/*
    Author: Anirban Roy
    Description: This is the test class for the trigger on Task object.  
    History:
        ARoy        05272014    - code creation.
*/

@isTest(SeeAllData=true)
public class TaskTriggerTest {
  
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
        insert gmplBX009;
        return gmplBX009;
    }
    
    
    // Creation of PPE Team
    static void createPPETeam(Id gmplId, User u){
        List<PPE_Team__c> ppeTeamList = new List<PPE_Team__c>();
        PPE_Team__c pT1 = new PPE_Team__c(GMPL_BX009__c = gmplId, 
                      PPE_Role__c = 'Product Marketing', User__c = UserInfo.getUserId(), Access_Level__c = 'Read/Write');
        
        PPE_Team__c pT2 = new PPE_Team__c(GMPL_BX009__c = gmplId, 
                      PPE_Role__c = 'Project Lead', User__c = u.Id, Access_Level__c = 'Read/Write');    
        
        ppeTeamList.add(pT1);
        ppeTeamList.add(pT2);
        insert ppeTeamList;
    }
    
    // Creation of a Task
    static Task createNewTask(Id gmplId){
    	Task tsk = new Task(ActivityDate = Date.today(),Subject='BRB Review',WhatId = gmplId,
    						OwnerId = UserInfo.getUserId(),Status='Not Started');
    	insert tsk;
    	return tsk;
    }   
    
     // Email Notification on Task Completion test
    static testMethod void emailOnTaskCompletionTest(){
        
        User u = TaskTriggerTest.createUser();
        GMPL_BX009__c gmplObj = TaskTriggerTest.createGMPL();
        TaskTriggerTest.createPPETeam(gmplObj.Id,u);
        Task tsk = TaskTriggerTest.createNewTask(gmplObj.Id);
        
        Test.startTest();
        	system.runAs(u){
        		Group grp = [select Id from Group where DeveloperName = 'CE_Admin_Group' limit 1];
        		GroupMember gm = new GroupMember(GroupId = grp.Id, UserOrGroupId = UserInfo.getUserId());
        		try{
        			insert gm;
        		}catch(Exception e){
        			system.debug('Error while group member insertion :: '+e.getMessage());
        		}
        	}
        	
        	tsk.Status = 'Completed';
        	update tsk;     
        Test.stopTest();               
        
    }
    
}