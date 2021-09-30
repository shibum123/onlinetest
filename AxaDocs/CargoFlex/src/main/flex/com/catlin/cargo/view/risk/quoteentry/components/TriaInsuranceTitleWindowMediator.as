package com.catlin.cargo.view.risk.quoteentry.components {
	import com.catlin.cargo.ApplicationFacade;
	import com.catlin.cargo.bundles.RB_ui;
	import com.catlin.cargo.model.core.risk.Risk;
	import com.catlin.cargo.model.core.risk.TriaInsuranceStatus;
	import com.catlin.cargo.validation.ValidationUtil;
	import com.catlin.cargo.view.BaseMediator;
	
	import flash.events.Event;
	
	import mx.events.FlexEvent;
	
	import org.puremvc.as3.interfaces.IMediator;

	public class TriaInsuranceTitleWindowMediator extends BaseMediator implements IMediator {

		public static const NAME:String='TRIATitleWindowMediator';

		private var _currentQuote:Risk;

		public function TriaInsuranceTitleWindowMediator(viewComponent:TriaInsuranceTitleWindow) {

			super(NAME, viewComponent);

			view.initialize();

			view.buttonBar.btnOK.addEventListener(FlexEvent.BUTTON_DOWN, onOk);
			view.buttonBar.btnCancel.addEventListener(FlexEvent.BUTTON_DOWN, onCancel);
		}

		private function get view():TriaInsuranceTitleWindow {
			return viewComponent as TriaInsuranceTitleWindow;
		}

		private function onOk(event:Event):void {
			if (validate()) {
				var triaResponse:TriaInsuranceStatus=view.TRIAoptions.selectedValue as TriaInsuranceStatus;
				sendNotification(ApplicationFacade.UPDATE_TRIA_INSURANCE, {quote: currentQuote, triaResponse: triaResponse});
				this.closePopUp();
			} else {
				currentQuote.hasAnsweredTriaInsurance = false;
			}
		}

		[Bindable]
		public function get currentQuote():Risk {
			return _currentQuote;
		}

		public function set currentQuote(quote:Risk):void {
			_currentQuote=quote;
		}

		private function closePopUp():void {
			ApplicationFacade.closePopUpWindow(view, NAME);
		}

		private function onCancel(event:Event):void {
			this.closePopUp();
		}

		private function validate():Boolean {
			var ret:Boolean=true;

			if (view.TRIAoptions.selection == null) {
				ValidationUtil.markFieldError(view.triaOptionsContainer,
					rm.getString(RB_ui.RB_NAME, RB_ui.TRIA_INSURANCE_VIEW_ERROR_MESSAGE));
				ret=false;
			}
			return ret;
		}
	}
}
