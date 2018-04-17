@isTest
public class VoCScoreTriggerUtilTest{
     @testSetup static void testdata() {
        DataUtilTest.loadEnvironmentVariables();
    }
    static testMethod void manageTrendsInsert(){
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
        VoC_Score__c testVoCScore1 = new VoC_Score__c();
        testVoCScore1.Area__c = 'Technology Roadmap';
        testVoCScore1.Grade_5_best__c = '5';
        testVoCScore1.Comments__c = 'test comments';
        testVoCScore1.VoC__c = testVoC.id;
        insert testVoCScore1;
        
        testVoCScore1.Grade_5_best__c = '2';
        update testVoCScore1;
        test.stopTest();
        
    }
    
    static testMethod void manageTrendsDelete(){
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
        VoC_Score__c testVoCScore1 = new VoC_Score__c();
        testVoCScore1.Area__c = 'Technology Roadmap';
        testVoCScore1.Grade_5_best__c = '5';
        testVoCScore1.Comments__c = 'test comments';
        testVoCScore1.VoC__c = testVoC.id;
        insert testVoCScore1;
        
        testVoCScore1.Grade_5_best__c = '2';
        delete testVoCScore1;   
        delete testVoC;      
        test.stopTest();
        
    }
}