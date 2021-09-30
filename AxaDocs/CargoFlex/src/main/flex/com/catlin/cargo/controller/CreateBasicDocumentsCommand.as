package com.catlin.cargo.controller
{
	import com.catlin.cargo.ApplicationFacade;
	import com.catlin.cargo.model.BasicDocumentCriteria;
	
	import org.granite.tide.events.TideResultEvent;
	import org.puremvc.as3.interfaces.INotification;

	public class CreateBasicDocumentsCommand extends BaseCommand {
		
		public function CreateBasicDocumentsCommand() {
		}
		
		override public function execute(notification:INotification):void {
			var basicDocumentCriteria:BasicDocumentCriteria = notification.getBody() as BasicDocumentCriteria;
			tideContext.quoteService.createBasicQuoteDocuments(basicDocumentCriteria.brokerOffice.sid, 
				basicDocumentCriteria.usageDate, basicDocumentCriteria.currency, 
				basicDocumentCriteria.consumerType, basicDocumentCriteria.province, onCreateDocuments, onRemoteFault);
		}

		private function onCreateDocuments(event:TideResultEvent):void {
			sendNotification(ApplicationFacade.CREATE_BASIC_DOCUMENTS_COMPLETE, event.result);
		}
	}
}