package com.catlin.cargo.model.proxy {

	import com.catlin.cargo.model.core.brokeroffice.BrokerOffice;
	
	import org.granite.tide.events.TideResultEvent;
	import org.puremvc.as3.interfaces.IProxy;

	public class SourceAssociationProxy extends BaseProxy implements IProxy {

		public static const NAME:String = 'SourceAssociationProxy';
		public static const FIND_SOURCE_ASSOCIATION_COMPLETE:String = 'findSourceSystemsComplete';
		public static const FIND_ALL_SOURCE_SYSTEMS_COMPLETE:String = 'findAllSourceSystemsComplete';

		public function SourceAssociationProxy() {
			super(NAME);
		}

		public function listSourceAssociations(bo:BrokerOffice):void {
			tideContext.sourceAssociationService.listSourceAssociationsByBrokerOffice(bo, onListSourceAssociations, onRemoteFault);
		}

		private function onListSourceAssociations(event:TideResultEvent):void {
			sendNotification(FIND_SOURCE_ASSOCIATION_COMPLETE, event.result);
		}

		public function listSourceSystems():void {
			tideContext.sourceAssociationService.listSourceSystems(onListSourceSystems, onRemoteFault);
		}

		private function onListSourceSystems(event:TideResultEvent):void {
			sendNotification(FIND_ALL_SOURCE_SYSTEMS_COMPLETE, event.result);
		}
	}
}
