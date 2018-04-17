/*
    Author: Abhita Bansal
    Created Date: 15/09/2015 
    Description: Test class for MPWVoidReservationFormScheduler
*/
@isTest
public class MPWVoidReservationFormSchedulerTest {
    
    //public static String CRON_EXP = '0 0 0 15 3 ?'; 
    
    @testSetup static void testdata() {
        DataUtilTest.loadEnvironmentVariables();
        Map<String,Object> fieldValueMap = new Map<String,Object>();            
        fieldValueMap.put('Name', 'Test Account 007');            
        fieldValueMap.put('stage__c', 'Unqualified');
        fieldValueMap.put('short_name__c', 'Test007');
        fieldValueMap.put('sub_type__c', 'Direct');
        fieldValueMap.put('site_department__c', 'IT');          
        fieldValueMap.put('transaction_type__c', 'Non-Transactional');
        fieldValueMap.put('account_profile__c', 'Fabless - Emerging');            
        fieldValueMap.put('Process_Tech_Interested__c', 'Mature (> 0.11um)');
        fieldValueMap.put('region__c', 'US');
        fieldValueMap.put('Sales_Territory__c', 'Greater China');
        fieldValueMap.put('financial_territory__c', 'Greater China');          
        fieldValueMap.put('Copy_Address__c', true);
        fieldValueMap.put('Corporate_Address_1__c', 'Test Address 1');
        fieldValueMap.put('Corporate_Address_2__c', 'Test Address 2');
        fieldValueMap.put('Corporate_Address_3__c', 'Test Address 3');
        fieldValueMap.put('Corporate_Address_4__c', 'Test Address 4');            
        fieldValueMap.put('Corporate_Country__c', 'Test Country');
        fieldValueMap.put('Corporate_City__c', 'Test City');
        fieldValueMap.put('Corporate_State__c', 'Test State');
        fieldValueMap.put('Corporate_Postal_Zip_Code__c', '700007');
        fieldValueMap.put('Organization_Unit__c', 'GF Investment LLC OU');
        fieldValueMap.put('bill_to_location__c', 'test');
        fieldValueMap.put('total_employee__c', 7);          
        fieldValueMap.put('end_customer__c', 'people');
        fieldValueMap.put('Revenue_Potential__c', 'Low Potential');            
        fieldValueMap.put('Target_Account__c', 'Yes');
        fieldValueMap.put('Fab_9_10__c','No');
        fieldValueMap.put('Bill_To_Address_1__c','Test Address');
        fieldValueMap.put('Account_Profile__c','Fabless - Emerging');
        fieldValueMap.put('Bill_To_City__c','Test City');
        fieldValueMap.put('Bill_To_Country__c','India');
        AccountDataFactory.createAccount(fieldValueMap);
    }
    
    private static MPW_Approval_Matrix__c utilDataAMMethod() { 
    
        List<User> userAppMatrix = [select Id from User where Profile.Name = 'GF PIYE Platform' and isActive = true limit 3];  
        
        MPW_Approval_Matrix__c mpwApproval = new MPW_Approval_Matrix__c();
        mpwApproval.Category__c = 'FAB';
        mpwApproval.Fab__c = 'Fab1';
        mpwApproval.Geometry__c = '28nm';
        mpwApproval.Step_1_Approver_1__c = userAppMatrix[0].Id;
        mpwApproval.Step_1_Approver_2__c = userAppMatrix[1].Id;
        insert mpwApproval;
        
        return mpwApproval;
    }
    
    private static Account utilDataAccMethod() {
    
        Account account= getAccount('Test Account 007'); 
        return account;
    }  
    
