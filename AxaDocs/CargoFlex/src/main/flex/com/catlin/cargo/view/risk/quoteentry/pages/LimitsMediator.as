package com.catlin.cargo.view.risk.quoteentry.pages {

	import com.catlin.cargo.controller.UpdateLimitsAndDeductiablesCommand;
	import com.catlin.cargo.model.core.risk.Risk;

	import flash.events.Event;

	import mx.collections.ArrayCollection;

	import org.puremvc.as3.interfaces.IMediator;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;

	public class LimitsMediator extends Mediator implements IMediator {

		public static const NAME:String='LimitsMediator';

		private var _quote:Risk;

		public function LimitsMediator(viewComponent:Object) {
			super(NAME, viewComponent);
			limits.postalLimits.addEventListener(Event.CHANGE, onPostalLimitChange);
		}

		private function get limits():Limits {
			return viewComponent as Limits;
		}


		public function set currentQuote(quote:Risk):void {
			_quote=quote;
		}

		override public function listNotificationInterests():Array {
			return [UpdateLimitsAndDeductiablesCommand.FIND_POSTAL_LIMITS_COMPLETE];
		}

		override public function handleNotification(note:INotification):void {
			switch (note.getName()) {
				case UpdateLimitsAndDeductiablesCommand.FIND_POSTAL_LIMITS_COMPLETE:
					updatePostalLimits(note);
					break;
			}
		}

		private function updatePostalLimits(note:INotification):void {
			limits.postalLimits.dataProvider=note.getBody() as ArrayCollection;
			limits.postalLimits.selectedItem=_quote.postalLimit;
		}

		protected function onPostalLimitChange(event:Event):void {
			var value:Number=event.currentTarget.selectedItem as Number;
			_quote.postalLimit=value;
		}


	}
}
