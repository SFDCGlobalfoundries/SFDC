/**********************************************************************************************************************************************
Class:         DeviceChecklistAdminConsoleTest
-----------------------------------------------------------------------------------------------------------------------------------------------
Author:        Joydev Mondol (Cognizant - 153480)
Created Date:  15/05/2014
Reason:        Test class that covers module/page - "DeviceChecklistAdminConsole":
               (1) Test cases for controller class "DeviceChecklistAdminConsoleController" 
               (2) Test cases for controller class "AutoComplete_Con" 

Change Log:    Created     -     JOYDEV     -     15/05/2014     
Change Log:    Updated     -     JOYDEV     -     13/06/2014  
               [Reason] (1) Updated code to load environment variables.
                        (2) External user search scenario not required any more 
               Updated      -   Sreedhar    -   7/23/2014   
                        (3) Added Load Environment variables logic to test cases   
**********************************************************************************************************************************************/

@isTest(SeeAllData=false)
public class DeviceChecklistAdminConsoleTest{
    

    @testSetup
    static void testDataSetup(){
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
        fieldValueMap.put('recordtypeid', EnvironmentVariable.get('ACCT_RT_ID_CUSTOMER'));

        AccountDataFactory.createAccount(fieldValueMap);
    }

    /**
     * Try wrong permission set assignement(Permission Set is not available in the org) 
     **/
    public static testMethod void DeviceChecklistAdminConsoleControllerTest0() {
        PageReference pageRef = Page.DeviceChecklistAdminConsole;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('set', 'No_Such_Permission_Set_XXXX');
        test.startTest();
        DeviceChecklistAdminConsoleController controller = new DeviceChecklistAdminConsoleController();
        System.assertEquals(null, controller.Permission, 'There should not be any permission');
        test.stopTest();
    }
    
    /**
     * 
     * Create permission set and assign it 
     **/
    public static testMethod void DeviceChecklistAdminConsoleControllerTest1() {
        User usr = createUser();
        insert usr;
        PermissionSet perSet = createPermissionSet('PS_AX');
        insert perSet;
        PermissionSetAssignment perSetAsgn = createPermissionSetAssignment(usr.Id, perSet.Id);
        insert perSetAsgn;
        PageReference pageRef = Page.DeviceChecklistAdminConsole;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('set', perSet.Name);
        test.startTest();
        DeviceChecklistAdminConsoleController controller = new DeviceChecklistAdminConsoleController();
        System.assertNotEquals(null, controller.Permission, 'There should be permission');
        System.assertEquals('PS_AX', controller.Permission.name);
        System.assertEquals(1, controller.DeviceChecklistUsers.size(), 'One user should be there');
        test.stopTest();
    }
    
    /**
     * Assign a permission set to a user
     **/
    public static testMethod void DeviceChecklistAdminConsoleControllerTest2() {
        User usr = createUser();
        insert usr;
        PermissionSet perSet = createPermissionSet('PS_AX');
        insert perSet;
        
        PermissionSetAssignment perSetAsgn = createPermissionSetAssignment(usr.Id, perSet.Id);
        insert perSetAsgn;
        System.runAs(usr){
            GF_TaskRay_Project_NPI_Editors__c npiEditor = createCustomSetting(usr.Id);
            insert npiEditor;
            PageReference pageRef = Page.DeviceChecklistAdminConsole;
            Test.setCurrentPage(pageRef);
            ApexPages.currentPage().getParameters().put('set', perSet.Name);
            test.startTest();
            DeviceChecklistAdminConsoleController controller = new DeviceChecklistAdminConsoleController();
            System.assertNotEquals(null, controller.Permission, 'There should be permission');
            System.assertEquals('PS_AX', controller.Permission.name);
            System.assertEquals(1, controller.DeviceChecklistUsers.size(), 'One user should be there');
            test.stopTest();
        }
    }
    