    private static List<Account_Team_Proxy__c> utilDataAccPMethod(Account a) {
        
        List<Account_Team_Proxy__c> accountProxyList =  new List<Account_Team_Proxy__c>();
        
        List<User> userAppMatrix = [select Id from User where Profile.Name = 'GF PIYE Platform' and isActive = true limit 3];
        
        Account_Team_Proxy__c accProxy = new Account_Team_Proxy__c();
        accProxy.Account__c = a.Id;
        accProxy.Team_Role__c = 'Primary Account Manager';
        accProxy.User__c = userAppMatrix[0].Id;
        accProxy.Account_Access__c = 'Read/Write';
        insert accProxy;
        accountProxyList.add(accProxy);
        
        Account_Team_Proxy__c accProxy1 = new Account_Team_Proxy__c();
        accProxy1.Account__c = a.Id;
        accProxy1.Team_Role__c = 'Primary Customer Service Rep';
        accProxy1.User__c = userAppMatrix[1].Id;
        accProxy1.Account_Access__c = 'Read/Write';
        insert accProxy1;
        accountProxyList.add(accProxy1);
        
        Account_Team_Proxy__c accProxy2 = new Account_Team_Proxy__c();
        accProxy2.Account__c = a.Id;
        accProxy2.Team_Role__c = 'Primary Field Application Engineer';
        accProxy2.User__c = userAppMatrix[2].Id;
        accProxy2.Account_Access__c = 'Read/Write';
        insert accProxy2;
        accountProxyList.add(accProxy2);
               
        return accountProxyList;
    }  
    
    private static MPW_Form_No_Generator__c utilDataFNGMethod() { 
        
        MPW_Form_No_Generator__c mpwFormNoGen = new MPW_Form_No_Generator__c();
        mpwFormNoGen.Geometry__c = '03';
        mpwFormNoGen.Year__c = '2015';
        mpwFormNoGen.Last_Sequence_No__c = 232;
        insert mpwFormNoGen;
        
        return mpwFormNoGen;
    }
    
    private static MPW_Geometry_Mapping__c utilDataGMMethod() {
        
        MPW_Geometry_Mapping__c mpwGeoMap = new MPW_Geometry_Mapping__c();
        mpwGeoMap.Name = '28nm';
        mpwGeoMap.Geometry_ID__c = '0.028UM'; 
        mpwGeoMap.TechNo__c = '03'; 
        mpwGeoMap.Active__c = true;
        mpwGeoMap.Use_Process_Type__c  = true;
        insert mpwGeoMap;
        
        return mpwGeoMap;
    }    
    
    private static MPW_ERP_PA_Code__c utilDataPAMethod() {
        
        MPW_ERP_PA_Code__c mpwPACode = new MPW_ERP_PA_Code__c();
        mpwPACode.Name = 'RDY67219';
        mpwPACode.PA_Description__c = 'Testing';
        insert mpwPACode;
        
        return mpwPACode;
    }
    
    private static MPW_Metal_Stack_Configuration__c utilDataMSMethod(MPW_Config_Settings__c mpwConfig) {
        
        MPW_Metal_Stack_Configuration__c mpwMetalStack = new MPW_Metal_Stack_Configuration__c();
        mpwMetalStack.Active__c = true;
        mpwMetalStack.Category__c = 'Customer';
        mpwMetalStack.Process_Type__c = mpwConfig.Id;
        insert mpwMetalStack;
        
        return mpwMetalStack;
    }
    
