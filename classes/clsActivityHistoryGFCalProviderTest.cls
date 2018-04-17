/*
 Type Name: clsActivityHistoryGFCalProviderTest 
 Author: Cognizant Technology Solutions
 Created Date: 11-July-2013
 Reason: This is the test class for 'clsActivityHistoryGFCalActivityProvider' class.
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
private class clsActivityHistoryGFCalProviderTest {
    @testSetup static void testdata() {
        DataUtilTest.loadEnvironmentVariables();
    }
    static testMethod void testclsActivityHistoryGFCalProvider() {
        
        // Load Environment Variables   
        //DataUtilTest.loadEnvironmentVariables();
        
            Profile profileObj = [Select Name,Id from Profile where Name = 'System Administrator'];
            User userObj = new User();
            Account acctObj = new Account();
            Contact conobj=new Contact();
            Team_Room__c teamRoomObj = new Team_Room__c();
            
            Team_Room_Meeting__c teamRoomMeetingObj = new Team_Room_Meeting__c();
            
            GF_Meeting_Occurrence__c gfMeetingOccrOpenObj = new GF_Meeting_Occurrence__c();
            GF_Meeting_Occurrence__c gfMeetingOccrCloseObj = new GF_Meeting_Occurrence__c();
            Team_Room_Member__c teamRoomMemberObj = new Team_Room_Member__c();
            GF_Task__c  gfTaskOpenObj = new GF_Task__c ();
            GF_Task__c  gfTaskClosedObj = new GF_Task__c ();
            
            acctObj.Name='TestAccount';
            acctObj.Site_Department__c = 'Site1';
            acctObj.Sub_Type__c = 'Direct';
            acctObj.Transaction_Type__c = 'Transactional';
            acctObj.Region__c = 'APJ';
            acctObj.Bill_To_Address_1__c='KOL';
            acctObj.Bill_To_City__c = 'KOL';
            acctObj.Bill_To_Country__c = 'INDIA';
            acctObj.Corporate_Address_1__c = 'Street';
            acctObj.Corporate_City__c = 'KOL';
            acctObj.Corporate_Country__c = 'INDIA';
            
            insert acctObj;
            
            
            conobj.FirstName='Mr';
            conobj.LastName='Testcon1';
            conobj.AccountId=acctObj.Id;
            conobj.Email='con1@gf.com';
            conobj.Department__c='Design';
                                      
            insert conobj;
            
            
            userObj.Alias = 'Jimmy2';
            userObj.Email='Jimmy2058@test.com'; 
            userObj.EmailEncodingKey='UTF-8'; 
            userObj.LastName='Gadha';
            userObj.LanguageLocaleKey='en_US'; 
            userObj.LocaleSidKey='en_US';
            userObj.ProfileId = profileObj.Id;
            userObj.TimeZoneSidKey='America/Los_Angeles'; 
            userObj.UserName='Jimmy2058@test.com';
            //userObj.Portal_Login__c = 'xyz1';
            //userObj.contactId = conobj.Id;
            userObj.IsActive = true;
                        
            insert userObj;
            
            teamRoomObj.Team_Room_Administrator__c = userObj.Id;
            teamRoomObj.Name ='Team Room 1';
            teamRoomObj.Team_Room_Description__c = 'Team Room Description';
            teamRoomObj.Primary_Account__c= acctObj.id;
            teamRoomObj.Terms_n_Conditions_Accepted__c = true;
            
            insert teamRoomObj;
            
            teamRoomMemberObj.Team_Room__c = teamRoomObj.id;
            teamRoomMemberObj.User__c = userObj.id;
            
            insert teamRoomMemberObj;
            
            teamRoomMeetingObj.Team_Room__c = teamRoomObj.id;
            teamRoomMeetingObj.Status__c='Open';
            teamRoomMeetingObj.Description__c='Test Team Room';
            teamRoomMeetingObj.Start_DateTime__c = System.today();
            
            insert teamRoomMeetingObj;
            
            
            gfTaskClosedObj.Name='Closed Task';
            gfTaskClosedObj.Team_Room__c=teamRoomObj.id;
            gfTaskClosedObj.subject__c='GF task Meeting';
            gfTaskClosedObj.Due_Date__c = System.today();
            gfTaskClosedObj.assignTo__c = userObj.id;
            gfTaskClosedObj.Status__c ='Completed';
            
            insert gfTaskClosedObj;

            gfTaskOpenObj.Name='Open Task';
            gfTaskOpenObj.Team_Room__c=teamRoomObj.id;
            gfTaskOpenObj.subject__c='GF task Meeting';
            gfTaskOpenObj.Due_Date__c = System.today().addDays(+1);
            gfTaskOpenObj.assignTo__c = userObj.id;
            gfTaskOpenObj.Status__c ='In Progress';
            
            insert gfTaskOpenObj;
            
            
            gfMeetingOccrOpenObj.Start_Time__c=System.today().addDays(+1);
            gfMeetingOccrOpenObj.Status__c='Open';
            gfMeetingOccrOpenObj.End_Time__c=System.today().addDays(+2);
            gfMeetingOccrOpenObj.Team_Room_Meeting__c=teamRoomMeetingObj.id;
            
            insert gfMeetingOccrOpenObj;

            gfMeetingOccrCloseObj.Start_Time__c=System.today().addDays(+1);
            gfMeetingOccrCloseObj.Status__c='Closed';
            gfMeetingOccrCloseObj.End_Time__c=System.today();
            gfMeetingOccrCloseObj.Team_Room_Meeting__c=teamRoomMeetingObj.id;
            
            insert gfMeetingOccrCloseObj;
            
            System.runAs(userObj)
            {
            
                Test.startTest();
                
                clsActivityHistoryGFCalActivityProvider clsActivityHistoryGFCalActivityProviderObj = new clsActivityHistoryGFCalActivityProvider();
                clsActivityHistoryGFCalActivityProviderObj.findActivities(userObj.id);
                clsActivityHistoryGFCalActivityProviderObj.getActivityTypes();
                Test.stopTest();    
            
            }        
        
    }
}