package com.catlin.cargo.controller {
	import com.catlin.cargo.ApplicationFacade;
	import com.catlin.cargo.model.proxy.LocaleProxy;
	
	import flash.external.ExternalInterface;
	
	import org.puremvc.as3.interfaces.INotification;


	public class PrepareApplicationCommand extends BaseCommand {

		/**
		 * Prepare the application before mediators, etc are initialised
		 */
		override public function execute(note:INotification):void {
			facade.registerProxy(new LocaleProxy());

			// Try for IE user regional language setting
			var locale:String = ExternalInterface.call("function(){return navigator.userLanguage;}");
			if (locale == "" || "undefined" == locale || locale == null) {
				// Fall back to default system language 
				locale = ExternalInterface.call("function(){return navigator.language;}");
				if ("undefined" == locale || locale == null) {
					locale = "en_GB";
				}
			}
			// Convert to format required
			if (locale.length == 2) {
				// Locale is eg 'de'
				locale = locale + '_' + locale.toUpperCase();
			} else {
				locale = locale.substr(0, 2) + '_' + (locale.substr(3, 2).toUpperCase());
			}
			(facade.retrieveProxy(LocaleProxy.NAME) as LocaleProxy).retrieveLocaleFormat(locale);
		}
	}
}
