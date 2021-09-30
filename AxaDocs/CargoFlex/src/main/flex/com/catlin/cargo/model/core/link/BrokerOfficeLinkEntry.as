/**
 * Generated by Gas3 v2.2.0 (Granite Data Services).
 *
 * NOTE: this file is only generated if it does not exist. You may safely put
 * your custom code here.
 */

package com.catlin.cargo.model.core.link {
	import flash.utils.IExternalizable;
	
	import mx.utils.UIDUtil;
	
	import org.granite.meta;

	use namespace meta;

	[Bindable]
	[RemoteClass(alias="com.catlin.cargo.model.core.link.BrokerOfficeLinkEntry")]
	public class BrokerOfficeLinkEntry extends BrokerOfficeLinkEntryBase implements IExternalizable {

		private static const _importedClasses:Array=[LinkUrl];

		private var _tempUid:String=null;

		override public function set uid(value:String):void {
			super.uid=value;
		}

		override public function get uid():String {
			if (isNaN(sid)) {
				if (_tempUid == null) {
					_tempUid=UIDUtil.createUID();
				}
				return _tempUid;
			}
			return super.uid;
		}

		public function get name():String {
			return link ? link.name : "";
		}
		
		public var inheritedFromMasterOffice:Boolean=false;
	}
}
