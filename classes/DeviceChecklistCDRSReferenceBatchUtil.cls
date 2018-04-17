/***************************************************************************************************************************
Class:         DeviceChecklistCDRSReferenceBatchUtil
----------------------------------------------------------------------------------------------------------------------------
Author:        Joydev Mondol (Cognizant - 153480)
Created Date:  14/08/2014
Reason:        Utility class for scheduler for auto CDRS reference with projects

Change Log:    Created     -     JOYDEV     -     14/08/2014
***************************************************************************************************************************/

global without sharing class DeviceChecklistCDRSReferenceBatchUtil {

    /*schedule interval in minutes*/
    global Integer Interval { get; set; }
    
    /*last sync timestamp*/
    global DateTime LastSyncDateTime { get; set; }
    
    /*Batch error message(s) for the entire job*/
    public String BatchErrors { get; set; }
    public String BatchErrorsHtml { get; set; }
    
    /**     
    *  method:         SOQLUtil
    *  args:           none
    *  return type:    String (SOQL Query)
    *  purpose:        this method does the following:  
    *                  (1) Constructs the SOQL query for the scope generation 
    **/
    global String SOQLUtil() {
        LastSyncDateTime = (LastSyncDateTime == Null ? System.now().addMinutes(-(Interval > 0 ? Interval : 15)) : LastSyncDateTime);
        
        String szLastIntervalTimeStamp = 
            LastSyncDateTime.formatGMT('yyyy-MM-dd') + 'T' + LastSyncDateTime.formatGMT('HH:mm:ss.SSS') + 'Z';
            
        String szSOQL = 'SELECT Id, '
                      + '       Name, '
                      + '       Device__c, '
                      + '       BX_041__c '
                      + '  FROM Checklist_Container__c '
                      + ' WHERE Device__c != NULL AND '
                      + ' Checklist_Container__c.BX_041__c = NULL AND'
                      + '       CreatedDate > ' + szLastIntervalTimeStamp;
            
        System.debug('[JOYDEV:DEBUG] >> SOQLUtil() ... szSOQL = ' + szSOQL);
            
        return szSOQL;
    }
    
    /**     
    *  method:         ExecuteUtil
    *  args:           scope (Sobject scope of the DeviceChecklistSyncTaskBatch instance)
    *  return type:    none
    *  purpose:        this method does the following:  
    *                  (1) Schedule job runs and checks all projects updated after previous successfully ran scheduled job.
    *                  (2) Gets the device assotiated to get the CDRS from the device.
    *                  (3) Assotiates the CDRS with the projects. 
    **/
    global void ExecuteUtil(List<Checklist_Container__c> scope) {
        /*list of projects to be updated (to be completed)*/
        List<Checklist_Container__c> ProjectsToUpdate = new List<Checklist_Container__c>();  
        
        /*Map of project id with device id*/
        Map<Id, Id> ProjectIdWithDeviceIdMap = new Map<Id, Id>();
        /*Map of device id with cdrs id*/
        Map<Id, Id> DeviceIdWithCDRSIdMap = new Map<Id, Id>();
        
        for(Checklist_Container__c proj : scope) {
            ProjectIdWithDeviceIdMap.put(proj.Id, proj.Device__c);
        }
        
        /*for(BX_041__c cdrs : [SELECT Id, 
                                     Device__c
                                FROM BX_041__c
                               WHERE Device__c IN: ProjectIdWithDeviceIdMap.Values()]) {
            DeviceIdWithCDRSIdMap.put(cdrs.Device__c, cdrs.Id);
        }*/

        for(BX_041__c cdrs : [SELECT Id, 
                                     Device__c
                                FROM BX_041__c
                               WHERE Device__c IN: ProjectIdWithDeviceIdMap.Values()]) {
            DeviceIdWithCDRSIdMap.put(cdrs.Device__c, cdrs.Id);
        }
        
        for(Checklist_Container__c proj : scope) {
            if(DeviceIdWithCDRSIdMap.containsKey(proj.Device__c)) {
                proj.BX_041__c = DeviceIdWithCDRSIdMap.get(proj.Device__c);
                ProjectsToUpdate.add(proj);
            }
        }
        
        /*updated the tasks and log error if any*/
        if(ProjectsToUpdate.size() > 0) {
            Database.SaveResult[] saveResults = Database.update(ProjectsToUpdate, false);
            Integer iIndex = 0;
            for (Database.SaveResult sRslt : saveResults ) {
                if(!sRslt.isSuccess()) {
                    BatchErrors += 'ERROR updating Project Record:' 
                                 + ProjectsToUpdate[iIndex].Id + ', ' 
                                 + sRslt.getErrors()[0].getMessage() + '\n\n';
                    BatchErrorsHtml += '<b>ERROR updating Project Record</b>:' 
                                     + ProjectsToUpdate[iIndex].Id + ', ' 
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
            if(!Test.isRunningTest()){ Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail }); }
        }
    }
}