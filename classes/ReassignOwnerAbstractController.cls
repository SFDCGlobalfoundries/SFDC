/*
  Author: Win Hwang
  Description: This is the generic controller class for owner reassignment.
  History:
    ARoy        07102013    - code creation.      
    Win         07192013	- added ccAddress in emailNotifyOwner method.
    ARoy		11222013	- modified code to use portal_email__c instead of email field of User.
*/
public abstract class ReassignOwnerAbstractController {
    
    public String notesToNewOwner{get;set;}
    
    public String ownerId{get;set;}
    
    public SObject sObj { get; set; }
    public String prevOwnerId;
    
    //return Account contacts, account team proxy, team role, etc.
    public UsersInfoUtil uiUtil = new UsersInfoUtil();
    
    //variables
    public String owner = EnvironmentVariable.get('OWNER_ID');
    public String notesToNewOwnerLabel = EnvironmentVariable.get('NOTES_TO_NEW_OWNER');
    public String status = EnvironmentVariable.get('EXP_CON_STATUS_API_NAME');
    public String reassignStatus = EnvironmentVariable.get('REASSIGN_STATUS');
    public String emailAdd = EnvironmentVariable.get('EXP_CON_EMAIL_ADD_API_NAME');
    public String cusConName = EnvironmentVariable.get('EXP_CON_CUS_CON_PER_API_NAME');
    public String phone = EnvironmentVariable.get('EXP_CON_PHONE_API_NAME');
    public String lastAssCon = EnvironmentVariable.get('EXP_CON_LAST_ASS_USER_API_NAME');
        
    public ReassignOwnerAbstractController(){
        Id id = ApexPages.currentPage().getParameters().get('id');
        if(id!=null){
            String sobjPrefix = ((String)id).subString(0,3);
            Schema.SObjectType sObjTyp = getSobjectTypeByPrefix(sobjPrefix);
            List<sObject> sObjlist = Database.query('select '+getQueryFields()+' from ' +sObjTyp+' where Id = :id');
            if(sObjlist.size() == 1){
                sObj = sObjlist.get(0);                
                Object obj = sObj.get(owner);
                prevOwnerId = String.valueOf(obj);                                                                                       
            }
        }
    }
    
    /*
    	@return fields to be query
    	Example return: ' Id, Notes_to_New_Owner__c, OwnerId__c, Status__c, Device__c '
    	this return string will be used to construct the full query as:
    	select Id, Notes_to_New_Owner__c, OwnerId__c, Status__c, Device__c from ' +sObjTyp+' where Id = :id 
    */
    public abstract String getQueryFields();
    
    /*
    	this is needed to retrieve Account Team mainly AM/FE of the account for this device.
    	return null if this is not relevant.
    */
    public abstract Id getDeviceId();
    
    /* 
    	Email Body
    */
    public abstract String getEmailBody();
    
    /* 
    	Email Subject
    */
    public abstract String getEmailSubject();    

    public abstract List<SelectOption> getAllAccountContacts();
    
    public abstract PageReference cancel();
    
