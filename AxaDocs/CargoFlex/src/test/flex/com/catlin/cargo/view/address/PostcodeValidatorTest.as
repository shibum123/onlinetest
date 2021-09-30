package com.catlin.cargo.view.address {
	import mx.controls.TextInput;
	
	import flexunit.framework.TestCase;

	[ResourceBundle("resources_ui")]
	public class PostcodeValidatorTest extends TestCase {

		public static const FALSE:uint = 0;
		public static const TRUE:uint = 1;

		private var postcodeComponent:TextInput;
		private var postcodeValidator:PostcodeValidator = new PostcodeValidator();

		public function validate(postcodeComponent:TextInput, country:String):uint {
			return postcodeValidator.validate(postcodeComponent, country);
		}

		private function setUpPostcodeComponent(postcode:String):void {
			postcodeComponent = new TextInput();
			postcodeComponent.text = postcode;
		}

		public function testShouldIgnoreBlankPostCodes():void {
			var postcodeComponent:TextInput = new TextInput();
			postcodeComponent.text = "";
			assertEquals(FALSE, validate(postcodeComponent, "AU"));
		}

		public function testShouldIgnoreUnsuportedPostCodes():void {
			var postcodeComponent:TextInput = new TextInput();
			postcodeComponent.text = "";
			assertEquals(FALSE, validate(postcodeComponent, "IE"));
		}

		public function testShouldValidateAuPostCodesToNNNNFormat():void {
			var result:uint;
			var country:String = "AU";
			setUpPostcodeComponent("1234");
			result = validate(postcodeComponent, country);
			assertEquals(FALSE, result);
			assertEquals("", postcodeComponent.errorString);
			assertNull(postcodeComponent.styleName);

			setUpPostcodeComponent("AB12");
			result = validate(postcodeComponent, country);
			assertEquals(TRUE, result);
			assertNotNull(postcodeComponent.errorString);
			assertNotNull(postcodeComponent.styleName);
		}

		public function testShouldValidateMTPostCodesToAAASpaceNNNNFormat():void {
			var result:uint;
			var country:String = "MT";
			setUpPostcodeComponent("ABC 1234");
			result = validate(postcodeComponent, country);
			assertEquals(FALSE, result);
			assertEquals("", postcodeComponent.errorString);
			assertNull(postcodeComponent.styleName);

			setUpPostcodeComponent("ABC1234");
			result = validate(postcodeComponent, country);
			assertEquals(FALSE, result);
			assertEquals("", postcodeComponent.errorString);
			assertNull(postcodeComponent.styleName);

			setUpPostcodeComponent("ABC  1234");
			result = validate(postcodeComponent, country);
			assertEquals(TRUE, result);
			assertNotNull(postcodeComponent.errorString);
			assertNotNull(postcodeComponent.styleName);
		}

		public function testShouldValidateSGPostCodesNNNNNNFormat():void {
			var result:uint;
			var country:String = "SG";
			setUpPostcodeComponent("123456");
			result = validate(postcodeComponent, country);
			assertEquals(FALSE, result);
			assertEquals("", postcodeComponent.errorString);
			assertNull(postcodeComponent.styleName);

			setUpPostcodeComponent("12345");
			result = validate(postcodeComponent, country);
			assertEquals(TRUE, result);
			assertNotNull(postcodeComponent.errorString);
			assertNotNull(postcodeComponent.styleName);

			setUpPostcodeComponent("1234567");
			result = validate(postcodeComponent, country);
			assertEquals(TRUE, result);
			assertNotNull(postcodeComponent.errorString);
			assertNotNull(postcodeComponent.styleName);

		}

		public function testShouldValidateUKFormat():void {
			var result:uint;
			var country:String = "GB";
			setUpPostcodeComponent("BX3 2BB");
			assertEquals(FALSE, validate(postcodeComponent, country));
			setUpPostcodeComponent("BX3 2BB")
			assertEquals(FALSE, validate(postcodeComponent, country));
			setUpPostcodeComponent("CF99 1NA")
			assertEquals(FALSE, validate(postcodeComponent, country));
			setUpPostcodeComponent("E16 1XL")
			assertEquals(FALSE, validate(postcodeComponent, country));
			setUpPostcodeComponent("N1 9GU")
			assertEquals(FALSE, validate(postcodeComponent, country));
			setUpPostcodeComponent("EC2N 2DB")
			assertEquals(FALSE, validate(postcodeComponent, country));
			setUpPostcodeComponent("S6 1SW")
			assertEquals(FALSE, validate(postcodeComponent, country));
			setUpPostcodeComponent("W1D 4FA")
			assertEquals(FALSE, validate(postcodeComponent, country));

			setUpPostcodeComponent("A99AAAAA")
			assertEquals(TRUE, validate(postcodeComponent, country));
		}

		public function testShouldValidateUKFormatForNonGeographicalPostcodeForGiroBank():void {
			var result:uint;
			var country:String = "GB";
			setUpPostcodeComponent("GIR 0AA")
			assertEquals(FALSE, validate(postcodeComponent, country));
		}
		
		public function testShouldValidateUsPostCodesFormat():void {
			var result:uint;
			var country:String = "US";
			// Short PostCode
			setUpPostcodeComponent("10001");
			result = validate(postcodeComponent, country);
			assertEquals(FALSE, result);
			assertEquals("", postcodeComponent.errorString);
			assertNull(postcodeComponent.styleName);

			// Extended PostCode
			setUpPostcodeComponent("10001-1001");
			result = validate(postcodeComponent, country);
			assertEquals(FALSE, result);
			assertEquals("", postcodeComponent.errorString);
			assertNull(postcodeComponent.styleName);

			setUpPostcodeComponent("AB12C");
			result = validate(postcodeComponent, country);
			assertEquals(TRUE, result);
			assertNotNull(postcodeComponent.errorString);
			assertNotNull(postcodeComponent.styleName);
			
			setUpPostcodeComponent("10001-ABCD");
			result = validate(postcodeComponent, country);
			assertEquals(TRUE, result);
			assertNotNull(postcodeComponent.errorString);
			assertNotNull(postcodeComponent.styleName);			
		}		


	}
}