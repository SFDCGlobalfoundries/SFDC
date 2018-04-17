/*************************************************************************************************************************************************************
@ Class:          QMXWorkOrderTriggerHelper
@ Version:        1.0
@ Author:         Pradosh Samal/Yathish (pradosh.samal@globalfoundries.com,yathish.ns1@globalfoundries.com)
@ Purpose:        This Helper class consists of logics used in QMX Work Order trigger.
--------------------------------------------------------------------------------------------------------------------------------------------------------------
@ Change history: 11.09.2017 / Yathish / Created the class.
**************************************************************************************************************************************************************/
public class QMXWorkOrderTriggerHelper{
    public static boolean firstRun = true;
    Public static Set<Id> rmaIdSet = new Set<Id>();
    Public Static List<Work_Order_Lot__c> wolList= new List<Work_Order_Lot__c>();
    Public Static Map<Id,RMA__c> rmaRetInvoice = new Map<Id,RMA__c>();
    public static List<Work_Order__c> woList = new List<Work_Order__c>();
    
    /**EnvironmentVariable**/
    private final String REC_TYPE_GF_R10_RMA_FA = Environment_Variable__c.getInstance('QMX_WO_REC_TYPE_GF_R10_RMA_FA').Value__c;
    private final String REC_TYPE_GF_PARTIAL_CRIB_RELEASE = Environment_Variable__c.getInstance('QMX_WO_REC_TYPE_GF_PARTIAL_CRIB_RELEAS').Value__c;
    private final String REC_TYPE_GF_STOCK_REWORK = Environment_Variable__c.getInstance('QMX_WO_REC_TYPE_GF_STOCK_REWORK').Value__c;
    private final String REC_TYPE_GF_BA_RELEASE_SETUP = Environment_Variable__c.getInstance('QMX_WO_REC_TYPE_GF_BA_RELEASE_SETUP').Value__c;
    private final String STATUS_DRAFT = Environment_Variable__c.getInstance('QMX_WO_STATUS_DRAFT').Value__c;
    private final String STATUS_APPROVED = Environment_Variable__c.getInstance('QMX_WO_STATUS_APPROVED').Value__c;
    private final String STATUS_REJECTED = Environment_Variable__c.getInstance('QMX_WO_STATUS_REJECTED').Value__c;
    private final String STATUS_ZONE_88 = Environment_Variable__c.getInstance('QMX_WO_STATUS_ZONE_88').Value__c;
    private final String STATUS_PARTIAL_CRIB = Environment_Variable__c.getInstance('QMX_WO_STATUS_BROMONT_PARTIAL_CRIB').Value__c;
    private final String STATUS_BNP_FIRST_APPROVAL = Environment_Variable__c.getInstance('QMX_WO_STATUS_BNP_FIRST_APPROVAL').Value__c;
    private final String STATUS_BNP_SECOND_APPROVAL = Environment_Variable__c.getInstance('QMX_WO_STATUS_BNP_SECOND_APPROVAL').Value__c;
    private final String STATUS_MFG_RELEASE = Environment_Variable__c.getInstance('QMX_WO_STATUS_MFG_RELEASE').Value__c;
    private final String STATUS_BTV_ROUTING = Environment_Variable__c.getInstance('QMX_WO_STATUS_BTV_ROUTING').Value__c;
    private final String STATUS_CO_ZONE_88 = Environment_Variable__c.getInstance('QMX_WO_STATUS_CO_ZONE_88').Value__c;
    private final String STATUS_ITAR = Environment_Variable__c.getInstance('QMX_WO_STATUS_ITAR').Value__c;
    private final String ISC_ENG_CUST_INST = Environment_Variable__c.getInstance('QMX_WO_ISC_ENG_CUST_INST').Value__c;
    
