/*
Type Name: MRSAuditTrailTest
Author: Cognizant
Created Date: 30-May-2014
Reason: Test class for MRSAuditTrail Controller
Change History:
Author:
Modified Date:
Reason:
Author: Cognizant Technology Solutions
Modified Date:
*/


@isTest(seeAllData=true)
public class MRSAuditTrailTest {

    public static List < String > ProcessRows(List < MRS_Layer_Chip_Association__History > historyList) {
            List < String > results = new List < String > ();
            for (MRS_Layer_Chip_Association__History hist: historyList) {
                String field = hist.field;
                Object oldValue = hist.oldValue;
                Object newValue = hist.newValue;

                results.add(field + '|' + oldValue + '|' + newValue);
            }

            return results;
        }

    /**
        This test method tests the method which will be called for MRS Layer Chip Association object
        @method name: controllerConstructor1
        @parameter:   none.
        @return :     None.
     **/

    public static testMethod void controllerConstructor1() {

        User sysAdminUser = [SELECT Id, Name FROM User WHERE Profile.Name = 'System Administrator'
        AND isActive = true].get(0);
        System.runAs(sysAdminUser) {


            test.starttest();
            MRS_Layer_Chip_Association__History HistObj = [SELECT Id, ParentId FROM MRS_Layer_Chip_Association__History limit 1];
            MRS_Layer_Association__History HistObjLA = [SELECT ParentId FROM MRS_Layer_Association__History limit 1];

            List < MRS_Layer_Chip_Association__History > lstLayerChipAssoHistory = [SELECT CreatedBy.Name, CreatedById, CreatedDate, Field, NewValue, OldValue, ParentId FROM MRS_Layer_Chip_Association__History where ParentId = : HistObj.ParentId];

            List < MRS_Layer_Chip_Association__History > lstLayerChipAssoHistory1 = [SELECT CreatedBy.Name, CreatedById, CreatedDate, Field, NewValue, OldValue, ParentId FROM MRS_Layer_Chip_Association__History
            where Field in ('Last_Sync_Request_Timestamp__c,LastReferencedDate__c,Foundry_GDSOUT_Review_Date__c,Customer_Frame_Mockup_Date__c,SystemModstamp,Foundry_Prime_Remote_Jobview_Setup_Date__c,lastmodifieddate_sgt__c,CreatedDate,Customer_Prime_Remote_Jobview_Setup_Date__c,GlobalShuttle_MEBES_Jobview_Date__c,LastViewedDate,TDTI_MPW_MEBES_Jobview_Date__c,Send_Frame_Data_Date__c,Send_Prime_Data_Date__c,Customer_MEBES_Jobview_Date__c,Tapeout_Applications_MEBES_Jobview_Date__c,Foundry_MEBES_Jobview_Date__c,LastModifiedDate,Frame_MEBES_Received_Date__c,ORC_Date__c,LastReferencedDate,MDP_MEBES_Jobview_Date__c,DRW_Date__c,Tapeout_Centre_MEBES_Jobview_Date__c,Foundry_Frame_Mockup_Date__c,Customer_Frame_Remote_Jobview_Setup_Date__c,Foundry_Frame_Remote_Jobview_Setup_Date__c,Prime_MEBES_Received_Date__c,Customer_GDSOUT_Review_Date__c,Layer_Status_Date__c,Customer_MEBES_Jobview__c,Foundry_MEBES_Jobview__c,Tapeout_Centre_MEBES_Jobview__c,Tapeout_Applications_MEBES_Jobview__c,GlobalShuttle_MEBES_Jobview__c,MDP_MEBES_Jobview__c,TDTI_MPW_MEBES_Jobview__c,Customer_Frame_Mockup__c,Foundry_Frame_Mockup__c,Customer_GDSOUT_Review__c,Foundry_GDSOUT_Review__c,Synced_with_Oracle_DB__c,ORC__c,DRW__c,Customer_Prime_Remote_Jobview_Setup__c,Customer_Frame_Remote_Jobview_Setup__c,Foundry_Prime_Remote_Jobview_Setup__c,Foundry_Frame_Remote_Jobview_Setup__c,Prime_MEBES_Received__c,Frame_MEBES_Received__c') LIMIT 1000];
            lstLayerChipAssoHistory.addAll(lstLayerChipAssoHistory1);

            if ([Select Id from MRS_Layer_Chip_Association__c where Customer_MEBES_Jobview__c = : 'Released'
            and CustomerMebesJobViewApprover__c != null limit 1].size() > 0) {
                MRS_Layer_Chip_Association__c LCA1 = [Select Id from MRS_Layer_Chip_Association__c where Customer_MEBES_Jobview__c = : 'Released'
                and CustomerMebesJobViewApprover__c != null limit 1];
                lstLayerChipAssoHistory.addAll([SELECT CreatedBy.Name, CreatedById, CreatedDate, Field, NewValue, OldValue, ParentId FROM MRS_Layer_Chip_Association__History
                where Field = : 'Customer_MEBES_Jobview__c'
                and ParentId = : LCA1.Id]);
            }

            if ([Select Id from MRS_Layer_Chip_Association__c where Foundry_MEBES_Jobview__c = : 'Released'
            and FoundryMebesJobViewApprover__c != null limit 1].size() > 0) {
                MRS_Layer_Chip_Association__c LCA2 = [Select Id from MRS_Layer_Chip_Association__c where Foundry_MEBES_Jobview__c = : 'Released'
                and FoundryMebesJobViewApprover__c != null limit 1];

                lstLayerChipAssoHistory.addAll([SELECT CreatedBy.Name, CreatedById, CreatedDate, Field, NewValue, OldValue, ParentId FROM MRS_Layer_Chip_Association__History
                where Field = : 'Foundry_MEBES_Jobview__c'
                and ParentId = : LCA2.Id]);
            }

            if ([Select Id from MRS_Layer_Chip_Association__c where Tapeout_Centre_MEBES_Jobview__c = : 'Released'
            and TapeoutCentreMebesJobViewApprover__c != null limit 1].size() > 0) {
                MRS_Layer_Chip_Association__c LCA3 = [Select Id from MRS_Layer_Chip_Association__c where Tapeout_Centre_MEBES_Jobview__c = : 'Released'
                and TapeoutCentreMebesJobViewApprover__c != null limit 1];
                lstLayerChipAssoHistory.addAll([SELECT CreatedBy.Name, CreatedById, CreatedDate, Field, NewValue, OldValue, ParentId FROM MRS_Layer_Chip_Association__History
                where Field = : 'Tapeout_Centre_MEBES_Jobview__c'
                and ParentId = : LCA3.Id]);
            }

            if ([Select Id from MRS_Layer_Chip_Association__c where Tapeout_Applications_MEBES_Jobview__c = : 'Released'
            and TapeoutApplicationsMebesJobviewApprover__c != null limit 1].size() > 0) {
                MRS_Layer_Chip_Association__c LCA4 = [Select Id from MRS_Layer_Chip_Association__c where Tapeout_Applications_MEBES_Jobview__c = : 'Released'
                and TapeoutApplicationsMebesJobviewApprover__c != null limit 1];
                lstLayerChipAssoHistory.addAll([SELECT CreatedBy.Name, CreatedById, CreatedDate, Field, NewValue, OldValue, ParentId FROM MRS_Layer_Chip_Association__History
                where Field = : 'Tapeout_Applications_MEBES_Jobview__c'
                and ParentId = : LCA4.Id]);

            }

            if ([Select Id from MRS_Layer_Chip_Association__c where GlobalShuttle_MEBES_Jobview__c = : 'Released'
            and GlobalShuttleMebesJobviewApprover__c != null limit 1].size() > 0) {
                MRS_Layer_Chip_Association__c LCA5 = [Select Id from MRS_Layer_Chip_Association__c where GlobalShuttle_MEBES_Jobview__c = : 'Released'
                and GlobalShuttleMebesJobviewApprover__c != null limit 1];
                lstLayerChipAssoHistory.addAll([SELECT CreatedBy.Name, CreatedById, CreatedDate, Field, NewValue, OldValue, ParentId FROM MRS_Layer_Chip_Association__History
                where Field = : 'GlobalShuttle_MEBES_Jobview__c'
                and ParentId = : LCA5.Id]);

            }

            if ([Select Id from MRS_Layer_Chip_Association__c where MDP_MEBES_Jobview__c = : 'Released'
            and MDPMebesJobviewApprover__c != null limit 1].size() > 0) {
                MRS_Layer_Chip_Association__c LCA6 = [Select Id from MRS_Layer_Chip_Association__c where MDP_MEBES_Jobview__c = : 'Released'
                and MDPMebesJobviewApprover__c != null limit 1];
                lstLayerChipAssoHistory.addAll([SELECT CreatedBy.Name, CreatedById, CreatedDate, Field, NewValue, OldValue, ParentId FROM MRS_Layer_Chip_Association__History
                where Field = : 'MDP_MEBES_Jobview__c'
                and ParentId = : LCA6.Id]);
            }
            if ([Select Id from MRS_Layer_Chip_Association__c where TDTI_MPW_MEBES_Jobview__c = : 'Released'
            and TDTIMPWMebesJobviewApprover__c != null limit 1].size() > 0) {
                MRS_Layer_Chip_Association__c LCA7 = [Select Id from MRS_Layer_Chip_Association__c where TDTI_MPW_MEBES_Jobview__c = : 'Released'
                and TDTIMPWMebesJobviewApprover__c != null limit 1];
                lstLayerChipAssoHistory.addAll([SELECT CreatedBy.Name, CreatedById, CreatedDate, Field, NewValue, OldValue, ParentId FROM MRS_Layer_Chip_Association__History
                where Field = : 'TDTI_MPW_MEBES_Jobview__c'
                and ParentId = : LCA7.Id]);
            }


            if ([Select Id from MRS_Layer_Chip_Association__c where Customer_Frame_Mockup__c = : 'Approve'
            and CustomerFrameMockupApprover__c != null limit 1].size() > 0) {
                MRS_Layer_Chip_Association__c LCA8 = [Select Id from MRS_Layer_Chip_Association__c where Customer_Frame_Mockup__c = : 'Approve'
                and CustomerFrameMockupApprover__c != null limit 1];
                lstLayerChipAssoHistory.addAll([SELECT CreatedBy.Name, CreatedById, CreatedDate, Field, NewValue, OldValue, ParentId FROM MRS_Layer_Chip_Association__History
                where Field = : 'Customer_Frame_Mockup__c'
                and ParentId = : LCA8.Id]);
            }

            if ([Select Id from MRS_Layer_Chip_Association__c where Foundry_Frame_Mockup__c = : 'Approve'
            and FoundryFrameMockupApprover__c != null limit 1].size() > 0) {
                MRS_Layer_Chip_Association__c LCA9 = [Select Id from MRS_Layer_Chip_Association__c where Customer_Frame_Mockup__c = : 'Approve'
                and FoundryFrameMockupApprover__c != null limit 1];
                lstLayerChipAssoHistory.addAll([SELECT CreatedBy.Name, CreatedById, CreatedDate, Field, NewValue, OldValue, ParentId FROM MRS_Layer_Chip_Association__History
                where Field = : 'Foundry_Frame_Mockup__c'
                and ParentId = : LCA9.Id]);
            }

            if ([Select Id from MRS_Layer_Chip_Association__c where Customer_GDSOUT_Review__c = : 'Approve'
            and CustomerGDSOUTReviewApprover__c != null limit 1].size() > 0) {
                MRS_Layer_Chip_Association__c LCA10 = [Select Id from MRS_Layer_Chip_Association__c where Customer_GDSOUT_Review__c = : 'Approve'
                and CustomerGDSOUTReviewApprover__c != null limit 1];
                lstLayerChipAssoHistory.addAll([SELECT CreatedBy.Name, CreatedById, CreatedDate, Field, NewValue, OldValue, ParentId FROM MRS_Layer_Chip_Association__History
                where Field = : 'Customer_GDSOUT_Review__c'
                and ParentId = : LCA10.Id]);
            }


            if ([Select Id from MRS_Layer_Chip_Association__c where Foundry_GDSOUT_Review__c = : 'Approve'
            and FoundryGDSOUTReviewApprover__c != null limit 1].size() > 0) {
                MRS_Layer_Chip_Association__c LCA11 = [Select Id from MRS_Layer_Chip_Association__c where Foundry_GDSOUT_Review__c = : 'Approve'
                and FoundryGDSOUTReviewApprover__c != null limit 1];
                lstLayerChipAssoHistory.addAll([SELECT CreatedBy.Name, CreatedById, CreatedDate, Field, NewValue, OldValue, ParentId FROM MRS_Layer_Chip_Association__History
                where Field = : 'Foundry_GDSOUT_Review__c'
                and ParentId = : LCA11.Id]);
            }


            if ([Select Id from MRS_Layer_Chip_Association__c where Synced_with_Oracle_DB__c = true limit 1].size() > 0) {
                MRS_Layer_Chip_Association__c LCA12 = [Select Id from MRS_Layer_Chip_Association__c where Synced_with_Oracle_DB__c = true limit 1];
                lstLayerChipAssoHistory.addAll([SELECT CreatedBy.Name, CreatedById, CreatedDate, Field, NewValue, OldValue, ParentId FROM MRS_Layer_Chip_Association__History
                where Field = : 'Synced_with_Oracle_DB__c'
                and ParentId = : LCA12.Id]);
            }

            if ([Select Id from MRS_Layer_Chip_Association__c where Send_Prime_Data__c = : 'Not Done'
            limit 1].size() > 0) {
                MRS_Layer_Chip_Association__c LCA13 = [Select Id from MRS_Layer_Chip_Association__c where Send_Prime_Data__c = : 'Not Done'
                limit 1];
                lstLayerChipAssoHistory.addAll([SELECT CreatedBy.Name, CreatedById, CreatedDate, Field, NewValue, OldValue, ParentId FROM MRS_Layer_Chip_Association__History
                where Field = : 'Send_Prime_Data__c'
                and ParentId = : LCA13.Id]);
            }

            MRS_Layer_Chip_Association__History hist = new MRS_Layer_Chip_Association__History(Field = 'Layer_Chip_Status__c');
            lstLayerChipAssoHistory.add(hist);

            MRS_Layer_Chip_Association__History hist1 = new MRS_Layer_Chip_Association__History(Field = 'Send_Frame_Data__c');
            lstLayerChipAssoHistory.add(hist1);

            MRS_Layer_Chip_Association__History hist2 = new MRS_Layer_Chip_Association__History(Field = 'Synced_with_Oracle_DB__c');
            lstLayerChipAssoHistory.add(hist2);

            MRS_Layer_Chip_Association__History hist3 = new MRS_Layer_Chip_Association__History(Field = 'Send_Prime_Data__c');
            lstLayerChipAssoHistory.add(hist3);


            MRS_Layer_Chip_Association__History hist4 = new MRS_Layer_Chip_Association__History(Field = 'Chip_Hold_Warning__c');
            lstLayerChipAssoHistory.add(hist4);


            MRS_Layer_Chip_Association__History hist5 = new MRS_Layer_Chip_Association__History(Field = 'Customer_MEBES_Jobview__c');
            lstLayerChipAssoHistory.add(hist5);


            MRS_Layer_Chip_Association__History hist6 = new MRS_Layer_Chip_Association__History(Field = 'Foundry_MEBES_Jobview__c');
            lstLayerChipAssoHistory.add(hist6);


            MRS_Layer_Chip_Association__History hist7 = new MRS_Layer_Chip_Association__History(Field = 'Tapeout_Centre_MEBES_Jobview__c');
            lstLayerChipAssoHistory.add(hist7);


            MRS_Layer_Chip_Association__History hist8 = new MRS_Layer_Chip_Association__History(Field = 'Tapeout_Applications_MEBES_Jobview__c');
            lstLayerChipAssoHistory.add(hist8);


            MRS_Layer_Chip_Association__History hist9 = new MRS_Layer_Chip_Association__History(Field = 'GlobalShuttle_MEBES_Jobview__c');
            lstLayerChipAssoHistory.add(hist9);


            MRS_Layer_Chip_Association__History hist10 = new MRS_Layer_Chip_Association__History(Field = 'MDP_MEBES_Jobview__c');
            lstLayerChipAssoHistory.add(hist10);

            MRS_Layer_Chip_Association__History hist11 = new MRS_Layer_Chip_Association__History(Field = 'TDTI_MPW_MEBES_Jobview__c');
            lstLayerChipAssoHistory.add(hist11);

            MRS_Layer_Chip_Association__History hist12 = new MRS_Layer_Chip_Association__History(Field = 'Customer_Frame_Mockup__c');
            lstLayerChipAssoHistory.add(hist12);


            MRS_Layer_Chip_Association__History hist13 = new MRS_Layer_Chip_Association__History(Field = 'Foundry_Frame_Mockup__c');
            lstLayerChipAssoHistory.add(hist13);

            MRS_Layer_Chip_Association__History hist14 = new MRS_Layer_Chip_Association__History(Field = 'Customer_GDSOUT_Review__c');
            lstLayerChipAssoHistory.add(hist14);


            MRS_Layer_Chip_Association__History hist15 = new MRS_Layer_Chip_Association__History(Field = 'Foundry_GDSOUT_Review__c');
            lstLayerChipAssoHistory.add(hist15);

            MRS_Layer_Chip_Association__History hist16 = new MRS_Layer_Chip_Association__History(Field = 'ORC__c');
            lstLayerChipAssoHistory.add(hist16);

            MRS_Layer_Chip_Association__History hist17 = new MRS_Layer_Chip_Association__History(Field = 'DRW__c');
            lstLayerChipAssoHistory.add(hist17);


            MRS_Layer_Chip_Association__History hist18 = new MRS_Layer_Chip_Association__History(Field = 'Customer_Prime_Remote_Jobview_Setup__c');
            lstLayerChipAssoHistory.add(hist18);


            MRS_Layer_Chip_Association__History hist19 = new MRS_Layer_Chip_Association__History(Field = 'Customer_Frame_Remote_Jobview_Setup__c');
            lstLayerChipAssoHistory.add(hist19);

            MRS_Layer_Chip_Association__History hist20 = new MRS_Layer_Chip_Association__History(Field = 'Foundry_Prime_Remote_Jobview_Setup__c');
            lstLayerChipAssoHistory.add(hist20);

            MRS_Layer_Chip_Association__History hist21 = new MRS_Layer_Chip_Association__History(Field = 'Foundry_Frame_Remote_Jobview_Setup__c');
            lstLayerChipAssoHistory.add(hist21);

            MRS_Layer_Chip_Association__History hist22 = new MRS_Layer_Chip_Association__History(Field = 'Prime_MEBES_Received__c');
            lstLayerChipAssoHistory.add(hist22);


            MRS_Layer_Chip_Association__History hist23 = new MRS_Layer_Chip_Association__History(Field = 'Frame_MEBES_Received__c');
            lstLayerChipAssoHistory.add(hist23);


            List < String > results = processRows(lstLayerChipAssoHistory);

            MRS_Layer_Chip_Association__c objMLCA = [select Layer__c from MRS_Layer_Chip_Association__c where Id = : HistObj.ParentId];


            objMLCA.Layer_Chip_Status__c = 'Hold';
            objMLCA.Chip_Hold_Warning__c = 'Hold Warning Acknowledge';
            update objMLCA;

            List < MRS_Layer_Association__History > lstLayerAssoHistory = [SELECT CreatedBy.Name, CreatedById, CreatedDate, Field, NewValue, OldValue, ParentId FROM MRS_Layer_Association__History where ParentId = : HistObjLA.ParentId];
            List < Notes__c > lstLayerAssoNotes = new List < Notes__c > ();
            lstLayerAssoNotes = [SELECT CreatedDate, CreatedById, Body__c from Notes__c where ParentId__c = : HistObj.ParentId and MRS_Layer_Association__c = null and Category__c = 'Hold Chip'
            ORDER BY CreatedDate desc];
            Notes__c objNotes = new Notes__c();
            objNotes.ParentId__c = HistObj.ParentId;
            objNotes.MRS_Layer_Association__c = null;
            objNotes.Category__c = 'Hold Chip';

            insert objNotes;

            List < MRSAuditTrail.AuditTrail > lstWrapperAuditTrail = new List < MRSAuditTrail.AuditTrail > ();
            MRSAuditTrail.AuditTrail var2 = new MRSAuditTrail.AuditTrail('29/08/2014 10:10:10', 'System User', 'Test description', 'Tapeout_Centre_MEBES_Jobview__c', 'Not Ready', 'Redady', '', '');
            lstWrapperAuditTrail.add(var2);


            MRSAuditTrail.AuditTrail var3 = new MRSAuditTrail.AuditTrail('29/08/2014 10:10:10', 'System User', 'Test description', 'Prime_MEBES_Received__c', 'Not Ready', 'Redady', '', '');
            lstWrapperAuditTrail.add(var3);

            Test.setCurrentPage(Page.VFMRSAuditTrail);
            ApexPages.currentPage().getParameters().put('PageName', 'LayerChipSummary');
            ApexPages.currentPage().getParameters().put('id', HistObj.ParentId);
            ApexPages.currentPage().getParameters().put('LayerId', objMLCA.Layer__c);
            ApexPages.currentPage().getHeaders().put('Host', system.Label.Internal_URL);
            MRSAuditTrail objAuditTrail1 = new MRSAuditTrail();
            objAuditTrail1.recordid = HistObj.ParentId;
            MRSAuditTrail.sortby = '1';
            objAuditTrail1.layerid = HistObj.Id; //objMLCA.Layer__c;

            objAuditTrail1.PageName = 'LayerChipSummary';

            objAuditTrail1.ListOfDateTimeFields = 'Last_Sync_Request_Timestamp__c,LastReferencedDate__c,Foundry_GDSOUT_Review_Date__c,Customer_Frame_Mockup_Date__c,SystemModstamp,Foundry_Prime_Remote_Jobview_Setup_Date__c,lastmodifieddate_sgt__c,CreatedDate,Customer_Prime_Remote_Jobview_Setup_Date__c,GlobalShuttle_MEBES_Jobview_Date__c,LastViewedDate,TDTI_MPW_MEBES_Jobview_Date__c,Send_Frame_Data_Date__c,Send_Prime_Data_Date__c,Customer_MEBES_Jobview_Date__c,Tapeout_Applications_MEBES_Jobview_Date__c,Foundry_MEBES_Jobview_Date__c,LastModifiedDate,Frame_MEBES_Received_Date__c,ORC_Date__c,LastReferencedDate,MDP_MEBES_Jobview_Date__c,DRW_Date__c,Tapeout_Centre_MEBES_Jobview_Date__c,Foundry_Frame_Mockup_Date__c,Customer_Frame_Remote_Jobview_Setup_Date__c,Foundry_Frame_Remote_Jobview_Setup_Date__c,Prime_MEBES_Received_Date__c,Customer_GDSOUT_Review_Date__c,Layer_Status_Date__c';

            //objAuditTrail1.PopulateAuditHistoryLayerChipAssociation(lstLayerChipAssoHistory);
            List < MRS_Layer_Chip_Association__History > lstLayerChipAssoHistoryAfterTest = [SELECT CreatedById, CreatedDate, Field, NewValue, OldValue, ParentId FROM MRS_Layer_Chip_Association__History where ParentId = : HistObj.ParentId];

            system.assertNotEquals(1, lstLayerChipAssoHistoryAfterTest.size());
            test.stoptest();
        }

    }


