package com.catlin.cargo.controller {

	import com.catlin.cargo.bundles.RB_ui;

	import mx.controls.Alert;

	import org.granite.tide.events.TideResultEvent;
	import org.puremvc.as3.interfaces.INotification;

	public class PostcodeFetchCommand extends BaseCommand {

		public static const POSTCODE_FETCH_COMPLETE:String="postcodeFetchComplete";

		public function PostcodeFetchCommand() {
		}

		override public function execute(notification:INotification):void {
			data=notification.getBody() as Object;
			tideContext.postcodeLookupService.fetchIntl(data.code as String, onLookup, onRemoteFault);
		}

		private function onLookup(event:TideResultEvent):void {
			var response:XML=XML(event.result as String);
			var totItems:int=response.Row.length();
			
			if (totItems == 0) {
				var postcodeLabel:String=rm.getString(RB_ui.RB_NAME, RB_ui.POSTAL_CODE(data.countryIsoCode));
				Alert.show(rm.getString(RB_ui.RB_NAME, RB_ui.POSTCODEFETCH_ERROR_NOADDRESSFOUND_MESSAGE, [postcodeLabel]));
				return;
			}
			
			var obj:Object=
				{	line1: response.Row[0].Line1.valueOf(),
					line2: response.Row[0].Line2.valueOf(),
					line3: response.Row[0].Line3.valueOf(),
					postTown: response.Row[0].AdminAreaName.valueOf(),
					county: response.Row[0].City.valueOf(),
					postcode: response.Row[0].PostalCode.valueOf(),
					company: response.Row[0].Company.valueOf(),
					province: response.Row[0].ProvinceName.valueOf(),
					provinceCode: response.Row[0].ProvinceCode.valueOf()
				};
			sendNotification(POSTCODE_FETCH_COMPLETE, obj);			

		}
	}
}
