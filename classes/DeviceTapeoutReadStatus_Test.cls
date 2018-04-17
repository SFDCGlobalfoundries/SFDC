/*
  Author: Anirban Roy
  Description: This is the test class for DeviceTapeoutReadStatus class.
  History:
    ARoy        06242013    - code creation.              
    Nbustillos  10122013    - Added call to loadEnvironmentVariables() method.
                            - Updated annotation to SeeAllData=false     
    Vijay       11282014    - Updated the Device Stage 'Solutioning' to 'Design In' as Device will be created in 'Design In' directly.    
    Ashwini     04132015    - Updated code for making SeeAllData=false and refactoring of test class.
    ARoy        11232015    - modified code to include Comfigurator Plus approval check. 
*/

@isTest(SeeAllData=false)
public class DeviceTapeoutReadStatus_Test {
    @testSetup static void testdata() {
        DataUtilTest.loadEnvironmentVariables();
        
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

    AccountDataFactory.createAccount(fieldValueMap);
    }
    //Creation of User
    static User createUser(){
        User usr1 = [select id,name,email  from User where profileId in (select id from Profile where Name='System Administrator') and IsActive=true limit 1];
        return usr1;
    }
           
    // Creation of an opportunity
    static Id createOpp(Id acctId){
        Map<String,Object> fieldValueMap = new Map<String,Object>();
        fieldValueMap.put('AccountId',acctId);
        fieldValueMap.put('Name','Test Opportunity');  
        fieldValueMap.put('StageName','1. Discovery');
        fieldValueMap.put('CloseDate',date.newinstance(2012, 12, 21));  
        fieldValueMap.put('Target_Process_Node__c','14XM');
        fieldValueMap.put('Market_Segment__c','Automotive');  
        fieldValueMap.put('Process_Platform__c','GF Baseline');
        fieldValueMap.put('Fab_Split__c',100);          
        fieldValueMap.put('Process_Geometry__c','0.09UM');  
        fieldValueMap.put('Process_Family__c','Generic / Nominal');
        fieldValueMap.put('Opportunity_Sourcing_Type__c','First Source');          
         
        return OpportunityDataFactory.createOpportunity(fieldValueMap).id;
        
    }
    
    // Creation of an opportunity program
    static Id createOppProg(Id acctId,Id oppId){
        Opportunity_Program__c opProg = new Opportunity_Program__c(Name='Test OppProg',Account__c=acctId,Opportunity__c=oppId);
        insert opProg;
        return opProg.Id;
    }
    
    // Creation of an opportunity program team member
    static Opportunity_Program_Team_Member__c createOppProgTmMem(Id oppProgId, Id userId){
        Opportunity_Program_Team_Member__c oppProgTM = new Opportunity_Program_Team_Member__c(Core_Team_Member__c=false,
                                        Device_Access__c='Read/Write',Opportunity_Program_Access__c='Read/Write',
                                        Opportunity_Program__c=oppProgId,Team_Role__c='Field Application Engineer',
                                        User__c=userId,Flag_for_Delete__c=false);
        insert oppProgTM;
        return oppProgTM;
    }
    
