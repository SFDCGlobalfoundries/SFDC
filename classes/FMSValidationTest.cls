/*
Author: Anirban Roy
Description: This is the test class for FMSValidation.
History:
ARoy        06112017    - code creation.              
*/
@isTest(SeeAllData=false)
public class FMSValidationTest {
    
    @testSetup
    static void testDataSetup(){
        DataUtilTest.loadEnvironmentVariables();               
    }
    
    public static Device__c createDevice(Id accId, Id oppId, Id oppProgId){
        Map<String,Object> fieldValueDevMap = new Map<String,Object>();
        fieldValueDevMap.put('Name' , 'TESTDEVICESP1');
        fieldValueDevMap.put('Confidence_Level_Tapeout__c' , '150');
        fieldValueDevMap.put('Expose_Device_to_Customer__c' , false ); 
        fieldValueDevMap.put('Enabled_via_previous_MPW_1__c','No');
        fieldValueDevMap.put('CRMDID__c' , '123456');
        fieldValueDevMap.put('Device_Mask_Set_Title__c' , 'MSTT1');
        fieldValueDevMap.put('GSOP_Assignment_Tapeout_Plan__c' , 'No');
        fieldValueDevMap.put('Market_Segment__c' , 'Automotive1');
        fieldValueDevMap.put('Semiconductor_Device__c' , 'Analog Amplifier1');
        fieldValueDevMap.put('End_Customer__c' , 'Test Customer1');
        fieldValueDevMap.put('Device_Sourcing__c' , '1st Source1');
        fieldValueDevMap.put('Stage__c' , 'Design In');
        fieldValueDevMap.put('Status__c' , 'Active');
        fieldValueDevMap.put('Tapeout_Type__c' , 'Single Product');
        fieldValueDevMap.put('PLM_Device_ID__c' , 'ANBQP60ACO8CH-U02');
        fieldValueDevMap.put('Actual_Tapeout_Date__c' , datetime.now());
        fieldValueDevMap.put('Process_Family_Filter__c' , 'Super Low Power');
        fieldValueDevMap.put('reticle_type__c' , 'Small Field Reticle (SFR)');
        fieldValueDevMap.put('Geometry_Filter__c' , '0.10UM');
        fieldValueDevMap.put('Confidence_Level_Tapeout__c' , '100');
        fieldValueDevMap.put('End_Application__c' , 'Powertrain');
        fieldValueDevMap.put('Original_Forecasted_Tapeout_Date__c' , date.today());
        fieldValueDevMap.put('PTRF_ID__c' , 'test');
        fieldValueDevMap.put('End_Application__c' , 'Body');
        fieldValueDevMap.put('Device_Type__c' , 'Retrofit');
        fieldValueDevMap.put('Opportunity_Program__c' , oppProgId);
        Device__c dev = DeviceDataFactory.createDevice(fieldValueDevMap);
        return dev; 
    }
    
