/*
  Author: Anirban Roy
  Description: This is the test class for the IpDeclarationReassignOwnerController class.
  History:
    ARoy        10132013    - code creation.
    Vijay       16012015    - Updated the Device Stage 'Solutioning' to 'Design In' as Device will be created in 
                                  'Design In' directly and added mandatory fields.
    DBiswal     04072015    - Updated code for refactoring of test class.           
    ARoy        08142017    - Modified for Export Control changes            
*/

@isTest
public class IpDecReassignOwnerController_Test {
    
    @testSetup static void testdata() {
        DataUtilTest.loadEnvironmentVariables();
        AcctRegHeadMappingTgrHandler.bypassAcctTrigger = true;
        ClsAccTriggerHandler.blnAccountShareRun = true;
        User user = IpDecReassignOwnerController_Test.createUser1();
        System.runAs(user)
        {
        Map<String,Object> fieldValueMap = new Map<String,Object>();
        fieldValueMap.put('Name', 'MYTEST ACCOUNT1');            
        fieldValueMap.put('IP_Declaration_Template__c', 'IP_Declaration_Version_default');        
        fieldValueMap.put('sub_type__c', 'Direct');
        fieldValueMap.put('site_department__c', 'test dept');          
        fieldValueMap.put('transaction_type__c', 'transactional');                          
        fieldValueMap.put('region__c', 'US');        
        fieldValueMap.put('Corporate_Address_1__c', 'Test Address 1');          
        fieldValueMap.put('Corporate_City__c', 'Test City');                
        fieldValueMap.put('Corporate_Country__c', 'India');
        fieldValueMap.put('Bill_To_Address_1__c', 'Test Address 1');          
        fieldValueMap.put('Bill_To_City__c', 'Test City');            
        fieldValueMap.put('Bill_To_Country__c', 'India');        
        fieldValueMap.put('Fab_9_10__c','No');

        AccountDataFactory.createAccount(fieldValueMap);
        }
    }
    
    //Creation of User
    static User createUser1(){
        User usr1 = [select id,name,email from User where profileId in (select id from Profile where Name='System Administrator') and IsActive=true and UserRoleId in (select id from UserRole where Name='Global Admin') limit 1];
        return usr1;
    }       
        
    // Creation of a Contact
    static Id createContact(Id acctId){
        Contact con = new Contact();
        con.FirstName='Mr';
        con.LastName='Testcon1';
        con.AccountId=acctId;
        con.Email='con1@gf.com';
        con.Department__c='Design';
                                  
        insert con;
        return con.Id;
    }
    
    
    // Creation of an opportunity
    static Id createOpp(Id acctId){
      Map<String,Object> fieldValueMap = new Map<String,Object>();
        fieldValueMap.put('AccountId',acctId);
        fieldValueMap.put('Name','Win Test Opportunity 12345');  
        fieldValueMap.put('StageName','1. Discovery');
        fieldValueMap.put('CloseDate',date.newinstance(2012, 12, 21));  
        fieldValueMap.put('Target_Process_Node__c','14XM');
        fieldValueMap.put('Market_Segment__c','Automotive');  
        fieldValueMap.put('Process_Platform__c','GF Baseline');
        fieldValueMap.put('Fab_Split__c',100);          
        fieldValueMap.put('Process_Geometry__c','0.09UM');  
        fieldValueMap.put('Process_Family__c','Generic / Nominal');
        fieldValueMap.put('Opportunity_Sourcing_Type__c','First Source');  
        
        return OpportunityDataFactory.createOpportunity(fieldValueMap).id;
        
    }
    
    // Creation of an opportunity program
    static Id createOppProg(Id acctId,Id oppId){
        Opportunity_Program__c opProg = new Opportunity_Program__c(Name='Win Test OppProg 12345',Account__c=acctId,Opportunity__c=oppId);
        insert opProg;
        return opProg.Id;
    }
    
