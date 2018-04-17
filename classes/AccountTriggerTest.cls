/*
    Author: 
    Description: This is test class for AccountTrigger
    History:
        Tlai        25072014    - Created
    Devendra  10142015      - Updated to fix device validation error
*/
@isTest(seeAllData = false)
private class AccountTriggerTest {
    
    @testSetup static void testdata() {
    
        DefaultTechnologyGeometries__c defltTchGeo = new DefaultTechnologyGeometries__c();
            defltTchGeo.Name = '0.11UM';
            insert defltTchGeo;
            
   
        DataUtilTest.loadEnvironmentVariables();
        
        List<Map<String,Object>> fieldValueMapList = new List<Map<String,Object>>();
        for(integer i=1;i<=4;i++){
            Map<String,Object> fieldValueMap = new Map<String,Object>();
            fieldValueMap.put('Name', 'MYTEST ACCOUNT'+i);            
            fieldValueMap.put('Short_Name__c', 'data0'+i);    
            fieldValueMap.put('Has_Valid_NDA__c', true);      
            fieldValueMap.put('sub_type__c', 'Direct');
            fieldValueMap.put('site_department__c', 'test dept');          
            fieldValueMap.put('transaction_type__c', 'transactional');                          
            fieldValueMap.put('region__c', 'APJ');        
            fieldValueMap.put('Corporate_Address_1__c', 'Test Address 1');          
            fieldValueMap.put('Corporate_City__c', 'Test City');                
            fieldValueMap.put('Corporate_Country__c', 'Singapore');
            fieldValueMap.put('Copy_Address__c', true);                             
            fieldValueMap.put('Fab_9_10__c','No');
            fieldValueMap.put('Account_Type__c','Customer');
            fieldValueMap.put('Organization_Unit__c','sg;us');
            fieldValueMap.put('New_Organization_Unit_Request__c','gf');
            fieldValueMap.put('Financial_Territory__c','Greater China');
            fieldValueMap.put('stage__c','Unqualified');
            fieldValueMap.put('Siebel_Status__c','SUCCESS');
            fieldValueMap.put('Account_Present_In_OT__c', true);
            fieldValueMap.put('Valid_Tech_Geos__c', '0.007UM');
            fieldValueMap.put('Tech_Geo_Granted__c', '0.010UM');
            fieldValueMap.put('Has_Valid_NDA__c', true);
            
            fieldValueMapList.add(fieldValueMap);
        }
        Map<String,Object> fieldValueMap = new Map<String,Object>();
        fieldValueMap.put('Name', 'MYTEST ACCOUNT56');            
        fieldValueMap.put('sub_type__c', 'Direct');
        fieldValueMap.put('site_department__c', 'test dept');          
        fieldValueMap.put('transaction_type__c', 'transactional');                          
        fieldValueMap.put('region__c', 'APJ');        
        fieldValueMap.put('Corporate_Address_1__c', 'Test Address 1');          
        fieldValueMap.put('Corporate_City__c', 'Test City');                
        fieldValueMap.put('Corporate_Country__c', 'Singapore');
        fieldValueMap.put('Copy_Address__c', false);                             
        fieldValueMap.put('Fab_9_10__c','No');
        fieldValueMap.put('Account_Type__c','GLOBALFOUNDRIES Internal');
        fieldValueMap.put('Organization_Unit__c','sg;us');
        fieldValueMap.put('New_Organization_Unit_Request__c','gf');
        fieldValueMap.put('Financial_Territory__c','Greater China');
        fieldValueMap.put('stage__c','Unqualified');
        fieldValueMap.put('Siebel_Status__c','SUCCESS');
        fieldValueMap.put('Account_Present_In_OT__c', true);
        fieldValueMap.put('Valid_Tech_Geos__c', '0.007UM');
        fieldValueMap.put('Tech_Geo_Granted__c', '0.010UM');
        fieldValueMap.put('Has_Valid_NDA__c', true);
        
        fieldValueMapList.add(fieldValueMap);
        AccountDataFactory.createAccounts(fieldValueMapList,5);
        
        WordsForShortName__c word = new WordsForShortName__c(Name='INC', WordsToExclude__c='INC');
        insert word;
        WordsForShortName__c word1 = new WordsForShortName__c(Name='TEST', WordsToExclude__c='TEST');
        insert word1;
    }
    
    static testMethod void runTest1() {
        Account acc = getAccount('MYTEST ACCOUNT1');
           
    }
    
    
    static testMethod void runTest2() {
        Account acc = getAccount('MYTEST ACCOUNT1');
 
        test.startTest();
        
        acc.Short_Name__c = 'test_*';
        
        try{
            update acc;
        }catch(Exception e){
             System.assert(e.getMessage().contains('Short name can only contain characters, numbers, -, _ '));
        }
        
        acc.Short_Name__c = '1';
        try{
            update acc;
        }catch(Exception e){
             System.assert(e.getMessage().contains('Shortname should be more than 1 character'));
        }
        
        acc.Short_Name__c = 'test726';
        acc.Siebel_Status__c = 'ERROR';
        acc.Account_Present_In_OT__c = false;
        acc.Valid_Tech_Geos__c = '0.010UM';
        acc.Tech_Geo_Granted__c = '0.007UM';
        acc.Has_Valid_NDA__c = false;
        
        try{
            update acc;
        }catch(Exception e){
             System.assert(e.getMessage().contains('Short Name can not be modified'));
        }
        
        test.stopTest();
    }
    
    static testMethod void runShortNameTest() {
        Account acc = getAccount('MYTEST ACCOUNT1');
        
        test.startTest();
        
        acc.Short_Name__c = 'test_*';
        try{
            update acc;
        }catch(Exception e){
             System.assert(e.getMessage().contains('Short name can only contain characters, numbers, -, _ '));
        }
        
        acc.Short_Name__c = '1';
        try{
            update acc;
        }catch(Exception e){
             System.assert(e.getMessage().contains('Shortname should be more than 1 character'));
        }
        
        acc.Short_Name__c = 'test726';
        try{
            update acc;
        }catch(Exception e){
             System.assert(e.getMessage().contains('Short Name can not be modified'));
        }
        
        test.stopTest();
    }
        
    static testMethod void runTest3() {
        Account acc = getAccount('MYTEST ACCOUNT56');
        
        test.startTest();
        
        acc.Financial_Territory_Change_Request__c = 'Japan Korea';
        acc.Financial_Territory__c =  'Japan Korea';
        try{
            update acc;
        }catch(Exception e){
             System.assert(e.getMessage().contains('Territory can not be modified because territory change request has been initiated'));
        }
        
        
        test.stopTest();
    }
    
