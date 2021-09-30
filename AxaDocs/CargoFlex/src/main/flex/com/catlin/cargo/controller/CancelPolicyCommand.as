package com.catlin.cargo.controller {
	
	import com.catlin.cargo.ApplicationFacade;
	import com.catlin.cargo.model.core.risk.Risk;
	import com.catlin.cargo.model.proxy.HistoryProxy;
	
	import mx.formatters.DateFormatter;
	
	import org.granite.tide.events.TideResultEvent;
	import org.puremvc.as3.interfaces.INotification;

	public class CancelPolicyCommand extends BaseCommand {

		public function CancelPolicyCommand() {
		}

		override public function execute(notification:INotification):void {
			var o:Object = notification.getBody();
			var df:DateFormatter = new DateFormatter();
			df.formatString="YYYYMMDD";
			tideContext.quoteService.cancelPolicy(o.risk.sid, df.format(o.effectiveDate), o.comments, onCancelPolicy, onRemoteFault);
		}
		
		private function onCancelPolicy(event:TideResultEvent):void {
			var risk:Risk = event.result as Risk;
			(facade.retrieveProxy(HistoryProxy.NAME) as HistoryProxy).listHistory(risk.sid);
			sendNotification(ApplicationFacade.RISK_MERGED, risk);
			sendNotification(ApplicationFacade.REFRESH_ALL_RISKS);
		}
	}
}