/*
Type Name: SwiftCustomLookupTest
Author: Cognizant 
Created Date: 31-March-2014
Reason: This is the test class for ClsCustomerLookupDialog, ClsMaskSetTitleLookupDialog and SwiftPagination test class.
Change History:
*/
@istest(SeeAllData=false)
public class SwiftCustomLookupTest {
	
	/**
	This method initialize data using throughout this test class.
	The create data method are: 
	- SwiftDataUtilityTest.customSystemData();
	@author		SWIFT TEAM
	@since		7-April-2015
	*/
	@testSetup static void setup() {
		SwiftDataUtilityTest.customSystemData();
	}
    
    /*
    * This test method tests the functionality of Customer lookup dialog
    */
    @isTest
    private static void CustomerLookupDialogTest() {
        /** creating test data **/
        // comment-out, refactored with testSetup method setup()
        // SwiftDataUtilityTest.customSystemData();
        if(Environment_Variable__c.getInstance('SwiftCustomLookupPageSize') == null) {
            Environment_Variable__c envObj = new Environment_Variable__c(Name='SwiftCustomLookupPageSize',Value__c='1');
            insert envObj;
        }
        Account acc = SwiftDataUtilityTest.createTestAccountForDRT();
        list<Mask_Set_Title__c> mstList = SwiftDataUtilityTest.maskSetTitleList(2);
        list<DRT__c> drtList=SwiftDataUtilityTest.createDRTList(1,mstList[0]);
        MST_Config__c mstConfig = SwiftDataUtilityTest.createMSTconfig(acc .Id,mstList[0].Id);
        Opportunity opp = SwiftDataUtilityTest.createOpportunityDRT(acc .Id);
        Opportunity_Program__c oppProg = SwiftDataUtilityTest.createOpportunityProgramDRT(acc .Id, opp.Id);
        Process_Technology__c pt = SwiftDataUtilityTest.createProcessTechnologyForDRT();
        
        Test.startTest();
        
        Device__c testDevice = SwiftDataUtilityTest.createDeviceWithPT(acc .Id, opp.Id,oppProg.Id,pt.Id);
        PTRF__c ptrf = SwiftDataUtilityTest.createPTRF_ForDRT(mstList[0].Id, testDevice.Id,acc .Id);
        /** End of test data creation **/
        
        // Customer lookup dialog test
        Test.setCurrentPage(Page.VFCustomerLookupDialog);
        ClsCustomerLookupDialog customerLookupObj = new ClsCustomerLookupDialog();
        customerLookupObj.searchCustomers();
        
        customerLookupObj.goNext();
        customerLookupObj.goPrev();
        boolean hasPrev = customerLookupObj.getHasPrevious();
        boolean hasNext = customerLookupObj.getHasNext();
        
        system.assertEquals(false,hasPrev);
        system.assertEquals(false,hasNext);
        
        Test.setCurrentPage(Page.VFCustomerLookupDialog);
        customerLookupObj = new ClsCustomerLookupDialog();
        customerLookupObj.searchString = 't';
        customerLookupObj.searchCustomers();
        customerLookupObj.goNext();
        customerLookupObj.goPrev();        
        hasPrev = customerLookupObj.getHasPrevious();
        hasNext = customerLookupObj.getHasNext();
        
        system.assert(customerLookupObj.listDisplayedCustomers != null);
        system.assertEquals(false,hasPrev);
        system.assertEquals(false,hasNext);
        
        Test.setCurrentPage(Page.VFCustomerLookupDialog);
        customerLookupObj = new ClsCustomerLookupDialog();
        customerLookupObj.searchString = 'invalid';
        customerLookupObj.searchCustomers();
        
        system.assert(customerLookupObj.listDisplayedCustomers != null);       
        
        customerLookupObj.goNext();
        customerLookupObj.goPrev();        
        hasPrev = customerLookupObj.getHasPrevious();
        hasNext = customerLookupObj.getHasNext();
        
        system.assertEquals(false,hasPrev);
        system.assertEquals(false,hasNext);
        
        SwiftPagination pgObj = new SwiftPagination(new list<Account>{acc});
        pgObj.setPageSize(1);
        pgObj.setPageNumber(1);
        pgObj.first();
        pgObj.last();
        
        Test.stopTest();
    }
     
