/*Author: UCM Team(Pankaj)
* Description: Test Class for ASICSubscriptionVFCExt
               
* History: Created on 03/09/2017
*/
@isTest(SeeAllData = false)
private class ASICSubscriptionVFCExtTest {
    
    public static User createUser(String profileName) {
        Profile p = [SELECT Id FROM Profile WHERE Name = : profileName];
        String uEmail = 'standarduser' + DateTime.now().getTime() + '@testorg.com';
        User u = new User(Alias = 'standt', Email = uEmail,
            EmailEncodingKey = 'UTF-8', LastName = 'Testing', LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US', ProfileId = p.Id,
            TimeZoneSidKey = 'America/Los_Angeles', Username = 'buguser1' + System.now().format('MMddyyyyHHmmss') + '@testorg.com');
        insert u;
        System.assert(u.id != null);
        return u;
    }
    
    @testSetup static void testdata() {
        DataUtilTest.loadEnvironmentVariables();
        
        List<Map<String,Object>> fieldValueMapList = new List<Map<String,Object>>();
        for(integer i=1;i<=4;i++){
            Map<String,Object> fieldValueMap = new Map<String,Object>();
            fieldValueMap.put('Name', 'MYTEST ACCOUNT'+i);            
            fieldValueMap.put('Short_Name__c', 'test'+i);        
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
            
            fieldValueMapList.add(fieldValueMap);
        }
        AccountDataFactory.createAccounts(fieldValueMapList,4);
    }
    private static testMethod void subscribed(){
        List<Bug_ASIC_Picklist__c> listBugASIC = new List<Bug_ASIC_Picklist__c>();
        Test.startTest();
        Contact objContact = new Contact();
        objContact.firstName = 'Kali';
        objContact.lastname  = 'Sandipam';
        objContact.email = 'noreply@salesforce.com';
        
        insert objContact;
        User sysAdmin = createUser('System Administrator');
        string adminId = Userinfo.getUserId();
        string adminIds = adminId.substring(0, 15);
        
        Profile p2 = [SELECT Id FROM Profile WHERE Name = 'System Administrator'];
        String uEmail = 'standarduser' + DateTime.now().getTime() + '@testorg1.com';
        
        User u2 = new User(Alias = 'standt2', Email = uEmail, EmailEncodingKey = 'UTF-8', LastName = 'Testing1', LanguageLocaleKey = 'en_US',
                           LocaleSidKey = 'en_US', ProfileId = p2.Id,TimeZoneSidKey = 'America/Los_Angeles', Username = 'buguser3' + System.now().format('MMddyyyyHHmmss') + '@testorg1.com');
        
        insert u2;
        
        Bug_ASIC_Picklist__c objTestASICPicklist2 = new Bug_ASIC_Picklist__c();
        objTestASICPicklist2.Problem_Type__c =   'Tool';
        objTestASICPicklist2.Sub_Type_A__c   =   '14LPP Prior';
        objTestASICPicklist2.Sub_Type_B__c   =   'TheGuide Methodologies';
        objTestASICPicklist2.Sub_Type_C__c   =   'SOM Methodology';
        objTestASICPicklist2.Sub_Type_D__c   =   'Testability and Test Generation';
        objTestASICPicklist2.is_Active__c    =   true;
        listBugASIC.add(objTestASICPicklist2);
        insert listBugASIC;
        
        Bug_Default_Owner_Team__c custSet = new Bug_Default_Owner_Team__c();        
        custSet.Bug_Owners__c = adminIds;
        custSet.Bug_BugTeam__c = u2.Id;
        custSet.Bug_Admin__c = adminIds;
        custSet.Sub_Type_A__c   =   '14LPP Prior';
        custSet.Sub_Type_B__c   =   'TheGuide Methodologies';
        custSet.Sub_Type_C__c   =   'SOM Methodology';
        custSet.Sub_Type_D__c   =   'Testability and Test Generation';
        insert custSet;
        
        Account acc = new Account(name = 'acctest14', Site_Department__c = 'Site13', Sub_Type__c = 'Direct',
                Transaction_Type__c = 'Transactional', Region__c = 'APJ', Bill_To_Address_1__c = 'New Bill43',
                Bill_To_City__c = 'city13', Bill_To_Country__c = 'Austria', Corporate_Address_1__c = '',
                Corporate_City__c = 'city13', Corporate_Country__c = 'Austria');
        insert acc;
                                     
        Id BugrecordTypeId = Schema.SObjectType.Bug__c.getRecordTypeInfosByName().get('ASIC Bug').getRecordTypeId();
        bug__c b = new bug__c();
        
        PageReference pageRef = new PageReference('/apex/ASICSubscriptionVFP');
        Test.setCurrentPage(pageRef);
        Apexpages.StandardController controller = new Apexpages.StandardController(b);
        
        ASICSubscriptionVFCExt objLoadFieldsClass = new ASICSubscriptionVFCExt(controller);
        
        objLoadFieldsClass.retrieveProblemType(); 
        objLoadFieldsClass.retrieveSubTypeA();  
        objLoadFieldsClass.retrieveSubTypeB(); 
        objLoadFieldsClass.retrieveSubTypeC();
        objLoadFieldsClass.subscribed(); 
                         
        objLoadFieldsClass.problemType = 'Tool';
        objLoadFieldsClass.subTypeA    = '14LPP Prior';        
        objLoadFieldsClass.subTypeB    = 'TheGuide Methodologies';
        objLoadFieldsClass.bugSearch();
        objLoadFieldsClass.subscribed();
        objLoadFieldsClass.doCancel();
        
        objLoadFieldsClass.problemType = 'Tool';
        objLoadFieldsClass.subTypeA    = '14LPP Prior';
        objLoadFieldsClass.subTypeC    = 'SOM Methodology';
        objLoadFieldsClass.bugSearch();
        objLoadFieldsClass.subscribed();
        system.assertEquals('14LPP Prior',custSet.Sub_Type_A__c);
        
        
        objLoadFieldsClass.problemType = 'Tool'; 
        objLoadFieldsClass.retrieveProblemType();               
        objLoadFieldsClass.subTypeA = '14LPP Prior';
        objLoadFieldsClass.retrieveSubTypeA();              
        objLoadFieldsClass.subTYpeB = 'TheGuide Methodologies';
        objLoadFieldsClass.retrieveSubTypeB();  
        objLoadFieldsClass.subTYpeC = 'SOM Methodology';
        objLoadFieldsClass.retrieveSubTypeC();                      
        objLoadFieldsClass.subTypeD    = 'Testability and Test Generation';
        objLoadFieldsClass.bugSearch();
        objLoadFieldsClass.subscribed();
        objLoadFieldsClass.unSubsrcibed();  
        
        Test.stopTest();
    }
    private static testMethod void unSubsrcibed() {
        
        List<Bug_ASIC_Picklist__c> listBugASIC = new List<Bug_ASIC_Picklist__c>();
        Test.startTest();
        Contact objContact = new Contact();
        objContact.firstName = 'Kali';
        objContact.lastname  = 'Sandipam';
        objContact.email = 'noreply@salesforce.com';
        
        insert objContact;
        User sysAdmin = createUser('System Administrator');
        string adminId = Userinfo.getUserId();
        string adminIds = adminId.substring(0, 15);
        
        Profile p2 = [SELECT Id FROM Profile WHERE Name = 'System Administrator'];
        String uEmail = 'standarduser' + DateTime.now().getTime() + '@testorg1.com';
        
        User u2 = new User(Alias = 'standt2', Email = uEmail, EmailEncodingKey = 'UTF-8', LastName = 'Testing1', LanguageLocaleKey = 'en_US',
                           LocaleSidKey = 'en_US', ProfileId = p2.Id,TimeZoneSidKey = 'America/Los_Angeles', Username = 'buguser3' + System.now().format('MMddyyyyHHmmss') + '@testorg1.com');
        
        insert u2;
        
        Bug_ASIC_Picklist__c objTestASICPicklist = new Bug_ASIC_Picklist__c();
        objTestASICPicklist.Problem_Type__c =   'Tool';
        objTestASICPicklist.Sub_Type_A__c   =   '14LPP Prior';
        objTestASICPicklist.Sub_Type_B__c   =   'TheGuide Methodologies';
        objTestASICPicklist.Sub_Type_C__c   =   'SOM Methodology';
        objTestASICPicklist.Sub_Type_D__c   =   'Timing and Coupled Noise';
        objTestASICPicklist.is_Active__c    =   true;
        listBugASIC.add(objTestASICPicklist);
        insert listBugASIC;
                        
        Bug_Default_Owner_Team__c custSet = new Bug_Default_Owner_Team__c();        
        custSet.Bug_Owners__c = adminIds;
        custSet.Bug_BugTeam__c = u2.Id;
        custSet.Bug_Admin__c = adminIds;
        custSet.Sub_Type_A__c   =   '14LPP Prior';
        custSet.Sub_Type_B__c   =   'TheGuide Methodologies';
        custSet.Sub_Type_C__c   =   'SOM Methodology';
        custSet.Sub_Type_D__c   =   'Timing and Coupled Noise';
        insert custSet;
        
        Account acc = new Account(name = 'acctest14', Site_Department__c = 'Site13', Sub_Type__c = 'Direct',
                Transaction_Type__c = 'Transactional', Region__c = 'APJ', Bill_To_Address_1__c = 'New Bill43',
                Bill_To_City__c = 'city13', Bill_To_Country__c = 'Austria', Corporate_Address_1__c = '',
                Corporate_City__c = 'city13', Corporate_Country__c = 'Austria');
        insert acc;
                                     
        Id BugrecordTypeId = Schema.SObjectType.Bug__c.getRecordTypeInfosByName().get('ASIC Bug').getRecordTypeId();
        bug__c b = new bug__c();
        
        PageReference pageRef = new PageReference('/apex/ASICSubscriptionVFP');
        Test.setCurrentPage(pageRef);
        Apexpages.StandardController controller = new Apexpages.StandardController(b);
        
        ASICSubscriptionVFCExt objLoadFieldsClass = new ASICSubscriptionVFCExt(controller);
        
        objLoadFieldsClass.unSubsrcibed(); 
                            
        objLoadFieldsClass.problemType = 'Tool';
        objLoadFieldsClass.subTypeA    = '14LPP Prior';        
        objLoadFieldsClass.subTypeB    = 'TheGuide Methodologies';
        objLoadFieldsClass.bugSearch();
        objLoadFieldsClass.unSubsrcibed();
        objLoadFieldsClass.doCancel();
        
        objLoadFieldsClass.problemType = 'Tool';
        objLoadFieldsClass.subTypeA    = '14LPP Prior';        
        objLoadFieldsClass.subTypeB    = 'TheGuide Methodologies';
        objLoadFieldsClass.subTypeC    = 'SOM Methodology';
        objLoadFieldsClass.bugSearch();
        objLoadFieldsClass.unSubsrcibed();
                
        
        
        objLoadFieldsClass.problemType = 'Tool';                      
        objLoadFieldsClass.subTypeA = '14LPP Prior';                      
        objLoadFieldsClass.subTYpeB = 'TheGuide Methodologies';          
        objLoadFieldsClass.subTYpeC = 'SOM Methodology';                              
        objLoadFieldsClass.subTypeD    = 'Timing and Coupled Noise'; 
        objLoadFieldsClass.bugSearch();
        objLoadFieldsClass.subscribed();       
        objLoadFieldsClass.unSubsrcibed();  
        
        
        
        Test.stopTest();                                      
    }
        
