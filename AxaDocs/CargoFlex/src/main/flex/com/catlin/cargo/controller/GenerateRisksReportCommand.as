package com.catlin.cargo.controller {
	import com.catlin.cargo.model.core.risk.report.RiskReportResult;
	import com.catlin.cargo.model.proxy.ReportsProxy;
	
	import org.granite.tide.events.TideResultEvent;
	import org.puremvc.as3.interfaces.INotification;

	public class GenerateRisksReportCommand extends BaseCommand {
		public function GenerateRisksReportCommand() {
		}

		override public function execute(notification:INotification):void {
			tideContext.riskReportService.generateReportNativeSQL(notification.getBody(), onReportComplete, onRemoteFault);
		}

		private function onReportComplete(event:TideResultEvent):void {
			var result:RiskReportResult=event.result as RiskReportResult;
			(facade.retrieveProxy(ReportsProxy.NAME) as ReportsProxy).updateReportResultList(result);
		}
	}
}
