package com.catlin.cargo.controller
{
	import com.catlin.cargo.ApplicationFacade;
	
	import org.granite.tide.events.TideResultEvent;
	import org.puremvc.as3.interfaces.INotification;
	
	public class LoadEarliestEndorsementDateCommand extends BaseCommand {

		override public function execute(notification:INotification):void {
			tideContext.quoteService.getEarliestAllowedEndorsementDate(notification.getBody(), onSuccess, onRemoteFault);
		}
		
		private function onSuccess(event:TideResultEvent):void {
			sendNotification(ApplicationFacade.EARLIEST_ENDORSEMENT_DATE_LOADED, event.result as Date);
		}
	}
}