    static testMethod void runTest4() {
        Account acc = getAccount('MYTEST ACCOUNT1');
        
        test.startTest();
        
        acc.Approval_Request__c='Invoice Term Change';
        acc.Approval_Status__c='Approved';
        acc.Invoice_Term_Change_Request__c = 'Shipping Date';
        acc.New_Organization_Unit_Request__c = 'sg';
        try{
            update acc;
        }catch(Exception e){
             System.assert(e.getMessage().contains('Duplicate Organization Unit is not allowed'));
        }
        
        
        test.stopTest();
    }
    
    static testMethod void runTest5() {
        Account acc = getAccount('MYTEST ACCOUNT1');
        acc.Copy_Address__c = false;
        acc.Stage__c='Inactive';
        test.startTest();
        
        try{
            update acc;
        }catch(Exception e){
             System.assert(e.getMessage().contains('Bill to Address 1, Bill to City and Bill to Country fields are required. Please enter a value on the fields OR tick Copy Corporate Address checkbox'));
        }
        
        
        test.stopTest();
    }
    
    static testMethod void runTest6() {
        Account acc = getAccount('MYTEST ACCOUNT1');
        
        test.startTest();
        
        acc.Name = 'GLOBALFOUNDRIES';
        acc.Site_Department__c = 'HQ';
        try{
            update acc;
        }catch(Exception e){
             System.assert(e.getMessage().contains('Account Name and Site must be unqiue'));
        }
        
        
        test.stopTest();
    }
    
    static testMethod void runTest7() {
        Account acc = getAccount('MYTEST ACCOUNT1');
        
        test.startTest();
        acc.Approval_Request__c='Account Details Change';
        acc.Approval_Status__c='Approved';
        //acc.Financial_Territory__c = 'Japan Korea';
        acc.Account_Name_Change_Request__c = 'NewTesting725';
        //acc.Region_Change_Request__c = 'US';
        //acc.Financial_Territory_Change_Request__c = 'QUALCOMM';
        acc.Region_Change_Request__c = 'US-West';
        acc.Financial_Territory_Change_Request__c = 'US-West';        
        acc.Bill_To_Address_1_Change_Request__c = '52ewe';
        acc.Bill_To_Address_2_Change_Request__c = 'ewew232';
        acc.Bill_To_Address_3_Change_Request__c = '242www';
        acc.Bill_To_Address_4_Change_Request__c = '232dweww';
        acc.Bill_To_City_Change_Request__c = 'NY';
        acc.Bill_To_Country__c = 'JP';
        acc.Bill_To_State__c = 'TK';
        acc.Bill_To_Country_Change_Request__c = 'JP';
        acc.Bill_To_Location_Change_Request__c = 'TKY';

        Account_Address__c addObj2 = new Account_Address__c();
         addObj2.Account__c = acc.id;
         addObj2.Nuclear_Fuel_Related_Activity__c = 'No';
         addObj2.Country__c = 'Austria';
         addObj2.Type__c = 'Bill To Address';
         addObj2.Shipments_exported_from_USA__c = 'Yes';
         addObj2.Who_will_be_Exporter_of_Record__c = 'Customer';
         addObj2.Ship_to_VAT_Registration_Number__c = 1232;
         addObj2.Airport_IATA_code__c = 'sgtTest';    
         addObj2.Is_Primary_Address__c = false;
         addObj2.Status__c = 'Approved';
         insert addObj2;
         
         acc.Primary_Bill_To_Address_Change_Request__c = addObj2.Id;        
        update acc;
        
        test.stopTest();
    }
    
    
    
    static testMethod void runTest8() {
        Account acc = getAccount('MYTEST ACCOUNT1');
        
        acc.Account_Profile__c = 'Fabless - Emerging';
        acc.Invoice_Term__c = 'Booking Date';
        acc.Market_Segment__c = 'Automotive';
        acc.Process_Tech_Interested__c = 'Mature (>0.11um)';
        acc.Total_Employee__c = 20;
        acc.End_Customer__c = 'unknown';
        acc.Sales_Group__c = 'GC-GROUP1';
        acc.Account_Manager__c = [SELECT Id FROM User WHERE IsActive=true LIMIT 1].Id;
        
        acc.Bill_To_Location__c =  'sg';
        acc.Target_Account__c = 'Yes';
        acc.Revenue_Potential__c = 'High Potential';
        acc.Total_Employee__c = 100;
        acc.Bill_To_Address_1__c = 'addr bill1';
        acc.Bill_To_City__c = 'bang';
        acc.Bill_To_Country__c = 'India';
        acc.Sales_Territory__c = 'AMD';
        update acc;
        
        
        list<user> ulist = [select id from user where isactive = true and profile.UserType = 'Standard' and id != :UserInfo.getUserId() limit 5];
        Account_Team_Proxy__c atp = new Account_Team_Proxy__c(User__c = ulist[4].id,Account__c=acc.id,Account_Access__c='Read/Write',flag_for_delete__c = false,Opportunity_Access__c='Read/Write',Team_Role__c='Primary Account Manager',Sequence_No__c='1',Account_Role_ID__c='test');
        Account_Team_Proxy__c atp1 = new Account_Team_Proxy__c(User__c = ulist[0].id,Account__c=acc.id,Account_Access__c='Read/Write',flag_for_delete__c = false,Opportunity_Access__c='Read/Write',Team_Role__c='Backup Customer Service Rep',Sequence_No__c='1',Account_Role_ID__c='test');
        Account_Team_Proxy__c atp2 = new Account_Team_Proxy__c(User__c = ulist[1].id,Account__c=acc.id,Account_Access__c='Read/Write',flag_for_delete__c = false,Opportunity_Access__c='Read/Write',Team_Role__c='Primary Customer Service Rep',Sequence_No__c='1',Account_Role_ID__c='test');
        Account_Team_Proxy__c atp3 = new Account_Team_Proxy__c(User__c = ulist[2].id,Account__c=acc.id,Account_Access__c='Read/Write',flag_for_delete__c = false,Opportunity_Access__c='Read/Write',Team_Role__c='Primary Field Engineer',Sequence_No__c='1',Account_Role_ID__c='test');
        //Account_Team_Proxy__c atp41 = new Account_Team_Proxy__c(User__c = ulist[2].id,Account__c=acc.id,Account_Access__c='Read/Write',flag_for_delete__c = false,Opportunity_Access__c='Read/Write',Team_Role__c='Backup Customer Service Rep',Sequence_No__c='1',Account_Role_ID__c='test');
        //Account_Team_Proxy__c atp51 = new Account_Team_Proxy__c(User__c = ulist[2].id,Account__c=acc.id,Account_Access__c='Read/Write',flag_for_delete__c = false,Opportunity_Access__c='Read/Write',Team_Role__c='Primary Field Engineer',Sequence_No__c='1',Account_Role_ID__c='test');
        
        
        test.startTest();
        insert new list<Account_Team_Proxy__c>{atp, atp1, atp2, atp3};
        
        acc.Approval_Request__c = 'Promote to Authorized';
        acc.Approval_Status__c='Approved';
        
        update acc;
        
        Account_Team_Proxy__c atp4 = new Account_Team_Proxy__c(User__c = ulist[3].id,Account__c=acc.id,flag_for_delete__c = false,Account_Access__c='Read/Write',Opportunity_Access__c='Read/Write',Team_Role__c='Primary Field Application Engineer',Sequence_No__c='1',Account_Role_ID__c='test');
        atp3.Team_Role__c = 'Planning';
        
        AccountTriggerRun.skipATPValidation = true;
        insert atp4;
        AccountTriggerRun.skipATPValidation = false;
        update atp3;
        
        acc.Stage__c = 'Authorized';
        acc.Copy_Address__c = false;
        //acc.primary_contact__c = testContact.Id;
        update acc;
        
        Account_TriggerHelper helper = new Account_TriggerHelper();       
        test.stopTest();
    } 
    
