/*
    Author: Ariz Solito
    Description: Apex test class for ReassignExportControl
    History: 
        Asolito     10172013    - Apex class created
        Vijay       16012015    - Updated the Device Stage 'Solutioning' to 'Design In' as Device will be created in 
                                  'Design In' directly and added mandatory fields.
        Vijay       04222015    - Refactored the test class and added the test methods for Internal Device
   
*/
@isTest(SeeAllData=false)
public class ReassignExportControlCtrlTest {
    
    @testSetup static void setupData(){
        DataUtilTest.loadEnvironmentVariables();
        
        
    }
    
    static device__c createSPDevice(Id acctId,Id opptyProgramId){
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
        fieldValueMap.put('Confidence_Level_Tapeout__c','50');
        fieldValueMap.put('PLM_Device_ID__c','ANBQP60ACO8CH-U01');
        fieldValueMap.put('Device_Mask_Set_Title__c','MSTTRT1');
        //fieldValueMap.put('CRMDID__c','CDID0000001.00'+system.now());
        fieldValueMap.put('Device_Type__c','Base');
        fieldValueMap.put('reticle_type__c','Small Field Reticle (SFR)');
        fieldValueMap.put('End_Application__c','Body');
        return DeviceDataFactory.createDevice(fieldValueMap);
    }
    
