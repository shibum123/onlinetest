package com.catlin.cargo.view.address {
	
	import com.catlin.cargo.ApplicationFacade;
	import com.catlin.cargo.model.geo.address.Address;
	import com.catlin.cargo.model.reference.country.Country;
	
	import flash.errors.IllegalOperationError;
	import flash.events.MouseEvent;
	
	import org.puremvc.as3.patterns.mediator.Mediator;

	public class AddressWindowMediator extends Mediator {
		
		private var addressMediator:AddressMediator;
		
		public function AddressWindowMediator(_name:String, self:AddressWindowMediator, viewComponent:IAddressView) {
			super(_name, viewComponent);
			
			if (self != this) {
				throw new IllegalOperationError("AddressCaptureMediator is abstract - instantiate one of its sub-classes");
			}
			
			addressWindow.buttonBar.btnOK.addEventListener(MouseEvent.CLICK, onOK);
			addressWindow.buttonBar.btnCancel.addEventListener(MouseEvent.CLICK, onCancel);
			
		}
		
		public override function onRegister():void {
			super.onRegister();
			addressMediator = new addressMediatorClass(viewComponent);
			facade.registerMediator(addressMediator);
		}
		
		public override function onRemove():void {
			super.onRemove();
			facade.removeMediator(addressMediatorName);
		}
		
		public function set editMode(editMode:Boolean):void {
			if (editMode) {
				addressWindow.title = editModeTitle;
				addressWindow.label = editModeTitle;			
			}
		}
		
		public function set address(_address:Address): void {
			addressMediator.address = _address;
		}
		
		public function set country(_country:Country):void {
			addressMediator.country = _country;
		}
		
		protected function get editModeTitle(): String {
			return null;
		}
		
		public function set setTitle(title:String):void {
			addressWindow.title = title;
			addressWindow.label = title;
		}
		
		public function get addressWindow():AddressWindow {
			return viewComponent as AddressWindow;
		}
		
		public function onCancel(event:MouseEvent):void {
			ApplicationFacade.closePopUpWindow(addressWindow, name);
			sendNotification(cancelledEventName);
		}

		public function onOK(event:MouseEvent):void {
			if (!(addressMediator.validate())) {
				return; // Fields in error
			}
			var address:Address = new Address();
			addressMediator.updateAddress(address);
			sendNotification(enteredEventName, address);
			ApplicationFacade.closePopUpWindow(addressWindow, name);
		}
		
		protected function get cancelledEventName():String {
			throw new Error("Create a subclass and override this method");
		}
		
		protected function get enteredEventName():String {
			throw new Error("Create a subclass and override this method");
		}
		
		protected function get name():String {
			throw new Error("Create a subclass and override this method");
		}
		
		protected function get addressMediatorClass():Class {
			throw new Error("Create a subclass and override this method");
		}
		
		protected function get addressMediatorName():String {
			throw new Error("Create a subclass and override this method");
		}

		public function setRegionMode():void {
			addressMediator.setRegionMode();
		}

		public function setCountryMode():void {
			addressMediator.setCountryMode();
		}
	}
}