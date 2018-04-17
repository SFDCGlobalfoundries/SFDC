/*
  Author: Anirban Roy
  Description: This is the test class for controller class for the Summary page for Configurator.
  History:
    ARoy        10202014    - code creation.              
*/
@isTest(SeeAllData=false)
public class ProposalSummaryTest {
    
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
        fieldValueMap.put('Fab_9_10__c','Yes');
        fieldValueMap.put('Bill_To_Address_1__c','Test Address');
        fieldValueMap.put('Account_Profile__c','Fabless - Emerging');
        fieldValueMap.put('Bill_To_City__c','Test City');
        fieldValueMap.put('Bill_To_Country__c','India');
        fieldValueMap.put('recordtypeid', EnvironmentVariable.get('ACCT_RT_ID_CUSTOMER'));   
        AccountDataFactory.createAccount(fieldValueMap);
        Test.startTest();
         createPTSwapRecord();
        Test.stopTest(); 
        
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
    
    static testMethod void testProposalSummary(){
        
        User admin = DeviceChecklistTestDataUtils.createUserWithDCAdmin('System Administrator');
        System.runAs(admin){
            IntegrationUsers__c skipUser = new IntegrationUsers__c(SetupOwnerId = admin.Id, Is_Integration_User__c= true, Skip_Trigger__c = true, Skip_Validation_Rule__c = true);
            insert skipUser;
        
            Account acc = createAccount();
            
            Opportunity opp = createOpp(acc.Id);                
            Opportunity_Program__c oppProg = createOppProg(acc.Id,opp.Id);
            Device__c dev = createCMPWDevice(acc.Id,oppProg.Id);
                 
            
            Test.startTest();
                Apttus_Proposal__Proposal__c proposal = createProposal(acc.Id, opp.Id, dev.Id, null, 'AB,CD',null);
                String proposalId = proposal.Id;
                String prodConfigId = createProdConfig(proposalId);
                
                Product2 ip1 = createOptionProduct('Test Add Ques', 'RF', 'TESTAddQues0001', 'AA');
                insert ip1;
                
                Apttus_Proposal__Proposal_Line_Item__c pl = createProposalLineItem(1, proposal.Id, ip1.Id,prodConfigId);            
                insert pl;
                
                ApexPages.currentPage().getParameters().put('retId',proposalId);                
                ApexPages.currentPage().getParameters().put('Id',prodConfigId);
                ProposalSummary ps = new ProposalSummary();
                proposalId = null;
                ps.uploadGDS();
                proposalId = proposal.Id;
                system.debug('test class proposalId===>'+proposalId);
                
                ps.prodAttVal = new Apttus_Config2__ProductAttributeValue__c();
                
                ps.init();
                Apexpages.currentPage().getHeaders().put('Referer','/apex/ProposalSummary');
                Apexpages.currentPage().getHeaders().put('Origin','--c');
                
                PageReference pr;
                pr = ps.finalize();
                system.assert(pr.getUrl().contains(proposalId));
                pr = ps.uploadGDS();
                system.assert(pr.getUrl().contains('/apex/GDSUPLOAD?id='+ proposalId));
                pr = ps.redirectToCatalog();
                
                Apexpages.currentPage().getHeaders().put('Referer','GlobalfoundryView');
                Apexpages.currentPage().getHeaders().put('Origin','--c');
                pr = ps.finalize();
                system.assert(pr.getUrl().contains('/GlobalfoundryView/'+proposalId));
                pr = ps.uploadGDS();
                system.assert(pr.getUrl().contains('/GlobalfoundryView/apex/GDSUPLOAD?id='+ proposalId));
                pr = ps.redirectToCatalog();
                
            Test.stopTest();
        }
    }          
    /*static testMethod void testProposalSummaryPDK(){

        
        User admin = DeviceChecklistTestDataUtils.createUserWithDCAdmin('System Administrator');
        System.runAs(admin){
            IntegrationUsers__c skipUser = new IntegrationUsers__c(SetupOwnerId = admin.Id, Is_Integration_User__c= true, Skip_Trigger__c = true, Skip_Validation_Rule__c = true);
            insert skipUser;
        
            Account acc = createAccount();
            
            Opportunity opp = createOpp(acc.Id);                
            Opportunity_Program__c oppProg = createOppProg(acc.Id,opp.Id);
            Device__c dev = DeviceUtilTest.createCMPWDevice(acc.Id,oppProg.Id);
            Insert dev;           
            
            Test.startTest();
                Apttus_Proposal__Proposal__c proposal = createProposal(acc.Id, opp.Id, dev.Id, null, 'AB,CD');
                String proposalId = proposal.Id;
                String prodConfigId = createProdConfig(proposalId);
                
                Product2 ip1 = createOptionProduct('Test Add Ques', 'Devices', 'TESTAddQues0001', 'AA');
            
                insert ip1;
                                                
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
                insert prod;
            
              Apttus_Proposal__Proposal_Line_Item__c proposalLineItem = 
              new Apttus_Proposal__Proposal_Line_Item__c(Apttus_QPConfig__LineNumber__c = 2,
                                                         Apttus_QPConfig__ItemSequence__c = 2,
                                                         Apttus_Proposal__Product__c = prod.Id,
                                                         Apttus_Proposal__Proposal__c = proposalId,
                                                         Apttus_QPConfig__OptionId__c = ip1.Id,
                                                         Apttus_QPConfig__ConfigurationId__c = prodConfigId);//,
                                                         //Apttus_QPConfig__AttributeValueId__c = attrib.Id);
                                                         
                insert proposalLineItem;
            
                Apttus_Proposal__Proposal_Line_Item__c pl = createProposalLineItem(1, proposal.Id, ip1.Id,prodConfigId);            
                insert pl;
                
                ApexPages.currentPage().getParameters().put('retId',proposalId);
                ApexPages.currentPage().getParameters().put('Id',prodConfigId);
                system.debug('test class proposalId===>'+proposalId);
                ProposalSummary ps = new ProposalSummary();
                ps.prodAttVal = new Apttus_Config2__ProductAttributeValue__c();
                
                ps.init();
                
                
            Test.stopTest();
        }
    }*/
    static testMethod void testProposalSummary2(){
               
        User admin = DeviceChecklistTestDataUtils.createUserWithDCAdmin('System Administrator');
        
        System.runAs(admin){
            IntegrationUsers__c skipUser = new IntegrationUsers__c(SetupOwnerId = admin.Id, Is_Integration_User__c= true, Skip_Trigger__c = true, Skip_Validation_Rule__c = true);
            insert skipUser;
                   
            Account acc = createAccount();  
                   
            Opportunity opp = createOpp(acc.Id);
            
            
            Opportunity_Program__c oppProg = createOppProg(acc.Id,opp.Id);
            
            Device__c dev = createCMPWDevice(acc.Id,oppProg.Id);
            Test.startTest(); 
            Apttus_Proposal__Proposal__c proposal = createProposal(acc.Id, opp.Id, dev.Id, null, 'AB,CD',null);
            String proposalId = proposal.Id;
            String prodConfigId = createProdConfig(proposalId);
            
                                       
               
                List<Product2> prodList = new List<Product2>();
                Product2 ip1 = createOptionProduct('Test Device 1', 'Devices', 'TESTDev0001', 'AB');
                Product2 ip2 = createOptionProduct('Test Device 2', 'Devices', 'TESTDev0002', 'AC');
                prodList.add(ip1);
                prodList.add(ip2);
                insert prodList;
                
                List<Apttus_Proposal__Proposal_Line_Item__c> plList = new List<Apttus_Proposal__Proposal_Line_Item__c>();
                Apttus_Proposal__Proposal_Line_Item__c pl1 = createProposalLineItem(1, proposal.Id, ip1.Id,prodConfigId);                                
                Apttus_Proposal__Proposal_Line_Item__c pl2 = createProposalLineItem(1, proposal.Id, ip2.Id,prodConfigId);
                plList.add(pl1);
                plList.add(pl2);
                insert plList;
                
                ApexPages.currentPage().getParameters().put('retId',proposalId);
                ApexPages.currentPage().getParameters().put('Id',prodConfigId);
                system.debug('test class proposalId===>'+proposalId);
                ProposalSummary ps = new ProposalSummary();
                ps.prodAttVal = new Apttus_Config2__ProductAttributeValue__c();
                
                ps.init();
               
                Apexpages.currentPage().getHeaders().put('Referer','/apex/ProposalSummary');
                Apexpages.currentPage().getHeaders().put('Origin','--c');
                
                PageReference pr;
                pr = ps.finalize();
                system.assert(pr.getUrl().contains(proposalId));
                pr = ps.uploadGDS();
                system.assert(pr.getUrl().contains('/apex/GDSUPLOAD?id='+ proposalId));
                pr = ps.redirectToCatalog();

                
                Apexpages.currentPage().getHeaders().put('Referer','GlobalfoundryView');
                Apexpages.currentPage().getHeaders().put('Origin','--c');
                pr = ps.finalize();
                system.assert(pr.getUrl().contains('/GlobalfoundryView/'+proposalId));
                pr = ps.uploadGDS();
                system.assert(pr.getUrl().contains('/GlobalfoundryView/apex/GDSUPLOAD?id='+ proposalId));
                pr = ps.redirectToCatalog();
                
             Test.stopTest();
        }
    } 
    
    
    static testMethod void testProposalSummary3(){                 
        
        User admin = DeviceChecklistTestDataUtils.createUserWithDCAdmin('System Administrator');
        System.runAs(admin){
            IntegrationUsers__c skipUser = new IntegrationUsers__c(SetupOwnerId = admin.Id, Is_Integration_User__c= true, Skip_Trigger__c = true, Skip_Validation_Rule__c = true);
            insert skipUser;
  
            Account acc = createAccount();       
            Opportunity opp = createOpp(acc.Id);
            
           
            Opportunity_Program__c oppProg = createOppProg(acc.Id,opp.Id);
            Device__c dev = DeviceUtilTest.createCMPWDevice(acc.Id,oppProg.Id);
           // Insert dev;
               Test.startTest();
                Apttus_Proposal__Proposal__c proposal = createProposal(acc.Id, opp.Id, dev.Id, null, 'AB,CD',null);
                String proposalId = proposal.Id;
                String prodConfigId = createProdConfig(proposalId);
                
                Product2 ip1 = createOptionProduct('Test IP 1', 'IPs', 'TESTIP0001', 'AC');
                insert ip1;
                Apttus_Proposal__Proposal_Line_Item__c pl = createProposalLineItem(1, proposal.Id, ip1.Id,prodConfigId); 
                insert pl;          
    
                ApexPages.currentPage().getParameters().put('retId',proposalId);
                ApexPages.currentPage().getParameters().put('Id',prodConfigId);
                system.debug('test class proposalId===>'+proposalId);
                ProposalSummary ps = new ProposalSummary();
                ps.isMultiSourceTapeout = true;
                ps.prodAttVal = new Apttus_Config2__ProductAttributeValue__c();
                
                ps.init();
                Apexpages.currentPage().getHeaders().put('Referer','/apex/ProposalSummary');
                Apexpages.currentPage().getHeaders().put('Origin','--c');
                
                PageReference pr;
                pr = ps.finalize();
                system.assert(pr.getUrl().contains(proposalId));
                pr = ps.uploadGDS();
                system.assert(pr.getUrl().contains('/apex/GDSUPLOAD?id='+ proposalId));
                pr = ps.redirectToCatalog();
                
                Apexpages.currentPage().getHeaders().put('Referer','GlobalfoundryView');
                Apexpages.currentPage().getHeaders().put('Origin','--c');
                pr = ps.finalize();
                system.assert(pr.getUrl().contains('/GlobalfoundryView/'+proposalId));
                pr = ps.uploadGDS();
                system.assert(pr.getUrl().contains('/GlobalfoundryView/apex/GDSUPLOAD?id='+ proposalId));
                pr = ps.redirectToCatalog();
                
            Test.stopTest();
        }
    }
    
