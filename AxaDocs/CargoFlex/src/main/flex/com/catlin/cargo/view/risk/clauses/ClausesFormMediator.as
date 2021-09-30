package com.catlin.cargo.view.risk.clauses {
	import com.catlin.cargo.ApplicationFacade;
	import com.catlin.cargo.LazyCollectionExecutor;
	import com.catlin.cargo.bundles.RB_ui;
	import com.catlin.cargo.model.core.clause.Clause;
	import com.catlin.cargo.model.core.risk.Risk;
	import com.catlin.cargo.model.core.risk.RiskClause;
	import com.catlin.cargo.model.proxy.ClauseProxy;
	import com.catlin.cargo.view.BaseMediator;
	
	import flash.events.Event;
	
	import mx.binding.utils.BindingUtils;
	import mx.collections.ArrayCollection;
	import mx.collections.ICollectionView;
	import mx.collections.IList;
	import mx.collections.ListCollectionView;
	import mx.controls.Alert;
	import mx.controls.List;
	import mx.core.ClassFactory;
	import mx.events.DragEvent;
	import mx.events.FlexEvent;
	import mx.managers.DragManager;
	
	import org.puremvc.as3.interfaces.IMediator;
	import org.puremvc.as3.interfaces.INotification;

	public class ClausesFormMediator extends BaseMediator implements IMediator {
		
		public static const NAME:String = 'ClausesFormMediator';
		
		private var clause:Clause;
		
		[Bindable]
		public var quote:Risk;
		
		public function ClausesFormMediator(viewComponent:Object) {
			super(NAME, viewComponent);
			
			clausesForm.standardClauses.labelField = "title";
			clausesForm.standardClauses.allowDragSelection = false;
			clausesForm.standardClauses.allowMultipleSelection = false;
			clausesForm.standardClauses.itemRenderer = new ClassFactory(ClauseListItemRenderer);
			BindingUtils.bindProperty(clausesForm.standardClauses, "dragEnabled", this, ["quote", "editable"]);
			
			clausesForm.nonStandardClauses.labelField = "title";
			clausesForm.nonStandardClauses.allowDragSelection = false;
			clausesForm.nonStandardClauses.allowMultipleSelection = false;
			clausesForm.nonStandardClauses.itemRenderer = new ClassFactory(ClauseListItemRenderer);
			BindingUtils.bindProperty(clausesForm.nonStandardClauses, "dragEnabled", this, ["quote", "editable"]); 

			clausesForm.applicableClauses.labelFunction = riskClauseLabel;
			clausesForm.applicableClauses.dragEnabled = true;
			clausesForm.applicableClauses.allowDragSelection = false;
			clausesForm.applicableClauses.allowMultipleSelection = false;
			clausesForm.applicableClauses.addEventListener(DragEvent.DRAG_DROP, dragDropHandler, false, 1); 
			clausesForm.applicableClauses.addEventListener(DragEvent.DRAG_ENTER, onClauseEnter);
			BindingUtils.bindProperty(clausesForm.applicableClauses, "dragEnabled", this, ["quote", "editable"]);
			BindingUtils.bindProperty(clausesForm.applicableClauses, "dropEnabled", this, ["quote", "editable"]);
			BindingUtils.bindProperty(clausesForm.applicableClauses, "dragMoveEnabled", this, ["quote", "editable"]);
			
			clausesForm.removeClauseBox.addEventListener(DragEvent.DRAG_ENTER, onRemoveEnter);
			clausesForm.removeClauseBox.addEventListener(DragEvent.DRAG_DROP, onRemoveClause);
			
			clausesForm.btnAddNewClause.addEventListener(FlexEvent.BUTTON_DOWN, onNewClause);
			BindingUtils.bindProperty(clausesForm.btnAddNewClause, "enabled", this, ["quote", "editable"]); 

			clausesForm.btnViewClauseN.addEventListener(FlexEvent.BUTTON_DOWN, onViewClause);
			clausesForm.btnViewClauseS.addEventListener(FlexEvent.BUTTON_DOWN, onViewClause);
			clausesForm.btnViewClauseA.addEventListener(FlexEvent.BUTTON_DOWN, onViewRiskClause);
			
			clausesForm.btnArchiveClauseN.addEventListener(FlexEvent.BUTTON_DOWN, onArchiveClause);
			clausesForm.btnArchiveClauseS.addEventListener(FlexEvent.BUTTON_DOWN, onArchiveClause);
			
			clausesForm.btnRestoreClauseN.addEventListener(FlexEvent.BUTTON_DOWN, onRestoreClause);
			clausesForm.btnRestoreClauseS.addEventListener(FlexEvent.BUTTON_DOWN, onRestoreClause);

			clausesForm.cbxShowArchived.addEventListener(Event.CHANGE, onSelectArchivedClauses);
		}
		
		public function onArchiveClause(event:Event):void {
			var list:List;
			switch (event.currentTarget) {
				case clausesForm.btnArchiveClauseN:
					list = clausesForm.nonStandardClauses;
					break;
				case clausesForm.btnArchiveClauseS:
					list = clausesForm.standardClauses;
					break;
			}
			if (list != null && list.selectedIndex != -1) {
				var clause:Clause = list.selectedItem as Clause;
				clause.active = false;
				sendNotification(ApplicationFacade.UPDATE_CLAUSE_ARCHIVE_STATUS, clause);
				ICollectionView(list.dataProvider).refresh();
			} else {
				Alert.show(rm.getString(RB_ui.RB_NAME, RB_ui.CLAUSES_FORM_MEDIATOR_ERROR_NO_CLAUSE_SELECTED));
			}
		}
		
		public function onRestoreClause(event:Event):void {
			var list:List;
			switch (event.currentTarget) {
				case clausesForm.btnRestoreClauseN:
					list = clausesForm.nonStandardClauses;
					break;
				case clausesForm.btnRestoreClauseS:
					list = clausesForm.standardClauses;
					break;
			}
			if (list != null && list.selectedIndex != -1) {
				var clause:Clause = list.selectedItem as Clause;
				clause.active = true;
				sendNotification(ApplicationFacade.UPDATE_CLAUSE_ARCHIVE_STATUS, clause);
				ICollectionView(list.dataProvider).refresh();
			} else {
				Alert.show(rm.getString(RB_ui.RB_NAME, RB_ui.CLAUSES_FORM_MEDIATOR_ERROR_NO_CLAUSE_SELECTED));
			}
		}
		
		public function onSelectArchivedClauses(event:Event):void {
			var list:ListCollectionView = (clausesForm.nonStandardClauses.dataProvider as ListCollectionView);
			if (list != null) {
				list.refresh();
			}
			list = (clausesForm.standardClauses.dataProvider as ListCollectionView);
			if (list != null) {
				list.refresh();
			}
		}

		public function riskClauseLabel(rc:RiskClause):String {
			return rc.clause.title;
		}
		
		public function onViewClause(event:Event):void {
			var list:List;
			switch (event.currentTarget) {
				case clausesForm.btnViewClauseN:
					list = clausesForm.nonStandardClauses;
					break;
				case clausesForm.btnViewClauseS:
					list = clausesForm.standardClauses;
					break;
			}
			if (list != null && list.selectedIndex != -1) {
				var m:ViewClauseFormMediator = ApplicationFacade.openPopUpWindow(ViewClauseForm, ViewClauseFormMediator) as ViewClauseFormMediator;
				m.clause = list.selectedItem as Clause;
			} else {
				Alert.show(rm.getString(RB_ui.RB_NAME, RB_ui.CLAUSES_FORM_MEDIATOR_ERROR_NO_CLAUSE_SELECTED));
			}
        }
		
		public function onViewRiskClause(event:Event):void {
			var list:List = clausesForm.applicableClauses;
			if (list != null && list.selectedIndex != -1) {
				var m:ViewClauseFormMediator = ApplicationFacade.openPopUpWindow(ViewClauseForm, ViewClauseFormMediator) as ViewClauseFormMediator;
				m.clause = (list.selectedItem as RiskClause).clause;
			} else {
				Alert.show(rm.getString(RB_ui.RB_NAME, RB_ui.CLAUSES_FORM_MEDIATOR_ERROR_NO_CLAUSE_SELECTED));
			}
        }
		
		public function onNewClause(event:Event):void {
			ApplicationFacade.openPopUpWindow(NewClauseForm, NewClauseFormMediator);
        }

		public function onClauseEnter(event:DragEvent):void {
			var src:List =  (event.dragInitiator) as List;
			if (src != clausesForm.applicableClauses) {
				var clause:Clause = src.selectedItem as Clause;
				if (clause.active) {
						for each (var rc:RiskClause in quote.riskClauses) {
						if (rc.clause.title == clause.title && !rc.manuallyRemoved) {
							event.stopImmediatePropagation();
						}
					}
				}
			}
		}

		public function onRemoveEnter(event:DragEvent):void {
			var src:List =  (event.dragInitiator) as List;
			if (src != clausesForm.applicableClauses) {
				event.stopImmediatePropagation();
			} else {
				DragManager.acceptDragDrop(clausesForm.removeClauseBox);
			}
		}

		public function onRemoveClause(event:DragEvent):void {
			if (clausesForm.applicableClauses.selectedIndex != -1) { 
				var rc:RiskClause = clausesForm.applicableClauses.selectedItem as RiskClause;
				if (rc.auto) {
					rc.manuallyRemoved = true;
					event.stopImmediatePropagation();
				}
			}
		}

		private function dragDropHandler(event:DragEvent):void {
	        if (event.dragSource.hasFormat("items") && event.action == DragManager.COPY) {
				event.preventDefault();
				clausesForm.applicableClauses.hideDropFeedback(event);
            	var dropIndex:int = clausesForm.applicableClauses.calculateDropIndex(event);
	            var items:Array = event.dragSource.dataForFormat("items") as Array;
				for each (var c:Clause in items) {
					for each (var rc:RiskClause in quote.riskClauses) {
						if (rc.clause.title == c.title && rc.manuallyRemoved) {
							rc.manuallyRemoved = false;
							return;
						}
					}
					if (c.active) {
					var newRc:RiskClause = new RiskClause();
						newRc.clause = c;
						(clausesForm.applicableClauses.dataProvider as IList).addItemAt(newRc, dropIndex);
					}
				}
	        }
		}
			
		public function get clausesForm():ClausesForm {
			return viewComponent as ClausesForm;
		}
	
		public function set currentQuote(q:Risk):void {
			quote = q;
			if (quote != null) {
				new LazyCollectionExecutor(quote.riskClauses, setClauses, quote.riskClauses).execute();
			}
		}
		
		public function get currentQuote():Risk {
			return quote;
		}
	
		override public function listNotificationInterests():Array {
			return [
				ClauseProxy.FIND_ALL_STANDARD_CLAUSES_COMPLETE,
				ClauseProxy.FIND_ALL_NON_STANDARD_CLAUSES_COMPLETE
				];
		}

		override public function handleNotification(note:INotification):void {
			var clauses:ArrayCollection;
			switch (note.getName()) {
				case ClauseProxy.FIND_ALL_STANDARD_CLAUSES_COMPLETE:
					clauses = (note.getBody() as ArrayCollection);
					clauses.filterFunction = archiveFilter;
					clauses.refresh();
					clausesForm.standardClauses.dataProvider = clauses;
					break;
				case ClauseProxy.FIND_ALL_NON_STANDARD_CLAUSES_COMPLETE:
					clauses = (note.getBody() as ArrayCollection);
					clauses.filterFunction = archiveFilter;
					clauses.refresh();
					clausesForm.nonStandardClauses.dataProvider = clauses;
					break;
			}
		}
		
		private function manuallyRemovedFilter(clause:RiskClause):Boolean {
			return !clause.manuallyRemoved;
		}
		
		private function archiveFilter(clause:Clause):Boolean {
			return clausesForm.cbxShowArchived.selected || clause.active;
		}

		private function setClauses(sourceClauses:IList):void {
			var clauses:ICollectionView = new ListCollectionView(sourceClauses);
			clauses.filterFunction = manuallyRemovedFilter;
			clauses.refresh();
			clausesForm.applicableClauses.dataProvider = clauses;
		}	
	}
}