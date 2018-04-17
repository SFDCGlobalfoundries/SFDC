/*
Author: Shyam Ravindra Nair
Description: Apex class for sending annual reminder for CuSR Form.
History:
SNair     07012015     - code creation.
SNair     11012015     - updated code for quering CUSR Form.
SNair     09022015     - updated email template.
*/
global class CuSRFormAnnualReminderScheduler implements Schedulable{
    global void execute(SchedulableContext SC){
    	EmailTemplate templateForAnnualReminder = [select Id, Name from EmailTemplate where Name = 'CuSRFormAnnualReminderTemplate'];
        Date currentDate = Date.today();
        Integer tempMonth = currentDate.month()+1;
        if(tempMonth == 13){
        	tempMonth = 1;
        }
        String currentMonth = String.valueOf(tempMonth);
        UtilClassToGetAllFields util = new UtilClassToGetAllFields();
        String cusrFormFields = util.getAllFields('CuSR_Form__c');
        String query = 'select '+cusrFormFields+' from CuSR_Form__c where Request_Effective_Month__c = \''+currentMonth+'\' and Status__c = \'Implemented\' and Validity_Period_of_this_Request__c = \'EOL\'';
        List<CuSR_Form__c> cusrFormList = Database.query(query);
		List<AggregateResult> cusrOwnerList = [select OwnerId from CuSR_Form__c where Request_Effective_Month__c =: currentMonth and Status__c = 'Implemented' and Validity_Period_of_this_Request__c = 'EOL' group by OwnerId];
		Map<String, List<CuSR_Form__c>> finalInitiatorToCuSRMap = new Map<String, List<CuSR_Form__c>>();
		for(AggregateResult aggr: cusrOwnerList){
            String tempId = String.valueOf(aggr.get('OwnerId'));
			List<CuSR_Form__c> tempCuSRList = new List<CuSR_Form__c>();
			for(CuSR_Form__c cusr: cusrFormList){
				if(tempId == cusr.OwnerId){
					tempCuSRList.add(cusr);
				}
			}
			if(tempCuSRList.size() > 0){
				finalInitiatorToCuSRMap.put(tempId, tempCuSRList);	
			}
		}
        List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
        if(!finalInitiatorToCuSRMap.isEmpty()){
        	for(String key: finalInitiatorToCuSRMap.keySet()){
				List<CuSR_Form__c> tempCuSRFormList = finalInitiatorToCuSRMap.get(key);
				if(tempCuSRFormList.size() > 0){
					Messaging.SingleEmailMessage singleMail = new Messaging.SingleEmailMessage();
					singleMail.setReplyTo('do-not-reply@globalfoundries.com');
					singleMail.setSenderDisplayName('NO REPLY');
					singleMail.setTargetObjectId(key);
					singleMail.setWhatId(key);
					singleMail.saveAsActivity = false;
					String managerEmail = '';
					for(CuSR_Form__c tempCuSR: tempCuSRFormList){
						if(!managerEmail.contains(tempCuSR.Originator_Manager_Email__c)){
							managerEmail += tempCuSR.Originator_Manager_Email__c;
						}
					}
					if(managerEmail != ''){
						List<String> ccList = new List<String>();
						ccList.add(managerEmail);
						singleMail.setCcAddresses(ccList);  
					}
					singleMail.setTemplateId(templateForAnnualReminder.Id);
					mails.add(singleMail);
				}
        	}
        	if(!mails.isEmpty()){
        		 Messaging.sendEmail(mails);
        	}
        }
    }
}