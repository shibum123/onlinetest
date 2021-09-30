package com.catlin.cargo.view.footer
{
	import com.catlin.cargo.ApplicationFacade;
	import com.catlin.cargo.view.BaseMediator;
	import com.catlin.cargo.view.terms.TermsOfUseTitleWindow;
	import com.catlin.cargo.view.terms.TermsOfUseTitleWindowMediator;
	
	import mx.events.FlexEvent;
	
	import org.puremvc.as3.interfaces.IMediator;

	public class FooterMediator extends BaseMediator implements IMediator {
		
		public static const NAME:String = 'FooterMediator';	
	
		public function FooterMediator(viewComponent:Object) {
			super(NAME, viewComponent);
			footer.btnTerms.addEventListener(FlexEvent.BUTTON_DOWN, onTermsOfUse);
			//footer.locales.selectedItem = ApplicationFacade.getInstance().currentLocale;
			//footer.locales.addEventListener(Event.CHANGE,  onLocaleChange);
		}
		
		public function get footer():Footer {
			return viewComponent as Footer;
		}
		
		private function onTermsOfUse(event:FlexEvent):void {
			ApplicationFacade.openPopUpWindow(TermsOfUseTitleWindow, TermsOfUseTitleWindowMediator);
		}
		
		/*			
		override public function listNotificationInterests():Array {
			return [ ApplicationFacade.LOCALE_CHANGED ];
		}
	
		override public function handleNotification(note:INotification):void {
			switch (note.getName()) {
				case ApplicationFacade.LOCALE_CHANGED:
					footer.locales.selectedItem = ApplicationFacade.getInstance().currentLocale;
					break;
			}
		}
		
		protected function onLocaleChange(event:ListEvent):void {
			//ApplicationFacade.getInstance().currentLocale=footer.locales.selectedItem.toString();
			ApplicationFacade.getInstance().initializeLocalization();
		}
		*/		
	}
}