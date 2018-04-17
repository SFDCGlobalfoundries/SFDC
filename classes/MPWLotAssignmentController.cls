/**
* Author: Anil Kumar
* Company: JK Technosoft
* Project: MPW
* Description: Used for assignment of splitted Manufacturing Lot to Prime Die
* History:
*    Anil Kumar 28/04/2016 - Created
**/
public with sharing class MPWLotAssignmentController {

    public List<MfgLotWrapper> lstMgfLot                    {get; set;}
    public List<MPWWIPLotPopoupWrapper> lstPopupMPWWIPLot   {get; set;}
    public String strSearchTxtLot                           {get; set;}
    public String strSearchTxtDevice                        {get; set;}
    public String strParentLot                              {get; set;}
    public String strMfgLot                                 {get; set;}
    public String strMfgLotId                               {get; set;}
    public String strMPWTrain                               {get; set;}
    public String strAssignmentName                         {get; set;}
    public Integer intAssignmentInterval                    {get; set;}
    
    public MPWLotAssignmentController(){
        initializeVariables();
    }
    
    /*
    * Description : Method for initializing all variables
    */
    private void initializeVariables(){
        lstMgfLot = new List<MfgLotWrapper>();
        lstPopupMPWWIPLot = new List<MPWWIPLotPopoupWrapper>();
        strSearchTxtLot = '';
        strSearchTxtDevice = '';
        strParentLot = '';
        strMfgLot = '';
        strMfgLotId = '';
        strMPWTrain = '';
        strAssignmentName = '';
        intAssignmentInterval = 0;
    }
    
    /*
    * Description : Method to retrieve Manufacturing Lot based on filter selected.
    */
    public void loadMfgLot(){
        lstMgfLot = new List<MfgLotWrapper>();
        
        Set<String> setMfgLotIds = new Set<String>();  
        Map<String, List<Manufacturing_Lot__c>> mapParentLotIdToMfgLots = new Map<String, List<Manufacturing_Lot__c>>();
        Map<String, Manufacturing_Lot__c> mapMfgLotInfo = new Map<String, Manufacturing_Lot__c>();
        Map<String, Map<String, List<Manufacturing_Lot__c>>> mapParentOfParentLotIdToMfgLots = new Map<String, Map<String, List<Manufacturing_Lot__c>>>();
        Map<String, List<MPW_WIP_Lot__c>> mapMfgLotIdToMPWWIPLot = new Map<String, List<MPW_WIP_Lot__c>>();
        Set<String> setAccountIds = new Set<String>();
        
        for(MPWAssignment__c oCS : [SELECT Id, Name, AccountId__c FROM MPWAssignment__c WHERE AccountId__c != NULL ]) {
            setAccountIds.add(oCS.AccountId__c);
        }
        
        String strQuery = 'SELECT Id, Name, Active_Flag__c, Manufacturing_Lot_Id__c, Device_ID_MES__c, Fab_Group__c, Start_Lot_Quantity__c, Parent_Lot_Id__c, '+
                            'Account_Name__c, Account_Name__r.Name, Lot_Type__c, Sales_Order_Number__c, Process_Name__c, Geometry__c, Technology_Type__c, '+
                            'Lot_Start_Date__c, Current_Wafer_Quantity_In_Lot__c, Current_Mask_Layer_Being_Processed__c, Remaining_Mask_Count__c, '+ 
                            'Current_Scheduled_Date_CSD__c, Ship_To_Location__c, Total_Mask_Count__c '+
                            'FROM Manufacturing_Lot__c '+
                            'WHERE Active_Flag__c = true AND Manufacturing_Lot_Id__c != NULL ';
        
        if(setAccountIds.size() > 0) {
            strQuery += ' AND Account_Name__c IN: setAccountIds ';
        }
        
        if(strSearchTxtLot != null) {
            strSearchTxtLot = String.escapeSingleQuotes(strSearchTxtLot).trim();
        }
        if(strSearchTxtDevice != null) {
            strSearchTxtDevice = String.escapeSingleQuotes(strSearchTxtDevice).trim();
        }
        
        try{
            if((strSearchTxtLot != null && strSearchTxtLot != '') || (strSearchTxtDevice != null && strSearchTxtDevice != '')) {
            
                if(strSearchTxtLot != null && strSearchTxtLot != '' && strSearchTxtDevice != null && strSearchTxtDevice != '') {
                    strQuery += ' AND (Manufacturing_Lot_Id__c =: strSearchTxtLot OR Parent_Lot_Id__c =: strSearchTxtLot OR Device_ID_MES__c LIKE \'' + strSearchTxtDevice + '%\') ';
                }
                else if(strSearchTxtLot != null && strSearchTxtLot != '' && (strSearchTxtDevice == null || strSearchTxtDevice == '')) {
                    strQuery += ' AND (Manufacturing_Lot_Id__c =: strSearchTxtLot OR Parent_Lot_Id__c =: strSearchTxtLot) ';
                }
                else if(strSearchTxtDevice != null && strSearchTxtDevice != '' && (strSearchTxtLot == null || strSearchTxtLot == '')) {
                    strQuery += ' AND Device_ID_MES__c LIKE \'' + strSearchTxtDevice + '%\'';
                }
                strQuery += ' LIMIT 10000';
                
                //Prepare map of parent Manufacturing lot to immediate child Manufacturing lots
                for(Manufacturing_Lot__c objMfg : database.query(strQuery)){
                    Integer intCML = objMfg.Current_Mask_Layer_Being_Processed__c != null ? Integer.valueOf(objMfg.Current_Mask_Layer_Being_Processed__c) : 0;
                    Integer intRMC = objMfg.Remaining_Mask_Count__c != null ? Integer.valueOf(objMfg.Remaining_Mask_Count__c) : 0;
                    
                    if(!(intCML == 0 && intRMC == 0)) {
                        objMfg.Parent_Lot_Id__c = objMfg.Parent_Lot_Id__c != null ? objMfg.Parent_Lot_Id__c : objMfg.Manufacturing_Lot_Id__c;
                        if(!mapParentLotIdToMfgLots.containsKey(objMfg.Parent_Lot_Id__c)) {
                            mapParentLotIdToMfgLots.put(objMfg.Parent_Lot_Id__c, new List<Manufacturing_Lot__c>{objMfg});
                        }
                        else {
                            List<Manufacturing_Lot__c> lstMfgLotTemp = mapParentLotIdToMfgLots.get(objMfg.Parent_Lot_Id__c);
                            lstMfgLotTemp.add(objMfg);
                            mapParentLotIdToMfgLots.put(objMfg.Parent_Lot_Id__c, lstMfgLotTemp);
                        }
                        mapMfgLotInfo.put(objMfg.Manufacturing_Lot_Id__c, objMfg);
                    }
                }
                
                for(String strKey : mapParentLotIdToMfgLots.keySet()) {
                    if(!mapMfgLotInfo.containsKey(strKey)) {
                        setMfgLotIds.add(strKey);
                    }
                }
                
                //Preparing map of Parent Manufacturing Lot information
                for(Manufacturing_Lot__c objMfg : [SELECT Id, Name, Active_Flag__c, Manufacturing_Lot_Id__c, Device_ID_MES__c, Fab_Group__c, 
                                                    Start_Lot_Quantity__c, Parent_Lot_Id__c, Technology_Type__c, Process_Name__c, Geometry__c, 
                                                    Account_Name__c, Account_Name__r.Name, Lot_Type__c, Sales_Order_Number__c, Lot_Start_Date__c, 
                                                    Current_Wafer_Quantity_In_Lot__c, Current_Mask_Layer_Being_Processed__c, Remaining_Mask_Count__c, 
                                                    Total_Mask_Count__c, Current_Scheduled_Date_CSD__c, Ship_To_Location__c 
                                                    FROM Manufacturing_Lot__c 
                                                    WHERE Manufacturing_Lot_Id__c IN: setMfgLotIds]) {
                    mapMfgLotInfo.put(objMfg.Manufacturing_Lot_Id__c, objMfg);
                }
                
                Set<String> setParentMfgLot1 = new Set<String>();
                Set<String> setParentMfgLot2 = new Set<String>();
                for(String strKey : mapParentLotIdToMfgLots.keySet()) {
                    for(Manufacturing_Lot__c oMfg : mapParentLotIdToMfgLots.get(strKey)) {
                        if(mapParentLotIdToMfgLots.containsKey(oMfg.Manufacturing_Lot_Id__c) && oMfg.Manufacturing_Lot_Id__c != strKey) {
                            Map<String, List<Manufacturing_Lot__c>> mapTemp = new Map<String, List<Manufacturing_Lot__c>>();
                            mapTemp.put(oMfg.Manufacturing_Lot_Id__c, mapParentLotIdToMfgLots.get(oMfg.Manufacturing_Lot_Id__c));
                            mapParentOfParentLotIdToMfgLots.put(strKey, mapTemp);
                            setParentMfgLot1.add(strKey);
                            setParentMfgLot2.add(oMfg.Manufacturing_Lot_Id__c);
                        }
                        else if(mapParentLotIdToMfgLots.containsKey(oMfg.Manufacturing_Lot_Id__c) && oMfg.Manufacturing_Lot_Id__c == strKey) {
                            Map<String, List<Manufacturing_Lot__c>> mapTemp = new Map<String, List<Manufacturing_Lot__c>>();
                            List<Manufacturing_Lot__c> lstTemp = new List<Manufacturing_Lot__c>();
                            for(Manufacturing_Lot__c oMfg1 : mapParentLotIdToMfgLots.get(oMfg.Manufacturing_Lot_Id__c)) {
                                if(oMfg1.Manufacturing_Lot_Id__c != strKey) {
                                    lstTemp.add(oMfg1);
                                }
                            }
                            mapTemp.put(oMfg.Manufacturing_Lot_Id__c, lstTemp);
                            mapParentOfParentLotIdToMfgLots.put(strKey, mapTemp);
                            setParentMfgLot1.add(strKey);
                            setParentMfgLot2.add(oMfg.Manufacturing_Lot_Id__c);
                        }
                    }
                }
                
                for(String strKey : mapParentLotIdToMfgLots.keySet()) {
                    if(!setParentMfgLot1.contains(strKey) && !setParentMfgLot2.contains(strKey)) {
                        for(Manufacturing_Lot__c oMfg : mapParentLotIdToMfgLots.get(strKey)) {
                            Map<String, List<Manufacturing_Lot__c>> mapTemp = new Map<String, List<Manufacturing_Lot__c>>();
                            mapTemp.put(oMfg.Manufacturing_Lot_Id__c, mapParentLotIdToMfgLots.get(strKey));
                            mapParentOfParentLotIdToMfgLots.put(strKey, mapTemp);
                        }
                    }
                }
                
                //Preparing map of assigned Prime Die of Mfg Lot
                for(MPW_WIP_Lot__c objMPWWIP : [SELECT Id, Manufacturing_Lot__c, Manufacturing_Lot__r.Manufacturing_Lot_Id__c, 
                                                Manufacturing_Lot__r.Parent_Lot_Id__c, MPW_Prime_Die__r.MPW_Form__r.Name, 
                                                MPW_Prime_Die__r.Account_Name__c,
                                                Bare_Die_Shipment_Forecast_Date_BL__c, Bare_Die_Shipment_Forecast_Date_OR__c, 
                                                MPW_MES_Part_ID__c, Current_Scheduled_Date_CSD__c, Current_Scheduled_Date_CSD_OR__c,
                                                Assignment_Type__c, MPW_Prime_Die__c, MPW_Prime_Die__r.Name, MPW_Prime_Die__r.MPW_Train__c, 
                                                MPW_Prime_Die__r.MPW_Form__r.Id, MPW_Prime_Die__r.Process_Type__c, 
                                                MPW_Prime_Die__r.Prime_Die_Name__c 
                                                FROM MPW_WIP_Lot__c WHERE Manufacturing_Lot__r.Manufacturing_Lot_Id__c IN: mapMfgLotInfo.keySet()]) {
                    String strKey = objMPWWIP.Manufacturing_Lot__r.Manufacturing_Lot_Id__c;
                    if(!mapMfgLotIdToMPWWIPLot.containsKey(strKey)) {
                        mapMfgLotIdToMPWWIPLot.put(strKey, new List<MPW_WIP_Lot__c>{objMPWWIP});
                    }
                    else {
                        List<MPW_WIP_Lot__c> lstMPWWIPTemp = mapMfgLotIdToMPWWIPLot.get(strKey); 
                        lstMPWWIPTemp.add(objMPWWIP);
                        mapMfgLotIdToMPWWIPLot.put(strKey, lstMPWWIPTemp);
                    }
                }
                
                for(String strKey1 : mapParentOfParentLotIdToMfgLots.keySet()) {
                    MfgLotInfoWrapper objParentMfgLotInfoWrapper = new MfgLotInfoWrapper();
                    objParentMfgLotInfoWrapper.strMfgLot = strKey1;
                    objParentMfgLotInfoWrapper.objMfgLot = mapMfgLotInfo.get(strKey1);
                    objParentMfgLotInfoWrapper.lstMPWWIPLot = mapMfgLotIdToMPWWIPLot.get(strKey1);
        
                    MfgLotWrapper objMfgLotWrapper = new MfgLotWrapper();
                    objMfgLotWrapper.objParentMfgLot = objParentMfgLotInfoWrapper;
                    
                    MfgLotInfoWrapper objMfgLotInfoWrapper = new MfgLotInfoWrapper();
                    objMfgLotInfoWrapper.strMfgLot = '';
                    objMfgLotInfoWrapper.objMfgLot = new Manufacturing_Lot__c();
                    objMfgLotInfoWrapper.lstMPWWIPLot = new List<MPW_WIP_Lot__c>();
                    objMfgLotWrapper.objMfgLot = objMfgLotInfoWrapper;
                    
                    List<MfgLotInfoWrapper> lstChildMfgLotTemp = new List<MfgLotInfoWrapper>();
                    
                    for(String strKey2 : mapParentOfParentLotIdToMfgLots.get(strKey1).keySet()) {
                        if(strKey1 != strKey2) {
                            objMfgLotInfoWrapper.strMfgLot = strKey2;
                            objMfgLotInfoWrapper.objMfgLot = mapMfgLotInfo.get(strKey2);
                            objMfgLotInfoWrapper.lstMPWWIPLot = mapMfgLotIdToMPWWIPLot.get(strKey2);
                            objMfgLotWrapper.objMfgLot = objMfgLotInfoWrapper;
                        }
                        
                        for(Manufacturing_Lot__c oMfg : mapParentOfParentLotIdToMfgLots.get(strKey1).get(strKey2)) {
                            if(oMfg.Manufacturing_Lot_Id__c != strKey1 && oMfg.Manufacturing_Lot_Id__c != strKey2) {
                                MfgLotInfoWrapper objChildMfgLotInfoWrapper = new MfgLotInfoWrapper();
                                objChildMfgLotInfoWrapper.strMfgLot = oMfg.Manufacturing_Lot_Id__c;
                                objChildMfgLotInfoWrapper.objMfgLot = oMfg;
                                objChildMfgLotInfoWrapper.lstMPWWIPLot = mapMfgLotIdToMPWWIPLot.get(oMfg.Manufacturing_Lot_Id__c);
                                lstChildMfgLotTemp.add(objChildMfgLotInfoWrapper);
                            }
                        }
                    }
                    
                    objMfgLotWrapper.lstChildMfgLot = lstChildMfgLotTemp;
                    lstMgfLot.add(objMfgLotWrapper);
                }
                
                if(lstMgfLot.size() > 0 && (strParentLot == null || strParentLot.trim() == '')) {
                    strParentLot = lstMgfLot[0].objParentMfgLot.strMfgLot;
                }
            }
        }
        catch(Exception ex) {
            ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR, ex.getMessage());
            ApexPages.addMessage(msg);
            MPWExceptionHandler.exceptionHandler(ex, MPWLotAssignmentController.class.getName(), 'loadMfgLot()', '', 'Manufacturing Lot Assignment');
        }
    }
    
    /*
    * Description : Method to get list of MPW_WIP_Lot__c for selected Mfg Lot
    */
    public void loadPopupMPWWIPLot(){
        lstPopupMPWWIPLot = new List<MPWWIPLotPopoupWrapper>();
        Set<Id> setExistingPrimeDieIds = new Set<Id>();
        
        try {
            //Adding selected WIP to list of Popup
            for(MPW_WIP_Lot__c objMPWWIP : [SELECT Id, Manufacturing_Lot__c, Manufacturing_Lot__r.Manufacturing_Lot_Id__c, 
                                            Manufacturing_Lot__r.Parent_Lot_Id__c, Bare_Die_Shipment_Forecast_Date_BL__c, 
                                            Bare_Die_Shipment_Forecast_Date_OR__c, MPW_MES_Part_ID__c, Assignment_Type__c, 
                                            MPW_Prime_Die__c, MPW_Prime_Die__r.Name, MPW_Prime_Die__r.MPW_Train__c, 
                                            MPW_Prime_Die__r.MPW_Form__r.Name, Current_Scheduled_Date_CSD__c, Current_Scheduled_Date_CSD_OR__c,
                                            MPW_Prime_Die__r.MPW_Form__r.Id, MPW_Prime_Die__r.Process_Type__c, 
                                            MPW_Prime_Die__r.Prime_Die_Name__c, 
                                            MPW_Prime_Die__r.Account_Name__c                                     
                                            FROM MPW_WIP_Lot__c 
                                            WHERE Manufacturing_Lot__c =: strMfgLotId ORDER BY MPW_Prime_Die__r.Prime_Die_Name__c]) {
                MPWWIPLotPopoupWrapper oMfgLotMPWWIPLot = new MPWWIPLotPopoupWrapper();
                oMfgLotMPWWIPLot.objMfgLotMPWWIPLot = objMPWWIP;
                oMfgLotMPWWIPLot.isSelected = true;
                lstPopupMPWWIPLot.add(oMfgLotMPWWIPLot);
                setExistingPrimeDieIds.add(objMPWWIP.MPW_Prime_Die__c);
            }
            
            Integer intLimit = (1000 - lstPopupMPWWIPLot.size()); //Used to add only 1000 records in list to avoid exception
            
            String strMPWTrainTemp = String.escapeSingleQuotes(strMPWTrain);
            String strQuery = 'SELECT Id, Name, Prime_Die_Name__c, MPW_Train__c, MPW_Form__r.Id, MPW_Form__r.Name, Process_Type__c, Account_Name__c ' +
                                'FROM MPW_Prime_Die__c WHERE Id NOT IN: setExistingPrimeDieIds AND MPW_Train__c =: strMPWTrainTemp AND ' +
                                '(MPW_Form__r.Category__c = \'Customer\' OR MPW_Form__r.Category__c = \'IP\') AND ' +
                                '(MPW_Form__r.Form_Status__c = \'Accepted by MPW Tapeout\' ' +
                                'OR MPW_Form__r.Form_Status__c = \'Accepted by CE\' OR MPW_Form__r.Form_Status__c = \'Accepted by Turnkey\') ' +
                                'ORDER BY Prime_Die_Name__c LIMIT ' + intLimit;     
            
            for(MPW_Prime_Die__c oPD : database.query(strQuery)) {
                MPWWIPLotPopoupWrapper oMfgLotMPWWIPLot = new MPWWIPLotPopoupWrapper();
                MPW_WIP_Lot__c objMPWWIPLot = new MPW_WIP_Lot__c();
                objMPWWIPLot.MPW_Prime_Die__r = oPD;
                objMPWWIPLot.MPW_Prime_Die__c = oPD.Id;
                oMfgLotMPWWIPLot.objMfgLotMPWWIPLot = objMPWWIPLot;
                oMfgLotMPWWIPLot.isSelected = false;
                lstPopupMPWWIPLot.add(oMfgLotMPWWIPLot);
            }
            
            strAssignmentName = strMPWTrainTemp;
        }
        catch(Exception ex) {
            ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR, ex.getMessage());
            ApexPages.addMessage(msg);
            MPWExceptionHandler.exceptionHandler(ex, MPWLotAssignmentController.class.getName(), 'loadPopupMPWWIPLot()', '', 'Manufacturing Lot Assignment');
        }
    }
    
    /*
    * Description : Method to assign Prime Dies to Manufacturing Lot
    */
    public void saveLotAssignment(){
        List<MPW_WIP_Lot__c> lstMPWWIPLotToBeDelete = new List<MPW_WIP_Lot__c>();
        List<MPW_WIP_Lot__c> lstMPWWIPLotToBeUpsert = new List<MPW_WIP_Lot__c>();
        List<MPW_WIP_Lot__c> lstMPWWIPLotTemp = new List<MPW_WIP_Lot__c>();
        Set<Id> setMPWWIPLotIds = new Set<Id>();
        
        Savepoint sp = Database.setSavepoint();
        
        try {
            strAssignmentName = strAssignmentName != null ? String.escapeSingleQuotes(strAssignmentName): '';
            
            for(MPWWIPLotPopoupWrapper oW : lstPopupMPWWIPLot) {
                if(oW.isSelected) {
                    MPW_WIP_Lot__c oMfgLotMPWWIPLot = oW.objMfgLotMPWWIPLot;
                    oMfgLotMPWWIPLot.Manufacturing_Lot__c = strMfgLotId;
                    oMfgLotMPWWIPLot.Saved_User__c = UserInfo.getUserId();
                    oMfgLotMPWWIPLot.Assignment_Group_Name__c = strAssignmentName;
                    oMfgLotMPWWIPLot.Notification_Interval_Days__c = intAssignmentInterval;
                    lstMPWWIPLotToBeUpsert.add(oMfgLotMPWWIPLot);
                    if(oW.objMfgLotMPWWIPLot.Id != null) {
                        setMPWWIPLotIds.add(oW.objMfgLotMPWWIPLot.Id);
                    }
                }
            }
            
            for(MPW_WIP_Lot__c oW : [SELECT Id, Manufacturing_Lot__c FROM MPW_WIP_Lot__c 
                                     WHERE Manufacturing_Lot__c =: strMfgLotId AND Id NOT IN: setMPWWIPLotIds]) {
                lstMPWWIPLotToBeDelete.add(oW);
            }
            
            if(lstMPWWIPLotToBeDelete.size() > 0) {
                delete lstMPWWIPLotToBeDelete;
            }
            
            if(lstMPWWIPLotToBeUpsert.size() > 0) {
                upsert lstMPWWIPLotToBeUpsert;
            }
            
            //Preparing map of assigned Prime Die of Child Lot
            for(MPW_WIP_Lot__c objMPWWIP : [SELECT Id, Manufacturing_Lot__c, Manufacturing_Lot__r.Manufacturing_Lot_Id__c, 
                                            Manufacturing_Lot__r.Parent_Lot_Id__c, Assignment_Type__c, 
                                            Bare_Die_Shipment_Forecast_Date_BL__c, Bare_Die_Shipment_Forecast_Date_OR__c, MPW_MES_Part_ID__c, 
                                            MPW_Prime_Die__c, MPW_Prime_Die__r.Name, MPW_Prime_Die__r.MPW_Train__c, 
                                            MPW_Prime_Die__r.MPW_Form__r.Name, Current_Scheduled_Date_CSD__c, Current_Scheduled_Date_CSD_OR__c,
                                            MPW_Prime_Die__r.MPW_Form__r.Id, MPW_Prime_Die__r.Process_Type__c, 
                                            MPW_Prime_Die__r.Prime_Die_Name__c, 
                                            MPW_Prime_Die__r.Account_Name__c                                     
                                            FROM MPW_WIP_Lot__c 
                                            WHERE Manufacturing_Lot__c =: strMfgLotId]) {
                lstMPWWIPLotTemp.add(objMPWWIP);
            }
            
            for(MfgLotWrapper oMfg : lstMgfLot) {
                if(oMfg.objMfgLot.objMfgLot.Id == strMfgLotId) {
                    oMfg.objMfgLot.lstMPWWIPLot = lstMPWWIPLotTemp;
                }
                else if(oMfg.objParentMfgLot.objMfgLot.Id == strMfgLotId) {
                    oMfg.objParentMfgLot.lstMPWWIPLot = lstMPWWIPLotTemp;
                }
                else {
                    for(MfgLotInfoWrapper oMfgInfo : oMfg.lstChildMfgLot) {
                        if(oMfgInfo.objMfgLot.Id == strMfgLotId) {
                            oMfgInfo.lstMPWWIPLot = lstMPWWIPLotTemp;
                        }
                    }
                }
            }
        }
        catch(Exception ex) {
            Database.rollback(sp);
            ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR, ex.getMessage());
            ApexPages.addMessage(msg);
            MPWExceptionHandler.exceptionHandler(ex, MPWLotAssignmentController.class.getName(), 'saveLotAssignment()', '', 'Manufacturing Lot Assignment');
        }
    }
    
    public class MfgLotWrapper {
        public MfgLotInfoWrapper objParentMfgLot            {get; set;}
        public MfgLotInfoWrapper objMfgLot                  {get; set;}
        public List<MfgLotInfoWrapper> lstChildMfgLot       {get; set;}
    }
    
    public class MfgLotInfoWrapper {
        public String strMfgLot                             {get; set;}
        public Manufacturing_Lot__c objMfgLot               {get; set;}
        public List<MPW_WIP_Lot__c> lstMPWWIPLot            {get; set;}
    }
    
    public class MPWWIPLotPopoupWrapper {
        public MPW_WIP_Lot__c objMfgLotMPWWIPLot            {get; set;}
        public Boolean isSelected                           {get; set;}
    }
}