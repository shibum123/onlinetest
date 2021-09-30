package com.catlin.cargo.view.risk.quoteentry {
	import com.catlin.cargo.ApplicationFacade;
	import com.catlin.cargo.CargoDateUtil;
	import com.catlin.cargo.bundles.RB_ui;
	import com.catlin.cargo.controller.UpdateLimitsAndDeductiablesCommand;
	import com.catlin.cargo.model.BasicDocumentCriteriaBuilder;
	import com.catlin.cargo.model.core.covertype.CoverTypeCode;
	import com.catlin.cargo.model.core.covertype.CoverTypeLocation;
	import com.catlin.cargo.model.core.insured.Insured;
	import com.catlin.cargo.model.core.originatingoffice.OriginatingOfficeCode;
	import com.catlin.cargo.model.core.party.Party;
	import com.catlin.cargo.model.core.risk.Risk;
	import com.catlin.cargo.model.core.risk.Sendings;
	import com.catlin.cargo.model.core.risk.TriaInsuranceStatus;
	import com.catlin.cargo.model.core.subjectmatter.SubjectMatter;
	import com.catlin.cargo.model.proxy.ExchangeRateProxy;
	import com.catlin.cargo.model.proxy.ReferenceDataProxy;
	import com.catlin.cargo.model.proxy.SubjectMatterProxy;
	import com.catlin.cargo.model.reference.country.Province;
	import com.catlin.cargo.model.reference.deductible.Deductible;
	import com.catlin.cargo.model.reference.financialregulation.FinancialControlRegulation;
	import com.catlin.cargo.model.security.UserInfo;
	import com.catlin.cargo.model.util.PersistentDateFormat;
	import com.catlin.cargo.validation.ValidationUtil;
	import com.catlin.cargo.view.BaseMediator;
	import com.catlin.cargo.view.address.AddressValidationImpl;
	import com.catlin.cargo.view.address.InsuredWindow;
	import com.catlin.cargo.view.address.InsuredWindowAmendProvinceMediator;
	import com.catlin.cargo.view.risk.mta.MTAOverridePremiumWindow;
	import com.catlin.cargo.view.risk.mta.MTAOverridePremiumWindowMediator;
	import com.catlin.cargo.view.risk.quoteentry.components.FinancialControlRegulationTitleWindow;
	import com.catlin.cargo.view.risk.quoteentry.components.FinancialControlRegulationTitleWindowMediator;
	import com.catlin.cargo.view.risk.quoteentry.components.TriaInsuranceTitleWindow;
	import com.catlin.cargo.view.risk.quoteentry.components.TriaInsuranceTitleWindowMediator;
	import com.catlin.cargo.view.risk.quoteentry.pages.BasisOfValuationMediator;
	import com.catlin.cargo.view.risk.quoteentry.pages.Cover;
	import com.catlin.cargo.view.risk.quoteentry.pages.CoverMediator;
	import com.catlin.cargo.view.risk.quoteentry.pages.LimitsMediator;
	import com.catlin.cargo.view.risk.quoteentry.pages.additionalcover.AdditionalCoverMediator;
	import com.catlin.cargo.view.risk.quoteentry.pages.personal.PersonalMediator;
	import com.catlin.ui.flex.validator.PageValidator;
	import com.catlin.ui.flex.widgets.currency.CurrencyInput;

	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import mx.collections.ArrayCollection;
	import mx.controls.Alert;
	import mx.controls.ComboBox;
	import mx.events.CalendarLayoutChangeEvent;
	import mx.events.CloseEvent;
	import mx.events.ListEvent;
	import mx.formatters.DateFormatter;
	
	import org.puremvc.as3.interfaces.IMediator;
	import org.puremvc.as3.interfaces.INotification;
	
	public class QuoteFormMediator extends BaseMediator implements IMediator {
		
		private static const dummy:CoverTypeLocation=null; // Force swf inclusion as not directly referenced 
		
		public static const NAME:String='QuoteFormMediator';
		
		public static const EVT_CREATE_BASIC_DOCUMENTATION:String='EVT_CREATE_BASIC_DOCUMENTATION';		

		private static const FALSE:uint=0;
		private static const TRUE:uint=1;
		
		public var validation:ValidationImpl=new ValidationImpl();
		private var fieldValidator:PageValidator=new PageValidator();
		private var adjustmentAmounts:Array=[0, -50, -40, -30, -25, -20, -15, -10, -5, 5, 10, 15, 20, 25, 30, 40, 50, "Other"];
		private var _exchangeRate:Object;
		private var nearestValueCalculator:NearestValueCalculator=new NearestValueCalculator();
		private var deductiblesMap:Object;
		private var _earliestEndorsementDate:Date;
		private var _latestEndDate:Date;
		private var userInfo:UserInfo;
		private var consumerBusinessControlRegulations:ArrayCollection;
		
		public function QuoteFormMediator(viewComponent:Object) {
			super(NAME, viewComponent);
			
			userInfo=ApplicationFacade.getInstance().userInfo;
			
			quoteForm.addEventListener(QuoteForm.BACK, onBack);
			quoteForm.addEventListener(QuoteForm.NEXT, onNext);
			quoteForm.addEventListener(QuoteForm.QUOTE, onQuote);
			
			quoteForm.cover.subjectMatter.addEventListener(ListEvent.CHANGE, onSubjectMatterChange);
			quoteForm.personal.cboCurrency.addEventListener(ListEvent.CHANGE, onSubjectMatterChange);
			quoteForm.cover.policyStartDate.addEventListener(CalendarLayoutChangeEvent.CHANGE, onPolicyStartDateChange);
			if (!userInfo.isUnderwriter) {
				adjustmentAmounts.pop();
			}
			quoteForm.getQuote.cboPremiumAdjustment.dataProvider=adjustmentAmounts;
			quoteForm.getQuote.cboPremiumAdjustment.addEventListener(ListEvent.CHANGE, onPremiumAdjustmentChange);
			quoteForm.getQuote.overrideAdditionalPremiumButton.addEventListener(MouseEvent.CLICK, onClickOverrideAdditionalPremiumButton);
			
			fieldValidator.multiPageValidator.rules=validation.create();
			
			quoteForm.userInfo=userInfo;
		}
		
		override public function onRegister():void {
			facade.registerMediator(new AdditionalCoverMediator(quoteForm.additionalCover));
			facade.registerMediator(new PersonalMediator(quoteForm.personal));
			facade.registerMediator(new LimitsMediator(quoteForm.limits));
			facade.registerMediator(new BasisOfValuationMediator(quoteForm.basis));
			facade.registerMediator(new CoverMediator(quoteForm.cover));
		}
		
		public function get currentQuote():Risk {
			return quoteForm.quote;
		}
		
		public function setQuote(quote:Risk):void {
			if (quote.editable && quote.policyStartDate != null) {
				sendNotification(ApplicationFacade.DETERMINE_LATEST_END_DATE, new PersistentDateFormat().parse(quote.policyStartDate));
			}

			fieldValidator.reset();
			
			quoteForm.history.overridenHistoryLock=false;
			quoteForm.sendings.overridenSendingLock=false;
			quoteForm.userInfo=ApplicationFacade.getInstance().userInfo;
			quoteForm.quote=quote;
			validation.quote=quote;
			validation.originatingOfficeCode=ApplicationFacade.getInstance().sessionOriginatingOfficeCode;
			var additionalCoverMediator:AdditionalCoverMediator=facade.retrieveMediator(AdditionalCoverMediator.NAME) as AdditionalCoverMediator;
			additionalCoverMediator.currentQuote=quote;
			var personalMediator:PersonalMediator=facade.retrieveMediator(PersonalMediator.NAME) as PersonalMediator;
			personalMediator.currentQuote=quote;
			var limitsMediator:LimitsMediator=facade.retrieveMediator(LimitsMediator.NAME) as LimitsMediator;
			limitsMediator.currentQuote=quote;
			var basisOfValuationMediator:BasisOfValuationMediator=facade.retrieveMediator(BasisOfValuationMediator.NAME) as BasisOfValuationMediator;
			basisOfValuationMediator.currentQuote=quote;
			basisOfValuationMediator.overridenDeductiblesLock=false;
			basisOfValuationMediator.userInfo=userInfo;

			quoteForm.getQuote.cboPremiumAdjustment.text="";
			
			if (quote.adjustmentPercent != 0) {
				quoteForm.getQuote.cboPremiumAdjustment.text=quote.adjustmentPercent.toString();
			}
			
			if (quote.isMidTermAdjustment()) {
				quoteForm.getQuote.chargeableAdditionalPremium.data=quote.mtaRate.premium.toString();
			}
			
			if (quote.previousRisk != null) {
				quoteForm.getQuote.cboPreviousPremiumAdjustment.data=quote.previousRisk.premiumOverridden ? "Other" : quote.previousRisk.adjustmentPercent;
			} else {
				quoteForm.getQuote.cboPreviousPremiumAdjustment.data=null;
			}
			quoteForm.cover.dateInit();
			sendNotification(ApplicationFacade.REFRESH_COVER_DEDUCTIBLE);
			onPremiumAdjustmentChange(null);
			(facade.retrieveProxy(ReferenceDataProxy.NAME) as ReferenceDataProxy).listConsumerBusinessControlRegulations(quote.quoteDate != null ? quote.quoteDate : new Date());
		}
		
		public function enableFields(quote:Risk):void {
			quoteForm.getQuote.overrideAdditionalPremiumButton.enabled=true;
		}
		
		public function get quoteForm():QuoteForm {
			return viewComponent as QuoteForm;
		}
		
		public function set earliestEndorsementDate(date:Date):void {
			this._earliestEndorsementDate=date;
			quoteForm.cover.endorsementStartDate.selectableRange={rangeStart: date};
		}
		
		public function get earliestEndorsementDate():Date {
			return this._earliestEndorsementDate;
		}
		
		private function onBack(event:Event):void {
			quoteForm.multistepNavigator.selectedIndex--;
		}
		
		private function onNext(event:Event):void {
			if (!currentQuote.editable || allFieldsValid()) {
				quoteForm.multistepNavigator.selectedIndex++;
			}
		}

		public function canBindCoverProceed():Boolean {
		
			if (currentQuote.insured != null && 
					currentQuote.insured.address != null &&
					currentQuote.insured.address.country != null &&
					AddressValidationImpl.provinceRequired(currentQuote.insured.address.country.isoCode) && 
					currentQuote.insured.address.province == null) {

				var form:InsuredWindow=new InsuredWindow();
				var mediator:InsuredWindowAmendProvinceMediator=ApplicationFacade.addPopUpWindow(form, InsuredWindowAmendProvinceMediator) as InsuredWindowAmendProvinceMediator;
				mediator.insured=currentQuote.insured;
				return false;
			}

			if (quoteForm.personal.consumerBusinessControlRegulations != null && 
					quoteForm.personal.consumerBusinessControlRegulations.length > 0 && 
					quoteForm.quote.consumerBusinessControl == null && 
					!quoteForm.quote.isMidTermAdjustment()) {
				
				var financialControlRegulationTitleWindow:FinancialControlRegulationTitleWindowMediator=ApplicationFacade.openPopUpWindow(FinancialControlRegulationTitleWindow, FinancialControlRegulationTitleWindowMediator) as FinancialControlRegulationTitleWindowMediator;
				financialControlRegulationTitleWindow.currentQuote=currentQuote;
				financialControlRegulationTitleWindow.title = rm.getString(RB_ui.RB_NAME, RB_ui.QUOTE_FORM_MEDIATOR_VALIDATION_REQUIRED_CBC_OPTION_TITLE);
				financialControlRegulationTitleWindow.message = rm.getString(RB_ui.RB_NAME, RB_ui.QUOTE_FORM_MEDIATOR_VALIDATION_REQUIRED_CBC_OPTION_MESSAGE);

				return false;
			}

			if (ApplicationFacade.getInstance().userInfo.originatingOffice.triaPremiumEnabled == true && 
					!currentQuote.hasAnsweredTriaInsurance && 
					currentQuote.triaInsuranceDetails.triaInsuranceStatus != TriaInsuranceStatus.ACCEPTED && 
					currentQuote.triaInsuranceDetails.triaInsuranceStatus != TriaInsuranceStatus.NOT_REQUIRED) {

				var triaTitleWindowMediator:TriaInsuranceTitleWindowMediator=ApplicationFacade.openPopUpWindow(TriaInsuranceTitleWindow, TriaInsuranceTitleWindowMediator) as TriaInsuranceTitleWindowMediator;
				triaTitleWindowMediator.currentQuote=currentQuote;
				return false;
			}
			
			return true;
		}

		private function onAmendInsuredProvinceComplete(party:Party):void {
			var insured:Insured=currentQuote.insured;
			insured.address.county=party.address.county;
			insured.address.province=party.address.province;

			sendNotification(ApplicationFacade.UPDATE_INSURED, insured);
		}

		private function allFieldsValid():Boolean {
			validation.adjustedPremium=Number(quoteForm.getQuote.curAdjustedPremium.data);
			var pageName:String=quoteForm.multistepNavigator.childDescriptors[quoteForm.multistepNavigator.selectedIndex].id;
			
			var isCoverValid:Boolean=true;
			ValidationUtil.clearErrors(quoteForm.cover.endorsementStartDate);
			ValidationUtil.clearErrors(quoteForm.cover.policyStartDate);
			ValidationUtil.clearErrors(quoteForm.cover.policyEndDate);
			if (quoteForm[pageName] is Cover) {
				isCoverValid=validateCover(quoteForm.cover);
			}
			
			var isValidatorValid:Boolean=fieldValidator.validate(pageName, quoteForm[pageName]);
			
			var isValid:Boolean=isCoverValid && isValidatorValid;
			
			if (isValid && quoteForm[pageName] is Cover && !(currentQuote.exclusionsAccepted)) {
				showExclusionRestrictionsText();
				isValid=false;
			}
			return isValid;
		}
		
		private function validateCover(cover:Cover):Boolean {
			var df:DateFormatter=new DateFormatter();
			df.formatString=ApplicationFacade.getInstance().localeFormat.dateShort4Year2MonthDay;
			
			ValidationUtil.clearErrors(cover.policyStartDate);
			ValidationUtil.clearErrors(cover.policyEndDate);
			
			if (ValidationUtil.valueRequired(cover.policyStartDate, rm.getString(RB_ui.RB_NAME, RB_ui.QUOTE_FORM_MEDIATOR_VALIDATION_REQUIRED_INCEPTION_DATE)) 
				|| ValidationUtil.valueRequired(cover.policyEndDate, rm.getString(RB_ui.RB_NAME, RB_ui.QUOTE_FORM_MEDIATOR_VALIDATION_REQUIRED_EXPIRY_DATE))) {
				return false;
			}
			
			var inceptionDate:Date=cover.policyStartDate.selectedDate;
			var expiryDate:Date=cover.policyEndDate.selectedDate;
			if (inceptionDate == null || expiryDate == null) {
				if (inceptionDate == null) {
					ValidationUtil.markFieldError(cover.policyStartDate, rm.getString(RB_ui.RB_NAME, RB_ui.QUOTE_FORM_MEDIATOR_VALIDATION_INVALID_INCEPTION_DATE));
				}
				if (expiryDate == null) {
					ValidationUtil.markFieldError(cover.policyEndDate, rm.getString(RB_ui.RB_NAME, RB_ui.QUOTE_FORM_MEDIATOR_VALIDATION_INVALID_EXPIRY_DATE));
				}
				return false;
			}
			
			if (!currentQuote.isMidTermAdjustment() && CargoDateUtil.isDateInThePast(inceptionDate) && !userInfo.isUnderwriter) {
				ValidationUtil.markFieldError(cover.policyStartDate, rm.getString(RB_ui.RB_NAME, RB_ui.QUOTE_FORM_MEDIATOR_VALIDATION_INVALID_INCEPTION_DATE_IN_PAST));
				return false;
			}
			if (inceptionDate.time > expiryDate.time) {
				ValidationUtil.markFieldError(cover.policyStartDate, rm.getString(RB_ui.RB_NAME, RB_ui.QUOTE_FORM_MEDIATOR_VALIDATION_INVALID_INCEPTION_DATE_LATER_EXPIRY_DATE));
				return false;
			}
			if ((_latestEndDate != null) && (expiryDate.time > _latestEndDate.time)) {
				ValidationUtil.markFieldError(cover.policyEndDate, rm.getString(RB_ui.RB_NAME, RB_ui.QUOTE_FORM_MEDIATOR_VALIDATION_INVALID_POLICY_END_DATE_GT_15M));
				return false;
			}
			
			if (currentQuote.isMidTermAdjustment()) {
				if (ValidationUtil.valueRequired(cover.endorsementStartDate, rm.getString(RB_ui.RB_NAME, RB_ui.QUOTE_FORM_MEDIATOR_VALIDATION_REQUIRED_ENDORSEMENT_DATE))) {
					return false;
				} else {
					var endorsementDate:Date=cover.endorsementStartDate.selectedDate;
					if (endorsementDate == null) {
						ValidationUtil.markFieldError(cover.endorsementStartDate, rm.getString(RB_ui.RB_NAME, RB_ui.QUOTE_FORM_MEDIATOR_VALIDATION_INVALID_ENDORSEMENT));
						return false;
					}
					if (endorsementDate.time < earliestEndorsementDate.time) {
						ValidationUtil.markFieldError(cover.endorsementStartDate, rm.getString(RB_ui.RB_NAME, RB_ui.QUOTE_FORM_MEDIATOR_VALIDATION_INVALID_ENDORSEMENT_DATE_TOO_EARLY, [df.format(earliestEndorsementDate)]));
						return false;
						;
					}
					if (CargoDateUtil.isDateInThePast(endorsementDate) && !userInfo.isUnderwriter) {
						ValidationUtil.markFieldError(cover.endorsementStartDate, rm.getString(RB_ui.RB_NAME, RB_ui.QUOTE_FORM_MEDIATOR_VALIDATION_INVALID_ENDORSEMENT_DATE_IN_PAST));
						return false;
						;
					}
					if (endorsementDate.time > expiryDate.time) {
						ValidationUtil.markFieldError(cover.endorsementStartDate, rm.getString(RB_ui.RB_NAME, RB_ui.QUOTE_FORM_MEDIATOR_VALIDATION_INVALID_ENDORSEMENT_DATE_LATER_POLICY_DATE));
						return false;
					}
				}
			}
			
			return true;
		}
		
		private function onSubjectMatterChange(event:ListEvent):void {
			updateSendings();
		}
		
		private function onPolicyStartDateChange(event:CalendarLayoutChangeEvent):void {
			var newDate:Date=event.newDate;
			if (newDate != null) {
				sendNotification(ApplicationFacade.DETERMINE_LATEST_END_DATE, newDate);
				createBasicDocumentation();
			}
		}
		
		private function updateSendings():void {
			currentQuote.exclusionsAccepted=false;

			if (currentQuote.subjectMatter != null && currentQuote.currency != null && currentQuote.editable && deductiblesMap != null) {
				var subjectMatter:SubjectMatter=currentQuote.subjectMatter;
				var deductibles:ArrayCollection = null;
				for each (var sending:Sendings in currentQuote.sendings) {
					deductibles = Deductible.getDeductiblesForCoverTypeGroup(deductiblesMap, CoverTypeCode.valueOf(sending.type.code));
					sending.deductibles=nearestValueCalculator.deriveDefault(subjectMatter.getDeductibleDefaultValueFor(sending.type), currentQuote.currency, deductibles);
					setDefaultValues(sending);
				}
				if (currentQuote.stockCover != null) {
					deductibles = Deductible.getDeductiblesForCoverTypeGroup(deductiblesMap, CoverTypeCode.STOCK);
					currentQuote.stockCover.deductibles=nearestValueCalculator.deriveDefault(subjectMatter.stockCoverDeductiblesDefault, currentQuote.currency, deductibles);

					if (currentQuote.stockCover.catastropheCover != null) {
						deductibles = Deductible.getDeductiblesForCoverTypeGroup(deductiblesMap, CoverTypeCode.STOCK_CATASTROPHE);
						currentQuote.stockCover.catastropheCover.deductibles=nearestValueCalculator.deriveDefault(subjectMatter.getDeductibleDefaultValueByCoverTypeCodeFor(CoverTypeCode.STOCK_CATASTROPHE), currentQuote.currency, deductibles);
					}
				}
				if (currentQuote.exhibitionCover != null) {
					deductibles = Deductible.getDeductiblesForCoverTypeGroup(deductiblesMap, CoverTypeCode.EXHIBITION);
					currentQuote.exhibitionCover.deductibles=nearestValueCalculator.deriveDefault(subjectMatter.exhibitionCoverDeductiblesDefault, currentQuote.currency, deductibles);
				}
				if (currentQuote.toolsAndSamplesCover != null) {
					deductibles = Deductible.getDeductiblesForCoverTypeGroup(deductiblesMap, CoverTypeCode.TOOLS_AND_SAMPLES);
					currentQuote.toolsAndSamplesCover.deductibles=nearestValueCalculator.deriveDefault(subjectMatter.toolsAndSamplesCoverDeductiblesDefault, currentQuote.currency, deductibles);
				}
			}
			sendNotification(ApplicationFacade.REFRESH_COVER_DEDUCTIBLE);
		}
		
		private function setDefaultValues(sending:Sendings):void {
			if (sending.type.code == "DOMESTIC_TRANSITS") {
				if (sending.basisOfValuation == "") {
					sending.basisOfValuation=currentQuote.brokerOffice.defaultBoVDomesticTransit;
				}
			}
			
		}
		
		private function showExclusionRestrictionsText():void {
			Alert.okLabel=rm.getString(RB_ui.RB_NAME, RB_ui.ACCEPT);
			Alert.cancelLabel=rm.getString(RB_ui.RB_NAME, RB_ui.DECLINE);
			Alert.buttonWidth=75;
			Alert.show(quoteForm.userInfo.originatingOffice.excludedGoods + rm.getString(RB_ui.RB_NAME, RB_ui.QUOTE_FORM_MEDIATOR_EXCLUSIONS_CONFIRMATION_QUESTION), rm.getString(RB_ui.RB_NAME, RB_ui.QUOTE_FORM_MEDIATOR_EXCLUSIONS_TITLE), Alert.OK | Alert.CANCEL, null, exclusionsCloseHandler);
		}
		
		private function exclusionsCloseHandler(event:CloseEvent):void {
			if (event.detail == Alert.OK) {
				currentQuote.exclusionsAccepted=true;
				onNext(event);
			}
			Alert.okLabel=null;
			Alert.cancelLabel=null;
			Alert.buttonWidth=65;
		}

		private function onQuote(event:Event):void {
			if (allFieldsValid()) {
				if (currentQuote.brokerQuoteCount == 4) {
					// Four attempts already, this is the fifth
					Alert.show(rm.getString(RB_ui.RB_NAME, RB_ui.QUOTE_FORM_MEDIATOR_ON_QUOTE_MAX_EDIT_ON_QUOTE));
				}
				var quote:Risk=quoteForm.quote;

				quote.rate.premium=Number(quoteForm.getQuote.curAdjustedPremium.data);
				sendNotification(ApplicationFacade.QUOTE_RISK, quote);
			}
		}

		override public function listNotificationInterests():Array {
			return [SubjectMatterProxy.FIND_ALL_SUBJECT_MATTERS_COMPLETE, 
					ExchangeRateProxy.LIST_EXCHANGE_RATES_COMPLETE, 
					UpdateLimitsAndDeductiablesCommand.FIND_DEDUCTABLES_COMPLETE, 
					UpdateLimitsAndDeductiablesCommand.UPDATE_SENDINGS, 
					ApplicationFacade.LATEST_END_DATE_DETERMINED, 
					ReferenceDataProxy.FIND_ALL_CONSUMER_BUSINESS_CONTROL_REGULATIONS_COMPLETE,
					QuoteFormMediator.EVT_CREATE_BASIC_DOCUMENTATION,
					InsuredWindowAmendProvinceMediator.INSURED_WINDOW_AMEND_PROVINCE_COMPLETED,
					ApplicationFacade.UPDATE_INSURED_COMPLETE];
		}

		override public function handleNotification(note:INotification):void {
			switch (note.getName()) {
				case SubjectMatterProxy.FIND_ALL_SUBJECT_MATTERS_COMPLETE:
					var subjectMatters:ArrayCollection=(note.getBody() as ArrayCollection);
					quoteForm.cover.subjectMatters=subjectMatters;
					break;
				case ExchangeRateProxy.LIST_EXCHANGE_RATES_COMPLETE:
					nearestValueCalculator.exchangeRates=note.getBody();
					break;
				case UpdateLimitsAndDeductiablesCommand.FIND_DEDUCTABLES_COMPLETE:
					deductiblesMap=note.getBody();
					break;
				case UpdateLimitsAndDeductiablesCommand.UPDATE_SENDINGS:
					updateSendings();
					break;
				case ApplicationFacade.LATEST_END_DATE_DETERMINED:
					this._latestEndDate=note.getBody() as Date;
					break;
				case ReferenceDataProxy.FIND_ALL_CONSUMER_BUSINESS_CONTROL_REGULATIONS_COMPLETE:
					quoteForm.personal.consumerBusinessControlRegulations=(note.getBody() as ArrayCollection);
					quoteForm.personal.businesConsumerControl.selectedValue=quoteForm.quote.consumerBusinessControl as FinancialControlRegulation;
					break;
				case QuoteFormMediator.EVT_CREATE_BASIC_DOCUMENTATION:
					createBasicDocumentation();
					break;
				case InsuredWindowAmendProvinceMediator.INSURED_WINDOW_AMEND_PROVINCE_COMPLETED:
					var ins:Insured=note.getBody() as Insured;
					onAmendInsuredProvinceComplete(ins);
					break;
				case ApplicationFacade.UPDATE_INSURED_COMPLETE:
					sendNotification(ApplicationFacade.ACCEPT_QUOTE_AFTER_UPDATE);
					break;					
			}
		}

		private function onClickOverrideAdditionalPremiumButton(event:Event):void {
			var mediator:MTAOverridePremiumWindowMediator=ApplicationFacade.openPopUpWindow(MTAOverridePremiumWindow, MTAOverridePremiumWindowMediator) as MTAOverridePremiumWindowMediator;
			mediator.quote=currentQuote;
			mediator.confirmFunction=confirmOverrideAdditionalPremium;
			mediator.removeFunction=removeAdditionalPremiumOverride;
		}

		private function removeAdditionalPremiumOverride():void {
			currentQuote.midTermAdjustmentDetails.additionalPremiumOverridden=false;
			currentQuote.mtaRate.premium=currentQuote.mtaCalculatedRate.premium;
			
			if (ApplicationFacade.getInstance().userInfo.originatingOffice.triaPremiumEnabled == true) {
				currentQuote.triaInsuranceDetails.triaPremiumOverridden = false;
				currentQuote.triaInsuranceDetails.triaPremium=0;
			}
			
			onQuote(null);
		}

		private function confirmOverrideAdditionalPremium(requiredAdditionalPremium:Number, requiredAdditionalTriaPremium:Number):void {
			currentQuote.midTermAdjustmentDetails.additionalPremiumOverridden=true;
			quoteForm.getQuote.chargeableAdditionalPremium.data=requiredAdditionalPremium;
			currentQuote.mtaRate.premium=requiredAdditionalPremium;
			
			if (ApplicationFacade.getInstance().userInfo.originatingOffice.triaPremiumEnabled == true) {			
				currentQuote.triaInsuranceDetails.triaPremiumOverridden = true;
				currentQuote.triaInsuranceDetails.triaPremium=requiredAdditionalTriaPremium;				
			}
			
			onQuote(null);
		}
		
		private function onPremiumAdjustmentChange(event:Event):void {
			var adjustByField:ComboBox=quoteForm.getQuote.cboPremiumAdjustment;
			var chargeablePremiumField:CurrencyInput=quoteForm.getQuote.curAdjustedPremium;
			currentQuote.adjustmentPercent=isNaN(parseFloat(adjustByField.text)) ? 0 : parseFloat(adjustByField.text)
			if (adjustByField.text == 'Other') {
				quoteForm.quote.premiumOverridden=true;
				chargeablePremiumField.enabled=true;
			} else {
				quoteForm.quote.premiumOverridden=false;
				chargeablePremiumField.enabled=false;
			}
		}
		
		private function createBasicDocumentation():Boolean {
			
			if (canCreateBasicDocumentation()) {
				sendNotification(ApplicationFacade.CREATE_BASIC_DOCUMENTS, 
					new BasicDocumentCriteriaBuilder()
					.withBrokerOffice(currentQuote.brokerOffice)
					.withCurrency(currentQuote.currency)
					.withUsageDate(currentQuote.policyStartDate)
					.withConsumerType(getConsumerType())
					.withProvince(getInsuredProvince() != null ? getInsuredProvince().isoCode : null)
					.build());

				return true;
			}
			return false;
		}

		/**
		 * For UK, the documentation is driven by the FCA so Basic doc can only be
		 * created after the user selects the required FCA.
		 */
		protected function canCreateBasicDocumentation():Boolean {
			
			if (currentQuote && currentQuote.brokerOffice != null && currentQuote.currency != null) {	
				switch (ApplicationFacade.getInstance().sessionOriginatingOfficeCode) {
					case OriginatingOfficeCode.UK:
						return currentQuote.consumerBusinessControl != null;
						break;
					case OriginatingOfficeCode.US:
						return currentQuote.insured != null;
						break;
					default:
						return true;
				}
			}
			return false;
		}
		
		private function getConsumerType():String {
			if (currentQuote && currentQuote.consumerBusinessControl) {
				return currentQuote.consumerBusinessControl.regulationSubType;
			}
			return null;
		}
		
		private function getInsuredProvince():Province {
			if (currentQuote && currentQuote.insured) {
				return currentQuote.insured.address.province;
			}
			return null;
		}		
	}
}
