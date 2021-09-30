package com.catlin.cargo.controller {
	
	import com.catlin.cargo.ApplicationFacade;
	import com.catlin.cargo.model.core.risk.Risk;
	
	import org.granite.tide.events.TideResultEvent;
	import org.puremvc.as3.interfaces.INotification;

	public class LoadEmailTemplateCommand extends BaseCommand {

		public function LoadEmailTemplateCommand() {
		}

		override public function execute(notification:INotification):void {
			var risk:Risk = notification.getBody() as Risk;
			tideContext.riskService.getSendToBrokerMessageFragments(risk.sid, onGetSendToBrokerMessageFragments, onRemoteFault);
		}
		
		private function onGetSendToBrokerMessageFragments(event:TideResultEvent):void {
			sendNotification(ApplicationFacade.LOAD_EMAIL_TEMPLATE_COMPLETE, event.result);
		}
	}
}