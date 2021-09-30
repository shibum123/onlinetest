package com.catlin.cargo.model.util {
	import com.catlin.cargo.CargoDateUtil;
	
	import mx.formatters.DateFormatter;

	public class PersistentDateFormat 	{
		
		private var dateFormatter:DateFormatter = new DateFormatter();

		public function PersistentDateFormat() 	{
			dateFormatter.formatString = "YYYYMMDD";
		}
		
		public function parse(dateString:String):Date {
			if (dateString == null || dateString.length != 8) {
				return null;
			}
			var date:Date = new Date();
			date = CargoDateUtil.toDayPrecision(date);
			date.date = 1;
			date.fullYear = Number(dateString.substr(0, 4));
			date.month = Number(dateString.substr(4, 2)) - 1;
			date.date = Number(dateString.substr(6, 2));
			date = CargoDateUtil.toDayPrecision(date);
			return date;
		}
		
		public function format(date:Date):String {
			var formattedDate:String = null
			if (date != null) {
				formattedDate = dateFormatter.format(date); 
			}
			return formattedDate;
		}
	}
}