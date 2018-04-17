/****
    Author: Sreedhar Karukonda
    Description: This is Utility class used in TaskRay Project Trigger. 
    
    History:
Change Log:    05142014     - code creation.
Change Log:    Updated     -     Sreedhar   -     10/02/2014
                [Reason]   Removed TASKRAY Application Objects Dependency  
*****/

public without sharing class DeviceChecklistTaskRayProjectHelper {

    public static boolean hierarchyBuilding{
      get{
        if(hierarchyBuilding == null) hierarchyBuilding = false;
        return hierarchyBuilding;
      }
      set;
    }

    public static boolean deletingInprogress{
      get{
        if(deletingInprogress == null) deletingInprogress = false;
        return deletingInprogress;
      }
      set;
    }

  public static void afterInsert(Map<Id, Checklist_Container__c> newContainersMap){
    try{
      updateHierarchy(newContainersMap) ;
    }catch(Exception e){
      for(Checklist_Container__c container: newContainersMap.values()){
        container.addError(e.getMessage());
      }
    }
  }

  public static void afterUpdate(Map<Id, Checklist_Container__c> oldContainersMap, Map<Id, Checklist_Container__c> newContainersMap){
    try{
      updateHierarchy(newContainersMap) ;
    }catch(Exception e){
      for(Checklist_Container__c container: newContainersMap.values()){
        container.addError(e.getMessage());
      }
    }

    for(Checklist_Container__c container: newContainersMap.values()){
        if(container.Hierarchy_Level__c >= 6){
          container.addError('Checklist Container can be upto 5 level deep');
        }
    }
  }
  public static void beforeDelete(Map<Id, Checklist_Container__c> oldContainersMap){

    if( deletingInprogress == false){
      List<Id> deletedContainerIds = new List<Id>(oldContainersMap.keySet());

      Map<Id, Checklist_Container__c> subContainer = new Map<Id, Checklist_Container__c>([Select Id from Checklist_Container__c where 
                                                Parent__c in :deletedContainerIds Or Parent__r.Parent__c in :deletedContainerIds Or
                                                Parent__r.Parent__r.Parent__c in :deletedContainerIds Or Parent__r.Parent__r.Parent__r.Parent__c in :deletedContainerIds Or
                                                Parent__r.Parent__r.Parent__r.Parent__r.Parent__c in :deletedContainerIds]);
      for(Id cid: oldContainersMap.keySet()){
        subContainer.remove(cid);
      }
      for(Id cid: subContainer.keySet()){
        deletedContainerIds.add(cid);
      }
      List<CheckList_Task__c> tasks = [select Id from CheckList_Task__c where Container__c in :deletedContainerIds];
      delete tasks;
      deletingInprogress = true;
      delete subContainer.values();
      deletingInprogress = false;
    }
  }

  public static void updateHierarchy(Map<Id, Checklist_Container__c> newContainersMap ){
    if(hierarchyBuilding == false){
      List<Id> containerIds = new List<Id>(newContainersMap.keySet());
      List<Checklist_Container__c> containers = [select Id, Archive_Project__c, Hierarchy_Level__c, Parent__c, Parent__r.Parent__c, Parent__r.Parent__r.Parent__c, 
                        Parent__r.Parent__r.Parent__r.Parent__c , Parent__r.Parent__r.Parent__r.Parent__r.Parent__c, 
                        Parent__r.Parent__r.Parent__r.Parent__r.Parent__r.Parent__c  from Checklist_Container__c where Id in : containerIds ];
      Set<Id> programIdsSet = new Set<Id>();
      for(Checklist_Container__c container: containers){
        if(container.Hierarchy_Level__c == 0){
          programIdsSet.add(container.Id);
        } else if(container.Hierarchy_Level__c == 1){
          programIdsSet.add(container.Parent__c);
        } else if(container.Hierarchy_Level__c == 2){
          programIdsSet.add(container.Parent__r.Parent__c);
        } else if(container.Hierarchy_Level__c == 3){
          programIdsSet.add(container.Parent__r.Parent__r.Parent__c);
        } else if(container.Hierarchy_Level__c == 4){
          programIdsSet.add(container.Parent__r.Parent__r.Parent__r.Parent__c);
        } else if(container.Hierarchy_Level__c == 5){
          programIdsSet.add(container.Parent__r.Parent__r.Parent__r.Parent__r.Parent__c);
        } 
      }
      List<Id> programIds = new List<Id>(programIdsSet);
      List<Checklist_Container__c> checklistContainers =  [select Id, Archive_Project__c, Account__c, Program__c, Parent__c, Opportunity__c, 
                                  Opportunity_Program__c, Device__c, BX_041__c, Hierarchy_Level__c, Type__c, Subtype__c from Checklist_Container__c where
                                  Id in :programIds or
                                  Parent__c in :programIds or
                                  Parent__r.Parent__c in :programIds or
                                  Parent__r.Parent__r.Parent__c in :programIds or
                                  Parent__r.Parent__r.Parent__r.Parent__c in :programIds or
                                  Parent__r.Parent__r.Parent__r.Parent__r.Parent__c in :programIds or
                                  Parent__r.Parent__r.Parent__r.Parent__r.Parent__r.Parent__c in :programIds 
                                  Order by Hierarchy_Level__c asc];
      Map<Id, Checklist_Container__c> needUpdateContainer = new Map<Id, Checklist_Container__c>();
      for(Checklist_Container__c container: checklistContainers){
        if(container.Hierarchy_Level__c == 0){
          needUpdateContainer.put(container.Id, new Checklist_Container__c(Id= container.Id, Device__c= container.Device__c, 
                                                                            Account__c = container.Account__c, BX_041__c = container.BX_041__c, 
                                                                            Opportunity__c = container.Opportunity__c, 
                                                                            Opportunity_Program__c = container.Opportunity_Program__c,
                                                                            Type__c = container.Type__c, Subtype__c = container.Subtype__c, Archive_Project__c = container.Archive_Project__c));
        }else if(container.Hierarchy_Level__c == 1){

          Checklist_Container__c parent = needUpdateContainer.get(container.Parent__c);
          needUpdateContainer.put(container.Id, new Checklist_Container__c(Id= container.Id, Device__c= parent.Device__c, 
                                                                            Account__c = parent.Account__c, BX_041__c = parent.BX_041__c, 
                                                                            Opportunity__c = parent.Opportunity__c, 
                                                                            Opportunity_Program__c = parent.Opportunity_Program__c,
                                                                            Parent__c = container.Parent__c, Program__c = container.Parent__c,
                                                                            Type__c = parent.Type__c, Subtype__c = parent.Subtype__c, Archive_Project__c = parent.Archive_Project__c));
        }else{
          Checklist_Container__c parent = needUpdateContainer.get(container.Parent__c);
          needUpdateContainer.put(container.Id, new Checklist_Container__c(Id= container.Id, Device__c= parent.Device__c, 
                                                                            Account__c = parent.Account__c, BX_041__c = parent.BX_041__c, 
                                                                            Opportunity__c = parent.Opportunity__c, 
                                                                            Opportunity_Program__c = parent.Opportunity_Program__c,
                                                                            Parent__c = container.Parent__c, Program__c = parent.Program__c,
                                                                            Type__c = parent.Type__c, Subtype__c = parent.Subtype__c, Archive_Project__c = parent.Archive_Project__c));
        }
      }

      System.debug(checklistContainers);
      hierarchyBuilding = true;
      update needUpdateContainer.values();
      hierarchyBuilding = false;
    }
  }
}