    private static List<MPW_Keyword_Config__c> utilDataKCMethod() {
        
        List<MPW_Keyword_Config__c> mpwKeywordList = new List<MPW_Keyword_Config__c>();
        
        MPW_Keyword_Config__c mpwKeyword = new MPW_Keyword_Config__c();
        mpwKeyword.Active__c = true;
        mpwKeyword.Sequence_No__c = 1;
        mpwKeyword.Type__c = 'ForwarderAccountType';
        mpwKeyword.Value__c = 'Third Party';
        mpwKeywordList.add(mpwKeyword);
        
        MPW_Keyword_Config__c mpwKeyword1 = new MPW_Keyword_Config__c();
        mpwKeyword1.Active__c = true;
        mpwKeyword1.Sequence_No__c = 1;
        mpwKeyword1.Type__c = 'DieQuantity';
        mpwKeyword1.Value__c = '200';
        mpwKeywordList.add(mpwKeyword1);
        
        MPW_Keyword_Config__c mpwKeyword2 = new MPW_Keyword_Config__c();
        mpwKeyword2.Active__c = true;
        mpwKeyword2.Sequence_No__c = 1;
        mpwKeyword2.Type__c = 'QuantityWaferForm';
        mpwKeyword2.Value__c = '10';
        mpwKeywordList.add(mpwKeyword2);
        
        MPW_Keyword_Config__c mpwKeyword3 = new MPW_Keyword_Config__c();
        mpwKeyword3.Active__c = true;
        mpwKeyword3.Sequence_No__c = 1;
        mpwKeyword3.Type__c = 'Backgrind';
        mpwKeyword3.Value__c = '7miles';
        mpwKeywordList.add(mpwKeyword3);
        
        MPW_Keyword_Config__c mpwKeyword4 = new MPW_Keyword_Config__c();
        mpwKeyword4.Active__c = true;
        mpwKeyword4.Sequence_No__c = 1;
        mpwKeyword4.Type__c = 'ShortLoopWafers';
        mpwKeyword4.Value__c = '7';
        mpwKeywordList.add(mpwKeyword4);
        
        MPW_Keyword_Config__c mpwKeyword5 = new MPW_Keyword_Config__c();
        mpwKeyword5.Active__c = true;
        mpwKeyword5.Sequence_No__c = 1;
        mpwKeyword5.Type__c = 'Expedite';
        mpwKeyword5.Value__c = '200';
        mpwKeywordList.add(mpwKeyword5);
        
        MPW_Keyword_Config__c mpwKeyword6 = new MPW_Keyword_Config__c();
        mpwKeyword6.Active__c = true;
        mpwKeyword6.Sequence_No__c = 1;
        mpwKeyword6.Type__c = 'ExpediteQuantityWaferForm';
        mpwKeyword6.Value__c = '7';
        mpwKeywordList.add(mpwKeyword6);
        
        MPW_Keyword_Config__c mpwKeyword7 = new MPW_Keyword_Config__c();
        mpwKeyword7.Active__c = true;
        mpwKeyword7.Sequence_No__c = 1;
        mpwKeyword7.Type__c = 'DeviceType';
        mpwKeyword7.Value__c = 'Product';
        mpwKeywordList.add(mpwKeyword7);
        
        MPW_Keyword_Config__c mpwKeyword8 = new MPW_Keyword_Config__c();
        mpwKeyword8.Active__c = true;
        mpwKeyword8.Sequence_No__c = 1;
        mpwKeyword8.Type__c = 'DrawnOrientation';
        mpwKeyword8.Value__c = 'Vertical';
        mpwKeywordList.add(mpwKeyword8);
        
        MPW_Keyword_Config__c mpwKeyword9 = new MPW_Keyword_Config__c();
        mpwKeyword9.Active__c = true;
        mpwKeyword9.Sequence_No__c = 1;
        mpwKeyword9.Type__c = 'CornerSplit';
        mpwKeyword9.Value__c = 'yes';
        mpwKeywordList.add(mpwKeyword9);
        
        MPW_Keyword_Config__c mpwKeyword10 = new MPW_Keyword_Config__c();
        mpwKeyword10.Active__c = true;
        mpwKeyword10.Sequence_No__c = 1;
        mpwKeyword10.Type__c = 'TurnkeyServices';
        mpwKeyword10.Value__c = 'yes';
        mpwKeywordList.add(mpwKeyword10);
        
        MPW_Keyword_Config__c mpwKeyword11 = new MPW_Keyword_Config__c();
        mpwKeyword11.Active__c = true;
        mpwKeyword11.Sequence_No__c = 1;
        mpwKeyword11.Type__c = 'SubDeviceExtraction';
        mpwKeyword11.Value__c = '7';
        mpwKeywordList.add(mpwKeyword11);
        
        MPW_Keyword_Config__c mpwKeyword12 = new MPW_Keyword_Config__c();
        mpwKeyword12.Active__c = true;
        mpwKeyword12.Sequence_No__c = 1;
        mpwKeyword12.Type__c = 'IPSubCategory';
        mpwKeyword12.Value__c = 'Sponsored';
        mpwKeywordList.add(mpwKeyword12);
        
        MPW_Keyword_Config__c mpwKeyword13 = new MPW_Keyword_Config__c();
        mpwKeyword13.Active__c = true;
        mpwKeyword13.Sequence_No__c = 1;
        mpwKeyword13.Type__c = 'CategoryUsage';
        mpwKeyword13.Value__c = 'Required';
        mpwKeywordList.add(mpwKeyword13);
        
        MPW_Keyword_Config__c mpwKeyword14 = new MPW_Keyword_Config__c();
        mpwKeyword14.Active__c = true;
        mpwKeyword14.Sequence_No__c = 1;
        mpwKeyword14.Type__c = 'DESubCategory';
        mpwKeyword14.Value__c = 'DFM';
        mpwKeywordList.add(mpwKeyword14);
        
        if(!mpwKeywordList.isEmpty()) {
            insert mpwKeywordList;
        }
        
        return mpwKeywordList;
    }
    
