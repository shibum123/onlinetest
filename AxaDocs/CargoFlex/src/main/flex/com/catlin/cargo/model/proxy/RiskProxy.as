package com.catlin.cargo.model.proxy {
	
	import org.granite.tide.events.TideResultEvent;
	import org.puremvc.as3.interfaces.IProxy;

	public class RiskProxy extends BaseProxy implements IProxy {
		
		public static const NAME:String = 'RiskProxy';
		public static const FIND_ALL_RISKS_COMPLETE:String = 'findAllRisksComplete';
		public static const FIND_BY_ID_COMPLETE:String = 'findRiskByIdComplete';

		public function RiskProxy() {
			super( NAME );
		}
		
		public function findById(sid:Number):void {
			tideContext.riskService.findRiskById(sid, onFindById, onRemoteFault);
		}

		public function listRisksForUser():void {
			tideContext.riskService.listRisksForUser(onListRisksForUser, onRemoteFault);
		}

		public function onListRisksForUser(event:TideResultEvent):void {
			sendNotification(FIND_ALL_RISKS_COMPLETE, event.result);
		}
		
		public function onFindById(event:TideResultEvent):void {
			sendNotification(FIND_BY_ID_COMPLETE, event.result);
		}
	}
}