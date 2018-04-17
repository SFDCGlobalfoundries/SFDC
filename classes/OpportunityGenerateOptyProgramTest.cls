/*
    Author: Zymark Ambat
    Description: This serves as the test class for the OpportunityGenerateOptyProgram Trigger.
    History: 
        ZAmbat      02272013    - Code creation.
        NBustillos  02282013    - added logic on creation of Opportunity Program, Device, Device Forecast and Quarterly Revenue.
        Vijay       16012015    - Updated the Device Stage 'Solutioning' to 'Design In' as Device will be created in 
                                  'Design In' directly and added mandatory fields.
*/
@isTest(SeeAllData=false)
public class OpportunityGenerateOptyProgramTest {
    @testSetup static void testdata() {
        DataUtilTest.loadEnvironmentVariables();
        
        List<Map<String,Object>> fieldValueMapList = new List<Map<String,Object>>();
        for(integer i=1;i<=2;i++){
            Map<String,Object> fieldValueMap = new Map<String,Object>();
            fieldValueMap.put('Name', 'MYTEST ACCOUNT'+i);            
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
            
            fieldValueMapList.add(fieldValueMap);
        }
        AccountDataFactory.createAccounts(fieldValueMapList,2);
                   
    }       
    
    static Opportunity createOpportunity1(Id testAcctId) {
        // Create Opportunity
        Map<String,Object> fieldValueMap = new Map<String,Object>();
        fieldValueMap.put('AccountId',testAcctId);
        fieldValueMap.put('Name','Test Opportunity 1');  
        fieldValueMap.put('StageName','1. Discovery');
        fieldValueMap.put('CloseDate',Date.Today().addDays(10));  
        fieldValueMap.put('Target_Process_Node__c','14XM');
        fieldValueMap.put('Market_Segment__c','Mobility');  
        fieldValueMap.put('Process_Platform__c','GF Baseline');
        fieldValueMap.put('Fab_Split__c',100);          
        fieldValueMap.put('Process_Geometry__c','0.028UM');  
        fieldValueMap.put('Process_Family__c','Generic / Nominal');        
        fieldValueMap.put('Fab_Assignment_1__c','FAB 3');
        fieldValueMap.put('Opportunity_Sourcing_Type__c','First Source');
        fieldValueMap.put('FAE_CP2__c',True);
        fieldValueMap.put('FAE_CP3__c',True); 
        Opportunity testOppty = OpportunityDataFactory.createOpportunity(fieldValueMap);
                
        testOppty.StageName = '2. Assessment';//added by sunita
        
       // testOppty.StageName = '2. Assessment';//added by sunita
       // Update testOppty;//added by sunita
        return testOppty;
    }   
    
    static Opportunity_Program__c createOpportunityProgram(Id testAcctId, Id testOpptyId) {
        // Create Opportunity Program
        Opportunity_Program__c testOpptyProgram = new Opportunity_Program__c();
        testOpptyProgram.Name = 'Test Opportunity 1';
        testOpptyProgram.Account__c = testAcctId;
        testOpptyProgram.Opportunity__c = testOpptyId;
        
        Insert testOpptyProgram;
        
        return testOpptyProgram;
    }
    
    static Device__c createDevice(Id testOpptyProgramId) {
        // Create Device
        Map<String,Object> fieldValueMap = new Map<String,Object>();
        fieldValueMap.put('Name','TEST'+testOpptyProgramId); 
        fieldValueMap.put('Stage__c','Design In'); 
        fieldValueMap.put('Status__c','Active'); 
        fieldValueMap.put('Opportunity_Program__c',testOpptyProgramId); 
        fieldValueMap.put('Market_Segment__c','Mobility'); 
        fieldValueMap.put('Semiconductor_Device__c','Analog Regulator'); 
        fieldValueMap.put('End_Application__c','Body'); 
        fieldValueMap.put('Device_Sourcing__c','1st Source'); 
        fieldValueMap.put('Tapeout_Type__c','Customer MPW'); 
        fieldValueMap.put('Fab__c','Fab 3');
        fieldValueMap.put('GSOP_Assignment_Tapeout_Plan__c','No');
        fieldValueMap.put('End_Customer__c','Test Customer');
        fieldValueMap.put('Original_Forecasted_Tapeout_Date__c',System.today());
        fieldValueMap.put('Enabled_via_previous_MPW_1__c','No');
        fieldValueMap.put('Confidence_Level_Tapeout__c','100');
        return DeviceDataFactory.createDevice(fieldValueMap);
    }
    
