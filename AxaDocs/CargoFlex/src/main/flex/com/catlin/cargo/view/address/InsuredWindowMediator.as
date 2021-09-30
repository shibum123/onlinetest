package com.catlin.cargo.view.address {
	
	import com.catlin.cargo.ApplicationFacade;
	import com.catlin.cargo.bundles.RB_ui;
	import com.catlin.cargo.model.core.insured.Insured;
	import com.catlin.cargo.model.geo.address.Address;
	import com.catlin.cargo.model.reference.country.Country;
	import com.catlin.cargo.validation.ValidationUtil;
	import com.catlin.cargo.view.BaseMediator;
	
	import flash.events.MouseEvent;

	public class InsuredWindowMediator extends BaseMediator {
		
		public static const NAME:String = "InsuredCaptureMediator";
		public static const INSURED_WINDOW_ENTERED:String = "InsuredWindowEntered";
		public static const INSURED_WINDOW_CANCELLED:String = "InsuredCancelledEntered";
		
		private var addressMediator:InsuredWindowAddressMediator;
		
		private var insuredSid:Number;
		private var editModeFlag:Boolean = false;
		
		public function InsuredWindowMediator(viewComponent:Object) {
			super(NAME, viewComponent);
		}
		
		public override function onRegister():void {
			super.onRegister();
			insuredCaptureForm.buttonBar.btnOK.addEventListener(MouseEvent.CLICK, onOK);
			insuredCaptureForm.buttonBar.btnCancel.addEventListener(MouseEvent.CLICK, onCancel);
			addressMediator = new InsuredWindowAddressMediator(viewComponent as IAddressView);
			facade.registerMediator(addressMediator);
		}
		
		public override function onRemove():void {
			super.onRemove();
			facade.removeMediator(InsuredWindowAddressMediator.NAME);
		}
		
		public function set editMode(editMode:Boolean):void {
			if (editMode) {
				editModeFlag = true;
				insuredCaptureForm.title = editModeTitle;
				insuredCaptureForm.label = editModeTitle;			
			}
		} 
		
		public function set insured(_insured:Insured): void {
			insuredSid = _insured.sid;
			insuredCaptureForm.txiName.text = _insured.name;
			addressMediator.address = _insured.address;
		}
		
		public function set defaultCountry(_country:Country):void {
			addressMediator.country = _country;
		}

		protected function get editModeTitle(): String {
			return "Edit insured details";
		}
		
		public function set setTitle(title:String):void {
			insuredCaptureForm.title = title;
			insuredCaptureForm.label = title;
		}
		
		public function get insuredCaptureForm():InsuredWindow {
			return viewComponent as InsuredWindow;
		}
		
		public function onCancel(event:MouseEvent):void {
			ApplicationFacade.closePopUpWindow(insuredCaptureForm, NAME);
			sendNotification(INSURED_WINDOW_CANCELLED);
		}

		public function onOK(event:MouseEvent):void {

			var thisSuccess:Boolean = ValidationUtil.valueRequired(insuredCaptureForm.txiName, rm.getString(RB_ui.RB_NAME, RB_ui.INSURED_WINDOW_MEDIATOR_VALIDATION_REQUIRED_NAME)) == ValidationUtil.FALSE;
			var addressSuccess:Boolean = addressMediator.validate();
			
			if (!(thisSuccess && addressSuccess)) {
				return; // Fields in error
			}
			var insured:Insured = new Insured();
			if (editModeFlag) {
				insured.sid = insuredSid;
			}
			insured.name = insuredCaptureForm.txiName.text;
			insured.address = new Address();
			addressMediator.updateAddress(insured.address);
			sendNotification(INSURED_WINDOW_ENTERED, insured);
			ApplicationFacade.closePopUpWindow(insuredCaptureForm, NAME);
		}
	}
}