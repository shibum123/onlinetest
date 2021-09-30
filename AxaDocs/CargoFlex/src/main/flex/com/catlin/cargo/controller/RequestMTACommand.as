package com.catlin.cargo.controller {

	import com.catlin.cargo.ApplicationFacade;
	import com.catlin.cargo.bundles.RB_ui;
	import com.catlin.cargo.model.core.risk.Risk;
	
	import mx.controls.Alert;
	
	import org.granite.tide.events.TideResultEvent;
	import org.puremvc.as3.interfaces.INotification;

	public class RequestMTACommand extends BaseCommand {

		public function RequestMTACommand() {
		}

		override public function execute(notification:INotification):void {
			var o:Object = notification.getBody();
			tideContext.quoteService.createMidTermAdjustmentQuote(o.risk.sid, o.endorsementDate, o.reason, o.request, onRequestMTAComplete, onRemoteFault);
		}

		private function onRequestMTAComplete(event:TideResultEvent):void {
			var result:Risk = event.result as Risk;
			result.updateTotals();
			sendNotification(ApplicationFacade.MTA_CREATE_QUOTE_COMPLETE, result);
			Alert.show(rm.getString(RB_ui.RB_NAME, RB_ui.REQUEST_MTA_SUCCESS_MESSAGE), rm.getString(RB_ui.RB_NAME, RB_ui.REQUEST_MTA_SUCCESS_TITLE));
		}
	}
}