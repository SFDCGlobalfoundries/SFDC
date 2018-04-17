/*
Type Name: UserCreationForPortalsHelper Class
Author: Ashish Jadhav
Created Date: 12-02-2016
Reason: 
Change History:
Author: Global Foundries (Dinesh M Suggala)
Modified Date: 09-02-2017
Reason: Added the Functionality for Valid Email Domain. Whenever the email is changed in Contact the Corresponding User's Email related to Contact will get updated
??..
??..
*/
public class UserCreationForPortalsHelper {
    public static void UserCreationHelperMethod(List<Contact> conList,Map<Id,Contact> oldMap){
        Set<Id> lstConIds = new Set<Id>();
        for(Contact con : conList){
            if(con.Status__c == 'Active' && oldMap.get(con.Id).Status__c != 'Active')
                lstConIds.add(con.id);
        }
        if(lstConIds.size() > 0)
            UserCreation(lstConIds);
    }
    @future
    public static void UserCreation(Set<Id> lstConIds){
        List<Contact> lstCon = [Select Id, FirstName,Name, Create_Portal_User__c,LastName, Account.Name, Email,AccountId,Is_Portal_User_Active__c,Is_Portal_User_Created__c,
                               Account_Short_Name__c,Phone,Customer_Link__c,MobilePhone,MailingStreet,MailingCity,MailingState,MailingPostalCode,CreatedById,
                               MailingCountry,Status__c,Account_Manager__r.Email,FAE__r.Email,Primary_CSR__r.Email from Contact where Id in: lstConIds];
        List<User> lstUser = new List<User>();
        Map<Id,String> mapAccountTemp = new Map<Id,String>();
		Map<Id,String> mapCreatedEmail = new Map<Id,String>();
        Map<Id,List<String>> mapEmails = new Map<Id,List<String>>();
        Set<String> finalUserAlias = new Set<String>();
        Set<String> finalUserNickn = new Set<String>();
        Set<Id> AccIds = new Set<Id>();
        Set<String> contactEmail = new Set<String>();
        Set<String> contactAlias = new Set<String>();
        Set<String> contactNickn = new Set<String>();
		Set<Id> createdId = new Set<Id>();
		Set<Id> contactIdMailCheck = new Set<Id>();
        UserLicense ul = [SELECT Id,Name FROM UserLicense where name ='Overage Customer Portal Manager Custom' limit 1];
        Profile p = [SELECT Id,Name from Profile where name = 'Overage Customer Portal Profile' limit 1];
        String uname = '';
        String alias = '';
        String nickn = '';
        for(Contact con: lstCon){
            String tempAlias = '';
            AccIds.add(con.AccountId);
            contactEmail.add(con.Email);
            if(con.FirstName.length() > 0)
                tempAlias = con.FirstName.substring(0,1);
            if(con.LastName.length() >= 4)
                tempAlias += con.LastName.substring(0,4);
            else
                tempAlias += con.LastName;
            contactAlias.add(tempAlias);
            contactNickn.add(con.Email.split('@')[0]);
			createdId.add(con.CreatedById);
        }
        for(User u : [Select Id,Name,Email from User where Id IN: createdId]){
            mapCreatedEmail.put(u.Id, u.Email);
        }
        for(Account_Team_Proxy__c a : [Select Id,Name,Account__c,User__c,User__r.Email,User_Email__c,Team_Role__c from Account_Team_Proxy__c 
                                      where (Team_Role__c = 'Primary Account Manager' OR Team_Role__c = 'Primary Customer Service Rep' OR
                                      Team_Role__c = 'Primary Field Application Engineer') and Account__c IN: AccIds]){
            List<String> temp = new List<String>();
            if(mapEmails.containsKey(a.Account__c)){
                 temp.addAll(mapEmails.get(a.Account__c));
                 temp.add(a.User__r.Email);                
            }
            else{
               temp.add(a.User__r.Email);  
            }
            mapEmails.put(a.Account__c,temp);                           
        }
        for(User u : [Select Id, Name,UserName,Alias,ContactId from User where Alias IN: contactAlias]){
            finalUserAlias.add(u.Alias);
        }
        for(User u : [Select Id, Name,UserName,Alias,CommunityNickname,ContactId from User where CommunityNickname IN: contactNickn]){
            finalUserNickn.add(u.CommunityNickname);
        }
        List<Account> accList = [Select Id,Name from Account where Id IN: AccIds];
        for(Account a : accList){
            String temp = '%'+a.Name+' Customer User';
            mapAccountTemp.put(a.Id, temp);
        }
        OrgWideEmailAddress owa = [select id, DisplayName, Address from OrgWideEmailAddress where DisplayName = 'Salesforce, Noreply' limit 1];
        try{
            List<Messaging.SingleEmailMessage> finalEmails = new  List<Messaging.SingleEmailMessage>();
            for(Contact con: lstCon){
                if(con.Status__c == 'Active' && con.Create_Portal_User__c){
					contactIdMailCheck.add(con.Id);
                    User u = new User();
                    if(con.FirstName.length() > 0)
                    alias = con.FirstName.substring(0,1);
                    if(con.LastName.length() >= 4)
                    alias += con.LastName.substring(0,4);
                    else
                    alias += con.LastName;
                    if(finalUserAlias.contains(alias)){
                        String str = String.valueOf(system.today().day());
                        if(str.length()==1)
                            str = '0'+str;
                        alias = alias+String.valueOf(system.today().day());
                    }
                    nickn = con.Email.split('@')[0];
                    if(finalUserNickn.contains(nickn))
                        nickn =  con.Email.split('@')[0]+String.valueOf(system.today().day());
                    u.Email = con.Email;
                    u.Username=con.Email;
                    u.CommunityNickName=nickn;
                    u.Phone=con.Phone;
                    u.MobilePhone=con.MobilePhone;
                    u.Street=con.MailingStreet;
                    u.City=con.MailingCity;
                    u.State=con.MailingState;
                    u.PostalCode=con.MailingPostalCode;
                    u.Country=con.MailingCountry;
                    u.Alias=alias;
                    u.LastName=con.LastName;
                    u.ProfileId=p.Id;
                    u.ContactId=con.Id;
                    u.IsActive = true;
                    u.EmailEncodingKey = 'ISO-8859-1';
                    u.LocaleSidKey = 'en_US';
                    u.LanguageLocaleKey = 'en_US';
                    u.TimeZoneSidKey = 'America/Los_Angeles';
                    lstUser.add(u);
                }
				if(contactIdMailCheck.contains(con.Id)){
					List<String> finalEmailsTo = new List<String>();
					finalEmailsTo.addAll(mapEmails.get(con.AccountId));
					finalEmailsTo.add(mapCreatedEmail.get(con.CreatedById));
					EmailTemplate template = [select id, name,body from EmailTemplate where Name = 'Email Notification for Portal User Activation' limit 1];
					UserCreationForPortalsHelper obj = new UserCreationForPortalsHelper();
					Messaging.SingleEmailMessage tempMail = new Messaging.SingleEmailMessage();
					tempMail.setWhatId(con.AccountId);
					if(template != null ) 
						tempMail.setPlainTextBody(obj.EmailTextTemplate(template.body,con));
					tempMail.setOrgWideEmailAddressId(owa.id);
					tempMail.setSaveAsActivity(false);
					tempMail.setSubject('Email confirmation of portal user creation!');
					tempMail.setToAddresses(finalEmailsTo);
					finalEmails.add(tempMail);
				}
            }
            if(lstUser.size() > 0)
                insert lstUser;
            if(finalEmails.size() > 0)
                Messaging.sendEmail(finalEmails);
        }
        catch(Exception e){
            List<String> support = new List<String>(); 
            support.addAll(Label.SupportEmail.split(','));
            List<Messaging.SingleEmailMessage> finalmsg = new  List<Messaging.SingleEmailMessage>();
            for(Contact c : lstCon){
				c.Status__c = 'Draft';
				support.add(mapCreatedEmail.get(c.CreatedById));
                support.add(c.Account_Manager__r.Email);
                support.add(c.FAE__r.Email);
                support.add(c.Primary_CSR__r.Email);
                String str = System.Url.getSalesforceBaseURL().toExternalForm()+'/'+c.Id;
				String Internalstr = Label.Portal_Admin_URL+'/GlobalfoundryView/'+c.Id;
                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                mail.setSubject('Portal User Creation Failed Due to Validation Errors!');
                mail.setToAddresses(support);
                mail.setOrgWideEmailAddressId(owa.id);
                String body = '<html>Dear AM/CSR/FAE, <br></br><br></br>';
                body += 'Portal automation User Creation has been failed with the following errors: <br></br>';
                body += '<b>Cause:</b> '+e.getCause()+'<br></br>';
                body += '<b>Error type:</b> '+e.getTypeName()+'<br></br>';
                body += '<b>Error Message:</b> '+e.getMessage()+'<br></br>';
                body += '<b>Related Contact Id failed for User Creation :<br></br>';
                body += 'Internal User View : </b> <a href="'+str+'" target="_blank">'+str+'</a><br></br>';
                body += 'Portal User View : </b> <a href="'+Internalstr+'" target="_blank">'+Internalstr+'</a><br></br>';
                body += '<b>Contact Email:</b> '+c.Email+'<br></br>';
                body += '<b>Contact Name:</b> '+c.Name+'<br></br><br></br>';
                body += 'Thank you,<br></br>';
                body += 'GLOBALFOUNDRYVIEW Admin</html>';
                mail.setHtmlBody(body);
                finalmsg.add(mail);
            }
			if(lstCon.size() > 0)
                update lstCon;
            Messaging.sendEmail(finalmsg);
        }
    }
    public string EmailTextTemplate(string emailBody, Contact c){
        emailBody = emailBody.replaceAll('\\{!Contact\\.Name\\}',String.valueOf(c.Name));
        emailBody = emailBody.replaceAll('\\{!Contact\\.Id\\}',String.valueOf(c.Id != null ? string.valueof(c.Id) : 'Not-Defined'));        
        emailBody = emailBody.replaceAll('\\{!Contact\\.AccountId\\}',String.valueOf(c.AccountId != null ? c.AccountId : 'Not-Defined'));
        emailBody = emailBody.replaceAll('\\{!Contact\\.Link\\}',String.valueOf(System.Url.getSalesforceBaseURL().toExternalForm()+'/'+c.Id));
		emailBody = emailBody.replaceAll('\\{!Contact\\.Customer_Link__c\\}',Label.Portal_Admin_URL+'/GlobalfoundryView/'+c.Id);
        return emailBody;
    }

    //Code Added by Dinesh on 12/1/2017 for Email Domain
    public static void UpdateUserEmailSametoContactEmailMethod(Map<String,Contact> contMap){
    
         List<User> lUserForUpdates = new List<User>();
         for(User u: [SELECT Id,ContactId,Email FROM User WHERE ContactId IN: contMap.KeySet()]) {
          u.Email = contMap.get(u.ContactId).Email;
          lUserForUpdates.add(u);
        }
        
         Update lUserForUpdates;
        
        }
}