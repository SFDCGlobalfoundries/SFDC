/*Author: Cognizant UCM Team
* Description: Test Class for LoadBugFieldsClass, Bugredirect ,BugCADCreate ,BugCDTCreate.               
* History: Created on 09/18/2015
*/
@isTest(SeeAllData = false)
public class BugVisualforceControllerTest{
  @testSetup static void testdata() {
        DataUtilTest.loadEnvironmentVariables();
        
        Map<String,Object> fieldValueMap = new Map<String,Object>();            
        fieldValueMap.put('Name', 'MYTEST ACCOUNT1');            
        fieldValueMap.put('stage__c', 'Unqualified');
        fieldValueMap.put('short_name__c', 'TestACC1');
        fieldValueMap.put('sub_type__c', 'Direct');
        fieldValueMap.put('site_department__c', 'test dept');          
        fieldValueMap.put('transaction_type__c', 'transactional');
        fieldValueMap.put('account_profile__c', 'Fabless - Emerging');            
        fieldValueMap.put('Process_Tech_Interested__c', 'Mature (> 0.11um)');
        fieldValueMap.put('region__c', 'US');
        fieldValueMap.put('Sales_Territory__c', 'US-East');
        fieldValueMap.put('FE_Territory__c', 'US-FE-East');
        fieldValueMap.put('financial_territory__c', 'US-East');          
        fieldValueMap.put('Copy_Address__c', true);
        fieldValueMap.put('Corporate_Address_1__c', '50 water st');  
        fieldValueMap.put('Corporate_Address_2__c', 'Suite B'); 
        fieldValueMap.put('Corporate_City__c', 'Fremont');  
        fieldValueMap.put('Corporate_State__c', 'CA');       
        fieldValueMap.put('Corporate_Country__c', 'USA');
        fieldValueMap.put('Bill_To_Address_1__c', '50 water st');  
        fieldValueMap.put('Bill_To_Address_2__c', 'Suite B'); 
        fieldValueMap.put('Bill_To_City__c', 'Fremont');  
        fieldValueMap.put('Bill_To_State__c', 'CA');       
        fieldValueMap.put('Bill_To_Country__c', 'USA');
        fieldValueMap.put('Organization_Unit__c', 'GF Investment');
        fieldValueMap.put('bill_to_location__c', 'YES');
        fieldValueMap.put('total_employee__c', 100);          
        fieldValueMap.put('end_customer__c', 'people');
        fieldValueMap.put('Revenue_Potential__c', 'High Potential');            
        fieldValueMap.put('Target_Account__c', 'Yes');
        fieldValueMap.put('Fab_9_10__c','No');  
        fieldValueMap.put('recordtypeid', EnvironmentVariable.get('ACCT_RT_ID_CUSTOMER'));
            
        AccountDataFactory.createAccount(fieldValueMap);
    }
    
