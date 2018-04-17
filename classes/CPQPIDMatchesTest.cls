/******************************************************************************************************************************
Class:         CPQPIDMatchesTest
-------------------------------------------------------------------------------------------------------------------------------
Author:        Joydev Mondol (Cognizant - 153480)
Created Date:  5/11/2013
Reason:        Test class for controller classes PIDMatchesController
*******************************************************************************************************************************/
               
@isTest
private class CPQPIDMatchesTest{
    
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
    static testMethod void testPIDMatches(){
        //Setup the Proposal test record for the the page to render
        Account acc = getAccount('MYTEST ACCOUNT1');
        //User xUser = createXUser(acc.Id);
        
        Opportunity opp = createOpportunity(acc.Id);
        
        //PS 02062015: Team_Room__c tmrm = createTeamroom(acc.Id);
        Test.startTest();
        Apttus_Proposal__Proposal__c proposal = createProposal(acc.Id, opp.Id, Null, null);
            
               
        List<Apttus_Proposal__Proposal_Line_Item__c> lstLineItems = 
                        new List<Apttus_Proposal__Proposal_Line_Item__c>();
        
        List<Process__c> lstPIDs = new List<Process__c>();
                
        Product2 processTech4Com = createProduct('Test Process Technology', 'PROCESSTECHCOM0001', Null, 'XXX00321');        
        
        Product2 processTech = createProduct('Test Process Technology', 'PROCESSTECH0001', Null, processTech4Com.PT_Number__c);        
        Apttus_Proposal__Proposal_Line_Item__c lineItem1 = createProposalLineItem(1, proposal.Id, processTech.Id);
        lstLineItems.add(lineItem1);
        
        Product2 ms1 = createOptionProduct('Test Mask 1', 'Mask Layers', 'TESTMASK0001', 'CC', Null);
        Apttus_Proposal__Proposal_Line_Item__c lineItem2 = createProposalLineItem(2, proposal.Id, ms1.Id);
        lstLineItems.add(lineItem2);
        
        
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
        


        Process_Technology__c pt = createProcessTechnology();
        //proposal.Mask_Set__c = 'CC BB DD EE';
        //changed reference of Mask_Set__c to Mask_Set_Long__c for the Case#00051463
        //proposal.Mask_Set_Long__c = 'CC BB DD EE';
        //proposal.Process_Technology_Lookup__c = pt.id;
        //update proposal;



        
        //system.runas(xUser){
        //Test.startTest();
        //update proposal;
        PageReference pageRef = Page.PIDMatches;
    
        Test.setCurrentPage(pageRef);
        
        ApexPages.CurrentPage().getParameters().put('Id', proposal.id);
        ApexPages.CurrentPage().getParameters().put('tab', 'FEOL');

        
        
        ApexPages.StandardController sc = new ApexPages.standardController(proposal);                
        
        PIDMatchesController pidController = new PIDMatchesController(sc);
        

        pidController.MatchFound = true;
        








        


        ApexPages.CurrentPage().getParameters().put('tab', 'BEOL');
        pidController = new PIDMatchesController(sc);
        Test.stopTest();
        //}
    }
    static testMethod void testPIDMatches1(){
        //Setup the Proposal test record for the the page to render
        Account acc = getAccount('MYTEST ACCOUNT1');
        //User xUser = createXUser(acc.Id);
        
        Opportunity opp = createOpportunity(acc.Id);
        
        //PS 02062015: Team_Room__c tmrm = createTeamroom(acc.Id);
        Test.startTest();


		Process_Technology__c pt = createProcessTechnology();
        Apttus_Proposal__Proposal__c proposal = 
                    new Apttus_Proposal__Proposal__c(Apttus_Proposal__Description__c = 'Test Proposal Description ...',
                                                     //Device__c = dev.Id,                                                     
                                                     //Mask_Set__c = 'BB CC DD EE',


                                                     Mask_Set_Long__c = 'CC BB DD EE',
                                                     Apttus_Proposal__Opportunity__c = opp.Id,
                                                     Apttus_Proposal__Account__c = acc.Id,Process_Technology_Lookup__c = pt.id);


            

        insert proposal;
            
               
        List<Apttus_Proposal__Proposal_Line_Item__c> lstLineItems = 
                        new List<Apttus_Proposal__Proposal_Line_Item__c>();
        
        List<Process__c> lstPIDs = new List<Process__c>();
                
        //Product2 processTech4Com = createProduct('Test Process Technology', 'PROCESSTECHCOM0001', Null, 'XXX00321');        

		Product2 processTech4Com = new Product2(Name = 'Test Process Technology',
                                     ProductCode = 'GEO_' + 'PROCESSTECHCOM0001' + '_ADD',
                                     FEOL__c = 'AA BB CC',
                                     BEOL__c = 'DD EE FF',
                                     APTPS_Core_Voltage__c = '1.50',
                                     APTPS_IO_Voltage__c = '1.50',
                                     Geometry__c = '0.028nm',
                                     //Mask_Sets__c = null,
                                     IsActive = True,
                                     //Compatible_PTs__c = szComPTs,
                                     PT_Number__c = 'PROCESSTECHCOM0001',
                                     Product_External_ID__c = 'PROCESSTECHCOM0001' + Math.random());
        
		insert processTech4Com;
        //Product2 processTech = createProduct('Test Process Technology', 'PROCESSTECH0001', Null, processTech4Com.PT_Number__c);        
        Apttus_Proposal__Proposal_Line_Item__c lineItem1 = createProposalLineItem(1, proposal.Id, processTech4Com.Id);
        lstLineItems.add(lineItem1);
        
        Product2 ms1 = createOptionProduct('Test Mask 1', 'Mask Layers', 'TESTMASK0001', 'CC', Null);
        Apttus_Proposal__Proposal_Line_Item__c lineItem2 = createProposalLineItem(2, proposal.Id, ms1.Id);
        lstLineItems.add(lineItem2);
        
        
        insert lstLineItems;
        
        //Exact
        Process__c pid1 = createProcess('Test PID 1', 'Test,Mask,1', 'TESTPID000001', processTech4Com.PT_Number__c);
        lstPIDs.add(pid1);
        
        //Duplicate Exact
        Process__c pid1dup = createProcess('Test PID 1 Dup', 'Test,Mask,1', 'TESTPID000001DUP', processTech4Com.PT_Number__c);
        lstPIDs.add(pid1dup);

		
        Process__c pid4 = createProcess('Test PID 4', 'SR,ST,DK,QI,Test,Mask,1', 'TESTPID000004', processTech4Com.PT_Number__c);
        lstPIDs.add(pid4);
        
        insert lstPIDs;
        system.debug('maskTest==>'+proposal.Mask_Set_Long__c);
        
        PageReference pageRef = Page.PIDMatches;
    
        Test.setCurrentPage(pageRef);
        
        ApexPages.CurrentPage().getParameters().put('Id', proposal.id);
        ApexPages.CurrentPage().getParameters().put('tab', 'Reticle');
        
        ApexPages.StandardController sc = new ApexPages.standardController(proposal);                
        
        PIDMatchesController pidController = new PIDMatchesController(sc); 
        
        
        Test.stopTest();
        //}
    }
    static testMethod void testPIDMatches1A(){
        //Setup the Proposal test record for the the page to render
        Account acc = getAccount('MYTEST ACCOUNT1');
        //User xUser = createXUser(acc.Id);
        
        Opportunity opp = createOpportunity(acc.Id);
        
        //PS 02062015: Team_Room__c tmrm = createTeamroom(acc.Id);
        Test.startTest();
        //Apttus_Proposal__Proposal__c proposal = createProposal(acc.Id, opp.Id, Null, null);
        Process_Technology__c pt = createProcessTechnology();
        Apttus_Proposal__Proposal__c proposal = 
                    new Apttus_Proposal__Proposal__c(Apttus_Proposal__Description__c = 'Test Proposal Description ...',
                                                     //Device__c = dev.Id,                                                     
                                                     //Mask_Set__c = 'BB CC DD EE',
                                                     Mask_Set_Long__c = 'AA,BB,CC,DD,EE',
                                                     Apttus_Proposal__Opportunity__c = opp.Id,
                                                     Apttus_Proposal__Account__c = acc.Id,Process_Technology_Lookup__c = pt.id);
            
        insert proposal;      
        List<Apttus_Proposal__Proposal_Line_Item__c> lstLineItems = 
                        new List<Apttus_Proposal__Proposal_Line_Item__c>();
        
        List<Process__c> lstPIDs = new List<Process__c>();
                
        
        Product2 processTech4Com = new Product2(Name = 'Test Process Technology',
                                     ProductCode = 'GEO_' + 'PROCESSTECHCOM0001' + '_ADD',
                                     FEOL__c = 'AA,BB,CC',
                                     BEOL__c = 'OOOO,IIII,JJJJ',
                                     APTPS_Core_Voltage__c = '1.50',
                                     APTPS_IO_Voltage__c = '1.50',
                                     Geometry__c = '0.028nm',
                                     //Mask_Sets__c = null,
                                     IsActive = True,
                                     //Compatible_PTs__c = szComPTs,
                                     PT_Number__c = 'PROCESSTECHCOM0001',
                                     Product_External_ID__c = 'PROCESSTECHCOM0001' + Math.random());
        
        insert processTech4Com;
                
        Apttus_Proposal__Proposal_Line_Item__c lineItem1 = createProposalLineItem(1, proposal.Id, processTech4Com.Id);
        lstLineItems.add(lineItem1);
        
        Product2 ms1 = createOptionProduct('DD EE FF', 'Mask Layers', 'TESTMASK0001', 'CC', Null);
        Apttus_Proposal__Proposal_Line_Item__c lineItem2 = createProposalLineItem(2, proposal.Id, ms1.Id);
        lstLineItems.add(lineItem2);
        
        
        insert lstLineItems;
        
        
        Process__c pid4 = createProcess('PID 4', 'SR,ST,DK,QI', 'TESTPID000004', processTech4Com.PT_Number__c);
        lstPIDs.add(pid4);
        
        //Extra BEOL
        Process__c pid4x = createProcess('Test PID 4x', 'KIJA,JJAHE,LLOD,JJDHE', 'TESTPID000004X', processTech4Com.PT_Number__c);
        lstPIDs.add(pid4x);
        
        insert lstPIDs;

        
        PageReference pageRef = Page.PIDMatches;
    
        Test.setCurrentPage(pageRef);
        
        ApexPages.CurrentPage().getParameters().put('Id', proposal.id);
        ApexPages.CurrentPage().getParameters().put('tab', 'Reticle');
        
        ApexPages.StandardController sc = new ApexPages.standardController(proposal);                
        
        PIDMatchesController pidController = new PIDMatchesController(sc); 
        
        Test.stopTest();
        //}
    }
    static testMethod void testPIDMatches2(){
        //Setup the Proposal test record for the the page to render
        Account acc = getAccount('MYTEST ACCOUNT1');
        //User xUser = createXUser(acc.Id);
        
        Opportunity opp = createOpportunity(acc.Id);
        
        //Team_Room__c tmrm = createTeamroom(acc.Id);
        Test.startTest();
        Apttus_Proposal__Proposal__c proposal = createProposal(acc.Id, opp.Id, Null, null);
            
        
        List<Apttus_Proposal__Proposal_Line_Item__c> lstLineItems = 
                        new List<Apttus_Proposal__Proposal_Line_Item__c>();
        
        List<Process__c> lstPIDs = new List<Process__c>();
                
        Product2 processTech4Com = createProduct('Test Process Technology', 'PROCESSTECHCOM0001', Null, 'XXX00321');        
        
        Product2 processTech = createProduct('Test Process Technology', 'PROCESSTECH0001', Null, processTech4Com.PT_Number__c);        
        Apttus_Proposal__Proposal_Line_Item__c lineItem1 = createProposalLineItem(1, proposal.Id, processTech.Id);
        lstLineItems.add(lineItem1);
        
        Product2 ms1 = createOptionProduct('Test Mask 1', 'Mask Layers', 'TESTMASK0001', 'CC', Null);
        Apttus_Proposal__Proposal_Line_Item__c lineItem2 = createProposalLineItem(2, proposal.Id, ms1.Id);
        lstLineItems.add(lineItem2);
        
        
        insert lstLineItems;
        
        //Exact
        Process__c pid1 = createProcess('Test PID 1', 'BB,CC,DD,EE', 'TESTPID000001', processTech.PT_Number__c);
        lstPIDs.add(pid1);
        
        //Compatible
        Process__c pidCom1 = createProcess('Test PID COM 1', 'BB,CC,DD,EE', 'TESTPIDCOM000001', processTech4Com.PT_Number__c);
        lstPIDs.add(pidCom1);
        
        //Greater
        Process__c pid2 = createProcess('Test PID 2', 'AA,BB,CC,DD,EE', 'TESTPID000002', processTech.PT_Number__c);
        lstPIDs.add(pid2);
        
        //FEOL
        Process__c pid3 = createProcess('Test PID 3', 'BB,CC,DD,EE', 'TESTPID000003', processTech.PT_Number__c);
        lstPIDs.add(pid3);
        
        //BEOL
        Process__c pid4 = createProcess('Test PID 4', 'BB,CC,DD,EE', 'TESTPID000004', processTech.PT_Number__c);
        lstPIDs.add(pid4);
        
        insert lstPIDs;
        
        //proposal.Mask_Set__c = 'BB CC DD EE';
        //changed reference of Mask_Set__c to Mask_Set_Long__c for the Case#00051463
        //proposal.Mask_Set_Long__c = 'BB CC DD EE';
        //update proposal;
                
        //system.runas(xUser){



        //Test.startTest();
        //update proposal; 
        PageReference pageRef = Page.PIDMatches;
    
        Test.setCurrentPage(pageRef);
        
        ApexPages.CurrentPage().getParameters().put('Id', proposal.id);
        
        ApexPages.StandardController sc = new ApexPages.standardController(proposal);                
        
        PIDMatchesController pidController = new PIDMatchesController(sc); 


        Test.stopTest();      
        //}
    }
    
