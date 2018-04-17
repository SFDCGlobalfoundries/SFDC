/*
    Author: Ariz Solito
    Description: Apex test class for ExposeDeviceToCustomer
    History: 
        Asolito     06172013    - Code creation.
        Nbustillos  10122013    - Added call to loadEnvironmentVariables() method.
                                - Updated annotation to SeeAllData=false  
        ZAmbat      04022014    - Updated due to change in ExposeDeviceToCustomer class.
        Tlai        29052014    - SeeAllData = true
*/
@isTest(SeeAllData=false)
private class ExposeDeviceToCustomer_Test {
    @testSetup static void testdata() {
        DataUtilTest.loadEnvironmentVariables();
        
        /*
        List<Map<String,Object>> fieldValueMapList = new List<Map<String,Object>>();
        for(integer i=1;i<=2;i++){
            Map<String,Object> fieldValueMap = new Map<String,Object>();
            fieldValueMap.put('Name', 'MYTEST ACCOUNT'+i);            
            fieldValueMap.put('short_name__c', 'epctest111'+i);        
            fieldValueMap.put('sub_type__c', 'Direct');
            fieldValueMap.put('site_department__c', 'test dept');          
            fieldValueMap.put('transaction_type__c', 'transactional');                          
            fieldValueMap.put('region__c', 'US');        
            fieldValueMap.put('Corporate_Address_1__c', 'Test Address 1');          
            fieldValueMap.put('Corporate_City__c', 'Test City');                
            fieldValueMap.put('Corporate_Country__c', 'India');
            fieldValueMap.put('Bill_To_Address_1__c', 'Test Address 1');          
            fieldValueMap.put('Bill_To_City__c', 'Test City');            
            fieldValueMap.put('Bill_To_Country__c', 'Indi');        
            fieldValueMap.put('Fab_9_10__c','No');
            fieldValueMap.put('Account_Type__c','Customer');
            fieldValueMapList.add(fieldValueMap);
        }
        AccountDataFactory.createAccounts(fieldValueMapList,2);
        */
        
        Test.startTest();
        
        Map<String,Object> fieldValueMap = new Map<String,Object>();
        fieldValueMap.put('Name', 'MYTEST ACCOUNT1');            
        fieldValueMap.put('short_name__c', 'epctest1111');        
        fieldValueMap.put('sub_type__c', 'Direct');
        fieldValueMap.put('site_department__c', 'test dept');          
        fieldValueMap.put('transaction_type__c', 'transactional');                          
        fieldValueMap.put('region__c', 'US');        
        fieldValueMap.put('Corporate_Address_1__c', 'Test Address 1');          
        fieldValueMap.put('Corporate_City__c', 'Test City');                
        fieldValueMap.put('Corporate_Country__c', 'India');
        fieldValueMap.put('Bill_To_Address_1__c', 'Test Address 1');          
        fieldValueMap.put('Bill_To_City__c', 'Test City');            
        fieldValueMap.put('Bill_To_Country__c', 'Indi');        
        fieldValueMap.put('Fab_9_10__c','No');
        fieldValueMap.put('Account_Type__c','Customer');
        
        Account accountObj1 = AccountDataFactory.createAccount(fieldValueMap);
        
        fieldValueMap = new Map<String,Object>();
        fieldValueMap.put('Name', 'MYTEST ACCOUNT2');            
        fieldValueMap.put('short_name__c', 'epctest1112');        
        fieldValueMap.put('sub_type__c', 'Direct');
        fieldValueMap.put('site_department__c', 'test dept');          
        fieldValueMap.put('transaction_type__c', 'transactional');                          
        fieldValueMap.put('region__c', 'US');        
        fieldValueMap.put('Corporate_Address_1__c', 'Test Address 1');          
        fieldValueMap.put('Corporate_City__c', 'Test City');                
        fieldValueMap.put('Corporate_Country__c', 'India');
        fieldValueMap.put('Bill_To_Address_1__c', 'Test Address 1');          
        fieldValueMap.put('Bill_To_City__c', 'Test City');            
        fieldValueMap.put('Bill_To_Country__c', 'Indi');        
        fieldValueMap.put('Fab_9_10__c','No');
        fieldValueMap.put('Account_Type__c','Customer');
        fieldValueMap.put('Parentid',accountObj1.Id);
        
        Account accountObj2 = AccountDataFactory.createAccount(fieldValueMap);
        
        //createContacts(new List<Contact>(accountObj1, accountObj2), 'Design');
        
        Opportunity opp = createOppty(accountObj2.Id);
        Opportunity_Program__c oppProg = createOppProg(accountObj2.id, opp.id);
        
        User faeUser = [Select id from user where profile.name = 'GF FAE/FTS' and isactive = true limit 1];
        
        createOppProgTmMem(oppProg.id, faeUser.id);
        
        createDevice(oppProg.id, accountObj1.Id);
        
        Test.stopTest();
    }
    
