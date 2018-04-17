/*
    Author:      Deepti Narayan Biswal
    Description: This class creates CPK Reports Folder every month.

    History:
    DBiswal    02112015 - Class Creation.
    DBiswal    03102015 - Allow only one callout at a time.
*/
global class batchMonthlycpkReportCreation implements Database.batchable<sObject>{
   
   global String query = 'SELECT id,Reminder__c,Remind_To_Upload__c,Report_Cycle__c,Report_Cycle_Day__c,QA_Approver__c,QA_Approver_backUp__c,OpenTextId__c,LastModifiedDate from CPK_Report__c WHERE Active__c = true AND Stage__c=\'Approved\''; 
   
   global Database.QueryLocator start(Database.BatchableContext BC){
       return Database.getQueryLocator(query);
   }

   global void execute(Database.BatchableContext BC, 
                       List<CPK_Report__c> scope){
      
      List<CPK_Report__c> cpkreportList = new List<CPK_Report__c>();
      List<Monthly_CPK_Report__c> monthlyreportList = new List<Monthly_CPK_Report__c>();
      String recordName;
      
      //Only select the CPK reports Which have due date for current month
      for(CPK_Report__c cpk : scope){
          //DBiswal 02232015
          if(cpk.Reminder__c.month() == System.now().month()){
              cpkreportList.add(cpk);
          }
      }
      
      for(CPK_Report__c cpkreport : cpkreportList){
          if(cpkreport.Reminder__c != null){
              if(cpkreport.Report_Cycle__c == 'Monthly'){
                  recordName='M';
              } else if(cpkreport.Report_Cycle__c == 'Bi-Monthly'){
                  recordName='BM';
              } else if(cpkreport.Report_Cycle__c == 'Quarterly'){
                  recordName='Q';
              } else if(cpkreport.Report_Cycle__c == 'Half yearly'){
                  recordName='HF';
              }
          }
          
          //Get the default values for Monthly_CPK_Report__c record
          monthlyreportList.add(ClsUpdateCPKReportOnReportUpload.createNewReport(cpkreport,recordName));          
      }
      
      //Insert Monthly_CPK_Report__c values
      if(monthlyreportList != null && monthlyreportList.size() > 0){
          try{
              Database.insert(monthlyreportList,false);
          } catch(Exception ex){
              System.debug(ex.getMessage());
          }          
      }           
   }

   global void finish(Database.BatchableContext BC){
       
       //Call the batch class to make callout to OpenText
       //DBiswal 03102015
       if(!Test.isRunningTest()){
           batchMonthlycpkReportFolderCallout callout = new batchMonthlycpkReportFolderCallout();
           database.executebatch(callout,1);
       } else{
           database.executebatch(new batchMonthlycpkReportFolderCallout());
       }
   }
}