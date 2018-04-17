/*
    Author: Abhita Bansal
    Created Date: 24/08/2015 
    Description: Test class for MPWTurnKeyTriggerHandler 
*/
@isTest
public class MPWTurnKeyTriggerHandlerTest {
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
    
    public static testMethod void myturnkeyHandlerMethod() {    
    
        Profile p = [Select Id from Profile where name = 'System Administrator' LIMIT 1];
        User u1 = new User(ProfileId = p.Id, Username = 'test002' + System.now().format('MMddyyyyHHmmss') + '@test.com',
                           Alias = 'mm1', Email = 'test1@gf.com', EmailEncodingKey = 'UTF-8', Firstname = 'MPWTest', Lastname = 'User1',
                           LanguageLocaleKey = 'en_US', LocaleSidKey = 'en_US', TimeZoneSidKey = 'America/Chicago');
        insert u1;
        
    Group grp = [Select Id from Group where developerName='MPW_Dresden_MPW_CE_Queue' AND Type = 'Queue'];
        System.runAs(u1){
            GroupMember member = new GroupMember();
            member.UserOrGroupId = u1.id;
            member.GroupId = grp.Id;
            
            insert member;
        }
        List<User> userAppMatrix = [select Id from User where Profile.Name = 'GF PIYE Platform' and isActive = true limit 3];
        
        Account a= getAccount('Test Account 007'); 
        
    List<Account_Team_Proxy__c> lstAccountTeam = new List<Account_Team_Proxy__c>();
        Account_Team_Proxy__c accProxy = new Account_Team_Proxy__c();
        accProxy.Account__c = a.Id;
        accProxy.Team_Role__c = 'Primary Account Manager';
        accProxy.User__c = userAppMatrix[0].Id;
        accProxy.Account_Access__c = 'Read/Write';
        lstAccountTeam.add(accProxy);
        
        Account_Team_Proxy__c accProxy1 = new Account_Team_Proxy__c();
        accProxy1.Account__c = a.Id;
        accProxy1.Team_Role__c = 'Primary Customer Service Rep';
        accProxy1.User__c = userAppMatrix[1].Id;
        accProxy1.Account_Access__c = 'Read/Write';
        lstAccountTeam.add(accProxy1);
        
        Account_Team_Proxy__c accProxy2 = new Account_Team_Proxy__c();
        accProxy2.Account__c = a.Id;
        accProxy2.Team_Role__c = 'Field Application Engineer';
        accProxy2.User__c = userAppMatrix[2].Id;
        accProxy2.Account_Access__c = 'Read/Write';
        lstAccountTeam.add(accProxy2);
    
    insert lstAccountTeam;
        
        MPW_Approval_Matrix__c mpwApproval = new MPW_Approval_Matrix__c();
        mpwApproval.Category__c = 'FAB';
        mpwApproval.Fab__c = 'Fab1';
        mpwApproval.Geometry__c = '28nm';
        mpwApproval.Step_1_Approver_1__c = userAppMatrix[0].Id;
        mpwApproval.Step_1_Approver_2__c = userAppMatrix[1].Id;
        insert mpwApproval;
        
        MPW_Config_Settings__c mpwConfig = new MPW_Config_Settings__c();
        mpwConfig.Active__c = true;
        mpwConfig.Geometry__c = '28nm';
        mpwConfig.Name = '28nmLP';
        insert mpwConfig;
        
        MPW_Tech_Module__c mpwTechModule = new MPW_Tech_Module__c();
        mpwTechModule.Active__c = true;
        mpwTechModule.Answers__c = 'Yes;No';
        mpwTechModule.Geometry__c = '28nm';
        mpwTechModule.Module_Description__c = 'N3';
        mpwTechModule.Module_Name__c = 'Triple well';
        mpwTechModule.Question__c = 'Do you need Triple well?:';
        insert mpwTechModule;
        
        MPW_Train_Maintenance__c mpwTrain = new MPW_Train_Maintenance__c();
        mpwTrain.Active__c = true;
        mpwTrain.Publish__c = true;
        mpwTrain.Train_Type__c = 'GlobalShuttle';
        mpwTrain.Geometry__c = '28nm';
        mpwTrain.Train_Number__c = 'MPW03312';
        mpwTrain.Reservation_Close_Date__c = System.today();
        mpwTrain.Tapeout_Date_Customer__c = System.today() + 6;
        mpwTrain.Fab__c = 'Fab1';
        mpwTrain.Status__c = '28LPSe, 28LPS, 28LPS-RF';
        insert mpwTrain;
        
        MPW_Train_Maintenance_Details__c mpwTrainDetails = new MPW_Train_Maintenance_Details__c();
        mpwTrainDetails.Answers__c = 'Yes;No';
        mpwTrainDetails.MPW_Tech_Module__c = mpwTechModule.Id;
        mpwTrainDetails.MPW_Train_Maintenance__c = mpwTrain.Id;
        mpwTrainDetails.Process_Type__c = mpwConfig.Id;
        insert mpwTrainDetails;
        
        Test.startTest();
        
        MPW_Reservation__c mpwReservation1 = new MPW_Reservation__c();        
        mpwReservation1.MPW_Train_Name__c = mpwTrain.Id;
        mpwReservation1.Name = '2015-03-05600';
        mpwReservation1.Form_Status__c = 'Draft';
        mpwReservation1.Category__c = 'Customer';
        mpwReservation1.Usage__c = 'Required';
        mpwReservation1.Prime_Die_Name__c = 'TestComapre1';
        mpwReservation1.Customer_Company_Name__c = a.Id;
        insert mpwReservation1;
        
        MPW_Prime_Die__c mpwPrimeDie1 = new MPW_Prime_Die__c();
        mpwPrimeDie1.Prime_Die_Name__c = 'TestComapre1';
        mpwPrimeDie1.MPW_Form__c = mpwReservation1.Id;
        mpwPrimeDie1.Drawn_Die_Size_X_um__c = '1234';
        mpwPrimeDie1.Drawn_Die_Size_Y_um__c = '2344';
        mpwPrimeDie1.Device_Type__c = 'Product';
        mpwPrimeDie1.Delivery_Qty_Die_Form__c = '100';
        mpwPrimeDie1.Delivery_Qty_Wafer_Form__c = '2';
        mpwPrimeDie1.Drawn_Orientation_Restricted_Structures__c= 'Test';
        mpwPrimeDie1.Metal_Stack__c = 'Test';
        mpwPrimeDie1.Corner_Split__c = 'No';
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
        mpwPrimeDie1.Turnkey_Service__c = 'No';
        insert mpwPrimeDie1;
        
        MPW_CE_Turnkey_QueueIDName__c mpwQueueIdNameCusset = new MPW_CE_Turnkey_QueueIDName__c();
        mpwQueueIdNameCusset.Name = 'MPW_Dresden_MPW_CE_Queue';
        mpwQueueIdNameCusset.Queue_Name__c = grp.Id;
        mpwQueueIdNameCusset.Group_Name__c = 'MPW_Dresden_MPW_CE_Group';
        mpwQueueIdNameCusset.isCEUser__c = true;
        mpwQueueIdNameCusset.isTurnkeyUser__c = false;
        mpwQueueIdNameCusset.Fab__c = 'Fab1';
        insert mpwQueueIdNameCusset;

        //Test.startTest();
        
        System.runAs(u1){
            MPW_Turnkey__c mpwTurnkey = new MPW_Turnkey__c();
            mpwTurnkey.MPW_Reservation__c = mpwReservation1.Id;
            mpwTurnkey.MPW_Prime_Die__c = mpwPrimeDie1.Id;
            mpwTurnkey.Ship_Date__c = System.today() + 5;
            mpwTurnkey.Wafer_Ship_Date__c = System.today() + 7;
            mpwTurnkey.AWB__c = 'Testing';
            mpwTurnkey.Actual_Wafer_Skeleton_Return_Date__c = System.today() + 3;
            mpwTurnkey.Expected_Wafer_Skeleton_Return_Date__c = System.today() + 2;
            insert mpwTurnkey;
            mpwTurnkey.AWB__c = 'Test Update';
            mpwTurnkey.Bare_Die_Forecast_Ship_Date__c = System.today() + 2;
      mpwTurnkey.Actual_Wafer_Skeleton_Return_Date__c = System.today() + 4;
            update mpwTurnkey;
        }
        Test.stopTest() ; 
    }
    
    private static Account getAccount(string AccountName)
            {
                Account a= [SELECT Id, Name FROM Account Where Name =: AccountName];
        
                return a;
            }  
}