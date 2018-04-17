/*
 * Author: Elizabeth Button
 * Test class for RTATScheduleViewController apex class
 * Created April 24th, 2017
 *  
*/

@isTest
public class RTATScheduleViewControllerTest {
      @testSetup static void testdata() {
        DataUtilTest.loadEnvironmentVariables();
     }
    static Id createAccount()
    {
        Account account = new Account();
        account.Name = 'MyJunkAcct';
        insert account;
        return account.id;
    }    
        
    static Id createOppy(Id accntId)
    {
        opportunity oppy = new opportunity();
        oppy.AccountId = accntId;
        
        oppy.Name = 'MyDummyOpp';
        oppy.CloseDate = date.today();
        oppy.CloseDate = oppy.CloseDate.addMonths(1);
        insert oppy;
        return oppy.Id;
    }
    static Id createERPDevice(Id oppyId) {
        
        ERP_Device__c erpDevice = new ERP_Device__c();
        erpDevice.Technology__c = 'SIGE8XP';
        erpDevice.Fab__c = 'FAB 9';
        erpDevice.Product_Type__c = 'Foundry';
        erpDevice.Deliverable_Type__c = 'WAFER';
        erpDevice.Name = 'MOSIS 910';
        erpDevice.Part_Number__c = '0000001KG304';
        erpDevice.Level__c = '27';
        erpDevice.Option_ID__c = 'OPT043516';
        erpDevice.Opportunity_ID__c = 'something';
        erpDevice.Opportunity__c = oppyId;
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
        wfs.RIT_Type__c = 'A';
        wfs.LOM_or_Mask_Layers__c = 'Levels of Metal';
        wfs.RIT_A_Quality__c = 'PQ';
        wfs.RIT_A_Speed__c = 'TURBO';
        wfs.RIT_A_Wafer_Start_Quantity__c = 8;
        wfs.RIT_B_Quality__c = 'PQ';
        wfs.RIT_B_Speed__c = 'TURBO';
        wfs.RIT_B_Wafer_Start_Quantity__c = 6;
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
    
    static Id createWafFinSched(Id RTATSlotId)
    {
        RTAT_Wafer_Finish_Sched_Input__c wfins = new RTAT_Wafer_Finish_Sched_Input__c();
        wfins.Name = 'Sample_FIN';
        wfins.Chip_Attach_Type__c = 'WB';
        wfins.Lot_size__c = 6;
        wfins.Quality__c = 'PQ';
        wfins.RTAT_Slot__c = RTATSlotid;
        wfins.Speed__c = 'TURBO';
        wfins.Test_Tier__c ='1';
        wfins.Wafer_Finish_Start_Date__c = Date.parse('10/03/2017');
        wfins.Wafer_or_device_to_stock_quantity__c = 100;
        wfins.Wafer_size__c = '200MM';
        wfins.Wafer_Test__c = true;
        insert wfins;
        return wfins.Id;
    }
    static Id createModuleSchedule(Id RTATSlotId)
    {
        RTAT_Module_Schedule_Input__c modSched = new RTAT_Module_Schedule_Input__c();
        modSched.Module_Final_Test__c = true;
        modSched.Module_Start_Quantity__c = 20;
        modSched.Modules_to_Stock_Quantity__c = 10;
        modSched.Package_Type__c = 'TQFPEP';
        modSched.Quality__c = 'PQ';
        modSched.RTAT_Slot__c = RTATSlotId;
        modSched.Speed__c = 'TURBO';
        modSched.Test_Tier__c = 1;
        insert modSched;
        return modSched.Id;
    }
    
    static id createMilestone(Id idWFS, String proc, String subproc, double TotTAT, Date endDate, boolean bb)
    {
        RTAT_Sched_TAT_Adjust__c mt = new RTAT_Sched_TAT_Adjust__c();
        mt.Parent_Waf_Fab_Schedule__c = idWFS;
        mt.Process__c = proc;
        mt.Subprocess__c = subproc;
        mt.Adjustable_TAT__c = bb;
        mt.Total_TAT__c = TotTAT;
        if (endDate > date.parse('01/02/2001'))
        {
            mt.End_Date__c =endDate;
        }
        mt.addDays__c = 0;
        insert mt;        
        return mt.Id;
    }
    static Id createRTATBOM(Id RTATSlotId)
    {
        RTAT_BOM__c rtatBOM = new RTAT_BOM__c();
        rtatBOM.Component__c = '0000001LN001';
        rtatBOM.Level_code__c = '27';
        rtatBOM.Part_Classification__c = 'BEOL Wafer';
        rtatBOM.RTAT_Slot__c = RTATSlotId;
        insert rtatBOM;
        return rtatBOM.Id;
    }
    
    static testMethod void runTest1() 
    {
        Test.startTest();
        Id accntId = createAccount();
        Id myOppyId = createOppy(accntId);
        //Create ERPDevice;
        Id idERPDevice = createERPDevice(myOppyId);
        //Create RTATSlot
        Id idRTATSlot = createRTATSlot(idERPDevice);
        //Create Waf Fab Schedule
        Id idWFS = createWafFabSched(idRTATSlot);
        //Create Wafer Finish Schedule
        Id idWFinS = createWafFinSched(idRTATSlot);
        //create module schdule
        Id idModSched = createModuleSchedule(idRTATSlot);
        //Create Milestones
        Date myDate = date.newinstance(2017, 7, 3);
        Id idMT1 = createMilestone(idWFS, 'MaskHouse CCDesk', null, 0, myDate, false);
        myDate = date.newInstance(2017, 7, 6);
        Id idMT2 = createMilestone(idWFS, 'RIT A Mask TAT', null, 2, myDate, true);
        myDate = date.newInstance(2017, 7, 6);
        Id idMT3 = createMilestone(idWFS, 'RIT A Transit TAT', null, 0, myDate, true);
        myDate = date.newInstance(2017, 7, 6);
        Id idMT4 = createMilestone(idWFS, 'RIT A Fab Prep TAT', null, 0, myDate, true);
     
        myDate = date.newInstance(2001, 01, 01);
        double ddTotalTAT = 11.5;
        Id idMT5 = createMilestone(idWFS, 'RIT A Wafer TAT', 'Normal Wafer TAT', ddTotalTAT, myDate, true); 
        Id idMT6 = createMilestone(idWFS, 'RIT A Wafer TAT', 'BR'              , 1,    myDate, true);
        Id idMT7 = createMilestone(idWFS, 'RIT A Wafer TAT', 'Exceed Std Lot Size', 0, myDate, true);
 
        myDate = date.newInstance(2017, 7, 18);
        ddTotalTAT = 12.5;
        Id idMT8 = createMilestone(idWFS, 'RIT A Wafer TAT', 'Total RIT A TAT', ddTotalTAT, myDate, false);
  
        myDate = date.newInstance(2017, 7, 18);
        Id idMT9 = createMilestone(idWFS, 'Ship Prep TAT', null, 0, myDate, true);
        
        Id idBOM = createRTATBOM(idRTATSlot );
        
        ApexPages.currentPage().getParameters().put('Id', idRTATSlot );
        RTATScheduleViewController RTATSlotView = new RTATScheduleViewController();
        RTAT_Slot__c myTestSlot = RTATSlotView.getRTATSlot();
        RTATSlotView.setRTATSlot(myTestSlot);
        
        // test getting parent ERP Device 
        ERP_Device__c sobjMotherERPDev = RTATSlotView.getERP_Device();
        
        RTAT_Wafer_Fab_Schedule_Inputs__c myWFSI = RTATSlotView.getWaferFabSchedInput();
        myWFSI.RIT_Type__c = 'B';
        RTATSlotView.setWaferFabSchedInput(myWFSI);
        
        Decimal myQty = RTATSlotView.getFinalShipQty();
        
        RTAT_Wafer_Finish_Sched_Input__c myFin = RTATSlotView.getWaferFinishSchedInput();
        
        RTAT_Module_Schedule_Input__c myModSched = RTATSlotView.getRTATModuleScheduleInput();
        
        List<RTAT_Sched_TAT_Adjust__c> listMT =  RTATSlotView.getMilestones();
        
        List<RTAT_BOM__c> listBOM = RTATSlotView.getRTATBOM();
        
        System.assertEquals(9, listMT.size());
        
        RTATSlotView.setMilestones(listMT);
        System.assertEquals(listMT, RTATSlotView.MilestoneTATs);
        
        String sAcctName = RTATSlotView.getAccountName();
        
        Decimal dQty= RTATSlotView.getFinalShipQty();
        System.assertEquals(10, dQty);
        
        RTATSlotView.saveAttachement();
        try
        {
            RTATSlotView.publishSchedule();
        }
        catch (Exception ee)
        {
            system.debug('in the publishSchedule catch block');
        }    
        
        Test.stopTest();
    }
    static testMethod void runTest2() 
    {
        Test.startTest();
        Id accntId = createAccount();
        Id myOppyId = createOppy(accntId);
        //Create ERPDevice;
        Id idERPDevice = createERPDevice(myOppyId);
        //Create RTATSlot
        Id idRTATSlot = createRTATSlot(idERPDevice);
        //Create Waf Fab Schedule
        Id idWFS = createWafFabSched(idRTATSlot);
        
        //Create Wafer Finish Schedule
        Id idWFinS = createWafFinSched(idRTATSlot);
        //create module schdule
        Id idModSched = createModuleSchedule(idRTATSlot);
        //Create Milestones
        Date myDate = date.newinstance(2017, 7, 3);
        Id idMT1 = createMilestone(idWFS, 'MaskHouse CCDesk', null, 0, myDate, false);
        myDate = date.newInstance(2017, 7, 6);
        Id idMT2 = createMilestone(idWFS, 'RIT A Mask TAT', null, 2, myDate, true);
        myDate = date.newInstance(2017, 7, 6);
        Id idMT3 = createMilestone(idWFS, 'RIT A Transit TAT', null, 0, myDate, true);
        myDate = date.newInstance(2017, 7, 6);
        Id idMT4 = createMilestone(idWFS, 'RIT A Fab Prep TAT', null, 0, myDate, true);
     
        myDate = date.newInstance(2001, 01, 01);
        double ddTotalTAT = 11.5;
        Id idMT5 = createMilestone(idWFS, 'RIT A Wafer TAT', 'Normal Wafer TAT', ddTotalTAT, myDate, true); 
        Id idMT6 = createMilestone(idWFS, 'RIT A Wafer TAT', 'BR'              , 1,    myDate, true);
        Id idMT7 = createMilestone(idWFS, 'RIT A Wafer TAT', 'Exceed Std Lot Size', 0, myDate, true);
 
        myDate = date.newInstance(2017, 7, 18);
        ddTotalTAT = 12.5;
        Id idMT8 = createMilestone(idWFS, 'RIT A Wafer TAT', 'Total RIT A TAT', ddTotalTAT, myDate, false);
  
        myDate = date.newInstance(2017, 7, 18);
        Id idMT9 = createMilestone(idWFS, 'Ship Prep TAT', null, 0, myDate, true);
        
        //ApexPages.currentPage().getParameters().put('Id', idRTATSlot );
        
        RTAT_Slot__c rtatSlot = new RTAT_Slot__c();
        rtatSlot = [select Name, Id from RTAT_Slot__c where id =:idRTATSlot limit 1];
        ApexPages.StandardController cont = new ApexPages.StandardController(rtatSlot);
        RTATScheduleViewController RTATSlotView = new RTATScheduleViewController(cont);
        
        RTAT_Slot__c myTestSlot = RTATSlotView.getRTATSlot();
        RTATSlotView.setRTATSlot(myTestSlot);
        
        // test getting parent ERP Device
        ERP_Device__c sobjMotherERPDev = RTATSlotView.getERP_Device();
        
        //test final shipment qty several times
        Decimal dQty = RTATSlotView.getFinalShipQty();
        
        RTAT_Wafer_Fab_Schedule_Inputs__c myWFSI = RTATSlotView.getWaferFabSchedInput();
        RTATSlotView.setWaferFabSchedInput(myWFSI);
        
        dQty = RTATSlotView.getFinalShipQty();
        
        RTAT_Wafer_Finish_Sched_Input__c myFin = RTATSlotView.getWaferFinishSchedInput();
        
        dQty = RTATSlotView.getFinalShipQty();
        
        RTAT_Module_Schedule_Input__c myModSched = RTATSlotView.getRTATModuleScheduleInput();
        
        dQty = RTATSlotView.getFinalShipQty();
        
        List<RTAT_Sched_TAT_Adjust__c> listMT =  RTATSlotView.getMilestones();
        System.assertEquals(9, listMT.size());
        
        RTATSlotView.setMilestones(listMT);
        System.assertEquals(listMT, RTATSlotView.MilestoneTATs);
        
        myTestSlot.Wafer_Size__c = '400MM';
        RTATSlotView.setRTATSlot(myTestSlot);
        
        RTATSlotView.saveAttachement();
        try
        {     
           RTATSlotView.publishSchedule();
        }
        catch (Exception ee)
        {
            system.debug('Trying to publish RTAT schedule:' + ee.getMessage());
        }    
        
        Test.stopTest();
    }
    
     static testMethod void runTest3() 
    {
        Test.startTest();
        Id accntId = createAccount();
        Id myOppyId = createOppy(accntId);
        //Create ERPDevice;
        Id idERPDevice = createERPDevice(myOppyId);
        //Create RTATSlot
        Id idRTATSlot = createRTATSlot(idERPDevice);
        ApexPages.currentPage().getParameters().put('Id', idRTATSlot );
        RTATScheduleViewController RTATSlotView = new RTATScheduleViewController();
        
        RTAT_Slot__c myTestSlot = RTATSlotView.getRTATSlot();
        RTAT_Slot__c emptySlot = new RTAT_Slot__c();
        RTATSlotView.setRTATSlot(emptySlot);
        RTATSlotView.rtatSlotID = emptySlot.Id;
        // Try getting the RTAT BOM when no Slot created yet
        try
        {
            List<RTAT_BOM__c> myBOM = RTATSlotView.getRTATBOM();
        }
        catch (Exception e)
        {
            system.debug('in the BOM catch block');
        }
        // Try getting account when nothing done yet
        try
        {    
           String sNoAccnt = RTATSlotView.getAccountName();
        }
        catch (Exception eexx)
        {
            system.debug('in the GetAccountName block');
        }
        
        RTATSlotView.setRTATSlot(myTestSlot);
        RTATSlotView.rtatSlotID = myTestSlot.Id;
        Decimal dQty = RTATSlotView.getFinalShipQty();
        
        try
        {    
            List<RTAT_Sched_TAT_Adjust__c> listMT =  RTATSlotView.getMilestones();
            System.assertEquals(9, listMT.size());
        }
        catch (Exception e)
        {
            system.debug('in the milestone catch block');
        }
            
        RTATSlotView.setRTATSlot(new RTAT_Slot__c());
        try
        {
            RTAT_Wafer_Fab_Schedule_Inputs__c  mySchedInputs = RTATSlotView.getWaferFabSchedInput();
        }  
        catch (Exception e)
        {
            system.debug('in the wfsi catch block');
        }
        
        try
        {
            RTAT_Wafer_Finish_Sched_Input__c myWafFinSched = RTATSlotView.getWaferFinishSchedInput();
        }
        catch(Exception e)
        {
            system.debug('in the Waf Fin Sched catch block');
        }    
        
        try
        {
            RTAT_Module_Schedule_Input__c myModSched = RTATSlotView.getRTATModuleScheduleInput();
        }
        catch (Exception e)
        {
            system.debug('in the modsched catch block');
        }
        
        try
        {
            List<RTAT_BOM__c> myBOM = RTATSlotView.getRTATBOM();
        }
        catch (Exception e)
        {
            system.debug('in the BOM catch block');
        }
            
       
    }  
}