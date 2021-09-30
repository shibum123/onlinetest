package com.catlin.cargo.model.proxy {
	
	import com.catlin.cargo.model.reference.country.Country;
	
	import org.granite.tide.events.TideResultEvent;
	import org.puremvc.as3.interfaces.IProxy;

	public class CountryProxy extends BaseProxy implements IProxy {
		
		public static const NAME:String = 'CountryProxy';
		public static const LIST_COUNTRIES_OF_RISK_COMPLETE:String = 'listCountriesOfRiskComplete';
		public static const LIST_COUNTRIES_COMPLETE:String = 'listCountriesComplete';
		public static const LIST_PROVINCES_COMPLETE:String = 'listProvincesComplete';
		public static const LIST_COUNTRIES_OF_RISK_REGION_COMPLETE:String="listCountriesOfRiskRegionComplete";

		public function CountryProxy() {
			super( NAME );
		}

		public function listCountriesOfRisk():void {
			tideContext.referenceDataService.listCountriesOfRisk(onListCountriesOfRisk, onRemoteFault);
		}

		public function onListCountriesOfRisk(event:TideResultEvent):void {
			sendNotification(LIST_COUNTRIES_OF_RISK_COMPLETE, event.result);
		}
		
		public function listCountriesByName():void {
			tideContext.referenceDataService.listCountriesByName(onListCountriesByName, onRemoteFault);
		}
		
		public function onListCountriesByName(event:TideResultEvent):void {
			sendNotification(LIST_COUNTRIES_COMPLETE, event.result);
		}

		public function listProvincesByCountry(country:Country):void {
			tideContext.referenceDataService.listProvincesByCountry(country, onListProvincesByCountry, onRemoteFault);
		}
		
		public function onListProvincesByCountry(event:TideResultEvent):void {
			sendNotification(LIST_PROVINCES_COMPLETE, event.result);
		}		
	}
}