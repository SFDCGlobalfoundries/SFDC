/***************************************************************************************************************************
Class:         UserLoginSendMailsBatch 
----------------------------------------------------------------------------------------------------------------------------
Author:        Ravi Teja Boggala
Created Date:  05/07/2016 - DD-MM-YYYY
Reason:        This Class is used to send notification to the portal users if they not logged in to portal for more than 6 months
               There are 4 notification which will be delivered after 6 months, 6 months + 15 days, 6 months + 22 days, 6 months + 29 days

Change Log:    Created     -     Ravi Teja     -     05/07/2016
               Updated     -     -     
***************************************************************************************************************************/
global class UserLoginSendMailsBatch implements Database.Batchable<SObject>, Schedulable{
    
    global Database.QueryLocator start(Database.BatchableContext BC){
        Map<String, PortalUserDeactivateRecordTypes__c> accRTs = PortalUserDeactivateRecordTypes__c.getAll();
        Integer days = Integer.valueOf(UserPortalDeactivation__c.getInstance('SendEmailNotification').Days__c) * -1;
        Datetime d = datetime.now().addDays(days); 
        
        if(!test.isRunningTest()){
            return database.getQueryLocator([Select Id,Name,AccountId,LastLoginDate,Contact.Account.RecordType.Name,Contact.Deactivation_Notification_Date__c,LastName,isActive,Email,ContactId, CreatedDate, Profile.Name,Contact.AccountId from User where (LastLoginDate <= : d OR (CreatedDate <=: d AND LastLoginDate=null)) and isActive = true and ContactId != null and Contact.Account.RecordType.Name in: accRTs.keySet() and Profile.Name LIKE 'Overage%' and Contact.Account.Unauthorized__c = false]);
        }
        else
            return database.getQueryLocator([Select Id,Name,AccountId,LastLoginDate,Contact.Deactivation_Notification_Date__c,LastName,isActive,Email,ContactId,Contact.AccountId from User where  isActive = true and ContactId != null and Contact.Account.Unauthorized__c = false]);
    }
    
    global void execute(Database.BatchableContext info, List<User> scope){
        system.debug('scope===='+scope);
        List<Messaging.MassEmailMessage> mails = new List<Messaging.MassEmailMessage>();
        List<Messaging.SingleEmailMessage> internalMails = new List<Messaging.SingleEmailMessage>();
        OrgWideEmailAddress owa = [select id, DisplayName, Address from OrgWideEmailAddress where DisplayName = 'Salesforce, Noreply' limit 1];
        List<Contact> contactToUpdate = new List<Contact>();
        EmailTemplate template1;
        EmailTemplate template2;
        EmailTemplate template3;
        EmailTemplate template4;
        
        EmailTemplate intTemplate1;
        EmailTemplate intTemplate2;
        EmailTemplate intTemplate3;
        EmailTemplate intTemplate4;
        
        List<String> emailTemplates = new List<String>{'PortalDeactivationToAMCSRFAE','PortalDeactivationToAMCSRFAE2','PortalDeactivationToAMCSRFAE3','PortalDeactivationToAMCSRFAE4','User_Notification_For_Batch','User_Notification_2For_Batch','User_Notification_3For_Batch','User_Notification_4For_Batch'};
            
            Integer secondNotDays = Integer.valueOf(UserPortalDeactivation__c.getInstance('SendEmailNotification2').Days__c);
        Integer thirdNotDays = Integer.valueOf(UserPortalDeactivation__c.getInstance('SendEmailNotification3').Days__c);
        Integer fourthNotDays = Integer.valueOf(UserPortalDeactivation__c.getInstance('SendEmailNotification4').Days__c);
        
        for(EmailTemplate temp : [Select Id, DeveloperName,Subject,Body, HTMLValue from EmailTemplate where DeveloperName in: emailTemplates]){
            system.debug('temp===>'+temp.DeveloperName + '==' + temp.Id);
            if(temp.DeveloperName == 'User_Notification_4For_Batch')
                template4 = temp;
            if(temp.DeveloperName == 'User_Notification_3For_Batch')
                template3 = temp;
            if(temp.DeveloperName == 'User_Notification_2For_Batch')
                template2 = temp;
            if(temp.DeveloperName == 'User_Notification_For_Batch')
                template1 = temp;
            if(temp.DeveloperName == 'PortalDeactivationToAMCSRFAE')
                intTemplate1 = temp;
            if(temp.DeveloperName == 'PortalDeactivationToAMCSRFAE2')
                intTemplate2 = temp;
            if(temp.DeveloperName == 'PortalDeactivationToAMCSRFAE3')
                intTemplate3 = temp;
            if(temp.DeveloperName == 'PortalDeactivationToAMCSRFAE4')
                intTemplate4 = temp;
            
        }
        set<Id> conIds = new Set<Id>();
        set<Id> acctIds = new set<Id>();
        for(User u: scope){
            conIds.add(u.ContactId);
            acctIds.add(u.Contact.AccountId);
        }
        Map<Id,Id> conAccMap = new Map<Id,Id>();
        Map<Id,Contact> conMap = new Map<Id,Contact>();
        for(Contact con: [Select Id, AccountId,Account_Manager__c,Deactivation_Notification_Date__c,Account_Manager__r.Email,FAE__c,FAE__r.Email,Primary_CSR__c,Primary_CSR__r.Email from Contact where Id in: conIds]){
            conAccMap.put(con.Id,con.AccountId);
            conMap.put(con.Id,con);
            con.Deactivation_Notification_Date__c = system.today();
            contactToUpdate.add(con);
        }
        List<String> bccSupport = new List<String>();
        List<Id> con1Ids = new List<Id>();
        List<Id> acc1Ids = new List<Id>();
        List<Id> con2Ids = new List<Id>();
        List<Id> acc2Ids = new List<Id>();
        List<Id> con3Ids = new List<Id>();
        List<Id> acc3Ids = new List<Id>();
        List<Id> con4Ids = new List<Id>();
        List<Id> acc4Ids = new List<Id>();
        
        bccSupport.add(Label.DoNotReply);
        Map<String,List<Id>> recepientConIds = new Map<String,List<Id>>();
        List<Id> conIdstemp;
        Map<String,List<Id>> recepientConIds2 = new Map<String,List<Id>>();
        Map<String,List<Id>> recepientConIds3 = new Map<String,List<Id>>();
        Map<String,List<Id>> recepientConIds4 = new Map<String,List<Id>>();
        Map<Id,String> accIdATPEmailMap = new Map<Id,String>();
        Map<Id,List<Account_Team_Proxy__c>> accIdAtpMap = new Map<Id,List<Account_Team_Proxy__c>>();
        List<Account_Team_Proxy__c> atpList;
        for(Account_Team_Proxy__c atp: [Select Id, User__c, User__r.Email,Account__c, Team_Role__c from Account_Team_Proxy__c where Account__c in: acctIds]){
            if(accIdAtpMap.containsKey(atp.Account__c)){
                accIdAtpMap.get(atp.Account__c).add(atp);
            }
            else{
                atpList = new List<Account_Team_Proxy__c>();
                atpList.add(atp);
                accIdAtpMap.put(atp.Account__c,atpList);
            }
        }
        for(Id accId: accIdAtpMap.keySet()){
            String sTemp = '';
            for(Account_Team_Proxy__c atp: accIdAtpMap.get(accId)){
                if(atp.Team_Role__c != null){
                    if(atp.Team_Role__c == 'Primary Account Manager'){
                        sTemp += atp.User__r.Email+';';
                    }
                    else if(atp.Team_Role__c == 'Primary Customer Service Rep'){
                        sTemp += atp.User__r.Email+';';
                    }
                    else if(atp.Team_Role__c == 'Primary Field Application Engineer'){
                        sTemp += atp.User__r.Email+';';
                    }
                }
            }
            if(sTemp != '')
                accIdATPEmailMap.put(accId,sTemp);
        }
        for(User portalUser : scope) {
            if(conAccMap.containsKey(portalUser.ContactId)){
                string sTemp1 = '';
                string sTemp2 = '';
                string sTemp3 = '';
                string sTemp4 = '';
                if(accIdATPEmailMap.containsKey(portalUser.Contact.AccountId)){
                    if(portalUser.Contact.Deactivation_Notification_Date__c != null){
                        if(portalUser.Contact.Deactivation_Notification_Date__c.addDays(secondNotDays) == system.today()){
                            con2Ids.add(portalUser.ContactId);
                            acc2Ids.add(portalUser.Contact.AccountId);
                            if(recepientConIds2.containsKey(accIdATPEmailMap.get(portalUser.Contact.AccountId))){
                                recepientConIds2.get(accIdATPEmailMap.get(portalUser.Contact.AccountId)).add(portalUser.ContactId);
                            }
                            else{
                                conIdstemp = new List<Id>();
                                conIdstemp.add(portalUser.ContactId);
                                recepientConIds2.put(accIdATPEmailMap.get(portalUser.Contact.AccountId),conIdstemp);
                            }
                        }
                        if(portalUser.Contact.Deactivation_Notification_Date__c.addDays(thirdNotDays) == system.today()){
                            con3Ids.add(portalUser.ContactId);
                            acc3Ids.add(portalUser.Contact.AccountId);
                            
                            if(recepientConIds3.containsKey(accIdATPEmailMap.get(portalUser.Contact.AccountId))){
                                recepientConIds3.get(accIdATPEmailMap.get(portalUser.Contact.AccountId)).add(portalUser.ContactId);
                            }
                            else{
                                conIdstemp = new List<Id>();
                                conIdstemp.add(portalUser.ContactId);
                                recepientConIds3.put(accIdATPEmailMap.get(portalUser.Contact.AccountId),conIdstemp);
                            }
                        }
                        if(portalUser.Contact.Deactivation_Notification_Date__c.addDays(fourthNotDays) == system.today()){
                            con4Ids.add(portalUser.ContactId);
                            acc4Ids.add(portalUser.Contact.AccountId);
                            if(recepientConIds4.containsKey(accIdATPEmailMap.get(portalUser.Contact.AccountId))){
                                recepientConIds4.get(accIdATPEmailMap.get(portalUser.Contact.AccountId)).add(portalUser.ContactId);
                            }
                            else{
                                conIdstemp = new List<Id>();
                                conIdstemp.add(portalUser.ContactId);
                                recepientConIds4.put(accIdATPEmailMap.get(portalUser.Contact.AccountId),conIdstemp);
                            }
                        }
                    }
                    else{
                        con1Ids.add(portalUser.ContactId);
                        acc1Ids.add(portalUser.Contact.AccountId);
                        if(recepientConIds.containsKey(accIdATPEmailMap.get(portalUser.Contact.AccountId))){
                            recepientConIds.get(accIdATPEmailMap.get(portalUser.Contact.AccountId)).add(portalUser.ContactId);
                        }
                        else{
                            conIdstemp = new List<Id>();
                            conIdstemp.add(portalUser.ContactId);
                            recepientConIds.put(accIdATPEmailMap.get(portalUser.Contact.AccountId),conIdstemp);
                        }
                    }
                    //mail.setSaveAsActivity(false);
                    //mails.add(mail);
                }
            }
        }
        if(con1Ids.size() > 0){
            Messaging.MassEmailMessage mail1 = new Messaging.MassEmailMessage();
            mail1.setTemplateId(template1.id);
            mail1.setTargetObjectIds(con1Ids);
            mail1.setDescription('Global-FoundryView: Reminder of login to keep user activation');
            mails.add(mail1);
        }
        if(con2Ids.size() > 0){
            Messaging.MassEmailMessage mail2 = new Messaging.MassEmailMessage();
            mail2.setTemplateId(template2.Id);
            mail2.setTargetObjectIds(con2Ids);
            mail2.setDescription('Global-FoundryView: Reminder of login to keep user activation');
            mails.add(mail2);
        }
        if(con3Ids.size() > 0){
            Messaging.MassEmailMessage mail3 = new Messaging.MassEmailMessage();
            mail3.setTemplateId(template3.Id);
            mail3.setTargetObjectIds(con3Ids);
            mail3.setDescription('Global-FoundryView: Reminder of login to keep user activation');
            mails.add(mail3);
        }
        if(con4Ids.size() > 0){
            Messaging.MassEmailMessage mail4 = new Messaging.MassEmailMessage();
            mail4.setTemplateId(template4.Id);
            mail4.setTargetObjectIds(con4Ids);
            mail4.setDescription('Global-FoundryView: Reminder of login to keep user activation');
            mails.add(mail4);
        }
        if(mails.size() > 0)
            Messaging.sendEmail(mails);
        if(contactToUpdate.size() > 0)
            update contactToUpdate;
        
        PageReference pdf;
        Blob attbody;
        
        for(String s: recepientConIds.keySet()){
            system.debug('sssss==>'+s);
            String[] strs = s.split(';');
            system.debug('strssssss==>'+strs);
            Messaging.EmailFileAttachment efa1 = new Messaging.EmailFileAttachment();
            pdf = Page.Portal_Deactivation_pdf;
            string param = ''; 
            for(Id conId: recepientConIds.get(s)){
                param += conId+';';
            }
            pdf.getParameters().put('Ids', param);
            pdf.setredirect(true);
            if(!Test.IsRunningTest())
                attbody = pdf.getContent();
            else
                attBody = blob.valueOf('Test Att');
            efa1.setFileName(system.today() +' ' + 'List of Customers notified for the last time.xls');
            efa1.setBody(attbody);
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            mail.setOrgWideEmailAddressId(owa.id);
            mail.setToAddresses(strs);
            mail.setSubject(intTemplate1.Subject);
            mail.setPlainTextBody(intTemplate1.Body);
            mail.setFileAttachments(new Messaging.EmailFileAttachment[] {efa1});
            internalMails.add(mail);
        }
        for(String s: recepientConIds2.keySet()){
            String[] strs = s.split(';');
            Messaging.EmailFileAttachment efa1 = new Messaging.EmailFileAttachment();
            pdf = Page.Portal_Deactivation_pdf;
            string param = ''; 
            for(Id conId: recepientConIds2.get(s)){
                param += conId+';';
            }
            pdf.getParameters().put('Ids', param);
            pdf.setredirect(true);
            if(!Test.IsRunningTest())
                attbody = pdf.getContent();
            else
                attBody = blob.valueOf('Test Att');
            efa1.setFileName(system.today() +' ' + 'List of Customers notified for the last time.xls');
            efa1.setBody(attbody);
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            mail.setOrgWideEmailAddressId(owa.id);
            mail.setToAddresses(strs);
            mail.setPlainTextBody(intTemplate2.Body);
            mail.setSubject(intTemplate2.Subject);
            mail.setFileAttachments(new Messaging.EmailFileAttachment[] {efa1});
            internalMails.add(mail);
        }
        for(String s: recepientConIds3.keySet()){
            String[] strs = s.split(';');
            Messaging.EmailFileAttachment efa1 = new Messaging.EmailFileAttachment();
            pdf = Page.Portal_Deactivation_pdf;
            string param = ''; 
            for(Id conId: recepientConIds3.get(s)){
                param += conId+';';
            }
            pdf.getParameters().put('Ids', param);
            pdf.setredirect(true);
            if(!Test.IsRunningTest())
                attbody = pdf.getContent();
            else
                attBody = blob.valueOf('Test Att');
            efa1.setFileName(system.today() +' ' + 'List of Customers notified for the last time.xls');
            efa1.setBody(attbody);
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            mail.setOrgWideEmailAddressId(owa.id);
            mail.setToAddresses(strs);
            mail.setSubject(intTemplate3.Subject);
            mail.setPlainTextBody(intTemplate3.Body);
            mail.setFileAttachments(new Messaging.EmailFileAttachment[] {efa1});
            internalMails.add(mail);
        }
        for(String s: recepientConIds4.keySet()){
            
            String[] strs = s.split(';');
            Messaging.EmailFileAttachment efa1 = new Messaging.EmailFileAttachment();
            pdf = Page.Portal_Deactivation_pdf;
            string param = ''; 
            for(Id conId: recepientConIds4.get(s)){
                param += conId+';';
            }
            pdf.getParameters().put('Ids', param);
            pdf.setredirect(true);
            if(!Test.IsRunningTest())
                attbody = pdf.getContent();
            else
                attBody = blob.valueOf('Test Att');
            efa1.setFileName(system.today() +' ' + 'List of Customers notified for the last time.xls');
            efa1.setBody(attbody);
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            mail.setOrgWideEmailAddressId(owa.id);
            mail.setToAddresses(strs);
            mail.setPlainTextBody(intTemplate4.Body);
            mail.setSubject(intTemplate4.Subject);
            mail.setFileAttachments(new Messaging.EmailFileAttachment[] {efa1});
            internalMails.add(mail);
        }
        if(internalMails.size() > 0){
            try{
                Messaging.sendEmail(internalMails);
            }
            catch(exception e){
                //Adding code for exception framework
                ApplicationLogWrapper alw=new ApplicationLogWrapper();
                alw.source = 'UserLoginSendMailsBatch';
                alw.sourceFunction = 'Batch Execute';
                alw.ApplicationName= 'Portal User Deactivation';                  
                alw.referenceInfo = 'Notification Email Sending';
                alw.logMessage ='Error Message='+e.getMessage()+' At Line Number='+e.getLineNumber()+' Stack Trace='+e.getStackTraceString();
                alw.debugLevel ='Error';
                alw.logCode =e.getTypeName();
                alw.ex=e.getCause();
                GlobalUtility.logMessage(alw);
            }
            
        }
        
        
    } 
    
    global void finish(Database.BatchableContext BC){        
        AsyncApexJob a = [SELECT Id, Status, NumberOfErrors, JobItemsProcessed,
                          TotalJobItems, CreatedBy.Email
                          FROM AsyncApexJob WHERE Id =
                          :BC.getJobId()];
        // Send an email to the Apex job's submitter notifying of job completion.
        if((a.NumberOfErrors != 0 && a.NumberOfErrors != null) || Test.isRunningTest()){
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            String[] toAddresses = new String[] {a.CreatedBy.Email};
                mail.setToAddresses(toAddresses);
            mail.setSubject('Portal User Deactivation Notification Batch' + a.Status);
            mail.setPlainTextBody
                ('The batch Apex job processed ' + a.TotalJobItems +
                 ' batches with '+ a.NumberOfErrors + ' failures.');
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
        }
    }
    
    global void execute(SchedulableContext sc){        
        UserLoginSendMailsBatch sendNotification = new UserLoginSendMailsBatch();
        if(!Test.isRunningTest())
            Database.executeBatch(sendNotification,10);
    } 
    public string EmailTextTemplate(string emailBody, User c){
        emailBody = emailBody.replaceAll('\\{!User\\.Name\\}',String.valueOf(c.Name));
        emailBody = emailBody.replaceAll('\\{!User\\.Link\\}',String.valueOf(System.Url.getSalesforceBaseURL().toExternalForm()+'/'+c.Id));
        return emailBody;
    }
}