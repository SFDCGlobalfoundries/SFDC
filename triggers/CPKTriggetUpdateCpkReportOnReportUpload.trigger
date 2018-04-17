/*
Project      : CPK Reports 
Name         : TriggetUpdateCPKReportOnReportUpload 
Author       : Cognizant 
Created Date : 3-july-2013
Reason       : To update the reminder date for next month based on the report upload for the current month
Change History:
Author       : Bhavana Mohan 
Modified Date: 
Reason       : 
……..
……..
 */
trigger CPKTriggetUpdateCpkReportOnReportUpload on Report_Upload__c (before delete,before insert, after insert,before Update,after Update){
    List<ID> reportUploadIdList = new List<ID>();
    List<Monthly_CPK_Report__c> monthlyCPKReportList = new List<Monthly_CPK_Report__c>();
    List<CPK_Report__c> cpkReportList = new List<CPK_Report__c>();
    List<Id> cpkId = new List<Id>();
    
    if(Trigger.isInsert){
    	
        if(Trigger.isBefore){
            for(Report_Upload__c reportUpload : trigger.new){
                reportUpload.Last_Report_For_the_month__c = true;   
            }
        }
        
        if(Trigger.isAfter){
            ClsUpdateCPKReportOnReportUpload.AfterTriggerInsert(Trigger.New);
        }
    }
   
    if(Trigger.isDelete){
        Map<String,String> mapId = new Map<String,String>();
        for(Report_Upload__c accList : Trigger.old){
            mapId.put(accList.Id,accList.OpenTextId__c+';');
        }
        ClsUpdateCPKReportOnReportUpload.CreateDeleteObject(mapId);
    } 
   
}