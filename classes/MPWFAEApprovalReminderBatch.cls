/*
    Author: Kanishk Singh
    Description: Repeated reminders to FAE - MPW customer reservation approval 
                 please repeat the reminder message to FAE every day until task is closed.
    Change Log:  14/07/2017 Ravi Teja B - Added configuration related query and scope             
    
    
*/

global class MPWFAEApprovalReminderBatch implements Database.Batchable < sObject > {
    global string whomToNotify;
    global string objectAPIName;
    global List < sObject > start(Database.BatchableContext BC) {
        String query;
        if(objectAPIName != null && objectAPIName == 'Apttus_Proposal__Proposal__c'){
            if(whomToNotify != null){
                if(whomToNotify == 'FAE')
                    query = 'Select id,Name, Apttus_Proposal__Approval_Stage__c, Device__r.Owner.Email from Apttus_Proposal__Proposal__c where Apttus_Proposal__Approval_Stage__c=\'Submitted Phase\'';
                else if(whomToNotify == 'PIYE')//Both Packaging and PIYE
                    query = 'Select id,Name, Apttus_Proposal__Approval_Stage__c, Device__r.Owner.Email from Apttus_Proposal__Proposal__c where Apttus_Proposal__Approval_Stage__c=\'Process Accepted Phase\' or Apttus_Proposal__Approval_Stage__c=\'Package Accepted Phase\' or Apttus_Proposal__Approval_Stage__c=\'Configuration Design Phase\'';
            }
        }
        else
        query = 'Select id,Name,Form_Status__c from MPW_Reservation__c where Form_Status__c=\'Pending FAE Review\'';
        return Database.query(query);
    }

    global void execute(Database.BatchableContext BC, List <sObject> scope) {
        set < id > setMPWReservationId = new set < id > ();
        EmailTemplate objTemplate;
        Map<Id,String> ConfigIdFAEEmailMap = new Map<Id,String>();                                                        
        if(objectAPIName != null && objectAPIName == 'Apttus_Proposal__Proposal__c'){
            for (Apttus_Proposal__Proposal__c config: (List<Apttus_Proposal__Proposal__c>) scope) {
                setMPWReservationId.add(config.id);
                ConfigIdFAEEmailMap.put(config.Id,config.Device__r.Owner.Email);                                                                 
            }
            if(whomToNotify == 'FAE')
                objTemplate = [Select id from EmailTemplate where developername = 'Configuration_Reminder_for_FAE'];
            else if(whomToNotify == 'PIYE')
                objTemplate = [Select id from EmailTemplate where developername = 'Configuration_Reminder_for_PIYE'];                                                                                                        
        }
        else{
            for(MPW_Reservation__c mpwReservation: (List<MPW_Reservation__c>) scope) {
                setMPWReservationId.add(mpwReservation.id);
            }
            objTemplate = [Select id from EmailTemplate where developername = 'PendingFAEApprovalRemider'];
        }
        
        List < Messaging.SingleEmailMessage > lstSingleEmailMessage = MPWFAEApprovalReminderUtil.getApproversEmailList(setMPWReservationId,objTemplate.id,ConfigIdFAEEmailMap);
     
       if(lstSingleEmailMessage!=null && lstSingleEmailMessage.size()>0){
         Messaging.sendEmail(lstSingleEmailMessage);
       }
    }


    global void finish(Database.BatchableContext BC) {
        if(whomToNotify == 'FAE' && objectAPIName == 'Apttus_Proposal__Proposal__c'){
            MPWFAEApprovalReminderBatch obj= new MPWFAEApprovalReminderBatch();
            obj.objectAPIName = 'Apttus_Proposal__Proposal__c';
            obj.whomToNotify = 'PIYE';
            integer batchSize = 200;
            database.executebatch(obj, batchSize);
        }
    }


}