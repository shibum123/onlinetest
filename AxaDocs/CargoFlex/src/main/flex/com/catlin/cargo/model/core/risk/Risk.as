package com.catlin.cargo.model.core.risk {
	import com.catlin.cargo.LazyCollectionExecutor;
	import com.catlin.cargo.model.core.brokeroffice.BrokerOffice;
	import com.catlin.cargo.model.core.sourceassociation.Channel;
	import com.catlin.cargo.model.security.UserInfo;
	import com.catlin.cargo.model.util.PersistentDateFormat;
	
	import flash.events.Event;
	import flash.utils.IDataInput;
	
	import mx.collections.IList;
	import mx.formatters.DateFormatter;
	
	import org.granite.meta;
	import org.granite.tide.IEntityManager;

	use namespace meta;

	[Bindable]
	[RemoteClass(alias="com.catlin.cargo.model.core.risk.Risk")]
	public class Risk extends RiskBase {

		public static const MILLISECONDS_PER_DAY:int = 1000 * 60 * 60 * 24;

		public var _editModeEnabled:Boolean = false;
		public var numOfSendings:Number = 0;
		public var totalSendingsValue:Number = 0;
		public var totalSendingsCalculatedPremium:Number = 0;
		public var totalSendingsPremium:Number = 0;
		public var totalSendingsTax:Number = 0;
		private var dateFormatter:DateFormatter = new DateFormatter();
		public var hasAnsweredTriaInsurance:Boolean = false;

		public function Risk() {
			// Set up the formatter once
			dateFormatter.formatString = "YYYYMMDD";
		}

		override public function set commissionType(value:CommissionType):void {
			super.commissionType = value;
			if (value == CommissionType.GROSS && isNaN(commissionPercentage) && brokerOffice != null) {
				commissionPercentage = brokerOffice.defaultCommission;
			} else if (value == CommissionType.NET) {
				commissionPercentage = NaN;
			}
		}

		override public function get brokerOffice():BrokerOffice {
			return super.brokerOffice;
		}

		override public function set brokerOffice(value:BrokerOffice):void {
			super.brokerOffice = value;
			if (isNaN(commissionPercentage) && commissionType == CommissionType.GROSS && value != null) {
				commissionPercentage = value.defaultCommission;
			}
		}

		meta override function merge(em:IEntityManager, obj:*):void {
			super.merge(em, obj);
			dispatchEvent(new Event("editableChanged"));
		}

		override public function readExternal(input:IDataInput):void {
			super.readExternal(input);
			dispatchEvent(new Event("editableChanged"));
		}

		[Bindable(event="editableChanged")]
		public function get editable():Boolean {
			return status == RiskStatus.NEW || editModeEnabled;
		}

		public function get editModeEnabled():Boolean {
			return _editModeEnabled;
		}

		public function set editModeEnabled(value:Boolean):void {
			_editModeEnabled = value;
			dispatchEvent(new Event("editableChanged"));
		}

		public override function set status(value:RiskStatus):void {
			super.status = value;
			dispatchEvent(new Event("editableChanged"));
		}

		public function updatePolicyEndDate(startDate:Date, userInfo:UserInfo):void {
			if (startDate != null) {
				var date:Date = new Date(startDate.getTime());
				date.hours = 12; // make sure we can't get bitten by daylight savings
				if (policyType == PolicyType.ANNUAL) {
					date.fullYear = date.fullYear + 1;
					date.time = date.time - MILLISECONDS_PER_DAY;
				} else { // single
					if (userInfo.isAsianOriginatingOffice()) {
						date.time = date.time + (30 * MILLISECONDS_PER_DAY);
					} else {
						date.time = date.time + (90 * MILLISECONDS_PER_DAY);
					}
				}
				date.hours = 0;

				// Format the date
				policyEndDateAsDate = date;
			}
		}

		public function updateEndorsmentStartDate(startDate:Date):void {
			if (startDate != null) {
				if (midTermAdjustmentDetails != null) {
					midTermAdjustmentDetails.endorsementStartDateAsDate = startDate;
				}
			}
		}

		public function updateTotals():void {
			new LazyCollectionExecutor(sendings, lazyUpdateTotals, sendings).execute();
		}

		private function lazyUpdateTotals(sendings:IList):void {
			var sendingsCount:Number = 0;
			var sendingTotal:Number = 0;
			var sendingCalculatedPremium:Number = 0;
			var sendingPremium:Number = 0;
			var sendingTax:Number = 0;
			for each (var sending:Sendings in sendings) {
				sendingsCount += sending.getInsuredRouteCount();
				sending.updateTotals();
				sendingTotal += sending.totalValue;
				sendingCalculatedPremium += sending.totalCalculatedPremium;
				sendingPremium += sending.totalPremium;
				sendingTax += sending.totalTax;
				if (policyType == PolicyType.SINGLE ) {
					sending.limit = sending.highestValue;
				}
			}
			numOfSendings = sendingsCount;
			totalSendingsValue = sendingTotal;
			totalSendingsCalculatedPremium = sendingCalculatedPremium;
			totalSendingsPremium = sendingPremium;
			totalSendingsTax = sendingTax;
		}

		public static function getFormattedStatus(status:RiskStatus, renewal:Boolean):String {
			var result:String = (renewal) ? "Renewal " : "";
			switch (status.name) {
				case RiskStatus.NEW.name:
					if (renewal) {
						return result + "Offer";
					}
					return "New";
				case RiskStatus.QUOTED.name:
					return result + "Quoted";
				case RiskStatus.QUOTE_EXPIRED.name:
					return result + "Quote Expired";
				case RiskStatus.REFERRED.name:
					return result + "Referred";
				case RiskStatus.QUOTE_PENDING.name:
					return result + "Quote Pending";
				case RiskStatus.OFFLINE.name:
					return result + "Handled Offline";
				case RiskStatus.POLICY.name:
					return result + "Policy";
				case RiskStatus.DECLINED.name:
					return result + "Declined";
				case RiskStatus.EXPIRED.name:
					return result + "Expired";
				case RiskStatus.CANCELLED.name:
					return "Cancelled";
				case RiskStatus.LAPSED.name:
					return result + "Lapsed";
				case RiskStatus.NTU.name:
					return result + "Not Taken Up";
				default:
					return "Unknown: " + status;
			}
		}

		public function getSendingsForType(type:String):Sendings {
			for each (var sending:Sendings in sendings) {
				if (sending.type.code == type) {
					return sending;
				}
			}
			return null;
		}

		public function getSendingsIndexForType(type:String):Number {
			for (var i:int = 0; i < sendings.length; i++) {
				if (sendings.getItemAt(i).type.code == type) {
					return i;
				}
			}
			return NaN;
		}

		// ***** String date functions
		public function updatePolicyStartDate(startDate:Date):void {
			if (startDate != null) {
				var date:Date = new Date(startDate.getTime());
				date.hours = 0;
				policyStartDate = new PersistentDateFormat().format(date);
			} else {
				policyStartDate = null;
			}
		}

		public function get policyReference():String {
			var result:String = reference;
			if (result.substring(0,1) == "Q") {
				result = result.substring(1);
			}
			if (result.indexOf("/") > 0 ) {
				result = result.substring(0, result.indexOf("/")); 
			}
			return result;
		}

		public function get policyStartDateAsDate():Date {
			return new PersistentDateFormat().parse(policyStartDate);
		}

		public function set policyStartDateAsDate(dt:Date):void {
			policyStartDate = new PersistentDateFormat().format(dt);
		}

		public function get policyEndDateAsDate():Date {
			return new PersistentDateFormat().parse(policyEndDate);
		}

		public function set policyEndDateAsDate(dt:Date):void {
			policyEndDate = new PersistentDateFormat().format(dt);
		}

		public function isMidTermAdjustment():Boolean {
			return midTermAdjustmentDetails != null;
		}
		
		public function isCoverPeriodMidTermAdjustment():Boolean {
			return (midTermAdjustmentDetails != null && midTermAdjustmentDetails.reason.code == "CPD");
		}
		
		public function isCancellation():Boolean {
			return (midTermAdjustmentDetails != null && midTermAdjustmentDetails.reason.code == "CAN");
		}

		public function get startDate():Date {
			return isMidTermAdjustment() ? midTermAdjustmentDetails.endorsementStartDateAsDate : policyStartDateAsDate;
		}
		
		public function isWebChannel():Boolean {
			return sourceAssociation == null || sourceAssociation.sourceSystem.channel == Channel.WEB;
		}

		public function isRenewal():Boolean {
			return previousRisk != null;
		}

	}
}