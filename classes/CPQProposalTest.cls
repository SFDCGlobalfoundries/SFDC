/******************************************************************************************************************************
Class:         CPQProposalTest 
-------------------------------------------------------------------------------------------------------------------------------
Author:        Joydev Mondol (Cognizant - 153480)
Created Date:  28/10/2013
Reason:        Test class for triggers and classes on Proposal object
Vijay       16012015    - Updated the Device Stage 'Solution' to 'Design In' as Device will be created in 
                                  'Design In' directly and added mandatory fields.
*******************************************************************************************************************************/
               
@isTest(SeeAllData=false)
private class CPQProposalTest{
    @testSetup 
     static void testDataSetup(){
        DataUtilTest.loadEnvironmentVariables();
        
        ConfiguratorApprovalSetting__c obj=new ConfiguratorApprovalSetting__c(Default_Approver__c=UserInfo.getUserId(),FAB_Name__c='FAB 2,FAB 3,FAB 3E,FAB 7,FAB 5,FAB 6',Maximum_Approver__c=15);
        insert obj;
        
     }
    static testMethod void testProposalInsertTriggerFromTeamroom(){
        //Setup the Proposal test record types and cause the insert trigger to excecute
        Account acc = createAccount();
        
        Opportunity opp = createOpp(acc.Id);
        
        Team_Room__c tmrm = createTeamroom(acc.Id);
        Team_Room_Member__c tmrmmbr = createTeamroomMember(tmrm.Id);
        
        Test.startTest();
        Apttus_Proposal__Proposal__c proposal = createProposal(acc.Id, opp.Id, Null, tmrm.Id, Null);
        Test.stopTest();
    }
    
    static testMethod void testProposalInsertTriggerFromDevice(){
        //Setup the Proposal test record types and cause the insert trigger to excecute
        Account acc = createAccount();
        
        Opportunity opp = createOpp(acc.Id);
        
        Opportunity_Program__c oppProg = createOppProg(acc.Id,opp.Id);
        Device__c dev = createDevice(acc.Id, opp.Id, oppProg.Id);
                
        Test.startTest();
        Apttus_Proposal__Proposal__c proposal = createProposal(acc.Id, opp.Id, dev.Id, Null, Null);
        Test.stopTest();
    }

    static testMethod void testProposalUpdateTriggerFromTeamroomWithDevice(){     
        //Setup the Proposal test record types and cause the insert trigger to excecute
        User admin = DeviceChecklistTestDataUtils.createUserWithDCAdmin('System Administrator');
        System.runAs(admin){
            IntegrationUsers__c skipUser = new IntegrationUsers__c(SetupOwnerId = admin.Id, Is_Integration_User__c= true, Skip_Trigger__c = true, Skip_Validation_Rule__c = true);
            insert skipUser;
      Account acc = createAccount();
      
      Opportunity opp = createOpp(acc.Id);
      
      Team_Room__c tmrm = createTeamroom(acc.Id);
      Team_Room_Member__c tmrmmbr = createTeamroomMember(tmrm.Id);
      
      Opportunity_Program__c oppProg = createOppProg(acc.Id,opp.Id);
      Device__c dev = createDevice(acc.Id, opp.Id, oppProg.Id);
      
      Test.startTest();
      Apttus_Proposal__Proposal__c proposal = createProposal(acc.Id, opp.Id, Null, tmrm.Id, Null);
      
      //Update the proposal
      proposal.Device__c = dev.Id;
      
      //Cause the trigger to excecute
      
      update proposal;
      Test.stopTest();
    }
    }
    
    static testMethod void testProposalUpdateTriggerFromTeamroomWithAccount(){     
        //Setup the Proposal test record types and cause the insert trigger to excecute
        system.Test.setMock(WebServiceMock.class, new NDA_IntegrationServiceWebServiceMock() );
        checkRecursive.runOnceAgain = false;
        checkRecursive.run = false;
        //BPMConfigurationPlusIntegration.hasRun = true;
        
    List<CPQ_Customer_Price_List__c> custPriceList = new List<CPQ_Customer_Price_List__c>();
        CPQ_Customer_Price_List__c custPriceList1 
                    = new CPQ_Customer_Price_List__c(name='gfsinternal',Price_List__c='GLOBALFOUNDRIES Internal Price List');
        CPQ_Customer_Price_List__c custPriceList2 
                    = new CPQ_Customer_Price_List__c(name='multisource',Price_List__c='Multi-Source Internal Price List');
        custPriceList.add(custPriceList1);
        custPriceList.add(custPriceList2);
        insert custPriceList;
        
        List<Apttus_Config2__PriceList__c> plList = new List<Apttus_Config2__PriceList__c>();
        Apttus_Config2__PriceList__c pl1 
            = new Apttus_Config2__PriceList__c(name='GLOBALFOUNDRIES Internal Price List',
                                               Apttus_Config2__Description__c = 'GLOBALFOUNDRIES Internal Price List',
                                               Apttus_Config2__Type__c = 'Standard',
                                               Apttus_Config2__Active__c = true
                                              );
        Apttus_Config2__PriceList__c pl2 
            = new Apttus_Config2__PriceList__c(name='Multi-Source Internal Price List',
                                               Apttus_Config2__Description__c = 'Multi-Source Internal Price List',
                                               Apttus_Config2__Type__c = 'Standard',
                                               Apttus_Config2__Active__c = true
                                              );
        plList.add(pl1);
        plList.add(pl2);
        insert plList;
    
        User admin = DeviceChecklistTestDataUtils.createUserWithDCAdmin('System Administrator');
        System.runAs(admin){
            IntegrationUsers__c skipUser = new IntegrationUsers__c(SetupOwnerId = admin.Id, Is_Integration_User__c= true, Skip_Trigger__c = true, Skip_Validation_Rule__c = true);
            insert skipUser;
            Account acc = createAccount();
            
            //Apttus__APTS_Agreement__c agrmnt = createAgreement(acc.Id);
            
            Opportunity opp = createOpp(acc.Id);
            
            Opportunity_Program__c oppProg = createOppProg(acc.Id,opp.Id);
            Device__c dev = DeviceUtilTest.createCMPWDevice(acc.Id,oppProg.Id);
            Insert dev;
            //createDevice(acc.Id, opp.Id, oppProg.Id);
            
            Team_Room__c tmrm = createTeamroom(acc.Id);
            //Team_Room_Member__c tmrmmbr = createTeamroomMember(tmrm.Id);
            
            
            //Apttus_Proposal__Proposal__c proposal = createProposal(acc.Id, opp.Id, Null, tmrm.Id, Null);
            Apttus_Proposal__Proposal__c proposal = createProposal(Null, Null, Null, tmrm.Id, Null);
            Test.startTest();
                //Update the proposal
                proposal.Device__c = dev.Id;
                proposal.Apttus_Proposal__Account__c = acc.Id;
                proposal.Apttus_Proposal__Opportunity__c = opp.Id;        
                
                //Cause the trigger to excecute
                
                update proposal;
            Test.stopTest();
        }
    }

