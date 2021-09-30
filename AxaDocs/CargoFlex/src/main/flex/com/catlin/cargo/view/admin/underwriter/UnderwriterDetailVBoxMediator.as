package com.catlin.cargo.view.admin.underwriter {

	import com.catlin.cargo.ApplicationFacade;
	import com.catlin.cargo.controller.PostcodeFetchCommand;
	import com.catlin.cargo.model.core.underwriter.Underwriter;
	import com.catlin.ui.flex.validator.PageValidator;
	
	import flash.events.Event;
	
	import mx.events.FlexEvent;
	
	import org.puremvc.as3.interfaces.IMediator;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;

	public class UnderwriterDetailVBoxMediator extends Mediator implements IMediator {

		public static const NAME:String='UnderwriterDetailVBoxMediator';
		private var validation:UnderwriterDetailValidationImpl=new UnderwriterDetailValidationImpl();
		private var fieldValidator:PageValidator=new PageValidator();

		private var underwriter:Underwriter;

		private var addressMediator:UnderwriterDetailAddressMediator;

		public function UnderwriterDetailVBoxMediator(viewComponent:UnderwriterDetailVBox) {
			super(NAME, viewComponent);
			validation.window=underwriterDetailVBox;
			fieldValidator.multiPageValidator.rules=validation.create();
			underwriterDetailVBox.txiPostcodeToLookup.addEventListener(Event.CHANGE, onChangePostcodeToLookup);
			underwriterDetailVBox.btnResetPassword.addEventListener(FlexEvent.BUTTON_DOWN, onResetPassword);
			underwriterDetailVBox.cbxAccountDisabled.addEventListener(FlexEvent.VALUE_COMMIT, onDisabledCommit);
			underwriterDetailVBox.btnSave.addEventListener(FlexEvent.BUTTON_DOWN, onSave);

			addressMediator=new UnderwriterDetailAddressMediator(underwriterDetailVBox);
			facade.registerMediator(addressMediator);
		}

		public function get underwriterDetailVBox():UnderwriterDetailVBox {
			return viewComponent as UnderwriterDetailVBox;
		}

		override public function listNotificationInterests():Array {
			return [ApplicationFacade.LOAD_UNDERWRITER, PostcodeFetchCommand.POSTCODE_FETCH_COMPLETE];
		}

		override public function handleNotification(note:INotification):void {
			switch (note.getName()) {
				case ApplicationFacade.LOAD_UNDERWRITER:
					onLoadUnderwriter(note);
					break;
			}
		}

		private function onDisabledCommit(event:FlexEvent):void {
			underwriterDetailVBox.txiUsername.enabled=!underwriterDetailVBox.cbxAccountDisabled.selected && underwriter != null && (underwriter.username == null || underwriter.username.length == 0);
			underwriterDetailVBox.btnResetPassword.enabled=!underwriterDetailVBox.cbxAccountDisabled.selected && underwriter != null && underwriter.username != null && underwriter.username.length > 0;
		}

		private function onChangePostcodeToLookup(event:Event):void {
			if (underwriterDetailVBox.txiPostcodeToLookup.text == "") {
				underwriterDetailVBox.btnLookupAddress.enabled=false;
			} else {
				underwriterDetailVBox.btnLookupAddress.enabled=true;
			}
		}

		private function onResetPassword(event:FlexEvent):void {
			sendNotification(ApplicationFacade.RESET_PASSWORD, underwriter.username);
		}

		private function onLoadUnderwriter(note:INotification):void {
			fieldValidator.reset();
			underwriter=note.getBody() as Underwriter;
			addressMediator.address=underwriter.address;
			addressMediator.originatingOfficeCode=underwriter.originatingOfficeCode;
			underwriterDetailVBox.txiName.text=underwriter.name;
			underwriterDetailVBox.txiUsername.text=underwriter.username;
			underwriterDetailVBox.txiTitle.text=underwriter.title;
			underwriterDetailVBox.txiRegion.text=underwriter.region;
			underwriterDetailVBox.txiEmailAddress.text=underwriter.emailAddress;
			underwriterDetailVBox.txiTelephoneNumber.text=underwriter.telephoneNumber;
			underwriterDetailVBox.txiFaxNumber.text=underwriter.faxNumber;
			underwriterDetailVBox.txiDDNumber.text=underwriter.directDialNumber;
			underwriterDetailVBox.txiMobileNumber.text=underwriter.mobileNumber;
			underwriterDetailVBox.cbxAccountDisabled.selected=!underwriter.enabled;
			onDisabledCommit(null);
		}

		private function onSave(event:FlexEvent):void {
			var addressValid:Boolean=addressMediator.validate();
			var underwriterFieldsValid:Boolean=fieldValidator.validate("underwriterDetailVBox", underwriterDetailVBox);
			if (addressValid && underwriterFieldsValid) {
				underwriter.name=underwriterDetailVBox.txiName.text;
				underwriter.username=(underwriterDetailVBox.txiUsername.text.length > 0) ? underwriterDetailVBox.txiUsername.text : null;
				underwriter.title=underwriterDetailVBox.txiTitle.text;
				underwriter.region=underwriterDetailVBox.txiRegion.text;
				underwriter.emailAddress=underwriterDetailVBox.txiEmailAddress.text;
				underwriter.telephoneNumber=underwriterDetailVBox.txiTelephoneNumber.text;
				underwriter.faxNumber=underwriterDetailVBox.txiFaxNumber.text;
				underwriter.directDialNumber=underwriterDetailVBox.txiDDNumber.text;
				underwriter.mobileNumber=underwriterDetailVBox.txiMobileNumber.text;
				underwriter.enabled=!underwriterDetailVBox.cbxAccountDisabled.selected;

				addressMediator.updateAddress(underwriter.address);

				// should only be doing this as an underwriter
				var currentUnderwriter:Underwriter=ApplicationFacade.getInstance().userInfo.party as Underwriter;
				underwriter.originatingOfficeCode=currentUnderwriter.originatingOfficeCode;

				sendNotification(ApplicationFacade.SAVE_UNDERWRITER, underwriter);
			}
		}
	}
}
