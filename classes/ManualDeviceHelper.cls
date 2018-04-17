/*
    Author:         Bhupesh Mukhija
    Company:        Cognizant Technology Solution
    Description:    This class is a Helper class for CE Weekly Report on Device and Manual Device
                    Objects. This class implement following:
                        o Mapping Data from Device to Manual Device Object and vice versa.
                          From Manual Device and Device only two (Project_Update__c, Publish_Report__c)
                              fields mapped as per Business Requirements
                        o Update Manual Device records with Updated Device Data
    
    History:
    BMukhija     28052013     -     Class Creation
    BMohan       29052013     -     btnClickEmailPdf and btnClickEmailPdf method Creation
    SMulugu      30052013     -     getUpdateManualDeviceData Method Creation.
    BMukhija     26062013     -     sortList, manualDeviceAccountValidation, inactivateManualDevice, 
                                    retrofitDeviceCheck, createDocument Method creation.
    ASinghal     16082013     -     RawbtnClickPublishToTeamRoom to store CEWeeklyReport Data with/without Export Flag
    Asinghal     19082013     -     changed naming Format for CE Files Raw Documents as per Business requirement in RawbtnClickPublishToTeamRoom method         
    NJain        02092013     -     changed the logic for calculating the Week number in btnClickPublishToTeamRoom and RawbtnClickPublishToTeamRoom methods
    Yash         03092013     -     Update method getUpdatedDeviceData().
    */
    public class ManualDeviceHelper {

        public static Boolean flagHelper = false;
        public static Boolean flagMDevUpdate = false;
        public static Boolean flagSaveReport = false;        
        
        /***********************************************************
        * Name              : getUpdatedManualDeviceData
        * Description       : Get respective Manual Device data for 
                              CE Reports.
        * Input Parameters  : None
        * Return            : List<Manual_Device__c>
        ************************************************************/
        public static List<Manual_Device__c> getUpdateManualDeviceData () {
        /*    list<Manual_Device__c> manualDeviceList =  new list<Manual_Device__c> ([ Select Yield__c,
                                                                                    Technology__c,
                                                                                    Status__c,
                                                                                    Region__c,
                                                                                    Account_Name__c,
                                                                                    Publish_Report__c,
                                                                                    Proto_Functional_Status__c,
                                                                                    Project_Update__c,
                                                                                    Process_Family__c,
                                                                                    Prime_Die__c,
                                                                                    Device__r.Actual_Tapeout_Date_GMT__c,
                                                                                    IsActive__c,
                                                                                    Geometry__c,
                                                                                    Forecast_GDSII_In__c,
                                                                                    Forecast_1st_3_reticle_Lot_Start__c,
                                                                                    Fab__c,
                                                                                    Export__c,
                                                                                    ET_Met_Target__c,
                                                                                    Device__c,
                                                                                    Device_Id__c,
                                                                                    Attn_To__c,
                                                                                    Account__c
                                                                                    From Manual_Device__c ]);
                                                                                    */
              list<Manual_Device__c> manualDeviceList =  new list<Manual_Device__c> ([ Select Yield__c,
                                                                                    Technology__c,
                                                                                    Status__c,
                                                                                    Region__c,
                                                                                    Account_Name__c,
                                                                                    Publish_Report__c,
                                                                                    Proto_Functional_Status__c,
                                                                                    Project_Update__c,
                                                                                    Process_Family__c,
                                                                                    Prime_Die__c,
                                                                                    Device__r.Actual_Tapeout_Date_GMT__c,
                                                                                    IsActive__c,
                                                                                    Geometry__c,
                                                                                    Forecast_GDSII_In__c,
                                                                                    Forecast_1st_3_reticle_Lot_Start__c,
                                                                                    Fab__c,
                                                                                    Export__c,
                                                                                    ET_Met_Target__c,
                                                                                    Device__c,
                                                                                    Device_Id__c,
                                                                                    Attn_To__c,
                                                                                    Account__c
                                                                                    From Manual_Device__c where IsActive__c =: true]);
                                                                                                                                                        
            return manualDeviceList;
        }

        /***********************************************************
        * Name              : getUpdatedDeviceData
        * Description       : Get respective Device data for all 
                              Manual Devices.
        * Input Parameters  : None
        * Return            : List<Manual_Device__c>
        ************************************************************/
        public static List<Manual_Device__c> getUpdatedDeviceData() {
    
            Set<String> sDeviceIds = new Set<String>();
            List<Device__c> lDevice = new List<Device__c>();
            flagHelper = true;

            List<Manual_Device__c> lRetVal
                =  new List<Manual_Device__c>(
                    [ SELECT Id
                          , Device__c
                          , Device__r.Name
                          , Account_Name__c
                          , Device__r.ET_Met_Target__c
                          , Device__r.Fab__c
                          , Device__r.Stage__c
                          , Device__r.Forecasted_Lot_Start_Date__c
                          , Device__r.Geometry__c
                          , Device__r.Prime_Die__c
                          , Device__r.Current_Forecast_Tapeout_Date__c
                          , Device__r.Process_Family__c
                          , Device__r.Project_Update__c
                          , Device__r.Proto_Functional_Status__c
                          , Device__r.Publish_Report__c
                          , Device__r.Account__r.Region__c
                          , Device__r.Yield__c
                          , Device__r.Opportunity_Program__r.Technology__c
                          , Device__r.Tapeout_Type__c
                          , Device__r.Actual_Tapeout_Date_GMT__c
                          , Device__r.Confidence_Level_Tapeout__c
                          , Device__r.Attn_To__c
                          , Device__r.Opportunity2__r.Account.Region__c
                      FROM Manual_Device__c
                      WHERE Device__c != NULL
                         
                          AND Publish_Report__c !=NULL ]);
                          
            //03/sept/2013 case no 1898 remove isActive__c,Publish_Report__c  from above list (AND IsActive__c = true and Publish_Report__c = :ManualDeviceConstants.PV_YES)
            for (Manual_Device__c eachManualDevice: lRetVal) {
                eachManualDevice.ET_Met_Target__c = eachManualDevice.Device__r.ET_Met_Target__c;
                eachManualDevice.Status__c = getManualDeviceStage(eachManualDevice.Device__r.Stage__c);
                eachManualDevice.Forecast_1st_3_reticle_Lot_Start__c = eachManualDevice.Device__r.Forecasted_Lot_Start_Date__c;
                eachManualDevice.Prime_Die__c = eachManualDevice.Device__r.Prime_Die__c;
                eachManualDevice.Forecast_GDSII_In__c = eachManualDevice.Device__r.Current_Forecast_Tapeout_Date__c;
                eachManualDevice.Process_Family__c = eachManualDevice.Device__r.Process_Family__c;
                eachManualDevice.Project_Update__c = eachManualDevice.Device__r.Project_Update__c;
                eachManualDevice.Proto_Functional_Status__c = eachManualDevice.Device__r.Proto_Functional_Status__c;
                eachManualDevice.Publish_Report__c = eachManualDevice.Device__r.Publish_Report__c;
                eachManualDevice.Yield__c = eachManualDevice.Device__r.Yield__c;
                eachManualDevice.Tapeout_Type__c = eachManualDevice.Device__r.Tapeout_Type__c;
                eachManualDevice.Confidence_Level_Tapeout__c = eachManualDevice.Device__r.Confidence_Level_Tapeout__c;
                eachManualDevice.Fab__c = eachManualDevice.Device__r.Fab__c;
                eachManualDevice.Region__c = eachManualDevice.Device__r.Account__r.Region__c;
                eachManualDevice.Geometry__c = eachManualDevice.Device__r.Geometry__c;
                eachManualDevice.Device_Id__c = eachManualDevice.Device__r.Name;
                eachManualDevice.Attn_To__c = eachManualDevice.Device__r.Attn_To__c;
                eachManualDevice.Technology__c = eachManualDevice.Device__r.Opportunity_Program__r.Technology__c;
                
                sDeviceIds.add(eachManualDevice.Device__c);
            }
            //if (sDeviceIds != null && sDeviceIds.size() > 0) {
                lDevice = [SELECT Id
                                , Name
                                , Account__c
                                , ET_Met_Target__c
                                , Fab__c
                                , Stage__c
                                , Forecasted_Lot_Start_Date__c
                                , Geometry__c
                                , Prime_Die__c
                                , Current_Forecast_Tapeout_Date__c
                                , Process_Family__c
                                , Project_Update__c
                                , Proto_Functional_Status__c
                                , Publish_Report__c
                                , Account__r.Region__c
                                , Yield__c
                                , Opportunity_Program__r.Technology__c
                                , Actual_Tapeout_Date_GMT__c
                                , Account__r.Name
                                , Attn_To__c
                                , Opportunity2__r.Account.Region__c
                           FROM Device__c
                           WHERE (Id NOT IN :sDeviceIds
                            AND Status__c = 'Active'
                            AND Publish_Report__c = :ManualDeviceConstants.PV_YES) ];
            //}
            lRetVal.addAll(convertManualDeviceFrmDevice(lDevice, true));
            return lRetVal;
        }
    
    /***********************************************************
    * Name              : convertManualDeviceFrmDevice
    * Description       : Device to manual Device Mapper
    * Input Parameters  : List<Device__c>
    * Return            : List<Manual_Device__c>
    ************************************************************/
    public static List<Manual_Device__c> convertManualDeviceFrmDevice(List<Device__c> lDevice, Boolean isInsert) {
        List<Manual_Device__c> retVal = new List<Manual_Device__c>();
        Manual_Device__c manualDevice;

        if (lDevice != null && lDevice.size() > 0) {
            for (Device__c eachDevice: lDevice) {
                    
                if (eachDevice != null) {
                        manualDevice = new Manual_Device__c();
                        manualDevice.Account__c = eachDevice.account__c;
                        manualDevice.ET_Met_Target__c = eachDevice.ET_Met_Target__c;
                        manualDevice.Forecast_1st_3_reticle_Lot_Start__c = eachDevice.Forecasted_Lot_Start_Date__c;
                        manualDevice.Forecast_GDSII_In__c = eachDevice.Current_Forecast_Tapeout_Date__c;
                        manualDevice.Prime_Die__c = eachDevice.Prime_Die__c;
                        manualDevice.Process_Family__c = eachDevice.Process_Family__c;
                        manualDevice.Project_Update__c = eachDevice.Project_Update__c;
                        manualDevice.Proto_Functional_Status__c = eachDevice.Proto_Functional_Status__c;
                        manualDevice.Publish_Report__c = eachDevice.Publish_Report__c;
                        manualDevice.Yield__c = eachDevice.Yield__c;
                        manualDevice.Device__c = eachDevice.Id;
                        manualDevice.Device_Id__c = eachDevice.Name;
                        manualDevice.Fab__c = eachDevice.Fab__c;
                        manualDevice.Technology__c = eachDevice.Opportunity_Program__r.Technology__c;
                        manualDevice.Geometry__c = eachDevice.Geometry__c;
                        manualDevice.Region__c = eachDevice.Account__r.Region__c;
                        
                        if ( eachDevice.Publish_Report__c == ManualDeviceConstants.PV_YES ) {
                            manualDevice.isActive__c = true;
                        }
                        else if ( eachDevice.Publish_Report__c == ManualDeviceConstants.PV_NO ) {
                            manualDevice.IsActive__c = false;
                        }
                    manualDevice.Status__c = getManualDeviceStage(eachDevice.Stage__c);
                    /* THE CODE HAS BEEN ADDED TO CHECK IF THE EXPORT IS TRUE */
                    if ( manualDevice.Status__c == ManualDeviceConstants.DEVICE_STAGE_TAPEOUT ) {
                        manualDevice.Export__c = true;
                    }
                    if (isInsert) {
                        manualDevice.Account_Name__c = eachDevice.Account__r.Name;
                    }
                }
                retVal.add(manualDevice);
            }
        }
    return retVal;
    }
        

    /***********************************************************
    * Name              : getManualDeviceStage
    * Description       : 
    * Input Parameters  : String
    * Return            : String
    ************************************************************/
    public static String getManualDeviceStage(String deviceStage) {
        String retVal;

        if (deviceStage != null) {
            if (deviceStage == ManualDeviceConstants.DEVICE_STAGE_SOLUTIONING 
                || deviceStage == ManualDeviceConstants.DEVICE_STAGE_DESIGN_IN
                || deviceStage == ManualDeviceConstants.DEVICE_STAGE_TAPEOUT) {
                retVal = ManualDeviceConstants.MDEVICE_TAPEOUT;
            } else if (deviceStage == ManualDeviceConstants.DEVICE_STAGE_PROTOTYPE
                    || deviceStage == ManualDeviceConstants.DEVICE_STAGE_RTR) {
                retVal = ManualDeviceConstants.MDEVICE_PROTO_RISK_PROD;
            } else if (deviceStage == ManualDeviceConstants.DEVICE_STAGE_PRODUCTION) {
                retVal = ManualDeviceConstants.MDEVICE_PRODUCTION;
            }
        }
            
        return retVal;
    }

    /* Manual Device to Device mapper for Project Update and Publish Report Fields.*/ 
    public static List<Device__c> convertDeviceFrmManualDevice(List<Manual_Device__c> lManualDevice) {
        List<Device__c> retVal = new List<Device__c>();
        Map<Id, Manual_Device__c> mManualDevice = new Map<Id, Manual_Device__c>();

        for (Manual_Device__c eachManualDevice: lManualDevice) {
            if ( eachManualDevice.Device__c != null || eachManualDevice.Device__c != '' ) {
                mManualDevice.put(eachManualDevice.Device__c, eachManualDevice);
            }
        }
        
        for (Device__c eachDevice : [ SELECT Id
                                            , Name
                                            , Confidence_Level_Tapeout__c
                                            , Account__c
                                            , Device_Id__c
                                            , Project_Update__c
                                            , Publish_Report__c
                                            , Current_Forecast_Tapeout_Date__c
                                            , Actual_Tapeout_Date_GMT__c
                                            , Tapeout_Type__c
                                            , Attn_To__c
                                            , Opportunity2__r.Account.Region__c
                                        FROM Device__c 
                                        WHERE Id IN :mManualDevice.keyset() ]) {
            eachDevice.Project_Update__c    = mManualDevice.get(eachDevice.id).Project_Update__c;
            //eachDevice.Publish_Report__c    = mManualDevice.get(eachDevice.id).Publish_Report__c;
            eachDevice.Attn_To__c    = mManualDevice.get(eachDevice.id).Attn_To__c;
            retval.add(eachDevice);
        }
            
        return retVal;
    }
        
   /***********************************************************
    * Name              : manualDeviceCheckedToExport
    * Description       : fetch the data from manual device into a list
    * Input Parameters  : none 
    * Return            : List<PageReference>
    ************************************************************/
    public static List<Manual_Device__c> manualDeviceCheckedToExport() {
        List<Manual_Device__c> manualDeviceList = [ SELECT m.Yield__c
                                                         , m.Technology__c
                                                         , m.SystemModstamp
                                                         , m.Status__c
                                                         , m.Region__c
                                                         , m.Publish_Report__c
                                                         , m.Proto_Functional_Status__c
                                                         , m.Project_Update__c
                                                         , m.Process_Family__c
                                                         , m.Prime_Die__c
                                                         , m.OwnerId
                                                         , m.Name
                                                         , m.IsActive__c
                                                         , m.Id
                                                         , m.Device__r.Actual_Tapeout_Date_GMT__c
                                                         , m.Geometry__c
                                                         , m.Forecast_GDSII_In__c
                                                         , m.Forecast_1st_3_reticle_Lot_Start__c
                                                         , m.Fab__c
                                                         , m.Export__c
                                                         , m.ET_Met_Target__c
                                                         , m.Device__c
                                                         , m.Device_Id__c
                                                         , m.Attn_To__c
                                                         , m.Account__c
                                                         , m.Account_Name__c FROM Manual_Device__c m
                                                     WHERE Publish_Report__c = :ManualDeviceConstants.PV_YES 
                                                        AND IsActive__c = true 
                                                        AND Export__c = true ];
        
        if(manualDeviceList != null && manualDeviceList.size()>0) {
            return manualDeviceList;             
        } else {        
            return null;
        }
    }
        
     /***********************************************************
    * Name              : btnClickPublishToTeamRoom
    * Description       : On button click attach the page content as pdf in the Team Roo
    * Input Parameters  : List<PageReference> 
    * Return            : none
    ************************************************************/
    public static Boolean btnClickPublishToTeamRoom(Map<PageReference,String> tabPageNamesMap){
    
        Set<PageReference> tabPageNames = new Set<PageReference>();
        Team_Room_Meeting_Minutes__c tRoomMeetMins = new Team_Room_Meeting_Minutes__c();
        
        tabPageNames = tabPageNamesMap.KeySet();
        System.debug('------->plain'+'----->'+tabPageNames );
        Team_Room__c insTeamRoom;
        Folder folder;
        try {
             insTeamRoom = [ SELECT Id FROM Team_Room__c WHERE Name = :Label.CEWeekly_Team_Room LIMIT 1 ];
             folder = [SELECT Id FROM Folder WHERE DeveloperName = :ManualDeviceConstants.MDEVICE_REPORT_FOLDER LIMIT 1];
        } catch (Exception ex) {
             insTeamRoom=null;
             System.debug('Exception on fetching record from TeamRoom :'+ex.getMessage());      
        }
        
        integer numberOfWeek;
        Double numberOfWeekDouble ;
        Date todaydate = date.today();
        Integer currentyear = todaydate.year();
        Date todaydateinstance = date.newinstance(1900, 1, 7);
        Date startDate = date.newinstance(currentyear, 1, 1);
        Integer numberDaysDue = todaydateinstance.daysBetween(startDate);
        Integer modDiff = Math.MOD(numberDaysDue,7);

        if(modDiff == 0){
            numberOfWeekDouble = math.ceil((startDate.daysBetween(todaydate)+3)/7.0);
        }else if(modDiff == 1){
            numberOfWeekDouble = math.ceil((startDate.daysBetween(todaydate)+4)/7.0);
        }else if(modDiff == 2){
            numberOfWeekDouble = math.ceil((startDate.daysBetween(todaydate)+5)/7.0);
        }else if(modDiff == 3){
            numberOfWeekDouble = math.ceil((startDate.daysBetween(todaydate)+6)/7.0);
        }else if(modDiff == 4){
            numberOfWeekDouble = math.ceil((startDate.daysBetween(todaydate)+7)/7.0);
        }else if(modDiff == 5){
            numberOfWeekDouble = math.ceil((startDate.daysBetween(todaydate)+1)/7.0);
        }else if(modDiff == 6){
            numberOfWeekDouble = math.ceil((startDate.daysBetween(todaydate)+2)/7.0);
        }else{
            numberOfWeekDouble =99;
        }
        numberOfWeek = numberOfWeekDouble.intValue();
        /*
          Date todaydate = date.today(); 
          Date todaydateinstance = date.newinstance(todaydate.year(), todaydate.month(), todaydate.day());      
          Integer currentyear = todaydate.year(); 
          Date startDate = date.newinstance(currentyear, 01, 01);     
          integer numberDaysDue = startDate.daysBetween(todaydateinstance);    
          Integer numberOfWeek = Math.MOD(Integer.valueOf(math.FLOOR((numberDaysDue +1)/7)),52)+1;
        */
        List<attachment> attachList = new List<attachment>();
        List<Document> lDocument = new List<Document>();
        Document document;
        Blob body;
        
        Date weekStartDate = todaydate.toStartofWeek();

        List<Team_Room_Meeting_Minutes__c> lTRoomMeetMins = [SELECT Id
                                                             FROM Team_Room_Meeting_Minutes__c
                                                             WHERE Team_Room__c = :insTeamRoom.Id
                                                                AND Meeting_Date__c >= :weekStartDate
                                                                AND Meeting_Date__c < :weekStartDate.addDays(6)];

        // Prepare Meeting Minutes for Team Room
        if (lTRoomMeetMins != null && lTRoomMeetMins.size() > 0) {
            return false;
        } else {
            if (insTeamRoom != null && insTeamRoom.Id != null) {
                tRoomMeetMins.Team_Room__c = insTeamRoom.Id;
                tRoomMeetMins.Status__c = 'Open';
                tRoomMeetMins.Meeting_Type__c = 'Weekly';
                tRoomMeetMins.Meeting_Date__c = todaydate;
               // tRoomMeetMins.Name='CE-Weekly-'+currentyear+'-'+currentmonth+'-'+currentday+'-WW'+numberOfWeek;
                
                insert tRoomMeetMins;
            }

            try {
            System.debug('---->inside try'+tabPageNames);
                for(PageReference tabPageName : tabPageNames) {
    
                    if ( String.ValueOf(tabPageName).contains('tapeout') ) {
                        attachment attach = new attachment();
                        body = (Blob)(tabPageName.getContent());
                        attach.Name = tabPageNamesMap.get(tabPageName)+'CE Weekly Report Week:'+numberOfWeek+'.xls';
                        attach.body = body;
                        attach.IsPrivate = false;
                        if(tRoomMeetMins != null && tRoomMeetMins.Id != null) {
                            attach.ParentId = tRoomMeetMins.Id;
                        }
                        
                        document = createDocument(folder.Id, body);
                        document.Name = tabPageNamesMap.get(tabPageName)+'CE Weekly Report Week:' + numberOfWeek + '.xls';
                        lDocument.add(document);
                        attachList.add(attach);
                    } else {
                        attachment attach = new attachment();
                        body = tabPageName.getContentAsPDF();
                        attach.Body = body;         
                        attach.Name = tabPageNamesMap.get(tabPageName )+'CE Weekly Report Week:' + numberOfWeek + '.pdf' ;
                        attach.IsPrivate = false;

                        if(tRoomMeetMins != null && tRoomMeetMins.Id != null) {
                            attach.ParentId = tRoomMeetMins.Id;
                        }
                        document = createDocument(folder.Id, body);
                        document.Name = tabPageNamesMap.get(tabPageName)+'CE Weekly Report Week:' + numberOfWeek + '.pdf';
                        lDocument.add(document);
                        attachList.add(attach);
                    }
                }
            }
            catch (VisualforceException e) {
                body = Blob.valueOf('Missing Text');
            }
    
            try {
                insert attachList;
                insert lDocument;
            }
            catch(DMLException e) {
                System.debug('Exception encountered in inserting Attchment is ' + e.getMessage());
            }
            
            return true;
        }
    }
    
    
    /***********************************************************
    * Name              : RawbtnClickPublishToTeamRoom
    * Description       : On button click insert the raw data files in Document folder RAW CE Files
    * Input Parameters  : List<PageReference> 
    * Return            : none
    ************************************************************/
    public static void RawbtnClickPublishToTeamRoom(Map<PageReference,String> tabPageNamesMap){
        Set<PageReference> tabPageNames = new Set<PageReference>();
        
        tabPageNames = tabPageNamesMap.KeySet();
        System.debug('-------->'+tabPageNames );
        Folder folder;
        try {
             folder = [SELECT Id FROM Folder WHERE DeveloperName = 'RAW_CE_Files'];
        } catch (Exception ex) {
             folder=null;
             System.debug('Exception on fetching Document folder:'+ex.getMessage());      
        }
        /*
        Date todaydate = date.today();
        Date todaydateinstance = date.newinstance(todaydate.year(), todaydate.month(), todaydate.day());
        Integer currentyear = todaydate.year();
        Integer currentmonth = todaydate.month();
        Integer currentday = todaydate.day();
        Date startDate = date.newinstance(currentyear, 01, 01);
        integer numberDaysDue = startDate.daysBetween(todaydateinstance);
        Integer numberOfWeek = Math.MOD(Integer.valueOf(math.FLOOR((numberDaysDue +1)/7)),52)+1;
        */
        
        
        integer numberOfWeek;
        Double numberOfWeekDouble ;
        Date todaydate = date.today();
        Integer currentyear = todaydate.year();
        Date todaydateinstance = date.newinstance(1900, 1, 7);
        Date startDate = date.newinstance(currentyear, 1, 1);
        Integer numberDaysDue = todaydateinstance.daysBetween(startDate);
        Integer modDiff = Math.MOD(numberDaysDue,7);

        if(modDiff == 0){
            numberOfWeekDouble = math.ceil((startDate.daysBetween(todaydate)+3)/7.0);
        }else if(modDiff == 1){
            numberOfWeekDouble = math.ceil((startDate.daysBetween(todaydate)+4)/7.0);
        }else if(modDiff == 2){
            numberOfWeekDouble = math.ceil((startDate.daysBetween(todaydate)+5)/7.0);
        }else if(modDiff == 3){
            numberOfWeekDouble = math.ceil((startDate.daysBetween(todaydate)+6)/7.0);
        }else if(modDiff == 4){
            numberOfWeekDouble = math.ceil((startDate.daysBetween(todaydate)+7)/7.0);
        }else if(modDiff == 5){
            numberOfWeekDouble = math.ceil((startDate.daysBetween(todaydate)+1)/7.0);
        }else if(modDiff == 6){
            numberOfWeekDouble = math.ceil((startDate.daysBetween(todaydate)+2)/7.0);
        }else{
            numberOfWeekDouble =99;
        }
        numberOfWeek = numberOfWeekDouble.intValue();
        system.debug('#######Week Number########'+numberOfWeek);
        
        
        List<Document> lDocument = new List<Document>();
        Document document;
        Blob body;
        
        Date weekStartDate = todaydate.toStartofWeek();
        List<Document> Rawdocuments= new List<Document>();
        //List<String> names=new List<String>();
        Set<String> Documentnames=new Set<String>(); 
        RawDocuments=[Select Id,name from Document where folderid=:folder.id];
        for(Document d: Rawdocuments)
        Documentnames.add(d.name);
       
        
               
            try {
                for(PageReference tabPageName : tabPageNames) {
    System.debug('----->inves'+tabPageName+'======'+String.ValueOf(tabPageName));
                    if ( String.ValueOf(tabPageName).contains('tapeoutraw') ) {
                        System.debug('----------->inside tapeoutraw');
                        body = (Blob)(tabPageName.getContent());
                                                                     
                        document = createDocument(folder.Id, body);
                        document.Name =currentyear+'-'+numberofweek+'-'+tabPageNamesMap.get(tabPageName)+'CE Weekly Report Week:' + numberOfWeek + '.xls';
                        if(!Documentnames.contains(document.name))
                        lDocument.add(document);
                        
                    } else {
                        
                        body = tabPageName.getContentAsPDF();
                                               
                        document = createDocument(folder.Id, body);
                        document.Name =currentyear+'-'+numberofweek+'-'+tabPageNamesMap.get(tabPageName)+'CE Weekly Report Week:' + numberOfWeek + '.pdf';
                        if(!Documentnames.contains(document.name))
                        lDocument.add(document);
                        
                    }
                }
            }
            catch (VisualforceException e) {
                body = Blob.valueOf('Missing Text');
            }
    
            try {
                insert lDocument;
            }
            catch(DMLException e) {
                System.debug('Exception encountered in inserting Document is ' + e.getMessage());
            }
            
            
        }
    
    
    public static Document createDocument(Id folderId, Blob body) {
        Document document = new Document();
        
        document.body = body;
        document.contentType = 'application/vnd.msexcel';
        if (folderId != null) {
            document.folderId = folderId;
        }
        
        return document;
    }

    public static void retrofitDeviceCheck1 (List<Device__c> lDevice) {
        Date currentDate = Date.today();
        
        for (Device__c device :lDevice) {
        if (device.Stage__c == ManualDeviceConstants.DEVICE_STAGE_SOLUTIONING
            || device.Stage__c == ManualDeviceConstants.DEVICE_STAGE_DESIGN_IN
            || device.Stage__c == ManualDeviceConstants.DEVICE_STAGE_TAPEOUT) {
            if (device.Tapeout_Type__c == ManualDeviceConstants.MDEVICE_RETROFIT) {
                device.Publish_Report__c = ManualDeviceConstants.PV_No;
            } else {
                if (device.Confidence_Level_Tapeout__c != null
                    && Integer.valueOf(device.Confidence_Level_Tapeout__c) >= 50
                    && device.Current_Forecast_Tapeout_Date__c < currentDate.addMonths(9)
                    && device.Current_Forecast_Tapeout_Date__c > currentDate.addMonths(-3)) {
                    device.Publish_Report__c = ManualDeviceConstants.PV_YES;
                } else {
                    device.Publish_Report__c = ManualDeviceConstants.PV_NO;
                }
            }
        }
        }
    }

    
    public static void inactivateManualDevice(List<Device__c> lDevice) {
        // DEVICE ID SET FOR MANUAL DEVICE
        Set<String> sDeviceId = new Set<String>();
        ManualDeviceHelper.flagMDevUpdate = true;
        
        for (Device__c eachDevice :lDevice) {
            sDeviceId.add(eachDevice.Name.toUpperCase());
        }
        List<Manual_Device__c> lManualDevice = [ SELECT Id
                                                 FROM Manual_Device__c
                                                 WHERE Device_Id__c IN :sDeviceId ];

        if (!lManualDevice.isEmpty()) {
            // INACTIVATE ALL MANUAL DEVICES FOR THIS EXISTING DEVICE
            for (Manual_Device__c eachManualDevice :lManualDevice) {
                eachManualDevice.IsActive__c = false;
                eachManualDevice.Publish_Report__c = 'No';
            }

            Database.saveResult[] dSaveResult = Database.update(lManualDevice);
        }
    }

    public static void manualDeviceAccountValidation(List<Manual_Device__c> lManualDevice, Set<String> sAccountName) {
    
        for (Manual_Device__c manualDevice :lManualDevice) {
            if (!manualDevice.Account_Name__c.equalsIgnoreCase(ManualDeviceConstants.MDEVICE_ID_MULTIPLE)
                && !sAccountName.contains(manualDevice.Account_Name__c.toUpperCase())) {
                manualDevice.Account_Name__c.addError(ManualDeviceConstants.MDEVICE_INVALID_ACCOUNT_ERROR);                
            }
        }
    }    
    
    public static void sortList(List<Sobject> lSortItems, String sortField, String order) {
        
        List<Sobject> lResult = new List<Sobject>();
   
        // CREATE A MAP THAT CAN BE USED FOR SORTING
        Map<object, List<Sobject>> mObject = new Map<object, List<Sobject>>();
        
        for (Sobject sObjectTemp : lSortItems) {
            
            if (mObject.get(sObjectTemp.get(sortField)) == null) {
                mObject.put(sObjectTemp.get(sortField), new List<Sobject>()); 
            }
            
            mObject.get(sObjectTemp.get(sortField)).add(sObjectTemp);
        }       
        // SORT KEYS
        List<object> keys = new List<object>(mObject.keySet());
        keys.sort();
       
        for (object key : keys){ 
            lResult.addAll(mObject.get(key)); 
        }
       
        // APPLY SORTED VALUES AS PER ORDER
        lSortItems.clear();
        if (order.toLowerCase() == 'asc') {
            for (Sobject ob : lResult){
                lSortItems.add(ob); 
            }
        } else if (order.toLowerCase() == 'desc') {
            for (integer i = lResult.size()-1; i >= 0; i--) {
                lSortItems.add(lResult[i]);  
            }
        }
    }
}