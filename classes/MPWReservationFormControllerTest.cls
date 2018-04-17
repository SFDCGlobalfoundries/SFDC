/*
    Author: Abhita Bansal
    Created Date: 16/09/2015 
    Description: Test class for MPWReservationFormController
*/
@isTest
public class MPWReservationFormControllerTest {

    @testSetup static void testdata() {
        DataUtilTest.loadEnvironmentVariables();
         //Environment_Variable__c objEnvironmentVariable=new Environment_Variable__c(Name = 'AccountProxy', Value__c = '15');
        // database.insert(objEnvironmentVariable, false);
         
       
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
        RecordType recordType =  [Select Id from RecordType where Name = 'Customer' AND SObjectType = 'Account'];
        
        User thisUser = [select Id from User where Profile.Name ='GF Sales User' and isActive = true and UserRoleId != null limit 1];
        
        Account account= new Account();
        Map<String,Object> fieldValueMap = new Map<String,Object>();
        fieldValueMap.put('Name', 'MYTEST ACCOUNT1');            
        fieldValueMap.put('stage__c', 'Unqualified');        
        fieldValueMap.put('sub_type__c', 'Direct');
        fieldValueMap.put('site_department__c', 'test dept');          
        fieldValueMap.put('transaction_type__c', 'transactional');                          
        fieldValueMap.put('region__c', 'APJ');        
        fieldValueMap.put('Corporate_Address_1__c', 'Test Address 1');          
        fieldValueMap.put('Corporate_City__c', 'Test City');                
        fieldValueMap.put('Corporate_Country__c', 'Singapore');
        fieldValueMap.put('Bill_To_Address_1__c', 'Test Address 1');          
        fieldValueMap.put('Bill_To_City__c', 'Test City');            
        fieldValueMap.put('Bill_To_Country__c', 'Singapore');        
        fieldValueMap.put('Fab_9_10__c','No');
        fieldValueMap.put('ownerId',thisUser.Id);
        fieldValueMap.put('recordtypeid', recordType.id);     
        account= AccountDataFactory.createAccount(fieldValueMap);
        
        return account;
    }
    
    private static Account utilDataAccMethod1() {
        RecordType recordType =  [Select Id from RecordType where Name = 'GLOBALFOUNDRIES Internal' AND SObjectType = 'Account'];
        
        Account account= new Account();
        Map<String,Object> fieldValueMap = new Map<String,Object>();
        fieldValueMap.put('Name', 'MYTEST ACCOUNT2');            
        fieldValueMap.put('stage__c', 'Unqualified');        
        fieldValueMap.put('sub_type__c', 'Direct');
        fieldValueMap.put('site_department__c', 'test dept');          
        fieldValueMap.put('transaction_type__c', 'transactional');                          
        fieldValueMap.put('region__c', 'APJ');        
        fieldValueMap.put('Corporate_Address_1__c', 'Test Address 1');          
        fieldValueMap.put('Corporate_City__c', 'Test City');                
        fieldValueMap.put('Corporate_Country__c', 'Singapore');
        fieldValueMap.put('Bill_To_Address_1__c', 'Test Address 1');          
        fieldValueMap.put('Bill_To_City__c', 'Test City');            
        fieldValueMap.put('Bill_To_Country__c', 'Singapore');        
        fieldValueMap.put('Fab_9_10__c','No');
        
        fieldValueMap.put('recordtypeid', recordType.id);     
        account= AccountDataFactory.createAccount(fieldValueMap);
        
        return account;
    }
    
    private static Account utilDataAccMethod2(Account account) {
        RecordType recordType =  [Select Id from RecordType where Name = 'Customer' AND SObjectType = 'Account'];
        
        Account account1= new Account();
        Map<String,Object> fieldValueMap = new Map<String,Object>();
        fieldValueMap.put('Name', 'MYTEST ACCOUNT1');            
        fieldValueMap.put('stage__c', 'Unqualified');        
        fieldValueMap.put('sub_type__c', 'Direct');
        fieldValueMap.put('site_department__c', 'test dept');          
        fieldValueMap.put('transaction_type__c', 'transactional');                          
        fieldValueMap.put('region__c', 'APJ');        
        fieldValueMap.put('Corporate_Address_1__c', 'Test Address 1');          
        fieldValueMap.put('Corporate_City__c', 'Test City');                
        fieldValueMap.put('Corporate_Country__c', 'Singapore');
        fieldValueMap.put('Bill_To_Address_1__c', 'Test Address 1');          
        fieldValueMap.put('Bill_To_City__c', 'Test City');            
        fieldValueMap.put('Bill_To_Country__c', 'Singapore');        
        fieldValueMap.put('Fab_9_10__c','No');
        fieldValueMap.put('recordtypeid', recordType.id);     
        account= AccountDataFactory.createAccount(fieldValueMap);
               
        return account1;
    }
    
    private static MPW_Train_Account__c utilDataTAMethod(Account account, MPW_Train_Maintenance__c mpwTrainMaintenance) {
        MPW_Train_Account__c mpwTrainAccount = new MPW_Train_Account__c();
        mpwTrainAccount.Account__c = account.Id;
        mpwTrainAccount.MPW_Train__c = mpwTrainMaintenance.Id;
        insert mpwTrainAccount;
        
        return mpwTrainAccount;
    }
    
    private static MPW_Train_Account__c utilDataTAMethod1(Account account1, MPW_Train_Maintenance__c mpwTrainMaintenance) {
        MPW_Train_Account__c mpwTrainAccount = new MPW_Train_Account__c();
        mpwTrainAccount.Account__c = account1.Id;
        mpwTrainAccount.MPW_Train__c = mpwTrainMaintenance.Id;
        insert mpwTrainAccount;
        
        return mpwTrainAccount;
    }
    
    private static Contact utilDataConMethod(Account account) {
        Contact con = new Contact();
        con.FirstName = 'FirstName';
        con.LastName = 'LastName';
        con.AccountId = account.Id;
        con.Email = 'test1@test.com';
        con.Department__c='Design';
        insert con;  
        
        return con;
    }
    
    private static User utilDataUserMethod(Contact con) {
        User u = new User();
        u.LastName = 'LastName';
        u.Alias = 'Test1';
        u.Email = 'test1@test.com';
        u.LanguageLocaleKey = 'en_US';
        u.EmailEncodingKey = 'UTF-8';
        u.LocaleSidKey = 'en_US';
        u.ProfileId = [Select Id,Name from Profile where Name = 'Customer Portal Admin'].Id;
        u.TimeZoneSidKey = 'America/Los_Angeles';
        u.UserName = 'test1@test.com.mpwdev';
        u.Portal_login__c = 'xyz';
        u.ContactId = con.Id;
        u.IsActive = true;
        u.CommunityNickname = 'Testtest123';
        insert u;
        
        return u;
    }
    
    private static List<Account_Team_Proxy__c> utilDataAccPMethod(Account a, Integer iCount) {
        List<Account_Team_Proxy__c> accountProxyList =  new List<Account_Team_Proxy__c>();
        List<User> userAppMatrix = [select Id from User where Profile.Name = 'GF PIYE Platform' and isActive = true limit 12];
        
		if(userAppMatrix.size() > 0 && iCount > 0) {
			Account_Team_Proxy__c accProxy = new Account_Team_Proxy__c();
			accProxy.Account__c = a.Id;
			accProxy.Team_Role__c = 'Field Application Engineer';
			accProxy.User__c = userAppMatrix[0].Id;
			accProxy.Account_Access__c = 'Read/Write';
			//insert accProxy;
			accountProxyList.add(accProxy);
        }
		if(userAppMatrix.size() > 1 && iCount > 1) {
			Account_Team_Proxy__c accProxy1 = new Account_Team_Proxy__c();
			accProxy1.Account__c = a.Id;
			accProxy1.Team_Role__c = 'Field Application Engineer';
			accProxy1.User__c = userAppMatrix[1].Id;
			accProxy1.Account_Access__c = 'Read/Write';
			//insert accProxy1;
			accountProxyList.add(accProxy1);
        }
		if(userAppMatrix.size() > 2 && iCount > 2) {
			Account_Team_Proxy__c accProxy2 = new Account_Team_Proxy__c();
			accProxy2.Account__c = a.Id;
			accProxy2.Team_Role__c = 'Field Application Engineer';
			accProxy2.User__c = userAppMatrix[2].Id;
			accProxy2.Account_Access__c = 'Read/Write';
			//insert accProxy2;
			accountProxyList.add(accProxy2);
        }
		if(userAppMatrix.size() > 3 && iCount > 3) {
			Account_Team_Proxy__c accProxy3 = new Account_Team_Proxy__c();
			accProxy3.Account__c = a.Id;
			accProxy3.Team_Role__c = 'Field Application Engineer';
			accProxy3.User__c = userAppMatrix[3].Id;
			accProxy3.Account_Access__c = 'Read/Write';
			//insert accProxy3;
			accountProxyList.add(accProxy3);
		}
		if(userAppMatrix.size() > 4 && iCount > 4) {
			Account_Team_Proxy__c accProxy4 = new Account_Team_Proxy__c();
			accProxy4.Account__c = a.Id;
			accProxy4.Team_Role__c = 'Field Application Engineer';
			accProxy4.User__c = userAppMatrix[4].Id;
			accProxy4.Account_Access__c = 'Read/Write';
			accountProxyList.add(accProxy4);
        }
		if(userAppMatrix.size() > 5 && iCount > 5) {
			Account_Team_Proxy__c accProxy5 = new Account_Team_Proxy__c();
			accProxy5.Account__c = a.Id;
			accProxy5.Team_Role__c = 'Field Application Engineer';
			accProxy5.User__c = userAppMatrix[5].Id;
			accProxy5.Account_Access__c = 'Read/Write';
			accountProxyList.add(accProxy5);
		}
		if(userAppMatrix.size() > 6 && iCount > 6) {
			Account_Team_Proxy__c accProxy6 = new Account_Team_Proxy__c();
			accProxy6.Account__c = a.Id;
			accProxy6.Team_Role__c = 'Field Application Engineer';
			accProxy6.User__c = userAppMatrix[6].Id;
			accProxy6.Account_Access__c = 'Read/Write';
			accountProxyList.add(accProxy6);
		}
		if(userAppMatrix.size() > 7 && iCount > 7) {
			Account_Team_Proxy__c accProxy7 = new Account_Team_Proxy__c();
			accProxy7.Account__c = a.Id;
			accProxy7.Team_Role__c = 'Field Application Engineer';
			accProxy7.User__c = userAppMatrix[7].Id;
			accProxy7.Account_Access__c = 'Read/Write';
			accountProxyList.add(accProxy7);
		}
		if(userAppMatrix.size() > 8 && iCount > 8) {
			Account_Team_Proxy__c accProxy8 = new Account_Team_Proxy__c();
			accProxy8.Account__c = a.Id;
			accProxy8.Team_Role__c = 'Field Application Engineer';
			accProxy8.User__c = userAppMatrix[8].Id;
			accProxy8.Account_Access__c = 'Read/Write';
			accountProxyList.add(accProxy8);
		}
		if(userAppMatrix.size() > 9 && iCount > 9) {
			Account_Team_Proxy__c accProxy9 = new Account_Team_Proxy__c();
			accProxy9.Account__c = a.Id;
			accProxy9.Team_Role__c = 'Primary Account Manager';
			accProxy9.User__c = userAppMatrix[9].Id;
			accProxy9.Account_Access__c = 'Read/Write';
			accountProxyList.add(accProxy9);
		}
		if(userAppMatrix.size() > 10 && iCount > 10) {
			Account_Team_Proxy__c accProxy10 = new Account_Team_Proxy__c();
			accProxy10.Account__c = a.Id;
			accProxy10.Team_Role__c = 'Primary Customer Service Rep';
			accProxy10.User__c = userAppMatrix[10].Id;
			accProxy10.Account_Access__c = 'Read/Write';
			accountProxyList.add(accProxy10);
		}
		if(userAppMatrix.size() > 11 && iCount > 11) {
			Account_Team_Proxy__c accProxy11 = new Account_Team_Proxy__c();
			accProxy11.Account__c = a.Id;
			accProxy11.Team_Role__c = 'Primary Field Application Engineer';
			accProxy11.User__c = userAppMatrix[11].Id;
			accProxy11.Account_Access__c = 'Read/Write';
			accountProxyList.add(accProxy11);
		}
		insert accountProxyList;
		
        return accountProxyList;
    }  
    
    private static MPW_Form_No_Generator__c utilDataFNGMethod() { 
        MPW_Form_No_Generator__c mpwFormNoGen = new MPW_Form_No_Generator__c();
        mpwFormNoGen.Geometry__c = '03';
        mpwFormNoGen.Year__c = String.valueOf(System.Today().year());
        mpwFormNoGen.Last_Sequence_No__c = 1;
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
        mpwTrainMaintenance.Reservation_Close_Date__c = System.today()+10;
        mpwTrainMaintenance.Train_Type__c = 'GlobalShuttle';
        mpwTrainMaintenance.Geometry_ID__c = '0.028UM';
        mpwTrainMaintenance.Tapeout_Date_Customer__c = System.today();
        mpwTrainMaintenance.Fab__c = 'Fab1';
        insert mpwTrainMaintenance;
        
        return mpwTrainMaintenance;
    }
    
