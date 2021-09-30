package com.catlin.cargo.view.risk.decline {
	import com.catlin.cargo.ApplicationFacade;
	import com.catlin.cargo.bundles.RB_ui;
	import com.catlin.cargo.model.core.risk.Risk;
	import com.catlin.cargo.model.core.risk.RiskStatus;
	import com.catlin.cargo.model.reference.declinereason.DeclineReason;
	import com.catlin.cargo.view.BaseMediator;
	import com.catlin.ui.flex.validator.PageValidator;
	
	import flash.events.Event;
	
	import mx.binding.utils.BindingUtils;
	import mx.collections.ArrayCollection;
	import mx.events.FlexEvent;
	import mx.managers.PopUpManager;
	
	import org.puremvc.as3.interfaces.IMediator;
	

	public class DeclineReasonMediator extends BaseMediator implements IMediator {
		
		public static const NAME:String = 'DeclineReasonMediator';
		
		private var allErrors:Array = new Array();
		private var validation:ValidationImpl = new ValidationImpl();
		private var fieldValidator:PageValidator = new PageValidator();

		private var _risk:Risk;

		public function DeclineReasonMediator(viewComponent:DeclineReasonTitleWindow) {
			super(NAME, viewComponent);
			validation.window = declineReasonTitleWindow;
			fieldValidator.multiPageValidator.rules = validation.create();
			declineReasonTitleWindow.okButton.addEventListener(FlexEvent.BUTTON_DOWN, onOk);
			declineReasonTitleWindow.cancelButton.addEventListener(FlexEvent.BUTTON_DOWN, onCancel);
			
			var currentDate:Date = new Date();
			currentDate = new Date(currentDate.fullYear, currentDate.month, currentDate.date);
			declineReasonTitleWindow.dtfEffectiveDate.selectedDate = currentDate;
			declineReasonTitleWindow.dtfEffectiveDate.formatString = ApplicationFacade.getInstance().localeFormat.dateShort4Year2MonthDay; //"DD/MM/YYYY";
			BindingUtils.bindProperty(declineReasonTitleWindow.dtfEffectiveDate, "formatString", ApplicationFacade.getInstance(), ["localeFormat", "dateShort4Year2MonthDay"]);
		}
		
		public function get risk():Risk {
			return _risk;
		}
		
		public function set risk(risk:Risk):void {
			_risk = risk;
			validation.risk = risk;
			if (risk.status == RiskStatus.POLICY) {
				declineReasonTitleWindow.fmiEffectiveDateItem.visible = true;
				declineReasonTitleWindow.fmiEffectiveDateItem.includeInLayout = true;
				declineReasonTitleWindow.dtfEffectiveDate.selectableRange = {rangeStart: risk.policyStartDateAsDate , rangeEnd: risk.policyEndDateAsDate}; 
			}
			updateLabels();
		}
		
		public function setDeclineReasons(declineReasons:ArrayCollection):void {
			var reasons:ArrayCollection = new ArrayCollection();
			var isUnderwriter:Boolean = ApplicationFacade.getInstance().userInfo.isUnderwriter;
			for each (var reason:DeclineReason in declineReasons) {
				if (isUnderwriter || reason.brokerViewable) {
					reasons.addItem(reason.description);
				}
			}
			reasons.addItem(rm.getString(RB_ui.RB_NAME, RB_ui.DECLINE_REASON_MEDIATOR_OTHER));
			declineReasonTitleWindow.cboReasons.dataProvider = reasons;
		}

		private function get declineReasonTitleWindow():DeclineReasonTitleWindow {
			return viewComponent as DeclineReasonTitleWindow;
		}
		
		private function updateLabels():void {
			switch (risk.status) {
				case RiskStatus.POLICY:
					declineReasonTitleWindow.title = rm.getString(RB_ui.RB_NAME, RB_ui.DECLINE_REASON_MEDIATOR_CANCEL_POLICY_TITLE);
					declineReasonTitleWindow.txtDescription.text = rm.getString(RB_ui.RB_NAME, RB_ui.DECLINE_REASON_MEDIATOR_CANCEL_POLICY_DESCRIPTION);
					break;
				case RiskStatus.QUOTED:
					declineReasonTitleWindow.title = rm.getString(RB_ui.RB_NAME, RB_ui.DECLINE_REASON_MEDIATOR_NTU_QUOTE_TITLE);
					declineReasonTitleWindow.txtDescription.text = rm.getString(RB_ui.RB_NAME, RB_ui.DECLINE_REASON_MEDIATOR_NTU_QUOTE_DESCRIPTION);
					break;
				default:
					declineReasonTitleWindow.title = rm.getString(RB_ui.RB_NAME, RB_ui.DECLINE_REASON_MEDIATOR_DECLINE_TITLE);
					declineReasonTitleWindow.txtDescription.text = rm.getString(RB_ui.RB_NAME, RB_ui.DECLINE_REASON_MEDIATOR_DECLINE_DESCRIPTION);
					break;
			}
		}
		
		private function onOk(event:Event):void {
			if (fieldValidator.validate("declineReasonTitleWindow", declineReasonTitleWindow)) {
				var reason:String = declineReasonTitleWindow.cboReasons.selectedItem as String;
				if (reason == rm.getString(RB_ui.RB_NAME, RB_ui.DECLINE_REASON_MEDIATOR_OTHER)) {
					reason = declineReasonTitleWindow.cboOtherReason.text;
				}
				PopUpManager.removePopUp(declineReasonTitleWindow);
				if (risk.status == RiskStatus.POLICY) {
					sendNotification(ApplicationFacade.CANCEL_POLICY, 
						{risk: risk, comments: reason, effectiveDate: declineReasonTitleWindow.dtfEffectiveDate.selectedDate});
				} else {
					sendNotification(ApplicationFacade.DECLINE_RISK, {risk: risk, comments: reason});
				}
			}
		}

		private function onCancel(event:Event):void {
			PopUpManager.removePopUp(declineReasonTitleWindow);
		}
	}
}