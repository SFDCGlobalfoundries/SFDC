@isTest(seeAllData=false)
public class Device_TriggerHelperTest3 {
  @testSetup static void testdata() {
    DataUtilTest.loadEnvironmentVariables();
  }

  static testmethod void testEnvironmentVariable(){
        User thisUser= DeviceChecklistTestDataUtils.createUserWithDCAdmin('System Administrator');
        System.runAs(thisUser){
            IntegrationUsers__c skipUser = new IntegrationUsers__c(SetupOwnerId = thisUser.Id, Is_Integration_User__c= true, Skip_Trigger__c = true, Skip_Validation_Rule__c = true);
            insert skipUser;
            
            Environment_Variable__c env = [SELECT id FROM Environment_Variable__c WHERE Name=:'BPM_isActive'];//new Environment_Variable__c(name='BPM_isActive', Value__c ='TRUE');
            env.value__c = 'TRUE';
            update env; 
           
            Map<String,Object> fieldValueAccMap = new Map<String,Object>();
            Account account1 = AccountDataFactory.createAccount(fieldValueAccMap);
            
            Map<String,Object> fieldValueOppMap = new Map<String,Object>();
            fieldValueOppMap.put('AccountId', account1.id);
            Opportunity opp1 = OpportunityDataFactory.createOpportunity(fieldValueOppMap);
         
            Map<String,Object> fieldValuepoppProgramMap1 = new Map<String,Object>();
            fieldValuepoppProgramMap1.put('Account__c',account1.id);
            fieldValuepoppProgramMap1.put('Opportunity__c',opp1.id);
            Opportunity_Program__c oppprogram = new Opportunity_Program__c();    
            oppprogram = OpportunityProgramDataFactory.createOpportunityProgram(fieldValuepoppProgramMap1);
            
            Map<String,Object> fieldValueOptionMap = new Map<String,Object>();   
            Customer_Requirement__c  opt1 = BNP_DataFactory.createOption(fieldValueOptionMap);
            system.debug('--opt1 --'+opt1.id );
            
            Map<String,Object> fieldValueMap1 = new Map<String,Object>();
            fieldValueMap1.put('Device_Sourcing__c','Sole Source');
            fieldValueMap1.put('Opportunity_Program__c',oppprogram.Id);
            fieldValueMap1.put('Primary_Option__c',opt1.Id);
            fieldValueMap1.put('Secure_Device__c','Yes');
            
            
            Device__c Dev1 = new Device__c ();
            Dev1 = DeviceDataFactory.createDevice(fieldValueMap1);
            set<id> devid= new set<id>();
            devid.add(Dev1.id);
            
            Test.startTest();
            Dev1.Product_TO_Date__c = System.today().addDays(1);
            Dev1.Forecasted_Production_Start_Date__c =  System.today().addDays(2);
            Dev1.Sample_Delivery_Date__c =  System.today().addDays(2);
            Dev1.Forecasted_Proto_Date__c =  System.today().addDays(3);
            Dev1.Forecasted_RTP_Date__c =  System.today().addDays(4);
            Dev1.Forecasted_Production_Start_Date__c = System.today().addDays(5);
            Dev1.Secure_Device__c = 'Yes';
            Dev1.BX041_Status__c = 'Pending Acknowledgement';
            BX_041__c bObj = new BX_041__c(Approver_1__c =thisUser.Id, Approver_2__c =thisUser.Id, Device__c =Dev1.Id);
            insert bObj;
            
            BX_041__c bObj1 = new BX_041__c(Approver_1__c =thisUser.Id, Approver_2__c =thisUser.Id, Device__c =Dev1.Id);
            insert bObj1;
           
            update Dev1 ;
           
          Test.stopTest();
      }
    }
    
