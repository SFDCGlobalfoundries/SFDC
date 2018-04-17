/*
 @class: FMSDeviceCreation_ExtTest
 @CreatedBy: Anirban Roy
 @CreatedDate: 09/06/2017
 @Description: Test class for FMSDeviceCreation_Ext
 @Modifications-
 *
 */
@isTest
public class FMSDeviceCreation_ExtTest {    
    
    @testSetup
    static void testDataSetup(){
        DataUtilTest.loadEnvironmentVariables();
        User admin = DeviceChecklistTestDataUtils.createUserWithDCAdmin('System Administrator');
        System.runAs(admin){
            IntegrationUsers__c skipUser = new IntegrationUsers__c(SetupOwnerId = admin.Id, Is_Integration_User__c= true, Skip_Trigger__c = true, Skip_Validation_Rule__c = true);
            try{
                insert skipUser;          
            }catch(Exception e){
                UtilityCls.saveExceptionLog(FMSDeviceCreation_ExtTest.class.getName(), 'save()', '', 'Bug', '', '', 'Error', e.getTypeName(), 'FMS', e, 0);
            }
            AcctRegHeadMappingTgrHandler.bypassAcctTrigger = true;
            ClsAccTriggerHandler.blnAccountShareRun = true;
            Map<String,Object> accFieldMap = new Map<String,Object>{'Name' => 'GLOBAL FOUNDRIES','Site_Department__c' => 'Test Site 1', 'Sub_Type__c' => 'Direct', 'Transaction_Type__c' => 'Transactional',
            'Region__c' => 'APJ', 'Corporate_Address_1__c' => 'Test Bill To Address 1', 'Corporate_City__c' => 'Singapore', 'Corporate_Country__c' => 'Singapore'  };       
            accFieldMap.put('Fab_9_10__c','Yes');
            accFieldMap.put('Customer_Category__c','TFA');
            accFieldMap.put('Tech_Geo_Granted__c','0.007UM'+';'+'0.010UM');
            accFieldMap.put('SAP_Account_Number__c', '016133');
            Account acc;
            try{
                acc = AccountDataFactory.createAccount(accFieldMap);
            }catch(Exception e){
                UtilityCls.saveExceptionLog(FMSDeviceCreation_ExtTest.class.getName(), 'save()', '', 'Bug', '', '', 'Error', e.getTypeName(), 'FMS', e, 0);
            }
            
            Contact con = new Contact(LastName = 'Test Last', AccountId = acc.Id, Is_Portal_User_Active__c = true, Firstname='Test', Department__c='Design');
            con.Is_Portal_User_Created__c = true;
            try{
                insert con;
            }catch(Exception e){
                UtilityCls.saveExceptionLog(FMSDeviceCreation_ExtTest.class.getName(), 'save()', '', 'Bug', '', '', 'Error', e.getTypeName(), 'FMS', e, 0);
            }
            Map<String,Object> oppFieldMap = new Map<String,Object>{'Name'=>'GLOBAL FOUNDRIES OPP DUMMY','AccountId'=>acc.Id,'StageName'=>'1. Discovery','Market_Segment__c'=>'Automotive',
                                                'Target_Process_Node__c'=>'14XM','Process_Platform__c'=>'GF Baseline','Opportunity_Sourcing_Type__c'=>'First Source',
                                                'Process_Geometry__c' => '0.09UM','Process_Family__c' => 'Generic / Nominal',
                'Fab_Split__c'=>100,'CloseDate' => date.newinstance(2012, 12, 21), 'Product_Line__c'=>'Mature'};
            Opportunity opp;
            try{
                opp = OpportunityDataFactory.createOpportunity(oppFieldMap);
            }catch(Exception e){
                UtilityCls.saveExceptionLog(FMSDeviceCreation_ExtTest.class.getName(), 'save()', '', 'Bug', '', '', 'Error', e.getTypeName(), 'FMS', e, 0);
            }
            
            System.debug('TESTTTTTTT CLASSSSS 1 ' +opp.Id);
            Map<String,Object> oppProgFieldMap= new Map<String,Object>{'Name'=>'GLOBAL FOUNDRIES OPP DUMMY','Account__c'=>acc.Id,'Opportunity__c'=>opp.Id};
            Opportunity_Program__c opProg;
            try{
                opProg = OpportunityProgramDataFactory.createOpportunityProgram(oppProgFieldMap);
            }catch(Exception e){
                UtilityCls.saveExceptionLog(FMSDeviceCreation_ExtTest.class.getName(), 'save()', '', 'Bug', '', '', 'Error', e.getTypeName(), 'FMS', e, 0);
            }
        }
    }
    
