trigger SFDCProjectBeforeInsertUpdate on SFDC_Project__c (before insert, before update) 
{
   List<SFDC_Project__c> plist = [Select id from SFDC_Project__c];
   Integer count = plist.size();
   Map<String,String> oldStatusMap = new Map<String,String>();
   String oldStatus = null;
   String newStatus = null;
   if(Trigger.IsUpdate)
   {
     for(SFDC_Project__c project:Trigger.OLD)
     {
         oldStatusMap.put(project.Id,project.Project_Status_Indicator__c);
     }
   }
   
   for(SFDC_Project__c project:Trigger.NEW)
   {
      if(project.Priority_Sequence__c > (count+1))
      {
          project.addError('Priority Sequence value cannot be greater than the total number of SFDC Projects num_projects = ' + (count+1));
      }
   
      if(Trigger.IsUpdate)
      {
          oldStatus = oldStatusMap.get(project.Id);
          newStatus = project.Project_Status_Indicator__c;
          if((oldStatus != null)&&(oldStatus.startsWith('Inactive'))&&(newStatus.startsWith('Inactive')))
          {
              project.addError('Inactive Projects cannot be updated, please change to Active in order to update.');
          } 
      }
   
   }


}