    static Id createOpportunity(Id testAcctId) {
        Map<String,Object> fieldValueMap = new Map<String,Object>();
        fieldValueMap.put('AccountId',testAcctId);
        fieldValueMap.put('Name','Test Opportunity');  
        fieldValueMap.put('StageName','1. Discovery');
        fieldValueMap.put('CloseDate',date.newinstance(2012, 12, 21));  
        fieldValueMap.put('Target_Process_Node__c','14XM');
        fieldValueMap.put('Market_Segment__c','Automotive');  
        fieldValueMap.put('Process_Platform__c','GF Baseline');
        fieldValueMap.put('Fab_Split__c',100);          
        fieldValueMap.put('Process_Geometry__c','0.014UM');  
        fieldValueMap.put('Process_Family__c','XM');
        fieldValueMap.put('Opportunity_Sourcing_Type__c','First Source');  
        fieldValueMap.put('Fab_Assignment_1__c','FAB 1');
         
        return OpportunityDataFactory.createOpportunity(fieldValueMap).id;
        
    }
    
    static Id createOpportunityProgram(Id testAcctId, Id testOpptyId) {
        Opportunity_Program__c opProg = new Opportunity_Program__c(
            Name='Test OppProg',
            Account__c=testAcctId,
            Opportunity__c=testOpptyId
        );
        
        insert opProg;
        return opProg.Id;
    }
    
    static id createProcessTechnology() {
        Process_Technology__c p = new Process_Technology__c(
            name = 'testPT',
            PT_number__c = 'PT12323'
        );
        
        insert p;
        return p.Id;
    }
    static list<account> createAccounts(){
        Account acc = getAccount('MYTEST ACCOUNT1');
        
        Account acc2 = getAccount('MYTEST ACCOUNT2');
        acc2.Parentid = acc.id;
        update acc2;
        
        return new list<account>{acc, acc2};
    }
    
    
    
    static list<Contact> createContacts(list<account> accts, string dep){
        Contact con = new Contact(
            firstName = 'Test'+ String.valueOf(system.now().millisecond()),
            lastName = 'Contact',
            email = 'test@test.com',
            accountId = accts[0].id,
            is_portal_user_active__c = true,
            is_portal_user_created__c = true,
            role__c = 'Customers My Device Admin',
            Department__c = dep
        );
        
        Contact con2 = new Contact(
            firstName = 'Test2'+ String.valueOf(system.now().millisecond()),
            lastName = 'Contact',
            email = 'test2@test.com',
            accountId = accts[1].id,
            is_portal_user_active__c = true,
            is_portal_user_created__c = true,
            role__c = 'Customers My Device Admin',
            Department__c = dep
        );
        
        list<Contact> conts = new list<Contact>{con, con2};
        
        insert conts;
        return conts;
    }
    
    static opportunity createOppty(Id acctId){
        Map<String,Object> fieldValueMap = new Map<String,Object>();
        fieldValueMap.put('AccountId',acctId);
        fieldValueMap.put('Name','Test Opportunity');  
        fieldValueMap.put('StageName','1. Discovery');
        fieldValueMap.put('CloseDate',system.today().adddays(5));  
        fieldValueMap.put('Target_Process_Node__c','14XM');
        fieldValueMap.put('Market_Segment__c','Automotive');  
        fieldValueMap.put('Process_Platform__c','GF Baseline');
        fieldValueMap.put('Opportunity_Health__c','On Track');          
        fieldValueMap.put('Process_Geometry__c','0.014UM');  
        fieldValueMap.put('Process_Family__c','XM');
        fieldValueMap.put('Opportunity_Sourcing_Type__c','First Source');  
        fieldValueMap.put('Fab_Assignment_1__c','FAB 1');
        fieldValueMap.put('End_Application_for_Opty__c','Medical');
        fieldValueMap.put('Production_Confidence__c','30%');
         
        return OpportunityDataFactory.createOpportunity(fieldValueMap);
        
    }
    