  static testmethod void testEnvironmentVariable1(){
    User thisUser= DeviceChecklistTestDataUtils.createUserWithDCAdmin('System Administrator');
        System.runAs(thisUser){
            IntegrationUsers__c skipUser = new IntegrationUsers__c(SetupOwnerId = thisUser.Id, Is_Integration_User__c= true, Skip_Trigger__c = true, Skip_Validation_Rule__c = true);
            insert skipUser;
            
         
            Map<String,Object> fieldValueAccMap = new Map<String,Object>();
            Account account1 = AccountDataFactory.createAccount(fieldValueAccMap);
            
            Map<String,Object> fieldValueOppMap = new Map<String,Object>();
            fieldValueOppMap.put('AccountId', account1.id);
            Opportunity opp1 = OpportunityDataFactory.createOpportunity(fieldValueOppMap);
         
            Map<String,Object> fieldValuepoppProgramMap1 = new Map<String,Object>();
            fieldValuepoppProgramMap1.put('Account__c',account1.id);
            fieldValuepoppProgramMap1.put('Opportunity__c',opp1.id);
            Opportunity_Program__c oppprogram = new Opportunity_Program__c();    
            oppprogram = OpportunityProgramDataFactory.createOpportunityProgram(fieldValuepoppProgramMap1);
            
            Map<String,Object> fieldValueOptionMap = new Map<String,Object>();      
            Customer_Requirement__c  opt1 = BNP_DataFactory.createOption(fieldValueOptionMap);
            system.debug('--opt1 --'+opt1.id );
            
            Mask_Set_Title__c mst = new Mask_Set_Title__c();
            mst.Name = 'MSTTRT';
            mst.Reticle_Type__c = 'Multi Layer Reticle (MLR)';
            insert mst;
        
            Map<String,Object> fieldValueMap1 = new Map<String,Object>();
            fieldValueMap1.put('Device_Sourcing__c','Sole Source');
            fieldValueMap1.put('Opportunity_Program__c',oppprogram.Id);
            fieldValueMap1.put('Primary_Option__c',opt1.Id);
            fieldValueMap1.put('Secure_Device__c','Yes');
            fieldValueMap1.put('Mask_Set_Title_Lookup__c',mst.Id);            
            
            Device__c Dev1 = new Device__c ();
            Dev1 = DeviceDataFactory.createDevice(fieldValueMap1);
            set<id> devid= new set<id>();
            devid.add(Dev1.id);
            
            Test.startTest();
            Dev1.Product_TO_Date__c = System.today().addDays(1);
            Dev1.Forecasted_Production_Start_Date__c =  System.today().addDays(2);
            Dev1.Sample_Delivery_Date__c =  System.today().addDays(2);
            Dev1.Forecasted_Proto_Date__c =  System.today().addDays(3);
            Dev1.Forecasted_RTP_Date__c =  System.today().addDays(4);
            Dev1.Forecasted_Production_Start_Date__c = System.today().addDays(5);
            Dev1.Secure_Device__c = 'Yes';
            
            Dev1.BX041_Status__c = 'Pending Submission';
           
            update Dev1 ;
            
            BX_041__c bObj = new BX_041__c(Approver_1__c =thisUser.Id, Approver_2__c =thisUser.Id, Device__c =Dev1.Id);
            insert bObj;
            
            
            Environment_Variable__c env = Environment_Variable__c.getInstance('BPM_isActive');
            env.Value__c ='TRUE';
            update env ; 
              
          Test.stopTest();
      }
    } 
    
