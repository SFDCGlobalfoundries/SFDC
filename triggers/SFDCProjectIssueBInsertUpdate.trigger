trigger SFDCProjectIssueBInsertUpdate on SFDC_Project_Issue__c (before insert, before update) 
{

     for(SFDC_Project_Issue__c issue: Trigger.NEW)
     {
         if((issue.Status__c == 'Open')&&(issue.Close_By_Date__c == null))
         {
             issue.addError('Close By Date is required if issue status is Open');
         }else if((issue.Status__c == 'On Hold')&&(issue.Resume_By_Date__c == null))
         {
             issue.addError('Resume By Date is required if issue status is On Hold');
         }else if((issue.Status__c == 'Closed')&&(issue.Actual_Closed_Date__c == null))
         {
             issue.addError('Actual Closed Date is required if issue status is Closed');
         }
     }
}