    static Opportunity_Program__c createOppProg(Id acctId,Id oppId){
        Opportunity_Program__c opProg = new Opportunity_Program__c(Name='Test OppProg',Account__c=acctId,Opportunity__c=oppId);
        insert opProg;
        return opProg;
    }
    
    static Opportunity_Program_Team_Member__c createOppProgTmMem(Id oppProgId, Id userId){
        Opportunity_Program_Team_Member__c oppProgTM = new Opportunity_Program_Team_Member__c(Core_Team_Member__c=false,
                                        Device_Access__c='Read/Write',Opportunity_Program_Access__c='Read/Write',
                                        Opportunity_Program__c=oppProgId,Team_Role__c='Field Application Engineer',
                                        User__c=userId,Flag_for_Delete__c=false);
        insert oppProgTM;
        return oppProgTM;
    }
    
    static Device__c createDevice(Id oppProgId, Id accountId) {
        // Create Device
        Map<String,Object> fieldValueMap = new Map<String,Object>();
        fieldValueMap.put('Name','TESTDEVICEZAIH12345677');
        fieldValueMap.put('Opportunity_Program__c',oppProgId);
        fieldValueMap.put('Fab__c','Fab 3');
        fieldValueMap.put('GSOP_Assignment_Tapeout_Plan__c','No');
        fieldValueMap.put('Market_Segment__c','Mobility');
        fieldValueMap.put('End_Application__c','Mobile PC');
        fieldValueMap.put('Semiconductor_Device__c','Analog Amplifier');
        fieldValueMap.put('End_Customer__c','Test Customer');
        fieldValueMap.put('Device_Sourcing__c','1st Source');
        fieldValueMap.put('Stage__c','Solutioning');
        fieldValueMap.put('Status__c','Active');
        fieldValueMap.put('Tapeout_Type__c','Single Product');
        fieldValueMap.put('Geometry_Filter__c','0.014UM');
        fieldValueMap.put('Process_Family_Filter__c','XM');
        fieldValueMap.put('Account__c', accountId);
        return DeviceDataFactory.createDevice(fieldValueMap);
    }
    
    static list<User> createPortalUser(list<Contact> conts){
        User portalUser = new User(
            contactId = conts[0].id,
            firstName = 'Test',
            lastName = 'Contact',
            email = 'test@test.com',
            emailencodingkey='UTF-8',           
            communityNickname = 'Contact_'+math.random(),
            languagelocalekey='en_US',
            localesidkey='en_US',
            alias = 'portUsrT',
            profileId = '00e90000001C376',
            timezonesidkey='America/Los_Angeles', 
            username='testing01@test.com',
            FederationIdentifier='Test2015'
                    
            
        ); 
        
        User portalUser2 = new User(
            contactId = conts[1].id,
            firstName = 'Test2',
            lastName = 'Contact',
            email = 'test2@test.com',
            emailencodingkey='UTF-8',           
            communityNickname = 'Contact_'+math.random(),
            languagelocalekey='en_US',
            localesidkey='en_US',
            alias = 'portUsrT',
            profileId = '00e90000001C376',
            timezonesidkey='America/Los_Angeles', 
            username='testing02@test.com',
            FederationIdentifier='Test2016'
            
        ); 
        
        list<User> users = new list<User>{portalUser, portalUser2};
        insert users;
        
        return users;
        
              
    }
    