    public static Device__c createDevice1(Id accId, Id oppId, Id oppProgId, Id processId,String devType){
        //List<Device__c> devList = new List<Device__c>();
        Map<String,Object> fieldValueDevMap = new Map<String,Object>();
        fieldValueDevMap.put('Name' , 'TESTDEVICESP1');
        fieldValueDevMap.put('Confidence_Level_Tapeout__c' , '150');
        fieldValueDevMap.put('Expose_Device_to_Customer__c' , false ); 
        fieldValueDevMap.put('Assigned_Process_ID__c' , processId);
        fieldValueDevMap.put('Enabled_via_previous_MPW_1__c','No');
        fieldValueDevMap.put('CRMDID__c' , '123456');
        fieldValueDevMap.put('Device_Mask_Set_Title__c' , 'MSTT1');
        fieldValueDevMap.put('GSOP_Assignment_Tapeout_Plan__c' , 'No');
        fieldValueDevMap.put('Market_Segment__c' , 'Automotive1');
        fieldValueDevMap.put('Semiconductor_Device__c' , 'Analog Amplifier1');
        fieldValueDevMap.put('End_Customer__c' , 'Test Customer1');
        fieldValueDevMap.put('Device_Sourcing__c' , '1st Source1');
        fieldValueDevMap.put('Stage__c' , 'Design In');
        fieldValueDevMap.put('Status__c' , 'Active');
        fieldValueDevMap.put('Tapeout_Type__c' , '');
        fieldValueDevMap.put('PLM_Device_ID__c' , 'ANBQP60ACO8CH-U02');
        fieldValueDevMap.put('Actual_Tapeout_Date__c' , datetime.now());
        fieldValueDevMap.put('Process_Family_Filter__c' , 'Super Low Power');
        fieldValueDevMap.put('Reticle_Type__c' , '');
        fieldValueDevMap.put('Geometry_Filter__c' , '0.10UM');
        fieldValueDevMap.put('Confidence_Level_Tapeout__c' , '100');
        fieldValueDevMap.put('End_Application__c' , 'Powertrain');
        fieldValueDevMap.put('Customer_Tapeout_Date__c' , date.today());
        fieldValueDevMap.put('Original_Forecasted_Tapeout_Date__c' , date.today());
        fieldValueDevMap.put('PTRF_ID__c' , 'test');
        fieldValueDevMap.put('End_Application__c' , 'Body');
        fieldValueDevMap.put('Device_Type__c' , (devType=='Retrofit')?'Retrofit':'Base');
        fieldValueDevMap.put('Opportunity_Program__c' , oppProgId);
        fieldValueDevMap.put('Account__c' , accId);
        fieldValueDevMap.put('Device_Id__c' , 'Base');
        fieldValueDevMap.put('Device_Type__c' , 'Retrofit');        
        fieldValueDevMap.put('Device_Purpose__c' , 'Product');
        Device__c dev;
        //try{
            dev = DeviceDataFactory.createDevice(fieldValueDevMap);
        /*}catch(Exception e){
            UtilityCls.saveExceptionLog(FMSDeviceCreation_ExtTest.class.getName(), 'save()', '', 'Bug', '', '', 'Error', e.getTypeName(), 'FMS', e, 0);
        }*/  
        return dev; 
    }
    
    
    public static Device__c createDevice(Id accId, Id oppId, Id oppProgId, Id processId){

        Device__c dev = createDevice1(accId,oppId,oppProgId,processId,'Single Product');
            
       // devList.add(dev);
        Map<String,Object> fieldValueDevMap1 = new Map<String,Object>();
        fieldValueDevMap1.put('Base_Device__c',dev.id);
        fieldValueDevMap1.put('Confidence_Level_Tapeout__c','100');
        fieldValueDevMap1.put('Expose_Device_to_Customer__c',false) ; 
        fieldValueDevMap1.put('Fab__c','Fab 2');
        fieldValueDevMap1.put('Assigned_Process_ID__c',processId);
        fieldValueDevMap1.put('Enabled_via_previous_MPW_1__c','No');
        fieldValueDevMap1.put('CRMDID__c','123457');
        fieldValueDevMap1.put('Account__c' , accId);
        fieldValueDevMap1.put('Device_Id__c' , 'Test122');
        fieldValueDevMap1.put('Device_Sourcing__c','test');
        fieldValueDevMap1.put('Device_Purpose__c' , 'Product');
        
        fieldValueDevMap1.put('Customer_Tapeout_Date__c' , date.today());
        fieldValueDevMap1.put('Original_Forecasted_Tapeout_Date__c' , date.today());
        Device__c dev1;
        //try{
            dev1 = DeviceDataFactory.createDevice(fieldValueDevMap1);
        /*}catch(Exception e){
            UtilityCls.saveExceptionLog(FMSDeviceCreation_ExtTest.class.getName(), 'save()', '', 'Bug', '', '', 'Error', e.getTypeName(), 'FMS', e, 0);
        }*/
        return dev1; 
    }
    
    public static Device__c createDeviceNew(Id accId, Id oppId, Id oppProgId, Id processId){

        Device__c dev = createDevice1(accId,oppId,oppProgId,processId,'Single Product');
            
       // devList.add(dev);
        Map<String,Object> fieldValueDevMap1 = new Map<String,Object>();
        fieldValueDevMap1.put('Base_Device__c',dev.id);
        fieldValueDevMap1.put('Confidence_Level_Tapeout__c','100');
        fieldValueDevMap1.put('Expose_Device_to_Customer__c',false) ; 
        fieldValueDevMap1.put('Fab__c','Fab 2');
        fieldValueDevMap1.put('Assigned_Process_ID__c',processId);
        fieldValueDevMap1.put('Enabled_via_previous_MPW_1__c','No');
        fieldValueDevMap1.put('CRMDID__c','123457');
        fieldValueDevMap1.put('Account__c' , accId);
        fieldValueDevMap1.put('Device_Id__c' , 'Test122');
        fieldValueDevMap1.put('Device_Sourcing__c','test');
        fieldValueDevMap1.put('Device_Purpose__c' , 'Product');
        
        fieldValueDevMap1.put('Customer_Tapeout_Date__c' , date.today());
        fieldValueDevMap1.put('Original_Forecasted_Tapeout_Date__c' , date.today());
        fieldValueDevMap1.put('Export_Control_Template__c' , 'Switch Devices for Cellular End Use Applications');
        Device__c dev1;
        //try{
            dev1 = DeviceDataFactory.createDevice(fieldValueDevMap1);
        /*}catch(Exception e){
            UtilityCls.saveExceptionLog(FMSDeviceCreation_ExtTest.class.getName(), 'save()', '', 'Bug', '', '', 'Error', e.getTypeName(), 'FMS', e, 0);
        }*/
        return dev1; 
    }

