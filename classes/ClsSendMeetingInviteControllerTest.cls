/*
 Type Name: ClsSendMeetingInviteControllerTest
 Author: Cognizant Technology Solutions
 Created Date: 16-Aug-2013
 Reason: This is the test class for 'ClsSendMeetingInviteController' class.
 Change History:
 Author: 
 Modified Date: 
 Reason: 
 …….. 
 ……..
    Nbustillos  10122013    - Added call to loadEnvironmentVariables() method.
    Ashwini     05142015    - Updated code for refactoring of test class.
*/

@isTest
private class ClsSendMeetingInviteControllerTest
{
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
    static testmethod void testClsSendMeetingInviteController()
    {
        // Load Environment Variables   
        //DataUtilTest.loadEnvironmentVariables();
        
     User thisUser = [SELECT Id FROM User WHERE Id = :UserInfo.getUserId()];
       Profile profileObj = [Select Name,Id from Profile where Name = 'Customer Portal Admin'];
         User userObj = new User();
         Account acctObj = getAccount('MYTEST ACCOUNT1');
         Contact conobj=new Contact();
         Team_Room__c teamroomObj = new Team_Room__c();
         Team_Room_Meeting__c trmObj = new Team_Room_Meeting__c();
         Team_Room_Member__c teamroommemberObj = new Team_Room_Member__c ();
         GF_Meeting_Occurrence__c occurrenceObj = new GF_Meeting_Occurrence__c();
         GF_Meeting_Invitee__c inviteeObj = new GF_Meeting_Invitee__c();
         String Name = 'John';
         
         
        conobj.FirstName='Mr';
        conobj.LastName='Testcon1';
        conobj.AccountId=acctObj.Id;
        conobj.Email='con1@gf.com';
        conobj.Department__c='Design';
                                      
        insert conobj;
        
        
        userObj.Alias = 'John';
        userObj.Email='john@test.com'; 
        userObj.EmailEncodingKey='UTF-8'; 
        userObj.LastName='Paul';
        userObj.LanguageLocaleKey='en_US'; 
        userObj.LocaleSidKey='en_US';
        userObj.ProfileId = profileObj.Id;
        userObj.TimeZoneSidKey='America/Los_Angeles'; 
        userObj.UserName='john@test.com';
        userObj.Portal_Login__c = 'xyz';
        userObj.contactId = conobj.Id;
        userObj.IsActive = true;
                    
        insert userObj;
        
     
        teamroomObj.Name = 'CTS Testing TR-1';
        teamroomObj.Team_Room_Description__c = 'This is a Team Room';
        teamroomObj.Primary_Account__c = acctObj.Id;//added by cognizant on 16th March 2015
        insert teamroomObj;
         
         
        teamroommemberObj.User__c = thisUser.Id;
        teamroommemberObj.Team_Room__c = teamroomObj.Id;
        insert  teamroommemberObj;
        
        trmObj.Team_Room__c = teamroomObj.Id;
        trmObj.Subject__c = 'Project Status';
        trmObj.Agenda__c = 'Project Status';
        trmObj.Status__c='Open';
        trmObj.MonthlyRecurrence__c = '23';
        insert trmObj;
        
        occurrenceObj.Team_Room_Meeting__c = trmObj.Id;
        occurrenceObj.Status__c='Open';
        occurrenceObj.Agenda__c = 'Project Status';
        insert occurrenceObj;
        Test.startTest(); 
        inviteeObj.User__c = thisUser.Id;
        inviteeObj.Team_Room_Meeting__c = trmObj.Id;
        insert inviteeObj;
        
        System.runAs(thisUser)
        {                     
             ApexPages.currentPage().getParameters().put('id', trmObj.Id);
             ApexPages.StandardController controller = new ApexPages.StandardController(trmObj) ;
             
             ClsSendMeetingInviteController sendMeetingInviteeObj = new ClsSendMeetingInviteController(controller);
             sendMeetingInviteeObj.sendmail();
             sendMeetingInviteeObj.cancelSendingMail();
             trmObj.Status__c = 'Cancelled';
             update trmObj;
             ClsSendMeetingInviteController sendMeetingInviteeObj1 = new ClsSendMeetingInviteController(controller);
             Test.stopTest();
             
             System.assertEquals('Cancelled',trmObj.Status__c);
             
             
        }
    }
    
    private static Account getAccount(string AccountName)
    {
        Account acct = [SELECT Id, Name FROM Account Where Name =: AccountName];
        
        return acct;
    }
}