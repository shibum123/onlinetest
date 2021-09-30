package com.catlin.cargo.controller {
	
	import com.catlin.cargo.ApplicationFacade;
	import com.catlin.cargo.bundles.RB_ui;
	import com.catlin.cargo.view.address.PostcodeLookupForm;
	import com.catlin.cargo.view.address.PostcodeLookupMediator;
	import com.catlin.cargo.view.address.vo.PostCodeLookupFormVO;
	
	import mx.collections.ArrayCollection;
	import mx.controls.Alert;
	
	import org.granite.tide.events.TideFaultEvent;
	import org.granite.tide.events.TideResultEvent;
	import org.puremvc.as3.interfaces.IMediator;
	import org.puremvc.as3.interfaces.INotification;

	public class PostcodeLookupCommand extends BaseCommand {

		public function PostcodeLookupCommand() {
		}

		override public function execute(notification:INotification):void {
			data = notification.getBody() as Object;
			tideContext.postcodeLookupService.lookupIntl(
				data.code as String, 
				data.countryIsoCode as String, 
				data.hasOwnProperty("parent") ? data.parent.id as String : "", 
				onLookup, 
				onRemoteFault);
		}
		
		private function onLookup(event:TideResultEvent):void {
			var response:XML = XML(event.result as String);
			
			var addresses:ArrayCollection = new ArrayCollection();
			var countryIsoCode:String = data.countryIsoCode as String;
			
			var i:int = 0;
			var totItems:int = 0;

			totItems = response.Row.length();
			for each (var item:Object in response.Row) {
				addresses.addItem(
					new PostCodeLookupFormVO(
						item.Id.valueOf(),
						item.Text.valueOf(),
						countryIsoCode,
						data.code as String,
						item.Description.valueOf(),
						item.Next.valueOf()
					)
				);
			}

			if (totItems == 0 ) {
				var postcodeLabel:String = rm.getString(RB_ui.RB_NAME, RB_ui.POSTAL_CODE(countryIsoCode));
				Alert.show(rm.getString(RB_ui.RB_NAME, RB_ui.POSTCODELOOKUP_ERROR_NOADDRESSFOUND_MESSAGE, [postcodeLabel]));
				return;
			}
			
			var currentData:PostCodeLookupFormVO = null;
			var postcodeLookupMediator:PostcodeLookupMediator = null;
			
			if (data.hasOwnProperty("parent")) {
				currentData = data.parent as PostCodeLookupFormVO;
				currentData.children.removeAll();
				for each (var child:PostCodeLookupFormVO in addresses)
					currentData.children.addItem(child);
					
			} else {
				postcodeLookupMediator = ApplicationFacade.openPopUpWindow(PostcodeLookupForm, PostcodeLookupMediator) as PostcodeLookupMediator;			
				currentData = new PostCodeLookupFormVO("", "", countryIsoCode, data.code as String);
				currentData.parent = null;
				currentData.children = addresses;
			}
			
			if (!postcodeLookupMediator) {
				if (!ApplicationFacade.getInstance().hasMediator(PostcodeLookupMediator.NAME)) {
					ApplicationFacade.getInstance().registerMediator(PostcodeLookupMediator as IMediator);
				} else {
					postcodeLookupMediator = ApplicationFacade.getInstance().retrieveMediator(PostcodeLookupMediator.NAME) as PostcodeLookupMediator;
				}
			}
			
			postcodeLookupMediator.setModel(currentData);
		}
		
		override protected function onRemoteFault(event:TideFaultEvent):void {
			switch (event.fault.faultCode) {
				case "PostCodeLookupException.Call.Failed":
					var xData:XML    = XML(event.fault.faultString);
					var errorCode:String = xData.Row[0].Error;
					var message:String = "";
					switch (errorCode) {
						case "1005":
							message = rm.getString(RB_ui.RB_NAME, RB_ui.POSTCODELOOKUP_ERROR_RESPONSE_ERROR1005);
							break;
						default:
							message = rm.getString(RB_ui.RB_NAME, RB_ui.POSTCODELOOKUP_ERROR_RESPONSE_GENERAL);
							break;
					}
					Alert.show(message, rm.getString(RB_ui.RB_NAME, RB_ui.POSTCODELOOKUP_ERROR_RESPONSE_TITLE));
					break;
				default:
					super.onRemoteFault(event);
			}
		}		
	}
}