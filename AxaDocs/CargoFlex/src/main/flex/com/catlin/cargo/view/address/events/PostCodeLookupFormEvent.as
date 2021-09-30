package com.catlin.cargo.view.address.events {
	import com.catlin.cargo.view.address.vo.PostCodeLookupFormVO;

	import flash.events.Event;

	public class PostCodeLookupFormEvent extends Event {

		public static const POSTCODE_LOOKUPFORM_RETRIEVE:String="POSTCODE_LOOKUPFORM_RETRIEVE";
		public static const POSTCODE_LOOKUPFORM_FIND:String="POSTCODE_LOOKUPFORM_FIND";

		public var data:PostCodeLookupFormVO;

		public function PostCodeLookupFormEvent(type:String, data:PostCodeLookupFormVO, bubbles:Boolean=true, cancelable:Boolean=false) {
			super(type, bubbles, cancelable);
			this.data = data;
		}
	}
}
