/*
Type Name: MRSLayerChipSummaryExtnTest
Author: Cognizant 
Created Date: 23-May-2014
Reason: 
Change History:
Author: 
Modified Date: 
Reason: 
Author: Cognizant Technology Solutions
Modified Date:
*/
@istest(SeeAllData = false)
public class MRSLayerChipSummaryExtnTest {

    //public static List < MRS_Layer_Association__c > layerSummary;
    //public static Account objAccount;
    //public static Mask_Set_Title__c objMST;
    //public static PTRF__c objPTRF;
    //public static PTRF__c objPTRF2;

    //public static User sysAdminUser;
    //public static User userSU;
    //public static User userSUFE;
    //public static MRS_Layer_Chip_Association__c MRSLCAObj3;

    /**
        This method is for setting default Test Environment data and creating Test Account instance. 
        @method name: TestAccountInsert
        @parameter:   None
        @return :     void
     **/
    /* public static void TestAccountInsert() {
        SwiftDataUtilityTest.customSystemData();
        objAccount = SwiftDataUtilityTest.createTestAccountForDRT();
        System.assertNotEquals(objAccount, null);
        objAccount.stage__c = 'Qualified';
        update objAccount;

    } */

    @testSetup static void testdata() {
        
        //TestAccountInsert();
        SwiftDataUtilityTest.customSystemData();
        Account objAccount = SwiftDataUtilityTest.createTestAccountForDRT();
        //System.assertNotEquals(objAccount, null);
        objAccount.stage__c = 'Qualified';
        update objAccount;
        Test.startTest();
        Mask_Set_Title__c objMST = SwiftDataUtilityTest.createMST('MST1001');
        insert objMST;
        
        List<PTRF__c> ptrfList = new List<PTRF__c>();
        PTRF__c objPTRF = createPTRF('PTRF 000 1001', objMST, null);
        ptrfList.add(objPTRF);
        PTRF__c objPTRF2 = createPTRF2('PTRF 000 1002', objMST, null);
        ptrfList.add(objPTRF2);
        insert ptrfList;
        
        List<Mask_Layer__c> maskLayerList = new List<Mask_Layer__c>();
        Mask_Layer__c objLayer = createMaskLayer(objPTRF, objMST, 'MLN001', 'AZ', '01');
        maskLayerList.add(objLayer);
        Mask_Layer__c objLayer2 = createMaskLayer(objPTRF2, objMST, 'MLN002', 'AZ', '01');
        maskLayerList.add(objLayer2);
        insert maskLayerList;

        MRS__c MRSObject = createMRS(objPTRF,objMST);
        System.assertNotEquals(MRSObject.Id, null);

        //MRS__c MRSObject2 = createMRS2();
        //System.assertNotEquals(MRSObject.Id, null);
        
        List<MRS_Chip_Details__c> mrsChipDetailsList = new List<MRS_Chip_Details__c>();
        MRS_Chip_Details__c MRSChipDetails = createMRSChipDetail(String.valueOf(objMST.Name), String.valueOf(MRSObject.Id));
        //System.assertNotEquals(MRSChipDetails.Id, null);
        mrsChipDetailsList.add(MRSChipDetails);
        MRS_Chip_Details__c MRSChipDetails2 = createMRSChipDetail(String.valueOf(objMST.Name), String.valueOf(MRSObject.Id));
        //System.assertNotEquals(MRSChipDetails2.Id, null);
        mrsChipDetailsList.add(MRSChipDetails2);
        insert mrsChipDetailsList;
        
        List<MRS_Layer_Association__c> mrsLayerAssociationList = new List<MRS_Layer_Association__c>();
        MRS_Layer_Association__c MRSLAObj1 = createMRSData(String.valueOf(objLayer.Name), String.valueOf(objLayer.Mask_Layer_Rev__c), String.valueOf(objMST.Name), String.valueOf(MRSObject.Id));
        //System.assertNotEquals(MRSLAObj1.Id, null);
        mrsLayerAssociationList.add(MRSLAObj1);
        MRS_Layer_Association__c MRSLAObj2 = createMRSData(String.valueOf(objLayer2.Name), String.valueOf(objLayer2.Mask_Layer_Rev__c), String.valueOf(objMST.Name), String.valueOf(MRSObject.Id));
        //System.assertNotEquals(MRSLAObj2.Id, null);
        mrsLayerAssociationList.add(MRSLAObj2);
        insert mrsLayerAssociationList;
        
        List<MRS_Layer_Chip_Association__c> mrsLayerChipAssociationList = new List<MRS_Layer_Chip_Association__c>();
        MRS_Layer_Chip_Association__c MRSLCAObj1 = createMRSLCAData(String.valueOf(MRSChipDetails.Id), String.valueOf(objPTRF.Id), String.valueOf(objAccount.id), String.valueOf(MRSLAObj1.Id), String.valueOf(objMST.Name), String.valueOf(MRSObject.Id));
        //System.assertNotEquals(MRSLCAObj1.Id, null);
        mrsLayerChipAssociationList.add(MRSLCAObj1);
        MRS_Layer_Chip_Association__c MRSLCAObj2 = createMRSLCAData2(String.valueOf(MRSChipDetails.Id), String.valueOf(objPTRF.Id), String.valueOf(objAccount.id), String.valueOf(MRSLAObj1.Id), String.valueOf(objMST.Name), String.valueOf(MRSObject.Id));
        //System.assertNotEquals(MRSLCAObj2.Id, null);
        mrsLayerChipAssociationList.add(MRSLCAObj2);
        MRS_Layer_Chip_Association__c MRSLCAObj3 = createMRSLCAData3(String.valueOf(MRSChipDetails2.Id), String.valueOf(objPTRF2.Id), String.valueOf(objAccount.id), String.valueOf(MRSLAObj2.Id), String.valueOf(objMST.Name), String.valueOf(MRSObject.Id));
        //System.assertNotEquals(MRSLCAObj3.Id, null);
        mrsLayerChipAssociationList.add(MRSLCAObj3);
        insert mrsLayerChipAssociationList;

        //layerSummary = [select name, Layer_Status__c, ID from MRS_Layer_Association__c];
        //Test.startTest();
        System.runAs(new User(Id = UserInfo.getUserId())) {
            User sysAdminUser = [SELECT Id, Name FROM User WHERE Profile.Name = 'System Administrator'
            AND isActive = true].get(0);
            Group groupGS = [select Id, DeveloperName, Name from Group where DeveloperName = 'SWIFT_Admin'];
            GroupMember groupMember = new GroupMember();
            groupMember.GroupId = groupGS.Id;
            groupMember.UserOrGroupId = sysAdminUser.Id;
            insert groupMember;

            list < User > listUser = new list < User > ();
            Profile stdUserProfile = [SELECT Id FROM Profile WHERE Name = 'Standard User'];
            UserRole usrRole = [SELECT Id FROM UserRole WHERE Name = 'GLOBALFOUNDRIES Corporate'];
            User userSU = new User(alias = 'testMRS2', email = 'testMRS2@test.com',
            emailencodingkey = 'UTF-8', lastname = 'testMRS2Last', firstname = 'testMRS2First', languagelocalekey = 'en_US',
            localesidkey = 'en_US', profileid = stdUserProfile.Id, UserRoleId = usrRole.Id,
            timezonesidkey = 'America/Los_Angeles', username = 'testMRS2@test.com', communitynickname = 'testMRS2');
            User userSUFE = new User(alias = 'testMRS3', email = 'testMRS3@test.com',
            emailencodingkey = 'UTF-8', lastname = 'testMRS3Last', firstname = 'testMRS3First', languagelocalekey = 'en_US',
            localesidkey = 'en_US', profileid = stdUserProfile.Id, UserRoleId = usrRole.Id,
            timezonesidkey = 'America/Los_Angeles', username = 'testMRS3@test.com', communitynickname = 'testMRS3');

            listUser.add(userSU);
            listUser.add(userSUFE);

            insert listUser;

            List < String > listFieldNames = new List < String > {
                'Swift_GlobalShuttle', 'Swift_Tapeout_Centre', 'Swift_MDP', 'Swift_TDTI_MPW', 'Swift_Tapeout_Operations', 'Swift_Tapeout_Application', 'SWIFT_Support', 'Swift_RMG', 'Swift_Foundry_Jobviewer', 'SWIFT_CAD', 'Swift_Tapeout_Admin'
            };

            GroupMember groupMember1;
            for (Group groupGS1: [select Id, DeveloperName, Name from Group where DeveloperName in : listFieldNames]) {
                groupMember1 = new GroupMember();
                groupMember1.GroupId = groupGS1.Id;
                //groupMember1.UserOrGroupId = userSU.Id;
                groupMember1.UserOrGroupId = sysAdminUser.Id;
                insert groupMember1;
            }

            Account_Team_Proxy__c accproxy = new Account_Team_Proxy__c();
            accproxy.Team_Role__c = 'Field Application Engineer';
            accproxy.User__c = userSUFE.id;
            accproxy.Account__c = objAccount.id;
            accproxy.Account_Access__c = 'Read/Write';
            accproxy.Opportunity_Access__c = 'Read/Write';

            insert accproxy;

            PTRF_JobViewer_Info__c objJobviewer = new PTRF_JobViewer_Info__c();
            objJobviewer.Email_Address__c = 'test@test.com';
            objJobviewer.User__c = sysAdminUser.id;
            objJobviewer.PTRF__c = objPtrf.id;
            objJobviewer.Jobview__c = 'Foundry';
            objJobviewer.Jobview_Type__c = 'MEBES Jobview';

            insert objJobviewer;

        }
        Test.stopTest();    
    }

