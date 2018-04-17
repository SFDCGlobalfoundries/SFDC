@isTest(seeAllData=false)
public class Device_TriggerHelperTest2 {
    @testSetup static void testdata() {
        DataUtilTest.loadEnvironmentVariables();
    }
    static Id createContact(Id acctId) {
        Contact c = new Contact();
        c.FirstName = 'FirstName';
        c.LastName = 'LastName';
        c.AccountId = acctId;
        c.Email = 'test@test.com';
        c.Department__c = 'TestDepartment';
        try{
            insert c;
            return c.Id;    
        }catch(exception e){}
        return null;
        
    }
    public static New_Part_Creation_Form__c createNPC(string accId,Id devId){
        New_Part_Creation_Form__c npc = new New_Part_Creation_Form__c();
        npc.Account__c = accId;
        npc.BASE_Device__c = devId;
        npc.Originating_Device__c = devId;
        npc.Approver_1__c =userInfo.getUserId();
        npc.Approver_2__c = userInfo.getUserId();
        npc.New_Part_ID__c = 'NPCTEST1';
        npc.CRM_DID__c = 'CDID12345';
        npc.Fab__c = 'FAB 2';
        npc.New_Fab__c = 'FAB 3';
        npc.Reason_for_New_Part__c = Environment_Variable__c.getInstance('NPC_REASON_CHANGE_PID').Value__c;//'Fab To Fab Transfer' ;
        npc.Tapeout_Required__c = 'Yes';
        try{
            insert npc;
            return npc;
        }catch(exception e){}
        return null;
    }
    //Method to test Approval of Business Category RMA
    static testmethod void testupdateNPCs(){
        
        String accId = DesignExecutionUtill_Test.accountId;
        String oppId = DesignExecutionUtill_Test.opportunityId;
        
        Opportunity_Program__c oppProg = new Opportunity_Program__c(Name='Test OppProg',Account__c=accId,Opportunity__c=oppId);
        insert oppProg;
        MPW_Train_Maintenance__c mpw = new MPW_Train_Maintenance__c();
        mpw.Name = 'MPW1011';
        mpw.Active__c = true;
        mpw.Train_Type__c = 'GlobalShuttle';
        insert mpw;
        Map<String, Object> mapMaskSetTit = new Map<String, Object>();
        mapMaskSetTit.put('Name', 'MSTTRT');
        Mask_Set_Title__c mst = MaskSetTitleDataFactory.createMaskSetTitle(mapMaskSetTit);
        string MSTAccId = DeviceUtilTest.createMSTAccount(accId,MST.Id);
        Map<String,Object> fieldValueDevMap = new Map<String,Object>();
        fieldValueDevMap.put('Account__c', accId);
        fieldValueDevMap.put('Opportunity_Program__c', oppProg.id);
        fieldValueDevMap.put('Device_Sourcing__c', '1st Source');
        fieldValueDevMap.put('Fab__c', 'Fab 7');
        fieldValueDevMap.put('Tapeout_Type__c','GlobalShuttle MPW');
        fieldValueDevMap.put('Secure_Device__c','Secure Device');
        fieldValueDevMap.put('Mask_Set_Title_Lookup__c',mst.id); 
        fieldValueDevMap.put('MPW_Train_Number__c',mpw.id); 
        Device__c dev = DeviceDataFactory.createDevice(fieldValueDevMap);
        
        Test.startTest();
        dev.Secure_Device__c = 'Secure Device1';
        dev.Mask_Set_Title_Lookup__c = mst.id;
        checkRecursive.runOnceAgain = true;
        checkRecursive.run = true;
        update dev;
        Map<Id, New_Part_Creation_Form__c> mapNPC = new Map<Id, New_Part_Creation_Form__c>();
        BX_041__c bObj = new BX_041__c(Approver_1__c =userInfo.getUserId(),Approver_2__c =userInfo.getUserId(),Approver_3__c =userInfo.getUserId(), Device__c =dev.Id);
        insert bObj;
        
        New_Part_Creation_Form__c npc = createNPC(accId,dev.Id);
        
        Approval.ProcessSubmitRequest app = new Approval.ProcessSubmitrequest();
        app.setComments('Rejected');
        app.setObjectId(npc.Id);
        Approval.ProcessResult result = Approval.process(app);
        
        Set<Id> setOfId = new Set<id> ();
        setOfId.add(npc.Id);
        Device_TriggerHelper deviceTH = new Device_TriggerHelper();
        deviceTH.updateNPCs(setOfId);
        deviceTH.updateOpp();
        set<id> oppIds = New set<id>();
        oppIds.add(oppId);
        deviceTH.updateOPDevices(oppIds);
        
        deviceTH.catchCover(dev.id,'No Msg','MethodName');
        Test.stopTest();
    }
    //Method to test Approval of Business Category RMA
    static testmethod void testupdateNPCs1(){
        
        String accId = DesignExecutionUtill_Test.accountId;
        String oppId = DesignExecutionUtill_Test.opportunityId;
        
        Opportunity_Program__c oppProg = new Opportunity_Program__c(Name='Test OppProg',Account__c=accId,Opportunity__c=oppId);
        insert oppProg;
        
        Process_Technology__c procTech = New Process_Technology__c();
        procTech.Name = 'Process Name';
        insert procTech;
        
        
        Process__c procss = New Process__c();
        procss.Name = 'Process Name';
        insert procss;
        
        
        Map<String, Object> mapMaskSetTit = new Map<String, Object>();
        Map<String, Object> mapMaskSetTit1 = new Map<String, Object>();
        mapMaskSetTit.put('Name', 'MSTTRT');
        
        Mask_Set_Title__c mst = MaskSetTitleDataFactory.createMaskSetTitle(mapMaskSetTit);
        
        string MSTAccId = DeviceUtilTest.createMSTAccount(accId,MST.Id);
        Map<String,Object> fieldValueDevMap = new Map<String,Object>();
        fieldValueDevMap.put('Account__c', accId);
        fieldValueDevMap.put('Opportunity_Program__c', oppProg.id);
        fieldValueDevMap.put('Device_Sourcing__c', '1st Source');
        fieldValueDevMap.put('Fab__c', 'Fab 7');
        fieldValueDevMap.put('Tapeout_Type__c','Full Layer Retrofit');
        fieldValueDevMap.put('Secure_Device__c','Secure Device');
        fieldValueDevMap.put('Process_Technology_2__c',procTech.id);
        fieldValueDevMap.put('Assigned_Process_ID__c',procss.id);
        fieldValueDevMap.put('BX041_Status__c','Pending Acknowledgement');
        fieldValueDevMap.put('Mask_Set_Title_Lookup__c',mst.Id);
        
        Test.startTest();
        Device__c dev = DeviceDataFactory.createDevice(fieldValueDevMap);
        //createContact(accId);
        BX_041__c bObj = new BX_041__c(Approver_1__c =userInfo.getUserId(),Approver_2__c =userInfo.getUserId(),Approver_3__c =userInfo.getUserId(),Assigned_Process_ID__c = procss.Id, Device__c =dev.Id,BX_041_Status__c = 'Closed');
        insert bObj;
        checkRecursive.runOnceAgain = true;
        
        //Device__c upDev = new Device__c(Id=dev.Id);
        Dev.Secure_Device__c = 'Yes';
        
        update Dev;
        Map<Id, New_Part_Creation_Form__c> mapNPC = new Map<Id, New_Part_Creation_Form__c>();
        
        
        New_Part_Creation_Form__c npc = createNPC(accId,dev.Id);
        dev.Secure_Device__c = 'Secure';
        dev.NPC_Form__c = npc.id;
        //checkRecursive.runOnceAgain = true;
        //checkRecursive.run = true;
        update dev;
        
        Set<Id> setOfId = new Set<id> ();
        setOfId.add(npc.Id);
        Device_TriggerHelper deviceTH = new Device_TriggerHelper();
        //deviceTH.updateNPCs(setOfId);
        
        
        deviceTH.catchCover(dev.id,'No Msg','MethodName');
        Test.stopTest();
        
    }
    static testmethod void testupdateNPCs1More(){
        
        String accId = DesignExecutionUtill_Test.accountId;
        String oppId = DesignExecutionUtill_Test.opportunityId;
        
        Opportunity_Program__c oppProg = new Opportunity_Program__c(Name='Test OppProg',Account__c=accId,Opportunity__c=oppId);
        insert oppProg;
        
        Process_Technology__c procTech = New Process_Technology__c();
        procTech.Name = 'Process Name';
        insert procTech;
        
        
        Process__c procss = New Process__c();
        procss.Name = 'Process Name';
        insert procss;
        
        
        Map<String, Object> mapMaskSetTit = new Map<String, Object>();
        Map<String, Object> mapMaskSetTit1 = new Map<String, Object>();
        mapMaskSetTit.put('Name', 'MSTTRT');
        mapMaskSetTit1.put('Name', 'MSRT1F');
        Mask_Set_Title__c mst = MaskSetTitleDataFactory.createMaskSetTitle(mapMaskSetTit);
        Mask_Set_Title__c mst1 = MaskSetTitleDataFactory.createMaskSetTitle(mapMaskSetTit1);
        string MSTAccId = DeviceUtilTest.createMSTAccount(accId,MST.Id);
        Map<String,Object> fieldValueDevMap = new Map<String,Object>();
        fieldValueDevMap.put('Account__c', accId);
        fieldValueDevMap.put('Opportunity_Program__c', oppProg.id);
        fieldValueDevMap.put('Device_Sourcing__c', '1st Source');
        fieldValueDevMap.put('Fab__c', 'Fab 7');
        fieldValueDevMap.put('Tapeout_Type__c','Full Layer Retrofit');
        fieldValueDevMap.put('Secure_Device__c','Secure Device');
        fieldValueDevMap.put('Process_Technology_2__c',procTech.id);
        fieldValueDevMap.put('Assigned_Process_ID__c',procss.id);
        fieldValueDevMap.put('BX041_Status__c','Pending Acknowledgement');
        fieldValueDevMap.put('Mask_Set_Title_Lookup__c',mst.Id);
        
        Test.startTest();
        checkRecursive.run1s = true;
        Device__c dev = DeviceDataFactory.createDevice(fieldValueDevMap);
        //createContact(accId);
        
        checkRecursive.runOnceAgain = true;
        
        //Device__c upDev = new Device__c(Id=dev.Id);
        Dev.Secure_Device__c = 'Yes';
        Dev.Mask_Set_Title_Lookup__c = mst1.id;
        checkRecursive.run1s = true;
        update Dev;
        
        Test.stopTest();
        
    }
    
