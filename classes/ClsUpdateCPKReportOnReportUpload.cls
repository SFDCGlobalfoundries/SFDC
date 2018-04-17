/*
Project      : CPK Reports 
Name         : ClsUpdateCPKReportOnReportUpload 
Author       : Cognizant 
Created Date : 8-july-2013
Reason       : To update the cpk report on report upload
Change History:
Author       : Bhavana Mohan 
Modified Date: 
Reason       : 
……..
……..
 */
public without sharing class ClsUpdateCPKReportOnReportUpload
{
    public static List<CPK_Report__c> cpkReportList = new List<CPK_Report__c>();
    public static List<Id> cpkId = new List<Id>();
    public static Integer counter = 1; 
    
    public static List<Monthly_CPK_Report__c> monthlyCPKReportQuery(List<ID> idList){
        return [select Name, Status__c, CPK_Report__c, CPK_Report__r.OwnerId,Count_Report_Uploaded__c from Monthly_CPK_Report__c where Id IN : idList];  
    }
    
    public static Map<Id, CPK_Report__c> CPKReportQuery(Set<ID> cpkReportIdSet){
        return new Map<Id, CPK_Report__c>([Select c.Report_Cycle__c, c.ReportUploaded__c, c.Reminder__c, c.Reminder_Updated__c, 
                                                  c.OpenTextId__c, c.Name, c.OwnerId, c.QA_Approver__c, c.Current_Report_Status__c,
                                                  c.QA_Approver_backUp__c, c.Report_Cycle_Day__c From CPK_Report__c c Where id IN : cpkReportIdSet]);
    }
    
   /*
    public static void UpdateAccessList(CPK_Report_Access_List__c accList, Map<ID,List<ID>> accTeamProxyMap,Map<ID,String> accTeamProxyFabMap){
        if(!accTeamProxyMap.isEmpty() && accTeamProxyMap.containsKey(accList.Account__c)){
            if(accTeamProxyMap.get(accList.Account__c).size()>0 && accList.Fab__c.equals(accTeamProxyFabMap.get(accList.Account__c))){
                accList.CE_Owner_1__c = accTeamProxyMap.get(accList.Account__c)[0];
            }
            if(accTeamProxyMap.get(accList.Account__c).size()>1 && accList.Fab__c.equals(accTeamProxyFabMap.get(accList.Account__c))){
                accList.CE_Owner_2__c = accTeamProxyMap.get(accList.Account__c)[1];
            }
            if(accTeamProxyMap.get(accList.Account__c).size()>2 && accList.Fab__c.equals(accTeamProxyFabMap.get(accList.Account__c))){
                accList.CE_Owner_3__c = accTeamProxyMap.get(accList.Account__c)[2];
            }
            if(accTeamProxyMap.get(accList.Account__c).size()>3 && accList.Fab__c.equals(accTeamProxyFabMap.get(accList.Account__c))){
                accList.CE_Owner_4__c = accTeamProxyMap.get(accList.Account__c)[3];
            }
            if(accTeamProxyMap.get(accList.Account__c).size()>4 && accList.Fab__c.equals(accTeamProxyFabMap.get(accList.Account__c))){
                accList.CE_Owner_5__c = accTeamProxyMap.get(accList.Account__c)[4];
            }
        }
    }*/
  
  
    public static Monthly_CPK_Report__c createNewReport(CPK_Report__c cpkReportins,String recordName){
          
        Monthly_CPK_Report__c monthlyCpkRFeportIns = new Monthly_CPK_Report__c();
        monthlyCpkRFeportIns.Name = recordName+'|'+string.valueOf(cpkReportins.Reminder__c.addMonths(-1));
        monthlyCpkRFeportIns.CPK_Report__c = cpkReportins.Id;   
        monthlyCpkRFeportIns.QA_Approver__c = cpkReportins.QA_Approver__c;
        monthlyCpkRFeportIns.QA_Approver_backUp__c = cpkReportins.QA_Approver_backUp__c;
        monthlyCpkRFeportIns.Report_Due_Date__c = cpkReportins.Reminder__c;
        monthlyCpkRFeportIns.Approved__c= 'Draft';
        monthlyCpkRFeportIns.Sync_to_OpenText__c = true;
        return monthlyCpkRFeportIns;
    }
    
    public static void AfterTriggerInsert(List<Report_Upload__c> reportUploadedList){
        List<Id> monthlyCPKReportIdList = new List<Id>();
        List<Monthly_CPK_Report__c> monthlyCPKReportList = new List<Monthly_CPK_Report__c>();
        for(Report_Upload__c reportUpload : reportUploadedList){
            monthlyCPKReportIdList.add(reportUpload.Monthly_CPK_Report__c);
        }
        if(monthlyCPKReportIdList != null && !monthlyCPKReportIdList.isEmpty()){
            monthlyCPKReportList = monthlyCPKReportQuery(monthlyCPKReportIdList);
        }
        if(monthlyCPKReportList != null && !monthlyCPKReportList.isEmpty()){
            Set<CPK_Report__c> cpkReportSet = new Set<CPK_Report__c>();
            for(Monthly_CPK_Report__c monthlyCPKReport: monthlyCPKReportList){
                if(monthlyCPKReport.Count_Report_Uploaded__c < 1){
                    cpkReportSet.add(new CPK_Report__c(Id = monthlyCPKReport.CPK_Report__c, ReportUploaded__c = true));
                }
            }
            
            if(cpkReportSet != null && !cpkReportSet.isEmpty()){
                update new List<CPK_Report__c>(cpkReportSet);
            }   
        }
    }
    
    public static CPK_Report__c  UpdateReportDueDate(CPK_Report__c cpkRt,Monthly_CPK_Report__c monthlyCPKreport){ 
        system.debug('########Inside UpdateReportDueDate######');
        counter++;
        Date myDate;
        Integer remindDate;
        
        if(cpkRt.Report_Cycle_Day__c != NULL){
            remindDate = Integer.valueOf(cpkRt.Report_Cycle_Day__c);

            //DBiswal 01262015 - Changed conditions for Reminder mail
            if(cpkRt.Report_Cycle__c == 'Monthly'){
                myDate = monthlyCPKreport.Report_Due_Date__c.addMonths(1); 
                cpkRt.Reminder__c = myDate; 
            }
            else if(cpkRt.Report_Cycle__c == 'Bi-Monthly'){
                myDate = monthlyCPKreport.Report_Due_Date__c.addMonths(2);
                cpkRt.Reminder__c = myDate;
            }
            else if(cpkRt.Report_Cycle__c == 'Quarterly'){
                myDate = monthlyCPKreport.Report_Due_Date__c.addMonths(3);
                cpkRt.Reminder__c = myDate;
            }
            else if(cpkRt.Report_Cycle__c == 'Half yearly'){
                myDate = monthlyCPKreport.Report_Due_Date__c.addMonths(6);
                cpkRt.Reminder__c = myDate;
            }
            cpkRt.Remind_To_Upload__c = myDate - remindDate;
        }else{
            cpkRt.Remind_To_Upload__c = myDate;
        }
        cpkRt.Current_Report_Status__c = monthlyCPKreport.Approved__c;
        cpkRt.ReportUploaded__c = false;
        
        if(monthlyCPKreport.Approved__c == 'Approved'){
            cpkRt.Release_Date__c = System.TODAY();
            if(monthlyCPKreport.Report_Due_Date__c !=NULL){
                cpkRt.Report_Month__c = datetime.newInstance(monthlyCPKreport.Report_Due_Date__c.addMonths(-1).year(),
                                                             monthlyCPKreport.Report_Due_Date__c.addMonths(-1).month(),
                                                             monthlyCPKreport.Report_Due_Date__c.addMonths(-1).day()
                                                             ).format('MMM-YYYY');
            }
        }
        update cpkRt;
        
        system.debug('After Update Cpk Report >>>>>>>>>'+cpkRt.Remind_To_Upload__c);
        system.debug('Later Date >> After 1 month date >>>>>'+cpkRt.Reminder__c);
     
        return cpkRt;
    }
    
    public static void  CreateDeleteObject(Map<String,String> MapId){
        List<DeleteObjectFromOpenText__c> DeleteObjectList = new List<DeleteObjectFromOpenText__c>();
        List<DeleteObjectFromOpenText__c> DeleteObjectInsertList = new List<DeleteObjectFromOpenText__c>();
        DeleteObjectList = [select Id from DeleteObjectFromOpenText__c where Status__c = 'SUCCESS'limit 999];
        for(String id: MapId.keySet()){
            for(String otid : MapId.get(id).split(';')){
                if(otid!=null && otid!=''){
                    DeleteObjectFromOpenText__c deleteobjectIns = new DeleteObjectFromOpenText__c();
                    //deleteobjectIns.OpenTextId__c = MapId.get(id);
                    deleteobjectIns.OpenTextId__c = otid;
                    deleteobjectIns.SFDCId__c = id;
                    deleteobjectIns.Source__c = 'CPK';
                    DeleteObjectInsertList.add(deleteobjectIns);
                }
            }
        }
        try{
            if(DeleteObjectList != null && DeleteObjectList.size() > 0){
                delete DeleteObjectList; 
            }
            insert DeleteObjectInsertList;
        }catch(Exception e){
            system.debug('Exception during deleteobject Insertion or deletion is'+e);
        }
    }

    // Code Added to fix CPK Report Date Issue
    
    public static void updateCpkDateAfterReportApproval(Monthly_CPK_Report__c monthlyCPKreport){
       
        system.debug('Inside updateCpkDateAfterReportApproval>>>>>>');
        List<CPK_Report__c> CPKReportQuery = [Select c.Report_Cycle__c, 
                                                     c.ReportUploaded__c, 
                                                     c.Reminder__c, 
                                                     c.Reminder_Updated__c, 
                                                     c.OpenTextId__c, 
                                                     c.Name,
                                                     c.OwnerId,
                                                     c.QA_Approver__c,
                                                     c.QA_Approver_backUp__c,
                                                     c.Report_Cycle_Day__c,
                                                     (Select Id,Approved__c,
                                                      Report_Due_Date__c from Monthly_CPK_Reports__r  order by createdDate desc limit 1)
                                              From CPK_Report__c c 
                                              Where Id =: monthlyCPKreport.CPK_Report__c];
        if(!CPKReportQuery.isEmpty()){
            system.debug('########Before UpdateReportDueDate######');
            //DBiswal 02112015
            if(!CPKReportQuery[0].Monthly_CPK_Reports__r.isEmpty()){
                if(CPKReportQuery[0].Monthly_CPK_Reports__r[0].Report_Due_Date__c == CPKReportQuery[0].Reminder__c){
                    ClsUpdateCPKReportOnReportUpload.UpdateReportDueDate(CPKReportQuery[0],monthlyCPKreport);
                }
            } else{
                ClsUpdateCPKReportOnReportUpload.UpdateReportDueDate(CPKReportQuery[0],monthlyCPKreport);
            }
        }
    }
    
    public static void updateAccessList(CPK_Report_Access_List__c associatedCustomer, Map<String, List<Account_Team_Proxy__c>> accountTeamProxyListMap){
        if(accountTeamProxyListMap != null && accountTeamProxyListMap.containsKey(associatedCustomer.Account__c)){
            Integer cnt = 0;
            for(Account_Team_Proxy__c accountTeamProxy: accountTeamProxyListMap.get(associatedCustomer.Account__c)){
                if(accountTeamProxy.User__r.Fab_Assigned__c != null && accountTeamProxy.User__r.Fab_Assigned__c != ''){
                    List<String> assignFABList = accountTeamProxy.User__r.Fab_Assigned__c.split(';');
                    Set<String> assignFABSet = (assignFABList != null && !assignFABList.isEmpty()) ? new Set<String>(assignFABList):null;
                    
                    if(assignFABSet != null && assignFABSet.contains(associatedCustomer.Fab__c)){
                        if(cnt == 5){
                            break;
                        }
                        if(cnt == 0){
                            associatedCustomer.CE_Owner_1__c = accountTeamProxy.User__c;
                        }
                        if(cnt == 1){
                            associatedCustomer.CE_Owner_2__c = accountTeamProxy.User__c;
                        }
                        if(cnt == 2){
                            associatedCustomer.CE_Owner_3__c = accountTeamProxy.User__c;
                        }
                        if(cnt == 3){
                            associatedCustomer.CE_Owner_4__c = accountTeamProxy.User__c;
                        }
                        if(cnt == 4){
                            associatedCustomer.CE_Owner_5__c = accountTeamProxy.User__c;
                        }
                        cnt++;
                    }
                }
            }
        }
    }

}