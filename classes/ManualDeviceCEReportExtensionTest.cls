/*
    Author: 
    Description: 
    History:
        Nbustillos  10122013    - Added call to loadEnvironmentVariables() method.
        Nbustillos  10172013    - Added new method called runMDMContent() and remove code logic
                                  related to ManualDeviceContentController Apex Controller.
*/

@isTest
private class ManualDeviceCEReportExtensionTest {

   /* static testMethod void CEWeeklyReport() {
        
        // Load Environment Variables   
        DataUtilTest.loadEnvironmentVariables();
        
        // Create a User Record in Test various functionalities of the application
        Profile p = [SELECT Id FROM Profile WHERE Name=:'System Administrator' limit 1]; 

        User u = new User(Alias = 'alias', Email='testUser@testorg.com', 
        EmailEncodingKey='UTF-8', LastName='TestUser', LanguageLocaleKey='en_US', 
        LocaleSidKey='en_US', ProfileId = p.Id, HCM_Login_ID__c = 'RC3591',
        TimeZoneSidKey='America/Los_Angeles', UserName='alias'+'@testorg.com');


        system.runAs( u ) {

            ManualDeviceTest.setUpCustomSetting();

            Account account1 = ManualDeviceTest.createAccount('Account 1');

            Opportunity opportunity1 = ManualDeviceTest.createOpportunity(account1.Id, 'Opportunity 1');

            Opportunity_Program__c  oppProg1 = ManualDeviceTest.createOpportunityProgram(
                account1.Id, opportunity1.Id, 'Opp Prog 1');
             
            List<Device__c> lDevice =  new List<Device__c>();
            List<Device__c> newDevice =  new List<Device__c>();
            Device__c device1 = DeviceUtilTest.createCMPWDevice(account1.Id,oppProg1.Id);
               // account1.Id, opportunity1.Id, oppProg1.Id, 'Device.SUSHUTEST1A', ManualDeviceConstants.DEVICE_STAGE_PRODUCTION, ManualDeviceConstants.PV_YES);
            lDevice.add(device1);
            newDevice.add(device1);
            test.starttest();
             Insert device1;           
           // Device__c device2 = DeviceUtilTest.createCustomerMPWDevice5(account1.Id,oppProg1.Id);
            //ManualDeviceTest.createDevice2(
             //   account1.Id, opportunity1.Id, oppProg1.Id, 'Device.SUSHUTEST2A', ManualDeviceConstants.DEVICE_STAGE_PROTOTYPE, ManualDeviceConstants.PV_YES);
           // lDevice.add(device2);
           // newDevice.add(device2);                        
           //  Insert device2;    
           // Device__c device3 = DeviceUtilTest.createCustomerMPWDevice4(account1.Id,oppProg1.Id);
            //ManualDeviceTest.createDevice2(
              //  account1.Id, opportunity1.Id, oppProg1.Id, 'Device.SUSHUTEST3A',ManualDeviceConstants.DEVICE_STAGE_SOLUTIONING, ManualDeviceConstants.PV_YES);
           // newDevice.add(device3);
            
           // insert newDevice;                            

            system.debug('uuuuuuuuuuuuuu'+device1);
           // system.debug('uuuuuuuuuuuuuu'+device2);
           // system.debug('uuuuuuuuuuuuuu'+device3);
           // device3.Stage__c = ManualDeviceConstants.DEVICE_STAGE_DESIGN_IN;
           // update(device3);
            
           
           // device3.Current_Forecast_Tapeout_Date__c = system.today();
           // update(device3);
           // lDevice.add(device3);
    
            ApexPages.StandardController controller =  new ApexPages.StandardController(lDevice[0]);
            ManualDeviceCEReportExtension maDevice = new ManualDeviceCEReportExtension(controller);

            //ApexPages.StandardController controller1 =  new ApexPages.StandardController(lDevice[1]);
            //ManualDeviceCEReportExtension maDeviceNegative = new ManualDeviceCEReportExtension(controller1);
    
            maDevice.updateManualDevice();

            // Create fourth Device 
            List<Device__c> newDevice2 = new List<Device__c>(); 
            Device__c device4 = DeviceUtilTest.createSPDevice(account1.id,oppProg1.id);
            //ManualDeviceTest.createDevice2(
           // account1.Id, opportunity1.Id, oppProg1.Id, 'Device.SUSHUTEST4A',ManualDeviceConstants.DEVICE_STAGE_SOLUTIONING, ManualDeviceConstants.PV_YES);
            newDevice2.add(device4);
            Device__c device5 = DeviceUtilTest.createSPDevice3(account1.id,oppProg1.id);
            //ManualDeviceTest.createDevice2(
            //account1.Id, opportunity1.Id, oppProg1.Id, 'Device.SUSHUTEST5A',ManualDeviceConstants.DEVICE_STAGE_SOLUTIONING, ManualDeviceConstants.PV_NO);
            newDevice2.add(device5);
            
            //insert newDevice2;
                                   
            Manual_Device__c x = ManualDeviceTest.createManualDeviceFrmDevice(device4);           
            Manual_Device__c y = ManualDeviceTest.createManualDeviceFrmDevice(device5);
            
            List<Device__c> dlist = new List<Device__c> ();
            dList.add(device5);
            ManualDeviceHelper.convertManualDeviceFrmDevice(dList, true);

            ManualDeviceHelper.inactivateManualDevice(lDevice);
            ManualDeviceHelper.getUpdatedDeviceData();
            List<Manual_Device__c> lRetVal = new List<Manual_Device__c>( [ SELECT Id
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
                                                                            , Project_Update__c
                                                                            , Publish_Report__c
                                                                            , Attn_To__c
                                                                            FROM Manual_Device__c]);
                                                                            //WHERE Device__c != NULL
                                                                            //AND IsActive__c = true
                                                                            //AND Publish_Report__c = :ManualDeviceConstants.PV_YES ]);
            SYSTEM.DEBUG('ssssssssssss'+lRetVal);
            manualDeviceHelper.convertDeviceFrmManualDevice(lRetVal);
            maDeviceNegative.updateManualDevice();

            maDeviceNegative.tapeCustomer  = '';
            maDeviceNegative.tapeRegion  = '--None--';
            maDeviceNegative.tapeDevice = '';
            maDeviceNegative.tapeFab = '--None--';
            maDeviceNegative.filterTapeout();

            maDeviceNegative.protoCustomer = '';
            maDeviceNegative.protoRegion = '--None--';
            maDeviceNegative.protoDevice = '';
            maDeviceNegative.protoFab = '--None--';
            maDeviceNegative.filterProto();

            maDeviceNegative.prodCustomer = '';
            maDeviceNegative.prodRegion = '--None--';
            maDeviceNegative.prodDevice = '';
            maDeviceNegative.prodFab = '--None--';
            maDeviceNegative.filterProduction();

            // Filter for multiple Tapeout Tab 

            maDevice.tapeCustomer  = 'Account 1';
            maDevice.tapeRegion  = 'APJ';
            maDevice.tapeDevice = 'Device.SUSHUTEST3';
            maDevice.tapeFab = 'FAB 7';
            maDevice.filterTapeout();

            maDevice.tapeCustomer  = 'Account 2';
            maDevice.tapeRegion  = 'XYZ';
            maDevice.tapeDevice = 'TEST_WRONG';
            maDevice.tapeFab = 'FAB';
            maDevice.filterTapeout();

            maDevice.tapeCustomer  = '';
            maDevice.tapeRegion  = '--None--';
            maDevice.tapeDevice = '';
            maDevice.tapeFab = '--None--';
            maDevice.filterTapeout();

            maDevice.tapeCustomer  = 'Account 1';
            maDevice.tapeRegion  = 'APJ';
            maDevice.tapeDevice = 'Device.SUSHUTEST3';
            maDevice.tapeFab = 'FAB 7';
            maDevice.filterTapeout();

            // Filter for multiple Tapeout Proto 

            maDevice.protoCustomer  = 'Account 1';
            maDevice.protoRegion  = 'APJ';
            maDevice.protoDevice = 'Device.SUSHUTEST2';
            maDevice.protoFab = 'FAB 7';
            maDevice.filterProto();

            maDevice.protoCustomer  = 'Account 2';
            maDevice.protoRegion  = 'XYZ';
            maDevice.protoDevice = 'TEST_WRONG';
            maDevice.protoFab = 'FAB';
            maDevice.filterProto();

            maDevice.protoCustomer  = '';
            maDevice.protoRegion  = '--None--';
            maDevice.protoDevice = '';
            maDevice.protoFab = '--None--';
            maDevice.filterProto();

            maDevice.protoCustomer  = 'Account 1';
            maDevice.protoRegion  = 'APJ';
            maDevice.protoDevice = 'Device.SUSHUTEST2';
            maDevice.protoFab = 'FAB 7';
            maDevice.filterProto();

            // Filter for multiple Tapeout Production 

            maDevice.prodCustomer  = 'Account 1';
            maDevice.prodRegion  = 'APJ';
            maDevice.prodDevice = 'Device.SUSHUTEST1';
            maDevice.prodFab = 'FAB 7';
            maDevice.filterProduction();

            maDevice.prodCustomer  = 'Account 2';
            maDevice.prodRegion  = 'XYZ';
            maDevice.prodDevice = 'TEST_WRONG';
            maDevice.prodFab = 'FAB';
            maDevice.filterProduction();

            maDevice.prodCustomer  = '';
            maDevice.prodRegion  = '--None--';
            maDevice.prodDevice = '';
            maDevice.prodFab = '--None--';
            maDevice.filterProduction();

            maDevice.prodCustomer  = 'Account 1';
            maDevice.prodRegion  = 'APJ';
            maDevice.prodDevice = 'Device.SUSHUTEST1';
            maDevice.prodFab = 'FAB 7';
            maDevice.filterProduction();

            maDevice.returnPage();

            maDevice.save();

            maDevice.clearTapeoutFilters();
            maDevice.clearProtoFilters();
            maDevice.clearProductionFilters();    


            
            List<Manual_Device__c> updateList = new List<Manual_Device__c>();
            for ( Manual_Device__c d : [select id, export__c from manual_Device__c] ) {
                d.Export__c = true;
                updateList.add(d);
            }
            update(updateList);
            }
        test.stoptest();
        }*/
    
