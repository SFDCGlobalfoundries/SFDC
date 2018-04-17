public with sharing class QualityCertificationUploadFile {
public Quality_Certificate__c  QCRecord {get; set;}
public UploadQC__c uploadQC {get; set;}
public String srcUrl{get;set;}
public Boolean apRender{get;set;}
ApexPages.standardController uploadQualityCert = null;
ApexPages.standardController attach = null;

public PageReference methodRender() {
         
        return null;
    }
    


public PageReference doCancel()
  {
    List<DeleteObjectFromOpenText__c> DeleteObjectList = new List<DeleteObjectFromOpenText__c>();
    DeleteObjectList = [select Id from DeleteObjectFromOpenText__c where Status__c =: 'SUCCESS' limit 999];
    DeleteObjectFromOpenText__c deleteobjectIns = new DeleteObjectFromOpenText__c();
    deleteobjectIns.OpenTextId__c = QCRecord.OpenTextId__c;
    deleteobjectIns.Cancel__c = True;
    deleteobjectIns.Source__c = QCRecord.Source__c;
    try
    {
    if(DeleteObjectList != null && DeleteObjectList.size() > 0)
    delete DeleteObjectList; 
    insert deleteobjectIns;
    
    }
    catch(Exception e)
    {
    system.debug('Exception during deleteobject Insertion or deletion is'+e);
    }
    
    return attach.cancel();
  }
  
public pageReference Save()
{
    PageReference returnUrl;

        try
        {
        system.debug('Upload QC Fields are >>>>>>>>>>>>>>>'+uploadQC);
        uploadQC.Stage__c='Approved';
        insert uploadQC;
        }
        catch(DMLException e)
        {
        system.debug('Exceptioin during record insert in Uploadqc'+e);  
        return null;
        } 
        returnUrl = new PageReference('/'+QCRecord.id);
        returnUrl.setRedirect(true);   
        return returnUrl;   
 
             
}

User currentUserId;

public QualityCertificationUploadFile (Apexpages.StandardController stdController)
{
    attach =  stdController;
    apRender = True;
    uploadQualityCert = stdController;
    uploadQC = (UploadQC__c)stdController.getRecord();
    String uId = UserInfo.getUserId(); 
    currentUserId = [Select Id,HCM_Login_ID__c,FederationIdentifier,Portal_Login__c from User where Id=:uId limit 1];
    if (currentUserId.Portal_Login__c==null || currentUserId.Portal_Login__c==''){
        if (currentUserId.HCM_Login_ID__c==null || currentUserId.HCM_Login_ID__c==''){
            uploadQC.Short_Name__C = currentUserId.FederationIdentifier;
        } else{
            uploadQC.Short_Name__C = currentUserId.HCM_Login_ID__c;
        }
    } else {
        uploadQC.Short_Name__C = currentUserId.Portal_Login__c;
    }
    
    if(uploadQC != null)
    {
    QCRecord = [select Name,OpenTextId__c,Source__c,id from Quality_Certificate__c  where id =: uploadQC.Quality_Certificate__c ];
    srcUrl= Label.CpkAttachmentOpenTextUrlFirst+QCRecord.OpenTextId__c+Label.CpkAttachmentOpenTextUrlSecond;
    System.debug('srcURL------>'+srcUrl);
    }
 }
}