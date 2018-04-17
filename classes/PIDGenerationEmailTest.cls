/*
Author:      Ariz Solito
Description: Testclass for PIDGenerationEmail
History:
    Asolito        12022015    - Apex class created
*/

@isTest(SeeAllData=false)
public class PIDGenerationEmailTest{    
    @testSetup
     static void testDataSetup(){
        DataUtilTest.loadEnvironmentVariables();
        
         Map<String,Object> fieldValueMap = new Map<String,Object>();       
        fieldValueMap.put('Name', 'testing701');
        fieldValueMap.put('Stage__c', 'Unqualified');
        fieldValueMap.put('Short_Name__c', 'test725');
        fieldValueMap.put('Site_Department__c', 'cts.com');
        fieldValueMap.put('Account_Type__c', 'Customer');
        fieldValueMap.put('Organization_Unit__c', 'sg;us');
        fieldValueMap.put('Copy_Address__c', true);
        fieldValueMap.put('Corporate_Address_1__c', 'test');
        fieldValueMap.put('Corporate_City__c', 'sg');
        fieldValueMap.put('Corporate_Country__c', 'sg');        
        fieldValueMap.put('Financial_Territory__c', 'Greater China');
        fieldValueMap.put('Region__c', 'APJ');
        fieldValueMap.put('Sub_Type__c', 'Direct');
        fieldValueMap.put('Transaction_Type__c', 'Transactional');
        fieldValueMap.put('Account_Profile__c', 'Fabless - Emerging');
        fieldValueMap.put('Corporate_Postal_Zip_Code__c', '700007');
        fieldValueMap.put('Fab_9_10__c', 'No');
        fieldValueMap.put('recordtypeid', EnvironmentVariable.get('ACCT_RT_ID_CUSTOMER'));       
        AccountDataFactory.createAccount(fieldValueMap);
        
     }
    static ID createAccount() {
        // Create Account
        Account testAcct = getAccount('testing701');
        return testAcct.ID;
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
    
    static ID createOpportunity(ID testAcctID) {
        // Create Opportunity
        Map<String,Object> fieldValueMap = new Map<String,Object>();
        fieldValueMap.put('AccountId',testAcctID);
        fieldValueMap.put('Name','Test Opportunity');  
        fieldValueMap.put('StageName','1. Discovery');
        fieldValueMap.put('CloseDate',Date.Today().addDays(10));  
        fieldValueMap.put('Target_Process_Node__c','14XM');
        fieldValueMap.put('Market_Segment__c','Mobility');  
        fieldValueMap.put('Process_Platform__c','GF Baseline');
        fieldValueMap.put('Fab_Split__c',100);          
        fieldValueMap.put('Process_Geometry__c','0.055UM');  
        fieldValueMap.put('Process_Family__c','Generic / Nominal');
        
        return OpportunityDataFactory.createOpportunity(fieldValueMap).id;
        
    }
        
    static ID createOpportunityProgram(ID testAcctID, ID testOpptyID) {
        // Create Opportunity Program
        Opportunity_Program__c testOpptyProgram = new Opportunity_Program__c(
            name = 'Test Opportunity Program',
            account__c = testAcctID,
            opportunity__c = testOpptyID
        );
        
        Insert testOpptyProgram;        
        return testOpptyProgram.ID;
    }
    
    /*static ID createDevice( ID testOpptyProgramID) {
        // Create Device
        Device__c device = new Device__c(        
            name = 'TESTDEVICEZAIH12345677.00',
            opportunity_Program__c = testOpptyProgramID,
            fab__c = 'FAB 3',
            GSOP_assignment_tapeout_plan__c = 'No',
            market_segment__c = 'Mobility',
            semiconductor_device__c = 'Analog Amplifier',
            end_customer__c = 'Test Customer',
            end_application__c = 'Others - Consumer',
            device_sourcing__c = '1st Source',
            stage__c = 'Solutioning',
            status__c = 'Active',
            tapeout_type__c = 'Single Product',
            geometry_filter__c = '0.055UM',
            process_family_filter__c = 'MEMS',
            current_forecast_tapeout_date__c = date.today(),
            forecasted_lot_start_date__c = date.today().addDays(10),
            device_mask_set_title__c = 'DVM1234',
            confidence_level_tapeout__c = '50',
            confidence_level_volume__c = '50',           
            reticle_type__c = 'Single Layer Reticle (SLR)',
            automotive_device__c = 'No',
            special_scribe_width__c = 'NA',
            process_technology_number__c = 'PT003055',
            BX041_submission_date__c = date.today()                      
        );
        
        
        Insert device;        
        return device.id;
    }*/
    
    //Static method to create proposal test record
    static Apttus_Proposal__Proposal__c createProposal(ID accID, ID oppID, ID devID,ID processId){  
        //Setup the test records required to create the Proposal test record
        RecordType recType = [Select Id
                                From RecordType 
                               Where Name='Draft' And
                                     SobjectType = 'Apttus_Proposal__Proposal__c'];  
                                           
        //Create a proposal from Device
        Apttus_Proposal__Proposal__c proposal = new Apttus_Proposal__Proposal__c(
                                                     Apttus_Proposal__Description__c = 'Test Proposal Description ...',
                                                     Device__c = devID,                                                     
                                                     Apttus_Proposal__Opportunity__c = oppID,
                                                     Apttus_Proposal__Account__c = accID,                                                   
                                                     sram__c = 'Yes',
                                                     sram_gate_orientation__c = 'Horizontal',
                                                     aclv_gate_orientation__c = 'Horizontal',
                                                     gate_orientation_PFET__c = 'Horizontal',
                                                     ptrf_rotation__c = '90',
                                                     apttus_proposal__approval_stage__c = 'Submitted Phase',
                                                     process_technology__c = 'PT002562',
                                                     approval_check__c = true,
                                                     Assigned_Process_ID__c = processId);
        
        insert proposal;
        return proposal;
    } 
    
    //Static method to create proposal line item test record
    static void createProposalLineItem(String configID){        
        
        Apttus_Proposal__Proposal_Line_Item__c lineItem = new Apttus_Proposal__Proposal_Line_Item__c(
                                                             Apttus_Proposal__Proposal__c = configID,
                                                             Apttus_QPConfig__ItemSequence__c = 1);
        
        insert lineItem;    
    }
    
    //Static method to create product test record
    static Process__c createProcess(String szName, String szMaskLayers, String szPIDNumber, String szProcessTech){
        //Create a proposal line item
        Process__c process = new Process__c(Name = szName,
                                            Mask_Layers__c = szMaskLayers,
                                            PID_Number__c = szPIDNumber,
                                            Process_Technology__c = szProcessTech);
        
        //insert process;
        return process;
    }            
   
    static testmethod void testEmailSend1(){                
        
        User admin = DeviceChecklistTestDataUtils.createUserWithDCAdmin('System Administrator');
        System.runAs(admin){
            IntegrationUsers__c skipUser = new IntegrationUsers__c(SetupOwnerId = admin.Id, Is_Integration_User__c= true, Skip_Trigger__c = true, Skip_Validation_Rule__c = true);
            insert skipUser;
            String acctID = PIDGenerationEmailTest.createAccount();
            String opptyID = PIDGenerationEmailTest.createOpportunity(acctID);
            String OpptyPrgmID = PIDGenerationEmailTest.createOpportunityProgram(acctID, opptyID);
            Device__c dev = createCMPWDevice(acctID,OpptyPrgmID);
            //PIDGenerationEmailTest.createDevice(OpptyPrgmID);        
            String devID = dev.Id;
            Process__c pid1 = createProcess('Test PID 1', 'BB,CC,DD,EE', 'TESTPID000001', 'TestPTNumber001');
            insert pid1;
                                   
             
            
            //Test configuration with line item
            Test.startTest();
            Apttus_Proposal__Proposal__c testConfig = createProposal(acctID,opptyID,devID,pid1.Id);        
            
            createProposalLineItem(testConfig.ID);                                  
            
            Approval.ProcessSubmitRequest req1 = new Approval.ProcessSubmitRequest();
            req1.setComments('Submitting request for approval.');
            req1.setObjectId(testConfig.id);        
            //Approval.ProcessResult result = Approval.process(req1);                
    
            PIDGenerationEmail.sendEmail(testConfig); 
            
            Test.stopTest();      
                                       
        
        }    
    }
    
    static testmethod void testEmailSend2(){                
        
        User admin = DeviceChecklistTestDataUtils.createUserWithDCAdmin('System Administrator');
        System.runAs(admin){
            IntegrationUsers__c skipUser = new IntegrationUsers__c(SetupOwnerId = admin.Id, Is_Integration_User__c= true, Skip_Trigger__c = true, Skip_Validation_Rule__c = true);
            insert skipUser;
            String acctID = PIDGenerationEmailTest.createAccount();
            String opptyID = PIDGenerationEmailTest.createOpportunity(acctID);
            String OpptyPrgmID = PIDGenerationEmailTest.createOpportunityProgram(acctID, opptyID);
            Device__c dev = createCMPWDevice(acctID,OpptyPrgmID);
            //PIDGenerationEmailTest.createDevice(OpptyPrgmID);        
            String devID = dev.Id;
            Process__c pid1 = createProcess('Test PID 1', 'BB,CC,DD,EE', 'TESTPID000001', 'TestPTNumber001');
            insert pid1;
                                   
            Test.startTest(); 
            
            
            
            
            //Test configuration with no line item
            Apttus_Proposal__Proposal__c testConfig2 = createProposal(acctID,opptyID,devID,pid1.Id); 
            
            Approval.ProcessSubmitRequest req2 = new Approval.ProcessSubmitRequest();
            req2.setComments('Submitting request for approval.');
            req2.setObjectId(testConfig2.id);        
            Approval.ProcessResult result2 = Approval.process(req2);                
    
            PIDGenerationEmail.sendEmail(testConfig2);        
                               
            Test.stopTest();
        
        }    
    } 
    
             private static Account getAccount(string AccountName)
            {
                Account testAcct= [SELECT Id, Name FROM Account Where Name =: AccountName];
        
                return testAcct;
            }       
}