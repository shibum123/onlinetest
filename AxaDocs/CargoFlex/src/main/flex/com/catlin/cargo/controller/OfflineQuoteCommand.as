package com.catlin.cargo.controller {
	
	import com.catlin.cargo.ApplicationFacade;
	import com.catlin.cargo.model.core.risk.Risk;
	import com.catlin.cargo.model.proxy.HistoryProxy;
	
	import org.granite.tide.events.TideResultEvent;
	import org.puremvc.as3.interfaces.INotification;

	public class OfflineQuoteCommand extends BaseCommand {

		public function OfflineQuoteCommand() {
		}

		override public function execute(notification:INotification):void {
			tideContext.quoteService.handleOffline(notification.getBody().sid, onOfflineQuote, onRemoteFault);
		}
		
		private function onOfflineQuote(event:TideResultEvent):void {
			var quote:Risk = event.result as Risk;
			(facade.retrieveProxy(HistoryProxy.NAME) as HistoryProxy).listHistory(quote.sid);
			sendNotification(ApplicationFacade.RISK_MERGED, quote);
			sendNotification(ApplicationFacade.REFRESH_ALL_RISKS);
		}
	}
}