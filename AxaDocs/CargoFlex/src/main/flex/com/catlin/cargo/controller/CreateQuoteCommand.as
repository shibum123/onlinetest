package com.catlin.cargo.controller {
	import com.catlin.cargo.ApplicationFacade;
	import com.catlin.cargo.model.core.risk.Risk;
	import com.catlin.cargo.view.risk.quoteentry.QuoteFormMediator;
	
	import org.granite.tide.events.TideResultEvent;
	import org.puremvc.as3.interfaces.INotification;

	public class CreateQuoteCommand extends BaseCommand {

		private var quoteFormMediator:QuoteFormMediator;

		public function CreateQuoteCommand() {
			quoteFormMediator = facade.retrieveMediator(QuoteFormMediator.NAME) as QuoteFormMediator;
		}

		override public function execute(notification:INotification):void {
			tideContext.quoteService.createQuote(onCreateQuote, onRemoteFault);
		}

		private function onCreateQuote(event:TideResultEvent):void {
			var quote:Risk = event.result as Risk;
			quote.updateTotals();
			sendNotification(ApplicationFacade.RISK_LOADED, quote);
		}
	}
}