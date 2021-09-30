package com.catlin.cargo.view.risk.quoteentry.pages.additionalcover {
	import com.catlin.cargo.view.address.AddressWindowMediator;
	import com.catlin.cargo.view.address.IAddressView;

	import org.puremvc.as3.interfaces.IMediator;

	public class StockLocationAddressWindowMediator extends AddressWindowMediator implements IMediator {

		public static const NAME:String="stockLocationAddressWindowMediator";
		public static const ADDRESS_ENTERED:String="stockLocationAddressWindowEntered";
		public static const ADDRESS_CANCELLED:String="stockLocationAddressWindowCancelled";

		public function StockLocationAddressWindowMediator(view:IAddressView) {
			super(NAME, this, view);
		}

		protected override function get enteredEventName():String {
			return ADDRESS_ENTERED;
		}

		protected override function get cancelledEventName():String {
			return ADDRESS_CANCELLED;
		}

		protected override function get name():String {
			return NAME;
		}

		protected override function get addressMediatorClass():Class {
			return StockLocationAddressWindowAddressMediator;
		}

		protected override function get addressMediatorName():String {
			return StockLocationAddressWindowAddressMediator.NAME;
		}

		public function showCountry(value:Boolean):void {
			addressWindow.showCountry(value);
		}
	}
}
