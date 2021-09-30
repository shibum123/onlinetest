package com.catlin.cargo.controller
{
	import com.catlin.cargo.ApplicationFacade;
	import com.catlin.cargo.bundles.RB_ui;
	import com.catlin.cargo.model.core.brokercontact.BrokerContact;
	import com.catlin.cargo.model.proxy.BrokerProxy;
	
	import mx.controls.Alert;
	
	import org.granite.tide.events.TideResultEvent;
	import org.puremvc.as3.interfaces.INotification;
	
	public class SaveBrokerContactCommand extends BaseCommand { 
	
		override public function execute(notification:INotification):void {
			tideContext.brokerService.saveBrokerContact(notification.getBody(), onSaveBrokerContact, onRemoteFault);
		}

		private function onSaveBrokerContact(event:TideResultEvent):void {
			sendNotification(ApplicationFacade.LOAD_BROKER_OFFICE, (event.result as BrokerContact).brokerOffice);
			(facade.retrieveProxy(BrokerProxy.NAME) as BrokerProxy).listBrokerOfficesForUser();
			Alert.show(rm.getString(RB_ui.RB_NAME, RB_ui.SAVE_BROKER_CONTACT_SUCCESS_MESSAGE),
				rm.getString(RB_ui.RB_NAME, RB_ui.SAVE_BROKER_CONTACT_SUCCESS_TITLE));			
		}
	}
}