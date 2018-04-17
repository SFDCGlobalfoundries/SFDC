/*
    Author: Nikhil Jain
    Description: Test class for PSP_CustomAccountLookupController
    History:
        NJain 10/04/2014    - Created
        Vijay       16012015    - Updated the Device Stage 'Solutioning' to 'Design In' as Device will be created in 
                                  'Design In' directly and added mandatory fields.
        DBiswal     05182015    - Updated code for refactoring of test class.
*/
@isTest(seeAllData = false)
private class PSP_CustomAccountLookupControllerTest{
    
    @testSetup static void testdata() {
        DataUtilTest.loadEnvironmentVariables();
        
         Map<String,Object> fieldValueMap = new Map<String,Object>();       
        fieldValueMap.put('Name', 'testing901');
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
        AccountDataFactory.createAccount(fieldValueMap);
    }
    
    static Fab__c createFab(String fabName){
        Fab__c fabRec = new Fab__c();
        fabRec.name = fabName;
        fabRec.isActive__c = true;
        insert fabRec;
        return fabRec;
    }
    
    static Account createAccount() {
        // Create Account
        Account testAcct = getAccount('testing901'); 
        
        return testAcct;
    }
        
    static Id createOpportunity(Id testAcctId) {
        // Create Opportunity
        Map<String,Object> fieldValueMap = new Map<String,Object>();
        fieldValueMap.put('AccountId',testAcctId);
        fieldValueMap.put('Name','Test Opportunity');  
        fieldValueMap.put('StageName','1. Discovery');
        fieldValueMap.put('CloseDate',date.newinstance(2012, 12, 21));  
        fieldValueMap.put('Target_Process_Node__c','14XM');
        fieldValueMap.put('Market_Segment__c','Mobility');  
        fieldValueMap.put('Process_Platform__c','GF Baseline');
        fieldValueMap.put('Fab_Split__c',100);          
        fieldValueMap.put('Process_Geometry__c','0.055UM');  
        fieldValueMap.put('Process_Family__c','Generic / Nominal');
        
        Opportunity testOppty = OpportunityDataFactory.createOpportunity(fieldValueMap);
        
        testOppty.Siebel_Opportunity_ID__c = '123123123123';        
        Update testOppty;
        
        return testOppty.Id;
    }
    
    static Id createOpportunityProgram(Id testAcctId, Id testOpptyId){
        // Create Opportunity Program
        Opportunity_Program__c testOpptyProgram = new Opportunity_Program__c();
        testOpptyProgram.Name = 'Test Opportunity Program';
        testOpptyProgram.Account__c = testAcctId;
        testOpptyProgram.Opportunity__c = testOpptyId;        
        Insert testOpptyProgram;        
        return testOpptyProgram.Id;
    }
    
    static Id createMaskSetTtitle(){
        Mask_Set_Title__c mst = new Mask_Set_Title__c();
        mst.Name = 'MSTTRT1';
        mst.Reticle_Type__c = 'Multi Layer Reticle (MLR)';
        insert mst;
        return mst.Id;
    }
    
    static Id createMSTAccount(Id acctId, Id MSTId){
        MSTAccount__c mstAcc = new MSTAccount__c();
        mstAcc.Account__c = acctId;
        mstAcc.Mask_Set_Title__c = MSTId;
        insert mstAcc;
        return mstAcc.Id;
    }
    
    static Device__c createDevice(Id testAcctId, Id testOpptyProgramId) {
        // Create Device
        String MSTId = createMaskSetTtitle();
        string MSTAccId = DeviceUtilTest.createMSTAccount(testAcctId,MSTId);
        
        Map<String,Object> fieldValueMap = new Map<String,Object>();
        fieldValueMap.put('Account__c',testAcctId);
        fieldValueMap.put('Name','TESTDEVICEZAIH12345677');
        fieldValueMap.put('Opportunity_Program__c',testOpptyProgramId);
        fieldValueMap.put('Fab__c','FAB 2');
        fieldValueMap.put('GSOP_Assignment_Tapeout_Plan__c','No');
        fieldValueMap.put('Market_Segment__c','Mobility');
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
        fieldValueMap.put('End_Application__c','Body');
        //fieldValueMap.put('Original_Forecasted_Tapeout_Date__c',System.today());
        fieldValueMap.put('Confidence_Level_Tapeout__c','100');
        return DeviceDataFactory.createDevice(fieldValueMap);
        
        
        
    }
    
    static testMethod void test_devicePSPs() {
       
        // Load Environment Variables   
        //DataUtilTest.loadEnvironmentVariables();
        
        Account testAcct1         = PSP_CustomAccountLookupControllerTest.createAccount();
        String testOpptyId        = PSP_CustomAccountLookupControllerTest.createOpportunity(testAcct1.Id);
        String testOpptyProgramId = PSP_CustomAccountLookupControllerTest.createOpportunityProgram(testAcct1.Id, testOpptyId);
        String mstId = PSP_CustomAccountLookupControllerTest.createMaskSetTtitle();
        String mstaccId =  PSP_CustomAccountLookupControllerTest.createMSTAccount(testAcct1.Id,mstId);
        test.startTest();
        //Device__c testDevice      = PSP_CustomAccountLookupControllerTest.createDevice(testAcct1.Id, testOpptyProgramId);
        String deviceId = DeviceUtilTest.createCustomerMPWDevice(testAcct1.Id, testOpptyProgramId);
        Device__c testDevice = new Device__c(Id = deviceId);
        
        Fab__c fab1 = createFab('FAB 1');
        Fab__c fab2 = createFab('FAB 2');
        
        
        
            PageReference pageRef = Page.PSP_CustomAccountLookup;
            ApexPages.currentPage().getParameters().put('lksrch',testAcct1.Name);
            ApexPages.currentPage().getParameters().put('frm','text1');
            ApexPages.currentPage().getParameters().put('txt','text2');
           
            Test.setCurrentPageReference(pageRef);
            PSP_CustomAccountLookupController obj = new PSP_CustomAccountLookupController();
            obj.searchString = 'Test';
            obj.getFormTag();
            obj.getTextBox();
            obj.search();
        test.stopTest();  
        
    }
    
    private static Account getAccount(string AccountName)
            {
                Account testAcct= [SELECT Id, Name FROM Account Where Name =: AccountName];
        
                return testAcct;
            }  
}