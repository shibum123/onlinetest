package com.catlin.cargo.view.risk.mta {
	import com.catlin.cargo.ApplicationFacade;
	import com.catlin.cargo.model.core.risk.Risk;
	import com.catlin.cargo.validation.ValidationUtil;
	
	import flash.events.Event;
	
	import mx.binding.utils.BindingUtils;
	import mx.collections.ArrayCollection;
	import mx.events.FlexEvent;
	import mx.formatters.DateFormatter;
	
	import org.puremvc.as3.interfaces.IMediator;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;

	public class MTATitleWindowMediator extends Mediator implements IMediator {

		private static var FALSE:uint = 0;
		private static var TRUE:uint = 1;

		public static const NAME:String = 'MTATitleWindowMediator';
		private var risk:Risk;
		private var earliestDate:Date;

		public function MTATitleWindowMediator(viewComponent:MTATitleWindow) {
			super(NAME, viewComponent);
		}

		public function set midTermAdjustmentReasons(midTermAdjustmentReasons:ArrayCollection):void {
			mtaTitleWindow.cboMtaReasons.dataProvider = midTermAdjustmentReasons;
		}

		public function initialise(risk:Risk):void {
			this.risk = risk;

			if (ApplicationFacade.getInstance().userInfo.isUnderwriter) {
				earliestDate = risk.startDate;
			} else {
				var currentDate:Date = new Date();
				currentDate = new Date(currentDate.fullYear, currentDate.month, currentDate.date);
				earliestDate = (risk.startDate < currentDate) ? currentDate : risk.startDate;
			}

			mtaTitleWindow.dtfEndorsementDate.selectableRange = { rangeStart: earliestDate,
					rangeEnd: risk.policyEndDateAsDate };
			mtaTitleWindow.dtfEndorsementDate.formatString = ApplicationFacade.getInstance().localeFormat.dateShort4Year2MonthDay; //"DD/MM/YYYY";
			BindingUtils.bindProperty(mtaTitleWindow.dtfEndorsementDate, "formatString", ApplicationFacade.getInstance(), ["localeFormat", "dateShort4Year2MonthDay"]);
			
			mtaTitleWindow.buttonBar.btnOK.addEventListener(FlexEvent.BUTTON_DOWN, onSend);
			mtaTitleWindow.buttonBar.btnCancel.addEventListener(FlexEvent.BUTTON_DOWN, onCancel);
		}

		private function get mtaTitleWindow():MTATitleWindow {
			return viewComponent as MTATitleWindow;
		}

		override public function listNotificationInterests():Array {
			return [];
		}

		override public function handleNotification(note:INotification):void {
			switch (note.getName()) {
			}
		}

		private function onSend(event:Event):void {
			if (validate()) {
				sendNotification(ApplicationFacade.REQUEST_MTA, { risk: risk, 
									 endorsementDate: mtaTitleWindow.dtfEndorsementDate.selectedDate,
									 reason: mtaTitleWindow.cboMtaReasons.selectedItem,
									 request: mtaTitleWindow.txaRequest.text });
				ApplicationFacade.closePopUpWindow(mtaTitleWindow, NAME);
			}
		}

		private function validate():Boolean {
			var errors:uint = FALSE;

			errors |= ValidationUtil.valueRequired(mtaTitleWindow.dtfEndorsementDate, "Endorsement start date is required") | ValidationUtil.valueRequired(mtaTitleWindow.cboMtaReasons, "Reason for change is required");

			if (mtaTitleWindow.cboMtaReasons.selectedLabel == "Other") {
				errors |= ValidationUtil.valueRequired(mtaTitleWindow.txaRequest, "Description of change is required for reason 'Other'");
			}

			var selectedDate:Date = mtaTitleWindow.dtfEndorsementDate.selectedDate;

			if (selectedDate) {
				if (selectedDate.time < earliestDate.time) {
					errors = TRUE;
					var df:DateFormatter = new DateFormatter();
					df.formatString = ApplicationFacade.getInstance().localeFormat.dateShort4Year2MonthDay;
					ValidationUtil.markFieldError(mtaTitleWindow.dtfEndorsementDate, "Endorsement start date cannot be earlier than " + df.format(earliestDate));
				}
			} else {
				errors |= ValidationUtil.valueRequired(mtaTitleWindow.dtfEndorsementDate, "Endorsement start date is required");
			}

			return errors == FALSE;
		}

		private function onCancel(event:Event):void {
			ApplicationFacade.closePopUpWindow(mtaTitleWindow, NAME);
		}
	}
}