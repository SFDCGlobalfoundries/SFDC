/*
* @ Author :- Navneet Rajput
* @ Description :- 
* @ Date :-
* @ Change History :-  Navneet Rajput,8/9/2016
* @ Change History :-  SUHAS,22/02/2017 - Refactoring and Exception handling 
**/

public with sharing class WaivercollaboratorTriggerHandler { 

    public WaivercollaboratorTriggerHandler(){
         
    }
    
    public static void shareDFMReport(List<Wavier_Collaborator__c> dfmReport,Boolean isApproved){
        
        // No one time data load is requred and at run time only one DFM record will be push from PTSR system
        // In case historical data need to push then we need to keep batch size is 1 
        //List<Messaging.SingleEmailMessage> lstOfEmails = new List<Messaging.SingleEmailMessage>();
        
        // get list of FAE users assigned to waiver collaborator account 
        List<String> uRoles = new List<String>{'Field Application Engineer','Primary Field Application Engineer'};
        Set<Id> FAEs = DfmUtilityCls.getATPUsersByRole(dfmReport[0].Account_Short_Name__c,uRoles);
        Set<Id> custIds = DfmUtilityCls.getCustomers(dfmReport[0].Created_By_Shortname__c,dfmReport[0].Submitted_By_Shortname__c);
        Set<Id> dfmUserIds = DfmUtilityCls.getUsersFromPublicGroup('DFM_Users')<>NULL ?DfmUtilityCls.getUsersFromPublicGroup('DFM_Users').keySet():NULL;
        Set<Id> dfmManagerIds = DfmUtilityCls.getUsersFromPublicGroup('DFM_Waiver_Team')<>NULL ?DfmUtilityCls.getUsersFromPublicGroup('DFM_Waiver_Team').keySet():NULL;
         Wavier_Collaborator__c collaborator =  dfmReport[0];
       
       
        try {
            //DFM Services Report - S2 template - In case Collaborator report is approved by DFM Manager
            if (isApproved){
                if(! Test.isRunningTest()){
                DFMEmailImplementation.DFMServicesApprovalConfirmation(dfmReport[0]);
                }
                
            } else {
                
                //THIS Condition is for Short flow.  
                //only 'Chip' & 'Review Only' reports run through approval process for Long flow. Rest all conditions will be part of shor flow
                //DFM Services Report - S3 template - In case Collaborator report is Rejected by DFM Manager, 
                //As per DFM enhancements, Mail template is implemented. 
                //Need to assign the report back to DFM User.
                
                // MOhan : Is_Submit_4_DFM_Apprval__c changed
                if(dfmReport[0] <> null && dfmReport[0].Is_Submit_4_DFM_Apprval__c &&   dfmReport[0].Waiver_Status__c != 'Approved'){
                if(! Test.isRunningTest()){
                DFMEmailImplementation.DFMServicesRejectionConfirmation(dfmReport[0]);
                }
               
                }
            }
            
        } catch (Exception e){
            GlobalUtility.logMessage('Debug', 'WaivercollaboratorTriggerHandler', 'shareDFMReport()', String.valueOf(collaborator.id), 'waiver Trigger Handler', 'this is error message', 'payLoad','Other SFDC',e, 2300);
            system.debug('Exception e ####### '+e.getMessage());
        }
        
    }   
    
    // Adding the DRC Functaionality
    public static void shareDRCReport(List<Wavier_Collaborator__c> waiverReport){
        
         Wavier_Collaborator__c collaborator =  waiverReport[0];
        List<String> uRoles = new List<String>{'Field Application Engineer','Primary Field Application Engineer'};
        Set<Id> FAEs = DfmUtilityCls.getATPUsersByRole(collaborator.Account_Short_Name__c,uRoles);     
        // Sharing the record with FAEs when everything is ready in Salesforce
        if(FAEs<>NULL && !FAEs.isEmpty()) {
            DfmUtilityCls.shareRecord(collaborator.Id,FAEs,'Edit');
        }
        
        Set<Id> DRBGroupIds = DfmUtilityCls.getUsersForDRBGp(collaborator.DRB_Group_uIds__c); 
        // Sharing the record with DRB Group Users when everything is ready in Salesforce
        if(DRBGroupIds<>NULL && !DRBGroupIds.isEmpty()) {
            DfmUtilityCls.shareRecord(collaborator.Id,DRBGroupIds ,'Read');
        } 
        List<Waiver_Rule_List__c>  ruleListCount=[select id, Rule_Type__c from Waiver_Rule_List__c  where Waiver_Collaborator__c =: collaborator.Id AND Rule_Type__c !='' limit 1];
        if(collaborator.PTSR_Service_Type__c.toUpperCase().contains('DFM') && ruleListCount.size() !=0){
        system.debug('FAE Mail for auto close');
            // This is executed when DFM Manager rejects report and its LONG FLOW scenario
           if(! Test.isRunningTest()){DFMEmailImplementation.DFMReviewSummaryNotificationL3L4(collaborator);        }
        }
    }
    
    // Send closure notification to Mantis
    public static void sendClosureNotificationToMantis(Wavier_Collaborator__c drcInfo) {
        
        String drcClosureRequest = null;
        List<Waiver_Rule_List__c> lst_WaiverRules = new list<Waiver_Rule_List__c>();
        List<Waiver_Rule_List__c> lst_RuleInfo = [SELECT Id,Prime_Die_Name__c,Design_Rule_Name__c,Stage__c,Mantis_Stage__c,Mantis_Id__c,Final_Stage__c,GF_Internal_Closing_Comment__c,RuleId__c,
                                                         IsCustomerAcceptsRisk__c,IsCustomerAgreeToFix__c,IsGfAcceptsRisk__c,Customer_Closing_Comment__c 
                                                  FROM  Waiver_Rule_List__c
                                                  WHERE Waiver_Collaborator__c = : drcInfo.Id];
       
         Map<string,string> mantisIdStatusMap=new Map<string,string>();
           
          list<Chip__c> objChip = [SELECT Id,Chip_Name__c, Prime_Die_Status__c,MantisId1__c,MantisId2__c,MantisId3__c,AllJobs_Submitted__c,Wavier_Collaborator__c FROM Chip__c WHERE Wavier_Collaborator__c =: drcInfo.Id];
          
        system.debug('objChip'+objChip);
          for(Chip__c cg:objChip ){
           system.debug('objChip123'+cg+'seetice type'+drcInfo.DRCServiceoption__c);
              if(drcInfo.DRCServiceoption__c <>Null && drcInfo.DRCServiceoption__c.toLowerCase()=='DRC Run Only'){
                  if(cg.MantisId1__c!=null)mantisIdStatusMap.put(cg.MantisId1__c,'PJNG');
                  if(cg.MantisId2__c!=null)mantisIdStatusMap.put(cg.MantisId2__c,'PJNG');
                  if(cg.MantisId3__c!=null)mantisIdStatusMap.put(cg.MantisId3__c,'PJNG');
              
              } else {
              
              if(cg.MantisId1__c!=null && cg.Prime_Die_Status__c !=null)mantisIdStatusMap.put(cg.MantisId1__c,cg.Prime_Die_Status__c);
              if(cg.MantisId2__c!=null && cg.Prime_Die_Status__c !=null)mantisIdStatusMap.put(cg.MantisId2__c,cg.Prime_Die_Status__c);
              if(cg.MantisId3__c!=null && cg.Prime_Die_Status__c!=null)mantisIdStatusMap.put(cg.MantisId3__c,cg.Prime_Die_Status__c);
              }
          }
          system.debug('mantisIdStatusMap>>>>>>'+mantisIdStatusMap);
          String strMantisIds = drcInfo.MantisIds__c;
                set<String> mantisIds = new  set<String>();
                if(strMantisIds !=null && string.isNotBlank(strMantisIds)){
          for (String strSplit : strMantisIds.split(';')){
                          if(strSplit!='')mantisIds.add(strSplit.trim()); 
                      }
               
            for(String mantisId : mantisIds){
              JSONGenerator jGen = JSON.createGenerator(true);
              system.debug('dwcObj'+drcInfo);
              if (drcInfo<>NULL && mantisId<>null) {
                  
                   system.debug('mantisIds'+mantisId);
                   
                       
                   jGen.writeStartObject();
                   jGen.writeFieldName('job_level');
                   jGen.writeStartObject();
                   
                   jGen.writeStringField('mantis_id', mantisId);
                   
                   if(drcInfo.PTSR_Number__c<>null){
                       jGen.writeStringField('ptsr', drcInfo.PTSR_Number__c);
                   }
                   if(mantisIdStatusMap<>null){
                       jGen.writeStringField('agg_status', mantisIdStatusMap.get(mantisId));//drcInfo.Waiver_Status__c);
                   }
                   if(drcInfo.PTSR_Status__c<>null){
                       jGen.writeStringField('coll_status', drcInfo.PTSR_Status__c);
                   }
                   jGen.writeStringField('coll_comment', String.isEmpty(drcInfo.Cancellation_Reason__c)?'No Comments':drcInfo.Cancellation_Reason__c);
                   
                   
                   jGen.writeEndObject();          
                    
                   jGen.writeFieldName('chk_level');
                   jGen.writeStartArray();
                   system.debug('lst_WaiverRules'+lst_RuleInfo);
                   
                   if (lst_RuleInfo<>NULL && !lst_RuleInfo.isEmpty()) {
                    system.debug('Rule list'+lst_RuleInfo);
                             
                             for (Waiver_Rule_List__c wRule : lst_RuleInfo) {
                                system.debug('mantisId' + mantisId + 'Rule mantis id' + wRule.Mantis_Id__c );
                                
                                if(wRule.Mantis_Id__c !=null && wRule.RuleId__c<>null && mantisId.containsIgnoreCase(String.valueOf(wRule.Mantis_Id__c))){
                                    system.debug('inside check level');
                                 jGen.writeStartObject();
                                 if(wRule.RuleId__c<>null){
                                     jGen.writeNumberField('check_id', wRule.RuleId__c);
                                 
                                 jGen.writeStringField('fe_comment',String.isEmpty(wRule.GF_Internal_Closing_Comment__c)?'No Comments':wRule.GF_Internal_Closing_Comment__c);
                                 jGen.writeStringField('final_comments',String.isEmpty(wRule.Customer_Closing_Comment__c)?'No Comments':wRule.Customer_Closing_Comment__c);
                                   system.debug('Serviceoption'+drcInfo.DRCServiceoption__c+'final stagae'+wRule.Final_Stage__c);
                                     if(drcInfo.DRCServiceoption__c <>Null && drcInfo.DRCServiceoption__c.toLowerCase()=='DRC Run Only'){
                                     jGen.writeStringField('collaborator_status', 'PJNG'); 
                                     }else {
                                     if(wRule.Final_Stage__c <> null){
                                         jGen.writeStringField('collaborator_status', wRule.Final_Stage__c);   
                                     }
                                     }
                                 }      
                                 jGen.writeEndObject(); 
                                }
                             }
                             
                         }   
                   jGen.writeEndArray();
                   jGen.writeEndObject();
                           
              }
              drcClosureRequest=jGen.getAsString();
              system.debug('drcClosureRequest'+drcClosureRequest);
              
              if (lst_RuleInfo<>NULL && !lst_RuleInfo.isEmpty()){
                system.debug('lst_RuleInfo'+lst_RuleInfo);
             for(Waiver_Rule_List__c rule: lst_RuleInfo){
                if(rule.Stage__c=='PI'&& rule.Mantis_Stage__c <> NULL && rule.Mantis_Stage__c != ''){
                    rule.Final_Stage__c=rule.Mantis_Stage__c;
                }
            }
        
            if (drcClosureRequest<>NULL){
              
                WaivercollaboratorTriggerHandler.notifyToMantis(drcClosureRequest,'CLOSURE');
            }
           }
         }
        } 
        
       }
       
        
       
      /*  if (lst_RuleInfo<>NULL && !lst_RuleInfo.isEmpty()){
            
            for(Waiver_Rule_List__c rule: lst_RuleInfo){
                if(rule.Stage__c=='PI'&& rule.Mantis_Stage__c <> NULL && rule.Mantis_Stage__c != ''){
                    rule.Final_Stage__c=rule.Mantis_Stage__c;
                }
            }
        
            drcClosureRequest = DRC_JsonGenerator.getJsonRequest(lst_RuleInfo,drcInfo);
            
            if (drcClosureRequest<>NULL){
                WaivercollaboratorTriggerHandler.notifyToMantis(drcClosureRequest,'CLOSURE');
            }
          
        }         */                                
        
    
    
    
     // Send closure notification to Mantis
    public static void sendRevertNotificationToMantis(Wavier_Collaborator__c drcInfo) {
        
        String drcClosureRequest = null;
        set<string> revertMantisIds=new  set<string>();
        List<Waiver_Rule_List__c> lst_Reverted_Rules = new List<Waiver_Rule_List__c>();
        List<Waiver_Rule_List__c> lst_RuleInfo = [SELECT Id,Design_Rule_Name__c,Mantis_Id__c,Mantis_Stage__c,Revert_Rule__c,Stage__c ,Final_Stage__c,GF_Internal_Closing_Comment__c,RuleId__c,
                                                         IsCustomerAcceptsRisk__c,IsCustomerAgreeToFix__c,IsGfAcceptsRisk__c,Customer_Closing_Comment__c 
                                                  FROM  Waiver_Rule_List__c
                                                  WHERE Waiver_Collaborator__c = : drcInfo.Id];
        
        
        
         if (lst_RuleInfo<>NULL && !lst_RuleInfo.isEmpty()){
            
            for(Waiver_Rule_List__c rule: lst_RuleInfo){
                if(rule.Stage__c=='PI'&& rule.Mantis_Stage__c <> NULL && rule.Mantis_Stage__c != ''){
                    rule.Final_Stage__c=rule.Mantis_Stage__c;
                }
                if(rule.Revert_Rule__c == true){
                    //rule.Final_Stage__c='cRR';
                    lst_Reverted_Rules.add(rule);
                   
                   revertMantisIds.add(string.valueof(rule.Mantis_Id__c));
                   
                }
            }
            
            
            system.debug('revertMantisIds'+revertMantisIds);
            system.debug('lst_Reverted_Rules>>>>>>'+lst_Reverted_Rules.size());
            //drcClosureRequest = DRC_JsonGenerator.getJsonRequestForRevert(lst_Reverted_Rules,drcInfo);
            
            JSONGenerator jGen = JSON.createGenerator(true);
            
           
           system.debug('dwcObj2222'+drcInfo);
           
           
           if (drcInfo<>NULL) {
                
           /*     String strMantisIds = drcInfo.MantisIds__c;
                List<String> mantisIds = new  List<String>();
                 if(strMantisIds<>null && strMantisIds !=''){
                      for (String strSplit : strMantisIds.split(';')){
                          mantisIds.add(strSplit.trim()); 
                      } 
                     */
                       if(revertMantisIds<>null &&!revertMantisIds.isEmpty()){
                     for (string mantisId: revertMantisIds){
                     
                     //for(String mantisId : mantisIds){
                         
                         jGen.writeStartObject();
                         jGen.writeFieldName('job_level');
                         jGen.writeStartObject();
                         if(drcInfo.MantisId__c<>null){
                             jGen.writeStringField('mantis_id', mantisId);
                         }
                         if(drcInfo.PTSR_Number__c<>null){
                             jGen.writeStringField('ptsr', drcInfo.PTSR_Number__c);
                         }
                         jGen.writeStringField('agg_status','cRR');
                         
                         jGen.writeStringField('coll_status', 'REVERT');
                         
                         jGen.writeStringField('coll_comment', String.isEmpty(drcInfo.Cancellation_Reason__c)?'No Comments':drcInfo.Cancellation_Reason__c);
                         
                         
                         jGen.writeEndObject();          
                         
                         jGen.writeFieldName('chk_level');
                         jGen.writeStartArray();
                         
                         if (lst_Reverted_Rules<>NULL && !lst_Reverted_Rules.isEmpty()) {
                            // system.debug('mantisId' + mantisId + 'Rule mantis id' + wRule.Mantis_Id__c );
                             for (Waiver_Rule_List__c wRule : lst_Reverted_Rules) {
                                system.debug('mantisId' + mantisId + 'Rule mantis id' + wRule.Mantis_Id__c );
                                 if(String.valueOf(wRule.Mantis_Id__c) == mantisId){
                                 jGen.writeStartObject();
                                 if(wRule.RuleId__c<>null){
                                     jGen.writeNumberField('check_id', wRule.RuleId__c);
                                 }
                                 jGen.writeStringField('fe_comment',String.isEmpty(wRule.GF_Internal_Closing_Comment__c)?'No Comments':wRule.GF_Internal_Closing_Comment__c);
                                 jGen.writeStringField('final_comments',String.isEmpty(wRule.Customer_Closing_Comment__c)?'No Comments':wRule.Customer_Closing_Comment__c);
                                 jGen.writeStringField('collaborator_status','cRR');       
                                 jGen.writeEndObject(); 
                                }
                             }
                             
                         }   
                         jGen.writeEndArray();
                         jGen.writeEndObject();
                         
                     }
                 }
               }
           if(jGen<>NULL){
               System.debug('jGen.getAsString()>>>>>>>>>'+jGen.getAsString());
               
           } 
           
           drcClosureRequest=jGen.getAsString();
           //drcClosureRequest = DRC_JsonGenerator.getJsonRequestForRevert(lst_Reverted_Rules,drcInfo);
           
            //return jGen<>NULL?jGen.getAsString():null;
            system.debug('drcClosureRequest>>>>>>'+drcClosureRequest);
            system.debug('lst_Reverted_Rules>>>>>>'+lst_Reverted_Rules);
            if (drcClosureRequest<>NULL && lst_Reverted_Rules<>NULL && !lst_Reverted_Rules.isEmpty()){
                WaivercollaboratorTriggerHandler.notifyToMantis(drcClosureRequest,'REVERT');
            }
           
        }                                         
       }
    
    // Send Cancel notification to Mantis
    public static void sendCancelNotificationToMantis(Wavier_Collaborator__c drcInfo) {
        
        String drcClosureRequest = null;
        
        
       
        //drcClosureRequest = DRC_JsonGenerator.getJsonRequest(null,drcInfo);
           
      //  WaivercollaboratorTriggerHandler.notifyToMantis(drcClosureRequest,'CANCEL');
            JSONGenerator jGen = JSON.createGenerator(true);    
            
                     
                      
                     jGen.writeStartObject();
                     jGen.writeFieldName('chk_level');
                     jGen.writeStartArray();
                     jGen.writeEndArray();
                     jGen.writeFieldName('job_level');
                     jGen.writeStartObject();
                     //if(mantisId<>null){
                         jGen.writeStringField('mantis_id', '');
                    // }
                     if(drcInfo.PTSR_Number__c<>null){
                         jGen.writeStringField('ptsr', drcInfo.PTSR_Number__c);
                     }
                     if(drcInfo.Waiver_Status__c<>null){
                         jGen.writeStringField('agg_status', drcInfo.Waiver_Status__c);
                     }
                     if(drcInfo.PTSR_Status__c<>null){
                         jGen.writeStringField('coll_status', drcInfo.PTSR_Status__c);
                     }
                     jGen.writeStringField('coll_comment', String.isEmpty(drcInfo.Cancellation_Reason__c)?'No Comments':drcInfo.Cancellation_Reason__c);
                     
                     
                     jGen.writeEndObject();          
                     
                     jGen.writeEndObject();
                             
                
                drcClosureRequest=jGen.getAsString();
                system.debug('drcCancelRequest'+drcClosureRequest);
                
                if (drcClosureRequest<>NULL){
                    
                    WaivercollaboratorTriggerHandler.notifyToMantis(drcClosureRequest,'CANCEL');
                    //WaivercollaboratorTriggerHandler.sendCancelNotificationToPTSR(drcInfo,drcInfo.PTSR_Status__c);
                }   
            }
        
    
     
    // Send workflow Freeze notification to Mantis
    public static void sendWfFreezeNotificationToMantis(Wavier_Collaborator__c drcInfo) {
        
        String drcFreezeRequest = null;
      
       // drcFreezeRequest = DRC_JsonGenerator.getJsonRequest(null,drcInfo);
            String strMantisIds = drcInfo.MantisIds__c;
                set<String> mantisIds = new  set<String>();
            for (String strSplit : strMantisIds.split(';')){
                    system.debug('strSplit'+strSplit);
                          if(strSplit!='')mantisIds.add(strSplit.trim()); 
                      }
        
            for(String mantisId : mantisIds){
                JSONGenerator jGen = JSON.createGenerator(true);
                system.debug('dwcObj'+drcInfo);
                if (drcInfo<>NULL) {
                    
                     system.debug('mantisIds'+mantisIds);
                     
                         
                     jGen.writeStartObject();
                     jGen.writeFieldName('job_level');
                     jGen.writeStartObject();
                     if(mantisId<>null){
                         jGen.writeStringField('mantis_id',mantisId);
                     }
                     if(drcInfo.PTSR_Number__c<>null){
                         jGen.writeStringField('ptsr', drcInfo.PTSR_Number__c);
                     }
                     if(drcInfo.Waiver_Status__c<>null){
                         jGen.writeStringField('agg_status', drcInfo.Waiver_Status__c);
                     }
                     if(drcInfo.PTSR_Status__c<>null){
                         jGen.writeStringField('coll_status', drcInfo.PTSR_Status__c);
                     }
                     jGen.writeStringField('coll_comment', String.isEmpty(drcInfo.Cancellation_Reason__c)?'No Comments':drcInfo.Cancellation_Reason__c);
                     
                     
                     jGen.writeEndObject();          
                     
                     jGen.writeFieldName('chk_level');
                     jGen.writeStartArray();
                     jGen.writeEndArray();
                     jGen.writeEndObject();
                             
                }
                drcFreezeRequest=jGen.getAsString();
                system.debug('drcFreezeRequest'+drcFreezeRequest);
                if (drcFreezeRequest<>NULL){
                   system.debug('drcFreezeRequest>>>>>>>>>'+drcFreezeRequest);
                    WaivercollaboratorTriggerHandler.notifyToMantis(drcFreezeRequest,'FREEZE');
                }
            }
    }
    
    // Send closure notification to PTSR
    public static void sendClosureNotificationToPTSR(Wavier_Collaborator__c drcInfo) {
        WaivercollaboratorTriggerHandler.notifyToPTSR(drcInfo.DFM_Transaction_Id__c,drcInfo.PTSR_Number__c,'Close',
                              String.valueOf(system.now()),Userinfo.getName(),'','');
    }
    
     // Send cancel notification to PTSR
    public static void sendCancelNotificationToPTSR(Wavier_Collaborator__c drcInfo,String stage) {
       system.debug('cancelnotification to PTSR');
        WaivercollaboratorTriggerHandler.notifyToPTSR(drcInfo.DFM_Transaction_Id__c,drcInfo.PTSR_Number__c,'Cancel',
                                String.valueOf(system.now()),Userinfo.getName(),stage,drcInfo.Cancellation_Reason__c);
    }
    
   
  
    
    @future (callout=true)
public static void notifyToMantis(String requstElement,String operationType) {
        try{
                if (operationType=='CLOSURE'){
                    
                    DRC_UpdateStatusToMantisStub.SyncMantisStatusService_pt syncMantisElement = new DRC_UpdateStatusToMantisStub.SyncMantisStatusService_pt();
                    if(!Test.isRunningTest()){
                      syncMantisElement.SendPTSRClosureInfo(requstElement);
                    }
                }
                else if (operationType=='FREEZE'){
                    system.debug('freeze ');
                    DRC_UpdateStatusToMantisStub.SyncMantisStatusService_pt syncMantisElement1 = new DRC_UpdateStatusToMantisStub.SyncMantisStatusService_pt();
                     
                     if(!Test.isRunningTest()){
                      syncMantisElement1.SendPTSRFreezeInfo(requstElement);
                     }
                }
                else if (operationType=='CANCEL'){
                    
                    DRC_UpdateStatusToMantisStub.SyncMantisStatusService_pt syncMantisElement2 = new DRC_UpdateStatusToMantisStub.SyncMantisStatusService_pt();
                     system.debug('cancel Notify to Mantis');
                     if(!Test.isRunningTest()){
                      syncMantisElement2.SendPTSRCancelInfo(requstElement);
                     }
                }
                else if (operationType=='REVERT'){
                
                DRC_UpdateStatusToMantisStub.SyncMantisStatusService_pt syncMantisElement1 = new DRC_UpdateStatusToMantisStub.SyncMantisStatusService_pt();
                
                if(!Test.isRunningTest()){
                    syncMantisElement1.SendPTSRClosureInfo(requstElement);
                    }
                }
          }catch (Exception e){GlobalUtility.logMessage('Debug', 'WCollabTrigHandler', 'sendClosureNotificationToMantis()', '__ for Optype -'+operationType, 'waiverTrigHandl', 'this is errmsg', 'payLoad','Other SFDC',e, 2300);
            }
}
    
    @future (callout=true)
    public static void notifyToPTSR (String transId,String ptsrNo,String status,String closeDate,String cancelledBy,String stage,String reason) {
        
        DRC_SyncPTSRStatusStub.SyncPTSRStatusService_pt syncPtsrElement = new DRC_SyncPTSRStatusStub.SyncPTSRStatusService_pt();
         if(!Test.isRunningTest()){
           if (status=='Close'){syncPtsrElement.SendPTSRClosureInfo(transId,ptsrNo,status,closeDate);
           } else if (status=='Cancel'){
            system.debug('Cancel notify to PTSR');
            syncPtsrElement.SendPTSRCancelInfo(transId,ptsrNo,'Cancel',reason,cancelledBy,closeDate,stage);
           }
         }
    }
    
    // to share the record with Submitted by ShortName and Created By ShortName when are rule are PI and PW and Closed.
    public static void shareDRCReportWithCustomers(Wavier_Collaborator__c drcWaiverRecord) {
      
      Set<Id> custIds = DfmUtilityCls.getCustomers(drcWaiverRecord.Created_By_Shortname__c,drcWaiverRecord.Submitted_By_Shortname__c);
      if(custIds<>NULL && !custIds.isEmpty()) {
        DfmUtilityCls.shareRecord(drcWaiverRecord.Id,custIds,'Edit');
      }
    }
}