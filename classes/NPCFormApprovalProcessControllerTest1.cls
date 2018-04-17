/*
    Author: Zymark Ambat
    Description: This serves as the test class for NPCFormApprovalProcessController.
    History: 
        ZAmbat      02142014    - Code creation.
        ZAmbat      04282014    - Updated code to SeeAllData=false as fix for SFDC test limitations.
        Vijay       16012015    - Updated the Device Stage 'Solutioning' to 'Design In' as Device will be created in 
                                  'Design In' directly and added mandatory fields.
        DBiswal     04132015    - Updated code for refactoring of test class.
        Vijay       05012015    - added the test methods for Internal Device and updated existing test methods.
*/
@isTest(SeeAllData=false)
public class NPCFormApprovalProcessControllerTest1 {
    
     @testSetup static void setupInternalDeviceData(){
        DataUtilTest.loadEnvironmentVariables();
        List<RecordType> recordTypeList = [Select Id from RecordType where sObjectType ='Account' and developerName = 'GLOBALFOUNDRIES_Internal'];

        Account account = InternalDeviceTestUtil.createAccount('Test Account1', 'Unqualified', 'TestAccount1', 'Site', 'Direct', 'transactional', 'Fabless - Emerging',
                                             'Mature (> 0.11um)', 'APJ', 'APJ-FE-CHINA', 'APJ-China', 'APJ-China', true, '50 water', 'Bijing', 'China',  '50', 'GF Investment LLC OU', 
                                             100);
                                        
        if(!recordTypeList.isEmpty()){                      
            account.RecordTypeId = recordTypeList[0].Id;
        }
        //insert account;
        System.debug('account====='+account);
        List<RecordType> deviceRecTypeList = [Select Id from RecordType where sObjectType ='Device__c' and developerName = 'Internal_Device'];
        Device__c device = InternalDeviceTestUtil.createDevice('TestInternalDevice', 'Fab 2', 'Design In', 'Active', '100', System.today(), 
                                                                '1234567890', 'Single Product',  account.Id, '0.028UM', 'Super Low Power');
        if(!deviceRecTypeList.isEmpty()){                       
            device.RecordTypeId = deviceRecTypeList[0].Id;
        }
        Device.Device_Mask_Set_Title__c ='VMSTV';
        Device.Enabled_via_previous_MPW_1__c ='No';
        Device.Reticle_Type__c ='Multi Layer Reticle (MLR)';
        insert device;
    }
    
          
    static New_Part_Creation_Form__c createNPCForm1(Id accountId, Id deviceId) {
        New_Part_Creation_Form__c npc = new New_Part_Creation_Form__c();
        npc.Account__c = accountId;
        npc.BASE_Device__c = deviceId;
        npc.Originating_Device__c = deviceId;
        npc.New_Part_ID__c = 'NPCTEST5';
        npc.CRM_DID__c = 'CDID12345';
        npc.Fab__c = 'FAB 2';
        npc.Tapeout_Required__c = 'No';
        
        insert npc;
        
        return npc;
    }
    
    static New_Part_Creation_Form__c createNPCForm2(Id accountId, Id deviceId) {
        New_Part_Creation_Form__c npc = new New_Part_Creation_Form__c();
        npc.Account__c = accountId;
        npc.BASE_Device__c = deviceId;
        npc.Originating_Device__c = deviceId;
        npc.New_Part_ID__c = 'NPCTEST6';
        npc.CRM_DID__c = 'CDID12345';
        npc.Fab__c = 'FAB 2';
        npc.Tapeout_Required__c = 'No';
        npc.Reason_for_New_Part__c = 'New Probe Card Flow' ;
        npc.NPC_Form_Status__c = 'Pending Submission';
        
        insert npc;
        
        return npc;
    }
    
      static New_Part_Creation_Form__c createNPCForm3(Id accountId, Id deviceId) {
        New_Part_Creation_Form__c npc = new New_Part_Creation_Form__c();
        npc.Account__c = accountId;
        npc.BASE_Device__c = deviceId;
        npc.Originating_Device__c = deviceId;
        npc.New_Part_ID__c = 'NPCTEST7';
        npc.CRM_DID__c = 'CDID12345';
        npc.Fab__c = 'FAB 3';
        npc.Tapeout_Required__c = 'No';
        npc.NPC_Form_Status__c = 'Pending Submission';
        
        insert npc;
        
        return npc;
    }
    
    static Id createNPCMasks(Id npcId) {
        Mask__c m = new Mask__c();
        m.New_Part_Creation_Form__c = npcId;
        m.Layer__c = 'TestLayer';
        m.Modified_Mask__c = 'TestLayerMask';
        m.Original_Mask__c = 'TestLayerMask';
        
        insert m;
        
        return m.Id;
    }
    
