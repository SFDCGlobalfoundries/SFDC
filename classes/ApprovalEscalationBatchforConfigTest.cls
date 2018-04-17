/******************************************************************************************************************************
Class:         ApprovalEscalationBatchforConfigTest
-------------------------------------------------------------------------------------------------------------------------------
Author:        Karna Shiva (GF - 1016934)
Created Date:  06/04/2016
Reason:        Batch class will send escalation email to Approvers managers when approval request is pending more than equals to
               5 days.
History:       

*******************************************************************************************************************************/

@isTest(SeeAllData=false)
private class ApprovalEscalationBatchforConfigTest{
    @testSetup
     static void testDataSetup(){
        DataUtilTest.loadEnvironmentVariables();
        ConfiguratorApprovalSetting__c obj=new ConfiguratorApprovalSetting__c(Default_Approver__c=UserInfo.getUserId(),FAB_Name__c='FAB 2,FAB 3,FAB 3E,FAB 7,FAB 5,FAB 6',Maximum_Approver__c=15);
        insert obj;
     }
 
      static testMethod void testProposalApprovalCheck(){
        //Setup the Proposal test record types and cause the insert trigger to excecute
        Id accId = createAccountNew();        
        Id oppId = createOpportunityNew(accId);            
        Id oppProgId = createOpportunityProgramNew(accId,oppId);       
        Device__c dev = DeviceUtilTest.createCMPWDevice(accId,oppProgId);
        Test.startTest(); 
        Insert dev;
        dev.Fab__c = 'FAB 9';
        update dev;
        //createDeviceNew(oppProgId);
        
        
            Apttus_Proposal__Proposal__c testConfig = createProposalNew(accId,oppId,dev.Id);                      
            
            //Internal user approver
            testConfig.approval_check__c = false;
            update testConfig;
            
            Approval.ProcessSubmitRequest req1 = new Approval.ProcessSubmitRequest();
            req1.setComments('Submitting request for approval.');
            req1.setObjectId(testConfig.id);        
            Approval.ProcessResult result = Approval.process(req1); 
               
           String ObjectName='Apttus_Proposal__Proposal__c',status1='Pending';
        Integer days=0;
        
        ApprovalEscalationBatchConfig c = new ApprovalEscalationBatchConfig(ObjectName,days,status1);
        Database.executeBatch(c); 
     
        Test.stopTest();
        
    }
  
  static ID createAccountNew() {
        // Create Account
        Account testAcct = new Account(
            name = 'Test Account',
            stage__c = 'Unqualified',
            site_department__c = 'Test Department',
            sub_type__c = 'Direct',
            transaction_type__c = 'Transactional',
            region__c = 'APJ',
            bill_to_address_1__c = 'Test Address 1',
            corporate_address_1__c = 'Corporate Address 1',
            bill_to_city__c = 'Test City',
            corporate_city__c = 'Test City',
            bill_to_country__c = 'Singapore',
            corporate_country__c = 'Singapore',
            short_name__c = 'TA123'
        );

        Insert testAcct;       
        
        return testAcct.ID;
    }

  static ID createOpportunityNew(ID testAcctID) {
        // Create Opportunity
        Opportunity testOppty = new Opportunity(
            name = 'Test Opportunity',
            accountID = testAcctID,
            stageName = '1. Discovery',
            closeDate = Date.Today().addDays(10),
            target_process_node__c = '14XM',
            market_segment__c = 'Mobility',
            process_platform__c = 'GF Baseline',
            fab_split__c = 100,
            process_geometry__c = '0.055UM',
            process_family__c = 'Generic / Nominal'
        );

        Insert testOppty;  
        return testOppty.ID;
    }
   
    static ID createOpportunityProgramNew(ID testAcctID, ID testOpptyID) {
        // Create Opportunity Program
        Opportunity_Program__c testOpptyProgram = new Opportunity_Program__c(
            name = 'Test Opportunity Program111',
            account__c = testAcctID,
            opportunity__c = testOpptyID
        );

        Insert testOpptyProgram;        
        return testOpptyProgram.ID;
    }
    
