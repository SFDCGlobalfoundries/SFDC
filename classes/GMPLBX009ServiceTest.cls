/*
    Author: Anirban Roy
    Description: This is the test class for the GMPLBX009Service class.  
    History:
        ARoy        04072014    - code creation.
        ARoy        06102014    - code modification for Override the Quantity and Revenue forecasted from different Opportunities.
        Ashwini     04162015    - Updated code for making SeeAllData=false and refactoring of test class.
*/

@isTest(SeeAllData=false)
public class GMPLBX009ServiceTest {
     
     @testSetup static void testdata() {
        DataUtilTest.loadEnvironmentVariables();
        
        Map<String,Object> fieldValueMap = new Map<String,Object>();
        fieldValueMap.put('Name', 'MYTEST ACCOUNT1');                          
        fieldValueMap.put('sub_type__c', 'Indirect');
        fieldValueMap.put('site_department__c', 'test dept');          
        fieldValueMap.put('transaction_type__c', 'Non-Transactional');                          
        fieldValueMap.put('region__c', 'US');        
        fieldValueMap.put('Corporate_Address_1__c', 'Test Address 1');          
        fieldValueMap.put('Corporate_City__c', 'Test City');                
        fieldValueMap.put('Corporate_Country__c', 'India');
        fieldValueMap.put('Bill_To_Address_1__c', 'Test Address 1');          
        fieldValueMap.put('Bill_To_City__c', 'Test City');            
        fieldValueMap.put('Bill_To_Country__c', 'India');        
        fieldValueMap.put('Fab_9_10__c','No');

        AccountDataFactory.createAccount(fieldValueMap);
    }
    
    // Create User
    static User createUser(){
        Id acctId = getAccount('MYTEST ACCOUNT1').id;
        Environment_Variable__c env = [select id,name,value__c from Environment_Variable__c where name='HCM Emp AccountId'];
        env.value__c=acctId;
        update env;
       
        HCM_Employee__c hcm = new HCM_Employee__c(First_Name__c='TestFirstName2002',
                                                  Last_Name__c='TestLastName2002',
                                                  Employee_ID__c='Test2002',
                                                  Login_ID__c='test2002',
                                                  Email_Address__c='test2002@test.com');
        insert hcm;
        Profile p = [select id from Profile where name = 'GF CE'];
        User u = new User(alias = 'ts2002', email='test2002@test.com',
                          emailencodingkey='UTF-8', lastname='TestLast2002', firstname='TestFirst2002', languagelocalekey='en_US',
                          localesidkey='en_US',timezonesidkey='America/Los_Angeles', username='test2002@test.com',communitynickname='ts2002',
                          profileid = p.Id,FederationIdentifier='Test2002');
        insert u;
        return u;
    }       
    
    // Creation of an opportunity
    static Id createOpp(Id acctId){
        Integer year = System.Today().year();
        Integer month = System.Today().month();
        Integer day = System.Today().day();
        
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
        fieldValueMap.put('Process_Family__c','Super Low Power');
        fieldValueMap.put('Opportunity_Sourcing_Type__c','First Source');  
        fieldValueMap.put('Years_of_Production__c',4);
        fieldValueMap.put('X1st_Product_Production_Date__c',date.newInstance(year+6,month,day));
         
        return OpportunityDataFactory.createOpportunity(fieldValueMap).id;
        
    }
    
    // Creation of an opportunity
    static Id createOpp1(Id acctId){
        Integer year = System.Today().year();
        Integer month = System.Today().month();
        Integer day = System.Today().day();
        
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
        fieldValueMap.put('Process_Family__c','Super Low Power');
        fieldValueMap.put('Opportunity_Sourcing_Type__c','First Source');  
        fieldValueMap.put('Years_of_Production__c',4);
        fieldValueMap.put('X1st_Product_Production_Date__c',date.newInstance(year-1,month,day));
         
        return OpportunityDataFactory.createOpportunity(fieldValueMap).id;
        
    }        
    
    // Creation of GMPL/BX009
    static GMPL_BX009__c createGMPL(){
        GMPL_BX009__c gmplBX009 = new GMPL_BX009__c();
        gmplBX009.Product_Start_Date__c = String.valueOf(System.Today().year());
        gmplBX009.status__c = 'Active';
        insert gmplBX009;
        return gmplBX009;
    }
    
