trigger SFDCProjectStageAfterDelete on SFDC_Project_Stage__c (after delete) 
{
    List<SFDC_Project_Milestone__c> dlist = new List<SFDC_Project_Milestone__c>();
    List<SFDC_Project_Milestone__c> tlist = null;
    
    for(SFDC_Project_Stage__c stage:Trigger.OLD)
    {
       tlist = [SELECT id from SFDC_Project_Milestone__c where Stage__c = :stage.id];
       for(SFDC_Project_Milestone__c m:tlist)
       {
          dlist.add(m);
       }
       
       
    }
    
    delete dlist;
}