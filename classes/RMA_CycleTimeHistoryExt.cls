/**
 * Author: Surendranadh Nune
 * Company: GlobalFoundries,India
 * Project: Return Material Authorization
 * Description: This class is used to display the cycle time history records of RMA using field sets. 
 * History:
 *    SurendranadhNune 09122015  -   Created.
**/

public with sharing class RMA_CycleTimeHistoryExt {
    private RMA__c rmaObj;
    public boolean isFab9or10{get;set;}
    public RMA_CycleTimeHistoryExt(ApexPages.StandardController con){
    	isFab9or10 = false;
        rmaObj = (RMA__c)con.getRecord();
        isFab9or10 = RMA_Utility.checkFab9or10(rmaObj.Fab__c);
        getCycleTimeLogs();
    }
    
    //This method is used to retreive the cycle time logs using field sets.
    public List<RMA_Audit_log__c> getCycleTimeLogs(){
        String query = 'SELECT ID';
        Map<String, Schema.FieldSet> rmaFieldSetMap = Schema.SObjectType.RMA_Audit_log__c.fieldSets.getMap();
        List<String> cycleTimeFieldSets = new List<String>{'RMA_CSR_Submission_Cycle_time', 'RMA_CQ_Validation_Cycle_Time', 'RMA_Fab_Validation_Cycle_time', 'RMA_Finance_Approval_Cycle_Time',
                                                            'RMA_Regional_Approval_Cycle_Time', 'RMA_Wafer_Acknowledgement_Cycle_Time'}; 
        for(String fieldSet : cycleTimeFieldSets){
            for(Schema.FieldSetMember f : rmaFieldSetMap.get(fieldSet).getFields()){
                query = query+', '+ f.getFieldPath();  
            }
        } 
        query += ' FROM RMA_Audit_log__c WHERE RMA__C =\'' +rmaObj.id + '\' and recordtypeId=\''+ RMA_Utility.getRecordTypeId('RMA_Audit_log__c', RMA_Constants.CYCLE_TIME_LOG) + '\'';
        query += 'ORDER BY CREATEDDATE DESC';
        return Database.query(query);                                                    
    }
}