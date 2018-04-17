/******************************************************************************************************************************
Class:         NPCCopyConfigurationControllerTest 
-------------------------------------------------------------------------------------------------------------------------------
Author:        Anirban Roy
Created Date:  20/05/2016
Reason:        Test class for NPCCopyConfigurationController class
ARoy       20052016    -  Code creation.
*******************************************************************************************************************************/

@isTest(SeeAllData=false)
public class NPCCopyConfigurationControllerTest{
    @testSetup
    static void testDataSetup(){
       DataUtilTest.loadEnvironmentVariables();
       
       Map<String,Object> fieldValueMap = new Map<String,Object>();
        fieldValueMap.put('Name', 'MYTEST ACCOUNT1');  
        fieldValueMap.put('Account_Type__c', 'Customer');                           
        fieldValueMap.put('sub_type__c', 'Indirect');        
        fieldValueMap.put('site_department__c', 'IT');  
        fieldValueMap.put('Account_Manager__c', userinfo.getuserid());        
        fieldValueMap.put('transaction_type__c', 'Non-Transactional');                          
        fieldValueMap.put('region__c', 'US');        
        fieldValueMap.put('Corporate_Address_1__c', 'Test Address 1');          
        fieldValueMap.put('Corporate_City__c', 'Test City');                
        fieldValueMap.put('Corporate_Country__c', 'Singapore');
        fieldValueMap.put('Bill_To_Address_1__c', 'Test Address 1');          
        fieldValueMap.put('Bill_To_City__c', 'Test City');            
        fieldValueMap.put('Bill_To_Country__c', 'Singapore');
        
        AccountDataFactory.createAccount(fieldValueMap);
        Account acc = getAccount('MYTEST ACCOUNT1');
        Opportunity opp = createOpp(acc.Id);  
        Opportunity_Program__c oppProg = createOppProg(acc.Id,opp.Id); 
        Test.startTest();
        Device__c dev = DeviceUtilTest.createCMPWDevice(acc.Id,oppProg.Id);
        Insert dev;
        Test.stopTest();
    }
    
    static testMethod void testPrepareDataForCloneConfig(){
        // Creating the original configurator
        /* Account acc = getAccount('MYTEST ACCOUNT1');        
        Opportunity opp = createOpp(acc.Id);  
        Opportunity_Program__c oppProg = createOppProg(acc.Id,opp.Id); 
        Device__c dev = DeviceUtilTest.createCMPWDevice(acc.Id,oppProg.Id); */
        Account acc = getAccount('MYTEST ACCOUNT1');       
        Opportunity opp = [Select Id, Name from Opportunity where Name='Test Opportunity1'];
        Opportunity_Program__c oppProg = [Select Id, Name from Opportunity_Program__c where Name='Test OppProg1'];
        Device__c dev = [Select Id, Name from Device__c where Name='TESTDEVICEZAIH12345677'];
        
        Test.startTest();                      
        //Insert dev;
        Pagereference pg = Page.NPCCopyConfiguration;
        Test.setCurrentPage(Page.NPCCopyConfiguration);
        Apexpages.currentpage().getparameters().put('oldDeviceId',dev.Id);
        Apexpages.currentpage().getparameters().put('newDeviceId',null);
        Apexpages.currentpage().getparameters().put('mode','NPC');
        Apexpages.currentpage().getparameters().put('reasonForRetrofit',null);
        NPCCopyConfigurationController cont = new NPCCopyConfigurationController();
        //cont.dev.Id,null,'NPC',null
        cont.prepareDataForClone();
        
        Test.stopTest();
    }
    
