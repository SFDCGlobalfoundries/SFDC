/*
Type Name: BnPRFQSRReadOnlyCtrl
Author: Poulami Saha
Project Name: DIW Step Down Track 2 (BnP) 
Created Date: 10/01/2017
Description: This class is call from 'Create SR' button on Decision page.
Test Class: 
Change History:Changed the query criteria to fetch BnP Finance quote Document records
*/
public class BnPRFQSRReadOnlyCtrl {
    public Request_Information__c rfqRecord { get; set; }
    //String reqInfoId;
    
    //Public attachment objAttachment{get; set;}
    Public List<attachment> finAttachList{get; set;}
    //Public Request_Information__c objApplicant{get; set;}
    Public BnP_Finance_Quote_Document__c bnpFinDoc{get; set;}
    Public transient List<BnP_Finance_Quote_Document__c> bnpFinanDocList{get; set;}
    Public List<Id> bnbFinDocIdList = new List<Id>();
    Public List<MyWrapper> wrapperList {get; set;}
    Public String rfqId {get; set;}
    
    public BnPRFQSRReadOnlyCtrl(ApexPages.StandardController ctrl) {
        rfqRecord = (Request_Information__c)ctrl.getRecord();
        
        rfqId = ApexPages.currentPage().getParameters().get('RFQId');
        
        if(rfqId == null || rfqId == '') 
            rfqId = rfqRecord.id;
            
        rfqRecord = queryRFQ(rfqId);
    }
    
    public Request_Information__c queryRFQ(String rfqId) {
        return [SELECT id, name, RFQ_Request_Number__c, Access_Preferred_Fab_Location_Table__c, Request_Type__c, Wafer_Fab_sourcing_location__c, Client_preferred_Wafer_Fab_from_FMS__c, If_other_please_specify__c, Date_of_Request__c, Support_position_due_date__c, Backup_Request_Catcher__c, Primary_Request_Catcher__c, Request_comments__c, Request_status__c, Quote_Status__c, Access_Sizing_Spreadsheet_Template__c FROM Request_Information__c where id = :rfqId];
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
        bnpFinanDocList = [Select id, Name, Document_Business_Type__c from BnP_Finance_Quote_Document__c where BnP_Finance_Quote_Document__c = :rfqId and Is_SQT_sheet__c = true and Is_Financial_Document__c = false and Is_Costing_Document__c = false];
        
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
                        myWrap.bnpSQTSheetRec = bnpFinDoc;
                        wrapperList.add(myWrap);
                        
                }
            }
        }
        return wrapperList;
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