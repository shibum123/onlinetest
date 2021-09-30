package com.catlin.cargo.controller {
	import com.catlin.cargo.ApplicationFacade;
	import com.catlin.cargo.CargoFlexMediator;
	import com.catlin.cargo.model.core.brokeroffice.BrokerDocument;
	import com.catlin.cargo.model.geo.address.Address;
	import com.catlin.cargo.model.proxy.BrokerProxy;
	import com.catlin.cargo.model.proxy.ClauseProxy;
	import com.catlin.cargo.model.proxy.CountryProxy;
	import com.catlin.cargo.model.proxy.CurrencyProxy;
	import com.catlin.cargo.model.proxy.ExchangeRateProxy;
	import com.catlin.cargo.model.proxy.HistoryProxy;
	import com.catlin.cargo.model.proxy.ReferenceDataProxy;
	import com.catlin.cargo.model.proxy.ReportsProxy;
	import com.catlin.cargo.model.proxy.RiskProxy;
	import com.catlin.cargo.model.proxy.SourceAssociationProxy;
	import com.catlin.cargo.model.proxy.SubjectMatterProxy;
	import com.catlin.cargo.model.proxy.UsefulLinkProxy;
	import com.catlin.cargo.model.reference.mtareason.MidTermAdjustmentReason;
	
	import org.puremvc.as3.interfaces.INotification;


	public class ApplicationStartupCommand extends BaseCommand {

		// TODO - remove MidTermAdjustmentReason
		private static var compiledClass:Array = [ Address, MidTermAdjustmentReason, BrokerDocument ];

		/**
		 * Register the Proxies and Mediators.
		 *
		 * Get the View Components for the Mediators from the app,
		 * which passed a reference to itself on the notification.
		 */
		override public function execute(note:INotification):void {
			var app:CargoFlex = note.getBody() as CargoFlex;

			facade.registerProxy(new BrokerProxy());
			facade.registerProxy(new ClauseProxy());
			facade.registerProxy(new RiskProxy());
			facade.registerProxy(new SubjectMatterProxy());
			facade.registerProxy(new ReferenceDataProxy());
			facade.registerProxy(new SourceAssociationProxy());
			facade.registerProxy(new CountryProxy());
			facade.registerProxy(new CurrencyProxy());
			facade.registerProxy(new ExchangeRateProxy());
			facade.registerProxy(new HistoryProxy());
			facade.registerProxy(new UsefulLinkProxy);
			facade.registerProxy(new ReportsProxy);

			facade.registerMediator(new CargoFlexMediator(app));

			sendNotification(ApplicationFacade.PREP_QUOTE_FORM);
			sendNotification(ApplicationFacade.PREP_USEFUL_LINKS);
		}
	}
}
