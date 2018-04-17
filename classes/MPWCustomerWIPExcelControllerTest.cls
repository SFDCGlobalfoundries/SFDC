/**
* Author: Anil Kumar
* Company: JK Technosoft
* Project: MPW
* Description: Used to download Prime Die Assignment of Customer in Excel format
* History:
*    Anil Kumar 12/07/2016 - Created
**/
@isTest 
public class MPWCustomerWIPExcelControllerTest {
    
    @testSetup static void setupData(){
        DataUtilTest.loadEnvironmentVariables();
        
        Map<String,Object> fieldValueMap = new Map<String,Object>();
        fieldValueMap.put('Name', 'MYTEST ACCOUNT1');  
        fieldValueMap.put('Account_Type__c', 'Customer');                           
        fieldValueMap.put('sub_type__c', 'Indirect');        
        fieldValueMap.put('site_department__c', 'IT');  
        fieldValueMap.put('Account_Manager__c', userinfo.getuserid());        
        fieldValueMap.put('transaction_type__c', 'Non-Transactional');                          
        fieldValueMap.put('region__c', 'US');        
        fieldValueMap.put('Corporate_Address_1__c', 'Test Address 1');          
        fieldValueMap.put('Corporate_City__c', 'Test City');                
        fieldValueMap.put('Corporate_Country__c', 'Singapore');
        fieldValueMap.put('Bill_To_Address_1__c', 'Test Address 1');          
        fieldValueMap.put('Bill_To_City__c', 'Test City');            
        fieldValueMap.put('Bill_To_Country__c', 'Singapore');        
        fieldValueMap.put('Fab_9_10__c','No');
        
        AccountDataFactory.createAccount(fieldValueMap);
    }
    
    public static testMethod void MPWCustomerWIPExcelControllerTest1(){
        
        
       Account accntObj = getAccount('MYTEST ACCOUNT1');
        
         Profile p = [SELECT Id FROM Profile WHERE Name='Standard User']; 
        
        User u2 = new User(Alias = 'test769', Email='test76579@testorg.com', 
                           EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                           LocaleSidKey='en_US', ProfileId = p.Id, 
                           TimeZoneSidKey='America/Los_Angeles', UserName='test76579@testorg.com');
        
       
        
        Contact c = new Contact();
        c.LastName = 'Last';
        c.FirstName = 'First';
        //c.AccountId = a.Id;
        c.User_Name__c = u2.UserName;
        insert c;
        
        Manufacturing_Lot__c objChild1 = new Manufacturing_Lot__c();
        objChild1.Name = 'testobjChild1';
        objChild1.Manufacturing_Lot_Id__c = '132323';
        //objChild1.Parent_Lot_Id__c = objParent.Id;
        objChild1.Device_ID_MES__c = 'Device';
        objChild1.Current_Mask_Layer_Being_Processed__c = 2;
        objChild1.Total_Mask_Count__c = 5;
		objChild1.Active_Flag__c = true;
        insert objChild1;
            
        MPW_Train_Maintenance__c mpwmant = new MPW_Train_Maintenance__c();
          mpwmant.Name = 'mpwmant'; 
          mpwmant.Tapeout_Date_Customer__c = Date.today()-1; 
          insert mpwmant;
            
            
       MPW_Reservation__c mpwRes = new MPW_Reservation__c();
        mpwRes.Name = 'Test Mpwres' ;
        mpwRes.Form_Status__c = 'Pending';
        mpwRes.Customer_Company_Name__c = c.AccountId;
        mpwRes.MPW_Train_Name__c = mpwmant.Id; 
        insert mpwRes;
            
        MPW_Prime_Die__c primedie = new MPW_Prime_Die__c();
        primedie.Prime_Die_Name__c = 'teste die';
        primedie.MPW_Form__c = mpwRes.id;
        primedie.Drawn_Die_Size_Y_um__c = 'test y';
        primedie.Drawn_Die_Size_X_um__c = 'test x';
        primedie.Device_Type__c = 'test ice';
        insert primedie;
        
         MPW_WIP_Lot__c mpw = new MPW_WIP_Lot__c();
        mpw.Manufacturing_Lot__c = objChild1.Id;
        mpw.Assignment_Type__c  = 'End Part';
        mpw.MPW_MES_Part_ID__c = 'testm';
        mpw.Notification_Start_Date__c = Date.today()-2;
        mpw.Notification_End_Date__c = Date.today();
        mpw.MPW_Prime_Die__c = primedie.ID;
        insert mpw;
      Test.startTest();      
         System.runAs(u2){
            String strFrmDt = String.valueOF(Date.today()-2);
            String strToDt = String.valueOF(Date.today());
        
        ApexPages.currentPage().getParameters().put('fromDt', strFrmDt);
        ApexPages.currentPage().getParameters().put('toDt', strToDt);
            
            MPWCustomerWIPExcelController cntrl = new MPWCustomerWIPExcelController();
        }
      Test.StopTest();  
        
    }

     private static Account getAccount(string AccountName){
        Account acct = [SELECT Id, Name FROM Account Where Name =: AccountName];
        
        return acct;
    }
    
}