    /*
    * This test method tests the functionality of Mask Set Title lookup dialog
    */
    @isTest
    private static void MaskSetTitleLookupDialogTest1() {
        /** creating test data **/
        User testUser;
        Account acc;
        Id currentUserId = UserInfo.getUserId();
        User thisUser = [ select Id from User where Id = :UserInfo.getUserId() ];
        
        system.runAs(thisUser) {
            Profile standardUserProfile = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
            UserRole usrRole=[SELECT Id FROM UserRole WHERE Name = 'GLOBALFOUNDRIES Corporate'];
            testUser = new User(alias = 'testMRS', email='testMRS@test.com',
                                emailencodingkey='UTF-8', lastname='testMRSLast', firstname='testMRSFirst', languagelocalekey='en_US',
                                localesidkey='en_US', profileid = standardUserProfile.Id, UserRoleId = usrRole.Id,
                                timezonesidkey='America/Los_Angeles', username='testMRS@test.com',communitynickname='testMRS',FederationIdentifier='Test');   
            
            insert testUser;        
        }
        system.runAs(testUser) {   
            list<Group> listOfGroups = [select Id, DeveloperName, Name from Group where (Name like 'Swift%' OR Name like 'SWIFT%')];
            list<GroupMember> gmList = new List<GroupMember>();
            for(Group g : ListOfGroups){
                    GroupMember singleGroupMemberObj = new GroupMember();
                    singleGroupMemberObj.GroupId = g.Id;
                    singleGroupMemberObj.UserOrGroupId = currentUserId;
                    gmList.add(singleGroupMemberObj);
            }
            insert gmList;        
        }
        // comment-out, refactored with testSetup method setup()
        // SwiftDataUtilityTest.customSystemData();
        if(Environment_Variable__c.getInstance('SwiftCustomLookupPageSize') == null) {
            Environment_Variable__c envObj = new Environment_Variable__c(Name='SwiftCustomLookupPageSize',Value__c='1');
            insert envObj;
        }

        acc = SwiftDataUtilityTest.createTestAccountForDRT();
        list<Mask_Set_Title__c> mstList = SwiftDataUtilityTest.maskSetTitleList(2);
        
        PTRF__c ptrf = new PTRF__c();
        ptrf.Name = 'PTRF1';
        ptrf.Customer__c=acc.Id;
        ptrf.Transaction_Date__c = date.today();
        ptrf.Order_Type__c = 'TEST';
        ptrf.Prime_Tapeout__c = true;
        ptrf.Frame_Tapeout__c = true;
        ptrf.Frame_Mockup__c = true;
        ptrf.Mask_Set_Title__c = mstList.get(0).Id;
        ptrf.MaskSetTitle__c=mstList.get(0).Id;
        ptrf.Status__c='Closed';
        ptrf.Prime_DRT__c = 'Prime';
        ptrf.Frame_DRT__c = 'Frame';        
        ptrf.Tech_Geo_Value__c= '0.02UM';
        ptrf.Recticle_Type__c='Multi Node Reticle (MNR)';
        ptrf.Prime_Tapeout__c = true;
        ptrf.Prime_GDSOUT_Review__c = true;
        
        insert ptrf;
        
        Id jvUserId = (Id)UserInfo.getUserId();
        list<PTRF_JobViewer_Info__c> listPTRFJVObj = new list<PTRF_JobViewer_Info__c>();
        PTRF_JobViewer_Info__c ptrfJVObj;
        
        ptrfJVObj = new PTRF_JobViewer_Info__c(Jobview_Type__c='Prime GDSOUT Review',User__c=jvUserId,Jobview__c='Customer',PTRF__c=ptrf.Id);
        listPTRFJVObj.add(ptrfJVObj);
        
        ptrfJVObj = new PTRF_JobViewer_Info__c(Jobview_Type__c='Frame Mockup',User__c=jvUserId,Jobview__c='Customer',PTRF__c=ptrf.Id);
        listPTRFJVObj.add(ptrfJVObj);
        
        ptrfJVObj = new PTRF_JobViewer_Info__c(Jobview_Type__c='MEBES Jobview',User__c=jvUserId,Jobview__c='Customer',PTRF__c=ptrf.Id);
        listPTRFJVObj.add(ptrfJVObj);
        
        ptrfJVObj = new PTRF_JobViewer_Info__c(Jobview_Type__c='Prime GDSOUT Review',User__c=jvUserId,Jobview__c='Foundry',PTRF__c=ptrf.Id);
        listPTRFJVObj.add(ptrfJVObj);
        
        ptrfJVObj = new PTRF_JobViewer_Info__c(Jobview_Type__c='Frame Mockup',User__c=jvUserId,Jobview__c='Foundry',PTRF__c=ptrf.Id);
        listPTRFJVObj.add(ptrfJVObj);
        
        insert listPTRFJVObj;
        
        // Test data for Send Data mst lookup
        Mask_Set_Title__c mstObj = SwiftDataUtilityTest.createMST('TESTMST');
        insert mstObj;
        MRS__c mrsObj = new MRS__c(Mask_Set_Title__c = mstObj.Id);
        insert mrsObj;
        
        /** End of test data creation **/
        Test.startTest();
        
        // Customer GDSOut Review test
        Test.setCurrentPage(Page.VFMaskSetTitleLookupDialog);
        ApexPages.currentPage().getParameters().put('aid',acc.Id);
        ApexPages.currentPage().getParameters().put('pg','CustomerGDSOutReview');
        ApexPages.currentPage().getParameters().put('jv','true');
        
        ClsMaskSetTitleLookupDialog mstLookupObj = new ClsMaskSetTitleLookupDialog();
        mstLookupObj.searchMSTs();
        mstLookupObj.goNext();
        mstLookupObj.goPrev();
        boolean hasPrev = mstLookupObj .getHasPrevious();
        boolean hasNext = mstLookupObj .getHasNext();
        
        // Customer Frame Mockup test
        Test.setCurrentPage(Page.VFMaskSetTitleLookupDialog);
        ApexPages.currentPage().getParameters().put('aid',acc.Id);
        ApexPages.currentPage().getParameters().put('pg','CustomerFrameMockup');
        ApexPages.currentPage().getParameters().put('jv','true');
        
        mstLookupObj = new ClsMaskSetTitleLookupDialog();
        mstLookupObj.searchString = 'MYMST';
        mstLookupObj.searchMSTs();
        mstLookupObj.goNext();
        mstLookupObj.goPrev();
        hasPrev = mstLookupObj.getHasPrevious();
        hasNext = mstLookupObj.getHasNext();
        
        // MEBES Jobview test
        
        Test.setCurrentPage(Page.VFMaskSetTitleLookupDialog);
        ApexPages.currentPage().getParameters().put('aid',acc.Id);
        ApexPages.currentPage().getParameters().put('pg','Customer MEBES Jobview');
        ApexPages.currentPage().getParameters().put('jv','true');
        
        mstLookupObj = new ClsMaskSetTitleLookupDialog();
        mstLookupObj.searchMSTs();
        mstLookupObj.goNext();
        mstLookupObj.goPrev();
        hasPrev = mstLookupObj .getHasPrevious();
        hasNext = mstLookupObj .getHasNext();
        
        Test.setCurrentPage(Page.VFMaskSetTitleLookupDialog);
        ApexPages.currentPage().getParameters().put('aid',acc.Id);
        ApexPages.currentPage().getParameters().put('pg','HoldResume');
        
        mstLookupObj = new ClsMaskSetTitleLookupDialog();
        mstLookupObj.searchMSTs();
        mstLookupObj.goNext();
        mstLookupObj.goPrev();
        hasPrev = mstLookupObj.getHasPrevious();
        hasNext = mstLookupObj.getHasNext();
        
        Test.setCurrentPage(Page.VFMaskSetTitleLookupDialog);
        ApexPages.currentPage().getParameters().put('aid',acc.Id);
        ApexPages.currentPage().getParameters().put('pg','LayerSummary');
        
        mstLookupObj = new ClsMaskSetTitleLookupDialog();
        mstLookupObj.searchMSTs();
        mstLookupObj.goNext();
        mstLookupObj.goPrev();
        hasPrev = mstLookupObj.getHasPrevious();
        hasNext = mstLookupObj.getHasNext();
        
        // Send Data test
        Test.setCurrentPage(Page.VFMaskSetTitleLookupDialog);
        ApexPages.currentPage().getParameters().put('pg','SendData');
        
        mstLookupObj = new ClsMaskSetTitleLookupDialog();
        mstLookupObj.searchMSTs();
        
        system.assertEquals(1,mstLookupObj.listDisplayedMSTs.size());
        
        Test.stopTest();
    }
    