    private static MPW_Train_Maintenance__c utilDataTMMethod3() {
        MPW_Train_Maintenance__c mpwTrainMaintenance = new MPW_Train_Maintenance__c();
        mpwTrainMaintenance.Name = 'MPW1811';
        mpwTrainMaintenance.Geometry__c = '0.18um';
        mpwTrainMaintenance.Publish__c = true;
        mpwTrainMaintenance.Active__c = true;
        mpwTrainMaintenance.Reservation_Close_Date__c = System.today()+10;
        mpwTrainMaintenance.Train_Type__c = 'GlobalShuttle';
        mpwTrainMaintenance.Geometry_ID__c = '0.028UM';
        mpwTrainMaintenance.Tapeout_Date_Customer__c = System.today();
        mpwTrainMaintenance.Fab__c = 'Fab1';
        insert mpwTrainMaintenance;
        
        return mpwTrainMaintenance;
    }
    
    private static MPW_Train_Maintenance__c utilDataTMMethod1() {
        MPW_Train_Maintenance__c mpwTrainMaintenance = new MPW_Train_Maintenance__c();
        mpwTrainMaintenance.Name = 'MPWCS031';
        mpwTrainMaintenance.Geometry__c = '28nm';
        mpwTrainMaintenance.Publish__c = true;
        mpwTrainMaintenance.Active__c = true;
        mpwTrainMaintenance.Reservation_Close_Date__c = System.today()+10;
        mpwTrainMaintenance.Train_Type__c = 'CustomizedShuttle';
        mpwTrainMaintenance.Geometry_ID__c = '0.028UM';
        mpwTrainMaintenance.Tapeout_Date_Customer__c = System.today();
        mpwTrainMaintenance.Fab__c = 'Fab1';
        insert mpwTrainMaintenance;
        
        return mpwTrainMaintenance;
    }
    
    private static MPW_Train_Maintenance__c utilDataTMMethod2() {
        MPW_Train_Maintenance__c mpwTrainMaintenance = new MPW_Train_Maintenance__c();
        mpwTrainMaintenance.Name = 'MPW0311';       
        mpwTrainMaintenance.Geometry__c = '28nm';
        mpwTrainMaintenance.Publish__c = true;
        mpwTrainMaintenance.Active__c = true;
        mpwTrainMaintenance.Reservation_Close_Date__c = System.today()-5;
        mpwTrainMaintenance.Train_Type__c = 'GlobalShuttle';
        mpwTrainMaintenance.Geometry_ID__c = '0.028UM';
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
        mpwPrimeDie1.FF__c = '0';
        mpwPrimeDie1.FS__c = '0';
        mpwPrimeDie1.POR__c = '0';
        mpwPrimeDie1.SF__c = '0';
        mpwPrimeDie1.SS__c = '0';
        mpwPrimeDie1.GMPL_Purpose__c = 'Test';
        mpwPrimeDie1.ShortLoop_Wafer__c = '4';
        mpwPrimeDie1.Sub_Devices_Extraction__c = '0';
        mpwPrimeDie1.Backgrind__c = '10';
        mpwPrimeDie1.Expedite_In_DIE_Form__c = '100';
        mpwPrimeDie1.Expedite_In_WAFER_Form__c = '5';
        mpwPrimeDie1.Turnkey_Service__c = 'No';
        insert mpwPrimeDie1;
        
        return mpwPrimeDie1;
    }  
    
    private static MPW_Prime_Die__c utilDataPDMethod1(MPW_Reservation__c mpwReservation1) {
        MPW_Prime_Die__c mpwPrimeDie1 = new MPW_Prime_Die__c();
        mpwPrimeDie1.Prime_Die_Name__c = 'TestComapre2';
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
        mpwPrimeDie1.FF__c = '0';
        mpwPrimeDie1.FS__c = '0';
        mpwPrimeDie1.POR__c = '0';
        mpwPrimeDie1.SF__c = '0';
        mpwPrimeDie1.SS__c = '0';
        mpwPrimeDie1.GMPL_Purpose__c = 'Test';
        mpwPrimeDie1.ShortLoop_Wafer__c = '4';
        mpwPrimeDie1.Sub_Devices_Extraction__c = '0';
        mpwPrimeDie1.Backgrind__c = '10';
        mpwPrimeDie1.Expedite_In_DIE_Form__c = '100';
        mpwPrimeDie1.Expedite_In_WAFER_Form__c = '5';
        mpwPrimeDie1.Turnkey_Service__c = 'No';
        insert mpwPrimeDie1;
        
        return mpwPrimeDie1;
    } 
    
    private static MPW_Prime_Die__c utilDataPDMethod2(MPW_Reservation__c mpwReservation1) {
        MPW_Prime_Die__c mpwPrimeDie1 = new MPW_Prime_Die__c();
        mpwPrimeDie1.Prime_Die_Name__c = 'TestComapre2';
        mpwPrimeDie1.MPW_Form__c = mpwReservation1.Id;
        mpwPrimeDie1.Drawn_Die_Size_X_um__c = null;
        mpwPrimeDie1.Drawn_Die_Size_Y_um__c = null;
        mpwPrimeDie1.Device_Type__c = 'None';
        mpwPrimeDie1.Delivery_Qty_Die_Form__c = '100';
        mpwPrimeDie1.Delivery_Qty_Wafer_Form__c = '5';
        mpwPrimeDie1.Drawn_Orientation_Restricted_Structures__c= 'Test';
        mpwPrimeDie1.Address2_Quantity_Delivery_In_DIE_Form__c = '100';
        mpwPrimeDie1.Address2_Quantity_Delivery_In_WAFER_Form__c = '7';
        mpwPrimeDie1.Address2_ShortLoop_Wafer__c = '4';
        mpwPrimeDie1.Metal_Stack__c = 'Test';
        mpwPrimeDie1.Corner_Split__c = 'Yes';
        mpwPrimeDie1.FF__c = '50';
        mpwPrimeDie1.FS__c = '0';
        mpwPrimeDie1.POR__c = '0';
        mpwPrimeDie1.SF__c = '0';
        mpwPrimeDie1.SS__c = '0';
        mpwPrimeDie1.Wafer_FF__c = '3';
        mpwPrimeDie1.Wafer_FS__c = '0';
        mpwPrimeDie1.Wafer_POR__c = '0';
        mpwPrimeDie1.Wafer_SF__c = '0';
        mpwPrimeDie1.Wafer_SS__c = '0';
        mpwPrimeDie1.GMPL_Purpose__c = null;
        mpwPrimeDie1.ShortLoop_Wafer__c = '4';
        mpwPrimeDie1.Sub_Devices_Extraction__c = '0';
        mpwPrimeDie1.Backgrind__c = 'None';
        mpwPrimeDie1.Expedite_In_DIE_Form__c = '100';
        mpwPrimeDie1.Expedite_In_WAFER_Form__c = '5';
        mpwPrimeDie1.Turnkey_Service__c = 'No';
        insert mpwPrimeDie1;
        return mpwPrimeDie1;
    } 
    
    private static MPW_Prime_Die__c utilDataPDMethod3(MPW_Reservation__c mpwReservation1) {
        MPW_Prime_Die__c mpwPrimeDie1 = new MPW_Prime_Die__c();
        mpwPrimeDie1.Prime_Die_Name__c = 'TestComapre2';
        mpwPrimeDie1.MPW_Form__c = mpwReservation1.Id;
        mpwPrimeDie1.Drawn_Die_Size_X_um__c = null;
        mpwPrimeDie1.Drawn_Die_Size_Y_um__c = null;
        mpwPrimeDie1.Device_Type__c = 'None';
        mpwPrimeDie1.Delivery_Qty_Die_Form__c = '100';
        mpwPrimeDie1.Delivery_Qty_Wafer_Form__c = '0';
        mpwPrimeDie1.Drawn_Orientation_Restricted_Structures__c= 'Test';
        mpwPrimeDie1.Address2_Quantity_Delivery_In_DIE_Form__c = '100';
        mpwPrimeDie1.Address2_Quantity_Delivery_In_WAFER_Form__c = '0';
        mpwPrimeDie1.Address2_ShortLoop_Wafer__c = '4';
        mpwPrimeDie1.Metal_Stack__c = 'Test';
        mpwPrimeDie1.Corner_Split__c = 'Yes';
        mpwPrimeDie1.FF__c = '';
        mpwPrimeDie1.FS__c = '';
        mpwPrimeDie1.POR__c = '';
        mpwPrimeDie1.SF__c = '';
        mpwPrimeDie1.SS__c = '';
        mpwPrimeDie1.Wafer_FF__c = '';
        mpwPrimeDie1.Wafer_FS__c = '';
        mpwPrimeDie1.Wafer_POR__c = '';
        mpwPrimeDie1.Wafer_SF__c = '';
        mpwPrimeDie1.Wafer_SS__c = '';
        mpwPrimeDie1.GMPL_Purpose__c = null;
        mpwPrimeDie1.ShortLoop_Wafer__c = '4';
        mpwPrimeDie1.Sub_Devices_Extraction__c = '0';
        mpwPrimeDie1.Backgrind__c = 'None';
        mpwPrimeDie1.Expedite_In_DIE_Form__c = '100';
        mpwPrimeDie1.Expedite_In_WAFER_Form__c = '5';
        mpwPrimeDie1.Turnkey_Service__c = 'No';
        insert mpwPrimeDie1;
        return mpwPrimeDie1;
    }
    
    private static MPW_Prime_Die__c utilDataPDMethod4(MPW_Reservation__c mpwReservation1) {
        MPW_Prime_Die__c mpwPrimeDie1 = new MPW_Prime_Die__c();
        mpwPrimeDie1.Prime_Die_Name__c = 'TestComapre2';
        mpwPrimeDie1.MPW_Form__c = mpwReservation1.Id;
        mpwPrimeDie1.Drawn_Die_Size_X_um__c = null;
        mpwPrimeDie1.Drawn_Die_Size_Y_um__c = null;
        mpwPrimeDie1.Device_Type__c = 'None';
        mpwPrimeDie1.Delivery_Qty_Die_Form__c = '0';
        mpwPrimeDie1.Delivery_Qty_Wafer_Form__c = '12';
        mpwPrimeDie1.Drawn_Orientation_Restricted_Structures__c= 'Test';
        mpwPrimeDie1.Address2_Quantity_Delivery_In_DIE_Form__c = '0';
        mpwPrimeDie1.Address2_Quantity_Delivery_In_WAFER_Form__c = '12';
        mpwPrimeDie1.Address2_ShortLoop_Wafer__c = '4';
        mpwPrimeDie1.Metal_Stack__c = 'Test';
        mpwPrimeDie1.Corner_Split__c = 'Yes';
        mpwPrimeDie1.FF__c = '';
        mpwPrimeDie1.FS__c = '';
        mpwPrimeDie1.POR__c = '';
        mpwPrimeDie1.SF__c = '';
        mpwPrimeDie1.SS__c = '';
        mpwPrimeDie1.Wafer_FF__c = '';
        mpwPrimeDie1.Wafer_FS__c = '';
        mpwPrimeDie1.Wafer_POR__c = '';
        mpwPrimeDie1.Wafer_SF__c = '';
        mpwPrimeDie1.Wafer_SS__c = '';
        mpwPrimeDie1.GMPL_Purpose__c = null;
        mpwPrimeDie1.ShortLoop_Wafer__c = '4';
        mpwPrimeDie1.Sub_Devices_Extraction__c = '0';
        mpwPrimeDie1.Backgrind__c = 'None';
        mpwPrimeDie1.Expedite_In_DIE_Form__c = '100';
        mpwPrimeDie1.Expedite_In_WAFER_Form__c = '5';
        mpwPrimeDie1.Turnkey_Service__c = 'No';
        insert mpwPrimeDie1;
        return mpwPrimeDie1;
    }
    
