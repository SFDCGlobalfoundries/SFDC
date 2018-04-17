/*
    Author: Nikhil Jain
    Description: Test class for PSP_CustomOpportunityLookupController
    History:
        NJain 10/04/2014    - Created
        Vijay       16012015    - Updated the Device Stage 'Solutioning' to 'Design In' as Device will be created in 
                                  'Design In' directly and added mandatory fields.
        DBiswal     05182015    - Updated code for refactoring of test class.
*/
@isTest(seeAllData = false)
private class PSP_CustomOppLookupControllerTest{
    
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
        
    static Opportunity createOpportunity(Id testAcctId) {
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
        
        return testOppty;
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
		Map<String, Object> tempMap = new Map<String, Object>();
		tempMap.put('Name', 'MSTPYP0');
		tempMap.put('Reticle_Type__c', 'Multi Layer Reticle (MLR)');
        
		Mask_Set_Title__c mst = MaskSetTitleDataFactory.createMaskSetTitle1(tempMap);
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
        
        
        Map<String,Object> fieldValueMap = new Map<String,Object>();
        fieldValueMap.put('Account__c',testAcctId);
        fieldValueMap.put('Name','TESTDEVICEZAIH12345677');
        fieldValueMap.put('Opportunity_Program__c',testOpptyProgramId);
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
        fieldValueMap.put('Device_Mask_Set_Title__c','MSTPYP0');
        fieldValueMap.put('Confidence_Level_Tapeout__c','100');
        fieldValueMap.put('Original_Forecasted_Tapeout_Date__c',date.today().addDays(7));
        fieldValueMap.put('CRMDID__c','CDID0000001.00');
        fieldValueMap.put('Device_Type__c','Base');
        fieldValueMap.put('reticle_type__c','Small Field Reticle (SFR)');
        fieldValueMap.put('End_Application__c','Body');
        return DeviceDataFactory.createDevice(fieldValueMap);
        /*
        
        Device__c device = new Device__c();
        device.Name = 'TESTDEVICEZAIH12345677';
        device.Opportunity_Program__c = testOpptyProgramId;
        device.Fab__c = 'FAB 2';
        device.GSOP_Assignment_Tapeout_Plan__c = 'No';
        device.Market_Segment__c = 'Mobility';
        device.Semiconductor_Device__c = 'Analog Amplifier';
        device.End_Customer__c = 'Test Customer';
        device.Device_Sourcing__c = '1st Source';
        device.Stage__c = 'Design In';
        device.Status__c = 'Active';
        device.Siebel_Device_ID__c = '1234567890';
        device.Tapeout_Type__c = 'Customer MPW';
        device.PLM_Device_ID__c = 'ANBQP60ACO8CH-U01';
        device.Device_Mask_Set_Title__c = 'DVMST12';
        device.CRMDID__c = 'CDID0000001.00';
        device.Device_Type__c = 'Base';
        
        device.Forecasted_Lot_Start_Date__c = System.Today();
        device.Product_TO_Date__c = System.Today();
        device.Sample_Delivery_Date__c = System.Today()+160;
        device.Forecasted_Proto_Date__c = System.Today()+220;
        device.Forecasted_RTP_Date__c = System.Today()+380;
        device.Forecasted_Production_Start_Date__c = System.Today()+580;
        device.Proto_DPML__c = 0.8;
        device.PreProd_Prod_DPML__c = 1.9;
        device.Production_DPML__c = 2.8;        
        device.No_of_Mask_Layers__c = 60;
        device.Display_in_PSP__c = true; 
        device.End_Application__c = 'Body';
        device.Original_Forecasted_Tapeout_Date__c = System.today();
        device.Enabled_via_previous_MPW_1__c = 'No';
        device.Confidence_Level_Tapeout__c = '100';
        device.Device_Mask_Set_Title__c = 'MSTPYP0';
        */
        
    }
    
    static testMethod void test_devicePSPs() {
       
        // Load Environment Variables   
        //DataUtilTest.loadEnvironmentVariables();
        
        Account testAcct1         = PSP_CustomOppLookupControllerTest.createAccount();
        Opportunity testOppty     = PSP_CustomOppLookupControllerTest.createOpportunity(testAcct1.Id);
        String testOpptyProgramId = PSP_CustomOppLookupControllerTest.createOpportunityProgram(testAcct1.Id, testOppty.Id);
        //String mstId = PSP_CustomOppLookupControllerTest.createMaskSetTtitle();
        //String mstId = DeviceUtilTest.createMaskSetTtitle();
        String mstId = createMaskSetTtitle();
        String mstaccId =  PSP_CustomOppLookupControllerTest.createMSTAccount(testAcct1.Id,mstId);
        test.startTest();
        Device__c testDevice      = PSP_CustomOppLookupControllerTest.createDevice(testAcct1.Id, testOpptyProgramId);
        Fab__c fab1 = createFab('FAB 1');
        Fab__c fab2 = createFab('FAB 2');
        
            PageReference pageRef = Page.PSP_CustomAccountLookup;
            ApexPages.currentPage().getParameters().put('lksrch',testOppty.Name);
            ApexPages.currentPage().getParameters().put('frm','text1');
            ApexPages.currentPage().getParameters().put('txt','text2');
           
            Test.setCurrentPageReference(pageRef);
            PSP_CustomOpportunityLookupController obj = new PSP_CustomOpportunityLookupController();
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