    static testMethod void testFMSValidation(){
        
        System.runAs(FMSDataFactory.testUser){
            FMSDataFactory.intUserCreation();
            Map<String,Object> accFieldMap = new Map<String,Object>{'Name' => 'GLOBAL FOUNDRIES','Site_Department__c' => 'Test Site 1', 'Sub_Type__c' => 'Direct', 'Transaction_Type__c' => 'Transactional',
                'Region__c' => 'APJ', 'Corporate_Address_1__c' => 'Test Bill To Address 1', 'Corporate_City__c' => 'Singapore', 'Corporate_Country__c' => 'Singapore'  };       
                    accFieldMap.put('Fab_9_10__c','Yes');
            accFieldMap.put('Customer_Category__c','TFA');
            accFieldMap.put('Tech_Geo_Granted__c','0.007UM'+';'+'0.010UM');
            accFieldMap.put('SAP_Account_Number__c', '006104');
            Account acc = AccountDataFactory.createAccount(accFieldMap);
            
            Map<String,Object> oppFieldMap = new Map<String,Object>{'Name'=>'GLOBAL FOUNDRIES OPP DUMMY','AccountId'=>acc.Id,'StageName'=>'1. Discovery','Market_Segment__c'=>'Automotive',
                'Target_Process_Node__c'=>'14XM','Process_Platform__c'=>'GF Baseline','Opportunity_Sourcing_Type__c'=>'First Source',
                'Process_Geometry__c' => '0.09UM','Process_Family__c' => 'Generic / Nominal',
                'Fab_Split__c'=>100,'CloseDate' => date.newinstance(2012, 12, 21), 'Product_Line__c'=>'Leading Edge'};
                    Opportunity opp = OpportunityDataFactory.createOpportunity(oppFieldMap);
            
            Map<String,Object> oppProgFieldMap= new Map<String,Object>{'Name'=>'GLOBAL FOUNDRIES OPP DUMMY','Account__c'=>acc.Id,'Opportunity__c'=>opp.Id};
                Opportunity_Program__c opProg = OpportunityProgramDataFactory.createOpportunityProgram(oppProgFieldMap);
            
            Device__c dev = createDevice(acc.Id,opp.Id,opProg.Id);
            FMS_Original_Flow_Mapping__c fmsOrgMap = new FMS_Original_Flow_Mapping__c(Technology__c = 'TestTech_FMS', Section__c = 'Embedded DRAM Options', IsRequired__c=true);
            try{
                insert fmsOrgMap;
            }catch(Exception e){
                UtilityCls.saveExceptionLog(FMSValidationTest.class.getName(), 'testFMSValidation()', '', 'Bug', '', '', 'Error', e.getTypeName(), 'FMS', e, 0);
            }
            Map<String,Object> fieldValueFMSMap = new Map<String,Object>{
                'Device__c' => dev.Id,
                    'Customer_Name__c' => acc.Id,
                    'Name__c' => 'Test Name',
                    'Form_Name__c' => 'Test Main Form',                 
                    'Form_Description__c' => 'Test Description', 
                    'Technology__c' => 'CSOI 7RF', 
                    'TestServices__c' => 'Yes', 
                    'Packaging_Services__c' => 'No',                    
                    'Chip_Interconnect__c' => 'Wirebond', 
                    'QuoteOnly__c' => 'No',
                    'ServiceOptions__c' => 'Dicing',
                    'AppName__c' => 'Test 1'+','+'Test 2',
                    'AppEmail__c' => 'test@gmail.com',
                    'DesignSubmission__c' => 'Single Chip (one GDS)', 
                    'InputMethod__c' =>'Advanced Process: Inputs via XML file attachment.', 
                    'Phone__c' => '9999999999',
                    'Email__c' => 'test@gmail.com',
                    'FileAttachment__c' => 'Test Attachment',
                    'AdvancedProcessFileAttachment__c' => 'Test Attachment',
                    'StepPlanRotationActive__c' => null,
                    //SelAppId__c = 'test',
                    'LastMetalUsed__c' => 'AM (Analog Metal) (MT, FT, AM) (70P5485)', 'State_of_the_Form__c' => 'Draft'};
                        Form_Management_System__c  formObj = FMSDataFactory.createFMSRecord(fieldValueFMSMap,FMSDataFactory.FormType.MAIN , true);      
            
            Test.startTest();
            Apttus_Proposal__Proposal__c proposal = createProposal(acc.Id, opp.Id, dev.Id, formObj.id, null);
            String proposalId = proposal.Id;
            String prodConfigId = createProdConfig(proposalId);
            
            Product2 ip1 = createOptionProduct('Test Add Ques', 'RF', 'TESTAddQues0001', 'AA');
            try{
                insert ip1;
            }catch(Exception e){
                UtilityCls.saveExceptionLog(FMSValidationTest.class.getName(), 'testFMSValidation()', '', 'Bug', '', '', 'Error', e.getTypeName(), 'FMS', e, 0);
            }
            System.assertNotEquals(null,ip1.Id);
            
            Apttus_Proposal__Proposal_Line_Item__c pl = createProposalLineItem(1, proposal.Id, ip1.Id,prodConfigId);            
            try{
                insert pl;
            }catch(Exception e){
                UtilityCls.saveExceptionLog(FMSValidationTest.class.getName(), 'testFMSValidation()', '', 'Bug', '', '', 'Error', e.getTypeName(), 'FMS', e, 0);
            }
            System.assertNotEquals(null,pl.Id); 
            
            ApexPages.currentPage().getParameters().put('retId',proposalId);
            ApexPages.currentPage().getParameters().put('visualforce','true');
            ApexPages.currentPage().getParameters().put('Id',prodConfigId);                
            FMSValidation fmsVal = new FMSValidation();
            System.assertEquals(null,fmsVal.checkMandatory());
            Test.stopTest();
        }
    }        
    
