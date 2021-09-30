package com.catlin.cargo.controller {
	import com.catlin.cargo.bundles.RB_ui;
	
	import mx.controls.Alert;
	
	import org.granite.tide.events.TideFaultEvent;
	import org.granite.tide.events.TideResultEvent;
	import org.puremvc.as3.interfaces.INotification;

	public class ChangePasswordCommand extends BaseCommand {

		public static const PASSWORD_CHANGED:String='PASSWORD_CHANGED';

		override public function execute(notification:INotification):void {
			var o:Object=notification.getBody();
			tideContext.userService.changePassword(o.oldPassword, o.newPassword, onChangePassword, onRemoteFault);
		}

		private function onChangePassword(event:TideResultEvent):void {
			Alert.show(rm.getString(RB_ui.RB_NAME, RB_ui.CHANGE_PASSWORD_SUCCESS_MESSAGE), rm.getString(RB_ui.RB_NAME, RB_ui.CHANGE_PASSWORD_SUCCESS_TITLE));
			sendNotification(PASSWORD_CHANGED);
		}

		override protected function onRemoteFault(event:TideFaultEvent):void {
			switch (event.fault.faultCode) {
				case "BadCredentialsException.Call.Failed":
					Alert.show(rm.getString(RB_ui.RB_NAME, RB_ui.CHANGE_PASSWORD_ERROR_INCORRECTPASSWORD_MESSAGE), 
							   rm.getString(RB_ui.RB_NAME, RB_ui.CHANGE_PASSWORD_ERROR_INCORRECTPASSWORD_TITLE));
					break;
				case "WeakPasswordException.Call.Failed":
					Alert.show(event.fault.faultString + "\n ", 
							   rm.getString(RB_ui.RB_NAME, RB_ui.CHANGE_PASSWORD_ERROR_WEAKPASSWORD_TITLE));
					break;
				default:
					super.onRemoteFault(event);
					break;
			}
		}

	}
}
