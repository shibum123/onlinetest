package com.catlin.cargo.view.reports.charts {
	import com.catlin.cargo.model.core.risk.report.RiskReportResult;
	import com.catlin.cargo.model.proxy.ReportsProxy;
	import com.catlin.cargo.view.BaseMediator;
	
	import org.puremvc.as3.interfaces.INotification;

	public class ReportsChartsMediator extends BaseMediator {
		
		public static const NAME:String = 'ReportsChartsMediator';
		
		public function ReportsChartsMediator(mediatorName:String, viewComponent:ReportsCharts) {
			super(mediatorName, viewComponent);
		}

		public function get view():ReportsCharts {
			return viewComponent as ReportsCharts;
		}
		
		public function get chartRisksByStatusPie():ChartRisksByStatusPie {
			return view.chartRisksByStatusPie as ChartRisksByStatusPie;
		}
		
		public function get stats():ReportsResultStats {
			return view.stats as ReportsResultStats;
		}		
		
		public function get chartGrossPerMonthBars():ChartGrossPerMonthBars {
			return view.chartGrossPerMonthBars as ChartGrossPerMonthBars;
		}		

		override public function listNotificationInterests():Array {
			return [ReportsProxy.GENERATE_RISKS_REPORT_COMPLETE];
		}

		override public function handleNotification(note:INotification):void {
			switch (note.getName()) {
				case ReportsProxy.GENERATE_RISKS_REPORT_COMPLETE:
					updateChartsDataProvider(note);
					break;
			}
		}

		private function updateChartsDataProvider(note:INotification):void {
			
			var reportResult:RiskReportResult = note.getBody() as RiskReportResult;

			chartRisksByStatusPie.chartDataProvider = reportResult.chartDataRisksByStatus;
			chartGrossPerMonthBars.chartDataProvider = reportResult.chartDataGrossPerMonth;
			stats.totalRows = reportResult.reportResultData.length;
			
		}
	}
}
