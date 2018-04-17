/*
Class name : Device_TriggerHelperTest
Changes:
DBiswal     10182017    changes from line no. 48-73 and testCodeCoverage method for code coverge.
*/
@isTest
private class Device_TriggerHelperTest {
    
    @testSetup static void testdata() {
        DataUtilTest.loadEnvironmentVariables();
    }
    
    private static testmethod void testCreatePSP() {
        
        User thisUser= DeviceChecklistTestDataUtils.createUserWithDCAdmin('System Administrator');
        System.runAs(thisUser){
            IntegrationUsers__c skipUser = new IntegrationUsers__c(SetupOwnerId = thisUser.Id, Is_Integration_User__c= true, Skip_Trigger__c = true, Skip_Validation_Rule__c = true);
            insert skipUser;
            
           // UtilityValidatorHelper.hasAlreadyDone();
            
            Map<String,Object> fieldValueAccMap = new Map<String,Object>();
            Account account1 = AccountDataFactory.createAccount(fieldValueAccMap);
            
            Map<String,Object> fieldValueOppMap = new Map<String,Object>();
            fieldValueOppMap.put('AccountId', account1.id);
            Opportunity opp1 = OpportunityDataFactory.createOpportunity(fieldValueOppMap);
         
            Map<String,Object> fieldValuepoppProgramMap1 = new Map<String,Object>();
            fieldValuepoppProgramMap1.put('Account__c',account1.id);
            fieldValuepoppProgramMap1.put('Opportunity__c',opp1.id);
            Opportunity_Program__c oppprogram = new Opportunity_Program__c();    
            oppprogram = OpportunityProgramDataFactory.createOpportunityProgram(fieldValuepoppProgramMap1);
            
            Map<String,Object> fieldValueOptionMap = new Map<String,Object>();
            //fieldValueOptionMap.put('Opportunity__c',opp1.id);        
           // fieldValueOptionMap.put('Device__c',dev1.id);       
            Customer_Requirement__c  opt1 = BNP_DataFactory.createOption(fieldValueOptionMap);
            system.debug('--opt1 --'+opt1.id );
            
            Map<String,Object> fieldValueMap1 = new Map<String,Object>();
            fieldValueMap1.put('Device_Sourcing__c','Sole Source');
            fieldValueMap1.put('Opportunity_Program__c',oppprogram.Id);
            fieldValueMap1.put('Primary_Option__c',opt1.Id);
            fieldValueMap1.put('Secure_Device__c','Yes');
            fieldValueMap1.put('Tapeout_Type__c','Single Product');
            
            fieldValueMap1.put('Product_TO_Date__c',System.today().addDays(1));
            fieldValueMap1.put('Design_Partner__c',account1.Id);
            fieldValueMap1.put('Forecasted_Production_Start_Date__c',System.today().addDays(2));
            fieldValueMap1.put('Forecasted_Proto_Date__c',System.today().addDays(3));
            fieldValueMap1.put('Forecasted_RTP_Date__c',System.today().addDays(4));
            fieldValueMap1.put('Forecasted_Production_Start_Date__c',System.today().addDays(5));
            fieldValueMap1.put('Secure_Device__c','Yes');
            
            Test.startTest();
            Device__c Dev1 = new Device__c();
            Dev1 = DeviceDataFactory.createDevice(fieldValueMap1);
            set<id> devid= new set<id>();
            devid.add(Dev1.id);
            /*
            Test.startTest();
            Dev1.Product_TO_Date__c = System.today().addDays(1);
            Dev1.Design_Partner__c = account1.Id;
            Dev1.Forecasted_Production_Start_Date__c =  System.today().addDays(2);
            Dev1.Sample_Delivery_Date__c =  System.today().addDays(2);
            Dev1.Forecasted_Proto_Date__c =  System.today().addDays(3);
            Dev1.Forecasted_RTP_Date__c =  System.today().addDays(4);
            Dev1.Forecasted_Production_Start_Date__c = System.today().addDays(5);
            Dev1.Secure_Device__c = 'Yes';*/
            //Dev1.Tapeout_Type__c ='GlobalShuttle MPW';
           
            //update Dev1 ;
            
            Device_TriggerHelper obj = new Device_TriggerHelper();
            //Environment_Variable__c obk = new Environment_Variable__c();
           // obk.name = 'BPM_isActive';
           // obk.value__C = 'TRUE';
           // insert obk;
            
            obj.syncToBPM();
            
            obj.updateOPDevices(devid);
            obj.updateOppProg();
            obj.updateOpp();
            obj.deviceMaskSetTitlelookUp();
            Device_TriggerHelper.deviceSharingAccess('test');
            obj.catchCover(string.valueof(dev1.id),'test','test');
            List<Mask_Set_Title__c> lstMaskSetTitle = [select id from Mask_Set_Title__c];
            for(Mask_Set_Title__c mst : lstMaskSetTitle) {
                mst.Technology__c = 'Test';
            }
            update lstMaskSetTitle;
            obj.deviceMaskSetTitleRec();
            obj.updateDevices(devid);
            //Device_TriggerHelper.revokedeviceSharingAccess('test_new','test_old');
            Test.stopTest();
        }
    }
    
