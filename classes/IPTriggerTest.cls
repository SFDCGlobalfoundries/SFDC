//Ashwini     05152015    - Updated code for refactoring of test class.

@isTest(seeAllData=false)
private class IPTriggerTest{
    @testSetup static void testdata() {
        DataUtilTest.loadEnvironmentVariables();
        //string acctId = DeviceUtilTest.createAccount();
        
         Map<String,Object> fieldValueMap = new Map<String,Object>();       
        fieldValueMap.put('Name', 'Test Account');
        fieldValueMap.put('Stage__c', 'Unqualified');
        fieldValueMap.put('Short_Name__c', 'test725');
        fieldValueMap.put('Site_Department__c', 'cts.com');
        fieldValueMap.put('Account_Type__c', 'Customer');
        fieldValueMap.put('Organization_Unit__c', 'sg;us');
        fieldValueMap.put('Copy_Address__c', true);
        fieldValueMap.put('Corporate_Address_1__c', 'test');
        fieldValueMap.put('Corporate_City__c', 'sg');
        fieldValueMap.put('Corporate_Country__c', 'sg');        
        fieldValueMap.put('Financial_Territory__c', 'Greater China');
        fieldValueMap.put('Region__c', 'APJ');
        fieldValueMap.put('Sub_Type__c', 'Direct');
        fieldValueMap.put('Transaction_Type__c', 'Transactional');
        fieldValueMap.put('Account_Profile__c', 'Fabless - Emerging');
        fieldValueMap.put('Corporate_Postal_Zip_Code__c', '700007');
        fieldValueMap.put('Fab_9_10__c', 'No');
        fieldValueMap.put('recordtypeid', EnvironmentVariable.get('ACCT_RT_ID_CUSTOMER'));       
        String acctId = AccountDataFactory.createAccount(fieldValueMap).Id;
        
        //string opptyId = DeviceUtilTest.createOpp(acctId,'0.10UM');
        string opptyId = DeviceUtilTest.createOpp(acctId,'0.055UM');
        string opptyProgramId = DeviceUtilTest.createOppProg(acctId,opptyId);
        Test.startTest();
        Device__c Device = DeviceUtilTest.createSPDevice(acctId,opptyProgramId);
        Device.Name = 'TESTDEVICEZAIH12345677';
        Device.Original_Forecasted_Tapeout_Date__c  = system.today();
        Device.PTRF_ID__c = 'test';
        Device.Geometry_Filter__c = '0.055UM';
        Device.Process_Family_Filter__c = 'MEMS';
        Device.Enabled_via_previous_MPW_1__c = 'No';
        Device.Stage__c = 'Design In';
        Device.Status__c = 'Active';
        Insert Device;
         Test.stopTest();
    }

     /**
        This method helps to test the BX041 record Edit functionalities along with the record submit and other approval process
        functionalities.
        
        @method name: testBX041_Edit
       
     */
    static Id createAccount() {
        // Create Account
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

        Insert testAcct;
        
        Contact testContact = new Contact();
        testContact.accountid = testAcct.id;
        testContact.lastname = 'testln';
        testContact.firstname = 'testfn';
        testContact.email = 'blank@blank.com';
        insert testContact;
        return testAcct.Id;
    }
    
    static void createAccountTeamProxy(id acctId, id userId){
        //string pfts = 'Primary Field Application Engineer';
        try
        {
        //string fts = 'Field Application Engineer';
        Account_Team_Proxy__c proxy1 =  new Account_Team_Proxy__c();
        proxy1.Team_Role__c = 'Field Application Engineer';
        proxy1.Account__c = acctId;
        proxy1.user__c  = userId;
        proxy1.Account_Access__c = 'Read/Write';
        proxy1.Opportunity_Access__c = 'Read/Write';
        insert proxy1;
        }
        catch(Exception ex)
        {}
    }
    
    static Id createOpportunity(Id testAcctId) {
        // Create Opportunity
        Map<String,Object> fieldValueMap = new Map<String,Object>();
        fieldValueMap.put('AccountId',testAcctId);
        fieldValueMap.put('Name','Test Opportunity');  
        fieldValueMap.put('StageName','1. Discovery');
        fieldValueMap.put('CloseDate',Date.Today().addDays(10));  
        fieldValueMap.put('Target_Process_Node__c','14XM');
        fieldValueMap.put('Market_Segment__c','Mobility');  
        fieldValueMap.put('Process_Platform__c','GF Baseline');
        fieldValueMap.put('Fab_Split__c',100);          
        fieldValueMap.put('Process_Geometry__c','0.055UM');  
        fieldValueMap.put('Process_Family__c','Generic / Nominal');
        fieldValueMap.put('Opportunity_Sourcing_Type__c','First Source');  
       
        return OpportunityDataFactory.createOpportunity(fieldValueMap).id;
        
        
    }
    