    static testMethod void testProposalUpdateTriggerFromTeamroomWithMaskSet(){     
        //Setup the Proposal test record types and cause the insert trigger to excecute
        Account acc = createAccount();
        
        Opportunity opp = createOpp(acc.Id);
        
        Team_Room__c tmrm = createTeamroom(acc.Id);
        Team_Room_Member__c tmrmmbr = createTeamroomMember(tmrm.Id);
        
        Apttus_Proposal__Proposal__c proposal = createProposal1(acc.Id, opp.Id, Null, tmrm.Id, Null);
    
        //Update the proposal
        proposal.Mask_Set__c = 'AA BB CC DD EE FF';        
        //changed reference of Mask_Set__c to Mask_Set_Long__c for the Case#00051463
        proposal.Mask_Set_Long__c = 'AA BB CC DD EE FF';
        
        //Cause the trigger to excecute
        Test.startTest();
        update proposal;
        Test.stopTest();
    }
    
    static testMethod void testProposalUpdateTriggerFromDeviceWithTeamroom(){     
        //Setup the Proposal test record types and cause the insert trigger to excecute
        Account acc = createAccount();
        
        Opportunity opp = createOpp(acc.Id);
        
        Team_Room__c tmrm = createTeamroom(acc.Id);
        Opportunity_Program__c oppProg = createOppProg(acc.Id,opp.Id);
        Test.startTest();
        Device__c dev = DeviceUtilTest.createCMPWDevice(acc.Id,oppProg.Id);
        Insert dev;
        //createDevice(acc.Id, opp.Id, oppProg.Id);
        
        Apttus_Proposal__Proposal__c proposal = createProposal(acc.Id, opp.Id, dev.Id, Null, Null);
    
        //Update the proposal
        proposal.Team_Room__c = tmrm.Id;
        
        //Cause the trigger to excecute
        
        update proposal;
        Test.stopTest();                
    }

    static testMethod void testProposalUpdateTriggerFromDeviceWithAccount(){     
        //Setup the Proposal test record types and cause the insert trigger to excecute
        system.Test.setMock(WebServiceMock.class, new NDA_IntegrationServiceWebServiceMock() );
        

            
        //Account acc2 = createAccount();
        Id accId = createAccountNew();
        
        //Account acc2 = createAccount();
        Apttus__APTS_Agreement__c agrmnt = createAgreement(accId);
        
    
        //Apttus__APTS_Agreement__c agrmnt2 = createAgreement(acc2.Id);              
        
        Id oppId = createOpportunityNew(accId);
        //Opportunity opp2 = createOpp(acc2.Id);
        
        
        Opportunity_Program__c oppProg = createOppProg(accId, oppId);
        //Id oppProg2Id = createOpportunityProgramNew(acc2.Id, opp2.Id);
    
    Test.startTest();
    
        Device__c dev = DeviceUtilTest.createCMPWDevice(accId,oppProg.Id);
        Insert dev;
        //createDevice(accId, oppId, oppProg.Id);
        //Device__c dev2 = createDevice(acc2.Id, opp2.Id, oppProg2.Id);
       
                 
        Apttus_Proposal__Proposal__c proposal = createProposal(accId, oppId, dev.Id, Null, Null);
    
        
     Test.stopTest();  
    }
    