    static Id createMaskSetTitle(){
        Map<String,Object> fieldValueMap = new Map<String,Object>();
        fieldValueMap.put('Name','MSTTRT1');
        fieldValueMap.put('Reticle_Type__c','Multi Layer Reticle (MLR)');
        return MaskSetTitleDataFactory.createMaskSetTitle(fieldValueMap).Id;
    }
    
    public static Device__c createCMPWDevice(Id acctId,Id opptyProgramId) {
        String MSTId = CreateMaskSetTitle();
        string MSTAccId = DeviceUtilTest.createMSTAccount(acctId,MSTId);
        // Create Device
        Map<String,Object> fieldValueMap = new Map<String,Object>();
        fieldValueMap.put('Account__c',acctId);
        fieldValueMap.put('Name','TESTDEVICEZAIH12345677');
        fieldValueMap.put('Opportunity_Program__c',opptyProgramId);
        fieldValueMap.put('Fab__c','FAB 2');
        fieldValueMap.put('GSOP_Assignment_Tapeout_Plan__c','No');
        fieldValueMap.put('Market_Segment__c','Automotive');
        fieldValueMap.put('Semiconductor_Device__c','Analog Amplifier');
        fieldValueMap.put('End_Customer__c','Test Customer');
        fieldValueMap.put('Device_Sourcing__c','1st Source');
        fieldValueMap.put('Stage__c','Design In');
        fieldValueMap.put('Status__c','Active');
        fieldValueMap.put('Siebel_Device_ID__c','1234567890');
        fieldValueMap.put('Tapeout_Type__c','Customer MPW');
        fieldValueMap.put('PLM_Device_ID__c','ANBQP60ACO8CH-U01');
        fieldValueMap.put('Device_Mask_Set_Title__c','MSTTRT1');
        fieldValueMap.put('CRMDID__c','CDID0000001.00');
        fieldValueMap.put('Actual_Tapeout_Date__c',date.newInstance(2013,5,20));
        fieldValueMap.put('Original_Forecasted_Tapeout_Date__c',date.newInstance(2013,5,20));
        fieldValueMap.put('Current_Forecast_Tapeout_Date__c',date.newInstance(2013,3,4));
        fieldValueMap.put('Confidence_Level_Tapeout__c','100');
        fieldValueMap.put('Device_Type__c','Base');
        fieldValueMap.put('End_Application__c','Body');
        return DeviceDataFactory.createDevice(fieldValueMap);
    }
    
