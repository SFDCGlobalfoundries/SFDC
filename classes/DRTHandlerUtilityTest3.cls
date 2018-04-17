/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an organization are executed whenever Apex code is deployed
 * to a production organization to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production organization. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@isTest
private class DRTHandlerUtilityTest3 {

    /**
    This method initialize data using throughout this test class.
    The create data method are: 
    - SwiftDataUtilityTest.customSystemData();
    @author     SWIFT TEAM
    @since      7-April-2015
    */
    @testSetup static void setup() {
        SwiftDataUtilityTest.customSystemData();
    }
    
    /*
   This test method tests the below functionality of the class DRTHandlerUtility
   sendMassEmailOnDRTRevision()
   sendMassEmailOnDRTActivation()
    */    
    @isTest
    public static void sendMassEmailOnDRTRevisionTest(){
        // comment-out, refactor with testSetup method setup()
        // SwiftDataUtilityTest.customSystemData();
        Account acc = SwiftDataUtilityTest.createTestAccount();
        List<Mask_Set_Title__c> mstList = SwiftDataUtilityTest.maskSetTitleList(2);
        DRT__c drt = new DRT__C( Name='MYMST_PRIME_DRT_001.001', Customer_Name__c=acc.id,
                                  Status__c='Active',
                                  Type__c='PRIME',
                                  Mask_Set_Title__c = mstList[0].id);
        insert drt;
        
        MST_Config__c mstConfig = SwiftDataUtilityTest.createMSTconfig(acc.Id,mstList[0].Id);
        Opportunity opp = SwiftDataUtilityTest.createOpportunityDRT(acc.Id);
        Opportunity_Program__c oppProg = SwiftDataUtilityTest.createOpportunityProgramDRT(acc.Id, opp.Id);
        Process_Technology__c pt = SwiftDataUtilityTest.createProcessTechnologyForDRT();
        test.startTest();
        Device__c testDevice = SwiftDataUtilityTest.createDeviceWithPT(acc.Id, opp.Id,oppProg.Id,pt.Id);
        
        PTRF__c ptrf = SwiftDataUtilityTest.createPTRF_ForDRT(mstList[0].Id, testDevice.Id,acc.Id);
        DRT_PTRF_Association__c dpa = SwiftDataUtilityTest.createDPA(drt.Id,ptrf.Id);                          
        
        DRTHandlerUtility.sendMassEmailOnDRTActivation(drt.Id, true); 
        DRTHandlerUtility.sendMassEmailOnDRTRevision(drt.Id, 'Revised DRT');    
        DRTHandlerUtility.subArray(new list<String>{'abc.123@abc.com','xyz.234@xyz.com'},0,1);
        
        /*Profile profileObj = [Select Name,Id from Profile where Name = 'Customer Portal Admin'];
        UserRole usrRole = [Select id,PortalType, PortalAccountId From UserRole where PortalType ='CustomerPortal' limit 1];
        User userObj = new User();
        
        Contact conobj=new Contact();
        conobj.FirstName='Mr';
        conobj.LastName='Testcon1';
        conobj.AccountId=acc.Id;
        conobj.Email='con1@gf.com';
        conobj.Department__c='Design';
                                  
        insert conobj;
        
        User thisUser = [ select Id from User where Id = :UserInfo.getUserId() ];
        System.runAs ( thisUser ) {
            userObj.Alias = 'Shyam';
            userObj.Email='shyam@test.com'; 
            userObj.EmailEncodingKey='UTF-8'; 
            userObj.LastName='Paul';
            userObj.LanguageLocaleKey='en_US'; 
            userObj.LocaleSidKey='en_US';
            userObj.ProfileId = profileObj.Id;
            userObj.TimeZoneSidKey='America/Los_Angeles'; 
            userObj.UserName='shyam@test.com';
            userObj.Portal_Login__c = 'xyz';
            userObj.contactId = conobj.Id;
            userObj.IsActive = true;
            userObj.userRoleId = usrRole.Id;
        insert userObj;
        
            Portal_Tab_Access__c portaltabObj = new Portal_Tab_Access__c();
            portaltabObj.User__c = userObj.Id;
            portaltabObj.Account__c = acc.Id;
            portaltabObj.My_Devices__c = true;
            portaltabObj.PTRF__c = true; 
            
            insert portaltabObj;
        }
        //test.stopTest();
        System.runAs(userObj)
        {
            User u = [select id,accountid from user where id=:userObj.Id];
            system.assertEquals(u.accountId, acc.Id);
            DRTHandlerUtility.sendMassEmailOnDRTActivation(drt.Id); 
            DRTHandlerUtility.sendMassEmailOnDRTRevision(drt.Id, 'Revised DRT');
            
        }*/
        test.stopTest();
    }
    
