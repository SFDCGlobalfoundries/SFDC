/*
Author:         Bhavana Mohan
Company:        Cognizant Technology Solution
Description:    

History:
BMohan     25062013     -     Class Creation
*/
public without sharing class ClsCPKReportUpload
{
public Report_Upload__c reportUpload{get; set;}
public Monthly_CPK_Report__c mCPKReport {get; set;}
public String srcUrl{get;set;}
ApexPages.standardController attach = null;


  public PageReference doSave()
  {
    pageReference returnUrl ;
    try
    {  
    system.debug('Before Insert >>>>>>'+reportUpload);
    insert reportUpload; 
    }
    catch(Exception e)
    {
    system.debug('Exception during inserting'+e);
    }
    returnUrl = new PageReference('/'+mCPKReport.id);
    return returnUrl;                        
}
 public PageReference doCancel()
  {
    List<DeleteObjectFromOpenText__c> DeleteObjectList = new List<DeleteObjectFromOpenText__c>();
    DeleteObjectList = [select Id from DeleteObjectFromOpenText__c where Status__c =: 'SUCCESS' limit 999];
    DeleteObjectFromOpenText__c deleteobjectIns = new DeleteObjectFromOpenText__c();
    deleteobjectIns.OpenTextId__c = mCPKReport.OpenTextId__c;
    deleteobjectIns.Cancel__c = True;
    deleteobjectIns.Source__c = mCPKReport.Source__c;
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
  User currentUserId;
public ClsCPKReportUpload(Apexpages.StandardController stdController)
{
    attach = stdController;
    reportUpload = (Report_Upload__c)stdController.getRecord();
    
    String uId = UserInfo.getUserId(); 
    
    currentUserId = [Select Id,HCM_Login_ID__c,FederationIdentifier,Portal_Login__c from User where Id=:uId limit 1];
    if (currentUserId.Portal_Login__c==null || currentUserId.Portal_Login__c==''){
        if (currentUserId.HCM_Login_ID__c==null || currentUserId.HCM_Login_ID__c==''){
            reportUpload.Short_Name__C = currentUserId.FederationIdentifier;
        } else{
            reportUpload.Short_Name__C = currentUserId.HCM_Login_ID__c;
        }
    } else {
        reportUpload.Short_Name__C = currentUserId.Portal_Login__c;
    }
    
    if(reportUpload  != null)
    {
    mCPKReport = [select Name,OpenTextId__c,Source__c,Id from Monthly_CPK_Report__c where id =: reportUpload.Monthly_CPK_Report__c];
    srcUrl = Label.CpkAttachmentOpenTextUrlFirst+mCPKReport.OpenTextId__c+Label.CpkAttachmentOpenTextUrlSecond;
    }
}
}