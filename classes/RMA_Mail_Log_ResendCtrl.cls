/**
* Author: Surendranadh Nune
* Company: GlobalFoundries,India
* Project: Return Material Authorization
* Description: This class is used to resend the email that was already sent.
* History:
*    SurendranadhNune 05112015  -   Created.
**/
public class RMA_Mail_Log_ResendCtrl {
    
    private RMA_Audit_log__c auditObj;
    public String addCC{get;set;}
    public boolean isCSR{get;set;}
    public RMA_Mail_Log_ResendCtrl(ApexPages.StandardController controller){
    	addCC = '';
        auditObj = (RMA_audit_log__c)controller.getRecord();
        isCSR = hasAdminPriv() || checkOwner();
    }
    
    //This method is used to resend email.
    public void resend(){
       boolean isValidEmail = true;	
       Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
       List<String> sendTo = new List<String>();
       sendTo = String.isNotBlank(auditObj.to__c) ? auditObj.to__c.split(', ') : null; 
       List<String> CCList = new List<String>();
       if(String.isNotBlank(auditObj.cc__c))
            ccList = String.isNotBlank(auditObj.CC__c) ? auditObj.CC__c.split(', '): null;
	   if(String.isNotBlank(addCC)){
	   	 List<String> addCCList = addCC.trim().split(';');
	   	 for(String str : addCCList){
	   	 	isValidEmail = validateEmail(str.trim());
	   	 	if(!isValidEmail){
	   	 		ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.error,'Please enter valid email address(es) separated by semicolon(;).'));
	   	 		break;
	   	 	}else{
	   	 		CCList.add(str);
	   	 	}
	   	 }
	   }
	   if(isValidEmail){	             
	       mail.setToAddresses(sendTo);
	       mail.setCcAddresses(CCList);   
	       mail.setSubject('Resend:' + auditObj.Subject__c);  
	       mail.setHtmlBody(auditObj.Email_Body__c);
	       List<Messaging.SendEmailResult> results = Messaging.sendEmail(new Messaging.SingleEmailMessage[]{mail});
	       ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Confirm,'E-mail sent successfully.'));
	   }
    }
    
    //public boolean checkOwner
    public boolean checkOwner(){
    	if(userInfo.getUserId() == auditObj.RMA__r.ownerId){
    		return true;
    	}
    	else{
    		return false;
    	}
    }
    
    //Method to check if the logged-in user is a system administrator.
    public boolean hasAdminPriv(){
        Profile p = [select Name from Profile where Id =: userInfo.getProfileId()];
        if(p.Name.equalsIgnoreCase('System Administrator')
        || p.Name.equalsIgnoreCase('GF Consultants')
        || p.Name.equalsIgnoreCase('GF Developer')
        || p.Name.equalsIgnoreCase('GF Integration')
        || p.Name.equalsIgnoreCase('GF System Admin')){
            return true;
        }
        else{
            return false;
        }
    } 
    
    private boolean validateEmail(String email){
    	return Pattern.matches('[a-zA-Z0-9._-]+@[a-zA-Z]+.[a-zA-Z]{2,4}', email);
    }
}