    static testMethod void testProposalSummary4(){                 
        
        User admin = DeviceChecklistTestDataUtils.createUserWithDCAdmin('System Administrator');
        System.runAs(admin){
            IntegrationUsers__c skipUser = new IntegrationUsers__c(SetupOwnerId = admin.Id, Is_Integration_User__c= true, Skip_Trigger__c = true, Skip_Validation_Rule__c = true);
            insert skipUser;
            Account acc = createAccount();
            
            Opportunity opp = createOpp(acc.Id);
            
            
            Opportunity_Program__c oppProg = createOppProg(acc.Id,opp.Id);
            Device__c dev = createCMPWDevice(acc.Id,oppProg.Id);
            
            
            Test.startTest();
                Apttus_Proposal__Proposal__c proposal = createProposal(acc.Id, opp.Id, dev.Id, null, 'AB,CD',null);
                String proposalId = proposal.Id;
                String prodConfigId = createProdConfig(proposalId);
                
                Product2 ip1 = createOptionProduct('Spice Model for HSPICE', 'Additional Questions', 'TESTAddQues001', 'AC');
                insert ip1;
                Apttus_Proposal__Proposal_Line_Item__c pl = createProposalLineItem(1, proposal.Id, ip1.Id,prodConfigId);           
                insert pl;
                
                ApexPages.currentPage().getParameters().put('retId',proposalId);
                ApexPages.currentPage().getParameters().put('Id',prodConfigId);
                system.debug('test class proposalId===>'+proposalId);
                ProposalSummary ps = new ProposalSummary();
                ps.isMultiSourceTapeout = true;
                ps.prodAttVal = new Apttus_Config2__ProductAttributeValue__c();
                
                ps.init();
                Apexpages.currentPage().getHeaders().put('Referer','/apex/ProposalSummary');
                Apexpages.currentPage().getHeaders().put('Origin','--c');
                
                PageReference pr;
                pr = ps.finalize();
                system.assert(pr.getUrl().contains(proposalId));
                pr = ps.uploadGDS();
                system.assert(pr.getUrl().contains('/apex/GDSUPLOAD?id='+ proposalId));
                pr = ps.redirectToCatalog();
                
            Test.stopTest();
        }
    }

