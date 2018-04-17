public class LotRequest_RecordTypeUpdate{
    //Commenting the class for Deletion from Production
    public LotRequest_RecordTypeUpdate(){
         
    }
        
    /*
    Lot_Request__c lotReq = new Lot_Request__c();
     
    public LotRequest_RecordTypeUpdate(ApexPages.StandardController controller){
        lotReq = (Lot_Request__c)controller.getRecord();
    }
    public pageReference changeRecordType(){
        
        Id LotRecordTypeId= Schema.SObjectType.Lot_Request__c.getRecordTypeInfosByName().get('Pricing Review Lot Request').getRecordTypeId();
        lotReq.RecordTypeId = LotRecordTypeId;
        lotReq.Stage__c = 'Submitted for Repricing';
        database.update(lotReq);
        
        PageReference pageRef = new PageReference('/'+lotReq.id);
        pageRef.setRedirect(true);
        return pageRef;
    }
    */
}