package com.catlin.cargo.view.address {
	import org.puremvc.as3.interfaces.IMediator;
	
	public class InsuredWindowAddressMediator extends AddressMediator implements IMediator {
		
		public static const NAME:String="InsuredCaptureAddressMediator";
		
		public function InsuredWindowAddressMediator(view:IAddressView) {
			super(NAME, this, view);
		}
		
		protected override function get name():String {
			return NAME;
		}
	}
}