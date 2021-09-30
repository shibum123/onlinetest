package com.catlin.cargo.controller
{
	import com.catlin.cargo.ApplicationFacade;
	import com.catlin.cargo.model.core.insured.Insured;
	
	import org.granite.tide.events.TideResultEvent;
	import org.puremvc.as3.interfaces.INotification;
	
	public class UpdateInsuredDetailsCommand extends BaseCommand { 
	
		override public function execute(notification:INotification):void {
			tideContext.brokerService.updateInsured(notification.getBody(), onUpdateInsuredCompleted, onRemoteFault);
		}

		private function onUpdateInsuredCompleted(event:TideResultEvent):void {
			sendNotification(ApplicationFacade.UPDATE_INSURED_COMPLETE, (event.result as Insured));
		}
	}
}