    static testmethod void testupdateNPCs12(){
        
        String accId = DesignExecutionUtill_Test.accountId;
        String oppId = DesignExecutionUtill_Test.opportunityId;
        
        Opportunity_Program__c oppProg = new Opportunity_Program__c(Name='Test OppProg',Account__c=accId,Opportunity__c=oppId);
        insert oppProg;
        
        Process_Technology__c procTech = New Process_Technology__c();
        procTech.Name = 'Process Name';
        insert procTech;
        
        
        Process__c procss = New Process__c();
        procss.Name = 'Process Name';
        insert procss;
        
        
        Map<String, Object> mapMaskSetTit = new Map<String, Object>();
        mapMaskSetTit.put('Name', 'MSTTRT');
        Mask_Set_Title__c mst = MaskSetTitleDataFactory.createMaskSetTitle(mapMaskSetTit);
        string MSTAccId = DeviceUtilTest.createMSTAccount(accId,MST.Id);
        Map<String,Object> fieldValueDevMap = new Map<String,Object>();
        fieldValueDevMap.put('Account__c', accId);
        fieldValueDevMap.put('Opportunity_Program__c', oppProg.id);
        fieldValueDevMap.put('Device_Sourcing__c', '1st Source');
        fieldValueDevMap.put('Fab__c', 'Fab 7');
        fieldValueDevMap.put('Tapeout_Type__c','Single Product1');
        fieldValueDevMap.put('Secure_Device__c','Secure Device');
        fieldValueDevMap.put('Process_Technology_2__c',procTech.id);
        fieldValueDevMap.put('Assigned_Process_ID__c',procss.id);
        fieldValueDevMap.put('BX041_Status__c','Pending Acknowledgement');
        Test.startTest();
        Device__c dev = DeviceDataFactory.createDevice(fieldValueDevMap);
        dev.Secure_Device__c = 'Secure Device1';
        dev.Mask_Set_Title_Lookup__c = null;
        dev.Status__c = 'Inactive';
        checkRecursive.runOnceAgain = true;
        update dev;
        createContact(accId);
        BX_041__c bObj = new BX_041__c(Approver_1__c =userInfo.getUserId(),Approver_2__c =userInfo.getUserId(),Approver_3__c =userInfo.getUserId(),Assigned_Process_ID__c = procss.Id, Device__c =dev.Id,BX_041_Status__c = 'Frozen/Pending PID Assignment');
        insert bObj;
        //bObj.Assigned_Process_ID__c = procss.Id;
        //bObj.BX_041_Status__c = 'Closed';
        //update bObj;
        
    }
    static testmethod void testupdateCDRSApprovalUserPopulation(){
        
        String accId = DesignExecutionUtill_Test.accountId;
        String oppId = DesignExecutionUtill_Test.opportunityId;
        String accId2 = DesignExecutionUtill_Test.accountId;
        String oppId2 = DesignExecutionUtill_Test.opportunityId;
        createContact(accId);
        List<Process_Technology__c> lstPt = new List<Process_Technology__c>();
        List<Process__c> lstProcess = new List<Process__c>();
        List<Opportunity_Program__c> lstOptProg = new List<Opportunity_Program__c>();
        Opportunity_Program__c oppProg = new Opportunity_Program__c(Name='Test OppProg',Account__c=accId,Opportunity__c=oppId);
        lstOptProg.add(oppProg);
        Opportunity_Program__c oppProg2 = new Opportunity_Program__c(Name='Test OppProg',Account__c=accId2,Opportunity__c=oppId2);
        lstOptProg.add(oppProg2);
        
        Process_Technology__c procTech = New Process_Technology__c();
        procTech.Name = 'Process Name';
        lstPt.add(procTech);
        Process_Technology__c procTech2 = New Process_Technology__c();
        procTech2.Name = 'Process Name';
        lstPt.add(procTech2);
        Process__c procss = New Process__c();
        procss.Name = 'Process Name';
        lstProcess.add(procss);
        Process__c procss2 = New Process__c();
        procss2.Name = 'Process Name';
        lstProcess.add(procss2);
        try{
            insert lstOptProg;
            insert lstPt;
            insert lstProcess;
        }catch(exception e){}
        
        User u = [Select Id,HCM_Login_Id__c from User where Id=:userInfo.getUserId()];
        string s = u.HCM_Login_Id__c+','+u.HCM_Login_Id__c+','+u.HCM_Login_Id__c;
        Map<String, Object> mapMaskSetTit = new Map<String, Object>();
        mapMaskSetTit.put('Name', 'MSTTRT');
        Mask_Set_Title__c mst = MaskSetTitleDataFactory.createMaskSetTitle(mapMaskSetTit);
        string MSTAccId = DeviceUtilTest.createMSTAccount(accId,MST.Id);
        Map<String,Object> fieldValueDevMap = new Map<String,Object>();
        fieldValueDevMap.put('Account__c', accId);
        fieldValueDevMap.put('Opportunity_Program__c', oppProg.id);
        fieldValueDevMap.put('Device_Sourcing__c', '1st Source');
        fieldValueDevMap.put('Fab__c', 'Fab 7');
        fieldValueDevMap.put('Tapeout_Type__c','Single Product1');
        fieldValueDevMap.put('Secure_Device__c','Secure Device');
        fieldValueDevMap.put('Process_Technology_2__c',procTech.id);
        fieldValueDevMap.put('Assigned_Process_ID__c',procss.id);
        fieldValueDevMap.put('BX041_Status__c','Pending Acknowledgement');
        
        Map<String,Object> fieldValueDevMap2 = new Map<String,Object>();
        fieldValueDevMap2.put('Account__c', accId);
        fieldValueDevMap2.put('Opportunity_Program__c', oppProg.id);
        fieldValueDevMap2.put('Device_Sourcing__c', '1st Source');
        fieldValueDevMap2.put('Fab__c', 'Fab 9');
        fieldValueDevMap2.put('Tapeout_Type__c','Full Layer Retrofit');
        fieldValueDevMap2.put('Secure_Device__c','Secure Device');
        fieldValueDevMap2.put('Process_Technology_2__c',procTech.id);
        fieldValueDevMap2.put('Assigned_Process_ID__c',procss.id);
        fieldValueDevMap2.put('BX041_Status__c','Pending Acknowledgement');
        test.startTest();
        Device__c dev = DeviceDataFactory.createDevice(fieldValueDevMap);
        
        
        //Device__c dev2 = DeviceDataFactory.createDevice(fieldValueDevMap2);
        checkRecursive.runOnceAgain = true;
        Device__c dev2 = new Device__c(Name = 'TESTDEVICEZAIH12345677FF',
                                       GSOP_Assignment_Tapeout_Plan__c = 'No',
                                       Market_Segment__c = 'Automotive',
                                       Semiconductor_Device__c = 'Analog Amplifier',
                                       End_Customer__c = 'Test Customer',
                                       Stage__c = 'Design In',
                                       Status__c = 'Active',
                                       Siebel_Device_ID__c = '1234567890',
                                       PLM_Device_ID__c = 'ANBQP60ACO8CH-U01',
                                       Device_Mask_Set_Title__c = '',
                                       Confidence_Level_Tapeout__c = '100',
                                       Original_Forecasted_Tapeout_Date__c = date.today().addDays(7),
                                       CRMDID__c = 'CDID0000001.00FF',
                                       Device_Type__c = 'Retrofit',
                                       reticle_type__c = 'Small Field Reticle (SFR)',
                                       End_Application__c = 'Body',
                                       Base_Device__c = dev.Id,Mask_Set_Title_Lookup__c = mst.Id,
                                       Tapeout_Type__c = Environment_Variable__c.getInstance('DEVICE_TYPE_RETROFIT').Value__c
                                      );       
        
        for(String fieldName: fieldValueDevMap2.keySet())
        {
            dev2.put(fieldName, fieldValueDevMap2.get(fieldName));        
        }
        dev2.Fab__c = 'FAB 9';
        insert dev2;
        
        system.assertEquals(dev2.Device_Type__c, 'Retrofit');
        system.assertEquals(dev2.Tapeout_Type__c, 'Full Layer Retrofit');
        BX_041__c bObj = new BX_041__c(Approver_1__c =userInfo.getUserId(), Approver_2__c =userInfo.getUserId(),Approver_3__c =userInfo.getUserId(), Device__c =dev2.Id, Assigned_Process_ID__c = procss.Id);
        insert bObj;
        checkRecursive.runOnceAgain = true;
        bObj.BX_041_Status__c = 'Closed';
        update bObj;
        
        Test.stopTest();
        Savepoint sp = Database.setSavepoint();
        
        try{
            
            dev2.CDRS_approval_User__c = null;
            dev2.Configuration_Status__c = null;
            
            dev2.Device_Mask_Set_Title__c = null;
            dev2.Tapeout_Type__c = 'Retrofit';
            dev2.BX041_Status__c = 'Closed';
            update dev2;
        }
        catch(exception e){
            Database.rollback(sp);
        }
        New_Part_Creation_Form__c npcForm = createNPCForm(accId, dev.Id); 
        dev2.CDRS_approval_User__c = null;
        dev2.Configuration_Status__c = null;
        dev2.Tapeout_Type__c = 'Retrofit';
        dev2.BX041_Status__c = null;
        
        dev2.NPC_Form__c = npcForm.Id;
        try{
            //update dev2;
        }
        catch(exception e){
            Database.rollback(sp);
        }
        dev2.CDRS_approval_User__c = null;
        dev2.Configuration_Status__c = null;
        dev2.BX041_Status__c = null;
        //New_Part_Creation_Form__c npcForm = createNPCForm(accId, dev.Id); 
        dev2.NPC_Form__c = null;
        dev2.Base_Device__c = dev.Id;
        dev2.Tapeout_Type__c = 'Retrofit';
        
        
        try{
            //update dev2;
        }
        catch(exception e){}
        
        
        //system.assertEquals(devT.CDRS_approval_User__c,s);
        
    }
    static testmethod void testapprovalNPC(){
        
        String accId = DesignExecutionUtill_Test.accountId;
        String oppId = DesignExecutionUtill_Test.opportunityId;
        
        Test.startTest();
        Opportunity_Program__c oppProg = new Opportunity_Program__c(Name='Test OppProg',Account__c=accId,Opportunity__c=oppId);
        insert oppProg;
        MPW_Train_Maintenance__c mpw = new MPW_Train_Maintenance__c();
        mpw.Name = 'MPW1011';
        mpw.Active__c = true;
        mpw.Train_Type__c = 'GlobalShuttle';
        insert mpw;
        Map<String, Object> mapMaskSetTit = new Map<String, Object>();
        mapMaskSetTit.put('Name', 'MPW1011');
        mapMaskSetTit.put('Technology__c', '22FDX');
        Mask_Set_Title__c mst = MaskSetTitleDataFactory.createMaskSetTitle(mapMaskSetTit);
        string MSTAccId = DeviceUtilTest.createMSTAccount(accId,MST.Id);
        Map<String,Object> fieldValueDevMap = new Map<String,Object>();
        fieldValueDevMap.put('Account__c', accId);
        fieldValueDevMap.put('Opportunity_Program__c', oppProg.id);
        fieldValueDevMap.put('Device_Sourcing__c', '1st Source');
        fieldValueDevMap.put('Fab__c', 'Fab 7');
        fieldValueDevMap.put('Tapeout_Type__c','GlobalShuttle MPW');
        fieldValueDevMap.put('MPW_Train_Number__c',mpw.id); 
        fieldValueDevMap.put('Mask_Set_Title_Lookup__c',mst.Id);
        fieldValueDevMap.put('Device_Mask_Set_Title__c','MPW1011');
        Device__c dev = DeviceDataFactory.createDevice(fieldValueDevMap);
        Map<Id, New_Part_Creation_Form__c> mapNPC = new Map<Id, New_Part_Creation_Form__c>();
        BX_041__c bObj = new BX_041__c(Approver_1__c =userInfo.getUserId(),Approver_2__c =userInfo.getUserId(),Approver_3__c =userInfo.getUserId(), Device__c =dev.Id);
        insert bObj;
        checkRecursive.runOnceAgain = true;
        dev.Device_Mask_Set_Title__c = 'MSTTRTF';
        dev.Mask_Set_Title_Lookup__c = null;
        update dev;
        
        New_Part_Creation_Form__c npc = createNPC(accId,dev.Id);
        
        Device_TriggerHelper deviceTH = new Device_TriggerHelper();
        mapNPC.put(npc.Id,npc);
        deviceTH.approvalNPC(mapNPC);            
        test.stopTest();
        
    }
    static testmethod void testapprovalNPCOneMore(){
        
        String accId = DesignExecutionUtill_Test.accountId;
        String oppId = DesignExecutionUtill_Test.opportunityId;
        
        Test.startTest();
        Opportunity_Program__c oppProg = new Opportunity_Program__c(Name='Test OppProg',Account__c=accId,Opportunity__c=oppId);
        insert oppProg;
        MPW_Train_Maintenance__c mpw = new MPW_Train_Maintenance__c();
        mpw.Name = 'MPW1011';
        mpw.Active__c = true;
        mpw.Train_Type__c = 'GlobalShuttle';
        insert mpw;
        Map<String, Object> mapMaskSetTit = new Map<String, Object>();
        mapMaskSetTit.put('Name', 'MPW1011');
        mapMaskSetTit.put('Technology__c', '22FDX');
        Mask_Set_Title__c mst = MaskSetTitleDataFactory.createMaskSetTitle(mapMaskSetTit);
        string MSTAccId = DeviceUtilTest.createMSTAccount(accId,MST.Id);
        Map<String,Object> fieldValueDevMap = new Map<String,Object>();
        fieldValueDevMap.put('Account__c', accId);
        fieldValueDevMap.put('Opportunity_Program__c', oppProg.id);
        fieldValueDevMap.put('Device_Sourcing__c', '1st Source');
        fieldValueDevMap.put('Fab__c', 'Fab 7');
        fieldValueDevMap.put('Tapeout_Type__c','Customer MPW');
        fieldValueDevMap.put('MPW_Train_Number__c',mpw.id); 
        fieldValueDevMap.put('Mask_Set_Title_Lookup__c',mst.Id);
        fieldValueDevMap.put('Device_Mask_Set_Title__c','MPW1011');
        Device__c dev = DeviceDataFactory.createDevice(fieldValueDevMap);
        Map<Id, New_Part_Creation_Form__c> mapNPC = new Map<Id, New_Part_Creation_Form__c>();
        BX_041__c bObj = new BX_041__c(Approver_1__c =userInfo.getUserId(),Approver_2__c =userInfo.getUserId(),Approver_3__c =userInfo.getUserId(), Device__c =dev.Id);
        insert bObj;
        
        New_Part_Creation_Form__c npc = createNPC(accId,dev.Id);
        Device_TriggerHelper deviceTH = new Device_TriggerHelper();
        mapNPC.put(npc.Id,npc);
        deviceTH.approvalNPC(mapNPC);            
        test.stopTest();
        
    }
    
