package com.catlin.cargo.view.risk {

	import com.catlin.cargo.ApplicationFacade;
	import com.catlin.cargo.LazyCollectionExecutor;
	import com.catlin.cargo.bundles.RB_ui;
	import com.catlin.cargo.model.core.risk.PremiumType;
	import com.catlin.cargo.model.core.risk.Risk;
	import com.catlin.cargo.model.core.risk.RiskStatus;
	import com.catlin.cargo.model.core.risk.TriaInsuranceStatus;
	import com.catlin.cargo.model.documents.document.Document;
	import com.catlin.cargo.model.documents.document.DocumentType;
	import com.catlin.cargo.model.proxy.ReferenceDataProxy;
	import com.catlin.cargo.validation.ValidationUtil;
	import com.catlin.cargo.view.BaseMediator;
	import com.catlin.cargo.view.risk.clauses.ClausesFormMediator;
	import com.catlin.cargo.view.risk.coverperiod.CoverPeriodTitleWindow;
	import com.catlin.cargo.view.risk.coverperiod.CoverPeriodTitleWindowMediator;
	import com.catlin.cargo.view.risk.decline.DeclineReasonMediator;
	import com.catlin.cargo.view.risk.decline.DeclineReasonTitleWindow;
	import com.catlin.cargo.view.risk.email.EmailConfirmation;
	import com.catlin.cargo.view.risk.email.EmailConfirmationMediator;
	import com.catlin.cargo.view.risk.history.HistoryFormMediator;
	import com.catlin.cargo.view.risk.inceptiondate.InceptionDateTitleWindow;
	import com.catlin.cargo.view.risk.inceptiondate.InceptionDateTitleWindowMediator;
	import com.catlin.cargo.view.risk.mta.MTATitleWindow;
	import com.catlin.cargo.view.risk.mta.MTATitleWindowMediator;
	import com.catlin.cargo.view.risk.quoteentry.QuoteFormMediator;
	import com.catlin.cargo.view.risk.referrals.ReferralReasonsForm;
	import com.catlin.cargo.view.risk.referrals.ReferralReasonsFormMediator;
	import com.catlin.ui.flex.widgets.currency.CargoCurrencyFormatter;
	
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import mx.binding.utils.BindingUtils;
	import mx.collections.ArrayCollection;
	import mx.controls.Alert;
	import mx.controls.Button;
	import mx.effects.Glow;
	import mx.events.CloseEvent;
	import mx.formatters.DateFormatter;
	import mx.managers.PopUpManager;
	
	import org.puremvc.as3.interfaces.IMediator;
	import org.puremvc.as3.interfaces.INotification;

	public class ContentAreaMediator extends BaseMediator implements IMediator {

		public static const NAME:String='ContentAreaMediator';

		public static const ACCEPT_QUOTE:String="ACCEPT_QUOTE";
		public static const FRAME_RESEND:String="FRAME_RESEND";
		public static const NTU:String="NTU";
		public static const DECLINE:String="DECLINE";
		public static const EDIT:String="EDIT";
		public static const QUOTE_AGAIN:String="QUOTE_AGAIN";
		public static const REACTIVATE:String="REACTIVATE";
		public static const SEND_TO_BROKER:String="SEND_TO_BROKER";
		public static const HANDLE_OFFLINE:String="HANDLE_OFFLINE";
		public static const REQUEST_MTA:String="REQUEST_MTA";
		public static const EMAIL_DOCS:String="EMAIL_DOCS";
		public static const CANCEL_POLICY:String="CANCEL_POLICY";
		public static const REINSTATE:String="REINSTATE";
		public static const EXTEND_POLICY_PERIOD:String="EXTEND_POLICY_PERIOD";		
		
		private var currentQuote:Risk;
		private var cf:CargoCurrencyFormatter=new CargoCurrencyFormatter();
		private var df:DateFormatter=new DateFormatter();
		private var referralForm:DisplayObject;
		private var glowEffect:Glow;
		private var declineReasons:ArrayCollection;
		private var midTermAdjustmentReasons:ArrayCollection;
		
		public static const CONTENT_LABEL_SEPARATOR:String=" : ";
		public static const CONTEXT_LABEL_SEPARATOR:String=" | ";
		public static const EMPTY_STRING:String="";

		public function ContentAreaMediator(viewComponent:Object) {
			super(NAME, viewComponent);
			cf.precision=2;
			cf.currencySymbol=EMPTY_STRING;
			cf.showZero=true;
			df.formatString=ApplicationFacade.getInstance().localeFormat.dateShort4Year; //"DD/MM/YYYY";
			BindingUtils.bindProperty(df, "formatString", ApplicationFacade.getInstance(), ["localeFormat", "dateShort4Year"]);
		}

		override public function onRegister():void {
			facade.registerMediator(new QuoteFormMediator(contentArea.quoteForm));
			facade.registerMediator(new ReferralReasonsFormMediator(contentArea.referralReasonsForm));
			facade.registerMediator(new ClausesFormMediator(contentArea.clausesForm));
			facade.registerMediator(new HistoryFormMediator(contentArea.historyForm));

			glowEffect=new Glow();
			glowEffect.duration=1000;
			glowEffect.alphaFrom=0.3;
			glowEffect.alphaTo=0;
			glowEffect.blurXFrom=0;
			glowEffect.blurXTo=25;
			glowEffect.blurYFrom=0;
			glowEffect.blurYTo=25;
			glowEffect.color=0xff0000;

		}

		public function setCurrentRisk(risk:Risk, editModeEnabled:Boolean=false):void {

			var editable:Boolean=(risk.status == RiskStatus.NEW) || editModeEnabled;
			if (editable) {
				contentArea.quoteForm.multistepNavigator.fieldsEnabled=editable;
			}
			risk.editModeEnabled=editModeEnabled;

			currentQuote=risk;
			var quoteFormMediator:QuoteFormMediator=facade.retrieveMediator(QuoteFormMediator.NAME) as QuoteFormMediator;
			quoteFormMediator.setQuote(risk);
			quoteFormMediator.quoteForm.overrideDisplayQuoteNow=false;
			quoteFormMediator.quoteForm.cover.quote=risk;
			(facade.retrieveMediator(ReferralReasonsFormMediator.NAME) as ReferralReasonsFormMediator).currentQuote=risk;
			(facade.retrieveMediator(ClausesFormMediator.NAME) as ClausesFormMediator).currentQuote=risk;

			if (!editable) {
				contentArea.quoteForm.multistepNavigator.fieldsEnabled=editable;
			}

			quoteFormMediator.enableFields(risk);

			contentArea.supersededLabel.text=EMPTY_STRING;
			// multi-step navigator may have re-enabled sendings fields
			contentArea.quoteForm.getQuote.disableSendingsFields();

			ValidationUtil.clearErrors(contentArea.quoteForm.cover.endorsementStartDate);
			ValidationUtil.clearErrors(contentArea.quoteForm.cover.policyEndDate);
			sendNotification(ApplicationFacade.FIND_SUPERSEDING_RISK, risk.sid);
		}

		private function onAcceptConfirm(event:CloseEvent):void {
			if (event.detail == Alert.YES) {
				contentArea.buttonBar.dataProvider=[];
				sendNotification(ApplicationFacade.ACCEPT_QUOTE, currentQuote);
			} else {
				currentQuote.hasAnsweredTriaInsurance = false;
			}
		}

		private function onEmailDocsClose(event:CloseEvent):void {
			if (event.detail == Alert.YES) {
				sendNotification(ApplicationFacade.EMAIL_DOCS, currentQuote);
			}
		}

		private function get contentArea():ContentArea {
			return viewComponent as ContentArea;
		}

		public function showNoPremiumInfo():void {
			contentArea.contentLabel.text=EMPTY_STRING;
			contentArea.contextLabel.text=EMPTY_STRING;
		}

		// Was 'ApplicationFacade.RISK_LOADED' but caused false compile error of:
		// Parameter initializer unknown or is not a compile-time constant.ActionScript Error 1047
		public function showPremiumState(quote:Risk, triggeredBy:String="RISK_LOADED"):void {

			var placeHolders:Array = new Array();
			placeHolders[0] = "";
			placeHolders[1] = "";
			placeHolders[2] = "";
			placeHolders[3] = "";
			placeHolders[4] = "";
			
			
			// some of this labels will be driven by the session locale as it defines display format and not labelling.
			var locale:String = ApplicationFacade.getInstance().sessionLocale;
			// CONTENT_AREA_CONTENT_LABEL
			// CONTENT_AREA_CONTENT_LABEL_MTA_ADD
			
			var contentLabel:String= (quote.status != RiskStatus.NEW) ? quote.reference : EMPTY_STRING;
			placeHolders[0] = (quote.status != RiskStatus.NEW) ? quote.reference : EMPTY_STRING;
			placeHolders[2] = CONTENT_LABEL_SEPARATOR;
			
			var contextLabel:String=EMPTY_STRING;
			
			if (quote.isCancellation()) {
				placeHolders[1] = rm.getString(RB_ui.RB_NAME, RB_ui.CONTENT_AREA_MEDIATOR_CONTENT_LABEL_PREFIX_CANCELLATION);
			} else if (quote.isMidTermAdjustment()) {
				placeHolders[1] = rm.getString(RB_ui.RB_NAME, RB_ui.CONTENT_AREA_MEDIATOR_CONTENT_LABEL_PREFIX_MTA);
			} 

			switch (quote.status) {
				case RiskStatus.NEW:
					contentLabel = rm.getString(RB_ui.RB_NAME, RB_ui.CONTENT_AREA_MEDIATOR_CONTENT_LABEL_NEW);
					placeHolders[0] = rm.getString(RB_ui.RB_NAME, RB_ui.CONTENT_AREA_MEDIATOR_CONTENT_LABEL_NEW);
					placeHolders[2] = "";
					
					if (quote.previousRisk != null && !quote.isMidTermAdjustment()) {
						placeHolders[0] = quote.reference;
						placeHolders[2] = CONTENT_LABEL_SEPARATOR;
						placeHolders[3] = rm.getString(RB_ui.RB_NAME, RB_ui.CONTENT_AREA_MEDIATOR_CONTENT_LABEL_RENEWAL_OFFER);
						contentLabel=quote.reference + CONTENT_LABEL_SEPARATOR + rm.getString(RB_ui.RB_NAME, RB_ui.CONTENT_AREA_MEDIATOR_CONTENT_LABEL_RENEWAL_OFFER);
					}
					
					contextLabel=EMPTY_STRING;
					contentArea.contentAreaTabNavigator.getTabAt(0).label=rm.getString(RB_ui.RB_NAME, RB_ui.CONTENT_AREA_MEDIATOR_PROPOSAL);
					break;
				case RiskStatus.QUOTED:
				case RiskStatus.POLICY:
				case RiskStatus.QUOTE_PENDING:
					if (quote.isMidTermAdjustment()) {
						placeHolders[3] = createMTAHeadline(quote);
					} else {
						placeHolders[3] = createPremiumHeadline(quote);
					}

					// ContextLabel
					var premiumType:String;
					if (quote.premiumType == PremiumType.MAD) {
						premiumType=rm.getString(RB_ui.RB_NAME, RB_ui.CONTENT_AREA_MEDIATOR_PREMIUM_TYPE_MIN_AND_DEPOSIT);
					} else {
						premiumType=rm.getString(RB_ui.RB_NAME, RB_ui.CONTENT_AREA_MEDIATOR_PREMIUM_TYPE_FLAT_NA);
					}
					
					if (quote.triaInsuranceDetails.triaInsuranceStatus != TriaInsuranceStatus.REJECTED && quote.triaInsuranceDetails.triaInsuranceStatus != TriaInsuranceStatus.NOT_REQUIRED) {
						placeHolders[4] = createTriaHeadline(quote);
					} 					
					contextLabel=premiumType + CONTEXT_LABEL_SEPARATOR + rm.getString(RB_ui.RB_NAME, RB_ui.CONTENT_AREA_MEDIATOR_COMISSION) + 
						(isNaN(quote.commissionPercentage) ? rm.getString(RB_ui.RB_NAME, RB_ui.CONTENT_AREA_MEDIATOR_NET) : quote.commissionPercentage + "%");
					contentArea.contextLabel.styleName="contextNormal";
					break;
				case RiskStatus.REFERRED:
					placeHolders[3] = rm.getString(RB_ui.RB_NAME, RB_ui.CONTENT_AREA_MEDIATOR_CONTENT_LABEL_REFERRED);
					
					// ContextLabel
					if (ApplicationFacade.getInstance().userInfo.isUnderwriter) {
						contextLabel=EMPTY_STRING;
					} else {
						if (ApplicationFacade.RISK_LOADED == triggeredBy) {
							setContextMessage(rm.getString(RB_ui.RB_NAME, RB_ui.CONTENT_AREA_CONTEXT_MESSAGE_RISK_LOADED_MESSAGE), "contextWarning");
						} else {
							setContextMessage(rm.getString(RB_ui.RB_NAME, RB_ui.CONTENT_AREA_CONTEXT_MESSAGE_DEFAULT_MESSAGE), "contextWarning");
						}
					}
					break;
				case RiskStatus.OFFLINE:
					placeHolders[3] = rm.getString(RB_ui.RB_NAME, RB_ui.CONTENT_AREA_MEDIATOR_CONTENT_LABEL_OFFLINE);
					break;
				case RiskStatus.QUOTE_EXPIRED:
					placeHolders[3] = rm.getString(RB_ui.RB_NAME, RB_ui.CONTENT_AREA_MEDIATOR_CONTENT_LABEL_QUOTE_EXPIRED);
					contextLabel=rm.getString(RB_ui.RB_NAME, RB_ui.CONTENT_AREA_MEDIATOR_CONTENT_LABEL_EXPIRED_CONTEXT);
					break;
				case RiskStatus.CANCELLED:
					placeHolders[3] = rm.getString(RB_ui.RB_NAME, RB_ui.CONTENT_AREA_MEDIATOR_CONTENT_LABEL_CANCELLED);
					break;
				case RiskStatus.EXPIRED:
					placeHolders[3] = rm.getString(RB_ui.RB_NAME, RB_ui.CONTENT_AREA_MEDIATOR_CONTENT_LABEL_EXPIRED);
					break;
				case RiskStatus.LAPSED:
					placeHolders[3] = rm.getString(RB_ui.RB_NAME, RB_ui.CONTENT_AREA_MEDIATOR_CONTENT_LABEL_LAPSED);
					break;
				case RiskStatus.NTU:
					placeHolders[3] = rm.getString(RB_ui.RB_NAME, RB_ui.CONTENT_AREA_MEDIATOR_CONTENT_LABEL_NOT_TAKEN_UP);
					break;
				case RiskStatus.DECLINED:
					placeHolders[3] = rm.getString(RB_ui.RB_NAME, RB_ui.CONTENT_AREA_MEDIATOR_CONTENT_LABEL_DECLINED);
					break;
				default:
					break;
			}
			
			contentLabel = rm.getString(RB_ui.RB_NAME, RB_ui.CONTENT_AREA_CONTENT_LABEL, placeHolders); 
			contentArea.contentLabel.text=contentLabel;
			
			contentArea.contextLabel.text=contextLabel;
			glowEffect.play([contentArea.contentLabel, contentArea.contextLabel]);
		}

		private function createPremiumHeadline(quote:Risk):String {
			
			var premium:Number;
			var tax:Number;

			if (quote.premiumType == PremiumType.MAD) {
				premium=quote.madRate.premium;
				tax=quote.madRate.tax;
			} else {
				premium=quote.rate.premium;
				tax=quote.rate.tax;
			}
			
			// content_area.view.content_label.mta_add={0}{1} + {2}{3}
			var placeholders:Array = new Array();
			placeholders[0]=rm.getString(RB_ui.RB_NAME, RB_ui.CONTENT_AREA_MEDIATOR_PREMIUM);
			placeholders[1]=rm.getString(RB_ui.RB_NAME, RB_ui.CONTENT_AREA_MEDIATOR_CCY_AND_FORMAT, [quote.currency, cf.format(premium)]);
			placeholders[2]=rm.getString(RB_ui.RB_NAME, RB_ui.CONTENT_AREA_MEDIATOR_TAX);
			placeholders[3]=rm.getString(RB_ui.RB_NAME, RB_ui.CONTENT_AREA_MEDIATOR_CCY_AND_FORMAT, [quote.currency, cf.format(tax)]);
			
			var ret:String = rm.getString(RB_ui.RB_NAME, RB_ui.CONTENT_AREA_CONTENT_LABEL_MTA_ADD, placeholders); 
			
			return ret;
		}
		
		private function createTriaHeadline(quote:Risk):String {
			
			var triaPremium:Number = quote.triaInsuranceDetails.triaPremium;

			if (triaPremium == 0 && quote.triaInsuranceDetails.triaCalculatedPremium < 0 
					&& quote.status == RiskStatus.REFERRED 
					&& !quote.triaInsuranceDetails.triaPremiumOverridden) 
				triaPremium = quote.triaInsuranceDetails.triaCalculatedPremium;

			var placeholders:Array = new Array();
			placeholders[0]=" + " + rm.getString(RB_ui.RB_NAME, RB_ui.CONTENT_AREA_MEDIATOR_TRIA);
			placeholders[1]=rm.getString(RB_ui.RB_NAME, RB_ui.CONTENT_AREA_MEDIATOR_CCY_AND_FORMAT, [quote.currency, cf.format(triaPremium)]);
			
			return rm.getString(RB_ui.RB_NAME, RB_ui.CONTENT_AREA_CONTENT_LABEL_TRIA_ADD, placeholders);
		}
		

		private function createMTAHeadline(quote:Risk):String {
			
			var premium:Number;
			var tax:Number;

			if (quote.premiumType == PremiumType.MAD) {
				premium=quote.mtaMadRate.premium;
				tax=quote.mtaMadRate.tax;
			} else {
				premium=quote.mtaRate.premium;
				tax=quote.mtaRate.tax;
			}

			// content_area.view.content_label.mta_add={0}{1} + {2}{3}
			var placeholders:Array = new Array();	
			placeholders[0]=premium < 0 ? 
				rm.getString(RB_ui.RB_NAME, RB_ui.CONTENT_AREA_MEDIATOR_RETURN_PREMIUM) : 
				rm.getString(RB_ui.RB_NAME, RB_ui.CONTENT_AREA_MEDIATOR_ADDITIONAL_PREMIUM);
			
			placeholders[1]=rm.getString(RB_ui.RB_NAME, RB_ui.CONTENT_AREA_MEDIATOR_CCY_AND_FORMAT, [ quote.currency, cf.format(premium)]);
			placeholders[2]=tax < 0 ? 
				rm.getString(RB_ui.RB_NAME, RB_ui.CONTENT_AREA_MEDIATOR_RETURN_TAX) : 
				rm.getString(RB_ui.RB_NAME, RB_ui.CONTENT_AREA_MEDIATOR_ADDITIONAL_TAX);
			placeholders[3]=rm.getString(RB_ui.RB_NAME, RB_ui.CONTENT_AREA_MEDIATOR_CCY_AND_FORMAT, [ quote.currency, cf.format(tax)]);
				
			return rm.getString(RB_ui.RB_NAME, RB_ui.CONTENT_AREA_CONTENT_LABEL_MTA_ADD, placeholders);
		}

		public function setContextMessage(msg:String, style:String):void {
			contentArea.contextLabel.text=msg;
			contentArea.contextLabel.styleName=style;
			glowEffect.play([contentArea.contextLabel]);
		}

		// Done this way as its not possible to set the data provider then immediately obtain 
		// one of the buttons to set the enabled property
		public function setButtons(buttons:Array):void {
			contentArea.buttonBar.removeAllChildren();
			
			for each (var o:Object in buttons) {
				var button:Button=new Button();
				button.addEventListener(MouseEvent.CLICK, onButtonBarClick);
				button.label=rm.getString(RB_ui.RB_NAME, o["label"]);
				button.id=o["id"];
				if (o["enabled"] != null) {
					button.enabled=o["enabled"];
				}
				contentArea.buttonBar.addChild(button);
			}
		}

		private function onButtonBarClick(event:MouseEvent):void {

			switch (event.currentTarget.id) {
				case ContentAreaMediator.EDIT:
					if (currentQuote.isCoverPeriodMidTermAdjustment()) {
						launchExtendPolicyPeriodPopup();
					} else {
						sendNotification(ApplicationFacade.EDIT_QUOTE, currentQuote);
					}
					break;
				case ContentAreaMediator.ACCEPT_QUOTE:
					this.onAcceptQuote();
					break;
				case ContentAreaMediator.HANDLE_OFFLINE:
					sendNotification(ApplicationFacade.OFFLINE_QUOTE, currentQuote);
					break;
				case ContentAreaMediator.SEND_TO_BROKER:
					sendNotification(ApplicationFacade.LOAD_EMAIL_TEMPLATE, currentQuote);
					break;
				case ContentAreaMediator.REQUEST_MTA:
					/*
					 * A MTA can only be requested on the policy risk, so it is safe to use the start date from the current risk as the minimum
					 * endorsement date on the new MTA.
					 */
					(facade.retrieveMediator(QuoteFormMediator.NAME) as QuoteFormMediator).earliestEndorsementDate=currentQuote.startDate;
					var mtwm:MTATitleWindowMediator=ApplicationFacade.openPopUpWindow(MTATitleWindow, MTATitleWindowMediator) as MTATitleWindowMediator;
					mtwm.midTermAdjustmentReasons=midTermAdjustmentReasons;
					mtwm.initialise(currentQuote);
					break;
				case ContentAreaMediator.DECLINE:
				case ContentAreaMediator.CANCEL_POLICY:
				case ContentAreaMediator.NTU:
					var drm:DeclineReasonMediator=ApplicationFacade.openPopUpWindow(DeclineReasonTitleWindow, DeclineReasonMediator) as DeclineReasonMediator;
					drm.risk=currentQuote;
					drm.setDeclineReasons(declineReasons);
					break;
				case ContentAreaMediator.REACTIVATE:
					sendNotification(ApplicationFacade.QUOTE_RISK, currentQuote);
					break;
				case ContentAreaMediator.REINSTATE:
					sendNotification(ApplicationFacade.REINSTATE_RISK, currentQuote);
					break;
				case ContentAreaMediator.EMAIL_DOCS:
					
					var emailTo:String = (currentQuote.contactEmailAddress != null &&  currentQuote.contactEmailAddress != "") ? currentQuote.contactEmailAddress : currentQuote.brokerContact.emailAddress;
					var copiedTo:String = (currentQuote.copyEmailTo != null && currentQuote.copyEmailTo.length > 0) ? 
						rm.getString(RB_ui.RB_NAME, RB_ui.CONTENT_AREA_MEDIATOR_EMAIL_DOCS_COPIEDTO, [currentQuote.copyEmailTo]) : 
						EMPTY_STRING;
						
					Alert.show(
						rm.getString(RB_ui.RB_NAME, RB_ui.CONTENT_AREA_MEDIATOR_EMAIL_DOCS, [emailTo, copiedTo]), 
						rm.getString(RB_ui.RB_NAME, RB_ui.CONFIRMATION), 
						Alert.YES | Alert.NO, 
						null, 
						onEmailDocsClose);
					
					break;
				case ContentAreaMediator.EXTEND_POLICY_PERIOD:
					launchExtendPolicyPeriodPopup();
					break;
				case ContentAreaMediator.FRAME_RESEND:
					sendNotification(ApplicationFacade.FRAME_RESEND, currentQuote);
					break;
			}
		}


		private function onAcceptQuote():void {

			var currentDate:Date=new Date();
			currentDate=new Date(currentDate.fullYear, currentDate.month, currentDate.date);
			if (currentQuote.policyStartDateAsDate < currentDate && !ApplicationFacade.getInstance().userInfo.isUnderwriter && !currentQuote.isMidTermAdjustment()) {
				if (currentQuote.previousRisk == null) {
					var idtwm:InceptionDateTitleWindowMediator=ApplicationFacade.openPopUpWindow(InceptionDateTitleWindow, InceptionDateTitleWindowMediator) as InceptionDateTitleWindowMediator;
					idtwm.currentQuote=currentQuote;
				} else {
					var renewalAlert:Alert=Alert.show(
						rm.getString(RB_ui.RB_NAME, RB_ui.CONTENT_AREA_MEDIATOR_ACCEPT_QUOTE_RENEWAL_ALERT_MESSAGE), 
						rm.getString(RB_ui.RB_NAME, RB_ui.CONTENT_AREA_MEDIATOR_ACCEPT_QUOTE_RENEWAL_ALERT_TITLE));
					PopUpManager.centerPopUp(renewalAlert);
				}
			} else if (currentQuote.isCancellation()) {
				var alert:Alert=Alert.show(
						rm.getString(RB_ui.RB_NAME, RB_ui.CONTENT_AREA_MEDIATOR_ACCEPT_QUOTE_CANCELLATION_ALERT_MESSAGE, [currentQuote.policyReference, df.format(currentQuote.midTermAdjustmentDetails.endorsementStartDateAsDate)]), 
						rm.getString(RB_ui.RB_NAME, RB_ui.CONFIRMATION), 
						Alert.YES | Alert.NO, null, onAcceptConfirm, null, Alert.NO);
				PopUpManager.centerPopUp(alert);
			} else {
				var quoteFormMediator:QuoteFormMediator=facade.retrieveMediator(QuoteFormMediator.NAME) as QuoteFormMediator;
				if (quoteFormMediator.canBindCoverProceed()) {
					var alert2:Alert=Alert.show(
						rm.getString(RB_ui.RB_NAME, RB_ui.CONTENT_AREA_MEDIATOR_ACCEPT_QUOTE_BIND_COVER_ACCEPT_TEXT) + 
						rm.getString(RB_ui.RB_NAME, RB_ui.CONTENT_AREA_MEDIATOR_ACCEPT_QUOTE_BIND_COVER_ALERT_MESSAGE, [currentQuote.reference, df.format(currentQuote.policyStartDateAsDate)]),
 						rm.getString(RB_ui.RB_NAME, RB_ui.CONFIRMATION), 
						Alert.YES | Alert.NO, null, onAcceptConfirm, null, Alert.NO);
					PopUpManager.centerPopUp(alert2);
				}
			}

		}

		private function launchExtendPolicyPeriodPopup():void {
			var cptwm:CoverPeriodTitleWindowMediator=ApplicationFacade.openPopUpWindow(CoverPeriodTitleWindow, CoverPeriodTitleWindowMediator) as CoverPeriodTitleWindowMediator;
			cptwm.initialise(currentQuote);
		}

		public function showButtons():void {
			contentArea.contentAreaTabNavigator.getTabAt(0).label=rm.getString(RB_ui.RB_NAME, RB_ui.CONTENT_AREA_MEDIATOR_PROPOSAL) + CONTENT_LABEL_SEPARATOR + Risk.getFormattedStatus(currentQuote.status, currentQuote.previousRisk != null);
			switch (currentQuote.status) {
				case RiskStatus.QUOTED:
					if (!((facade as ApplicationFacade).userInfo.isSupport)) {
						setButtons([
							{label: RB_ui.CONTENT_AREA_MEDIATOR_BUTTON_ACCEPT_QUOTE , id: ContentAreaMediator.ACCEPT_QUOTE, enabled: currentQuote.isWebChannel()}, 
							{label: RB_ui.CONTENT_AREA_MEDIATOR_BUTTON_EMAIL_DOCS , id: ContentAreaMediator.EMAIL_DOCS}, 
							{label: RB_ui.CONTENT_AREA_MEDIATOR_BUTTON_NTU , id: ContentAreaMediator.NTU}, 
							{label: RB_ui.CONTENT_AREA_MEDIATOR_BUTTON_EDIT , id: ContentAreaMediator.EDIT, enabled: currentQuote.isWebChannel() && !currentQuote.isCancellation()}]);
					} else {
						setButtons([]);
					}
					break;
				case RiskStatus.REFERRED:
					if ((facade as ApplicationFacade).userInfo.isUnderwriter) {
						setButtons([
							{label: RB_ui.CONTENT_AREA_MEDIATOR_BUTTON_DECLINE , id: ContentAreaMediator.DECLINE}, 
							{label: RB_ui.CONTENT_AREA_MEDIATOR_BUTTON_HANDLE_OFFLINE , id: ContentAreaMediator.HANDLE_OFFLINE}, 
							{label: RB_ui.CONTENT_AREA_MEDIATOR_BUTTON_EDIT , id: ContentAreaMediator.EDIT, enabled: !currentQuote.isCancellation()}]);
					} else {
						setButtons([]);
					}
					break;
				case RiskStatus.QUOTE_PENDING:
					if ((facade as ApplicationFacade).userInfo.isUnderwriter) {
						setButtons([
							{label: RB_ui.CONTENT_AREA_MEDIATOR_BUTTON_DECLINE , id: ContentAreaMediator.DECLINE}, 
							{label: RB_ui.CONTENT_AREA_MEDIATOR_BUTTON_SEND_TO_BROKER , id: ContentAreaMediator.SEND_TO_BROKER}, 
							{label: RB_ui.CONTENT_AREA_MEDIATOR_BUTTON_HANDLE_OFFLINE , id: ContentAreaMediator.HANDLE_OFFLINE}, 
							{label: RB_ui.CONTENT_AREA_MEDIATOR_BUTTON_EDIT , id: ContentAreaMediator.EDIT, enabled: !currentQuote.isCancellation()}]);
					} else {
						setButtons([]);
					}
					break;
				case RiskStatus.QUOTE_EXPIRED:
					if (!((facade as ApplicationFacade).userInfo.isSupport)) {
						setButtons([
							{label: RB_ui.CONTENT_AREA_MEDIATOR_BUTTON_NTU , id: ContentAreaMediator.NTU}, 
							{label: RB_ui.CONTENT_AREA_MEDIATOR_BUTTON_EDIT , id: ContentAreaMediator.EDIT, enabled: currentQuote.isWebChannel() && !currentQuote.isCancellation()}]);
					} else {
						setButtons([]);
					}
					break;
				case RiskStatus.POLICY:
					contentArea.contentAreaTabNavigator.getTabAt(0).label=rm.getString(RB_ui.RB_NAME, RB_ui.CONTENT_AREA_MEDIATOR_POLICY);
					if (!(facade as ApplicationFacade).userInfo.isSupport) {
						setButtons([
							{label: RB_ui.CONTENT_AREA_MEDIATOR_BUTTON_REQUEST_MTA , id: ContentAreaMediator.REQUEST_MTA}, 
							{label: RB_ui.CONTENT_AREA_MEDIATOR_BUTTON_EXTEND_POLICY_PERIOD , id: ContentAreaMediator.EXTEND_POLICY_PERIOD}, 
							{label: RB_ui.CONTENT_AREA_MEDIATOR_BUTTON_CANCEL_POLICY , id: ContentAreaMediator.CANCEL_POLICY}, 
							{label: RB_ui.CONTENT_AREA_MEDIATOR_BUTTON_EMAIL_DOCS , id: ContentAreaMediator.EMAIL_DOCS}]);
					} else {
						setButtons([
							{label: RB_ui.CONTENT_AREA_MEDIATOR_BUTTON_FRAME_RESEND , id: ContentAreaMediator.FRAME_RESEND}
						]);
					}
					break;
				case RiskStatus.NTU:
				case RiskStatus.OFFLINE:
					if (!currentQuote.isMidTermAdjustment() && !((facade as ApplicationFacade).userInfo.isSupport)) {
						setButtons([{label: RB_ui.CONTENT_AREA_MEDIATOR_BUTTON_REACTIVATE , id: ContentAreaMediator.REACTIVATE}]);
					} else {
						setButtons([]);
					}
					break;
				case RiskStatus.DECLINED:
					if ((facade as ApplicationFacade).userInfo.isUnderwriter && !currentQuote.isMidTermAdjustment()) {
						setButtons([{label: RB_ui.CONTENT_AREA_MEDIATOR_BUTTON_REACTIVATE , id: ContentAreaMediator.REACTIVATE}]);
					} else {
						setButtons([]);
					}
					break;
				case RiskStatus.CANCELLED:
					if ((facade as ApplicationFacade).userInfo.isUnderwriter && !currentQuote.isMidTermAdjustment()) {
						setButtons([{label: RB_ui.CONTENT_AREA_MEDIATOR_BUTTON_REINSTATE , id: ContentAreaMediator.REINSTATE}]);
					} else {
						setButtons([]);
					}
					break;
				case RiskStatus.EXPIRED:
				case RiskStatus.LAPSED:
					if ((facade as ApplicationFacade).userInfo.isSupport) {
						setButtons([{label: RB_ui.CONTENT_AREA_MEDIATOR_BUTTON_FRAME_RESEND , id: ContentAreaMediator.FRAME_RESEND}]);
					} else {
						setButtons([]);
					}
					break;
				case RiskStatus.NEW:
				default:
					setButtons([]);
					break;
			}
		}

		public function showEditLabel():void {
			setBasicLabel(rm.getString(RB_ui.RB_NAME, RB_ui.CONTENT_AREA_MEDIATOR_EDIT_QUOTE));
		}

		public function manageTabs(quote:Risk):void {
			new LazyCollectionExecutor(quote.referralRuleFailures, manageTabsAfterInit, quote).execute();
		}

		public function manageTabsAfterInit(quote:Risk):void {
			if (quote.status == RiskStatus.REFERRED || (quote.status == RiskStatus.QUOTE_PENDING && quote.referralRuleFailures.length > 0)) {
				if (referralForm != null) {
					contentArea.contentAreaTabNavigator.addChild(referralForm);
				}
			} else {
				var form:DisplayObject=contentArea.contentAreaTabNavigator.getChildByName("referralReasonsForm");
				if (form != null) {
					// if this is the first time we have done this, add ourselves as a listener
					if (referralForm == null) {
						(form as ReferralReasonsForm).overrideReferral.addEventListener(Event.CHANGE, onOverrideReferralChange);
					}
					referralForm=form;
					contentArea.contentAreaTabNavigator.removeChild(referralForm);
				}
			}

			var tabChild:*=contentArea.contentAreaTabNavigator.getChildByName("clausesForm");
			manageUnderwriterBasedTab(tabChild, contentArea.clausesForm);

			tabChild=contentArea.contentAreaTabNavigator.getChildByName("historyForm");
			manageUnderwriterBasedTab(tabChild, contentArea.historyForm);
		}

		private function onOverrideReferralChange(event:Event):void {
			contentArea.quoteForm.overrideDisplayQuoteNow=true;
		}

		private function manageUnderwriterBasedTab(tabChild:*, frm:*):void {
			if (!ApplicationFacade.getInstance().userInfo.isUnderwriter) {
				if (tabChild != null) {
					contentArea.contentAreaTabNavigator.removeChild(tabChild);
				}
			} else {
				if (tabChild == null) {
					contentArea.contentAreaTabNavigator.addChild(frm);
				}
			}
		}

		public function showDocuments(risk:Risk):void {
			if (risk != null && !risk.status.equals(RiskStatus.QUOTE_EXPIRED)) {
				var documents:ArrayCollection=new ArrayCollection();
				if (risk.scheduleDocument != null) {
					documents.addItem(risk.scheduleDocument);
				}
				if (risk.ratingScheduleDocument != null && risk.premiumType == PremiumType.MAD) {
					documents.addItem(risk.ratingScheduleDocument);
				}
				if (risk.wordingDocument != null) {
					documents.addItem(risk.wordingDocument);
				}
				if (risk.keyFactsDocument != null) {
					documents.addItem(risk.keyFactsDocument);
				}
				if (risk.policyChangesDocument != null) {
					documents.addItem(risk.policyChangesDocument);
				}
				if (risk.noticeToPolicyHolderDocument != null) {
					documents.addItem(risk.noticeToPolicyHolderDocument);
				}
				if (risk.debitInstructionDocument != null && (ApplicationFacade.getInstance().userInfo.isUnderwriter || risk.debitNoteAvailableToBroker)) {
					contentArea.debitNoteAvailableToBroker=risk.debitNoteAvailableToBroker;
					documents.addItem(risk.debitInstructionDocument);
				}
				contentArea.documentRepeater.dataProvider=documents;
			} else {
				contentArea.documentRepeater.dataProvider=null;
			}
		}

		override public function listNotificationInterests():Array {
			return [ApplicationFacade.CREATE_BASIC_DOCUMENTS_COMPLETE, ApplicationFacade.LOAD_EMAIL_TEMPLATE_COMPLETE, ReferenceDataProxy.FIND_ALL_DECLINE_REASONS_COMPLETE, ReferenceDataProxy.FIND_ALL_MTA_REASONS_COMPLETE, ApplicationFacade.RISK_MERGED, ApplicationFacade.MTA_CREATE_QUOTE_COMPLETE, ApplicationFacade.RISK_LOADED, ApplicationFacade.EARLIEST_ENDORSEMENT_DATE_LOADED, ApplicationFacade.MTA_ACTIONS_DETERMINED, ApplicationFacade.SUPERSEDING_RISK_FOUND, ApplicationFacade.COVER_PERIOD_MTA_QUOTE_COMPLETE, ApplicationFacade.ACCEPT_QUOTE_AFTER_UPDATE];
		}

		override public function handleNotification(note:INotification):void {
			var risk:Risk;
			switch (note.getName()) {
				case ApplicationFacade.CREATE_BASIC_DOCUMENTS_COMPLETE:
					updateDocuments(note.getBody());
					break;
				case ApplicationFacade.LOAD_EMAIL_TEMPLATE_COMPLETE:
					showEmailConfirmation(note.getBody() as ArrayCollection);
					break;
				case ReferenceDataProxy.FIND_ALL_DECLINE_REASONS_COMPLETE:
					populateDeclineReasons((note.getBody() as ArrayCollection));
					break;
				case ReferenceDataProxy.FIND_ALL_MTA_REASONS_COMPLETE:
					midTermAdjustmentReasons=(note.getBody() as ArrayCollection);
					break;
				case ApplicationFacade.RISK_LOADED:
					contentArea.contentAreaTabNavigator.selectedIndex=0;
					contentArea.quoteForm.multistepNavigator.selectedIndex=0;
					risk=note.getBody() as Risk;
					setCurrentRisk(risk);
					if (risk.status != RiskStatus.NEW && risk.isMidTermAdjustment()) {
						sendNotification(ApplicationFacade.LOAD_EARLIEST_ENDORSEMENT_DATE, risk.sid);
					}
					postLoadRisk(risk);
					break;
				case ApplicationFacade.RISK_MERGED:
					risk=note.getBody() as Risk;
					setCurrentRisk(risk);
					postLoadRisk(risk);
					contentArea.quoteForm.getQuote.mdlQuote.sendings.refresh();
					break;
				case ApplicationFacade.EARLIEST_ENDORSEMENT_DATE_LOADED:
					var date:Date=note.getBody() as Date;
					(facade.retrieveMediator(QuoteFormMediator.NAME) as QuoteFormMediator).earliestEndorsementDate=date;
					break;
				case ApplicationFacade.MTA_CREATE_QUOTE_COMPLETE:
					var mtaRisk:Risk=note.getBody() as Risk;
					setCurrentRisk(mtaRisk);

					manageTabs(currentQuote);
					showButtons();
					showPremiumState(mtaRisk, ApplicationFacade.RISK_MERGED);
					showDocuments(mtaRisk);
					contentArea.quoteForm.multistepNavigator.selectedIndex=0;
					break;
				case ApplicationFacade.MTA_ACTIONS_DETERMINED:
					updateMtaAllowed(note.getBody() as Boolean);
					break;
				case ApplicationFacade.SUPERSEDING_RISK_FOUND:
					updateSupersedingRisk(note.getBody() as Risk);
					restrictReinstatement();
					break;
				case ApplicationFacade.COVER_PERIOD_MTA_QUOTE_COMPLETE:
					contentArea.quoteForm.multistepNavigator.selectedIndex=contentArea.quoteForm.multistepNavigator.numChildren - 1;
					break;
				case ApplicationFacade.ACCEPT_QUOTE_AFTER_UPDATE:
					this.onAcceptQuote();
					break;
			}
		}

		private function restrictReinstatement():void {
			switch (currentQuote.status) {
				case RiskStatus.CANCELLED:
				case RiskStatus.NTU:
				case RiskStatus.OFFLINE:
				case RiskStatus.DECLINED:
					setButtons([]);
					break;
			}
			showButtons();
		}

		private function updateSupersedingRisk(quote:Risk):void {
			if (quote != null) {
				var status:RiskStatus=quote.status;
				if (status == RiskStatus.POLICY || status == RiskStatus.EXPIRED) {
					contentArea.supersededLabel.text=rm.getString(RB_ui.RB_NAME, RB_ui.CONTENT_AREA_MEDIATOR_RISK_SUPERSEDED);
				} else {
					contentArea.supersededLabel.text=rm.getString(RB_ui.RB_NAME, RB_ui.CONTENT_AREA_MEDIATOR_RISK_SUPERSEDED_PENDING_MTA);
				}
			}
		}

		/*
		* TODO - at a less sensitive time in a project, determine
		* whether this can be merged in to 'setCurrentRisk'.
		*/
		private function postLoadRisk(risk:Risk):void {
			manageTabs(currentQuote);
			/*
			* If the risk is in POLICY state, we need to find out whether it is allowed
			* to raise an MTA - we want to wait until we have determined this before
			* constructing the button bar, or we may have a noticeable pause where
			* the button is enabled before being disabled, which would allow someone
			* to click on it.
			*/
			if (risk.status == RiskStatus.POLICY) {
				disableAllButtons();
				sendNotification(ApplicationFacade.DETERMINE_MTA_ACTIONS, risk.sid);
			} else {
				showButtons();
			}
			showPremiumState(risk, ApplicationFacade.RISK_LOADED);
			showDocuments(risk);
			ApplicationFacade.getInstance().setQuoting(false);
		}

		private function disableAllButtons():void {
			for (var i:int=0; i < contentArea.buttonBar.numChildren; i++) {
				(contentArea.buttonBar.getChildAt(i) as Button).enabled=false;
			}
		}

		private function updateMtaAllowed(mtaAllowed:Boolean):void {
			showButtons();
			for (var i:int=0; i < contentArea.buttonBar.numChildren; i++) {
				var button:Button=contentArea.buttonBar.getChildAt(i) as Button;
				if (button.id == ContentAreaMediator.REQUEST_MTA || button.id == ContentAreaMediator.EXTEND_POLICY_PERIOD) {
					button.enabled=mtaAllowed;
				}
			}
		}

		private function populateDeclineReasons(declineReasons:ArrayCollection):void {
			this.declineReasons=declineReasons;
		}

		private function showEmailConfirmation(fragments:ArrayCollection):void {
			var ecm:EmailConfirmationMediator=ApplicationFacade.openPopUpWindow(EmailConfirmation, EmailConfirmationMediator) as EmailConfirmationMediator;
			ecm.currentQuote=currentQuote;
			ecm.fragments=fragments;
		}

		private function updateDocuments(documents:Object):void {
 
			currentQuote.wordingDocument=documents[DocumentType.WORDINGS];
			 
			if (currentQuote.previousRisk == null || 
				(documents[DocumentType.KEY_FACTS] != null && 
					currentQuote.previousRisk.keyFactsDocument != null && 
					currentQuote.previousRisk.keyFactsDocument.sid != (documents[DocumentType.KEY_FACTS] as Document).sid
				) 
			) {
					currentQuote.keyFactsDocument=documents[DocumentType.KEY_FACTS];
			}

			if (isPolicyChangesDocumentRequired(currentQuote, documents[DocumentType.POLICY_CHANGES])) {
				currentQuote.policyChangesDocument = documents[DocumentType.POLICY_CHANGES];
			} else {
				currentQuote.policyChangesDocument = null;
			}

			if (isNoticeToPolicyHolderDocumentRequired(currentQuote, documents[DocumentType.NOTICE_TO_POLICYHOLDERS])) {
				currentQuote.noticeToPolicyHolderDocument = documents[DocumentType.NOTICE_TO_POLICYHOLDERS];
			} else {
				currentQuote.noticeToPolicyHolderDocument = null;
			}

			showDocuments(currentQuote);
		}

		private function isPolicyChangesDocumentRequired(currentQuote:Risk, currentDocument:Document):Boolean {
			
			if (currentDocument != null) {
				// If is a renewal
				if (currentQuote && currentQuote.previousRisk != null) {
					// Check if it already contains a policy changes and comapne with the current version. 
					if (currentQuote.previousRisk.policyChangesDocument == null || currentQuote.previousRisk.policyChangesDocument.sid != currentDocument.sid) {
						return true;
					}
				}
			}
			return false;
		}
		
		private function isNoticeToPolicyHolderDocumentRequired(currentQuote:Risk, currentDocument:Document):Boolean {
			
			if (currentDocument != null) {
				// If is a renewal
				if (currentQuote && currentQuote.previousRisk != null) {
					// Check if it already contains a noticeToPolicyHolderDocument and comapne with the current version. 
					if (currentQuote.previousRisk.noticeToPolicyHolderDocument == null || currentQuote.previousRisk.noticeToPolicyHolderDocument.sid != currentDocument.sid) {
						return true;
					}
				} else {
					return true;
				}
			}
			return false;
		}		

		public function hasDocumentChanged(currentDoc:Document, newDoc:Document):String {
			if (currentDoc != null && newDoc != null) {
				if (currentDoc.sid != newDoc.sid) {
					return newDoc.name + "\n ";
				}
			}
			return EMPTY_STRING;
		}

		public function hideQuoteDocument():void {
			var newdp:ArrayCollection=new ArrayCollection();
			for each (var doc:Document in contentArea.documentRepeater.dataProvider) {
				if (doc.name != 'Quote Schedule') {
					newdp.addItem(doc);
				}
			}
			contentArea.documentRepeater.dataProvider=newdp;
		}

		private function setBasicLabel(label:String):void {
			contentArea.contentLabel.text=label;
			contentArea.contextLabel.text=EMPTY_STRING;
			glowEffect.play([contentArea.contentLabel]);
		}
	}
}
