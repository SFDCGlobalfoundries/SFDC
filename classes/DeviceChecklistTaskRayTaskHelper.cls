/*
Author: Sreedhar Karukonda
Description: This class is helper for TaskRay Project Task object Trigger. 
History:
skarukonda     03022014     - code creation.
Change Log:    Updated     -     Sreedhar   -     10/02/2014
                [Reason]   Removed TASKRAY Application Objects Dependency  
*/

public without sharing class DeviceChecklistTaskRayTaskHelper{
     /*
     * On Task insert, Deadline is calculated based on Days Due Before Tapeout(Days_Due_Before_TO__c). 
     * Deadline is  Device's "Current Forecast Tapeout Date" - Task's "Days Due Before Tapeout".
     * Only Evaluated if related Device has "Current Forecast Tapeout Date".
     */
     public static void addDeadlineOnInsert(List<Checklist_Task__c> newTasks){
      DeviceChecklistUtils.deviceTapeoutDatePropagation = true;
        set<id> projectsId= new set<id>();
        for(Checklist_Task__c task : newTasks){
            if(task.Container__c != null){
                projectsId.add(task.Container__c);
            }
        }
        if(projectsId.size() > 0){
            Map<Id, Checklist_Container__c> projectsWithDeviceToDate = new Map<Id, Checklist_Container__c>(
                [select id, Device_TO_Date__c from Checklist_Container__c where Device_TO_Date__c != null and id in :projectsId]            
            );
            if(projectsWithDeviceToDate.size() > 0){
                for(Checklist_Task__c task : newTasks){
                    if(task.Container__c != null && task.Override_Tapeout_Date__c != true && task.Days_Due_Before_TO__c != null && projectsWithDeviceToDate.get(task.Container__c) != null){
                        task.Deadline__c = projectsWithDeviceToDate.get(task.Container__c).Device_TO_Date__c.addDays(-task.Days_Due_Before_TO__c.intValue());
                    }
                    else if(task.Container__c != null && task.Override_Tapeout_Date__c != true && task.Days_Due_Before_TO__c == null && projectsWithDeviceToDate.get(task.Container__c) != null){
                        task.Deadline__c = projectsWithDeviceToDate.get(task.Container__c).Device_TO_Date__c;
                    }
                }
            }
        }
        //DeviceChecklistUtils.deviceTapeoutDatePropagation = false;
     }

     /*
     * On Days Due before Tape out(Days_Due_Before_TO__c) change, Task Dealine reevaluated. 
     */
     public static void updateDeadlineOnTaskUpdate(Map<Id, Checklist_Task__c> newTasks, Map<Id, Checklist_Task__c> oldTasks){
      System.debug('************** DEVICE TO DATE PROPAGATION '+ DeviceChecklistUtils.deviceTapeoutDatePropagation );
        set<id> projectsId= new set<id>();
        for(Checklist_Task__c task : newTasks.values()){
            if(task.Container__c != null && (oldTasks.get(task.id).Container__c  != task.Container__c || oldTasks.get(task.id).Days_Due_Before_TO__c != task.Days_Due_Before_TO__c)){
                projectsId.add(task.Container__c);
            }
        }
        if(projectsId.size() > 0){
            Map<Id, Checklist_Container__c> projectsWithDeviceToDate = new Map<Id, Checklist_Container__c>(
                [select id, Device_TO_Date__c from Checklist_Container__c where Device_TO_Date__c != null and id in :projectsId]            
            );
            if(projectsWithDeviceToDate.size() > 0){
                for(Checklist_Task__c task : newTasks.values()){
                    if(task.Container__c != null && task.Days_Due_Before_TO__c != null && projectsWithDeviceToDate.get(task.Container__c) != null && !task.Override_Tapeout_Date__c){
                        task.Deadline__c = projectsWithDeviceToDate.get(task.Container__c).Device_TO_Date__c.addDays(-task.Days_Due_Before_TO__c.intValue());
                    }
                    //If days to TO is not there then Device Deadline is going to be the TO date 
                    else if(task.Container__c != null && task.Days_Due_Before_TO__c == null && projectsWithDeviceToDate.get(task.Container__c) != null && !task.Override_Tapeout_Date__c){
                        task.Deadline__c = projectsWithDeviceToDate.get(task.Container__c).Device_TO_Date__c;
                    }
                }
            }
        }
     }

     /*
     * On Task Completion, Update "Is Completed" to true and Capture completed date for reporting.
     * On Dealine change, flag ""
     */
     public static void updateTasks(Map<Id, Checklist_Task__c> newTasks, Map<Id, Checklist_Task__c> oldTasks){
        for(Checklist_Task__c task : newTasks.values()){
            if(oldTasks.get(task.id).Status__c  != task.Status__c){
                if(task.Status__c == 'Completed'){
                  task.Is_Completed__c = true;
                  task.Completed_Date__c = Date.today();
                }else if(task.Status__c != 'Completed'){
                  task.Is_Completed__c= false;
                  task.Completed_Date__c = null;
                }
            }


            if(oldTasks.get(task.id).Is_Completed__c  != task.Is_Completed__c){
                if(task.Is_Completed__c == true){
                  task.Status__c = 'Completed';
                  task.Completed_Date__c = Date.today();
                }else{
                  task.Status__c = 'Open';
                  task.Completed_Date__c = null;
                }
            }
            System.debug(task);
            if(DeviceChecklistUtils.deviceTapeoutDatePropagation == false && oldTasks.get(task.id).Deadline__c != task.Deadline__c){
              task.Override_Tapeout_Date__c = true;
            }
        }
        set<id> projectsId= new set<id>();
        for(Checklist_Task__c task: newTasks.values()){
          if(task.Container__c != null){
            projectsId.add(task.Container__c);
          }
        }
        if(projectsId.size() > 0){
            Map<Id, Checklist_Container__c> projectsWithDeviceToDate = new Map<Id, Checklist_Container__c>(
                [select id, Device_TO_Date__c from Checklist_Container__c where Device_TO_Date__c != null and id in :projectsId]            
            );
            if(projectsWithDeviceToDate.size() > 0){
                for(Checklist_Task__c task : newTasks.values()){
                    if(task.Container__c != null && task.Days_Due_Before_TO__c != null && projectsWithDeviceToDate.get(task.Container__c) != null && !task.Override_Tapeout_Date__c){
                        task.Deadline__c = projectsWithDeviceToDate.get(task.Container__c).Device_TO_Date__c.addDays(-task.Days_Due_Before_TO__c.intValue());
                    }
                    //If days to TO is not there then Device Deadline is going to be the TO date 
                    else if(task.Container__c != null && task.Days_Due_Before_TO__c == null && projectsWithDeviceToDate.get(task.Container__c) != null && !task.Override_Tapeout_Date__c){
                        task.Deadline__c = projectsWithDeviceToDate.get(task.Container__c).Device_TO_Date__c;
                    }
                }
            }
        }
     }
}