    //This method is for running test data for validations before Save functionality of manual update page. 
    static testMethod void TestMRSLayerChipSummaryExtn2() {
            Test.startTest();
            User sysAdminUser = [SELECT Id, Name FROM User WHERE Profile.Name = 'System Administrator' AND isActive = true].get(0);
            System.runAs(sysAdminUser) {
            createCustomerPermissionMRSLayer();
            

            MRS_Layer_Summary_Refresh_Interval__c refreshInterval = new MRS_Layer_Summary_Refresh_Interval__c();
            refreshInterval.Page_Refresh_Frequency__c = 50;
            refreshInterval.Name = 'LayerSummaryInterval';
            insert refreshInterval;
            
            Account objAccount = [Select Id, name from Account where name='Test Account 009'];
            Mask_Set_Title__c objMST = [Select Id, name from Mask_Set_Title__c where name = 'MST1001'];
            
            
            List < MRS_Layer_Association__c > layerSummary = [select name, Layer_Status__c, ID from MRS_Layer_Association__c];
            ApexPages.StandardController appSc = new ApexPages.StandardController(layerSummary[0]);
            ApexPages.currentPage().getParameters().put('id', layerSummary[0].Id);
            ApexPages.currentPage().getParameters().put('customerid', objAccount.Id);
            ApexPages.currentPage().getParameters().put('mstid', objMST.Id);
            ApexPages.currentPage().getHeaders().put('Host', system.Label.SWIFT_Community_URL);

            MRSLayerChipSummaryExtn objMRSLayerChipAssocExtn = new MRSLayerChipSummaryExtn(appSc);
            objMRSLayerChipAssocExtn.populateFilterValues(String.valueof(layerSummary[0].id));
            objMRSLayerChipAssocExtn.populateManualUpdatePicklist();
            objMRSLayerChipAssocExtn.statusSelectedValue = '';
            objMRSLayerChipAssocExtn.boolAll = false;
            objMRSLayerChipAssocExtn.boolGDSOUT = true;
            objMRSLayerChipAssocExtn.boolFrameMockup = true;
            objMRSLayerChipAssocExtn.boolSendData = true;
            objMRSLayerChipAssocExtn.viewLayerChipData();
            createSettingsMain();
            objMRSLayerChipAssocExtn.fetchStatusHierarchyFromSettings();
            objMRSLayerChipAssocExtn.isTechGeoViewable();
            objMRSLayerChipAssocExtn.setFieldsForCustomer();
            
            objMRSLayerChipAssocExtn.openLayerChipPage();
            objMRSLayerChipAssocExtn.openManualUpdate();
            objMRSLayerChipAssocExtn.manualExportToExcel();
            objMRSLayerChipAssocExtn.manualExportToCSV();
            objMRSLayerChipAssocExtn.exportToExcel();
            objMRSLayerChipAssocExtn.exportToCSV();
            
            System.assertnotEquals(null, objMRSLayerChipAssocExtn.listCustomerGDSOUTReview);
            System.assertnotEquals(null, objMRSLayerChipAssocExtn.listFoundryGDSOUTReview);
            System.assertnotEquals(null, objMRSLayerChipAssocExtn.listCustomerFrameMockup);
            System.assertnotEquals(null, objMRSLayerChipAssocExtn.listFoundryFrameMockup);
            System.assertnotEquals(null, objMRSLayerChipAssocExtn.listSendPrimeData);
            System.assertnotEquals(null, objMRSLayerChipAssocExtn.listSendFrameData);
            System.assertnotEquals(null, objMRSLayerChipAssocExtn.listORC);
            System.assertnotEquals(null, objMRSLayerChipAssocExtn.listDRW);
            System.assertnotEquals(null, objMRSLayerChipAssocExtn.listCustomerPrimeRemoteJobviewSetup);
            System.assertnotEquals(null, objMRSLayerChipAssocExtn.listCustomerFrameRemoteJobviewSetup);
            System.assertnotEquals(null, objMRSLayerChipAssocExtn.listFoundryPrimeRemoteJobviewSetup);
            System.assertnotEquals(null, objMRSLayerChipAssocExtn.listFoundryFrameRemoteJobviewSetup);
            System.assertnotEquals(null, objMRSLayerChipAssocExtn.listPrimeMEBESReceived);
            System.assertnotEquals(null, objMRSLayerChipAssocExtn.listFrameMEBESReceived);
            System.assertnotEquals(null, objMRSLayerChipAssocExtn.listCustomerMEBESJobview);
            System.assertnotEquals(null, objMRSLayerChipAssocExtn.listFoundryMEBESJobview);
            System.assertnotEquals(null, objMRSLayerChipAssocExtn.listTapeoutCentreMEBESJobview);
            System.assertnotEquals(null, objMRSLayerChipAssocExtn.listTapeoutApplicationsMEBESJobview);
            System.assertnotEquals(null, objMRSLayerChipAssocExtn.listGlobalShuttleMEBESJobview);
            System.assertnotEquals(null, objMRSLayerChipAssocExtn.listMDPMEBESJobview);
            System.assertnotEquals(null, objMRSLayerChipAssocExtn.listTDTIMPWMEBESJobview);
            System.assertnotEquals(null, objMRSLayerChipAssocExtn.optionlistLayerStatus);
            System.assertnotEquals(null, objMRSLayerChipAssocExtn.optionlistDevice);
            System.assertnotEquals(null, objMRSLayerChipAssocExtn.optionlistPTRFnDRT);
            System.assertnotEquals(null, objMRSLayerChipAssocExtn.optionlistTechGeo);

            System.assertnotEquals(0, objMRSLayerChipAssocExtn.setLayerList.size());
            System.assertnotEquals(0, objMRSLayerChipAssocExtn.mapManualUpdatePicklist.size());
            System.assertnotEquals(0, objMRSLayerChipAssocExtn.lstLayerChipSummary.size());
            System.assertnotEquals(0, objMRSLayerChipAssocExtn.lstLayerChipWrapper.size());
            System.assertnotEquals(0, objMRSLayerChipAssocExtn.mapLayerChipStatusSettings.size());

            objMRSLayerChipAssocExtn.lstLayerChipSummaryOld[0].Customer_Frame_Mockup__c = 'Ready';
            objMRSLayerChipAssocExtn.lstLayerChipSummary[0].Customer_Frame_Mockup__c = 'Not Ready';

            objMRSLayerChipAssocExtn.lstLayerChipSummaryOld[0].Foundry_Frame_Mockup__c = 'Ready';
            objMRSLayerChipAssocExtn.lstLayerChipSummary[0].Foundry_Frame_Mockup__c = '';

            objMRSLayerChipAssocExtn.lstLayerChipSummaryOld[0].Customer_GDSOUT_Review__c = 'Not Ready';
            objMRSLayerChipAssocExtn.lstLayerChipSummary[0].Customer_GDSOUT_Review__c = 'Approve';

            objMRSLayerChipAssocExtn.lstLayerChipSummaryOld[0].Send_Prime_Data__c = 'Not Done';
            objMRSLayerChipAssocExtn.lstLayerChipSummary[0].Send_Prime_Data__c = 'Not Done';

            objMRSLayerChipAssocExtn.lstLayerChipSummaryOld[0].Send_Frame_Data__c = 'Not Done';
            objMRSLayerChipAssocExtn.lstLayerChipSummary[0].Send_Frame_Data__c = 'Not Done';

            objMRSLayerChipAssocExtn.lstLayerChipSummaryOld[0].ORC__c = 'In Progress';
            objMRSLayerChipAssocExtn.lstLayerChipSummary[0].ORC__c = 'Ready';

            objMRSLayerChipAssocExtn.lstLayerChipSummaryOld[0].DRW__c = 'Not Ready';
            objMRSLayerChipAssocExtn.lstLayerChipSummary[0].DRW__c = 'Done';

            objMRSLayerChipAssocExtn.lstLayerChipSummaryOld[0].Prime_MEBES_Received__c = 'Not Done';
            objMRSLayerChipAssocExtn.lstLayerChipSummary[0].Prime_MEBES_Received__c = 'Done';

            objMRSLayerChipAssocExtn.lstLayerChipSummaryOld[0].Customer_Prime_Remote_Jobview_Setup__c = 'N.A.';
            objMRSLayerChipAssocExtn.lstLayerChipSummary[0].Customer_Prime_Remote_Jobview_Setup__c = 'Done';

            objMRSLayerChipAssocExtn.lstLayerChipSummaryOld[0].Tapeout_Centre_MEBES_Jobview__c = 'N.A.';
            objMRSLayerChipAssocExtn.lstLayerChipSummary[0].Tapeout_Centre_MEBES_Jobview__c = 'Done';

            objMRSLayerChipAssocExtn.lstLayerChipSummaryOld[0].Customer_MEBES_Jobview__c = 'Not Ready';
            objMRSLayerChipAssocExtn.lstLayerChipSummary[0].Customer_MEBES_Jobview__c = 'Released';

            objMRSLayerChipAssocExtn.lstLayerChipSummaryOld[0].Customer_Frame_Remote_Jobview_Setup__c = 'Not Ready';
            objMRSLayerChipAssocExtn.lstLayerChipSummaryOld[0].Foundry_MEBES_Jobview__c = 'Not Ready';
            objMRSLayerChipAssocExtn.lstLayerChipSummary[0].Foundry_MEBES_Jobview__c = 'Ready';

            PageReference pg6 = objMRSLayerChipAssocExtn.saveLayerChipData();

            List < ApexPages.Message > msgList = ApexPages.getMessages();
            // or loop over the messages
            for (ApexPages.Message msg: ApexPages.getMessages()) {
                System.assertnotEquals(null, msg.getSummary());

            }

            System.assertEquals(null, pg6);
            
            objMRSLayerChipAssocExtn.clearLayerChipData();

        }
        Test.stopTest();
    }

