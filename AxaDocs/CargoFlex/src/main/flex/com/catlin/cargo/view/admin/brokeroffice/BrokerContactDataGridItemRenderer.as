package com.catlin.cargo.view.admin.brokeroffice {
	
	import com.catlin.cargo.model.core.party.Party;
	
	import mx.controls.dataGridClasses.DataGridItemRenderer;
	import mx.core.mx_internal;

	use namespace mx_internal;
	
	public class BrokerContactDataGridItemRenderer extends DataGridItemRenderer {

		override public function invalidateDisplayList():void {
			var party:Party = data as Party;
			if (party != null && !party.active) {
				explicitColor = getStyle("disabledColor");
			}
			super.invalidateDisplayList();
		}
	}
}
