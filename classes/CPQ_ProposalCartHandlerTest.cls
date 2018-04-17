/*
  Author: Anirban Roy
  Description: This is the test class for CPQ_ProposalCartHandler.
  History:
    ARoy        06122017    - code creation.              
*/
@isTest(SeeAllData=false)
public class CPQ_ProposalCartHandlerTest {
    
    @testSetup
    static void testDataSetup(){
        DataUtilTest.loadEnvironmentVariables();               
    }
    
    public static Device__c createDevice(Id accId, Id oppId, Id oppProgId){
        Device__c dev = deviceutiltest.createDevicePM(accId,oppId,oppProgId);
        dev.Confidence_Level_Tapeout__c = '100';
        dev.Expose_Device_to_Customer__c = false ; 
        dev.Fab__c = 'Fab 3';
        dev.Enabled_via_previous_MPW_1__c='No';
        dev.CRMDID__c = '123456';
        insert dev;
        return dev; 
    }
    
    static testMethod void testCPQCartHandler(){
        
        User admin = DeviceChecklistTestDataUtils.createUserWithDCAdmin('System Administrator');
        System.runAs(admin){
            IntegrationUsers__c skipUser = new IntegrationUsers__c(SetupOwnerId = admin.Id, Is_Integration_User__c= true, Skip_Trigger__c = true, Skip_Validation_Rule__c = true);
            insert skipUser;
        
            Account acc = new Account(Name = 'Test Account',Site_Department__c = 'Test Site 1', Sub_Type__c = 'Direct', Transaction_Type__c = 'Transactional',
                               Region__c = 'APJ', Corporate_Address_1__c = 'Test Bill To Address 1', Corporate_City__c = 'Singapore', Corporate_Country__c = 'Singapore'  );       
            acc.Fab_9_10__c = 'Yes';
            acc.Customer_Category__c = 'TFA';
            acc.Tech_Geo_Granted__c = '0.007UM'+';'+'0.010UM';
            acc.SAP_Account_Number__c= '006104';
            Insert acc;
            
            String oppId = DeviceChecklistTestDataUtils.createOpp(acc.Id);                
            String oppProgId = DeviceChecklistTestDataUtils.createOppProg(acc.Id, oppId);
            Device__c dev = createDevice(acc.Id,oppId,oppProgId);
            Form_Management_System__c formObj = new Form_Management_System__c(
                Device__c = dev.Id,
                Customer_Name__c = acc.Id,
                Name__c = 'Test Name',
                Form_Name__c = 'Test Main Form',                 
                Form_Description__c = 'Test Description', 
                Technology__c = 'CSOI 7RF', 
                TestServices__c = 'Yes', 
                Packaging_Services__c = 'No', 
                RecordTypeId = Schema.SObjectType.Form_Management_System__c.getRecordTypeInfosByName().get('Design Data Return (DDR)').getRecordTypeId(),
                Chip_Interconnect__c = 'Wirebond', 
                QuoteOnly__c = 'No',
                ServiceOptions__c = 'Dicing',
                AppName__c = 'Test 1'+','+'Test 2',
                AppEmail__c = 'test@gmail.com',
                DesignSubmission__c = 'Single Chip (one GDS)', 
                InputMethod__c ='Advanced Process: Inputs via XML file attachment.', 
                Phone__c = '9999999999',
                Email__c = 'test@gmail.com',
                FileAttachment__c = 'Test Attachment',
                AdvancedProcessFileAttachment__c = 'Test Attachment',
                StepPlanRotationActive__c = null,
                SelAppId__c = 'test',
                LastMetalUsed__c = 'AM (Analog Metal) (MT, FT, AM) (70P5485)');
            
            insert formObj ;     
            
            Test.startTest();
                Product2 prod = createProduct('TestTech_FMS', 'TestTech_FMS', Null, 'PROCESSTECHCOM0001');
                Apttus_Proposal__Proposal__c proposal = createProposal(acc.Id, oppId, dev.Id, formObj.id, null);
                String proposalId = proposal.Id;
                String prodConfigId = createProdConfig(proposalId);                
                                
                Id cartId = CPQ_ProposalCartHandler.addBundleToCart(proposalId,prod.Id);
                Id tempCartId = CPQ_ProposalCartHandler.createCart(null);
                system.assert(tempCartId==null);
                Boolean isAddToCart = CPQ_ProposalCartHandler.saveCart(null);
                system.assertEquals(isAddToCart,false);
                
            Test.stopTest();
        }
    }        
    
    //Static method to create proposal test record
    static Apttus_Proposal__Proposal__c createProposal(Id accId, Id oppId, Id devId, Id formId, Id tmrmId){
        //Setup the test records required to create the Proposal test record
        RecordType recType = [Select Id
                                From RecordType 
                               Where Name='Multi Source Proposal from Teamroom' And
                                     SobjectType = 'Apttus_Proposal__Proposal__c'];
        
        //Create a proposal from Device
        Apttus_Proposal__Proposal__c proposal = 
                    new Apttus_Proposal__Proposal__c(Apttus_Proposal__Description__c = 'Test Proposal Description ...',
                                                     Device__c = devId,                                                     
                                                     Apttus_Proposal__Opportunity__c = oppId,
                                                     Apttus_Proposal__Account__c = accId,
                                                     FMS_Proposal__c = formId,
                                                     RecordTypeId = recType.Id);
        
        insert proposal;
        return proposal;
    }
    
    //Static method to create product test record
    static Product2 createProduct(String szName, String szCode, String szMaskSet, String szProductFamily){
        //Create a proposal line item
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
        
        insert prod;
        return prod;
    }
    
    static Id createProdConfig(Id configId){
        Apttus_Config2__ProductConfiguration__c pc = new Apttus_Config2__ProductConfiguration__c();
        pc.Apttus_QPConfig__Proposald__c = configId;
        insert pc;
        return pc.id;
    } 
    
}