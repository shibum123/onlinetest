package com.catlin.cargo.controller
{
	import com.catlin.cargo.ApplicationFacade;
	import com.catlin.cargo.bundles.RB_ui;
	import com.catlin.cargo.model.core.link.LinkUrl;
	
	import mx.controls.Alert;
	
	import org.granite.tide.events.TideFaultEvent;
	import org.granite.tide.events.TideResultEvent;
	import org.puremvc.as3.interfaces.INotification;

	public class SaveOrUpdateUsefulLinkCommand extends BaseCommand
	{

		override public function execute(notification:INotification):void {
			var link:LinkUrl = notification.getBody() as LinkUrl;
			tideContext.linkService.saveOrUpdateLinkUrl(link, onSaveOrUpdateLinkUrl, onSaveOrUpdateLinkUrlFault);
		}
		
		private function onSaveOrUpdateLinkUrl(event:TideResultEvent):void {
			sendNotification(ApplicationFacade.SAVE_OR_UPDATE_USEFUL_LINK_COMPLETE, event.result);
		}
		
		private function onSaveOrUpdateLinkUrlFault(event:TideFaultEvent):void {
			if (event.fault.faultCode == "Persistence.Error") {
				Alert.show(rm.getString(RB_ui.RB_NAME, RB_ui.USEFUL_LINKS_SAVE_ERROR_DUPLICATE_ID));				
			} else {
				super.onRemoteFault(event);
			}
		}		
	}
}