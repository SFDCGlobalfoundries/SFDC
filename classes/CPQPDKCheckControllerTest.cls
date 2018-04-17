@isTest(SeeAllData=false)
Public Class CPQPDKCheckControllerTest{

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
        fieldValueMap.put('recordtypeid', EnvironmentVariable.get('ACCT_RT_ID_CUSTOMER'));   
        AccountDataFactory.createAccount(fieldValueMap);
      
    }

 static Account createAccount(){
                                       
          Account acc= getAccount('Test Account 009');
          return acc;
        
    }
    
    private static Account getAccount(string AccountName)
    {
        Account accntObj1 = [SELECT Id, Name FROM Account Where Name =: AccountName];
        
        return accntObj1;
    }  
    
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




        
        Database.insert(opp);
        System.assertEquals(opp.Name,'Test Opportunity');
        return opp;
    }
    
      static Opportunity_Program__c createOppProg(Id acctId, Id oppId){
        Opportunity_Program__c opProg = 
                    new Opportunity_Program__c(Name = 'Test OppProg',
                                               Account__c = acctId,
                                               Opportunity__c = oppId);
        Database.insert(opProg);
        System.assertEquals(opProg.Name,'Test OppProg');
        return opProg;
    }    
    
    
    static Apttus_Proposal__Proposal__c createProposal(Id accId, Id oppId, Id devId, Id tmrmId, String szMaskSet){
        //Setup the test records required to create the Proposal test record
        RecordType recType = [Select Id
                                From RecordType 
                               Where Name='Multi Source Proposal from Teamroom' And
                                     SobjectType = 'Apttus_Proposal__Proposal__c'];
        
        //Create a proposal from Device
        Apttus_Proposal__Proposal__c proposal = 
                    new Apttus_Proposal__Proposal__c(Apttus_Proposal__Description__c = 'Test Proposal Description ...',
                                                     Device__c = devId,
                                                     /*Mask_Set__c = szMaskSet, changed reference of Mask_Set__c to Mask_Set_Long__c for the Case#00051463*/
                                                     Mask_Set_Long__c = szMaskSet,
                                                     Apttus_Proposal__Opportunity__c = oppId,
                                                     PDK_Version__c ='V6',
                                                     Apttus_Proposal__Account__c = accId,
                                                     RecordTypeId = recType.Id);
        
        Database.insert(proposal);
        
        System.assertEquals(proposal.PDK_Version__c,'V6');
        return proposal;
    }
    
     static Id createProdConfig(Id configId){
        Apttus_Config2__ProductConfiguration__c pc = new Apttus_Config2__ProductConfiguration__c();
        pc.Apttus_QPConfig__Proposald__c = configId;
        Database.insert(pc);
        return pc.id;
    }     
    
     static Product2 createOptionProduct(String szName, String szFamily, String szCode, String szMaskSet){
        //Create a proposal line item
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
        //Setup the test records required to create the Proposal test record
        Product2 prod = createProduct('Test Process Technology', 'PROCESSTECH0001', Null, 'PROCESSTECHCOM0001');
                                                         
        //Create a proposal line item
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
        
        Database.insert(prod);
        return prod;
    }  
