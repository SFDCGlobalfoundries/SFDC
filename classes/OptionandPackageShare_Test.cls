/**
@Author <Cognizant>
@name <OptionandPackageShare_Test>
@CreateDate <21/12/2016>
@Description <Apex Test Class For OptionShareHelper>
@Version <>
@reference <>
*/
@isTest(SeeAllData=false)
public class OptionandPackageShare_Test {
    @testSetup static void testdata() {
        DataUtilTest.loadEnvironmentVariables();
    }
      
    static Id createUser1(){
        User usr1 = [select id from User where profile.Name='System Administrator' and IsActive=true limit 1];
        return usr1.Id;
    }
    
    static Id createUser2(){
        User usr2 = [select id from User where profile.Name ='GF System Admin' and IsActive=true limit 1];
        return usr2.Id;
    }
    
    static Id createAccount(){
        RecordType recType = [select id from RecordType where Name='Customer' AND SObjectType = 'Account' limit 1];
        Account acc = new Account(Name='Test Account',RecordTypeId=recType.id,Site_Department__c='IT',Sub_Type__c='Indirect',
                                Transaction_Type__c='Non-Transactional',Region__c='US',Bill_To_Address_1__c='Test Address',
                                Bill_To_City__c='Test City',Bill_To_Country__c='India',Corporate_Address_1__c='Test Address',
                                Corporate_City__c='Test City',Corporate_Country__c='India');
        //Account acc = new Account(Name='Test Account');
        
        insert acc;
        return acc.Id;
        
        /*Map<String,Object> fieldValueMap = new Map<String,Object>();       
        fieldValueMap.put('Name', 'Test Account');
        fieldValueMap.put('Stage__c', 'Unqualified');
        fieldValueMap.put('Short_Name__c', 'test725');
        fieldValueMap.put('Site_Department__c', 'cts.com');
        fieldValueMap.put('Account_Type__c', 'Customer');
        fieldValueMap.put('Organization_Unit__c', 'sg;us');
        fieldValueMap.put('Copy_Address__c', true);
        fieldValueMap.put('Corporate_Address_1__c', 'test');
        fieldValueMap.put('Corporate_City__c', 'sg');
        fieldValueMap.put('Corporate_Country__c', 'sg');        
        fieldValueMap.put('Financial_Territory__c', 'Greater China');
        fieldValueMap.put('Region__c', 'APJ');
        fieldValueMap.put('Sub_Type__c', 'Direct');
        fieldValueMap.put('Transaction_Type__c', 'Transactional');
        fieldValueMap.put('Account_Profile__c', 'Fabless - Emerging');
        fieldValueMap.put('Corporate_Postal_Zip_Code__c', '700007');
        fieldValueMap.put('Fab_9_10__c', 'No');
        fieldValueMap.put('recordtypeid', recType.id);       
        Account acc = AccountDataFactory.createAccount(fieldValueMap);
        return acc.Id;*/
    }
    
    static Id createOpp(Id acctId){
        Opportunity opp = new Opportunity(Name='Test Opportunity',AccountId=acctId,StageName='2. Assessment',Market_Segment__c='Automotive',
                                        Target_Process_Node__c='14XM',Process_Platform__c='GF Baseline',Opportunity_Sourcing_Type__c='First Source',Fab_Assignment_1__c = 'FAB 3',
                                        Process_Geometry__c = '0.50UM',Process_Family__c = 'Generic / Nominal',
                                        Fab_Split__c=100,CloseDate = System.today().addDays(10));
        
        insert opp;
        return opp.Id;
    }
    
    static Id createOppProg(Id acctId,Id oppId){
        Opportunity_Program__c opProg = new Opportunity_Program__c(Name='Test OppProg',Account__c=acctId,Opportunity__c=oppId);
        insert opProg;
        return opProg.Id;
    }
        
