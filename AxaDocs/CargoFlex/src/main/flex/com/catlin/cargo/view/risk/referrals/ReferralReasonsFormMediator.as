package com.catlin.cargo.view.risk.referrals {
	import com.catlin.cargo.ApplicationFacade;
	import com.catlin.cargo.LazyCollectionExecutor;
	import com.catlin.cargo.model.core.risk.ReferralRuleFailure;
	import com.catlin.cargo.model.core.risk.Risk;
	import com.catlin.ui.flex.widgets.error.ErrorPopup;
	
	import mx.binding.utils.BindingUtils;
	import mx.collections.ArrayCollection;
	import mx.collections.ListCollectionView;
	import mx.events.CollectionEvent;
	
	import org.granite.tide.events.TideFaultEvent;
	import org.puremvc.as3.interfaces.IMediator;
	import org.puremvc.as3.patterns.mediator.Mediator;

	public class ReferralReasonsFormMediator extends Mediator implements IMediator {
		
		public static const NAME:String = 'ReferralReasonsFormMediator';
		private var referralRuleFailures:ListCollectionView;

		public function ReferralReasonsFormMediator(viewComponent:Object) {
			super(NAME, viewComponent);
            BindingUtils.bindSetter(setBrokerFailureMessages, referralReasonsForm, ["quote", "referralRuleFailures"] );
		}

		public function get referralReasonsForm ():ReferralReasonsForm {
			return viewComponent as ReferralReasonsForm;
		}
		
		public function set currentQuote(quote:Risk):void {
			referralReasonsForm.userInfo = ApplicationFacade.getInstance().userInfo;
			referralReasonsForm.quote = quote;
		}
		
		private function setBrokerFailureMessages(failures:ListCollectionView):void {
			if (referralRuleFailures != null) {
				referralRuleFailures.removeEventListener(CollectionEvent.COLLECTION_CHANGE, updateFailures); 
			}
			referralRuleFailures = failures;
			if (referralRuleFailures != null) {
				referralRuleFailures.addEventListener(CollectionEvent.COLLECTION_CHANGE, updateFailures); 
			}
			updateFailures(null);
		}
		
		private function updateFailures(event:CollectionEvent):void {
			new LazyCollectionExecutor((referralReasonsForm.quote != null) ? referralReasonsForm.quote.referralRuleFailures : null, 
				setBrokerFailureMessagesInternal, referralReasonsForm.quote).execute();
		}
		
		private function setBrokerFailureMessagesInternal(quote:Risk):void {
			var f:ArrayCollection = new ArrayCollection();
			if (quote != null) {
				for each ( var failure:ReferralRuleFailure in quote.referralRuleFailures ) {
					f.addItem({description:failure.brokerDescription});					
				}
			}
			referralReasonsForm.brokerMessages = removeDuplicates(f);
		}
		
		private function removeDuplicates(arrCol:ArrayCollection):ArrayCollection {
			var tempArr:Array = arrCol.toArray();
			var obj:Object = {}, i:* = tempArr.length, arr:Array = [], t:String;
			while(i--) t = (tempArr[i] as Object)["description"], obj[t] = t;
			for(i in obj) if(i != "-") arr.push(obj[i]);
			return new ArrayCollection(arr);
		}  
		
 		protected function onRemoteFault(event:TideFaultEvent):void {
			ErrorPopup.show(event.fault);
		}
	}
}