    static testMethod void runMdmContent(){
        // Load Environment Variables   
        DataUtilTest.loadEnvironmentVariables();
        
        // Create a User Record in Test various functionalities of the application
        Profile p = [SELECT Id FROM Profile WHERE Name=:'System Administrator' limit 1]; 

        User u = new User(Alias = 'alias', Email='testUser@testorg.com', 
        EmailEncodingKey='UTF-8', LastName='TestUser', LanguageLocaleKey='en_US', 
        LocaleSidKey='en_US', ProfileId = p.Id, HCM_Login_ID__c = 'RC3591',
        TimeZoneSidKey='America/Los_Angeles', UserName='alias'+'@testorg.com');


        system.runAs( u ) {
            ManualDeviceTest.setUpCustomSetting();

            Account account1 = ManualDeviceTest.createAccount('Account 1');

            Opportunity opportunity1 = ManualDeviceTest.createOpportunity(account1.Id, 'Opportunity 1');

            Opportunity_Program__c  oppProg1 = ManualDeviceTest.createOpportunityProgram(
                account1.Id, opportunity1.Id, 'Opp Prog 1');
            
            List<Device__c> lDevice =  new List<Device__c>();
            Test.startTest();
            Device__c device1 = createCMPWDevice(account1.Id, oppProg1.Id);
                //account1.Id, opportunity1.Id, oppProg1.Id, 'Device.SUSHUTEST1A', ManualDeviceConstants.DEVICE_STAGE_PRODUCTION, ManualDeviceConstants.PV_YES);
           
            
            //Insert device1;
           
            ApexPages.StandardController controller =  new ApexPages.StandardController(device1);
            ManualDeviceContentController mdContent = new ManualDeviceContentController(controller);
            mdContent.manualDeviceTapeoutToExcel();
            mdContent.manualDeviceProdToPdf();
            mdContent.manualDeviceProtoToPdf();

            mdContent.location  = null;
            mdContent.manualDeviceTapeoutToExcel();
            mdContent.manualDeviceProdToPdf();
            mdContent.manualDeviceProtoToPdf();

            mdContent.location  = 'crap';
            mdContent.manualDeviceTapeoutToExcel();
            mdContent.manualDeviceProdToPdf();
            mdContent.manualDeviceProtoToPdf();
            
            Test.stopTest();
        }
    }    
        
