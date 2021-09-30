package com.catlin.cargo.view.risk.quoteentry {
	import mx.collections.ArrayCollection;
	
	import flexunit.framework.TestCase;

	public class NearestValueCalculatorTest extends TestCase {

		private var deductibles:ArrayCollection = new ArrayCollection([ 0, 10, 15, 50, 100, 110 ]);
		private var exchangeRates:Object = { GBP: new Number(1)};
		private var calc:NearestValueCalculator = new NearestValueCalculator();

		public function testShouldReturnTheClosestMatch():void {
			calc.exchangeRates = { GBP: new Number(1)};
			assertEquals(0, calc.deriveDefault(0, "GBP", deductibles));
			assertEquals(0, calc.deriveDefault(1, "GBP", deductibles));
			assertEquals(10, calc.deriveDefault(5, "GBP", deductibles));
			assertEquals(10, calc.deriveDefault(10, "GBP", deductibles));
			assertEquals(15, calc.deriveDefault(16, "GBP", deductibles));
			assertEquals(15, calc.deriveDefault(25, "GBP", deductibles));
			assertEquals(100, calc.deriveDefault(75, "GBP", deductibles));
			assertEquals(110, calc.deriveDefault(210, "GBP", deductibles));
		}

		public function testShouldApplyCurrencyConversionCorrectly():void {
			calc.exchangeRates = exchangeRates;
			calc.exchangeRates = { GBP: new Number(2)};
			assertEquals(100, calc.deriveDefault(50, "GBP", deductibles));
		}

	}
}