    static Id createOpportunityProgram(Id testAcctId, Id testOpptyId) {
        // Create Opportunity Program
        Opportunity_Program__c testOpptyProgram = new Opportunity_Program__c();
        testOpptyProgram.Name = 'Test Opportunity Program';
        testOpptyProgram.Account__c = testAcctId;
        testOpptyProgram.Opportunity__c = testOpptyId;        
        Insert testOpptyProgram;        
        return testOpptyProgram.Id;
    }
   /* 
    static Device__c createDevice(Id testAcctId, Id testOpptyProgramId) {
        // Create Device
        Device__c device = new Device__c();
        device.Name = 'TESTDEVICEZAIH12345677';
        device.Opportunity_Program__c = testOpptyProgramId;
        device.Fab__c = 'Fab 3';
        device.GSOP_Assignment_Tapeout_Plan__c = 'No';
        device.Market_Segment__c = 'Mobility';
        device.Semiconductor_Device__c = 'Analog Amplifier';
        device.End_Customer__c = 'Test Customer';
        device.Device_Sourcing__c = '1st Source';
        device.Stage__c = 'Design In'; // Testing only for 'design in'
        device.Confidence_Level_Tapeout__c = '50';
        device.End_Application__c = 'Server';
        device.Original_Forecasted_Tapeout_Date__c  = system.today();
        device.Status__c = 'Active';
        device.Siebel_Device_ID__c = '1234567890';
        device.Tapeout_Type__c = 'Single Product';
        device.Semiconductor_Device__c = 'MEMS - Inertial';
        device.PTRF_ID__c = 'test';
        device.Geometry_Filter__c = '0.055UM';
        device.Process_Family_Filter__c = 'MEMS';
        device.Enabled_via_previous_MPW_1__c = 'No';//Added as class was failing by Ashwini on 5/19/2015
        
        Insert device;
        
        return device;
    }
    */
    static Process__c createProcess(){
        Process__c process1 = new Process__c();
        process1.name = 'Test Process1';
        process1.Available_to_Sell__c = 'Available';//Prototype Ready; MPW Ready;'Registered/TBO
        //process1.ATTRIBUTE_READINESS_CALCULATED__c = ''; // Suspended
        process1.Bias_Table_Spec__c = 'Test bais tabel spec';
        process1.Tech_Geometry__c = '0.055UM';
        process1.Process_Family__c = 'MEMS';
        insert process1;
        return process1;
    }
    static BX_041__c createBX041(ID deviceID,Id processId){
        BX_041__c bx041 = new BX_041__c ();
        bx041.Device__c = deviceID;
        bx041.BX_041_Status__c = 'Closed';
        bx041.Geometry_Filter__c = '0.055UM';
        bx041.Process_Family_Filter__c = 'MEMS';
        bx041.Assigned_Process_ID__c = processId;
        bx041.BX_041_Status__c = 'Closed';
        //bx041.Requested_Process_ID__c = reqProcID;
        insert bx041;  
        return bx041;  
    }
    
    static List<Process_Information__c> createPI (id bx041ID, List<id> questionMetadataIDList){
        List<Process_Information__c> insertList = new List<Process_Information__c>();
        for(id questionMetadataID :questionMetadataIDList){
            Process_Information__c pi = new Process_Information__c(BX_041__c = bx041ID );
            pi.Comments__c = 'Test Comment';
            pi.Customer_Comment__c = 'Test CustComment';
            pi.Customer_Request__c = 'Test';
            pi.FE_Requested_Information__c = '';
            pi.mandatory__c = true;
            pi.PIYE__c = '';
            pi.Question__c = 'Lifecycle';
            pi.Question_Metadata__c = questionMetadataID;
            pi.Question_to_Display__c = 'Lifecycle';
            pi.Requirement_Gaps__c = 'test';
            insertList.add(pi);
        }
        insert insertList;
        return insertList;
    }
    
