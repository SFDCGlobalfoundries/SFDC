/*
 Type Name: ClsMailUtilityTest
 Author: Cognizant Technology Solutions
 Created Date: 11-July-2013
 Reason: This is the test class for 'ClsMailUtilityTest' class.
 Change History:
 Author: 
 Modified Date: 
 Reason: 
 …….. 
 ……..
    Nbustillos  10122013    - Added call to loadEnvironmentVariables() method.
    Ashwini     05132015    - Updated code for refactoring of test class.
*/

@isTest
private class ClsMailUtilityTest {
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
     static testMethod void testClsMailUtility() {
        
        Profile profileObj = [Select Name,Id from Profile where Name = 'Customer Portal Admin'];
         RecordType recordtypeobj=[Select Id from Recordtype where DeveloperName='External_Single_party'];
         User userObj = new User();
         Account acctObj = getAccount('MYTEST ACCOUNT1');
         Contact conobj=new Contact();
         Team_Room__c teamroomObj = new Team_Room__c();
         Team_Room_Meeting__c trmObj = new Team_Room_Meeting__c();
         Team_Room_Member__c teamroommemberObj = new Team_Room_Member__c ();
         GF_Meeting_Occurrence__c occurrenceObj = new GF_Meeting_Occurrence__c();
         GF_Meeting_Invitee__c inviteeObj = new GF_Meeting_Invitee__c();
         
           
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
        userObj.UserName='john@success.com';
        userObj.Portal_Login__c = 'xyz';
        userObj.contactId = conobj.Id;
        userObj.IsActive = true;
                    
        insert userObj;
        
     
        teamroomObj.Name = 'CTS Testing TR-1';
        teamroomObj.Team_Room_Description__c = 'This is a Team Room';
        teamroomObj.RecordTypeId=recordtypeobj.Id;
        teamroomObj.Primary_Account__c=acctObj.id;

        insert teamroomObj;
         
         
        teamroommemberObj.User__c = userObj.Id;
        teamroommemberObj.Team_Room__c = teamroomObj.Id;
        Test.startTest();
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
        system.assertEquals(occurrenceObj.Status__c,'Open'); 
        inviteeObj.User__c = userObj.Id;
        inviteeObj.Team_Room_Meeting__c = trmObj.Id;
        
        insert inviteeObj;
       
            System.runAs(userObj)
            {                 
                String operation = 'Cancel';
                String email = 'john@test.com';
                List <String> emailids = new List<String>();
                emailids.add(email);
                
                String meetingtopic = 'Topic 1';
                String meetingDate = '12-12-2013';
                String meetingOccStartDateTime = '12-12-2013 11:00 PM';
                String meetingOccEndDateTime = '12-12-2013 11:30 PM';
                String subject = 'Subject 1';
                String teamRoomname = 'Team Room1' ;        
                String teamRoomowner = userObj.Id;
                String teamMeetingId = trmObj.Id;
                datetime startdate=null;
                datetime enddate=null;
                String agenda='new agenda';
                String Status='Open';
                
                ClsMailUtility.sendMail(operation,emailids,meetingtopic,meetingDate,meetingOccStartDateTime,meetingOccEndDateTime,subject,teamRoomname,teamRoomowner,teamMeetingId,startdate,enddate,agenda,Status);
                
                String operation1 = 'Reschedule';
                String email1 = 'bb@aa.com';
                List <String> emailids1 = new List<String>();
                emailids.add(email1);
                
                String meetingtopic1 = 'Topic 2';
                String meetingDate1 = '12-2-2013';
                String meetingOccStartDateTime1 = '12-12-2013 11:00 PM';
                String meetingOccEndDateTime1 = '12-12-2013 11:30 PM';
                String subject1 = 'Subject 2';   
                String teamRoomname1 = 'Team Room2' ;        
                String teamRoomowner1 = userObj.Id;
                String teamMeetingId1 = trmObj.Id;
                datetime startdate1=null;
                datetime enddate1=null;
                String agenda1='new agenda';
                String Status1='Open';
                
                ClsMailUtility.sendMail(operation1,emailids1,meetingtopic1,meetingDate1,meetingOccStartDateTime1,meetingOccEndDateTime1,subject1,teamRoomname1,teamRoomowner1,teamMeetingId1,startdate1,enddate1,agenda1,Status1);
                
                String operation2 = 'SendMeetingInvitee';
                String email2 = 'bb@aa.com';
                List <String> emailids2 = new List<String>();
                emailids.add(email2);
                
                String meetingtopic2 = 'Topic 2';
                String meetingDate2 = '12-2-2013';
                String meetingOccStartDateTime2 = '12-12-2013 11:00 PM';
                String meetingOccEndDateTime2 = '12-12-2013 11:30 PM';
                String subject2 = 'Subject 2';                
                String teamRoomname2 = 'Team Room2' ;        
                String teamRoomowner2 = userObj.Id;
                String teamMeetingId2 = trmObj.Id;
                datetime startdate2=null;
                datetime enddate2=null;
                String agenda2='new agenda';
                String Status2='Open';
                ClsMailUtility.sendMail(operation2,emailids2,meetingtopic2,meetingDate2,meetingOccStartDateTime2,meetingOccEndDateTime2,subject2,teamRoomname2,teamRoomowner2,teamMeetingId2,startdate2,enddate2,agenda2,Status2);

                String operation3 = 'SendMeetingNotes';
                String email3 = 'bb@aa.com';
                List <String> emailids3 = new List<String>();
                emailids.add(email3);
                
                String meetingtopic3 = 'Topic 2';
                String meetingDate3 = '12-2-2013';
                String meetingOccStartDateTime3 = '12-12-2013 11:00 PM';
                String meetingOccEndDateTime3 = '12-12-2013 11:30 PM';
                String subject3 = 'Subject 3';                
                String teamRoomname3 = 'Team Room3' ;        
                String teamRoomowner3 = userObj.Id;
                String teamMeetingId3 = trmObj.Id;
                datetime startdate3=null;
                datetime enddate3=null;
                String agenda3='new agenda';
                String Status3='Open';
                ClsMailUtility.sendMail(operation3,emailids3,meetingtopic3,meetingDate3,meetingOccStartDateTime3,meetingOccEndDateTime3,subject3,teamRoomname3,teamRoomowner3,teamMeetingId3,startdate3,enddate3,agenda3,Status3);


                String operation4 = 'TeamRoomInsert';
                String email4 = 'bb@aa.com';
                List <String> emailids4 = new List<String>();
                emailids.add(email4);
                
                String meetingtopic4 = 'Topic 2';
                String meetingDate4 = '12-2-2013';
                String meetingOccStartDateTime4 = '12-12-2013 11:00 PM';
                String meetingOccEndDateTime4 = '12-12-2013 11:30 PM';
                String subject4 = 'Subject 2';                
                String teamRoomname4 = 'Team Room3';        
                String teamRoomowner4= userObj.Id;
                String teamMeetingId4 = trmObj.Id;
                datetime startdate4=null;
                datetime enddate4=null;
                String agenda4='new agenda';
                String Status4='Open';
                
                ClsMailUtility.sendMail(operation4,emailids4,meetingtopic4,meetingDate4,meetingOccStartDateTime4,meetingOccEndDateTime4,subject4,teamRoomname4,teamRoomowner4,teamMeetingId4,startdate4,enddate4,agenda4,Status4);
                
                String operation5 = 'TRMeetingCancel';
                String email5 = 'bb@aa.com';
                List <String> emailids5 = new List<String>();
                emailids.add(email5);
                
                String meetingtopic5 = 'Topic 2';
                String meetingDate5 = '12-2-2013';
                String meetingOccStartDateTime5 = '12-12-2013 11:00 PM';
                String meetingOccEndDateTime5 = '12-12-2013 11:30 PM';
                String subject5 = 'Subject 2';                
                String teamRoomname5 = 'Team Room3';        
                String teamRoomowner5= userObj.Id;
                String teamMeetingId5 = trmObj.Id;
                datetime startdate5=null;
                datetime enddate5=null;
                String agenda5='new agenda';
                String Status5='Open';
                
                ClsMailUtility.sendMail(operation5,emailids5,meetingtopic5,meetingDate5,meetingOccStartDateTime5,meetingOccEndDateTime5,subject5,teamRoomname5,teamRoomowner5,teamMeetingId5,startdate5,enddate5,agenda5,Status5);

                Test.stopTest();    
            
            }  
        
    }
    
    private static Account getAccount(string AccountName)
    {
        Account acct = [SELECT Id, Name FROM Account Where Name =: AccountName];
        
        return acct;
    }
}