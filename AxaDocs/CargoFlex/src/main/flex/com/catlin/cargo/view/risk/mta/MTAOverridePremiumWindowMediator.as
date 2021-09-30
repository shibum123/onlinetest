package com.catlin.cargo.view.risk.mta {
	import com.catlin.cargo.ApplicationFacade;
	import com.catlin.cargo.model.core.risk.Risk;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import org.puremvc.as3.interfaces.IMediator;
	import org.puremvc.as3.patterns.mediator.Mediator;

	public class MTAOverridePremiumWindowMediator extends Mediator implements IMediator {

		public static const NAME:String = 'MTAOverridePremiumWindowMediator';
		
		private var confirmFunc:Function;
		private var removeFunc:Function;

		public function MTAOverridePremiumWindowMediator(viewComponent:MTAOverridePremiumWindow) {
			super(NAME, viewComponent);
		}

		override public function onRegister():void {
			window.btnConfirm.addEventListener(MouseEvent.CLICK, onConfirm);
			window.btnCancel.addEventListener(MouseEvent.CLICK, onCancel);
			window.btnRemove.addEventListener(MouseEvent.CLICK, onRemoveOverride);
		}

		private function get window():MTAOverridePremiumWindow {
			return viewComponent as MTAOverridePremiumWindow;
		}
		
		public function set confirmFunction(func:Function): void {
			this.confirmFunc = func;
		}
		
		public function set removeFunction(func:Function): void {
			this.removeFunc = func;
		}
		
		public function set quote(quote:Risk): void {
			window.quote = quote;
		}

		private function onConfirm(event:Event):void {
			ApplicationFacade.closePopUpWindow(window, NAME);
			confirmFunc(window.requiredAdditionalPremium.data, window.requiredAdditionalTriaPremium.data);
		}
		
		private function onRemoveOverride(event:Event):void {
			ApplicationFacade.closePopUpWindow(window, NAME);
			removeFunc();
		}

		private function onCancel(event:Event):void {
			ApplicationFacade.closePopUpWindow(window, NAME);
		}
	}
}