    static testMethod void testrawdevices(){
            
        // Load Environment Variables   
        DataUtilTest.loadEnvironmentVariables();
            
        // Create a User Record in Test various functionalities of the application
        Profile p = [SELECT Id FROM Profile WHERE Name=:'System Administrator' limit 1]; 

        User u = new User(Alias = 'alias', Email='testUser@testorg.com', 
        EmailEncodingKey='UTF-8', LastName='TestUser', LanguageLocaleKey='en_US', 
        LocaleSidKey='en_US', ProfileId = p.Id, HCM_Login_ID__c = 'RC3591',
        TimeZoneSidKey='America/Los_Angeles', UserName='alias'+'@testorg.com');


        system.runAs( u ) {
            
            ManualDeviceTest.setUpCustomSetting();
            Account account1 = ManualDeviceTest.createAccount('Account 1');
            Opportunity opportunity1 = ManualDeviceTest.createOpportunity(account1.Id, 'Opportunity 1');
            Opportunity_Program__c  oppProg1 = ManualDeviceTest.createOpportunityProgram(account1.Id, opportunity1.Id, 'Opp Prog 1');
            test.starttest();
            List<Device__c> lDevice =  new List<Device__c>();
            Device__c device1 = createCMPWDevice(account1.Id, oppProg1.Id);
            //ManualDeviceTest.createDevice(account1.Id, opportunity1.Id, oppProg1.Id, 'Device.SUSHUTEST1A', ManualDeviceConstants.DEVICE_STAGE_PRODUCTION, ManualDeviceConstants.PV_YES);
            lDevice.add(device1);
            
            
            //Insert device1;
            ManualDeviceTest.setUpCustomSetting();
            ApexPages.StandardController controller =  new ApexPages.StandardController(lDevice[0]);
            ManualDeviceCEReportExtension maDevice = new ManualDeviceCEReportExtension(controller);
            PageReference pageref1 = new PageReference('apex/ProductionTabDetail');
            PageReference pageref2 = new PageReference('apex/ProtoRiskProductionTabDetail');
            Map<PageReference,String> pagerefMap = new Map<PageReference,String>();
            pagerefMap.put(pageref1,'ProductionTabDetail');
            pagerefMap.put(pageref2,'ProtoRiskProductionTabDetail');
            Team_Room__c tRoom = new Team_Room__c();
            tRoom.Name = Label.CEWeekly_Team_Room;
            tRoom.Team_Room_Description__c = 'Test';
            tRoom.Primary_Account__c=account1.Id;
            insert tRoom;

            ManualDeviceHelper.btnClickPublishToTeamRoom(pagerefMap);
            maDevice.btnClickPublishToTeamRoom();         
        test.stoptest();
        }
    }

