package com.catlin.cargo.view.risk.email {
	import com.catlin.cargo.ApplicationFacade;
	import com.catlin.cargo.model.core.risk.Risk;
	
	import flash.events.Event;
	
	import mx.collections.ArrayCollection;
	import mx.events.FlexEvent;
	
	import org.puremvc.as3.interfaces.IMediator;
	import org.puremvc.as3.patterns.mediator.Mediator;

	public class EmailConfirmationMediator extends Mediator implements IMediator {

		public static const NAME:String = 'EmailConfirmationMediator';

		private var _fragments:ArrayCollection;

		public function EmailConfirmationMediator(viewComponent:EmailConfirmation) {
			super(NAME, viewComponent);
			emailConfirmation.sendButton.addEventListener(FlexEvent.BUTTON_DOWN, onSend);
			emailConfirmation.cancelButton.addEventListener(FlexEvent.BUTTON_DOWN, onCancel);
		}

		[Bindable]
		public var currentQuote:Risk;

		[Bindable]
		public function get fragments():ArrayCollection {
			return _fragments;
		}

		public function set fragments(fragments:ArrayCollection):void {
			_fragments = fragments;
			emailConfirmation.txaStaticContentStart.htmlText = 
				(fragments.getItemAt(0) as String).replace(new RegExp("\n|\r", "g"), "").replace(new RegExp("\<\/p\>", "g"), "</p>\n");
			emailConfirmation.txaStaticContentStart.validateNow();
			emailConfirmation.txaStaticContentEnd.htmlText = 
				(fragments.getItemAt(1) as String).replace(new RegExp("\n|\r", "g"), "").replace(new RegExp("\<\/p\>", "g"), "</p>\n");
			emailConfirmation.txaStaticContentEnd.validateNow();
			
            emailConfirmation.txaStaticContentStart.height = emailConfirmation.txaStaticContentStart.textHeight + 10;
            emailConfirmation.txaStaticContentEnd.height = emailConfirmation.txaStaticContentEnd.textHeight + 10;
		}

		private function get emailConfirmation():EmailConfirmation {
			return viewComponent as EmailConfirmation;
		}

		private function onSend(event:Event):void {
			sendNotification(ApplicationFacade.SEND_TO_BROKER, {risk: currentQuote, comments: emailConfirmation.rteAdditionalComments.validHtmlText});
			ApplicationFacade.closePopUpWindow(emailConfirmation, NAME);
		}

		private function onCancel(event:Event):void {
			ApplicationFacade.closePopUpWindow(emailConfirmation, NAME);
		}
	}
}