    public static testMethod void controllerConstructor6() {

        User sysAdminUser = [SELECT Id, Name FROM User WHERE Profile.Name = 'System Administrator'
        AND isActive = true].get(0);
        System.runAs(sysAdminUser) {

            test.starttest();

            MRS_Layer_Chip_Association__History HistObj = [SELECT Id, ParentId FROM MRS_Layer_Chip_Association__History limit 1];
            MRS_Layer_Association__History HistObjLA = [SELECT ParentId FROM MRS_Layer_Association__History limit 1];

            List < MRS_Layer_Chip_Association__History > lstLayerChipAssoHistory = [SELECT CreatedBy.Name, CreatedById, CreatedDate, Field, NewValue, OldValue, ParentId FROM MRS_Layer_Chip_Association__History where ParentId = : HistObj.ParentId];

            MRS_Layer_Chip_Association__c objMLCA = [select Layer__c from MRS_Layer_Chip_Association__c where Id = : HistObj.ParentId];

            List < MRS_Layer_Chip_Association__History > lstLayerChipAssoHistory1 = [SELECT CreatedBy.Name, CreatedById, CreatedDate, Field, NewValue, OldValue, ParentId FROM MRS_Layer_Chip_Association__History LIMIT 1000];
            lstLayerChipAssoHistory.addAll(lstLayerChipAssoHistory1);

            if ([Select Id from MRS_Layer_Chip_Association__c where Customer_MEBES_Jobview__c = : 'Ready'
            and CustomerMebesJobViewApprover__c = null limit 1].size() > 0) {
                MRS_Layer_Chip_Association__c LCA1 = [Select Id from MRS_Layer_Chip_Association__c where Customer_MEBES_Jobview__c = : 'Ready'
                and CustomerMebesJobViewApprover__c = null limit 1];
                lstLayerChipAssoHistory.addAll([SELECT CreatedBy.Name, CreatedById, CreatedDate, Field, NewValue, OldValue, ParentId FROM MRS_Layer_Chip_Association__History
                where Field = : 'Customer_MEBES_Jobview__c'
                and ParentId = : LCA1.Id]);
            }

            if ([Select Id from MRS_Layer_Chip_Association__c where Foundry_MEBES_Jobview__c = : 'Ready'
            and FoundryMebesJobViewApprover__c = null limit 1].size() > 0) {
                MRS_Layer_Chip_Association__c LCA2 = [Select Id from MRS_Layer_Chip_Association__c where Foundry_MEBES_Jobview__c = : 'Released'
                and FoundryMebesJobViewApprover__c != null limit 1];

                lstLayerChipAssoHistory.addAll([SELECT CreatedBy.Name, CreatedById, CreatedDate, Field, NewValue, OldValue, ParentId FROM MRS_Layer_Chip_Association__History
                where Field = : 'Foundry_MEBES_Jobview__c'
                and ParentId = : LCA2.Id]);
            }

            if ([Select Id from MRS_Layer_Chip_Association__c where Tapeout_Centre_MEBES_Jobview__c = : 'Ready'
            and TapeoutCentreMebesJobViewApprover__c = null limit 1].size() > 0) {
                MRS_Layer_Chip_Association__c LCA3 = [Select Id from MRS_Layer_Chip_Association__c where Tapeout_Centre_MEBES_Jobview__c = : 'Ready'
                and TapeoutCentreMebesJobViewApprover__c = null limit 1];
                lstLayerChipAssoHistory.addAll([SELECT CreatedBy.Name, CreatedById, CreatedDate, Field, NewValue, OldValue, ParentId FROM MRS_Layer_Chip_Association__History
                where Field = : 'Tapeout_Centre_MEBES_Jobview__c'
                and ParentId = : LCA3.Id]);
            }

            if ([Select Id from MRS_Layer_Chip_Association__c where Tapeout_Applications_MEBES_Jobview__c = : 'Released'
            and TapeoutApplicationsMebesJobviewApprover__c != null limit 1].size() > 0) {
                MRS_Layer_Chip_Association__c LCA4 = [Select Id from MRS_Layer_Chip_Association__c where Tapeout_Applications_MEBES_Jobview__c = : 'Ready'
                and TapeoutApplicationsMebesJobviewApprover__c = null limit 1];
                lstLayerChipAssoHistory.addAll([SELECT CreatedBy.Name, CreatedById, CreatedDate, Field, NewValue, OldValue, ParentId FROM MRS_Layer_Chip_Association__History
                where Field = : 'Tapeout_Applications_MEBES_Jobview__c'
                and ParentId = : LCA4.Id]);

            }

            if ([Select Id from MRS_Layer_Chip_Association__c where GlobalShuttle_MEBES_Jobview__c = : 'Ready'
            and GlobalShuttleMebesJobviewApprover__c = null limit 1].size() > 0) {
                MRS_Layer_Chip_Association__c LCA5 = [Select Id from MRS_Layer_Chip_Association__c where GlobalShuttle_MEBES_Jobview__c = : 'Ready'
                and GlobalShuttleMebesJobviewApprover__c = null limit 1];
                lstLayerChipAssoHistory.addAll([SELECT CreatedBy.Name, CreatedById, CreatedDate, Field, NewValue, OldValue, ParentId FROM MRS_Layer_Chip_Association__History
                where Field = : 'GlobalShuttle_MEBES_Jobview__c'
                and ParentId = : LCA5.Id]);

            }

            if ([Select Id from MRS_Layer_Chip_Association__c where MDP_MEBES_Jobview__c = : 'Ready'
            and MDPMebesJobviewApprover__c = null limit 1].size() > 0) {
                MRS_Layer_Chip_Association__c LCA6 = [Select Id from MRS_Layer_Chip_Association__c where MDP_MEBES_Jobview__c = : 'Ready'
                and MDPMebesJobviewApprover__c = null limit 1];
                lstLayerChipAssoHistory.addAll([SELECT CreatedBy.Name, CreatedById, CreatedDate, Field, NewValue, OldValue, ParentId FROM MRS_Layer_Chip_Association__History
                where Field = : 'MDP_MEBES_Jobview__c'
                and ParentId = : LCA6.Id]);
            }
            if ([Select Id from MRS_Layer_Chip_Association__c where TDTI_MPW_MEBES_Jobview__c = : 'Ready'
            and TDTIMPWMebesJobviewApprover__c = null limit 1].size() > 0) {
                MRS_Layer_Chip_Association__c LCA7 = [Select Id from MRS_Layer_Chip_Association__c where TDTI_MPW_MEBES_Jobview__c = : 'Ready'
                and TDTIMPWMebesJobviewApprover__c = null limit 1];
                lstLayerChipAssoHistory.addAll([SELECT CreatedBy.Name, CreatedById, CreatedDate, Field, NewValue, OldValue, ParentId FROM MRS_Layer_Chip_Association__History
                where Field = : 'TDTI_MPW_MEBES_Jobview__c'
                and ParentId = : LCA7.Id]);
            }


            if ([Select Id from MRS_Layer_Chip_Association__c where Customer_Frame_Mockup__c = : 'Ready'
            and CustomerFrameMockupApprover__c = null limit 1].size() > 0) {
                MRS_Layer_Chip_Association__c LCA8 = [Select Id from MRS_Layer_Chip_Association__c where Customer_Frame_Mockup__c = : 'Ready'
                and CustomerFrameMockupApprover__c = null limit 1];
                lstLayerChipAssoHistory.addAll([SELECT CreatedBy.Name, CreatedById, CreatedDate, Field, NewValue, OldValue, ParentId FROM MRS_Layer_Chip_Association__History
                where Field = : 'Customer_Frame_Mockup__c'
                and ParentId = : LCA8.Id]);
            }

            if ([Select Id from MRS_Layer_Chip_Association__c where Foundry_Frame_Mockup__c = : 'Ready'
            and FoundryFrameMockupApprover__c = null limit 1].size() > 0) {
                MRS_Layer_Chip_Association__c LCA9 = [Select Id from MRS_Layer_Chip_Association__c where Customer_Frame_Mockup__c = : 'Ready'
                and FoundryFrameMockupApprover__c = null limit 1];
                lstLayerChipAssoHistory.addAll([SELECT CreatedBy.Name, CreatedById, CreatedDate, Field, NewValue, OldValue, ParentId FROM MRS_Layer_Chip_Association__History
                where Field = : 'Foundry_Frame_Mockup__c'
                and ParentId = : LCA9.Id]);
            }

            if ([Select Id from MRS_Layer_Chip_Association__c where Customer_GDSOUT_Review__c = : 'Ready'
            and CustomerGDSOUTReviewApprover__c = null limit 1].size() > 0) {
                MRS_Layer_Chip_Association__c LCA10 = [Select Id from MRS_Layer_Chip_Association__c where Customer_GDSOUT_Review__c = : 'Ready'
                and CustomerGDSOUTReviewApprover__c = null limit 1];
                lstLayerChipAssoHistory.addAll([SELECT CreatedBy.Name, CreatedById, CreatedDate, Field, NewValue, OldValue, ParentId FROM MRS_Layer_Chip_Association__History
                where Field = : 'Customer_GDSOUT_Review__c'
                and ParentId = : LCA10.Id]);
            }


            if ([Select Id from MRS_Layer_Chip_Association__c where Foundry_GDSOUT_Review__c = : 'Ready'
            and FoundryGDSOUTReviewApprover__c = null limit 1].size() > 0) {
                MRS_Layer_Chip_Association__c LCA11 = [Select Id from MRS_Layer_Chip_Association__c where Foundry_GDSOUT_Review__c = : 'Ready'
                and FoundryGDSOUTReviewApprover__c = null limit 1];
                lstLayerChipAssoHistory.addAll([SELECT CreatedBy.Name, CreatedById, CreatedDate, Field, NewValue, OldValue, ParentId FROM MRS_Layer_Chip_Association__History
                where Field = : 'Foundry_GDSOUT_Review__c'
                and ParentId = : LCA11.Id]);
            }


            if ([Select Id from MRS_Layer_Chip_Association__c where Synced_with_Oracle_DB__c = false limit 1].size() > 0) {
                MRS_Layer_Chip_Association__c LCA12 = [Select Id from MRS_Layer_Chip_Association__c where Synced_with_Oracle_DB__c = false limit 1];
                lstLayerChipAssoHistory.addAll([SELECT CreatedBy.Name, CreatedById, CreatedDate, Field, NewValue, OldValue, ParentId FROM MRS_Layer_Chip_Association__History
                where Field = : 'Synced_with_Oracle_DB__c'
                and ParentId = : LCA12.Id]);
            }

            if ([Select Id from MRS_Layer_Chip_Association__c where Send_Prime_Data__c = : 'Done'
            limit 1].size() > 0) {
                MRS_Layer_Chip_Association__c LCA13 = [Select Id from MRS_Layer_Chip_Association__c where Send_Prime_Data__c = : 'Done'
                limit 1];
                lstLayerChipAssoHistory.addAll([SELECT CreatedBy.Name, CreatedById, CreatedDate, Field, NewValue, OldValue, ParentId FROM MRS_Layer_Chip_Association__History
                where Field = : 'Send_Prime_Data__c'
                and ParentId = : LCA13.Id]);
            }

            MRS_Layer_Chip_Association__History hist = new MRS_Layer_Chip_Association__History(Field = 'Layer_Chip_Status__c');
            lstLayerChipAssoHistory.add(hist);

            MRS_Layer_Chip_Association__History hist1 = new MRS_Layer_Chip_Association__History(Field = 'Send_Frame_Data__c');
            lstLayerChipAssoHistory.add(hist1);

            MRS_Layer_Chip_Association__History hist2 = new MRS_Layer_Chip_Association__History(Field = 'Synced_with_Oracle_DB__c');
            lstLayerChipAssoHistory.add(hist2);

            MRS_Layer_Chip_Association__History hist3 = new MRS_Layer_Chip_Association__History(Field = 'Send_Prime_Data__c');
            lstLayerChipAssoHistory.add(hist3);

            MRS_Layer_Chip_Association__History hist4 = new MRS_Layer_Chip_Association__History(Field = 'Chip_Hold_Warning__c');
            lstLayerChipAssoHistory.add(hist4);


            MRS_Layer_Chip_Association__History hist5 = new MRS_Layer_Chip_Association__History(Field = 'Customer_MEBES_Jobview__c');
            lstLayerChipAssoHistory.add(hist5);


            MRS_Layer_Chip_Association__History hist6 = new MRS_Layer_Chip_Association__History(Field = 'Foundry_MEBES_Jobview__c');
            lstLayerChipAssoHistory.add(hist6);


            MRS_Layer_Chip_Association__History hist7 = new MRS_Layer_Chip_Association__History(Field = 'Tapeout_Centre_MEBES_Jobview__c');
            lstLayerChipAssoHistory.add(hist7);


            MRS_Layer_Chip_Association__History hist8 = new MRS_Layer_Chip_Association__History(Field = 'Tapeout_Applications_MEBES_Jobview__c');
            lstLayerChipAssoHistory.add(hist8);


            MRS_Layer_Chip_Association__History hist9 = new MRS_Layer_Chip_Association__History(Field = 'GlobalShuttle_MEBES_Jobview__c');
            lstLayerChipAssoHistory.add(hist9);


            MRS_Layer_Chip_Association__History hist10 = new MRS_Layer_Chip_Association__History(Field = 'MDP_MEBES_Jobview__c');
            lstLayerChipAssoHistory.add(hist10);

            MRS_Layer_Chip_Association__History hist11 = new MRS_Layer_Chip_Association__History(Field = 'TDTI_MPW_MEBES_Jobview__c');
            lstLayerChipAssoHistory.add(hist11);

            MRS_Layer_Chip_Association__History hist12 = new MRS_Layer_Chip_Association__History(Field = 'Customer_Frame_Mockup__c');
            lstLayerChipAssoHistory.add(hist12);


            MRS_Layer_Chip_Association__History hist13 = new MRS_Layer_Chip_Association__History(Field = 'Foundry_Frame_Mockup__c');
            lstLayerChipAssoHistory.add(hist13);

            MRS_Layer_Chip_Association__History hist14 = new MRS_Layer_Chip_Association__History(Field = 'Customer_GDSOUT_Review__c');
            lstLayerChipAssoHistory.add(hist14);


            MRS_Layer_Chip_Association__History hist15 = new MRS_Layer_Chip_Association__History(Field = 'Foundry_GDSOUT_Review__c');
            lstLayerChipAssoHistory.add(hist15);

            MRS_Layer_Chip_Association__History hist16 = new MRS_Layer_Chip_Association__History(Field = 'ORC__c');
            lstLayerChipAssoHistory.add(hist16);

            MRS_Layer_Chip_Association__History hist17 = new MRS_Layer_Chip_Association__History(Field = 'DRW__c');
            lstLayerChipAssoHistory.add(hist17);


            MRS_Layer_Chip_Association__History hist18 = new MRS_Layer_Chip_Association__History(Field = 'Customer_Prime_Remote_Jobview_Setup__c');
            lstLayerChipAssoHistory.add(hist18);


            MRS_Layer_Chip_Association__History hist19 = new MRS_Layer_Chip_Association__History(Field = 'Customer_Frame_Remote_Jobview_Setup__c');
            lstLayerChipAssoHistory.add(hist19);

            MRS_Layer_Chip_Association__History hist20 = new MRS_Layer_Chip_Association__History(Field = 'Foundry_Prime_Remote_Jobview_Setup__c');
            lstLayerChipAssoHistory.add(hist20);

            MRS_Layer_Chip_Association__History hist21 = new MRS_Layer_Chip_Association__History(Field = 'Foundry_Frame_Remote_Jobview_Setup__c');
            lstLayerChipAssoHistory.add(hist21);

            MRS_Layer_Chip_Association__History hist22 = new MRS_Layer_Chip_Association__History(Field = 'Prime_MEBES_Received__c');
            lstLayerChipAssoHistory.add(hist22);


            MRS_Layer_Chip_Association__History hist23 = new MRS_Layer_Chip_Association__History(Field = 'Frame_MEBES_Received__c');
            lstLayerChipAssoHistory.add(hist23);


            List < String > results = processRows(lstLayerChipAssoHistory);

            List < MRS_Layer_Association__History > lstLayerAssoHistory = [SELECT CreatedBy.Name, CreatedById, CreatedDate, Field, NewValue, OldValue, ParentId FROM MRS_Layer_Association__History where ParentId = : HistObjLA.ParentId];

            List < Notes__c > lstLayerAssoNotes = new List < Notes__c > ();
            lstLayerAssoNotes = [SELECT CreatedDate, CreatedById, Body__c from Notes__c where ParentId__c = : HistObj.ParentId and MRS_Layer_Association__c = null and Category__c = 'Hold Chip'
            ORDER BY CreatedDate desc];

            Notes__c objNotes = new Notes__c();
            objNotes.ParentId__c = HistObj.ParentId;
            objNotes.MRS_Layer_Association__c = null;
            objNotes.Category__c = 'Hold Chip';

            insert objNotes;


            List < MRSAuditTrail.AuditTrail > lstWrapperAuditTrail = new List < MRSAuditTrail.AuditTrail > ();
            MRSAuditTrail.AuditTrail var2 = new MRSAuditTrail.AuditTrail('29/08/2014 10:10:10', 'System User', 'Test description', 'Tapeout_Centre_MEBES_Jobview__c', 'Not Ready', 'Redady', '', '');
            lstWrapperAuditTrail.add(var2);

            MRSAuditTrail.AuditTrail var3 = new MRSAuditTrail.AuditTrail('29/08/2014 10:10:10', 'System User', 'Test description', 'Prime_MEBES_Received__c', 'Not Ready', 'Redady', '', '');
            lstWrapperAuditTrail.add(var3);

            Test.setCurrentPage(Page.VFMRSAuditTrail);
            ApexPages.currentPage().getParameters().put('PageName', 'LayerChipSummary');
            ApexPages.currentPage().getParameters().put('id', HistObj.ParentId);
            ApexPages.currentPage().getParameters().put('LayerId', objMLCA.Layer__c);
            ApexPages.currentPage().getHeaders().put('Host', system.Label.SWIFT_Community_URL);
            MRSAuditTrail objAuditTrail1 = new MRSAuditTrail();
            objAuditTrail1.recordid = HistObj.ParentId;
            MRSAuditTrail.sortby = '1';
            objAuditTrail1.layerid = HistObj.Id; //objMLCA.Layer__c;

            objAuditTrail1.PageName = 'LayerChipSummary';

            objAuditTrail1.ListOfDateTimeFields = 'Last_Sync_Request_Timestamp__c,LastReferencedDate__c,Foundry_GDSOUT_Review_Date__c,Customer_Frame_Mockup_Date__c,SystemModstamp,Foundry_Prime_Remote_Jobview_Setup_Date__c,lastmodifieddate_sgt__c,CreatedDate,Customer_Prime_Remote_Jobview_Setup_Date__c,GlobalShuttle_MEBES_Jobview_Date__c,LastViewedDate,TDTI_MPW_MEBES_Jobview_Date__c,Send_Frame_Data_Date__c,Send_Prime_Data_Date__c,Customer_MEBES_Jobview_Date__c,Tapeout_Applications_MEBES_Jobview_Date__c,Foundry_MEBES_Jobview_Date__c,LastModifiedDate,Frame_MEBES_Received_Date__c,ORC_Date__c,LastReferencedDate,MDP_MEBES_Jobview_Date__c,DRW_Date__c,Tapeout_Centre_MEBES_Jobview_Date__c,Foundry_Frame_Mockup_Date__c,Customer_Frame_Remote_Jobview_Setup_Date__c,Foundry_Frame_Remote_Jobview_Setup_Date__c,Prime_MEBES_Received_Date__c,Customer_GDSOUT_Review_Date__c,Layer_Status_Date__c';

            List < MRS_Layer_Chip_Association__History > lstLayerChipAssoHistoryAfterTest = [SELECT CreatedById, CreatedDate, Field, NewValue, OldValue, ParentId FROM MRS_Layer_Chip_Association__History where ParentId = : HistObj.ParentId];
            system.assertNotEquals(1, lstLayerChipAssoHistoryAfterTest.size());
            test.stoptest();
        }
    }

