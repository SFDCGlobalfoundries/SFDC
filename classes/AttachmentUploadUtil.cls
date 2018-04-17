/*
    Author: Anirban Roy
    Description: This is the utility class for the upload Attachment page in Expose Control Attachment
                 and IP Declaration Form. 
    History:
        ARoy        06212013    - code creation.        
        Win         06272013    - make 'Other' as static final string.
        Devendra        20092016    - updated the functionality to support the Export Control form for Red system.
*/

public class AttachmentUploadUtil {
    
    // Environmental Variable declaration
    public static final string QUES_4_DESC = EnvironmentVariable.get('QUESTION_4_DESC');
    public static final string QUES_5_DESC = EnvironmentVariable.get('QUESTION_5_DESC');
    public static final string QUES_4_BEGIN = EnvironmentVariable.get('QUES_4_STARTSWITH');
    public static final string QUES_5_BEGIN = EnvironmentVariable.get('QUES_5_STARTSWITH');
    
    public static final string MPWAGG_DESC = EnvironmentVariable.get('MPWAGG_DESC');
    public static final string MPWAGG_BEGIN = EnvironmentVariable.get('MPWAGG_BEGIN');
    
    public static final string QUES_5_NEW_DESC = EnvironmentVariable.get('QUES_5_NEW_DESC');
    public static final string QUES_5_NEW_BEGIN = EnvironmentVariable.get('QUES_5_NEW_STARTSWITH');
    
    
    public static final string OTHER = 'Other';
    
    // Instance variables
    public Map<String,Attachment> attachMap = new Map<String,Attachment>();
    public Id parentId;
    
    
    // Retrieve attachment map for Question 4, Question 5 and Other attachment
    public Map<String,Attachment> getAttachments(Id id){
        if(id!=null){           
            parentId = id;
            // Query for Attachment  
            List<Attachment> attachList = [select id,name,body,parentid,description from Attachment 
                                      where parent.id = :id];
            
            // Populating the attachment map with Question 4 and Question 5 if these exists
            for(Attachment att : attachList){
                att.Body=null;
                if(att.Name.startsWith(AttachmentUploadUtil.QUES_4_BEGIN)){
                    attachMap.put(AttachmentUploadUtil.QUES_4_BEGIN,att);
                }else if(att.Name.startsWith(AttachmentUploadUtil.QUES_5_BEGIN)){
                    attachMap.put(AttachmentUploadUtil.QUES_5_BEGIN,att);
                //}else if(att.Name.startsWith(AttachmentUploadUtil.MPWAGG_BEGIN)){
                //    attachMap.put(AttachmentUploadUtil.MPWAGG_BEGIN,att);
                }else if(att.Name.startsWith(AttachmentUploadUtil.QUES_5_NEW_BEGIN)){
                    attachMap.put(AttachmentUploadUtil.QUES_5_NEW_BEGIN,att);
                }
            }
            
            // Checking for Question 4 attachment or creating new attachment object
            if(!attachMap.containsKey(AttachmentUploadUtil.QUES_4_BEGIN)){
                attachMap.put(AttachmentUploadUtil.QUES_4_BEGIN,new Attachment());
            }
            
            // Checking for Question 5 attachment or creating new attachment object
            if(!attachMap.containsKey(AttachmentUploadUtil.QUES_5_BEGIN)){
                attachMap.put(AttachmentUploadUtil.QUES_5_BEGIN,new Attachment());
            }
            
            // Checking for Question 5 New attachment or creating new attachment object
            if(!attachMap.containsKey(AttachmentUploadUtil.QUES_5_NEW_BEGIN)){
                attachMap.put(AttachmentUploadUtil.QUES_5_NEW_BEGIN,new Attachment());
            }
            
            // Checking for MPW aggregator attachment or creating new attachment object
           // if(!attachMap.containsKey(AttachmentUploadUtil.MPWAGG_BEGIN)){
            //    attachMap.put(AttachmentUploadUtil.MPWAGG_BEGIN,new Attachment());
           // }
            
            // Creating new attachment object for Other
            attachMap.put(OTHER, new Attachment());
            return attachMap;
        }
        return null;
    }   
    