    private static MPW_Prime_Die__c utilDataPDMethod5(MPW_Reservation__c mpwReservation1) {
        MPW_Prime_Die__c mpwPrimeDie1 = new MPW_Prime_Die__c();
        mpwPrimeDie1.Prime_Die_Name__c = 'TestComapre2';
        mpwPrimeDie1.MPW_Form__c = mpwReservation1.Id;
        mpwPrimeDie1.Drawn_Die_Size_X_um__c = null;
        mpwPrimeDie1.Drawn_Die_Size_Y_um__c = null;
        mpwPrimeDie1.Device_Type__c = 'None';
        mpwPrimeDie1.Delivery_Qty_Die_Form__c = '100';
        mpwPrimeDie1.Delivery_Qty_Wafer_Form__c = '12';
        mpwPrimeDie1.Drawn_Orientation_Restricted_Structures__c= 'Test';
        mpwPrimeDie1.Address2_Quantity_Delivery_In_DIE_Form__c = '100';
        mpwPrimeDie1.Address2_Quantity_Delivery_In_WAFER_Form__c = '12';
        mpwPrimeDie1.Address2_ShortLoop_Wafer__c = '4';
        mpwPrimeDie1.Metal_Stack__c = 'Test';
        mpwPrimeDie1.Corner_Split__c = 'Yes';
        mpwPrimeDie1.FF__c = '100';
        mpwPrimeDie1.FS__c = '';
        mpwPrimeDie1.POR__c = '';
        mpwPrimeDie1.SF__c = '';
        mpwPrimeDie1.SS__c = '';
        mpwPrimeDie1.Wafer_FF__c = '';
        mpwPrimeDie1.Wafer_FS__c = '';
        mpwPrimeDie1.Wafer_POR__c = '12';
        mpwPrimeDie1.Wafer_SF__c = '';
        mpwPrimeDie1.Wafer_SS__c = '';
        mpwPrimeDie1.GMPL_Purpose__c = null;
        mpwPrimeDie1.ShortLoop_Wafer__c = '4';
        mpwPrimeDie1.Sub_Devices_Extraction__c = '0';
        mpwPrimeDie1.Backgrind__c = 'None';
        mpwPrimeDie1.Expedite_In_DIE_Form__c = '100';
        mpwPrimeDie1.Expedite_In_WAFER_Form__c = '5';
        mpwPrimeDie1.Turnkey_Service__c = 'No';
        insert mpwPrimeDie1;
        return mpwPrimeDie1;
    }
    
    private static MPW_Prime_Die__c utilDataPDMethod6(MPW_Reservation__c mpwReservation1) {
        MPW_Prime_Die__c mpwPrimeDie1 = new MPW_Prime_Die__c();
        mpwPrimeDie1.Prime_Die_Name__c = 'TestComapre2';
        mpwPrimeDie1.MPW_Form__c = mpwReservation1.Id;
        mpwPrimeDie1.Drawn_Die_Size_X_um__c = null;
        mpwPrimeDie1.Drawn_Die_Size_Y_um__c = null;
        mpwPrimeDie1.Device_Type__c = 'None';
        mpwPrimeDie1.Delivery_Qty_Die_Form__c = '100';
        mpwPrimeDie1.Delivery_Qty_Wafer_Form__c = '12';
        mpwPrimeDie1.Drawn_Orientation_Restricted_Structures__c= 'Test';
        mpwPrimeDie1.Address2_Quantity_Delivery_In_DIE_Form__c = '100';
        mpwPrimeDie1.Address2_Quantity_Delivery_In_WAFER_Form__c = '12';
        mpwPrimeDie1.Address2_ShortLoop_Wafer__c = '4';
        mpwPrimeDie1.Metal_Stack__c = 'Test';
        mpwPrimeDie1.Corner_Split__c = 'Yes';
        mpwPrimeDie1.FF__c = '';
        mpwPrimeDie1.FS__c = '';
        mpwPrimeDie1.POR__c = '100';
        mpwPrimeDie1.SF__c = '';
        mpwPrimeDie1.SS__c = '';
        mpwPrimeDie1.Wafer_FF__c = '12';
        mpwPrimeDie1.Wafer_FS__c = '';
        mpwPrimeDie1.Wafer_POR__c = '';
        mpwPrimeDie1.Wafer_SF__c = '';
        mpwPrimeDie1.Wafer_SS__c = '';
        mpwPrimeDie1.GMPL_Purpose__c = null;
        mpwPrimeDie1.ShortLoop_Wafer__c = '4';
        mpwPrimeDie1.Sub_Devices_Extraction__c = '0';
        mpwPrimeDie1.Backgrind__c = 'None';
        mpwPrimeDie1.Expedite_In_DIE_Form__c = '100';
        mpwPrimeDie1.Expedite_In_WAFER_Form__c = '5';
        mpwPrimeDie1.Turnkey_Service__c = 'No';
        insert mpwPrimeDie1;
        return mpwPrimeDie1;
    }
    
    private static MPW_Prime_Die__c utilDataPDMethod7(MPW_Reservation__c mpwReservation1) {
        MPW_Prime_Die__c mpwPrimeDie1 = new MPW_Prime_Die__c();
        mpwPrimeDie1.Prime_Die_Name__c = 'TestComapre2';
        mpwPrimeDie1.MPW_Form__c = mpwReservation1.Id;
        mpwPrimeDie1.Drawn_Die_Size_X_um__c = null;
        mpwPrimeDie1.Drawn_Die_Size_Y_um__c = null;
        mpwPrimeDie1.Device_Type__c = 'None';
        mpwPrimeDie1.Delivery_Qty_Die_Form__c = '100';
        mpwPrimeDie1.Delivery_Qty_Wafer_Form__c = '12';
        mpwPrimeDie1.Drawn_Orientation_Restricted_Structures__c= 'Test';
        mpwPrimeDie1.Address2_Quantity_Delivery_In_DIE_Form__c = '100';
        mpwPrimeDie1.Address2_Quantity_Delivery_In_WAFER_Form__c = '12';
        mpwPrimeDie1.Address2_ShortLoop_Wafer__c = '4';
        mpwPrimeDie1.Metal_Stack__c = 'Test';
        mpwPrimeDie1.Corner_Split__c = 'Yes';
        mpwPrimeDie1.FF__c = '50';
        mpwPrimeDie1.FS__c = '';
        mpwPrimeDie1.POR__c = '';
        mpwPrimeDie1.SF__c = '';
        mpwPrimeDie1.SS__c = '';
        mpwPrimeDie1.Wafer_FF__c = '0';
        mpwPrimeDie1.Wafer_FS__c = '';
        mpwPrimeDie1.Wafer_POR__c = '12';
        mpwPrimeDie1.Wafer_SF__c = '';
        mpwPrimeDie1.Wafer_SS__c = '';
        mpwPrimeDie1.GMPL_Purpose__c = null;
        mpwPrimeDie1.ShortLoop_Wafer__c = '4';
        mpwPrimeDie1.Sub_Devices_Extraction__c = '0';
        mpwPrimeDie1.Backgrind__c = 'None';
        mpwPrimeDie1.Expedite_In_DIE_Form__c = '100';
        mpwPrimeDie1.Expedite_In_WAFER_Form__c = '5';
        mpwPrimeDie1.Turnkey_Service__c = 'No';
        insert mpwPrimeDie1;
        return mpwPrimeDie1;
    }
    
    private static MPW_Prime_Die__c utilDataPDMethod8(MPW_Reservation__c mpwReservation1) {
        MPW_Prime_Die__c mpwPrimeDie1 = new MPW_Prime_Die__c();
        mpwPrimeDie1.Prime_Die_Name__c = 'TestComapre2';
        mpwPrimeDie1.MPW_Form__c = mpwReservation1.Id;
        mpwPrimeDie1.Drawn_Die_Size_X_um__c = null;
        mpwPrimeDie1.Drawn_Die_Size_Y_um__c = null;
        mpwPrimeDie1.Device_Type__c = 'None';
        mpwPrimeDie1.Delivery_Qty_Die_Form__c = '100';
        mpwPrimeDie1.Delivery_Qty_Wafer_Form__c = '12';
        mpwPrimeDie1.Drawn_Orientation_Restricted_Structures__c= 'Test';
        mpwPrimeDie1.Address2_Quantity_Delivery_In_DIE_Form__c = '100';
        mpwPrimeDie1.Address2_Quantity_Delivery_In_WAFER_Form__c = '12';
        mpwPrimeDie1.Address2_ShortLoop_Wafer__c = '4';
        mpwPrimeDie1.Metal_Stack__c = 'Test';
        mpwPrimeDie1.Corner_Split__c = 'Yes';
        mpwPrimeDie1.FF__c = '';
        mpwPrimeDie1.FS__c = '';
        mpwPrimeDie1.POR__c = '50';
        mpwPrimeDie1.SF__c = '';
        mpwPrimeDie1.SS__c = '';
        mpwPrimeDie1.Wafer_FF__c = '0';
        mpwPrimeDie1.Wafer_FS__c = '';
        mpwPrimeDie1.Wafer_POR__c = '12';
        mpwPrimeDie1.Wafer_SF__c = '';
        mpwPrimeDie1.Wafer_SS__c = '';
        mpwPrimeDie1.GMPL_Purpose__c = null;
        mpwPrimeDie1.ShortLoop_Wafer__c = '4';
        mpwPrimeDie1.Sub_Devices_Extraction__c = '0';
        mpwPrimeDie1.Backgrind__c = 'None';
        mpwPrimeDie1.Expedite_In_DIE_Form__c = '100';
        mpwPrimeDie1.Expedite_In_WAFER_Form__c = '5';
        mpwPrimeDie1.Turnkey_Service__c = 'No';
        insert mpwPrimeDie1;
        return mpwPrimeDie1;
    }
    
    private static MPW_Prime_Die__c utilDataPDMethod9(MPW_Reservation__c mpwReservation1) {
        MPW_Prime_Die__c mpwPrimeDie1 = new MPW_Prime_Die__c();
        mpwPrimeDie1.Prime_Die_Name__c = 'TestComapre2';
        mpwPrimeDie1.MPW_Form__c = mpwReservation1.Id;
        mpwPrimeDie1.Drawn_Die_Size_X_um__c = null;
        mpwPrimeDie1.Drawn_Die_Size_Y_um__c = null;
        mpwPrimeDie1.Device_Type__c = 'None';
        mpwPrimeDie1.Delivery_Qty_Die_Form__c = '100';
        mpwPrimeDie1.Delivery_Qty_Wafer_Form__c = '12';
        mpwPrimeDie1.Drawn_Orientation_Restricted_Structures__c= 'Test';
        mpwPrimeDie1.Address2_Quantity_Delivery_In_DIE_Form__c = '100';
        mpwPrimeDie1.Address2_Quantity_Delivery_In_WAFER_Form__c = '12';
        mpwPrimeDie1.Address2_ShortLoop_Wafer__c = '4';
        mpwPrimeDie1.Metal_Stack__c = 'Test';
        mpwPrimeDie1.Corner_Split__c = 'Yes';
        mpwPrimeDie1.FF__c = '0';
        mpwPrimeDie1.FS__c = '';
        mpwPrimeDie1.POR__c = '100';
        mpwPrimeDie1.SF__c = '';
        mpwPrimeDie1.SS__c = '';
        mpwPrimeDie1.Wafer_FF__c = '1';
        mpwPrimeDie1.Wafer_FS__c = '';
        mpwPrimeDie1.Wafer_POR__c = '';
        mpwPrimeDie1.Wafer_SF__c = '';
        mpwPrimeDie1.Wafer_SS__c = '';
        mpwPrimeDie1.GMPL_Purpose__c = null;
        mpwPrimeDie1.ShortLoop_Wafer__c = '4';
        mpwPrimeDie1.Sub_Devices_Extraction__c = '0';
        mpwPrimeDie1.Backgrind__c = 'None';
        mpwPrimeDie1.Expedite_In_DIE_Form__c = '100';
        mpwPrimeDie1.Expedite_In_WAFER_Form__c = '5';
        mpwPrimeDie1.Turnkey_Service__c = 'No';
        insert mpwPrimeDie1;
        return mpwPrimeDie1;
    }
    
    private static MPW_Prime_Die__c utilDataPDMethod10(MPW_Reservation__c mpwReservation1) {
        MPW_Prime_Die__c mpwPrimeDie1 = new MPW_Prime_Die__c();
        mpwPrimeDie1.Prime_Die_Name__c = 'TestComapre2';
        mpwPrimeDie1.MPW_Form__c = mpwReservation1.Id;
        mpwPrimeDie1.Drawn_Die_Size_X_um__c = null;
        mpwPrimeDie1.Drawn_Die_Size_Y_um__c = null;
        mpwPrimeDie1.Device_Type__c = 'None';
        mpwPrimeDie1.Delivery_Qty_Die_Form__c = '100';
        mpwPrimeDie1.Delivery_Qty_Wafer_Form__c = '12';
        mpwPrimeDie1.Drawn_Orientation_Restricted_Structures__c= 'Test';
        mpwPrimeDie1.Address2_Quantity_Delivery_In_DIE_Form__c = '100';
        mpwPrimeDie1.Address2_Quantity_Delivery_In_WAFER_Form__c = '12';
        mpwPrimeDie1.Address2_ShortLoop_Wafer__c = '4';
        mpwPrimeDie1.Metal_Stack__c = 'Test';
        mpwPrimeDie1.Corner_Split__c = 'Yes';
        mpwPrimeDie1.FF__c = '0';
        mpwPrimeDie1.FS__c = '';
        mpwPrimeDie1.POR__c = '100';
        mpwPrimeDie1.SF__c = '';
        mpwPrimeDie1.SS__c = '';
        mpwPrimeDie1.Wafer_FF__c = '';
        mpwPrimeDie1.Wafer_FS__c = '';
        mpwPrimeDie1.Wafer_POR__c = '1';
        mpwPrimeDie1.Wafer_SF__c = '';
        mpwPrimeDie1.Wafer_SS__c = '';
        mpwPrimeDie1.GMPL_Purpose__c = null;
        mpwPrimeDie1.ShortLoop_Wafer__c = '4';
        mpwPrimeDie1.Sub_Devices_Extraction__c = '0';
        mpwPrimeDie1.Backgrind__c = 'None';
        mpwPrimeDie1.Expedite_In_DIE_Form__c = '100';
        mpwPrimeDie1.Expedite_In_WAFER_Form__c = '5';
        mpwPrimeDie1.Turnkey_Service__c = 'No';
        insert mpwPrimeDie1;
        return mpwPrimeDie1;
    }
    
