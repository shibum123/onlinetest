package com.catlin.cargo.view.admin.brokeroffice
{
	import com.catlin.cargo.ApplicationFacade;
	import com.catlin.cargo.model.core.brokeroffice.BrokerOffice;
	import com.catlin.cargo.model.core.link.BrokerOfficeLinkEntry;
	import com.catlin.cargo.model.core.link.LinkUrl;
	import com.catlin.cargo.model.proxy.UsefulLinkProxy;
	import com.catlin.cargo.view.BaseMediator;
	import com.catlin.cargo.view.admin.brokeroffice.vo.BrokerOfficeLinkVO;
	import com.catlin.ui.flex.validator.PageValidator;
	
	import flash.events.Event;
	import flash.utils.Dictionary;
	
	import mx.collections.ArrayCollection;
	import mx.collections.ICollectionView;
	import mx.collections.IList;
	import mx.collections.ListCollectionView;
	import mx.collections.Sort;
	import mx.collections.SortField;
	import mx.controls.Alert;
	import mx.controls.List;
	import mx.controls.TileList;
	import mx.core.UIComponent;
	import mx.events.DragEvent;
	import mx.events.FlexEvent;
	import mx.events.ItemClickEvent;
	import mx.events.ListEvent;
	import mx.managers.DragManager;
	
	import org.puremvc.as3.interfaces.INotification;
	
	public class BrokerOfficeLinksVBoxMediator extends BaseMediator
	{
		public static const NAME:String = 'BrokerLinksVBoxMediator';
		
		[Bindable]
		private var brokerOffice:BrokerOffice;
		
		[Bindable]
		private var brokerOfficeLink:LinkUrl;
		
		[Bindable]
		private var brokerOfficeLinks:ArrayCollection;
		
		private var validation:BrokerOfficeLinksValidationImpl = new BrokerOfficeLinksValidationImpl();
		private var fieldValidator:PageValidator = new PageValidator();
		private var linkProxy:UsefulLinkProxy;		
		
		public function BrokerOfficeLinksVBoxMediator(viewComponent:BrokerOfficeLinksVBox)
		{
			super(NAME, viewComponent);

			validation.window = view;
			fieldValidator.multiPageValidator.rules = validation.create();
			
			linkProxy = facade.retrieveProxy(UsefulLinkProxy.NAME) as UsefulLinkProxy;
			linkProxy.listLinks();
			
			view.btnCreateLink.addEventListener(FlexEvent.BUTTON_DOWN, onCreateLink);
			view.btnSaveLink.addEventListener(FlexEvent.BUTTON_DOWN, onSaveLink);
			
			view.allLinks.addEventListener(ItemClickEvent.ITEM_CLICK, onSelectLink);
			view.cbxShowArchived.addEventListener(Event.CHANGE, onSelectArchivedLinks);
			view.btnSave.addEventListener(FlexEvent.BUTTON_DOWN, onSave);

			brokerOfficeLinks = new ArrayCollection();
			
			view.brokerOfficeUsefulLinks.tileList.selectable  = true;
			view.brokerOfficeUsefulLinks.dataProvider = brokerOfficeLinks;
			//view.brokerOfficeUsefulLinks.sortField = "displayOrder";
			view.brokerOfficeUsefulLinks.tileList.dragEnabled = true;
			view.brokerOfficeUsefulLinks.tileList.dropEnabled = true;
			view.brokerOfficeUsefulLinks.tileList.allowDragSelection = false;
			view.brokerOfficeUsefulLinks.tileList.allowMultipleSelection = false;
			
			view.brokerOfficeUsefulLinks.tileList.addEventListener(DragEvent.DRAG_DROP, onDropHandler, false, 1); 
			view.brokerOfficeUsefulLinks.tileList.addEventListener(DragEvent.DRAG_ENTER, onDragHandler);
			
			view.allLinks.dragEnabled = true;
			view.allLinks.allowDragSelection = false;
			view.allLinks.allowMultipleSelection = false;
			
			view.removeItemArea.addEventListener(DragEvent.DRAG_ENTER, onRemoveEnter);
			view.removeItemArea.addEventListener(DragEvent.DRAG_DROP, onRemoveLink);				

				
		}
		
		public function get view():BrokerOfficeLinksVBox {
			return viewComponent as BrokerOfficeLinksVBox;
		}
		
		override public function listNotificationInterests():Array {
			return [ApplicationFacade.LOAD_BROKER_OFFICE, UsefulLinkProxy.FIND_ALL_USEFUL_LINKS_COMPLETE, ApplicationFacade.SAVE_OR_UPDATE_USEFUL_LINK_COMPLETE]; //UsefulLinkProxy.FIND_ALL_USEFUL_LINKS_FROM_MO_COMPLETE, 
		}
		
		override public function handleNotification(note:INotification):void {
			switch (note.getName()) {
				case ApplicationFacade.LOAD_BROKER_OFFICE:
					onLoadBrokerOffice(note);
					break;
				case UsefulLinkProxy.FIND_ALL_USEFUL_LINKS_COMPLETE:
					onLoadUsefulLinks(note);
					break;
				case ApplicationFacade.SAVE_OR_UPDATE_USEFUL_LINK_COMPLETE:
					linkProxy.listLinks();
					if (ApplicationFacade.getInstance().userInfo.isSupport || ApplicationFacade.getInstance().userInfo.isUnderwriter) {
						linkProxy.listLinksForUnderwriter();
					}
					break;					
			}
		}
		
		private function onLoadBrokerOffice(note:INotification):void {
			
			brokerOffice = note.getBody() as BrokerOffice;
			view.enabled = (!isNaN(brokerOffice.sid));

			if (view.enabled) {
				fieldValidator.reset();
				setContactEnablement(false);
				brokerOfficeLink = null;
				view.txiName.text = null;
				view.txiUrl.text = null;
				view.txiDescription.text = null;
				view.cbxArchived.selected = false;
				
				var links:IList = generateUniqueLinksList(
					brokerOffice.usefulLinks, 
					(brokerOffice.masterOffice != null ? brokerOffice.masterOffice.usefulLinks : null), (brokerOffice.masterOffice ? false: true));
				
				brokerOfficeLinks.removeAll();
				populateLinksOfficeDataProvider(links);
				brokerOfficeLinks.refresh();
			}
		}
		
		private function generateUniqueLinksList(boLinks:IList, moLinks:IList, isMasterOffice:Boolean):IList {
			var ret:IList = new ArrayCollection();
			var existingIds:Dictionary = new Dictionary();
			var allLinks:ArrayCollection = new ArrayCollection();

			if (moLinks != null) {
				for each (var moLink:BrokerOfficeLinkEntry in moLinks) {
					moLink.inheritedFromMasterOffice = isMasterOffice ?  false : true;
					if (!existingIds[moLink.link.sid]) {
						existingIds[moLink.link.sid] = true;
						ret.addItem(moLink);
					}
				}
			}
			
			if (boLinks != null) {
				for each (var boLink:BrokerOfficeLinkEntry in boLinks) {
					boLink.inheritedFromMasterOffice = false;
					if (!existingIds[boLink.link.sid]) {
						existingIds[boLink.link.sid] = true;
						ret.addItem(boLink);
					}
				}				
			}
		
			return ret;
		}
		
		private function populateLinksOfficeDataProvider(links:IList):void {
			for each (var item:BrokerOfficeLinkEntry in links) {
				brokerOfficeLinks.addItem(BrokerOfficeLinkVO.createFromBrokerOfficeLinkEntry(item));
			}
		}
		
		private function onLoadUsefulLinks(note:INotification):void {	
			var viewList:ICollectionView = new ListCollectionView(IList(note.getBody()));
			var sort:Sort = new Sort();
			sort.fields = [new SortField("name", true)];
			viewList.sort = sort;
			viewList.filterFunction = archiveFilter;
			viewList.refresh();
			
			view.allLinks.dataProvider = viewList;
			
		}

		private function onSelectLink(event:ListEvent):void {
			fieldValidator.reset();
			brokerOfficeLink = (view.allLinks.dataProvider as IList).getItemAt(event.rowIndex) as LinkUrl;
			loadBrokerContact();
		}
		
		private function onCreateLink(event:FlexEvent):void {
			fieldValidator.reset();
			brokerOfficeLink = new LinkUrl();
			brokerOfficeLink.active = true;
			brokerOfficeLink.url="http://";
			loadBrokerContact();
		}
		
		private function onSaveLink(event:FlexEvent):void {
			if (fieldValidator.validate("brokerOfficeLinksVBox", view)) {
				brokerOfficeLink.name = view.txiName.text;
				brokerOfficeLink.url = view.txiUrl.text;
				brokerOfficeLink.description = (view.txiDescription.text.length > 0) ? view.txiDescription.text : null;
				brokerOfficeLink.active = !view.cbxArchived.selected;
				sendNotification(ApplicationFacade.SAVE_OR_UPDATE_USEFUL_LINK, brokerOfficeLink);
			}
		}
		
		private function loadBrokerContact():void {
			view.txiName.text = brokerOfficeLink.name;
			view.txiUrl.text = brokerOfficeLink.url;
			view.txiDescription.text = brokerOfficeLink.description;
			view.cbxArchived.selected = !brokerOfficeLink.active;

			setContactEnablement(true);
		}
		
		private function setContactEnablement(enabled:Boolean):void {
			view.txiName.enabled = enabled;
			view.txiUrl.enabled = enabled;
			view.txiDescription.enabled = enabled;
			view.cbxArchived.enabled = enabled;
			view.btnSaveLink.enabled = enabled;			
		}
		
		public function onSelectArchivedLinks(event:Event):void {
			var list:ICollectionView = (view.allLinks.dataProvider as ICollectionView);
			if (list != null) {
				list.refresh();
			}
		}		
		
		private function archiveFilter(bl:LinkUrl):Boolean {
			return view.cbxShowArchived.selected || bl.active;
		}	
		
		private function onSave(event:FlexEvent):void {
			
			var pos:int = 0;
			var displayOrderPos:int = brokerOffice.masterOffice ? brokerOffice.masterOffice.usefulLinks.length : 0;
			var updatedUsefulLinks:IList = new ArrayCollection();
			
			for each (var item:BrokerOfficeLinkVO in brokerOfficeLinks) {
				
				var persistentItem:BrokerOfficeLinkEntry = null;
				if (item.link is BrokerOfficeLinkEntry) {
					persistentItem = item.link as BrokerOfficeLinkEntry;
				} else if (item.link is LinkUrl) {
					persistentItem = new BrokerOfficeLinkEntry();
					persistentItem.link = item.link as LinkUrl;
				}
				
				if (!persistentItem.inheritedFromMasterOffice) {
					persistentItem.displayOrder = displayOrderPos + pos;
					updatedUsefulLinks.addItemAt(persistentItem, pos);
					pos++;
				}
			}

			sendNotification(ApplicationFacade.SAVE_BROKER_OFFICE_USEFUL_LINKS, {sid: brokerOffice.sid, usefulLinks: updatedUsefulLinks});
		}
		
		private function onDropHandler(event:DragEvent):void {
			
			if (event.dragSource.hasFormat("items") && event.action == DragManager.COPY) {
				event.preventDefault();
				
				var dropIndex:int = view.brokerOfficeUsefulLinks.tileList.calculateDropIndex(event);
				view.brokerOfficeUsefulLinks.tileList.hideDropFeedback(event);
				
				if (event.dragInitiator == event.target) {
					if (brokerOfficeLinks.length > dropIndex) {
						var indexStartDrag:Number = event.currentTarget.selectedIndex;
						var tmpItem:Object = brokerOfficeLinks.removeItemAt(indexStartDrag);
						brokerOfficeLinks.addItemAt(tmpItem, dropIndex);
						brokerOfficeLinks.refresh();
					}
					return;					
				}
				
				var items:Array = event.dragSource.dataForFormat("items") as Array;
				for each (var item:LinkUrl in items) {
					var link:LinkUrl = item as LinkUrl;
					if (link.active) {
						
						for each (var existingLinkEntry:BrokerOfficeLinkVO in brokerOfficeLinks) {
							if (link.name == existingLinkEntry.name) {
								return;
							}
						}
						
						var newLinkEntry:BrokerOfficeLinkVO = BrokerOfficeLinkVO.createFromLinkUrl(link);
						brokerOfficeLinks.addItemAt(newLinkEntry, dropIndex);
						brokerOfficeLinks.refresh();
					}
				}
			}
		}
		
		public function onDragHandler(event:DragEvent):void {
			if (event.dragInitiator == view.allLinks) {
				var link:LinkUrl = (event.dragInitiator as List).selectedItem as LinkUrl;
				if (!link.active)
					return;
			}
		}
		
		public function onRemoveEnter(event:DragEvent):void {
			if ((event.dragInitiator as UIComponent).id != view.brokerOfficeUsefulLinks.tileList.id) {
				event.stopImmediatePropagation();
			} else {
				DragManager.acceptDragDrop(view.removeItemArea);
			}
		}
		
		public function onRemoveLink(event:DragEvent):void {
			if ((event.dragInitiator as UIComponent).id == view.brokerOfficeUsefulLinks.tileList.id) {
				
				var item:Object = (event.dragInitiator as TileList).selectedItem;
				
				if (item.inheritedFromMasterOffice) {
					Alert.show("You cant remove a link inherited from the Master Office.");
					return;
				}
				
				var index:int = (event.dragInitiator as TileList).selectedIndex;
				((event.dragInitiator as TileList).dataProvider as IList).removeItemAt(index);
			}
		}
		
	}
	
	
}