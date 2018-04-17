/*
 Type Name: ClsTeamRoomControllerTest
 Author: Cognizant Technology Solutions
 Created Date: 11-June-2013
 Reason: This is the test class for 'ClsTeamRoomController' class.
 Change History:
 Author: 
 Modified Date: 
 Reason: 
 …….. 
 ……..
*/

@isTest
private class ClsTempTeamRoomControllerTest {
    
    @testSetup static void testdata() {
        DataUtilTest.loadEnvironmentVariables();
                
        Map<String,Object> fieldValueMap = new Map<String,Object>();
        fieldValueMap.put('Name', 'MYTEST ACCOUNT1');                            
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
    static testMethod void testClsTempTeamRoomController() {

            Profile profileObj = [Select Name,Id from Profile where Name = 'Customer Portal Admin'];
            User userObj = new User();
            Account acctObj = new Account();
            Contact conobj=new Contact();
            Team_Room__c teamRoomObj = new Team_Room__c();
            
            acctObj = getAccount('MYTEST ACCOUNT1');
            
            conobj.FirstName='Mr';
            conobj.LastName='Testcon1';
            conobj.AccountId=acctObj.Id;
            conobj.Email='con1@gf.com';
            conobj.Department__c='Design';
                                      
            insert conobj;
            
            userObj.Alias = 'John';
            userObj.Email='John@test.com'; 
            userObj.EmailEncodingKey='UTF-8'; 
            userObj.LastName='Paul';
            userObj.LanguageLocaleKey='en_US'; 
            userObj.LocaleSidKey='en_US';
            userObj.ProfileId = profileObj.Id;
            userObj.TimeZoneSidKey='America/Los_Angeles'; 
            userObj.UserName='John@test.com';
            userObj.Portal_Login__c = 'xyz1';
            userObj.contactId = conobj.Id;
            userObj.IsActive = true;
                        
            insert userObj;
            
            teamRoomObj.Team_Room_Administrator__c = userObj.Id;
            teamRoomObj.Name ='Team Room 1';
            teamRoomObj.Team_Room_Description__c = 'Team Room Description';
            //teamRoomObj.Team_Room_Type__c = 'External Multi party';
            teamRoomObj.Terms_n_Conditions_Accepted__c = true;
            teamroomObj.Primary_Account__c = acctObj.Id;//added by cognizant on 16th March 2015
            
            insert teamRoomObj;
                    
            System.runAs(userObj)
            {
            
                Test.startTest();
                ClsTempTeamRoomController  clsTempTeamRoomControllerObj = new ClsTempTeamRoomController(new ApexPages.StandardController(teamRoomObj));
                clsTempTeamRoomControllerObj.redirectAcceptPage();
                Test.stopTest();    
                
            }   

    }
    
    private static Account getAccount(string AccountName)
    {
        Account acct = [SELECT Id, Name FROM Account Where Name =: AccountName];
        
        return acct;
    }
}