/*
 Type Name: ClsTeamRoomMeetingExtensionTest
 Author: Cognizant Technology Solutions
 Created Date: 14-Aug-2013
 Reason: This is the test class for 'ClsTeamRoomMeetingExtension' class.
 Change History:
 Author: 
 Modified Date: 
 Reason: 
 …….. 
 ……..
    Nbustillos  10122013    - Added call to loadEnvironmentVariables() method.
     Ashwini     04072015    - Refactoring test class.
*/

@isTest
private class ClsTeamRoomMeetingExtensionTest
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
      /**
        This method is used to test the ClsTeamRoomMeetingExtension class at the time of team room meeting creation.
        
        @method name: testCreateClsTeamRoomMeetingExtension
       
     */
     
     static testmethod void testCreateClsTeamRoomMeetingExtension()
     {
        
        // Load Environment Variables   
        //DataUtilTest.loadEnvironmentVariables();
        
         Profile profileObj = [Select Name,Id from Profile where Name = 'Customer Portal Admin'];
         User userObj = new User();
         Account acctObj = new Account();
         Contact conobj=new Contact();
         Team_Room__c teamroomObj = new Team_Room__c();
         Team_Room_Meeting__c trmObj = new Team_Room_Meeting__c();
         Team_Room_Member__c teamroommemberObj = new Team_Room_Member__c ();
         String Name = 'John';
         
         acctObj = getAccount('MYTEST ACCOUNT1');
                        
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
         
         
        teamroommemberObj.User__c = userObj.Id;
        teamroommemberObj.Team_Room__c = teamroomObj.Id;
        Test.startTest();
        insert  teamroommemberObj;
        
        
         
        //System.runAs(userObj)
        //{
                     
             ApexPages.currentPage().getParameters().put('trid', teamroomObj.Id);
             ApexPages.currentPage().getParameters().put('id', trmObj.Id);
             ApexPages.StandardController controller = new ApexPages.StandardController(trmObj) ;
             ClsTeamRoomMeetingExtension teamRoomMeetingExtensionObj = new ClsTeamRoomMeetingExtension(controller);
             teamRoomMeetingExtensionObj.getItems();
             teamRoomMeetingExtensionObj.gettimeStamps();
             teamRoomMeetingExtensionObj.showrecurrSection();
             teamRoomMeetingExtensionObj.recurrSelection();
             teamRoomMeetingExtensionObj.sundaycall();
             teamRoomMeetingExtensionObj.mondaycall();
             teamRoomMeetingExtensionObj.tuesdaycall();
             teamRoomMeetingExtensionObj.thursdaycall();
             teamRoomMeetingExtensionObj.wednesdaycall();
             teamRoomMeetingExtensionObj.fridaycall();
             teamRoomMeetingExtensionObj.saturdaycall();
             teamRoomMeetingExtensionObj.unselectclick();
             teamRoomMeetingExtensionObj.getunSelectedValues();
             teamRoomMeetingExtensionObj.cancelTeamRoomMeeting();
             teamRoomMeetingExtensionObj.recurrValue = 'Daily';
             teamRoomMeetingExtensionObj.recurrSelection();
             teamRoomMeetingExtensionObj.recurrValue = 'Weekly';
             teamRoomMeetingExtensionObj.recurrSelection();
             teamRoomMeetingExtensionObj.recurrValue = 'Monthly';
             teamRoomMeetingExtensionObj.recurrSelection();
             teamRoomMeetingExtensionObj.recurrValue = 'Yearly';
             teamRoomMeetingExtensionObj.recurrSelection();
             teamRoomMeetingExtensionObj.saveTeamRoomMeeting();
             teamRoomMeetingExtensionObj.sampleDateField = '08/22/2050';
             teamRoomMeetingExtensionObj.sampleEndDateField = '12/22/2050';
             teamRoomMeetingExtensionObj.saveTeamRoomMeeting();
             teamRoomMeetingExtensionObj.meetingSubject = 'Project Status';
             teamRoomMeetingExtensionObj.saveTeamRoomMeeting();
             teamRoomMeetingExtensionObj.startTime = '08:00';
             teamRoomMeetingExtensionObj.saveTeamRoomMeeting();
             teamRoomMeetingExtensionObj.endTime = '09:00';
             teamRoomMeetingExtensionObj.saveTeamRoomMeeting();
             teamRoomMeetingExtensionObj.rightvalues.add(Name);
             teamRoomMeetingExtensionObj.selectclick();
             teamRoomMeetingExtensionObj.getSelectedValues();
             teamRoomMeetingExtensionObj.saveTeamRoomMeeting();
             teamRoomMeetingExtensionObj.recurrValue = 'Daily';
             teamRoomMeetingExtensionObj.dailyrecurrValue = 'everyweekday'; 
             teamRoomMeetingExtensionObj.saveTeamRoomMeeting();
             teamRoomMeetingExtensionObj.recurrValue = 'Daily';
             teamRoomMeetingExtensionObj.dailyrecurrValue = NULL; 
             teamRoomMeetingExtensionObj.saveTeamRoomMeeting();
             teamRoomMeetingExtensionObj.recurrValue = 'Weekly';
             teamRoomMeetingExtensionObj.monday = 'monday';
             teamRoomMeetingExtensionObj.tuesday= 'tuesday';
             teamRoomMeetingExtensionObj.saveTeamRoomMeeting();
             teamRoomMeetingExtensionObj.recurrValue = 'Monthly';
             teamRoomMeetingExtensionObj.monthlyrecurrValue = 'onDay';
             teamRoomMeetingExtensionObj.recurrPicklist ='23';
             teamRoomMeetingExtensionObj.saveTeamRoomMeeting();
             Test.stopTest(); 
             
             System.assertEquals('Monthly',teamRoomMeetingExtensionObj.recurrValue);    
         //}
    }
    
    /**
        This method is used to test the ClsTeamRoomMeetingExtension class at the time of team room meeting editing.
        
        @method name: testEditClsTeamRoomMeetingExtension
       
     */
     static testmethod void testEditClsTeamRoomMeetingExtension()
     {
        // Load Environment Variables   
        //DataUtilTest.loadEnvironmentVariables();
        
         Profile profileObj = [Select Name,Id from Profile where Name = 'Customer Portal Admin'];
         User userObj = new User();
         Account acctObj = new Account();
         Contact conobj=new Contact();
         Team_Room__c teamroomObj = new Team_Room__c();
         Team_Room_Meeting__c trmObj = new Team_Room_Meeting__c();
         Team_Room_Member__c teamroommemberObj = new Team_Room_Member__c ();
         GF_Meeting_Occurrence__c occurrenceObj = new GF_Meeting_Occurrence__c();
         GF_Meeting_Invitee__c inviteeObj = new GF_Meeting_Invitee__c();
         String Name = 'John';
         
         acctObj = getAccount('MYTEST ACCOUNT1');
                        
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
        insert occurrenceObj;
         
        inviteeObj.User__c = userObj.Id;
        inviteeObj.Team_Room_Meeting__c = trmObj.Id;
        insert inviteeObj;
         
         
        //System.runAs(userObj)
        //{
        
             
             //ApexPages.currentPage().getParameters().put('trid', teamroomObj.Id);
             ApexPages.currentPage().getParameters().put('id', trmObj.Id);
             ApexPages.StandardController controller = new ApexPages.StandardController(trmObj) ;
             ClsTeamRoomMeetingExtension teamRoomMeetingExtensionObj = new ClsTeamRoomMeetingExtension(controller);
             teamRoomMeetingExtensionObj.getItems();
             teamRoomMeetingExtensionObj.gettimeStamps();
             teamRoomMeetingExtensionObj.showrecurrSection();
             teamRoomMeetingExtensionObj.recurrSelection();
             teamRoomMeetingExtensionObj.sundaycall();
             teamRoomMeetingExtensionObj.mondaycall();
             teamRoomMeetingExtensionObj.tuesdaycall();
             teamRoomMeetingExtensionObj.thursdaycall();
             teamRoomMeetingExtensionObj.wednesdaycall();
             teamRoomMeetingExtensionObj.fridaycall();
             teamRoomMeetingExtensionObj.saturdaycall();
             teamRoomMeetingExtensionObj.unselectclick();
             teamRoomMeetingExtensionObj.getunSelectedValues();
             teamRoomMeetingExtensionObj.cancelTeamRoomMeeting();
             teamRoomMeetingExtensionObj.recurrValue = 'Daily';
             teamRoomMeetingExtensionObj.recurrSelection();
             teamRoomMeetingExtensionObj.recurrValue = 'Weekly';
             teamRoomMeetingExtensionObj.recurrSelection();
             teamRoomMeetingExtensionObj.recurrValue = 'Monthly';
             teamRoomMeetingExtensionObj.recurrSelection();
             teamRoomMeetingExtensionObj.recurrValue = 'Yearly';
             teamRoomMeetingExtensionObj.recurrSelection();
             teamRoomMeetingExtensionObj.saveTeamRoomMeeting();
             teamRoomMeetingExtensionObj.sampleDateField = '08/22/2050';
             teamRoomMeetingExtensionObj.sampleEndDateField = '12/22/2050';
             teamRoomMeetingExtensionObj.saveTeamRoomMeeting();
             teamRoomMeetingExtensionObj.meetingSubject = 'Project Status';
             teamRoomMeetingExtensionObj.saveTeamRoomMeeting();
             teamRoomMeetingExtensionObj.startTime = '08:00';
             teamRoomMeetingExtensionObj.saveTeamRoomMeeting();
             teamRoomMeetingExtensionObj.endTime = '09:00';
             teamRoomMeetingExtensionObj.saveTeamRoomMeeting();
             teamRoomMeetingExtensionObj.rightvalues.add(Name);
             teamRoomMeetingExtensionObj.selectclick();
             teamRoomMeetingExtensionObj.getSelectedValues();
             teamRoomMeetingExtensionObj.saveTeamRoomMeeting();
             teamRoomMeetingExtensionObj.recurrValue = 'Daily';
             teamRoomMeetingExtensionObj.dailyrecurrValue = 'everyweekday'; 
             teamRoomMeetingExtensionObj.saveTeamRoomMeeting();
             teamRoomMeetingExtensionObj.recurrValue = 'Daily';
             teamRoomMeetingExtensionObj.dailyrecurrValue = NULL; 
             teamRoomMeetingExtensionObj.saveTeamRoomMeeting();
             teamRoomMeetingExtensionObj.recurrValue = 'Weekly';
             teamRoomMeetingExtensionObj.monday = 'monday';
             teamRoomMeetingExtensionObj.tuesday= 'tuesday';
             teamRoomMeetingExtensionObj.saveTeamRoomMeeting();
             teamRoomMeetingExtensionObj.recurrValue = 'Monthly';
             teamRoomMeetingExtensionObj.monthlyrecurrValue = 'onDay';
             teamRoomMeetingExtensionObj.recurrPicklist ='23';
             teamRoomMeetingExtensionObj.saveTeamRoomMeeting();
             Test.stopTest(); 
             
             System.assertEquals('Monthly',teamRoomMeetingExtensionObj.recurrValue);    
         //}
    }
    
    private static Account getAccount(string AccountName)
    {
        Account acct = [SELECT Id, Name FROM Account Where Name =: AccountName];
        
        return acct;
    }

}