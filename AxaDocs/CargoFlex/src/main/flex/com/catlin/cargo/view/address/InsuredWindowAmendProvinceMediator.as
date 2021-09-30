package com.catlin.cargo.view.address {
	
	import com.catlin.cargo.ApplicationFacade;
	import com.catlin.cargo.bundles.RB_ui;
	import com.catlin.cargo.model.core.insured.Insured;
	import com.catlin.cargo.model.geo.address.Address;
	import com.catlin.cargo.model.reference.country.Province;
	import com.catlin.cargo.view.BaseMediator;
	
	import flash.events.MouseEvent;

	public class InsuredWindowAmendProvinceMediator extends BaseMediator {

		public static const NAME:String = "InsuredCaptureMediator";
		public static const INSURED_WINDOW_AMEND_PROVINCE_CANCELLED:String = "InsuredWindowAmendProvinceCancelled";
		public static const INSURED_WINDOW_AMEND_PROVINCE_COMPLETED:String = "InsuredWindowAmendProvinceCompleted";
		
		private var addressMediator:InsuredWindowAddressMediator;

		[Bindable]
		protected var _insured:Insured;
		
		public function InsuredWindowAmendProvinceMediator(viewComponent:Object) {
			super(NAME, viewComponent);

			insuredCaptureForm.disableAllComponents();
			insuredCaptureForm.provinceComboBox.enabled = true;
			
			insuredCaptureForm.title = rm.getString(RB_ui.RB_NAME, RB_ui.INSURED_WINDOW_AMEND_PROVINCE_TITLE);
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

		public function set insured(insured:Insured): void {
			_insured = insured;
			insuredCaptureForm.txiName.text = _insured.name;
			addressMediator.address = _insured.address;
		}

		public function get insuredCaptureForm():InsuredWindow {
			return viewComponent as InsuredWindow;
		}

		public function onCancel(event:MouseEvent):void {
			ApplicationFacade.closePopUpWindow(insuredCaptureForm, NAME);
			sendNotification(INSURED_WINDOW_AMEND_PROVINCE_CANCELLED);
		}

		public function onOK(event:MouseEvent):void {

			var addressSuccess:Boolean = addressMediator.validate();

			if (!addressSuccess) {
				return; // Fields in error
			}

			var _selectedProvince:Province = addressMediator.addressView.provinceComboBox.selectedItem as Province;
			if (_selectedProvince) {
				_insured.address.province = _selectedProvince;
			}

			var insured:Insured = new Insured();
			insured.sid = _insured.sid;
			insured.name = _insured.name;
			insured.address = new Address();
			addressMediator.updateAddress(insured.address);	

			_insured.address = insured.address;
			sendNotification(INSURED_WINDOW_AMEND_PROVINCE_COMPLETED, insured);
			ApplicationFacade.closePopUpWindow(insuredCaptureForm, NAME);
		}
	}
}