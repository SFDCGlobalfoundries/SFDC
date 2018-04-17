/**
* Author: Prosenjit Saha
* Description: This is the test class for Tigger:CPQDefaultValueAssignmentTrigger 
                                        & Class: CPQDefaultValueAssignmentClass 
* History:
*     PSaha          06262014     - code creation.
*     ARoy           05302016     - code modified for Copy Configurator functionality to create Product Attribute Value record.    
*     
**/

@isTest(SeeAllData=false)
private class CPQDefaultValueAssignmentClassTest{
    
    
    @testSetup
    static void testDataSetup(){
       DataUtilTest.loadEnvironmentVariables();
        
    }
    
    /*
    * Method Name:     createProductAttributeValue
    * Return Type:     Apttus_Config2__ProductAttributeValue__c  
    * Parameter  :     NA
    * Reason     :     This method creates Product Attribute Value
    */
    static List<Apttus_Config2__ProductAttributeValue__c  > createProductAttributeValue(List<Apttus_Config2__LineItem__c> ListLineItems){
        List<Apttus_Config2__ProductAttributeValue__c> ProdAttributeValueList = new List<Apttus_Config2__ProductAttributeValue__c  >();
        for(Apttus_Config2__LineItem__c LineItems : ListLineItems){
            Apttus_Config2__ProductAttributeValue__c TempProdAtt = new Apttus_Config2__ProductAttributeValue__c();
                TempProdAtt.Apttus_Config2__LineItemId__c    = LineItems.id;
            ProdAttributeValueList.add(TempProdAtt);
        }  
        try{
            insert ProdAttributeValueList;
        }catch(Exception e){}
        Return ProdAttributeValueList;
    }
    
    /*
    * Method Name:     CPQDefaultValueTestMethod
    * Return Type:     NA
    * Parameter  :     NA
    * Reason     :     This method Tests Tigger:CPQDefaultValueAssignmentTrigger 
                                       & Class: CPQDefaultValueAssignmentClass 
    */
    static testMethod void CPQDefaultValueTestMethod(){       
        
        Map<String,Object> fieldValueMap = new Map<String,Object>();
        fieldValueMap.put('Name', 'Test Account1');  
        fieldValueMap.put('Account_Type__c', 'Customer');                           
        fieldValueMap.put('sub_type__c', 'Indirect');        
        fieldValueMap.put('site_department__c', 'IT');        
        fieldValueMap.put('transaction_type__c', 'Non-Transactional');                          
        fieldValueMap.put('region__c', 'US');        
        fieldValueMap.put('Corporate_Address_1__c', 'Test Address 1');          
        fieldValueMap.put('Corporate_City__c', 'Test City');                
        fieldValueMap.put('Corporate_Country__c', 'Singapore');
        fieldValueMap.put('Bill_To_Address_1__c', 'Test Address 1');          
        fieldValueMap.put('Bill_To_City__c', 'Test City');            
        fieldValueMap.put('Bill_To_Country__c', 'Singapore');
        
        Account acc = AccountDataFactory.createAccount(fieldValueMap);
                
        Opportunity opp = createOpp(acc.Id);        
        Apttus_Proposal__Proposal__c proposal = createProposal(acc.Id, opp.Id, null, null, null);
        
        Product2 bundleProd = createProduct('Test Process Technology', 'PROCESSTECH0001', Null, Null);
        
        Product2 optionProd = createOptionProduct('Test Mask 1', 'Mask Layers', 'TESTMASK0001', 'AA');
        
        Apttus_Config2__ProductConfiguration__c pc = createProdConfig(proposal.Id);
        Apttus_Config2__PriceList__c pl = createPriceList();
        
        Apttus_Config2__ConstraintRule__c cr = createConstraintRule();
        createConstRuleCondition(cr.Id,bundleProd.Id);
        Apttus_Config2__ConstraintRuleAction__c cra = createConstRuleAction(cr.Id,bundleProd.Id);
        
        Apttus_Config2__AppliedRuleInfo__c ari = createAppRuleInfo(pc.Id,cr.Id);
        createAppRuleActionInfo(ari.Id,pc.Id,cra.Id);
        
        List<Apttus_Config2__LineItem__c> lineitem = new List<Apttus_Config2__LineItem__c>{new Apttus_Config2__LineItem__c()};
        
        test.startTest();            
            createProductAttributeValue(lineitem);
        test.stopTest();
    
    }    
    
