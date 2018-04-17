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
 /*
Author: Cognizant Technology Solutions
Company: 
Description: Test class used for Addding PTRF sharing for Customer Contact
History:
    Cognizant     23122014     - Initial Version
*/
@isTest(SeeAllData=false)
private class BatchContactAddTest {

 public static Account accountObj;
 public static List<Contact> con=new List<Contact>();
    /**
		@Method Name: accountInsert
		@Return type: null
		@Parameters: null
		@Description: Insert account for test class
	**/
    public static  void accountInsert(){
        SwiftDataUtilityTest.customSystemData();
        accountObj = SwiftDataUtilityTest.createTestAccountForDRT();
        
        System.assertNotEquals(accountObj,null);
        accountObj.stage__c = 'Qualified';
        update accountObj;
        con=SwiftDataUtilityTest.createTestContact(accountObj,1);  
        
        Profile profileObj = [Select Name,Id from Profile where Name = 'Customer Portal Admin'];
		//UserRole usrRole = [Select id,PortalType, PortalAccountId From UserRole where PortalType ='CustomerPortal' limit 1];
		User userObj = new User();
		
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
            userObj.contactId = con[0].Id;
            userObj.IsActive = true;
            //userObj.userRoleId = usrRole.Id;
                        
            insert userObj;
        }
    }
    static{
        accountInsert();
    }
    
    public static void insertSwiftPublicGroupNotification() {
        Swift_Public_Group_Notification__c swiftObj = new Swift_Public_Group_Notification__c(Name='CustomerContactAdd',Last_Notified__c=System.now().addHours(-2));
        insert swiftObj;
    }
    
    public static void updateSwiftPublicGroupNotification() {
        Swift_Public_Group_Notification__c swiftObj = new Swift_Public_Group_Notification__c(Name='CustomerContactAdd');
        insert swiftObj;
    }
    
    /**
		@Method Name: batchPTRFShareTest1
		@Return type: null
		@Parameters: null
		@Description: Test Method for batch class
	**/
    public static testMethod void batchPTRFShareTest1(){
    	Profile sysAdminProfile = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
        User sysAdminUser = [SELECT Id,Name FROM User WHERE Profile.Name = 'System Administrator' AND isActive = true].get(0);
        System.runAs(sysAdminUser){
            Profile stdUserProfile = [SELECT Id FROM Profile WHERE Name='Standard User'];
            UserRole usrRole=[SELECT Id FROM UserRole WHERE Name = 'GLOBALFOUNDRIES Corporate'];
            
            User userSU = new User(alias = 'testMRS2', email='testMRS2@test.com',
            emailencodingkey='UTF-8', lastname='testMRS2Last', firstname='testMRS2First', languagelocalekey='en_US',
            localesidkey='en_US', profileid = stdUserProfile.Id, UserRoleId = usrRole.Id,
            timezonesidkey='America/Los_Angeles', username='testMRS2@test.com',communitynickname='testMRS2');
            
            insert userSU;
        	
        	insertSwiftPublicGroupNotification();
            
            Test.startTest();
            Mask_Set_Title__c objMST = MRSDataUtilityTest.createMST();
            
            List<PTRF__c> ptrfList = new List<PTRF__c>();
            PTRF__c PTRFobj1 = new PTRF__c();
            PTRFobj1.Name = 'PTRF 1';
            PTRFobj1.Order_Type__c = 'Test Order Type';
            PTRFobj1.Recticle_Type__c = 'Single Layer Reticle (SLR)';
            PTRFobj1.MaskSetTitle__c = objMST.Id;
            PTRFobj1.tech_Geo_Value__c = '0.019UM';
            PTRFobj1.Customer__c = accountObj.Id;
            
            ptrfList.add(PTRFobj1);
            
            insert ptrfList;
            System.assertEquals('PTRF 1',PTRFobj1.Name);
         	
         	List<String> ptrfStatus = new List<String>{'Active','Pending Submit','Open','Copy DB','Validation','MDP Approval','GlobalShuttle Updates','Perform DRC DRW','Perform Tapeout Options','Jobview','Mask Making','GDS Errors','Validate PTRF vs Info File','Generate Info File','IP Merge','DB Error','Bump'};     
            String query = 'SELECT Id,Device__c,Customer__c FROM PTRF__c WHERE Status__c IN :ptrfStatus';
            
            SchedulableContext SC= null;
            BatchContactAdd batchObj = new BatchContactAdd();
            ID batchprocessid = Database.executeBatch(batchObj);
            batchObj.start(null);            
            batchObj.execute(null,ptrfList);
            batchObj.finish(null);         
            //BatchSchedulerForAccountTeamProxy reviewer = new BatchSchedulerForAccountTeamProxy();
            //reviewer.execute(SC);
            
            Test.stopTest();
            
        }
    }
    
        /**
		@Method Name: batchPTRFShareTest2
		@Return type: null
		@Parameters: null
		@Description: Test Method for batch class
	**/
    public static testMethod void batchPTRFShareTest2(){
    	Profile sysAdminProfile = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
        User sysAdminUser = [SELECT Id,Name FROM User WHERE Profile.Name = 'System Administrator' AND isActive = true].get(0);
        System.runAs(sysAdminUser){
            Profile stdUserProfile = [SELECT Id FROM Profile WHERE Name='Standard User'];
            UserRole usrRole=[SELECT Id FROM UserRole WHERE Name = 'GLOBALFOUNDRIES Corporate'];
            
            User userSU = new User(alias = 'testMRS2', email='testMRS2@test.com',
            emailencodingkey='UTF-8', lastname='testMRS2Last', firstname='testMRS2First', languagelocalekey='en_US',
            localesidkey='en_US', profileid = stdUserProfile.Id, UserRoleId = usrRole.Id,
            timezonesidkey='America/Los_Angeles', username='testMRS2@test.com',communitynickname='testMRS2');
            
            insert userSU;
        	
        	updateSwiftPublicGroupNotification();
            
            Test.startTest();
            Mask_Set_Title__c objMST = MRSDataUtilityTest.createMST();
            
            List<PTRF__c> ptrfList = new List<PTRF__c>();
            PTRF__c PTRFobj1 = new PTRF__c();
            PTRFobj1.Name = 'PTRF 1';
            PTRFobj1.Order_Type__c = 'Test Order Type';
            PTRFobj1.Recticle_Type__c = 'Single Layer Reticle (SLR)';
            PTRFobj1.MaskSetTitle__c = objMST.Id;
            PTRFobj1.tech_Geo_Value__c = '0.019UM';
            PTRFobj1.Customer__c = accountObj.Id;
            
            ptrfList.add(PTRFobj1);
            
            insert ptrfList;
            System.assertEquals('PTRF 1',PTRFobj1.Name);
         	
         	List<String> ptrfStatus = new List<String>{'Active','Pending Submit','Open','Copy DB','Validation','MDP Approval','GlobalShuttle Updates','Perform DRC DRW','Perform Tapeout Options','Jobview','Mask Making','GDS Errors','Validate PTRF vs Info File','Generate Info File','IP Merge','DB Error','Bump'};     
            String query = 'SELECT Id,Device__c,Customer__c FROM PTRF__c WHERE Status__c IN :ptrfStatus';
            
            SchedulableContext SC= null;
            BatchContactAdd batchObj = new BatchContactAdd();
            ID batchprocessid = Database.executeBatch(batchObj);
            batchObj.start(null);            
            batchObj.execute(null,ptrfList);
            batchObj.finish(null);         
            //BatchSchedulerForAccountTeamProxy reviewer = new BatchSchedulerForAccountTeamProxy();
            //reviewer.execute(SC);
            
            Test.stopTest();
            
        }
    }
    
}