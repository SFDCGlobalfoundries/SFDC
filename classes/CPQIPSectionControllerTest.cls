/******************************************************************************************************************************
Class:         CPQIPSectionControllerTest
-------------------------------------------------------------------------------------------------------------------------------
Author:        Prosenjit Saha
Created Date:  9/25/2014
Reason:        Test class for CPQIPSectionController
History:     ARoy    11162015    Modified the test class for IP Design Kit customization.     
*******************************************************************************************************************************/
@isTest(SeeAllData=false)
private class CPQIPSectionControllerTest{
    @testSetup
     static void testDataSetup(){
        DataUtilTest.loadEnvironmentVariables();
        
     }
    // Test Method for IP Section
    static testMethod void testCPQIPSectionMethod(){
        Account acc = createAccount();
       //Setup the Proposal test record for the the page to render
        Apttus_Proposal__Proposal__c proposal = createProposal();
        
        List<Apttus_Proposal__Proposal_Line_Item__c> lstLineItems = 
                        new List<Apttus_Proposal__Proposal_Line_Item__c>();
        
        
        Base_IP__c baseIp = createIP();
        createIPdesignKit(baseIp.Id);
                
        Apttus_Config2__ProductConfiguration__c prodconfig = createProductConfig(proposal.Id);   
        Product2 dev1 = createOptionProduct('Test Device 1', 'IPs', 'IPE99999', 'AA');  
        Apttus_Proposal__Proposal_Line_Item__c lineItem1 = createProposalLineItem(1, proposal.Id, prodconfig.Id ,dev1.Id);
        lstLineItems.add(lineItem1);
        
        Apttus_Config2__PriceList__c pl = new Apttus_Config2__PriceList__c();
        pl.Apttus_Config2__AccountId__c = acc.Id;
        pl.Apttus_Config2__Active__c = true;
        pl.Name = 'GLOBALFOUNDRIES Internal';
        insert pl;
        Apttus_Config2__PriceListItem__c pli = new Apttus_Config2__PriceListItem__c();
        pli.Apttus_Config2__PriceListId__c = pl.Id;
        pli.Apttus_Config2__ChargeType__c = 'Standard';
        pli.Apttus_Config2__ProductId__c = dev1.Id;
        pli.Apttus_Config2__Active__c = true;
        insert pli;
        
        Product2 dev2 = createOptionProduct('Test Device 2', 'IPs', 'TESTIP0002', 'BB');
        Apttus_Proposal__Proposal_Line_Item__c lineItem2 = createProposalLineItem(2, proposal.Id, prodconfig.Id ,dev2.Id);
        lstLineItems.add(lineItem2);
        
        //Added by Ravi Teja.B for covering BaseIPTriggerHelper Class.
        baseIp.Display_in_IP_Catalog__c = 'No';
        update baseIp;
        baseIp.Display_in_IP_Catalog__c = 'Yes';
        update baseIp;
        
        
        insert lstLineItems;
        
        Test.startTest();
            PageReference pageRef = Page.CPQIPSection;
            
            Test.setCurrentPage(pageRef);
            
            ApexPages.CurrentPage().getParameters().put('Id', proposal.id);
            
            ApexPages.StandardController sc = new ApexPages.standardController(proposal);                
        
            CPQIPSectionController CPQIPSecController = new CPQIPSectionController(sc);
            CPQIPSecController.royaltyEditModeOn();
            CPQIPSecController.royaltyCancel();
            CPQIPSecController.royaltyEditModeOn();
            CPQIPSecController.saveRoyalty();
        Test.stopTest();
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
    
    
    //Static method to create proposal test record
    static Apttus_Proposal__Proposal__c createProposal(){
        //Create a proposal from Device
        Apttus_Proposal__Proposal__c proposal = 
                    new Apttus_Proposal__Proposal__c(Apttus_Proposal__Description__c = 'Test Proposal Description ...');
                                                     
        
        insert proposal;
        return proposal;
    }
    
    //Static method to create product test record
    static Product2 createProduct(String szName, String szCode, String szMaskSet){
        //Create a proposal line item
        Product2 prod = new Product2(Name = szName,
                                     ProductCode = szCode,
                                     BEOL__c = 'AA BB CC',
                                     FEOL__c = 'DD EE FF',
                                     APTPS_Core_Voltage__c = '1.50',
                                     APTPS_IO_Voltage__c = '1.50',
                                     Geometry__c = '0.028nm',
                                     Mask_Sets__c = szMaskSet,
                                     family= 'IPs',
                                     IsActive = True,
                                     Product_External_ID__c = szCode + Math.Random());
        
        insert prod;
        return prod;
    }
    
    //Static method to create product test record
    static Product2 createOptionProduct(String szName, String szFamily, String szCode, String szMaskSet){
        //Create a proposal line item
        Product2 prod = new Product2(Name = szName,
                                     Family = szFamily,
                                     ProductCode = szCode,
                                     APTPS_Core_Voltage__c = '1.50',
                                     APTPS_IO_Voltage__c = '1.50',
                                     Geometry__c = '0.028nm',
                                     Mask_Sets__c = szMaskSet,
                                     IsActive = True,
                                     Product_External_ID__c = szCode + Math.Random());
        
        insert prod;
        return prod;
    }
    
    
    //Static method to create proposal line item test record
    static Apttus_Proposal__Proposal_Line_Item__c createProposalLineItem(Integer iNumber, Id PropId, Id prodconfigID,Id optId){
        //Setup the test records required to create the Proposal test record
        Product2 prod = createProduct('IPE99999', 'IPE99999', Null);
                                                         
        //Create a proposal line item
        Apttus_Proposal__Proposal_Line_Item__c proposalLineItem = 
              new Apttus_Proposal__Proposal_Line_Item__c(Apttus_QPConfig__LineNumber__c = iNumber,
                                                         Apttus_QPConfig__ItemSequence__c = iNumber,
                                                         Apttus_Proposal__Product__c = prod.Id,
                                                         Apttus_Proposal__Proposal__c = propId,
                                                         Apttus_QPConfig__OptionId__c = optId,
                                                         Apttus_QPConfig__ConfigurationId__c= prodconfigID,
                                                         IP_Design_Kit__c = 'IP00001-02'/*,
                                                         Apttus_QPConfig__AttributeValueId__c = attrib.Id*/);
        
        return proposalLineItem;
    }
    
    // Create IP Design Kit
    static void createIPdesignKit(Id baseIp){
        List<IP__c> ipList = new List<IP__c>();
        IP__c ip1 = new IP__c(Name = 'IPE99999-01',IP_Type__c = 'NVM',PH1_QA_Status__c = 'NCR', IPNumber__c = baseIp, IP_Device_List__c = 'abc', Latest_Version__c = 'IPE99999-02');
        IP__c ip2 = new IP__c(Name = 'IPE99999-02',IP_Type__c = 'NVM',PH1_QA_Status__c = 'NCR', IPNumber__c = baseIp, IP_Device_List__c = 'def', Latest_Version__c = 'IPE99999-02');
        IP__c ip3 = new IP__c(Name = 'IPE99999-03',IP_Type__c = 'NVM',PH1_QA_Status__c = 'NCR', IPNumber__c = baseIp, IP_Device_List__c = 'ghi', Latest_Version__c = 'IPE99999-02');
        ipList.add(ip1);
        ipList.add(ip2);
        ipList.add(ip3);
        insert ipList;
    }
    
    // Create IP 
    static Base_IP__c createIP(){
        Base_IP__c baseIp = new Base_IP__c(Name = 'IPE99999',IP_Type__c = 'NVM', IP_Number__c = 'IPE99999');
        insert baseIp;
        return baseIp;
    }
    
    //Static method to create Account test record
    static Account createAccount(){
        Map<String,Object> fieldValueMap = new Map<String,Object>();
        fieldValueMap.put('Name', 'MYTEST ACCOUNT1');                           
        fieldValueMap.put('sub_type__c', 'Indirect');
        fieldValueMap.put('site_department__c', 'test dept');          
        fieldValueMap.put('transaction_type__c', 'Non-Transactional');                          
        fieldValueMap.put('region__c', 'US');        
        fieldValueMap.put('Corporate_Address_1__c', 'Test Address 1');          
        fieldValueMap.put('Corporate_City__c', 'Test City');                
        fieldValueMap.put('Corporate_Country__c', 'India');
        fieldValueMap.put('Bill_To_Address_1__c', 'Test Address 1');          
        fieldValueMap.put('Bill_To_City__c', 'Test City');            
        fieldValueMap.put('Bill_To_Country__c', 'India');        
        fieldValueMap.put('Fab_9_10__c','No');
        fieldValueMap.put('recordtypeid', EnvironmentVariable.get('ACCT_RT_ID_CUSTOMER'));

        return AccountDataFactory.createAccount(fieldValueMap);
        
    }
    
}