    static void createPTA(list<User> users, list<Account> accts, list<Boolean> IPDs, list<Boolean> ECs){
        Portal_Tab_Access__c pta =  new Portal_Tab_Access__c(Account__c = accts[0].id,
                                                            IP_Declaration__c = IPDs[0],
                                                            Export_Control__c = ECs[0],
                                                            My_Devices__c = true
                                                            );
                                                            
        Portal_Tab_Access__c pta2 =  new Portal_Tab_Access__c(Account__c = accts[1].id,
                                                            IP_Declaration__c = IPDs[1],
                                                            Export_Control__c = ECs[1],
                                                            My_Devices__c = true
                                                            );
                                                            
        insert new list<Portal_Tab_Access__c>{pta, pta2};
        pta.User__c = users[0].id;
        pta2.User__c = users[1].id;
        update new list<Portal_Tab_Access__c>{pta, pta2};
    }
    //test method for the class     
    static testMethod void testClass(){                
        //User faeUser = [Select id from user where profile.name = 'GF FAE/FTS' and isactive = true limit 1];
        //list<Account> accts = ExposeDeviceToCustomer_Test.createAccounts();
        
        List<Account> accts = [SELECT Id, Name, short_name__c FROM Account Where Name = 'MYTEST ACCOUNT1' OR Name = 'MYTEST ACCOUNT2'];
        
        list<Contact> conts = ExposeDeviceToCustomer_Test.createContacts(accts, 'Design');        
        //Opportunity opp = ExposeDeviceToCustomer_Test.createOppty(accts[1].id);
        //Opportunity_Program__c oppProg = ExposeDeviceToCustomer_Test.createOppProg(accts[1].id, opp.id);
        Opportunity_Program__c oppProg = [SELECT Id FROM Opportunity_Program__c LIMIT 1];
        
        //ExposeDeviceToCustomer_Test.createOppProgTmMem(oppProg.id, faeUser.id);
        
        //Device__c dev = ExposeDeviceToCustomer_Test.createDevice(oppProg.id);
        Device__c dev = [SELECT Id FROM Device__c LIMIT 1];
        
        list<User> users = ExposeDeviceToCustomer_Test.createPortalUser(conts);
        ExposeDeviceToCustomer_Test.createPTA(users, accts, new list<boolean>{true,false}, new list<boolean>{true,false});
        Process_Technology__c p = new Process_Technology__c(name = 'testPT', PT_number__c = 'PT12323');
        insert p;   
        FV_Beta_Account__c fba = new FV_Beta_Account__c(name = 'epctest111');
        insert fba;
        
        //expose device to customer portal
        dev.confidence_level_tapeout__c = '50';
        dev.stage__c = 'Design In';
        dev.fab__c = 'FAB 1';
        dev.expose_device_to_customer__c = true;
        dev.semiconductor_device__c = 'MEMS - RF';
        dev.siebel_device_id__c = 'testID';
        dev.process_technology_2__c = p.id;
        dev.Enabled_via_previous_MPW_1__c = 'No';
        //dev.Original_Forecasted_Tapeout_Date__c = system.today();
        Test.startTest();
        update dev;
        
        Export_Control_Form__c ecf = new Export_Control_Form__c();
        ecf.Account__c = accts[0].id;
        insert ecf;
        
        Device_Export_Control_Junction__c decj = new Device_Export_Control_Junction__c();
        decj.Device__c = dev.id;
        decj.Export_Control_Form__c = ecf.id;
        insert decj;
        
        ExposeDeviceToCustomer.ReturnMessage rm = ExposeDeviceToCustomer.validate(new list<device__c>{dev}, new set<id>{ accts[1].id});
        system.debug(rm);
        ExposeDeviceToCustomer.exposeCustomer(rm.recordsMap, false);
        ExposeDeviceToCustomer.sendEmail(rm.recordsMap, new set<id>(), new set<id>());
        
        ExposeDeviceToCustomer.RecordDetail rd = new ExposeDeviceToCustomer.RecordDetail(dev, accts[1].short_name__c);
        Map<String,List<ExposeDeviceToCustomer.RecordDetail>> rdMap = new Map<String,List<ExposeDeviceToCustomer.RecordDetail>>();
        rdMap.put(accts[1].id,new List<ExposeDeviceToCustomer.RecordDetail>{rd});
        ExposeDeviceToCustomer.exposeCustomer(rdMap, false);
        ExposeDeviceToCustomer.sendEmail(rdMap, new set<id>(), new set<id>());
        rd.addContacts(conts);
        rd.getCustomer();
        rd.getAccountAdminEmail();
        rd.getFAEEmail();
        Test.stopTest(); 
    }

