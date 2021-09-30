package com.catlin.cargo.controller {

	import com.catlin.cargo.ApplicationFacade;
	import com.catlin.cargo.model.core.risk.ReferralRuleFailure;
	import com.catlin.cargo.model.core.risk.Risk;
	import com.catlin.cargo.model.core.risk.RiskStatus;
	import com.catlin.cargo.model.proxy.HistoryProxy;
	
	import org.granite.tide.events.TideResultEvent;
	import org.puremvc.as3.interfaces.INotification;

	public class QuoteRiskCommand extends BaseCommand {

		private var classPlaceholder:ReferralRuleFailure;

		public function QuoteRiskCommand() {
		}

		override public function execute(notification:INotification):void {
			ApplicationFacade.getInstance().setQuoting(true);
			var quote:Risk = notification.getBody() as Risk;
			tideContext.quoteService.quoteRisk(notification.getBody(), onQuoteRisk, onRemoteFault);
		}

		private function onQuoteRisk(event:TideResultEvent):void {
			var quote:Risk = event.result as Risk;
			quote.updateTotals();
			// workaround - does not seem to set to null when merged into session.
			if (quote.status.equals(RiskStatus.REFERRED)) {
				quote.scheduleDocument = null;
			}
			(facade.retrieveProxy(HistoryProxy.NAME) as HistoryProxy).listHistory(quote.sid);
			sendNotification(ApplicationFacade.RISK_MERGED, quote);
			sendNotification(ApplicationFacade.REFRESH_ALL_RISKS);
		}
	}
}