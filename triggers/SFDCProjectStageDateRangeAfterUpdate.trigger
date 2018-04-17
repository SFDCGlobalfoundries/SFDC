trigger SFDCProjectStageDateRangeAfterUpdate on SFDC_Project_Stage__c (after update)
{
     List<SFDC_Project_Milestone__c> mlist = new List<SFDC_Project_Milestone__c>();
     List<SFDC_Project_Milestone__c> ulist = new List<SFDC_Project_Milestone__c>();
     List<String> idList = new List<String>();
     SFDC_Project_Stage__c stage = null;
     Map<String,SFDC_Project_Stage__c> stageMap = new Map<String,SFDC_Project_Stage__c>();
     for(SFDC_Project_Stage__c rec: Trigger.NEW)
     {
        idList.add(rec.Id);
        stageMap.put(rec.Id,rec);
     }
     
     mlist = [Select Id, Completed__c, Start_Date__c, End_Date__c,Stage__c from SFDC_Project_Milestone__c where Stage__c in :idList];
     Boolean blank = false;
     for(SFDC_Project_Milestone__c m:mlist)
     {
         stage = stageMap.get(m.Stage__c);
         blank = false;
         
         if(stage.Start_Date__c == null)
         {
             blank = true;
         }else if((m.Start_Date__c != null)&&(stage.Start_Date__c > m.Start_Date__c))
         {
             blank = true;
         }else if((m.End_Date__c != null)&&(stage.End_Date__c != null)&&(stage.End_Date__c < m.End_Date__c))
         {
             blank = true;
         } 
         
         
         if(blank)
         {
             m.Start_Date__c = null;
             m.End_Date__c = null;
             m.Completed__c = false;
             ulist.add(m);
         }
     }
     
     update ulist;
     
}