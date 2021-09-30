package com.catlin.cargo.controller {
	import com.catlin.cargo.bundles.RB_ui;
	import com.catlin.cargo.model.core.risk.Risk;
	
	import mx.controls.Alert;
	
	import org.granite.tide.events.TideResultEvent;
	import org.puremvc.as3.interfaces.INotification;
	
	public class ResendToFrameCommand extends BaseCommand {
		
		public function ResendToFrameCommand() {
		}
		
		override public function execute(notification:INotification):void {
			var quote:Risk = notification.getBody() as Risk;
			tideContext.riskService.markPolicyForResend(quote.sid, onSuccess);
		}
		
		private function onSuccess(event:TideResultEvent): void {
			Alert.show(
				rm.getString(RB_ui.RB_NAME, RB_ui.RESEND_TO_FRAME_SUCCESS_MESSAGE),
				rm.getString(RB_ui.RB_NAME, RB_ui.RESEND_TO_FRAME_SUCCESS_TITLE));
		}
		
	}
}