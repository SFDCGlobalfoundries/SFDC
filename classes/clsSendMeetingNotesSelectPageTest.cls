/*
 Type Name: clsSendMeetingNotesSelectPageTest
 Author: Cognizant Technology Solutions
 Created Date: 11-July-2013
 Reason: This is the test class for 'clsGFCalendarComponentController' class.
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
private class clsSendMeetingNotesSelectPageTest {
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
    static testMethod void testclsSendMeetingNotesSelectPage() {
       
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
			system.assertEquals(teamroomObj.Name,'CTS Testing TR-1');
			                         	
            teamroommemberObj.User__c = userObj.Id;
            teamroommemberObj.Team_Room__c = teamroomObj.Id;
            Test.startTest();
            insert  teamroommemberObj;
            
            trmObj.Team_Room__c = teamroomObj.Id;
            trmObj.Subject__c = 'Project Status';
            trmObj.Agenda__c = 'Project Status';
            trmObj.Status__c='Open';
            trmObj.Start_DateTime__c = System.today().addDays(+1);
            trmObj.End_DateTime__c =  System.now().addDays(+3);
            trmObj.MonthlyRecurrence__c = '23';
            insert trmObj;
            
            occurrenceObj.Team_Room_Meeting__c = trmObj.Id;
            occurrenceObj.Status__c='Open';
            occurrenceObj.Agenda__c = 'Project Status';
            occurrenceObj.Meeting_Notes__c='This is a test mail mail body for test class';
            occurrenceObj.Start_Time__c=System.today().addDays(+1);
            occurrenceObj.End_Time__c=System.today().addDays(+1);
            insert occurrenceObj;
             
            inviteeObj.User__c = userObj.Id;
            inviteeObj.Team_Room_Meeting__c = trmObj.Id;
            insert inviteeObj;
            
            
            
            //String pProviders='clsTaskGFCalActivityProvider,clsMeetingOccuranceGFCalActivityProvider,clsActivityHistoryGFCalActivityProvider';        
            //System.runAs(userObj)
            //{
                Test.setCurrentPageReference(new PageReference('Page.VFSendMeetingNotesSelectPage')); 
                System.currentPageReference().getParameters().put('id', String.valueOf(trmObj.id));
                clsSendMeetingNotesSelectPage.WrapperclsSendMeetingNotes wsmn= new clsSendMeetingNotesSelectPage.WrapperclsSendMeetingNotes();
                clsSendMeetingNotesSelectPage.wrapperMeetingOccurrence wmo= new clsSendMeetingNotesSelectPage.wrapperMeetingOccurrence();
                clsSendMeetingNotesSelectPage clsSendMeetingNotesSelectPageObj= new clsSendMeetingNotesSelectPage(new ApexPages.StandardController(trmObj));
                System.currentPageReference().getParameters().put('MeetoccID', String.valueOf(occurrenceObj.id));
                clsSendMeetingNotesSelectPageObj.setWrapperMORadio();
                clsSendMeetingNotesSelectPageObj.saveMeetingOccurrence();
                clsSendMeetingNotesSelectPageObj.addUsersFromTeamRoomMeeting(occurrenceObj);
                clsSendMeetingNotesSelectPageObj.NewEmail='xyx@test.com,yyy@test.com';
                clsSendMeetingNotesSelectPageObj.addNewUser();
                clsSendMeetingNotesSelectPageObj.addmore();
                clsSendMeetingNotesSelectPageObj.addmore();
                clsSendMeetingNotesSelectPageObj.addmore();
                clsSendMeetingNotesSelectPageObj.addmore();
                clsSendMeetingNotesSelectPageObj.addmore();
                
                clsSendMeetingNotesSelectPageObj.SendEmail();
                System.currentPageReference().getParameters().put('countRow', String.valueOf(1));
                clsSendMeetingNotesSelectPageObj.removeUser();
                Test.stopTest();    
            
            //}        
        
    }
    
    private static Account getAccount(string AccountName)
    {
        Account acct = [SELECT Id, Name FROM Account Where Name =: AccountName];
        
        return acct;
    }
}