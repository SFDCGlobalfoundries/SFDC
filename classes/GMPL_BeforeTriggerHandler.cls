/*
    Author: Anirban Roy
    Description: This is the helper class for the trigger GMPL_BeforeTrigger.  
    History:
        ARoy        04102014    - code creation.
*/

public class GMPL_BeforeTriggerHandler {
	
	public static Boolean hasRun = false;
	
	public static void refreshLifetimeRevenue(List<GMPL_BX009__c> gmplBx009List){
		
		Set<Id> gmplIds = new Set<Id>();
		for(GMPL_BX009__c gmpl : gmplBx009List){
			gmplIds.add(gmpl.Id);
		}	
		
		Map<Id, Decimal> gmplIdRevenueMap = new Map<Id, Decimal>();
		for(AggregateResult gmplAggRes : [select	SUM(Total_Lifetime_Revenue__c) totalRev
													, GMPL_BX009__c
										  from		GMPL_Opportunity__c
										  where		GMPL_BX009__c in :gmplIds
										  group by	GMPL_BX009__c]){
			gmplIdRevenueMap.put((Id)gmplAggRes.get('GMPL_BX009__c'), (Decimal)gmplAggRes.get('totalRev'));		
		}
		
		for(GMPL_BX009__c gmpl : gmplBx009List){
			gmpl.Total_Lifetime_Revenue__c = gmplIdRevenueMap.get(gmpl.Id)!=null?gmplIdRevenueMap.get(gmpl.Id):0.0;
			gmpl.Lifetime_Revenue_Refresh_Timestamp__c = System.now();
		}
		
		hasRun = true;
	}
	
}