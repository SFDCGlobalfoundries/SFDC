/*
 * Author: Amit Kumar Ojha
 * Company: JK Technosoft Ltd
 * Description: Batch Class on Contact Object for notifying users on Expiry for ITAR Apps Provision
 * History:
 *   Amit Kumar Ojha	19072017	Initial Draft          
 *
 */
public class ITAR_Certified_Expiry_PortalUsers_Batch implements database.batchable<Sobject> , Database.Stateful{
    public Set<Contact> oneDayExpirySet;
    public Set<Contact> oneWeekExpirySet;
	public List<Contact> expiredMailingCertificateLst;
    public Set<Id> accountMgrIds;
    
    public ITAR_Certified_Expiry_PortalUsers_Batch(){
		oneDayExpirySet = new Set<Contact>();
		oneWeekExpirySet = new Set<Contact>();     
        expiredMailingCertificateLst = new List<Contact>();   
        accountMgrIds = new Set<Id>();	
    }

    public database.QueryLocator start(Database.batchableContext BC)
    {
        return database.getQueryLocator([Select Id, Account_Manager__c, OwnerId, Owner.Name, Owner.Email, ITAR_Certified__c ,Email ,ITAR_Enabled_Date__c, ITAR_Documents_Verified__c, ITAR_Expiry_Prior_One_Day__c, ITAR_Expiry_Prior_One_Week__c FROM Contact WHERE ITAR_Documents_Verified__c = TRUE and Is_Portal_User_Active__c = true]);
    }
    
    // Execute method: check the interval and process accordingly. 
    public void execute (Database.BatchableContext BC, List<Contact> Scope)
    {
        
        List<Contact> expiredCertificateLst = new List<Contact>();
        
        for(Contact con : Scope){
            if(con.ITAR_Documents_Verified__c) {
                if(Test.isRunningTest()) {
                    String userId = Userinfo.getUserId();
                    if(userId != null) {
                    	accountMgrIds.add(userId);
                    }
                }
                if(con.ITAR_Expiry_Prior_One_Day__c == Date.today().addDays(1)){
	                oneDayExpirySet.add(con);
	            }
	            if(con.ITAR_Expiry_Prior_One_Week__c == Date.today().addDays(7)){
	                oneWeekExpirySet.add(con);
	            }/*
	            if(con.ITAR_Enabled_Date__c < Date.today()){
	                // Unchecking the ITAR Certified checkbox
	                con.ITAR_Certified__c = false;
	                expiredCertificateLst.add(con);
	                // Adding again the users to the set in order to use it in sending them a notification
	                expiredMailingCertificateLst.add(con);
	            }*/
            } else if(con.Account_Manager__c != null) {
				accountMgrIds.add(con.Account_Manager__c);
			}
             
        }
        /*
        if(!expiredCertificateLst.isEmpty()){
             update expiredCertificateLst;
        }*/
    }
    
    public void finish(Database.batchableContext BC)
    {
        List<Messaging.SingleEmailMessage> lstSingleEmailMessages = new List<Messaging.SingleEmailMessage>(); // List of single email messages to be sent to subscribers
        String orgWideEmail = System.Label.BugOrgWideEmail;
        String strOrgId = UserInfo.getOrganizationId();   
        List<String> emailAddresses = new List<String>();
		List<User> accountMgrs = new List<User>();
		
        OrgWideEmailAddress owea = [select id, Address from OrgWideEmailAddress WHERE Address =: orgWideEmail LIMIT 1];
        
		if(!accountMgrIds.isEmpty()) {
			accountMgrs = [SELECT Id, Email FROM User WHERE Id IN: accountMgrIds];
		}
		
		if(!accountMgrs.isEmpty()) {
			for(User u : accountMgrs) {
				if(u.Email != null) {
					emailAddresses.add(u.Email);
				}
			}
		}
		
       if(!oneDayExpirySet.isEmpty() || !oneWeekExpirySet.isEmpty()) {
           Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
           if(owea.Id != null) {
           	   email.setOrgWideEmailAddressId(owea.Id);
           }
           if(!oneDayExpirySet.isEmpty()) {
               email.setSubject('One Day ITAR Certification Expiry Notification' );
           } else if(!oneWeekExpirySet.isEmpty()) {
               email.setSubject('One Week ITAR Certification Expiry Notification' );
           }
           
           if(Test.isRunningTest()) {
               email.setToAddresses(new List<String>{'abc@global-foundries.com'});
           } else {
               if(!emailAddresses.isEmpty()) {
                   email.settoAddresses(emailAddresses);
               }
           }
           
           String body = '<br/>';
           body += 'Dear Admins,<br/>';
           body += '<br/>';	
           if(!oneDayExpirySet.isEmpty()) {
               body += 'ITAR certification for the following users are expiring on <b>'+'';
           } else if(!oneWeekExpirySet.isEmpty()) {
               body += 'ITAR certification for the following users are expiring on <b>'+'';
           }   
           
           body += '</b>.<br/> Please take the necessary action.';
           body +='<ol>';
           
           if(!oneDayExpirySet.isEmpty()) { 
               for(Contact onedayCon : oneDayExpirySet){
                   if(onedayCon.Owner.Name != null && onedayCon.Owner.Email != null) {
                       body += '<li>'+onedayCon.Owner.Name+'  '+onedayCon.Owner.Email+'</li>'; 
                   }
               }
           } else if(!oneWeekExpirySet.isEmpty()) { 
               for(Contact oneweekCon : oneWeekExpirySet){
                   if(oneweekCon.Owner.Name != null && oneweekCon.Owner.Email != null) {
                       body += '<li>'+oneweekCon.Owner.Name+'  '+oneweekCon.Owner.Email+'</li>'; 
                   }
               }
           }
           
           body += '</ol>';
           
           body += 'Regards,<br/>';
           body += 'GLOBALFOUNDRIES Admin';
           email.setHtmlBody(body);
           email.setSaveAsActivity(false);
           
           lstSingleEmailMessages.add(email); 				
       }
        
        if(lstSingleEmailMessages.size() > 0) {
        	Messaging.SendEmailResult [] r = Messaging.sendEmail(lstSingleEmailMessages); 
        }
    }
}