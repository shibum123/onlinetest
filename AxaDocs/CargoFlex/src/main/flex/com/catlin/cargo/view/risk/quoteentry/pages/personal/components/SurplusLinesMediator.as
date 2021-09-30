package com.catlin.cargo.view.risk.quoteentry.pages.personal.components {

	import com.catlin.cargo.ApplicationFacade;
	import com.catlin.cargo.model.core.risk.Risk;
	import com.catlin.cargo.model.core.surpluslines.SurplusLinesBrokerOffice;
	import com.catlin.cargo.model.core.surpluslines.SurplusLinesContact;
	import com.catlin.cargo.model.core.surpluslines.SurplusLinesReference;
	import com.catlin.cargo.model.proxy.BrokerProxy;
	import com.catlin.cargo.model.reference.country.Province;
	import com.catlin.cargo.view.BaseMediator;
	import com.catlin.components.autoComplete.AutoComplete;
	
	import flash.events.Event;
	
	import mx.collections.ArrayCollection;
	import mx.collections.IList;
	import mx.controls.ComboBox;
	import mx.utils.StringUtil;
	
	import org.puremvc.as3.interfaces.IMediator;
	import org.puremvc.as3.interfaces.INotification;
	
	public class SurplusLinesMediator extends BaseMediator implements IMediator {

		public static const NAME:String='SurplusLinesMediator';

		private var brokerProxy:BrokerProxy;

		private var _quote:Risk;

		[Bindable]
		private var _activeSurplusLinesOffice:ArrayCollection;

		public function SurplusLinesMediator(viewComponent:Object) {
			super(NAME, viewComponent);

			view.cboSurplusLinesOffice.addEventListener(Event.CHANGE, onCboSurplusLinesOfficeChange);
			view.cboSurplusLinesContact.addEventListener(Event.CHANGE, onCboSurplusLinesContactChange);
			view.cboSurplusContactStates.addEventListener(Event.CHANGE, onCboSurplusContactStatesChange);
			view.cboSurplusLinesLicenseNo.addEventListener(Event.CHANGE, onCboSurplusLinesLicenseNoChange);

			brokerProxy=facade.retrieveProxy(BrokerProxy.NAME) as BrokerProxy;
		}

		public function set currentQuote(quote:Risk):void {
			_quote=quote;
			setUpSurplusLinesData(_quote._editModeEnabled, _quote.isMidTermAdjustment(), _quote.isRenewal());
		}

		private function get view():SurplusLines {
			return viewComponent as SurplusLines;
		}

		private function onCboSurplusLinesOfficeChange(event:Event):void {

			_quote.surplusLinesContact = null;
			_quote.surplusLinesReference = null;

			view.cboSurplusLinesLicenseNo.reset();
			view.cboSurplusLinesContact.reset(true);	

			if (view.cboSurplusLinesOffice.selectedItem != null) {

				var newSelectedLicenceBrokerOffice:SurplusLinesBrokerOffice = (view.cboSurplusLinesOffice.selectedItem as SurplusLinesBrokerOffice);
				// List states for the new office selected based on the office isoCode
				if (_quote.surplusLinesBrokerOffice == null 
					|| _quote.surplusLinesBrokerOffice.originatingOfficeCode != newSelectedLicenceBrokerOffice.originatingOfficeCode
					|| view.cboSurplusContactStates.dataProvider == null 
					|| (view.cboSurplusContactStates.dataProvider as ArrayCollection).length == 0) {
					brokerProxy.listSurplusLinesProvincesForBrokerOffice(newSelectedLicenceBrokerOffice);
				}

				if ((_quote.surplusLinesBrokerOffice == null && view.cboSurplusLinesOffice.selectedItem != null) || 
					(_quote.surplusLinesBrokerOffice != view.cboSurplusLinesOffice.selectedItem as SurplusLinesBrokerOffice)
				) {
					_quote.surplusLinesBrokerOffice=view.cboSurplusLinesOffice.selectedItem as SurplusLinesBrokerOffice;
					// List all the contacts for the given office
					brokerProxy.listSurplusLinesContactsForSurplusLinesBrokerOffice(_quote.surplusLinesBrokerOffice as SurplusLinesBrokerOffice);
				}
			}
		}

		private function onCboSurplusLinesContactChange(event:Event):void {

			var currentSurplusContact:SurplusLinesContact = null; 

			if (view.cboSurplusLinesContact.selectedItem != null 
				&& view.cboSurplusLinesContact.selectedItem is SurplusLinesContact) {
				currentSurplusContact = view.cboSurplusLinesContact.selectedItem as SurplusLinesContact;
				if (currentSurplusContact.sid == 0) {
					currentSurplusContact.name = view.cboSurplusLinesContact.text;
				}
			} else {
				if (view.cboSurplusLinesContact.text != null &&
					StringUtil.trim(view.cboSurplusLinesContact.text).length > 0) {
					currentSurplusContact = new SurplusLinesContact();
					currentSurplusContact.active = true;
					currentSurplusContact.name = view.cboSurplusLinesContact.text;
					currentSurplusContact.surplusLinesBrokerOffice = _quote.surplusLinesBrokerOffice;
					currentSurplusContact.active = true;
					currentSurplusContact.enabled = true;
					currentSurplusContact.sid = 0;
				} else {
					view.cboSurplusLinesContact.reset(true);
				}
			}

			_quote.surplusLinesContact=currentSurplusContact;
			_quote.surplusLinesReference=null;
			view.cboSurplusLinesLicenseNo.reset();

			// If its an existing surplus contact, then it might also have references numbers for states
			if (_quote.surplusLinesContact != null 
				&& _quote.surplusLinesContact.sid > 0) {
				brokerProxy.listSurplusLinesContactReferencesForContact(_quote.surplusLinesContact as SurplusLinesContact);
			}
			
		}

		private function onCboSurplusContactStatesChange(event:Event):void {

			if (view.cboSurplusContactStates.selectedItem != null) {

				_quote.surplusLinesReference = null;
				view.cboSurplusLinesLicenseNo.resetSelectedItem();

				// Will filter the SurplusLinesContactReferences dataprovider
				if (view.cboSurplusLinesLicenseNo.dataProvider != null) {
					var dp:ArrayCollection = view.cboSurplusLinesLicenseNo.dataProvider as ArrayCollection;
					view.cboSurplusLinesLicenseNo.dataProvider = dp;
					dp.filterFunction = filterLicencesNroByProvince;
					dp.refresh();
				}

				sendNotification(ApplicationFacade.VALIDATE_SURPLES_STATE_VS_INSURED_STATE);
			}
		}

		private function filterLicencesNroByProvince(item:Object):Boolean { 
			var isoCode:String = (item as SurplusLinesReference).province.isoCode;
			var selectedProvince:Province = view.cboSurplusContactStates.selectedItem as Province;
			if (selectedProvince != null) {
				return (isoCode.toLowerCase() == selectedProvince.isoCode.toLowerCase());
			}
			return false;
		}

		private function onCboSurplusLinesLicenseNoChange(event:Event):void {

			var currentSurplusLinesReference:SurplusLinesReference = null;
			if (view.cboSurplusLinesLicenseNo.selectedItem != null
				&& view.cboSurplusLinesLicenseNo.selectedItem is SurplusLinesReference) {
				currentSurplusLinesReference = view.cboSurplusLinesLicenseNo.selectedItem as SurplusLinesReference;
				if (currentSurplusLinesReference.sid == 0) {
					currentSurplusLinesReference.reference = view.cboSurplusLinesLicenseNo.text;					
				}
			} else {
				
				if (view.cboSurplusLinesLicenseNo.text != null &&
					StringUtil.trim(view.cboSurplusLinesLicenseNo.text).length > 0) {
					currentSurplusLinesReference = new SurplusLinesReference();
					currentSurplusLinesReference.reference = view.cboSurplusLinesLicenseNo.text;
					currentSurplusLinesReference.province = view.cboSurplusContactStates.selectedItem as Province;
					currentSurplusLinesReference.surplusLinesContact = _quote.surplusLinesContact;
					currentSurplusLinesReference.sid = 0;					
				} else {
					view.cboSurplusLinesLicenseNo.reset(true);
				}
			}
			_quote.surplusLinesReference=currentSurplusLinesReference;
		}

		private function onListSurplusLinesBrokerOffices(surplusBrokerLines:IList):void {
			var dataProvider:ArrayCollection=surplusBrokerLines as ArrayCollection;
			if (dataProvider != null && dataProvider.length > 0) {
				_activeSurplusLinesOffice = dataProvider;
				view.cboSurplusLinesOffice.dataProvider=_activeSurplusLinesOffice;
			}
		}

		private function onListSurplusLinesContacts(surplusBrokerLines:IList):void {
			var dataProvider:ArrayCollection=surplusBrokerLines as ArrayCollection;
			view.cboSurplusLinesContact.dataProvider = dataProvider;

			// pre-populates existing values
			if (_quote.surplusLinesContact != null && _quote.surplusLinesContact.sid > 0) {
				
				var tmpSurplusLinesContact:SurplusLinesContact = this.findItemIndexOnList(dataProvider, _quote.surplusLinesContact.sid) as SurplusLinesContact;
				if (_quote.surplusLinesContact.sid != tmpSurplusLinesContact.sid) 
					trace("ERROR_HERE: _quote.surplusLinesContact.sid != tmpSurplusLinesContact.sid ")

				setItemOnAutoCompleteDropDown(view.cboSurplusLinesContact, _quote.surplusLinesContact);
				brokerProxy.listSurplusLinesContactReferencesForContact(_quote.surplusLinesContact);
			}
		}		

		private function onListSurplusLinesReferencesForContact(surplusContactReferenceLines:IList):void {
			var dataProvider:ArrayCollection=surplusContactReferenceLines as ArrayCollection;
			view.cboSurplusLinesLicenseNo.dataProvider = dataProvider;

			if (_quote.surplusLinesReference != null && _quote.surplusLinesReference.sid > 0) {

				var tmpSurplusLinesReference:SurplusLinesReference = this.findItemIndexOnList(dataProvider, _quote.surplusLinesReference.sid) as SurplusLinesReference;
				if (_quote.surplusLinesReference.sid != tmpSurplusLinesReference.sid) 
					trace("ERROR_HERE: _quote.surplusLinesReference.sid != tmpSurplusLinesReference.sid")

				view.cboSurplusContactStates.selectedItem=_quote.surplusLinesReference.province;
				setItemOnAutoCompleteDropDown(view.cboSurplusLinesLicenseNo, _quote.surplusLinesReference);
			}
		}

		private function findItemIndexOnList(items:IList, targetSid:int):Object {
			if (items) {
				for each (var currentItem:Object in items) {
					if (currentItem.sid == targetSid) {
						return currentItem;
					}
				}
			}
			return null;
		}

		private function setUpSurplusLinesData(editMode:Boolean, isMTA:Boolean = false, isRenewal:Boolean = false):void {
			
			// Will reset the component.
			reset();

			// On edit mode will populate the dropDown with the active values.
			if (editMode || isRenewal) {
				var currentSurplusLinesBrokerOffice:SurplusLinesBrokerOffice=_quote != null ? _quote.surplusLinesBrokerOffice : null;
				if (currentSurplusLinesBrokerOffice != null) {

					var currentItem:Object = this.findItemIndexOnList(view.cboSurplusLinesOffice.dataProvider as
						IList, currentSurplusLinesBrokerOffice.sid);
					
					view.cboSurplusLinesOffice.selectedItem=currentItem;
					
					if (currentItem != null) {
						brokerProxy.listSurplusLinesContactsForSurplusLinesBrokerOffice(currentSurplusLinesBrokerOffice);
						brokerProxy.listSurplusLinesProvincesForBrokerOffice(currentSurplusLinesBrokerOffice);
					}
/*
					var currentSurplusLinesOffice:SurplusLinesBrokerOffice = this.findItemIndexOnList(view.cboSurplusLinesOffice.dataProvider as
					IList, currentSurplusLinesBrokerOffice.sid) as SurplusLinesBrokerOffice;
					
					view.cboSurplusLinesOffice.selectedItem=currentSurplusLinesOffice;
					
					if (currentSurplusLinesOffice != null) {
					brokerProxy.listSurplusLinesContactsForSurplusLinesBrokerOffice(currentSurplusLinesBrokerOffice);
					brokerProxy.listSurplusLinesProvincesForBrokerOffice(currentSurplusLinesBrokerOffice);
					}
*/
					
					
				} else {
					view.cboSurplusLinesOffice.selectedItem=null;
				}
			} else {
			// Otherwise, 
				//will check if is a new quote (wont have a sid yet)
				// If it is an exiting one, will reset the components
				if (!isNaN(_quote.sid) || isMTA) {
					if (_quote.surplusLinesBrokerOffice) {
						brokerProxy.findSurplusLinesBrokerOfficeById(_quote.surplusLinesBrokerOffice);
						if (_quote.surplusLinesContact) {
							brokerProxy.findSurplusLineContactById(_quote.surplusLinesContact);
							if (_quote.surplusLinesReference) {
								brokerProxy.findSurplusLinesReferenceById(_quote.surplusLinesReference);
							}
						}
					}
				}
			}
		}

		private function setItemOnDropDown(dropdown:ComboBox, selectedItem:Object):void {
			if (selectedItem != null && dropdown != null) {
				var dp:ArrayCollection=new ArrayCollection();
				dp.addItem(selectedItem);
				dropdown.dataProvider=dp;
				dropdown.selectedItem=selectedItem;
			}
		}

		private function setItemOnAutoCompleteDropDown(dropdown:AutoComplete, selectedItem:Object):void {
			if (selectedItem != null && dropdown != null) {

				var itemToSet:Object=selectedItem;
				var dp:ArrayCollection=new ArrayCollection();
				var dpSelectedItems:ArrayCollection=new ArrayCollection();

				if (dropdown.dataProvider == null) {
					dp.addItem(itemToSet);
					dropdown.dataProvider=dp;
				} else {
					// will look for the item on the existing DP
					for each (var item:Object in dropdown.dataProvider) {
						if (item['sid'] == selectedItem['sid']) {
							itemToSet = item;
							break;
						}
					}
				}

				var textToShow:String = "";
				if (selectedItem is SurplusLinesContact)
					textToShow = (selectedItem as SurplusLinesContact).name;
				else if (selectedItem is SurplusLinesReference)
					textToShow = (selectedItem as SurplusLinesReference).reference;
				
				dpSelectedItems.addItem(itemToSet);

				dropdown.selectedItem=itemToSet;
				dropdown.selectedItems=dpSelectedItems;
				dropdown.text=textToShow;
				dropdown.searchText=textToShow;
			}
		}

		override public function listNotificationInterests():Array {
			return [
				BrokerProxy.FIND_ALL_SURPLUS_LINES_CONTACTS_COMPLETE,
				BrokerProxy.FIND_ALL_SURPLUS_LINES_OFFICES_COMPLETE,
				BrokerProxy.FIND_SURPLUS_REFERENCES_FOR_CONTACT_COMPLETE,
				BrokerProxy.FIND_SURPLUS_CONTACT_BY_ID_COMPLETE,
				BrokerProxy.FIND_SURPLUS_REFERENCE_BY_ID_COMPLETE,
				BrokerProxy.FIND_SURPLUS_OFFICE_BY_ID_COMPLETE,
				BrokerProxy.LIST_SURPLUS_LINES_PROVINCES_FOR_BROKER_OFFICE_COMPLETE];
		}

		override public function handleNotification(note:INotification):void {
			switch (note.getName()) {
				case BrokerProxy.FIND_ALL_SURPLUS_LINES_OFFICES_COMPLETE:
					onListSurplusLinesBrokerOffices(IList(note.getBody()));
					break;
				case BrokerProxy.FIND_ALL_SURPLUS_LINES_CONTACTS_COMPLETE:
					onListSurplusLinesContacts(IList(note.getBody()));
					break;
				case BrokerProxy.FIND_SURPLUS_REFERENCES_FOR_CONTACT_COMPLETE:
					onListSurplusLinesReferencesForContact(IList(note.getBody()));
					break;
				case BrokerProxy.FIND_SURPLUS_CONTACT_BY_ID_COMPLETE:
					setItemOnAutoCompleteDropDown(view.cboSurplusLinesContact, note.getBody());
					break;
				case BrokerProxy.FIND_SURPLUS_REFERENCE_BY_ID_COMPLETE:
					var surplusReference:SurplusLinesReference = note.getBody() as SurplusLinesReference;
					setItemOnAutoCompleteDropDown(view.cboSurplusLinesLicenseNo, surplusReference);
					setItemOnDropDown(view.cboSurplusContactStates, surplusReference.province);
					break;
				case BrokerProxy.FIND_SURPLUS_OFFICE_BY_ID_COMPLETE:
					setItemOnDropDown(view.cboSurplusLinesOffice, note.getBody());
					break;
				case BrokerProxy.LIST_SURPLUS_LINES_PROVINCES_FOR_BROKER_OFFICE_COMPLETE:
					var dataProvider:ArrayCollection=note.getBody() as ArrayCollection;
					view.cboSurplusContactStates.dataProvider = dataProvider;					
					break
			}
		}

		private function reset():void {

			view.cboSurplusLinesOffice.dataProvider = null;
			view.cboSurplusLinesOffice.selectedItem = null;

			view.cboSurplusLinesContact.dataProvider = null;
			view.cboSurplusLinesContact.selectedItem = null;
			view.cboSurplusLinesContact.text = null;

			view.cboSurplusContactStates.dataProvider = null;
			view.cboSurplusContactStates.selectedItem = null;

			view.cboSurplusLinesLicenseNo.dataProvider = null;
			view.cboSurplusLinesLicenseNo.selectedItem = null;
			view.cboSurplusLinesLicenseNo.text = null;

			view.cboSurplusLinesContact.reset();
			view.cboSurplusLinesLicenseNo.reset();			
			
			if (_activeSurplusLinesOffice != null) {
				view.cboSurplusLinesOffice.dataProvider=_activeSurplusLinesOffice;
			}
		}
	}
}