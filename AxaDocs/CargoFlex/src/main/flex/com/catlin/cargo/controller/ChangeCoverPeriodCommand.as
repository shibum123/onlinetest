package com.catlin.cargo.controller
{
	import com.catlin.cargo.ApplicationFacade;
	import com.catlin.cargo.model.core.risk.Risk;
	import com.catlin.cargo.model.core.risk.RiskStatus;
	import com.catlin.cargo.model.proxy.HistoryProxy;
	
	import org.granite.tide.events.TideResultEvent;
	import org.puremvc.as3.interfaces.INotification;

	public class ChangeCoverPeriodCommand extends BaseCommand
	{
		public function ChangeCoverPeriodCommand()
		{
			super();
		}
		
		override public function execute(notification:INotification):void {
			ApplicationFacade.getInstance().setQuoting(true);
			var o:Object = notification.getBody();
			tideContext.quoteService.createCoverPeriodMTAAndGetQuote(o.risk.sid, o.inceptionDate, o.expiryDate, o.consumerBusinessType, onQuoteRisk, onRemoteFault);
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
			sendNotification(ApplicationFacade.COVER_PERIOD_MTA_QUOTE_COMPLETE, quote);
			
			if (quote.documentSetChanged)
				sendNotification(ApplicationFacade.RISK_DOCUMENT_MODIFIED_ALERT, quote);
		}

	}
}