    /*static Device__c createDevice(Id accId, Id oppId, Id oppProgId, Id processId){
        Device__c dev = new Device__c();
        dev.Name = 'TESTDEVICE1947';
        dev.Stage__c = 'Design In';
        dev.Status__c = 'Active';
        dev.Account__c = accId;
        dev.Opportunity2__c = oppId;
        dev.Opportunity_Program__c = oppProgId;
        dev.Market_Segment__c = 'Automotive';
        dev.Semiconductor_Device__c = 'Analog Regulator';
        dev.End_Application__c = 'Body';
        dev.Device_Sourcing__c = '3rd Source';
        //dev.Tapeout_Type__c = 'Customer MPW';
        dev.Tapeout_Type__c = 'GlobalShuttle MPW';
        dev.Siebel_Device_ID__c = '0987654321';
        dev.IP_Gap__c = false;
        dev.Assigned_Process_ID__c = processId;
        dev.BX041_Status__c = 'Closed';
        dev.Actual_Tapeout_Date__c = date.newInstance(2013,5,20);
        dev.Original_Forecasted_Tapeout_Date__c = date.newInstance(2013,5,20);
        dev.Current_Forecast_Tapeout_Date__c = date.newInstance(2013,3,4);
        dev.Fab__c = 'FAB 2';
        dev.Confidence_Level_Tapeout__c = '100';
        //dev.Mask_Set_Title_Lookup__c='a94O0000000Cbyl';
        dev.Device_Mask_Set_Title__c='Test Device';        
        dev.Reticle_Type__c='Single Layer Reticle (SLR)';
        insert dev;
        system.debug('Device='+dev.id);
        return dev; 
    }
    
    static Device__c createDevice1(Id accId, Id oppId, Id oppProgId, Id processId){
        Device__c dev = new Device__c();
        dev.Name = 'TESTDEVICE1948';
        dev.Stage__c = 'Design In';
        dev.Status__c = 'Active';
        dev.Account__c = accId;
        dev.Opportunity2__c = oppId;
        dev.Opportunity_Program__c = oppProgId;
        dev.Market_Segment__c = 'Automotive';
        dev.Semiconductor_Device__c = 'Analog Regulator';
        dev.End_Application__c = 'Body';
        dev.Device_Sourcing__c = 'First Source';
        dev.Tapeout_Type__c = 'GlobalShuttle MPW';
        dev.Export_Control_Waiver_Flag__c = 'Yes';
        dev.Siebel_Device_ID__c = '0987654321';
        dev.IP_Gap__c = false;
        dev.Assigned_Process_ID__c = processId;
        dev.BX041_Status__c = 'Closed';
        dev.Device_Type__c = 'Base';
        dev.Actual_Tapeout_Date__c = date.newInstance(2013,5,20);
        dev.Original_Forecasted_Tapeout_Date__c = date.newInstance(2013,5,20);
        dev.Current_Forecast_Tapeout_Date__c = date.newInstance(2013,3,4);
        dev.Geometry_Filter__c = '0.010UM';
        dev.Fab__c = 'FAB 2';
        dev.Confidence_Level_Tapeout__c = '100';
        dev.Mask_Set_Title_Lookup__c='a94O0000000Cbyl';
        dev.Device_Mask_Set_Title__c='Test Device';
        dev.Reticle_Type__c='Single Layer Reticle (SLR)';
        insert dev;
        return dev; 
    }
    
    static Device__c createDevice2(Id accId, Id oppId, Id oppProgId, Id processId, Id newPartId){
        Device__c dev = new Device__c();
        dev.Name = 'TESTDEVICE1949';
        dev.Stage__c = 'Design In';
        dev.Status__c = 'Active';
        dev.Account__c = accId;
        dev.Opportunity2__c = oppId;
        dev.Opportunity_Program__c = oppProgId;
        dev.Market_Segment__c = 'Automotive';
        dev.Semiconductor_Device__c = 'Analog Regulator';
        dev.End_Application__c = 'Body';
        dev.Device_Sourcing__c = '3rd Source';
        dev.Device_Type__c = 'Revision';
        dev.Tapeout_Type__c = 'GlobalShuttle MPW';
        dev.Siebel_Device_ID__c = '0987654321';
        dev.IP_Gap__c = false;
        dev.Assigned_Process_ID__c = processId;
        dev.BX041_Status__c = 'Pending Submission';
        dev.Secure_Device__c = 'Y';
        dev.Automotive_Device__c = 'Yes';
        dev.Automotive_Grade__c = 'Grade 0';
        dev.Confidence_Level_Tapeout__c = '10';
        dev.Fab__c = 'FAB 1';
        //dev.NPC_Form__c = newPartId;
        dev.PTRF_ID__c = 'test';
        dev.Actual_Tapeout_Date__c = date.newInstance(2013,5,20);
        dev.Original_Forecasted_Tapeout_Date__c = date.newInstance(2013,5,20);
        dev.Current_Forecast_Tapeout_Date__c = date.newInstance(2013,3,4);
        dev.Fab__c = 'FAB 2';
        dev.Confidence_Level_Tapeout__c = '100';
        //dev.Mask_Set_Title_Lookup__c='a94O0000000Cbyl';
        dev.Device_Mask_Set_Title__c='TestDevice';
        dev.Reticle_Type__c='Single Layer Reticle (SLR)';
        insert dev;
        return dev; 
    }
    */
    static Process__c createProcess(){
        Process__c p = new Process__c();
        p.Name = 'TestProcess';
        p.Available_to_Sell__c = 'Available';
        insert p;
        return p;  
    }
    