    /**
        This test method tests the method which will be called for MRS Layer Chip Association object
        @method name: controllerConstructor5
        @parameter:   none.
        @return :     None.
     **/


    public static testMethod void controllerConstructor5() {

        User sysAdminUser = [SELECT Id, Name FROM User WHERE Profile.Name = 'System Administrator'
        AND isActive = true].get(0);
        System.runAs(sysAdminUser) {

            test.starttest();
            MRS_Layer_Chip_Association__History HistObj = [SELECT ParentId FROM MRS_Layer_Chip_Association__History limit 1];
            MRS_Layer_Association__History HistObjLA = [SELECT ParentId FROM MRS_Layer_Association__History limit 1];

            List < MRS_Layer_Chip_Association__History > lstLayerChipAssoHistory = [SELECT CreatedBy.Name, CreatedById, CreatedDate, Field, NewValue, OldValue, ParentId FROM MRS_Layer_Chip_Association__History where ParentId = : HistObj.ParentId];

            List < MRS_Layer_Chip_Association__History > lstLayerChipAssoHistory1 = [SELECT CreatedBy.Name, CreatedById, CreatedDate, Field, NewValue, OldValue, ParentId FROM MRS_Layer_Chip_Association__History LIMIT 1000];
            lstLayerChipAssoHistory.addAll(lstLayerChipAssoHistory1);


            MRS_Layer_Chip_Association__History hist = new MRS_Layer_Chip_Association__History(Field = 'Layer_Chip_Status__c');
            lstLayerChipAssoHistory.add(hist);

            MRS_Layer_Chip_Association__History hist1 = new MRS_Layer_Chip_Association__History(Field = 'Send_Frame_Data__c');
            lstLayerChipAssoHistory.add(hist1);

            MRS_Layer_Chip_Association__History hist2 = new MRS_Layer_Chip_Association__History(Field = 'Synced_with_Oracle_DB__c');
            lstLayerChipAssoHistory.add(hist2);

            MRS_Layer_Chip_Association__History hist3 = new MRS_Layer_Chip_Association__History(Field = 'Send_Prime_Data__c');
            lstLayerChipAssoHistory.add(hist3);


            MRS_Layer_Chip_Association__History hist4 = new MRS_Layer_Chip_Association__History(Field = 'Chip_Hold_Warning__c');
            lstLayerChipAssoHistory.add(hist4);


            MRS_Layer_Chip_Association__History hist5 = new MRS_Layer_Chip_Association__History(Field = 'Customer_MEBES_Jobview__c');
            lstLayerChipAssoHistory.add(hist5);


            MRS_Layer_Chip_Association__History hist6 = new MRS_Layer_Chip_Association__History(Field = 'Foundry_MEBES_Jobview__c');
            lstLayerChipAssoHistory.add(hist6);


            MRS_Layer_Chip_Association__History hist7 = new MRS_Layer_Chip_Association__History(Field = 'Tapeout_Centre_MEBES_Jobview__c');
            lstLayerChipAssoHistory.add(hist7);


            MRS_Layer_Chip_Association__History hist8 = new MRS_Layer_Chip_Association__History(Field = 'Tapeout_Applications_MEBES_Jobview__c');
            lstLayerChipAssoHistory.add(hist8);


            MRS_Layer_Chip_Association__History hist9 = new MRS_Layer_Chip_Association__History(Field = 'GlobalShuttle_MEBES_Jobview__c');
            lstLayerChipAssoHistory.add(hist9);


            MRS_Layer_Chip_Association__History hist10 = new MRS_Layer_Chip_Association__History(Field = 'MDP_MEBES_Jobview__c');
            lstLayerChipAssoHistory.add(hist10);

            MRS_Layer_Chip_Association__History hist11 = new MRS_Layer_Chip_Association__History(Field = 'TDTI_MPW_MEBES_Jobview__c');
            lstLayerChipAssoHistory.add(hist11);

            MRS_Layer_Chip_Association__History hist12 = new MRS_Layer_Chip_Association__History(Field = 'Customer_Frame_Mockup__c');
            lstLayerChipAssoHistory.add(hist12);


            MRS_Layer_Chip_Association__History hist13 = new MRS_Layer_Chip_Association__History(Field = 'Foundry_Frame_Mockup__c');
            lstLayerChipAssoHistory.add(hist13);

            MRS_Layer_Chip_Association__History hist14 = new MRS_Layer_Chip_Association__History(Field = 'Customer_GDSOUT_Review__c');
            lstLayerChipAssoHistory.add(hist14);


            MRS_Layer_Chip_Association__History hist15 = new MRS_Layer_Chip_Association__History(Field = 'Foundry_GDSOUT_Review__c');
            lstLayerChipAssoHistory.add(hist15);

            MRS_Layer_Chip_Association__History hist16 = new MRS_Layer_Chip_Association__History(Field = 'ORC__c');
            lstLayerChipAssoHistory.add(hist16);

            MRS_Layer_Chip_Association__History hist17 = new MRS_Layer_Chip_Association__History(Field = 'DRW__c');
            lstLayerChipAssoHistory.add(hist17);


            MRS_Layer_Chip_Association__History hist18 = new MRS_Layer_Chip_Association__History(Field = 'Customer_Prime_Remote_Jobview_Setup__c');
            lstLayerChipAssoHistory.add(hist18);


            MRS_Layer_Chip_Association__History hist19 = new MRS_Layer_Chip_Association__History(Field = 'Customer_Frame_Remote_Jobview_Setup__c');
            lstLayerChipAssoHistory.add(hist19);

            MRS_Layer_Chip_Association__History hist20 = new MRS_Layer_Chip_Association__History(Field = 'Foundry_Prime_Remote_Jobview_Setup__c');
            lstLayerChipAssoHistory.add(hist20);

            MRS_Layer_Chip_Association__History hist21 = new MRS_Layer_Chip_Association__History(Field = 'Foundry_Frame_Remote_Jobview_Setup__c');
            lstLayerChipAssoHistory.add(hist21);

            MRS_Layer_Chip_Association__History hist22 = new MRS_Layer_Chip_Association__History(Field = 'Prime_MEBES_Received__c');
            lstLayerChipAssoHistory.add(hist22);


            MRS_Layer_Chip_Association__History hist23 = new MRS_Layer_Chip_Association__History(Field = 'Frame_MEBES_Received__c');
            lstLayerChipAssoHistory.add(hist23);

            List < String > results = processRows(lstLayerChipAssoHistory);

            MRS_Layer_Chip_Association__c objMLCA = [select Layer__c from MRS_Layer_Chip_Association__c where Id = : HistObj.ParentId];

            List < MRS_Layer_Association__History > lstLayerAssoHistory = [SELECT CreatedBy.Name, CreatedById, CreatedDate, Field, NewValue, OldValue, ParentId FROM MRS_Layer_Association__History where ParentId = : HistObjLA.ParentId];

            Notes__c objNotes = new Notes__c();
            objNotes.ParentId__c = HistObj.ParentId;
            objNotes.MRS_Layer_Association__c = null;
            objNotes.Category__c = 'Hold Chip';

            insert objNotes;
            //lstMLA = [select name from MRS_Layer_Association__c limit 1 ];

            List < Notes__c > lstLayerAssoNotes = new List < Notes__c > ();
            lstLayerAssoNotes = [SELECT CreatedDate, CreatedById, Body__c from Notes__c where ParentId__c = : HistObj.ParentId and MRS_Layer_Association__c = null and Category__c = 'Hold Chip'
            ORDER BY CreatedDate desc];


            List < MRSAuditTrail.AuditTrail > lstWrapperAuditTrail = new List < MRSAuditTrail.AuditTrail > ();
            MRSAuditTrail.AuditTrail var3 = new MRSAuditTrail.AuditTrail('29/08/2014 10:10:10', 'System User', 'Test description', 'Tapeout_Centre_MEBES_Jobview__c', 'Not Ready', 'Redady', '', '');
            lstWrapperAuditTrail.add(var3);

            MRSAuditTrail.AuditTrail var2 = new MRSAuditTrail.AuditTrail('29/08/2014 10:10:10', 'System User', 'Test description', 'Prime_MEBES_Received__c', 'Not Ready', 'Redady', '', '');

            Test.setCurrentPage(Page.VFMRSAuditTrail);
            ApexPages.currentPage().getParameters().put('PageName', 'LayerChipSummary');
            ApexPages.currentPage().getHeaders().put('Host', system.Label.SWIFT_Community_URL);
            MRSAuditTrail objAuditTrail1 = new MRSAuditTrail();

            objAuditTrail1.PageName = 'LayerChipSummary';
            MRSAuditTrail.sortby = '1';

            objAuditTrail1.recordid = HistObjLA.ParentId;
            objAuditTrail1.layerid = objMLCA.Layer__c;

            objAuditTrail1.ListOfDateTimeFields = 'Last_Sync_Request_Timestamp__c,LastReferencedDate__c,Foundry_GDSOUT_Review_Date__c,Customer_Frame_Mockup_Date__c,SystemModstamp,Foundry_Prime_Remote_Jobview_Setup_Date__c,lastmodifieddate_sgt__c,CreatedDate,Customer_Prime_Remote_Jobview_Setup_Date__c,GlobalShuttle_MEBES_Jobview_Date__c,LastViewedDate,TDTI_MPW_MEBES_Jobview_Date__c,Send_Frame_Data_Date__c,Send_Prime_Data_Date__c,Customer_MEBES_Jobview_Date__c,Tapeout_Applications_MEBES_Jobview_Date__c,Foundry_MEBES_Jobview_Date__c,LastModifiedDate,Frame_MEBES_Received_Date__c,ORC_Date__c,LastReferencedDate,MDP_MEBES_Jobview_Date__c,DRW_Date__c,Tapeout_Centre_MEBES_Jobview_Date__c,Foundry_Frame_Mockup_Date__c,Customer_Frame_Remote_Jobview_Setup_Date__c,Foundry_Frame_Remote_Jobview_Setup_Date__c,Prime_MEBES_Received_Date__c,Customer_GDSOUT_Review_Date__c,Layer_Status_Date__c';

            objAuditTrail1.PopulateAuditHistoryLayerAssociation(lstLayerAssoHistory);
            List < MRS_Layer_Chip_Association__History > lstLayerChipAssoHistoryAfterTest = [SELECT CreatedById, CreatedDate, Field, NewValue, OldValue, ParentId FROM MRS_Layer_Chip_Association__History where ParentId = : HistObj.ParentId];

            //system.assert(lstLayerChipAssoHistoryAfterTest.size()!=null);
            system.assertNotEquals(1, lstLayerChipAssoHistoryAfterTest.size());
            test.stoptest();
        }

    }

}