/*
 Type Name: ClsTeamRoomManageMembershipTest 
 Author: Cognizant Technology Solutions
 Created Date: 11-June-2013
 Reason: This is the test class for 'clsTeamRoomManageMembership' class.
 Change History:
 Author: 
 Modified Date: 
 Reason: 
 …….. 
 ……..
    Nbustillos  10122013    - Added call to loadEnvironmentVariables() method.
    Ashwini     05142015    - Updated code for refactoring of test class.
*/

@isTest(seeAllData=false)
private class ClsTeamRoomManageMembershipTest {
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
        Account acctObj = getAccount('MYTEST ACCOUNT1');
        Contact conobj=new Contact(FirstName='Mr',LastName='Testcon1',AccountId=acctObj.Id,Email='con1@gf.com',Department__c='Design');                          
        Contact conobj1=new Contact(FirstName='Mr1',LastName='Testcon2',AccountId=acctObj.Id,Email='con2@gf.com',Department__c='Design');                          
        
        insert conobj;
        insert conobj1;
        Test.startTest();
        Profile profileObj1 = [Select Name,Id from Profile where Name = 'System Administrator'];
        Profile profileObj = [Select Name,Id from Profile where Name = 'Customer Portal Admin'];
        User externaluserObj = new User();
        User internaluserObj = new User();
        User internaluserObj1 = new User();
        User externaluserObj1= new User();
        User internaluserObj2=new User();
        User internaluserObj3=new User();
        User internaluserObj4=new User();
        User internaluserObj5=new User();
        User internaluserObj6=new User();
        User internaluserObj7=new User();
        
        User internaluserObj8=new User();
        User internaluserObj9=new User();
        
        List<User> userList=new List<User>();
        
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
                    
                 
        internaluserObj1.Alias = 'TJohn11';
        internaluserObj1.Email='TJohn11@test.com'; 
        internaluserObj1.EmailEncodingKey='UTF-8'; 
        internaluserObj1.LastName='Paul';
        internaluserObj1.LanguageLocaleKey='en_US'; 
        internaluserObj1.LocaleSidKey='en_US';
        internaluserObj1.ProfileId = profileObj1.Id;
        internaluserObj1.TimeZoneSidKey='America/Los_Angeles'; 
        internaluserObj1.UserName='TJohn11@test.com';
        internaluserObj1.IsActive = true;
                    
        internaluserObj2.Alias = 'TJohn12';
        internaluserObj2.Email='TJohn12@test.com'; 
        internaluserObj2.EmailEncodingKey='UTF-8'; 
        internaluserObj2.LastName='Paul';
        internaluserObj2.LanguageLocaleKey='en_US'; 
        internaluserObj2.LocaleSidKey='en_US';
        internaluserObj2.ProfileId = profileObj1.Id;
        internaluserObj2.TimeZoneSidKey='America/Los_Angeles'; 
        internaluserObj2.UserName='TJohn12@test.com';
        internaluserObj2.IsActive = true;
        
        internaluserObj3.Alias = 'TJohn13';
        internaluserObj3.Email='TJohn13@test.com'; 
        internaluserObj3.EmailEncodingKey='UTF-8'; 
        internaluserObj3.LastName='Paul';
        internaluserObj3.LanguageLocaleKey='en_US'; 
        internaluserObj3.LocaleSidKey='en_US';
        internaluserObj3.ProfileId = profileObj1.Id;
        internaluserObj3.TimeZoneSidKey='America/Los_Angeles'; 
        internaluserObj3.UserName='TJohn13@test.com';
        internaluserObj3.IsActive = true;
        
        internaluserObj4.Alias = 'TJohn14';
        internaluserObj4.Email='TJohn14@test.com'; 
        internaluserObj4.EmailEncodingKey='UTF-8'; 
        internaluserObj4.LastName='Paul';
        internaluserObj4.LanguageLocaleKey='en_US'; 
        internaluserObj4.LocaleSidKey='en_US';
        internaluserObj4.ProfileId = profileObj1.Id;
        internaluserObj4.TimeZoneSidKey='America/Los_Angeles'; 
        internaluserObj4.UserName='TJohn14@test.com';
        internaluserObj4.IsActive = true;
        