    static testmethod void devCreationTest(){       
        Device__c devList;
        
        Id accId = getAccount('GLOBAL FOUNDRIES');
        Id oppId = getOpp();
        Id opProgId = getOpProg(); 
        
        User u1;
        Form_Management_System__c  formObj;
        System.runAs(getUser()){             
            Account_Hierarchy__c ojbAH = new Account_Hierarchy__c();
            ojbAH.Account_Id__c = accId;
            ojbAH.Parent_Id__c = accId;
            ojbAH.Master_Account_Id__c = accId;
            try{
                insert ojbAH;
            }catch(Exception e){
                UtilityCls.saveExceptionLog(FMSDeviceCreation_ExtTest.class.getName(), 'save()', '', 'Bug', '', '', 'Error', e.getTypeName(), 'FMS', e, 0);
            }           
            
            Process__c p;
            try{
                p = DeviceChecklistTestDataUtils.createProcess();
            }catch(Exception e){
                UtilityCls.saveExceptionLog(FMSDeviceCreation_ExtTest.class.getName(), 'save()', '', 'Bug', '', '', 'Error', e.getTypeName(), 'FMS', e, 0);
            }
            Test.startTest();
            devList = createDevice(accId,oppId,opProgId,p.Id); 
            u1 = FMSDataFactory.testUser;
            /*deviceAccess(new List<String>{devList.Base_Device__c,devList.Id}, u1.Id);
            oppProgAccess(opProgId, u1.Id);
            oppAccess(oppId,u1.Id);
            accAccess(accId,u1.Id);*/
            
            Map<String,Object> fieldValueFMSMap = new Map<String,Object>{
                    'Device__c' => devList.Base_Device__c,
                    'Customer_Name__c' => accId,
                    'Name__c' => 'Test Name',
                    'Form_Name__c' => 'Test Main Form',                 
                    'Form_Description__c' => 'Test Description', 
                    'Technology__c' => 'CSOI 7RF', 
                    'TestServices__c' => 'Yes', 
                    'Packaging_Services__c' => 'No',                    
                    'Chip_Interconnect__c' => 'Wirebond', 
                    'QuoteOnly__c' => 'No',
                    'ServiceOptions__c' => 'Dicing',
                    'AppName__c' => 'Test 1'+','+'Test 2',
                    'AppEmail__c' => 'test@gmail.com',
                    'DesignSubmission__c' => 'Single Chip (one GDS)', 
                    'InputMethod__c' =>'Advanced Process: Inputs via XML file attachment.', 
                    'Phone__c' => '9999999999',
                    'Email__c' => 'test@gmail.com',
                    'FileAttachment__c' => 'Test Attachment',
                    'AdvancedProcessFileAttachment__c' => 'Test Attachment',
                    'StepPlanRotationActive__c' => null,
                    //SelAppId__c = 'test',
                    'LastMetalUsed__c' => 'AM (Analog Metal) (MT, FT, AM) (70P5485)', 'State_of_the_Form__c' => 'Draft'};
                    
                try{
                    formObj = FMSDataFactory.createFMSRecord(fieldValueFMSMap,FMSDataFactory.FormType.MAIN , true); 
                }catch(Exception e){
                    UtilityCls.saveExceptionLog(FMSDeviceCreation_ExtTest.class.getName(), 'save()', '', 'Bug', '', '', 'Error', e.getTypeName(), 'FMS', e, 0);
                }            
            
            
            //system.runAs(u1){ 
                
                Test.setCurrentPageReference(new PageReference('Page.FMSDeviceCreationPage')); 
                System.currentPageReference().getParameters().put('id', devList.Id);
                System.currentPageReference().getParameters().put('tnx', 'copy');
                System.currentPageReference().getParameters().put('oppProgId', opProgId);
                System.currentPageReference().getParameters().put('baseId', devList.Base_Device__c);            
                ApexPages.StandardController sc = new ApexPages.StandardController(devList);
                FMSDeviceCreation_Ext fmsDevExt = new FMSDeviceCreation_Ext(sc);
                fmsDevExt.deviceObj = devList;
                fmsDevExt.getdevicePurposeList();
                                
                PageReference pr=fmsDevExt.save();
                Test.stopTest();    
                system.assert(pr.getUrl().contains('/apex/fmsdevicecreationpage')); 
                pr=fmsDevExt.newFMSMainForm();
                   
                system.assert(pr==null);                  
           // }
            
        }
    }
    
