/**
 * Author: Vijay Mahajan
 * Company: Cognizant Technology Solutions Asia Pacific Pte Ltd
 * Description: It is a QS_MonthlyCPKReportTriggerHandler class. It contains methods for each trigger events like before insert, 
                update and delete etc which invoke actual business logic.
 *             
 * History:
 * <Vijay>     08042014 - class created
 * 
 */
public without sharing class QS_MonthlyCPKReportTriggerHandler {
    
    private Boolean isExecuting = false;
    private Integer size = 0;
    public static Boolean isExecuted = false;

     /**
     * This is parametrized constructor
     *
     * @param   isExecuting     boolean variable to check trigger execution context
     * @param   size            size of list processing in trigger execution context
     */    
    public QS_MonthlyCPKReportTriggerHandler(Boolean isExecuting, Integer size){
        this.isExecuting = isExecuting;
        this.size = size;
    }
    
    
     /**
     * This method accepts trigger context variables for on before insert event and call the actual business logic
     *
     * @param   newMonthlyCPKReports      list of new Monthly CPK Report records
     */ 
    public void OnBeforeInsert(Monthly_CPK_Report__c[] newMonthlyCPKReports){
       
       Set<Id> cpkReportIdSet = new Set<Id>();
        
        for(Monthly_CPK_Report__c monthlyCPKReport : newMonthlyCPKReports){
            if(monthlyCPKReport.CPK_Report__c != null){
                cpkReportIdSet.add(monthlyCPKReport.CPK_Report__c);
            }
        }
        
        if(cpkReportIdSet != null && !cpkReportIdSet.isEmpty()){
            Map<Id, CPK_Report__c> cpkReportMap = ClsUpdateCPKReportOnReportUpload.CPKReportQuery(cpkReportIdSet);
            if(cpkReportMap != null && !cpkReportMap.isEmpty()){
                for(Monthly_CPK_Report__c monthlyCPKReport : newMonthlyCPKReports){
                    CPK_Report__c cpkReport = cpkReportMap.get(monthlyCPKReport.CPK_Report__c);
                    if(cpkReport != null){
                        monthlyCPKReport.QA_Approver__c = CPKReport.QA_Approver__c;
                        monthlyCPKReport.QA_Approver_backUp__c = CPKReport.QA_Approver_backUp__c;
                        cpkReport.Current_Report_Status__c = monthlyCPKReport.Approved__c;
                        if(monthlyCPKReport.Approved__c == 'No Reports'){
                            cpkReport.ReportUploaded__c = true; 
                        }
                    }
                }
                update cpkReportMap.Values();
            }
        } 
    }
    
     /**
     * This method accepts trigger context variables for on after update event and call the actual business logic
     *
     * @param   oldmonthlyCPKReports          list of old Monthly CPK Report records
     * @param   updatedmonthlyCPKReports      list of updated Monthly CPK Report records
     * @param   oldmonthlyCPKReportMap        map of old Monthly CPK Report records
     * @param   updatedmonthlyCPKReportMap    map of updated Monthly CPK Report records
     */ 
    public void OnAfterUpdate(Monthly_CPK_Report__c[] oldmonthlyCPKReports, Monthly_CPK_Report__c[] updatedmonthlyCPKReports, 
                              Map<ID, Monthly_CPK_Report__c>  oldmonthlyCPKReportMap, Map<ID, Monthly_CPK_Report__c>  updatedmonthlyCPKReportMap ){
        if(!isExecuted){
            
            //DBiswal 02102015
            System.debug('---------------'+updatedmonthlyCPKReports[0]);
            if(oldmonthlyCPKReports[0].Approved__c!='No Reports' && updatedmonthlyCPKReports[0].Approved__c == 'No Reports'){
                CPKReportRelatedList.Createfolder(updatedmonthlyCPKReports[0].Id);               
            }    
                /*if(oldmonthlyCPKReports[0].Approved__c=='Pending Approval' && (updatedmonthlyCPKReports[0].Approved__c == 'Approved' || updatedmonthlyCPKReports[0].Approved__c == 'No Reports')){
                    if (ClsUpdateCPKReportOnReportUpload.counter == 1){ 
                        System.debug('-----In If----------'+updatedmonthlyCPKReports[0]);               
                        ClsUpdateCPKReportOnReportUpload.updateCpkDateAfterReportApproval(updatedmonthlyCPKReports[0]);        
                    }
                }*/
                
            Set<Id> SCPKIds=new Set<Id>();
            for (Monthly_CPK_Report__c monthlyReportUpload : updatedmonthlyCPKReports){
                if(monthlyReportUpload.Approved__c != null && monthlyReportUpload.Approved__c != oldmonthlyCPKReportMap.get(monthlyReportUpload.Id).Approved__c ){
                    SCPKIds.add(monthlyReportUpload.CPK_Report__c);
                }
            }
            if(SCPKIds != null && !SCPKIds.isEmpty()){
                List<CPK_Report__c> LSelCPKReports = new List<CPK_Report__c>([Select id,Current_Report_Status__c,isUpdatedFromReport__c,(Select Id,Approved__c from Monthly_CPK_Reports__r  order by createdDate desc limit 1) from CPK_Report__c where Id in :(SCPKIds)]);
                   
                for(CPK_Report__c eachCPKReport : LSelCPKReports){
                    eachCPKReport.Current_Report_Status__c = eachCPKReport.Monthly_CPK_Reports__r[0].Approved__c;
                    eachCPKReport.isUpdatedFromReport__c = true;
                }
                if(LSelCPKReports != null && !LSelCPKReports.isEmpty()){
                    database.update(LSelCPKReports);
                }
            }          
            
            isExecuted = true;
        }
        
    }
    
     /**
     * This method accepts trigger context variables for on before delete event and call the actual business logic
     *
     * @param   oldMonthlyCPKReports       list of old Monthly CPK Report records
     */ 
    public void OnBeforeDelete(Monthly_CPK_Report__c[] oldMonthlyCPKReports){
        List<Id> lCPKReportIds= new List<Id>();
        List<CPK_Report__c> LCPKReports=new List<CPK_Report__c>();
        Map<String,String> mapId = new Map<String,String>();
        for(Monthly_CPK_Report__c  accList : oldMonthlyCPKReports){
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
    }
    
    /**
     * This method accepts trigger context variables on after insert event and call the actual business logic
     *
     * @param   updatedmonthlyCPKReports      list of updated Monthly CPK Report records
     * @param   oldmonthlyCPKReportMap        map of old Monthly CPK Report records
     * @param   updatedmonthlyCPKReportMap    map of updated Monthly CPK Report records
     */
    //DBiswal 02232015  
    public void OnAfterInsert(Monthly_CPK_Report__c[] newmonthlyCPKReports, Map<ID, Monthly_CPK_Report__c>  newmonthlyCPKReportMap){
        if(!System.isBatch()){
            CPKReportRelatedList.Createfolder(newmonthlyCPKReports[0].Id);
        }
        Set<Id> sCPKIds=new Set<Id>();        
        for(Monthly_CPK_Report__c mcpk : newmonthlyCPKReportMap.values()){
            sCPKIds.add(mcpk.CPK_Report__c);
        }
        Map<Id,CPK_Report__c> mapCPKReports = new Map<Id,CPK_Report__c>([Select id,Reminder__c from CPK_Report__c where Id in :sCPKIds]);
        for(Id mcpkId : newmonthlyCPKReportMap.keySet()){
            for(Id cpkId: mapCPKReports.keySet()){
                if(newmonthlyCPKReportMap.get(mcpkId).CPK_Report__c == cpkId){
                    if(newmonthlyCPKReportMap.get(mcpkId).Report_Due_Date__c == mapCPKReports.get(cpkId).Reminder__c){
                        ClsUpdateCPKReportOnReportUpload.updateCpkDateAfterReportApproval(newmonthlyCPKReportMap.get(mcpkId));   
                    }
                }  
            }            
        }
            
    }
        
}