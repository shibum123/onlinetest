package com.catlin.cargo.controller
{
	import com.catlin.cargo.ApplicationFacade;
	import com.catlin.cargo.bundles.RB_ui;
	import com.catlin.cargo.model.core.risk.Risk;
	import com.catlin.cargo.model.core.risk.RiskStatus;
	import com.catlin.cargo.model.security.UserInfo;
	import com.catlin.cargo.view.risk.ContentAreaMediator;
	
	import org.granite.tide.events.TideResultEvent;
	import org.puremvc.as3.interfaces.INotification;

    /*
     * TODO - this is performing two refreshes on the UI which causes a race condition where we lose entered values.
     */
	public class EditQuoteCommand extends BaseCommand {
		
		override public function execute(notification:INotification):void {
			var contentAreaMediator:ContentAreaMediator = facade.retrieveMediator(ContentAreaMediator.NAME) as ContentAreaMediator;
			var quote:Risk = notification.getBody() as Risk;

			contentAreaMediator.setButtons([{id: ContentAreaMediator.EDIT, label:RB_ui.CONTENT_AREA_MEDIATOR_BUTTON_EDIT, enabled:false}]);
			contentAreaMediator.hideQuoteDocument();
			
			var rs:RiskStatus = quote.status; 
			if (rs.equals(RiskStatus.REFERRED) || rs.equals(RiskStatus.QUOTE_PENDING) || rs.equals(RiskStatus.QUOTE_EXPIRED)) {
				var ua:UserInfo = ApplicationFacade.getInstance().userInfo;
				if (ua.isUnderwriter) {
					 // update the owner on the quote
					quote.owner = ua.username; 
					tideContext.riskService.updateOwner(quote.sid, ua.username, onUpdateRisk, onRemoteFault);
				}
			} else {
                contentAreaMediator.setCurrentRisk(quote, true);
            }
		}
		
		private function onUpdateRisk(event:TideResultEvent):void {
			var quote:Risk = event.result as Risk;
			quote.updateTotals();
			var contentAreaMediator:ContentAreaMediator = facade.retrieveMediator(ContentAreaMediator.NAME) as ContentAreaMediator;
			contentAreaMediator.setCurrentRisk(quote, true);
		}
	}
}