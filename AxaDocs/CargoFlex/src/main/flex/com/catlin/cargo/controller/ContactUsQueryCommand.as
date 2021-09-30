package com.catlin.cargo.controller
{
	import com.catlin.cargo.ApplicationFacade;
	
	import org.granite.tide.events.TideResultEvent;
	import org.puremvc.as3.interfaces.INotification;
	
	public class ContactUsQueryCommand  extends BaseCommand  {
		public function ContactUsQueryCommand() {
		}

		override public function execute(notification:INotification):void {
			
			var curUsername:String = ApplicationFacade.getInstance().userInfo.username;
			var data:Object = notification.getBody() as Object;
			tideContext.contactService.sendContactEmail(data['mailto'], curUsername, data['subject'], data['message'], onEmailSent, onRemoteFault);
		}

		private function onEmailSent(event:TideResultEvent):void {
		}
	}
}