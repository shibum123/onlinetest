package com.catlin.cargo.controller
{
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	
	import org.puremvc.as3.interfaces.INotification;
	
	public class LogoutCommand extends BaseCommand {
		
		public function LogoutCommand() {
		}
	
		override public function execute(notification:INotification):void {
			tideContext.identity.logout();
			navigateToURL(new URLRequest("j_spring_security_logout"), "_top");
		}
	}
}