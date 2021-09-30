package com.catlin.cargo.controller {
	import com.catlin.cargo.ApplicationFacade;
	
	import org.granite.tide.events.TideResultEvent;
	import org.puremvc.as3.interfaces.INotification;

	public class SaveSourceAssociationCommand extends BaseCommand {

		override public function execute(notification:INotification):void {
			tideContext.sourceAssociationService.saveSourceAssociations(notification.getBody(), onSaveSourceAssociation, onRemoteFault);
		}

		private function onSaveSourceAssociation(event:TideResultEvent):void {
			sendNotification(ApplicationFacade.SAVE_SOURCE_ASSOCIATION_COMPLETE, event.result);
		}
	}
}