    static testMethod void testProposalUpdateTriggerFromDeviceWithMaskSet(){     
        //Setup the Proposal test record types and cause the insert trigger to excecute
        checkRecursive.runOnceAgain = false;
        checkRecursive.run = false;
        //BPMConfigurationPlusIntegration.hasRun = true;
                
        Account acc = createAccount();
        //User u = createUser(acc.Id);
        
        Opportunity opp = createOpp(acc.Id);        
        
        Opportunity_Program__c oppProg = createOppProg(acc.Id,opp.Id);            
               
        Device__c dev = DeviceUtilTest.createCMPWDevice(acc.Id,oppProg.Id);
        Insert dev;
        //createDevice(acc.Id, opp.Id, oppProg.Id);                       
               
        Test.startTest();
    Apttus_Proposal__Proposal__c proposal = createProposal(acc.Id, opp.Id, dev.Id, Null, Null);
        
        
        proposal.APTPS_Primary__c = true;
        //update proposal;
        
        
        List<Apttus_Proposal__Proposal_Line_Item__c> lstLineItems = 
                        new List<Apttus_Proposal__Proposal_Line_Item__c>();
        
        List<Process__c> lstPIDs = new List<Process__c>();
        List<Product2> prodList = new List<Product2>();
                
        Product2 processTech4Com = createProduct('Test Process Technology', 'PROCESSTECHCOM0001', 'CC,DD,EE', 'PROCESSTECHCOM0002');        
        prodList.add(processTech4Com);
        Product2 processTech = createProduct('Test Process Technology', 'PROCESSTECH0001', null, 'PROCESSTECHCOM0003');        
        prodList.add(processTech);
        insert prodList;
        Apttus_Proposal__Proposal_Line_Item__c lineItem1 = createProposalLineItem(1, proposal.Id, processTech4Com.Id);
        lstLineItems.add(lineItem1);
        
        Product2 ms1 = createOptionProduct('Test Mask 1', 'Mask Layers', 'TESTMASK0001', 'CC', Null);
        //Apttus_Proposal__Proposal_Line_Item__c lineItem2 = createProposalLineItem(2, proposal.Id, null);
        Product2 dev2 = createOptionProduct('Test Device 1', 'Devices', 'TESTDEV0001', 'CD', Null);
        Product2 devSRAM = createOptionProduct('Test SRAM Device', 'Devices', 'TESTSRAM0001', 'CD', Null); //ps 03/04/2016
        
        Apttus_Proposal__Proposal_Line_Item__c lineItem2 = createProposalLineItemDevices(3, proposal.Id, dev2.Id, processTech.Id);
        Apttus_Proposal__Proposal_Line_Item__c lineItem3 = createProposalLineItemDevices(3, proposal.Id, ms1.Id, processTech.Id);
        Apttus_Proposal__Proposal_Line_Item__c lineItem4 = createProposalLineItemDevices(3, proposal.Id, devSRAM.Id, processTech.Id);//ps 03/04/2016
        lstLineItems.add(lineItem2);
        lstLineItems.add(lineItem3);    
        lstLineItems.add(lineItem4);     
        
        insert lstLineItems;                
        
        //Exact
        Process__c pid1 = createProcess('Test PID 1', 'BB,CC,DD,EE', 'TESTPID000001', processTech.PT_Number__c);
        lstPIDs.add(pid1);
        
        //Duplicate Exact
        Process__c pid1dup = createProcess('Test PID 1 Dup', 'BB,CC,DD,EE', 'TESTPID000001DUP', processTech.PT_Number__c);
        lstPIDs.add(pid1dup);
        
        //Compatible
        Process__c pidCom1 = createProcess('Test PID COM 1', '11,22,33,44,55,66', 'TESTPIDCOM000001', processTech4Com.PT_Number__c);
        lstPIDs.add(pidCom1);
        
        //Compatible
        Process__c pidCom2 = createProcess('Test PID COM 2', 'AA,BB,CC,DD,EE', 'TESTPIDCOM000002', processTech4Com.PT_Number__c);
        lstPIDs.add(pidCom2);                
        
        //Greater
        Process__c pid2 = createProcess('Test PID 2', 'AA,BB,CC,DD,EE', 'TESTPID000002', processTech.PT_Number__c);
        lstPIDs.add(pid2);
        
        //Greater
        Process__c pid2x = createProcess('Test PID 2x', 'AA,BB,CC,DD,EE,FF', 'TESTPID000002x', processTech.PT_Number__c);
        lstPIDs.add(pid2x);
        
        //FEOL
        Process__c pid3 = createProcess('Test PID 3', 'BB,XX,CC', 'TESTPID000003', processTech.PT_Number__c);
        lstPIDs.add(pid3);
        
        //Extra FEOL
        Process__c pid3x = createProcess('Test PID 3x', 'AA,CC,BB', 'TESTPID000003X', processTech.PT_Number__c);
        lstPIDs.add(pid3x);
        
        //BEOL
        Process__c pid4 = createProcess('Test PID 4', 'EE,MM,DD', 'TESTPID000004', processTech.PT_Number__c);
        lstPIDs.add(pid4);
        
        //Extra BEOL
        Process__c pid4x = createProcess('Test PID 4x', 'DD,FF,EE', 'TESTPID000004X', processTech.PT_Number__c);
        lstPIDs.add(pid4x);
        
        insert lstPIDs;
        
    
        //Update the proposal
        //proposal.Mask_Set__c = 'AA BB CC DD EE FF';        
        //changed reference of Mask_Set__c to Mask_Set_Long__c for the Case#00051463
        //proposal.Mask_Set_Long__c = 'AA BB CC DD EE FF';
        
        //Cause the trigger to excecute
        
        //update proposal;
        Test.stopTest();
    
        PageReference pageRef = Page.PIDMatches;
    
        Test.setCurrentPage(pageRef);
        
        ApexPages.CurrentPage().getParameters().put('Id', proposal.id);
        
        ApexPages.StandardController sc = new ApexPages.standardController(proposal);                
        
        PIDMatchesController pidController = new PIDMatchesController(sc);
        
        
        //Run as portal user: to assign customer specific pricelist
        //User ExtUser = [SELECT id,name FROM user WHERE contact.account.name = 'GLOBALFOUNDRIES' AND ISACTIVE = TRUE AND USERTYPE IN ('CustomerSuccess','PowerCustomerSuccess') LIMIT 1] ;
        
        //system.debug('ExtUser ==> '+ExtUser);
        /*System.RunAs(u) {
            //Cause the trigger to excecute
            Apttus_Proposal__Proposal__c proposalExt = createProposal(acc.Id, Null, Null, Null, Null);
            update proposalExt;
        }*/
        
    }        
    static testMethod void testProposalUpdateTriggerFromDeviceWithMaskSet1(){     
        //Setup the Proposal test record types and cause the insert trigger to excecute
        checkRecursive.runOnceAgain = false;
        checkRecursive.run = false;
        //BPMConfigurationPlusIntegration.hasRun = true;
                
        Account acc = createAccount();
        //User u = createUser(acc.Id);
        
        Opportunity opp = createOpp(acc.Id);        
        
        Opportunity_Program__c oppProg = createOppProg(acc.Id,opp.Id);            
               
        Device__c dev = DeviceUtilTest.createCMPWDevice(acc.Id,oppProg.Id);
        Insert dev;
        //createDevice(acc.Id, opp.Id, oppProg.Id);                       
               
        Test.startTest();
        //Apttus_Proposal__Proposal__c proposal = createProposal(acc.Id, opp.Id, dev.Id, Null, Null);
        Apttus_Proposal__Proposal__c proposal = 
                    new Apttus_Proposal__Proposal__c(Apttus_Proposal__Description__c = 'Test Proposal Description ...',
                                                     Device__c = dev.Id,                                                     
                                                     Mask_Set__c = 'AA BB CC DD EE FF',
                                                     Mask_Set_Long__c = 'AA BB CC DD EE FF',
                                                     Apttus_Proposal__Opportunity__c = opp.Id,
                                                     Apttus_Proposal__Account__c = acc.Id);
        
        
        
        insert proposal;
        
        proposal.APTPS_Primary__c = true;
        //update proposal;
        
        
        List<Apttus_Proposal__Proposal_Line_Item__c> lstLineItems = 
                        new List<Apttus_Proposal__Proposal_Line_Item__c>();
        
        List<Process__c> lstPIDs = new List<Process__c>();
        List<Product2> prodList = new List<Product2>();
                
        Product2 processTech4Com = createProduct('Test Process Technology', 'PROCESSTECHCOM0001', 'CC,DD,EE', 'PROCESSTECHCOM0002');        
        prodList.add(processTech4Com);
        Product2 processTech = createProduct('Test Process Technology', 'PROCESSTECH0001', null, 'PROCESSTECHCOM0003');        
        prodList.add(processTech);
        insert prodList;
        Apttus_Proposal__Proposal_Line_Item__c lineItem1 = createProposalLineItem(1, proposal.Id, processTech4Com.Id);
        lstLineItems.add(lineItem1);
        
        Product2 ms1 = createOptionProduct('Test Mask 1', 'Mask Layers', 'TESTMASK0001', 'CC', Null);
        //Apttus_Proposal__Proposal_Line_Item__c lineItem2 = createProposalLineItem(2, proposal.Id, null);
        Product2 dev2 = createOptionProduct('Test Device 1', 'Devices', 'TESTDEV0001', 'CD', Null);
        Product2 devSRAM = createOptionProduct('Test SRAM Device', 'Devices', 'TESTSRAM0001', 'CD', Null); //ps 03/04/2016
        Apttus_Proposal__Proposal_Line_Item__c lineItem2 = createProposalLineItemDevices(3, proposal.Id, dev2.Id, processTech.Id);
        Apttus_Proposal__Proposal_Line_Item__c lineItem3 = createProposalLineItemDevices(3, proposal.Id, ms1.Id, processTech.Id);
        Apttus_Proposal__Proposal_Line_Item__c lineItem4 = createProposalLineItemDevices(3, proposal.Id, devSRAM.Id, processTech.Id);//ps 03/04/2016
        lstLineItems.add(lineItem2);
        lstLineItems.add(lineItem3);    
        lstLineItems.add(lineItem4);     
        
        insert lstLineItems;                
        
        //Exact
        Process__c pid1 = createProcess('Test PID 1', 'BB,CC,DD,EE', 'TESTPID000001', processTech.PT_Number__c);
        lstPIDs.add(pid1);
        
        //Duplicate Exact
        Process__c pid1dup = createProcess('Test PID 1 Dup', 'BB,CC,DD,EE', 'TESTPID000001DUP', processTech.PT_Number__c);
        lstPIDs.add(pid1dup);
        
        //Compatible
        Process__c pidCom1 = createProcess('Test PID COM 1', '11,22,33,44,55,66', 'TESTPIDCOM000001', processTech4Com.PT_Number__c);
        lstPIDs.add(pidCom1);
        
        //Compatible
        Process__c pidCom2 = createProcess('Test PID COM 2', 'AA,BB,CC,DD,EE', 'TESTPIDCOM000002', processTech4Com.PT_Number__c);
        lstPIDs.add(pidCom2);                
        
        //Greater
        Process__c pid2 = createProcess('Test PID 2', 'AA,BB,CC,DD,EE', 'TESTPID000002', processTech.PT_Number__c);
        lstPIDs.add(pid2);
        
        //Greater
        Process__c pid2x = createProcess('Test PID 2x', 'AA,BB,CC,DD,EE,FF', 'TESTPID000002x', processTech.PT_Number__c);
        lstPIDs.add(pid2x);
        
        //FEOL
        Process__c pid3 = createProcess('Test PID 3', 'BB,XX,CC', 'TESTPID000003', processTech.PT_Number__c);
        lstPIDs.add(pid3);
        
        //Extra FEOL
        Process__c pid3x = createProcess('Test PID 3x', 'AA,CC,BB', 'TESTPID000003X', processTech.PT_Number__c);
        lstPIDs.add(pid3x);
        
        //BEOL
        Process__c pid4 = createProcess('Test PID 4', 'EE,MM,DD', 'TESTPID000004', processTech.PT_Number__c);
        lstPIDs.add(pid4);
        
        //Extra BEOL
        Process__c pid4x = createProcess('Test PID 4x', 'DD,FF,EE', 'TESTPID000004X', processTech.PT_Number__c);
        lstPIDs.add(pid4x);
        
        insert lstPIDs;
        
    
        //Update the proposal
        //proposal.Mask_Set__c = 'AA BB CC DD EE FF';        
        //changed reference of Mask_Set__c to Mask_Set_Long__c for the Case#00051463
        //proposal.Mask_Set_Long__c = 'AA BB CC DD EE FF';
        
        //Cause the trigger to excecute
        
        //update proposal;
        Test.stopTest();
    
        PageReference pageRef = Page.PIDMatches;
    
        Test.setCurrentPage(pageRef);
        
        ApexPages.CurrentPage().getParameters().put('Id', proposal.id);
        
        ApexPages.StandardController sc = new ApexPages.standardController(proposal);                
        
        PIDMatchesController pidController = new PIDMatchesController(sc);
        
        
        //Run as portal user: to assign customer specific pricelist
        //User ExtUser = [SELECT id,name FROM user WHERE contact.account.name = 'GLOBALFOUNDRIES' AND ISACTIVE = TRUE AND USERTYPE IN ('CustomerSuccess','PowerCustomerSuccess') LIMIT 1] ;
        
        //system.debug('ExtUser ==> '+ExtUser);
        /*System.RunAs(u) {
            //Cause the trigger to excecute
            Apttus_Proposal__Proposal__c proposalExt = createProposal(acc.Id, Null, Null, Null, Null);
            update proposalExt;
        }*/
        
    }        