    private static Account getAccount(string AccountName)
    {
        // Select columns you would like to use in your test class for the object. If only ID is used, just select ID
        Account acct = [SELECT Id FROM Account Where Name =: AccountName];
        
        return acct;
    }
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
    public static testMethod void testCADCreate() {
         list < BugErrorMessages__c> bugerrorlist = new list < BugErrorMessages__c> ();
         BugErrorMessages__c berror1 = new BugErrorMessages__c ();
         berror1 .name = 'BugResolutionValidation';
         berror1 .Error_Message__c= 'The Resolution field have to be populated for closed, verified and resolved status';
         BugErrorMessages__c berror2 = new BugErrorMessages__c ();
         berror2.name = 'BugDuplicateValidation';
         berror2.Error_Message__c= 'Duplicate Bug field should be populated for the resolution "Duplicate"';
         BugErrorMessages__c berror3 = new BugErrorMessages__c ();
         berror3 .name = 'BugDupeBlockerValidation';
         berror3 .Error_Message__c= 'DupeBlocker Duplicate Prevention';
         bugerrorlist.add(berror1);
         bugerrorlist.add(berror2);
         bugerrorlist.add(berror3);
         insert bugerrorlist;    
    
        
        User sysAdmin = createUser('System Administrator');
        System.runAs(sysAdmin) {
            Design_Spec__c c = new Design_Spec__c();
            c.name = 'tt1';
            c.OpenText_ID__c = 11;
            insert c;
            Id recordTypeTechnicalId = Schema.SObjectType.Case.getRecordTypeInfosByName().get(System.Label.Case_Recordtype_Technical).getRecordTypeId();
            case cs = new
            case ();
            cs.origin = 'test';
            insert cs;
            test.starttest();
            Id cadRecordTypeId = Schema.SObjectType.Bug__c.getRecordTypeInfosByName().get('CAD Bug').getRecordTypeId();
            //Id cadRecordTypeId = Schema.SObjectType.Bug__c.getRecordTypeInfosByName().get('PDK Bug').getRecordTypeId();
            bug__c b = new bug__c();
            b.Bug_Title__c = 'test zzzz123z11111';
            b.Product_technology__c = 'CAD Environment';
            b.Component__c = 'Documentation';
            b.DE_Spec_Affected__c = c.id;
            b.Bug_Classification__c = 'test';
            b.Priority__c = 'p1';
            b.Severity__c = 'c1';
            b.Version__c = '1.1';
            b.Customer_Severity__c='Normal';
            b.recordtypeid = cadRecordTypeId;
            //insert b;

            bug__c b1 = new bug__c();
            b1.Bug_Title__c = 'test zzzz123z2222';
            b1.Product_technology__c = 'CAD Environment';
            b1.Component__c = 'Documentation';
            b1.DE_Spec_Affected__c = c.id;
            b1.Bug_Classification__c = 'test';
            b1.Priority__c = 'p1';
            b1.Severity__c = 'c1';
            b1.Version__c = '1.1';
            bug__c b2 = new bug__c();
            
            b2.Bug_Title__c = 'test zzzz123z3333';
            b2.Product_technology__c = 'CAD Environment';
            b2.Component__c = 'Documentation';
            b2.DE_Spec_Affected__c = c.id;
            b2.Bug_Classification__c = 'test';
            b2.Priority__c = 'p1';
            b2.Severity__c = 'c1';
            b2.Version__c = '1.1';
            b2.recordtypeid = cadRecordTypeId;
            // Test code for bug create
            PageReference pageRef = new PageReference('/apex/BugCADCreate?rid=' + cadRecordTypeId);
            Test.setCurrentPage(pageRef);
            Apexpages.StandardController controller = new Apexpages.StandardController(b);
            BugCADCreateController BugCADCreateControllerVar = new BugCADCreateController(controller);
            BugCADCreateControllerVar.savebug();
            BugCADCreateControllerVar.cancelBug();
                        
            // Test code for bug create from case
            pageRef = new PageReference('/apex/BugCADCreate?rid='+recordTypeTechnicalId +'&type=copy&caseid='+cs.id);
            Test.setCurrentPage(pageRef);
            controller = new Apexpages.StandardController(b);
            BugCADCreateControllerVar = new BugCADCreateController(controller);
            BugCADCreateControllerVar.savebug();
            BugCADCreateControllerVar.cancelBug();
                                    
            // Test code for bug create from case
            pageRef = new PageReference('/apex/BugCADCreate?caseid=' + cs.id + '&rid=' + cadRecordTypeId);
            Test.setCurrentPage(pageRef);
            controller = new Apexpages.StandardController(b);
            BugCADCreateControllerVar = new BugCADCreateController(controller);
            BugCADCreateControllerVar.savebug();
            BugCADCreateControllerVar.cancelBug();
            insert b;

            // Test code for bug update

            pageRef = Page.BugCADCreate;
            controller = new Apexpages.StandardController(b);
            BugCADCreateControllerVar = new BugCADCreateController(controller);
            BugCADCreateControllerVar.savebug();
            BugCADCreateControllerVar.SubmitBugandAddAttachment();
            BugCADCreateControllerVar.cancelBug();
            // Test code for bug Clone
            pageRef = new PageReference('/apex/BugCADCreate?type=clone&rid=' + cadRecordTypeId);
            Test.setCurrentPage(pageRef);
            controller = new Apexpages.StandardController(b);
            BugCADCreateControllerVar = new BugCADCreateController(controller);
            BugCADCreateControllerVar.savebug();
            
            
             // Test code for bug Clone for CAD
            pageRef = new PageReference('/apex/BugCADCreate?type=clone&rid=' + cadRecordTypeId);
            Test.setCurrentPage(pageRef);
            controller = new Apexpages.StandardController(b);
            BugCADCreateControllerVar = new BugCADCreateController(controller);
            BugCADCreateControllerVar.savebug();            

            // Test code for create bug and attach
            PageReference pageRef2 = new PageReference('/apex/BugCADCreate?type=clone&rid=' + cadRecordTypeId);
            Test.setCurrentPage(pageRef2);
            Apexpages.StandardController controller2 = new Apexpages.StandardController(b);
            BugCADCreateController BugCADCreateControllerVar2 = new BugCADCreateController(controller2);
            BugCADCreateControllerVar2.SubmitBugandAddAttachment();


            //Run catch block
            BugCADCreateControllerVar.bugVar.Bug_Title__c = '';
            BugCADCreateControllerVar.savebug();
            BugCADCreateControllerVar.SubmitBugandAddAttachment();

            //Run catch block
            BugCADCreateControllerVar.bugVar.Bug_Title__c = 'test12345';
            BugCADCreateControllerVar.bugVar.version__c = null;
            BugCADCreateControllerVar.savebug();
            BugCADCreateControllerVar.SubmitBugandAddAttachment();


            //Run catch block
            BugCADCreateControllerVar.bugVar.Bug_Title__c = 'test12345';
            BugCADCreateControllerVar.bugVar.version__c = '1.1';
            BugCADCreateControllerVar.bugVar.Priority__c = null;
            BugCADCreateControllerVar.savebug();
            BugCADCreateControllerVar.SubmitBugandAddAttachment();

            //Run catch block
            BugCADCreateControllerVar.bugVar.Bug_Title__c = 'test12345';
            BugCADCreateControllerVar.bugVar.version__c = '1.1';
            BugCADCreateControllerVar.bugVar.Priority__c = 'p1';
            BugCADCreateControllerVar.bugVar.Severity__c = null;
            BugCADCreateControllerVar.savebug();
            BugCADCreateControllerVar.SubmitBugandAddAttachment();

            //Bug Redirect controller for update
            b = [select recordtypeid from bug__c where id = : b.id][0];

            pageRef = new PageReference('/apex/Bug_Redirect?RecordType=' + cadRecordTypeId);
            Test.setCurrentPage(pageRef);
            controller = new Apexpages.StandardController(b);
            BugRedirect BugRedirectvar = new BugRedirect(controller);
            bugredirectvar.redirectToPage();
            //Bug Redirect for insert
            Bug__c btemp = new Bug__c();

            pageRef = new PageReference('/apex/Bug_Redirect?RecordType=' + cadRecordTypeId);
            Test.setCurrentPage(pageRef);
            controller = new Apexpages.StandardController(btemp);
            BugRedirectvar = new BugRedirect(controller);
            bugredirectvar.redirectToPage();
            pageRef = new PageReference('/apex/Bug_Redirect?RecordType=' + cadRecordTypeId);
            Test.setCurrentPage(pageRef);
            controller = new Apexpages.StandardController(btemp);
            BugRedirectvar = new BugRedirect(controller);
            bugredirectvar.redirectToPage();
            //Bug redirect for clone
            pageRef = new PageReference('/apex/Bug_Redirect?type=clone&RecordType=' + cadRecordTypeId);
            Test.setCurrentPage(pageRef);
            controller = new Apexpages.StandardController(b);
            BugRedirectvar = new BugRedirect(controller);
            bugredirectvar.redirectToPage();
            //Bug redirect for clone for CAD
            pageRef = new PageReference('/apex/Bug_Redirect?type=clone&RecordType=' + cadRecordTypeId);
            Test.setCurrentPage(pageRef);
            controller = new Apexpages.StandardController(b);
            BugRedirectvar = new BugRedirect(controller);
            bugredirectvar.redirectToPage();
            
            //BugAutoCompleteController Test data
            BugAutoCompleteController autocontroller = new BugAutoCompleteController();
            BugAutoCompleteController.getData('Bug__C','Bug_Title__c','Id','test');
            
        }
        test.stoptest();

    }
    public static testMethod void testCreateCDT() {
         list < BugErrorMessages__c> bugerrorlist = new list < BugErrorMessages__c> ();
         BugErrorMessages__c berror1 = new BugErrorMessages__c ();
         berror1 .name = 'BugResolutionValidation';
         berror1 .Error_Message__c= 'The Resolution field have to be populated for closed, verified and resolved status';
         BugErrorMessages__c berror2 = new BugErrorMessages__c ();
         berror2.name = 'BugDuplicateValidation';
         berror2.Error_Message__c= 'Duplicate Bug field should be populated for the resolution "Duplicate"';
         BugErrorMessages__c berror3 = new BugErrorMessages__c ();
         berror3 .name = 'BugDupeBlockerValidation';
         berror3 .Error_Message__c= 'DupeBlocker Duplicate Prevention';
         bugerrorlist.add(berror1);
         bugerrorlist.add(berror2);
        bugerrorlist.add(berror3);
         insert bugerrorlist;    
    
        
        User sysAdmin = createUser('System Administrator');
        System.runAs(sysAdmin) {
            Design_Spec__c c = new Design_Spec__c();
            c.name = 'tt1';
            c.OpenText_ID__c = 11;

            insert c;
            
            case cs = new
            case ();
            cs.origin = 'test';
            insert cs;
            
            test.starttest();
            
            Id CDTRecordTypeId = Schema.SObjectType.Bug__c.getRecordTypeInfosByName().get('CDT Bug').getRecordTypeId();
            //Id CDTRecordTypeId = Schema.SObjectType.Bug__c.getRecordTypeInfosByName().get('PDK Bug').getRecordTypeId();
            bug__c b = new bug__c();
            b.Bug_Title__c = 'test zzzz123z11111';
            b.Product_technology__c = 'CAD Environment';
            b.Component__c = 'Documentation';
            b.DE_Spec_Affected__c = c.id;
            b.Bug_Classification__c = 'test';
            b.Priority__c = 'p1';
            b.Severity__c = 'c1';
            b.Version__c = '1.1';
            b.Customer_Severity__c='Normal';
            b.recordtypeid = CDTRecordTypeId;
            //insert b;

            bug__c b1 = new bug__c();
            b1.Bug_Title__c = 'test zzzz123z2222';
            b1.Product_technology__c = 'CAD Environment';
            b1.Component__c = 'Documentation';
            b1.DE_Spec_Affected__c = c.id;
            b1.Bug_Classification__c = 'test';
            b1.Priority__c = 'p1';
            b1.Severity__c = 'c1';
            b1.Version__c = '1.1';
            bug__c b2 = new bug__c();
            
            b2.Bug_Title__c = 'test zzzz123z3333';
            b2.Product_technology__c = 'CAD Environment';
            b2.Component__c = 'Documentation';
            b2.DE_Spec_Affected__c = c.id;
            b2.Bug_Classification__c = 'test';
            b2.Priority__c = 'p1';
            b2.Severity__c = 'c1';
            b2.Version__c = '1.1';
            b2.recordtypeid = CDTRecordTypeId;
            // Test code for bug create
            PageReference pageRef = new PageReference('/apex/BugCDTCreate?rid=' + CDTRecordTypeId);
            Test.setCurrentPage(pageRef);
            Apexpages.StandardController controller = new Apexpages.StandardController(b);
            BugCDTCreateController BugCDTCreateControllerVar = new BugCDTCreateController(controller);
            BugCDTCreateControllerVar.savebug();
            BugCDTCreateControllerVar.cancelBug();

            // Test code for bug create from case
            pageRef = new PageReference('/apex/BugCDTCreate?caseid=' + cs.id + '&rid=' + CDTRecordTypeId);
            Test.setCurrentPage(pageRef);
            controller = new Apexpages.StandardController(b);
            BugCDTCreateControllerVar = new BugCDTCreateController(controller);
            BugCDTCreateControllerVar.savebug();
            BugCDTCreateControllerVar.cancelBug();
            insert b;

           // Test code for bug update

            pageRef = Page.BugCDTCreate;
            controller = new Apexpages.StandardController(b);
            BugCDTCreateControllerVar = new BugCDTCreateController(controller);
            BugCDTCreateControllerVar.savebug();
            BugCDTCreateControllerVar.SubmitBugandAddAttachment();
            BugCDTCreateControllerVar.cancelBug();
            // Test code for bug Clone
            pageRef = new PageReference('/apex/BugCDTCreate?type=clone&rid=' + CDTRecordTypeId);
            Test.setCurrentPage(pageRef);
            controller = new Apexpages.StandardController(b);
            BugCDTCreateControllerVar = new BugCDTCreateController(controller);
            BugCDTCreateControllerVar.savebug();
            
            
             // Test code for bug Clone for CAD
            pageRef = new PageReference('/apex/BugCDTCreate?type=clone&rid=' + CDTRecordTypeId);
            Test.setCurrentPage(pageRef);
            controller = new Apexpages.StandardController(b);
            BugCDTCreateControllerVar = new BugCDTCreateController(controller);
            BugCDTCreateControllerVar.savebug();            

            // Test code for create bug and attach
            PageReference pageRef2 = new PageReference('/apex/BugCDTCreate?type=clone&rid=' + CDTRecordTypeId);
            Test.setCurrentPage(pageRef2);
            Apexpages.StandardController controller2 = new Apexpages.StandardController(b);
            BugCDTCreateController BugCDTCreateControllerVar2 = new BugCDTCreateController(controller2);
            BugCDTCreateControllerVar2.SubmitBugandAddAttachment();


            //Run catch block
            BugCDTCreateControllerVar.bugVar.Bug_Title__c = '';
            BugCDTCreateControllerVar.savebug();
            BugCDTCreateControllerVar.SubmitBugandAddAttachment();

            //Run catch block
            BugCDTCreateControllerVar.bugVar.Bug_Title__c = 'test12345';
            BugCDTCreateControllerVar.bugVar.version__c = null;
            BugCDTCreateControllerVar.savebug();
            BugCDTCreateControllerVar.SubmitBugandAddAttachment();


            //Run catch block
            BugCDTCreateControllerVar.bugVar.Bug_Title__c = 'test12345';
            BugCDTCreateControllerVar.bugVar.version__c = '1.1';
            BugCDTCreateControllerVar.bugVar.Priority__c = null;
            BugCDTCreateControllerVar.savebug();
            BugCDTCreateControllerVar.SubmitBugandAddAttachment();

            //Run catch block
            BugCDTCreateControllerVar.bugVar.Bug_Title__c = 'test12345';
            BugCDTCreateControllerVar.bugVar.version__c = '1.1';
            BugCDTCreateControllerVar.bugVar.Priority__c = 'p1';
            BugCDTCreateControllerVar.bugVar.Severity__c = null;
            BugCDTCreateControllerVar.savebug();
            BugCDTCreateControllerVar.SubmitBugandAddAttachment();

            //Bug Redirect controller for update
            b = [select recordtypeid from bug__c where id = : b.id][0];

            pageRef = new PageReference('/apex/Bug_Redirect?RecordType=' + CDTRecordTypeId);
            Test.setCurrentPage(pageRef);
            controller = new Apexpages.StandardController(b);
            BugRedirect BugRedirectvar = new BugRedirect(controller);
            bugredirectvar.redirectToPage();
            //Bug Redirect for insert
            Bug__c btemp = new Bug__c();

            pageRef = new PageReference('/apex/Bug_Redirect?RecordType=' + CDTRecordTypeId);
            Test.setCurrentPage(pageRef);
            controller = new Apexpages.StandardController(btemp);
            BugRedirectvar = new BugRedirect(controller);
            bugredirectvar.redirectToPage();
            pageRef = new PageReference('/apex/Bug_Redirect?RecordType=' + CDTRecordTypeId);
            Test.setCurrentPage(pageRef);
            controller = new Apexpages.StandardController(btemp);
            BugRedirectvar = new BugRedirect(controller);
            bugredirectvar.redirectToPage();
            //Bug redirect for clone
            pageRef = new PageReference('/apex/Bug_Redirect?type=clone&RecordType=' + CDTRecordTypeId);
            Test.setCurrentPage(pageRef);
            controller = new Apexpages.StandardController(b);
            BugRedirectvar = new BugRedirect(controller);
            bugredirectvar.redirectToPage();
            //Bug redirect for clone for CAD
            pageRef = new PageReference('/apex/Bug_Redirect?type=clone&RecordType=' + CDTRecordTypeId);
            Test.setCurrentPage(pageRef);
            controller = new Apexpages.StandardController(b);
            BugRedirectvar = new BugRedirect(controller);
            bugredirectvar.redirectToPage();
            
            //BugAutoCompleteController Test data
            BugAutoCompleteController autocontroller = new BugAutoCompleteController();
            BugAutoCompleteController.getData('Bug__C','Bug_Title__c','Id','test');
            
        }
        test.stoptest();

    }
    //Method to test the clone,new bug for other record types
    public static testMethod void testloadbugfields() {
         list < BugErrorMessages__c> bugerrorlist = new list < BugErrorMessages__c> ();
         BugErrorMessages__c berror1 = new BugErrorMessages__c ();
         berror1 .name = 'BugResolutionValidation';
         berror1 .Error_Message__c= 'The Resolution field have to be populated for closed, verified and resolved status';
         BugErrorMessages__c berror2 = new BugErrorMessages__c ();
         berror2.name = 'BugDuplicateValidation';
         berror2.Error_Message__c= 'Duplicate Bug field should be populated for the resolution "Duplicate"';
         BugErrorMessages__c berror3 = new BugErrorMessages__c ();
         berror3 .name = 'BugDupeBlockerValidation';
         berror3 .Error_Message__c= 'DupeBlocker Duplicate Prevention';
         bugerrorlist.add(berror1);
         bugerrorlist.add(berror2);
        bugerrorlist.add(berror3);
         insert bugerrorlist;    
    
        
        User sysAdmin = createUser('System Administrator');
        System.runAs(sysAdmin) {
            Design_Spec__c c = new Design_Spec__c();
            c.name = 'tt1';
            c.OpenText_ID__c = 11;
            insert c;
            case cs = new
            case ();
            cs.origin = 'test';
            insert cs;
            test.starttest();
            Id cadRecordTypeId = Schema.SObjectType.Bug__c.getRecordTypeInfosByName().get('CAD Bug').getRecordTypeId();
            Id pdkRecordTypeId = Schema.SObjectType.Bug__c.getRecordTypeInfosByName().get('PDK Bug').getRecordTypeId();
            bug__c b = new bug__c();
            b.Bug_Title__c = 'test zzzz123z11111';
            b.Product_technology__c = 'CAD Environment';
            b.Component__c = 'Documentation';
            b.DE_Spec_Affected__c = c.id;
            b.Bug_Classification__c = 'test';
            b.Priority__c = 'p1';
            b.Severity__c = 'c1';
            b.Version__c = '1.1';
            b.recordtypeid = cadRecordTypeId;
            b.Customer_Severity__c='Normal';
            //insert b;

            bug__c b1 = new bug__c();
            b1.Bug_Title__c = 'test zzzz123z2222';
            b1.Product_technology__c = 'CAD Environment';
            b1.Component__c = 'Documentation';
            b1.DE_Spec_Affected__c = c.id;
            b1.Bug_Classification__c = 'test';
            b1.Priority__c = 'p1';
            b1.Severity__c = 'c1';
            b1.Version__c = '1.1';
            b1.Customer_Severity__c = 'Normal';
            insert b1;
            
            bug__c b2 = new bug__c();
            
            b2.Bug_Title__c = 'test zzzz123z3333';
            b2.Product_technology__c = 'CAD Environment';
            b2.Component__c = 'Documentation';
            b2.DE_Spec_Affected__c = c.id;
            b2.Bug_Classification__c = 'test';
            b2.Priority__c = 'p1';
            b2.Severity__c = 'c1';
            b2.Version__c = '1.1';
            b2.Customer_Severity__c = 'Normal';
            b2.recordtypeid = pdkRecordTypeId;
            // Test code for bug create
            PageReference pageRef = new PageReference('/apex/LoadBugFieldsPage?rid=' + pdkRecordTypeId);
            Test.setCurrentPage(pageRef);
            Apexpages.StandardController controller = new Apexpages.StandardController(b);
            LoadBugFieldsClass LoadBugFieldsClassVar = new LoadBugFieldsClass(controller);
            LoadBugFieldsClassVar.checkRequired();
            LoadBugFieldsClassVar.savebug();
            LoadBugFieldsClassVar.cancelBug();

            PageReference pageRef1 = new PageReference('/apex/LoadBugFieldsPage?rid=' + pdkRecordTypeId);
            Test.setCurrentPage(pageRef1);
            Apexpages.StandardController controller1 = new Apexpages.StandardController(b);
            LoadBugFieldsClass LoadBugFieldsClassVar1 = new LoadBugFieldsClass(controller1);
            LoadBugFieldsClassVar1.bugVar.Component__c ='Layer database';           
            LoadBugFieldsClassVar1.checkRequired();
            LoadBugFieldsClassVar1.bugVar.Internal_Priority__c ='test';
            LoadBugFieldsClassVar1.savebug();
            LoadBugFieldsClassVar1.cancelBug();
            
            // Test code for bug create from case
            pageRef = new PageReference('/apex/LoadBugFieldsPage?caseid=' + cs.id + '&rid=' + pdkRecordTypeId);
            Test.setCurrentPage(pageRef);
            controller = new Apexpages.StandardController(b);
            LoadBugFieldsClassVar = new LoadBugFieldsClass(controller);
            LoadBugFieldsClassVar.cancelBug();
            insert b;

            // Test code for bug update

            pageRef = Page.LoadBugFieldsPage;
            controller = new Apexpages.StandardController(b);
            LoadBugFieldsClassVar = new LoadBugFieldsClass(controller);
            LoadBugFieldsClassVar.savebug();
            LoadBugFieldsClassVar.SubmitBugandAddAttachment();
            LoadBugFieldsClassVar.cancelBug();
            // Test code for bug Clone
            pageRef = new PageReference('/apex/LoadBugFieldsPage?type=clone&rid=' + pdkRecordTypeId);
            Test.setCurrentPage(pageRef);
            controller = new Apexpages.StandardController(b);
            LoadBugFieldsClassVar = new LoadBugFieldsClass(controller);
            LoadBugFieldsClassVar.savebug();
            
            
             // Test code for bug Clone for CAD
            pageRef = new PageReference('/apex/LoadBugFieldsPage?type=clone&rid=' + cadRecordTypeId);
            Test.setCurrentPage(pageRef);
            controller = new Apexpages.StandardController(b);
            LoadBugFieldsClassVar = new LoadBugFieldsClass(controller);
            LoadBugFieldsClassVar.savebug();            

            // Test code for create bug and attach
            PageReference pageRef2 = new PageReference('/apex/LoadBugFieldsPage?type=clone&rid=' + pdkRecordTypeId);
            Test.setCurrentPage(pageRef2);
            Apexpages.StandardController controller2 = new Apexpages.StandardController(b);
            LoadBugFieldsClass LoadBugFieldsClassVar2 = new LoadBugFieldsClass(controller2);
            LoadBugFieldsClassVar2.SubmitBugandAddAttachment();


            //Run catch block
            LoadBugFieldsClassVar.bugVar.Bug_Title__c = '';
            LoadBugFieldsClassVar.savebug();
            LoadBugFieldsClassVar.SubmitBugandAddAttachment();

            //Run catch block
            LoadBugFieldsClassVar.bugVar.Bug_Title__c = 'test12345';
            LoadBugFieldsClassVar.bugVar.version__c = null;
            LoadBugFieldsClassVar.savebug();
            LoadBugFieldsClassVar.SubmitBugandAddAttachment();


            //Run catch block
            LoadBugFieldsClassVar.bugVar.Bug_Title__c = 'test12345';
            LoadBugFieldsClassVar.bugVar.version__c = '1.1';
            LoadBugFieldsClassVar.bugVar.Priority__c = null;
            LoadBugFieldsClassVar.bugVar.Customer_Severity__c = 'Normal';
            LoadBugFieldsClassVar.savebug();
            LoadBugFieldsClassVar.SubmitBugandAddAttachment();

            //Run catch block
            LoadBugFieldsClassVar.bugVar.Bug_Title__c = 'test12345';
            LoadBugFieldsClassVar.bugVar.version__c = '1.1';
            LoadBugFieldsClassVar.bugVar.Priority__c = 'p1';
            LoadBugFieldsClassVar.bugVar.Severity__c = null;
            LoadBugFieldsClassVar.savebug();
            LoadBugFieldsClassVar.SubmitBugandAddAttachment();

            //Bug Redirect controller for update
            b = [select recordtypeid from bug__c where id = : b.id][0];

            pageRef = new PageReference('/apex/Bug_Redirect?RecordType=' + pdkRecordTypeId);
            Test.setCurrentPage(pageRef);
            controller = new Apexpages.StandardController(b);
            BugRedirect BugRedirectvar = new BugRedirect(controller);
            bugredirectvar.redirectToPage();
            //Bug Redirect for insert
            Bug__c btemp = new Bug__c();

            pageRef = new PageReference('/apex/Bug_Redirect?RecordType=' + pdkRecordTypeId);
            Test.setCurrentPage(pageRef);
            controller = new Apexpages.StandardController(btemp);
            BugRedirectvar = new BugRedirect(controller);
            bugredirectvar.redirectToPage();
            pageRef = new PageReference('/apex/Bug_Redirect?RecordType=' + cadRecordTypeId);
            Test.setCurrentPage(pageRef);
            controller = new Apexpages.StandardController(btemp);
            BugRedirectvar = new BugRedirect(controller);
            bugredirectvar.redirectToPage();
            //Bug redirect for clone
            pageRef = new PageReference('/apex/Bug_Redirect?type=clone&RecordType=' + pdkRecordTypeId);
            Test.setCurrentPage(pageRef);
            controller = new Apexpages.StandardController(b);
            BugRedirectvar = new BugRedirect(controller);
            bugredirectvar.redirectToPage();
            //Bug redirect for clone for CAD
            pageRef = new PageReference('/apex/Bug_Redirect?type=clone&RecordType=' + cadRecordTypeId);
            Test.setCurrentPage(pageRef);
            controller = new Apexpages.StandardController(b);
            BugRedirectvar = new BugRedirect(controller);
            bugredirectvar.redirectToPage();
            
            //BugAutoCompleteController Test data
            BugAutoCompleteController autocontroller = new BugAutoCompleteController();
            BugAutoCompleteController.getData('Bug__C','Bug_Title__c','Id','test');
            
        }
        test.stoptest();

    }
    //Method to test the clone,new bug for other record types
    public static testMethod void testLegacyDataRecType() {
         list < BugErrorMessages__c> bugerrorlist = new list < BugErrorMessages__c> ();
         BugErrorMessages__c berror1 = new BugErrorMessages__c ();
         berror1 .name = 'BugResolutionValidation';
         berror1 .Error_Message__c= 'The Resolution field have to be populated for closed, verified and resolved status';
         BugErrorMessages__c berror2 = new BugErrorMessages__c ();
         berror2.name = 'BugDuplicateValidation';
         berror2.Error_Message__c= 'Duplicate Bug field should be populated for the resolution "Duplicate"';
         BugErrorMessages__c berror3 = new BugErrorMessages__c ();
         berror3 .name = 'BugDupeBlockerValidation';
         berror3 .Error_Message__c= 'DupeBlocker Duplicate Prevention';
         bugerrorlist.add(berror1);
         bugerrorlist.add(berror2);
        bugerrorlist.add(berror3);
         insert bugerrorlist;    
    
        test.starttest();
        User sysAdmin = createUser('System Administrator');
        System.runAs(sysAdmin) {
            Design_Spec__c c = new Design_Spec__c();
            c.name = 'tt1';
            c.OpenText_ID__c = 11;

            insert c;
            case cs = new
            case ();
            cs.origin = 'test';
            insert cs;
            Id LegacyDataRecordTypeId = Schema.SObjectType.Bug__c.getRecordTypeInfosByName().get('Legacy Data').getRecordTypeId();
           //Id LegacyDataRecordTypeId = Schema.SObjectType.Bug__c.getRecordTypeInfosByName().get('PDK Bug').getRecordTypeId();
            bug__c b = new bug__c();
            b.Bug_Title__c = 'test zzzz123z11111';
            b.Product_technology__c = 'CAD Environment';
            b.Component__c = 'Documentation';
            b.DE_Spec_Affected__c = c.id;
            b.Bug_Classification__c = 'test';
            b.Priority__c = 'p1';
            b.Severity__c = 'c1';
            b.Version__c = '1.1';
            b.Customer_Severity__c = 'Normal';
            b.recordtypeid = LegacyDataRecordTypeId;
            //insert b;

            bug__c b1 = new bug__c();
            b1.Bug_Title__c = 'test zzzz123z2222';
            b1.Product_technology__c = 'CAD Environment';
            b1.Component__c = 'Documentation';
            b1.DE_Spec_Affected__c = c.id;
            b1.Bug_Classification__c = 'test';
            b1.Priority__c = 'p1';
            b1.Severity__c = 'c1';
            b1.Version__c = '1.1';
            bug__c b2 = new bug__c();
            
            b2.Bug_Title__c = 'test zzzz123z3333';
            b2.Product_technology__c = 'CAD Environment';
            b2.Component__c = 'Documentation';
            b2.DE_Spec_Affected__c = c.id;
            b2.Bug_Classification__c = 'test';
            b2.Priority__c = 'p1';
            b2.Severity__c = 'c1';
            b2.Version__c = '1.1';
            b2.recordtypeid = LegacyDataRecordTypeId;
            // Test code for bug create
            PageReference pageRef = new PageReference('/apex/LoadBugFieldsPage?rid=' + LegacyDataRecordTypeId);
            Test.setCurrentPage(pageRef);
            Apexpages.StandardController controller = new Apexpages.StandardController(b);
            LoadBugFieldsClass LoadBugFieldsClassVar = new LoadBugFieldsClass(controller);
            LoadBugFieldsClassVar.savebug();
            LoadBugFieldsClassVar.cancelBug();

            // Test code for bug create from case
            pageRef = new PageReference('/apex/LoadBugFieldsPage?caseid=' + cs.id + '&rid=' + LegacyDataRecordTypeId);
            Test.setCurrentPage(pageRef);
            controller = new Apexpages.StandardController(b);
            LoadBugFieldsClassVar = new LoadBugFieldsClass(controller);
            LoadBugFieldsClassVar.savebug();
            LoadBugFieldsClassVar.cancelBug();
            insert b;

            // Test code for bug update

            pageRef = Page.LoadBugFieldsPage;
            controller = new Apexpages.StandardController(b);
            LoadBugFieldsClassVar = new LoadBugFieldsClass(controller);
            LoadBugFieldsClassVar.savebug();
            LoadBugFieldsClassVar.SubmitBugandAddAttachment();
            LoadBugFieldsClassVar.cancelBug();
            // Test code for bug Clone
            pageRef = new PageReference('/apex/LoadBugFieldsPage?type=clone&rid=' + LegacyDataRecordTypeId);
            Test.setCurrentPage(pageRef);
            controller = new Apexpages.StandardController(b);
            LoadBugFieldsClassVar = new LoadBugFieldsClass(controller);
            LoadBugFieldsClassVar.savebug();
            
            
             // Test code for bug Clone for CAD
            pageRef = new PageReference('/apex/LoadBugFieldsPage?type=clone&rid=' + LegacyDataRecordTypeId);
            Test.setCurrentPage(pageRef);
            controller = new Apexpages.StandardController(b);
            LoadBugFieldsClassVar = new LoadBugFieldsClass(controller);
            LoadBugFieldsClassVar.savebug();            

            // Test code for create bug and attach
            PageReference pageRef2 = new PageReference('/apex/LoadBugFieldsPage?type=clone&rid=' + LegacyDataRecordTypeId);
            Test.setCurrentPage(pageRef2);
            Apexpages.StandardController controller2 = new Apexpages.StandardController(b);
            LoadBugFieldsClass LoadBugFieldsClassVar2 = new LoadBugFieldsClass(controller2);
            LoadBugFieldsClassVar2.SubmitBugandAddAttachment();


            //Run catch block
            LoadBugFieldsClassVar.bugVar.Bug_Title__c = '';
            LoadBugFieldsClassVar.savebug();
            LoadBugFieldsClassVar.SubmitBugandAddAttachment();

            //Run catch block
            LoadBugFieldsClassVar.bugVar.Bug_Title__c = 'test12345';
            LoadBugFieldsClassVar.bugVar.version__c = null;
            LoadBugFieldsClassVar.savebug();
            LoadBugFieldsClassVar.SubmitBugandAddAttachment();


            //Run catch block
            LoadBugFieldsClassVar.bugVar.Bug_Title__c = 'test12345';
            LoadBugFieldsClassVar.bugVar.version__c = '1.1';
            LoadBugFieldsClassVar.bugVar.Priority__c = null;
            LoadBugFieldsClassVar.savebug();
            LoadBugFieldsClassVar.SubmitBugandAddAttachment();

            //Run catch block
            LoadBugFieldsClassVar.bugVar.Bug_Title__c = 'test12345';
            LoadBugFieldsClassVar.bugVar.version__c = '1.1';
            LoadBugFieldsClassVar.bugVar.Priority__c = 'p1';
            LoadBugFieldsClassVar.bugVar.Severity__c = null;
            LoadBugFieldsClassVar.savebug();
            LoadBugFieldsClassVar.SubmitBugandAddAttachment();

            //Bug Redirect controller for update
            b = [select recordtypeid from bug__c where id = : b.id][0];

            pageRef = new PageReference('/apex/Bug_Redirect?RecordType=' + LegacyDataRecordTypeId);
            Test.setCurrentPage(pageRef);
            controller = new Apexpages.StandardController(b);
            BugRedirect BugRedirectvar = new BugRedirect(controller);
            bugredirectvar.redirectToPage();
            //Bug Redirect for insert
            Bug__c btemp = new Bug__c();

            pageRef = new PageReference('/apex/Bug_Redirect?RecordType=' + LegacyDataRecordTypeId);
            Test.setCurrentPage(pageRef);
            controller = new Apexpages.StandardController(btemp);
            BugRedirectvar = new BugRedirect(controller);
            bugredirectvar.redirectToPage();
            pageRef = new PageReference('/apex/Bug_Redirect?RecordType=' + LegacyDataRecordTypeId);
            Test.setCurrentPage(pageRef);
            controller = new Apexpages.StandardController(btemp);
            BugRedirectvar = new BugRedirect(controller);
            bugredirectvar.redirectToPage();
            //Bug redirect for clone
            pageRef = new PageReference('/apex/Bug_Redirect?type=clone&RecordType=' + LegacyDataRecordTypeId);
            Test.setCurrentPage(pageRef);
            controller = new Apexpages.StandardController(b);
            BugRedirectvar = new BugRedirect(controller);
            bugredirectvar.redirectToPage();
            //Bug redirect for clone for CAD
            pageRef = new PageReference('/apex/Bug_Redirect?type=clone&RecordType=' + LegacyDataRecordTypeId);
            Test.setCurrentPage(pageRef);
            controller = new Apexpages.StandardController(b);
            BugRedirectvar = new BugRedirect(controller);
            bugredirectvar.redirectToPage();
            
            //BugAutoCompleteController Test data
            BugAutoCompleteController autocontroller = new BugAutoCompleteController();
            BugAutoCompleteController.getData('Bug__C','Bug_Title__c','Id','test');
            
        }
        test.stoptest();

    }
    public static testMethod void testCreatePdkBug() {
        //test.starttest();
        
     
        
        list < BugErrorMessages__c> bugerrorlist = new list < BugErrorMessages__c> ();
        BugErrorMessages__c berror1 = new BugErrorMessages__c ();
        berror1 .name = 'BugResolutionValidation';
        berror1 .Error_Message__c= 'The Resolution field have to be populated for closed, verified and resolved status';
        BugErrorMessages__c berror2 = new BugErrorMessages__c ();
        berror2.name = 'BugDuplicateValidation';
        berror2.Error_Message__c= 'Duplicate Bug field should be populated for the resolution "Duplicate"';
        BugErrorMessages__c berror3 = new BugErrorMessages__c ();
        berror3 .name = 'BugDupeBlockerValidation';
        berror3 .Error_Message__c= 'DupeBlocker Duplicate Prevention';
        bugerrorlist.add(berror1);
        bugerrorlist.add(berror2);
        bugerrorlist.add(berror3);
        insert bugerrorlist;  
        
        Account acc = getAccount('MYTEST ACCOUNT1');
        
        Profile p = [SELECT Id FROM Profile WHERE Name = 'System Administrator'];
        User usr = new User(Alias = 'stdUcm', Email = 'testUCM@testOrg.com',
            EmailEncodingKey = 'UTF-8', LastName = 'TestUcm', LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US', ProfileId = p.Id,
            TimeZoneSidKey = 'America/Los_Angeles', Username = 'testUCMUser@testorg.com');
        insert usr;
        
        Map<String,Object> fieldValueMap = new Map<String,Object>();
        fieldValueMap.put('AccountId',acc.Id);
        fieldValueMap.put('Name','Test Opp');  
        fieldValueMap.put('StageName','1. Discovery');
        fieldValueMap.put('CloseDate',date.newinstance(2012, 12, 21));  
        fieldValueMap.put('Target_Process_Node__c','14XM');
        fieldValueMap.put('Market_Segment__c','Automotive');  
        fieldValueMap.put('Process_Platform__c','GF Baseline');
        fieldValueMap.put('Fab_Split__c',100);          
        fieldValueMap.put('Process_Geometry__c','0.014UM');  
        fieldValueMap.put('Process_Family__c','Super Low Power');
        fieldValueMap.put('Opportunity_Sourcing_Type__c','First Source');  
        fieldValueMap.put('Fab_Assignment_1__c','FAB 1');
         
        Opportunity opp = OpportunityDataFactory.createOpportunity(fieldValueMap);

        
        PDK__c objPDK = new PDK__c();
        objPDK.Name = 'Test';
        objPDK.OpenText_ID__c = 3421;
        objPDK.Description__c = 'TestDescription';
        objPDK.Old_Revision_ID__c = 3421;
        insert objPDK;
        
        Id recordTypeTechnicalId = Schema.SObjectType.Case.getRecordTypeInfosByName().get(System.Label.Case_Recordtype_Technical).getRecordTypeId();
        test.starttest();
        
        Case caseObj = new Case (
            Description = 'Test Desc',
            Subject = 'Test Sub',
            Target_process_node__c = '110G',
            Master_PDK__c = objPDK.Id,
            Geometry__c = '0.11UM',
            Need_by_Date__c = Date.Today().addDays(5),
            Process_Variant__c = '10opp',
            Opportunity__c = opp.Id,
            Internal_or_external__c = true,
            AccountId = acc.Id,
            Subcategory__c = 'DFM',
            Metal_Stack__c = 'Testing Metal Stack',
            RecordTypeId = recordTypeTechnicalId
            
        );
        insert caseObj;
        
        Id recordTypePdkBugId = Schema.SObjectType.Bug__c.getRecordTypeInfosByName().get(System.Label.BugPDKRecordTypeName).getRecordTypeId();
        
        Bug__c bugObj = new Bug__c (
            Bug_Title__c = 'Test Sub',
            Bug_Description__c = 'Test Desc',
            Bug_Classification__c = 'Testing Clas',
            Customer_Severity__c = 'Normal',
            Product_Technology__c = '110G',
            Component__c = 'DFM',
            Tool_Name__c = 'Synopsys MAS',
            Severity__c = '2. Tapeout Delay',
            Tool_Version__c = 'Test Version',
            Version__c = 'unspecified',
            Account_Affected__c = acc.Id,
            Priority__c = 'P2',
            RecordTypeId = recordTypePdkBugId
        );
        insert bugObj;
                      
        Bug_Team__c bugTeamObj=new Bug_Team__c();
        bugTeamObj.Bug__c = bugObj.Id;
        bugTeamObj.Chatter_Only__c = true;
        bugTeamObj.Access__c = 'Read/Write';
        bugTeamObj.User__c = usr.Id; 
        insert bugTeamObj;  
        
        String newId = caseObj.Id;        
        FeedItem bugFeed = new FeedItem();
        bugFeed.ParentId = bugObj.Id;
        bugFeed.body = 'Created from Case - Case '+caseObj.CaseNumber;
        insert bugFeed; 
        
        test.stoptest();
    }
    