    static Process__c createProcess1(){
        Process__c p = new Process__c();
        p.Name = 'TestProcess';
        p.Available_to_Sell__c = 'Pending EOL';
        insert p;
        
        return p;
    }
    
    static New_Part_Creation_Form__c createNewPartCreateForm(Id baseDevId, Id accountId){
        New_Part_Creation_Form__c newPart = new New_Part_Creation_Form__c();
        newPart.Account__c = accountId;
        newPart.Tapeout_Required__c = 'No';
        newPart.Tapeout_Type__c = 'Retrofit';
        newPart.New_Part_ID__c = 'TestNewPart1';
        newPart.BASE_Device__c = baseDevId;
        newPart.Originating_Device__c = baseDevId;
        insert newPart;
        return newpart;
    }
    
    //Static method to create proposal test record
    static Apttus_Proposal__Proposal__c createProposal(Id acctId, Id devId){
        //Create a proposal from Device
        Apttus_Proposal__Proposal__c proposal = 
                    new Apttus_Proposal__Proposal__c(Apttus_Proposal__Description__c = 'Test Proposal Description ...',
                                                    Apttus_Proposal__Approval_Stage__c = 'Draft',
                                                    Apttus_Proposal__Account__c = acctId,
                                                    Device__c = devId);
                                                     
        
        insert proposal;
        return proposal;
    }  
        
    static testMethod void deviceTapeoutReadStatusTest1() {
         
        
        
        // Data creation
        User user = DeviceTapeoutReadStatus_Test.createUser();
        String acctId = getAccount('MYTEST ACCOUNT1').id;
        String oppId = DeviceTapeoutReadStatus_Test.createOpp(acctId);
        String oppProgId = DeviceTapeoutReadStatus_Test.createOppProg(acctId, oppId);
        Opportunity_Program_Team_Member__c oppProgTM = DeviceTapeoutReadStatus_Test.createOppProgTmMem(oppProgId, user.id);
        Process__c p = DeviceTapeoutReadStatus_Test.createProcess();
        Test.startTest();
        Device__c dev = DeviceUtilTest.createCMPWDevice(acctId,oppProgId);        
        Insert dev;
        //Device__c dev = DeviceUtilTest.createGlobalShuttleMPWDevice2(acctId,oppId,oppProgId,p.Id);
       // String MSTId1 = DeviceUtilTest.createMaskSetTitle1();
        //string MSTAccId = DeviceUtilTest.createMSTAccount(acctId,MSTId1);
        //string baseDeviceId = DeviceUtilTest.createCustomerMPWDevice10(acctId,oppProgId);
        dev = [select Pre_PTRF_Validation_Status__c, Tapeout_Readiness_Validation_Error__c from Device__c where id = :dev.Id];
       
        //system.assertEquals(dev.Pre_PTRF_Validation_Status__c,'Not Pre-PTRF Ready');
        //system.assert(dev.Tapeout_Readiness_Validation_Error__c.contains('Export Control Declaration has not been completed for this Device.'));
        //system.assert(dev.Tapeout_Readiness_Validation_Error__c.contains('Secure Device is required.'));
        //system.assert(dev.Tapeout_Readiness_Validation_Error__c.contains('Automotive Device is required.'));
        //system.assert(dev.Tapeout_Readiness_Validation_Error__c.contains('Stage is in Solutioning'));
        
        Test.stopTest();
    }
    
