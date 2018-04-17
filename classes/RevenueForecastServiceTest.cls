/*
    Author: Anirban Roy
    Description: This is the test class for the RevenueForecastService class.  
    History:
        ARoy        04142014    - code creation.
        DBiswal     04152015    - Updated code for making SeeAllData=false and refactoring of test class.
*/

@isTest(SeeAllData=false)
public class RevenueForecastServiceTest {
    
    @testSetup static void testdata() {
        DataUtilTest.loadEnvironmentVariables();
        Map<String,Object> fieldValueMap = new Map<String,Object>();
        fieldValueMap.put('Name', 'MYTEST ACCOUNT1');            
        fieldValueMap.put('Account_Manager__c', userinfo.getuserid());        
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
        fieldValueMap.put('recordtypeid', EnvironmentVariable.get('ACCT_RT_ID_CUSTOMER'));
            
        Account acc = AccountDataFactory.createAccount(fieldValueMap);        
        Environment_Variable__c env = [select id,name,value__c from Environment_Variable__c where name='HCM Emp AccountId'];
        env.value__c=acc.Id;
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
        Profile p = [select id from Profile where name = 'GF Finance'];
        User u = new User(alias = 'ts2002', email='test2002@test.com',
                          emailencodingkey='UTF-8', lastname='TestLast2002', firstname='TestFirst2002', languagelocalekey='en_US',
                          localesidkey='en_US',timezonesidkey='America/Los_Angeles', username='test2002@test.com',communitynickname='ts2002',
                          profileid = p.Id,FederationIdentifier='Test2002');
        insert u;
        return u;
    }        
    
    // Creation of GMPL/BX009
    static GMPL_BX009__c createGMPL(){
        GMPL_BX009__c gmplBX009 = new GMPL_BX009__c();
        gmplBX009.Product_Start_Date__c = String.valueOf(System.Today().year());
        insert gmplBX009;
        return gmplBX009;
    }
    
    // Creation of PPE Team
    static PPE_Team__c createPPETeam(Id gmplId, Id userId){
        PPE_Team__c pT = new PPE_Team__c(GMPL_BX009__c = gmplId, 
                                    PPE_Role__c = 'Team Member', User__c = userId, Access_Level__c = 'Read Only');      
        
        insert pT;
        return pT;
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
    
    // Test Method using System Admin user to reset revenue forecast
    static testMethod void resetRevenueForecastTest1(){
        
        // Load Environment Variables   
        //DataUtilTest.loadEnvironmentVariables();          
        GMPL_BX009__c gmplBX009Obj = RevenueForecastServiceTest.createGMPL();
        RevenueForecastServiceTest.updateRevenueForecast(gmplBX009Obj.Id);
        
        String retMsg = RevenueForecastService.resetForecast(gmplBX009Obj.Id);
        system.assertEquals(retMsg, 'OK');
    }
    
    // Test Method using GF Finance user to reset revenue forecast
    static testMethod void resetRevenueForecastTest2(){
        
        // Load Environment Variables   
        //DataUtilTest.loadEnvironmentVariables();
        User usr = RevenueForecastServiceTest.createUser();         
        GMPL_BX009__c gmplBX009Obj = RevenueForecastServiceTest.createGMPL();
        PPE_Team__c pT = RevenueForecastServiceTest.createPPETeam(gmplBX009Obj.Id, usr.Id);
        RevenueForecastServiceTest.updateRevenueForecast(gmplBX009Obj.Id);
        
        system.runAs(usr){
            String retMsg = RevenueForecastService.resetForecast(gmplBX009Obj.Id);
            system.assertEquals(retMsg, 'User is having Read Only access on GMPL/BX009 record.');
        }
        
    }
    
    // Test Method using GF Finance user to reset revenue forecast
    static testMethod void resetRevenueForecastTest3(){
        
        // Load Environment Variables   
        //DataUtilTest.loadEnvironmentVariables();
        User usr = RevenueForecastServiceTest.createUser();         
        
        System.runAs(usr){
            Test.startTest();
                Group grp = [select id from group where developername = 'PPM_Team_Group'];
                GroupMember gm = new GroupMember(GroupId = grp.Id, UserOrGroupId = usr.Id);
                insert gm;
            Test.stopTest();
        }
        
        GMPL_BX009__c gmplBX009Obj = RevenueForecastServiceTest.createGMPL();
        PPE_Team__c pT = RevenueForecastServiceTest.createPPETeam(gmplBX009Obj.Id, usr.Id);
        RevenueForecastServiceTest.updateRevenueForecast(gmplBX009Obj.Id);
        
        system.runAs(usr){
            String retMsg = RevenueForecastService.resetForecast(gmplBX009Obj.Id);
            //system.assertEquals(retMsg, 'OK');
        }
        
    }
    
}