    //This method is for running test data for mail send scenarios for Globalshuttle,MDP,TDTI mebes jobview. 
    static testMethod void TestMRSLayerChipSummaryExtn17() {
        Test.startTest();
        Account objAccount = [Select Id, name from Account where name='Test Account 009'];
        Mask_Set_Title__c objMST = [Select Id, name from Mask_Set_Title__c where name = 'MST1001'];
        User sysAdminUser = [SELECT Id, Name FROM User WHERE Profile.Name = 'System Administrator' AND isActive = true].get(0);
        System.runAs(sysAdminUser) {
            

            MRS_Layer_Summary_Refresh_Interval__c refreshInterval = new MRS_Layer_Summary_Refresh_Interval__c();
            refreshInterval.Page_Refresh_Frequency__c = 50;
            refreshInterval.Name = 'LayerSummaryInterval';
            insert refreshInterval;

            List < MRS_Layer_Association__c > layerSummary = [select name, Layer_Status__c, ID from MRS_Layer_Association__c];
            ApexPages.StandardController appSc = new ApexPages.StandardController(layerSummary[0]);
            ApexPages.currentPage().getParameters().put('id', layerSummary[0].Id);
            ApexPages.currentPage().getParameters().put('customerid', objAccount.Id);
            ApexPages.currentPage().getParameters().put('mstid', objMST.Id);
            ApexPages.currentPage().getHeaders().put('Host', system.Label.SWIFT_Community_URL);

            MRSLayerChipSummaryExtn objMRSLayerChipAssocExtn = new MRSLayerChipSummaryExtn(appSc);
            objMRSLayerChipAssocExtn.populateFilterValues(String.valueof(layerSummary[0].id));
            objMRSLayerChipAssocExtn.populateManualUpdatePicklist();
            objMRSLayerChipAssocExtn.statusSelectedValue = '';
            objMRSLayerChipAssocExtn.boolAll = true;
            objMRSLayerChipAssocExtn.viewLayerChipData();
            objMRSLayerChipAssocExtn.strCustomerName = 'test';

            objMRSLayerChipAssocExtn.lstLayerChipSummaryOld[0].GlobalShuttle_MEBES_Jobview__c = 'Ready';
            objMRSLayerChipAssocExtn.lstLayerChipSummary[0].GlobalShuttle_MEBES_Jobview__c = 'Released';

            objMRSLayerChipAssocExtn.lstLayerChipSummaryOld[0].MDP_MEBES_Jobview__c = 'Ready';
            objMRSLayerChipAssocExtn.lstLayerChipSummary[0].MDP_MEBES_Jobview__c = 'Released';

            objMRSLayerChipAssocExtn.lstLayerChipSummaryOld[0].TDTI_MPW_MEBES_Jobview__c = 'Ready';
            objMRSLayerChipAssocExtn.lstLayerChipSummary[0].TDTI_MPW_MEBES_Jobview__c = 'Released';

            objMRSLayerChipAssocExtn.sendManualUpdateMail();
            System.assertEquals(true, objMRSLayerChipAssocExtn.boolIsMailSent);

        }
        Test.stopTest();
    }
    
