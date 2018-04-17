/*
    Author: Nikhil Jain
    Description: Test class for PSP_searchExtension
    History:
        NJain 04/09/2014    - Created
        Vijay       16012015    - Updated the Device Stage 'Solutioning' to 'Design In' as Device will be created in 
                                  'Design In' directly and added mandatory fields.
*/
@isTest
private class PSP_searchExtensionTest{

@testSetup static void testdata(){
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
        Test.startTest();        
        Account testAcct1         = PSP_searchExtensionTest.createAccount();
        String testOpptyId        = PSP_searchExtensionTest.createOpportunity(testAcct1.Id);
        String testOpptyProgramId = PSP_searchExtensionTest.createOpportunityProgram(testAcct1.Id, testOpptyId);
        Test.stopTest();
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
        fieldValueMap.put('Name','Test Opp');  
        fieldValueMap.put('StageName','1. Discovery');
        fieldValueMap.put('CloseDate',Date.Today().addDays(10));  
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
    
    static void createQuarterlyRevenue(Id testOpptyId){
        List<Quarterly_Revenue_Object__c> qtrRevlist = new List<Quarterly_Revenue_Object__c>();
        
        Quarterly_Revenue_Object__c qtrRev1 = new Quarterly_Revenue_Object__c();
        qtrRev1.Opportunity__c = testOpptyId;
        qtrRev1.Volume__c = 100;
        qtrRev1.Date__c = System.Today();
        qtrRev1.ASP__c = 1000;
        qtrRev1.Fiscal_Quarter__c = String.valueOf(System.Today().year())+'-Q1';
        qtrRevlist.add(qtrRev1);
        
        Quarterly_Revenue_Object__c qtrRev2 = new Quarterly_Revenue_Object__c();
        qtrRev2.Opportunity__c = testOpptyId;
        qtrRev2.Volume__c = 200;
        qtrRev2.Date__c = System.Today();
        qtrRev2.ASP__c = 100;
        qtrRev2.Fiscal_Quarter__c = String.valueOf(System.Today().year())+'-Q2';
        qtrRevlist.add(qtrRev2);
        
        Quarterly_Revenue_Object__c qtrRev3 = new Quarterly_Revenue_Object__c();
        qtrRev3.Opportunity__c = testOpptyId;
        qtrRev3.Volume__c = 100;
        qtrRev3.Date__c = System.Today();
        qtrRev3.Fiscal_Quarter__c = String.valueOf(System.Today().year())+'-Q3';
        qtrRev3.ASP__c = 500;
        qtrRevlist.add(qtrRev3);
        
        Quarterly_Revenue_Object__c qtrRev4 = new Quarterly_Revenue_Object__c();
        qtrRev4.Opportunity__c = testOpptyId;
        qtrRev4.Volume__c = 1000;
        qtrRev4.Date__c = System.Today();
        qtrRev4.Fiscal_Quarter__c = String.valueOf(System.Today().year())+'-Q4';
        qtrRev4.ASP__c = 180;
        qtrRevlist.add(qtrRev4);
            
        Insert qtrRevlist;
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
        Map<String,Object> fieldValueMap = new Map<String,Object>();
        
        fieldValueMap.put('Name','TESTDEVICEZAIH12345677');
        fieldValueMap.put('Account__c',testAcctId);
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
        fieldValueMap.put('Device_Type__c','Base');
        
        fieldValueMap.put('Forecasted_Lot_Start_Date__c',System.Today());
        fieldValueMap.put('Product_TO_Date__c',System.Today());
        fieldValueMap.put('Sample_Delivery_Date__c',System.Today()+160);
        fieldValueMap.put('Forecasted_Proto_Date__c',System.Today()+220);
        fieldValueMap.put('Forecasted_RTP_Date__c',System.Today()+380);
        fieldValueMap.put('Forecasted_Production_Start_Date__c',System.Today()+580);
        fieldValueMap.put('Proto_DPML__c',0.8);
        fieldValueMap.put('PreProd_Prod_DPML__c',1.9);
        fieldValueMap.put('Production_DPML__c',2.8);        
        fieldValueMap.put('No_of_Mask_Layers__c',60);
        fieldValueMap.put('Display_in_PSP__c',true); 
        fieldValueMap.put('End_Application__c','Body');
        fieldValueMap.put('Original_Forecasted_Tapeout_Date__c',System.today());
        fieldValueMap.put('Enabled_via_previous_MPW_1__c','No');
        fieldValueMap.put('Confidence_Level_Tapeout__c','100');
        
                               
        return DeviceDataFactory.createDevice(fieldValueMap);
    }
    
    static testMethod void test_devicePSPs() {
       
        
        Account testAcct1         = PSP_searchExtensionTest.createAccount();
        /*String testOpptyId        = PSP_searchExtensionTest.createOpportunity(testAcct1.Id);
        String testOpptyProgramId = PSP_searchExtensionTest.createOpportunityProgram(testAcct1.Id, testOpptyId); */
        
        String testOpptyId = [Select Id from Opportunity where Name = 'Test Opp'].Id;
        String testOpptyProgramId = [Select Id from Opportunity_Program__c where Name = 'Test Opportunity Program'].Id;
        PSP_searchExtensionTest.createQuarterlyRevenue(testOpptyId);
        
        String mstId = PSP_searchExtensionTest.createMaskSetTtitle();
        String mstaccId =  PSP_searchExtensionTest.createMSTAccount(testAcct1.Id,mstId);
        test.startTest();
        Device__c testDevice      = PSP_searchExtensionTest.createDevice(testAcct1.Id, testOpptyProgramId);
        Fab__c fab1 = createFab('FAB 1');
        Fab__c fab2 = createFab('FAB 2');
        
            PageReference pageRef = Page.PSP_search;
            ApexPages.currentPage().getParameters().put('accId',testAcct1.Id);
            ApexPages.currentPage().getParameters().put('oppId',testOpptyId);
            
            Test.setCurrentPageReference(pageRef);
            ApexPages.StandardController controller = new ApexPages.StandardController(testDevice);
            PSP_searchExtension dlc = new PSP_searchExtension(controller);
            
            
            dlc.deviceRec.Account__c = testAcct1.Id;
            dlc.yearofbegin = system.today().year();
            dlc.yearofstart = system.today().year()-2;
            dlc.yearofend   = system.today().addYears(2).year();
            dlc.getFabs();
            dlc.getProcessGeometries();
            dlc.getSalesTerritories();
            
            dlc.Search();
            dlc.getSearchResult();
            
            dlc.Beginning();
            dlc.Previous();
            dlc.Next();
            dlc.End();
            dlc.getDisablePrevious();
            dlc.getDisableNext();
            dlc.getTotal_Size();
            dlc.getPageNumber();
            dlc.getTotalPages();
            dlc.ExportToExcel();
            dlc.getYears();
            
            Decimal d1 = dlc.NullCheck(9);
            Decimal d2 = dlc.NullCheck(NULL);
            
            dlc.processGeometrySelected = '0.050UM';
            dlc.getSearchResult();
            dlc.getYearsEnd();
            dlc.returnFunction();
        test.stoptest();                        
    }
    
    private static Account getAccount(string AccountName)
            {
                Account testAcct= [SELECT Id, Name FROM Account Where Name =: AccountName];
        
                return testAcct;
            }  
    
}