    static testMethod void deviceUpdtTest1() {   
    
        RecordType recType = [select id from RecordType where Name='Customer' and SobjectType='Account' limit 1];
        Account acc = new Account(Name='Test Account',RecordTypeId=recType.id,Site_Department__c='IT',Sub_Type__c='Indirect',
                                Transaction_Type__c='Non-Transactional',Region__c='US',Bill_To_Address_1__c='Test Address',
                                Bill_To_City__c='Test City',Bill_To_Country__c='India',Corporate_Address_1__c='Test Address',
                                Corporate_City__c='Test City',Corporate_Country__c='India', Account_Manager__c = userinfo.getuserid());
        
        insert acc;
           
        Opportunity opp = new Opportunity(Name='Test Opportunity',AccountId=acc.Id,StageName='1. Discovery',Market_Segment__c='Automotive',
                                        Target_Process_Node__c='14XM',Process_Platform__c='GF Baseline',Opportunity_Sourcing_Type__c='First Source',
                                        Fab_Split__c=100,CloseDate = date.newinstance(2012, 12, 21),Process_Geometry__c='0.014UM',
                                        Fab_Assignment_1__c = 'FAB 1',
                                        Process_Family__c = 'Super Low Power');
        
        insert opp;

        Opportunity_Program__c opProg = new Opportunity_Program__c(Name='Test OppProg',Account__c=acc.Id,Opportunity__c=opp.Id);
        insert opProg;
               
        test.startTest();
        String stageTapeout = 'Tapeout';
        Device__c dev = new Device__c();
        dev.Name = 'TESTDEVICE1313';
        dev.Stage__c = 'Design In';
        dev.Status__c = 'Active';
        dev.Account__c = acc.Id;
        dev.Opportunity2__c = opp.Id;
        dev.Opportunity_Program__c = opProg.Id;
        dev.Market_Segment__c = 'Automotive';
        dev.Semiconductor_Device__c = 'Analog Regulator';
        dev.End_Application__c = 'Body';
        dev.Device_Sourcing__c = '3rd Source';
        dev.Tapeout_Type__c = 'Customer MPW';
        dev.Siebel_Device_ID__c = '0987654321';
        dev.IP_Gap__c = false;
        dev.Actual_Tapeout_Date__c = date.newInstance(2013,5,20);
        dev.Forecasted_Lot_Start_Date__c = date.newInstance(2013,5,20);
        dev.Original_Forecasted_Tapeout_Date__c = date.newInstance(2013,3,4);
        dev.Current_Forecast_Tapeout_Date__c = date.newInstance(2013,3,4);
        dev.Fab__c = 'FAB 2';
        dev.Confidence_Level_Tapeout__c = '100';
         
        insert dev;
        dev.Stage__c = stageTapeout;
        update dev;         
        test.stopTest();
    }  

