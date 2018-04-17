/***************************************************************************************************************************
Class:         DeviceChecklistCloneAPI
----------------------------------------------------------------------------------------------------------------------------
Author:        Sreedhar karukonda
Created Date:  02/10/2014
Reason:        Utility class to clone a Checklist Container hierarchy (Clones both child Containers and tasks below the a Checklist Container)

Change Log:    Created     -     Sreedhar     -     02/10/2014
***************************************************************************************************************************/

public without sharing class DeviceChecklistCloneAPI {
    public static Id cloneHierarchey(Id continerId, String clonedChecklistName, Map<String, String> fieldValueMap){
        Integer randomNumber= (Math.random() * 1000).intValue();
        Long milliseconds = Datetime.now().getTime();
        String returnRecordExternalId = ((String)continerId + milliseconds) + randomNumber;
        List<Checklist_Container__c> containers = [SELECT CloneExternalId__c, Display_Sequence__c, Id,  Name, Not_Applicable__c, OwnerId, Parent__c, 
                                                    Parent__r.CloneExternalId__c, RecordTypeId, Subtype__c,  Template_Name__c, Type__c, Hierarchy_Level__c, 
                                                    Program__c, Program__r.CloneExternalId__c FROM Checklist_Container__c  where Id= :continerId or 
                                                    Parent__c = :continerId or Parent__r.Parent__c = :continerId or Parent__r.Parent__r.Parent__c = :continerId or 
                                                    Parent__r.Parent__r.Parent__r.Parent__c = :continerId or Parent__r.Parent__r.Parent__r.Parent__r.Parent__c = :continerId or 
                                                    Parent__r.Parent__r.Parent__r.Parent__r.Parent__r.Parent__c = :continerId order by Hierarchy_Level__c asc];
        Map<String, String> relationshipMap = new Map<String, String>();
        String programExtId = null;
        for(Checklist_Container__c container : containers){
            if(container.id == continerId){
                if(container.Hierarchy_Level__c != 0){
                    relationshipMap.put((String)container.id + milliseconds + randomNumber, container.Parent__r.CloneExternalId__c);
                    programExtId = container.Program__r.CloneExternalId__c;
                }else{
                    programExtId = returnRecordExternalId;
                }
                if(clonedChecklistName != null){
                    container.Name = clonedChecklistName;
                }
            }else{
                relationshipMap.put((String)container.id + milliseconds + randomNumber, (String)container.Parent__c + milliseconds + randomNumber );
            }
            container.CloneExternalId__c = (String)container.Id + milliseconds + randomNumber;
            if(fieldValueMap != null){
                for(String fieldName: fieldValueMap.keySet()){
                    container.put(fieldName, fieldValueMap.get(fieldName));
                }
            }
            
            container.Parent__c = null;
            //container.Parent__r = null;
            container.Program__c = null;
            //container.Program__r = null;
        }
        List<Checklist_Container__c> clonedContainers = containers.deepClone(false, false, false);
        insert clonedContainers;
        System.debug('clonedContainers : '+clonedContainers);
        List<Checklist_Container__c> updateRelationship = new List<Checklist_Container__c>();
        for(String containerKey: relationshipMap.keySet()){
            updateRelationship.add(new Checklist_Container__c(CloneExternalId__c =containerKey, 
                                                                Parent__r = new Checklist_Container__c(CloneExternalId__c = relationshipMap.get(containerKey)),
                                                                Program__r = new Checklist_Container__c(CloneExternalId__c = programExtId)
                                                            ));
        }
        Database.upsert(updateRelationship, Schema.Checklist_Container__c.Fields.CloneExternalId__c, true);


        Set<Id> projectIds = new Set<Id>();
        for(Checklist_Container__c container: containers){
            projectIds.add(container.Id);
        }
        Map<String, String> extIdsToIds = new Map<String, String>();
        for(Checklist_Container__c ccontainer: clonedContainers){
            extIdsToIds.put(ccontainer.CloneExternalId__c, ccontainer.Id);
        }


        List<Checklist_Task__c> tasksInHierarchy = [ SELECT Completed_Date__c, Container__c, Current_Status__c,DateTime_Place_Holder__c,Date_Place_Holder__c,
                                                                    Days_Due_Before_TO__c,Deadline_to_TO_Date__c,Deadline__c,Decimal_Place_Holder__c,Dependency_Tootip__c,
                                                                    Dependent_Field_Completed_Value__c,Dependent_Field_Type__c,Dependent_Field__c,Dependent_Object__c,
                                                                    Device_TO_Date__c, Is_Completed__c, Mandatory__c,Name,Not_Applicable__c,Number_Place_Holder__c,
                                                                    Override_Tapeout_Date__c,Over_Due__c, Owner_Group__c,Red_Flag__c,Sequence__c,Status__c,
                                                                    Task_Status__c,Template_Lock__c,TextArea_Place_Holder__c,Text_Place_Holder__c,To_Be_Completed__c 
                                                                    FROM Checklist_Task__c where Container__c in: projectIds];

        List<Checklist_Task__c> tasksToClone =  tasksInHierarchy.deepClone(false, false, false);

        for(Checklist_Task__c task : tasksToClone){
            String ccontainerId = extIdsToIds.get((String)task.Container__c + milliseconds + randomNumber);
            task.Container__c = ccontainerId;
        }

        if(tasksToClone.size() > 0){
            insert tasksToClone;
        }
        List<Checklist_Container__c> queryClonedChecklist =[select Id from Checklist_Container__c where CloneExternalId__c=: (String)continerId+ milliseconds + randomNumber];

        if(queryClonedChecklist != null && queryClonedChecklist.size()>0){
            return queryClonedChecklist[0].Id;
        } 
        return null;
    }
}