    static Apttus_Proposal__Proposal__c createProposal(Id accId, Id oppId, Id devId, Id formId, Id tmrmId){
        RecordType recType = [Select Id
                              From RecordType 
                              Where Name='Multi Source Proposal from Teamroom' And
                              SobjectType = 'Apttus_Proposal__Proposal__c'];
        
        Apttus_Proposal__Proposal__c proposal = 
            new Apttus_Proposal__Proposal__c(Apttus_Proposal__Description__c = 'Test Proposal Description ...',
                                             Device__c = devId,                                                     
                                             Apttus_Proposal__Opportunity__c = oppId,
                                             Apttus_Proposal__Account__c = accId,
                                             FMS_Proposal__c = formId,
                                             RecordTypeId = recType.Id);
        
        try{
            insert proposal;
        }catch(Exception e){
            UtilityCls.saveExceptionLog(FMSValidationTest.class.getName(), 'createProduct()', '', 'Bug', '', '', 'Error', e.getTypeName(), 'FMS', e, 0);
        }
        return proposal;
    }
    
    static Product2 createOptionProduct(String szName, String szFamily, String szCode, String szMaskSet){
        Product2 prod = new Product2(Name = szName,
                                     Family = szFamily,
                                     ProductCode = szCode,
                                     Product_External_ID__c = szCode + Math.Random(),
                                     APTPS_Core_Voltage__c = '1.50',
                                     APTPS_IO_Voltage__c = '1.50',
                                     Geometry__c = '0.028nm',
                                     Mask_Sets__c = szMaskSet,
                                     IsActive = True);
        
        return prod;
    }
    
    static Apttus_Proposal__Proposal_Line_Item__c createProposalLineItem(Integer iNumber, Id PropId, Id optId, Id configId){
        Product2 prod = createProduct('TestTech_FMS', 'TestTech_FMS', Null, 'PROCESSTECHCOM0001');
        
        Apttus_Proposal__Proposal_Line_Item__c proposalLineItem = 
            new Apttus_Proposal__Proposal_Line_Item__c(Apttus_QPConfig__LineNumber__c = iNumber,
                                                       Apttus_QPConfig__ItemSequence__c = iNumber,
                                                       Apttus_Proposal__Product__c = prod.Id,
                                                       Apttus_Proposal__Proposal__c = propId,
                                                       Apttus_QPConfig__OptionId__c = optId,
                                                       Apttus_QPConfig__ConfigurationId__c = configId/*,
Apttus_QPConfig__AttributeValueId__c = attrib.Id*/);
        
        return proposalLineItem;
    }
    
    static Product2 createProduct(String szName, String szCode, String szMaskSet, String szProductFamily){
        Product2 prod = new Product2(Name = szName,
                                     Family = szProductFamily,
                                     ProductCode = szCode,
                                     Product_External_ID__c = szCode,
                                     BEOL__c = 'AA BB CC',
                                     FEOL__c = 'DD EE FF',
                                     APTPS_Core_Voltage__c = '1.50',
                                     APTPS_IO_Voltage__c = '1.50',
                                     Geometry__c = '0.028nm',
                                     Mask_Sets__c = szMaskSet,
                                     IsActive = True);
        
        try{
            insert prod;
        }catch(Exception e){
            UtilityCls.saveExceptionLog(FMSValidationTest.class.getName(), 'createProduct()', '', 'Bug', '', '', 'Error', e.getTypeName(), 'FMS', e, 0);
        }
        return prod;
    }
    
    static Id createProdConfig(Id configId){
        Apttus_Config2__ProductConfiguration__c pc = new Apttus_Config2__ProductConfiguration__c();
        pc.Apttus_QPConfig__Proposald__c = configId;
        try{
            insert pc;
        }catch(Exception e){
            UtilityCls.saveExceptionLog(FMSValidationTest.class.getName(), 'createProdConfig()', '', 'Bug', '', '', 'Error', e.getTypeName(), 'FMS', e, 0);
        }
        return pc.id;
    }    
}