package com.catlin.cargo.model
{
	import com.catlin.cargo.model.core.brokeroffice.BrokerOffice;

	public class BasicDocumentCriteria
	{
		private var _brokerOffice:BrokerOffice = null;
		private var _currency:String = null;
		private var _usageDate:String = null;
		private var _consumerType:String = null;
		private var _province:String = null;

		public function get brokerOffice():BrokerOffice
		{
			return _brokerOffice;
		}

		public function set brokerOffice(value:BrokerOffice):void
		{
			_brokerOffice = value;
		}

		public function get currency():String
		{
			return _currency;
		}
		
		public function set currency(value:String):void
		{
			_currency = value;
		}
		
		public function get usageDate():String
		{
			return _usageDate;
		}
		
		public function set usageDate(value:String):void
		{
			_usageDate = value;
		}
		
		public function get consumerType():String
		{
			return _consumerType;
		}
		
		public function set consumerType(value:String):void
		{
			_consumerType = value;
		}
		
		public function get province():String
		{
			return _province;
		}

		public function set province(value:String):void
		{
			_province = value;
		}			
	}
}