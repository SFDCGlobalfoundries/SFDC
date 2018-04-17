/**
* Company       :   Cognizant Technologies PTE Ltd.
* Description   :   Functionality to store multiple files as a single Zip file in the document.
* History       :   

        Initials        Date          Description
-----------------------------------------------------------------------------------------
        Nikhil Jain    09-Aug-14      Created the Class                                    
**/

public class ROS_DisposalZipExportController {

    public String zipFileName {get; set;}
    public String zipContent {get; set;}
    public String disposalId{get;set;}
    
    public ROS_DisposalZipExportController(){
        disposalId = ApexPages.currentPage().getParameters().get('disposalId');
    }
    
    public PageReference uploadZip() {
        if (String.isEmpty(zipFileName) ||
            String.isBlank(zipFileName)) {
            zipFileName = 'DisposalCertificates.zip';
        }
        else {
            zipFileName.replace('.', '');
            zipFileName += '.zip';
        }
        
        Document doc = new Document();
        doc.Name = zipFileName;
        doc.ContentType = 'application/zip';
        doc.FolderId = UserInfo.getUserId();
        doc.Body = EncodingUtil.base64Decode(zipContent);
        
        insert doc;
        
        this.zipFileName = null;
        this.zipContent = null;

        PageReference pageRef = new PageReference('/' + doc.Id);
        pageRef.setRedirect(true);
        
        return pageRef;
    }

    public List<Attachment> getAttachments() {
        return [SELECT Id, ParentId, Name, ContentType, BodyLength
                FROM Attachment
                WHERE parentId = :disposalId
                LIMIT 1000];
    }
    
    @RemoteAction
    public static AttachmentWrapper getAttachment(String attId) {
        
        Attachment att = [select Id, Name, ContentType, Body
                          from Attachment
                          where Id = :attId];
        
        AttachmentWrapper attWrapper = new AttachmentWrapper();
        attWrapper.attEncodedBody = EncodingUtil.base64Encode(att.body);
        attWrapper.attName = att.Name;
                          
        return attWrapper;
    }
    
    public class AttachmentWrapper {
        public String attEncodedBody {get; set;}
        public String attName {get; set;}
    }
    
    public pageReference cancelReturn(){
        if(disposalId != NULL && disposalId != ''){
            delete([select id from ROS_DisposalCertificate__c where id= :disposalId]);
        }
        pagereference BacktoReticleSearch=page.ROSVF_SearchReticlesGFForm;
        BacktoReticleSearch.setRedirect(true); 
        return BacktoReticleSearch;
    }
    
    public pageReference ReturnMethod(){
        pagereference BacktoReticleSearch=page.ROSVF_SearchReticlesGFForm;
        BacktoReticleSearch.setRedirect(true); 
        return BacktoReticleSearch;
    }
}