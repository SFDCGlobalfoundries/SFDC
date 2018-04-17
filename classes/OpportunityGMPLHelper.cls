/*
    Author: Anirban Roy
    Description: This is the helper class for Opportunity and GMPL association.  
    History:
        ARoy        03222014    - code creation.
*/

public class OpportunityGMPLHelper {
    
    public static Boolean hasRun = false;
    public static String stageName1 = '8. Lost';
    public static String stageName2 = '9. Dropped';
    public static String stageName3 = '10. Void';
    
    public static void validateGMPLActive(List<Opportunity> oppList, Map<Id,Opportunity> oldOppMap){
        
        Set<Id> oppIds = new Set<Id>();
        List<Opportunity> oppListNew = new List<Opportunity>();
        for(Opportunity opp : oppList){
            if(opp.StageName != oldOppMap.get(opp.Id).StageName && (opp.StageName == stageName1 
                || opp.StageName == stageName2 || opp.StageName == stageName3)){
                oppIds.add(opp.Id);
                oppListNew.add(opp);
            }
        }
        
        if(oppIds.size()>0){
            boolean isActive = false;
            Set<Id> oppIdActiveSet = new Set<Id>();
            for(Opportunity opp : [select   id
                                            , (select id, BX009_Status__c from GMPL_Opportunity_Junctions__r)
                                            , StageName
                                   from     Opportunity
                                   where    Id in :oppIds]){
                isActive = false;
                if(opp.GMPL_Opportunity_Junctions__r != null && opp.GMPL_Opportunity_Junctions__r.size()>0){
                    for(GMPL_Opportunity__c gmplOpp : opp.GMPL_Opportunity_Junctions__r){
                        if(gmplOpp.BX009_Status__c != null && gmplOpp.BX009_Status__c != 'Completed' && gmplOpp.BX009_Status__c != 'BRB Rejected' 
                            && gmplOpp.BX009_Status__c != 'Customer Rejected' && gmplOpp.BX009_Status__c != 'Void'){
                            isActive = true;
                        }
                    }
                }
                if(isActive){
                    oppIdActiveSet.add(opp.Id);
                }
            }
            
            for(Opportunity opp : oppListNew){
                if(oppIdActiveSet.contains(opp.Id)){
                    opp.addError('Opportunity cannot be made Lost/Dropped/Void if active BX009(s) exists.');
                }
            }
        }
        
        hasRun = true;
    }
    
}