    private static MPW_Prime_Die__c utilDataPDMethod11(MPW_Reservation__c mpwReservation1) {
        MPW_Prime_Die__c mpwPrimeDie1 = new MPW_Prime_Die__c();
        mpwPrimeDie1.Prime_Die_Name__c = 'TestComapre2';
        mpwPrimeDie1.MPW_Form__c = mpwReservation1.Id;
        mpwPrimeDie1.Drawn_Die_Size_X_um__c = null;
        mpwPrimeDie1.Drawn_Die_Size_Y_um__c = null;
        mpwPrimeDie1.Device_Type__c = 'None';
        mpwPrimeDie1.Delivery_Qty_Die_Form__c = '100';
        mpwPrimeDie1.Delivery_Qty_Wafer_Form__c = '0';
        mpwPrimeDie1.Drawn_Orientation_Restricted_Structures__c= 'Test';
        mpwPrimeDie1.Address2_Quantity_Delivery_In_DIE_Form__c = '100';
        mpwPrimeDie1.Address2_Quantity_Delivery_In_WAFER_Form__c = '0';
        mpwPrimeDie1.Address2_ShortLoop_Wafer__c = '4';
        mpwPrimeDie1.Metal_Stack__c = 'Test';
        mpwPrimeDie1.Corner_Split__c = 'Yes';
        mpwPrimeDie1.FF__c = '50';
        mpwPrimeDie1.FS__c = '';
        mpwPrimeDie1.POR__c = '50';
        mpwPrimeDie1.SF__c = '';
        mpwPrimeDie1.SS__c = '';
        mpwPrimeDie1.Wafer_FF__c = '';
        mpwPrimeDie1.Wafer_FS__c = '';
        mpwPrimeDie1.Wafer_POR__c = '';
        mpwPrimeDie1.Wafer_SF__c = '';
        mpwPrimeDie1.Wafer_SS__c = '';
        mpwPrimeDie1.GMPL_Purpose__c = null;
        mpwPrimeDie1.ShortLoop_Wafer__c = '4';
        mpwPrimeDie1.Sub_Devices_Extraction__c = '0';
        mpwPrimeDie1.Backgrind__c = 'None';
        mpwPrimeDie1.Expedite_In_DIE_Form__c = '100';
        mpwPrimeDie1.Expedite_In_WAFER_Form__c = '5';
        mpwPrimeDie1.Turnkey_Service__c = 'No';
        insert mpwPrimeDie1;
        return mpwPrimeDie1;
    }
    
    private static MPW_Prime_Die__c utilDataPDMethod12(MPW_Reservation__c mpwReservation1) {
        MPW_Prime_Die__c mpwPrimeDie1 = new MPW_Prime_Die__c();
        mpwPrimeDie1.Prime_Die_Name__c = 'TestComapre2';
        mpwPrimeDie1.MPW_Form__c = mpwReservation1.Id;
        mpwPrimeDie1.Drawn_Die_Size_X_um__c = null;
        mpwPrimeDie1.Drawn_Die_Size_Y_um__c = null;
        mpwPrimeDie1.Device_Type__c = 'None';
        mpwPrimeDie1.Delivery_Qty_Die_Form__c = '0';
        mpwPrimeDie1.Delivery_Qty_Wafer_Form__c = '12';
        mpwPrimeDie1.Drawn_Orientation_Restricted_Structures__c= 'Test';
        mpwPrimeDie1.Address2_Quantity_Delivery_In_DIE_Form__c = '0';
        mpwPrimeDie1.Address2_Quantity_Delivery_In_WAFER_Form__c = '12';
        mpwPrimeDie1.Address2_ShortLoop_Wafer__c = '4';
        mpwPrimeDie1.Metal_Stack__c = 'Test';
        mpwPrimeDie1.Corner_Split__c = 'Yes';
        mpwPrimeDie1.FF__c = '';
        mpwPrimeDie1.FS__c = '';
        mpwPrimeDie1.POR__c = '';
        mpwPrimeDie1.SF__c = '';
        mpwPrimeDie1.SS__c = '';
        mpwPrimeDie1.Wafer_FF__c = '5';
        mpwPrimeDie1.Wafer_FS__c = '';
        mpwPrimeDie1.Wafer_POR__c = '5';
        mpwPrimeDie1.Wafer_SF__c = '';
        mpwPrimeDie1.Wafer_SS__c = '2';
        mpwPrimeDie1.GMPL_Purpose__c = null;
        mpwPrimeDie1.ShortLoop_Wafer__c = '4';
        mpwPrimeDie1.Sub_Devices_Extraction__c = '0';
        mpwPrimeDie1.Backgrind__c = 'None';
        mpwPrimeDie1.Expedite_In_DIE_Form__c = '100';
        mpwPrimeDie1.Expedite_In_WAFER_Form__c = '5';
        mpwPrimeDie1.Turnkey_Service__c = 'No';
        insert mpwPrimeDie1;
        return mpwPrimeDie1;
    }
    
    private static MPW_Prime_Die__c utilDataPDMethod13(MPW_Reservation__c mpwReservation1) {
        MPW_Prime_Die__c mpwPrimeDie1 = new MPW_Prime_Die__c();
        mpwPrimeDie1.Prime_Die_Name__c = 'TestComapre2';
        mpwPrimeDie1.MPW_Form__c = mpwReservation1.Id;
        mpwPrimeDie1.Drawn_Die_Size_X_um__c = null;
        mpwPrimeDie1.Drawn_Die_Size_Y_um__c = null;
        mpwPrimeDie1.Device_Type__c = 'None';
        mpwPrimeDie1.Delivery_Qty_Die_Form__c = '100';
        mpwPrimeDie1.Delivery_Qty_Wafer_Form__c = '0';
        mpwPrimeDie1.Drawn_Orientation_Restricted_Structures__c= 'Test';
        mpwPrimeDie1.Address2_Quantity_Delivery_In_DIE_Form__c = '100';
        mpwPrimeDie1.Address2_Quantity_Delivery_In_WAFER_Form__c = '0';
        mpwPrimeDie1.Address2_ShortLoop_Wafer__c = '4';
        mpwPrimeDie1.Metal_Stack__c = 'Test';
        mpwPrimeDie1.Corner_Split__c = 'Yes';
        mpwPrimeDie1.FF__c = '50';
        mpwPrimeDie1.FS__c = '';
        mpwPrimeDie1.POR__c = '50';
        mpwPrimeDie1.SF__c = '';
        mpwPrimeDie1.SS__c = '';
        mpwPrimeDie1.Wafer_FF__c = '';
        mpwPrimeDie1.Wafer_FS__c = '';
        mpwPrimeDie1.Wafer_POR__c = '';
        mpwPrimeDie1.Wafer_SF__c = '';
        mpwPrimeDie1.Wafer_SS__c = '';
        mpwPrimeDie1.GMPL_Purpose__c = null;
        mpwPrimeDie1.ShortLoop_Wafer__c = '4';
        mpwPrimeDie1.Sub_Devices_Extraction__c = '0';
        mpwPrimeDie1.Backgrind__c = 'None';
        mpwPrimeDie1.Expedite_In_DIE_Form__c = '100';
        mpwPrimeDie1.Expedite_In_WAFER_Form__c = '0';
        mpwPrimeDie1.Turnkey_Service__c = 'No';
        insert mpwPrimeDie1;
        return mpwPrimeDie1;
    }
    
    private static MPW_Turnkey__c utilDataTurnkeyMethod(MPW_Reservation__c mpwReservation1, MPW_Prime_Die__c mpwPrimeDie1) {
        MPW_Turnkey__c mpwTurnkey = new MPW_Turnkey__c();
        mpwTurnkey.MPW_Reservation__c = mpwReservation1.Id;
        mpwTurnkey.MPW_Prime_Die__c = mpwPrimeDie1.Id;
        mpwTurnkey.Ship_Date__c = System.today() + 5;
        mpwTurnkey.Wafer_Ship_Date__c = System.today() + 7;
        mpwTurnkey.AWB__c = 'Testing';
        mpwTurnkey.Actual_Wafer_Skeleton_Return_Date__c = System.today() + 3;
        mpwTurnkey.Expected_Wafer_Skeleton_Return_Date__c = System.today() + 2;
        insert mpwTurnkey;
        
        return mpwTurnkey;
    }
    
    public static testMethod void myReservationFormContMethod() {
        MPW_Geometry_Mapping__c mpwGeoMap = utilDataGMMethod();
        MPW_Config_Settings__c mpwConfig = utilDataCSMethod();
        MPW_SRAM_Configuration__c mpwSRAMConfig = utilDataSRMCMethod(mpwConfig); 
        MPW_ERP_PA_Code__c mpwPACode = utilDataPAMethod();
        MPW_Tech_Module__c mpwTechModule = utilDataTeMMethod();
        MPW_Train_Maintenance__c mpwTrainMaintenance = utilDataTMMethod();   
        MPW_Train_Maintenance_Details__c mpwTrainDetails = utilDataTMDMethod(mpwTechModule, mpwTrainMaintenance, mpwConfig);   
		
        MPW_Reservation__c mpwReservation1 = new MPW_Reservation__c();        
        mpwReservation1.MPW_Train_Name__c = mpwTrainMaintenance.Id;
        mpwReservation1.Name = '2015-03-05600';
        mpwReservation1.Form_Status__c = 'Draft';
        mpwReservation1.Category__c = 'FAB';
        mpwReservation1.Usage__c = 'Required';
        mpwReservation1.Prime_Die_Name__c = 'TestComapre1';
        mpwReservation1.Reason_to_Void__c = 'Not Required';
        mpwReservation1.PA_Code__c = 'RDY67219';
        mpwReservation1.Process_Type__c = mpwConfig.Id;
        insert mpwReservation1;
        
        MPW_Prime_Die__c mpwPrimeDie1 = utilDataPDMethod(mpwReservation1);
        MPW_Prime_Die__c mpwPrimeDie = utilDataPDMethod1(mpwReservation1);
        
        Test.startTest();
        
        Test.setCurrentPageReference(new PageReference('Page.MPWReservationFormVF'));
        System.currentPageReference().getParameters().put('voidtheform','true');
        System.currentPageReference().getParameters().put('mode', 'Edit');
        System.currentPageReference().getParameters().put('mpwId', mpwTrainMaintenance.Id);
        System.currentPageReference().getParameters().put('Clone', '1');
        System.currentPageReference().getParameters().put('Search', '1');
        System.currentPageReference().getParameters().put('ChangeRequest', '1');
        System.currentPageReference().getParameters().put('index', '1');
        
        MPWReservationFormController appMatrixClass = new MPWReservationFormController(new ApexPages.Standardcontroller(mpwReservation1));
        appMatrixClass.delRowToChipInformation();
        appMatrixClass.exitPreview();
        appMatrixClass.getProcesses();
        appMatrixClass.retrieveMPWTrainScheduleDetails();
        appMatrixClass.getMPWTrainMaintenanceDetailList();
        appMatrixClass.retrieveMPWSchedule();
        appMatrixClass.retreiveFormName();
		
        appMatrixClass.copy();
        
        Test.stopTest();
    }   
    
    public static testMethod void myReservationFormContMethod1() {
		MPW_Train_Maintenance__c mpwTrainMaintenance = utilDataTMMethod();  
		MPW_Geometry_Mapping__c mpwGeoMap = utilDataGMMethod();				
        MPW_Form_No_Generator__c mpwFormNo = utilDataFNGMethod();
		MPW_Approval_Matrix__c mpwApproval = utilDataAMMethod();	
		Account account = utilDataAccMethod();		
        List<Account_Team_Proxy__c> accountProxyList = utilDataAccPMethod(account, 12); 
		
        MPW_Reservation__c mpwReservation1 = new MPW_Reservation__c();        
        mpwReservation1.MPW_Train_Name__c = mpwTrainMaintenance.Id;
        mpwReservation1.Name = '2015-03-05600';
        mpwReservation1.Form_Status__c = 'Draft';
        mpwReservation1.Category__c = 'Customer';
        mpwReservation1.Usage__c = 'Required';
        mpwReservation1.Prime_Die_Name__c = 'TestComapre1';
		mpwReservation1.Customer_Company_Name__c = account.Id;
        insert mpwReservation1;
        
        MPW_Prime_Die__c mpwPrimeDie1 = utilDataPDMethod2(mpwReservation1);
        MPW_Config_Settings__c mpwConfig = utilDataCSMethod();
        MPW_Metal_Stack_Configuration__c mpwMetalStackCongig = utilDataMSMethod(mpwConfig);
        
        Test.startTest();
        
        Test.setCurrentPageReference(new PageReference('Page.MPWReservationFormVF'));
        
        MPWReservationFormController appMatrixClass = new MPWReservationFormController(new ApexPages.Standardcontroller(mpwReservation1));
        appMatrixClass.getProcesses();
        appMatrixClass.retriveMetalStackValues();
        appMatrixClass.saveAsDraft();
        appMatrixClass.voidformAction();
		
		/** Start : Added by Anil **/
		appMatrixClass.retreiveFormName();
		mpwFormNo.Last_Sequence_No__c = 11;
        update mpwFormNo;
		appMatrixClass.retreiveFormName();
		mpwFormNo.Last_Sequence_No__c = 111;
        update mpwFormNo;
		appMatrixClass.retreiveFormName();
		mpwFormNo.Last_Sequence_No__c = 1111;
        update mpwFormNo;
		appMatrixClass.retreiveFormName();
		mpwFormNo.Last_Sequence_No__c = 11111;
        update mpwFormNo;
		appMatrixClass.retreiveFormName();
		appMatrixClass.changeRequest();
		appMatrixClass.submitForApproval(); 
		appMatrixClass.retreiveApproversForChangeReq();
		/** End : Added by Anil **/
		
        Test.stopTest();
    }
	
