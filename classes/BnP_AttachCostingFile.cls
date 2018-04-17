/*
Type Name: BnP_AttachCostingFile
Author: Poulami Saha
Project Name: DIW Step Down Track 2 (BnP) 
Created Date: 19/04/2017
Description: This class serves controller for BnPAttachCostingFileInlineVF page.
Test Class: 
Change History:
*/
Public class BnP_AttachCostingFile{
    Public attachment objAttachment{get; set;}
    Public List<attachment> finAttachList{get; set;}
    Public Request_Information__c objApplicant{get; set;}
    Public BnP_Finance_Quote_Document__c bnpFinDoc{get; set;}
    Public transient List<BnP_Finance_Quote_Document__c> bnpFinanDocList{get; set;}
    Public Request_Information__c reqRecord{get; set;}
    Public Set<Id> bnbFinDocIdList = new Set<Id>();
    Public List<MyWrapper> wrapperList {get; set;}
    
    /**
    *  Constructor of this Controller 
    *  @name <BnP_SQTSheetAttachment>
    *  @param <ApexPages.StandardController> 
    *  @return <NA> - <>
    *  @throws exception-<exception description>
    */
    Public BnP_AttachCostingFile(apexpages.standardcontroller stdCon){
        if (objAttachment == null){
            objAttachment = new Attachment();
        }
        bnpFinDoc = new BnP_Finance_Quote_Document__c();
        this.objApplicant = (Request_Information__c)stdCon.getRecord();
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
        bnpFinanDocList = [Select id, Name, Document_Business_Type__c from BnP_Finance_Quote_Document__c where BnP_Finance_Quote_Document__c = :objApplicant.id and Is_Costing_Document__c = true and Is_SQT_sheet__c = false and Is_Financial_Document__c = false];
        
        for(BnP_Finance_Quote_Document__c bnpFinDoc : bnpFinanDocList){
            bnbFinDocIdList.add(bnpFinDoc.id);
        }
        finAttachList = [Select id, Name, ContentType, BodyLength, Description, ParentId from attachment where ParentId IN :bnbFinDocIdList];
        
        for(BnP_Finance_Quote_Document__c bnpFinDoc : bnpFinanDocList){
            for(Attachment attFile : finAttachList){
                if(bnpFinDoc.id == attFile.ParentId){
                        MyWrapper myWrap = new MyWrapper();
                        myWrap.attRec = attFile;
                        myWrap.bnpSQTSheetRec = bnpFinDoc;
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
            bnpFinDoc.Is_Costing_Document__c = true;
            try {
                insert bnpFinDoc;
            }catch (DMLException excp) {
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Error inserting'));
                GlobalUtility.logMessage('Error','BnP_Extattachfile','saveApplicant','','Exception while inserting BnP Finance Quote Document',String.valueof(excp.getMessage()),'','BnP',excp,0);
            }
            objAttachment.ParentId = bnpFinDoc.id;
            try {
                insert objAttachment;
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,'Attachment uploaded successfully'));
            }catch (DMLException excp) {
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Error uploading attachment'));
                GlobalUtility.logMessage('Error','BnP_Extattachfile','saveApplicant','','Exception while inserting attachment',String.valueof(excp.getMessage()),'','BnP',excp,0);
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
        public BnP_Finance_Quote_Document__c bnpSQTSheetRec {get; set;}
       
    }
}