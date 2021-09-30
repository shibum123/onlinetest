package com.catlin.cargo.controller {
	import com.catlin.cargo.ApplicationFacade;
	
	import org.granite.tide.events.TideResultEvent;
	import org.puremvc.as3.interfaces.INotification;

	public class DetermineMtaActionsCommand extends BaseCommand {

		override public function execute(notification:INotification):void {
			tideContext.riskService.isMtaAllowed(notification.getBody(), onSuccess, onRemoteFault);
		}

		private function onSuccess(event:TideResultEvent):void {
			var allowed:Boolean = event.result as Boolean;
			sendNotification(ApplicationFacade.MTA_ACTIONS_DETERMINED, allowed);
		}
	}
}