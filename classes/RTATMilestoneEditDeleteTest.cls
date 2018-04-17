/*
 * Author: Elizabeth Button
 * Test class for RTATMilestoneEditDelete apex class
 * Created April 24th, 2017
 *  
*/

@isTest
private class RTATMilestoneEditDeleteTest {
        
     @testSetup static void testdata() {
        DataUtilTest.loadEnvironmentVariables();
     }
    
    static Id createERPDevice() {
        
        ERP_Device__c erpDevice = new ERP_Device__c();
        erpDevice.Technology__c = 'SIGE8XP';
        erpDevice.Fab__c = 'FAB 9';
        erpDevice.Product_Type__c = 'Foundry';
        erpDevice.Deliverable_Type__c = 'WAFER';
        erpDevice.Name = 'MOSIS 910';
        erpDevice.Part_Number__c = '0000001KG304';
        erpDevice.Level__c = '27';
        erpDevice.Option_ID__c = 'OPT043516';
        erpDevice.Opportunity_ID__c = 'OPP029770';
        erpDevice.Business_Unit__c = 'RF';
        erpDevice.Burn_In__c = 'N';
        erpDevice.Test_wafer__c = 'N';
        erpDevice.Back_Side_Grind__c = 'Y';
        erpDevice.Levels_Of_Metal__c = 8;
        erpDevice.Last_Level_of_Metal__c = 'MA';
        erpDevice.Mask_Layer_Count__c = '52';
        erpDevice.Wafer_Diameter__c = 200;
        erpDevice.Chips_per_Wafer__c = 1;
        erpDevice.Module_Test_Flag__c = 'N';
        
        insert erpDevice;
        return erpDevice.Id;
        
    }
    
    static id createRTATSLOT(Id ERPDeviceId)
    {
        RTAT_Slot__c rtatSlot = new RTAT_Slot__c();
        rtatSlot.Name = 'MyTestSlotERB';
        rtatSlot.ERP_Device_for_Slot__c = ERPDeviceId;
        rtatSlot.Conversion_Lot_Number__c = '000222333';
        rtatSlot.SAP_Order_Number__c = '009030303030';
        rtatSlot.Internal_Charge_Code__c = 'My ICC num';
        rtatSlot.Mfg_Instructions__c = 'Some comments';
        rtatSlot.General_Comments__c = 'More comments';
        rtatSlot.Slot_Status__c = 'ACTIVE';
        rtatSlot.Slot_Type__c = 'EUH';
        rtatSlot.Slot_Yield_Factor__c = 75;
        rtatSlot.MPW__c = true;
        rtatSlot.Wafer_Size__c = '200MM';
        
        insert rtatSlot;
        return rtatSlot.Id;        
        
    }
    
    static Id createWafFabSched(Id RTATSlotId)
    {
        RTAT_Wafer_Fab_Schedule_Inputs__c wfs = new RTAT_Wafer_Fab_Schedule_Inputs__c();
        wfs.Name = 'MySampleWFSbyERB';
        wfs.Wafer_Build_Location__c = 'BURLINGTON';
        wfs.RTAT_Slot__c = RTATSlotId;
        wfs.RIT_Type__c = 'AB';
        wfs.LOM_or_Mask_Layers__c = 'Levels of Metal';
        wfs.RIT_A_Quality__c = 'PQ';
        wfs.RIT_A_Speed__c = 'TURBO';
        wfs.RIT_A_Wafer_Start_Quantity__c = 8;
        wfs.RIT_B_Quality__c = 'PQ';
        wfs.RIT_B_Speed__c = 'TURBO';
        wfs.RIT_B_Wafer_Start_Quantity__c = 8;
        wfs.Mask_House_CCDESK_date__c = Date.parse('07/03/2017');
        wfs.Mask_Build_TAT__c = 3;
        wfs.RIT_A_BTV_Fab_Transit_Time__c = 0.0;
        wfs.Fab_Prep_TAT__c = 0;
        wfs.Base_RIT_A_TAT__c = 21.5;
        wfs.ProcOptionNamesRITA__c = 'MPW;BR;';
        wfs.ProcOptionTATsRITA__c = '0;1';
        wfs.Base_RIT_B_TAT__c = 20;
        wfs.ProcOptionNamesRITB__c = 'AV;';
        wfs.ProcOptionTATsRITB__c = '1;8';        
        
        insert wfs;
        return wfs.Id;
        
    }
    static id createMilestone(Id idWFS, String proc, double dd, Date dt, boolean bb)
    {
        RTAT_Sched_TAT_Adjust__c mt = new RTAT_Sched_TAT_Adjust__c();
        mt.Parent_Waf_Fab_Schedule__c = idWFS;
        mt.Process__c = proc;
        mt.Adjustable_TAT__c = bb;
        mt.Total_TAT__c = dd;
        mt.End_Date__c = dt;
        insert mt;        
        return mt.Id;
        
    }
    
