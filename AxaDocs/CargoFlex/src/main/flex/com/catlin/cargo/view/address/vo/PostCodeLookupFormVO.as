package com.catlin.cargo.view.address.vo
{
	import mx.collections.ArrayCollection;
	import mx.collections.IList;
	
	[Bindable]
	public class PostCodeLookupFormVO
	{
		
		public static const STATUS_RETRIEVE:String='Retrieve';
		public static const STATUS_FIND:String='Find';
		
		public var parent:PostCodeLookupFormVO;
		
		public var id:String;
		public var address:String;
		public var status:String;
		public var description:String;
		public var isoCountryCode:String;
		public var children:IList;
		public var currentSearchKey:String;
		
		public function PostCodeLookupFormVO(
				id:String, 
				address:String,
				isoCountryCode:String,
				currentSearchKey:String,
				description:String = null,
				status:String = STATUS_RETRIEVE)
		{
			this.id = id;
			this.address = address;
			this.status = status;
			this.currentSearchKey = currentSearchKey;
			this.description = description;
			this.isoCountryCode = isoCountryCode;
			
			children = new ArrayCollection();    
		}
		
		public function addChild(item:PostCodeLookupFormVO):void {
			this.children.addItem(item);
		}
		
		public function readyToRetrieve():Boolean {
			return this.status == STATUS_RETRIEVE ? true : false; 
		}
		
	}
}