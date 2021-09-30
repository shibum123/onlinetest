package com.catlin.cargo.view.reports.renderers {
	import com.catlin.cargo.model.core.risk.RiskStatus;
	
	import mx.collections.ArrayCollection;

	public class RiskStatusWrapper {
		
		private var _riskStatus:RiskStatus;

		public function RiskStatusWrapper(riskStatus:RiskStatus) {
			_riskStatus=riskStatus;
		}

		public function get name():String {
			return _riskStatus.name;
		}

		public static function createRiskStatusWraper(riskStatus:RiskStatus):RiskStatusWrapper {
			return new RiskStatusWrapper(riskStatus);
		}

		public static function get allConstants():Array {
			var ret:Array=new Array();
			for each (var currentRiskStatus:RiskStatus in RiskStatus.constants) {
				ret.push(createRiskStatusWraper(currentRiskStatus))
			}

			return ret;
		}
		
		public static function createArray(riskStatusList:Array):Array {
			var ret:Array=new Array();
			for each (var currentRiskStatus:RiskStatus in riskStatusList) {
				if (currentRiskStatus)
					ret.push(createRiskStatusWraper(currentRiskStatus))
			}
			
			return ret;
		}
		
		public static function createArrayCollection(riskStatusList:Array):ArrayCollection {
			var ret:ArrayCollection=new ArrayCollection();
			for each (var currentRiskStatus:RiskStatus in riskStatusList) {
				if (currentRiskStatus)
					ret.addItem(createRiskStatusWraper(currentRiskStatus))
			}
			
			return ret;
		}		
		
		public function get riskStatus():RiskStatus {
			return _riskStatus;
		}
	}
}