    static testMethod void deviceTapeoutReadStatusTest2() {
        
        
        // Data creation
        User user = DeviceTapeoutReadStatus_Test.createUser();
        String acctId = getAccount('MYTEST ACCOUNT1').id;
        String oppId = DeviceTapeoutReadStatus_Test.createOpp(acctId);
        String oppProgId = DeviceTapeoutReadStatus_Test.createOppProg(acctId, oppId);
        Opportunity_Program_Team_Member__c oppProgTM = DeviceTapeoutReadStatus_Test.createOppProgTmMem(oppProgId, user.id);
        Process__c p = DeviceTapeoutReadStatus_Test.createProcess1();
        Test.startTest();
        Device__c dev = DeviceUtilTest.createCMPWDevice(acctId,oppProgId);
        Insert dev ;        
        //Device__c dev = DeviceUtilTest.createGlobalShuttleMPWDevice2(acctId,oppId,oppProgId,p.Id);
        //String MSTId = DeviceUtilTest.createMaskSetTtitle();
        //string MSTAccId = DeviceUtilTest.createMSTAccount(acctId,MSTId);
        //Device__c baseDeviceId = DeviceUtilTest.createSPDevice(acctId,oppProgId);
        //Insert baseDeviceId;
        dev = [select Pre_PTRF_Validation_Status__c, Tapeout_Readiness_Validation_Error__c from Device__c where id = :dev.Id];
        
        //system.assertEquals(dev.Pre_PTRF_Validation_Status__c,'Not Pre-PTRF Ready');
        
        //system.assert(dev.Tapeout_Readiness_Validation_Error__c.contains('Assigned Pid Lifecycle (PLM) Status should be either in Prototype Ready, MPW Ready or Available.'));
        //system.assert(dev.Tapeout_Readiness_Validation_Error__c.contains('Assigned Process Id (PI/YE) should not be Pending EOL, EOL or null.'));
        //system.assert(dev.Tapeout_Readiness_Validation_Error__c.contains('MPW Train Number is required'));        
        
        Test.stopTest();
    }        
    