    //Static method to create Opportunity test record
    static Opportunity createOpp(Id acctId){
        Opportunity opp = new Opportunity(Name = 'Test Opportunity',
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
        
        insert proposal;
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
        
        insert prod;
        return prod;
    }
    
    //Static method to create a line item
    static List<Apttus_Config2__LineItem__c> createLineItem(Id bundleProdId,Id optionProdId,Id prodConfigId,Id priceListId){
        //Create a line item               
        List<Apttus_Config2__LineItem__c> lineItemList = new List<Apttus_Config2__LineItem__c>();
        Apttus_Config2__LineItem__c lineItem1 = new Apttus_Config2__LineItem__c(Apttus_Config2__LineType__c = 'Product/Service',
                                                                               Apttus_Config2__ProductId__c = bundleProdId,
                                                                               Apttus_Config2__ConfigurationId__c = prodConfigId,
                                                                               Apttus_Config2__ItemSequence__c = 1,
                                                                               Apttus_Config2__LineNumber__c = 1,
                                                                               Apttus_Config2__PriceListId__c = priceListId,
                                                                               Apttus_Config2__IsPrimaryLine__c = true,
                                                                               Apttus_Config2__Quantity__c = 1.00,
                                                                               Apttus_Config2__IsQuantityModifiable__c = true,
                                                                               Apttus_Config2__ConfigStatus__c = 'Complete',
                                                                               Apttus_Config2__ConstraintCheckStatus__c = 'NA',
                                                                               Apttus_Config2__PricingStatus__c = 'Complete',
                                                                               Apttus_Config2__SyncStatus__c = 'Synchronized',
                                                                               Apttus_Config2__Uom__c = 'Each',
                                                                               Apttus_Config2__PrimaryLineNumber__c = 1,
                                                                               Apttus_Config2__LineStatus__c = 'New' ,
                                                                               Apttus_Config2__SellingTerm__c = 1.00,
                                                                               Apttus_Config2__Term__c = 1,
                                                                               Apttus_Config2__AllowManualAdjustment__c = true,
                                                                               Apttus_Config2__AllowableAction__c = 'Unrestricted'                                                                              
                                                                               );

        lineItemList.add(lineItem1);
        insert lineItemList;
        return lineItemList;                                                                            
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
    
    // Create pricelist
    static Apttus_Config2__PriceList__c createPriceList(){
        Apttus_Config2__PriceList__c pl = new Apttus_Config2__PriceList__c(Name = 'GLOBALFOUNDRIES Internal Price List');
        insert pl;
        return pl;
    }
    
    //create applied rule info
    static Apttus_Config2__AppliedRuleInfo__c createAppRuleInfo(Id prodConfigId,Id crId){
        Apttus_Config2__AppliedRuleInfo__c ari = new Apttus_Config2__AppliedRuleInfo__c(Apttus_Config2__ConfigurationId__c = prodConfigId,
                                                                                        Apttus_Config2__ConstraintRuleId__c = crId
                                                                                       );
        insert ari;
        return ari;
    }
    
    //create applied rule action info
    static void createAppRuleActionInfo(Id appRuleInfoId,Id pcId,Id craId){
        Apttus_Config2__AppliedRuleActionInfo__c arai 
                         = new Apttus_Config2__AppliedRuleActionInfo__c(Apttus_Config2__AppliedRuleInfoId__c = appRuleInfoId,
                                                                         Apttus_Config2__ConfigurationId__c = pcId,
                                                                         Apttus_Config2__ConstraintRuleActionId__c = craId
                                                                        );
        insert arai;
    }
    
    //create constraint rule
    static Apttus_Config2__ConstraintRule__c createConstraintRule(){
        Apttus_Config2__ConstraintRule__c cr = new Apttus_Config2__ConstraintRule__c(name = 'Test Constraint Rule',
                                                                                     Constraint_Rule_External_Id__c = 'Test Constraint Rule',
                                                                                     Apttus_Config2__Active__c = true
                                                                                    );
        insert cr;
        return cr;
    }
    
    //create constraint rule condition
    static void createConstRuleCondition(Id crId,Id prodId){
        Apttus_Config2__ConstraintRuleCondition__c crc 
                                = new Apttus_Config2__ConstraintRuleCondition__c(Name = 'Test Constraint Rule Condition',
                                                                                 Apttus_Config2__ConstraintRuleId__c = crId,
                                                                                 Constraint_Rule_Condition_External_ID__c = 'Test Constraint Rule Condition',
                                                                                 Apttus_Config2__ProductScope__c = 'Product',
                                                                                 Apttus_Config2__ProductId__c = prodId,
                                                                                 Apttus_Config2__MatchInPrimaryLines__c = true
                                                                                );
        insert crc;
    }
    
    //create constraint rule action
    static Apttus_Config2__ConstraintRuleAction__c createConstRuleAction(Id crId,Id prodId){
        Apttus_Config2__ConstraintRuleAction__c cra 
                                        = new Apttus_Config2__ConstraintRuleAction__c(Name = 'Test Constraint Rule Action',
                                                                                      Apttus_Config2__ConstraintRuleId__c = crId,
                                                                                      Constraint_Rule_Action_External_ID__c = 'Test Constraint Rule Action',
                                                                                      Apttus_Config2__ProductScope__c = 'Product',
                                                                                      Apttus_Config2__ProductId__c = prodId,
                                                                                      Apttus_Config2__MatchInOptions__c = true,
                                                                                      Apttus_Config2__ActionDisposition__c = 'Warning',
                                                                                      Apttus_Config2__ActionType__c = 'Inclusion', 
                                                                                      Apttus_Config2__ActionIntent__c = 'Auto Include'
                                                                                     );
        
        insert cra;
        return cra;
    }
}