    static testMethod void testProposalUpdateTriggerFromTeamroomByConfiguringProcessTech(){     
        //Setup the Proposal test record types and cause the insert trigger to excecute
        Account acc = createAccount();
        
        Opportunity opp = createOpp(acc.Id);
        
        Team_Room__c tmrm = createTeamroom(acc.Id);
        Team_Room_Member__c tmrmmbr = createTeamroomMember(tmrm.Id);
                
        Apttus_Proposal__Proposal__c proposal = createProposal(acc.Id, opp.Id, Null, tmrm.Id, Null);
        
        //Create Proposal Process Tech Line Items
        Product2 processTech = createProduct('Test Process Technology', 'PROCESSTECH0001', Null, Null);
        insert(new List<Product2>{processTech});
        
        Test.startTest();
        insert(new List<Apttus_Proposal__Proposal_Line_Item__c>{createProposalLineItem(2, proposal.Id, processTech.Id)});
        Test.stopTest();
    }
    
    
    static testMethod void testProposalUpdateTriggerFromTeamroomByConfiguringIPs(){     
        //Setup the Proposal test record types and cause the insert trigger to excecute
        Account acc = createAccount();

        
        Opportunity opp = createOpp(acc.Id);

        
        Team_Room__c tmrm = createTeamroom(acc.Id);
        Team_Room_Member__c tmrmmbr = createTeamroomMember(tmrm.Id);
        
        Apttus_Proposal__Proposal__c proposal = createProposal(acc.Id, opp.Id, Null, tmrm.Id, Null);
        
        //Create Proposal Process Tech Line Items
        Product2 ip1 = createOptionProduct('Test IP 1', 'IPs', 'TESTIP0001', 'AA');
        
        insert(new List<Product2>{ip1});
        
        Test.startTest();
        insert(new List<Apttus_Proposal__Proposal_Line_Item__c>{createProposalLineItem(1, proposal.Id, ip1.Id)});
        Test.stopTest();
    }

    static testMethod void testProposalUpdateTriggerFromTeamroomByConfiguringMasks(){     
        //Setup the Proposal test record types and cause the insert trigger to excecute
        Account acc = createAccount();
        
        Opportunity opp = createOpp(acc.Id);
        
        Team_Room__c tmrm = createTeamroom(acc.Id);
        Team_Room_Member__c tmrmmbr = createTeamroomMember(tmrm.Id);
        
        Apttus_Proposal__Proposal__c proposal = createProposal(acc.Id, opp.Id, Null, tmrm.Id, Null);
        
        //Create Proposal Process Tech Line Items
        Product2 ms1 = createOptionProduct('Test Mask 1', 'Mask Layers', 'TESTMASK0001', 'AA');
        
        insert(new List<Product2>{ms1});
        
        Test.startTest();
        insert(new List<Apttus_Proposal__Proposal_Line_Item__c>{createProposalLineItem(1, proposal.Id, ms1.Id)});
        Test.stopTest();
    }

