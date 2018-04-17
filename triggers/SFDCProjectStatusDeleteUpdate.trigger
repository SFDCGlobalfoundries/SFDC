trigger SFDCProjectStatusDeleteUpdate on SFDC_Project_Status__c (before delete, before update) 
{
   if (Trigger.isUpdate) {
       for(SFDC_Project_Status__c oldStatus : Trigger.old){
           for(SFDC_Project_Status__c newStatus : Trigger.new){
               if(newStatus.Week_Ending_Date__c != oldStatus.Week_Ending_Date__c){
                   newStatus.addError('Week Ending Date is not allowed to modify.');
               }
               if(oldStatus.Week_Ending_Date__c != DateUtil.getCurrentWeekFridayLocalDate()){
                   newStatus.addError('Editing of past status is not allowed.');
               }
           }
       }
       
    }
    
    if (Trigger.isDelete) {
       for(SFDC_Project_Status__c oldStatus : Trigger.old){
           if(oldStatus.Week_Ending_Date__c != DateUtil.getCurrentWeekFridayLocalDate()){
                  oldStatus.addError('Deleting of past status is not allowed.');
           }
       }
       
    }   
   
}