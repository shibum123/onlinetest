package com.catlin.cargo.view.formatters
{
	import com.catlin.cargo.ApplicationFacade;
	import com.catlin.cargo.model.locale.LocaleFormat;
	
	import mx.binding.utils.BindingUtils;
	import mx.formatters.DateFormatter;
	import mx.formatters.NumberBaseRoundType;
	import mx.formatters.NumberFormatter;

	public class DataFormatters
	{
		
		private static var _dateFormatter:DateFormatter = new DateFormatter();
		private static var _numberFormatter:NumberFormatter = null;
		
		private static var _instance:DataFormatters = null;

		public function DataFormatters(se:SingletonEnforcer ) {
			if( se == null ){
				throw new Error( "You can only have one active instance of DataFormatters.");
			}

			_dateFormatter.formatString = ApplicationFacade.getInstance().localeFormat.dateShort4Year2MonthDay; //"DD/MM/YYYY";
			_numberFormatter = new NumberFormatter();
			_numberFormatter.precision = 2;
			_numberFormatter.rounding = NumberBaseRoundType.NEAREST;
			//_numberFormatter.useThousandsSeparator=false;
		}
		
		public static function getInstance():DataFormatters {
			if (!_instance) {
				_instance = new DataFormatters(new SingletonEnforcer());
				BindingUtils.bindSetter(updateDateFormat, ApplicationFacade.getInstance(), "localeFormat");
			}
			return _instance;
		}
		
		public function getDateFormatter():DateFormatter {
			return _dateFormatter;
		}
		
		private static function updateDateFormat(localeFormat:LocaleFormat):void {
			_dateFormatter.formatString = localeFormat.dateShort4Year2MonthDay;
		}
		
		public function getNumberFormater():NumberFormatter {
			return _numberFormatter;
		}
	}
}

class SingletonEnforcer  {}