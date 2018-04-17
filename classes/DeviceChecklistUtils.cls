/*Author: SREEDHAR KARUKONDA
    Description: This is a utility class for Device Checklist project code. 
    History:
    03192014     - code creation.
    05142014     - Updated Code to test updated requiremtns.
Change Log:    Updated     -     Sreedhar   -     10/02/2014
                [Reason]   Removed TASKRAY Application Objects Dependency  
*/


public without sharing class DeviceChecklistUtils {

    /*
    * This flag varible is set when update to the tasks are initiated by Device record change
    */
    public static boolean deviceTapeoutDatePropagation{
        get{
            if(deviceTapeoutDatePropagation == null) deviceTapeoutDatePropagation = false;
            return deviceTapeoutDatePropagation;
        }
        set;
    }
    
    /*
    * This flag varible is set when update to the tasks are initiated by Device record change
    */
    public static boolean checklistCloningInProgress{
        get{
            if(checklistCloningInProgress == null) checklistCloningInProgress = false;
            return checklistCloningInProgress;
        }
        set;
    }
    

    
   /*
      Returns user can edit NPI Template
   */
    public static boolean canEditTemplate{
      get{
          if(canEditTemplate == null) {
              GF_TaskRay_Project_NPI_Editors__c npiTemplateEditor  = GF_TaskRay_Project_NPI_Editors__c.getInstance();
              if(npiTemplateEditor != null){
                  canEditTemplate= npiTemplateEditor.NPI_Project_Template_Editable__c;
              } else{
                  canEditTemplate = false;
              }
          }
          return canEditTemplate;
      }
      set;
    }


    
    /*
    * On Device Change, Update the tasks depends on the Device Fields
    * On Current Forecast Tapeout Date change, propagate the change to Device Checklist Tasks 
    */
    public static void onDeviceToChange(Map<Id, Device__c> newDevices, Map<Id,Device__c> oldDevices){
        /* This method has future call, future call can not be made from future method call. 
         * If the transaction started as future methods, we need to skip this logic.
        */
        if(!System.isFuture()){
            set<Id> toUpdatedDevicesId = new Set<Id>();
            for(id did: newDevices.keySet()){
                if(newDevices.get(did).Checklist__c != null && (newDevices.get(did).Current_Forecast_Tapeout_Date__c != oldDevices.get(did).Current_Forecast_Tapeout_Date__c )){
                    toUpdatedDevicesId.add(did);
                }
            }
            if(toUpdatedDevicesId.size() > 0){
                DeviceChecklistUtils.updateTasksOnDeviceToDateChange(toUpdatedDevicesId);
            }
        }  
    }
    
    /*
     * THIS DATE CHANGE SHOULD REFLECT IN ALL TASKS WHICH ARE NOT FLAGED TO OVERRIDE TAPEOUT DATE.
     * Any Task that is dependent of the field of Device should be closed
    */
    @future
    public static void updateTasksOnDeviceToDateChange(Set<id> deviceIds){
        DeviceChecklistUtils.deviceTapeoutDatePropagation = true;
        List<Checklist_Task__c> tasks = [select id, Is_Completed__c, Dependent_Object__c, Dependent_Field__c, Dependent_Field_Completed_Value__c,  
                                                    Dependent_Field_Type__c, Container__r.Device__c, Override_Tapeout_date__c, Days_Due_Before_TO__c, 
                                                    Deadline__c, Container__r.Device_TO_Date__c 
                                                    from Checklist_Task__c where Container__r.Device__c in :deviceIds  and Not_Applicable__c = false];
        Map<Id, Checklist_Task__c> tasksToUpdate = new Map<Id, Checklist_Task__c>();
        for(Checklist_Task__c task : tasks){
            if(task.Override_Tapeout_date__c == false){
                system.debug('THIS TASK '+ task.Override_Tapeout_date__c);
                if(task.Days_Due_Before_TO__c != null && task.Container__r.Device_TO_Date__c != null){
                    Date tempDeadline = task.Container__r.Device_TO_Date__c.addDays(-task.Days_Due_Before_TO__c.intValue());
                    if(tempDeadline != task.Deadline__c){
                        tasksToUpdate.put(task.id, new Checklist_Task__c( id= task.id, Deadline__c = tempDeadline));
                    }
                }else if(task.Days_Due_Before_TO__c == null && task.Container__r.Device_TO_Date__c != null){
                    if(task.Container__r.Device_TO_Date__c != task.Deadline__c){
                        tasksToUpdate.put(task.id, new Checklist_Task__c( id= task.id, Deadline__c = task.Container__r.Device_TO_Date__c, Is_Completed__c = task.Is_Completed__c));
                    }
                }
            }
        }
        if(tasksToUpdate.size() > 0){
            update tasksToUpdate.values();
        }
    }
          

    
    
      /* 
      * Generic Exception class
      */
      public class GFTaskRayException extends Exception{
      }
      
}