    static testMethod void deviceTapeoutReadStatusTest3() {
             
        // Data creation
        User admin = DeviceChecklistTestDataUtils.createUserWithDCAdmin('System Administrator');
        String acctId;
        String oppId;
        String oppProgId;
        Process__c p;
        System.runAs(admin){
            IntegrationUsers__c skipUser = new IntegrationUsers__c(SetupOwnerId = admin.Id, Is_Integration_User__c= true, Skip_Trigger__c = true, Skip_Validation_Rule__c = true);
            insert skipUser;
            User user = DeviceTapeoutReadStatus_Test.createUser();
            acctId = getAccount('MYTEST ACCOUNT1').id;
            oppId = DeviceTapeoutReadStatus_Test.createOpp(acctId);
            oppProgId = DeviceTapeoutReadStatus_Test.createOppProg(acctId, oppId);
            Opportunity_Program_Team_Member__c oppProgTM = DeviceTapeoutReadStatus_Test.createOppProgTmMem(oppProgId, user.id);
            p = DeviceTapeoutReadStatus_Test.createProcess1();
            //Device__c dev = DeviceTapeoutReadStatus_Test.createDevice1(acctId,oppId,oppProgId,p.Id);
           // Device__c dev = DeviceUtilTest.createGlobalShuttleMPWDevice2(acctId,oppId,oppProgId,p.Id);
        
        Test.startTest();
        Device__c dev = DeviceUtilTest.createCMPWDevice(acctId,oppProgId);
        Insert dev;
        //String MSTId = DeviceUtilTest.createMaskSetTtitle();
        //string MSTAccId = DeviceUtilTest.createMSTAccount(acctId,MSTId);
       // Device__c baseDeviceId = DeviceUtilTest.createSPDevice(acctId,oppProgId);
        //Insert baseDeviceId;
        
        New_Part_Creation_Form__c newPart = DeviceTapeoutReadStatus_Test.createNewPartCreateForm(dev.Id, acctId);
        //Device__c dev1 = DeviceTapeoutReadStatus_Test.createDevice2(acctId,oppId,oppProgId,p.Id,newPart.Id);
        dev.NPC_Form__c = newPart.Id;
        dev.Device_Mask_Set_Title__c = null;
        dev.Reticle_Type__c = null;
        update dev;      
        
        //Device__c dev1 = DeviceTapeoutReadStatus_Test.createDevice2(acctId,oppId,oppProgId,p.Id,null);
        Device__c dev1 = DeviceUtilTest.createGlobalShuttleMPWDevice3(acctId,oppId,oppProgId,p.Id,null);
        
     
        dev1 = [select Pre_PTRF_Validation_Status__c, Tapeout_Readiness_Validation_Error__c from Device__c where id = :dev1.Id];
        
        //system.assertEquals(dev1.Pre_PTRF_Validation_Status__c,'Not Pre-PTRF Ready');     
        
        Test.stopTest();
        }

    }
       public static Device__c createSPDevice(Id acctId,Id opptyProgramId) {
        
        // Create Device
        Device__c device = new Device__c();
       
        device.Account__c = acctId;
        device.Name = 'TESTDEVICEZAIH12345677';
        device.Opportunity_Program__c = opptyProgramId ;
        device.Fab__c = 'FAB 2';
        device.GSOP_Assignment_Tapeout_Plan__c = 'No';
        device.Market_Segment__c = 'Automotive';
        device.Semiconductor_Device__c = 'Analog Amplifier';
        device.End_Customer__c = 'Test Customer';
        device.Device_Sourcing__c = '1st Source';
        device.Stage__c = 'Design In';
        device.Status__c = 'Active';
        device.Siebel_Device_ID__c = '1234567890';
        device.Tapeout_Type__c = 'Single Product';
        device.Confidence_Level_Tapeout__c = '50';
        device.PLM_Device_ID__c = 'ANBQP60ACO8CH-U01';
        device.Device_Mask_Set_Title__c = 'MSTTRT2';
        device.CRMDID__c = 'CDID0000001.00';
        device.Device_Type__c = 'Base';
        device.reticle_type__c = 'Small Field Reticle (SFR)';
        device.End_Application__c = 'Body';
        
        
        return device;
    }
     public static Id createMaskSetTtitle(){
        Mask_Set_Title__c mst = new Mask_Set_Title__c();
        mst.Name = 'MSTTRT';
        mst.Reticle_Type__c = 'Multi Layer Reticle (MLR)';
        insert mst;
        return mst.Id;
    }
      public static Id createMSTAccount(Id acctId, Id MSTId){
        MSTAccount__c mstAcc = new MSTAccount__c();
        mstAcc.Account__c = acctId;
        mstAcc.Mask_Set_Title__c = MSTId;
        insert mstAcc;
        return mstAcc.Id;
    }
    
    
      static testMethod void deviceTapeoutReadStatusTest7() {
             
        // Data creation
        User admin = DeviceChecklistTestDataUtils.createUserWithDCAdmin('System Administrator');
        String acctId;
        String oppId;
        String oppProgId;
        Process__c p;
        System.runAs(admin){
            IntegrationUsers__c skipUser = new IntegrationUsers__c(SetupOwnerId = admin.Id, Is_Integration_User__c= true, Skip_Trigger__c = true, Skip_Validation_Rule__c = true);
            insert skipUser;
            User user = DeviceTapeoutReadStatus_Test.createUser();
            acctId = getAccount('MYTEST ACCOUNT1').id;
            oppId = DeviceTapeoutReadStatus_Test.createOpp(acctId);
            oppProgId = DeviceTapeoutReadStatus_Test.createOppProg(acctId, oppId);
            Opportunity_Program_Team_Member__c oppProgTM = DeviceTapeoutReadStatus_Test.createOppProgTmMem(oppProgId, user.id);
            p = DeviceTapeoutReadStatus_Test.createProcess1();
                 
        } 
        
        Test.startTest();
        Device__c dev = DeviceTapeoutReadStatus_Test.createSPDevice(acctId,oppProgId);
        Insert dev;
       
        
       
        dev.Export_Control_Status__c = 'Approved' ;
        dev.Generate_Standard_Frame__c = 'Yes';
        dev.Original_Forecasted_Tapeout_Date__c = System.today();          
        dev.Enabled_via_previous_MPW_1__c = 'No';
       
        update dev;      

        Device__c dev1 = DeviceUtilTest.createGlobalShuttleMPWDevice3(acctId,oppId,oppProgId,p.Id,null);
        
     
        dev1 = [select Pre_PTRF_Validation_Status__c, Tapeout_Readiness_Validation_Error__c from Device__c where id = :dev1.Id];
        
        //system.assertEquals(dev1.Pre_PTRF_Validation_Status__c,'Not Pre-PTRF Ready');     
        
        Test.stopTest();
    }
    
