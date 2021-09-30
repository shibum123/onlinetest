package com.catlin.cargo.view.terms {
	import com.catlin.cargo.ApplicationFacade;
	import com.catlin.cargo.bundles.RB_ui;
	
	import mx.events.FlexEvent;
	import mx.resources.ResourceManager;
	
	import org.puremvc.as3.interfaces.IMediator;
	import org.puremvc.as3.patterns.mediator.Mediator;
	
	public class TermsOfUseTitleWindowMediator extends Mediator implements IMediator {
		
		public static const NAME:String = 'TermsOfUseTitleWindowMediator';
		
		public function TermsOfUseTitleWindowMediator(viewComponent:TermsOfUseTitleWindow) {
			super(NAME, viewComponent);
			
			termsOfUseTitleWindow.ifrTerms.source = this.getIframeSource();
			
			termsOfUseTitleWindow.btnOk.addEventListener(FlexEvent.BUTTON_DOWN, onCancel); 
			termsOfUseTitleWindow.btnAccept.addEventListener(FlexEvent.BUTTON_DOWN, onAccept); 
			termsOfUseTitleWindow.btnDecline.addEventListener(FlexEvent.BUTTON_DOWN, onDecline); 
		}
		
		public function configureAcceptance():void {
			termsOfUseTitleWindow.btnAccept.visible = true;
			termsOfUseTitleWindow.btnAccept.includeInLayout = true;
			termsOfUseTitleWindow.btnDecline.visible = true;
			termsOfUseTitleWindow.btnDecline.includeInLayout = true;
			termsOfUseTitleWindow.btnOk.visible = false;
			termsOfUseTitleWindow.btnOk.includeInLayout = false;
		}
		
		private function get termsOfUseTitleWindow():TermsOfUseTitleWindow {
			return viewComponent as TermsOfUseTitleWindow;
		}
		
		private function onCancel(event:FlexEvent):void {
			this.closePopUp();
		}
		
		private function onAccept(event:FlexEvent):void {
			sendNotification(ApplicationFacade.ACCEPT_TERMS_OF_USE);
			this.closePopUp();
		}
		
		private function onDecline(event:FlexEvent):void {
			ApplicationFacade.getInstance().logout();
		}
		
		private function closePopUp():void {
			viewComponent.ifrTerms.removeIFrame()
			ApplicationFacade.closePopUpWindow(termsOfUseTitleWindow, NAME);
		}
		
		private function getIframeSource():String {
			return ResourceManager.getInstance().getString(RB_ui.RB_NAME,RB_ui.TERMS_OF_USE_SOURCE);
		}
	}
}