    static testMethod void testPrepareDataForCloneForNPC1(){
        // Creating the original configurator
        /*Account acc = getAccount('MYTEST ACCOUNT1');        
        Opportunity opp = createOpp(acc.Id);  
        Opportunity_Program__c oppProg = createOppProg(acc.Id,opp.Id); 
        Device__c dev = DeviceUtilTest.createCMPWDevice(acc.Id,oppProg.Id); */
        Account acc = getAccount('MYTEST ACCOUNT1');       
        Opportunity opp = [Select Id, Name from Opportunity where Name='Test Opportunity1'];
        Opportunity_Program__c oppProg = [Select Id, Name from Opportunity_Program__c where Name='Test OppProg1'];
        Device__c dev = [Select Id, Name from Device__c where Name='TESTDEVICEZAIH12345677'];        
        
        Test.startTest();
        //Insert dev;      
        Apttus_Proposal__Proposal__c proposal = createProposal(acc.Id, opp.Id, dev.Id, null, null);
        insert proposal;
        
        Product2 bundleProd = createProduct('Test Process Technology', 'PROCESSTECH0001', Null, Null);
        
        Product2 optionProd = createOptionProduct('Test Mask 1', 'Mask Layers', 'TESTMASK0001', 'AA');
        insert optionProd;
        //Apttus_Proposal__Proposal_Line_Item__c lineItem = createProposalLineItem(1, proposal.Id, optionProd.Id, 'Approved');
        //insert lineItem;
        Apttus_Config2__ProductConfiguration__c pc = createProdConfig(proposal.Id);
        
      
        
        //Device__c dev1 = DeviceUtilTest.createCustomerMPWDevice8(acc.Id,opp.Id,oppProg.Id);
        
        Pagereference pg = Page.NPCCopyConfiguration;
        Test.setCurrentPage(Page.NPCCopyConfiguration);
        Apexpages.currentpage().getparameters().put('oldDeviceId',dev.Id);
        Apexpages.currentpage().getparameters().put('newDeviceId',dev.Id);
        Apexpages.currentpage().getparameters().put('mode','NPC');
        Apexpages.currentpage().getparameters().put('reasonForRetrofit','Retrofit');
        NPCCopyConfigurationController cont = new NPCCopyConfigurationController();
        //cont.dev.Id,null,'NPC',null
        cont.prepareDataForClone();
        
        //NPCCopyConfigurationController.prepareDataForClone(dev.Id,dev1.Id,'NPC',null);
         Test.stopTest();
        
    }
    