    static testMethod void testProposalSummary5(){                 
        PCM_Administration__c pcmAdmin = new PCM_Administration__c(Name='CURRENT_SETTING',Catalog_ID__c='PCM215',PCM_Fabs__c='FAB 2',Version_ID__c ='1');
        insert pcmAdmin;
        User admin = DeviceChecklistTestDataUtils.createUserWithDCAdmin('System Administrator');
        System.runAs(admin){
            IntegrationUsers__c skipUser = new IntegrationUsers__c(SetupOwnerId = admin.Id, Is_Integration_User__c= true, Skip_Trigger__c = true, Skip_Validation_Rule__c = true);
            insert skipUser;
            Account acc = createAccount();
            
            Opportunity opp = createOpp(acc.Id);
            
            
            Opportunity_Program__c oppProg = createOppProg(acc.Id,opp.Id);
            Device__c dev = createCMPWDevice(acc.Id,oppProg.Id);
            
            
            Test.startTest();
                Apttus_Proposal__Proposal__c proposal = createProposal(acc.Id, opp.Id, dev.Id, null, 'AB,CD',null);
                String proposalId = proposal.Id;
                String prodConfigId = createProdConfig(proposalId);
                
                Product2 ip1 = createOptionProduct('Spice Model for HSPICE', 'Additional Questions', 'TESTAddQues001', 'AC');
                insert ip1;
                Apttus_Proposal__Proposal_Line_Item__c pl = createProposalLineItem(1, proposal.Id, ip1.Id,prodConfigId);           
                insert pl;
                
                ApexPages.currentPage().getParameters().put('retId',proposalId);
                ApexPages.currentPage().getParameters().put('Id',prodConfigId);
                system.debug('test class proposalId===>'+proposalId);
                ProposalSummary ps = new ProposalSummary();
                ps.isMultiSourceTapeout = true;
                ps.prodAttVal = new Apttus_Config2__ProductAttributeValue__c();
                
                ps.init();
                
                Apexpages.currentPage().getHeaders().put('Referer','GlobalfoundryView');
                Apexpages.currentPage().getHeaders().put('Origin','--c');
                PageReference pr;
                pr = ps.finalize();
                system.assert(pr.getUrl().contains('/GlobalfoundryView/'+proposalId));
                pr = ps.uploadGDS();
                system.assert(pr.getUrl().contains('/GlobalfoundryView/apex/GDSUPLOAD?id='+ proposalId));                
                pr = ps.redirectToCatalog();                
            Test.stopTest();
        }
    }
    
