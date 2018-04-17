/*
    Author: DBiswal
    Description: Apex test class for Classes CXM_escalationTeamSelectController, CXM_actionMgmtmassEditController, 
                 CXM_BatchEscalationReminders, CXM_actionMgmtTriggerHelper and Trigger CXM_actionMgmtTrigger.
    History: 
        DBiswal    04112017    Modified for Escalation team enhancement.
        DBiswal    07132017    Modified for best practices.
*/

@istest
public class CXM_combinedClassesTest{
    
    private static String CRON_EXP = '0 0 0 15 3 ? 2022';
    
    @testsetup static void setupData(){
        DataUtilTest.loadEnvironmentVariables();
        
        Map<String,Object> fieldValueMap = new Map<String,Object>();
        fieldValueMap.put('Name', 'MYTEST ACCOUNT34');  
        fieldValueMap.put('Account_Type__c', 'Customer');                           
        fieldValueMap.put('sub_type__c', 'Indirect');        
        fieldValueMap.put('site_department__c', 'IT');  
        fieldValueMap.put('Account_Manager__c', userinfo.getuserid());        
        fieldValueMap.put('transaction_type__c', 'Non-Transactional');                          
        fieldValueMap.put('region__c', 'US');        
        fieldValueMap.put('Corporate_Address_1__c', 'Test Address 1');          
        fieldValueMap.put('Corporate_City__c', 'Test City');                
        fieldValueMap.put('Corporate_Country__c', 'Singapore');
        fieldValueMap.put('Bill_To_Address_1__c', 'Test Address 1');          
        fieldValueMap.put('Bill_To_City__c', 'Test City');            
        fieldValueMap.put('Bill_To_Country__c', 'Singapore');        
        fieldValueMap.put('Fab_9_10__c','No');
        Account acc = AccountDataFactory.createAccount(fieldValueMap);
        
        System.assertNotEquals(acc,null);
        acc.Region__c = 'US';
        acc.Sales_Territory__c = 'US NW';
        acc.FE_Territory__c = 'US-FE-West';
        acc.financial_territory__c = 'US NW';
        acc.Region_Head_lk__c = UserInfo.getUserId();
        try{
            Database.update(acc);
        }catch(Exception e){
            GlobalUtility.logMessage('Error', 'CXM_combinedClassesTest', 'setupData','', 'Exception while updating Account record', String.valueof(e.getMessage()),'','Action Management',e,0);
        }
    }
    
