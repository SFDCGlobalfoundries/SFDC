public with sharing class PWCAReportUploadFile {
ApexPages.standardController attach = null;
    public PWCAReportUploadFile() {

    }
    public PageReference doSave()
    {
    PageReference returnUrl;
    try
        {
            insert uploadPWCA  ;
        }
        catch(DMLException e)
        {
        system.debug('Exceptioin during record insert in Uploadqc'+e);  
        } 
        returnUrl = new PageReference('/'+pwcaRecord .id);
        returnUrl.setRedirect(true);   
        return returnUrl; 
    }
    
    public PageReference doCancel()
  {
    List<DeleteObjectFromOpenText__c> DeleteObjectList = new List<DeleteObjectFromOpenText__c>();
    DeleteObjectList = [select Id from DeleteObjectFromOpenText__c where Status__c = 'SUCCESS' limit 999];
    DeleteObjectFromOpenText__c deleteobjectIns = new DeleteObjectFromOpenText__c();
    deleteobjectIns.OpenTextId__c = pwcaRecord.OpenTextId__c;
    deleteobjectIns.Cancel__c = True;
    deleteobjectIns.Source__c = pwcaRecord.Source__c;
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
  public static void  CreateDeleteObject(Map<String,String> MapId)
    {
        List<DeleteObjectFromOpenText__c> DeleteObjectList = new List<DeleteObjectFromOpenText__c>();
        List<DeleteObjectFromOpenText__c> DeleteObjectInsertList = new List<DeleteObjectFromOpenText__c>();
        DeleteObjectList = [select Id from DeleteObjectFromOpenText__c where Status__c = 'SUCCESS' limit 999];
        for(String id: MapId.keySet())
        {
             for(String otid : MapId.get(id).split(';')){
                 if(otid!=null && otid!=''){
                    DeleteObjectFromOpenText__c deleteobjectIns = new DeleteObjectFromOpenText__c();
                    //deleteobjectIns.OpenTextId__c = MapId.get(id);
                    deleteobjectIns.OpenTextId__c = otid;
                    deleteobjectIns.SFDCId__c = id;
                    deleteobjectIns.Source__c = 'PWCA';
                    DeleteObjectInsertList.add(deleteobjectIns);
                    }
        }
    }
    try
    {
    if(DeleteObjectList != null && DeleteObjectList.size() > 0)
    delete DeleteObjectList; 
    insert DeleteObjectInsertList;
    
    }
    catch(Exception e)
    {
    system.debug('Exception during deleteobject Insertion or deletion is'+e);
    }
    }
  


public PWCA_publication__c pwcaRecord {get; set;}
public PWCA_Attachments__c uploadPWCA {get; set;}
public String srcUrl{get;set;}
User currentUserId ;
public PWCAReportUploadFile(Apexpages.StandardController stdController)
{
    attach = stdController;
    uploadPWCA  = (PWCA_Attachments__c)stdController.getRecord();
    String uId = userInfo.getUserId();
    currentUserId = [Select Id,HCM_Login_ID__c,FederationIdentifier,Portal_Login__c from User where Id=:uId limit 1];
       
     if (currentUserId.Portal_Login__c==null || currentUserId.Portal_Login__c==''){
        if (currentUserId.HCM_Login_ID__c==null || currentUserId.HCM_Login_ID__c==''){
            uploadPWCA.Short_Name__C = currentUserId.FederationIdentifier;
        } else{
            uploadPWCA.Short_Name__C = currentUserId.HCM_Login_ID__c;
        }
    } else {
        uploadPWCA.Short_Name__C = currentUserId.Portal_Login__c;
    }
    
    
    if(uploadPWCA != null)
    {
    pwcaRecord = [select Name,OpenTextId__c,Source__c  from PWCA_publication__c where id =: uploadPWCA.PWCA_publication__c limit 1];
    srcUrl = Label.CpkAttachmentOpenTextUrlFirst+pwcaRecord.OpenTextId__c+Label.CpkAttachmentOpenTextUrlSecond;
    
    }
 }
}