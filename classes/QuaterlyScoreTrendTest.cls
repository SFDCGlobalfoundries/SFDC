@isTest
public class QuaterlyScoreTrendTest{
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
        
        List<VoC_Score__c> vocScoreList = new List<VoC_Score__c>();
        VoC_Score__c testVoCScore = new VoC_Score__c();
        testVoCScore.Area__c = 'Technology Roadmap';
        testVoCScore.Grade_5_best__c = '5';
        testVoCScore.Comments__c = 'test comments';
        testVoCScore.VoC__c = testVoC.id;
        vocScoreList.add(testVoCScore);
        
        VoC_Score__c testVoCScore1 = new VoC_Score__c();
        testVoCScore1.Area__c = 'Fab Operations';
        testVoCScore1.Grade_5_best__c = '5';
        testVoCScore1.Comments__c = 'test comments';
        testVoCScore1.VoC__c = testVoC.id;
        vocScoreList.add(testVoCScore1);
        
        VoC_Score__c testVoCScore2 = new VoC_Score__c();
        testVoCScore2.Area__c = 'Assurance of Supply';
        testVoCScore2.Grade_5_best__c = '5';
        testVoCScore2.Comments__c = 'test comments';
        testVoCScore2.VoC__c = testVoC.id;
        vocScoreList.add(testVoCScore2);
        
        VoC_Score__c testVoCScore3 = new VoC_Score__c();
        testVoCScore3.Area__c = 'Design Enablement';
        testVoCScore3.Grade_5_best__c = '5';
        testVoCScore3.Comments__c = 'test comments';
        testVoCScore3.VoC__c = testVoC.id;
        vocScoreList.add(testVoCScore3);
        
        VoC_Score__c testVoCScore4 = new VoC_Score__c();
        testVoCScore4.Area__c = 'Capacity';
        testVoCScore4.Grade_5_best__c = '5';
        testVoCScore4.Comments__c = 'test comments';
        testVoCScore4.VoC__c = testVoC.id;
        vocScoreList.add(testVoCScore4);
        
        VoC_Score__c testVoCScore5 = new VoC_Score__c();
        testVoCScore5.Area__c = 'Attentiveness';
        testVoCScore5.Grade_5_best__c = '5';
        testVoCScore5.Comments__c = 'test comments';
        testVoCScore5.VoC__c = testVoC.id;
        vocScoreList.add(testVoCScore5);
        
        VoC_Score__c testVoCScore6 = new VoC_Score__c();
        testVoCScore6.Area__c = 'Price';
        testVoCScore6.Grade_5_best__c = '5';
        testVoCScore6.Comments__c = 'test comments';
        testVoCScore6.VoC__c = testVoC.id;
        vocScoreList.add(testVoCScore6);
        
        VoC_Score__c testVoCScore7 = new VoC_Score__c();
        testVoCScore7.Area__c = 'Ease of Doing Business';
        testVoCScore7.Grade_5_best__c = '5';
        testVoCScore7.Comments__c = 'test comments';
        testVoCScore7.VoC__c = testVoC.id;
        vocScoreList.add(testVoCScore7);
        
        insert vocScoreList;
        
        test.startTest();
        ApexPages.StandardController con = new ApexPages.StandardController(testCon);
        QuaterlyScoreAreaTrendController quatCon = new QuaterlyScoreAreaTrendController(con);
        Boolean isSF1 = quatCon.isSF1;          
        quatCon.getLinearData();
        
        ApexPages.StandardController acc = new ApexPages.StandardController(testAcct);
        QuaterlyScoreTrendAggregateController quatAcc = new QuaterlyScoreTrendAggregateController(acc);
        Boolean isSF11 = quatAcc.isSF1;           
        quatAcc.getLinearData();
        
        test.stopTest();
     }
}