    //This method is for running test data for mail send scenarios for Foundry,Tapeout Centre,Tapeout Apps jobview. 
    static testMethod void TestMRSLayerChipSummaryExtn18() {
        Test.startTest();
        Account objAccount = [Select Id, name from Account where name='Test Account 009'];
        Mask_Set_Title__c objMST = [Select Id, name from Mask_Set_Title__c where name = 'MST1001'];
        User sysAdminUser = [SELECT Id, Name FROM User WHERE Profile.Name = 'System Administrator' AND isActive = true].get(0);
        System.runAs(sysAdminUser) {           

            MRS_Layer_Summary_Refresh_Interval__c refreshInterval = new MRS_Layer_Summary_Refresh_Interval__c();
            refreshInterval.Page_Refresh_Frequency__c = 50;
            refreshInterval.Name = 'LayerSummaryInterval';
            insert refreshInterval;

            List < MRS_Layer_Association__c > layerSummary = [select name, Layer_Status__c, ID from MRS_Layer_Association__c];
            ApexPages.StandardController appSc = new ApexPages.StandardController(layerSummary[0]);
            ApexPages.currentPage().getParameters().put('id', layerSummary[0].Id);
            ApexPages.currentPage().getParameters().put('customerid', objAccount.Id);
            ApexPages.currentPage().getParameters().put('mstid', objMST.Id);
            ApexPages.currentPage().getHeaders().put('Host', system.Label.SWIFT_Community_URL);

            MRSLayerChipSummaryExtn objMRSLayerChipAssocExtn = new MRSLayerChipSummaryExtn(appSc);
            objMRSLayerChipAssocExtn.populateFilterValues(String.valueof(layerSummary[0].id));
            objMRSLayerChipAssocExtn.populateManualUpdatePicklist();
            objMRSLayerChipAssocExtn.statusSelectedValue = '';
            objMRSLayerChipAssocExtn.boolAll = true;
            objMRSLayerChipAssocExtn.viewLayerChipData();
            objMRSLayerChipAssocExtn.strCustomerName = 'test';


            objMRSLayerChipAssocExtn.lstLayerChipSummaryOld[0].Foundry_MEBES_Jobview__c = 'Ready';
            objMRSLayerChipAssocExtn.lstLayerChipSummary[0].Foundry_MEBES_Jobview__c = 'Released';

            objMRSLayerChipAssocExtn.lstLayerChipSummaryOld[0].Tapeout_Centre_MEBES_Jobview__c = 'Ready';
            objMRSLayerChipAssocExtn.lstLayerChipSummary[0].Tapeout_Centre_MEBES_Jobview__c = 'Released';

            objMRSLayerChipAssocExtn.lstLayerChipSummaryOld[0].Tapeout_Applications_MEBES_Jobview__c = 'Ready';
            objMRSLayerChipAssocExtn.lstLayerChipSummary[0].Tapeout_Applications_MEBES_Jobview__c = 'Released';


            objMRSLayerChipAssocExtn.lstLayerChipSummaryOld[0].Customer_MEBES_Jobview__c = 'Not Ready';
            objMRSLayerChipAssocExtn.lstLayerChipSummary[0].Customer_MEBES_Jobview__c = 'Ready';

            objMRSLayerChipAssocExtn.lstLayerChipSummaryOld[0].Foundry_MEBES_Jobview__c = 'Not Ready';
            objMRSLayerChipAssocExtn.lstLayerChipSummary[0].Foundry_MEBES_Jobview__c = 'Ready';



            objMRSLayerChipAssocExtn.sendManualUpdateMail();
            System.assertEquals(true, objMRSLayerChipAssocExtn.boolIsMailSent);

        }
        Test.stopTest();
    }

    //This method is for running test data for mail send scenarios for Customer/Foundry Mebes. 
    static testMethod void TestMRSLayerChipSummaryExtn19 (){
        Account objAccount = [Select Id, name from Account where name='Test Account 009'];
        Mask_Set_Title__c objMST = [Select Id, name from Mask_Set_Title__c where name = 'MST1001'];
        User sysAdminUser = [SELECT Id, Name FROM User WHERE Profile.Name = 'System Administrator' AND isActive = true].get(0);        
        System.runAs(sysAdminUser){
             Test.startTest();
            
             MRS_Layer_Summary_Refresh_Interval__c refreshInterval= new MRS_Layer_Summary_Refresh_Interval__c();
             refreshInterval.Page_Refresh_Frequency__c = 50;
             refreshInterval.Name ='LayerSummaryInterval'; 
             insert refreshInterval;
             
            List < MRS_Layer_Association__c > layerSummary = [select name,Layer_Status__c,ID from MRS_Layer_Association__c];
             ApexPages.StandardController appSc = new ApexPages.StandardController(layerSummary[0]);   
             ApexPages.currentPage().getParameters().put('id',layerSummary[0].Id);
             ApexPages.currentPage().getParameters().put('customerid',objAccount.Id);
             ApexPages.currentPage().getParameters().put('mstid',objMST.Id);
             ApexPages.currentPage().getHeaders().put('Host',system.Label.SWIFT_Community_URL);
             
             MRSLayerChipSummaryExtn objMRSLayerChipAssocExtn = new MRSLayerChipSummaryExtn(appSc );                     
             objMRSLayerChipAssocExtn.populateFilterValues(String.valueof(layerSummary[0].id));
             objMRSLayerChipAssocExtn.populateManualUpdatePicklist();         
             objMRSLayerChipAssocExtn.statusSelectedValue='';
             objMRSLayerChipAssocExtn.boolAll=true;
             objMRSLayerChipAssocExtn.viewLayerChipData();
             objMRSLayerChipAssocExtn.strCustomerName='test';
             
             objMRSLayerChipAssocExtn.lstLayerChipSummaryOld[0].Customer_MEBES_Jobview__c='Not Ready';
             objMRSLayerChipAssocExtn.lstLayerChipSummary[0].Customer_MEBES_Jobview__c='Ready';
            
             objMRSLayerChipAssocExtn.lstLayerChipSummaryOld[0].Foundry_MEBES_Jobview__c='Not Ready';
             objMRSLayerChipAssocExtn.lstLayerChipSummary[0].Foundry_MEBES_Jobview__c='Ready';
            
                          
             objMRSLayerChipAssocExtn.sendManualUpdateMail();
             System.assertEquals(true, objMRSLayerChipAssocExtn.boolIsMailSent);
                  
             Test.stopTest();
        }
    }
    
    public static void createCustomerPermissionMRSLayer(){
       Account objAccount = [Select Id, name from Account where name='Test Account 009'];
       Customer_Layer_Summary_Permission__c customerPermission = new Customer_Layer_Summary_Permission__c();
       customerPermission.Customer__c = objAccount.Id;
       customerPermission.Customer_Remote_Jobview__c = true;
       //customerPermission.Customer_Short_Name__c = 'test';
       customerPermission.Frame_Mockup__c = true;
       customerPermission.GDSOUT_Review__c = true;
       customerPermission.MEBES_Jobview__c = true;
       insert customerPermission;
   }

    /**
        This method is for storing data in MRS_Layer_Chip_Status_Hierarchy__c object for test method execution. 
        @method name: createSettingsMain
        @parameter:   None
        @return :     void
     **/
    private static void createSettingsMain() {

        createSettings('Customer_Frame_Mockup__c', '2', '4', '0', '0', '1', '3', '4', '0', '0');
        createSettings('Customer_Frame_Remote_Jobview_Setup__c', '0', '0', '0', '0', '1', '0', '0', '2', '0');
        createSettings('Customer_GDSOUT_Review__c', '2', '4', '0', '0', '1', '3', '0', '0', '0');
        createSettings('Customer_MEBES_Jobview__c', '2', '0', '0', '0', '1', '3', '0', '0', '4');
        createSettings('Customer_Prime_Remote_Jobview_Setup__c', '0', '0', '0', '0', '1', '0', '0', '2', '0');
        createSettings('DRW__c', '2', '0', '0', '3', '1', '0', '0', '4', '0');
        createSettings('Foundry_Frame_Mockup__c', '2', '4', '0', '0', '1', '3', '4', '0', '0');
        createSettings('Foundry_Frame_Remote_Jobview_Setup__c', '0', '0', '0', '0', '1', '0', '0', '2', '0');
        createSettings('Foundry_GDSOUT_Review__c', '2', '4', '0', '0', '1', '3', '0', '0', '0');
        createSettings('Foundry_MEBES_Jobview__c', '2', '0', '0', '0', '1', '3', '0', '0', '4');
        createSettings('Foundry_Prime_Remote_Jobview_Setup__c', '0', '0', '0', '0', '1', '0', '0', '2', '0');
        createSettings('Frame_MEBES_Received__c', '0', '0', '2', '0', '1', '0', '0', '3', '0');
        createSettings('GlobalShuttle_MEBES_Jobview__c', '2', '0', '0', '0', '1', '3', '0', '0', '4');
        createSettings('MDP_MEBES_Jobview__c', '2', '0', '0', '0', '1', '3', '0', '0', '4');
        createSettings('ORC__c', '0', '0', '2', '0', '1', '0', '0', '3', '0');
        createSettings('Prime_MEBES_Received__c', '0', '0', '2', '0', '1', '0', '0', '3', '0');
        createSettings('Send_Frame_Data__c', '2', '0', '0', '0', '1', '3', '0', '4', '0');
        createSettings('Send_Prime_Data__c', '2', '0', '0', '0', '1', '3', '0', '4', '0');
        createSettings('Tapeout_Applications_MEBES_Jobview__c', '2', '0', '0', '0', '1', '3', '0', '0', '4');
        createSettings('Tapeout_Centre_MEBES_Jobview__c', '2', '0', '0', '0', '1', '3', '0', '0', '4');
        createSettings('TDTI_MPW_MEBES_Jobview__c', '2', '0', '0', '0', '1', '3', '0', '0', '4');

        List < MRS_Layer_Chip_Status_Hierarchy__c > lstHierarchy = [select Name from MRS_Layer_Chip_Status_Hierarchy__c limit 1];
        System.assertnotEquals(0, lstHierarchy.size());
    }

