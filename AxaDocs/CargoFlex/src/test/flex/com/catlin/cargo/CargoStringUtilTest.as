package com.catlin.cargo {
	import flexunit.framework.TestCase;

	public class CargoStringUtilTest extends TestCase {

		public function testShouldReturnNullIfEmpty():void {
			assertNull(CargoStringUtil.nullIfEmpty(""));
		}
		
		public function testShouldReturnNullIfNull():void {
			assertNull(CargoStringUtil.nullIfEmpty(null));
		}
		
		public function testShouldReturnValueIfNotNullAndNotEmpty():void {
			assertEquals("foo", CargoStringUtil.nullIfEmpty("foo"));
		}

	}
}