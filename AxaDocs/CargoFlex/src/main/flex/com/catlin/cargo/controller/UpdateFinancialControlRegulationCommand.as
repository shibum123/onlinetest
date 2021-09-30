package com.catlin.cargo.controller
{
	
	import com.catlin.cargo.ApplicationFacade;
	import com.catlin.cargo.model.core.risk.Risk;
	import com.catlin.cargo.model.proxy.HistoryProxy;
	
	import org.granite.tide.events.TideResultEvent;
	import org.puremvc.as3.interfaces.INotification;
	
	
	public class UpdateFinancialControlRegulationCommand extends BaseCommand  
	{
		public function UpdateFinancialControlRegulationCommand()
		{
		}

		override public function execute(notification:INotification):void {
			var quote:Risk = notification.getBody() as Risk;
			tideContext.quoteService.updateFinancialControlRegulation(quote.sid ,quote.consumerBusinessControl, onRiskUpdated, onRemoteFault);
		}
		
		private function onRiskUpdated(event:TideResultEvent):void {
			var quote:Risk = event.result as Risk;

			(facade.retrieveProxy(HistoryProxy.NAME) as HistoryProxy).listHistory(quote.sid);
			sendNotification(ApplicationFacade.RISK_MERGED, quote);
			sendNotification(ApplicationFacade.REFRESH_ALL_RISKS);
			if (quote.documentSetChanged == true) {
				sendNotification(ApplicationFacade.RISK_DOCUMENT_MODIFIED_ALERT, quote);
			} else {
				sendNotification(ApplicationFacade.ACCEPT_QUOTE_AFTER_UPDATE);
			}
		}
	}
}