    static testMethod void testNegetivePIDMatches(){

        //Setup the Proposal test record for the the page to render
        Account acc = getAccount('MYTEST ACCOUNT1');
        //User xUser = createXUser(acc.Id);
        
        Opportunity opp = createOpportunity(acc.Id);
        
        //Team_Room__c tmrm = createTeamroom(acc.Id);
        Test.startTest();
        Apttus_Proposal__Proposal__c proposal = createProposal(acc.Id, opp.Id, Null, null);
            
        
        List<Apttus_Proposal__Proposal_Line_Item__c> lstLineItems = 
                        new List<Apttus_Proposal__Proposal_Line_Item__c>();
        
        List<Process__c> lstPIDs = new List<Process__c>();
                
        Product2 processTech4Com = createProduct('Test Process Technology', 'PROCESSTECHCOM0001', Null, 'XXX00321');        
        
        Product2 processTech = createProduct('Test Process Technology', 'PROCESSTECH0001', Null, processTech4Com.PT_Number__c);        
        Apttus_Proposal__Proposal_Line_Item__c lineItem1 = createProposalLineItem(1, proposal.Id, processTech.Id);
        lstLineItems.add(lineItem1);
        
        Product2 ms1 = createOptionProduct('Test Mask 1', 'Mask Layers', 'TESTMASK0001', 'CC', Null);
        Apttus_Proposal__Proposal_Line_Item__c lineItem2 = createProposalLineItem(2, proposal.Id, ms1.Id);
        lstLineItems.add(lineItem2);
        
               
        insert lstLineItems;
        
        //Exact
        Process__c pid1 = createProcess('Test PID 1', 'BX,CX,DX,EX', 'TESTPID000001', processTech.PT_Number__c);
        lstPIDs.add(pid1);
        
        //Compatible
        Process__c pidCom1 = createProcess('Test PID COM 1', '11,22,33,44,55,66', 'TESTPIDCOM000001', processTech4Com.PT_Number__c);
        lstPIDs.add(pidCom1);
        
        //Greater
        Process__c pid2 = createProcess('Test PID 2', 'AX,BX,CX,DX,EX', 'TESTPID000002', processTech.PT_Number__c);
        lstPIDs.add(pid2);
        
        //FEOL
        Process__c pid3 = createProcess('Test PID 3', 'BX,CX', 'TESTPID000003', processTech.PT_Number__c);
        lstPIDs.add(pid3);
        
        //BEOL
        Process__c pid4 = createProcess('Test PID 4', 'DX,EX', 'TESTPID000004', processTech.PT_Number__c);
        lstPIDs.add(pid4);
        
        insert lstPIDs;
        
        //proposal.Mask_Set__c = 'BB CC DD EE';
        //changed reference of Mask_Set__c to Mask_Set_Long__c for the Case#00051463
        //proposal.Mask_Set_Long__c = 'BB CC DD EE';
        //update proposal;


                
        //system.runas(xUser){
        
        //update proposal;
        PageReference pageRef = Page.PIDMatches;
    
        Test.setCurrentPage(pageRef);
        
        ApexPages.CurrentPage().getParameters().put('Id', proposal.id);
        
        ApexPages.StandardController sc = new ApexPages.standardController(proposal);                
        
        PIDMatchesController pidController = new PIDMatchesController(sc);  


        Test.stopTest();           
        //}
    }
    static testMethod void testNegetivePIDMatches1(){
        
        //Setup the Proposal test record for the the page to render
        Account acc = getAccount('MYTEST ACCOUNT1');
        //User xUser = createXUser(acc.Id);
        
        Opportunity opp = createOpportunity(acc.Id);
        Test.startTest();
        //Team_Room__c tmrm = createTeamroom(acc.Id);
        
        //Apttus_Proposal__Proposal__c proposal = createProposal(acc.Id, opp.Id, Null, null);
        Apttus_Proposal__Proposal__c proposal = 
                    new Apttus_Proposal__Proposal__c(Apttus_Proposal__Description__c = 'Test Proposal Description ...',
                                                     //Device__c = dev.Id,                                                     
                                                     //Mask_Set__c = 'BB CC DD EE',
                                                     Mask_Set_Long__c = 'BB CC DD EE',
                                                     Apttus_Proposal__Opportunity__c = opp.Id,
                                                     Apttus_Proposal__Account__c = acc.Id);
        
        
        
        insert proposal;    
        
        List<Apttus_Proposal__Proposal_Line_Item__c> lstLineItems = 
                        new List<Apttus_Proposal__Proposal_Line_Item__c>();
        
        List<Process__c> lstPIDs = new List<Process__c>();
                
        Product2 processTech4Com = createProduct('Test Process Technology', 'PROCESSTECHCOM0001', Null, 'XXX00321');        
        
        Product2 processTech = createProduct('Test Process Technology', 'PROCESSTECH0001', Null, processTech4Com.PT_Number__c);        
        Apttus_Proposal__Proposal_Line_Item__c lineItem1 = createProposalLineItem(1, proposal.Id, processTech.Id);
        lstLineItems.add(lineItem1);
        
        Product2 ms1 = createOptionProduct('Test Mask 1', 'Mask Layers', 'TESTMASK0001', 'CC', Null);
        Apttus_Proposal__Proposal_Line_Item__c lineItem2 = createProposalLineItem(2, proposal.Id, ms1.Id);
        lstLineItems.add(lineItem2);
        
               
        insert lstLineItems;
        
        //Exact
        Process__c pid1 = createProcess('Test PID 1', 'BX,CX,DX,EX', 'TESTPID000001', processTech.PT_Number__c);
        lstPIDs.add(pid1);
        
        //Compatible
        Process__c pidCom1 = createProcess('Test PID COM 1', '11,22,33,44,55,66', 'TESTPIDCOM000001', processTech4Com.PT_Number__c);
        lstPIDs.add(pidCom1);
        
        //Greater
        Process__c pid2 = createProcess('Test PID 2', 'AX,BX,CX,DX,EX', 'TESTPID000002', processTech.PT_Number__c);
        lstPIDs.add(pid2);
        
        //FEOL
        Process__c pid3 = createProcess('Test PID 3', 'BX,CX', 'TESTPID000003', processTech.PT_Number__c);
        lstPIDs.add(pid3);
        
        //BEOL
        Process__c pid4 = createProcess('Test PID 4', 'DX,EX', 'TESTPID000004', processTech.PT_Number__c);
        lstPIDs.add(pid4);
        
        insert lstPIDs;
        
        //proposal.Mask_Set__c = 'BB CC DD EE';
        //changed reference of Mask_Set__c to Mask_Set_Long__c for the Case#00051463
        //bk/proposal.Mask_Set_Long__c = 'BB CC DD EE';
        //update proposal;
                
        //system.runas(xUser){
        Test.stopTest();
        //update proposal;
        PageReference pageRef = Page.PIDMatches;
    
        Test.setCurrentPage(pageRef);
        
        ApexPages.CurrentPage().getParameters().put('Id', proposal.id);
        
        ApexPages.StandardController sc = new ApexPages.standardController(proposal);                
        
        PIDMatchesController pidController = new PIDMatchesController(sc);  
                   
        //}
    }