    static testMethod void testXMLValidator(){
        //Setup the Proposal test record types and cause the insert trigger to excecute
        User admin = DeviceChecklistTestDataUtils.createUserWithDCAdmin('System Administrator');
        System.runAs(admin){
            IntegrationUsers__c skipUser = new IntegrationUsers__c(SetupOwnerId = admin.Id, Is_Integration_User__c= true, Skip_Trigger__c = true, Skip_Validation_Rule__c = true);
            insert skipUser;
      Account acc = createAccount();
      
      Opportunity opp = createOpp(acc.Id);
      
      Team_Room__c tmrm = createTeamroom(acc.Id);
      Team_Room_Member__c tmrmmbr = createTeamroomMember(tmrm.Id);      
      Opportunity_Program__c oppProg = createOppProg(acc.Id,opp.Id);
      Device__c dev = createDevice(acc.Id, opp.Id, oppProg.Id);
      Test.startTest();
      Apttus_Proposal__Proposal__c proposal = createProposal(acc.Id, opp.Id, dev.Id, tmrm.Id, Null);        
      IP_Declaration_Form__c ipDecForm = CPQProposalTest.createIpDecForm(dev.Id);
      
      //Update the MasksSets, Devices and IPs
      proposal.Devices__c = 'D1 D2 D3';
      proposal.Device_Description__c = 'D1=>D2';
      proposal.Device_List__c ='D1<:>D2';
      proposal.Device_List_for_Email__c = 'D1';
      //proposal.Mask_Set__c = 'M1 M2 M3';
      //changed reference of Mask_Set__c to Mask_Set_Long__c for the Case#00051463
      proposal.Mask_Set_Long__c = 'M1 M2 M3';
      proposal.IPs__c = 'I1<:>I2<:>I3';
      proposal.APTPS_Primary__c = TRUE; 
      
      
      update proposal;
      Test.stopTest();        
      PageReference pageRef = Page.ValidatorXMLLauncher;
      
      Test.setCurrentPage(pageRef);
      
      ApexPages.CurrentPage().getParameters().put('Id', proposal.Id);
      
      ValidatorXMLLauncherController xmlController = new ValidatorXMLLauncherController();
      xmlController.sendValidatorXML();
        }
    }   
    
    static testMethod void testProposalApprovalCheck(){
        //Setup the Proposal test record types and cause the insert trigger to excecute
        Id accId = createAccountNew();        
        Id oppId = createOpportunityNew(accId);            
        Id oppProgId = createOpportunityProgramNew(accId,oppId);       
        Device__c dev = DeviceUtilTest.createCMPWDevice(accId,oppProgId);
        Insert dev;
        
        //createDeviceNew(oppProgId);
        
        Test.startTest(); 
        dev.Fab__c = 'FAB 9';
        update dev;
            Apttus_Proposal__Proposal__c testConfig = createProposalNew(accId,oppId,dev.Id);                      
            
            //Internal user approver
            testConfig.approval_check__c = false;
            update testConfig;
            
            Approval.ProcessSubmitRequest req1 = new Approval.ProcessSubmitRequest();
            req1.setComments('Submitting request for approval.');
            req1.setObjectId(testConfig.id);        
            Approval.ProcessResult result = Approval.process(req1); 
                          
        Test.stopTest();
        
    }
    
    static testMethod void testProposalApprovalComments(){
        //Setup the Proposal test record types and cause the insert trigger to excecute
        Id accId = createAccountNew();        
        Id oppId = createOpportunityNew(accId);            
        Id oppProgId = createOpportunityProgramNew(accId,oppId);       
        Device__c dev = DeviceUtilTest.createCMPWDevice(accId,oppProgId);
        Insert dev;
        
        //createDeviceNew(oppProgId);
        
        Test.startTest(); 
            dev.Fab__c = 'FAB 9';
            update dev;
            Apttus_Proposal__Proposal__c testConfig = createProposalNew(accId,oppId,dev.Id);                      
            
            //Internal user approver
            testConfig.approval_check__c = false;
            update testConfig;
            
            Approval.ProcessSubmitRequest req1 = new Approval.ProcessSubmitRequest();
            req1.setComments('Submitting request for approval.');
            req1.setObjectId(testConfig.id);        
            Approval.ProcessResult result = Approval.process(req1);         
            
            List<Id> newWorkItemIds = result.getNewWorkitemIds();
            Approval.ProcessWorkitemRequest req2 = new Approval.ProcessWorkitemRequest();
            req2.setComments('Rejecting request.');
            req2.setAction('Reject');
            req2.setNextApproverIds(new Id[] {UserInfo.getUserId()});
            req2.setWorkitemId(newWorkItemIds.get(0));   
            //Approval.ProcessResult result1 = Approval.process(req2);                 
                       
            Test.stopTest();
        
    }
    
    static testMethod void testProposalApprovalCommentsBlank(){
        //Setup the Proposal test record types and cause the insert trigger to excecute
        Id accId = createAccountNew();        
        Id oppId = createOpportunityNew(accId);            
        Id oppProgId = createOpportunityProgramNew(accId,oppId);       
        Device__c dev = DeviceUtilTest.createCMPWDevice(accId,oppProgId);
        Insert dev;
        
        //createDeviceNew(oppProgId);
        
        Test.startTest(); 
            dev.Fab__c = 'FAB 9';
            update dev;
            Apttus_Proposal__Proposal__c testConfig = createProposalNew(accId,oppId,dev.Id);                      
            
            //Internal user approver
            testConfig.approval_check__c = false;
            update testConfig;
            
            Approval.ProcessSubmitRequest req1 = new Approval.ProcessSubmitRequest();
            req1.setComments('Submitting request for approval.');
            req1.setObjectId(testConfig.id);        
            Approval.ProcessResult result = Approval.process(req1);         
            
            try{
                List<Id> newWorkItemIds = result.getNewWorkitemIds();
                Approval.ProcessWorkitemRequest req2 = new Approval.ProcessWorkitemRequest();
                req2.setComments('');
                req2.setAction('Reject');
                req2.setNextApproverIds(new Id[] {UserInfo.getUserId()});
                req2.setWorkitemId(newWorkItemIds.get(0));   
                Approval.ProcessResult result1 = Approval.process(req2);                 
            }
            catch(Exception e){
                system.debug(e.getmessage());
                System.assertEquals(e.getmessage().contains('Please provide a rejection reason!'),true);
            }
            Test.stopTest();
        
    }
    
    // This method tests CPQApprovalHandler
    static testMethod void testCPQApprovalHandler1(){     
        //Setup the Proposal test record types and cause the insert trigger to excecute
        Id accId = createAccountNew();       
        Id oppId = createOpportunityNew(accId);
        Id oppProgId = createOpportunityProgramNew(accId,oppId);        
        Device__c dev = DeviceUtilTest.createCMPWDevice(accId,oppProgId);
        Insert dev;
    //createDeviceNew(oppProgId);
        Test.startTest();
      Apttus_Proposal__Proposal__c Configuration = createProposal(accId, oppId, dev.Id, null, Null);                                         
            Configuration.Approval_Check_1__c = true;
            Configuration.Apttus_Proposal__Approval_Stage__c = 'Submitted Phase';
            Update Configuration; 
        Test.stopTest();
    }
    