	static testmethod void devCreationTest2(){       
        Device__c devList;
        
        Id accId = getAccount('GLOBAL FOUNDRIES');
        Id oppId = getOpp();
        Id opProgId = getOpProg(); 
        
        EC_Template_for_Skyworks_Qorvo__c ecTemp = new EC_Template_for_Skyworks_Qorvo__c();
        ecTemp.Account__c = accId;
        ecTemp.Automotive_Device__c = 'No';
        ecTemp.Business_Unit__c = 'RF';
        ecTemp.Design_Rules_Applied__c = 'Consumer';
        ecTemp.Device_Description__c = 'RF - Switch';
        ecTemp.ECCN_Technology__c = '5E991';
        ecTemp.ECCN_Wafer__c = '5A991.g';
        ecTemp.End_Application__c = 'Cell Handset';
        ecTemp.Export_Control_Template__c = 'Switch Devices for Cellular End Use Applications';
        ecTemp.IsActive__c = 'Yes';
        ecTemp.Market_Segment__c = 'Mobility';
        ecTemp.Product_Line__c = 'RF';
        ecTemp.Q1__c = 'Switch Devices for Cellular End Use Applications';
        ecTemp.Q2__c = 'No';
        ecTemp.Q3__c = 'No';
        ecTemp.Q4__c = 'No';
        ecTemp.Q5__c = 'No';
        ecTemp.Q6__c = 'Yes';
        ecTemp.Q6_a__c = '5A991.g / 5E991';
        ecTemp.Q7__c = 'No';
        ecTemp.Q7_a__c = '';
        ecTemp.Q8__c = '8542.39';
        ecTemp.Q9__c = 'Qorvo';
        ecTemp.Semiconductor_Device__c  = 'RF - Switch';
        insert ecTemp;
        User u1;
        Form_Management_System__c  formObj;
        System.runAs(getUser()){             
            Account_Hierarchy__c ojbAH = new Account_Hierarchy__c();
            ojbAH.Account_Id__c = accId;
            ojbAH.Parent_Id__c = accId;
            ojbAH.Master_Account_Id__c = accId;
            try{
                insert ojbAH;
            }catch(Exception e){
                UtilityCls.saveExceptionLog(FMSDeviceCreation_ExtTest.class.getName(), 'save()', '', 'Bug', '', '', 'Error', e.getTypeName(), 'FMS', e, 0);
            }           
            
            Process__c p;
            try{
                p = DeviceChecklistTestDataUtils.createProcess();
            }catch(Exception e){
                UtilityCls.saveExceptionLog(FMSDeviceCreation_ExtTest.class.getName(), 'save()', '', 'Bug', '', '', 'Error', e.getTypeName(), 'FMS', e, 0);
            }
            Test.startTest();
            devList = createDeviceNew(accId,oppId,opProgId,p.Id); 
            u1 = FMSDataFactory.testUser;
            /*deviceAccess(new List<String>{devList.Base_Device__c,devList.Id}, u1.Id);
            oppProgAccess(opProgId, u1.Id);
            oppAccess(oppId,u1.Id);
            accAccess(accId,u1.Id);*/
            
            /*Map<String,Object> fieldValueFMSMap = new Map<String,Object>{
                    'Device__c' => devList.Base_Device__c,
                    'Customer_Name__c' => accId,
                    'Name__c' => 'Test Name',
                    'Form_Name__c' => 'Test Main Form',                 
                    'Form_Description__c' => 'Test Description', 
                    'Technology__c' => 'CSOI 7RF', 
                    'TestServices__c' => 'Yes', 
                    'Packaging_Services__c' => 'No',                    
                    'Chip_Interconnect__c' => 'Wirebond', 
                    'QuoteOnly__c' => 'No',
                    'ServiceOptions__c' => 'Dicing',
                    'AppName__c' => 'Test 1'+','+'Test 2',
                    'AppEmail__c' => 'test@gmail.com',
                    'DesignSubmission__c' => 'Single Chip (one GDS)', 
                    'InputMethod__c' =>'Advanced Process: Inputs via XML file attachment.', 
                    'Phone__c' => '9999999999',
                    'Email__c' => 'test@gmail.com',
                    'FileAttachment__c' => 'Test Attachment',
                    'AdvancedProcessFileAttachment__c' => 'Test Attachment',
                    'StepPlanRotationActive__c' => null,
                    'LastMetalUsed__c' => 'AM (Analog Metal) (MT, FT, AM) (70P5485)', 'State_of_the_Form__c' => 'Draft'};
                    
                try{
                    formObj = FMSDataFactory.createFMSRecord(fieldValueFMSMap,FMSDataFactory.FormType.MAIN , true); 
                }catch(Exception e){
                    UtilityCls.saveExceptionLog(FMSDeviceCreation_ExtTest.class.getName(), 'save()', '', 'Bug', '', '', 'Error', e.getTypeName(), 'FMS', e, 0);
                }*/            
            
            
            //system.runAs(u1){ 
                
                Test.setCurrentPageReference(new PageReference('Page.FMSDeviceCreationPage')); 
                System.currentPageReference().getParameters().put('id', null);
				//System.currentPageReference().getParameters().put('deviceId', devList.Id);
                System.currentPageReference().getParameters().put('tnx', '');
                //System.currentPageReference().getParameters().put('oppProgId', opProgId);
                //System.currentPageReference().getParameters().put('baseId', devList.Base_Device__c);            
                ApexPages.StandardController sc = new ApexPages.StandardController(devList);
                FMSDeviceCreation_Ext fmsDevExt = new FMSDeviceCreation_Ext(sc);
                fmsDevExt.deviceObj = devList;
                fmsDevExt.getdevicePurposeList();
                fmsDevExt.getecTemplateList();
                fmsDevExt.openPopUp();
                fmsDevExt.closePopup();
                fmsDevExt.changeECTemp();
                
                PageReference pr=fmsDevExt.save();
                Test.stopTest();    
                system.assert(pr.getUrl().contains('/apex/fmsdevicecreationpage')); 
                //pr=fmsDevExt.newFMSMainForm();
                   
                //system.assert(pr==null);                  
           // }
            
        }
    }
	
	static testmethod void devCreationTest3(){       
        Device__c devList;
        
        Id accId = getAccount('GLOBAL FOUNDRIES');
        Id oppId = getOpp();
        Id opProgId = getOpProg(); 
        
        EC_Template_for_Skyworks_Qorvo__c ecTemp = new EC_Template_for_Skyworks_Qorvo__c();
        ecTemp.Account__c = accId;
        ecTemp.Automotive_Device__c = 'No';
        ecTemp.Business_Unit__c = 'RF';
        ecTemp.Design_Rules_Applied__c = 'Consumer';
        ecTemp.Device_Description__c = 'RF - Switch';
        ecTemp.ECCN_Technology__c = '5E991';
        ecTemp.ECCN_Wafer__c = '5A991.g';
        ecTemp.End_Application__c = 'Cell Handset';
        ecTemp.Export_Control_Template__c = 'Switch Devices for Cellular End Use Applications';
        ecTemp.IsActive__c = 'Yes';
        ecTemp.Market_Segment__c = 'Mobility';
        ecTemp.Product_Line__c = 'RF';
        ecTemp.Q1__c = 'Switch Devices for Cellular End Use Applications';
        ecTemp.Q2__c = 'No';
        ecTemp.Q3__c = 'No';
        ecTemp.Q4__c = 'No';
        ecTemp.Q5__c = 'No';
        ecTemp.Q6__c = 'Yes';
        ecTemp.Q6_a__c = '5A991.g / 5E991';
        ecTemp.Q7__c = 'No';
        ecTemp.Q7_a__c = '';
        ecTemp.Q8__c = '8542.39';
        ecTemp.Q9__c = 'Qorvo';
        ecTemp.Semiconductor_Device__c  = 'RF - Switch';
        insert ecTemp;
        User u1;
        Form_Management_System__c  formObj;
        System.runAs(getUser()){             
            Account_Hierarchy__c ojbAH = new Account_Hierarchy__c();
            ojbAH.Account_Id__c = accId;
            ojbAH.Parent_Id__c = accId;
            ojbAH.Master_Account_Id__c = accId;
            try{
                insert ojbAH;
            }catch(Exception e){
                UtilityCls.saveExceptionLog(FMSDeviceCreation_ExtTest.class.getName(), 'save()', '', 'Bug', '', '', 'Error', e.getTypeName(), 'FMS', e, 0);
            }           
            
            Process__c p;
            try{
                p = DeviceChecklistTestDataUtils.createProcess();
            }catch(Exception e){
                UtilityCls.saveExceptionLog(FMSDeviceCreation_ExtTest.class.getName(), 'save()', '', 'Bug', '', '', 'Error', e.getTypeName(), 'FMS', e, 0);
            }
            Test.startTest();
            devList = createDevice(accId,oppId,opProgId,p.Id); 
            u1 = FMSDataFactory.testUser;
            /*deviceAccess(new List<String>{devList.Base_Device__c,devList.Id}, u1.Id);
            oppProgAccess(opProgId, u1.Id);
            oppAccess(oppId,u1.Id);
            accAccess(accId,u1.Id);*/
            
       
            
            //system.runAs(u1){ 
                
                Test.setCurrentPageReference(new PageReference('Page.FMSDeviceCreationPage')); 
                System.currentPageReference().getParameters().put('id', devList.Id);
				//System.currentPageReference().getParameters().put('deviceId', devList.Id);
                System.currentPageReference().getParameters().put('tnx', 'edit');
                //System.currentPageReference().getParameters().put('oppProgId', opProgId);
                //System.currentPageReference().getParameters().put('baseId', devList.Base_Device__c);            
                ApexPages.StandardController sc = new ApexPages.StandardController(devList);
                FMSDeviceCreation_Ext fmsDevExt = new FMSDeviceCreation_Ext(sc);
                fmsDevExt.deviceObj = devList;
				fmsDevExt.deviceObj.Export_Control_Template__c = 'Switch Devices for Cellular End Use Applications';
                fmsDevExt.getdevicePurposeList();
                fmsDevExt.getecTemplateList();
                fmsDevExt.openPopUp();
                //fmsDevExt.closePopup();
                //fmsDevExt.changeECTemp();
                PageReference pr=fmsDevExt.save();
                Test.stopTest();    
                system.assert(pr.getUrl().contains('/apex/fmsdevicecreationpage')); 
                //pr=fmsDevExt.newFMSMainForm();
                   
                //system.assert(pr==null);                  
           // }
            
        }
    }
	
