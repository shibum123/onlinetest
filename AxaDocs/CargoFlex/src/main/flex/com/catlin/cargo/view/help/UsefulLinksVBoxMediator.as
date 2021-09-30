package com.catlin.cargo.view.help
{
	import com.catlin.cargo.ApplicationFacade;
	import com.catlin.cargo.model.proxy.UsefulLinkProxy;
	import com.catlin.cargo.view.BaseMediator;
	
	import mx.collections.ArrayCollection;
	import mx.collections.IList;
	import mx.collections.ListCollectionView;
	
	import org.puremvc.as3.interfaces.IMediator;
	import org.puremvc.as3.interfaces.INotification;

	public class UsefulLinksVBoxMediator extends BaseMediator implements IMediator {
		
		public static const NAME:String='UsefulLinksVBoxMediator';
		
		public function UsefulLinksVBoxMediator(viewComponent:UsefulLinksVBox) {
			super(NAME, viewComponent);
			
		}
		
		public function get view():UsefulLinksVBox {
			return viewComponent as UsefulLinksVBox;
		}
		
		override public function onRegister():void {
			super.onRegister();
		}
		
		override public function listNotificationInterests():Array {
			return [UsefulLinkProxy.FIND_ALL_USEFUL_LINKS_FOR_UNDERWRITER_COMPLETE, UsefulLinkProxy.FIND_ALL_USEFUL_LINKS_FOR_BROKER_COMPLETE];
		}
		
		override public function handleNotification(note:INotification):void {
			switch (note.getName()) {
				case UsefulLinkProxy.FIND_ALL_USEFUL_LINKS_FOR_UNDERWRITER_COMPLETE:
				case UsefulLinkProxy.FIND_ALL_USEFUL_LINKS_FOR_BROKER_COMPLETE:
					updateUsefulLinks(new ListCollectionView(IList(note.getBody())));
					break;
				}
		}	
		
		private function updateUsefulLinks(usefulLinksDp:ListCollectionView):void {
			var usefulLinks:ArrayCollection = new ArrayCollection(usefulLinksDp.toArray());
			
			if (!ApplicationFacade.getInstance().userInfo.isUnderwriter && !ApplicationFacade.getInstance().userInfo.isSupport)
				view.usefulLinksCmp.sortField = "displayOrder";
			
			view.usefulLinksCmp.dataProvider = usefulLinks; 
		}
	}
}