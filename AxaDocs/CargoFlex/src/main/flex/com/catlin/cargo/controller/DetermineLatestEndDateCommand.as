package com.catlin.cargo.controller {
	import com.catlin.cargo.ApplicationFacade;
	
	import org.granite.tide.events.TideResultEvent;
	import org.puremvc.as3.interfaces.INotification;

	public class DetermineLatestEndDateCommand extends BaseCommand {

		override public function execute(notification:INotification):void {
			var date:Date = notification.getBody() as Date;
			tideContext.riskService.getLatestAllowedEndDate(date, onSuccess, onRemoteFault);
		}

		private function onSuccess(event:TideResultEvent):void {
			var date:Date = event.result as Date;
			sendNotification(ApplicationFacade.LATEST_END_DATE_DETERMINED, date);
		}
	}
}