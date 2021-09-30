package com.catlin.cargo.view.risk.coverperiod
{
	import com.catlin.cargo.ApplicationFacade;
	import com.catlin.cargo.bundles.RB_ui;
	import com.catlin.cargo.model.core.originatingoffice.OriginatingOfficeCode;
	import com.catlin.cargo.model.core.risk.Risk;
	import com.catlin.cargo.model.proxy.ReferenceDataProxy;
	import com.catlin.cargo.model.reference.financialregulation.FinancialControlRegulation;
	import com.catlin.cargo.validation.ValidationUtil;
	import com.catlin.cargo.view.BaseMediator;
	
	import flash.events.Event;
	
	import mx.binding.utils.BindingUtils;
	import mx.collections.ArrayCollection;
	import mx.events.CalendarLayoutChangeEvent;
	import mx.events.FlexEvent;
	import mx.formatters.DateFormatter;
	import mx.managers.PopUpManager;
	
	import org.puremvc.as3.interfaces.IMediator;
	import org.puremvc.as3.interfaces.INotification;

	public class CoverPeriodTitleWindowMediator extends BaseMediator implements IMediator
	{
		public static const NAME:String='CoverPeriodTitleWindowMediator';

		private var risk:Risk;
		private var _latestEndDate:Date;
		private var _consumerBusinessType:String=null;
		private var _showConsumerBusinessControl:Boolean=false;
		private var dateFormatter:DateFormatter=RB_ui.getDateFormatter();
		private var _newDate:Date=null;

		public function CoverPeriodTitleWindowMediator(viewComponent:CoverPeriodTitleWindow)
		{
			super(NAME, viewComponent);
		}

		public function initialise(risk:Risk):void
		{
			this.risk=risk;

			sendNotification(ApplicationFacade.DETERMINE_LATEST_END_DATE, risk.policyStartDateAsDate);

			coverPeriodTitleWindow.dtfinceptionDate.selectedDate=risk.policyStartDateAsDate
			coverPeriodTitleWindow.dtfinceptionDate.formatString=ApplicationFacade.getInstance().localeFormat.dateShort4Year2MonthDay; //"DD/MM/YYYY";
			BindingUtils.bindProperty(coverPeriodTitleWindow.dtfinceptionDate, "formatString", ApplicationFacade.getInstance(), ["localeFormat", "dateShort4Year2MonthDay"]);
			coverPeriodTitleWindow.dtfexpiryDate.selectedDate=risk.policyEndDateAsDate;
			coverPeriodTitleWindow.dtfexpiryDate.formatString=ApplicationFacade.getInstance().localeFormat.dateShort4Year2MonthDay; //"DD/MM/YYYY";
			BindingUtils.bindProperty(coverPeriodTitleWindow.dtfexpiryDate, "formatString", ApplicationFacade.getInstance(), ["localeFormat", "dateShort4Year2MonthDay"]);

			coverPeriodTitleWindow.btnUpdate.addEventListener(FlexEvent.BUTTON_DOWN, onUpdate);
			coverPeriodTitleWindow.btnCancel.addEventListener(FlexEvent.BUTTON_DOWN, onCancel);
			coverPeriodTitleWindow.dtfinceptionDate.addEventListener(CalendarLayoutChangeEvent.CHANGE, onPolicyStartDateChange);

			if (!ApplicationFacade.getInstance().userInfo.isUnderwriter)
			{
				coverPeriodTitleWindow.dtfinceptionDate.enabled=false;
				coverPeriodTitleWindow.dtfexpiryDate.selectableRange={rangeStart: risk.policyEndDateAsDate};
			}

			_showConsumerBusinessControl=risk.brokerOffice.originatingOfficeCode == OriginatingOfficeCode.UK && risk.consumerBusinessControl == null;
			if (_showConsumerBusinessControl == true)
			{
				_consumerBusinessType=null;
				coverPeriodTitleWindow.businesConsumerControlContainerText.text="The Insured’s status must be specified in accordance with the Financial Conduct Authority “Consumer Business Control” regulations.";
				coverPeriodTitleWindow.businesConsumerControl.addEventListener(Event.CHANGE, onBusinesConsumerControlChange);
				var referenceDataProxy:ReferenceDataProxy=facade.retrieveProxy(ReferenceDataProxy.NAME) as ReferenceDataProxy;
				referenceDataProxy.listConsumerBusinessControlRegulations(new Date());
				super.addClientSpecificRestrictedComponent(coverPeriodTitleWindow.businesConsumerControlContainer, OriginatingOfficeCode.UK, true, true, true);
				super.applyClientSpecificViewRestrictions();
			}
			else
			{
				_consumerBusinessType=risk.consumerBusinessControl.regulationSubType;
			}
		}

		private function get coverPeriodTitleWindow():CoverPeriodTitleWindow
		{
			return viewComponent as CoverPeriodTitleWindow;
		}

		override public function listNotificationInterests():Array
		{
			return [ApplicationFacade.LATEST_END_DATE_DETERMINED 
					,ReferenceDataProxy.FIND_ALL_CONSUMER_BUSINESS_CONTROL_REGULATIONS_COMPLETE
					];
		}

		override public function handleNotification(note:INotification):void
		{
			switch (note.getName())
			{
				case ApplicationFacade.LATEST_END_DATE_DETERMINED:
					this._latestEndDate=note.getBody() as Date;
					break;
				case ReferenceDataProxy.FIND_ALL_CONSUMER_BUSINESS_CONTROL_REGULATIONS_COMPLETE:
					this.coverPeriodTitleWindow.businesConsumerControl.dataProvider=note.getBody() as ArrayCollection;
					PopUpManager.centerPopUp(coverPeriodTitleWindow);
					break;
			}
		}

		protected function onUpdate(event:Event):void
		{
			if (validate())
			{
				sendNotification(ApplicationFacade.CREATE_COVER_PERIOD_MTA_QUOTE, {risk: risk, inceptionDate: coverPeriodTitleWindow.dtfinceptionDate.selectedDate, expiryDate: coverPeriodTitleWindow.dtfexpiryDate.selectedDate, consumerBusinessType: _consumerBusinessType});
				ApplicationFacade.closePopUpWindow(coverPeriodTitleWindow, NAME);
			}
		}

		private function validate():Boolean
		{
			if (_showConsumerBusinessControl == true && (_consumerBusinessType == null || _consumerBusinessType == ""))
			{
				ValidationUtil.markFieldError(coverPeriodTitleWindow.businesConsumerControl, "Required field!!");
				return false;
			}

			if (ValidationUtil.valueRequired(coverPeriodTitleWindow.dtfinceptionDate, rm.getString(RB_ui.RB_NAME, RB_ui.COVER_PERIOD_VIEW_VALIDATOR_REQUIRED_INCEPTION_DATE)) | ValidationUtil.valueRequired(coverPeriodTitleWindow.dtfexpiryDate, rm.getString(RB_ui.RB_NAME, RB_ui.COVER_PERIOD_VIEW_VALIDATOR_REQUIRED_EXPIRY_DATE)))
			{
				return false;
			}
			var inceptionDate:Date=coverPeriodTitleWindow.dtfinceptionDate.selectedDate;
			var expiryDate:Date=coverPeriodTitleWindow.dtfexpiryDate.selectedDate;

			if (inceptionDate == null || expiryDate == null)
			{
				if (inceptionDate == null)
				{
					ValidationUtil.markFieldError(coverPeriodTitleWindow.dtfinceptionDate, rm.getString(RB_ui.RB_NAME, RB_ui.COVER_PERIOD_VIEW_VALIDATOR_ERROR_INCEPTION_DATE_UNDEFINED));
				}
				if (expiryDate == null)
				{
					ValidationUtil.markFieldError(coverPeriodTitleWindow.dtfexpiryDate, rm.getString(RB_ui.RB_NAME, RB_ui.COVER_PERIOD_VIEW_VALIDATOR_ERROR_EXPIRY_DATE_UNDEFINED));
				}
				return false;
			}

			if (!ApplicationFacade.getInstance().userInfo.isUnderwriter && risk.policyEndDateAsDate.time > expiryDate.time)
			{
				ValidationUtil.markFieldError(coverPeriodTitleWindow.dtfexpiryDate, rm.getString(RB_ui.RB_NAME, RB_ui.COVER_PERIOD_VIEW_VALIDATOR_ERROR_INCEPTION_DATE_INVALID));
				return false;
			}

			if (inceptionDate.time > expiryDate.time)
			{
				ValidationUtil.markFieldError(coverPeriodTitleWindow.dtfinceptionDate, rm.getString(RB_ui.RB_NAME, RB_ui.COVER_PERIOD_VIEW_VALIDATOR_ERROR_EXPIRY_DATE_INVALID));
				return false;
			}
			if ((_latestEndDate != null) && (expiryDate.time > _latestEndDate.time))
			{
				ValidationUtil.markFieldError(coverPeriodTitleWindow.dtfexpiryDate, rm.getString(RB_ui.RB_NAME, RB_ui.COVER_PERIOD_VIEW_VALIDATOR_ERROR_EXPIRY_DATE_INVALID2, [dateFormatter.format(_latestEndDate)]));
				return false;
			}

			return true;
		}

		protected function onCancel(event:Event):void
		{
			ApplicationFacade.closePopUpWindow(coverPeriodTitleWindow, NAME);
		}

		private function onPolicyStartDateChange(event:CalendarLayoutChangeEvent):void
		{
			_newDate=event.newDate;
			if (_newDate != null)
			{
				sendNotification(ApplicationFacade.DETERMINE_LATEST_END_DATE, _newDate);
			}
		}

		private function onBusinesConsumerControlChange(e:Event):void
		{
			this._consumerBusinessType=(coverPeriodTitleWindow.businesConsumerControl.selectedValue as FinancialControlRegulation).regulationSubType;
		}

	}
}
