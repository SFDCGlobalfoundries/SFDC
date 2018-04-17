trigger SFDCProjectMilestoneAfterDelete on SFDC_Project_Milestone__c (after delete) {
   
   List<SFDC_Task__c> dlist = new List<SFDC_Task__c>();
   List<SFDC_Task__c> tlist = null;
   for(SFDC_Project_Milestone__c m:Trigger.OLD)
   {
       tlist = [Select id from SFDC_Task__c where Milestone__c = :m.Id];
       for(SFDC_Task__c t:tlist)
       {
         dlist.add(t);
       }
   }
   
   delete dlist;
   
}