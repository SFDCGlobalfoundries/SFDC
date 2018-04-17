/*Author: Karthick D
* Description: This trigger runs on RelatedBugAssciation object to avoid 
               duplicate relationship between bug records.
* History: Created on 4/13/2014
 Modified on : 08/20/14 for make it bulk operable and implement skip logic (Karthick).
 Modified on : 10/21/14 changes made to optimize the trigger code(Karthick).
*/

trigger RelatedBugAssociationTrigger on RelatedBugAssociation__c (before insert) {
if(!IntegrationUserUtil.isSkipTrigger())
    {
        list <string> idList = new list <string> ();
        for(RelatedBugAssociation__c relatedBug : trigger.new)
        {
            idList.add(relatedBug .buga__c);
            idList.add(relatedBug .bugb__c);
        }
        list <RelatedBugAssociation__c> relatedRecordList = new list <RelatedBugAssociation__c>();
        relatedRecordList = [select id, Relasionship__c, buga__r.name, bugb__r.name from RelatedBugAssociation__c  where buga__c in :idlist and 
                            bugb__c in :idlist];
        if(relatedRecordList.size() > 0)
            {
                for(RelatedBugAssociation__c relatedBug : trigger.new)
                {
                    for(RelatedBugAssociation__c relBug : relatedRecordList)
                        if((relatedBug.bugA__c == relBug.bugA__c && relatedBug.bugB__c == relBug.bugB__c) || 
                           (relatedBug.bugA__c == relBug.bugB__c && relatedBug.bugB__c == relBug.bugA__c))
                               relatedBug .addError('Bug ' +relBug.bugb__r.name+ ' is already associated with Bug  ' + relBug.buga__r.name + ' with relationship "' + relBug.Relasionship__c +'"');
                }
                
            }
       }
    }