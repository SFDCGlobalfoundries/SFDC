/***************************************************************************************************************************
Class:         RiskStartApprovalReminderBatch 
----------------------------------------------------------------------------------------------------------------------------
Author:        Pradosh Samal
Description:   This class is used to send approval reminder to risk start approver.
History:
    Psamal  06/15/2017 -  Created
    Psamal  08/10/2017 -  Email subject change

***************************************************************************************************************************/

global class RiskStartApprovalReminderBatch implements Database.Batchable<sObject>, Database.Stateful, Schedulable {
    
    global final String query = 'SELECT Id, Status__c, Reminder_Date__c, First_Approval_Reminder__c, Second_Approval_Reminder__c, Third_Approval_Reminder__c, FAB__c, Name, Customer_Name__c, Customer_Name__r.Name, Recommended_Device__c, Business_Unit__c, No_of_Mask_Layer__c, Recommended_Quantity__c, Plan_Start_Date__c, End_Date__c, PX_Request_Revenue__c FROM Risk_Start_System__c WHERE Reminder_Date__c != NULL AND Status__c != \'Draft\' AND Status__c != \'Rejected\' AND Status__c != \'Approved & Pending Conversion\' AND Status__c != \'Conversion Completed\' AND Status__c != \'Void\'';
    
    global EmailTemplate emailTemplate;
    global Integer firstApproval  = 0;
    global Integer secondApproval = 0;
    global Integer thirdApproval  = 0;
    
    global RiskStartApprovalReminderBatch(){
        
        String emailTemplateName = Environment_Variable__c.getInstance('RISK_START_APPROVAL_REMINDER_TEMPLATE').Value__c;
        
        emailTemplate = [SELECT Id, subject, Body FROM EmailTemplate WHERE Name = :emailTemplateName LIMIT 1];
        
        if(Environment_Variable__c.getInstance('RISK_START_FIRST_REMINDER') != NULL
          && Environment_Variable__c.getInstance('RISK_START_FIRST_REMINDER').Value__c.isNumeric()){
            
            firstApproval = Integer.valueOf(Environment_Variable__c.getInstance('RISK_START_FIRST_REMINDER').Value__c);
        }
        
        if(Environment_Variable__c.getInstance('RISK_START_SECOND_REMINDER') != NULL
          && Environment_Variable__c.getInstance('RISK_START_SECOND_REMINDER').Value__c.isNumeric()){
            
            secondApproval = Integer.valueOf(Environment_Variable__c.getInstance('RISK_START_SECOND_REMINDER').Value__c);
        }
        
        if(Environment_Variable__c.getInstance('RISK_START_THIRD_REMINDER') != NULL
          && Environment_Variable__c.getInstance('RISK_START_THIRD_REMINDER').Value__c.isNumeric()){
            
            thirdApproval = Integer.valueOf(Environment_Variable__c.getInstance('RISK_START_THIRD_REMINDER').Value__c);
        }
    }
   
    global Database.QueryLocator start (Database.BatchableContext batchableContext) {
        
        return Database.getQueryLocator(query);    
    }
    
    global void execute(Database.BatchableContext batchableContext, List<sObject> scope){
        try{
            List<Risk_Start_System__c> riskStartSystemList = (List<Risk_Start_System__c>)scope;
            Map<Id, Integer> riskStartSystemFlagMap = new Map<Id, Integer>();
            Map<Id, Risk_Start_System__c> riskStartSystemMap = new Map<Id, Risk_Start_System__c>();
            List<Risk_Start_System__c> riskStartTobeUpdateList = new List<Risk_Start_System__c>();
            
            for(Risk_Start_System__c riskStartSystem : riskStartSystemList){
                
                if( (! riskStartSystem.First_Approval_Reminder__c) && sendReminder(riskStartSystem.Reminder_Date__c, firstApproval) ){
                    
                    riskStartSystemMap.put(riskStartSystem.Id, riskStartSystem);
                    riskStartSystemFlagMap.put(riskStartSystem.Id, firstApproval);
                }
                else if( (! riskStartSystem.Second_Approval_Reminder__c) && sendReminder(riskStartSystem.Reminder_Date__c, secondApproval) ){
                    
                    riskStartSystemMap.put(riskStartSystem.Id, riskStartSystem);
                    riskStartSystemFlagMap.put(riskStartSystem.Id, secondApproval);
                }
                else if( (! riskStartSystem.Third_Approval_Reminder__c) && sendReminder(riskStartSystem.Reminder_Date__c, thirdApproval) ){
                    
                    riskStartSystemMap.put(riskStartSystem.Id, riskStartSystem);
                    riskStartSystemFlagMap.put(riskStartSystem.Id, thirdApproval);
                }
            }
            
            if(riskStartSystemMap.size() > 0){
                
                List<ProcessInstance> processInstanceList = [SELECT Id, TargetObjectId, SubmittedById, (SELECT Id, StepStatus, ActorId FROM StepsAndWorkitems WHERE StepStatus = 'Pending') FROM ProcessInstance WHERE TargetObjectId IN : riskStartSystemMap.keySet()];
            
                Map<Id, List<Id>> riskStartActorMap = new Map<Id, List<Id>>();
                Set<Id> userIdSet = new Set<Id>();
                List<Id> tempActorList = new List<Id>();
                
                for(ProcessInstance processInstance : processInstanceList){
                    
                    tempActorList = new List<Id>();
                    
                    for(ProcessInstanceHistory processInstanceHistory : processInstance.StepsAndWorkitems){
                        
                        if(processInstanceHistory.ActorId != NULL){
                            
                            tempActorList.add(processInstanceHistory.ActorId);
                            userIdSet.add(processInstanceHistory.ActorId);
                        }
                    }
                    
                    if(tempActorList.size() > 0){
                        
                        tempActorList.add(processInstance.SubmittedById);
                        userIdSet.add(processInstance.SubmittedById);
                    
                        riskStartActorMap.put(processInstance.TargetObjectId, tempActorList);
                    }
                }
                
                List<User> userList = [SELECT Id, Email FROM User WHERE Id IN :userIdSet];
                
                Map<Id, String> userIdEmailMap = new Map<Id, String>();
                
                for(User userObj : userList){
                    if(userObj.Email != NULL){
                        userIdEmailMap.put(userObj.Id, userObj.Email);
                    }
                }
                
                List<Messaging.SingleEmailMessage> emails = new List<Messaging.SingleEmailMessage>();
                Messaging.SingleEmailMessage mail;
                List<String> emailList;
                String emailSubject = '';
                String emailBody = '';
                
                for (Id targetObjectId : riskStartActorMap.keySet()){
                    
                    mail = new Messaging.SingleEmailMessage();
                    
                    emailSubject = '';
                    emailBody = '';
                
                    if(emailTemplate.subject != NULL){
                        //emailSubject = emailTemplate.subject;
                    }
                    
                    if(emailTemplate.Body != NULL){
                        emailBody = emailTemplate.Body;
                    }
                        
                    if(riskStartSystemMap.get(targetObjectId) != NULL){
                    
                        if(riskStartSystemMap.get(targetObjectId).FAB__c != NULL){
                            
                            //emailSubject = emailSubject.replace('{!Risk_Start_System__c.FAB__c}', riskStartSystemMap.get(targetObjectId).FAB__c);
                            emailBody = emailBody.replace('{!Risk_Start_System__c.FAB__c}', riskStartSystemMap.get(targetObjectId).FAB__c + '<br>');
                        }
                        else{
                            emailBody = emailBody.replace('{!Risk_Start_System__c.FAB__c}', '<br>');
                        }
                        
                        if(riskStartSystemMap.get(targetObjectId).Name != NULL){
                            
                            //emailSubject = emailSubject.replace('{!Risk_Start_System__c.Name}', riskStartSystemMap.get(targetObjectId).Name);
                            emailBody = emailBody.replace('Request No : {!Risk_Start_System__c.Name}', '<br><br> Request No : ' + riskStartSystemMap.get(targetObjectId).Name + '<br>');
                        }
                        else{
                            emailBody = emailBody.replace('Request No : {!Risk_Start_System__c.Name}', '<br><br> Request No : <br>');
                        }
                        
                        if(riskStartSystemMap.get(targetObjectId).Customer_Name__c != NULL && riskStartSystemMap.get(targetObjectId).Customer_Name__r.Name != NULL){
                            
                            //emailSubject = emailSubject.replace('{!Risk_Start_System__c.Customer_Name__c}', riskStartSystemMap.get(targetObjectId).Customer_Name__r.Name);
                            emailBody = emailBody.replace('{!Risk_Start_System__c.Customer_Name__c}', riskStartSystemMap.get(targetObjectId).Customer_Name__r.Name + '<br>');
                        }
                        else{
                            emailBody = emailBody.replace('{!Risk_Start_System__c.Customer_Name__c}', '<br>');
                        }
                        
                        if(riskStartSystemMap.get(targetObjectId).Status__c != NULL){
                            //emailSubject = emailSubject.replace('{!Risk_Start_System__c.Status__c}', riskStartSystemMap.get(targetObjectId).Status__c);
                        }
                        
                        if(riskStartSystemMap.get(targetObjectId).Recommended_Device__c != NULL){
                            emailBody = emailBody.replace('{!Risk_Start_System__c.Recommended_Device__c}', riskStartSystemMap.get(targetObjectId).Recommended_Device__c + '<br>');
                        }
                        else{
                            emailBody = emailBody.replace('{!Risk_Start_System__c.Recommended_Device__c}', '<br>');
                        }
                        
                        if(riskStartSystemMap.get(targetObjectId).Business_Unit__c != NULL){
                            emailBody = emailBody.replace('{!Risk_Start_System__c.Business_Unit__c}', riskStartSystemMap.get(targetObjectId).Business_Unit__c + '<br>');
                        }
                        else{
                            emailBody = emailBody.replace('{!Risk_Start_System__c.Business_Unit__c}', '<br>');
                        }
                        
                        if(riskStartSystemMap.get(targetObjectId).No_of_Mask_Layer__c != NULL){
                            emailBody = emailBody.replace('{!Risk_Start_System__c.No_of_Mask_Layer__c}', String.valueOf(riskStartSystemMap.get(targetObjectId).No_of_Mask_Layer__c) + '<br>');
                        }
                        else{
                            emailBody = emailBody.replace('{!Risk_Start_System__c.No_of_Mask_Layer__c}', '<br>');
                        }
                        
                        if(riskStartSystemMap.get(targetObjectId).Recommended_Quantity__c != NULL){
                            emailBody = emailBody.replace('{!Risk_Start_System__c.Recommended_Quantity__c}', String.valueOf(riskStartSystemMap.get(targetObjectId).Recommended_Quantity__c) + '<br>');
                        }
                        else{
                            emailBody = emailBody.replace('{!Risk_Start_System__c.Recommended_Quantity__c}', '<br>');
                        }
                        
                        if(riskStartSystemMap.get(targetObjectId).Plan_Start_Date__c != NULL){
                            emailBody = emailBody.replace('{!Risk_Start_System__c.Plan_Start_Date__c}', String.valueOf(riskStartSystemMap.get(targetObjectId).Plan_Start_Date__c) + '<br>');
                        }
                        else{
                            emailBody = emailBody.replace('{!Risk_Start_System__c.Plan_Start_Date__c}', '<br>');
                        }
                        
                        if(riskStartSystemMap.get(targetObjectId).End_Date__c != NULL){
                            emailBody = emailBody.replace('{!Risk_Start_System__c.End_Date__c}', String.valueOf(riskStartSystemMap.get(targetObjectId).End_Date__c) + '<br><br>');
                        }
                        else{
                            emailBody = emailBody.replace('{!Risk_Start_System__c.End_Date__c}', '<br><br>');
                        }
                        
                        if(riskStartSystemMap.get(targetObjectId).PX_Request_Revenue__c != NULL){
                            emailBody = emailBody.replace('{!Risk_Start_System__c.PX_Request_Revenue__c}', String.valueOf(riskStartSystemMap.get(targetObjectId).PX_Request_Revenue__c) + '<br><br>');
                        }
                        else{
                            emailBody = emailBody.replace('{!Risk_Start_System__c.PX_Request_Revenue__c}', '<br><br>');
                        }
                    }
                    
                    if(riskStartSystemFlagMap.get(targetObjectId) == firstApproval){
                        emailSubject = 'Gentle reminder 1: PX request pending your endorsement for ' + (firstApproval * 24) + 'hrs';
                    }
                    else if(riskStartSystemFlagMap.get(targetObjectId) == secondApproval){
                        emailSubject = 'Gentle reminder 2: PX request pending your endorsement for ' + (secondApproval * 24) + 'hrs';
                    }
                    else if(riskStartSystemFlagMap.get(targetObjectId) == thirdApproval){
                        emailSubject = 'Gentle reminder 3: PX request pending your endorsement for ' + (thirdApproval * 24) + 'hrs';
                    }
                    
                    emailBody = emailBody.replace('{!Risk_Start_System__c.Link}', System.URL.getSalesforceBaseURL().toExternalForm() + '/' + targetObjectId + '<br><br>'); 
                    
                    mail.setSubject(emailSubject);
                    mail.setHtmlBody(emailBody);
                    
                    //mail.setTemplateId(emailTemplate.Id);
                    //mail.setTargetObjectId(targetObjectId);
                    //mail.setWhatId(targetObjectId);
                        
                    emailList = new List<String>();
                    for(Id userId : riskStartActorMap.get(targetObjectId)){
                        
                        if(userIdEmailMap.get(userId) != NULL){
                            emailList.add(userIdEmailMap.get(userId));
                        }
                    }
                    
                    if(emailList.size() > 0){
                        mail.setToAddresses(emailList);
                        emails.add(mail);
                        riskStartTobeUpdateList.add(riskStartSystemMap.get(targetObjectId));
                    }
                }
                
                if(emails.size() > 0){
                    
                    Messaging.sendEmail(emails);
                    
                    for (Risk_Start_System__c rsa : riskStartTobeUpdateList){
                        
                        if(riskStartSystemFlagMap.get(rsa.Id) == firstApproval){
                            rsa.First_Approval_Reminder__c = TRUE;
                        }
                        else if(riskStartSystemFlagMap.get(rsa.Id) == secondApproval){
                            rsa.Second_Approval_Reminder__c = TRUE;
                        }
                        else if(riskStartSystemFlagMap.get(rsa.Id) == thirdApproval){
                            rsa.Third_Approval_Reminder__c = TRUE;
                        }
                    }
                    
                    if(riskStartTobeUpdateList.size() > 0){
                        
                        Database.SaveResult[] saveResult =  Database.update(riskStartTobeUpdateList, FALSE);
                    }
                }
            }
        }
        catch(Exception e){
            GlobalUtility.logMessage('Error', 'RiskStartApprovalReminderBatch', 'execute', '', '', e.getMessage(), '', 'PX - Risk Start System', e, 0);
        }
    }
     
    global void finish(Database.BatchableContext batchableContext){
    }  
    
    global void execute(SchedulableContext schedulableContext) {
        
        if ([SELECT count() FROM AsyncApexJob WHERE JobType= 'BatchApex' AND (Status = 'Processing' OR Status = 'Preparing')] < 5){ 
            
            RiskStartApprovalReminderBatch batchObj = new RiskStartApprovalReminderBatch();
            Database.executeBatch(batchObj, 50);
        } 
        else {
            
            RiskStartApprovalReminderBatch batchObj = new RiskStartApprovalReminderBatch();
            DateTime after30Minutes = DateTime.now().addMinutes(30);  
            String timeForScheduler = after30Minutes.format('s m H d M \'?\' yyyy');
            Id schedId = System.Schedule('RiskStartApprovalReminder' + timeForScheduler, timeForScheduler, batchObj);
        }
    }
    
    public Boolean sendReminder(DateTime reminderDate, Integer noOfDays){
        
        Integer i = 1;
        While(i <= noOfDays){
        
            reminderDate = reminderDate.addDays(1);
            
            if( !( reminderDate.format('EEEE').equalsIgnoreCase('Saturday') || reminderDate.format('EEEE').equalsIgnoreCase('Sunday') ) ){
                
                i++;
            }
        }
        
        if(noOfDays <= 0){
            return FALSE;
        }
        else if(reminderDate < DateTime.now()){
            return TRUE;
        }
        else{
            return FALSE;
        }
    }
}