package com.catlin.cargo.view.admin.brokeroffice {
	
	import com.catlin.cargo.ApplicationFacade;
	import com.catlin.cargo.model.core.brokercontact.BrokerContact;
	import com.catlin.cargo.model.core.brokeroffice.BrokerOffice;
	import com.catlin.cargo.model.proxy.BrokerProxy;
	import com.catlin.cargo.view.BaseMediator;
	import com.catlin.ui.flex.validator.PageValidator;
	
	import flash.events.Event;
	
	import mx.collections.ICollectionView;
	import mx.collections.IList;
	import mx.collections.ListCollectionView;
	import mx.collections.Sort;
	import mx.collections.SortField;
	import mx.events.FlexEvent;
	import mx.events.ItemClickEvent;
	import mx.events.ListEvent;
	
	import org.puremvc.as3.interfaces.IMediator;
	import org.puremvc.as3.interfaces.INotification;

	public class BrokerContactsVBoxMediator extends BaseMediator implements IMediator {

		public static const NAME:String = 'BrokerContactsVBoxMediator';
		
		private var brokerOffice:BrokerOffice;
		private var brokerContact:BrokerContact;
		private var validation:BrokerContactsValidationImpl = new BrokerContactsValidationImpl();
		private var fieldValidator:PageValidator = new PageValidator();
		private var brokerProxy:BrokerProxy;

		public function BrokerContactsVBoxMediator(viewComponent:BrokerContactsVBox) {
			super(NAME, viewComponent);
			validation.window = brokerContactsVBox;
			fieldValidator.multiPageValidator.rules = validation.create();
			brokerContactsVBox.dgcName.dataField = "name";
			brokerContactsVBox.dgcEmail.dataField = "emailAddress";
			brokerContactsVBox.dgcUsername.dataField = "username";
			brokerContactsVBox.dgcAccountStatus.dataField = "enabled";
			
			//brokerContactsVBox.grdBrokerContacts.itemRenderer = new ClassFactory(BrokerContactDataGridItemRenderer);
			brokerContactsVBox.grdBrokerContacts.addEventListener(ItemClickEvent.ITEM_CLICK, onSelectBrokerContact);
			brokerContactsVBox.btnCreateContact.addEventListener(FlexEvent.BUTTON_DOWN, onCreateBrokerContact);
			brokerContactsVBox.btnResetPassword.addEventListener(FlexEvent.BUTTON_DOWN, onResetPassword);
			brokerContactsVBox.cbxArchived.addEventListener(FlexEvent.VALUE_COMMIT, onArchivedCommit);
			brokerContactsVBox.cbxAccountDisabled.addEventListener(FlexEvent.VALUE_COMMIT, onDisabledCommit);
			brokerContactsVBox.btnSave.addEventListener(FlexEvent.BUTTON_DOWN, onSave);
			brokerContactsVBox.cbxShowArchived.addEventListener(Event.CHANGE, onSelectArchivedClauses);
			brokerProxy = facade.retrieveProxy(BrokerProxy.NAME) as BrokerProxy;
		}

		public function get brokerContactsVBox ():BrokerContactsVBox {
			return viewComponent as BrokerContactsVBox;
		}

		override public function listNotificationInterests():Array {
			return [ApplicationFacade.LOAD_BROKER_OFFICE, BrokerProxy.FIND_BROKER_CONTACTS_COMPLETE];
		}

		override public function handleNotification(note:INotification):void {
			switch (note.getName()) {
				case ApplicationFacade.LOAD_BROKER_OFFICE:
					onLoadBrokerOffice(note);
					break;
				case BrokerProxy.FIND_BROKER_CONTACTS_COMPLETE:
					onLoadBrokerContacts(note);
					break;
			}
		}
	
		private function onLoadBrokerOffice(note:INotification):void {
			fieldValidator.reset();
			brokerOffice = note.getBody() as BrokerOffice;
			brokerContactsVBox.enabled = (!isNaN(brokerOffice.sid)); 
			setContactEnablement(false);
			brokerContact = null;
			brokerContactsVBox.txiName.text = null;
			brokerContactsVBox.txiAddressee.text = null;
			brokerContactsVBox.txiUsername.text = null;
			brokerContactsVBox.txiEmailAddress.text = null;
			brokerContactsVBox.txiTelephoneNumber.text = null;
			brokerContactsVBox.cbxAccountDisabled.selected = false;
			brokerContactsVBox.cbxArchived.selected = false;
			brokerProxy.listBrokerContactsForBrokerOffice(brokerOffice);
		}
		
		private function onLoadBrokerContacts(note:INotification):void {	
			var view:ICollectionView = new ListCollectionView(IList(note.getBody()));
			var sort:Sort = new Sort();
			sort.fields = [new SortField("name", true)];
			view.sort = sort;
			view.filterFunction = archiveFilter;
			view.refresh();	
			brokerContactsVBox.grdBrokerContacts.dataProvider = view;
		}
	
		private function onSelectBrokerContact(event:ListEvent):void {
			fieldValidator.reset();
			brokerContact = brokerContactsVBox.grdBrokerContacts.selectedItem as BrokerContact;
			loadBrokerContact();
		}
		
		private function onCreateBrokerContact(event:FlexEvent):void {
			fieldValidator.reset();
			brokerContact = new BrokerContact();
			loadBrokerContact();
		}
	
		private function onArchivedCommit(event:FlexEvent):void {
			if (brokerContactsVBox.cbxArchived.selected) {
				brokerContactsVBox.cbxAccountDisabled.selected = true;
			}
		}
	
		private function onDisabledCommit(event:FlexEvent):void {
			brokerContactsVBox.txiUsername.enabled = !brokerContactsVBox.cbxAccountDisabled.selected && brokerContact != null && 
				(brokerContact.username == null || brokerContact.username.length == 0);
			brokerContactsVBox.btnResetPassword.enabled = !brokerContactsVBox.cbxAccountDisabled.selected && brokerContact != null && 
				brokerContact.username != null && brokerContact.username.length > 0;
		}
		
		private function onResetPassword(event:FlexEvent):void {
			sendNotification(ApplicationFacade.RESET_PASSWORD, brokerContact.username);
		}
		
		private function onSave(event:FlexEvent):void {
			if (fieldValidator.validate("brokerContactsVBox", brokerContactsVBox)) {
				brokerContact.name = brokerContactsVBox.txiName.text;
				brokerContact.addressee = brokerContactsVBox.txiAddressee.text;
				brokerContact.username = (brokerContactsVBox.txiUsername.text.length > 0) ? brokerContactsVBox.txiUsername.text : null;
				brokerContact.emailAddress = brokerContactsVBox.txiEmailAddress.text;
				brokerContact.telephoneNumber = brokerContactsVBox.txiTelephoneNumber.text;
				brokerContact.brokerOffice = brokerOffice;
				brokerContact.active = !brokerContactsVBox.cbxArchived.selected;
				brokerContact.enabled = !brokerContactsVBox.cbxAccountDisabled.selected;
				sendNotification(ApplicationFacade.SAVE_BROKER_CONTACT, brokerContact);
			}
		}
		
		private function loadBrokerContact():void {
			brokerContactsVBox.txiName.text = brokerContact.name;
			brokerContactsVBox.txiAddressee.text = brokerContact.addressee;
			brokerContactsVBox.txiUsername.text = brokerContact.username;
			brokerContactsVBox.txiEmailAddress.text = brokerContact.emailAddress;
			brokerContactsVBox.txiTelephoneNumber.text = brokerContact.telephoneNumber;
			brokerContactsVBox.cbxArchived.selected = !brokerContact.active;
			brokerContactsVBox.cbxAccountDisabled.selected = !brokerContact.enabled;
			setContactEnablement(true);
			onDisabledCommit(null);
		}
		
		private function setContactEnablement(enabled:Boolean):void {
			brokerContactsVBox.txiName.enabled = enabled;
			brokerContactsVBox.txiAddressee.enabled = enabled;
			brokerContactsVBox.txiEmailAddress.enabled = enabled;
			brokerContactsVBox.txiTelephoneNumber.enabled = enabled;
			brokerContactsVBox.cbxArchived.enabled = enabled;
			brokerContactsVBox.cbxAccountDisabled.enabled = enabled;
			brokerContactsVBox.txiUsername.enabled = enabled;
			brokerContactsVBox.btnResetPassword.enabled = enabled;
			brokerContactsVBox.btnSave.enabled = enabled;
		}
		
		public function onSelectArchivedClauses(event:Event):void {
			var list:ICollectionView = (brokerContactsVBox.grdBrokerContacts.dataProvider as ICollectionView);
			if (list != null) {
				list.refresh();
			}
		}
		
		private function archiveFilter(bc:BrokerContact):Boolean {
			return brokerContactsVBox.cbxShowArchived.selected || bc.active;
		}
	}
}