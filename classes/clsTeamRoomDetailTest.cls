/*
    Author:
    Description:
    History:
        Nbustillos  10122013    - Added call to loadEnvironmentVariables() method.
        Ashwini     05142015    - Updated code for refactoring of test class.
*/
@isTest
private class clsTeamRoomDetailTest{
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
    private static testmethod void test_clsTeamRoomDetail(){
        
        // Load Environment Variables   
       // DataUtilTest.loadEnvironmentVariables();
        
            Profile profileObj = [Select Name,Id from Profile where Name = 'System Administrator'];
            User userObj = new User();
            Account acctObj = getAccount('MYTEST ACCOUNT1');
            AccountTeamMember atmObj=new AccountTeamMember();
            Contact conobj=new Contact();
            Team_Room__c teamRoomObj = new Team_Room__c();            
            Team_Room_Meeting__c teamRoomMeetingObj = new Team_Room_Meeting__c();
            Team_Room_Account__c teamRoomAccountObj = new Team_Room_Account__c();
            Team_Room_Member__c teamRoomMemberObj = new Team_Room_Member__c();
            Team_Room_Meeting__c closedTeamRoomMeetingObj=new Team_Room_Meeting__c();
            GF_Task__c  gfTaskOpenObj = new GF_Task__c ();
            GF_Task__c  gfTaskClosedObj = new GF_Task__c ();
            Salesforce_Field_Ids__c cstObj=new Salesforce_Field_Ids__c();
                        
            conobj.FirstName='Mr';
            conobj.LastName='Testcon1';
            conobj.AccountId=acctObj.Id;
            conobj.Email='con1@gf.com';
            conobj.Department__c='Design';
                                      
            insert conobj;
            
            cstObj.Name='1';
            cstObj.SObject_Name__c='Team_Room_Account__c';
            cstObj.Field_Name__c='Team_Room__c';
            cstObj.Id__c='testId';
            
            insert cstObj;
            
            userObj.Alias = 'Kenny';
            userObj.Email='Kenny@test.com'; 
            userObj.EmailEncodingKey='UTF-8'; 
            userObj.LastName='Loggins';
            userObj.LanguageLocaleKey='en_US'; 
            userObj.LocaleSidKey='en_US';
            userObj.ProfileId = profileObj.Id;
            userObj.TimeZoneSidKey='America/Los_Angeles'; 
            userObj.UserName='Kenny@test.com';
            //userObj.Portal_Login__c = 'xyz1';
            //userObj.contactId = conobj.Id;
            userObj.IsActive = true;
                        
            insert userObj;
            
            RecordType recType=[Select Id from RecordType where DeveloperName='External_Multi_Party'];
            teamRoomObj.Team_Room_Administrator__c = userObj.Id;
            teamRoomObj.Name ='Team Room 1';
            teamRoomObj.Team_Room_Description__c = 'Team Room Description';
            //teamRoomObj.Team_Room_Type__c = 'External Multi party';
            teamRoomObj.Terms_n_Conditions_Accepted__c = true;
            teamRoomObj.RecordTypeId=recType.Id;
            teamRoomObj.Primary_Account__c=acctObj.id;
            
            insert teamRoomObj;
            
            teamRoomMemberObj.Team_Room__c = teamRoomObj.id;
            teamRoomMemberObj.User__c = userObj.Id;
            
            insert teamRoomMemberObj;
            
            atmObj.AccountId=acctObj.Id;
            atmObj.UserId=UserInfo.getUserId();
            
            //insert atmObj;
            
            
            teamRoomMeetingObj.Team_Room__c = teamRoomObj.id;
            teamRoomMeetingObj.Status__c='Open';
            teamRoomMeetingObj.Description__c='Test Team Room';
            teamRoomMeetingObj.Start_DateTime__c = System.today();
            
            insert teamRoomMeetingObj;
            
            
            closedTeamRoomMeetingObj.Team_Room__c = teamRoomObj.id;
            closedTeamRoomMeetingObj.Status__c='Closed';
            closedTeamRoomMeetingObj.Description__c='Test Team Room';
            closedTeamRoomMeetingObj.Start_DateTime__c = System.today().addDays(-2);
            closedTeamRoomMeetingObj.Start_DateTime__c = System.today().addDays(-1);
            insert closedTeamRoomMeetingObj;
            
            teamRoomAccountObj.Team_Room__c = teamRoomObj.id;
            teamRoomAccountObj.Account__c=acctObj.Id;
            
            insert teamRoomAccountObj;
            
            
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
                       
            
            List<Default_Page_Size__c> pageSizeList=new List<Default_Page_Size__c>();
            Default_Page_Size__c pageSizeObj=new Default_Page_Size__c(Name='Account',Page_Size__c=1);
            pageSizeList.add(pageSizeObj);
            pageSizeObj=new Default_Page_Size__c(Name='Member',Page_Size__c=1);
            pageSizeList.add(pageSizeObj);
            pageSizeObj=new Default_Page_Size__c(Name='Open Activity',Page_Size__c=1);
            pageSizeList.add(pageSizeObj);
            pageSizeObj=new Default_Page_Size__c(Name='Activity History',Page_Size__c=1);
            pageSizeList.add(pageSizeObj);
            
            
            insert pageSizeList;
            
            
            Test.startTest();  
                System.runAs(userObj){         
                    
                    
                    PageReference pageRef = Page.VFTeamRoomDetail;
                    pageRef.getParameters().put('id', String.valueOf(teamRoomObj.Id));
                    pageRef.getParameters().put('memberId', String.valueOf(teamRoomMemberObj.Id));
                    pageRef.getParameters().put('accToDelete', String.valueOf(teamRoomAccountObj.Id));
                    pageRef.getParameters().put('MeetingTonavigate', String.valueOf(teamRoomMeetingObj.Id));
                    pageRef.getParameters().put('objectToEdit', String.valueOf(teamRoomMeetingObj.Id));
                    pageRef.getParameters().put('accToEdit', String.valueOf(teamRoomAccountObj.Id));
                    pageRef.getParameters().put('objectTonavigate', 'Member');
                    Test.setCurrentPage(pageRef);
                    
                    ApexPages.StandardController controller = new ApexPages.StandardController(teamRoomObj); 
                    clsTeamRoomDetail obj= new clsTeamRoomDetail(controller);
                    
                    obj.goToNewTRAccount();
                    obj.goToNewMeeting();
                    obj.goToNewtask();
                    obj.goToNewMember();
                    obj.addDoc();
                    
                    obj.getAccMapSize();
                    obj.getMemberMapSize();
                    obj.getOpenActivityMapSize();
                    obj.getClosedActivityMapSize();
                    
                    obj.goToEditActivity();
                    obj.goToEditTRAccount();
                    obj.previous();
                    obj.next();
                    obj.first();
                    obj.last();
                    
                    
                    obj.deleteMember();
                    obj.deleteActivity();
                    
                    pageRef.getParameters().put('accToDelete', String.valueOf(acctObj.Id));
                    pageRef.getParameters().put('TaskTonavigate', String.valueOf(gfTaskOpenObj.Id));
                    pageRef.getParameters().put('MeetingTonavigate', null);
                    Test.setCurrentPage(pageRef);
                    obj.deleteActivity();
                    obj.deleteTRAccount();
                    
                    pageRef.getParameters().put('objectTonavigate', 'OpenActivity');
                    Test.setCurrentPage(pageRef);
                    obj.previous();
                    obj.next();
                    obj.first();
                    obj.last();
                    
                    pageRef.getParameters().put('objectTonavigate', 'Account');
                    Test.setCurrentPage(pageRef);
                    obj.previous();
                    obj.next();
                    obj.first();
                    obj.last();
                    
                    pageRef.getParameters().put('objectTonavigate', 'ClosedActivity');
                    Test.setCurrentPage(pageRef);
                    obj.previous();
                    obj.next();
                    obj.first();
                    obj.last();
                    
                    pageRef.getParameters().put('selectedPageNum', '1');
                    Test.setCurrentPage(pageRef);
                    obj.updatePageNumberDisplay();
                    
                    System.Debug('ApexPages.currentPage().getURL()-----------'+ApexPages.currentPage().getURL());
                    
                    obj.removeDoc();                    
                    obj.autorefresh();
                }
            Test.stopTest();    
            
    }
    
    private static Account getAccount(string AccountName)
    {
        Account acct = [SELECT Id, Name FROM Account Where Name =: AccountName];
        
        return acct;
    }
}