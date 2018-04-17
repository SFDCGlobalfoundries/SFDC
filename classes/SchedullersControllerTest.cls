/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an organization are executed whenever Apex code is deployed
 * to a production organization to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production organization. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@isTest(SEEALLDATA = false)
private class SchedullersControllerTest {
    
    static testMethod void testScheduler(){
        
       Test.startTest();
       
       Retry_Logic__c retry = new Retry_Logic__c(
           name = 'Defaults',
           log__c = 'Last Run :2013-10-16 14:29:20',
           MaxRecordsPerObject__c = 10,
           MinutesToResendRecord__c = 598,
           time_to_recall__c = 600
       );
           
       insert retry;
       
       // Load Environment Variables   
       DataUtilTest.loadEnvironmentVariables();
       
       //==============Test Data Creation======================//
       List<Account> accts = new List<Account>();
       Account acc = new Account(Name='Test Account1111',Site_Department__c='IT',Sub_Type__c='Indirect',
                                Transaction_Type__c='Non-Transactional',Region__c='US',Bill_To_Address_1__c='Test Address',
                                Bill_To_City__c='Test City',Bill_To_Country__c='India',Corporate_Address_1__c='Test Address',
                                Corporate_City__c='Test City',Corporate_Country__c='India');           
       
       Account acc2 = new Account(Name='Test Account2222',Site_Department__c='IT',Sub_Type__c='Indirect',
                                Transaction_Type__c='Non-Transactional',Region__c='US',Bill_To_Address_1__c='Test Address',
                                Bill_To_City__c='Test City',Bill_To_Country__c='India',Corporate_Address_1__c='Test Address',
                                Corporate_City__c='Test City',Corporate_Country__c='India');             
       
       accts.add(acc);
       accts.add(acc2);
       insert accts;
       
       acc.ParentId = acc2.Id;
       update acc;
       
       Account_Hierarchy__c ah = [select Parent_Id__c, Master_Account_Id__c, Martinistore_Sync_Status__c from Account_Hierarchy__c where Account_Id__c = :acc.Id LIMIT 1];
       ah.Martinistore_Sync_Status__c = 'ERROR';
       update ah;
                     
       Account acc1 = [select Siebel_Sync_id__c, Siebel_Status__c, Martinistore_Sync_Status__c from Account where id = :acc.Id];
       acc1.Martinistore_Sync_Status__c = 'ERROR'; 
       acc1.Siebel_Sync_id__c  = String.valueof(System.now());   
       acc1.Siebel_Status__c = 'SENT';
       acc1.Siebel_Account_ID__c = '007007001';
       update acc1;              
       
       Test.stopTest();
       
       //=========================================================//
       // Schedule the test job 
       Schedulers s = new Schedulers();  
       String CRON_EXP = '0 0 0 3 9 ? 2022';
         
       String jobId = System.schedule('testBasicScheduledApex',CRON_EXP, s  );
       
       // Get the information from the CronTrigger API object 
       CronTrigger ct = [SELECT Id, CronExpression, TimesTriggered, 
             NextFireTime
             FROM CronTrigger WHERE id = :jobId];
    
       // Verify the expressions are the same       
       System.assertEquals(CRON_EXP,ct.CronExpression);
    
       // Verify the job has not run        
       System.assertEquals(0, ct.TimesTriggered);
    
       // Verify the next time the job will run     
       System.assertEquals('2022-09-03 00:00:00',String.valueOf(ct.NextFireTime));         

  }
     
