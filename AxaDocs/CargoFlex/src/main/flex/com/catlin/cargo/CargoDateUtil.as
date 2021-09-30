package com.catlin.cargo {
	import mx.formatters.DateFormatter;
	
	public class CargoDateUtil 	{
		
		public static function isDateInThePast(date:Date):Boolean {
			var today:Date = toDayPrecision(new Date());
			date = toDayPrecision(date);
			
			var todayTime:Number = today.time;
			var dateTime:Number = date.time;
			
			var ret:Boolean = dateTime < todayTime;
			
			return ret;
		}
		
		public static function toDayPrecision(date:Date):Date {
			date.hours = 0;
			date.minutes = 0;
			date.seconds = 0;
			date.milliseconds = 0;
			return date;
		}
		
		
		private static var dateFormatter:DateFormatter = new DateFormatter();

		{
			dateFormatter.formatString = "YYYYMMDD"	
		}
		
		public static function formateDate(date:Date):String {
			return dateFormatter.format(date);
		}	
		
	}
	
}