    // Creation of an opportunity program team member
    static Opportunity_Program_Team_Member__c createOppProgTmMem(Id oppProgId, Id userId){
        Opportunity_Program_Team_Member__c oppProgTM = new Opportunity_Program_Team_Member__c(Core_Team_Member__c=false,
                                        Device_Access__c='Read/Write',Opportunity_Program_Access__c='Read/Write',
                                        Opportunity_Program__c=oppProgId,Team_Role__c='Field Application Engineer',
                                        User__c=userId,Flag_for_Delete__c=false);
        insert oppProgTM;
        return oppProgTM;
    }
    static Id createMaskSetTitle(){
        Map<String,Object> fieldValueMap = new Map<String,Object>();
        fieldValueMap.put('Name','MSTTRT1');
        fieldValueMap.put('Reticle_Type__c','Multi Layer Reticle (MLR)');
        return MaskSetTitleDataFactory.createMaskSetTitle(fieldValueMap).Id;
    }
    public static Device__c createCMPWDevice(Id acctId,Id opptyProgramId){
        String MSTId = CreateMaskSetTitle();
        string MSTAccId = DeviceUtilTest.createMSTAccount(acctId,MSTId);
        // Create Device
        Map<String,Object> fieldValueMap = new Map<String,Object>();
        fieldValueMap.put('Account__c',acctId);
        fieldValueMap.put('Name','Win-TEST-DEVICE-1947');
        fieldValueMap.put('Opportunity_Program__c',opptyProgramId);
        fieldValueMap.put('Fab__c','FAB 2');
        fieldValueMap.put('GSOP_Assignment_Tapeout_Plan__c','No');
        fieldValueMap.put('Market_Segment__c','Automotive');
        fieldValueMap.put('Semiconductor_Device__c','Analog Amplifier');
        fieldValueMap.put('End_Customer__c','Test Customer');
        fieldValueMap.put('Device_Sourcing__c','3rd Source');
        fieldValueMap.put('Stage__c','Design In');
        fieldValueMap.put('Status__c','Active');
        fieldValueMap.put('Siebel_Device_ID__c','1234567890');
        fieldValueMap.put('Tapeout_Type__c','Customer MPW');
        fieldValueMap.put('PLM_Device_ID__c','ANBQP60ACO8CH-U01');
        fieldValueMap.put('Device_Mask_Set_Title__c','MSTTRT1');
        fieldValueMap.put('CRMDID__c','CDID0000001.00');
        fieldValueMap.put('Actual_Tapeout_Date__c',date.newInstance(2013,5,20));
        fieldValueMap.put('Original_Forecasted_Tapeout_Date__c',date.newInstance(2013,5,20));
        fieldValueMap.put('Current_Forecast_Tapeout_Date__c',date.newInstance(2013,3,4));
        fieldValueMap.put('Confidence_Level_Tapeout__c','100');
        fieldValueMap.put('Device_Type__c','Base');
        fieldValueMap.put('End_Application__c','Body');
        fieldValueMap.put('IP_Gap__c',false);
        return DeviceDataFactory.createDevice(fieldValueMap);
    }
    
    //Creation of Portal User
    static User createportalUser1(Id conId){
    //static Id createportalUser1() {
        Profile profileObj = [Select Name,Id from Profile where Name = 'Customer Portal Admin'];
        //UserRole userRoleObj = [SELECT Id FROM UserRole WHERE DeveloperName = 'Customer User'];
        User usr1 = new User(Alias = 'Test', Email='Test@test.com', EmailEncodingKey='UTF-8', LastName='Test',
                            LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = profileObj.Id, TimeZoneSidKey='America/Los_Angeles',
                            UserName='Test1212112@test.com', Portal_Login__c = 'abc', contactId = conId, IsActive = true);
        insert usr1;
        return usr1;
        
        /* User usr1 = [
            SELECT      Id
            FROM        User
            WHERE       Contact.Id != null
                        AND IsActive = true
            LIMIT 1
        ];
        
        return usr1.Id; */
    }
    
