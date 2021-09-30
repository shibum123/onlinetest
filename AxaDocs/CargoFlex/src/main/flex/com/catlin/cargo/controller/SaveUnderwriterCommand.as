package com.catlin.cargo.controller {
	import com.catlin.cargo.ApplicationFacade;
	import com.catlin.cargo.bundles.RB_ui;
	import com.catlin.cargo.model.proxy.BrokerProxy;
	
	import mx.controls.Alert;
	
	import org.granite.tide.events.TideResultEvent;
	import org.puremvc.as3.interfaces.INotification;

	public class SaveUnderwriterCommand extends BaseCommand {

		override public function execute(notification:INotification):void {
			tideContext.brokerService.saveUnderwriter(notification.getBody(), onSaveUnderwriter, onRemoteFault);
		}

		private function onSaveUnderwriter(event:TideResultEvent):void {
			sendNotification(ApplicationFacade.LOAD_UNDERWRITER, event.result);
			(facade.retrieveProxy(BrokerProxy.NAME) as BrokerProxy).listUnderwriters();
			
			Alert.show(rm.getString(RB_ui.RB_NAME, RB_ui.SAVE_UNDERWRITER_SUCCESS_MESSAGE), 
				rm.getString(RB_ui.RB_NAME, RB_ui.SAVE_UNDERWRITER_SUCCESS_TITLE));
		}
	}
}
