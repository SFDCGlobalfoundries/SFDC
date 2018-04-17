@istest(seeAllData=false)
public with sharing class SFFGModule_Test{
    @testSetup static void testdata() {
        DataUtilTest.loadEnvironmentVariables();
    }
    
    public static Id createAccount() {
        // Create Account
        RecordType rt = [
            SELECT      Id
            FROM        RecordType
            WHERE       SObjectType = 'Account'
                        AND Name = 'Customer'
        ];
        
        Account testAcct = new Account();
        testAcct.Name = 'Test Account';
        testAcct.Stage__c = 'Unqualified';
        testAcct.Site_Department__c = 'Test Department';
        testAcct.Sub_Type__c = 'Direct';
        testAcct.Transaction_Type__c = 'Transactional';
        testAcct.Region__c = 'APJ';
        testAcct.Bill_To_Address_1__c = 'Test Address 1';
        testAcct.Corporate_Address_1__c = 'Corporate Address 1';
        testAcct.Bill_To_City__c = 'Test City';
        testAcct.Corporate_City__c = 'Test City';
        testAcct.Bill_To_Country__c = 'Singapore';
        testAcct.Corporate_Country__c = 'Singapore';
        testAcct.RecordTypeId = rt.Id;      
        testAcct.Short_Name__c = 'TestAcct';
        
        insert testAcct;
        return testAcct.Id;
    }
   
    public static Id createOpp(Id acctId, string processGeometry) {
        // Create Opportunity
        Opportunity testOppty = new Opportunity();
        testOppty.Name = 'Test Opportunity';
        testOppty.AccountId = acctId;
        testOppty.StageName = '1. Discovery';
        testOppty.CloseDate = Date.Today().addDays(10);
        testOppty.Target_Process_Node__c = '14XM';
        testOppty.Market_Segment__c = 'Mobility';
        testOppty.Process_Platform__c = 'GF Baseline';
        testOppty.Fab_Split__c = 100;
        testOppty.Process_Geometry__c = processGeometry; //'0.60UM'
        testOppty.Process_Family__c = 'Super Low Power';
        
        insert testOppty;
        return testOppty.Id;
    }
    public static Id createOpp2(Id acctId, string processGeometry) {
        // Create Opportunity
        Opportunity testOppty = new Opportunity();
        testOppty.Name = 'Test Opportunity';
        testOppty.AccountId = acctId;
        testOppty.StageName = '1. Discovery';
        testOppty.CloseDate = Date.Today().addDays(10);
        testOppty.Target_Process_Node__c = '14XM';
        testOppty.Market_Segment__c = 'Mobility';
        testOppty.Process_Platform__c = 'GF Baseline';
        testOppty.Fab_Split__c = 100;
        testOppty.Process_Geometry__c = '0.055UM'; //'0.60UM'
        testOppty.Process_Family__c = 'Super Low Power';
        
        insert testOppty;
        return testOppty.Id;
    }
    
    public static Id createOppProg(Id acctId,Id oppId) {
        // Create Opportunity Program
        Opportunity_Program__c testOpptyProgram = new Opportunity_Program__c();
        testOpptyProgram.Name = 'Test Opportunity Program';
        testOpptyProgram.Account__c = acctId;
        testOpptyProgram.Opportunity__c = oppId;
        
        insert testOpptyProgram;
        return testOpptyProgram.Id;
    }
    
    public static Id createMPWTrainMnt(){
        MPW_Train_Maintenance__c mtm = new MPW_Train_Maintenance__c();
        mtm.Name = 'MPWTEST';
        mtm.MPW_Train_No__c = 'MPWTEST';
        mtm.Delay__c = 5;
        mtm.Status__c = 'Test';
        insert mtm;
        return mtm.Id;
    }
    
    public static Id createMPW() {
        MPW_Train_Maintenance__c m = new MPW_Train_Maintenance__c();
        m.Name = 'TestMPW';
        m.Customer_Tapeout_Date__c = date.newInstance(2013,5,20);
        m.Other_Tapeout_Date__c = date.newInstance(2013,5,20);
        m.MPW_Train_No__c = 'testMpwTrainNo123';
        
        insert m;
        return m.Id;
    }
    public static Id createMaskSetTtitle(){
        Mask_Set_Title__c mst = new Mask_Set_Title__c();
        mst.Name = 'MSTTRT';
        mst.Reticle_Type__c = 'Multi Layer Reticle (MLR)';
        insert mst;
        return mst.Id;
    }
    public static Id createMaskSetTtitleMPW(){
        Mask_Set_Title__c mst = new Mask_Set_Title__c();
        mst.Name = 'MPW13';
        mst.Manual_Creation__c =False;
        mst.Reticle_Type__c = 'Multi Layer Reticle (MLR)';
        insert mst;
        return mst.Id;
    }
    public static Mask_Set_Title__c createMaskSetTtitleObj(String mstname){
        Mask_Set_Title__c mst = new Mask_Set_Title__c();
        mst.Name = mstname;
        mst.Reticle_Type__c = 'Multi Layer Reticle (MLR)';
        insert mst;
        return mst;
    }
    Public static Mask_Set_Title__c createMaskSetTitle1(String name, Boolean isAvailableForUse, String status){
       Mask_Set_Title__c Maskst = new Mask_Set_Title__c(Name = name, Is_Available_For_Use__c = isAvailableForUse, Status__c = status,Reticle_Type__c = 'Multi Layer Reticle (MLR)');
       insert Maskst ;
       return Maskst ;
    }
    public static Id createMSTAccount(Id acctId, Id MSTId){
        MSTAccount__c mstAcc = new MSTAccount__c();
        mstAcc.Account__c = acctId;
        mstAcc.Mask_Set_Title__c = MSTId;
        insert mstAcc;
        return mstAcc.Id;
    }
    
    public static id createProcess(string processGeometry){
        Process__c pros = new Process__c();
        pros.Process_Family__c = 'Super Low Power';
        pros.Tech_Geometry__c = processGeometry;
        pros.Available_to_Sell__c = 'Available';
        pros.Process_Technology__c = 'test123';
        pros.Generation_Rule_Spec__c='GR123';
        insert pros;      
        return pros.id;
    }
    
    public static id createProcessTechnology() {
        Process_Technology__c pt = new Process_Technology__c();
        pt.Name = 'test';
        pt.IP_Geometry_Technology__c = 'test';
        pt.PT_Number__c = 'test123';
        insert pt;      
        return pt.id;
    }
    
    public static void insertLGConfig(){
        List<SFFG_LG_Configuration__c> lgList=new List<SFFG_LG_Configuration__c>();
        SFFG_LG_Configuration__c lg=new SFFG_LG_Configuration__c();
        lg.Status__c='Active';
        lg.Spec_Config_Table_ID__c='GR123';
        lg.Revision__c=2;
        lg.Configuration_Type__c='Test1';
        lg.Configuration_Option__c='Yes';
        lgList.add(lg);
        
        SFFG_LG_Configuration__c lg2=new SFFG_LG_Configuration__c();
        lg2.Status__c='Active';
        lg2.Spec_Config_Table_ID__c='GR123';
        lg2.Revision__c=2;
        lg2.Configuration_Type__c='Test1';
        lg2.Configuration_Option__c='No';
        lgList.add(lg2);
        
        SFFG_LG_Configuration__c lg3=new SFFG_LG_Configuration__c();
        lg3.Status__c='Active';
        lg3.Spec_Config_Table_ID__c='GR123';
        lg3.Revision__c=2;
        lg3.Configuration_Type__c='Test2';
        lg3.Configuration_Option__c='Yes';
        lgList.add(lg3);
        
        SFFG_LG_Configuration__c lg4=new SFFG_LG_Configuration__c();
        lg4.Status__c='Active';
        lg4.Spec_Config_Table_ID__c='GR123';
        lg4.Revision__c=2;
        lg4.Configuration_Type__c='Test2';
        lg4.Configuration_Option__c='No';
        lgList.add(lg4);
        
        insert lgList;
        
    }
    
    public static Device__c createSingleProductDevice() {
       
        string acctId = SFFGModule_Test.createAccount();
        string opptyId = SFFGModule_Test.createOpp(acctId, '0.10UM');
        string opptyProgramId = SFFGModule_Test.createOppProg(acctId, opptyId);
        string processId = SFFGModule_Test.createProcess('0.10UM');
        string processTechnologyId = SFFGModule_Test.createProcessTechnology();
        
            // Create Device
            Device__c device = new Device__c();
            device.Name = 'TESTDEVICESP';
            device.Account__c = acctId;
            device.Opportunity2__c = opptyId;
            device.Opportunity_Program__c = opptyProgramId;
            device.Fab__c = 'FAB 2';
            device.GSOP_Assignment_Tapeout_Plan__c = 'No';
            device.Market_Segment__c = 'Automotive';
            device.Semiconductor_Device__c = 'Analog Amplifier';
            device.End_Customer__c = 'Test Customer';
            device.Device_Sourcing__c = '1st Source';
            device.Stage__c = 'Design In';
            device.Status__c = 'Active';
            device.Tapeout_Type__c = 'Single Product';
            device.PLM_Device_ID__c = 'ANBQP60ACO8CH-U01';
            device.Device_Mask_Set_Title__c = 'MSTSP';
            device.Actual_Tapeout_Date__c = datetime.now();
            device.Process_Family_Filter__c = 'Super Low Power';
            device.Assigned_Process_ID__c = processId;
            device.reticle_type__c = 'Single Layer Reticle (SLR)';
            device.Geometry_Filter__c = '0.10UM';
            device.Confidence_Level_Tapeout__c = '100';
            device.End_Application__c = 'Powertrain';
            device.Original_Forecasted_Tapeout_Date__c = date.today();
            device.PTRF_ID__c = 'test';
            device.Automotive_Grade__c='Grade 0';
            device.Process_Technology_2__c = processTechnologyId;
            device.End_Application__c = 'Body';
            device.Generate_Standard_Frame__c='Yes';
            device.Enabled_via_previous_MPW_1__c='No';
            device.BX041_Status__c='Closed';
            device.Secure_Device__c ='Yes';
            device.Automotive_Device__c ='Yes';
            device.BX041_Submission_Date__c=system.today();
            device.Current_Forecast_Tapeout_Date__c=system.today();
            device.Customer_Tapeout_Date__c=system.today();
            device.Export_Control_Status__c='Approved';
            device.Export_Control_Form_Submitted_Date__c=system.today();
            device.IP_Declaration_Status__c='Approved';
            device.MS_SFDC_Synch_Time__c=string.valueof(system.now());
            device.IP_Declaration_Submitted_Date__c=system.today();
            Test.StartTest();
            insert device;
             system.debug('---device---'+device);
             Test.StopTest();
            return device;
    }
    
     public static Device__c createSingleProductDevice_1() {
       
        string acctId = SFFGModule_Test.createAccount();
        string opptyId = SFFGModule_Test.createOpp(acctId, '0.10UM');
        string opptyProgramId = SFFGModule_Test.createOppProg(acctId, opptyId);
        string processId = SFFGModule_Test.createProcess('0.10UM');
        string processTechnologyId = SFFGModule_Test.createProcessTechnology();
        
            // Create Device
            Device__c device = new Device__c();
            device.Name = 'TESTYASH';
            device.Account__c = acctId;
            device.Opportunity2__c = opptyId;
            device.Opportunity_Program__c = opptyProgramId;
            device.Fab__c = 'FAB 2';
            device.GSOP_Assignment_Tapeout_Plan__c = 'No';
            device.Market_Segment__c = 'Automotive';
            device.Semiconductor_Device__c = 'Analog Amplifier';
            device.End_Customer__c = 'Test Customer';
            device.Device_Sourcing__c = '1st Source';
            device.Stage__c = 'Design In';
            device.Status__c = 'Active';
            device.Tapeout_Type__c = 'Single Product';
            device.PLM_Device_ID__c = 'ANBQP60ACO8CH-U01';
            device.Device_Mask_Set_Title__c = 'MSTSP';
            device.Actual_Tapeout_Date__c = datetime.now();
            device.Process_Family_Filter__c = 'Super Low Power';
            device.Assigned_Process_ID__c = processId;
            device.reticle_type__c = 'Single Layer Reticle (SLR)';
            device.Geometry_Filter__c = '0.10UM';
            device.Confidence_Level_Tapeout__c = '100';
            device.End_Application__c = 'Powertrain';
            device.Original_Forecasted_Tapeout_Date__c = date.today();
            device.PTRF_ID__c = 'test';
            device.Automotive_Grade__c='Grade 0';
            device.Process_Technology_2__c = processTechnologyId;
            device.End_Application__c = 'Body';
            device.Generate_Standard_Frame__c='Yes';
            device.Enabled_via_previous_MPW_1__c='No';
            device.BX041_Status__c='Closed';
            device.Secure_Device__c ='Yes';
            device.Automotive_Device__c ='Yes';
            device.BX041_Submission_Date__c=system.today();
            device.Current_Forecast_Tapeout_Date__c=system.today();
            device.Customer_Tapeout_Date__c=system.today();
            device.Export_Control_Status__c='Approved';
            device.Export_Control_Form_Submitted_Date__c=system.today();
            device.IP_Declaration_Status__c='Approved';
            device.MS_SFDC_Synch_Time__c=string.valueof(system.now());
            device.IP_Declaration_Submitted_Date__c=system.today();
            device.CRMDID__c='CDID0023352.00';
            Test.StartTest();
            insert device; 
             system.debug('---device---'+device);
             Test.StopTest();
            return device;
    }
    
    public static Device__c createSingleProductDeviceFail() {
       
        string acctId = SFFGModule_Test.createAccount();
        string opptyId = SFFGModule_Test.createOpp(acctId, '0.10UM');
        string opptyProgramId = SFFGModule_Test.createOppProg(acctId, opptyId);
        string processId = SFFGModule_Test.createProcess('0.10UM');
        string processTechnologyId = SFFGModule_Test.createProcessTechnology();
        
            // Create Device
            Device__c device = new Device__c();
            device.Name = 'TESTDEVICESP';
            device.Account__c = acctId;
            device.Opportunity2__c = opptyId;
            device.Opportunity_Program__c = opptyProgramId;
            device.Fab__c = 'FAB 2';
            device.GSOP_Assignment_Tapeout_Plan__c = 'No';
            device.Market_Segment__c = 'Automotive';
            device.Semiconductor_Device__c = 'Analog Amplifier';
            device.End_Customer__c = 'Test Customer';
            device.Device_Sourcing__c = '1st Source';
            device.Stage__c = 'Tapeout';
            device.Status__c = 'Active';
            device.Tapeout_Type__c = 'Single Product';
            device.PLM_Device_ID__c = 'ANBQP60ACO8CH-U01';
            device.Device_Mask_Set_Title__c = 'MSTSP';
            device.Actual_Tapeout_Date__c = datetime.now();
            device.Process_Family_Filter__c = 'Super Low Power';
            device.Assigned_Process_ID__c = processId;
            device.reticle_type__c = 'Single Layer Reticle (SLR)';
            device.Geometry_Filter__c = '0.10UM';
            device.Confidence_Level_Tapeout__c = '100';
            device.End_Application__c = 'Powertrain';
            device.Original_Forecasted_Tapeout_Date__c = date.today();
            device.PTRF_ID__c = 'test';
            device.Process_Technology_2__c = processTechnologyId;
            device.End_Application__c = 'Body';
            device.Generate_Standard_Frame__c='Yes';
            device.Enabled_via_previous_MPW_1__c='No';
            device.BX041_Status__c='Closed';
            device.Secure_Device__c ='Yes';
            device.Automotive_Device__c ='Yes';
            device.Automotive_Grade__c='Grade 0';
            device.BX041_Submission_Date__c=system.today();
            device.Export_Control_Status__c='Approved';
            device.Export_Control_Form_Submitted_Date__c=system.today();
            device.IP_Declaration_Status__c='Approved';
            device.MS_SFDC_Synch_Time__c=string.valueof(system.now());
            device.IP_Declaration_Submitted_Date__c=system.today();
            insert device;
           
            return device;
    }
    
    
    public static Device__c createSingleProductDeviceFail2() {
       
        string acctId = SFFGModule_Test.createAccount();
        string opptyId = SFFGModule_Test.createOpp(acctId, '0.10UM');
        string opptyProgramId = SFFGModule_Test.createOppProg(acctId, opptyId);
        string processId = SFFGModule_Test.createProcess('0.10UM');
        string processTechnologyId = SFFGModule_Test.createProcessTechnology();
        
            // Create Device
            Device__c device = new Device__c();
            device.Name = 'TESTDEVICESP';
            device.Account__c = acctId;
            device.Opportunity2__c = opptyId;
            device.Opportunity_Program__c = opptyProgramId;
            device.Fab__c = 'FAB 2';
            device.GSOP_Assignment_Tapeout_Plan__c = 'No';
            device.Market_Segment__c = 'Automotive';
            device.Semiconductor_Device__c = 'Analog Amplifier';
            device.End_Customer__c = 'Test Customer';
            device.Device_Sourcing__c = '1st Source';
            device.Stage__c = 'Tapeout';
            device.Status__c = 'Active';
            device.Tapeout_Type__c = 'Single';
            device.PLM_Device_ID__c = 'ANBQP60ACO8CH-U01';
            device.Device_Mask_Set_Title__c = 'MSTSP';
            device.Actual_Tapeout_Date__c = datetime.now();
            device.Process_Family_Filter__c = 'Super Low Power';
            device.Assigned_Process_ID__c = processId;
            device.reticle_type__c = 'Single Layer Reticle';
            device.Geometry_Filter__c = '0.10UM';
            device.Confidence_Level_Tapeout__c = '100';
            device.Automotive_Grade__c='Grade 0';
            device.End_Application__c = 'Powertrain';
            device.Original_Forecasted_Tapeout_Date__c = date.today();
            device.PTRF_ID__c = 'test';
            device.Process_Technology_2__c = processTechnologyId;
            device.End_Application__c = 'Body';
            device.Generate_Standard_Frame__c='No';
            device.Enabled_via_previous_MPW_1__c='No';
            device.BX041_Status__c='Closed';
            
            device.Automotive_Device__c ='Yes';
            device.BX041_Submission_Date__c=system.today();
            device.Export_Control_Status__c='Approved';
            device.Export_Control_Form_Submitted_Date__c=system.today();
            device.IP_Declaration_Status__c='Approved';
            device.MS_SFDC_Synch_Time__c=string.valueof(system.now());
            device.IP_Declaration_Submitted_Date__c=system.today();
            insert device;
           
            return device;
    }
    
    
    public static Device__c createSingleProductDeviceNoProcess() {
       
        string acctId = SFFGModule_Test.createAccount();
        string opptyId = SFFGModule_Test.createOpp(acctId, '0.10UM');
        string opptyProgramId = SFFGModule_Test.createOppProg(acctId, opptyId);
        string processId = SFFGModule_Test.createProcess('0.10UM');
        string processTechnologyId = SFFGModule_Test.createProcessTechnology();
        
            // Create Device
            Device__c device = new Device__c();
            device.Name = 'TESTDEVICESP';
            device.Account__c = acctId;
            device.Opportunity2__c = opptyId;
            device.Opportunity_Program__c = opptyProgramId;
            device.Fab__c = 'FAB 2';
            device.GSOP_Assignment_Tapeout_Plan__c = 'No';
            device.Market_Segment__c = 'Automotive';
            device.Semiconductor_Device__c = 'Analog Amplifier';
            device.End_Customer__c = 'Test Customer';
            device.Device_Sourcing__c = '1st Source';
            device.Stage__c = 'Design In';
            device.Status__c = 'Active';
            device.Tapeout_Type__c = 'Single Product';
            device.PLM_Device_ID__c = 'ANBQP60ACO8CH-U01';
            device.Device_Mask_Set_Title__c = 'MSTSP';
            device.Actual_Tapeout_Date__c = datetime.now();
            device.Process_Family_Filter__c = 'Super Low Power';
             
            device.reticle_type__c = 'Single Layer Reticle (SLR)';
            device.Geometry_Filter__c = '0.10UM';
            device.Confidence_Level_Tapeout__c = '100';
            device.End_Application__c = 'Powertrain';
            device.Original_Forecasted_Tapeout_Date__c = date.today();
            device.PTRF_ID__c = 'test';
            device.Automotive_Grade__c='Grade 0';
             device.End_Application__c = 'Body';
            device.Generate_Standard_Frame__c='Yes';
            device.Enabled_via_previous_MPW_1__c='No';
            device.BX041_Status__c='Closed';
            device.Secure_Device__c ='Yes';
            device.Automotive_Device__c ='Yes';
            device.BX041_Submission_Date__c=system.today();
            device.Current_Forecast_Tapeout_Date__c=system.today();
            device.Customer_Tapeout_Date__c=system.today();
            device.Export_Control_Status__c='Approved';
            device.Export_Control_Form_Submitted_Date__c=system.today();
            device.IP_Declaration_Status__c='Approved';
            device.MS_SFDC_Synch_Time__c=string.valueof(system.now());
            device.IP_Declaration_Submitted_Date__c=system.today();
            insert device;
           device=[select id,Fab__c,CRMDID__c,lastmodifieddate,MS_SFDC_Synch_Time__c,Current_Forecast_Tapeout_Date__c,Name,Account_Short_Name__c,Account__c,Geometry__c,Assigned_Process_ID__c,
                            Assigned_Process_ID__r.Main_Generation_Rule_Spec__c,reticle_Type__c,Generate_Standard_Frame__c,Stage__c,Tapeout_Type__c,Pre_PTRF_Validation_Status__c,Assigned_Process_ID__r.Generation_Rule_Spec__c,systemmodstamp 
                             from device__c  limit 1];
                             
             system.debug('---device---'+device);
            return device;
    }
    
    @istest
    public  static void  sffgTest1(){
        insertLGConfig();
        // This causes a fake response to be generated
        Test.setMock(WebServiceMock.class, new SFFGWebServiceMockImpl_Test());
        //test.starttest();
        Device__c dev=createSingleProductDevice();
        //test.stoptest();
        PageReference pageRef = Page.SFFGFrameDetails;
        Test.setCurrentPage(pageRef);
        System.currentPageReference().getParameters().put('id', dev.Id);
        SFFG_CreatePrimeDieCtrl obj=new SFFG_CreatePrimeDieCtrl();
        SFFG_CreatePrimeDieCtrl.primeDieWrapper pdw=new SFFG_CreatePrimeDieCtrl.primeDieWrapper();
        SFFG_Prime_Die__c pd=new SFFG_Prime_Die__c();
        pd.Name='testD1';
        pd.Die_Anti_clock_wise_Rotation__c='90';
        pd.Foundry_to_Add_CrackStop__c='Yes';
        pd.Foundry_to_add_Guardring__c='No';
        pd.Size_X_um__c=5000;
        pd.Size_Y_um__c=5000;
        pdw.index=0;
        pdw.record=pd;
        obj.pdWrapList.remove(0);
        obj.pdWrapList.add(pdw);
        obj.Frame.Backgrind_Thickness__c='None';
        obj.Frame.LG_Configuration__c='Test1:Yes;Test2;No';
        obj.SaveMultiplePrimeDieData();
        obj.finalize();
    }
    
    @istest
    public  static void  sffgTest2(){
        Test.setMock(WebServiceMock.class, new SFFGWebServiceMockFailure_Test());
        //test.starttest();
        Device__c dev=createSingleProductDevice();
        //test.stoptest();
        PageReference pageRef = Page.SFFGFrameDetails;
        Test.setCurrentPage(pageRef);
        System.currentPageReference().getParameters().put('id', dev.Id);
        SFFG_CreatePrimeDieCtrl obj=new SFFG_CreatePrimeDieCtrl();
        SFFG_CreatePrimeDieCtrl.primeDieWrapper pdw=new SFFG_CreatePrimeDieCtrl.primeDieWrapper();
        SFFG_Prime_Die__c pd=new SFFG_Prime_Die__c();
        pd.Name='testD1';
        pd.Die_Anti_clock_wise_Rotation__c='90';
        pd.Foundry_to_Add_CrackStop__c='Yes';
        pd.Foundry_to_add_Guardring__c='No';
        pd.Size_X_um__c=5000;
        pd.Size_Y_um__c=5000;
        pdw.index=0;
        pdw.record=pd;
        obj.pdWrapList.remove(0);
        obj.pdWrapList.add(pdw);
        obj.Frame.Backgrind_Thickness__c='None';
        obj.Frame.LG_Configuration__c='Test1:Yes;Test2;No';
        obj.SaveandFinalize();
        SFFGTriggerPTRFCtrl.createPTRF(obj.Frame.id,Userinfo.getsessionId());

    }
    
    @istest
    public  static void  sffgTest5(){
        Test.setMock(WebServiceMock.class, new SFFGWebServiceMockFailure_Test());
        test.starttest();
        Device__c dev=createSingleProductDevicefAIL2();
        test.stoptest();
        PageReference pageRef = Page.SFFGFrameDetails;
        Test.setCurrentPage(pageRef);
        System.currentPageReference().getParameters().put('id', dev.Id);
        SFFG_CreatePrimeDieCtrl obj=new SFFG_CreatePrimeDieCtrl();
        SFFG_CreatePrimeDieCtrl.primeDieWrapper pdw=new SFFG_CreatePrimeDieCtrl.primeDieWrapper();
        SFFG_Prime_Die__c pd=new SFFG_Prime_Die__c();
        pd.Name='testD1';
        pd.Die_Anti_clock_wise_Rotation__c='90';
        pd.Foundry_to_Add_CrackStop__c='Yes';
        pd.Foundry_to_add_Guardring__c='No';
        pd.Size_X_um__c=5000;
        pd.Size_Y_um__c=5000;
        pdw.index=0;
        pdw.record=pd;
        obj.pdWrapList.remove(0);
        obj.pdWrapList.add(pdw);
        obj.Frame.Backgrind_Thickness__c='None';
        obj.Frame.LG_Configuration__c='Test1:Yes;Test2;No';
        obj.SaveandFinalize();
    }
    
    @istest
    public  static void  sffgTest4(){
        insertLGConfig();
        // This causes a fake response to be generated
        Test.setMock(WebServiceMock.class, new SFFGWebServiceMockImpl_Test());
        
        string acctId = SFFGModule_Test.createAccount();
        string opptyId = SFFGModule_Test.createOpp(acctId, '0.10UM');
        string opptyProgramId = SFFGModule_Test.createOppProg(acctId, opptyId);
        string processId = SFFGModule_Test.createProcess('0.10UM');
        string processTechnologyId = SFFGModule_Test.createProcessTechnology();
        
        test.starttest();
        
        // Create Device
        Device__c device = new Device__c();
        device.Name = 'TESTDEVICESP';
        device.Account__c = acctId;
        device.Opportunity2__c = opptyId;
        device.Opportunity_Program__c = opptyProgramId;
        device.Fab__c = 'FAB 2';
        device.GSOP_Assignment_Tapeout_Plan__c = 'No';
        device.Market_Segment__c = 'Automotive';
        device.Semiconductor_Device__c = 'Analog Amplifier';
        device.End_Customer__c = 'Test Customer';
        device.Device_Sourcing__c = '1st Source';
        device.Stage__c = 'Design In';
        device.Status__c = 'Active';
        device.Tapeout_Type__c = 'Single Product';
        device.PLM_Device_ID__c = 'ANBQP60ACO8CH-U01';
        device.Device_Mask_Set_Title__c = 'MSTSP';
        device.Actual_Tapeout_Date__c = datetime.now();
        device.Process_Family_Filter__c = 'Super Low Power';
        device.Assigned_Process_ID__c = processId;
        device.reticle_type__c = 'Single Layer Reticle (SLR)';
        device.Geometry_Filter__c = '0.10UM';
        device.Confidence_Level_Tapeout__c = '100';
        device.End_Application__c = 'Powertrain';
        device.Original_Forecasted_Tapeout_Date__c = date.today();
        device.PTRF_ID__c = 'test';
        device.Automotive_Grade__c='Grade 0';
        device.Process_Technology_2__c = processTechnologyId;
        device.End_Application__c = 'Body';
        device.Generate_Standard_Frame__c='Yes';
        device.Enabled_via_previous_MPW_1__c='No';
        device.BX041_Status__c='Closed';
        device.Secure_Device__c ='Yes';
        device.Automotive_Device__c ='Yes';
        device.BX041_Submission_Date__c=system.today();
        device.Current_Forecast_Tapeout_Date__c=system.today();
        device.Customer_Tapeout_Date__c=system.today();
        device.Export_Control_Status__c='Approved';
        device.Export_Control_Form_Submitted_Date__c=system.today();
        device.IP_Declaration_Status__c='Approved';
        device.MS_SFDC_Synch_Time__c=string.valueof(system.now());
        device.IP_Declaration_Submitted_Date__c=system.today();
        insert device;
       device=[select id,Fab__c,CRMDID__c,lastmodifieddate,MS_SFDC_Synch_Time__c,Current_Forecast_Tapeout_Date__c,Name,Account_Short_Name__c,Account__c,Geometry__c,Assigned_Process_ID__c,
                        Assigned_Process_ID__r.Main_Generation_Rule_Spec__c,reticle_Type__c,Generate_Standard_Frame__c,Stage__c,Tapeout_Type__c,Pre_PTRF_Validation_Status__c,Assigned_Process_ID__r.Generation_Rule_Spec__c,systemmodstamp 
                         from device__c  limit 1];
                         
        //Device__c dev=createSingleProductDevice();
        Device__c dev = device;
        
        PageReference pageRef = Page.SFFGFrameDetails;
        Test.setCurrentPage(pageRef);
        System.currentPageReference().getParameters().put('id', dev.Id);
        SFFG_CreatePrimeDieCtrl obj=new SFFG_CreatePrimeDieCtrl();
        SFFG_CreatePrimeDieCtrl.primeDieWrapper pdw=new SFFG_CreatePrimeDieCtrl.primeDieWrapper();
        SFFG_Prime_Die__c pd=new SFFG_Prime_Die__c();
        pd.Name='testD1';
        pd.Die_Anti_clock_wise_Rotation__c='90';
        pd.Foundry_to_Add_CrackStop__c='Yes';
        pd.Foundry_to_add_Guardring__c='No';
        pd.Size_X_um__c=5000;
        pd.Size_Y_um__c=5000;
        pdw.index=0;
        pdw.record=pd;
        obj.pdWrapList.remove(0);
        test.stoptest();
        obj.pdWrapList.add(pdw);
        obj.Frame.Backgrind_Thickness__c='None';
        obj.Frame.LG_Configuration__c='Test1:Yes;Test2;No';
        obj.SaveMultiplePrimeDieData();
       
        list<user> ulist = [select id from user where isactive = true and profile.UserType = 'Standard' and id != :UserInfo.getUserId() limit 4];
        Account_Team_Proxy__c atp1 = new Account_Team_Proxy__c(User__c = ulist[0].id,Account__c=dev.Account__c,Account_Access__c='Read/Write',Opportunity_Access__c='Read/Write',Team_Role__c='Backup Customer Service Rep',Sequence_No__c='1',Account_Role_ID__c='test');
        Account_Team_Proxy__c atp2 = new Account_Team_Proxy__c(User__c = ulist[1].id,Account__c=dev.Account__c,Account_Access__c='Read/Write',Opportunity_Access__c='Read/Write',Team_Role__c='Primary Customer Service Rep',Sequence_No__c='1',Account_Role_ID__c='test');
        Account_Team_Proxy__c atp3 = new Account_Team_Proxy__c(User__c = ulist[2].id,Account__c=dev.Account__c,Account_Access__c='Read/Write',Opportunity_Access__c='Read/Write',Team_Role__c='Primary Field Application Engineer',Sequence_No__c='1',Account_Role_ID__c='test');
         AccountTriggerRun.skipATPValidation = true;
         IntegrationUserUtil.isSkipTrigger();
         
         insert new list<Account_Team_Proxy__c>{atp1, atp2, atp3};
        obj.Frame.SWIFT_PTRF_ID__c='123456';
        obj.finalize();
    }
    
    
    @istest
    public  static void  sffgTest8(){
        insertLGConfig();
        // This causes a fake response to be generated
        Test.setMock(WebServiceMock.class, new SFFGWebServiceMockImpl_Test());
        
        Device__c dev=createSingleProductDeviceNoProcess();
        test.starttest();
        PageReference pageRef = Page.SFFGFrameDetails;
        Test.setCurrentPage(pageRef);
        System.currentPageReference().getParameters().put('id', dev.Id);
        SFFG_CreatePrimeDieCtrl obj=new SFFG_CreatePrimeDieCtrl();
        SFFG_CreatePrimeDieCtrl.primeDieWrapper pdw=new SFFG_CreatePrimeDieCtrl.primeDieWrapper();
        SFFG_Prime_Die__c pd=new SFFG_Prime_Die__c();
        pd.Name='tes@tD1';
        pd.Die_Anti_clock_wise_Rotation__c='90';
        pd.Foundry_to_Add_CrackStop__c=null;
        pd.Foundry_to_add_Guardring__c=null;
        pd.Size_X_um__c=-1;
        pd.Size_Y_um__c=5000;
        pdw.index=0;
        pdw.record=pd;
        obj.pdWrapList.remove(0);
        obj.pdWrapList.add(pdw);
        obj.Frame.Backgrind_Thickness__c='None';
        obj.Frame.LG_Configuration__c='Test1:Yes;Test2;No';
        obj.SaveMultiplePrimeDieData();
       test.stoptest();
        
       
    }
    
    
    @istest
    public  static void  sffgTest3(){
        insertLGConfig();
        // This causes a fake response to be generated
        Test.setMock(WebServiceMock.class, new SFFGWebServiceMockImpl_Test());
        
        string acctId = SFFGModule_Test.createAccount();
        string opptyId = SFFGModule_Test.createOpp(acctId, '0.10UM');
        string opptyProgramId = SFFGModule_Test.createOppProg(acctId, opptyId);
        string processId = SFFGModule_Test.createProcess('0.10UM');
        string processTechnologyId = SFFGModule_Test.createProcessTechnology();
        
        test.starttest();  
        
        Device__c device = new Device__c();
        device.Name = 'TESTDEVICESP';
        device.Account__c = acctId;
        device.Opportunity2__c = opptyId;
        device.Opportunity_Program__c = opptyProgramId;
        device.Fab__c = 'FAB 2';
        device.GSOP_Assignment_Tapeout_Plan__c = 'No';
        device.Market_Segment__c = 'Automotive';
        device.Semiconductor_Device__c = 'Analog Amplifier';
        device.End_Customer__c = 'Test Customer';
        device.Device_Sourcing__c = '1st Source';
        device.Stage__c = 'Tapeout';
        device.Status__c = 'Active';
        device.Tapeout_Type__c = 'Single Product';
        device.PLM_Device_ID__c = 'ANBQP60ACO8CH-U01';
        device.Device_Mask_Set_Title__c = 'MSTSP';
        device.Actual_Tapeout_Date__c = datetime.now();
        device.Process_Family_Filter__c = 'Super Low Power';
        device.Assigned_Process_ID__c = processId;
        device.reticle_type__c = 'Single Layer Reticle (SLR)';
        device.Geometry_Filter__c = '0.10UM';
        device.Confidence_Level_Tapeout__c = '100';
        device.End_Application__c = 'Powertrain';
        device.Original_Forecasted_Tapeout_Date__c = date.today();
        device.PTRF_ID__c = 'test';
        device.Process_Technology_2__c = processTechnologyId;
        device.End_Application__c = 'Body';
        device.Generate_Standard_Frame__c='Yes';
        device.Enabled_via_previous_MPW_1__c='No';
        device.BX041_Status__c='Closed';
        device.Secure_Device__c ='Yes';
        device.Automotive_Device__c ='Yes';
        device.Automotive_Grade__c='Grade 0';
        device.BX041_Submission_Date__c=system.today();
        device.Export_Control_Status__c='Approved';
        device.Export_Control_Form_Submitted_Date__c=system.today();
        device.IP_Declaration_Status__c='Approved';
        device.MS_SFDC_Synch_Time__c=string.valueof(system.now());
        device.IP_Declaration_Submitted_Date__c=system.today();
        insert device;
            
        //Device__c dev=createSingleProductDeviceFail();
        Test.stoptest();
        
        PageReference pageRef = Page.SFFGFrameDetails;
        Test.setCurrentPage(pageRef);
        System.currentPageReference().getParameters().put('id', device.Id);
        SFFG_CreatePrimeDieCtrl obj=new SFFG_CreatePrimeDieCtrl();
        SFFG_CreatePrimeDieCtrl.primeDieWrapper pdw=new SFFG_CreatePrimeDieCtrl.primeDieWrapper();
        SFFG_Prime_Die__c pd=new SFFG_Prime_Die__c();
        pd.Name='testD1';
        pd.Die_Anti_clock_wise_Rotation__c='90';
        pd.Foundry_to_Add_CrackStop__c='Yes';
        pd.Foundry_to_add_Guardring__c='No';
        pd.Size_X_um__c=5000;
        pd.Size_Y_um__c=5000;
        pdw.index=0;
        pdw.record=pd;
        obj.pdWrapList.remove(0);
        obj.pdWrapList.add(pdw);
        obj.Frame.Backgrind_Thickness__c='None';
        obj.Frame.LG_Configuration__c='Test1:Yes;Test2;No';
        obj.SaveMultiplePrimeDieData();
        obj.rowToRemove=0;
        obj.cancel();
        obj.removeRow();
       
    }
    
    
    @istest
    public  static void  sffgTest6(){
        
        insertLGConfig();
         //test.starttest();
        try{        
        Device__c dev=createSingleProductDevice();
        // test.stoptest();
        string CRON_EXP = '0 0 0 3 9 ? 2022';
        CronTrigger ct;
        
      String jobId = System.schedule('testBasicScheduledApex',CRON_EXP, new SFFGNotificationScheduler());
      ct = [SELECT Id, CronExpression, TimesTriggered,NextFireTime
         FROM CronTrigger WHERE id = :jobId];
     // System.assertEquals(CRON_EXP,ct.CronExpression);
          list<user> ulist = [select id from user where isactive = true and profile.UserType = 'Standard' and id != :UserInfo.getUserId() limit 4];
        Account_Team_Proxy__c atp1 = new Account_Team_Proxy__c(User__c = ulist[0].id,Account__c=dev.Account__c,Account_Access__c='Read/Write',Opportunity_Access__c='Read/Write',Team_Role__c='Backup Customer Service Rep',Sequence_No__c='1',Account_Role_ID__c='test');
        Account_Team_Proxy__c atp2 = new Account_Team_Proxy__c(User__c = ulist[1].id,Account__c=dev.Account__c,Account_Access__c='Read/Write',Opportunity_Access__c='Read/Write',Team_Role__c='Primary Customer Service Rep',Sequence_No__c='1',Account_Role_ID__c='test');
        Account_Team_Proxy__c atp3 = new Account_Team_Proxy__c(User__c = ulist[2].id,Account__c=dev.Account__c,Account_Access__c='Read/Write',Opportunity_Access__c='Read/Write',Team_Role__c='Primary Field Application Engineer',Sequence_No__c='1',Account_Role_ID__c='test');
         AccountTriggerRun.skipATPValidation = true;
         IntegrationUserUtil.isSkipTrigger();
        
         
         insert new list<Account_Team_Proxy__c>{atp1, atp2, atp3};
         SFFGEmailNotificationBatch bc=new SFFGEmailNotificationBatch();
          Database.executeBatch(bc,50);
          
     
      //System.assertEquals(0, ct.TimesTriggered);
       }catch(Exception E){} 
       
    }
    
    
    @istest
    public  static void  sffgTest7(){
        insertLGConfig();
        //test.starttest();
        Device__c dev=createSingleProductDevice();
        SFFG_Standard_Foundry_Frame__c f=new SFFG_Standard_Foundry_Frame__c();
        f.device__c=dev.id;
        f.Fab__c=dev.Fab__c;
        f.SWIFT_PTRF_ID__c=null;
        f.SWIFT_Status__c='New';
        //f.isChanged__c=true;
        f.SFFG_Frame_Status__c='In Progress';
        f.Backgrind_Thickness__c='None';
        f.LG_Configuration__c='Test1:Yes;Test2;No';
        insert f;
        SFFG_Prime_Die__c pd=new SFFG_Prime_Die__c();
        pd.Die_Anti_clock_wise_Rotation__c='90';
        pd.Foundry_to_Add_CrackStop__c='Yes';
        pd.Foundry_to_add_Guardring__c='No';
        pd.Size_X_um__c=5000;
        pd.Size_Y_um__c=5000;
        pd.Standard_Foundry_Frame__c=f.id;
        insert pd;
        //test.stoptest();
        //f.SWIFT_PTRF_ID__c='123456';update f;
        PageReference pageRef = Page.SFFGFrameDetails;
        Test.setCurrentPage(pageRef);
        System.currentPageReference().getParameters().put('id', dev.Id);
        SFFG_CreatePrimeDieCtrl obj=new SFFG_CreatePrimeDieCtrl();
        }
    
    
        
    @istest
    public static void testValidateChange(){
        SFFG_CreatePrimeDieCtrl obj=new SFFG_CreatePrimeDieCtrl();
        obj.validatePrimeDieChange(new SFFG_Prime_Die__c(Die_Anti_clock_wise_Rotation__c='90'),new SFFG_Prime_Die__c(Die_Anti_clock_wise_Rotation__c='190'));
        obj.validatePrimeDieChange(new SFFG_Prime_Die__c(Foundry_to_Add_CrackStop__c='Yes'),new SFFG_Prime_Die__c(Foundry_to_Add_CrackStop__c='No'));
        obj.validatePrimeDieChange(new SFFG_Prime_Die__c(Foundry_to_add_Guardring__c='Yes'),new SFFG_Prime_Die__c(Foundry_to_add_Guardring__c='No'));
        obj.validatePrimeDieChange(new SFFG_Prime_Die__c(Size_X_um__c=123),new SFFG_Prime_Die__c(Size_X_um__c=12313));
        obj.validatePrimeDieChange(new SFFG_Prime_Die__c(Size_Y_um__c=123),new SFFG_Prime_Die__c(Size_Y_um__c=123213));
        obj.validatePrimeDieChange(new SFFG_Prime_Die__c(Name='PD90'),new SFFG_Prime_Die__c(Name='PD190'));
        obj.validatePrimeDieChange(new SFFG_Prime_Die__c(Name='PD90'),new SFFG_Prime_Die__c(Name='PD90'));
        obj.validateFrameChange(new SFFG_Standard_Foundry_Frame__c(Backgrind_Thickness__c='0.13'),new SFFG_Standard_Foundry_Frame__c(Backgrind_Thickness__c='None'));
        obj.validateFrameChange(new SFFG_Standard_Foundry_Frame__c(LG_Configuration__c='test'),new SFFG_Standard_Foundry_Frame__c(LG_Configuration__c='Test21'));
        obj.validateFrameChange(new SFFG_Standard_Foundry_Frame__c(Backgrind_Thickness__c='0.13'),new SFFG_Standard_Foundry_Frame__c(Backgrind_Thickness__c='0.13'));
    }

}