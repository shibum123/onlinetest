package com.catlin.cargo.controller {
	import com.catlin.cargo.ApplicationFacade;
	import com.catlin.cargo.model.core.risk.Risk;
	import com.catlin.cargo.model.proxy.HistoryProxy;
	
	import org.granite.tide.events.TideResultEvent;
	import org.puremvc.as3.interfaces.INotification;

	public class AcceptQuoteCommand extends BaseCommand {

		override public function execute(notification:INotification):void {
			var quote:Risk = notification.getBody() as Risk;
			if (quote.isCancellation()) {
				tideContext.quoteService.acceptCancellationQuote(quote.reference, onAcceptQuote, onRemoteFault);
			} else {
				tideContext.quoteService.acceptQuote(notification.getBody(), onAcceptQuote, onRemoteFault);
			}
		}

		private function onAcceptQuote(event:TideResultEvent):void {
			var risk:Risk = event.result as Risk;
			(facade.retrieveProxy(HistoryProxy.NAME) as HistoryProxy).listHistory(risk.sid);
			sendNotification(ApplicationFacade.RISK_MERGED, event.result);
			sendNotification(ApplicationFacade.REFRESH_ALL_RISKS);
		}
	}
}