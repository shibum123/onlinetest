package com.catlin.cargo.view.address {
	import com.catlin.cargo.bundles.CargoLocaleConstants;
	import com.catlin.cargo.bundles.RB_ui;
	
	import mx.controls.TextInput;

	public class PostcodeValidator {

		public static const FALSE:uint=0;
		public static const TRUE:uint=1;

		public static var POSTCODE_FORMAT_AU:String="NNNN";
		public static var POSTCODE_FORMAT_SG:String="NNNNNN";
		public static var POSTCODE_FORMAT_MT:String="AAA NNNN";
		public static var POSTCODE_FORMAT_US:String="NNNNN-NNNN";
		

		public static var POSTCODE_FORMAT_REXP_AU:String="^[0-9]{4}$";
		public static var POSTCODE_FORMAT_REXP_SG:String="^[0-9]{6}$";
		public static var POSTCODE_FORMAT_REXP_MT:String="^[A-Za-z]{3}[ ]?[0-9]{4}$";
		public static var POSTCODE_FORMAT_REXP_GB:String="^((([A-Z][0-9][0-9]?)|([A-Z][A-Z][0-9][0-9]?)|([A-Z][0-9][A-Z])|([A-Z][A-Z][0-9][A-Z]))[ ]{0,1}[0-9][A-Z]{2})$|^(GIR[ ]?0AA)$";
		public static var POSTCODE_FORMAT_REXP_US:String="^^[0-9]{5}(-[0-9]{4})?$";
		
		private var postcodeValidators:Object={
			AU: [RB_ui.rm.getString(RB_ui.RB_NAME, RB_ui.POSTCODE_VALIDATOR_FORMAT_MESSAGE, [RB_ui.rm.getString(RB_ui.RB_NAME, RB_ui.POSTAL_CODE(CargoLocaleConstants.COUNTRY_ISO_AU)) ,POSTCODE_FORMAT_AU]), 
				POSTCODE_FORMAT_REXP_AU], 
			SG: [RB_ui.rm.getString(RB_ui.RB_NAME, RB_ui.POSTCODE_VALIDATOR_FORMAT_MESSAGE, [RB_ui.rm.getString(RB_ui.RB_NAME, RB_ui.POSTAL_CODE(CargoLocaleConstants.COUNTRY_ISO_SG)) ,POSTCODE_FORMAT_SG]), 
				POSTCODE_FORMAT_REXP_SG], 
			MT: [RB_ui.rm.getString(RB_ui.RB_NAME, RB_ui.POSTCODE_VALIDATOR_FORMAT_MESSAGE, [RB_ui.rm.getString(RB_ui.RB_NAME, RB_ui.POSTAL_CODE(CargoLocaleConstants.COUNTRY_ISO_MT)) ,POSTCODE_FORMAT_MT]), 
				POSTCODE_FORMAT_REXP_MT], 
			GB: [RB_ui.rm.getString(RB_ui.RB_NAME, RB_ui.POSTCODE_VALIDATOR_FORMAT_MESSAGE, [RB_ui.rm.getString(RB_ui.RB_NAME, RB_ui.POSTAL_CODE(CargoLocaleConstants.COUNTRY_ISO_GB)) ,POSTCODE_FORMAT_MT]), 
				POSTCODE_FORMAT_REXP_GB],
			US: [RB_ui.rm.getString(RB_ui.RB_NAME, RB_ui.POSTCODE_VALIDATOR_FORMAT_MESSAGE, [RB_ui.rm.getString(RB_ui.RB_NAME, RB_ui.POSTAL_CODE(CargoLocaleConstants.COUNTRY_ISO_US)) ,POSTCODE_FORMAT_US]), 
				POSTCODE_FORMAT_REXP_US]
			
		};

		public function validate(postcodeComponent:TextInput, country:String):uint {
			var text:String=postcodeComponent.text;
			postcodeComponent.errorString="";
			postcodeComponent.styleName=null;
			if (text != null && text.length > 0) {
				var validator:Array=postcodeValidators[country];
				if (validator != null && text.match(validator[1]) == null) {
					postcodeComponent.errorString=validator[0];
					postcodeComponent.styleName="cargoErrorStyle";
					return TRUE;
				}
			}
			return FALSE;
		}

	}
}
