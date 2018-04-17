/*
 * Author: Amit Kumar Ojha
 * Company: JK Technosoft Ltd
 * Description: Batch Class on HCM Employee Object for notifying users on Expiry for ITAR Apps Provision
 * History:
 *   Amit Kumar Ojha	19072017	Initial Draft          
 *
 */
public class ITAR_Certified_Expiry_Batch implements database.batchable<Sobject> , Database.Stateful{
    
    //Change Request : 21/07/2017 - To move the whole logic from User Object to HCM Employee Object
    
    public Set<HCM_Employee__c> oneDayExpirySet;
    public Set<HCM_Employee__c> oneWeekExpirySet;
    public Set<HCM_Employee__c> expiredMailingCertificateLst;
    
    public ITAR_Certified_Expiry_Batch(){
        oneDayExpirySet = new Set<HCM_Employee__c>();
        oneWeekExpirySet = new Set<HCM_Employee__c>();     
        expiredMailingCertificateLst = new Set<HCM_Employee__c>();     	
    }
    
    public database.QueryLocator start(Database.batchableContext BC)
    {
        return database.getQueryLocator([Select id, ITARCertified__c ,User__r.Email ,User__r.Name, ITAR_EndDate__c FROM HCM_Employee__c WHERE ITARCertified__c = TRUE and User__r.IsPortalEnabled = false and User__r.contactid = null AND Status__c = 'Active']);
    }
    
    // Execute method: check the interval and process accordingly. 
    public void execute (Database.BatchableContext BC, List<HCM_Employee__c> Scope)
    {
        List<HCM_Employee__c> expiredCertificateLst = new List<HCM_Employee__c>();
        
        for(HCM_Employee__c usr : Scope){
            if(usr.ITAR_EndDate__c == Date.today().addDays(1)){
                oneDayExpirySet.add(usr);
            }
            if(usr.ITAR_EndDate__c == Date.today().addDays(7)){
                oneWeekExpirySet.add(usr);
            }
            if(usr.ITAR_EndDate__c < Date.today()){
                // Unchecking the ITAR Certified checkbox
                usr.ITARCertified__c = false;
                expiredCertificateLst.add(usr);
                // Adding again the users to the set in order to use it in sending them a notification
                expiredMailingCertificateLst.add(usr);
            }
        }
        
        if(!expiredCertificateLst.isEmpty()){
            update expiredCertificateLst;
        }
    }
    
    public void finish(Database.batchableContext BC)
    {
        List<Messaging.SingleEmailMessage> lstSingleEmailMessages = new List<Messaging.SingleEmailMessage>(); // List of single email messages to be sent to subscribers
        
        String orgWideEmail = System.Label.BugOrgWideEmail;
        String strOrgId = UserInfo.getOrganizationId();   
        
        OrgWideEmailAddress owea = [select id, Address from OrgWideEmailAddress WHERE Address =: orgWideEmail LIMIT 1];
        List<String> getGroupMembersAddresses = getMailAddresses();
        
        Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
        
        if(!oneDayExpirySet.isEmpty()) {
            if(owea.Id != null)
            	email.setOrgWideEmailAddressId(owea.Id);
            email.setSubject('One Day ITAR Certification Expiry Notification');
            
            if(Test.isRunningTest()) {
                email.setToAddresses(new List<String>{'abc@global-foundries.com'});
            } else {
                if(!getGroupMembersAddresses.isEmpty()) {
                	email.setToAddresses (getGroupMembersAddresses);
                }
            }
            String  body = '<br/>';
            
            body += 'Dear Admins,<br/>';
            body += '<br/>';	   
            body += 'ITAR certification for the following users are expiring on <b>'+Date.today().addDays(1);
            body += '</b>.<br/> Please take the necessary action.';
            body +='<ol>';
            
            for(HCM_Employee__c dayUsr : oneDayExpirySet){
                if(dayUsr.User__r.Name != null && dayUsr.User__r.Email != null) {
                    body += '<li>'+dayUsr.User__r.Name+'  '+dayUsr.User__r.Email+'</li>'; 
                }
            }
            
            body += '</ol>';
            
            body += 'Regards,<br/>';
            body += 'GLOBALFOUNDRIES Admin';
            
            email.setHtmlBody(body);
            email.setSaveAsActivity(false);
            
            lstSingleEmailMessages.add(email); 
        }
        
        Messaging.SingleEmailMessage oneweekemail = new Messaging.SingleEmailMessage();
        
        if(!oneWeekExpirySet.isEmpty()){
            if(owea.Id != null)
            	oneweekemail.setOrgWideEmailAddressId(owea.Id);
            oneweekemail.setSubject('One Week ITAR Certification Expiry Notification' );
            
            if(Test.isRunningTest()) {
                oneweekemail.setToAddresses(new List<String>{'abc@global-foundries.com'});
            } else {
                if(!getGroupMembersAddresses.isEmpty()) {
                	oneweekemail.setToAddresses (getGroupMembersAddresses);
                }
            }
            
            String  body = '<br/>';
            
            body += 'Dear Admins,<br/>';
            body += '<br/>';
            body += 'ITAR certification for the following users are expiring on <b>'+Date.today().addDays(7);
            body += '</b>.<br/> Please take the necessary action.';
            body += '<ol>';
            
            for(HCM_Employee__c weekUsr : oneWeekExpirySet){
                if(weekUsr.User__r.Name != null && weekUsr.User__r.Email != null) {
                    body += '<li>'+weekUsr.User__r.Name+'  '+weekUsr.User__r.Email+'</li>'; 
                }
            }
            
            body += '</ol>';
            
            body += 'Regards,<br/>';
            body += 'GLOBALFOUNDRIES Admin';
            
            oneweekemail.setHtmlBody(body);
            
            oneweekemail.setSaveAsActivity(false);
            lstSingleEmailMessages.add(oneweekemail); 
        }
        
        if(lstSingleEmailMessages.size() > 0) {
            Messaging.SendEmailResult [] r = Messaging.sendEmail(lstSingleEmailMessages); 
        }
    }
    
    /*
     * @Method Name : getMailAddresses
     * @Return Type : List<String>
     * Description : To get the mail addresses of the Users who have been assigned with the Restricted International Regulations Permission Set.
     */
    public List<String> getMailAddresses() {
        List<String> mailList = new List<String>();
        List<String> mailAddresses = new List<String>(); 
        List<User> usr = new List<User>();
        
        List<PermissionSetAssignment> prmisonSetAssign = [SELECT AssigneeId,PermissionSetId FROM PermissionSetAssignment where PermissionSet.Name = 'Restricted_International_Regulations'];
        
        if(!prmisonSetAssign.isEmpty()) {
            for(PermissionSetAssignment psAssig : prmisonSetAssign){
                if(psAssig.AssigneeId != null) {
                    mailList.add(psAssig.AssigneeId);
                }
            }	
        }
        
        if(!mailList.isEmpty()) {
            usr = [SELECT email FROM user WHERE id IN :mailList];
        }
        
        
        if(!usr.isEmpty()) {
            for(User u : usr) {
                mailAddresses.add(u.email);
            } 
        }				
        return mailAddresses;
    }
}