    public static testMethod void testMaskSet(){
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
            mapMaskSetTit.put('Technology__c', 'test');
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
            fieldValueDevMap.put('Secure_Device__c','Yes');
            fieldValueDevMap.put('Tapeout_Type__c','Single Product1');
            fieldValueDevMap.put('MPW_Train_Number__c', m.id);
            Device__c dev1 = DeviceDataFactory.createDevice(fieldValueDevMap);
            
            Test.stopTest();            
        }   
    }    
    
    //Gopi Method for Code Coverage
    public static testMethod void testCodeCoverage(){
        User thisUser = DeviceChecklistTestDataUtils.createUserWithDCAdmin('System Administrator');
        System.runAs(thisUser){
            Map<String,Object> fieldValueAccMap = new Map<String,Object>();
            //Account account1 = AccountDataFactory.createAccount(fieldValueAccMap);
            List<Map<String,Object>> fieldValueAccMaplist = new List<Map<String,Object>>();
            fieldValueAccMaplist.add(fieldValueAccMap);
            fieldValueAccMaplist.add(fieldValueAccMap);
            fieldValueAccMaplist.add(fieldValueAccMap);
            List<Account> account1 = AccountDataFactory.createAccounts(fieldValueAccMaplist,3);
            
            Map<String,Object> fieldValueOppMap = new Map<String,Object>();
            fieldValueOppMap.put('AccountId', account1[0].id);
            Opportunity opp1 = OpportunityDataFactory.createOpportunity(fieldValueOppMap);
            
            Test.startTest();
            Map<String,Object> fieldValueOppProgMap = new Map<String,Object>();
            fieldValueOppProgMap.put('Account__c', account1[0].id);
            fieldValueOppProgMap.put('Opportunity__c', opp1.id);
            Opportunity_Program__c oppProg = OpportunityProgramDataFactory.createOpportunityProgram(fieldValueOppProgMap);
            
            
            MPW_Train_Maintenance__c m = new MPW_Train_Maintenance__c();
            m.Name = 'zTestMPW';
            m.Customer_Tapeout_Date__c = date.today();
            m.Other_Tapeout_Date__c = date.today();
            
            insert m;
            
            
            Map<String, Object> mapMaskSetTit = new Map<String, Object>();
            mapMaskSetTit.put('Name', 'MSTTRT');
            mapMaskSetTit.put('Technology__c', 'test');
            Mask_Set_Title__c mst = MaskSetTitleDataFactory.createMaskSetTitle(mapMaskSetTit);
            string MSTAccId = DeviceUtilTest.createMSTAccount(account1[0].Id,MST.Id);
            
            Map<String,Object> fieldValueDevMap = new Map<String,Object>();
            fieldValueDevMap.put('Account__c', account1[0].id);
            fieldValueDevMap.put('Opportunity_Program__c', oppProg.id);
            fieldValueDevMap.put('Device_Sourcing__c', '1st Source');
            fieldValueDevMap.put('Status__c', 'On Hold');
            fieldValueDevMap.put('Reason_For_Status_On_Hold__c', 'On Hold Test');
            fieldValueDevMap.put('IP_Gap__c', false);
            fieldValueDevMap.put('Siebel_Status__c', 'SUCCESS');
            fieldValueDevMap.put('Secure_Device__c','Yes');
            fieldValueDevMap.put('Tapeout_Type__c','Single Product1');
            fieldValueDevMap.put('MPW_Train_Number__c', m.id);
            fieldValueDevMap.put('Secure_Device__c', 'secure Device 1');
            fieldValueDevMap.put('Tapeout_Type__c','GlobalShuttle MPW1');
            fieldValueDevMap.put('Design_Partner__c',account1[1].id);
            Device__c dev1 = DeviceDataFactory.createDevice(fieldValueDevMap);
            
            //insert erp device
            ERP_Device__c d1 = new ERP_Device__c(name='d11',fab__c='FAB 6',geometry__c='0.028UM',ERP_Inventory_Id__c='testinv24',ITARNew__c='TRUE',Device__c=dev1.Id);
            insert d1;
            
            dev1.Secure_Device__c = 'Yes';
            dev1.Mask_Set_Title_Lookup__c = mst.id;
            dev1.Fab__c = 'FAB 3E';
            dev1.Design_Partner__c = account1[2].id;
            update dev1;
            
            Test.stopTest();            
        }   
    }     
}