/**
   @Author <Cognizant Technology Solutions>
   @name <BNPTRCloneCtrl_Test>
   @CreateDate <12/29/2016>
   @Description <Apex Test Class For OptionTriggerHelper>
   @Version <>
   1.1 - Created New method "OptionsTrHelper2" to cover Option Trigger and "UtilOptionsTrigger" class - GOPI KOKA
   @reference <>
 */
@isTest
public Class OptionTriggerHelper_Test
{
    @TestSetup static void testdata() 
    {
        DataUtilTest.loadEnvironmentVariables();
    }
    Static TestMethod void OptionsTrHelper() 
    {
        RecordType recordTypeRI =  [Select Id from RecordType where developerName = 'RFQ' AND SObjectType = 'Request_Information__c'];
        List<RecordType> rt  = [SELECT Description,DeveloperName,Id,IsActive,Name,SobjectType FROM RecordType where SobjectType ='Customer_Requirement__c']; 
        RecordType recordType =  [Select Id from RecordType where Name = 'Customer' AND SObjectType = 'Account'];
        User thisUser= DeviceChecklistTestDataUtils.createUserWithDCAdmin('System Administrator');
        System.runAs(thisUser)
        {
            IntegrationUsers__c skipUser = new IntegrationUsers__c(SetupOwnerId = thisUser.Id, Is_Integration_User__c= true, Skip_Trigger__c = true, Skip_Validation_Rule__c = true);
            insert skipUser;
               
            Map<String,Object> fieldValueAccMap = new Map<String,Object>();
            Account account1 = AccountDataFactory.createAccount(fieldValueAccMap);
            
            Map<String,Object> fieldValueOppMap = new Map<String,Object>();
            fieldValueOppMap.put('AccountId', account1.id);
            Opportunity opp1 = OpportunityDataFactory.createOpportunity(fieldValueOppMap);
            
            Map<String,Object> fieldValueOppMap1 = new Map<String,Object>();
            fieldValueOppMap1.put('AccountId', account1.id);
            Opportunity opp2 = OpportunityDataFactory.createOpportunity(fieldValueOppMap1);
            
            
            Map<String,Object> fieldValuepoppProgramMap1 = new Map<String,Object>();
            fieldValuepoppProgramMap1.put('Account__c',account1.id);
            fieldValuepoppProgramMap1.put('Opportunity__c',opp1.id);
            Opportunity_Program__c oppprogram = new Opportunity_Program__c();    
            oppprogram = OpportunityProgramDataFactory.createOpportunityProgram(fieldValuepoppProgramMap1);
            
            Map<String,Object> fieldValueMap1 = new Map<String,Object>();
            fieldValueMap1.put('Device_Sourcing__c','Sole Source');
            fieldValueMap1.put('Opportunity_Program__c',oppprogram.Id);
            Device__c Dev1 = new Device__c ();
            Dev1 = DeviceDataFactory.createDevice(fieldValueMap1);
            
            test.startTest();
            Map<String,Object> fieldValueOptionInfoMap = new Map<String,Object>();
            fieldValueOptionInfoMap.put('Opportunity__c',opp1.id);
            fieldValueOptionInfoMap.put('Device__c',Dev1 .Id);
            Customer_Requirement__c cr = BNP_DataFactory.createOption(fieldValueOptionInfoMap);
            
            Customer_Requirement__c cr1 = BNP_DataFactory.createOption(fieldValueOptionInfoMap);
            
            Customer_Requirement__c cr2 = BNP_DataFactory.createOption(fieldValueOptionInfoMap);
    
            Customer_Requirement__c cr3 = BNP_DataFactory.createOption(fieldValueOptionInfoMap);
            
            OptionTriggerHelper opt = new OptionTriggerHelper();
            
            cr.Opportunity__c = opp2.id;
            
            Chip_Data__c chip1 = new Chip_Data__c();
            chip1.Technical_Requirement__c = cr1.Id;
            Insert chip1;
            
            Chip_Data__c chip2 = new Chip_Data__c();
            chip2.Technical_Requirement__c = cr2.Id;
            Insert chip2;
            
            Chip_Data__c chip3 = new Chip_Data__c();
            chip3.Technical_Requirement__c = cr3.Id;
            Insert chip3;
            
            Chip_Data__c chip4 = new Chip_Data__c();
            chip4.Technical_Requirement__c = cr3.Id;
            Insert chip4;
            
            Chip_Data__c chip5 = new Chip_Data__c();
            chip5.Technical_Requirement__c = cr2.Id;
            Insert chip5;
            
            Chip_Data__c chip6 = new Chip_Data__c();
            chip6.Technical_Requirement__c = cr1.Id;
            Insert chip6;
            
            Module_Data__c mod= new Module_Data__c();
            mod.Package_encapsulation_cap_lid_type__c = 'Other';
            mod.Technical_Requirement__c = cr.id;
            mod.Number_of_decoupling_capacitor_sites__c = '2';
            mod.Are_decoupling_capacitors_required_on_ch__c = 'No';
            mod.Is_the_module_Pb_Pb_reduced_or_Pb_free__c = 'Pb';
            mod.Module_Burn_In__c = 'No';
            mod.Chip_1__c = chip1.Id;
            mod.Chip_2__c = chip2.Id;
            mod.Chip_3__c = chip3.Id;
            mod.Chip_4__c = chip4.Id;
            mod.Chip_5__c = chip5.Id;
            mod.Chip_6__c = chip6.Id;
            
            Insert mod;
            update cr; 
            system.assertequals(Dev1.Device_Sourcing__c,'Sole Source'); 
            test.stopTest();
         }
         
       }   
       Static TestMethod void OptionsTrHelper1() 
    {
        
        List<RecordType> rt  = [SELECT Description,DeveloperName,Id,IsActive,Name,SobjectType FROM RecordType where SobjectType ='Customer_Requirement__c']; 
        RecordType recordType =  [Select Id from RecordType where Name = 'Customer' AND SObjectType = 'Account'];
        
        
        User thisUser= DeviceChecklistTestDataUtils.createUserWithDCAdmin('System Administrator');
        System.runAs(thisUser)
        {
            IntegrationUsers__c skipUser = new IntegrationUsers__c(SetupOwnerId = thisUser.Id, Is_Integration_User__c= true, Skip_Trigger__c = true, Skip_Validation_Rule__c = true);
            insert skipUser;
            
            
            RecordType recordTypeOptions =  [Select Id from RecordType where developerName = 'Contract_Technical_Requirment' AND SObjectType = 'Customer_Requirement__c'];
            RecordType recordTypeRIQ =  [Select Id from RecordType where developerName = 'RFQ_Contract' AND SObjectType = 'Request_Information__c'];

               
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
            
            Map<String,Object> fieldValueMap1 = new Map<String,Object>();
            fieldValueMap1.put('Device_Sourcing__c','Sole Source');
            fieldValueMap1.put('Opportunity_Program__c',oppprogram.Id);
            Device__c Dev1 = new Device__c ();
            Dev1 = DeviceDataFactory.createDevice(fieldValueMap1);
            
            test.starttest();
            Map<String,Object> fieldValueOptionInfoMap = new Map<String,Object>();
            fieldValueOptionInfoMap.put('Opportunity__c',opp1.id);
            fieldValueOptionInfoMap.put('Device__c',Dev1 .Id);
            fieldValueOptionInfoMap.put('recordTypeID',recordTypeOptions .id);
            Customer_Requirement__c cr = BNP_DataFactory.createOption(fieldValueOptionInfoMap);
            
            Map<String,Object> fieldValueReqInfoMap = new Map<String,Object>();
            fieldValueReqInfoMap.put('Opportunity__c', opp1.id);
            fieldValueReqInfoMap.put('Customer_Requirement__c', cr.id);
            fieldValueReqInfoMap.put('Primary_Request_Catcher__c', thisUser.id);
            fieldValueReqInfoMap.put('Backup_Request_Catcher__c', thisUser.id);
            fieldValueReqInfoMap.put('recordTypeID', recordTypeRIQ.id);        
            fieldValueReqInfoMap.put('Quote_Status__c', 'Accept');
            fieldValueReqInfoMap.put('Skip_Validation__c', true);
            Request_Information__c reqInfo = BNP_DataFactory.createRequestInformation(fieldValueReqInfoMap);     
            
            system.assertequals(Dev1.Device_Sourcing__c,'Sole Source');           
            test.stoptest();
            //OptionTriggerHelper opt = new OptionTriggerHelper();
             
         }
         
       }    
       /*Static TestMethod void OptionsTrHelper2() {
           Test.StartTest();
            Customer_Requirement__c cr = new Customer_Requirement__c();
            cr.Fab__c ='FAB 1';
            cr.Node__c = '0.11UM';
            cr.Technology__c = '7LP';
            cr.Deliverable_Type__c = 'Chip';
            cr.Option_Stage__c = 'Reconciliation';
            cr.Deliverable_Part_Number_DPN__c = 'DP';
            cr.isTCA__c = 'Yes';
            insert cr;
            
            ERP_Device__c erp2 = new ERP_Device__c();
            erp2.Name ='Test234056';
            erp2.Part_Number__c = 'dpn009';
            insert erp2;
            
            system.assertequals(cr.isTCA__c ,'Yes');
           Test.StopTest();
       } */
       
        Static TestMethod void OptionsTrHelper3() 
    {
        
        List<RecordType> rt  = [SELECT Description,DeveloperName,Id,IsActive,Name,SobjectType FROM RecordType where SobjectType ='Customer_Requirement__c']; 
        RecordType recordType =  [Select Id from RecordType where Name = 'Customer' AND SObjectType = 'Account'];
        
        
        User thisUser= DeviceChecklistTestDataUtils.createUserWithDCAdmin('System Administrator');
        System.runAs(thisUser)
        {
            IntegrationUsers__c skipUser = new IntegrationUsers__c(SetupOwnerId = thisUser.Id, Is_Integration_User__c= true, Skip_Trigger__c = true, Skip_Validation_Rule__c = true);
            insert skipUser;
            
            
            RecordType recordTypeOptions =  [Select Id from RecordType where developerName = 'Contract_Technical_Requirment' AND SObjectType = 'Customer_Requirement__c'];
            RecordType recordTypeRIQ =  [Select Id from RecordType where developerName = 'RFQ_Contract' AND SObjectType = 'Request_Information__c'];

               
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
            
            Map<String,Object> fieldValueMap1 = new Map<String,Object>();
            fieldValueMap1.put('Device_Sourcing__c','Sole Source');
            fieldValueMap1.put('Opportunity_Program__c',oppprogram.Id);
            Device__c Dev1 = new Device__c ();
            Dev1 = DeviceDataFactory.createDevice(fieldValueMap1);
            
            test.starttest();
            Map<String,Object> fieldValueOptionInfoMap = new Map<String,Object>();
            fieldValueOptionInfoMap.put('Opportunity__c',opp1.id);
            fieldValueOptionInfoMap.put('Device__c',Dev1 .Id);
            fieldValueOptionInfoMap.put('Option_Stage__c','Reconciliation');
            fieldValueOptionInfoMap.put('recordTypeID',recordTypeOptions .id);
            Customer_Requirement__c cr = BNP_DataFactory.createOption(fieldValueOptionInfoMap);
            
            
            /*Map<String,Object> fieldValueReqInfoMap = new Map<String,Object>();
            fieldValueReqInfoMap.put('Opportunity__c', opp1.id);
            fieldValueReqInfoMap.put('Customer_Requirement__c', cr.id);
            fieldValueReqInfoMap.put('Primary_Request_Catcher__c', thisUser.id);
            fieldValueReqInfoMap.put('Backup_Request_Catcher__c', thisUser.id);
            fieldValueReqInfoMap.put('recordTypeID', recordTypeRIQ.id);        
            fieldValueReqInfoMap.put('Quote_Status__c', 'Accept');
            fieldValueReqInfoMap.put('Skip_Validation__c', true);
            Request_Information__c reqInfo = BNP_DataFactory.createRequestInformation(fieldValueReqInfoMap);     */
             
            cr.Design_Export_Control_Classification_Num__c = 'testtt';
            checkRecursive.run = true;
             Chip_Data__c chip1 = new Chip_Data__c();
            chip1.Technical_Requirement__c = cr.Id;
            Insert chip1;
            
            Chip_Data__c chip2 = new Chip_Data__c();
            chip2.Technical_Requirement__c = cr.Id;
            Insert chip2;
            
            Chip_Data__c chip3 = new Chip_Data__c();
            chip3.Technical_Requirement__c = cr.Id;
            Insert chip3;
            
            Chip_Data__c chip4 = new Chip_Data__c();
            chip4.Technical_Requirement__c = cr.Id;
            Insert chip4;
            
            Chip_Data__c chip5 = new Chip_Data__c();
            chip5.Technical_Requirement__c = cr.Id;
            Insert chip5;
            
            Chip_Data__c chip6 = new Chip_Data__c();
            chip6.Technical_Requirement__c = cr.Id;
            Insert chip6;
            
            Module_Data__c mod= new Module_Data__c();
            mod.Package_encapsulation_cap_lid_type__c = 'Other';
            mod.Technical_Requirement__c = cr.id;
            mod.Number_of_decoupling_capacitor_sites__c = '2';
            mod.Are_decoupling_capacitors_required_on_ch__c = 'No';
            mod.Is_the_module_Pb_Pb_reduced_or_Pb_free__c = 'Pb';
            mod.Module_Burn_In__c = 'No';
            mod.Chip_1__c = chip1.Id;
            mod.Chip_2__c = chip2.Id;
            mod.Chip_3__c = chip3.Id;
            mod.Chip_4__c = chip4.Id;
            mod.Chip_5__c = chip5.Id;
            mod.Chip_6__c = chip6.Id;           
            Insert mod;
            update cr;          
            
            system.assertequals(cr.Design_Export_Control_Classification_Num__c,'testtt');
            test.stoptest();
            //OptionTriggerHelper opt = new OptionTriggerHelper();
             
         }
         
       }  
            
 }