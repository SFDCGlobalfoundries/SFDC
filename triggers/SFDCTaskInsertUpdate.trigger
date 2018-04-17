trigger SFDCTaskInsertUpdate on SFDC_Task__c (before insert, before update)
{

    Map<String,SFDC_Project_Milestone__c> milestones = new Map<String,SFDC_Project_Milestone__c>();
    SFDC_Project_Milestone__c milestone = null;
    
     for(SFDC_Task__c task: Trigger.NEW)
     {
         milestone = milestones.get(task.Milestone__c);
         if(milestone == null)
         {
             List<SFDC_Project_Milestone__c> mlist = [SELECT id, Name, Start_Date__c, End_Date__c from SFDC_Project_Milestone__c where id = :task.Milestone__c];
             if(mlist.size() == 1)
             {
                milestone = mlist.get(0);
                milestones.put(task.Milestone__c,milestone);
             }
         }
         
         if((task.Due_Date__c != null)&&(task.Start_Date__c != null))
         {
             if(task.Due_Date__c < task.Start_Date__c)
             {
                 task.addError('Due Date of ' + task.Due_Date__c + ' cannot be less than Start Date of ' + task.Start_Date__c);
             }
         }
         
         if(milestone != null)
         {
             if((task.Start_Date__c != null)&&(milestone.Start_Date__c != null))
             {
                 if(task.Start_Date__c < milestone.Start_Date__c)
                 {
                    task.addError('Start Date of ' + task.Start_Date__c + ' cannot be less than Milestone Start Date of ' + milestone.Start_Date__c);
                 }
             }
             
             if((task.Due_Date__c != null)&&(milestone.End_Date__c != null))
             {
                 if(task.Due_Date__c > milestone.End_Date__c)
                 {
                    task.addError('Due Date of ' + task.Due_Date__c + ' cannot be greater than Milestone End Date of ' + milestone.End_Date__c);
                 }
             }
         }
     
     }

}