package com.catlin.cargo.controller
{
	import com.catlin.cargo.model.proxy.ClauseProxy;
	import com.catlin.cargo.view.risk.clauses.NewClauseFormMediator;
	
	import org.granite.tide.events.TideResultEvent;
	import org.puremvc.as3.interfaces.INotification;
	
	public class CreateClauseCommand extends BaseCommand 
	{
		override public function execute(notification:INotification):void {
			tideContext.clauseService.createNonStandardClause(notification.getBody(), onCreateClause, onRemoteFault);
			
			var clauseProxy:ClauseProxy = facade.retrieveProxy(ClauseProxy.NAME) as ClauseProxy;
			clauseProxy.listNonStandardClauses();
		}
		
		private function onCreateClause(event:TideResultEvent):void {
			sendNotification(NewClauseFormMediator.CREATE_CLAUSE_COMPLETE);
		}
	}
}