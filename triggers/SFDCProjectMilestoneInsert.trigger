trigger SFDCProjectMilestoneInsert on SFDC_Project_Milestone__c (before insert, before update)
{

    Map<String,SFDC_Project_Stage__c> stages = new Map<String,SFDC_Project_Stage__c>();
    SFDC_Project_Stage__c stage = null;
    
     for(SFDC_Project_Milestone__c milestone: Trigger.NEW)
     {
         stage = stages.get(milestone.Stage__c);
         if(stage == null)
         {
             List<SFDC_Project_Stage__c> slist = [SELECT id, Name, Start_Date__c, End_Date__c from SFDC_Project_Stage__c where id = :milestone.Stage__c];
             if(slist.size() == 1)
             {
                stage = slist.get(0);
                stages.put(milestone.Stage__c,stage);
             }
         }
         
         if((milestone.End_Date__c != null)&&(milestone.Start_Date__c != null))
         {
             if(milestone.End_Date__c < milestone.Start_Date__c)
             {
                 milestone.addError('Milestone End Date of ' + milestone.End_Date__c + ' cannot be less than Milestone Start Date of ' + milestone.Start_Date__c);
             }
         }
         
         if(stage != null)
         {
             if((milestone.Start_Date__c != null)&&(stage.Start_Date__c != null))
             {
                 if(milestone.Start_Date__c < stage.Start_Date__c)
                 {
                    milestone.addError('Milestone \"' + milestone.Name + '\"  Start Date of ' + milestone.Start_Date__c + ' cannot be less than Stage Start Date of ' + stage.Start_Date__c);
                 }
             }
             
             if((milestone.End_Date__c != null)&&(stage.End_Date__c != null))
             {
                 if(milestone.End_Date__c > stage.End_Date__c)
                 {
                    milestone.addError('Milestone \"' + milestone.Name + '\" End Date of ' + milestone.End_Date__c + ' cannot be greater than Stage End Date of ' + stage.End_Date__c);
                 }
             }
         }
         
         if(milestone.Completed_Date__c != null)
         {
             milestone.Completed__c = true;
         }
     
     }

}