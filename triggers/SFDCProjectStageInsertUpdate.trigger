trigger SFDCProjectStageInsertUpdate on SFDC_Project_Stage__c (before insert, before update)
{
     for(SFDC_Project_Stage__c rec: Trigger.NEW)
     {
         if((rec.End_Date__c != null)&&(rec.Start_Date__c != null))
         {
             if(rec.End_Date__c < rec.Start_Date__c)
             {
                 rec.addError('Stage: ' + rec.Name__c + ', End Date of ' + rec.End_Date__c + ' cannot be less than Start Date of ' + rec.Start_Date__c);
             }
         }
     
     }


}