    static testMethod void runTest9() {
        Account acc = getAccount('MYTEST ACCOUNT1');
        
        test.startTest();
        list<user> ulist = [select id from user where isactive = true and profile.UserType = 'Standard' and id != :UserInfo.getUserId() limit 2];
        acc.ownerId = ulist[0].id;
        acc.Financial_Territory__c =  'Japan Korea';
        //acc.Customer_Portal_Admin__c = ulist[1].id;
        update acc;
        
        test.stopTest();
    }
    
    static testMethod void runTest10() {
        Account acc = getAccount('MYTEST ACCOUNT1');
        
        test.startTest();
        acc.New_Organization_Unit_Request__c = 'gf2';
        update acc;
        
        acc.Stage__c = 'Inactive';
        update acc;
        test.stopTest();
    }
    
    static testMethod void runTest11() {
        Account acc = getAccount('MYTEST ACCOUNT1');
        
        acc.Invoice_Term__c = 'Booking Date';
        acc.Organization_Unit__c = 'GF Investment LLC OU';
        //acc.ParentId = [SELECT Id FROM Account WHERE ParentId = null LIMIT 1].Id;
        acc.ParentId = getAccount('MYTEST ACCOUNT2').id;
        update acc;
               
        test.startTest();
        acc.ParentId = [SELECT Id FROM Account WHERE Id != :acc.ParentId AND Id != :acc.Id AND ParentId = null LIMIT 1].Id;
        AccountTriggerRun.customerNo = 1;
        update acc;
        
        test.stopTest();
    }
    
  /*  static testMethod void runTest12() {
        Account acc = getAccount('MYTEST ACCOUNT1');
        acc.Invoice_Term__c = 'Booking Date';
        acc.Organization_Unit__c = 'GF Investment LLC OU';
        //acc.ParentId = [SELECT Id FROM Account WHERE ParentId = null LIMIT 1].Id;
        acc.ParentId = getAccount('MYTEST ACCOUNT2').id;
        //acc.Customer_Portal_Admin__c = [SELECT Id FROM User WHERE IsActive = true LIMIT 1].Id;
       test.startTest();
        update acc;
               
        
        
        Contact con1 = new Contact(
            firstName = 'Test1',
            lastName = 'Contact1',
            email = 'test1@test.com',
            accountId = acc.Id,
            is_portal_user_active__c = true,
            is_portal_user_created__c = true,
            role__c = 'Customers My Device Admin',
            Department__c = 'Design'
        );
        insert con1;
        
        User portalUser1 = new User(
            contactId = con1.Id,
            firstName = 'Test1',
            lastName = 'Contact1',
            email = 'test1@test.com',
            emailencodingkey='UTF-8',           
            communityNickname = 'Contact_'+math.random(),
            languagelocalekey='en_US',
            localesidkey='en_US',
            alias = 'portUsr1',
            profileId = [SELECT Id FROM Profile WHERE Name = :System.Label.OverageCustomerPortalAdmin].Id,
            timezonesidkey='America/Los_Angeles', 
            username='testing001@test.com',
            FederationIdentifier='Test20151'
        );
        insert portalUser1;
        
        acc.Customer_Portal_Admin__c = portalUser1.Id;
        update acc;
        */
       
        
     /*   Contact con2 = new Contact(
            firstName = 'Test2zzz',
            lastName = 'Contact2zzz',
            email = 'test2@test.com',
            accountId = acc.Id,
            is_portal_user_active__c = true,
            is_portal_user_created__c = true,
            role__c = 'Customers My Device Admin',
            Department__c = 'Design'
        );
        insert con2;
        
        User portalUser2 = new User(
            contactId = con2.Id,
            firstName = 'Test2zzz',
            lastName = 'Contact2zzz',
            email = 'test2@test.com',
            emailencodingkey='UTF-8',           
            communityNickname = 'Contact_'+math.random(),
            languagelocalekey='en_US',
            localesidkey='en_US',
            alias = 'portUsr2',
            profileId = [SELECT Id FROM Profile WHERE Name = :System.Label.OverageCustomerPortalAdmin].Id,
            timezonesidkey='America/Los_Angeles', 
            username='testing002@test.com',
            FederationIdentifier='Test20152'
        );
        insert portalUser2;*/
        
        //acc.Customer_Portal_Admin__c = portalUser2.Id;
       // update acc;
        // test.stopTest();
        
    //}
     public static Id createMaskSetTtitle(){
        Map<String,Object> fieldValueMap = new Map<String,Object>();
        fieldValueMap.put('Name','DMSTL12');
        fieldValueMap.put('Reticle_Type__c','Multi Layer Reticle (MLR)');
        return MaskSetTitleDataFactory.createMaskSetTitle(fieldValueMap).Id;
    }
    
    static testMethod void runTest14() {
        Account acc = getAccount('MYTEST ACCOUNT1');
        
        test.startTest();
            try {
                AccountTriggerRun.isAddressValidated = false;
                update acc;
            } catch (Exception e) {
            }
        test.stopTest();
    }
    
    static testMethod void runTest15() {
        test.startTest();
        
        Account acc = getAccount('MYTEST ACCOUNT1');
        
        Account acc1 = getAccount('MYTEST ACCOUNT2');
        acc1.Account_Type__c = 'Enablement Partner';
        update acc1;
        
        Account acc2 = getAccount('MYTEST ACCOUNT3');
        acc2.Account_Type__c = 'GLOBALFOUNDRIES Internal';
        update acc2;
        
        Account acc3 = getAccount('MYTEST ACCOUNT4');
        acc3.Account_Type__c = 'Reseller';
        update acc3;

        test.stopTest();
    }
    
