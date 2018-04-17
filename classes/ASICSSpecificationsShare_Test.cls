/**
@Author <Cognizant>
@name <ASICSSpecificationsShare_Test>
@CreateDate <06/01/2016>
@Description <Apex Test Class For ASICSSpecificationsTriggerHelper>
@Version <>
@reference <>
*/
@isTest(SeeAllData=true)
public class ASICSSpecificationsShare_Test {
      
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
        
        insert acc;
        return acc.Id;
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
        
    static Id createDevice(Id oppProgId){
       
        
        Device__c dev = new Device__c();
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
        
        Insert dev;
        return dev.Id; 
    }
    
    static Id createAsic(Id devId){
       
        ASICS_Specification__c asic = new ASICS_Specification__c();
        asic.name = 'Test Asic';
        asic.Device__c = devId ;
        insert asic;
        return asic.Id; 
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

    static ASICS_Specification__Share createasicShare(Id asicId,Id userId){
        ASICS_Specification__Share asicShare1 = new ASICS_Specification__Share(AccessLevel='Read',
                                                    ParentId=asicId,RowCause='Opportunity_Program_Team__c',
                                                    UserOrGroupId=userId
                                                        );
        insert asicShare1;
        return asicShare1;
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
       
    static ASICS_Specification__Share createasicShare1(Id asicId,Id userId){
        ASICS_Specification__Share asicShare1 = new ASICS_Specification__Share(AccessLevel='Edit',
                                                    ParentId=asicId,RowCause='Opportunity_Program_Team__c',
                                                    UserOrGroupId=userId
                                                        );
        insert asicShare1;
        return asicShare1;
    }      
    
   
    static testMethod void oppProgTmMemCreateTest() {
        
        //Data preparation
        String userId1 = ASICSSpecificationsShare_Test.createUser1();
        String userId2 = ASICSSpecificationsShare_Test.createUser2();
        String acctId = ASICSSpecificationsShare_Test.createAccount();
        String oppId = ASICSSpecificationsShare_Test.createOpp(acctId);
        String oppProgId = ASICSSpecificationsShare_Test.createOppProg(acctId, oppId);
        //String devId = ASICSSpecificationsShare_Test.createDevice(oppProgId);
        
        test.startTest();
        
        //Create new oppty program team members
        Opportunity_Program_Team_Member__c oppProgTM = ASICSSpecificationsShare_Test.createOppProgTmMem1(oppProgId, userId1);
        Opportunity_Program_Team_Member__c oppProgTM2 = ASICSSpecificationsShare_Test.createOppProgTmMem1(oppProgId, userId2);
        
        //Create new device
        
        String devId = ASICSSpecificationsShare_Test.createDevice(oppProgId);
        
        //Create new Asic
        
        String asicId= ASICSSpecificationsShare_Test.createAsic(devId);
        
        
        //add couple of opportunity program share record
        Opportunity_Program__Share oppProgShare1 = ASICSSpecificationsShare_Test.createOppProgramShare(oppProgId,userId1);
        Opportunity_Program__Share oppProgShare2 = ASICSSpecificationsShare_Test.createOppProgramShare(oppProgId,userId2);
        
        //adding couple of device share record
        Device__Share devShare1 = ASICSSpecificationsShare_Test.createDeviceShare(devId,userId1);
        Device__Share devShare2 = ASICSSpecificationsShare_Test.createDeviceShare(devId,userId2);
        
        //adding couple of Asic share record
        ASICS_Specification__Share asicShare1 = ASICSSpecificationsShare_Test.createasicShare(asicId,userId1);
        ASICS_Specification__Share asicShare2 = ASICSSpecificationsShare_Test.createasicShare(asicId,userId2);
        
        
        
        List <Id> oppIds = new List<Id>();
        oppIds.add(asicId);
        ASICSSpecificationsTriggerHelper.createasicShare(oppProgTM,oppIds);
        
        Set <Id> oppProgTMIds = new Set<Id>();
        oppProgTMIds.add(oppProgId);
        Map<Id, Opportunity_Program_Team_Member__c> mapOppProgTM = new Map<Id, Opportunity_Program_Team_Member__c>();
        mapOppProgTM.put(oppProgTM.Id,oppProgTM);
        Set <Id> activeUserIDs = new Set<Id>();
        activeUserIDs.add(userId1);
        ASICSSpecificationsTriggerHelper.asicshareRecords(oppProgTMIds);
        ASICSSpecificationsTriggerHelper.insertasicShare(oppProgTMIds,mapOppProgTM,activeUserIDs);      
        test.stopTest();
        
    }
    
    static testMethod void oppProgTmMemUpdateTest() {
        
        //Data preparation
        String userId1 = ASICSSpecificationsShare_Test.createUser1();
        String userId2 = ASICSSpecificationsShare_Test.createUser2();
        String acctId = ASICSSpecificationsShare_Test.createAccount();
        String oppId = ASICSSpecificationsShare_Test.createOpp(acctId);
        String oppProgId = ASICSSpecificationsShare_Test.createOppProg(acctId, oppId);
        //String devId = ASICSSpecificationsShare_Test.createDevice(oppProgId);
        
        test.startTest();
        
        //Create new oppty program team members
        Opportunity_Program_Team_Member__c oppProgTM = ASICSSpecificationsShare_Test.createOppProgTmMem1(oppProgId, userId1);
        Opportunity_Program_Team_Member__c oppProgTM2 = ASICSSpecificationsShare_Test.createOppProgTmMem1(oppProgId, userId2);
        
        //Create new device
        
        String devId = ASICSSpecificationsShare_Test.createDevice(oppProgId);
        
        //Create new Asic
        
        String asicId= ASICSSpecificationsShare_Test.createAsic(devId);
        
        
        //add couple of opportunity program share record
        Opportunity_Program__Share oppProgShare1 = ASICSSpecificationsShare_Test.createOppProgramShare(oppProgId,userId1);
        Opportunity_Program__Share oppProgShare2 = ASICSSpecificationsShare_Test.createOppProgramShare(oppProgId,userId2);
        
        //adding couple of device share record
        Device__Share devShare1 = ASICSSpecificationsShare_Test.createDeviceShare(devId,userId1);
        Device__Share devShare2 = ASICSSpecificationsShare_Test.createDeviceShare(devId,userId2);
        
        //adding couple of Asic share record
        ASICS_Specification__Share asicShare1 = ASICSSpecificationsShare_Test.createasicShare(asicId,userId1);
        ASICS_Specification__Share asicShare2 = ASICSSpecificationsShare_Test.createasicShare(asicId,userId2);
        
        
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
        String userId1 = ASICSSpecificationsShare_Test.createUser1();
        String userId2 = ASICSSpecificationsShare_Test.createUser2();
        String acctId = ASICSSpecificationsShare_Test.createAccount();
        String oppId = ASICSSpecificationsShare_Test.createOpp(acctId);
        String oppProgId = ASICSSpecificationsShare_Test.createOppProg(acctId, oppId);
        
        test.startTest();
        
        //Create new oppty program team members
        Opportunity_Program_Team_Member__c oppProgTM = ASICSSpecificationsShare_Test.createOppProgTmMem1(oppProgId, userId1);
        Opportunity_Program_Team_Member__c oppProgTM2 = ASICSSpecificationsShare_Test.createOppProgTmMem1(oppProgId, userId2);
        
        //Create new device
        
        String devId = ASICSSpecificationsShare_Test.createDevice(oppProgId);
        
        //Create new Asic
        
        String asicId= ASICSSpecificationsShare_Test.createAsic(devId);
        
       
        //add couple of opportunity program share record
        Opportunity_Program__Share oppProgShare1 = ASICSSpecificationsShare_Test.createOppProgramShare(oppProgId,userId1);
        Opportunity_Program__Share oppProgShare2 = ASICSSpecificationsShare_Test.createOppProgramShare(oppProgId,userId2);
        
        //adding couple of device share record
        Device__Share devShare1 = ASICSSpecificationsShare_Test.createDeviceShare(devId,userId1);
        Device__Share devShare2 = ASICSSpecificationsShare_Test.createDeviceShare(devId,userId2);
        
        //adding couple of Asic share record
        ASICS_Specification__Share asicShare1 = ASICSSpecificationsShare_Test.createasicShare(asicId,userId1);
        ASICS_Specification__Share asicShare2 = ASICSSpecificationsShare_Test.createasicShare(asicId,userId2);
        
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