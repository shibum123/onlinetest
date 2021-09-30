package com.catlin.cargo.model.proxy {
	
	import com.catlin.cargo.model.core.brokeroffice.BrokerOffice;
	import com.catlin.cargo.model.core.licencebrokeroffice.LicenceBrokerOffice;
	import com.catlin.cargo.model.core.surpluslines.SurplusLinesContact;
	import com.catlin.cargo.model.core.surpluslines.SurplusLinesReference;
	
	import org.granite.tide.events.TideResultEvent;
	import org.puremvc.as3.interfaces.IProxy;
	
	public class BrokerProxy extends BaseProxy implements IProxy {

		public static const NAME:String='BrokerOfficeProxy';
		public static const FIND_ALL_BROKER_OFFICES_COMPLETE:String='FIND_ALL_BROKER_OFFICES_COMPLETE';
		public static const FIND_ALL_UNDERWRITERS_COMPLETE:String='FIND_ALL_UNDERWRITERS_COMPLETE';
		public static const FIND_BROKER_CONTACTS_COMPLETE:String='FIND_BROKER_CONTACTS_COMPLETE';
		public static const FIND_MASTER_BROKER_CONTACTS_COMPLETE:String='FIND_MASTER_BROKER_CONTACTS_COMPLETE';
		public static const FIND_INSUREDS_COMPLETE:String='FIND_INSUREDS_COMPLETE';
		public static const FIND_ALL_SURPLUS_LINES_CONTACTS_COMPLETE:String='FIND_ALL_SURPLUS_LINES_CONTACTS_COMPLETE';
		public static const FIND_ALL_SURPLUS_LINES_OFFICES_COMPLETE:String='FIND_ALL_SURPLUS_LINES_OFFICES_COMPLETE';
		public static const FIND_SURPLUS_REFERENCES_FOR_CONTACT_COMPLETE:String='FIND_SURPLUS_REFERENCES_FOR_CONTACT_COMPLETE';
		public static const FIND_SURPLUS_CONTACT_BY_ID_COMPLETE:String='FIND_SURPLUS_CONTACT_BY_ID_COMPLETE';
		public static const FIND_SURPLUS_REFERENCE_BY_ID_COMPLETE:String='FIND_SURPLUS_REFERENCE_BY_ID_COMPLETE';
		public static const FIND_SURPLUS_OFFICE_BY_ID_COMPLETE:String='FIND_SURPLUS_OFFICE_BY_ID_COMPLETE';
		public static const LIST_SURPLUS_LINES_PROVINCES_FOR_BROKER_OFFICE_COMPLETE:String='LIST_SURPLUS_LINES_PROVINCES_FOR_BROKER_OFFICE_COMPLETE';

		public function BrokerProxy() {
			super(NAME);
		}

		public function listBrokerOfficesForUser():void {
			tideContext.brokerService.listBrokerOfficesForUser(onListBrokerOfficesForUser, onRemoteFault);
		}
		
		public function listUnderwriters():void {
			tideContext.brokerService.listUnderwriters(onListUnderwriters, onRemoteFault);
		}
		
		public function listBrokerContactsForMasterOffice(brokerOffice:BrokerOffice):void {
			tideContext.brokerService.listBrokerContactsForMasterOffice(brokerOffice.sid, onListBrokerContactsForMasterOffice,
				onRemoteFault);
		}
		
		public function listBrokerContactsForBrokerOffice(brokerOffice:BrokerOffice):void {
			tideContext.brokerService.listBrokerContactsForBrokerOffice(brokerOffice.sid, onListBrokerContactsForBrokerOffice,
				onRemoteFault);
		}
		
		public function listInsuredsForBrokerOffice(brokerOffice:BrokerOffice):void {
			tideContext.brokerService.listInsuredsForBrokerOffice(brokerOffice.sid, onListInsuredsForBrokerOffice, onRemoteFault);
		}
		
		private function onListBrokerOfficesForUser(event:TideResultEvent):void {
			sendNotification(FIND_ALL_BROKER_OFFICES_COMPLETE, event.result);
		}
		
		private function onListUnderwriters(event:TideResultEvent):void {
			sendNotification(FIND_ALL_UNDERWRITERS_COMPLETE, event.result);
		}
		
		private function onListBrokerContactsForBrokerOffice(event:TideResultEvent):void {
			sendNotification(FIND_BROKER_CONTACTS_COMPLETE, event.result);
		}
		
		private function onListBrokerContactsForMasterOffice(event:TideResultEvent):void {
			sendNotification(FIND_MASTER_BROKER_CONTACTS_COMPLETE, event.result);
		}
		
		private function onListInsuredsForBrokerOffice(event:TideResultEvent):void {
			sendNotification(FIND_INSUREDS_COMPLETE, event.result);
		}

		public function listSurplusLinesBrokerOfficesForOffice():void {
			tideContext.brokerService.listSurplusLinesBrokerOfficesForUser(onListSurplusLinesBrokerOfficesForOffice, onRemoteFault);
		}

		private function onListSurplusLinesBrokerOfficesForOffice(event:TideResultEvent):void {
			sendNotification(FIND_ALL_SURPLUS_LINES_OFFICES_COMPLETE, event.result);
		}

		public function listSurplusLinesContactsForSurplusLinesBrokerOffice(surplusLinesBrokerOffice:LicenceBrokerOffice):void {
			tideContext.brokerService.listSurplusLinesContact(surplusLinesBrokerOffice.sid, onListSurplusLinesContactsForSurplusLinesBrokerOffice,
				onRemoteFault);
		}

		private function onListSurplusLinesContactsForSurplusLinesBrokerOffice(event:TideResultEvent):void {
			sendNotification(FIND_ALL_SURPLUS_LINES_CONTACTS_COMPLETE, event.result);
		}
		
		public function listSurplusLinesContactReferencesForContact(surplusLinesContact:SurplusLinesContact):void {
			tideContext.brokerService.listSurplusLinesContactReferences(surplusLinesContact.sid, onListSurplusLinesContactReferencesForContact,
				onRemoteFault);
		}
		
		private function onListSurplusLinesContactReferencesForContact(event:TideResultEvent):void {
			sendNotification(FIND_SURPLUS_REFERENCES_FOR_CONTACT_COMPLETE, event.result);
		}

		// surplusLinesContact
		public function findSurplusLinesBrokerOfficeById(surplusLinesBrokerOffice:LicenceBrokerOffice):void {
			tideContext.brokerService.findSurplusLinesBrokerById(surplusLinesBrokerOffice.sid, onFindSurplusLinesBrokerOfficeById,
				onRemoteFault);
		}
		
		private function onFindSurplusLinesBrokerOfficeById(event:TideResultEvent):void {
			sendNotification(FIND_SURPLUS_OFFICE_BY_ID_COMPLETE, event.result);
		}

		// SurplusLinesContact
		public function findSurplusLineContactById(surplusLinesContact:SurplusLinesContact):void {
			tideContext.brokerService.findSurplusLinesContactById(surplusLinesContact.sid, onFindSurplusLinesContactById,
				onRemoteFault);
		}

		private function onFindSurplusLinesContactById(event:TideResultEvent):void {
			sendNotification(FIND_SURPLUS_CONTACT_BY_ID_COMPLETE, event.result);
		}

		// SurplusLinesReference
		public function findSurplusLinesReferenceById(surplusLinesReference:SurplusLinesReference):void {
			tideContext.brokerService.findSurplusLinesReferenceById(surplusLinesReference.sid, onFindSurplusLinesReferenceById,
				onRemoteFault);
		}

		private function onFindSurplusLinesReferenceById(event:TideResultEvent):void {
			sendNotification(FIND_SURPLUS_REFERENCE_BY_ID_COMPLETE, event.result);
		}		

		public function listSurplusLinesProvincesForBrokerOffice(surplusLinesBrokerOffice:LicenceBrokerOffice):void {
			tideContext.brokerService.listSurplusLinesProvincesForBrokerOffice(surplusLinesBrokerOffice.sid, onListSurplusLinesProvincesForBrokerOffice, onRemoteFault);
		}

		public function onListSurplusLinesProvincesForBrokerOffice(event:TideResultEvent):void {
			sendNotification(LIST_SURPLUS_LINES_PROVINCES_FOR_BROKER_OFFICE_COMPLETE, event.result);
		}

	}
}
