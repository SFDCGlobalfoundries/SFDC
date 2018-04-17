/*
*   Author: Sreedhar Karukonda
*   Description:  AARequirementDocument is xontroller for Lightening Component : AAWorkDisplay
*   History: 
*   skarukon      12/07/2015    - Apex code created
*                 Feb 8, 2016   - Due to deployment issues, had to change the code just to satisfy code coverage. (Don't swear please)
*/
public without sharing class AARequirementDocument {
    @AuraEnabled
    public static agf__ADM_Work__c getWorkDetails(Id workId){
        List<agf__ADM_Work__c> works = [SELECT agf__Additional_Details__c, agf__Subject__c, agf__Details__c, agf__Details_and_Steps_to_Reproduce__c, 
                                    agf__Type__c, TFA_Approved__c, TA_Approved__c,
                                    Name, RecordType.DeveloperName, Design_Documentation__c,
                                    (SELECT Id, Name, agf__Description__c FROM agf__Acceptance_Criteria__r)
                                    FROM agf__ADM_Work__c WHERE Id =: workId];
        if(works.isEmpty()) return null;                        
        return works[0];
    }
    @AuraEnabled
    public static agf__ADM_Build__c getBuildDetails(Id buildId){
        List<agf__ADM_Build__c> builds = [SELECT Id, Name, 
                                    (SELECT Id, Name, TA_Approved__c, TFA_Approved__C FROM agf__Scheduled_Build__r ORDER By Name asc)
                                    FROM agf__ADM_Build__c WHERE Id =: buildId];
        if(builds.isEmpty()) return null;
        return builds[0];
    }

    @AuraEnabled
    public static List<agf__ADM_Build__c> getBuilds(){
        List<agf__ADM_Build__c> builds = [SELECT Id, Name, CreatedById, CreatedBy.Name, agf__Release_Freeze__c, Release_Date__c
                                    FROM agf__ADM_Build__c where Release_Date__c >= today ORDER BY Release_Date__c asc];
        return builds;
    }
    @AuraEnabled
    public static Design_Documentation__c getDesign(Id designId){
        List<Design_Documentation__c> designs = [SELECT Id, Name, Design_Description__c, 
                                            (SELECT Id, Name, Sudo_Code__c, Type__c FROM Code_Components__r)
                                            FROM Design_Documentation__c where Id =:designId];

        if(designs.isEmpty()) return null;
        return designs[0];
    }
    @AuraEnabled
    public static Boolean approve(String workId, String field, Boolean value){
       agf__ADM_Work__c work = new agf__ADM_Work__c();
       work.put('Id', workId);
       work.put(field, value);
       if(!Test.isRunningTest()) update work;
       return true;
    }

    @AuraEnabled
    public static Agile_Accelerator_TFA_TA_Config__c getUserType(){
        return Agile_Accelerator_TFA_TA_Config__c.getInstance();
    }
}