    static testMethod void testPrepareDataForCloneForNPC2(){
        // Creating the original configurator
        /*Account acc = getAccount('MYTEST ACCOUNT1');        
        Opportunity opp = createOpp(acc.Id);
        Opportunity_Program__c oppProg = createOppProg(acc.Id,opp.Id);         
        Device__c dev = DeviceUtilTest.createCMPWDevice(acc.Id,oppProg.Id); */
        Account acc = getAccount('MYTEST ACCOUNT1');       
        Opportunity opp = [Select Id, Name from Opportunity where Name='Test Opportunity1'];
        Opportunity_Program__c oppProg = [Select Id, Name from Opportunity_Program__c where Name='Test OppProg1'];
        Device__c dev = [Select Id, Name from Device__c where Name='TESTDEVICEZAIH12345677'];                
        
        Test.startTest();
        //Insert dev;
        Apttus_Proposal__Proposal__c proposal = createProposal(acc.Id, opp.Id, dev.Id, null, null);
        insert proposal;
        
        Product2 bundleProd = createProduct('Test Process Technology', 'PROCESSTECH0001', Null, Null);
        
        Product2 optionProd = createOptionProduct('Test Mask 1', 'Mask Layers', 'TESTMASK0001', 'AA');
        insert optionProd;
        
        Apttus_Config2__ProductConfiguration__c pc = createProdConfig(proposal.Id);                
        
        //Device__c dev1 = DeviceUtilTest.createCustomerMPWDevice8(acc.Id,opp.Id,oppProg.Id);
        
        
        Pagereference pg = Page.NPCCopyConfiguration;
        Test.setCurrentPage(Page.NPCCopyConfiguration);
        Apexpages.currentpage().getparameters().put('oldDeviceId',dev.Id);
        Apexpages.currentpage().getparameters().put('newDeviceId',dev.Id);
        Apexpages.currentpage().getparameters().put('mode','NPC');
        Apexpages.currentpage().getparameters().put('reasonForRetrofit','Fab to Fab Transfer');
        NPCCopyConfigurationController cont = new NPCCopyConfigurationController();
        //cont.dev.Id,null,'NPC',null
        cont.prepareDataForClone();
        //NPCCopyConfigurationController.prepareDataForClone(dev.Id,dev1.Id,'NPC','Fab to Fab Transfer');
        
         Test.stopTest();
    }
    /*
    static testMethod void testPrepareDataForCloneForNPC3(){
        // Creating the original configurator
        Account acc = getAccount('MYTEST ACCOUNT1');       
        Opportunity opp = createOpp(acc.Id);
        Opportunity_Program__c oppProg = createOppProg(acc.Id,opp.Id);         
        Device__c dev = DeviceUtilTest.createCMPWDevice(acc.Id,oppProg.Id);
        
        
         Test.startTest();
        Insert dev;
        Apttus_Proposal__Proposal__c proposal = createProposal(acc.Id, opp.Id, dev.Id, null, null);
        proposal.Apttus_Proposal__Approval_Stage__c = 'Process Flow Accepted';
        proposal.Purpose_of_the_Configuration__c = 'Final';
        insert proposal;
        
        Product2 bundleProd = createProduct('Test Process Technology', 'PROCESSTECH0001', Null, Null);
        
        Product2 optionProd = createOptionProduct('Test Mask 1', 'Mask Layers', 'TESTMASK0001', 'AA');
        insert optionProd;
        
        Apttus_Config2__ProductConfiguration__c pc = createProdConfig(proposal.Id);                
        
        //Device__c dev1 = DeviceUtilTest.createCustomerMPWDevice8(acc.Id,opp.Id,oppProg.Id);
        
       
        Pagereference pg = Page.NPCCopyConfiguration;
        Test.setCurrentPage(Page.NPCCopyConfiguration);
        Apexpages.currentpage().getparameters().put('oldDeviceId',dev.Id);
        Apexpages.currentpage().getparameters().put('newDeviceId',dev.Id);
        Apexpages.currentpage().getparameters().put('mode','NPC');
        Apexpages.currentpage().getparameters().put('reasonForRetrofit',null);
        NPCCopyConfigurationController cont = new NPCCopyConfigurationController();
        //cont.dev.Id,null,'NPC',null
        cont.prepareDataForClone();
        //NPCCopyConfigurationController.prepareDataForClone(dev.Id,dev1.Id,'NPC',null);
        
        Test.stopTest();
    }*/
    
    static testMethod void testPrepareDataForCloneForCopy(){
        // Creating the original configurator
        /*Account acc = getAccount('MYTEST ACCOUNT1');        
        Opportunity opp = createOpp(acc.Id);
        Opportunity_Program__c oppProg = createOppProg(acc.Id,opp.Id);
        Device__c dev = DeviceUtilTest.createCMPWDevice(acc.Id,oppProg.Id);*/
        Account acc = getAccount('MYTEST ACCOUNT1');       
        Opportunity opp = [Select Id, Name from Opportunity where Name='Test Opportunity1'];
        Opportunity_Program__c oppProg = [Select Id, Name from Opportunity_Program__c where Name='Test OppProg1'];
        Device__c dev = [Select Id, Name from Device__c where Name='TESTDEVICEZAIH12345677'];        

        
        Test.startTest();
        //Insert dev;     
        Apttus_Proposal__Proposal__c proposal = createProposal(acc.Id, opp.Id, dev.Id, null, null);
        insert proposal;
        
        Product2 bundleProd = createProduct('Test Process Technology', 'PROCESSTECH0001', Null, Null);
        
        Product2 optionProd = createOptionProduct('Test Mask 1', 'Mask Layers', 'TESTMASK0001', 'AA');
        insert optionProd;
        
        Apttus_Config2__ProductConfiguration__c pc = createProdConfig(proposal.Id);        
        
        //Device__c dev1 = DeviceUtilTest.createCustomerMPWDevice8(acc.Id,opp.Id,oppProg.Id);
        
        
        Pagereference pg = Page.NPCCopyConfiguration;
        Test.setCurrentPage(Page.NPCCopyConfiguration);
        Apexpages.currentpage().getparameters().put('oldDeviceId',dev.Id);
        Apexpages.currentpage().getparameters().put('newDeviceId',dev.Id);
        Apexpages.currentpage().getparameters().put('mode','COPY');
        Apexpages.currentpage().getparameters().put('reasonForRetrofit',null);
        NPCCopyConfigurationController cont = new NPCCopyConfigurationController();
        //cont.dev.Id,null,'NPC',null
        cont.prepareDataForClone();
        //NPCCopyConfigurationController.prepareDataForClone(dev.Id,dev1.Id,'COPY',null);
        
        Test.stopTest();
    }
    