    /*
    * This test method tests the functionality of Mask Set Title lookup dialog
    */
    @isTest
    private static void MaskSetTitleLookupDialogTest2() {
        /** creating test data **/
        User testUser;
        Account acc;
        Id currentUserId = UserInfo.getUserId();
        User thisUser = [ select Id from User where Id = :UserInfo.getUserId() ];
        
        system.runAs(thisUser) {
            Profile standardUserProfile = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
            UserRole usrRole=[SELECT Id FROM UserRole WHERE Name = 'GLOBALFOUNDRIES Corporate'];
            testUser = new User(alias = 'testMRS', email='testMRS@test.com',
                                emailencodingkey='UTF-8', lastname='testMRSLast', firstname='testMRSFirst', languagelocalekey='en_US',
                                localesidkey='en_US', profileid = standardUserProfile.Id, UserRoleId = usrRole.Id,
                                timezonesidkey='America/Los_Angeles', username='testMRS@test.com',communitynickname='testMRS',FederationIdentifier='Test');   
            
            insert testUser;        
        }       
        
        system.runAs(testUser) {   
            list<Group> listOfGroups = [select Id, DeveloperName, Name from Group where (Name like 'Swift%' OR Name like 'SWIFT%')];
            list<GroupMember> gmList = new List<GroupMember>();
            for(Group g : ListOfGroups){
                    GroupMember singleGroupMemberObj = new GroupMember();
                    singleGroupMemberObj.GroupId = g.Id;
                    singleGroupMemberObj.UserOrGroupId = currentUserId;
                    gmList.add(singleGroupMemberObj);
            }
            insert gmList;
        }        
        
        // comment-out, refactored with testSetup method setup()  
        // SwiftDataUtilityTest.customSystemData();
        if(Environment_Variable__c.getInstance('SwiftCustomLookupPageSize') == null) {
            Environment_Variable__c envObj = new Environment_Variable__c(Name='SwiftCustomLookupPageSize',Value__c='1');
            insert envObj;
        }

        acc = SwiftDataUtilityTest.createTestAccountForDRT();
        list<Mask_Set_Title__c> mstList = SwiftDataUtilityTest.maskSetTitleList(2);
        
        PTRF__c ptrf = new PTRF__c();
        ptrf.Name = 'PTRF1';
        ptrf.Customer__c=acc.Id;
        ptrf.Transaction_Date__c = date.today();
        ptrf.Order_Type__c = 'TEST';
        ptrf.Prime_Tapeout__c = true;
        ptrf.Frame_Tapeout__c = true;
        ptrf.Frame_Mockup__c = true;
        ptrf.Mask_Set_Title__c = mstList.get(0).Id;
        ptrf.MaskSetTitle__c=mstList.get(0).Id;
        ptrf.Status__c='Closed';
        ptrf.Prime_DRT__c = 'Prime';
        ptrf.Frame_DRT__c = 'Frame';        
        ptrf.Tech_Geo_Value__c= '0.02UM';
        ptrf.Recticle_Type__c='Multi Node Reticle (MNR)';
        ptrf.Prime_Tapeout__c = true;
        ptrf.Prime_GDSOUT_Review__c = true;
        
        insert ptrf;
        
        Id jvUserId = (Id)UserInfo.getUserId();
        list<PTRF_JobViewer_Info__c> listPTRFJVObj = new list<PTRF_JobViewer_Info__c>();
        PTRF_JobViewer_Info__c ptrfJVObj;
        
        ptrfJVObj = new PTRF_JobViewer_Info__c(Jobview_Type__c='Prime GDSOUT Review',User__c=jvUserId,Jobview__c='Customer',PTRF__c=ptrf.Id);
        listPTRFJVObj.add(ptrfJVObj);
        
        ptrfJVObj = new PTRF_JobViewer_Info__c(Jobview_Type__c='Frame Mockup',User__c=jvUserId,Jobview__c='Customer',PTRF__c=ptrf.Id);
        listPTRFJVObj.add(ptrfJVObj);
        
        ptrfJVObj = new PTRF_JobViewer_Info__c(Jobview_Type__c='MEBES Jobview',User__c=jvUserId,Jobview__c='Customer',PTRF__c=ptrf.Id);
        listPTRFJVObj.add(ptrfJVObj);
        
        ptrfJVObj = new PTRF_JobViewer_Info__c(Jobview_Type__c='Prime GDSOUT Review',User__c=jvUserId,Jobview__c='Foundry',PTRF__c=ptrf.Id);
        listPTRFJVObj.add(ptrfJVObj);
        
        ptrfJVObj = new PTRF_JobViewer_Info__c(Jobview_Type__c='Frame Mockup',User__c=jvUserId,Jobview__c='Foundry',PTRF__c=ptrf.Id);
        listPTRFJVObj.add(ptrfJVObj);
        
        insert listPTRFJVObj;
        
        // Test data for Send Data mst lookup
        Mask_Set_Title__c mstObj = SwiftDataUtilityTest.createMST('TESTMST');
        insert mstObj;
        MRS__c mrsObj = new MRS__c(Mask_Set_Title__c = mstObj.Id);
        insert mrsObj;

        /** End of test data creation **/
        
        Test.startTest();
        
        /** set perform approval flag to true**/
        system.runAs(testUser) {
            if(Environment_Variable__c.getInstance('ALL_VIEW_ALL_APPROVAL') != null) {
                Environment_Variable__c envObj = Environment_Variable__c.getInstance('ALL_VIEW_ALL_APPROVAL');
                envObj.Value__c='invalid group';
                update envObj;
            }
        }
        // GDSOUT test
        Test.setCurrentPage(Page.VFMaskSetTitleLookupDialog);
        ApexPages.currentPage().getParameters().put('aid',acc.Id);
        ApexPages.currentPage().getParameters().put('pg','CustomerGDSOutReview');
        ApexPages.currentPage().getParameters().put('jv','true');
        
        ClsMaskSetTitleLookupDialog mstLookupObj = new ClsMaskSetTitleLookupDialog();
        
        // Frame Mockup test
        Test.setCurrentPage(Page.VFMaskSetTitleLookupDialog);
        ApexPages.currentPage().getParameters().put('aid',acc.Id);
        ApexPages.currentPage().getParameters().put('pg','CustomerFrameMockup');
        ApexPages.currentPage().getParameters().put('jv','true');
        
        mstLookupObj = new ClsMaskSetTitleLookupDialog();
        
        // MEBES test
        
        // Removing user from all groups to set isUserMEBES and isUserAdmin flag to false
        
        system.runAs(testUser) { 
            list<GroupMember> gmDelList = new list<GroupMember>();
            for(GroupMember gm : [SELECT Id,UserOrGroupId FROM GroupMember WHERE UserOrGroupId = :currentUserId]){
                    gmDelList.add(gm);
            }
            delete gmDelList;
        }
     
        Test.setCurrentPage(Page.VFMaskSetTitleLookupDialog);
        ApexPages.currentPage().getParameters().put('aid',acc.Id);
        ApexPages.currentPage().getParameters().put('pg','Customer MEBES Jobview');
        ApexPages.currentPage().getParameters().put('jv','true');
        
        mstLookupObj = new ClsMaskSetTitleLookupDialog();
        
        
        // Customer id is blank
        Test.setCurrentPage(Page.VFMaskSetTitleLookupDialog);
        ApexPages.currentPage().getParameters().put('aid','');
        ApexPages.currentPage().getParameters().put('pg','CustomerGDSOutReview');
        ApexPages.currentPage().getParameters().put('jv','true');        
        mstLookupObj = new ClsMaskSetTitleLookupDialog();
        system.assertEquals(0,mstLookupObj.listDisplayedMSTs.size());
        
        // invalid page name passed
        Test.setCurrentPage(Page.VFMaskSetTitleLookupDialog);
        ApexPages.currentPage().getParameters().put('aid',acc.Id);
        ApexPages.currentPage().getParameters().put('pg','invalidPageName');
        ApexPages.currentPage().getParameters().put('jv','true');        
        mstLookupObj = new ClsMaskSetTitleLookupDialog();
        system.assertEquals(0,mstLookupObj.listDisplayedMSTs.size());
        
        
        Test.stopTest();
    }
}