    static Id createDevice(Id oppProgId, Id acctId){
       
        
        /*Device__c dev = new Device__c();
        dev.Name = 'TESTDEVICEZAIH1234677';
        dev.Opportunity_Program__c = oppProgId;
        dev.Fab__c = 'Fab 3';
        dev.GSOP_Assignment_Tapeout_Plan__c = 'No';
        dev.Market_Segment__c = 'Mobility';
        dev.Semiconductor_Device__c = 'Analog Amplifier';
        dev.End_Customer__c = 'Test Customer';
        dev.Device_Sourcing__c = '1st Source';
        dev.Stage__c = 'Solutioning';
        dev.Status__c = 'Active';
        dev.Tapeout_Type__c = 'Customer MPW';
        dev.End_Application__c = 'Testchip';
        
        Insert dev;*/
        
        Map<String,Object> fieldValueMap1 = new Map<String,Object>();
        fieldValueMap1.put('Account__c', acctId);
        fieldValueMap1.put('Device_Sourcing__c','Sole Source');
        fieldValueMap1.put('Opportunity_Program__c',oppProgId);
        Device__c dev = new Device__c ();
        dev = DeviceDataFactory.createDevice(fieldValueMap1);
        return dev.Id; 
    }
    
    static Id createOption(Id devId){
       
        Customer_Requirement__c cr = new Customer_Requirement__c();
        cr.isTCA__c = 'No';
        cr.device__c = devId ;
        cr.Reliability_grade_required__c = 'Yes';
        cr.Reliability_Grade__c = 'Grade 1 (Premium)';
        cr.Node__c = '0.007UM';
        cr.Technology__c = '7LP';
        cr.Fab__c = 'FAB 1';
        cr.Total_Chip_Count__c =  '1';
        insert cr;
        return cr.Id; 
    }
    
    
    static Id createPack(Id opId){
       
       Package_Data__c pd = new Package_Data__c();
        pd.Is_Deliverable_Type__c = 'Yes'; 
        pd.Technical_Requirement__c = opId ;
        
        insert pd;
        return pd.Id; 
    }
    
    
    
    static Opportunity_Program_Team_Member__c createOppProgTmMem1(Id oppProgId, Id userId){
        Opportunity_Program_Team_Member__c oppProgTM = new Opportunity_Program_Team_Member__c(Core_Team_Member__c=false,
                                        Device_Access__c='Read/Write',Opportunity_Program_Access__c='Read/Write',
                                        Opportunity_Program__c=oppProgId,Team_Role__c='Primary Account Manager',
                                        User__c=userId,Flag_for_Delete__c=false);
        insert oppProgTM;
        return oppProgTM;
    }
    
    static Opportunity_Program__Share createOppProgramShare(Id oppProgId,Id userId){
        Opportunity_Program__Share oppProgShare1 = new Opportunity_Program__Share(AccessLevel='Read',
                                                    ParentId=oppProgId,RowCause='Opportunity_Program_Team__c',
                                                    UserOrGroupId=userId
                                                        );
        insert oppProgShare1;
        return oppProgShare1;
    }

    static Device__Share createDeviceShare(Id devId,Id userId){
        Device__Share devShare1 = new Device__Share(AccessLevel='Read',
                                                    ParentId=devId,RowCause='Opportunity_Program_Team__c',
                                                    UserOrGroupId=userId
                                                        );
        insert devShare1;
        return devShare1;
    }

    static Customer_Requirement__Share createOptionShare(Id opId,Id userId){
        Customer_Requirement__Share opShare1 = new Customer_Requirement__Share(AccessLevel='Read',
                                                    ParentId=opId,RowCause='Opportunity_Program_Team__c',
                                                    UserOrGroupId=userId
                                                        );
        insert opShare1;
        return opShare1;
    }
    
