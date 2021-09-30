package com.catlin.cargo.view.help {
	import com.catlin.cargo.ApplicationFacade;
	import com.catlin.cargo.bundles.RB_ui;
	import com.catlin.cargo.model.core.brokercontact.BrokerContact;
	import com.catlin.cargo.model.core.brokeroffice.BrokerOffice;
	import com.catlin.cargo.model.core.originatingoffice.OriginatingOfficeCode;
	import com.catlin.cargo.model.proxy.BrokerProxy;
	import com.catlin.cargo.view.BaseMediator;

	import flash.events.Event;
	import flash.events.MouseEvent;

	import mx.collections.ArrayCollection;
	import mx.controls.Alert;

	import org.puremvc.as3.interfaces.IMediator;
	import org.puremvc.as3.interfaces.INotification;

	public class ContactUsDivBoxMediator extends BaseMediator implements IMediator {
		public static const NAME:String='ContactUsDivBoxMediator';
		private var brokerProxy:BrokerProxy;

		public function ContactUsDivBoxMediator(viewComponent:ContactUsDivBox) {
			super(NAME, viewComponent);
			contactUsDivBox.userInfo=ApplicationFacade.getInstance().userInfo;
			contactUsDivBox.btnSubmit.addEventListener(MouseEvent.CLICK, onSubmit);

			brokerProxy=facade.retrieveProxy(BrokerProxy.NAME) as BrokerProxy;

			// US view restrictions:
			super.addClientSpecificRestrictedComponent(contactUsDivBox.contactsDetailsContainer, OriginatingOfficeCode.US);
			super.applyClientSpecificViewRestrictions();

		}

		override public function listNotificationInterests():Array {
			return [BrokerProxy.FIND_ALL_BROKER_OFFICES_COMPLETE, BrokerProxy.FIND_MASTER_BROKER_CONTACTS_COMPLETE];
		}

		override public function handleNotification(note:INotification):void {
			switch (note.getName()) {
				case BrokerProxy.FIND_ALL_BROKER_OFFICES_COMPLETE:
					processMasterOfficeDisplay((note.getBody() as ArrayCollection));
					break;
				case BrokerProxy.FIND_MASTER_BROKER_CONTACTS_COMPLETE:
					displayActiveContactsForMasterOffice((note.getBody() as ArrayCollection));
					break;
			}
		}

		private function processMasterOfficeDisplay(allOffices:ArrayCollection):void {
			if (!contactUsDivBox.userInfo.isBroker || contactUsDivBox.userInfo.isSupport || contactUsDivBox.userInfo.isUnderwriter) {
				return;
			}
			var enabledOffices:ArrayCollection=new ArrayCollection();
			for (var i:Number=0; i < allOffices.length; i++) {
				var brokerOffice:BrokerOffice=allOffices[i] as BrokerOffice;
				if (brokerOffice.enabled) {
					enabledOffices.addItem(brokerOffice);
				}
			}
			if (enabledOffices.length == 1) {
				var masterOffice:BrokerOffice=(enabledOffices[0] as BrokerOffice).masterOffice;
				;
				if (masterOffice != null && masterOffice.showContactUsDetails) {
					contactUsDivBox.masterOffice=masterOffice;
					brokerProxy.listBrokerContactsForMasterOffice(contactUsDivBox.masterOffice);
				}
			}


		}

		private function displayActiveContactsForMasterOffice(brokerContacts:ArrayCollection):void {
			var enabledBrokerContacts:ArrayCollection=new ArrayCollection();
			for (var i:Number=0; i < brokerContacts.length; i++) {
				var brokerContact:BrokerContact=brokerContacts[i] as BrokerContact;
				if (brokerContact.active) {
					enabledBrokerContacts.addItem(brokerContact);
				}
			}
			if (enabledBrokerContacts.length > 0 && contactUsDivBox.masterOffice != null) {
				if ((enabledBrokerContacts[0] as BrokerContact).brokerOffice == contactUsDivBox.masterOffice) {
					contactUsDivBox.masterBrokerContacts=enabledBrokerContacts;
				}
			}
		}

		public function onSubmit(event:Event):void {
			var sel:XML=contactUsDivBox.cboQueryType.selectedItem as XML;
			if (sel == null) {
				Alert.show(rm.getString(RB_ui.RB_NAME, RB_ui.CONTACT_US_MEDIATOR_SUBMIT_REQUIRED_QUERY));
				return;
			}
			if (contactUsDivBox.txaDescription.text.length == 0) {
				Alert.show(rm.getString(RB_ui.RB_NAME, RB_ui.CONTACT_US_MEDIATOR_SUBMIT_REQUIRED_DESCRIPTION));
				return;
			}
			sendNotification(ApplicationFacade.CONTACT_US_QUERY,
				{mailto: sel.@email.toString(), subject: sel.@subject.toString(), message: contactUsDivBox.txaDescription.text});
			Alert.show(rm.getString(RB_ui.RB_NAME, RB_ui.CONTACT_US_MEDIATOR_SUBMIT_MESSAGE));
			contactUsDivBox.cboQueryType.selectedIndex=-1;
			contactUsDivBox.txaDescription.text="";
		}

		public function get contactUsDivBox():ContactUsDivBox {
			return viewComponent as ContactUsDivBox;
		}
	}
}
