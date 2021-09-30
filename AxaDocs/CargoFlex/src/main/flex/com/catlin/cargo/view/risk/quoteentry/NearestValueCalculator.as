package com.catlin.cargo.view.risk.quoteentry {
	import mx.collections.ArrayCollection;

	public class NearestValueCalculator {

		private var _exchangeRate:Object;

		public function set exchangeRates(exchangeRate:Object):void {
			_exchangeRate=exchangeRate;
		}

		public function deriveDefault(defaultValue:Number, deductibleCurrency:String, deductibles:ArrayCollection):Number {
			defaultValue=convertDefaultToCurrency(deductibleCurrency, defaultValue);
			var previousNode:Number=0;

			for (var i:int=0; i < deductibles.length; i++) {
				var currentNode:Number=deductibles[i] as Number;
				if (currentNode == defaultValue) {
					return currentNode;
				}
				if (defaultValue > currentNode) {
					previousNode=currentNode;
					continue;
				}
				if (defaultValue < currentNode) {
					var upperbound:Number=currentNode - defaultValue;
					var lowerbound:Number=defaultValue - previousNode;
					if (upperbound > lowerbound) {
						return previousNode;
					}
					if (lowerbound >= upperbound) {
						return currentNode;
					}
				}
			}
			return previousNode;
		}

		private function convertDefaultToCurrency(deductibleCurrency:String, value:Number):Number {
			var exchangeRate:Number=_exchangeRate[deductibleCurrency];
			if (isNaN(value) || isNaN(exchangeRate) || exchangeRate == 0) {
				return NaN;
			}
			return Number((value * exchangeRate).toFixed(0));
		}
	}
}