    static testmethod void devCreationTestNew(){       
        Device__c devList;
        Id accId = getAccount('GLOBAL FOUNDRIES');
        Id oppId = getOpp();
        Id opProgId = getOpProg();
        User u1;
        Form_Management_System__c  formObj;
        FMSDeviceCreation_Ext fmsDevExt;
        System.runAs(getUser()){             
            
            Account_Hierarchy__c ojbAH = new Account_Hierarchy__c();
            ojbAH.Account_Id__c = accId;
            //ojbAH.Parent_Id__c = acc1.Id;
            try{
                insert ojbAH;
            }catch(Exception e){
                UtilityCls.saveExceptionLog(FMSDeviceCreation_ExtTest.class.getName(), 'save()', '', 'Bug', '', '', 'Error', e.getTypeName(), 'FMS', e, 0);
            }          
            
            Process__c p;
            try{
                p = DeviceChecklistTestDataUtils.createProcess();
            }catch(Exception e){
                UtilityCls.saveExceptionLog(FMSDeviceCreation_ExtTest.class.getName(), 'save()', '', 'Bug', '', '', 'Error', e.getTypeName(), 'FMS', e, 0);
            }
            Test.startTest();
            devList = createDevice(accId,oppId,opProgId,p.Id);
            u1 = FMSDataFactory.testUser;
            /*deviceAccess(new List<String>{devList.Base_Device__c,devList.Id}, u1.Id);
            oppProgAccess(opProgId, u1.Id);
            oppAccess(oppId,u1.Id);
            accAccess(accId,u1.Id);*/
            Map<String,Object> fieldValueFMSMap = new Map<String,Object>{
                'Device__c' => devList.Base_Device__c,
                'Customer_Name__c' => accId,
                'Name__c' => 'Test Name',
                'Form_Name__c' => 'Test Main Form',                 
                'Form_Description__c' => 'Test Description', 
                'Technology__c' => 'CSOI 7RF', 
                'TestServices__c' => 'Yes', 
                'Packaging_Services__c' => 'No',                    
                'Chip_Interconnect__c' => 'Wirebond', 
                'QuoteOnly__c' => 'No',
                'ServiceOptions__c' => 'Dicing',
                'AppName__c' => 'Test 1'+','+'Test 2',
                'AppEmail__c' => 'test@gmail.com',
                'DesignSubmission__c' => 'Single Chip (one GDS)', 
                'InputMethod__c' =>'Advanced Process: Inputs via XML file attachment.', 
                'Phone__c' => '9999999999',
                'Email__c' => 'test@gmail.com',
                'FileAttachment__c' => 'Test Attachment',
                'AdvancedProcessFileAttachment__c' => 'Test Attachment',
                'StepPlanRotationActive__c' => null,
                //SelAppId__c = 'test',
                'LastMetalUsed__c' => 'AM (Analog Metal) (MT, FT, AM) (70P5485)', 'State_of_the_Form__c' => 'Submitted'};
                
                try{
                    formObj = FMSDataFactory.createFMSRecord(fieldValueFMSMap,FMSDataFactory.FormType.MAIN , true); 
                }catch(Exception e){
                    UtilityCls.saveExceptionLog(FMSDeviceCreation_ExtTest.class.getName(), 'save()', '', 'Bug', '', '', 'Error', e.getTypeName(), 'FMS', e, 0);
                }
                   
                Test.setCurrentPageReference(new PageReference('Page.FMSDeviceCreationPage')); 
                System.currentPageReference().getParameters().put('id', devList.Id);
                System.currentPageReference().getParameters().put('tnx', 'copy');
                System.currentPageReference().getParameters().put('oppProgId', opProgId);
                System.currentPageReference().getParameters().put('baseId', devList.Id);            
                ApexPages.StandardController sc = new ApexPages.StandardController(devList);
                fmsDevExt = new FMSDeviceCreation_Ext(sc);
                fmsDevExt.deviceObj = devList;
        }
            //system.runAs(u1){
                
                PageReference pr = fmsDevExt.newFMSMainForm();
                system.assert(pr.getUrl().contains('/GlobalfoundryView/apex/FMSmainFormCreation'));
                fmsDevExt.deviceSharingToExtUser(devList);
                fmsDevExt.deviceId = null;
				TriggerHandler.bypass('Device_TriggerHandler');
                pr = fmsDevExt.save();
                
                fmsDevExt.deviceObj.Customer_Tapeout_Date__c = System.today()+1;
				TriggerHandler.bypass('Device_TriggerHandler');
                pr = fmsDevExt.save();
                Test.stopTest();
            //}
        
    }
    
