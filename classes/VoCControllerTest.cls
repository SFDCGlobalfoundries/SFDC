@isTest
public class VoCControllerTest{
    @testSetup static void testdata() {
        DataUtilTest.loadEnvironmentVariables();
    }
    static testMethod void manageVocInsert(){
        // Create Account
        RecordType rt = [
            SELECT      Id
            FROM        RecordType
            WHERE       SObjectType = 'Account'
                        AND Name = 'Customer'
        ];
        
        Account testAcct = new Account();
        testAcct.Name = 'Test Account';
        testAcct.Stage__c = 'Unqualified';
        testAcct.Site_Department__c = 'Test Department';
        testAcct.Sub_Type__c = 'Direct';
        testAcct.Transaction_Type__c = 'Transactional';
        testAcct.Region__c = 'APJ';
        testAcct.Bill_To_Address_1__c = 'Test Address 1';
        testAcct.Corporate_Address_1__c = 'Corporate Address 1';
        testAcct.Bill_To_City__c = 'Test City';
        testAcct.Corporate_City__c = 'Test City';
        testAcct.Bill_To_Country__c = 'Singapore';
        testAcct.Corporate_Country__c = 'Singapore';
        testAcct.RecordTypeId = rt.Id;      
        testAcct.Short_Name__c = 'TestAcct';
        
        insert testAcct;
        
        Contact testCon = new Contact();
        testCon.firstName = 'test';
        testCon.LastName = 'test';
        testCon.Email = 'test@gmail.com';
        testCon.accountId = testAcct.id;
        insert testCon;
        
        
        VoC__c testVoC= new VoC__c();
        testVoC.Account__c = testAcct.Id;
        testVoC.Contact__c = testCon.id;
        testVoC.Date_Feedback_Provided__c = system.today();
        testVoC.Schedule_Next_Follow_Up__c = system.today();
        testVoC.Action_Owner__c = userinfo.getUserId();
        insert testVoC;
        
        VoC_Score__c testVoCScore = new VoC_Score__c();
        testVoCScore.Area__c = 'Technology Roadmap';
        testVoCScore.Grade_5_best__c = '5';
        testVoCScore.Comments__c = 'test comments';
        testVoCScore.VoC__c = testVoC.id;
        insert testVoCScore;
        
        test.startTest();
        ApexPages.StandardController voc = new ApexPages.StandardController(testVoC);
        VoCController con = new VoCController(voc);
        Test.setCurrentPageReference(new PageReference('Page.VoC'));
        System.currentPageReference().getParameters().put('id', testVoC.id);
        String vocName = con.vocName;
        //Integer toDelIdent = VoCController.toDelIdent;
        VoCController.toDelIdent = 1;
        Integer addCount = VoCController.addCount;
        Boolean isSF1 = con.isSF1;
        con.saveRec();
        con.cancelRec();
        con.editRec();
        con.delWrapper();
        con.addRows();
        con.save();
        con.addUpdateScore();
        con.cancelVoCScore();
        //delete testVoCScore;
        test.stopTest();
    }
    
