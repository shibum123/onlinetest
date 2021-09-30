package com.catlin.cargo.controller {
	import com.catlin.cargo.ApplicationFacade;
	import com.catlin.cargo.model.core.risk.Risk;
	import com.catlin.cargo.model.proxy.HistoryProxy;

	import org.puremvc.as3.interfaces.INotification;

	public class DisplayQuoteCommand extends BaseCommand {

		public function DisplayQuoteCommand() {
		}

		override public function execute(notification:INotification):void {
			var quote:Risk = notification.getBody() as Risk;
			quote.updateTotals();
			(facade.retrieveProxy(HistoryProxy.NAME) as HistoryProxy).listHistory(quote.sid);
			sendNotification(ApplicationFacade.RISK_LOADED, quote);
		}
	}
}