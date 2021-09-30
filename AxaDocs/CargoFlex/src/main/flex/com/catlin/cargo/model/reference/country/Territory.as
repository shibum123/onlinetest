/**
 * Generated by Gas3 v2.2.0 (Granite Data Services).
 *
 * NOTE: this file is only generated if it does not exist. You may safely put
 * your custom code here.
 */

package com.catlin.cargo.model.reference.country {

    [Bindable]
    [RemoteClass(alias="com.catlin.cargo.model.reference.country.Territory")]
    public class Territory extends TerritoryBase {

		public function getCountry():Country {
			if (this is Country) {
				return this as Country;
			} else if (this is Region) {
				var tmoCountry:Country = (this as Region).defaultTerritory.getCountry(); 
				return tmoCountry;
			} else if (this is Province) {
				return (this as Province).parent as Country;
			} 
			return null;
		}
		
    }
}