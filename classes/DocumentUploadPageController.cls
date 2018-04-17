/*
Type Name: DocumentUploadPageController Class
Author: Global Foundries (Dinesh Suggala) 
Created Date: 13-06-2017
Reason: This Class is used to Upload the documents
Change History:
Author: Dinesh Suggala
Modified Date: 26/10/2017
Reason: Added the dummy method

*/
public class DocumentUploadPageController {

    public DocumentUploadPageController(ApexPages.StandardController controller) {    
     
    }
    
    
    public pageReference UploadedTrue(){
    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Info,'File Has Been Uploaded Successfully.Click "Close&Refresh" button')); 
    return null;
    }
    
	//Added by Dinesh 26/10/2017
    public pageReference dummy(){ 
    return null;
    }
    
       
}