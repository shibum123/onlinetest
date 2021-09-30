package com.catlin.cargo.controller
{
	import com.catlin.cargo.ApplicationFacade;
	import com.catlin.cargo.bundles.RB_ui;
	import com.catlin.ui.flex.widgets.error.ErrorPopup;
	
	import mx.controls.Alert;
	import mx.resources.IResourceManager;
	import mx.resources.ResourceManager;
	
	import org.granite.tide.events.TideFaultEvent;
	import org.granite.tide.spring.Context;
	import org.granite.tide.spring.Spring;
	import org.puremvc.as3.interfaces.ICommand;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	public class BaseCommand extends SimpleCommand implements ICommand {
	
        protected var tideContext:Context = Spring.getInstance().getSpringContext();
		protected var data:Object;
		
		protected function get rm():IResourceManager {
			return ResourceManager.getInstance();
		}

		protected function onRemoteFault(event:TideFaultEvent):void {
            switch (event.fault.faultCode) {
                case "Server.Security.SessionExpired":
                case "Server.Security.NotLoggedIn":
                	ApplicationFacade.getInstance().logout();
                    break;
                case "Server.Security.AccessDenied":
                	Alert.show(rm.getString(RB_ui.RB_NAME, RB_ui.ACCESS_DENIED_MESSAGE), 
							   rm.getString(RB_ui.RB_NAME, RB_ui.ACCESS_DENIED_TITLE));
                    break;
                default:
					ErrorPopup.show(event.fault);
            }
		}
	}
}