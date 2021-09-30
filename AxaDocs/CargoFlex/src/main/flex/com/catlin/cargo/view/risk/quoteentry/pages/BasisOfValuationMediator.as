package com.catlin.cargo.view.risk.quoteentry.pages {
	
	import com.catlin.cargo.ApplicationFacade;
	import com.catlin.cargo.LazyCollectionExecutor;
	import com.catlin.cargo.controller.UpdateLimitsAndDeductiablesCommand;
	import com.catlin.cargo.model.core.covertype.CoverTypeCode;
	import com.catlin.cargo.model.core.risk.PremiumType;
	import com.catlin.cargo.model.core.risk.Risk;
	import com.catlin.cargo.model.core.risk.Sendings;
	import com.catlin.cargo.model.proxy.ReferenceDataProxy;
	import com.catlin.cargo.model.reference.deductible.Deductible;
	import com.catlin.cargo.model.security.UserInfo;
	import com.catlin.cargo.view.BaseMediator;
	import com.catlin.ui.flex.widgets.general.ComboBox;
	
	import flash.events.Event;
	
	import mx.collections.ArrayCollection;
	import mx.collections.IList;
	import mx.core.Repeater;
	
	import org.puremvc.as3.interfaces.IMediator;
	import org.puremvc.as3.interfaces.INotification;
	
	public class BasisOfValuationMediator extends BaseMediator implements IMediator {
		
		public static const NAME:String='BasisOfValuationMediator';
		public static const OVERRIDE_LOCK_UPDATED:String='OVERRIDE_DEDUCTIBLES_LOCK_UPDATED';
		
		private var _quote:Risk;
		private var costsMap:Object;
		
		[Bindable]
		public var userInfo:UserInfo=null;
		
		[Bindable]
		public var overridenDeductiblesLock:Boolean=false;
		
		public function BasisOfValuationMediator(viewComponent:Object) {
			super(NAME, viewComponent);
			
			basis.exhibitionsDeductibles.addEventListener(Event.CHANGE, onExhibitionDeductibleChange);
			basis.stockDeductibles.addEventListener(Event.CHANGE, onStockDeductibleChange);
			basis.stockCatDeductibles.addEventListener(Event.CHANGE, onStockCatastropheDeductibleChange);
			basis.toolsAndSamplesDeductibles.addEventListener(Event.CHANGE, onTaSDeductibleChange);
			
			basis.fieldLock.overridenLockChangeEventName=OVERRIDE_LOCK_UPDATED;
			basis.fieldLock.addEventListener(OVERRIDE_LOCK_UPDATED, updateDeductiblesOverrideLock)
			basis.fieldLock.overridenLock=overridenDeductiblesLock;
		}
		private function get basis():BasisOfValuation {
			return viewComponent as BasisOfValuation;
		}
		
		public function set currentQuote(quote:Risk):void {
			_quote=quote;
		}
		
		override public function listNotificationInterests():Array {
			return [UpdateLimitsAndDeductiablesCommand.FIND_DEDUCTABLES_COMPLETE, ApplicationFacade.REFRESH_COVER_DEDUCTIBLE,
				ReferenceDataProxy.FIND_ALL_BASIS_OF_VALUATION_STOCK_PERCENTAGES_COMPLETE, ReferenceDataProxy.FIND_ALL_BASIS_OF_VALUATION_IMPORT_EXPORT_PERCENTAGES_COMPLETE];
		}
		
		override public function handleNotification(note:INotification):void {
			switch (note.getName()) {
				case UpdateLimitsAndDeductiablesCommand.FIND_DEDUCTABLES_COMPLETE:
					costsMap=note.getBody();
					updateDeductibles(note);
					break;
				case ApplicationFacade.REFRESH_COVER_DEDUCTIBLE:
					updateDeductibles(note);
					break;
				case ReferenceDataProxy.FIND_ALL_BASIS_OF_VALUATION_STOCK_PERCENTAGES_COMPLETE:
					basis.stockPercentages=note.getBody() as ArrayCollection;
					break;
				case ReferenceDataProxy.FIND_ALL_BASIS_OF_VALUATION_IMPORT_EXPORT_PERCENTAGES_COMPLETE:
					basis.importExportPercentages=note.getBody() as ArrayCollection;
					break;
			}
		}
		
		private function updateDeductibles(note:INotification):void {
			if (_quote.exhibitionCover != null) {
				basis.exhibitionsDeductibles.dataProvider=Deductible.getDeductiblesForCoverTypeGroup(costsMap, CoverTypeCode.
					EXHIBITION);
				basis.exhibitionsDeductibles.selectedItem=_quote.exhibitionCover.deductibles;
				basis.exhibitionsDeductibles.enabled=canDeductiblesBeEdited(_quote, userInfo, !overridenDeductiblesLock,
					CoverTypeCode.EXHIBITION);
			}
			if (_quote.toolsAndSamplesCover != null) {
				basis.toolsAndSamplesDeductibles.dataProvider=Deductible.getDeductiblesForCoverTypeGroup(costsMap, CoverTypeCode.
					TOOLS_AND_SAMPLES);
				basis.toolsAndSamplesDeductibles.selectedItem=_quote.toolsAndSamplesCover.deductibles;
				basis.toolsAndSamplesDeductibles.enabled=canDeductiblesBeEdited(_quote, userInfo, !overridenDeductiblesLock,
					CoverTypeCode.TOOLS_AND_SAMPLES);
			}
			if (_quote.stockCover != null) {
				basis.stockDeductibles.dataProvider=Deductible.getDeductiblesForCoverTypeGroup(costsMap, CoverTypeCode.STOCK);
				basis.stockDeductibles.selectedItem=_quote.stockCover.deductibles;
				basis.stockDeductibles.enabled=canDeductiblesBeEdited(_quote, userInfo, !overridenDeductiblesLock, CoverTypeCode.
					STOCK);
				
				if (_quote.stockCover.catastropheCover != null && _quote.stockCover.stockRequiredOnRestrictedAreas == true) {
					basis.stockCatDeductibles.dataProvider=Deductible.getDeductiblesForCoverTypeGroup(costsMap, CoverTypeCode.
						STOCK_CATASTROPHE);
					basis.stockCatDeductibles.selectedItem=_quote.stockCover.catastropheCover.deductibles;
					basis.stockCatDeductibles.enabled=canDeductiblesBeEdited(_quote, userInfo, !overridenDeductiblesLock,
						CoverTypeCode.STOCK_CATASTROPHE);
				}
			}
			if (_quote.sendings != null) {
				new LazyCollectionExecutor(_quote.sendings, updateDeductibleRepeater).execute();
			}
		}
		
		private function updateDeductibleRepeater(obj:Object=null):void {
			var repeater:Repeater=basis.deductibleRepeater as Repeater;
			repeater.dataProvider=_quote.sendings as IList;
			for each (var formItem:DeductibleFormItem in basis.deductibleFormItem) {
				formItem.deductibleAmount.dataProvider=Deductible.getDeductiblesForCoverTypeGroup(costsMap, CoverTypeCode.
					valueOf(formItem.sending.type.code));
				formItem.deductibleAmount.selectedItem=formItem.sending.deductibles;
				formItem.deductiblesEditable=canDeductiblesBeEditedForRepeater(_quote, userInfo, !overridenDeductiblesLock,
					formItem.sending);
			}
		}
		
		protected function onTaSDeductibleChange(event:Event):void {
			var coverComboBox:ComboBox=event.currentTarget as ComboBox;
			if (_quote.toolsAndSamplesCover != null) {
				_quote.toolsAndSamplesCover.deductibles=coverComboBox.selectedItem as Number;
			}
		}
		
		protected function onStockCatastropheDeductibleChange(event:Event):void {
			var coverComboBox:ComboBox=event.currentTarget as ComboBox;
			if (_quote.stockCover != null && _quote.stockCover.catastropheCover != null) {
				_quote.stockCover.catastropheCover.deductibles=coverComboBox.selectedItem as Number;
			}
		}
		
		protected function onStockDeductibleChange(event:Event):void {
			var coverComboBox:ComboBox=event.currentTarget as ComboBox;
			if (_quote.stockCover != null) {
				_quote.stockCover.deductibles=coverComboBox.selectedItem as Number;
			}
		}
		
		public function onExhibitionDeductibleChange(event:Event):void {
			var coverComboBox:ComboBox=event.currentTarget as ComboBox;
			if (_quote.exhibitionCover != null) {
				_quote.exhibitionCover.deductibles=coverComboBox.selectedItem as Number;
			}
		}
		
		protected function canDeductiblesBeEditedForRepeater(quote:Risk, userInfo:UserInfo, lockNotOveridden:Boolean, currentItem:Object):Boolean {
			return canDeductiblesBeEdited(quote, userInfo, lockNotOveridden, CoverTypeCode.valueOf((currentItem as Sendings).
				type.code));
		}
		
		protected function canDeductiblesBeEdited(quote:Risk, userInfo:UserInfo, lockNotOveridden:Boolean, coverTypeCode:CoverTypeCode):Boolean {
			var isQuoteEditable:Boolean=quote.editable;
			var isMTA:Boolean=quote.isMidTermAdjustment();
			var isUnderwriter:Boolean=userInfo.isUnderwriter;
			var isAsianOffice:Boolean=userInfo.isAsianOriginatingOffice();
			var mad:Boolean=(quote.premiumType == PremiumType.MAD);
			var isDeductibleEditable:Boolean=(quote.subjectMatter == null ? false : quote.subjectMatter.getDeductibleEditableFor(coverTypeCode));
			
			if (userInfo == null) {
				return false;
			}
			
			// isDeductibleEditable: this variable comes from the database and in case it is false, then 
			// it rules any underwriter's business logic.
			if (!isDeductibleEditable) {
				return isDeductibleEditable;
			}
			
			if (isAsianOffice) {
				return (isQuoteEditable && (!(isMTA) || isUnderwriter)) && !(mad && isMTA && (!isUnderwriter || lockNotOveridden));
			} else {
				return (isUnderwriter && isQuoteEditable) && !(mad && isMTA && (!isUnderwriter || lockNotOveridden));
			}
		}
		
		private function updateDeductiblesOverrideLock(event:Event):void {
			overridenDeductiblesLock=!overridenDeductiblesLock;
			sendNotification(ApplicationFacade.REFRESH_COVER_DEDUCTIBLE);
		}
	
	}
}
