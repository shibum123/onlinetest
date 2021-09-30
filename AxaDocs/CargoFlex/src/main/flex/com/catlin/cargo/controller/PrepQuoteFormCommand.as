package com.catlin.cargo.controller {
	import com.catlin.cargo.ApplicationFacade;
	import com.catlin.cargo.model.proxy.BrokerProxy;
	import com.catlin.cargo.model.proxy.ClauseProxy;
	import com.catlin.cargo.model.proxy.CurrencyProxy;
	import com.catlin.cargo.model.proxy.ExchangeRateProxy;
	import com.catlin.cargo.model.proxy.ReferenceDataProxy;
	import com.catlin.cargo.model.proxy.RiskProxy;
	import com.catlin.cargo.model.proxy.SubjectMatterProxy;

	import org.puremvc.as3.interfaces.INotification;

	public class PrepQuoteFormCommand extends BaseCommand {

		override public function execute(notification:INotification):void {
			var referenceDataProxy:ReferenceDataProxy=facade.retrieveProxy(ReferenceDataProxy.NAME) as ReferenceDataProxy;
			var brokerProxy:BrokerProxy=facade.retrieveProxy(BrokerProxy.NAME) as BrokerProxy;
			var clauseProxy:ClauseProxy=facade.retrieveProxy(ClauseProxy.NAME) as ClauseProxy;
			var subjectMatterProxy:SubjectMatterProxy=facade.retrieveProxy(SubjectMatterProxy.NAME) as SubjectMatterProxy;
			var currencyProxy:CurrencyProxy=facade.retrieveProxy(CurrencyProxy.NAME) as CurrencyProxy;
			var exchangeRateProxy:ExchangeRateProxy=facade.retrieveProxy(ExchangeRateProxy.NAME) as ExchangeRateProxy;

			brokerProxy.listBrokerOfficesForUser();
			brokerProxy.listUnderwriters();
			brokerProxy.listSurplusLinesBrokerOfficesForOffice();
			subjectMatterProxy.listSubjectMatters();
			referenceDataProxy.listDeclineReasons();
			referenceDataProxy.listMidTermAdjustmentReasons();
			referenceDataProxy.listBasisOfValuationImportExportPercentages(ApplicationFacade.getInstance().sessionOriginatingOfficeCode);
			referenceDataProxy.listBasisOfValuationStockPercentages(ApplicationFacade.getInstance().sessionOriginatingOfficeCode);			

			exchangeRateProxy.listExchangeRates("GBP");

			// TODO: The following code should be use to get the exchange rates based OriginatingOffice default currency.
			// Further currency conversions should be based on the user currency rather than using GBP as base currency.
			/*
			var baseExchangeSystemCurrency:String=ApplicationFacade.getInstance().defaultBaseExchangeSystemCurrency;
			exchangeRateProxy.listExchangeRates(baseExchangeSystemCurrency);
			*/

			if (ApplicationFacade.getInstance().userInfo.isUnderwriter) {
				clauseProxy.listStandardClauses();
				clauseProxy.listNonStandardClauses();
			}
			ApplicationFacade.getInstance().initialised=true;
			(facade.retrieveProxy(RiskProxy.NAME) as RiskProxy).listRisksForUser();
		}
	}
}
