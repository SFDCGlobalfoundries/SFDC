/* Author:- Suvajit

This is the base test fixture for Agreement Test Classes. This class provides the basic structure of the objects but does not perform any DML here. The DML execution rests on the test implementation class using this.

*/

@isTest
public class AgreementTestDataFactory
{
    public static void loaddefaults() 
    {
        DataUtilTest.loadEnvironmentVariables();
        List<GFV_NDA_Account_Sync_Settings__c> ndaSyncSettings = new List<GFV_NDA_Account_Sync_Settings__c>{
            new GFV_NDA_Account_Sync_Settings__c(Name='errorEmailsTo', value__c = 'suvajit.majumder@globalfoundries.com'),
              new GFV_NDA_Account_Sync_Settings__c(Name='ndaSyncApplicableTo', value__c = 'In Signatures->Activated\nFully Signed->Activated'),
              new GFV_NDA_Account_Sync_Settings__c(Name='errorEmailSubject', value__c = '[IMPORTANT] NDA sync to accounts failed.'),
              new GFV_NDA_Account_Sync_Settings__c(Name='syncApplicableRecordTypes', value__c = 'GENERAL_2_Party_NDA')
                };
          
          insert ndaSyncSettings; 
    }
    public static RecordType getRecordTypeId(Schema.sObjectType sObjType, String RecrdType)
    {
        RecordType rt = [SELECT  Id  from RecordType  WHERE SObjectType = :sObjType.getDescribe().getName() AND DeveloperName = :RecrdType];
        return rt;
        
    }
   public static Account GenerateAccount(String RecrdType,String AccName)
   {
     Account acct=new Account();  
     if(!String.isBlank(RecrdType))
         acct = (Account)Account.sObjectType.newSObject(getRecordTypeId(Schema.Account.getsObjectType(),RecrdType).id,true);
     else
         acct = (Account)Account.sObjectType.newSObject(NULL,true);
     acct.Name = AccName;
     acct.short_name__c='TESTACC';
     return acct;

   }
   
   public static Contact GenerateContact(String RecrdType,String ConFirstName,String ConLastName,Account acct)
   {
     Contact con=new Contact();
     if(!String.isBlank(RecrdType))
         con = (Contact)Contact.sObjectType.newSObject(getRecordTypeId(Schema.Contact.getsObjectType(),RecrdType).id,true);
     else
         con = (Contact)Contact.sObjectType.newSObject(NULL,true);    
     con.FirstName= ConFirstName;
     con.LastName=ConLastName;
     con.AccountId=acct.id;
     con.Email='test@abc.com';
     return con;

   }
   
   //add newer fields in the parameter and set the value in the body
   
   public static Apttus__APTS_Agreement__c GenerateAgreement(String RecrdType,String AgrName,Account acct)
   {
     Apttus__APTS_Agreement__c agr=new Apttus__APTS_Agreement__c();  
     if(!String.isBlank(RecrdType))
         agr = (Apttus__APTS_Agreement__c)Apttus__APTS_Agreement__c.sObjectType.newSObject(getRecordTypeId(Schema.Apttus__APTS_Agreement__c.getsObjectType(),RecrdType).id,true);
     else
         agr= (Apttus__APTS_Agreement__c)Apttus__APTS_Agreement__c.sObjectType.newSObject(NULL,true);
     agr.Apttus__Account__c=acct.id;
     agr.Name = AgrName;

     return agr;
   }
   
