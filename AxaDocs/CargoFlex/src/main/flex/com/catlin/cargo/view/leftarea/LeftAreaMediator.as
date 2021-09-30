package com.catlin.cargo.view.leftarea {
	import com.catlin.cargo.ApplicationFacade;
	import com.catlin.cargo.bundles.RB_ui;
	import com.catlin.cargo.model.core.risk.RiskSearchResult;
	import com.catlin.cargo.model.core.risk.RiskStatus;
	import com.catlin.cargo.model.proxy.BrokerProxy;
	import com.catlin.cargo.model.proxy.RiskProxy;
	import com.catlin.cargo.view.BaseMediator;
	
	import flash.events.Event;
	
	import mx.collections.ArrayCollection;
	
	import org.puremvc.as3.interfaces.IMediator;
	import org.puremvc.as3.interfaces.INotification;

	public class LeftAreaMediator extends BaseMediator implements IMediator {
		
		public static const NAME:String = 'LeftAreaMediator';
		
		private var riskProxy:RiskProxy;
		private var renewalList:RenewalList = new RenewalList();

		public function LeftAreaMediator(viewComponent:Object) {
			super(NAME, viewComponent);
			leftArea.addEventListener(LeftArea.NEW_QUOTE, onClickNewQuote);
			leftArea.addEventListener(LeftArea.FORCE_RENEWAL, onForceRenewal);
			leftArea.addEventListener(RiskList.VIEW, onViewRisk);
			
		    riskProxy = facade.retrieveProxy(RiskProxy.NAME) as RiskProxy;
		    leftArea.accordion.selectedIndex = 1;
			if (ApplicationFacade.getInstance().userInfo.isUnderwriter) {
				renewalList.title = rm.getString(RB_ui.RB_NAME,RB_ui.LEFT_AREA_MEDIATOR_TITLE_RENEWAL_OFFERS);
				leftArea.accordion.addChildAt(renewalList, 3);
			}
		}

		override public function onRegister():void {
			super.onRegister();
			facade.registerMediator( new SearchMediator( leftArea.search ) );
			facade.registerMediator( new RiskListMediator( leftArea.quotesList, true ) );
			facade.registerMediator( new RiskListMediator( leftArea.policyList ) );
			facade.registerMediator( new RiskListMediator( leftArea.referralList, false, true ) );
			if (ApplicationFacade.getInstance().userInfo.isUnderwriter) {
				facade.registerMediator( new RenewalListMediator( renewalList ) );
			}
			facade.registerMediator( new RiskListMediator( leftArea.offlineList ) );
		}

        private function onViewRisk( event:Event ):void {
			if (event.target.selectedRisk != null) {
				riskProxy.findById(event.target.selectedRisk.riskSid);
   			}
        }

		private function get leftArea ():LeftArea {
			return viewComponent as LeftArea;
		}

		private function onForceRenewal(event:Event):void {
			sendNotification(ApplicationFacade.FORCE_RENEWAL);
		}
		
		private function onClickNewQuote(event:Event):void {
			sendNotification(ApplicationFacade.CREATE_QUOTE);
		}

		override public function listNotificationInterests():Array {
			return [ApplicationFacade.REFRESH_ALL_RISKS, RiskProxy.FIND_ALL_RISKS_COMPLETE, RiskProxy.FIND_BY_ID_COMPLETE,
				ApplicationFacade.PREP_QUOTE_FORM, BrokerProxy.FIND_ALL_BROKER_OFFICES_COMPLETE];
		}
		
		override public function handleNotification(note:INotification):void {
			switch (note.getName()) {
				case ApplicationFacade.REFRESH_ALL_RISKS:
					riskProxy.listRisksForUser();
					break;
				case RiskProxy.FIND_ALL_RISKS_COMPLETE: 
					var allRisks:ArrayCollection = (note.getBody() as ArrayCollection);
					var quoteRisks:ArrayCollection = new ArrayCollection();
					var policyRisks:ArrayCollection = new ArrayCollection();
					var policyWithSubjListRisks:ArrayCollection = new ArrayCollection();
					var renewalRisks:ArrayCollection = new ArrayCollection();
					var referralRisks:ArrayCollection = new ArrayCollection();
					var offlineRisks:ArrayCollection = new ArrayCollection();
					for (var i:int = 0; i < allRisks.length; i++) {
						var result:RiskSearchResult = allRisks.getItemAt(i) as RiskSearchResult;
						var rs:RiskStatus = result.status;
						if (RiskStatus.QUOTED.equals(rs) || RiskStatus.QUOTE_EXPIRED.equals(rs)) {
							quoteRisks.addItem(result);
						} else if (RiskStatus.POLICY.equals(rs)) {
							policyRisks.addItem(result);
						} else if (result.renewal && !result.seenByBroker) {
							renewalRisks.addItem(result);
						} else if (RiskStatus.REFERRED.equals(rs) || RiskStatus.QUOTE_PENDING.equals(rs)) {
							referralRisks.addItem(result);
						} else if (RiskStatus.OFFLINE.equals(rs)) {
							offlineRisks.addItem(result);
						}
					}
					leftArea.quotesList.risks = quoteRisks;
					leftArea.policyList.risks = policyRisks;
					renewalList.risks = renewalRisks;
					leftArea.referralList.risks = referralRisks;
					leftArea.offlineList.risks = offlineRisks;
					break;
				case RiskProxy.FIND_BY_ID_COMPLETE:
            		sendNotification(ApplicationFacade.DISPLAY_QUOTE, note.getBody());
            		break;
				case ApplicationFacade.PREP_QUOTE_FORM:
					leftArea.newQuote.enabled = false;
					break;
				case BrokerProxy.FIND_ALL_BROKER_OFFICES_COMPLETE:
					leftArea.newQuote.enabled = true;
					break;
			}
		}
		
	}
}