    static testMethod void runTest16() {
        Account acc = getAccount('MYTEST ACCOUNT1');
        acc.copy_address__c = false;
        update acc;
        
        test.startTest();
        acc.Approval_Request__c='Account Details Change';
        acc.Approval_Status__c='Approved';        
        //acc.Financial_Territory__c = 'Japan Korea';
        acc.Account_Name_Change_Request__c = 'NewTesting725';
        acc.Region_Change_Request__c = 'ASIC';
        acc.Financial_Territory_Change_Request__c = 'NA-A';
        acc.Bill_To_Address_1_Change_Request__c = '52ewe';
        acc.Bill_To_Address_2_Change_Request__c = 'ewew232';
        acc.Bill_To_Address_3_Change_Request__c = '242www';
        acc.Bill_To_Address_4_Change_Request__c = '232dweww';
        acc.Bill_To_City_Change_Request__c = 'NY';
        acc.Bill_To_Country__c = 'JP';
        acc.Bill_To_State__c = 'TKY';
        acc.Bill_To_Country_Change_Request__c = 'JP';
        acc.Bill_To_Location_Change_Request__c = 'TKY';
        
        update acc;

        test.stopTest();
    }  
 
    static testMethod void runTest17() {
        Account acc = getAccount('MYTEST ACCOUNT1');
        acc.Copy_Address__c = false;
        update acc;
        
        test.startTest();
        acc.Approval_Request__c='Account Details Change';
        acc.Approval_Status__c='Approved';
        //acc.Financial_Territory__c = 'Japan Korea';
        acc.Account_Name_Change_Request__c = 'NewTesting725';
        acc.Region_Change_Request__c = 'ASIC';
        acc.Financial_Territory_Change_Request__c = 'AP-A';
        acc.Bill_To_Address_1_Change_Request__c = '52ewe';
        acc.Bill_To_Address_2_Change_Request__c = 'ewew232';
        acc.Bill_To_Address_3_Change_Request__c = '242www';
        acc.Bill_To_Address_4_Change_Request__c = '232dweww';
        acc.Bill_To_City_Change_Request__c = 'NY';
        acc.Bill_To_Country__c = 'JP';
        acc.Bill_To_State__c = 'TKY';
        acc.Bill_To_Country_Change_Request__c = 'JP';
        acc.Bill_To_Location_Change_Request__c = 'TKY';
        
        update acc;

        test.stopTest();
    }  
     
    static testMethod void runTest18() {
        Account acc = getAccount('MYTEST ACCOUNT1');
        acc.Copy_Address__c = false;
        update acc;
        
        test.startTest();
        acc.Approval_Request__c='Account Details Change';
        acc.Approval_Status__c='Approved';
        //acc.Financial_Territory__c = 'Japan Korea';
        acc.Account_Name_Change_Request__c = 'NewTesting725';
        acc.Region_Change_Request__c = 'ASIC';
        acc.Financial_Territory_Change_Request__c = 'EMEA-A';
        acc.Bill_To_Address_1_Change_Request__c = '52ewe';
        acc.Bill_To_Address_2_Change_Request__c = 'ewew232';
        acc.Bill_To_Address_3_Change_Request__c = '242www';
        acc.Bill_To_Address_4_Change_Request__c = '232dweww';
        acc.Bill_To_City_Change_Request__c = 'NY';
        acc.Bill_To_Country__c = 'JP';
        acc.Bill_To_State__c = 'TKY';
        acc.Bill_To_Country_Change_Request__c = 'JP';
        acc.Bill_To_Location_Change_Request__c = 'TKY';
        
        update acc;

        test.stopTest();
    } 
     
    static testMethod void runTest19() {
        Account acc = getAccount('MYTEST ACCOUNT1');
        acc.Copy_Address__c = false;
        update acc;
        
        test.startTest();
        acc.Approval_Request__c='Account Details Change';
        acc.Approval_Status__c='Approved';
        //acc.Financial_Territory__c = 'Japan Korea';
        acc.Account_Name_Change_Request__c = 'NewTesting725';
        acc.Region_Change_Request__c = 'ASIC';
        acc.Financial_Territory_Change_Request__c = 'JP-A';
        acc.Bill_To_Address_1_Change_Request__c = '52ewe';
        acc.Bill_To_Address_2_Change_Request__c = 'ewew232';
        acc.Bill_To_Address_3_Change_Request__c = '242www';
        acc.Bill_To_Address_4_Change_Request__c = '232dweww';
        acc.Bill_To_City_Change_Request__c = 'NY';
        acc.Bill_To_Country__c = 'JP';
        acc.Bill_To_State__c = 'TKY';
        acc.Bill_To_Country_Change_Request__c = 'JP';
        acc.Bill_To_Location_Change_Request__c = 'TKY';
        
        update acc;

        test.stopTest();
    } 
    
