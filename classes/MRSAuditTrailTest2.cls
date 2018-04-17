/*
Type Name: MRSAuditTrailTest2
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
public class MRSAuditTrailTest2 {

    /**
        This test method tests the method which will be called for MRS Layer Chip Association object
        @method name: controllerConstructor2
        @parameter:   none.
        @return :     None.
     **/


    public static testMethod void controllerConstructor2() {

        User sysAdminUser = [SELECT Id, Name FROM User WHERE Profile.Name = 'System Administrator'
        AND isActive = true].get(0);
        System.runAs(sysAdminUser) {

            test.starttest();
            MRS_Layer_Chip_Association__History HistObj = [SELECT ParentId FROM MRS_Layer_Chip_Association__History limit 1];
            MRS_Layer_Association__History HistObjLA = [SELECT ParentId FROM MRS_Layer_Association__History limit 1];

            MRS_Layer_Chip_Association__c objMLCA = [select Layer__c from MRS_Layer_Chip_Association__c where Id = : HistObj.ParentId];

            List < MRS_Layer_Chip_Association__History > lstLayerChipAssoHistory = [SELECT CreatedBy.Name, CreatedById, CreatedDate, Field, NewValue, OldValue, ParentId FROM MRS_Layer_Chip_Association__History where ParentId = : HistObj.ParentId];

            List < MRS_Layer_Chip_Association__History > lstLayerChipAssoHistory1 = [SELECT CreatedBy.Name, CreatedById, CreatedDate, Field, NewValue, OldValue, ParentId FROM MRS_Layer_Chip_Association__History LIMIT 1000];
            lstLayerChipAssoHistory.addAll(lstLayerChipAssoHistory1);

            List < MRS_Layer_Association__History > lstLayerAssoHistory = [SELECT CreatedBy.Name, CreatedById, CreatedDate, Field, NewValue, OldValue, ParentId FROM MRS_Layer_Association__History where ParentId = : HistObjLA.ParentId];
            List < MRSAuditTrail.AuditTrail > lstWrapperAuditTrail = new List < MRSAuditTrail.AuditTrail > ();
            MRSAuditTrail.AuditTrail var3 = new MRSAuditTrail.AuditTrail('29/08/2014 10:10:10', 'System User', 'Test description', 'Tapeout_Centre_MEBES_Jobview__c', 'Not Ready', 'Redady', '', '');
            lstWrapperAuditTrail.add(var3);
            MRSAuditTrail.AuditTrail var2 = new MRSAuditTrail.AuditTrail('29/08/2014 10:10:10', 'System User', 'Test description', 'Frame_MEBES_Received__c', 'Not Ready', 'Redady', '', '');

            lstWrapperAuditTrail.add(var2);
            Test.setCurrentPage(Page.VFMRSAuditTrail);
            ApexPages.currentPage().getParameters().put('PageName', 'ManualUpdate');
            ApexPages.currentPage().getHeaders().put('Host', system.Label.SWIFT_Community_URL);

            ApexPages.currentPage().getParameters().put('id', HistObjLA.ParentId);
            ApexPages.currentPage().getParameters().put('LayerId', HistObjLA.ParentId);
            MRSAuditTrail objAuditTrail1 = new MRSAuditTrail();
            MRSAuditTrail.sortby = '1';

            objAuditTrail1.ListOfDateTimeFields = 'Last_Sync_Request_Timestamp__c,LastReferencedDate__c,Foundry_GDSOUT_Review_Date__c,Customer_Frame_Mockup_Date__c,SystemModstamp,Foundry_Prime_Remote_Jobview_Setup_Date__c,lastmodifieddate_sgt__c,CreatedDate,Customer_Prime_Remote_Jobview_Setup_Date__c,GlobalShuttle_MEBES_Jobview_Date__c,LastViewedDate,TDTI_MPW_MEBES_Jobview_Date__c,Send_Frame_Data_Date__c,Send_Prime_Data_Date__c,Customer_MEBES_Jobview_Date__c,Tapeout_Applications_MEBES_Jobview_Date__c,Foundry_MEBES_Jobview_Date__c,LastModifiedDate,Frame_MEBES_Received_Date__c,ORC_Date__c,LastReferencedDate,MDP_MEBES_Jobview_Date__c,DRW_Date__c,Tapeout_Centre_MEBES_Jobview_Date__c,Foundry_Frame_Mockup_Date__c,Customer_Frame_Remote_Jobview_Setup_Date__c,Foundry_Frame_Remote_Jobview_Setup_Date__c,Prime_MEBES_Received_Date__c,Customer_GDSOUT_Review_Date__c,Layer_Status_Date__c';

            objAuditTrail1.recordid = HistObjLA.ParentId;
            objAuditTrail1.layerid = HistObjLA.ParentId;

            objAuditTrail1.PageName = 'ManualUpdate';
            //objAuditTrail1.PopulateAuditHistoryLayerChipAssociation(lstLayerChipAssoHistory);
            List < MRS_Layer_Chip_Association__History > lstLayerChipAssoHistoryAfterTest = [SELECT CreatedById, CreatedDate, Field, NewValue, OldValue, ParentId FROM MRS_Layer_Chip_Association__History where ParentId = : HistObj.id];


            system.assertNotEquals(1, lstLayerChipAssoHistoryAfterTest.size());

            test.stoptest();
        }

    }

    /**
        This test method tests the method which will be called for MRS Layer Chip Association object
        @method name: controllerConstructorManualUpdate
        @parameter:   none.
        @return :     None.
     **/
    public static testMethod void controllerConstructorManualUpdate() {

        User sysAdminUser = [SELECT Id, Name FROM User WHERE Profile.Name = 'System Administrator'
        AND isActive = true].get(0);
        System.runAs(sysAdminUser) {

            test.starttest();
            MRS_Layer_Chip_Association__History HistObj = [SELECT ParentId FROM MRS_Layer_Chip_Association__History limit 1];
            MRS_Layer_Association__History HistObjLA = [SELECT ParentId FROM MRS_Layer_Association__History limit 1];
            MRS_Layer_Chip_Association__c objMLCA = [select Layer__c from MRS_Layer_Chip_Association__c where Id = : HistObj.ParentId];
            List < MRS_Layer_Chip_Association__History > lstLayerChipAssoHistory = [SELECT CreatedBy.Name, CreatedById, CreatedDate, Field, NewValue, OldValue, ParentId FROM MRS_Layer_Chip_Association__History where ParentId = : HistObj.ParentId];
            List < MRS_Layer_Association__History > lstLayerAssoHistory = [SELECT CreatedBy.Name, CreatedById, CreatedDate, Field, NewValue, OldValue, ParentId FROM MRS_Layer_Association__History where ParentId = : HistObjLA.ParentId];
            List < MRSAuditTrail.AuditTrail > lstWrapperAuditTrail = new List < MRSAuditTrail.AuditTrail > ();
            MRSAuditTrail.AuditTrail var3 = new MRSAuditTrail.AuditTrail('29/08/2014 10:10:10', 'System User', 'Test description', 'Tapeout_Centre_MEBES_Jobview__c', 'Not Ready', 'Redady', '', '');
            lstWrapperAuditTrail.add(var3);
            MRSAuditTrail.AuditTrail var2 = new MRSAuditTrail.AuditTrail('29/08/2014 10:10:10', 'System User', 'Test description', 'Tapeout_Centre_MEBES_Jobview__c', 'Not Ready', 'Redady', '', '');

            lstWrapperAuditTrail.add(var2);
            Test.setCurrentPage(Page.VFMRSAuditTrail);
            ApexPages.currentPage().getParameters().put('PageName', 'ManualUpdate');
            ApexPages.currentPage().getHeaders().put('Host', system.Label.SWIFT_Community_URL);

            ApexPages.currentPage().getParameters().put('id', HistObj.ParentId);
            ApexPages.currentPage().getParameters().put('LayerId', HistObj.Id);

            MRSAuditTrail objAuditTrail1 = new MRSAuditTrail();
            objAuditTrail1.ListOfDateTimeFields = 'Last_Sync_Request_Timestamp__c,LastReferencedDate__c,Foundry_GDSOUT_Review_Date__c,Customer_Frame_Mockup_Date__c,SystemModstamp,Foundry_Prime_Remote_Jobview_Setup_Date__c,lastmodifieddate_sgt__c,CreatedDate,Customer_Prime_Remote_Jobview_Setup_Date__c,GlobalShuttle_MEBES_Jobview_Date__c,LastViewedDate,TDTI_MPW_MEBES_Jobview_Date__c,Send_Frame_Data_Date__c,Send_Prime_Data_Date__c,Customer_MEBES_Jobview_Date__c,Tapeout_Applications_MEBES_Jobview_Date__c,Foundry_MEBES_Jobview_Date__c,LastModifiedDate,Frame_MEBES_Received_Date__c,ORC_Date__c,LastReferencedDate,MDP_MEBES_Jobview_Date__c,DRW_Date__c,Tapeout_Centre_MEBES_Jobview_Date__c,Foundry_Frame_Mockup_Date__c,Customer_Frame_Remote_Jobview_Setup_Date__c,Foundry_Frame_Remote_Jobview_Setup_Date__c,Prime_MEBES_Received_Date__c,Customer_GDSOUT_Review_Date__c,Layer_Status_Date__c';


            MRSAuditTrail.sortby = '1';
            objAuditTrail1.PageName = 'ManualUpdate';
            objAuditTrail1.recordid = HistObj.ParentId;
            objAuditTrail1.layerid = objMLCA.Layer__c;


            List < MRS_Layer_Chip_Association__History > lstLayerChipAssoHistoryAfterTest = [SELECT CreatedById, CreatedDate, Field, NewValue, OldValue, ParentId FROM MRS_Layer_Chip_Association__History where ParentId = : HistObj.ParentId];
            system.assertNotEquals(1, lstLayerChipAssoHistoryAfterTest.size());
            test.stoptest();
        }

    }

    // for page name layer summary
    /**
         This test method tests the method which will be called for MRS Layer Chip Association object
        @method name: controllerConstructor
        @parameter:   none.
        @return :     None.
     **/

    public static testMethod void controllerConstructor() {

        User sysAdminUser = [SELECT Id, Name FROM User WHERE Profile.Name = 'System Administrator'
        AND isActive = true].get(0);
        System.runAs(sysAdminUser) {

            MRS_Layer_Chip_Association__History HistObj = [SELECT ParentId FROM MRS_Layer_Chip_Association__History limit 1];
            MRS_Layer_Association__History HistObjLA = [SELECT ParentId FROM MRS_Layer_Association__History limit 1];

            if ([SELECT Layer_Chip_Status__c FROM MRS_Layer_Chip_Association__c where Layer__c = : HistObjLA.ParentId limit 1].size() > 0) {

                MRS_Layer_Chip_Association__c ObjLCA = [SELECT Layer_Chip_Status__c FROM MRS_Layer_Chip_Association__c where Layer__c = : HistObjLA.ParentId limit 1];
                ObjLCA.Layer_Chip_Status__c = 'Hold';
                update ObjLCA;
            }

            List < MRS_Layer_Association__History > lstLayerAssoHistory = [SELECT CreatedBy.Name, CreatedById, CreatedDate, Field, NewValue, OldValue, ParentId FROM MRS_Layer_Association__History where ParentId = : HistObjLA.ParentId];

            List < MRS_Layer_Association__History > lstLayerAssoHistory1 = [SELECT CreatedBy.Name, CreatedById, CreatedDate, Field, NewValue, OldValue, ParentId FROM MRS_Layer_Association__History where Field in ('Last_Sync_Request_Timestamp__c,LastReferencedDate__c,Foundry_GDSOUT_Review_Date__c,Customer_Frame_Mockup_Date__c,SystemModstamp,Foundry_Prime_Remote_Jobview_Setup_Date__c,lastmodifieddate_sgt__c,CreatedDate,Customer_Prime_Remote_Jobview_Setup_Date__c,GlobalShuttle_MEBES_Jobview_Date__c,LastViewedDate,TDTI_MPW_MEBES_Jobview_Date__c,Send_Frame_Data_Date__c,Send_Prime_Data_Date__c,Customer_MEBES_Jobview_Date__c,Tapeout_Applications_MEBES_Jobview_Date__c,Foundry_MEBES_Jobview_Date__c,LastModifiedDate,Frame_MEBES_Received_Date__c,ORC_Date__c,LastReferencedDate,MDP_MEBES_Jobview_Date__c,DRW_Date__c,Tapeout_Centre_MEBES_Jobview_Date__c,Foundry_Frame_Mockup_Date__c,Customer_Frame_Remote_Jobview_Setup_Date__c,Foundry_Frame_Remote_Jobview_Setup_Date__c,Prime_MEBES_Received_Date__c,Customer_GDSOUT_Review_Date__c,Layer_Status_Date__c') LIMIT 1000];

            lstLayerAssoHistory.addAll(lstLayerAssoHistory1);


            if ([Select Id from MRS_Layer_Association__c where Layer_Status__c = : 'Hold'
            limit 1].size() > 0) {
                MRS_Layer_Association__c LA1 = [Select Id from MRS_Layer_Association__c where Layer_Status__c = : 'Hold'
                limit 1];
                lstLayerAssoHistory.addAll([SELECT CreatedBy.Name, CreatedById, CreatedDate, Field, NewValue, OldValue, ParentId FROM MRS_Layer_Association__History
                where Field = : 'Layer_Status__c'
                and ParentId = : LA1.Id]);
            }

            Notes__c objNotes = new Notes__c();
            objNotes.ParentId__c = null;
            objNotes.MRS_Layer_Association__c = HistObjLA.ParentId;
            insert objNotes;

            test.startTest();

            Test.setCurrentPage(Page.VFMRSAuditTrail);

            ApexPages.currentPage().getParameters().put('PageName', 'Layersummary');
            ApexPages.currentPage().getHeaders().put('Host', system.Label.Internal_URL);
            MRSAuditTrail objAuditTrail1 = new MRSAuditTrail();
            MRSAuditTrail.sortby = '1';

            objAuditTrail1.ListOfDateTimeFields = 'Last_Sync_Request_Timestamp__c,LastReferencedDate__c,Foundry_GDSOUT_Review_Date__c,Customer_Frame_Mockup_Date__c,SystemModstamp,Foundry_Prime_Remote_Jobview_Setup_Date__c,lastmodifieddate_sgt__c,CreatedDate,Customer_Prime_Remote_Jobview_Setup_Date__c,GlobalShuttle_MEBES_Jobview_Date__c,LastViewedDate,TDTI_MPW_MEBES_Jobview_Date__c,Send_Frame_Data_Date__c,Send_Prime_Data_Date__c,Customer_MEBES_Jobview_Date__c,Tapeout_Applications_MEBES_Jobview_Date__c,Foundry_MEBES_Jobview_Date__c,LastModifiedDate,Frame_MEBES_Received_Date__c,ORC_Date__c,LastReferencedDate,MDP_MEBES_Jobview_Date__c,DRW_Date__c,Tapeout_Centre_MEBES_Jobview_Date__c,Foundry_Frame_Mockup_Date__c,Customer_Frame_Remote_Jobview_Setup_Date__c,Foundry_Frame_Remote_Jobview_Setup_Date__c,Prime_MEBES_Received_Date__c,Customer_GDSOUT_Review_Date__c,Layer_Status_Date__c';
            objAuditTrail1.recordid = HistObjLA.ParentId;
            objAuditTrail1.PageName = 'Layersummary';

            MRSAuditTrail.AuditTrail var2 = new MRSAuditTrail.AuditTrail('29/08/2014 10:10:10', 'System User', 'Test description', 'Tapeout_Centre_MEBES_Jobview__c', 'Not Ready', 'Redady', '', '');
            List < MRSAuditTrail.AuditTrail > lstWrapperAuditTrail = new List < MRSAuditTrail.AuditTrail > ();
            lstWrapperAuditTrail.add(var2);

            List < MRS_Layer_Association__History > lstLayerAssoHistoryAftertest = [SELECT CreatedBy.Name, CreatedById, CreatedDate, Field, NewValue, OldValue, ParentId FROM MRS_Layer_Association__History where ParentId = : HistObjLA.ParentId];
            system.assertNotEquals(1, lstLayerAssoHistoryAftertest.size());
            test.stoptest();
        }

    }
}