    private static MPW_Config_Settings__c utilDataCSMethod() {
        
        RecordType recordType =  [Select Id from RecordType where Name = 'Process' AND SObjectType = 'MPW_Config_Settings__c'];
    
        MPW_Config_Settings__c mpwConfig = new MPW_Config_Settings__c();
        mpwConfig.Active__c = true;
        mpwConfig.Geometry__c = '28nm';
        mpwConfig.Name = '28nmGpName';
        mpwConfig.RecordTypeId = recordType.Id;
        insert mpwConfig; 
        
        return mpwConfig;
    }
    
    private static MPW_Tech_Module__c utilDataTeMMethod() {
    
        MPW_Tech_Module__c mpwTechModule = new MPW_Tech_Module__c();
        mpwTechModule.Active__c = true;
        mpwTechModule.Answers__c = 'Yes;No';
        mpwTechModule.Geometry__c = '28nm';
        mpwTechModule.Module_Description__c = 'N3';
        mpwTechModule.Module_Name__c = 'Triple well';
        mpwTechModule.Question__c = 'Do you need SRAM';
        insert mpwTechModule;
        
        return mpwTechModule;
    }
    
    private static MPW_SRAM_Configuration__c utilDataSRMCMethod(MPW_Config_Settings__c mpwConfig) {
        
        MPW_SRAM_Configuration__c mpwSRAMConfig = new MPW_SRAM_Configuration__c();
        mpwSRAMConfig.Active__c = true;
        mpwSRAMConfig.Process_Type__c = mpwConfig.id;
        insert mpwSRAMConfig;
        
        return mpwSRAMConfig;
    }    
    
    private static MPW_Train_Maintenance__c utilDataTMMethod() {
    
        MPW_Train_Maintenance__c mpwTrainMaintenance = new MPW_Train_Maintenance__c();
        mpwTrainMaintenance.Name = 'MPW0311';       
        mpwTrainMaintenance.Geometry__c = '28nm';
        mpwTrainMaintenance.Publish__c = true;
        mpwTrainMaintenance.Active__c = true;
        mpwTrainMaintenance.Reservation_Close_Date__c = System.today()-10;
        mpwTrainMaintenance.Tapeout_Date_Other_Participant__c = System.today()-10;
        mpwTrainMaintenance.Train_Type__c = 'GlobalShuttle';
        mpwTrainMaintenance.Geometry_ID__c = '0.028UM';
        mpwTrainMaintenance.Tapeout_Date_Customer__c = System.today().addMonths(-1);
        mpwTrainMaintenance.Projected_1st_Batch_Bare_Die_Ship_Start__c = System.today()+10;
        mpwTrainMaintenance.Projected_1st_Batch_Bare_Die_Ship_End__c = System.today()+16;
        insert mpwTrainMaintenance;
        
        return mpwTrainMaintenance;
    }
    