static testMethod void testProposalSummaryPDK(){
      
      try{
        User admin = DeviceChecklistTestDataUtils.createUserWithDCAdmin('System Administrator');
        System.runAs(admin){
            IntegrationUsers__c skipUser = new IntegrationUsers__c(SetupOwnerId = admin.Id, Is_Integration_User__c= true, Skip_Trigger__c = true, Skip_Validation_Rule__c = true);
            Database.insert(skipUser);
        
            Account acc = createAccount();
            
            Opportunity opp = createOpp(acc.Id);                
            Opportunity_Program__c oppProg = createOppProg(acc.Id,opp.Id);
            Device__c dev = DeviceUtilTest.createCMPWDevice(acc.Id,oppProg.Id);
            Database.insert(dev);           
            
            
                Test.startTest();
                Apttus_Proposal__Proposal__c proposal = createProposal(acc.Id, opp.Id, dev.Id, null, 'AB,CD');
                String proposalId = proposal.Id;
                String prodConfigId = createProdConfig(proposalId);
                
                Product2 ip1 = createOptionProduct('Test Add Ques', 'Devices', 'TESTAddQues0001', 'AA');
            
                Database.insert(ip1);
                                            
                Product2 prod = new Product2(Name = 'Test Process Technology',
                                     Family = 'PROCESSTECHCOM0001',
                                     ProductCode = 'PROCESSTECH0001',
                                     Product_External_ID__c = 'PROCESSTECH0001' + Math.Random(),
                                     BEOL__c = 'AA BB CC',
                                     FEOL__c = 'DD EE FF',
                                     APTPS_Core_Voltage__c = '1.50',
                                     APTPS_IO_Voltage__c = '1.50',
                                     Geometry__c = '0.028nm',
                                     Mask_Sets__c = '',
                                     Apttus_Config2__ConfigurationType__c = 'Bundle',
                                     PDK_Version__c = 'V1',
                                     IsActive = True);
                Database.insert(prod);
                 
                  System.assertEquals(prod.PDK_Version__c,'V1');
              Apttus_Proposal__Proposal_Line_Item__c proposalLineItem = 
              new Apttus_Proposal__Proposal_Line_Item__c(Apttus_QPConfig__LineNumber__c = 2,
                                                         Apttus_QPConfig__ItemSequence__c = 2,
                                                         Apttus_Proposal__Product__c = prod.Id,
                                                         Apttus_Proposal__Proposal__c = proposalId,
                                                         Apttus_QPConfig__OptionId__c = ip1.Id,
                                                         Apttus_QPConfig__ConfigurationId__c = prodConfigId/*,
                                                         Apttus_QPConfig__AttributeValueId__c = attrib.Id*/);
                                                         
                Database.insert(proposalLineItem);
                System.assert(proposalLineItem.id != null);
                Apttus_Proposal__Proposal_Line_Item__c pl = createProposalLineItem(1, proposal.Id, ip1.Id,prodConfigId);            
                Database.insert(pl);
               
                
                 ApexPages.currentPage().getParameters().put('id',proposalId);
                ApexPages.currentPage().getParameters().put('flow','GFFlow');
                ApexPages.currentPage().getParameters().put('Name','prodscope_1');
                
                
               CPQPDKCheckController  Pdkcheck = new CPQPDKCheckController();
               pdkcheck.CheckPDK();
                
                
            Test.stopTest();
        }
        
        }catch(Exception excp) {
                GlobalUtility.logMessage('Error','CPQPDKCheckControllerTest','testProposalSummaryPDK','','Exception while updating pdk version in proposal in Test class',String.valueof(excp.getMessage()),'','Apttus CPQ',excp,0);
             }
    }
  
  
  
  static testMethod void testProposalSummaryPDK2(){
      
        try{
        User admin = DeviceChecklistTestDataUtils.createUserWithDCAdmin('System Administrator');
        System.runAs(admin){
            IntegrationUsers__c skipUser = new IntegrationUsers__c(SetupOwnerId = admin.Id, Is_Integration_User__c= true, Skip_Trigger__c = true, Skip_Validation_Rule__c = true);
            insert skipUser;
        
            Account acc = createAccount();
            
            Opportunity opp = createOpp(acc.Id);                
            Opportunity_Program__c oppProg = createOppProg(acc.Id,opp.Id);
            Device__c dev = DeviceUtilTest.createCMPWDevice(acc.Id,oppProg.Id);
            Database.Insert(dev);           
            
                Test.startTest();
                Apttus_Proposal__Proposal__c proposal = createProposal(acc.Id, opp.Id, dev.Id, null, 'AB,CD');
                String proposalId = proposal.Id;
                String prodConfigId = createProdConfig(proposalId);
                
                Product2 ip1 = createOptionProduct('Test Add Ques', 'Devices', 'TESTAddQues0001', 'AA');
            
                Database.insert(ip1);
               
                                                
                Product2 prod = new Product2(Name = 'Test Process Technology',
                                     Family = 'PROCESSTECHCOM0001',
                                     ProductCode = 'PROCESSTECH0001',
                                     Product_External_ID__c = 'PROCESSTECH0001' + Math.Random(),
                                     BEOL__c = 'AA BB CC',
                                     FEOL__c = 'DD EE FF',
                                     APTPS_Core_Voltage__c = '1.50',
                                     APTPS_IO_Voltage__c = '1.50',
                                     Geometry__c = '0.028nm',
                                     Mask_Sets__c = '',
                                     Apttus_Config2__ConfigurationType__c = 'Bundle',
                                     PDK_Version__c = 'V6',
                                     IsActive = True);
                Database.insert(prod);
                 
                
                System.assertEquals(prod.PDK_Version__c,'V6');
            
              Apttus_Proposal__Proposal_Line_Item__c proposalLineItem = 
              new Apttus_Proposal__Proposal_Line_Item__c(Apttus_QPConfig__LineNumber__c = 2,
                                                         Apttus_QPConfig__ItemSequence__c = 2,
                                                         Apttus_Proposal__Product__c = prod.Id,
                                                         Apttus_Proposal__Proposal__c = proposalId,
                                                         Apttus_QPConfig__OptionId__c = ip1.Id,
                                                         Apttus_QPConfig__ConfigurationId__c = prodConfigId/*,
                                                         Apttus_QPConfig__AttributeValueId__c = attrib.Id*/);
                                                         
                Database.insert(proposalLineItem);
                 System.assert(proposalLineItem.id != null);
                Apttus_Proposal__Proposal_Line_Item__c pl = createProposalLineItem(1, proposal.Id, ip1.Id,prodConfigId);            
                Database.insert(pl);
                
                
                 ApexPages.currentPage().getParameters().put('id',proposalId);
                ApexPages.currentPage().getParameters().put('flow','GFFlow');
                ApexPages.currentPage().getParameters().put('Name','prodscope_1');
                
                
               CPQPDKCheckController  Pdkcheck = new CPQPDKCheckController();
               pdkcheck.CheckPDK();
                
                
            Test.stopTest();
        }
    }catch(Exception excp) {
                GlobalUtility.logMessage('Error','CPQPDKCheckControllerTest','testProposalSummaryPDK2','','Exception while updating pdk version in proposal in Test class',String.valueof(excp.getMessage()),'','Apttus CPQ',excp,0);
             }
    
    }
    



}