    static testMethod void testPrepareDataForCloneForRevise1(){
        // Creating the original configurator
        /*Account acc = getAccount('MYTEST ACCOUNT1');       
        Opportunity opp = createOpp(acc.Id);
        Opportunity_Program__c oppProg = createOppProg(acc.Id,opp.Id);
        Device__c dev = DeviceUtilTest.createCMPWDevice(acc.Id,oppProg.Id); */
        Account acc = getAccount('MYTEST ACCOUNT1');       
        Opportunity opp = [Select Id, Name from Opportunity where Name='Test Opportunity1'];
        Opportunity_Program__c oppProg = [Select Id, Name from Opportunity_Program__c where Name='Test OppProg1'];
        Device__c dev = [Select Id, Name from Device__c where Name='TESTDEVICEZAIH12345677'];                
        
        Test.startTest();
        //Insert dev;        
        Apttus_Proposal__Proposal__c proposal = createProposal(acc.Id, opp.Id, dev.Id, null, null);
        //proposal.Apttus_Proposal__Approval_Stage__c = 'Process Flow Accepted';
        insert proposal;
       
        Product2 bundleProd = createProduct('Test Process Technology', 'PROCESSTECH0001', Null, Null);
        Product2 optionProd = createOptionProduct('Test Mask 1', 'Mask Layers', 'TESTMASK0001', 'AA');
        //Product2 optionProd = createOptionProduct('Test Mask 1', 'IPs', 'IP0001', 'AA');
        insert optionProd;
        
        //Apttus_Proposal__Proposal_Line_Item__c lineItem = createProposalLineItem(1, proposal.Id, optionProd.Id, 'Approved');
        //insert lineItem;
         
        Apttus_Config2__ProductConfiguration__c pc = createProdConfig(proposal.Id);
        
        //Device__c dev1 = DeviceUtilTest.createCustomerMPWDevice8(acc.Id,opp.Id,oppProg.Id);
        
        
        Pagereference pg = Page.NPCCopyConfiguration;
        Test.setCurrentPage(Page.NPCCopyConfiguration);
        Apexpages.currentpage().getparameters().put('oldDeviceId',dev.Id);
        Apexpages.currentpage().getparameters().put('newDeviceId',dev.Id);
        Apexpages.currentpage().getparameters().put('mode','REVISE');
        Apexpages.currentpage().getparameters().put('reasonForRetrofit',null);
        NPCCopyConfigurationController cont = new NPCCopyConfigurationController();
        //cont.dev.Id,null,'NPC',null
        cont.prepareDataForClone();
        //NPCCopyConfigurationController.prepareDataForClone(dev.Id,dev1.Id,'REVISE',null);
       
        Test.stopTest();
    }
    