    public void updateCusIns(List<Work_Order__c> wos){
        for(Work_Order__c wo :wos){
            wo.ISC_Engineering_Customer_Instructions__c = ISC_ENG_CUST_INST;
            woList.add(wo);
        }
        
    }
    public void createWOLot(List<Work_Order__c> wos){
        
        Map<ID, Schema.RecordTypeInfo>  workOderRecordTypeMap = Work_Order__c.sObjectType.getDescribe().getRecordTypeInfosById();
        List<Work_Order__c> wosList = [select Id,recordTypeID,RMA_Number__c,Original_PN__c,Manufacturing_PN__c from Work_Order__c where Id In : Trigger.newMap.keySet()];
        for(Work_Order__c w :wosList){
            if(workOderRecordTypeMap.get(w.recordTypeID).getName().containsIgnoreCase(REC_TYPE_GF_R10_RMA_FA) || workOderRecordTypeMap.get(w.recordTypeID).getName().containsIgnoreCase(REC_TYPE_GF_STOCK_REWORK)){
                if(w.RMA_Number__c !=null){
                    rmaIdSet.add(w.RMA_Number__c);    
                }
            }   
        }
        rmaRetInvoice =new Map<Id, RMA__c>([select Id,Name,(Select Id,Lot_Number__c,Wafer_Quantity__c,Device__c from RMA_Return_Invoices__r) From RMA__c where Id In: rmaIdSet]);
        List<Work_Order__c> woList = new List<Work_Order__c>();
        String deviceName = '';
        System.debug('rmaidsetval    ' +  rmaIdSet + '     '+rmaRetInvoice);
        for(Work_Order__c wo:wosList){
            if(workOderRecordTypeMap.get(wo.recordTypeID).getName().containsIgnoreCase(REC_TYPE_GF_R10_RMA_FA) || workOderRecordTypeMap.get(wo.recordTypeID).getName().containsIgnoreCase(REC_TYPE_GF_STOCK_REWORK)){
                if(wo.RMA_Number__c !=null){
                for(RMA_Return_Invoice__c ri : rmaRetInvoice.get(wo.RMA_Number__c).RMA_Return_Invoices__r){
                   Work_Order_Lot__c rwol = new Work_Order_Lot__c();
                   rwol.Rework_Lots__c = '';
                   rwol.Original_Lot_Numbers__c = ri.Lot_Number__c;
                   rwol.Qual_Code__c = '00';
                   rwol.Lot_Qty__c = ri.Wafer_Quantity__c ;
                   rwol.Work_Order__c = wo.Id;
                   wolList.add(rwol);
                   deviceName = ri.Device__c;
                   System.debug('heeere123');
                }
                }
            }
            if(deviceName !=null && deviceName !=''){
                wo.Original_PN__c = deviceName;
                wo.Manufacturing_PN__c = deviceName;
                woList.add(wo);
            }
         }
       if(!wolList.isEmpty()){
          try{
              insert wolList;
              System.debug('heeere 234');
              if(!woList.isEmpty()){
                  update woList;
              }
          }
          catch(Exception e){
              GlobalUtility.logMessage('Error', 'QMXWorkOrderTriggerHelper', 'createWOLot', '', '', e.getMessage(), '', 'Work Order', e, 0);
          }
       }
       
    }
    public void handleUpdate(List<Work_Order__c> wos){
        Map<ID, Schema.RecordTypeInfo>  workOderRecordTypeMap = Work_Order__c.sObjectType.getDescribe().getRecordTypeInfosById();
        rmaIdSet.clear();
        rmaRetInvoice.clear();
        wolList.clear();
        Set<Id> woId = new Set<Id>();
        Map<Id,Work_Order__c> woWolMap = new Map<Id,Work_Order__c>();  
        for(Work_Order__c w :wos){
            rmaIdSet.add(w.RMA_Number__c); 
            woId.add(w.Id);   
        }
        rmaRetInvoice =new Map<Id, RMA__c>([select Id,Name,(Select Id,Lot_Number__c,Wafer_Quantity__c,Device__c from RMA_Return_Invoices__r) From RMA__c where Id In: rmaIdSet]);
        woWolMap =  new Map<Id,Work_Order__c>([Select Id,(Select Id,Rework_Lots__c from RMA_Work_Order_Lots__r) from Work_Order__c where Id In:woId]);
        List<Work_Order_Lot__c> wolotList = new List<Work_Order_Lot__c>();
        List<Work_Order__c> woList = new List<Work_Order__c>();
        String deviceName = '';
        
        for(Work_Order__c wo:wos){
           Work_Order__c wo1 = (Work_Order__c)Trigger.oldMap.get(wo.Id); 
                    System.debug('wo1 wo    ' +  wo1.RMA_Number__c + '     '+wo.RMA_Number__c);
           if(wo.RMA_Number__c != wo1.RMA_Number__c && (wo.RMA_Number__c !=null))
           {
               wolotList.addall(woWolMap.get(wo.Id).RMA_Work_Order_Lots__r);
               for(RMA_Return_Invoice__c ri : rmaRetInvoice.get(wo.RMA_Number__c).RMA_Return_Invoices__r){
               Work_Order_Lot__c rwol = new Work_Order_Lot__c();
               rwol.Rework_Lots__c = '';
               rwol.Original_Lot_Numbers__c = ri.Lot_Number__c;
               rwol.Qual_Code__c = '00';
               rwol.Lot_Qty__c = ri.Wafer_Quantity__c ;
               rwol.Work_Order__c = wo.Id;
               wolList.add(rwol);
               deviceName = ri.Device__c;
            }
               
           }
           if(wo.Approval_Status__c == STATUS_BTV_ROUTING && String.isBlank(wo.Rework_Instructions__c)){
               
               Error_Codes__c errorCodes = Error_Codes__c.getInstance('QMX_WORK_ORDER_REWORK_INSTRUCTION_VAL');
               wo.Rework_Instructions__c.adderror(errorCodes.Message__c);
           }
           system.debug( 'vals heeere   ' +wo1.LastModifiedDate  +'    '+wo.LastModifiedDate+'    '+wo.RecordType.DeveloperName);
           if((wo.Approval_Status__c == wo1.Approval_Status__c && (wo.Approval_Status__c != STATUS_DRAFT  && wo.Approval_Status__c !=STATUS_ZONE_88 && wo.Approval_Status__c !=STATUS_REJECTED && wo.Approval_Status__c !=STATUS_CO_ZONE_88 && wo.Approval_Status__c !=STATUS_PARTIAL_CRIB && wo.Approval_Status__c !=STATUS_BNP_FIRST_APPROVAL && wo.Approval_Status__c !=STATUS_MFG_RELEASE && wo.Approval_Status__c !=STATUS_BNP_SECOND_APPROVAL))){
               Error_Codes__c errorCodes = Error_Codes__c.getInstance('QMX_WORK_ORDER_ACCESS_VALIDATION');
               wo.adderror(errorCodes.Message__c);
           }
           
           if(wo.Approval_Status__c ==STATUS_ITAR || wo.Approval_Status__c ==STATUS_APPROVED){
               boolean isRetLotEmpty = false;
               for(Work_Order_Lot__c wol : woWolMap.get(wo.Id).RMA_Work_Order_Lots__r){
                   if(wol.Rework_Lots__c == null || wol.Rework_Lots__c == ''){
                       isRetLotEmpty = true;    
                   }    
               }
               if(isRetLotEmpty){
                   Error_Codes__c errorCodes = Error_Codes__c.getInstance('QMX_WORK_ORDER_LOT_REWORK_VALIDATION');
                   wo.adderror(errorCodes.Message__c);    
               }
               
           }
           
           if((workOderRecordTypeMap.get(wo.recordTypeID).getName().containsIgnoreCase(REC_TYPE_GF_BA_RELEASE_SETUP) && wo.Approval_Status__c ==STATUS_BNP_SECOND_APPROVAL && wo.OSAT_Ready__c == 'No') || (workOderRecordTypeMap.get(wo.recordTypeID).getName().containsIgnoreCase(REC_TYPE_GF_BA_RELEASE_SETUP) && wo.Approval_Status__c ==STATUS_APPROVED && wo.OSAT_Ready__c == 'No')){
                  Error_Codes__c errorCodes = Error_Codes__c.getInstance('QMX_WO_OSAT_FIELDS_VALIDATION');
                  wo.adderror(errorCodes.Message__c);                              
           }
           
           if(workOderRecordTypeMap.get(wo.recordTypeID).getName().containsIgnoreCase(REC_TYPE_GF_BA_RELEASE_SETUP) && wo.Approval_Status__c ==STATUS_APPROVED && wo.To_Go_Quantity__c != 0){
                  Error_Codes__c errorCodes = Error_Codes__c.getInstance('QMX_WO_OSAT_TOGO_QTY_VALIDATION');
                  wo.adderror(errorCodes.Message__c);                              
           }
         
           
           if(deviceName !=null && deviceName !=''){
                wo.Original_PN__c = deviceName;
                wo.Manufacturing_PN__c = deviceName;
                woList.add(wo);
            }       
            
         }
         if(!wolotList.isEmpty()){
             try{
                 delete wolotList;
                 if(!woList.isEmpty()){
                     update woList;
                 }
             }
             catch(Exception e){
                 GlobalUtility.logMessage('Error', 'QMXWorkOrderTriggerHelper', 'handleUpdate', '', '', e.getMessage(), '', 'Work Order', e, 0);
             }
         }
         if(!wolList.isEmpty()){
             try{
                 insert wolList;
             }
             catch(Exception e){
                 GlobalUtility.logMessage('Error', 'QMXWorkOrderTriggerHelper', 'handleUpdate', '', '', e.getMessage(), '', 'Work Order', e, 0);
             }    
         }
    }
    
