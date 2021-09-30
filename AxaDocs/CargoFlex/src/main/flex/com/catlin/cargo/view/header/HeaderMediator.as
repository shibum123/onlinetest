package com.catlin.cargo.view.header {
	import com.catlin.cargo.ApplicationFacade;
	import com.catlin.cargo.model.proxy.LocaleProxy;
	import com.catlin.cargo.model.security.UserInfo;
	import com.catlin.cargo.view.BaseMediator;
	import com.catlin.ui.flex.widgets.EqualWidthLinkBar;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import mx.containers.ViewStack;
	import mx.controls.LinkButton;
	import mx.core.Container;
	
	import org.puremvc.as3.interfaces.IMediator;
	import org.puremvc.as3.interfaces.INotification;

	public class HeaderMediator extends BaseMediator implements IMediator {

		public static const NAME:String='HeaderMediator';

		public function HeaderMediator(viewComponent:Object) {
			super(NAME, viewComponent);
			viewObject.lnkTopMenu.linkClickHandler=onTopMenuClick;
			viewObject.logout_BT.addEventListener(MouseEvent.CLICK, onLogOut);

			var userInfo:UserInfo=ApplicationFacade.getInstance().userInfo;
			
			if (userInfo.username != null && userInfo.username.length > 17)
				viewObject.user_details_TX.text = userInfo.username.substr(0, 14) + "..."; 
			else
				viewObject.user_details_TX.text=userInfo.username;
			
			viewObject.user_details_TX.toolTip = userInfo.username;
			updateLayout();
		}

		public function get viewObject():Header {
			return viewComponent as Header;
		}

		private function onTopMenuClick(evt:MouseEvent):Boolean {
			
			if (isAdminitrationView(evt.currentTarget as LinkButton, evt.currentTarget.parent as EqualWidthLinkBar)) {
				sendNotification(ApplicationFacade.SHOW_ADMINISTRATION);
			}
			return true;
		}
		
		private function isAdminitrationView(currentLinkButton:LinkButton, linkBar:EqualWidthLinkBar):Boolean {
			var childIndex:int = linkBar.getChildIndex(currentLinkButton);
			var cont:Container = (linkBar.dataProvider as ViewStack).getChildAt(childIndex) as Container;
			return childIndex && cont && cont.id == ApplicationFacade.ADMIN_VIEW_ID;
		}

		private function onLogOut(e:Event):void {
			(facade as ApplicationFacade).logout();
		}

		override public function listNotificationInterests():Array {
			return [LocaleProxy.RETRIEVE_LOCALE_FORMAT_COMPLETE, ApplicationFacade.LF_PREVIEW_LOGO, ApplicationFacade.LF_RESET_LOGO];
		}

		override public function handleNotification(note:INotification):void {
			switch (note.getName()) {
				case LocaleProxy.RETRIEVE_LOCALE_FORMAT_COMPLETE:
					updateLayout();
					break;
				case ApplicationFacade.LF_PREVIEW_LOGO:
					viewObject.leftLogo.source=note.getBody() as String;
					viewObject.leftLogo.visible=true;
					viewObject.leftLogo.includeInLayout=true;
					viewObject.leftLogo.maintainAspectRatio=true;
					break;
				case ApplicationFacade.LF_RESET_LOGO:
					updateLayout();
					break;
			}
		}

		private function updateLayout():void {
			if (ApplicationFacade.getInstance().userInfo.lookAndFeel.logoUrl != null) {
				viewObject.leftLogo.source=ApplicationFacade.getInstance().userInfo.lookAndFeel.logoUrl;
				viewObject.leftLogo.visible=true;
				viewObject.leftLogo.includeInLayout=true;
			} else {
				viewObject.leftLogo.source=null;
				viewObject.leftLogo.visible=true;
				viewObject.leftLogo.includeInLayout=true;
			}
			viewObject.leftLogo.maintainAspectRatio=true;
		}

	}
}
