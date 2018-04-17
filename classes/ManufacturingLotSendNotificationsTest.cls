/*
    Author: Zymark Ambat
    Description: This Class serves as the test class for ManufacturingLotSendNotifications.
    History: 
        ZAmbat      12292014    - Code creation.
*/

@isTest(SeeAllData = false)

 
    
public class ManufacturingLotSendNotificationsTest {

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
        fieldValueMap.put('recordtypeid', EnvironmentVariable.get('ACCT_RT_ID_CUSTOMER')); 
        AccountDataFactory.createAccount(fieldValueMap);
    }
    static Id createAccount() {
        Account testAcct = getAccount('Test Account 007'); 
        
        
        return testAcct.Id;
    }
    
    static void createAccountTeamProxy(Id accountId, boolean hasCE) {
        List<Account_Team_Proxy__c> listATP = new List<Account_Team_Proxy__c>();
        Account_Team_Proxy__c atpCE = new Account_Team_Proxy__c();
        if (hasCE) {
            atpCE.Account__c = accountId;
            atpCE.User__c = [SELECT Id FROM User WHERE Profile.Name = 'GF CE' AND IsActive = true LIMIT 1].Id;
            atpCE.Account_Access__c = 'Read/Write';
            atpCE.Opportunity_Access__c = 'Read/Write';
            atpCE.Team_Role__c = 'Customer Engineer';
            atpCE.Fab_Assignment__c = 'FAB 2;FAB 3;FAB 5';
            listATP.add(atpCE);
        }
        
        Account_Team_Proxy__c atpFE = new Account_Team_Proxy__c();
        atpFE.Account__c = accountId;
        atpFE.User__c = [SELECT Id FROM User WHERE Profile.Name = 'GF FAE/FTS' AND IsActive = true LIMIT 1].Id;
        atpFE.Account_Access__c = 'Read/Write';
        atpFE.Opportunity_Access__c = 'Read/Write';
        atpFE.Team_Role__c = 'Field Application Engineer';
        atpFE.Fab_Assignment__c = 'FAB 2;FAB 3;';
        listATP.add(atpFE);
        
        insert listATP;
    }
 
    static List<Manufacturing_Lot__c> createManufacturingLot(Id accountId) {
        List<Manufacturing_Lot__c> listML = new List<Manufacturing_Lot__c>();
        for (integer i=1; i<=20; i++) {    
            Manufacturing_Lot__c m = new Manufacturing_Lot__c();
            m.Account_Name__c = accountId;
            m.Name = 'testManufacturingLotZ.' + i;
            if (i <= 5) {
                m.Lot_Type__c = 'QD' + i;
                m.Last_Ship_Date__c = date.today().addDays(-3);
            } else if (i > 5 && i <= 10) {
                m.Lot_Type__c = 'QF1D' + i;
                m.Last_Ship_Date__c = date.today().addDays(50);
            } else if (i > 10 && i <= 15) {
                m.Lot_Type__c = 'QF15D' + i;
                m.Last_Ship_Date__c = date.today().addDays(50);
            } else if (i > 15 && i <= 20) {
                m.Lot_Type__c = 'QF30D' + i;
                m.Last_Ship_Date__c = date.today().addDays(50);
            }
            m.Fab_Group__c = 'FAB 2';
            m.Lot_Start_Date__c = datetime.now();
            m.Device_ID_MES__c = 'TESTMLDEVICE123Z';
            listML.add(m);
        }
        
        insert listML;
        return listML;
    }
    
    static testMethod void testManufacturingLotSendNotifications1() {
        string accountId = ManufacturingLotSendNotificationsTest.createAccount();
        ManufacturingLotSendNotificationsTest.createAccountTeamProxy(accountId, false);
        
        test.startTest();
            ManufacturingLotSendNotificationsTest.createManufacturingLot(accountId);
        test.stopTest();
    }
    
    static testMethod void testManufacturingLotSendNotifications2() {
        string accountId = ManufacturingLotSendNotificationsTest.createAccount();
        ManufacturingLotSendNotificationsTest.createAccountTeamProxy(accountId, false);
        
        test.startTest();
            ManufacturingLotSendNotificationsTest.createManufacturingLot(accountId);
        test.stopTest();
    }
    
    static testMethod void testManufacturingLotSendNotifications3() {
        string accountId = ManufacturingLotSendNotificationsTest.createAccount();
        ManufacturingLotSendNotificationsTest.createAccountTeamProxy(accountId, false);
        
        test.startTest();
            List<Manufacturing_Lot__c> listML = ManufacturingLotSendNotificationsTest.createManufacturingLot(accountId);
            for (Manufacturing_Lot__c m : listML) {
                if (m.Lot_Type__c.startsWith('QD')) {
                    m.Lot_Type__c = 'QF';
                } else if (m.Lot_Type__c.startsWith('QF')) {
                    m.Lot_Type__c = 'QD';
                }
            }
            update listML;
        test.stopTest();
    }
    
    private static Account getAccount(string AccountName)
            {
                Account testAcct= [SELECT Id, Name FROM Account Where Name =: AccountName];
        
                return testAcct;
            }  
}