/*
    Author: Zymark Ambat
    Description: Trigger for Visitation_Record__c.
    History:
        ZAmbat        08212014    - code creation.
*/

public class VisitationSetRegionHead {
	public static void updateRegionHead(Map<Id, Id> mapAccountRH) {
		List<Visitation_Record__c> listVisitation = new List<Visitation_Record__c>(); 
		for (Visitation_Record__c v : [SELECT		Id
													, Account__c
													, Territory_Head_for_Approval__c
									   FROM			Visitation_Record__c
									   WHERE		Account__c IN :mapAccountRH.keySet()]) {
			v.Territory_Head_for_Approval__c = mapAccountRH.get(v.Account__c);
			listVisitation.add(v);
		}
		
		if (listVisitation.size() > 0) {
			update listVisitation;
		}
	}
}