    static testMethod void internalDeviceUpdtTest1() {   
    
        RecordType recType = [select id from RecordType where DeveloperName='GLOBALFOUNDRIES_Internal' and SobjectType='Account' limit 1];
        Account acc = new Account(Name='Test Account',RecordTypeId=recType.id,Site_Department__c='IT',Sub_Type__c='Indirect',
                                Transaction_Type__c='Non-Transactional',Region__c='US',Bill_To_Address_1__c='Test Address',
                                Bill_To_City__c='Test City',Bill_To_Country__c='India',Corporate_Address_1__c='Test Address',
                                Corporate_City__c='Test City',Corporate_Country__c='India', Account_Manager__c = userinfo.getuserid());
        
        insert acc;
           
        Opportunity opp = new Opportunity(Name='Test Opportunity',AccountId=acc.Id,StageName='1. Discovery',Market_Segment__c='Automotive',
                                        Target_Process_Node__c='14XM',Process_Platform__c='GF Baseline',Opportunity_Sourcing_Type__c='First Source',
                                        Fab_Split__c=100,CloseDate = date.newinstance(2012, 12, 21),Process_Geometry__c='0.014UM',
                                        Fab_Assignment_1__c = 'FAB 1',
                                        Process_Family__c = 'Super Low Power');
        
        insert opp;

        Opportunity_Program__c opProg = new Opportunity_Program__c(Name='Test OppProg',Account__c=acc.Id,Opportunity__c=opp.Id);
        insert opProg;
        
        RecordType devrecType = [select id from RecordType where DeveloperName='Internal_Device' and SobjectType='Device__c' limit 1];
        /*Environment_Variable__c envTech = Environment_Variable__c.getInstance('DEVICE_ECCN_TECH_INTERNALDEV_DEFAULT');
        Environment_Variable__c envWafer = Environment_Variable__c.getInstance('DEVICE_ECCN_WAFER_INTERNALDEV_DEFAULT');
        Environment_Variable__c envColor = Environment_Variable__c.getInstance('DEVICE_ECCN_COLOR_INTERNALDEV_DEFAULT');
        Environment_Variable__c envItar = Environment_Variable__c.getInstance('DEVICE_ITAR_CLASS_INTERNALDEV_DEFAULT');
        Environment_Variable__c envItarStat = Environment_Variable__c.getInstance('DEVICE_ITAR_FLAG_INTERNALDEV_DEFAULT');
        Environment_Variable__c envD1Flag = Environment_Variable__c.getInstance('DEVICE_D1_FLAG_INTERNALDEV_DEFAULT');*/
        
        List<Environment_Variable__c> envList = new List<Environment_Variable__c>();
        Environment_Variable__c envTech = new Environment_Variable__c(name = 'DEVICE_ECCN_TECH_INTERNALDEV_DEFAULT', value__c = 'EAR99');
        envList.add(envTech);
        
        Environment_Variable__c envWafer = new Environment_Variable__c(name = 'DEVICE_ECCN_WAFER_INTERNALDEV_DEFAULT', value__c = 'EAR99');
        envList.add(envWafer);
        
        Environment_Variable__c envColor = new Environment_Variable__c(name = 'DEVICE_ECCN_COLOR_INTERNALDEV_DEFAULT', value__c = 'GREEN');
        envList.add(envColor);
        
        Environment_Variable__c envItar = new Environment_Variable__c(name = 'DEVICE_ITAR_CLASS_INTERNALDEV_DEFAULT', value__c = 'No');
        envList.add(envItar);
        
        Environment_Variable__c envItarStat = new Environment_Variable__c(name = 'DEVICE_ITAR_FLAG_INTERNALDEV_DEFAULT', value__c = 'NON ITAR/NON RED Zone');
        envList.add(envItarStat);
        
        Environment_Variable__c envD1Flag = new Environment_Variable__c(name = 'DEVICE_D1_FLAG_INTERNALDEV_DEFAULT', value__c = 'Yes');
        envList.add(envD1Flag);
        
        insert envList;
        
        psa_psc_eccn_default__c eccnDefault = new psa_psc_eccn_default__c(Name = '5E991', D1_National_Access_Allowed__c = 'Yes', ECCN_Color__c = 'YELLOW', psa_eccn__c = 'A', psc_eccn__c = '0');
        insert eccnDefault;
        
        test.startTest();
        //String stageTapeout = 'Tapeout';
        Device__c dev = new Device__c();
        dev.Name = 'TESTDEVICE1313';
        dev.RecordTypeId=devrecType.id;
        dev.Stage__c = 'Design In';
        dev.Status__c = 'Active';
        dev.Account__c = acc.Id;
        dev.Opportunity2__c = opp.Id;
        dev.Opportunity_Program__c = opProg.Id;
        dev.Market_Segment__c = 'Automotive';
        dev.Semiconductor_Device__c = 'Analog Regulator';
        dev.End_Application__c = 'Body';
        dev.Device_Sourcing__c = '3rd Source';
        dev.Tapeout_Type__c = 'Customer MPW';
        dev.Siebel_Device_ID__c = '0987654321';
        dev.IP_Gap__c = false;
        dev.Actual_Tapeout_Date__c = date.newInstance(2013,5,20);
        dev.Forecasted_Lot_Start_Date__c = date.newInstance(2013,5,20);
        dev.Original_Forecasted_Tapeout_Date__c = date.newInstance(2013,3,4);
        dev.Current_Forecast_Tapeout_Date__c = date.newInstance(2013,3,4);
        dev.Fab__c = 'FAB 8';
        dev.Internal_Device_Geometry__c = '0.003UM';
        dev.Internal_Device_Process_Family__c = 'Interposer';
        dev.Confidence_Level_Tapeout__c = '100';
         
        insert dev;
        dev.ECCN_Technology__c = '5E991';
        update dev;         
        test.stopTest();
    }
}