    static id createOpptyProgGap(Id testOpptyProgramId , id testOpptyId ){
    
       Device_Gap__c gap = new Device_Gap__c();
       gap.Opportunity_Program__c = testOpptyProgramId; 
       gap.Opportunity__c=testOpptyId ;
       gap.Select_Status__c = 'B - Major Issue Closed';
       gap.Gap_Type__c = 'Price / Cost';
       gap.Area__c = 'Price';
        insert gap;
        return gap.id;
    }
    
    static id createEDAReq(Id testOpptyProgramId){
        EDA_Requirement__c eda = new EDA_Requirement__c(Opportunity_Program__c = testOpptyProgramId);
        insert eda;
        return eda.id;
    }
    
    static testMethod void testOpptyVoidStage() {
        
        insert new Error_Codes__c(Name = 'CONFIG_STAGE_VALIDATION_MSG', Message__c = 'Process Flow Accepted');
        User thisUser= DeviceChecklistTestDataUtils.createUserWithDCAdmin('System Administrator');
        system.runas(thisUser){
            IntegrationUsers__c skipUser = new IntegrationUsers__c(SetupOwnerId = thisUser.Id, Is_Integration_User__c= true, Skip_Trigger__c = true, Skip_Validation_Rule__c = true);
            insert skipUser; 
            Account acct = getAccount('MYTEST ACCOUNT1');
            Test.startTest();
            Opportunity oppty = OpportunityGenerateOptyProgramTest.createOpportunity1(acct.id);
            oppty.StageName = '2. Assessment';//added by sunita
            update oppty;//added by sunita
            Opportunity_Program__c opptyPgm =  createOpportunityProgram(acct.id, oppty.id);
            
            Device__c dev = createDevice(opptyPgm.id);
            
            
            createOpptyProgGap(opptyPgm.id,oppty.id);
            createEDAReq(opptyPgm.id);
            dev.Status__c = 'Inactive';
            dev.Reticle_Type__c = 'Single Layer Reticle (SLR)';
            update dev;
            oppty.StageName = '10. Void';
            oppty.Design_Win_Review_Status__c = null;
            update oppty;
            
            Test.stopTest();            
        }        
    }
    
    static testMethod void testOpptyAcctidChange() {
        
        insert new Error_Codes__c(Name = 'CONFIG_STAGE_VALIDATION_MSG', Message__c = 'Process Flow Accepted');
        User thisUser= DeviceChecklistTestDataUtils.createUserWithDCAdmin('System Administrator');
        system.runas(thisUser){
            IntegrationUsers__c skipUser = new IntegrationUsers__c(SetupOwnerId = thisUser.Id, Is_Integration_User__c= true, Skip_Trigger__c = true, Skip_Validation_Rule__c = true); 
            insert skipUser;      
            Test.startTest();
            Opportunity oppty = OpportunityGenerateOptyProgramTest.createOpportunity1(getAccount('MYTEST ACCOUNT1').id);
            oppty.StageName = '2. Assessment';
            update oppty;
            Opportunity_Program__c opptyPgm =  createOpportunityProgram(getAccount('MYTEST ACCOUNT1').id, oppty.id);
            
            Device__c dev = createDevice(opptyPgm.id);
            User usr = [select id from user where profile.name = 'System Administrator' and isactive = true limit 1];
            system.runas(usr){
                
                
                oppty.AccountId = getAccount('MYTEST ACCOUNT2').id;
                try{
                    update oppty;
                }catch(exception ex){
                    //system.assertEquals(ex.getMessage(), 'Opportunity account cannot change as device record already exists in Opportunity Program.');
                }
                
                Test.stopTest();
            }
        }
    }
    
