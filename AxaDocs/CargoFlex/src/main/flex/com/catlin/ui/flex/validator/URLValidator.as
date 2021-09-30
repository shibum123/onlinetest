package com.catlin.ui.flex.validator
{
	import mx.utils.StringUtil;
	import mx.validators.ValidationResult;
	import mx.validators.Validator;
	
	public class URLValidator extends Validator
	{
		private static const ERROR_BAD_URL:String = "BadUrl";
		
		private var _results:Array;
		private var _validExtensions:Array; 
		private var _urlRegex:RegExp = /^http(s)?:\/\/((\d+\.\d+\.\d+\.\d+)|(([\w-]+\.)+([a-z,A-Z][\w-]*)))(:[1-9][0-9]*)?(\/([\w-.\/:%+@&=]+[\w- .\/?:%+@&=]*)?)?(#(.*))?$/i;
		private var _errorMessage:String;
		
		public function URLValidator()
		{
			super();
		}
		
		public function get errorMessage():String {
			return _errorMessage;
		}
		
		public function set errorMessage(value:String):void {
			_errorMessage = value;
		}
		
		override protected function doValidation(value:Object):Array {
			// Convert value to a String.
			var inputValue:String = StringUtil.trim(String(value));
			// Clear the results array.
			_results = [];
			// Call base class doValidation().
			_results = super.doValidation(inputValue);
			// Return if there are errors.
			if (_results.length > 0) 
				return _results;
			// If the string is empty, return.
			if (inputValue.length == 0)
				return _results;
			
			if (!_urlRegex.test(inputValue)) {
				_results.push(new ValidationResult(true, null, ERROR_BAD_URL, _errorMessage));
				return _results;
			}
			return _results;              
		}
	}
}