    static testMethod void btnClickPublishToTeamRoom() {
        
        // Load Environment Variables   
        DataUtilTest.loadEnvironmentVariables();
        
        Test.startTest();
        ManualDeviceTest.setUpCustomSetting();
        ManualDeviceCEReportExtension maDevice = new ManualDeviceCEReportExtension();  
        Account account1 = ManualDeviceTest.createAccount('Account 7');
        PageReference pageref1 = new PageReference('apex/ProductionTabDetail');
        PageReference pageref2 = new PageReference('apex/ProtoRiskProductionTabDetail');
        Map<PageReference,String> pagerefMap = new Map<PageReference,String>();
        pagerefMap.put(pageref1,'ProductionTabDetail');
        pagerefMap.put(pageref2,'ProtoRiskProductionTabDetail');

        Team_Room__c tRoom = new Team_Room__c();
        tRoom.Name = Label.CEWeekly_Team_Room;
        tRoom.Team_Room_Description__c = 'Test';
        tRoom.Primary_Account__c=account1.Id;
        insert tRoom;

        pageReference pageref = maDevice.btnClickPublishToTeamRoom();
        ManualDeviceHelper.btnClickPublishToTeamRoom(pagerefMap);
        String url = maDevice.backPage().getUrl();
        System.assert(url.contains('/home/home.jsp'), true);
        Test.stopTest();
    }
    
    static testMethod void publishToTeamRoomError() {
        
        // Load Environment Variables   
        DataUtilTest.loadEnvironmentVariables();
        
        Test.startTest();
        PageReference pageref1 = new PageReference('apex/ProductionTabDetail');
        PageReference pageref2 = new PageReference('apex/ProtoRiskProductionTabDetail');
        Map<PageReference,String> pagerefMap = new Map<PageReference,String>();
        pagerefMap.put(pageref1,'ProductionTabDetail');
        pagerefMap.put(pageref2,'ProtoRiskProductionTabDetail');

        try {
            ManualDeviceHelper.btnClickPublishToTeamRoom(pagerefMap);
        } catch (Exception eException) {
            System.debug('EXCEPTION MESSAGE ' + eException.getMessage());
            System.debug('EXCEPTION TYPENAME ' + eException.getTypeName());
        }
        
        Test.stopTest();
    }

    static testMethod void setControllerCodeCoverageTapeout() {
        
        // Load Environment Variables   
        DataUtilTest.loadEnvironmentVariables();
        
        Test.startTest();
        ManualDeviceTest.setUpCustomSetting();
        List<Manual_Device__c> lMd = new List<Manual_Device__c>();
        
        Account acc = ManualDeviceTest.createAccount('Account');
        lMd.add(ManualDeviceTest.createManualDevice('MD1', acc));
        lMd.add(ManualDeviceTest.createManualDevice('MD2', acc));
        /*lMd.add(ManualDeviceTest.createManualDevice('MD3', acc));
        lMd.add(ManualDeviceTest.createManualDevice('MD4', acc));
        lMd.add(ManualDeviceTest.createManualDevice('MD5', acc));
        lMd.add(ManualDeviceTest.createManualDevice('MD12',acc));
        lMd.add(ManualDeviceTest.createManualDevice('MD6', acc));
        lMd.add(ManualDeviceTest.createManualDevice('MD7', acc));
        lMd.add(ManualDeviceTest.createManualDevice('MD8', acc));
        lMd.add(ManualDeviceTest.createManualDevice('MD9', acc));
        lMd.add(ManualDeviceTest.createManualDevice('MD0', acc));
        lMd.add(ManualDeviceTest.createManualDevice('MD10', acc));
        lMd.add(ManualDeviceTest.createManualDevice('MD11', acc));*/
        
        ManualDeviceCEReportExtension controller = new ManualDeviceCEReportExtension();
        //controller.T1 = lMd;
        controller.getList1();
        
        System.assert(!controller.hasNext, true);
        controller.nextTapeout();
        System.assert(!controller.hasPrevious, true);
        controller.firstTapeout();
        controller.lastTapeout();
        controller.previousTapeout();
        
        System.assert(controller.pageNumberTapeout == 1, true);
        System.assert(!(controller.totalPagesTapeout == 2), true);
        test.stoptest();
    }