    static Opportunity_Program_Team_Member__c createOppProgTmMem2(Id oppProgId, Id userId){
        Opportunity_Program_Team_Member__c oppProgTM = new Opportunity_Program_Team_Member__c(Core_Team_Member__c=false,
                                        Device_Access__c='Read/Write',Opportunity_Program_Access__c='Read/Write',
                                        Opportunity_Program__c=oppProgId,Team_Role__c='Primary Account Manager',
                                        User__c=userId,Flag_for_Delete__c=false);
        insert oppProgTM;
        return oppProgTM;
    }
    
    
    
    static Opportunity_Program__Share createOppProgramShare1(Id oppProgId,Id userId){
        Opportunity_Program__Share oppProgShare1 = new Opportunity_Program__Share(AccessLevel='Edit',
                                                    ParentId=oppProgId,RowCause='Opportunity_Program_Team__c',
                                                    UserOrGroupId=userId
                                                        );
        insert oppProgShare1;
        return oppProgShare1;
    }

    static Device__Share createDeviceShare1(Id devId,Id userId){
        Device__Share devShare1 = new Device__Share(AccessLevel='Edit',
                                                    ParentId=devId,RowCause='Opportunity_Program_Team__c',
                                                    UserOrGroupId=userId
                                                        );
        insert devShare1;
        return devShare1;
    }
       
    static Customer_Requirement__Share createOptionShare1(Id opId,Id userId){
        Customer_Requirement__Share opShare1 = new Customer_Requirement__Share(AccessLevel='Edit',
                                                    ParentId=opId,RowCause='Opportunity_Program_Team__c',
                                                    UserOrGroupId=userId
                                                        );
        insert opShare1;
        return opShare1;
    }      
    
    static testMethod void oppProgTmMemCreateTest() {
        
        //Data preparation
        String userId1 = OptionandPackageShare_Test.createUser1();
        String userId2 = OptionandPackageShare_Test.createUser2();
        String acctId = OptionandPackageShare_Test.createAccount();
        String oppId = OptionandPackageShare_Test.createOpp(acctId);
        String oppProgId = OptionandPackageShare_Test.createOppProg(acctId, oppId);
        //String devId = OptionandPackageShare_Test.createDevice(oppProgId);
        
        test.startTest();
        
        //Create new oppty program team members
        Opportunity_Program_Team_Member__c oppProgTM = OptionandPackageShare_Test.createOppProgTmMem1(oppProgId, userId1);
        Opportunity_Program_Team_Member__c oppProgTM2 = OptionandPackageShare_Test.createOppProgTmMem1(oppProgId, userId2);
        system.AssertEquals('Primary Account Manager', oppProgTM.Team_Role__c);
        
        //Create new device
        User thisUser= DeviceChecklistTestDataUtils.createUserWithDCAdmin('System Administrator');
        String devId;
        System.runAs(thisUser)
        {
            IntegrationUsers__c skipUser = new IntegrationUsers__c(SetupOwnerId = thisUser.Id, Is_Integration_User__c= true, Skip_Trigger__c = true, Skip_Validation_Rule__c = true);
            insert skipUser;
            devId = OptionandPackageShare_Test.createDevice(oppProgId, acctId);
        }
        
        //Create new option
        
        String opId = OptionandPackageShare_Test.createOption(devId);
        
        // Create new Package Data
        
        String pdId = OptionandPackageShare_Test.createPack(opId);
        
        //add couple of opportunity program share record
        Opportunity_Program__Share oppProgShare1 = OptionandPackageShare_Test.createOppProgramShare(oppProgId,userId1);
        Opportunity_Program__Share oppProgShare2 = OptionandPackageShare_Test.createOppProgramShare(oppProgId,userId2);
        
        //adding couple of device share record
        Device__Share devShare1 = OptionandPackageShare_Test.createDeviceShare(devId,userId1);
        Device__Share devShare2 = OptionandPackageShare_Test.createDeviceShare(devId,userId2);
        
        //adding couple of option share record
        Customer_Requirement__Share opShare1 = OptionandPackageShare_Test.createOptionShare(opId,userId1);
        Customer_Requirement__Share opShare2 = OptionandPackageShare_Test.createOptionShare(opId,userId2);
        
        List <Id> oppIds = new List<Id>();
        oppIds.add(opId);
        OptionShareHelper.createOptionShare(oppProgTM,oppIds);
        
        List <Id> pdIds = new List<Id>();
        pdIds.add(pdId);
        
        Set <Id> oppProgTMIds = new Set<Id>();
        oppProgTMIds.add(oppProgId);
        Map<Id, Opportunity_Program_Team_Member__c> mapOppProgTM = new Map<Id, Opportunity_Program_Team_Member__c>();
        mapOppProgTM.put(oppProgTM.Id,oppProgTM);
        Set <Id> activeUserIDs = new Set<Id>();
        activeUserIDs.add(userId1);
        OptionShareHelper.opshareRecords(oppProgTMIds);
        OptionShareHelper.insertOptionShare(oppProgTMIds,mapOppProgTM,activeUserIDs);
        test.stopTest();
        
    }
    
