package com.catlin.cargo.controller {
	
	import com.catlin.cargo.ApplicationFacade;
	import com.catlin.cargo.model.core.risk.Risk;
	import com.catlin.cargo.model.proxy.HistoryProxy;
	
	import org.granite.tide.events.TideResultEvent;
	import org.puremvc.as3.interfaces.INotification;

	public class DeclineRiskCommand extends BaseCommand {

		public function DeclineRiskCommand() {
		}

		override public function execute(notification:INotification):void {
			var o:Object = notification.getBody();
			tideContext.quoteService.declineRisk(o.risk.sid, o.comments, onDeclineRisk, onRemoteFault);
		}
		
		private function onDeclineRisk(event:TideResultEvent):void {
			var quote:Risk = event.result as Risk;
			(facade.retrieveProxy(HistoryProxy.NAME) as HistoryProxy).listHistory(quote.sid);
			sendNotification(ApplicationFacade.RISK_MERGED, quote);
			sendNotification(ApplicationFacade.REFRESH_ALL_RISKS);
		}
	}
}