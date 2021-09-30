package com.catlin.cargo.view.leftarea {
	import com.catlin.cargo.ApplicationFacade;
	import com.catlin.cargo.bundles.RB_ui;
	import com.catlin.cargo.controller.SearchCommand;
	import com.catlin.cargo.model.core.risk.Risk;
	import com.catlin.cargo.model.core.risk.RiskSearchResult;
	import com.catlin.cargo.model.proxy.RiskProxy;
	import com.catlin.cargo.view.BaseMediator;
	
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	
	import mx.binding.utils.BindingUtils;
	import mx.collections.ArrayCollection;
	import mx.controls.dataGridClasses.DataGridColumn;
	import mx.events.FlexEvent;
	import mx.formatters.DateFormatter;
	
	import org.puremvc.as3.interfaces.IMediator;
	import org.puremvc.as3.interfaces.INotification;

	public class SearchMediator extends BaseMediator implements IMediator {
		
		public static const NAME:String = 'SearchMediator';
		private var dateFormat:DateFormatter = new DateFormatter();
		
		private var riskProxy:RiskProxy;
		
		public function SearchMediator(viewComponent:Object) {
			super(NAME, viewComponent);
			
		    riskProxy = facade.retrieveProxy(RiskProxy.NAME) as RiskProxy;
			
			searchForm.btnSearch.addEventListener(FlexEvent.BUTTON_DOWN, onSearch);
			searchForm.txtSearch.addEventListener(KeyboardEvent.KEY_DOWN, onSearchEnter);
			
			searchForm.dgcDate.labelFunction = formatDate;

            searchForm.dgcReference.dataField = "reference";

            searchForm.dgcStatus.labelFunction = formatStatus;
            
            searchForm.dgcBrokerOffice.dataField = "brokerOfficeName";
            
            searchForm.dgcTownCity.dataField = "brokerTown";
			
			searchForm.dgcInsured.dataField = "insuredName";

			dateFormat.formatString = ApplicationFacade.getInstance().localeFormat.dateShort4Year2MonthDay; // "DD/MM/YYYY";
			BindingUtils.bindProperty(dateFormat, "formatString", ApplicationFacade.getInstance(), ["localeFormat", "dateShort4Year2MonthDay"]);
			
		}

		private function formatStatus(item:Object, column:DataGridColumn):String {
			var rsr:RiskSearchResult = item as RiskSearchResult;
			return Risk.getFormattedStatus(rsr.status, rsr.renewal);
		}

		public function formatDate(item:Object, column:DataGridColumn):String {
			return dateFormat.format(item.policyStartDateAsDate);
		}

        private function onViewRisk( event:Event ):void {
			if (event.target.selectedRisk != null) {
				riskProxy.findById(event.target.selectedRisk.riskSid);
   			}
        }

		private function onSearchEnter(event:KeyboardEvent):void {
			if (event.keyCode == 13) {
				onSearch(new FlexEvent("")); // trigger search
			}
		}

		private function onSearch(event:FlexEvent):void {
			if (searchForm.txtSearch.text.length > 0) {
				sendNotification(ApplicationFacade.SEARCH, searchForm.txtSearch.text);
			} 
		}		
		private function get searchForm ():Search {
			return viewComponent as Search;
		}

		override public function listNotificationInterests():Array {
			return [SearchCommand.SEARCH_COMPLETE];
		}
		
		override public function handleNotification(note:INotification):void {
			switch (note.getName()) {
				case SearchCommand.SEARCH_COMPLETE:
					searchForm.riskGrid.dataProvider = note.getBody();
					searchForm.label = rm.getString(RB_ui.RB_NAME, RB_ui.SEARCH_VIEW_TITLE) + " (" + (note.getBody() as ArrayCollection).length + ")"; 
					break;
			}
		}
		
	}
}