    // Creation of Device
   /* static Device__c createDevice(Id accId, Id oppId, Id oppProgId){
        Device__c dev = new Device__c();
        dev.Name = 'Win-TEST-DEVICE-1947';
        dev.Stage__c = 'Design In';
        dev.Status__c = 'Active';
        dev.Account__c = accId;
        dev.Opportunity2__c = oppId;
        dev.Opportunity_Program__c = oppProgId;
        dev.Market_Segment__c = 'Automotive';
        dev.Semiconductor_Device__c = 'Analog Regulator';
        dev.End_Application__c = 'Body';
        dev.Device_Sourcing__c = '3rd Source';
        dev.Tapeout_Type__c = 'Customer MPW';
        dev.Siebel_Device_ID__c = '0987654321';
        dev.IP_Gap__c = false;
        dev.Actual_Tapeout_Date__c = date.newInstance(2013,5,20);
        dev.Original_Forecasted_Tapeout_Date__c = date.newInstance(2013,5,20);
        dev.Current_Forecast_Tapeout_Date__c = date.newInstance(2013,3,4);
        dev.Fab__c = 'Fab 3';
        dev.Confidence_Level_Tapeout__c = '100';
        insert dev;
        return dev; 
    }
       */
    static IP_Declaration_Form__c createIpDecForm(Id testDeviceId) {
        // Create IP_Declaration_Form
        IP_Declaration_Form__c ipDecForm = new IP_Declaration_Form__c();
        ipDecForm.Device__c = testDeviceId;
        IpDecForm.Status__c = 'Draft';
        IpDecForm.OwnerId__c = UserInfo.getUserId();
        IpDecForm.Last_Assigned_Customer_User__c = UserInfo.getUserId();
        
        Insert ipDecForm;        
        
        return ipDecForm;
    }
    
    static testMethod void reAssignIpDecFormInPortalTest(){
        // Data creation
        //DataUtilTest.loadEnvironmentVariables();
        User admin = DeviceChecklistTestDataUtils.createUserWithDCAdmin('System Administrator');
        System.runAs(admin){
            IntegrationUsers__c skipUser = new IntegrationUsers__c(SetupOwnerId = admin.Id, Is_Integration_User__c= true, Skip_Trigger__c = true, Skip_Validation_Rule__c = true);
            insert skipUser;
            User user = IpDecReassignOwnerController_Test.createUser1();
            String acctId = getAccount('MYTEST ACCOUNT1').id;
            String conId = IpDecReassignOwnerController_Test.createContact(acctId);
            String oppId = IpDecReassignOwnerController_Test.createOpp(acctId);
            String oppProgId = IpDecReassignOwnerController_Test.createOppProg(acctId, oppId);
            Opportunity_Program_Team_Member__c oppProgTM = IpDecReassignOwnerController_Test.createOppProgTmMem(oppProgId, user.Id);  
            
                    
            
            Test.startTest();
            Device__c dev = createCMPWDevice(acctId,oppProgId); 
            IP_Declaration_Form__c ipDecForm = IpDecReassignOwnerController_Test.createIpDecForm(dev.Id);
            ApexPages.currentPage().getParameters().put('id',ipDecForm.Id);
            
            IpDeclarationReassignOwnerController ipDecReAssign = new IpDeclarationReassignOwnerController();
            List<SelectOption> selOpt = ipDecReAssign.getAllAccountContacts();
            
            ApexPages.currentPage().getParameters().put('type','list');
            
            ipDecReAssign.ownerId = UserInfo.getUserId();
            ipDecReAssign.notesToNewOwner = 'TestComment';
            
            PageReference pgr = ipDecReAssign.save();
            //system.assert(pgr.getUrl().contains('/apex/MyDevices'));
            
            pgr = ipDecReAssign.cancel();
            system.assert(pgr.getUrl().contains('/apex/MyDevices'));
            
            Test.stopTest();
         }
     }
     
