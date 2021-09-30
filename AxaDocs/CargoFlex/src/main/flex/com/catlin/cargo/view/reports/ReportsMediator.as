package com.catlin.cargo.view.reports {
	import com.catlin.cargo.ApplicationFacade;
	import com.catlin.cargo.model.core.brokeroffice.BrokerOffice;
	import com.catlin.cargo.model.core.risk.Risk;
	import com.catlin.cargo.model.core.risk.RiskReportSearchCriteria;
	import com.catlin.cargo.model.core.risk.RiskSearchResult;
	import com.catlin.cargo.model.core.risk.RiskStatus;
	import com.catlin.cargo.model.proxy.BrokerProxy;
	import com.catlin.cargo.model.proxy.ReportsProxy;
	import com.catlin.cargo.view.reports.charts.ReportsChartsMediator;
	import com.catlin.cargo.view.reports.renderers.RiskStatusWrapper;
	import com.catlin.utils.GridExportUtils;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import mx.collections.ArrayCollection;
	import mx.collections.IList;
	import mx.controls.Alert;
	import mx.controls.ComboBox;
	import mx.controls.dataGridClasses.DataGridColumn;
	import mx.events.CalendarLayoutChangeEvent;
	import mx.events.ListEvent;
	
	import org.puremvc.as3.interfaces.IMediator;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;

	public class ReportsMediator extends Mediator implements IMediator { 

		public static const NAME:String = 'ReportsMediator';
		
		private var reportsProxy:ReportsProxy;
		
		public function ReportsMediator(viewComponent:ReportsVBox) {
			super(NAME, viewComponent);
			
			reportsProxy = facade.retrieveProxy(ReportsProxy.NAME) as ReportsProxy;

			initializeReportsSearchBar();
		}

		public function get view ():ReportsVBox {
			return viewComponent as ReportsVBox;
		}
		
		private function formatStatus(item:Object, column:DataGridColumn):String {
			var rsr:RiskSearchResult = item as RiskSearchResult;
			return Risk.getFormattedStatus(rsr.status, rsr.renewal);
		}		
		
		override public function listNotificationInterests():Array {
			return [ BrokerProxy.FIND_ALL_BROKER_OFFICES_COMPLETE, ReportsProxy.GENERATE_RISKS_REPORT_COMPLETE]
		}
		
		override public function handleNotification(note:INotification):void {
			switch (note.getName()) {
				case BrokerProxy.FIND_ALL_BROKER_OFFICES_COMPLETE:
					updateBrokerOfficeList(note);
					break;
				case ReportsProxy.GENERATE_RISKS_REPORT_COMPLETE:
					onGenerateReportcomplete(note);
					break;							
			}
		}
		
		private function onGenerateReportcomplete(note:INotification):void {
			updateDisplayDependencies();
		}
		
		override public function onRegister():void {
			super.onRegister();
			facade.registerMediator( new ReportsGridMediator( ReportsGridMediator.NAME, view.reportGrid ) );
			facade.registerMediator( new ReportsChartsMediator( ReportsChartsMediator.NAME, view.reportCharts) );
		}		
		
		[Bindable]
		private var allBrokerOffices:ArrayCollection = new ArrayCollection(); 
		
		private function updateBrokerOfficeList(note:INotification):void {
			allBrokerOffices.removeAll();
			allBrokerOffices.addAll(note.getBody() as IList);
			
			var brokersMasterOffices:ArrayCollection = new ArrayCollection([{name: "All Offices"}]);
			var brokersOffices:ArrayCollection = new ArrayCollection([{name: "All Offices"}]);
			
			if (ApplicationFacade.getInstance().userInfo.isUnderwriter) {
				for each (var currentOffice:BrokerOffice in allBrokerOffices) {
					if (currentOffice.masterOffice == null)
						brokersMasterOffices.addItem(currentOffice);
				}
				brokersOffices.addAll(allBrokerOffices);

				view.reportSearchBar.cboMasterOffice.dataProvider = brokersMasterOffices;
				view.reportSearchBar.cboBrokerOffice.dataProvider = brokersOffices;
				view.reportSearchBar.cboMasterOffice.addEventListener(ListEvent.CHANGE, updateBrokerOffices);

  			} else {
				var tmpChildOffice:ArrayCollection = new ArrayCollection([{name: "All Offices"}]);
				var masterOfficeSid:Number = 0;
				if (ApplicationFacade.getInstance().userInfo.brokerOffice.masterOffice == null) {
					masterOfficeSid = ApplicationFacade.getInstance().userInfo.brokerOffice.sid;
					for each (var currentOffice1:BrokerOffice in allBrokerOffices) {
						if (currentOffice1.masterOffice != null && currentOffice1.masterOffice.sid == masterOfficeSid)
							tmpChildOffice.addItem(currentOffice1);
					}
				}

				if (masterOfficeSid > 0 && tmpChildOffice.length > 1) {
					tmpChildOffice.addItemAt(ApplicationFacade.getInstance().userInfo.brokerOffice, 1);
					brokersMasterOffices = new ArrayCollection([ApplicationFacade.getInstance().userInfo.brokerOffice]);
					brokersOffices = new ArrayCollection(tmpChildOffice.toArray());

					view.reportSearchBar.cboMasterOffice.dataProvider = brokersMasterOffices;
					view.reportSearchBar.cboMasterOffice.addEventListener(ListEvent.CHANGE, updateBrokerOffices);
					view.reportSearchBar.cboBrokerOffice.selectedItem= brokersOffices.getItemAt(0);
					view.reportSearchBar.cboBrokerOffice.dataProvider = brokersOffices;

				} else {
					brokersOffices = new ArrayCollection([ApplicationFacade.getInstance().userInfo.brokerOffice]);
					view.reportSearchBar.cboBrokerOffice.dataProvider = brokersOffices;
					view.reportSearchBar.cboBrokerOffice.selectedItem= brokersOffices.getItemAt(0);
					view.reportSearchBar.masterOfficeFormItem.visible = false;
					view.reportSearchBar.masterOfficeFormItem.includeInLayout = false;
				}
			}
		}

		private function updateBrokerOffices(event:ListEvent):void {

			var brokersOffices:ArrayCollection = view.reportSearchBar.cboBrokerOffice.dataProvider as ArrayCollection;
			brokersOffices ? brokersOffices.removeAll() : brokersOffices = new ArrayCollection();
			brokersOffices.addItem({name: "All Offices"});
			
			var selectedOffice:BrokerOffice = (event.target as ComboBox).selectedItem as BrokerOffice;
			if (selectedOffice) {
				for each (var currentOffice:BrokerOffice in allBrokerOffices) {
					if (currentOffice.masterOffice && currentOffice.masterOffice.sid == selectedOffice.sid) 
						brokersOffices.addItem(currentOffice);
				}
				brokersOffices.addItem(selectedOffice);
			} else {
				brokersOffices.addAll(allBrokerOffices);
			}
		}
		
		protected function updateTileRiskStatus(event:MouseEvent):void {
			if (view.reportSearchBar.tileRiskStatus.selectedIndex == 0) {
				view.reportSearchBar.tileRiskStatus.selectedIndices=[0];
			} else {
				for each (var idx:int in view.reportSearchBar.tileRiskStatus.selectedIndices) {
					if (idx == 0) {
						view.reportSearchBar.tileRiskStatus.selectedIndices=[0];
						return;
					}
				}
			}
		}	
		
		protected function updateStartEndDate(event:Event):void {
			
			if (event.target == view.reportSearchBar.dfiStartDate) {
				if (view.reportSearchBar.dfiStartDate.selectedDate != null) {
					view.reportSearchBar.dfiEndDate.disabledRanges = [{rangeEnd: view.reportSearchBar.dfiStartDate.selectedDate}];
				}
			}
			
			if (event.target == view.reportSearchBar.dfiEndDate) {
				if (view.reportSearchBar.dfiEndDate.selectedDate != null) {
					view.reportSearchBar.dfiStartDate.disabledRanges = [{rangeStart: view.reportSearchBar.dfiEndDate.selectedDate}];
				}
			}			
		}			
		
		// Report Search Bar specific Methods - (To be moved to a future ReportSearchBarMediator if required).
		private function initializeReportsSearchBar():void {
			
			view.reportSearchBar.cboBrokerOffice.labelField = "name";
			view.reportSearchBar.cboMasterOffice.labelField = "name";

			view.reportSearchBar.btnGenerate.addEventListener(MouseEvent.CLICK, onGenerateReport);
			view.reportSearchBar.btnExportToExcel.addEventListener(MouseEvent.CLICK, onExportToExcel);
			view.reportSearchBar.btnExportToExcel.enabled = false;
			view.reportSearchBar.btnExportToExcel.alpha = 0.3;
			view.reportSearchBar.btnExportToExcel.buttonMode = false;
			
			view.reportSearchBar.btnExportToCSV.addEventListener(MouseEvent.CLICK, onExportToCSV);
			view.reportSearchBar.btnExportToCSV.enabled = false;
			view.reportSearchBar.btnExportToCSV.alpha = 0.3;
			view.reportSearchBar.btnExportToCSV.buttonMode = false;
			this.addEventListener("ReportListUpdated", updateDisplayDependencies); 
			
			var riskStatusDataProvider:ArrayCollection = RiskStatusWrapper.createArrayCollection(RiskStatus.constants);
			riskStatusDataProvider.addItemAt({name: 'ALL', valueOf: 'ALL'},0);
			view.reportSearchBar.tileRiskStatus.dataProvider = riskStatusDataProvider;
			
			view.reportSearchBar.tileRiskStatus.addEventListener(MouseEvent.CLICK, updateTileRiskStatus);
			view.reportSearchBar.dfiStartDate.addEventListener(CalendarLayoutChangeEvent.CHANGE, updateStartEndDate);
			view.reportSearchBar.dfiEndDate.addEventListener(CalendarLayoutChangeEvent.CHANGE, updateStartEndDate);			
		}
		
		private function updateDisplayDependencies():void {
			var reportEmpty:Boolean = reportsProxy.isReportEmpty();
			
			view.reportSearchBar.btnExportToExcel.enabled = !reportEmpty;
			view.reportSearchBar.btnExportToExcel.alpha = (!reportEmpty) ? 1.0 : 0.3;
			view.reportSearchBar.btnExportToExcel.buttonMode = !reportEmpty;
			
			view.reportSearchBar.btnExportToCSV.enabled = !reportEmpty
			view.reportSearchBar.btnExportToCSV.alpha = (!reportEmpty) ? 1.0 : 0.3;
			view.reportSearchBar.btnExportToCSV.buttonMode = !reportEmpty;
			//view.reportSearchBar.showSearchFilters(!value);
		}

		protected function onGenerateReport(evt:Event):void {
			
			var params:RiskReportSearchCriteria = generateRiskReportSeachCriteria();
			reportsProxy.generateReport(params);
		}
		
		protected function generateRiskReportSeachCriteria():RiskReportSearchCriteria {
			
			var ret:RiskReportSearchCriteria = new RiskReportSearchCriteria();
			
			ret.originatingOfficeCode = ApplicationFacade.getInstance().userInfo.originatingOffice.code;
			
			if (view.reportSearchBar.cboBrokerOffice.selectedItem && view.reportSearchBar.cboBrokerOffice.selectedItem is BrokerOffice)
				ret.brokerOfficeSid = (view.reportSearchBar.cboBrokerOffice.selectedItem as BrokerOffice).sid;

			if (view.reportSearchBar.cboMasterOffice.selectedItem && view.reportSearchBar.cboMasterOffice.selectedItem is BrokerOffice)
				ret.masterOfficeSid = (view.reportSearchBar.cboMasterOffice.selectedItem as BrokerOffice).sid;

			if (view.reportSearchBar.dfiStartDate.selectedDate)
				ret.startDate = view.reportSearchBar.dfiStartDate.selectedDate;
			
			if (view.reportSearchBar.dfiEndDate.selectedDate)
				ret.endDate = view.reportSearchBar.dfiEndDate.selectedDate;			

			if (view.reportSearchBar.tileRiskStatus.selectedItems && view.reportSearchBar.tileRiskStatus.selectedItems.length > 0) {

				// Is the slection is ALL status -> nothing to filter
				var selectionIsAll:Boolean = view.reportSearchBar.tileRiskStatus.selectedItems.length == 1 && view.reportSearchBar.tileRiskStatus.selectedIndex == 0; 
				if (!selectionIsAll) {
					ret.statuses = new Array();
					var statuses:IList = new ArrayCollection(view.reportSearchBar.tileRiskStatus.selectedItems);
					for each (var status:RiskStatusWrapper in statuses) 
						ret.statuses.push(status.riskStatus);
				}
			}
				
			return ret;
		}
		
		protected function onExportToExcel(evt:Event):void {
			GridExportUtils.exportBasicDataGridToExcel(view.reportGrid.riskGrid, false);
		}
		
		protected function onExportToCSV(evt:Event):void {
			
			GridExportUtils.exportBasicDataGridToClipboard(view.reportGrid.riskGrid, false);
			Alert.show("Data has been copy to Clipboard.");
		}

	}
}