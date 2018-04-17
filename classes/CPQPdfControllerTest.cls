@isTest
private class CPQPdfControllerTest {
    @testSetup
     static void testDataSetup(){
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
        fieldValueMap.put('Name','Test Opportunity');
        fieldValueMap.put('AccountId',acctId);
        fieldValueMap.put('StageName','1. Discovery');
        fieldValueMap.put('CloseDate',Date.Today().addDays(10));
        fieldValueMap.put('Target_Process_Node__c','14XM');
        fieldValueMap.put('Market_Segment__c','Mobility');
        fieldValueMap.put('Process_Platform__c','GF Baseline');
        fieldValueMap.put('Fab_Split__c',100);
        fieldValueMap.put('Process_Geometry__c',processGeometry); //'0.60UM'
        fieldValueMap.put('Process_Family__c','Super Low Power');
                
        return OpportunityDataFactory.createOpportunity(fieldValueMap).Id;
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
    
    static Id CreateMaskSetTitle(){
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
    static testMethod void DeviceTriggerTest1() {
        
        string acctId = getAccount('MYTEST ACCOUNT1').id;
        string opptyId = CPQPdfControllerTest.createOpp(acctId, '0.60UM');
        string opptyProgramId = CPQPdfControllerTest.createOppProg(acctId, opptyId);
        
        test.startTest();
            // Create Device
             Device__c device = createCMPWDevice(acctId,opptyProgramId);
            //device.Actual_Tapeout_Date__c = date.today().adddays(2);
            //device.Actual_Tapeout_Date_GMT__c = date.today().adddays(2);
            //device.Stage__c = 'Tapeout';
            //insert device;
            
            Apttus_Proposal__Proposal__c prop = createProposal(acctId, opptyId, device.Id, Null, Null); 
            prop.Free_Devices__c = 'abcd<:>efgh';
            prop.SRAM_Sizes__c = 'abcd>:<123<:>efgh>:<345';
            update prop;
           
           PageReference pg = Page.CPQ_Proposal_Pdf;
           ApexPages.CurrentPage().getParameters().put('id',prop.Id);
           test.stopTest();
           CPQProposalPDFController controll = new CPQProposalPDFController();
           CPQProposalPDFController.WrapIps wr = new CPQProposalPDFController.WrapIps(new Apttus_Proposal__Proposal_Line_Item__c());
           wr.ipid = 'q23';
           wr.device = '123';           
           CPQProposalPDFController.SRAMWrapper sram = new CPQProposalPDFController.SRAMWrapper('abc');
           sram.prodName = 'test';
           sram.size = '200kb';
           sram = new CPQProposalPDFController.SRAMWrapper('abc','12');
           
           controll.savePDF();
        
        
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
                                                     Mask_Set__c = szMaskSet, //changed reference of Mask_Set__c to Mask_Set_Long__c for the Case#00051463
                                                     //Mask_Set_Long__c = szMaskSet,                                                      
                                                     Apttus_Proposal__Opportunity__c = oppId,
                                                     Apttus_Proposal__Account__c = accId,
                                                     RecordTypeId = recType.Id,
                                                     APTPS_Primary__c = true);
        
        insert proposal;
        return proposal;
    } 
    
    private static Account getAccount(string AccountName)
    {
        Account acct = [SELECT Id, Name FROM Account Where Name =: AccountName];
        
        return acct;
    }  
}