        internaluserObj5.Alias = 'TJohn15';
        internaluserObj5.Email='TJohn15@test.com'; 
        internaluserObj5.EmailEncodingKey='UTF-8'; 
        internaluserObj5.LastName='Paul';
        internaluserObj5.LanguageLocaleKey='en_US'; 
        internaluserObj5.LocaleSidKey='en_US';
        internaluserObj5.ProfileId = profileObj1.Id;
        internaluserObj5.TimeZoneSidKey='America/Los_Angeles'; 
        internaluserObj5.UserName='TJohn15@test.com';
        internaluserObj5.IsActive = true;
        
        internaluserObj6.Alias = 'TJohn16';
        internaluserObj6.Email='TJohn16@test.com'; 
        internaluserObj6.EmailEncodingKey='UTF-8'; 
        internaluserObj6.LastName='Paul';
        internaluserObj6.LanguageLocaleKey='en_US'; 
        internaluserObj6.LocaleSidKey='en_US';
        internaluserObj6.ProfileId = profileObj1.Id;
        internaluserObj6.TimeZoneSidKey='America/Los_Angeles'; 
        internaluserObj6.UserName='TJohn16@test.com';
        internaluserObj6.IsActive = true;
        
        internaluserObj7.Alias = 'TJohn17';
        internaluserObj7.Email='TJohn17@test.com'; 
        internaluserObj7.EmailEncodingKey='UTF-8'; 
        internaluserObj7.LastName='Paul';
        internaluserObj7.LanguageLocaleKey='en_US'; 
        internaluserObj7.LocaleSidKey='en_US';
        internaluserObj7.ProfileId = profileObj1.Id;
        internaluserObj7.TimeZoneSidKey='America/Los_Angeles'; 
        internaluserObj7.UserName='TJohn17@test.com';
        internaluserObj7.IsActive = true;
        
        
        internaluserObj8.Alias = 'TTJohn18';
        internaluserObj8.Email='TTJohn18@test.com'; 
        internaluserObj8.EmailEncodingKey='UTF-8'; 
        internaluserObj8.LastName='Paul';
        internaluserObj8.LanguageLocaleKey='en_US'; 
        internaluserObj8.LocaleSidKey='en_US';
        internaluserObj8.ProfileId = profileObj1.Id;
        internaluserObj8.TimeZoneSidKey='America/Los_Angeles'; 
        internaluserObj8.UserName='TTJohn18@test.com';
        internaluserObj8.IsActive = true;
        
        internaluserObj9.Alias = 'TJohn19';
        internaluserObj9.Email='TJohn19@test.com'; 
        internaluserObj9.EmailEncodingKey='UTF-8'; 
        internaluserObj9.LastName='Paul';
        internaluserObj9.LanguageLocaleKey='en_US'; 
        internaluserObj9.LocaleSidKey='en_US';
        internaluserObj9.ProfileId = profileObj1.Id;
        internaluserObj9.TimeZoneSidKey='America/Los_Angeles'; 
        internaluserObj9.UserName='TJohn19@test.com';
        internaluserObj9.IsActive = true;
        
        
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
        
        externaluserObj1.Alias = 'portal2';
        externaluserObj1.Email='portal2@test.com'; 
        externaluserObj1.EmailEncodingKey='UTF-8'; 
        externaluserObj1.LastName='portal2';
        externaluserObj1.LanguageLocaleKey='en_US'; 
        externaluserObj1.LocaleSidKey='en_US';
        externaluserObj1.ProfileId = profileObj.Id;
        externaluserObj1.TimeZoneSidKey='America/Los_Angeles'; 
        externaluserObj1.UserName='portal2@test.com';
        externaluserObj1.ContactId=conobj1.id;
        externaluserObj1.IsActive = true;
        
