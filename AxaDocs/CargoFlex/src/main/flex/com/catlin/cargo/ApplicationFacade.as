package com.catlin.cargo {
	import com.catlin.cargo.bundles.CargoCurrencyConstants;
	import com.catlin.cargo.bundles.CargoLocaleConstants;
	import com.catlin.cargo.controller.AcceptQuoteCommand;
	import com.catlin.cargo.controller.AcceptTermsOfUseCommand;
	import com.catlin.cargo.controller.ApplicationStartupCommand;
	import com.catlin.cargo.controller.CancelPolicyCommand;
	import com.catlin.cargo.controller.ChangeCoverPeriodCommand;
	import com.catlin.cargo.controller.ChangePasswordCommand;
	import com.catlin.cargo.controller.ContactUsQueryCommand;
	import com.catlin.cargo.controller.CreateBasicDocumentsCommand;
	import com.catlin.cargo.controller.CreateBrokerOfficeCommand;
	import com.catlin.cargo.controller.CreateClauseCommand;
	import com.catlin.cargo.controller.CreateQuoteCommand;
	import com.catlin.cargo.controller.DeclineRiskCommand;
	import com.catlin.cargo.controller.DetermineLatestEndDateCommand;
	import com.catlin.cargo.controller.DetermineMtaActionsCommand;
	import com.catlin.cargo.controller.DisplayQuoteCommand;
	import com.catlin.cargo.controller.EditQuoteCommand;
	import com.catlin.cargo.controller.EmailDocsCommand;
	import com.catlin.cargo.controller.FindSupersedingRiskCommand;
	import com.catlin.cargo.controller.ForceRenewalCommand;
	import com.catlin.cargo.controller.GenerateRisksReportCommand;
	import com.catlin.cargo.controller.LoadCurrentUserInfoCommand;
	import com.catlin.cargo.controller.LoadEarliestEndorsementDateCommand;
	import com.catlin.cargo.controller.LoadEmailTemplateCommand;
	import com.catlin.cargo.controller.LogoutCommand;
	import com.catlin.cargo.controller.OfflineQuoteCommand;
	import com.catlin.cargo.controller.PostcodeFetchCommand;
	import com.catlin.cargo.controller.PostcodeLookupCommand;
	import com.catlin.cargo.controller.PrepQuoteFormCommand;
	import com.catlin.cargo.controller.PrepUsefulLinkCommand;
	import com.catlin.cargo.controller.QuoteRiskCommand;
	import com.catlin.cargo.controller.ReinstateRiskCommand;
	import com.catlin.cargo.controller.RequestMTACommand;
	import com.catlin.cargo.controller.ResendToFrameCommand;
	import com.catlin.cargo.controller.ResetPasswordCommand;
	import com.catlin.cargo.controller.RiskDocumentModifiedCommand;
	import com.catlin.cargo.controller.SaveBrokerContactCommand;
	import com.catlin.cargo.controller.SaveBrokerOfficeCommand;
	import com.catlin.cargo.controller.SaveBrokerOfficeUsefulLinksCommand;
	import com.catlin.cargo.controller.SaveOrUpdateUsefulLinkCommand;
	import com.catlin.cargo.controller.SaveSourceAssociationCommand;
	import com.catlin.cargo.controller.SaveUnderwriterCommand;
	import com.catlin.cargo.controller.SearchCommand;
	import com.catlin.cargo.controller.SendToBrokerCommand;
	import com.catlin.cargo.controller.UpdateClauseArchiveStatusCommand;
	import com.catlin.cargo.controller.UpdateFinancialControlRegulationCommand;
	import com.catlin.cargo.controller.UpdateInsuredDetailsCommand;
	import com.catlin.cargo.controller.UpdateLimitsAndDeductiablesCommand;
	import com.catlin.cargo.controller.UpdateTriaInsuranceCommand;
	import com.catlin.cargo.model.core.originatingoffice.OriginatingOfficeCode;
	import com.catlin.cargo.model.locale.LocaleFormat;
	import com.catlin.cargo.model.security.UserInfo;
	import com.catlin.cargo.model.ui.lookandfeel.LookAndFeel;
	
	import flash.display.Sprite;
	import flash.utils.Dictionary;
	
	import mx.binding.utils.ChangeWatcher;
	import mx.controls.Text;
	import mx.core.Application;
	import mx.core.IFlexDisplayObject;
	import mx.managers.PopUpManager;
	import mx.resources.ResourceManager;
	import mx.styles.CSSStyleDeclaration;
	import mx.styles.StyleManager;
	
	import org.puremvc.as3.interfaces.IMediator;
	import org.puremvc.as3.patterns.facade.Facade;
	import org.puremvc.as3.patterns.mediator.Mediator;
	import org.puremvc.as3.patterns.observer.Notification;
	
	/**
	 * A concrete <code>Facade</code> for the <code>ApplicationSkeleton</code> application.
	 * <P>
	 * The main job of the <code>ApplicationFacade</code> is to act as a single
	 * place for mediators, proxies and commands to access and communicate
	 * with each other without having to interact with the Model, View, and
	 * Controller classes directly. All this capability it inherits from
	 * the PureMVC Facade class.</P>
	 *
	 * <P>
	 * This concrete Facade subclass is also a central place to define
	 * notification constants which will be shared among commands, proxies and
	 * mediators, as well as initializing the controller with Command to
	 * Notification mappings.</P>
	 */
	public class ApplicationFacade extends Facade {
		
		public static const ERROR_STYLE_NAME:String="cargoErrorStyle";
		
		// Notification name constants
		// application
		public static const PREPARE:String="PREPARE";
		
		public static const STARTUP:String="STARTUP";
		
		public static const LOAD_CURRENT_USER:String="LOAD_CURRENT_USER";
		
		public static const ACCEPT_TERMS_OF_USE:String="ACCEPT_TERMS_OF_USE";
		
		public static const LOGOUT:String="LOGOUT";
		
		public static const PREP_QUOTE_FORM:String="PREP_QUOTE_FORM";
		
		public static const CREATE_QUOTE:String="CREATE_QUOTE";
		
		public static const EDIT_QUOTE:String="EDIT_QUOTE";
		
		public static const FORCE_RENEWAL:String="FORCE_RENEWAL";
		
		public static const SHOW_ADMINISTRATION:String="SHOW_ADMINISTRATION";
		
		public static const RESET_PASSWORD:String="RESET_PASSWORD";
		
		public static const CHANGE_PASSWORD:String="CHANGE_PASSWORD";
		
		public static const LOAD_BROKER_OFFICE:String="LOAD_BROKER_OFFICE";
		
		public static const CREATE_BROKER_OFFICE:String="CREATE_BROKER_OFFICE";
		
		public static const SAVE_BROKER_OFFICE:String="SAVE_BROKER_OFFICE";
		
		public static const SAVE_BROKER_OFFICE_COMPLETE:String='saveBrokerOfficeComplete';
		
		public static const SAVE_SOURCE_ASSOCIATION:String="SAVE_SOURCE_ASSOCIATION";
		
		public static const SAVE_SOURCE_ASSOCIATION_COMPLETE:String="SAVE_SOURCE_ASSOCIATION_COMPLETE";
		
		public static const SAVE_BROKER_CONTACT:String="SAVE_BROKER_CONTACT";
		
		public static const LOAD_UNDERWRITER:String="LOAD_UNDERWRITER";
		
		public static const SAVE_UNDERWRITER:String="SAVE_UNDERWRITER";
		
		public static const CANCEL_SELECTED:String="CANCEL_SELECTED";
		
		public static const RISK_LOADED:String="RISK_LOADED";
		
		public static const RISK_MERGED:String="RISK_MERGED";
		
		public static const MTA_CREATE_QUOTE_COMPLETE:String="MTA_CREATE_QUOTE_COMPLETE";
		
		public static const QUOTE_RISK:String="QUOTE_RISK";
		
		public static const UPDATE_FINANCIAL_CONTROL_REGULATION:String="UPDATE_FINANCIAL_CONTROL_REGULATION";
		
		public static const UPDATE_TRIA_INSURANCE:String="UPDATE_TRIA_INSURANCE";
		
		public static const ACCEPT_QUOTE_AFTER_UPDATE:String="ACCEPT_QUOTE_AFTER_UPDATE";
		
		public static const ACCEPT_QUOTE:String="ACCEPT_QUOTE";
		
		public static const DISPLAY_QUOTE:String="DISPLAY_QUOTE";
		
		public static const OFFLINE_QUOTE:String="OFFLINE_QUOTE";
		
		public static const SEND_TO_BROKER:String="SEND_TO_BROKER";
		
		public static const CREATE_CLAUSE:String="CREATE_CLAUSE";
		
		public static const DECLINE_RISK:String="DECLINE_RISK";
		
		public static const CANCEL_POLICY:String="CANCEL_POLICY";
		
		public static const REQUEST_MTA:String="REQUEST_MTA";
		
		public static const REINSTATE_RISK:String="REINSTATE_RISK";
		
		public static const LOOKUP_POSTCODE:String="LOOKUP_POSTCODE";
		
		public static const FETCH_POSTCODE:String="FETCH_POSTCODE";
		
		public static const LOAD_EMAIL_TEMPLATE:String="LOAD_EMAIL_TEMPLATE";
		
		public static const LOAD_EMAIL_TEMPLATE_COMPLETE:String="LOAD_EMAIL_TEMPLATE_COMPLETE";
		
		public static const SEARCH:String="SEARCH";
		
		public static const EMAIL_DOCS:String="EMAIL_DOCS";
		
		public static const CREATE_BASIC_DOCUMENTS:String="CREATE_BASIC_DOCUMENTS";
		
		public static const REFRESH_ALL_RISKS:String="REFRESH_ALL_RISKS";
		
		public static const CONTACT_US_QUERY:String="CONTACT_US_QUERY";
		
		public static const CREATE_BASIC_DOCUMENTS_COMPLETE:String="CREATE_BASIC_DOCUMENTS_COMPLETE";
		
		public static const UPDATE_CLAUSE_ARCHIVE_STATUS:String="UPDATE_CLAUSE_ARCHIVE_STATUS";
		
		public static const UPDATE_LIMITS_AND_DEDCTIBLES:String="UPDATE_LIMITS_AND_DEDCTIBLES";
		
		public static const LOOK_UP_USER_EDIT_RIGHTS:String="LOOK_UP_USER_EDIT_RIGHTS";
		
		public static const LOAD_EARLIEST_ENDORSEMENT_DATE:String="LOAD_EARLIEST_ENDORSEMENT_DATE";
		
		public static const EARLIEST_ENDORSEMENT_DATE_LOADED:String="EARLIEST_ENDORSEMENT_DATE_LOADED";
		
		public static const DETERMINE_MTA_ACTIONS:String="DETERMINE_MTA_ACTIONS";
		
		public static const MTA_ACTIONS_DETERMINED:String="MTA_ACTIONS_DETERMINED";
		
		public static const DETERMINE_LATEST_END_DATE:String="DETERMINE_LATEST_END_DATE";
		
		public static const LATEST_END_DATE_DETERMINED:String="LATEST_END_DATE_DETERMINED";
		
		public static const FIND_SUPERSEDING_RISK:String="FIND_SUPERSEDING_RISK";
		
		public static const SUPERSEDING_RISK_FOUND:String="SUPERSEDING_RISK_FOUND";
		
		public static const CREATE_COVER_PERIOD_MTA_QUOTE:String="CREATE_COVER_PERIOD_MTA_QUOTE";
		
		public static const COVER_PERIOD_MTA_QUOTE_COMPLETE:String="COVER_PERIOD_MTA_QUOTE_COMPLETE";
		
		public static const FRAME_RESEND:String="FRAME_RESEND";
		
		public static const REFRESH_COVER_DEDUCTIBLE:String="REFRESH_COVER_DEDUCTIBLE";
		
		public static const LOCALE_CHANGED:String="LOCALE_CHANGED";
		
		public static const LF_PREVIEW_LOGO:String='LF_PREVIEW_LOGO';
		
		public static const LF_RESET_LOGO:String='LF_RESET_LOGO';
		
		public static const ADMIN_VIEW_ID:String='ADMIN_VIEW_ID';
		
		public static const SAVE_OR_UPDATE_USEFUL_LINK:String='SAVE_OR_UPDATE_USEFUL_LINK';
		
		public static const SAVE_OR_UPDATE_USEFUL_LINK_COMPLETE:String='SAVE_OR_UPDATE_USEFUL_LINK_COMPLETE';
		
		public static const PREP_USEFUL_LINKS:String='PREP_USEFUL_LINKS';
		
		public static const SAVE_BROKER_OFFICE_USEFUL_LINKS:String="SAVE_BROKER_OFFICE_USEFUL_LINKS";
		
		public static const GENERATE_RISKS_REPORT:String="GENERATE_RISKS_REPORT";
		
		public static const RISK_DOCUMENT_MODIFIED_ALERT:String="RISK_DOCUMENT_MODIFIED_ALERT";

		public static const VALIDATE_SURPLES_STATE_VS_INSURED_STATE:String="VALIDATE_SURPLES_STATE_VS_INSURED_STATE";

		public static const UPDATE_INSURED:String="UPDATE_INSURED";

		public static const UPDATE_INSURED_COMPLETE:String="UPDATE_INSURED_COMPLETE";

		//public static const VALIDATE_RISK_DOCUMENT_VERSIONS:String="VALIDATE_RISK_DOCUMENT_VERSIONS";
		//public static const VALIDATE_RISK_DOCUMENT_VERSIONS_COMPLETE:String="VALIDATE_RISK_DOCUMENT_VERSIONS_COMPLETE";

		
		[Bindable]
		public var userInfo:UserInfo=null;
		
		[Bindable]
		public var initialised:Boolean=false;
		
		private var quotingBodgit:Text=null;
		
		private var _localeFormat:LocaleFormat=null;
		
		[Bindable]
		public function get localeFormat():LocaleFormat {
			if (!_localeFormat)
				return new LocaleFormat();
			return _localeFormat;
		}
		
		public function set localeFormat(l:LocaleFormat):void {
			_localeFormat = l;
		}		
		
		private var app:CargoFlex;
		
		private var startupCommandIssued:Boolean=false;
		
		function ApplicationFacade() {
		}
		
		/**
		 * Singleton ApplicationFacade Factory Method
		 */
		public static function getInstance():ApplicationFacade {
			if (instance == null)
				instance=new ApplicationFacade();
			return instance as ApplicationFacade;
		}
		
		/**
		 * Register Commands with the Controller
		 */
		override protected function initializeController():void {
			super.initializeController();
			
			//registerCommand(PREPARE, PrepareApplicationCommand);
			registerCommand(STARTUP, ApplicationStartupCommand);
			registerCommand(LOAD_CURRENT_USER, LoadCurrentUserInfoCommand);
			registerCommand(ACCEPT_TERMS_OF_USE, AcceptTermsOfUseCommand);
			registerCommand(LOGOUT, LogoutCommand);
			registerCommand(PREP_QUOTE_FORM, PrepQuoteFormCommand);
			registerCommand(CREATE_QUOTE, CreateQuoteCommand);
			registerCommand(EDIT_QUOTE, EditQuoteCommand);
			registerCommand(QUOTE_RISK, QuoteRiskCommand);
			registerCommand(UPDATE_FINANCIAL_CONTROL_REGULATION, UpdateFinancialControlRegulationCommand);
			registerCommand(UPDATE_TRIA_INSURANCE, UpdateTriaInsuranceCommand);
			registerCommand(ACCEPT_QUOTE, AcceptQuoteCommand);
			registerCommand(DISPLAY_QUOTE, DisplayQuoteCommand);
			registerCommand(OFFLINE_QUOTE, OfflineQuoteCommand);
			registerCommand(SEND_TO_BROKER, SendToBrokerCommand);
			registerCommand(DECLINE_RISK, DeclineRiskCommand);
			registerCommand(CREATE_CLAUSE, CreateClauseCommand);
			registerCommand(LOOKUP_POSTCODE, PostcodeLookupCommand);
			registerCommand(LOAD_EMAIL_TEMPLATE, LoadEmailTemplateCommand);
			registerCommand(FETCH_POSTCODE, PostcodeFetchCommand);
			registerCommand(SEARCH, SearchCommand);
			registerCommand(EMAIL_DOCS, EmailDocsCommand);
			registerCommand(CREATE_BASIC_DOCUMENTS, CreateBasicDocumentsCommand);
			registerCommand(CANCEL_POLICY, CancelPolicyCommand);
			registerCommand(REQUEST_MTA, RequestMTACommand);
			registerCommand(REINSTATE_RISK, ReinstateRiskCommand);
			registerCommand(SAVE_BROKER_OFFICE, SaveBrokerOfficeCommand);
			registerCommand(SAVE_BROKER_CONTACT, SaveBrokerContactCommand);
			registerCommand(SAVE_UNDERWRITER, SaveUnderwriterCommand);
			registerCommand(RESET_PASSWORD, ResetPasswordCommand);
			registerCommand(CHANGE_PASSWORD, ChangePasswordCommand);
			registerCommand(CONTACT_US_QUERY, ContactUsQueryCommand);
			registerCommand(FORCE_RENEWAL, ForceRenewalCommand);
			registerCommand(UPDATE_CLAUSE_ARCHIVE_STATUS, UpdateClauseArchiveStatusCommand);
			registerCommand(SAVE_SOURCE_ASSOCIATION, SaveSourceAssociationCommand);
			registerCommand(UPDATE_LIMITS_AND_DEDCTIBLES, UpdateLimitsAndDeductiablesCommand);
			registerCommand(CREATE_BROKER_OFFICE, CreateBrokerOfficeCommand);
			registerCommand(LOAD_EARLIEST_ENDORSEMENT_DATE, LoadEarliestEndorsementDateCommand);
			registerCommand(DETERMINE_MTA_ACTIONS, DetermineMtaActionsCommand);
			registerCommand(DETERMINE_LATEST_END_DATE, DetermineLatestEndDateCommand);
			registerCommand(FIND_SUPERSEDING_RISK, FindSupersedingRiskCommand);
			registerCommand(CREATE_COVER_PERIOD_MTA_QUOTE, ChangeCoverPeriodCommand);
			registerCommand(FRAME_RESEND, ResendToFrameCommand);
			registerCommand(SAVE_OR_UPDATE_USEFUL_LINK, SaveOrUpdateUsefulLinkCommand);
			registerCommand(PREP_USEFUL_LINKS, PrepUsefulLinkCommand);
			registerCommand(SAVE_BROKER_OFFICE_USEFUL_LINKS, SaveBrokerOfficeUsefulLinksCommand);
			registerCommand(GENERATE_RISKS_REPORT, GenerateRisksReportCommand);
			registerCommand(RISK_DOCUMENT_MODIFIED_ALERT, RiskDocumentModifiedCommand);
			registerCommand(UPDATE_INSURED, UpdateInsuredDetailsCommand);
		}
		
		public function configureStyle(lookAndFeel:LookAndFeel):void {
			var style:CSSStyleDeclaration=getOrCreateStyleDeclaration("Application");
			style.setStyle("backgroundGradientColors", [lookAndFeel.backgroundColour, lookAndFeel.backgroundColour]);
			style.setStyle("backgroundColor", lookAndFeel.backgroundColour);
			
			style=getOrCreateStyleDeclaration("Accordion");
			style.setStyle("color", (lookAndFeel.invertMenuTextColour ? 0xFFFFFF : 0x000000));
			style.setStyle("backgroundColor", lookAndFeel.backgroundColour);
			
			style=getOrCreateStyleDeclaration("TitleWindow");
			style.setStyle("borderColor", lookAndFeel.menuColour);
			style.setStyle("backgroundColor", lookAndFeel.backgroundColour);
			
			style=getOrCreateStyleDeclaration("Alert");
			style.setStyle("borderColor", lookAndFeel.menuColour);
			style.setStyle("backgroundColor", lookAndFeel.backgroundColour);
			
			style=getOrCreateStyleDeclaration(".alertTitle");
			style.setStyle("color", (lookAndFeel.invertMenuTextColour ? 0xFFFFFF : 0x000000));
			
			style=getOrCreateStyleDeclaration("TabNavigator");
			style.setStyle("backgroundColor", lookAndFeel.backgroundColour);
			
			style=getOrCreateStyleDeclaration("MultistepNavigator");
			style.setStyle("completeLineColor", lookAndFeel.keyColour);
			
			style=getOrCreateStyleDeclaration("DataGrid");
			style.setStyle("rollOverColor", lookAndFeel.rolloverColour);
			style.setStyle("textRollOverColor", (lookAndFeel.invertRolloverTextColour ? 0xFFFFFF : 0x000000));
			style.setStyle("selectionColor", lookAndFeel.selectionColor);
			style.setStyle("textSelectedColor", (lookAndFeel.invertSelectionTextColour ? 0xFFFFFF : 0x000000));
			style.setStyle("alternatingItemColors", [lookAndFeel.backgroundColour, lookAndFeel.backgroundColour]);
			
			style=getOrCreateStyleDeclaration("List");
			style.setStyle("rollOverColor", lookAndFeel.rolloverColour);
			style.setStyle("textRollOverColor", (lookAndFeel.invertRolloverTextColour ? 0xFFFFFF : 0x000000));
			style.setStyle("selectionColor", lookAndFeel.selectionColor);
			style.setStyle("textSelectedColor", (lookAndFeel.invertSelectionTextColour ? 0xFFFFFF : 0x000000));
			style.setStyle("backgroundColor", lookAndFeel.backgroundColour);

			style=getOrCreateStyleDeclaration("ListData");
			style.setStyle("rollOverColor", lookAndFeel.rolloverColour);
			style.setStyle("textRollOverColor", (lookAndFeel.invertRolloverTextColour ? 0xFFFFFF : 0x000000));
			style.setStyle("selectionColor", lookAndFeel.selectionColor);
			style.setStyle("textSelectedColor", (lookAndFeel.invertSelectionTextColour ? 0xFFFFFF : 0x000000));
			style.setStyle("backgroundColor", lookAndFeel.backgroundColour);

			style=getOrCreateStyleDeclaration(".insuredBox");
			style.setStyle("borderColor", lookAndFeel.backgroundColour);
			
			style=getOrCreateStyleDeclaration(".comboBoxDropdown");
			style.setStyle("rollOverColor", lookAndFeel.rolloverColour);
			style.setStyle("textRollOverColor", (lookAndFeel.invertRolloverTextColour ? 0xFFFFFF : 0x000000));
			style.setStyle("selectionColor", lookAndFeel.selectionColor);
			style.setStyle("textSelectedColor", (lookAndFeel.invertSelectionTextColour ? 0xFFFFFF : 0x000000));
			
			style=getOrCreateStyleDeclaration(".accordionHeader");
			style.setStyle("fillColors", [lookAndFeel.menuColour, lookAndFeel.menuColour]);
			style.setStyle("borderColor", lookAndFeel.menuColour);
			style.setStyle("themeColor", lookAndFeel.menuColour);
			
			style=getOrCreateStyleDeclaration(".newQuote");
			style.setStyle("themeColor", lookAndFeel.menuColour);
			style.setStyle("fillColors", [0xCCCCCC, 0xFFFFFF, lookAndFeel.menuColour, lookAndFeel.menuColour]);
			style.setStyle("textRollOverColor", (lookAndFeel.invertMenuTextColour ? 0xFFFFFF : 0x000000));
			style.setStyle("textSelectedColor", (lookAndFeel.invertMenuTextColour ? 0xFFFFFF : 0x000000));
			
			style=getOrCreateStyleDeclaration(".red");
			style.setStyle("borderColor", lookAndFeel.keyColour);
			style.setStyle("fillColors", [lookAndFeel.keyColour, lookAndFeel.keyColour, lookAndFeel.keyColour, 0xE3DADA]);
			style.setStyle("themeColor", lookAndFeel.keyColour);
			style.setStyle("color", (lookAndFeel.invertKeyTextColour ? 0xFFFFFF : 0x000000));
			style.setStyle("textRollOverColor", (lookAndFeel.invertKeyTextColour ? 0xFFFFFF : 0x000000));
			style.setStyle("textSelectedColor", (lookAndFeel.invertKeyTextColour ? 0xFFFFFF : 0x000000));
			
			style=getOrCreateStyleDeclaration(".ContentArea");
			style.setStyle("backgroundColor", lookAndFeel.secondaryColour);
			
			style=getOrCreateStyleDeclaration(".contentPanel");
			style.setStyle("backgroundColor", lookAndFeel.backgroundColour);
			
			style=getOrCreateStyleDeclaration(".heading1");
			style.setStyle("color",  (lookAndFeel.headingColour != lookAndFeel.secondaryColour ? lookAndFeel.headingColour : 0x000000));
			
			style=getOrCreateStyleDeclaration(".menuButton");
			style.setStyle("themeColor", lookAndFeel.keyColour);
		}
		
		public function getStyleProperty(selector:String, property:String):uint {
			return StyleManager.getStyleDeclaration(selector).getStyle(property);
		}
		
		private function getOrCreateStyleDeclaration(selector:String):CSSStyleDeclaration {
			var style:CSSStyleDeclaration=StyleManager.getStyleDeclaration(selector);
			if (style == null) {
				style=new CSSStyleDeclaration();
				StyleManager.setStyleDeclaration(selector, style, true);
			}
			return style;
		}
		
		public static function openPopUpWindow(componentClass:Class, mediatorClass:Class):Mediator {
			var window:IFlexDisplayObject=PopUpManager.createPopUp(Application.application as Sprite, componentClass, true);
			return registerMediatorAndCenterPopUp(window, mediatorClass);
		}
		
		public static function addPopUpWindowAndRegisterMediator(window:IFlexDisplayObject, mediator:IMediator):void {
			PopUpManager.addPopUp(window, Application.application as Sprite, true);
			ApplicationFacade.getInstance().registerMediator(mediator);
			PopUpManager.centerPopUp(window);
		}
		
		public static function addPopUpWindow(window:IFlexDisplayObject, mediatorClass:Class):Mediator {
			PopUpManager.addPopUp(window, Application.application as Sprite, true);
			return registerMediatorAndCenterPopUp(window, mediatorClass);
		}
		
		private static function registerMediatorAndCenterPopUp(window:IFlexDisplayObject, mediatorClass:Class):Mediator {
			var m:Mediator=new mediatorClass(window);
			ApplicationFacade.getInstance().registerMediator(m);
			PopUpManager.centerPopUp(window);
			return m;
		}
		
		public static function closePopUpWindow(window:IFlexDisplayObject, mediatorName:String):void {
			PopUpManager.removePopUp(window);
			ApplicationFacade.getInstance().removeMediator(mediatorName);
		}
		
		public function preInit():void {
			sendNotification(LOAD_CURRENT_USER);
		}
		
		public function startup(app:CargoFlex):void {
			
			// If both object were populated before this method, the change watcherers wont detect the change (so might not be required).  
			if (localeFormat != null && userInfo != null && !startupCommandIssued) {
				startupCommandIssued=true;
				sendNotification(ApplicationFacade.STARTUP, app);
			} else {

				var w:ChangeWatcher = ChangeWatcher.watch(this, "localeFormat", null);
				w.setHandler(function(event:*):void {
					if (userInfo != null && !startupCommandIssued) {
						startupCommandIssued = true;
						sendNotification(ApplicationFacade.STARTUP, app);
					}
				});

				var w2:ChangeWatcher = ChangeWatcher.watch(this, "userInfo", null);
				w2.setHandler(function(event:*):void {
					if (localeFormat != null && !startupCommandIssued) {
						startupCommandIssued = true;
						sendNotification(ApplicationFacade.STARTUP, app);
					}
				});
			}
			//sendNotification(ApplicationFacade.PREPARE);
		}


		public function logout():void {
			sendNotification(ApplicationFacade.LOGOUT);
		}
		
		// for riatest waitfor
		public function setQuoting(value:Boolean):void {
			if (value && quotingBodgit == null) {
				quotingBodgit=new Text();
				quotingBodgit.text="Risk Quoting";
				quotingBodgit.width=0;
				quotingBodgit.height=0;
				quotingBodgit.includeInLayout=false;
				Application.application.addChild(quotingBodgit);
			} else if (quotingBodgit != null) {
				Application.application.removeChild(quotingBodgit);
				quotingBodgit=null;
			}
		}
		
		override public function sendNotification(notificationName:String, body:Object=null, type:String=null):void {
			trace('Sent ' + notificationName);
			notifyObservers(new Notification(notificationName, body, type));
		}
		
		// ==================================================================================== //
		// Localization @See LoadCurrentUserInfoCommand + PrepareApplicationCommand approaches. //
		// ==================================================================================== //
		
		// This can be part of the copilling options instead.
		[Bindable]
		public static var compiledLocales:Array=[
			CargoLocaleConstants.COUNTRY_LOCALE_GB, 
			CargoLocaleConstants.COUNTRY_LOCALE_US, 
			CargoLocaleConstants.COUNTRY_LOCALE_HK, 
			CargoLocaleConstants.COUNTRY_LOCALE_SG];
		
		[Bindable]
		private static var localesChainMap:Dictionary= CargoLocaleConstants.localesChainMap;
		
		/**
		 * The session locale drives the application logic of the app and is obtained from the broker originating office.
		 * The current locale drives the application labels only.
		 */
		// TO UPDATE: This locale is taken from the userInfo.originatingOffice.locale during the initializeLocalization().
		private var _currentLocale:String = null;
		private var _defaultLocale:String = ApplicationFacade.compiledLocales[0]; 
		private var _sessionLocale:String = "";
		
		public function get currentLocale():String {
			if (_currentLocale == null)
				_currentLocale=_defaultLocale;
			
			return _currentLocale;
		}
		
		public function set currentLocale(value:String):void {
			this._currentLocale=value;
			sendNotification(ApplicationFacade.LOCALE_CHANGED, this._currentLocale);
		}
		
		public function initializeLocalization():void {
			initializeLocalesChain();
		}
		
		private function initializeLocalesChain():void {
			if (localesChainMap[currentLocale])
				ResourceManager.getInstance().localeChain=localesChainMap[currentLocale];
			else
				ResourceManager.getInstance().localeChain=localesChainMap[_defaultLocale];
		}
		
		public function set sessionLocale(locale:String):void {
			_sessionLocale = locale;
		}
		
		public function get sessionLocale():String {
			if (!_sessionLocale)
				_sessionLocale = _defaultLocale
			return _sessionLocale; 
		}
		
		public function get sessionLocaleIsoCode():String {
			return sessionLocale.split("_")[1];
		}
		
		public function get sessionOriginatingOfficeCode():OriginatingOfficeCode {
			return userInfo.originatingOffice.code;
		}
		
		/**
		 *	Returns the system currency.
		 *  This currency should be used to populate currency exchange rates.
		 */
		/*		
		public function get defaultBaseExchangeSystemCurrency():String {
			var ret:String = CargoCurrencyConstants.POUND_STERLING;
			var originatingOffice:OriginatingOfficeCode = OriginatingOfficeCode.UK;
			
			if (userInfo) {
				if (userInfo.isUnderwriter || userInfo.isSupport) {
					originatingOffice = userInfo.originatingOffice.code;
				} else {
					if (userInfo.brokerOffice != null && userInfo.brokerOffice.originatingOfficeCode != null) {
						originatingOffice = userInfo.brokerOffice.originatingOfficeCode;
					}
				}
			}

			switch (originatingOffice) {
				case OriginatingOfficeCode.US:
					ret = CargoCurrencyConstants.US_DOLLAR;
					break;
				default:
					ret = CargoCurrencyConstants.POUND_STERLING;
					break;
			}

			return ret;
		}*/
		
		
		public function get defaultSystemCurrency():String {
			var ret:String = "";
			
			if (userInfo) {
				if (userInfo.isUnderwriter || userInfo.isSupport) {
					switch (userInfo.originatingOffice.code) {
						case OriginatingOfficeCode.US:
							ret = CargoCurrencyConstants.US_DOLLAR;
							break;
						case OriginatingOfficeCode.UK:
							ret = CargoCurrencyConstants.POUND_STERLING;
							break;
						default:
							ret = CargoCurrencyConstants.US_DOLLAR;
							break;
					}
				} else {
					ret = (userInfo.brokerOffice ? userInfo.brokerOffice.defaultCurrency : "");
				}
			}
			
			return ret;
		}
	}
}
