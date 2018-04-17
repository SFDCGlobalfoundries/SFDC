/*
 Type Name: clsRTeamRoomManageMembershipTest 
 Author: Global Foundries(Dinesh Suggala)
 Created Date: 27-July-2017
 Reason: This is the test class for 'clsRTeamRoomManageMembership' class.
 Change History:
 Author: 
 Modified Date: 
 Reason: 
 …….. 
 ……..

*/

@isTest
private class clsRTeamRoomManageMembershipTest {
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
    static testMethod void clsTeamRoomManageMembershipInternalMemberTest() {
            
           Profile profileObj = [Select Name,Id from Profile where Name = 'Customer Portal Admin'];
           Profile profileObj1 = [Select Name,Id from Profile where Name = 'System Administrator'];
           RecordType objRecordtype=[select id from RecordType where DeveloperName=:'GLOBALFOUNDRIES_with_Multi_Party'];
          
           User thisUser = [SELECT Id FROM User WHERE Id = :UserInfo.getUserId()];
          
           User internaluserObj = new User(); 
           User internaluserObj1 = new User();
           User internaluserObj2 = new User();
           User externaluserObj= new User();
           List<User> userList=new List<User>();
            
           Account acctObj = new Account();            
           Contact conobj=new Contact(); 
           Restricted_Team_Room__c teamRoomObj = new Restricted_Team_Room__c ();
           R_Team_Room_Account__c teamRoomAccObj= new R_Team_Room_Account__c ();
           R_Team_Room_Member__c teamRoomMemberObj= new R_Team_Room_Member__c ();
           R_Team_Room_Member__c teamRoomMemberObj1= new R_Team_Room_Member__c ();
           R_Team_Room_Member__c teamRoomMemberObj2= new R_Team_Room_Member__c ();
           
           List<R_Team_Room_Member__c> teamRoomMemberList=new List<R_Team_Room_Member__c>();                       
             
            acctObj = getAccount('MYTEST ACCOUNT1');
            conobj=new Contact(FirstName='Mr',LastName='Testcon1',AccountId=acctObj.Id,Email='con1@gf.com',Department__c='Design',Is_Portal_User_Active__c=true,ITAR_Certified__c=true,ITAR_Documents_Verified__c=true);                          
           
            insert conobj;
           
            internaluserObj.Alias = 'TJohn1';
            internaluserObj.Email='TJohn1@test.com'; 
            internaluserObj.EmailEncodingKey='UTF-8'; 
            internaluserObj.LastName='Paul';
            internaluserObj.LanguageLocaleKey='en_US'; 
            internaluserObj.LocaleSidKey='en_US';
            internaluserObj.ProfileId = profileObj1.Id;
            internaluserObj.TimeZoneSidKey='America/Los_Angeles'; 
            internaluserObj.UserName='TJohn1@test.com';
            internaluserObj.IsActive = true;
            
            internaluserObj1.Alias = 'TJohn2';
            internaluserObj1.Email='TJohn2@test.com'; 
            internaluserObj1.EmailEncodingKey='UTF-8'; 
            internaluserObj1.LastName='Paul1';
            internaluserObj1.LanguageLocaleKey='en_US'; 
            internaluserObj1.LocaleSidKey='en_US';
            internaluserObj1.ProfileId = profileObj1.Id;
            internaluserObj1.TimeZoneSidKey='America/Los_Angeles'; 
            internaluserObj1.UserName='TJohn2@test.com';
            internaluserObj1.IsActive = true;    
            
            internaluserObj2.Alias = 'TJohn2';
            internaluserObj2.Email='TJohn2@test.com'; 
            internaluserObj2.EmailEncodingKey='UTF-8'; 
            internaluserObj2.LastName='Paul1';
            internaluserObj2.LanguageLocaleKey='en_US'; 
            internaluserObj2.LocaleSidKey='en_US';
            internaluserObj2.ProfileId = profileObj1.Id;
            internaluserObj2.TimeZoneSidKey='America/Los_Angeles'; 
            internaluserObj2.UserName='TJohn2@test.com';
            internaluserObj2.IsActive = true;      
                 
            
            externaluserObj.Alias = 'portal1';
            externaluserObj.Email='portal1@test.com'; 
            externaluserObj.EmailEncodingKey='UTF-8'; 
            externaluserObj.LastName='portal1';
            externaluserObj.LanguageLocaleKey='en_US'; 
            externaluserObj.LocaleSidKey='en_US';
            externaluserObj.ProfileId = profileObj.Id;
            externaluserObj.TimeZoneSidKey='America/Los_Angeles'; 
            externaluserObj.UserName='portal1@test.com';
            externaluserObj.ContactId=conobj.id;
            externaluserObj.IsActive = true;    
         
            
            userList.add(internaluserObj); 
            userList.add(externaluserObj);
            Test.startTest();
            insert userList;
            
            System.runAs(internaluserObj){
            
            teamRoomObj.Name ='Team Room 1';
            teamRoomObj.R_Team_Room_Description__c = 'Team Room Description';
            teamRoomObj.OwnerId=internaluserObj.id;
            teamRoomObj.RecordTypeId=objRecordtype.Id;
            teamRoomObj.R_Primary_Account__c=acctObj.Id;               
                
            insert teamRoomObj;
            
            teamRoomAccObj.Restricted_Team_Room__c = teamRoomObj.Id;
            teamRoomAccObj.Account__c = acctObj.Id;
                
            insert teamRoomAccObj;
            system.assert(teamRoomAccObj.id!=null);                                   
                 
            teamRoomMemberObj1.Restricted_Team_Room__c = teamRoomObj.Id;
            teamRoomMemberObj1.Access__c ='Read';
            teamRoomMemberObj1.Account__c =acctObj.Id;
            teamRoomMemberObj1.Team_Room_Role__c='Internal Member';
            teamRoomMemberObj1.User_Selected__c=false;
            teamRoomMemberObj1.User__c = internaluserObj1.Id;

            teamRoomMemberObj2.Restricted_Team_Room__c = teamRoomObj.Id;
            teamRoomMemberObj2.User__c = externaluserObj.Id;
            teamRoomMemberObj2.Access__c ='Read';
            teamRoomMemberObj2.Account__c =acctObj.Id;
            teamRoomMemberObj2.Team_Room_Role__c='Internal Member';
           

            teamRoomMemberList.add(teamRoomMemberObj1);
            teamRoomMemberList.add(teamRoomMemberObj2);
            
             insert teamRoomMemberList;
            

            
             
             Test.setCurrentPageReference(new PageReference('Page.VFR_TeamRoomManageMembership')); 
             System.currentPageReference().getParameters().put('id', String.valueOf(teamRoomObj.id));
             clsRTeamRoomManageMembership controller= new clsRTeamRoomManageMembership();  
             clsRTeamRoomManageMembership.UserWrapper userwrp=new clsRTeamRoomManageMembership.UserWrapper(externaluserObj);
                 
             controller.selectedAccId=acctObj.Id;
             controller.blnDuplicateUser=false;    
             userwrp.selectedportaluser=true;             
             controller.fetchportalusers();
             List<Selectoption> memRole=controller.MemberRoleList;
             List<Selectoption> accList=controller.getAccountNames();
             controller.Cancel();
             controller.addUserRow();
             controller.back();
             controller.save();
             controller.DeleteUser();
                
                
            }
            
    }
    
