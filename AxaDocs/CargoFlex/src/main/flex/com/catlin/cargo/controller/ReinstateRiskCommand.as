package com.catlin.cargo.controller {
	
	import com.catlin.cargo.ApplicationFacade;
	import com.catlin.cargo.model.core.risk.Risk;
	
	import org.granite.tide.events.TideResultEvent;
	import org.puremvc.as3.interfaces.INotification;

	public class ReinstateRiskCommand extends BaseCommand {

		public function ReinstateRiskCommand() {
		}

		override public function execute(notification:INotification):void {
			tideContext.riskService.reinstateRisk(notification.getBody().sid, onReinstateRisk, onRemoteFault);
		}
		
		private function onReinstateRisk(event:TideResultEvent):void {
			var risk:Risk = event.result as Risk;
			sendNotification(ApplicationFacade.RISK_MERGED, risk);
			sendNotification(ApplicationFacade.REFRESH_ALL_RISKS);
		}
	}
}