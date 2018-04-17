/**
* Author: Anil Kumar
* Company: JK Technosoft
* Project: MPW
* Description: Test Class for MPWLotAssignmentController
* History:
*    Anil Kumar 07/07/2016 - Created
**/
@isTest
private class MPWLotAssignmentControllerTest {

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
   
    static testMethod void MPWLotAssignmentControllerTest1() {


        List<Manufacturing_Lot__c> lstMFG = new List<Manufacturing_Lot__c>();
        List<String> lststrMFG = new List<String>();
        
        Account accntObj = getAccount('MYTEST ACCOUNT1');
        
        MPWAssignment__c mpwAssign = new MPWAssignment__c();
        mpwAssign.Name = 'mpwAssign';
        mpwAssign.AccountId__c = accntObj.Id;
        insert mpwAssign;
        
        Manufacturing_Lot__c objParent = new Manufacturing_Lot__c();
        objParent.Name = 'testParent';
        objParent.Manufacturing_Lot_Id__c = '32124';
        objParent.Active_Flag__c = true;
        objParent.Device_ID_MES__c = 'Device';
        objParent.Current_Mask_Layer_Being_Processed__c = 5;
        objParent.Total_Mask_Count__c = 8;
        objParent.Account_Name__c = accntObj.ID; 
        lstMFG.add(objParent);
        
        Manufacturing_Lot__c objChild1 = new Manufacturing_Lot__c();
        objChild1.Name = 'testobjChild1';
        objChild1.Manufacturing_Lot_Id__c = '132323';
        objChild1.Parent_Lot_Id__c = '32124';
        objChild1.Active_Flag__c = true;
        objChild1.Device_ID_MES__c = 'Device';
        objChild1.Account_Name__c = accntObj.ID; 
        objChild1.Current_Mask_Layer_Being_Processed__c = 5;
        objChild1.Total_Mask_Count__c = 8;
        lstMFG.add(objChild1);
        
        Manufacturing_Lot__c obj = new Manufacturing_Lot__c();
        obj.Name = 'test';
        obj.Manufacturing_Lot_Id__c = '356677';
        obj.Parent_Lot_Id__c = '132323';
        obj.Active_Flag__c = true;
        obj.Device_ID_MES__c = 'Device';
        obj.Account_Name__c = accntObj.ID; 
        obj.Current_Mask_Layer_Being_Processed__c = 5;
        obj.Total_Mask_Count__c = 8;
        lstMFG.add(obj);
       
         
        Manufacturing_Lot__c objChild2 = new Manufacturing_Lot__c();
        objChild2.Name = 'testobjChild2';
        objChild2.Manufacturing_Lot_Id__c = '12435451';
        objChild2.Parent_Lot_Id__c = '32124';
        objChild2.Device_ID_MES__c = 'Device';   
        objChild2.Active_Flag__c = true;
        objChild2.Account_Name__c = accntObj.ID; 
        objChild2.Current_Mask_Layer_Being_Processed__c = 5;
        objChild2.Total_Mask_Count__c = 8;
        lstMFG.add(objChild2);
        
        insert lstMFG;
        
        MPW_Train_Maintenance__c mpwmant = new MPW_Train_Maintenance__c();
        mpwmant.Name = 'mpwmant'; 
        mpwmant.Tapeout_Date_Customer__c = Date.today()-1; 
        insert mpwmant;
            
        MPW_Reservation__c mpwRes = new MPW_Reservation__c();
        mpwRes.Name = 'Test Mpwres' ;
        mpwRes.Form_Status__c = 'Pending';
        mpwRes.Customer_Company_Name__c = accntObj.ID;
        mpwRes.MPW_Train_Name__c = mpwmant.Id; 
        insert mpwRes;
        
        List<MPW_Prime_Die__c> lstPrimeDie = new List<MPW_Prime_Die__c>();
        MPW_Prime_Die__c primedie = new MPW_Prime_Die__c();
        primedie.Prime_Die_Name__c = 'teste die';
        primedie.MPW_Form__c = mpwRes.id;
        primedie.Drawn_Die_Size_Y_um__c = 'test y';
        primedie.Drawn_Die_Size_X_um__c = 'test x';
        primedie.Device_Type__c = 'test ice';
        lstPrimeDie.add(primedie);
        
        MPW_Prime_Die__c primedie1 = new MPW_Prime_Die__c();
        primedie1.Prime_Die_Name__c = 'teste die1';
        primedie1.MPW_Form__c = mpwRes.id;
        primedie1.Drawn_Die_Size_Y_um__c = 'test y';
        primedie1.Drawn_Die_Size_X_um__c = 'test x';
        primedie1.Device_Type__c = 'test ice';
        lstPrimeDie.add(primedie1);
        
        insert lstPrimeDie;
        
        List<MPW_WIP_Lot__c> lstWIP = new List<MPW_WIP_Lot__c>();
        MPW_WIP_Lot__c mpw = new MPW_WIP_Lot__c();
        mpw.Manufacturing_Lot__c = objChild1.Id;
        mpw.Assignment_Type__c  = 'End Part';
        mpw.MPW_MES_Part_ID__c = 'testm';
        mpw.Notification_Start_Date__c = Date.today()-2;
        mpw.Notification_End_Date__c = Date.today();
        mpw.MPW_Prime_Die__c = primedie.ID;
        lstWIP.add(mpw);
        
        MPW_WIP_Lot__c mpw1 = new MPW_WIP_Lot__c();
        mpw1.Manufacturing_Lot__c = objParent.Id;
        mpw1.Assignment_Type__c  = 'End Part';
        mpw1.MPW_MES_Part_ID__c = 'testm';
        mpw1.Notification_Start_Date__c = Date.today()-2;
        mpw1.Notification_End_Date__c = Date.today();
        mpw1.MPW_Prime_Die__c = primedie.ID;
        lstWIP.add(mpw1);
        
        MPW_WIP_Lot__c mpw2 = new MPW_WIP_Lot__c();
        mpw2.Manufacturing_Lot__c = objParent.Id;
        mpw2.Assignment_Type__c  = 'End Part';
        mpw2.MPW_MES_Part_ID__c = 'testm';
        mpw2.Notification_Start_Date__c = Date.today()-2;
        mpw2.Notification_End_Date__c = Date.today();
        mpw2.MPW_Prime_Die__c = primedie.ID;
        lstWIP.add(mpw2);
        
        insert lstWIP;
        
        MPWLotAssignmentController cntrl = new MPWLotAssignmentController();
        cntrl.strMfgLotId = objChild1.Id;
        cntrl.strSearchTxtDevice = 'Device';
        cntrl.strMfgLot = '132323';
        cntrl.strMPWTrain = 'strMPWTrain';
        cntrl.loadMfgLot();
        cntrl.loadPopupMPWWIPLot();
        for(MPWLotAssignmentController.MPWWIPLotPopoupWrapper wrap2 : cntrl.lstPopupMPWWIPLot){
            wrap2.isSelected = true;
        }
        cntrl.saveLotAssignment();
    }
    
     private static Account getAccount(string AccountName){
        Account acct = [SELECT Id, Name FROM Account Where Name =: AccountName];
        
        return acct;
    }
}