    static List<Gap_Analysis_Form__c> createGA (id bx041ID,List<id>  questionMetadataIDList){
        List<Gap_Analysis_Form__c > insertList = new List<Gap_Analysis_Form__c >();
        for(id questionMetadataID : questionMetadataIDList){
            Gap_Analysis_Form__c ga = new Gap_Analysis_Form__c  (BX_041__c = bx041ID );
            ga.APTS_Comments__c = 'Test Comment';
            ga.Gap_Name__c = 'ET';
            ga.Question_Metadata__c = questionMetadataID ; 
            ga.APTS_Resolution__c = 'test';
            ga.APTS_Status__c = 'None';
            insertList.add(ga);
        }
        insert insertList ;
        return insertList ;
    }
    
    
    static IP__c createIP (){
        IP__c ip = new IP__c(IP_Type__c = 'Logic',PH1_QA_Status__c = 'NCR');
        insert ip;
        return ip;
    }
    
    static IP_Merge__c createIPM (){
        IP_Merge__c ipm = new IP_Merge__c(IP_Type__c = 'Logic',PH1_QA_Status__c = 'NCR');
        insert ipm;
        return ipm;
    }
    
    static BX041_IP__c createBX041IP (id bx041ID ,id IdkId){
        BX041_IP__c ip = new BX041_IP__c (BX_041__c = bx041ID);
        ip.IP_Type__c = 'LOGIC';
        ip.IP_Master__c = IdkId;
       
        insert ip ;
        return ip ;
    
    }
    
    static BX041_IP_Merge__c createBX041IPM (id bx041ID, id ipmId){
        BX041_IP_Merge__c ipm = new BX041_IP_Merge__c(BX_041__c = bx041ID);
        ipm.GF_Supported_IP__c = true;
        ipm.IP_Master__c = ipmId;
        ipm.Remarks__c = 'test';
        ipm.Merge_Kit_Name__c = 'Test';
        insert ipm ;
        return ipm ;
    
    }
    
    static testmethod void testIPTrigger()
    {
            //DataUtilTest.loadEnvironmentVariables();
            //User admin = [SELECT Id FROM user WHERE profile.Name='GF FAE/FTS' and isactive = true limit 1];
            //Test Data creation: 
           /* String testAcctId = IPTriggerTest.createAccount();
            IPTriggerTest.createAccountTeamProxy(testAcctId, '005900000010XJr');
            String testOpptyId = IPTriggerTest.createOpportunity(testAcctId);
            String testOpptyProgramId = IPTriggerTest.createOpportunityProgram(testAcctId, testOpptyId);
            Device__c testDevice = DeviceUtilTest.createSingleProductDevice();*/
            Account acctId = [Select Id from Account where name = 'Test Account'];
            Opportunity oppId =[Select Id from Opportunity where name = 'Test Opportunity'];
            test.startTest();
            Opportunity_Program__c testOpptyProgramId = [Select Id from Opportunity_Program__c where name = 'Test Opportunity Program'];
             
            Device__c testDevice = [Select Id,Geometry_Filter__c from Device__c where name = 'TESTDEVICEZAIH12345677'];
            system.debug('Geometry :' +testDevice.Geometry_Filter__c);
            Process__c process1 = IPTriggerTest.createProcess();
            BX_041__c bx041 = IPTriggerTest.createBX041(testDevice.id,process1.Id);
            
            System.debug('Tech_Geometry' +process1.Tech_Geometry__c);
            IP__c ip = IPTriggerTest.createIP();
            IPTriggerTest.createBX041IP(bx041.id, ip.id);
            IP_Merge__c ipm = IPTriggerTest.createIPM();
            IPTriggerTest.createBX041IPM(bx041.id, ipm.id);
            testDevice.Assigned_Process_ID__c = process1.id;
            //testDevice.Assigned_Process_ID__c = '0.055UM';
            
                    
            update testDevice;
            //System.runAs(admin) {
           // bx041.Assigned_Process_ID__c = process1.id;
            //bx041.GAP_Closed__c = true;
            //update bx041;
            BX_041__c bx041Temp = [select id, BX_041_Status__c, device__r.Stage__c, device__r.Status__c from BX_041__c where id = :bx041.id];
            system.debug('&&&&&&' + bx041Temp.BX_041_Status__c + '&&&&' + bx041Temp.device__r.Stage__c + '&&&&' + bx041Temp.device__r.status__c);
                      
            list<Sobject> olist = new list<Sobject>();
            ip.PH1_QA_Status__c = 'BKE';            
            ipm.PH1_QA_Status__c = 'PYE';
            olist.add(ip);
            olist.add(ipm);
            update olist;
            test.stopTest();  
            //}

	}
}