     private static MPW_Train_Maintenance_Details__c utilDataTMDMethod(MPW_Tech_Module__c mpwTechModule, MPW_Train_Maintenance__c mpwTrain, MPW_Config_Settings__c mpwConfig) {
      
        MPW_Train_Maintenance_Details__c mpwTrainDetails = new MPW_Train_Maintenance_Details__c();
        mpwTrainDetails.Answers__c = 'Yes;No';
        mpwTrainDetails.MPW_Tech_Module__c = mpwTechModule.Id;
        mpwTrainDetails.MPW_Train_Maintenance__c = mpwTrain.Id;
        mpwTrainDetails.Process_Type__c = mpwConfig.Id;
        insert mpwTrainDetails;
        
        return mpwTrainDetails;
    }
    
    private static MPW_SRAM_Question__c utilDataSRMQMethod(MPW_Reservation__c mpwReservation1, MPW_SRAM_Configuration__c mpwSRAMConfig) {
        
        MPW_SRAM_Question__c mpwSRAMQuestion = new MPW_SRAM_Question__c();
        mpwSRAMQuestion.Answer__c = 'Yes;No';
        mpwSRAMQuestion.Array_Total_Block_Size__c = '280';
        mpwSRAMQuestion.MPW_Process_Information_Question__c = mpwReservation1.Id;
        mpwSRAMQuestion.MPW_SRAM_Configuration__c = mpwSRAMConfig.Id;
        insert mpwSRAMQuestion;
        
        return mpwSRAMQuestion;
    }
    
    private static MPW_Process_Information_Question__c utilDataPIQMethod(MPW_Train_Maintenance_Details__c mpwTrainDetails, MPW_Reservation__c mpwReservation1) {
        
        MPW_Process_Information_Question__c mpwprocessInfo = new MPW_Process_Information_Question__c();
        mpwprocessInfo.Answer__c = 'Yes;No';
        mpwprocessInfo.MPW_Maintenance_Details__c = mpwTrainDetails.Id;
        mpwprocessInfo.MPW_Reservation_Form__c = mpwReservation1.Id;
        insert mpwprocessInfo;
        
        return mpwprocessInfo;
    }
    
    private static MPW_Prime_Die__c utilDataPDMethod(MPW_Reservation__c mpwReservation1) {
    
        MPW_Prime_Die__c mpwPrimeDie1 = new MPW_Prime_Die__c();
        mpwPrimeDie1.Prime_Die_Name__c = 'TestComapre1';
        mpwPrimeDie1.MPW_Form__c = mpwReservation1.Id;
        mpwPrimeDie1.Drawn_Die_Size_X_um__c = '1234';
        mpwPrimeDie1.Drawn_Die_Size_Y_um__c = '2344';
        mpwPrimeDie1.Device_Type__c = 'Product';
        mpwPrimeDie1.Delivery_Qty_Die_Form__c = '100';
        mpwPrimeDie1.Delivery_Qty_Wafer_Form__c = '7';
        mpwPrimeDie1.Drawn_Orientation_Restricted_Structures__c= 'Test';
        mpwPrimeDie1.Address2_Quantity_Delivery_In_DIE_Form__c = '100';
        mpwPrimeDie1.Address2_Quantity_Delivery_In_WAFER_Form__c = '7';
        mpwPrimeDie1.Address2_ShortLoop_Wafer__c = '4';
        mpwPrimeDie1.Metal_Stack__c = 'Test';
        mpwPrimeDie1.Corner_Split__c = 'No';
        mpwPrimeDie1.Sub_Devices_Extraction__c = '4';
        mpwPrimeDie1.SubDevicesExtractionAttached__c = true;
        mpwPrimeDie1.FF__c = '0';
        mpwPrimeDie1.FS__c = '0';
        mpwPrimeDie1.POR__c = '0';
        mpwPrimeDie1.SF__c = '0';
        mpwPrimeDie1.SS__c = '0';
        mpwPrimeDie1.GMPL_Purpose__c = 'Test';
        mpwPrimeDie1.ShortLoop_Wafer__c = '4';
        mpwPrimeDie1.Backgrind__c = '10';
        mpwPrimeDie1.Expedite_In_DIE_Form__c = '100';
        mpwPrimeDie1.Expedite_In_WAFER_Form__c = '5';
        mpwPrimeDie1.Turnkey_Service__c = 'Yes';
        mpwPrimeDie1.TurnkeyAttached__c = true;
        insert mpwPrimeDie1;
        
        return mpwPrimeDie1;
    }  
    
