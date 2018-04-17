trigger SFDCProjectMilestoneAfterUpdate on SFDC_Project_Milestone__c (after update)
{
     List<SFDC_Task__c> childlist = new List<SFDC_Task__c>();
     List<SFDC_Project_Stage__c> parentlist = new List<SFDC_Project_Stage__c>();
     List<String> completedIdList = new List<String>();
     Set<String> uncompletedIds = new Set<String>();     
     for(SFDC_Project_Milestone__c rec: Trigger.NEW)
     {
         if(rec.Completed__c)
         {
            completedIdList.add(rec.Id);
         }else
         {
            uncompletedIds.add(rec.Stage__c);      
         }
     }
     
     childlist = [Select Id, Completed__c from SFDC_Task__c where Milestone__c in :completedIdList];
     for(SFDC_Task__c u:childlist)
     {
         u.Completed__c = true;
     }
     
      
     parentlist = [Select Id, Completed__c from  SFDC_Project_Stage__c where id in :uncompletedIds];
     
     for(SFDC_Project_Stage__c stage:parentlist)
     {
        stage.Completed__c = false;  
     }
     
     update childlist;     
     update parentlist;

     
}