    static testMethod void oppProgTmMemUpdateTest() {
        
        //Data preparation
        String userId1 = OptionandPackageShare_Test.createUser1();
        String userId2 = OptionandPackageShare_Test.createUser2();
        String acctId = OptionandPackageShare_Test.createAccount();
        String oppId = OptionandPackageShare_Test.createOpp(acctId);
        String oppProgId = OptionandPackageShare_Test.createOppProg(acctId, oppId);
        //String devId = OptionandPackageShare_Test.createDevice(oppProgId);
        
        test.startTest();
        
        //Create new oppty program team members
        Opportunity_Program_Team_Member__c oppProgTM = OptionandPackageShare_Test.createOppProgTmMem1(oppProgId, userId1);
        Opportunity_Program_Team_Member__c oppProgTM2 = OptionandPackageShare_Test.createOppProgTmMem1(oppProgId, userId2);
        system.AssertEquals('Primary Account Manager', oppProgTM.Team_Role__c);
        
        //Create new device
        User thisUser= DeviceChecklistTestDataUtils.createUserWithDCAdmin('System Administrator');
        String devId;
        System.runAs(thisUser)
        {
            IntegrationUsers__c skipUser = new IntegrationUsers__c(SetupOwnerId = thisUser.Id, Is_Integration_User__c= true, Skip_Trigger__c = true, Skip_Validation_Rule__c = true);
            insert skipUser;
            devId = OptionandPackageShare_Test.createDevice(oppProgId,acctId);
        }
        
        //Create new Option
        
        String opId = OptionandPackageShare_Test.createOption(devId);
        
        // Create new Package Data
        
        String pdId = OptionandPackageShare_Test.createPack(opId);
        
        //add couple of opportunity program share record
        Opportunity_Program__Share oppProgShare1 = OptionandPackageShare_Test.createOppProgramShare(oppProgId,userId1);
        Opportunity_Program__Share oppProgShare2 = OptionandPackageShare_Test.createOppProgramShare(oppProgId,userId2);
        
        //adding couple of device share record
        Device__Share devShare1 = OptionandPackageShare_Test.createDeviceShare(devId,userId1);
        Device__Share devShare2 = OptionandPackageShare_Test.createDeviceShare(devId,userId2);
        
        //adding couple of option share record
        Customer_Requirement__Share opShare1 = OptionandPackageShare_Test.createOptionShare(opId,userId1);
        Customer_Requirement__Share opShare2 = OptionandPackageShare_Test.createOptionShare(opId,userId2);
        
        //updating the opportunity program share records
        List<Opportunity_Program_Team_Member__c> oppProgTeamMemList 
                           = [SELECT Core_Team_Member__c,Device_Access__c,Id,Opportunity_Program_Access__c,
                                Opportunity_Program__c,User__c FROM Opportunity_Program_Team_Member__c
                                where Opportunity_Program__c=:oppProgId and Opportunity_Program_Access__c = 'Read/Write'
                                and Device_Access__c = 'Read/Write' limit 1];
        
        oppProgTeamMemList[0].Opportunity_Program_Access__c = 'Read Only';
        oppProgTeamMemList[0].Device_Access__c = 'Read Only';
        
        update oppProgTeamMemList[0];
               
        test.stopTest();
        
    }
    
