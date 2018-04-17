/***************************************************************************************************************************
Class:         DeviceChecklistSyncTaskBatchUtil
----------------------------------------------------------------------------------------------------------------------------
Author:        Joydev Mondol (Cognizant - 153480)
Created Date:  29/07/2014
Reason:        Utility class for sync task completion on opportunities and device updates as follows:

               (1) Schedule job runs and checks all updated Opportunities and Devices which have Device Checklist and are 
                   updated after previous successfully ran scheduled job.
               (2) Query Device Checklists and Task related to those updated Opportunities and Devices and update tasks 
                   which satisfy complete condition.
               (3) In Checklist_Task__c object, we have following fields : Dependent Object, Dependent Field, 
                   Dependent Field Completed Value, Dependent Field Type. Dependent Object can be  Opportunity OR Device 
               
               Example: “TaskX” of “DeviceChecklistA” and “ DeviceChecklistA” related to “Opportunity1” and “Device1”

                        Task X’s definition:
                        
                        Dependent Object:                 Opportunity
                        Dependent Field:                  Status__c
                        Dependent Field Type:             Picklist
                        Dependent Field Completed Value:  Design Won
                        
                        If “Opportunity1” is updated and Opportunity1’s Status__c is equal to “Design Won” then “TaskX” 
                        should be automatically completed (set: Is_Completed__c = true).

Change Log:    Created     -     JOYDEV     -     29/07/2014
Change Log:    Updated     -     JOYDEV     -     10/07/2014
               Reason: New logic - If “Opportunity1” is updated and Opportunity1’s Status__c is equal to “Design Won” then 
                                   “TaskX” should be automatically completed (set: Is_Completed__c = true) else uncompleted 
                                   (set: Is_Completed__c = true)
Change Log:    Updated     -     JOYDEV     -     11/07/2014
               Reason: New logic - If “Dependent_Field_Completed_Value__c” contains the string “__notnull”then task should 
                                   be automatically completed (set: Is_Completed__c = true)
                       New logic - If “Dependent_Field_Type__c” is Multi-select picklist, the value comparision logic with 
                                   field “Dependent_Field_Completed_Value__c” needs to be updated to handle unordered comma 
                                   separated picklist values
                       (*) Code optimized !
Change Log:    Updated     -     JOYDEV     -     14/07/2014
               Reason: Code fix - (1) "System.QueryException: duplicate field selected:" in the dynamic SOQL for opportunity 
                                       and device;
                                  (2) "System.NullPointerException: Attempt to de-reference a null object:
                                       Class.DeviceChecklistSyncTaskBatch.Execute: line 161, column 1";
Change Log:    Updated     -     JOYDEV     -     22/07/2014   
               Reason: Code fix - (1) "_NULL" changed to "__NOTNULL"  
Change Log:    Updated     -     JOYDEV     -     29/07/2014   
               Reason: New functionality - 
                                  (1) Need to capture scheduled sync job start time.
                                  (2) User should be able to initiate sync job for opened checklist and it needs to 
                                      capture user click sync start date time in Last Sync Date field of the checklist.
                                  (3) Header (in device checklist hierarchy view page) should show which ever is latest 
                                      either scheduled sync job start time OR user initiated sync.     
Change Log:    Updated     -     JOYDEV     -     31/07/2014   
               Reason: New functionality - 
                                  (1) Need to send errors to specified email id in custom setting if any    
                       (*) Code cleaned !  
Change Log:    Updated     -     Sreedhar   -     10/02/2014
                [Reason]   Removed TASKRAY Application Objects Dependency    
***************************************************************************************************************************/