    public static testMethod void unittest1(){
        User sysAdminUser = [SELECT Id,Name FROM User WHERE Profile.Name = 'System Administrator' AND isActive = true].get(0);
        System.runAs(sysAdminUser){
            try{
                Profile stdUserProfile = [SELECT Id FROM Profile WHERE Name='Standard User'];
                UserRole usrRole=[SELECT Id FROM UserRole WHERE Name = 'GLOBALFOUNDRIES Corporate'];
                
                User userSU = new User(alias = 'testMR56', email='testMR56@test.com',
                emailencodingkey='UTF-8', lastname='testMR56Last', firstname='testMR56First', languagelocalekey='en_US',
                localesidkey='en_US', profileid = stdUserProfile.Id, UserRoleId = usrRole.Id,
                timezonesidkey='America/Los_Angeles', username='testMR56@test.com',communitynickname='testMR56');
                
                Database.insert(userSU);
                
                Account accountObj = getAccount('MYTEST ACCOUNT34');
                Contact con = QS_TestUtil.createContact('Test Cont3t', 'Test Con4t', accountObj.Id, 'tes456@tes4t.com', 'Customers My Device Admin; Primary Account Admin', 
                                                'Design; Engineering; Quality; Procurement; Supply Chain; Legal', true, true);
                Database.insert(con);
                                
                Escalation_Complaint__c actmgmt = new Escalation_Complaint__c(Account__c=accountObj.id,Subject__c='test action',Escalation_Severity__c='G - Action, Customer Satisfied',Escalation_Level__c='L1 - Customer Action',
                                                                              Stage__c='Assigned',Type__c='Quality',Department__c='Quality',Expected_Close_Date__c=Date.today().addDays(4),
                                                                              Escalation_User_1__c=userinfo.getUserId(),Escalation_User_2__c=userinfo.getUserId(),Escalation_User_3__c=userSU.Id);
                Database.insert(actmgmt);
                System.assertNotEquals(actmgmt,null);
                List<CXM_Escalation_Team__c> escTeamstotestIns = new List<CXM_Escalation_Team__c>();
                escTeamstotestIns.add(new CXM_Escalation_Team__c(Action_Management__c = actmgmt.Id,User__c = userSU.Id,Escalation_Level__c = 'L2 - Account Team Level'));
                escTeamstotestIns.add(new CXM_Escalation_Team__c(Action_Management__c = actmgmt.Id,User__c = UserInfo.getUserId(),Escalation_Level__c = 'L3 - Director/VP'));
                
                
                Test.startTest();
                    Database.insert(escTeamstotestIns);
                    System.assert(escTeamstotestIns.size() > 0);
                    ApexPages.StandardController controller = new ApexPages.StandardController(actmgmt);
                    CXM_escalationTeamSelectController cxmctrl = new CXM_escalationTeamSelectController(controller);
                    for(CXM_escalationTeamSelectController.customerActionWrapper cust : cxmctrl.customerActionWrapperList){
                        cust.isSelected = true;
                        cust.level = 'Action Owner';
                    }
                    cxmctrl.allSelected = true;
                    cxmctrl.saveRecOthers();
                    cxmctrl.settheBox();
                    cxmctrl.saveRecCustomers();
                    cxmctrl.editCXMteam();
                    cxmctrl.saveCXMteam();
                    cxmctrl.addCXMteam();
                    try{
                        cxmctrl.removeCXMteam();
                    }catch(exception e){
                        GlobalUtility.logMessage('Error', 'CXM_combinedClassesTest', 'unittest1','', 'Exception while testing removeCXMteam method', String.valueof(e.getMessage()),'','Action Management',e,0);
                    }
                    actmgmt.Stage__c = 'Closed';
                    actmgmt.Assigned_Resolution_Owner__c = UserInfo.getUserId();
                    actmgmt.Resolution__c = 'solved';
                    Database.update(actmgmt);
                    System.assertEquals(actmgmt.Resolution__c, 'solved');
                    ApexPages.StandardController controller1 = new ApexPages.StandardController(new Escalation_Complaint__c());
                    CXM_escalationTeamSelectController cxmctrl1 = new CXM_escalationTeamSelectController(controller1);
                    cxmctrl1.saveRecOthers();
                    cxmctrl1.saveRecCustomers();
                Test.stopTest();
            }catch(Exception e){
                GlobalUtility.logMessage('Error', 'CXM_combinedClassesTest', 'unittest1','', 'Exception while running test method', String.valueof(e.getMessage()),'','Action Management',e,0);
            }
        }
    }
    