    static testMethod void method2(){
        // Create Account
        RecordType rt = [
            SELECT      Id
            FROM        RecordType
            WHERE       SObjectType = 'Account'
                        AND Name = 'Customer'
        ];
        
        Account testAcct = new Account();
        testAcct.Name = 'Test Account';
        testAcct.Stage__c = 'Unqualified';
        testAcct.Site_Department__c = 'Test Department';
        testAcct.Sub_Type__c = 'Direct';
        testAcct.Transaction_Type__c = 'Transactional';
        testAcct.Region__c = 'APJ';
        testAcct.Bill_To_Address_1__c = 'Test Address 1';
        testAcct.Corporate_Address_1__c = 'Corporate Address 1';
        testAcct.Bill_To_City__c = 'Test City';
        testAcct.Corporate_City__c = 'Test City';
        testAcct.Bill_To_Country__c = 'Singapore';
        testAcct.Corporate_Country__c = 'Singapore';
        testAcct.RecordTypeId = rt.Id;      
        testAcct.Short_Name__c = 'TestAcct';
        
        insert testAcct;
        
        Contact testCon = new Contact();
        testCon.firstName = 'test';
        testCon.LastName = 'test';
        testCon.Email = 'test@gmail.com';
        testCon.accountId = testAcct.id;
        insert testCon;
        
        
        VoC__c testVoC= new VoC__c();
        testVoC.Account__c = testAcct.Id;
        //testVoC.Contact__c = testCon.id;
        testVoC.Date_Feedback_Provided__c = system.today();
        testVoC.Schedule_Next_Follow_Up__c = system.today();
        testVoC.Action_Owner__c = userinfo.getUserId();       
        
        test.startTest();
        ApexPages.StandardController voc = new ApexPages.StandardController(testVoC);
        VoCController con = new VoCController(voc);
        Test.setCurrentPageReference(new PageReference('Page.VoC'));
        System.currentPageReference().getParameters().put('id', testVoC.id);
        String vocName = con.vocName;        
        VoCController.toDelIdent = 1;
        Integer addCount = VoCController.addCount;
        Boolean isSF1 = con.isSF1;
        con.saveRec();
        con.cancelRec();
        con.editRec();
        con.delWrapper();
        con.addRows();
        con.save();
        con.addUpdateScore();
        con.cancelVoCScore();        
        test.stopTest();
    }
    
    static testMethod void method3(){
        
        RecordType rt = [
            SELECT      Id
            FROM        RecordType
            WHERE       SObjectType = 'Account'
                        AND Name = 'Customer'
        ];
        
        Account testAcct = new Account();
        testAcct.Name = 'Test Account';
        testAcct.Stage__c = 'Unqualified';
        testAcct.Site_Department__c = 'Test Department';
        testAcct.Sub_Type__c = 'Direct';
        testAcct.Transaction_Type__c = 'Transactional';
        testAcct.Region__c = 'APJ';
        testAcct.Bill_To_Address_1__c = 'Test Address 1';
        testAcct.Corporate_Address_1__c = 'Corporate Address 1';
        testAcct.Bill_To_City__c = 'Test City';
        testAcct.Corporate_City__c = 'Test City';
        testAcct.Bill_To_Country__c = 'Singapore';
        testAcct.Corporate_Country__c = 'Singapore';
        testAcct.RecordTypeId = rt.Id;      
        testAcct.Short_Name__c = 'TestAcct';
        
        insert testAcct;
        
        Contact testCon = new Contact();
        testCon.firstName = 'test';
        testCon.LastName = 'test';
        testCon.Email = 'test@gmail.com';
        testCon.accountId = testAcct.id;
        insert testCon;
        
        
        VoC__c testVoC= new VoC__c();
        testVoC.Account__c = testAcct.Id;
        testVoC.Contact__c = testCon.id;
        testVoC.Date_Feedback_Provided__c = system.today();
        testVoC.Schedule_Next_Follow_Up__c = system.today();
        testVoC.Action_Owner__c = userinfo.getUserId();        
        
        test.startTest();
        ApexPages.StandardController voc = new ApexPages.StandardController(testVoC);
        VoCController con = new VoCController(voc);
        Test.setCurrentPageReference(new PageReference('Page.VoC'));
        System.currentPageReference().getParameters().put('id', testVoC.id);
        String vocName = con.vocName;        
        VoCController.toDelIdent = 1;
        Integer addCount = VoCController.addCount;
        Boolean isSF1 = con.isSF1;
        con.saveRec();
        con.cancelRec();
        con.editRec();
        con.delWrapper();
        con.addRows();
        con.save();
        con.addUpdateScore();
        con.cancelVoCScore();                
        test.stopTest();
    }
}