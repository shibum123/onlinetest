package com.catlin.cargo.model.proxy {
	
	import com.catlin.cargo.ApplicationFacade;
	import com.catlin.cargo.bundles.RB_ui;
	import com.catlin.ui.flex.widgets.error.ErrorPopup;
	
	import mx.controls.Alert;
	import mx.events.CloseEvent;
	import mx.resources.IResourceManager;
	import mx.resources.ResourceManager;
	
	import org.granite.tide.events.TideFaultEvent;
	import org.granite.tide.spring.Context;
	import org.granite.tide.spring.Spring;
	import org.puremvc.as3.interfaces.IProxy;
	import org.puremvc.as3.patterns.proxy.Proxy;

	public class BaseProxy extends Proxy implements IProxy {
	
        protected var tideContext:Context = Spring.getInstance().getSpringContext();

		protected function get rm():IResourceManager {
			return ResourceManager.getInstance();
		}		
		
		public function BaseProxy(name:String) {
			super(name);
		}

		protected function onRemoteFault(event:TideFaultEvent):void {
            switch (event.fault.faultCode) {
                case "Server.Security.NotLoggedIn":
                	ApplicationFacade.getInstance().logout();
                    break;
                case "Server.Security.SessionExpired":
                	Alert.show(rm.getString(RB_ui.RB_NAME, RB_ui.BASEPROXY_ERROR_SESSIONEXPIRED_MESSAGE), 
						rm.getString(RB_ui.RB_NAME, RB_ui.BASEPROXY_ERROR_SESSIONEXPIRED_TITLE), 
						Alert.OK, 
						null, 
                		function(event:CloseEvent):void {ApplicationFacade.getInstance().logout();});
                    break;
                case "Server.Security.AccessDenied":
					Alert.show(rm.getString(RB_ui.RB_NAME, RB_ui.BASEPROXY_ERROR_ACCESSDENIED_MESSAGE), 
						rm.getString(RB_ui.RB_NAME, RB_ui.BASEPROXY_ERROR_ACCESSDENIED_TITLE));
                    break;
                default:
					ErrorPopup.show(event.fault);
            }
		}
	}
}