    private static testMethod void cstSubscribed() {
        
        List<Bug_ASIC_Picklist__c> listBugASIC = new List<Bug_ASIC_Picklist__c>();
        Test.startTest();
        Contact objContact = new Contact();
        objContact.firstName = 'Kali';
        objContact.lastname  = 'Sandipam';
        objContact.email = 'noreply@salesforce.com';
        
        insert objContact;
        User sysAdmin = createUser('System Administrator');
        string adminId = Userinfo.getUserId();
        string adminIds = adminId.substring(0, 15);
        
        Profile p2 = [SELECT Id FROM Profile WHERE Name = 'System Administrator'];
        String uEmail = 'standarduser' + DateTime.now().getTime() + '@testorg1.com';
        
        User u2 = new User(Alias = 'standt2', Email = uEmail, EmailEncodingKey = 'UTF-8', LastName = 'Testing1', LanguageLocaleKey = 'en_US',
                           LocaleSidKey = 'en_US', ProfileId = p2.Id,TimeZoneSidKey = 'America/Los_Angeles', Username = 'buguser3' + System.now().format('MMddyyyyHHmmss') + '@testorg1.com');
        
        insert u2;
        
        List<ASICCustomerProject__c> cstprjct = new list<ASICCustomerProject__c> ();
        ASICCustomerProject__c cst = new ASICCustomerProject__c();
        cst.name = '1';
        cst.Name__c = '3COM - FRAMER (TELAVIV ISRAEL)';
        cst.Bug_Team__c =  adminIds;
        cstprjct.add(cst);
        insert cstprjct;
        
        Account acc = new Account(name = 'acctest14', Site_Department__c = 'Site13', Sub_Type__c = 'Direct',
                Transaction_Type__c = 'Transactional', Region__c = 'APJ', Bill_To_Address_1__c = 'New Bill43',
                Bill_To_City__c = 'city13', Bill_To_Country__c = 'Austria', Corporate_Address_1__c = '',
                Corporate_City__c = 'city13', Corporate_Country__c = 'Austria');
        insert acc;
                                     
        Id BugrecordTypeId = Schema.SObjectType.Bug__c.getRecordTypeInfosByName().get('ASIC Bug').getRecordTypeId();
        bug__c b = new bug__c();
        
        PageReference pageRef = new PageReference('/apex/ASICSubscriptionVFP');
        Test.setCurrentPage(pageRef);
        Apexpages.StandardController controller = new Apexpages.StandardController(b);
        
        ASICSubscriptionVFCExt objLoadFieldsClass = new ASICSubscriptionVFCExt(controller);
        
        objLoadFieldsClass.cstProject  = '3COM - FRAMER (TELAVIV ISRAEL)';
        objLoadFieldsClass.cstBugSearch();
        objLoadFieldsClass.cstUnSubsrcibed();
                            
        
        
        
        
        Test.stopTest();                                      
    }
    
    private static Account getAccount(string AccountName)
    {
        Account acct = [SELECT Id, Name FROM Account Where Name =: AccountName];
        
        return acct;
    }

}