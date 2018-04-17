@isTest
private class SRAMDevicesControllerTest {
    @testSetup
     static void testDataSetup(){
        DataUtilTest.loadEnvironmentVariables();
        Map<String,Object> fieldValueMap = new Map<String,Object>();            
        fieldValueMap.put('Name', 'Test Account 009');            
        fieldValueMap.put('stage__c', 'Unqualified');
        fieldValueMap.put('short_name__c', 'Test007');
        fieldValueMap.put('sub_type__c', 'Direct');
        fieldValueMap.put('site_department__c', 'IT');          
        fieldValueMap.put('transaction_type__c', 'Non-Transactional');
        fieldValueMap.put('account_profile__c', 'Fabless - Emerging');            
        fieldValueMap.put('Process_Tech_Interested__c', 'Mature (> 0.11um)');
        fieldValueMap.put('region__c', 'US');
        fieldValueMap.put('Sales_Territory__c', 'Greater China');
        fieldValueMap.put('financial_territory__c', 'Greater China');          
        fieldValueMap.put('Copy_Address__c', true);
        fieldValueMap.put('Corporate_Address_1__c', 'Test Address 1');
        fieldValueMap.put('Corporate_Address_2__c', 'Test Address 2');
        fieldValueMap.put('Corporate_Address_3__c', 'Test Address 3');
        fieldValueMap.put('Corporate_Address_4__c', 'Test Address 4');            
        fieldValueMap.put('Corporate_Country__c', 'Test Country');
        fieldValueMap.put('Corporate_City__c', 'Test City');
        fieldValueMap.put('Corporate_State__c', 'Test State');
        fieldValueMap.put('Corporate_Postal_Zip_Code__c', '700007');
        fieldValueMap.put('Organization_Unit__c', 'GF Investment LLC OU');
        fieldValueMap.put('bill_to_location__c', 'test');
        fieldValueMap.put('total_employee__c', 7);          
        fieldValueMap.put('end_customer__c', 'people');
        fieldValueMap.put('Revenue_Potential__c', 'Low Potential');            
        fieldValueMap.put('Target_Account__c', 'Yes');
        fieldValueMap.put('Fab_9_10__c','No');
        fieldValueMap.put('Bill_To_Address_1__c','Test Address');
        fieldValueMap.put('Account_Profile__c','Fabless - Emerging');
        fieldValueMap.put('Bill_To_City__c','Test City');
        fieldValueMap.put('Bill_To_Country__c','India');
        AccountDataFactory.createAccount(fieldValueMap);
        
     }
   static Id createAccount() {
        // Create Account
         Account acct= getAccount('Test Account 009');
         return acct.id;
    }
    
    //static method to create product configuration
    static Apttus_Config2__ProductConfiguration__c  createProductConfig(String propID){
        Apttus_Config2__ProductConfiguration__c tempconfig = new Apttus_Config2__ProductConfiguration__c();
            tempconfig.name = 'testconfig';
            tempconfig.Apttus_QPConfig__Proposald__c = propID;
            tempconfig.Apttus_Config2__Status__c = 'Finalized';
        insert tempconfig ;
        return tempconfig;
    }
    
    static Id createOpp(Id acctId, string processGeometry) {
        // Create Opportunity
        Map<String,Object> fieldValueMap = new Map<String,Object>();
        fieldValueMap.put('AccountId',acctId);
        fieldValueMap.put('Name','Test Opportunity');  
        fieldValueMap.put('StageName','1. Discovery');
        fieldValueMap.put('CloseDate',Date.Today().addDays(10));  
        fieldValueMap.put('Target_Process_Node__c','14XM');
        fieldValueMap.put('Market_Segment__c','Mobility');  
        fieldValueMap.put('Process_Platform__c','GF Baseline');
        fieldValueMap.put('Fab_Split__c',100);          
        fieldValueMap.put('Process_Geometry__c',processGeometry);  
        fieldValueMap.put('Process_Family__c','Super Low Power');
        fieldValueMap.put('Opportunity_Sourcing_Type__c','First Source');  
        fieldValueMap.put('Fab_Assignment_1__c','FAB 1');
         
        return OpportunityDataFactory.createOpportunity(fieldValueMap).id;
        
    }
    
    static Id createOppProg(Id acctId,Id oppId) {
        // Create Opportunity Program
        Opportunity_Program__c testOpptyProgram = new Opportunity_Program__c();
        testOpptyProgram.Name = 'Test Opportunity Program';
        testOpptyProgram.Account__c = acctId;
        testOpptyProgram.Opportunity__c = oppId;
        
        insert testOpptyProgram;
        return testOpptyProgram.Id;
    }
        static testMethod void DeviceTriggerTest1() {

        string acctId = SRAMDevicesControllerTest.createAccount();
        string opptyId = SRAMDevicesControllerTest.createOpp(acctId, '0.60UM');
        string opptyProgramId = SRAMDevicesControllerTest.createOppProg(acctId, opptyId);
        
        test.startTest();
            // Create Device
             Device__c device = DeviceUtilTest.createCMPWDevice(acctId,opptyProgramId);
            //device.Actual_Tapeout_Date__c = date.today().adddays(2);
            //device.Actual_Tapeout_Date_GMT__c = date.today().adddays(2);
            //device.Stage__c = 'Tapeout';
            insert device;
            
            Apttus_Proposal__Proposal__c prop = createProposal(acctId, opptyId, device.Id, Null, Null); 
            prop.Free_Devices__c = 'abcd<:>efgh';
            prop.SRAM_Sizes__c = 'abcd>:<123<:>efgh>:<345';
            update prop;
           
           PageReference pg = Page.CPQ_Proposal_Pdf;
           ApexPages.CurrentPage().getParameters().put('id',prop.Id);
           SRAM_Devices_Controller controll = new SRAM_Devices_Controller(new ApexPages.StandardController(prop));
           controll.saveSramSize();
       controll.goToEdit();
        test.stopTest();
        
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
                                                     //Mask_Set__c = szMaskSet, changed reference of Mask_Set__c to Mask_Set_Long__c for the Case#00051463
                                                     Mask_Set_Long__c = szMaskSet,
                                                     Apttus_Proposal__Opportunity__c = oppId,
                                                     Apttus_Proposal__Account__c = accId,
                                                     RecordTypeId = recType.Id,
                                                     APTPS_Primary__c = true);
        
        insert proposal;
        return proposal;
    }   
    
     private static Account getAccount(string AccountName)
    {
        Account acctId= [SELECT Id, Name FROM Account Where Name =: AccountName];
        
        return acctId;
    }  
    
}