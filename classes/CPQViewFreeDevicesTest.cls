/******************************************************************************************************************************
Class:         CPQViewFreeDevicesTest
-------------------------------------------------------------------------------------------------------------------------------
Author:        Joydev Mondol (Cognizant - 153480)
Created Date:  5/11/2013
Reason:        Test class for controller classes ViewFreeDevicesController
*******************************************************************************************************************************/
               
@isTest
private class CPQViewFreeDevicesTest{
@testSetup static void testdata() {
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
    static testMethod void testViewFreeDevices(){
        //Setup the Proposal test record for the the page to render
        Account acc = getAccount('MYTEST ACCOUNT1');
        //PS 02062015: Team_Room__c tmrm = createTeamroom(acc.Id);
        Apttus_Proposal__Proposal__c proposal = createProposal(Null, Null);
        
        List<Apttus_Proposal__Proposal_Line_Item__c> lstLineItems = 
                        new List<Apttus_Proposal__Proposal_Line_Item__c>();
        
        List<Process__c> lstPIDs = new List<Process__c>();
                
        Product2 processTech = createProduct('Test Process Technology', 'PROCESSTECH0001', Null);        
        Apttus_Proposal__Proposal_Line_Item__c lineItem1 = createProposalLineItem(1, proposal.Id, processTech.Id);
        lstLineItems.add(lineItem1);
        
        Product2 dev1 = createOptionProduct('Test Device 1', 'Devices', 'TESTDEVICE0001', 'AA');
        Apttus_Proposal__Proposal_Line_Item__c lineItem2 = createProposalLineItem(2, proposal.Id, dev1.Id);
        lstLineItems.add(lineItem2);
        
        Product2 dev2 = createOptionProduct('Test Device 2', 'Devices', 'TESTDEVICE0002', 'BB');
        
        insert lstLineItems;
        
        //proposal.Mask_Set__c = 'BB CC DD EE';
        //changed reference of Mask_Set__c to Mask_Set_Long__c for the Case#00051463
        proposal.Mask_Set_Long__c = 'BB CC DD EE';
        proposal.Free_Devices__c = dev2.ProductCode;
        
        //update proposal;
        
        Test.startTest();
        update proposal;
        PageReference pageRef = Page.ViewFreeDevices;
        
        Test.setCurrentPage(pageRef);
        
        ApexPages.CurrentPage().getParameters().put('Id', proposal.id);
        
        ApexPages.StandardController sc = new ApexPages.standardController(proposal);                
        
        ViewFreeDevicesController viewFDevicesController = new ViewFreeDevicesController(sc);       
        Test.stopTest();
    }
    
    
    /*PS 02062015: 
    //Static method to create Teamroom test record
    static Team_Room__c createTeamroom(Id accId){
        Team_Room__c tmrm = new Team_Room__c(Name = 'TESTTEAMROOM1313',
                                             Team_Room_Description__c= 'Team room Description ... ',Primary_Account__c=accId); //TBD
        insert tmrm;
        return tmrm; 
    } */
    
    //Static method to create proposal test record
    static Apttus_Proposal__Proposal__c createProposal(Id devId, Id tmrmId){
        //Setup the test records required to create the Proposal test record
        RecordType recType = [Select Id
                                From RecordType 
                               Where Name='Draft' And
                                     SobjectType = 'Apttus_Proposal__Proposal__c'];
        
        //Create a proposal from Device
        Apttus_Proposal__Proposal__c proposal = 
                    new Apttus_Proposal__Proposal__c(Apttus_Proposal__Description__c = 'Test Proposal Description ...',
                                                     Device__c = devId,
                                                     RecordTypeId = recType.Id);
        
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
    
    //Static method to create Attribute test record
    /*
    static Apttus_QPConfig__ProposalProductAttributeValue__c createAttribute(){
        //Setup the test records required to create the Proposal test record
        Account acc = createAccount();
        Team_Room__c tmrm = createTeamroom(acc.Id);
        Apttus_Proposal__Proposal__c proposal = createProposal(Null, tmrm.Id);
        Product2 prod = createProduct('Test Process Technology', 'PROCESSTECH0001', Null);
        
        Apttus_Proposal__Proposal_Line_Item__c proposalLineItemDummy = 
              new Apttus_Proposal__Proposal_Line_Item__c(Apttus_Proposal__Proposal__c = proposal.Id,
                                                         Apttus_QPConfig__LineNumber__c = 1,
                                                         Apttus_QPConfig__ItemSequence__c = 1,
                                                         Apttus_Proposal__Product__c = prod.Id);
        
        insert proposalLineItemDummy;
        
        //Create a attribute
        Apttus_QPConfig__ProposalProductAttributeValue__c atrib = 
              new Apttus_QPConfig__ProposalProductAttributeValue__c(Apttus_QPConfig__LineItemId__c = proposalLineItemDummy.Id,
                                                                    IO_Voltage__c = '1.50',
                                                                    core_voltagae__c = '1.50');
        
        insert atrib;
        return atrib;
    }
    */
    
    //Static method to create proposal line item test record
    static Apttus_Proposal__Proposal_Line_Item__c createProposalLineItem(Integer iNumber, Id PropId, Id optId){
        //Setup the test records required to create the Proposal test record
        Product2 prod = createProduct('Test Process Technology', 'PROCESSTECH0001', Null);
        //Apttus_QPConfig__ProposalProductAttributeValue__c attrib = createAttribute();
                                                         
        //Create a proposal line item
        Apttus_Proposal__Proposal_Line_Item__c proposalLineItem = 
              new Apttus_Proposal__Proposal_Line_Item__c(Apttus_QPConfig__LineNumber__c = iNumber,
                                                         Apttus_QPConfig__ItemSequence__c = iNumber,
                                                         Apttus_Proposal__Product__c = prod.Id,
                                                         Apttus_Proposal__Proposal__c = propId,
                                                         Apttus_QPConfig__OptionId__c = optId/*,
                                                         Apttus_QPConfig__AttributeValueId__c = attrib.Id*/);
        
        //insert proposalLineItem;
        return proposalLineItem;
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
    
    private static Account getAccount(string AccountName)
    {
        Account acct = [SELECT Id, Name FROM Account Where Name =: AccountName];
        
        return acct;
    }
}