	public static testMethod void myReservationFormContMethod1_1() {
		MPW_Train_Maintenance__c mpwTrainMaintenance = utilDataTMMethod();  
		MPW_Approval_Matrix__c mpwApproval = utilDataAMMethod();	
		Account account = utilDataAccMethod();		
        List<Account_Team_Proxy__c> accountProxyList = utilDataAccPMethod(account, 1); 
		
        MPW_Reservation__c mpwReservation1 = new MPW_Reservation__c();        
        mpwReservation1.MPW_Train_Name__c = mpwTrainMaintenance.Id;
        mpwReservation1.Name = '2015-03-05600';
        mpwReservation1.Form_Status__c = 'Draft';
        mpwReservation1.Category__c = 'Customer';
        mpwReservation1.Usage__c = 'Required';
        mpwReservation1.Prime_Die_Name__c = 'TestComapre1';
		mpwReservation1.Customer_Company_Name__c = account.Id;
        insert mpwReservation1;
        
        MPW_Prime_Die__c mpwPrimeDie1 = utilDataPDMethod2(mpwReservation1);
        
        Test.startTest();
        
        Test.setCurrentPageReference(new PageReference('Page.MPWReservationFormVF'));
        
        MPWReservationFormController appMatrixClass = new MPWReservationFormController(new ApexPages.Standardcontroller(mpwReservation1));
		
		appMatrixClass.submitForApproval(); 
		appMatrixClass.retreiveApproversForChangeReq();
		
        Test.stopTest();
    }
	
	public static testMethod void myReservationFormContMethod1_2() {
		MPW_Train_Maintenance__c mpwTrainMaintenance = utilDataTMMethod();  
		MPW_Approval_Matrix__c mpwApproval = utilDataAMMethod();	
		Account account = utilDataAccMethod();		
        List<Account_Team_Proxy__c> accountProxyList = utilDataAccPMethod(account, 2); 
		
        MPW_Reservation__c mpwReservation1 = new MPW_Reservation__c();        
        mpwReservation1.MPW_Train_Name__c = mpwTrainMaintenance.Id;
        mpwReservation1.Name = '2015-03-05600';
        mpwReservation1.Form_Status__c = 'Draft';
        mpwReservation1.Category__c = 'Customer';
        mpwReservation1.Usage__c = 'Required';
        mpwReservation1.Prime_Die_Name__c = 'TestComapre1';
		mpwReservation1.Customer_Company_Name__c = account.Id;
        insert mpwReservation1;
        
        MPW_Prime_Die__c mpwPrimeDie1 = utilDataPDMethod2(mpwReservation1);
        
        Test.startTest();
        
        Test.setCurrentPageReference(new PageReference('Page.MPWReservationFormVF'));
        
        MPWReservationFormController appMatrixClass = new MPWReservationFormController(new ApexPages.Standardcontroller(mpwReservation1));
		
		appMatrixClass.submitForApproval(); 
		appMatrixClass.retreiveApproversForChangeReq();
		
        Test.stopTest();
    }
	
	public static testMethod void myReservationFormContMethod1_3() {
		MPW_Train_Maintenance__c mpwTrainMaintenance = utilDataTMMethod();  
		MPW_Approval_Matrix__c mpwApproval = utilDataAMMethod();	
		Account account = utilDataAccMethod();		
        List<Account_Team_Proxy__c> accountProxyList = utilDataAccPMethod(account, 3); 
		
        MPW_Reservation__c mpwReservation1 = new MPW_Reservation__c();        
        mpwReservation1.MPW_Train_Name__c = mpwTrainMaintenance.Id;
        mpwReservation1.Name = '2015-03-05600';
        mpwReservation1.Form_Status__c = 'Draft';
        mpwReservation1.Category__c = 'Customer';
        mpwReservation1.Usage__c = 'Required';
        mpwReservation1.Prime_Die_Name__c = 'TestComapre1';
		mpwReservation1.Customer_Company_Name__c = account.Id;
        insert mpwReservation1;
        
        MPW_Prime_Die__c mpwPrimeDie1 = utilDataPDMethod2(mpwReservation1);
        
        Test.startTest();
        
        Test.setCurrentPageReference(new PageReference('Page.MPWReservationFormVF'));
        
        MPWReservationFormController appMatrixClass = new MPWReservationFormController(new ApexPages.Standardcontroller(mpwReservation1));
		
		appMatrixClass.submitForApproval(); 
		appMatrixClass.retreiveApproversForChangeReq();
		
        Test.stopTest();
    }
	
	public static testMethod void myReservationFormContMethod1_4() {
		MPW_Train_Maintenance__c mpwTrainMaintenance = utilDataTMMethod();  
		MPW_Approval_Matrix__c mpwApproval = utilDataAMMethod();	
		Account account = utilDataAccMethod();		
        List<Account_Team_Proxy__c> accountProxyList = utilDataAccPMethod(account, 4); 
		
        MPW_Reservation__c mpwReservation1 = new MPW_Reservation__c();        
        mpwReservation1.MPW_Train_Name__c = mpwTrainMaintenance.Id;
        mpwReservation1.Name = '2015-03-05600';
        mpwReservation1.Form_Status__c = 'Draft';
        mpwReservation1.Category__c = 'Customer';
        mpwReservation1.Usage__c = 'Required';
        mpwReservation1.Prime_Die_Name__c = 'TestComapre1';
		mpwReservation1.Customer_Company_Name__c = account.Id;
        insert mpwReservation1;
        
        MPW_Prime_Die__c mpwPrimeDie1 = utilDataPDMethod2(mpwReservation1);
        
        Test.startTest();
        
        Test.setCurrentPageReference(new PageReference('Page.MPWReservationFormVF'));
        
        MPWReservationFormController appMatrixClass = new MPWReservationFormController(new ApexPages.Standardcontroller(mpwReservation1));
		
		appMatrixClass.submitForApproval(); 
		appMatrixClass.retreiveApproversForChangeReq();
		
        Test.stopTest();
    }
	
	public static testMethod void myReservationFormContMethod1_5() {
		MPW_Train_Maintenance__c mpwTrainMaintenance = utilDataTMMethod();  
		MPW_Approval_Matrix__c mpwApproval = utilDataAMMethod();	
		Account account = utilDataAccMethod();		
        List<Account_Team_Proxy__c> accountProxyList = utilDataAccPMethod(account, 5); 
		
        MPW_Reservation__c mpwReservation1 = new MPW_Reservation__c();        
        mpwReservation1.MPW_Train_Name__c = mpwTrainMaintenance.Id;
        mpwReservation1.Name = '2015-03-05600';
        mpwReservation1.Form_Status__c = 'Draft';
        mpwReservation1.Category__c = 'Customer';
        mpwReservation1.Usage__c = 'Required';
        mpwReservation1.Prime_Die_Name__c = 'TestComapre1';
		mpwReservation1.Customer_Company_Name__c = account.Id;
        insert mpwReservation1;
        
        MPW_Prime_Die__c mpwPrimeDie1 = utilDataPDMethod2(mpwReservation1);
        
        Test.startTest();
        
        Test.setCurrentPageReference(new PageReference('Page.MPWReservationFormVF'));
        
        MPWReservationFormController appMatrixClass = new MPWReservationFormController(new ApexPages.Standardcontroller(mpwReservation1));
		
		appMatrixClass.submitForApproval(); 
		appMatrixClass.retreiveApproversForChangeReq();
		
        Test.stopTest();
    }
	
	public static testMethod void myReservationFormContMethod1_6() {
		MPW_Train_Maintenance__c mpwTrainMaintenance = utilDataTMMethod();  
		MPW_Approval_Matrix__c mpwApproval = utilDataAMMethod();	
		Account account = utilDataAccMethod();		
        List<Account_Team_Proxy__c> accountProxyList = utilDataAccPMethod(account, 6); 
		
        MPW_Reservation__c mpwReservation1 = new MPW_Reservation__c();        
        mpwReservation1.MPW_Train_Name__c = mpwTrainMaintenance.Id;
        mpwReservation1.Name = '2015-03-05600';
        mpwReservation1.Form_Status__c = 'Draft';
        mpwReservation1.Category__c = 'Customer';
        mpwReservation1.Usage__c = 'Required';
        mpwReservation1.Prime_Die_Name__c = 'TestComapre1';
		mpwReservation1.Customer_Company_Name__c = account.Id;
        insert mpwReservation1;
        
        MPW_Prime_Die__c mpwPrimeDie1 = utilDataPDMethod2(mpwReservation1);
        
        Test.startTest();
        
        Test.setCurrentPageReference(new PageReference('Page.MPWReservationFormVF'));
        
        MPWReservationFormController appMatrixClass = new MPWReservationFormController(new ApexPages.Standardcontroller(mpwReservation1));
		
		appMatrixClass.submitForApproval(); 
		appMatrixClass.retreiveApproversForChangeReq();
		
        Test.stopTest();
    }
	
	public static testMethod void myReservationFormContMethod1_7() {
		MPW_Train_Maintenance__c mpwTrainMaintenance = utilDataTMMethod();  
		MPW_Approval_Matrix__c mpwApproval = utilDataAMMethod();	
		Account account = utilDataAccMethod();		
        List<Account_Team_Proxy__c> accountProxyList = utilDataAccPMethod(account, 7); 
		
        MPW_Reservation__c mpwReservation1 = new MPW_Reservation__c();        
        mpwReservation1.MPW_Train_Name__c = mpwTrainMaintenance.Id;
        mpwReservation1.Name = '2015-03-05600';
        mpwReservation1.Form_Status__c = 'Draft';
        mpwReservation1.Category__c = 'Customer';
        mpwReservation1.Usage__c = 'Required';
        mpwReservation1.Prime_Die_Name__c = 'TestComapre1';
		mpwReservation1.Customer_Company_Name__c = account.Id;
        insert mpwReservation1;
        
        MPW_Prime_Die__c mpwPrimeDie1 = utilDataPDMethod2(mpwReservation1);
        
        Test.startTest();
        
        Test.setCurrentPageReference(new PageReference('Page.MPWReservationFormVF'));
        
        MPWReservationFormController appMatrixClass = new MPWReservationFormController(new ApexPages.Standardcontroller(mpwReservation1));
		
		appMatrixClass.submitForApproval(); 
		appMatrixClass.retreiveApproversForChangeReq();
		
        Test.stopTest();
    }
	
	public static testMethod void myReservationFormContMethod1_8() {
		MPW_Train_Maintenance__c mpwTrainMaintenance = utilDataTMMethod();  
		MPW_Approval_Matrix__c mpwApproval = utilDataAMMethod();	
		Account account = utilDataAccMethod();		
        List<Account_Team_Proxy__c> accountProxyList = utilDataAccPMethod(account, 8); 
		
        MPW_Reservation__c mpwReservation1 = new MPW_Reservation__c();        
        mpwReservation1.MPW_Train_Name__c = mpwTrainMaintenance.Id;
        mpwReservation1.Name = '2015-03-05600';
        mpwReservation1.Form_Status__c = 'Draft';
        mpwReservation1.Category__c = 'Customer';
        mpwReservation1.Usage__c = 'Required';
        mpwReservation1.Prime_Die_Name__c = 'TestComapre1';
		mpwReservation1.Customer_Company_Name__c = account.Id;
        insert mpwReservation1;
        
        MPW_Prime_Die__c mpwPrimeDie1 = utilDataPDMethod2(mpwReservation1);
        
        Test.startTest();
        
        Test.setCurrentPageReference(new PageReference('Page.MPWReservationFormVF'));
        
        MPWReservationFormController appMatrixClass = new MPWReservationFormController(new ApexPages.Standardcontroller(mpwReservation1));
		
		appMatrixClass.submitForApproval(); 
		appMatrixClass.retreiveApproversForChangeReq();
		
        Test.stopTest();
    }
	
