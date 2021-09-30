package com.catlin.cargo.controller {
	import com.catlin.cargo.ApplicationFacade;
	
	import org.granite.tide.events.TideResultEvent;
	import org.puremvc.as3.interfaces.INotification;

	public class FindSupersedingRiskCommand extends BaseCommand {

		override public function execute(notification:INotification):void {
			if (notification.getBody() != null) {
				tideContext.riskService.getSupersedingRisk(notification.getBody(), onSuccess, onRemoteFault);
			}
		}

		private function onSuccess(event:TideResultEvent):void {
			if (event.result != null) {
				sendNotification(ApplicationFacade.SUPERSEDING_RISK_FOUND, event.result);
			}
		}
	}
}