   public static Attachment GenerateAttachment(Integer size, String AttchName,ID parentId)
   {
       Attachment attach=new Attachment(); 
       attach.Name=AttchName;
       attach.Body=Blob.valueOf('A'.repeat('',size));
       attach.parentId=parentId;
       
       return attach;
   }
   public static Note GenerateNote(Integer BodyLength,String NoteTitle,ID parentId,Boolean IsPrivate)
   {
        Note n=new Note(); 
        n.Title=NoteTitle;
        n.Body='A'.repeat('',BodyLength);
        n.ParentId=parentId;
        n.IsPrivate=IsPrivate;
       
       return n;
   }
   
   
   public static Document GenerateDocument(String DocName)
   {
         Document d=new Document();
         d.Name=DocName;
         d.Description='Test Document';
         d.Keywords='Test';
         d.FolderId=UserInfo.getUserId();
         d.AuthorId=UserInfo.getUserId();
         Blob bodyBlob=Blob.valueOf('Unit Test Document Body');
         d.Body=bodyBlob;
         
         return d;
   }
   
   
   public static Apttus__Agreement_Document__c GenerateAgrDocRecord(SObject File,Apttus__APTS_Agreement__c agr)
   {
          Apttus__Agreement_Document__c agrDoc=new Apttus__Agreement_Document__c();  
          if(File.getsObjectType()==Document.getsObjectType())
          {
          Document d=(Document)File;

          agrDoc.Name=d.Name;
          agrDoc.Apttus__Agreement__c=agr.id;
          agrDoc.Apttus__Path__c=URL.getSalesforceBaseUrl().toExternalForm() +'/' + d.id;
          agrDoc.Apttus__URL__c=URL.getSalesforceBaseUrl().toExternalForm() +'/' + d.id;
          agrDoc.Apttus__Type__c='Final Electronic Copy'; 
          }
          if(File.getsObjectType()==ContentVersion.getsObjectType())
          {
          ContentVersion cv=(ContentVersion)File;
          agrDoc.Name='Test';
          agrDoc.Apttus__Agreement__c=agr.id;
          agrDoc.Apttus__Path__c=URL.getSalesforceBaseUrl().toExternalForm() +'/' + cv.Id;
          agrDoc.Apttus__URL__c=URL.getSalesforceBaseUrl().toExternalForm() +'/' + cv.Id;
          agrDoc.Apttus__Type__c='Final Electronic Copy';  
          }
          return agrDoc;
   }
   
   
   public static FeedItem GenerateFeedWithAttachment(Integer ContentSize,ID parentId)
   {
        FeedItem post = new FeedItem();
        post.ParentId = parentId;
        post.Body = 'Test Body';
        post.Type = 'ContentPost';
        post.ContentData=Blob.valueOf('A'.repeat('',ContentSize));
        post.ContentFileName = 'TestFile';
        post.Title = 'Test'; 
        
        return post; 
   }
   
     
   public static void GenerateDocinLibrary(String LibraryName,Integer ContentSize,String title,ID parentId)
   {
        List<Sobject> GenericList=new List<SObject>();
   
        ContentVersion contentVersionObj = new ContentVersion();
        contentVersionObj.Title =title;
        contentVersionObj.PathOnClient = 'TestFile.txt';
        contentVersionObj.VersionData = Blob.valueOf('A'.repeat('',ContentSize));
        contentVersionObj.IsMajorVersion = true;
        
        insert contentVersionObj;
        
        ContentVersion testContent = [SELECT ContentDocumentId FROM ContentVersion where Id = :contentVersionObj.Id]; 
        
        
        ContentWorkspace testWorkspace = [SELECT Id FROM ContentWorkspace WHERE Name= :LibraryName]; 
        ContentWorkspaceDoc newWorkspaceDoc =new ContentWorkspaceDoc(); 
        newWorkspaceDoc.ContentWorkspaceId = testWorkspace.Id; 
        newWorkspaceDoc.ContentDocumentId = testContent.ContentDocumentId; 
        GenericList.add(newWorkspaceDoc);
         
 
        ContentDocumentLink cwl=new ContentDocumentLink();
        cwl.ContentDocumentId=testContent.ContentDocumentId;
        cwl.LinkedEntityId=parentId;
        cwl.ShareType='V';
        GenericList.add(cwl);
        
        insert GenericList;
   }
     
    public static HCM_Employee__c GenerateHCMID(String FirstName,String LastName,Integer LengthofID)
    {
       HCM_Employee__c hcmid=new HCM_Employee__c();
       hcmid= (HCM_Employee__c )HCM_Employee__c.sObjectType.newSObject(NULL,true);
       hcmid.First_Name__c=FirstName;
       hcmid.Last_Name__c=LastName;
       
       String hashString = '1000' + String.valueOf(Datetime.now().formatGMT('yyyy-MM-dd HH:mm:ss.SSS'));
       Blob hash = Crypto.generateDigest('MD5', Blob.valueOf(hashString));
       String hexDigest = EncodingUtil.convertToHex(hash);

       hcmid.Employee_ID__c=hexDigest.abbreviate(LengthofID);
       hcmid.Login_ID__c=hexDigest.abbreviate(LengthofID);
       
       return hcmid;
    }
    
    public static TD_GN_Business_Reviewer__c GenerateMgmtNDANotification(String n)
    {
        TD_GN_Business_Reviewer__c tdgnbsnrwr=new TD_GN_Business_Reviewer__c();
        tdgnbsnrwr= (TD_GN_Business_Reviewer__c )TD_GN_Business_Reviewer__c.sObjectType.newSObject(NULL,true);
        tdgnbsnrwr.Name=n;
        
        return tdgnbsnrwr;
    }
    
    public static GF_NDA_Signatories__c GenerateGFNDASig(String n)
    {
        GF_NDA_Signatories__c gfndasign=new GF_NDA_Signatories__c();
        gfndasign= (GF_NDA_Signatories__c)GF_NDA_Signatories__c.sObjectType.newSObject(NULL,true);
        gfndasign.Name=n;
        
        return gfndasign;
    }
     
}