package com.catlin.cargo.view.leftarea {
	import com.catlin.cargo.ApplicationFacade;
	import com.catlin.cargo.model.core.risk.Risk;
	import com.catlin.cargo.model.core.risk.RiskSearchResult;
	import com.catlin.cargo.model.locale.LocaleFormat;
	
	import mx.binding.utils.BindingUtils;
	import mx.controls.dataGridClasses.DataGridColumn;
	import mx.formatters.DateFormatter;
	import mx.utils.ObjectUtil;
	
	import org.puremvc.as3.interfaces.IMediator;
	import org.puremvc.as3.patterns.mediator.Mediator;

	public class RiskListMediator extends Mediator implements IMediator {
		
		public static const NAME:String = 'RiskListMediator';
		private var dateFormat:DateFormatter = new DateFormatter();
		private var useReferralDate:Boolean;
		
		public function RiskListMediator(viewComponent:Object, showQuoteDate:Boolean = false, useReferralDate:Boolean = false) {
			super(NAME + viewComponent.toString(), viewComponent);
			this.useReferralDate = useReferralDate;
			
			dateFormat.formatString = ApplicationFacade.getInstance().localeFormat.dateShort4Year2MonthDay; //"DD/MM/YYYY";
			riskListForm.dgcPolicyStartDate.labelFunction = formatPolicyStartDate;
			riskListForm.dgcPolicyStartDate.sortCompareFunction = sortPolicyStartDate;
			riskListForm.dgcPolicyStartDate.visible = !useReferralDate;
			
			riskListForm.dgcQuoteDate.visible = showQuoteDate || useReferralDate;
			riskListForm.dgcQuoteDate.labelFunction = formatQuoteDate;
			riskListForm.dgcQuoteDate.sortCompareFunction = sortQuoteDate;
			
			if (useReferralDate) {
				// For referrals, relabel the quote date column (it's still bound to the quoteDate property).
				riskListForm.dgcQuoteDate.headerText = "Referral Date";
				dateFormat.formatString = ApplicationFacade.getInstance().localeFormat.dateTimeShort4Year; // "DD/MM/YYYY JJ:NN";				
				riskListForm.dgcOwner.visible = true;
				riskListForm.dgcOwner.dataField = "owner";
			}
			
            riskListForm.dgcReference.dataField = "reference";
            
            riskListForm.dgcStatus.labelFunction = formatStatus;
            
            riskListForm.dgcBrokerOffice.dataField = "brokerOfficeName";
            
            riskListForm.dgcTownCity.dataField = "brokerTown";
			
			riskListForm.dgcInsured.dataField = "insuredName";
			BindingUtils.bindSetter(updateDateFormat, ApplicationFacade.getInstance(), "localeFormat");
		}
		
		public function updateDateFormat(localeFormat:LocaleFormat):void {
			dateFormat.formatString = localeFormat.dateShort4Year2MonthDay; //"DD/MM/YYYY";
			if (useReferralDate) {
				dateFormat.formatString = localeFormat.dateTimeShort4Year;
			}
		}

		public function formatPolicyStartDate(item:Object, column:DataGridColumn):String {
			return dateFormat.format((item as RiskSearchResult).policyStartDateAsDate);		
		}
			
		public function formatQuoteDate(item:Object, column:DataGridColumn):String {
			return dateFormat.format((item as RiskSearchResult).quoteDate);			
		}
		
		public function sortQuoteDate(itemA:Object, itemB:Object):int {
			return ObjectUtil.dateCompare(itemA.quoteDate, itemB.quoteDate);
		}
		
		public function sortPolicyStartDate(itemA:Object, itemB:Object):int {
			return ObjectUtil.dateCompare(itemA.policyStartDateAsDate, itemB.policyStartDateAsDate);
		}

		private function formatStatus(item:Object, column:DataGridColumn):String {
			var rsr:RiskSearchResult = item as RiskSearchResult;
			return Risk.getFormattedStatus(rsr.status, rsr.renewal);
		}

		private function get riskListForm ():RiskList {
			return viewComponent as RiskList;
		}
	}
}