    /*********************************************************************************************************************************************************
    @ Method:         populateExpirationDate
    @ Version:        1.0
    @ Author:         Pradosh Samal
    @ Purpose:        Calculation of Expiration Date
    **********************************************************************************************************************************************************/ 
    public void populateExpirationDate(List<Work_Order__c> workOrderList){
        
        for(Work_Order__c workOrder : workOrderList){
            
            if(workOrder.Need_Date__c != NULL &&  workOrder.Expiration_Date__c == NULL){
                
                workOrder.Expiration_Date__c = workOrder.Need_Date__c.addDays(1);
            }
        }
    }
    
    
    /*********************************************************************************************************************************************************
    @ Method:         declaredLOTValidation
    @ Version:        1.0
    @ Author:         Pradosh Samal
    @ Purpose:        Validation for Declared LOT value in Zone88 step for GF Partial Crib Release form approval.
    **********************************************************************************************************************************************************/ 
    public void declaredLOTValidation(){
        Map<ID, Schema.RecordTypeInfo>  workOderRecordTypeMap = Work_Order__c.sObjectType.getDescribe().getRecordTypeInfosById(); 
        Map<Id, Work_Order__c>  triggerOldMap = ((Map<Id, Work_Order__c>)Trigger.oldMap);
        
        Error_Codes__c errorCodes;
        
        for(Work_Order__c workOrder : (List<Work_Order__c>)Trigger.new){
            
            if(workOderRecordTypeMap.get(workOrder.recordTypeID).getName().containsIgnoreCase(REC_TYPE_GF_PARTIAL_CRIB_RELEASE)
             && workOrder.Approval_Status__c != triggerOldMap.get(workOrder.Id).Approval_Status__c
             && triggerOldMap.get(workOrder.Id).Approval_Status__c == STATUS_PARTIAL_CRIB
             && (workOrder.Approval_Status__c != STATUS_DRAFT && workOrder.Approval_Status__c != STATUS_REJECTED) ){
                
                if(workOrder.Declared_LOT_OSAT_input__c == NULL){
                    
                    errorCodes = Error_Codes__c.getInstance('QMX_WORK_ORDER_DECLARED_LOT_VALIDATION');
                    workOrder.addError(errorCodes.Message__c);
                }
            }
        }
    }
}