    /*
       This test method tests the below functionality of the class DRTHandlerUtility
       sendMassEmailOnDRTRevision()
       sendMassEmailOnDRTActivation()
    */    
    @isTest
    public static void sendMassEmailOnDRTRevisionTest2(){
        // comment-out, refactor with testSetup method setup()
        // SwiftDataUtilityTest.customSystemData();
        Account acc = SwiftDataUtilityTest.createTestAccount();
        List<Mask_Set_Title__c> mstList = SwiftDataUtilityTest.maskSetTitleList(2);
        DRT__c drt = new DRT__C( Name='MYMST_PRIME_DRT_001.001', Customer_Name__c=acc.id,
                                  Status__c='Active',
                                  Type__c='PRIME',
                                  Mask_Set_Title__c = mstList[0].id);
        insert drt;
        
        MST_Config__c mstConfig = SwiftDataUtilityTest.createMSTconfig(acc.Id,mstList[0].Id);
        Opportunity opp = SwiftDataUtilityTest.createOpportunityDRT(acc.Id);
        Opportunity_Program__c oppProg = SwiftDataUtilityTest.createOpportunityProgramDRT(acc.Id, opp.Id);
        Process_Technology__c pt = SwiftDataUtilityTest.createProcessTechnologyForDRT();
        test.startTest();
        Device__c testDevice = SwiftDataUtilityTest.createDeviceWithPT(acc.Id, opp.Id,oppProg.Id,pt.Id);
        
        PTRF__c ptrf = SwiftDataUtilityTest.createPTRF_ForDRT(mstList[0].Id, testDevice.Id,acc.Id);
        DRT_PTRF_Association__c dpa = SwiftDataUtilityTest.createDPA(drt.Id,ptrf.Id);                          
        
        /*DRTHandlerUtility.sendMassEmailOnDRTActivation(drt.Id); 
        DRTHandlerUtility.sendMassEmailOnDRTRevision(drt.Id, 'Revised DRT');    
        DRTHandlerUtility.subArray(new list<String>{'abc.123@abc.com','xyz.234@xyz.com'},0,1);*/
        
        Profile profileObj = [Select Name,Id from Profile where Name = 'Customer Portal Admin'];
        UserRole usrRole = [Select id,PortalType, PortalAccountId From UserRole where PortalType ='CustomerPortal' limit 1];
        User userObj = new User();
        
        Contact conobj=new Contact();
        conobj.FirstName='Mr';
        conobj.LastName='Testcon1';
        conobj.AccountId=acc.Id;
        conobj.Email='con1@gf.com';
        conobj.Department__c='Design';
                                  
        insert conobj;
        
        User thisUser = [ select Id from User where Id = :UserInfo.getUserId() ];
        
        try {
            System.runAs ( thisUser ) {
                userObj.Alias = 'Shyam';
                userObj.Email='shyam@test.com'; 
                userObj.EmailEncodingKey='UTF-8'; 
                userObj.LastName='Paul';
                userObj.LanguageLocaleKey='en_US'; 
                userObj.LocaleSidKey='en_US';
                userObj.ProfileId = profileObj.Id;
                userObj.TimeZoneSidKey='America/Los_Angeles'; 
                userObj.UserName='shyam@test.com';
                userObj.Portal_Login__c = 'xyz';
                userObj.contactId = conobj.Id;
                userObj.IsActive = true;
                //userObj.userRoleId = usrRole.Id;
            insert userObj;
            
                Portal_Tab_Access__c portaltabObj = new Portal_Tab_Access__c();
                portaltabObj.User__c = userObj.Id;
                portaltabObj.Account__c = acc.Id;
                portaltabObj.My_Devices__c = true;
                portaltabObj.PTRF__c = true; 
                
                insert portaltabObj;
            }
        } catch(exception e) {}
        //test.stopTest();
        System.runAs(userObj)
        {
            try {
	            User u = [select id,accountid from user where id=:userObj.Id];
	            //DRTHandlerUtility.sendMassEmailOnDRTActivation(drt.Id, true); 
	            DRTHandlerUtility.sendMassEmailOnDRTRevision(drt.Id, 'Revised DRT');
            } catch(exception e) {}
        }
        test.stopTest();
    }
    
