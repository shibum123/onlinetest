package com.catlin.cargo.view.address {
	import com.catlin.cargo.ApplicationFacade;
	import com.catlin.cargo.view.address.events.PostCodeLookupFormEvent;
	import com.catlin.cargo.view.address.vo.PostCodeLookupFormVO;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import mx.collections.IList;
	import mx.events.FlexEvent;
	
	import org.puremvc.as3.interfaces.IMediator;
	import org.puremvc.as3.patterns.mediator.Mediator;

	public class PostcodeLookupMediator extends Mediator implements IMediator {

		public static const NAME:String='PostcodeLookupMediator';

		public function PostcodeLookupMediator(viewComponent:Object) {
			super(NAME, viewComponent);

			postcodeLookupForm.buttonBar.btnCancel.addEventListener(FlexEvent.BUTTON_DOWN, onCancel);

			postcodeLookupForm.buttonBar.btnOK.enabled=false;
			postcodeLookupForm.buttonBar.btnOK.addEventListener(FlexEvent.BUTTON_DOWN, onOK);
			postcodeLookupForm.upButton.addEventListener(MouseEvent.CLICK, onUpButton);

			postcodeLookupForm.lstAddresses.addEventListener(PostCodeLookupFormEvent.POSTCODE_LOOKUPFORM_RETRIEVE, onListItemClick);
			postcodeLookupForm.lstAddresses.addEventListener(PostCodeLookupFormEvent.POSTCODE_LOOKUPFORM_FIND, onExplodeSearchClick);
			postcodeLookupForm.lstAddresses.addEventListener(MouseEvent.CLICK, onClick);

		}

		private function onClick(item:Event):void {
			postcodeLookupForm.buttonBar.btnOK.enabled=false;
			if (postcodeLookupForm.lstAddresses.selectedItem) {
				var selectedItem:PostCodeLookupFormVO = postcodeLookupForm.lstAddresses.selectedItem as PostCodeLookupFormVO;
				if (selectedItem.readyToRetrieve())
					postcodeLookupForm.buttonBar.btnOK.enabled=true;
			}
			postcodeLookupForm.lstAddresses.invalidateList();
		}

		private function onListItemClick(event:PostCodeLookupFormEvent):void {
			if (event.data.readyToRetrieve())
				postcodeLookupForm.buttonBar.btnOK.enabled=true;
			else
				postcodeLookupForm.buttonBar.btnOK.enabled=false;
			postcodeLookupForm.lstAddresses.invalidateList();
		}

		private function onExplodeSearchClick(event:PostCodeLookupFormEvent):void {
			if (event.data.children.length > 0) {
				this.setModel(event.data);
			} else {
				if (!event.data.readyToRetrieve()) {
					sendNotification(ApplicationFacade.LOOKUP_POSTCODE,
						{code: event.data.id, countryIsoCode: event.data.isoCountryCode, parent: event.data});
				}
			}
			postcodeLookupForm.lstAddresses.invalidateList();
		}

		public function onCancel(event:FlexEvent):void {
			ApplicationFacade.closePopUpWindow(postcodeLookupForm, NAME);
		}

		public function onUpButton(event:Event):void {
			postcodeLookupForm.buttonBar.btnOK.enabled=false;
			if (model.parent) {
				this.model=this.model.parent;
				this.setAddresses(model.children);
				this.updateDisplay();
			}
		}

		public function onOK(event:FlexEvent):void {
			if (postcodeLookupForm.lstAddresses.selectedItem) {
				var selectedItem:PostCodeLookupFormVO=postcodeLookupForm.lstAddresses.selectedItem as PostCodeLookupFormVO
				sendNotification(ApplicationFacade.FETCH_POSTCODE,
					{code: selectedItem.id, countryIsoCode: selectedItem.isoCountryCode});
				ApplicationFacade.closePopUpWindow(postcodeLookupForm, NAME);
			} else {
				postcodeLookupForm.buttonBar.btnOK.enabled=false;
			}
		}

		protected function setAddresses(addresses:IList):void {
			postcodeLookupForm.lstAddresses.dataProvider=addresses;
		}

		public function get postcodeLookupForm():PostcodeLookupForm {
			return viewComponent as PostcodeLookupForm;
		}

		private var model:PostCodeLookupFormVO=null;

		public function setModel(newModel:PostCodeLookupFormVO):void {
			newModel.parent=this.model;
			this.model=newModel;
			this.setAddresses(model.children);
			this.updateDisplay();
			postcodeLookupForm.lstAddresses.invalidateList();
		}

		private function updateDisplay():void {
			this.updateLabels();
			postcodeLookupForm.upButton.visible=model.parent != null ? true : false;
		}

		private function updateLabels():void {
			if (model)
				postcodeLookupForm.updateLabels(model.isoCountryCode);
			else
				postcodeLookupForm.updateLabels();
		}
	}
}
