/*
 Type Name: ClsTeamRoomTriggerHandlerTest
 Author: Cognizant Technology Solutions
 Created Date: 22-July-2013
 Reason: This is the test class for 'ClsTeamRoomTriggerHandler' class.
 Change History:
 Author: 
 Modified Date: 
 Reason: 
 …….. 
 ……..
    Nbustillos  10122013    - Added call to loadEnvironmentVariables() method.
    Ashwini     05142015    - Updated code for refactoring of test class.
*/

@isTest(seeAllData=false)
private class ClsTeamRoomTriggerHandlerTest{
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
 static testMethod void ClsTeamRoomTriggerHandlerTest() {
    
        // Load Environment Variables   
        //DataUtilTest.loadEnvironmentVariables();
 
    Profile profileObj = [Select Name,Id from Profile where Name = 'Customer Portal Admin'];
    Profile profileObj1 = [Select Name,Id from Profile where Name = 'System Administrator'];
    User userObj = new User();
    User userObj1 = new User();
    Account acctObj = new Account();
    Contact conobj=new Contact();
    Team_Room__c teamRoomObj = new Team_Room__c();
    Team_Room__c teamRoomObj1 = new Team_Room__c();
    List<Team_Room__c> teamroomList=new List<Team_Room__c>();
    List<Team_Room__c> teamroomList1=new List<Team_Room__c>();
    List<Id> profileIdList=new List<Id>();
    
    profileIdList.add(profileObj.Id);
           
            
    userObj1.Alias = 'YJohn1';
    userObj1.Email='YJohn1@test.com'; 
    userObj1.EmailEncodingKey='UTF-8'; 
    userObj1.LastName='Paul';
    userObj1.LanguageLocaleKey='en_US'; 
    userObj1.LocaleSidKey='en_US';
    userObj1.ProfileId = profileObj1.Id;
    userObj1.TimeZoneSidKey='America/Los_Angeles'; 
    userObj1.UserName='YJohn1@test.com';
    
    userObj1.IsActive = true;
                
    insert userObj1;

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
    
    System.runAs(userObj)
    {        
    teamRoomObj.Team_Room_Administrator__c = userObj.Id;
    teamRoomObj.Name ='Team Room 1';
    teamRoomObj.Team_Room_Description__c = 'Team Room Description';
    teamRoomObj.Terms_n_Conditions_Accepted__c = true;
    teamroomObj.Primary_Account__c = acctObj.Id;//added by cognizant on 16th March 2015
    teamroomList.add(teamRoomObj);
    Test.startTest();
    insert teamroomList;    
    system.assertEquals(teamRoomObj.Name,'Team Room 1'); 
        ClsTeamRoomTriggerHandler.setTeamRoomOwner(teamroomList);
        ClsTeamRoomTriggerHandler.addCorresAccount(teamroomList,profileIdList);
        Test.stopTest();    
        
    }    
  }     
 
    private static Account getAccount(string AccountName)
    {
        Account acct = [SELECT Id, Name FROM Account Where Name =: AccountName];
        
        return acct;
    }
 }