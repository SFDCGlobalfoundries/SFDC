/*
Type Name: BnP_AttachQuote
Author: Poulami Saha
Project Name: DIW Step Down Track 2 (BnP) 
Created Date: 05/10/2016
Description: This class serves controller for BnPAttachQuoteInlineVF page.
Test Class: 
Change History:Changed the query criteria to fetch BnP Finance quote Document records
*/
Public class BnP_AttachQuote{
    Public attachment objAttachment{get; set;}
    Public List<attachment> finAttachList{get; set;}
    Public Request_Information__c objApplicant{get; set;}
    Public BnP_Finance_Quote_Document__c bnpFinDoc{get; set;}
    Public  List<BnP_Finance_Quote_Document__c> bnpFinanDocList{get; set;}
    Public List<Id> bnbFinDocIdList = new List<Id>();
    public List<MyWrapper> wrapperList {get; set;}
    Public String userProfileName{get; set;}
    
    
    /**
    *  Constructor of this Controller 
    *  @name <bnpAttachQuote>
    *  @param <ApexPages.StandardController> 
    *  @return <NA> - <>
    *  @throws exception-<exception description>
    */
    Public BnP_AttachQuote(apexpages.standardcontroller stdCon){
        if (objAttachment == null){
            objAttachment = new Attachment();
        }
        bnpFinDoc = new BnP_Finance_Quote_Document__c();
        this.objApplicant = (Request_Information__c)stdCon.getRecord();
        userProfileName = [select u.Profile.Name, id, UserType from User u where u.id = :Userinfo.getUserId()].Profile.Name;
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
    *  The getter method used in the page to display BnP Finance Quote Document, Attachment
    *  @name <getwrapperList>
    *  @param <NA>
    *  @return <List <MyWrapper>>
    *  @throws exception-<exception description>
    */
    Public List <MyWrapper> getwrapperList(){
        wrapperList = new List<MyWrapper>();
        bnpFinanDocList = [Select id, Name, createdDate, Quote_Attachment_Date__c from BnP_Finance_Quote_Document__c where BnP_Finance_Quote_Document__c = :objApplicant.id and Is_Financial_Document__c = false and Is_SQT_sheet__c = false and Is_Costing_Document__c = false];
        
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
                        myWrap.bnpQuoteAttRec = bnpFinDoc;
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
    public void saveApplicant(){
        bnpFinDoc = new BnP_Finance_Quote_Document__c();
        bnpFinDoc.BnP_Finance_Quote_Document__c = objApplicant.id;
        bnpFinDoc.createdDate = Datetime.newInstance(system.now().year(),system.now().month(),system.now().day());
        bnpFinDoc.Quote_Attachment_Date__c = bnpFinDoc.createdDate.format('dd/MMM/yyyy');
        try {
            insert bnpFinDoc;
        }catch (DMLException excp) {
            //ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Error uploading attachment'));
            GlobalUtility.logMessage('Error','BnP_AttachQuote','saveApplicant','','Exception while inserting BnP Finance Quote Document',String.valueof(excp.getMessage()),'','BnP',excp,0);
        }
       
        objAttachment.ParentId = bnpFinDoc.id;
        try {
            insert objAttachment;
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,'Attachment uploaded successfully'));
        }catch (DMLException excp) {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Error uploading attachment'));
            GlobalUtility.logMessage('Error','BnP_AttachQuote','saveApplicant','','Exception while inserting attachment',String.valueof(excp.getMessage()),'','BnP',excp,0);
        } finally {
            objAttachment = new Attachment(); 
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
        public BnP_Finance_Quote_Document__c bnpQuoteAttRec {get; set;}
    }
}