	public static testMethod void myReservationFormContMethod1_9() {
		MPW_Train_Maintenance__c mpwTrainMaintenance = utilDataTMMethod();  
		MPW_Approval_Matrix__c mpwApproval = utilDataAMMethod();	
		Account account = utilDataAccMethod();		
        List<Account_Team_Proxy__c> accountProxyList = utilDataAccPMethod(account, 9); 
		
        MPW_Reservation__c mpwReservation1 = new MPW_Reservation__c();        
        mpwReservation1.MPW_Train_Name__c = mpwTrainMaintenance.Id;
        mpwReservation1.Name = '2015-03-05600';
        mpwReservation1.Form_Status__c = 'Draft';
        mpwReservation1.Category__c = 'Customer';
        mpwReservation1.Usage__c = 'Required';
        mpwReservation1.Prime_Die_Name__c = 'TestComapre1';
		mpwReservation1.Customer_Company_Name__c = account.Id;
        insert mpwReservation1;
        
        MPW_Prime_Die__c mpwPrimeDie1 = utilDataPDMethod2(mpwReservation1);
        
        Test.startTest();
        
        Test.setCurrentPageReference(new PageReference('Page.MPWReservationFormVF'));
        
        MPWReservationFormController appMatrixClass = new MPWReservationFormController(new ApexPages.Standardcontroller(mpwReservation1));
		
		appMatrixClass.submitForApproval(); 
		appMatrixClass.retreiveApproversForChangeReq();
		
        Test.stopTest();
    }
    
    public static testMethod void myReservationFormContMethod2() {
       
        MPW_Train_Maintenance__c mpwTrainMaintenance = utilDataTMMethod(); 
        MPW_Config_Settings__c mpwConfig = utilDataCSMethod();  
		MPW_Approval_Matrix__c mpwApproval = utilDataAMMethod();		
		
        MPW_Reservation__c mpwReservation1 = new MPW_Reservation__c();        
        mpwReservation1.MPW_Train_Name__c = mpwTrainMaintenance.Id;
        mpwReservation1.Name = '2015-03-05600';
        mpwReservation1.Form_Status__c = 'Draft';
        mpwReservation1.Category__c = 'FAB';
        mpwReservation1.Usage__c = 'Required';
        mpwReservation1.Prime_Die_Name__c = 'TestComapre1';
        insert mpwReservation1;
        
        MPW_Prime_Die__c mpwPrimeDie1 = utilDataPDMethod(mpwReservation1);
        
        Test.startTest();
        
        Test.setCurrentPageReference(new PageReference('Page.MPWReservationFormVF'));
        System.currentPageReference().getParameters().put('mode', 'View');
        
        MPWReservationFormController appMatrixClass = new MPWReservationFormController(new ApexPages.Standardcontroller(mpwReservation1));
		appMatrixClass.submitForApproval(); //Added by Anil
		appMatrixClass.back();	//Added by Anil
		
        Test.stopTest();
    }
    
    //Added by Kanishk
      public static testMethod void myReservationFormForPortalUser() {
      	
      	 List<User> userAppMatrix = [select Id from User where Profile.Name = 'GF PIYE Platform' and isActive = true limit 13];
      	
      	Account account = utilDataAccMethod();
        Account account2 = utilDataAccMethod2(account);
        Contact con = utilDataConMethod(account);
        User objUser = utilDataUserMethod(con);
       
        MPW_Train_Maintenance__c mpwTrainMaintenance = utilDataTMMethod(); 
        MPW_Config_Settings__c mpwConfig = utilDataCSMethod();  
		MPW_Approval_Matrix__c mpwApproval = utilDataAMMethod();		
		//utilDataKCMethod();
	
	 Test.startTest();
		
        MPW_Reservation__c mpwReservation1 = new MPW_Reservation__c();        
        mpwReservation1.MPW_Train_Name__c = mpwTrainMaintenance.Id;
        mpwReservation1.Name = '2015-03-05600';
        mpwReservation1.Form_Status__c = 'Draft';
        mpwReservation1.Category__c = 'FAB';
        mpwReservation1.Usage__c = 'Required';
        mpwReservation1.Prime_Die_Name__c = 'TestComapre1';
        mpwReservation1.FE_Name__c = userAppMatrix[0].Id;
        mpwReservation1.CSR_Name__c = userAppMatrix[1].Id;
        mpwReservation1.AM_Name__c = userAppMatrix[2].Id;
        mpwReservation1.Step_1_Approver_1__c = userAppMatrix[3].Id;
        mpwReservation1.Step_1_Approver_2__c = userAppMatrix[4].Id;
        mpwReservation1.Step_1_Approver_3__c = userAppMatrix[5].Id;
        mpwReservation1.Step_1_Approver_4__c = userAppMatrix[6].Id;
        mpwReservation1.Step_1_Approver_5__c = userAppMatrix[7].Id;
        mpwReservation1.Step_1_Approver_6__c = userAppMatrix[8].Id;
        mpwReservation1.Step_1_Approver_7__c = userAppMatrix[9].Id;
        mpwReservation1.Step_1_Approver_8__c = userAppMatrix[10].Id;
        mpwReservation1.Step_1_Approver_9__c = userAppMatrix[11].Id;
        mpwReservation1.Step_1_Approver_10__c = userAppMatrix[12].Id;
        insert mpwReservation1;
        
        MPW_Prime_Die__c mpwPrimeDie1 = utilDataPDMethod(mpwReservation1);
        
       
        
        Test.setCurrentPageReference(new PageReference('Page.MPWReservationFormVF'));
        System.currentPageReference().getParameters().put('mode', 'View');
        
       	system.runAs(objUser){
			 MPWReservationFormController appMatrixClass = new MPWReservationFormController(new ApexPages.Standardcontroller(mpwReservation1));
		}
		
        Test.stopTest();
      }
    
    
    
    public static testMethod void myReservationFormContMethod3() {
        List<MPW_Keyword_Config__c> mpwKeywordList = utilDataKCMethod();
        MPW_ERP_PA_Code__c mpwPACode = utilDataPAMethod();
        MPW_Train_Maintenance__c mpwTrainMaintenance = utilDataTMMethod();      
       
        Test.startTest();
        
        Test.setCurrentPageReference(new PageReference('Page.MPWReservationFormVF'));
        System.currentPageReference().getParameters().put('mpwId', mpwTrainMaintenance.Id);
        System.currentPageReference().getParameters().put('initPoint', 'mpwtrain');
        
        MPWReservationFormController appMatrixClass = new MPWReservationFormController(new ApexPages.Standardcontroller(new MPW_Reservation__c()));
        appMatrixClass.mpwResf.Category__c = 'DE';
        appMatrixClass.back();
        appMatrixClass.saveAsDraft();
        appMatrixClass.retrieveSubCategoryAndUsage();
        
        Test.stopTest();
    } 
    
    public static testMethod void myReservationFormContMethod4() {
        List<MPW_Keyword_Config__c> mpwKeywordList = utilDataKCMethod();
        MPW_ERP_PA_Code__c mpwPACode = utilDataPAMethod();
        MPW_Train_Maintenance__c mpwTrainMaintenance = utilDataTMMethod();      
       
        Test.startTest();
        
        Test.setCurrentPageReference(new PageReference('Page.MPWReservationFormVF'));
        System.currentPageReference().getParameters().put('mpwId', mpwTrainMaintenance.Id);
        
        MPWReservationFormController appMatrixClass = new MPWReservationFormController(new ApexPages.Standardcontroller(new MPW_Reservation__c()));
        appMatrixClass.mpwResf.Category__c = 'TD';
        appMatrixClass.saveAsDraft();
        appMatrixClass.retrieveSubCategoryAndUsage();
        
        Test.stopTest();
    }   
    
    public static testMethod void myReservationFormContMethod5() {
        List<MPW_Keyword_Config__c> mpwKeywordList = utilDataKCMethod();
        MPW_ERP_PA_Code__c mpwPACode = utilDataPAMethod();
        MPW_Train_Maintenance__c mpwTrainMaintenance = utilDataTMMethod();      
       
        Test.startTest();
        
        Test.setCurrentPageReference(new PageReference('Page.MPWReservationFormVF'));
        System.currentPageReference().getParameters().put('mpwId', mpwTrainMaintenance.Id);
        
        MPWReservationFormController appMatrixClass = new MPWReservationFormController(new ApexPages.Standardcontroller(new MPW_Reservation__c()));
        appMatrixClass.mpwResf.Category__c = 'IP';
        appMatrixClass.saveAsDraft();
        appMatrixClass.retrieveSubCategoryAndUsage();
        
        Test.stopTest();
    } 

	public static testMethod void myReservationFormContMethod6() {
        Account account = utilDataAccMethod();
        Account account2 = utilDataAccMethod2(account);
        Contact con = utilDataConMethod(account);
        User u = utilDataUserMethod(con);
        MPW_Train_Maintenance__c mpwTrainMaintenance = utilDataTMMethod();     
        MPW_Train_Account__c mpwTrainAccount = utilDataTAMethod(account, mpwTrainMaintenance);
        MPW_Train_Account__c mpwTrainAccount1 = utilDataTAMethod(account2, mpwTrainMaintenance); 
        
        MPW_Reservation__c mpwReservation1 = new MPW_Reservation__c();        
        mpwReservation1.MPW_Train_Name__c = mpwTrainMaintenance.Id;
        mpwReservation1.Name = '2015-03-05600';
        mpwReservation1.Form_Status__c = 'Draft';
        mpwReservation1.Category__c = 'Customer';
        mpwReservation1.Usage__c = 'Required';
        mpwReservation1.Prime_Die_Name__c = 'TestComapre1';
        mpwReservation1.Customer_Company_Name__c = account.Id;
        Test.startTest();
        insert mpwReservation1;
        
        MPW_Prime_Die__c mpwPrimeDie1 = utilDataPDMethod(mpwReservation1);
        
        Test.setCurrentPageReference(new PageReference('Page.MPWReservationFormVF'));
        
        System.runAs(u){
            MPWReservationFormController appMatrixClass = new MPWReservationFormController(new ApexPages.Standardcontroller(mpwReservation1));
        }
        
        Test.stopTest();
    }
    
    public static testMethod void myReservationFormContMethod7() {
        List<User> userAppMatrix = [select Id from User where Profile.Name = 'GF PIYE Platform' and isActive = true limit 3];
        
        MPW_Train_Maintenance__c mpwTrainMaintenance = utilDataTMMethod(); 
        MPW_Config_Settings__c mpwConfig = utilDataCSMethod();     
        
        MPW_Reservation__c mpwReservation1 = new MPW_Reservation__c();        
        mpwReservation1.MPW_Train_Name__c = mpwTrainMaintenance.Id;
        mpwReservation1.Name = '2015-03-05600';
        mpwReservation1.Form_Status__c = 'Pending FAE Review';
        mpwReservation1.Category__c = 'Customer';
        mpwReservation1.Usage__c = 'Required';
        mpwReservation1.Prime_Die_Name__c = 'TestComapre1';
        insert mpwReservation1;
        
        MPW_Prime_Die__c mpwPrimeDie1 = utilDataPDMethod(mpwReservation1);
        
        Test.startTest();
        
        Test.setCurrentPageReference(new PageReference('Page.MPWReservationFormVF'));
        System.currentPageReference().getParameters().put('mode', 'View');
        
        System.runAs(userAppMatrix[2]){
            MPWReservationFormController appMatrixClass = new MPWReservationFormController(new ApexPages.Standardcontroller(mpwReservation1));
        }
        Test.stopTest();
    }
    
    public static testMethod void myReservationFormContMethod8() {
        List<User> userAppMatrix = [select Id from User where Profile.Name = 'GF PIYE Platform' and isActive = true limit 3];
        
        MPW_Train_Maintenance__c mpwTrainMaintenance = utilDataTMMethod(); 
        MPW_Config_Settings__c mpwConfig = utilDataCSMethod();     
        
        MPW_Reservation__c mpwReservation1 = new MPW_Reservation__c();        
        mpwReservation1.MPW_Train_Name__c = mpwTrainMaintenance.Id;
        mpwReservation1.Name = '2015-03-05600';
        mpwReservation1.Form_Status__c = 'Accepted by MPW Tapeout';
        mpwReservation1.Category__c = 'Customer';
        mpwReservation1.Usage__c = 'Required';
        mpwReservation1.Prime_Die_Name__c = 'TestComapre1';
        insert mpwReservation1;
        
        MPW_Prime_Die__c mpwPrimeDie1 = utilDataPDMethod(mpwReservation1);
        
        Test.startTest();
        
        Test.setCurrentPageReference(new PageReference('Page.MPWReservationFormVF'));
        System.currentPageReference().getParameters().put('mode', 'View');
        
        System.runAs(userAppMatrix[2]){
            MPWReservationFormController appMatrixClass = new MPWReservationFormController(new ApexPages.Standardcontroller(mpwReservation1));
        }
        Test.stopTest();
    }
    
