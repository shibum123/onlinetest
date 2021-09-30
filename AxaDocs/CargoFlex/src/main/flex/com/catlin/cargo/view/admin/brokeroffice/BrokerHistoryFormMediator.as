package com.catlin.cargo.view.admin.brokeroffice {
	import com.catlin.cargo.ApplicationFacade;
	import com.catlin.cargo.model.core.risk.HistoricAction;
	import com.catlin.cargo.model.proxy.HistoryProxy;
	import com.catlin.cargo.view.BaseMediator;
	
	import mx.binding.utils.BindingUtils;
	import mx.collections.ArrayCollection;
	import mx.controls.dataGridClasses.DataGridColumn;
	import mx.formatters.DateFormatter;
	
	import org.puremvc.as3.interfaces.IMediator;
	import org.puremvc.as3.interfaces.INotification;

	public class BrokerHistoryFormMediator extends BaseMediator implements IMediator {

		public static const NAME:String = 'BrokerHistoryFormMediator';
		private var holder:HistoricAction = null;
		private var dateFormatter:DateFormatter = new DateFormatter();

		[Bindable]
		public var fullHistory:ArrayCollection;

		public function BrokerHistoryFormMediator(viewComponent:Object) {
			super(NAME, viewComponent);

			BindingUtils.bindProperty(brokerHistoryForm.grdHistory, "dataProvider", this, [ "fullHistory" ]);

			brokerHistoryForm.dgcComments.dataField = "comments";
			brokerHistoryForm.dgcComments.wordWrap = true;

			brokerHistoryForm.dgcUser.dataField = "userName";

			brokerHistoryForm.dgcDateTime.dataField = "timestamp";
			brokerHistoryForm.dgcDateTime.labelFunction = dateLabel;
			brokerHistoryForm.dgcDateTime.sortable = true;
			brokerHistoryForm.dgcDateTime.sortDescending = false;
			dateFormatter.formatString = ApplicationFacade.getInstance().localeFormat.dateTimeShort4Year; //"D/M/YYYY H:NN";
			BindingUtils.bindProperty(dateFormatter, "formatString", ApplicationFacade.getInstance(), [ "localeFormat", "dateTimeShort4Year" ]);
		}

		private function dateLabel(item:Object, column:DataGridColumn):String {
			return dateFormatter.format(item[column.dataField]);
		}

		public function get brokerHistoryForm():BrokerHistoryForm {
			return viewComponent as BrokerHistoryForm;
		}

		override public function listNotificationInterests():Array {
			return [ HistoryProxy.BROKER_HISTORY_FOUND ];
		}

		override public function handleNotification(note:INotification):void {
			switch (note.getName()) {
				case HistoryProxy.BROKER_HISTORY_FOUND:
					updateHistory(note);
					break;
			}
		}

		private function updateHistory(note:INotification):void {
			fullHistory = note.getBody() as ArrayCollection;
		}
	}
}