    static testMethod void runTest20() {
        Account acc = getAccount('MYTEST ACCOUNT1');
        acc.Copy_Address__c = false;
        update acc;
                
        test.startTest();
        acc.Approval_Request__c='Account Details Change';
        acc.Approval_Status__c='Approved';
        //acc.Financial_Territory__c = 'Japan Korea';
        acc.Account_Name_Change_Request__c = 'NewTesting725';
        acc.Region_Change_Request__c = 'US-East';
        acc.Financial_Territory_Change_Request__c = 'US-East';
        acc.Bill_To_Address_1_Change_Request__c = '52ewe';
        acc.Bill_To_Address_2_Change_Request__c = 'ewew232';
        acc.Bill_To_Address_3_Change_Request__c = '242www';
        acc.Bill_To_Address_4_Change_Request__c = '232dweww';
        acc.Bill_To_City_Change_Request__c = 'NY';
        acc.Bill_To_Country__c = 'JP';
        acc.Bill_To_State__c = 'TKY';
        acc.Bill_To_Country_Change_Request__c = 'JP';
        acc.Bill_To_Location_Change_Request__c = 'TKY';
        update acc;

        test.stopTest();
    }        
    static testMethod void runTest21() {
        Account acc = getAccount('MYTEST ACCOUNT1');
        acc.Copy_Address__c = false;
        update acc;
        
        test.startTest();
        acc.Approval_Request__c='Account Details Change';
        acc.Approval_Status__c='Approved';
        //acc.Financial_Territory__c = 'Japan Korea';
        acc.Account_Name_Change_Request__c = 'NewTesting725';
        acc.Region_Change_Request__c = 'US-West';
        acc.Financial_Territory_Change_Request__c = 'US NW';
        acc.Bill_To_Address_1_Change_Request__c = '52ewe';
        acc.Bill_To_Address_2_Change_Request__c = 'ewew232';
        acc.Bill_To_Address_3_Change_Request__c = '242www';
        acc.Bill_To_Address_4_Change_Request__c = '232dweww';
        acc.Bill_To_City_Change_Request__c = 'NY';
        acc.Bill_To_Country__c = 'JP';
        acc.Bill_To_State__c = 'TKY';
        acc.Bill_To_Country_Change_Request__c = 'JP';
        acc.Bill_To_Location_Change_Request__c = 'TKY';
        
        update acc;

        test.stopTest();
    } 
    static testMethod void runTest22() {
        Account acc = getAccount('MYTEST ACCOUNT1');
        acc.Copy_Address__c = false;
        update acc;
        
        test.startTest();
        acc.Approval_Request__c='Account Details Change';
        acc.Approval_Status__c='Approved';
        //acc.Financial_Territory__c = 'Japan Korea';
        acc.Account_Name_Change_Request__c = 'NewTesting725';
        acc.Region_Change_Request__c = 'US-SoCal';
        acc.Financial_Territory_Change_Request__c = 'US SoCal1';
        acc.Bill_To_Address_1_Change_Request__c = '52ewe';
        acc.Bill_To_Address_2_Change_Request__c = 'ewew232';
        acc.Bill_To_Address_3_Change_Request__c = '242www';
        acc.Bill_To_Address_4_Change_Request__c = '232dweww';
        acc.Bill_To_City_Change_Request__c = 'NY';
        acc.Bill_To_Country__c = 'JP';
        acc.Bill_To_State__c = 'TKY';
        acc.Bill_To_Country_Change_Request__c = 'JP';
        acc.Bill_To_Location_Change_Request__c = 'TKY';
        
        update acc;

        test.stopTest();
    }   
    static testMethod void runTest23() {
        Account acc = getAccount('MYTEST ACCOUNT1');
        acc.Copy_Address__c = false;
        update acc;
        
        test.startTest();
        acc.Approval_Request__c='Account Details Change';
        acc.Approval_Status__c='Approved';
        //acc.Financial_Territory__c = 'Japan Korea';
        acc.Account_Name_Change_Request__c = 'NewTesting725';
        acc.Region_Change_Request__c = 'EUR';
        acc.Financial_Territory_Change_Request__c = 'EMEA-ROA';
        acc.Bill_To_Address_1_Change_Request__c = '52ewe';
        acc.Bill_To_Address_2_Change_Request__c = 'ewew232';
        acc.Bill_To_Address_3_Change_Request__c = '242www';
        acc.Bill_To_Address_4_Change_Request__c = '232dweww';
        acc.Bill_To_City_Change_Request__c = 'NY';
        acc.Bill_To_Country__c = 'JP';
        acc.Bill_To_State__c = 'TKY';
        acc.Bill_To_Country_Change_Request__c = 'JP';
        acc.Bill_To_Location_Change_Request__c = 'TKY';
        
        update acc;

        test.stopTest();
    }  
    static testMethod void runTest24() {
        Account acc = getAccount('MYTEST ACCOUNT1');
        acc.Copy_Address__c = false;
        update acc;
        
        test.startTest();
        acc.Approval_Request__c='Account Details Change';
        acc.Approval_Status__c='Approved';
        //acc.Financial_Territory__c = 'Japan Korea';
        acc.Account_Name_Change_Request__c = 'NewTesting725';
        acc.Region_Change_Request__c = 'APJ';
        acc.Financial_Territory_Change_Request__c = 'Greater China';
        acc.Bill_To_Address_1_Change_Request__c = '52ewe';
        acc.Bill_To_Address_2_Change_Request__c = 'ewew232';
        acc.Bill_To_Address_3_Change_Request__c = '242www';
        acc.Bill_To_Address_4_Change_Request__c = '232dweww';
        acc.Bill_To_City_Change_Request__c = 'NY';
        acc.Bill_To_Country__c = 'JP';
        acc.Bill_To_State__c = 'TKY';
        acc.Bill_To_Country_Change_Request__c = 'JP';
        acc.Bill_To_Location_Change_Request__c = 'TKY';
        
        update acc;

        test.stopTest();
    }
    static testMethod void runTest25() {
        Account acc = getAccount('MYTEST ACCOUNT1');
        acc.Copy_Address__c = false;
        update acc;
        
        test.startTest();
        acc.Approval_Request__c='Account Details Change';
        acc.Approval_Status__c='Approved';
        //acc.Financial_Territory__c = 'Japan Korea';
        acc.Account_Name_Change_Request__c = 'NewTesting725';
        acc.Region_Change_Request__c = 'APJ';
        acc.Financial_Territory_Change_Request__c = 'Japan Korea';
        acc.Bill_To_Address_1_Change_Request__c = '52ewe';
        acc.Bill_To_Address_2_Change_Request__c = 'ewew232';
        acc.Bill_To_Address_3_Change_Request__c = '242www';
        acc.Bill_To_Address_4_Change_Request__c = '232dweww';
        acc.Bill_To_City_Change_Request__c = 'NY';
        acc.Bill_To_Country__c = 'JP';
        acc.Bill_To_State__c = 'TKY';
        acc.Bill_To_Country_Change_Request__c = 'JP';
        acc.Bill_To_Location_Change_Request__c = 'TKY';
        
        update acc;

        test.stopTest();
    }
    static testMethod void runTest26() {
        Account acc = getAccount('MYTEST ACCOUNT1');
        acc.Copy_Address__c = false;
        update acc;
        
        test.startTest();
        acc.Approval_Request__c='Account Details Change';
        acc.Approval_Status__c='Approved';
        //acc.Financial_Territory__c = 'Japan Korea';
        acc.Account_Name_Change_Request__c = 'NewTesting725';
        acc.Region_Change_Request__c = 'A&D';
        acc.Financial_Territory_Change_Request__c = 'A&D';
        acc.Bill_To_Address_1_Change_Request__c = '52ewe';
        acc.Bill_To_Address_2_Change_Request__c = 'ewew232';
        acc.Bill_To_Address_3_Change_Request__c = '242www';
        acc.Bill_To_Address_4_Change_Request__c = '232dweww';
        acc.Bill_To_City_Change_Request__c = 'NY';
        acc.Bill_To_Country__c = 'JP';
        acc.Bill_To_State__c = 'TKY';
        acc.Bill_To_Country_Change_Request__c = 'JP';
        acc.Bill_To_Location_Change_Request__c = 'TKY';
        
        update acc;

        test.stopTest();
    }
    
    static testMethod void runTest27() {
        
        Account acc = getAccount('MYTEST ACCOUNT1');       
        
        Test.startTest();
        acc.Copy_Address__c = false;
        acc.Corporate_Address_1__c = '1';
        acc.Corporate_Address_2__c = '2';
        acc.Corporate_Address_3__c = '3';
        acc.Corporate_Address_4__c = '4';
        acc.Corporate_City__c = 'City';
        acc.Corporate_State__c = 'State';
        acc.Corporate_Postal_Zip_Code__c = '12345';
        acc.Corporate_Country__c = 'Test';
        acc.Lead_Created_By__c = UserInfo.getUserId();
        
        update acc;
        
        Test.stopTest();
    }
    