global without sharing class DeviceChecklistSyncTaskBatchUtil {

    /*schedule interval in minutes*/
    global Integer Interval { get; set; }
    
    /*last sync timestamp*/
    global DateTime LastSyncDateTime { get; set; }
    
    /*Batch error message(s) for the entire job*/
    public String BatchErrors { get; set; }
    public String BatchErrorsHtml { get; set; }
    
    /*custom scope of tasks in terms of device checklist*/
    public Id ChecklistId { get; set; }
    
    /*final NOT-NULL String (can be fetched from custom setting to make it flexible)*/
    final static String NotNullVal = '__notnull';
    
    /**     
    *  method:         SOQLUtil
    *  args:           none
    *  return type:    String (SOQL Query)
    *  purpose:        this method does the following:  
    *                  (1) Constructs the SOQL query for the scope generation 
    **/
    global String SOQLUtil() {
        LastSyncDateTime = (LastSyncDateTime == Null ? 
                            System.now().addMinutes(-(Interval > 0 ? Interval : 5)) : LastSyncDateTime);
        
        String szLastIntervalTimeStamp = 
            LastSyncDateTime.formatGMT('yyyy-MM-dd') + 'T' + LastSyncDateTime.formatGMT('HH:mm:ss.SSS') + 'Z';
            
        String szSOQL = 'SELECT ';
        String szSOQLCLAUSE = '';
        
        for(Schema.FieldSetMember f : 
                Schema.SObjectType.Checklist_Container__c.fieldSets.DeviceChecklistSyncTaskFieldSet.getFields()) {
            String szFname = f.getFieldPath();
            String szFname_r = szFname.replace('__c', '__r');
            szSOQL += 'Container__r.' + szFname + ', ';
            szSOQLCLAUSE += '(Container__r.' + szFname + ' <> NULL AND ' + 
                          + ' Container__r.' + szFname_r + '.LastModifiedDate > ' +
                          + szLastIntervalTimeStamp + ') OR ';
        }
        
        szSOQL += (szSOQL.contains(' Id') ? '' : ' Id ') 
                + (szSoql.contains(' Name') ? '' : ', Name ') 
                + (szSoql.contains(' Is_Completed__c') ? '' : ', Is_Completed__c ') 
                + (szSoql.contains(' Dependent_Object__c') ? '' : ', Dependent_Object__c ') 
                + (szSoql.contains(' Dependent_Field__c') ? '' : ', Dependent_Field__c ') 
                + (szSoql.contains(' Dependent_Field_Type__c') ? '' : ', Dependent_Field_Type__c ') 
                + (szSoql.contains(' Dependent_Field_Completed_Value__c') ? '' : ', Dependent_Field_Completed_Value__c ') 
                + (szSoql.contains(' Container__r.Program__c') ? '' : ', Container__r.Program__c ') 
                + ' FROM Checklist_Task__c '
                + (ChecklistId != Null ? 
                  ' WHERE Container__r.Program__c = \'' + ChecklistId + '\'' :
                  ' WHERE Dependent_Object__c <> NULL AND '
                + '       Dependent_Field__c <> NULL AND '
                + '       Dependent_Field_Completed_Value__c <> NULL AND '
                + '       (' + szSOQLCLAUSE.substring(0, szSOQLCLAUSE.length()-4) + ')'
                + ' AND Container__r.Archive_Project__c = false'); // Sreedhar: added Project Archive feature. 
                                                              //Don't sync tasks under Archived Prjects

                        
        System.debug('[JOYDEV:DEBUG] >> SOQLUtil() ... szSOQL = ' + szSOQL);
            
        return szSOQL;
    }
    
    /**     
    *  method:         ExecuteUtil
    *  args:           scope (Sobject scope of the DeviceChecklistSyncTaskBatch instance)
    *  return type:    none
    *  purpose:        this method does the following:  
    *                  (1) Schedule job runs and checks all updated Opportunities and Devices which have Device Checklist 
    *                      and are updated after previous successfully ran scheduled job.
    *                  (2) Query Device Checklists and Task related to those updated Opportunities and Devices and update 
    *                      tasks which satisfy complete condition.
    *                  (3) In Checklist_Task__c object, we have following fields : Dependent Object, Dependent 
    *                      Field, Dependent Field Completed Value, Dependent Field Type. Dependent Object can be  
    *                      Opportunity OR Device 
    *                     
    *                      Example: “TaskX” of “DeviceChecklistA” and “ DeviceChecklistA” related to “Opportunity1” and 
    *                               “Device1”
    *       
    *                                Task X’s definition:
    *                                
    *                                Dependent Object:                 Opportunity
    *                                Dependent Field:                  Status__c
    *                                Dependent Field Type:             Picklist
    *                                Dependent Field Completed Value:  Design Won
    *                                
    *                                If “Opportunity1” is updated and Opportunity1’s Status__c is equal to “Design Won” 
    *                                then “TaskX” should be automatically completed (set: Is_Completed__c = true). 
    *                    
    *                  (4) Captures scheduled sync job start time. 
    **/
    global void ExecuteUtil(List<Checklist_Task__c> scope) {
        /*list of tasks to be updated (to be completed)*/
        Map<Id, Checklist_Task__c> MasterTasksToUpdate = new Map<Id, Checklist_Task__c>();
        
        /*list of parent device checklist to be updated with latest sync timestamp*/
        Map<Id, Checklist_Container__c> MasterDCLToUpdate = new Map<Id, Checklist_Container__c>();
        /*set of all the tasks' parent device checklist*/
        Set<Id> parentChecklistIds = new Set<Id>();
            
        /*Map of Dependent object Id with Dependent object*/
        Map<Id, Sobject> DependentSobjectMap = new Map<Id, Sobject>();  
        /*map of SOQL based on feildset members in 'DeviceChecklistSyncTaskFieldSet'*/ 
        Map<String, String> DependentSOQLMap = new Map<String, String>();
        /*map of SOQL IN Filters based on feildset members in 'DeviceChecklistSyncTaskFieldSet'*/ 
        Map<String, String> DependentSOQLFilterMap = new Map<String, String>();
        
        List<Schema.FieldSetMember> fields = 
            Schema.SObjectType.Checklist_Container__c.fieldSets.DeviceChecklistSyncTaskFieldSet.getFields();
        
        for(Schema.FieldSetMember f : fields) {
            DependentSOQLMap.put(f.getFieldPath(), 'SELECT ');
            DependentSOQLFilterMap.put(f.getFieldPath(), '(');
        }
        
        for(Checklist_Task__c tsk : scope) {
            /*populate opportunity/device ... etc. maps and string the SOQLs and 
              filter Ids based on dependent object of task*/
            if(tsk.Dependent_Object__c != Null) {
                String szRefAPIName = (tsk.Dependent_Object__c.contains('__c') ? tsk.Dependent_Object__c : 
                                       tsk.Dependent_Object__c + '__c');
                                       
                Id refId = (Id)(tsk.getSobject('Container__r').get(szRefAPIName));
                
                if(refId!= Null && (tsk.Dependent_Field__c != Null || refId != Null)) {                
                    String szSOQLTemp = DependentSOQLMap.get(szRefAPIName);
                    szSOQLTemp += (!szSOQLTemp.contains(tsk.Dependent_Field__c) ? tsk.Dependent_Field__c + ',' : '');
                    
                    DependentSOQLMap.put(szRefAPIName, szSOQLTemp);
                    
                    String szSOQLFilterTemp = DependentSOQLFilterMap.get(szRefAPIName);

                    System.debug('SREEDDHAR >>  szSOQLFilterTemp :' + szSOQLFilterTemp);
                    
                    szSOQLFilterTemp += (!szSOQLFilterTemp.contains('\'' + refId + '\'') ? '\'' + refId + '\',' : '');
                    
                    DependentSOQLFilterMap.put(szRefAPIName, szSOQLFilterTemp);
                }
            }
        } 
        
        for(String f : DependentSOQLMap.keySet()) {
            System.debug('SREEDDHAR >> ' + DependentSOQLFilterMap);
            String szSOQLFilterTemp = DependentSOQLFilterMap.get(f);
            szSOQLFilterTemp += '\'\')';
            DependentSOQLFilterMap.put(f, szSOQLFilterTemp);
            System.debug('[JOYDEV:DEBUG] >> ... szSOQLFilterTemp = ' + szSOQLFilterTemp);
            
            String szSOQLTemp = DependentSOQLMap.get(f);
            szSOQLTemp += 'Id FROM ' + (Schema.getGlobalDescribe().containsKey(f) ? f : f.replace('__c', '')) 
                        + ' WHERE Id IN ' + szSOQLFilterTemp;
            DependentSOQLMap.put(f, szSOQLTemp);
            System.debug('[JOYDEV:DEBUG] >> ... szSOQLTemp = ' + szSOQLTemp);
            System.debug('SREEDDHAR >> ' + szSOQLTemp);
            for(Sobject obj : Database.query(szSOQLTemp)) {
                System.debug('[JOYDEV:DEBUG] >> ... obj(loop x) = ' + obj);
                DependentSobjectMap.put((Id)(obj.get('Id')), obj);
            }
        }
        
        /*loop through the tasks to decide if it needs to be completed*/
        for(Checklist_Task__c tsk : scope) {
            if(tsk.Dependent_Object__c != Null) {
                System.debug('SREEDDHAR >> ' + tsk + tsk.Dependent_Object__c.contains('__c'));
                /*get the parent reference*/
                String szRefAPIName = (tsk.Dependent_Object__c.contains('__c') ? tsk.Dependent_Object__c : 
                                       tsk.Dependent_Object__c + '__c');
                Sobject par = DependentSobjectMap.get((Id)(tsk.getSobject('Container__r').get(szRefAPIName))); 
                /*comparing object field value*/
                Object comVal = (par != null ? par.get(tsk.Dependent_Field__c) : null);
                
                Boolean match = true;
                
                /*check if 'Dependent_Field_Completed_Value__c' field has/contains value '__notnull' 
                  so that it is an auto-completed task if comparing value is null else auto-incomplete*/
                if(tsk.Dependent_Field_Completed_Value__c != Null && 
                   !tsk.Dependent_Field_Completed_Value__c.toLowerCase().contains(NotNullVal) &&
                   comVal != Null) {
                    System.debug('[JOYDEV:DEBUG] >> ... do not contain __notnull');
                    if(tsk.Dependent_Field_Type__c != Null &&
                       tsk.Dependent_Field_Type__c.toLowerCase().contains('picklist') == True) {
                        System.debug('[JOYDEV:DEBUG] >> ... Dependent_Field_Type__c is PICKLIST');
                        Map<String, String> multipleValMap = new Map<String, String>();
                        
                        for(String szVal : tsk.Dependent_Field_Completed_Value__c.split(',')) {
                            multipleValMap.put(szVal, szVal);
                        }
                        
                        for(String szVal : String.valueOf(comVal).split(',')) {
                            if(!multipleValMap.containsKey(szVal)) {
                                match = false;
                                break;
                            }
                        }
                    } else if(tsk.Dependent_Field_Type__c != Null &&
                              (tsk.Dependent_Field_Type__c.toLowerCase() == 'date' ||
                               tsk.Dependent_Field_Type__c.toLowerCase() == 'datetime')) {
                        match = (String.valueOf(comVal).split(' ')[0] == tsk.Dependent_Field_Completed_Value__c ? True : False);
                    /*in case of 'Dependent_Field_Type__c' values other than picklist/picklist (multiselect)*/
                    } else {
                        System.debug('[JOYDEV:DEBUG] >> ... Dependent_Field_Type__c is other than PICKLIST');
                        /*calculate match result as true if the opportunity field specified in 'Dependent_Field__c' field of 
                          task has the same value as 'Dependent_Field_Completed_Value__c' field of task - then task needs to 
                          be completed*/
                        match = (String.valueOf(comVal) == tsk.Dependent_Field_Completed_Value__c ? True : False);
                        System.debug('[JOYDEV:DEBUG] >> ... match = ' + match);
                    }
                } 
                /*Dependent_Field_Completed_Value__c contains "__notnull" - scenario*/
                else if((tsk.Dependent_Field_Completed_Value__c != Null && 
                         tsk.Dependent_Field_Completed_Value__c.toLowerCase().contains(NotNullVal) &&
                         comVal == Null) || comVal == Null) {
                    match = False;
                } 
                    
                /*previous completion status of the task*/
                Boolean previousStatus = tsk.Is_Completed__c;
                
                /*check if the status has changed and update else leave it as it is*/
                if(previousStatus != match) {
                    tsk.Is_Completed__c = match;
                    MasterTasksToUpdate.put(tsk.Id, tsk);
                    parentChecklistIds.add(tsk.Container__r.Program__c);
                }
            }
        }
        
        parentChecklistIds.add(ChecklistId);
        
        /*updated the tasks and log error if any*/
        if(MasterTasksToUpdate.values().size() > 0) {
            Database.SaveResult[] saveResults = Database.update(MasterTasksToUpdate.values(), false);
            Integer iIndex = 0;
            for (Database.SaveResult sRslt : saveResults ) {
                if(!sRslt.isSuccess()) {
                    BatchErrors += 'ERROR updating Task Record:' 
                                 + MasterTasksToUpdate.values()[iIndex].Id + ', ' 
                                 + sRslt.getErrors()[0].getMessage() + '\n\n';
                    BatchErrorsHtml += '<b>ERROR updating Task Record</b>:' 
                                     + MasterTasksToUpdate.values()[iIndex].Id + ', ' 
                                     + sRslt.getErrors()[0].getMessage() + '<br/><br/>';
                }
                iIndex++;
            }
        }
        
        /*fetch the parent checklists for all the tasks in scope*/
        for(Checklist_Container__c par : [SELECT Id,
                                              DeviceChecklistLastSyncDate__c
                                         FROM Checklist_Container__c
                                        WHERE Id IN:parentChecklistIds]) {
            par.DeviceChecklistLastSyncDate__c = DateTime.now();
            MasterDCLToUpdate.put(par.Id, par);
        }
        
        /*updated the parent checklists and log error if any*/
        if(MasterDCLToUpdate.values().size() > 0) {
            Database.SaveResult[] saveResults = Database.update(MasterDCLToUpdate.values(), false);
            Integer iIndex = 0;
            for (Database.SaveResult sRslt : saveResults ) {
                if(!sRslt.isSuccess()) {
                    BatchErrors += 'ERROR updating Sync Timestamp:' 
                                 + MasterDCLToUpdate.values()[iIndex].Id + ', ' 
                                 + sRslt.getErrors()[0].getMessage() + '\n';
                    BatchErrorsHtml += '<b>ERROR updating Sync Timestamp</b>:' 
                                     + MasterDCLToUpdate.values()[iIndex].Id + ', ' 
                                     + sRslt.getErrors()[0].getMessage() + '<br/><br/>';
                }
                iIndex++;
            }
        }        
    }
    
    /**     
    *  method:         SendMail
    *  args:           recipients (list of recipient mail ids)
    *  return type:    none
    *  purpose:        this method sends mail with error logs to the email ids passed on in argument 
    **/
    global void SendMail(String[] recipients) {
        if(BatchErrors != Null && BatchErrors != '') {
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();    
            
            mail.setSubject('Batch Error - Device Checklist');  
            mail.setToAddresses(recipients);
            mail.setSenderDisplayName('GLOBALFOUNDRIES: Device Checklist');
            mail.setPlainTextBody(BatchErrors);
            mail.setHtmlBody(BatchErrorsHtml);
            if(!Test.isRunningTest()){ 
              Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail }); 
            }
        }
    }
}