    static testmethod void devCreationTest1(){                                      
        Device__c devList;
        Id accId = getAccount('GLOBAL FOUNDRIES');
        Id oppId = getOpp();
        Id opProgId = getOpProg();
        User u1;
        System.runAs(getUser()){ 
            Account_Hierarchy__c ojbAH = new Account_Hierarchy__c();
            ojbAH.Account_Id__c = accId;
            //ojbAH.Parent_Id__c = acc1.Id;
            try{    
                insert ojbAH;
            }catch(Exception e){
                UtilityCls.saveExceptionLog(FMSDeviceCreation_ExtTest.class.getName(), 'save()', '', 'Bug', '', '', 'Error', e.getTypeName(), 'FMS', e, 0);
            }
            Process__c p;
            try{
                p = DeviceChecklistTestDataUtils.createProcess();
            }catch(Exception e){
                UtilityCls.saveExceptionLog(FMSDeviceCreation_ExtTest.class.getName(), 'save()', '', 'Bug', '', '', 'Error', e.getTypeName(), 'FMS', e, 0);
            }
        Test.startTest();    
            devList = createDevice1(accId,oppId,opProgId,p.Id,'Retrofit');
            u1 = FMSDataFactory.testUser;
            /*deviceAccess(new List<String>{devList.Id}, u1.Id);
            oppProgAccess(opProgId, u1.Id);
            oppAccess(oppId,u1.Id);
            accAccess(accId,u1.Id);*/
        //}
            
                       
            //system.runAs(u1){
                Test.setCurrentPageReference(new PageReference('Page.FMSDeviceCreationPage')); 
                System.currentPageReference().getParameters().put('id', devList.Id);
                System.currentPageReference().getParameters().put('tnx', 'copy');
                System.currentPageReference().getParameters().put('oppProgId', opProgId);
                System.currentPageReference().getParameters().put('baseId', devList.Id);            
    
                ApexPages.StandardController sc = new ApexPages.StandardController(devList);
                FMSDeviceCreation_Ext fmsDevExt = new FMSDeviceCreation_Ext(sc);
                fmsDevExt.deviceObj = devList;
                PageReference pr = fmsDevExt.newFMSMainForm();
                system.assert(pr.getUrl().contains('/GlobalfoundryView/apex/FMSmainFormCreation'));
           Test.stopTest();
            }
        
    }
    
    
    @isTest
    static void testdiffDevice(){                        
        
        Id accId = getAccount('GLOBAL FOUNDRIES');
        Id oppId = getOpp();
        Id opProgId = getOpProg();
        User u1;

        Device__c devList1;
        System.runAs(getUser()){
            Process__c p;
            try{
                p = DeviceChecklistTestDataUtils.createProcess();
            }catch(Exception e){
                UtilityCls.saveExceptionLog(FMSDeviceCreation_ExtTest.class.getName(), 'save()', '', 'Bug', '', '', 'Error', e.getTypeName(), 'FMS', e, 0);
            }
         Test.startTest();
            devList1 = createDevice1(accId,oppId,opProgId,p.Id,'Retrofit');
            u1 = FMSDataFactory.testUser;
            /*deviceAccess(new List<String>{devList1.Id}, u1.Id);
            oppProgAccess(opProgId, u1.Id);
            oppAccess(oppId,u1.Id);
            accAccess(accId,u1.Id);*/
        //}
        
            //system.runAs(u1){
                Test.setCurrentPageReference(new PageReference('Page.FMSDeviceCreationPage')); 
                System.currentPageReference().getParameters().put('id', devList1.Id);
                System.currentPageReference().getParameters().put('tnx', 'createRetor');
                System.currentPageReference().getParameters().put('oppProgId', opProgId);
                System.currentPageReference().getParameters().put('baseId', devList1.Id);            
    
                ApexPages.StandardController sc = new ApexPages.StandardController(devList1);
                FMSDeviceCreation_Ext fmsDevExt = new FMSDeviceCreation_Ext(sc);
                PageReference pr = fmsDevExt.save();
                fmsDevExt.generateExpControl();
                system.assert(pr==null);
                fmsDevExt.deviceObj.Device_Id__c = 'Test123';
                pr = fmsDevExt.save();
                system.assert(pr==null);
                Test.stopTest();
            }
        
     
        
    }
    
  @isTest
  static void testdiffDevice2(){                
        
        Id accId = getAccount('GLOBAL FOUNDRIES');
        Id oppId = getOpp();
        Id opProgId = getOpProg();
        Device__c devList1;
        User u1;
        
        System.runAs(getUser()){
            Process__c p;
            try{
                p = DeviceChecklistTestDataUtils.createProcess();
            }catch(Exception e){
                UtilityCls.saveExceptionLog(FMSDeviceCreation_ExtTest.class.getName(), 'save()', '', 'Bug', '', '', 'Error', e.getTypeName(), 'FMS', e, 0);
            }
            Test.startTest();
            devList1 = createDevice(accId,oppId,opProgId,p.Id);
            u1 = FMSDataFactory.testUser;
            //deviceAccess(new List<String>{devList1.Id}, u1.Id);
        //}
        
            //system.runAs(u1){
                Test.setCurrentPageReference(new PageReference('Page.FMSDeviceCreationPage')); 
                System.currentPageReference().getParameters().put('id', devList1.Id);
                System.currentPageReference().getParameters().put('tnx', '');
                System.currentPageReference().getParameters().put('oppProgId', opProgId);
                System.currentPageReference().getParameters().put('baseId', devList1.Id);            
    
                ApexPages.StandardController sc = new ApexPages.StandardController(devList1);
                FMSDeviceCreation_Ext fmsDevExt = new FMSDeviceCreation_Ext(sc);                
                System.currentPageReference().getParameters().remove('id');
                fmsDevExt = new FMSDeviceCreation_Ext(sc);
                system.assert(devList1!=null);
                Test.stopTest();
            }
        
    
    }  
    
