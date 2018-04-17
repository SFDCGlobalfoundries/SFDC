/*
 Type Name: ClsDisplayAllTasksTest
 Author: Cognizant Technology Solutions
 Created Date: 13-Dec-2013
 Reason: This is the test class for 'ClsDisplayAllTasks' class.
 Change History:
 Author: 
 Modified Date: 
 Reason: 
 …….. 
 ……..
*/

@isTest(SeeAllData = false)
private class ClsDisplayAllTasksTest{
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

static testMethod void ClsDisplayAllTasksTest() {


     Profile profileObj = [Select Name,Id from Profile where Name ='Customer Portal Admin'];
           
      User userobj =[Select Id,Name,Profile.Name,Contact.accountId from user where Id=:userinfo.getuserId()];
      
      User portalUser =new User();
      Account acctObj = getAccount('MYTEST ACCOUNT1');
      Contact conobj = new Contact();   
      Team_Room__c teamRoomObj = new Team_Room__c();
      GF_Task__c gftaskobj=new GF_Task__c ();
      Task tsk = new Task();
                  
            conobj.FirstName='Mr';
            conobj.LastName='Testcon1';
            conobj.Email='con1@gf.com';
            conobj.Department__c='Design';
            conobj.AccountId=acctObj.Id;
            conobj.Is_Portal_User_Active__c = true;                          
            insert conobj;
            
       
            
          portalUser = new User( ProfileId = profileObj.Id,
                                            Username = 'portaluser@testorg.com',
                                            Alias = 'auser',
                                            Email='portaluser@testorg.com',
                                            EmailEncodingKey='UTF-8',
                                            Firstname='Bruce',
                                            Lastname='Wayne',
                                            LanguageLocaleKey='en_US',
                                            LocaleSidKey='en_US',
                                            ContactId=conobj.Id,
                                            isactive=true,
                                            TimeZoneSidKey='America/Chicago'
                                           );
         Test.startTest();                                   
         insert portalUser ;
         
         teamRoomObj.Team_Room_Administrator__c = userObj.Id;
         teamRoomObj.Name ='Team Room 1';
         teamRoomObj.Team_Room_Description__c = 'Team Room Description';
         //teamRoomObj.Team_Room_Type__c = 'External Multi party';
         teamRoomObj.Terms_n_Conditions_Accepted__c = true;
    teamRoomObj.Primary_Account__c=acctObj.id;
           
         insert teamRoomObj;
         
         gftaskobj.Name ='GFtask1';
         gftaskobj.Subject__c='New task';
         gftaskobj.assignTo__c=portalUser.Id;
         gftaskobj.Status__c='Completed';
         gftaskobj.assignTo__c = userinfo.getuserid();
         insert gftaskobj;
         
         tsk.subject = 'test subject';
         tsk.Status = 'Completed';
         tsk.ownerid = userinfo.getuserid();
         insert tsk;
     
         Test.setCurrentPageReference(new PageReference('Page.VFDisplayTasks'));
    
         ClsDisplayAllTasks ClsDisplayAllTasksobj= new ClsDisplayAllTasks();
         List<Selectoption> dateList=ClsDisplayAllTasksobj.filtervalues;
         boolean SelectedValueIsOverdue = ClsDisplayAllTasksobj.SelectedValueIsOverdue;
         ClsDisplayAllTasksobj.SelectedValue='Overdue';
         ClsDisplayAllTasksobj.totaltasklist();
         ClsDisplayAllTasksobj.SelectedValue='All Completed';
         ClsDisplayAllTasksobj.totaltasklist();
         ClsDisplayAllTasksobj.SelectedValue='Today';
         ClsDisplayAllTasksobj.totaltasklist();
         ClsDisplayAllTasksobj.SelectedValue='Today+Overdue';
         ClsDisplayAllTasksobj.totaltasklist();
         ClsDisplayAllTasksobj.SelectedValue='Tomorrow';
         ClsDisplayAllTasksobj.totaltasklist();
         ClsDisplayAllTasksobj.SelectedValue='Next 7 Days';
         ClsDisplayAllTasksobj.totaltasklist();
         ClsDisplayAllTasksobj.SelectedValue='Next 7 Days+Overdue';
         ClsDisplayAllTasksobj.totaltasklist();
         ClsDisplayAllTasksobj.SelectedValue='This Month';
         ClsDisplayAllTasksobj.totaltasklist();
         ClsDisplayAllTasksobj.SelectedValue='All Open';
         ClsDisplayAllTasksobj.totaltasklist();
         ClsDisplayAllTasksobj.NewTask();
         system.assertEquals(ClsDisplayAllTasksobj.SelectedValue,'All Open');
         Test.stopTest();    

}

    private static Account getAccount(string AccountName)
    {
        Account acct = [SELECT Id, Name FROM Account Where Name =: AccountName];
        
        return acct;
    }
}