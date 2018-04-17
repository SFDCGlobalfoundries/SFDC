trigger SFDCChangeRequestBeforeInsertUpdate on SFDC_Change_Request__c (before insert, before update) 
{
     for(SFDC_Change_Request__c cr:Trigger.NEW)
     {
         if(((cr.Status__c == 'Closed-Accepted')||(cr.Status__c == 'Closed-Rejected'))&&(cr.Actual_Close_Date__c == null))
         {
              cr.addError('Actual Close Date is required if status is Closed-Accepted or Closed-Rejected');
              continue;
         }
         

         
        if((cr.Status__c == 'On Hold')&&(cr.Resume_Date__c == null))
         {
              cr.addError('Resume Date is required if status is On Hold');
              continue;
         }
         
          


              
          if(cr.Close_Date__c != null)
          {
             if(cr.Start_Date__c == null)
             {
                cr.addError('Start date cannot be blank if close date is populated');
             }else if(cr.Close_Date__c < cr.Start_Date__c)
             {
                cr.addError('Close Date of ' + cr.Close_Date__c + ' cannot come before Start Date of ' + cr.Start_Date__c );
             }else if((cr.Resume_Date__c != null)&&(cr.Close_Date__c < cr.Resume_Date__c))
             {
                cr.addError('Close Date of ' + cr.Close_Date__c + ' cannot come before Resume Date of ' + cr.Resume_Date__c );
             }
          }else if(cr.Resume_Date__c != null)
          {
              if(cr.Start_Date__c == null)
             {
                cr.addError('Start date cannot be blank if resume date is populated');
             }else if(cr.Resume_Date__c < cr.Start_Date__c)
             {
                cr.addError('Resume Date of ' + cr.Resume_Date__c + ' cannot come before Start Date of ' + cr.Start_Date__c );
             }
          }
     
     }


}