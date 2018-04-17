/*
    Author : Abhita Bansal
    Description : This trigger is used to provide the Access to Fab Execution Users on record Creation on the basis of recordType
    Code Creation: 27/11/2014
*/
trigger eWSR_Form_ShareForApproval on eWSR_Form__c (after insert) {
    
    public static Group getQueue(String QName){
        Group gp = [Select Type, Id From Group where Type =:eWSRConstantsVariablesClass.QUEUE And Name =:QName Limit 1];
        return gp;
    }
    
    
    if(trigger.isInsert){
        List<eWSR_Form__Share> formShares = new List<eWSR_Form__Share>();
        //Set<Id> formIds = new Set<Id>();
        //Map<String, String> mapUserToManager = new Map<String, String>();
        //List<eWSR_Form__c> formList = new List<eWSR_Form__c>();
              
        String s_Fab2RecordtypeID = Schema.getGlobalDescribe().get(eWSRConstantsVariablesClass.EWSRFORMSOBJECT).getDescribe().getRecordTypeInfosByName().get(eWSRConstantsVariablesClass.FAB2RECORDTYPE).getRecordTypeId();
        String s_Fab3RecordtypeID = Schema.getGlobalDescribe().get(eWSRConstantsVariablesClass.EWSRFORMSOBJECT).getDescribe().getRecordTypeInfosByName().get(eWSRConstantsVariablesClass.FAB3RECORDTYPE).getRecordTypeId();
        String s_Fab3ERecordtypeID = Schema.getGlobalDescribe().get(eWSRConstantsVariablesClass.EWSRFORMSOBJECT).getDescribe().getRecordTypeInfosByName().get(eWSRConstantsVariablesClass.FAB3ERECORDTYPE).getRecordTypeId();
        String s_Fab5RecordtypeID = Schema.getGlobalDescribe().get(eWSRConstantsVariablesClass.EWSRFORMSOBJECT).getDescribe().getRecordTypeInfosByName().get(eWSRConstantsVariablesClass.FAB5RECORDTYPE).getRecordTypeId();
        String s_Fab5JVRecordtypeID = Schema.getGlobalDescribe().get(eWSRConstantsVariablesClass.EWSRFORMSOBJECT).getDescribe().getRecordTypeInfosByName().get(eWSRConstantsVariablesClass.FAB5JVRECORDTYPE).getRecordTypeId();
        String s_Fab6RecordtypeID = Schema.getGlobalDescribe().get(eWSRConstantsVariablesClass.EWSRFORMSOBJECT).getDescribe().getRecordTypeInfosByName().get(eWSRConstantsVariablesClass.FAB6RECORDTYPE).getRecordTypeId();
        String s_Fab7RecordtypeID = Schema.getGlobalDescribe().get(eWSRConstantsVariablesClass.EWSRFORMSOBJECT).getDescribe().getRecordTypeInfosByName().get(eWSRConstantsVariablesClass.FAB7RECORDTYPE).getRecordTypeId();
        
        if(!IntegrationUserUtil.isSkipTrigger()){
        
        for(eWSR_Form__c form : trigger.new){
            System.debug('RecordId'+form.recordTypeId);
            //formIds.add(form.OwnerId);
            eWSR_Form__Share approvalShare = new eWSR_Form__Share ();
            if(form.recordTypeId == s_Fab2RecordtypeID){
                Group grp = getQueue(eWSRConstantsVariablesClass.FAB2QNAME);
                approvalShare.UserOrGroupId = grp.Id;
            }
            else if(form.recordTypeId == s_Fab3RecordtypeID){
                Group grp = getQueue(eWSRConstantsVariablesClass.FAB3QNAME);
                approvalShare.UserOrGroupId = grp.Id;
            }
            else if(form.recordTypeId == s_Fab3ERecordtypeID){
                Group grp = getQueue(eWSRConstantsVariablesClass.FAB3EQNAME);
                approvalShare.UserOrGroupId = grp.Id;
            }
            else if(form.recordTypeId == s_Fab5RecordtypeID){
                Group grp = getQueue(eWSRConstantsVariablesClass.FAB5QNAME);
                approvalShare.UserOrGroupId = grp.Id;
            }
            else if(form.recordTypeId == s_Fab5JVRecordtypeID){
                Group grp = getQueue(eWSRConstantsVariablesClass.FAB5JVQNAME);
                approvalShare.UserOrGroupId = grp.Id;
            }
            else if(form.recordTypeId == s_Fab6RecordtypeID){
                Group grp = getQueue(eWSRConstantsVariablesClass.FAB6QNAME);
                approvalShare.UserOrGroupId = grp.Id;
            }
            else{
                Group grp = getQueue(eWSRConstantsVariablesClass.FAB7QNAME);
                approvalShare.UserOrGroupId = grp.Id;
            }
            approvalShare.ParentId = form.Id;
            //approvalShare.UserOrGroupId = '00GN0000000vLW8';
            approvalShare.AccessLevel = eWSRConstantsVariablesClass.EDIT;
            approvalShare.RowCause = Schema.eWSR_Form__Share.RowCause.Fab_Execution_Planning_Users__c;
            System.debug('Approver:'+approvalShare);
            formShares.add(approvalShare);        
        }
        
        Database.SaveResult[] formSharesInsertResult = Database.insert(formShares ,false);
       }
    }
}