    static testMethod void testProposalSummary6(){                 
        
        User admin = DeviceChecklistTestDataUtils.createUserWithDCAdmin('System Administrator');
        System.runAs(admin){
            IntegrationUsers__c skipUser = new IntegrationUsers__c(SetupOwnerId = admin.Id, Is_Integration_User__c= true, Skip_Trigger__c = true, Skip_Validation_Rule__c = true);
            insert skipUser;
            Account acc = createAccount();
            
            Opportunity opp = createOpp(acc.Id);
            
            
            Opportunity_Program__c oppProg = createOppProg(acc.Id,opp.Id);
            Device__c dev = createCMPWDevice(acc.Id,oppProg.Id);
            Form_Management_System__c formObj = new Form_Management_System__c(
                Device__c = dev.Id,
                Customer_Name__c = acc.Id,
                Name__c = 'Test Name',
                Form_Name__c = 'Test Main Form',                 
                Form_Description__c = 'Test Description', 
                Technology__c = 'CSOI 7RF', 
                TestServices__c = 'Yes', 
                Packaging_Services__c = 'No', 
                RecordTypeId = Schema.SObjectType.Form_Management_System__c.getRecordTypeInfosByName().get('Main Product Definition Form').getRecordTypeId(),
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
                Apttus_Proposal__Proposal__c proposal = createProposal(acc.Id, opp.Id, dev.Id, null, 'AB,CD',formObj.Id);
                String proposalId = proposal.Id;
                String prodConfigId = createProdConfig(proposalId);
                
                Apttus_Proposal__Proposal_Line_Item__c pl = createProposalLineItem(1, proposal.Id, null,prodConfigId);           
                insert pl;
                
                ApexPages.currentPage().getParameters().put('retId',proposalId);
                ApexPages.currentPage().getParameters().put('Id',prodConfigId);
                system.debug('test class proposalId===>'+proposalId);
                ProposalSummary ps = new ProposalSummary();
                ps.isMultiSourceTapeout = true;
                ps.prodAttVal = new Apttus_Config2__ProductAttributeValue__c();
                ps.init();
                ps.finalize();                
                
            Test.stopTest();
        }
    }
    
    static testMethod void testProposalSummary7(){                 
        PCM_Administration__c pcmAdmin = new PCM_Administration__c(Name='CURRENT_SETTING',Catalog_ID__c='PCM215',PCM_Fabs__c='FAB 2',Version_ID__c ='1');
        insert pcmAdmin;
        User admin = DeviceChecklistTestDataUtils.createUserWithDCAdmin('System Administrator');
        System.runAs(admin){
            IntegrationUsers__c skipUser = new IntegrationUsers__c(SetupOwnerId = admin.Id, Is_Integration_User__c= true, Skip_Trigger__c = true, Skip_Validation_Rule__c = true);
            insert skipUser;
            Account acc = createAccount();
            
            Opportunity opp = createOpp(acc.Id);
            
            
            Opportunity_Program__c oppProg = createOppProg(acc.Id,opp.Id);
            Device__c dev = createCMPWDevice(acc.Id,oppProg.Id);
            
            
            Test.startTest();
                Apttus_Proposal__Proposal__c proposal = createProposal1(acc.Id, opp.Id, dev.Id, null, 'AB,CD',null);                                
                ProposalSummary ps = new ProposalSummary();
                ps.redirectToCatalog();                
            Test.stopTest();
        }
    }
    
    static testMethod void testProposalSummarySwapPT(){
         
        User admin = DeviceChecklistTestDataUtils.createUserWithDCAdmin('System Administrator');
        System.runAs(admin){
            IntegrationUsers__c skipUser = new IntegrationUsers__c(SetupOwnerId = admin.Id, Is_Integration_User__c= true, Skip_Trigger__c = true, Skip_Validation_Rule__c = true);
            insert skipUser;
            Account acc = createAccount();
            
            Opportunity opp = createOpp(acc.Id);
            
            
            Opportunity_Program__c oppProg = createOppProg(acc.Id,opp.Id);
            Device__c dev = createCMPWDevice(acc.Id,oppProg.Id);
            createPTSwapRecord();
            createProcesstech();
            
            Test.startTest();
                //insert dev;
                Apttus_Proposal__Proposal__c proposal = createProposal(acc.Id, opp.Id, dev.Id, null, 'AB,CD',null);   
                String prodConfigId = createProdConfig(proposal.Id); 
                proposal.Process_Technology__c = 'PTLPSQTI';
                proposal.Actual_Tapeout_Date_FAB_9_and_FAB_10__c = system.today();   
                update proposal;
                PageReference pageRef = Page.ProposalSummary;
                Test.setCurrentPage(pageRef);
                ApexPages.currentPage().getParameters().put('retId',proposal.Id);
                ApexPages.currentPage().getParameters().put('Id',prodConfigId);
                Apexpages.currentPage().getHeaders().put('Referer','GlobalfoundryView');
                Apexpages.currentPage().getHeaders().put('Origin','--c');
                ProposalSummary ps = new ProposalSummary();          
                ps.proposal = proposal;
                GenerateYieldAndCost.hasRun = false;
                ps.init();
                ps.finalize();
               
                 
            Test.stopTest();
        }
    } 
    
    //Static method to create Account test record
    static Account createAccount(){
                                       
          Account acc= getAccount('Test Account 009');
          return acc;
        
    }
    
    //Static method to create Opportunity test record
    static Opportunity createOpp(Id acctId){
      Map<String,Object> fieldValueMap = new Map<String,Object>();
        fieldValueMap.put('AccountId',acctId);
        fieldValueMap.put('Name','Test Opportunity');  
        fieldValueMap.put('StageName','1. Discovery');
        fieldValueMap.put('CloseDate',date.newinstance(2012, 12, 21));  
        fieldValueMap.put('Target_Process_Node__c','14XM');
        fieldValueMap.put('Market_Segment__c','Automotive');  
        fieldValueMap.put('Process_Platform__c','GF Baseline');
        fieldValueMap.put('Fab_Split__c',100);          
        fieldValueMap.put('Process_Geometry__c','0.014UM');  
        fieldValueMap.put('Process_Family__c','Super Low Power');
        fieldValueMap.put('Opportunity_Sourcing_Type__c','First Source');  
        fieldValueMap.put('Fab_Assignment_1__c','FAB 1');
         
        return OpportunityDataFactory.createOpportunity(fieldValueMap);
        
    }

    //Static method to create Opportunity Program test record
    static Opportunity_Program__c createOppProg(Id acctId, Id oppId){
        Opportunity_Program__c opProg = 
                    new Opportunity_Program__c(Name = 'Test OppProg',
                                               Account__c = acctId,
                                               Opportunity__c = oppId);
        insert opProg;
        return opProg;
    }    
    
    //Static method to create proposal test record
    static Apttus_Proposal__Proposal__c createProposal(Id accId, Id oppId, Id devId, Id tmrmId, String szMaskSet, Id formId){
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
                                                     Apttus_Proposal__Account__c = accId,
                                                     RecordTypeId = recType.Id,
                                                     FMS_Proposal__c = formId);
        
        insert proposal;
        return proposal;
    }
    
