package com.catlin.cargo.controller
{
	import com.catlin.cargo.ApplicationFacade;
	import com.catlin.cargo.model.proxy.LocaleProxy;
	import com.catlin.cargo.model.security.UserInfo;
	import com.catlin.cargo.view.profile.PasswordExpiredTitleWindow;
	import com.catlin.cargo.view.profile.PasswordExpiredTitleWindowMediator;
	import com.catlin.cargo.view.terms.TermsOfUseTitleWindow;
	import com.catlin.cargo.view.terms.TermsOfUseTitleWindowMediator;
	
	import flash.external.ExternalInterface;
	
	import org.granite.tide.events.TideResultEvent;
	import org.puremvc.as3.interfaces.INotification;
	
	public class LoadCurrentUserInfoCommand extends BaseCommand {

		override public function execute(notification:INotification):void {
			tideContext.userService.getCurrentUserInfo(onGetCurrentUserInfo, onRemoteFault);
		}
		
		private function onGetCurrentUserInfo(event:TideResultEvent):void {
			
			var appFacade:ApplicationFacade = ApplicationFacade.getInstance();
			
		    var userInfo:UserInfo = event.result as UserInfo;
			appFacade.configureStyle(userInfo.lookAndFeel);
			
			var currentUserLocale:String = this.resolveApplicationLocale(userInfo); 
			appFacade.currentLocale = currentUserLocale;
			appFacade.sessionLocale = currentUserLocale;
			appFacade.initializeLocalization();
			
			if (userInfo.credentialsExpired) {
				ApplicationFacade.openPopUpWindow(PasswordExpiredTitleWindow, PasswordExpiredTitleWindowMediator);
			}

		    if (!userInfo.termsAccepted) {
		    	var tm:TermsOfUseTitleWindowMediator = 
		    		ApplicationFacade.openPopUpWindow(TermsOfUseTitleWindow, TermsOfUseTitleWindowMediator) as TermsOfUseTitleWindowMediator;
		    	tm.configureAcceptance();
		    } else {
				userInfo.initialiseRoles();
				appFacade.userInfo = userInfo;
		    }
			
			// Initialize the locale Proxy with the user Locale.
			facade.registerProxy(new LocaleProxy());
			(facade.retrieveProxy(LocaleProxy.NAME) as LocaleProxy).retrieveLocaleFormat(appFacade.sessionLocale);
		}
		
		private function resolveApplicationLocale(userInfo:UserInfo):String {
			var retLocale:String = null;
			if (userInfo && userInfo.originatingOffice && userInfo.originatingOffice.locale)
				retLocale=userInfo.originatingOffice.locale;
			else
				retLocale=getBrowserLocale();
			
			return retLocale;
		}
		
		private function getBrowserLocale():String {
			
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
			
			return locale;
		}
	}
}