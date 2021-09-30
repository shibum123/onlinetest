package com.catlin.cargo.model.proxy {
	
	import com.catlin.cargo.model.core.clause.Clause;
	
	import org.granite.tide.events.TideResultEvent;
	import org.puremvc.as3.interfaces.IProxy;

	public class ClauseProxy extends BaseProxy implements IProxy {
		
		public static const NAME:String = 'ClauseProxy';
		public static const FIND_ALL_STANDARD_CLAUSES_COMPLETE:String = 'findAllStandardClausesComplete';
		public static const FIND_ALL_NON_STANDARD_CLAUSES_COMPLETE:String = 'findAllNonStandardClausesComplete';
		public static const GET_CLAUSE_TEXT_COMPLETE:String = 'getClauseTextComplete';

		public function ClauseProxy() {
			super( NAME );
		}

		public function listStandardClauses():void {
			tideContext.clauseService.findAllStandardClauses(onListStandardClauses, onRemoteFault);
		}
		
		public function listNonStandardClauses():void {
			tideContext.clauseService.findAllNonStandardClauses(onListNonStandardClauses, onRemoteFault);
		}

		public function getSnippetText(clause:Clause):void {
			tideContext.clauseService.getSnippetText(clause, onGetSnippetText, onRemoteFault);
		}

		public function onListStandardClauses(event:TideResultEvent):void {
			sendNotification(FIND_ALL_STANDARD_CLAUSES_COMPLETE, event.result);
		}

		public function onListNonStandardClauses(event:TideResultEvent):void {
			sendNotification(FIND_ALL_NON_STANDARD_CLAUSES_COMPLETE, event.result);
		}

		public function onGetSnippetText(event:TideResultEvent):void {
			sendNotification(GET_CLAUSE_TEXT_COMPLETE, event.result);
		}
	}
}