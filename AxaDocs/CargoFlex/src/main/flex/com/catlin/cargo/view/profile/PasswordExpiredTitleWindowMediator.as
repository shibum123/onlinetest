package com.catlin.cargo.view.profile {
	import com.catlin.cargo.ApplicationFacade;
	import com.catlin.cargo.controller.ChangePasswordCommand;
	
	import org.puremvc.as3.interfaces.IMediator;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;

	public class PasswordExpiredTitleWindowMediator extends Mediator implements IMediator {

		public static const NAME:String = 'PasswordExpiredTitleWindowMediator';
		
		private var changePasswordMediator:ChangePasswordMediator;

		public function PasswordExpiredTitleWindowMediator(viewComponent:PasswordExpiredTitleWindow) {
			super(NAME, viewComponent);
			changePasswordMediator = new ChangePasswordMediator(passwordExpiredTitleWindow.changePasswordForm);
			facade.registerMediator(changePasswordMediator);
		}

		private function get passwordExpiredTitleWindow():PasswordExpiredTitleWindow {
			return viewComponent as PasswordExpiredTitleWindow;
		}
		
		override public function listNotificationInterests():Array {
			return [ ChangePasswordCommand.PASSWORD_CHANGED ];
		}
		
		override public function handleNotification(note:INotification):void {
			facade.removeMediator(ChangePasswordMediator.NAME);
			ApplicationFacade.closePopUpWindow(passwordExpiredTitleWindow, NAME);
		}

	}
}