    //Creation of GMPL Opportunity Junction
    static Id createGMPLOppJunction(Id gmplId, Id oppId){
        GMPL_Opportunity__c gmplOpp = new GMPL_Opportunity__c(GMPL_BX009__c = gmplId, Opportunity__c = oppId);
        insert gmplOpp;
        return gmplOpp.Id;
    }
    
    //Updation of Revenue Forecast
    static void updateRevenueForecast(Id gmplId){
        List<Revenue_Forecast__c> revForecastList = [select     id
                                                                , Average_Sales_Price__c
                                                                , Quantity__c 
                                                    from        Revenue_Forecast__c 
                                                    where       GMPL_BX009__c = :gmplId];
        for(Revenue_Forecast__c revFor : revForecastList){
            revFor.Average_Sales_Price__c = 10;
            revFor.Quantity__c = 2;
        }
        update revForecastList;
    }
    
    // Approval Request Submission Test
    static testMethod void approvalRequestTest1(){
        
        // Load Environment Variables   
        //DataUtilTest.loadEnvironmentVariables();            
        GMPL_BX009__c gmplBX009Obj = GMPLBX009ServiceTest.createGMPL();
        GMPLBX009ServiceTest.updateRevenueForecast(gmplBX009Obj.Id);
        
        
        Test.startTest();        
        
        String retMsg = GMPLBX009Service.approvalRequest(gmplBX009Obj.Id);
        system.assertEquals(retMsg,'Please select atleast one Service Type to proceed further.');
        
        gmplBX009Obj.Consigned_Wafer__c = true;
        gmplBX009Obj.Productization__c = true;
        gmplBX009Obj.Product_Process__c = true;        
        gmplBX009Obj.Turnkey__c = true;
        update gmplBX009Obj;
        
        retMsg = GMPLBX009Service.approvalRequest(gmplBX009Obj.Id);
        system.assert(retMsg.contains('It is essential to Acknowledge the completion of details for the Service Type(s) selected to proceed further'));
        
        Test.stopTest();
        
    }
    
    // Approval Request Submission Test
    static testMethod void approvalRequestTest2(){
        
        // Load Environment Variables   
        //DataUtilTest.loadEnvironmentVariables();            
        GMPL_BX009__c gmplBX009Obj = GMPLBX009ServiceTest.createGMPL();        
        GMPLBX009ServiceTest.updateRevenueForecast(gmplBX009Obj.Id);
        
        Test.startTest();
        
        gmplBX009Obj.Consigned_Wafer__c = true;
        gmplBX009Obj.SQE_Acknowledgement__c = true;
        update gmplBX009Obj;
        
        String retMsg = GMPLBX009Service.approvalRequest(gmplBX009Obj.Id);
        system.assertEquals(retMsg,'OK');
        
        Test.stopTest();
        
    }
    
    // Approval Request Submission Test
    static testMethod void approvalRequestTest5(){
        
        // Load Environment Variables   
        //DataUtilTest.loadEnvironmentVariables(); 
        
        User u = GMPLBX009ServiceTest.createUser();                
        
        GMPL_BX009__c gmplBX009Obj = GMPLBX009ServiceTest.createGMPL();
        
        Test.startTest();        
        
        system.runAs(u){
            String retMsg = GMPLBX009Service.approvalRequest(gmplBX009Obj.Id);
            system.assertEquals(retMsg,'Only PPM, CE Admin, GF Product Marketing Profile with R/W Access,'+ 
                    ' GF Sales Profile (Account Manager) with R/W Access, Project Lead with R/W Access can submit a GMPL/BX009 for approval.'+
                    +' '+'If you are a Project Lead, please request System Administrator to add you on Project Lead Permission Set.');
        }
        
        Test.stopTest();
        
    }
    
