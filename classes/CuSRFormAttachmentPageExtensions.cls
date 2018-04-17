/*
Author: Shyam Ravindra Nair
Description: Extension for CuSRFormAttachmentPage.
History:
SNair     13112014     - code creation
SNair     14112014     - updated logic for Save method
SNair     20112014     - updated logic for adding attachment to chatter feed.
*/

public class CuSRFormAttachmentPageExtensions{
    
    //variable to store parent id
    public String recordId{get;set;}
    //variable to store sboject name
    public String sobjectName{get;set;}
    //instance of CuSR Form
    public CuSR_Form__c cusrForm{get;set;}
    public CuSR_Implementation__c cusrImplementation{get;set;}
    //public String objectName{get;set;}
    public String recordName{get;set;}
    public String pageType{get;set;}
    public Transient Blob fileBody{get;set;}
    public String fileName{get;set;}
    public boolean displayInfo{get;set;}
    public boolean showError{get;set;}
    public String attachmentFileName{get;set;}
    public pageReference pgRef{get;set;}
    
    //constructor
    public CuSRFormAttachmentPageExtensions(){
        displayInfo = false;
        showError = false;
        recordId = ApexPages.currentPage().getParameters().get('RecordId');
        sobjectName = ApexPages.currentPage().getParameters().get('ObjectName');
        pageType = ApexPages.currentPage().getParameters().get('PageType');
        if(sobjectName == 'CuSR_Form__c'){
            cusrForm = new CuSR_Form__c();
            cusrForm = [select Id, Name from CuSR_Form__c where Id =: RecordId];
            //objectName = 'CuSR Form';
            recordName = cusrForm.Name;
        }
        else if(sobjectName == 'CuSR_Implementation__c'){
            cusrImplementation = new CuSR_Implementation__c();
            cusrImplementation = [select Id, Name from CuSR_Implementation__c where Id =: RecordId];
            //objectName = 'CuSR Implementation';
            recordName = cusrImplementation.Name;
        }
    }
    
    public void attachFile(){
        try{
            if(fileBody != null && fileName != null){
                if(sobjectName == 'CuSR_Form__c'){
                    FeedItem post = new FeedItem();
                    post.ParentId = cusrForm.Id;
                    post.Body = 'New attachment added.';
                    post.ContentData = fileBody;
                    //post.ContentFileName = cusrForm.Name+'_'+fileName;
                    post.ContentFileName = fileName;
                    //post.Title = cusrForm.Name+'_'+fileName;
                    post.Title = fileName;
                    //feedFileName = post.Title;
                    fileBody = null;
                    fileName = '';
                    insert post;
                    displayInfo = true;
                    attachmentFileName = post.Title;
                }
                else if(sobjectName == 'CuSR_Implementation__c'){
                    Attachment attach = new Attachment();
                    attach.ParentId = cusrImplementation.Id;
                    attach.Body = fileBody;
                    attach.Name = fileName;
                    fileBody = null;
                    fileName = '';
                    insert attach;
                    displayInfo = true;
                    attachmentFileName = attach.Name;
                }
            }
            else{
                displayInfo = false;
                showError = true;
                ApexPages.addMessage(new ApexPages.Message(ApexPages.SEVERITY.ERROR,'There was an issue while saving attachment. Please try again.'));
            }
        }
        catch(Exception e){
            
        }
        
    }
    
    public pageReference doneMethod(){
        if(sobjectName == 'CuSR_Form__c'){
        	pgRef = new pageReference('/'+cusrForm.Id);
        }
        else if(sobjectName == 'CuSR_Implementation__c'){
            if(pageType == 'Edit'){
            	pgRef = new pageReference('/apex/CuSRImplementationEditPage?Id='+cusrImplementation.Id);    
            }
            else if(pageType == 'View'){
                pgRef = new pageReference('/apex/CuSRImplementationViewPage?Id='+cusrImplementation.Id);    
            }
        }
        pgRef.setRedirect(true);
        return pgRef;
    }
}