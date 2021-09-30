package com.catlin.cargo.controller {
	import mx.collections.ArrayCollection;
	
	import org.granite.tide.events.TideResultEvent;
	import org.puremvc.as3.interfaces.INotification;

	public class UpdateLimitsAndDeductiablesCommand extends BaseCommand {

		public static const FIND_POSTAL_LIMITS_COMPLETE:String = 'findPostalLimitsComplete';
		public static const FIND_DEDUCTABLES_COMPLETE:String = 'findDeductablesComplete';
		public static const UPDATE_SENDINGS:String = 'updateSendings';

		override public function execute(notification:INotification):void {
			tideContext.referenceDataService.findPostalLimitsByIsoCodes(notification.getBody(), onFoundPostalLimit, onRemoteFault);
			tideContext.referenceDataService.findDeductiblesMapByIsoCodes(notification.getBody(), onFoundDeductibles, onRemoteFault);
		}

		private function onFoundPostalLimit(event:TideResultEvent):void {
			var postalLimits:ArrayCollection = event.result as ArrayCollection;
			sendNotification(FIND_POSTAL_LIMITS_COMPLETE, postalLimits);
		}

		private function onFoundDeductibles(event:TideResultEvent):void {
			var deductiblesMap:Object = event.result;
			sendNotification(FIND_DEDUCTABLES_COMPLETE, deductiblesMap);
			sendNotification(UPDATE_SENDINGS);
		}

	}
}