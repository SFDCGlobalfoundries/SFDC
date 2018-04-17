/*
 *
 * Author: Amit Kumar Ojha
 * Company: JK Technosoft Ltd
 * Description: Trigger Handler Class on HCM Employee Object and Access Set Up Object for sending mails to Internal/External Users on ITAR Apps Provision 
 * History:
 *   Amit Kumar Ojha    31072017    Initial Draft          
 *   Dinesh Suggala     03122018    Added one more method "uncheckptabitaraccess"
 */
public class ITAR_Certified_Utility {
    //Variables declaration      
    final Static string orgWideEmail = System.Label.BugOrgWideEmail;
    final Static string strOrgId = UserInfo.getOrganizationId();    
    
    /* 
     * @Method Name : appProvisionInternalUserAlert
     * @Parameters : Trigger.oldMap, Trigger.newMap
     * @returnType : None
     * @Description : This method is handling the ITAR Certification and all necessary validations for the Users (or Internal Users) and 
                 sends an email alert for apps provising, if any of the apps check boxes were checked from unchecked state.
     */
    //Email alert for apps provising, if any of the apps check boxes were checked from unchecked state.
    public static void appProvisionInternalUserAlert(Map<id,HCM_Employee__c> userOldMap,Map<id,HCM_Employee__c> userNewMap){ 
        List<String> appProvisionList = new List<String>();
        List<ITAR_HCM_Employee_Fields__c> itarHCMFields = ITAR_HCM_Employee_Fields__c.getAll().values();
        for(ITAR_HCM_Employee_Fields__c itarHCM : itarHCMFields) {
            appProvisionList.add(itarHCM.Name);
        }
        Map<Id,List<String>> usrAppProvMap = new Map<Id,List<String>>();
        List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
        OrgWideEmailAddress owea = [select Id from OrgWideEmailAddress where Address =: orgWideEmail LIMIT 1];

        Map<String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
        Schema.SObjectType ObjectSchema = schemaMap.get('HCM_Employee__c');
        Map<String, Schema.SObjectField> fieldMap = ObjectSchema.getDescribe().fields.getMap();
        List<String> appProvisionReq = new List<String>();
        List<ITAR_US_IT_HELP__c> usIThelp = ITAR_US_IT_HELP__c.getAll().Values();
            
        String usIThelpEmail;
        if(!usIThelp.isEmpty()) {
            usIThelpEmail = usIThelp.get(0).Name;
        }
            
        for(HCM_Employee__c usr : [select Id,LastModifiedById,Email_Address__c,ITARCertified__c,user__c,user__r.username,user__r.email,Conferencing_ITAR__c,DropBox_ITAR__c,DropBox_Non_ITAR__c,Remote_Mask_Viewer_ITAR__c,Remote_Mask_Viewer_Non_ITAR__c from HCM_Employee__c where id =:userNewMap.keyset()]){
            
            for(String appProv : appProvisionList){
                if(((!userOldMap.isEmpty()) 
                    && (usr.get(appProv) != userOldMap.get(usr.id).get(appProv)) 
                    && (userOldMap.get(usr.id).get(appProv) == false)) || (userOldMap.isEmpty() && usr.get(appProv) == true)){
                        if(fieldMap != null && fieldMap.containskey(appProv)) {
                            String appLabel = fieldMap.get(appProv).getDescribe().getLabel();
                            appProvisionReq.add(appLabel);
                        }
                    }       
            } 
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            Messaging.SingleEmailMessage usermail = new Messaging.SingleEmailMessage();
            
            if(!appProvisionReq.isEmpty()){
                usrAppProvMap.put(usr.id, appProvisionReq);   
                
                List<String> sendTo = new List<String>();
                
                if(usIThelpEmail != null && usIThelpEmail != '') {
                    sendTo.add(usIThelpEmail);
                }
                mail.setToAddresses(sendTo);
                if(owea.Id != null) {
                    mail.setOrgWideEmailAddressId(owea.Id);
                }
                //setting subject 
                mail.setSubject('ITAR/Non-ITAR Apps Provisioning');
                // setting record modfied user in CC
                List<String> ccTo = new List<String>();
                ccTo.add(usr.LastModifiedById);
                
                if(!ccTo.isEmpty()) {
                    mail.setCcAddresses(ccTo);
                }
                String body = '<br/>';
                body += '<br/>';
                body += '<b>***PLEASE ROUTE THIS REQUEST TO ADFS TEAM***</b><br/>';
                body += '<br/>';
                body += 'Dear Admin,<br/>';
                body += '<br/>';
                body += 'The following user(s) need to be provisioned for the below ITAR/Restricted International Regulations Application :<br/>';
                body += '<br/>';
                
                Boolean isNA = false;
                Integer counter = 0;
                
                for(String prvReq : appProvisionReq){
                    counter = counter + 1; 
                    if((counter == 1 || counter == 2) && prvReq.contains('-')) {
                        isNA = true;
                    }
                    if(isNA && (counter == 2 || counter > 2)) {
                        isNA = false;
                    } 
                }
                body += '<b>User Name: </b>'+usr.User__r.Username+'<br/>';
                body += '<b>Email Id: </b>'+usr.User__r.Email+'<br/>';
                body += '<b>Domain: </b>'+'&nbsp;usgfoundries&nbsp;'+'<br/>';
                body += '<b>Company Name: </b>'+'&nbsp;GLOBALFOUNDRIES&nbsp;'+'<br/>';
                body += '<b>ITAR Status: </b>'+ (isNA ? 'N/A' : 'Current') +'<br/><p>';
                body += 'Apps to be provisioned: <br/>';
                body +='<ol>';
                
                for(String prvReq : appProvisionReq){
                    if(('Conferencing (ITAR)').equals(prvReq)) { 
                        body += '<b>Application :</b>&nbsp;Conferencing(Restricted International Regulations/ITAR)<br/>';
                    } else if(('DropBox (ITAR)').equals(prvReq)) { 
                        body += '<b>Application :</b>&nbsp;Drop Box(Restricted International Regulations/ITAR)<br/>';
                    } else if(('DropBox (Non-ITAR)').equals(prvReq)) { 
                        body += '<b>Application :</b>&nbsp;Drop Box(Restricted International Regulations/Non-ITAR)<br/>';
                    } else if(('Remote Mask Viewer (ITAR)').equals(prvReq)) { 
                        body += '<b>Application :</b>&nbsp;Remote Mask Viewer(Restricted International Regulations/ITAR)<br/>';
                    } else if(('Remote Mask Viewer (Non-ITAR)').equals(prvReq)) { 
                        body += '<b>Application :</b>&nbsp;Remote Mask Viewer(Restricted International Regulations/Non-ITAR)<br/>';
                    }
                }
                body += '</ol>';
                
                body += 'Thank you,<br/>';
                body += 'GLOBALFOUNDRIES Admin';
                mail.setHtmlBody(body);
                
                // Step 5. Add your email to the master list
                mails.add(mail);
                
                // Notification Mail sent to the User
                if(usr.Email_Address__c != null) {
                    
                    List<String> userAddress = new List<String>();
                    userAddress.add(usr.Email_Address__c);
                    usermail.setToAddresses(userAddress);
                    if(owea.Id != null) {
                        usermail.setOrgWideEmailAddressId(owea.Id);
                    }
                    //setting subject 
                    usermail.setSubject('User Notification for ITAR/Non-ITAR Apps Provisioning');
                    
                    String useremailbody = '<br/>';
                    useremailbody += '<font style="red"><b>***This is a system generated message. Do not reply to this mail. If you are an Internal<br/></b>';
                    useremailbody += '<b>GLOBALFOUNDRIES user, contact HelpDesk. If you are a Customer, contact your GLOBALFOUNDRIES Account Manager or FAE***</b>';
                    useremailbody += '</font>';
                    useremailbody += '<br/>';
                    useremailbody += '<p>Provisioning for the following applications have been initiated :</p><br/>';
                    useremailbody += '<table border="1"><tr><th>App Name</th><th>Training URL</th></tr>';
                    for(String prvReq : appProvisionReq){   
                        String appName = ITAR_Users_Training_Materials__c.getAll().get(prvReq).Name ;
                        if(prvReq == appName) {               
                            useremailbody += '<tr><td>'+prvReq+'</td><td>'+ITAR_Users_Training_Materials__c.getAll().get(prvReq).Training_Material_Link__c+'</td></tr>';
                        }
                    }
                    useremailbody += '</table><br/>';
                    useremailbody += '<br/>';
                    useremailbody += 'Expect to receive an email in within a week with details about your application login.<br/>';
                    useremailbody += '<br/>';
                    useremailbody += 'Thanks<br/>';
                    useremailbody += 'Support Team<br/>';
                    useremailbody += 'GLOBALFOUNDRIES';
                    usermail.setHtmlBody(useremailbody);
                    
                    // Step 5. Add your email to the master list
                    mails.add(usermail);
                    
                }
            }
        }
        if(mails.size() > 0) {
            Messaging.sendEmail(mails);
        }
    }
    
