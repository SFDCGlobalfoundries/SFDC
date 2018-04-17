/**
* Company       :   Cognizant Technologies PTE Ltd.
* Description   :   Helper class for the Apex Trigger: RMA_ReturnInvoiceTrigger.
* History       :   

        Initials        Date          Description
-----------------------------------------------------------------------------------------
        Nikhil Jain    09-Sep-15      Created the Class
**/

public class RMA_ReturnInvoiceTrigger_Helper{
    
    public static Map<String,boolean> checkDuplicate(List<RMA_Return_Invoice__c> TriggerNew){
        Map<String,String> mapInvWafer = new Map<String,String>();
        Map<String,List<RMA_Return_Invoice__c>> mapRMAExisting = new Map<String,List<RMA_Return_Invoice__c>>();
        Map<String,List<RMA_DNCN__c>> mapDNCNExisting = new Map<String,List<RMA_DNCN__c>>();
        Map<String,Boolean> mapErrorStatus = new Map<String,Boolean>();        
        
        for(RMA_Return_Invoice__c rmaRI : TriggerNew){
            mapInvWafer.put(rmaRI.Id, rmaRI.Invoice_Number__c + ':' + rmaRI.Lot_Number__c);
        }            
        
        Map<String,RMA_Return_Invoice__c> mapRMAvsStage = new Map<String,RMA_Return_Invoice__c>(
                                                                [SELECT Id,RMA__r.Workflow_Stage__c,Invoice__r.Item_Type__c
                                                                    FROM RMA_Return_Invoice__c
                                                                    WHERE Id in :TriggerNew]);
        
        //++CHECK DUPLICATE AGAINST THE EXISTING RMA FOR SAME INVOICE-LOT ID-WAFER ID COMBINATION
        //Preparing map for the existing Return Invoices for the Lot Number and Invoice Number being Inserted/Updated
        for(RMA_Return_Invoice__c rmaRIexisting: [SELECT Id,Wafer_Id_CSR_Submission__c, Wafer_Id_Fab_Validated__c, RMA__r.RMA_Category__c,Fab_Group__c,
                                                    Wafer_Id_Regional_Personnel_Recommended__c,RMA__r.Workflow_Stage__c,Invoice__r.Item_type__c,
                                                    Unique_RMA_ReturnInvoice__c,Invoice_Lot_Combination__c,RMA__r.name ,RMA__c, RMA_BY__c,
                                                    Wafer_Id_Fab_9_10_CSR_Submission__c,Wafer_Id_Fab_9_10_Fab_Validated__c,Wafer_Id_Fab_9_10_Regional_Validated__c
                                                  FROM RMA_Return_Invoice__c 
                                                  WHERE Invoice_Lot_Combination__c in :mapInvWafer.values()
                                                    AND Id NOT IN :TriggerNew
                                                    AND RMA__r.Status__c in ('Submitted','Approved')
                                                    AND RMA__r.RMA_Category__c NOT IN ('Rework','Failure Analysis')
                                                    AND RMA__r.ReasonCode__c NOT IN ('R25','R30')]){
            
            if(!mapRMAExisting.containsKey(rmaRIexisting.Invoice_Lot_Combination__c)){
                mapRMAExisting.put(rmaRIexisting.Invoice_Lot_Combination__c,new List<RMA_Return_Invoice__c>());
            }
            mapRMAExisting.get(rmaRIexisting.Invoice_Lot_Combination__c).add(rmaRIexisting);
        }
        
        //Checking for the Wafers that are already associated in the existing Return Invoices
        map<String,List<String>> mapLotWaferNotInserted   = new Map<String,List<String>>();
        map<String,RMA_Return_Invoice__c> mapLotInvAndRMA = new Map<String,RMA_Return_Invoice__c>();
        map<String,RMA_Return_Invoice__c> mapLotInvAndRMAdie = new Map<String,RMA_Return_Invoice__c>();
        map<String,RMA_Return_Invoice__c> mapLotInvAndExistingRMA = new Map<String,RMA_Return_Invoice__c>();
        map<String,RMA_Return_Invoice__c> mapLotInvAndExistingRMAdie = new Map<String,RMA_Return_Invoice__c>();
        
        string tempWaferId;
        string tempToCheckWaferId;
        string workflowStage;
        for(RMA_Return_Invoice__c rmaToCheck: TriggerNew){
            tempToCheckWaferId = '';
            workflowStage = mapRMAvsStage.get(rmaToCheck.Id) != NULL ? mapRMAvsStage.get(rmaToCheck.Id).RMA__r.Workflow_Stage__c:'';
            
            if(mapRMAExisting != NULL && mapRMAExisting.get(rmaToCheck.Invoice_Number__c + ':' + rmaToCheck.Lot_Number__c) != NULL){
                if( workflowStage == 'RMA Raised' ||
                    workflowStage == 'Rejected RMA' || 
                    workflowStage == '' 
                ){
                    if(!RMA_Utility.checkFab9or10(rmaToCheck.Fab_Group__c)){
                        tempToCheckWaferId = rmaToCheck.Wafer_Id_CSR_Submission__c;
                    }else{
                        tempToCheckWaferId = rmaToCheck.Wafer_Id_Fab_9_10_CSR_Submission__c;
                    }
                }else if(workflowStage == RMA_Constants.PEN_CQ_VAL){
                    if(!RMA_Utility.checkFab9or10(rmaToCheck.Fab_Group__c)){
                        tempToCheckWaferId = rmaToCheck.Wafer_Id_CSR_Submission__c;
                    }else{
                        tempToCheckWaferId = rmaToCheck.Wafer_Id_Fab_9_10_CSR_Submission__c;
                    }
                }else if(
                    workflowStage == RMA_Constants.PEN_FAB_VAL ||
                    workflowStage == RMA_Constants.PEN_TNK_VAL ||
                    workflowStage == RMA_Constants.PEN_NONFAB_VAL ||
                    workflowStage == RMA_Constants.PEN_PRD_ENG
                ){
                    if(!RMA_Utility.checkFab9or10(rmaToCheck.Fab_Group__c)){
                        tempToCheckWaferId = rmaToCheck.Wafer_Id_Fab_Validated__c;
                    }else{
                        tempToCheckWaferId = rmaToCheck.Wafer_Id_Fab_9_10_Fab_Validated__c;
                    }
                }else{
                    if(!RMA_Utility.checkFab9or10(rmaToCheck.Fab_Group__c)){
                        tempToCheckWaferId = rmaToCheck.Wafer_Id_Regional_Personnel_Recommended__c;
                    }else{
                        tempToCheckWaferId = rmaToCheck.Wafer_Id_Fab_9_10_Regional_Validated__c;
                    }
                }
                for(RMA_Return_Invoice__c rmaExisting: mapRMAExisting.get(rmaToCheck.Invoice_Number__c + ':' + rmaToCheck.Lot_Number__c)){
                    tempWaferId = '';
                    if( 
                        rmaExisting.RMA__r.Workflow_Stage__c == 'RMA Raised' ||
                        rmaExisting.RMA__r.Workflow_Stage__c == 'Rejected RMA' || 
                        rmaExisting.RMA__r.Workflow_Stage__c == ''
                    ){
                        if(!RMA_Utility.checkFab9or10(rmaExisting.Fab_Group__c)){
                            tempWaferId = rmaExisting.Wafer_Id_CSR_Submission__c;
                        }else{
                            tempWaferId = rmaExisting.Wafer_Id_Fab_9_10_CSR_Submission__c;
                        }
                    }else if(rmaExisting.RMA__r.Workflow_Stage__c == RMA_Constants.PEN_CQ_VAL){
                        if(!RMA_Utility.checkFab9or10(rmaExisting.Fab_Group__c)){
                            tempWaferId = rmaExisting.Wafer_Id_CSR_Submission__c;
                        }else{
                            tempWaferId = rmaExisting.Wafer_Id_Fab_9_10_CSR_Submission__c;
                        }
                    }else if(
                        rmaExisting.RMA__r.Workflow_Stage__c == RMA_Constants.PEN_FAB_VAL || 
                        rmaExisting.RMA__r.Workflow_Stage__c == RMA_Constants.PEN_TNK_VAL ||
                        rmaExisting.RMA__r.Workflow_Stage__c == RMA_Constants.PEN_NONFAB_VAL ||
                        rmaExisting.RMA__r.Workflow_Stage__c == RMA_Constants.PEN_PRD_ENG
                    ){
                        if(!RMA_Utility.checkFab9or10(rmaExisting.Fab_Group__c)){
                            tempWaferId = rmaExisting.Wafer_Id_Fab_Validated__c;
                        }else{
                            tempWaferId = rmaExisting.Wafer_Id_Fab_9_10_Fab_Validated__c;
                        }
                    }else if(rmaExisting.RMA__r.RMA_Category__c == 'Failure Analysis'){
                        if(!RMA_Utility.checkFab9or10(rmaExisting.Fab_Group__c)){
                            tempWaferId = rmaExisting.Wafer_Id_CSR_Submission__c;
                        }else{
                            tempWaferId = rmaExisting.Wafer_Id_Fab_9_10_CSR_Submission__c;
                        }
                    }else{
                        if(!RMA_Utility.checkFab9or10(rmaExisting.Fab_Group__c)){
                            tempWaferId = rmaExisting.Wafer_Id_Regional_Personnel_Recommended__c;
                        }else{
                            tempWaferId = rmaExisting.Wafer_Id_Fab_9_10_Regional_Validated__c;
                        }
                    }
                    
                    tempWaferId = '; ' + tempWaferId + ';' ;
                    if(tempWaferId != NULL){
                        tempWaferId = tempWaferId.replaceAll(' ','');
                    }
                    if(tempToCheckWaferId != NULL){
                        tempToCheckWaferId = tempToCheckWaferId.replaceAll(' ','');
                    }
                    
                    if( (rmaToCheck.RMA_By__c != 'Die') || 
                        (mapRMAvsStage.get(rmaToCheck.Id) != NULL && mapRMAvsStage.get(rmaToCheck.Id).Invoice__r.Item_Type__c == 'SD')
                    ){
                        if(tempToCheckWaferId != NULL && (rmaExisting.RMA_By__c != 'Die' || rmaExisting.Invoice__r.Item_type__c == 'SD')){
                            for(String waferId: tempToCheckWaferId.split(';')){
                                if(tempWaferId.contains(';'+ waferId.trim() + ';')){
                                    if(!mapLotWaferNotInserted.containsKey(rmaToCheck.Lot_Number__c + '--' + rmaExisting.RMA__c)){
                                        mapLotWaferNotInserted.put(rmaToCheck.Lot_Number__c + '--' + rmaExisting.RMA__c, new List<String>());
                                    }
                                    mapLotWaferNotInserted.get (rmaToCheck.Lot_Number__c + '--' + rmaExisting.RMA__c).add(waferId);
                                    mapLotInvAndRMA.put        (rmaToCheck.Lot_Number__c + '--' + rmaExisting.RMA__c,rmaToCheck);
                                    mapLotInvAndExistingRMA.put(rmaToCheck.Lot_Number__c + '--' + rmaExisting.RMA__c,rmaExisting);
                                }
                            }
                        }
                    }
                    if(rmaToCheck.RMA_By__c == 'Die'){
                        if(!mapLotWaferNotInserted.containsKey(rmaToCheck.Lot_Number__c + '--' + rmaExisting.RMA__c)){
                            mapLotWaferNotInserted.put(rmaToCheck.Lot_Number__c + '--' + rmaExisting.RMA__c, new List<String>());
                        }
                        mapLotInvAndRMAdie.put        (rmaToCheck.Lot_Number__c + '--' + rmaExisting.RMA__c,rmaToCheck);
                        mapLotInvAndExistingRMAdie.put(rmaToCheck.Lot_Number__c + '--' + rmaExisting.RMA__c,rmaExisting);
                    }
                    
                }
            }
        }
        //Displaying the error message for the erroneous records along with the Hyperlink to the duplicate record.
        for(String LotInvoiceStr: mapLotInvAndRMA.keySet()){
            if(ApexPages.currentPage() != null){
                mapErrorStatus.put('WaferExists',TRUE);
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,
                    (!mapLotWaferNotInserted.get(LotInvoiceStr).isEmpty() ? ' Wafer Id:'+mapLotWaferNotInserted.get(LotInvoiceStr):'Selected Dies') + 
                    ' under Lot #:'+ LotInvoiceStr.split('--')[0] + ' has already been entered in the '+ 
                    '<a href="/'+mapLotInvAndExistingRMA.get(LotInvoiceStr).RMA__c+'">'+
                    mapLotInvAndExistingRMA.get(LotInvoiceStr).RMA__r.name+'</a>.'));
            }
                mapLotInvAndRMA.get(LotInvoiceStr).addError(
                    (!mapLotWaferNotInserted.get(LotInvoiceStr).isEmpty() ? ' Wafer Id:'+mapLotWaferNotInserted.get(LotInvoiceStr):'Selected Dies') + 
                    ' under Lot #:'+ LotInvoiceStr.split('--')[0] + ' has already been entered in the '+ 
                    '<a href="/'+mapLotInvAndExistingRMA.get(LotInvoiceStr).RMA__c+'">'+
                    mapLotInvAndExistingRMA.get(LotInvoiceStr).RMA__r.name+'</a>.');
        }
        for(String LotInvoiceStr2: mapLotInvAndRMAdie.keySet()){
            if(ApexPages.currentPage() != null){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,
                    'Selected Dies under Lot #:'+ LotInvoiceStr2.split('--')[0] + ' has already been entered in the '+ 
                    '<a href="/'+mapLotInvAndExistingRMAdie.get(LotInvoiceStr2).RMA__c+'">'+
                    mapLotInvAndExistingRMAdie.get(LotInvoiceStr2).RMA__r.name+'</a>.'+
                    ' Please validate its inclusion before submitting the RMA for Approval.'
                ));
            }
        }
        //--CHECK DUPLICATE AGAINST THE EXISTING RMA FOR SAME INVOICE-LOT ID-WAFER ID COMBINATION
        
        
        //++CHECK DUPLICATE AGAINST THE EXISTING DN/CN TABLE FOR SAME INVOICE-LOT ID-WAFER ID COMBINATION
        //Preparing map for the existing Return Invoices for the Lot Number and Invoice Number being Inserted/Updated
        for(RMA_DNCN__c dncnExisting: [SELECT Id,Invoice_Lot_Combination__c,Invoice_Number__c,Name,Lot_Id__c,Wafer_Id__c,CN_DN_Number__c
                                        FROM RMA_DNCN__c
                                        WHERE Invoice_Lot_Combination__c in :mapInvWafer.values()
                                          AND Record_Source__c = 'DNCN']){
            
            if(!mapDNCNexisting.containsKey(dncnExisting.Invoice_Lot_Combination__c)){
                mapDNCNexisting.put(dncnExisting.Invoice_Lot_Combination__c,new List<RMA_DNCN__c>());
            }
            mapDNCNexisting.get(dncnExisting.Invoice_Lot_Combination__c).add(dncnExisting);
        }        
        //Checking for the Wafers that are already associated in the existing Return Invoices
        map<String,List<String>> mapLotWaferDNCNnotInserted= new Map<String,List<String>>();
        map<String,RMA_Return_Invoice__c> mapLotInvAndRI = new Map<String,RMA_Return_Invoice__c>();
        map<String,RMA_DNCN__c> mapLotInvAndExistingDNCN = new Map<String,RMA_DNCN__c>();
        
        string tempToCheckWaferIdDNCN;
        for(RMA_Return_Invoice__c rmaToCheck: TriggerNew){
            workflowStage = mapRMAvsStage.get(rmaToCheck.Id) != NULL ? mapRMAvsStage.get(rmaToCheck.Id).RMA__r.Workflow_Stage__c:'';
            //get the wafer Id to check 
            if( 
                workflowStage == 'RMA Raised' ||
                workflowStage == 'Rejected RMA' || 
                workflowStage == '' 
            ){
                if(!RMA_Utility.checkFab9or10(rmaToCheck.Fab_Group__c)){
                    tempToCheckWaferIdDNCN = rmaToCheck.Wafer_Id_CSR_Submission__c;
                }else{
                    tempToCheckWaferIdDNCN = rmaToCheck.Wafer_Id_Fab_9_10_CSR_Submission__c;
                }
            }else if(workflowStage == RMA_Constants.PEN_CQ_VAL){
                if(!RMA_Utility.checkFab9or10(rmaToCheck.Fab_Group__c)){
                    tempToCheckWaferIdDNCN = rmaToCheck.Wafer_Id_CSR_Submission__c;
                }else{
                    tempToCheckWaferIdDNCN = rmaToCheck.Wafer_Id_Fab_9_10_CSR_Submission__c;
                }
            }else if(
                workflowStage == RMA_Constants.PEN_FAB_VAL || 
                workflowStage == RMA_Constants.PEN_TNK_VAL ||
                workflowStage == RMA_Constants.PEN_NONFAB_VAL ||
                workflowStage == RMA_Constants.PEN_PRD_ENG
            ){
                if(!RMA_Utility.checkFab9or10(rmaToCheck.Fab_Group__c)){
                    tempToCheckWaferIdDNCN = rmaToCheck.Wafer_Id_Fab_Validated__c;
                }else{
                    tempToCheckWaferIdDNCN = rmaToCheck.Wafer_Id_Fab_9_10_Fab_Validated__c;
                }
            }else{
                if(!RMA_Utility.checkFab9or10(rmaToCheck.Fab_Group__c)){
                    tempToCheckWaferIdDNCN = rmaToCheck.Wafer_Id_Regional_Personnel_Recommended__c;
                }else{
                    tempToCheckWaferIdDNCN = rmaToCheck.Wafer_Id_Fab_9_10_Regional_Validated__c;
                }
            }
            
            if(mapDNCNexisting != NULL && mapDNCNexisting.get(rmaToCheck.Invoice_Number__c + ':' + rmaToCheck.Lot_Number__c) != NULL){
                for(RMA_DNCN__c dncnExisting: mapDNCNexisting.get(rmaToCheck.Invoice_Number__c + ':' + rmaToCheck.Lot_Number__c)){
                    dncnExisting.Wafer_Id__c = ';' + dncnExisting.Wafer_Id__c + ';' ;
                    if(rmaToCheck.RMA_By__c != 'Die'){
                        if(tempToCheckWaferIdDNCN != NULL){
                            for(String waferId: tempToCheckWaferIdDNCN.split(';')){
                                if(dncnExisting.Wafer_Id__c.contains(';' + waferId + ';')){
                                    if(!mapLotWaferDNCNnotInserted.containsKey(rmaToCheck.Lot_Number__c + '--' + dncnExisting.CN_DN_Number__c)){
                                        mapLotWaferDNCNnotInserted.put(rmaToCheck.Lot_Number__c + '--' + dncnExisting.CN_DN_Number__c, new List<String>());
                                    }
                                    mapLotWaferDNCNnotInserted.get(rmaToCheck.Lot_Number__c + '--' + dncnExisting.CN_DN_Number__c).add(waferId);
                                    mapLotInvAndRI.put            (rmaToCheck.Lot_Number__c + '--' + dncnExisting.CN_DN_Number__c,rmaToCheck);
                                    mapLotInvAndExistingDNCN.put  (rmaToCheck.Lot_Number__c + '--' + dncnExisting.CN_DN_Number__c,dncnExisting);
                                }
                            }
                        }
                    }else{
                        if(!mapLotWaferDNCNnotInserted.containsKey(rmaToCheck.Lot_Number__c + '--' + dncnExisting.CN_DN_Number__c)){
                            mapLotWaferDNCNnotInserted.put(rmaToCheck.Lot_Number__c + '--' + dncnExisting.CN_DN_Number__c, new List<String>());
                        }
                        mapLotInvAndRI.put            (rmaToCheck.Lot_Number__c + '--' + dncnExisting.CN_DN_Number__c,rmaToCheck);
                        mapLotInvAndExistingDNCN.put  (rmaToCheck.Lot_Number__c + '--' + dncnExisting.CN_DN_Number__c,dncnExisting);
                    }
                }
            }
        }
        //Displaying the error message for the erroneous records along with the Hyperlink to the duplicate record.
        for(String LotInvoiceStr: mapLotInvAndRI.keySet()){            
            if(ApexPages.currentPage() != null){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,
                        (!mapLotWaferDNCNnotInserted.get(LotInvoiceStr).isEmpty() ? ' Wafer Id:'+mapLotWaferDNCNnotInserted.get(LotInvoiceStr):'Selected Dies') + 
                        ' under Lot #:'+ LotInvoiceStr.split('--')[0] + ' has already been issued in the '+ 
                        '<a href="/'+mapLotInvAndExistingDNCN.get(LotInvoiceStr).Id+'">'+
                        mapLotInvAndExistingDNCN.get(LotInvoiceStr).Name+'</a>.'+
                        ' Please validate its inclusion before submitting the RMA for Approval.'
                ));
            }       
        }
        //--CHECK DUPLICATE AGAINST THE EXISTING DN/CN TABLE FOR SAME INVOICE-LOT ID-WAFER ID COMBINATION
        
        //++CHECK IF THE DIE QUANTITY DOESN'T EXCEED THE MAXIMUM BILL QUANTITY OF THE INVOICE 
        Map<String,Integer> mapLotInvAggregate = new Map<String,Integer>();
        for(AggregateResult aggr: [SELECT SUM(Current_Die_Quantity__c),Invoice_Number__c,Lot_Number__c
                                    FROM RMA_Return_Invoice__c 
                                    WHERE RMA_By__c = 'Die' 
                                        AND Id NOT IN :TriggerNew
                                        AND RMA__r.Status__c in ('Submitted','Approved')
                                        AND Invoice_Lot_Combination__c in :mapInvWafer.values()
                                    GROUP BY Invoice_Number__c,Lot_Number__c]){
            mapLotInvAggregate.put(aggr.get('Invoice_Number__c') + ':' + aggr.get('Lot_Number__c'), integer.valueOf(aggr.get('expr0')));
        }
        for(RMA_Return_Invoice__c ri: TriggerNew){
            if( mapLotInvAggregate.get(ri.Invoice_Lot_Combination__c) != NULL && 
                ri.Current_Die_Quantity__c > ri.Bill_Quantity__c - mapLotInvAggregate.get(ri.Invoice_Lot_Combination__c)){
                ri.addError('Die Quantity has already exceeded the maximum Bill Quantity for Lot Number: '+ ri.Lot_Number__c + 
                            '. It has been associated in other RMAs.');
            }
        }
        //--CHECK IF THE DIE QUANTITY DOESN'T EXCEED THE MAXIMUM BILL QUANTITY OF THE INVOICE
        
        //++CHECK IF THE MODULE QUANTITY DOESN'T EXCEED THE MAXIMUM BILL QUANTITY OF THE INVOICE 
        Map<String,Integer> mapLotInvAggregateMod = new Map<String,Integer>();
        for(AggregateResult aggr: [SELECT SUM(Current_Module_Quantity__c),Invoice_Number__c,Lot_Number__c
                                    FROM RMA_Return_Invoice__c 
                                    WHERE RMA_By__c = 'Module' 
                                        AND Id NOT IN :TriggerNew
                                        AND RMA__r.Status__c in ('Submitted','Approved')
                                        AND Invoice_Lot_Combination__c in :mapInvWafer.values()
                                    GROUP BY Invoice_Number__c,Lot_Number__c]){
            mapLotInvAggregateMod.put(aggr.get('Invoice_Number__c') + ':' + aggr.get('Lot_Number__c'), integer.valueOf(aggr.get('expr0')));
        }
        for(RMA_Return_Invoice__c ri: TriggerNew){
            if( mapLotInvAggregateMod.get(ri.Invoice_Lot_Combination__c) != NULL && 
                ri.Current_Module_Quantity__c > ri.Bill_Quantity__c - mapLotInvAggregateMod.get(ri.Invoice_Lot_Combination__c)){
                ri.addError('Multiple RMAs exist for the selected Lot and Invoice Id and total sum of module quantities exceeds the invoice billed quantity');
            }
        }
        //--CHECK IF THE MODULE QUANTITY DOESN'T EXCEED THE MAXIMUM BILL QUANTITY OF THE INVOICE 
        
        return mapErrorStatus;
    }
    
    
    //Method to check if the line item being inserted belongs to matching Fab and Account at RMA and Manufacturing Lot.
    public static void checkAccountAndFab(List<RMA_Return_Invoice__c> TriggerNew){
        for(RMA_Return_Invoice__c rmaLI: TriggerNew){
            if(!rmaLI.Valid_Account__c){
                rmaLI.addError('Lot Id that you\'re trying to insert belongs to a different Account as of RMA.'+
                'Please select different Lot.');
            }
            if(!rmaLI.Valid_Fab__c){
                rmaLI.addError('Lot Id that you\'re trying to insert belongs to a different FAB as of RMA.'+
                'Please select different Lot.');
            }
        }
    }
    
    //Method to populate if the RMA is Intercompany or Not    
    public static void checkIntercompanyLogic(List<RMA_Return_Invoice__c> TriggerNew){
        Set<String> setRMAids = new Set<String>();
        Map<String,Boolean> mapRMAvsICflag = new Map<String,Boolean>();
        Map<String,List<RMA_Return_Invoice__c>> mapRMAvsLI = new Map<String,List<RMA_Return_Invoice__c>>();
        
        for(RMA_Return_Invoice__c  rmaLI: TriggerNew){
            setRMAids.add(rmaLI.RMA__c);
            if(!mapRMAvsLI.containsKey(rmaLI.RMA__c)){
                mapRMAvsLI.put(rmaLI.RMA__c, new List<RMA_Return_Invoice__c>());
            }
            mapRMAvsLI.get(rmaLI.RMA__c).add(rmaLI);
        }
        
        //++Logic to Check if all the Line Items associated with a particular RMA belong to either Intercompany or Non-Intercompany
        List<RMA__c> lstRMAtoUpdate = new List<RMA__c>();
        for(String RMAid: mapRMAvsLI.keySet()){
            boolean initialICflag = (mapRMAvsLI.get(RMAid)[0].Intercompany_Customer_Name__c != NULL ? True:False);
            boolean isMixedICflag = false;
            for(RMA_Return_Invoice__c  riLI: mapRMAvsLI.get(RMAid)){
                if(initialICflag != (riLI.Intercompany_Customer_Name__c != NULL? True:False)){
                    for(RMA_Return_Invoice__c  riLIErrors: mapRMAvsLI.get(RMAid)){
                        riLIErrors.addError('You are trying to insert mixed Intercompany line Items.');
                    }
                    isMixedICflag = True;
                    break;
                }
            }
            if(!isMixedICflag){
                RMA__c rmaRec = new RMA__c(ID = RMAid);
                rmaRec.Intercompany__c = initialICflag;
                lstRMAtoUpdate.add(rmaRec);
            }
        }
        //--Logic to Check if all the Line Items associated with a particular RMA belong to either Intercompany or Non-Intercompany
        
        //++Logic to Check if the Line Item can be inserted to the RMA if Intercompany or Not
        for(RMA__c rmaRec: [SELECT Id, Total_Wafers__c, Intercompany__c 
                            FROM RMA__c
                            WHERE Id in: setRMAids and Total_Wafers__c > 0]){
            mapRMAvsICflag.put(rmaRec.Id,rmaRec.Intercompany__c);
        }
        
        for(RMA_Return_Invoice__c  rmaLI: TriggerNew){
            if(mapRMAvsICflag.containsKey(rmaLI.RMA__c) && 
               mapRMAvsICflag.get(rmaLI.RMA__c) != (rmaLI.Intercompany_Customer_Name__c != NULL ? True:False)){
                string str = mapRMAvsICflag.get(rmaLI.RMA__c) == True ? 'Intercompany':'Non-Intercompany';
                rmaLI.addError('Line Item cannot be inserted as the RMA request can have only <b>' + str + '</b> Lots');
            }else{
                
            }
        }
        //--Logic to Check if the Line Item can be inserted to the RMA if Intercompany or Not
        
        //Update the RMA record for the Intercompany Flag based on the Line Items inserted.
        if(!lstRMAtoUpdate.isEmpty()){
            database.update(lstRMAtoUpdate);
        }
    }
    
    //to remove deleted lot#s from RMA Lot Fields
    public static void clearLotNoFromRMA(List<RMA_Return_Invoice__c> TriggerNew){
        Set<String> setRMAIds = new Set<String>();
        Map<RMA__c, String> mapRMALotNo = new Map<RMA__c, String>();
        List<RMA__c> lstRMA = new List<RMA__c>();
        
        for(RMA_Return_Invoice__c invoice : TriggerNew){
            setRMAIds.add(invoice.RMA__c);
        }
        
        if(!setRMAIds.isEmpty()){
            lstRMA = [select Id,Lot_Device_Design_Rule_Waiver__c,Lot_Device_ET_Waiver__c,Lot_Device_FRF__c,Lot_Device_Requires_Scrap_Certificate__c,
                     Lot_Device_Risk_Production__c,Lot_Device_To_Return__c from RMA__c where Id IN: setRMAIds];
        }
        
        if(!lstRMA.isEmpty()){
            for(RMA__c rmaRec : lstRMA){
                String lotNos = '';
                for(RMA_Return_Invoice__c invoice : TriggerNew){
                    if(rmaRec.Id == invoice.RMA__c){
                        lotNos += invoice.Lot_Number__c + '-' + invoice.Invoice_Number__c + ';';
                    }
                }
                mapRMALotNo.put(rmaRec,lotNos);
            }
        }
                
        lstRMA = new List<RMA__c>();
        
        Map<String,List<String>> mapRMALot = new Map<String,List<String>>();
        for(RMA__c rmaRec: mapRMALotNo.keySet()){
            List<String> lstLots = new List<String>();
            for(String lot : mapRMALotNo.get(rmaRec).split(';')){
                lstLots.add(lot);
            }
            mapRMALot.put(rmaRec.Id,lstLots);
        } 
        
        List<RMA_PRF_CAR_Particulars__c> lstRemove = new List<RMA_PRF_CAR_Particulars__c>();
        if(!mapRMALot.isEmpty()){
            for(RMA_PRF_CAR_Particulars__c part : [select Id,Lot__c,RMA__c,RecordTypeId from RMA_PRF_CAR_Particulars__c where RMA__c =: mapRMALot.keySet()]){
                for(String rmaId : mapRMALot.keySet()){
                    if(part.RMA__c == rmaId){
                        for(String lot : mapRMALot.get(rmaId)){
                            if(part.Lot__c == lot){
                                lstRemove.add(part);
                            }
                        }
                    }
                }
            }
        }
        
        if(!lstRemove.isEmpty()){
            delete lstRemove;
        }
        
        if(!mapRMALotNo.isEmpty()){
            for(RMA__c rmaRec : mapRMALotNo.keySet()){
                String lotNoToRemove = mapRMALotNo.get(rmaRec);
                
                if(rmaRec.Lot_Device_Design_Rule_Waiver__c != NULL && rmaRec.Lot_Device_Design_Rule_Waiver__c.contains(lotNoToRemove)){
                    rmaRec.Lot_Device_Design_Rule_Waiver__c = rmaRec.Lot_Device_Design_Rule_Waiver__c.remove(lotNoToRemove);
                }
                
                if(rmaRec.Lot_Device_ET_Waiver__c != NULL && rmaRec.Lot_Device_ET_Waiver__c.contains(lotNoToRemove)){
                    rmaRec.Lot_Device_ET_Waiver__c = rmaRec.Lot_Device_ET_Waiver__c.remove(lotNoToRemove);
                }
                
                if(rmaRec.Lot_Device_FRF__c != NULL && rmaRec.Lot_Device_FRF__c.contains(lotNoToRemove)){
                    rmaRec.Lot_Device_FRF__c = rmaRec.Lot_Device_FRF__c.remove(lotNoToRemove);
                }
                
                if(rmaRec.Lot_Device_Requires_Scrap_Certificate__c != NULL && rmaRec.Lot_Device_Requires_Scrap_Certificate__c.contains(lotNoToRemove)){
                    rmaRec.Lot_Device_Requires_Scrap_Certificate__c = rmaRec.Lot_Device_Requires_Scrap_Certificate__c.remove(lotNoToRemove);
                }
                
                if(rmaRec.Lot_Device_Risk_Production__c != NULL && rmaRec.Lot_Device_Risk_Production__c.contains(lotNoToRemove)){
                    rmaRec.Lot_Device_Risk_Production__c = rmaRec.Lot_Device_Risk_Production__c.remove(lotNoToRemove);
                }
                
                if(rmaRec.Lot_Device_To_Return__c != NULL && rmaRec.Lot_Device_To_Return__c.contains(lotNoToRemove)){
                    rmaRec.Lot_Device_To_Return__c = rmaRec.Lot_Device_To_Return__c.remove(lotNoToRemove);
                }
                
                lstRMA.add(rmaRec);
            }
        }
        
        if(!lstRMA.isEmpty()){
            update lstRMA;
        }
        
    }
    
}