    /**
        This method is for storing data in MRS_Layer_Chip_Status_Hierarchy__c object for test method execution. 
        @method name: createSettings
        @parameter:   1. Status name
                      2. Value for Approve  
                      3. Value for Disapprove
                      4. Value for Done
                      5. Value for InProgress
                      6. Value for NA
                      7. Value for NotDone
                      8. Value for NotReady
                      9. Value for Ready
                      10. Value for Released
        @return :     void
     **/
    private static void createSettings(string strname, string NotReady, string Approve, string NotDone, string InProgress, string NA, string Ready, string Disapprove, string Done, string Released) {

        MRS_Layer_Chip_Status_Hierarchy__c objStatus = new MRS_Layer_Chip_Status_Hierarchy__c();
        objStatus.name = strname;
        objStatus.Approve__c = Approve;
        objStatus.Disapprove__c = Disapprove;
        objStatus.Done__c = Done;
        objStatus.InProgress__c = InProgress;
        objStatus.NA__c = NA;
        objStatus.Not_Done__c = NotDone;
        objStatus.Not_Ready__c = NotReady;
        objStatus.Ready__c = Ready;
        objStatus.Released__c = Released;

        insert objStatus;

        System.assertnotEquals(null, objStatus);

    }


    /**
        This method is for storing data in Chip_Detail__c object for test method execution. 
        @method name: createChipDetail
        @parameter:   1. PTRF object
                      2. Chip name  
        @return :     Chip_Detail__c object
     **/
    private static Chip_Detail__c createChipDetail(PTRF__c ptrf, string chipname) {

        Chip_Detail__c chipDetail = new Chip_Detail__c();
        chipDetail.PTRF__c = ptrf.Id;
        chipDetail.Name = chipname;

        insert chipDetail;
        System.assertnotEquals(null, chipDetail);

        return chipDetail;
    }

    /**
        This method is for storing data in Mask_Layer__c object for test method execution. 
        @method name: createMaskLayer
        @parameter:   1. PTRF object
                      2. Mask_Set_Title__c  object  
                      3. Layer Name
                      4. Rom Code
                      5. Layer Revision code
        @return :     Mask_Layer__c object
     **/
    private static Mask_Layer__c createMaskLayer(PTRF__c ptrf, Mask_Set_Title__c objMST1, string Layername, string RomCode, string LayerRev) {

        Mask_Layer__c maskLayer = new Mask_Layer__c();
        maskLayer.Tapeout__c = true;
        maskLayer.Name = Layername;
        maskLayer.Mask_Set_Title__c = objMST1.id;
        maskLayer.PTRF__c = ptrf.Id;
        maskLayer.ROM_Code__c = RomCode;
        maskLayer.Mask_Layer_Rev__c = LayerRev;
        maskLayer.LogicalOperation__c = 'Foundry Std';
        maskLayer.LogicalOperationType__c = 'Foundry Std.';
        //insert maskLayer;
        System.assertnotEquals(null, maskLayer);

        return maskLayer;
    }

    /**
        This method is for storing data in PTRF__c  object for test method execution. 
        @method name: createPTRF
        @parameter:   1. PTRF name
                      2. Mask_Set_Title__c  object  
                      3. Device name  
                      
        @return :     PTRF__c object
     **/
    private static PTRF__c createPTRF(string ptrfname, Mask_Set_Title__c objMST1, Device__c objDevice) {
        Account objAccount = [Select Id, name from Account where name='Test Account 009'];
        PTRF__c ptrf = new PTRF__c();

        ptrf.Status__c = 'Active';
        ptrf.Mask_Set_Title__c = objMST1.id;
        ptrf.MaskSetTitle__c = objMST1.id;
        ptrf.Device_Id__c = 'Device1';
        ptrf.Transaction_Date__c = Date.today();
        ptrf.Process_ID__c = '';
        ptrf.Prime_Tapeout__c = true;
        ptrf.Prime_Status__c = '';
        ptrf.Prime_DRT__c = '';
        ptrf.Name = ptrfname;
        ptrf.Order_Type__c = 'Retrofit';
        ptrf.Frame_Status__c = '';
        ptrf.Frame_Mockup__c = true;
        ptrf.Frame_GDSOUT_Review__c = false;
        ptrf.Frame_DRT__c = '';
        ptrf.Frame_Tapeout__c = true;
        ptrf.DRC_Only__c = false;
        ptrf.Prime_GDSOUT_Review__c = true;
        ptrf.Recticle_Type__c = 'Multi Node Reticle (MNR)';
        ptrf.Tech_Geo_Value__c = '0.02UM';

        ptrf.customer_jobview__c = 'Gating mask release';
        ptrf.foundry_Jobview__c = 'Gating mask release';
        ptrf.Customer__c = objAccount.id;

        //insert ptrf;
        System.assertnotEquals(null, ptrf);

        return ptrf;
    }


    /**
        This method is for storing data in PTRF__c  object for test method execution. 
        @method name: createPTRF2
        @parameter:   1. PTRF name
                      2. Mask_Set_Title__c  object  
                      3. Device name  
                      
        @return :     PTRF__c object
     **/
    private static PTRF__c createPTRF2(string ptrfname, Mask_Set_Title__c objMST1, Device__c objDevice) {
        Account objAccount = [Select Id, name from Account where name='Test Account 009'];
        PTRF__c ptrf = new PTRF__c();

        ptrf.Status__c = 'Active';
        ptrf.Mask_Set_Title__c = objMST1.id;
        ptrf.MaskSetTitle__c = objMST1.id;
        ptrf.Device_Id__c = 'Device1';
        ptrf.Transaction_Date__c = Date.today();
        ptrf.Process_ID__c = '';
        ptrf.Prime_Tapeout__c = true;
        ptrf.Prime_Status__c = '';
        ptrf.Prime_DRT__c = '';
        ptrf.Name = ptrfname;
        ptrf.Order_Type__c = 'Retrofit';
        ptrf.Frame_Status__c = '';
        ptrf.Frame_Mockup__c = true;
        ptrf.Frame_GDSOUT_Review__c = false;
        ptrf.Frame_DRT__c = '';
        ptrf.Frame_Tapeout__c = true;
        ptrf.DRC_Only__c = false;
        ptrf.Prime_GDSOUT_Review__c = true;
        ptrf.Recticle_Type__c = 'Multi Node Reticle (MNR)';
        ptrf.Tech_Geo_Value__c = '0.02UM';

        ptrf.customer_jobview__c = 'Not gating mask release';
        ptrf.foundry_Jobview__c = 'Not gating mask release';
        ptrf.Customer__c = objAccount.id;

        //insert ptrf;
        System.assertnotEquals(null, ptrf);

        return ptrf;
    }

