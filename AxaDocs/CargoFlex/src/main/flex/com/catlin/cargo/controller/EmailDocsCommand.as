package com.catlin.cargo.controller {
	
	import com.catlin.cargo.model.core.risk.Risk;
	
	import org.granite.tide.events.TideResultEvent;
	import org.puremvc.as3.interfaces.INotification;

	public class EmailDocsCommand extends BaseCommand {

		public function EmailDocsCommand() {
		}

		override public function execute(notification:INotification):void {
			var risk:Risk = notification.getBody() as Risk;
			tideContext.riskService.sendEmail(risk.sid, onEmailDocs, onRemoteFault);
		}
		
		private function onEmailDocs(event:TideResultEvent):void {
		}
	}
}