    // Calculate Revenue Test
    static testMethod void calculateRevenueTest(){
        
        // Load Environment Variables   
        //DataUtilTest.loadEnvironmentVariables();            
        Id acctId = getAccount('MYTEST ACCOUNT1').id;
        Id oppId = GMPLBX009ServiceTest.createOpp(acctId);
        Test.startTest();    
        GMPL_BX009__c gmplBX009Obj = GMPLBX009ServiceTest.createGMPL();
        Id gmplOppId = GMPLBX009ServiceTest.createGMPLOppJunction(gmplBX009Obj.Id,oppId);
       
            
        
        String retMsg = GMPLBX009Service.calculateRevenue(gmplBX009Obj.Id);
        system.assertEquals(retMsg,'OK');
        
        Test.stopTest();
        
    }
    
    // Override Quarterly Revenue to GMPL Revenue Forecast Test
    static testMethod void overrideGMPLRevForecastWithQtrRevTest(){
        
        // Load Environment Variables   
        //DataUtilTest.loadEnvironmentVariables();    
             
        Id acctId = getAccount('MYTEST ACCOUNT1').id;
        Test.startTest();    
        Id oppId = GMPLBX009ServiceTest.createOpp(acctId);
        
        //Query to find the Quarterly Revenue
        List<Quarterly_Revenue_Object__c> qtrRevList = [select ASP__c,Volume__c from Quarterly_Revenue_Object__c 
                                    where Opportunity__c = :oppId];
        
        for(Quarterly_Revenue_Object__c qtrRev : qtrRevList){
            qtrRev.ASP__c = 10;
            qtrRev.Volume__c = 10;
        }       
        
        update qtrRevList;
        
         
        GMPL_BX009__c gmplBX009Obj = GMPLBX009ServiceTest.createGMPL();
       
        Id gmplOppId = GMPLBX009ServiceTest.createGMPLOppJunction(gmplBX009Obj.Id,oppId);
       
               
        
            String retMsg = GMPLBX009Service.overrideWithQrtlyRevFrcst(gmplBX009Obj.Id, gmplBX009Obj.Product_Start_Date__c);
            system.assertEquals(retMsg,'OK');
        
        Test.stopTest();
        
    }
    
    // Override Quarterly Revenue to GMPL Revenue Forecast and Calculate Revenue Validation Test
    static testMethod void overrideQtrRevCalRevUserPermTest(){
        
        // Load Environment Variables   
        //DataUtilTest.loadEnvironmentVariables();            
        User u = GMPLBX009ServiceTest.createUser();                
        
        GMPL_BX009__c gmplBX009Obj = GMPLBX009ServiceTest.createGMPL();
       
        Test.startTest();        
        
            system.runAs(u){
                String retMsg = GMPLBX009Service.overrideWithQrtlyRevFrcst(gmplBX009Obj.Id, gmplBX009Obj.Product_Start_Date__c);
                system.assertEquals(retMsg,'User is having Read Only access on GMPL/BX009 record.');
            
                retMsg = GMPLBX009Service.calculateRevenue(gmplBX009Obj.Id);
                system.assertEquals(retMsg,'User is having Read Only access on GMPL/BX009 record.');
            }
        
        Test.stopTest();
        
    }
    
    // Override Quarterly Revenue to GMPL Revenue Forecast and Calculate Revenue Validation Test
    static testMethod void overrideQtrRevCalRevYrValTest(){
        
        // Load Environment Variables   
        //DataUtilTest.loadEnvironmentVariables();            
        Id acctId = getAccount('MYTEST ACCOUNT1').id;
        Id oppId = GMPLBX009ServiceTest.createOpp1(acctId);
        Test.startTest();   
        GMPL_BX009__c gmplBX009Obj = GMPLBX009ServiceTest.createGMPL();
        Id gmplOppId = GMPLBX009ServiceTest.createGMPLOppJunction(gmplBX009Obj.Id,oppId);
       
             
        
            String retMsg = GMPLBX009Service.overrideWithQrtlyRevFrcst(gmplBX009Obj.Id, gmplBX009Obj.Product_Start_Date__c);
            system.assertEquals(retMsg,'Opportunity Quarterly Revenue cannot override GMPL Revenue Forecast as '
                                + 'Quarterly Revenue Year is earlier than GMPL Revenue Forecast Year. '
                                + 'Update Revenue Start Year in GMPL/BX009 to earlier year to proceed.');
        
        Test.stopTest();
        
    }       
    
    private static Account getAccount(string AccountName)
    {
        Account acct = [SELECT Id, Name FROM Account Where Name =: AccountName];
        
        return acct;
    }

}