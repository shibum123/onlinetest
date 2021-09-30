package com.catlin.cargo.controller {

	import com.catlin.cargo.ApplicationFacade;
	import com.catlin.cargo.bundles.RB_ui;
	
	import mx.collections.ArrayCollection;
	import mx.controls.Alert;
	
	import org.granite.tide.events.TideFaultEvent;
	import org.granite.tide.events.TideResultEvent;
	import org.puremvc.as3.interfaces.INotification;

	public class SaveBrokerOfficeUsefulLinksCommand extends BaseCommand {

		override public function execute(notification:INotification):void {
			var params:Object=notification.getBody() as Object;
			tideContext.brokerService.saveBrokerOfficeUsefulLinks(params.sid, params.usefulLinks as ArrayCollection, onSaveBrokerOffice,
				onSaveBrokerOfficeFault);
		}

		private function onSaveBrokerOffice(event:TideResultEvent):void {
			sendNotification(ApplicationFacade.SAVE_BROKER_OFFICE_COMPLETE, event.result);
		}

		private function onSaveBrokerOfficeFault(event:TideFaultEvent):void {
			if (event.fault.faultCode == "Persistence.Error") {
				Alert.show(rm.getString(RB_ui.RB_NAME, RB_ui.SAVE_BROKER_OFFICE_ERROR_DUPLICATE_MESSAGE));
			} else {
				super.onRemoteFault(event);
			}
		}
	}
}