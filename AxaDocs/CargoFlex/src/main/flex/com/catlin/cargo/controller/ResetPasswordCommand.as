package com.catlin.cargo.controller
{
	import com.catlin.cargo.bundles.RB_ui;
	
	import mx.controls.Alert;
	
	import org.granite.tide.events.TideResultEvent;
	import org.puremvc.as3.interfaces.INotification;
	
	public class ResetPasswordCommand extends BaseCommand { 
	
		override public function execute(notification:INotification):void {
			tideContext.userService.resetPassword(notification.getBody(), onResetPassword, onRemoteFault);
		}

		private function onResetPassword(event:TideResultEvent):void {
			Alert.show(rm.getString(RB_ui.RB_NAME, RB_ui.RESET_PASSWORD_SUCCESS_MESSAGE),
				rm.getString(RB_ui.RB_NAME, RB_ui.RESET_PASSWORD_SUCCESS_TITLE));
		}
	}
}