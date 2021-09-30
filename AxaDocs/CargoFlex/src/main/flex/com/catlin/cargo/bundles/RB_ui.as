package com.catlin.cargo.bundles {
	import com.catlin.cargo.view.address.InsuredWindowAmendProvinceMediator;
	
	import mx.formatters.DateFormatter;
	import mx.resources.IResourceManager;
	import mx.resources.ResourceManager;

	/**
	 *
	 * Reference class that will contain, mainly, a set of String constant which value is the key
	 * for the resources.properties file, in this case,  resources_ui.properties.
	 *
	 */

	[Bindable]
	public class RB_ui {

		public function RB_ui() {
		}

		public static const RB_NAME:String='resources_ui';

		// QUOTE AND POLICIES
		public static const QUOTE_AND_POLICIES_TITLE:String='quote_and_policies.title';

		// ADMINISTRATION
		public static const ADMINISTRATION_TITLE:String='administration.title';

		// MY PROFILE
		public static const PROFILE_TITLE:String='profile.title';


		// GENERAL
		public static const LOGOUT:String='general.logout';
		public static const TERMS_OF_USE:String='general.terms';
		public static const TERMS_OF_USE_SOURCE:String='general.terms.source';
		public static const CATLIN_LIMITED:String='general.companyinfo';
		public static const SEPARATOR_PIPE:String='general.pipe_separator';
		public static const USERNAME:String='general.username';
		public static const ACCEPT:String='general.accept';
		public static const DECLINE:String='general.decline';
		public static const OK:String='general.ok';
		public static const CANCEL:String='general.cancel';
		public static const CONFIRM:String='general.confirm';
		public static const ADD:String='general.add';
		public static const SEND:String='general.send';
		public static const CARGO_WEB_URL:String='general.cargo.url';
		public static const SAVE:String='general.button.save';
		public static const MANDATORY_FIELDS:String='general.mandatoryfields';
		public static const YES:String='general.yes';
		public static const NO:String='general.no';
		public static const OTHER:String='general.other';
		public static const PROCEED:String='general.proceed';
		public static const PROCEED_CONFIRMATION:String='general.proceed_confirmation';
		public static const WARNING:String='general.warning';
		public static const SEARCH:String='general.search';
		public static const CONFIRMATION:String='general.confirmation';
		public static function POSTAL_CODE(isoLocale:String = "GB"):String {
			if (isoLocale == CargoLocaleConstants.COUNTRY_ISO_US) 
				return 'general.zipcode'; 
			else
				return 'general.postcode';
		};
		
		// ERROR & ALERTS
		// BaseCommand.as
		public static const ACCESS_DENIED_TITLE:String='access_denied.title';
		public static const ACCESS_DENIED_MESSAGE:String='access_denied.message';

		// ChangePasswordCommand.as
		public static const CHANGE_PASSWORD_SUCCESS_TITLE:String='change_password.success.title';
		public static const CHANGE_PASSWORD_SUCCESS_MESSAGE:String='change_password.success.message';
		public static const CHANGE_PASSWORD_ERROR_INCORRECTPASSWORD_TITLE:String='change_password.error.incorrectpassword.title';
		public static const CHANGE_PASSWORD_ERROR_INCORRECTPASSWORD_MESSAGE:String='change_password.error.incorrectpassword.message';
		public static const CHANGE_PASSWORD_ERROR_WEAKPASSWORD_TITLE:String='change_password.error.weakpassword.title';
		public static const CHANGE_PASSWORD_ERROR_WEAKPASSWORD_MESSAGE:String='change_password.error.weakpassword.message';

		// ForceRenewalCommand.as
		public static const FORCE_RENEWAL_SUCCESS_TITLE:String="force_renewal.success.title";
		public static const FORCE_RENEWAL_SUCCESS_MESSAGE:String="force_renewal.success.message";

		// PostcodeFetchCommand.as
		public static const POSTCODEFETCH_ERROR_NOADDRESSFOUND_MESSAGE:String="postcode_fetch.error.noaddressfound.message";
		public static const POSTCODEFETCH_ERROR_NOADDRESSFOUND_TITLE:String="postcode_fetch.error.noaddressfound.title";

		// PostcodeLookupCommand.as		
		public static const POSTCODELOOKUP_ERROR_NOADDRESSFOUND_MESSAGE:String="postcode_lookup.error.noaddressfound.message";
		public static const POSTCODELOOKUP_ERROR_NOADDRESSFOUND_TITLE:String="postcode_lookup.error.noaddressfound.title";

		public static const POSTCODELOOKUP_ERROR_RESPONSE_TITLE:String="postcode_lookup.error.response.title";
		public static const POSTCODELOOKUP_ERROR_RESPONSE_ERROR1005:String="postcode_lookup.error.response.error1005";
		public static const POSTCODELOOKUP_ERROR_RESPONSE_GENERAL:String="postcode_lookup.error.response.general";		
		
		// RequestMTACommand.as
		public static const REQUEST_MTA_SUCCESS_MESSAGE:String="request_mta.success.message";
		public static const REQUEST_MTA_SUCCESS_TITLE:String="request_mta.success.title.title";

		// ResendToFrameCommand.as
		public static const RESEND_TO_FRAME_SUCCESS_MESSAGE:String="resend_to_frame.success.message";
		public static const RESEND_TO_FRAME_SUCCESS_TITLE:String="resend_to_frame.success.title";

		// ResetPasswordCommand.as
		public static const RESET_PASSWORD_SUCCESS_MESSAGE:String="reset_password.success.message";
		public static const RESET_PASSWORD_SUCCESS_TITLE:String="reset_password.success.title";

		// SaveBrokerContactCommand.as
		public static const SAVE_BROKER_CONTACT_SUCCESS_MESSAGE:String="save_broker_contact.success.message";
		public static const SAVE_BROKER_CONTACT_SUCCESS_TITLE:String="save_broker_contact.success.title";

		// SaveBrokerOfficeCommand.as
		public static const SAVE_BROKER_OFFICE_ERROR_DUPLICATE_MESSAGE:String="save_broker_office.error.duplicate.message";
		public static const SAVE_BROKER_OFFICE_ERROR_DUPLICATE_TITLE:String="save_broker_office.error.duplicate.title";

		// SaveUnderwriterCommand.as
		public static const SAVE_UNDERWRITER_SUCCESS_MESSAGE:String="save_underwriter.success.message";
		public static const SAVE_UNDERWRITER_SUCCESS_TITLE:String="save_underwriter.success.title";

		// SearchCommand.as
		public static const SEARCH_COMMAND_SUCCESS_MESSAGE:String="search.success.message";
		public static const SEARCH_COMMAND_SUCCESS_TITLE:String="search.success.title";

		public static const RISK_DOCUMENT_MODIFIED_COMMAND_MESSAGE:String="risk_document_modified_command.message";
		public static const RISK_DOCUMENT_MODIFIED_COMMAND_TITLE:String="risk_document_modified_command.title";
		
		// BaseProxy.as
		public static const BASEPROXY_ERROR_SESSIONEXPIRED_MESSAGE:String="base_proxy.error.sessionexpired.message";
		public static const BASEPROXY_ERROR_SESSIONEXPIRED_TITLE:String="base_proxy.error.sessionexpired.title";

		public static const BASEPROXY_ERROR_ACCESSDENIED_MESSAGE:String="base_proxy.error.accessdenied.message";
		public static const BASEPROXY_ERROR_ACCESSDENIED_TITLE:String="base_proxy.error.accessdenied.title";

		// AddressMediator.as
		public static const ADDRESS_MEDIATOR_VALIDATION_REQUIRED_ADDRESS:String="address_mediator.validation.required.address";
		public static const ADDRESS_MEDIATOR_VALIDATION_REQUIRED_CITY:String="address_mediator.validation.required.city";
		public static const ADDRESS_MEDIATOR_VALIDATION_REQUIRED_PROVINCE:String="address_mediator.validation.required.province";
		public static const ADDRESS_MEDIATOR_VALIDATION_REQUIRED_POSTCODE:String="address_mediator.validation.required.postcode";

		// InsuredWindowAmendProvinceMediator.as
		public static const INSURED_WINDOW_AMEND_PROVINCE_TITLE:String="insured_window_amend_province_mediator.title";
		
		// AddressValidationImpl.as
		/*		public static const ADDRESS_VALIDATION_REQUIRED_ADDRESS:String = "address_validation.required.address";
				public static const ADDRESS_VALIDATION_REQUIRED_CITY:String = "address_validation.required.city";
				public static const ADDRESS_VALIDATION_REQUIRED_POSTCODE:String = "address_validation.required.postcode";	*/

		// AddressWindow.as
		public static const ADDRESS_WINDOW_LOOKUPADDRESS:String="address_window.lookupaddress";
		public static const ADDRESS_WINDOW_ADDRESSLINE:String="address_window.addressline";
		public static const ADDRESS_WINDOW_CITY:String="address_window.city";
		public static const ADDRESS_WINDOW_COUNTY:String="address_window.county";
		public static const ADDRESS_WINDOW_PROVINCE:String="address_window.province";

		// AddressWindow.mxml
		public static const INSURED_WINDOW_TITLE:String="insured_window.title";
		public static const INSURED_WINDOW_INSUREDNAME:String="insured_window.insuredname";
		public static const INSURED_WINDOW_POSTCODE:String="insured_window.postcode";
		public static const INSURED_WINDOW_LOOKUPADDRESS:String="insured_window.lookupaddress";
		public static const INSURED_WINDOW_ADDRESSLINE:String="insured_window.addressline";
		public static const INSURED_WINDOW_CITY:String="insured_window.city";
		public static const INSURED_WINDOW_COUNTY:String="insured_window.county";
		public static const INSURED_WINDOW_PROVINCE:String="insured_window.province";
		public static const INSURED_WINDOW_COUNTRY:String="insured_window.country";
		
		// InsuredWindowMediator.as
		public static const INSURED_WINDOW_MEDIATOR_VALIDATION_REQUIRED_NAME:String="insured_window_mediator.validation.required.name";
		
		// PostcodeLookupForm.mxml
		public static const POSTCODE_LOOKUP_FORM_TITLE:String="postcode_lookup_form.title";
		public static const POSTCODE_LOOKUP_FORM_CHOOSEADDRESS:String="postcode_lookup_form.chooseAddress";		
		
		// PostcodeValidator.as
		public static const POSTCODE_VALIDATOR_FORMAT_MESSAGE:String="postcode_validator_format_message";

		// BrokerContactsValidationImpl.mxml
		public static const BROKER_CONTACT_VALIDATION_REQUIRED_NAME:String="broker_contact.validation.required.name";
		public static const BROKER_CONTACT_VALIDATION_REQUIRED_USERNAME:String="broker_contact.validation.required.username";
		public static const BROKER_CONTACT_VALIDATION_REQUIRED_EMAIL:String="broker_contact.validation.required.email";
		public static const BROKER_CONTACT_VALIDATION_INVALID_EMAIL:String="broker_contact.validation.invalid.email";
		public static const BROKER_CONTACT_VALIDATION_REQUIRED_PHONE:String="broker_contact.validation.required.phone";		
		
		// BrokerContactsVBox.mxml
		public static const BROKER_CONTACTS_TITLE:String="broker_contacts.title";
		public static const BROKER_CONTACTS_SHOW_ARCHIVED_CONTACTS:String="broker_contacts.show_archived_contacts";
		public static const BROKER_CONTACTS_GRID_HEADER_NAME:String="broker_contacts.grid.header.name";
		public static const BROKER_CONTACTS_GRID_HEADER_EMAIL:String="broker_contacts.grid.header.email";
		public static const BROKER_CONTACTS_GRID_HEADER_USERNAME:String="broker_contacts.grid.header.username";
		public static const BROKER_CONTACTS_GRID_HEADER_ENABLED:String="broker_contacts.grid.header.enabled";
		public static const BROKER_CONTACTS_CREATE_CONTACT:String="broker_contacts.create.contact";
		public static const BROKER_CONTACTS_DETAILS_TITLE:String="broker_contacts.details.title";
		public static const BROKER_CONTACTS_DETAILS_NAME:String="broker_contacts.details.name";
		public static const BROKER_CONTACTS_DETAILS_ADDRESSEE:String="broker_contacts.details.addressee";
		public static const BROKER_CONTACTS_DETAILS_EMAIL:String="broker_contacts.details.email";
		public static const BROKER_CONTACTS_DETAILS_PHONE:String="broker_contacts.details.phone";
		public static const BROKER_CONTACTS_DETAILS_DISABLE:String="broker_contacts.details.disable";
		public static const BROKER_CONTACTS_DETAILS_ACHIVED:String="broker_contacts.details.achived";
		public static const BROKER_CONTACTS_DETAILS_USERNAME:String="broker_contacts.details.username";
		public static const BROKER_CONTACTS_RESETPASSWORD:String="broker_contacts.resetpassword";

		// BrokerLinksVBox.mxml
		public static const BROKER_LINK_TITLE:String="broker_link.title";
		public static const BROKER_LINK_SHOW_ARCHIVED_CONTACTS:String="broker_link.show_archived_links";
		public static const BROKER_LINK_CREATE_LINK:String="broker_link.create.contact";
		public static const BROKER_LINK_DETAILS_TITLE:String="broker_link.details.title";
		public static const BROKER_LINK_DETAILS_NAME:String="broker_link.details.name";
		public static const BROKER_LINK_DETAILS_URL:String="broker_link.details.url";
		public static const BROKER_LINK_DETAILS_DESCRIPTION:String="broker_link.details.description";
		public static const BROKER_LINK_DETAILS_ACHIVED:String="broker_link.details.achived";
		public static const BROKER_LINK_ARCHIEVE:String="broker_link.archieve";		
		
		
		// BrokerLinksVBoxValidationImpl.mxml
		public static const BROKER_LINK_VALIDATION_REQUIRED_NAME:String="broker_link.validation.required.name";
		public static const BROKER_LINK_VALIDATION_REQUIRED_DESCRIPTION:String="broker_link.validation.required.description";
		public static const BROKER_LINK_VALIDATION_REQUIRED_URL:String="broker_link.validation.required.url";
		public static const BROKER_LINK_VALIDATION_INVALID_URL:String="broker_link.validation.invalid.url";
		
		
		// BrokerHistoryForm.mxml
		public static const BROKER_HISTORY_FORM_GRID_DATE:String="broker_history_form.grid.date";
		public static const BROKER_HISTORY_FORM_GRID_USER:String="broker_history_form.grid.user";
		public static const BROKER_HISTORY_FORM_GRID_COMMENTS:String="broker_history_form.grid.comments";
		
		
		// BrokerOfficeDetailValidationImpl.mxml
		public static const BROKER_OFFICE_DETAIL_VALIDATION_REQUIRED_EXTERNAL_BROKER_ID:String="broker_office_detail_validation.required.external_broker_id";
		public static const BROKER_OFFICE_DETAIL_VALIDATION_REQUIRED_BROKER_OFFICE:String="broker_office_detail_validation.required.broker_office";
		public static const BROKER_OFFICE_DETAIL_VALIDATION_REQUIRED_BROKER_CODE:String="broker_office_detail_validation.required.broker_code";			
		public static const BROKER_OFFICE_DETAIL_VALIDATION_REQUIRED_UNDERWRITER:String="broker_office_detail_validation.required.underwriter";
		public static const BROKER_OFFICE_DETAIL_VALIDATION_REQUIRED_ORIGINATING_OFFICE:String="broker_office_detail_validation.required.originating_office";
		public static const BROKER_OFFICE_DETAIL_VALIDATION_REQUIRED_DEFAULT_CURRENCY:String="broker_office_detail_validation.required.default_currency";
		public static const BROKER_OFFICE_DETAIL_VALIDATION_REQUIRED_COUNTRY_OF_RISK:String="broker_office_detail_validation.required.country_of_risk";
		public static const BROKER_OFFICE_DETAIL_VALIDATION_REQUIRED_DEFAULT_MAD_PERCENTAGE:String="broker_office_detail_validation.required.default_mad_percentage";
		public static const BROKER_OFFICE_DETAIL_VALIDATION_REQUIRED_PREMIUM_MINIMUN_LIMIT_ANNUAL:String="broker_office_detail_validation.required.premium_minimun_limit_annual";
		public static const BROKER_OFFICE_DETAIL_VALIDATION_REQUIRED_PREMIUM_MINIMUN_LIMIT_SINGLE_TRIP:String="broker_office_detail_validation.required.premium_minimun_limit_single_trip";
		public static const BROKER_OFFICE_DETAIL_VALIDATION_REQUIRED_PREMIUM_MINIMUN_ANUAL_COVER:String="broker_office_detail_validation.required.premium_minimun_anual_cover";
		public static const BROKER_OFFICE_DETAIL_VALIDATION_REQUIRED_PREMIUM_MINIMUN_SINGLE_TRIP:String="broker_office_detail_validation.required.premium_minimun_single_trip";
		public static const BROKER_OFFICE_DETAIL_VALIDATION_REQUIRED_MINIMUM_NET_AP_FOR_MTA:String="broker_office_detail_validation.required.minimum_net_ap_for_mta";
		public static const BROKER_OFFICE_DETAIL_VALIDATION_REQUIRED_DAYS_TO_SETTLE:String="broker_office_detail_validation.required.days_to_settle";
		public static const BROKER_OFFICE_DETAIL_VALIDATION_REQUIRED_PCT_DEFAULT_COMMISSION:String="broker_office_detail_validation.required.pct_default_commission";
		public static const BROKER_OFFICE_DETAIL_VALIDATION_REQUIRED_PCT_DISCOUNT_CAP:String="broker_office_detail_validation.required.pct_discount_cap";
		public static const BROKER_OFFICE_DETAIL_VALIDATION_REQUIRED_NUM_LOADING:String="broker_office_detail_validation.required.num_loading";		
		
		// BrokerOfficeDetailVBox.mxml
		
		public static const BROKER_OFFICE_DETAIL_VIEW_DETAILS:String="broker_office_detail_view.details";
		public static const BROKER_OFFICE_DETAIL_VIEW_SOURCE_SYSTEM:String="broker_office_detail_view.source_system";
		public static const BROKER_OFFICE_DETAIL_VIEW_COUNTRY_OF_RISK:String="broker_office_detail_view.country_of_risk";
		public static const BROKER_OFFICE_DETAIL_VIEW_COUNTRY_OF_RISK_DEFAULT:String="broker_office_detail_view.country_of_risk_default";
		public static const BROKER_OFFICE_DETAIL_VIEW_BROKER_OFFICE:String="broker_office_detail_view.broker_office";
		public static const BROKER_OFFICE_DETAIL_VIEW_BROKER_CODE:String="broker_office_detail_view.broker_code";
		public static const BROKER_OFFICE_DETAIL_VIEW_MASTER_OFFICE:String="broker_office_detail_view.master_office";
		public static const BROKER_OFFICE_DETAIL_VIEW_EXTERNAL_BROKER_ID:String="broker_office_detail_view.external_broker_id";
		public static const BROKER_OFFICE_DETAIL_VIEW_UNDERWRITER:String="broker_office_detail_view.underwriter";
		public static const BROKER_OFFICE_DETAIL_VIEW_ORIGINATING_OFFICE:String="broker_office_detail_view.originating_office";
		//public static const BROKER_OFFICE_DETAIL_VIEW_POSTCODE:String="broker_office_detail_view.postcode";
		public static const BROKER_OFFICE_DETAIL_VIEW_POSTCODE_LOOKUP:String="broker_office_detail_view.postcode.lookup";
		public static const BROKER_OFFICE_DETAIL_VIEW_POSTCODE_ADDRESSLINE:String="broker_office_detail_view.postcode.addressline";
		public static const BROKER_OFFICE_DETAIL_VIEW_TOWN:String="broker_office_detail_view.town";
		public static const BROKER_OFFICE_DETAIL_VIEW_COUNTY:String="broker_office_detail_view.county";
		public static const BROKER_OFFICE_DETAIL_VIEW_RESCINDED:String="broker_office_detail_view.rescinded";
		public static const BROKER_OFFICE_DETAIL_VIEW_SHOW_CONTACTUS_DETAILS:String="broker_office_detail_view.show_contactus_details";
		public static const BROKER_OFFICE_DETAIL_VIEW_FINANCIAL_CONTROLS:String="broker_office_detail_view.financial_controls";
		public static const BROKER_OFFICE_DETAIL_VIEW_FINANCIAL_CONTROLS_PREMIUN:String="broker_office_detail_view.financial_controls.premiun";
		public static const BROKER_OFFICE_DETAIL_VIEW_FINANCIAL_CONTROLS_PREMIUN_FNA:String="broker_office_detail_view.financial_controls.premiun.fna";
		public static const BROKER_OFFICE_DETAIL_VIEW_FINANCIAL_CONTROLS_PREMIUN_MAD:String="broker_office_detail_view.financial_controls.premiun.mad";
		public static const BROKER_OFFICE_DETAIL_VIEW_FINANCIAL_CONTROLS_PREMIUN_BOTH:String="broker_office_detail_view.financial_controls.premiun.both";
		public static const BROKER_OFFICE_DETAIL_VIEW_DEFAULT_MAD_PERCENTAGE:String="broker_office_detail_view.default_mad_percentage";
		public static const BROKER_OFFICE_DETAIL_VIEW_CUR_PREMIUM_LIM_ANNUAL:String="broker_office_detail_view.cur_premium_lim_annual";
		public static const BROKER_OFFICE_DETAIL_VIEW_CUR_PREMIUM_LIM_SINGLE:String="broker_office_detail_view.cur_premium_lim_single";
		public static const BROKER_OFFICE_DETAIL_VIEW_CUR_PREMIUM_MIN_ANNUAL:String="broker_office_detail_view.cur_premium_min_annual";
		public static const BROKER_OFFICE_DETAIL_VIEW_CUR_PREMIUM_MIN_SINGLE:String="broker_office_detail_view.cur_premium_min_single";
		public static const BROKER_OFFICE_DETAIL_VIEW_CUR_PREMIUM_MIN_NET_AP_FOR_MTA:String="broker_office_detail_view.cur_premium_min_net_ap_for_mta";
		public static const BROKER_OFFICE_DETAIL_VIEW_DAYS_TO_SETTLE:String="broker_office_detail_view.days_to_settle";
		public static const BROKER_OFFICE_DETAIL_VIEW_PCT_DEFAULT_COMMISSION:String="broker_office_detail_view.pct_default_commission";
		public static const BROKER_OFFICE_DETAIL_VIEW_ADJUST_PREMIUN:String="broker_office_detail_view.adjust_premiun";
		public static const BROKER_OFFICE_DETAIL_VIEW_DISCOUNT_CAP:String="broker_office_detail_view.discount_cap";
		public static const BROKER_OFFICE_DETAIL_VIEW_NUM_LOADING:String="broker_office_detail_view.num_loading";
		public static const BROKER_OFFICE_DETAIL_VIEW_DEFAULT_CURRENCY:String="broker_office_detail_view.default_currency";
		public static const BROKER_OFFICE_DETAIL_VIEW_DEBIT_NOTE_AVAILABLE:String="broker_office_detail_view.debit_note_available";
		public static const BROKER_OFFICE_DETAIL_VIEW_DOMESTIC_TRANSIT_BOV:String="broker_office_detail_view.domestic_transit_bov";
		
		public static const BROKER_OFFICE_DETAIL_VIEW_WHITE_LABEL_GUIDE_TITLE:String="broker_office_detail_view.white_label_guide.title";
		public static const BROKER_OFFICE_DETAIL_VIEW_WHITE_LABEL_GUIDE_LINK_TOOLTIP:String="broker_office_detail_view.white_label_guide.link.tooltip";
		public static const BROKER_OFFICE_DETAIL_VIEW_WHITE_LABEL_GUIDE_LINK_LABEL:String="broker_office_detail_view.white_label_guide.link.label";
		public static const BROKER_OFFICE_DETAIL_VIEW_WHITE_LABEL_GUIDE_ENABLED:String="broker_office_detail_view.white_label_guide.enabled";
		public static const BROKER_OFFICE_DETAIL_VIEW_WHITE_LABEL_GUIDE_LOGO_URL:String="broker_office_detail_view.white_label_guide.logo_url";
		public static const BROKER_OFFICE_DETAIL_VIEW_WHITE_LABEL_GUIDE_BACKGROUND_COLOUR:String="broker_office_detail_view.white_label_guide.background_colour";
		public static const BROKER_OFFICE_DETAIL_VIEW_WHITE_LABEL_GUIDE_HEADING_COLOUR:String="broker_office_detail_view.white_label_guide.heading_colour";
		public static const BROKER_OFFICE_DETAIL_VIEW_WHITE_LABEL_GUIDE_KEY_COLOUR:String="broker_office_detail_view.white_label_guide.key_colour";
		public static const BROKER_OFFICE_DETAIL_VIEW_WHITE_LABEL_GUIDE_INVERT_KEY_TEXT:String="broker_office_detail_view.white_label_guide.invert_key_text";
		public static const BROKER_OFFICE_DETAIL_VIEW_WHITE_LABEL_GUIDE_SECONDARY_COLOUR:String="broker_office_detail_view.white_label_guide.secondary_colour";
		public static const BROKER_OFFICE_DETAIL_VIEW_WHITE_LABEL_GUIDE_MENU_COLOR:String="broker_office_detail_view.white_label_guide.menu_color";
		public static const BROKER_OFFICE_DETAIL_VIEW_WHITE_LABEL_GUIDE_SELECTION_COLOUR:String="broker_office_detail_view.white_label_guide.selection_colour";
		public static const BROKER_OFFICE_DETAIL_VIEW_WHITE_LABEL_GUIDE_ROLLOVER_COLOUR:String="broker_office_detail_view.white_label_guide.rollover_colour";
		public static const BROKER_OFFICE_DETAIL_VIEW_WHITE_LABEL_GUIDE_DATE_CREATED:String="broker_office_detail_view.white_label_guide.date_created";
		
		public static const BROKER_OFFICE_DETAIL_VIEW_UNAUTHORISED_CURRENCIES_TITLE:String="broker_office_detail_view.unauthorised_currencies.title";
		public static const BROKER_OFFICE_DETAIL_VIEW_AUTHORISED_CURRENCIES_TITLE:String="broker_office_detail_view.authorised_currencies.title";
		
		public static const BROKER_OFFICE_DETAIL_VIEW_MEDIATOR_SAVE_BROKER_OFFICE_TITLE:String="broker_office_detail_view_mediator.save_broker_office.title";
		public static const BROKER_OFFICE_DETAIL_VIEW_MEDIATOR_SAVE_BROKER_OFFICE_MESSAGE:String="broker_office_detail_view_mediator.save_broker_office.message";
		
		// UnderwriterDetailValidationImpl.mxml
		public static const UNDERWRITER_DETAIL_VALIDATOR_REQUIRED_NAME:String="underwriter_detail_validator.required.name";
		public static const UNDERWRITER_DETAIL_VALIDATOR_REQUIRED_USERNAME:String="underwriter_detail_validator.required.username";
		public static const UNDERWRITER_DETAIL_VALIDATOR_REQUIRED_TITLE:String="underwriter_detail_validator.required.title";
		public static const UNDERWRITER_DETAIL_VALIDATOR_REQUIRED_REGION:String="underwriter_detail_validator.required.region";
		public static const UNDERWRITER_DETAIL_VALIDATOR_REQUIRED_EMAIL:String="underwriter_detail_validator.required.email";
		public static const UNDERWRITER_DETAIL_VALIDATOR_INVALID_EMAIL:String="underwriter_detail_validator.invalid.email";
		public static const UNDERWRITER_DETAIL_VALIDATOR_REQUIRED_PHONE:String="underwriter_detail_validator.required.phone";
		public static const UNDERWRITER_DETAIL_VALIDATOR_REQUIRED_FAX:String="underwriter_detail_validator.required.fax";
		public static const UNDERWRITER_DETAIL_VALIDATOR_REQUIRED_PHONEDDI:String="underwriter_detail_validator.required.phoneddi";
		public static const UNDERWRITER_DETAIL_VALIDATOR_REQUIRED_MOBILE:String="underwriter_detail_validator.required.mobile";
		
		// UnderwriterDetail.mxml
		public static const UNDERWRITER_DETAIL_MAINTITLE:String="underwriter_detail.maintitle";
		public static const UNDERWRITER_DETAIL_NAME:String="underwriter_detail.name";
		public static const UNDERWRITER_DETAIL_TITLE:String="underwriter_detail.title";
		public static const UNDERWRITER_DETAIL_REGION:String="underwriter_detail.region";
		//public static const UNDERWRITER_DETAIL_POSTCODE:String="underwriter_detail.postcode";
		public static const UNDERWRITER_DETAIL_POSTCODE_LOOKUP:String="underwriter_detail.postcode.lookup";
		public static const UNDERWRITER_DETAIL_POSTCODE_ADDRESSLINE:String="underwriter_detail.postcode.addressline";
		public static const UNDERWRITER_DETAIL_CITY:String="underwriter_detail.city";
		public static const UNDERWRITER_DETAIL_COUNTY:String="underwriter_detail.county";
		public static const UNDERWRITER_DETAIL_PROVINCE:String=ADDRESS_WINDOW_PROVINCE;
		public static const UNDERWRITER_DETAIL_EMAIL:String="underwriter_detail.email";
		public static const UNDERWRITER_DETAIL_PHONE:String="underwriter_detail.phone";
		public static const UNDERWRITER_DETAIL_FAX:String="underwriter_detail.fax";
		public static const UNDERWRITER_DETAIL_PHONEDDI:String="underwriter_detail.phoneddi";
		public static const UNDERWRITER_DETAIL_MOBILE:String="underwriter_detail.mobile";
		public static const UNDERWRITER_DETAIL_ACCOUNT_DISABLED:String="underwriter_detail.account_disabled";
		public static const UNDERWRITER_DETAIL_USERNAME:String="underwriter_detail.username";
		public static const UNDERWRITER_DETAIL_RESETPASSWORD:String="underwriter_detail.resetpassword";		
		
		// AdministrationView.mxml
		public static const ADMINISTRATION_VIEW_BROKER_OFFICES:String="administration_view.broker_offices";
		public static const ADMINISTRATION_VIEW_BUTTON_CREATE_BROKER:String="administration_view.button.create_broker";
		public static const ADMINISTRATION_VIEW_UNDERWRITERS:String="administration_view.underwriters";
		public static const ADMINISTRATION_VIEW_BUTTON_CREATE_UNDERWRITER:String="administration_view.button.create_underwriter";
		public static const ADMINISTRATION_VIEW_TAB_TITLE_DETAIL:String="administration_view.tab.title.detail";
		public static const ADMINISTRATION_VIEW_TAB_TITLE_CONTACTS:String="administration_view.tab.title.contacts";
		public static const ADMINISTRATION_VIEW_TAB_TITLEHISTORY:String="administration_view.tab.titlehistory";
		
		// AdministrationMediator.as
		public static const ADMINISTRATION_MEDIATOR_NEW_BROKER_OFFICE:String="administration_mediator.new_broker_office";
		public static const ADMINISTRATION_MEDIATOR_NEW_UNDERWRITER:String="administration_mediator.new_underwriter";

		// ContactUs.mxml 
		public static const CONTACT_US_TITLE:String="contact_us.title";
		public static const CONTACT_US_BUSINESS_TITLE:String="contact_us.business.title";
		public static const CONTACT_US_BUSINESS_INTRO:String="contact_us.business.intro";
		public static const CONTACT_US_BUSINESS_DESCRIPTION:String="contact_us.business.description";
		public static const CONTACT_US_BUSINESS_TYPE_OF_QUERY:String="contact_us.business.type_of_query";
		public static const CONTACT_US_MASTEROFFICE_TITLE:String="contact_us.masteroffice.title";
		public static const CONTACT_US_MASTEROFFICE_INTRO:String="contact_us.masteroffice.intro";
		
		public static const CONTACT_US_UNDERWRITER_TITLE:String="contact_us.underwriter.title";
		public static const CONTACT_US_UNDERWRITER_INTRO:String="contact_us.underwriter.intro";

		public static const CONTACT_US_CONTACT_REGION:String="contact_us.contact.region";
		public static const CONTACT_US_CONTACT_DIRECT_DIAL:String="contact_us.contact.direct_dial";
		public static const CONTACT_US_CONTACT_EMAIL:String="contact_us.contact.email";
		public static const CONTACT_US_BUTTON_SUBMIT:String="contact_us.button.submit";
		public static const CONTACT_US_CONTACTS:String="contact_us.contacts";
		
		// ContactUsMediator.as
		public static const CONTACT_US_MEDIATOR_SUBMIT_REQUIRED_QUERY:String="contact_us.mediator.submit.required.query";
		public static const CONTACT_US_MEDIATOR_SUBMIT_REQUIRED_DESCRIPTION:String="contact_us.mediator.submit.required.description";
		public static const CONTACT_US_MEDIATOR_SUBMIT_MESSAGE:String="contact_us.mediator.submit.message";
		
		// UsefulLinks.mxml
		public static const USEFUL_LINKS_TITLE:String="useful_links.title";
		public static const USEFUL_LINKS_SAVE_ERROR_DUPLICATE_ID:String="useful_links.save.error.duplicate_id";
		
		// LeftArea.mxml
		public static const LEFT_AREA_BUTTON_NEW_QUOTE:String="left_area.button.new_quote";
		public static const LEFT_AREA_BUTTON_FORCE_RENEWAL:String="left_area.button.force_renewal";
		//public static const LEFT_AREA_TITLE_SEARCH:String="left_area.title.search";
		public static const LEFT_AREA_TITLE_QUOTES_RENEWAL:String="left_area.title.quotes_renewal";
		public static const LEFT_AREA_TITLE_LEFT_AREA_POLICIES:String="left_area.title.left_area.policies";
		public static const LEFT_AREA_TITLE_REFERRALS:String="left_area.title.referrals";
		public static const LEFT_AREA_TITLE_HANDLED_OFFLINE:String="left_area.title.handled_offline";		
		
		// LeftAreaMediator.as
		public static const LEFT_AREA_MEDIATOR_TITLE_RENEWAL_OFFERS:String="left_area_mediator.title.renewal_offers";
		
		// RenewalList.mxml
		public static const RENEWAL_LIST_GRID_DAYS_TO_INCEPT:String="renewal_list.grid.days_to_incept";
		public static const RENEWAL_LIST_GRID_INCEPTION_DATE:String="renewal_list.grid.inception_date";
		public static const RENEWAL_LIST_GRID_INSURED_NAME:String="renewal_list.grid.insured_name";
		public static const RENEWAL_LIST_GRID_STATUS:String="renewal_list.grid.status";
		public static const RENEWAL_LIST_GRID_REFERENCE:String="renewal_list.grid.reference";
		public static const RENEWAL_LIST_GRID_BROKER_OFFICE:String="renewal_list.grid.broker_office";
		public static const RENEWAL_LIST_GRID_BROKER_CITY:String="renewal_list.grid.broker_city";
			
		// RiskList.mxml
		public static const RISK_LIST_GRID_QUOTE_DATE:String="risk_list.grid.quote_date";
		public static const RISK_LIST_GRID_INSURED_NAME:String="risk_list.grid.insured_name";
		public static const RISK_LIST_GRID_REFERENCE:String="risk_list.grid.reference";
		public static const RISK_LIST_GRID_OWNER:String="risk_list.grid.owner";
		public static const RISK_LIST_GRID_STATUS:String="risk_list.grid.status";
		public static const RISK_LIST_GRID_BROKER_OFFICE:String="risk_list.grid.broker_office";
		public static const RISK_LIST_GRID_BROKER_CITY:String="risk_list.grid.broker_city";
		public static const RISK_LIST_GRID_INCEPTION_DATE:String="risk_list.grid.inception_date";

		// Search.mxml
		public static const SEARCH_VIEW_TITLE:String="search_view.title";
		public static const SEARCH_VIEW_GRID_INSURED_NAME:String="search_view.grid.insured_name";
		public static const SEARCH_VIEW_GRID_REFERENCE:String="search_view.grid.reference";
		public static const SEARCH_VIEW_GRID_STATUS:String="search_view.grid.status";
		public static const SEARCH_VIEW_GRID_BROKER_OFFICE:String="search_view.grid.broker_office";
		public static const SEARCH_VIEW_GRID_BROKER_CITY:String="search_view.grid.broker_city";
		public static const SEARCH_VIEW_GRID_DATE:String="search_view.grid.date";
		
		// ChangePasswordValidationImpl.mxml
		public static const CHANGE_PASSWORD_VALIDATOR_REQUIRED_OLD_PASSWORD:String="change_password_validator.required.old_password";
		public static const CHANGE_PASSWORD_VALIDATOR_REQUIRED_NEW_PASSWORD:String="change_password_validator.required.new_password";
		public static const CHANGE_PASSWORD_VALIDATOR_REQUIRED_NEW_PASSWORD_CONFIRMATION:String="change_password_validator.required.new_password_confirmation";
		public static const CHANGE_PASSWORD_VALIDATOR_ERROR_PASSWORDS_DOES_NOT_MATCH:String="change_password_validator.error.passwords_does_not_match";		
		
		public static const CHANGE_PASSWORD_TITLE:String="change_password.title";
		public static const CHANGE_PASSWORD_INTRO:String="change_password.intro";
		public static const CHANGE_PASSWORD_OLD_PASSWORD:String="change_password.old_password";
		public static const CHANGE_PASSWORD_NEW_PASSWORD:String="change_password.new_password";
		public static const CHANGE_PASSWORD_NEW_PASSWORD_CONFIRMATION:String="change_password.new_password_confirmation";
		public static const CHANGE_PASSWORD_BUTTON_CONFIRM:String="change_password.button.confirm";
		public static const CHANGE_PASSWORD_BUTTON_RESET:String="change_password.button.reset";		
		
		//PasswordExpired.mxml
		public static const CHANGE_PASSWORD_EXPIRED:String="change_password.expired";		
		
		
		// Reports.mxml
/*		public static const REPORTS_TITLE:String="reports.title";
		public static const REPORTS_BROKER_OFFICE:String="reports.broker_office";
		public static const REPORTS_START_DATE:String="reports.start_date";
		public static const REPORTS_END_DATE:String="reports.end_date";
		public static const REPORTS_BUTTON_GENERATE:String="reports.button.generate";*/
		public static const REPORTS_TITLE:String="reports.title";
		public static const REPORTS_BROKER_OFFICE:String="reports.broker_office";
		public static const REPORTS_START_DATE:String="reports.start_date";
		public static const REPORTS_END_DATE:String="reports.end_date";
		public static const REPORTS_BUTTON_GENERATE:String="reports.button.generate";
		
		public static const REPORTS_GRID_HEADER_GRID_HEADER_YOA:String="reports.grid_header.yoa";
		public static const REPORTS_GRID_HEADER_GRID_HEADER_INSURED_NAME:String="reports.grid_header.insured_name";
		public static const REPORTS_GRID_HEADER_GRID_HEADER_POLICY_TYPE:String="reports.grid_header.policy_type";
		public static const REPORTS_GRID_HEADER_GRID_HEADER_STATUS:String="reports.grid_header.status";
		public static const REPORTS_GRID_HEADER_GRID_HEADER_REFERENCE:String="reports.grid_header.reference";
		public static const REPORTS_GRID_HEADER_GRID_HEADER_POLICY_REFERENCE:String="reports.grid_header.policy_reference";
		public static const REPORTS_GRID_HEADER_GRID_HEADER_POLICY_START_DATE:String="reports.grid_header.policy_start_date";
		public static const REPORTS_GRID_HEADER_GRID_HEADER_POLICY_END_DATE:String="reports.grid_header.policy_end_date";
		public static const REPORTS_GRID_HEADER_GRID_HEADER_INCEPTION_DATE:String="reports.grid_header.inception_date";
		public static const REPORTS_GRID_HEADER_GRID_HEADER_BROKER_OFFICE_NAME:String="reports.grid_header.broker_office_name";
		public static const REPORTS_GRID_HEADER_GRID_HEADER_BROKER_CONTACT_NAME:String="reports.grid_header.broker_contact_name";
		public static const REPORTS_GRID_HEADER_GRID_HEADER_INCEPTED_BY:String="reports.grid_header.incepted_by";
		public static const REPORTS_GRID_HEADER_GRID_HEADER_CURRENCY:String="reports.grid_header.currency";
		public static const REPORTS_GRID_HEADER_GRID_HEADER_GROSS_PREMIUM:String="reports.grid_header.gross_premium";
		public static const REPORTS_GRID_HEADER_GRID_HEADER_NET_PREMIUM:String="reports.grid_header.net_premium";
		public static const REPORTS_GRID_HEADER_GRID_HEADER_COMMISSION:String="reports.grid_header.commission";
		public static const REPORTS_GRID_HEADER_GRID_HEADER_COMMISSION_PERCENTAGE:String="reports.grid_header.commission_percentage";
		public static const REPORTS_GRID_HEADER_GRID_HEADER_INCEPTION_MONTH:String="reports.grid_header.inception_month";
		public static const REPORTS_GRID_HEADER_GRID_HEADER_INCEPTION_YEAR:String="reports.grid_header.inception_year";
		public static const REPORTS_GRID_HEADER_GRID_HEADER_TAX:String="reports.grid_header.tax";
		public static const REPORTS_GRID_HEADER_GRID_HEADER_TRIA:String="reports.grid_header.tria";
		public static const REPORTS_GRID_HEADER_GRID_HEADER_TRIA_OFFERED:String="reports.grid_header.tria_offered";
		public static const REPORTS_SELECTION_DETAILS_GROSS_NET_COMMISSION:String="reports.selection_details.gross_net_commission";
		public static const REPORTS_GRID_HEADER_GRID_HEADER_SURPLUS_OFFICE_NAME:String="reports.grid_header.surplus_office_name";
		public static const REPORTS_GRID_HEADER_GRID_HEADER_SURPLUS_CONTACT_NAME:String="reports.grid_header.surplus_contact_name";
		public static const REPORTS_GRID_HEADER_GRID_HEADER_SURPLUS_LICENSE_NO:String="reports.grid_header.surplus_license_no";
		public static const REPORTS_GRID_HEADER_GRID_HEADER_SURPLUS_LICENSE_STATE:String="reports.grid_header.surplus_license_state";
		
		
		public static const REPORTS_CHART_STATS_TOTAL_ROWS:String="reports.chart.stats.total_rows";
		public static const REPORTS_CHART_RISK_BY_STATUS_TITLE:String="reports.chart.risk_by_status.title";
		public static const REPORTS_CHART_RISK_BY_STATUS_TOOLTIP:String="reports.chart.risk_by_status.tooltip";
		public static const REPORTS_CHART_RISK_BY_STATUS_LABEL:String="reports.chart.risk_by_status.label";
		
		public static const REPORTS_CHART_GROSS_BY_PERIOD_TITLE:String="reports.chart.gross_by_period.title";
		public static const REPORTS_CHART_GROSS_BY_PERIOD_TOOLTIP:String="reports.chart.gross_by_period.tooltip";

		// ClausesForm.mxml
		public static const CLAUSES_FORM_AVAIABLE_CLAUSES:String="clauses_form.avaiable_clauses";
		public static const CLAUSES_FORM_SHOW_ACHIVED_CLAUSES:String="clauses_form.show_achived_clauses";
		public static const CLAUSES_FORM_STANDARD:String="clauses_form.standard";
		public static const CLAUSES_FORM_BUTTON_RESTORE:String="clauses_form.button.restore";
		public static const CLAUSES_FORM_BUTTON_ARCHIVE:String="clauses_form.button.archive";
		public static const CLAUSES_FORM_BUTTON_VIEW:String="clauses_form.button.view";
		public static const CLAUSES_FORM_BUTTON_ADD:String="clauses_form.button.add";
		public static const CLAUSES_FORM_NONSTANDARD:String="clauses_form.nonstandard";
		public static const CLAUSES_FORM_APLICABLE_CLAUSES:String="clauses_form.aplicable_clauses";
		public static const CLAUSES_FORM_APLICABLE_CLAUSES_TITLE:String="clauses_form.aplicable_clauses.title";
		public static const CLAUSES_FORM_APLICABLE_CLAUSES_INTRO:String="clauses_form.aplicable_clauses.intro";
		
		public static const CLAUSES_FORM_MEDIATOR_ERROR_NO_CLAUSE_SELECTED:String="clauses_form_mediator.error.no_clause_selected";
		
		// NewClausesForm.mxml
		
		public static const NEW_CLAUSES_FORM_TITLE:String="new_clauses_form.title";
		public static const NEW_CLAUSES_FORM_NAME:String="new_clauses_form.name";
		public static const NEW_CLAUSES_FORM_DESCRIPTION:String="new_clauses_form.description";
		
		// NewClausesFormValidator.mxml
		public static const NEW_CLAUSES_FORM_VALIDATOR_REQUIRED_NAME:String="new_clauses_form_validator.required.name";
		public static const NEW_CLAUSES_FORM_VALIDATOR_REQUIRED_DESCRIPTION:String="new_clauses_form_validator.required.description";
		public static const NEW_CLAUSES_FORM_VALIDATOR_ERROR_ALREADY_EXISTS:String="new_clauses_form_validator.error.already_exists";
		
		
		// ViewClausesForm.mxml
		public static const VIEW_CLAUSES_FORM_TITLE:String="view_clauses_form.title";
		public static const VIEW_CLAUSES_FORM_CLAUSE:String="view_clauses_form.clause";
		
		// CoverPeriodView.mxml
		public static const COVER_PERIOD_VIEW_TITLE:String="cover_period_view.title";
		public static const COVER_PERIOD_VIEW_INCEPTION_DATE:String="cover_period_view.inception_date";
		public static const COVER_PERIOD_VIEW_EXPIRY_DATE:String="cover_period_view.expiry_date";
		public static const COVER_PERIOD_VIEW_BUTTON_UPDATE:String="cover_period_view.button.update";
		
		// CoverPeriodValidatorView.mxml
		public static const COVER_PERIOD_VIEW_VALIDATOR_REQUIRED_INCEPTION_DATE:String="cover_period_view_validator.required.inception_date";
		public static const COVER_PERIOD_VIEW_VALIDATOR_REQUIRED_EXPIRY_DATE:String="cover_period_view_validator.required.expiry_date";
		public static const COVER_PERIOD_VIEW_VALIDATOR_ERROR_INCEPTION_DATE_UNDEFINED:String="cover_period_view_validator.error.inception_date_undefined";
		public static const COVER_PERIOD_VIEW_VALIDATOR_ERROR_EXPIRY_DATE_UNDEFINED:String="cover_period_view_validator.error.expiry_date_undefined";
		public static const COVER_PERIOD_VIEW_VALIDATOR_ERROR_INCEPTION_DATE_INVALID:String="cover_period_view_validator.error.inception_date_invalid";
		public static const COVER_PERIOD_VIEW_VALIDATOR_ERROR_EXPIRY_DATE_INVALID:String="cover_period_view_validator.error.expiry_date_invalid";
		public static const COVER_PERIOD_VIEW_VALIDATOR_ERROR_EXPIRY_DATE_INVALID2:String="cover_period_view_validator.error.expiry_date_invalid2";		
		
		
		// DeclineReasonMediator.as
		public static const DECLINE_REASON_MEDIATOR_CANCEL_POLICY_TITLE:String="decline_reason_mediator.cancel_policy.title";
		public static const DECLINE_REASON_MEDIATOR_CANCEL_POLICY_DESCRIPTION:String="decline_reason_mediator.cancel_policy.description";
		public static const DECLINE_REASON_MEDIATOR_NTU_QUOTE_TITLE:String="decline_reason_mediator.ntu_quote.title";
		public static const DECLINE_REASON_MEDIATOR_NTU_QUOTE_DESCRIPTION:String="decline_reason_mediator.ntu_quote.description";
		public static const DECLINE_REASON_MEDIATOR_DECLINE_TITLE:String="decline_reason_mediator.decline.title";
		public static const DECLINE_REASON_MEDIATOR_DECLINE_DESCRIPTION:String="decline_reason_mediator.decline.description";
		public static const DECLINE_REASON_MEDIATOR_OTHER:String="decline_reason_mediator.other";
		
		// DeclineReasonMediator.as
		public static const DECLINE_REASON_REASON:String="decline_reason.reason";
		public static const DECLINE_REASON_EFFECTIVE_DATE:String="decline_reason.effective_date";
	
		// DeclineReasonValidator.mxml
		public static const DECLINE_REASON_VALIDATOR_REQUIRED_REASON:String="decline_reason_validator.required.reason";
		public static const DECLINE_REASON_VALIDATOR_ERROR_EFFECTIVE_DATE:String="decline_reason_validator.error.effective_date";		
		
		// EmailConfirmation.mxml
		public static const EMAIL_CONFIRMATION_TITLE:String="email_confirmation.title";
		public static const EMAIL_CONFIRMATION_COMMENTS:String="email_confirmation.comments";
		
		// HistoryForm_mxml
		public static const HISTORY_FORM_GRID_DATE:String="history_form.grid.date";
		public static const HISTORY_FORM_GRID_STATUS:String="history_form.grid.status";
		public static const HISTORY_FORM_GRID_REFERENCE:String="history_form.grid.reference";
		public static const HISTORY_FORM_GRID_USER:String="history_form.grid.user";
		public static const HISTORY_FORM_GRID_COMMENTS:String="history_form.grid.comments";
		public static const HISTORY_FORM_GRID_DOCUMENTS:String="history_form.grid.documents";		
		
		// InceptionDate.mxml
		public static const INCEPTION_DATE_TITLE:String="inception_date.title";
		public static const INCEPTION_DATE_INTRO1:String="inception_date.intro1";
		public static const INCEPTION_DATE_INTRO2:String="inception_date.intro2";
		public static const INCEPTION_DATE_INCEPTION_DATE:String="inception_date.inception_date";
		public static const INCEPTION_DATE_CONFIRM_BIND1:String="inception_date.confirm_bind1";
		public static const INCEPTION_DATE_CONFIRM_BIND2:String="inception_date.confirm_bind2";
		
		// InceptionDateMediator.mxml
		public static const INCEPTION_DATE_MEDIATOR_REQUIRED_INCEPTION_DATE:String="inception_date_mediator.required.inception_date";
		public static const INCEPTION_DATE_MEDIATOR_ERROR_INCEPTION_DATE:String="inception_date_mediator.error.inception_date";
		
		// MTAOverridePremium_mxml                         
		public static const MTA_OVERRRIDE_PREMIUM_TITLE:String="mta_overrride_premium.title";
		public static const MTA_OVERRRIDE_PREMIUM_INTRO:String="mta_overrride_premium.intro";
		public static const MTA_OVERRRIDE_PREMIUM_GRID_ROW1_COL1:String="mta_overrride_premium.grid.row1.col1";
		public static const MTA_OVERRRIDE_PREMIUM_GRID_ROW1_COL3_BUTTON:String="mta_overrride_premium.grid.row1.col3.button";
		public static const MTA_OVERRRIDE_PREMIUM_GRID_ROW2_COL1:String="mta_overrride_premium.grid.row2.col1";
		//public static const MTA_OVERRRIDE_PREMIUM_GRID_ROW2_COL3_BUTTON:String="mta_overrride_premium.grid.row2.col3.button";
		public static const MTA_OVERRRIDE_PREMIUM_BUTTON_REMOVE_OVERRIDE:String="mta_overrride_premium.button.remove_override";		

		public static const MTA_OVERRRIDE_PREMIUM_TRIA_TITLE:String="mta_overrride_premium.tria.title";
		public static const MTA_OVERRRIDE_PREMIUM_TRIA_INTRO:String="mta_overrride_premium.tria.intro";
		public static const MTA_OVERRRIDE_PREMIUM_TRIA_GRID_ROW1_COL1:String="mta_overrride_premium.tria.grid.row1.col1";
		public static const MTA_OVERRRIDE_PREMIUM_TRIA_GRID_ROW1_COL3_BUTTON:String="mta_overrride_premium.tria.grid.row1.col3.button";
		public static const MTA_OVERRRIDE_PREMIUM_TRIA_GRID_ROW2_COL1:String="mta_overrride_premium.tria.grid.row2.col1";
		//public static const MTA_OVERRRIDE_PREMIUM_TRIA_GRID_ROW2_COL3_BUTTON:String="mta_overrride_premium.tria.grid.row2.col3.button";
		public static const MTA_OVERRRIDE_PREMIUM_TRIA_BUTTON_REMOVE_OVERRIDE:String="mta_overrride_premium.tria.button.remove_override";		
		
		
		// MTAView
		public static const MTA_REQUEST_VIEW_TITLE:String="mta_request_view.title";
		public static const MTA_REQUEST_VIEW_INTRO:String="mta_request_view.intro";
		public static const MTA_REQUEST_VIEW_ENDORSEMENT_DATE:String="mta_request_view.endorsement_date";
		public static const MTA_REQUEST_VIEW_REASON:String="mta_request_view.reason";
		public static const MTA_REQUEST_VIEW_DESCRIPTION:String="mta_request_view.description";		
		
		// AdditionalCover.mxml / AdditionalCoverMediator.mxml
		public static const ADDITIONAL_COVER_NEW_QUOTE_STOCK_COVER_TITLE:String="additional_cover.new_quote.stock_cover.title";
		public static const ADDITIONAL_COVER_NEW_QUOTE_STOCK_COVER_Q1:String="additional_cover.new_quote.stock_cover.q1";
		public static const ADDITIONAL_COVER_NEW_QUOTE_STOCK_COVER_Q2:String="additional_cover.new_quote.stock_cover.q2";
		public static const ADDITIONAL_COVER_NEW_QUOTE_STOCK_COVER_Q3:String="additional_cover.new_quote.stock_cover.q3";
		public static const ADDITIONAL_COVER_NEW_QUOTE_STOCK_COVER_Q4:String="additional_cover.new_quote.stock_cover.q4";
		public static const ADDITIONAL_COVER_NEW_QUOTE_STOCK_COVER_Q5:String="additional_cover.new_quote.stock_cover.q5";
		public static const ADDITIONAL_COVER_NEW_QUOTE_STOCK_RESTRICTED_AREAS:String="additional_cover.new_quote.stock_cover.restricted.areas";
		public static const ADDITIONAL_COVER_NEW_QUOTE_EXHIBITION_COVER_TITLE:String="additional_cover.new_quote.exhibition_cover.title";
		public static const ADDITIONAL_COVER_NEW_QUOTE_EXHIBITION_COVER_Q1:String="additional_cover.new_quote.exhibition_cover.q1";
		public static const ADDITIONAL_COVER_NEW_QUOTE_EXHIBITION_COVER_Q2:String="additional_cover.new_quote.exhibition_cover.q2";
		public static const ADDITIONAL_COVER_NEW_QUOTE_TOOLS_AND_SAMPLES_COVER_TITLE:String="additional_cover.new_quote.tools_and_samples_cover.title";
		public static const ADDITIONAL_COVER_NEW_QUOTE_TOOLS_AND_SAMPLES_COVER_Q1:String="additional_cover.new_quote.tools_and_samples_cover.q1";		
		public static const ADDITIONAL_COVER_NEW_QUOTE_ADDRESS_ENTER_STOCK_LOCATION:String="additional_cover.new_quote.address.enter.stock_location";
		public static const ADDITIONAL_COVER_NEW_QUOTE_ADDRESS_EDIT_STOCK_LOCATION:String="additional_cover.new_quote.address.edit.stock_location";

		// ExhibitionsGrid.mxml
		public static const EXHIBITIONS_GRID_TERRITORY:String="exhibitions_grid.territory";
		public static const EXHIBITIONS_GRID_TOTAL_NO:String="exhibitions_grid.total_no";
		public static const EXHIBITIONS_GRID_MAX_LLIMIT:String="exhibitions_grid.max_llimit";
		
		// StockLocation
		public static const STOCK_LOCATION_DETAIL_ENTER_ADDRESS:String="stock_location.detail.enter_address";
		public static const STOCK_LOCATION_GRID_VIEW_ADDRESS:String="stock_location.grid_view.address";
		public static const STOCK_LOCATION_GRID_VIEW_NSI_ALARM:String="stock_location.grid_view.nsi_alarm";
		public static const STOCK_LOCATION_GRID_VIEW_STD_CONSTRUCTION:String="stock_location.grid_view.std_construction";
		public static const STOCK_LOCATION_GRID_VIEW_LIMIT:String="stock_location.grid_view.limit";
		public static const STOCK_LOCATION_GRID_VIEW_BUTTON_ADD_LOCATION:String="stock_location.grid_view.button.add_location";
		public static const STOCK_LOCATION_GRID_VIEW_TOTAL:String="stock_location.grid_view.total";
		
		public static const TOOLS_AND_SAMPLES_GRID_TOTAL_NO_VEHICLE:String="tools_and_samples.grid.total_no_vehicle";
		public static const TOOLS_AND_SAMPLES_GRID_LIMIT_PER_VEHICLE:String="tools_and_samples.grid.limit_per_vehicle";
		
		public static const BUSINESS_CONSUMER_CONTROL_TITLE:String="business_consumer_control.title";
		public static const BUSINESS_CONSUMER_CONTROL_INTRO:String="business_consumer_control.intro";
		public static const BUSINESS_CONSUMER_CONTROL_TO_BE_CONFIRMED:String="business_consumer_control.to_be_confirmed";
        public static const BUSINESS_CONSUMER_CONTROL_NOTE:String="business_consumer_control.note";
			
		public static const NEW_INSURED_FORM_TITLE:String="new_insured.form.title";
		public static const NEW_INSURED_FORM_INSURED_NAME:String="new_insured.form.insured_name";
		//public static const NEW_INSURED_FORM_POSTCODE:String="new_insured.form.postcode";
		public static const NEW_INSURED_FORM_LOOKUPADDRESS:String="new_insured.form.lookupaddress";
		public static const NEW_INSURED_FORM_ADDRESSLINE:String="new_insured.form.addressline";
		public static const NEW_INSURED_FORM_CITY:String="new_insured.form.city";
		public static const NEW_INSURED_FORM_COUNTY:String="new_insured.form.county";		
		
		public static const NEW_INSURED_VALIDATOR_REQUIRED_INSURED_NAME:String="new_insured.validator.required.insured_name";
		public static const NEW_INSURED_VALIDATOR_REQUIRED_ADDRESSLINE1:String="new_insured.validator.required.addressline1";
		public static const NEW_INSURED_VALIDATOR_REQUIRED_CITY:String="new_insured.validator.required.city";

		// PersonalView/Mediator
		public static const PERSONAL_VIEW_BROKER_DETAILS_TITLE:String="personal.view.broker_details.title";
		public static const PERSONAL_VIEW_BROKER_DETAILS_BROKER_OFFICE:String="personal.view.broker_details.broker_office";
		public static const PERSONAL_VIEW_BROKER_DETAILS_UNDERWRITER:String="personal.view.broker_details.underwriter";
		public static const PERSONAL_VIEW_BROKER_DETAILS_CURRENCY:String="personal.view.broker_details.currency";
		public static const PERSONAL_VIEW_BROKER_DETAILS_CONTACT_NAME:String="personal.view.broker_details.contact_name";
		public static const PERSONAL_VIEW_BROKER_DETAILS_EMAIL:String="personal.view.broker_details.email";
		public static const PERSONAL_VIEW_BROKER_DETAILS_EMAIL_COPY_TO:String="personal.view.broker_details.email_copy_to";
		public static const PERSONAL_VIEW_BROKER_DETAILS_TELEPHONE_DDI:String="personal.view.broker_details.telephone_ddi";
		public static const PERSONAL_VIEW_BROKER_DETAILS_BROKER_REFERENCE:String="personal.view.broker_details.broker_reference";
		//Surplus Lines Office
		public static const PERSONAL_VIEW_BROKER_DETAILS_SURPLUS_LINES_OFFICE:String="personal.view.broker_details.surplus_lines_office";
		public static const PERSONAL_VIEW_BROKER_DETAILS_SURPLUS_LINES_CONTACT:String="personal.view.broker_details.surplus_lines_contact";
		public static const PERSONAL_VIEW_BROKER_DETAILS_SURPLUS_LINES_STATE:String="personal.view.broker_details.surplus_lines_state";
		public static const PERSONAL_VIEW_BROKER_DETAILS_SURPLUS_LINES_LICENSE_NO:String="personal.view.broker_details.surplus_lines_license_no";

		public static const PERSONAL_VIEW_INSURED_DETAILS_TITLE:String="personal.view.insured_details.title";
		public static const PERSONAL_VIEW_INSURED_DETAILS_SELECT_INSURED:String="personal.view.insured_details.select_insured";
		public static const PERSONAL_VIEW_INSURED_DETAILS_BUTTON_CREATE_NEW_INSURED:String="personal.view.insured_details.button.create_new_insured";
		public static const PERSONAL_VIEW_INSURED_DETAILS_NAME_AND_ADDRESS:String="personal.view.insured_details.name_and_address";		

		public static const PERSONAL_MEDIATOR_POP_UP_CURRENCY_CHANGE_MESSAGE:String="personal.mediator.pop_up.currency_change.message";
		public static const PERSONAL_MEDIATOR_POP_UP_CURRENCY_CHANGE_TITLE:String="personal.mediator.pop_up.currency_change.title";
		public static const PERSONAL_MEDIATOR_POP_UP_SURPLUS_STATE_MESSAGE:String="personal.mediator.pop_up.surplus_licence_state.message";
		public static const PERSONAL_MEDIATOR_POP_UP_SURPLUS_STATE_TITLE:String="personal.mediator.pop_up.surplus_licence_state.title";

		// BargeForm
		public static const BARGE_FORM_VIEW_LIMIT:String="barge_form_view.limit";
		public static const BARGE_FORM_VIEW_YES:String=YES;
		public static const BARGE_FORM_VIEW_NO:String=NO;

		// BasisOfValuationView/Mediator
		public static const BASIS_OF_VALUATION_VIEW_BASIS_BASIS_OF_VALUDATION:String="basis_of_valuation.view.basis.basis_of_valudation";
		public static const BASIS_OF_VALUATION_VIEW_BASIS_STOCK_COST_INSURANCE:String="basis_of_valuation.view.basis.stock_cost_insurance";
		public static const BASIS_OF_VALUATION_VIEW_BASIS_STOCK_COST_INSURANCE_FOR_UNSOLD_STOCK_INVOICE_VALUE:String="basis_of_valuation.view.basis.stock_cost_insurance.for_unsold_stock_invoice_value";
		public static const BASIS_OF_VALUATION_VIEW_BASIS_EXHIBITIONS:String="basis_of_valuation.view.basis.exhibitions";
		public static const BASIS_OF_VALUATION_VIEW_BASIS_TOOLS_AND_SAMPLES:String="basis_of_valuation.view.basis.tools_and_samples";
		public static const BASIS_OF_VALUATION_VIEW_BASIS_SENDINGS_DOMESTIC_TRANSIT:String="basis_of_valuation.view.basis.sendings.domestic_transit";
		public static const BASIS_OF_VALUATION_VIEW_BASIS_SENDINGS_PERCENTAGE_BASIS_OF_VALUATION:String="basis_of_valuation.view.basis.sendings.percentage_basis_of_valuation";
		
		public static const BASIS_OF_VALUATION_VIEW_DEDUCTIBLES_TITLE:String="basis_of_valuation.view.deductibles.title";
		public static const BASIS_OF_VALUATION_VIEW_DEDUCTIBLES_CHANGE_WARNING_TEXT:String="basis_of_valuation.view.deductibles.change_warning_text";
		public static const BASIS_OF_VALUATION_VIEW_DEDUCTIBLES_CHECK_BOX_LABEL:String="basis_of_valuation.view.deductibles.check_box_label";
		public static const BASIS_OF_VALUATION_VIEW_DEDUCTIBLES_STOCK:String="basis_of_valuation.view.deductibles.stock";
		public static const BASIS_OF_VALUATION_VIEW_DEDUCTIBLES_STOCK_CATASTROPHE:String="basis_of_valuation.view.deductibles.stock.catastrophe";
		public static const BASIS_OF_VALUATION_VIEW_DEDUCTIBLES_EXHIBITIONS:String=BASIS_OF_VALUATION_VIEW_BASIS_EXHIBITIONS;
		public static const BASIS_OF_VALUATION_VIEW_DEDUCTIBLES_TOOLS_AND_SAMPLES:String=BASIS_OF_VALUATION_VIEW_BASIS_TOOLS_AND_SAMPLES;
		public static const BASIS_OF_VALUATION_VIEW_DEDUCTIBLES_EACH_AND_EVERY_LOST:String="basis_of_valuation.view.deductibles.each_and_every_lost=each and every loss";		

		// ClaimsHistory
		public static const CLAIMS_HISTORY_TITLE:String="claims_history.title";
		public static const CLAIMS_HISTORY_CHANGE_WARNING_TEXT:String="claims_history.change_warning_text";
		public static const CLAIMS_HISTORY_CHECK_BOX_LABEL:String="claims_history.check_box_label";
		public static const CLAIMS_HISTORY_FMI_CLAIM_3YEARS:String="claims_history.fmi_claim_3years";
		public static const CLAIMS_HISTORY_NUMBER_OF_CLAIMS:String="claims_history.number_of_claims";
		public static const CLAIMS_HISTORY_TOTAL_CLAIMS_AMOUNT:String="claims_history.total_claims_amount";		
		
		// Cover
		public static const COVER_VIEW_TITLE:String="cover.view.title";
		public static const COVER_VIEW_TYPE:String="cover.view.type";
		public static const COVER_VIEW_TYPE_ANNUAL:String="cover.view.type.annual";
		public static const COVER_VIEW_TYPE_SINGLE_TRANSIT:String="cover.view.type.single_transit";
		public static const COVER_VIEW_SUBJECT_MATTER_INSURED:String="cover.view.subject_matter_insured";
		public static const COVER_VIEW_SUBJECT_MATTER_DETAIL:String="cover.view.subject_matter_detail";
		public static const COVER_VIEW_ENDORSEMENT_START_DATE:String="cover.view.endorsement_start_date";
		public static const COVER_VIEW_INCEPTION_DATE:String="cover.view.inception_date";
		public static const COVER_VIEW_EXPIRY_DATE:String="cover.view.expiry_date";
		public static const COVER_VIEW_VESSEL_NAME:String="cover.view.vessel_name";
		public static const COVER_VIEW_VESSEL_NAME_OVER_25:String="cover.view.vessel_name_over_25";
		public static const COVER_VIEW_VESSEL_IACS_CLASS:String="cover.view.vessel_iacs_class";		
		
		// getQuote View
		public static const GET_QUOTE_VIEW_MAD_LABEL:String="get_quote.view.mad_label";
		public static const GET_QUOTE_VIEW_TERMS:String="get_quote.view.terms";
		public static const GET_QUOTE_VIEW_PREMIUM_TYPE:String="get_quote.view.premium_type";
		public static const GET_QUOTE_VIEW_FLAT_NON_ADJUSTABLE:String="get_quote.view.flat_non_adjustable";
		public static const GET_QUOTE_VIEW_OVERRIDE:String="get_quote.view.override";
		public static const GET_QUOTE_VIEW_COMISSION:String="get_quote.view.comission";
		public static const GET_QUOTE_VIEW_COMISSION_GROSS:String="get_quote.view.comission.gross";
		public static const GET_QUOTE_VIEW_COMISSION_NET:String="get_quote.view.comission.net";
		public static const GET_QUOTE_VIEW_MIN_AND_DEPOSIT:String="get_quote.view.min_and_deposit";
		public static const GET_QUOTE_VIEW_MIN_AND_DEPOSIT_PREMIUM:String="get_quote.view.min_and_deposit.premium";
		public static const GET_QUOTE_VIEW_MIN_AND_DEPOSIT_ADDITIONAL_RETURN_PREMIUM:String="get_quote.view.min_and_deposit.additional_return_premium";
		public static const GET_QUOTE_VIEW_MIN_AND_DEPOSIT_TAX_AMOUNT:String="get_quote.view.min_and_deposit.tax_amount";
		public static const GET_QUOTE_VIEW_MIN_AND_DEPOSIT_ADDITIONAL_RETURN_TAX:String="get_quote.view.min_and_deposit.additional_return_tax";
		public static const GET_QUOTE_VIEW_EXPIRING_PREMIUM:String="get_quote.view.expiring_premium";
		public static const GET_QUOTE_VIEW_EXPIRING_PREMIUM_POLICY:String="get_quote.view.expiring_premium.policy";
		public static const GET_QUOTE_VIEW_EXPIRING_PREMIUM_ADJUST_BY:String="get_quote.view.expiring_premium.adjust_by";
		public static const GET_QUOTE_VIEW_EXPIRING_PREMIUM_CHARGEABLE:String="get_quote.view.expiring_premium.chargeable";
		public static const GET_QUOTE_VIEW_MTA_DETAILS:String="get_quote.view.mta_details";
		public static const GET_QUOTE_VIEW_MTA_DETAILS_ADDITIONAL_RETURN_PREMIUM:String="get_quote.view.mta_details.additional_return_premium";
		public static const GET_QUOTE_VIEW_MTA_DETAILS_OVERRIDEN:String="get_quote.view.mta_details.overriden";
		public static const GET_QUOTE_VIEW_MTA_DETAILS_CALCULATED:String="get_quote.view.mta_details.calculated";
		public static const GET_QUOTE_VIEW_MTA_DETAILS_OVERRIDE_BUTTON_EDIT:String="get_quote.view.mta_details.override.button.edit";
		public static const GET_QUOTE_VIEW_MTA_DETAILS_OVERRIDE_BUTTON_OVERRIDE:String="get_quote.view.mta_details.override.button.override";
		public static const GET_QUOTE_VIEW_MTA_DETAILS_ADDITIONAL_RETURN_TAX:String="get_quote.view.mta_details.additional_return_tax";
		public static const GET_QUOTE_VIEW_MTA_DETAILS_CHARGEABLE:String="get_quote.view.mta_details.chargeable";		
		
		public static const GET_QUOTE_VIEW_MTA_DETAILS_ADDITIONAL_RETURN_TRIA_PREMIUM:String="get_quote.view.mta_details.additional_return_tria_premium";
		public static const GET_QUOTE_VIEW_PREMIUM_BREAKDOWN_TRIA_PREMIUM:String="get_quote.view.premium_breakdown.tria_premium";
		
		public static const GET_QUOTE_VIEW_PREMIUM_BREAKDOWN_100:String="get_quote.view.premium_breakdown.100";
		public static const GET_QUOTE_VIEW_PREMIUM_BREAKDOWN_FLAT:String="get_quote.view.premium_breakdown.flat";
		public static const GET_QUOTE_VIEW_PREMIUM_BREAKDOWN_POLICY_PREMIUM:String="get_quote.view.premium_breakdown.policy_premium";
		public static const GET_QUOTE_VIEW_PREMIUM_BREAKDOWN_ADJUSTED_BY:String="get_quote.view.premium_breakdown.adjusted_by";
		public static const GET_QUOTE_VIEW_PREMIUM_BREAKDOWN_ADJUST_BY:String="get_quote.view.premium_breakdown.adjust_by";
		public static const GET_QUOTE_VIEW_PREMIUM_BREAKDOWN_CHARGEABLE_PREMIUM:String="get_quote.view.premium_breakdown.chargeable_premium";
		public static const GET_QUOTE_VIEW_PREMIUM_BREAKDOWN_PREMIUM_WITH_CLAIMS:String="get_quote.view.premium_breakdown.premium_with_claims";
		public static const GET_QUOTE_VIEW_PREMIUM_BREAKDOWN_BASE:String="get_quote.view.premium_breakdown.base";
		public static const GET_QUOTE_VIEW_PREMIUM_BREAKDOWN_TAX:String="get_quote.view.premium_breakdown.tax";
		public static const GET_QUOTE_VIEW_PREMIUM_BREAKDOWN_LOSS_RATIO:String="get_quote.view.premium_breakdown.loss_ratio";
		public static const GET_QUOTE_VIEW_PREMIUM_BREAKDOWN_CLAIM_LOADING:String="get_quote.view.premium_breakdown.claim_loading";
		
		public static const GET_QUOTE_VIEW_SENDINGS_AND_ADD_COVER_BREAKDOWN_SENDINGS:String="get_quote.view.sendings_and_add_cover_breakdown.sendings";
		public static const GET_QUOTE_VIEW_SENDINGS_AND_ADD_COVER_BREAKDOWN_AMOUNT:String="get_quote.view.sendings_and_add_cover_breakdown.amount";
		public static const GET_QUOTE_VIEW_SENDINGS_AND_ADD_COVER_BREAKDOWN_CALCULATED_RATE:String="get_quote.view.sendings_and_add_cover_breakdown.calculated_rate";
		public static const GET_QUOTE_VIEW_SENDINGS_AND_ADD_COVER_BREAKDOWN_CALCULATED_PREMIUM:String="get_quote.view.sendings_and_add_cover_breakdown.calculated_premium";
		public static const GET_QUOTE_VIEW_SENDINGS_AND_ADD_COVER_BREAKDOWN_CHARGEABLE_PREMIUM:String="get_quote.view.sendings_and_add_cover_breakdown.chargeable_premium";
		public static const GET_QUOTE_VIEW_SENDINGS_AND_ADD_COVER_BREAKDOWN_TAX:String="get_quote.view.sendings_and_add_cover_breakdown.tax";
		public static const GET_QUOTE_VIEW_SENDINGS_AND_ADD_COVER_BREAKDOWN_TOTAL_SENDINGS:String="get_quote.view.sendings_and_add_cover_breakdown.total_sendings";
		public static const GET_QUOTE_VIEW_SENDINGS_AND_ADD_COVER_BREAKDOWN_TOTAL_STOCK:String="get_quote.view.sendings_and_add_cover_breakdown.total_stock";
		public static const GET_QUOTE_VIEW_SENDINGS_AND_ADD_COVER_BREAKDOWN_NUMBER_OF:String="get_quote.view.sendings_and_add_cover_breakdown.number_of";
		public static const GET_QUOTE_VIEW_SENDINGS_AND_ADD_COVER_BREAKDOWN_LIMIT_PER_EXHIBITION:String="get_quote.view.sendings_and_add_cover_breakdown.limit_per_exhibition";
		public static const GET_QUOTE_VIEW_SENDINGS_AND_ADD_COVER_BREAKDOWN_ROW_LIMIT_PER_EXHIBITION:String="get_quote.view.sendings_and_add_cover_breakdown.row_limit_per_exhibition";
		public static const GET_QUOTE_VIEW_SENDINGS_AND_ADD_COVER_BREAKDOWN_LIMIT_PER_VEHICLE:String="get_quote.view.sendings_and_add_cover_breakdown.limit_per_vehicle";
	
		// Limits View/Mediator	
		public static const LIMITS_VIEW_TITLE:String="limits.view.title";
		public static const LIMITS_VIEW_OWN_VEHICLES:String="limits.view.own_vehicles";
		public static const LIMITS_VIEW_BARGE_SHIPMENTS:String="limits.view.barge_shipments";
		public static const LIMITS_VIEW_POSTAL_LIMIT:String="limits.view.postal_limit";
		
		// maMTAOverridableLock
		public static const MA_MTA_ORVERRIDABLE_PROCEED:String=PROCEED;
		public static const MA_MTA_ORVERRIDABLE_PROCEED_CONFIRMATION:String=PROCEED_CONFIRMATION;
		public static const MA_MTA_ORVERRIDABLE_WARNING:String=WARNING;
		
		// OwnVehiclesFormItem
		public static const OWN_VEHICLES_VIEW_LIMIT:String="own_vehicles.view.limit";
		
		// SendingsForm
		public static const SENDINGS_FORM_VIEW_FIELDLOCK_CHANGE_WARNING_TEST:String="sendings_form.view.fieldLock.change_warning_test";
		public static const SENDINGS_FORM_VIEW_FIELDLOCK_CHECK_BOX_LABEL:String="sendings_form.view.fieldLock.check_box_label";
		public static const SENDINGS_FORM_VIEW_SENDINGS:String="sendings_form.view.sendings";
		// Region
		public static const SENDINGS_FORM_VIEW_ESTIMATED_TO_FROM:String="sendings_form.view.estimated_to_from";
		public static const SENDINGS_FORM_VIEW_TOTAL_SENDINGS:String="sendings_form.view.total_sendings";
		public static const SENDINGS_GRID_ROW_TRANSITS_WITHING:String="sendings_form.grid_row.transit_within";
		
		// QuoteForm View/Mediator
		
		public static const QUOTE_FORM_VIEW_PERSONAL:String="quote_form.view.personal";
		public static const QUOTE_FORM_VIEW_COVER:String="quote_form.view.cover";
		public static const QUOTE_FORM_VIEW_SENDINGS:String="quote_form.view.sendings";
		public static const QUOTE_FORM_VIEW_LIMITS:String="quote_form.view.limits";
		public static const QUOTE_FORM_VIEW_ADDIOTNAL_COVER:String="quote_form.view.addiotnal_cover";
		public static const QUOTE_FORM_VIEW_BASIS:String="quote_form.view.basis";
		public static const QUOTE_FORM_VIEW_HISTORY:String="quote_form.view.history";
		public static const QUOTE_FORM_VIEW_GET_QUOTE:String="quote_form.view.get_quote";
		public static const QUOTE_FORM_VIEW_BUTTON_BACK:String="quote_form.view.button.back";
		public static const QUOTE_FORM_VIEW_BUTTON_NEXT:String="quote_form.view.button.next";
		public static const QUOTE_FORM_VIEW_BUTTON_QUOTE_NOW:String="quote_form.view.button.quote_now";		
		
		
		public static const QUOTE_FORM_MEDIATOR_VALIDATION_REQUIRED_INCEPTION_DATE:String="quote_form.mediator.validation.required.inception_date";
		public static const QUOTE_FORM_MEDIATOR_VALIDATION_REQUIRED_EXPIRY_DATE:String="quote_form.mediator.validation.required.expiry_date";
		public static const QUOTE_FORM_MEDIATOR_VALIDATION_INVALID_INCEPTION_DATE:String="quote_form.mediator.validation.invalid.inception_date";
		public static const QUOTE_FORM_MEDIATOR_VALIDATION_INVALID_EXPIRY_DATE:String="quote_form.mediator.validation.invalid.expiry_date";
		public static const QUOTE_FORM_MEDIATOR_VALIDATION_INVALID_INCEPTION_DATE_IN_PAST:String="quote_form.mediator.validation.invalid.inception_date_in_past";
		public static const QUOTE_FORM_MEDIATOR_VALIDATION_INVALID_INCEPTION_DATE_LATER_EXPIRY_DATE:String="quote_form.mediator.validation.invalid.inception_date_later_expiry_date";
		public static const QUOTE_FORM_MEDIATOR_VALIDATION_INVALID_POLICY_END_DATE_GT_15M:String="quote_form.mediator.validation.invalid.policy_end_date_gt_15m";
		public static const QUOTE_FORM_MEDIATOR_VALIDATION_REQUIRED_ENDORSEMENT_DATE:String="quote_form.mediator.validation.required.endorsement_date";
		public static const QUOTE_FORM_MEDIATOR_VALIDATION_INVALID_ENDORSEMENT:String="quote_form.mediator.validation.invalid.endorsement_date";
		public static const QUOTE_FORM_MEDIATOR_VALIDATION_INVALID_ENDORSEMENT_DATE_TOO_EARLY:String="quote_form.mediator.validation.invalid.endorsement_date_too_early";
		public static const QUOTE_FORM_MEDIATOR_VALIDATION_INVALID_ENDORSEMENT_DATE_IN_PAST:String="quote_form.mediator.validation.invalid.endorsement_date_in_past";
		public static const QUOTE_FORM_MEDIATOR_VALIDATION_INVALID_ENDORSEMENT_DATE_LATER_POLICY_DATE:String="quote_form.mediator.validation.invalid.endorsement_date_later_policy_date";
		public static const QUOTE_FORM_MEDIATOR_EXCLUSIONS_CONFIRMATION_QUESTION:String="quote_form.mediator.exclusions.confirmation_question";
		public static const QUOTE_FORM_MEDIATOR_EXCLUSIONS_TITLE:String="quote_form.mediator.exclusions.title";
		public static const QUOTE_FORM_MEDIATOR_ON_QUOTE_MAX_EDIT_ON_QUOTE:String="quote_form.mediator.on_quote.max_edit_on_quote";
		public static const QUOTE_FORM_MEDIATOR_VALIDATION_REQUIRED_CBC_OPTION_TITLE:String="quote_form.mediator.validation.required.cbc_option.title";
		public static const QUOTE_FORM_MEDIATOR_VALIDATION_REQUIRED_CBC_OPTION_MESSAGE:String="quote_form.mediator.validation.required.cbc_option.message";
		
		// ValidationImpl
		public static const VALIDATION_INSUREDPAGE_REQUIRED_BROKER_OFFICE:String="validation.insuredPage.required.broker_office";
		public static const VALIDATION_INSUREDPAGE_REQUIRED_BROKER_CONTACT:String="validation.insuredPage.required.broker_contact";
		public static const VALIDATION_INSUREDPAGE_REQUIRED_INSURED:String="validation.insuredPage.required.insured";
		public static const VALIDATION_INSUREDPAGE_INVALID_EMAIL:String="validation.insuredPage.invalid.email";
		public static const VALIDATION_INSUREDPAGE_INVALID_EMAILCC:String="validation.insuredPage.invalid.emailcc";
		public static const VALIDATION_INSUREDPAGE_REQUIRED_FCA_OPTION:String="validation.insuredPage.required.fca_option";
		public static const VALIDATION_INSUREDPAGE_REQUIRED_SURPLUS_LINES_CONTACT:String="validation.insuredPage.required.surplus_lines_contact";
		public static const VALIDATION_INSUREDPAGE_REQUIRED_SURPLUS_LINES_STATES:String="validation.insuredPage.required.surplus_lines_states";
		public static const VALIDATION_INSUREDPAGE_REQUIRED_SURPLUS_LINES_BROKER_OFFICE:String="validation.insuredPage.required.surplus_lines_broker_office";
		public static const VALIDATION_INSUREDPAGE_REQUIRED_SURPLUS_LINES_LICENCE:String="validation.insuredPage.required.surplus_lines_licence";
		
		public static const VALIDATION_COVERTYPEPAGE_REQUIRED_SUBJECT_MATTER:String="validation.coverTypePage.required.subject_matter";
		public static const VALIDATION_COVERTYPEPAGE_REQUIRED_SUBJECT_MATTER_DETAIL:String="validation.coverTypePage.required.subject_matter_detail";
		public static const VALIDATION_COVERTYPEPAGE_REQUIRED_POLICY_END_DATE:String="validation.coverTypePage.required.policy_end_date";
		public static const VALIDATION_COVERTYPEPAGE_REQUIRED_VESSEL_NAME:String="validation.coverTypePage.required.vessel_name";
		public static const VALIDATION_COVERTYPEPAGE_REQUIRED_VESSEL_25Y:String="validation.coverTypePage.required.vessel_25y";
		public static const VALIDATION_COVERTYPEPAGE_REQUIRED_VESSEL_IACS:String="validation.coverTypePage.required.vessel_iacs";
		
		public static const VALIDATION_SENDINGSPAGE_INVALID_MAX_TOTAL_SENDINGS:String="validation.sendingsPage.invalid.max_total_sendings";
		public static const VALIDATION_SENDINGSPAGE_INVALID_MIN_TOTAL_SENDINGS:String="validation.sendingsPage.invalid.min_total_sendings";
		
		public static const VALIDATION_LIMITSPAGE_INVALID_OWN_VEHICLES_LIMIT_GOODS_TRANSIT:String="validation.limitsPage.invalid.own_vehicles_limit_goods_transit";
		public static const VALIDATION_LIMITSPAGE_REQUIRED_OWN_VEHICLES_LIMIT_GOODS_TRANSIT:String="validation.limitsPage.required.own_vehicles_limit_goods_transit";
		public static const VALIDATION_LIMITSPAGE_INVALID_OWN_VEHICLES_LIMIT_DOMESTIC_TRANSIT:String="validation.limitsPage.invalid.own_vehicles_limit_domestic_transit";
		public static const VALIDATION_LIMITSPAGE_REQUIRED_OWN_VEHICLES_LIMIT_DOMESTIC_TRANSIT:String="validation.limitsPage.required.own_vehicles_limit_domestic_transit";
		public static const VALIDATION_LIMITSPAGE_INVALID_BARGE_LIMIT_DOMESTIC_TRANSIT:String="validation.limitsPage.invalid.barge_limit_domestic_transit";
		public static const VALIDATION_LIMITSPAGE_REQUIRED_BARGE_LIMIT_DOMESTIC_TRANSIT:String="validation.limitsPage.required.barge_limit_domestic_transit";
		public static const VALIDATION_LIMITSPAGE_INVALID_LIABILITY_LIMIT_SENDING_VALUE:String="validation.limitsPage.invalid.liability_limit_sending_value";
		public static const VALIDATION_LIMITSPAGE_REQUIRED_LIABILITY_LIMIT_SENDING_VALUE:String="validation.limitsPage.required.liability_limit_sending_value";
		
		public static const VALIDATION_ADDITIONALCOVERPAGE_REQUIRED_NO_VEHICLES:String="validation.additionalCoverPage.required.no_vehicles";
		public static const VALIDATION_ADDITIONALCOVERPAGE_REQUIRED_MAX_LIMIT_PER_EXHIBITION:String="validation.additionalCoverPage.required.max_limit_per_exhibition";
		public static const VALIDATION_ADDITIONALCOVERPAGE_REQUIRED_NUMBER_OF_EXHIBITIONS:String="validation.additionalCoverPage.required.number_of_exhibitions";
		public static const VALIDATION_ADDITIONALCOVERPAGE_INVALID_TOTAL_EXHIBITIONS_INSURED:String="validation.additionalCoverPage.invalid.total_exhibitions_insured";
		public static const VALIDATION_ADDITIONALCOVERPAGE_INVALID_TOTAL_EXHIBITIONS_TERRITORY:String="validation.additionalCoverPage.invalid.total_exhibitions_territory";
		public static const VALIDATION_ADDITIONALCOVERPAGE_REQUIRED_LIMIT_PER_VEHICLE:String="validation.additionalCoverPage.required.limit_per_vehicle";
		public static const VALIDATION_ADDITIONALCOVERPAGE_REQUIRED_STOCK_LOCATION_ADDRESS:String="validation.additionalCoverPage.required.stock_location_address";
		public static const VALIDATION_ADDITIONALCOVERPAGE_REQUIRED_STOCK_LOCATION_LIMIT:String="validation.additionalCoverPage.required.stock_location_limit";
		
		public static const VALIDATION_BASISPAGE_REQUIRED_BASIS_VALUATION:String="validation.basisPage.required.basis_valuation";
		public static const VALIDATION_BASISPAGE_REQUIRED_BASIS_VALUATION_OTHER:String="validation.basisPage.required.basis_valuation_other";
		public static const VALIDATION_BASISPAGE_REQUIRED_BASIS_VALUATION_STOCK:String="validation.basisPage.required.basis_valuation_stock";
		public static const VALIDATION_BASISPAGE_REQUIRED_EXHIBITION_BASIS:String="validation.basisPage.required.exhibition_basis";
		public static const VALIDATION_BASISPAGE_REQUIRED_TOOLS_SAMPLES_BASIS:String="validation.basisPage.required.tools_samples_basis";
		
		public static const VALIDATION_CLAIMSHISTORYPAGE_REQUIRED_NO_OF_CLAIMS:String="validation.claimsHistoryPage.required.no_of_claims";
		public static const VALIDATION_CLAIMSHISTORYPAGE_REQUIRED_TOTAL_CLAIMS_AMOUNT:String="validation.claimsHistoryPage.required.total_claims_amount";
		
		public static const VALIDATION_GETQUOTEPAGE_REQUIRED_CHARGEABLE_PREMIUM:String="validation.getQuotePage.required.chargeable_premium";
		public static const VALIDATION_GETQUOTEPAGE_INVALID_COMMISION_EXECEED:String="validation.getQuotePage.invalid.commision_execeed";
		public static const VALIDATION_GETQUOTEPAGE_INVALID_MINIMUM_PREMIUM_PERCENTAGE:String="validation.getQuotePage.invalid.minimum_premium_percentage";

		// ReferralReasonsForm View/Mediator
		public static const REFERRAL_REASONS_FORM_VIEW_TITLE:String="referral_reasons_form.view.title";
		public static const REFERRAL_REASONS_FORM_VIEW_OVERRIDE_REFERRAL:String="referral_reasons_form.view.override_referral";
		public static const REFERRAL_REASONS_FORM_VIEW_OVERRIDE_ALLOWED:String="referral_reasons_form.view.override_allowed";
		public static const REFERRAL_REASONS_FORM_VIEW_REASON:String="referral_reasons_form.view.reason";
		
		// ContentArea view/Mediator
		public static const CONTENT_AREA_VIEW_TOOLTOP_NOT_ALLOWED_TO_BROKER:String="content_area.view.tooltop.not_allowed_to_broker";
		public static const CONTENT_AREA_VIEW_NEW_QUOTE:String="content_area.view.new_quote";
		public static const CONTENT_AREA_VIEW_TAB_NAV_PROPOSAL:String="content_area.view.tab_nav.proposal";
		public static const CONTENT_AREA_VIEW_TAB_NAV_REFERRAL_REASON:String="content_area.view.tab_nav.referral_reason";
		public static const CONTENT_AREA_VIEW_TAB_NAV_CLAUSES:String="content_area.view.tab_nav.clauses";
		public static const CONTENT_AREA_VIEW_TAB_NAV_HISTORY:String="content_area.view.tab_nav.history";		

		
		
		public static const CONTENT_AREA_MEDIATOR_BUTTON_ACCEPT_QUOTE:String="content_area.mediator.button_accept_quote";
		public static const CONTENT_AREA_MEDIATOR_BUTTON_FRAME_RESEND:String="content_area.mediator.button_frame_resend";
		public static const CONTENT_AREA_MEDIATOR_BUTTON_NTU:String="content_area.mediator.button_ntu";
		public static const CONTENT_AREA_MEDIATOR_BUTTON_DECLINE:String="content_area.mediator.button_decline";
		public static const CONTENT_AREA_MEDIATOR_BUTTON_EDIT:String="content_area.mediator.button_edit";
		public static const CONTENT_AREA_MEDIATOR_BUTTON_QUOTE_AGAIN:String="content_area.mediator.button_quote_again";
		public static const CONTENT_AREA_MEDIATOR_BUTTON_REACTIVATE:String="content_area.mediator.button_reactivate";
		public static const CONTENT_AREA_MEDIATOR_BUTTON_SEND_TO_BROKER:String="content_area.mediator.button_send_to_broker";
		public static const CONTENT_AREA_MEDIATOR_BUTTON_HANDLE_OFFLINE:String="content_area.mediator.button_handle_offline";
		public static const CONTENT_AREA_MEDIATOR_BUTTON_REQUEST_MTA:String="content_area.mediator.button_request_MTA";
		public static const CONTENT_AREA_MEDIATOR_BUTTON_EMAIL_DOCS:String="content_area.mediator.button_email_docs";
		public static const CONTENT_AREA_MEDIATOR_BUTTON_CANCEL_POLICY:String="content_area.mediator.button_cancel_policy";
		public static const CONTENT_AREA_MEDIATOR_BUTTON_REINSTATE:String="content_area.mediator.button_reinstate";
		public static const CONTENT_AREA_MEDIATOR_BUTTON_EXTEND_POLICY_PERIOD:String="content_area.mediator.button_extend_policy_period";

		
		public static const CONTENT_AREA_MEDIATOR_CONTENT_LABEL_NEW:String="content_area.mediator.content_label.new";	
		public static const CONTENT_AREA_MEDIATOR_CONTENT_LABEL_RENEWAL_OFFER:String="content_area.mediator.content_label.renewal_offer";
		public static const CONTENT_AREA_MEDIATOR_CONTENT_LABEL_REFERRED:String="content_area.mediator.content_label.referred";
		public static const CONTENT_AREA_MEDIATOR_CONTENT_LABEL_OFFLINE:String="content_area.mediator.content_label.offline";
		public static const CONTENT_AREA_MEDIATOR_CONTENT_LABEL_QUOTE_EXPIRED:String="content_area.mediator.content_label.quote_expired";
		public static const CONTENT_AREA_MEDIATOR_CONTENT_LABEL_CANCELLED:String="content_area.mediator.content_label.cancelled";
		public static const CONTENT_AREA_MEDIATOR_CONTENT_LABEL_EXPIRED:String="content_area.mediator.content_label.expired";
		public static const CONTENT_AREA_MEDIATOR_CONTENT_LABEL_EXPIRED_CONTEXT:String="content_area.mediator.content_label.expired.context";
		public static const CONTENT_AREA_MEDIATOR_CONTENT_LABEL_LAPSED:String="content_area.mediator.content_label.lapsed";
		public static const CONTENT_AREA_MEDIATOR_CONTENT_LABEL_NOT_TAKEN_UP:String="content_area.mediator.content_label.not_taken_up";
		public static const CONTENT_AREA_MEDIATOR_CONTENT_LABEL_DECLINED:String="content_area.mediator.content_label.declined";
		public static const CONTENT_AREA_MEDIATOR_CONTENT_LABEL_PREFIX_CANCELLATION:String="content_area.mediator.content_label.prefix.cancellation";
		public static const CONTENT_AREA_MEDIATOR_CONTENT_LABEL_PREFIX_MTA:String="content_area.mediator.content_label.prefix.mta";
		public static const CONTENT_AREA_MEDIATOR_PREMIUM_TYPE_MIN_AND_DEPOSIT:String="content_area.mediator.premium_type.min_and_deposit";
		public static const CONTENT_AREA_MEDIATOR_PREMIUM_TYPE_FLAT_NA:String="content_area.mediator.premium_type.flat_na";
		public static const CONTENT_AREA_MEDIATOR_COMISSION:String="content_area.mediator.comission";
		public static const CONTENT_AREA_MEDIATOR_NET:String="content_area.mediator.net";
		public static const CONTENT_AREA_CONTEXT_MESSAGE_RISK_LOADED_MESSAGE:String="content_area.context_message.risk_loaded.message";
		public static const CONTENT_AREA_CONTEXT_MESSAGE_DEFAULT_MESSAGE:String="content_area.context_message.default.message";		
		

		public static const CONTENT_AREA_CONTENT_LABEL:String="content_area.view.content_label";
		public static const CONTENT_AREA_CONTEXT_LABEL:String="content_area.view.context_label";
		public static const CONTENT_AREA_CONTENT_LABEL_MTA_ADD:String="content_area.view.content_label.mta_add";
		public static const CONTENT_AREA_CONTENT_LABEL_TRIA_ADD:String="content_area.view.content_label.tria_add";
		public static const CONTENT_AREA_MEDIATOR_PREMIUM:String="content_area.mediator.premium";
		public static const CONTENT_AREA_MEDIATOR_TRIA:String="content_area.mediator.tria";
		public static const CONTENT_AREA_MEDIATOR_ADDITIONAL_PREMIUM:String="content_area.mediator.additional_premium";
		public static const CONTENT_AREA_MEDIATOR_TAX:String="content_area.mediator.tax";
		public static const CONTENT_AREA_MEDIATOR_ADDITIONAL_TAX:String="content_area.mediator.additional_tax";
		public static const CONTENT_AREA_MEDIATOR_RETURN_TAX:String="content_area.mediator.return_tax";
		public static const CONTENT_AREA_MEDIATOR_RETURN_PREMIUM:String="content_area.mediator.return_premium";
		public static const CONTENT_AREA_MEDIATOR_CCY_AND_FORMAT:String="content_area.mediator.ccy_and_format";
		public static const CONTENT_AREA_MEDIATOR_WRAP_PARENTESIS:String="content_area.mediator.wrap_parentesis";
		
		public static const CONTENT_AREA_MEDIATOR_EMAIL_DOCS:String="content_area.mediator.email_docs";
		public static const CONTENT_AREA_MEDIATOR_EMAIL_DOCS_COPIEDTO:String="content_area.mediator.email_docs.copiedTo";
		
		
		public static const CONTENT_AREA_MEDIATOR_ACCEPT_QUOTE_RENEWAL_ALERT_TITLE:String="content_area.mediator.accept_quote.renewal_alert.title";
		public static const CONTENT_AREA_MEDIATOR_ACCEPT_QUOTE_RENEWAL_ALERT_MESSAGE:String="content_area.mediator.accept_quote.renewal_alert.message";
		public static const CONTENT_AREA_MEDIATOR_ACCEPT_QUOTE_CANCELLATION_ALERT_MESSAGE:String="content_area.mediator.accept_quote.cancellation_alert.message";
		public static const CONTENT_AREA_MEDIATOR_ACCEPT_QUOTE_BIND_COVER_ALERT_MESSAGE:String="content_area.mediator.accept_quote.bind_cover_alert.message";
		public static const CONTENT_AREA_MEDIATOR_ACCEPT_QUOTE_BIND_COVER_ACCEPT_TEXT:String="content_area.mediator.accept_quote.bind_cover.accept_text";		
		
		public static const CONTENT_AREA_MEDIATOR_EDIT_QUOTE:String="content_area.mediator.edit_quote";
		public static const CONTENT_AREA_MEDIATOR_PROPOSAL:String="content_area.mediator.proposal";
		public static const CONTENT_AREA_MEDIATOR_POLICY:String="content_area.mediator.policy";
		public static const CONTENT_AREA_MEDIATOR_RISK_SUPERSEDED:String="content_area.mediator.risk.superseded";
		public static const CONTENT_AREA_MEDIATOR_RISK_SUPERSEDED_PENDING_MTA:String="content_area.mediator.risk.superseded_pending_mta";

		
		public static const LOOK_AND_FEEL_PREVIEW_VIEW_TITLE:String="look_and_feel_preview_view.title";
		public static const LOOK_AND_FEEL_PREVIEW_VIEW_INTRO:String="look_and_feel_preview_view.intro";
		public static const LOOK_AND_FEEL_PREVIEW_VIEW_FOOTER:String="look_and_feel_preview_view.footer";
		
		public static const LOOK_AND_FEEL_PREVIEW_VIEW_NEW_QUOTE_BUTTON:String="look_and_feel_preview_view.new_quote_button";
		public static const LOOK_AND_FEEL_PREVIEW_VIEW_COMBOBOX:String="look_and_feel_preview_view.combobox";
		public static const LOOK_AND_FEEL_PREVIEW_VIEW_DATAGRID:String="look_and_feel_preview_view.datagrid";
		public static const LOOK_AND_FEEL_PREVIEW_VIEW_DATAGRID_NAME:String="look_and_feel_preview_view.datagrid.name";
		public static const LOOK_AND_FEEL_PREVIEW_VIEW_DATAGRID_DATE:String="look_and_feel_preview_view.datagrid.date";
		public static const LOOK_AND_FEEL_PREVIEW_VIEW_DATAGRID_TOTAL:String="look_and_feel_preview_view.datagrid.total";
		public static const LOOK_AND_FEEL_PREVIEW_VIEW_MULTISTEP_NAVIGATOR:String="look_and_feel_preview_view.multistep_navigator";
		public static const LOOK_AND_FEEL_PREVIEW_VIEW_CONTROL_BAR:String="look_and_feel_preview_view.control_bar";		
		
		
		public static const TRIA_INSURANCE_VIEW_TITLE:String = "tria_insurance_view.title";
		public static const TRIA_INSURANCE_VIEW_INTRO:String = "tria_insurance_view.intro";
		public static const TRIA_INSURANCE_VIEW_AFFIRMATIVE_QUESTION:String = "tria_insurance_view.affirmative_question";
		public static const TRIA_INSURANCE_VIEW_NEGATIVE_QUESTION:String = "tria_insurance_view.negative_question";
		public static const TRIA_INSURANCE_VIEW_ERROR_MESSAGE:String = "tria_insurance_view.error_message";
		
		public static const GRID_EXPORT_UTILS_SAVE_FILE_FILENAME_PREFIX:String ="grid_export_utils.save_file.filename_prefix";
		public static const GRID_EXPORT_UTILS_SAVE_FILE_SAVED_TITLE:String = "grid_export_utils.save_file.saved_title";
		public static const GRID_EXPORT_UTILS_SAVE_FILE_SAVED_DESCRIPTION:String = "grid_export_utils.save_file.saved_description";
		public static const GRID_EXPORT_UTILS_SAVE_FILE_ERROR_TITLE:String = "grid_export_utils.save_file.error_title";
		public static const GRID_EXPORT_UTILS_SAVE_FILE_ERROR_DESCRIPTION:String ="grid_export_utils.save_file.error_description";		

		// Tooltips
		
		//-- General -->
		public static const TOOLTIP_GENERAL_SEARCH:String="tooltip.general.search";		
		public static const TOOLTIP_GENERAL_POSTCODE:String="tooltip.general.postcode";
		
		//-- Personal -->
		public static const TOOLTIP_PERSONAL_CC_EMAIL:String="tooltip.personal.cc_email";
		public static const TOOLTIP_PERSONAL_BROKER_REFERENCE:String="tooltip.personal.broker_reference";
		public static const TOOLTIP_PERSONAL_INSURED_NAME:String="tooltip.personal.insured_name";
		public static const TOOLTIP_PERSONAL_FINANCIAL_CONDUCT_AUTHORTITY:String="tooltip.personal.financial_conduct_authortity";
		//public static const TOOLTIP_PERSONAL_SURPLUS_BROKER_LINES:String="tooltip.personal.surplus_broker_lines";
		
		
		//-- Cover -->
		public static const TOOLTIP_COVER_COVER_TYPE:String="tooltip.cover.cover_type";
		public static const TOOLTIP_COVER_SUBJECT_MATTER_INSURED:String="tooltip.cover.subject_matter_insured";
		public static const TOOLTIP_COVER_SUBJECT_MATTER_DETAIL:String="tooltip.cover.subject_matter_detail";
		public static const TOOLTIP_COVER_ENDORSEMENT_START_DATE:String="tooltip.cover.endorsement_start_date";
		public static const TOOLTIP_COVER_INCEPTION_DATE:String="tooltip.cover.inception_date";
		public static const TOOLTIP_COVER_VESSEL_NAME:String="tooltip.cover.vessel_name";
		
		//-- Sendings -->
		public static const TOOLTIP_SENDINGS_GOODS_IN_TRANSIT_WITHIN_COUNTRY:String="tooltip.sendings.goods_in_transit_within_country"; 
		public static const TOOLTIP_SENDINGS_UK_FOB:String="tooltip.sendings.uk_fob";
		public static const TOOLTIP_SENDINGS_IMPORT_EXPORT_WORLD:String="tooltip.sendings.import_export_world_of_world";
		public static const TOOLTIP_SENDINGS_IMPORT_EXPORT_ASIA:String="tooltip.sendings.import_export_asia";
		public static const TOOLTIP_SENDINGS_IMPORT_EXPORT_WESTERN_EUROPE:String="tooltip.sendings.import_export_western_europe"; 
		public static const TOOLTIP_SENDINGS_IMPORT_EXPORT_EASTERN_EUROPE:String="tooltip.sendings.import_export_eastern_europe"; 
		public static const TOOLTIP_SENDINGS_IMPORT_EXPORT_NORTH_AMERICA:String="tooltip.sendings.import_export_north_america"; 
		public static const TOOLTIP_SENDINGS_IMPORT_EXPORT_MIDDLE_EAST:String="tooltip.sendings.import_export_middle_east"; 
		public static const TOOLTIP_SENDINGS_IMPORT_EXPORT_FAR_EAST:String="tooltip.sendings.import_export_far_east"; 
		public static const TOOLTIP_SENDINGS_IMPORT_EXPORT_REST_OF_WORLD:String="tooltip.sendings.import_export_rest_of_world";
		public static const TOOLTIP_SENDINGS_IMPORT_EXPORT_CENTRAL:String="tooltip.sendings.import_export_central";
		public static const TOOLTIP_SENDINGS_BUYERS_SELLERS_INTEREST_CONTINGENCY:String="tooltip.sendings.buyers_sellers_interest_contingency";
	
		//-- Limits -->
		public static const TOOLTIP_LIMITS_SENDINGS_LIMIT:String="tooltip.limits.sendings_limit";
		public static const TOOLTIP_LIMITS_SENDINGS_LIMIT_READONLY:String="tooltip.limits.sendings_limit_readonly";
		public static const TOOLTIP_LIMITS_OWN_VEHICLES:String="tooltip.limits.own_vehicles";
		public static const TOOLTIP_LIMITS_BARGE_LIMIT:String="tooltip.limits.barge_limit";
		public static const TOOLTIP_LIMITS_POSTAL_LIMIT:String="tooltip.limits.postal_limit";
		
		//-- Additional Cover -->    
		public static const TOOLTIP_ADDCOVER_STOCK_COVER_OUTSIDE_ORDINARY_TRANSIT:String="tooltip.addcover.stock_cover_outside_ordinary_transit";
		public static const TOOLTIP_ADDCOVER_IPT_GOODS_STORE_EXCESS_60_DAYS:String="tooltip.addcover.ipt_goods_store_excess_60_days";
		public static const TOOLTIP_ADDCOVER_STOCK_COVER_OUTSIDE_UK:String="tooltip.addcover.stock_cover_outside_uk";
		public static const TOOLTIP_ADDCOVER_EXHIBITION_COVER:String="tooltip.addcover.exhibition_cover";
		public static const TOOLTIP_ADDCOVER_COVER_EXCESS_OF_30_DAYS:String="tooltip.addcover.cover_excess_of_30_days";
		public static const TOOLTIP_ADDCOVER_TOTAL_EXHIBITIONS_PER_ANNUM_UK:String="tooltip.addcover.total_exhibitions_per_annum_uk";
		public static const TOOLTIP_ADDCOVER_LIMIT_PER_EXHIBITION_UK:String="tooltip.addcover.limit_per_exhibition_uk";
		public static const TOOLTIP_ADDCOVER_TOTAL_EXHIBITIONS_PER_ANNUM_ROW:String="tooltip.addcover.total_exhibitions_per_annum_row";
		public static const TOOLTIP_ADDCOVER_LIMIT_PER_EXHIBITION_ROW:String="tooltip.addcover.limit_per_exhibition_row";
		public static const TOOLTIP_ADDCOVER_TOOLS_AND_SAMPLES_COVER:String="tooltip.addcover.tools_and_samples_cover";
		public static const TOOLTIP_ADDCOVER_STOCK_COVER_OVERSEAS_COVER:String="tooltip.addcover.stock_cover_overseas_cover";
		public static const TOOLTIP_ADDCOVER_NSI_ALARM:String="tooltip.addcover.nsi_alarm";
		public static const TOOLTIP_ADDCOVER_STD_CONSTRUCTION:String="tooltip.addcover.std_construction";
		public static const TOOLTIP_ADDCOVER_CAT_PERILS_RESTRICTED_AREAS:String="tooltip.addcover.cat_perils_restricted_areas";
		
		//-- Tools and samples grid -->
		public static const TOOLTIP_TOOLSANDSAMPLES_TOTAL_VEHICLES:String="tooltip.toolsandsamples.total_vehicles";
		public static const TOOLTIP_TOOLSANDSAMPLES_LIMIT_PER_VEHICLE:String="tooltip.toolsandsamples.limit_per_vehicle";
	
		//-- Basis of Valuation -->  
		public static const TOOLTIP_BOV_GOODS_IN_TRANSIT_WITHIN_UK:String="tooltip.bov.goods_in_transit_within_uk";
		public static const TOOLTIP_BOV_UK_UP_TO_FOB:String="tooltip.bov.uk_up_to_fob";
		public static const TOOLTIP_BOV_IMPORT_EXPORT:String="tooltip.bov.import_export";
		public static const TOOLTIP_BOV_BUYERS_SELLERS_INTEREST_CONTINGENCY:String="tooltip.bov.buyers_sellers_interest_contingency";
		public static const TOOLTIP_BOV_EXHIBITIONS:String="tooltip.bov.exhibitions";
		public static const TOOLTIP_BOV_TOOLS_AND_SAMPLES:String="tooltip.bov.tools_and_samples";
		
		//-- Deductibles  -->
		public static const TOOLTIP_DED_GOODS_IN_TRANSIT_WITHIN_UK:String="tooltip.ded.goods_in_transit_within_uk";
		public static const TOOLTIP_DED_UK_UP_TO_FOB:String="tooltip.ded.uk_up_to_fob";
		public static const TOOLTIP_DED_IMPORT_EXPORT:String="tooltip.ded.import_export"; 
		public static const TOOLTIP_DED_BUYERS_SELLERS_INTEREST_CONTINGENCY:String="tooltip.ded.buyers_sellers_interest_contingency"; 
		public static const TOOLTIP_DED_EXHIBITIONS:String="tooltip.ded.exhibitions";
		public static const TOOLTIP_DED_TOOLS_AND_SAMPLES:String="tooltip.ded.tools_and_samples";
		
		//-- Claims History -->  
		public static const TOOLTIP_CLAIMS_SUBMITTED_LAST_3_YEARS:String="tooltip.claims.claims_submitted_last_3_years";
		public static const TOOLTIP_CLAIMS_TOTAL_CLAIM_AMOUNT:String="tooltip.claims.total_claim_amount";
		
		//-- Get Quote  -->
		public static const TOOLTIP_GET_QUOTE_QUOTE_COMMISSION:String="tooltip.get_quote.quote_commission";
		public static const TOOLTIP_GET_QUOTE_COMMISSION:String="tooltip.get_quote.commission";
		
		
		// Dates / Time / Currency
		private static const TIME_FORMAT:String='time_format';
		private static const DATE_FORMAT:String='date_format';
		private static const CURRENCY_PRECISION:String='currency_precision';
		private static const CURRENCY_SYMBOL:String='currency_symbol';
		private static const THOUSANDS_SEPARATOR:String='thousands_separator';
		private static const DECIMAL_SEPARATOR:String='decimal_separator';

		
		
		
		private static var _dateFormatter:DateFormatter;

		public static function getDateFormatter():DateFormatter {
			if (_dateFormatter == null) {
				_dateFormatter=new DateFormatter();
				_dateFormatter.formatString=ResourceManager.getInstance().getString(RB_ui.RB_NAME, RB_ui.DATE_FORMAT);
			}
			return _dateFormatter;
		}

		public static function getDate(date:Object):String {
			return getDateFormatter().format(date);
		}
		
		public static function get rm():IResourceManager {
			return ResourceManager.getInstance();
		}

		public static function resolveDataBaseCode(item:Object, params:Array = null, codeName:String='code', defaultName:String='name'):String {
			if (item.hasOwnProperty(codeName)) {
				var tmpCode:String=ResourceManager.getInstance().getString(RB_ui.RB_NAME, item[codeName] as String, params);
				return (tmpCode && tmpCode.length > 0) ? tmpCode : item.name as String;
			}
			return item[defaultName] as String;
		}

		/**
		 * We cannot apply the same solution as with "resolveDataBaseCode" as this returns the key that will be 
		 * resolved later as part od the ToolTip Helper.
		 */		
		public static function resolveSendingsToolTipCodes(prefix:String, suffix:String):String {
			
			//trace ("Prefix: " + prefix + " - Suffix: " + suffix); 
			
			if (prefix == "FREE_ON_BOARD") {
				switch (suffix) {
					case "DOMESTIC":
						return TOOLTIP_SENDINGS_UK_FOB;
				}
			} else if (prefix == "IMPORT_EXPORT") {
				switch (suffix) {
					case "WESTERN_EUROPE":
						return TOOLTIP_SENDINGS_IMPORT_EXPORT_WESTERN_EUROPE;
					case "EASTERN_EUROPE":
						return TOOLTIP_SENDINGS_IMPORT_EXPORT_EASTERN_EUROPE;				
					case "MIDDLE_EAST":
						return TOOLTIP_SENDINGS_IMPORT_EXPORT_MIDDLE_EAST;
					case "FAR_EAST":
						return TOOLTIP_SENDINGS_IMPORT_EXPORT_FAR_EAST;					
					case "ROW":
						return TOOLTIP_SENDINGS_IMPORT_EXPORT_REST_OF_WORLD;
					case "NORTH_AMERICA":
						return TOOLTIP_SENDINGS_IMPORT_EXPORT_NORTH_AMERICA;
					case "ASIA":
						return TOOLTIP_SENDINGS_IMPORT_EXPORT_ASIA;
					case "WORLD":
						return TOOLTIP_SENDINGS_IMPORT_EXPORT_WORLD;
					case "CENTRAL":
						return TOOLTIP_SENDINGS_IMPORT_EXPORT_CENTRAL;						
						
				}	
			} else if (prefix == "BUYER_SELLER") {
				switch (suffix) {
					case "BS":
						return TOOLTIP_SENDINGS_BUYERS_SELLERS_INTEREST_CONTINGENCY;
				}	
			} else if (prefix == "GOODS_IN_TRANSIT") {
				switch (suffix) {
					case "DOMESTIC":
						return TOOLTIP_SENDINGS_GOODS_IN_TRANSIT_WITHIN_COUNTRY;
				}	
			} 				
			return "";
		}
		
	}
}
