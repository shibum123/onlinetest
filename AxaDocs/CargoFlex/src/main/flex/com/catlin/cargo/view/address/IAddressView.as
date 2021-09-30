package com.catlin.cargo.view.address {
	import com.catlin.ui.flex.widgets.general.ComboBox;
	
	import mx.containers.FormItem;
	import mx.controls.Button;
	import mx.controls.TextInput;
	
	public interface IAddressView {
		
		function get postcodeLookupTextComponent():TextInput;
		
		function get postcodeLookupActionComponent():Button;
		
		function get addressLine1Component():TextInput;
		
		function get addressLine1FormItem():FormItem;
		
		function get addressLine2Component():TextInput;
		
		function get addressLine3Component():TextInput;
		
		function get townCityComponent():TextInput;
		
		function get townCityFormItem():FormItem;

		function get countyComponent():TextInput;

		function get provinceComboBox():ComboBox;
		
		function get postcodeComponent():TextInput;
		
		function get postcodeFormItem():FormItem;
		
		/**
		 * Optional - returns the combo box used to
		 * select the country - return <code>null</code>
		 * if the view does not maintain the country.
		 */
		function get countryComboBox():ComboBox;

		function showCounty(show:Boolean):void;

		function showProvince(show:Boolean):void;
		
		function showPostcodeLookup(show:Boolean):void;
		
		function set currentCountryIso(isoCode:String):void;
		
		function get currentCountryIso():String;
	}
}