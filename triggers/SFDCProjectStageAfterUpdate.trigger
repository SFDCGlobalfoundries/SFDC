trigger SFDCProjectStageAfterUpdate on SFDC_Project_Stage__c (after update)
{
     List<SFDC_Project_Milestone__c> mlist = new List<SFDC_Project_Milestone__c>();
     List<String> completedIdList = new List<String>();
     for(SFDC_Project_Stage__c rec: Trigger.NEW)
     {
         if(rec.Completed__c)
         {
            completedIdList.add(rec.Id);
         }
     
     }
     
     mlist = [Select Id, Completed__c from SFDC_Project_Milestone__c where Stage__c in :completedIdList];
     for(SFDC_Project_Milestone__c m:mlist)
     {
         m.Completed__c = true;
     }
     
     update mlist;
     
}