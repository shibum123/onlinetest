package com.catlin.cargo.controller {
	
	import com.catlin.cargo.ApplicationFacade;
	import com.catlin.cargo.bundles.RB_ui;
	import com.catlin.cargo.model.core.risk.Risk;
	import com.catlin.cargo.view.risk.quoteentry.QuoteFormMediator;
	
	import mx.controls.Alert;
	
	import org.granite.tide.events.TideResultEvent;
	import org.puremvc.as3.interfaces.INotification;

	public class ForceRenewalCommand extends BaseCommand {

		public function ForceRenewalCommand() {
		}

		override public function execute(notification:INotification):void {
			var risk:Risk = (facade.retrieveMediator(QuoteFormMediator.NAME) as QuoteFormMediator).currentQuote;
			tideContext.renewalService.createRenewalQuote(risk.sid, onCreateRenewalQuote, onRemoteFault);
		}
		
		private function onCreateRenewalQuote(event:TideResultEvent):void {
			sendNotification(ApplicationFacade.REFRESH_ALL_RISKS);
			Alert.show(rm.getString(RB_ui.RB_NAME, RB_ui.FORCE_RENEWAL_SUCCESS_MESSAGE, [(event.result as Risk).reference]), 
				rm.getString(RB_ui.RB_NAME, RB_ui.FORCE_RENEWAL_SUCCESS_TITLE));
		}
	}
}