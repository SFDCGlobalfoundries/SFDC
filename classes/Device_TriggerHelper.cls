/*************************************************************************************************************************************************************
@ Class:          Device_TriggerHelper
@ Version:        1.0
@ Author:         Ishtpreet Singh (Ishtpreet.singh@globalfoundries.com)
@ Purpose:        Helper class which consist of logics used in Device Triggers.
--------------------------------------------------------------------------------------------------------------------------------------------------------------
@ Change history: 26.08.2016 / Ishtpreet Singh / Created the class.
// Jabee : updated the line 1028-1046 for null value check
@ Change history: 15.05.2017 / Pradosh Samal / Added updatGenerateStandardFrame method.
Ravi Teja.B / 15.06.2017 / Modified deviceUpdateBefore method for CDRS Approvals User Population @LineNum:927.
Ravi Teja.B / 03.07.2017 / Added different runOnce Variable in deviceMaskSetTitlelookUp @ LineNum: 518.
Ravi Teja.B / 21.07.2017 / As Approval Stage of Configurator has been added with new Process Flow Accepted Values changes are made accordingly.
Devendra / 28.08.2017 / updated changes name change validation and AUto generate masksettitle for Fab9 , 10 & altis.
Devendra / 12.09.2017 / Added DeviceToERPDeviceDataFlow and updateERPDevices method.
DBiswal  / 12.10.2017 / Commented for psp bug of deleting psp volumes(line no. 106-120).
**************************************************************************************************************************************************************/
Public Class Device_TriggerHelper{
    
    /*Global Variables*/
    public       List<Device__c>                              lstDevice              { get; set; } //List of Devices
    public       List<String>                                 lstPickvals            { get; set; } //List of Picklist values for Phase__c field
    public       Map<string,integer>                          mapOpptyStage          { get; set; } // Map to store Opportunity Stage
    public       Map<Id,Device__c>                            triggerOldMap          { get; set; } //Map to store old record values of Device object
    public       Map<Id,Device__c>                            triggerNewMap          { get; set; } //Map to store New record values of Device object 
    public       List<DevicePSPData__c>                       lstPSPRecords          { get; set; } //List to store the Device PSP Data object records
    public       Map<String, Device__c>                       DeviceMap              { get; set; } //Map of string and object to store the string and Device records 
    public       List<Id>                                     opProg                 { get; set; } //List of Ids of Opportunity for Stage 
    public       List<Id>                                     opProgProd             { get; set; } //List of Ids of Opportunity for stage and status 
    public       List<Opportunity_Program_Team_Member__c>     oppTeamMember          { get; set; } //List of Opportunity Program Team Members of opportunity program
    public       List<Device__c>                              deviceDoNotUpdate      { get; set; } //List of Devices for which status can't be updated to On Hold
    public       List<Device__c>                              deviceDoNotUpdate1     { get; set; } //List of Devices for which status can't be updated to On Hold if the user is not part of opportunity Team members 
    public       set<id>                                      oppProg                { get; set; } //Set of Opportunity Program Ids which are part of trigger.new
    public       set<id>                                      oppProgDoNotUpdate     { get; set; } //Set of Opportunity Program associated to Devices for which status can't be updated to On Hold
    public       set<id>                                      oppProgDoNotUpdate1    { get; set; } //Set of Opportunity Program associated to Devices for which status can't be updated to On Hold if the user is not part of opportunity Team members 
    public       boolean uFlag = false; //Flag to check whether current user is Opportunity Program Team Members 
    public       boolean statusChngFlag = false; //Flag to check whether the status is updated to 'On Hold' or on 'On Hold' to Active/Inactive/Void 
    
    /*String Variables*/        
    public       String stageTapeout = EnvironmentVariable.get('DEVICE_TAPEOUT');
    public       String deviceProd = EnvironmentVariable.get('DEVICE_PROD');
    public       String oppStgNm6 = EnvironmentVariable.get('OPP_STG_NM_6');
    public       String oppStgNm7 = EnvironmentVariable.get('OPP_STG_NM_7');
    public       String oppStatus = EnvironmentVariable.get('OPP_STATUS');
    public       String tapeoutGlobalShuttle = EnvironmentVariable.get('TAPEOUT_TYPE_MPW');
    public       String errorMsgD1NatAccess = Error_Codes__c.getInstance('DEV_D1_NAT_ACCESS_VALIDATION_MSG').Message__c;
    public final string DEVICE_DESIGN_IN = Environment_Variable__c.getInstance('DEVICE_DESIGN_IN').Value__c;
    public final string DEVICE_TAPEOUT = Environment_Variable__c.getInstance('DEVICE_STAGE_TAPEOUT').Value__c;
    public final string DEVICE_TYPE_RETROFIT = Environment_Variable__c.getInstance('DEVICE_TYPE_RETROFIT').Value__c;
    public final string DEVICE_DEFAULT_TYPE = EnvironmentVariable.get('DEVICE_DEFAULT_TYPE');
    public final string DEVICE_DEFAULT_REVISION = EnvironmentVariable.get('DEVICE_DEFAULT_REVISION');
    public final string DEVICE_DEFAULT_BX041_STATUS = EnvironmentVariable.get('DEVICE_DEFAULT_BX041_STATUS');
    public static boolean stopMSTTriggerforFab9_10=false;
      
    /*********************************************************************************************************************************************************
    @ Constructor:    Device_TriggerHelper
    @ Version:        1.0
    @ Author:         Ishtpreet Singh (Ishtpreet.singh@globalfoundries.com)
    @ Purpose:        Initialises the class for controller instance.
    **********************************************************************************************************************************************************/  
    public Device_TriggerHelper(){
        lstDevice = new List<Device__c>();
        lstPickvals=new List<String>();
        triggerOldMap = ((Map<Id,Device__c>)Trigger.oldMap);
        triggerNewMap = ((Map<Id,Device__c>)Trigger.newMap);
        lstPSPRecords = new List<DevicePSPData__c>();
        opProg = new List<Id>();
        opProgProd = new List<Id>();
        oppTeamMember = new List<Opportunity_Program_Team_Member__c>();
        deviceDoNotUpdate = new List<Device__c>();
        deviceDoNotUpdate1 = new List<Device__c>();
        oppProg = new set<Id>();
        oppProgDoNotUpdate = new set<Id>();
        oppProgDoNotUpdate1 = new set<Id>();
        mapOpptyStage = new Map<string,integer>{'1. Discovery'=>1,
                                                '2. Assessment'=>2,
                                                '3. Recommendation'=>3,
                                                '4. Decision'=>4,
                                                '5. Commitment'=>5,
                                                oppStgNm6=>6,
                                                oppStgNm7=>7,
                                                '8. Lost'=>8,
                                                '9. Dropped'=>9,
                                                '10. Void'=>10};
      
          
    }
    /*********************************************************************************************************************************************************
    @ Method:         creatDevicePSP
    @ Version:        1.0
    @ Author:         Ishtpreet Singh (Ishtpreet.singh@globalfoundries.com)
    @ Purpose:        This Method creates/resets DevicePSP Data records whenever the device record is created or PSP dates are changed.
    **********************************************************************************************************************************************************/   
    public void creatDevicePSP(){
        system.debug('start>>>>>>>>>>creatDevicePSP :SOQL queries:'+limits.getQueries());
        if(System.Label.DevicePSPtrigger_Active.equalsIgnoreCase('true')){
            List<Device__c> lstDevice1 = new List<Device__c>();
            Device__c dev = (Device__c)Trigger.new[0];            
            If(dev.Tapeout_Type__c =='Single Product') {  
            if(Trigger.isInsert){
                for(Device__c deviceRec: (List<Device__c >)Trigger.new){
                    if(deviceRec.Product_TO_Date__c  != NULL && deviceRec.Forecasted_Production_Start_Date__c != NULL){
                        lstDevice1.add(deviceRec);
                    }        
                }
            }
            
            /*else if(Trigger.isUpdate){
                for(Device__c deviceRec: (List<Device__c >)Trigger.new){
                    if(deviceRec.Product_TO_Date__c  != NULL && deviceRec.Forecasted_Production_Start_Date__c != NULL &&
                    (  deviceRec.Product_TO_Date__c != triggerOldMap.get(deviceRec.id).Product_TO_Date__c ||
                       deviceRec.Sample_Delivery_Date__c != triggerOldMap.get(deviceRec.id).Sample_Delivery_Date__c ||
                       deviceRec.Forecasted_Proto_Date__c != triggerOldMap.get(deviceRec.id).Forecasted_Proto_Date__c ||
                       deviceRec.Forecasted_RTP_Date__c != triggerOldMap.get(deviceRec.id).Forecasted_RTP_Date__c ||
                       deviceRec.Forecasted_Production_Start_Date__c != triggerOldMap.get(deviceRec.id).Forecasted_Production_Start_Date__c ))
                    {                              
                          lstDevice.add(deviceRec);
                    }
                }          
            }*/
            if(!lstDevice1.isEmpty()){
                //database.delete([select id from DevicePSPData__c where Device__c in :lstDevice]);           
                integer startYear;
                integer endYear;
                
                Schema.SObjectType targetType = Schema.getGlobalDescribe().get('DevicePSPData__c');
                sObject Object_name = targetType.newSObject();
                Schema.sObjectType sobject_type = Object_name.getsObjectType(); //grab the sObject that was passed
                Schema.DescribeSObjectResult sobject_describe = sObject_type.getDescribe(); //describe the sObject
                Map<String, Schema.sObjectField> field_map = sObject_describe.fields.getMap(); //get a map of fields for the passed sobject
                List<Schema.PicklistEntry> pick_list_values = field_map.get('Phase__c').getDescribe().getPickListValues(); //grab the list of picklist values for the passed field on the sObject
                for (Schema.PicklistEntry a : pick_list_values){ 
                    lstPickvals.add(a.getValue());
                }
                for(Device__c deviceRec : lstDevice1){
                    startYear = deviceRec.Product_TO_Date__c.Year();
                    endYear   = deviceRec.Forecasted_Production_Start_Date__c.Year();
                    
                    for(integer i=startYear;i<=endYear;i++){
                        for(String phaseVal: lstPickvals){
                            DevicePSPData__c pspRecord = new DevicePSPData__c();
                            pspRecord.Device__c = deviceRec.id;
                            pspRecord.Phase__c  = phaseVal;
                            pspRecord.Year__c   = i;
                            if(phaseVal == 'Prototype Wafer Start'){
                                pspRecord.Phase_Number__c = 1;
                            }else if(phaseVal == 'Prototype Wafer Out'){
                                pspRecord.Phase_Number__c = 2;
                            }else if(phaseVal == 'Prototype Wafer ASP'){
                                pspRecord.Phase_Number__c = 3;
                            }else if(phaseVal == 'Production Wafer Start'){
                                pspRecord.Phase_Number__c = 4;
                            }else if(phaseVal == 'Production Wafer Out'){
                                pspRecord.Phase_Number__c = 5;
                            }else if(phaseVal == 'Production Wafer ASP'){
                                pspRecord.Phase_Number__c = 6;
                            }
                                pspRecord.Month_1__c = 0;
                                pspRecord.Month_2__c = 0;
                                pspRecord.Month_3__c = 0;
                                pspRecord.Month_4__c = 0;
                                pspRecord.Month_5__c = 0;
                                pspRecord.Month_6__c = 0;
                                pspRecord.Month_7__c = 0;
                                pspRecord.Month_8__c = 0;
                                pspRecord.Month_9__c = 0;
                                pspRecord.Month_10__c = 0;
                                pspRecord.Month_11__c = 0;
                                pspRecord.Month_12__c = 0;
                                
                                lstPSPRecords.add(pspRecord);                                                
                        }
                    }
                }
                try{
                    database.insert(lstPSPRecords);
                }
                catch (system.Dmlexception ex) {                    
                   catchCover(string.valueof(Device__c.Id),string.valueof(ex.getMessage()),'creatDevicePSP()');                          
                }                            
            }         
        }
        }
        system.debug('end>>>>>>>>>>creatDevicePSP :SOQL queries:'+limits.getQueries());
        
    }
    /*********************************************************************************************************************************************************
    @ Method:         deviceMaskSetTitleRec
    @ Version:        1.0
    @ Author:         Ishtpreet Singh (Ishtpreet.singh@globalfoundries.com)
    @ Purpose:        This Method creates / updates Mask Set title record
    **********************************************************************************************************************************************************/
    public void deviceMaskSetTitleRec(){
        system.debug('start>>>>>>>>>>deviceMaskSetTitleRec :SOQL queries:'+limits.getQueries());

        Set<String> setMaskTitle= new Set<String>();
        Set<String> setMSTIDsUpdate = new Set<String>();
        Set<String> setExistingDevice = new Set<String>();
        List<String> lstDeviceIDNew = new List<String>();
        List<String> lstDeviceIDNewSecure = new List<String>();
        List <MSTAccount__c> MSTAccountToInsert = new List <MSTAccount__c>();
        List<Mask_Set_Title__c> lstMaskSetTitle = new List<Mask_Set_Title__c>();
        List<MSTAccount__c> lstMSTAcc =new List<MSTAccount__c>();
        List<Mask_Set_Title__c> lstMaskSetTitleSecure = new List<Mask_Set_Title__c>();
        List <Mask_Set_Title__c> MSTToUpdate = new List <Mask_Set_Title__c>();
        List <Mask_Set_Title__c> MSTToUpdate2 = new List <Mask_Set_Title__c>();
        List <Mask_Set_Title__c> MSTToInsert = new List <Mask_Set_Title__c>();
        List <MSTAccount__c> MSTAccountToUpsert = new List <MSTAccount__c>();
        List<Mask_set_Title__c> lstOldMSTUpdate = new List<Mask_set_Title__c>();
        List<Mask_set_Title__c> MSTUpdateList = new List<Mask_set_Title__c>();
        List<id> MSTIdList = new List<id>();        
        List<id> lstOldMSTId = new List<id>();
        Map<id,Double> mapMSTPimeDie = new Map<id,Double>();
        Map<String, MSTAccount__c> MSTMSTAccountMap = new Map<String, MSTAccount__c>();
        Map<ID, Mask_Set_Title__c> DeviceMSTMap = new Map<ID, Mask_Set_Title__c>();
        Map<Id, Boolean> mapPTRFCheck = new Map<ID,Boolean>();
        Map<ID, ID> mapDeviceMSTIdSecure = new Map<ID, ID>();
        Map<ID, ID> mapDeviceMSTId = new Map<ID, ID>();
        Map<ID, Device__c> mapDeviceMST = new Map<ID, Device__c>();
        Boolean FlagMaxPTRFCount;
        Boolean FlagPTRF;
        if (!IntegrationUserUtil.isSkipTrigger()){
            if(checkRecursive.runOnceAgain()){
            DeviceMap = new Map<String, Device__c>();
            string mstNames='';
            integer z=0;
            integer recSize=Trigger.new.size();
            for (Device__c Device : (List<Device__c >)Trigger.new){
              if(Device.Fab__c!=null && (Device.Fab__c!='FAB 9'&& Device.Fab__c!='FAB 10'&&Device.Fab__c!='Altis')){
                lstDeviceIDNew.add(Device.Id);
                if (!Test.isRunningTest()){
                    if (Trigger.isUpdate &&(Device.Reticle_Type__c != triggerOldMap.get(Device.Id).Reticle_Type__c) && Device.Tapeout_Type__c =='GlobalShuttle MPW'){
                        if (!Device.Manual_Creation__c){
                            Device.Reticle_Type__c.addError('Reticle type can not be modified.');
                        }
                    }
                }
                if(Device.Mask_Set_Title_Lookup__c!=Null){
                    lstDeviceIDNewSecure.add(Device.Id);
                    mapDeviceMSTIdSecure.put(Device.Mask_Set_Title_Lookup__c,Device.id);
    
                }
                //If Global shuttle tapeouttype MPW train number will be copied to Mask set title.
                if(Device.Tapeout_Type__c =='GlobalShuttle MPW' && Device.MPW_Train_Number__c != null){
                    For(MPW_Train_Maintenance__c MPWNo: [SELECT ID,Name from MPW_Train_Maintenance__c where ID =:Device.MPW_Train_Number__c]){
                                Device.Device_Mask_Set_Title__c = MPWNo.Name;
                    }
                }
                // if Full layer retrofit tapeout type Device mask set title and MST look up will be copied from base device.                    
                else if (Device.Tapeout_Type__c =='Full Layer Retrofit' && Device.Base_Device__c != null){
                    for (Device__c Dev: [SELECT ID,Device_Mask_Set_Title__c,Mask_Set_Title_Lookup__c from Device__c where ID =:Device.Base_Device__c]){
                                Device.Device_Mask_Set_Title__c = Dev.Device_Mask_Set_Title__c;
                                Device.Mask_Set_Title_Lookup__c = Dev.Mask_Set_Title_Lookup__c;
                    }
                }
                if ((Device.Device_Mask_Set_Title__c != null) && (Trigger.isInsert || (Device.Device_Mask_Set_Title__c != triggerOldMap.get(Device.Id).Device_Mask_Set_Title__c))) {
                    // Make sure another new Device__c isn't also a duplicate
                    if (DeviceMap.containsKey(Device.Device_Mask_Set_Title__c)) {
                        Device.Device_Mask_Set_Title__c.addError('Another new Device has the same Mask set title.');
                    }else{
                        DeviceMap.put(Device.Device_Mask_Set_Title__c, Device);
                        //masksettitle duplicate check
                        if(z==recSize-1){
                            mstNames += ' MaskSetTitle_From_PTRF__c like \'%'+Device.Device_Mask_Set_Title__c+'%\' ';    
                        }else{
                            mstNames += ' MaskSetTitle_From_PTRF__c like \'%'+Device.Device_Mask_Set_Title__c+'%\' or ';
                        }
                        z++;
                        
                    }
                    if(Device.Mask_Set_Title_Lookup__c != null){             
                        mapDeviceMSTId.put(Device.id,Device.Mask_Set_Title_Lookup__c);
                        mapDeviceMST.put(Device.Mask_Set_Title_Lookup__c,Device);
                    }        
                }else if (Device.Device_Mask_Set_Title__c == null){
                     Device.Mask_Set_Title_Lookup__c = Null;   
                }
              }
            }
            List<PTRF__c> PTRF=[SELECT ID,Device__c FROM PTRF__c where Status__c!='Cancel' AND Device__c In :lstDeviceIDNew ];
            
            //For checking on same existing Mask Set title.
            set<string> nameSet=new set<string>();
            nameSet.addall(DeviceMap.KeySet());  
            string query='SELECT id,Name,MaskSetTitle_From_PTRF__c,Reticle_Type__c,Mask_Set_Classification__c,Technology__c FROM Mask_Set_Title__c WHERE Name IN: nameSet ';
            if(mstNames!='')query+=' OR '+ mstNames +' ';
            List<Mask_Set_Title__c> masKList=database.query(query);
            if(DeviceMap.size() > 0){
                for(Mask_Set_Title__c mst: masKList){
                    List<string> MSTRoMCodes=new List<string>();
                    if(string.isnotblank(mst.MaskSetTitle_From_PTRF__c))MSTRoMCodes=mst.MaskSetTitle_From_PTRF__c.split(';');
                    setMaskTitle.add(mst.name);
                    setMaskTitle.addAll(MSTRoMCodes); 
                    lstMaskSetTitle.add(mst);
                }
            }
            //Mask set titlle related to MST Account.
            if(lstMaskSetTitle !=Null && lstMaskSetTitle.size()>0){
             lstMSTAcc=[SELECT ID,Account__c FROM MSTAccount__c where Mask_Set_Title__c =:lstMaskSetTitle[0].ID];
            }
            //For checking on Existing Device Records. 
            if(DeviceMap.size() > 0 || lstDeviceIDNew.size() > 0){               
                for(Device__c dev: [SELECT ID,Device_Mask_Set_Title__c,Mask_Set_Title_Lookup__c 
                                      FROM Device__c 
                                     WHERE Device_Mask_Set_Title__c In :DeviceMap.KeySet()
                                       AND Id NOT IN :lstDeviceIDNew]){
                    setExistingDevice.add(dev.Device_Mask_Set_Title__c);     
                }
            }
            //For checking on Mask set title Device Records.
            if(mapDeviceMSTIdSecure.size() > 0){
                for(Mask_Set_Title__c mst: [SELECT Id,Name,Reticle_Type__c,Mask_Set_Classification__c,Technology__c FROM Mask_Set_Title__c WHERE ID In:mapDeviceMSTIdSecure.KeySet()]){
                    setMSTIDsUpdate.add(mst.id);
                    lstMaskSetTitleSecure.add(mst);
                }
            }
            
            for (Device__c Device : (List<Device__c>) Trigger.new){
                if(Device.Fab__c!=null && (Device.Fab__c!='FAB 9'&& Device.Fab__c!='FAB 10'&&Device.Fab__c!='Altis')){
                //Secure Device Check for mask set title record.
                if(Trigger.IsUpdate && (Device.Secure_Device__c != triggerOldMap.get(Device.Id).Secure_Device__c) && Device.Mask_Set_Title_Lookup__c!= Null) {
                    if(Device.Secure_Device__c == 'Yes' && Device.Tapeout_Type__c !='GlobalShuttle MPW' ){
                        if(setMSTIDsUpdate!=Null && setMSTIDsUpdate.contains(Device.Mask_Set_Title_Lookup__c)){
                            For(Mask_Set_Title__c lmst: lstMaskSetTitleSecure){
                                if(lmst.id == Device.Mask_Set_Title_Lookup__c){
                                    lmst.Mask_Set_Classification__c = 'Secure';
                                    MSTToUpdate2.add(lmst);
    
                                }
                                 
                            }
                        }
                    }
                    Else if(Device.Secure_Device__c == 'No'){       
                    }
                }
                
                //Checking non cancelled PTRF in related list of Device.
                if(PTRF.Size()>=1){                            
                    FlagMaxPTRFCount =True;                                           
                }
                Else
                    FlagMaxPTRFCount =False;
                    
                mapPTRFCheck.put(Device.ID,FlagMaxPTRFCount);
                If(mapPTRFCheck != NULL){
                    FlagPTRF = mapPTRFCheck.get(Device.id);
                    if(!FlagPTRF && (Device.Status__c   == 'Inactive' || Device.Status__c=='Void' && Device.Stage__c!= 'EOL')){
                        Device.Device_Mask_Set_Title__c ='';
                        Device.Mask_Set_Title_Lookup__c = Null;
                    }
                }
                
                if(Device.Tapeout_Type__c =='Single Product' ){
                    If(setExistingDevice != NULL && setExistingDevice.contains(Device.Device_Mask_Set_Title__c)){
                        Device.Device_Mask_Set_Title__c.addError('A Device with this mask set title already exists.');    
                    }
                    if(FlagPTRF!=Null){
                        if(FlagPTRF && Trigger.IsUpdate && (Device.Device_Mask_Set_Title__c != triggerOldMap.get(Device.Id).Device_Mask_Set_Title__c)){
                            Device.Device_Mask_Set_Title__c.addError('Device Mask Set Titile cannot be changed if at least 1 non cancelled PTRF associated with Device');
                        }
                    }
                    //If Mask set title already exists in Mask set title object.  
                    If(setMaskTitle != NULL && setMaskTitle.contains(Device.Device_Mask_Set_Title__c)){
                        Device.Device_Mask_Set_Title__c.addError('This mask set title already exists.');
                    }
                    
                    else{
                        If((Trigger.IsInsert || (Trigger.IsUpdate && (Device.Device_Mask_Set_Title__c != triggerOldMap.get(Device.Id).Device_Mask_Set_Title__c))) && Device.Device_Mask_Set_Title__c != null) {
                            Mask_Set_Title__c MST = new Mask_Set_Title__c (); 
                            MST.Name = Device.Device_Mask_Set_Title__c; 
                            MST.Reticle_Type__c = Device.Reticle_Type__c;
                            MST.Number_of_Prime_Die__c = Device.Expected_no_of_Prime_Die__c;
                            if(Device.Secure_Device__c == 'Yes'){
                                MST.Mask_Set_Classification__c = 'Secure';  
                            }                                
                            String Geometry2 = String.valueof(Device.Geometry_NM__c);
                            Boolean chkFlag = True;
                            MST.Technology__c = Geometry2;
                            MSTToInsert.add(MST);
                            DeviceMSTMap.put(Device.id,MST);
                            if(Device.Account__c != Null){
                                MSTAccount__c MSTAcc  = new MSTAccount__c();
                                MSTAcc.Account__c = Device.Account__c;
                                MSTAccountToInsert.add(MSTAcc);
                                MSTMSTAccountMap.put(Device.Device_Mask_Set_Title__c,MSTAcc);
                            }                           
                        }
                    }                                                                        
                }
                
                // IF Tapeout type is Global Shuttle MPW / Retrofit.
                else if(Device.Tapeout_Type__c =='GlobalShuttle MPW' || Device.Tapeout_Type__c =='Retrofit' ){
                    If(setMaskTitle != NULL && setMaskTitle.contains(Device.Device_Mask_Set_Title__c)){
                        Device.Mask_Set_Title_Lookup__c = lstMaskSetTitle[0].ID;
                        String Geometry2 = String.valueof(Device.Geometry_NM__c);
                        Boolean chkFlag = True;
                        If(lstMaskSetTitle[0].Technology__c != Null){
                            String Geometry =  lstMaskSetTitle[0].Technology__c;
                            List<String> Parts = lstMaskSetTitle[0].Technology__c.split('\r\n');
                            for(String P:Parts){  
                                if(P == Geometry2)
                                    chkFlag = False;
                                        
                                }
                            if(chkFlag){
                                lstMaskSetTitle[0].Technology__c = Geometry + ' \r\n' + Geometry2;
                                    
                            }
                        }
                        else
                            lstMaskSetTitle[0].Technology__c = Geometry2;
                        MSTToUpdate.add(lstMaskSetTitle[0]);
                        if(lstMaskSetTitle[0].Reticle_Type__c!= null){
                            Device.Manual_Creation__c = True;
                            Device.Reticle_Type__c = lstMaskSetTitle[0].Reticle_Type__c; 
                        }
                    }
                    else{
                        if(Device.Mask_Set_Title_Lookup__c == Null && Device.Device_Mask_Set_Title__c!= Null ){
                            Mask_Set_Title__c MST = new Mask_Set_Title__c (); 
                            MST.Name = Device.Device_Mask_Set_Title__c; 
                            MST.Reticle_Type__c = Device.Reticle_Type__c;
                            MST.Number_of_Prime_Die__c = Device.Expected_no_of_Prime_Die__c;
                            if(Device.Secure_Device__c == 'Yes'){
                                MST.Mask_Set_Classification__c = 'Secure';  
                            }
                            String Geometry2 = String.valueof(Device.Geometry_NM__c);
                            Boolean chkFlag = True;
                            MST.Technology__c = Geometry2;
                            MSTToInsert.add(MST);
                            DeviceMSTMap.put(Device.id,MST);
                            if(Device.Account__c != Null){
                                MSTAccount__c MSTAcc  = new MSTAccount__c();
                                MSTAcc.Account__c = Device.Account__c;
                                MSTAccountToInsert.add(MSTAcc);
                                MSTMSTAccountMap.put(Device.Device_Mask_Set_Title__c,MSTAcc);
                            }    
                        }
                    }
                }
                //If tapeout type is customer MPW or TD test Chip.
                else if(Device.Tapeout_Type__c =='Customer MPW' ||Device.Tapeout_Type__c =='TD Test Chip'){
                    if(Device.Device_Mask_Set_Title__c!= Null && Device.Device_Mask_Set_Title__c!= ''
                       && (Trigger.IsInsert ||(Device.Device_Mask_Set_Title__c != triggerOldMap.get(Device.Id).Device_Mask_Set_Title__c) || 
                           (Trigger.Isupdate && Device.Geometry_NM__c!=triggerOldMap.get(Device.Id).Geometry_NM__c))){
                        If(setMaskTitle != NULL && setMaskTitle.contains(Device.Device_Mask_Set_Title__c)){
                            boolean isMatched=false;
                            for (Integer i = 0; i < lstMSTAcc.size(); i++){
                                if(Device.Account__c== lstMSTAcc[i].Account__c){
                                    Device.Mask_Set_Title_Lookup__c = lstMaskSetTitle[0].ID;
                                    if(Device.Secure_Device__c == 'Yes'){
                                        lstMaskSetTitle[0].Mask_Set_Classification__c = 'Secure';
                                    }
                                    String Geometry2 = String.valueof(Device.Geometry_NM__c);
                                    Boolean chkFlag = True;
                                    If(lstMaskSetTitle[0].Technology__c != Null){
                                        String Geometry =  lstMaskSetTitle[0].Technology__c;
                                        List<String> Parts = lstMaskSetTitle[0].Technology__c.split('\r\n');
                                        for(String P:Parts){
                                            if(P == Geometry2)
                                            chkFlag = False;
                                        
                                        }
                                        if(chkFlag){
                                            lstMaskSetTitle[0].Technology__c = Geometry + ' \r\n' + Geometry2;
                                    
                                        }
                                    }
                                    else
                                        lstMaskSetTitle[0].Technology__c = Geometry2;
                                    MSTToUpdate.add(lstMaskSetTitle[0]);
                                    if(lstMaskSetTitle[0].Reticle_Type__c!= Null){
                                        Device.Manual_Creation__c = True;
                                        Device.Reticle_Type__c = lstMaskSetTitle[0].Reticle_Type__c; 
                                    }
                                    isMatched=true;
                                    break;    
                                }
                            }
                            if(!isMatched){
                                System.debug('Test7 : ');
                                Device.Device_Mask_Set_Title__c.addError('This mask set title does not exist with Account associated with this Device.Request FAE to create Mask set Title');
                            }
                        }
                        else{
                            Device.Device_Mask_Set_Title__c.addError('This mask set title does not exist.');
                        }
                    }
                } 
                }
            }
            
            try{
                if(MSTToUpdate2!= Null){
                    Update MSTToUpdate2;
                }
                if(MSTToInsert!= Null){
                    upsert MSTToInsert;
                }
                if(MSTToUpdate!= Null){
                    Update MSTToUpdate;
                }
                for(Device__c Device1 : (List<Device__c>)Trigger.new){
                    if(DeviceMSTMap != NULL && DeviceMSTMap.containskey(Device1.ID)){
                        Device1.Mask_Set_Title_Lookup__c = DeviceMSTMap.get(Device1.id).id; 
                    }
                }
                if(MSTAccountToInsert!= Null){
                    for(Device__c Device1 : (List<Device__c>)Trigger.new){
                        if(MSTMSTAccountMap != NULL && MSTMSTAccountMap.containskey(Device1.Device_Mask_Set_Title__c)){
                            for(MSTAccount__c MSTAcc : MSTAccountToInsert){
                                MSTAcc.Mask_Set_Title__c = Device1.Mask_Set_Title_Lookup__c;
                                MSTAcc.Account__c = MSTAcc.Account__c;
                                MSTAccountToUpsert.add(MSTAcc);
                            }
                        
                        }
                        Device1.Manual_Creation__c = False;                        
                    }
                    if (!Test.isRunningTest()){
                        upsert MSTAccountToUpsert;
                    }
                }       
            } 
            catch (system.Dmlexception ex) {
                
                catchCover(string.valueof(Device__c.Id),string.valueof(ex.getMessage()),'deviceMaskSetTitleRec()');                          
            }                                                             
        }
        }
        system.debug('end>>>>>>>>>>deviceMaskSetTitleRec :SOQL queries:'+limits.getQueries());        
    }
    /*********************************************************************************************************************************************************
    @ Method:         deviceMaskSetTitlelookUp
    @ Version:        1.0
    @ Author:         Ishtpreet Singh (Ishtpreet.singh@globalfoundries.com)
    @ Purpose:        This Method updates Mask set title lookup field on device.
    **********************************************************************************************************************************************************/
    
    public void deviceMaskSetTitlelookUp(){
        system.debug('start>>>>>>>>>>deviceMaskSetTitlelookUp:SOQL queries:'+limits.getQueries());
    
        List<id> MSTIdList = new List<id>();        
        List<id> lstOldMSTId = new List<id>();
        List<Mask_set_Title__c> MSTUpdateList = new List<Mask_set_Title__c>();
        Map<id,Double> mapMSTPimeDie = new Map<id,Double>(); //Map to hold Prime die for respective Device ID.
        List<Mask_set_Title__c> lstOldMSTUpdate = new List<Mask_set_Title__c>(); //List to hold changed mmst record and respective prime die value.
        if(checkRecursive.run1sMet()){
            for (Device__c Dev : [SELECT ID,Mask_Set_Title_Lookup__c from Device__c where ID IN :Trigger.new]){
                if(Dev.Mask_Set_Title_Lookup__c != null)
                    MSTIdList.add(Dev.Mask_Set_Title_Lookup__c);
                if(Trigger.isUpdate){
                    if(Dev.Mask_Set_Title_Lookup__c != triggerOldMap.get(Dev.Id).Mask_Set_Title_Lookup__c){
                        if(triggerOldMap.get(Dev.Id).Expected_no_of_Prime_Die__c!= Null){
                            mapMSTPimeDie.put(triggerOldMap.get(Dev.Id).Mask_Set_Title_Lookup__c,triggerOldMap.get(Dev.Id).Expected_no_of_Prime_Die__c); //Trigger.oldMap.get(Dev.Id).Expected_no_of_Prime_Die__c
                            lstOldMSTId.add(triggerOldMap.get(Dev.Id).Mask_Set_Title_Lookup__c);
                        }
                    } 
                }   
            
            }
            if(MSTIdList.size() > 0){
                for (Mask_set_Title__c MST : [SELECT ID,Number_of_Prime_Die__c,(SELECT id,Expected_no_of_Prime_Die__c FROM Devices__r) FROM Mask_set_Title__c WHERE id =: MSTIdList]){
                    Device__c[] lstDevice = MST.Devices__r;
                    if (lstDevice != null && lstDevice.size() > 0){
                        MST.Number_of_Prime_Die__c = 0;
                        for (Device__c Dev : lstDevice){
                            if(Dev.Expected_no_of_Prime_Die__c!= null ){
                                MST.Number_of_Prime_Die__c += Dev.Expected_no_of_Prime_Die__c;
                            }    
                        }
                        MSTUpdateList.add(MST);    
                    }        
                }
            }

            if(lstOldMSTId.size() > 0){
                for (Mask_set_Title__c MST : [SELECT ID,Number_of_Prime_Die__c FROM Mask_set_Title__c WHERE id =: lstOldMSTId]){
                    if(mapMSTPimeDie!= Null && mapMSTPimeDie.containskey(MST.ID) &&  MST.Number_of_Prime_Die__c>0 && MST.Number_of_Prime_Die__c!= Null){
                        MST.Number_of_Prime_Die__c = Integer.valueOf(MST.Number_of_Prime_Die__c - mapMSTPimeDie.get(MST.ID));
                        if(MST.Number_of_Prime_Die__c ==0){
                            MST.Number_of_Prime_Die__c = Null;
                        }
                    }
                    lstOldMSTUpdate.add(MST);
                }
            }
            try{
                if (MSTUpdateList!= Null){
                    update MSTUpdateList;
                }
                if (lstOldMSTUpdate!= Null){
                    update lstOldMSTUpdate;    
                }
                          
            }catch (Exception ex){  
                
                catchCover(string.valueof(Device__c.Id),string.valueof(ex.getMessage()),'deviceMaskSetTitlelookUp()');  
            }
        }
        system.debug('end>>>>>>>>>>deviceMaskSetTitlelookUp:SOQL queries:'+limits.getQueries());        
    }
    /*********************************************************************************************************************************************************
    @ Method:         deviceChecklistBefore
    @ Version:        1.0
    @ Author:         Ishtpreet Singh (Ishtpreet.singh@globalfoundries.com)
    @ Purpose:        This Method run on device checklist before event.
    **********************************************************************************************************************************************************/    
    public void deviceChecklistBefore(){  
        if(Trigger.isInsert || Trigger.isUpdate){
            DeviceTriggerHandler.updateBUPL(Trigger.new);
        }
        for (Device__c device : (List<Device__c>)trigger.new){
            if(device.Tapeout_process__c==null){
                if(device.Fab__c=='FAB 9' || device.Fab__c=='FAB 10' || device.Fab__c=='ALTIS')device.Tapeout_process__c='FMS 2.0';
                else device.Tapeout_process__c='PTRF';
            }
        }
    }
    
    /*********************************************************************************************************************************************************
    @ Method:         taskUpdateOnDevicechnge
    @ Version:        1.0
    @ Author:         Ishtpreet Singh (Ishtpreet.singh@globalfoundries.com)
    @ Purpose:        This Method updates the task depending on the device fields.
    **********************************************************************************************************************************************************/
    public void taskUpdateOnDevicechnge(){ 
        system.debug('start>>>>>>>>>>taskUpdateOnDevicechnge:SOQL queries:'+limits.getQueries());        
        DeviceChecklistUtils.onDeviceToChange(triggerNewMap, triggerOldMap);    
        system.debug('end>>>>>>>>>>taskUpdateOnDevicechnge:SOQL queries:'+limits.getQueries());        
    }
    
    /*********************************************************************************************************************************************************
    @ Method:         deviceForcastDateUpdt
    @ Version:        1.0
    @ Author:         Ishtpreet Singh (Ishtpreet.singh@globalfoundries.com)
    @ Purpose:        This Method updates the RTR_Date_Original_Forecast__c  field on device.
    **********************************************************************************************************************************************************/
    public void deviceForcastDateUpdt(){
        system.debug('start>>>>>>>>>>deviceForcastDateUpdt:SOQL queries:'+limits.getQueries());        
        for (Device__c device : (List<Device__c>)trigger.new){
            if (device.RTR_Date_Original_Forecast__c == null && device.RTR_Date_Current_Forecast__c!=null){
                 device.RTR_Date_Original_Forecast__c = device.RTR_Date_Current_Forecast__c;    
            }
            /*Changes made by gopi for case # 00058217
              Requirement:based on "Tapeout Type" values ,
              Generate Standard Frame field required based on custom Setting.
              Custom Setting Name : DeviceTapeoutValues
            */
            Boolean stopLogicExecution = true;
            if(trigger.isInsert && device.Tapeout_Type__c == 'Retrofit') stopLogicExecution = false;
                        
            Map<String,DeviceTapeoutValues__c> allDeviceTapeoutValues = DeviceTapeoutValues__c.getAll();
            if(allDeviceTapeoutValues.size()>0){
              if(!allDeviceTapeoutValues.keySet().contains(device.Tapeout_Type__c)){
                  if(device.Generate_Standard_Frame__c == null && !test.isRunningTest()){
                      device.Generate_Standard_Frame__c.addError('Generate Standard Frame is Required');
                  }
              }
            }
        }
  }
   
            
    /*********************************************************************************************************************************************************
    @ Method:         autopopulateDeviceFlds
    @ Version:        1.0
    @ Author:         Ishtpreet Singh (Ishtpreet.singh@globalfoundries.com)
    @ Purpose:        This Method Autopopulates fields on Device object.
    **********************************************************************************************************************************************************/
    public void autopopulateDeviceFlds(){           
        Set<Id> opptyProgramIds = new Set<Id>();
        Set<Id> processTechnologyIds = new Set<Id>();
        Set<Id> processIds = new Set<Id>();
        List<Device__c> lstDevice = new List<Device__c>();
        Map<String, String> mapDevice = new Map<String, String>();
        Map<Id, Id> mapPT = new Map<Id, Id>();
        Map<String, Id> mapProcess = new Map<String, Id>();     
        
        if (!IntegrationUserUtil.isSkipTrigger()){
            DeviceTriggerHelper.populateFilterLookupCriteria(trigger.new); 
            for (Device__c device1 : (List<Device__c>)Trigger.New){
                    
                if(device1.Previous_Enabling_Devices_MPW__c <> null){
                    device1.Enabled_via_previous_MPW_1__c = 'Yes';
                }
                device1.Name = device1.Name.toUpperCase();
                device1.Device_ID__c = device1.Name.toUpperCase();
                device1.Device_Geometry_Range_Copy__c = device1.Device_Geometry_Range__c;
                if (device1.Actual_Tapeout_Date__c != null){
                    device1.Actual_Tapeout_Date_GMT__c = device1.Actual_Tapeout_Date__c.dateGMT();
                }else {
                    device1.Actual_Tapeout_Date_GMT__c = null;
                }
                device1.Device_ID__c = (device1.Name + device1.Tapeout_Type__c.replace(' ', '')).toUpperCase();
                //added by Vijay 01282015 -  if-else block to support the Internal Device functionality
                if (!DeviceTriggerHandler.isInternalDevice(device1.recordTypeId) && device1.Opportunity_Program__c != null){
                    opptyProgramIds.add(device1.Opportunity_Program__c);    
                }else {
                    if (device1.CRMDID__c == null || device1.CRMDID__c.trim() == '') {
                        mapDevice.put(device1.Name, null);
                    }
                }
                if (device1.Process_Technology_2__c != null) {
                    processTechnologyIds.add(device1.Process_Technology_2__c);
                }else{
                    device1.IP_Technology__c = '';
                    device1.Process_Technology_Number__c = '';                    
                }
               // Added functionality to autopopulate 'Process Technology' when user selects an 'Assigned Process Id'.
                if (device1.Assigned_Process_ID__c != null) {
                    processIds.add(device1.Assigned_Process_ID__c);
                }
                if(!String.isEmpty(device1.geometry_filter__c)){
                    decimal geom = decimal.valueOf(device1.geometry_filter__c.replace('UM',''));
                    if(geom >= 0.04 && geom <= 0.055){
                        device1.Design_Rules_Applied__c = 'Automotive Design Rules';
                    } else 
                        device1.Design_Rules_Applied__c = 'Consumer Design Rules';
                }
                if (device1.Tapeout_Type__c == Environment_Variable__c.getInstance('DEVICE_TAPEOUT_TYPE_GLOBALSHUTTLE_MPW').Value__c){  
                    lstDevice.add(device1);
                }
                if (device1.Proto_Lot_Start_ID__c != null) {
                    device1.Proto_Lot_Start_ID_Change_Date__c = date.today();
                }  
				if (DeviceTriggerHandler.isInternalDevice(device1.recordTypeId) && device1.Tapeout_Type__c != Environment_Variable__c.getInstance('DEVICE_TAPEOUT_TYPE_RETROFIT').Value__c){
                    device1.ECCN_Technology__c = Environment_Variable__c.getInstance('DEVICE_ECCN_TECH_INTERNALDEV_DEFAULT').Value__c;
                    device1.ECCN_Wafer__c = Environment_Variable__c.getInstance('DEVICE_ECCN_WAFER_INTERNALDEV_DEFAULT').Value__c;
                    device1.ECCN_Color__c = Environment_Variable__c.getInstance('DEVICE_ECCN_COLOR_INTERNALDEV_DEFAULT').Value__c;
                    device1.Is_ITAR__c = Environment_Variable__c.getInstance('DEVICE_ITAR_CLASS_INTERNALDEV_DEFAULT').Value__c;
                    device1.ITAR_Flag__c = Environment_Variable__c.getInstance('DEVICE_ITAR_FLAG_INTERNALDEV_DEFAULT').Value__c;
                    device1.D1_National_Access_Allowed__c = Environment_Variable__c.getInstance('DEVICE_D1_FLAG_INTERNALDEV_DEFAULT').Value__c;
                }
            }
            ManualDeviceHelper.retrofitDeviceCheck1(Trigger.New);
            if(opptyProgramIds != null && !opptyProgramIds.isEmpty()){
                Map<Id, Opportunity_Program__c> mapOpptyProgram = new Map<Id, Opportunity_Program__c>([SELECT Id, 
                                                                                                              Opportunity__c, 
                                                                                                              Opportunity__r.AccountId
                                                                                                         FROM Opportunity_Program__c
                                                                                                        WHERE Id IN :opptyProgramIds]);
            
                for (Device__c device : (List<Device__c>)Trigger.New){
                    Opportunity_Program__c tempOpptyProgram = mapOpptyProgram.get(device.Opportunity_Program__c);
                    device.Account__c = tempOpptyProgram.Opportunity__r.AccountId;
                    device.Opportunity2__c = tempOpptyProgram.Opportunity__c;
                    if (device.CRMDID__c == null || device.CRMDID__c.trim() == '') {
                        mapDevice.put(device.Name, null);
                    }               
                }            
            }
            mapDevice = Utility.retrieveMapNewCRMDID(mapDevice);
            for (Device__c device : (List<Device__c >)Trigger.New) {
                if (mapDevice.containsKey(device.Name)){
                    device.CRMDID__c = mapDevice.get(device.Name);
                }
                String[] baseCRMDID = device.CRMDID__c.split('\\.', 2);
                device.Device_Base_Id__c = baseCRMDID[0];
                
                if(device.Device_Type__c==null){
                    device.Device_Type__c = DEVICE_DEFAULT_TYPE;
                }
                if(device.Revision__c==null){
                    device.Revision__c = DEVICE_DEFAULT_REVISION;
                }
                if(device.BX041_Status__c==null){
                    device.BX041_Status__c = DEVICE_DEFAULT_BX041_STATUS;    
                }
            }
            if (processTechnologyIds.size() > 0){
                Map<Id, Process_Technology__c> mapProcessTechnology = new Map<Id, Process_Technology__c>([
                    SELECT      Id
                                , IP_Geometry_Technology__c
                                , PT_Number__c
                      FROM        Process_Technology__c
                     WHERE      Id IN :processTechnologyIds ]);
                
                for (Device__c device : (List<Device__c>)Trigger.New){
                    if (device.Process_Technology_2__c != null){
                        if (mapProcessTechnology.containsKey(device.Process_Technology_2__c)){
                            device.IP_Technology__c = mapProcessTechnology.get(device.Process_Technology_2__c).IP_Geometry_Technology__c;
                            device.Process_Technology_Number__c = mapProcessTechnology.get(device.Process_Technology_2__c).PT_Number__c;
                        }
                    }
                }     
            }
            if (processIds.size() > 0){
                for (Process__c p : [SELECT     Id
                                                , Process_Technology__c
                                     FROM       Process__c
                                     WHERE      Id IN :processIds]) { 
                    mapProcess.put(p.Process_Technology__c, p.Id);
                }
                for (Process_Technology__c pt : [SELECT     Id
                                                            , PT_Number__c
                                                 FROM       Process_Technology__c
                                                 WHERE      PT_Number__c IN :mapProcess.keySet()]) {
                    if (mapProcess.containsKey(pt.PT_Number__c)) {
                        mapPT.put(mapProcess.get(pt.PT_Number__c), pt.Id);
                    }                                                                      
                }
                for (Device__c dev : (List<Device__c>)Trigger.New){
                    if (mapPT.containsKey(dev.Assigned_Process_ID__c)) {
                        dev.Process_Technology_2__c = mapPT.get(dev.Assigned_Process_ID__c);
                    } 
                }
            }
            DeviceForLotCalculate.calculateForecastLotStartDate(Trigger.new, triggerOldMap, 'Insert');
            if (lstDevice.size() > 0){ 
                DeviceMPWForecastedTapeoutDate.retrieveTapeoutDate(lstDevice);
            }          
        }                  
    }
            
    /*********************************************************************************************************************************************************
    @ Method:         deviceSharingWithATM
    @ Version:        1.0
    @ Author:         Ishtpreet Singh (Ishtpreet.singh@globalfoundries.com)
    @ Purpose:        This Method creates new Sharing records for device.
    **********************************************************************************************************************************************************/
    public void deviceSharingWithATM(){
        system.debug('start>>>>>>>>>>deviceSharingWithATM:SOQL queries:'+limits.getQueries());            
    
        Map<String,List<String>> deviceIDMap = new Map<String,List<String>>(); 
        Set<Id> deviceIds = new Set<Id>(); 
        OpptyTeamManager.insertDeviceShare(triggerNewMap);
        ManualDeviceHelper.inactivateManualDevice(Trigger.new);
        
        for(Device__c device: (List<Device__c>)trigger.new){
            if((device.tapeout_type__c == 'Retrofit' || device.device_type__c == 'Revision') && UtilsString.isNotBlank(device.base_device__c)){
                if(deviceIDMap.containsKey(device.base_device__c)){
                    deviceIDMap.get(device.base_device__c).add(device.id);
                }else {
                    deviceIDMap.put(device.base_device__c,new List<String>{device.id});
                }
                    
            }
            
            if (device.Device_Complete__c && device.NPC_Form_Originating_Device__c == null) {
                lstDevice.add(new Device__c(Id = device.Id, NPC_Form_Originating_Device__c = device.Id));
            }
        }
        if(deviceIDMap.size() > 0){
            DeviceRetrofit.cloneIPDecAndExpCon(deviceIDMap);
        }
        if (lstDevice.size() > 0 ){
            update lstDevice;
        }           
        
    }
    /*********************************************************************************************************************************************************
    @ Method:         syncTo
    
    @ Version:        1.0
    @ Author:         Ishtpreet Singh (Ishtpreet.singh@globalfoundries.com)
    @ Purpose:        This Method is synchronizing Device with BPM Data.
    **********************************************************************************************************************************************************/
    public void syncToBPM(){         
    
        set<Device__c> setDevice = new set<Device__c>();
        Set<Id> deviceIdset = new Set<Id>();
        
        if (Environment_Variable__c.getInstance('BPM_isActive').value__c.equalsIgnoreCase('TRUE') &&  !UtilityValidatorHelper.hasAlreadyDone()){
            for (Device__c device : (List<Device__c>)Trigger.new){
                if (device.BX041_Form_Count__c > 0  && triggerOldMap.get(device.id).BX041_Form_Count__c == 0 && device.BX041_Status__c == 'Pending Submission' ){
                    setDevice.add(device);    
                }
                else if(device.BX041_Form_Count__c > 0 && triggerOldMap.get(device.id).BX041_Status__c == 'Pending Submission' && device.BX041_Status__c == 'Pending Review'){
                    setDevice.add(device);    
                } 
                else if(device.BX041_Form_Count__c > 0 && TriggerOldMap.get(device.id).BX041_Status__c == 'Pending Review' && device.BX041_Status__c == 'Pending Acknowledgement'){
                    setDevice.add(device);
                }
                else if(device.BX041_Form_Count__c > 0 && (device.BX041_Status__c == 'Pending Acknowledgement' || device.BX041_Status__c == 'Frozen/Pending PID Assignment')){
                    deviceIdset.add(device.id);                   
                }
                else if(device.BX041_Form_Count__c > 0 && triggerOldMap.get(device.id).BX041_Status__c != device.BX041_Status__c
                    && ( device.BX041_Status__c == 'Frozen/Pending PID Assignment'
                         || device.BX041_Status__c == 'Suspended PID Assigned'
                         || device.BX041_Status__c == 'Pending Gap Closure'
                         || device.BX041_Status__c == 'Registered/TBO PID Assigned'
                         || device.BX041_Status__c == 'Closed') ){                   
                    setDevice.add(device);
                }
                else if(device.Status__c == 'Active' && triggerOldMap.get(device.id).Current_Forecast_Tapeout_Date__c != device.Current_Forecast_Tapeout_Date__c){
                    setDevice.add(device);
                }
                else if(device.Status__c == 'Active' && triggerOldMap.get(device.id).Confidence_Level_Tapeout__c != device.Confidence_Level_Tapeout__c){
                    setDevice.add(device);
                }
                else if(triggerOldMap.get(device.id).Status__c != device.Status__c){
                    setDevice.add(device);
                }
                else if(device.Status__c == 'Active' && device.Tapeout_Type__c == 'Retrofit' && device.CreatedDate.addMinutes(2) >= device.LastModifiedDate){
                    setDevice.add(device);
                }  
                else if(TriggerOldMap.get(device.id).device_mask_set_title__c <> device.device_mask_set_title__c){
                    setDevice.add(device);
                }      
            }
            if(deviceIdset.size()>0){
                List<BX_041__c> cdrslist = [select id, Approval_Step__c from BX_041__c where Device__c IN: deviceIdset];
                for(Device__c device : (List<Device__c>)Trigger.new){
                    for(BX_041__c bx041:cdrslist){
                        if(bx041.Approval_Step__c == 'Pending for PIYE' || bx041.Approval_Step__c == 'Approved'){
                            setDevice.add(device);
                        }
                    }
                }   
            }
            if(setDevice.size()>0){ 
                for(Device__c device : setDevice){
                //set BPM status to Sent
                    device.BPM_Status__c = 'SENT';//Tlai 24042014 - changed to SENT
                    if( !Test.isRunningTest() && !system.isBatch() && !system.isFuture()){
                    
                        //call web method for integration: 
                        BPMDeviceIntegration.deviceBPMSFDCIntegrationMethod(device.id, true);
                        
                        //fire for Config+ if used
                    if(UtilsString.isNotBlank(device.configuration__c)){
                       // BPMConfigurationPlusIntegration.fireFromDevice(device.configuration__c);// Commented by Baij
                    }   
                    
                    }
                }
            
            //setting the global variable to restrict recursion.
            UtilityValidatorHelper.setAlreadyDone();
            }        
        }
        system.debug('end>>>>>>>>>>syncToBPM:SOQL queries:'+limits.getQueries());                    
    }
    /*********************************************************************************************************************************************************
    @ Method:         deviceUpdateBefore
    @ Version:        1.0
    @ Author:         Ishtpreet Singh (Ishtpreet.singh@globalfoundries.com)
    @ Purpose:        This Method is updating Device on before update event.
    **********************************************************************************************************************************************************/
    public void deviceUpdateBefore(){
        system.debug('start>>>>>>>>>>deviceUpdateBefore:SOQL queries:'+limits.getQueries());                
        Set<Id> processTechnologyIds = new Set<Id>();
        Set<Id> processIds = new Set<Id>();
        set<Id> OppSetId=new set<Id>();
        List<Device__c> listDeviceMpw = new List<Device__c>();
        List<String> reassignDeviceIDs = new List<String>();
        List<String> rejectedDeviceIDs = new List<String>();
        User user = [SELECT  Id,
                             HCM_Login_ID__c
                       FROM  User
                      WHERE  Id = :UserInfo.getUserId()];
        if (!IntegrationUserUtil.isSkipTrigger()){           
            for(Device__c deviceOld :(List<Device__c>)Trigger.Old){
                OppSetId.add(deviceOld.opportunity2__c);
            }
            Map<Id,Opportunity> oppOwnerMap2=new Map<Id,Opportunity>([select Id,Name,OwnerId,Owner.Name,Owner.IsActive from Opportunity where ID IN :OppSetId AND Owner.IsActive=true ]);    
            for(Device__c device: (List<Device__c>)trigger.new){
                if (oppOwnerMap2.ContainsKey(device.opportunity2__c)){
                    if (device.Primary_Device_AM__c == null){
                        device.Primary_Device_AM__c = oppOwnerMap2.get(device.opportunity2__c).OwnerId;
                        device.TapeOut_AM__c = device.Primary_Device_AM__c;
                    }
                    if (device.Primary_Device_AM__c!=oppOwnerMap2.get(device.opportunity2__c).OwnerId){
                        device.Primary_Device_AM__c =oppOwnerMap2.get(device.opportunity2__c).OwnerId;      
                    }        
                
                }
                //Added by Jabee//Modified by Ravi Teja.B
                String Device_Retrofit=Environment_Variable__c.getInstance('DEVICE_TYPE_RETROFIT').Value__c;
                if(device.CDRS_approval_User__c==null && device.Tapeout_Type__c==Device_Retrofit){ // && device.Base_Device__c!=null
                    if(device.Configuration_Status__c == null || (device.Configuration_Status__c != null && !device.Configuration_Status__c.contains('Process Flow Accepted'))){ //Modified By Ravi Teja.B 21072017
                        if(device.BX041_Form_Count__c>0 && device.BX041_Status__c == 'Closed'){
                            string CDRSApprovalUsers=DeviceTriggerHelper.CDRSapprovalUserPapulate(null,device.id,null);
                            if(CDRSApprovalUsers!=''){
                            device.CDRS_approval_User__c=CDRSApprovalUsers;
                            }
                        }
                        else if(device.NPC_Form__c!=null){
                            string CDRSApprovalUsers=DeviceTriggerHelper.CDRSapprovalUserPapulate(device.NPC_Form__c,null,device.Base_Device__c);
                            if(CDRSApprovalUsers!=''){
                            device.CDRS_approval_User__c=CDRSApprovalUsers;
                            }
                        }
                        else{
                            if(device.Base_Device__c!=null){
                                string CDRSApprovalUsers=DeviceTriggerHelper.CDRSapprovalUserPapulate(null,null,device.Base_Device__c);
                                if(CDRSApprovalUsers!=''){
                                device.CDRS_approval_User__c=CDRSApprovalUsers;
                                }
                            }
                        }
                    }
                }
                if(!(System.isBatch() || System.isScheduled()) &&
                    (device.MES_Device_Id__c != triggerOldMap.get(device.id).MES_Device_Id__c || device.Proto_Lot_Start_ID__c != triggerOldMap.get(device.id).Proto_Lot_Start_ID__c 
                    || device.Proto_Lot_Start_Date__c != triggerOldMap.get(device.id).Proto_Lot_Start_Date__c )){
                    device.ML_Sync_Id__c = system.now().format('yyyy-MM-dd','Asia/Singapore');
                    device.Updated_By_ML_Logic__c = false;
                    device.ML_Updated_By__c = UserInfo.getName();
                }
                
                if(!DeviceUtility.d1NatAccessFlag && (!DeviceTriggerHandler.isInternalDevice(device.RecordTypeId) || 
                    (DeviceTriggerHandler.isInternalDevice(device.RecordTypeId) && device.Account_Sub_Type__c == 'DE - IP'))){
                    if(!device.Is_D1_Nat_Allowed_Check__c &&  device.Export_Control_Waiver_Flag__c != 'Yes'
                        && device.D1_National_Access_Allowed__c != triggerOldMap.get(device.id).D1_National_Access_Allowed__c){
                        device.D1_National_Access_Allowed__c.addError(errorMsgD1NatAccess);
                    }
                    if(device.Is_D1_Nat_Allowed_Check__c){
                        device.Is_D1_Nat_Allowed_Check__c = false;
                    } 
                    DeviceUtility.d1NatAccessFlag = true; 
                }
                if(device.Previous_Enabling_Devices_MPW__c <> triggerOldMap.get(device.id).Previous_Enabling_Devices_MPW__c 
                    && device.Previous_Enabling_Devices_MPW__c <> null){
                    device.Enabled_via_previous_MPW_1__c = 'Yes';
                }
                if((device.Stage__c <> triggerOldMap.get(device.id).Stage__c) && (device.Stage__c == stageTapeout)){
                    device.Confidence_Level_Tapeout__c = '100';  
                }
                
                if(!DeviceTriggerHandler.isInternalDevice(device.RecordTypeId) && device.opportunity_program__c <> triggerOldMap.get(device.id).opportunity_program__c){
                    lstDevice.add(device);
                }else{
                    //else block for Internal Device 
                    if(device.Internal_Device_Geometry__c != triggerOldMap.get(device.id).Internal_Device_Geometry__c || device.Internal_Device_Process_Family__c !=
                        triggerOldMap.get(device.id).Internal_Device_Process_Family__c){
                        lstDevice.add(device);
                    }
                }
                if (!ReassignExportControl.hasRun){
                    if(UtilsString.isNotBlank(device.reassigned_export_control__c) &&                     
                        device.approve_reassign_export_control_number__c == 'Yes'){
                        reassignDeviceIDs.add(device.id);
                    }
                    if(UtilsString.isNotBlank(device.reassigned_export_control__c) &&                     
                        (device.approve_reassign_export_control_number__c == 'No' && 
                         device.approve_reassign_export_control_number__c <> triggerOldMap.get(device.id).approve_reassign_export_control_number__c)){
                       rejectedDeviceIDs.add(device.id);
                    } 
                }
                device.Name = device.Name.toUpperCase();
                device.Device_ID__c = device.Device_ID__c.toUpperCase();
                if (device.Name.toUpperCase() != triggerOldMap.get(device.Id).Name.toUpperCase()
                    || device.Tapeout_Type__c.toUpperCase() != triggerOldMap.get(device.Id).Tapeout_Type__c.toUpperCase()) {
                    device.Device_ID__c = (device.Name + device.Tapeout_Type__c.replace(' ', '')).toUpperCase();
                }
                if (device.Process_Technology_2__c != null) {
                    processTechnologyIds.add(device.Process_Technology_2__c);
                } else {
                    device.IP_Technology__c = '';
                    device.Process_Technology_Number__c = '';
                }
                if (device.Assigned_Process_ID__c != null) {
                    processIds.add(device.Assigned_Process_ID__c);
                }
                if (device.Tapeout_Type__c == Environment_Variable__c.getInstance('DEVICE_TAPEOUT_TYPE_GLOBALSHUTTLE_MPW').Value__c
                    && (device.MPW_Train_Number__c != triggerOldMap.get(device.Id).MPW_Train_Number__c || device.Name != triggerOldMap.get(device.Id).Name
                    || triggerOldMap.get(device.Id).Tapeout_Type__c !=  Environment_Variable__c.getInstance('DEVICE_TAPEOUT_TYPE_GLOBALSHUTTLE_MPW').Value__c)) {  
                    listDeviceMpw.add(device);
                }
                if (device.Proto_Lot_Start_ID__c != null && device.Proto_Lot_Start_ID__c != triggerOldMap.get(device.Id).Proto_Lot_Start_ID__c) {
                    device.Proto_Lot_Start_ID_Change_Date__c = date.today();
                }
                if(device.Device_Complete__c && device.NPC_Form_Originating_Device__c == null){
                   device.NPC_Form_Originating_Device__c = device.Id;
                } 
            }
            if (lstDevice.size() > 0){
                DeviceTriggerHelper.populateFilterLookupCriteria(lstDevice);
            }
            if(reassignDeviceIDs.size() > 0){
                ReassignExportControl.processReassign(triggerNewMap,reassignDeviceIDs);
            }
            if(rejectedDeviceIDs.size() > 0){
                ReassignExportControl.sendRejectedReassign( rejectedDeviceIDs);
            }
            if(ExpConApprovalSendMail.isRun == false ){   
                ExpConApprovalSendMail.validateExpConWaiver(trigger.new, triggerOldMap);    
                ExpConApprovalSendMail.sendEmail(trigger.new, triggerOldMap);                   
            }
            ManualDeviceHelper.retrofitDeviceCheck1(Trigger.new);
            if (processTechnologyIds.size() > 0) {
                Map<Id, Process_Technology__c> mapProcessTechnology = new Map<Id, Process_Technology__c>([SELECT      Id,
                                                                                                                      IP_Geometry_Technology__c,
                                                                                                                      PT_Number__c
                                                                                                            FROM      Process_Technology__c
                                                                                                           WHERE      Id IN :processTechnologyIds]);                
            
                 for (Device__c device : (List<Device__c>)Trigger.New) {
                     if (device.Process_Technology_2__c != null) {
                         if (mapProcessTechnology.containsKey(device.Process_Technology_2__c)) {
                            device.IP_Technology__c = mapProcessTechnology.get(device.Process_Technology_2__c).IP_Geometry_Technology__c;
                            device.Process_Technology_Number__c = mapProcessTechnology.get(device.Process_Technology_2__c).PT_Number__c;
                        }
                    }
                }
            }
            DeviceForLotCalculate.calculateForecastLotStartDate(trigger.new, triggerOldMap, 'Update');
            if (listDeviceMpw.size() > 0) { 
                DeviceMPWForecastedTapeoutDate.retrieveTapeoutDate(listDeviceMpw);
            }
            DeviceTapeoutReadStatus.devErrorHandling(trigger.new);
            if (processIds.size() > 0) {
                Map<String, Id> mapProcess = new Map<String, Id>(); 
                for (Process__c process : [SELECT     Id,
                                                Process_Technology__c
                                       FROM     Process__c
                                      WHERE     Id IN :processIds]) { 
                    mapProcess.put(process.Process_Technology__c, process.Id);
                }
                Map<Id, Id> mapPT = new Map<Id, Id>();
                for (Process_Technology__c ptech : [SELECT     Id,
                                                            PT_Number__c
                                                   FROM     Process_Technology__c
                                                  WHERE     PT_Number__c IN :mapProcess.keySet()]) {
                    if (mapProcess.containsKey(ptech.PT_Number__c)) {
                        mapPT.put(mapProcess.get(ptech.PT_Number__c), ptech.Id);
                    }
                }
                for (Device__c device : (List<Device__c>)Trigger.New) {
                    if (mapPT.containsKey(device.Assigned_Process_ID__c)) {
                        device.Process_Technology_2__c = mapPT.get(device.Assigned_Process_ID__c);
                    } 
                }
            }
        }  
        system.debug('end>>>>>>>>>>deviceUpdateBefore:SOQL queries:'+limits.getQueries());                          
    }
    
    /*********************************************************************************************************************************************************
    @ Method:         deviceUpdateAfter
    @ Version:        1.0
    @ Author:         Ishtpreet Singh (Ishtpreet.singh@globalfoundries.com)
    @ Purpose:        This Method is updating Device on after update event.
    **********************************************************************************************************************************************************/
    public void deviceUpdateAfter(){
        system.debug('start>>>>>>>>>>deviceUpdateAfter:SOQL queries:'+limits.getQueries());                    
            Set<Id> opptyProgramIds = new Set<Id>();
            Set<Id> deviceIds = new Set<Id>();
            Set<Id> opDeviceIds = new Set<Id>();
            Set<String> crmdids = new Set<String>();
            Set<Id> npcIds = new Set<Id>();
            set<id> acctIds = new set<id>();//Tlai 19052014
            List<Device__c> multiPidDevices  = new List<Device__c>(); 
            List<New_Part_Creation_Form__c> npcList = new List<New_Part_Creation_Form__c>();
            List<Opportunity_Program__c> listUpdateOpptyProgram = new List<Opportunity_Program__c>();
            List<IntegrationLog.IntegrationLogWrapper> intLogWrpList = new List<IntegrationLog.IntegrationLogWrapper>();    
            Map<Id, Date> mapNPC = new Map<Id, Date>();
            Map<Id, List<Device__c>> mapDevices = new Map<Id, List<Device__c>>();
        if (!IntegrationUserUtil.isSkipTrigger()){
            for(Device__c device : (List<Device__c>)trigger.new){
                if (device.NPC_Form__c!= null && device.device_type__c == DEVICE_TYPE_RETROFIT && triggerOldMap.get(device.id).Stage__c != device.Stage__c && device.Stage__c == DEVICE_TAPEOUT){
                    New_Part_Creation_Form__c npc = new New_Part_Creation_Form__c(id = device.NPC_Form__c, Generated_Device_Tapeout_Flag__c = true); 
                    npcList.add(npc);               
                }
                if (device.Assigned_Process_Id__c != null && triggerOldMap.get(device.Id).Assigned_Process_Id__c == null && !NPCFormTrigerStopper.isExecuted) {
                    npcIds.add(device.NPC_Form__c);
                }
                if (!DeviceTriggerHandler.isInternalDevice(device.RecordTypeId)){
                    if(device.expose_device_to_customer__c && !triggerOldMap.get(device.id).expose_device_to_customer__c){
                        lstDevice.add(device); 
                        acctIds.add(device.account__c);  //Tlai 19052014
                    }
                    if (device.Opportunity_Program__c != triggerOldMap.get(device.Id).Opportunity_Program__c) {
                        opDeviceIds.add(device.Id);
                    }
                    if ((device.Stage__c != triggerOldMap.get(device.Id).Stage__c) && (device.Stage__c==stageTapeout) 
                        && device.Tapeout_Type__c != tapeoutGlobalShuttle && device.Opportunity__c != null){
                        opProg.add(device.Opportunity__c);
                    }
                    else if((device.Stage__c != triggerOldMap.get(device.Id).Stage__c) && (device.Stage__c==deviceProd) && device.Opportunity__c != null){
                        opProgProd.add(device.Opportunity__c);
                    }
                    if (triggerOldMap.get(device.Id).IP_Gap__c != triggerNewMap.get(device.Id).IP_Gap__c && device.Opportunity_Program__c != null) {
                        opptyProgramIds.add(device.Opportunity_Program__c);
                    }
                }
                if (device.Stage__c == 'Prototype' && triggerOldMap.get(device.Id).Stage__c != 'Prototype') {
                    crmdids.add(device.CRMDID__c);
                }
                if(device.Assigned_Process_ID__c != NULL && triggerOldMap.get(device.id).Assigned_Process_ID__c != device.Assigned_Process_ID__c){
                    multiPidDevices.add(device);   
                }
                if (device.Current_Forecast_Tapeout_Date__c != triggerOldMap.get(device.Id).Current_Forecast_Tapeout_Date__c) {
                    system.debug('Current_Forecast_Tapeout_Date__c**'+device.Current_Forecast_Tapeout_Date__c +'----'+ triggerOldMap.get(device.Id).Current_Forecast_Tapeout_Date__c);
                     mapNPC.put(device.NPC_Form__c, device.Current_Forecast_Tapeout_Date__c);
                }
            }
            if(npcList.size() >0){
                NPCFormTrigerStopper.isExecuted = true;
                update npcList;
            }
            if (npcIds.size() > 0) {
                NPCFormTrigerStopper.isExecuted = true;
                updateNPCs(npcIds);
            }
            if(multiPidDevices.size() > 0){
                MultiplePIDDeviceUpdateTriggerHandler MultAssignedPID = new MultiplePIDDeviceUpdateTriggerHandler();
                MultAssignedPID.multiplePIDassignmentMethod(multiPidDevices, triggerOldMap, triggerNewMap);
            } 
            if(lstDevice.size() > 0 && !ExposeDeviceToCustomer.hasExposeRun){
                ExposeDeviceToCustomer.validate(lstDevice,acctIds);
            }
            if (opDeviceIds.size() > 0) {
                updateOPDevices(opDeviceIds);
            }
            if (deviceIds.size() > 0) {
                updateDevices(deviceIds);
            }
            if (mapNPC.size() > 0) {
                updateNPCCurrentForecastTapeoutDate(mapNPC);
            }
            if (crmdids.size() > 0) {
                NPCFormUpdateStatus.updateNPC(crmdids);
            }
            if(opProg!=null && opProg.size()>0){
                updateOpp();
            }
            if(opProgProd!=null && opProgProd.size()>0){
                updateOppProg();
            }
            
            Map<Id, Opportunity_Program__c> mapOpptyPrograms = null;
            if(opptyProgramIds != null && !opptyProgramIds.isEmpty()){
                mapOpptyPrograms = new Map<Id, Opportunity_Program__c>([SELECT      Id,
                                                                                    IP_Gaps__c
                                                                          FROM      Opportunity_Program__c
                                                                         WHERE      Id IN :opptyProgramIds ]);
                
            } 
            if (mapOpptyPrograms != null && mapOpptyPrograms.size() > 0) {
                List<Device__c> listDevices = [ SELECT  Id,
                                                        Opportunity_Program__c,
                                                        IP_Gap__c
                                                  FROM  Device__c
                                                 WHERE  Opportunity_Program__c IN :opptyProgramIds
                                              ORDER BY  Opportunity_Program__c ];
            
                String opId = '';
                for (Device__c device : listDevices) {
                    if (opId != (String)device.Opportunity_Program__c) {
                        opId = device.Opportunity_Program__c;
                        List<Device__c> tempList = new List<Device__c>();
                        tempList.add(device);
                        mapDevices.put(device.Opportunity_Program__c, tempList);
                    } else {
                        List<Device__c> tempList = mapDevices.get(device.Opportunity_Program__c);
                        tempList.add(device);
                        mapDevices.put(device.Opportunity_Program__c, tempList);
                    }
                }
                for (String key : mapDevices.keySet()) {
                    List<Device__c> tempList = mapDevices.get(key);
                    Boolean isAllUnchecked = True;
                    for (Device__c device : tempList) {
                        if (device.IP_Gap__c == True) {
                            Opportunity_Program__c op = mapOpptyPrograms.get(key);
                            if (op.IP_Gaps__c == False) {
                                op.IP_Gaps__c = True;
                                listUpdateOpptyProgram.add(op);
                                isAllUnchecked = False;
                                break;
                            } else {
                                isAllUnchecked = False;
                                break;
                            }
                        }    
                    }
                    if (isAllUnchecked == True) {
                        Opportunity_Program__c op = mapOpptyPrograms.get(key);
                        if (op.IP_Gaps__c == True) {
                            op.IP_Gaps__c = False;
                            listUpdateOpptyProgram.add(op);
                        }
                    }
                }
                if (listUpdateOpptyProgram.size() > 0) {
                    Update listUpdateOpptyProgram;
                }
                for (Device__c device: (List<Device__c>)trigger.new){
                    if ((triggerOldMap.get(device.Id).Siebel_Status__c !=  device.Siebel_Status__c)  && 
                        (device.Siebel_Status__c == 'ERROR' || device.Siebel_Status__c == 'SUCCESS' )){
                        IntegrationLog.IntegrationLogWrapper intLogWrp = new IntegrationLog.IntegrationLogWrapper('Device',
                                                                                                                   device.ID,
                                                                                                                   device.Siebel_Sync_ID__c,
                                                                                                                   device.Siebel_Error_Message__c,
                                                                                                                   device.Siebel_Operation__c,
                                                                                                                   device.Siebel_Status__c,
                                                                                                                   device.Siebel_Sent_DateTime__c );

                       // Adding the IntegrationLogWrapper object to a list
                       intLogWrpList.add(intLogWrp);
                    }          
                }
                if(intLogWrpList.size()>0){
                    IntegrationLog.addIntegrationLogList(intLogWrpList);
                }                                     
            }       
        }    
        system.debug('end>>>>>>>>>>deviceUpdateAfter:SOQL queries:'+limits.getQueries());                            
    }
    /*********************************************************************************************************************************************************
    @ Method:         deviceOnholdDateUpdt
    @ Version:        1.0
    @ Author:         Ishtpreet Singh (Ishtpreet.singh@globalfoundries.com)
    @ Purpose:        This Method is updating Date_On_Hold_Was_Removed__c  field on device.
    **********************************************************************************************************************************************************/
    public void deviceOnholdDateUpdt(){
        system.debug('start>>>>>>>>>>deviceOnholdDateUpdt:SOQL queries:'+limits.getQueries());                        
        Set<Id> opptyProgramIds = new Set<Id>();
        Set<string> setOPTM = new Set<string>();
        Map<Id, Id> mapDeviceOpptyProgram = new Map<Id, Id>();
        for(Device__c device : (List<Device__c>)trigger.new) {
            if (device.Status__c == 'On Hold' && triggerOldMap.get(device.Id).Status__c != 'On Hold'
                || device.Status__c != 'On Hold' && triggerOldMap.get(device.Id).Status__c == 'On Hold') {
                mapDeviceOpptyProgram.put(device.Id, device.Opportunity_Program__c);
                opptyProgramIds.add(device.Opportunity_Program__c);
            }
        }
        if (mapDeviceOpptyProgram.size() > 0) {
            for (Opportunity_Program_Team_Member__c o : [SELECT    Id,
                                                                   Opportunity_Program__c,
                                                                   Team_Role__c,
                                                                   User__c
                                                           FROM    Opportunity_Program_Team_Member__c
                                                          WHERE    Opportunity_Program__c IN :opptyProgramIds
                                                            AND    User__c = :UserInfo.getUserId()
                                                            AND    (Team_Role__c IN ('Field Application Engineer',
                                                                                     'Primary Field Technical Support',
                                                                                     'Primary Field Application Engineer',
                                                                                     'Field Technical Support')
                                                             OR    ( Team_Role__c =  'Account Manager' AND Is_FAE__c = TRUE)
                                                             OR    ( Team_Role__c =  'Primary Account Manager' AND Is_FAE__c = TRUE) )]) {
                setOPTM.add(o.Opportunity_Program__c);
            }
            Profile userProfile = [SELECT    Name
                                     FROM    Profile
                                    WHERE    Id = :UserInfo.getProfileId()];
            
            for (Device__c device : (List<Device__c>)trigger.new) {
                // Check user's profile
                boolean isQualified = true;
                if (userProfile.Name != 'System Administrator' 
                    && userProfile.Name != 'GF System Admin' 
                    && userProfile.Name != 'GF Integration' 
                    && userProfile.Name != 'GF FAE/FTS') {
                    // Check user's Opportunity Program Team Role
                    if (!setOPTM.contains(device.Opportunity_Program__c)) {
                        isQualified = false;
                        if (device.Status__c == 'On Hold' && triggerOldMap.get(device.Id).Status__c != 'On Hold') {
                            device.addError('Only FE or System Admins can update Device Status to On Hold');
                        } else if (device.Status__c != 'On Hold' && triggerOldMap.get(device.Id).Status__c == 'On Hold') {
                            device.addError('Only FE or System Admins can update Device Status from On Hold');
                        }
                    } 
                }
                
                if (isQualified) {
                    if (device.Status__c == 'On Hold' && triggerOldMap.get(device.Id).Status__c != 'On Hold') {
                        device.Date_On_Hold_Was_Removed__c = null;
                    } else if (device.Status__c != 'On Hold' && triggerOldMap.get(device.Id).Status__c == 'On Hold') {
                        device.Date_On_Hold_Was_Removed__c = date.today();
                    }
                }
            }                        
        }
        system.debug('end>>>>>>>>>>deviceOnholdDateUpdt:SOQL queries:'+limits.getQueries());                                
    }
    
    /*********************************************************************************************************************************************************
    @ Method:         updateOpptyDWField
    @ Version:        1.0
    @ Author:         Ishtpreet Singh (Ishtpreet.singh@globalfoundries.com)
    @ Purpose:        This Method is updating Oppotunity DW field on Opportunity object.
    **********************************************************************************************************************************************************/
    public void updateOpptyDWField(){
        system.debug('start>>>>>>>>>>updateOpptyDWField:SOQL queries:'+limits.getQueries());                            
        OpptyGeometryValidator.DeviceProcessor(triggerOldMap, triggerNewMap);
        system.debug('end>>>>>>>>>>updateOpptyDWField:SOQL queries:'+limits.getQueries());                            
    }
    
    /*********************************************************************************************************************************************************
    @ Method:         updateOpp
    @ Version:        1.0
    @ Author:         Ishtpreet Singh (Ishtpreet.singh@globalfoundries.com)
    @ Purpose:        This method is updating Opportunity stage field on Opportunity depends on device.
    **********************************************************************************************************************************************************/
  @testvisible  private void updateOpp(){
    
        list<opportunity> opporList = new list<opportunity>();
            for(Opportunity opp:[select Id,StageName from Opportunity where Id=:opProg]){
                if(mapOpptyStage.get(opp.StageName)<mapOpptyStage.get(oppStgNm6)){
                    opp.StageName = oppStgNm6;
                    opporList.add(opp);
                }
            }
            
        try{
            if(opporList.size()>0)
                update opporList;
        }catch(Exception ex){
            
            catchCover(string.valueof(Device__c.Id),string.valueof(ex.getMessage()),'updateOpp()');                         
        }
    }
    
    /*********************************************************************************************************************************************************
    @ Method:         updateOppProg
    @ Version:        1.0
    @ Author:         Ishtpreet Singh (Ishtpreet.singh@globalfoundries.com)
    @ Purpose:        This method is updating Opportunity stage  and status field on Opportunity depends on device.
    **********************************************************************************************************************************************************/
   @testvisible private void updateOppProg(){        
         List<Opportunity> opporList = new list<Opportunity>();   
            for(Opportunity opp:[select Id,StageName,Status__c from Opportunity where Id=:opProgProd]){
                if(mapOpptyStage.get(opp.StageName)<mapOpptyStage.get(oppStgNm7)){
                    opp.StageName = oppStgNm7;
                    opp.Status__c = oppStatus;
                    opporList.add(opp);
                }
            }
        try{
            if(opporList.size()>0)
                update opporList;
        }catch(Exception ex){
            catchCover(string.valueof(Device__c.Id),string.valueof(ex.getMessage()),'deviceMaskSetTitlelookUp()');                         
             
        }  
    }
    
    /*********************************************************************************************************************************************************
    @ Method:         updateDevices
    @ Version:        1.0
    @ Author:         Ishtpreet Singh (Ishtpreet.singh@globalfoundries.com)
    @ Purpose:        This method is setting Send_for_Integration__c field to true on device 
    **********************************************************************************************************************************************************/
 @testvisible   private void updateDevices(Set<Id> devIds) {
    }
    
    /*********************************************************************************************************************************************************
    @ Method:         updateNPCs
    @ Version:        1.0
    @ Author:         Ishtpreet Singh (Ishtpreet.singh@globalfoundries.com)
    @ Purpose:        This method is updating fields on New_Part_Creation_Form__c object. 
    **********************************************************************************************************************************************************/
    @TestVisible
    private void updateNPCs(Set<Id> npcIds) {
        Set<Id> tempIds = new Set<Id>();
        Map<Id, New_Part_Creation_Form__c> mapNPC = new Map<Id, New_Part_Creation_Form__c>();
        for (New_Part_Creation_Form__c n : [SELECT    Id
                                                      , NPC_Form_Status__c
                                                      , Reason_for_New_Part__c
                                                      , Originating_Device__r.Opportunity_Program__c
                                                      , PIYE_Approver_1__c
                                                      , PIYE_Approver_2__c
                                                      , PIYE_Approver_3__c,PIYE_Approver_4__c
                                                      , Fab__c
                                            FROM      New_Part_Creation_Form__c
                                            WHERE     Id IN :npcIds
                                                      AND (Reason_for_New_Part__c = :EnvironmentVariable.get('NPC_REASON_FAB_TRANSFER')
                                                           OR Reason_for_New_Part__c = :EnvironmentVariable.get('NPC_REASON_CHANGE_PID'))]) {
            if (n.PIYE_Approver_1__c == null && n.PIYE_Approver_2__c == null && n.PIYE_Approver_3__c == null && n.PIYE_Approver_4__c==null) {
                if (Environment_Variable__c.getInstance('NPC_FAB_LIST').Value__c.contains(n.Fab__c) && n.Reason_for_New_Part__c != EnvironmentVariable.get('NPC_REASON_FAB_TRANSFER')) {
                    integer ctr = 1;
                    for (string s : Environment_Variable__c.getInstance('Fab235Approvers').Value__c.split(',')) {
                        if (ctr == 1) {
                            n.PIYE_Approver_1__c = s;
                        } else if (ctr == 2) {
                            n.PIYE_Approver_2__c = s;
                        } else if (ctr == 3) {
                            n.PIYE_Approver_3__c = s;
                        } else if (ctr == 4) {
                            n.PIYE_Approver_4__c = s;
                        }
                        ctr++;
                    }
                    n.No_of_PIYE_Approvers__c = (ctr - 1);
                } else {
                    tempIds.add(n.Id);    
                }
            }    
            mapNPC.put(n.Id, n);
        }
        
        if (tempIds.size() > 0) {
            Map<Id, BX_041__c> mapCDRS = new Map<Id, BX_041__c>();
            for (Device__c d : [SELECT    Id,
                                          NPC_Form__c,
                                          (SELECT     Approver_1__c,
                                                      Approver_2__c,
                                                      Approver_3__c
                                             FROM     BX_041__r)
                                  FROM    Device__c
                                 WHERE    NPC_Form__c = :tempIds]) {
                mapCDRS.put(d.NPC_Form__c, d.BX_041__r);
            }
            
            for (string key : mapNPC.keySet()) {
                if (mapNPC.get(key).PIYE_Approver_1__c == null && mapNPC.get(key).PIYE_Approver_2__c == null && mapNPC.get(key).PIYE_Approver_3__c == null  && mapNPC.get(key).PIYE_Approver_4__c == null ) {
                    if (mapCDRS.containsKey(key)) {
                        List<string> tempList = new List<string>();
                        if (mapCDRS.get(key).Approver_1__c != null) {
                            tempList.add(mapCDRS.get(key).Approver_1__c);
                        }
                        
                        for (integer i=0; i<tempList.size(); i++) {
                            if (i == 0) {
                                 mapNPC.get(key).PIYE_Approver_1__c = tempList[i];
                            }
                        }
                        mapNPC.get(key).No_of_PIYE_Approvers__c = tempList.size();
                    }
                }
            }
        }
        
        if (mapNPC.size() > 0) {
            approvalNPC(mapNPC);
        }
    }
    
    /*********************************************************************************************************************************************************
    @ Method:         approvalNPC
    @ Version:        1.0
    @ Author:         Ishtpreet Singh (Ishtpreet.singh@globalfoundries.com)
    @ Purpose:        This method is executing approval process after submission of NPC form.
    **********************************************************************************************************************************************************/
    public void approvalNPC(Map<Id, New_Part_Creation_Form__c> mapNPC) {
        system.debug('start>>>>>>>>>>approvalNPC:SOQL queries:'+limits.getQueries());                                 
    
        for(ProcessInstance pi : [SELECT Id, TargetObjectId, (SELECT Id, StepStatus, Comments FROM Steps) FROM ProcessInstance 
                                    WHERE TargetObjectId IN: mapNPC.keySet() AND Status = 'Pending'])
        {
            if(pi != null && pi.Steps.size() > 0){
                approveNPC2(pi.Id,pi.TargetObjectId);
            }
        }
        for (string key : mapNPC.keySet()) {
            mapNPC.get(key).NPC_Form_Status__c = EnvironmentVariable.get('NPC_STATUS_IN_EXEC');
        }
        update mapNPC.values();
        system.debug('mapNPC ========================> ' + mapNPC);
        
        for(Id npcId : mapNPC.keySet()){
            Approval.ProcessSubmitRequest req = new Approval.ProcessSubmitRequest();
            req.setComments('Submitted for PIYE Approval');    
            req.setObjectId(npcId);
            Approval.ProcessResult result = Approval.process(req);
            
        }  
        system.debug('start>>>>>>>>>>approvalNPC:SOQL queries:'+limits.getQueries());                                          
    }
    
    /*********************************************************************************************************************************************************
    @ Method:         approveNPC2
    @ Version:        1.0
    @ Author:         Ishtpreet Singh (Ishtpreet.singh@globalfoundries.com)
    @ Purpose:        This method is executing approval process after submission of NPC form.
    **********************************************************************************************************************************************************/
     public void approveNPC2(Id piId,Id npcId) {
        system.debug('start>>>>>>>>>>approveNPC2:SOQL queries:'+limits.getQueries());                                 
        ProcessInstanceWorkitem piwi = [SELECT Id,OriginalActorId from ProcessInstanceWorkitem 
                                            WHERE ProcessInstanceId= :piId LIMIT 1];
        Approval.ProcessWorkitemRequest PWR = new Approval.ProcessWorkitemRequest();
        PWR.setComments('Submitted for PIYE Approval');
        PWR.setAction('Approve');
        PWR.setWorkitemId(piwi.id);
        Approval.ProcessResult result =  Approval.process(PWR); 
        system.debug('end>>>>>>>>>>approveNPC2:SOQL queries:'+limits.getQueries());                                         
    }
    
    /*********************************************************************************************************************************************************
    @ Method:         updateOPDevices
    @ Version:        1.0
    @ Author:         Ishtpreet Singh (Ishtpreet.singh@globalfoundries.com)
    @ Purpose:        This method is updating the opportunity & account fields on Device from Opportunity_Program__c object.
    **********************************************************************************************************************************************************/
 @TestVisible 
 private void updateOPDevices(Set<Id> opDIds) {
        List<Device__c> deviceList = [
            SELECT      Id
                        , Opportunity_Program__c
            FROM        Device__c
            WHERE       Id IN :opDIds
        ];
    
        Set<Id> opIds = new Set<Id>();
        for (Device__c d : deviceList) {
            opIds.add(d.Opportunity_Program__c);
        }
        
        Map<Id, Opportunity_Program__c> mapOP = new Map<Id, Opportunity_Program__c>([
            SELECT      Id
                        , Opportunity__c
                        , Opportunity__r.AccountId
            FROM        Opportunity_Program__c
            WHERE       Id IN :opIds
        ]);
        
        // Assign new values
        for (Device__c device : deviceList) {
            if (mapOP.containsKey(device.Opportunity_Program__c)) {
                Opportunity_Program__c tempOP = mapOP.get(device.Opportunity_Program__c);
                device.Opportunity2__c = tempOP.Opportunity__c;
                device.Account__c = tempOP.Opportunity__r.AccountId;
            }
        }
        
        Update deviceList;
    }
    
    /*********************************************************************************************************************************************************
    @ Method:         updateNPCCurrentForecastTapeoutDate
    @ Version:        1.0
    @ Author:         Ishtpreet Singh (Ishtpreet.singh@globalfoundries.com)
    @ Purpose:        This method is updating the Current_Forecast_Tapeout_Date__c field on New_Part_Creation_Form__c object.
    **********************************************************************************************************************************************************/
    @testvisible 
    private void updateNPCCurrentForecastTapeoutDate(Map<Id, Date> mapNPCDate) {
        List<New_Part_Creation_Form__c> listUpdateNPC = new List<New_Part_Creation_Form__c>(); 
        for (New_Part_Creation_Form__c n : [SELECT      Id
                                                        , Current_Forecast_Tapeout_Date__c
                                            FROM        New_Part_Creation_Form__c
                                            WHERE       Id IN :mapNPCDate.keySet()]) {
            n.Current_Forecast_Tapeout_Date__c = mapNPCDate.get(n.Id);
            listUpdateNPC.add(n);
        }
        
        if (listUpdateNPC.size() > 0) {
            update listUpdateNPC;
        }
    }
    
    /*********************************************************************************************************************************************************
    @ Method:         updatGenerateStandardFrame
    @ Version:        1.0
    @ Author:         Pradosh Samal (pradosh.samal@globalfoundries.com)
    @ Purpose:        This method is to update the Generate_Standard_Frame__c based on Fab__c field on Device__c object.
    **********************************************************************************************************************************************************/    
    public void updatGenerateStandardFrame(){
        
        for (Device__c device : (List<Device__c>)Trigger.new){
            
            if(device.Fab__c != NULL && (device.Fab__c == 'FAB 9' || device.Fab__c == 'FAB 10')){
                device.Generate_Standard_Frame__c = 'No';
            }
        }
    }
    
    public void catchCover(String deviceid, String mssg,String MethodName  ){
                
        ApplicationLogWrapper appLog = new  ApplicationLogWrapper();
                 appLog.source = 'Device_TriggerHelper';
                 appLog.sourceFunction = MethodName;
                 appLog.ApplicationName = 'Device Management';
                 appLog.referenceId = deviceid;
                 appLog.referenceInfo = 'Device';
                 appLog.logMessage = mssg;
                 appLog.payload = '';
                 appLog.debugLevel = 'Error';
                GlobalUtility.logMessage(appLog); 
   }
    
    /*********************************************************************************************************************************************************              
    @ Method:         deviceSharingAccess                
    @ Version:        1.0               
    @ Author:         Manikumar             
    @ Purpose:        This Method run on device to share the access to all active Account Team Proxy and contact users.             
    **********************************************************************************************************************************************************/                 
    @future
    public static void deviceSharingAccess(string devJson){                   
        try {
            Device__c dev =(Device__c)(Json.deserialize(devJson,Device__c.class));
            Set<Id> atpUserIds = new Set<Id>();
            if(dev.Design_Partner__c != null && dev.expose_device_to_customer__c) {
                for(Account_Team_Proxy__c atpObj : [SELECT Id, Account__c, User__c FROM Account_Team_Proxy__c
                                                        WHERE User__r.IsActive = true And Account__c = : dev.Design_Partner__c]){
                    atpUserIds.add(atpObj.User__c);                                                    
                } 
                
                List<id> devExpCntlIdList = new List<id>();
                for(Device__c dev1 : [SELECT id, (SELECT Id, Export_Control_Form__c from Device_Export_Control_Junctions__r) from Device__c WHERE id=:dev.Id]){
                    for(Device_Export_Control_Junction__c devExpContrl : dev1.Device_Export_Control_Junctions__r){
                            devExpCntlIdList.add(devExpContrl.Export_Control_Form__c);
                    }
                }
                
                List<Device__Share> DeviceSharingList=new List<Device__Share>();
                Map<Id,Device__Share> DeviceSharingMap=new Map<Id,Device__Share>();
                for(Device__Share DS :[SELECT AccessLevel,Id,ParentId,UserOrGroupId FROM Device__Share where ParentId=:dev.Id]){
                    DeviceSharingMap.put(DS.UserOrGroupId,DS);
                }
                
                List<Export_Control_Form__Share> ExpContrlJuncSharingList=new List<Export_Control_Form__Share>();
                Map<Id,Export_Control_Form__Share> ExpContrlJuncSharingMap=new Map<Id,Export_Control_Form__Share>();
                if(devExpCntlIdList.size() > 0){
                    for(Export_Control_Form__Share ExpS :[SELECT AccessLevel,Id,ParentId,UserOrGroupId FROM Export_Control_Form__Share where ParentId IN :devExpCntlIdList]){
                        ExpContrlJuncSharingMap.put(ExpS.UserOrGroupId,ExpS);
                    }
                }
                
                List<User> accessUsersList = [select Id,Name,ContactId,Contact.AccountId,IsActive from User where IsActive=true AND (Contact.AccountId=:dev.Design_Partner__c OR Id IN :atpUserIds)];
                if(accessUsersList != null && !accessUsersList.isEmpty()){
                    for(User AccessUsers : accessUsersList) {
                        if(!DeviceSharingMap.containsKey(AccessUsers.Id)) {
                            Device__Share Deviceshare=new Device__Share();
                            Deviceshare.AccessLevel='Edit';
                            Deviceshare.ParentId=dev.Id;
                            Deviceshare.UserOrGroupId=AccessUsers.id; 
                            Deviceshare.RowCause=Schema.Device__Share.RowCause.Design_Partner_Sharing__c;
                            DeviceSharingList.add(Deviceshare);
                        }
                    }
                }
                if(devExpCntlIdList.size() > 0){
                    for(Id devExpContrlId : devExpCntlIdList){
                        if(accessUsersList != null && !accessUsersList.isEmpty()){
                            for(User AccessUsers : accessUsersList) {
                                if(!ExpContrlJuncSharingMap.containsKey(AccessUsers.Id)) {
                                    Export_Control_Form__Share ExpContrlshare=new Export_Control_Form__Share();
                                    ExpContrlshare.AccessLevel='Edit';
                                    ExpContrlshare.ParentId=devExpContrlId;
                                    ExpContrlshare.UserOrGroupId=AccessUsers.id; 
                                    ExpContrlshare.RowCause=Schema.Export_Control_Form__Share.RowCause.Design_Partner_Sharing__c;
                                    ExpContrlJuncSharingList.add(ExpContrlshare);
                                }
                            }
                        }
                    }
                }
                
                if(DeviceSharingList.size()>0){
                    Database.insert(DeviceSharingList,false);
                }  

                if(ExpContrlJuncSharingList.size()>0){
                    Database.insert(ExpContrlJuncSharingList,false);
                }
            }
            if(Test.isRunningTest()) {
                throw new applicationException('In Test Mode');
            }
        }catch(Exception e){
                ApplicationLogWrapper alw=new ApplicationLogWrapper();
                alw.source = Device_TriggerHelper.class.getName();
                alw.sourceFunction ='deviceSharingAccess()';
                alw.ApplicationName='Device Management';                   
                alw.referenceInfo = 'Device Management';
                alw.logMessage ='Error Message='+e.getMessage()+' At Line Number='+e.getLineNumber()+' Stack Trace='+e.getStackTraceString();
                alw.debugLevel ='Error';
                alw.logCode =e.getTypeName();
                alw.ex=e.getCause();
                GlobalUtility.logMessage(alw);
        }
            
    }
    
    public class applicationException extends Exception {}     

  /*********************************************************************************************************************************************************
    @ Method:         Device Naming validation
    @ Version:        1.0
    @ Author:         Devendra babu Itraju
    @ Purpose:        This Method validates and populate the name for Device object.
    **********************************************************************************************************************************************************/
    public void nameValidationForDevice(){
         for(Device__c dev: (List<Device__c >)Trigger.new){
            string startDate=EnvironmentVariable.get('NameValidationStartDate');
            if(startDate!=null && startDate!=''){
            Date D=Date.newInstance(Integer.valueof(startDate.split('/')[2]), Integer.valueof(startDate.split('/')[0]), Integer.valueof(startDate.split('/')[1]));
                if(dev.createddate > d){
                    boolean isCorrectFormat=false;
                        if(dev.name!=null && dev.Fab__c=='FAB 3E' || dev.Fab__c=='FAB 5'){
                        boolean ismatch=Pattern.matches('^[a-zA-Z0-9\\-_\\.]+$', dev.name);
                        if(!ismatch)dev.adderror('Device ID can only be alphanumeric (0-9, A-Z, \'-\', \'_\', \'.\').');
                        else isCorrectFormat=true;
                    }else
                    if(dev.name!=null && dev.Fab__c=='FAB 1' ||
                                         dev.Fab__c=='FAB 2' ||
                                         dev.Fab__c=='FAB 3' ||
                                         dev.Fab__c=='FAB 6' ||
                                         dev.Fab__c=='FAB 7' ||
                                         dev.Fab__c=='FAB 8'){
                        boolean ismatch=Pattern.matches('^([\\dA-Za-z-_]+\\.(?!00)\\d{2}$).*', dev.name);
                        if(!ismatch)dev.adderror('Device ID must be in the "DeviceID.REV" format, where DeviceID is alphanumeric (0-9, A-Z, \'-\', \'_\') and REV is 2-digit number (01-99 inclusive).');
                        else isCorrectFormat=true;
                    }
                    
                    if(isCorrectFormat){
                        if(!dev.name.startswith('MPW') && dev.Tapeout_Type__c=='GlobalShuttle MPW')dev.adderror('For GlobalShuttle MPW tapeout, Device ID has to start with "MPW"');
                    }
                }
            }ELSE{
                dev.ADDERROR('Please update the customsetting value for NameValidationStartDate in EnvironmentVariable custom setting');
            }
            
        }
    }

   
    /*********************************************************************************************************************************************************
    @ Method:         updateMaskSetTitle
    @ Version:        1.0
    @ Author:         Devendra
    @ Purpose:        This method is updating the MaskSetTitle for Fab 9 and 10.
                      Format :  Random alphanumeric string with 7 characters 
    This will work for changes only from visualforce page for single record and doesnt support bulk 
    **********************************************************************************************************************************************************/
    public void updateMaskSetTitle() {
        
        Device__c dev=(device__c)Trigger.new[0];
        
        if(dev.Fab__c!=null && (dev.Fab__c=='FAB 9'||dev.Fab__c=='FAB 10'||dev.Fab__c=='Altis')){
          if(trigger.isbefore && (trigger.isinsert||(trigger.isupdate &&  dev.Device_Mask_Set_Title__c==null ))){
                dev.Device_Mask_Set_Title__c = generateRandomString();
                Mask_Set_Title__c MST = new Mask_Set_Title__c (); 
                MST.Name = dev.Device_Mask_Set_Title__c;
                MST.Reticle_Type__c = dev.Reticle_Type__c;
                MST.Number_of_Prime_Die__c = dev.Expected_no_of_Prime_Die__c;
                mst.forFab9and10__c=TRUE;                    
                if(dev.Secure_Device__c == 'Yes'){
                    MST.Mask_Set_Classification__c = 'Secure';  
                }
                String Geometry2 = String.valueof(dev.Geometry_NM__c);
                MST.Technology__c = Geometry2;
                stopMSTTriggerforFab9_10=true;
                insert mST;
                dev.Mask_Set_Title_Lookup__c=mst.id;
              }else{
                  Device__c olddev=(device__c)Trigger.old[0];
                  if(dev.Device_Mask_Set_Title__c!=olddev.Device_Mask_Set_Title__c){
                      //dev.adderror('Maskset title is not editable');
                  }
              } 
            }
           
        }
   
    //
    public static string  generateRandomString() {
        Blob blobKey = crypto.generateAesKey(128);
        String key = EncodingUtil.convertToHex(blobKey);
        String pwd = key.substring(0,7);
        //System.debug('************ '+pwd);
        while(pwd.isnumeric()){
        blobKey = crypto.generateAesKey(128);
        key = EncodingUtil.convertToHex(blobKey);
        pwd = key.substring(0,7);
        }
        List<Mask_Set_Title__c> msTList=[SELECT Name FROM Mask_Set_Title__c where name=:pwd ];
        if(!msTList.isempty()){
            blobKey = crypto.generateAesKey(128);
            key = EncodingUtil.convertToHex(blobKey);
            pwd = key.substring(0,7);
        }
        pwd=pwd.toUpperCase();
        return pwd; 
    }
    
    /*********************************************************************************************************************************************************
    @ Method:         updateERPDevice when the below fields are updated 
    @ Version:        1.0
    @ Author:         Devendra
    @ Purpose:        This method is updating the fields in the ERP Device 
    **********************************************************************************************************************************************************/
    /*********************************************************************************************************************************************************
    @ Method:         updateERPDevice when the below fields are updated 
    @ Version:        1.0
    @ Author:         Devendra
    @ Purpose:        This method is updating the fields in the ERP Device 
    **********************************************************************************************************************************************************/
    public void DeviceToERPDeviceDataFlow() {
        set<string> devIdSet=new set<string>();
        for(Device__c dev:(List<Device__c>)trigger.new){
            if(triggerOldMap.get(dev.id).Is_ITAR__c!=triggerNewMap.get(dev.id).Is_ITAR__c||
                triggerOldMap.get(dev.id).PSA__c!=triggerNewMap.get(dev.id).PSA__c||
                triggerOldMap.get(dev.id).PSC__c!=triggerNewMap.get(dev.id).PSC__c||
                triggerOldMap.get(dev.id).CRMDID__c!=triggerNewMap.get(dev.id).CRMDID__c||
                triggerOldMap.get(dev.id).Business_Unit__c!=triggerNewMap.get(dev.id).Business_Unit__c||
                triggerOldMap.get(dev.id).Product_Line__c!=triggerNewMap.get(dev.id).Product_Line__c||
                triggerOldMap.get(dev.id).Fab__c!=triggerNewMap.get(dev.id).Fab__c||
                triggerOldMap.get(dev.id).Assigned_Process_ID__c!=triggerNewMap.get(dev.id).Assigned_Process_ID__c){
    
                devIdSet.add(dev.id);
            }
        }
        if(!devIdSet.isempty())Device_TriggerHelper.updateERPDevices(devIdSet);
        
    }
    
    @future
    public static void updateERPDevices(set<string> devIdSet){
        try{
            List<ERP_Device__c> erpDevToUpdate=[select id,Business_Unit__c,Device__c,CRMDID__c,Product_Line__c,Device__r.fab__c,
                                                Process_ID__c,ITARNew__c,PSANew__c,PSCNew__c,Integration_Status__c,
                                                Device__r.Business_Unit__c,Device__r.CRMDID__c,Device__r.Product_Line__c,
                                                Device__r.Assigned_Process_ID__c,Device__r.Is_ITAR__c,Device__r.PSA__c,
                                                Device__r.PSC__c from ERP_Device__c where Device__c in : devIdSet];
            for(ERP_Device__c e:erpDevToUpdate){
                e.ITARNew__c=e.Device__r.Is_ITAR__c;
                e.Process_ID__c=e.Device__r.Assigned_Process_ID__c;
                e.Business_Unit__c=e.Device__r.Business_Unit__c;
                e.PSANew__c=e.Device__r.PSA__c;
                e.PSCNew__c=e.Device__r.PSC__c;
                e.Product_Line__c=e.Device__r.Product_Line__c;
                e.CRMDID__c=e.Device__r.CRMDID__c;
                e.Fab__c=e.Device__r.fab__c;
                e.Integration_Status__c='ReadytoSend';
            }
            update erpDevToUpdate;
        }catch(Exception e){
                GlobalUtility.logMessage('Error','Device_TriggerHelper','updateERPDevices','','Exception while running method',String.valueof(e.getMessage()),'','DEV',e,0);
            }
    }
    //************************************************END
    //************************************************
	
	public void updateECCNColorInternalDev(){
        List<String> devECCNTechList = new List<String>();
        List<psa_psc_eccn_default__c> eccnColorList = new List<psa_psc_eccn_default__c>();
        Map<Id,String> devIdEccnTechMap = new Map<Id,String>();
        
        for(Device__c dev:(List<Device__c>)trigger.new){
            if(DeviceTriggerHandler.isInternalDevice(dev.recordTypeId) && triggerOldMap.get(dev.Id).ECCN_Technology__c != dev.ECCN_Technology__c){
                devECCNTechList.add(dev.ECCN_Technology__c);
                devIdEccnTechMap.put(dev.id, dev.ECCN_Technology__c);
            }
        }
        
        if(!devECCNTechList.isEmpty()){
            eccnColorList = [SELECT name, ECCN_Color__c, D1_National_Access_Allowed__c from psa_psc_eccn_default__c WHERE Name IN : devECCNTechList];
        }
        
        if(!eccnColorList.isEmpty() && !devIdEccnTechMap.isEmpty()){
            for(Device__c dev:(List<Device__c>)trigger.new){
                for(psa_psc_eccn_default__c eccnColor : eccnColorList){
                    if(devIdEccnTechMap.get(dev.id) == eccnColor.name){
                        dev.ECCN_Color__c = eccnColor.ECCN_Color__c;
                        dev.D1_National_Access_Allowed__c = eccnColor.D1_National_Access_Allowed__c;
                    }
                }
            }
        }
    }
    
}