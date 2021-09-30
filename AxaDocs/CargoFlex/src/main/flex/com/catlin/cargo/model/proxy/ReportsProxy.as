package com.catlin.cargo.model.proxy
{
	import com.catlin.cargo.ApplicationFacade;
	import com.catlin.cargo.model.core.risk.RiskReportSearchCriteria;
	import com.catlin.cargo.model.core.risk.report.RiskReportResult;
	
	import flash.utils.Dictionary;
	
	import mx.collections.ArrayCollection;
	
	import org.puremvc.as3.interfaces.IProxy;

	public class ReportsProxy extends BaseProxy implements IProxy {
		
		public static const NAME:String = 'ReportsProxy';
		public static const GENERATE_RISKS_REPORT_COMPLETE:String="GENERATE_RISKS_REPORT_COMPLETE";		
		
		[Bindable]
		public var reportResultList:ArrayCollection;
		
		private var pendingCalls:Dictionary;		
		
		public function ReportsProxy() {
			super( NAME );
			reportResultList = new ArrayCollection();
			pendingCalls = new Dictionary();
		}

		public function generateReport(params:RiskReportSearchCriteria):void {
			ApplicationFacade.getInstance().sendNotification(ApplicationFacade.GENERATE_RISKS_REPORT, params);
		}
		
		public function updateReportResultList(results:RiskReportResult):void {
			reportResultList.removeAll();
			
			if (results.reportResultData && results.reportResultData.length)
				reportResultList.addAll(results.reportResultData);
			
			reportResultList.refresh();
			ApplicationFacade.getInstance().sendNotification(ReportsProxy.GENERATE_RISKS_REPORT_COMPLETE, results);  
		}
		
		public function isReportEmpty():Boolean {
			return (reportResultList && reportResultList.length > 0) ? false : true;
		}
	}
}