    public static testMethod void testCreatePdkBug1(){
        test.starttest();
        
        list < BugErrorMessages__c> bugerrorlist = new list < BugErrorMessages__c> ();
        BugErrorMessages__c berror1 = new BugErrorMessages__c ();
        berror1 .name = 'BugResolutionValidation';
        berror1 .Error_Message__c= 'The Resolution field have to be populated for closed, verified and resolved status';
        BugErrorMessages__c berror2 = new BugErrorMessages__c ();
        berror2.name = 'BugDuplicateValidation';
        berror2.Error_Message__c= 'Duplicate Bug field should be populated for the resolution "Duplicate"';
        BugErrorMessages__c berror3 = new BugErrorMessages__c ();
        berror3 .name = 'BugDupeBlockerValidation';
        berror3 .Error_Message__c= 'DupeBlocker Duplicate Prevention';
        bugerrorlist.add(berror1);
        bugerrorlist.add(berror2);
        bugerrorlist.add(berror3);
        insert bugerrorlist;  
        
        Account acc = getAccount('MYTEST ACCOUNT1');
        
        Profile p = [SELECT Id FROM Profile WHERE Name = 'System Administrator'];
        User usr = new User(Alias = 'stdUcm', Email = 'testUCM@testOrg.com',
            EmailEncodingKey = 'UTF-8', LastName = 'TestUcm', LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US', ProfileId = p.Id,
            TimeZoneSidKey = 'America/Los_Angeles', Username = 'testUCMUser@testorg.com');
        insert usr;
        
        Map<String,Object> fieldValueMap = new Map<String,Object>();
        fieldValueMap.put('AccountId',acc.Id);
        fieldValueMap.put('Name','Test Opp');  
        fieldValueMap.put('StageName','1. Discovery');
        fieldValueMap.put('CloseDate',date.newinstance(2012, 12, 21));  
        fieldValueMap.put('Target_Process_Node__c','14XM');
        fieldValueMap.put('Market_Segment__c','Automotive');  
        fieldValueMap.put('Process_Platform__c','GF Baseline');
        fieldValueMap.put('Fab_Split__c',100);          
        fieldValueMap.put('Process_Geometry__c','0.014UM');  
        fieldValueMap.put('Process_Family__c','Super Low Power');
        fieldValueMap.put('Opportunity_Sourcing_Type__c','First Source');  
        fieldValueMap.put('Fab_Assignment_1__c','FAB 1');
         
        Opportunity opp = OpportunityDataFactory.createOpportunity(fieldValueMap); 
        
        PDK__c objPDK = new PDK__c();
        objPDK.Name = 'Test';
        objPDK.OpenText_ID__c = 3421;
        objPDK.Description__c = 'TestDescription';
        objPDK.Old_Revision_ID__c = 3421;
        insert objPDK;
        
        Id recordTypeTechnicalId = Schema.SObjectType.Case.getRecordTypeInfosByName().get(System.Label.Case_Recordtype_Technical).getRecordTypeId();
         
        Case caseObj = new Case (
            Description = 'Test Desc',
            Subject = 'Test Sub',
            Target_process_node__c = '110G',
            Master_PDK__c = objPDK.Id,
            Geometry__c = '0.11UM',
            Need_by_Date__c = Date.Today().addDays(5),
            Process_Variant__c = '10opp',
            Opportunity__c = opp.Id,
            Internal_or_external__c = true,
            AccountId = acc.Id,
            Subcategory__c = 'DFM',
            Metal_Stack__c = 'Testing Metal Stack',
            RecordTypeId = recordTypeTechnicalId
            
        );
        insert caseObj;
        
        Id recordTypePdkBugId = Schema.SObjectType.Bug__c.getRecordTypeInfosByName().get(System.Label.BugPDKRecordTypeName).getRecordTypeId();
        
        Bug__c bugObj = new Bug__c (
            Bug_Title__c = 'Test Sub',
            Bug_Description__c = 'Test Desc',
            Bug_Classification__c = 'Testing Clas',
            Customer_Severity__c = 'Normal',
            Product_Technology__c = '110G',
            Component__c = 'DFM',
            Tool_Name__c = 'Synopsys MAS',
            Severity__c = '2. Tapeout Delay',
            Tool_Version__c = 'Test Version',
            Version__c = 'unspecified',
            Account_Affected__c = acc.Id,
            Priority__c = 'P2',
            RecordTypeId = recordTypePdkBugId
        );
        insert bugObj;
        
        CaseTeamRole caseTMRoleObj = [Select Name from CaseTeamRole where Name='Case Manager (Internal)'];
        
        CaseTeamMember caseTMObj = new CaseTeamMember();
        caseTMObj.MemberId = usr.Id;
        caseTMObj.ParentId = caseObj.Id;
        caseTMObj.TeamRoleId = caseTMRoleObj.Id;
        insert caseTMObj;
                       
        PageReference pageRef = new PageReference('/apex/LoadBugFieldsPage?rid=' + recordTypePdkBugId + '&cid=' + caseObj.Id);
        Test.setCurrentPage(pageRef);
        Apexpages.StandardController controller = new Apexpages.StandardController(bugObj);
        LoadBugFieldsClass LoadBugFieldsClassVar = new LoadBugFieldsClass(controller);
        LoadBugFieldsClassVar.getBugPickVal();
        LoadBugFieldsClassVar.savebug();
        LoadBugFieldsClassVar.cancelBug();
        
        test.stoptest();
    
     }
    public static testMethod void testNegativePdkBug() {
        //test.starttest();
        
        
        
        list < BugErrorMessages__c> bugerrorlist = new list < BugErrorMessages__c> ();
        BugErrorMessages__c berror1 = new BugErrorMessages__c ();
        berror1 .name = 'BugResolutionValidation';
        berror1 .Error_Message__c= 'The Resolution field have to be populated for closed, verified and resolved status';
        BugErrorMessages__c berror2 = new BugErrorMessages__c ();
        berror2.name = 'BugDuplicateValidation';
        berror2.Error_Message__c= 'Duplicate Bug field should be populated for the resolution "Duplicate"';
        BugErrorMessages__c berror3 = new BugErrorMessages__c ();
        berror3 .name = 'BugDupeBlockerValidation';
        berror3 .Error_Message__c= 'DupeBlocker Duplicate Prevention';
        bugerrorlist.add(berror1);
        bugerrorlist.add(berror2);
        bugerrorlist.add(berror3);
        insert bugerrorlist;  
        
        Account acc = getAccount('MYTEST ACCOUNT1');
        
        Profile p = [SELECT Id FROM Profile WHERE Name = 'System Administrator'];
        User usr = new User(Alias = 'stdUcm2', Email = 'testUCM2@testOrg.com',
            EmailEncodingKey = 'UTF-8', LastName = 'TestUcm2', LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US', ProfileId = p.Id,
            TimeZoneSidKey = 'America/Los_Angeles', Username = 'testUCMUser2@testorg.com');
        insert usr;
        
        
        Map<String,Object> fieldValueMap = new Map<String,Object>();
        fieldValueMap.put('AccountId',acc.Id);
        fieldValueMap.put('Name','Test Opp');  
        fieldValueMap.put('StageName','1. Discovery');
        fieldValueMap.put('CloseDate',date.newinstance(2012, 12, 21));  
        fieldValueMap.put('Target_Process_Node__c','14XM');
        fieldValueMap.put('Market_Segment__c','Automotive');  
        fieldValueMap.put('Process_Platform__c','GF Baseline');
        fieldValueMap.put('Fab_Split__c',100);          
        fieldValueMap.put('Process_Geometry__c','0.014UM');  
        fieldValueMap.put('Process_Family__c','Super Low Power');
        fieldValueMap.put('Opportunity_Sourcing_Type__c','First Source');  
        fieldValueMap.put('Fab_Assignment_1__c','FAB 1');
         
        Opportunity opp = OpportunityDataFactory.createOpportunity(fieldValueMap);                
        
        PDK__c objPDK = new PDK__c();
        objPDK.Name = 'Test';
        objPDK.OpenText_ID__c = 3421;
        objPDK.Description__c = 'TestDescription';
        objPDK.Old_Revision_ID__c = 3421;
        insert objPDK;
        
        Id recordTypeTechnicalId = Schema.SObjectType.Case.getRecordTypeInfosByName().get(System.Label.Case_Recordtype_Technical).getRecordTypeId();
        test.starttest();
        
        Case caseObj = new Case (
            Description = 'Test Desc',
            Subject = 'Test Sub',
            Target_process_node__c = '110G',
            Master_PDK__c = objPDK.Id,
            Geometry__c = '0.11UM',
            Need_by_Date__c = Date.Today().addDays(5),
            Process_Variant__c = '10opp',
            Opportunity__c = opp.Id,
            Internal_or_external__c = true,
            AccountId = acc.Id,
            Subcategory__c = 'DFM',
            Metal_Stack__c = 'Testing Metal Stack',
            Priority = 'High',
            RecordTypeId = recordTypeTechnicalId
            
        );
        insert caseObj;
        
        Id recordTypePdkBugId = Schema.SObjectType.Bug__c.getRecordTypeInfosByName().get(System.Label.BugPDKRecordTypeName).getRecordTypeId();
        
        Bug__c bugObj = new Bug__c (
            Bug_Title__c = 'Test Sub',
            Bug_Description__c = 'Test Desc',
            Product_Technology__c = '110G',
            Component__c = 'DFM',
            Tool_Name__c = 'Synopsys MAS',
            Severity__c = '2. Tapeout Delay',
            Tool_Version__c = 'Test Version',
            Version__c = 'unspecified',
            Account_Affected__c = acc.Id,
            Priority__c = 'P1 - High',
            RecordTypeId = recordTypePdkBugId
        );
        insert bugObj;
               
        
        Bug_Team__c bugTeamObj=new Bug_Team__c();
        bugTeamObj.Bug__c = bugObj.Id;
        bugTeamObj.Chatter_Only__c = true;
        bugTeamObj.Access__c = 'Read/Write';
        bugTeamObj.User__c = usr.Id; 
        insert bugTeamObj;        
        
        String newId = caseObj.Id;         
        FeedItem bugFeed = new FeedItem();
        bugFeed.ParentId = bugObj.Id;
        bugFeed.body = 'Created from Case - Case '+caseObj.CaseNumber;
        insert bugFeed;    
                        
        test.stoptest();
    }
    
