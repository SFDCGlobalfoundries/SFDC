@isTest
public class Device_TriggerHelperTest1 {
    @testSetup static void testdata() {
        DataUtilTest.loadEnvironmentVariables();
    }
    public static testMethod void deviceHelperMethod1(){
    User thisUser = DeviceChecklistTestDataUtils.createUserWithDCAdmin('System Administrator');
    System.runAs(thisUser){
        Map<String,Object> fieldValueAccMap = new Map<String,Object>();
        Account account1 = AccountDataFactory.createAccount(fieldValueAccMap);
        
        Map<String,Object> fieldValueOppMap = new Map<String,Object>();
        fieldValueOppMap.put('AccountId', account1.id);
        Opportunity opp1 = OpportunityDataFactory.createOpportunity(fieldValueOppMap);
        
        Test.startTest();
        Map<String,Object> fieldValueOppProgMap = new Map<String,Object>();
        fieldValueOppProgMap.put('Account__c', account1.id);
        fieldValueOppProgMap.put('Opportunity__c', opp1.id);
        Opportunity_Program__c oppProg = OpportunityProgramDataFactory.createOpportunityProgram(fieldValueOppProgMap);
        
        
        MPW_Train_Maintenance__c m = new MPW_Train_Maintenance__c();
        m.Name = 'zTestMPW';
        m.Customer_Tapeout_Date__c = date.today();
        m.Other_Tapeout_Date__c = date.today();
        
        insert m;
        
        
        Map<String, Object> mapMaskSetTit = new Map<String, Object>();
        mapMaskSetTit.put('Name', 'MSTTRT');
        Mask_Set_Title__c mst = MaskSetTitleDataFactory.createMaskSetTitle(mapMaskSetTit);
        string MSTAccId = DeviceUtilTest.createMSTAccount(account1.Id,MST.Id);
        
        Map<String,Object> fieldValueDevMap = new Map<String,Object>();
        fieldValueDevMap.put('Account__c', account1.id);
        fieldValueDevMap.put('Opportunity_Program__c', oppProg.id);
        fieldValueDevMap.put('Device_Sourcing__c', '1st Source');
        fieldValueDevMap.put('Status__c', 'On Hold');
        fieldValueDevMap.put('Reason_For_Status_On_Hold__c', 'On Hold Test');
        fieldValueDevMap.put('IP_Gap__c', false);
        fieldValueDevMap.put('Siebel_Status__c', 'SUCCESS');
        
        fieldValueDevMap.put('MPW_Train_Number__c', m.id);
        fieldValueDevMap.put('Tapeout_Type__c', 'GlobalShuttle MPW');
        Device__c dev1 = DeviceDataFactory.createDevice(fieldValueDevMap);
        //dev1.Device_Sourcing__c = 'Second Source';
        //Device_TriggerHelper devhelp = new Device_TriggerHelper();
        //devhelp.deviceOnholdDateUpdt();
        dev1.Status__c = 'Active';
        //dev1.Reason_For_Status_On_Hold__c = 'On Hold Test';
        dev1.IP_Gap__c = true;
        dev1.Siebel_Status__c = 'ERROR';
        update dev1;
        Test.stopTest();
        
        
        //Device_TriggerHelper devhelp = new Device_TriggerHelper();
    }   
    }
    
