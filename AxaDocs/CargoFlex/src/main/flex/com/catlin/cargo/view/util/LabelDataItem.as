package com.catlin.cargo.view.util
{
	[Bindable]
	public class LabelDataItem
	{
		public var data:Object;
		public var label:String;
		
		public function LabelDataItem(label:String, data:Object) {
			this.data = data;
			this.label = label;
		}
	
	}
}