    //test method for the class     
    static testMethod void testClass(){                        
        // Load Environment Variables   
        //DataUtilTest.loadEnvironmentVariables();
        
         Account acc= new Account();
        Map<String,Object> fieldValueMap = new Map<String,Object>();
        fieldValueMap.put('Name', 'MYTEST ACCOUNT1');            
        fieldValueMap.put('stage__c', 'Unqualified');        
        fieldValueMap.put('sub_type__c', 'Direct');
        fieldValueMap.put('site_department__c', 'test dept');          
        fieldValueMap.put('transaction_type__c', 'transactional');                          
        fieldValueMap.put('region__c', 'APJ');        
        fieldValueMap.put('Corporate_Address_1__c', 'Test Address 1');          
        fieldValueMap.put('Corporate_City__c', 'Test City');                
        fieldValueMap.put('Corporate_Country__c', 'Singapore');
        fieldValueMap.put('Bill_To_Address_1__c', 'Test Address 1');          
        fieldValueMap.put('Bill_To_City__c', 'Test City');            
        fieldValueMap.put('Bill_To_Country__c', 'Singapore');        
        fieldValueMap.put('Fab_9_10__c','No');
        fieldValueMap.put('recordtypeid', EnvironmentVariable.get('ACCT_RT_ID_CUSTOMER'));       
        acc= AccountDataFactory.createAccount(fieldValueMap);
        
        /*Contact con = new Contact(
            firstName = 'Test',
            lastName = 'Contact',
            email = 'test@test.com',
            accountId = acc.id,
            is_portal_user_active__c = true,
            is_portal_user_created__c = true,
            role__c = 'Customers My Device Admin',
            Department__c = 'TestDepartment'
        );
        insert con;*/

        List<User> users = new List<User>();
        User u1 = new User(
            alias = 'ts', 
            email='testing@test.com',
            emailencodingkey='UTF-8', 
            lastname='TestLast', 
            firstname='TestFirst', 
            languagelocalekey='en_US',
            localesidkey='en_US', 
            profileid = '00e90000001232a',
            timezonesidkey='America/Los_Angeles', 
            username='testing112@test.com',
            communitynickname='ts',
            FederationIdentifier='Test2014'
        );
              
        users.add(u1);  
        insert users; 
                                      
        Map<String,Object> fieldValueMapOpp = new Map<String,Object>();
        fieldValueMapOpp.put('AccountId',acc.Id);
        fieldValueMapOpp.put('Name','Test Opportunity');  
        fieldValueMapOpp.put('StageName','1. Discovery');
        fieldValueMapOpp.put('CloseDate',date.newinstance(2012, 12, 21));  
        fieldValueMapOpp.put('Target_Process_Node__c','14XM');
        fieldValueMapOpp.put('Market_Segment__c','Automotive');  
        fieldValueMapOpp.put('Process_Platform__c','GF Baseline');
        fieldValueMapOpp.put('Fab_Split__c',100);          
        fieldValueMapOpp.put('Process_Geometry__c','0.014UM');  
        fieldValueMapOpp.put('Process_Family__c','Super Low Power');
        fieldValueMapOpp.put('Opportunity_Sourcing_Type__c','First Source');  
        fieldValueMapOpp.put('Fab_Assignment_1__c','FAB 1');
         
        Opportunity opp = OpportunityDataFactory.createOpportunity(fieldValueMapOpp);
        system.AssertEquals('Test Opportunity', opp.Name);
        
        Opportunity_Program__c opProg = new Opportunity_Program__c(
            Name='Test OppProg',
            Account__c=acc.id,
            Opportunity__c=opp.id
        );
        Test.startTest();
        insert opProg;
                
        List<Opportunity_Program_Team_Member__c> mems = new List<Opportunity_Program_Team_Member__c>();
        
        Opportunity_Program_Team_Member__c optm1 = new Opportunity_Program_Team_Member__c(
            user__c = u1.id,
            team_role__c= 'Field Application Engineer',
            device_access__c = 'Read/Write',
            core_team_member__c = true,
            opportunity_program_access__c = 'Read/Write',
            opportunity_program__c = opProg.id
            
        );               
        
        mems.add(optm1);     
        insert mems; 
        
        
        
        System.runAs(u1){
            List<Device__c> devs = new List<Device__c>();
            List<Map<String,Object>> fieldValueMapList = new List<Map<String,Object>>();
            /*Device__c dev = new Device__c(
                Name = 'TESTDEVICE1313',
                Stage__c = 'Design In',
                Status__c = 'Active',
                Account__c = acc.id,
                Opportunity2__c = opp.id,
                Opportunity_Program__c = opProg.id,
                Market_Segment__c = 'Automotive',
                Semiconductor_Device__c = 'Analog Regulator',
                End_Application__c = 'Body',
                Device_Sourcing__c = '3rd Source',
                Tapeout_Type__c = 'Customer MPW',
                Siebel_Device_ID__c = '0987654321',
                IP_Gap__c = false,
                Actual_Tapeout_Date__c = date.newInstance(2013,5,20),
                Forecasted_Lot_Start_Date__c = date.newInstance(2013,5,20),
                Original_Forecasted_Tapeout_Date__c = date.newInstance(2013,5,20),
                Current_Forecast_Tapeout_Date__c = date.newInstance(2013,3,4),
                Enabled_via_previous_MPW_1__c = 'No',
                Confidence_Level_Tapeout__c = '100',
                Fab__c = 'Fab 3'          
            );  */    
            Map<String,Object> fieldValueMap3 = new Map<String,Object>();
            fieldValueMap3.put('Account__c',acc.id);
            fieldValueMap3.put('Name','TESTDEVICEZAIH12345671');
            fieldValueMap3.put('Opportunity_Program__c',opProg.id);
            fieldValueMap3.put('Fab__c','FAB 3');
            fieldValueMap3.put('GSOP_Assignment_Tapeout_Plan__c','No');
            fieldValueMap3.put('Market_Segment__c','Automotive');
            fieldValueMap3.put('Semiconductor_Device__c','Analog Amplifier');
            fieldValueMap3.put('End_Customer__c','Test Customer');
            fieldValueMap3.put('Device_Sourcing__c','1st Source');
            fieldValueMap3.put('Stage__c','Design In');
            fieldValueMap3.put('Status__c','Active');
            fieldValueMap3.put('Siebel_Device_ID__c','1234567891');
            fieldValueMap3.put('Tapeout_Type__c','Single Product');
            fieldValueMap3.put('Confidence_Level_Tapeout__c','50');
            fieldValueMap3.put('PLM_Device_ID__c','ANBQP60ACO8CH-U01');
            fieldValueMap3.put('Device_Mask_Set_Title__c','MSTTST');
            fieldValueMap3.put('CRMDID__c','CDID0000002.00');
            fieldValueMap3.put('Device_Type__c','Base');
            fieldValueMap3.put('reticle_type__c','Small Field Reticle (SFR)');
            fieldValueMap3.put('End_Application__c','Body');
            fieldValueMap3.put('IP_Gap__c',false);
            fieldValueMap3.put('Actual_Tapeout_Date__c',date.newInstance(2013,5,20));
            fieldValueMap3.put('Forecasted_Lot_Start_Date__c',date.newInstance(2013,5,20));
            fieldValueMap3.put('Original_Forecasted_Tapeout_Date__c',date.newInstance(2013,5,20));
            fieldValueMap3.put('Current_Forecast_Tapeout_Date__c',date.newInstance(2013,3,4));
            fieldValueMap3.put('Enabled_via_previous_MPW_1__c','No');
            fieldValueMap3.put('Confidence_Level_Tapeout__c','100');
            
            /*Mask_Set_Title__c MSTId = DeviceUtilTest.createMaskSetTtitleObj('MSTEST');
            string MSTAccId = DeviceUtilTest.createMSTAccount(acc.id,MSTId.id);
            String dev =  DeviceUtilTest.createCustomerMPWDevice(acc.id, opProg.id);*/
            
            /*Device__c dev2 = new Device__c(
                Name = 'TESTDEVICE1314',
                Stage__c = 'Design In',
                Status__c = 'Active',
                Account__c = acc.id,
                Opportunity2__c = opp.id,
                Opportunity_Program__c = opProg.id,
                Market_Segment__c = 'Automotive',
                Semiconductor_Device__c = 'Analog Regulator',
                End_Application__c = 'Body',
                Device_Sourcing__c = '3rd Source',
                Tapeout_Type__c = 'Customer MPW',
                Siebel_Device_ID__c = '0987654321',
                IP_Gap__c = false,
                Actual_Tapeout_Date__c = date.newInstance(2013,5,20),
                Forecasted_Lot_Start_Date__c = date.newInstance(2013,5,20),
                Original_Forecasted_Tapeout_Date__c = date.newInstance(2013,5,20),
                Current_Forecast_Tapeout_Date__c = date.newInstance(2013,3,4),
                Enabled_via_previous_MPW_1__c = 'No',
                Confidence_Level_Tapeout__c = '100',
                Fab__c = 'Fab 3'            
            );*/
            Map<String,Object> fieldValueMap1 = new Map<String,Object>();
            fieldValueMap1.put('Account__c',acc.id);
            fieldValueMap1.put('Name','TESTDEVICEZAIH12345672');
            fieldValueMap1.put('Opportunity_Program__c',opProg.id);
            fieldValueMap1.put('Fab__c','FAB 3');
            fieldValueMap1.put('GSOP_Assignment_Tapeout_Plan__c','No');
            fieldValueMap1.put('Market_Segment__c','Automotive');
            fieldValueMap1.put('Semiconductor_Device__c','Analog Amplifier');
            fieldValueMap1.put('End_Customer__c','Test Customer');
            fieldValueMap1.put('Device_Sourcing__c','1st Source');
            fieldValueMap1.put('Stage__c','Design In');
            fieldValueMap1.put('Status__c','Active');
            fieldValueMap1.put('Siebel_Device_ID__c','1234567892');
            fieldValueMap1.put('Tapeout_Type__c','Single Product');
            fieldValueMap1.put('PLM_Device_ID__c','ANBQP60ACO8CH-U01');
            fieldValueMap1.put('Device_Mask_Set_Title__c','MSTXYZ');
            fieldValueMap1.put('CRMDID__c','CDID0000003.00');
            fieldValueMap1.put('Device_Type__c','Base');
            fieldValueMap1.put('reticle_type__c','Small Field Reticle (SFR)');
            fieldValueMap1.put('End_Application__c','Body');
            fieldValueMap1.put('IP_Gap__c',false);
            fieldValueMap1.put('Actual_Tapeout_Date__c',date.newInstance(2013,5,20));
            fieldValueMap1.put('Forecasted_Lot_Start_Date__c',date.newInstance(2013,5,20));
            fieldValueMap1.put('Original_Forecasted_Tapeout_Date__c',date.newInstance(2013,5,20));
            fieldValueMap1.put('Current_Forecast_Tapeout_Date__c',date.newInstance(2013,3,4));
            fieldValueMap1.put('Enabled_via_previous_MPW_1__c','No');
            fieldValueMap1.put('Confidence_Level_Tapeout__c','100');
            
            /*Mask_Set_Title__c MSTId2 = DeviceUtilTest.createMaskSetTtitleObj('MST010');
            string MSTAccId2 = DeviceUtilTest.createMSTAccount(acc.id,MSTId.id);
            String dev2 =  DeviceUtilTest.createCustomerMPWDevice(acc.id, opProg.id);*/
            /*Device__c dev3 = new Device__c(
                Name = 'TESTDEVICE1315',
                Stage__c = 'Design In',
                Status__c = 'Active',
                Account__c = acc.id,
                Opportunity2__c = opp.id,
                Opportunity_Program__c = opProg.id,
                Market_Segment__c = 'Automotive',
                Semiconductor_Device__c = 'Analog Regulator',
                End_Application__c = 'Body',
                Device_Sourcing__c = '3rd Source',
                Tapeout_Type__c = 'Customer MPW',
                Siebel_Device_ID__c = '0987654321',
                IP_Gap__c = false,
                Actual_Tapeout_Date__c = date.newInstance(2013,5,20),
                Forecasted_Lot_Start_Date__c = date.newInstance(2013,5,20),
                Original_Forecasted_Tapeout_Date__c = date.newInstance(2013,5,20),
                Current_Forecast_Tapeout_Date__c = date.newInstance(2013,3,4),
                Enabled_via_previous_MPW_1__c = 'No',
                Confidence_Level_Tapeout__c = '100',
                Fab__c = 'Fab 3'            
            );*/
            Map<String,Object> fieldValueMap2 = new Map<String,Object>();
            fieldValueMap2.put('Account__c',acc.id);
            fieldValueMap2.put('Name','TESTDEVICEZAIH12345673');
            fieldValueMap2.put('Opportunity_Program__c',opProg.id);
            fieldValueMap2.put('Fab__c','FAB 3');
            fieldValueMap2.put('GSOP_Assignment_Tapeout_Plan__c','No');
            fieldValueMap2.put('Market_Segment__c','Automotive');
            fieldValueMap2.put('Semiconductor_Device__c','Analog Amplifier');
            fieldValueMap2.put('End_Customer__c','Test Customer');
            fieldValueMap2.put('Device_Sourcing__c','1st Source');
            fieldValueMap2.put('Stage__c','Design In');
            fieldValueMap2.put('Status__c','Active');
            fieldValueMap2.put('Siebel_Device_ID__c','1234567894');
            fieldValueMap2.put('Tapeout_Type__c','Single Product');
            fieldValueMap2.put('PLM_Device_ID__c','ANBQP60ACO8CH-U01');
            fieldValueMap2.put('Device_Mask_Set_Title__c','MSTPQR');
            fieldValueMap2.put('CRMDID__c','CDID0000004.00');
            fieldValueMap2.put('Device_Type__c','Base');
            fieldValueMap2.put('reticle_type__c','Small Field Reticle (SFR)');
            fieldValueMap2.put('End_Application__c','Body');
            fieldValueMap2.put('IP_Gap__c',false);
            fieldValueMap2.put('Actual_Tapeout_Date__c',date.newInstance(2013,5,20));
            fieldValueMap2.put('Forecasted_Lot_Start_Date__c',date.newInstance(2013,5,20));
            fieldValueMap2.put('Original_Forecasted_Tapeout_Date__c',date.newInstance(2013,5,20));
            fieldValueMap2.put('Current_Forecast_Tapeout_Date__c',date.newInstance(2013,3,4));
            fieldValueMap2.put('Enabled_via_previous_MPW_1__c','No');
            fieldValueMap2.put('Confidence_Level_Tapeout__c','100');
            
            /*Mask_Set_Title__c MSTId3 = DeviceUtilTest.createMaskSetTtitleObj('MST009');
            string MSTAccId3 = DeviceUtilTest.createMSTAccount(acc.id,MSTId.id);
            String dev3 =  DeviceUtilTest.createCustomerMPWDevice(acc.id, opProg.id);*/
              fieldValueMapList.add(fieldValueMap3);
              fieldValueMapList.add(fieldValueMap1);
              fieldValueMapList.add(fieldValueMap2);
              devs = DeviceDataFactory.createDevices(fieldValueMapList,3);          
            
            // Creation of Export Control HS Code   
            Export_Control_HS_Code__c expConHSCode = new Export_Control_HS_Code__c(
                HS_Code__c = 'Test HS Code',
                HS_Description__c = 'Test HS Description'
            );
            insert expConHSCode;     
            
            /*CDS_Color_zone__c cdsColZone = new CDS_Color_zone__c (Name = '3E292', Color__c = 'Orange');
            insert cdsColZone;*/
            
            List<DeviceITAR__c> devITARList = new List<DeviceITAR__c>();
            
            DeviceITAR__c devITAR1 = new DeviceITAR__c(Name = 'Yes', ITAR_Classification_Status__c = 'Yes');
            DeviceITAR__c devITAR2 = new DeviceITAR__c(Name = 'No', ITAR_Classification_Status__c = 'No');
            devITARList.add(devITAR1);
            devITARList.add(devITAR2);
            insert devITARList;
             
            // Creation of Export Control Form    
            List<Export_Control_Form__c> exps = new List<Export_Control_Form__c>();        
            Export_Control_Form__c exp = new Export_Control_Form__c(        
                OwnerId__c = UserInfo.getUserId(),
                Product_Description__c = 'Test Description',
                Phone__c = '3456321',
                Weapon_Product__c = 'No',
                Military_App_Product__c = 'No',
                ITAR_Product__c = 'No',
                US_EAR_Product__c = 'No',
                Non_US_EAR_Product__c = 'No',
                Harmonized_System__c = expConHSCode.Id,
                Other_Harmonized_System__c = 'Others',
                status__c = 'Submitted'
                
            );                     
                    
            Export_Control_Form__c exp2 = new Export_Control_Form__c(        
                OwnerId__c = UserInfo.getUserId(),
                Product_Description__c = 'Test Description',
                Phone__c = '3456321',
                Weapon_Product__c = 'No',
                Military_App_Product__c = 'No',
                ITAR_Product__c = 'No',
                US_EAR_Product__c = 'No',
                Non_US_EAR_Product__c = 'No',
                Harmonized_System__c = expConHSCode.Id,
                Other_Harmonized_System__c = 'Others',
                status__c = 'Approved',
                D1_National_Access_is_Allowed__c = 'No', ECCN_Technology__c = '3E292', ECCN_Wafer__c = '3E292'            
            );
            
            exps.add(exp);
            exps.add(exp2);          
            insert exps;        
            
            List<Device_Export_Control_Junction__c> junctions = new List<Device_Export_Control_Junction__c>();
            Device_Export_Control_Junction__c junction = new Device_Export_Control_Junction__c(
                device__c = devs[0].id,
                export_control_form__c = exp.id
            ); 
            
            Device_Export_Control_Junction__c junction2 = new Device_Export_Control_Junction__c(
                device__c = devs[1].id,
                export_control_form__c = exp2.id
            );         
                     
            junctions.add(junction);        
            junctions.add(junction2);                     
            insert junctions;
            
    
            
            //test VCID override fail - no VCID components
            PageReference pageRef = Page.ReassignExportControl;
            pageRef.getParameters().put('did',devs[0].id);
            Test.setCurrentPageReference(pageRef);
            
            ReassignExportControlCtrl ctrl = new ReassignExportControlCtrl();
            ctrl.cancel();
            
            ctrl.init();
            
            //pick one Approved export control to be reassigned from the list
            for(ReassignExportControlCtrl.record r :ctrl.junction.recordList){
                if(r.status == 'Approved'){
                    r.isPicked = true;
                    break;
                }
            }            
            ctrl.save();
            
            //
            devs[0].approve_reassign_export_control_number__c = 'No';
            update devs[0];
            Test.stopTest(); 
            ReassignExportControl.hasRun = false;
            
            devs[0].approve_reassign_export_control_number__c = 'Yes';
            update devs[0];
        }
        
                                     
    }
    
