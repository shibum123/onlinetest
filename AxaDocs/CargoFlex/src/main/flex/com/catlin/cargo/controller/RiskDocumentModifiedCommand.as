package com.catlin.cargo.controller
{
	import com.catlin.cargo.bundles.RB_ui;
	import com.catlin.cargo.model.core.risk.Risk;

	import mx.controls.Alert;

	import org.puremvc.as3.interfaces.INotification;

	public class RiskDocumentModifiedCommand extends BaseCommand
	{

		override public function execute(notification:INotification):void
		{
			var risk:Risk=notification.getBody() as Risk;
			Alert.show(rm.getString(RB_ui.RB_NAME, RB_ui.RISK_DOCUMENT_MODIFIED_COMMAND_MESSAGE, [risk.reference]), 
				rm.getString(RB_ui.RB_NAME, RB_ui.RISK_DOCUMENT_MODIFIED_COMMAND_TITLE));
		}
	}
}