       /*static testMethod void deviceTapeoutReadStatusTest4() {
             
        // Data creation
        User user = DeviceTapeoutReadStatus_Test.createUser();
        String acctId = getAccount('MYTEST ACCOUNT1').id;
        Test.startTest();
        String oppId = DeviceTapeoutReadStatus_Test.createOpp(acctId);
        String oppProgId = DeviceTapeoutReadStatus_Test.createOppProg(acctId, oppId);
        Opportunity_Program_Team_Member__c oppProgTM = DeviceTapeoutReadStatus_Test.createOppProgTmMem(oppProgId, user.id);
        Process__c p = DeviceTapeoutReadStatus_Test.createProcess1();
    
        Device__c dev = DeviceUtilTest.createCMPWDevice(acctId,oppProgId);
        Insert dev ;
        
        Apttus_Proposal__Proposal__c prop = createProposal(acctId,dev.Id);
        //Device__c dev = DeviceUtilTest.createGlobalShuttleMPWDevice2(acctId,oppId,oppProgId,p.Id);
        //String MSTId = DeviceUtilTest.createMaskSetTtitle();
        //string MSTAccId = DeviceUtilTest.createMSTAccount(acctId,MSTId);
        //Device__c baseDeviceId = DeviceUtilTest.createSPDevice(acctId,oppProgId);
        //Insert baseDeviceId;
        dev = [select Pre_PTRF_Validation_Status__c, Tapeout_Readiness_Validation_Error__c from Device__c where id = :dev.Id];
        
        //system.assertEquals(dev.Pre_PTRF_Validation_Status__c,'Not Pre-PTRF Ready');
        
        //system.assert(dev.Tapeout_Readiness_Validation_Error__c.contains('Assigned Pid Lifecycle (PLM) Status should be either in Prototype Ready, MPW Ready or Available.'));
        //system.assert(dev.Tapeout_Readiness_Validation_Error__c.contains('Assigned Process Id (PI/YE) should not be Pending EOL, EOL or null.'));
        //system.assert(dev.Tapeout_Readiness_Validation_Error__c.contains('MPW Train Number is required'));        
        
        Test.stopTest();
    }*/
    
    static testMethod void deviceTapeoutReadStatusTest5() {
        
        Test.startTest();
        // Data creation
        User user = DeviceTapeoutReadStatus_Test.createUser();
         String acctId = getAccount('MYTEST ACCOUNT1').id;
        //String acctId = getAccount('MYTEST ACCOUNT1').id;
        String oppId = DeviceTapeoutReadStatus_Test.createOpp(acctId);
        String oppProgId = DeviceTapeoutReadStatus_Test.createOppProg(acctId, oppId);
        Opportunity_Program_Team_Member__c oppProgTM = DeviceTapeoutReadStatus_Test.createOppProgTmMem(oppProgId, user.id);
        Process__c p = DeviceTapeoutReadStatus_Test.createProcess1();
        Device__c dev = DeviceUtilTest.createCMPWDevice(acctId,oppProgId);
        dev.Tapeout_Type__c = 'Single Product' ;
        dev.Export_Control_Status__c = 'Approved' ;
        dev.Device_Mask_Set_Title__c = 'test5';
        Insert dev ;        
       
        dev = [select Pre_PTRF_Validation_Status__c, Tapeout_Readiness_Validation_Error__c from Device__c where id = :dev.Id];
      
        //system.assertEquals(dev.Pre_PTRF_Validation_Status__c,'Not Pre-PTRF Ready');
        
       
        
        Test.stopTest();
    }        
    static testMethod void deviceTapeoutReadStatusTest6() {
        
        Test.startTest();
        // Data creation
        User user = DeviceTapeoutReadStatus_Test.createUser();
         String acctId = getAccount('MYTEST ACCOUNT1').id;
        //String acctId = getAccount('MYTEST ACCOUNT1').id;
        String oppId = DeviceTapeoutReadStatus_Test.createOpp(acctId);
        String oppProgId = DeviceTapeoutReadStatus_Test.createOppProg(acctId, oppId);
        Opportunity_Program_Team_Member__c oppProgTM = DeviceTapeoutReadStatus_Test.createOppProgTmMem(oppProgId, user.id);
        Process__c p = DeviceTapeoutReadStatus_Test.createProcess1();
        Device__c dev = DeviceUtilTest.createCMPWDevice(acctId,oppProgId);
        dev.Tapeout_Type__c = 'Single Product' ;
        dev.Export_Control_Status__c = 'Pending' ;
        dev.Device_Mask_Set_Title__c = 'test6';
        Insert dev ;        
       
        dev = [select Pre_PTRF_Validation_Status__c, Tapeout_Readiness_Validation_Error__c from Device__c where id = :dev.Id];
        
        //system.assertEquals(dev.Pre_PTRF_Validation_Status__c,'Not Pre-PTRF Ready'); 
              
        Test.stopTest();
    }       
     
    
    //test method for Internal Device
    static testMethod void testDevErrorHandling1(){
        List<RecordType> recordTypeList = [Select Id from RecordType where sObjectType ='Account' and developerName = 'GLOBALFOUNDRIES_Internal'];

        Account account = InternalDeviceTestUtil.createAccount('Test Account1', 'Qualified', 'TestAccount1', 'Site', 'Direct', 'transactional', 'Fabless - Emerging',
                                             'Mature (> 0.11um)', 'APJ', 'APJ-FE-CHINA', 'APJ-China', 'APJ-China', true, '50 water', 'Bijing', 'China',  '50', 'GF Investment LLC OU', 
                                             100);
                                        
        if(!recordTypeList.isEmpty()){                      
            account.RecordTypeId = recordTypeList[0].Id;
        }
        //insert account;
        String oppId = DeviceTapeoutReadStatus_Test.createOpp(account.Id);
        String oppProgId = DeviceTapeoutReadStatus_Test.createOppProg(account.Id, oppId);

        Test.startTest();
        
            Id mskSetId = DeviceUtilTest.createMaskSetTtitle();
            Id mstAcctId = DeviceUtilTest.createMSTAccount(account.Id,mskSetId);        
            List<RecordType> deviceRecTypeList = [Select Id from RecordType where sObjectType ='Device__c' and developerName = 'Internal_Device'];
            Device__c device = DeviceUtilTest.createCustomerMPWDevice4(account.Id,oppProgId);
            /*InternalDeviceTestUtil.createDevice('TestInternalDevice', 'Fab 2', 'Design In', 'Active', '100', System.today(), 
                                                                        '1234567890', 'Single Product',  account.Id, '0.028UM', 'Super Low Power');*/
           if(!deviceRecTypeList.isEmpty()){                       
                device.RecordTypeId = deviceRecTypeList[0].Id;
            }
            device.Opportunity2__c = oppId;
           // device.Device_Mask_Set_Title__c ='MSTTRT1';
            Device.reticle_type__c ='Multi Layer Reticle (MLR)';
            insert device;
        Test.stopTest();
    }
    
