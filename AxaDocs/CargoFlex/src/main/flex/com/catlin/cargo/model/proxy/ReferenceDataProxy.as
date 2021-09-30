package com.catlin.cargo.model.proxy {
	
	import com.catlin.cargo.ApplicationFacade;
	import com.catlin.cargo.model.core.originatingoffice.OriginatingOfficeCode;
	import com.catlin.cargo.view.util.LabelDataItem;
	
	import mx.collections.ArrayCollection;
	
	import org.granite.tide.events.TideResultEvent;
	import org.puremvc.as3.interfaces.IProxy;
	
	public class ReferenceDataProxy extends BaseProxy implements IProxy {

		public static const NAME:String='ReferenceDataProxy';
		public static const FIND_ALL_DECLINE_REASONS_COMPLETE:String='FIND_ALL_DECLINE_REASONS_COMPLETE';
		public static const FIND_ALL_MTA_REASONS_COMPLETE:String='FIND_ALL_MTA_REASONS_COMPLETE';
		public static const FIND_ALL_FRAME_ORIGINATING_OFFICES_COMPLETE:String='FIND_ALL_FRAME_ORIGINATING_OFFICES_COMPLETE';
		public static const FIND_ALL_CONSUMER_BUSINESS_CONTROL_REGULATIONS_COMPLETE:String="FIND_ALL_CONSUMER_BUSINESS_CONTROL_REGULATIONS_COMPLETE";
		public static const FIND_ALL_BASIS_OF_VALUATION_STOCK_PERCENTAGES_COMPLETE:String="FIND_ALL_BASIS_OF_VALUATION_STOCK_PERCENTAGES_COMPLETE";
		public static const FIND_ALL_BASIS_OF_VALUATION_IMPORT_EXPORT_PERCENTAGES_COMPLETE:String="FIND_ALL_BASIS_OF_VALUATION_IMPORT_EXPORT_PERCENTAGES_COMPLETE";

		public function ReferenceDataProxy() {
			super(NAME);
		}

		public function listDeclineReasons():void {
			tideContext.referenceDataService.listDeclineReasons(onListDeclineReasons, onRemoteFault);
		}
		
		private function onListDeclineReasons(event:TideResultEvent):void {
			sendNotification(FIND_ALL_DECLINE_REASONS_COMPLETE, event.result);
		}
		
		public function listMidTermAdjustmentReasons():void {
			tideContext.referenceDataService.listMidTermAdjustmentReasons(onListMidTermAdjustmentReasons, onRemoteFault);
		}
		
		private function onListMidTermAdjustmentReasons(event:TideResultEvent):void {
			sendNotification(FIND_ALL_MTA_REASONS_COMPLETE, event.result);
		}
		
		public function listFrameOriginatingOffices():void {
			tideContext.referenceDataService.listFrameOriginatingOffices(onListFrameOriginatingOffices, onRemoteFault);
		}
		
		private function onListFrameOriginatingOffices(event:TideResultEvent):void {
			sendNotification(FIND_ALL_FRAME_ORIGINATING_OFFICES_COMPLETE, event.result);
		}
		
		public function listConsumerBusinessControlRegulations(date:Date):void {
			tideContext.referenceDataService.listConsumerBusinessControlRegulations(date, onlistConsumerBusinessControlRegulations,
				onRemoteFault);
		}

		private function onlistConsumerBusinessControlRegulations(event:TideResultEvent):void {
			sendNotification(FIND_ALL_CONSUMER_BUSINESS_CONTROL_REGULATIONS_COMPLETE, event.result);
		}
		
		/**
		 * TODO: Moved this from the Mediator to this proxy...
		 * but we should consider store this values somwhere on the DataBase
		 */
		public static var DEFAULT_KEY:String = "DEFAULT";
		private static var  basisOfValuationStockPercentages:ArrayCollection;
		private static var  basisOfValuationImportExportPercentages:ArrayCollection;
		
		private function getBOVStockPercentagesDataProvider(key:String):ArrayCollection {
			if (basisOfValuationStockPercentages == null) {
				if (key == "US") {
					basisOfValuationStockPercentages = new ArrayCollection([
						new LabelDataItem("Selling Price", "Selling Price"), 
						new LabelDataItem("Cost, Insurance & Freight plus 10%", "10%"), 
						new LabelDataItem("Cost, Insurance & Freight plus 20%", "20%"),
						new LabelDataItem("Cost, Insurance & Freight plus 30%", "30%"),
						new LabelDataItem("Cost, Insurance & Freight plus Other%", "Other")]);	
				} else {
					basisOfValuationStockPercentages = new ArrayCollection([
						new LabelDataItem("10%", "10%"),
						new LabelDataItem("15%", "15%"), 
						new LabelDataItem("20%", "20%"),
						new LabelDataItem("25%", "25%"),
						new LabelDataItem("30%", "30%"),
						new LabelDataItem("Other%", "Other")]);
				}
			}
			return basisOfValuationStockPercentages;
		}

		private function getBOVImportExportPercentagesDataProvider(key:String):ArrayCollection {
			if (basisOfValuationImportExportPercentages == null) {
				if (key == "US") {
					basisOfValuationImportExportPercentages = new ArrayCollection([
						new LabelDataItem("Selling Price", "Selling Price"), 
						new LabelDataItem("Cost, Insurance & Freight plus 10%", "10%"), 
						new LabelDataItem("Cost, Insurance & Freight plus 20%", "20%"),
						new LabelDataItem("Cost, Insurance & Freight plus 30%", "30%"),
						new LabelDataItem("Cost, Insurance & Freight plus Other%", "Other")]);	
				} else {
					basisOfValuationImportExportPercentages = new ArrayCollection([
						new LabelDataItem("10%", "10%"), 
						new LabelDataItem("20%", "20%"),
						new LabelDataItem("30%", "30%"),
						new LabelDataItem("Other%", "Other")]);
				}
			}
			return basisOfValuationImportExportPercentages;
		}

		public function listBasisOfValuationStockPercentages(originatingOfficeCode:OriginatingOfficeCode):void {
			//tideContext.referenceDataService.listBasisOfValuationStockPercentages(originatingOfficeCode, onListBasisOfValuationStockPercentages, onRemoteFault);
			this.onListBasisOfValuationStockPercentages(null);
		}

		private function onListBasisOfValuationStockPercentages(event:TideResultEvent):void {
			var code:String = DEFAULT_KEY;
			if (ApplicationFacade.getInstance().sessionOriginatingOfficeCode == OriginatingOfficeCode.US) {
				code = OriginatingOfficeCode.US.toString();
			}
			var percentagesWithOther:ArrayCollection = getBOVStockPercentagesDataProvider(code);
			sendNotification(FIND_ALL_BASIS_OF_VALUATION_STOCK_PERCENTAGES_COMPLETE, percentagesWithOther);
		}

		/**
		 * TODO: Moved this from the Mediator to this proxy.... 
		 * but we should consider store this values somwhere on the DataBase
		 */
		public function listBasisOfValuationImportExportPercentages(originatingOfficeCode:OriginatingOfficeCode):void {
			//tideContext.referenceDataService.listBasisOfValuationImportExportPercentages(originatingOfficeCode, onListBasisOfValuationImportExportPercentages, onRemoteFault);
			this.onListBasisOfValuationImportExportPercentages(null);
		}

		private function onListBasisOfValuationImportExportPercentages(event:TideResultEvent):void {
			var code:String = DEFAULT_KEY;
			if (ApplicationFacade.getInstance().sessionOriginatingOfficeCode == OriginatingOfficeCode.US) {
				code = OriginatingOfficeCode.US.toString();
			}
			var percentagesWithOther:ArrayCollection = getBOVImportExportPercentagesDataProvider(code);
			sendNotification(FIND_ALL_BASIS_OF_VALUATION_IMPORT_EXPORT_PERCENTAGES_COMPLETE, percentagesWithOther);
		}
	}
}
