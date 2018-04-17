/*
  Author: Anirban Roy
  Description: Unit Test class for Opportunity Program Team Member controller class and Opportunity Program Team Member Trigger.
  History:
    ARoy  02212013  - code creation.
    ARoy  03142013  - modified for Opportunity Program Team Member Trigger.
*/

@isTest(SeeAllData=false)
private class OppTeamMemberControllerTest {

@testSetup static void testdata(){
        DataUtilTest.loadEnvironmentVariables();
 
         Map<String,Object> fieldValueMap = new Map<String,Object>();       
        fieldValueMap.put('Name', 'testing701');
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
        fieldValueMap.put('recordtypeid', EnvironmentVariable.get('ACCT_RT_ID_CUSTOMER'));       
        AccountDataFactory.createAccount(fieldValueMap);
    }   
    
    static Id createUser1(){
        User usr1 = [select id from User where profileId in (select id from Profile where Name='System Administrator') and IsActive=true limit 1];
        return usr1.Id;
    }
    
    static Id createUser2(){
        User usr2 = [select id from User where profileId in (select id from Profile where Name='GF System Admin') and IsActive=true limit 1];
        return usr2.Id;
    }
    
    static Id createAccount(){
                 Account acct= getAccount('testing701'); 
        return acct.Id;
    }
    
    static Id createOpp(Id acctId){
      Map<String,Object> fieldValueMap = new Map<String,Object>();
        fieldValueMap.put('AccountId',acctId);
        fieldValueMap.put('Name','Test Opportunity');  
        fieldValueMap.put('StageName','1. Discovery');
        fieldValueMap.put('CloseDate',date.newinstance(2012, 12, 21));  
        fieldValueMap.put('Target_Process_Node__c','14XM');
        fieldValueMap.put('Market_Segment__c','Automotive');  
        fieldValueMap.put('Process_Platform__c','GF Baseline');
        fieldValueMap.put('Fab_Split__c',100);          
        fieldValueMap.put('Process_Geometry__c','0.014UM');  
        fieldValueMap.put('Process_Family__c','Super Low Power');
        fieldValueMap.put('Opportunity_Sourcing_Type__c','First Source');  
        fieldValueMap.put('Fab_Assignment_1__c','FAB 1');
         
        return OpportunityDataFactory.createOpportunity(fieldValueMap).id;
        
    }
    
    static Id createOppProg(Id acctId,Id oppId){
        Opportunity_Program__c opProg = new Opportunity_Program__c(Name='Test OppProg',Account__c=acctId,Opportunity__c=oppId);
        insert opProg;
        return opProg.Id;
    }
        
    static Id createDevice(Id accId, Id oppId, Id oppProgId){
        Map<String,Object> fieldValueMap = new Map<String,Object>();
        fieldValueMap.put('Name','TESTDEVICE1313');
        fieldValueMap.put('Stage__c','Solutioning');
        fieldValueMap.put('Status__c','Active');
        fieldValueMap.put('Account__c',accId);
        fieldValueMap.put('Opportunity2__c',oppId);
        fieldValueMap.put('Opportunity_Program__c',oppProgId);
        fieldValueMap.put('Market_Segment__c','Automotive');
        fieldValueMap.put('Semiconductor_Device__c','Analog Regulator');
        fieldValueMap.put('End_Application__c','Body');
        fieldValueMap.put('Device_Sourcing__c','3rd Source');
        fieldValueMap.put('Tapeout_Type__c','Customer MPW');
        fieldValueMap.put('Siebel_Device_ID__c','0987654321');
        fieldValueMap.put('Original_Forecasted_Tapeout_Date__c',date.newInstance(2013,5,20));
        fieldValueMap.put('Current_Forecast_Tapeout_Date__c',date.newInstance(2013,3,4));
        return DeviceDataFactory.createDevice(fieldValueMap).Id;
    }
    