    public static testMethod void DeviceChecklistAdminConsoleControllerTest3() {
        User usr = createUser();
        insert usr;
        PermissionSet perSet = createPermissionSet('PS_BX');        
        insert perSet;
        PageReference pageRef = Page.DeviceChecklistAdminConsole;
        Test.setCurrentPage(pageRef);      
        ApexPages.currentPage().getParameters().put('set', perSet.Name);
        DeviceChecklistAdminConsoleController controller = new DeviceChecklistAdminConsoleController();
        test.startTest();
        controller.TargetUser = usr.Id;
        controller.AddUser();
        
        List<PermissionSetAssignment> afterAddingAssignment = [SELECT Id,
                                                             AssigneeId,
                                                             Assignee.Name,
                                                             PermissionSetId
                                                        FROM PermissionSetAssignment
                                                       WHERE PermissionSetId = :perSet.Id];
        System.assertEquals(1, afterAddingAssignment.size(), 'One user should be assigned with this permission');
        System.assertEquals(usr.Id, afterAddingAssignment[0].AssigneeId, 'One user should be assigned with this permission');
        /*List<GF_TaskRay_Project_NPI_Editors__c> customSettingsAfterAdd = [SELECT Id,
                                                                   SetupOwnerId,
                                                                   NPI_Project_Template_Editable__c
                                                              FROM GF_TaskRay_Project_NPI_Editors__c]; 
        
        System.assertEquals(1, customSettingsAfterAdd.size(), 'One Custom setting should be inserted');
        System.assertEquals(true, customSettingsAfterAdd[0].NPI_Project_Template_Editable__c, 'One Custom setting should be inserted');*/
        
        controller.TargetUser = usr.Id;
        controller.RemoveUser();
        List<PermissionSetAssignment> afterRemovingAssignment = [SELECT Id,
                                                             AssigneeId,
                                                             Assignee.Name,
                                                             PermissionSetId
                                                        FROM PermissionSetAssignment
                                                       WHERE PermissionSetId = :perSet.Id];
        System.assertEquals(1, afterRemovingAssignment.size(), 'One user should be assigned with this permission');
        test.stopTest();
    }
    
    /*public static testMethod void DeviceChecklistAdminConsoleControllerTest4() {
        User usr = createUser();
        insert usr;
        
        PermissionSet perSet = createPermissionSet('PS_BX');        
        insert perSet;
        
        PageReference pageRef = Page.DeviceChecklistAdminConsole;
        Test.setCurrentPage(pageRef);
      
        ApexPages.currentPage().getParameters().put('set', perSet.Name);
        
        DeviceChecklistAdminConsoleController controller = new DeviceChecklistAdminConsoleController();
        
        test.startTest();
        controller.TargetUser = usr.Id;
        controller.AddUser();
        
        controller.TargetUser = '01pN0000000DmgR';
        controller.AddUser();
        
        controller.TargetUser = usr.Id;
        controller.AddUser();
        test.stopTest();
    }*/
    
    /**
     * Make a user as admin
     **/
    public static testMethod void DeviceChecklistAdminConsoleControllerTest5() {
        User usr = createUser();
        insert usr;
        PermissionSet perSet = createPermissionSet('PS_BX');        
        insert perSet;
        //PermissionSetAssignment perSetAsgn = createPermissionSetAssignment(usr.Id, perSet.Id);
        //insert perSetAsgn;
        PageReference pageRef = Page.DeviceChecklistAdminConsole;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('set', perSet.Name);
        DeviceChecklistAdminConsoleController controller = new DeviceChecklistAdminConsoleController();
        test.startTest();
        controller.TargetUser = usr.Id;
        controller.AddUser();
        controller.TargetUser = usr.Id;
        controller.ChangeAdmin();
        test.stopTest();
       
        List<PermissionSetAssignment> afterAddingAssignment = [SELECT Id,
                                                             AssigneeId,
                                                             Assignee.Name,
                                                             PermissionSetId
                                                        FROM PermissionSetAssignment
                                                       WHERE PermissionSetId = :perSet.Id];
        System.assertEquals(1, afterAddingAssignment.size(), 'One user should be assigned with this permission');
        System.assertEquals(usr.Id, afterAddingAssignment[0].AssigneeId, 'One user should be assigned with this permission');
    }
    
    
   public static testMethod void DeviceChecklistAdminConsoleControllerTest6() {
        User usr = createUser();
        insert usr;
        PermissionSet perSet = createPermissionSet('PS_BX');
        PermissionSetAssignment perSetAsgn = createPermissionSetAssignment(usr.Id, perSet.Id);
        GF_TaskRay_Project_NPI_Editors__c npiEditor = createCustomSetting(usr.Id);
        PageReference pageRef = Page.DeviceChecklistAdminConsole;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('set', perSet.Name);
        DeviceChecklistAdminConsoleController controller = new DeviceChecklistAdminConsoleController();
        test.startTest();
        controller.DeviceChecklistUsers.put(usr.Id, new DeviceChecklistAdminConsoleController.DeviceChecklistUser(usr.Id));
        controller.DeviceChecklistUsers.put(usr.Id, new DeviceChecklistAdminConsoleController.DeviceChecklistUser(perSetAsgn));
        controller.DeviceChecklistUsers.put(usr.Id, new DeviceChecklistAdminConsoleController.DeviceChecklistUser(npiEditor));
        controller.DeviceChecklistUsers.put(usr.Id, new DeviceChecklistAdminConsoleController.DeviceChecklistUser(perSetAsgn, npiEditor));
        test.stopTest();
    }
    