    static testmethod void testdeviceMaskSetTitleRec(){
        User thisUser = DeviceChecklistTestDataUtils.createUserWithDCAdmin('System Administrator');
        System.runAs(thisUser){
            String accId = DesignExecutionUtill_Test.accountId;
            String oppId = DesignExecutionUtill_Test.opportunityId;
            
            Opportunity_Program__c oppProg = new Opportunity_Program__c(Name='Test OppProg',Account__c=accId,Opportunity__c=oppId);
            insert oppProg;
            
            Map<String, Object> mapMaskSetTit = new Map<String, Object>();
            mapMaskSetTit.put('Name', 'MSTTRTF');
            Mask_Set_Title__c mst = MaskSetTitleDataFactory.createMaskSetTitle(mapMaskSetTit);
            string MSTAccId = DeviceUtilTest.createMSTAccount(accId,MST.Id);
            Map<String,Object> fieldValueDevMap = new Map<String,Object>();
            fieldValueDevMap.put('Account__c', accId);
            fieldValueDevMap.put('Opportunity_Program__c', oppProg.id);
            fieldValueDevMap.put('Device_Sourcing__c', '1st Source');
            fieldValueDevMap.put('Fab__c', 'Fab 7');
            fieldValueDevMap.put('Tapeout_Type__c','Single Product');
            fieldValueDevMap.put('Device_Mask_Set_Title__c','MPW101F');
            Test.startTest();
            Device__c dev = DeviceDataFactory.createDevice(fieldValueDevMap); 
            dev.Secure_Device__c = 'Yes';
            //dev.Mask_Set_Title_Lookup__c = mst.Id;
            try{
                update dev;
            }
            catch(Exception e){
                
            }
            Device_TriggerHelper deviceTH = new Device_TriggerHelper();
            //deviceTH.deviceMaskSetTitleRec();
            test.stopTest();
        }
        
    }
    static New_Part_Creation_Form__c createNPCForm(Id accountId, Id deviceId) {
        New_Part_Creation_Form__c npc = new New_Part_Creation_Form__c();
        npc.Account__c = accountId;
        npc.BASE_Device__c = deviceId;
        npc.Originating_Device__c = deviceId;
        npc.New_Part_ID__c = 'NPCTEST1';
        npc.CRM_DID__c = 'CDID12345';
        npc.Fab__c = 'FAB 9';
        npc.New_Fab__c = 'FAB 3';
        npc.Reason_for_New_Part__c = 'Fab To Fab Transfer' ;
        npc.Tapeout_Required__c = 'No';
        
        insert npc;
        
        return npc;
    }
    public static Id getWorkItemId(Id targetObjectId)
    {
        Id retVal = null;
        
        for(ProcessInstanceWorkitem workItem  : [Select p.Id from ProcessInstanceWorkitem p
                                                 where p.ProcessInstance.TargetObjectId =: targetObjectId])
        {
            retVal  =  workItem.Id;
        }
        
        return retVal;
    }
    
}