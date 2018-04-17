/**
* Company       :   Cognizant Technologies PTE Ltd.
* Description   :   This is the trigger handler class for RMA_Trigger.
* History       :   
        Initials        Date          Description
-----------------------------------------------------------------------------------------
        Nikhil Jain    16-Oct-15      Created the Class
        Pradosh Samal  04-Aug-17      Modified for fab ALTIS  
**/

public without sharing class RMA_Trigger_Handler {
    
     //static boolean isFirstRun = false;
     public static boolean firstRun = true; 
     
     //Auto Populating the default wafers for the next level on approval of current level of approval
     public static void copyWaferIds(List<RMA__c> newRMARecordList, String source){
        List<RMA_Return_Invoice__c> updatedInvoiceList = new List<RMA_Return_Invoice__c>();
        List<RMA_Return_Invoice__c> rmaReturnInvoiceList = new List<RMA_Return_Invoice__c>();
        rmaReturnInvoiceList = [SELECT Id, RMA__c, RMA__r.Status__c, RMA__r.Workflow_Stage__c, Wafer_Id_CSR_Submission__c, Wafer_Id_Fab_Validated__c,
                                    Die_Quantity__c,Die_Quantity_Fab_Validated__c,RMA_By__c,Invoice__r.Item_Type__c,Fab_Group__c,
                                    Wafer_Id_Fab_9_10_CSR_Submission__c,Wafer_Id_Fab_9_10_Fab_Validated__c,Module_Quantity__c,
                                    Module_Quantity_Fab_Validated__c
                                FROM  RMA_Return_Invoice__c 
                                WHERE RMA__c IN: newRMARecordList];
        if(!rmaReturnInvoiceList.isEmpty()){
            for(RMA_Return_Invoice__c invoice: rmaReturnInvoiceList){
                if((invoice.RMA__r.Workflow_Stage__c == RMA_Constants.PEN_FAB_VAL || 
                    invoice.RMA__r.Workflow_Stage__c == RMA_Constants.PEN_TNK_VAL || 
                    invoice.RMA__r.Workflow_Stage__c == RMA_Constants.PEN_PRD_ENG ||
                    invoice.RMA__r.Workflow_Stage__c == RMA_Constants.PEN_CQ_VAL ) 
                   && source == 'DraftToFab'){
                    if(invoice.RMA_By__c == 'Wafer'){
                        if(!RMA_Utility.checkFab9or10(invoice.Fab_Group__c)){
                            invoice.Wafer_Id_Fab_Validated__c = invoice.Wafer_Id_CSR_Submission__c;
                            invoice.Wafer_Id_Fab_9_10_Fab_Validated__c = NULL;
                        }else{
                            invoice.Wafer_Id_Fab_9_10_Fab_Validated__c = invoice.Wafer_Id_Fab_9_10_CSR_Submission__c;
                            invoice.Wafer_Id_Fab_Validated__c = NULL;
                        }
                        invoice.Wafer_Id_Fab_In_Validated__c = NULL;
                        invoice.Wafer_Id_Fab_9_10_Fab_Invalidated__c = NULL;
                        invoice.Wafer_Id_Regional_Personnel_Recommended__c = NULL;
                        invoice.Wafer_Id_Fab_9_10_Regional_Validated__c = NULL;
                        invoice.Wafer_Id_Regional_Personnel_Not_Rec__c = NULL;
                        invoice.Wafer_Id_Fab_9_10_Regional_Invalidated__c = NULL;
                    }else if(invoice.RMA_By__c == 'Die'){
                        if(invoice.Invoice__r.Item_Type__c == 'SD'){
                            if(!RMA_Utility.checkFab9or10(invoice.Fab_Group__c)){
                                invoice.Wafer_Id_Fab_Validated__c = invoice.Wafer_Id_CSR_Submission__c;
                                invoice.Wafer_Id_Fab_9_10_Fab_Validated__c = NULL;
                            }else{
                                invoice.Wafer_Id_Fab_9_10_Fab_Validated__c = invoice.Wafer_Id_Fab_9_10_CSR_Submission__c;
                                invoice.Wafer_Id_Fab_Validated__c = NULL;
                            }
                            invoice.Wafer_Id_Fab_In_Validated__c = NULL;
                            invoice.Wafer_Id_Fab_9_10_Fab_Invalidated__c = NULL;
                            invoice.Wafer_Id_Regional_Personnel_Recommended__c = NULL;
                            invoice.Wafer_Id_Fab_9_10_Regional_Validated__c = NULL;
                            invoice.Wafer_Id_Regional_Personnel_Not_Rec__c = NULL;
                            invoice.Wafer_Id_Fab_9_10_Regional_Invalidated__c = NULL;
                        }
                        invoice.Die_Quantity_Fab_Validated__c = invoice.Die_Quantity__c;
                        invoice.Die_Quantity_Regional_Validated__c = NULL;
                    }else if(invoice.RMA_By__c == 'Module'){
                        invoice.Module_Quantity_Fab_Validated__c = invoice.Module_Quantity__c;
                        invoice.Module_Quantity_Regional_Validated__c = NULL;
                    }
                }
                if((invoice.RMA__r.Workflow_Stage__c == RMA_Constants.PEN_REG_DIR
                    || invoice.RMA__r.Workflow_Stage__c == RMA_Constants.PEN_PRD_MGR
                    || invoice.RMA__r.Workflow_Stage__c == RMA_Constants.PEN_CSR_MGR_APPR) 
                    && source == 'TechToReg'){
                    if(invoice.RMA_By__c == 'Wafer'){
                        if(!RMA_Utility.checkFab9or10(invoice.Fab_Group__c)){
                            invoice.Wafer_Id_Regional_Personnel_Recommended__c = invoice.Wafer_Id_Fab_Validated__c;
                            invoice.Wafer_Id_Fab_9_10_Regional_Validated__c = NULL;
                        }else{
                            invoice.Wafer_Id_Fab_9_10_Regional_Validated__c = invoice.Wafer_Id_Fab_9_10_Fab_Validated__c;
                            invoice.Wafer_Id_Regional_Personnel_Recommended__c = NULL;
                        }
                        invoice.Wafer_Id_Fab_9_10_Regional_Invalidated__c = NULL;
                        invoice.Wafer_Id_Regional_Personnel_Not_Rec__c = NULL;
                    }else if(invoice.RMA_By__c == 'Die'){
                        if(invoice.Invoice__r.Item_Type__c == 'SD'){
                            if(!RMA_Utility.checkFab9or10(invoice.Fab_Group__c)){
                                invoice.Wafer_Id_Regional_Personnel_Recommended__c = invoice.Wafer_Id_Fab_Validated__c;
                                invoice.Wafer_Id_Fab_9_10_Regional_Validated__c = NULL;
                            }else{
                                invoice.Wafer_Id_Fab_9_10_Regional_Validated__c = invoice.Wafer_Id_Fab_9_10_Fab_Validated__c;
                                invoice.Wafer_Id_Regional_Personnel_Recommended__c = NULL;
                            }
                            invoice.Wafer_Id_Regional_Personnel_Not_Rec__c = NULL;
                            invoice.Wafer_Id_Fab_9_10_Regional_Invalidated__c = NULL;
                        }
                        invoice.Die_Quantity_Regional_Validated__c = invoice.Die_Quantity_Fab_Validated__c;
                    }else if(invoice.RMA_By__c == 'Module'){
                        invoice.Module_Quantity_Regional_Validated__c = invoice.Module_Quantity_Fab_Validated__c;
                    }
                }
                if((invoice.RMA__r.Workflow_Stage__c == RMA_Constants.PEN_REG_DIR || 
                    invoice.RMA__r.Workflow_Stage__c == RMA_Constants.PEN_PRD_MGR ||
                    invoice.RMA__r.Workflow_Stage__c == RMA_Constants.PEN_LOG_APPR ||
                    invoice.RMA__r.Workflow_Stage__c == RMA_Constants.PEN_CSR_MGR_APPR ||
                    invoice.RMA__r.Workflow_Stage__c == RMA_Constants.PEN_CQ_VAL ) 
                   && source == 'DraftToReg'){
                    if(invoice.RMA_By__c == 'Wafer'){
                        if(!RMA_Utility.checkFab9or10(invoice.Fab_Group__c)){
                            invoice.Wafer_Id_Regional_Personnel_Recommended__c = invoice.Wafer_Id_CSR_Submission__c;
                            invoice.Wafer_Id_Fab_9_10_Regional_Validated__c = NULL;
                        }else{
                            invoice.Wafer_Id_Fab_9_10_Regional_Validated__c = invoice.Wafer_Id_Fab_9_10_CSR_Submission__c;
                            invoice.Wafer_Id_Regional_Personnel_Recommended__c = NULL;
                        }
                        invoice.Wafer_Id_Regional_Personnel_Not_Rec__c = NULL;
                        invoice.Wafer_Id_Fab_9_10_Regional_Invalidated__c = NULL;
                        invoice.Wafer_Id_Fab_Validated__c = NULL;
                        invoice.Wafer_Id_Fab_In_Validated__c = NULL;
                        invoice.Wafer_Id_Fab_9_10_Fab_Validated__c = NULL;
                        invoice.Wafer_Id_Fab_9_10_Fab_Invalidated__c = NULL;
                    }else if(invoice.RMA_By__c == 'Die'){
                        if(invoice.Invoice__r.Item_Type__c == 'SD'){
                            if(!RMA_Utility.checkFab9or10(invoice.Fab_Group__c)){
                                invoice.Wafer_Id_Regional_Personnel_Recommended__c = invoice.Wafer_Id_CSR_Submission__c;
                                invoice.Wafer_Id_Fab_9_10_Regional_Validated__c = NULL;
                            }else{
                                invoice.Wafer_Id_Fab_9_10_Regional_Validated__c = invoice.Wafer_Id_Fab_9_10_CSR_Submission__c;
                                invoice.Wafer_Id_Regional_Personnel_Recommended__c = NULL;
                            }
                            invoice.Wafer_Id_Regional_Personnel_Not_Rec__c = NULL;
                            invoice.Wafer_Id_Fab_9_10_Regional_Invalidated__c = NULL;
                            invoice.Wafer_Id_Fab_Validated__c = NULL;
                            invoice.Wafer_Id_Fab_In_Validated__c = NULL;
                            invoice.Wafer_Id_Fab_9_10_Fab_Validated__c = NULL;
                            invoice.Wafer_Id_Fab_9_10_Fab_Invalidated__c = NULL;
                        }
                        invoice.Die_Quantity_Regional_Validated__c = invoice.Die_Quantity__c;
                        invoice.Die_Quantity_Fab_Validated__c  = NULL;
                    }else if(invoice.RMA_By__c == 'Module'){
                        invoice.Module_Quantity_Regional_Validated__c = invoice.Module_Quantity__c;
                        invoice.Module_Quantity_Fab_Validated__c  = NULL;
                    }
                }
                updatedInvoiceList.add(invoice);
            }
        }
        
        if(!updatedInvoiceList.isEmpty()){
            update updatedInvoiceList;
        }
     }
     
     //Invoking the approval request for Regional Approval or Finance Approval
     public static void invokeApprovalProcess(List<RMA__c> newRMARecordList){
        List<RMA__c> rmaList = new List<RMA__c>();
        for(RMA__c RMAreq: newRMARecordList){
            if(RMAreq.Workflow_Stage__c == RMA_Constants.PEN_REG_DIR || RMAreq.Workflow_Stage__c == RMA_Constants.PEN_PRD_MGR){
                // Create an approval request for the RMA request
                Approval.ProcessSubmitRequest req1 = new Approval.ProcessSubmitRequest();
                req1.setComments('Invoking the Approval Request for Regional Approval.');
                req1.setObjectId(RMAreq.Id);
                // Submit on behalf of a specific submitter
                req1.setSubmitterId(UserInfo.getUserId()); 
                req1.setSkipEntryCriteria(true);
                
                // Submit the record to specific process and skip the criteria evaluation
                req1.setProcessDefinitionNameOrId('RMA_Regional_Approval');
                
                // Submit the approval request for the RMA
                Approval.ProcessResult resultReAssign = Approval.process(req1);
                
                //to copy wafer ids
                rmaList.add(RMAreq);
                
            }
            else if(RMAreq.Workflow_Stage__c == RMA_Constants.PEN_FIN_MGR){
                 
                // Create an approval request for the RMA request
                Approval.ProcessSubmitRequest req1 = new Approval.ProcessSubmitRequest();
                req1.setComments('Invoking the Approval Request for Finance Approval.');
                req1.setObjectId(RMAreq.Id);
                
                // Submit on behalf of a specific submitter
                req1.setSubmitterId(UserInfo.getUserId()); 
                req1.setSkipEntryCriteria(true);
                
                // Submit the record to specific process and skip the criteria evaluation
                req1.setProcessDefinitionNameOrId('RMA_Finance_Approval');
                
                // Submit the approval request for the RMA
                Approval.ProcessResult resultReAssign = Approval.process(req1);
            }
            else if(RMA_Utility.checkFab9or10(RMAreq.Fab__c)){
                if(RMAreq.Workflow_Stage__c.equalsIgnoreCase(RMA_Constants.PEN_FAB_VAL)){
                    Approval.ProcessSubmitRequest req1 = new Approval.ProcessSubmitRequest();
                    req1.setComments('Invoking Approval Process for Fab Validation');
                    req1.setObjectId(RMAreq.Id);
                    req1.setSubmitterId(UserInfo.getUserId()); 
                    req1.setSkipEntryCriteria(true);
                    req1.setProcessDefinitionNameOrId('RMA_Fab_Group_Approval_For_Fab_9_and_10');
                    Approval.ProcessResult resultReAssign = Approval.process(req1); 
                }
                else if(RMAreq.Workflow_Stage__c.equalsIgnoreCase(RMA_Constants.PEN_LOG_APPR) || RMAreq.Workflow_Stage__c.equalsIgnoreCase(RMA_Constants.PEN_CSR_MGR_APPR)){
                    Approval.ProcessSubmitRequest req1 = new Approval.ProcessSubmitRequest();
                    req1.setComments('Invoking Approval Process for Logistic/CSR Manager Approval');
                    req1.setObjectId(RMAreq.Id);
                    req1.setSubmitterId(UserInfo.getUserId()); 
                    req1.setSkipEntryCriteria(true);
                    req1.setProcessDefinitionNameOrId('RMA_Logistics_CSR_Manager_Approval');
                    Approval.ProcessResult resultReAssign = Approval.process(req1);
                }
            }
        }
        if(!rmaList.isEmpty()){
            copyWaferIds(rmaList,'TechToReg');
            provideAccess(rmaList);
            List<RMA__c> rmaListTemp = new List<RMA__c>();
            for(RMA__c rmaRec : rmaList){
                if(!RMA_Utility.checkFab9or10(rmaRec.Fab__c)){
                    rmaListTemp.add(rmaRec);
                }
            }
            if(!rmaListTemp.isEmpty()){
                RMA_Email_Notification_Helper.sendEmailNotification(rmaListTemp,'Tech-Reg Validation'); 
            }
        }
     }
     
    //Populate the Region Head and Sales SVP on creation of RMA request based on the Customer selection
    public static void populateRegionalHeadDetails(List<RMA__c> newRMARecordList){
        List<String> lstAccountId = new List<String>();
        Map<String,String> mapAccountIdVsTer = new Map<String,String>();
        
        for(RMA__c RMAreq: newRMARecordList){
            lstAccountId.add(RMAreq.Customer__c);
        }
        
        for(Account acc: [SELECT Financial_Territory__c FROM Account WHERE Id in: lstAccountId]){
            mapAccountIdVsTer.put(acc.Id,acc.Financial_Territory__c);
        }
		
        //++ NJain-12Jul16 - New Code for populating Region Heads and SVP from Account Region Head Mapping
        Map<String,Account_Region_Head_Mapping__c> mapStrategicAccount = new Map<String,Account_Region_Head_Mapping__c>();
        Map<String,Account_Region_Head_Mapping__c> mapTerritories = new Map<String,Account_Region_Head_Mapping__c>();
        for(Account_Region_Head_Mapping__c arhm : [SELECT Region_Head_LK__c, Region_Head_Backup_LK__c,
                                                        Strategic_Account__c,Sales_Territory__c,Sales_SVP__c
                                                     FROM  Account_Region_Head_Mapping__c
                                                     WHERE Strategic_Account__c in :lstAccountId 
                                                        OR Sales_Territory__c   in :mapAccountIdVsTer.values()]){
            if(arhm.Sales_Territory__c != NULL){
                mapTerritories.put(arhm.Sales_Territory__c,arhm);
            }else if(arhm.Strategic_Account__c != NULL){
                mapStrategicAccount.put(arhm.Strategic_Account__c,arhm);
            }
        }
        
        for(RMA__c RMAreq: newRMARecordList){
            if(mapStrategicAccount != NULL && mapStrategicAccount.get(RMAreq.Customer__c) != NULL){
                RMAreq.Region_Head__c = mapStrategicAccount.get(RMAreq.Customer__c).Region_Head_LK__c;
                RMAreq.Sales_SVP__c   = mapStrategicAccount.get(RMAreq.Customer__c).Sales_SVP__c;
                RMAreq.Region_Head_Backup__c = mapStrategicAccount.get(RMAreq.Customer__c).Region_Head_Backup_LK__c;
            }else if(mapTerritories != NULL && mapAccountIdVsTer != NULL && mapAccountIdVsTer.get(RMAreq.Customer__c) !=NULL &&
                     mapTerritories.get(mapAccountIdVsTer.get(RMAreq.Customer__c)) != NULL){
                RMAreq.Region_Head__c = mapTerritories.get(mapAccountIdVsTer.get(RMAreq.Customer__c)).Region_Head_LK__c;
                RMAreq.Sales_SVP__c   = mapTerritories.get(mapAccountIdVsTer.get(RMAreq.Customer__c)).Sales_SVP__c;
                RMAreq.Region_Head_Backup__c = mapTerritories.get(mapAccountIdVsTer.get(RMAreq.Customer__c)).Region_Head_Backup_LK__c;
            }
        }
        
    }
    
    //Populate RMA Cycle Time 
    public static void populateCycleTime(Map<id, RMA__c> rmaNewMap){
        Map<String,RMA_Cycle_Time_Settings__mdt> gfCycleTimeMap = new Map<String,RMA_Cycle_Time_Settings__mdt>();
        Map<String,RMA_Cycle_Time_Settings__mdt> smplsiCycleTimeMap = new Map<String,RMA_Cycle_Time_Settings__mdt>();
        Map<String,RMA_Cycle_Time_Settings__mdt> redCycleTimeMap = new Map<String,RMA_Cycle_Time_Settings__mdt>();
        Map<Id, RMA__c> rmaShortNameMap = new Map<Id, RMA__c>();
        Set<String> lstStage = new Set<String>();
        
        //As this is before trigger context, we can not club both the below for loops into one.
        for(RMA__c rmaObj : rmaNewMap.values()){
            lstStage.add(rmaObj.RMA_Category__c);
        }
        //Retreiving RMA records for customer short name. 
        //Though we have formula field, as formula field values could not be fetched in before update, querying using SOQL.
        for(RMA__c RMAreq: [SELECT ID, Customer__r.Short_Name__c,Customer__r.Customer_Number__c,RMA_Category__c FROM RMA__c WHERE ID IN:rmaNewMap.keyset()]){
            rmaShortNameMap.put(RMAreq.id, RMAreq);
        }
        for(RMA_Cycle_Time_Settings__mdt cycleTime: [SELECT Id,Label,Cycle_Time_for_CSR_Submission__c, Cycle_time_for_Fab_Validation__c, Cycle_Time_for_Finance_Approval__c,
                                                            Cycle_Time_for_Regional_Approval__c, Cycle_time_for_Wafer_Acknowledgement__c,Category__c, IS_SMPLSI__c,
                                                            Cycle_Time_for_Customer_Qty_Validation__c,RMA_Reason_Code__c
                                                      FROM RMA_Cycle_Time_Settings__mdt where Category__c in :lstStage]){
            if(cycleTime.IS_SMPLSI__c){
                smplsiCycleTimeMap.put(cycleTime.Category__c,cycleTime);
            }
            else if(!cycleTime.IS_SMPLSI__c && cycleTime.Label.startsWith('Red')){
                redCycleTimeMap.put(cycleTime.RMA_Reason_Code__c,cycleTime);
            }
            else{                                                          
                gfCycleTimeMap.put(cycleTime.Category__c,cycleTime);
            }
        }
        
        for(RMA__c RMAreq: rmaNewMap.values()){
            
            String customerShortName = rmaShortNameMap.get(RMAreq.id).Customer__c != null ? rmaShortNameMap.get(RMAreq.id).Customer__r.Customer_Number__c : null;
            if(String.isNotBlank(customerShortName) && customerShortName.equals(RMA_Constants.AGERE_CUSTOMER_NUMBER) && RMAreq.Fab__c.equals('FAB 5') && 
            smplsiCycleTimeMap.get(RMAreq.RMA_Category__c) != null){
                RMAreq.Cycle_Time_for_Customer_Qty_Validation__c = smplsiCycleTimeMap.get(RMAreq.RMA_Category__c).Cycle_Time_for_Customer_Qty_Validation__c;
                RMAreq.Cycle_Time_for_Fab_Validation__c     = smplsiCycleTimeMap.get(RMAreq.RMA_Category__c).Cycle_Time_for_Fab_Validation__c;
                RMAreq.Cycle_Time_for_Regional_Approval__c  = smplsiCycleTimeMap.get(RMAreq.RMA_Category__c).Cycle_Time_for_Regional_Approval__c;
                RMAreq.Cycle_Time_for_Finance_Approval__c   = smplsiCycleTimeMap.get(RMAreq.RMA_Category__c).Cycle_Time_for_Finance_Approval__c;
                RMAreq.Cycle_Time_for_Wafer_Acknowledgement__c= smplsiCycleTimeMap.get(RMAreq.RMA_Category__c).Cycle_Time_for_Wafer_Acknowledgement__c;
            }
            else if(RMA_Utility.checkFab9or10(RMAreq.Fab__c) && redCycleTimeMap.get(RMAreq.ReasonCode__c) != NULL){
                RMAreq.Cycle_Time_for_CSR_Submission__c     = redCycleTimeMap.get(RMAreq.ReasonCode__c).Cycle_Time_for_CSR_Submission__c;
                RMAreq.Cycle_Time_for_Customer_Qty_Validation__c = redCycleTimeMap.get(RMAreq.ReasonCode__c).Cycle_Time_for_Customer_Qty_Validation__c;
                RMAreq.Cycle_Time_for_Fab_Validation__c     = redCycleTimeMap.get(RMAreq.ReasonCode__c).Cycle_Time_for_Fab_Validation__c;
                RMAreq.Cycle_Time_for_Regional_Approval__c  = redCycleTimeMap.get(RMAreq.ReasonCode__c).Cycle_Time_for_Regional_Approval__c;
                RMAreq.Cycle_Time_for_Finance_Approval__c   = redCycleTimeMap.get(RMAreq.ReasonCode__c).Cycle_Time_for_Finance_Approval__c;
                RMAreq.Cycle_Time_for_Wafer_Acknowledgement__c= redCycleTimeMap.get(RMAreq.ReasonCode__c).Cycle_Time_for_Wafer_Acknowledgement__c;
            }
            else if(gfCycleTimeMap.get(RMAreq.RMA_Category__c) != null){
                RMAreq.Cycle_Time_for_Customer_Qty_Validation__c = gfCycleTimeMap.get(RMAreq.RMA_Category__c).Cycle_Time_for_Customer_Qty_Validation__c;
                RMAreq.Cycle_Time_for_Fab_Validation__c     = gfCycleTimeMap.get(RMAreq.RMA_Category__c).Cycle_Time_for_Fab_Validation__c;
                RMAreq.Cycle_Time_for_Regional_Approval__c  = gfCycleTimeMap.get(RMAreq.RMA_Category__c).Cycle_Time_for_Regional_Approval__c;
                RMAreq.Cycle_Time_for_Finance_Approval__c   = gfCycleTimeMap.get(RMAreq.RMA_Category__c).Cycle_Time_for_Finance_Approval__c;
                RMAreq.Cycle_Time_for_Wafer_Acknowledgement__c= gfCycleTimeMap.get(RMAreq.RMA_Category__c).Cycle_Time_for_Wafer_Acknowledgement__c;
            }
        }
    }
    
    //to provide Read/Edit access to validators and unlock RMA record
    public static void provideAccess(List<RMA__c> newRMARecordList){
        List<RMA__c> fabTurnValList = new List<RMA__c>();
        List<RMA__c> nonFabValList = new List<RMA__c>();
        List<RMA__c> regList = new List<RMA__c>();
        List<RMA__c> regSrList = new List<RMA__c>();
        List<RMA__c> prodList = new List<RMA__c>();
        List<RMA__c> prodDirList = new List<RMA__c>();
        List<RMA__c> finList = new List<RMA__c>();
        List<RMA__c> prodEngList = new List<RMA__c>();
        List<RMA__Share> rmaShareList = new List<RMA__Share>();
        for(RMA__c RMAreq: newRMARecordList){
            if(RMAreq.Workflow_Stage__c == RMA_Constants.PEN_FAB_VAL || RMAreq.Workflow_Stage__c == RMA_Constants.PEN_TNK_VAL){
                fabTurnValList.add(RMAreq);
            }
            else if(RMAreq.Workflow_Stage__c == RMA_Constants.PEN_NONFAB_VAL){
                nonFabValList.add(RMAreq);
            }
            else if(RMAreq.Workflow_Stage__c == RMA_Constants.PEN_PRD_ENG){
                prodEngList.add(RMAreq);
            }
            else if(RMAreq.Workflow_Stage__c == RMA_Constants.PEN_REG_DIR){
                regList.add(RMAreq);
            }
            else if(RMAreq.Workflow_Stage__c == RMA_Constants.PEN_REG_SVP){
                regSrList.add(RMAreq);
            }
            else if(RMAreq.Workflow_Stage__c == RMA_Constants.PEN_PRD_MGR){
                prodList.add(RMAreq);
            }
            else if(RMAreq.Workflow_Stage__c == RMA_Constants.PEN_PRD_DIR){
                prodDirList.add(RMAreq);
            }
            else if(RMAreq.Workflow_Stage__c.startsWith('Pending for Finance')){
                finList.add(RMAreq);
            }
        }
        
        if(!fabTurnValList.isEmpty()){
            for(RMA_Access_User__c access: [SELECT Id, User__c, RMA__c, RMA__r.Workflow_Stage__c, User_Name__c, Category__c FROM RMA_Access_User__c 
                                                                                WHERE RMA__c IN: fabTurnValList and Category__c IN ('Fab','Turnkey')]){
                if(access.RMA__r.Workflow_Stage__c == RMA_Constants.PEN_FAB_VAL && access.Category__c == 'Fab'){
                    RMA__Share rmaShare = new RMA__Share();
                    rmaShare.UserOrGroupId = access.User__c;
                    rmaShare.ParentId = access.RMA__c;
                    rmaShare.AccessLevel = 'Edit';
                    rmaShare.RowCause = Schema.RMA__Share.RowCause.Fab_Validation__c;
                    rmaShareList.add(rmaShare);
                }
                else if(access.RMA__r.Workflow_Stage__c == RMA_Constants.PEN_TNK_VAL && access.Category__c == 'Turnkey'){
                    RMA__Share rmaShare = new RMA__Share();
                    rmaShare.UserOrGroupId = access.User__c;
                    rmaShare.ParentId = access.RMA__c;
                    rmaShare.AccessLevel = 'Edit';
                    rmaShare.RowCause = Schema.RMA__Share.RowCause.Turnkey_Validation__c;
                    rmaShareList.add(rmaShare);
                }
            }
        }
        if(!nonFabValList.isEmpty()){
            Map<RMA__c, Set<String>> rmaNonFabUserMap = new Map<RMA__c, Set<String>>();
            for(RMA__c rmaRec : nonFabValList){
                Set<String> nonFabUserList = new Set<String>();
                for(Schema.FieldSetMember members: SObjectType.RMA__c.FieldSets.RMA_Non_Fab_Approvers.getFields()){
                    if(rmaRec.get(members.getFieldPath()) != NULL){
                        nonFabUserList.add((String)rmaRec.get(members.getFieldPath()));
                    }
                }
                if(!nonFabUserList.isEmpty()){
                    rmaNonFabUserMap.put(rmaRec,nonFabUserList);
                }
            }
            if(!rmaNonFabUserMap.isEmpty()){
                for(RMA__c rmaRec : nonFabValList){
                    Set<String> nfList = new Set<String>();
                    nfList = rmaNonFabUserMap.get(rmaRec);
                    if(!nfList.isEmpty()){
                        for(String nf: nfList){
                            RMA__Share rmaShare = new RMA__Share();
                            rmaShare.UserOrGroupId = nf;
                            rmaShare.ParentId = rmaRec.Id;
                            rmaShare.AccessLevel = 'Edit';
                            rmaShare.RowCause = Schema.RMA__Share.RowCause.Non_Fab__c;
                            rmaShareList.add(rmaShare); 
                        }
                    }
                }
            }
        }
        if(!prodEngList.isEmpty()){
            Set<Id> setGroupId = new Set<Id>();
            Set<Id> setUserId = new Set<Id>();
            for(GroupMember member : [select UserOrGroupId from GroupMember where Group.Name = 'RMA PE Personnel' and Group.Type = 'Queue']){
                if(((String)member.UserOrGroupId).startsWith(RMA_Constants.GROUP_KEYPREFIX)){
                    setGroupId.add(member.UserOrGroupId);
                }
            }
            
            if(!setGroupId.isEmpty()){
                for(RMA__c rmaRec : prodEngList){
                    for(Id userId : setGroupId){
                        RMA__Share rmaShare = new RMA__Share();
                        rmaShare.UserOrGroupId = userId;
                        rmaShare.ParentId = rmaRec.Id;
                        rmaShare.AccessLevel = 'Edit';
                        rmaShare.RowCause = Schema.RMA__Share.RowCause.SMP_Approval__c;
                        rmaShareList.add(rmaShare);
                    }   
                }
            }
        }
        if(!regList.isEmpty()){
            for(RMA__c rmaRec : regList){
                RMA__Share rmaShare = new RMA__Share();
                rmaShare.UserOrGroupId = rmaRec.Region_Head__c;
                rmaShare.ParentId = rmaRec.Id;
                rmaShare.AccessLevel = 'Edit';
                rmaShare.RowCause = Schema.RMA__Share.RowCause.Regional_Approval__c;
                rmaShareList.add(rmaShare);
                
                //Provide access to Region Head (Backup)
                if(rmaRec.Region_Head_Backup__c != NULL){
                    RMA__Share rmaShare2 = new RMA__Share();
                    rmaShare2.UserOrGroupId = rmaRec.Region_Head_Backup__c;
                    rmaShare2.ParentId = rmaRec.Id;
                    rmaShare2.AccessLevel = 'Edit';
                    rmaShare2.RowCause = Schema.RMA__Share.RowCause.Regional_Approval__c;
                    rmaShareList.add(rmaShare2);
                }
            }
        }
        if(!regSrList.isEmpty()){
            for(RMA__c rmaRec : regSrList){
                RMA__Share rmaShare = new RMA__Share();
                rmaShare.UserOrGroupId = rmaRec.Sales_SVP__c;
                rmaShare.ParentId = rmaRec.Id;
                rmaShare.AccessLevel = 'Edit';
                rmaShare.RowCause = Schema.RMA__Share.RowCause.Regional_Approval__c;
                rmaShareList.add(rmaShare);
            }
        }
        if(!prodList.isEmpty()){
            Set<Id> setGroupId = new Set<Id>();
            Set<Id> setUserId = new Set<Id>();
            for(GroupMember member : [select UserOrGroupId from GroupMember where Group.Name = 'RMA PE Manager' and Group.Type = 'Queue']){
                if(((String)member.UserOrGroupId).startsWith(RMA_Constants.GROUP_KEYPREFIX)){
                    setGroupId.add(member.UserOrGroupId);
                }
            }
            
            if(!setGroupId.isEmpty()){
                for(RMA__c rmaRec : prodList){
                    for(Id userId : setGroupId){
                        RMA__Share rmaShare = new RMA__Share();
                        rmaShare.UserOrGroupId = userId;
                        rmaShare.ParentId = rmaRec.Id;
                        rmaShare.AccessLevel = 'Edit';
                        rmaShare.RowCause = Schema.RMA__Share.RowCause.Regional_Approval__c;
                        rmaShareList.add(rmaShare);
                    }   
                }
            }
        }
        if(!prodDirList.isEmpty()){
            Set<Id> setGroupId = new Set<Id>();
            Set<Id> setUserId = new Set<Id>();
            for(GroupMember member : [select UserOrGroupId from GroupMember where Group.Name = 'RMA PE Director' and Group.Type = 'Queue']){
                if(((String)member.UserOrGroupId).startsWith(RMA_Constants.GROUP_KEYPREFIX)){
                    setGroupId.add(member.UserOrGroupId);
                }
            }
            
            if(!setGroupId.isEmpty()){
                for(RMA__c rmaRec : prodDirList){
                    for(Id userId : setGroupId){
                        RMA__Share rmaShare = new RMA__Share();
                        rmaShare.UserOrGroupId = userId;
                        rmaShare.ParentId = rmaRec.Id;
                        rmaShare.AccessLevel = 'Edit';
                        rmaShare.RowCause = Schema.RMA__Share.RowCause.Regional_Approval__c;
                        rmaShareList.add(rmaShare);
                    }   
                }
            }
        }
        
        if(!finList.isEmpty()){
            for(RMA__c RMArec: finList){
                List<String> lstUsers = new List<String>();
                if(RMArec.Workflow_Stage__c == RMA_Constants.PEN_FIN_MGR){
                    lstUsers = retreiveFinanceApprover().get('RMA Fab Finance Manager- '+RMArec.Fab__c);
                }
                else if(RMArec.Workflow_Stage__c == RMA_Constants.PEN_FIN_FABDIR){
                    lstUsers = retreiveFinanceApprover().get('RMA Fab Director- '+RMArec.Fab__c);
                }
                else if(RMArec.Workflow_Stage__c == RMA_Constants.PEN_FIN_VPFIN){
                    lstUsers = retreiveFinanceApprover().get('RMA VP Operations - Finance');
                }
                else if(RMArec.Workflow_Stage__c == RMA_Constants.PEN_FIN_CORP){
                    lstUsers = retreiveFinanceApprover().get('RMA Corporate Controller');
                }
                else if(RMArec.Workflow_Stage__c == RMA_Constants.PEN_FIN_PRC){
                    lstUsers = retreiveFinanceApprover().get('RMA Pricing Council');
                }
                if(!lstUsers.isEmpty()){
                    for(String user : lstUsers){
                        RMA__Share rmaShare = new RMA__Share();
                        rmaShare.UserOrGroupId = user;
                        rmaShare.ParentId = rmaRec.Id;
                        rmaShare.AccessLevel = 'Edit';
                        rmaShare.RowCause = Schema.RMA__Share.RowCause.Finance_Approval__c;
                        rmaShareList.add(rmaShare);
                    }
                }
            }
        }
        
        
        if(!rmaShareList.isEmpty()){
            Database.SaveResult[] rmaSharesInsertResult = Database.insert(rmaShareList ,false);
        }
    }
    
    //retrieve GroupIds for Finance Approvers
    public static Map<String,List<String>> retreiveFinanceApprover(){
        Map<Id,Group> mapQueue = new Map<Id,Group>([select Id, Name from Group where (Name IN ('RMA Global AR Team','RMA AR Section Manager','RMA Finance Director',
                                                    'RMA VP Operations - Finance','RMA Corporate Controller','RMA Pricing Council') OR NAME LIKE 'RMA Fab Director- FAB%'
                                                     OR NAME LIKE 'RMA Fab Finance Manager- FAB%' OR NAME = 'RMA Fab Director- ALTIS'
                                                     OR NAME = 'RMA Fab Finance Manager- ALTIS' )and Type = 'Queue']);
        
        List<GroupMember> lstGroupMember = [select UserOrGroupId,GroupId,Group.Name from GroupMember where GroupId IN: mapQueue.keySet()];
        
        Map<String,List<String>> mapQueueGroup = new Map<String,List<String>>();
        for(Id queueId : mapQueue.keySet()){
            List<String> lstGroupId = new List<String>();
            for(GroupMember member : lstGroupMember){
                if(member.GroupId == queueId){
                    lstGroupId.add(member.UserOrGroupId);
                }
            }
            mapQueueGroup.put(mapQueue.get(queueId).Name,lstGroupId);
        }
        
        return mapQueueGroup;
    }
    
    
    public static void logRejectedRMA(List<RMA__c> rejectedRMAsForAudit){
        
        Map<String, Schema.FieldSet> rmaFieldSetMap = Schema.SObjectType.RMA_Audit_log__c.fieldSets.getMap();
        List<RMA_Audit_log__c> cycleTimeLogsToInsert = new List<RMA_Audit_log__c>();
        Id cycleTimeLogRecTypeId = RMA_Utility.getRecordTypeId('RMA_Audit_log__c', RMA_Constants.CYCLE_TIME_LOG);
        List<String> cycleTimeFieldSets = new List<String>{'RMA_CSR_Submission_Cycle_time', 'RMA_CQ_Validation_Cycle_Time', 'RMA_Fab_Validation_Cycle_time', 'RMA_Finance_Approval_Cycle_Time',
                                                            'RMA_Regional_Approval_Cycle_Time', 'RMA_Wafer_Acknowledgement_Cycle_Time'}; 
        for(RMA__c rmaObj : rejectedRMAsForAudit){
            RMA_Audit_log__c cycleTimeLog = new RMA_Audit_log__c(recordTypeId = cycleTimeLogRecTypeId, rma__c = rmaObj.id);
            for(String fieldSet : cycleTimeFieldSets){
                for(Schema.FieldSetMember f : rmaFieldSetMap.get(fieldSet).getFields()){
                    String fieldAPIName = f.getFieldPath();
                    cycleTimeLog.put(fieldAPIName, rmaObj.get(fieldAPIName)) ;
                }
            }
            cycleTimeLogsToInsert.add(cycleTimeLog);
        }
        
        if(!cycleTimeLogsToInsert.isEmpty()){
            insert cycleTimeLogsToInsert;
        }
    }
    
    //retreive Store Personnel Group Ids
    public static Map<String,List<String>> retreiveStorePersonnel(){
        Map<Id,Group> mapQueue = new Map<Id,Group>([select Id, Name from Group where Name LIKE 'RMA Store Personnel- FAB%' and Type = 'Queue']);
        Set<String> setQueueId = new Set<String>();
        
        for(String key : mapQueue.keySet()){
            setQueueId.add(key);
        }
        
        List<GroupMember> lstGroupMember = [select UserOrGroupId,GroupId,Group.Name from GroupMember where GroupId IN: setQueueId];
        
        Map<String,List<String>> mapQueueGroup = new Map<String,List<String>>();
        for(Id queueId : mapQueue.keySet()){
            List<String> lstGroup = new List<String>();
            for(GroupMember member : lstGroupMember){
                if(member.GroupId == queueId){
                    lstGroup.add(member.UserOrGroupId);
                }
            }
            mapQueueGroup.put(mapQueue.get(queueId).Name,lstGroup);
        }
        return mapQueueGroup;
    }
    
    public static void accessForAckn(List<RMA__c> rmaList){
        Map<RMA__c,List<String>> mapRMAProxy = new Map<RMA__c,List<String>>();
        Map<String,List<String>> fabStorePersonnelMap = retreiveStorePersonnel();
        List<RMA__Share> rmaShareList = new List<RMA__Share>();
        Set<String> setAcc = new Set<String>();
        for(RMA__c rmaRec : rmaList){
            setAcc.add(rmaRec.Customer__c);
        }
        
        List<Account_Team_Proxy__c> lstProxy = new List<Account_Team_Proxy__c>();
                                                                                    
        for(Account_Team_Proxy__c proxy : [select Id,User__c,Account__c from Account_Team_Proxy__c where Account__c IN: setAcc and Team_Role__c = 'Customer Engineer']){
            if(proxy != NULL){
                lstProxy.add(proxy);
            }
        }
                                                                                    
        for(RMA__c rmaRec : rmaList){
            List<String> lstUser = new List<String>();
            for(Account_Team_Proxy__c proxy : lstProxy){
                if(proxy.Account__c == rmaRec.Customer__c){
                    lstUser.add(proxy.User__c);
                }
            }
            mapRMAProxy.put(rmaRec,lstUser);
        }                                                                           
        
        for(RMA_Access_User__c access: [SELECT Id, User__c, RMA__c, Category__c 
                                        FROM RMA_Access_User__c 
                                        WHERE RMA__c IN: rmaList and Category__c IN ('Return Wafer','Scrap Certificate')]){
            RMA__Share rmaShare = new RMA__Share();
            rmaShare.UserOrGroupId = access.User__c;
            rmaShare.ParentId = access.RMA__c;
            rmaShare.AccessLevel = 'Edit';
            rmaShare.RowCause = Schema.RMA__Share.RowCause.Acknowledgement__c;
            rmaShareList.add(rmaShare);
        }
        
        for(RMA__c rmaRec: rmaList){
            if(RMA_Utility.checkFab9or10(rmaRec.Fab__c)){
                if(rmaRec.Disposition_of_Wafers__c.equalsIgnoreCase('Return to GF')){
                    if(rmaRec.Return_Location__c.equalsIgnoreCase('Burlington')){
                        //access granted through sharing rule
                    }
                    else if(rmaRec.Return_Location__c.equalsIgnoreCase('APLC')){
                        //access granted through sharing rule
                    }
                }
            }else{
                rmaShareList.addAll(createRMAShare(fabStorePersonnelMap.get('RMA Store Personnel- '+rmaRec.Fab__c),rmaRec.Id));
            }
            if(!mapRMAProxy.isEmpty() && mapRMAProxy.containsKey(rmaRec)){
                rmaShareList.addAll(createRMAShare(mapRMAProxy.get(rmaRec),rmaRec.Id));         
            }
        } 
        
        if(!rmaShareList.isEmpty()){
            Database.SaveResult[] rmaSharesInsertResult = Database.insert(rmaShareList ,false); 
        }
    }
    
    public static List<RMA__Share> createRMAShare(List<String> storePersonnelFabUserList,String rmaId){
        List<RMA__Share> lstRMAlist = new List<RMA__Share>();
        for(String strPerId: storePersonnelFabUserList){
            RMA__Share rmaShare = new RMA__Share();
            rmaShare.UserORGroupId = strPerId;
            rmaShare.ParentId = rmaId;
            rmaShare.AccessLevel = 'Edit';
            rmaShare.RowCause = Schema.RMA__Share.RowCause.Acknowledgement__c;
            lstRMAlist.add(rmaShare);
        }
        return lstRMAlist;
    }
    
    public static void afterInsert(List<RMA__c> newRMAList){
        Map<RMA__c, List<String>>  mapRMAProxy = new Map<RMA__c, List<String>>();
        Set<String> setAccountId = new Set<String>();
        for(RMA__c rmaRec : newRMAList){
            setAccountId.add(rmaRec.Customer__c);
        }
        List<Account_Team_Proxy__c> lstAccountTeamProxy = [select User__c from Account_Team_Proxy__c where Account__c IN: setAccountId and Team_Role__c IN ('Primary Customer Service Rep','Backup Customer Service Rep','Customer Service Rep')];
        for(RMA__c rmaRec : newRMAList){
            List<String> lstUserIds = new List<String>();
            for(Account_Team_Proxy__c proxy : lstAccountTeamProxy){
                if(rmaRec.OwnerId != proxy.User__c){
                    lstUserIds.add(proxy.User__c);
                }
            }
            mapRMAProxy.put(rmaRec,lstUserIds);
        }
        if(!mapRMAProxy.isEmpty()){
            List<RMA__Share> rmaShareList = new List<RMA__Share>();
            for(RMA__c rmaRec: mapRMAProxy.keySet()){
                List<String> lstUserIds = mapRMAProxy.get(rmaRec);
                for(String userIds : lstUserIds){
                    RMA__Share rmaShare = new RMA__Share();
                    rmaShare.UserOrGroupId = userIds;
                    rmaShare.ParentId = rmaRec.Id;
                    rmaShare.AccessLevel = 'Edit';
                    rmaShare.RowCause = Schema.RMA__Share.RowCause.CSR__c;
                    rmaShareList.add(rmaShare);
                }
            }
            
            if(!rmaShareList.isEmpty()){
                Database.SaveResult[] rmaSharesInsertResult = Database.insert(rmaShareList ,false);
            }
        }
    }
    
    public static void populateCycleTimeForFab9and10(List<RMA__c> lstRMA){
        Map<String,RMA_Cycle_Time_Settings__mdt> redCycleTimeMap = new Map<String,RMA_Cycle_Time_Settings__mdt>();
        Set<String> lstStage = new Set<String>();
        
        if(!lstRMA.isEmpty()){
            for(RMA__c rmaRec : lstRMA){
                lstStage.add(rmaRec.RMA_Category__c);
            }
            
            for(RMA_Cycle_Time_Settings__mdt cycleTime: [SELECT Id,Label,Cycle_Time_for_CSR_Submission__c, Cycle_time_for_Fab_Validation__c, Cycle_Time_for_Finance_Approval__c,
                                                        Cycle_Time_for_Regional_Approval__c, Cycle_time_for_Wafer_Acknowledgement__c,Category__c, IS_SMPLSI__c,
                                                        Cycle_Time_for_Customer_Qty_Validation__c,RMA_Reason_Code__c
                                                  FROM RMA_Cycle_Time_Settings__mdt where Category__c in :lstStage and Label LIKE 'Red%']){
                redCycleTimeMap.put(cycleTime.RMA_Reason_Code__c,cycleTime);        
            }
            
            for(RMA__c RMAreq : lstRMA){
                RMAreq.Cycle_Time_for_CSR_Submission__c     = redCycleTimeMap.get(RMAreq.ReasonCode__c).Cycle_Time_for_CSR_Submission__c;
                RMAreq.Cycle_Time_for_Customer_Qty_Validation__c = redCycleTimeMap.get(RMAreq.ReasonCode__c).Cycle_Time_for_Customer_Qty_Validation__c;
                RMAreq.Cycle_Time_for_Fab_Validation__c     = redCycleTimeMap.get(RMAreq.ReasonCode__c).Cycle_Time_for_Fab_Validation__c;
                RMAreq.Cycle_Time_for_Regional_Approval__c  = redCycleTimeMap.get(RMAreq.ReasonCode__c).Cycle_Time_for_Regional_Approval__c;
                RMAreq.Cycle_Time_for_Finance_Approval__c   = redCycleTimeMap.get(RMAreq.ReasonCode__c).Cycle_Time_for_Finance_Approval__c;
                RMAreq.Cycle_Time_for_Wafer_Acknowledgement__c= redCycleTimeMap.get(RMAreq.ReasonCode__c).Cycle_Time_for_Wafer_Acknowledgement__c;
            }
            
        }                                           
    }
    
    //for initial submission
    public static void afterQualityApproval(List<RMA__c> rmaList){
        for(RMA__c RMArecord : rmaList){
            if(!RMA_Utility.checkFab9or10(RMArecord.Fab__c)){
                if(RMArecord.RMA_Category__c.equalsIgnoreCase('Failure Analysis')){
                    RMA_Email_Notification_Helper.afterQualityApproval(RMArecord,'Failure Analysis');
                }
                else if(RMArecord.RMA_Category__c.equalsIgnoreCase('Technical/ Turnkey') && RMArecord.Assign_To__c != NULL){
                    if(RMArecord.Assign_To__c.equalsIgnoreCase('Fab')){
                        Approval.ProcessSubmitRequest req = new Approval.ProcessSubmitRequest();
                        req.setComments('Submitting request for fab approval');
                        req.setObjectId(RMArecord.Id);
                        req.setSubmitterId(UserInfo.getUserId());
                        req.setSkipEntryCriteria(true);
                        req.setProcessDefinitionNameOrId('RMA_Fab_Group_Approval');
                        Approval.ProcessResult result = Approval.process(req);
                        
                        if(result.isSuccess()){
                            if(RMArecord.is_SMPLSI__c){
                                RMA_Email_Notification_Helper.afterQualityApproval(RMArecord,'Pending for Product Engineer Validation');
                            }
                            else{
                                RMA_Email_Notification_Helper.afterQualityApproval(RMArecord,'Pending for Fab Validation');
                            }
                        }
                    }
                    else if(RMArecord.Assign_To__c.equalsIgnoreCase('Turnkey')){
                        Approval.ProcessSubmitRequest req = new Approval.ProcessSubmitRequest();
                        req.setComments('Submitting request for turnkey approval');
                        req.setObjectId(RMArecord.Id);
                        req.setSubmitterId(UserInfo.getUserId());
                        req.setSkipEntryCriteria(true);
                        req.setProcessDefinitionNameOrId('RMA_Turnkey_Approval');
                        Approval.ProcessResult result = Approval.process(req);
                        if(result.isSuccess()){
                            RMA_Email_Notification_Helper.afterQualityApproval(RMArecord,'Pending for Turnkey/ Sub-con Validation');    
                        }
                    }
                }
                else{
                    if(RMArecord.RMA_Category__c.equalsIgnoreCase('Business')){
                        Approval.ProcessSubmitRequest req1 = new Approval.ProcessSubmitRequest();
                        req1.setComments('Invoking the Approval Request for Regional Approval.');
                        req1.setObjectId(RMArecord.Id);
                        req1.setSubmitterId(UserInfo.getUserId()); 
                        req1.setSkipEntryCriteria(true);
                        req1.setProcessDefinitionNameOrId('RMA_Regional_Approval');
                        Approval.ProcessResult result = Approval.process(req1);
                        if(result.isSuccess()){
                            if(RMArecord.is_SMPLSI__c){
                                RMA_Email_Notification_Helper.afterQualityApproval(RMArecord,'Pending for Product Engineering - Manager'); 
                            }
                            else{
                                RMA_Email_Notification_Helper.afterQualityApproval(RMArecord,'Pending for Regional Recommendation Director');
                            }
                        }
                    }
                    else{
                        Approval.ProcessSubmitRequest req = new Approval.ProcessSubmitRequest();
                        req.setComments('Submitting request for fab approval');
                        req.setObjectId(RMArecord.Id);
                        req.setSubmitterId(UserInfo.getUserId());
                        req.setSkipEntryCriteria(true);
                        req.setProcessDefinitionNameOrId('RMA_Fab_Group_Approval');
                        Approval.ProcessResult result = Approval.process(req);
                        
                        if(result.isSuccess()){
                            if(RMArecord.is_SMPLSI__c){
                                RMA_Email_Notification_Helper.afterQualityApproval(RMArecord,'Pending for Product Engineer Validation');
                            }
                            else{
                                RMA_Email_Notification_Helper.afterQualityApproval(RMArecord,'Pending for Fab Validation');
                            }
                        }
                    }
                }
                
            }
            else{
                if(RMArecord.Workflow_Stage__c.equalsIgnoreCase(RMA_Constants.PEN_FAB_VAL)){
                    Approval.ProcessSubmitRequest req1 = new Approval.ProcessSubmitRequest();
                    req1.setComments('Invoking Approval Process for Fab Validation');
                    req1.setObjectId(RMArecord.Id);
                    req1.setSubmitterId(UserInfo.getUserId()); 
                    req1.setSkipEntryCriteria(true);
                    req1.setProcessDefinitionNameOrId('RMA_Fab_Group_Approval_For_Fab_9_and_10');
                    Approval.ProcessResult resultReAssign = Approval.process(req1);
                }
                else if(RMArecord.Workflow_Stage__c.equalsIgnoreCase(RMA_Constants.PEN_LOG_APPR) || RMArecord.Workflow_Stage__c.equalsIgnoreCase(RMA_Constants.PEN_CSR_MGR_APPR)){
                    Approval.ProcessSubmitRequest req1 = new Approval.ProcessSubmitRequest();
                    req1.setComments('Invoking Approval Process for Logistic/CSR Manager Approval');
                    req1.setObjectId(RMArecord.Id);
                    req1.setSubmitterId(UserInfo.getUserId()); 
                    req1.setSkipEntryCriteria(true);
                    req1.setProcessDefinitionNameOrId('RMA_Logistics_CSR_Manager_Approval');
                    Approval.ProcessResult resultReAssign = Approval.process(req1);
                }
            }
        }
    }
    
    @future(callout=true)
    public static void unlockRecords(List<Id> TriggerNew){
        if(!Test.isRunningTest()){
            Approval.UnlockResult[] unlockList = Approval.unlock(TriggerNew,false);
        }
    }
}