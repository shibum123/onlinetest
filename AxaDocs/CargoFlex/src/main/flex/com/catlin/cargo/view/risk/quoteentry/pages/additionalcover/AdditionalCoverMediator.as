package com.catlin.cargo.view.risk.quoteentry.pages.additionalcover
{

	import com.catlin.cargo.ApplicationFacade;
	import com.catlin.cargo.bundles.RB_ui;
	import com.catlin.cargo.controller.UpdateLimitsAndDeductiablesCommand;
	import com.catlin.cargo.model.core.covertype.CoverTypeCode;
	import com.catlin.cargo.model.core.originatingoffice.OriginatingOfficeCode;
	import com.catlin.cargo.model.core.risk.CatastropheCover;
	import com.catlin.cargo.model.core.risk.ExhibitionCover;
	import com.catlin.cargo.model.core.risk.Risk;
	import com.catlin.cargo.model.core.risk.StockCover;
	import com.catlin.cargo.model.core.risk.StockLocation;
	import com.catlin.cargo.model.core.risk.ToolsAndSamplesCover;
	import com.catlin.cargo.model.geo.address.Address;
	import com.catlin.cargo.model.proxy.CountryProxy;
	import com.catlin.cargo.model.proxy.ExchangeRateProxy;
	import com.catlin.cargo.model.reference.country.Region;
	import com.catlin.cargo.model.reference.country.Territory;
	import com.catlin.cargo.model.reference.deductible.Deductible;
	import com.catlin.cargo.view.BaseMediator;
	import com.catlin.cargo.view.address.AddressWindow;
	import com.catlin.cargo.view.risk.quoteentry.NearestValueCalculator;
	
	import flash.events.Event;
	
	import org.puremvc.as3.interfaces.IMediator;
	import org.puremvc.as3.interfaces.INotification;

	public class AdditionalCoverMediator extends BaseMediator implements IMediator
	{

		public static const NAME:String='AdditionalCoverMediator';

		private var _quote:Risk;

		private var locationIndex:Number;
		private var deductiblesMap:Object;
		private var nearestValueCalculator:NearestValueCalculator=new NearestValueCalculator();

		public function AdditionalCoverMediator(viewComponent:Object)
		{
			super(NAME, viewComponent);

			additionalCover.addEventListener(AdditionalCover.ADD_STOCK, onAddStock);
			additionalCover.addEventListener(AdditionalCover.ADD_EXHIBITION, onAddExhibition);
			additionalCover.addEventListener(AdditionalCover.ADD_TOOLS, onAddTools);
			additionalCover.addEventListener(AdditionalCover.ADD_STOCK_CAT, onAddStock);
			additionalCover.addEventListener(StockLocationDeleteEvent.DELETE_STOCK_LOCATION, onDeleteStockLocation);
			additionalCover.addEventListener(StockLocationAddressEvent.STOCK_LOCATION_ADDRESS_ENTER, onEnterAddress);
			additionalCover.addEventListener(StockLocationAddressEvent.STOCK_LOCATION_ADDRESS_EDIT, onEditAddress);

			// US view restrictions:
			super.addClientSpecificRestrictedComponent(additionalCover.fmiStockCoverQ2, OriginatingOfficeCode.US);
			super.addClientSpecificRestrictedComponent(additionalCover.fmiCoverRequiredInExcessOf30Day , OriginatingOfficeCode.US);
			super.addClientSpecificRestrictedComponent(additionalCover.fmiStockCoverQ4RequiredOnRestrictedAreas , OriginatingOfficeCode.US, true, true);
			//super.addClientSpecificRestrictedComponent(additionalCover.fmiStockCoverQ5OverseasCover, OriginatingOfficeCode.US, true , true);

			// HK view restrictions 
			super.addClientSpecificRestrictedComponent(additionalCover.vboxStockCover, OriginatingOfficeCode.HK, false , false);

			// SG view restrictions
			super.addClientSpecificRestrictedComponent(additionalCover.vboxStockCover, OriginatingOfficeCode.SG, false , false);

			// This method might be called from the onAddStock() or/and onAddExhibition instead.
			// It is properly working so far as currently the only way yo change the sessionLocale is by 
			// logging off and then logging in again so should not be an issue.
			super.applyClientSpecificViewRestrictions();
		}

		private function onEnterAddress(event:StockLocationAddressEvent):void
		{
			locationIndex=event.index;

			var view:AddressWindow=new AddressWindow();
			view.title=rm.getString(RB_ui.RB_NAME, RB_ui.ADDITIONAL_COVER_NEW_QUOTE_ADDRESS_ENTER_STOCK_LOCATION);
			var mediator:StockLocationAddressWindowMediator=ApplicationFacade.addPopUpWindow(view, StockLocationAddressWindowMediator) as StockLocationAddressWindowMediator;
			populateCountryComboBox(mediator, _quote.brokerOffice.countryOfRisk);
		}

		private function onEditAddress(event:StockLocationAddressEvent):void
		{
			locationIndex=event.index;
			var sl:StockLocation=_quote.stockCover.locations.getItemAt(locationIndex) as StockLocation;

			var view:AddressWindow=new AddressWindow();
			view.title=rm.getString(RB_ui.RB_NAME, RB_ui.ADDITIONAL_COVER_NEW_QUOTE_ADDRESS_EDIT_STOCK_LOCATION);
			var mediator:StockLocationAddressWindowMediator=ApplicationFacade.addPopUpWindow(view, StockLocationAddressWindowMediator) as StockLocationAddressWindowMediator;
			mediator.address=sl.address;
			populateCountryComboBox(mediator, _quote.brokerOffice.countryOfRisk);
		}

		private function populateCountryComboBox(mediator:StockLocationAddressWindowMediator, territoryOfRisk:Territory):void {
			mediator.country = territoryOfRisk.getCountry();
			if (territoryOfRisk is Region) {
				mediator.setRegionMode();
				sendNotification(CountryProxy.LIST_COUNTRIES_OF_RISK_REGION_COMPLETE, (territoryOfRisk as Region).getCountries());
			} else {
				mediator.setCountryMode();
				mediator.showCountry(false);
			}
		}

		public function onAddressDetailsEntered(address:Address):void
		{
			var sl:StockLocation=_quote.stockCover.locations.getItemAt(locationIndex) as StockLocation;
			sl.address=address;
			additionalCover.stockLocationGrid.updateAddressLabels();
		}

		public function set currentQuote(quote:Risk):void
		{
			_quote=quote;
		}

		private function get additionalCover():AdditionalCover
		{
			return viewComponent as AdditionalCover;
		}

		private function onAddStock(event:Event):void
		{
			switch (event.type) {
				case AdditionalCover.ADD_STOCK:
					if (additionalCover.requireStockCoverGroup.selectedValue == rm.getString(RB_ui.RB_NAME, RB_ui.YES) ) {
						_quote.stockCover=new StockCover();
						_quote.stockCover.configure(ApplicationFacade.getInstance().sessionOriginatingOfficeCode);
						_quote.stockCover.deductibles=nearestValueCalculator.deriveDefault(_quote.subjectMatter.stockCoverDeductiblesDefault, _quote.currency, 
							Deductible.getDeductiblesForCoverTypeGroup(deductiblesMap, CoverTypeCode.STOCK));
						_quote.stockCover.addDefaultEntry();
					} else {
						_quote.stockCover=null;
					}
					break;
				case AdditionalCover.ADD_STOCK_CAT:
					if (_quote.stockCover != null ) {
						if (additionalCover.stockRequiredOnRestrictedAreasGroup.selectedValue == rm.getString(RB_ui.RB_NAME, RB_ui.YES) ) {
							_quote.stockCover.stockRequiredOnRestrictedAreas = true;
							_quote.stockCover.catastropheCover = new CatastropheCover();
							_quote.stockCover.catastropheCover.deductibles=nearestValueCalculator.deriveDefault(
								_quote.subjectMatter.getDeductibleDefaultValueByCoverTypeCodeFor(CoverTypeCode.STOCK_CATASTROPHE), 
								_quote.currency, Deductible.getDeductiblesForCoverTypeGroup(deductiblesMap, CoverTypeCode.STOCK_CATASTROPHE));
						} else {
							_quote.stockCover.stockRequiredOnRestrictedAreas = false;
							_quote.stockCover.catastropheCover = null;
						}
					} else {
						throw(new Error("IncosistenState"));
					}
					break;
			}
			sendNotification(ApplicationFacade.REFRESH_COVER_DEDUCTIBLE);
		}

		private function onDeleteStockLocation(event:StockLocationDeleteEvent):void
		{
			if (_quote.stockCover.locations.length > 1)
			{
				_quote.stockCover.locations.removeItemAt(event.index);
			}
		}

		private function onAddExhibition(event:Event):void
		{
			if (additionalCover.requireExhibitionCoverGroup.selectedValue == rm.getString(RB_ui.RB_NAME, RB_ui.YES))
			{
				_quote.exhibitionCover=new ExhibitionCover();
				_quote.exhibitionCover.deductibles=nearestValueCalculator.deriveDefault(_quote.subjectMatter.exhibitionCoverDeductiblesDefault, _quote.currency, 
					Deductible.getDeductiblesForCoverTypeGroup(deductiblesMap, CoverTypeCode.EXHIBITION));
			}
			else
			{
				_quote.exhibitionCover=null;
			}
			sendNotification(ApplicationFacade.REFRESH_COVER_DEDUCTIBLE);
		}

		private function onAddTools(event:Event):void
		{
			if (additionalCover.requireToolsAndSamplesCoverGroup.selectedValue == rm.getString(RB_ui.RB_NAME, RB_ui.YES))
			{
				_quote.toolsAndSamplesCover=new ToolsAndSamplesCover();
				_quote.toolsAndSamplesCover.deductibles=nearestValueCalculator.deriveDefault(_quote.subjectMatter.toolsAndSamplesCoverDeductiblesDefault, _quote.currency, 
					Deductible.getDeductiblesForCoverTypeGroup(deductiblesMap, CoverTypeCode.TOOLS_AND_SAMPLES));
			}
			else
			{
				_quote.toolsAndSamplesCover=null;
			}
			sendNotification(ApplicationFacade.REFRESH_COVER_DEDUCTIBLE);
		}

		override public function listNotificationInterests():Array
		{
			return [StockLocationAddressWindowMediator.ADDRESS_ENTERED, StockLocationAddressWindowMediator.ADDRESS_CANCELLED, ExchangeRateProxy.LIST_EXCHANGE_RATES_COMPLETE, UpdateLimitsAndDeductiablesCommand.FIND_DEDUCTABLES_COMPLETE];
		}

		override public function handleNotification(note:INotification):void
		{
			switch (note.getName())
			{
				case StockLocationAddressWindowMediator.ADDRESS_ENTERED:
					onAddressDetailsEntered(note.getBody() as Address);
					break;
				case StockLocationAddressWindowMediator.ADDRESS_CANCELLED:
					break;
				case ExchangeRateProxy.LIST_EXCHANGE_RATES_COMPLETE:
					nearestValueCalculator.exchangeRates=note.getBody();
					break;
				case UpdateLimitsAndDeductiablesCommand.FIND_DEDUCTABLES_COMPLETE:
					deductiblesMap=note.getBody();
					break;
			}
		}
	}
}
