package com.catlin.cargo.controller {
	import com.catlin.cargo.ApplicationFacade;
	import com.catlin.cargo.model.core.risk.Risk;
	import com.catlin.cargo.model.core.risk.TriaInsuranceStatus;
	import com.catlin.cargo.model.proxy.HistoryProxy;
	
	import org.granite.tide.events.TideResultEvent;
	import org.puremvc.as3.interfaces.INotification;

	public class UpdateTriaInsuranceCommand extends BaseCommand {
		public function UpdateTriaInsuranceCommand() {
		}

		override public function execute(notification:INotification):void {
			var quote:Risk=notification.getBody().quote as Risk;
			var triaResponse:TriaInsuranceStatus=notification.getBody().triaResponse as TriaInsuranceStatus;
			tideContext.quoteService.updateTriaInsurance(quote.sid, triaResponse, onRiskUpdated,
				onRemoteFault);
		}
		
		private function onRiskUpdated(event:TideResultEvent):void {
			var quote:Risk = event.result as Risk;
			quote.hasAnsweredTriaInsurance  = true;
			
			(facade.retrieveProxy(HistoryProxy.NAME) as HistoryProxy).listHistory(quote.sid);
			sendNotification(ApplicationFacade.RISK_MERGED, quote);
			sendNotification(ApplicationFacade.REFRESH_ALL_RISKS);
			sendNotification(ApplicationFacade.ACCEPT_QUOTE_AFTER_UPDATE);
		}
	}
}
