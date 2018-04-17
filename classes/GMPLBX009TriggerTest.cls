/*
    Author: Anirban Roy
    Description: This is the test class for the GMPL triggers and the helper classes.  
    History:
        ARoy        04142014    - code creation.
        ARoy        06042014    - modified code for Case # 00024000.
        ARoy        09192014    - replaced Sales_Territory__c with Financial_Territory__c field.
        Ashwini     04162015    - Updated code for making SeeAllData=false and refactoring of test class.
*/

@isTest(SeeAllData=false)
public class GMPLBX009TriggerTest {
    @testSetup static void testdata() {
        DataUtilTest.loadEnvironmentVariables();
        
        List<Map<String,Object>> fieldValueMapList = new List<Map<String,Object>>();
        for(integer i=1;i<=2;i++){ 
            Map<String,Object> fieldValueMap = new Map<String,Object>();
            fieldValueMap.put('Name', 'MYTEST ACCOUNT'+i);            
            fieldValueMap.put('Financial_Territory__c', 'Greater China'); 
            fieldValueMap.put('Sales_group__c', 'GC-Group'+i);       
            fieldValueMap.put('sub_type__c', 'Indirect');
            fieldValueMap.put('site_department__c', 'test dept');          
            fieldValueMap.put('transaction_type__c', 'Non-transactional');                          
            fieldValueMap.put('region__c', 'APJ');        
            fieldValueMap.put('Corporate_Address_1__c', 'Test Address 1');          
            fieldValueMap.put('Corporate_City__c', 'Test City');                
            fieldValueMap.put('Corporate_Country__c', 'Singapore');
            fieldValueMap.put('Bill_To_Address_1__c', 'Test Address 1');          
            fieldValueMap.put('Bill_To_City__c', 'Test City');            
            fieldValueMap.put('Bill_To_Country__c', 'Singapore');        
            fieldValueMap.put('Fab_9_10__c','No');
            
            fieldValueMapList.add(fieldValueMap);
        }
        AccountDataFactory.createAccounts(fieldValueMapList,2);
        Id acctId = getAccount('MYTEST ACCOUNT1').id;
        Environment_Variable__c env = [select id,name,value__c from Environment_Variable__c where name='HCM Emp AccountId'];
        env.value__c=acctId;
        update env;
    }
    // Create User
    static User createUser(){
        
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
    
    // Creation of GMPL/BX009
    static GMPL_BX009__c createGMPL1(Id acctId){
        GMPL_BX009__c gmplBX009 = new GMPL_BX009__c();
        gmplBX009.Geometry__c = '10';
        gmplBX009.Family__c = 'TestFamily1';
        gmplBX009.Variant__c = 'TestVar1';
        gmplBX009.Option__c = 'TestOpt1';
        gmplBX009.Fab__c = 'FAB 1';
        gmplBX009.Account__c = acctId;
        gmplBX009.Product_Start_Date__c = String.valueOf(System.Today().year());
        insert gmplBX009;
        return gmplBX009;
    }
    
    // Creation of GMPL/BX009
    static GMPL_BX009__c createGMPL2(){
        GMPL_BX009__c gmplBX009 = new GMPL_BX009__c();
        gmplBX009.Geometry__c = '10';
        gmplBX009.Fab__c = 'FAB 1';        
        insert gmplBX009;
        return gmplBX009;
    }
    
    // Creation of GMPL/BX009
    static GMPL_BX009__c createGMPL3(Id acctId){
        GMPL_BX009__c gmplBX009 = new GMPL_BX009__c();
        gmplBX009.Family__c = 'TestFamily1';
        gmplBX009.Account__c = acctId;
        insert gmplBX009;
        return gmplBX009;
    }
    
    // Creation of GMPL/BX009
    static GMPL_BX009__c createGMPL4(){
        GMPL_BX009__c gmplBX009 = new GMPL_BX009__c();
        gmplBX009.Variant__c = 'To Be Assigned by PPM 1';
        insert gmplBX009;
        return gmplBX009;
    }
    
    // Creation of GMPL/BX009
    static GMPL_BX009__c createGMPL5(){
        GMPL_BX009__c gmplBX009 = new GMPL_BX009__c();
        gmplBX009.Option__c = 'TestOpt1';
        insert gmplBX009;
        return gmplBX009;
    }
    
    //Creation of PPE Team
    static PPE_Team__c createPPETeamMember(Id gmplId, Id userId, String ppeRole){
        PPE_Team__c pT = new PPE_Team__c();
        pT.GMPL_BX009__c = gmplId;
        pT.PPE_Role__c = ppeRole;
        pT.Access_Level__c = 'Read/Write';
        pT.User__c = userId;
        insert pT;
        return pT;
    }    
    
    // Creation of Process
    static Process__c createProcess(){
        Process__c p = new Process__c();
        p.Name = 'TestProcess';
        p.Available_to_Sell__c = 'Available';
        insert p;
        return p;  
    }
    
    static testMethod void createGMPLBX009Test1(){
        
        // Load Environment Variables   
        //DataUtilTest.loadEnvironmentVariables();
        
        Id acctId = getAccount('MYTEST ACCOUNT1').id;
        
        Test.startTest();
        
        GMPL_BX009__c gmpl = GMPLBX009TriggerTest.createGMPL1(acctId);      
                
        gmpl = [select  Id
                        , Project__c
                        , Program_Name__c
                        , Product_Start_Date__c
                from    GMPL_BX009__c
                where   Id = :gmpl.Id
               ];
        gmpl.Product_Start_Date__c = String.valueOf(System.Today().year()+1);
        GMPL_GMPLAfterOperationHandler.isExecuted = false;
        update gmpl;
               
        //system.assertEquals(gmpl.Project__c, '10-TestFamily1-TestVar1-TestOpt1');
        //system.assertEquals(gmpl.Program_Name__c, '10-TestFamily1-TestVar1-TestOpt1-FAB 1');
        
        Test.stopTest();
        
    }
    
    static testMethod void createGMPLBX009Test2(){
        
        // Load Environment Variables   
        //DataUtilTest.loadEnvironmentVariables();        
        
        Test.startTest();
        
        Process__c pr = GMPLBX009TriggerTest.createProcess();
        GMPL_BX009__c gmpl = GMPLBX009TriggerTest.createGMPL2();
        gmpl.Project_Code__c = 'Test Project Code';
        gmpl.New_Process_ID__c = pr.Id;
        gmpl.Productization__c = true;
        gmpl.Productization_Acknowledgement__c = true;
        gmpl.Product_Start_Date__c = String.valueOf(System.Today().year()+1);
        GMPL_GMPLAfterOperationHandler.isExecuted = false;        
        update gmpl;
        
        gmpl = [select  Project__c
                        , Program_Name__c
                        , BX009_Status__c
                from    GMPL_BX009__c
                where   Id = :gmpl.Id
               ];
        
        //system.assertEquals(gmpl.Project__c, '10');
        //system.assertEquals(gmpl.Program_Name__c, '10-FAB 1');
        //system.assertEquals(gmpl.BX009_Status__c,'Project Kick Off');
        
        Test.stopTest();
        
    }
    
    static testMethod void createGMPLBX009Test3(){
        
        // Load Environment Variables   
        //DataUtilTest.loadEnvironmentVariables();
               
        //List<Account> acctList = GMPLBX009TriggerTest.createAccount1();
        Process__c pr = GMPLBX009TriggerTest.createProcess();
        
        Test.startTest();
        
        GMPL_BX009__c gmpl = GMPLBX009TriggerTest.createGMPL3(getAccount('MYTEST ACCOUNT1').id);
        PPE_Team__c pT = GMPLBX009TriggerTest.createPPETeamMember(gmpl.Id, UserInfo.getUserId(), 'Team Member');
        gmpl.BCCB_Disposition__c = 'Approved to BX009';
        gmpl.Account__c = getAccount('MYTEST ACCOUNT2').id;
        update gmpl;
        
        gmpl = [select  BX009_Status__c
                from    GMPL_BX009__c
                where   Id = :gmpl.Id
               ];
        
        system.assertEquals(gmpl.BX009_Status__c,'BCCB Approved');
        
        Test.stopTest();
        
    }
    
    static testMethod void createGMPLBX009Test4(){
        
        // Load Environment Variables   
        //DataUtilTest.loadEnvironmentVariables();
        
        Test.startTest();
        User u = GMPLBX009TriggerTest.createUser();
        GMPL_BX009__c gmpl = GMPLBX009TriggerTest.createGMPL4();
        gmpl.Productization__c = true;
        gmpl.Productization_Acknowledgement__c = true; 
        gmpl.BX009_Status__c = 'Project Kick Off';

        system.runas(u){
            try{
                update gmpl;    
            }catch(Exception e){
                //system.assert(e.getMessage().contains('Please provide PA code and New Process ID to make BX009 Status to \'Project Kick Off\'.'));
            }
        }
        
        Test.stopTest();
        
    }
    
    static testMethod void createGMPLBX009Test5(){
        
        // Load Environment Variables   
        //DataUtilTest.loadEnvironmentVariables();
        
        Test.startTest();
        User u = GMPLBX009TriggerTest.createUser();
        Process__c pr = GMPLBX009TriggerTest.createProcess();
        GMPL_BX009__c gmpl = GMPLBX009TriggerTest.createGMPL5();    
        gmpl.CE_Admin_Complete__c = true;
        gmpl.Project_Code__c = 'Test Project Code';
        gmpl.New_Process_ID__c = pr.Id;
        gmpl.Productization__c = true;
        gmpl.Productization_Acknowledgement__c = true;   
        system.runas(u){
            try{
                update gmpl;
            }catch(Exception e){
                //system.assert(e.getMessage().contains('BX009 Status can be modified to Complete only by PPM/CE Admin/PM Team members.'));
            }
        }
        gmpl = [select  BX009_Status__c
                from    GMPL_BX009__c
                where   Id = :gmpl.Id
               ];
        
        //system.assertEquals(gmpl.BX009_Status__c,'Completed');
        
        Test.stopTest();
        
    }
    
    static testMethod void createGMPLBX009Test6(){
        
        // Load Environment Variables   
        //DataUtilTest.loadEnvironmentVariables();
        
        User u = GMPLBX009TriggerTest.createUser();
        
        GMPL_BX009__c gmpl = GMPLBX009TriggerTest.createGMPL5();
        
        PPE_Team__c pT = GMPLBX009TriggerTest.createPPETeamMember(gmpl.Id, u.Id, 'Team Member');
        
        Test.startTest();       
        
        system.runAs(u){
            try{   
                gmpl.CE_Admin_Complete__c = true;   
                update gmpl;
            }catch(Exception e){
                system.assert(e.getMessage().contains('BX009 Status can be modified to Complete only by PPM/CE Admin/PM Team members.'));
            }
        }
        
        Test.stopTest();
        
    }
    
    static testMethod void gmplBX009NotificationTest(){
        
        GMPL_BX009__c gmpl = GMPLBX009TriggerTest.createGMPL5();
        
        PPE_Team__c pT = GMPLBX009TriggerTest.createPPETeamMember(gmpl.Id, UserInfo.getUserId(), 'Account Manager');
        
        Test.startTest();   
            gmpl.Consigned_Wafer__c = true;
            gmpl.SQE_Acknowledgement__c = true;
            gmpl.Productization__c = true;
            gmpl.Productization_Acknowledgement__c = true;
            gmpl.Product_Process__c = true;
            gmpl.Process_Acknowledgement__c = true;
            gmpl.Turnkey__c = true;
            gmpl.Turnkey_Acknowledgement__c = true;   
            update gmpl;      
        Test.stopTest();
        
    }
    
    static testMethod void gmplBX009NotificationForProcessTest(){
        
        GMPL_BX009__c gmpl = GMPLBX009TriggerTest.createGMPL5();
        
        PPE_Team__c pT = GMPLBX009TriggerTest.createPPETeamMember(gmpl.Id, UserInfo.getUserId(), 'Process BX009');
        
        Test.startTest();
            gmpl.Product_Process__c = true;
            update gmpl;      
        Test.stopTest();
        
    }
    
    static testMethod void gmplBX009NotificationForProductizationTest(){
        
        GMPL_BX009__c gmpl = GMPLBX009TriggerTest.createGMPL5();
        
        PPE_Team__c pT = GMPLBX009TriggerTest.createPPETeamMember(gmpl.Id, UserInfo.getUserId(), 'Productization BX009');
        
        Test.startTest();
            gmpl.Productization__c = true; 
            update gmpl;      
        Test.stopTest();
        
    }
    
    static testMethod void gmplBX009NotificationForTurnkeyTest(){
        
        GMPL_BX009__c gmpl = GMPLBX009TriggerTest.createGMPL5();
        
        PPE_Team__c pT = GMPLBX009TriggerTest.createPPETeamMember(gmpl.Id, UserInfo.getUserId(), 'Turnkey BX009');
        
        Test.startTest();
            gmpl.Turnkey__c = true;
            update gmpl;      
        Test.stopTest();
        
    }
    
    static testMethod void gmplBX009NotificationForSQETest(){
        
        GMPL_BX009__c gmpl = GMPLBX009TriggerTest.createGMPL5();
        
        PPE_Team__c pT = GMPLBX009TriggerTest.createPPETeamMember(gmpl.Id, UserInfo.getUserId(), 'SQE BX009');
        
        Test.startTest();
            gmpl.Consigned_Wafer__c = true; 
            update gmpl;      
        Test.stopTest();
        
    }
    
    static testMethod void gmplBX009EmailForBX009StatusTest1(){
        
        GMPL_BX009__c gmpl = GMPLBX009TriggerTest.createGMPL5();
        gmpl.BCCB_Disposition__c = 'Approved to BX009';
        update gmpl;
        
        gmpl.BX009_Status__c = 'Regional / Marketing Business Analysis';
        update gmpl;
       
        PPE_Team__c pT = GMPLBX009TriggerTest.createPPETeamMember(gmpl.Id, UserInfo.getUserId(), 'SQE BX009');
        
        Test.startTest();
            gmpl.BX009_Status__c = 'BCCB Approved'; 
            GMPLBX009NotificationEmail.hasRun = false;
            update gmpl;      
        Test.stopTest();
        
    }
    
    static testMethod void gmplBX009EmailForBX009StatusTest2(){
        
        GMPL_BX009__c gmpl = GMPLBX009TriggerTest.createGMPL5();
        
        PPE_Team__c pT = GMPLBX009TriggerTest.createPPETeamMember(gmpl.Id, UserInfo.getUserId(), 'SQE BX009');
        
        Test.startTest();
            gmpl.BX009_Status__c = 'BRB Review'; 
            update gmpl;      
        Test.stopTest();
        
    }
    
    static testMethod void gmplBX009EmailForBX009StatusTest3(){
        
        GMPL_BX009__c gmpl = GMPLBX009TriggerTest.createGMPL5();
        
        PPE_Team__c pT = GMPLBX009TriggerTest.createPPETeamMember(gmpl.Id, UserInfo.getUserId(), 'Project Lead');
        
        Test.startTest();
            gmpl.BRB_Decision__c = 'test';
            gmpl.Consigned_Wafer__c = true;
            gmpl.SQE_Acknowledgement__c = true;
            gmpl.BX009_Status__c = 'BRB Approved'; 
            update gmpl;      
        Test.stopTest();
        
    }
    
    static testMethod void gmplBX009EmailForBX009StatusTest4(){
        
        GMPL_BX009__c gmpl = GMPLBX009TriggerTest.createGMPL5();
        
        PPE_Team__c pT = GMPLBX009TriggerTest.createPPETeamMember(gmpl.Id, UserInfo.getUserId(), 'Project Lead');
        Process__c pr = GMPLBX009TriggerTest.createProcess();
        gmpl.Project_Code__c = 'test PA Code';
        gmpl.New_Process_ID__c = pr.Id;
        gmpl.Consigned_Wafer__c = true;
        gmpl.SQE_Acknowledgement__c = true;
        update gmpl;
        
        Test.startTest();
            gmpl.CE_Admin_Complete__c = true;
            GMPLBX009NotificationEmail.hasRun = false; 
            update gmpl;
                  
        Test.stopTest();
        
    }
    
    static testMethod void gmplBX009EmailForProdStartDateTest(){
        
        GMPL_BX009__c gmpl = GMPLBX009TriggerTest.createGMPL5();
        
        PPE_Team__c pT = GMPLBX009TriggerTest.createPPETeamMember(gmpl.Id, UserInfo.getUserId(), 'Project Lead');
        
        Test.startTest();
            gmpl.Product_Start_Date__c = String.valueOf(System.today().year()); 
            update gmpl;      
        Test.stopTest();
        
    }
    
    static testMethod void gmplBX009EmailForCustAgreedTest(){
        
        GMPL_BX009__c gmpl = GMPLBX009TriggerTest.createGMPL5();
        
        PPE_Team__c pT = GMPLBX009TriggerTest.createPPETeamMember(gmpl.Id, UserInfo.getUserId(), 'Project Lead');
        
        Test.startTest();
            gmpl.Has_customer_agreed_with_GLOBALFOUNDRIES__c = 'Yes'; 
            update gmpl;      
        Test.stopTest();
        
    }
    
    static testMethod void gmplBX009EmailForRevForecastTest(){
        
        GMPL_BX009__c gmpl = GMPLBX009TriggerTest.createGMPL5();
        
        PPE_Team__c pT = GMPLBX009TriggerTest.createPPETeamMember(gmpl.Id, UserInfo.getUserId(), 'Project Lead');        
                
        Revenue_Forecast__c revenueObj = new Revenue_Forecast__c();
        revenueObj.Year__c = String.valueOf(System.today().year());
        revenueObj.GMPL_BX009__c = gmpl.Id;
        revenueObj.Average_Sales_Price__c=0.0;
        revenueObj.Quantity__c=0;       
        insert revenueObj;
        
        Test.startTest();
            revenueObj.Average_Sales_Price__c = 100.0;
            revenueObj.Quantity__c = 20;
            GMPLBX009NotificationEmail.hasRun = false;
            update revenueObj;      
        Test.stopTest();
        
    }
    
    private static Account getAccount(string AccountName)
    {
        Account acct = [SELECT Id, Name FROM Account Where Name =: AccountName];        
        return acct;
    }
}