    /* 
     * @Method Name : appProvisionExternalUserAlert
     * @Parameters : Trigger.oldMap, Trigger.newMap
     * @returnType : None
     * Description : This method is handling the ITAR Certification and all necessary validations for the Portal Users (or External Users)
     */
    public static void appProvisionExternalUserAlert(Map<id,Contact> contactOldMap, Map<id,Contact> contactNewMap){
        List<String> appProvisionList = new List<String>();
        List<ITAR_Access_Set_up_Fields__c> itarAccessSetUpFields = ITAR_Access_Set_up_Fields__c.getAll().values();
        for(ITAR_Access_Set_up_Fields__c itarAccSet : itarAccessSetUpFields) {
            appProvisionList.add(itarAccSet.Name);
        }
        OrgWideEmailAddress owea = [select Id from OrgWideEmailAddress where Address =: orgWideEmail LIMIT 1];
        Map<Id,List<String>> conAppProvMap = new Map<Id,List<String>>();
        List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
        // Roles include Account Manager, Backup Customer Service Rep, Customer Service Rep, Primary Account Manager
        Map<String,ITAR_App_Provision_ATP_Roles__c>  customSetATPRoles = ITAR_App_Provision_ATP_Roles__c.getAll();
        Map<Id,Id> contNCheckedUserMap = new Map<id,id>();
        Map<Id,Id> contNAccMap = new Map<id,id>();
        List<Portal_Tab_Access__c> tabAccessList = new List<Portal_Tab_Access__c>();
        tabAccessList = [SELECT Id, Contact__c, DropBox_ITAR__c, DropBox_non_ITAR__c, TeamRoom_ITAR__c, Remote_Mask_Viewer_ITAR__c, Remote_Mask_Viewer_non_ITAR__c FROM Portal_Tab_Access__c WHERE Id IN : contactNewMap.keyset()];
        // Getting all the Fields from the Schema
        Map<String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
        Schema.SObjectType ObjectSchema = schemaMap.get('Portal_Tab_Access__c');
        Map<String, Schema.SObjectField> fieldMap = ObjectSchema.getDescribe().fields.getMap();
        List<String> appProvisionReq = new List<String>();
        List<ITAR_US_IT_HELP__c> usIThelp = ITAR_US_IT_HELP__c.getAll().Values();
            
        String usIThelpEmail;
        if(!usIThelp.isEmpty()) {
            usIThelpEmail = usIThelp.get(0).Name;
        }
        for(Contact con : contactNewMap.values()) {
            
            if(!appProvisionList.isEmpty()){
                if(!tabAccessList.isEmpty()) {
                    for(Portal_Tab_Access__c tabAccess : tabAccessList) {
                        if(tabAccess.Contact__c == con.Id) {
                            for(String appProv : appProvisionList){
                                if(((!contactOldMap.isEmpty()) 
                                    && (con.get(appProv) != contactOldMap.get(con.id).get(appProv)) && (contactOldMap.get(con.id).get(appProv) == false)) || (contactOldMap.isEmpty() && con.get(appProv) == true)){
                                        if(fieldMap != null && fieldMap.containskey(appProv)) {
                                            String appLabel = fieldMap.get(appProv).getDescribe().getLabel();
                                            appProvisionReq.add(appLabel);
                                        }
                                    }   
                            }   
                        }   
                    }
                }
            }
            
            if(!appProvisionReq.isEmpty()){
                conAppProvMap.put(con.id, appProvisionReq);   
                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                List<String> sendTo = new List<String>();
                if(usIThelpEmail != null && usIThelpEmail != '') {
                    sendTo.add(usIThelpEmail);
                }
                mail.setToAddresses(sendTo);
                if(owea.Id != null) {
                    mail.setOrgWideEmailAddressId(owea.Id);
                }
                //setting subject 
                mail.setSubject('ITAR/Non-ITAR App Provisioning');
                // setting record modfied user in CC
                List<String> ccTo = new List<String>();
                ccTo.add(con.LastModifiedById);
                
                if(!ccTo.isEmpty()) {
                    mail.setCcAddresses(ccTo);
                }
                String body = '<br/>';
                body += 'Dear HelpDesk,<br/>';
                body += 'Globalfoundryview '+ (con.Id != null ? 'External' : 'Internal') +' user '+ con.Name+' needs provisioning to the following apps: <br/>';
                body += 'User Name:'+con.Name+'<br/>';
                body += 'Email Id:'+con.Email+'<br/><p>';
                body += 'Apps to be provisioned: <br/>';
                body +='<ol>';
                for(String prvReq : appProvisionReq){
                    body += '<li>'+prvReq+'</li>'; 
                }
                body += '</ol>';
                
                body += 'Thank you,<br/>';
                body += 'GLOBALFOUNDRIES Admin';
                mail.setHtmlBody(body);
                
                // Step 5. Add your email to the master list
                mails.add(mail);
            }
            
            if((con.ITAR_Access_Requested__c == True && contactOldMap.isEmpty()) ||(con.ITAR_Access_Requested__c == True && !contactOldMap.isEmpty() && con.ITAR_Access_Requested__c != contactOldMap.get(con.id).ITAR_Access_Requested__c)){
                contNCheckedUserMap.put(con.id,con.LastModifiedById);
                contNAccMap.put(con.id,con.accountid);
            }
            
            if((con.ITAR_Documents_Verified__c == True && contactOldMap.isEmpty()) ||(con.ITAR_Documents_Verified__c == True && !contactOldMap.isEmpty() && con.ITAR_Documents_Verified__c != contactOldMap.get(con.id).ITAR_Documents_Verified__c)){
                contNCheckedUserMap.put(con.id,con.LastModifiedById);
                contNAccMap.put(con.id,con.accountid);
            }
        }       
        
        String contactName;
        String accountId;
        String accountName;
        String userName;
        String lastModifiedUserName;
        Account a = new Account();
        List<Contact> conList = new List<Contact>();
        List<User> lastModifiedByUsers = new List<User>();
        
        if(!contNCheckedUserMap.isEmpty()) {
            lastModifiedByUsers = [SELECT Id, Name FROM USER WHERE Id IN : contNCheckedUserMap.values()];
        }
        
        
        if(!contNAccMap.isempty()) {
            conList = [SELECT Id, AccountId,User_Name__c,ITAR_Documents_Verified__c, Name, Email FROM Contact WHERE Id IN: contNAccMap.keyset()];
        }
        
        if(!conList.isEmpty()) {
            accountId = conList[0].AccountId;
            
            for(Contact c : conList) {
                if(c.Name != null) {
                    contactName = c.Name;
                } else if(c.User_Name__c != null) {
                    userName = c.User_Name__c;
                }
                if(c.ITAR_Documents_Verified__c) {
                    if(!lastModifiedByUsers.isEmpty()) {
                        for(User u : lastModifiedByUsers) {
                            if(u.Name != null && u.Name != '') {
                                lastModifiedUserName = u.Name;      
                            }
                        }
                    }   
                }
            }
            if(accountId != null) {
                a = [SELECT Id, Name FROM Account WHERE Id =: accountId];
            }
        }
        
        for(Contact con : contactNewMap.values()) {
            // Send mail if Documents are Verified
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            List<String> sendTo = new List<String>();
            
            if(!Test.isRunningTest()) {
                // Add the Group Members Email Addresses
                sendTo = getGroupMailAddresses();
                if(!sendTo.isEmpty()) {
                    mail.setToAddresses(sendTo);
                }
            } else {
                mail.setToAddresses(new List<String>{'amitkumar.ojha@globalfoundries.com'});
            }
            
            if(owea.id != null) {
                mail.setOrgWideEmailAddressId(owea.id);
            } 
            //setting subject 
            mail.setSubject('ITAR/Non-ITAR Apps provisioning for Document Verification');
            // setting record modfied user in CC
            List<String> ccTo = new List<String>();
            ccTo.add(con.LastModifiedById);
            
            if(!ccTo.isEmpty()) {
                mail.setCcAddresses(ccTo);
            }
            String body = '<br/>';
            body += 'Dear Compliance Team,<br/>';
            body += '<br/>';
            body += 'The following user(s) documents have been verified for ITAR Apps Provisioning :<br/>';
            body += '<br/>';
            
            if(con.User_Name__c != null) {
                body += '<b>User ID :</b> '+con.User_Name__c+'<br/>';
            }
            body += '<b>E-Mail ID :</b> '+con.Email+'<br/>';
            body += '<b>Domain :</b> '+'eusgfoundries'+'<br/>';
            if(a.Name != null) {
                body += '<b>Company Name:</b> '+ a.Name+'<br/>';
            }
            body += '<b>Documents verified by Account Manager/FAE for ITAR :</b> '+ 'Yes'+'<br/>';  
            if(lastModifiedUserName != null) {
                body += '<b>Documents verified by :</b> '+ lastModifiedUserName +'<br/>';
            }
            body += '<br/>';
            
            body += 'Thank you,<br/>';
            body += 'GLOBALFOUNDRIES Admin';
            mail.setHtmlBody(body);
            
            // Step 5. Add your email to the master list
            mails.add(mail);
        }
        
        if(mails.size() > 0) { 
            Messaging.sendEmail(mails);
        }
        /*
        Map<id,Set<id>> accATPUserMap = new Map<id,Set<id>>();
        Set<id> atpUsrLst = new Set<id>();
       
        if(!customSetATPRoles.isEmpty() && contNAccMap.values() != null) {
            for(Account_Team_Proxy__c atps : [SELECT Account__c,Id,Name,Team_Role__c,User__c FROM Account_Team_Proxy__c WHERE Team_Role__c IN :customSetATPRoles.keySet() AND Account__c IN :contNAccMap.values()]){
                
                if(accATPUserMap.containsKey(atps.Account__c)){
                    atpUsrLst = accATPUserMap.get(atps.Account__c);
                    atpUsrLst.add(atps.User__c);
                }
                else{
                    atpUsrLst.add(atps.User__c);  
                }
                accATPUserMap.put(atps.Account__c,atpUsrLst);
            }
        }
        */
        Set<id> prmisonSetAssignSet = new Set<id>();
        List<PermissionSetAssignment> prmisonSetAssign = [SELECT AssigneeId,PermissionSetId FROM PermissionSetAssignment where PermissionSet.name = 'Restricted_International_Regulations'];
        
        for(PermissionSetAssignment psAP : prmisonSetAssign ){
            prmisonSetAssignSet.add(psAP.AssigneeId);
        }
        
        List<Case> caseToCreate = new List<Case>();
        String conName;
        String caseOwner;
        String accName;
        String accId;
        Account acc = new Account();
        User u = new User();
        
        if(!contNAccMap.isEmpty()) {
            List<Contact> contactList = [SELECT Id, Name, AccountId, LastModifiedById FROM Contact WHERE Id IN : contNAccMap.keyset()];
            if(!contactList.isEmpty()){
                caseOwner = contactList[0].LastModifiedById;
                for(Contact con : contactList) {
                    if(con.Name != null) {
                        conName = con.Name;
                    }
                }
            }
        }
        
        if(!contactNewMap.isEmpty()) {
            List<Contact> contList = [SELECT Id, Name, AccountId, LastModifiedById FROM Contact WHERE Id IN : contactNewMap.keyset()];
            if(!contList.isEmpty()){
                if(contlist[0].AccountId != null) {
                    accId = contlist[0].AccountId;                  
                    if(accId != null) {
                        acc = [SELECT Id, Name FROM Account WHERE Id =: accId];
                        if(acc != null) {
                            accName = acc.Name;
                        }
                    } 
                }
            }
        }
        
        for(Contact con : contactNewMap.values()){
            if((con.ITAR_Access_Requested__c == True && contactOldMap.isEmpty()) ||(con.ITAR_Access_Requested__c == True && !contactOldMap.isEmpty() && con.ITAR_Access_Requested__c != contactOldMap.get(con.id).ITAR_Access_Requested__c)){
                //if(accATPUserMap != null && ((accATPUserMap.get(contNAccMap.get(con.id))).size()>0 && (accATPUserMap.get(contNAccMap.get(con.id))).contains(con.LastModifiedById)) || 
                   if(!prmisonSetAssignSet.isEmpty() && prmisonSetAssignSet.contains(con.LastModifiedById)){
                       //Create case
                       if(con.ITAR_Case_Number__c == null){ 
                           Case cs = new Case();
                           
                           cs.Application__c = 'Salesforce';
                           cs.Business_process__c = 'Other GFV';
                           if(contactName != null )
                               cs.Description = 'ITAR provisioning for '+ contactName; //need to set
                           cs.Region__c = 'US';
                           cs.Severity__c = 'Normal';
                           cs.Status ='New';
                           if(contactName != null || accName != null)
                               cs.Subject = 'ITAR provisioning for '+contactName + ' associated with ' +accName;
                           cs.Support_Level__c = 'L1';
                           cs.Type = 'Access Request';
                           cs.Priority = 'Medium';
                           cs.ITAR_Created_Case__c = true;
                           caseToCreate.add(cs);
                       }
                   }
            }
        }
            
        List<Case> casesToUpdate = new List<Case>();
        List<Case> updateCases = new List<Case>();
        Set<Id> caseIds = new Set<Id>();
        List<Contact> contactsToUpdate = new List<Contact>();
        List<Contact> updateContacts = new List<Contact>();
        
        if(!caseToCreate.isEmpty()){
            try{
                Database.insert(caseToCreate);
                
                for(Case cs : caseToCreate) {
                    caseIds.add(cs.Id);
                }
                if(!caseIds.isEmpty()){
                    casesToUpdate = [SELECT CaseNumber, ITAR_Created_Case__c, OwnerId FROM Case WHERE Id IN : caseIds];
                    contactsToUpdate = [SELECT Id, ITAR_Case_Number__c FROM Contact WHERE Id IN : contactNewMap.keyset()];
                    for(Case c : casesToUpdate) {
                        if(c.ITAR_Created_Case__c && caseOwner != null) {
                            c.OwnerId = caseOwner;
                            updateCases.add(c);
                        }
                    }
                    for(Contact con : contactsToUpdate){
                        for(Case c : casesToUpdate) {
                            if(c.ITAR_Created_Case__c) {
                                con.ITAR_Case_Number__c = c.CaseNumber;
                                updateContacts.add(con);
                            }
                        }
                    }
                }
                if(updateCases.size() > 0) {
                    update updateCases;
                }
                
                if(updateContacts.size() > 0) {
                    update updateContacts;
                }
            }
            catch(Exception e){
                
            } 
        }
    }
        
