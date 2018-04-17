/*
    Author: Cognizant
    Description: Apex test class for BatchAccTeamProxyAddSchedular
    History: 
*/

@istest(SeeAllData=false)
public class BatchAccTeamProxyAddTest {
    
    public static Account accountObj;
    public static Id deviceId, opprProgId, objMSTId;
    
    /**
    This method initialize data using throughout this test class.
    The create data method are: 
    - SwiftDataUtilityTest.customSystemData();
    @author     SWIFT TEAM
    @since      7-April-2015
    */
    @testSetup static void setup() {
        /*Environment_Variable__c env = new Environment_Variable__c();
        env.name = 'SWIFT_MRS_GENERAL_JOB_BATCH_SIZE';
        env.value__c = '50';
        insert env; */
        accountInsert();
    }
    
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
    }
    //static{
        //accountInsert();
    //}
    
    /**
        @Method Name: batchPTRFShareTest
        @Return type: null
        @Parameters: null
        @Description: Test Method for batch class
    **/
    public static testMethod void batchPTRFShareTest(){
        
        accountObj = new Account();
        
        
        accountObj = [SELECT Id FROM Account WHERE Name='Test Account 009'];
        
        
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
        
            Account_Team_Proxy__c atp = new Account_Team_Proxy__c(User__c = userSU.id,Account__c=accountObj.id,Account_Access__c='Read/Write',
            Opportunity_Access__c='Read/Write',Team_Role__c='Field Application Engineer',Sequence_No__c='1',Account_Role_ID__c='test1239');       
                    
            insert atp;
            
            insertSwiftPublicGroupNotification();
            
            Test.startTest();  
            
            
            Opportunity oppr = SwiftDataUtilityTest.createOpportunityDRT(accountObj.Id);
            Opportunity_Program__c opprProg = SwiftDataUtilityTest.createOpportunityProgramDRT(accountObj.Id,oppr.Id);
            Process_Technology__c pt = SwiftDataUtilityTest.createProcessTechnologyForDRT();
            
            Device__c testDevice = SwiftDataUtilityTest.createDeviceWithPT(accountObj.Id,oppr.Id,opprProg.Id,pt.Id);
            
            Opportunity_Program_Team_Member__c oppTeamMem = new Opportunity_Program_Team_Member__c();
            oppTeamMem.Opportunity_Program__c = opprProg.Id;
            oppTeamMem.User__c = userSU.Id;
            oppTeamMem.Team_Role__c= 'Pricing';
            oppTeamMem.Opportunity_Program_Access__c = 'Read Only';
            oppTeamMem.Device_Access__c = 'Read Only';
            insert oppTeamMem;
            
            List<PTRF__c> ptrfList = new List<PTRF__c>();
            PTRF__c PTRFobj = new PTRF__c();
            PTRFobj.Name = 'PTRF 2';
            PTRFobj.Order_Type__c = 'Test Order Type';
            PTRFobj.Recticle_Type__c = 'Single Layer Reticle (SLR)';
            PTRFobj.MaskSetTitle__c = objMSTId ;//objMST.Id;
            PTRFobj.tech_Geo_Value__c = '0.019UM';
            PTRFobj.Device__c = deviceId;//testDevice.Id;
            ptrfList.add(PTRFobj);
            
            PTRF__c PTRFobj1 = new PTRF__c();
            PTRFobj1.Name = 'PTRF 1';
            PTRFobj1.Order_Type__c = 'Test Order Type';
            PTRFobj1.Recticle_Type__c = 'Single Layer Reticle (SLR)';
            PTRFobj1.MaskSetTitle__c = objMSTId ;//objMST.Id;
            PTRFobj1.tech_Geo_Value__c = '0.019UM';
            PTRFobj1.Customer__c = accountObj.Id;
            ptrfList.add(PTRFobj1);
            
            insert ptrfList;
            System.assertEquals('PTRF 1',PTRFobj1.Name);
            //List<String> ptrfStatus = new List<String>{'Active','Pending Submit','Open','Copy DB','Validation','MDP Approval','GlobalShuttle Updates','Perform DRC DRW','Perform Tapeout Options','Jobview','Mask Making','GDS Errors','Validate PTRF vs Info File','Generate Info File','IP Merge','DB Error','Bump'};     
            //String query = 'SELECT Id,Device__c,Customer__c FROM PTRF__c WHERE Status__c IN :ptrfStatus';
            
            SchedulableContext SC= null;
            BatchAccTeamProxyAdd batchObj = new BatchAccTeamProxyAdd();
            ID batchprocessid = Database.executeBatch(batchObj);
            batchObj.start(null);            
            batchObj.execute(null,ptrfList);
            batchObj.finish(null);         
            BatchSchedulerForAccountTeamProxy reviewer = new BatchSchedulerForAccountTeamProxy();
            reviewer.execute(SC);
            
            Test.stopTest();
        }
    }
    
    /**
        @Method Name: insertSwiftPublicGroupNotification
        @Return type: null
        @Parameters: null
        @Description: Insert custom settings value
    **/
    public static void insertSwiftPublicGroupNotification() {
        List<Swift_Public_Group_Notification__c> swiftNotifyList=new List<Swift_Public_Group_Notification__c>();
        Swift_Public_Group_Notification__c swiftObj;
        swiftObj = new Swift_Public_Group_Notification__c(Name='LastTimeStampAdd',Last_Notified__c=System.now().addHours(-2));
        swiftNotifyList.add(swiftObj);
        swiftObj = new Swift_Public_Group_Notification__c(Name='CustomerContactAdd',Last_Notified__c=System.now().addHours(-2));
        swiftNotifyList.add(swiftObj);
        insert swiftNotifyList;
    }
    
}