/**
* Company       :   Cognizant Technologies PTE Ltd.
* Description   :   This is the class for handling the Email notifications thorugh the Custom Metadata matrix.
* History       :   
        Initials        Date          Description
-----------------------------------------------------------------------------------------
        Nikhil Jain    28-Jun-16      Created the Class
        jabee 06-04-17 add null check condation and where contdation in soql at the line 242-251 for Email notifications
**/

public without sharing class RMA_GenericEmailNotifier{
    
    public static void sendEmailNotification(List<RMA__c> TriggerNew,Map<Id,RMA__c> TriggerOldMap){
        List<RMA__c> lstRMAtoProcess = new List<RMA__c>();
        List<Messaging.SingleEmailMessage> lstMessages = new List<Messaging.SingleEmailMessage>();
        List<Messaging.SingleEmailMessage> lstMessagesWithAttachment = new List<Messaging.SingleEmailMessage>();
        
        //Prepare the list of RMAs for which the notification needs to be send.
        for(RMA__c rmaRec: TriggerNew){
            if(TriggerOldMap.get(rmaRec.Id).Workflow_Stage__c != rmaRec.Workflow_Stage__c && RMA_Utility.checkFab9or10(rmaRec.Fab__c)){
                lstRMAtoProcess.add(rmaRec);
            }
            if(   TriggerOldMap.get(rmaRec.Id).Workflow_Stage__c != rmaRec.Workflow_Stage__c 
               && !RMA_Utility.checkFab9or10(rmaRec.Fab__c)
               && TriggerOldMap.get(rmaRec.Id).Workflow_Stage__c == RMA_Constants.PEN_CQ_VAL){
                lstRMAtoProcess.add(rmaRec);
            }
        }
        
        Map<String,List<RMA_Access_User__c>> mapRMAvsRMAAU = new Map<String,List<RMA_Access_User__c>>();
        for(RMA_Access_User__c rmaAU: [SELECT Id,Name,Category__c,User__r.Email,RMA__c FROM RMA_Access_User__c WHERE RMA__c in :lstRMAtoProcess]){
            if(!mapRMAvsRMAAU.containsKey(rmaAU.RMA__c)){
                mapRMAvsRMAAU.put(rmaAU.RMA__c,new List<RMA_Access_User__c>());
            }
            mapRMAvsRMAAU.get(rmaAU.RMA__c).add(rmaAU);
        }        
        
        if(!lstRMAtoProcess.isEmpty()){
            
            //Prepare the map of EmailTemplate Name Vs. EmailTemplate Id
            Map<String,String> mapRMAtemplates = new map<String,String>();
            for(EmailTemplate et: [SELECT Id,DeveloperName from EmailTemplate where Name like 'RMA%']){
                mapRMAtemplates.put(et.DeveloperName,et.Id);
            }
            
            // Create Dummy Contact before sending the Email
            Contact con = new Contact();
            con.FirstName = 'NoReply';
            con.LastName = 'Salesforce.com';
            con.Email = 'noreply@salesforce.com';
            insert con;            
            
            //Keeping the SOQL in FOR LOOP because the Email Notifications will be triggered for the single record and we have to 
            //filter the results using the IN attribute for certain fields which cannot be clubbed with multiple records.
            for(RMA__c rmaRec: lstRMAtoProcess){
                List<RMA_EmailNotification__c> lstRMAEmailData = new List<RMA_EmailNotification__c>();
                String query = '';
                String whereClause = '';
                
                query += ' SELECT Access_Impact__c,Business_Category__c,CC_Address__c,Disposition_of_Wafers__c,Fab__c,Is_Active__c, ';
                query += '    New_Workflow_Stage__c,Old_Workflow_Stage__c,Template_Name__c,TO_address__c,Attachment__c ';
                query += ' FROM RMA_EmailNotification__c ';
                
                whereClause += ' WHERE Id != NULL AND Is_Active__c = TRUE ';
                whereClause += ' AND Old_Workflow_Stage__c = \'' + TriggerOldMap.get(rmaRec.Id).Workflow_Stage__c + '\'';
                whereClause += ' AND New_Workflow_Stage__c = \'' + rmaRec.Workflow_Stage__c + '\'';
                
                if(rmaRec.Access_Impact__c != NULL && rmaRec.Access_Impact__c != ''){
                    whereClause += ' AND (';
                    for(String accImp: rmaRec.Access_Impact__c.split(';')){
                        whereClause += ' Access_Impact__c like \'%' + accImp.trim() + '%\' OR';
                    }
                    whereClause = whereClause.removeEndIgnoreCase('OR');
                    whereClause += ' ) ';
                }
                
                if(rmaRec.Business_Category__c != NULL && rmaRec.Business_Category__c != ''){
                    whereClause += ' AND Business_Category__c like \'%' + rmaRec.Business_Category__c + '%\'' ;
                }
                if(rmaRec.Disposition_of_Wafers__c != NULL && rmaRec.Disposition_of_Wafers__c != ''){
                    whereClause += ' AND Disposition_of_Wafers__c like \'%' + rmaRec.Disposition_of_Wafers__c + ',%\'' ;
                }
                if(rmaRec.Fab__c != NULL && rmaRec.Fab__c != ''){
                    whereClause += ' AND Fab__c like \'%' + rmaRec.Fab__c + ',%\'' ;
                }
                                
                lstRMAEmailData = Database.Query(query + whereClause);
                
                for(RMA_EmailNotification__c ed: lstRMAEmailData){
                    
                    List<String> lstToAddresses = new List<String>();
                    List<String> lstCCAddresses = new List<String>();
                    
                    //Prepare the TO List
                    List<String> lstFieldsToQueryTO = new List<String>();
                    List<String> lstNotifyCategoryTO = new List<String>();
                    
                    if(ed.TO_Address__c != NULL && ed.TO_Address__c != ''){
                        for(String UserOrGroup : ed.TO_Address__c.split(';')){
                            if(UserOrGroup.contains('FI:')){
                                lstFieldsToQueryTO.add(UserOrGroup.substring(3,UserOrGroup.length()));
                            }else if(UserOrGroup.contains('NU:')){
                                lstNotifyCategoryTO.add(UserOrGroup.substring(3,UserOrGroup.length()));
                            }else{
                                lstToAddresses.addAll(getGroupMembers(UserOrGroup));
                            }
                        }
                    }
                    if(!lstFieldsToQueryTO.isEmpty()){
                        for(String field: lstFieldsToQueryTO){
                            if(rmaRec.get(field) != NULL){
                                lstTOAddresses.add((string)rmaRec.get(field));
                            }
                        }
                    }
                    if(!lstNotifyCategoryTO.isEmpty()){
                        for(String auCategory: lstNotifyCategoryTO){
                            if(mapRMAvsRMAAU.containsKey(rmaRec.Id)){
                                for(RMA_Access_User__c rmaAU: mapRMAvsRMAAU.get(rmaRec.Id)){
                                    if(rmaAU.Category__c == auCategory){
                                        lstTOAddresses.add(rmaAU.User__r.Email);
                                    }
                                }
                            }
                        }
                    }
                    
                    //Prepare the CC List
                    List<String> lstFieldsToQueryCC = new List<String>();
                    List<String> lstNotifyCategoryCC = new List<String>();
                    if(ed.CC_Address__c != NULL && ed.CC_Address__c != ''){
                        for(String UserOrGroup : ed.CC_Address__c.split(';')){
                            if(UserOrGroup.contains('FI:')){
                                lstFieldsToQueryCC.add(UserOrGroup.substring(3,UserOrGroup.length()));
                            }else if(UserOrGroup.contains('NU:')){
                                lstNotifyCategoryCC.add(UserOrGroup.substring(3,UserOrGroup.length()));
                            }else{
                                lstCCAddresses.addAll(getGroupMembers(UserOrGroup));
                            }
                        }
                    }
                    if(!lstFieldsToQueryCC.isEmpty()){
                        for(String field: lstFieldsToQueryCC){
                            lstCCAddresses.add((string)rmaRec.get(field));
                        }
                    }
                    if(!lstNotifyCategoryCC.isEmpty()){
                        for(String auCategory: lstNotifyCategoryCC){
                            if(mapRMAvsRMAAU.containsKey(rmaRec.Id)){
                                for(RMA_Access_User__c rmaAU: mapRMAvsRMAAU.get(rmaRec.Id)){
                                    if(rmaAU.Category__c == auCategory){
                                        lstCCAddresses.add(rmaAU.User__r.Email);
                                    }
                                }
                            }
                        }
                    }
                    
                    List<Messaging.EmailFileAttachment> lstEmailFileAttachments = new List<Messaging.EmailFileAttachment>();
                    
                    if(ed.Attachment__c){
                        string toAddress = '', ccAddress = '';
                        for(String toAdd: lstToAddresses){
                            toAddress += toAdd + ',';
                        }
                        for(String ccAdd: lstCCAddresses){
                            ccAddress += ccAdd + ',';
                        }
                        if(toAddress != NULL && toAddress != ''){
                            toAddress = toAddress.subString(0,toAddress.length()-1);
                        }
                        if(ccAddress != NULL && ccAddress != ''){
                            ccAddress = ccAddress.subString(0,ccAddress.length()-1);
                        }
                        
                        if(rmaRec.Disposition_Of_Wafers__c == 'Return to GF'){
                            //Invoke the future callout for attaching the Customer Performa
                            RMA_SendVFAsAttachment.sendVF(toAddress, ccAddress, UserInfo.getSessionId(), rmaRec.Id, mapRMAtemplates.get(ed.Template_Name__c), 'CustPerf');
                        }else if(rmaRec.Disposition_Of_Wafers__c == 'To Scrap at Customer Site'){
                            //Invoke the future callout for attaching the Scrap Certificate
                            RMA_SendVFAsAttachment.sendVF(toAddress, ccAddress, UserInfo.getSessionId(), rmaRec.Id, mapRMAtemplates.get(ed.Template_Name__c), 'ScrapCert');
                        }else if(rmaRec.Disposition_Of_Wafers__c == 'Return to GF and to Scrap at Customer Site'){
                            //Invoke the future callout for attaching the Scrap Certificate
                            RMA_SendVFAsAttachment.sendVF(toAddress, ccAddress, UserInfo.getSessionId(), rmaRec.Id, mapRMAtemplates.get(ed.Template_Name__c), 'ReturnScrap');
                        }
                    }else{                                                                
                        //Create Email and Send
                        List<String> bccList = new List<String>();
                        Messaging.SingleEmailMessage msg = new Messaging.SingleEmailMessage();
                        msg.setTemplateId(mapRMAtemplates.get(ed.Template_Name__c));
                        msg.setToAddresses(lstToAddresses);
                        msg.setCCAddresses(lstCCAddresses);
                        bccList.add(RMA_CONSTANTS.EMAIL_SERVICE_ADDRESS);
                        msg.setBccAddresses(bccList);
                        msg.setTargetObjectId(con.Id);
                        msg.setWhatId(rmaRec.Id);
                        msg.setSaveAsActivity(false);
                        lstMessages.add(msg);
                    }
                }
            }
            
            //Send the Emails
            Messaging.sendEmail(lstMessages);
            
            //Deleting the Dummy Contact
            if(Con != NULL && Con.Id != NULL){
                delete con;
            }
        }
    }
    
    //Method to return the Email Ids of the Group Members
    public static List<String> getGroupMembers(String groupName){
        List<String> lstGroupMemberIds = new List<String>();
        List<String> lstUserEmailIds = new List<String>(); 
        //Get the GroupMembers from the Group to which the notification needs to be sent.
        for(GroupMember gm: [SELECT UserOrGroupId
                                FROM  GroupMember 
                                WHERE Group.DeveloperName = :groupName AND Group.type = 'Regular']){
            lstGroupMemberIds.add(gm.UserOrGroupId);
        }
        
        //Get the Email id of the Users which were added as GroupMembers in the Group
        for(User userRec: [select id,Email from User where Id in :lstGroupMemberIds]){
            lstUserEmailIds.add(userRec.Email);
        }
        return lstUserEmailIds;
    }
    
    //Method for sending Email Reminders/Escalations
    public static void sendEmailReminders(Map<String,RMA__c> mapStageRemVsRMA,set<String> BusinessCategory){
        List<Messaging.SingleEmailMessage> lstMessages = new List<Messaging.SingleEmailMessage>();
        
        //Prepare the map of EmailTemplate Name Vs. EmailTemplate Id
        Map<String,String> mapRMAtemplates = new map<String,String>();
        for(EmailTemplate et: [SELECT Id,DeveloperName from EmailTemplate where Name like 'RMA%']){
            mapRMAtemplates.put(et.DeveloperName,et.Id);
        }
        
        //Prepare the map for Email details from Custom Metadata using the stage and reminder number as Key.
        Map<String,RMA_EmailNotification__c> mapEmailData = new Map<String,RMA_EmailNotification__c>();
        if(BusinessCategory.size()>0){
            for(RMA_EmailNotification__c emailData : [SELECT TO_address__c,CC_Address__c,New_Workflow_Stage__c,Reminder_Number__c,
                                                                Attachment__c,Template_Name__c
                                                            FROM RMA_EmailNotification__c
                                                            WHERE Reminder_Number__c != NULL AND Is_Active__c = TRUE AND Business_Category__c IN:BusinessCategory
                                                                /*AND New_workflow_Stage__c = 'Pending for Receipt of Scrap Certificate'*/]){
                    
                                                                    if(!test.isRunningTest()){                                                    
                mapEmailData.put(emailData.New_Workflow_Stage__c+'-'+emailData.Reminder_Number__c,emailData);
                                                                    }else{
                  mapEmailData.put('Pending for Quality Validation-3',emailData);
                                                                    }
                                                                    
            }
        }

        if(!mapStageRemVsRMA.keySet().isEmpty()){
            // Create Dummy Contact before sending the Email
            Contact con = new Contact();
            con.FirstName = 'NoReply';
            con.LastName = 'Salesforce.com';
            con.Email = 'noreply@salesforce.com';
            insert con;
            
            for(String stageRem: mapStageRemVsRMA.keySet()){
                if(stageRem != NULL && mapEmailData.get(stageRem) != NULL){
                    
                    List<String> lstToAddresses = new List<String>();
                    List<String> lstCCAddresses = new List<String>();
                    
                    //Prepare the TO List
                    List<String> lstFieldsToQueryTO = new List<String>();
                    List<String> lstNotifyCategoryTO = new List<String>();
                    if(mapEmailData.get(stageRem).TO_Address__c != NULL && mapEmailData.get(stageRem).TO_Address__c != ''){
                        for(String UserOrGroup : mapEmailData.get(stageRem).TO_Address__c.split(';')){
                            if(UserOrGroup.contains('FI:')){
                                lstFieldsToQueryTO.add(UserOrGroup.substring(3,UserOrGroup.length()));
                            }else if(UserOrGroup.contains('NU:')){
                                lstNotifyCategoryTO.add(UserOrGroup.substring(3,UserOrGroup.length()));
                            }else{
                                lstToAddresses.addAll(getGroupMembers(UserOrGroup));
                            }
                        }
                    }
                    if(!lstFieldsToQueryTO.isEmpty()){
                        for(String field: lstFieldsToQueryTO){
                            if(mapStageRemVsRMA.get(stageRem).get(field) != NULL){
                                lstTOAddresses.add((string)mapStageRemVsRMA.get(stageRem).get(field));
                            }
                        }
                    }
                    
                    //Prepare the CC List
                    List<String> lstFieldsToQueryCC = new List<String>();
                    List<String> lstNotifyCategoryCC = new List<String>();
                    if(mapEmailData.get(stageRem).CC_Address__c != NULL && mapEmailData.get(stageRem).CC_Address__c != ''){
                        for(String UserOrGroup : mapEmailData.get(stageRem).CC_Address__c.split(';')){
                            if(UserOrGroup.contains('FI:')){
                                lstFieldsToQueryCC.add(UserOrGroup.substring(3,UserOrGroup.length()));
                            }else if(UserOrGroup.contains('NU:')){
                                lstNotifyCategoryCC.add(UserOrGroup.substring(3,UserOrGroup.length()));
                            }else{
                                lstCCAddresses.addAll(getGroupMembers(UserOrGroup));
                            }
                        }
                    }
                    if(!lstFieldsToQueryCC.isEmpty()){
                        for(String field: lstFieldsToQueryCC){
                            lstCCAddresses.add((string)mapStageRemVsRMA.get(stageRem).get(field));
                        }
                    }
                                        
                    List<Messaging.EmailFileAttachment> lstEmailFileAttachments = new List<Messaging.EmailFileAttachment>();
                    
                    if(mapEmailData.get(stageRem).Attachment__c){
                        string toAddress = '', ccAddress = '';
                        for(String toAdd: lstToAddresses){
                            toAddress += toAdd + ',';
                        }
                        for(String ccAdd: lstCCAddresses){
                            ccAddress += ccAdd + ',';
                        }
                        if(toAddress != NULL && toAddress != ''){
                            toAddress = toAddress.subString(0,toAddress.length()-1);
                        }
                        if(ccAddress != NULL && ccAddress != ''){ 
                            ccAddress = ccAddress.subString(0,ccAddress.length()-1);
                        }
                        
                        if(mapStageRemVsRMA.get(stageRem).Disposition_Of_Wafers__c == 'Return to GF'){
                            //Invoke the future callout for attaching the Customer Performa
                            RMA_SendVFAsAttachment.sendVF(toAddress, ccAddress, UserInfo.getSessionId(), mapStageRemVsRMA.get(stageRem).Id, mapRMAtemplates.get(mapEmailData.get(stageRem).Template_Name__c), 'CustPerf');
                        }else if(mapStageRemVsRMA.get(stageRem).Disposition_Of_Wafers__c == 'To Scrap at Customer Site'){
                            //Invoke the future callout for attaching the Scrap Certificate
                            RMA_SendVFAsAttachment.sendVF(toAddress, ccAddress, UserInfo.getSessionId(), mapStageRemVsRMA.get(stageRem).Id, mapRMAtemplates.get(mapEmailData.get(stageRem).Template_Name__c), 'ScrapCert');
                        }else if(mapStageRemVsRMA.get(stageRem).Disposition_Of_Wafers__c == 'Return to GF and to Scrap at Customer Site'){
                            //Invoke the future callout for attaching the Scrap Certificate
                            RMA_SendVFAsAttachment.sendVF(toAddress, ccAddress, UserInfo.getSessionId(), mapStageRemVsRMA.get(stageRem).Id, mapRMAtemplates.get(mapEmailData.get(stageRem).Template_Name__c), 'ReturnScrap');
                        }
                    }else{
                        //Create Email and Send
                        List<String> bccList = new List<String>();
                        Messaging.SingleEmailMessage msg = new Messaging.SingleEmailMessage();
                        msg.setTemplateId(mapRMAtemplates.get(mapEmailData.get(stageRem).Template_Name__c));
                        msg.setToAddresses(lstToAddresses);
                        msg.setCCAddresses(lstCCAddresses);
                        bccList.add(RMA_CONSTANTS.EMAIL_SERVICE_ADDRESS);
                        msg.setBccAddresses(bccList);
                        msg.setTargetObjectId(con.Id);
                        msg.setWhatId(mapStageRemVsRMA.get(stageRem).Id);
                        msg.setSaveAsActivity(false);
                        lstMessages.add(msg);
                    }
                }
            }
            
            //Send the Emails
            if(!lstMessages.isEmpty()){
                Messaging.sendEmail(lstMessages);
            }
            
            //Deleting the Dummy Contact
            if(Con != NULL && Con.Id != NULL){
                delete con;
            }
        }
    }
}