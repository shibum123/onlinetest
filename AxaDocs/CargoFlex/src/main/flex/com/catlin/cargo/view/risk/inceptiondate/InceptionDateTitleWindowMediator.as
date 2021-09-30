package com.catlin.cargo.view.risk.inceptiondate {
	import com.catlin.cargo.ApplicationFacade;
	import com.catlin.cargo.bundles.RB_ui;
	import com.catlin.cargo.model.core.risk.Risk;
	import com.catlin.cargo.validation.ValidationUtil;
	import com.catlin.cargo.view.BaseMediator;
	
	import flash.events.Event;
	
	import mx.binding.utils.BindingUtils;
	import mx.events.FlexEvent;
	import mx.managers.PopUpManager;
	
	import org.puremvc.as3.interfaces.IMediator;
	import org.puremvc.as3.interfaces.INotification;
	

	public class InceptionDateTitleWindowMediator extends BaseMediator implements IMediator {
		
		public static const NAME:String = 'InceptionDateTitleWindowMediator';
		
		private var _currentQuote:Risk;
		private var currentDate:Date = new Date();

		public function InceptionDateTitleWindowMediator(viewComponent:InceptionDateTitleWindow) {
			super(NAME, viewComponent);
			inceptionDateTitleWindow.initialize();
			inceptionDateTitleWindow.okButton.addEventListener(FlexEvent.BUTTON_DOWN, onOk);
			inceptionDateTitleWindow.cancelButton.addEventListener(FlexEvent.BUTTON_DOWN, onCancel);
			
			currentDate = new Date(currentDate.fullYear, currentDate.month, currentDate.date);
			inceptionDateTitleWindow.policyStartDate.selectedDate = currentDate;
			inceptionDateTitleWindow.policyStartDate.selectableRange = {rangeStart: currentDate}; 
			inceptionDateTitleWindow.policyStartDate.formatString = ApplicationFacade.getInstance().localeFormat.dateShort4Year; //"DD/MM/YYYY";
			BindingUtils.bindProperty(inceptionDateTitleWindow.policyStartDate, "formatString", ApplicationFacade.getInstance(), ["localeFormat", "dateShort4Year"]);
		}
		
		[Bindable]
		public function get currentQuote():Risk {
			return _currentQuote;
		}
		
		public function set currentQuote(quote:Risk):void {
			_currentQuote = quote;
		}

		private function get inceptionDateTitleWindow():InceptionDateTitleWindow {
			return viewComponent as InceptionDateTitleWindow;
		}
		
		override public function listNotificationInterests():Array {
			return [];
		}
		
		override public function handleNotification(note:INotification):void {
			switch (note.getName()) {
			}
		}
		
		private function onOk(event:Event):void {
			if (validate()) {
				currentQuote.updatePolicyStartDate(inceptionDateTitleWindow.policyStartDate.selectedDate);
				currentQuote.updatePolicyEndDate(inceptionDateTitleWindow.policyStartDate.selectedDate, ApplicationFacade.getInstance().userInfo);
				currentQuote.policyStartDateAsDate = currentQuote.policyStartDateAsDate;
				PopUpManager.removePopUp(inceptionDateTitleWindow);
				sendNotification(ApplicationFacade.ACCEPT_QUOTE, currentQuote);
			}
		}
		
		private function onCancel(event:Event):void {
			PopUpManager.removePopUp(inceptionDateTitleWindow);
		}
		
		private function validate():Boolean {
			var ret:Boolean = true;
			var startDate:Date = inceptionDateTitleWindow.policyStartDate.selectedDate;
			
			if (startDate == null) {
				ValidationUtil.markFieldError(inceptionDateTitleWindow.policyStartDate, 
					rm.getString(RB_ui.RB_NAME, RB_ui.INCEPTION_DATE_MEDIATOR_REQUIRED_INCEPTION_DATE));
				ret = false;
			} else {
				if (currentDate.time > startDate.time) {
					ValidationUtil.markFieldError(inceptionDateTitleWindow.policyStartDate, 
						rm.getString(RB_ui.RB_NAME, RB_ui.INCEPTION_DATE_MEDIATOR_ERROR_INCEPTION_DATE));
					ret = false;
				}
			}
			return ret;
		}
		
	}
}