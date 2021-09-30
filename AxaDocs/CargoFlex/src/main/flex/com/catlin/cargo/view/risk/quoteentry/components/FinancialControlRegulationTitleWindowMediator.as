package com.catlin.cargo.view.risk.quoteentry.components
{
	import com.catlin.cargo.ApplicationFacade;
	import com.catlin.cargo.bundles.RB_ui;
	import com.catlin.cargo.model.core.risk.Risk;
	import com.catlin.cargo.model.proxy.ReferenceDataProxy;
	import com.catlin.cargo.model.reference.financialregulation.FinancialControlRegulation;
	import com.catlin.cargo.validation.ValidationUtil;
	import com.catlin.cargo.view.BaseMediator;
	
	import flash.events.Event;
	
	import mx.collections.ArrayCollection;
	import mx.events.FlexEvent;
	import mx.managers.PopUpManager;
	
	import org.puremvc.as3.interfaces.IMediator;
	import org.puremvc.as3.interfaces.INotification;

	public class FinancialControlRegulationTitleWindowMediator extends BaseMediator implements IMediator
	{

		public static const NAME:String='FinancialControlRegulationTitleWindowMediator';

		private var _currentQuote:Risk;
		
		[Bindable]
		private var _title:String;
		
		[Bindable]
		private var _message:String;
		
		public function FinancialControlRegulationTitleWindowMediator(viewComponent:FinancialControlRegulationTitleWindow)
		{
			super(NAME, viewComponent);
			
			financialControlRegulationTitleWindow.initialize();
			
			financialControlRegulationTitleWindow.okButton.label = rm.getString(RB_ui.RB_NAME, RB_ui.OK);
			financialControlRegulationTitleWindow.okButton.addEventListener(FlexEvent.BUTTON_DOWN, onOk);
			
			financialControlRegulationTitleWindow.cancelButton.label = rm.getString(RB_ui.RB_NAME, RB_ui.CANCEL);
			financialControlRegulationTitleWindow.cancelButton.addEventListener(FlexEvent.BUTTON_DOWN, onCancel);
			
			var referenceDataProxy:ReferenceDataProxy=facade.retrieveProxy(ReferenceDataProxy.NAME) as ReferenceDataProxy;
			referenceDataProxy.listConsumerBusinessControlRegulations(new Date());

		}

		[Bindable]
		public function get currentQuote():Risk
		{
			return _currentQuote;
		}

		public function set currentQuote(quote:Risk):void
		{
			_currentQuote=quote;
		}

		private function get financialControlRegulationTitleWindow():FinancialControlRegulationTitleWindow
		{
			return viewComponent as FinancialControlRegulationTitleWindow;
		}

		private function onOk(event:Event):void
		{
			if (validate())
			{
				var fcr:FinancialControlRegulation=financialControlRegulationTitleWindow.businesConsumerControl.selectedValue;
				currentQuote.consumerBusinessControl=fcr;
				sendNotification(ApplicationFacade.UPDATE_FINANCIAL_CONTROL_REGULATION, currentQuote);
				this.closePopUp();
			}
		}
		
		private function closePopUp():void {
			ApplicationFacade.closePopUpWindow(financialControlRegulationTitleWindow, NAME);
		}

		private function onCancel(event:Event):void
		{
			this.closePopUp(); 
		}

		private function validate():Boolean
		{
			var ret:Boolean=true;
			var currentValue:Object=financialControlRegulationTitleWindow.businesConsumerControl.selectedValue;

			if (currentValue == null)
			{
				ValidationUtil.markFieldError(financialControlRegulationTitleWindow.businesConsumerControl.container, "Please select any of the following options.");
				ret=false;
			}
			return ret;
		}

		// TODO NONCORE-41
		override public function listNotificationInterests():Array {
			return [ReferenceDataProxy.FIND_ALL_CONSUMER_BUSINESS_CONTROL_REGULATIONS_COMPLETE
				//,ApplicationFacade.VALIDATE_RISK_DOCUMENT_VERSIONS_COMPLETE
				//,ApplicationFacade.CREATE_BASIC_DOCUMENTS_COMPLETE
				];
		}

		// TODO NONCORE-41
		override public function handleNotification(note:INotification):void {
			switch (note.getName()) {
				case ReferenceDataProxy.FIND_ALL_CONSUMER_BUSINESS_CONTROL_REGULATIONS_COMPLETE:
					this.financialControlRegulationTitleWindow.businesConsumerControl.dataProvider=note.getBody() as ArrayCollection;
					PopUpManager.centerPopUp(financialControlRegulationTitleWindow);
					break;
				//case ApplicationFacade.VALIDATE_RISK_DOCUMENT_VERSIONS_COMPLETE:
				//	Alert.show("VALIDATE_RISK_DOCUMENT_VERSIONS_COMPLETE");
				//	break;
				//case ApplicationFacade.CREATE_BASIC_DOCUMENTS_COMPLETE:
				//	sendNotification(ApplicationFacade.VALIDATE_RISK_DOCUMENT_VERSIONS, {risk : _currentQuote, documents: note.getBody() as Object})
				//	break;				
			}
		}
		
		private function onBusinesConsumerControlChange(e:Event):void
		{
			var _consumerBusinessType:String =(financialControlRegulationTitleWindow.businesConsumerControl.selectedValue as FinancialControlRegulation).regulationSubType;
		}
		
		
		public function set title(value:String):void {
			financialControlRegulationTitleWindow.title = value;	
		}
		
		public function set message(value:String):void {
			financialControlRegulationTitleWindow.message = value;	
		}		
	}
}