    static testMethod void testRun2(){                
        
        List<Account> accts = [SELECT Id, Name, short_name__c FROM Account Where Name = 'MYTEST ACCOUNT1' OR Name = 'MYTEST ACCOUNT2'];
        List<Contact> conts = ExposeDeviceToCustomer_Test.createContacts(accts, 'Design');        
        Opportunity_Program__c oppProg = [SELECT Id FROM Opportunity_Program__c LIMIT 1];
        
        Device__c dev = [SELECT Id FROM Device__c LIMIT 1];
        
        List<User> users = ExposeDeviceToCustomer_Test.createPortalUser(conts);
        
        ExposeDeviceToCustomer_Test.createPTA(users, accts, new list<boolean>{true,false}, new list<boolean>{true,false});
        
        Process_Technology__c p = new Process_Technology__c(name = 'testPT', PT_number__c = 'PT12323');
        insert p;   
        
        FV_Beta_Account__c fba = new FV_Beta_Account__c(name = 'epctest111');
        insert fba;
        
        //expose device to customer portal
        dev.confidence_level_tapeout__c = '50';
        dev.stage__c = 'Design In';
        dev.fab__c = 'FAB 1';
        dev.expose_device_to_customer__c = true;
        dev.semiconductor_device__c = 'MEMS - RF';
        dev.siebel_device_id__c = 'testID';
        dev.process_technology_2__c = p.id;
        dev.Enabled_via_previous_MPW_1__c = 'No';
        //dev.Original_Forecasted_Tapeout_Date__c = system.today();
        Test.startTest();
        update dev;
        
        Export_Control_Form__c ecf = new Export_Control_Form__c();
        ecf.Account__c = accts[0].id;
        insert ecf;
        
        Device_Export_Control_Junction__c decj = new Device_Export_Control_Junction__c();
        decj.Device__c = dev.id;
        decj.Export_Control_Form__c = ecf.id;
        insert decj;
        
        ExposeDeviceToCustomer.ReturnMessage rm = ExposeDeviceToCustomer.validate(new list<device__c>{dev}, new set<id>{ accts[1].id});
        system.debug(rm);
        ExposeDeviceToCustomer.exposeCustomer(rm.recordsMap, false);
        ExposeDeviceToCustomer.sendEmail(rm.recordsMap, new set<id>(), new set<id>());
        
        ExposeDeviceToCustomer.RecordDetail rd = new ExposeDeviceToCustomer.RecordDetail(dev, accts[1].short_name__c);
        rd.getCustomer();
        rd.addContacts(conts);
        rd.getCustomer();
        List<Opportunity_Program_Team_Member__c> optmList = [SELECT Id, User__r.Email FROM Opportunity_Program_Team_Member__c];
        for(Integer i = 0; i < 30; i++){
            optmList.add(optmList[0]);
        }
        rd.addTeamMembers(optmList);
        rd.getCustomerEmail(new Set<string>{}, new Set<string>{}, new Set<Id>{conts[0].Id, conts[1].Id}, new Set<Id>{conts[0].Id, conts[1].Id});
        rd.getFAEEmail();
        Map<String,List<ExposeDeviceToCustomer.RecordDetail>> rdMap = new Map<String,List<ExposeDeviceToCustomer.RecordDetail>>();
        rdMap.put(accts[1].id,new List<ExposeDeviceToCustomer.RecordDetail>{rd});
        ExposeDeviceToCustomer.sendEmail(rdMap, new set<id>(), new set<id>());
        ExposeDeviceToCustomer.exposeCustomer(rdMap, false);
        
        Test.stopTest(); 
    }
    