    //save the IP Declaration Form.
    protected void saveForm() {
        try {
            if(sObj!=null){
                sObj.put(owner , ownerId);
                sObj.put(notesToNewOwnerLabel , notesToNewOwner);
                sObj.put(status , reassignStatus);
                update sObj;                    
            }            
        } catch (DmlException e) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'ReassignOwnerAbstractController 92:' + e.getMessage()));
        }
    }
    
    //save the Export Control Form.
    protected void saveExpForm() {
        try {
            if(sObj!=null){
                User usr = [select phone, email, LastName, FirstName from User where id = :ownerId];
                sObj.put(owner , ownerId);
                sObj.put(notesToNewOwnerLabel , notesToNewOwner);
                sObj.put(status , reassignStatus);
                sObj.put(cusConName , usr.LastName+','+usr.FirstName);
                sObj.put(emailAdd , usr.email);
                sObj.put(phone , usr.phone);
                sObj.put(lastAssCon , UserInfo.getUserId());
                update sObj;                    
            }            
        } catch (DmlException e) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'ReassignOwnerAbstractController 92:' + e.getMessage()));
        }
    }
    
    /*
    	@param optionalCcAddresses will be added to ccAddress[] param if available.
    */
    /*protected void emailNotifyOwner(String emailTemplateName, String[] optionalCcAddresses){
        try{
	        String id = getSObjectId();
	        Id id1 = ApexPages.currentPage().getParameters().get('id');
	        system.debug('id1==>'+id1);
	        Object emailObj = sObj.get(owner);
	        User usr = getUser(String.valueOf(emailObj)); 
	        system.debug('usr.id===>'+usr.id);       
	        String currentEmail='';
	        String prevOwnerEmail='';
	        if(usr!=null){
	            currentEmail = usr.Email;
	        }
	        User usrPrev = getUser(prevOwnerId);
	        if(usrPrev!=null){
	            prevOwnerEmail = usrPrev.Email;
	        }
	        
	        Id targetObjectId = usr.ContactId;
	        Id whatId = id1;
	        List<String> ccAddresses = new List<String>();
	        if(prevOwnerEmail!=''){
	            ccAddresses.add(prevOwnerEmail);
	        } 
	        if(optionalCcAddresses != null){
	        	ccAddresses.addAll(optionalCcAddresses);
	        }
	        EmailUtil.sendEmail(emailTemplateName, targetObjectId, whatId, ccAddresses);
        } catch (DmlException e) {
        	ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'ReassignOwnerAbstractController 128:' + e.getMessage()));
        }
    }*/
    
    /*
    	@param optionalCcAddresses will be added to ccAddress[] param if available.
    */
    protected void emailNotifyOwner(String subject, String emailtextBody, String[] optionalCcAddresses){
        try{
	        String id = getSObjectId();
	        Id id1 = ApexPages.currentPage().getParameters().get('id');
	        
	        Object emailObj = sObj.get(owner);
	        User usr = getUser(String.valueOf(emailObj)); 
	        String prevOwnerEmail='';
	        
	        String[] toAddresses = new String[] {usr.Portal_Email__c};
	        system.debug('toAddresses==>'+toAddresses);
	        List<String> ccAddresses = new List<String>();
	        String htmlBody = null;
	        
	        User usrPrev = getUser(prevOwnerId);
	        if(usrPrev!=null){
	        	prevOwnerEmail = usrPrev.Portal_Email__c;	          
	        }	        
	        	        
	        if(prevOwnerEmail!=''){
	            ccAddresses.add(prevOwnerEmail);
	        } 
	        if(optionalCcAddresses != null){
	        	ccAddresses.addAll(optionalCcAddresses);
	        }
	        system.debug('ccAddresses==>'+ccAddresses);
	        String replyTo = 'do-not-reply@globalfoundries.com';
        	String senderDisplayName = 'No Reply';
	        EmailUtil.sendEmail(subject, emailtextBody, htmlBody, toAddresses, ccAddresses, replyTo, senderDisplayName);
        } catch (DmlException e) {
        	ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'ReassignOwnerAbstractController 128:' + e.getMessage()));
        }
    }
    

    public abstract PageReference save();
    
    //get sobjecttype by sobject prefix (3 chars)
    private Schema.SObjectType getSobjectTypeByPrefix( String SObjectPrefix ){
        for( Schema.SObjectType ot : Schema.getGlobalDescribe().values() ){
            String keyPrefix = (String)ot.getDescribe().getKeyPrefix();
            if( keyPrefix != null && keyPrefix.equals( SObjectPrefix ) ){
                return ot;
            }
        }
        return null;
    }
    
    // get the sObject Id
    protected String getSObjectId(){
        Object o = sObj.get('Id');
        String id = String.valueOf(o);
        return id;
    }
    
    private User getUser(String usrid){
        if(!String.isBlank(usrid)){
            User usr = [select id, email,ContactId,Portal_Email__c from User where id = :usrid limit 1];
            return usr; 
        }else{
            return null;
        }
    }
}