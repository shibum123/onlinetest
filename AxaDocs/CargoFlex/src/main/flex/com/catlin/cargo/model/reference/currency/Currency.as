/**
 * Generated by Gas3 v2.2.0 (Granite Data Services).
 *
 * NOTE: this file is only generated if it does not exist. You may safely put
 * your custom code here.
 */

package com.catlin.cargo.model.reference.currency {

	[Bindable]
	[RemoteClass(alias="com.catlin.cargo.model.reference.currency.Currency")]
	public class Currency extends CurrencyBase {
		public function Currency(isoCode:String = null, name:String = null) {
			this.isoCode = isoCode;
			this.name = name;
		}
	}
}