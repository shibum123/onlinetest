package com.catlin.cargo.view.leftarea {
	import com.catlin.cargo.ApplicationFacade;
	import com.catlin.cargo.model.core.risk.Risk;
	import com.catlin.cargo.model.core.risk.RiskSearchResult;
	
	import mx.binding.utils.BindingUtils;
	import mx.controls.dataGridClasses.DataGridColumn;
	import mx.formatters.DateFormatter;
	
	import org.puremvc.as3.interfaces.IMediator;
	import org.puremvc.as3.patterns.mediator.Mediator;

	public class RenewalListMediator extends Mediator implements IMediator {
		
		public static const NAME:String = 'RenewalListMediator';
		private static const MILLISECONDS_IN_DAY:int = 1000 * 60 * 60 * 24;
		private var dateFormat:DateFormatter = new DateFormatter();
		
		public function RenewalListMediator(viewComponent:RenewalList) {
			super(NAME, viewComponent);
			
			dateFormat.formatString = ApplicationFacade.getInstance().localeFormat.dateShort4Year2MonthDay; // "DD/MM/YYYY";
			BindingUtils.bindProperty(dateFormat, "formatString", ApplicationFacade.getInstance(), ["localeFormat", "dateShort4Year2MonthDay"]);
			
			renewalList.dgcDaysToIncept.labelFunction = formatDaysToIncept;
			
			renewalList.dgcDate.labelFunction = formatDate;
			
			renewalList.dgcInsured.dataField = "insuredName";
			
            renewalList.dgcReference.dataField = "reference";
            
            renewalList.dgcStatus.labelFunction = formatStatus;
            
            renewalList.dgcBrokerOffice.dataField = "brokerOfficeName";
            
            renewalList.dgcTownCity.dataField = "brokerTown";
		}

		private function formatStatus(item:Object, column:DataGridColumn):String {
			var rsr:RiskSearchResult = item as RiskSearchResult;
			return Risk.getFormattedStatus(rsr.status, rsr.renewal);
		}

		private function formatDaysToIncept(item:Object, column:DataGridColumn):String {
			var today:Date = new Date();
			return String(Math.floor((((item as RiskSearchResult).policyStartDateAsDate).time - today.time) / MILLISECONDS_IN_DAY));
		}

		private function formatDate(item:Object, column:DataGridColumn):String {
			return dateFormat.format((item as RiskSearchResult).policyStartDateAsDate);
		}

		private function get renewalList ():RenewalList {
			return viewComponent as RenewalList;
		}
	}
}