package com.catlin.cargo {
	
	import mx.events.CollectionEvent;
	import mx.events.CollectionEventKind;
	
	import org.granite.tide.collections.PersistentCollection;
	
	public class LazyCollectionExecutor {
		
		private var lazyCollection:Object = null;
		private var functionToCall:Function = null;
		private var arg:* = null;
		
		public function LazyCollectionExecutor(lazyCollection:Object, functionToCall:Function, arg:*=null) {
			this.lazyCollection = lazyCollection;
			this.functionToCall = functionToCall;
			this.arg = arg;
		}
		
		public function execute():void {
			if (lazyCollection != null && lazyCollection is PersistentCollection && !lazyCollection.isInitialized()) {
				lazyCollection.addEventListener(CollectionEvent.COLLECTION_CHANGE, executeFunction);
				var a:int = lazyCollection.length;
			} else {
				functionToCall(arg);
			}
		}
		
		
		private function executeFunction(evt:CollectionEvent):void {
			if (evt.kind != CollectionEventKind.REFRESH) {
				return;
			}
			lazyCollection.removeEventListener(CollectionEvent.COLLECTION_CHANGE, executeFunction);
			functionToCall(arg);
		}
	}
}