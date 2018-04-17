trigger SFDCTaskAfterUpdate on SFDC_Task__c (after update) 
{
    Set<String> uncompletedIds = new Set<String>();
    List<SFDC_Project_Milestone__c> ulist = null;
    for(SFDC_Task__c task: Trigger.NEW)
     {
          if(!task.Completed__c)
          {
              uncompletedIds.add(task.Milestone__c);
          }         
     }
    
     ulist = [Select Id, Completed__c from  SFDC_Project_Milestone__c where id in :uncompletedIds];
     
     for(SFDC_Project_Milestone__c milestone:ulist)
     {
        milestone.Completed__c = false;  
     }
     
     update ulist;
}