package com.catlin.cargo {
	import com.catlin.cargo.bundles.RB_ui;
	import com.catlin.cargo.view.admin.AdministrationDivBox;
	import com.catlin.cargo.view.admin.AdministrationDivBoxMediator;
	import com.catlin.cargo.view.footer.FooterMediator;
	import com.catlin.cargo.view.header.HeaderMediator;
	import com.catlin.cargo.view.help.ContactUsDivBoxMediator;
	import com.catlin.cargo.view.help.UsefulLinksVBoxMediator;
	import com.catlin.cargo.view.leftarea.LeftAreaMediator;
	import com.catlin.cargo.view.profile.ChangePasswordMediator;
	import com.catlin.cargo.view.reports.ReportsMediator;
	import com.catlin.cargo.view.risk.ContentAreaMediator;
	
	import mx.resources.ResourceManager;
	
	import org.puremvc.as3.interfaces.IMediator;
	import org.puremvc.as3.patterns.mediator.Mediator;

	public class CargoFlexMediator extends Mediator implements IMediator {
			
		public static const NAME:String = 'CargoFlexMediator';

		public function CargoFlexMediator(viewComponent:CargoFlex) {
			super(NAME, viewComponent);

			if (ApplicationFacade.getInstance().userInfo.isUnderwriter) {
				var admin:AdministrationDivBox = new AdministrationDivBox();
				admin.label = ResourceManager.getInstance().getString(RB_ui.RB_NAME, RB_ui.ADMINISTRATION_TITLE);
				admin.id = ApplicationFacade.ADMIN_VIEW_ID;
				admin.percentWidth = 100;
				admin.percentHeight = 100;
				facade.registerMediator( new AdministrationDivBoxMediator( admin ) );
				cargoFlex.mainPanel.addChildAt(admin, 3);
			}
		}

		public function get cargoFlex():CargoFlex {
			return viewComponent as CargoFlex;
		}
		
		override public function onRegister():void {
			super.onRegister();
			facade.registerMediator( new LeftAreaMediator( cargoFlex.quoteView.leftArea ) );
			facade.registerMediator( new ContentAreaMediator( cargoFlex.quoteView.contentArea ) );
			facade.registerMediator( new ContactUsDivBoxMediator( cargoFlex.divContactUs ) );
			facade.registerMediator( new ChangePasswordMediator( cargoFlex.divProfile.changePasswordForm  ) );
			facade.registerMediator( new HeaderMediator( cargoFlex.header) );
			facade.registerMediator( new FooterMediator( cargoFlex.footer ) );
			facade.registerMediator( new UsefulLinksVBoxMediator( cargoFlex.divUsefulLinks ) );
			facade.registerMediator( new ReportsMediator( cargoFlex.divReports ) );
		}

	}
}