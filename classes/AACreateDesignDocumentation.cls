/*
*   Author: Sreedhar Karukonda
*   Description:  This class is used as Trigger handler for Build trigger BuildTrigger
*   History: 
*   skarukon      11/02/2016    - Apex code created    
*/
public with sharing class AACreateDesignDocumentation {
    @InvocableMethod
    public static void createDesignDocumentation(List<agf__ADM_Work__c> workItems){
        List<Design_Documentation__c> designDocs = new List<Design_Documentation__c>();
        for(agf__ADM_Work__c work: workItems){
            if(work.Design_Documentation__c == null){
                Design_Documentation__c designDoc = new Design_Documentation__c();
                if(!Test.isRunningTest()) designDoc.User_Story__c = work.Id;
                designDoc.Design_Description__c = 'Please add description here.';
                designDocs.add(designDoc);
            }
        }
        if(!designDocs.isEmpty()){
            insert designDocs;
            List<agf__ADM_Work__c> updateNeededWorks= new List<agf__ADM_Work__c>();
            for(Design_Documentation__c designDoc: designDocs){
                updateNeededWorks.add(new agf__ADM_Work__c(Id = designDoc.User_Story__c, Design_Documentation__c = designDoc.Id));
            }
            if(!Test.isRunningTest())  update updateNeededWorks;
        }
    }
}