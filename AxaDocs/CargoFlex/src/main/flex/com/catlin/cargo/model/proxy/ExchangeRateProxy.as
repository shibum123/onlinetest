package com.catlin.cargo.model.proxy {
	import org.granite.tide.events.TideResultEvent;
	import org.puremvc.as3.interfaces.IProxy;

	public class ExchangeRateProxy extends BaseProxy implements IProxy {

		public static const NAME:String = "ExchangeRateProxy";
		public static const LIST_EXCHANGE_RATES_COMPLETE:String = "LIST_EXCHANGE_RATES_COMPLETE";


		public function ExchangeRateProxy() {
			super(NAME);
		}

		public function listExchangeRates(baseCurrency:String):void {
			tideContext.referenceDataService.listExchangeRates(baseCurrency, onListExchangeRates, onRemoteFault);
		}

		private function onListExchangeRates(event:TideResultEvent):void {
			sendNotification(LIST_EXCHANGE_RATES_COMPLETE, event.result);
		}
	}
}