    public static testMethod void myReservationFormContMethod9() {
        List<User> userAppMatrix = [select Id from User where Profile.Name = 'GF PIYE Platform' and isActive = true limit 3];
         List<MPW_Keyword_Config__c> mpwKeywordList = utilDataKCMethod();
         
        MPW_Train_Maintenance__c mpwTrainMaintenance = utilDataTMMethod(); 
        MPW_Config_Settings__c mpwConfig = utilDataCSMethod();     
        
        MPW_Reservation__c mpwReservation1 = new MPW_Reservation__c();        
        mpwReservation1.MPW_Train_Name__c = mpwTrainMaintenance.Id;
        mpwReservation1.Name = '2015-03-05600';
        mpwReservation1.Form_Status__c = 'Pending FAE Review';
        mpwReservation1.Category__c = 'Customer';
        mpwReservation1.Usage__c = 'Required';
        mpwReservation1.Prime_Die_Name__c = 'TestComapre1';
        insert mpwReservation1;
        
        MPW_Prime_Die__c mpwPrimeDie1 = utilDataPDMethod(mpwReservation1);
        
        Test.startTest();
		MPWGeometry__c MPWGeo=new MPWGeometry__c();
		MPWGeo.Geometry__c='14nm LPE,14nm LPP,14nm LPP 1407,22nm eMRAM,22nm FDSOI,22nm FDX,28nm SLP';
		Insert MPWGeo;
		
        Test.setCurrentPageReference(new PageReference('Page.MPWReservationFormVF'));
        System.currentPageReference().getParameters().put('mode', 'Edit');
        
        System.runAs(userAppMatrix[2]){
            MPWReservationFormController appMatrixClass = new MPWReservationFormController(new ApexPages.Standardcontroller(mpwReservation1));
        }
        Test.stopTest();
    }
    
    public static testMethod void myReservationFormContMethod10() {
        List<User> userAppMatrix = [select Id from User where Profile.Name = 'GF PIYE Platform' and isActive = true limit 3];
        
        MPW_Train_Maintenance__c mpwTrainMaintenance = utilDataTMMethod(); 
        MPW_Config_Settings__c mpwConfig = utilDataCSMethod();     
        
        MPW_Reservation__c mpwReservation1 = new MPW_Reservation__c();        
        mpwReservation1.MPW_Train_Name__c = mpwTrainMaintenance.Id;
        mpwReservation1.Name = '2015-03-05600';
        mpwReservation1.Form_Status__c = 'Accepted by MPW Tapeout';
        mpwReservation1.Category__c = 'Customer';
        mpwReservation1.Usage__c = 'Required';
        mpwReservation1.Prime_Die_Name__c = 'TestComapre1';
        insert mpwReservation1;
        
        MPW_Prime_Die__c mpwPrimeDie1 = utilDataPDMethod(mpwReservation1);
        
        Test.startTest();
        
        Test.setCurrentPageReference(new PageReference('Page.MPWReservationFormVF'));
        System.currentPageReference().getParameters().put('mode', 'Edit');
        
        System.runAs(userAppMatrix[2]){
            MPWReservationFormController appMatrixClass = new MPWReservationFormController(new ApexPages.Standardcontroller(mpwReservation1));
        }
        Test.stopTest();
    }
    
    public static testMethod void myReservationFormContMethod11() {
        Account account = utilDataAccMethod();
        Account account1 = utilDataAccMethod1();
        MPW_Approval_Matrix__c mpwApproval = utilDataAMMethod();
        MPW_Geometry_Mapping__c mpwGeoMap = utilDataGMMethod();
        MPW_Config_Settings__c mpwConfig = utilDataCSMethod();
        MPW_SRAM_Configuration__c mpwSRAMConfig = utilDataSRMCMethod(mpwConfig); 
        MPW_ERP_PA_Code__c mpwPACode = utilDataPAMethod();
        MPW_Tech_Module__c mpwTechModule = utilDataTeMMethod();
        MPW_Train_Maintenance__c mpwTrainMaintenance = utilDataTMMethod();   
        MPW_Train_Maintenance_Details__c mpwTrainDetails = utilDataTMDMethod(mpwTechModule, mpwTrainMaintenance, mpwConfig);   
        
        MPW_Reservation__c mpwReservation1 = new MPW_Reservation__c();        
        mpwReservation1.MPW_Train_Name__c = mpwTrainMaintenance.Id;
        mpwReservation1.Name = '2015-03-05600';
        mpwReservation1.Form_Status__c = 'Draft';
        mpwReservation1.Category__c = 'FAB';
        mpwReservation1.Usage__c = 'Required';
        mpwReservation1.Prime_Die_Name__c = 'TestComapre1';
        mpwReservation1.Reason_to_Void__c = 'Not Required';
        mpwReservation1.PA_Code__c = 'RDY67219';
        mpwReservation1.Process_Type__c = mpwConfig.Id;
        mpwReservation1.Account_Internal__c = account1.Id;
        insert mpwReservation1;
        
        MPW_Prime_Die__c mpwPrimeDie = utilDataPDMethod(mpwReservation1);
        
        Test.startTest();
        
        Test.setCurrentPageReference(new PageReference('Page.MPWReservationFormVF'));
        System.currentPageReference().getParameters().put('mpwId', mpwTrainMaintenance.Id);

        MPWReservationFormController appMatrixClass = new MPWReservationFormController(new ApexPages.Standardcontroller(mpwReservation1));
        appMatrixClass.saveAsDraft();
        
        Test.stopTest();
    }
    
    public static testMethod void myReservationFormContMethod12() {
        Account account = utilDataAccMethod();
        Account account1 = utilDataAccMethod1();
        MPW_Approval_Matrix__c mpwApproval = utilDataAMMethod();
        MPW_Geometry_Mapping__c mpwGeoMap = utilDataGMMethod();
        MPW_Config_Settings__c mpwConfig = utilDataCSMethod();
        MPW_SRAM_Configuration__c mpwSRAMConfig = utilDataSRMCMethod(mpwConfig); 
        MPW_ERP_PA_Code__c mpwPACode = utilDataPAMethod();
        MPW_Tech_Module__c mpwTechModule = utilDataTeMMethod();
        MPW_Train_Maintenance__c mpwTrainMaintenance = utilDataTMMethod();   
        MPW_Train_Maintenance_Details__c mpwTrainDetails = utilDataTMDMethod(mpwTechModule, mpwTrainMaintenance, mpwConfig);   
        
        MPW_Reservation__c mpwReservation1 = new MPW_Reservation__c();        
        mpwReservation1.MPW_Train_Name__c = mpwTrainMaintenance.Id;
        mpwReservation1.Name = '2015-03-05600';
        mpwReservation1.Form_Status__c = 'Draft';
        mpwReservation1.Category__c = 'FAB';
        mpwReservation1.Usage__c = 'Opportunistic';
        mpwReservation1.Prime_Die_Name__c = 'TestComapre1';
        mpwReservation1.Reason_to_Void__c = 'Not Required';
        mpwReservation1.PA_Code__c = 'RDY67219';
        mpwReservation1.Process_Type__c = mpwConfig.Id;
        mpwReservation1.Account_Internal__c = account1.Id;
        insert mpwReservation1;
        
        MPW_Prime_Die__c mpwPrimeDie = utilDataPDMethod(mpwReservation1);
        
        Test.startTest();
        
        Test.setCurrentPageReference(new PageReference('Page.MPWReservationFormVF'));
        System.currentPageReference().getParameters().put('mpwId', mpwTrainMaintenance.Id);

        
        MPWReservationFormController appMatrixClass = new MPWReservationFormController(new ApexPages.Standardcontroller(mpwReservation1));
        appMatrixClass.saveAsDraft();
        
        Test.stopTest();
    }
    
    public static testMethod void myReservationFormContMethod13() {
        Account account = utilDataAccMethod();
        Account account1 = utilDataAccMethod1();
        MPW_Approval_Matrix__c mpwApproval = utilDataAMMethod();
        MPW_Geometry_Mapping__c mpwGeoMap = utilDataGMMethod();
        MPW_Config_Settings__c mpwConfig = utilDataCSMethod();
        MPW_SRAM_Configuration__c mpwSRAMConfig = utilDataSRMCMethod(mpwConfig); 
        MPW_ERP_PA_Code__c mpwPACode = utilDataPAMethod();
        MPW_Tech_Module__c mpwTechModule = utilDataTeMMethod();
        MPW_Train_Maintenance__c mpwTrainMaintenance = utilDataTMMethod1();   
        MPW_Train_Maintenance_Details__c mpwTrainDetails = utilDataTMDMethod(mpwTechModule, mpwTrainMaintenance, mpwConfig);   
        
        MPW_Reservation__c mpwReservation1 = new MPW_Reservation__c();        
        mpwReservation1.MPW_Train_Name__c = mpwTrainMaintenance.Id;
        mpwReservation1.Name = '2015-03-05600';
        mpwReservation1.Form_Status__c = 'Draft';
        mpwReservation1.Category__c = 'FAB';
        //mpwReservation1.Usage__c = 'Opportunistic';
        mpwReservation1.Prime_Die_Name__c = 'TestComapre1';
        mpwReservation1.Reason_to_Void__c = 'Not Required';
        mpwReservation1.PA_Code__c = 'RDY67219';
        mpwReservation1.Process_Type__c = mpwConfig.Id;
        mpwReservation1.Account_Internal__c = account1.Id;
        insert mpwReservation1;
        
        MPW_Prime_Die__c mpwPrimeDie = utilDataPDMethod1(mpwReservation1);
        
        Test.startTest();
        
        Test.setCurrentPageReference(new PageReference('Page.MPWReservationFormVF'));
        System.currentPageReference().getParameters().put('mpwId', mpwTrainMaintenance.Id);

        
        MPWReservationFormController appMatrixClass = new MPWReservationFormController(new ApexPages.Standardcontroller(mpwReservation1));
        appMatrixClass.saveAsDraft();
        
        Test.stopTest();
    }
    
    public static testMethod void myReservationFormContMethod14() {
        Account account = utilDataAccMethod();
        Account account2 = utilDataAccMethod2(account);
        Contact con = utilDataConMethod(account);
        User u = utilDataUserMethod(con);
        MPW_Train_Maintenance__c mpwTrainMaintenance = utilDataTMMethod2();     
        
        MPW_Reservation__c mpwReservation1 = new MPW_Reservation__c();        
        mpwReservation1.MPW_Train_Name__c = mpwTrainMaintenance.Id;
        mpwReservation1.Name = '2015-03-05600';
        mpwReservation1.Form_Status__c = 'Draft';
        mpwReservation1.Category__c = 'Customer';
        mpwReservation1.Usage__c = 'Required';
        mpwReservation1.Prime_Die_Name__c = 'TestComapre1';
        mpwReservation1.Customer_Company_Name__c = account.Id;
        Test.startTest();
        insert mpwReservation1;
        
        MPW_Prime_Die__c mpwPrimeDie1 = utilDataPDMethod(mpwReservation1);
        
        Test.setCurrentPageReference(new PageReference('Page.MPWReservationFormVF'));
        System.currentPageReference().getParameters().put('Clone', '1');
        
        System.runAs(u){
        	 
            MPWReservationFormController appMatrixClass = new MPWReservationFormController(new ApexPages.Standardcontroller(mpwReservation1));
            appMatrixClass.saveAsDraft();
            
        }
        
        Test.stopTest();
    }
    
    public static testMethod void myReservationFormContMethod15() {
        Account account = utilDataAccMethod();
        MPW_Train_Maintenance__c mpwTrainMaintenance = utilDataTMMethod2();
        MPW_Train_Account__c mpwTrainAccount = utilDataTAMethod(account, mpwTrainMaintenance);
        List<Account_Team_Proxy__c> accountProxyList =utilDataAccPMethod(account, 12);    
        
        MPW_Reservation__c mpwReservation1 = new MPW_Reservation__c();        
        mpwReservation1.MPW_Train_Name__c = mpwTrainMaintenance.Id;
        mpwReservation1.Name = '2015-03-05600';
        mpwReservation1.Form_Status__c = 'Draft';
        mpwReservation1.Category__c = 'FAB';
        mpwReservation1.Usage__c = 'Required';
        mpwReservation1.Prime_Die_Name__c = 'TestComapre1';
        mpwReservation1.Customer_Company_Name__c = account.Id;
        insert mpwReservation1;
        
        MPW_Prime_Die__c mpwPrimeDie1 = utilDataPDMethod(mpwReservation1);
        
        Test.startTest();
        
        Test.setCurrentPageReference(new PageReference('Page.MPWReservationFormVF'));
        System.currentPageReference().getParameters().put('Clone', '1');
        
        MPWReservationFormController appMatrixClass = new MPWReservationFormController(new ApexPages.Standardcontroller(mpwReservation1));
        appMatrixClass.saveAsDraft();

        Test.stopTest();
    }
    
    public static testMethod void myReservationFormContMethod16() {
        MPW_Train_Maintenance__c mpwTrainMaintenance = utilDataTMMethod();      
        
        MPW_Reservation__c mpwReservation1 = new MPW_Reservation__c();        
        mpwReservation1.MPW_Train_Name__c = mpwTrainMaintenance.Id;
        mpwReservation1.Name = '2015-03-05600';
        mpwReservation1.Form_Status__c = 'Draft';
        mpwReservation1.Category__c = 'Customer';
        mpwReservation1.Usage__c = 'Required';
        mpwReservation1.Prime_Die_Name__c = 'TestComapre1';
        insert mpwReservation1;
        
        MPW_Prime_Die__c mpwPrimeDie1 = utilDataPDMethod3(mpwReservation1);
        
        Test.startTest();
        
        Test.setCurrentPageReference(new PageReference('Page.MPWReservationFormVF'));
        
        MPWReservationFormController appMatrixClass = new MPWReservationFormController(new ApexPages.Standardcontroller(mpwReservation1));
        appMatrixClass.getProcesses();
        appMatrixClass.saveAsDraft();
        
        Test.stopTest();
    }
    