     @isTest
  static void testdiffDevice3(){               
        Id accId = getAccount('GLOBAL FOUNDRIES');
        Id oppId = getOpp();
        Id opProgId = getOpProg();
        Device__c dev;
        User u1;

        System.runAs(getUser()){
            Process__c p;
            try{
                p = DeviceChecklistTestDataUtils.createProcess();
            }catch(Exception e){
                UtilityCls.saveExceptionLog(FMSDeviceCreation_ExtTest.class.getName(), 'save()', '', 'Bug', '', '', 'Error', e.getTypeName(), 'FMS', e, 0);
            }
            Test.startTest();
            dev = createDevice1(accId,oppId,opProgId,p.Id,'Single Product');
            u1 = FMSDataFactory.testUser;
            /*deviceAccess(new List<String>{dev.Id}, u1.Id);
            oppProgAccess(opProgId, u1.Id);
            oppAccess(oppId,u1.Id);
            accAccess(accId,u1.Id);*/
        //}
               
            //system.runAs(u1){
                Test.setCurrentPageReference(new PageReference('Page.FMSDeviceCreationPage')); 
                System.currentPageReference().getParameters().put('id', dev.Id);
                System.currentPageReference().getParameters().put('tnx', '');
                System.currentPageReference().getParameters().put('oppProgId', opProgId);
                System.currentPageReference().getParameters().put('baseId', dev.Id);            
    
                ApexPages.StandardController sc = new ApexPages.StandardController(dev);
                FMSDeviceCreation_Ext fmsDevExt = new FMSDeviceCreation_Ext(sc);
                system.assert(dev!=null);
                Test.stopTest();
            }       
          
    }
    @isTest
  static void testdiffDevice4(){       
        Id accId = getAccount('GLOBAL FOUNDRIES');
        Id oppId = getOpp();
        Id opProgId = getOpProg();
        
        Device__c dev;
        User u1;

        System.runAs(getUser()){
            Process__c p;
            try{
                p = DeviceChecklistTestDataUtils.createProcess();
            }catch(Exception e){
                UtilityCls.saveExceptionLog(FMSDeviceCreation_ExtTest.class.getName(), 'save()', '', 'Bug', '', '', 'Error', e.getTypeName(), 'FMS', e, 0);
            }
            Test.startTest();           
            dev = createDevice1(accId,oppId,opProgId,p.Id,'Single Product');
            u1 = FMSDataFactory.testUser;
            /*deviceAccess(new List<String>{dev.Id}, u1.Id);
            oppProgAccess(opProgId, u1.Id);
            oppAccess(oppId,u1.Id);
            accAccess(accId,u1.Id);*/
        //}
        
             
            //system.runAs(u1){
                Test.setCurrentPageReference(new PageReference('Page.FMSDeviceCreationPage'));
                System.currentPageReference().getParameters().put('id', dev.Id); 
                System.currentPageReference().getParameters().put('tnx', '');
                System.currentPageReference().getParameters().put('oppProgId', opProgId);
                //System.currentPageReference().getParameters().put('baseId', dev.Id);            
    
                ApexPages.StandardController sc = new ApexPages.StandardController(dev);
                FMSDeviceCreation_Ext fmsDevExt = new FMSDeviceCreation_Ext(sc);
                PageReference pr = fmsDevExt.save();
                system.assert(dev!=null);
                Test.stopTest();
            }
        
          
    }

    @isTest
  static void testdiffDevice5(){       
        Id accId = getAccount('GLOBAL FOUNDRIES');
        Id oppId = getOpp();
        Id opProgId = getOpProg();
        
        Device__c dev;
        User u1;

        System.runAs(getUser()){
            Process__c p;
            try{
                p = DeviceChecklistTestDataUtils.createProcess();
            }catch(Exception e){
                UtilityCls.saveExceptionLog(FMSDeviceCreation_ExtTest.class.getName(), 'save()', '', 'Bug', '', '', 'Error', e.getTypeName(), 'FMS', e, 0);
            }
            Test.startTest();
            dev = createDevice1(accId,oppId,opProgId,p.Id,'Single Product');
            u1 = FMSDataFactory.testUser;
            /*deviceAccess(new List<String>{dev.Id}, u1.Id);
            oppProgAccess(opProgId, u1.Id);
            oppAccess(oppId,u1.Id);
            accAccess(accId,u1.Id);*/
        //}
        
             
            //system.runAs(u1){
                Test.setCurrentPageReference(new PageReference('Page.FMSDeviceCreationPage'));
                System.currentPageReference().getParameters().put('id', null);             
    
                ApexPages.StandardController sc = new ApexPages.StandardController(dev);
                FMSDeviceCreation_Ext fmsDevExt = new FMSDeviceCreation_Ext(sc);
                PageReference pr = fmsDevExt.save();
                fmsDevExt.generateExpControl();
                system.assert(dev!=null);
                Test.stopTest();
            }
        
          
    }

