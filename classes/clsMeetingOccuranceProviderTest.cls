/*
 Type Name: clsMeetingOccuranceProviderTest
 Author: Cognizant Technology Solutions
 Created Date: 11-July-2013
 Reason: This is the test class for 'clsMeetingOccuranceGFCalActivityProvider' class.
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
private class clsMeetingOccuranceProviderTest{
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
    static testMethod void testclsMeetingOccuranceProvider() {
        
            Profile profileObj = [Select Name,Id from Profile where Name = 'System Administrator'];
            User userObj = new User();
            Account acctObj = getAccount('MYTEST ACCOUNT1');
            Contact conobj=new Contact();
            Team_Room__c teamRoomObj = new Team_Room__c();
            
            Team_Room_Meeting__c teamRoomMeetingObj = new Team_Room_Meeting__c();
            
            GF_Meeting_Occurrence__c gfMeetingOccrOpenObj = new GF_Meeting_Occurrence__c();
            GF_Meeting_Occurrence__c gfMeetingOccrCloseObj = new GF_Meeting_Occurrence__c();
            Team_Room_Member__c teamRoomMemberObj = new Team_Room_Member__c();
            GF_Task__c  gfTaskOpenObj = new GF_Task__c ();
            GF_Task__c  gfTaskClosedObj = new GF_Task__c ();
            
           
            conobj.FirstName='Mr';
            conobj.LastName='Testcon1';
            conobj.AccountId=acctObj.Id;
            conobj.Email='con1@gf.com';
            conobj.Department__c='Design';
                                      
            insert conobj;
            
            
            userObj.Alias = 'Frank';
            userObj.Email='Frank@test.com'; 
            userObj.EmailEncodingKey='UTF-8'; 
            userObj.LastName='Sinnatra';
            userObj.LanguageLocaleKey='en_US'; 
            userObj.LocaleSidKey='en_US';
            userObj.ProfileId = profileObj.Id;
            userObj.TimeZoneSidKey='America/Los_Angeles'; 
            userObj.UserName='Franky@test.com';
            //userObj.Portal_Login__c = 'xyz1';
            //userObj.contactId = conobj.Id;
            userObj.IsActive = true;
                        
            insert userObj;
            
            teamRoomObj.Team_Room_Administrator__c = userObj.Id;
            teamRoomObj.Name ='Team Room 1';
            teamRoomObj.Team_Room_Description__c = 'Team Room Description';
            //teamRoomObj.Team_Room_Type__c = 'External Multi party';
            teamRoomObj.Terms_n_Conditions_Accepted__c = true;
            teamRoomObj.Primary_Account__c=acctObj.id;

            
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
            gfMeetingOccrOpenObj.End_Time__c=System.now().addDays(+2);
            gfMeetingOccrOpenObj.Team_Room_Meeting__c=teamRoomMeetingObj.id;
            
            insert gfMeetingOccrOpenObj;

            gfMeetingOccrCloseObj.Start_Time__c=System.today().addDays(+1);
            gfMeetingOccrCloseObj.Status__c='Closed';
            gfMeetingOccrCloseObj.End_Time__c=System.now().addDays(+3);
            gfMeetingOccrCloseObj.Team_Room_Meeting__c=teamRoomMeetingObj.id;
            
            insert gfMeetingOccrCloseObj;
            
            System.runAs(userObj)
            {
            
                Test.startTest();
                
                clsMeetingOccuranceGFCalActivityProvider clsMeetingOccuranceGFCalActivityProviderObj= new clsMeetingOccuranceGFCalActivityProvider();
                clsMeetingOccuranceGFCalActivityProviderObj.findActivities(userObj.id);
                clsMeetingOccuranceGFCalActivityProviderObj.getActivityTypes();
                Test.stopTest();    
            
            }        
        
    }
    
    private static Account getAccount(string AccountName)
    {
        Account acct = [SELECT Id, Name FROM Account Where Name =: AccountName];
        
        return acct;
    }
}