    //Static method to create proposal test record
    static Apttus_Proposal__Proposal__c createProposal1(Id accId, Id oppId, Id devId, Id tmrmId, String szMaskSet, Id formId){
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
                                                     Apttus_Proposal__Account__c = accId,
                                                     RecordTypeId = recType.Id,
                                                     FMS_Proposal__c = formId,
                                                     Deliverable_Part_Type__c = 'Wafer');
        
        insert proposal;
        return proposal;
    }
    
    //Static method to create product test record
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
    
    
    
    //Static method to create proposal line item test record
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
                                     IsActive = True,
                                     PDK_Version__c = 'V1');
        
        insert prod;
        return prod;
    }
    
    static Id createProdConfig(Id configId){
        Apttus_Config2__ProductConfiguration__c pc = new Apttus_Config2__ProductConfiguration__c();
        pc.Apttus_QPConfig__Proposald__c = configId;
        insert pc;
        return pc.id;
    }        

    
     private static void createPTSwapRecord(){
        try{
            CPQ_SwapProcessTechnology__c swap = new CPQ_SwapProcessTechnology__c();
            swap.Name = 'PTLPSQTI';
            swap.Replace_with_PT__c = 'PTLPS';
            Database.insert(swap);
            
            System.assertEquals(swap.Name,'PTLPSQTI');
           }catch(Exception excp){
                 GlobalUtility.logMessage('Error','ProposalSummaryTest','createPTSwapRecord','','Exception while custom setting record',String.valueof(excp.getMessage()),'','Apttus CPQ',excp,0);
              } 
    } 
    
    static void createProcesstech(){
        Process_Technology__c ptech = new Process_Technology__c(PT_Number__c = 'PTLPS');
        insert ptech;
    }  
    
    private static Account getAccount(string AccountName)
    {
        Account accntObj1 = [SELECT Id, Name FROM Account Where Name =: AccountName];
        
        return accntObj1;
    }  
       
}