    /**
        This method is for storing data in Process_Technology__c object for test method execution. 
        @method name: createProcessTechnology
        @parameter:   None
        @return :     Process_Technology__c object
     **/
    private static Process_Technology__c createProcessTechnology() {
        Process_Technology__c p = new Process_Technology__c();
        p.Name = 'PT1';
        p.IP_Geometry_Technology__c = 'GT1';
        p.Tech_Geometry__c = '0.02';
        insert p;
        System.assertnotEquals(null, p);

        return p;
    }

    /**
        This method is for storing data in Opportunity_Program__c object for test method execution. 
        @method name: createOpportunityProgram
        @parameter:   1. Account id
                      2. Opp Program Id  
        @return :     Opportunity_Program__c Id
     **/
    private static Id createOpportunityProgram(Id testAcctId, Id testOpptyId) {
        // Create Opportunity Program
        Opportunity_Program__c testOpptyProgram = new Opportunity_Program__c();
        testOpptyProgram.Name = 'Test Opportunity Program';
        testOpptyProgram.Account__c = testAcctId;
        testOpptyProgram.Opportunity__c = testOpptyId;

        Insert testOpptyProgram;
        System.assertnotEquals(null, testOpptyProgram);

        return testOpptyProgram.Id;
    }

    /**
        This method is for storing data in Opportunity object for test method execution. 
        @method name: createOpportunity
        @parameter:   1. Account Id
        @return :     Oportunity Id
     **/
    private static Id createOpportunity(Id testAcctId) {
        // Create Opportunity
        Map<String,Object> fieldValueMap = new Map<String,Object>();
        fieldValueMap.put('AccountId',testAcctId);
        fieldValueMap.put('Name','MRSLayerSummary');  
        fieldValueMap.put('StageName','1. Discovery');
        fieldValueMap.put('CloseDate',Date.Today().addDays(10));  
        fieldValueMap.put('Target_Process_Node__c','14XM');
        fieldValueMap.put('Market_Segment__c','Mobility');  
        fieldValueMap.put('Process_Platform__c','GF Baseline');
        fieldValueMap.put('Fab_Split__c',100);          
        fieldValueMap.put('Process_Geometry__c','0.055UM');  
        fieldValueMap.put('Process_Family__c','Generic / Nominal');
        
        return OpportunityDataFactory.createOpportunity(fieldValueMap).id;
       
    }

    /**
        This method is for storing data in MRS__c object for test method execution. 
        @method name: createMRS
        @parameter:   None
        @return :     MRS__c object
     **/
    public static MRS__c createMRS(PTRF__c objPTRF, Mask_Set_Title__c objMST) {
        MRS__c obj = new MRS__c();
        obj.Associated_PTRF__c = objPTRF.Id;
        obj.Mask_Set_Title__c = objMST.Id;
        obj.MRS_Package_Sync__c = false;
        insert obj;
        System.assertnotEquals(null, obj);
        return obj;
    }

    /**
        This method is for storing data in MRS_Chip_Details__c object for test method execution. 
        @method name: createMRSChipDetail
        @parameter:   1. MST name
                      2. MRS Id
        @return :     MRS_Chip_Details__c object
     **/
    public static MRS_Chip_Details__c createMRSChipDetail(String MaskSetTitleName, String MRSId) {
        MRS_Chip_Details__c obj = new MRS_Chip_Details__c();
        obj.MRS__c = MRSId;
        obj.Name = 'TestChip';
        //insert obj;
        System.assertnotEquals(null, obj);
        return obj;
    }

    /**
        This method is for storing data in MRS_Layer_Association__c object for test method execution. 
        @method name: createMRSData
        @parameter:   1. Layer name
                      2. Mask Layer Rev
                      3. MST Name
                      4. MRS id
        @return :     MRS_Layer_Association__c object
     **/
    public static MRS_Layer_Association__c createMRSData(String LayerName, String MaskLayerRev, String MaskSetTitleName, String MRSObjId) {
        MRS_Layer_Association__c MRSObj = new MRS_Layer_Association__c();
        MRSObj.Customer_Frame_Mockup_Date__c = System.now();
        MRSObj.Customer_Frame_Mockup__c = 'Not Ready';
        MRSObj.Customer_Frame_Remote_Jobview_Setup_Date__c = System.now();
        MRSObj.Customer_Frame_Remote_Jobview_Setup__c = 'Done';
        MRSObj.Customer_GDSOUT_Review_Date__c = System.now();
        MRSObj.Customer_GDSOUT_Review__c = 'In Progress';
        MRSObj.Customer_MEBES_Jobview_Date__c = System.now();
        MRSObj.Customer_MEBES_Jobview__c = 'In Progress';
        MRSObj.Customer_Prime_Remote_Jobview_Setup_Date__c = System.now();
        MRSObj.Customer_Prime_Remote_Jobview_Setup__c = 'Done';
        MRSObj.Disapprove_Reason_For_Frame_Mockup_Revie__c = 'Disaproved';
        MRSObj.DRW_Date__c = System.now();
        MRSObj.DRW__c = 'Not Ready';
        MRSObj.Error_Message_Oracle_DB__c = '';
        MRSObj.First_Sync_with_Oracle__c = false;
        MRSObj.Foundry_Frame_Mockup_Date__c = System.now();
        MRSObj.Foundry_Frame_Mockup__c = 'In Progress';
        MRSObj.Foundry_Frame_Remote_Jobview_Setup_Date__c = System.now();
        MRSObj.Foundry_Frame_Remote_Jobview_Setup__c = 'Done';
        MRSObj.Foundry_GDSOUT_Review_Date__c = System.now();
        MRSObj.Foundry_GDSOUT_Review__c = 'In Progress';
        MRSObj.Foundry_MEBES_Jobview_Date__c = System.now();
        MRSObj.Foundry_MEBES_Jobview__c = 'Ready';
        MRSObj.Foundry_Prime_Remote_Jobview_Setup_Date__c = System.now();
        MRSObj.Foundry_Prime_Remote_Jobview_Setup__c = 'Done';
        MRSObj.Frame_MEBES_Received_Date__c = System.now();
        MRSObj.Frame_MEBES_Received__c = 'Not Done';
        MRSObj.Generated_Mask_Title__c = '';
        MRSObj.GlobalShuttle_MEBES_Jobview_Date__c = System.now();
        MRSObj.GlobalShuttle_MEBES_Jobview__c = 'Not Ready';
        MRSObj.Hold_Warning__c = '';
        MRSObj.Layer_Name__c = LayerName;
        MRSObj.Layer_Status_Date__c = System.now();
        MRSObj.Layer_Status__c = 'In Progress';
        MRSObj.Mask_Layer_Rev__c = MaskLayerRev;
        MRSObj.MDP_MEBES_Jobview_Date__c = System.now();
        MRSObj.MDP_MEBES_Jobview__c = 'In Progress';
        MRSObj.MRS__c = MRSObjId;
        MRSObj.Name = LayerName;
        MRSObj.ORC_Date__c = System.now();
        MRSObj.ORC__c = 'Done';
        MRSObj.Prime_MEBES_Received_Date__c = System.now();
        MRSObj.Prime_MEBES_Received__c = 'Not Done';
        MRSObj.Reticle_Type__c = 'Multi Node Reticle (MNR)';
        MRSObj.ROM_Code__c = '123';
        MRSObj.Send_Frame_Data_Date__c = System.now();
        MRSObj.Send_Frame_Data__c = 'Not Done';
        MRSObj.Send_Prime_Data_Date__c = System.now();
        MRSObj.Send_Prime_Data__c = 'Not Done';
        MRSObj.Tapeout_Applications_MEBES_Jobview_Date__c = System.now();
        MRSObj.Tapeout_Applications_MEBES_Jobview__c = 'Not Ready';
        MRSObj.Tapeout_Centre_MEBES_Jobview_Date__c = System.now();
        MRSObj.Tapeout_Centre_MEBES_Jobview__c = 'In Progress';
        MRSObj.TDTI_MPW_MEBES_Jobview_Date__c = System.now();
        MRSObj.TDTI_MPW_MEBES_Jobview__c = 'Not Ready';
        MRSObj.Tech_Geo__c = '0.028UM';
        //insert MRSObj;
        System.assertnotEquals(null, MRSObj);
        return MRSObj;
    }