    /*
     * @ Method Name : notifyExternalUsersonAppProvision
     * @ Return Type : None
     * @ Parameters : Trigger.oldMap, Trigger.newMap
     * @ Description : Notifying External Users on the ITAR Apps enablement to the US IT Help and the portal User who Last Modified the Access Set Up record
     */
    public static void notifyExternalUsersonAppProvision (Map<id,Portal_Tab_Access__c> oldMapPortalUsers, Map<id,Portal_Tab_Access__c> newMapPortalUsers){    
        List<String> appProvisionList = new List<String>();
        List<ITAR_Access_Set_up_Fields__c> itarAccessSetUpFields = ITAR_Access_Set_up_Fields__c.getAll().values();
        
        for(ITAR_Access_Set_up_Fields__c itarAccSet : itarAccessSetUpFields) {
            appProvisionList.add(itarAccSet.Name);
        }
        Portal_Tab_Access__c portalCon = new Portal_Tab_Access__c();
        String contactId;
        Contact con = new Contact();
        Map<Id,List<String>> usrAppProvMap = new Map<Id,List<String>>();
        List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
        OrgWideEmailAddress owea = [select Id, DisplayName from OrgWideEmailAddress where Address =: orgWideEmail LIMIT 1];
        
        List<Portal_Tab_Access__c> portalConList = [select Id,Contact__c,DropBox_ITAR__c,DropBox_non_ITAR__c,TeamRoom_ITAR__c,Remote_Mask_Viewer_ITAR__c,Remote_Mask_Viewer_Non_ITAR__c from Portal_Tab_Access__c where id =:newMapPortalUsers.keyset() LIMIT 1];
        
        portalCon =  portalConList[0];
        
        if(portalConList[0].Contact__c != null) {
            contactId = portalConList[0].Contact__c;
        }
        
        if(contactId != null) {
            con = [SELECT Id, Name,ITAR_Certified__c,ITAR_Documents_Verified__c, LastModifiedById, User_Name__c, Email FROM Contact WHERE Id=: contactId];
        }
        Map<String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
        Schema.SObjectType ObjectSchema = schemaMap.get('Portal_Tab_Access__c');
        Map<String, Schema.SObjectField> fieldMap = ObjectSchema.getDescribe().fields.getMap();
        List<String> appProvisionReq = new List<String>();
        List<ITAR_US_IT_HELP__c> usIThelp = ITAR_US_IT_HELP__c.getAll().Values();
            
        String usIThelpEmail;
        if(!usIThelp.isEmpty()) {
            usIThelpEmail = usIThelp.get(0).Name;
        }
        if(con.ITAR_Documents_Verified__c != null && con.ITAR_Certified__c != null) {
            for(Portal_Tab_Access__c usr : newMapPortalUsers.values()){
                
                if(usr.User__c != null) {
                    for(String appProv : appProvisionList){
                        if(((!oldMapPortalUsers.isEmpty()) 
                            && (usr.get(appProv) != oldMapPortalUsers.get(usr.id).get(appProv)) 
                            && (oldMapPortalUsers.get(usr.id).get(appProv) == false)) || (oldMapPortalUsers.isEmpty() && usr.get(appProv) == true)){
                                if(fieldMap != null && fieldMap.containskey(appProv)) {
                                    String appLabel = fieldMap.get(appProv).getDescribe().getLabel();
                                    appProvisionReq.add(appLabel);
                                }
                            }       
                    } 
                }
                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                Messaging.SingleEmailMessage usermail = new Messaging.SingleEmailMessage();
                if(!appProvisionReq.isEmpty()){
                    List<String> sendTo = new List<String>();
                    
                    if(usIThelpEmail != null && usIThelpEmail != '') {
                        sendTo.add(usIThelpEmail);
                    }
                    mail.setToAddresses(sendTo);
                    if(owea.Id != null) {
                        mail.setOrgWideEmailAddressId(owea.Id);
                    }
                    //setting subject 
                    mail.setSubject('ITAR/Non-ITAR App Provisioning');
                    // setting record modfied user in CC
                    List<String> ccTo = new List<String>();
                    if(con.LastModifiedById != null) {
                        ccTo.add(con.LastModifiedById);
                    }
                    if(!ccTo.isEmpty()) {   
                        mail.setCcAddresses(ccTo);
                    }
                    String body = '<br/>';
                    body += '<b>***PLEASE ROUTE THIS REQUEST TO ADFS TEAM***</b><br/>';
                    body += '<br/>';
                    body += 'Dear Admin,<br/>';
                    body += '<br/>';
                    body += 'The following user(s) need to be provisioned for the below ITAR/Restricted International Regulations Application :<br/>';
                    body += '<br/>';
                    
                    Boolean isNA = false;
                    Integer counter = 0;
                    
                    if(!appProvisionReq.isEmpty() && appProvisionReq.size() < 3) {
                        for(String prvReq : appProvisionReq){
                            counter = counter + 1; 
                            if((counter == 1 || counter == 2) && prvReq.contains('-')) {
                                isNA = true;
                            }
                            if(isNA && (counter == 2 || counter > 2)) {
                                isNA = false;
                            } 
                        }
                    }
                    if(con.User_Name__c != null)
                        body += '<b>User Name: </b>'+con.User_Name__c+'<br/>';
                    if(con.Email != null)   
                        body += '<b>Email Id: </b>'+con.Email+'<br/>';
                    body += '<b>Domain: </b>'+'&nbsp;eusgfoundries&nbsp;'+'<br/>';
                    body += '<b>Company Name: </b>'+'&nbsp;GLOBALFOUNDRIES&nbsp;'+'<br/>';
                    body += '<b>ITAR Status: </b>'+ (isNA ? 'N/A' : 'Current') +'<br/>';
                    body += 'Apps to be provisioned: <br/>';
                    body +='<ol>';
                    
                    for(String prvReq : appProvisionReq){
                        if(('DropBox (ITAR)').equals(prvReq)) { 
                            body += '<b>Application :</b>&nbsp;Drop Box(Restricted International Regulations/ITAR)<br/>';
                        } else if(('DropBox (non-ITAR)').equals(prvReq)) { 
                            body += '<b>Application :</b>&nbsp;Drop Box(Restricted International Regulations/Non-ITAR)<br/>';
                        } else if(('TeamRoom (ITAR)').equals(prvReq)) { 
                            body += '<b>Application :</b>&nbsp;TeamRoom (Restricted International Regulations/ITAR)<br/>';
                        } else if(('Remote Mask Viewer (ITAR)').equals(prvReq)) { 
                            body += '<b>Application :</b>&nbsp;Remote Mask Viewer(Restricted International Regulations/ITAR)<br/>';
                        } else if(('Remote Mask Viewer (non-ITAR)').equals(prvReq)) { 
                            body += '<b>Application :</b>&nbsp;Remote Mask Viewer(Restricted International Regulations/Non-ITAR)<br/>';
                        }
                    }
                    body += '</ol>';
                    
                    body += 'Thank you,<br/>';
                    body += 'GLOBALFOUNDRIES Admin';
                    mail.setHtmlBody(body);
                    
                    // Step 5. Add your email to the master list
                    mails.add(mail);
                }
            }   
        }
        
        if(mails.size() > 0) {
            Messaging.sendEmail(mails);
        }
    }
    