    // This method tests CPQApprovalHandler
    static testMethod void testCPQApprovalHandler2(){     
        //Setup the Proposal test record types and cause the insert trigger to excecute
        //User u = createInternalUser();
        checkRecursive.runOnceAgain = false;
        checkRecursive.run = false;
        //BPMConfigurationPlusIntegration.hasRun = true;
        User admin = DeviceChecklistTestDataUtils.createUserWithDCAdmin('System Administrator');
        Id accId = null;
        Id oppId = null;
        Id oppProgId = null;
        //User u = createInternalUser(accId);
        Device__c dev = null;
        Apttus_Proposal__Proposal__c Configuration = null;
        
        
        System.runAs(admin){
            IntegrationUsers__c skipUser = new IntegrationUsers__c(SetupOwnerId = admin.Id, Is_Integration_User__c= true, Skip_Trigger__c = true, Skip_Validation_Rule__c = true);
            insert skipUser;
                       
            accId = createAccountNew();
            oppId = createOpportunityNew(accId);
            oppProgId = createOpportunityProgramNew(accId,oppId);        
                     
        }   
        
        dev = DeviceUtilTest.createCMPWDevice(accId,oppProgId);
        Insert dev; 
        /*User u = createInternalUser(accId);
        User runUser = [select id from User where id = :UserInfo.getUserId()];*/
               
        /*System.runAs(runUser){
            List<Group> grpList = createGrp('PI/YE Users Fab3');    
            createGrpMem(grpList,u);            
        }*/       
        
        Test.startTest(); 
            Configuration = createProposal(accId, oppId, dev.Id, null, Null);
            
            /*Apttus_Proposal__Proposal__Share propShare = new Apttus_Proposal__Proposal__Share();
            propShare.ParentId = Configuration.Id;
            propShare.UserOrGroupId = u.Id;
            propShare.AccessLevel = 'edit';
            insert propShare;*/

            //System.runAs(u){            
                Configuration.Apttus_Proposal__Approval_Stage__c = 'Package Accepted Phase';
                Configuration.Approval_Check__c = true ; 
                Update Configuration; 
            //}
        
        Test.stopTest();
        
    } 
    
    // This method tests CPQApprovalHandler
    static testMethod void testCPQApprovalHandler3(){     
        //Setup the Proposal test record types and cause the insert trigger to excecute
        //User u = createInternalUser();
        checkRecursive.runOnceAgain = false;
        checkRecursive.run = false;
        //BPMConfigurationPlusIntegration.hasRun = true;
        
        Id accId = createAccountNew();
        User u = createInternalUser(accId);
        
        createAccountTeamProxy(accId,u);
        Test.startTest();        
        Id oppId = createOpportunityNew(accId);
        Id oppProgId = createOpportunityProgramNew(accId,oppId);        
        //
       
        Device__c dev = DeviceUtilTest.createCMPWDevice(accId,oppProgId);
        Insert dev;
        //createDeviceNew(oppProgId);
        
        User runUser = [select id from User where id = :UserInfo.getUserId()];
                      
        System.runAs(runUser){
            List<Group> grpList = createGrp('Packaging Users Fab3');
            createGrpMem(grpList,u);
            grpList = createGrp('PI/YE Users Fab3');                   
            createGrpMem(grpList,u);            
        }       
        
        Apttus_Proposal__Proposal__c Configuration = createProposal(accId, oppId, dev.Id, null, Null);
        
        Apttus_Proposal__Proposal__Share propShare = new Apttus_Proposal__Proposal__Share();
        propShare.ParentId = Configuration.Id;
        propShare.UserOrGroupId = u.Id;
        propShare.AccessLevel = 'edit';
        insert propShare;        
        
        System.runAs(u){                      
            Configuration.Apttus_Proposal__Approval_Stage__c = 'Process Accepted Phase';
            Configuration.Approval_Check__c = true ; 
            //Update Configuration; 
        }                
        Test.stopTest();
        
        
    }
    
    static User createInternalUser(Id acctId){
        // retrieve portal profile
        Profile profileObj = [Select Name,Id from Profile where Name = 'GF PIYE Platform'];
        
        Environment_Variable__c env = [select id,name,value__c from Environment_Variable__c where name='HCM Emp AccountId'];
        env.value__c=acctId;
        update env;
        // Create HCM record
        HCM_Employee__c hcm = new HCM_Employee__c(First_Name__c='Test',Last_Name__c='Name',Employee_ID__c='Test1124',Login_ID__c='Test1124',Email_Address__c='test1124@test.com');
        insert hcm;
        
        
        /*User userObj = [select id, ProfileId from User where email = 'test@test.com' limit 1];
        userObj.ProfileId  = profileObj.Id;
        update userObj;*/
        // Create User
        String uEmail = 'NewUser'+DateTime.now().getTime()+'@testorg.com';
        User userObj = new User(Alias = 'Test', Email= uEmail , EmailEncodingKey='UTF-8', LastName='Name',
            LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = profileObj.Id, TimeZoneSidKey='America/Los_Angeles',
            UserName=uEmail , IsActive = true,FederationIdentifier='Test1124');   
        insert userObj;

        return userObj;
    }
    
    static List<Group> createGrp(String grpName){
        List<Group> grpList = new List<Group>();
        Group piyeGrp = new Group(Type = 'Regular',Name = grpName);
        Group piyeQue = new Group(Type = 'Queue',Name = grpName);
        insert grpList;
        return grpList;
    }
    
    static void createGrpMem(List<Group> grpList, User u){
        List<GroupMember> gmList = new List<GroupMember>();
        for(Group g : grpList){
            GroupMember member = new GroupMember();
            member.UserOrGroupId = u.Id;
            member.GroupId = g.id;
            gmList.add(member);
        }          
        insert gmList;
    }
    
           
    static ID createAccountNew() {
        // Create Account
        Map<String,Object> fieldValueMap = new Map<String,Object>();
        fieldValueMap.put('Name', 'MYTEST ACCOUNT'+system.now()+math.random()); 
        fieldValueMap.put('stage__c', 'Unqualified');                          
        fieldValueMap.put('sub_type__c', 'Direct');
        fieldValueMap.put('site_department__c', 'IT');          
        fieldValueMap.put('transaction_type__c', 'Transactional');                          
        fieldValueMap.put('region__c', 'APJ');        
        fieldValueMap.put('Corporate_Address_1__c', 'Test Address 1');          
        fieldValueMap.put('Corporate_City__c', 'Test City');                
        fieldValueMap.put('Corporate_Country__c', 'Singapore'); 
        fieldValueMap.put('Bill_To_Address_1__c', 'Test Address 1');          
        fieldValueMap.put('Bill_To_City__c', 'Test City');            
        fieldValueMap.put('Bill_To_Country__c', 'Singapore');              
        fieldValueMap.put('Fab_9_10__c','No');
        fieldValueMap.put('short_name__c','TAC');

        return AccountDataFactory.createAccount(fieldValueMap).id;  
        
    }
    
    static void createAccountTeamProxy(Id acctId, User u){
        Account_Team_Proxy__c atp = new Account_Team_Proxy__c(User__c = u.id,
                                                        Account__c=acctId,
                                                        Account_Access__c='Read/Write',
                                                        Opportunity_Access__c='Read/Write',
                                                        Team_Role__c='Primary Field Application Engineer',
                                                        Account_Role_ID__c='test',
                                                        fab_assignment__c = 'FAB 3');
        insert atp;
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
            name = 'Test Opportunity Program',
            account__c = testAcctID,
            opportunity__c = testOpptyID
        );
        