    static testMethod void setControllerNextTapeoutError() {
        
        // Load Environment Variables   
        DataUtilTest.loadEnvironmentVariables();
        
        Test.startTest();
        ManualDeviceCEReportExtension controller = new ManualDeviceCEReportExtension();
        try {
            controller.nextTapeout();
        } catch (Exception eException) {
            System.debug('EXCEPTION MESSAGE ' + eException.getMessage());
            System.debug('EXCEPTION TYPENAME ' + eException.getTypeName());
            
            System.assert(eException.getMessage().contains(
                'Please Save Changes before leaving the Page. Please use Back button on browser to go to Previous Page.'));
        }
    }

    static testMethod void setControllerPrvTapeoutError() {
        
        // Load Environment Variables   
        DataUtilTest.loadEnvironmentVariables();
        
        Test.startTest();
        ManualDeviceCEReportExtension controller = new ManualDeviceCEReportExtension();
        try {
            controller.previousTapeout();
        } catch (Exception eException) {
            System.debug('EXCEPTION MESSAGE ' + eException.getMessage());
            System.debug('EXCEPTION TYPENAME ' + eException.getTypeName());
            
            System.assert(eException.getMessage().contains(
                'Please Save Changes before leaving the Page. Please use Back button on browser to go to Previous Page.'));
        }
    }

    static testMethod void setControllerLastTapeoutError() {
        
        // Load Environment Variables   
        DataUtilTest.loadEnvironmentVariables();
        
        Test.startTest();
        ManualDeviceCEReportExtension controller = new ManualDeviceCEReportExtension();
        try {
            controller.lastTapeout();
        } catch (Exception eException) {
            System.debug('EXCEPTION MESSAGE ' + eException.getMessage());
            System.debug('EXCEPTION TYPENAME ' + eException.getTypeName());
            
            System.assert(eException.getMessage().contains(
                'Please Save Changes before leaving the Page. Please use Back button on browser to go to Previous Page.'));
        }
    }

    static testMethod void setControllerFirstTapeoutError() {
        
        // Load Environment Variables   
        DataUtilTest.loadEnvironmentVariables();
        
        Test.startTest();
        ManualDeviceCEReportExtension controller = new ManualDeviceCEReportExtension();
        try {
            controller.firstTapeout();
        } catch (Exception eException) {
            System.debug('EXCEPTION MESSAGE ' + eException.getMessage());
            System.debug('EXCEPTION TYPENAME ' + eException.getTypeName());
            
            System.assert(eException.getMessage().contains(
                'Please Save Changes before leaving the Page. Please use Back button on browser to go to Previous Page.'));
        }
    }
    
    static testMethod void setControllerCodeCoverageProto() {
        
        // Load Environment Variables   
        DataUtilTest.loadEnvironmentVariables();
        
        Test.startTest();
        ManualDeviceTest.setUpCustomSetting();
        List<Manual_Device__c> lMd = new List<Manual_Device__c>();
        
        Account acc = ManualDeviceTest.createAccount('Account');
        lMd.add(ManualDeviceTest.createManualDevice('MD1', acc));
        lMd.add(ManualDeviceTest.createManualDevice('MD2', acc));
        lMd.add(ManualDeviceTest.createManualDevice('MD3', acc));
       /* lMd.add(ManualDeviceTest.createManualDevice('MD4', acc));
        lMd.add(ManualDeviceTest.createManualDevice('MD5', acc));
        lMd.add(ManualDeviceTest.createManualDevice('MD12', acc));
        lMd.add(ManualDeviceTest.createManualDevice('MD6', acc));
        lMd.add(ManualDeviceTest.createManualDevice('MD7', acc));
        lMd.add(ManualDeviceTest.createManualDevice('MD8', acc));
        lMd.add(ManualDeviceTest.createManualDevice('MD9', acc));
        lMd.add(ManualDeviceTest.createManualDevice('MD0', acc));
        lMd.add(ManualDeviceTest.createManualDevice('MD10', acc));
        lMd.add(ManualDeviceTest.createManualDevice('MD11', acc));*/
        
        ManualDeviceCEReportExtension controller = new ManualDeviceCEReportExtension();
        //controller.T2 = lMd;
        controller.getList2();        

        System.assert(!controller.hasNextProto, true);
        controller.nextProto();
        System.assert(!controller.hasPreviousProto, true);
        controller.firstProto();
        controller.lastProto();
        controller.previousProto();
        
        System.assert(controller.pageNumberProto == 1, true);
        System.assert(!(controller.totalPagesProto == 2), true);        
        test.stoptest();
    }
    
