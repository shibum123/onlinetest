package com.catlin.cargo.view.risk.clauses {
	import com.catlin.cargo.ApplicationFacade;
	import com.catlin.cargo.model.core.clause.Clause;
	import com.catlin.ui.flex.validator.MultiPageValidator;
	import com.catlin.ui.flex.validator.rules.ValidatorError;
	
	import flash.events.Event;
	
	import mx.binding.utils.BindingUtils;
	import mx.core.UIComponent;
	import mx.events.FlexEvent;
	
	import org.puremvc.as3.interfaces.IMediator;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;
	
	public class NewClauseFormMediator extends Mediator implements IMediator {
		
		public static const NAME:String = 'NewClauseFormMediator';
		public static const CREATE_CLAUSE_COMPLETE:String = 'createClauseComplete';

		public var clause:Clause = new Clause();
		private var allErrors:Array = new Array();
		private var validation:ValidationImpl = new ValidationImpl();
		public var multiPageValidator:MultiPageValidator = new MultiPageValidator();

		public function NewClauseFormMediator(viewComponent:Object) {
			super(NAME, viewComponent);
			
			validation.newClauseFormMediator = this;
			multiPageValidator.rules = validation.create(); 
			
			newClauseForm.btnCancel.addEventListener(FlexEvent.BUTTON_DOWN, onCancel);
			newClauseForm.btnAdd.addEventListener(FlexEvent.BUTTON_DOWN, onAddClause);
			newClauseForm.rteDescription.linkTextInput.visible = false;

			BindingUtils.bindProperty(newClauseForm.txtName, "text", this, ["clause", "title"]); 
			//BindingUtils.bindSetter(onHtmlText, newClauseForm, ["rteDescription", "textArea", "htmlText"]); 
			BindingUtils.bindProperty(clause, "title", newClauseForm, ["txtName", "text"]); 
			BindingUtils.bindProperty(clause, "text", newClauseForm, ["rteDescription", "validHtmlText"]); 
		}

		public function onHtmlText(event:Event):void {
			clause.text = newClauseForm.rteDescription.validHtmlText;
		}

		public function onCancel(event:FlexEvent):void {
			ApplicationFacade.closePopUpWindow(newClauseForm, NAME);
		}
	
		public function onAddClause(event:FlexEvent):void {
			clause.text = newClauseForm.rteDescription.validHtmlText;
			validation.clause = clause;
			var errors:Array = multiPageValidator.validate("newClause");
			for each(var previousError:Object in allErrors) {
				var errorComp:UIComponent = previousError.component;
			 	errorComp.errorString = null;
			 	errorComp.styleName = previousError.originalStyleName;
			}
			for each (var error:ValidatorError in errors) {
				var failedComponent:UIComponent = loadContext(newClauseForm, error.context) as UIComponent;
				failedComponent.errorString = error.message;
				allErrors.push({component: failedComponent, originalStyleName: failedComponent.styleName}); // keep track for removal
				failedComponent.styleName = "cargoErrorStyle";
			}
			if (errors.length == 0) {
				sendNotification(ApplicationFacade.CREATE_CLAUSE, clause);
			}			
		}
		
		private function loadContext(object:Object, context:String):Object {
			var result:Object = object;
			var splitContext:Array = context.split(".");
			for each (var property:String in splitContext) {
				if (property.indexOf("[") >= 0) {
					result = result[property.substring(0, property.indexOf("["))];
					property = property.substring(property.indexOf("[")+1, property.lastIndexOf("]"));
				}
				result = result[property];
			}
			return result;
		}

		public function get newClauseForm ():NewClauseForm {
			return viewComponent as NewClauseForm;
		}
		
		override public function listNotificationInterests():Array {
			return [CREATE_CLAUSE_COMPLETE];
		}
		
		override public function handleNotification(note:INotification):void {
			switch (note.getName()) {
				case CREATE_CLAUSE_COMPLETE:
					ApplicationFacade.closePopUpWindow(newClauseForm, NAME);
				break;
			}
		}
		
		public function validateDuplicateName(name:String):Boolean {
			var clausesFormMediator:ClausesFormMediator = facade.retrieveMediator(ClausesFormMediator.NAME) as ClausesFormMediator;
			var clause:Clause;
			for each (clause in clausesFormMediator.clausesForm.standardClauses.dataProvider) {
				if (clause.title == name) return true;
			}
			for each (clause in clausesFormMediator.clausesForm.nonStandardClauses.dataProvider) {
				if (clause.title == name) return true;
			}
			return false;
		}
	}
}