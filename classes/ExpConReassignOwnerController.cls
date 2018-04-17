/*
  Author: Win Hwang
  Description: This is the controller class for Export Control Form owner reassignment.
  History:
    win        07102013     - code creation.
    win        07192013     - added ccAddresses.
    ARoy       10172013     - Added check for reserve mailing capacity to prevent getting error 
                              due to daily email limit.
    ARoy	   11222013		- modified code to use portal_email__c instead of email field of User.               
	ARoy       04082017     - Added for correcting the link for export control form             
*/
public class ExpConReassignOwnerController extends ReassignOwnerAbstractController {
    
    public String expControlEmailTemplate = EnvironmentVariable.get('EXPORT_CONTROL_REASSIGN_EMAIL_TEMPLATE');
    public String ownerFullName;
    public String roleGTC = EnvironmentVariable.get('GTC_ROLE');
    public String sysAdmin = EnvironmentVariable.get('SYS_ADMIN');
    public String expConStatusApiName = EnvironmentVariable.get('EXP_CON_STATUS_API_NAME');
    public String expConStatusDraft = EnvironmentVariable.get('EXP_CON_STATUS_DRAFT');
    public String expConStatusPendResub = EnvironmentVariable.get('EXP_CON_STATUS_PENDING_RESUBMISSION');
    public String expConStatusReassigned = EnvironmentVariable.get('REASSIGN_STATUS');
    public String userTypeCusPortal = EnvironmentVariable.get('USER_TYPE_CUST_PORTAL');
    public String expConQueryFields = EnvironmentVariable.get('EXP_CON_QUERY_FIELDS');
    Error_Codes__c expConStatusRestriction = Error_Codes__c.getInstance('EXP_CON_STATUS_RESTRICT');
    Error_Codes__c expConReassignRestriction = Error_Codes__c.getInstance('EXP_CON_REASSIGN_RESTRICT'); 
    String emailTempBody = '';
    String emailSub = ''; 
    public String expConFormId;
    public List<Device_Export_Control_Junction__c> devExpConJuncList; 
	public Id deviceUnqId; 
    
    //constructor
    public ExpConReassignOwnerController(){
        super();
        expConFormId = ApexPages.currentPage().getParameters().get('id');
        String usrRole = getUserRoleName();
        List<Profile> profList = getProfileList();
        if(profList.size()>0 && (profList[0].Name == sysAdmin 
                        || profList[0].UserType == userTypeCusPortal
                        || usrRole == roleGTC)){                       
            Object obj1 = sObj.get(expConStatusApiName);
            if(obj1!=null && (String.valueOf(obj1)!=expConStatusDraft 
                   && String.valueOf(obj1)!=expConStatusPendResub && String.valueOf(obj1)!=expConStatusReassigned)){
                sObj.addError(expConStatusRestriction.Message__c);
            }
        }else{
            sObj.addError(expConReassignRestriction.Message__c);
        }  
    }
    
    // To get all the Contacts of the Accounts
    public override List<SelectOption> getAllAccountContacts() {
        String id = getSObjectId();
        return uiUtil.getExpControlFormContacts(id);
        
    }
    
    // Cancel functionality
    public override PageReference cancel() {
        String id = getSObjectId();
        String chkPg = ApexPages.currentPage().getParameters().get('type');
        String deviceId = ApexPages.currentPage().getParameters().get('deviceid');
        if(deviceId!=null){
            PageReference expPage = new PageReference('/apex/ExportControlEdit');
            expPage.getParameters().put('deviceid',deviceId);
            if(chkPg=='list'){              
                expPage.getParameters().put('type','list');             
            }
            expPage.setRedirect(true);
            return expPage;
        }
        return new PageReference('/'+id);
    }
    