    static testMethod void testRun3(){
        
        List<Account> accountList = [SELECT Id, Name, short_name__c FROM Account WHERE Name = 'MYTEST ACCOUNT1' OR Name = 'MYTEST ACCOUNT2'];
        Device__c dev = [SELECT Id FROM Device__c LIMIT 1];
        
        Integer totalCustomer = 101;
        Integer count = 1;
        List<Contact> contactList = new List<Contact>();
        Contact tempContact;
        for(Integer i = 1; i <= totalCustomer; i++){
            
            tempContact = new Contact(
                FirstName = 'AZPP'+ String.valueOf(system.now().millisecond()),
                LastName = 'Contact',
                Email = 'AZPP' + count + '@test.com',
                AccountId = accountList[1].Id,
                Is_portal_user_active__c = TRUE,
                Is_portal_user_created__c = TRUE,
                Role__c = 'Customers My Device Admin',
                Department__c = 'Design'
            );
            contactList.add(tempContact);
            count++;
        }
        insert contactList;
        System.debug('contactList size : ' + contactList.size());
        
        Set<Id> contactIdSet = new Set<Id>();
        List<User> userList = new List<User>();
        User tempUser;
        count = 1;
        for(Contact  contactObj : contactList){
            
            tempUser = new User(
                ContactId = contactObj.id,
                FirstName = contactObj.FirstName,
                LastName = 'Contact',
                Email = contactObj.Email,
                Emailencodingkey='UTF-8',           
                CommunityNickname = 'Contact_'+math.random(),
                Languagelocalekey='en_US',
                Localesidkey='en_US',
                Alias = 'AZ' + count,
                ProfileId = '00e90000001C392',
                Timezonesidkey='America/Los_Angeles', 
                UserName = contactObj.Email,
                FederationIdentifier='Test2015' + count,
                IsActive = TRUE
            );  
            userList.add(tempUser);
            count++;
            
            contactIdSet.add(contactObj.Id);
        }
        insert userList;
        System.debug('userList size : ' + userList.size());
        
        List<Portal_Tab_Access__c> tpaList = [SELECT Id, Account__c FROM Portal_Tab_Access__c WHERE Account__c = :accountList[1].Id];
        System.debug('tpaList : ' + tpaList);
        
        Process_Technology__c p = new Process_Technology__c(name = 'testPT', PT_number__c = 'PT12323');
        insert p;   
        
        FV_Beta_Account__c fba = new FV_Beta_Account__c(name = 'epctest111');
        insert fba;
        
        //expose device to customer portal
        dev.confidence_level_tapeout__c = '50';
        dev.stage__c = 'Design In';
        dev.fab__c = 'FAB 1';
        dev.expose_device_to_customer__c = true;
        dev.semiconductor_device__c = 'MEMS - RF';
        dev.siebel_device_id__c = 'testID';
        dev.process_technology_2__c = p.id;
        dev.Enabled_via_previous_MPW_1__c = 'No';
        //dev.Original_Forecasted_Tapeout_Date__c = system.today();
        Test.startTest();
        update dev;
        
        Export_Control_Form__c ecf = new Export_Control_Form__c();
        ecf.Account__c = accountList[0].id;
        insert ecf;
        
        Device_Export_Control_Junction__c decj = new Device_Export_Control_Junction__c();
        decj.Device__c = dev.id;
        decj.Export_Control_Form__c = ecf.id;
        insert decj;
        
        ExposeDeviceToCustomer.ReturnMessage rm = ExposeDeviceToCustomer.validate(new list<device__c>{dev}, new set<id>{ accountList[1].id});
        system.debug(rm);
        ExposeDeviceToCustomer.exposeCustomer(rm.recordsMap, false);
        ExposeDeviceToCustomer.sendEmail(rm.recordsMap, new set<id>(), new set<id>());
        
        ExposeDeviceToCustomer.RecordDetail rd = new ExposeDeviceToCustomer.RecordDetail(dev, accountList[1].short_name__c);
        rd.getCustomer();
        rd.addContacts(contactList);
        rd.getCustomer();
        List<Opportunity_Program_Team_Member__c> optmList = [SELECT Id, User__r.Email FROM Opportunity_Program_Team_Member__c];
        for(Integer i = 0; i < 30; i++){
            optmList.add(optmList[0]);
        }
        rd.addTeamMembers(optmList);
        //rd.getCustomerEmail(new Set<string>{}, new Set<string>{}, new Set<Id>{co[0].Id, conts[1].Id}, new Set<Id>{conts[0].Id, conts[1].Id});
        rd.getFAEEmail();
        Map<String,List<ExposeDeviceToCustomer.RecordDetail>> rdMap = new Map<String,List<ExposeDeviceToCustomer.RecordDetail>>();
        rdMap.put(accountList[1].id,new List<ExposeDeviceToCustomer.RecordDetail>{rd});
        ExposeDeviceToCustomer.sendEmail(rdMap, contactIdSet, contactIdSet);
        
        Test.stopTest();
    }
    
    private static Account getAccount(string AccountName)
    {
        Account acct = [SELECT Id, Name FROM Account Where Name =: AccountName];
        
        return acct;
    }
}