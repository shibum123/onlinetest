package com.catlin.cargo.view.admin.brokeroffice {
	import com.catlin.cargo.bundles.CargoLocaleConstants;
	import com.catlin.cargo.bundles.RB_ui;
	import com.catlin.cargo.validation.ValidationUtil;
	import com.catlin.cargo.view.address.AddressMediator;
	import com.catlin.cargo.view.address.IAddressView;
	
	import org.puremvc.as3.interfaces.IMediator;
	
	public class BrokerOfficeDetailAddressMediator extends AddressMediator implements IMediator {
		
		public static const NAME:String = "BrokerOfficeDetailAddressMediator";
		
		public function BrokerOfficeDetailAddressMediator(view:IAddressView) {
			super(NAME, this, view);
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