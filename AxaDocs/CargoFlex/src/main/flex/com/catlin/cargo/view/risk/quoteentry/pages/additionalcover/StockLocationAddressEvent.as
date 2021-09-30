package com.catlin.cargo.view.risk.quoteentry.pages.additionalcover {
	import flash.events.Event;

	public class StockLocationAddressEvent extends Event {

		public static const STOCK_LOCATION_ADDRESS_ENTER:String="stock_location_address_enter";
		public static const STOCK_LOCATION_ADDRESS_EDIT:String="stock_location_address_edit";

		protected var _index:int;

		public function StockLocationAddressEvent(type:String, index:int, bubbles:Boolean=true, cancelable:Boolean=false) {
			super(type, bubbles, cancelable);
			_index=index;
		}

		public function get index():int {
			return _index;
		}
	}
}
