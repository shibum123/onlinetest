package com.catlin.cargo.view.profile {
	import com.catlin.cargo.ApplicationFacade;
	import com.catlin.ui.flex.validator.PageValidator;
	
	import flash.events.Event;
	
	import mx.events.FlexEvent;
	
	import org.puremvc.as3.interfaces.IMediator;
	import org.puremvc.as3.patterns.mediator.Mediator;
	
	import com.catlin.cargo.view.profile.components.ChangePasswordForm;

	public class ChangePasswordMediator extends Mediator implements IMediator { 

		public static const NAME:String = 'ChangePasswordMediator';
		private var validation:ChangePasswordValidationImpl = new ChangePasswordValidationImpl();
		private var fieldValidator:PageValidator = new PageValidator();

		public function ChangePasswordMediator(viewComponent:ChangePasswordForm) {
			super(NAME, viewComponent);
			validation.window = profileForm;
			fieldValidator.multiPageValidator.rules = validation.create();
			profileForm.confirmationButtonbar.btnOK.addEventListener(FlexEvent.BUTTON_DOWN, onConfirmChangePassword);
			profileForm.confirmationButtonbar.btnCancel.addEventListener(FlexEvent.BUTTON_DOWN, onResetChangePasswordForm);
		}

		public function get profileForm ():ChangePasswordForm {
			return viewComponent as ChangePasswordForm;
		}
		
		protected function onResetChangePasswordForm(evt:Event):void {
			profileForm.txiOldPassword.text = null;
			profileForm.txiNewPassword.text = null;
			profileForm.txiReenterPassword.text = null;
		}
		
		protected function onConfirmChangePassword(evt:Event):void {
			if (fieldValidator.validate("profileForm", profileForm)) {
				sendNotification(ApplicationFacade.CHANGE_PASSWORD, {
					oldPassword: profileForm.txiOldPassword.text, 
					newPassword: profileForm.txiNewPassword.text});
				onResetChangePasswordForm(evt);
			}
		}

	}
}