/**
 * Author: Vijay Mahajan
 * Company: Cognizant Technology Solutions Asia Pacific Pte Ltd
 * Description: It is a QS_CPKReportTriggerHandler class. It contains methods for each trigger events like before insert, update and delete etc which invoke actual business logic.
 *             
 * History:
 * <Vijay>     07312014 - class created
 *  Amar                  class Modified to change record type
 */
public without sharing class QS_CPKReportTriggerHandler {
    
    private Boolean isExecuting = false;
    private Integer size = 0;
    public static Boolean isExecuted = false;
    public static Boolean isUpdated = true;
    private static final String SHARING_ACCESSLEVEL = 'Edit';
    private recordType rt;
     /**
     * This is parametrized constructor
     *
     * @param   isExecuting     boolean variable to check trigger execution context
     * @param   size            size of list processing in trigger execution context
     */    
    public QS_CPKReportTriggerHandler(Boolean isExecuting, Integer size){
        this.isExecuting = isExecuting;
        this.size = size;
        //To change record type of CPK Template for AllAssociateCustomer
        rt = new recordType();
        rt =[SELECT id,name from RecordType WHERE name='ForAssociateCustomers'];
    }
    
    
    /**
     * This method accepts trigger context variables for on before insert event and call the actual business logic
     *
     * @param   updatedcpkReports       list of updated CPK Report records
     */ 
    public void OnBeforeInsert(CPK_Report__c[] newCPKReports){
        Set<Id> fabIdSet = new Set<Id>();
        for(CPK_Report__c cpkReport: newCPKReports){
            System.debug('before insert');
            if(cpkReport.FABS__c != null){
                fabIdSet.add(cpkReport.FABS__c);
            }
            
        }
        assignQAApprovers(newCPKReports,fabIdSet);
    }
    
    
    /**
     * This method accepts trigger context variables for on after insert event and call the actual business logic
     *
     * @param   oldcpkReports           list of old CPK Report records
     * @param   updatedcpkReports       list of updated CPK Report records
     * @param   oldCPKReportMap     map of old CPK Report records
     * @param   updatedCPKReportMap map of updated CPK Report records
     */ 
    public void OnAfterInsert(CPK_Report__c[] oldcpkReports, CPK_Report__c[] updatedcpkReports, 
                              Map<ID, CPK_Report__c>  oldCPKReportMap, Map<ID, CPK_Report__c>  updatedCPKReportMap ){
       system.debug('isExecuted @ after insert1'+isExecuted);
       if(!isExecuted){
            shareCPKReports(updatedCPKReportMap);
            isExecuted = true;
       }
       system.debug('isExecuted @ after insert2'+isExecuted);
    }
    
    /**
     * This method accepts trigger context variables for on before update event and call the actual business logic
     *
     * @param   oldcpkReports           list of old CPK Report records
     * @param   updatedcpkReports       list of updated CPK Report records
     * @param   oldCPKReportMap     map of old CPK Report records
     * @param   updatedCPKReportMap map of updated CPK Report records
     */ 
    public void OnBeforerUpdate(CPK_Report__c[] oldcpkReports, CPK_Report__c[] updatedcpkReports, 
                              Map<ID, CPK_Report__c>  oldCPKReportMap, Map<ID, CPK_Report__c>  updatedCPKReportMap ){
        Set<Id> fabIdSet = new Set<Id>(); 
        if(!isExecuted){
            for(CPK_Report__c cpkReport: updatedcpkReports){
                if(cpkReport.FABS__c != null && cpkReport.FABS__c != oldCPKReportMap.get(cpkReport.Id).FABS__c){
                    fabIdSet.add(cpkReport.FABS__c);
                }
                if(cpkReport.ASIC_Report__c!=null && cpkReport.For_All_ASIC_Customers__c!=null && (cpkReport.ASIC_Report__c == 'Geometry' ||cpkReport.ASIC_Report__c == 'ASIC' )&& cpkReport.For_All_ASIC_Customers__c == 'Yes' && cpkReport.isUpdatedFromReport__c == false ){
                    cpkReport.recordTypeId= rt.id;
                }
            }
            
            if(fabIdSet != null && !fabIdSet.isEmpty()){
                assignQAApprovers(updatedcpkReports,fabIdSet);
            }
        }
    }
    
    /**
     * This method accepts trigger context variables for on after update event and call the actual business logic
     *
     * @param   oldcpkReports           list of old CPK Report records
     * @param   updatedcpkReports       list of updated CPK Report records
     * @param   oldCPKReportMap     map of old CPK Report records
     * @param   updatedCPKReportMap map of updated CPK Report records
     */ 
    public void OnAfterUpdate(CPK_Report__c[] oldcpkReports, CPK_Report__c[] updatedcpkReports, 
                              Map<ID, CPK_Report__c>  oldCPKReportMap, Map<ID, CPK_Report__c>  updatedCPKReportMap ){
        List<CPK_Report__c> updateList = new List<CPK_Report__c>();
        List<CPK_Report__c> cpkList = [Select Id, RecordTypeId, ASIC_Report__c, For_All_ASIC_Customers__c, isUpdatedFromReport__c from CPK_Report__c where Id IN: updatedCPKReportMap.keySet()];
        if(!isExecuted){
            Map<Id, CPK_Report__c> cpkReportMap = new Map<Id, CPK_Report__c>();
            for(CPK_Report__c cpkReport: updatedcpkReports){
                if((cpkReport.FABS__c != null && cpkReport.FABS__c != oldCPKReportMap.get(cpkReport.Id).FABS__c) || (cpkReport.PI_Owner_1__c !=
                    oldCPKReportMap.get(cpkReport.Id).PI_Owner_1__c || cpkReport.PI_Owner_2__c != oldCPKReportMap.get(cpkReport.Id).PI_Owner_2__c ||
                    cpkReport.PI_Owner_3__c != oldCPKReportMap.get(cpkReport.Id).PI_Owner_3__c)){
                    cpkReportMap.put(cpkReport.Id, cpkReport);
                }
                
            }
            
            
            if(cpkReportMap != null && !cpkReportMap.isEmpty()){
                shareCPKReports(cpkReportMap);
            }
            
                //DBiswal 02252015
                List<Monthly_CPK_Report__c> mcpkList = new List<Monthly_CPK_Report__c>();
                String recordName;
                for(CPK_Report__c cpk : updatedCPKReportMap.values()){
                    if((cpk.Stage__c == 'Approved' && oldCPKReportMap.get(cpk.Id).Stage__c != 'Approved')  
                         
                        && cpk.Active__c == True){
                        if(cpk.Reminder__c != null){
                            if(cpk.Report_Cycle__c == 'Monthly'){
                                recordName='M';
                            } else if(cpk.Report_Cycle__c == 'Bi-Monthly'){
                                recordName='BM';
                            } else if(cpk.Report_Cycle__c == 'Quarterly'){
                                recordName='Q';
                            } else if(cpk.Report_Cycle__c == 'Half yearly'){
                                recordName='HF';
                            }
                            //Get the default values for Monthly_CPK_Report__c record
                            mcpkList.add(ClsUpdateCPKReportOnReportUpload.createNewReport(cpk,recordName)); 
                        }
                    }
                }
       
                //Insert Monthly_CPK_Report__c values
                if(mcpkList != null && mcpkList.size() > 0){
                    try{
                        Database.insert(mcpkList,false);
                    } catch(Exception ex){
                        System.debug(ex.getMessage());
                    }         
                }
            
            isExecuted = true;
        }
        
    }
    
    /**
     * This method accepts trigger context variables for on after delete event and call the actual business logic
     *
     * @param   updatedcpkReports       list of updated CPK Report records
     */ 
    public void OnAfterDelete(CPK_Report__c[] oldCPKReports){
         Map<String,String> mapId = new Map<String,String>();
        for(CPK_Report__c cpkreport : oldCPKReports){
            String OtId=cpkreport.OpenTextId__c+';'+cpkreport.OpenTextIdPublish__c;
            mapId.put(cpkreport.Id,OtId);
            
        }
        ClsUpdateCPKReportOnReportUpload.CreateDeleteObject(mapId);
    }
    
    
    private void assignQAApprovers(List<CPK_Report__c> cpkReportList, Set<Id> fabIdSet){
        Map<Id, List<Fab_User__c>> fabUserListMap = new Map<Id, List<Fab_User__c>>();
        if(fabIdSet != null && !fabIdSet.isEmpty()){
            fabUserListMap = getFabUsers(fabIdSet);
        }
        if(fabUserListMap != null && !fabUserListMap.isEmpty()){
            for(CPK_Report__c cpkReport:cpkReportList){
                if(cpkReport.FABS__c != null && fabUserListMap.containsKey(cpkReport.FABS__c)){
                    List<Fab_User__c> fabUserList = fabUserListMap.get(cpkReport.FABS__c);
    
                    if(fabUserList != null && !fabUserList.isEmpty()){
                        Integer cnt = 1;
                        for(Fab_User__c fabUser: fabUserList){
                            if(cnt == 3){
                                break;
                            }
                            if(cnt == 1){
                                cpkReport.QA_Approver__c = fabUser.User__c;
                            }
                            if(cnt == 2){
                                cpkReport.QA_Approver_backUp__c = fabUser.User__c;
                            }
                            cnt++;
                        }
                    }
                }   
            }
        }
    }
    
    
    private Map<Id, List<Fab_User__c>> getFabUsers(Set<Id> fabIdSet){
        Map<Id, List<Fab_User__c>> fabUserListMap = new Map<Id, List<Fab_User__c>>();
        
        if(fabIdSet != null && !fabIdSet.isEmpty()){
            List<Fab_User__c> fabUserList = [SELECT Id, User__c, Name, IsActive__c, IsQualityReports__c, FAB__c
                                             FROM   Fab_User__c 
                                             WHERE  FAB__c IN : fabIdSet AND IsActive__c = True AND IsQualityReports__c = True];
                                             
            if(fabUserList != null && !fabUserList.isEmpty()){
                for(Fab_User__c fabUser:fabUserList){
                    if(!fabUserListMap.containsKey(fabUser.FAB__c)){
                        fabUserListMap.put(fabUser.FAB__c, new List<Fab_User__c>());
                    }
                    if(fabUser.User__c != null){
                        fabUserListMap.get(fabUser.FAB__c).add(fabUser);
                    }
                }
            }
        }
        return fabUserListMap;
    }
    
    private void shareCPKReports(Map<Id, CPK_Report__c> cpkReportMap){
        if(cpkReportMap != null && !cpkReportMap.isEmpty()){
            Set<CPK_Report__Share> cpkReportShareSet = new Set<CPK_Report__Share>(); 
            try{
                List<CPK_Report__Share> cpkReportShareList = [SELECT Id FROM CPK_Report__Share where ParentId =: cpkReportMap.keyset() AND AccessLevel = : SHARING_ACCESSLEVEL
                                                                AND Rowcause = : Schema.CPK_Report__Share.RowCause.CPK_Report_FAB_and_PI_User_Sharing__c];
                if(cpkReportShareList != null && !cpkReportShareList.isEmpty()){
                    Database.delete(cpkReportShareList, false);
                }
                for(CPK_Report__c cpkReport : cpkReportMap.Values()){
                    if(cpkReport.PI_Owner_1__c != null){
                        cpkReportShareSet.add(prepareCPKReportShare(cpkReport.Id, cpkReport.PI_Owner_1__c, SHARING_ACCESSLEVEL, Schema.CPK_Report__Share.RowCause.CPK_Report_FAB_and_PI_User_Sharing__c));
                    }
                    if(cpkReport.PI_Owner_2__c != null ){
                        cpkReportShareSet.add(prepareCPKReportShare(cpkReport.Id, cpkReport.PI_Owner_2__c, SHARING_ACCESSLEVEL, Schema.CPK_Report__Share.RowCause.CPK_Report_FAB_and_PI_User_Sharing__c));
                    }
                    if(cpkReport.PI_Owner_3__c != null){
                        cpkReportShareSet.add(prepareCPKReportShare(cpkReport.Id, cpkReport.PI_Owner_3__c, SHARING_ACCESSLEVEL, Schema.CPK_Report__Share.RowCause.CPK_Report_FAB_and_PI_User_Sharing__c));
                    }
                    if(cpkReport.QA_Approver__c != null){
                        cpkReportShareSet.add(prepareCPKReportShare(cpkReport.Id, cpkReport.QA_Approver__c, SHARING_ACCESSLEVEL, Schema.CPK_Report__Share.RowCause.CPK_Report_FAB_and_PI_User_Sharing__c));
                    }
                    if(cpkReport.QA_Approver_backUp__c != null){
                        cpkReportShareSet.add(prepareCPKReportShare(cpkReport.Id, cpkReport.QA_Approver_backUp__c, SHARING_ACCESSLEVEL, Schema.CPK_Report__Share.RowCause.CPK_Report_FAB_and_PI_User_Sharing__c));
                    }
                }
                if(cpkReportShareSet != null && !cpkReportShareSet.isEmpty()){
                    Database.insert(new List<CPK_Report__Share>(cpkReportShareSet), false);
                }
            }catch(Exception e){
                
            }
        }
    }
    
    private CPK_Report__share prepareCPKReportShare(Id parentId, Id userorGroupId, String accessLevel, String rowcause){
        return new CPK_Report__Share(ParentId = parentId, UserOrGroupId = userOrGroupId, AccessLevel = accessLevel, Rowcause = rowcause);
    }
}