    static testMethod void runTest28() {
        
        Account acc = getAccount('MYTEST ACCOUNT1');
        
        test.startTest();
        acc.Copy_Address__c = false;
        acc.Approval_Request__c='Account Details Change';
        acc.Approval_Status__c='Approved';
        //acc.Financial_Territory__c = 'Japan Korea';
        acc.Account_Name_Change_Request__c = 'NewTesting725';
        acc.Region_Change_Request__c = 'A&D';
        acc.Bill_To_Address_1_Change_Request__c = '52ewe';
        acc.Bill_To_Address_2_Change_Request__c = 'REMOVE';
        acc.Bill_To_Address_3_Change_Request__c = 'REMOVE';
        acc.Bill_To_Address_4_Change_Request__c = 'REMOVE';
        acc.Bill_To_City_Change_Request__c = 'NY';
        acc.Bill_To_Country__c = 'JP';
        acc.Bill_To_State__c = 'TKY';
        acc.Bill_To_Country_Change_Request__c = 'JP';
        acc.Bill_To_Postal_Code_Change_Request__c = 'REMOVE';
        acc.Bill_To_Location_Change_Request__c = 'TKY';
        acc.Bill_To_State_Change_Request__c = 'Karnataka';
        
        update acc; 
        
        test.stopTest();
    }
    
    static testMethod void runTest29() {
        
        Account acc = getAccount('MYTEST ACCOUNT1');
        
        test.startTest();
        acc.Copy_Address__c = false;
        acc.Approval_Request__c='Account Details Change';
        acc.Approval_Status__c='Approved';
        //acc.Financial_Territory__c = 'Japan Korea';
        acc.Account_Name_Change_Request__c = 'NewTesting725';
        acc.Region_Change_Request__c = 'A&D';
        acc.Bill_To_Address_1_Change_Request__c = '52ewe';
        acc.Bill_To_Address_2_Change_Request__c = 'ewew232';
        acc.Bill_To_Address_3_Change_Request__c = '242www';
        acc.Bill_To_Address_4_Change_Request__c = '232dweww';
        acc.Bill_To_City_Change_Request__c = 'NY';
        acc.Bill_To_Country__c = 'USA';
        acc.Bill_To_State__c = 'TKY';
        acc.Bill_To_Country_Change_Request__c = 'JP';
        acc.Bill_To_Postal_Code_Change_Request__c = 'NOTREMOVE';
        
        update acc; 
        
        test.stopTest();
    }
   
    static testMethod void runTest31() {
        try{
            Account acc = getAccount('MYTEST ACCOUNT1');
            acc.Copy_Address__c = false;
            update acc;
            
            AccountTriggerRun.hasAccountTriggerRun = false;
            
            Account acc2 = getAccount('MYTEST ACCOUNT2');            
            
            acc2.Bill_To_Address_1__c = null;
            acc2.Bill_To_City__c = null;
            acc2.Bill_To_Country__c = null;
            acc2.Copy_Address__c = null;
            acc2.RecordTypeId = EnvironmentVariable.get('ACCT_RT_ID_CUSTOMER');
            
            AccountTriggerRun.isAddressValidated = false;
            
            update acc2;
        }
        catch(Exception e){
            
        }
        
    }
    
     static testMethod void runTest32() {
        
        Account acc = getAccount('MYTEST ACCOUNT1');        
        
        test.startTest();
        
        acc.Name = 'testing725Changed';
        acc.Stage__c = 'Authorized';
        acc.Copy_Address__c = false;
        //acc.Region_Head__c = 'Changed';
        acc.Financial_Territory__c =  'Japan Korea';
        //acc.Sales_Group__c =  'GC-GROUP2';
        //acc.ParentId = acc2.Id;
        
        try{
            update acc;
        }
        catch(Exception e){
        
        }
        
        test.stopTest();
    }
    
    static testMethod void runTest33() {
        
        Account acc = getAccount('MYTEST ACCOUNT1');
        
        test.startTest();
        
        acc.Stage__c = 'Authorized';
        acc.Region_Head__c = 'Changed';
       //acc.ParentId = acc2.Id;
        
        try{
            update acc;
        }
        catch(Exception e){
        
        }
        
        test.stopTest();
    }
    
    static testMethod void runTest34() {
        
        Account acc = getAccount('MYTEST ACCOUNT1');
        
        acc.Account_Profile__c = 'Fabless - Emerging';
        acc.Invoice_Term__c = 'Booking Date';
        acc.Market_Segment__c = 'Automotive';
        acc.Process_Tech_Interested__c = 'Mature (>0.11um)';
        acc.Total_Employee__c = 20;
        acc.End_Customer__c = 'unknown';
        acc.Sales_Group__c = 'GC-GROUP1';
        acc.Account_Manager__c = [SELECT Id FROM User WHERE IsActive=true LIMIT 1].Id;
        //acc.Region_Head__c = 'New';
        
        acc.Bill_To_Location__c =  'sg';
        acc.Target_Account__c = 'Yes';
        acc.Revenue_Potential__c = 'High Potential';
        //acc.ParentId = acc1.Id;
        update acc;
        
        test.startTest();
        
        acc.Stage__c = 'Authorized';
        acc.Sales_Group__c =  'GC-GROUP2';
        //acc.ParentId = acc2.Id;
        
        try{
            update acc;
        }
        catch(Exception e){
        
        }
        
        test.stopTest();
    }
    
    static testMethod void runTest35() {
        Account acc1 = getAccount('MYTEST ACCOUNT1');       
        Account acc2 = getAccount('MYTEST ACCOUNT2');
        
        Account acc = getAccount('MYTEST ACCOUNT3');
        
        acc.Account_Profile__c = 'Fabless - Emerging';
        acc.Invoice_Term__c = 'Booking Date';
        acc.Market_Segment__c = 'Automotive';
        acc.Process_Tech_Interested__c = 'Mature (>0.11um)';
        acc.Total_Employee__c = 20;
        acc.End_Customer__c = 'unknown';
        acc.Sales_Group__c = 'GC-GROUP1';
        acc.Account_Manager__c = [SELECT Id FROM User WHERE IsActive=true LIMIT 1].Id;
        //acc.Region_Head__c = 'New';
        
        acc.Bill_To_Location__c =  'sg';
        acc.Target_Account__c = 'Yes';
        acc.Revenue_Potential__c = 'High Potential';
        acc.ParentId = acc1.Id;
        update acc;
        
        test.startTest();
        
        acc.Stage__c = 'Authorized';
        acc.ParentId = acc2.Id;
        
        try{
            update acc;
        }
        catch(Exception e){
        
        }
        
        test.stopTest();
    }
    
    static testMethod void runTest37() {
        Account acc = getAccount('MYTEST ACCOUNT1');
        test.startTest();
        try{
            acc.approval_request__c = 'Promote to Authorized';
            acc.Bill_To_Location__c = '';
            update acc;
        }
        catch(Exception e){
        }
        test.stopTest();
    }
       
    static testMethod void runTest39(){
        Account acc = getAccount('MYTEST ACCOUNT1');

        test.startTest();
        acc.Tech_Geo_Granted__c = '0.11UM';
        acc.parentid = getAccount('MYTEST ACCOUNT3').Id;
        try{            
            update acc;
        }
        catch(Exception e){
        }     
        test.stopTest();
    }
    static testMethod void runTest40(){
        Account acc = getAccount('MYTEST ACCOUNT2');
        
        test.startTest(); 
        acc.Tech_Geo_Granted__c = '';
        try{
            update acc;
        }
        catch(Exception e){
        }
        
        test.stopTest();
    } 
    