    public static testMethod void deviceHelperMethod2(){
    User thisUser = DeviceChecklistTestDataUtils.createUserWithDCAdmin('System Administrator');
    System.runAs(thisUser){
        Map<String,Object> fieldValueAccMap = new Map<String,Object>();
        Account account1 = AccountDataFactory.createAccount(fieldValueAccMap);
        
        Map<String,Object> fieldValueOppMap = new Map<String,Object>();
        fieldValueOppMap.put('AccountId', account1.id);
        Opportunity opp1 = OpportunityDataFactory.createOpportunity(fieldValueOppMap);
        
        Test.startTest();
        Map<String,Object> fieldValueOppProgMap = new Map<String,Object>();
        fieldValueOppProgMap.put('Account__c', account1.id);
        fieldValueOppProgMap.put('Opportunity__c', opp1.id);
        fieldValueOppProgMap.put('IP_Gaps__c', true);
        Opportunity_Program__c oppProg = OpportunityProgramDataFactory.createOpportunityProgram(fieldValueOppProgMap);
        
        
        Map<String, Object> mapMaskSetTit = new Map<String, Object>();
        mapMaskSetTit.put('Name', 'MSTTRT');
        Mask_Set_Title__c mst = MaskSetTitleDataFactory.createMaskSetTitle(mapMaskSetTit);
        string MSTAccId = DeviceUtilTest.createMSTAccount(account1.Id,MST.Id);
        
        Map<String,Object> fieldValueDevMap = new Map<String,Object>();
        fieldValueDevMap.put('Account__c', account1.id);
        fieldValueDevMap.put('Opportunity_Program__c', oppProg.id);
        fieldValueDevMap.put('Device_Sourcing__c', '1st Source');
        //fieldValueDevMap.put('Status__c', 'On Hold');
        fieldValueDevMap.put('Reason_For_Status_On_Hold__c', 'On Hold Test');
        fieldValueDevMap.put('IP_Gap__c', true);
        //fieldValueDevMap.put('Siebel_Status__c', 'SUCCESS');
        fieldValueDevMap.put('Tapeout_Type__c','Single Product1');
        Device__c dev1 = DeviceDataFactory.createDevice(fieldValueDevMap);
        //dev1.Device_Sourcing__c = 'Second Source';
        //Device_TriggerHelper devhelp = new Device_TriggerHelper();
        //devhelp.deviceOnholdDateUpdt();
        dev1.Status__c = 'On Hold';
        //dev1.Reason_For_Status_On_Hold__c = 'On Hold Test';
        dev1.IP_Gap__c = false;
        //dev1.Siebel_Status__c = 'ERROR';
        update dev1;
        Test.stopTest();
        
        
        //Device_TriggerHelper devhelp = new Device_TriggerHelper();
    }   
    }
    public static testMethod void deviceHelperMethod3(){
    User thisUser = DeviceChecklistTestDataUtils.createUserWithDCAdmin('System Administrator');
    System.runAs(thisUser){
        Map<String,Object> fieldValueAccMap = new Map<String,Object>();
        Account account1 = AccountDataFactory.createAccount(fieldValueAccMap);
        
        Map<String,Object> fieldValueOppMap = new Map<String,Object>();
        fieldValueOppMap.put('AccountId', account1.id);
        Opportunity opp1 = OpportunityDataFactory.createOpportunity(fieldValueOppMap);
        
        Test.startTest();
        Map<String,Object> fieldValueOppProgMap = new Map<String,Object>();
        fieldValueOppProgMap.put('Account__c', account1.id);
        fieldValueOppProgMap.put('Opportunity__c', opp1.id);
        Opportunity_Program__c oppProg = OpportunityProgramDataFactory.createOpportunityProgram(fieldValueOppProgMap);
        
        MPW_Train_Maintenance__c mtm = New MPW_Train_Maintenance__c();
        mtm.Name = '123';
        insert mtm;
        
        Map<String, Object> mapMaskSetTit = new Map<String, Object>();
        mapMaskSetTit.put('Name', 'MSTTRT');
        Mask_Set_Title__c mst = MaskSetTitleDataFactory.createMaskSetTitle(mapMaskSetTit);
        Map<String, Object> mapMaskSetTit1 = new Map<String, Object>();
        mapMaskSetTit1.put('Name', 'MSTTRT1');
        Mask_Set_Title__c mst1 = MaskSetTitleDataFactory.createMaskSetTitle(mapMaskSetTit1);
        string MSTAccId = DeviceUtilTest.createMSTAccount(account1.Id,MST.Id);
        
        Map<String,Object> fieldValueDevMap = new Map<String,Object>();
        fieldValueDevMap.put('Account__c', account1.id);
        fieldValueDevMap.put('Opportunity_Program__c', oppProg.id);
        fieldValueDevMap.put('Device_Sourcing__c', '1st Source');
        fieldValueDevMap.put('Status__c', 'On Hold');
        fieldValueDevMap.put('Reason_For_Status_On_Hold__c', 'On Hold Test');
        fieldValueDevMap.put('IP_Gap__c', true);
        fieldValueDevMap.put('Tapeout_Type__c', 'GlobalShuttle MPW');
        fieldValueDevMap.put('Mask_Set_Title_Lookup__c', mst1.id);
        Device__c dev1 = DeviceDataFactory.createDevice(fieldValueDevMap);
        dev1.Status__c = 'Active';
        dev1.IP_Gap__c = false;
        dev1.Mask_Set_Title_Lookup__c = mst.id;
        try{
            dev1.MPW_Train_Number__c = mtm.id;
            update dev1;
        }catch(Exception e){throw e;}
        Test.stopTest();
        
        
        //Device_TriggerHelper devhelp = new Device_TriggerHelper();
    } 
    }
    
    public static testMethod void NPCFormTestMethod()
    {
        User thisUser = DeviceChecklistTestDataUtils.createUserWithDCAdmin('System Administrator');
        System.runAs(thisUser)
        {
            Map<String,Object> fieldValueAccMap = new Map<String,Object>();
            Account account1 = AccountDataFactory.createAccount(fieldValueAccMap);
            
            Map<String,Object> fieldValueOppMap = new Map<String,Object>();
            fieldValueOppMap.put('AccountId', account1.id);
            Opportunity opp1 = OpportunityDataFactory.createOpportunity(fieldValueOppMap);
        
            Test.startTest();
            Map<String,Object> fieldValueOppProgMap = new Map<String,Object>();
            fieldValueOppProgMap.put('Account__c', account1.id);
            fieldValueOppProgMap.put('Opportunity__c', opp1.id);
            Opportunity_Program__c oppProg = OpportunityProgramDataFactory.createOpportunityProgram(fieldValueOppProgMap);
            
            MPW_Train_Maintenance__c m = new MPW_Train_Maintenance__c();
            m.Name = 'zTestMPW';
            m.Customer_Tapeout_Date__c = date.today();
            m.Other_Tapeout_Date__c = date.today();
        
            insert m;
                                      
            Map<String,Object> fieldValueDevMap = new Map<String,Object>();
            fieldValueDevMap.put('Account__c', account1.id);
            fieldValueDevMap.put('Opportunity_Program__c', oppProg.id);
            fieldValueDevMap.put('Device_Sourcing__c', '1st Source');
            fieldValueDevMap.put('Status__c', 'On Hold');
            fieldValueDevMap.put('Reason_For_Status_On_Hold__c', 'On Hold Test');
            fieldValueDevMap.put('IP_Gap__c', false);
            fieldValueDevMap.put('Siebel_Status__c', 'SUCCESS');
            fieldValueDevMap.put('MPW_Train_Number__c', m.id);
            fieldValueDevMap.put('Current_Forecast_Tapeout_Date__c', Date.today());
            fieldValueDevMap.put('Tapeout_Type__c', 'GlobalShuttle MPW');
            Device__c dev1 = DeviceDataFactory.createDevice(fieldValueDevMap);
            
            Date d = Date.today();
            dev1.Current_Forecast_Tapeout_Date__c = d.addDays(7); 
            update dev1;
            Test.stopTest();       
        }   
    }
}