package com.catlin.cargo.view.risk.clauses
{
	import com.catlin.cargo.ApplicationFacade;
	import com.catlin.cargo.model.core.clause.Clause;
	import com.catlin.cargo.model.proxy.ClauseProxy;
	
	import mx.events.FlexEvent;
	
	import org.puremvc.as3.interfaces.IMediator;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;
	
	public class ViewClauseFormMediator extends Mediator implements IMediator {
		
		public static const NAME:String = 'ViewClauseFormMediator';
		
		public function ViewClauseFormMediator(viewComponent:Object) {
			super(NAME, viewComponent);
				viewClauseForm.btnOK.addEventListener(FlexEvent.BUTTON_DOWN, onOK);
		}

		public function onOK(event:FlexEvent):void {
			viewClauseForm.ifrDescription.removeIFrame();
			ApplicationFacade.closePopUpWindow(viewClauseForm, NAME);
		}
	
		public function get viewClauseForm ():ViewClauseForm {
			return viewComponent as ViewClauseForm;
		}
		
		public function set clause(c:Clause):void {
			viewClauseForm.title = c.title;
			if (c.clauseDocument != null) {
				var clauseProxy:ClauseProxy = facade.retrieveProxy(ClauseProxy.NAME) as ClauseProxy;
				clauseProxy.getSnippetText(c);
			} else {
				viewClauseForm.ifrDescription.content = c.text;
			}
		}
	

		override public function listNotificationInterests():Array {
			return [ClauseProxy.GET_CLAUSE_TEXT_COMPLETE];
		}
		
		override public function handleNotification(notification:INotification):void {
			switch (notification.getName()) {
				case ClauseProxy.GET_CLAUSE_TEXT_COMPLETE:
					viewClauseForm.ifrDescription.content = notification.getBody() as String;
					break;
			}
		}
	}
}