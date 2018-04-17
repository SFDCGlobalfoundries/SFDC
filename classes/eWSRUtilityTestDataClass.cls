/*
    Author:Abhita Bansal
    Description:This Class contains the Test Data for the test Classes of eWSR Form
    Created Date: 3/12/2014
*/
public class eWSRUtilityTestDataClass {
    
    public static HCM_Employee__c getHCMEmployee(){
        
        HCM_Employee__c hcmEmp = new HCM_Employee__c();
        hcmEmp.First_Name__c = 'Test eWSR User';
        hcmEmp.Last_Name__c = 'Test eWSR User';
        hcmEmp.Employee_ID__c = '91012012';
        hcmEmp.Login_ID__c = 'A1089';
        hcmEmp.Email_Address__c = 'testeWSRuser@testorg.com';
        insert hcmEmp;
        return hcmEmp;
    }
    
    public static HCM_Employee__c getHCMEmployee1(){
        
        HCM_Employee__c hcmEmp1 = new HCM_Employee__c();
        hcmEmp1.First_Name__c = 'Test1';
        hcmEmp1.Last_Name__c = 'Test1';
        hcmEmp1.Employee_ID__c = '9101201';
        hcmEmp1.Login_ID__c = 'A10891';
        hcmEmp1.Email_Address__c = 'testeWSRuser1@testorg.com';
        insert hcmEmp1;
        return hcmEmp1;
    }
    
    public static HCM_Employee__c getHCMEmployee2(){
        
        HCM_Employee__c hcmEmp2 = new HCM_Employee__c();
        hcmEmp2.First_Name__c = 'Test2';
        hcmEmp2.Last_Name__c = 'Test2';
        hcmEmp2.Employee_ID__c = '9101204';
        hcmEmp2.Login_ID__c = 'A10892';
        hcmEmp2.Email_Address__c = 'testeWSRuser2@testorg.com';
        insert hcmEmp2;
        return hcmEmp2;
    }

    public static HCM_Employee__c getHCMEmployee3(){
        
        HCM_Employee__c hcmEmp3 = new HCM_Employee__c();
        hcmEmp3.First_Name__c = 'Test3';
        hcmEmp3.Last_Name__c = 'Test3';
        hcmEmp3.Employee_ID__c = '91012901';
        hcmEmp3.Login_ID__c = 'A108781';
        hcmEmp3.Email_Address__c = 'testeWSRuser3@testorg.com';
        insert hcmEmp3;
        return hcmEmp3;
    }
    
    public static HCM_Employee__c getHCMEmployee4(){
        
        HCM_Employee__c hcmEmp4 = new HCM_Employee__c();
        hcmEmp4.First_Name__c = 'Test4';
        hcmEmp4.Last_Name__c = 'Test4';
        hcmEmp4.Employee_ID__c = '9101267';
        hcmEmp4.Login_ID__c = 'A108767';
        hcmEmp4.Email_Address__c = 'testeWSRuser4@testorg.com';
        insert hcmEmp4;
        return hcmEmp4;
    }
    
    public static HCM_Employee__c getHCMEmployee5(){
        
        HCM_Employee__c hcmEmp5 = new HCM_Employee__c();
        hcmEmp5.First_Name__c = 'Test5';
        hcmEmp5.Last_Name__c = 'Test5';
        hcmEmp5.Employee_ID__c = '91015267';
        hcmEmp5.Login_ID__c = 'A1085767';
        hcmEmp5.Email_Address__c = 'testeWSRuser5@testorg.com';
        insert hcmEmp5;
        return hcmEmp5;
    }
    
    public static User getuser(){
        
        Profile profileId = [Select Id from Profile where name = 'GF PIYE Platform'];
            HCM_Employee__c hcmEmp = getHCMEmployee();
            User user = new User();
            user.Email = 'testeWSRuser@testorg.com';
            user.Emailencodingkey = 'UTF-8';
            user.Alias = 'TUser';
            user.LastName = 'Test eWSR User';
            user.LanguageLocaleKey = 'en_US';
            user.LocaleSidKey = 'en_US';
            user.ProfileId = profileId.Id;
            user.Fab_Assigned__c = 'FAB 3';
            user.Username = 'testeWSRuser@testorg.com.uat'; 
            user.TimeZoneSidKey = 'America/Los_Angeles';
            user.FederationIdentifier = '91012012';     
            insert user;
            return user;
    }
    
    public static User getuser1(){
        
        Profile profileId = [Select Id from Profile where name = 'GF PIYE Platform'];
            HCM_Employee__c hcmEmp1 = getHCMEmployee1();
            User user1 = new User();
            user1.Email = 'testeWSRuser1@testorg.com';
            user1.Emailencodingkey = 'UTF-8';
            user1.Alias = 'TUser1';
            user1.LastName = 'Test eWSR User1';
            user1.LanguageLocaleKey = 'en_US';
            user1.LocaleSidKey = 'en_US';
            user1.ProfileId = profileId.Id;
            user1.Fab_Assigned__c = 'FAB 3E';
            user1.Username = 'testeWSRuser1@testorg.com.uat'; 
            user1.TimeZoneSidKey = 'America/Los_Angeles';
            user1.FederationIdentifier = '9101201';     
            insert user1;
            return user1;
    }
    
