package com.catlin.cargo.controller
{
	import com.catlin.cargo.ApplicationFacade;
	import com.catlin.cargo.model.proxy.UsefulLinkProxy;
	import com.catlin.cargo.model.security.UserInfo;
	
	import mx.controls.Alert;
	
	import org.puremvc.as3.interfaces.INotification;

	public class PrepUsefulLinkCommand extends BaseCommand {
	
		override public function execute(notification:INotification):void {
	
			var userInfo:UserInfo = ApplicationFacade.getInstance().userInfo;
			if (userInfo) {
				if (!userInfo.isUnderwriter && !userInfo.isSupport) {
					if (userInfo.brokerOffice && userInfo.brokerOffice.usefulLinks)
						sendNotification(UsefulLinkProxy.FIND_ALL_USEFUL_LINKS_FOR_BROKER_COMPLETE, userInfo.brokerOffice.usefulLinks);
					else
						Alert.show("ERROR: The broker " + userInfo.username + " is not linked to a brokerOffice.");
				} else {
					var usefulLinkProxy:UsefulLinkProxy = facade.retrieveProxy(UsefulLinkProxy.NAME) as UsefulLinkProxy;
					usefulLinkProxy.listLinksForUnderwriter();
				}
			}
		}
	}
}