    static testMethod void setControllerNextProtoError() {
        
        // Load Environment Variables   
        DataUtilTest.loadEnvironmentVariables();
        
        Test.startTest();
        ManualDeviceCEReportExtension controller = new ManualDeviceCEReportExtension();
        try {
            controller.nextProto();
        } catch (Exception eException) {
            System.debug('EXCEPTION MESSAGE ' + eException.getMessage());
            System.debug('EXCEPTION TYPENAME ' + eException.getTypeName());
            
            System.assert(eException.getMessage().contains(
                'Please Save Changes before leaving the Page. Please use Back button on browser to go to Previous Page.'));
        }
    }

    static testMethod void setControllerPrvProtoError() {
        
        // Load Environment Variables   
        DataUtilTest.loadEnvironmentVariables();
        
        Test.startTest();
        ManualDeviceCEReportExtension controller = new ManualDeviceCEReportExtension();
        try {
            controller.previousProto();
        } catch (Exception eException) {
            System.debug('EXCEPTION MESSAGE ' + eException.getMessage());
            System.debug('EXCEPTION TYPENAME ' + eException.getTypeName());
            
            System.assert(eException.getMessage().contains(
                'Please Save Changes before leaving the Page. Please use Back button on browser to go to Previous Page.'));
        }
    }

    static testMethod void setControllerLastProtoError() {
        
        // Load Environment Variables   
        DataUtilTest.loadEnvironmentVariables();
        
        Test.startTest();
        ManualDeviceCEReportExtension controller = new ManualDeviceCEReportExtension();
        try {
            controller.lastProto();
        } catch (Exception eException) {
            System.debug('EXCEPTION MESSAGE ' + eException.getMessage());
            System.debug('EXCEPTION TYPENAME ' + eException.getTypeName());
            
            System.assert(eException.getMessage().contains(
                'Please Save Changes before leaving the Page. Please use Back button on browser to go to Previous Page.'));
        }
    }

    static testMethod void setControllerFirstProtoError() {
        
        // Load Environment Variables   
        DataUtilTest.loadEnvironmentVariables();
        
        Test.startTest();
        ManualDeviceCEReportExtension controller = new ManualDeviceCEReportExtension();
        try {
            controller.firstProto();
        } catch (Exception eException) {
            System.debug('EXCEPTION MESSAGE ' + eException.getMessage());
            System.debug('EXCEPTION TYPENAME ' + eException.getTypeName());
            
            System.assert(eException.getMessage().contains(
                'Please Save Changes before leaving the Page. Please use Back button on browser to go to Previous Page.'));
        }
    }    

    static testMethod void setControllerCodeCoverageProduction() {
        
        // Load Environment Variables   
        DataUtilTest.loadEnvironmentVariables();
        
        Test.startTest();
        ManualDeviceTest.setUpCustomSetting();
        List<Manual_Device__c> lMd = new List<Manual_Device__c>();
        
        Account acc = ManualDeviceTest.createAccount('Account');
        lMd.add(ManualDeviceTest.createManualDevice('MD1', acc));
        lMd.add(ManualDeviceTest.createManualDevice('MD2', acc));
        lMd.add(ManualDeviceTest.createManualDevice('MD3', acc));
        /*lMd.add(ManualDeviceTest.createManualDevice('MD4', acc));
        lMd.add(ManualDeviceTest.createManualDevice('MD5', acc));
        lMd.add(ManualDeviceTest.createManualDevice('MD12', acc));
        lMd.add(ManualDeviceTest.createManualDevice('MD6', acc));
        lMd.add(ManualDeviceTest.createManualDevice('MD7', acc));
        lMd.add(ManualDeviceTest.createManualDevice('MD8', acc));
        lMd.add(ManualDeviceTest.createManualDevice('MD9', acc));
        lMd.add(ManualDeviceTest.createManualDevice('MD0', acc));
        lMd.add(ManualDeviceTest.createManualDevice('MD10', acc));
        lMd.add(ManualDeviceTest.createManualDevice('MD11', acc));*/
        
        ManualDeviceCEReportExtension controller = new ManualDeviceCEReportExtension();
        //controller.T3 = lMd;
        controller.getList3();        

        System.assert(!controller.hasNextProduction, true);
        controller.nextProduction();
        System.assert(!controller.hasPreviousProduction, true);
        controller.firstProduction();
        controller.lastProduction();
        controller.previousProduction();
        
        System.assert(controller.pageNumberProduction == 1, true);
        System.assert(!(controller.totalPagesProduction == 2), true);
        test.stoptest();
    }
    
