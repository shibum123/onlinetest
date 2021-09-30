package com.catlin.cargo.view.reports
{
	import com.catlin.cargo.ApplicationFacade;
	import com.catlin.cargo.bundles.RB_ui;
	import com.catlin.cargo.model.core.originatingoffice.OriginatingOfficeCode;
	import com.catlin.cargo.model.proxy.ReportsProxy;
	import com.catlin.cargo.view.BaseMediator;
	import com.catlin.cargo.view.formatters.DataFormatters;
	
	import mx.controls.dataGridClasses.DataGridColumn;
	
	import org.puremvc.as3.interfaces.IMediator;

	public class ReportsGridMediator  extends BaseMediator implements IMediator { 
		
		public static const NAME:String = 'ReportsGridMediator';

		private var reportsProxy:ReportsProxy;
		
		public function ReportsGridMediator(mediatorName:String, viewComponent:ReportsGrid) {

			super(mediatorName, viewComponent);
			reportsProxy = facade.retrieveProxy(ReportsProxy.NAME) as ReportsProxy;
			view.riskGrid.dataProvider = reportsProxy.reportResultList;
			initializeReportsGridColumns();
		}

		public function get view ():ReportsGrid {
			return viewComponent as ReportsGrid;
		}

		private function initializeReportsGridColumns():void {
		
			var columns:Array = view.riskGrid.columns;
			
			view.riskGrid.horizontalScrollPolicy="on";
			
			var dgcYoA:DataGridColumn = new DataGridColumn();
			dgcYoA.dataField="yoa";
			dgcYoA.headerText=this.rm.getString(RB_ui.RB_NAME, RB_ui.REPORTS_GRID_HEADER_GRID_HEADER_YOA);
			columns.push(dgcYoA);

			var dgcInceptionMonth:DataGridColumn = new DataGridColumn();
			dgcInceptionMonth.dataField="inceptionmonth";
			dgcInceptionMonth.headerText=this.rm.getString(RB_ui.RB_NAME, RB_ui.REPORTS_GRID_HEADER_GRID_HEADER_INCEPTION_MONTH);
			columns.push(dgcInceptionMonth);
			
			var dgcPolicyStartDate:DataGridColumn = new DataGridColumn();
			dgcPolicyStartDate.dataField="policystartdate";
			dgcPolicyStartDate.labelFunction = formatDate;
			dgcPolicyStartDate.headerText=this.rm.getString(RB_ui.RB_NAME, RB_ui.REPORTS_GRID_HEADER_GRID_HEADER_POLICY_START_DATE);
			columns.push(dgcPolicyStartDate);
			
			var dgcPolicyEndDate:DataGridColumn = new DataGridColumn();
			dgcPolicyEndDate.dataField="policyenddate";
			dgcPolicyEndDate.labelFunction = formatDate;
			dgcPolicyEndDate.headerText=this.rm.getString(RB_ui.RB_NAME, RB_ui.REPORTS_GRID_HEADER_GRID_HEADER_POLICY_END_DATE);
			columns.push(dgcPolicyEndDate);
			
			var dgcInceptionDate:DataGridColumn = new DataGridColumn();
			dgcInceptionDate.dataField="inceptiondate";
			dgcInceptionDate.labelFunction = formatDate;
			dgcInceptionDate.headerText=this.rm.getString(RB_ui.RB_NAME, RB_ui.REPORTS_GRID_HEADER_GRID_HEADER_INCEPTION_DATE);			
			columns.push(dgcInceptionDate);		
			
			var dgcPolicyType:DataGridColumn = new DataGridColumn();
			dgcPolicyType.dataField="policytype";
			dgcPolicyType.headerText=this.rm.getString(RB_ui.RB_NAME, RB_ui.REPORTS_GRID_HEADER_GRID_HEADER_POLICY_TYPE);
			columns.push(dgcPolicyType);
			
			var dgcStatus:DataGridColumn = new DataGridColumn();
			dgcStatus.dataField="status";
			dgcStatus.headerText=this.rm.getString(RB_ui.RB_NAME, RB_ui.REPORTS_GRID_HEADER_GRID_HEADER_STATUS)
			columns.push(dgcStatus);

			var dgcInsuredName:DataGridColumn = new DataGridColumn();			
			dgcInsuredName.dataField="insuredname";
			dgcInsuredName.headerText=this.rm.getString(RB_ui.RB_NAME, RB_ui.REPORTS_GRID_HEADER_GRID_HEADER_INSURED_NAME);			
			columns.push(dgcInsuredName);		

			var dgcReference:DataGridColumn = new DataGridColumn();
			dgcReference.dataField="reference";
			dgcReference.headerText=this.rm.getString(RB_ui.RB_NAME, RB_ui.REPORTS_GRID_HEADER_GRID_HEADER_REFERENCE);
			columns.push(dgcReference);

			var dgcPolicyReference:DataGridColumn = new DataGridColumn();			
			dgcPolicyReference.dataField="policyreference";
			dgcPolicyReference.headerText=this.rm.getString(RB_ui.RB_NAME, RB_ui.REPORTS_GRID_HEADER_GRID_HEADER_POLICY_REFERENCE);
			columns.push(dgcPolicyReference);

			var dgcBrokerOfficeName:DataGridColumn = new DataGridColumn();
			dgcBrokerOfficeName.dataField="brokerofficename";
			dgcBrokerOfficeName.headerText=this.rm.getString(RB_ui.RB_NAME, RB_ui.REPORTS_GRID_HEADER_GRID_HEADER_BROKER_OFFICE_NAME);
			columns.push(dgcBrokerOfficeName);

			var dgcBrokerContactName:DataGridColumn = new DataGridColumn();
			dgcBrokerContactName.dataField="brokercontactname";
			dgcBrokerContactName.headerText=this.rm.getString(RB_ui.RB_NAME, RB_ui.REPORTS_GRID_HEADER_GRID_HEADER_BROKER_CONTACT_NAME);
			columns.push(dgcBrokerContactName);
			
			var dgcInceptedBy:DataGridColumn = new DataGridColumn();
			dgcInceptedBy.dataField="inceptedby";
			dgcInceptedBy.headerText=this.rm.getString(RB_ui.RB_NAME, RB_ui.REPORTS_GRID_HEADER_GRID_HEADER_INCEPTED_BY);
			columns.push(dgcInceptedBy);

			var dgcCurrency:DataGridColumn = new DataGridColumn();
			dgcCurrency.dataField="currency";
			dgcCurrency.headerText=this.rm.getString(RB_ui.RB_NAME, RB_ui.REPORTS_GRID_HEADER_GRID_HEADER_CURRENCY);
			columns.push(dgcCurrency);

			var dgcGrossPremium:DataGridColumn = new DataGridColumn();
			dgcGrossPremium.dataField="grossPremiumStr";
			dgcGrossPremium.headerText=this.rm.getString(RB_ui.RB_NAME, RB_ui.REPORTS_GRID_HEADER_GRID_HEADER_GROSS_PREMIUM);
			columns.push(dgcGrossPremium);

			var dgcCommission:DataGridColumn = new DataGridColumn();
			dgcCommission.dataField="commissionStr";			
			dgcCommission.headerText=this.rm.getString(RB_ui.RB_NAME, RB_ui.REPORTS_GRID_HEADER_GRID_HEADER_COMMISSION);
			columns.push(dgcCommission);

			var dgcCommissionPercentage:DataGridColumn = new DataGridColumn();
			dgcCommissionPercentage.dataField="commissionPercentageStr";
			dgcCommissionPercentage.headerText=this.rm.getString(RB_ui.RB_NAME, RB_ui.REPORTS_GRID_HEADER_GRID_HEADER_COMMISSION_PERCENTAGE);
			columns.push(dgcCommissionPercentage);

			// US Specific columns.
			if (ApplicationFacade.getInstance().sessionOriginatingOfficeCode == OriginatingOfficeCode.US) {
				var dgcTria:DataGridColumn = new DataGridColumn();
				dgcTria.dataField="triaStr";
				dgcTria.headerText=this.rm.getString(RB_ui.RB_NAME, RB_ui.REPORTS_GRID_HEADER_GRID_HEADER_TRIA);
				columns.push(dgcTria);
			}

			var dgcNetPremium:DataGridColumn = new DataGridColumn();
			dgcNetPremium.dataField="netPremiumStr";
			dgcNetPremium.headerText=this.rm.getString(RB_ui.RB_NAME, RB_ui.REPORTS_GRID_HEADER_GRID_HEADER_NET_PREMIUM);
			columns.push(dgcNetPremium);

			var dgcTax:DataGridColumn = new DataGridColumn();
			dgcTax.dataField="taxStr";
			dgcTax.headerText=this.rm.getString(RB_ui.RB_NAME, RB_ui.REPORTS_GRID_HEADER_GRID_HEADER_TAX);
			columns.push(dgcTax);

			var dgcInceptionYear:DataGridColumn = new DataGridColumn();
			dgcInceptionYear.dataField="inceptionyear";
			dgcInceptionYear.headerText=this.rm.getString(RB_ui.RB_NAME, RB_ui.REPORTS_GRID_HEADER_GRID_HEADER_INCEPTION_YEAR);
			columns.push(dgcInceptionYear);

			// US Specific columns.
			if (ApplicationFacade.getInstance().sessionOriginatingOfficeCode == OriginatingOfficeCode.US) {
				var dgcTriaOffered:DataGridColumn = new DataGridColumn();
				dgcTriaOffered.dataField="triaoffered";
				dgcTriaOffered.headerText=this.rm.getString(RB_ui.RB_NAME, RB_ui.REPORTS_GRID_HEADER_GRID_HEADER_TRIA_OFFERED);
				columns.push(dgcTriaOffered);

				var dgcSurplusLineOfficeName:DataGridColumn = new DataGridColumn();
				dgcSurplusLineOfficeName.dataField="surpluslineofficename";
				dgcSurplusLineOfficeName.headerText=this.rm.getString(RB_ui.RB_NAME, RB_ui.REPORTS_GRID_HEADER_GRID_HEADER_SURPLUS_OFFICE_NAME);
				columns.push(dgcSurplusLineOfficeName);

				var dgcSurplusLineContactName:DataGridColumn = new DataGridColumn();
				dgcSurplusLineContactName.dataField="surpluslinecontactname";
				dgcSurplusLineContactName.headerText=this.rm.getString(RB_ui.RB_NAME, RB_ui.REPORTS_GRID_HEADER_GRID_HEADER_SURPLUS_CONTACT_NAME);
				columns.push(dgcSurplusLineContactName);	

				var dgcSurplusLineLicenseState:DataGridColumn = new DataGridColumn();
				dgcSurplusLineLicenseState.dataField="surpluslinelicensestate";
				dgcSurplusLineLicenseState.headerText=this.rm.getString(RB_ui.RB_NAME, RB_ui.REPORTS_GRID_HEADER_GRID_HEADER_SURPLUS_LICENSE_STATE);
				columns.push(dgcSurplusLineLicenseState);

				var dgcSurplusBrokerLineLicense:DataGridColumn = new DataGridColumn();
				dgcSurplusBrokerLineLicense.dataField="surpluslinelicenseno";
				dgcSurplusBrokerLineLicense.headerText=this.rm.getString(RB_ui.RB_NAME, RB_ui.REPORTS_GRID_HEADER_GRID_HEADER_SURPLUS_LICENSE_NO);
				columns.push(dgcSurplusBrokerLineLicense);				

			}

			view.riskGrid.columns = columns;
			view.riskGrid.invalidateDisplayList();
		}

		private function formatDate(item:Object, column:DataGridColumn):String {
			var propertyName:String = column.dataField;
			var dateToFormat:Date = null;
			if (item.hasOwnProperty(propertyName))
				dateToFormat =item[propertyName] as Date;
			
			return dateToFormat ? DataFormatters.getInstance().getDateFormatter().format(dateToFormat) : "";			
		}
		
	}
}