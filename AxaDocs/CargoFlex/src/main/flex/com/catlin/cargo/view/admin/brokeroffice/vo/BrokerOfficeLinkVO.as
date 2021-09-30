package com.catlin.cargo.view.admin.brokeroffice.vo
{
	import com.catlin.cargo.model.core.link.BrokerOfficeLinkEntry;
	import com.catlin.cargo.model.core.link.LinkUrl;

	[Bindable]
	public class BrokerOfficeLinkVO
	{
		private var linkUrl:LinkUrl;
		private var brokerOfficeLinkEntry:BrokerOfficeLinkEntry;
		private var isEmpty:Boolean = false;
		
		public function BrokerOfficeLinkVO(singletonEnforcer:SingletonEnforcer)
		{
		}
		
		public static function createFromLinkUrl(linkUrl:LinkUrl):BrokerOfficeLinkVO {
			var ret:BrokerOfficeLinkVO = new BrokerOfficeLinkVO(new SingletonEnforcer());
			ret.linkUrl = linkUrl;
			return ret;
		}	
		
		public static function createFromBrokerOfficeLinkEntry(brokerOfficeLinkEntry:BrokerOfficeLinkEntry):BrokerOfficeLinkVO {
			var ret:BrokerOfficeLinkVO = new BrokerOfficeLinkVO(new SingletonEnforcer());
			ret.brokerOfficeLinkEntry = brokerOfficeLinkEntry;
			return ret;
		}
		
		public static function createEmpty():BrokerOfficeLinkVO {
			var ret:BrokerOfficeLinkVO = new BrokerOfficeLinkVO(new SingletonEnforcer());
			ret.isEmpty = true;
			return ret;
		}		
		
		public function get link():Object {
			if (!isEmpty)
				return linkUrl ? linkUrl : brokerOfficeLinkEntry;
			return null;
		}
		
		public function get name():String {
			if (!isEmpty)
				return linkUrl ? linkUrl.name : brokerOfficeLinkEntry.link.name;
			return "";
		}
		
		public function get description():String {
			if (!isEmpty)
				return linkUrl ? linkUrl.description : brokerOfficeLinkEntry.link.description;
			return "";
		}

		public function get url():String {
			if (!isEmpty)
				return linkUrl ? linkUrl.url : brokerOfficeLinkEntry.link.url;
			return "";
		}
		
		public function get active():Boolean {
			if (!isEmpty)
				return linkUrl ? linkUrl.active : brokerOfficeLinkEntry.link.active;
			return false;
		}
		
		public function get displayOrder():Number {
			if (!isEmpty)
				return linkUrl ? 0 : brokerOfficeLinkEntry.displayOrder;
			return 0;
		}
		
		public function get inheritedFromMasterOffice():Boolean {
			if (!isEmpty)
				return linkUrl ? false : brokerOfficeLinkEntry.inheritedFromMasterOffice;
			return false;
		}	
		
	}
}
class SingletonEnforcer{}