/*
*   Author: Suvajit Majumder
*   Description:  This class is the controller for GF_AgreementActivate VF page and implements the functions of an Agreement Activation.
*   History: 
*   suvajit:   29/02/2016    - Apex code created
    DBiswal    02092018        Changes for SOQL issue(line 628) and Google doc(164).
*/


public without sharing class GFAgreementActivateController
{
  
    public final Apttus__APTS_Agreement__c objAgr{get; set;}
    
    private static Id agrid;
    
    public List<String> attchLst{get;set;}
    
    public  Integer hasAvailableDocItems;
    public Map<Id,String> NameMap{get; set;}
    public Boolean isSuccessOp{get; set;}
    
    public Boolean AccessGranted{get; set;}

    
    public Boolean getUserAccess() 
    {
        if(objAgr!=null) 
        {
            Id userId = UserInfo.getUserId();
            Boolean b1=False;
            Boolean b2=False;
            
            list<UserRecordAccess> uRaList= [Select RecordId, HasReadAccess, HasEditAccess From UserRecordAccess Where UserId =:userId And RecordId=:objAgr.Id];
            if(uRaList.size()>0)
            {
            UserRecordAccess uRa = new UserRecordAccess();
            uRa=uRaList.isEmpty()?null:uRaList[0];
            
            if(uRa.HasReadAccess && uRa.HasEditAccess)
                      b1=True;
              
            Schema.DescribeSObjectResult agrDocDescribe = Apttus__Agreement_Document__c.sObjectType.getDescribe();
               if(agrDocDescribe.isAccessible()  && agrDocDescribe.isCreateable())   
                      b2=True;
                    
            if(b1 && b2)  return True;
            }
           
        
        }

    return False; 
    }
    
    
    public void init() 
    {
        String recordId = ApexPages.currentPage().getParameters().get('id');
              if(recordId=='' || recordId==NULL  || validateId(recordId)==NULL || (String)Apttus__APTS_Agreement__c.sObjectType.getDescribe().getkeyPrefix()!=recordid.substring(0,3))
                   ApexPages.addMessage(new Apexpages.Message(ApexPages.Severity.ERROR,'Please run the page with an associated valid Agreement Id.'));           
            
    }
    
     
    public GFAgreementActivateController() 
    {
     
            attchLst=new List<String>();
            isSuccessOp=False;
             
             if(!String.isBlank(ApexPages.currentPage().getParameters().get('Id'))) 
             {
                 if(agrid==null)
                     if(validateId(ApexPages.currentPage().getParameters().get('Id'))!=null && (String)Apttus__APTS_Agreement__c.sObjectType.getDescribe().getkeyPrefix()==ApexPages.currentPage().getParameters().get('Id').substring(0,3))
                            agrid = ApexPages.currentPage().getParameters().get('Id');
                                   
                 if(agrid!=null)
                     if(objAgr ==null)
                            objAgr = [Select Id, Name,Apttus__FF_Agreement_Number__c  from Apttus__APTS_Agreement__c where Id =: agrid];         
                    
             }
             
             
            items=getItems1();
     }
     
     
     public GFAgreementActivateController(Apttus__APTS_Agreement__c param) 
    {
     
            attchLst=new List<String>();
            isSuccessOp=False;
             
             if(param!=NULL) 
             {
                 if(agrid==null)
                     if(validateId(param.id)!=null && (String)Apttus__APTS_Agreement__c.sObjectType.getDescribe().getkeyPrefix()==((String)param.id).substring(0,3))
                            agrid = param.id;
                                   
                 if(agrid!=null)
                     if(objAgr ==null)
                            objAgr = [Select Id, Name,Apttus__FF_Agreement_Number__c  from Apttus__APTS_Agreement__c where Id =: agrid];         
                    
             }
             
           items=getItems1();
            
     }
    
    public List<SelectOption> Items{get;set;} 
    
    public List<SelectOption> getItems1() 
    {
    NameMap=new Map<Id,String>();
    List<SelectOption> options=new List<SelectOption>();
    List<String> DocIds=new List<String>();
    String str;
    
    
    if(objAgr!=NULL)
    {
        
    for(Apttus__Agreement_Document__c agrDoc:[select Apttus__URL__c from Apttus__Agreement_Document__c where Apttus__Agreement__c= :objAgr.id  and isDeleted=False])
        {
            str=NULL;
            str=agrDoc.Apttus__URL__c.substringAfter(URL.getSalesforceBaseUrl().toExternalForm() +'/');
            if(!String.isBlank(str) && Pattern.compile('[a-zA-Z0-9]{15}|[a-zA-Z0-9]{18}').matcher(str).matches())
                DocIds.add(str);
            str=NULL;
            str=agrDoc.Apttus__URL__c.substringAfter('file=');
            if(!String.isBlank(str) && Pattern.compile('[a-zA-Z0-9]{15}|[a-zA-Z0-9]{18}').matcher(str).matches())
                DocIds.add(str);
        }
        
    
    
    
    
    
     for(Attachment attch: [select id,Name,LastModifiedDate,OwnerId,Body,ParentID   from Attachment where ParentId = :objAgr.id and IsPrivate=False  and isDeleted=False])
         {
             options.add(new SelectOption(attch.Id,attch.Name+' [' +attch.LastModifiedDate+' Attachment]'));
             NameMap.put(attch.id,attch.Name);
         }    
     for(Note n: [select id,Title,LastModifiedDate,Body     from Note where ParentId = :objAgr.id and IsPrivate=False  and isDeleted=False])
         {
             options.add(new SelectOption(n.Id,n.Title+' [' +n.LastModifiedDate+' Note]'));    
             NameMap.put(n.id,n.Title);
         }
         
     for(Document d: [select id,Name,LastModifiedDate,Body  from Document where id in :DocIds  and isDeleted=False])
         {
             options.add(new SelectOption(d.Id,d.Name+' [' +d.LastModifiedDate+' Document]'));    
             NameMap.put(d.id,d.Name);
         } 
     for(ContentDocumentLink  cdl: [select ContentDocumentId,ContentDocument.LatestPublishedVersionId,ContentDocument.Title,ContentDocument.ContentModifiedDate FROM ContentDocumentLink WHERE LinkedEntityId = :objAgr.id and isDeleted=False])
         {
             options.add(new SelectOption(cdl.ContentDocumentId,cdl.ContentDocument.Title+' [' +cdl.ContentDocument.ContentModifiedDate+' Feed Document]'));    
             NameMap.put(cdl.ContentDocumentId,cdl.ContentDocument.title);
             NameMap.put(cdl.ContentDocument.LatestPublishedVersionId,cdl.ContentDocument.title);
             
         }
         for(GoogleDoc gd: [select id,Name,LastModifiedDate,Url from GoogleDoc where ParentId =: objAgr.id  and isDeleted=False])
         {
             options.add(new SelectOption(gd.Id,gd.Name+' [' +gd.LastModifiedDate+' Google Doc]'));    
             NameMap.put(gd.id,gd.Name);
         }     
    
    }
         
    return options;

    }
    public boolean gotList=false;
    public Boolean gethasAvailableDocItems()
    {
        List<SelectOption> options=new List<SelectOption> ();

       
        hasAvailableDocItems=items.size();
        return (hasAvailableDocItems>0?True :False);
    }
    
    public PageReference returnToAgr()
    {
            PageReference pr=new PageReference('/'+objAgr.id); 
            pr.setRedirect(true);   
            return pr;  
       
    }
    
    
    
    
    public List<String> getattchLst() 
    {
            return attchLst;
    }
            
        public void setattchLst(List<String> attchLst) 
        {
            this.attchLst= attchLst;
        } 
        
        
        public PageReference doActivate() 
        {
        
           Savepoint sp = Database.setSavepoint();
           try
               {    
                   system.debug(limits.getQueries()+'soql start '+limits.getLimitQueries());
                    EnableContentSearch();
                   system.debug(limits.getQueries()+'soql start '+limits.getLimitQueries());
                    UpdateStatus();
                   system.debug(limits.getQueries()+'soql start '+limits.getLimitQueries());
                    createAuditTask();
                   system.debug(limits.getQueries()+'soql start '+limits.getLimitQueries());
                    isSuccessOp=True;
                    
               }catch(Exception e)
            {
                Database.rollback(sp);
                isSuccessOp=False;
                apexpages.Message msg = new Apexpages.Message(ApexPages.Severity.ERROR,e.getMessage());
                apexpages.addmessage(msg);
                
                //Adding code for exception framework
                ApplicationLogWrapper alw=new ApplicationLogWrapper();
                alw.source =GFAgreementActivateController.class.getName();
                alw.sourceFunction ='doActivate()';
                alw.ApplicationName='NDA Management';
                alw.referenceId =objAgr.id;
                alw.referenceInfo='Agreement';
                alw.logMessage ='Error Message='+e.getMessage()+' At Line Number='+e.getLineNumber()+' Stack Trace='+e.getStackTraceString();
                alw.debugLevel ='Error';
                alw.logCode =e.getTypeName();
                alw.ex=e.getCause();
                GlobalUtility.logMessage(alw);
                
            }
            
            
            if(isSuccessOp)
            {
            List<String>emailids=new List<String>();
            
            if(!String.isBlank(System.Label.Reviewer_Mailbox_for_Custom_NDA_Activation))
                {
                
                Pattern p = Pattern.compile('(?:[a-z0-9!#$%&\'*+/=?^_`{|}~-]+(?:\\.[a-z0-9!#$%&\'*+/=?^_`{|}~-]+)*|\"(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21\\x23-\\x5b\\x5d-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])*\")@(?:(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\\[(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?|[a-z0-9-]*[a-z0-9]:(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21-\\x5a\\x53-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])+)\\])' );
                Matcher matcher=p.matcher(System.Label.Reviewer_Mailbox_for_Custom_NDA_Activation);
                
                while(matcher.find())
                    { 
                    emailIds.add(matcher.group());
                    
                    }
                    
                matcher.reset();
                }   
             
                         
            if(emailids.size()>0)
                sendMailOnActivation(emailids,objAgr.id);
            }
            return NULL;

        }
        
        
        public PageReference AddUsertoGroupForLibraryAccess()
        {
                    Id Gid;
                    //using custom metadata type to store and retrieve repository ids
                    try
                    {
                    Gid=[select Variable_Value__c from Global_Variables__mdt where DeveloperName='Apttus_Library_Public_Group' limit 1][0].Variable_Value__c;
                    }catch(Exception e)
                    {
                        isSuccessOp=False;
                        apexpages.Message msg = new Apexpages.Message(ApexPages.Severity.ERROR,'Unable to acquire document repository access:'+e.getMessage());
                        apexpages.addmessage(msg);
            
            //Adding code for exception framework
            ApplicationLogWrapper alw=new ApplicationLogWrapper();
            alw.source =GFAgreementActivateController.class.getName();
            alw.sourceFunction ='doActivate()';
            alw.ApplicationName='NDA Management';
            alw.referenceId =objAgr.id;
            alw.referenceInfo='Agreement';
            alw.logMessage ='Error Message='+e.getMessage()+' At Line Number='+e.getLineNumber()+' Stack Trace='+e.getStackTraceString();
            alw.debugLevel ='Error';
            alw.logCode =e.getTypeName();
            alw.ex=e.getCause();
            GlobalUtility.logMessage(alw);
                        
                    }
                    
                    
                    if(Gid!=NULL && Group.SObjectType.getDescribe().getKeyPrefix()==String.valueOf(Gid).substring(0,3))
                    {
                        //adding the logged in user to the group which is subscribed to the library to automatically provide membership to the library and prevent access issues.
                        GroupMember GM = new GroupMember();
                        GM.GroupId = Gid;
                        GM.UserOrGroupId = UserInfo.getUserID();
                        Savepoint sv = Database.setSavepoint();
                        try
                        {
                            insert GM;
                        }
                        catch(Exception e)
                        {
                            AccessGranted=False;
                            Database.rollback(sv);
                            isSuccessOp=False;
                            apexpages.Message msg = new Apexpages.Message(ApexPages.Severity.ERROR,'Error in getting access to library:-'+e.getMessage());
                            apexpages.addmessage(msg);
              
              //Adding code for exception framework
              ApplicationLogWrapper alw=new ApplicationLogWrapper();
              alw.source =GFAgreementActivateController.class.getName();
              alw.sourceFunction ='doActivate()';
              alw.ApplicationName='NDA Management';
              alw.referenceId =objAgr.id;
              alw.referenceInfo='Agreement';
              alw.logMessage ='Error Message='+e.getMessage()+' At Line Number='+e.getLineNumber()+' Stack Trace='+e.getStackTraceString();
              alw.debugLevel ='Error';
              alw.logCode =e.getTypeName();
              alw.ex=e.getCause();
              GlobalUtility.logMessage(alw);
                            
                        }
                        AccessGranted=True;
                    }
                    return NULL; 
         }
        
        
        public Boolean getErrorsPresent()
        {
            return ApexPages.hasMessages(ApexPages.Severity.ERROR);
        }
        
        
        public void UpdateStatus()
        {
                objAgr.Apttus__Status__c='Activated';
                objAgr.Apttus__Status_Category__c='In Effect';
                objAgr.Apttus__Activated_By__c=UserInfo.getUserId();
                objAgr.Apttus__Activated_Date__c=System.Today();
                update objAgr;
        }
        
        public void createAuditTask()
        {
                //Audit task in activity log
                Task AuditTask=new Task(OwnerId=UserInfo.getUserId(),Subject='Activated Agreement',Description='Activated Agreement '+objAgr.Apttus__FF_Agreement_Number__c , ActivityDate=Date.today(),WhatId=objAgr.id,Status='Completed',Priority='Normal');
                insert AuditTask;
                
        }
        
        
        public void EnableContentSearch()
        {
            
            system.debug(limits.getQueries()+'soql start '+limits.getLimitQueries());
            Decimal attchsize = [select Maximum_Document_Size_Limit__c from Global_Platform_Limit__mdt limit 1][0].Maximum_Document_Size_Limit__c;   // custom metadata type
 
            Double ArtifactSize=(attchsize*1024*1024);   // this is the size of the attachment allowed. Anything bigger will be added to Chatter Files
            
            
            Set<String> attchSet=new Set<String>();
            String str;
            
            List<sObject> ToInsertList=new List<sObject>();
            List<Id> ToDelObjectRecords= new List<Id>();
            
            Map<String,Apttus__Agreement_Document__c> DocToAgrDocMap=new Map<String,Apttus__Agreement_Document__c>();
            for(Apttus__Agreement_Document__c agrDoc:[select Id,Apttus__URL__c from Apttus__Agreement_Document__c where Apttus__Agreement__c= :objAgr.id and isDeleted=False])
               {
                str=NULL;
                str=agrDoc.Apttus__URL__c.substringAfter('file=');
                
                if(!String.isBlank(str) && Pattern.compile('[a-zA-Z0-9]{15}|[a-zA-Z0-9]{18}').matcher(str).matches())
                    DocToAgrDocMap.put(str,agrDoc);
                 
                       
                str=NULL;    
                str=agrDoc.Apttus__URL__c.substringAfter(URL.getSalesforceBaseUrl().toExternalForm() +'/');
             
                if(!String.isBlank(str) && Pattern.compile('[a-zA-Z0-9]{15}|[a-zA-Z0-9]{18}').matcher(str).matches())    
                    DocToAgrDocMap.put(str,agrDoc);
                
                if(!Pattern.compile('[a-zA-Z0-9]{15}|[a-zA-Z0-9]{18}').matcher(str).matches() || String.isBlank(str))     
                    ToDelObjectRecords.add(agrDoc.Id);
               }
               
                              
               
          
            
            attchSet.addAll(attchLst);
            
            Id FolderId;
            Id LibraryId;
            
            
            //using custom metadata type to store and retrieve repository ids
            try
            {
            FolderId=[select Variable_Value__c from Global_Variables__mdt where DeveloperName='ApttusDocuments' limit 1][0].Variable_Value__c;
            }catch(Exception e)
            {
                isSuccessOp=False;
                apexpages.Message msg = new Apexpages.Message(ApexPages.Severity.ERROR,'Unable to acquire document repository access:'+e.getMessage());
                apexpages.addmessage(msg);
                
            }
            
             try
            {
            LibraryId=[select Variable_Value__c from Global_Variables__mdt where DeveloperName='Apttus_Library_Workspace' limit 1][0].Variable_Value__c;
            }catch(Exception e)
            {
                isSuccessOp=False;
                apexpages.Message msg = new Apexpages.Message(ApexPages.Severity.ERROR,'Unable to acquire library repository access:'+e.getMessage());
                apexpages.addmessage(msg);
                
            }
            
            
                           
            for(Attachment attch: [select id,Name,LastModifiedDate,OwnerId,Body,BodyLength,ParentID from Attachment where ParentId = :objAgr.id and IsPrivate=False and isDeleted=False])
                {
                    
                    if(!attchSet.contains(attch.Id) || attch==null || attch.BODY==null) continue;
                    if(attch.BodyLength>ArtifactSize || attch.Name.length()>255)
                    {
                        FeedItem post = new FeedItem();
                        post.ParentId = objAgr.id;
                        post.Body = 'Created by Activation process from Attachment ('+attch.Name+' '+attch.Id+')';
                        post.Type = 'ContentPost';
                        post.ContentData= attch.body;
                        post.ContentFileName = attch.Name;
                        post.Title = attch.Name;
                        ToInsertList.add(post);
                        ToDelObjectRecords.add(attch.id);
                       

                    }
                    if(attch.BodyLength<=ArtifactSize && attch.Name.length()<=255)
                    {

                    Document d=new Document();
                    d.Name=attch.Name;
                    d.Description='Created from Attachment ('+attch.Name+' '+attch.Id+')';
                    d.Keywords=attch.ParentID+' '+objAgr.Name;
                    d.FolderId=FolderId;
                    d.AuthorId = UserInfo.getUserId();
                    d.Body=attch.Body;
                    ToInsertList.add(d);
                    ToDelObjectRecords.add(attch.id);
                    }
                }
                
            for(Note n: [select id,Title,LastModifiedDate,Body from Note where ParentId = :objAgr.id and IsPrivate=False  and isDeleted=False])
                {
                    if(!attchSet.contains(n.Id) || n==null || n.body==NULL) continue;
                    Document d=new Document();
                    d.Name=n.Title;
                    if(!String.isBlank(n.Body))
                        d.Body=Blob.valueOf(n.Body);
                    d.FolderId=FolderId;
                    d.AuthorId =UserInfo.getUserId();
                    ToInsertList.add(d);
                    ToDelObjectRecords.add(n.id);
                }
                
                
             for(Document x: [select id,Name,LastModifiedDate,Body,BodyLength from Document where id in :DocToAgrDocMap.keySet() and isDeleted=False])
                {
                    if(!attchSet.contains(x.Id) || x.BodyLength>ArtifactSize || x.body==NULL || x==NULL) continue;
                    Document d=new Document();
                    d.Name=x.Name;
                    d.Body=x.Body;
                    d.FolderId=FolderId;
                    d.AuthorId =UserInfo.getUserId();
                    ToInsertList.add(d);
                    ToDelObjectRecords.add(x.id);
                    ToDelObjectRecords.add(DocToAgrDocMap.get(x.id).id);
                    
                    
                    
                }
                
               for(GoogleDoc gd: [select id,Name,LastModifiedDate,Url from GoogleDoc where ParentId =: objAgr.id  and isDeleted=False])
                {
                    if(!attchSet.contains(gd.Id) || gd==null || gd.Url==NULL) continue;
                    Document d=new Document();
                    d.Name=gd.Name;
                    if(!String.isBlank(gd.Url))
                        d.Body=Blob.valueOf(gd.Url);
                    d.FolderId=FolderId;
                    d.AuthorId =UserInfo.getUserId();
                    ToInsertList.add(d);
                    ToDelObjectRecords.add(gd.id);                    
                } 
           
                
                
              for(ID i : DocToAgrDocMap.keySet())
                      if(!NameMap.keyset().contains(i))  ToDelObjectRecords.add(DocToAgrDocMap.get(i).id);
                
                
            List<SObject> RelatedRecordList=new List<SObject>();    
            
            
            
            Map<Id,Id> Feed2Docaffl=new Map<Id,Id>();
            Feed2Docaffl=FeedAttachmentparser.FeedAttachmentMapper(NameMap.keySet());
            
            
            //fetching existing Doc IDs into a Set to prevent sharing exception when trying to add document
            Set<Id> CWDDocSet=new Set<Id>();
            for(ContentWorkspaceDoc CwdDoc:[SELECT ContentDocumentId FROM ContentWorkspaceDoc WHERE ContentWorkspaceId = :LibraryId])
                CWDDocSet.add(CwdDoc.ContentDocumentId);                
                             
               
            for(ContentDocumentLink  cdl: [select ContentDocumentId,ContentDocument.LatestPublishedVersionId,ContentDocument.Title,ContentDocument.FileExtension,ContentDocument.ContentModifiedDate FROM ContentDocumentLink WHERE LinkedEntityId = :objAgr.id and isDeleted=False])
            {
                if(!attchSet.contains(cdl.ContentDocumentId) || DocToAgrDocMap.keySet().contains(cdl.ContentDocument.LatestPublishedVersionId))continue;
                
                
                Apttus__Agreement_Document__c agrDoc=new Apttus__Agreement_Document__c();
                    if((cdl.ContentDocument.Title+'.'+cdl.ContentDocument.FileExtension).length()>80)
                        agrDoc.Name=(cdl.ContentDocument.Title+'.'+cdl.ContentDocument.FileExtension).substring(0,cdl.ContentDocument.Title.lastIndexOf('.')).substring(0,79-cdl.ContentDocument.Title.substring(cdl.ContentDocument.Title.lastIndexOf('.')+1).length())+'.'+cdl.ContentDocument.Title.substring(cdl.ContentDocument.Title.lastIndexOf('.')+1);
                    else
                        agrDoc.Name=cdl.ContentDocument.Title+'.'+cdl.ContentDocument.FileExtension;
                    
                    agrDoc.Apttus__Agreement__c=objAgr.id;
                    agrDoc.Apttus__Path__c=URL.getSalesforceBaseUrl().toExternalForm() +'/' + cdl.ContentDocument.LatestPublishedVersionId;
                    agrDoc.Apttus__URL__c=URL.getSalesforceBaseUrl().toExternalForm() +'/' + cdl.ContentDocument.LatestPublishedVersionId;
                    agrDoc.Apttus__Type__c='Final Electronic Copy';
                    agrDoc.Apttus__Comments__c=Feed2Docaffl.get(cdl.ContentDocument.LatestPublishedVersionId);
                    RelatedRecordList.add(agrDoc);
                    
                    
                    ContentWorkspaceDoc cwd=new ContentWorkspaceDoc();
                    cwd.ContentDocumentId=cdl.ContentDocumentId;
                    cwd.ContentWorkspaceId=LibraryId;
                    if(!CWDDocSet.contains(cwd.ContentDocumentId))RelatedRecordList.add(cwd);
                    
                
            }  
            
             
                
                  
                ToInsertList=SobjectListChunkReduce(ToInsertList);
                insert ToInsertList;
                
                
                List<ID> tmpList=new List<ID>();
                List<ID> FeedRelatedList=new List<ID>();
                for(SObject s: ToInsertList)
                {
                    if(s.getSobjectType()==Schema.FeedItem.getSobjectType())
                    {
                        FeedItem f=(FeedItem)s;
                        if(f.Type=='ContentPost')
                            tmpList.add(f.ID);
                    }
                        
                    
                    if(s.getSobjectType()==Schema.Document.getSobjectType())
                    {
                    Apttus__Agreement_Document__c agrDoc=new Apttus__Agreement_Document__c();
                    Document d=(Document)s;
                    
                    if(d.Name.length()>80)
                    agrDoc.Name=d.Name.substring(0,d.Name.lastIndexOf('.')).substring(0,79-d.Name.substring(d.Name.lastIndexOf('.')+1).length())+'.'+d.Name.substring(d.Name.lastIndexOf('.')+1);
                    else
                    agrDoc.Name=d.Name;
                    
                    agrDoc.Apttus__Agreement__c=objAgr.id;
                    agrDoc.Apttus__Path__c=URL.getSalesforceBaseUrl().toExternalForm() +'/' + d.id;
                    agrDoc.Apttus__URL__c=URL.getSalesforceBaseUrl().toExternalForm() +'/' + d.id;
                    agrDoc.Apttus__Type__c='Final Electronic Copy';
                    RelatedRecordList.add(agrDoc);
                    }
                }
                
               
                for(FeedItem f: [SELECT Id,Title,ParentID,RelatedRecordID From FeedItem where Type = 'ContentPost' and HasContent=True and id in :tmpList])
                        {
                            Apttus__Agreement_Document__c agrDoc=new Apttus__Agreement_Document__c();

                            //restricting Name to 80 characters due to Data Model limit
                            if(f.Title.length()>80)
                            agrDoc.Name=f.Title.substring(0,f.Title.lastIndexOf('.')).substring(0,79-f.Title.substring(f.Title.lastIndexOf('.')+1).length())+'.'+f.Title.substring(f.Title.lastIndexOf('.')+1);
                            else
                            agrDoc.Name=f.Title;    
                            agrDoc.Apttus__Agreement__c=f.ParentId;
                            agrDoc.Apttus__Path__c=URL.getSalesforceBaseUrl().toExternalForm() +'/' + f.RelatedRecordID ;
                            agrDoc.Apttus__URL__c=URL.getSalesforceBaseUrl().toExternalForm() +'/' + f.RelatedRecordID ;
                            FeedRelatedList .add(f.RelatedRecordID);
                            agrDoc.Apttus__Comments__c=f.id;
                            agrDoc.Apttus__Type__c='Final Electronic Copy';
                            RelatedRecordList.add(agrDoc);
                         }   
                 for(ContentDocumentLink  cdl: [select ContentDocumentId,ContentDocument.LatestPublishedVersionId FROM ContentDocumentLink WHERE LinkedEntityId = :objAgr.id and ContentDocument.LatestPublishedVersionId in :FeedRelatedList and isDeleted=False])          
                         {    
                        
                            ContentWorkspaceDoc cwd=new ContentWorkspaceDoc();
                            cwd.ContentDocumentId=cdl.ContentDocumentId;
                            cwd.ContentWorkspaceId=LibraryId;
                            RelatedRecordList.add(cwd);
                        }
                 
                 
                RelatedRecordList=SobjectListChunkReduce(RelatedRecordList);                
                dmlmethods(JSON.serialize(RelatedRecordList),'insert');
                dmlmethods(JSON.serialize(ToDelObjectRecords),'delete');
        }
        
        @Future
        public static void dmlmethods(String jsonList, String Opn){
            try{
                
                if(Opn =='insert'){
                    List<sObject> sList = (List<sObject>)JSON.deserialize(jsonList,List<sObject>.class);
                    Database.insert(sList);
                }
                if(Opn == 'delete'){
                    List<Id> sIdList = (List<Id>)JSON.deserialize(jsonList,List<Id>.class);
                    Database.delete(sIdList);
                }
            }catch(Exception e){
                ApplicationLogWrapper alw=new ApplicationLogWrapper();
                alw.source =GFAgreementActivateController.class.getName();
                alw.sourceFunction ='dmlmethods()';
                alw.ApplicationName='NDA Management';
                alw.referenceId ='agrId';
                alw.referenceInfo='Agreement';
                alw.logMessage ='Error Message='+e.getMessage()+' At Line Number='+e.getLineNumber()+' Stack Trace='+e.getStackTraceString();
                alw.debugLevel ='Error';
                alw.logCode =e.getTypeName();
                alw.ex=e.getCause();
                GlobalUtility.logMessage(alw);                    
            }
        }
        
        @Future
        public  static void sendMailOnActivation(List<String>emailids,Id agr)
        {
        
             Apttus__APTS_Agreement__c objAgr=[Select Id, 
                    Name,RecordTypeId,GF_Signatory_Region__c,TD_GN_Department_Name__c,
                    Apttus__FF_Agreement_Number__c,Apttus__Account__r.Name,RecordType.Name,Owner.Name,GF_Contract_End_Date__c,Owner.Email from Apttus__APTS_Agreement__c where Id =: agr];
             
             List<Messaging.SingleEmailMessage> msgs = new List<Messaging.SingleEmailMessage>();
             
             // Get the email template
             EmailTemplate emailTemp = [ SELECT id FROM  EmailTemplate WHERE  DeveloperName= 'General_Notification_for_Activation_of_an_NDA'];             
             Map<String,String> MergeFields=new Map<String,String>();
             Messaging.reserveSingleEmailCapacity(emailids.size());
             
             if(!String.isBlank(objAgr.GF_Signatory_Region__c))
                 MergeFields.put('{!Apttus__APTS_Agreement__c.GF_Signatory_Region__c}' ,objAgr.GF_Signatory_Region__c);  
                 
             if(!String.isBlank(objAgr.TD_GN_Department_Name__c))
                 MergeFields.put('{!Apttus__APTS_Agreement__c.TD_GN_Department_Name__c}',objAgr.TD_GN_Department_Name__c);  
             
                 
             if(!String.isBlank(objAgr.Name))
                 MergeFields.put('{!Apttus__APTS_Agreement__c.Name}' ,objAgr.Name);  
                 
             if(!String.isBlank(objAgr.Apttus__FF_Agreement_Number__c))
                 MergeFields.put('{!Apttus__APTS_Agreement__c.Apttus__FF_Agreement_Number__c}' ,objAgr.Apttus__FF_Agreement_Number__c);  
                 
             if(!String.isBlank(objAgr.Apttus__Account__c))
                 MergeFields.put('{!Apttus__APTS_Agreement__c.Apttus__Account__c}' ,objAgr.Apttus__Account__r.Name); 
                  
             if(!String.isBlank(objAgr.RecordType.Name))
                 MergeFields.put('{!Apttus__APTS_Agreement__c.RecordType}' ,objAgr.RecordType.Name);  
                 
             if(!String.isBlank(objAgr.Owner.Name))
                 MergeFields.put('{!Apttus__APTS_Agreement__c.OwnerFullName}' ,objAgr.Owner.Name); 
                  
             if(!String.isBlank(String.valueOf(objAgr.GF_Contract_End_Date__c)))
                 MergeFields.put('{!Apttus__APTS_Agreement__c.GF_Contract_End_Date__c}' ,String.valueOf(objAgr.GF_Contract_End_Date__c));   
                 
                 
             if(!String.isBlank(objAgr.Owner.Email))
                 MergeFields.put('{!Apttus__APTS_Agreement__c.OwnerEmail}' ,objAgr.Owner.Email);     
                 
             Messaging.SingleEmailMessage msg = EmailUtil.generateEmailTemplate(emailTemp.id,objAgr.id,'Notification for Activation of NDA.',emailids,null,MergeFields);
             
              try
                {
                      
                    if(msg != null)
                        {
                        List<String> DocIdentifiers=new List<String>();
                        Schema.DescribeSObjectResult r = Document.sObjectType.getDescribe();
                        Schema.DescribeSObjectResult s = ContentVersion.sObjectType.getDescribe();
                        
                        String keyPrefix = r.getKeyPrefix();
                        String keyPrfx = s.getKeyPrefix();
                        
                        for(Apttus__Agreement_Document__c agrDoc:[select Apttus__URL__c,Apttus__Comments__c from Apttus__Agreement_Document__c where Apttus__Agreement__c= :objAgr.id  and isDeleted=False])
                            {
                           
                               
                                
                               if(agrDoc.Apttus__URL__c.countMatches(keyPrefix)==1)
                               {
                                    Integer startIndex=agrDoc.Apttus__URL__c.indexOf(keyPrefix);
                                    Integer endIndex=startIndex+18;
                                  
                                    if(startIndex<=agrDoc.Apttus__URL__c.length() && endIndex<=agrDoc.Apttus__URL__c.length())
                                          
                                          {
                                              if(agrDoc.Apttus__URL__c.substring(startIndex,endIndex).isAlphanumeric())
                                                   DocIdentifiers.add(agrDoc.Apttus__URL__c.substring(startIndex,endIndex));
                                          }       
                                    else
                                          {
                                               startIndex=agrDoc.Apttus__URL__c.indexOf(keyPrefix);
                                               endIndex=startIndex+15;
                                               if(startIndex<=agrDoc.Apttus__URL__c.length() && endIndex<=agrDoc.Apttus__URL__c.length())
                                                  if(agrDoc.Apttus__URL__c.substring(startIndex,endIndex).isAlphanumeric())
                                                        DocIdentifiers.add(agrDoc.Apttus__URL__c.substring(startIndex,endIndex));
                                              
                                          }
                                 }  
                                 
                                 
                                if(agrDoc.Apttus__URL__c.countMatches(keyPrfx)==1)
                                   {
                                       if(agrDoc.Apttus__Comments__c.countMatches(FeedItem.sObjectType.getDescribe().getkeyPrefix())==1)
                                            DocIdentifiers.add(agrDoc.Apttus__Comments__c);     //using Apttus__Comments__c to identify the document  by storing the Feed Id as RelatedRecordIds are not filterable    
                                       else
                                       {
                                                Integer startIndex=agrDoc.Apttus__URL__c.indexOf(keyPrefix);
                                                Integer endIndex=startIndex+18;
                                              
                                                if(startIndex<=agrDoc.Apttus__URL__c.length() && endIndex<=agrDoc.Apttus__URL__c.length())
                                                      
                                                      {
                                                          if(agrDoc.Apttus__URL__c.substring(startIndex,endIndex).isAlphanumeric())
                                                               DocIdentifiers.add(agrDoc.Apttus__URL__c.substring(startIndex,endIndex));
                                                      }       
                                                else
                                                      {
                                                           startIndex=agrDoc.Apttus__URL__c.indexOf(keyPrefix);
                                                           endIndex=startIndex+15;
                                                           if(startIndex<=agrDoc.Apttus__URL__c.length() && endIndex<=agrDoc.Apttus__URL__c.length())
                                                              if(agrDoc.Apttus__URL__c.substring(startIndex,endIndex).isAlphanumeric())
                                                                    DocIdentifiers.add(agrDoc.Apttus__URL__c.substring(startIndex,endIndex));
                                                          
                                                      }
                                       }
                                
                                   }
                                
                            }
                            
                            
                            
                         
                        List<Messaging.Emailfileattachment> fileAttachments = new List<Messaging.Emailfileattachment>();
                        Integer TotalAttachmentSize=0;
                            for (Document d : [select id,Name,LastModifiedDate,Body,BodyLength,ContentType from Document where id in :DocIdentifiers])
                            {
                                    
                                  Messaging.Emailfileattachment efa = new Messaging.Emailfileattachment();
                                  efa.setFileName(d.Name);
                                  efa.setBody(d.Body);
                                  TotalAttachmentSize+=d.BodyLength;
                                  efa.setContentType(d.ContentType);
                                  efa.setInline(True);     
                                  fileAttachments.add(efa);
                            }
                            
                            
                            for (FeedItem  f: [select  ContentFileName,ContentData,ContentSize,ContentType FROM FeedItem WHERE ParentId= :objAgr.id and HasContent=True and Type='ContentPost' and Id in :DocIdentifiers])
                            {
                                    
                                  Messaging.Emailfileattachment efa = new Messaging.Emailfileattachment();
                                  efa.setFileName(f.ContentFileName);
                                  efa.setBody(f.ContentData);
                                  TotalAttachmentSize+=f.ContentSize;
                                  efa.setContentType(f.ContentType);
                                  efa.setInline(True);     
                                  fileAttachments.add(efa);
                            }
                            
                            
                            
                            
                        
                        
                            
                        msg.setFileAttachments(fileAttachments);
                        msg.setSenderDisplayName('ContractAdmin@globalfoundries.com'); 
                        msgs.add(msg); 
                        }                                                                                                                            
                       
                } catch (Exception e) 
                {
                    String CLM_ADMIN_MAIL_BATCH_NOTIFICATION = String.valueOf(EnvironmentVariable.get('CLM_ADMIN_MAIL_BATCH_NOTIFICATION'));  
                    String AdminMail= CLM_ADMIN_MAIL_BATCH_NOTIFICATION;
                    Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                    mail.setToAddresses(new String[] {AdminMail});
                    mail.setReplyTo(CLM_ADMIN_MAIL_BATCH_NOTIFICATION);
                    mail.setSenderDisplayName('NDA Mail Processing Class Exception');
                    mail.setSubject('Mail Processing Class');
                    mail.setPlainTextBody('The mail processing encountered following exception:-'+e.getMessage());
                    Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
                    
          //Adding code for exception framework
          ApplicationLogWrapper alw=new ApplicationLogWrapper();
          alw.source =GFAgreementActivateController.class.getName();
          alw.sourceFunction ='doActivate()';
          alw.ApplicationName='NDA Management';
          alw.referenceId =objAgr.id;
          alw.referenceInfo='Agreement';
          alw.logMessage ='Error Message='+e.getMessage()+' At Line Number='+e.getLineNumber()+' Stack Trace='+e.getStackTraceString();
          alw.debugLevel ='Error';
          alw.logCode =e.getTypeName();
          alw.ex=e.getCause();
          GlobalUtility.logMessage(alw);
        
                }        
         
        
        
        // Send the email
        if(msgs.size() > 0)
            if (!System.Test.isRunningTest()) 
                Messaging.sendEmail(msgs);
                                                                                          
                                                                                                                                                    

        }
        
        
        
        
        
        
        
 
    public String validateId(String Idparam) 
    {
        String id = String.escapeSingleQuotes(Idparam);
        if ((id.length() == 15 || id.length() == 18) && Pattern.matches('^[a-zA-Z0-9]*$',id)) 
            return id;
        
        return null;
    }
    
    
    
    public List<SObject> SobjectListChunkReduce(List <Sobject> setToUpdate) 
    {
   Integer SFDC_CHUNK_LIMIT = 10;

   // Developed this part due to System.TypeException: Cannot have more than 10 chunks in a single operation
   Map<Schema.SObjectType, List<Sobject>> sortedMapPerObjectType = new Map<Schema.SObjectType, List<Sobject>>();
   List<Sobject> FinalComboListForChunking = new List<Sobject>();
   for (Sobject obj : setToUpdate) 
   {
    Schema.SObjectType objType = obj.getSObjectType();
    if (!sortedMapPerObjectType.containsKey(objType)) 
    {
            sortedMapPerObjectType.put(objType, new List<Sobject>());
    }
    sortedMapPerObjectType.get(objType).add(obj);
   }
   while(sortedMapPerObjectType.size() > 0) 
   {
    // Create a new list, which can contain a max of chunking limit, and sorted, so we don't get any errors 
    List<Sobject> safeListForChunking = new List<Sobject>();
    List<Schema.SObjectType> keyListSobjectType = new List<Schema.SObjectType>(sortedMapPerObjectType.keySet());
    for (Integer i = 0;i<SFDC_CHUNK_LIMIT && !sortedMapPerObjectType.isEmpty();i++) 
    {
           List<Sobject> listSobjectOfOneType = sortedMapPerObjectType.remove(keyListSobjectType.remove(0)); 
           safeListForChunking.addAll(listSobjectOfOneType);
    }
    FinalComboListForChunking.addAll(safeListForChunking);
   }
   
   return FinalComboListForChunking;
}
    
   
}