     static testMethod void reAssignIpDecFormTest(){
        // Data creation
        //DataUtilTest.loadEnvironmentVariables();
        User admin = DeviceChecklistTestDataUtils.createUserWithDCAdmin('System Administrator');
        System.runAs(admin){
            IntegrationUsers__c skipUser = new IntegrationUsers__c(SetupOwnerId = admin.Id, Is_Integration_User__c= true, Skip_Trigger__c = true, Skip_Validation_Rule__c = true);
            insert skipUser;
            User user = IpDecReassignOwnerController_Test.createUser1();
            String acctId = getAccount('MYTEST ACCOUNT1').id;
            String conId = IpDecReassignOwnerController_Test.createContact(acctId);
            String oppId = IpDecReassignOwnerController_Test.createOpp(acctId);
            String oppProgId = IpDecReassignOwnerController_Test.createOppProg(acctId, oppId);
            Opportunity_Program_Team_Member__c oppProgTM = IpDecReassignOwnerController_Test.createOppProgTmMem(oppProgId, user.Id);  
            
            Test.startTest();
            Device__c dev = createCMPWDevice(acctId,oppProgId); 
            IP_Declaration_Form__c ipDecForm = IpDecReassignOwnerController_Test.createIpDecForm(dev.Id);
            ApexPages.currentPage().getParameters().put('id',ipDecForm.Id);
            
            IpDeclarationReassignOwnerController ipDecReAssign = new IpDeclarationReassignOwnerController();        
            
            ipDecReAssign.ownerId = UserInfo.getUserId();
            ipDecReAssign.notesToNewOwner = 'TestComment';
            
            PageReference pgr = ipDecReAssign.save();
           // system.assert(pgr.getUrl().contains(ipDecForm.Id));
            
            pgr = ipDecReAssign.cancel();
            system.assert(pgr.getUrl().contains(ipDecForm.Id));
            
            Test.stopTest();
         }
     }   

    static testMethod void reAssignIpDecPortalFormTest(){
        // Data creation
        //DataUtilTest.loadEnvironmentVariables();
        User admin = DeviceChecklistTestDataUtils.createUserWithDCAdmin('System Administrator');
        System.runAs(admin){
            IntegrationUsers__c skipUser = new IntegrationUsers__c(SetupOwnerId = admin.Id, Is_Integration_User__c= true, Skip_Trigger__c = true, Skip_Validation_Rule__c = true);
            insert skipUser;
            User user = IpDecReassignOwnerController_Test.createUser1();
            String acctId = getAccount('MYTEST ACCOUNT1').id;
            String conId = IpDecReassignOwnerController_Test.createContact(acctId);
            String oppId = IpDecReassignOwnerController_Test.createOpp(acctId);
            String oppProgId = IpDecReassignOwnerController_Test.createOppProg(acctId, oppId);
            Opportunity_Program_Team_Member__c oppProgTM = IpDecReassignOwnerController_Test.createOppProgTmMem(oppProgId, user.Id);  
            
            Test.startTest();
            User portalUser = IpDecReassignOwnerController_Test.createportalUser1(conId);
            Device__c dev = createCMPWDevice(acctId,oppProgId); 
            IP_Declaration_Form__c ipDecForm = IpDecReassignOwnerController_Test.createIpDecForm(dev.Id);
            ApexPages.currentPage().getParameters().put('id',ipDecForm.Id);
            IpDeclarationReassignOwnerController ipDecReAssign = new IpDeclarationReassignOwnerController();    
            system.runAs(portalUser){
                List<SelectOption> selOpt = ipDecReAssign.getAllAccountContacts();
            }
            ipDecReAssign.ownerId = portalUser.Id;
            //ipDecReAssign.notesToNewOwner = 'TestComment';
            PageReference pgr = ipDecReAssign.save();
            system.assert(pgr.getUrl().contains(ipDecForm.Id));
            Test.stopTest();
         }
         
         
     }
     
     private static Account getAccount(string AccountName)
    {
        Account acct = [SELECT Id, Name FROM Account Where Name =: AccountName];
        
        return acct;
    }
}