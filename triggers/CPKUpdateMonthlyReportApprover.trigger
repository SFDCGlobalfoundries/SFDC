/*
Project      : CPK Reports 
Name         : UpdateMonthlyReportApprover 
Author       : Cognizant 
Created Date : 3-july-2013
Reason       : To update the approver for the report upload
Change History:

Author            Modified date      Reason for Change
Ankit Singhal     Dec 23,2013        1. Reflect the Latest Report's Approval Status on CPK Report

 */

trigger CPKUpdateMonthlyReportApprover on Monthly_CPK_Report__c (before insert,after insert,before delete,after Update) {
    
    QS_MonthlyCPKReportTriggerHandler monthlyCPKReportTriggerHandler = new QS_MonthlyCPKReportTriggerHandler(Trigger.isExecuting, Trigger.size);
    if(Trigger.isInsert){
        /*
        Map<ID,Monthly_CPK_Report__c> idMap = new Map<ID,Monthly_CPK_Report__c>();
        List<ID> monthlyReportUploadIdList = new List<ID>();
        List<CPK_Report__c> CPKReportList = new List<CPK_Report__c>();
        List<Monthly_CPK_Report__c> monthlyInsList = new List<Monthly_CPK_Report__c>();
         
        for (Monthly_CPK_Report__c monthlyReportUpload : trigger.new){
            if(monthlyReportUpload.CPK_Report__c != null){
                idMap.put(monthlyReportUpload.CPK_Report__c,monthlyReportUpload);
                monthlyReportUploadIdList.add(monthlyReportUpload.CPK_Report__c);
            }
        }
        if(monthlyReportUploadIdList != null && monthlyReportUploadIdList.size()> 0){
            CPKReportList = ClsUpdateCPKReportOnReportUpload.CPKReportQuery(monthlyReportUploadIdList);
            for(CPK_Report__c CPKReport : CPKReportList){
                Monthly_CPK_Report__c monthlyreportUploadins = idMap.get(CPKReport.id);
                monthlyreportUploadins.QA_Approver__c = CPKReport.QA_Approver__c;
                monthlyreportUploadins.QA_Approver_backUp__c = CPKReport.QA_Approver_backUp__c;
                CPKReport.Current_Report_Status__c='Draft';
                //monthlyreportUploadins.Report_Due_Date__c = CPKReport.Reminder__c;
                monthlyInsList.add(monthlyreportUploadins);
            }
            database.update(CPKReportList);
        }*/
        if(Trigger.isBefore){
            monthlyCPKReportTriggerHandler.OnBeforeInsert(Trigger.new);  
        }else if(Trigger.isAfter){
            monthlyCPKReportTriggerHandler.OnAfterInsert(Trigger.new,Trigger.newMap);
        }
    }
 
    if(Trigger.isDelete){
        /*   
        List<Id> lCPKReportIds= new List<Id>();
        List<CPK_Report__c> LCPKReports=new List<CPK_Report__c>();
        Map<String,String> mapId = new Map<String,String>();
        for(Monthly_CPK_Report__c  accList : Trigger.old){
            //List<String> PublishIds=new List<String>(acclist.status__c.split(';'));
            mapId.put(accList.Id,accList.OpenTextId__c+';');
            lCPKReportIds.add(accList.CPK_Report__c);
        }
        //LCPKReports=ClsUpdateCPKReportOnReportUpload.CPKReportQuery(lCPKReportIds);
        List<CPK_Report__c> LSelCPKReports=new List<CPK_Report__c>([Select id,Current_Report_Status__c,(Select Id,Approved__c from Monthly_CPK_Reports__r where Id NOT IN :(mapId.keyset()) order by createdDate desc limit 1) from CPK_Report__c where Id in :(lCPKReportIds)]);
        ClsUpdateCPKReportOnReportUpload.CreateDeleteObject(mapId);
        if(!LSelCPKReports.isEmpty()){
            for(CPK_Report__c eachCPKReport : LSelCPKReports){
                if(!eachCPKReport.Monthly_CPK_Reports__r.isEmpty()){
                    eachCPKReport.Current_Report_Status__c= eachCPKReport.Monthly_CPK_Reports__r[0].Approved__c;
                }        
            }
        }
        database.update(LSelCPKReports);
       */
       monthlyCPKReportTriggerHandler.OnBeforeDelete(Trigger.old); 
    }
    
    if (Trigger.isUpdate){
        /*
        System.debug('---------------'+Trigger.New[0]);
        if(Trigger.Old[0].Approved__c=='Pending Approval' && (Trigger.New[0].Approved__c == 'Approved' || Trigger.New[0].Approved__c == 'No Reports')){
            if (ClsUpdateCPKReportOnReportUpload.counter == 1){ 
                System.debug('-----In If----------'+Trigger.New[0]);               
                ClsUpdateCPKReportOnReportUpload.updateCpkDateAfterReportApproval(Trigger.New[0]);        
            }
        }else{
            Set<Id> SCPKIds=new Set<Id>();
            for (Monthly_CPK_Report__c monthlyReportUpload : trigger.new){
                SCPKIds.add(monthlyReportUpload.CPK_Report__c);
            }
            List<CPK_Report__c> LSelCPKReports=new List<CPK_Report__c>([Select id,Current_Report_Status__c,(Select Id,Approved__c from Monthly_CPK_Reports__r  order by createdDate desc limit 1) from CPK_Report__c where Id in :(SCPKIds)]);
            for(CPK_Report__c eachCPKReport : LSelCPKReports){
                eachCPKReport.Current_Report_Status__c = eachCPKReport.Monthly_CPK_Reports__r[0].Approved__c;       
            }
            database.update(LSelCPKReports);
        }
      */
        monthlyCPKReportTriggerHandler.OnAfterUpdate(Trigger.old, Trigger.new, Trigger.oldMap, Trigger.newMap);
    }

}