     static testMethod void testOpptyPrivateChange() {
         User thisUser= DeviceChecklistTestDataUtils.createUserWithDCAdmin('System Administrator');
        system.runas(thisUser){
            IntegrationUsers__c skipUser = new IntegrationUsers__c(SetupOwnerId = thisUser.Id, Is_Integration_User__c= true, Skip_Trigger__c = true, Skip_Validation_Rule__c = true);
            insert skipUser;
            Account acct = getAccount('MYTEST ACCOUNT1');
            Test.startTest();
            Opportunity oppty = OpportunityGenerateOptyProgramTest.createOpportunity1(acct.id);
            oppty.StageName = '2. Assessment';
            update oppty;
            Opportunity_Program__c opptyPgm =  createOpportunityProgram(acct.id, oppty.id);
            
            
            oppty.IsPrivate = true;
            update oppty;
            
            Test.stopTest();
        }
    }
    
    
    /*static testMethod void OpportunityGenerateOptyProgram1() {
        
        list<user> lstUsers = [select id from user where profile.name = 'System Administrator' and isactive = true limit 2];
        
        system.runAs(lstUsers.get(0)){
            // Create dummy records for testing
            Account acct = getAccount('MYTEST ACCOUNT1');
            Opportunity oppty = OpportunityGenerateOptyProgramTest.createOpportunity1(acct.id);
            
            // Change to Assessment Stage
            oppty.StageName = '2. Assessment';
            oppty.X1st_Product_Production_Date__c = Date.newInstance(2011, 1, 1);
            oppty.Years_of_Production__c = 2;
            oppty.Create_Program__c = true;
            oppty.Process_Geometry__c='0.045UM';
            oppty.Process_Family__c='SOI';
            Update oppty;
            
            list<Opportunity_Program__c> lstOptyProgram = [select id from Opportunity_Program__c where Opportunity_ID_Key__c = :oppty.id];
            system.assertEquals((lstOptyProgram.size()>0),true);
           
            // Create Account TeamProxy
            list<Account_Team_Proxy__c> lstATP = new list<Account_Team_Proxy__c>();
            lstATP.add(new Account_Team_Proxy__c(Account__c=acct.id,User__c=lstUsers.get(1).Id,Team_Role__c='Pricing',Opportunity_Access__c='Read/Write',Account_Access__c='Read/Write'));
            insert lstATP;
            
                         
            Account_Team_Proxy__c atpUpdate = lstATP.get(0);
            atpUpdate.Opportunity_Access__c = 'Read Only';
            update atpUpdate; 
             test.startTest();
            // Create Devices
            Device__c objDevice = new Device__c(Name='TESTDEVICE1',Account__c=acct.id,Opportunity_Program__c=lstOptyProgram.get(0).id,CRMDID__c='CDID12345567.00',Tapeout_Type__c='Single Product',Device_Sourcing__c = 'First Source',End_Application__c= 'XYX',Market_Segment__c = 'Consumer',Confidence_Level_Tapeout__c='100',Fab__c='FAB 2',Semiconductor_Device__c='XXX',Enabled_via_previous_MPW_1__c ='No',Original_Forecasted_Tapeout_Date__c=system.today());
            insert objDevice;
            
            list<Device_Forecast__c> lstDeviceForecast = new list<Device_Forecast__c>();
            lstDeviceForecast.add(new Device_Forecast__c(ASP__c=1000,Quantity__c=5,Fiscal_Quarter__c='2011-Q1',Device__c=objDevice.id));
            lstDeviceForecast.add(new Device_Forecast__c(ASP__c=1000,Quantity__c=5,Fiscal_Quarter__c='2011-Q2',Device__c=objDevice.id));
            lstDeviceForecast.add(new Device_Forecast__c(ASP__c=1000,Quantity__c=5,Fiscal_Quarter__c='2011-Q3',Device__c=objDevice.id));
            lstDeviceForecast.add(new Device_Forecast__c(ASP__c=1000,Quantity__c=5,Fiscal_Quarter__c='2011-Q4',Device__c=objDevice.id));
            insert lstDeviceForecast;
            
            test.stopTest();
            
        }
        
        
    }*/
    
    private static Account getAccount(string AccountName)
    {
        Account acct = [SELECT Id, Name FROM Account Where Name =: AccountName];
        
        return acct;
    }
}