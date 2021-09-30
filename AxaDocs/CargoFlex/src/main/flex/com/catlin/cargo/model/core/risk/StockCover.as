/**
 * Generated by Gas3 v1.1.0 (Granite Data Services).
 *
 * NOTE: this file is only generated if it does not exist. You may safely put
 * your custom code here.
 */

package com.catlin.cargo.model.core.risk {
	import com.catlin.cargo.model.core.originatingoffice.OriginatingOfficeCode;
	
	import flash.events.Event;
	import flash.utils.IDataInput;
	
	import mx.collections.ArrayCollection;
	import mx.events.CollectionEvent;
	
	import org.granite.meta;
	import org.granite.tide.IEntityManager;

	use namespace meta;

	[Bindable]
	[RemoteClass(alias="com.catlin.cargo.model.core.risk.StockCover")]
	public class StockCover extends StockCoverBase {

		public function StockCover() {
			inStoreMoreThan60Days = false;
			stockRequiredOutsideUk = false;
			stockRequiredOverseas = false;
			stockRequiredOnRestrictedAreas = false;
			locations = new ArrayCollection();
			basisOfValuation = "10%";
			addLocationEventListener();
		}

		/**
		 * Configures Office Specific values. 
		 * Consider moving these values to the database instead.
		 */
		public function configure(officeCode:OriginatingOfficeCode):void {
			switch (officeCode)  {
				case OriginatingOfficeCode.US: {
					this.basisOfValuation = null;
				}
			}
		}

		meta override function merge(em:IEntityManager, obj:*):void {
			super.merge(em, obj);
			addLocationEventListener();
			dispatchEvent(new Event("totalStockLimitChanged"));
		}

		override public function readExternal(input:IDataInput):void {
			super.readExternal(input);
			addLocationEventListener();
			dispatchEvent(new Event("totalStockLimitChanged"));
		}

		public function addDefaultEntry():void {
			if (locations.length == 0) {
				var stockLocation:StockLocation = new StockLocation();
				locations.addItem(stockLocation);
			}
		}

		[Bindable(event="totalStockLimitChanged")]
		public function get totalStockLimit():Number {
			var totalLimit:Number = 0;
			for (var i:int = 0; i < locations.length; i++) {
				var location:StockLocation = locations.getItemAt(i) as StockLocation;
				if (!isNaN(location.limit)) {
					totalLimit += location.limit;
				}
			}
			return totalLimit;
		}

		private function addLocationEventListener():void {
			locations.addEventListener(CollectionEvent.COLLECTION_CHANGE, function(evt:CollectionEvent):void {
				dispatchEvent(new Event("totalStockLimitChanged"));
			});
		}
	}
}