    static testMethod void runUpdateAccountDetailTest(){
        Account acc = getAccount('MYTEST ACCOUNT1');
        
        test.startTest();
        acc.Approval_Request__c='Account Details Change';
        acc.Approval_Status__c='Approved';
        //acc.Financial_Territory__c = 'Japan Korea';
        acc.Account_Name_Change_Request__c = 'NewTesting725';
        //acc.Region_Change_Request__c = 'US';
        //acc.Financial_Territory_Change_Request__c = 'QUALCOMM';
        acc.Region_Change_Request__c = 'US-West';
        acc.Financial_Territory_Change_Request__c = 'US-West';        
        acc.Bill_To_Address_1_Change_Request__c = '52ewe';
        acc.Bill_To_Address_2_Change_Request__c = 'ewew232';
        acc.Bill_To_Address_3_Change_Request__c = '242www';
        acc.Bill_To_Address_4_Change_Request__c = '232dweww';
        acc.Bill_To_City_Change_Request__c = 'NY';
        acc.Bill_To_Country__c = 'JP';
        acc.Bill_To_State__c = 'TK';
        acc.Bill_To_Country_Change_Request__c = 'JP';
        acc.Bill_To_Location_Change_Request__c = 'TKY';

        Account_Address__c addObj2 = new Account_Address__c();
         addObj2.Account__c = acc.id;
         addObj2.Nuclear_Fuel_Related_Activity__c = 'No';
         addObj2.Country__c = 'Austria';
         addObj2.Type__c = 'Bill To Address';
         addObj2.Shipments_exported_from_USA__c = 'Yes';
         addObj2.Who_will_be_Exporter_of_Record__c = 'Customer';
         addObj2.Ship_to_VAT_Registration_Number__c = 1232;
         addObj2.Airport_IATA_code__c = 'sgtTest';    
         addObj2.Is_Primary_Address__c = false;
         addObj2.Status__c = 'Approved';
         insert addObj2;
         
         acc.Primary_Bill_To_Address_Change_Request__c = addObj2.Id;        
        update acc;
        Account_TriggerHelper helper = new Account_TriggerHelper();
        helper.updateAccountDetail(acc);
        test.stopTest();    
    }
    
    static testMethod void runAccountAddressTest(){
        Account acc = getAccount('MYTEST ACCOUNT1');
        List<Account_Address__c> addList = new List<Account_Address__c>();
        Account_Address__c addObj = new Account_Address__c();
         addObj.Account__c = acc.id;
         addObj.Nuclear_Fuel_Related_Activity__c = 'Yes';
         addObj.Country__c = 'Singapore';
         addObj.Type__c = 'Bill To Address';
         addObj.Is_Primary_Address__c = false;
         addObj.Status__c = 'Approved';
         addList.add(addObj);
         
         Account_Address__c addObj1 = new Account_Address__c();
         addObj1.Account__c = acc.id;
         addObj1.Nuclear_Fuel_Related_Activity__c = 'No';
         addObj1.Country__c = 'Singapore';
         addObj1.Type__c = 'Ship To Address';
         addObj1.Is_Primary_Address__c = true;
         addList.add(addObj1);
         
         Account_Address__c addObj2 = new Account_Address__c();
         addObj2.Account__c = acc.id;
         addObj2.Nuclear_Fuel_Related_Activity__c = 'No';
         addObj2.Country__c = 'Austria';
         addObj2.Type__c = 'Ship To Address';
         addObj2.Shipments_exported_from_USA__c = 'Yes';
         addObj2.Who_will_be_Exporter_of_Record__c = 'Customer';
         addObj2.Ship_to_VAT_Registration_Number__c = 1232;
         addObj2.Airport_IATA_code__c = 'sgtTest';         
         addList.add(addObj2);
         
         insert addList;
         
         acc.Primary_Bill_To_Address_Change_Request__c = addList[0].Id;
         update acc;
    }
	
	 static testMethod void runParentAccountTest(){
        Account acc = getAccount('MYTEST ACCOUNT1');        
        Map<String,Object> fieldValueMap = new Map<String,Object>();
        fieldValueMap = new Map<String,Object>();
        fieldValueMap.put('Name', 'MYTEST ACCOUNT234');            
        fieldValueMap.put('stage__c', 'Unqualified');        
        fieldValueMap.put('sub_type__c', 'Direct');
        fieldValueMap.put('site_department__c', 'test dept1');          
        fieldValueMap.put('transaction_type__c', 'transactional');                          
        fieldValueMap.put('region__c', 'APJ');        
        fieldValueMap.put('Corporate_Address_1__c', 'Test Address 1');          
        fieldValueMap.put('Corporate_City__c', 'Test City');                
        fieldValueMap.put('Corporate_Country__c', 'Singapore');
        fieldValueMap.put('Bill_To_Address_1__c', 'Test Address 1');          
        fieldValueMap.put('Bill_To_City__c', 'Test City');            
        fieldValueMap.put('Bill_To_Country__c', 'Singapore');        
        fieldValueMap.put('Fab_9_10__c','No');
        fieldValueMap.put('ParentId',acc.Id);
        test.startTest();
        AccountDataFactory.createAccount(fieldValueMap);
		test.stopTest();
    }  
	
	 static testMethod void runTest13() {
        Account acc = getAccount('MYTEST ACCOUNT1');
		
		test.startTest();
		
        string opptyId = DeviceUtilTest.createOpp(acc.Id, '0.10UM');
        string opptyProgramId = DeviceUtilTest.createOppProg(acc.Id, opptyId);
        string processTechnologyId = DeviceUtilTest.createProcessTechnology();
        
        Map<String,Object> fieldValueMap = new Map<String,Object>();
        fieldValueMap.put('Name','TESTDEVICEZAIH12345677');
        fieldValueMap.put('Fab__c','FAB 2');
        fieldValueMap.put('GSOP_Assignment_Tapeout_Plan__c','No');
        fieldValueMap.put('Market_Segment__c','Mobility');
        fieldValueMap.put('Semiconductor_Device__c','Analog Amplifier');
        fieldValueMap.put('End_Customer__c','Test Customer');
        fieldValueMap.put('Device_Sourcing__c','1st Source');
        fieldValueMap.put('Stage__c','Solutioning');
        fieldValueMap.put('Status__c','Active');
        fieldValueMap.put('Siebel_Device_ID__c','1234567890');
        fieldValueMap.put('Tapeout_Type__c','Single Product');
        fieldValueMap.put('PLM_Device_ID__c','ANBQP60ACO8CH-U01');
        fieldValueMap.put('CRMDID__c','CDID0000001.00');
        fieldValueMap.put('Device_Type__c','Base');
        fieldValueMap.put('End_Application__c','Testchip');
        fieldValueMap.put('Confidence_Level_Tapeout__c','50');
        fieldValueMap.put('Account__c',acc.Id);
        fieldValueMap.put('Process_Technology_2__c', processTechnologyId);
        fieldValueMap.put('Opportunity_Program__c',opptyProgramId);
        fieldValueMap.put('Enabled_via_previous_MPW_1__c','No');
        DeviceDataFactory.createDevice(fieldValueMap);
		
		acc.Region__c = 'US';
		update acc;
		test.stopTest();	
        
    }
	
