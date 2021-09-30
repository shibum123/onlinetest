package com.catlin.cargo.model.proxy {
	
	import org.granite.tide.events.TideResultEvent;
	import org.puremvc.as3.interfaces.IProxy;
	
	public class SubjectMatterProxy extends BaseProxy implements IProxy {
		
		public static const NAME:String = 'SubjectMatterProxy';
		public static const FIND_ALL_SUBJECT_MATTERS_COMPLETE:String = 'findAllSubjectMattersComplete';

		public function SubjectMatterProxy() {
			super( NAME );
		}

		// return data property cast to proper type
		public function listSubjectMatters():void {
			tideContext.referenceDataService.listSubjectMatters(onListSubjectMatters, onRemoteFault);
		}
		
		private function onListSubjectMatters(event:TideResultEvent):void {
			sendNotification(FIND_ALL_SUBJECT_MATTERS_COMPLETE, event.result);
		}
	}
}
