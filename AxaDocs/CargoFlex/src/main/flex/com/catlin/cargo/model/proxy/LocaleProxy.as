package com.catlin.cargo.model.proxy {
	
	import com.catlin.cargo.ApplicationFacade;
	import com.catlin.cargo.model.locale.LocaleFormat;
	
	import org.granite.tide.events.TideResultEvent;
	import org.puremvc.as3.interfaces.IProxy;

	public class LocaleProxy extends BaseProxy implements IProxy {
	
		public static const NAME:String = 'LocaleProxy';
		public static const RETRIEVE_LOCALE_FORMAT_COMPLETE:String = 'RETRIEVE_LOCALE_FORMAT_COMPLETE';

		public function LocaleProxy() {
			super( NAME );
		}
		
		public function retrieveLocaleFormat(locale:String):void {
			tideContext.localeService.getFlexFormatForLocale(locale, onRetrieveLocaleFormat, onRemoteFault);
		}
		
		private function onRetrieveLocaleFormat(event:TideResultEvent):void {
			ApplicationFacade.getInstance().localeFormat = event.result as LocaleFormat;
			sendNotification(RETRIEVE_LOCALE_FORMAT_COMPLETE);
		}
	}
}