    public static testMethod void unittest2(){
        
        User sysAdminUser = [SELECT Id,Name FROM User WHERE Profile.Name = 'System Administrator' AND isActive = true].get(0);
        String loggedusrId = Userinfo.getUserId();
        System.runAs(sysAdminUser){
            Profile stdUserProfile = [SELECT Id FROM Profile WHERE Name='Standard User'];
            UserRole usrRole=[SELECT Id FROM UserRole WHERE Name = 'GLOBALFOUNDRIES Corporate'];
            
            try{
                User userSU = new User(alias = 'testMR57', email='testMR57@test.com',
                emailencodingkey='UTF-8', lastname='testMR57Last', firstname='testMR57First', languagelocalekey='en_US',
                localesidkey='en_US', profileid = stdUserProfile.Id, UserRoleId = usrRole.Id,
                timezonesidkey='America/Los_Angeles', username='testMR57@test.com',communitynickname='testMR57');
                
                Database.insert(userSU);
                
                Account accountObj = getAccount('MYTEST ACCOUNT34');
                
                Contact con = QS_TestUtil.createContact('Test Cont6t', 'Test Con7t', accountObj.Id, 'tes486@tes8t.com', 'Customers My Device Admin; Primary Account Admin', 
                                                'Design; Engineering; Quality; Procurement; Supply Chain; Legal', true, true);
                Database.insert(con);
                                
                Test.startTest();
                Escalation_Complaint__c actmgmt0 = new Escalation_Complaint__c(Account__c=accountObj.id,Subject__c='test action0',Escalation_Severity__c='Y - Major Action, Potential Dissatisfaction',
                                                                              Stage__c='New',Type__c='Quality',Department__c='Quality',Expected_Close_Date__c=Date.today().addDays(10),Escalation_Level__c='L2 - Account Team Level',
                                                                              Escalation_User_1__c=userinfo.getUserId(),Escalation_User_2__c=userinfo.getUserId(),Escalation_User_3__c=userSU.Id,Assigned_Resolution_Owner__c=loggedusrId);
                Escalation_Complaint__c actmgmt1 = new Escalation_Complaint__c(Account__c=accountObj.id,Subject__c='test action1',Escalation_Severity__c='G - Action, Customer Satisfied',
                                                                              Stage__c='Assigned',Type__c='Quality',Department__c='Quality',Expected_Close_Date__c=Date.today().addDays(1),Escalation_Level__c='L1 - Customer Action',
                                                                              Escalation_User_1__c=userinfo.getUserId(),Escalation_User_2__c=userinfo.getUserId(),Escalation_User_3__c=userSU.Id);
                Escalation_Complaint__c actmgmt2 = new Escalation_Complaint__c(Account__c=accountObj.id,Subject__c='test action2',Escalation_Severity__c='G - Action, Customer Satisfied',
                                                                              Stage__c='Assigned',Type__c='Quality',Department__c='Quality',Expected_Close_Date__c=Date.today().addDays(2),Escalation_Level__c='L2 - Account Team Level',
                                                                              Escalation_User_1__c=userinfo.getUserId(),Escalation_User_2__c=userinfo.getUserId(),Escalation_User_3__c=userSU.Id);
                Escalation_Complaint__c actmgmt3 = new Escalation_Complaint__c(Account__c=accountObj.id,Subject__c='test action3',Escalation_Severity__c='G - Action, Customer Satisfied',
                                                                              Stage__c='Reassign',Type__c='Business',Department__c='TD',Expected_Close_Date__c=Date.today().addDays(4),Escalation_Level__c='L3 - Director/VP',
                                                                              Escalation_User_1__c=userinfo.getUserId(),Escalation_User_2__c=userinfo.getUserId(),Escalation_User_3__c=userSU.Id);
                List<Escalation_Complaint__c> actmgmtListIns = new List<Escalation_Complaint__c>{actmgmt0,actmgmt1,actmgmt2,actmgmt3};
                Database.insert(actmgmtListIns);
                
                List<CXM_Escalation_Team__c> escTeamstotestIns = new List<CXM_Escalation_Team__c>();
                escTeamstotestIns.add(new CXM_Escalation_Team__c(Action_Management__c = actmgmt0.Id,User__c = userSU.Id,Escalation_Level__c = 'L2 - Account Team Level'));
                escTeamstotestIns.add(new CXM_Escalation_Team__c(Action_Management__c = actmgmt1.Id,User__c = userSU.Id,Escalation_Level__c = 'L2 - Account Team Level'));
                escTeamstotestIns.add(new CXM_Escalation_Team__c(Action_Management__c = actmgmt2.Id,User__c = UserInfo.getUserId(),Escalation_Level__c = 'L3 - Director/VP'));
                escTeamstotestIns.add(new CXM_Escalation_Team__c(Action_Management__c = actmgmt3.Id,User__c = UserInfo.getUserId(),Escalation_Level__c = 'L4 - Sr VP'));
                Database.insert(escTeamstotestIns);
                
                    actmgmt0.Stage__c = 'Acknowledged';
                    actmgmt0.Escalation_Level_Change_Date__c = Date.today().addDays(-11);
                    
                    actmgmt1.Stage__c = 'In Process';
                    actmgmt1.Expected_Close_Date__c = Date.today().addDays(-1);
                    actmgmt1.Escalation_Level__c= 'L2 - Account Team Level';
                    
                    actmgmt2.Escalation_Level_Change_Date__c = Date.today().addDays(-17);
                    actmgmt2.Expected_Close_Date__c = Date.today().addDays(-29);
                
                    actmgmt3.Escalation_Level_Change_Date__c = Date.today().addDays(-12);
                    actmgmt3.Expected_Close_Date__c = Date.today().addDays(-24);
                    
                    List<Escalation_Complaint__c> actmgmtListUpd = new List<Escalation_Complaint__c>{actmgmt0,actmgmt1,actmgmt2,actmgmt3};
                    Database.update(actmgmtListUpd);
                    
                    System.assertEquals(actmgmt1.Escalation_Level__c, 'L2 - Account Team Level');
                    System.assert(actmgmtListUpd != null);
                    System.schedule('Schedule CXM Reminders-test1', CRON_EXP, new CXM_BatchEscalationReminders());
                Test.stopTest();
            }catch(Exception e){
                GlobalUtility.logMessage('Error', 'CXM_combinedClassesTest', 'unittest2','', 'Exception while running test method', String.valueof(e.getMessage()),'','Action Management',e,0);
            }
        }
    }
    