    // Saving the attachments
    public Boolean saveAttachList(){
        Boolean isError = false;
        List<Attachment> attachmentList = new List<Attachment>();
        
        for(String att : attachMap.keySet()){
            Attachment att1 = attachMap.get(att);
            
            // Adding the parent and description for the newly added attachment 1
            if(att!=null && att == AttachmentUploadUtil.QUES_4_BEGIN && att1!= null &&
               att1.body != null && !att1.name.startsWith(AttachmentUploadUtil.QUES_4_BEGIN)){
                att1.name = AttachmentUploadUtil.QUES_4_BEGIN + att1.name;
                if(att1.ParentId == null){                     
                    att1.ParentId = parentId;
                    att1.description = AttachmentUploadUtil.QUES_4_DESC;
                }
                attachmentList.add(att1);
            }
            
            // Adding the parent and description for the newly added attachment 2
            if(att!=null && att == AttachmentUploadUtil.QUES_5_BEGIN && att1.body != null &&
                att1.body != null && !att1.name.startsWith(AttachmentUploadUtil.QUES_5_BEGIN)){
                att1.name = AttachmentUploadUtil.QUES_5_BEGIN + att1.name;
                if(att1.ParentId == null){                      
                    att1.ParentId = parentId;
                    att1.description = AttachmentUploadUtil.QUES_5_DESC;
                }               
                attachmentList.add(att1);
            }
            
            // Adding the parent and description for the newly added question 5 attachment 
            if(att!=null && att == AttachmentUploadUtil.QUES_5_NEW_BEGIN && att1.body != null &&
                att1.body != null && !att1.name.startsWith(AttachmentUploadUtil.QUES_5_NEW_BEGIN)){
                att1.name = AttachmentUploadUtil.QUES_5_NEW_BEGIN + att1.name;
                if(att1.ParentId == null){                      
                    att1.ParentId = parentId;
                    att1.description = AttachmentUploadUtil.QUES_5_NEW_DESC;
                }               
                attachmentList.add(att1);
            }
            
            // Adding the parent and description for the newly added mpw aggregator attachment 2
           /* if(att!=null && att == AttachmentUploadUtil.MPWAGG_BEGIN && att1.body != null &&
                att1.body != null && !att1.name.startsWith(AttachmentUploadUtil.MPWAGG_BEGIN)){
                att1.name = AttachmentUploadUtil.MPWAGG_BEGIN + att1.name+string.valueof(system.now()).replace(' ','_');
                if(att1.ParentId == null){                      
                    att1.ParentId = parentId;
                    att1.description = AttachmentUploadUtil.MPWAGG_DESC;
                }               
                attachmentList.add(att1);
            }
            */
            
            // Adding the parent and description for the newly added other attachment
            if(att!=null && att == OTHER && att1.body != null){
                system.debug('saveAttachList - Other att1: ' + att1);
                if(att1.ParentId == null){
                    att1.ParentId = parentId;
                }
                att1.description = OTHER;              
                attachmentList.add(att1);
            }                      
            
        }
        
        // Insert or Update of attachment
        if(attachmentList.size()>0){
               try{
                    upsert attachmentList;
               }catch(Exception e){
                    ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, 'Error Occurred while uploading Attachment(s)'));
                    system.debug('ERROR UPSERTING ATTACHMENT ===> '+ e.getMessage());
                    isError = true; 
               }               
        }
        
        // Checks for the error thrown on attaching files having size more than 5 MB
        if(ApexPages.hasMessages(ApexPages.severity.ERROR)) {
            system.debug('Exceeds File Size limit, abort processing. ApexPages.getMessages() ' + ApexPages.getMessages());            
            isError = true;
        }
        
        return isError;
        
    }
    
}