package com.catlin.cargo.controller {
	
	import org.granite.tide.events.TideResultEvent;
	import org.puremvc.as3.interfaces.INotification;

	public class UpdateClauseArchiveStatusCommand extends BaseCommand {
		override public function execute(notification:INotification):void {
			tideContext.clauseService.updateClauseArchiveStatus(notification.getBody(), onUpdateClause, onRemoteFault);
		}

		private function onUpdateClause(event:TideResultEvent):void {
			// fire and forget
		}
	}
}