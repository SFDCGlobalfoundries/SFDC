/*
  Author: Win Hwang
  Description: This is the controller class for IP Declaration owner reassignment.
  History:
    win        07102013    - code creation. 
    Aroy	   09132013	   - added Cancel functionality for retrofitting to FoundryView.
    					   - added functionality for redirecting to list page for Customer Portal User.                      
*/
public class IpDeclarationReassignOwnerController extends ReassignOwnerAbstractController {
    
    
    public String ipDecReassignEmailTemplate = EnvironmentVariable.get('IP_DECLARATION_REASSIGN_EMAIL_TEMPLATE'); //    IPDeclaration_ChangeOwnership
    public String ownerFullName; 
    
    public IpDeclarationReassignOwnerController(){
        super();
    }
    
    public override List<SelectOption> getAllAccountContacts() {
        String id = getSObjectId();
        return uiUtil.getIpDecFormContacts(id);
        
    }
    
    public override PageReference cancel() {
        String id = getSObjectId();
        //************************************************************************
        // 09132013 - Aroy : Cancel functionality for retrofitting to FoundryView 
        String chkPg = ApexPages.currentPage().getParameters().get('type');
        if(chkPg=='list'){
	        PageReference ipDecPage = new PageReference('/apex/MyDevices?sfdc.tabName=01r900000003eSG');
	        ipDecPage.getParameters().put('name','IPDeclaration');
	        ipDecPage.setRedirect(true);
	        return ipDecPage;
        }
        return new PageReference('/'+id);
        //************************************************************************
    }
    
    
    public override PageReference save() {
        saveForm();
        if(ApexPages.hasMessages()){ //if validation failed, return to the same page.
            return null;
        }
        try{
            Id accountId = DeviceHelper.getAccountIdbyDeviceId(getDeviceId());
            system.debug('accountId='+accountId);
            Id devId = getDeviceId();
            ownerFullName = getOwnerId(devId);
            String subject = getEmailSubject();
            List<String> ccAddresses = DeviceHelper.getFEAMEmails(accountId);
            system.debug('ccAddresses='+ccAddresses);
            //emailNotifyOwner(ipDecReassignEmailTemplate, ccAddresses); //customized
            String emailTextBody = getEmailBody();
            emailNotifyOwner(subject, emailTextBody, ccAddresses);
            system.debug('emailNotifyOwner ccAddresses='+ccAddresses);
            String id = getSObjectId();        
            //************************************************************************
	        // 09132013 - Aroy : Redirecting to list page for Customer Portal User 
	        String chkPg = ApexPages.currentPage().getParameters().get('type');
	        if(chkPg=='list'){
		        PageReference ipDecPage = new PageReference('/apex/MyDevices?sfdc.tabName=01r900000003eSG');
		        ipDecPage.getParameters().put('name','IPDeclaration');
		        ipDecPage.setRedirect(true);
		        return ipDecPage;
	        }
	        return new PageReference('/'+id);
	        //************************************************************************
        }catch(Exception e){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'IpDeclarationReassignOwnerController 40:' + e.getMessage()));
            return null;
        }
    }
    
    public override Id getDeviceId(){
        system.debug('sObj='+sObj);
        return ((IP_Declaration_Form__c)sObj).Device__c;
    }
    
    public override String getQueryFields(){
        return 'Id, Notes_to_New_Owner__c, OwnerId__c, Status__c, Device__c, Device_Name__c, Name, CRM_Device_ID__c, Project_Name__c';  
    }
    
    public override String getEmailBody(){
        String emailBody = '';
        String br = '\n';
        emailBody = 'Dear Customer,';
        emailBody += br;
        emailBody += br+ 'The IP Declaration Form for Device ' + ((IP_Declaration_Form__c)sObj).Device_Name__c + 
                        ' is reassigned to you by ' + ownerFullName + '.';
        emailBody += br+ 'Please be reminded to fill in this form as soon as possible.';
        emailBody += br;
        emailBody += br+ 'Notes from '+ ownerFullName + ':';
        emailBody += br+ ((IP_Declaration_Form__c)sObj).Notes_to_New_Owner__c;
        emailBody += br;
        emailBody += br+ 'Please follow the link to review the document.:';
        emailBody += br+ 'Link: ' + EmailUtil.getSFLink('/apex/IPDeclarationEdit?id=' + ((IP_Declaration_Form__c)sObj).Id);
        emailBody += br+ 'IP Declaration Ref. No.: ' + ((IP_Declaration_Form__c)sObj).Name;
        emailBody += br+ 'CRM Device Name: ' + ((IP_Declaration_Form__c)sObj).Device_Name__c;
        emailBody += br+ 'CRM Device ID: ' + ((IP_Declaration_Form__c)sObj).CRM_Device_ID__c;
        emailBody += br+ 'Project Name: ' + ((IP_Declaration_Form__c)sObj).Project_Name__c;
        emailBody += br;
        emailBody += br+ 'Thank you.';
        emailBody += br;
        emailBody += br+ 'NOTE: This is a system generated message. Please do not reply to this email.';
        return emailBody;
    }
    
    public override String getEmailSubject(){
        String subject = 'Action Required: Review IP Declaration for ' + ((IP_Declaration_Form__c)sObj).Device_Name__c;
        return subject;
    }
    
    private String getOwnerId(Id devId){
        Device__c dev = [select owner.Name from Device__c where Id = :devId];
        return dev.owner.Name;
    }
    
}