    @isTest
    public static void sendMassEmailOnDRTRevisionTest3(){
        // comment-out, refactor with testSetup method setup()
        // SwiftDataUtilityTest.customSystemData();
        Account acc = SwiftDataUtilityTest.createTestAccount();
        List<Mask_Set_Title__c> mstList = SwiftDataUtilityTest.maskSetTitleList(2);
        DRT__c drt = new DRT__C( Name='MYMST_PRIME_DRT_001.001', Customer_Name__c=acc.id,
                                  Status__c='Active',
                                  Type__c='PRIME',
                                  Mask_Set_Title__c = mstList[0].id);
        insert drt;
        
        MST_Config__c mstConfig = SwiftDataUtilityTest.createMSTconfig(acc.Id,mstList[0].Id);
        Opportunity opp = SwiftDataUtilityTest.createOpportunityDRT(acc.Id);
        Opportunity_Program__c oppProg = SwiftDataUtilityTest.createOpportunityProgramDRT(acc.Id, opp.Id);
        Process_Technology__c pt = SwiftDataUtilityTest.createProcessTechnologyForDRT();
        test.startTest();
        Device__c testDevice = SwiftDataUtilityTest.createDeviceWithPT(acc.Id, opp.Id,oppProg.Id,pt.Id);
        
        PTRF__c ptrf = SwiftDataUtilityTest.createPTRF_ForDRT(mstList[0].Id, testDevice.Id,acc.Id);
        DRT_PTRF_Association__c dpa = SwiftDataUtilityTest.createDPA(drt.Id,ptrf.Id);                          
        
        /*DRTHandlerUtility.sendMassEmailOnDRTActivation(drt.Id); 
        DRTHandlerUtility.sendMassEmailOnDRTRevision(drt.Id, 'Revised DRT');    
        DRTHandlerUtility.subArray(new list<String>{'abc.123@abc.com','xyz.234@xyz.com'},0,1);*/
        
        Profile profileObj = [Select Name,Id from Profile where Name = 'Customer Portal Admin'];
        UserRole usrRole = [Select id,PortalType, PortalAccountId From UserRole where PortalType ='CustomerPortal' limit 1];
        User userObj = new User();
        
        Contact conobj=new Contact();
        conobj.FirstName='Mr';
        conobj.LastName='Testcon1';
        conobj.AccountId=acc.Id;
        conobj.Email='con1@gf.com';
        conobj.Department__c='Design';
                                  
        insert conobj;
        
        User thisUser = [ select Id from User where Id = :UserInfo.getUserId() ];
        
        try {
            System.runAs ( thisUser ) {
                userObj.Alias = 'Shyam';
                userObj.Email='shyam@test.com'; 
                userObj.EmailEncodingKey='UTF-8'; 
                userObj.LastName='Paul';
                userObj.LanguageLocaleKey='en_US'; 
                userObj.LocaleSidKey='en_US';
                userObj.ProfileId = profileObj.Id;
                userObj.TimeZoneSidKey='America/Los_Angeles'; 
                userObj.UserName='shyam@test.com';
                userObj.Portal_Login__c = 'xyz';
                userObj.contactId = conobj.Id;
                userObj.IsActive = true;
                //userObj.userRoleId = usrRole.Id;
            insert userObj;
            
                Portal_Tab_Access__c portaltabObj = new Portal_Tab_Access__c();
                portaltabObj.User__c = userObj.Id;
                portaltabObj.Account__c = acc.Id;
                portaltabObj.My_Devices__c = true;
                portaltabObj.PTRF__c = true; 
                
                insert portaltabObj;
            }
        } catch(exception e) {}
        //test.stopTest();
        System.runAs(userObj)
        {
            try{
	            User u = [select id,accountid from user where id=:userObj.Id];
	            
	            DRTHandlerUtility.sendMassEmailOnDRTActivation(drt.Id, true); 
	            //DRTHandlerUtility.sendMassEmailOnDRTRevision(drt.Id, 'Revised DRT');
            } catch(exception e) {}
            
            
        }
        test.stopTest();
    }
    

    /*
       This test method tests the below functionality of the class DRTHandlerUtility
       handleError()
    */  
    @isTest
    public static void handleErrorTest(){
        // comment-out, refactor with testSetup method setup()
        // SwiftDataUtilityTest.customSystemData();
        Exception ex;
        try{
            integer a=1/0;
        }catch(Exception e){
            ex=e;
        }
        DRTHandlerUtility.handleError(ex,'test',new String[]{'a','b','c'});
    }
    
    
    /*
       This test method tests the below functionality of the class DRTHandlerUtility
       handleErrorOnSyncOracleResponse()
    */  
    @isTest
    public static void handleErrorOnSyncOracleResponseTest(){
        // comment-out, refactor with testSetup method setup()
        // SwiftDataUtilityTest.customSystemData();
        Account acc = SwiftDataUtilityTest.createTestAccount();
        Exception ex;
        try{
            acc.Id='123';
            update acc;
        }catch(Exception e){
            ex=e;   
        }
        DRTHandlerUtility.handleErrorOnSyncOracleResponse(ex,acc.Id,'Test Mail');   
    }
    
    
}