    public static testMethod void unittest3(){
        
        User sysAdminUser = [SELECT Id,Name FROM User WHERE Profile.Name = 'System Administrator' AND isActive = true].get(0);
        System.runAs(sysAdminUser){
            Profile stdUserProfile = [SELECT Id FROM Profile WHERE Name='Standard User'];
            UserRole usrRole=[SELECT Id FROM UserRole WHERE Name = 'GLOBALFOUNDRIES Corporate'];
            
            try{
                User userSU = new User(alias = 'testMR58', email='testMR58@test.com',
                emailencodingkey='UTF-8', lastname='testMR58Last', firstname='testMR58First', languagelocalekey='en_US',
                localesidkey='en_US', profileid = stdUserProfile.Id, UserRoleId = usrRole.Id,
                timezonesidkey='America/Los_Angeles', username='testMR58@test.com',communitynickname='testMR58');
                
                Database.insert(userSU);
                
                Account accountObj = getAccount('MYTEST ACCOUNT34');
                Escalation_Complaint__c actmgmt1 = new Escalation_Complaint__c(Account__c=accountObj.id,Subject__c='test action1',Escalation_Severity__c='G - Action, Customer Satisfied',
                                                                              Stage__c='Assigned',Type__c='Quality',Department__c='Quality',Expected_Close_Date__c=Date.today().addDays(1),Escalation_Level__c='L3 - Director/VP',
                                                                              Escalation_User_1__c=userinfo.getUserId(),Escalation_User_2__c=userinfo.getUserId(),Escalation_User_3__c=userSU.Id);
                Escalation_Complaint__c actmgmt2 = new Escalation_Complaint__c(Account__c=accountObj.id,Subject__c='test action2',Escalation_Severity__c='G - Action, Customer Satisfied',
                                                                              Stage__c='Assigned',Type__c='Quality',Department__c='Quality',Expected_Close_Date__c=Date.today().addDays(2),Escalation_Level__c='L4 - Sr VP',
                                                                              Escalation_User_1__c=userinfo.getUserId(),Escalation_User_2__c=userinfo.getUserId(),Escalation_User_3__c=userSU.Id);
                Escalation_Complaint__c actmgmt3 = new Escalation_Complaint__c(Account__c=accountObj.id,Subject__c='test action3',Escalation_Severity__c='G - Action, Customer Satisfied',
                                                                              Stage__c='Assigned',Type__c='Business',Department__c='TD',Expected_Close_Date__c=Date.today().addDays(4),Escalation_Level__c='L2 - Account Team Level',
                                                                              Escalation_User_1__c=userinfo.getUserId(),Escalation_User_2__c=userinfo.getUserId(),Escalation_User_3__c=userSU.Id);
                List<Escalation_Complaint__c> actmgmtListIns = new List<Escalation_Complaint__c>{actmgmt1,actmgmt2,actmgmt3};
                Database.insert(actmgmtListIns);
                
                List<CXM_Escalation_Team__c> escTeamstotestIns = new List<CXM_Escalation_Team__c>();
                escTeamstotestIns.add(new CXM_Escalation_Team__c(Action_Management__c = actmgmt1.Id,User__c = userSU.Id,Escalation_Level__c = 'L3 - Director/VP'));
                escTeamstotestIns.add(new CXM_Escalation_Team__c(Action_Management__c = actmgmt2.Id,User__c = UserInfo.getUserId(),Escalation_Level__c = 'L4 - Sr VP'));
                escTeamstotestIns.add(new CXM_Escalation_Team__c(Action_Management__c = actmgmt3.Id,User__c = UserInfo.getUserId(),Escalation_Level__c = 'L3 - Director/VP'));
                Database.insert(escTeamstotestIns);
                
                Test.startTest();
                    CXM_actionMgmtmassEditController cxmedit = new CXM_actionMgmtmassEditController();
                    cxmedit.accountId = accountObj.id;
                    cxmedit.initiate();
                    for(CXM_actionMgmtmassEditController.actionmgmtwrapper actmwrap : cxmedit.actionmgmtwrapperList)
                    {
                        actmwrap.isSelected = true;
                    }
                    cxmedit.SaveActions();
                    cxmedit.SaveMultipleAcntMgmt();
                    Escalation_Complaint__c actmgmt4 = new Escalation_Complaint__c(Account__c=accountObj.id,Subject__c='test action4',Escalation_Severity__c='G - Action, Customer Satisfied',
                                                                              Stage__c='Assigned',Type__c='Business',Department__c='TD',Expected_Close_Date__c=Date.today().addDays(4),Escalation_Level__c='L2 - Account Team Level',
                                                                              Escalation_User_1__c=userinfo.getUserId(),Escalation_User_2__c=userinfo.getUserId(),Escalation_User_3__c=userSU.Id);
                    Database.insert(actmgmt4);
                    System.assertNotEquals(actmgmt4, null);
                    
                    CXM_actionMgmtmassEditController.WrapperpaActionMgmtList addActn = new CXM_actionMgmtmassEditController.WrapperpaActionMgmtList();
                    addActn.index = 1;
                    addActn.record = actmgmt4;  
                    cxmedit.waActnMgmtList.add(addActn);
                    for(CXM_actionMgmtmassEditController.actionmgmtwrapper actmwrap : cxmedit.actionmgmtwrapperList) {
                        actmwrap.isSelected = true;
                    }
                    cxmedit.addEscTeam();
                    cxmedit.saveEscTeam();
                    cxmedit.setescTeamSection();
                    cxmedit.setescTeamRemovalSection();
                    for(CXM_actionMgmtmassEditController.escalationTeamWrap escwrap : cxmedit.escTeamwrapRemovalList) {
                        escwrap.isSelected = true;
                    }
                    cxmedit.removeTeammethod();
                    cxmedit.SaveMultipleAcntMgmt();                
                    cxmedit.addNewRowToActnMgmtList();
                    try{
                        cxmedit.removeRowFromActnMgmtList();
                    }catch(exception e){
                        GlobalUtility.logMessage('Error', 'CXM_combinedClassesTest', 'unittest3','', 'Exception while testing removeRowFromActnMgmtList method', String.valueof(e.getMessage()),'','Action Management',e,0);
                    }
                    cxmedit.rowToRemove = 1;
                Test.stopTest();
            }catch(Exception e){
                GlobalUtility.logMessage('Error', 'CXM_combinedClassesTest', 'unittest3','', 'Exception while running test method', String.valueof(e.getMessage()),'','Action Management',e,0);
            }
        }
    }
    