    /**
        This method is for storing data in MRS_Layer_Chip_Association__c object for test method execution. 
        @method name: createMRSLCAData
        @parameter:   1. Chip detail Id
                      2. PTRF id
                      3. Account Id
                      4. Layer id
                      5. MST Name
                      6. MRS id
        @return :     MRS_Layer_Chip_Association__c object
     **/
    public static MRS_Layer_Chip_Association__c createMRSLCAData(String MRSChipDetailsId, String PTRFId, String AccountId, String MRSLCAId, String MaskSetTitleName, String MRSObjId) {

        MRS_Layer_Chip_Association__c obj = new MRS_Layer_Chip_Association__c();
        obj.Chip__c = MRSChipDetailsId;
        obj.PTRF__c = PTRFId;
        obj.Name = 'ChipName1';
        obj.Chip_Hold_Warning__c = 'Hold Warning Waive';
        obj.Customer_Name__c = AccountId;
        obj.Device_Id__c = 'Device1';
        obj.Layer__c = MRSLCAId;
        obj.Customer_Frame_Mockup_Date__c = System.now();
        obj.Customer_Frame_Mockup__c = 'Not Ready';
        obj.Customer_Frame_Remote_Jobview_Setup_Date__c = System.now();
        obj.Customer_Frame_Remote_Jobview_Setup__c = 'Done';
        obj.Customer_GDSOUT_Review_Date__c = System.now();
        obj.Customer_GDSOUT_Review__c = 'N.A.';
        obj.Customer_MEBES_Jobview_Date__c = System.now();
        obj.Customer_MEBES_Jobview__c = 'N.A.';
        obj.Customer_Prime_Remote_Jobview_Setup_Date__c = System.now();
        obj.Customer_Prime_Remote_Jobview_Setup__c = 'Done';

        obj.DRW_Date__c = System.now();
        obj.DRW__c = 'Not Ready';
        obj.Error_Message_Oracle_DB__c = '';
        obj.First_Sync_with_Oracle__c = false;
        obj.Foundry_Frame_Mockup_Date__c = System.now();
        obj.Foundry_Frame_Mockup__c = 'N.A.';
        obj.Foundry_Frame_Remote_Jobview_Setup_Date__c = System.now();
        obj.Foundry_Frame_Remote_Jobview_Setup__c = 'Done';
        obj.Foundry_GDSOUT_Review_Date__c = System.now();
        obj.Foundry_GDSOUT_Review__c = 'N.A.';
        obj.Foundry_MEBES_Jobview_Date__c = System.now();
        obj.Foundry_MEBES_Jobview__c = 'Ready';
        obj.Foundry_Prime_Remote_Jobview_Setup_Date__c = System.now();
        obj.Foundry_Prime_Remote_Jobview_Setup__c = 'Done';
        obj.Frame_MEBES_Received_Date__c = System.now();
        obj.Frame_MEBES_Received__c = 'Not Done';

        obj.GlobalShuttle_MEBES_Jobview_Date__c = System.now();
        obj.GlobalShuttle_MEBES_Jobview__c = 'Not Ready';

        obj.Layer_Chip_Status__c = 'N.A.';

        obj.Layer_Chip_Status__c = 'N.A.';

        obj.MDP_MEBES_Jobview_Date__c = System.now();
        obj.MDP_MEBES_Jobview__c = 'N.A.';

        obj.ORC_Date__c = System.now();
        obj.ORC__c = 'Done';
        obj.Prime_MEBES_Received_Date__c = System.now();
        obj.Prime_MEBES_Received__c = 'Not Done';


        obj.Send_Frame_Data_Date__c = System.now();
        obj.Send_Frame_Data__c = 'Not Done';
        obj.Send_Prime_Data_Date__c = System.now();
        obj.Send_Prime_Data__c = 'Not Done';
        obj.Tapeout_Applications_MEBES_Jobview_Date__c = System.now();
        obj.Tapeout_Applications_MEBES_Jobview__c = 'Not Ready';
        obj.Tapeout_Centre_MEBES_Jobview_Date__c = System.now();
        obj.Tapeout_Centre_MEBES_Jobview__c = 'N.A.';

        obj.TDTI_MPW_MEBES_Jobview__c = 'Not Ready';
        obj.Tech_Geo__c = '0.028UM';
        obj.PTRF_Or_DRT__c = 'PTRF';

        //insert obj;
        System.assertnotEquals(null, obj);
        return obj;
    }

    /**
        This method is for storing data in MRS_Layer_Chip_Association__c object for test method execution. 
        @method name: createMRSLCAData2
        @parameter:   1. Chip detail Id
                      2. PTRF id
                      3. Account Id
                      4. Layer id
                      5. MST Name
                      6. MRS id
        @return :     MRS_Layer_Chip_Association__c object
     **/
    public static MRS_Layer_Chip_Association__c createMRSLCAData2(String MRSChipDetailsId, String PTRFId, String AccountId, String MRSLCAId, String MaskSetTitleName, String MRSObjId) {
        Account objAccount = [Select Id, name from Account where name='Test Account 009'];
        Mask_Set_Title__c objMST = [Select Id, name from Mask_Set_Title__c where name = 'MST1001'];
        DRT__c objDRT = new DRT__c();
        objDRT.name = 'Test DRT';
        objDRT.Customer_Name__c = objAccount.id;
        objDRT.Mask_Set_Title__c = objMST.id;
        insert objDRT;

        MRS_Layer_Chip_Association__c obj = new MRS_Layer_Chip_Association__c();
        obj.Chip__c = MRSChipDetailsId;
        obj.PTRF__c = PTRFId;
        obj.Name = 'ChipName1';
        obj.Chip_Hold_Warning__c = 'Hold Warning Waive';
        obj.Customer_Name__c = AccountId;
        obj.Device_Id__c = 'Device1';
        obj.Layer__c = MRSLCAId;
        obj.Customer_Frame_Mockup_Date__c = System.now();
        obj.Customer_Frame_Mockup__c = 'Not Ready';
        obj.Customer_Frame_Remote_Jobview_Setup_Date__c = System.now();
        obj.Customer_Frame_Remote_Jobview_Setup__c = 'Done';
        obj.Customer_GDSOUT_Review_Date__c = System.now();
        obj.Customer_GDSOUT_Review__c = 'N.A.';
        obj.Customer_MEBES_Jobview_Date__c = System.now();
        obj.Customer_MEBES_Jobview__c = 'N.A.';
        obj.Customer_Prime_Remote_Jobview_Setup_Date__c = System.now();
        obj.Customer_Prime_Remote_Jobview_Setup__c = 'Done';

        obj.DRW_Date__c = System.now();
        obj.DRW__c = 'Not Ready';
        obj.Error_Message_Oracle_DB__c = '';
        obj.First_Sync_with_Oracle__c = false;
        obj.Foundry_Frame_Mockup_Date__c = System.now();
        obj.Foundry_Frame_Mockup__c = 'N.A.';
        obj.Foundry_Frame_Remote_Jobview_Setup_Date__c = System.now();
        obj.Foundry_Frame_Remote_Jobview_Setup__c = 'Done';
        obj.Foundry_GDSOUT_Review_Date__c = System.now();
        obj.Foundry_GDSOUT_Review__c = 'N.A.';
        obj.Foundry_MEBES_Jobview_Date__c = System.now();
        obj.Foundry_MEBES_Jobview__c = 'Ready';
        obj.Foundry_Prime_Remote_Jobview_Setup_Date__c = System.now();
        obj.Foundry_Prime_Remote_Jobview_Setup__c = 'Done';
        obj.Frame_MEBES_Received_Date__c = System.now();
        obj.Frame_MEBES_Received__c = 'Not Done';

        obj.GlobalShuttle_MEBES_Jobview_Date__c = System.now();
        obj.GlobalShuttle_MEBES_Jobview__c = 'Not Ready';

        obj.Layer_Chip_Status__c = 'N.A.';

        obj.MDP_MEBES_Jobview_Date__c = System.now();
        obj.MDP_MEBES_Jobview__c = 'N.A.';

        obj.ORC_Date__c = System.now();
        obj.ORC__c = 'Done';
        obj.Prime_MEBES_Received_Date__c = System.now();
        obj.Prime_MEBES_Received__c = 'Not Done';

        obj.Send_Frame_Data_Date__c = System.now();
        obj.Send_Frame_Data__c = 'Not Done';
        obj.Send_Prime_Data_Date__c = System.now();
        obj.Send_Prime_Data__c = 'Not Done';
        obj.Tapeout_Applications_MEBES_Jobview_Date__c = System.now();
        obj.Tapeout_Applications_MEBES_Jobview__c = 'Not Ready';
        obj.Tapeout_Centre_MEBES_Jobview_Date__c = System.now();
        obj.Tapeout_Centre_MEBES_Jobview__c = 'N.A.';

        obj.TDTI_MPW_MEBES_Jobview__c = 'Not Ready';
        obj.Tech_Geo__c = '0.01';
        obj.PTRF_Or_DRT__c = 'DRT';
        obj.DRT__c = objDRT.ID;

        //insert obj;
        System.assertnotEquals(null, obj);
        return obj;
    }