    static testMethod void testPrepareDataForCloneForRevise2(){
        // Creating the original configurator
        /*Account acc = getAccount('MYTEST ACCOUNT1');        
        Opportunity opp = createOpp(acc.Id);
        Opportunity_Program__c oppProg = createOppProg(acc.Id,opp.Id);
        Device__c dev = DeviceUtilTest.createCMPWDevice(acc.Id,oppProg.Id); */
        Account acc = getAccount('MYTEST ACCOUNT1');       
        Opportunity opp = [Select Id, Name from Opportunity where Name='Test Opportunity1'];
        Opportunity_Program__c oppProg = [Select Id, Name from Opportunity_Program__c where Name='Test OppProg1'];
        Device__c dev = [Select Id, Name from Device__c where Name='TESTDEVICEZAIH12345677'];        
        
         Test.startTest();
        //Insert dev;        
        Apttus_Proposal__Proposal__c proposal = createProposal(acc.Id, opp.Id, dev.Id, null, null);
        insert proposal;
        
        Product2 bundleProd = createProduct('Test Process Technology', 'PROCESSTECH0001', Null, Null);
        Product2 optionProd = createOptionProduct('Test Mask 1', 'Mask Layers', 'TESTMASK0001', 'AA');
        //Product2 optionProd = createOptionProduct('Test Mask 1', 'IPs', 'IP0001', 'AA');
        insert optionProd;
        
        //Apttus_Proposal__Proposal_Line_Item__c lineItem = createProposalLineItem(1, proposal.Id, optionProd.Id, 'Approved');
        //insert lineItem;
        
        Apttus_Config2__ProductConfiguration__c pc = createProdConfig1(proposal.Id);
       
       // Device__c dev1 = DeviceUtilTest.createCustomerMPWDevice8(acc.Id,opp.Id,oppProg.Id);
       
        Pagereference pg = Page.NPCCopyConfiguration;
        Test.setCurrentPage(Page.NPCCopyConfiguration);
        Apexpages.currentpage().getparameters().put('oldDeviceId',dev.Id);
        Apexpages.currentpage().getparameters().put('newDeviceId',dev.Id);
        Apexpages.currentpage().getparameters().put('mode','REVISE');
        Apexpages.currentpage().getparameters().put('reasonForRetrofit',null);
        NPCCopyConfigurationController cont = new NPCCopyConfigurationController();
        //cont.dev.Id,null,'NPC',null
        cont.prepareDataForClone();
        //NPCCopyConfigurationController.prepareDataForClone(dev.Id,dev1.Id,'REVISE',null);
        
        Test.stopTest(); 
    }        
    
    //Static method to create Opportunity test record
    static Opportunity createOpp(Id acctId){
        Opportunity opp = new Opportunity(Name = 'Test Opportunity1',
                                          AccountId = acctId,
                                          StageName = '1. Discovery',
                                          Market_Segment__c = 'Automotive',
                                          Target_Process_Node__c = '14XM',
                                          Process_Platform__c = 'GF Baseline',
                                          Opportunity_Sourcing_Type__c = 'First Source',
                                          Fab_Split__c = 100,
                                          CloseDate = date.newinstance(2012, 12, 21),
                                          Process_Geometry__c = '0.014UM',
                                          Fab_Assignment_1__c = 'FAB 1',
                                          Process_Family__c = 'Super Low Power');
        
        insert opp;
        return opp;
    }
    
    //Static method to create Opportunity Program test record
    static Opportunity_Program__c createOppProg(Id acctId, Id oppId){
        Opportunity_Program__c opProg = 
                    new Opportunity_Program__c(Name = 'Test OppProg1',
                                               Account__c = acctId,
                                               Opportunity__c = oppId);
        insert opProg;
        return opProg;
    }
    
    //Static method to create proposal test record
    static Apttus_Proposal__Proposal__c createProposal(Id accId, Id oppId, Id devId, Id tmrmId, String szMaskSet){
        //Setup the test records required to create the Proposal test record
        RecordType recType = [Select Id
                                From RecordType 
                               Where Name='Draft' And
                                     SobjectType = 'Apttus_Proposal__Proposal__c'];
        
        //Create a proposal from Device
        Apttus_Proposal__Proposal__c proposal = 
                    new Apttus_Proposal__Proposal__c(Apttus_Proposal__Description__c = 'Test Proposal Description ...',
                                                     Device__c = devId,
                                                     Mask_Set__c = szMaskSet,
                                                     Apttus_Proposal__Opportunity__c = oppId,
                                                     Apttus_Proposal__Account__c = accId,
                                                     RecordTypeId = recType.Id);
        
        //insert proposal;
        return proposal;
    }
    
