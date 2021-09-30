package com.catlin.cargo.controller {
	
	import com.catlin.cargo.ApplicationFacade;
	import com.catlin.cargo.model.core.risk.Risk;
	import com.catlin.cargo.model.proxy.HistoryProxy;
	
	import org.granite.tide.events.TideResultEvent;
	import org.puremvc.as3.interfaces.INotification;

	public class SendToBrokerCommand extends BaseCommand {

		public function SendToBrokerCommand() {
		}

		override public function execute(notification:INotification):void {
			var o:Object = notification.getBody();
			tideContext.quoteService.sendToBroker(o.risk.sid, o.comments, onSendToBroker, onRemoteFault);
		}
		
		private function onSendToBroker(event:TideResultEvent):void {
			var quote:Risk = event.result as Risk;
			quote.updateTotals();
			(facade.retrieveProxy(HistoryProxy.NAME) as HistoryProxy).listHistory(quote.sid);
			sendNotification(ApplicationFacade.RISK_MERGED, quote);
			sendNotification(ApplicationFacade.REFRESH_ALL_RISKS);
		}
	}
}