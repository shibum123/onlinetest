package com.catlin.cargo.validation {
	
	import com.catlin.cargo.CargoStringUtil;
	
	import mx.controls.Alert;
	import mx.controls.ComboBox;
	import mx.controls.DateField;
	import mx.controls.TextArea;
	import mx.controls.TextInput;
	import mx.core.UIComponent;
	
	public class ValidationUtil 	{
		
		public static const FALSE:uint = 0;
		public static const TRUE:uint = 1;
		
		public function ValidationUtil() {
		}
		
		/**
		 * Validates that the selected value of the passed component is not null or empty string, returning TRUE if there is an error, 
		 * or FALSE if there is no error.
		 * <p/>
		 * The reason for using these kind of semantics with a simulated primitive boolean of a uint
		 * is that you typically want to run lots of validation checks, and then fail if any of them
		 * failed.  The way to do this with least code is as follows:
		 * <pre>
		 *   public function validate():Boolean {
		 *     var errors:uint = ValidationUtil.FALSE;
		 * 
		 *     errors |= ValidationUtils.valueRequired(field1, msg)
		 *       | ValidationUtils.valueRequired(field2, msg)
		 *       | ValidationUtils.valueRequired(field3, msg);
		 * 
		 *     return errors == ValidationUtil.FALSE;
		 *   }
		 * </pre>
		 * 
		 * All of those calls will be implemented (so that we get correct styling and messages on all fields).
		 * If any of those <code>ValidationUtils.valueRequired(...)</code> returns <code>ValidationUtils.FALSE</code>,
		 * then we will return false from this method.  This is a far easier method of call chaining.
		 * <p/>
		 * Here's the equivalent code if you were to use instances of the <code>Boolean</code> class:
		 * <pre>
		 *   public function validate():Boolean {
		 *     var result1:Boolean = ValidationUtils.valueRequired(field1, msg);
		 *     var result2:Boolean = ValidationUtils.valueRequired(field1, msg);
		 *     var result3:Boolean = ValidationUtils.valueRequired(field1, msg);
		 *     return result1 && result2 && result3;
		 *   }
		 * </pre>
		 * <p/>
		 * This is error prone - if you add validation method calls and forget to add them
		 * in to the condition on the return statement, you will get false positives.
		 */
		public static function valueRequired(component:UIComponent, errorMessage:String):uint {
			var error:uint = FALSE;
			
			var value:Object = null;
			
			if (component is TextInput) {
				value = CargoStringUtil.nullIfEmpty((component as TextInput).text);
			} else if (component is ComboBox) {
				value = (component as ComboBox).selectedItem;
			} else if (component is DateField) {
				value = CargoStringUtil.nullIfEmpty((component as DateField).text);
			} else if (component is TextArea) {
				value = CargoStringUtil.nullIfEmpty((component as TextArea).text);
			} else {
				Alert.show("Unsupported component type: " + component.className);
			}
			
			if (value == null) {
				component.errorString = errorMessage;
				component.styleName = "cargoErrorStyle";
				error = TRUE;
			} else {
				component.errorString = "";
				component.styleName = null;
			}
			
			return error;
		}
		
		public static function markFieldError(component:UIComponent, errorString:String):void {
			component.errorString = errorString;
			component.styleName = "cargoErrorStyle";
		}
		
		public static function clearErrors(component:UIComponent):void {
			component.errorString = "";
			component.styleName = null;
		}
		
		public static function isFieldInError(component:UIComponent):Boolean {
			return !(component.errorString == "");
		}
	}
 
}