    static testMethod void clsTeamRoomManageMembershipInternalMemberTest2() {
           Profile profileObj = [Select Name,Id from Profile where Name = 'Customer Portal Admin'];
           Profile profileObj1 = [Select Name,Id from Profile where Name = 'System Administrator'];
           RecordType objRecordtype=[select id from RecordType where DeveloperName=:'GLOBALFOUNDRIES_with_Multi_Party'];
          
           User thisUser = [SELECT Id FROM User WHERE Id = :UserInfo.getUserId()];
          
           User internaluserObj = new User(); 
           User internaluserObj1 = new User();
           User internaluserObj2 = new User();
           User externaluserObj= new User();
           List<User> userList=new List<User>();
            
           Account acctObj = new Account();            
           Contact conobj=new Contact(); 
           Restricted_Team_Room__c teamRoomObj = new Restricted_Team_Room__c ();
           R_Team_Room_Account__c teamRoomAccObj= new R_Team_Room_Account__c ();
           R_Team_Room_Member__c teamRoomMemberObj= new R_Team_Room_Member__c ();
           R_Team_Room_Member__c teamRoomMemberObj1= new R_Team_Room_Member__c ();
           R_Team_Room_Member__c teamRoomMemberObj2= new R_Team_Room_Member__c ();
           
           List<R_Team_Room_Member__c> teamRoomMemberList=new List<R_Team_Room_Member__c>();                       
             
            acctObj = getAccount('MYTEST ACCOUNT1');
            conobj=new Contact(FirstName='Mr',LastName='Testcon1',AccountId=acctObj.Id,Email='con1@gf.com',Department__c='Design',Is_Portal_User_Active__c=true,ITAR_Certified__c=true,ITAR_Documents_Verified__c=true);                          
           
            insert conobj;
           
            internaluserObj.Alias = 'TJohn1';
            internaluserObj.Email='TJohn1@test.com'; 
            internaluserObj.EmailEncodingKey='UTF-8'; 
            internaluserObj.LastName='Paul';
            internaluserObj.LanguageLocaleKey='en_US'; 
            internaluserObj.LocaleSidKey='en_US';
            internaluserObj.ProfileId = profileObj1.Id;
            internaluserObj.TimeZoneSidKey='America/Los_Angeles'; 
            internaluserObj.UserName='TJohn1@test.com';
            internaluserObj.IsActive = true;
            
            internaluserObj1.Alias = 'TJohn2';
            internaluserObj1.Email='TJohn2@test.com'; 
            internaluserObj1.EmailEncodingKey='UTF-8'; 
            internaluserObj1.LastName='Paul1';
            internaluserObj1.LanguageLocaleKey='en_US'; 
            internaluserObj1.LocaleSidKey='en_US';
            internaluserObj1.ProfileId = profileObj1.Id;
            internaluserObj1.TimeZoneSidKey='America/Los_Angeles'; 
            internaluserObj1.UserName='TJohn2@test.com';
            internaluserObj1.IsActive = true;    
            
            internaluserObj2.Alias = 'TJohn2';
            internaluserObj2.Email='TJohn2@test.com'; 
            internaluserObj2.EmailEncodingKey='UTF-8'; 
            internaluserObj2.LastName='Paul1';
            internaluserObj2.LanguageLocaleKey='en_US'; 
            internaluserObj2.LocaleSidKey='en_US';
            internaluserObj2.ProfileId = profileObj1.Id;
            internaluserObj2.TimeZoneSidKey='America/Los_Angeles'; 
            internaluserObj2.UserName='TJohn2@test.com';
            internaluserObj2.IsActive = true;
            
            externaluserObj.Alias = 'portal11';
            externaluserObj.Email='portal11@test.com'; 
            externaluserObj.EmailEncodingKey='UTF-8'; 
            externaluserObj.LastName='portal11';
            externaluserObj.LanguageLocaleKey='en_US'; 
            externaluserObj.LocaleSidKey='en_US';
            externaluserObj.ProfileId = profileObj.Id;
            externaluserObj.TimeZoneSidKey='America/Los_Angeles'; 
            externaluserObj.UserName='portal11@test.com';
            externaluserObj.ContactId=conobj.id;
            externaluserObj.IsActive = true;    
         
            
            userList.add(internaluserObj); 
            userList.add(externaluserObj);
            Test.startTest();
            insert userList;
            
            System.runAs(internaluserObj){
            
            teamRoomObj.Name ='Team Room 2';
            teamRoomObj.R_Team_Room_Description__c = 'Team Room Description 2';
            teamRoomObj.OwnerId=internaluserObj.id;
            teamRoomObj.RecordTypeId=objRecordtype.Id;
            teamRoomObj.R_Primary_Account__c=acctObj.Id;               
                
            insert teamRoomObj;
            
            teamRoomAccObj.Restricted_Team_Room__c = teamRoomObj.Id;
            teamRoomAccObj.Account__c = acctObj.Id;
                
            insert teamRoomAccObj;
            system.assert(teamRoomAccObj.id!=null);    
                
           /* teamRoomMemberObj.Restricted_Team_Room__c = teamRoomObj.Id;
            teamRoomMemberObj.User__c = internaluserObj.Id;
            teamRoomMemberObj.Access__c ='Read';
            teamRoomMemberObj.Account__c =acctObj.Id;
            teamRoomMemberObj.Team_Room_Role__c='Moderator';*/
            
                 
            teamRoomMemberObj1.Restricted_Team_Room__c = teamRoomObj.Id;
            teamRoomMemberObj1.User__c = internaluserObj1.Id;
            teamRoomMemberObj1.Access__c ='Read';
            teamRoomMemberObj1.Account__c =acctObj.Id;
            teamRoomMemberObj1.Team_Room_Role__c='Internal Member';
            teamRoomMemberObj1.User_Selected__c=true;
             
            teamRoomMemberObj2.Restricted_Team_Room__c = teamRoomObj.Id;
            teamRoomMemberObj2.User__c = internaluserObj1.Id;
            teamRoomMemberObj2.Access__c ='Read';
            teamRoomMemberObj2.Account__c =acctObj.Id;
            teamRoomMemberObj2.Team_Room_Role__c='Internal Member';
            teamRoomMemberObj1.User_Selected__c=true;
            
           // teamRoomMemberList.add(teamRoomMemberObj);
            teamRoomMemberList.add(teamRoomMemberObj1);
            teamRoomMemberList.add(teamRoomMemberObj2);
            
            insert teamRoomMemberList;
            }
             
             System.runAs(externaluserObj){             
                 Test.setCurrentPageReference(new PageReference('Page.VFR_TeamRoomManageMembership')); 
                 System.currentPageReference().getParameters().put('id', String.valueOf(teamRoomObj.id));
                 clsRTeamRoomManageMembership controller= new clsRTeamRoomManageMembership();  
                 clsRTeamRoomManageMembership.UserWrapper userwrp=new clsRTeamRoomManageMembership.UserWrapper (internaluserObj);
                     
                 controller.selectedAccId=acctObj.Id;
                 controller.blnDuplicateUser=false;
                 controller.fetchportalusers();
                 userwrp.selectedportaluser=true;
                 List<Selectoption> memRole=controller.MemberRoleList;
                 List<Selectoption> accList=controller.getAccountNames();
                 controller.Cancel();
                 controller.addUserRow();
                 controller.back();
                 controller.save();
                 controller.DeleteUser();               
             }
             Test.stopTest();            
    }
        
    private static Account getAccount(string AccountName)
    {
        Account acct = [SELECT Id, Name FROM Account Where Name =: AccountName];
        
        return acct;
    }
   
    
        
}