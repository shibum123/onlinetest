package com.catlin.cargo.view.risk.quoteentry.pages.additionalcover {
	import com.catlin.cargo.view.address.AddressMediator;
	import com.catlin.cargo.view.address.IAddressView;

	import org.puremvc.as3.interfaces.IMediator;

	public class StockLocationAddressWindowAddressMediator extends AddressMediator implements IMediator {

		public static const NAME:String="StockLocationAddressWindowAddressMediator";

		public function StockLocationAddressWindowAddressMediator(view:IAddressView) {
			super(NAME, this, view);
		}

	}
}
