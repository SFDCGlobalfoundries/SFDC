/*
    Author: Anirban Roy
    Description: This is the test class for IPDeclarationSyncScheduler and IPDeclarationSyncBatch classes. 
    History:
        ARoy        12062013    - code creation.
        Vijay       16012015    - Updated the Device Stage 'Solutioning' to 'Design In' as Device will be created in 
                                  'Design In' directly and added mandatory fields.
*/
@isTest(SeeAllData=false)
public class IPDeclarationSyncSchedulerTest {
   @testSetup static void testdata() {
        DataUtilTest.loadEnvironmentVariables();
        
        Map<String,Object> fieldValueMap = new Map<String,Object>();
        fieldValueMap.put('Name', 'MYTEST ACCOUNT1');            
        fieldValueMap.put('IP_Declaration_Template__c', 'IP_Decl_Cust01');        
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
        String acctId = getAccount('MYTEST ACCOUNT1').id;
        Test.startTest();
        String conId = IPDeclarationSyncSchedulerTest.createContact(acctId);
        String oppId = IPDeclarationSyncSchedulerTest.createOpp(acctId);
        String oppProgId = IPDeclarationSyncSchedulerTest.createOppProg(acctId, oppId);        
        Test.stopTest();
    }
    
    //Retrieve Users
    static List<User> retrieveUserList(){
        List<User> usrList = [select id,name,email,IsActive  from User where profileId in (select id from Profile where Name in ('GF FAE/FTS','GF FE')) limit 10];
        return usrList;
    }  
    static Id createMaskSetTitle(){
        Map<String,Object> fieldValueMap = new Map<String,Object>();
        fieldValueMap.put('Name','MSTTRT1');
        fieldValueMap.put('Reticle_Type__c','Multi Layer Reticle (MLR)');
        return MaskSetTitleDataFactory.createMaskSetTitle(fieldValueMap).Id;
    }
    
    public static Device__c createCMPWDevice(Id acctId,Id opptyProgramId) {
        String MSTId = CreateMaskSetTitle();
        string MSTAccId = DeviceUtilTest.createMSTAccount(acctId,MSTId);
        // Create Device
        Map<String,Object> fieldValueMap = new Map<String,Object>();
        fieldValueMap.put('Account__c',acctId);
        fieldValueMap.put('Name','TESTDEVICEZAIH12345677');
        fieldValueMap.put('Opportunity_Program__c',opptyProgramId);
        fieldValueMap.put('Fab__c','FAB 2');
        fieldValueMap.put('GSOP_Assignment_Tapeout_Plan__c','No');
        fieldValueMap.put('Market_Segment__c','Automotive');
        fieldValueMap.put('Semiconductor_Device__c','Analog Amplifier');
        fieldValueMap.put('End_Customer__c','Test Customer');
        fieldValueMap.put('Device_Sourcing__c','1st Source');
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
        return DeviceDataFactory.createDevice(fieldValueMap);
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
    static List<Opportunity_Program_Team_Member__c> createOppProgTmMem1(Id oppProgId, List<User> userList){
        List<Opportunity_Program_Team_Member__c> opptmList = new List<Opportunity_Program_Team_Member__c>();
        
        for(User u : userList){
            Opportunity_Program_Team_Member__c oppProgTM = new Opportunity_Program_Team_Member__c(Core_Team_Member__c=false,
                                            Device_Access__c='Read/Write',Opportunity_Program_Access__c='Read/Write',
                                            Opportunity_Program__c=oppProgId,Team_Role__c='Field Application Engineer',
                                            User__c=u.Id,Flag_for_Delete__c=false);
            opptmList.add(oppProgTM);    
        }
            
        insert opptmList;
               
        return opptmList;
        
    }    
    
    
    static IP_Declaration_Form__c createIpDecForm1(Id testDeviceId) {
        // Create IP_Declaration_Form
        IP_Declaration_Form__c ipDecForm = new IP_Declaration_Form__c();
        ipDecForm.Device__c = testDeviceId;
        ipDecForm.Status__c = 'Draft';
        ipDecForm.Manual_Submission_Required__c = true;
        ipDecForm.Email_Address__c = 'test@test.comx';
        ipDecForm.OwnerId__c = UserInfo.getUserId();
        
        insert ipDecForm;
               
        return ipDecForm;
        
        
    }    
    
    static Process_Technology__c createPT(){
        Process_Technology__c pt = new Process_Technology__c();
        pt.Name = 'TestPT';
        pt.IP_Geometry_Technology__c = '28G;28LPE'; 
        insert pt;
        return pt;   
    }
        
    
    static testMethod void updateIPDecSyncTest(){
         List<User> userList = [select id,isactive,name,email from User where isactive = true and profile.Name in ('GF FAE/FTS','GF FE') limit 10];  
        //List<User> userList = IPDeclarationSyncSchedulerTest.retrieveUserList();
        String acctId = getAccount('MYTEST ACCOUNT1').id;
        string conId = [Select Id, name from Contact where Email='con1@gf.com'].id;
        string oppId = [Select Id, Name from Opportunity where Name='Win Test Opportunity 12345'].id;
        string oppProgId = [Select Id, name from Opportunity_Program__c where Name='Win Test OppProg 12345'].id;
        List<Opportunity_Program_Team_Member__c> oppProgTM = IPDeclarationSyncSchedulerTest.createOppProgTmMem1(oppProgId, userList);  
        Process_Technology__c pt = IPDeclarationSyncSchedulerTest.createPT();
        
             
             
        Test.startTest();
        Device__c Device = createCMPWDevice(acctId,oppProgId);
        
        Device.Send_for_Integration__c=false;
        update device;
        IP_Declaration_Form__c ipDecForm = IPDeclarationSyncSchedulerTest.createIpDecForm1(Device.Id);
          
          ipDecForm.Status__c='Reassigned';
          update ipDecForm;
          
          ipDecForm.Status__c='Recalled';
          update ipDecForm;
                 
        DateTime currTime = DateTime.now();
        Integer min = currTime.minute();
        Integer hour = currTime.hour();
        Integer second = currTime.second();
        String sch = second+' '+min+' '+'* * * ? '+ currTime.year();
        
              
        IPDeclarationSyncScheduler obj = new IPDeclarationSyncScheduler();                
        String jobId = system.schedule('test', sch, obj);        
        CronTrigger ct = [SELECT id, CronExpression, TimesTriggered, NextFireTime FROM CronTrigger where id = :jobId];        
        System.assertEquals(sch, ct.CronExpression);                                      
        database.executeBatch(new IPDeclarationSyncBatch());   
        
        Test.stopTest();
    }
    
    private static Account getAccount(string AccountName)
    {
        Account acct = [SELECT Id, Name FROM Account Where Name =: AccountName];
        
        return acct;
    }
}