        userList.add(internaluserObj);
        userList.add(internaluserObj1);
        userList.add(internaluserObj2);
        userList.add(internaluserObj3);
        userList.add(internaluserObj4);
        userList.add(internaluserObj5);
        userList.add(internaluserObj6);
        userList.add(internaluserObj7);
        userList.add(internaluserObj8);
        userList.add(internaluserObj9);
        userList.add(externaluserObj);
        userList.add(externaluserObj1);
        insert userList;    
        Test.stopTest();    
    }   
    static testMethod void clsTeamRoomManageMembershipInternalMemberTest() {
        
        // Load Environment Variables   
        //DataUtilTest.loadEnvironmentVariables();
        
         //Profile profileObj = [Select Name,Id from Profile where Name = 'Customer Portal Admin'];
          //  Profile profileObj1 = [Select Name,Id from Profile where Name = 'System Administrator'];
            RecordType objRecordtype=[select id from RecordType where DeveloperName=:'External_Multi_Party'];
            User thisUser = [SELECT Id FROM User WHERE Id = :UserInfo.getUserId()];
                                    
            Account acctObj = new Account();            
            AccountTeamMember AccountTeamMemberobj=new AccountTeamMember();
            AccountTeamMember AccountTeamMemberobj1=new AccountTeamMember();
            AccountTeamMember AccountTeamMemberobj2=new AccountTeamMember();
            
            Team_Room__c teamRoomObj = new Team_Room__c();
            Team_Room__c teamRoomObj1 = new Team_Room__c();
            Team_Room_Account__c teamRoomAccObj= new Team_Room_Account__c ();
            Team_Room_Account__c teamRoomAccObj1= new Team_Room_Account__c ();
            Team_Room_Member__c teamRoomMemberObj= new Team_Room_Member__c ();
            Team_Room_Member__c teamRoomMemberObj1= new Team_Room_Member__c ();
            Team_Room_Member__c teamRoomMemberObj2= new Team_Room_Member__c ();
            Team_Room_Member__c teamRoomMemberObj3= new Team_Room_Member__c ();
            Team_Room_Member__c teamRoomMemberObj4= new Team_Room_Member__c ();
            Team_Room_Member__c teamRoomMemberObj5= new Team_Room_Member__c ();
            Team_Room_Member__c teamRoomMemberObj6= new Team_Room_Member__c ();
            Team_Room_Member__c teamRoomMemberObj7= new Team_Room_Member__c ();
            Team_Room_Member__c teamRoomMemberObj8= new Team_Room_Member__c ();
            Team_Room_Member__c teamRoomMemberObj9= new Team_Room_Member__c ();
            Team_Room_Member__c teamRoomMemberObj10= new Team_Room_Member__c ();
            
            List<Team_Room_Member__c> teamRoomMemberList=new List<Team_Room_Member__c>();                       
             
            acctObj = getAccount('MYTEST ACCOUNT1');
            //conobj=new Contact(FirstName='Mr',LastName='Testcon1',AccountId=acctObj.Id,Email='con1@gf.com',Department__c='Design');                          
            //conobj1=new Contact(FirstName='Mr1',LastName='Testcon2',AccountId=acctObj.Id,Email='con2@gf.com',Department__c='Design');                          
            //insert conobj;
            //insert conobj1;
            User internaluserObj = [Select Id, Name from User where Email='TJohn1@test.com'];
            User internaluserObj1 = [Select Id, Name from User where Email='TJohn11@test.com'];
            User internaluserObj2 = [Select Id, Name from User where Email='TJohn12@test.com'];
            User internaluserObj3 = [Select Id, Name from User where Email='TJohn13@test.com'];
            User internaluserObj4 = [Select Id, Name from User where Email='TJohn14@test.com'];
            User internaluserObj5 = [Select Id, Name from User where Email='TJohn15@test.com'];
            User internaluserObj6 = [Select Id, Name from User where Email='TJohn16@test.com'];
            User internaluserObj7 = [Select Id, Name from User where Email='TJohn17@test.com'];
            User internaluserObj8 = [Select Id, Name from User where Email='TTJohn18@test.com'];
            User internaluserObj9 = [Select Id, Name from User where Email='TJohn19@test.com'];
            User externaluserObj = [Select Id, Name from User where Email='portal1@test.com'];
            User externaluserObj1 = [Select Id, Name from User where Email='portal2@test.com'];
            
            System.runAs(internaluserObj)
            {
                Test.startTest();
                AccountTeamMemberobj.AccountId=acctObj.Id;
                AccountTeamMemberobj.UserId  = internaluserObj1.Id;
                AccountTeamMemberobj.TeamMemberRole='Customer Service Rep';
                insert AccountTeamMemberobj;
                
                AccountTeamMemberobj1.AccountId=acctObj.Id;
                AccountTeamMemberobj1.UserId  = externaluserObj.Id;
                AccountTeamMemberobj1.TeamMemberRole='Customer Service Rep';
                insert AccountTeamMemberobj1;
                
                AccountTeamMemberobj2.AccountId=acctObj.Id;
                AccountTeamMemberobj2.UserId  = externaluserObj1.Id;
                AccountTeamMemberobj2.TeamMemberRole='Customer Service Rep';
                insert AccountTeamMemberobj2;
                               
                teamRoomObj.Name ='Team Room 1';
                teamRoomObj.Team_Room_Description__c = 'Team Room Description';
                teamRoomObj.Terms_n_Conditions_Accepted__c = true;
                teamRoomObj.OwnerId=internaluserObj.id;
                teamRoomObj.RecordTypeId=objRecordtype.Id;
                teamRoomObj.Primary_Account__c=acctObj.Id;
                insert teamRoomObj;
               
                teamRoomAccObj.Team_Room__c = teamRoomObj.Id;
                teamRoomAccObj.Account__c = acctObj.Id;
                
                insert teamRoomAccObj;
                teamRoomMemberObj.Team_Room__c = teamRoomObj.Id;
                teamRoomMemberObj.User__c = internaluserObj1.Id;
                teamRoomMemberObj.Access__c ='Read';
                teamRoomMemberObj.Account__c =acctObj.Id;
                teamRoomMemberObj.Team_Room_Role__c='Moderator';
                //insert teamRoomMemberObj;
                
                teamRoomMemberObj1.Team_Room__c = teamRoomObj.Id;
                teamRoomMemberObj1.User__c = internaluserObj2.Id;
                teamRoomMemberObj1.Access__c ='Read';
                teamRoomMemberObj1.Account__c =acctObj.Id;
                teamRoomMemberObj1.Team_Room_Role__c='Internal Member';
                //insert teamRoomMemberObj1;
                
                teamRoomMemberObj2.Team_Room__c = teamRoomObj.Id;
                teamRoomMemberObj2.User__c = internaluserObj5.Id;
                teamRoomMemberObj2.Access__c ='Read';
                teamRoomMemberObj2.Public_Group_Name__c='00G90000000HEtZ';
                teamRoomMemberObj2.Team_Room_Role__c='Moderator';
                //insert teamRoomMemberObj2;

                teamRoomMemberObj3.Team_Room__c = teamRoomObj.Id;
                teamRoomMemberObj3.User__c = internaluserObj3.Id;
                teamRoomMemberObj3.Access__c ='Read';
                teamRoomMemberObj3.Public_Group_Name__c='00G90000000HEtZ';
                teamRoomMemberObj3.Team_Room_Role__c='Moderator';
                //insert teamRoomMemberObj3;              
 
                teamRoomMemberObj4.Team_Room__c = teamRoomObj.Id;
                teamRoomMemberObj4.User__c = internaluserObj4.Id;
                teamRoomMemberObj4.Access__c ='Read';
                teamRoomMemberObj4.Team_Room_Role__c='Internal Member';
                
                teamRoomMemberObj5.Team_Room__c = teamRoomObj.Id;
                teamRoomMemberObj5.User__c = internaluserObj7.Id;
                //teamRoomMemberObj5.Access__c ='Read';
                teamRoomMemberObj5.Team_Room_Role__c='Owner';
                //insert teamRoomMemberObj4;                
                                
                teamRoomMemberObj6.Team_Room__c = teamRoomObj.Id;
                teamRoomMemberObj6.User__c = internaluserObj8.Id;
                teamRoomMemberObj6.Access__c ='Read';
                teamRoomMemberObj6.Public_Group_Name__c='00G90000000HXWn';
                teamRoomMemberObj6.Team_Room_Role__c='Internal Member';
                //insert teamRoomMemberObj2;

                teamRoomMemberObj7.Team_Room__c = teamRoomObj.Id;
                teamRoomMemberObj7.User__c = internaluserObj9.Id;
                teamRoomMemberObj7.Access__c ='Read';
                teamRoomMemberObj7.Public_Group_Name__c='00G90000000HXWn';
                teamRoomMemberObj7.Team_Room_Role__c='Internal Member';
                
                teamRoomMemberObj9.Team_Room__c = teamRoomObj.Id;
                teamRoomMemberObj9.User__c = externaluserObj.Id;
                teamRoomMemberObj9.Access__c ='Read';
                teamRoomMemberObj9.Team_Room_Role__c='External Member';
                teamRoomMemberObj9.User_selected__c=True;
                
                teamRoomMemberObj10.Team_Room__c = teamRoomObj.Id;
                teamRoomMemberObj10.User__c = externaluserObj1.Id;
                teamRoomMemberObj10.Access__c ='Read';
                teamRoomMemberObj10.Public_Group_Name__c='00G90000000HXWn';
                teamRoomMemberObj10.Team_Room_Role__c='External Member';
                                
                teamRoomMemberList.add(teamRoomMemberObj);
                teamRoomMemberList.add(teamRoomMemberObj1);
                teamRoomMemberList.add(teamRoomMemberObj2);
                teamRoomMemberList.add(teamRoomMemberObj3);
                teamRoomMemberList.add(teamRoomMemberObj4);
                teamRoomMemberList.add(teamRoomMemberObj5);
                teamRoomMemberList.add(teamRoomMemberObj6);
                teamRoomMemberList.add(teamRoomMemberObj7);
                teamRoomMemberList.add(teamRoomMemberObj9);
                teamRoomMemberList.add(teamRoomMemberObj10);
                //Test.startTest();
                insert teamRoomMemberList;
                
                teamRoomMemberObj8.Team_Room__c = teamRoomObj.Id;
                teamRoomMemberObj8.User__c = internaluserObj9.Id;
                teamRoomMemberObj8.Access__c ='Read';
                teamRoomMemberObj8.Public_Group_Name__c='00G90000000HXWn';
                teamRoomMemberObj8.Team_Room_Role__c='Internal Member';
                             
                Test.setCurrentPageReference(new PageReference('Page.VFTeamRoomManageMembership')); 
                System.currentPageReference().getParameters().put('id', String.valueOf(teamRoomObj.id));
                clsTeamRoomManageMembership clsTeamRoomManageMembershipobj= new clsTeamRoomManageMembership();  
                    
                clsTeamRoomManageMembership.clsGroupMember grpmem=new clsTeamRoomManageMembership.clsGroupMember();
                clsTeamRoomManageMembership.clsAccountMember acctmem=new clsTeamRoomManageMembership.clsAccountMember();
                
                List<Selectoption> memRole=clsTeamRoomManageMembershipobj.MemberRoleList;
                
                List<Selectoption> accList=clsTeamRoomManageMembershipobj.AccountList;
                List<Selectoption> groupList=clsTeamRoomManageMembershipobj.PublicGroupList;

                clsTeamRoomManageMembershipobj.Cancel();
                
                
                grpmem.sGroupId='00G90000000H9qH';
                grpmem.sGroupName='Biz Ops';
                grpmem.sMemberRole='Internal Member';
                
                clsTeamRoomManageMembershipobj.GroupMemberList.add(grpmem);
                
                clsTeamRoomManageMembershipobj.Save();
                clsTeamRoomManageMembershipobj.addAccountRow();
                clsTeamRoomManageMembershipobj.addUserRow();
                clsTeamRoomManageMembershipobj.addGroupRow();
                clsTeamRoomManageMembershipobj.deleteUser();
                clsTeamRoomManageMembershipobj.deleteAccount();
                clsTeamRoomManageMembershipobj.deleteGroup();
                system.assertEquals(grpmem.sMemberRole,'Internal Member');
            
                Test.stopTest();    
                    
            }           
    }
        
    private static Account getAccount(string AccountName)
    {
        Account acct = [SELECT Id, Name FROM Account Where Name =: AccountName];
        
        return acct;
    }       
}