/**
 * Generated by Gas3 v1.1.0 (Granite Data Services).
 *
 * NOTE: this file is only generated if it does not exist. You may safely put
 * your custom code here.
 */

package com.catlin.cargo.model.core.party {
	import com.catlin.cargo.model.geo.address.Address;

    [Bindable]
    [RemoteClass(alias="com.catlin.cargo.model.core.party.Party")]
    public class Party extends PartyBase {
    	
    	public function Party() {
    		active = true;
			address = new Address();
    	}
    }
}