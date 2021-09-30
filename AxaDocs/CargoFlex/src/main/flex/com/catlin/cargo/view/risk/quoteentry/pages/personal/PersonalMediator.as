package com.catlin.cargo.view.risk.quoteentry.pages.personal {

	import com.catlin.cargo.ApplicationFacade;
	import com.catlin.cargo.bundles.RB_ui;
	import com.catlin.cargo.model.core.brokercontact.BrokerContact;
	import com.catlin.cargo.model.core.brokeroffice.BrokerOffice;
	import com.catlin.cargo.model.core.insured.Insured;
	import com.catlin.cargo.model.core.originatingoffice.OriginatingOfficeCode;
	import com.catlin.cargo.model.core.party.Party;
	import com.catlin.cargo.model.core.risk.CommissionType;
	import com.catlin.cargo.model.core.risk.PremiumType;
	import com.catlin.cargo.model.core.risk.Risk;
	import com.catlin.cargo.model.core.risk.RiskStatus;
	import com.catlin.cargo.model.proxy.BrokerProxy;
	import com.catlin.cargo.model.proxy.CurrencyProxy;
	import com.catlin.cargo.model.reference.currency.Currency;
	import com.catlin.cargo.view.BaseMediator;
	import com.catlin.cargo.view.address.InsuredWindow;
	import com.catlin.cargo.view.address.InsuredWindowMediator;
	import com.catlin.cargo.view.risk.quoteentry.QuoteFormMediator;
	import com.catlin.cargo.view.risk.quoteentry.pages.personal.components.SurplusLinesMediator;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import mx.collections.ArrayCollection;
	import mx.collections.ICollectionView;
	import mx.collections.IList;
	import mx.collections.ListCollectionView;
	import mx.controls.Alert;
	import mx.events.FlexEvent;
	import mx.managers.PopUpManager;
	
	import org.puremvc.as3.interfaces.IMediator;
	import org.puremvc.as3.interfaces.INotification;

	public class PersonalMediator extends BaseMediator implements IMediator {

		public static const NAME:String='PersonalMediator';
		
		public static const ISURED_OR_SURPLES_STATE_CHANGED:String='ISURED_OR_SURPLES_STATE_CHANGED';

		private var brokerProxy:BrokerProxy;
		private var currencyProxy:CurrencyProxy;

		private var _quote:Risk;

		public function PersonalMediator(viewComponent:Object) {
			super(NAME, viewComponent);
			personal.cboBrokerOffices.addEventListener(FlexEvent.VALUE_COMMIT, onBrokerChange, true);
			personal.cboUnderwriter.addEventListener(FlexEvent.VALUE_COMMIT, onUnderwriterChange, true);
			personal.cboBrokerContact.addEventListener(FlexEvent.VALUE_COMMIT, onBrokerContactChange, true);
			personal.cboSelectInsured.addEventListener(Event.CHANGE, onInsuredChange);
			personal.cboCurrency.addEventListener(FlexEvent.VALUE_COMMIT, onCurrencyChange, true);
			personal.btnNewInsured.addEventListener(MouseEvent.CLICK, onNewInsured);
			personal.insuredName.addEventListener(MouseEvent.CLICK, onEditInsured);
			personal.businesConsumerControl.addEventListener(Event.CHANGE, onBusinesConsumerControlChange);

			brokerProxy=facade.retrieveProxy(BrokerProxy.NAME) as BrokerProxy;
			currencyProxy=facade.retrieveProxy(CurrencyProxy.NAME) as CurrencyProxy;

			super.addClientSpecificRestrictedComponent(personal.surplusLines, OriginatingOfficeCode.US, true, true, true);
			super.addClientSpecificRestrictedComponent(personal.businesConsumerControl, OriginatingOfficeCode.UK, true, true, true);
			super.applyClientSpecificViewRestrictions();
		}

		private function get personal():Personal {
			return viewComponent as Personal;
		}

		public function onEditInsured(event:MouseEvent):void {
			personal.showAddInsured=true;
			var form:InsuredWindow=new InsuredWindow();
			var mediator:InsuredWindowMediator=ApplicationFacade.addPopUpWindow(form, InsuredWindowMediator) as InsuredWindowMediator;
			mediator.editMode=true;
			mediator.insured=_quote.insured;
		}


		public function onNewInsured(event:MouseEvent):void {
			personal.showAddInsured=true;
			/*
			 * Need to create the window, set the broker office and
			 * then show it, to prevent the form from redrawing itself
			 * horribly in front of the user.
			 */
			var form:InsuredWindow=new InsuredWindow();
			var mediator:InsuredWindowMediator=ApplicationFacade.addPopUpWindow(form, InsuredWindowMediator) as InsuredWindowMediator;
			mediator.defaultCountry=_quote.brokerOffice.countryOfRisk.getCountry();
		}

		private function onEditInsuredComplete(party:Party):void {
			var qi:Insured=_quote.insured;
			qi.sid=party.sid;
			qi.name=party.name;
			qi.address.addressLine1=party.address.addressLine1;
			qi.address.addressLine2=party.address.addressLine2;
			qi.address.addressLine3=party.address.addressLine3;
			qi.address.townCity=party.address.townCity;
			qi.address.county=party.address.county;
			qi.address.country=party.address.country;
			qi.address.postcode=party.address.postcode;
			qi.address.province=party.address.province;

			createBasicDocumentation();
			sendNotification(ApplicationFacade.VALIDATE_SURPLES_STATE_VS_INSURED_STATE);
		}

		public function onAddInsuredComplete(party:Party):void {
			var insured:Insured=new Insured(party);
			personal.cboSelectInsured.dataProvider.addItem(insured);
			personal.cboSelectInsured.selectedItem=insured;
			_quote.insured=insured;

			personal.showAddInsured=false;
			createBasicDocumentation();
			sendNotification(ApplicationFacade.VALIDATE_SURPLES_STATE_VS_INSURED_STATE);
		}

		public function set currentQuote(quote:Risk):void {
			_quote=quote;
			setUpBrokerOfficeData();
			personal.cboBrokerOffices.selectedItem=quote.brokerOffice;
			setUpSurplusLinesBrokerData();
			cleanUpBrokerOfficeList();
			personal.showAddInsured=false;
			setExistingQuoteCurrency();
			setUpCommision();
		}

		private function setExistingQuoteCurrency():void {
			if (_quote != null && _quote.currency != null) {
				var view:ListCollectionView=personal.cboCurrency.dataProvider as ListCollectionView;
				for (var i:Number=0; i < view.length; i++) {
					var currency:Currency=view[i] as Currency;
					if (currency.isoCode == _quote.currency) {
						personal.cboCurrency.selectedItem=currency;
					}
				}
			}

		}

		private function setUpBrokerOfficeData():void {
			if (_quote != null && _quote.brokerOffice != null) {
				brokerProxy.listInsuredsForBrokerOffice(_quote.brokerOffice);
				if (!_quote.brokerOffice.enabled) {
					var brokers:ArrayCollection=personal.cboBrokerOffices.dataProvider as ArrayCollection;
					if (!brokers.contains(_quote.brokerOffice)) {
						personal.cboBrokerOffices.dataProvider.addItem(_quote.brokerOffice);
					}
				}
			} else {
				personal.cboSelectInsured.selectedItem=null;
			}
		}

		private function setUpCommision():void {
			var brokerOffice:BrokerOffice=personal.cboBrokerOffices.selectedItem as BrokerOffice;
			if (_quote.commissionType == CommissionType.GROSS && brokerOffice != null && _quote.status == RiskStatus.NEW) {
				_quote.commissionPercentage=brokerOffice.defaultCommission;
			}
		}

		private function cleanUpBrokerOfficeList():void {
			if (_quote == null || _quote.brokerOffice == null || _quote.brokerOffice.enabled) {
				var brokers:ArrayCollection=personal.cboBrokerOffices.dataProvider as ArrayCollection;
				for (var i:Number=0; i < brokers.length; i++) {
					var broker:BrokerOffice=brokers[i] as BrokerOffice;
					if (!broker.enabled) {
						brokers.removeItemAt(i);
					}
				}
			}
		}

		public function onBrokerChange(event:Event):void {
			var newBrokerOffice:BrokerOffice=event.currentTarget.selectedItem as BrokerOffice;
			if (newBrokerOffice != null) {
				if (_quote.editable) {
					_quote.currency=newBrokerOffice.defaultCurrency;
					if (!_quote.isMidTermAdjustment()) {
						_quote.premiumType=(newBrokerOffice.premiumType == PremiumType.BOTH ? PremiumType.FNA : newBrokerOffice.premiumType);
						_quote.minimumPremiumDeposit=newBrokerOffice.defaultMADPercentage;
					}
					_quote.insured=null;
					if (_quote.commissionType == CommissionType.GROSS) {
						_quote.commissionPercentage=newBrokerOffice.defaultCommission;
					}

					createBasicDocumentation();

					personal.cboUnderwriter.selectedItem=newBrokerOffice.underwriter;
				} else {
					personal.cboCurrency.selectedItem=_quote.currency;
					personal.cboUnderwriter.selectedItem=_quote.underwriter;
				}
				brokerProxy.listBrokerContactsForBrokerOffice(newBrokerOffice);
				brokerProxy.listInsuredsForBrokerOffice(newBrokerOffice);
				currencyProxy.findAuthorisedCurrency(newBrokerOffice.authorisedCurrencies);
			} else {
				personal.cboBrokerContact.selectedItem=null;
				personal.cboBrokerContact.dataProvider=new ArrayCollection();
				personal.cboSelectInsured.selectedItem=null;
				personal.cboSelectInsured.dataProvider=new ArrayCollection();
				personal.cboCurrency.selectedItem=null;
				personal.cboCurrency.dataProvider=new ArrayCollection();
				personal.cboUnderwriter.selectedItem=null;
			}
		}

		public function onUnderwriterChange(event:Event):void {
			if (_quote != null) {
				_quote.underwriter=event.currentTarget.selectedItem;
			}
		}

		public function onBrokerContactChange(event:Event):void {
			if (_quote != null) {
				_quote.brokerContact=event.currentTarget.selectedItem;
				if (_quote.brokerContact != null) {
					_quote.contactEmailAddress=_quote.brokerContact.emailAddress;
				}
			}
		}

		public function onInsuredChange(event:Event):void {
			if (_quote != null) {
				_quote.insured=event.currentTarget.selectedItem;
				sendNotification(ApplicationFacade.VALIDATE_SURPLES_STATE_VS_INSURED_STATE);
				createBasicDocumentation();
			}
		}

		public function onCurrencyChange(event:Event):void {
			if (_quote != null && event.currentTarget.selectedItem != null) {
				if (_quote.currency != event.currentTarget.selectedItem.isoCode) {
					createBasicDocumentation();
				}
				_quote.currency=event.currentTarget.selectedItem.isoCode;
				sendNotification(ApplicationFacade.UPDATE_LIMITS_AND_DEDCTIBLES, _quote.currency);
				if (_quote.totalSendingsValue > 0 && _quote.editable) {
					PopUpManager.centerPopUp(Alert.show(rm.getString(RB_ui.RB_NAME, RB_ui.PERSONAL_MEDIATOR_POP_UP_CURRENCY_CHANGE_MESSAGE), rm.getString(RB_ui.RB_NAME, RB_ui.PERSONAL_MEDIATOR_POP_UP_CURRENCY_CHANGE_TITLE)));
				}
			}
		}

		private function onListBrokerContacts(contacts:IList):void {
			var view:ICollectionView=new ListCollectionView(contacts);
			view.filterFunction=archiveFilter;
			view.refresh();
			var currentContact:BrokerContact=_quote.brokerContact;
			personal.cboBrokerContact.dataProvider=view;
			personal.cboBrokerContact.selectedItem=currentContact;
		}

		private function onListInsureds(insureds:IList):void {
			var dataProvider:ICollectionView=new ListCollectionView(insureds);
			personal.cboSelectInsured.dataProvider=dataProvider;
			personal.cboSelectInsured.selectedItem=_quote.insured;
		}

		private function onListCurrencies(note:INotification):void {
			var view:ListCollectionView=new ListCollectionView(note.getBody() as IList);
			personal.cboCurrency.dataProvider=view;

			for (var i:Number=0; i < view.length; i++) {
				var currency:Currency=view[i] as Currency;
				if (currency.isoCode == _quote.currency) {
					personal.cboCurrency.selectedItem=currency;
				}
			}
		}
		
		private function setUpSurplusLinesBrokerData():void {
			var surplusLinesMediator:SurplusLinesMediator=facade.retrieveMediator(SurplusLinesMediator.NAME) as SurplusLinesMediator;
			surplusLinesMediator.currentQuote=_quote;
		}

		override public function listNotificationInterests():Array {
			// FIXME - address dinwo
			return [BrokerProxy.FIND_ALL_BROKER_OFFICES_COMPLETE, 
					BrokerProxy.FIND_BROKER_CONTACTS_COMPLETE, 
					BrokerProxy.FIND_INSUREDS_COMPLETE, 
					BrokerProxy.FIND_ALL_UNDERWRITERS_COMPLETE,
					InsuredWindowMediator.INSURED_WINDOW_ENTERED, 
					InsuredWindowMediator.INSURED_WINDOW_CANCELLED, 
					CurrencyProxy.LIST_AUTHORISED_CURRENCIES_COMPLETE,
					QuoteFormMediator.EVT_CREATE_BASIC_DOCUMENTATION,
					ApplicationFacade.VALIDATE_SURPLES_STATE_VS_INSURED_STATE];
		}

		private function onFoundBrokerOffices(allOffices:ArrayCollection):void {
			var enabledOffices:ArrayCollection=new ArrayCollection();
			for (var i:Number=0; i < allOffices.length; i++) {
				var brokerOffice:BrokerOffice=allOffices[i] as BrokerOffice;
				if (brokerOffice.enabled) {
					enabledOffices.addItem(brokerOffice);
				}
			}
			personal.cboBrokerOffices.dataProvider=enabledOffices;
			sendNotification(ApplicationFacade.CREATE_QUOTE);
		}

		override public function handleNotification(note:INotification):void {
			switch (note.getName()) {
				case BrokerProxy.FIND_ALL_BROKER_OFFICES_COMPLETE:
					onFoundBrokerOffices((note.getBody() as ArrayCollection));
					break;
				case InsuredWindowMediator.INSURED_WINDOW_ENTERED:
					var ins:Insured=note.getBody() as Insured;
					if (!isNaN(ins.sid)) {
						onEditInsuredComplete(ins);
					} else {
						onAddInsuredComplete(ins);
					}
					break;
				case InsuredWindowMediator.INSURED_WINDOW_CANCELLED:
					personal.showAddInsured=false;
					break;
				case BrokerProxy.FIND_BROKER_CONTACTS_COMPLETE:
					onListBrokerContacts(IList(note.getBody()));
					break;
				case BrokerProxy.FIND_INSUREDS_COMPLETE:
					onListInsureds(IList(note.getBody()));
					break;
				case BrokerProxy.FIND_ALL_UNDERWRITERS_COMPLETE:
					personal.cboUnderwriter.dataProvider=note.getBody();
					break;
				case CurrencyProxy.LIST_AUTHORISED_CURRENCIES_COMPLETE:
					onListCurrencies(note);
					break;
				case ApplicationFacade.VALIDATE_SURPLES_STATE_VS_INSURED_STATE:
					validateSurplusVsInsuredStates();
			}
		}

		private function archiveFilter(bc:BrokerContact):Boolean {
			return bc.active;
		}

		protected function onBusinesConsumerControlChange(event:Event):void {
			if (_quote != null) {
				_quote.consumerBusinessControl=personal.businesConsumerControl.selectedValue;
				createBasicDocumentation();
			}
		}

		private function createBasicDocumentation():void {
			sendNotification(QuoteFormMediator.EVT_CREATE_BASIC_DOCUMENTATION);
		}

		override public function onRegister():void {
			facade.registerMediator(new SurplusLinesMediator(personal.surplusLines));
		}

		private function validateSurplusVsInsuredStates():void {
			if (_quote.surplusLinesReference && _quote.surplusLinesReference.province && _quote.insured) {
				if (_quote.insured.address.province == null || 
					_quote.surplusLinesReference.province.isoCode != _quote.insured.address.province.isoCode) {
					var slStateCode:String = _quote.surplusLinesReference.province.code;
					var insuredStateCode:String = _quote.insured.address.province != null ? _quote.insured.address.province.code : "Not Entered";
					PopUpManager.centerPopUp(
						Alert.show(
							rm.getString(RB_ui.RB_NAME, RB_ui.PERSONAL_MEDIATOR_POP_UP_SURPLUS_STATE_MESSAGE, [slStateCode, insuredStateCode]), 
							rm.getString(RB_ui.RB_NAME, RB_ui.PERSONAL_MEDIATOR_POP_UP_SURPLUS_STATE_TITLE)));
					
				}
			}
		}
	}
}
