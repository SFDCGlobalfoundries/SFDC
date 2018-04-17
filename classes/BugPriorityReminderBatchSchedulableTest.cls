@isTest
global class BugPriorityReminderBatchSchedulableTest {
    
     public static testmethod void TestBatch2() {
    
        DataUtilTest.loadEnvironmentVariables();
        List<case> caseLst = new list<case>();
        Account acct=new Account();  
        acct=(Account)Account.sObjectType.newSObject(NULL,true);
        acct.Name = 'Test';
        acct.short_name__c='TESTACC';
        //datalist.add(acct);
        insert acct;
        
        Contact objContact = new Contact();
        objContact.firstName = 'Kali';
        objContact.lastname  = 'Sandipam';
        objContact.email = 'noreply@salesforce.com';
        
        insert objContact;
        
        Contact objContact2 = new Contact();
        objContact2.firstName = 'Kali2';
        objContact2.AccountId = acct.Id;
        objContact2.lastname  = 'Sandipam2';
        objContact2.email = 'noreply-salesforce@globalfoundries.com';
        
        insert objContact2;
               
        
        id BugrecordTypeId = Schema.SObjectType.Bug__c.getRecordTypeInfosByName().get('ASIC Bug').getRecordTypeId();
        bug__c b = new bug__c();
        b.Bug_Title__c = 'test zzzz123z1';
        b.Product_technology__c = 'CAD Environment';
        b.Component__c = 'Documentation';
        b.Bug_Classification__c = 'test';
        b.Priority__c = 'P1 - High';
        b.Severity__c = 'c1';
        b.Version__c = '1.1';
        b.recordtypeid = BugrecordTypeId;
        b.Sub_Type_A__c   =   'ESPRESSO';
        b.Sub_Type_B__c   =   'System Hardware';
        b.Sub_Type_C__c   =   'Boards';
        b.Problem_Class__c = 'Enhancement';
        b.Projected_Availability_Date__c= system.today()+1;
        b.Status__c  = 'In Process';
        b.DevComplete__c = false;
        b.Dev_Only__c='No';
        
        insert b;
        //Test.setCreatedDate(b.Id, DateTime.newInstance(2012,12,12));
		
		system.assertEquals('In Process',b.Status__c);  
        
               
         test.startTest();
          BugPriorityReminderBatch batchObj = new BugPriorityReminderBatch ();         
          batchObj.query =  ' Select id,Priority__c,name,LastModifiedDate,owner.email from bug__c where Status__c != \'Closed\' and Status__c != \'Resolved\' '+
                            ' and Status__c != \'Duplicate\' and Dev_Only__c = \'NO\' and DevComplete__c = false and IsASICBug__c = true  and id =: b.id ';
          
          batchObj.p1Date = System.now()+1;
          
          ID batchprocessid = Database.executeBatch(batchObj); 
          
          
          test.stopTest();
          }
    public static testmethod void testbatch3() {
        DataUtilTest.loadEnvironmentVariables();
        List<case> caseLst = new list<case>();
        
        Account mainAccount = new Account();
        mainAccount.name = 'Test';
        mainAccount.Site_Department__c = 'Site13';
        mainAccount.short_name__c = 'TESTACC';
        mainAccount.Sub_Type__c = 'Direct';
        mainAccount.Transaction_Type__c = 'Transactional';
        mainAccount.Region__c = 'APJ';
        mainAccount.Bill_To_Address_1__c = 'New Bill43';
        mainAccount.Bill_To_City__c = 'city13';
        mainAccount.Bill_To_Country__c = 'Austria';
        mainAccount.Corporate_Address_1__c = 'BTM';
        mainAccount.Corporate_City__c = 'city13';
        mainAccount.Corporate_Country__c = 'Austria';
        insert mainAccount;
        
        Contact objContact = new Contact();
        objContact.firstName = 'Kali';
        objContact.lastname  = 'Sandipam';
        objContact.email = 'noreply@salesforce.com';
        
        insert objContact;
        
         Contact objContact2 = new Contact();
        objContact2.firstName = 'Kali2';
        objContact2.lastname  = 'Sandipam2';
        objContact2.email = 'noreply-salesforce@globalfoundries.com';
        
        insert objContact2;
               
        
        id BugrecordTypeId = Schema.SObjectType.Bug__c.getRecordTypeInfosByName().get('ASIC Bug').getRecordTypeId();
        bug__c b = new bug__c();
        b.Bug_Title__c = 'test zzzz123z1';
        b.Product_technology__c = 'CAD Environment';
        b.Component__c = 'Documentation';
        b.Bug_Classification__c = 'test';
        b.Priority__c = 'P1 - High';
        b.Severity__c = 'c1';
        b.Version__c = '1.1';
        b.recordtypeid = BugrecordTypeId;
        b.Sub_Type_A__c   =   'ESPRESSO';
        b.Sub_Type_B__c   =   'System Hardware';
        b.Sub_Type_C__c   =   'Boards';
        b.Problem_Class__c = 'Service Request';
        b.Status__c  = 'New';
        b.DevComplete__c = false;
        b.CreatedDate = system.today()-15;
        b.LastModifiedDate = system.today()-10;
        b.Dev_Only__c='No';
        insert b;
		
		system.assertEquals('New',b.Status__c);
               
          test.startTest();
          BugPriorityReminderBatch batchObj = new BugPriorityReminderBatch ();         
          batchObj.query =  ' Select id,Priority__c,name,LastModifiedDate,owner.email from bug__c where Status__c != \'Closed\' and Status__c != \'Resolved\' '+
                            ' and Status__c != \'Duplicate\' and Dev_Only__c = \'NO\' and DevComplete__c = false and IsASICBug__c = true  and id =: b.id ';
          
          batchObj.p1Date = system.now()-1;
          
          ID batchprocessid = Database.executeBatch(batchObj); 
          
          test.stopTest();
          }
          
    
         
    
}