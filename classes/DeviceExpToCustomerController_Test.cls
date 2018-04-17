/*
  Author: Anirban Roy
  Description: This is the test class for the controller class DeviceExpToCustomerController.
  History:
    ARoy        06182013    - code creation.
    Vijay       16012015    - Updated the Device Stage 'Solutioning' to 'Design In' as Device will be created in 
                                  'Design In' directly and added mandatory fields.                       
*/

@isTest(SeeAllData=false)
public class DeviceExpToCustomerController_Test {
    @testSetup static void testdata() {
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

        AccountDataFactory.createAccount(fieldValueMap);
    }
    //Creation of User
    static User createUser1(){
        User usr1 = [select id,name,email from User where profileId in (select id from Profile where Name='System Administrator') and IsActive=true limit 1];
        return usr1;
    }
    
   
    // Creation of an opportunity
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
        fieldValueMap.put('Process_Geometry__c','0.50UM');  
        fieldValueMap.put('Process_Family__c','Generic / Nominal');
        
        return OpportunityDataFactory.createOpportunity(fieldValueMap).id;        
    }
    
    // Creation of an opportunity program
    static Id createOppProg(Id acctId,Id oppId){
        Opportunity_Program__c opProg = new Opportunity_Program__c(Name='Test OppProg',Account__c=acctId,Opportunity__c=oppId);
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
    
     static id createDevice(Id oppProgId) {
        // Create Device
        Map<String,Object> fieldValueMap = new Map<String,Object>();
        fieldValueMap.put('Name','TESTDEVICEZAIH12345677'); 
        fieldValueMap.put('Opportunity_Program__c',oppProgId); 
        fieldValueMap.put('Fab__c','Fab 3'); 
        fieldValueMap.put('GSOP_Assignment_Tapeout_Plan__c','No'); 
        fieldValueMap.put('Market_Segment__c','Mobility'); 
        fieldValueMap.put('Semiconductor_Device__c','Analog Amplifier'); 
        fieldValueMap.put('End_Customer__c','Test Customer'); 
        fieldValueMap.put('Device_Sourcing__c','1st Source'); 
        fieldValueMap.put('Stage__c','Design In'); 
        fieldValueMap.put('Status__c','Active'); 
        fieldValueMap.put('Tapeout_Type__c','Single Product'); 
        fieldValueMap.put('Geometry_Filter__c','0.50UM'); 
        fieldValueMap.put('Process_Family_Filter__c','Generic / Nominal'); 
        fieldValueMap.put('Export_Control_Status__c','Undeclared'); 
        fieldValueMap.put('End_Application__c','Body'); 
        fieldValueMap.put('Confidence_Level_Tapeout__c','100'); 
        fieldValueMap.put('Original_Forecasted_Tapeout_Date__c',System.today()); 
        fieldValueMap.put('Enabled_via_previous_MPW_1__c','No'); 
        fieldValueMap.put('Reticle_Type__c','Multi Layer Reticle (MLR)');
        return DeviceDataFactory.createDevice(fieldValueMap).Id;
    }
    
    // Creation of an Ip declaration
    static void createIpDec(Id deviceid){
        IP_Declaration_Form__c IP = new IP_Declaration_Form__c();
        IP.device__c =  deviceid;
        IP.status__c = 'Undeclared';
        insert ip;
                
                   
    }
    
    static void createExpCF(id deviceId, id acctId){
        Export_Control_Form__c exp = new Export_Control_Form__c();
        exp.account__c = acctId;
        exp.status__c = 'Undeclared';                
        insert exp;
        
        Device_Export_Control_Junction__c j = new Device_Export_Control_Junction__c(
        device__c = deviceid,
        export_control_form__c = exp.id);
        insert j;
    }
    
    // test method for getting user details
    static testMethod void getUserDetailsTest() {
        
        // Data creation
        User user = DeviceExpToCustomerController_Test.createUser1();
        String acctId = getAccount('MYTEST ACCOUNT1').id;
        String oppId = DeviceExpToCustomerController_Test.createOpp(acctId);
        String oppProgId = DeviceExpToCustomerController_Test.createOppProg(acctId, oppId);
        
        Opportunity_Program_Team_Member__c oppProgTM = DeviceExpToCustomerController_Test.createOppProgTmMem(oppProgId, user.id);
        
        Test.startTest();
        // Opportunity Program Team Member with a team role as FAE
        DeviceExpToCustomerController devExp = new DeviceExpToCustomerController();
        devExp.oppProgId = oppProgId;
        String usrDetails = devExp.getFaeDetail();
        
        // Opportunity Program Team Member with a team role not as FAE
        oppProgTM.Team_Role__c = 'Customer Service Rep';
        update oppProgTM;
        usrDetails = devExp.getFaeDetail();
        system.assert(usrDetails==EnvironmentVariable.get('NO_OPP_PROG_FAE_INFO'));
        Test.stopTest();
        
    }
    
    // test method for getting user details
    static testMethod void getTargetIdTest() {
        
        // Data creation
        User user = DeviceExpToCustomerController_Test.createUser1();
        String acctId = getAccount('MYTEST ACCOUNT1').id;
        String oppId = DeviceExpToCustomerController_Test.createOpp(acctId);
        String oppProgId = DeviceExpToCustomerController_Test.createOppProg(acctId, oppId);
        Test.startTest();
        String deviceId = DeviceExpToCustomerController_Test.createDevice(oppProgId);
        DeviceExpToCustomerController_Test.createIpDec(deviceid);
        DeviceExpToCustomerController_Test.createExpCF(deviceId, acctId);
        Opportunity_Program_Team_Member__c oppProgTM = DeviceExpToCustomerController_Test.createOppProgTmMem(oppProgId, user.id);
        
        
        // Opportunity Program Team Member with a team role as FAE
        DeviceExpToCustomerController devExp = new DeviceExpToCustomerController();
        devExp.oppProgId = oppProgId;
        devExp.deviceId = deviceId;
        devExp.objectType = 'ECF';
        String returnUrl = devExp.getTargetId();
        
        
        // Opportunity Program Team Member with a team role not as FAE
        devExp.objectType = 'IDF';
        returnUrl = devExp.getTargetId();
        Test.stopTest();
        
    }
    
    private static Account getAccount(string AccountName)
    {
        Account acct = [SELECT Id, Name FROM Account Where Name =: AccountName];
        
        return acct;
    }
}