    static testMethod void setControllerNextProdError() {
        
        // Load Environment Variables   
        DataUtilTest.loadEnvironmentVariables();
        
        Test.startTest();
        ManualDeviceCEReportExtension controller = new ManualDeviceCEReportExtension();
        try {
            controller.nextProduction();
        } catch (Exception eException) {
            System.debug('EXCEPTION MESSAGE ' + eException.getMessage());
            System.debug('EXCEPTION TYPENAME ' + eException.getTypeName());
            
            System.assert(eException.getMessage().contains(
                'Please Save Changes before leaving the Page. Please use Back button on browser to go to Previous Page.'));
        }
    }

    static testMethod void setControllerPrvProdError() {
        
        // Load Environment Variables   
        DataUtilTest.loadEnvironmentVariables();
        
        Test.startTest();
        ManualDeviceCEReportExtension controller = new ManualDeviceCEReportExtension();
        try {
            controller.previousProduction();
        } catch (Exception eException) {
            System.debug('EXCEPTION MESSAGE ' + eException.getMessage());
            System.debug('EXCEPTION TYPENAME ' + eException.getTypeName());
            
            System.assert(eException.getMessage().contains(
                'Please Save Changes before leaving the Page. Please use Back button on browser to go to Previous Page.'));
        }
    }

    static testMethod void setControllerLastProdError() {
        
        // Load Environment Variables   
        DataUtilTest.loadEnvironmentVariables();
        
        Test.startTest();
        ManualDeviceCEReportExtension controller = new ManualDeviceCEReportExtension();
        try {
            controller.lastProduction();
        } catch (Exception eException) {
            System.debug('EXCEPTION MESSAGE ' + eException.getMessage());
            System.debug('EXCEPTION TYPENAME ' + eException.getTypeName());
            
            System.assert(eException.getMessage().contains(
                'Please Save Changes before leaving the Page. Please use Back button on browser to go to Previous Page.'));
        }
    }

    static testMethod void setControllerFirstProdError() {
        
        // Load Environment Variables   
        DataUtilTest.loadEnvironmentVariables();
        
        Test.startTest();
        ManualDeviceCEReportExtension controller = new ManualDeviceCEReportExtension();
        try {
            controller.firstProduction();
        } catch (Exception eException) {
            System.debug('EXCEPTION MESSAGE ' + eException.getMessage());
            System.debug('EXCEPTION TYPENAME ' + eException.getTypeName());
            
            System.assert(eException.getMessage().contains(
                'Please Save Changes before leaving the Page. Please use Back button on browser to go to Previous Page.'));
        }
    }
    
    static testMethod void saveExtnError() {
        
        // Load Environment Variables   
        DataUtilTest.loadEnvironmentVariables();
        
        ManualDeviceCEReportExtension controller = new ManualDeviceCEReportExtension();
        try {
            controller.save();
        } catch (Exception eException) {
            System.debug('EXCEPTION MESSAGE ' + eException.getMessage());
            System.debug('EXCEPTION TYPENAME ' + eException.getTypeName());
        }
    }
    
    static testMethod void updateManualDeviceError() {
        
        // Load Environment Variables   
        DataUtilTest.loadEnvironmentVariables();
        
        ManualDeviceCEReportExtension controller = new ManualDeviceCEReportExtension();
        try {
            controller.updateManualDevice();
        } catch (Exception eException) {
            System.debug('EXCEPTION MESSAGE ' + eException.getMessage());
            System.debug('EXCEPTION TYPENAME ' + eException.getTypeName());
        }
    }

    static testMethod void documentTest() {
        
        // Load Environment Variables   
        DataUtilTest.loadEnvironmentVariables();
        
        folder f = new folder();
        f = [select id from folder where name=:'Salesforce Adoption Dashboards'];
        blob body = Blob.valueOf('TEST BLOB DATA');
        ManualDeviceHelper.createDocument(f.id, body);
    }
}