/*
    Author: Anirban Roy
    Description: This is the test class for the CPConfigAppBckTrckController class.
    History: 
        ARoy      11192015    - Code creation.
*/

@isTest(SeeAllData=false)
public class CPConfigAppBckTrckControllerTest {
    @testSetup
     static void testDataSetup(){
        IntegrationUsers__c intsetting = IntegrationUsers__c.getInstance();
        intsetting.Is_Integration_User__c = true;
        intsetting.Skip_Trigger__c=true;
        intsetting.Skip_Validation_Rule__c = true;
        insert intsetting;
        
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
            fieldValueMap.put('recordtypeid', EnvironmentVariable.get('ACCT_RT_ID_CUSTOMER'));
         
            AccountDataFactory.createAccount(fieldValueMap);
    
    }
     static Id createMaskSetTitle(){
        Map<String,Object> fieldValueMap = new Map<String,Object>();
        fieldValueMap.put('Name','MSTTRT1');
        fieldValueMap.put('Reticle_Type__c','Single Layer Reticle (SLR)');
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
    
    // Test method for Configurator Plus Backtrack process with Approval Stage = 'Configuration Design Phase'
    static testMethod void configPlusBacktrackTestMethod1() {
        
        system.debug('%%%hierarachy \n\n' + IntegrationUsers__c.getInstance().Skip_Trigger__c);
        //Create records for Configurator Plus Backtrack
        //BPMConfigurationPlusIntegration.hasRun = true;
        //Setup the test records required to create the Proposal test record
        RecordType recType = [Select Id
                                From RecordType 
                               Where Name='Multi Source Proposal from Device' And
                                     SobjectType = 'Apttus_Proposal__Proposal__c'];
        
        Account acc = getAccount('MYTEST ACCOUNT1');
        
        Opportunity opp = createOpp(acc.Id);
        
        Opportunity_Program__c oppProg = createOppProg(acc.Id,opp.Id);
        
        Process_Technology__c TestPT = createPT(); 
        
        Test.startTest();
            Device__c dev = createCMPWDevice(acc.Id,oppProg.Id);
        
            Apttus_Proposal__Proposal__c ConfigPlusRec = createConfiguratorPlus(recType,acc,dev,TestPT);        
            Approval.ProcessSubmitRequest req = new Approval.ProcessSubmitRequest();
            req.setComments('submit for approval');
            req.setObjectId(ConfigPlusRec.Id); 
        
            //Approval.Processresult result = Approval.process(req);        
            ApexPages.currentPage().getParameters().put('id',String.valueOf(ConfigPlusRec.Id));
              
            /*ConfigPlusRec.Apttus_Proposal__Approval_Stage__c = 'Configuration Design Phase';
            ConfigPlusRec.Initial_Submitter__c = UserInfo.getUserId();
            update ConfigPlusRec;*/ 
            Test.stopTest();
            //Backtrack functionality test
            CPConfigAppBckTrckController cpBackTrack = new CPConfigAppBckTrckController();
            //cpBackTrack.submitRequest(ConfigPlusRec.id, 'submit', UserInfo.getUserId());
            PageReference pgr = cpBackTrack.init();
            
            //Cancel functionality test
            pgr = cpBackTrack.cancel();
        
    }
    
    // Test method for Configurator Plus Backtrack process with Approval Stage = 'Process Accepted Phase'
    static testMethod void configPlusBacktrackTestMethod2() {
        
        //Create records for Configurator Plus Backtrack
        //BPMConfigurationPlusIntegration.hasRun = true;
        //Setup the test records required to create the Proposal test record
        RecordType recType = [Select Id
                                From RecordType 
                               Where Name='Draft' And
                                     SobjectType = 'Apttus_Proposal__Proposal__c'];
        
        Account acc = getAccount('MYTEST ACCOUNT1');
        
        Opportunity opp = createOpp(acc.Id);
        
        Opportunity_Program__c oppProg = createOppProg(acc.Id,opp.Id);
        
        Process_Technology__c TestPT = createPT(); 
        
        Test.startTest();
        Device__c dev = createCMPWDevice(acc.Id,oppProg.Id);
        
            Apttus_Proposal__Proposal__c ConfigPlusRec = createConfiguratorPlus(recType,acc,dev,TestPT);
           
            Approval.ProcessSubmitRequest req = new Approval.ProcessSubmitRequest();
            req.setComments('submit for approval');
            req.setObjectId(ConfigPlusRec.Id); 
        
            //Approval.Processresult result = Approval.process(req);        
            ApexPages.currentPage().getParameters().put('id',String.valueOf(ConfigPlusRec.Id));
                
            ConfigPlusRec.Apttus_Proposal__Approval_Stage__c = 'Process Accepted Phase';
            update ConfigPlusRec; 
           Test.stopTest(); 
            //Backtrack functionality test
            CPConfigAppBckTrckController cpBackTrack = new CPConfigAppBckTrckController();
            PageReference pgr = cpBackTrack.init();
            
        
    }
    
     // Test method for Configurator Plus Backtrack process with Approval Stage = 'Package Accepted Phase'
    static testMethod void configPlusBacktrackTestMethod3() {
        
        //Create records for Configurator Plus Backtrack
        //BPMConfigurationPlusIntegration.hasRun = true;
        //Setup the test records required to create the Proposal test record
        RecordType recType = [Select Id
                                From RecordType 
                               Where Name='Draft' And
                                     SobjectType = 'Apttus_Proposal__Proposal__c'];
        
        Account acc = getAccount('MYTEST ACCOUNT1');
        
        Opportunity opp = createOpp(acc.Id);
        
        Opportunity_Program__c oppProg = createOppProg(acc.Id,opp.Id);
        
        Process_Technology__c TestPT = createPT(); 
            
        Test.startTest(); 
        Device__c dev = createCMPWDevice(acc.Id,oppProg.Id);
        
         
            Apttus_Proposal__Proposal__c ConfigPlusRec = createConfiguratorPlus(recType,acc,dev,TestPT);
                
            Approval.ProcessSubmitRequest req = new Approval.ProcessSubmitRequest();
            req.setComments('submit for approval');
            req.setObjectId(ConfigPlusRec.Id);
            //Approval.Processresult result = Approval.process(req);        
            ApexPages.currentPage().getParameters().put('id',String.valueOf(ConfigPlusRec.Id));
                
            ConfigPlusRec.Apttus_Proposal__Approval_Stage__c = 'Package Accepted Phase';
            update ConfigPlusRec; 
            Approval.lockResult lockedRersult = Approval.lock(ConfigPlusRec);
        	CPConfigAppBckTrckController cpBackTrack1 = new CPConfigAppBckTrckController();
        	cpBackTrack1.configId = ConfigPlusRec.Id;
        	PageReference pgr1 = cpBackTrack1.init();
           Test.stopTest(); 
            //Backtrack functionality test
            CPConfigAppBckTrckController cpBackTrack = new CPConfigAppBckTrckController();
            PageReference pgr = cpBackTrack.init();
          try{
              String x = null;
                x.toLowerCase();
            }catch(Exception e){
                CPConfigAppBckTrckController.postExceptionToCPQTeam(ConfigPlusRec, e);
            }
        
    }
    
    
    
    //Static method to create Configurator Plus  test record
    static Apttus_Proposal__Proposal__c createConfiguratorPlus(RecordType recType,Account acc,Device__c dev,Process_Technology__c PTNumber){        
        
        //Create a proposal from Device
        Apttus_Proposal__Proposal__c ConfiguratorPlus = 
                    new Apttus_Proposal__Proposal__c(Apttus_Proposal__Description__c = 'Test Proposal Description ...',
                                                     //Mask_Set__c = 'AB,CD, DA',
                                                     //changed reference of Mask_Set__c to Mask_Set_Long__c for the Case#00051463
                                                     Multi_Source_Tapeout_Approval_Stage__c = 'Approved',
                                                     Mask_Set_Long__c = 'AB,CD, DA',
                                                     RecordTypeId = recType.Id ,
                                                     Process_Technology_Lookup__c = PTNumber.id,
                                                     Device__c = dev.id,
                                                     Apttus_Proposal__Account__c = acc.id
                                                     );
        
        insert ConfiguratorPlus;
        return ConfiguratorPlus;
    }
    
    //static method to create process technology
    static Process_Technology__c createPT(){
      Process_Technology__c TempPT = new Process_Technology__c(Name = 'PTXXX01' , PT_Number__c='PTXXX01');
      insert TempPT;
      return TempPT ; 
    }
    
     
    
    //Static method to create Opportunity test record
    static Opportunity createOpp(Id acctId){
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
         
        return OpportunityDataFactory.createOpportunity(fieldValueMap);               
    }
    
    //Static method to create Opportunity Program test record
    static Opportunity_Program__c createOppProg(Id acctId, Id oppId){
        Opportunity_Program__c opProg = 
                    new Opportunity_Program__c(Name = 'Test OppProg',
                                               Account__c = acctId,
                                               Opportunity__c = oppId);
        insert opProg;
        return opProg;
    }
    
    //Static method to create Device test record
    /*static Device__c createDevice(Id accId, Id oppId, Id oppProgId){
        Device__c dev = new Device__c(Name = 'TESTDEVICE1313',
                                      Stage__c = 'Design In',
                                      Status__c = 'Active',
                                      Account__c = accId,
                                      Opportunity2__c = oppId,
                                      Opportunity_Program__c = oppProgId,
                                      Market_Segment__c = 'Automotive',
                                      Semiconductor_Device__c = 'Analog Regulator',
                                      End_Application__c = 'Body',
                                      Device_Sourcing__c = '3rd Source',
                                      Tapeout_Type__c = 'Customer MPW',
                                      Siebel_Device_ID__c = '0987654321',
                                      IP_Gap__c = false,
                                      Requested_from_Configuration__c = true, 
                                      Actual_Tapeout_Date__c = date.newInstance(2013,5,20),
                                      Forecasted_Lot_Start_Date__c = date.newInstance(2013,5,20),
                                      Original_Forecasted_Tapeout_Date__c = date.newInstance(2013,5,20),
                                      Current_Forecast_Tapeout_Date__c = date.newInstance(2013,3,4),
                                      Confidence_Level_Tapeout__c = '100',
                                      IP_Declaration_User_Ids__c = userinfo.getuserid() ,
                                      Fab__c = 'Fab 3');
        insert dev;
        return dev; 
    }*/
    
    private static Account getAccount(string AccountName)
    {
        Account acct = [SELECT Id, Name FROM Account Where Name =: AccountName];
        
        return acct;
    }
}