    //test method for Internal Device
    testMethod static void testSave(){
        List<RecordType> recordTypeList = [Select Id from RecordType where sObjectType ='Account' and developerName = 'GLOBALFOUNDRIES_Internal'];
        Account account = InternalDeviceTestUtil.createAccount('Test Account1', 'Qualified', 'TestAccount1', 'Site', 'Direct', 'transactional', 'Fabless - Emerging',
                                             'Mature (> 0.11um)', 'APJ', 'APJ-FE-CHINA', 'APJ-China', 'APJ-China', true, '50 water', 'Bijing', 'China',  '50', 'GF Investment LLC OU', 
                                             100);
                                        
        if(!recordTypeList.isEmpty()){                      
            account.RecordTypeId = recordTypeList[0].Id;
        }
        
        List<Device__c> deviceList = new List<Device__c>();
        List<RecordType> deviceRecTypeList = [Select Id from RecordType where sObjectType ='Device__c' and developerName = 'Internal_Device'];
        
        /*deviceList.add(InternalDeviceTestUtil.createDevice('TestInternalDevice1', 'Fab 2', 'Design In', 'Active', '100', System.today(), 
                                                                '1234567890', 'Single Product',  account.Id, '0.028UM', 'Super Low Power','Multi Layer Reticle (MLR)','TESTMST','No'));
        deviceList.add(InternalDeviceTestUtil.createDevice('TestInternalDevice2', 'Fab 2', 'Design In', 'Active', '100', System.today(), 
                                                                '1234567890', 'Single Product',  account.Id, '0.028UM', 'Super Low Power','Multi Layer Reticle (MLR)','TESTMSK','No'));*/
        
        String oppId = DeviceUtilTest.createOpp(account.Id, '0.09UM');
        String oppProgId = DeviceUtilTest.createOppProg(account.Id, oppId);
        deviceList.add(DeviceUtilTest.createSPDevice(account.Id, oppProgId));
        deviceList.add(DeviceUtilTest.createSPDevice(account.Id, oppProgId));                                                                                                              
        if(!deviceRecTypeList.isEmpty()){                       
            deviceList[0].RecordTypeId = deviceRecTypeList[0].Id;
            deviceList[1].RecordTypeId = deviceRecTypeList[0].Id;
            deviceList[0].Internal_Device_Geometry__c = '0.010UM';
            deviceList[1].Internal_Device_Geometry__c = '0.014UM';
            deviceList[0].Internal_Device_Process_Family__c = 'Generic / Nominal';
            deviceList[1].Internal_Device_Process_Family__c = 'High Performance / Low Voltage';
            deviceList[0].Device_Mask_Set_Title__c = 'MST890';
            deviceList[1].Device_Mask_Set_Title__c = 'MST567';
            deviceList[0].Siebel_Device_ID__c = '1234567567';
            deviceList[0].CRMDID__c = 'CDID0000008.00';
            deviceList[1].Siebel_Device_ID__c = '1234567246';
            deviceList[1].CRMDID__c = 'CDID0000009.00';
            deviceList[0].Name = 'TESTDEVICEZAIH12345674';
            deviceList[1].Name = 'TESTDEVICEZAIH12345675';
            
        }
        Test.startTest();
        insert deviceList;
        Profile[] profiles = [Select p.name, p.id From Profile p where p.UserLicense.Name = 'Salesforce' and p.name ='GF FAE/FTS' LIMIT 1];
        List<User> userList = [Select Id, Email From User Where ProfileId = :profiles[0].Id AND IsActive=true Limit 1];
        
        if(userList.isEmpty()){
            DataUtilTest.LoadHCMEnvVariables(); 
            List<HCM_Employee__c> hcmEmployeeList = new List<HCM_Employee__c>();
            for(Integer i = 1; i<3; i++){
                hcmEmployeeList.add(InternalDeviceTestUtil.createHCMEmployee('FAEtest'+i, 'User'+i, 'FAEFTS'+i, 'IT', 'testFAEFTSUser'+i+'@testFAEFTSUser.com',
                                                                                        'TestTitle', '999999999','FAEtest'+i));
                userList.add(InternalDeviceTestUtil.createUser('FAEtest'+i, 'testFAEFTSUser'+i+'@testFAEFTSUser1.com', 'User1', 'FAEFTS'+i, profiles[0].Id, 
                                                            'testFAEFTSUser'+i+'@testFAEFTSUser.com', 'FAEtest'+i));
            }
        
            insert hcmEmployeeList;
            insert userList;
        }   
        List<Account_Team_Proxy__c> atpList = new List<Account_Team_Proxy__c>();
       
        for(User u:userList){
            atpList.add(new Account_Team_Proxy__c(User__c = u.id, Account__c=account.id, Account_Access__c='Read/Write',Team_Role__c='Account Administrator',
                                                Sequence_No__c='1',  Account_Role_ID__c='test'));
        }
        
        insert atpList;
        Export_Control_HS_Code__c expContrlHSCode =  InternalDeviceTestUtil.createExportCntrlHSCode('Test HS Code', 'Test HS Description');
        insert expContrlHSCode;
        List<Export_Control_Form__c> expCntrlFrmList = new List<Export_Control_Form__c>();
        /*expCntrlFrmList.add(InternalDeviceTestUtil.createExportControlForm(UserInfo.getUserId(),'Test Description','3456321',
                                                                                                'No','No','No','No','No',expContrlHSCode.Id,'Others','Approved',));
        expCntrlFrmList.add(InternalDeviceTestUtil.createExportControlForm(UserInfo.getUserId(),'Test Description','3456321',
                                                                                                'No','No','No','No','No',expContrlHSCode.Id,'Others','Submitted'));*/
                                                                                                
        Export_Control_Form__c exp = new Export_Control_Form__c(        
                OwnerId__c = UserInfo.getUserId(),
                Product_Description__c = 'Test Description',
                Phone__c = '3456321',
                Weapon_Product__c = 'No',
                Military_App_Product__c = 'No',
                ITAR_Product__c = 'No',
                US_EAR_Product__c = 'No',
                Non_US_EAR_Product__c = 'No',
                Harmonized_System__c = expContrlHSCode.Id,
                Other_Harmonized_System__c = 'Others',
                status__c = 'Approved',
                D1_National_Access_is_Allowed__c = 'No', ECCN_Technology__c = 'test', ECCN_Wafer__c = 'test'    
                
            );                     
                    
            Export_Control_Form__c exp2 = new Export_Control_Form__c(        
                OwnerId__c = UserInfo.getUserId(),
                Product_Description__c = 'Test Description',
                Phone__c = '3456321',
                Weapon_Product__c = 'No',
                Military_App_Product__c = 'No',
                ITAR_Product__c = 'No',
                US_EAR_Product__c = 'No',
                Non_US_EAR_Product__c = 'No',
                Harmonized_System__c = expContrlHSCode.Id,
                Other_Harmonized_System__c = 'Others',
                status__c = 'Submitted'
            );
            
            expCntrlFrmList.add(exp);
            expCntrlFrmList.add(exp2);                                                                                      
                                                                                    
        insert expCntrlFrmList;
        system.assert(expCntrlFrmList.size() > 0);
        List<Device_Export_Control_Junction__c> devExpCntrlJunList = new List<Device_Export_Control_Junction__c>();
        devExpCntrlJunList.add(InternalDeviceTestUtil.createDeviceExportControlJunc(deviceList[0].Id, expCntrlFrmList[0].id));     
        devExpCntrlJunList.add(InternalDeviceTestUtil.createDeviceExportControlJunc(deviceList[1].Id, expCntrlFrmList[1].id));
        insert devExpCntrlJunList;
        
        PageReference pageRef = Page.ReassignExportControl;
        pageRef.getParameters().put('did',deviceList[0].Id);
        pageRef.getParameters().put('eid',expCntrlFrmList[0].id);
        Test.setCurrentPageReference(pageRef);
        ReassignExportControlCtrl ctrl = new ReassignExportControlCtrl();
        for(ReassignExportControlCtrl.record r :ctrl.junction.recordList){
            if(r.status == 'Submitted'){
                r.isPicked = true;
                break;
            }
        }      
        
        ctrl.save();
        Test.StopTest();    
            
    }
    
    
}