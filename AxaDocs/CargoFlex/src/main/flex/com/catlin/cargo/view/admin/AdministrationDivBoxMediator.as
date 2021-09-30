package com.catlin.cargo.view.admin {
	import com.catlin.cargo.ApplicationFacade;
	import com.catlin.cargo.bundles.RB_ui;
	import com.catlin.cargo.model.core.brokeroffice.BrokerOffice;
	import com.catlin.cargo.model.core.underwriter.Underwriter;
	import com.catlin.cargo.model.proxy.BrokerProxy;
	import com.catlin.cargo.model.proxy.CountryProxy;
	import com.catlin.cargo.model.proxy.ReferenceDataProxy;
	import com.catlin.cargo.model.proxy.SourceAssociationProxy;
	import com.catlin.cargo.model.proxy.UsefulLinkProxy;
	import com.catlin.cargo.view.BaseMediator;
	import com.catlin.cargo.view.admin.brokeroffice.BrokerContactsVBoxMediator;
	import com.catlin.cargo.view.admin.brokeroffice.BrokerHistoryFormMediator;
	import com.catlin.cargo.view.admin.brokeroffice.BrokerOfficeDetailVBoxMediator;
	import com.catlin.cargo.view.admin.brokeroffice.BrokerOfficeLinksVBoxMediator;
	import com.catlin.cargo.view.admin.underwriter.UnderwriterDetailVBoxMediator;
	
	import flash.events.Event;
	
	import mx.collections.ICollectionView;
	import mx.collections.Sort;
	import mx.collections.SortField;
	import mx.events.FlexEvent;
	import mx.events.ItemClickEvent;
	import mx.events.ListEvent;
	
	import org.puremvc.as3.interfaces.IMediator;
	import org.puremvc.as3.interfaces.INotification;

	public class AdministrationDivBoxMediator extends BaseMediator implements IMediator {

		public static const NAME:String='AdministrationDivBoxMediator';

		public function AdministrationDivBoxMediator(viewComponent:AdministrationDivBox) {
			super(NAME, viewComponent);
			administrationDivBox.initialize();
			administrationDivBox.btnCreateBrokerOffice.addEventListener(FlexEvent.BUTTON_DOWN, onCreateBrokerOffice);
			administrationDivBox.btnCreateUnderwriter.addEventListener(FlexEvent.BUTTON_DOWN, onCreateUnderwriter);
			administrationDivBox.lstBrokerOffices.labelField="name";
			administrationDivBox.lstBrokerOffices.addEventListener(ItemClickEvent.ITEM_CLICK, onSelectBrokerOffice);
			administrationDivBox.lstUnderwriters.labelField="name";
			administrationDivBox.lstUnderwriters.addEventListener(ItemClickEvent.ITEM_CLICK, onSelectUnderwriter);
			
			administrationDivBox.searchBrokerOffice.addEventListener(Event.CHANGE, filterByBrokerOfficeChangeHandler);
			administrationDivBox.searchUnderwriter.addEventListener(Event.CHANGE, filterByUnderwriterChangeHandler);
		}

		public function get administrationDivBox():AdministrationDivBox {
			return viewComponent as AdministrationDivBox;
		}

		override public function onRegister():void {
			super.onRegister();
			facade.registerMediator(new BrokerOfficeDetailVBoxMediator(administrationDivBox.vbxBrokerOfficeDetail));
			facade.registerMediator(new BrokerContactsVBoxMediator(administrationDivBox.vbxBrokerContacts));
			facade.registerMediator(new UnderwriterDetailVBoxMediator(administrationDivBox.vbxUnderwriterDetail));
			facade.registerMediator(new BrokerHistoryFormMediator(administrationDivBox.brokerHistoryForm));
			facade.registerMediator(new BrokerOfficeLinksVBoxMediator(administrationDivBox.vbxBrokerLinks));
		}

		override public function listNotificationInterests():Array {
			return [ApplicationFacade.SHOW_ADMINISTRATION, BrokerProxy.FIND_ALL_BROKER_OFFICES_COMPLETE, BrokerProxy.FIND_ALL_UNDERWRITERS_COMPLETE];
		}

		override public function handleNotification(note:INotification):void {
			switch (note.getName()) {
				case ApplicationFacade.SHOW_ADMINISTRATION:
					onShowAdministration(note);
					break;
				case BrokerProxy.FIND_ALL_BROKER_OFFICES_COMPLETE:
					updateBrokerOfficeList(note);
					break;
				case BrokerProxy.FIND_ALL_UNDERWRITERS_COMPLETE:
					updateUnderwriterList(note);
					break;
			}
		}

		private function onShowAdministration(note:INotification):void {
			administrationDivBox.contentStack.selectedIndex=0;
			administrationDivBox.lblHeadline.text="";
			(facade.retrieveProxy(BrokerProxy.NAME) as BrokerProxy).listBrokerOfficesForUser();
			(facade.retrieveProxy(BrokerProxy.NAME) as BrokerProxy).listUnderwriters();
			(facade.retrieveProxy(SourceAssociationProxy.NAME) as SourceAssociationProxy).listSourceSystems();
			(facade.retrieveProxy(ReferenceDataProxy.NAME) as ReferenceDataProxy).listFrameOriginatingOffices();
			(facade.retrieveProxy(UsefulLinkProxy.NAME) as UsefulLinkProxy).listLinks();
			(facade.retrieveProxy(CountryProxy.NAME) as CountryProxy).listCountriesByName();			
		}

		private function updateBrokerOfficeList(note:INotification):void {
			var view:ICollectionView=ICollectionView(note.getBody());
			if (view) {
				var sort:Sort=new Sort();
				sort.fields=[new SortField("name", true)];
				view.sort=sort;
				view.refresh();
			}
			administrationDivBox.lstBrokerOffices.dataProvider=view;
			filterByBrokerOfficeChangeHandler(null);
		}

		private function updateUnderwriterList(note:INotification):void {
			var view:ICollectionView=ICollectionView(note.getBody());
			var sort:Sort=new Sort();
			sort.fields=[new SortField("name", true)];
			view.sort=sort;
			view.refresh();
			administrationDivBox.lstUnderwriters.dataProvider=view;
			filterByUnderwriterChangeHandler(null);
		}

		private function onCreateBrokerOffice(event:FlexEvent):void {
			administrationDivBox.contentStack.selectedIndex=1;
			administrationDivBox.tnvBrokerOffice.selectedIndex=0;
			administrationDivBox.lblHeadline.text=rm.getString(RB_ui.RB_NAME, RB_ui.ADMINISTRATION_MEDIATOR_NEW_BROKER_OFFICE);
			sendNotification(ApplicationFacade.CREATE_BROKER_OFFICE);
		}

		private function onSelectBrokerOffice(event:ListEvent):void {
			administrationDivBox.contentStack.selectedIndex=1;
			administrationDivBox.tnvBrokerOffice.selectedIndex=0;
			var bo:BrokerOffice=administrationDivBox.lstBrokerOffices.selectedItem as BrokerOffice;
			administrationDivBox.lblHeadline.text=bo.name;
			sendNotification(ApplicationFacade.LOAD_BROKER_OFFICE, bo);
		}

		private function onCreateUnderwriter(event:FlexEvent):void {
			administrationDivBox.contentStack.selectedIndex=2;
			administrationDivBox.lblHeadline.text=rm.getString(RB_ui.RB_NAME, RB_ui.ADMINISTRATION_MEDIATOR_NEW_UNDERWRITER);
			sendNotification(ApplicationFacade.LOAD_UNDERWRITER, new Underwriter());
		}

		private function onSelectUnderwriter(event:ListEvent):void {
			administrationDivBox.contentStack.selectedIndex=2;
			var uw:Underwriter=administrationDivBox.lstUnderwriters.selectedItem as Underwriter;
			administrationDivBox.lblHeadline.text=uw.name;
			sendNotification(ApplicationFacade.LOAD_UNDERWRITER, uw);
		}
		
		
		
		private function filterByBrokerOfficeChangeHandler(event:Event):void {
			
			var filterText:String = administrationDivBox.searchBrokerOffice.text;
			if (filterText != null && filterText.length > 2) {
				administrationDivBox.lstBrokerOffices.dataProvider.filterFunction=filterByBrokerOfficeNameFunction;
			} else {
				administrationDivBox.lstBrokerOffices.dataProvider.filterFunction=null;
			}
			administrationDivBox.lstBrokerOffices.dataProvider.refresh();
		}
		
		private function filterByBrokerOfficeNameFunction(item:Object):Boolean {
			var itemName:String=item ? item.name : "";
			if (itemName.toLowerCase().indexOf(administrationDivBox.searchBrokerOffice.text.toLowerCase()) >= 0) {
				return true;
			} else {
				return false;
			}
		}
		
		private function filterByUnderwriterChangeHandler(event:Event):void {
			
			var filterText:String = administrationDivBox.searchUnderwriter.text;
			if (filterText != null && filterText.length > 2) {
				administrationDivBox.lstUnderwriters.dataProvider.filterFunction=filterByUnderwriterNameFunction;
			} else {
				administrationDivBox.lstUnderwriters.dataProvider.filterFunction=null;
			}
			administrationDivBox.lstUnderwriters.dataProvider.refresh();
		}
		
		private function filterByUnderwriterNameFunction(item:Object):Boolean {
			var itemName:String=item ? item.name : "";
			if (itemName.toLowerCase().indexOf(administrationDivBox.searchUnderwriter.text.toLowerCase()) >= 0) {
				return true;
			} else {
				return false;
			}
		}		
	}
}
