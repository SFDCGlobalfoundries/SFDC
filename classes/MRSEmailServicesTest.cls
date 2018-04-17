/*
Type Name: MRSEmailServicesTest
Author: Cognizant 
Created Date: 02-June-2014
Reason: 
Change History:
Modified Date: 
Reason: 
Author: Cognizant Technology Solutions
Modified Date:
??..
??..
*/
@istest(SeeAllData = false)
public class MRSEmailServicesTest {

    /**
    This method initialize data using throughout this test class.
    The create data method are: 
    - SwiftDataUtilityTest.customSystemData();
    @author     SWIFT TEAM
    @since      7-April-2015
    */
@testSetup static void setup() {
        SwiftDataUtilityTest.customSystemData();
    }


    /**
        @Method:emailsentReminderNotificationForFrameMockup
        @param: null
        @return: void
        @Description : This method will cover the code coverage for frame mockup  Review Block of Reminder Notification when it gets approved
    **/
    public static testmethod void emailsentReminderNotificationForFrameMockup() {
        /** Test started **/
        User sysAdminUser = [SELECT Id, Name FROM User WHERE Profile.Name = 'System Administrator'
        AND isActive = true].get(0);
        Profile sysAdminProfile = [SELECT Id FROM Profile WHERE Name = 'System Administrator'];
        User userSA = new User(alias = 'testMRS', email = 'testMRS@test.com',
        emailencodingkey = 'UTF-8', lastname = 'testMRSLast', firstname = 'testMRSFirst', languagelocalekey = 'en_US',
        localesidkey = 'en_US', profileid = sysAdminProfile.Id,
        timezonesidkey = 'America/Los_Angeles', username = 'testMRS@test.com', communitynickname = 'testMRS', isActive = true);
        insert userSA;
        Group groupTA = [select Id, DeveloperName, Name from Group where DeveloperName = 'Swift_Tapeout_Application'];
        Group groupTC = [select Id, DeveloperName, Name from Group where DeveloperName = 'Swift_Tapeout_Centre'];
        Group groupTMPW = [select Id, DeveloperName, Name from Group where DeveloperName = 'Swift_TDTI_MPW'];
        Group groupMDP = [select Id, DeveloperName, Name from Group where DeveloperName = 'Swift_MDP'];
        Group groupGS = [select Id, DeveloperName, Name from Group where DeveloperName = 'Swift_GlobalShuttle'];
        List < GroupMember > listGM = new List < GroupMember > ();
        GroupMember groupMemberTA = new GroupMember(GroupId = groupTA.Id, UserOrGroupId = userSA.Id);
        GroupMember groupMemberTC = new GroupMember(GroupId = groupTC.Id, UserOrGroupId = userSA.Id);
        GroupMember groupMemberTMPW = new GroupMember(GroupId = groupTMPW.Id, UserOrGroupId = userSA.Id);
        GroupMember groupMemberTMDP = new GroupMember(GroupId = groupMDP.Id, UserOrGroupId = userSA.Id);
        GroupMember groupMemberGS = new GroupMember(GroupId = groupGS.Id, UserOrGroupId = userSA.Id);
        listGM.add(groupMemberTA);
        listGM.add(groupMemberTC);
        listGM.add(groupMemberTMPW);
        listGM.add(groupMemberTMDP);
        listGM.add(groupMemberGS);
        insert listGM;

        System.runAs(sysAdminUser) {
            // comment-out, refactor with testSetup method setup()
            // SwiftDataUtilityTest.customSystemData();
            Account acc = SwiftDataUtilityTest.createTestAccount();
            Account_Team_Proxy__c atp = new Account_Team_Proxy__c(User__c = userSA.id, Account__c = acc.id, Account_Access__c = 'Read/Write',
            Opportunity_Access__c = 'Read/Write', Team_Role__c = 'Primary Customer Service Rep', Sequence_No__c = '1', Account_Role_ID__c = 'test1239');
            insert atp;
            Mask_Set_Title__c objMST = SwiftDataUtilityTest.createMST('MST001');
            insert objMST;
            PTRF__c objPTRF = new PTRF__c(Name = 'PTRF1', Order_Type__c = 'Test Order Type', Recticle_Type__c = 'Single Layer Reticle (SLR)', MaskSetTitle__c = objMST.Id, Customer__c = acc.id);
            insert objPTRF;
            List < PTRF_JobViewer_Info__c > listPTRFJVI = new List < PTRF_JobViewer_Info__c > ();
            PTRF_JobViewer_Info__c objPTRFJVC = new PTRF_JobViewer_Info__c(Name = 'SAC', PTRF__c = objPTRF.Id, Jobview__c = 'Customer', Jobview_Type__c = 'Frame Mockup;Prime GDSOUT Review;MEBES Jobview', User__c = userSA.Id);
            PTRF_JobViewer_Info__c objPTRFJVF = new PTRF_JobViewer_Info__c(Name = 'SAF', PTRF__c = objPTRF.Id, Jobview__c = 'Foundry', Jobview_Type__c = 'Frame Mockup;Prime GDSOUT Review;MEBES Jobview', User__c = userSA.Id);
            listPTRFJVI.add(objPTRFJVC);
            listPTRFJVI.add(objPTRFJVF);
            insert listPTRFJVI;
            MRS__c objMRS = new MRS__c(Mask_Set_Title__c = objMST.Id);
            insert objMRS;
            List < MRS_Layer_Association__c > listMRSLA = new List < MRS_Layer_Association__c > ();
            MRS_Layer_Association__c objMRSLA1 = new MRS_Layer_Association__c(MRS__c = objMRS.Id, Layer_Status__c = 'Ready', Name = 'RX', Mask_Layer_Rev__c = 'AZ', ROM_Code__c = '123');
            MRS_Layer_Association__c objMRSLA2 = new MRS_Layer_Association__c(MRS__c = objMRS.Id, Layer_Status__c = 'Ready', Name = 'RY', Mask_Layer_Rev__c = 'AZ', ROM_Code__c = '123');
            listMRSLA.add(objMRSLA1);
            listMRSLA.add(objMRSLA2);
            insert listMRSLA;
            List < MRS_Chip_Details__c > listMRSCD = new List < MRS_Chip_Details__c > ();
            MRS_Chip_Details__c objMRSCD1 = new MRS_Chip_Details__c(MRS__c = objMRS.Id, Name = 'Chip001');
            MRS_Chip_Details__c objMRSCD2 = new MRS_Chip_Details__c(MRS__c = objMRS.Id, Name = 'Chip002');
            MRS_Chip_Details__c objMRSCD3 = new MRS_Chip_Details__c(MRS__c = objMRS.Id, Name = 'Frame');
            listMRSCD.add(objMRSCD1);
            listMRSCD.add(objMRSCD2);
            listMRSCD.add(objMRSCD3);
            insert listMRSCD;
            List < MRS_Layer_Chip_Association__c > listMRSLCA = new List < MRS_Layer_Chip_Association__c > ();
            MRS_Layer_Chip_Association__c objMRSLCA1 = new MRS_Layer_Chip_Association__c(Layer__c = objMRSLA1.Id, Chip__c = objMRSCD1.Id, PTRF__c = objPTRF.Id, Tech_Geo__c = '0.019UM', Foundry_Frame_Mockup__c = 'Ready', Customer_Frame_Mockup__c = 'Ready');
            MRS_Layer_Chip_Association__c objMRSLCA2 = new MRS_Layer_Chip_Association__c(Layer__c = objMRSLA1.Id, Chip__c = objMRSCD2.Id, PTRF__c = objPTRF.Id, Tech_Geo__c = '0.019UM', Foundry_Frame_Mockup__c = 'Ready', Customer_Frame_Mockup__c = 'Ready');
            MRS_Layer_Chip_Association__c objMRSLCA3 = new MRS_Layer_Chip_Association__c(Layer__c = objMRSLA2.Id, Chip__c = objMRSCD1.Id, PTRF__c = objPTRF.Id, Tech_Geo__c = '0.019UM', Foundry_Frame_Mockup__c = 'Ready', Customer_Frame_Mockup__c = 'Ready');
            MRS_Layer_Chip_Association__c objMRSLCA4 = new MRS_Layer_Chip_Association__c(Layer__c = objMRSLA2.Id, Chip__c = objMRSCD2.Id, PTRF__c = objPTRF.Id, Tech_Geo__c = '0.019UM', Foundry_Frame_Mockup__c = 'Ready', Customer_Frame_Mockup__c = 'Ready');
            MRS_Layer_Chip_Association__c objMRSLCA5 = new MRS_Layer_Chip_Association__c(Layer__c = objMRSLA1.Id, Chip__c = objMRSCD3.Id, PTRF__c = objPTRF.Id, Tech_Geo__c = '0.019UM', Foundry_Frame_Mockup__c = 'Ready', Customer_Frame_Mockup__c = 'Ready');
            MRS_Layer_Chip_Association__c objMRSLCA6 = new MRS_Layer_Chip_Association__c(Layer__c = objMRSLA2.Id, Chip__c = objMRSCD3.Id, PTRF__c = objPTRF.Id, Tech_Geo__c = '0.019UM', Foundry_Frame_Mockup__c = 'Ready', Customer_Frame_Mockup__c = 'Ready');
            listMRSLCA.add(objMRSLCA1);
            listMRSLCA.add(objMRSLCA2);
            listMRSLCA.add(objMRSLCA3);
            listMRSLCA.add(objMRSLCA4);
            listMRSLCA.add(objMRSLCA5);
            listMRSLCA.add(objMRSLCA6);
            insert listMRSLCA;
            Messaging.InboundEmail email = new Messaging.InboundEmail();
            Messaging.InboundEnvelope env = new Messaging.InboundEnvelope();
            email.fromaddress = 'testMRS@test.com';
            email.fromname = 'testMRS';
            email.subject = 'Reminder Notification: Device ' + 'MST001' + ' : Gating Frame Mockup review for layer(s)' + 'RX';
            email.plainTextBody = 'Approved Mask Set Title: ' + 'MST001 \n' + +'PTRF Number: ' + 'PTRF1' + ' \n' + +'________________________________________ \n' + +' Dear Sir/Madam, \n' + +'Please be informed the following frame mockup is ready for your gating review \n' + +'Chip Name:' + 'Chip001' + ' layer(s) ' + 'RX' + +'Please approve in MRS system once the data is good to proceed tapeout. \n' + +'type=Customer&' + +'You can also approve by replying to this message with the text ?Approved? \n' + +'Thank you. \n' + +'This is a system generated message, please do not reply. \n' + +'Best Regards. ';
            Test.startTest();
            MRSEmailServices mrsEmailServicesObj = new MRSEmailServices();
            mrsEmailServicesObj.handleInboundEmail(email, env);
            System.assertNotEquals(email.plainTextBody, null);
            email.plainTextBody = 'Approved Mask Set Title: ' + 'MST001' + ' \n' + +'PTRF Number: ' + 'PTRF1' + ' \n' + +'________________________________________ \n' + +' Dear Sir/Madam, \n' + +'Please be informed the following frame mockup is ready for your gating review \n' + +'Chip Name:' + 'Chip001' + ' layer(s) ' + 'RX' + +'Please approve in MRS system once the data is good to proceed tapeout. \n' + +'type=Foundry&' + +'You can also approve by replying to this message with the text ?Approved? \n' + +'Thank you. \n' + +'This is a system generated message, please do not reply. \n' + +'Best Regards. ';
            mrsEmailServicesObj.handleInboundEmail(email, env);
            email.plainTextBody = 'Approved Mask Set Title: ' + 'MST001' + ' \n' + +'PTRF Number: ' + 'PTRF1' + ' \n' + +' Dear Sir/Madam, ' + +'Please be informed the following frame mockup is ready for your gating review ' + +'Chip Name:' + 'Chip001' + ' layer(s) ' + 'RX' + 'PTRF Number: ' + 'PTRF1' + ' \n' + +'Please approve in MRS system once the data is good to proceed tapeout. ' + +'type=Customer&' + +'You can also approve by replying to this message with the text ?Approved? ' + +'Thank you. ' + +'This is a system generated message, please do not reply. ' + +'Best Regards. ';
            mrsEmailServicesObj.handleInboundEmail(email, env);
            //System.assertEquals(mrsEmailServicesObj.frameMockupFlag,false);
            Set < String > layerNameSt = new Set < String > {
                'RX'
            };
            Set < String > maskRevSt = new Set < String > {
                'AZ'
            };
            Set < String > romCodeSt = new Set < String > {
                '123'
            };
            mrsEmailServicesObj.approveChipsForReviewerNotification(email.plainTextBody, email.fromaddress, 'PTRF1', 'MST001', 'Approve', true, '');

            Test.stopTest();

            /** Test ended **/
        }
    }
    /**
        @Method:emailsentReminderNotificationForMEBES
        @param: null
        @return: void
        @Description : This method will cover the code coverage for MEBES Jobview Block of Reminder Notification when it gets released
    **/
    public static testmethod void emailsentReminderNotificationForMEBES() {

        /** Test started **/
        User sysAdminUser = [SELECT Id, Name FROM User WHERE Profile.Name = 'System Administrator'
        AND isActive = true].get(0);
        Profile sysAdminProfile = [SELECT Id FROM Profile WHERE Name = 'System Administrator'];
        list < User > listUser = new list < User > ();
        User userSA = new User(alias = 'testMRS', email = 'testMRS@test.com',
        emailencodingkey = 'UTF-8', lastname = 'testMRSLast', firstname = 'testMRSFirst', languagelocalekey = 'en_US',
        localesidkey = 'en_US', profileid = sysAdminProfile.Id,
        timezonesidkey = 'America/Los_Angeles', username = 'testMRS@test.com', communitynickname = 'testMRS', isActive = true);
        User userSA2 = new User(alias = 'testMRS2', email = 'testMRS2@test.com',
        emailencodingkey = 'UTF-8', lastname = 'testMRSLast2', firstname = 'testMRSFirst2', languagelocalekey = 'en_US',
        localesidkey = 'en_US', profileid = sysAdminProfile.Id,
        timezonesidkey = 'America/Los_Angeles', username = 'testMRS2@test.com', communitynickname = 'testMRS2', isActive = true);
        User userSA3 = new User(alias = 'testMRS3', email = 'testMRS3@test.com',
        emailencodingkey = 'UTF-8', lastname = 'testMRSLast3', firstname = 'testMRSFirst3', languagelocalekey = 'en_US',
        localesidkey = 'en_US', profileid = sysAdminProfile.Id,
        timezonesidkey = 'America/Los_Angeles', username = 'testMRS3@test.com', communitynickname = 'testMRS3', isActive = true);
        listUser.add(userSA);
        listUser.add(userSA2);
        listUser.add(userSA3);
        insert listUser;
        Group groupTA = [select Id, DeveloperName, Name from Group where DeveloperName = 'Swift_Tapeout_Application'];
        Group groupTC = [select Id, DeveloperName, Name from Group where DeveloperName = 'Swift_Tapeout_Centre'];
        Group groupTMPW = [select Id, DeveloperName, Name from Group where DeveloperName = 'Swift_TDTI_MPW'];
        Group groupMDP = [select Id, DeveloperName, Name from Group where DeveloperName = 'Swift_MDP'];
        Group groupGS = [select Id, DeveloperName, Name from Group where DeveloperName = 'Swift_GlobalShuttle'];
        List < GroupMember > listGM = new List < GroupMember > ();
        GroupMember groupMemberTA = new GroupMember(GroupId = groupTA.Id, UserOrGroupId = userSA2.Id);
        GroupMember groupMemberTC = new GroupMember(GroupId = groupTC.Id, UserOrGroupId = userSA2.Id);
        GroupMember groupMemberTMPW = new GroupMember(GroupId = groupTMPW.Id, UserOrGroupId = userSA2.Id);
        GroupMember groupMemberTMDP = new GroupMember(GroupId = groupMDP.Id, UserOrGroupId = userSA2.Id);
        GroupMember groupMemberGS = new GroupMember(GroupId = groupGS.Id, UserOrGroupId = userSA2.Id);
        listGM.add(groupMemberTA);
        listGM.add(groupMemberTC);
        listGM.add(groupMemberTMPW);
        listGM.add(groupMemberTMDP);
        listGM.add(groupMemberGS);
        insert listGM;

        System.runAs(sysAdminUser) {
            // comment-out, refactor with testSetup method setup()
            // SwiftDataUtilityTest.customSystemData();
            Account acc = SwiftDataUtilityTest.createTestAccount();
            Account_Team_Proxy__c atp = new Account_Team_Proxy__c(User__c = userSA.id, Account__c = acc.id, Account_Access__c = 'Read/Write',
            Opportunity_Access__c = 'Read/Write', Team_Role__c = 'Primary Customer Service Rep', Sequence_No__c = '1', Account_Role_ID__c = 'test1239');
            insert atp;
            Mask_Set_Title__c objMST = SwiftDataUtilityTest.createMST('MST001');
            insert objMST;
            PTRF__c objPTRF = new PTRF__c(Name = 'PTRF1', Order_Type__c = 'Test Order Type', Recticle_Type__c = 'Single Layer Reticle (SLR)', MaskSetTitle__c = objMST.Id, Customer__c = acc.id, Tech_Geo_Value__c = '0.019');
            insert objPTRF;
            List < PTRF_JobViewer_Info__c > listPTRFJVI = new List < PTRF_JobViewer_Info__c > ();
            PTRF_JobViewer_Info__c objPTRFJVC = new PTRF_JobViewer_Info__c(Name = 'SAC', PTRF__c = objPTRF.Id, Jobview__c = 'Customer', Jobview_Type__c = 'Frame Mockup;Prime GDSOUT Review;MEBES Jobview', User__c = userSA.Id);
            PTRF_JobViewer_Info__c objPTRFJVF = new PTRF_JobViewer_Info__c(Name = 'SAF', PTRF__c = objPTRF.Id, Jobview__c = 'Foundry', Jobview_Type__c = 'Frame Mockup;Prime GDSOUT Review;MEBES Jobview', User__c = userSA.Id);
            PTRF_JobViewer_Info__c objPTRFJVSA2F = new PTRF_JobViewer_Info__c(Name = 'SACust', PTRF__c = objPTRF.Id, Jobview__c = 'Foundry', Jobview_Type__c = 'Frame Mockup;Prime GDSOUT Review;MEBES Jobview', User__c = userSA3.Id);
            listPTRFJVI.add(objPTRFJVC);
            listPTRFJVI.add(objPTRFJVF);
            listPTRFJVI.add(objPTRFJVSA2F);
            insert listPTRFJVI;
            MRS__c objMRS = new MRS__c(Mask_Set_Title__c = objMST.Id);
            insert objMRS;
            String maskSetTitleId = String.valueOf(objMST.Id).substring(0, 15);
            List < MRS_Layer_Association__c > listMRSLA = new List < MRS_Layer_Association__c > ();
            MRS_Layer_Association__c objMRSLA1 = new MRS_Layer_Association__c(MRS__c = objMRS.Id, Layer_Status__c = 'Ready', Name = 'RX', Mask_Layer_Rev__c = 'AZ', ROM_Code__c = '123');
            MRS_Layer_Association__c objMRSLA2 = new MRS_Layer_Association__c(MRS__c = objMRS.Id, Layer_Status__c = 'Ready', Name = 'RY', Mask_Layer_Rev__c = 'AZ', ROM_Code__c = null);
            listMRSLA.add(objMRSLA1);
            listMRSLA.add(objMRSLA2);
            insert listMRSLA;
            List < MRS_Chip_Details__c > listMRSCD = new List < MRS_Chip_Details__c > ();
            MRS_Chip_Details__c objMRSCD1 = new MRS_Chip_Details__c(MRS__c = objMRS.Id, Name = 'Chip001');
            MRS_Chip_Details__c objMRSCD2 = new MRS_Chip_Details__c(MRS__c = objMRS.Id, Name = 'Chip002');
            MRS_Chip_Details__c objMRSCD3 = new MRS_Chip_Details__c(MRS__c = objMRS.Id, Name = 'Frame');
            listMRSCD.add(objMRSCD1);
            listMRSCD.add(objMRSCD2);
            listMRSCD.add(objMRSCD3);
            insert listMRSCD;
            List < MRS_Layer_Chip_Association__c > listMRSLCA = new List < MRS_Layer_Chip_Association__c > ();
            MRS_Layer_Chip_Association__c objMRSLCA1 = new MRS_Layer_Chip_Association__c(Layer__c = objMRSLA1.Id, Chip__c = objMRSCD1.Id, PTRF__c = objPTRF.Id, Tech_Geo__c = '0.019UM', Tapeout_Applications_MEBES_Jobview__c = 'Ready', Tapeout_Centre_MEBES_Jobview__c = 'Ready', TDTI_MPW_MEBES_Jobview__c = 'Ready', MDP_MEBES_Jobview__c = 'Ready', GlobalShuttle_MEBES_Jobview__c = 'Ready', Customer_MEBES_Jobview__c = 'Ready', Foundry_MEBES_Jobview__c = 'Ready', Mask_Set_Title_Id__c = maskSetTitleId);
            MRS_Layer_Chip_Association__c objMRSLCA2 = new MRS_Layer_Chip_Association__c(Layer__c = objMRSLA1.Id, Chip__c = objMRSCD2.Id, PTRF__c = objPTRF.Id, Tech_Geo__c = '0.019UM', Tapeout_Applications_MEBES_Jobview__c = 'Ready', Tapeout_Centre_MEBES_Jobview__c = 'Ready', TDTI_MPW_MEBES_Jobview__c = 'Ready', MDP_MEBES_Jobview__c = 'Ready', GlobalShuttle_MEBES_Jobview__c = 'Ready', Customer_MEBES_Jobview__c = 'Ready', Foundry_MEBES_Jobview__c = 'Ready', Mask_Set_Title_Id__c = maskSetTitleId);
            MRS_Layer_Chip_Association__c objMRSLCA3 = new MRS_Layer_Chip_Association__c(Layer__c = objMRSLA2.Id, Chip__c = objMRSCD1.Id, PTRF__c = objPTRF.Id, Tech_Geo__c = '0.019UM', Tapeout_Applications_MEBES_Jobview__c = 'Ready', Tapeout_Centre_MEBES_Jobview__c = 'Ready', TDTI_MPW_MEBES_Jobview__c = 'Ready', MDP_MEBES_Jobview__c = 'Ready', GlobalShuttle_MEBES_Jobview__c = 'Ready', Customer_MEBES_Jobview__c = 'Ready', Foundry_MEBES_Jobview__c = 'Ready', Mask_Set_Title_Id__c = maskSetTitleId);
            MRS_Layer_Chip_Association__c objMRSLCA4 = new MRS_Layer_Chip_Association__c(Layer__c = objMRSLA2.Id, Chip__c = objMRSCD2.Id, PTRF__c = objPTRF.Id, Tech_Geo__c = '0.019UM', Tapeout_Applications_MEBES_Jobview__c = 'Ready', Tapeout_Centre_MEBES_Jobview__c = 'Ready', TDTI_MPW_MEBES_Jobview__c = 'Ready', MDP_MEBES_Jobview__c = 'Ready', GlobalShuttle_MEBES_Jobview__c = 'Ready', Customer_MEBES_Jobview__c = 'Ready', Foundry_MEBES_Jobview__c = 'Ready', Mask_Set_Title_Id__c = maskSetTitleId);
            MRS_Layer_Chip_Association__c objMRSLCA5 = new MRS_Layer_Chip_Association__c(Layer__c = objMRSLA1.Id, Chip__c = objMRSCD3.Id, PTRF__c = objPTRF.Id, Tech_Geo__c = '0.019UM', Tapeout_Applications_MEBES_Jobview__c = 'Ready', Tapeout_Centre_MEBES_Jobview__c = 'Ready', TDTI_MPW_MEBES_Jobview__c = 'Ready', MDP_MEBES_Jobview__c = 'Ready', GlobalShuttle_MEBES_Jobview__c = 'Ready', Customer_MEBES_Jobview__c = 'Ready', Foundry_MEBES_Jobview__c = 'Ready', Mask_Set_Title_Id__c = maskSetTitleId);
            MRS_Layer_Chip_Association__c objMRSLCA6 = new MRS_Layer_Chip_Association__c(Layer__c = objMRSLA2.Id, Chip__c = objMRSCD3.Id, PTRF__c = objPTRF.Id, Tech_Geo__c = '0.019UM', Tapeout_Applications_MEBES_Jobview__c = 'Ready', Tapeout_Centre_MEBES_Jobview__c = 'Ready', TDTI_MPW_MEBES_Jobview__c = 'Ready', MDP_MEBES_Jobview__c = 'Ready', GlobalShuttle_MEBES_Jobview__c = 'Ready', Customer_MEBES_Jobview__c = 'Ready', Foundry_MEBES_Jobview__c = 'Ready', Mask_Set_Title_Id__c = maskSetTitleId);
            listMRSLCA.add(objMRSLCA1);
            listMRSLCA.add(objMRSLCA2);
            listMRSLCA.add(objMRSLCA3);
            listMRSLCA.add(objMRSLCA4);
            listMRSLCA.add(objMRSLCA5);
            listMRSLCA.add(objMRSLCA6);
            insert listMRSLCA;

            Messaging.InboundEmail email = new Messaging.InboundEmail();
            Messaging.InboundEnvelope env = new Messaging.InboundEnvelope();
            email.fromaddress = 'testMRS@test.com';
            email.fromname = 'testMRS';
            MRSEmailServices mrsEmailServicesObj = new MRSEmailServices();
            Test.startTest();
            email.subject = 'Reminder Notification: Device ' + 'MST001' + ' : Gating Customer MEBES jobview for layer(s)' + 'RX';
            email.plainTextBody = 'Approved Mask Set Title: ' + 'MST001' + ' \n' + +'________________________________________ \n' + +' Dear Sir/Madam, \n' + +'Please be informed the following MEBES is ready for your gating review \n' + +'Chip Name:' + 'Chip002' + ' layer(s) ' + 'RXAZ' + 'PTRF Number: ' + 'PTRF1' + ' \n' + +'<Email Content from CAD Systems> \n' + +'jobview=Customer&' + +'Please approve in MRS system once the data is good to proceed tapeout. \n' + +'You can also approve by replying to this message with the text ?Approved? \n' + +'Thank you. \n' + +'This is a system generated message, please do not reply. \n' + +'Best Regards. ';
            mrsEmailServicesObj.handleInboundEmail(email, env);
            email.fromaddress = 'testMRS3@test.com';
            email.fromname = 'testMRS3';

            email.subject = 'Reminder Notification: Device ' + 'MST001' + ' : Gating Foundry MEBES jobview for layer(s)' + 'RX';
            email.plainTextBody = 'Approved Mask Set Title: ' + 'MST001' + ' \n' + +'________________________________________ \n' + +' Dear Sir/Madam, \n' + +'Please be informed the following MEBES is ready for your gating review \n' + +'Chip Name:' + 'Chip002' + ' layer(s) ' + 'RXAZ' + 'PTRF Number: ' + 'PTRF1' + ' \n' + +'<Email Content from CAD Systems> \n' + +'jobview=Foundry&' + +'Please approve in MRS system once the data is good to proceed tapeout. \n' + +'You can also approve by replying to this message with the text ?Approved? \n' + +'Thank you. \n' + +'This is a system generated message, please do not reply. \n' + +'Best Regards. ';
            mrsEmailServicesObj.handleInboundEmail(email, env);
            email.fromaddress = 'testMRS2@test.com';
            email.fromname = 'testMRS2';

            email.subject = 'Reminder Notification: Device ' + 'MST001' + ' : Gating TAPEOUT CENTER MEBES jobview for layer(s)' + 'RX';
            email.plainTextBody = 'Approved Mask Set Title: ' + 'MST001' + ' \n' + +'________________________________________ \n' + +' Dear Sir/Madam, \n' + +'Please be informed the following MEBES is ready for your gating review \n' + +'Chip Name:' + 'Chip002' + ' layer(s) ' + 'RXAZ' + 'PTRF Number: ' + 'PTRF1' + ' \n' + +'<Email Content from CAD Systems> \n' + +'jobview=tapeoutcentre&' + +'Please approve in MRS system once the data is good to proceed tapeout. \n' + +'You can also approve by replying to this message with the text ?Approved? \n' + +'Thank you. \n' + +'This is a system generated message, please do not reply. \n' + +'Best Regards. ';
            mrsEmailServicesObj.handleInboundEmail(email, env);
            email.fromaddress = 'testMRS2@test.com';
            email.fromname = 'testMRS2';
            email.subject = 'Reminder Notification: Device ' + 'MST001' + ' : Gating TAPEOUT APPLICATION MEBES jobview for layer(s)' + 'RX';
            email.plainTextBody = 'Approved Mask Set Title: ' + 'MST001' + ' \n' + +'________________________________________ \n' + +' Dear Sir/Madam, \n' + +'Please be informed the following MEBES is ready for your gating review \n' + +'Chip Name:' + 'Chip002' + ' layer(s) ' + 'RXAZ' + 'PTRF Number: ' + 'PTRF1' + ' \n' + +'<Email Content from CAD Systems> \n' + +'jobview=tapeoutapp&' + +'Please approve in MRS system once the data is good to proceed tapeout. \n' + +'You can also approve by replying to this message with the text ?Approved? \n' + +'Thank you. \n' + +'This is a system generated message, please do not reply. \n' + +'Best Regards. ';
            mrsEmailServicesObj.handleInboundEmail(email, env);
            email.fromaddress = 'testMRS2@test.com';
            email.fromname = 'testMRS2';
            email.subject = 'Reminder Notification: Device ' + 'MST001' + ' : Gating GLOBALSHUTTLE MEBES jobview for layer(s)' + 'RX';
            email.plainTextBody = 'Approved Mask Set Title: ' + 'MST001' + ' \n' + +'________________________________________ \n' + +' Dear Sir/Madam, \n' + +'Please be informed the following MEBES is ready for your gating review \n' + +'Chip Name:' + 'Chip002' + ' layer(s) ' + 'RXAZ' + 'PTRF Number: ' + 'PTRF1' + ' \n' + +'<Email Content from CAD Systems> \n' + +'jobview=globalshuttle&' + +'Please approve in MRS system once the data is good to proceed tapeout. \n' + +'You can also approve by replying to this message with the text ?Approved? \n' + +'Thank you. \n' + +'This is a system generated message, please do not reply. \n' + +'Best Regards. ';
            mrsEmailServicesObj.handleInboundEmail(email, env);


            Test.stopTest();

            /** Test ended **/
        }

    }
    /**
        @Method:emailForDisapproveReminderNotification
        @param: null
        @return: void
        @Description : This method will cover the code coverage for frame mockup Block of Reminder Notification when it gets disapproved
    **/
    public static testmethod void emailForDisapproveReminderNotification() {

        /** Test started **/
        User sysAdminUser = [SELECT Id, Name FROM User WHERE Profile.Name = 'System Administrator'
        AND isActive = true].get(0);
        Profile sysAdminProfile = [SELECT Id FROM Profile WHERE Name = 'System Administrator'];
        User userSA = new User(alias = 'testMRS', email = 'testMRS@test.com',
        emailencodingkey = 'UTF-8', lastname = 'testMRSLast', firstname = 'testMRSFirst', languagelocalekey = 'en_US',
        localesidkey = 'en_US', profileid = sysAdminProfile.Id,
        timezonesidkey = 'America/Los_Angeles', username = 'testMRS@test.com', communitynickname = 'testMRS', isActive = true);
        insert userSA;
        Group groupTA = [select Id, DeveloperName, Name from Group where DeveloperName = 'Swift_Tapeout_Application'];
        Group groupTC = [select Id, DeveloperName, Name from Group where DeveloperName = 'Swift_Tapeout_Centre'];
        Group groupTMPW = [select Id, DeveloperName, Name from Group where DeveloperName = 'Swift_TDTI_MPW'];
        Group groupMDP = [select Id, DeveloperName, Name from Group where DeveloperName = 'Swift_MDP'];
        Group groupGS = [select Id, DeveloperName, Name from Group where DeveloperName = 'Swift_GlobalShuttle'];
        List < GroupMember > listGM = new List < GroupMember > ();
        GroupMember groupMemberTA = new GroupMember(GroupId = groupTA.Id, UserOrGroupId = userSA.Id);
        GroupMember groupMemberTC = new GroupMember(GroupId = groupTC.Id, UserOrGroupId = userSA.Id);
        GroupMember groupMemberTMPW = new GroupMember(GroupId = groupTMPW.Id, UserOrGroupId = userSA.Id);
        GroupMember groupMemberTMDP = new GroupMember(GroupId = groupMDP.Id, UserOrGroupId = userSA.Id);
        GroupMember groupMemberGS = new GroupMember(GroupId = groupGS.Id, UserOrGroupId = userSA.Id);
        listGM.add(groupMemberTA);
        listGM.add(groupMemberTC);
        listGM.add(groupMemberTMPW);
        listGM.add(groupMemberTMDP);
        listGM.add(groupMemberGS);
        insert listGM;

        System.runAs(sysAdminUser) {
            // comment-out, refactor with testSetup method setup()
            // SwiftDataUtilityTest.customSystemData();
            Account acc = SwiftDataUtilityTest.createTestAccount();
            Account_Team_Proxy__c atp = new Account_Team_Proxy__c(User__c = userSA.id, Account__c = acc.id, Account_Access__c = 'Read/Write',
            Opportunity_Access__c = 'Read/Write', Team_Role__c = 'Primary Customer Service Rep', Sequence_No__c = '1', Account_Role_ID__c = 'test1239');
            insert atp;
            Mask_Set_Title__c objMST = SwiftDataUtilityTest.createMST('MST001');
            insert objMST;
            PTRF__c objPTRF = new PTRF__c(Name = 'PTRF1', Order_Type__c = 'Test Order Type', Recticle_Type__c = 'Single Layer Reticle (SLR)', MaskSetTitle__c = objMST.Id, Customer__c = acc.id);
            insert objPTRF;
            List < PTRF_JobViewer_Info__c > listPTRFJVI = new List < PTRF_JobViewer_Info__c > ();
            PTRF_JobViewer_Info__c objPTRFJVC = new PTRF_JobViewer_Info__c(Name = 'SAC', PTRF__c = objPTRF.Id, Jobview__c = 'Customer', Jobview_Type__c = 'Frame Mockup;Prime GDSOUT Review;MEBES Jobview', User__c = userSA.Id);
            PTRF_JobViewer_Info__c objPTRFJVF = new PTRF_JobViewer_Info__c(Name = 'SAF', PTRF__c = objPTRF.Id, Jobview__c = 'Foundry', Jobview_Type__c = 'Frame Mockup;Prime GDSOUT Review;MEBES Jobview', User__c = userSA.Id);
            listPTRFJVI.add(objPTRFJVC);
            listPTRFJVI.add(objPTRFJVF);
            insert listPTRFJVI;
            MRS__c objMRS = new MRS__c(Mask_Set_Title__c = objMST.Id);
            insert objMRS;
            List < MRS_Layer_Association__c > listMRSLA = new List < MRS_Layer_Association__c > ();
            MRS_Layer_Association__c objMRSLA1 = new MRS_Layer_Association__c(MRS__c = objMRS.Id, Layer_Status__c = 'Ready', Name = 'RX', Mask_Layer_Rev__c = 'AZ', ROM_Code__c = '123');
            MRS_Layer_Association__c objMRSLA2 = new MRS_Layer_Association__c(MRS__c = objMRS.Id, Layer_Status__c = 'Ready', Name = 'RY', Mask_Layer_Rev__c = 'AZ', ROM_Code__c = '123');
            listMRSLA.add(objMRSLA1);
            listMRSLA.add(objMRSLA2);
            insert listMRSLA;
            List < MRS_Chip_Details__c > listMRSCD = new List < MRS_Chip_Details__c > ();
            MRS_Chip_Details__c objMRSCD1 = new MRS_Chip_Details__c(MRS__c = objMRS.Id, Name = 'Chip001');
            MRS_Chip_Details__c objMRSCD2 = new MRS_Chip_Details__c(MRS__c = objMRS.Id, Name = 'Chip002');
            MRS_Chip_Details__c objMRSCD3 = new MRS_Chip_Details__c(MRS__c = objMRS.Id, Name = 'Frame');
            listMRSCD.add(objMRSCD1);
            listMRSCD.add(objMRSCD2);
            listMRSCD.add(objMRSCD3);
            insert listMRSCD;
            List < MRS_Layer_Chip_Association__c > listMRSLCA = new List < MRS_Layer_Chip_Association__c > ();
            MRS_Layer_Chip_Association__c objMRSLCA1 = new MRS_Layer_Chip_Association__c(Layer__c = objMRSLA1.Id, Chip__c = objMRSCD1.Id, PTRF__c = objPTRF.Id, Tech_Geo__c = '0.019UM', Foundry_Frame_Mockup__c = 'Ready', Customer_Frame_Mockup__c = 'Ready');
            MRS_Layer_Chip_Association__c objMRSLCA2 = new MRS_Layer_Chip_Association__c(Layer__c = objMRSLA1.Id, Chip__c = objMRSCD2.Id, PTRF__c = objPTRF.Id, Tech_Geo__c = '0.019UM', Foundry_Frame_Mockup__c = 'Ready', Customer_Frame_Mockup__c = 'Ready');
            MRS_Layer_Chip_Association__c objMRSLCA3 = new MRS_Layer_Chip_Association__c(Layer__c = objMRSLA2.Id, Chip__c = objMRSCD1.Id, PTRF__c = objPTRF.Id, Tech_Geo__c = '0.019UM', Foundry_Frame_Mockup__c = 'Ready', Customer_Frame_Mockup__c = 'Ready');
            MRS_Layer_Chip_Association__c objMRSLCA4 = new MRS_Layer_Chip_Association__c(Layer__c = objMRSLA2.Id, Chip__c = objMRSCD2.Id, PTRF__c = objPTRF.Id, Tech_Geo__c = '0.019UM', Foundry_Frame_Mockup__c = 'Ready', Customer_Frame_Mockup__c = 'Ready');
            MRS_Layer_Chip_Association__c objMRSLCA5 = new MRS_Layer_Chip_Association__c(Layer__c = objMRSLA1.Id, Chip__c = objMRSCD3.Id, PTRF__c = objPTRF.Id, Tech_Geo__c = '0.019UM', Foundry_Frame_Mockup__c = 'Ready', Customer_Frame_Mockup__c = 'Ready');
            MRS_Layer_Chip_Association__c objMRSLCA6 = new MRS_Layer_Chip_Association__c(Layer__c = objMRSLA2.Id, Chip__c = objMRSCD3.Id, PTRF__c = objPTRF.Id, Tech_Geo__c = '0.019UM', Foundry_Frame_Mockup__c = 'Ready', Customer_Frame_Mockup__c = 'Ready');
            listMRSLCA.add(objMRSLCA1);
            listMRSLCA.add(objMRSLCA2);
            listMRSLCA.add(objMRSLCA3);
            listMRSLCA.add(objMRSLCA4);
            listMRSLCA.add(objMRSLCA5);
            listMRSLCA.add(objMRSLCA6);
            insert listMRSLCA;
            Messaging.InboundEmail email = new Messaging.InboundEmail();
            Messaging.InboundEnvelope env = new Messaging.InboundEnvelope();
            email.fromaddress = 'testMRS@test.com';
            email.fromname = 'testMRS';
            email.subject = 'Reminder Notification: Device ' + 'MST001' + ' : Gating Frame Mockup review for layer(s)' + 'RX';
            email.plainTextBody = 'Disapprove Mask Set Title: ' + 'MST001 \n' + +'PTRF Number: ' + 'PTRF1' + ' \n' + +'________________________________________ \n' + +' Dear Sir/Madam, \n' + +'Please be informed the following frame mockup is ready for your gating review \n' + +'Chip Name:' + 'Chip001' + ' layer(s) ' + 'RX' + +'Please approve in MRS system once the data is good to proceed tapeout. \n' + +'type=Customer&' + +'You can also approve by replying to this message with the text ?Approved? \n' + +'Thank you. \n' + +'This is a system generated message, please do not reply. \n' + +'Best Regards. ';
            Test.startTest();
            MRSEmailServices mrsEmailServicesObj = new MRSEmailServices();
            mrsEmailServicesObj.handleInboundEmail(email, env);
            System.assertNotEquals(email.plainTextBody, null);
            email.plainTextBody = 'Disapprove Mask Set Title: ' + 'MST001' + ' \n' + +'PTRF Number: ' + 'PTRF1' + ' \n' + +'________________________________________ \n' + +' Dear Sir/Madam, \n' + +'Please be informed the following frame mockup is ready for your gating review \n' + +'Chip Name:' + 'Chip001' + ' layer(s) ' + 'RX' + +'Please approve in MRS system once the data is good to proceed tapeout. \n' + +'type=Foundry&' + +'You can also approve by replying to this message with the text ?Approved? \n' + +'Thank you. \n' + +'This is a system generated message, please do not reply. \n' + +'Best Regards. ';
            mrsEmailServicesObj.handleInboundEmail(email, env);
            email.plainTextBody = 'Disapprove Mask Set Title: ' + 'MST001' + ' \n' + +'PTRF Number: ' + 'PTRF1' + ' \n' + +' Dear Sir/Madam, ' + +'Please be informed the following frame mockup is ready for your gating review ' + +'Chip Name:' + 'Chip001' + ' layer(s) ' + 'RX' + 'PTRF Number: ' + 'PTRF1' + ' \n' + +'Please approve in MRS system once the data is good to proceed tapeout. ' + +'type=Customer&' + +'You can also approve by replying to this message with the text ?Approved? ' + +'Thank you. ' + +'This is a system generated message, please do not reply. ' + +'Best Regards. ';
            mrsEmailServicesObj.handleInboundEmail(email, env);
            //System.assertEquals(mrsEmailServicesObj.frameMockupFlag,false);
            Set < String > layerNameSt = new Set < String > {
                'RX'
            };
            Set < String > maskRevSt = new Set < String > {
                'AZ'
            };
            Set < String > romCodeSt = new Set < String > {
                '123'
            };
            mrsEmailServicesObj.approveChipsForReviewerNotification(email.plainTextBody, email.fromaddress, 'PTRF1', 'MST001', 'Disapprove', true, '');

            Test.stopTest();

            /** Test ended **/
        }


    }
    /**
        @Method:emailForTDTIAndMDP
        @param: null
        @return: void
        @Description : This method will cover the code coverage for tdti and MDP MEBES
    **/
    public static testmethod void emailForTDTIAndMDP() {

        /** Test started **/
        User sysAdminUser = [SELECT Id, Name FROM User WHERE Profile.Name = 'System Administrator'
        AND isActive = true].get(0);
        Profile sysAdminProfile = [SELECT Id FROM Profile WHERE Name = 'System Administrator'];
        list < User > listUser = new list < User > ();
        User userSA = new User(alias = 'testMRS', email = 'testMRS@test.com',
        emailencodingkey = 'UTF-8', lastname = 'testMRSLast', firstname = 'testMRSFirst', languagelocalekey = 'en_US',
        localesidkey = 'en_US', profileid = sysAdminProfile.Id,
        timezonesidkey = 'America/Los_Angeles', username = 'testMRS@test.com', communitynickname = 'testMRS', isActive = true);
        User userSA2 = new User(alias = 'testMRS2', email = 'testMRS2@test.com',
        emailencodingkey = 'UTF-8', lastname = 'testMRSLast2', firstname = 'testMRSFirst2', languagelocalekey = 'en_US',
        localesidkey = 'en_US', profileid = sysAdminProfile.Id,
        timezonesidkey = 'America/Los_Angeles', username = 'testMRS2@test.com', communitynickname = 'testMRS2', isActive = true);
        User userSA3 = new User(alias = 'testMRS3', email = 'testMRS3@test.com',
        emailencodingkey = 'UTF-8', lastname = 'testMRSLast3', firstname = 'testMRSFirst3', languagelocalekey = 'en_US',
        localesidkey = 'en_US', profileid = sysAdminProfile.Id,
        timezonesidkey = 'America/Los_Angeles', username = 'testMRS3@test.com', communitynickname = 'testMRS3', isActive = true);
        listUser.add(userSA);
        listUser.add(userSA2);
        listUser.add(userSA3);
        insert listUser;
        Group groupTA = [select Id, DeveloperName, Name from Group where DeveloperName = 'Swift_Tapeout_Application'];
        Group groupTC = [select Id, DeveloperName, Name from Group where DeveloperName = 'Swift_Tapeout_Centre'];
        Group groupTMPW = [select Id, DeveloperName, Name from Group where DeveloperName = 'Swift_TDTI_MPW'];
        Group groupMDP = [select Id, DeveloperName, Name from Group where DeveloperName = 'Swift_MDP'];
        Group groupGS = [select Id, DeveloperName, Name from Group where DeveloperName = 'Swift_GlobalShuttle'];
        List < GroupMember > listGM = new List < GroupMember > ();
        GroupMember groupMemberTA = new GroupMember(GroupId = groupTA.Id, UserOrGroupId = userSA2.Id);
        GroupMember groupMemberTC = new GroupMember(GroupId = groupTC.Id, UserOrGroupId = userSA2.Id);
        GroupMember groupMemberTMPW = new GroupMember(GroupId = groupTMPW.Id, UserOrGroupId = userSA2.Id);
        GroupMember groupMemberTMDP = new GroupMember(GroupId = groupMDP.Id, UserOrGroupId = userSA2.Id);
        GroupMember groupMemberGS = new GroupMember(GroupId = groupGS.Id, UserOrGroupId = userSA2.Id);
        listGM.add(groupMemberTA);
        listGM.add(groupMemberTC);
        listGM.add(groupMemberTMPW);
        listGM.add(groupMemberTMDP);
        listGM.add(groupMemberGS);
        insert listGM;

        System.runAs(sysAdminUser) {
            // comment-out, refactor with testSetup method setup()
            // SwiftDataUtilityTest.customSystemData();
            Account acc = SwiftDataUtilityTest.createTestAccount();
            Account_Team_Proxy__c atp = new Account_Team_Proxy__c(User__c = userSA.id, Account__c = acc.id, Account_Access__c = 'Read/Write',
            Opportunity_Access__c = 'Read/Write', Team_Role__c = 'Primary Customer Service Rep', Sequence_No__c = '1', Account_Role_ID__c = 'test1239');
            insert atp;
            Mask_Set_Title__c objMST = SwiftDataUtilityTest.createMST('MST001');
            insert objMST;
            PTRF__c objPTRF = new PTRF__c(Name = 'PTRF1', Order_Type__c = 'Test Order Type', Recticle_Type__c = 'Single Layer Reticle (SLR)', MaskSetTitle__c = objMST.Id, Customer__c = acc.id, Tech_Geo_Value__c = '0.019');
            insert objPTRF;
            List < PTRF_JobViewer_Info__c > listPTRFJVI = new List < PTRF_JobViewer_Info__c > ();
            PTRF_JobViewer_Info__c objPTRFJVC = new PTRF_JobViewer_Info__c(Name = 'SAC', PTRF__c = objPTRF.Id, Jobview__c = 'Customer', Jobview_Type__c = 'Frame Mockup;Prime GDSOUT Review;MEBES Jobview', User__c = userSA.Id);
            PTRF_JobViewer_Info__c objPTRFJVF = new PTRF_JobViewer_Info__c(Name = 'SAF', PTRF__c = objPTRF.Id, Jobview__c = 'Foundry', Jobview_Type__c = 'Frame Mockup;Prime GDSOUT Review;MEBES Jobview', User__c = userSA.Id);
            PTRF_JobViewer_Info__c objPTRFJVSA2F = new PTRF_JobViewer_Info__c(Name = 'SACust', PTRF__c = objPTRF.Id, Jobview__c = 'Foundry', Jobview_Type__c = 'Frame Mockup;Prime GDSOUT Review;MEBES Jobview', User__c = userSA3.Id);
            listPTRFJVI.add(objPTRFJVC);
            listPTRFJVI.add(objPTRFJVF);
            listPTRFJVI.add(objPTRFJVSA2F);
            insert listPTRFJVI;
            MRS__c objMRS = new MRS__c(Mask_Set_Title__c = objMST.Id);
            insert objMRS;
            String maskSetTitleId = String.valueOf(objMST.Id).substring(0, 15);
            List < MRS_Layer_Association__c > listMRSLA = new List < MRS_Layer_Association__c > ();
            MRS_Layer_Association__c objMRSLA1 = new MRS_Layer_Association__c(MRS__c = objMRS.Id, Layer_Status__c = 'Ready', Name = 'RX', Mask_Layer_Rev__c = 'AZ', ROM_Code__c = '123');
            MRS_Layer_Association__c objMRSLA2 = new MRS_Layer_Association__c(MRS__c = objMRS.Id, Layer_Status__c = 'Ready', Name = 'RY', Mask_Layer_Rev__c = 'AZ', ROM_Code__c = null);
            listMRSLA.add(objMRSLA1);
            listMRSLA.add(objMRSLA2);
            insert listMRSLA;
            List < MRS_Chip_Details__c > listMRSCD = new List < MRS_Chip_Details__c > ();
            MRS_Chip_Details__c objMRSCD1 = new MRS_Chip_Details__c(MRS__c = objMRS.Id, Name = 'Chip001');
            MRS_Chip_Details__c objMRSCD2 = new MRS_Chip_Details__c(MRS__c = objMRS.Id, Name = 'Chip002');
            MRS_Chip_Details__c objMRSCD3 = new MRS_Chip_Details__c(MRS__c = objMRS.Id, Name = 'Frame');
            listMRSCD.add(objMRSCD1);
            listMRSCD.add(objMRSCD2);
            listMRSCD.add(objMRSCD3);
            insert listMRSCD;
            List < MRS_Layer_Chip_Association__c > listMRSLCA = new List < MRS_Layer_Chip_Association__c > ();
            MRS_Layer_Chip_Association__c objMRSLCA1 = new MRS_Layer_Chip_Association__c(Layer__c = objMRSLA1.Id, Chip__c = objMRSCD1.Id, PTRF__c = objPTRF.Id, Tech_Geo__c = '0.019UM', Tapeout_Applications_MEBES_Jobview__c = 'Ready', Tapeout_Centre_MEBES_Jobview__c = 'Ready', TDTI_MPW_MEBES_Jobview__c = 'Ready', MDP_MEBES_Jobview__c = 'Ready', GlobalShuttle_MEBES_Jobview__c = 'Ready', Customer_MEBES_Jobview__c = 'Ready', Foundry_MEBES_Jobview__c = 'Ready', Mask_Set_Title_Id__c = maskSetTitleId);
            MRS_Layer_Chip_Association__c objMRSLCA2 = new MRS_Layer_Chip_Association__c(Layer__c = objMRSLA1.Id, Chip__c = objMRSCD2.Id, PTRF__c = objPTRF.Id, Tech_Geo__c = '0.019UM', Tapeout_Applications_MEBES_Jobview__c = 'Ready', Tapeout_Centre_MEBES_Jobview__c = 'Ready', TDTI_MPW_MEBES_Jobview__c = 'Ready', MDP_MEBES_Jobview__c = 'Ready', GlobalShuttle_MEBES_Jobview__c = 'Ready', Customer_MEBES_Jobview__c = 'Ready', Foundry_MEBES_Jobview__c = 'Ready', Mask_Set_Title_Id__c = maskSetTitleId);
            MRS_Layer_Chip_Association__c objMRSLCA3 = new MRS_Layer_Chip_Association__c(Layer__c = objMRSLA2.Id, Chip__c = objMRSCD1.Id, PTRF__c = objPTRF.Id, Tech_Geo__c = '0.019UM', Tapeout_Applications_MEBES_Jobview__c = 'Ready', Tapeout_Centre_MEBES_Jobview__c = 'Ready', TDTI_MPW_MEBES_Jobview__c = 'Ready', MDP_MEBES_Jobview__c = 'Ready', GlobalShuttle_MEBES_Jobview__c = 'Ready', Customer_MEBES_Jobview__c = 'Ready', Foundry_MEBES_Jobview__c = 'Ready', Mask_Set_Title_Id__c = maskSetTitleId);
            MRS_Layer_Chip_Association__c objMRSLCA4 = new MRS_Layer_Chip_Association__c(Layer__c = objMRSLA2.Id, Chip__c = objMRSCD2.Id, PTRF__c = objPTRF.Id, Tech_Geo__c = '0.019UM', Tapeout_Applications_MEBES_Jobview__c = 'Ready', Tapeout_Centre_MEBES_Jobview__c = 'Ready', TDTI_MPW_MEBES_Jobview__c = 'Ready', MDP_MEBES_Jobview__c = 'Ready', GlobalShuttle_MEBES_Jobview__c = 'Ready', Customer_MEBES_Jobview__c = 'Ready', Foundry_MEBES_Jobview__c = 'Ready', Mask_Set_Title_Id__c = maskSetTitleId);
            MRS_Layer_Chip_Association__c objMRSLCA5 = new MRS_Layer_Chip_Association__c(Layer__c = objMRSLA1.Id, Chip__c = objMRSCD3.Id, PTRF__c = objPTRF.Id, Tech_Geo__c = '0.019UM', Tapeout_Applications_MEBES_Jobview__c = 'Ready', Tapeout_Centre_MEBES_Jobview__c = 'Ready', TDTI_MPW_MEBES_Jobview__c = 'Ready', MDP_MEBES_Jobview__c = 'Ready', GlobalShuttle_MEBES_Jobview__c = 'Ready', Customer_MEBES_Jobview__c = 'Ready', Foundry_MEBES_Jobview__c = 'Ready', Mask_Set_Title_Id__c = maskSetTitleId);
            MRS_Layer_Chip_Association__c objMRSLCA6 = new MRS_Layer_Chip_Association__c(Layer__c = objMRSLA2.Id, Chip__c = objMRSCD3.Id, PTRF__c = objPTRF.Id, Tech_Geo__c = '0.019UM', Tapeout_Applications_MEBES_Jobview__c = 'Ready', Tapeout_Centre_MEBES_Jobview__c = 'Ready', TDTI_MPW_MEBES_Jobview__c = 'Ready', MDP_MEBES_Jobview__c = 'Ready', GlobalShuttle_MEBES_Jobview__c = 'Ready', Customer_MEBES_Jobview__c = 'Ready', Foundry_MEBES_Jobview__c = 'Ready', Mask_Set_Title_Id__c = maskSetTitleId);
            listMRSLCA.add(objMRSLCA1);
            listMRSLCA.add(objMRSLCA2);
            listMRSLCA.add(objMRSLCA3);
            listMRSLCA.add(objMRSLCA4);
            listMRSLCA.add(objMRSLCA5);
            listMRSLCA.add(objMRSLCA6);
            insert listMRSLCA;



            Test.startTest();
            Messaging.InboundEmail email = new Messaging.InboundEmail();
            Messaging.InboundEnvelope env = new Messaging.InboundEnvelope();
            MRSEmailServices mrsEmailServicesObj = new MRSEmailServices();
            email.fromaddress = 'testMRS2@test.com';
            email.fromname = 'testMRS2';
            email.subject = 'Reminder Notification: Device ' + 'MST001' + ' : Gating MDP MEBES jobview for layer(s)' + 'RX';
            email.plainTextBody = 'Approved Mask Set Title: ' + 'MST001' + ' \n' + +'________________________________________ \n' + +' Dear Sir/Madam, \n' + +'Please be informed the following MEBES is ready for your gating review \n' + +'Chip Name:' + 'Chip002' + ' layer(s) ' + 'RXAZ' + 'PTRF Number: ' + 'PTRF1' + ' \n' + +'<Email Content from CAD Systems> \n' + +'jobview=mdp&' + +'Please approve in MRS system once the data is good to proceed tapeout. \n' + +'You can also approve by replying to this message with the text ?Approved? \n' + +'Thank you. \n' + +'This is a system generated message, please do not reply. \n' + +'Best Regards. ';
            mrsEmailServicesObj.handleInboundEmail(email, env);
            email.fromaddress = 'testMRS2@test.com';
            email.fromname = 'testMRS2';
            email.subject = 'Reminder Notification: Device ' + 'MST001' + ' : Gating TDTI-MPW MEBES jobview for layer(s)' + 'RX';
            email.plainTextBody = 'Approved Mask Set Title: ' + 'MST001' + ' \n' + +'________________________________________ \n' + +' Dear Sir/Madam, \n' + +'Please be informed the following MEBES is ready for your gating review \n' + +'Chip Name:' + 'Chip002' + ' layer(s) ' + 'RXAZ' + 'PTRF Number: ' + 'PTRF1' + ' \n' + +'<Email Content from CAD Systems> \n' + +'jobview=mpwtdti&' + +'Please approve in MRS system once the data is good to proceed tapeout. \n' + +'You can also approve by replying to this message with the text ?Approved? \n' + +'Thank you. \n' + +'This is a system generated message, please do not reply. \n' + +'Best Regards. ';
            mrsEmailServicesObj.handleInboundEmail(email, env);
            //System.assertEquals(mrsEmailServicesObj.mebesFlag,false); 
            Test.stopTest();
        }
    }

    
    /**
    @method: CoverFrameMockupifBlock
  
  **/
    public static testmethod void CoverFrameMockupifBlock() {
        /** Test started **/
        User sysAdminUser = [SELECT Id, Name FROM User WHERE Profile.Name = 'System Administrator'
        AND isActive = true].get(0);
        Profile sysAdminProfile = [SELECT Id FROM Profile WHERE Name = 'System Administrator'];
        User userSA = new User(alias = 'testMRS', email = 'testMRS@test.com',
        emailencodingkey = 'UTF-8', lastname = 'testMRSLast', firstname = 'testMRSFirst', languagelocalekey = 'en_US',
        localesidkey = 'en_US', profileid = sysAdminProfile.Id,
        timezonesidkey = 'America/Los_Angeles', username = 'testMRS@test.com', communitynickname = 'testMRS', isActive = true);
        insert userSA;
        Group groupTA = [select Id, DeveloperName, Name from Group where DeveloperName = 'Swift_Tapeout_Application'];
        Group groupTC = [select Id, DeveloperName, Name from Group where DeveloperName = 'Swift_Tapeout_Centre'];
        Group groupTMPW = [select Id, DeveloperName, Name from Group where DeveloperName = 'Swift_TDTI_MPW'];
        Group groupMDP = [select Id, DeveloperName, Name from Group where DeveloperName = 'Swift_MDP'];
        Group groupGS = [select Id, DeveloperName, Name from Group where DeveloperName = 'Swift_GlobalShuttle'];
        List < GroupMember > listGM = new List < GroupMember > ();
        GroupMember groupMemberTA = new GroupMember(GroupId = groupTA.Id, UserOrGroupId = userSA.Id);
        GroupMember groupMemberTC = new GroupMember(GroupId = groupTC.Id, UserOrGroupId = userSA.Id);
        GroupMember groupMemberTMPW = new GroupMember(GroupId = groupTMPW.Id, UserOrGroupId = userSA.Id);
        GroupMember groupMemberTMDP = new GroupMember(GroupId = groupMDP.Id, UserOrGroupId = userSA.Id);
        GroupMember groupMemberGS = new GroupMember(GroupId = groupGS.Id, UserOrGroupId = userSA.Id);
        listGM.add(groupMemberTA);
        listGM.add(groupMemberTC);
        listGM.add(groupMemberTMPW);
        listGM.add(groupMemberTMDP);
        listGM.add(groupMemberGS);
        insert listGM;

        System.runAs(sysAdminUser) {
            // comment-out, refactor with testSetup method setup()
            // SwiftDataUtilityTest.customSystemData();
            Account acc = SwiftDataUtilityTest.createTestAccount();
            Account_Team_Proxy__c atp = new Account_Team_Proxy__c(User__c = userSA.id, Account__c = acc.id, Account_Access__c = 'Read/Write',
            Opportunity_Access__c = 'Read/Write', Team_Role__c = 'Primary Customer Service Rep', Sequence_No__c = '1', Account_Role_ID__c = 'test1239');
            insert atp;
            Mask_Set_Title__c objMST = SwiftDataUtilityTest.createMST('MST001');
            insert objMST;
            PTRF__c objPTRF = new PTRF__c(Name = 'PTRF1', Order_Type__c = 'Test Order Type', Recticle_Type__c = 'Single Layer Reticle (SLR)', MaskSetTitle__c = objMST.Id, Customer__c = acc.id);
            insert objPTRF;
            List < PTRF_JobViewer_Info__c > listPTRFJVI = new List < PTRF_JobViewer_Info__c > ();
            PTRF_JobViewer_Info__c objPTRFJVC = new PTRF_JobViewer_Info__c(Name = 'SAC', PTRF__c = objPTRF.Id, Jobview__c = 'Customer', Jobview_Type__c = 'Frame Mockup;Prime GDSOUT Review;MEBES Jobview', User__c = userSA.Id);
            PTRF_JobViewer_Info__c objPTRFJVF = new PTRF_JobViewer_Info__c(Name = 'SAF', PTRF__c = objPTRF.Id, Jobview__c = 'Foundry', Jobview_Type__c = 'Frame Mockup;Prime GDSOUT Review;MEBES Jobview', User__c = userSA.Id);
            listPTRFJVI.add(objPTRFJVC);
            listPTRFJVI.add(objPTRFJVF);
            insert listPTRFJVI;
            MRS__c objMRS = new MRS__c(Mask_Set_Title__c = objMST.Id);
            insert objMRS;
            List < MRS_Layer_Association__c > listMRSLA = new List < MRS_Layer_Association__c > ();
            MRS_Layer_Association__c objMRSLA1 = new MRS_Layer_Association__c(MRS__c = objMRS.Id, Layer_Status__c = 'Ready', Name = 'RX', Mask_Layer_Rev__c = 'AZ', ROM_Code__c = '123', Customer_Frame_Mockup__c = 'Ready', Foundry_Frame_Mockup__c = 'Ready');
            MRS_Layer_Association__c objMRSLA2 = new MRS_Layer_Association__c(MRS__c = objMRS.Id, Layer_Status__c = 'Ready', Name = 'RY', Mask_Layer_Rev__c = 'AZ', ROM_Code__c = null, Customer_Frame_Mockup__c = 'Ready', Foundry_Frame_Mockup__c = 'Ready');
            listMRSLA.add(objMRSLA1);
            listMRSLA.add(objMRSLA2);
            insert listMRSLA;
            List < MRS_Chip_Details__c > listMRSCD = new List < MRS_Chip_Details__c > ();
            MRS_Chip_Details__c objMRSCD1 = new MRS_Chip_Details__c(MRS__c = objMRS.Id, Name = 'Chip001');
            MRS_Chip_Details__c objMRSCD2 = new MRS_Chip_Details__c(MRS__c = objMRS.Id, Name = 'Chip002');
            MRS_Chip_Details__c objMRSCD3 = new MRS_Chip_Details__c(MRS__c = objMRS.Id, Name = 'Frame');
            listMRSCD.add(objMRSCD1);
            listMRSCD.add(objMRSCD2);
            listMRSCD.add(objMRSCD3);
            insert listMRSCD;
            List < MRS_Layer_Chip_Association__c > listMRSLCA = new List < MRS_Layer_Chip_Association__c > ();
            MRS_Layer_Chip_Association__c objMRSLCA1 = new MRS_Layer_Chip_Association__c(Layer__c = objMRSLA1.Id, Chip__c = objMRSCD1.Id, PTRF__c = objPTRF.Id, Foundry_Frame_Mockup__c = 'Ready', Customer_Frame_Mockup__c = 'Ready', Tech_Geo__c = '0.019UM');
            MRS_Layer_Chip_Association__c objMRSLCA2 = new MRS_Layer_Chip_Association__c(Layer__c = objMRSLA1.Id, Chip__c = objMRSCD2.Id, PTRF__c = objPTRF.Id, Foundry_Frame_Mockup__c = 'Ready', Customer_Frame_Mockup__c = 'Ready', Tech_Geo__c = '0.019UM');
            MRS_Layer_Chip_Association__c objMRSLCA3 = new MRS_Layer_Chip_Association__c(Layer__c = objMRSLA2.Id, Chip__c = objMRSCD1.Id, PTRF__c = objPTRF.Id, Foundry_Frame_Mockup__c = 'Ready', Customer_Frame_Mockup__c = 'Ready', Tech_Geo__c = '0.019UM');
            MRS_Layer_Chip_Association__c objMRSLCA4 = new MRS_Layer_Chip_Association__c(Layer__c = objMRSLA2.Id, Chip__c = objMRSCD2.Id, PTRF__c = objPTRF.Id, Foundry_Frame_Mockup__c = 'Ready', Customer_Frame_Mockup__c = 'Ready', Tech_Geo__c = '0.019UM');
            MRS_Layer_Chip_Association__c objMRSLCA5 = new MRS_Layer_Chip_Association__c(Layer__c = objMRSLA1.Id, Chip__c = objMRSCD3.Id, PTRF__c = objPTRF.Id, Foundry_Frame_Mockup__c = 'Ready', Customer_Frame_Mockup__c = 'Ready', Tech_Geo__c = '0.019UM');
            MRS_Layer_Chip_Association__c objMRSLCA6 = new MRS_Layer_Chip_Association__c(Layer__c = objMRSLA2.Id, Chip__c = objMRSCD3.Id, PTRF__c = objPTRF.Id, Foundry_Frame_Mockup__c = 'Ready', Customer_Frame_Mockup__c = 'Ready', Tech_Geo__c = '0.019UM');
            listMRSLCA.add(objMRSLCA1);
            listMRSLCA.add(objMRSLCA2);
            listMRSLCA.add(objMRSLCA3);
            listMRSLCA.add(objMRSLCA4);
            listMRSLCA.add(objMRSLCA5);
            listMRSLCA.add(objMRSLCA6);
            insert listMRSLCA;

            List < String > mrslcaIdList = new List < String > ();
            for (MRS_Layer_Chip_Association__c mrsObj: listMRSLCA) {
                mrslcaIdList.add(mrsObj.Id);
            }
            Approval_Helper__c app1 = insertApprovalHelper(mrslcaIdList, 'Customer_Frame_Mockup__c');
            Approval_Helper__c app2 = insertApprovalHelper(mrslcaIdList, 'Foundry_Frame_Mockup__c');


            Messaging.InboundEmail email = new Messaging.InboundEmail();
            Messaging.InboundEnvelope env = new Messaging.InboundEnvelope();
            email.fromaddress = 'testMRS@test.com';
            email.fromname = 'testMRS';
            MRSEmailServices mrsEmailServicesObj = new MRSEmailServices();
            Test.startTest();
            email.subject = 'Notification: Device ' + 'MST001' + ' : Gating Frame Mockup review for layer(s)' + 'RX';
            email.plainTextBody = 'Approved' + '\n' + +'Approval Id :' + app1.Id + '#' + '\n' + +'Mask Set Title:' + 'MST001' + ' \n' + +'Mask Layer: ' + 'RX-AZ-123' + '  \n' + +'PTRF Number: ' + 'PTRF1' + ' \n' + +'________________________________________ \n' + +' Dear Sir/Madam, \n' + +'Please be informed the following frame mockup is ready for your gating review \n' + +'Chip Name:' + 'Frame' + ' layer(s) ' + 'RXAZ' + ' \n' + +'<Email Content from CAD Systems> \n' + +'type=Customer&' + +'Please approve in MRS system once the data is good to proceed tapeout. \n' + +'You can also approve by replying to this message with the text ?Approved? \n' + +'Thank you. \n' + +'This is a system generated message, please do not reply. \n' + +'Best Regards. ';
            mrsEmailServicesObj.handleInboundEmail(email, env);
            email.subject = 'Notification: Device ' + 'MST001' + ' : Gating Frame Mockup review for layer(s)' + 'RX';
            email.plainTextBody = 'Approved' + '\n' + +'Approval Id :' + app2.Id + '#' + '\n' + +'Mask Set Title:' + 'MST001' + ' \n' + +'Mask Layer: ' + 'RX-AZ-null>' + '  \n' + +'PTRF Number: ' + 'PTRF1>' + ' \n' + +'________________________________________ \n' + +' Dear Sir/Madam, \n' + +'Please be informed the following frame mockup is ready for your gating review \n' + +'Chip Name:' + 'Frame' + ' layer(s) ' + 'RXAZ' + ' \n' + +'<Email Content from CAD Systems> \n' + +'type=Foundry&' + +'Please approve in MRS system once the data is good to proceed tapeout. \n' + +'You can also approve by replying to this message with the text ?Approved? \n' + +'Thank you. \n' + +'This is a system generated message, please do not reply. \n' + +'Best Regards. ';
            mrsEmailServicesObj.handleInboundEmail(email, env);
            email.plainTextBody = 'Approved' + '\n' + +'Approval Id :' + app1.Id + '#' + '\n' + +'Mask Set Title:' + 'MST001' + ' \n' + +'Mask Layer: ' + 'RX-null-null>' + '  \n' + +'PTRF Number: ' + 'PTRF1>' + ' \n' + +'________________________________________ \n' + +' Dear Sir/Madam, ' + +'Please be informed the following frame mockup is ready for your gating review ' + +'Chip Name:' + 'Frame' + ' layer(s) ' + 'RXAZ' + ' ' + +'<Email Content from CAD Systems> ' + +'type=Customer&' + +'Please approve in MRS system once the data is good to proceed tapeout. ' + +'You can also approve by replying to this message with the text ?Approved? ' + +'Thank you. ' + +'This is a system generated message, please do not reply. ' + +'Best Regards. ';
            mrsEmailServicesObj.handleInboundEmail(email, env);
            //System.assertEquals(mrsEmailServicesObj.frameMockupFlag,);
            mrsEmailServicesObj.approveChips(email.fromaddress, 'Customer_Frame_Mockup__c', 'Approve', mrslcaIdList, app1);
            mrsEmailServicesObj.approveChips(email.fromaddress, 'Foundry_Frame_Mockup__c', 'Approve', mrslcaIdList, app2);

            Test.stopTest();

            /** Test ended **/
        }
    }

    public static Approval_Helper__c insertApprovalHelper(List < String > mrslcaIdList, String field) {

        Approval_Helper__c appHelperObj = new Approval_Helper__c();
        appHelperObj.MRSLCA_Id_to_approve__c = String.join(mrslcaIdList, ';');
        appHelperObj.Field_to_Update__c = field;
        appHelperObj.PTRF_Number__c = 'PTRF1';
        appHelperObj.Mask_Set_Title__c = 'MST001';

        insert appHelperObj;
        return appHelperObj;
    }
}