    //test method for Internal Device
    static testMethod void testDevErrorHandling2(){
        List<RecordType> recordTypeList = [Select Id from RecordType where sObjectType ='Account' and developerName = 'GLOBALFOUNDRIES_Internal'];

        Account account = InternalDeviceTestUtil.createAccount('Test Account1', 'Qualified', 'TestAccount1', 'Site', 'Direct', 'transactional', 'Fabless - Emerging',
                                             'Mature (> 0.11um)', 'APJ', 'APJ-FE-CHINA', 'APJ-China', 'APJ-China', true, '50 water', 'Bijing', 'China',  '50', 'GF Investment LLC OU', 
                                             100);
                                        
        if(!recordTypeList.isEmpty()){                      
            account.RecordTypeId = recordTypeList[0].Id;
        }
        //insert account;
        
        String oppId = DeviceTapeoutReadStatus_Test.createOpp(account.Id);
        String oppProgId = DeviceTapeoutReadStatus_Test.createOppProg(account.Id, oppId);
        
        Test.startTest();
            Id mskSetId = DeviceUtilTest.createMaskSetTtitle();
            Id mstAcctId = DeviceUtilTest.createMSTAccount(account.Id,mskSetId);        
            List<RecordType> deviceRecTypeList = [Select Id from RecordType where sObjectType ='Device__c' and developerName = 'Internal_Device'];
            Device__c device = DeviceUtilTest.createCustomerMPWDevice4(account.Id,oppProgId);
            /*InternalDeviceTestUtil.createDevice('TestInternalDevice', 'Fab 2', 'Design In', 'Active', '100', System.today(), 
                                                                        '1234567890', 'Single Product',  account.Id, '0.028UM', 'Super Low Power');*/
            if(!deviceRecTypeList.isEmpty()){                       
                device.RecordTypeId = deviceRecTypeList[0].Id;
            }
            device.Opportunity2__c = oppId;
            //device.Device_Mask_Set_Title__c ='MSTTRT1';
            Device.reticle_type__c ='Multi Layer Reticle (MLR)';
            insert device;
            Process__c processObj = DeviceTapeoutReadStatus_Test.createProcess1();
            device.Assigned_Process_ID__c = processObj.Id;
            device.Enabled_via_previous_MPW_1__c = 'No';
            update device;
        Test.stopTest();
    }
    
    private static Account getAccount(string AccountName)
    {
        Account acct = [SELECT Id, Name FROM Account Where Name =: AccountName];
        
        return acct;
    }
}