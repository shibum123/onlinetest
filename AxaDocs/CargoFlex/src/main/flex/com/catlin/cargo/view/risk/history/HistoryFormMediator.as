package com.catlin.cargo.view.risk.history {
	import com.catlin.cargo.ApplicationFacade;
	import com.catlin.cargo.model.core.risk.HistoricAction;
	import com.catlin.cargo.model.proxy.HistoryProxy;
	
	import mx.binding.utils.BindingUtils;
	import mx.collections.ArrayCollection;
	import mx.controls.dataGridClasses.DataGridColumn;
	import mx.core.ClassFactory;
	import mx.formatters.DateFormatter;
	
	import org.puremvc.as3.interfaces.IMediator;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;

	public class HistoryFormMediator extends Mediator implements IMediator {

		public static const NAME:String = 'HistoryFormMediator';
		private var holder:HistoricAction = null;
		private var dateFormatter:DateFormatter = new DateFormatter();

		[Bindable]
		public var fullHistory:ArrayCollection;

		public function HistoryFormMediator(viewComponent:Object) {
			super(NAME, viewComponent);

			BindingUtils.bindProperty(historyForm.grdHistory, "dataProvider", this, [ "fullHistory" ]);

			historyForm.dgcStatus.dataField = "statusText";

			historyForm.dgcReference.dataField = "reference";

			historyForm.dgcComments.dataField = "comments";
			historyForm.dgcComments.wordWrap = true;

			historyForm.dgcUser.dataField = "userName";

			historyForm.dgcDateTime.dataField = "timestamp";
			historyForm.dgcDateTime.labelFunction = dateLabel;
			historyForm.dgcDateTime.sortable = true;
			historyForm.dgcDateTime.sortDescending = false;
			dateFormatter.formatString = ApplicationFacade.getInstance().localeFormat.dateTimeShort4Year; //"D/M/YYYY H:NN";
			BindingUtils.bindProperty(dateFormatter, "formatString", ApplicationFacade.getInstance(), ["localeFormat", "dateTimeShort4Year"]);

			historyForm.dgcDocuments.dataField = "documents";
			historyForm.dgcDocuments.itemRenderer = new ClassFactory(HistoryDocumentsRenderer);
		}

		private function dateLabel(item:Object, column:DataGridColumn):String {
			return dateFormatter.format(item[column.dataField]);
		}

		public function get historyForm():HistoryForm {
			return viewComponent as HistoryForm;
		}

		override public function listNotificationInterests():Array {
			return [ HistoryProxy.HISTORY_FOUND ];
		}

		override public function handleNotification(note:INotification):void {
			switch (note.getName()) {
				case HistoryProxy.HISTORY_FOUND:
					updateHistory(note);
					break;
			}
		}

		private function updateHistory(note:INotification):void {
			fullHistory = note.getBody() as ArrayCollection;
		}
	}
}