    static Opportunity_Program_Team_Member__c createOppProgTmMem1(Id oppProgId, Id userId){
        Opportunity_Program_Team_Member__c oppProgTM = new Opportunity_Program_Team_Member__c(Core_Team_Member__c=false,
                                        Device_Access__c='Read/Write',Opportunity_Program_Access__c='Read/Write',
                                        Opportunity_Program__c=oppProgId,Team_Role__c='Primary Account Manager',
                                        User__c=userId,Flag_for_Delete__c=false);
        insert oppProgTM;
        return oppProgTM;
    }
    
    static Opportunity_Program_Team_Member__c createOppProgTmMem2(Id oppProgId, Id userId){
        Opportunity_Program_Team_Member__c oppProgTM1 = new Opportunity_Program_Team_Member__c(Core_Team_Member__c=false,
                                        Device_Access__c='Read/Write',Opportunity_Program_Access__c='Read/Write',
                                        Opportunity_Program__c=oppProgId,Team_Role__c='Field Engineer',
                                        User__c=userId,Flag_for_Delete__c=true);
        insert oppProgTM1;
        return oppProgTM1;
    }
    
    static Opportunity_Program_Team_Member__c createOppProgTmMem3(Id oppProgId, Id userId){
        Opportunity_Program_Team_Member__c oppProgTM1 = new Opportunity_Program_Team_Member__c(Core_Team_Member__c=false,                                       
                                        Opportunity_Program__c=oppProgId,
                                        User__c=userId,Flag_for_Delete__c=false);
        insert oppProgTM1;
        return oppProgTM1;
    }
    
    static Opportunity_Program__Share createOppProgramReadShare(Id oppProgId,Id userId){
        Opportunity_Program__Share oppProgShare1 = new Opportunity_Program__Share(AccessLevel='Read',
                                                    ParentId=oppProgId,RowCause='Opportunity_Program_Team__c',
                                                    UserOrGroupId=userId
                                                        );
        insert oppProgShare1;
        return oppProgShare1;
    }
    
    static Opportunity_Program__Share createOppProgramEditShare(Id oppProgId,Id userId){
        Opportunity_Program__Share oppProgShare2 = new Opportunity_Program__Share(AccessLevel='Edit',
                                                    ParentId=oppProgId,RowCause='Opportunity_Program_Team__c',
                                                    UserOrGroupId=userId
                                                        );
        insert oppProgShare2;
        return oppProgShare2;
    }

    static Device__Share createDeviceReadShare(Id devId,Id userId){
        Device__Share devShare1 = new Device__Share(AccessLevel='Read',
                                                    ParentId=devId,RowCause='Opportunity_Program_Team__c',
                                                    UserOrGroupId=userId
                                                        );
        insert devShare1;
        return devShare1;
    }