    @isTest
    static void testdiffDevice6(){       
        Id accId = getAccount('GLOBAL FOUNDRIES');
        Id conId = getContact(accId);
        Id oppId = getOpp();
        Id opProgId = getOpProg();
        
        Device__c dev;
        User portalUser;

        //User portalUser = getPortalUser('portaluser1@testorg13.com');
        User u1;
        Account acc1;
        Contact con;
        System.runAs(getUser()){
            /*Map<String,Object> accFieldMap1 = new Map<String,Object>{'Name' => 'GLOBAL FOUNDRIES11','Site_Department__c' => 'Test Site 1', 'Sub_Type__c' => 'Direct', 'Transaction_Type__c' => 'Transactional',
            'Region__c' => 'APJ', 'Corporate_Address_1__c' => 'Test Bill To Address 1', 'Corporate_City__c' => 'Singapore', 'Corporate_Country__c' => 'Singapore'  };       
            accFieldMap1.put('Fab_9_10__c','Yes');
            accFieldMap1.put('Customer_Category__c','TFA');
            accFieldMap1.put('Tech_Geo_Granted__c','0.007UM'+';'+'0.010UM');
            accFieldMap1.put('SAP_Account_Number__c', '016133');
            
            try{
                acc1 = AccountDataFactory.createAccount(accFieldMap1);
            }catch(Exception e){
                UtilityCls.saveExceptionLog(FMSDeviceCreation_ExtTest.class.getName(), 'save()', '', 'Bug', '', '', 'Error', e.getTypeName(), 'FMS', e, 0);
            }
            con = new Contact(LastName = 'Test Last', AccountId = acc1.Id, is_portal_user_created__c= true,Is_Portal_User_Active__c = true, Firstname='Test', Department__c='Design');
            con.Is_Portal_User_Created__c = true;
            insert con;*/
            Profile portalProfile = [SELECT Id, Name FROM Profile where Name = 'Overage Customer Portal Admin' Limit 1];
            UserRole portalRole = [SELECT Id FROM UserRole WHERE PortalType = 'CustomerPortal' AND Name LIKE '%Customer%' LIMIT 1];
            portalUser = new User(Username = 'portaluser1@testorg13.com', Alias = 'auser', Email = 'portaluser1@testorg.com', EmailEncodingKey = 'UTF-8', Firstname = 'Test', Lastname = 'Test Last', LanguageLocaleKey = 'en_US', LocaleSidKey = 'en_US', TimeZoneSidKey = 'America/Chicago', ContactId = conId, IsActive = true,UserRoleId = portalRole.id, ProfileId = portalProfile.Id);
            Test.startTest();
            try{
                insert portalUser;
            } catch(Exception e){
                UtilityCls.saveExceptionLog(FMSDeviceCreation_ExtTest.class.getName(), 'save()', '', 'Bug', '', '', 'Error', e.getTypeName(), 'FMS', e, 0);
            }
            Process__c p;
            try{
                p = DeviceChecklistTestDataUtils.createProcess();
            }catch(Exception e){
                UtilityCls.saveExceptionLog(FMSDeviceCreation_ExtTest.class.getName(), 'save()', '', 'Bug', '', '', 'Error', e.getTypeName(), 'FMS', e, 0);
            }            
            dev = createDevice1(accId,oppId,opProgId,p.Id,'Single Product');
            u1 = FMSDataFactory.testUser;
            /*deviceAccess(new List<String>{dev.Id}, u1.Id);
            oppProgAccess(opProgId, u1.Id);
            oppAccess(oppId,u1.Id);
            accAccess(acc1.Id,u1.Id);*/
         
           Contact Con1 = [Select id,Contact.AccountId from contact where Contact.AccountId =: dev.Account__c ]; 
           Contact cn2;
           String trans = 'edit';
            //system.runAs(portalUser){
                
                cn2 = Con1; 
                Test.setCurrentPageReference(new PageReference('Page.FMSDeviceCreationPage'));
                System.currentPageReference().getParameters().put('deviceId', dev.Id);             
    
                ApexPages.StandardController sc = new ApexPages.StandardController(dev);
                FMSDeviceCreation_Ext fmsDevExt = new FMSDeviceCreation_Ext(sc);
                   
                fmsDevExt.deviceSharingToExtUser(dev);
                PageReference pr = fmsDevExt.generateExpControl();
                 System.assertNotEquals(dev, null);
                Test.stopTest(); 
              //  fmsDevExt.save();
                //system.assert(dev!=null);
            //}
         
        }        
    }
    
    static Id getAccount(String name){
        Account acc = [select id from Account where name = :name];
        return acc.Id;
    }
    static Id getContact(Id accId){
        Contact con = [select id, AccountId from Contact where AccountId = :accId];
        return con.Id;
    }
    static Id getOpp(){
        Opportunity opp = [select id from Opportunity where name = 'GLOBAL FOUNDRIES OPP DUMMY'];
        return opp.Id;
    }
    static Id getOpProg(){
        Opportunity_Program__c opProg = [select id from Opportunity_Program__c where name = 'GLOBAL FOUNDRIES OPP DUMMY' and opportunity__r.name = 'GLOBAL FOUNDRIES OPP DUMMY' limit 1];
        return opProg.Id;
    }
    static User getUser(){
        IntegrationUsers__c intUsr = [select id,SetupOwnerId from IntegrationUsers__c where Is_Integration_User__c= true and Skip_Trigger__c = true and Skip_Validation_Rule__c = true limit 1];
        system.debug('-intUsr -'+intUsr );   
        User usr = [select id from User where id = :intUsr.SetupOwnerId limit 1];
        return usr ;
    }  
    
    static void deviceAccess(List<String> devIds, String userId){
        List<Device__Share> devShareList = new List<Device__Share>();
        for(String devId : devIds){
            Device__Share ds = new Device__Share();
            ds.ParentId = devId;
            ds.UserOrGroupId = userId;
            ds.AccessLevel = 'Edit';
            ds.RowCause = 'Opportunity_Program_Team__c';
            devShareList.add(ds);
        }
        try{
            insert devShareList;
        }catch(Exception e){
            UtilityCls.saveExceptionLog(FMSDeviceCreation_ExtTest.class.getName(), 'save()', '', 'Bug', '', '', 'Error', e.getTypeName(), 'FMS', e, 0);
        }
    }
    
    static void oppProgAccess(String oppProgId, String userId){
        Opportunity_Program__Share opShare = new Opportunity_Program__Share();
        opShare.ParentId = oppProgId;
        opShare.UserOrGroupId = userId;
        opShare.AccessLevel = 'Edit';
        try{
            insert opShare;
        }catch(Exception e){
            UtilityCls.saveExceptionLog(FMSDeviceCreation_ExtTest.class.getName(), 'save()', '', 'Bug', '', '', 'Error', e.getTypeName(), 'FMS', e, 0);
        }
    }
    static void oppAccess(String opId, String userId){
        OpportunityShare opShare = new OpportunityShare();
        opShare.OpportunityID = opId;
        opShare.UserOrGroupId = userId;
        opShare.OpportunityAccessLevel = 'Edit';
        try{
            insert opShare;
        }catch(Exception e){
            UtilityCls.saveExceptionLog(FMSDeviceCreation_ExtTest.class.getName(), 'save()', '', 'Bug', '', '', 'Error', e.getTypeName(), 'FMS', e, 0);
        }
    }
    static void accAccess(String accId, String userId){
        AccountShare accShare = new AccountShare();
        accShare.AccountId = accId;
        accShare.UserOrGroupId = userId;
        accShare.AccountAccessLevel = 'Edit';
        accShare.OpportunityAccessLevel = 'Edit';
        try{
            insert accShare;
        }catch(Exception e){
            UtilityCls.saveExceptionLog(FMSDeviceCreation_ExtTest.class.getName(), 'save()', '', 'Bug', '', '', 'Error', e.getTypeName(), 'FMS', e, 0);
        }
    }
}