/*
    Author: Shyam Ravindra Nair
    Description: This serves as the controller for MPWPrimeDieAttachmentVF.
    History: 
        SNair   06182015  -  
        
*/
public class MPWPrimeDieAttachmentController {
    
    public String mpwpdId{get;set;}
    public String attachmentType{get;set;}
    public string initiationPoint{get;set;}
    public MPW_Prime_Die__c mpwpd{get;set;}
    public boolean isExternalUser{get;set;}
    public UtilClassToGetAllFields util{get;set;}
    public Blob fileBody{get;set;}
    public String fileName{get;set;}
    
    
    public MPWPrimeDieAttachmentController(){
        this.mpwpd = new MPW_Prime_Die__c();
        this.isExternalUser = false;
        
        util = new UtilClassToGetAllFields();
        this.mpwpdId = ApexPages.currentPage().getParameters().get('MPWPrimeDieID');
        this.attachmentType = ApexPages.currentPage().getParameters().get('AttachmentType');
        this.initiationPoint = ApexPages.currentPage().getParameters().get('initPoint');
        if(this.mpwpdId != null){
            String queryField = util.getAllFields('MPW_Prime_Die__c');
            String soql = 'select '+queryField+' from MPW_Prime_Die__c where Id = \''+this.mpwpdId+'\'';
            this.mpwpd = database.query(soql);
        } 
        
        if(userInfo.getUserType() == 'CustomerSuccess' || userInfo.getUserType() == 'PowerCustomerSuccess'){
              this.isExternalUser = true;
        }  
    }
    
    public pageReference attachFile(){
        pageReference pgRef = new pageReference('/apex/MPWReservationFormVF?Id='+this.mpwpd.MPW_Form__c);
        Attachment attach = new Attachment();
        attach.Body = fileBody;
        if(this.fileName != null && this.fileBody != null){
            attach.ParentId = this.mpwpd.Id;
            if(this.attachmentType == 'TurnkeyPreAlertForm'){
                attach.Name = 'TurnkeyPreAlertForm_'+this.fileName;
                this.mpwpd.TurnkeyAttached__c = true;
                this.mpwpd.TurnkeyAttached__c = true;
            }
            else if(this.attachmentType == 'CornerSplit'){
                attach.Name = 'CornerSplit_'+this.fileName;
                this.mpwpd.CornerSplitAttached__c = true;
            }
            else if(this.attachmentType == 'SubDevicesExtraction'){
                attach.Name = 'SubDevicesExtraction_'+this.fileName;
                this.mpwpd.SubDevicesExtractionAttached__c = true;
            }
            insert attach;
            if(this.attachmentType == 'TurnkeyPreAlertForm'){
                this.mpwpd.TurnkeyAttached__c = true;
                this.mpwpd.TurnkeyAttachedId__c = attach.Id;
            }
            else if(this.attachmentType == 'CornerSplit'){
                this.mpwpd.CornerSplitAttached__c = true;
                this.mpwpd.CornerSplitAttachedId__c = attach.Id;
            }
            else if(this.attachmentType == 'SubDevicesExtraction'){
                this.mpwpd.SubDevicesExtractionAttached__c = true;
                this.mpwpd.SubDevicesExtractionAttachedId__c = attach.Id;
            }
            update this.mpwpd;
        }
        pgRef.getParameters().put('initPoint',initiationPoint);
        pgRef.getParameters().put('mode','View');
        pgRef.setRedirect(true);
        return pgRef;
    }
    
}