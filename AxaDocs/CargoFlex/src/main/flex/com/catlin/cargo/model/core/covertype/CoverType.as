/**
 * Generated by Gas3 v2.2.0 (Granite Data Services).
 *
 * NOTE: this file is only generated if it does not exist. You may safely put
 * your custom code here.
 */

package com.catlin.cargo.model.core.covertype {
	import com.catlin.cargo.ApplicationFacade;

	[Bindable]
	[RemoteClass(alias="com.catlin.cargo.model.core.covertype.CoverType")]
	public class CoverType extends CoverTypeBase {
		private var ctd:CoverTypeDefaults;

		public override function get defaultBasisOfValuation():String {
			var configuredValue:CoverTypeDefaults = null;
			if (defaultValues && defaultValues.get(ApplicationFacade.getInstance().sessionOriginatingOfficeCode) != null) {
				configuredValue = defaultValues.get(ApplicationFacade.getInstance().sessionOriginatingOfficeCode);
				return configuredValue.defaultBasisOfValuation;
			}
			return super.defaultBasisOfValuation;
		}

		public override function set defaultBasisOfValuation(value:String):void {
			var configuredValue:CoverTypeDefaults = null;
			if (defaultValues && defaultValues.get(ApplicationFacade.getInstance().sessionOriginatingOfficeCode) != null) {
				configuredValue = defaultValues.get(ApplicationFacade.getInstance().sessionOriginatingOfficeCode);
				configuredValue.defaultBasisOfValuation = value
			} else {
				super.defaultBasisOfValuation = value;
			}
		}

		public override function get basisOfValuationAdditionalInfo():String {
			var configuredValue:CoverTypeDefaults = null;
			if (defaultValues && defaultValues.get(ApplicationFacade.getInstance().sessionOriginatingOfficeCode) != null) {
				configuredValue = defaultValues.get(ApplicationFacade.getInstance().sessionOriginatingOfficeCode);
				return configuredValue.basisOfValuationAdditionalInfo;
			}
			return super.basisOfValuationAdditionalInfo;
		}

		public override function set basisOfValuationAdditionalInfo(value:String):void {
			var configuredValue:CoverTypeDefaults = null;
			if (defaultValues && defaultValues.get(ApplicationFacade.getInstance().sessionOriginatingOfficeCode) != null) {
				configuredValue = defaultValues.get(ApplicationFacade.getInstance().sessionOriginatingOfficeCode);
				configuredValue.basisOfValuationAdditionalInfo = value
			} else {
				super.basisOfValuationAdditionalInfo = value;
			}
		}

		public override function get name():String {
			var configuredValue:CoverTypeDefaults = null;
			if (defaultValues && defaultValues.get(ApplicationFacade.getInstance().sessionOriginatingOfficeCode) != null) {
				configuredValue = defaultValues.get(ApplicationFacade.getInstance().sessionOriginatingOfficeCode);
				return configuredValue.name;
			}
			return super.name;
		}

		public override function set name(value:String):void {
			var configuredValue:CoverTypeDefaults = null;
			if (defaultValues && defaultValues.get(ApplicationFacade.getInstance().sessionOriginatingOfficeCode) != null) {
				configuredValue = defaultValues.get(ApplicationFacade.getInstance().sessionOriginatingOfficeCode);
				configuredValue.name = value
			} else {
				super.name = value;
			}
		}
	}
}