    private static MPW_Prime_Die__c utilDataPDMethod1(MPW_Reservation__c mpwReservation1) {
    
        MPW_Prime_Die__c mpwPrimeDie1 = new MPW_Prime_Die__c();
        mpwPrimeDie1.Prime_Die_Name__c = 'TestComapre2';
        mpwPrimeDie1.MPW_Form__c = mpwReservation1.Id;
        mpwPrimeDie1.Device_Type__c = 'None';
        mpwPrimeDie1.Delivery_Qty_Die_Form__c = '0';
        mpwPrimeDie1.Delivery_Qty_Wafer_Form__c = '0';
        mpwPrimeDie1.Drawn_Orientation_Restricted_Structures__c= 'Test';
        mpwPrimeDie1.Metal_Stack__c = 'Test';
        mpwPrimeDie1.Corner_Split__c = 'Yes';
        mpwPrimeDie1.FF__c = '0';
        mpwPrimeDie1.FS__c = '0';
        mpwPrimeDie1.POR__c = '0';
        mpwPrimeDie1.SF__c = '0';
        mpwPrimeDie1.SS__c = '0';
        mpwPrimeDie1.ShortLoop_Wafer__c = '4';
        mpwPrimeDie1.Backgrind__c = '10';
        mpwPrimeDie1.Sub_Devices_Extraction__c = '4';
        mpwPrimeDie1.SubDevicesExtractionAttached__c = true;
        mpwPrimeDie1.Expedite_In_DIE_Form__c = '100';
        mpwPrimeDie1.Expedite_In_WAFER_Form__c = '5';
        mpwPrimeDie1.Turnkey_Service__c = 'Yes';
        mpwPrimeDie1.TurnkeyAttached__c = true;
        insert mpwPrimeDie1;
        
        return mpwPrimeDie1;
    }  
    
