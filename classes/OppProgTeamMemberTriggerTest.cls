/*
  Author: Anirban Roy
  Description: Unit Test class for OppProgTeamMember trigger and OpptyTeamManager class.
  History:
    ARoy  03142013  - code creation.
*/

@isTest(SeeAllData=false)
private class OppProgTeamMemberTriggerTest {

    @testSetup static void testdata(){
        DataUtilTest.loadEnvironmentVariables();
 
         Map<String,Object> fieldValueMap = new Map<String,Object>();       
        fieldValueMap.put('Name', 'testing501');
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
                 Account acc= getAccount('testing501'); 
            return acc.Id;
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
        
    
    static testMethod void oppProgTmMemCreateTest() {
        
        //Data preparation
        String userId1 = OppProgTeamMemberTriggerTest.createUser1();
        String userId2 = OppProgTeamMemberTriggerTest.createUser2();
        String acctId = OppProgTeamMemberTriggerTest.createAccount();
        String oppId = OppProgTeamMemberTriggerTest.createOpp(acctId);
        String oppProgId = OppProgTeamMemberTriggerTest.createOppProg(acctId, oppId);
        Mask_Set_Title__c MSTId = DeviceUtilTest.createMaskSetTtitleObj('MSTTRT');
        string MSTAccId = DeviceUtilTest.createMSTAccount(acctId,MSTId.id);
        test.startTest();
        
        //Create new oppty program team members
        Opportunity_Program_Team_Member__c oppProgTM = OppProgTeamMemberTriggerTest.createOppProgTmMem1(oppProgId, userId1);
        Opportunity_Program_Team_Member__c oppProgTM2 = OppProgTeamMemberTriggerTest.createOppProgTmMem1(oppProgId, userId2);
        
        //Create new device
        
        String devId = OppProgTeamMemberTriggerTest.createDevice(acctId, oppId,oppProgId);
        
        
        
        //add couple of opportunity program share record
        Opportunity_Program__Share oppProgShare1 = OppProgTeamMemberTriggerTest.createOppProgramShare(oppProgId,userId1);
        Opportunity_Program__Share oppProgShare2 = OppProgTeamMemberTriggerTest.createOppProgramShare(oppProgId,userId2);
        
        //adding couple of device share record
        Device__Share devShare1 = OppProgTeamMemberTriggerTest.createDeviceShare(devId,userId1);
        Device__Share devShare2 = OppProgTeamMemberTriggerTest.createDeviceShare(devId,userId2);
               
        test.stopTest();
        
    }
    
    static testMethod void oppProgTmMemUpdateTest() {
        
        //Data preparation
        String userId1 = OppProgTeamMemberTriggerTest.createUser1();
        String userId2 = OppProgTeamMemberTriggerTest.createUser2();
        String acctId = OppProgTeamMemberTriggerTest.createAccount();
        String oppId = OppProgTeamMemberTriggerTest.createOpp(acctId);
        String oppProgId = OppProgTeamMemberTriggerTest.createOppProg(acctId, oppId);
        Mask_Set_Title__c MSTId = DeviceUtilTest.createMaskSetTtitleObj('MSTTRT');
        string MSTAccId = DeviceUtilTest.createMSTAccount(acctId,MSTId.id);
        test.startTest();
        
        //Create new oppty program team members
        Opportunity_Program_Team_Member__c oppProgTM = OppProgTeamMemberTriggerTest.createOppProgTmMem1(oppProgId, userId1);
        Opportunity_Program_Team_Member__c oppProgTM2 = OppProgTeamMemberTriggerTest.createOppProgTmMem1(oppProgId, userId2);
        
        //Create new device
        
        String devId = OppProgTeamMemberTriggerTest.createDevice(acctId, oppId,oppProgId);
        
        
        
        //add couple of opportunity program share record
        Opportunity_Program__Share oppProgShare1 = OppProgTeamMemberTriggerTest.createOppProgramShare(oppProgId,userId1);
        Opportunity_Program__Share oppProgShare2 = OppProgTeamMemberTriggerTest.createOppProgramShare(oppProgId,userId2);
        
        //adding couple of device share record
        Device__Share devShare1 = OppProgTeamMemberTriggerTest.createDeviceShare(devId,userId1);
        Device__Share devShare2 = OppProgTeamMemberTriggerTest.createDeviceShare(devId,userId2);
        
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
        String userId1 = OppProgTeamMemberTriggerTest.createUser1();
        String userId2 = OppProgTeamMemberTriggerTest.createUser2();
        String acctId = OppProgTeamMemberTriggerTest.createAccount();
        String oppId = OppProgTeamMemberTriggerTest.createOpp(acctId);
        String oppProgId = OppProgTeamMemberTriggerTest.createOppProg(acctId, oppId);
        Mask_Set_Title__c MSTId = DeviceUtilTest.createMaskSetTtitleObj('MSTTRT');
        string MSTAccId = DeviceUtilTest.createMSTAccount(acctId,MSTId.id);
        test.startTest();
        
        //Create new oppty program team members
        Opportunity_Program_Team_Member__c oppProgTM = OppProgTeamMemberTriggerTest.createOppProgTmMem1(oppProgId, userId1);
        Opportunity_Program_Team_Member__c oppProgTM2 = OppProgTeamMemberTriggerTest.createOppProgTmMem1(oppProgId, userId2);
        
        //Create new device
        
        String devId = OppProgTeamMemberTriggerTest.createDevice(acctId, oppId,oppProgId);
        
        
        
        //add couple of opportunity program share record
        Opportunity_Program__Share oppProgShare1 = OppProgTeamMemberTriggerTest.createOppProgramShare(oppProgId,userId1);
        Opportunity_Program__Share oppProgShare2 = OppProgTeamMemberTriggerTest.createOppProgramShare(oppProgId,userId2);
        
        //adding couple of device share record
        Device__Share devShare1 = OppProgTeamMemberTriggerTest.createDeviceShare(devId,userId1);
        Device__Share devShare2 = OppProgTeamMemberTriggerTest.createDeviceShare(devId,userId2);
        
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
    
    private static Account getAccount(string AccountName)
            {
                Account acc= [SELECT Id, Name FROM Account Where Name =: AccountName];
        
                return acc;
            }  
 
}