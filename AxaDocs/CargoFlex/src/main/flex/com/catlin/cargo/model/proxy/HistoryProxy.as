package com.catlin.cargo.model.proxy {


	import com.catlin.cargo.model.core.risk.HistoricAction;
	
	import org.granite.tide.events.TideResultEvent;
	import org.puremvc.as3.interfaces.IProxy;

	public class HistoryProxy extends BaseProxy implements IProxy {

		public static const NAME:String = "HistoryProxy";
		public static const HISTORY_FOUND:String = "HISTORY_FOUND";
		public static var BROKER_HISTORY_FOUND:String = "BROKER_HISTORY_FOUND";
		private var holder:HistoricAction = null;


		public function HistoryProxy() {
			super(NAME);
		}

		public function listHistory(sid:Number):void {
			tideContext.riskService.findFullHistoryOfRisk(sid, onListHistory, onRemoteFault);
		}

		public function listBrokerHistory(sid:Number):void {
			tideContext.brokerService.findHistory(sid, onListBrokerHistory, onRemoteFault);
		}

		private function onListHistory(event:TideResultEvent):void {
			sendNotification(HISTORY_FOUND, event.result);
		}

		private function onListBrokerHistory(event:TideResultEvent):void {
			sendNotification(BROKER_HISTORY_FOUND, event.result);
		}
	}
}