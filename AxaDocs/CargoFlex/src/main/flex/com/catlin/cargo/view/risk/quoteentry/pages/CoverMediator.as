package com.catlin.cargo.view.risk.quoteentry.pages {
	import com.catlin.cargo.ApplicationFacade;
	import com.catlin.cargo.bundles.RB_ui;
	import com.catlin.cargo.model.proxy.LocaleProxy;
	import com.catlin.cargo.view.BaseMediator;
	
	import org.puremvc.as3.interfaces.IMediator;
	import org.puremvc.as3.interfaces.INotification;

	public class CoverMediator extends BaseMediator implements IMediator {


		public static const NAME:String='CoverMediator';

		public function CoverMediator(viewComponent:Object) {
			super(NAME, viewComponent);
			
			if (ApplicationFacade.getInstance().localeFormat) {
				updateDynamicLabels();
			}
		}
		
		override public function listNotificationInterests():Array {
			return [LocaleProxy.RETRIEVE_LOCALE_FORMAT_COMPLETE];
		}
		
		override public function handleNotification(note:INotification):void {
			switch (note.getName()) {
				case LocaleProxy.RETRIEVE_LOCALE_FORMAT_COMPLETE:
					updateDynamicLabels();
					break;
			}
		}
		
		private function get cover():Cover {
			return viewComponent as Cover;
		}
		
		private function updateDynamicLabels():void {
			var localeFormat:String = ApplicationFacade.getInstance().localeFormat.dateShort4Year2MonthDay;
			cover.inceptionDateLabel.label = rm.getString(RB_ui.RB_NAME, RB_ui.COVER_VIEW_INCEPTION_DATE, [localeFormat]);
			cover.expiryDateLabel.label = rm.getString(RB_ui.RB_NAME, RB_ui.COVER_VIEW_EXPIRY_DATE, [localeFormat]);
			cover.endorsementDateLabel.label = rm.getString(RB_ui.RB_NAME, RB_ui.COVER_VIEW_ENDORSEMENT_START_DATE, [localeFormat]);
			
			cover.policyStartDate.formatString = localeFormat;
			cover.policyEndDate.formatString = localeFormat;
			cover.endorsementStartDate.formatString = localeFormat;
		}
		
	}
	
}