    //Static method to create product test record
    static Product2 createProduct(String szName, String szCode, String szMaskSet, String szProductFamily){
        //Create a product
        Product2 prod = new Product2(Name = szName,
                                     Family = szProductFamily,
                                     ProductCode = szCode,
                                     Product_External_ID__c = szCode + Math.Random(),
                                     BEOL__c = 'AA BB CC',
                                     FEOL__c = 'DD EE FF',
                                     APTPS_Core_Voltage__c = '1.50',
                                     APTPS_IO_Voltage__c = '1.50',
                                     Geometry__c = '0.028nm',
                                     Mask_Sets__c = szMaskSet,
                                     IsActive = True);
        
        insert prod;
        return prod;
    }
    
    //Static method to create product test record
    static Product2 createOptionProduct(String szName, String szFamily, String szCode, String szMaskSet){
        //Create a product
        Product2 prod = new Product2(Name = szName,
                                     Family = szFamily,
                                     ProductCode = szCode,
                                     Product_External_ID__c = szCode + Math.Random(),
                                     APTPS_Core_Voltage__c = '1.50',
                                     APTPS_IO_Voltage__c = '1.50',
                                     Geometry__c = '0.028nm',
                                     Mask_Sets__c = szMaskSet,
                                     IsActive = True);
        
        //insert prod;
        return prod;
    }        
    
    //Static method to create Product Configuration
    static Apttus_Config2__ProductConfiguration__c createProdConfig(Id proposalId){
        Apttus_Config2__BillingPreference__c bp = new Apttus_Config2__BillingPreference__c(Name = 'Test Billing Preference');
        insert bp;
        Apttus_Config2__ProductConfiguration__c prodConfig = 
                    new Apttus_Config2__ProductConfiguration__c(Apttus_QPConfig__Proposald__c = proposalId,
                                                                Apttus_Config2__Status__c = 'Finalized',
                                                                Apttus_Config2__BillingPreferenceId__c = bp.Id);
        insert prodConfig;
        return prodConfig;
    }
    
    //Static method to create Product Configuration
    static Apttus_Config2__ProductConfiguration__c createProdConfig1(Id proposalId){
        Apttus_Config2__BillingPreference__c bp = new Apttus_Config2__BillingPreference__c(Name = 'Test Billing Preference');
        insert bp;
        Apttus_Config2__ProductConfiguration__c prodConfig = 
                    new Apttus_Config2__ProductConfiguration__c(Apttus_QPConfig__Proposald__c = proposalId,
                                                                Apttus_Config2__Status__c = 'New',
                                                                Apttus_Config2__BillingPreferenceId__c = bp.Id);
        insert prodConfig;
        return prodConfig;
    }
    
    //Static method to create proposal line item test record
    static Apttus_Proposal__Proposal_Line_Item__c createProposalLineItem(Integer iNumber, Id PropId, Id optId, String ipStatus){
        //Setup the test records required to create the Proposal test record
        Product2 prod = createProduct('Test Process Technology1', 'PROCESSTECH0002', Null, 'PROCESSTECHCOM0002');
        //insert prod;
                                                         
        //Create a proposal line item
        Apttus_Proposal__Proposal_Line_Item__c proposalLineItem = 
              new Apttus_Proposal__Proposal_Line_Item__c(Apttus_QPConfig__LineNumber__c = iNumber,
                                                         Apttus_QPConfig__ItemSequence__c = iNumber,
                                                         Apttus_Proposal__Product__c = prod.Id,
                                                         Apttus_Proposal__Proposal__c = propId,
                                                         Apttus_QPConfig__OptionId__c = optId,
                                                         IP_Approval_Status__c = ipStatus);
                                                         
        //insert proposalLineItem;
        return proposalLineItem;
    }
    
    private static Account getAccount(string AccountName){
        Account acct = [SELECT Id, Name FROM Account Where Name =: AccountName];
        
        return acct;
    }
}