trigger SFDCProjectStatusInsertUpdate on SFDC_Project_Status__c (after insert, after update) 
{
   List<SFDC_Project__c> projects = null;
   List<String> projectIds = new List<String>();
   Map<String,String> statusMap = new Map<String,String>();
   Map<String,Date> dateMap = new Map<String,Date>();
   String overallStatus = null;
   
   for(SFDC_Project_Status__c status: Trigger.new)
   {
       if((status.Resources__c == 'Red')||(status.Schedule__c == 'Red')||(status.Budget__c == 'Red'))
       {
           overallStatus = 'Red';
           
       }else if((status.Resources__c == 'Yellow')||(status.Schedule__c == 'Yellow')||(status.Budget__c == 'Yellow'))
       {
           overallStatus = 'Yellow';
       }
       else
       {
           overallStatus = 'Green';
       }
       
       projectIds.add(status.Project__c);
       statusMap.put(status.Project__c,overallStatus);
       dateMap.put(status.Project__c,status.Week_Ending_Date__c);       
   }
   
   Date now = Date.today();
   projects = [SELECT Id, Overall_Status__c,Status_Date__c from SFDC_Project__c where id in :projectIds];
   for(SFDC_Project__c proj: projects)
   {
       proj.Overall_Status__c = statusMap.get(proj.Id);
       proj.Status_Date__c = dateMap.get(proj.Id);
       if(proj.Status_Date__c == null)
       {
         proj.Status_Date__c = now;
       }    
   }
   
   
   Database.SaveResult[] uresults = Database.update(projects,true);
}