    static Device__c createDeviceNew(id acctid,  ID testOpptyProgramID) {
        // Create Device
        Device__c device = new Device__c(        
            name = 'TESTDEVICEZAIH1234f5677.00',
            opportunity_Program__c = testOpptyProgramID,
            fab__c = 'FAB 3',
            Account__c  = acctid,
            GSOP_assignment_tapeout_plan__c = 'No',
            market_segment__c = 'Mobility',
            End_Application__c = 'Tablet',
            semiconductor_device__c = 'Analog Amplifier',
            end_customer__c = 'Test Customer',
            device_sourcing__c = '1st Source',
            stage__c = 'Solutioning',
            status__c = 'Active',
            tapeout_type__c = 'Customer MPW',
            geometry_filter__c = '0.055UM',
            process_family_filter__c = 'MEMS',
            current_forecast_tapeout_date__c = date.today(),
            forecasted_lot_start_date__c = date.today().addDays(10),
            //device_mask_set_title__c = 'MPW12333',
            confidence_level_tapeout__c = '50',
            confidence_level_volume__c = '50',           
            reticle_type__c = 'Single Layer Reticle (SLR)',
            automotive_device__c = 'No',
            special_scribe_width__c = 'NA',
            process_technology_number__c = 'PT1002562',
            BX041_submission_date__c = date.today()            
        );
        
   
        Insert device;    
        return device;
    }
  
    
    //Static method to create proposal test record
    static Apttus_Proposal__Proposal__c createProposalNew(ID accID, ID oppID, ID devID){    
        //Setup the test records required to create the Proposal test record
        RecordType recType = [Select Id
                                From RecordType 
                               Where Name='Draft' And
                                     SobjectType = 'Apttus_Proposal__Proposal__c'];        
            
        Product2 processTech = createProduct('Test Process Technology', 'PROCESSTECH0001', null, 'PROCESSTECHCOM0003');        
        Process__c pid1 = createProcess('Test PID 1', 'BB,CC,DD,EE', 'TESTP1ID000001', processTech.PT_Number__c);

        
        //Create a proposal from Device
        Apttus_Proposal__Proposal__c proposal = 
                    new Apttus_Proposal__Proposal__c(Apttus_Proposal__Description__c = 'Test Proposal Description ...',
                                                     Device__c = devID,                                                     
                                                     Apttus_Proposal__Opportunity__c = oppID,
                                                     Apttus_Proposal__Account__c = accID,                                                   
                                                     sram__c = 'Yes',
                                                     sram_gate_orientation__c = 'Horizontal',
                                                     aclv_gate_orientation__c = 'Horizontal',
                                                     gate_orientation_PFET__c = 'Horizontal',
                                                     ptrf_rotation__c = '90',
                                                     Devices__c='Test<:>Test3',
                                                     Purpose_of_the_Configuration__c='Final',
                                                     apttus_proposal__approval_stage__c = 'Configuration Design Phase',
                                                     process_technology__c = 'PT1002562',
                                                     Assigned_Process_ID__c = pid1.Id,
                                                     approval_check__c = false);
        insert proposal;
        return proposal;
    } 
    
    
    //Static method to create product test record
    static Product2 createProduct(String szName, String szCode, String szMaskSet, String szProductFamily){
        //Create a proposal line item
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
    static Process__c createProcess(String szName, String szMaskLayers, String szPIDNumber, String szProcessTech){
        //Create a proposal line item
        Process__c process = new Process__c(Name = szName,
                                            Mask_Layers__c = szMaskLayers,
                                            PID_Number__c = szPIDNumber,
                                            Process_Technology__c = szProcessTech);
        insert process;
        return process;
    
    }
     
}