	static testMethod void runTest36() {
        Account acc = getAccount('MYTEST ACCOUNT1');
        list<user> ulist = [select id from user where isactive = true and profile.UserType = 'Standard' and id != :UserInfo.getUserId() limit 3];

         test.startTest();
         List<Account_Team_Proxy__c> atpList = new List<Account_Team_Proxy__c>();
        //list<user> ulist = [select id from user where isactive = true and profile.UserType = 'Standard' and id != :UserInfo.getUserId() limit 4];
       // Account_Team_Proxy__c atp4 = new Account_Team_Proxy__c(User__c = ulist[3].id,Account__c=acc.id,Account_Access__c='Read/Write',Opportunity_Access__c='Read/Write',Team_Role__c='Primary Account Manager',Sequence_No__c='1',Account_Role_ID__c='test');
        Account_Team_Proxy__c atp1 = new Account_Team_Proxy__c(User__c = ulist[0].id,Account__c=acc.id,Account_Access__c='Read/Write',Opportunity_Access__c='Read/Write',Team_Role__c='Backup Customer Service Rep',Sequence_No__c='1',Account_Role_ID__c='test');
        Account_Team_Proxy__c atp2 = new Account_Team_Proxy__c(User__c = ulist[1].id,Account__c=acc.id,Account_Access__c='Read/Write',Opportunity_Access__c='Read/Write',Team_Role__c='Primary Customer Service Rep',Sequence_No__c='1',Account_Role_ID__c='test');
        Account_Team_Proxy__c atp3 = new Account_Team_Proxy__c(User__c = ulist[2].id,Account__c=acc.id,Account_Access__c='Read/Write',Opportunity_Access__c='Read/Write',Team_Role__c='Primary Field Engineer',Sequence_No__c='1',Account_Role_ID__c='test');
        //Account_Team_Proxy__c atp41 = new Account_Team_Proxy__c(User__c = ulist[2].id,Account__c=acc.id,Account_Access__c='Read/Write',flag_for_delete__c = false,Opportunity_Access__c='Read/Write',Team_Role__c='Backup Customer Service Rep',Sequence_No__c='1',Account_Role_ID__c='test');
        //Account_Team_Proxy__c atp51 = new Account_Team_Proxy__c(User__c = ulist[2].id,Account__c=acc.id,Account_Access__c='Read/Write',flag_for_delete__c = false,Opportunity_Access__c='Read/Write',Team_Role__c='Primary Field Engineer',Sequence_No__c='1',Account_Role_ID__c='test');
        atpList.add(atp1);
        atpList.add(atp2);
        atpList.add(atp3);
        insert atpList;
        
        Contact con2 = new Contact(
            firstName = 'Test2zzz',
            lastName = 'Contact2zzz',
            email = 'test2@test.com',
            accountId = acc.Id,
            role__c = 'Customers My Device Admin',
            Department__c = 'Design'
        );
        insert con2;                        
        
        acc.Account_Profile__c = 'Fabless - Emerging';
        acc.Invoice_Term__c = 'Booking Date';
        acc.Market_Segment__c = 'Automotive';
        acc.Process_Tech_Interested__c = 'Mature (>0.11um)';
        acc.Total_Employee__c = 20;
        acc.End_Customer__c = 'unknown';
        acc.Sales_Group__c = 'GC-GROUP1';
        acc.Account_Manager__c = [SELECT Id FROM User WHERE IsActive=true LIMIT 1].Id;
        acc.Primary_Contact__c = con2.id;
        
        acc.Bill_To_Location__c =  'sg';
        acc.Target_Account__c = 'Yes';
        acc.Revenue_Potential__c = 'High Potential'; 
        acc.Bill_To_Address_1__c = 'bill add1';  
        acc.Bill_To_City__c = 'bang';
        acc.Bill_To_Country__c = 'India';     
        update acc;
       
        acc.Stage__c = 'Authorized';
        acc.Fab_9_10__c = 'Yes';
        update acc;
        
        AccountDetailChange.hasRun = false;
        acc.tax_number__c = '32132';
        update acc;
        test.stopTest();
    } 
	
	static testMethod void runTest38(){
        test.startTest();
		WordsForShortName__c WTE = new WordsForShortName__c();
        WTE.Name='MYTEST';
        WTE.WordsToExclude__c ='MYTEST';
       
        insert WTE;
        Account Acc = New Account();
        Acc.Name = 'MYTEST Data';
        Acc.sub_type__c = 'Direct';
        Acc.site_department__c = 'test dept';          
        Acc.transaction_type__c = 'transactional';                          
        Acc.region__c ='APJ';        
        Acc.Corporate_Address_1__c = 'Test Address 1';          
        Acc.Corporate_City__c = 'Test City';                
        Acc.Corporate_Country__c ='Singapore';
        Acc.Copy_Address__c = true;                             
        Acc.Fab_9_10__c = 'No';
        Acc.Account_Type__c ='Customer';
        Acc.Organization_Unit__c ='sg';
        Acc.New_Organization_Unit_Request__c = 'gf';
        Acc.Financial_Territory__c = 'Greater China';
        Acc.stage__c = 'Unqualified';
        
        Insert Acc;
        
        Account Acc1 = New Account();
        Acc1.Name = 'data12 datadata';
                //Acc1.short_Name__c = 'data04';
        Acc1.sub_type__c = 'Direct';
        Acc1.site_department__c = 'test1';          
        Acc1.transaction_type__c = 'transactional';                          
        Acc1.region__c ='APJ';        
        Acc1.Corporate_Address_1__c = 'Test Address 1';          
        Acc1.Corporate_City__c = 'Test City';                
        Acc1.Corporate_Country__c ='Singapore';
        Acc1.Copy_Address__c = true;                             
        Acc1.Fab_9_10__c = 'No';
        Acc1.Account_Type__c ='Customer';
        Acc1.Organization_Unit__c ='sg';
        Acc1.New_Organization_Unit_Request__c = 'gf';
        Acc1.Financial_Territory__c = 'Greater China';
        Acc1.stage__c = 'Unqualified';
        try{
            Insert Acc1;
        }catch(Exception ex){}
		test.stopTest();
    }    
      
    private static Account getAccount(string AccountName)
    {
        Account acct = [SELECT Id, Name FROM Account Where Name =: AccountName];
        
        return acct;
    }     
}