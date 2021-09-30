package com.catlin.cargo.view.address {

	import com.catlin.cargo.ApplicationFacade;
	import com.catlin.cargo.CargoStringUtil;
	import com.catlin.cargo.bundles.CargoLocaleConstants;
	import com.catlin.cargo.bundles.RB_ui;
	import com.catlin.cargo.controller.PostcodeFetchCommand;
	import com.catlin.cargo.model.geo.address.Address;
	import com.catlin.cargo.model.proxy.CountryProxy;
	import com.catlin.cargo.model.reference.country.Country;
	import com.catlin.cargo.model.reference.country.Province;
	import com.catlin.cargo.validation.ValidationUtil;
	import com.catlin.cargo.view.BaseMediator;
	
	import flash.errors.IllegalOperationError;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.ui.Keyboard;
	
	import mx.collections.ArrayCollection;
	import mx.events.ListEvent;
	
	import org.puremvc.as3.interfaces.INotification;

	public class AddressMediator extends BaseMediator {

		protected static const FALSE:uint = 0;
		protected static const TRUE:uint = 1;

		/**
		 * Flags to avoid the
		 */
		public static const COUNTRY_MODE:uint = 0;
		public static const REGION_MODE:uint = 1;
		protected var countryProviderMode:uint = COUNTRY_MODE;
		
		protected var _country:Country;
		protected var _province:Province = null;

		protected var _allCountries:ArrayCollection;
		protected var _allProvinces:ArrayCollection;
		protected var _allRegionCountries:ArrayCollection;
		
		protected var postcodeValidator:PostcodeValidator = new PostcodeValidator();

		public function AddressMediator(_name:String, self:AddressMediator, viewComponent:IAddressView) {
			super(_name, viewComponent);

			/*
			 * Hack to get around lack of abstract classes in actionscript.
			 */
			if (self != this) {
				throw new IllegalOperationError("AddressMediator is an abstract type - use one of its sub-classes");
			}

			addressView.postcodeLookupActionComponent.addEventListener(MouseEvent.CLICK, onLookupAddress);
			addressView.postcodeLookupActionComponent.enabled = false;
			addressView.postcodeLookupTextComponent.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
			addressView.postcodeLookupTextComponent.addEventListener(Event.CHANGE, onChangePostcodeToLookup);
			addressView.postcodeLookupTextComponent.addEventListener(Event.CHANGE, changeHandlerToUpper);
			addressView.postcodeComponent.addEventListener(Event.CHANGE, changeHandlerToUpper);

			addressView.addressLine1FormItem.required = true;
			addressView.townCityFormItem.required = true;
			addressView.showCounty(false);

			if (addressView.countryComboBox != null) {
				addressView.countryComboBox.labelField = "name";
				addressView.countryComboBox.addEventListener(Event.CHANGE, onCountryChange);
			}

			if (addressView.provinceComboBox != null) {
				addressView.provinceComboBox.labelField = "name";
			}
		}

		public override function onRegister():void {
			super.onRegister();
			(facade.retrieveProxy(CountryProxy.NAME) as CountryProxy).listCountriesByName();
		}

		/**
		 * Validates the address fields, returning <code>true</code>
		 * if the validation succeeds, or <code>false</code> if there are any errors.
		 */
		public function validate():Boolean {
			var errors:uint = FALSE;

			errors |= ValidationUtil.valueRequired(
				addressView.addressLine1Component, 
				rm.getString(RB_ui.RB_NAME, RB_ui.ADDRESS_MEDIATOR_VALIDATION_REQUIRED_ADDRESS));

			errors |= ValidationUtil.valueRequired(
				addressView.townCityComponent, 
				rm.getString(RB_ui.RB_NAME, RB_ui.ADDRESS_MEDIATOR_VALIDATION_REQUIRED_CITY));

			if (_country != null) {

				if (addressView.provinceComboBox != null && 
					addressView.provinceComboBox.visible && 
					addressView.provinceComboBox.dataProvider != null &&
					AddressValidationImpl.provinceRequired(_country.isoCode) ) {
					errors |= ValidationUtil.valueRequired(
						addressView.provinceComboBox, 
						rm.getString(RB_ui.RB_NAME, RB_ui.ADDRESS_MEDIATOR_VALIDATION_REQUIRED_PROVINCE));
				}				

				var postcodeErrors:uint = FALSE;
				if (_country.isoCode == CargoLocaleConstants.COUNTRY_ISO_GB || _country.isoCode == CargoLocaleConstants.COUNTRY_ISO_US) {
					var postalCode:String = RB_ui.POSTAL_CODE(_country.isoCode);
					postcodeErrors |= ValidationUtil.valueRequired(
						addressView.postcodeComponent, 
						rm.getString(RB_ui.RB_NAME, RB_ui.ADDRESS_MEDIATOR_VALIDATION_REQUIRED_POSTCODE, [postalCode]));
				}
				if (postcodeErrors == FALSE) {
					postcodeErrors |= postcodeValidator.validate(addressView.postcodeComponent, _country.isoCode);
				}
				errors |= postcodeErrors;
			}

			return errors == FALSE;
		}

		/**
		* Runs on change converting all text to upper case
		*/
		public function changeHandlerToUpper(event:Event):void {
			event.target.text = event.target.text.toUpperCase();
		}

		private function onKeyDown(event:KeyboardEvent):void {
			if (event.charCode == Keyboard.ENTER) {
				onLookupAddress(null);
			}
		}

		private function onChangePostcodeToLookup(event:Event):void {
			if (addressView.postcodeLookupTextComponent.text == "") {
				addressView.postcodeLookupActionComponent.enabled = false;
			} else {
				addressView.postcodeLookupActionComponent.enabled = true;
			}
		}

		public function get addressView():IAddressView {
			return viewComponent as IAddressView;
		}

		/**
		 * Initialises the address fields from the passed address.
		 * Ensure that you also set country of risk iso code
		 * to initialise the proper visibility and validation
		 * of address fields.
		 */
		public function set address(address:Address):void {
			addressView.postcodeLookupTextComponent.text = "";
			addressView.addressLine1Component.text = address.addressLine1;
			addressView.addressLine2Component.text = address.addressLine2;
			addressView.addressLine3Component.text = address.addressLine3;
			addressView.townCityComponent.text = address.townCity;
			addressView.postcodeComponent.text = address.postcode;

			_province = address.province;
			if (!CargoStringUtil.isNullOrEmpty(address.county) && _province == null) {
				addressView.countyComponent.text = address.county;
				addressView.showCounty(true);
			} else {
				addressView.showCounty(false);
			}
			addressView.provinceComboBox.selectedItem = _province
			country = address.country;
		}

		/**
		 * Initialises proper visibility and validation of
		 * address fields based on the country of risk.
		 */
		public function set country(country:Country):void {
			this._country = country;

			// postcode and lookup rule
			if (country != null) {
				addressView.currentCountryIso = country.isoCode;
				if (country.isoCode == CargoLocaleConstants.COUNTRY_ISO_GB || country.isoCode == CargoLocaleConstants.COUNTRY_ISO_US) {
					addressView.showPostcodeLookup(true);
					addressView.postcodeFormItem.required = true;
				} else {
					addressView.showPostcodeLookup(false);
					addressView.postcodeFormItem.required = false;
				}

				if (_province != null)
					addressView.provinceComboBox.selectedItem = _province;

				(facade.retrieveProxy(CountryProxy.NAME) as CountryProxy).listProvincesByCountry(country);

				if (addressView.countryComboBox != null) {
					addressView.countryComboBox.selectedItem = country;
				}
			} else {
				addressView.currentCountryIso = ApplicationFacade.getInstance().sessionLocaleIsoCode; 
			}
		}

		private function updateCountry(note:INotification, dataProvider:ArrayCollection):void {

			if  (dataProvider == null)
				dataProvider = new ArrayCollection();
			else
				dataProvider.removeAll();
			
			dataProvider.addAll(note.getBody() as ArrayCollection);
			if (addressView.countryComboBox != null) {
				addressView.countryComboBox.dataProvider = dataProvider;
				if (_country != null) {
					addressView.countryComboBox.selectedItem = _country;
				}
			}
		}

		private function updateProvinces(note:INotification):void {
			_allProvinces = note.getBody() as ArrayCollection;
			if (addressView.provinceComboBox != null) {
				if (_allProvinces != null && _allProvinces.length > 0) {
					addressView.provinceComboBox.dataProvider = _allProvinces;
					if (_province != null) {
						addressView.provinceComboBox.selectedItem = _province;
					} else {
						addressView.provinceComboBox.prompt = "Select";
						addressView.provinceComboBox.selectedItem = null;
					}
				}
			}
		}

		public function updateAddress(_address:Address):void {
			_address.addressLine1 = CargoStringUtil.nullIfEmpty(addressView.addressLine1Component.text);
			_address.addressLine2 = CargoStringUtil.nullIfEmpty(addressView.addressLine2Component.text);
			_address.addressLine3 = CargoStringUtil.nullIfEmpty(addressView.addressLine3Component.text);
			_address.townCity = CargoStringUtil.nullIfEmpty(addressView.townCityComponent.text);
			_address.county = null;
			_address.postcode = CargoStringUtil.nullIfEmpty(addressView.postcodeComponent.text);
			_address.country = _country;
			var _selectedProvince:Province = addressView.provinceComboBox.selectedItem as Province;
			if (_selectedProvince) {
				_address.province = _selectedProvince;
			}
		}

		public function onLookupAddress(event:MouseEvent):void {
			sendNotification(ApplicationFacade.LOOKUP_POSTCODE, { code: addressView.postcodeLookupTextComponent.text, countryIsoCode: addressView.currentCountryIso });
		}

		override public function listNotificationInterests():Array {
			return [ PostcodeFetchCommand.POSTCODE_FETCH_COMPLETE,
					 CountryProxy.LIST_COUNTRIES_COMPLETE,
					 CountryProxy.LIST_PROVINCES_COMPLETE,
					 CountryProxy.LIST_COUNTRIES_OF_RISK_REGION_COMPLETE];
		}

		override public function handleNotification(note:INotification):void {
			switch (note.getName()) {
				case PostcodeFetchCommand.POSTCODE_FETCH_COMPLETE:
					var addressDetails:Object = (note.getBody() as Object);
					addressView.addressLine1Component.text = addressDetails.line1;
					addressView.addressLine2Component.text = addressDetails.line2;
					addressView.addressLine3Component.text = addressDetails.line3;
					addressView.townCityComponent.text = addressDetails.postTown;
					addressView.postcodeComponent.text = addressDetails.postcode;
					
					if (addressView.provinceComboBox != null) {
						var currentProvince:Province = null;
						if (_country && CargoLocaleConstants.COUNTRY_ISO_GB == _country.isoCode) {
							currentProvince = findProvinceAsCounty(addressDetails.county);
						} else {
							currentProvince = findProvince(addressDetails.provinceCode);
						}
						addressView.provinceComboBox.selectedItem = currentProvince;
					}

					break;
				case CountryProxy.LIST_COUNTRIES_COMPLETE:
					if (countryProviderMode == COUNTRY_MODE) 
						updateCountry(note, _allCountries);
					break;
				case CountryProxy.LIST_PROVINCES_COMPLETE:
					updateProvinces(note);
					break;
				case CountryProxy.LIST_COUNTRIES_OF_RISK_REGION_COMPLETE:
					if (countryProviderMode == REGION_MODE)
						updateCountry(note, _allRegionCountries);
					break;
			}
		}

		protected function get name():String {
			throw new Error("Override this method in a subclass");
		}

		protected function onCountryChange(event:ListEvent):void {
			var tmpCountry:Country = addressView.countryComboBox.selectedItem as Country; 
			country = tmpCountry;
			addressView.currentCountryIso = tmpCountry.isoCode;
		}

		protected function get allCountries():ArrayCollection {
			return _allCountries;
		}

		protected function get allProvinces():ArrayCollection {
			return _allProvinces;
		}
		
		protected function findProvince(provinceCode:String):Province {
			if (provinceCode == null || provinceCode.length == 0)
				return null;
			else
				provinceCode = provinceCode.toUpperCase();

			for each (var province:Province in allProvinces) {
				if (province.code.toUpperCase() == provinceCode) {
					return province;
				}
			}
			return null;
		}

		protected function findProvinceAsCounty(countyName:String):Province {
			if (countyName == null || countyName.length == 0)
				return null;
			else
				countyName = countyName.toUpperCase();

			var potentialMatches:ArrayCollection = new ArrayCollection();
			for each (var province:Province in allProvinces) {
				var currentCountyName:String = province.name.toUpperCase();
				if (currentCountyName == countyName) return province;

				if (currentCountyName.indexOf(countyName) >= 0) {
					potentialMatches.addItem(province);
				}
			}

			if (potentialMatches.length == 1)
				return potentialMatches.getItemAt(0) as Province;

			return null;
		}
		
		public function setCountryMode():void {
			countryProviderMode = COUNTRY_MODE;
			(facade.retrieveProxy(CountryProxy.NAME) as CountryProxy).listCountriesByName();
		}

		public function setRegionMode():void {
			countryProviderMode = REGION_MODE;
			if (addressView.countryComboBox != null && _allRegionCountries != null) {
				addressView.countryComboBox.dataProvider = _allRegionCountries;
			}			
		}

	}
}