    static testMethod void oppProgTmMemDeleteTest() {
        
        //Data preparation
        String userId1 = OptionandPackageShare_Test.createUser1();
        String userId2 = OptionandPackageShare_Test.createUser2();
        String acctId = OptionandPackageShare_Test.createAccount();
        String oppId = OptionandPackageShare_Test.createOpp(acctId);
        String oppProgId = OptionandPackageShare_Test.createOppProg(acctId, oppId);
        
        test.startTest();
        
        //Create new oppty program team members
        Opportunity_Program_Team_Member__c oppProgTM = OptionandPackageShare_Test.createOppProgTmMem1(oppProgId, userId1);
        Opportunity_Program_Team_Member__c oppProgTM2 = OptionandPackageShare_Test.createOppProgTmMem1(oppProgId, userId2);
        system.AssertEquals('Primary Account Manager', oppProgTM.Team_Role__c);
        
        //Create new device
        User thisUser= DeviceChecklistTestDataUtils.createUserWithDCAdmin('System Administrator');
        String devId;
        System.runAs(thisUser)
        {
            IntegrationUsers__c skipUser = new IntegrationUsers__c(SetupOwnerId = thisUser.Id, Is_Integration_User__c= true, Skip_Trigger__c = true, Skip_Validation_Rule__c = true);
            insert skipUser;
            devId = OptionandPackageShare_Test.createDevice(oppProgId,acctId);
        }
        
        //Create new option
        
        String opId = OptionandPackageShare_Test.createOption(devId);
        
        // Create new Package Data
        
        String pdId = OptionandPackageShare_Test.createPack(opId);
         
        
        //add couple of opportunity program share record
        Opportunity_Program__Share oppProgShare1 = OptionandPackageShare_Test.createOppProgramShare(oppProgId,userId1);
        Opportunity_Program__Share oppProgShare2 = OptionandPackageShare_Test.createOppProgramShare(oppProgId,userId2);
        
        //adding couple of device share record
        Device__Share devShare1 = OptionandPackageShare_Test.createDeviceShare(devId,userId1);
        Device__Share devShare2 = OptionandPackageShare_Test.createDeviceShare(devId,userId2);
        
        //adding couple of option share record
        Customer_Requirement__Share opShare1 = OptionandPackageShare_Test.createOptionShare(opId,userId1);
        Customer_Requirement__Share opShare2 = OptionandPackageShare_Test.createOptionShare(opId,userId2);
        
        //updating the opportunity program share records
        List<Opportunity_Program_Team_Member__c> oppProgTeamMemList 
                           = [SELECT Core_Team_Member__c,Device_Access__c,Id,Opportunity_Program_Access__c,
                                Opportunity_Program__c,User__c,Flag_for_Delete__c FROM Opportunity_Program_Team_Member__c
                                where Opportunity_Program__c=:oppProgId and Opportunity_Program_Access__c = 'Read/Write'
                                and Device_Access__c = 'Read/Write' limit 1];
        
        oppProgTeamMemList[0].Flag_for_Delete__c = true;      
        update oppProgTeamMemList[0];
        
        //Query to find oppty prog record for deletion
        List<Opportunity_Program_Team_Member__c> oppProgTeamMemListForDel 
                           = [SELECT Core_Team_Member__c,Device_Access__c,Id,Opportunity_Program_Access__c,
                                Opportunity_Program__c,User__c,Flag_for_Delete__c FROM Opportunity_Program_Team_Member__c
                                where Opportunity_Program__c=:oppProgId and Flag_for_Delete__c=true limit 1];
        
        delete oppProgTeamMemListForDel[0];
               
        test.stopTest();
        
    }
 
}