        Insert testOpptyProgram;        
        return testOpptyProgram.ID;
    }
    
    static ID createDeviceNew( ID testOpptyProgramID) {
        // Create Device
        Device__c device = new Device__c(        
            name = 'TESTDEVICEZAIH12345677.00',
            opportunity_Program__c = testOpptyProgramID,
            fab__c = 'FAB 3',
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
            device_mask_set_title__c = 'MPW1233',
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
    }
    
    //Static method to create proposal test record
    static Apttus_Proposal__Proposal__c createProposalNew(ID accID, ID oppID, ID devID){    
        //Setup the test records required to create the Proposal test record
        
        RecordType recType = [Select Id
                                From RecordType 
                               Where Name='Draft' And
                                     SobjectType = 'Apttus_Proposal__Proposal__c'];        
            
        Product2 processTech = createProduct('Test Process Technology', 'PROCESSTECH0001', null, 'PROCESSTECHCOM0003');        
        insert processTech;
    
        Process__c pid1 = createProcess('Test PID 1', 'BB,CC,DD,EE', 'TESTPID000001', processTech.PT_Number__c);
        insert pid1;
        
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
                                                     apttus_proposal__approval_stage__c = 'Submitted Phase',
                                                     process_technology__c = 'PT002562',
                                                     Assigned_Process_ID__c = pid1.Id,
                                                     approval_check__c = true);
        
        insert proposal;
        return proposal;
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
    
    static User createUser(Id acctId){
        
         // Create Contact
        Contact conobj = new Contact(FirstName='Mr', LastName='Testcon1', AccountId=acctId, Email='con1@gf.com', Department__c='Design;Procurement');
        insert conobj;
        
        // retrieve portal profile
        Profile profileObj = [Select Name,Id from Profile where Name = 'Overage Customer Portal Profile'];
    
        // Create User
        User userObj = new User(Alias = 'Shyam', Email='shyam@test.com', EmailEncodingKey='UTF-8', LastName='Paul',
            LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = profileObj.Id, TimeZoneSidKey='America/Los_Angeles',
            UserName='shyam@test.com', Portal_Login__c = 'xyz', contactId = conobj.Id, IsActive = true);   
        insert userObj;

        return userObj;
    }

    //Static method to create Attribute test record
    static Apttus__APTS_Agreement__c createAgreement(Id accId){
        List<GFV_NDA_Account_Sync_Settings__c> ndaSyncSettings = new List<GFV_NDA_Account_Sync_Settings__c>{
            new GFV_NDA_Account_Sync_Settings__c(Name='errorEmailsTo', value__c = 'sreedhar.karukonda@globalfoundries.com\nwinhwang.lim@globalfoundries.com'),
              new GFV_NDA_Account_Sync_Settings__c(Name='ndaSyncApplicableTo', value__c = 'In Effect->Activated\nIn Effect->Being Amended'),
              new GFV_NDA_Account_Sync_Settings__c(Name='errorEmailSubject', value__c = '[IMPORTANT] NDA sync to accounts failed.'),
              new GFV_NDA_Account_Sync_Settings__c(Name='syncApplicableRecordTypes', value__c = 'DS_2_Party_NDA\nDS_Multi_Party_NDA\nDS_Other_Party_NDA\nLegacy_NDA\nMulti_Party_NDA\nOther_Party_NDA\nGLOBALFOUNDRIES_NDA')
        };
        insert ndaSyncSettings;
        
        //Create a proposal line item
        Apttus__APTS_Agreement__c agrmnt = new Apttus__APTS_Agreement__c(Apttus__Account__c = accId,
                                                                         Name = 'Test Agreement',
                                                                         Geometries__c = '0.20UM;0.153UM',
                                                                         Apttus__Status_Category__c = 'Request' ,
                                                                         Apttus__Contract_End_Date__c = Date.Today().addDays(10),
                                                                         Apttus__Requestor__c = UserInfo.getUserId());
        
        insert agrmnt;
        return agrmnt;
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

    //Static method to create Opportunity Program test record
    static Opportunity_Program__c createOppProg(Id acctId, Id oppId){
        Opportunity_Program__c opProg = 
                    new Opportunity_Program__c(Name = 'Test OppProg',
                                               Account__c = acctId,
                                               Opportunity__c = oppId);
        insert opProg;
        return opProg;
    }
    
    //Static method to create Device test record
    static Device__c createDevice(Id accId, Id oppId, Id oppProgId){
        Device__c dev = new Device__c(Name = 'TESTDEVICE1313',
                                      Stage__c = 'Design In',
                                      Status__c = 'Active',
                                      Account__c = accId,
                                      Opportunity2__c = oppId,
                                      Opportunity_Program__c = oppProgId,
                                      Market_Segment__c = 'Automotive',
                                      Semiconductor_Device__c = 'Analog Regulator',
                                      End_Application__c = 'Body',
                                      Device_Sourcing__c = '3rd Source',
                                      Tapeout_Type__c = 'Customer MPW',
                                      Siebel_Device_ID__c = '0987654321',
                                      IP_Gap__c = false,
                                      Requested_from_Configuration__c = true, 
                                      Actual_Tapeout_Date__c = date.newInstance(2013,5,20),
                                      Forecasted_Lot_Start_Date__c = date.newInstance(2013,5,20),
                                      Original_Forecasted_Tapeout_Date__c = date.newInstance(2013,5,20),
                                      Current_Forecast_Tapeout_Date__c = date.newInstance(2013,3,4),
                                      Confidence_Level_Tapeout__c = '100',
                                      IP_Declaration_User_Ids__c = userinfo.getuserid() ,
                                      Fab__c = 'Fab 3');
        insert dev;
        return dev; 
    }
    
    //Static method to create Teamroom test record
    static Team_Room__c createTeamroom(Id accId){
        Team_Room__c tmrm = new Team_Room__c(Name = 'TESTTEAMROOM1313',
                                             Team_Room_Description__c= 'Team room Description ... ',Primary_Account__c=accId); //TBD
        insert tmrm;
        return tmrm; 
    }
    
    //Static method to create Teamroom test record
    static Team_Room_Member__c createTeamroomMember(Id tmrmId){
        Team_Room_Member__c tmrmmbr = 
                    new Team_Room_Member__c(User__c = UserInfo.getUserId(),
                                            Team_Room_Role__c = 'Moderator',
                                            Team_Room__c = tmrmId);
        insert tmrmmbr;
        return tmrmmbr; 
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
                                                     /*Mask_Set__c = szMaskSet, changed reference of Mask_Set__c to Mask_Set_Long__c for the Case#00051463*/
                                                     Mask_Set_Long__c = szMaskSet,
                                                     Apttus_Proposal__Opportunity__c = oppId,
                                                     Apttus_Proposal__Account__c = accId,
                                                     RecordTypeId = recType.Id);
        
        insert proposal;
        return proposal;
    }
    
    //Static method to create proposal test record
    static Apttus_Proposal__Proposal__c createProposal1(Id accId, Id oppId, Id devId, Id tmrmId, String szMaskSet){
        //Setup the test records required to create the Proposal test record
        RecordType recType = [Select Id
                                From RecordType 
                               Where Name='Draft' And
                                     SobjectType = 'Apttus_Proposal__Proposal__c'];
        
        //Create a proposal from Device
        Apttus_Proposal__Proposal__c proposal = 
                    new Apttus_Proposal__Proposal__c(Apttus_Proposal__Description__c = 'Test Proposal Description ...',
                                                     Device__c = devId,                                                     
                                                     /*Mask_Set__c = szMaskSet, changed reference of Mask_Set__c to Mask_Set_Long__c for the Case#00051463*/
                                                     Mask_Set_Long__c = szMaskSet,
                                                     Apttus_Proposal__Opportunity__c = oppId,
                                                     Apttus_Proposal__Account__c = accId,
                                                     Catalog_Type__c = 'Multi Source',
                                                     RecordTypeId = recType.Id);
        
        insert proposal;
        return proposal;
    }
    
    //Static method to create proposal test record
    static Apttus_Proposal__Proposal__c createProposal2(ID accID, ID oppID, ID devID){    
        //Setup the test records required to create the Proposal test record
        RecordType recType = [Select Id
                                From RecordType 
                               Where Name='Draft' And
                                     SobjectType = 'Apttus_Proposal__Proposal__c'];        
            
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
                                                     apttus_proposal__approval_stage__c = 'Submitted Phase',
                                                     process_technology__c = 'PT002562',
                                                     approval_check__c = true);
        
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
        
        //insert prod;
        return prod;
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
                                     IsActive = True,
                                     Description = 'nfet,pfet');
        
        //insert prod;
        return prod;
    }
    
    //Static method to create Attribute test record
    /*static Apttus_QPConfig__ProposalProductAttributeValue__c createAttribute(){
        //Setup the test records required to create the Proposal test record
        //Account acc = createAccount();
        Account acc = [SELECT Id,
                              Name
                         FROM Account 
                        WHERE Name = 'GLOBALFOUNDRIES'];
        
        //Opportunity opp = createOpp(acc.Id);
        Opportunity opp = [SELECT Id, 
                                  Account.Id 
                             FROM Opportunity 
                            WHERE Name = 'GLOBALFOUNDRIES DUMMY OPPORTUNITY TEST'];
                            
        Team_Room__c tmrm = createTeamroom(acc.Id);
        Apttus_Proposal__Proposal__c proposal = createProposal(acc.Id, opp.Id, Null, tmrm.Id, Null);
        Product2 prod = createProduct('Test Process Technology', 'PROCESSTECH0001', Null, Null);
        
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
    }*/
    
    //Static method to create proposal line item test record
    static Apttus_Proposal__Proposal_Line_Item__c createProposalLineItem(Integer iNumber, Id PropId, Id optId){
        //Setup the test records required to create the Proposal test record
        Product2 prod = createProduct('Test Process Technology', 'PROCESSTECH0001', Null, 'PROCESSTECHCOM0001');
        insert prod;
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
    
    //Static method to create proposal line item test record for device products
    static Apttus_Proposal__Proposal_Line_Item__c createProposalLineItemDevices(Integer iNumber, Id PropId, Id optId, ID devProdID){
                                                                 
        //Create a proposal line item
        Apttus_Proposal__Proposal_Line_Item__c proposalLineItem = 
              new Apttus_Proposal__Proposal_Line_Item__c(Apttus_QPConfig__LineNumber__c = iNumber,
                                                         Apttus_QPConfig__ItemSequence__c = iNumber,
                                                         Apttus_Proposal__Product__c = devProdID,
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
                                     Description = 'nfet,pfet');
        
        insert prod;
        return prod;
    }
    
    static IP_Declaration_Form__c createIpDecForm(Id testDeviceId) {
        // Create IP_Declaration_Form
        IP_Declaration_Form__c ipDecForm = new IP_Declaration_Form__c();
        ipDecForm.Device__c = testDeviceId;
        IpDecForm.Status__c = 'Undeclared';
        IpDecForm.Is_Config_Used__c = TRUE;
        
        Insert ipDecForm;
        
        return ipDecForm;
    }
    static testMethod void CloneConfigurator(){
                 Account acc = createAccount();
                 Opportunity opp = createOpp(acc.Id);
        
        //Team_Room__c tmrm = createTeamroom(acc.Id);
        //Team_Room_Member__c tmrmmbr = createTeamroomMember(tmrm.Id);      
        Opportunity_Program__c oppProg = createOppProg(acc.Id,opp.Id);
        Device__c dev = createDevice(acc.Id, opp.Id, oppProg.Id);
        Test.startTest();
        Configurator_Plus_Question__c cpq=new Configurator_Plus_Question__c();
        cpq.Question_Name__c='test';
        insert cpq;
        
        Apttus_Proposal__Proposal__c proposal = createProposal(acc.Id, opp.Id, dev.Id, Null, Null);  
        
        Configurator_Plus_Response__c response=new Configurator_Plus_Response__c();
        response.Configurator_Plus__c=proposal.Id;
        response.Response_Type__c='Packaging Options';
        response.Name__c='Test';
        response.Additional_Response__c='test';
        response.Configurator_Plus_Question__c=cpq.id;
        insert response;

        RecordType recType = [Select Id
                                From RecordType 
                               Where Name='MultiSource Proposal Device RO' And
                                     SobjectType = 'Apttus_Proposal__Proposal__c'];
                                     
         RecordType recType1 = [Select Id
                                From RecordType 
                               Where Name='MultiSource Proposal Teamroom RO' And
                                     SobjectType = 'Apttus_Proposal__Proposal__c'];
        RecordType recType2 = [Select Id
                                From RecordType 
                               Where Name='Proposal from Device Read Only' And
                                     SobjectType = 'Apttus_Proposal__Proposal__c'];  
        RecordType recType3 = [Select Id
                                From RecordType 
                               Where Name='Proposal from Teamroom Read Only' And
                                     SobjectType = 'Apttus_Proposal__Proposal__c'];
                                     
        
        //Create a proposal from Device
        Apttus_Proposal__Proposal__c proposal1 = 
                    new Apttus_Proposal__Proposal__c(Apttus_Proposal__Description__c = 'Test Proposal Description ...',
                                                     Device__c = dev.Id,                                                     
                                                     /*Mask_Set__c = szMaskSet, changed reference of Mask_Set__c to Mask_Set_Long__c for the Case#00051463*/
                                                     Mask_Set_Long__c = null,
                                                     Apttus_Proposal__Opportunity__c = opp.Id,
                                                     Apttus_Proposal__Account__c = acc.Id,
                                                     Configurator_Lookup__c = proposal.ID,
                                                     RecordTypeId = recType.Id);
        
        insert proposal1;


                                     proposal1.RecordTypeId = recType1.Id;
                                     update proposal1;
                                     
                                     proposal1.RecordTypeId = recType2.Id;
                                     update proposal1;
                                     
                                     proposal1.RecordTypeId = recType3.Id;
                                     update proposal1;
                                     
        Test.stopTest();  
        
    }
    
}