    public static testMethod void AutoCompleteV2_ConTest0() {
        List<Account> accountList = new List<Account>();
        /*for(Integer iCounter = 0 ; iCounter < 3; iCounter++){
            accountList.add(createXAccount());
        }*/
        
        insert accountList;
        
        accountList.add(getAccount('MYTEST ACCOUNT1'));
        Test.startTest();
        //System.assertEquals(accountList.size(),AutoCompleteV2_Con.getData('Account','Name','Id','X153480Test','').size());
        //System.assertEquals(0,AutoCompleteV2_Con.getData('Account','Name','Id','xxxxxxx','').size());
        AutoCompleteV2_Con controller = new AutoCompleteV2_Con();
        controller.setCacheField('X153480Test');
        controller.setTargetFieldVar(accountList[0].Name);
        controller.getTargetFieldVar();
        Test.stopTest();
    }
    
    public static GF_TaskRay_Project_NPI_Editors__c createCustomSetting(Id setupOwnerId) {
        return new GF_TaskRay_Project_NPI_Editors__c(SetupOwnerId = setupOwnerId);
    }
    
    public static Account createXAccount(){
        RecordType recType = [select id from RecordType where Name='Customer' limit 1];
        
        return new Account(Name='X153480Test Account' + Math.Random(),
                           RecordTypeId=recType.id,
                           Site_Department__c='IT',
                           Sub_Type__c='Indirect',
                           Transaction_Type__c='Non-Transactional',
                           Region__c='US',
                           Bill_To_Address_1__c='Test Address',
                           Bill_To_City__c='Test City',
                           Bill_To_Country__c='India',
                           Corporate_Address_1__c='Test Address',
                           Corporate_City__c='Test City',
                           Corporate_Country__c='India',
                           Tech_Geo_Granted__c = '65nm',
                           Valid_Tech_Geos__c = '65nm',
                           OwnerId = UserInfo.getUserId());
    }
    
    public static User createUser(){
        Profile prf = [Select Id 
                         From Profile 
                        Where Name = 'System Administrator'];
                        
        return new User(alias = ('xU' + Math.Random()).substring(0,7),
                        email = 'xUser@testorg.com' + Math.Random(),
                        emailencodingkey = 'UTF-8',
                        lastname = 'xUser' + Math.Random(), 
                        languagelocalekey = 'en_US',
                        localesidkey = 'en_US',
                        profileid = prf.Id,
                        Portal_Login__c = 'TestxUserLogin0001' + Math.Random(),
                        timezonesidkey = 'America/Los_Angeles',
                        username = 'xUser@testorg.com' + Math.Random());
    }
    
    
    
    public static PermissionSet createPermissionSet(String apiName){
        return new PermissionSet(label = ('PS' + Math.Random()).substring(0,7),
                                 name = apiName);
    }
    
    public static PermissionSetAssignment createPermissionSetAssignment(Id userId, Id perSetId){
        return new PermissionSetAssignment(AssigneeId = userId, 
                                           PermissionSetId = perSetId);
    }
    
    private static Account getAccount(string AccountName)
    {
        Account acct = [SELECT Id, Name FROM Account Where Name =: AccountName];
        
        return acct;
    }

}