    static id createMilestoneWithSubProc(Id idWFS, String proc, double dd, Date dt, boolean bb)
    {
        RTAT_Sched_TAT_Adjust__c mt = new RTAT_Sched_TAT_Adjust__c();
        mt.Parent_Waf_Fab_Schedule__c = idWFS;
        mt.Process__c = proc;
        mt.Subprocess__c = 'MySubProc Sample';
        mt.Adjustable_TAT__c = true;
        mt.Subprocess_TAT__c = dd;
        //mt.End_Date__c = dt;
        insert mt;        
        return mt.Id;
        
    }
    static testMethod void runTest() {
        
        Test.startTest();
        
        //Create ERPDevice;
        Id idERPDevice = createERPDevice();
        //Create RTATSlot
        Id idRTATSlot = createRTATSlot(idERPDevice);
        //Create Waf Fab Schedule
        Id idWFS = createWafFabSched(idRTATSlot);
        //Create Milestones
        Date myDate = date.newinstance(2017, 7, 3);
        Id idMilestone1 = createMilestone(idWFS, 'first Milestone', 0, myDate, false);
        myDate = myDate.addDays(1);
        Id idMilestone1a = createMilestone(idWFS, 'first Milestone', 1, myDate, true);
        myDate = myDate.addDays(1);
        Id idMilestoneSub2 = createMilestone(idWFS, 'Second Milestone', 1, myDate, true);
        myDate = myDate.addDays(1);
        Id idMilestoneSub3 = createMilestone(idWFS, 'Second Milestone', 1, myDate, true);
        myDate = myDate.addDays(1);
        Id idMilestone2 = createMilestone(idWFS, 'Second Milestone', 1, myDate, false);
        myDate = myDate.addDays(1);
        Id idMilestone4 = createMilestone(idWFS, 'Third Milestone', 1, myDate, true);
        
        RTAT_Sched_TAT_Adjust__c myMilestone = [SELECT Id, Parent_Waf_Fab_Schedule__c FROM RTAT_Sched_TAT_Adjust__c 
                                                                WHERE Id = :idMilestone4 LIMIT 1];
        
        ApexPages.StandardController sc = new ApexPages.StandardController(myMilestone);
        
        RTATMilestoneEditDelete tatAdj = new RTATMilestoneEditDelete(sc);
        
               
        List<RTAT_Sched_TAT_Adjust__c> listMilestones = tatAdj.getMilestones();
        
               
        if (listMilestones.size() > 0)
        {
            for (Integer jj = 0; jj< listMilestones.size(); jj++)
            {    
               //get the first one.
               RTAT_Sched_TAT_Adjust__c milestone = listMilestones.get(jj);
               milestone.addDays__c = 2;
               listMilestones.set(jj, milestone);
               tatAdj.setMilestones(listMilestones);
               
            }
            tatAdj.adjust();
        } 
        
        RTAT_Wafer_Fab_Schedule_Inputs__c myWFSI = tatAdj.getWafFabSched();
        
        tatAdj.save();
        tatAdj.junk();
        tatAdj.junky();
        tatAdj.junk2();
        tatAdj.junk3();
        tatAdj.junk4();
        
        Test.stopTest();
    }

}