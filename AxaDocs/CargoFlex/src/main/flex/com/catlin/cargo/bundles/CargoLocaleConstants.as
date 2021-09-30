package com.catlin.cargo.bundles {
	
	import flash.utils.Dictionary;

	public class CargoLocaleConstants {
		
		public function CargoLocaleConstants() {
		}

		

		public static const COUNTRY_ISO_US:String='US';
		public static const COUNTRY_ISO_GB:String='GB';
		public static const COUNTRY_ISO_IE:String='IE';
		public static const COUNTRY_ISO_HK:String='HK';
		public static const COUNTRY_ISO_SG:String='SG';
		public static const COUNTRY_ISO_MT:String='MT'; // Malta
		public static const COUNTRY_ISO_AU:String='AU'; // Australia
		public static const COUNTRY_ISO_MY:String='MY'; // Malasya
		public static const COUNTRY_ISO_CA:String='CA'; // Canada
		public static const COUNTRY_ISO_CH:String='CH'; // Switzerland 

		public static const COUNTRY_LOCALE_US:String='en_US';
		public static const COUNTRY_LOCALE_GB:String='en_GB';
		public static const COUNTRY_LOCALE_IE:String='en_IE';
		public static const COUNTRY_LOCALE_HK:String='en_HK';
		public static const COUNTRY_LOCALE_SG:String='en_SG';
		public static const COUNTRY_LOCALE_MT:String='en_MT';
		public static const COUNTRY_LOCALE_AU:String='en_AU';

		public static var localesChainMap:Dictionary;

		private static var initialised:Boolean=initialise();

		private static function initialise():Boolean {
			if (!initialised) {
				localesChainMap=new Dictionary();
				localesChainMap[COUNTRY_LOCALE_GB]=[COUNTRY_LOCALE_GB];
				localesChainMap[COUNTRY_LOCALE_US]=[COUNTRY_LOCALE_US, COUNTRY_LOCALE_GB];
				localesChainMap[COUNTRY_LOCALE_HK]=[COUNTRY_LOCALE_HK, COUNTRY_LOCALE_GB];
				localesChainMap[COUNTRY_LOCALE_SG]=[COUNTRY_LOCALE_SG, COUNTRY_LOCALE_GB];
			}
			return true;
		}
	}
}