    // Save functionality and sending email to owner
    public override PageReference save() {
        String usrRole = getUserRoleName();
        List<Profile> profList = getProfileList();
        if(profList.size()>0 && (profList[0].Name == sysAdmin 
                        || profList[0].UserType == userTypeCusPortal
                        || usrRole == roleGTC)){
            Object obj1 = sObj.get(expConStatusApiName);
            if(obj1!=null && (String.valueOf(obj1)!=expConStatusDraft 
                        && String.valueOf(obj1)!=expConStatusPendResub && String.valueOf(obj1)!=expConStatusReassigned)){
                sObj.addError(expConStatusRestriction.Message__c);
            }else{
                saveExpForm();
            }           
        }else{
            sObj.addError(expConReassignRestriction.Message__c);
        }        
        if(ApexPages.hasMessages()){ //if validation failed, return to the same page.
            return null;
        }
        try{
            // get the email template
            EmailTemplate emailTemp = [SELECT id, Subject, Body, HtmlValue from EmailTemplate where name = :expControlEmailTemplate];
            system.debug('Email Subject==>'+emailTemp.Subject);
            system.debug('Email Body==>'+emailTemp.Body);
            emailTempBody = emailTemp.HtmlValue;
            Id accountId = DeviceHelper.getAccountIdbyDeviceId(getDeviceId());
            Id devId = getDeviceId();
            deviceUnqId = devId;
            ownerFullName = getOwnerId(devId);
            List<String> ccAddresses = DeviceHelper.getFEAMEmails(accountId);
            String subject = emailTemp.Subject;
            //emailNotifyOwner(expControlDecEmailTemplate, ccAddresses); //customized
            String emailHtmlBody = getEmailBody();
            emailNotifyOwnerForExpCon(subject, emailHtmlBody, ccAddresses);
            String id = getSObjectId();
            String chkPg = ApexPages.currentPage().getParameters().get('type');
            String deviceId = ApexPages.currentPage().getParameters().get('deviceid');
            if(deviceId!=null){
                PageReference expPage = new PageReference('/apex/ExportControlEdit');
                expPage.getParameters().put('deviceid',deviceId);
                if(chkPg=='list'){              
                    expPage.getParameters().put('type','list');             
                }
                expPage.setRedirect(true);
                return expPage;
            }        
            return new PageReference('/'+id);
        }catch(Exception e){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, e.getMessage()));
            return null;
        }
    }
    
    public override Id getDeviceId(){       
        devExpConJuncList = [select     id,
                                        Device_Name__c,
                                        Device__c,
                                        CRM_Device_ID__c,
                                        Project_Name__c
                             from       Device_Export_Control_Junction__c
                             where      Export_Control_Form__c = :expConFormId 
                             order by   createdDate asc];        
        
        if(devExpConJuncList!=null && devExpConJuncList.size()>0){ 
            return  devExpConJuncList[0].Device__c;        
        }
        return null;
    }
    
    public override String getQueryFields(){
        return expConQueryFields; 
    }
       
    private String getUserRoleName(){
        String usrRole;
        Id usrRoleId = UserInfo.getUserRoleId();
        List<UserRole> usrRoleList = [select name from UserRole where Id = :usrRoleId limit 1];
        if(usrRoleList.size()>0){
            usrRole = usrRoleList[0].Name;
        }
        return usrRole;
    }
    
    private List<Profile> getProfileList(){
        String profName;
        Id profId = UserInfo.getProfileId();
        List<Profile> profNameList = [select name, UserType from Profile where Id = :profId limit 1];
        return profNameList;
    }
    
    public override String getEmailBody(){
        //String devName = ((Export_Control_Form__c)sObj).Device_Name__c!=null?((Export_Control_Form__c)sObj).Device_Name__c:'';
        String ownerFullNameText = ownerFullName!=null?ownerFullName:'';
        String notesToNewOwner = ((Export_Control_Form__c)sObj).Notes_to_New_Owner__c!=null?((Export_Control_Form__c)sObj).Notes_to_New_Owner__c:'';
        String expConLink = EmailUtil.getSFLink('/apex/ExportControlEdit?id=' + ((Export_Control_Form__c)sObj).Id);
        if(expConLink==null){
            expConLink='';
        }else{
        	expConLink = '<a href='+'"'+expConLink+'"'+'>'+expConLink+'</a>';
        }
        
        String emailBody = emailTempBody;
        emailBody = emailBody.replace('{!Device__c.OwnerFullName}', ownerFullNameText);
        emailBody = emailBody.replace('{!Export_Control_Form__c.Notes_to_New_Owner__c}', notesToNewOwner);
        emailBody = emailBody.replace('{!Export_Control_Form__c.Link}',expConLink);
        
		//04-08-2017 Anirban Roy    Added for correcting the link for export control form - START
        emailBody = emailBody.replace('{!$Label.Export_Control_URL_for_Emailtemplate}',System.Label.Export_Control_URL_for_Emailtemplate+expConFormId+'&deviceId='+deviceUnqId);
        //04-08-2017 Anirban Roy    Added for correcting the link for export control form - END
        String deviceTable = '<table border="1" cellpadding="2"><th>CRM Device ID</th><th>CRM Device Name</th><th>Project Name</th>';
        for(Device_Export_Control_Junction__c devExpConJunc : devExpConJuncList){
            deviceTable += '<tr><td>'+(devExpConJunc.CRM_Device_ID__c!=null?devExpConJunc.CRM_Device_ID__c:'')+'</td>';
            deviceTable += '<td>'+(devExpConJunc.Device_Name__c!=null?devExpConJunc.Device_Name__c:'')+'</td>';
            deviceTable += '<td>'+(devExpConJunc.Project_Name__c!=null?devExpConJunc.Project_Name__c:'')+'</td></tr>';
        }
        deviceTable += '</table>'; 
        emailBody = emailBody.replace('#DEVICELIST#', deviceTable);
        emailBody = emailBody.replace('<![CDATA[','');
        emailBody = emailBody.replace(']]>','');
        system.debug('emailBody==>'+emailBody);
        return emailBody;
    }
    
    public void emailNotifyOwnerForExpCon(String subject, String emailhtmlBody, String[] optionalCcAddresses){
        try{
            String id = getSObjectId();
            Id id1 = ApexPages.currentPage().getParameters().get('id');
            
            Object emailObj = sObj.get(owner);
            User usr = getUser(String.valueOf(emailObj)); 
            String prevOwnerEmail='';
            
            String[] toAddresses = new String[] {usr.Portal_Email__c};
            system.debug('toAddresses===>'+toAddresses);
            List<String> ccAddresses = new List<String>();
            String emailtextBody = null;
            
            User usrPrev = getUser(prevOwnerId);
            if(usrPrev!=null){
            	prevOwnerEmail = usrPrev.Portal_Email__c;       
            }
            system.debug('prevOwnerEmail===>'+prevOwnerEmail);            
            if(prevOwnerEmail!=''){
                ccAddresses.add(prevOwnerEmail);
            } 
            if(optionalCcAddresses != null){
                ccAddresses.addAll(optionalCcAddresses);
            }
            system.debug('ccAddresses===>'+ccAddresses);
            String replyTo = 'do-not-reply@globalfoundries.com';
            String senderDisplayName = 'No Reply';

            Integer noOfToRecipient = 0;
            Integer noOfCCRecipient = 0;
            if(toAddresses!=null){
                noOfToRecipient = toAddresses.size();
            }
            if(ccAddresses!=null){
                noOfCCRecipient = ccAddresses.size();
            }
            Messaging.reserveSingleEmailCapacity(noOfToRecipient+noOfCCRecipient);
            EmailUtil.sendEmail(subject, emailtextBody, emailhtmlBody, toAddresses, ccAddresses, replyTo, senderDisplayName);
            
        } catch(Exception e){
            system.debug('Error in sending mail===>'+e.getMessage());
        }
    }
    
    private String getOwnerId(Id devId){
        Device__c dev = [select owner.Name from Device__c where Id = :devId];
        return dev.owner.Name;
    }
    
    public override String getEmailSubject(){return null;}
    
    private User getUser(String usrid){
        if(!String.isBlank(usrid)){
            User usr = [select id, email,ContactId,Portal_Email__c from User where id = :usrid limit 1];
            return usr; 
        }else{
            return null;
        }
    }
    
}