    /**
        This method is for storing data in MRS_Layer_Chip_Association__c object for test method execution. 
        @method name: createMRSLCAData3
        @parameter:   1. Chip detail Id
                      2. PTRF id
                      3. Account Id
                      4. Layer id
                      5. MST Name
                      6. MRS id
        @return :     MRS_Layer_Chip_Association__c object
     **/
    public static MRS_Layer_Chip_Association__c createMRSLCAData3(String MRSChipDetailsId, String PTRFId, String AccountId, String MRSLCAId, String MaskSetTitleName, String MRSObjId) {

        MRS_Layer_Chip_Association__c obj = new MRS_Layer_Chip_Association__c();
        obj.Chip__c = MRSChipDetailsId;
        obj.PTRF__c = PTRFId;
        obj.Name = 'ChipName1';
        obj.Chip_Hold_Warning__c = 'Hold Warning Waive';
        obj.Customer_Name__c = AccountId;
        obj.Device_Id__c = 'Device1';
        obj.Layer__c = MRSLCAId;
        obj.Customer_Frame_Mockup_Date__c = System.now();
        obj.Customer_Frame_Mockup__c = 'Not Ready';
        obj.Customer_Frame_Remote_Jobview_Setup_Date__c = System.now();
        obj.Customer_Frame_Remote_Jobview_Setup__c = 'Done';
        obj.Customer_GDSOUT_Review_Date__c = System.now();
        obj.Customer_GDSOUT_Review__c = 'N.A.';
        obj.Customer_MEBES_Jobview_Date__c = System.now();
        obj.Customer_MEBES_Jobview__c = 'N.A.';
        obj.Customer_Prime_Remote_Jobview_Setup_Date__c = System.now();
        obj.Customer_Prime_Remote_Jobview_Setup__c = 'Done';

        obj.DRW_Date__c = System.now();
        obj.DRW__c = 'Not Ready';
        obj.Error_Message_Oracle_DB__c = '';
        obj.First_Sync_with_Oracle__c = false;
        obj.Foundry_Frame_Mockup_Date__c = System.now();
        obj.Foundry_Frame_Mockup__c = 'N.A.';
        obj.Foundry_Frame_Remote_Jobview_Setup_Date__c = System.now();
        obj.Foundry_Frame_Remote_Jobview_Setup__c = 'Done';
        obj.Foundry_GDSOUT_Review_Date__c = System.now();
        obj.Foundry_GDSOUT_Review__c = 'N.A.';
        obj.Foundry_MEBES_Jobview_Date__c = System.now();
        obj.Foundry_MEBES_Jobview__c = 'N.A.';
        obj.Foundry_Prime_Remote_Jobview_Setup_Date__c = System.now();
        obj.Foundry_Prime_Remote_Jobview_Setup__c = 'Done';
        obj.Frame_MEBES_Received_Date__c = System.now();
        obj.Frame_MEBES_Received__c = 'Not Done';

        obj.GlobalShuttle_MEBES_Jobview_Date__c = System.now();
        obj.GlobalShuttle_MEBES_Jobview__c = 'Not Ready';

        obj.Layer_Chip_Status__c = 'N.A.';

        obj.MDP_MEBES_Jobview_Date__c = System.now();
        obj.MDP_MEBES_Jobview__c = 'N.A.';

        obj.ORC_Date__c = System.now();
        obj.ORC__c = 'Done';
        obj.Prime_MEBES_Received_Date__c = System.now();
        obj.Prime_MEBES_Received__c = 'Not Done';

        obj.Send_Frame_Data_Date__c = System.now();
        obj.Send_Frame_Data__c = 'Not Done';
        obj.Send_Prime_Data_Date__c = System.now();
        obj.Send_Prime_Data__c = 'Not Done';
        obj.Tapeout_Applications_MEBES_Jobview_Date__c = System.now();
        obj.Tapeout_Applications_MEBES_Jobview__c = 'Not Ready';
        obj.Tapeout_Centre_MEBES_Jobview_Date__c = System.now();
        obj.Tapeout_Centre_MEBES_Jobview__c = 'N.A.';

        obj.TDTI_MPW_MEBES_Jobview__c = 'Not Ready';
        obj.Tech_Geo__c = '0.02UM';
        obj.PTRF_Or_DRT__c = 'PTRF';


        //insert obj;
        System.assertnotEquals(null, obj);
        return obj;
    }
    
    static testMethod void testDummyMethod() {
        Test.startTest();
        Account objAccount = [Select Id, name from Account where name='Test Account 009'];
        Mask_Set_Title__c objMST = [Select Id, name from Mask_Set_Title__c where name = 'MST1001'];

        MRS_Layer_Summary_Refresh_Interval__c refreshInterval = new MRS_Layer_Summary_Refresh_Interval__c(Page_Refresh_Frequency__c = 50,Name = 'LayerSummaryInterval');
        insert refreshInterval;
        List <MRS_Layer_Association__c> layerSummary = [select name, Layer_Status__c, ID from MRS_Layer_Association__c];
        ApexPages.StandardController appSc = new ApexPages.StandardController(layerSummary[0]);
        ApexPages.currentPage().getParameters().put('id', layerSummary[0].Id);
        ApexPages.currentPage().getParameters().put('customerid', objAccount.Id);
        ApexPages.currentPage().getParameters().put('mstid', objMST.Id);
        ApexPages.currentPage().getHeaders().put('Host', system.Label.SWIFT_Community_URL);
        MRSLayerChipSummaryExtn objMRSLayerChipAssocExtn = new MRSLayerChipSummaryExtn(appSc);
        //Integer a = objMRSLayerChipAssocExtn.mthdDummy();
        //System.assertEquals(1, a);
        Test.stopTest();
    }
}