    public static testMethod void unittest4(){
        
        try{
            Account accountObj = getAccount('MYTEST ACCOUNT34');
            Escalation_Complaint__c actmgmt1 = new Escalation_Complaint__c(Account__c=accountObj.id,Subject__c='test action1',Escalation_Severity__c='G - Action, Customer Satisfied',
                                                                          Stage__c='Assigned',Type__c='Quality',Department__c='Quality',Expected_Close_Date__c=Date.today().addDays(10),Escalation_Level__c='L3 - Director/VP',
                                                                          Escalation_User_1__c=userinfo.getUserId(),Escalation_User_2__c=userinfo.getUserId(),Alert_Senior_Leadership_Team__c = true);
            Escalation_Complaint__c actmgmt2 = new Escalation_Complaint__c(Account__c=accountObj.id,Subject__c='test action2',Escalation_Severity__c='G - Action, Customer Satisfied',
                                                                           Stage__c='Assigned',Type__c='Quality',Department__c='Quality',Expected_Close_Date__c=Date.today().addDays(20),Escalation_Level__c='L4 - Sr VP',
                                                                           Escalation_User_1__c=userinfo.getUserId(),Escalation_User_2__c=userinfo.getUserId(),Alert_Senior_Leadership_Team__c = true);
            
            Test.startTest();
                List<Escalation_Complaint__c> actmgmtListIns = new List<Escalation_Complaint__c>{actmgmt1,actmgmt2};
                Database.insert(actmgmtListIns);
                
                Database.delete(actmgmt1);
            Test.stopTest();
        }catch(Exception e){
            GlobalUtility.logMessage('Error', 'CXM_combinedClassesTest', 'unittest4','', 'Exception while running test method', String.valueof(e.getMessage()),'','Action Management',e,0);
        }
    }
    
    private static Account getAccount(string AccountName){
        Account acct = [SELECT Id, Name FROM Account Where Name =: AccountName];        
        return acct;
    }
}