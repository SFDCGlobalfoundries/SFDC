/*Author: UCM Team(Kali)
* Description: Test Class for ASICLoadBugFieldsClass
               
* History: Created on 10/20/2016
*/
@isTest(SeeAllData = false)
private class ASICLoadBugFieldsTest {
    
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
    private static testMethod void test() {
        CaseDataUtilTest.loadCustomSettingVariables();  
        DataUtilTest.loadEnvironmentVariables();
        RecordType recordType =  [Select Id from RecordType where Name = 'Customer' AND SObjectType = 'Account'];
        Map<String,Object> fieldValueAccMap = new Map<String,Object>();       
        fieldValueAccMap.put('Name', 'testing501');
        fieldValueAccMap.put('Stage__c', 'Unqualified');
        fieldValueAccMap.put('Short_Name__c', 'test725');
        fieldValueAccMap.put('Site_Department__c', 'cts.com');
        fieldValueAccMap.put('Account_Type__c', 'Customer');
        fieldValueAccMap.put('Organization_Unit__c', 'sg;us');
        fieldValueAccMap.put('Copy_Address__c', true);
        fieldValueAccMap.put('Corporate_Address_1__c', 'test');
        fieldValueAccMap.put('Corporate_City__c', 'sg');
        fieldValueAccMap.put('Corporate_Country__c', 'sg');        
        fieldValueAccMap.put('Financial_Territory__c', 'Greater China');
        fieldValueAccMap.put('Region__c', 'APJ');
        fieldValueAccMap.put('Sub_Type__c', 'Direct');
        fieldValueAccMap.put('Transaction_Type__c', 'Transactional');
        fieldValueAccMap.put('Account_Profile__c', 'Fabless - Emerging');
        fieldValueAccMap.put('Corporate_Postal_Zip_Code__c', '700007');
        fieldValueAccMap.put('Fab_9_10__c', 'No');
        fieldValueAccMap.put('recordtypeid', EnvironmentVariable.get('ACCT_RT_ID_CUSTOMER'));
        Account account1 = AccountDataFactory.createAccount(fieldValueAccMap); 
    
        List<Bug_ASIC_Picklist__c> listBugASIC = new List<Bug_ASIC_Picklist__c>();
        Bug_ASIC_Picklist__c objTestASICPicklist = new Bug_ASIC_Picklist__c();
        objTestASICPicklist.Problem_Type__c =   'Tool';
        objTestASICPicklist.Sub_Type_A__c   =   '14LPP Prior';
        objTestASICPicklist.Sub_Type_B__c   =   'TheGuide Methodologies';
        objTestASICPicklist.Sub_Type_C__c   =   'SOM Methodology';
        objTestASICPicklist.Sub_Type_D__c   =   'Timing and Coupled Noise';
        objTestASICPicklist.is_Active__c    =   true;
        listBugASIC.add(objTestASICPicklist);
        
        Bug_ASIC_Picklist__c objTestASICPicklist2 = new Bug_ASIC_Picklist__c();
        objTestASICPicklist2.Problem_Type__c =   'Tool';
        objTestASICPicklist2.Sub_Type_A__c   =   '14LPP Prior';
        objTestASICPicklist2.Sub_Type_B__c   =   'TheGuide Methodologies';
        objTestASICPicklist2.Sub_Type_C__c   =   'SOM Methodology';
        objTestASICPicklist2.Sub_Type_D__c   =   'Testability and Test Generation';
        objTestASICPicklist2.is_Active__c    =   true;
        listBugASIC.add(objTestASICPicklist2);
        insert listBugASIC;
        
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
        User u2 = new User(Alias = 'standt2', Email = uEmail,
            EmailEncodingKey = 'UTF-8', LastName = 'Testing1', LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US', ProfileId = p2.Id,
            TimeZoneSidKey = 'America/Los_Angeles', Username = 'buguser3' + System.now().format('MMddyyyyHHmmss') + '@testorg1.com');
        insert u2;
              
              
              
        List<Case> caseList = new List<Case>();
        Id recordTypeLogisticsId = Schema.SObjectType.Case.getRecordTypeInfosByName().get(System.Label.Case_Recordtype_Logistics).getRecordTypeId();
        
        Case c = new Case(Status = 'New', Origin = 'Email', Type = 'Expedite', RecordTypeId = recordTypeLogisticsId,
                          Description = 'Test 331', Subject = 'Test 12', Category__c = 'Shipping',
                          Priority = 'Low', Problem_Type__c='Methodology',Sub_Type_A__c= 'FX14 Onwards', Sub_Type_D__c= 'FX-14P', Sub_Type_C__c= 'RTL Compiler',Sub_Type_B__c= 'ASIC Front End Processing/DFTS',  AccountId = account1.Id, Internal_or_external__c = true);
        caseList.add(c);
        
        
        insert caseList;
        
        Id BugrecordTypeId = Schema.SObjectType.Bug__c.getRecordTypeInfosByName().get('ASIC Bug').getRecordTypeId();
        bug__c b = new bug__c();
        
        PageReference pageRef = new PageReference('/apex/ASICLoadBugFieldsPage?cid=' + caseList[0].Id);
        Test.setCurrentPage(pageRef);
        Apexpages.StandardController controller = new Apexpages.StandardController(b);
        Test.startTest();
        ASICLoadBugFieldsClass objLoadFieldsClass = new ASICLoadBugFieldsClass(controller);
      
        objLoadFieldsClass.bugVar.Problem_Type__c = 'Tool';
        objLoadFieldsClass.bugVar.Sub_Type_A__c= '14LPP Prior';
        objLoadFieldsClass.bugVar.Sub_Type_B__c= 'TheGuide Methodologies';
        objLoadFieldsClass.bugVar.Sub_Type_C__c= 'SOM Methodology';
        objLoadFieldsClass.bugVar.Sub_Type_D__c= 'Timing and Coupled Noise';
        objLoadFieldsClass.savebug();
        objLoadFieldsClass.loadingOrNot  = 'NO';
        objLoadFieldsClass.isFromConstructor = false;
        objLoadFieldsClass.bugVar.recordTypeId = BugrecordTypeId;
        
        objLoadFieldsClass.bugVar.Problem_Type__c = null;
        objLoadFieldsClass.bugVar.Sub_TYpe_A__c     = null;
        objLoadFieldsClass.isShowSubTypeB           =   true;
        objLoadFieldsClass.bugVar.Sub_TYpe_B__c     = null;
        objLoadFieldsClass.isShowSubTypeC          =   true;
        objLoadFieldsClass.bugVar.Sub_TYpe_C__c     = null;
        objLoadFieldsClass.isShowSubTypeD          =   true;
        objLoadFieldsClass.bugVar.Sub_Type_D__c     = null;
        objLoadFieldsClass.bugVar.Technology__c     =  'FX-14P';
        objLoadFieldsClass.bugVar.Problem_Class__c  = 'Defect';
        objLoadFieldsClass.savebug();
        
        objLoadFieldsClass.bugVar.Bug_Title__c  = 'TEST';
        objLoadFieldsClass.bugVar.Problem_Type__c   = 'Tool';
        objLoadFieldsClass.bugVar.Sub_TYpe_A__c     = '14LPP Prior';
        objLoadFieldsClass.bugVar.Sub_TYpe_B__c     = 'TheGuide Methodologies';
        objLoadFieldsClass.bugVar.Sub_TYpe_C__c     = 'SOM Methodology';
        objLoadFieldsClass.bugVar.Sub_Type_D__c     = 'Testability and Test Generation';
        objLoadFieldsClass.bugVar.Technology__c     =  'FX-14P';
        objLoadFieldsClass.bugVar.Problem_Class__c  = 'Defect';
        objLoadFieldsClass.bugVar.Need_By_Date__c   =  System.today();
        objLoadFieldsClass.bugVar.Library_Release__c= '2.0';
        objLoadFieldsClass.bugVar.Account_Affected__c = account1.Id;
        objLoadFieldsClass.problemType = 'Tool';
       
        objLoadFieldsClass.retrieveProblemTypeValues(); 
        objLoadFieldsClass.retrieveProblemTypeConstructor1(); 
        objLoadFieldsClass.retrieveProblemType();
        objLoadFieldsClass.subTypeA = '14LPP Prior';
        objLoadFieldsClass.retrieveSubTypeA(); 
        objLoadFieldsClass.subTYpeB = 'TheGuide Methodologies';
        objLoadFieldsClass.retrieveSubTypeB(); 
        objLoadFieldsClass.subTYpeC = 'SOM Methodology';
        objLoadFieldsClass.retrieveSubTypeC(); 
        objLoadFieldsClass.savebug();
        Test.stopTest();
        
        objLoadFieldsClass.cancelBug();
        objLoadFieldsClass.bugVar.Id = b.Id;
        objLoadFieldsClass.cancelBug();
        objLoadFieldsClass.bugVar.Id = null;
        objLoadFieldsClass.newId = null;
        objLoadFieldsClass.cancelBug();
        
    }
}