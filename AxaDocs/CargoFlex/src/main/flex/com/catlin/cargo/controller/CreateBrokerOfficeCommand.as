package com.catlin.cargo.controller
{
	import com.catlin.cargo.ApplicationFacade;
	
	import org.granite.tide.events.TideResultEvent;
	import org.puremvc.as3.interfaces.INotification;
	
	public class CreateBrokerOfficeCommand extends BaseCommand {
		
		public function CreateBrokerOfficeCommand() {
		}
		
		override public function execute(notification:INotification):void {
			tideContext.brokerService.createBrokerOffice(onCreateBrokerOffice, onRemoteFault);
		}
		
		private function onCreateBrokerOffice(event:TideResultEvent):void {
			sendNotification(ApplicationFacade.LOAD_BROKER_OFFICE, event.result);
		}
	}
}