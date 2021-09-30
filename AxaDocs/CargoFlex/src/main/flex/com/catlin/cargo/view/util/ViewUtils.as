package com.catlin.cargo.view.util {
	import mx.controls.TextInput;
	import mx.core.IContainer;
	import mx.core.UIComponent;
	
	public class ViewUtils 	{
		
		public static function deepDisableTextInputs(container:IContainer):void {
			for (var i:int = 0; i < container.numChildren; i++) {
				var child:UIComponent = container.getChildAt(i) as UIComponent;
				if (child is IContainer) {
					deepDisableTextInputs(child as IContainer);
				} else if (child is TextInput) {
					child.enabled = false;
				}
			}
		}
		
	}
}