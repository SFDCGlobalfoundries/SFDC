/**
* Company       :   Cognizant Technologies PTE Ltd.
* Description   :   Trigger on RMA object.
* History       :   

        Initials        Date          Description
-----------------------------------------------------------------------------------------
        Nikhil Jain    17-Nov-15      Created the Trigger
        jabee 06-04-17 we have added set to get business Category line 161-270 and 805
**/

trigger RMA_Trigger  on RMA__c (after insert, before insert, before update, after update){
    
    List<RMA__c> rmaAfterQtyList = new List<RMA__c>();    
    List<RMA__c> rmaForCQList = new List<RMA__c>();
    List<RMA__c> rmaForCopyList = new List<RMA__c>();  
    List<RMA__c> rmaToInvokeList = new List<RMA__c>(); 
    List<RMA__c> rmaRedForFabValidation = new List<RMA__c>();
    List<RMA__c> rmaRedForRegValidation = new List<RMA__c>();
    List<RMA__c> rmaLogisticsUnlock = new List<RMA__c>();
    List<RMA__c> rmaForAccessList = new List<RMA__c>(); 
    List<RMA__c> rmaBeforeApproval = new List<RMA__c>(); 
    List<RMA__c> rejectedRMAsForAudit = new List<RMA__c>();   
    List<RMA__c> rmaWithNewAssignee = new List<RMA__c>();
    List<RMA__c> rmaForFabValidation = new List<RMA__c>();
    List<RMA__c> rmaRejectedByFinanceList = new List<RMA__c>();
    List<String> rmaApprovedByFinanceList = new List<String>();
    List<RMA__c> rmaForSOIssue = new List<RMA__c>();
    List<RMA__c> rmaForCNIssue = new List<RMA__c>();
    List<RMA__c> rmaForRegvalidationList = new List<RMA__c>();
    List<RMA__c> rmaForAcknList = new List<RMA__c>();
    List<RMA__c> rmaAfterAcknList = new List<RMA__c>();
    List<RMA__c> rmaWaferScrapList = new List<RMA__c>();
    List<RMA__c> rmaForExtensionList = new List<RMA__c>();
    List<RMA__c> rmaVoidedList = new List<RMA__c>();
    List<RMA__c> rmaRejectedByQlty = new List<RMA__c>();
    List<RMA__c> rmaRejectedList = new List<RMA__c>();
    List<RMA__c> rmaRejectedByFab = new List<RMA__c>();
    List<RMA__c> rmaRejectedByReg = new List<RMA__c>();
    List<RMA__c> rmaProdDirAppr = new List<RMA__c>();
    List<RMA__c> rmaFailAnlys = new List<RMA__c>();
    List<RMA__c> rmaForFinanceApproval = new List<RMA__c>();
    List<RMA__c> rmaRegSrVP = new List<RMA__c>();
    List<RMA__c> rmaCNDNClosed = new List<RMA__c>();
    List<RMA__c> rmaFAClosed = new List<RMA__c>();
    List<RMA__c> rmaFinClosed = new List<RMA__c>();
    
    //For Reminder for Quality Approval
    List<RMA__c> rmaQltyReminderList = new List<RMA__c>();
    List<RMA__c> rmaQltyReminder1List = new List<RMA__c>();
    List<RMA__c> rmaQltyReminder2List = new List<RMA__c>();
    List<RMA__c> rmaQltyReminder3List = new List<RMA__c>();
    
    //For Pending For Fab Validation Reminder
    List<RMA__c> rmaFabValidationReminderList = new List<RMA__c>();
    List<RMA__c> rmaFabValidationReminder1List = new List<RMA__c>();
    List<RMA__c> rmaFabValidationReminder2List = new List<RMA__c>();
    List<RMA__c> rmaFabValidationReminder3List = new List<RMA__c>();
    
    //for Pending Acknowledgement Reminder
    List<RMA__c> rmaAckReminderList = new List<RMA__c>();
    List<RMA__c> rmaAckReminder1List = new List<RMA__c>();
    List<RMA__c> rmaAckReminder2List = new List<RMA__c>();
    List<RMA__c> rmaAckReminder3List = new List<RMA__c>();
    
    //for Pending Regional Recommendation or Product Manager
    List<RMA__c> rmaRegReminderList = new List<RMA__c>();
    List<RMA__c> rmaRegReminder1List = new List<RMA__c>();
    List<RMA__c> rmaRegReminder2List = new List<RMA__c>();
    List<RMA__c> rmaRegReminder3List = new List<RMA__c>();
    
    //for Pending Regional Recommendation or Product Manager
    List<RMA__c> rmaFinanceReminderList = new List<RMA__c>();
    List<RMA__c> rmaFinanceReminder1List = new List<RMA__c>();
    List<RMA__c> rmaFinanceReminder2List = new List<RMA__c>();
    List<RMA__c> rmaFinanceReminder3List = new List<RMA__c>();
    
    if(!IntegrationUserUtil.isSkipTrigger()){
        
        if(Trigger.isAfter && Trigger.isUpdate){
            
            //NJain- 15Jul16- for Sending Reminder/Escalation Mails
            map<String,RMA__c> mapStageRemVsRMA = new Map<String,RMA__c>();
            set<String> BusinessCategorySet =new set<String>();
            //++NJain-5Oct16-For checking invoices against CRO
            map<String,List<Invoice__c>> mapCROSOvsInvoices = new Map<String,List<Invoice__c>>();
            List<String> lstSalesOrderNoCRO = new List<String>();
            
            for(RMA__c RMAreq: Trigger.New){
                if( RMAreq.Workflow_Stage__c != NULL &&
                    RMAreq.Workflow_Stage__c != trigger.oldMap.get(RMAreq.Id).Workflow_Stage__c && 
                    Trigger.OldMap.get(RMAreq.Id).Workflow_Stage__c == 'Pending for Finance Approval - Manager' &&
                    RMAreq.Workflow_Stage__c != 'Rejected RMA' &&
                    RMAreq.Compensation_Type__c == 'Credit with charged replacement' && 
                    RMAreq.Sales_Order_Number_CRO__c != NULL && RMAreq.Sales_Order_Number_CRO__c != ''){
                        lstSalesOrderNoCRO.add(RMAreq.Sales_Order_Number_CRO__c);
                }
            }
            if(!lstSalesOrderNoCRO.isEmpty()){
                for(Invoice__c invRec: [SELECT Id,Bill_Quantity__c,Unit_Selling_Price__c,Die_Selling_Price__c,Sales_Order_Number__c
                                         FROM Invoice__c where Sales_Order_Number__c in :lstSalesOrderNoCRO limit 2000]){
                    if(invRec.Sales_Order_Number__c != NULL && invRec.Sales_Order_Number__c != '' &&
                       !mapCROSOvsInvoices.containsKey(invRec.Sales_Order_Number__c)){
                        mapCROSOvsInvoices.put(invRec.Sales_Order_Number__c,new List<Invoice__c>());
                    }
                    mapCROSOvsInvoices.get(invRec.Sales_Order_Number__c).add(invRec);
                }
            }
            //--NJain-5Oct16-For checking invoices against CRO
            
            for(RMA__c RMAreq: Trigger.New){
                
                //Pending for CN issue
                if(trigger.oldMap.get(RMAreq.Id).Workflow_Stage__c != RMAreq.Workflow_Stage__c
                        && RMAreq.Workflow_Stage__c == RMA_Constants.PEN_CN_ISS
                        && !RMA_Utility.checkFab9or10(RMAreq.Fab__c)){
                    rmaForCNIssue.add(RMAreq);
                }
                
                //for Regional Recommendation - Sr.VP approval
                if(trigger.oldMap.get(RMAreq.Id).Workflow_Stage__c != RMAreq.Workflow_Stage__c
                        && RMAreq.Workflow_Stage__c == RMA_Constants.PEN_REG_SVP){
                    rmaRegSrVP.add(RMAreq);
                }
                
                //for Product Director Approval
                if(trigger.oldMap.get(RMAreq.Id).Workflow_Stage__c != RMAreq.Workflow_Stage__c
                        && RMAreq.Workflow_Stage__c == RMA_Constants.PEN_PRD_DIR){
                    rmaProdDirAppr.add(RMAreq);
                }
                
                //NJain-20Sep16- Check CRO fulfilment before Finance Approval.
                if( RMAreq.Workflow_Stage__c != NULL &&
                    RMAreq.Workflow_Stage__c != trigger.oldMap.get(RMAreq.Id).Workflow_Stage__c && 
                    Trigger.OldMap.get(RMAreq.Id).Workflow_Stage__c == 'Pending for Finance Approval - Manager' &&
                    RMAreq.Workflow_Stage__c != 'Rejected RMA' &&
                    RMAreq.Compensation_Type__c == 'Credit with charged replacement'){
                    double totalAmount = 0;
                    if(RMAreq.Sales_Order_Number_CRO__c != NULL && RMAreq.Sales_Order_Number_CRO__c != ''){
                        if(mapCROSOvsInvoices.containsKey(RMAreq.Sales_Order_Number_CRO__c)){
                            for(Invoice__c invRec: mapCROSOvsInvoices.get(RMAreq.Sales_Order_Number_CRO__c)){
                                if(invRec.Bill_Quantity__c != NULL && invRec.Unit_Selling_Price__c != NULL){
                                    totalAmount = totalAmount + invRec.Bill_Quantity__c * invRec.Unit_Selling_Price__c;
                                }
                            }
                            if(totalAmount != RMAreq.Grand_Total_Final__c){
                                rmaReq.addError('The CRO has not been completely fulfiled yet in ERP system. Please try again later.');
                            }
                        }else{
                            rmaReq.addError('The CRO has not been fulfiled yet in ERP system. Please try again later.');
                        }
                    }else{
                        rmaReq.addError('The Sales Order (CRO) has not been updated on the RMA request.');
                    }
                }
                
                //Due Date Reminder for Quality Validation
                
                system.debug(RMAreq.Workflow_Stage__c+'***S*T**A**T**U**S***'+RMA_Constants.PEN_CQ_VAL);
                if(RMAreq.Workflow_Stage__c != NULL 
                        && RMAreq.Workflow_Stage__c.equalsIgnoreCase(RMA_Constants.PEN_CQ_VAL)){
                    if(trigger.oldMap.get(RMAreq.Id).Reminder_Quality_Approval_Due_Date__c == false && RMAreq.Reminder_Quality_Approval_Due_Date__c){
                        if(RMA_Utility.checkFab9or10(RMAreq.Fab__c)){mapStageRemVsRMA.put(RMAreq.Workflow_Stage__c+'-'+'0',RMAreq);BusinessCategorySet.add(RMAreq.Business_Category__c);}
                        else{rmaQltyReminderList.add(RMAreq);}
                    }
                    else if(trigger.oldMap.get(RMAreq.Id).Reminder_Quality_Approval_1_Day__c == false && RMAreq.Reminder_Quality_Approval_1_Day__c){
                        if(RMA_Utility.checkFab9or10(RMAreq.Fab__c)){mapStageRemVsRMA.put(RMAreq.Workflow_Stage__c+'-'+'1',RMAreq);BusinessCategorySet.add(RMAreq.Business_Category__c);}
                        else{rmaQltyReminder1List.add(RMAreq);}
                    }
                    else if(trigger.oldMap.get(RMAreq.Id).Reminder_Quality_Approval_2_Days__c == false && RMAreq.Reminder_Quality_Approval_2_Days__c){
                        if(RMA_Utility.checkFab9or10(RMAreq.Fab__c)){mapStageRemVsRMA.put(RMAreq.Workflow_Stage__c+'-'+'2',RMAreq);BusinessCategorySet.add(RMAreq.Business_Category__c);}
                        else{rmaQltyReminder2List.add(RMAreq);}
                    }
                    else if(trigger.oldMap.get(RMAreq.Id).Reminder_Quality_Approval_3_Days__c == false && RMAreq.Reminder_Quality_Approval_3_Days__c){
                        if(RMA_Utility.checkFab9or10(RMAreq.Fab__c)){mapStageRemVsRMA.put(RMAreq.Workflow_Stage__c+'-'+'3',RMAreq);BusinessCategorySet.add(RMAreq.Business_Category__c);}
                        else{rmaQltyReminder3List.add(RMAreq);}
                    }
                }
              
               
                //Reminders/Escalation for Finance Approval
                if(RMAreq.Workflow_Stage__c != NULL && RMAreq.Workflow_Stage__c.startsWith('Pending for Finance Approval')){
                    if(trigger.oldMap.get(RMAreq.Id).Reminder_Finance_Approval_Due__c == false && RMAreq.Reminder_Finance_Approval_Due__c){
                        if(RMA_Utility.checkFab9or10(RMAreq.Fab__c)){mapStageRemVsRMA.put(RMAreq.Workflow_Stage__c+'-'+'0',RMAreq);BusinessCategorySet.add(RMAreq.Business_Category__c);}
                        else {rmaFinanceReminderList.add(RMAreq);}
                    }
                    else if(trigger.oldMap.get(RMAreq.Id).Reminder_Finance_Approval_1_Day__c == false && RMAreq.Reminder_Finance_Approval_1_Day__c){
                        if(RMA_Utility.checkFab9or10(RMAreq.Fab__c)){mapStageRemVsRMA.put(RMAreq.Workflow_Stage__c+'-'+'1',RMAreq);BusinessCategorySet.add(RMAreq.Business_Category__c);}
                        else{rmaFinanceReminder1List.add(RMAreq);}
                    }
                    else if(trigger.oldMap.get(RMAreq.Id).Reminder_Finance_Approval_2_Days__c == false && RMAreq.Reminder_Finance_Approval_2_Days__c){
                        if(RMA_Utility.checkFab9or10(RMAreq.Fab__c)){mapStageRemVsRMA.put(RMAreq.Workflow_Stage__c+'-'+'2',RMAreq);BusinessCategorySet.add(RMAreq.Business_Category__c);}
                        else{rmaFinanceReminder2List.add(RMAreq);}
                    }
                    else if(trigger.oldMap.get(RMAreq.Id).Reminder_Finance_Approval_3_Days__c == false && RMAreq.Reminder_Finance_Approval_3_Days__c){
                        if(RMA_Utility.checkFab9or10(RMAreq.Fab__c)){mapStageRemVsRMA.put(RMAreq.Workflow_Stage__c+'-'+'3',RMAreq);BusinessCategorySet.add(RMAreq.Business_Category__c);}
                        else{rmaFinanceReminder3List.add(RMAreq);}
                    }
                }
                
                //Due Date Reminder for Fab Validation
                if(RMAreq.Workflow_Stage__c != NULL 
                        && (RMAreq.Workflow_Stage__c == RMA_Constants.PEN_FAB_VAL 
                            || RMAreq.Workflow_Stage__c == RMA_Constants.PEN_TNK_VAL 
                            || RMAreq.Workflow_Stage__c == RMA_Constants.PEN_NONFAB_VAL
                            || RMAreq.Workflow_Stage__c == RMA_Constants.PEN_PRD_ENG)){
                    if(trigger.oldMap.get(RMAreq.Id).Reminder_Fab_Validation_Due_Date__c == false && RMAreq.Reminder_Fab_Validation_Due_Date__c){
                        if(RMA_Utility.checkFab9or10(RMAreq.Fab__c)){mapStageRemVsRMA.put(RMAreq.Workflow_Stage__c+'-'+'0',RMAreq);BusinessCategorySet.add(RMAreq.Business_Category__c);}
                        else{rmaFabValidationReminderList.add(RMAreq);}
                    }
                    else if(trigger.oldMap.get(RMAreq.Id).Reminder_Fab_Validation_One_Day__c == false && RMAreq.Reminder_Fab_Validation_One_Day__c){
                        if(RMA_Utility.checkFab9or10(RMAreq.Fab__c)){mapStageRemVsRMA.put(RMAreq.Workflow_Stage__c+'-'+'1',RMAreq);BusinessCategorySet.add(RMAreq.Business_Category__c);}
                        else{rmaFabValidationReminder1List.add(RMAreq);}
                    }
                    else if(trigger.oldMap.get(RMAreq.Id).Reminder_Fab_Validation_2_Days__c == false && RMAreq.Reminder_Fab_Validation_2_Days__c){
                        if(RMA_Utility.checkFab9or10(RMAreq.Fab__c)){mapStageRemVsRMA.put(RMAreq.Workflow_Stage__c+'-'+'2',RMAreq);BusinessCategorySet.add(RMAreq.Business_Category__c);}
                        else{rmaFabValidationReminder2List.add(RMAreq);}
                    }
                    else if(trigger.oldMap.get(RMAreq.Id).Reminder_Fab_Validation_3_Days__c == false && RMAreq.Reminder_Fab_Validation_3_Days__c){
                        if(RMA_Utility.checkFab9or10(RMAreq.Fab__c)){mapStageRemVsRMA.put(RMAreq.Workflow_Stage__c+'-'+'3',RMAreq);BusinessCategorySet.add(RMAreq.Business_Category__c);}
                        else{rmaFabValidationReminder3List.add(RMAreq);}
                    }
                }
                
                //Reminder for Regional or Product Manager approval
                if(RMAreq.Workflow_Stage__c != NULL
                        && (RMAreq.Workflow_Stage__c == RMA_Constants.PEN_REG_DIR
                            || RMAreq.Workflow_Stage__c == RMA_Constants.PEN_REG_SVP
                            || (RMAreq.Is_SMPLSI__c 
                                && (RMAReq.Workflow_Stage__c == RMA_Constants.PEN_PRD_MGR
                                    || RMAreq.Workflow_Stage__c == RMA_Constants.PEN_PRD_DIR)))){
                    if(trigger.oldMap.get(RMAreq.Id).Reminder_Reg_Recommendation_Due_Date__c == false && RMAreq.Reminder_Reg_Recommendation_Due_Date__c){
                        if(RMA_Utility.checkFab9or10(RMAreq.Fab__c)){mapStageRemVsRMA.put(RMAreq.Workflow_Stage__c+'-'+'0',RMAreq);BusinessCategorySet.add(RMAreq.Business_Category__c);}
                        else{rmaRegReminderList.add(RMAreq);}
                    }
                    else if(trigger.oldMap.get(RMAreq.Id).Reminder_Reg_Recommendation_1_Day__c == false && RMAreq.Reminder_Reg_Recommendation_1_Day__c){
                        if(RMA_Utility.checkFab9or10(RMAreq.Fab__c)){mapStageRemVsRMA.put(RMAreq.Workflow_Stage__c+'-'+'1',RMAreq);BusinessCategorySet.add(RMAreq.Business_Category__c);}
                        else{rmaRegReminder1List.add(RMAreq);}
                    }
                    else if(trigger.oldMap.get(RMAreq.Id).Reminder_Reg_Recommendation_2_Days__c == false && RMAreq.Reminder_Reg_Recommendation_2_Days__c){
                        if(RMA_Utility.checkFab9or10(RMAreq.Fab__c)){mapStageRemVsRMA.put(RMAreq.Workflow_Stage__c+'-'+'2',RMAreq);BusinessCategorySet.add(RMAreq.Business_Category__c);}
                        else{rmaRegReminder2List.add(RMAreq);}
                    }
                    else if(trigger.oldMap.get(RMAreq.Id).Reminder_Reg_Recommendation_3_Days__c == false && RMAreq.Reminder_Reg_Recommendation_3_Days__c){
                        if(RMA_Utility.checkFab9or10(RMAreq.Fab__c)){mapStageRemVsRMA.put(RMAreq.Workflow_Stage__c+'-'+'3',RMAreq);BusinessCategorySet.add(RMAreq.Business_Category__c);}
                        else{rmaRegReminder3List.add(RMAreq);}
                    }
                }
                
                //Reminder for Acknowledgment
                if(RMAreq.Workflow_Stage__c != NULL
                        && (RMAreq.Workflow_Stage__c == RMA_Constants.PEN_REC_WAF
                            || RMAreq.Workflow_Stage__c == RMA_Constants.PEN_SCR_CRT
                            || RMAreq.Workflow_Stage__c == RMA_Constants.PEN_REC_SCR)){
                    if(trigger.oldMap.get(RMAreq.Id).Reminder_Acknowledgement_Due_Date__c == false && RMAreq.Reminder_Acknowledgement_Due_Date__c){
                        if(RMA_Utility.checkFab9or10(RMAreq.Fab__c)){mapStageRemVsRMA.put(RMAreq.Workflow_Stage__c+'-'+'0',RMAreq);BusinessCategorySet.add(RMAreq.Business_Category__c);}
                        else{rmaAckReminderList.add(RMAreq);}
                    }
                    else if(trigger.oldMap.get(RMAreq.Id).Reminder_Acknowledgement_1_Day__c == false && RMAreq.Reminder_Acknowledgement_1_Day__c){
                        if(RMA_Utility.checkFab9or10(RMAreq.Fab__c)){mapStageRemVsRMA.put(RMAreq.Workflow_Stage__c+'-'+'1',RMAreq);BusinessCategorySet.add(RMAreq.Business_Category__c);}
                        else{rmaAckReminder1List.add(RMAreq);}
                    }
                    else if(trigger.oldMap.get(RMAreq.Id).Reminder_Acknowledgement_2_Days__c == false && RMAreq.Reminder_Acknowledgement_2_Days__c){
                        if(RMA_Utility.checkFab9or10(RMAreq.Fab__c)){mapStageRemVsRMA.put(RMAreq.Workflow_Stage__c+'-'+'2',RMAreq);BusinessCategorySet.add(RMAreq.Business_Category__c);}
                        else{rmaAckReminder2List.add(RMAreq);}
                    }
                    else if(trigger.oldMap.get(RMAreq.Id).Reminder_Acknowledgement_3_Days__c == false && RMAreq.Reminder_Acknowledgement_3_Days__c){
                        if(RMA_Utility.checkFab9or10(RMAreq.Fab__c)){mapStageRemVsRMA.put(RMAreq.Workflow_Stage__c+'-'+'3',RMAreq);BusinessCategorySet.add(RMAreq.Business_Category__c);}
                        else{rmaAckReminder3List.add(RMAreq);}
                    }
                }
                
                //22 days After RMA Rejected
                if(Trigger.oldMap.get(RMAreq.Id).Twenty_Two_Days_after_RMA_Rejected__c != RMAreq.Twenty_Two_Days_after_RMA_Rejected__c 
                        && RMAreq.Twenty_Two_Days_after_RMA_Rejected__c 
                        && RMAreq.Status__c == RMA_Constants.REJECTED_STATUS
                        && !RMA_Utility.checkFab9or10(RMAreq.Fab__c)){
                    rmaRejectedList.add(RMAreq);
                }   
                
                //for Voided Forms
                if(Trigger.oldMap.get(RMAreq.Id).Status__c != RMAreq.Status__c 
                        && !RMA_Utility.checkFab9or10(RMAreq.Fab__c)
                        && RMAreq.Status__c == 'Voided'){
                    rmaVoidedList.add(RMAreq);
                }
                
                //for validation extension
                if(Trigger.OldMap.get(RMAreq.Id).Extension_Status__c != RMAreq.Extension_Status__c
                        && RMAreq.Extension_for_Fab_validation_required__c == true && RMAreq.Extension_Status__c == 'Requested'){
                    rmaForExtensionList.add(RMAreq);
                }
                //during initial submission
                if((Trigger.OldMap.get(RMAreq.Id).Status__c == RMA_Constants.DRAFT_STATUS 
                            || Trigger.OldMap.get(RMAreq.Id).Status__c == RMA_Constants.REJECTED_STATUS) 
                        && RMAreq.Status__c == RMA_Constants.SUBMITTED_STATUS){
                    if(RMAreq.Workflow_Stage__c.equalsIgnoreCase(RMA_Constants.PEN_CQ_VAL)){
                        rmaForCQList.add(RMAreq);
                    }
                }
                
                //to copy wafer ids to next stage
                if(RMA_Trigger_Handler.firstRun){
                    if(RMAreq.Workflow_Stage__c != Trigger.OldMap.get(RMAreq.Id).Workflow_Stage__c 
                            && Trigger.OldMap.get(RMAreq.Id).Workflow_Stage__c == RMA_Constants.PEN_CQ_VAL
                            && !RMAreq.Workflow_Stage__c.equalsIgnoreCase(RMA_Constants.REJECTED_RMA)){
                        rmaAfterQtyList.add(RMAreq);
                        if(RMAreq.RMA_Category__c != 'Business'){
                            rmaForCopyList.add(RMAreq);
                        }
                        if((RMAReq.Workflow_Stage__c == RMA_Constants.PEN_FAB_VAL 
                                    || RMAReq.Workflow_Stage__c == RMA_Constants.PEN_PRD_ENG
                                    || RMAReq.Workflow_Stage__c == RMA_Constants.PEN_TNK_VAL) 
                                && (Trigger.OldMap.get(RMAreq.Id).Workflow_Stage__c == RMA_Constants.RMA_RAISED
                                    || Trigger.OldMap.get(RMAreq.Id).Workflow_Stage__c == RMA_Constants.REJECTED_RMA)){
                            rmaForFabValidation.add(RMAreq);
                        }
                        if(!RMAreq.Acknowledged_Wafer_Return__c || !RMAreq.Acknowledged_Wafer_Scrap__c){
                            rmaForAcknList.add(RMAreq);
                        }
                    }
                }
                
                //Checking if the request is pending at Regional Approval or Finance Approval or Fab Validation (For Red RMA)
                if(Trigger.OldMap.get(RMAreq.Id).Workflow_Stage__c != NULL
                        && Trigger.OldMap.get(RMAreq.Id).Workflow_Stage__c != RMA_Constants.PEN_CQ_VAL 
                        && RMAreq.Workflow_Stage__c != Trigger.OldMap.get(RMAreq.Id).Workflow_Stage__c){
                    if(RMAreq.Workflow_Stage__c == RMA_Constants.PEN_REG_DIR 
                            || RMAreq.Workflow_Stage__c == RMA_Constants.PEN_PRD_MGR 
                            || RMAreq.Workflow_Stage__c == RMA_Constants.PEN_FIN_MGR){
                        rmaToInvokeList.add(RMAreq);        
                    }
                    if( RMA_Utility.checkFab9or10(RMAreq.Fab__c) && 
                        RMAreq.RMA_Category__c.equalsIgnoreCase('Business') && 
                        RMAreq.Workflow_Stage__c == RMA_Constants.PEN_LOG_APPR){
                        rmaLogisticsUnlock.add(RMAreq);
                    }
                }                
                
                //to copy wafer ids from CSR to Reg Validation
                if(Trigger.OldMap.get(RMAreq.Id).Workflow_Stage__c == RMA_Constants.PEN_CQ_VAL 
                        && RMAreq.RMA_Category__c == 'Business' 
                        && (RMAreq.Workflow_Stage__c == RMA_Constants.PEN_REG_DIR 
                            || RMAreq.Workflow_Stage__c == RMA_Constants.PEN_PRD_MGR
                            || RMAreq.Workflow_Stage__c == RMA_Constants.PEN_LOG_APPR
                            || RMAreq.Workflow_Stage__c == RMA_Constants.PEN_CSR_MGR_APPR)){
                    rmaForRegvalidationList.add(RMAreq);
                }
                
                //checking the status to provide Read/Edit access to validators and unlock RMA record
                if(RMAreq.Workflow_Stage__c != Trigger.OldMap.get(RMAreq.Id).Workflow_Stage__c 
                        && Trigger.oldMap.get(RMAreq.Id).Workflow_Stage__c != RMA_Constants.RMA_RAISED 
                        && Trigger.oldMap.get(RMAreq.Id).Workflow_Stage__c != RMA_Constants.REJECTED_RMA
                        && Trigger.oldMap.get(RMAreq.Id).Workflow_Stage__c != RMA_Constants.PEN_CQ_VAL
                        && (RMAreq.Workflow_Stage__c == RMA_Constants.PEN_FAB_VAL 
                            || RMAreq.Workflow_Stage__c == RMA_Constants.PEN_TNK_VAL 
                            || RMAreq.Workflow_Stage__c == RMA_Constants.PEN_NONFAB_VAL)){
                    rmaForAccessList.add(RMAreq);
                }
                
                //for new assignees            
                if((RMAreq.Notify_For_Fab__c != trigger.oldMap.get(RMAreq.Id).Notify_For_Fab__c && RMAreq.Workflow_Stage__c == RMA_Constants.PEN_FAB_VAL) ||
                        (RMAreq.Notify_For_Non_Fab__c != trigger.oldMap.get(RMAreq.Id).Notify_For_Non_Fab__c && RMAreq.Workflow_Stage__c == RMA_Constants.PEN_NONFAB_VAL) ||
                        (RMAreq.Notify_For_Turnkey__c != trigger.oldMap.get(RMAreq.Id).Notify_For_Turnkey__c && RMAreq.Workflow_Stage__c == RMA_Constants.PEN_TNK_VAL)){
                    rmaWithNewAssignee.add(RMAreq);
                }
                
                if(RMAreq.status__c != Trigger.OldMap.get(RMAreq.Id).Status__c && RMAreq.status__c == RMA_Constants.REJECTED_STATUS){
                    rejectedRMAsForAudit.add(RMAreq);
                    //if record is rejected by Finance
                    if(trigger.OldMap.get(RMAreq.Id).Workflow_Stage__c.startsWith('Pending for Finance') && RMAreq.Workflow_Stage__c == RMA_Constants.REJECTED_RMA
                            && !RMA_Utility.checkFab9or10(RMAreq.Fab__c)){
                        rmaRejectedByFinanceList.add(RMAreq);
                    }
                    
                    //rejected by Regional Approver
                    if((trigger.oldMap.get(RMAreq.Id).Workflow_Stage__c.startsWith('Pending for Regional') 
                                || trigger.oldMap.get(RMAreq.Id).Workflow_Stage__c.equalsIgnoreCase(RMA_Constants.PEN_PRD_MGR)
                                ||trigger.oldMap.get(RMAreq.Id).Workflow_Stage__c.equalsIgnoreCase(RMA_Constants.PEN_PRD_DIR))
                            && RMAreq.Workflow_Stage__c == RMA_Constants.REJECTED_RMA
                            && !RMA_Utility.checkFab9or10(RMAreq.Fab__c)){
                        rmaRejectedByReg.add(RMAreq);
                    }
                    
                    //rejected during tech validation
                    if((trigger.oldMap.get(RMAreq.Id).Workflow_Stage__c == RMA_Constants.PEN_FAB_VAL
                                || trigger.oldMap.get(RMAreq.Id).Workflow_Stage__c == RMA_Constants.PEN_TNK_VAL
                                || trigger.oldMap.get(RMAreq.Id).Workflow_Stage__c == RMA_Constants.PEN_NONFAB_VAL
                                || trigger.oldMap.get(RMAreq.Id).Workflow_Stage__c == RMA_Constants.PEN_PRD_ENG)
                            && !RMA_Utility.checkFab9or10(RMAreq.Fab__c)){
                        rmaRejectedByFab.add(RMAreq);
                    }
                    
                    //rejected by quality team
                    if(trigger.oldMap.get(RMAreq.Id).Workflow_Stage__c == RMA_Constants.PEN_CQ_VAL
                            && !RMA_Utility.checkFab9or10(RMAreq.Fab__c)){
                        rmaRejectedByQlty.add(RMAreq);
                    }
                }
                
                //if record is approved by Finance
                if(Trigger.oldMap.get(RMAreq.Id).Workflow_Stage__c.startsWith('Pending for Finance')){
                    if(RMAreq.Workflow_Stage__c == RMA_Constants.PEN_SO_ISS){
                        rmaApprovedByFinanceList.add(RMAreq.Id);
                        if(RMA_Utility.checkFab9or10(RMAreq.Fab__c)){
                            rmaForSOIssue.add(RMAreq);
                        }
                    }
                }
                //Nikhil-17-Feb-16--Logic for Rework process to initiate the callout once Acknowledged or Approved by Regional
                if(Trigger.oldMap.get(RMAreq.Id).Workflow_Stage__c.startsWith('Pending for Regional') ||
                        Trigger.oldMap.get(RMAreq.Id).Workflow_Stage__c.startsWith('Pending for Receipt') ){
                    if(RMAreq.Workflow_Stage__c == RMA_Constants.PEN_SO_ISS){
                        rmaApprovedByFinanceList.add(RMAreq.Id);
                        rmaForSOIssue.add(RMAreq);
                    }
                }
                
                //when RMA Closed
                if(RMA_Trigger_Handler.firstRun){
                    if(RMAreq.Workflow_Stage__c != NULL && RMAreq.Workflow_Stage__c == RMA_Constants.CLOSED_RMA && !RMA_Utility.checkFab9or10(RMAreq.Fab__c)){
                        if(trigger.oldMap.get(RMAreq.Id).Workflow_Stage__c == RMA_Constants.PEN_CN_ISS
                                || trigger.oldMap.get(RMAreq.Id).Workflow_Stage__c == RMA_Constants.PEN_SO_ISS){
                            rmaCNDNClosed.add(RMAreq);
                        }
                        else if(trigger.oldMap.get(RMAreq.Id).Workflow_Stage__c == RMA_Constants.PEN_REC_WAF
                                || trigger.oldMap.get(RMAreq.Id).Workflow_Stage__c == RMA_Constants.PEN_SCR_CRT
                                || trigger.oldMap.get(RMAreq.Id).Workflow_Stage__c == RMA_Constants.PEN_REC_SCR){
                            rmaFAClosed.add(RMAreq);
                        }
                        else if(trigger.oldMap.get(RMAreq.Id).Workflow_Stage__c .startsWith('Pending for Finance Approval')){
                            rmaFinClosed.add(RMAreq);
                        }
                    }
                }
                
                //when record goes for pending acknowledgement
                if(trigger.oldMap.get(RMAreq.Id).Workflow_Stage__c != RMAreq.Workflow_Stage__c &&
                        (RMAreq.Workflow_Stage__c == RMA_Constants.PEN_REC_WAF ||
                            RMAreq.Workflow_Stage__c == RMA_Constants.PEN_SCR_CRT ||
                            RMAreq.Workflow_Stage__c == RMA_Constants.PEN_REC_SCR)
                        && !RMA_Utility.checkFab9or10(RMAreq.Fab__c)
                        && RMAreq.RMA_Category__c != 'Failure Analysis'){
                    rmaWaferScrapList.add(RMAreq);
                }
                
                //when acknowledgement is completed or rejected
                if((trigger.oldMap.get(RMAreq.Id).Workflow_Stage__c == RMA_Constants.PEN_REC_WAF ||
                            trigger.oldMap.get(RMAreq.Id).Workflow_Stage__c == RMA_Constants.PEN_SCR_CRT ||
                            trigger.oldMap.get(RMAreq.Id).Workflow_Stage__c == RMA_Constants.PEN_REC_SCR) &&
                        (RMAreq.Workflow_Stage__c == RMA_Constants.REJECTED_RMA ||
                            RMAreq.Workflow_Stage__c == RMA_Constants.PEN_FIN_MGR)){
                    rmaAfterAcknList.add(RMAreq);
                }
                
                //for finance approval
                if(trigger.oldMap.get(RMAreq.Id).Workflow_Stage__c != RMAreq.Workflow_Stage__c 
                        && RMAreq.Workflow_Stage__c != NULL
                        && RMAreq.Workflow_Stage__c.startsWith('Pending for Finance')){
                    rmaForFinanceApproval.add(RMAreq);
                }
                
            }
            
            //after quality submission
            if(!rmaAfterQtyList.isEmpty()){
                RMA_Trigger_Handler.afterQualityApproval(rmaAfterQtyList);
                RMA_Trigger_Handler.firstRun = false;
                
                //NJain - 24Aug16 - Make a callout for SO Generation after Quality Approval.
                Timezone tzPST = Timezone.getTimeZone('America/Los_Angeles');
                Decimal OffSetValueNET = (tzPST.getOffset(DateTime.newInstance(System.now().Year(),
                System.now().Month(),
                System.now().Day(),
                0,0,0))
                );
                OffSetValueNET = OffSetValueNET * (-1) / 60 / 60 / 1000;
                //Prepare the Salesforcec Full URL
                string fullURL = system.Label.RMA_BaseURL + '/services/Soap/c/34.0/' + UserInfo.getOrganizationId().substring(0,15);
                //Initiate a callout to AIA for sending the approved RMA information to ERP
                List<String> lstRMAQualityApprovedIds = new List<String>();
                for(RMA__c rmaQualityApp : rmaAfterQtyList){
                    if(!RMA_Utility.checkFab9or10(rmaQualityApp.Fab__c) && rmaQualityApp.Compensation_Type__c == 'Credit with charged replacement'){
                        lstRMAQualityApprovedIds.add(rmaQualityApp.Id);
                    }
                }
                if(!lstRMAQualityApprovedIds.isEmpty()){
                    RMA_Integration.SOdetailsCallout(lstRMAQualityApprovedIds,UserInfo.getSessionId(),OffSetValueNET,fullURL,'Quality');
                }
            }
            
            //Closed after Finance Approval
            if(!rmaFinClosed.isEmpty()){
                RMA_Email_Notification_Helper.sendEmailNotification(rmaFinClosed,'Closed RMA after Finance Approval');
                RMA_Trigger_Handler.firstRun = false;
            }
            
            //Closed for FA Category
            if(!rmaFAClosed.isEmpty()){
                RMA_Email_Notification_Helper.sendEmailNotification(rmaFAClosed,'Closed RMA for FA');
                RMA_Trigger_Handler.firstRun = false;
            }
            
            //Closed after CN Issue
            if(!rmaCNDNClosed.isEmpty()){
                RMA_Email_Notification_Helper.sendEmailNotification(rmaCNDNClosed,'Closed after CN Issue');
                RMA_Trigger_Handler.firstRun = false;
            }
            
            //for Pending for SO Issue or Pending of CN issue
            if(!rmaForSOIssue.isEmpty()){
                RMA_Email_Notification_Helper.sendEmailNotification(rmaForSOIssue,'Pending for SO Issue');
            }
            
            if(!rmaForCNIssue.isEmpty()){
                RMA_Email_Notification_Helper.sendEmailNotification(rmaForCNIssue,'Pending for CN Issue');
            }
            
            //Copy RMA Cycle time data to Audit log when RMA is Rejected.
            if(!rejectedRMAsForAudit.isEmpty()){
                RMA_Trigger_Handler.logRejectedRMA(rejectedRMAsForAudit);
            }
            
            //when acknowledgement is completed or rejected
            if(!rmaAfterAcknList.isEmpty()){
                delete [select Id from RMA__Share where ParentId IN: rmaAfterAcknList and AccessLevel <> 'All' and rowCause != 'Rule' and rowCause != 'CSR__c'];
            }
            
            //For Pending For Regional Recommendation - Director
            if(!rmaRegSrVP.isEmpty()){
                delete [select Id from RMA__Share where ParentId IN: rmaRegSrVP and AccessLevel <> 'All' and rowCause != 'Rule' and rowCause != 'CSR__c' and rowCause != 'Acknowledgement__c'];
                List<RMA__c> rmaRegSrVpTemp = new List<RMA__c>();
                for(RMA__c RMAreq : rmaRegSrVP){
                    if(!RMA_Utility.checkFab9or10(RMAreq.Fab__c)){
                        rmaRegSrVpTemp.add(RMAreq);
                    }
                }
                if(!rmaRegSrVpTemp.isEmpty()){
                    RMA_Email_Notification_Helper.sendEmailNotification(rmaRegSrVpTemp,'Pending for Regional Approval - Snr. VP');
                }
                RMA_Trigger_Handler.provideAccess(rmaRegSrVP);
            }
            
            if(!rmaWaferScrapList.isEmpty()){
                RMA_Email_Notification_Helper.sendEmailNotification(rmaWaferScrapList,'Pending for Acknowledgement');
            }
            
            //for Finance Approval
            if(!rmaForFinanceApproval.isEmpty()){
                delete [select Id from RMA__Share where ParentId IN: rmaForFinanceApproval and AccessLevel <> 'All' and rowCause != 'Rule' and rowCause != 'CSR__c']; 
                List<RMA__c> rmaForFinanceApprovalTemp = new List<RMA__c>();
                for(RMA__c RMAreq : rmaForFinanceApproval){
                    if(!RMA_Utility.checkFab9or10(RMAreq.Fab__c)){
                        rmaForFinanceApprovalTemp.add(RMAreq);
                    }
                }
                if(!rmaForFinanceApprovalTemp.isEmpty()){
                    RMA_Email_Notification_Helper.sendEmailNotification(rmaForFinanceApprovalTemp,'Pending Finance Approval');
                }
                RMA_Trigger_Handler.provideAccess(rmaForFinanceApproval);
            }
            
            //for production director
            if(!rmaProdDirAppr.isEmpty()){
                delete [select Id from RMA__Share where ParentId IN: rmaProdDirAppr and AccessLevel <> 'All' and rowCause != 'Rule' and rowCause != 'CSR__c' and rowCause != 'Acknowledgement__c'];
                List<RMA__c> rmaProdDirApprTemp = new List<RMA__c>();
                for(RMA__c RMAreq : rmaProdDirAppr){
                    if(!RMA_Utility.checkFab9or10(RMAreq.Fab__c)){
                        rmaProdDirApprTemp.add(RMAreq);
                    }
                }
                if(!rmaProdDirApprTemp.isEmpty()){
                    RMA_Email_Notification_Helper.sendEmailNotification(rmaProdDirApprTemp,'Product Engineering - Director Approval');
                }
                RMA_Trigger_Handler.provideAccess(rmaProdDirAppr);
            }
            
            //Rejected by Regional Approver
            if(!rmaRejectedByReg.isEmpty()){
                RMA_Email_Notification_Helper.sendEmailNotification(rmaRejectedByReg,'Regional Rejected');
                delete [select Id from RMA__Share where ParentId IN: rmaRejectedByReg and AccessLevel <> 'All' and rowCause != 'Rule' and rowCause != 'CSR__c'];
            }
            
            //for fab validation reminders
            if(!rmaFabValidationReminderList.isEmpty()){
                RMA_Email_Notification_Helper.sendReminderEmail(rmaFabValidationReminderList,'Fab Validation Due Date');
            }
            if(!rmaFabValidationReminder1List.isEmpty()){
                RMA_Email_Notification_Helper.sendReminderEmail(rmaFabValidationReminder1List,'Fab Validation Due 1 Day');
            }
            if(!rmaFabValidationReminder2List.isEmpty()){
                RMA_Email_Notification_Helper.sendReminderEmail(rmaFabValidationReminder2List,'Fab Validation Due 2 Days');
            }
            if(!rmaFabValidationReminder3List.isEmpty()){
                RMA_Email_Notification_Helper.sendReminderEmail(rmaFabValidationReminder3List,'Fab Validation Due 3 Days');
            }
            
            //for acknowledgement reminder
            if(!rmaAckReminderList.isEmpty()){
                RMA_Email_Notification_Helper.sendReminderEmail(rmaAckReminderList,'Ackn Due Date');
            }
            if(!rmaAckReminder1List.isEmpty()){
                RMA_Email_Notification_Helper.sendReminderEmail(rmaAckReminder1List,'Ackn Due 1 Day');
            }
            if(!rmaAckReminder2List.isEmpty()){
                RMA_Email_Notification_Helper.sendReminderEmail(rmaAckReminder2List,'Ackn Due 2 Days');
            }
            if(!rmaAckReminder3List.isEmpty()){
                RMA_Email_Notification_Helper.sendReminderEmail(rmaAckReminder3List,'Ackn Due 3 Days');
            }
            
            //for Regional or Product Manager reminder
            if(!rmaRegReminderList.isEmpty()){
                RMA_Email_Notification_Helper.sendReminderEmail(rmaRegReminderList,'Regional Reminder Due Date');   
            }
            if(!rmaRegReminder1List.isEmpty()){
                RMA_Email_Notification_Helper.sendReminderEmail(rmaRegReminder1List,'Regional Reminder 1 Day'); 
            }
            if(!rmaRegReminder2List.isEmpty()){
                RMA_Email_Notification_Helper.sendReminderEmail(rmaRegReminder2List,'Regional Reminder 2 Days');    
            }
            if(!rmaRegReminder3List.isEmpty()){
                RMA_Email_Notification_Helper.sendReminderEmail(rmaRegReminder3List,'Regional Reminder 3 Days');    
            }
            
            //Reminder/Escalation for Finance Approval
            if(!rmaFinanceReminderList.isEmpty()){
                RMA_Email_Notification_Helper.sendReminderEmail(rmaFinanceReminderList,'Finance Reminder Due Date');    
            }
            if(!rmaFinanceReminder1List.isEmpty()){
                RMA_Email_Notification_Helper.sendReminderEmail(rmaFinanceReminder1List,'Finance Reminder 1 Day');  
            }
            if(!rmaFinanceReminder2List.isEmpty()){
                RMA_Email_Notification_Helper.sendReminderEmail(rmaFinanceReminder2List,'Finance Reminder 2 Days'); 
            }
            if(!rmaFinanceReminder3List.isEmpty()){
                RMA_Email_Notification_Helper.sendReminderEmail(rmaFinanceReminder3List,'Finance Reminder 3 Days'); 
            }
            
            //rejected by quality team
            if(!rmaRejectedByQlty.isEmpty()){
                RMA_Email_Notification_Helper.sendEmailNotification(rmaRejectedByQlty,'Quality Rejected');
            }
            
            //rejected during fab validation
            if(!rmaRejectedByFab.isEmpty()){
                RMA_Email_Notification_Helper.sendEmailNotification(rmaRejectedByFab,'Tech Validation Rejected');
                delete [select Id from RMA__Share where ParentId IN: rmaRejectedByFab and AccessLevel <> 'All' and rowCause != 'Rule' and rowCause != 'CSR__c'];
            }
            
            //22 days After RMA Rejected
            if(!rmaRejectedList.isEmpty()){
                RMA_Email_Notification_Helper.sendReminderEmail(rmaRejectedList,'Rejected Reminder 22 days');
            }
            
            //send Email for Fab Validation
            if(!rmaForFabValidation.isEmpty()){
                RMA_Trigger_Handler.provideAccess(rmaForFabValidation);
            }
            
            //Invoking the methiod to Copy the wafer Ids to the next level on Approval
            if(!rmaForCopyList.isEmpty()){
                RMA_Trigger_Handler.copyWaferIds(rmaForCopyList,'DraftToFab');
            }
            
            //Invoking the method to initiate the approval request for Regional or Finance Approval
            if(!rmaToInvokeList.isEmpty()){
                RMA_Trigger_Handler.invokeApprovalProcess(rmaToInvokeList);
            }
            
            //Invoking approval process for Fab Validation for FAB 9 or 10
            if(!rmaRedForFabValidation.isEmpty()){
                RMA_Trigger_Handler.invokeApprovalProcess(rmaRedForFabValidation);
            }
            
            //Invoking approval prcess for Logistics/CSR Manager approval for Fab 9 or 10
            if(!rmaRedForRegValidation.isEmpty()){
                RMA_Trigger_Handler.invokeApprovalProcess(rmaRedForRegValidation);
            }
            
            //Invoking a method for providing Read/Write access to the Users added to the request
            if(!rmaForAccessList.isEmpty()){
                delete [select Id from RMA__Share where ParentId IN: rmaForAccessList and AccessLevel <> 'All' and rowCause != 'Rule' and rowCause != 'CSR__c' and rowCause != 'Acknowledgement__c'];
                RMA_Trigger_Handler.provideAccess(rmaForAccessList);
                List<RMA__c> rmaForAccessListTemp = new List<RMA__c>();
                for(RMA__c RMAreq : rmaForAccessList){
                    if(!RMA_Utility.checkFab9or10(RMAreq.Fab__c)){
                        rmaForAccessListTemp.add(RMAreq);
                    }
                }
                if(!rmaForAccessListTemp.isEmpty()){
                    RMA_Email_Notification_Helper.sendEmailNotification(rmaForAccessListTemp,'Pending for Technical Validation');
                }
            }
            
            if(!rmaWithNewAssignee.isEmpty()){
                delete [select Id from RMA__Share where ParentId IN: rmaWithNewAssignee and AccessLevel <> 'All' and rowCause != 'Rule' and rowCause != 'CSR__c' and rowCause != 'Acknowledgement__c'];
                RMA_Trigger_Handler.provideAccess(rmaWithNewAssignee);
            }
            
            //to copy wafer ids from CSR to Reg Validation
            if(!rmaForRegvalidationList.isEmpty()){
                RMA_Trigger_Handler.copyWaferIds(rmaForRegvalidationList,'DraftToReg');
                RMA_Trigger_Handler.provideAccess(rmaForRegvalidationList);
            }
            
            //Invoking method to Unlock the records after the approval request in initiated
            if(!rmaToInvokeList.isEmpty() || !rmaForAccessList.isEmpty() || !rmaForRegvalidationList.isEmpty() || !rmaLogisticsUnlock.isEmpty()
                || !rmaForFabValidation.isEmpty() || !rmaForFinanceApproval.isEmpty() || !rmaProdDirAppr.isEmpty()
                || !rmaRedForFabValidation.isEmpty() || !rmaRedForRegValidation.isEmpty() || !rmaForCQList.isEmpty()){
                List<RMA__c> rmaForUnlocking = new List<RMA__c>();
                List<Id> lstRMAids = new List<Id>();
                rmaForUnlocking.addAll(rmaToInvokeList);
                rmaForUnlocking.addAll(rmaForAccessList);
                rmaForUnlocking.addAll(rmaForRegvalidationList);
                rmaForUnlocking.addAll(rmaForFabValidation);
                rmaForUnlocking.addAll(rmaForFinanceApproval);
                rmaForUnlocking.addAll(rmaProdDirAppr);
                rmaForUnlocking.addAll(rmaRedForFabValidation);
                rmaForUnlocking.addAll(rmaRedForRegValidation);
                rmaForUnlocking.addAll(rmaForCQList);
                rmaForUnlocking.addAll(rmaLogisticsUnlock);
                for(RMA__c rmaRec: rmaForUnlocking){
                    lstRMAids.add(rmaRec.Id);
                }
                RMA_Trigger_Handler.unlockRecords(lstRMAids);
            }
            /*
            //Copy RMA Cycle time data to Audit log when RMA is Rejected.
            if(!rejectedRMAsForAudit.isEmpty()){
                RMA_Trigger_Handler.logRejectedRMA(rejectedRMAsForAudit);
            }            
            */
            //for records rejected by Finance
            if(!rmaRejectedByFinanceList.isEmpty()){
                RMA_Email_Notification_Helper.sendEmailNotification(rmaRejectedByFinanceList,'Finance Rejected');
                delete [select Id from RMA__Share where ParentId IN: rmaRejectedByFinanceList and AccessLevel <> 'All' and rowCause != 'Rule' and rowCause != 'CSR__c'];
            }
            
            //if record is approved by Finance
            if(!rmaApprovedByFinanceList.isEmpty()){
                
                //Check for any duplicates before sending to ERP
                List<RMA_Return_Invoice__c> lstRMAInvoices = [SELECT Id,RMA__c,Wafer_Die_Unit_Price__c,Wafer_Id_CSR_Submission__c,Wafer_Id_Fab_Validated__c,
                                            Adjusted_Unit_Price__c,Total_Price__c,Wafer_Quantity__c,Wafer_Id_Regional_Personnel_Recommended__c,
                                            Invoice_Number__c,Lot_Number__c,Name,Scrap_Limit__c,Wafer_Yield__c,RMA__r.Name,Total_Price_FAB_Validation__c,
                                            Wafer_Id_Fab_In_Validated__c,Total_Wfr_Qty_after_validation__c,Total_Price_Final__c,Invoice_Lot_Combination__c,
                                            Wafer_Id_Regional_Personnel_Not_Rec__c,Final_RMA_Wfr_Qty_To_Issue_CN_SO__c,Die_Quantity__c,GDPW__c,
                                            RMA__r.Workflow_Stage__c,Bill_Quantity__c,RMA_By__c,Current_Die_Quantity__c,Fab_Group__c,Current_Module_Quantity__c,
                                            Wafer_Id_Fab_9_10_Regional_Validated__c,Wafer_Id_Fab_9_10_Fab_Validated__c,Wafer_Id_Fab_9_10_CSR_Submission__c
                                            FROM RMA_Return_Invoice__c 
                                            WHERE RMA__c in :rmaApprovedByFinanceList];
                
                RMA_ReturnInvoiceTrigger_Helper.checkDuplicate(lstRMAInvoices);            
                
                //Initiate request if no error found.
                Timezone tzPST = Timezone.getTimeZone('America/Los_Angeles');
                Decimal OffSetValueNET = (/*tzGMT.getOffset(DateTime.newInstance(System.now().Year(),
                                                                            System.now().Month(),
                                                                            System.now().Day(),
                                                                            0,0,0)) - */
                tzPST.getOffset(DateTime.newInstance(System.now().Year(),
                System.now().Month(),
                System.now().Day(),
                0,0,0))
                );
                OffSetValueNET = OffSetValueNET * (-1) / 60 / 60 / 1000;
                //Prepare the Salesforcec Full URL
                string fullURL = system.Label.RMA_BaseURL + '/services/Soap/c/34.0/' + UserInfo.getOrganizationId().substring(0,15);
                //Initiate a callout to AIA for sending the approved RMA information to ERP
                RMA_Integration.SOdetailsCallout(rmaApprovedByFinanceList,UserInfo.getSessionId(),OffSetValueNET,fullURL,'Finance');
            }
            
            //when record goes for pending acknowledgement
            if(!rmaForAcknList.isEmpty()){
                RMA_Trigger_Handler.accessForAckn(rmaForAcknList);
            }
            
            //for validation extension
            if(!rmaForExtensionList.isEmpty()){
                RMA_Email_Notification_Helper.sendEmailNotification(rmaForExtensionList,'Request Extension');
            }
            
            //For Voided Form
            if(!rmaVoidedList.isEmpty()){
                RMA_Email_Notification_Helper.sendEmailNotification(rmaVoidedList,'Void');
            }
            
            //NJain - 29-Jun-16 - Invoking the new method for sending Emails.
            List<RMA__c> lstTriggerNew = new List<RMA__c>();
            for(RMA__C rmaForEmail : Trigger.New){
                if(rmaForEmail.Workflow_Stage__c == RMA_Constants.PEN_CQ_VAL){
                    if(checkRecursive.runOnce()){
                        lstTriggerNew.add(rmaForEmail);
                    }
                }else{
                    lstTriggerNew.add(rmaForEmail);
                }
            }
            RMA_GenericEmailNotifier.sendEmailNotification(lstTriggerNew,Trigger.OldMap);
            
            //NJain - 15-Jul-16 - Invoking method for sending Reminder/Escalations
            //SNAIR - 10-Aug-16 - Added check whether map is empty
            if(!mapStageRemVsRMA.isEmpty()){
                RMA_GenericEmailNotifier.sendEmailReminders(mapStageRemVsRMA,BusinessCategorySet);
            }
        }
        
        if(Trigger.isBefore && Trigger.isInsert){
            //Validate field before insert
            RMA_Field_Validation_Helper.validateBeforeInsert(trigger.new);
            
            //Populate the Region Head and Sales SVP on creation of RMA request based on the Customer selection
            RMA_Trigger_Handler.populateRegionalHeadDetails(trigger.new);
            
            //Populate the Cycle time from the RMA Cycle Time custom metadata
            List<RMA__c> lstRMA = new List<RMA__c>();
            for(RMA__c rmaRec: Trigger.new){
                if(rmaRec.RMA_Category__c != NULL && RMA_Utility.checkFab9or10(rmaRec.Fab__c)){
                    lstRMA.add(rmaRec);
                }
            }
            
            if(!lstRMA.isEmpty()){
                RMA_Trigger_Handler.populateCycleTimeForFab9and10(lstRMA);
            }
        }
        
        if(Trigger.isBefore && Trigger.isUpdate){
            Map<id, RMA__c> TriggerNewToProcess = new Map<id, RMA__c>();
            List<RMA__c> RMAList = new List<RMA__c>();
            List<RMA__c> rmaRedList = new List<RMA__c>();
            
            for(RMA__c rmaRec: Trigger.New){
                //Populate the Cycle time from the RMA Cycle Time custom metadata
                if(rmaRec.RMA_Category__c != Trigger.oldMap.get(rmaRec.Id).RMA_Category__c && 
                        (rmaRec.Status__c == RMA_Constants.DRAFT_STATUS || rmaRec.Status__c == RMA_Constants.REJECTED_STATUS)){
                    TriggerNewToProcess.put(rmaRec.id, rmaRec);
                }
                
                //to check before approving technical validation
                if((trigger.oldMap.get(rmaRec.Id).Workflow_Stage__c == RMA_Constants.PEN_FAB_VAL 
                            || trigger.oldMap.get(rmaRec.Id).Workflow_Stage__c == RMA_Constants.PEN_TNK_VAL
                            || trigger.oldMap.get(rmaRec.Id).Workflow_Stage__c == RMA_Constants.PEN_NONFAB_VAL
                            || trigger.oldMap.get(rmaRec.Id).Workflow_Stage__c == RMA_Constants.PEN_PRD_ENG)
                        && (rmaRec.Workflow_Stage__c == RMA_Constants.PEN_REG_DIR || rmaRec.Workflow_Stage__c == RMA_Constants.PEN_PRD_MGR)){
                    RMAList.add(rmaRec);
                }
                
                //to check fields before Customer Quality Validation
                if(RMA_Utility.checkFab9or10(rmaRec.Fab__c)
                        && trigger.oldMap.get(rmaRec.Id).Workflow_Stage__c != rmaRec.Workflow_Stage__c
                        && trigger.oldMap.get(rmaRec.Id).Workflow_Stage__c.equalsIgnoreCase(RMA_Constants.PEN_CQ_VAL)
                        && !rmaRec.Workflow_Stage__c.equalsIgnoreCase(RMA_Constants.REJECTED_RMA)){
                    rmaRedList.add(rmaRec);
                }
                
            }
            
            if(!TriggerNewToProcess.isEmpty()){
                RMA_Trigger_Handler.populateCycleTime(TriggerNewToProcess);
            }
            if(!RMAList.isEmpty()){
                RMA_Field_Validation_Helper.validateBeforeRegValidation(RMAList);
            }
            if(!rmaRedList.isEmpty()){
                RMA_Field_Validation_Helper.validateOnCustomerQualityApproval(rmaRedList);
            }
            
        }
        
        if(trigger.isAfter && trigger.isInsert){
            RMA_Trigger_Handler.afterInsert(trigger.new);
        }
        
    }
}