    //Static method to create External User test record
    static User createXUser(Id accId){
        Profile prf = [Select Id, 
                              Name 
                         From Profile 
                        Where Name = 'Customer Portal Profile'];
                        
        Contact cnct = createContact(accId);
        
        User xUser = new User(alias = 'xUser',
                                email='xUser@testorg.com',
                                emailencodingkey='UTF-8',
                                lastname='xUser', 
                                languagelocalekey='en_US',
                                localesidkey='en_US',
                                profileid = prf.Id,
                                ContactId = cnct.Id,
                                Portal_Login__c = 'TestxUserLogin0001',
                                timezonesidkey='America/Los_Angeles',
                                username='xUser@testorg.com');
        
        insert xUser;
        return xUser;
    }
    
    //Static method to create External User Contact test record
    static Contact createContact(Id accId){
        Contact cnct = new Contact(email='xUser@testorg.com',
                                    lastname='xUser',
                                    FirstName = 'Testing',
                                    AccountId = accId);
        
        insert cnct;
        return cnct;
    }
        
    
    //Static method to create Opportunity test record
    static Opportunity createOpportunity(Id AccId){
        Opportunity opp = new Opportunity(Name = 'Test Opportunity',
                                          AccountId = AccId,
                                          StageName = '1. Discovery',
                                          CloseDate = Date.Today().addDays(10),
                                          Target_Process_Node__c = '14XM',
                                          Market_Segment__c = 'Mobility',
                                          Process_Platform__c = 'GF Baseline',
                                          Fab_Split__c = 100,
                                          Fab_Assignment_1__c = 'FAB 6',
                                          Process_Geometry__c='0.13UM',
                                          Process_Family__c='Generic / Nominal');
        
        insert opp;
        return opp;
    }
    
    //Static method to create proposal test record
    static Apttus_Proposal__Proposal__c createProposal(Id accId, Id oppId, Id devId, Id tmrmId){
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
                                     Product_External_ID__c = szCode + Math.random());
        
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
                                     Product_External_ID__c = szCode + Math.random());
        
        insert prod;
        return prod;
    }
    
    //Static method to create proposal line item test record
    static Apttus_Proposal__Proposal_Line_Item__c createProposalLineItem(Integer iNumber, Id PropId, Id optId){
        //Setup the test records required to create the Proposal test record
        Product2 prod = createProduct('Test Process Technology', 'PROCESSTECH0001', Null, 'PROCESSTECHCOM0001');
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
    
    static Process_Technology__c createProcessTechnology(){
        Process_Technology__c pt = new Process_Technology__c();
        pt.Name = 'PT002562';
        pt.Tech_Geometry__c = '0.028UM';
        insert pt;
        return pt;
    }
    
    private static Account getAccount(string AccountName)
    {
        Account acct = [SELECT Id, Name FROM Account Where Name =: AccountName];
        
        return acct;
    }

}