package com.catlin.cargo.controller
{
	import com.catlin.cargo.ApplicationFacade;
	import com.catlin.cargo.model.security.UserInfo;
	
	import org.granite.tide.events.TideResultEvent;
	import org.puremvc.as3.interfaces.INotification;
	
	public class AcceptTermsOfUseCommand extends BaseCommand {

		override public function execute(notification:INotification):void {
			tideContext.userService.acceptTerms(onAcceptTerms, onRemoteFault);
		}
		
		private function onAcceptTerms(event:TideResultEvent):void {
		    var userInfo:UserInfo = event.result as UserInfo;
		    ApplicationFacade.getInstance().configureStyle(userInfo.lookAndFeel);
			userInfo.initialiseRoles();
			ApplicationFacade.getInstance().userInfo = userInfo;
		}
	}
}
