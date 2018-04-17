/*
    Author: Anirban Roy
    Description: This is the controller class for the add Attachment page for Expose Control Attachment. 
    History:
        ARoy        06122013    - code creation.        
*/

public class ExpConAttachSaveController {
        
    // Declare variables
    public Export_Control_Form__c expCntrForm { get; set; }
    public Attachment attachment1 { get; set; }
    public Attachment attachment2 { get; set; }
    public Attachment attachOthers { get; set; }
  
    public AttachmentUploadUtil att = new AttachmentUploadUtil();
	Map<String,Attachment> attachMap = new Map<String,Attachment>();
	String roleGTC = EnvironmentVariable.get('GTC_ROLE');
	String sysAdmin = EnvironmentVariable.get('SYS_ADMIN');
	String othAtt = EnvironmentVariable.get('OTH_ATT'); 
	Error_Codes__c expConAuthError = Error_Codes__c.getInstance('EXPORT_CONTROL_FORM_NOT_AUTHORIZED');
    
    // Constructor to query up the Attachment and initialize the variables
    public ExpConAttachSaveController()
    {
        Id id = ApexPages.currentPage().getParameters().get('id');
        if(id!=null){
		    expCntrForm = [select id, name from Export_Control_Form__c
		                   where Id = :id];
		    String usrRole = getUserRoleName();
		    String profName = getProfileName();		    	      
							
			if(usrRole == roleGTC || profName == sysAdmin){              
				attachMap =  att.getAttachments(id);
		    	attachment1 = attachMap.get(AttachmentUploadUtil.QUES_4_BEGIN);
		    	attachment2 = attachMap.get(AttachmentUploadUtil.QUES_5_BEGIN);
		    	attachOthers = attachMap.get(othAtt);
		    }else{
		    	expCntrForm.addError(expConAuthError.Message__c);
		    }
        }
    }
	
	// Method to save the attachments
    public PageReference saveAttachments()
    {   
        // Declare method variable
        Boolean isError = false;
        String usrRole = getUserRoleName();
		String profName = getProfileName();
        
        if(usrRole == roleGTC || profName == sysAdmin){
	        if(expCntrForm!=null){
	        	att.attachMap.put(AttachmentUploadUtil.QUES_4_BEGIN,attachment1);
				att.attachMap.put(AttachmentUploadUtil.QUES_5_BEGIN,attachment2);
				att.attachMap.put(othAtt,attachOthers);
	        	isError = att.saveAttachList();
	        }
        }else{
        	isError=true;
        	expCntrForm.addError(expConAuthError.Message__c);
        }
		
		// In case of error return to same page or else return to Export Control Form detail page.
        if(isError){
        	return null;
        }else{
        	return new PageReference('/'+expCntrForm.Id);
        }
    }
    
    public PageReference cancel(){
        //View the record
        return new PageReference('/'+expCntrForm.Id);
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
    
    private String getProfileName(){
    	String profName;
    	Id profId = UserInfo.getProfileId();
		List<Profile> profNameList = [select name from Profile where Id = :profId limit 1];
		if(profNameList.size()>0){
			profName = profNameList[0].Name;
		}
		return profName;
    } 
        
}