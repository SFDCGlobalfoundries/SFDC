/*Author: Karthick
* Description: This trigger runs on CaseBugAssociation object. This trigger 
                validates the duplicate relationship between case and bug. 
* History: Created on 6/23/2014

 Modified on : 08/20/14 for make it bulk operable and implement skip logic (Karthick).
*/


trigger CaseBugAssociationTrigger on CaseBugAssociation__c (before insert, before update) {
    if(!IntegrationUserUtil.isSkipTrigger())
    {
      /*  if (trigger.isInsert || trigger.isUpdate)
        {
            list <id> caseidList = new list <id>();
            list <id> bugidList = new list <id>();
            
            for(CaseBugAssociation__c cb : trigger.new)
                {
                    bugidList.add(cb.bug__c);
                    caseidList.add(cb.case__c);
                }
                
             system.debug('testing11' + bugidList + caseidList);
             
            if([select id from CaseBugAssociation__c where Bug__c in :bugidList and Case__c = :caseidList].size() > 0)
                trigger.new[0].addError('Bug is already associated to the case');
        }
        */
    }
}