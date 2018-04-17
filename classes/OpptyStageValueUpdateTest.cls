@isTest
public class OpptyStageValueUpdateTest
{
    @TestSetup
    public static void SetupTestData()
    {
        DataUtilTest.loadEnvironmentVariables();
        Id Acc=DeviceUtilTest.createAccount();
        DeviceUtilTest.createOpp(Acc,'0.014UM');
    }
    public static testmethod void TestChangeinProbability()
    {
        Opportunity opp=[select id,StageName,Probability from Opportunity limit 1];
       
        opp.Probability=25;
        opp.Fab_Assignment_1__c='Fab 1';
        update opp;
        
        List<OpportunityStage> OpptyStageList =[SELECT APiName,DefaultProbability,MasterLabel FROM OpportunityStage where IsActive=True and (DefaultProbability<>0 AND ForecastCategoryName<>'Omitted')];
           
        Map<String,Decimal> StageProbabilityMap=new Map<String,Decimal>();
        for(OpportunityStage x: OpptyStageList)
            StageProbabilityMap.put(x.APiName,x.DefaultProbability);
            
            
        Test.startTest();
        opp.StageName='4. Decision';
        opp.AM_CP1__c = true;
        opp.FAE_CP1__c = true;
        opp.AM_CP2__c = true;
        opp.FAE_CP2__c = true;
        opp.PLM_CP2__c = true;
        opp.MarketSegment_CP2__c = true;
        opp.Probability=StageProbabilityMap.get('4. Decision');
        update opp;
        Test.stopTest();
        Opportunity res=[select id,StageName,Probability from Opportunity where id = :opp.id limit 1];
        System.assertEquals('4. Decision',res.StageName);
        System.assertEquals(75.0,res.Probability);
        //System.assert(OpptyStageValueUpdate.OpptyStageList.size()>0);
    }
}