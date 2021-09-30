package com.catlin.cargo.view.admin.brokeroffice {

	import com.catlin.cargo.ApplicationFacade;
	import com.catlin.cargo.bundles.RB_ui;
	import com.catlin.cargo.controller.PostcodeFetchCommand;
	import com.catlin.cargo.model.core.brokeroffice.BrokerOffice;
	import com.catlin.cargo.model.core.frameoriginatingoffice.FrameOriginatingOffice;
	import com.catlin.cargo.model.core.risk.PremiumType;
	import com.catlin.cargo.model.core.sourceassociation.Channel;
	import com.catlin.cargo.model.core.sourceassociation.SourceAssociation;
	import com.catlin.cargo.model.core.sourceassociation.SourceSystem;
	import com.catlin.cargo.model.core.underwriter.Underwriter;
	import com.catlin.cargo.model.proxy.BrokerProxy;
	import com.catlin.cargo.model.proxy.CountryProxy;
	import com.catlin.cargo.model.proxy.CurrencyProxy;
	import com.catlin.cargo.model.proxy.HistoryProxy;
	import com.catlin.cargo.model.proxy.ReferenceDataProxy;
	import com.catlin.cargo.model.proxy.SourceAssociationProxy;
	import com.catlin.cargo.model.reference.country.Country;
	import com.catlin.cargo.model.reference.country.Region;
	import com.catlin.cargo.model.reference.country.Territory;
	import com.catlin.cargo.model.reference.currency.Currency;
	import com.catlin.cargo.model.security.UserInfo;
	import com.catlin.cargo.model.ui.lookandfeel.LookAndFeel;
	import com.catlin.cargo.view.BaseMediator;
	import com.catlin.cargo.view.admin.components.LookAndFeelPreviewTitleWindow;
	import com.catlin.ui.flex.validator.PageValidator;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import mx.binding.utils.BindingUtils;
	import mx.collections.ArrayCollection;
	import mx.collections.IList;
	import mx.collections.ListCollectionView;
	import mx.collections.Sort;
	import mx.collections.SortField;
	import mx.controls.Alert;
	import mx.controls.List;
	import mx.core.Application;
	import mx.events.DragEvent;
	import mx.events.FlexEvent;
	import mx.formatters.DateFormatter;
	import mx.managers.PopUpManager;
	
	import org.puremvc.as3.interfaces.IMediator;
	import org.puremvc.as3.interfaces.INotification;

	public class BrokerOfficeDetailVBoxMediator extends BaseMediator implements IMediator {

		public static const NAME:String='BrokerOfficeDetailVBoxMediator';
		private var validation:BrokerOfficeDetailValidationImpl=new BrokerOfficeDetailValidationImpl();
		private var fieldValidator:PageValidator=new PageValidator();
		private var df:DateFormatter=new DateFormatter();

		private var brokerOffice:BrokerOffice;
		private var sourceAssociations:ArrayCollection=new ArrayCollection();
		private var currency:Currency;

		private var addressMediator:BrokerOfficeDetailAddressMediator;

		public function BrokerOfficeDetailVBoxMediator(viewComponent:BrokerOfficeDetailVBox) {
			super(NAME, viewComponent);
			df.formatString=ApplicationFacade.getInstance().localeFormat.dateTimeShort4Year; // "DD/MM/YYYY JJ:NN";
			BindingUtils.bindProperty(df, "formatString", ApplicationFacade.getInstance(), ["localeFormat", "dateTimeShort4Year"]);
			validation.window=brokerOfficeDetailVBox;
			fieldValidator.multiPageValidator.rules=validation.create();
			brokerOfficeDetailVBox.cboMasterOffice.labelField="name";
			brokerOfficeDetailVBox.cboUnderwriter.labelField="name";
			brokerOfficeDetailVBox.cboFrameOriginatingOffice.labelField="name";
			brokerOfficeDetailVBox.cboCountryOfRisk.labelField="name";
			brokerOfficeDetailVBox.cboDefaultCountryOfRisk.labelField="name";
			brokerOfficeDetailVBox.cboDefaultCurrency.labelField="name";
			brokerOfficeDetailVBox.authorisedCurrencies.labelField="name";
			brokerOfficeDetailVBox.allCurrencies.labelField="name";

			brokerOfficeDetailVBox.allCurrencies.dragEnabled=true;
			brokerOfficeDetailVBox.allCurrencies.allowDragSelection=false;
			brokerOfficeDetailVBox.allCurrencies.allowMultipleSelection=false;
			brokerOfficeDetailVBox.allCurrencies.dropEnabled=true;
			brokerOfficeDetailVBox.allCurrencies.dragMoveEnabled=true;
			brokerOfficeDetailVBox.allCurrencies.addEventListener(DragEvent.DRAG_DROP, onRemoveCurrency);

			brokerOfficeDetailVBox.authorisedCurrencies.dragEnabled=true;
			brokerOfficeDetailVBox.authorisedCurrencies.allowDragSelection=false;
			brokerOfficeDetailVBox.authorisedCurrencies.dropEnabled=true;
			brokerOfficeDetailVBox.authorisedCurrencies.allowMultipleSelection=false;
			brokerOfficeDetailVBox.authorisedCurrencies.dragMoveEnabled=true;
			brokerOfficeDetailVBox.authorisedCurrencies.addEventListener(DragEvent.DRAG_DROP, onDropAuthorisedCurrency);

			brokerOfficeDetailVBox.btnSave.addEventListener(MouseEvent.MOUSE_OVER, saveFocus);
			brokerOfficeDetailVBox.btnSave.addEventListener(FlexEvent.BUTTON_DOWN, onSave);

			brokerOfficeDetailVBox.cboCountryOfRisk.addEventListener(Event.CHANGE, onCountryOfRiskChange);

			brokerOfficeDetailVBox.cboDefaultCurrency.addEventListener(FlexEvent.VALUE_COMMIT, onDefaultCurrencyChange, true);

			addressMediator=new BrokerOfficeDetailAddressMediator(brokerOfficeDetailVBox);
			facade.registerMediator(addressMediator);

			var userInfo:UserInfo=ApplicationFacade.getInstance().userInfo;

			brokerOfficeDetailVBox.cboDomesticTransitBOV.dataProvider=new ArrayCollection(["10%", "15%", "20%", "25%", "30%", "Other"]);
			var asianUser:Boolean=userInfo.isAsianOriginatingOffice();
			brokerOfficeDetailVBox.dtbov.includeInLayout=asianUser;
			brokerOfficeDetailVBox.dtbov.visible=asianUser;
			
			brokerOfficeDetailVBox.previewButton.addEventListener(MouseEvent.CLICK, onLookAndFeelPreview); 
		}

		protected function onCountryOfRiskChange(event:Event = null):void {
			var selectedCountry:Country = null;
			var isRegion:Boolean = brokerOfficeDetailVBox.cboCountryOfRisk.selectedItem is Region;  
			if (isRegion) {
				var region:Region = brokerOfficeDetailVBox.cboCountryOfRisk.selectedItem as Region; 
				brokerOfficeDetailVBox.cboDefaultCountryOfRisk.dataProvider=region.territories;
				brokerOfficeDetailVBox.cboDefaultCountryOfRisk.selectedItem=region.defaultTerritory;
				selectedCountry = region.defaultTerritory as Country;
			} else {
				selectedCountry = brokerOfficeDetailVBox.cboCountryOfRisk.selectedItem as Country;
			}

			brokerOfficeDetailVBox.fmiDefaultCountryOfRisk.includeInLayout = isRegion;
			brokerOfficeDetailVBox.fmiDefaultCountryOfRisk.visible = isRegion;
			addressMediator.country=selectedCountry;
		}

		protected function saveFocus(event:MouseEvent):void {
			brokerOfficeDetailVBox.focusManager.setFocus(brokerOfficeDetailVBox.btnSave);
		}

		public function get brokerOfficeDetailVBox():BrokerOfficeDetailVBox {
			return viewComponent as BrokerOfficeDetailVBox;
		}

		override public function listNotificationInterests():Array {
			return [ApplicationFacade.LOAD_BROKER_OFFICE, 
					BrokerProxy.FIND_ALL_UNDERWRITERS_COMPLETE, 
					ReferenceDataProxy.FIND_ALL_FRAME_ORIGINATING_OFFICES_COMPLETE, 
					BrokerProxy.FIND_ALL_BROKER_OFFICES_COMPLETE, 
					PostcodeFetchCommand.POSTCODE_FETCH_COMPLETE, 
					SourceAssociationProxy.FIND_ALL_SOURCE_SYSTEMS_COMPLETE, 
					SourceAssociationProxy.FIND_SOURCE_ASSOCIATION_COMPLETE, 
					ApplicationFacade.SAVE_BROKER_OFFICE_COMPLETE, 
					ApplicationFacade.SAVE_SOURCE_ASSOCIATION_COMPLETE, 
					CountryProxy.LIST_COUNTRIES_OF_RISK_COMPLETE, 
					CurrencyProxy.LIST_CURRENCIES_COMPLETE, 
					CurrencyProxy.LIST_AUTHORISED_CURRENCIES_COMPLETE];
		}

		override public function handleNotification(note:INotification):void {
			switch (note.getName()) {
				case ApplicationFacade.LOAD_BROKER_OFFICE:
					onLoadBrokerOffice(note);
					break;
				case BrokerProxy.FIND_ALL_UNDERWRITERS_COMPLETE:
					updateUnderwriters(note);
					break;
				case ReferenceDataProxy.FIND_ALL_FRAME_ORIGINATING_OFFICES_COMPLETE:
					updateFrameOriginatingOffices(note);
					break;
				case BrokerProxy.FIND_ALL_BROKER_OFFICES_COMPLETE:
					updateMasterOffices(note);
					break;
				case SourceAssociationProxy.FIND_ALL_SOURCE_SYSTEMS_COMPLETE:
					populateSourceSystem(note);
					break;
				case SourceAssociationProxy.FIND_SOURCE_ASSOCIATION_COMPLETE:
					populateSourceAssociation(note);
					break;
				case ApplicationFacade.SAVE_BROKER_OFFICE_COMPLETE:
					onSaveBrokerOfficeComplete(note);
					break;
				case ApplicationFacade.SAVE_SOURCE_ASSOCIATION_COMPLETE:
					onSaveSourceAssociationComplete(note);
					break;
				case CountryProxy.LIST_COUNTRIES_OF_RISK_COMPLETE:
					updateCountryOfRisk(note);
					break;
				case CurrencyProxy.LIST_CURRENCIES_COMPLETE:
					populateUnauthorisedCurrencies(note);
					break;
				case CurrencyProxy.LIST_AUTHORISED_CURRENCIES_COMPLETE:
					populateAuthorisedCurrencies(note);
					break;
			}
		}

		private function populateAuthorisedCurrencies(note:INotification):void {
			if (brokerOffice != null) {
				brokerOfficeDetailVBox.authorisedCurrencies.dataProvider=note.getBody();
				brokerOfficeDetailVBox.cboDefaultCurrency.dataProvider=note.getBody();
				updateDefaultCurrency();
			}
		}

		private function populateUnauthorisedCurrencies(note:INotification):void {
			var allCurrencies:ArrayCollection=note.getBody() as ArrayCollection;
			if (brokerOffice != null) {
				for each (var authorisedCurrency:String in brokerOffice.authorisedCurrencies) {
					removeCurrency(authorisedCurrency, allCurrencies);
				}
				var currencySort:Sort=new Sort();
				currencySort.fields=[new SortField("name", false)];
				allCurrencies.sort=currencySort;
				allCurrencies.refresh();
				brokerOfficeDetailVBox.allCurrencies.dataProvider=allCurrencies;
			}
		}

		private function updateDefaultCurrency():void {
			var currentCcy:String=brokerOffice.defaultCurrency;
			for each (var ccy:Currency in brokerOfficeDetailVBox.cboDefaultCurrency.dataProvider) {
				if (ccy.isoCode == currentCcy) {
					brokerOfficeDetailVBox.cboDefaultCurrency.selectedItem=ccy;
					break;
				}
			}
		}

		private function removeCurrency(authorisedCurrency:String, allCurrencies:IList):void {
			for each (var currency:Currency in allCurrencies) {
				if (currency.isoCode == authorisedCurrency) {
					allCurrencies.removeItemAt(allCurrencies.getItemIndex(currency));
				}
			}
		}

		private function updateCountryOfRisk(note:INotification):void {
			brokerOfficeDetailVBox.cboCountryOfRisk.dataProvider=note.getBody();
			if (brokerOffice) {
				brokerOfficeDetailVBox.cboCountryOfRisk.selectedItem=brokerOffice.countryOfRisk;
				this.onCountryOfRiskChange();
			}
		}

		private function onSaveBrokerOfficeComplete(note:INotification):void {
			for each (var sourceAssociation:SourceAssociation in sourceAssociations) {
				sourceAssociation.brokerOffice=note.getBody() as BrokerOffice;
				for each (var ss:SourceSystemCheckBox in brokerOfficeDetailVBox.sourceSystemCheckBoxes) {
					if (sourceAssociation.sourceSystem.sid == ss.cbxSelect.data.sid) {
						sourceAssociation.externalBrokerId=(ss.txiExternalBrokerId.text.length > 0) ? ss.txiExternalBrokerId.text : null;
					}
				}
			}
			sendNotification(ApplicationFacade.SAVE_SOURCE_ASSOCIATION, sourceAssociations);
		}

		private function onSaveSourceAssociationComplete(note:INotification):void {
			reloadBrokerOfficeAfterSave((note.getBody() as ArrayCollection)[0].brokerOffice);
		}

		private function populateSourceSystem(note:INotification):void {
			brokerOfficeDetailVBox.fmiSourceSystem.removeAllChildren();
			var sourceSystemCheckBoxes:ListCollectionView=new ArrayCollection();
			for each (var sourceSystem:SourceSystem in note.getBody()) {
				var ss:SourceSystemCheckBox=new SourceSystemCheckBox();
				brokerOfficeDetailVBox.fmiSourceSystem.addChild(ss);
				ss.cbxSelect.data=sourceSystem;
				ss.cbxSelect.label=sourceSystem.name;
				sourceSystemCheckBoxes.addItem(ss);
				ss.cbxSelect.addEventListener(MouseEvent.CLICK, onSourceSystemChange);
			}
			brokerOfficeDetailVBox.sourceSystemCheckBoxes=sourceSystemCheckBoxes;
			updateSourceAssociations();
		}

		protected function onSourceSystemChange(event:Event):void {
			if (event.currentTarget.selected) {
				var sa:SourceAssociation=new SourceAssociation();
				sa.sourceSystem=event.currentTarget.data as SourceSystem;
				sourceAssociations.addItem(sa);
			} else {
				for each (var source:SourceAssociation in sourceAssociations) {
					if (!source.sid && source.sourceSystem.sid == event.currentTarget.data.sid) {
						sourceAssociations.removeItemAt(sourceAssociations.getItemIndex(source));
						return;
					}
				}
			}
		}

		private function populateSourceAssociation(note:INotification):void {
			if (note.getBody() && (note.getBody() as ArrayCollection).length) {
				sourceAssociations=(note.getBody() as ArrayCollection);
				updateSourceAssociations();
			}
		}

		private function updateSourceAssociations():void {
			for each (var ss:SourceSystemCheckBox in brokerOfficeDetailVBox.sourceSystemCheckBoxes) {
				var selected:Boolean=false;
				var externalBrokerId:String=null;
				for each (var sourceAssociation:SourceAssociation in sourceAssociations) {
					if (sourceAssociation.sourceSystem.sid == ss.cbxSelect.data.sid) {
						selected=true;
						externalBrokerId=sourceAssociation.externalBrokerId;
					}
				}
				ss.cbxSelect.selected=selected;
				ss.cbxSelect.enabled=!selected;
				ss.txiExternalBrokerId.text=externalBrokerId;
			}
		}

		private function reloadBrokerOfficeAfterSave(brokerOffice:BrokerOffice):void {
			sendNotification(ApplicationFacade.LOAD_BROKER_OFFICE, brokerOffice);
			(facade.retrieveProxy(BrokerProxy.NAME) as BrokerProxy).listBrokerOfficesForUser();
			Alert.show(rm.getString(RB_ui.RB_NAME, RB_ui.BROKER_OFFICE_DETAIL_VIEW_MEDIATOR_SAVE_BROKER_OFFICE_MESSAGE), rm.getString(RB_ui.RB_NAME, RB_ui.BROKER_OFFICE_DETAIL_VIEW_MEDIATOR_SAVE_BROKER_OFFICE_TITLE));
		}

		private function updateMasterOffices(note:INotification):void {
			brokerOfficeDetailVBox.cboMasterOffice.dataProvider=buildMasterOfficeCollection(note);
			if (brokerOffice != null) {
				brokerOfficeDetailVBox.cboMasterOffice.selectedItem=brokerOffice.masterOffice;
			}
		}

		private function buildMasterOfficeCollection(note:INotification):ArrayCollection {
			if (note.getBody() && (note.getBody() as ArrayCollection).length) {
				var validMasterBrokers:ArrayCollection=new ArrayCollection((note.getBody() as ArrayCollection).source);
				if (brokerOffice != null) {
					// Prevent a broker from being selected as its own master and two brokers being each others master 
					for (var index:int=validMasterBrokers.length - 1; index >= 0; index--) {
						if (brokerOffice.sid == validMasterBrokers[index].sid || (validMasterBrokers[index].masterOffice != null && validMasterBrokers[index].masterOffice.sid == brokerOffice.sid)) {
							validMasterBrokers.removeItemAt(index);
						}
					}
				}
				var masterBrokers:Sort=new Sort();
				masterBrokers.fields=[new SortField("name", false)];
				validMasterBrokers.sort=masterBrokers;
				validMasterBrokers.refresh();
				return validMasterBrokers;
			} else {
				return note.getBody() as ArrayCollection;
			}
		}

		private function updateUnderwriters(note:INotification):void {
			brokerOfficeDetailVBox.cboUnderwriter.dataProvider=note.getBody();
		}

		private function updateFrameOriginatingOffices(note:INotification):void {
			brokerOfficeDetailVBox.cboFrameOriginatingOffice.dataProvider=note.getBody();
		}

		private function onChangePostcodeToLookup(event:Event):void {
			if (brokerOfficeDetailVBox.txiPostcodeToLookup.text == "") {
				brokerOfficeDetailVBox.btnLookupAddress.enabled=false;
			} else {
				brokerOfficeDetailVBox.btnLookupAddress.enabled=true;
			}
		}

		protected function onDefaultCurrencyChange(event:FlexEvent):void {
			if (brokerOffice != null && brokerOfficeDetailVBox.cboDefaultCurrency.selectedItem != null) {
				brokerOfficeDetailVBox.limitCurrency=(brokerOfficeDetailVBox.cboDefaultCurrency.selectedItem as Currency).isoCode;
			}
		}

		protected function onDropAuthorisedCurrency(event:DragEvent):void {
			var src:List=(event.dragInitiator) as List;
			if (src == brokerOfficeDetailVBox.authorisedCurrencies) {
				return;
			}
			var allCurrencies:IList=brokerOfficeDetailVBox.allCurrencies.dataProvider as IList;
			var authorisedCurrencies:IList=brokerOfficeDetailVBox.authorisedCurrencies.dataProvider as IList;
			authorisedCurrencies.addItem(brokerOfficeDetailVBox.allCurrencies.selectedItem as Currency);
			allCurrencies.removeItemAt(brokerOfficeDetailVBox.allCurrencies.selectedIndex);
		}

		protected function onRemoveCurrency(event:DragEvent):void {
			var src:List=(event.dragInitiator) as List;
			if (src == brokerOfficeDetailVBox.allCurrencies) {
				return;
			}
			var allCurrencies:IList=brokerOfficeDetailVBox.allCurrencies.dataProvider as IList;
			var authorisedCurrencies:IList=brokerOfficeDetailVBox.authorisedCurrencies.dataProvider as IList;
			var selectedCurrency:Currency=brokerOfficeDetailVBox.authorisedCurrencies.selectedItem as Currency;
			var defaultCurrency:Currency=brokerOfficeDetailVBox.cboDefaultCurrency.selectedItem as Currency;

			allCurrencies.addItem(selectedCurrency);
			authorisedCurrencies.removeItemAt(brokerOfficeDetailVBox.authorisedCurrencies.selectedIndex);
			if (defaultCurrency != null && selectedCurrency.isoCode == defaultCurrency.isoCode) {
				brokerOfficeDetailVBox.cboDefaultCurrency.selectedItem=null;
			}

		}

		private function onLoadBrokerOffice(note:INotification):void {
			fieldValidator.reset();
			brokerOffice=note.getBody() as BrokerOffice;
			brokerOffice.refreshOfBrokerDocumentsRequired=false;

			if (brokerOffice.address.country == null) {
				brokerOffice.address.country=brokerOffice.countryOfRisk != null ? 
					brokerOffice.countryOfRisk.getCountry() 
					: null;
			}

			addressMediator.address=brokerOffice.address;
			if (brokerOffice.countryOfRisk != null) {
				addressMediator.country=brokerOffice.countryOfRisk != null ? 
					brokerOffice.countryOfRisk.getCountry() 
					: null;
			}

			brokerOfficeDetailVBox.txiBrokerName.text=brokerOffice.name;
			brokerOfficeDetailVBox.txiBrokerCode.text=brokerOffice.brokerCode;
			brokerOfficeDetailVBox.cboMasterOffice.selectedItem=brokerOffice.masterOffice;
			brokerOfficeDetailVBox.cboUnderwriter.selectedItem=brokerOffice.underwriter;
			brokerOfficeDetailVBox.cboFrameOriginatingOffice.selectedItem=brokerOffice.frameOriginatingOffice;
			brokerOfficeDetailVBox.cboCountryOfRisk.selectedItem=brokerOffice.countryOfRisk;
			if (brokerOffice.countryOfRisk is Region)
				brokerOfficeDetailVBox.cboDefaultCountryOfRisk.selectedItem=brokerOffice.countryOfRisk.getCountry();
			brokerOfficeDetailVBox.curPremiumLimitAnnual.data=brokerOffice.premiumLimitAnnual;
			brokerOfficeDetailVBox.curPremiumLimitSingle.data=brokerOffice.premiumLimitSingle;
			brokerOfficeDetailVBox.curMinimumPremiumAnnual.data=brokerOffice.minimumPremiumAnnual;
			brokerOfficeDetailVBox.curMinimumPremiumSingle.data=brokerOffice.minimumPremiumSingle;
			brokerOfficeDetailVBox.curMinimumNetApForMta.data=brokerOffice.minimumNetAdditionalPremium;
			brokerOfficeDetailVBox.numDaysToSettle.data=brokerOffice.settlementDays;
			brokerOfficeDetailVBox.pctDefaultCommission.data=brokerOffice.defaultCommission;
			brokerOfficeDetailVBox.cbxAdjustPremium.selected=brokerOffice.canAdjustPremium;
			brokerOfficeDetailVBox.pctDiscountCap.data=brokerOffice.discountCap;
			brokerOfficeDetailVBox.numLoading.data=brokerOffice.loadingRate;
			brokerOfficeDetailVBox.cbxWhiteLabel.selected=brokerOffice.lookAndFeel != null;
			brokerOfficeDetailVBox.txiLogoUrl.text=(brokerOffice.lookAndFeel != null ? brokerOffice.lookAndFeel.logoUrl : "");
			brokerOfficeDetailVBox.cprBackgroundColour.selectedColor=(brokerOffice.lookAndFeel != null ? brokerOffice.lookAndFeel.backgroundColour : 0);
			brokerOfficeDetailVBox.cprHeadingColour.selectedColor=(brokerOffice.lookAndFeel != null ? brokerOffice.lookAndFeel.headingColour : 0);
			brokerOfficeDetailVBox.cprKeyColour.selectedColor=(brokerOffice.lookAndFeel != null ? brokerOffice.lookAndFeel.keyColour : 0);
			brokerOfficeDetailVBox.cbxInvertKeyText.selected=(brokerOffice.lookAndFeel != null ? brokerOffice.lookAndFeel.invertKeyTextColour : false);
			brokerOfficeDetailVBox.cprSecondaryColour.selectedColor=(brokerOffice.lookAndFeel != null ? brokerOffice.lookAndFeel.secondaryColour : 0);
			brokerOfficeDetailVBox.cprMenuColour.selectedColor=(brokerOffice.lookAndFeel != null ? brokerOffice.lookAndFeel.menuColour : 0);
			brokerOfficeDetailVBox.cbxInvertMenuText.selected=(brokerOffice.lookAndFeel != null ? brokerOffice.lookAndFeel.invertMenuTextColour : false);
			brokerOfficeDetailVBox.cprSelectionColour.selectedColor=(brokerOffice.lookAndFeel != null ? brokerOffice.lookAndFeel.selectionColor : 0);
			brokerOfficeDetailVBox.cbxInvertSelectionText.selected=(brokerOffice.lookAndFeel != null ? brokerOffice.lookAndFeel.invertSelectionTextColour : false);
			brokerOfficeDetailVBox.cprRolloverColour.selectedColor=(brokerOffice.lookAndFeel != null ? brokerOffice.lookAndFeel.rolloverColour : 0);
			brokerOfficeDetailVBox.cbxInvertRolloverText.selected=(brokerOffice.lookAndFeel != null ? brokerOffice.lookAndFeel.invertRolloverTextColour : false);
			var emptyAuthorisedCurrencies:ArrayCollection=new ArrayCollection();
			brokerOfficeDetailVBox.authorisedCurrencies.dataProvider=emptyAuthorisedCurrencies;
			brokerOfficeDetailVBox.cboDefaultCurrency.dataProvider=emptyAuthorisedCurrencies;
			brokerOfficeDetailVBox.cboDefaultCurrency.selectedItem=null;
			brokerOfficeDetailVBox.limitCurrency="";
			brokerOfficeDetailVBox.premiumTypeGroup.selectedValue=(brokerOffice.premiumType != null ? brokerOffice.premiumType : PremiumType.FNA);
			brokerOfficeDetailVBox.curDefaultMADPercentage.data=(isNaN(brokerOffice.defaultMADPercentage) ? 100 : brokerOffice.defaultMADPercentage);
			brokerOfficeDetailVBox.cbxArchived.selected=!brokerOffice.enabled;
			brokerOfficeDetailVBox.cbxShowContactUsDetails.selected=brokerOffice.showContactUsDetails;
			brokerOfficeDetailVBox.cboDomesticTransitBOV.selectedItem=brokerOffice.defaultBoVDomesticTransit;
			brokerOfficeDetailVBox.cbxDebitNoteAvailable.selected=brokerOffice.debitNoteAvailable;

			brokerOfficeDetailVBox.txiDateCreated.text=df.format(brokerOffice.createdDate);

			if (brokerOffice.sid) {
				(facade.retrieveProxy(SourceAssociationProxy.NAME) as SourceAssociationProxy).listSourceAssociations(brokerOffice);
				(facade.retrieveProxy(HistoryProxy.NAME) as HistoryProxy).listBrokerHistory(brokerOffice.sid);
			} else {
				sourceAssociations=new ArrayCollection();
				var sa:SourceAssociation=new SourceAssociation();
				for each (var ss:SourceSystemCheckBox in brokerOfficeDetailVBox.sourceSystemCheckBoxes) {
					if (ss.cbxSelect.data.channel == Channel.WEB) {
						sa.sourceSystem=ss.cbxSelect.data as SourceSystem;
					}
				}
				sourceAssociations.addItem(sa);
			}
			updateSourceAssociations();

			// Initalize master broker offices
			(facade.retrieveProxy(BrokerProxy.NAME) as BrokerProxy).listBrokerOfficesForUser();
			// Initalize authorised currencies
			(facade.retrieveProxy(CurrencyProxy.NAME) as CurrencyProxy).findAuthorisedCurrency(brokerOffice.authorisedCurrencies);
			// Initiate countries of risk
			(facade.retrieveProxy(CountryProxy.NAME) as CountryProxy).listCountriesOfRisk();
			// Initiate curencies
			(facade.retrieveProxy(CurrencyProxy.NAME) as CurrencyProxy).listCurrencies();

		}

		private function neq(s1:String, s2:String):Boolean {
			if (s1 == null && s2 == null)
				return false;
			if (s1 == null && s2 != null)
				return true;
			return !(s1 == s2);
		}

		private function onSave(event:FlexEvent):void {
			var addressValid:Boolean=addressMediator.validate();
			var brokerDetailFieldsValid:Boolean=fieldValidator.validate("brokerOfficeDetailVBox", brokerOfficeDetailVBox);
			if (brokerDetailFieldsValid && addressValid) {
				var underwriter:Underwriter=brokerOfficeDetailVBox.cboUnderwriter.selectedItem as Underwriter;
				brokerOffice.name=brokerOfficeDetailVBox.txiBrokerName.text;
				brokerOffice.brokerCode=brokerOfficeDetailVBox.txiBrokerCode.text;
				brokerOffice.masterOffice=brokerOfficeDetailVBox.cboMasterOffice.selectedItem as BrokerOffice;
				brokerOffice.underwriter=underwriter;
				brokerOffice.frameOriginatingOffice=brokerOfficeDetailVBox.cboFrameOriginatingOffice.selectedItem as FrameOriginatingOffice;
				brokerOffice.premiumLimitAnnual=Number(brokerOfficeDetailVBox.curPremiumLimitAnnual.data);
				brokerOffice.premiumLimitSingle=Number(brokerOfficeDetailVBox.curPremiumLimitSingle.data);
				brokerOffice.minimumPremiumAnnual=Number(brokerOfficeDetailVBox.curMinimumPremiumAnnual.data);
				brokerOffice.minimumPremiumSingle=Number(brokerOfficeDetailVBox.curMinimumPremiumSingle.data);
				brokerOffice.minimumNetAdditionalPremium=Number(brokerOfficeDetailVBox.curMinimumNetApForMta.data);
				brokerOffice.settlementDays=Number(brokerOfficeDetailVBox.numDaysToSettle.data);
				brokerOffice.defaultCommission=Number(brokerOfficeDetailVBox.pctDefaultCommission.data);
				brokerOffice.canAdjustPremium=brokerOfficeDetailVBox.cbxAdjustPremium.selected;
				brokerOffice.discountCap=Number(brokerOfficeDetailVBox.pctDiscountCap.data);
				brokerOffice.loadingRate=Number(brokerOfficeDetailVBox.numLoading.data);
				var territoryOfRisk:Territory = brokerOfficeDetailVBox.cboCountryOfRisk.selectedItem as Territory;
				brokerOffice.countryOfRisk=territoryOfRisk;
				if (brokerOffice.countryOfRisk is Region)
					(brokerOffice.countryOfRisk as Region).defaultTerritory = brokerOfficeDetailVBox.cboDefaultCountryOfRisk.selectedItem as Country;
				brokerOffice.defaultCurrency=(brokerOfficeDetailVBox.cboDefaultCurrency.selectedItem as Currency).isoCode;
				brokerOffice.originatingOfficeCode=underwriter.originatingOfficeCode;
				brokerOffice.premiumType=brokerOfficeDetailVBox.premiumTypeGroup.selectedValue as PremiumType;
				brokerOffice.defaultMADPercentage=Number(brokerOfficeDetailVBox.curDefaultMADPercentage.data);
				brokerOffice.defaultBoVDomesticTransit=brokerOfficeDetailVBox.cboDomesticTransitBOV.selectedItem as String;
				brokerOffice.authorisedCurrencies=new ArrayCollection();
				brokerOffice.enabled=!brokerOfficeDetailVBox.cbxArchived.selected;
				brokerOffice.showContactUsDetails=brokerOfficeDetailVBox.cbxShowContactUsDetails.selected;
				brokerOffice.debitNoteAvailable=brokerOfficeDetailVBox.cbxDebitNoteAvailable.selected;

				addressMediator.updateAddress(brokerOffice.address);

				for each (var authorised:Currency in brokerOfficeDetailVBox.authorisedCurrencies.dataProvider) {
					brokerOffice.authorisedCurrencies.addItem((authorised as Currency).isoCode);
				}

				// Reset the wordings document if:
				// - changing to white labelling
				// - changing from white labelling
				// - already white labelled but changing the logo url
				if ((brokerOffice.lookAndFeel == null && brokerOfficeDetailVBox.cbxWhiteLabel.selected) || (brokerOffice.lookAndFeel != null && !brokerOfficeDetailVBox.cbxWhiteLabel.selected) || (brokerOffice.lookAndFeel != null && brokerOfficeDetailVBox.cbxWhiteLabel.selected && neq(brokerOffice.lookAndFeel.logoUrl, brokerOfficeDetailVBox.txiLogoUrl.text))) {
					brokerOffice.refreshOfBrokerDocumentsRequired=true;
				}

				if (brokerOfficeDetailVBox.cbxWhiteLabel.selected) {
					if (brokerOffice.lookAndFeel == null) {
						brokerOffice.lookAndFeel=new LookAndFeel();
					}
					brokerOffice.lookAndFeel.logoUrl=(brokerOfficeDetailVBox.txiLogoUrl.text.length > 0) ? brokerOfficeDetailVBox.txiLogoUrl.text : null;
					brokerOffice.lookAndFeel.backgroundColour=brokerOfficeDetailVBox.cprBackgroundColour.selectedColor;
					brokerOffice.lookAndFeel.headingColour=brokerOfficeDetailVBox.cprHeadingColour.selectedColor;
					brokerOffice.lookAndFeel.keyColour=brokerOfficeDetailVBox.cprKeyColour.selectedColor;
					brokerOffice.lookAndFeel.invertKeyTextColour=brokerOfficeDetailVBox.cbxInvertKeyText.selected;
					brokerOffice.lookAndFeel.secondaryColour=brokerOfficeDetailVBox.cprSecondaryColour.selectedColor;
					brokerOffice.lookAndFeel.menuColour=brokerOfficeDetailVBox.cprMenuColour.selectedColor;
					brokerOffice.lookAndFeel.invertMenuTextColour=brokerOfficeDetailVBox.cbxInvertMenuText.selected;
					brokerOffice.lookAndFeel.selectionColor=brokerOfficeDetailVBox.cprSelectionColour.selectedColor;
					brokerOffice.lookAndFeel.invertSelectionTextColour=brokerOfficeDetailVBox.cbxInvertSelectionText.selected;
					brokerOffice.lookAndFeel.rolloverColour=brokerOfficeDetailVBox.cprRolloverColour.selectedColor;
					brokerOffice.lookAndFeel.invertRolloverTextColour=brokerOfficeDetailVBox.cbxInvertRolloverText.selected;
				} else {
					brokerOffice.lookAndFeel=null;
				}

				sendNotification(ApplicationFacade.SAVE_BROKER_OFFICE, brokerOffice);

			}
		}

		public function onLookAndFeelPreview(e:Event = null):void {
			
			var tmpLookAndFeel:LookAndFeel = new LookAndFeel();

			tmpLookAndFeel.logoUrl=(brokerOfficeDetailVBox.txiLogoUrl.text.length > 0) ? brokerOfficeDetailVBox.txiLogoUrl.text : null;
			tmpLookAndFeel.backgroundColour=brokerOfficeDetailVBox.cprBackgroundColour.selectedColor;
			tmpLookAndFeel.headingColour=brokerOfficeDetailVBox.cprHeadingColour.selectedColor;
			tmpLookAndFeel.keyColour=brokerOfficeDetailVBox.cprKeyColour.selectedColor;
			tmpLookAndFeel.invertKeyTextColour=brokerOfficeDetailVBox.cbxInvertKeyText.selected;
			tmpLookAndFeel.secondaryColour=brokerOfficeDetailVBox.cprSecondaryColour.selectedColor;
			tmpLookAndFeel.menuColour=brokerOfficeDetailVBox.cprMenuColour.selectedColor;
			tmpLookAndFeel.invertMenuTextColour=brokerOfficeDetailVBox.cbxInvertMenuText.selected;
			tmpLookAndFeel.selectionColor=brokerOfficeDetailVBox.cprSelectionColour.selectedColor;
			tmpLookAndFeel.invertSelectionTextColour=brokerOfficeDetailVBox.cbxInvertSelectionText.selected;
			tmpLookAndFeel.rolloverColour=brokerOfficeDetailVBox.cprRolloverColour.selectedColor;
			tmpLookAndFeel.invertRolloverTextColour=brokerOfficeDetailVBox.cbxInvertRolloverText.selected;
			
			ApplicationFacade.getInstance().configureStyle(tmpLookAndFeel); 
			ApplicationFacade.getInstance().sendNotification(ApplicationFacade.LF_PREVIEW_LOGO, tmpLookAndFeel.logoUrl);
			
			var titleWin:LookAndFeelPreviewTitleWindow  = new LookAndFeelPreviewTitleWindow();
			titleWin.addEventListener("close",removePopup);
			
			titleWin.setStyle("modalTransparency", 0);
			titleWin.setStyle("modalTransparencyBlur", 0);
			
			PopUpManager.addPopUp(titleWin,Application.application as Sprite,true);
			PopUpManager.centerPopUp(titleWin);
			
			function removePopup():void
			{
				ApplicationFacade.getInstance().configureStyle(ApplicationFacade.getInstance().userInfo.lookAndFeel);
				PopUpManager.removePopUp(titleWin);
				ApplicationFacade.getInstance().sendNotification(ApplicationFacade.LF_RESET_LOGO);
			}
		}
	}
}
