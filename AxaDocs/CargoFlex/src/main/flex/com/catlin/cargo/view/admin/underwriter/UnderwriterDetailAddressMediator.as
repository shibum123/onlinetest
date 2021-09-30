package com.catlin.cargo.view.admin.underwriter {
	import com.catlin.cargo.bundles.CargoLocaleConstants;
	import com.catlin.cargo.bundles.RB_ui;
	import com.catlin.cargo.model.core.originatingoffice.OriginatingOfficeCode;
	import com.catlin.cargo.model.reference.country.Country;
	import com.catlin.cargo.validation.ValidationUtil;
	import com.catlin.cargo.view.address.AddressMediator;
	import com.catlin.cargo.view.address.IAddressView;
	
	import org.puremvc.as3.interfaces.IMediator;
	
	public class UnderwriterDetailAddressMediator extends AddressMediator implements IMediator {
		
		public static const NAME:String = "UnderwriterDetailAddressMediator";
		
		public function UnderwriterDetailAddressMediator(view:IAddressView) {
			super(NAME, this, view);
		}
		
		/*
		 * A quick solution for using appropriate country address formatting rules
		 * for the different originating offices.
		 */
		public function set originatingOfficeCode(originatingOfficeCode:OriginatingOfficeCode):void {
			switch (originatingOfficeCode) {
				case OriginatingOfficeCode.UK:
					country = getCountry(CargoLocaleConstants.COUNTRY_ISO_GB);
					break;
				case OriginatingOfficeCode.HK:
					country = getCountry(CargoLocaleConstants.COUNTRY_ISO_HK);
					break;
				case OriginatingOfficeCode.SG:
					country = getCountry(CargoLocaleConstants.COUNTRY_ISO_SG);
					break;
				case OriginatingOfficeCode.US:
					country = getCountry(CargoLocaleConstants.COUNTRY_ISO_US);
					break;
			}
		}
		
		private function getCountry(isoCode:String):Country {
			if (allCountries != null) {
				for (var i:int = 0; i < allCountries.length; i++) {
					var country:Country = allCountries.getItemAt(i) as Country;
					if (country.isoCode == isoCode) {
						return country;
					}
				}
				throw new Error("Could not find country for iso code: " + isoCode);
			}
			return null;
		}
		
		/**
		 * Validates the address fields, returning <code>true</code>
		 * if the validation succeeds, or <code>false</code> if there are any errors.
		 */
		override public function validate():Boolean {
			var errors:uint = FALSE;
			
			errors |= ValidationUtil.valueRequired(
				addressView.addressLine1Component, 
				rm.getString(RB_ui.RB_NAME, RB_ui.ADDRESS_MEDIATOR_VALIDATION_REQUIRED_ADDRESS));
			
			errors |= ValidationUtil.valueRequired(
				addressView.townCityComponent, 
				rm.getString(RB_ui.RB_NAME, RB_ui.ADDRESS_MEDIATOR_VALIDATION_REQUIRED_CITY));
			
			errors |= ValidationUtil.valueRequired(
						addressView.postcodeComponent, 
						rm.getString(RB_ui.RB_NAME, RB_ui.ADDRESS_MEDIATOR_VALIDATION_REQUIRED_POSTCODE));
			
			return errors == FALSE;
		}	
		
	}
}