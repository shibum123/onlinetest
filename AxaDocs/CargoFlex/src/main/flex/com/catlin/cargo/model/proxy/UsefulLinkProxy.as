package com.catlin.cargo.model.proxy {
	
	import org.granite.tide.events.TideResultEvent;
	import org.puremvc.as3.interfaces.IProxy;

	public class UsefulLinkProxy extends BaseProxy implements IProxy {

		public static const NAME:String='UsefulLinkProxy';
		public static const FIND_ALL_USEFUL_LINKS_COMPLETE:String='FIND_ALL_USEFUL_LINKS_COMPLETE';
		public static const FIND_ALL_USEFUL_LINKS_FROM_MO_COMPLETE:String='FIND_ALL_USEFUL_LINKS_FROM_MO_COMPLETE';
		public static const FIND_ALL_USEFUL_LINKS_FOR_UNDERWRITER_COMPLETE:String='FIND_ALL_USEFUL_LINKS_FOR_UNDERWRITER_COMPLETE';
		public static const FIND_ALL_USEFUL_LINKS_FOR_BROKER_COMPLETE:String='FIND_ALL_USEFUL_LINKS_FOR_BROKER_COMPLETE';

		public function UsefulLinkProxy() {
			super(NAME);
		}
		
		public function listLinksForUnderwriter():void {
			//tideContext.linkService.listLinksForUnderwriter(onListLinksForUnderwriter, onRemoteFault);
			tideContext.linkService.listLinks(onListLinksForUnderwriter, onRemoteFault);
		}
		
		public function listLinks():void {
			tideContext.linkService.listLinks(onListLinks, onRemoteFault);
		}
	
		public function listLinksFromMasterOffice():void {
			tideContext.linkService.listLinksFromMasterOffice(onListLinksFromMasterOffice, onRemoteFault);
		}
		
		private function onListLinksForUnderwriter(event:TideResultEvent):void {
			sendNotification(FIND_ALL_USEFUL_LINKS_FOR_UNDERWRITER_COMPLETE, event.result);
		}
		
		private function onListLinks(event:TideResultEvent):void {
			sendNotification(FIND_ALL_USEFUL_LINKS_COMPLETE, event.result);
		}
		
		private function onListLinksFromMasterOffice(event:TideResultEvent):void {
			sendNotification(FIND_ALL_USEFUL_LINKS_FROM_MO_COMPLETE, event.result);
		}
	}
}
