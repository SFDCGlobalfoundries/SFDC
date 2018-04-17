public class NWRFormController{
    
    public Non_Wafer_Revenue__c nwrObj     {get;set;}
    public String recordTypeName           {get;set;}
    public List<Attachment> attachmentList {get;set;}
    public List<Note> noteList {get;set;}
    public Boolean isClone {get;set;}
    
    public NWRFormController(ApexPages.StandardController controller) {
        
        try{
            isClone = false;
            
            if( ApexPages.currentPage().getParameters().get('clone') != null && ApexPages.currentPage().getParameters().get('clone').equals('1')){
                
                isClone = true;
            }
            
            recordTypeName = 'Master';
            
            String recordTypeId = ApexPages.currentPage().getParameters().get('RecordType');
            
            if(recordTypeId != null){
                
                List<RecordType> recordTypeList = [SELECT id, Name from RecordType where Id = :recordTypeId];
                
                if(recordTypeList != null 
                   && recordTypeList.size() > 0
                   && recordTypeList[0].Name != null){
                    
                    recordTypeName = recordTypeList[0].Name;
                }
            }
            
            String deviceId = ApexPages.currentPage().getParameters().get('Did');
            
            Device__c deviceObject;
            
            if(deviceId != null){
            
                deviceObject = [SELECT id, Opportunity2__c FROM Device__c WHERE id =: deviceId];
            }
            
            nwrObj = new Non_Wafer_Revenue__c();
             
            nwrObj = (Non_Wafer_Revenue__c)controller.getRecord();
           
            if(nwrObj.Id != null){
                
                nwrObj = [SELECT Id, Non_Wafer_Revenue_Type__c,Option__c, Status__c, Sub_Type__c, MPW_Train__c, NRE_Billing_Milestone__c, Comments_for_N__c, Opportunity__c, Comments__c, Device__c, Booking_Date__c, Billing_Date__c, Booking_Revenue__c, Billing_Revenue__c, Actual_Date__c, Quote__c, Actual_Revenue__c, PO_Receipt_Date__c,Check_box__c,Total_Revenue__c, Sales_Order__c, PO__c, RecordTypeId, RecordType.Name FROM Non_Wafer_Revenue__c WHERE Id = :nwrObj.Id];
                
                if(nwrObj.RecordType.Name != null){
                    
                    recordTypeName = nwrObj.RecordType.Name;
                }
            }
            else if(deviceObject != null){
                
                nwrObj.Device__c = deviceObject.id;
                
                if(deviceObject.Opportunity2__c != null){
                    
                    nwrObj.Opportunity__c = deviceObject.Opportunity2__c;
                }
            }
            
            if(isClone){
                
                Non_Wafer_Revenue__c tempNwrObj = new Non_Wafer_Revenue__c();
                
                if(nwrObj.Non_Wafer_Revenue_Type__c != null){
                    
                    tempNwrObj.Non_Wafer_Revenue_Type__c = nwrObj.Non_Wafer_Revenue_Type__c;
                }
                 if(nwrObj.NRE_Billing_Milestone__c != null){
                    
                    tempNwrObj.NRE_Billing_Milestone__c = nwrObj.NRE_Billing_Milestone__c;
                }
                 if(nwrObj.Sub_Type__c!= null){
                    
                    tempNwrObj.Sub_Type__c= nwrObj.Sub_Type__c;
                }
                if(nwrObj.Status__c != null){
                    
                    tempNwrObj.Status__c = nwrObj.Status__c;
                }
                
                if(nwrObj.Opportunity__c != null){
                    
                    tempNwrObj.Opportunity__c = nwrObj.Opportunity__c;
                }
                
                if(nwrObj.RecordTypeId != null){
                    
                    tempNwrObj.RecordTypeId = nwrObj.RecordTypeId;
                }    
                nwrObj = tempNwrObj;
            }
        }
        catch(Exception e){
            
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, e.getMessage() + ', ' +  e.getLineNumber() + ', ' + e.getStackTraceString() ) );
        }
    }
    
    public PageReference save(){
        
        PageReference pageRef; 
        
        try{
            
            upsert nwrObj;
            pageRef = New PageReference('/' + nwrObj.id);
        }
        catch(Exception e){
           
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, e.getMessage() + ', ' +  e.getLineNumber() + ', ' + e.getStackTraceString() ) );
        }
        
        return pageRef;
    }
}