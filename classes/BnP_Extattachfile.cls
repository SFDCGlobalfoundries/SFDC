/*
Type Name: BnP_Extattachfile
Author: Poulami Saha
Project Name: DIW Step Down Track 2 (BnP) 
Created Date: 18/08/2016
Description: This class serves controller for BnPRIInlineVF page.
Test Class: 
Change History:Changed the query criteria to fetch BnP Finance quote Document records
*/
Public class BnP_Extattachfile{
    Public attachment objAttachment{get; set;}
    Public List<attachment> finAttachList{get; set;}
    Public Request_Information__c objApplicant{get; set;}
    Public BnP_Finance_Quote_Document__c bnpFinDoc{get; set;}
    Public transient List<BnP_Finance_Quote_Document__c> bnpFinanDocList{get; set;}
    Public List<Id> bnbFinDocIdList = new List<Id>();
    Public String userProfileName{get; set;}
    public List<MyWrapper> wrapperList {get; set;}
    
    Public Boolean IsSaveVisible {get;set;}
    Public Boolean IsAttachVisible {get;set;}
    Public Boolean AttachfileFields{get;set;}
    
    /**
    *  Constructor of this Controller 
    *  @name <extattachfile>
    *  @param <ApexPages.StandardController> 
    *  @return <NA> - <>
    *  @throws exception-<exception description>
    */
    Public BnP_Extattachfile(apexpages.standardcontroller stdCon){
        if (objAttachment == null){
            objAttachment = new Attachment();
        }
        //if (bnpFinDoc == null){
            bnpFinDoc = new BnP_Finance_Quote_Document__c();
        //}
        this.objApplicant = (Request_Information__c)stdCon.getRecord();
        userProfileName = [select u.Profile.Name, id, UserType from User u where u.id = :Userinfo.getUserId()].Profile.Name;
        System.debug('userProfileName: ' +userProfileName);
        IsSaveVisible = false;
        IsAttachVisible = true;
        AttachfileFields = false;
    }
    
    /**
    *  The Purpose of this method is to display BnP Finance Quote Document, Attachment 
    *  @name <displatAttachment>
    *  @param <NA> 
    *  @return <Pagereference>
    *  @throws exception-<exception description>
    */
    public pageReference displatAttachment(){
        getwrapperList();
        return null;
    }
    
    /**
    *  @Description <The purpose of this method is to edit the Service data> 
    *  @name <attachfile>
    *  @param <> <>
    *  @return <> - <>
    *  @throws exception-<>
    */   
    public pagereference attachfile()
    {
        
        IsSaveVisible = true;
        IsAttachVisible = false;
        AttachfileFields = true;
        return null;
    } 
    
    /**
    *  The getter method used in the page to display BnP Finance Quote Document, Attachment
    *  @name <getwrapperList>
    *  @param <NA>
    *  @return <List <MyWrapper>>
    *  @throws exception-<exception description>
    */
    Public List <MyWrapper> getwrapperList(){
        wrapperList = new List<MyWrapper>();
        bnpFinanDocList = [Select id, Name, Document_Business_Type__c from BnP_Finance_Quote_Document__c where BnP_Finance_Quote_Document__c = :objApplicant.id and Is_Financial_Document__c = true and Is_SQT_sheet__c = false and Is_Costing_Document__c = false];
        
        for(BnP_Finance_Quote_Document__c bnpFinDoc : bnpFinanDocList){
            bnbFinDocIdList.add(bnpFinDoc.id);
        }
        finAttachList = [Select id, Name, ContentType, BodyLength, Description, ParentId from attachment where ParentId IN :bnbFinDocIdList];
        
        for(BnP_Finance_Quote_Document__c bnpFinDoc : bnpFinanDocList){
            for(Attachment attFile : finAttachList){
                if(bnpFinDoc.id == attFile.ParentId){
                        MyWrapper myWrap = new MyWrapper();
                        System.debug('Inside if');
                        myWrap.attRec = attFile;
                        myWrap.bnpFinAttRec = bnpFinDoc;
                        wrapperList.add(myWrap);
                        
                }
            }
        }
        return wrapperList;
    }
    
    /**
    *  The Purpose of this method is to save BnP Finance Quote Document, Attachment 
    *  @name <saveApplicant>
    *  @param <NA> 
    *  @return <Void>
    *  @throws exception-<GlobalUtility.logMessage was called to capture the exception>
    */
    Public void saveApplicant(){
            bnpFinDoc.BnP_Finance_Quote_Document__c = this.objApplicant.id;
            bnpFinDoc.Is_Financial_Document__c = true;
            //IsSaveVisible = false;
            //IsAttachVisible = true;
            //AttachfileFields = false;
            try {
                insert bnpFinDoc;
            }catch (DMLException excp) {
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Error inserting'));
                GlobalUtility.logMessage('Error','BnP_Extattachfile','saveApplicant','','Exception while inserting BnP Finance Quote Document',String.valueof(excp.getMessage()),'','BnP',excp,0);
                //return null;
            }

            objAttachment.ParentId = bnpFinDoc.id;
            //objAttachment.description = bnpFinDoc.Name;
            try {
                system.debug('File Name: ' +objAttachment.name);
                system.debug('File Body: ' +objAttachment.body);
                insert objAttachment;
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,'Attachment uploaded successfully'));
            }catch (DMLException excp) {
                system.debug('Exception msg: ' +excp.getMessage());
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Error uploading attachment'));
                GlobalUtility.logMessage('Error','BnP_Extattachfile','saveApplicant','','Exception while inserting attachment',String.valueof(excp.getMessage()),'','BnP',excp,0);
                //return null;
            } finally {
                objAttachment = new Attachment(); 
                bnpFinDoc = new BnP_Finance_Quote_Document__c();
            }


        
        getwrapperList();
    }
    
    /**
    @name <MyWrapper>
    @Description <This class is handle mutliple object instances>
    @Version <>
    @reference <>
    */
    public class MyWrapper
    {
        public Attachment attRec {get; set;}
        public BnP_Finance_Quote_Document__c bnpFinAttRec {get; set;}
       
    }
}