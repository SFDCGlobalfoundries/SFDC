@istest
private class MRSHandlerUtilityTest6 {

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
        This test method sets All the Layer Chip values.
        @method name: remoteJobview
       
  **/
    public static testMethod void remoteGatingJobview() {

        User sysAdminUser = [SELECT Id, Name FROM User WHERE Profile.Name = 'System Administrator'
        AND isActive = true].get(0);
        Profile sysAdminProfile = [SELECT Id FROM Profile WHERE Name = 'System Administrator'];
        User userSA = new User(alias = 'testMRS', email = 'testMRS@test.com',
        emailencodingkey = 'UTF-8', lastname = 'testMRSLast', firstname = 'testMRSFirst', languagelocalekey = 'en_US',
        localesidkey = 'en_US', profileid = sysAdminProfile.Id,
        timezonesidkey = 'America/Los_Angeles', username = 'testMRS@test.com', communitynickname = 'testMRS');
        insert userSA;
        Group groupTA = [select Id, DeveloperName, Name from Group where DeveloperName = 'Swift_Tapeout_Application'];
        Group groupTC = [select Id, DeveloperName, Name from Group where DeveloperName = 'Swift_Tapeout_Centre'];
        Group groupTMPW = [select Id, DeveloperName, Name from Group where DeveloperName = 'Swift_TDTI_MPW'];
        Group groupMDP = [select Id, DeveloperName, Name from Group where DeveloperName = 'Swift_MDP'];
        Group groupGS = [select Id, DeveloperName, Name from Group where DeveloperName = 'Swift_GlobalShuttle'];
        Group groupSA = [select Id, DeveloperName, Name from Group where DeveloperName = 'Swift_Admin'];
        List < GroupMember > listGM = new List < GroupMember > ();
        GroupMember groupMemberTA = new GroupMember(GroupId = groupTA.Id, UserOrGroupId = userSA.Id);
        GroupMember groupMemberTC = new GroupMember(GroupId = groupTC.Id, UserOrGroupId = userSA.Id);
        GroupMember groupMemberTMPW = new GroupMember(GroupId = groupTMPW.Id, UserOrGroupId = userSA.Id);
        GroupMember groupMemberTMDP = new GroupMember(GroupId = groupMDP.Id, UserOrGroupId = userSA.Id);
        GroupMember groupMemberGS = new GroupMember(GroupId = groupGS.Id, UserOrGroupId = userSA.Id);
        GroupMember groupMemberSA = new GroupMember(GroupId = groupSA.Id, UserOrGroupId = userSA.Id);
        listGM.add(groupMemberTA);
        listGM.add(groupMemberTC);
        listGM.add(groupMemberTMPW);
        listGM.add(groupMemberTMDP);
        listGM.add(groupMemberGS);
        listGM.add(groupMemberSA);
        insert listGM;
        System.runAs(sysAdminUser) {
            Test.startTest();
            // comment-out, refactor with testSetup method setup()
            // SwiftDataUtilityTest.customSystemData();
            // Insert Custom Settings Data---//
            //---------------------------------------------//

            Account acc = SwiftDataUtilityTest.createTestAccount();


            Mask_Set_Title__c objMST = SwiftDataUtilityTest.createMST('MST001');
            insert objMST;
            list < PTRF__c > ptrflst = new list < PTRF__c > ();
            PTRF__c objPTRF = new PTRF__c(Name = 'PTRF101', Order_Type__c = 'New Prototype', Recticle_Type__c = 'Single Layer Reticle (SLR)', MaskSetTitle__c = objMST.Id, Customer__c = acc.id, Tech_Geo_Value__c = '0.01UM', Customer_jobview__c = 'Gating mask release', Foundry_jobview__c = 'Gating mask release');
            ptrflst.add(objPTRF);

            insert ptrflst;
            List < PTRF_JobViewer_Info__c > listPTRFJVI = new List < PTRF_JobViewer_Info__c > ();
            List < PTRF_JobViewer_Info__c > listPTRFJVIQueried = new List < PTRF_JobViewer_Info__c > ();
            PTRF_JobViewer_Info__c objPTRFJVC = new PTRF_JobViewer_Info__c(Name = 'SAC', PTRF__c = ptrflst.get(0).Id, Jobview__c = 'Customer', Jobview_Type__c = 'Frame Mockup;Prime GDSOUT Review;MEBES Jobview', User__c = userSA.Id);
            PTRF_JobViewer_Info__c objPTRFJVF = new PTRF_JobViewer_Info__c(Name = 'SAF', PTRF__c = ptrflst.get(0).Id, Jobview__c = 'Foundry', Jobview_Type__c = 'Frame Mockup;Prime GDSOUT Review;MEBES Jobview', User__c = userSA.Id);
            PTRF_JobViewer_Info__c objPTRFJVC2 = new PTRF_JobViewer_Info__c(Name = 'SAC2', PTRF__c = ptrflst.get(0).Id, Jobview__c = 'Customer', Jobview_Type__c = 'Frame Mockup;Prime GDSOUT Review;MEBES Jobview', User__c = userSA.Id);
            PTRF_JobViewer_Info__c objPTRFJVF2 = new PTRF_JobViewer_Info__c(Name = 'SAF2', PTRF__c = ptrflst.get(0).Id, Jobview__c = 'Foundry', Jobview_Type__c = 'Frame Mockup;Prime GDSOUT Review;MEBES Jobview', User__c = userSA.Id);
            listPTRFJVI.add(objPTRFJVC);
            listPTRFJVI.add(objPTRFJVF);
            listPTRFJVI.add(objPTRFJVC2);
            listPTRFJVI.add(objPTRFJVF2);
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
            MRS_Layer_Chip_Association__c objMRSLCA1 = new MRS_Layer_Chip_Association__c(Layer__c = objMRSLA1.Id, Chip__c = objMRSCD1.Id, PTRF__c = ptrflst.get(0).Id, Device_Id__c = '1', Layer_Chip_Status__c = 'In Progress', Customer_Name__c = acc.Id, Tapeout_Applications_MEBES_Jobview__c = 'Ready', Customer_Prime_Remote_Jobview_Setup__c = 'Done', Foundry_Prime_Remote_Jobview_Setup__c = 'Done', Customer_MEBES_Jobview__c = 'Ready', Foundry_MEBES_Jobview__c = 'Ready');
            MRS_Layer_Chip_Association__c objMRSLCA2 = new MRS_Layer_Chip_Association__c(Layer__c = objMRSLA1.Id, Chip__c = objMRSCD2.Id, PTRF__c = ptrflst.get(0).Id, Device_Id__c = '1', Layer_Chip_Status__c = 'In Progress', Customer_Name__c = acc.Id, Tapeout_Applications_MEBES_Jobview__c = 'Ready', Customer_Prime_Remote_Jobview_Setup__c = 'Done', Foundry_Prime_Remote_Jobview_Setup__c = 'Done', Customer_MEBES_Jobview__c = 'Ready', Foundry_MEBES_Jobview__c = 'Ready');
            MRS_Layer_Chip_Association__c objMRSLCA3 = new MRS_Layer_Chip_Association__c(Layer__c = objMRSLA2.Id, Chip__c = objMRSCD1.Id, PTRF__c = ptrflst.get(0).Id, Device_Id__c = '1', Layer_Chip_Status__c = 'In Progress', Customer_Name__c = acc.Id, Tapeout_Applications_MEBES_Jobview__c = 'Ready', Customer_Prime_Remote_Jobview_Setup__c = 'Done', Foundry_Prime_Remote_Jobview_Setup__c = 'Done', Customer_MEBES_Jobview__c = 'Ready', Foundry_MEBES_Jobview__c = 'Ready');
            MRS_Layer_Chip_Association__c objMRSLCA4 = new MRS_Layer_Chip_Association__c(Layer__c = objMRSLA2.Id, Chip__c = objMRSCD2.Id, PTRF__c = ptrflst.get(0).Id, Device_Id__c = '1', Layer_Chip_Status__c = 'In Progress', Customer_Name__c = acc.Id, Tapeout_Applications_MEBES_Jobview__c = 'Ready', Customer_Prime_Remote_Jobview_Setup__c = 'Done', Foundry_Prime_Remote_Jobview_Setup__c = 'Done', Customer_MEBES_Jobview__c = 'Ready', Foundry_MEBES_Jobview__c = 'Ready');
            MRS_Layer_Chip_Association__c objMRSLCA5 = new MRS_Layer_Chip_Association__c(Layer__c = objMRSLA1.Id, Chip__c = objMRSCD3.Id, PTRF__c = ptrflst.get(0).Id, Device_Id__c = '1', Layer_Chip_Status__c = 'In Progress', Customer_Name__c = acc.Id, Tapeout_Applications_MEBES_Jobview__c = 'Ready', Customer_Prime_Remote_Jobview_Setup__c = 'Done', Foundry_Prime_Remote_Jobview_Setup__c = 'Done', Customer_MEBES_Jobview__c = 'Ready', Foundry_MEBES_Jobview__c = 'Ready');
            //MRS_Layer_Chip_Association__c objMRSLCA6 = new MRS_Layer_Chip_Association__c(Layer__c=objMRSLA2.Id,Chip__c=objMRSCD3.Id,PTRF__c=objPTRF.Id,Tech_Geo__c='0.019UM',Device_Id__c='1',Layer_Chip_Status__c='In Progress',Customer_Name__c=acc.Id,Tapeout_Applications_MEBES_Jobview__c= 'Ready');
            listMRSLCA.add(objMRSLCA1);
            listMRSLCA.add(objMRSLCA2);
            listMRSLCA.add(objMRSLCA3);
            listMRSLCA.add(objMRSLCA4);
            listMRSLCA.add(objMRSLCA5);
            insert listMRSLCA;

            //LIST<MRS_Layer_Chip_Association__c> mrsLayerChiplst =[SELECT PTRF__r.Customer_Jobview__c,PTRF__r.Foundry_Jobview__c,PTRF__r.Tech_Geo__c,Layer__c,PTRF__c,Chip__c,Layer_Chip_Status__c,Customer_Name__c,Tapeout_Applications_MEBES_Jobview__c,PTRF__r.Order_Type__c,PTRF__r.Customer_Short_Name__c,PTRF__r.Process_Technology_Lifecycle_Phase__c,Chip__r.Name,Layer__r.Name,Layer__r.Mask_Rev__c FROM MRS_Layer_Chip_Association__c WHERE Id IN :listMRSLCA];
            List < MRS_Layer_Chip_Association__c > mrsLayerChiplst = [select PTRF__r.Tech_Geo__c, Layer_Name__c, lastmodifieddate_sgt__c,
            Tech_Geo__c,
            Tapeout_Centre_MEBES_Jobview__c,
            Tapeout_Centre_MEBES_Jobview_Date__c,
            Tapeout_Applications_MEBES_Jobview__c,
            Tapeout_Applications_MEBES_Jobview_Date__c,
            TDTI_MPW_MEBES_Jobview__c,
            TDTI_MPW_MEBES_Date__c,
            Send_Prime_Data__c,
            Send_Prime_Data_Date__c,
            Send_Frame_Data__c,
            Send_Frame_Data_Date__c,
            Rev__c,
            ROM_Code__c,
            Prime_TapeOut__c,
            Prime_MEBES_Received__c,
            Prime_MEBES_Received_Date__c,
            PTRF__c,
            PTRF_Number__c,
            ORC__c,
            ORC_Date__c,
            Name,
            Mask_Set_Title_Name__c,
            Mask_Layer__c,
            Mask_Layer_Status__c,
            MST__c,
            MDP_MEBES_Jobview__c,
            MDP_MEBES_Jobview_Date__c,
            Layer__r.Mask_Layer_Rev__c,
            Layer__r.ROM_Code__c,
            PTRF__r.Customer_jobview__c,
            PTRF__r.Foundry_Jobview__c,
            PTRF__r.Order_Type__c,
            PTRF__r.MaskSetTitle__c,
            PTRF__r.MaskSetTitle__r.Name,
            Customer_Name__r.Name,
            PTRF__r.Name,
            Chip__r.Name,
            Layer__r.Name,
            Customer_Name__r.Short_Name__c,
            Layer_Send_Prime_Data__c,
            Layer_Send_Frame_Data__c,

            Layer_Chip_Status__c,
            Layer_Chip_Status_Date__c,
            Layer_Chip_Old_Status__c,
            Last_Sync_Req_Timestamp__c,
            Last_Sync_Req_Timestamp_Send_Prime__c,
            Last_Sync_Req_Timestamp_Send_Frame__c,
            Last_Sync_Req_Timestamp_Remote_Jobview__c,
            Last_Sync_Req_Timestamp_Receive_MEBES__c,
            Last_Sync_Req_Timestamp_ORCN_Job__c,
            Last_Sync_Req_Timestamp_Layer_Gen__c,
            Is_Tapeout_Centre_MEBES_Jobview_Updated__c,
            Is_Tapeout_Apps_MEBES_Jobview_Updated__c,
            Is_TDTI_MPW_MEBES_Jobview_Updated__c,
            Is_Send_Prime_Data_Updated__c,
            Is_Send_Frame_Data_Updated__c,
            Is_Prime_MEBES_Received_Updated__c,
            Is_ORC_Updated__c,
            Is_MDP_MEBES_Jobview_Updated__c,
            Is_GlobalShuttle_MEBES_Jobview_Updated__c,
            Is_Frame_MEBES_Received_Updated__c,
            Is_Foundry_Prime_Remote_Jobview_Updated__c,
            Is_Foundry_MEBES_Jobview_Updated__c,
            Is_Foundry_GDSOUT_Review_Updated__c,
            Is_Foundry_Frame_Remote_Jobview_Updated__c,
            Is_Foundry_Frame_Mockup_Updated__c,
            Is_DRW_Updated__c,
            Is_Customer_Prime_Remote_Jobview_Updated__c,
            Is_Customer_MEBES_Jobview_Updated__c,
            Is_Customer_GDSOUT_Review_Updated__c,
            Is_Customer_Frame_Remote_Jobview_Updated__c,
            Is_Customer_Frame_Mockup_Updated__c,
            Is_Active__c,
            IsDeleted,
            Id,
            GlobalShuttle_MEBES_Jobview__c,
            GlobalShuttle_MEBES_Jobview_Date__c,
            Frame_TapeOut__c,
            Frame_MEBES_Received__c,
            Frame_MEBES_Received_Date__c,
            Foundry_Prime_Remote_Jobview_Setup__c,
            Foundry_Prime_Remote_Jobview_Setup_Date__c,
            Foundry_MEBES_Jobview__c,
            Foundry_MEBES_Jobview_Date__c,
            Foundry_GDSOUT_Review__c,
            Foundry_GDSOUT_Review_Date__c,
            Foundry_Frame_Remote_Jobview_Setup__c,
            Foundry_Frame_Remote_Jobview_Setup_Date__c,
            Foundry_Frame_Mockup__c,
            Foundry_Frame_Mockup_Date__c,
            Customer_Prime_Remote_Jobview_Setup__c,
            Customer_Prime_Remote_Jobview_Setup_Date__c,
            Customer_Name__c,
            Customer_MEBES_Jobview__c,
            Customer_MEBES_Jobview_Date__c,
            Customer_GDSOUT_Review__c,
            Customer_GDSOUT_Review_Date__c,
            Customer_Frame_Remote_Jobview_Setup__c,
            Customer_Frame_Remote_Jobview_Setup_Date__c,
            Customer_Frame_Mockup__c,
            Customer_Frame_Mockup_Date__c,
            Chip__c, DRW__c,
            Chip_Name__c, PTRF__r.Process_Technology_Lifecycle_Phase__c,
            PTRF__r.Customer_Short_Name__c
            FROM MRS_Layer_Chip_Association__c WHERE Id IN: listMRSLCA];
            MRSHandlerUtility.sendDoneEmailtoRemoteJobView(mrsLayerChiplst, 'Test String', true, true, 'Test String');
            MRSHandlerUtility.sendEmailForRemoteJobViewToReviewersSubsequently(mrsLayerChiplst, 'Test String', 'Test String', 'Testtt', true, true);
            
            try {
                Integer a = integer.valueOf('test') + 5 ; 
            } catch(Exception e) {
                MRSHandlerUtility.sendMRSExceptionLogMail2(e, new set<string>{ptrflst.get(0).Id});
            }
                                                                        
            
            Test.stopTest();

        }
    }
    /**
        This test method sets All the Layer Chip values.
        @method name: retreiveCustomerName
       
  **/
    public static testMethod void retreiveCustomerName() {

        User sysAdminUser = [SELECT Id, Name FROM User WHERE Profile.Name = 'System Administrator'
        AND isActive = true].get(0);
        Profile sysAdminProfile = [SELECT Id FROM Profile WHERE Name = 'System Administrator'];
        User userSA = new User(alias = 'testMRS', email = 'testMRS@test.com',
        emailencodingkey = 'UTF-8', lastname = 'testMRSLast', firstname = 'testMRSFirst', languagelocalekey = 'en_US',
        localesidkey = 'en_US', profileid = sysAdminProfile.Id,
        timezonesidkey = 'America/Los_Angeles', username = 'testMRS@test.com', communitynickname = 'testMRS');
        insert userSA;
        Group groupTA = [select Id, DeveloperName, Name from Group where DeveloperName = 'Swift_Tapeout_Application'];
        Group groupTC = [select Id, DeveloperName, Name from Group where DeveloperName = 'Swift_Tapeout_Centre'];
        Group groupTMPW = [select Id, DeveloperName, Name from Group where DeveloperName = 'Swift_TDTI_MPW'];
        Group groupMDP = [select Id, DeveloperName, Name from Group where DeveloperName = 'Swift_MDP'];
        Group groupGS = [select Id, DeveloperName, Name from Group where DeveloperName = 'Swift_GlobalShuttle'];
        Group groupSA = [select Id, DeveloperName, Name from Group where DeveloperName = 'Swift_Admin'];
        List < GroupMember > listGM = new List < GroupMember > ();
        GroupMember groupMemberTA = new GroupMember(GroupId = groupTA.Id, UserOrGroupId = userSA.Id);
        GroupMember groupMemberTC = new GroupMember(GroupId = groupTC.Id, UserOrGroupId = userSA.Id);
        GroupMember groupMemberTMPW = new GroupMember(GroupId = groupTMPW.Id, UserOrGroupId = userSA.Id);
        GroupMember groupMemberTMDP = new GroupMember(GroupId = groupMDP.Id, UserOrGroupId = userSA.Id);
        GroupMember groupMemberGS = new GroupMember(GroupId = groupGS.Id, UserOrGroupId = userSA.Id);
        GroupMember groupMemberSA = new GroupMember(GroupId = groupSA.Id, UserOrGroupId = userSA.Id);
        listGM.add(groupMemberTA);
        listGM.add(groupMemberTC);
        listGM.add(groupMemberTMPW);
        listGM.add(groupMemberTMDP);
        listGM.add(groupMemberGS);
        listGM.add(groupMemberSA);
        insert listGM;
        System.runAs(sysAdminUser) {
            Test.startTest();
            // comment-out, refactor with testSetup method setup()
            // SwiftDataUtilityTest.customSystemData();
            // Insert Custom Settings Data---//
            //---------------------------------------------//

            Account acc = SwiftDataUtilityTest.createTestAccount();
            list < Tapeout_Applications_MEBES_Jobview_Confi__c > tapeoutApplicationCofiglst = new list < Tapeout_Applications_MEBES_Jobview_Confi__c > ();
            Tapeout_Applications_MEBES_Jobview_Confi__c tapeoutApplicationObject = new Tapeout_Applications_MEBES_Jobview_Confi__c(PTRF_Customer_MEBES_Jobview__c = 'Gating mask release;Not Required', PTRF_Foundry_MEBES_Jobview__c = 'Gating mask release;Not Required', PTRF_Order_Type__c = 'New Prototype', PTRF_Technology__c = '0.02UM', Tapeout_Application_Jobview__c = 'Gating', Logic_For_Calculation__c = 'AND', Excluded_Customer__c = acc.Short_Name__c);
            tapeoutApplicationCofiglst.add(tapeoutApplicationObject);
            tapeoutApplicationObject = new Tapeout_Applications_MEBES_Jobview_Confi__c(PTRF_Customer_MEBES_Jobview__c = 'Gating mask release;Not Required', PTRF_Foundry_MEBES_Jobview__c = 'Gating mask release;Not Required', PTRF_Order_Type__c = 'New Prototype', PTRF_Technology__c = '<=0.01UM', Tapeout_Application_Jobview__c = 'Gating', Logic_For_Calculation__c = 'AND', Excluded_Customer__c = acc.Short_Name__c);
            tapeoutApplicationCofiglst.add(tapeoutApplicationObject);
            tapeoutApplicationObject = new Tapeout_Applications_MEBES_Jobview_Confi__c(PTRF_Customer_MEBES_Jobview__c = 'Gating mask release;Not Required', PTRF_Foundry_MEBES_Jobview__c = 'Gating mask release;Not Required', PTRF_Order_Type__c = 'New Prototype', PTRF_Technology__c = '>=0.02UM', Tapeout_Application_Jobview__c = 'Gating', Logic_For_Calculation__c = 'OR', Excluded_Customer__c = acc.Short_Name__c);
            tapeoutApplicationCofiglst.add(tapeoutApplicationObject);
            tapeoutApplicationObject = new Tapeout_Applications_MEBES_Jobview_Confi__c(PTRF_Customer_MEBES_Jobview__c = 'Gating mask release;Not Required', PTRF_Foundry_MEBES_Jobview__c = 'Gating mask release;Not Required', PTRF_Order_Type__c = 'New Prototype', PTRF_Technology__c = '>0.02UM', Tapeout_Application_Jobview__c = 'Gating', Logic_For_Calculation__c = 'AND', Excluded_Customer__c = acc.Short_Name__c);
            tapeoutApplicationCofiglst.add(tapeoutApplicationObject);
            tapeoutApplicationObject = new Tapeout_Applications_MEBES_Jobview_Confi__c(PTRF_Customer_MEBES_Jobview__c = 'Gating mask release;Not Required', PTRF_Foundry_MEBES_Jobview__c = 'Not Gating mask release;Not Required', PTRF_Order_Type__c = 'New Prototype', PTRF_Technology__c = '<0.02UM', Tapeout_Application_Jobview__c = 'Gating', Logic_For_Calculation__c = 'OR', Excluded_Customer__c = acc.Short_Name__c);
            tapeoutApplicationCofiglst.add(tapeoutApplicationObject);
            tapeoutApplicationObject = new Tapeout_Applications_MEBES_Jobview_Confi__c(PTRF_Customer_MEBES_Jobview__c = 'Gating mask release;Not Required', PTRF_Foundry_MEBES_Jobview__c = 'Gating mask release;Not Required', PTRF_Order_Type__c = 'New Prototype', PTRF_Technology__c = '0.11UM - 0.18UM', Tapeout_Application_Jobview__c = 'Not Gating', Logic_For_Calculation__c = 'AND', Excluded_Customer__c = acc.Short_Name__c);
            tapeoutApplicationCofiglst.add(tapeoutApplicationObject);
            insert tapeoutApplicationCofiglst;

            Mask_Set_Title__c objMST = SwiftDataUtilityTest.createMST('MST001');
            insert objMST;
            list < PTRF__c > ptrflst = new list < PTRF__c > ();
            PTRF__c objPTRF = new PTRF__c(Name = 'PTRF101', Order_Type__c = 'New Prototype', Recticle_Type__c = 'Single Layer Reticle (SLR)', MaskSetTitle__c = objMST.Id, Customer__c = acc.id, Tech_Geo_Value__c = '0.01UM', Customer_jobview__c = 'Gating mask release', Foundry_jobview__c = 'Gating mask release');
            ptrflst.add(objPTRF);
            objPTRF = new PTRF__c(Name = 'PTRF102', Order_Type__c = 'New Prototype', Recticle_Type__c = 'Single Layer Reticle (SLR)', MaskSetTitle__c = objMST.Id, Customer__c = acc.id, Tech_Geo_Value__c = '0.02UM', Customer_jobview__c = 'Gating mask release', Foundry_jobview__c = 'Gating mask release');
            ptrflst.add(objPTRF);
            objPTRF = new PTRF__c(Name = 'PTRF103', Order_Type__c = 'New Prototype', Recticle_Type__c = 'Single Layer Reticle (SLR)', MaskSetTitle__c = objMST.Id, Customer__c = acc.id, Tech_Geo_Value__c = '0.03UM', Customer_jobview__c = 'Gating mask release', Foundry_jobview__c = 'Gating mask release');
            ptrflst.add(objPTRF);
            objPTRF = new PTRF__c(Name = 'PTRF104', Order_Type__c = 'New Prototype', Recticle_Type__c = 'Single Layer Reticle (SLR)', MaskSetTitle__c = objMST.Id, Customer__c = acc.id, Tech_Geo_Value__c = '0.01UM', Customer_jobview__c = 'Gating mask release', Foundry_jobview__c = 'Not Gating mask release');
            ptrflst.add(objPTRF);
            objPTRF = new PTRF__c(Name = 'PTRF105', Order_Type__c = 'New Prototype', Recticle_Type__c = 'Single Layer Reticle (SLR)', MaskSetTitle__c = objMST.Id, Customer__c = acc.id, Tech_Geo_Value__c = '0.12UM', Customer_jobview__c = 'Gating mask release', Foundry_jobview__c = 'Gating mask release');
            ptrflst.add(objPTRF);
            insert ptrflst;
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
            MRS_Layer_Chip_Association__c objMRSLCA1 = new MRS_Layer_Chip_Association__c(Layer__c = objMRSLA1.Id, Chip__c = objMRSCD1.Id, PTRF__c = ptrflst.get(0).Id, Device_Id__c = '1', Layer_Chip_Status__c = 'In Progress', Customer_Name__c = acc.Id, Tapeout_Applications_MEBES_Jobview__c = 'Ready');
            MRS_Layer_Chip_Association__c objMRSLCA2 = new MRS_Layer_Chip_Association__c(Layer__c = objMRSLA1.Id, Chip__c = objMRSCD2.Id, PTRF__c = ptrflst.get(1).Id, Device_Id__c = '1', Layer_Chip_Status__c = 'In Progress', Customer_Name__c = acc.Id, Tapeout_Applications_MEBES_Jobview__c = 'Ready');
            MRS_Layer_Chip_Association__c objMRSLCA3 = new MRS_Layer_Chip_Association__c(Layer__c = objMRSLA2.Id, Chip__c = objMRSCD1.Id, PTRF__c = ptrflst.get(2).Id, Device_Id__c = '1', Layer_Chip_Status__c = 'In Progress', Customer_Name__c = acc.Id, Tapeout_Applications_MEBES_Jobview__c = 'Ready');
            MRS_Layer_Chip_Association__c objMRSLCA4 = new MRS_Layer_Chip_Association__c(Layer__c = objMRSLA2.Id, Chip__c = objMRSCD2.Id, PTRF__c = ptrflst.get(3).Id, Device_Id__c = '1', Layer_Chip_Status__c = 'In Progress', Customer_Name__c = acc.Id, Tapeout_Applications_MEBES_Jobview__c = 'Ready');
            MRS_Layer_Chip_Association__c objMRSLCA5 = new MRS_Layer_Chip_Association__c(Layer__c = objMRSLA1.Id, Chip__c = objMRSCD3.Id, PTRF__c = ptrflst.get(4).Id, Device_Id__c = '1', Layer_Chip_Status__c = 'In Progress', Customer_Name__c = acc.Id, Tapeout_Applications_MEBES_Jobview__c = 'Ready');
            //MRS_Layer_Chip_Association__c objMRSLCA6 = new MRS_Layer_Chip_Association__c(Layer__c=objMRSLA2.Id,Chip__c=objMRSCD3.Id,PTRF__c=objPTRF.Id,Tech_Geo__c='0.019UM',Device_Id__c='1',Layer_Chip_Status__c='In Progress',Customer_Name__c=acc.Id,Tapeout_Applications_MEBES_Jobview__c= 'Ready');
            listMRSLCA.add(objMRSLCA1);
            listMRSLCA.add(objMRSLCA2);
            listMRSLCA.add(objMRSLCA3);
            listMRSLCA.add(objMRSLCA4);
            listMRSLCA.add(objMRSLCA5);
            insert listMRSLCA;

            //LIST<MRS_Layer_Chip_Association__c> mrsLayerChiplst =[SELECT PTRF__r.Customer_Jobview__c,PTRF__r.Foundry_Jobview__c,PTRF__r.Tech_Geo__c,Layer__c,PTRF__c,Chip__c,Layer_Chip_Status__c,Customer_Name__c,Tapeout_Applications_MEBES_Jobview__c,PTRF__r.Order_Type__c,PTRF__r.Customer_Short_Name__c,PTRF__r.Process_Technology_Lifecycle_Phase__c,Chip__r.Name,Layer__r.Name,Layer__r.Mask_Rev__c FROM MRS_Layer_Chip_Association__c WHERE Id IN :listMRSLCA];
            List < MRS_Layer_Chip_Association__c > mrsLayerChiplst = [select PTRF__r.Tech_Geo__c, Layer_Name__c, lastmodifieddate_sgt__c,
            Tech_Geo__c,
            Tapeout_Centre_MEBES_Jobview__c,
            Tapeout_Centre_MEBES_Jobview_Date__c,
            Tapeout_Applications_MEBES_Jobview__c,
            Tapeout_Applications_MEBES_Jobview_Date__c,
            TDTI_MPW_MEBES_Jobview__c,
            TDTI_MPW_MEBES_Date__c,
            Send_Prime_Data__c,
            Send_Prime_Data_Date__c,
            Send_Frame_Data__c,
            Send_Frame_Data_Date__c,
            Rev__c,
            ROM_Code__c,
            Prime_TapeOut__c,
            Prime_MEBES_Received__c,
            Prime_MEBES_Received_Date__c,
            PTRF__c,
            PTRF_Number__c,
            ORC__c,
            ORC_Date__c,
            Name,
            Mask_Set_Title_Name__c,
            Mask_Layer__c,
            Mask_Layer_Status__c,
            MST__c,
            MDP_MEBES_Jobview__c,
            MDP_MEBES_Jobview_Date__c,
            Layer__r.Mask_Layer_Rev__c,
            Layer__r.ROM_Code__c,
            PTRF__r.Customer_jobview__c,
            PTRF__r.Foundry_Jobview__c,
            PTRF__r.Order_Type__c,
            PTRF__r.MaskSetTitle__c,
            PTRF__r.MaskSetTitle__r.Name,
            Customer_Name__r.Name,
            PTRF__r.Name,
            Chip__r.Name,
            Layer__r.Name,
            Customer_Name__r.Short_Name__c,
            Layer_Send_Prime_Data__c,
            Layer_Send_Frame_Data__c,

            Layer_Chip_Status__c,
            Layer_Chip_Status_Date__c,
            Layer_Chip_Old_Status__c,
            Last_Sync_Req_Timestamp__c,
            Last_Sync_Req_Timestamp_Send_Prime__c,
            Last_Sync_Req_Timestamp_Send_Frame__c,
            Last_Sync_Req_Timestamp_Remote_Jobview__c,
            Last_Sync_Req_Timestamp_Receive_MEBES__c,
            Last_Sync_Req_Timestamp_ORCN_Job__c,
            Last_Sync_Req_Timestamp_Layer_Gen__c,
            Is_Tapeout_Centre_MEBES_Jobview_Updated__c,
            Is_Tapeout_Apps_MEBES_Jobview_Updated__c,
            Is_TDTI_MPW_MEBES_Jobview_Updated__c,
            Is_Send_Prime_Data_Updated__c,
            Is_Send_Frame_Data_Updated__c,
            Is_Prime_MEBES_Received_Updated__c,
            Is_ORC_Updated__c,
            Is_MDP_MEBES_Jobview_Updated__c,
            Is_GlobalShuttle_MEBES_Jobview_Updated__c,
            Is_Frame_MEBES_Received_Updated__c,
            Is_Foundry_Prime_Remote_Jobview_Updated__c,
            Is_Foundry_MEBES_Jobview_Updated__c,
            Is_Foundry_GDSOUT_Review_Updated__c,
            Is_Foundry_Frame_Remote_Jobview_Updated__c,
            Is_Foundry_Frame_Mockup_Updated__c,
            Is_DRW_Updated__c,
            Is_Customer_Prime_Remote_Jobview_Updated__c,
            Is_Customer_MEBES_Jobview_Updated__c,
            Is_Customer_GDSOUT_Review_Updated__c,
            Is_Customer_Frame_Remote_Jobview_Updated__c,
            Is_Customer_Frame_Mockup_Updated__c,
            Is_Active__c,
            IsDeleted,
            Id,
            GlobalShuttle_MEBES_Jobview__c,
            GlobalShuttle_MEBES_Jobview_Date__c,
            Frame_TapeOut__c,
            Frame_MEBES_Received__c,
            Frame_MEBES_Received_Date__c,
            Foundry_Prime_Remote_Jobview_Setup__c,
            Foundry_Prime_Remote_Jobview_Setup_Date__c,
            Foundry_MEBES_Jobview__c,
            Foundry_MEBES_Jobview_Date__c,
            Foundry_GDSOUT_Review__c,
            Foundry_GDSOUT_Review_Date__c,
            Foundry_Frame_Remote_Jobview_Setup__c,
            Foundry_Frame_Remote_Jobview_Setup_Date__c,
            Foundry_Frame_Mockup__c,
            Foundry_Frame_Mockup_Date__c,
            Customer_Prime_Remote_Jobview_Setup__c,
            Customer_Prime_Remote_Jobview_Setup_Date__c,
            Customer_Name__c,
            Customer_MEBES_Jobview__c,
            Customer_MEBES_Jobview_Date__c,
            Customer_GDSOUT_Review__c,
            Customer_GDSOUT_Review_Date__c,
            Customer_Frame_Remote_Jobview_Setup__c,
            Customer_Frame_Remote_Jobview_Setup_Date__c,
            Customer_Frame_Mockup__c,
            Customer_Frame_Mockup_Date__c,
            Chip__c, DRW__c,
            Chip_Name__c, PTRF__r.Process_Technology_Lifecycle_Phase__c,
            PTRF__r.Customer_Short_Name__c
            FROM MRS_Layer_Chip_Association__c WHERE Id IN: listMRSLCA];
            MRSHandlerUtility.sendEmailToTapeoutApplication(mrsLayerChiplst, 'Test String', 'Test String');
            Test.stopTest();

        }
    }
    /**
        This test method sets All the Layer Chip values.
        @method name: remoteNotGatingJobview
       
  **/
    public static testMethod void remoteNotGatingJobview() {

        User sysAdminUser = [SELECT Id, Name FROM User WHERE Profile.Name = 'System Administrator'
        AND isActive = true].get(0);
        Profile sysAdminProfile = [SELECT Id FROM Profile WHERE Name = 'System Administrator'];
        User userSA = new User(alias = 'testMRS', email = 'testMRS@test.com',
        emailencodingkey = 'UTF-8', lastname = 'testMRSLast', firstname = 'testMRSFirst', languagelocalekey = 'en_US',
        localesidkey = 'en_US', profileid = sysAdminProfile.Id,
        timezonesidkey = 'America/Los_Angeles', username = 'testMRS@test.com', communitynickname = 'testMRS');
        insert userSA;
        Group groupTA = [select Id, DeveloperName, Name from Group where DeveloperName = 'Swift_Tapeout_Application'];
        Group groupTC = [select Id, DeveloperName, Name from Group where DeveloperName = 'Swift_Tapeout_Centre'];
        Group groupTMPW = [select Id, DeveloperName, Name from Group where DeveloperName = 'Swift_TDTI_MPW'];
        Group groupMDP = [select Id, DeveloperName, Name from Group where DeveloperName = 'Swift_MDP'];
        Group groupGS = [select Id, DeveloperName, Name from Group where DeveloperName = 'Swift_GlobalShuttle'];
        Group groupSA = [select Id, DeveloperName, Name from Group where DeveloperName = 'Swift_Admin'];
        List < GroupMember > listGM = new List < GroupMember > ();
        GroupMember groupMemberTA = new GroupMember(GroupId = groupTA.Id, UserOrGroupId = userSA.Id);
        GroupMember groupMemberTC = new GroupMember(GroupId = groupTC.Id, UserOrGroupId = userSA.Id);
        GroupMember groupMemberTMPW = new GroupMember(GroupId = groupTMPW.Id, UserOrGroupId = userSA.Id);
        GroupMember groupMemberTMDP = new GroupMember(GroupId = groupMDP.Id, UserOrGroupId = userSA.Id);
        GroupMember groupMemberGS = new GroupMember(GroupId = groupGS.Id, UserOrGroupId = userSA.Id);
        GroupMember groupMemberSA = new GroupMember(GroupId = groupSA.Id, UserOrGroupId = userSA.Id);
        listGM.add(groupMemberTA);
        listGM.add(groupMemberTC);
        listGM.add(groupMemberTMPW);
        listGM.add(groupMemberTMDP);
        listGM.add(groupMemberGS);
        listGM.add(groupMemberSA);
        insert listGM;
        System.runAs(sysAdminUser) {
            Test.startTest();
            // comment-out, refactor with testSetup method setup()
            // SwiftDataUtilityTest.customSystemData();
            // Insert Custom Settings Data---//
            //---------------------------------------------//

            Account acc = SwiftDataUtilityTest.createTestAccount();


            Mask_Set_Title__c objMST = SwiftDataUtilityTest.createMST('MST001');
            insert objMST;
            list < PTRF__c > ptrflst = new list < PTRF__c > ();
            PTRF__c objPTRF = new PTRF__c(Name = 'PTRF101', Order_Type__c = 'New Prototype', Recticle_Type__c = 'Single Layer Reticle (SLR)', MaskSetTitle__c = objMST.Id, Customer__c = acc.id, Tech_Geo_Value__c = '0.01UM', Customer_jobview__c = 'Not gating mask release', Foundry_jobview__c = 'Not gating mask release');
            ptrflst.add(objPTRF);
            insert ptrflst;
            List < PTRF_JobViewer_Info__c > listPTRFJVI = new List < PTRF_JobViewer_Info__c > ();
            List < PTRF_JobViewer_Info__c > listPTRFJVIQueried = new List < PTRF_JobViewer_Info__c > ();
            PTRF_JobViewer_Info__c objPTRFJVC = new PTRF_JobViewer_Info__c(Name = 'SAC', PTRF__c = ptrflst.get(0).Id, Jobview__c = 'Customer', Jobview_Type__c = 'Frame Mockup;Prime GDSOUT Review;MEBES Jobview', User__c = userSA.Id);
            PTRF_JobViewer_Info__c objPTRFJVF = new PTRF_JobViewer_Info__c(Name = 'SAF', PTRF__c = ptrflst.get(0).Id, Jobview__c = 'Foundry', Jobview_Type__c = 'Frame Mockup;Prime GDSOUT Review;MEBES Jobview', User__c = userSA.Id);
            PTRF_JobViewer_Info__c objPTRFJVC2 = new PTRF_JobViewer_Info__c(Name = 'SAC2', PTRF__c = ptrflst.get(0).Id, Jobview__c = 'Customer', Jobview_Type__c = 'Frame Mockup;Prime GDSOUT Review;MEBES Jobview', User__c = userSA.Id);
            PTRF_JobViewer_Info__c objPTRFJVF2 = new PTRF_JobViewer_Info__c(Name = 'SAF2', PTRF__c = ptrflst.get(0).Id, Jobview__c = 'Foundry', Jobview_Type__c = 'Frame Mockup;Prime GDSOUT Review;MEBES Jobview', User__c = userSA.Id);
            listPTRFJVI.add(objPTRFJVC);
            listPTRFJVI.add(objPTRFJVF);
            listPTRFJVI.add(objPTRFJVC2);
            listPTRFJVI.add(objPTRFJVF2);
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
            MRS_Layer_Chip_Association__c objMRSLCA1 = new MRS_Layer_Chip_Association__c(Layer__c = objMRSLA1.Id, Chip__c = objMRSCD1.Id, PTRF__c = ptrflst.get(0).Id, Device_Id__c = '1', Layer_Chip_Status__c = 'In Progress', Customer_Name__c = acc.Id, Tapeout_Applications_MEBES_Jobview__c = 'Ready', Customer_MEBES_Jobview__c = 'N.A.', Foundry_MEBES_Jobview__c = 'N.A.');
            MRS_Layer_Chip_Association__c objMRSLCA2 = new MRS_Layer_Chip_Association__c(Layer__c = objMRSLA1.Id, Chip__c = objMRSCD2.Id, PTRF__c = ptrflst.get(0).Id, Device_Id__c = '1', Layer_Chip_Status__c = 'In Progress', Customer_Name__c = acc.Id, Tapeout_Applications_MEBES_Jobview__c = 'Ready', Customer_MEBES_Jobview__c = 'N.A.', Foundry_MEBES_Jobview__c = 'N.A.');
            MRS_Layer_Chip_Association__c objMRSLCA3 = new MRS_Layer_Chip_Association__c(Layer__c = objMRSLA2.Id, Chip__c = objMRSCD1.Id, PTRF__c = ptrflst.get(0).Id, Device_Id__c = '1', Layer_Chip_Status__c = 'In Progress', Customer_Name__c = acc.Id, Tapeout_Applications_MEBES_Jobview__c = 'Ready', Customer_Prime_Remote_Jobview_Setup__c = 'Done', Foundry_Prime_Remote_Jobview_Setup__c = 'Done', Customer_MEBES_Jobview__c = 'N.A.', Foundry_MEBES_Jobview__c = 'N.A.');
            MRS_Layer_Chip_Association__c objMRSLCA4 = new MRS_Layer_Chip_Association__c(Layer__c = objMRSLA2.Id, Chip__c = objMRSCD2.Id, PTRF__c = ptrflst.get(0).Id, Device_Id__c = '1', Layer_Chip_Status__c = 'In Progress', Customer_Name__c = acc.Id, Tapeout_Applications_MEBES_Jobview__c = 'Ready', Customer_Prime_Remote_Jobview_Setup__c = 'Done', Foundry_Prime_Remote_Jobview_Setup__c = 'Done', Customer_MEBES_Jobview__c = 'N.A.', Foundry_MEBES_Jobview__c = 'N.A.');
            MRS_Layer_Chip_Association__c objMRSLCA5 = new MRS_Layer_Chip_Association__c(Layer__c = objMRSLA1.Id, Chip__c = objMRSCD3.Id, PTRF__c = ptrflst.get(0).Id, Device_Id__c = '1', Layer_Chip_Status__c = 'In Progress', Customer_Name__c = acc.Id, Tapeout_Applications_MEBES_Jobview__c = 'Ready', Customer_Prime_Remote_Jobview_Setup__c = 'Done', Foundry_Prime_Remote_Jobview_Setup__c = 'Done', Customer_MEBES_Jobview__c = 'N.A.', Foundry_MEBES_Jobview__c = 'N.A.');
            //MRS_Layer_Chip_Association__c objMRSLCA6 = new MRS_Layer_Chip_Association__c(Layer__c=objMRSLA2.Id,Chip__c=objMRSCD3.Id,PTRF__c=objPTRF.Id,Tech_Geo__c='0.019UM',Device_Id__c='1',Layer_Chip_Status__c='In Progress',Customer_Name__c=acc.Id,Tapeout_Applications_MEBES_Jobview__c= 'Ready');
            listMRSLCA.add(objMRSLCA1);
            listMRSLCA.add(objMRSLCA2);
            listMRSLCA.add(objMRSLCA3);
            listMRSLCA.add(objMRSLCA4);
            listMRSLCA.add(objMRSLCA5);
            insert listMRSLCA;

            //LIST<MRS_Layer_Chip_Association__c> mrsLayerChiplst =[SELECT PTRF__r.Customer_Jobview__c,PTRF__r.Foundry_Jobview__c,PTRF__r.Tech_Geo__c,Layer__c,PTRF__c,Chip__c,Layer_Chip_Status__c,Customer_Name__c,Tapeout_Applications_MEBES_Jobview__c,PTRF__r.Order_Type__c,PTRF__r.Customer_Short_Name__c,PTRF__r.Process_Technology_Lifecycle_Phase__c,Chip__r.Name,Layer__r.Name,Layer__r.Mask_Rev__c FROM MRS_Layer_Chip_Association__c WHERE Id IN :listMRSLCA];
            List < MRS_Layer_Chip_Association__c > mrsLayerChiplst = [select PTRF__r.Tech_Geo__c, Layer_Name__c, lastmodifieddate_sgt__c,
            Tech_Geo__c,
            Tapeout_Centre_MEBES_Jobview__c,
            Tapeout_Centre_MEBES_Jobview_Date__c,
            Tapeout_Applications_MEBES_Jobview__c,
            Tapeout_Applications_MEBES_Jobview_Date__c,
            TDTI_MPW_MEBES_Jobview__c,
            TDTI_MPW_MEBES_Date__c,
            Send_Prime_Data__c,
            Send_Prime_Data_Date__c,
            Send_Frame_Data__c,
            Send_Frame_Data_Date__c,
            Rev__c,
            ROM_Code__c,
            Prime_TapeOut__c,
            Prime_MEBES_Received__c,
            Prime_MEBES_Received_Date__c,
            PTRF__c,
            PTRF_Number__c,
            ORC__c,
            ORC_Date__c,
            Name,
            Mask_Set_Title_Name__c,
            Mask_Layer__c,
            Mask_Layer_Status__c,
            MST__c,
            MDP_MEBES_Jobview__c,
            MDP_MEBES_Jobview_Date__c,
            Layer__r.Mask_Layer_Rev__c,
            Layer__r.ROM_Code__c,
            PTRF__r.Customer_jobview__c,
            PTRF__r.Foundry_Jobview__c,
            PTRF__r.Order_Type__c,
            PTRF__r.MaskSetTitle__c,
            PTRF__r.MaskSetTitle__r.Name,
            Customer_Name__r.Name,
            PTRF__r.Name,
            Chip__r.Name,
            Layer__r.Name,
            Customer_Name__r.Short_Name__c,
            Layer_Send_Prime_Data__c,
            Layer_Send_Frame_Data__c,

            Layer_Chip_Status__c,
            Layer_Chip_Status_Date__c,
            Layer_Chip_Old_Status__c,
            Last_Sync_Req_Timestamp__c,
            Last_Sync_Req_Timestamp_Send_Prime__c,
            Last_Sync_Req_Timestamp_Send_Frame__c,
            Last_Sync_Req_Timestamp_Remote_Jobview__c,
            Last_Sync_Req_Timestamp_Receive_MEBES__c,
            Last_Sync_Req_Timestamp_ORCN_Job__c,
            Last_Sync_Req_Timestamp_Layer_Gen__c,
            Is_Tapeout_Centre_MEBES_Jobview_Updated__c,
            Is_Tapeout_Apps_MEBES_Jobview_Updated__c,
            Is_TDTI_MPW_MEBES_Jobview_Updated__c,
            Is_Send_Prime_Data_Updated__c,
            Is_Send_Frame_Data_Updated__c,
            Is_Prime_MEBES_Received_Updated__c,
            Is_ORC_Updated__c,
            Is_MDP_MEBES_Jobview_Updated__c,
            Is_GlobalShuttle_MEBES_Jobview_Updated__c,
            Is_Frame_MEBES_Received_Updated__c,
            Is_Foundry_Prime_Remote_Jobview_Updated__c,
            Is_Foundry_MEBES_Jobview_Updated__c,
            Is_Foundry_GDSOUT_Review_Updated__c,
            Is_Foundry_Frame_Remote_Jobview_Updated__c,
            Is_Foundry_Frame_Mockup_Updated__c,
            Is_DRW_Updated__c,
            Is_Customer_Prime_Remote_Jobview_Updated__c,
            Is_Customer_MEBES_Jobview_Updated__c,
            Is_Customer_GDSOUT_Review_Updated__c,
            Is_Customer_Frame_Remote_Jobview_Updated__c,
            Is_Customer_Frame_Mockup_Updated__c,
            Is_Active__c,
            IsDeleted,
            Id,
            GlobalShuttle_MEBES_Jobview__c,
            GlobalShuttle_MEBES_Jobview_Date__c,
            Frame_TapeOut__c,
            Frame_MEBES_Received__c,
            Frame_MEBES_Received_Date__c,
            Foundry_Prime_Remote_Jobview_Setup__c,
            Foundry_Prime_Remote_Jobview_Setup_Date__c,
            Foundry_MEBES_Jobview__c,
            Foundry_MEBES_Jobview_Date__c,
            Foundry_GDSOUT_Review__c,
            Foundry_GDSOUT_Review_Date__c,
            Foundry_Frame_Remote_Jobview_Setup__c,
            Foundry_Frame_Remote_Jobview_Setup_Date__c,
            Foundry_Frame_Mockup__c,
            Foundry_Frame_Mockup_Date__c,
            Customer_Prime_Remote_Jobview_Setup__c,
            Customer_Prime_Remote_Jobview_Setup_Date__c,
            Customer_Name__c,
            Customer_MEBES_Jobview__c,
            Customer_MEBES_Jobview_Date__c,
            Customer_GDSOUT_Review__c,
            Customer_GDSOUT_Review_Date__c,
            Customer_Frame_Remote_Jobview_Setup__c,
            Customer_Frame_Remote_Jobview_Setup_Date__c,
            Customer_Frame_Mockup__c,
            Customer_Frame_Mockup_Date__c,
            Chip__c, DRW__c,
            Chip_Name__c, PTRF__r.Process_Technology_Lifecycle_Phase__c,
            PTRF__r.Customer_Short_Name__c
            FROM MRS_Layer_Chip_Association__c WHERE Id IN: listMRSLCA];
            MRSHandlerUtility.sendDoneEmailtoRemoteJobView(mrsLayerChiplst, 'Test String', true, true, 'Test String');
            MRSHandlerUtility.sendEmailForRemoteJobViewToReviewersSubsequently(mrsLayerChiplst, 'Test String', 'Test String', 'Testtt', true, true);
            Test.stopTest();

        }
    }
    
    private static testMethod void testDummyMethod(){
        Test.startTest();
        
        MRSHandlerUtility service = new MRSHandlerUtility();
        //Integer a = service.mthdDummy();
        //Integer b = service.mthdDummy2();
        
        Test.stopTest();
    }
}