@isTest
global class CaseStausToCloseBatchSchedulableTest
{
    public static testmethod void testingmethod()
    {
        DataUtilTest.loadEnvironmentVariables();
        Account acct=new Account();  
        acct=(Account)Account.sObjectType.newSObject(NULL,true);
        acct.Name = 'Test';
        acct.short_name__c='TESTACC';
        //datalist.add(acct);
        insert acct;
        
        Id recordTypeTechnicalId = Schema.SObjectType.Case.getRecordTypeInfosByName().get(System.Label.Case_Recordtype_Technical).getRecordTypeId();
        
        Case c1 = new Case(Status = 'Resolved - pending PDK release', Origin = 'Email', Type = 'Bug Report', RecordTypeId = recordTypeTechnicalId,
                           Description = 'Test 10', Subject = 'Test 14', Category__c = 'GFV-My Devices',Subcategory__c='Web View',Target_process_node__c = 'Other',
                           Priority = 'Low',AccountId = acct.Id,Internal_or_external__c = true,Hold_Justification__c = 'test');
        
        insert c1;
        
        RecordType RecType2 = [Select Id From RecordType  Where SobjectType = 'Bug__c' and RecordType.DeveloperName = 'CAD_Bug'];
        
        Bug__c objBug = new Bug__c (RecordTypeId = RecType2.Id,
                                Bug_Title__c='Bug - Something',Status__c = 'Closed',Resolution__c='Fixed',Resolution_Details__c='Fixed');
              
        insert objBug;
        
        CaseBugAssociation__c objCaseBug1=new CaseBugAssociation__c(Case__c=c1.Id,Bug__c=objBug.Id);
        
        FeedItem feedItemObj = new FeedItem(
                    Body = 'The Bug(s) associated with this Case have closed/shipped',
                    ParentId = c1.Id,
                    Status = 'Published',
                    VISIBILITY = 'AllUsers'
                );
        insert feedItemObj;        
        
               
        test.StartTest();
        CaseStausToCloseBatchSchedulable obj=new CaseStausToCloseBatchSchedulable();// after 24 hours
        obj.execute(NULL);
        
        test.StopTest();
        
    }
    
    public static testmethod void TestBatch() {
    
    DataUtilTest.loadEnvironmentVariables();
    List<case> caseLst = new list<case>();
        Account acct=new Account();  
        acct=(Account)Account.sObjectType.newSObject(NULL,true);
        acct.Name = 'Test';
        acct.short_name__c='TESTACC';
        //datalist.add(acct);
        insert acct;
        
        Id recordTypeTechnicalId = Schema.SObjectType.Case.getRecordTypeInfosByName().get(System.Label.Case_Recordtype_Technical).getRecordTypeId();
        
        Case c1 = new Case(Status = 'Resolved - pending PDK release', Origin = 'Email', Type = 'Bug Report', RecordTypeId = recordTypeTechnicalId,
                           Description = 'Test 10', Subject = 'Test 14', Category__c = 'GFV-My Devices',Subcategory__c='Web View',Target_process_node__c = 'Other',
                           Priority = 'Low',AccountId = acct.Id,Internal_or_external__c = true,Hold_Justification__c = 'test');
        caseLst.add(c1);
        insert caseLst;
        
        RecordType RecType2 = [Select Id From RecordType  Where SobjectType = 'Bug__c' and RecordType.DeveloperName = 'CAD_Bug'];
        
        Bug__c objBug = new Bug__c (RecordTypeId = RecType2.Id,
                                Bug_Title__c='Bug - Something',Status__c = 'Closed',Resolution__c='Fixed',Resolution_Details__c='Fixed');
              
        insert objBug;
        
        CaseBugAssociation__c objCaseBug1=new CaseBugAssociation__c(Case__c=c1.Id,Bug__c=objBug.Id);
        insert objCaseBug1;
                
          test.startTest();
          CaseStausToCloseBatch batchObj = new CaseStausToCloseBatch ();         
          batchObj.query = 'Select id,Status,Public_comments__c from Case where id =: c1.id limit 1';
          ID batchprocessid = Database.executeBatch(batchObj); 
          test.stopTest();
        
     }
    }