    //test method for Internal Device
    static testMethod void testSubmitNPCForm(){
        Account account = null;
        Device__c device = null;
        New_Part_Creation_Form__c npcForm = null;
        System.runAs(new User(Id = UserInfo.getUserId())){
            Test.startTest();
            account = [Select Id From Account Where Name = 'Test Account1' Limit 1];
            device = [Select Id From Device__c Where Name='TestInternalDevice' Limit 1];
            npcForm = createNPCForm1(account.Id, device.Id);
            PageReference pageRef = Page.NPCFormVF;
            Test.setCurrentPageReference(pageRef);
            ApexPages.currentPage().getParameters().put('id', npcForm.Id);
            NPCFormApprovalProcessController n = new NPCFormApprovalProcessController();
            n.submitNPCForm();
       }
       Test.stopTest();
    }
    
    
    static testMethod void testNPCFormApprovalProcessController_GFFAEFTS1() {
        Account account = null;
        Opportunity_Program__c oppProgram = null;
        User gfFAEFTS = null;
        Test.startTest();
        System.runAs(new User(Id = UserInfo.getUserId())){
        account = [Select Id From Account Where Name = 'Test Account1'];
            gfFAEFTS= [
                SELECT    Id
                FROM      User
                WHERE     Profile.Name = 'GF FAE/FTS'
                          AND IsActive = true
                LIMIT 1
            ];
            AccountShare as1 = new AccountShare();
            as1.AccountAccessLevel = 'Edit';
            //as1.RowCause = 'Manual';
            as1.AccountId = account.Id;
            as1.UserOrGroupId = gfFAEFTS.Id;
            as1.OpportunityAccessLevel = 'Edit';
            as1.CaseAccessLevel = 'Edit';
            insert as1;
            
        }
        system.runAs(gfFAEFTS) {
            List<RecordType> deviceRecTypeList = [Select Id from RecordType where sObjectType ='Device__c' and developerName = 'Internal_Device'];
            Device__c device = InternalDeviceTestUtil.createDevice('TestInternalDevice1', 'Fab 2', 'Design In', 'Active', '100', System.today(), 
                                                                '11111111111', 'Single Product',  account.Id, '0.028UM', 'Super Low Power');
            if(!deviceRecTypeList.isEmpty()){                       
                device.RecordTypeId = deviceRecTypeList[0].Id;
            } 
            Device.Device_Mask_Set_Title__c ='VMSTML';
            Device.Enabled_via_previous_MPW_1__c ='No';
            Device.Reticle_Type__c ='Multi Layer Reticle (MLR)';
            insert device;
            New_Part_Creation_Form__c testNPC = createNPCForm2(account.Id, device.Id);
            createNPCMasks(testNPC.Id);
            PageReference pageRef = Page.NPCFormVF;
            Test.setCurrentPageReference(pageRef);
            ApexPages.currentPage().getParameters().put('id', testNPC.Id);
            NPCFormApprovalProcessController n = new NPCFormApprovalProcessController();
            
            n.submitNPCForm();
        }
        test.stopTest();
    }
     
     static testMethod void testNPCFormApprovalProcessController_GFFAEFTS2() {
        Account account = null;
        Opportunity_Program__c oppProgram = null;
        User gfFAEFTS = null;
        Test.startTest();
        System.runAs(new User(Id = UserInfo.getUserId())){
            account = [Select Id From Account Where Name = 'Test Account1'];
            gfFAEFTS= [
                SELECT    Id
                FROM      User
                WHERE     Profile.Name = 'GF FAE/FTS'
                          AND IsActive = true
                LIMIT 1
            ];
             AccountShare as1 = new AccountShare();
            as1.AccountAccessLevel = 'Edit';
            //as1.RowCause = 'Manual';
            as1.AccountId = account.Id;
            as1.UserOrGroupId = gfFAEFTS.Id;
            as1.OpportunityAccessLevel = 'Edit';
            as1.CaseAccessLevel = 'Edit';
            insert as1;
       }
        system.runAs(gfFAEFTS) {
            List<RecordType> deviceRecTypeList = [Select Id from RecordType where sObjectType ='Device__c' and developerName = 'Internal_Device'];
            Device__c device = InternalDeviceTestUtil.createDevice('TestInternalDevice2', 'Fab 2', 'Design In', 'Active', '100', System.today(), 
                                                                '2222222222', 'Single Product',  account.Id, '0.028UM', 'Super Low Power');
            if(!deviceRecTypeList.isEmpty()){                       
                device.RecordTypeId = deviceRecTypeList[0].Id;
            }
            //Device.Device_Mask_Set_Title__c ='VMSTV';
            Device.Enabled_via_previous_MPW_1__c ='No';
            Device.Reticle_Type__c ='Multi Layer Reticle (MLR)';
            insert device;
            New_Part_Creation_Form__c testNPC = createNPCForm3(account.Id, device.Id);
            createNPCMasks(testNPC.Id);
            PageReference pageRef = Page.NPCFormVF;
            Test.setCurrentPageReference(pageRef);
            ApexPages.currentPage().getParameters().put('id', testNPC.Id);
            NPCFormApprovalProcessController n = new NPCFormApprovalProcessController();
            
            n.submitNPCForm();
        }
        test.stopTest();
    }
    
     static testMethod void testCancel(){
     test.startTest();
            PageReference pageRef = Page.NPCFormVF;
            Test.setCurrentPageReference(pageRef);
            NPCFormApprovalProcessController n = new NPCFormApprovalProcessController();
            n.cancel();
        test.stopTest();
    }
    
}