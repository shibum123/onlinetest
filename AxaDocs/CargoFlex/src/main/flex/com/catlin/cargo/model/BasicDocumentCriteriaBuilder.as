package com.catlin.cargo.model
{
	import com.catlin.cargo.model.core.brokeroffice.BrokerOffice;
	import com.catlin.cargo.model.reference.country.Province;

	public class BasicDocumentCriteriaBuilder
	{
		private var _basicDocumentCriteria:BasicDocumentCriteria=new BasicDocumentCriteria();

		public function build():BasicDocumentCriteria
		{
			return _basicDocumentCriteria;
		}

		public function withBrokerOffice(brokerOffice:BrokerOffice):BasicDocumentCriteriaBuilder
		{
			_basicDocumentCriteria.brokerOffice=brokerOffice;
			return this;
		}

		public function withCurrency(currency:String):BasicDocumentCriteriaBuilder
		{
			_basicDocumentCriteria.currency=currency;
			return this;
		}

		public function withUsageDate(usageDate:String):BasicDocumentCriteriaBuilder
		{
			_basicDocumentCriteria.usageDate=usageDate;
			return this;
		}

		public function withConsumerType(consumerType:String):BasicDocumentCriteriaBuilder
		{
			_basicDocumentCriteria.consumerType=consumerType;
			return this;
		}

		public function withProvince(province:String):BasicDocumentCriteriaBuilder
		{
			_basicDocumentCriteria.province=province;
			return this;
		}
	}
}
