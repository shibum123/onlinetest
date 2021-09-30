package com.catlin.cargo.controller
{
	import com.catlin.cargo.bundles.RB_ui;
	import com.catlin.cargo.model.system.search.CargoSearchResult;
	
	import mx.controls.Alert;
	
	import org.granite.tide.events.TideResultEvent;
	import org.puremvc.as3.interfaces.INotification;
	
	public class SearchCommand extends BaseCommand {

		public static const SEARCH_COMPLETE:String = 'searchComplete';

		public function SearchCommand() {
		}

		override public function execute(notification:INotification):void {
			tideContext.searchService.search(notification.getBody(), onSearch, onRemoteFault);
		}
		
		private function onSearch(event:TideResultEvent):void {
			var csr:CargoSearchResult = (event.result as CargoSearchResult);
			if (csr.errorText != null) {
				Alert.show(rm.getString(RB_ui.RB_NAME, RB_ui.SEARCH_COMMAND_SUCCESS_MESSAGE, [csr.query]));
			} else {
				sendNotification(SEARCH_COMPLETE, csr.results);
			}
		}
	}
}