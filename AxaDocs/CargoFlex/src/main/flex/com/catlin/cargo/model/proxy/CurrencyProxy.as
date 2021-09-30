package com.catlin.cargo.model.proxy {

	import mx.collections.ArrayCollection;
	import mx.collections.IList;
	import mx.collections.ListCollectionView;
	import mx.collections.Sort;
	import mx.collections.SortField;
	
	import org.granite.tide.events.TideResultEvent;
	import org.puremvc.as3.interfaces.IProxy;


	public class CurrencyProxy extends BaseProxy implements IProxy {

		public static const NAME:String = 'CurrencyProxy';
		public static const LIST_CURRENCIES_COMPLETE:String = 'listCurrenciesComplete';
		public static const LIST_AUTHORISED_CURRENCIES_COMPLETE:String = 'listAuthorisedCurrenciesComplete';


		public function CurrencyProxy() {
			super(NAME);
		}

		public function listCurrencies():void {
			tideContext.referenceDataService.listCurrencies(onListCurrencies, onRemoteFault);
		}

		public function findAuthorisedCurrency(isoCodes:IList):void {
			if (isoCodes != null && isoCodes.length > 0) {
				tideContext.referenceDataService.findCurrenciesByIsoCodes(new ArrayCollection(isoCodes.toArray()), onFindCurrencyByIsoCodes, onRemoteFault);
			}
		}

		private function onFindCurrencyByIsoCodes(event:TideResultEvent):void {
			var currencies:ArrayCollection = event.result as ArrayCollection;
			sortCurrenciesByName(currencies);
			sendNotification(LIST_AUTHORISED_CURRENCIES_COMPLETE, currencies);
		}

		private function onListCurrencies(event:TideResultEvent):void {
			var currencies:ArrayCollection = event.result as ArrayCollection;
			sortCurrenciesByName(currencies);
			sendNotification(LIST_CURRENCIES_COMPLETE, currencies);
		}

		private function sortCurrenciesByName(currencies:ListCollectionView):void {
			var currencySort:Sort = new Sort();
			currencySort.fields = [ new SortField("name", false)];
			currencies.sort = currencySort;
			currencies.refresh();
		}

	}
}