    public static User getuser2(){
        
        Profile profileId = [Select Id from Profile where name = 'GF PIYE Platform'];
            HCM_Employee__c hcmEmp2 = getHCMEmployee2();
            User user2 = new User();
            user2.Email = 'testeWSRuser2@testorg.com';
            user2.Emailencodingkey = 'UTF-8';
            user2.Alias = 'TUser2';
            user2.LastName = 'Test eWSR User2';
            user2.LanguageLocaleKey = 'en_US';
            user2.LocaleSidKey = 'en_US';
            user2.ProfileId = profileId.Id;
            user2.Fab_Assigned__c = 'FAB 5';
            user2.Username = 'testeWSRuser2@testorg.com.uat'; 
            user2.TimeZoneSidKey = 'America/Los_Angeles';
            user2.FederationIdentifier = '9101204';     
            insert user2;
            return user2;
    }
    
    public static User getuser3(){
        
        Profile profileId = [Select Id from Profile where name = 'GF PIYE Platform'];
            HCM_Employee__c hcmEmp3 = getHCMEmployee3();
            User user3 = new User();
            user3.Email = 'testeWSRuser3@testorg.com';
            user3.Emailencodingkey = 'UTF-8';
            user3.Alias = 'TUser3';
            user3.FirstName = 'Test';
            user3.LastName = 'eWSR User3';
            user3.LanguageLocaleKey = 'en_US';
            user3.LocaleSidKey = 'en_US';
            user3.ProfileId = profileId.Id;
            user3.Username = 'testeWSRuser3@testorg.com.uat'; 
            user3.Fab_Assigned__c = 'FAB 2';
            user3.TimeZoneSidKey = 'America/Los_Angeles';
            user3.FederationIdentifier = '91012901';     
            insert user3;
            return user3;
    }
    
    public static User getuser4(){
        
        Profile profileId = [Select Id from Profile where name = 'GF PIYE Platform'];
            HCM_Employee__c hcmEmp4 = getHCMEmployee4();
            User user4 = new User();
            user4.Email = 'testeWSRuser4@testorg.com';
            user4.Emailencodingkey = 'UTF-8';
            user4.Alias = 'TUser4';
            user4.LastName = 'Test eWSR User4';
            user4.LanguageLocaleKey = 'en_US';
            user4.LocaleSidKey = 'en_US';
            user4.ProfileId = profileId.Id;
            user4.Username = 'testeWSRuser4@testorg.com.uat'; 
            user4.Fab_Assigned__c = 'FAB 2;FAB 3;FAB 3E;FAB 5;FAB 6;FAB 7';
            user4.TimeZoneSidKey = 'America/Los_Angeles';
            user4.FederationIdentifier = '9101267';     
            insert user4;
            return user4;
    }
    
    public static User getuser5(){
        
        Profile profileId = [Select Id from Profile where name = 'GF PIYE Platform'];
            HCM_Employee__c hcmEmp5 = getHCMEmployee5();
            User user5 = new User();
            user5.Email = 'testeWSRuser5@testorg.com';
            user5.Emailencodingkey = 'UTF-8';
            user5.Alias = 'TUser5';
            user5.LastName = 'Test eWSR User4';
            user5.LanguageLocaleKey = 'en_US';
            user5.LocaleSidKey = 'en_US';
            user5.ProfileId = profileId.Id;
            user5.Username = 'testeWSRuser5@testorg.com.uat'; 
            //user5.Fab_Assigned__c = 'FAB 2;FAB 3;FAB 3E;FAB 5;FAB 6;FAB 7';
            user5.TimeZoneSidKey = 'America/Los_Angeles';
            user5.FederationIdentifier = '91015267';     
            insert user5;
            return user5;
    }
    
    public static Account getAccount(){
        
        Map<String,Object> fieldValueMap = new Map<String,Object>();
        fieldValueMap.put('Name', 'MYTEST ACCOUNT1');            
        fieldValueMap.put('Short_Name__c', 'TAC1');        
        fieldValueMap.put('sub_type__c', 'Direct');
        fieldValueMap.put('site_department__c', 'test dept');          
        fieldValueMap.put('transaction_type__c', 'transactional');                          
        fieldValueMap.put('region__c', 'US');        
        fieldValueMap.put('Corporate_Address_1__c', 'Test Address 1');          
        fieldValueMap.put('Corporate_City__c', 'Test City');                
        fieldValueMap.put('Corporate_Country__c', 'India');                
        fieldValueMap.put('Fab_9_10__c','No');
        fieldValueMap.put('recordtypeid', EnvironmentVariable.get('ACCT_RT_ID_CUSTOMER'));

        return AccountDataFactory.createAccount(fieldValueMap);                
    }
    
    public static RecordType getRecordType(String recordName, String sObjectName){
        
        RecordType recordType = new RecordType();
        recordType = [Select Id from RecordType where Name =: recordName AND SObjectType =: sObjectName]; 
        return recordType;
    }
    
    public Static eWSR_Devices__c getDeviceId(String fabName){
        
        eWSR_Devices__c deviceId = new eWSR_Devices__c();
        deviceId.Name = '123';
        deviceId.Fab__c = fabName;
        deviceId.Process_ID__c = '125';
        deviceId.Start_Material__c = 'ABW123';
        deviceId.Total_Number_of_Mask_layers__c = 9;
        insert deviceId;
        return deviceId;
    }
    
    public Static eWSR_Devices__c getDeviceId1(String fabName){
        
        eWSR_Devices__c deviceId = new eWSR_Devices__c();
        deviceId.Name = '123';
        deviceId.Fab__c = fabName;
        deviceId.Process_ID__c = '125';
        deviceId.Start_Material__c = 'ABW123;TEST123';
        deviceId.Total_Number_of_Mask_layers__c = 9;
        insert deviceId;
        return deviceId;
    }
    
}