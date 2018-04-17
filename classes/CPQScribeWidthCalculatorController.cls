/*
* Author : Akash
* Purpose : To support scribewidth calculator page, to query base table data and display it in tabular format
* Createddate : sep 1, 2015
  Nbajaj      23-Aug-17   -cpq Sprint10 case- 00067881
  Description: added one string variable to add msg on vf page if device TapeoutReadinessValidationStatus is in fully complet state
*/

public without sharing class CPQScribeWidthCalculatorController {
    public List<Apttus_Config2__ProductAttributeValue__c> lines{get;set;}
    public List<String> processTechList {get;set;}
    public String configID ;
    public String deviceId; 
    public Device__c device{get;set;}
    public map<String,String> mpBaseTableData{get;set;}
    Public String TapeoutReadinessValidationStatus{get;set;}
    public string iPAccountKey{get;set;}
    public string currentPT{get;set;}
    public string accountShortName{get;set;}
    public boolean isSuperUser{get;set;}
    public Scribewidth_Calculator_Settings__c calcDisplaySetting{get;set;}
    public map<String,Scribe_Width_Base_Table__c> mpPtBaseData{get;set;}
    public CPQScribeWidthCalculatorController(ApexPages.StandardController controller) {
        mpPTBaseData = new map<String,Scribe_Width_Base_Table__c>();        
        lines = new List<Apttus_Config2__ProductAttributeValue__c> ();
        Apttus_Config2__ProductAttributeValue__c tempLine = new Apttus_Config2__ProductAttributeValue__c();
        calcDisplaySetting = Scribewidth_Calculator_Settings__c.getInstance();
        device = (Device__c)controller.getRecord();
        device = [SELECT Id,Pre_PTRF_Validation_Status__c,Die_Size_Y_mm__c,Die_Size_X_mm__c,Min_scribe_width_X_post_shrink__c,
                    Dies_X_per_illumination_field__c,Dies_Y_per_illumination_field__c,
                    Min_scribe_width_Y_post_shrink__c,Std_scribe_width_X_post_shrink__c ,Std_scribe_width_Y_post_shrink__c 
                  FROM Device__c where id = :device.Id]; 
        TapeoutReadinessValidationStatus = device.Pre_PTRF_Validation_Status__c;
        deviceId = device.Id;
        if(deviceId != NULl && deviceId !='') {
          for(Apttus_Proposal__Proposal__c  config :  [select Id,Apttus_Proposal__Account__r.Short_Name__c,Process_Technology_Lookup__c,Process_Technology_Lookup__r.IP_Geometry_Technology__c 
                                                       FROM Apttus_Proposal__Proposal__c 
                                                                    where   Device__c =:deviceId AND APTPS_Primary__c = true  limit 1 ]){
                /*                                                    	
                iPAccountKey = config.Process_Technology_Lookup__r.IP_Geometry_Technology__c + '-' +  config.Apttus_Proposal__Account__r.Short_Name__c;   
                currentPT = config.Process_Technology_Lookup__r.IP_Geometry_Technology__c;
                accountShortName = config.Apttus_Proposal__Account__r.Short_Name__c;                                                
                */
                iPAccountKey = config.Process_Technology_Lookup__c;
                currentPT = config.Process_Technology_Lookup__c;
                configID  = config.Id ;  
            } //
        }
        String prodConfigID  ; 
        if(configID !=NULL){
            for(Apttus_Proposal__Proposal_Line_Item__c  PLitem :  [select  id,Apttus_QPConfig__ConfigurationId__c 
                                                                    from    Apttus_Proposal__Proposal_Line_Item__c 
                                                                    where   Apttus_Proposal__Proposal__c =:configID limit 1 ]){
                prodConfigID  = PLitem.Apttus_QPConfig__ConfigurationId__c ;  
            } 
        }
        if(prodConfigID  != NULL){
            lines = [select  id
                                , name 
                                , Die_Size_X_mm__c
                                , Die_Size_Y_mm__c
                                , Apttus_Config2__LineItemId__r.Apttus_Config2__ConfigurationId__c 
                        from    Apttus_Config2__ProductAttributeValue__c  
                        where   Apttus_Config2__LineItemId__r.Apttus_Config2__ConfigurationId__c = :prodConfigID  ];
            
        }
        if(!lines.isEmpty()) {
          if(device.Die_Size_X_mm__c == NULL) {
            device.Die_Size_X_mm__c = lines[0].Die_Size_X_mm__c;
          }
          if(device.Die_Size_Y_mm__c == NULL) {
            device.Die_Size_Y_mm__c = lines[0].Die_Size_Y_mm__c;
          }
          
        }
        processTechList = new List<String>();
                     
        mpBaseTableData = new map<String,String>();
        set<String> processTechnologies = new set<String>(); 
        Boolean isPTFound = false;
        Boolean isAccountPTFound = false;
        String currntPT;
        for(Scribe_Width_Base_Table__c BTable : [SELECT    id,Process_Technology_Number__c
                                                           , Sequence__c
                                                           , Process_Technology__c
                                                           , Optical_and_Manufacturing_Structures_V__c
                                                           , Optical_and_Manufacturing_Structures_H__c
                                                           , Electrical_Yield_Bring_Up_Structures_V__c
                                                           , Electrical_Yield_Bring_Up_Structures_H__c
                                                           , Electrical_Wafer_Disposition_StructuresV__c
                                                           , Electrical_Wafer_Disposition_StructuresH__c
                                                           , Electrical_Reliability_Structures_V__c
                                                           , Electrical_Reliability_Structures_H__c
                                                           , Electrical_Debugging_Customer_StructureV__c
                                                           , Electrical_Debugging_Customer_StructureH__c
                                                           , Std_Horizontal_scribe_width_post_shrink__c
                                                           , Std_Vertical_scribe_width_post_shrink__c
                                                           , Std_Horizontal_scribe_width_pre_shrink__c
                                                           , Std_Vertical_scribe_width_pre_shrink__c
                                                 FROM      Scribe_Width_Base_Table__c 
                                                 WHERE On_Display__c = true
                                                 ORDER BY  Sequence__c ]){
            processTechList.add(BTable.Process_Technology__c);
            processTechnologies.add(BTable.Process_Technology__c != null ? BTable.Process_Technology__c.tolowercase() : BTable.Process_Technology__c);
            /*
            if(BTable.Process_Technology__c != null && iPAccountKey != NULL && iPAccountKey != '' && iPAccountKey.tolowercase().contains(BTable.Process_Technology__c.tolowercase())) {
              isAccountPTFound = true;
              currntPT = BTable.Process_Technology__c;
            }
            else if(BTable.Process_Technology__c != null && currentPT != NULl && currentPT != '' && currentPT.tolowercase().contains(BTable.Process_Technology__c.tolowercase())) {
              isPTFound = true; 
              currntPT = BTable.Process_Technology__c;
            }
            */
            if(BTable.Process_Technology_Number__c != null && iPAccountKey != NULL && iPAccountKey != '' && iPAccountKey == BTable.Process_Technology_Number__c) {
              isAccountPTFound = true;
              currntPT = BTable.Process_Technology__c;
            }
            /*
            else if(BTable.Process_Technology__c != null && currentPT != NULl && currentPT != '' && currentPT.tolowercase().contains(BTable.Process_Technology__c.tolowercase())) {
              isPTFound = true; 
              currntPT = BTable.Process_Technology__c;
            }
            */
            if(BTable.Std_Horizontal_scribe_width_post_shrink__c == NULL) {
              BTable.Std_Horizontal_scribe_width_post_shrink__c = 0;
            }
            if(BTable.Std_Vertical_scribe_width_post_shrink__c == NULL) {
              BTable.Std_Vertical_scribe_width_post_shrink__c  = 0;
            }
           
            mpPTBaseData.put(BTable.Process_Technology__c.toUpperCase(),BTable);
            
            mpBaseTableData.put(BTable.Process_Technology__c+'--opManStr--H',String.valueOf(BTable.Optical_and_Manufacturing_Structures_H__c)==null?'':String.valueOf(BTable.Optical_and_Manufacturing_Structures_H__c));
            mpBaseTableData.put(BTable.Process_Technology__c+'--opManStr--V',String.valueOf(BTable.Optical_and_Manufacturing_Structures_V__c)==null?'':String.valueOf(BTable.Optical_and_Manufacturing_Structures_V__c));
            mpBaseTableData.put(BTable.Process_Technology__c+'--elecWatDisStruct--H',String.valueOf(BTable.Electrical_Wafer_Disposition_StructuresH__c)==null?'':String.valueOf(BTable.Electrical_Wafer_Disposition_StructuresH__c));
            mpBaseTableData.put(BTable.Process_Technology__c+'--elecWatDisStruct--V',String.valueOf(BTable.Electrical_Wafer_Disposition_StructuresV__c)==null?'':String.valueOf(BTable.Electrical_Wafer_Disposition_StructuresV__c));
            mpBaseTableData.put(BTable.Process_Technology__c+'--elecWatRelStruct--H',String.valueOf(BTable.Electrical_Reliability_Structures_H__c)==null?'':String.valueOf(BTable.Electrical_Reliability_Structures_H__c));
            mpBaseTableData.put(BTable.Process_Technology__c+'--elecWatRelStruct--V',String.valueOf(BTable.Electrical_Reliability_Structures_V__c)==null?'':String.valueOf(BTable.Electrical_Reliability_Structures_V__c));
            mpBaseTableData.put(BTable.Process_Technology__c+'--elecYieldBrUpStruct--H',String.valueOf(BTable.Electrical_Yield_Bring_Up_Structures_H__c)==null?'':String.valueOf(BTable.Electrical_Yield_Bring_Up_Structures_H__c));
            mpBaseTableData.put(BTable.Process_Technology__c+'--elecYieldBrUpStruct--V',String.valueOf(BTable.Electrical_Yield_Bring_Up_Structures_V__c)==null?'':String.valueOf(BTable.Electrical_Yield_Bring_Up_Structures_V__c));
            mpBaseTableData.put(BTable.Process_Technology__c+'--elecDebCustStruct--H',String.valueOf(BTable.Electrical_Debugging_Customer_StructureH__c)==null?'':String.valueOf(BTable.Electrical_Debugging_Customer_StructureH__c));
            mpBaseTableData.put(BTable.Process_Technology__c+'--elecDebCustStruct--V',String.valueOf(BTable.Electrical_Debugging_Customer_StructureV__c)==null?'':String.valueOf(BTable.Electrical_Debugging_Customer_StructureV__c));
        }
        if(isAccountPTFound) {
          iPAccountKey = currntPT;
        }
        /*
        else if(!isAccountPTFound && isPTFound) {
          iPAccountKey = currntPT;
        }
        */
        else {
          iPAccountKey = NULL;
          mpPTBaseData.put(iPAccountKey,new Scribe_Width_Base_Table__c(Std_Horizontal_scribe_width_post_shrink__c = 0,Std_Vertical_scribe_width_post_shrink__c = 0));
        }
    }   
    
    // method tp save the data
    public pagereference saveDie(){
        try {
          update device;
        } 
        catch(Exception de) {
          ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, de.getMessage());
          ApexPages.addMessage(myMsg);
          return NULL;
        }
        return (new pagereference ('/'+configID ));
    }
 
}