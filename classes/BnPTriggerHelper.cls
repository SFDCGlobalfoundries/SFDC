/**
@Author < Varsha Tomar >
@name < BnPTriggerHelper >
@CreateDate < 11/29/2016 >
@Description < Helper class for BNPRequestInfoTrigger >
@Version <1.0>
*/
public class BnPTriggerHelper {
    
    // update decision association with new quote when requote is done
    public void updateDecision() {
    
    Map<Id, Id> optionRfqIdMap = new Map<Id, Id>();
            for(Request_Information__c reqInfo : (List<Request_Information__c>)Trigger.new){
                
                    optionRfqIdMap.put(reqInfo.Customer_Requirement__c, reqInfo.id);
                
            }
    
        // query decision record related to option of quote
        List<Decision__c> decisionList = [select Technical_Requirement__c from Decision__c 
                            where Technical_Requirement__c = :optionRfqIdMap.keySet()];
        
        if(decisionList != null && decisionList.size() > 0) {
            for(Decision__c dc :decisionList) {
                // populate new quote on decision
                if(optionRfqIdMap != null && optionRfqIdMap.containsKey(dc.Technical_Requirement__c)) {
                    dc.Request_Information__c = optionRfqIdMap.get(dc.Technical_Requirement__c);
                }
            }
            try {
                update decisionList;
            
            } catch(Exception e) {
               GlobalUtility.logMessage('Error','BnPTriggerHelper','updateDecision','','Exception while updating Decision Record',String.valueof(e.getMessage()),'','Customer Decision',e,0);
            }
        }
    }
}