    public static testMethod void myReservationFormContMethod17() {
        MPW_Train_Maintenance__c mpwTrainMaintenance = utilDataTMMethod();      
        
        MPW_Reservation__c mpwReservation1 = new MPW_Reservation__c();        
        mpwReservation1.MPW_Train_Name__c = mpwTrainMaintenance.Id;
        mpwReservation1.Name = '2015-03-05600';
        mpwReservation1.Form_Status__c = 'Draft';
        mpwReservation1.Category__c = 'Customer';
        mpwReservation1.Usage__c = 'Required';
        mpwReservation1.Prime_Die_Name__c = 'TestComapre1';
        insert mpwReservation1;
        
        MPW_Prime_Die__c mpwPrimeDie1 = utilDataPDMethod4(mpwReservation1);
        
        Test.startTest();
        
        Test.setCurrentPageReference(new PageReference('Page.MPWReservationFormVF'));
        
        MPWReservationFormController appMatrixClass = new MPWReservationFormController(new ApexPages.Standardcontroller(mpwReservation1));
        appMatrixClass.getProcesses();
        appMatrixClass.saveAsDraft();
        
        Test.stopTest();
    }
    
    public static testMethod void myReservationFormContMethod18() {
        MPW_Train_Maintenance__c mpwTrainMaintenance = utilDataTMMethod();      
        
        MPW_Reservation__c mpwReservation1 = new MPW_Reservation__c();        
        mpwReservation1.MPW_Train_Name__c = mpwTrainMaintenance.Id;
        mpwReservation1.Name = '2015-03-05600';
        mpwReservation1.Form_Status__c = 'Draft';
        mpwReservation1.Category__c = 'Customer';
        mpwReservation1.Usage__c = 'Required';
        mpwReservation1.Prime_Die_Name__c = 'TestComapre1';
        insert mpwReservation1;
        
        MPW_Prime_Die__c mpwPrimeDie1 = utilDataPDMethod5(mpwReservation1);
        
        Test.startTest();
        
        Test.setCurrentPageReference(new PageReference('Page.MPWReservationFormVF'));
        
        MPWReservationFormController appMatrixClass = new MPWReservationFormController(new ApexPages.Standardcontroller(mpwReservation1));
        appMatrixClass.getProcesses();
        appMatrixClass.saveAsDraft();
        
        Test.stopTest();
    }
    
    public static testMethod void myReservationFormContMethod19() {
        MPW_Train_Maintenance__c mpwTrainMaintenance = utilDataTMMethod();      
        
        MPW_Reservation__c mpwReservation1 = new MPW_Reservation__c();        
        mpwReservation1.MPW_Train_Name__c = mpwTrainMaintenance.Id;
        mpwReservation1.Name = '2015-03-05600';
        mpwReservation1.Form_Status__c = 'Draft';
        mpwReservation1.Category__c = 'Customer';
        mpwReservation1.Usage__c = 'Required';
        mpwReservation1.Prime_Die_Name__c = 'TestComapre1';
        insert mpwReservation1;
        
        MPW_Prime_Die__c mpwPrimeDie1 = utilDataPDMethod6(mpwReservation1);
        
        Test.startTest();
        
        Test.setCurrentPageReference(new PageReference('Page.MPWReservationFormVF'));
        
        MPWReservationFormController appMatrixClass = new MPWReservationFormController(new ApexPages.Standardcontroller(mpwReservation1));
        appMatrixClass.getProcesses();
        appMatrixClass.saveAsDraft();
        
        Test.stopTest();
    }
    
    public static testMethod void myReservationFormContMethod20() {
        MPW_Train_Maintenance__c mpwTrainMaintenance = utilDataTMMethod();      
        
        MPW_Reservation__c mpwReservation1 = new MPW_Reservation__c();        
        mpwReservation1.MPW_Train_Name__c = mpwTrainMaintenance.Id;
        mpwReservation1.Name = '2015-03-05600';
        mpwReservation1.Form_Status__c = 'Draft';
        mpwReservation1.Category__c = 'Customer';
        mpwReservation1.Usage__c = 'Required';
        mpwReservation1.Prime_Die_Name__c = 'TestComapre1';
        insert mpwReservation1;
        
        MPW_Prime_Die__c mpwPrimeDie1 = utilDataPDMethod7(mpwReservation1);
        
        Test.startTest();
        
        Test.setCurrentPageReference(new PageReference('Page.MPWReservationFormVF'));
        
        MPWReservationFormController appMatrixClass = new MPWReservationFormController(new ApexPages.Standardcontroller(mpwReservation1));
        appMatrixClass.getProcesses();
        appMatrixClass.saveAsDraft();
        
        Test.stopTest();
    }
    
    public static testMethod void myReservationFormContMethod21() {
        MPW_Train_Maintenance__c mpwTrainMaintenance = utilDataTMMethod();      
        
        MPW_Reservation__c mpwReservation1 = new MPW_Reservation__c();        
        mpwReservation1.MPW_Train_Name__c = mpwTrainMaintenance.Id;
        mpwReservation1.Name = '2015-03-05600';
        mpwReservation1.Form_Status__c = 'Draft';
        mpwReservation1.Category__c = 'Customer';
        mpwReservation1.Usage__c = 'Required';
        mpwReservation1.Prime_Die_Name__c = 'TestComapre1';
        insert mpwReservation1;
        
        MPW_Prime_Die__c mpwPrimeDie1 = utilDataPDMethod8(mpwReservation1);
        
        Test.startTest();
        
        Test.setCurrentPageReference(new PageReference('Page.MPWReservationFormVF'));
        
        MPWReservationFormController appMatrixClass = new MPWReservationFormController(new ApexPages.Standardcontroller(mpwReservation1));
        appMatrixClass.getProcesses();
        appMatrixClass.saveAsDraft();
        
        Test.stopTest();
    }
    
    public static testMethod void myReservationFormContMethod22() {
        MPW_Train_Maintenance__c mpwTrainMaintenance = utilDataTMMethod();      
        
        MPW_Reservation__c mpwReservation1 = new MPW_Reservation__c();        
        mpwReservation1.MPW_Train_Name__c = mpwTrainMaintenance.Id;
        mpwReservation1.Name = '2015-03-05600';
        mpwReservation1.Form_Status__c = 'Draft';
        mpwReservation1.Category__c = 'Customer';
        mpwReservation1.Usage__c = 'Required';
        mpwReservation1.Prime_Die_Name__c = 'TestComapre1';
        insert mpwReservation1;
        
        MPW_Prime_Die__c mpwPrimeDie1 = utilDataPDMethod9(mpwReservation1);
        
        Test.startTest();
        
        Test.setCurrentPageReference(new PageReference('Page.MPWReservationFormVF'));
        
        MPWReservationFormController appMatrixClass = new MPWReservationFormController(new ApexPages.Standardcontroller(mpwReservation1));
        appMatrixClass.getProcesses();
        appMatrixClass.saveAsDraft();
        
        Test.stopTest();
    }
    
    public static testMethod void myReservationFormContMethod23() {
        MPW_Train_Maintenance__c mpwTrainMaintenance = utilDataTMMethod();      
        
        MPW_Reservation__c mpwReservation1 = new MPW_Reservation__c();        
        mpwReservation1.MPW_Train_Name__c = mpwTrainMaintenance.Id;
        mpwReservation1.Name = '2015-03-05600';
        mpwReservation1.Form_Status__c = 'Draft';
        mpwReservation1.Category__c = 'Customer';
        mpwReservation1.Usage__c = 'Required';
        mpwReservation1.Prime_Die_Name__c = 'TestComapre1';
        insert mpwReservation1;
        
        MPW_Prime_Die__c mpwPrimeDie1 = utilDataPDMethod10(mpwReservation1);
        
        Test.startTest();
        
        Test.setCurrentPageReference(new PageReference('Page.MPWReservationFormVF'));
        
        MPWReservationFormController appMatrixClass = new MPWReservationFormController(new ApexPages.Standardcontroller(mpwReservation1));
        appMatrixClass.getProcesses();
        appMatrixClass.saveAsDraft();
        
        Test.stopTest();
    }
    
    public static testMethod void myReservationFormContMethod24() {
        MPW_Train_Maintenance__c mpwTrainMaintenance = utilDataTMMethod();      
        
        MPW_Reservation__c mpwReservation1 = new MPW_Reservation__c();        
        mpwReservation1.MPW_Train_Name__c = mpwTrainMaintenance.Id;
        mpwReservation1.Name = '2015-03-05600';
        mpwReservation1.Form_Status__c = 'Draft';
        mpwReservation1.Category__c = 'Customer';
        mpwReservation1.Usage__c = 'Required';
        mpwReservation1.Prime_Die_Name__c = 'TestComapre1';
        insert mpwReservation1;
        
        MPW_Prime_Die__c mpwPrimeDie1 = utilDataPDMethod11(mpwReservation1);
        
        Test.startTest();
        
        Test.setCurrentPageReference(new PageReference('Page.MPWReservationFormVF'));
        
        MPWReservationFormController appMatrixClass = new MPWReservationFormController(new ApexPages.Standardcontroller(mpwReservation1));
        appMatrixClass.getProcesses();
        appMatrixClass.saveAsDraft();
        
        Test.stopTest();
    }
    
    public static testMethod void myReservationFormContMethod25() {
        MPW_Train_Maintenance__c mpwTrainMaintenance = utilDataTMMethod();      
        
        MPW_Reservation__c mpwReservation1 = new MPW_Reservation__c();        
        mpwReservation1.MPW_Train_Name__c = mpwTrainMaintenance.Id;
        mpwReservation1.Name = '2015-03-05600';
        mpwReservation1.Form_Status__c = 'Draft';
        mpwReservation1.Category__c = 'Customer';
        mpwReservation1.Usage__c = 'Required';
        mpwReservation1.Prime_Die_Name__c = 'TestComapre1';
        insert mpwReservation1;
        
        MPW_Prime_Die__c mpwPrimeDie1 = utilDataPDMethod12(mpwReservation1);
        
        Test.startTest();
        
        Test.setCurrentPageReference(new PageReference('Page.MPWReservationFormVF'));
        
        MPWReservationFormController appMatrixClass = new MPWReservationFormController(new ApexPages.Standardcontroller(mpwReservation1));
        appMatrixClass.getProcesses();
        appMatrixClass.saveAsDraft();
        
        Test.stopTest();
    }
    public static testMethod void myReservationFormContMethod26() {
        MPW_Train_Maintenance__c mpwTrainMaintenance = utilDataTMMethod();      
        
        MPW_Reservation__c mpwReservation1 = new MPW_Reservation__c();        
        mpwReservation1.MPW_Train_Name__c = mpwTrainMaintenance.Id;
        mpwReservation1.Name = '2015-03-05600';
        mpwReservation1.Form_Status__c = 'Draft';
        mpwReservation1.Category__c = 'Customer';
        mpwReservation1.Usage__c = 'Required';
        mpwReservation1.Prime_Die_Name__c = 'TestComapre1';
        insert mpwReservation1;
        
        MPW_Prime_Die__c mpwPrimeDie1 = utilDataPDMethod13(mpwReservation1);
        
        Test.startTest();
        
        Test.setCurrentPageReference(new PageReference('Page.MPWReservationFormVF'));
        
        MPWReservationFormController appMatrixClass = new MPWReservationFormController(new ApexPages.Standardcontroller(mpwReservation1));
        appMatrixClass.copySearchNumber = 'Test';
        //appMatrixClass.getProcesses();
        appMatrixClass.getSubCategories();
        appMatrixClass.getUsages();
        appMatrixClass.getPACodes();
        appMatrixClass.gotoPreview();
        appMatrixClass.turnkeyWrap.selectedmpwpd = mpwPrimeDie1.Id;
        appMatrixClass.saveAsDraft();
        
         appMatrixClass.compare();
        appMatrixClass.editPage();
        appMatrixClass.mpwResf.Category__c = 'FAB';
        appMatrixClass.onCategoryChange();
        // appMatrixClass.submitForApproval();
        appMatrixClass.voidForm();
        appMatrixClass.mpwResf.Form_Status__c='Test';
         appMatrixClass.voidForm();
         
        appMatrixClass.showAddress1 = false;
        appMatrixClass.showAddress2 = false;
        appMatrixClass.showAddress3 = false;
        appMatrixClass.addRowToAddress();
        appMatrixClass.deleteAddress1();
        appMatrixClass.deleteAddress2();
        appMatrixClass.deleteAddress3();
        appMatrixClass.gettrainOptions();
        appMatrixClass.gettrainOptions1();
        appMatrixClass.addRowToChipInformation();
        appMatrixClass.getPrimeDieWrapperList();
        //appMatrixClass.retreiveFormName();
        
              
        Test.stopTest();
    }
    
  
	
}