    public static testMethod void testNegativePdkBug1() {
    
         test.starttest();
      
        list < BugErrorMessages__c> bugerrorlist = new list < BugErrorMessages__c> ();
        BugErrorMessages__c berror1 = new BugErrorMessages__c ();
        berror1 .name = 'BugResolutionValidation';
        berror1 .Error_Message__c= 'The Resolution field have to be populated for closed, verified and resolved status';
        BugErrorMessages__c berror2 = new BugErrorMessages__c ();
        berror2.name = 'BugDuplicateValidation';
        berror2.Error_Message__c= 'Duplicate Bug field should be populated for the resolution "Duplicate"';
        BugErrorMessages__c berror3 = new BugErrorMessages__c ();
        berror3 .name = 'BugDupeBlockerValidation';
        berror3 .Error_Message__c= 'DupeBlocker Duplicate Prevention';
        bugerrorlist.add(berror1);
        bugerrorlist.add(berror2);
        bugerrorlist.add(berror3);
        insert bugerrorlist;  
        
        Account acc = getAccount('MYTEST ACCOUNT1');
        
        Profile p = [SELECT Id FROM Profile WHERE Name = 'System Administrator'];
        User usr = new User(Alias = 'stdUcm2', Email = 'testUCM2@testOrg.com',
            EmailEncodingKey = 'UTF-8', LastName = 'TestUcm2', LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US', ProfileId = p.Id,
            TimeZoneSidKey = 'America/Los_Angeles', Username = 'testUCMUser2@testorg.com');
        insert usr;
        
        Map<String,Object> fieldValueMap = new Map<String,Object>();
        fieldValueMap.put('AccountId',acc.Id);
        fieldValueMap.put('Name','Test Opp');  
        fieldValueMap.put('StageName','1. Discovery');
        fieldValueMap.put('CloseDate',date.newinstance(2012, 12, 21));  
        fieldValueMap.put('Target_Process_Node__c','14XM');
        fieldValueMap.put('Market_Segment__c','Automotive');  
        fieldValueMap.put('Process_Platform__c','GF Baseline');
        fieldValueMap.put('Fab_Split__c',100);          
        fieldValueMap.put('Process_Geometry__c','0.014UM');  
        fieldValueMap.put('Process_Family__c','Super Low Power');
        fieldValueMap.put('Opportunity_Sourcing_Type__c','First Source');  
        fieldValueMap.put('Fab_Assignment_1__c','FAB 1');
         
        Opportunity opp = OpportunityDataFactory.createOpportunity(fieldValueMap); 
        
        PDK__c objPDK = new PDK__c();
        objPDK.Name = 'Test';
        objPDK.OpenText_ID__c = 3421;
        objPDK.Description__c = 'TestDescription';
        objPDK.Old_Revision_ID__c = 3421;
        insert objPDK;
        
        Id recordTypeTechnicalId = Schema.SObjectType.Case.getRecordTypeInfosByName().get(System.Label.Case_Recordtype_Technical).getRecordTypeId();
         
        Case caseObj = new Case (
            Description = 'Test Desc',
            Subject = 'Test Sub',
            Target_process_node__c = '110G',
            Master_PDK__c = objPDK.Id,
            Geometry__c = '0.11UM',
            Need_by_Date__c = Date.Today().addDays(5),
            Process_Variant__c = '10opp',
            Opportunity__c = opp.Id,
            Internal_or_external__c = true,
            AccountId = acc.Id,
            Subcategory__c = 'DFM',
            Metal_Stack__c = 'Testing Metal Stack',
            Priority = 'High',
            RecordTypeId = recordTypeTechnicalId
            
        );
        insert caseObj;
        
        Id recordTypePdkBugId = Schema.SObjectType.Bug__c.getRecordTypeInfosByName().get(System.Label.BugPDKRecordTypeName).getRecordTypeId();
       
        
        Bug__c bugObj = new Bug__c (
            Bug_Title__c = 'Test Sub',
            Bug_Description__c = 'Test Desc',
            Product_Technology__c = '110G',
            Component__c = 'DFM',
            Tool_Name__c = 'Synopsys MAS',
            Severity__c = '2. Tapeout Delay',
            Tool_Version__c = 'Test Version',
            Version__c = 'unspecified',
            Account_Affected__c = acc.Id,
            Priority__c = 'P1 - High',
            RecordTypeId = recordTypePdkBugId
        );
        insert bugObj;
        
        CaseTeamRole caseTMRoleObj = [Select Name from CaseTeamRole where Name='Case Manager (Internal)'];        
        CaseTeamMember caseTMObj = new CaseTeamMember();
        caseTMObj.MemberId = usr.Id;
        caseTMObj.ParentId = caseObj.Id;
        caseTMObj.TeamRoleId = caseTMRoleObj.Id;
        insert caseTMObj;
       // CaseTeamRole caseTMRoleObj = [Select Name from CaseTeamRole where Name='Case Manager (Internal)'];
                                   
        PageReference pageRef = new PageReference('/apex/LoadBugFieldsPage?rid=' + recordTypePdkBugId + '&cid=' + caseObj.Id);
        Test.setCurrentPage(pageRef);
        Apexpages.StandardController controller = new Apexpages.StandardController(bugObj);
        LoadBugFieldsClass LoadBugFieldsClassVar = new LoadBugFieldsClass(controller);
        LoadBugFieldsClassVar.getBugPickVal();
        LoadBugFieldsClassVar.savebug();
        LoadBugFieldsClassVar.cancelBug();
        
        test.stoptest();
    }
}