    static Device__Share createDeviceEditShare(Id devId,Id userId){
        Device__Share devShare2 = new Device__Share(AccessLevel='Edit',
                                                    ParentId=devId,RowCause='Opportunity_Program_Team__c',
                                                    UserOrGroupId=userId
                                                        );
        insert devShare2;
        return devShare2;
    }
        
    
    static testMethod void oppProgTmMemSaveTest() {
        
        //Data preparation
        String userId1 = OppTeamMemberControllerTest.createUser1();
        String userId2 = OppTeamMemberControllerTest.createUser2();
        String acctId = OppTeamMemberControllerTest.createAccount();
        String oppId = OppTeamMemberControllerTest.createOpp(acctId);
        String oppProgId = OppTeamMemberControllerTest.createOppProg(acctId, oppId);
        Mask_Set_Title__c MSTId = DeviceUtilTest.createMaskSetTtitleObj('MSTTRT');
        string MSTAccId = DeviceUtilTest.createMSTAccount(acctId,MSTId.id);
        Test.startTest();
        String devId = OppTeamMemberControllerTest.createDevice(acctId, oppId,oppProgId);
        test.stopTest();
        Opportunity_Program_Team_Member__c oppProgTM = OppTeamMemberControllerTest.createOppProgTmMem1(oppProgId, userId1);
        Opportunity_Program_Team_Member__c oppProgTM1 = OppTeamMemberControllerTest.createOppProgTmMem2(oppProgId, userId2);
        Opportunity_Program__Share oppProgShare1 = OppTeamMemberControllerTest.createOppProgramReadShare(oppProgId,userId1);
        Opportunity_Program__Share oppProgShare2 = OppTeamMemberControllerTest.createOppProgramEditShare(oppProgId,userId2);
        Device__Share devShare1 = OppTeamMemberControllerTest.createDeviceReadShare(devId,userId1);
        
        Device__Share devShare2 = OppTeamMemberControllerTest.createDeviceEditShare(devId,userId2);
        apexpages.currentpage().getparameters().put('id',oppProgId);
        
        OppTeamMemberController oppTmMem = new OppTeamMemberController();
        
        PageReference pgRef = oppTmMem.Save();
        system.assert(pgRef!=null);       
        
        //System.runAs with a different user
       /* Start**************************Commented by Baij*************/
        /*
        User usr = [select id from User where profileId in (select id from Profile where Name='GF System Admin') and IsActive=true limit 1];
        System.runAs(usr){
            apexpages.currentpage().getparameters().put('id',oppProgId);

            oppTmMem = new OppTeamMemberController();
                    
            pgRef = oppTmMem.Save();
            system.assert(pgRef!=null);

        }  */
        /*End**************************Commented by Baij*************/      
        
        
        
    }
    
    static testMethod void oppProgMembrValidTest() {
        
        //Data preparation
        String userId1 = OppTeamMemberControllerTest.createUser1();
        String userId2 = OppTeamMemberControllerTest.createUser2();
        String acctId = OppTeamMemberControllerTest.createAccount();
        String oppId = OppTeamMemberControllerTest.createOpp(acctId);
        String oppProgId = OppTeamMemberControllerTest.createOppProg(acctId, oppId);
        Opportunity_Program_Team_Member__c oppProgTM = OppTeamMemberControllerTest.createOppProgTmMem1(oppProgId, userId2);
        
        test.startTest();
        
        apexpages.currentpage().getparameters().put('id',oppProgId);
        
        OppTeamMemberController oppTmMem = new OppTeamMemberController();
        
        //After adding a row and not providing Opportunity_Program_Access__c,Device_Access__c and Team_Role__c
        Opportunity_Program_Team_Member__c oppProgTM1 = new Opportunity_Program_Team_Member__c(Core_Team_Member__c=false,
                                                    Opportunity_Program__c=oppProgId,User__c=userId2);
        
        OppTeamMemberController.OppProgramTeamMemberModel optmMod = new OppTeamMemberController.OppProgramTeamMemberModel();
        optmMod.OPTM=oppProgTM1;
        oppTmMem.OppProgramTMModelList.add(optmMod);
        
        PageReference pgRef = oppTmMem.Save();
        system.assert(pgRef==null);
        
        //Creating exceptional situation when the opportunity program list is having duplicate values
        oppProgTM = new Opportunity_Program_Team_Member__c(Core_Team_Member__c=false,Team_Role__c='Primary Account Manager',
                                                    Device_Access__c='Read/Write',Opportunity_Program_Access__c='Read/Write',
                                                    Opportunity_Program__c=oppProgId,User__c=userId1);                                                                                                      
        
        insert oppProgTM;
        
        optmMod = new OppTeamMemberController.OppProgramTeamMemberModel();
        optmMod.OPTM=oppProgTM;
        oppTmMem.OppProgramTMModelList.add(optmMod);
        
        pgRef = oppTmMem.Save();
        system.assert(pgRef==null);
        
        //Creating exceptional situation when the opportunity program list is empty
        oppTmMem.OppProgramTMModelList=null;
        pgRef = oppTmMem.Save();
        system.assert(pgRef==null);
        
        test.stopTest();
        
    }
    
             private static Account getAccount(string AccountName)
            {
                Account acct= [SELECT Id, Name FROM Account Where Name =: AccountName];
        
                return acct;
            }  
}