    public static testMethod void myReservationSchedulerMethod() {   
        
        String sch = '20 30 8 10 2 ?';
        
        Account a = utilDataAccMethod();    
        List<Account_Team_Proxy__c> accountProxyList = utilDataAccPMethod(a);
        MPW_Approval_Matrix__c mpwApproval = utilDataAMMethod();
        MPW_Geometry_Mapping__c mpwGeoMap = utilDataGMMethod();
        MPW_Form_No_Generator__c mpwFormNoGen = utilDataFNGMethod();
        MPW_ERP_PA_Code__c mpwPACode = utilDataPAMethod();
        List<MPW_Keyword_Config__c> mpwKeywordList = utilDataKCMethod();
        MPW_Tech_Module__c mpwTechModule = utilDataTeMMethod();
        MPW_Config_Settings__c mpwConfig = utilDataCSMethod();
        MPW_SRAM_Configuration__c mpwSRAMConfig = utilDataSRMCMethod(mpwConfig); 
        MPW_Metal_Stack_Configuration__c mpwMetalStack = utilDataMSMethod(mpwConfig);    
        MPW_Train_Maintenance__c mpwTrainMaintenance = utilDataTMMethod();
        MPW_Train_Maintenance_Details__c mpwTrainDetails = utilDataTMDMethod(mpwTechModule, mpwTrainMaintenance, mpwConfig);  
        
        MPW_Reservation__c mpwReservation1 = new MPW_Reservation__c();        
        mpwReservation1.MPW_Train_Name__c = mpwTrainMaintenance.Id;
        mpwReservation1.Name = '2015-03-05600';
        mpwReservation1.Form_Status__c = 'Draft';
        mpwReservation1.Category__c = 'Customer';
        mpwReservation1.Usage__c = 'Required';
        mpwReservation1.Prime_Die_Name__c = 'TestComapre1';
        mpwReservation1.Reason_to_Void__c = 'Not Required';
        mpwReservation1.PA_Code__c = 'RDY67219';
        mpwReservation1.Customer_Company_Name__c = a.Id;
        mpwReservation1.Company_Name__c = 'Test';
        mpwReservation1.Company_Name2__c = 'Test1';
        mpwReservation1.Company_Name3__c = 'Test2';
        mpwReservation1.Address2__c = 'Test';
        mpwReservation1.Contact_Person2__c = 'Test';
        mpwReservation1.Phone2__c = '78342832';
        mpwReservation1.Postal_Code2__c = '78342';
        mpwReservation1.Address__c = 'Test1';
        mpwReservation1.Contact_Person__c = 'Test1';
        mpwReservation1.Phone__c = '783428321';
        mpwReservation1.Postal_Code__c = '783421';
        mpwReservation1.Address3__c = 'Test2';
        mpwReservation1.Contact_Person3__c = 'Test2';
        mpwReservation1.Phone3__c = '783428322';
        mpwReservation1.Postal_Code3__c = '783422';
        mpwReservation1.Customer_Name__c = 'test2';
        mpwReservation1.Customer_Email__c = 'abc@abc.com';
        mpwReservation1.Customer_Phone__c = '56778855';
        mpwReservation1.Process_Type__c = mpwConfig.Id;
        Test.startTest();
        MPWGeometry__c MPWGeotest=new MPWGeometry__c();
        MPWGeotest.Geometry__c='14nm LPE,14nm LPP,14nm LPP 1407,22nm eMRAM';
        Insert MPWGeotest;
        insert mpwReservation1;
        
        MPW_Prime_Die__c mpwPrimeDie1 = utilDataPDMethod(mpwReservation1);
        MPW_Process_Information_Question__c mpwprocessInfo = utilDataPIQMethod(mpwTrainDetails, mpwReservation1);
        MPW_SRAM_Question__c mpwSRAMQuestion = utilDataSRMQMethod(mpwReservation1, mpwSRAMConfig);
        
        
        
        Test.setCurrentPageReference(new PageReference('Page.MPWReservationFormVF'));
        System.currentPageReference().getParameters().put('voidtheform','true');
        System.currentPageReference().getParameters().put('mode', 'Edit');
        System.currentPageReference().getParameters().put('mpwId', mpwTrainMaintenance.Id);
        System.currentPageReference().getParameters().put('Search', '1');
        System.currentPageReference().getParameters().put('ChangeRequest', '1');
        System.currentPageReference().getParameters().put('index', '2');
        System.currentPageReference().getParameters().put('geometry', '0.028UM');
        System.currentPageReference().getParameters().put('primeIdfield', mpwPrimeDie1.Id);
        System.currentPageReference().getParameters().put('primeNamefield', 'TestComapre1');
        
        MPWReservationFormController controller = new MPWReservationFormController(new ApexPages.Standardcontroller(mpwReservation1));
        controller.getSubCategories();
        controller.getUsages();
        controller.getPACodes();
        controller.gotoPreview();
        controller.turnkeyWrap.selectedmpwpd = mpwPrimeDie1.Id;
        controller.saveAsDraft();
        //controller.submitForApproval();
              
        MPWVoidReservationFormScheduler m = new MPWVoidReservationFormScheduler();

        
            String jobID = system.schedule('Merge Job', sch, m);

            //System.schedule('Schedule Reservation to Void', sch, new MPWVoidReservationFormScheduler());  
        Test.stopTest();               
    }
    
    private static Account getAccount(string AccountName)
            {
                Account account= [SELECT Id, Name FROM Account Where Name =: AccountName];
        
                return account;
            }  
}