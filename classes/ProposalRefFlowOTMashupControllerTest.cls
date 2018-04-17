/*
    Author: Anirban Roy
    Description: Apex test class for ProposalRefFlowOTMashupController
    History: 
        ARoy     07092014    - Code creation.
*/
@isTest(seeAllData=false)
public class ProposalRefFlowOTMashupControllerTest {   

    @testSetup static void testdata() {
        DataUtilTest.loadEnvironmentVariables();
 
         Map<String,Object> fieldValueMap = new Map<String,Object>();       
        fieldValueMap.put('Name', 'testing901');
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
    
    static testMethod void testPropRefFlowOTMashupControllerTest(){
         Test.startTest();
        Account acc = createAccount();
        
        Opportunity opp = createOpportunity(acc.Id);        
        
        Apttus_Proposal__Proposal__c proposal = createProposal(acc.Id, opp.Id, Null);                                   
        
        Product2 processTech4Com = createProduct('Test Process Technology', 'PROCESSTECHCOM0001', Null, 'XXX00321');
        
        Product2 processTech = createOptionProduct('Test Process Technology', 'RF', 'PROCESSTECHCOM0001', 'CC', Null);
                
        Apttus_Proposal__Proposal_Line_Item__c lineItem1 = createProposalLineItem(1, proposal.Id, NULL, processTech4Com);
        
        Apttus_Proposal__Proposal_Line_Item__c lineItem2 = createProposalLineItem(1, proposal.Id, processTech.Id, processTech4Com);
        
     
        /*PageReference pageRef = Page.ProposalRefFlowOTMashup;
    
        Test.setCurrentPage(pageRef);*/
        
        ApexPages.CurrentPage().getParameters().put('Id', proposal.id);
        
        ApexPages.CurrentPage().getHeaders().put('host', 'globalfoundryview' );       
        
        ApexPages.StandardController sc = new ApexPages.standardController(proposal);                
        
        ProposalRefFlowOTMashupController propRefController1 = new ProposalRefFlowOTMashupController(sc);  
        
        ApexPages.CurrentPage().getHeaders().put('host', 'test' );
        
        ProposalRefFlowOTMashupController propRefController2 = new ProposalRefFlowOTMashupController(sc); 
         
        Test.stopTest();
        
    }
    
    //Static method to create Account test record
    static Account createAccount(){
        Account acc= getAccount('testing901'); 
        return acc;
    }
    
    //Static method to create Opportunity test record
    static Opportunity createOpportunity(Id AccId){
      Map<String,Object> fieldValueMap = new Map<String,Object>();
        fieldValueMap.put('AccountId',AccId);
        fieldValueMap.put('Name','Test Opportunity');  
        fieldValueMap.put('StageName','1. Discovery');
        fieldValueMap.put('CloseDate',Date.Today().addDays(10));  
        fieldValueMap.put('Target_Process_Node__c','14XM');
        fieldValueMap.put('Market_Segment__c','Mobility');  
        fieldValueMap.put('Process_Platform__c','GF Baseline');
        fieldValueMap.put('Fab_Split__c',100);          
        fieldValueMap.put('Process_Geometry__c','0.13UM');  
        fieldValueMap.put('Process_Family__c','Generic / Nominal');
        fieldValueMap.put('Opportunity_Sourcing_Type__c','First Source');  
        fieldValueMap.put('Fab_Assignment_1__c','FAB 6');
         
        return OpportunityDataFactory.createOpportunity(fieldValueMap);
        
    }    
    
    //Static method to create proposal test record
    static Apttus_Proposal__Proposal__c createProposal(Id accId, Id oppId, Id devId){
        //Setup the test records required to create the Proposal test record
        RecordType recType = [Select Id
                                From RecordType 
                               Where Name='Draft' And
                                     SobjectType = 'Apttus_Proposal__Proposal__c'];
        
        //Create a proposal from Device
        Apttus_Proposal__Proposal__c proposal = 
                    new Apttus_Proposal__Proposal__c(Apttus_Proposal__Description__c = 'Test Proposal Description ...',
                                                     Device__c = devId,
                                                     Apttus_Proposal__Opportunity__c = OppId,
                                                     Apttus_Proposal__Account__c = AccId,
                                                     RecordTypeId = recType.Id);
        
        insert proposal;
        return proposal;
    }
    
    //Static method to create product test record
    static Product2 createProduct(String szName, String szCode, String szMaskSet, String szComPTs){
        //Create a proposal line item
        Product2 prod = new Product2(Name = szName,
                                     ProductCode = 'GEO_' + szCode + '_ADD',
                                     FEOL__c = 'AA BB CC',
                                     BEOL__c = 'DD EE FF',
                                     APTPS_Core_Voltage__c = '1.50',
                                     APTPS_IO_Voltage__c = '1.50',
                                     Geometry__c = '0.028nm',
                                     Mask_Sets__c = szMaskSet,
                                     IsActive = True,
                                     Compatible_PTs__c = szComPTs,
                                     PT_Number__c = szCode,
                                     Product_External_ID__c = szCode + Math.random(),
                                     IP_PT_ID__c = createProcess());
        
        insert prod;
        return prod;
    }
    
    
    //Static method to create product test record
    static Product2 createOptionProduct(String szName, String szFamily, String szCode, String szMaskSet, String szComPTs){
        //Create a proposal line item
        Product2 prod = new Product2(Name = szName,
                                     Family = szFamily,
                                     ProductCode = 'OPT_' + szCode + '_ADD',
                                     FEOL__c = 'AA BB CC',
                                     BEOL__c = 'DD EE FF',
                                     APTPS_Core_Voltage__c = '1.50',
                                     APTPS_IO_Voltage__c = '1.50',
                                     Geometry__c = '0.028nm',
                                     Mask_Sets__c = szMaskSet,
                                     IsActive = True,
                                     Compatible_PTs__c = szComPTs,
                                     PT_Number__c = szCode,
                                     Product_External_ID__c = szCode + Math.random(),
                                     IP_PT_ID__c = createProcess());
        
        insert prod;
        return prod;
    }
    
    //Static method to create proposal line item test record
    static Apttus_Proposal__Proposal_Line_Item__c createProposalLineItem(Integer iNumber, Id PropId, Id optId, Product2 prod){
        //Setup the test records required to create the Proposal test record
        //Product2 prod = createProduct('Test Process Technology', 'PROCESSTECH0001', Null, 'PROCESSTECHCOM0001');
        //Apttus_QPConfig__ProposalProductAttributeValue__c attrib = createAttribute();
                                                         
        //Create a proposal line item
        Apttus_Proposal__Proposal_Line_Item__c proposalLineItem = 
              new Apttus_Proposal__Proposal_Line_Item__c(Apttus_QPConfig__LineNumber__c = iNumber,
                                                         Apttus_QPConfig__ItemSequence__c = iNumber,
                                                         Apttus_Proposal__Product__c = prod.Id,
                                                         Apttus_Proposal__Proposal__c = propId,
                                                         Apttus_QPConfig__OptionId__c = optId);
        
        insert proposalLineItem;
        return proposalLineItem;
    }   
    
    //Static method to create proposal line item test record
    static String createProcess(){
        Process__c TempProcess = new Process__c();
            TempProcess.name = 'Test Process';
        insert TempProcess;
        return TempProcess.ID;
    }
  private static Account getAccount(string AccountName)
            {
                Account acc= [SELECT Id, Name FROM Account Where Name =: AccountName];
        
                return acc;
            }  
              
}