    static testMethod void testScheduler2(){
        
       //Test.startTest();
       
       Retry_Logic__c retry = new Retry_Logic__c(
           name = 'Defaults',
           log__c = 'Last Run :2013-10-16 14:29:20',
           MaxRecordsPerObject__c = 10,
           MinutesToResendRecord__c = 598,
           time_to_recall__c = 600
       );
       
       insert retry;       
       
       // Load Environment Variables   
       DataUtilTest.loadEnvironmentVariables();
       
       List<Account> accts = new List<Account>();
       Account acc = new Account(Name='Test Account1111',Site_Department__c='IT',Sub_Type__c='Indirect',
                                Transaction_Type__c='Non-Transactional',Region__c='US',Bill_To_Address_1__c='Test Address',
                                Bill_To_City__c='Test City',Bill_To_Country__c='India',Corporate_Address_1__c='Test Address',
                                Corporate_City__c='Test City',Corporate_Country__c='India');           
       
       Account acc2 = new Account(Name='Test Account2222',Site_Department__c='IT',Sub_Type__c='Indirect',
                                Transaction_Type__c='Non-Transactional',Region__c='US',Bill_To_Address_1__c='Test Address',
                                Bill_To_City__c='Test City',Bill_To_Country__c='India',Corporate_Address_1__c='Test Address',
                                Corporate_City__c='Test City',Corporate_Country__c='India');             
       
       accts.add(acc);
       accts.add(acc2);
       insert accts;
       
       //==============Test Data Creation======================//                                          
       Opportunity opp = new Opportunity(Name='Test Opportunity1111',AccountId=acc.Id,StageName='1. Discovery',Market_Segment__c='Automotive',
                                        Target_Process_Node__c='14XM',Process_Platform__c='GF Baseline',Opportunity_Sourcing_Type__c='First Source',
                                        Fab_Split__c=100,CloseDate = date.newinstance(2012, 12, 21),Process_Geometry__c='0.014UM',
                                        Fab_Assignment_1__c = 'FAB 1',
                                        Process_Family__c = 'Super Low Power');
       
       insert opp;
       
       Opportunity opp1 = [select Siebel_Sync_id__c, Siebel_Status__c from Opportunity where id = :opp.Id];    
       opp1.Siebel_Sync_id__c = String.valueOf(System.now());
       opp1.Siebel_Status__c = 'SENT';      
       update opp1;
       
       Opportunity_Program__c opProg = new Opportunity_Program__c(Name='Test OppProg',Account__c=acc.Id,Opportunity__c=opp1.Id);
       insert opProg;              
       
       Opportunity_Program_Team_Member__c optm1 = new Opportunity_Program_Team_Member__c();
       optm1.Opportunity_Program__c = opProg.Id;
       optm1.User__c = [SELECT Id FROM User WHERE IsActive=true AND Profile.Name = 'System Administrator' LIMIT 1].Id;
       optm1.Team_Role__c = 'Field Application Engineer';
       optm1.Opportunity_Program_Access__c = 'Read/Write';
       optm1.Device_Access__c = 'Read/Write';
       optm1.Martinistore_Sync_Status__c = 'SENT';
       Test.startTest(); 
       insert optm1;
       
       Device__c dev = new Device__c(Name = 'TESTDEVICE1313', Stage__c = 'Design In', Status__c = 'Active', Account__c = acc.Id,
                                    Opportunity2__c = opp1.Id, Opportunity_Program__c = opProg.Id,Market_Segment__c = 'Automotive',
                                    Semiconductor_Device__c = 'Analog Regulator',End_Application__c = 'Body',Device_Sourcing__c = '3rd Source',
                                    Tapeout_Type__c = 'Customer MPW', Siebel_Device_ID__c = '0987654321', IP_Gap__c = false,
                                    Actual_Tapeout_Date__c = date.newInstance(2013,5,20), Forecasted_Lot_Start_Date__c = date.newInstance(2013,5,20),
                                    Original_Forecasted_Tapeout_Date__c = date.newInstance(2013,5,20), 
                                    Current_Forecast_Tapeout_Date__c = date.newInstance(2013,3,4), Confidence_Level_Tapeout__c = '100',Fab__c = 'Fab 3');
       insert dev;
       
       Device__c dev1 = [select Siebel_Sync_id__c, Siebel_Status__c from Device__c where id = :dev.Id];
       dev1.Siebel_Sync_id__c = String.valueOf(System.now());
       dev1.Siebel_Status__c = 'SENT';      
       update dev1;
       
       Lot_Prefix__c lp = new Lot_Prefix__c(Account__c = acc.Id, Name = 'LPR1', Fab__c = 'FAB 3', Martinistore_Sync_Status__c = 'SENT');
       insert lp; 
       
       IP_Form_Matching_Result__c ipFormMatchRes = new IP_Form_Matching_Result__c(CRM_DID__c='Test_1234');
       insert ipFormMatchRes;
       
       IP_Form_Matching_Result__c ipFormMatchRes1 = [select Id, Martinistore_Sync_Status__c from IP_Form_Matching_Result__c where id = :ipFormMatchRes.Id];
       ipFormMatchRes1.MartiniStore_Sync_Status__c = 'ERROR';
       update ipFormMatchRes1;
             
       New_Part_Creation_Form__c npc = new New_Part_Creation_Form__c();
       npc.Account__c = acc.Id;
       npc.BASE_Device__c = dev.Id;
       npc.PLM_Sync_Status__c = 'SENT';
       npc.New_Part_ID__c = 'TESTNPC99999Z';
       insert npc;
       
       Test.stopTest();
                   
       //=========================================================//
       
       // Schedule the test job 
       Schedulers s = new Schedulers();  
       String CRON_EXP = '0 0 0 3 9 ? 2022';
         
       String jobId = System.schedule('testBasicScheduledApex',CRON_EXP, s  );
       
       // Get the information from the CronTrigger API object 
       CronTrigger ct = [SELECT Id, CronExpression, TimesTriggered, 
             NextFireTime
             FROM CronTrigger WHERE id = :jobId];
    
       // Verify the expressions are the same       
       System.assertEquals(CRON_EXP,ct.CronExpression);
    
       // Verify the job has not run        
       System.assertEquals(0, ct.TimesTriggered);
    
       // Verify the next time the job will run     
       System.assertEquals('2022-09-03 00:00:00',String.valueOf(ct.NextFireTime));         

  }                 
}