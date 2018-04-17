/***************************************************************************************************************************
Class:         DeactivatePortalUserBatch 
----------------------------------------------------------------------------------------------------------------------------
Author:        Ravi Teja Boggala
Created Date:  06/07/2016 -  DD-MM-YYYY
Reason:        This Class is used to Deactivate Portal User who are not logged in to the system for past 7 months

Change Log:    Created     -     Ravi Teja     -     06/07/2016
               Updated     -     -     
***************************************************************************************************************************/
global class DeactivatePortalUserBatch implements Database.Batchable<SObject>,Schedulable,Database.Stateful{
    global Set<Id> conIdsfullState;
    global Database.QueryLocator start(Database.BatchableContext BC){
        Map<String, PortalUserDeactivateRecordTypes__c> accRTs = PortalUserDeactivateRecordTypes__c.getAll();        
        conIdsfullState = new Set<Id>();
        Integer tempLogin = Integer.valueOf(UserPortalDeactivation__c.getInstance('LastLoginVariable').Days__c) * -1;
        Integer days = Integer.valueOf(UserPortalDeactivation__c.getInstance('DeactivateAfterNotification').Days__c) * -1;
        Date d = date.today().addDays(tempLogin); 
        Date d1 = date.today().addDays(days);

        if(!test.isRunningTest()){







            return database.getQueryLocator([Select Id,Name,ProfileId,Parent_Account_Id__c,CreatedDate,LastLoginDate,LastName,isActive,Email,
                                                 Contact.AccountId,Contact.Deactivation_Notification_Date__c,ContactId,Contact.Account.RecordType.Name from User where (LastLoginDate <= : d OR (CreatedDate <=: d AND LastLoginDate=null)) and isActive = true 
                                                 and Contact.Deactivation_Notification_Date__c <=: d1 and ContactId != null and Parent_Account_Id__c != null and Contact.Account.RecordType.Name in: accRTs.keySet() and Profile.Name LIKE 'Overage%' and Contact.Account.Unauthorized__c = false]);

        }
        else
            return database.getQueryLocator([Select Id,Name,ProfileId,Parent_Account_Id__c,CreatedDate,LastLoginDate,LastName,isActive,Email,
                                             Contact.AccountId,Contact.Deactivation_Notification_Date__c,ContactId,Contact.Account.RecordType.Name from User where  isActive = true and ContactId != null and Contact.Account.Unauthorized__c = false]);
    }
    global void execute(Database.BatchableContext info, List<User> scope){
        List<User> userToUpdate = new List<User>();
        List<User> finalUsers = new List<User>();
        Set<Id> contactIds = new Set<Id>();
        Map<Id,List<User>> mapAccountUser = new Map<Id,List<User>>();
        List<Messaging.SingleEmailMessage> internalMails = new List<Messaging.SingleEmailMessage>();
        List<Messaging.MassEmailMessage> massMails = new List<Messaging.MassEmailMessage>();
        OrgWideEmailAddress owa = [select id, DisplayName, Address from OrgWideEmailAddress where DisplayName = 'Salesforce, Noreply' limit 1];
        set<Id> conIds = new set<Id>();
        set<Id> acctIds = new set<Id>();
        for(User u: scope){
            conIds.add(u.ContactId);
            u.isActive = false;
            userToUpdate.add(u);
            acctIds.add(u.Contact.AccountId);
        }
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
        Map<Id,String> accIdATPEmailMap = new Map<Id,String>();
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
        List<Contact> lstCon = new List<Contact>();
        if(!test.isRunningTest())
            lstCon = [Select Id,FirstName,LastName,Name,Account_Manager__r.Email,AccountId,Primary_CSR__r.Email,FAE__r.Email,FAE__c,Primary_CSR__c,Account_Manager__c from Contact where Id IN: conIds];
        else{
            lstCon = [Select Id,FirstName,LastName,Name,Account_Manager__r.Email,AccountId,Primary_CSR__r.Email,FAE__r.Email,FAE__c,Primary_CSR__c,Account_Manager__c from Contact where Is_Portal_User_Active__c = true LIMIT 1];
        }
        
        List<EmailTemplate> intTemplate = [Select Id, Name, Subject, Body from EmailTemplate where Name = 'PortalDeactivationEmailToAMCSRFAE' LIMIT 1];
        
        List<String> bccSupport = new List<String>();
        bccSupport.add(Label.DoNotReply);
        Map<String,List<Id>> recepientConIds = new Map<String,List<Id>>();
        List<Id> conIdstemp;
        List<Id> conIdsToemail = new List<Id>();
        List<Id> accIds = new List<Id>();
        for(Contact c : lstCon){
            conIdsToemail.add(c.Id);
            accIds.add(c.AccountId);
            if(accIdATPEmailMap.containsKey(c.AccountId)){
                if(recepientConIds.containsKey(accIdATPEmailMap.get(c.AccountId))){
                    recepientConIds.get(accIdATPEmailMap.get(c.AccountId)).add(c.Id);
                }
                else{
                    conIdstemp = new List<Id>();
                    conIdstemp.add(c.Id);
                    recepientConIds.put(accIdATPEmailMap.get(c.AccountId),conIdstemp);
                }
            }
            conIdsfullState.add(c.Id);
        }
        PageReference pdf;
        Blob attbody;
        for(String s: recepientConIds.keySet()){
            String[] strs = s.split(';');
            Messaging.EmailFileAttachment efa1 = new Messaging.EmailFileAttachment();
            pdf = Page.Portal_Deactivation_pdf;
            string param = ''; 
            for(Id conId: recepientConIds.get(s)){
                param += conId+';';
            }
            pdf.getParameters().put('Ids', param);
            pdf.setredirect(true);
            if(!Test.IsRunningTest()){
                attbody = pdf.getContent();
            }
            else{
                attBody = Blob.valueOf('Test Attachment');
            }
            efa1.setFileName(system.today() +' ' + 'List of Customers Deactivated.xls');
            efa1.setBody(attbody);
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            mail.setOrgWideEmailAddressId(owa.id);
            mail.setToAddresses(strs);
            mail.setSubject(intTemplate[0].Subject);
            mail.setPlainTextBody(intTemplate[0].Body);
            mail.setFileAttachments(new Messaging.EmailFileAttachment[] {efa1});
            internalMails.add(mail);
        }
		try{
            if(userToUpdate.size() > 0)
                update userToUpdate;
            if(internalMails.size() > 0)
                Messaging.sendEmail(internalMails);
        }
        catch(exception e){
            //Adding code for exception framework
            ApplicationLogWrapper alw=new ApplicationLogWrapper();
            alw.source = 'DeactivatePortalUserBatch';
            alw.sourceFunction = 'Batch Execute';
            alw.ApplicationName= 'Portal User Deactivation';                  
            alw.referenceInfo = 'Deactivating Portal User';
            alw.logMessage ='Error Message='+e.getMessage()+' At Line Number='+e.getLineNumber()+' Stack Trace='+e.getStackTraceString();
            alw.debugLevel ='Error';
            alw.logCode =e.getTypeName();
            alw.ex=e.getCause();
            GlobalUtility.logMessage(alw);
        }
        
    } 
    
    global void finish(Database.BatchableContext BC){        
        AsyncApexJob a = [SELECT Id, Status, NumberOfErrors, JobItemsProcessed,
                          TotalJobItems, CreatedBy.Email
                          FROM AsyncApexJob WHERE Id =
                          :BC.getJobId()];
        if((a.NumberOfErrors != 0 && a.NumberOfErrors != null) || test.isRunningTest()){
            // Send an email to the Apex job's submitter notifying of job completion.
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            String[] toAddresses = new String[] {a.CreatedBy.Email};
                mail.setToAddresses(toAddresses);
            mail.setSubject('Portal User Deactivation Batch' + a.Status);
            mail.setPlainTextBody
                ('The batch Apex job processed ' + a.TotalJobItems +
                 ' batches with '+ a.NumberOfErrors + ' failures.');
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
        }
        PortalContactDeactivateBatch deactCon = new PortalContactDeactivateBatch();
        deactCon.conIds = conIdsfullState;
        Database.executeBatch(deactCon,10);
    }
    
    global void execute(SchedulableContext sc){
        
        DeactivatePortalUserBatch deactivate = new DeactivatePortalUserBatch();
        Database.executeBatch(deactivate,10);
    }
}