package com.catlin.cargo.view {
	
	import com.catlin.cargo.ApplicationFacade;
	import com.catlin.cargo.model.core.originatingoffice.OriginatingOfficeCode;
	
	import flash.utils.Dictionary;
	
	import mx.collections.ArrayList;
	import mx.collections.IList;
	import mx.core.UIComponent;
	import mx.resources.IResourceManager;
	import mx.resources.ResourceManager;
	
	import org.puremvc.as3.patterns.mediator.Mediator;

	public class BaseMediator extends Mediator {
		
		public function BaseMediator(mediatorName:String, viewComponent:Object) {
			super(mediatorName, viewComponent);
		}
		
		protected function get rm():IResourceManager {
			return ResourceManager.getInstance();
		}
		
		/**
		 * The following methods provides the basic functionality to show/hide enable/disable 
		 * view elements based on the ApplicationFacade.getInstance().sessionLocale.
		 * 
		 * This restrictions must be defined on the specific view mediator.
		 */

		protected var _clientSpecificComponents:Dictionary = new Dictionary();

		/**
		 * This method is used to group all the client specific restricted component by sessionLocale.
		 */
		protected function addClientSpecificRestrictedComponent(component:UIComponent, originatingOfficeCode:OriginatingOfficeCode, visible:Boolean = false, includeInLayout:Boolean = false, enabled:Boolean = true):void {
			if (!_clientSpecificComponents[originatingOfficeCode])
				_clientSpecificComponents[originatingOfficeCode] = new ArrayList();
			var cmpList:IList = _clientSpecificComponents[originatingOfficeCode];
			cmpList.addItem(new ComponentRestrictionProperties(component, visible, includeInLayout, enabled)); 
		}
		
		/**
		 * Applies the locale specifc rules based on the sessionLocale.
		 */
		protected function applyClientSpecificViewRestrictions():void {
			var cmpList:ArrayList = _clientSpecificComponents[ApplicationFacade.getInstance().sessionOriginatingOfficeCode];
			if (cmpList!= null) {
				for (var i:int = 0; i < cmpList.length; i++) {
					var viewItem:ComponentRestrictionProperties = (cmpList.getItemAt(i) as ComponentRestrictionProperties);
					viewItem.applyProperties();
				}
			}
		}
	}
}

import mx.core.UIComponent;

class ComponentRestrictionProperties {
	
	private var _visible:Boolean;
	private var _enabled:Boolean;
	private var _includeInLayout:Boolean;
	private var _cmp:UIComponent;
	
	public function ComponentRestrictionProperties(cmp:UIComponent, visible:Boolean = false, includeInLayout:Boolean = false, enabled:Boolean = true) {
		this._cmp = cmp;
		this._enabled = enabled;
		this._includeInLayout = includeInLayout;
		this._visible = visible;
	}
	
	public function applyProperties():void {
		_cmp.visible = _visible;
		_cmp.enabled = _enabled;
		_cmp.includeInLayout = _includeInLayout;
	}
}