    /*
     * @ Method Name : getGroupMailAddresses
     * @ Return Type : None
     * @ Parameters : None
     * @ Description : Getting all the Email Addresses of the Group Members who should be getting notified for ITAR Document Verification
     */
    public static List<String> getGroupMailAddresses() {
        List<String> mailList = new List<String>();
        List<String> mailAddresses = new List<String>(); 
        List<GroupMember> groupMemberList = new List<GroupMember>();
        Set<Id> groupIds = new Set<Id>();
        List<Group> groupList = [SELECT Id, Name FROM GROUP WHERE Type ='Regular' AND Name = 'ITAR - Documents Verification Team'];
        
        if(!groupList.isEmpty()) {
            for(Group g : groupList) {
                groupIds.add(g.Id);     
            }
        }
        if(!groupIds.isEmpty()) {
            groupMemberList = [SELECT Id, GroupId, UserorGroupId FROM GroupMember WHERE GroupId IN : groupIds];
        }
        
        if(!groupMemberList.isEmpty()) {
            for (GroupMember gm : groupMemberList) {
                if(gm.userOrGroupId != null) {
                    mailList.add(gm.userOrGroupId);
                }
            }
        }
        
        List<User> userList = new List<User>();
        
        if(!mailList.isEmpty()) {
            userList = [SELECT Email FROM User WHERE Id IN : mailList];
        }
        
        if(!userList.isEmpty()) {
            for(User u : userList) {
                mailAddresses.add(u.email);
            }
        } 
        return mailAddresses;
    }
    
    /* 
     * @Method Name : unchecckptabitaraccess
     * @Parameters : set<Id>
     * @returnType : None
     * Description : This method is used to make the Team_Room_ITAR__c field to false
     */
    @future
    public static void uncheckptabitaraccess(set<Id> contactset){
     
     List<Portal_Tab_Access__c> portlist=[Select Id,Contact__c,TeamRoom_ITAR__c from Portal_Tab_Access__c where Contact__c = :contactset];
     
     List<Portal_Tab_Access__c> newportallist=new List<Portal_Tab_Access__c>();
     for(Portal_Tab_Access__c portal:portlist){
         portal.TeamRoom_ITAR__c =false;
         portal.DropBox_ITAR__c=false;
         portal.DropBox_non_ITAR__c=false;
         portal.Remote_Mask_Viewer_ITAR__c=false;
         portal.Remote_Mask_Viewer_non_ITAR__c=false;
         newportallist.add(portal);
     }
     update newportallist;
    }
}