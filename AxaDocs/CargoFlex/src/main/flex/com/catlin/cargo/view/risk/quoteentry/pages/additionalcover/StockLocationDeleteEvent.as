package com.catlin.cargo.view.risk.quoteentry.pages.additionalcover {
	import flash.events.Event;

	public class StockLocationDeleteEvent extends Event {

		public static const DELETE_STOCK_LOCATION:String="delete_stock_location";

		protected var _index:int;

		public function StockLocationDeleteEvent(index:int, bubbles:Boolean=false, cancelable:Boolean=false) {
			super(DELETE_STOCK_LOCATION, bubbles, cancelable);
			_index=index;
		}

		public function get index():int {
			return _index;
		}
	}
}
