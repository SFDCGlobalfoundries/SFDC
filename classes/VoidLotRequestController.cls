/**
* Author        :   Ravikiran Nadella
* Description   :  this class has Logic to exceute from Void button 
related to Lot Service request object .
* History       :
Initials        Date                Description
-----------------------------------------------------------------------------------------

RNadella        11/09/2015          Created the class                                   
**/

public  class VoidLotRequestController {
    public Lot_Request__c lsr {get;set;}
    public id  recId;
    PageReference pageRef= null;
    public VoidLotRequestController(ApexPages.StandardController controller) {
        lsr=(Lot_Request__c)controller.getRecord();
        recId=lsr.id;
        
        
    }
    
    /* This method has a logic to update the record to Closed -void 
when void button upon click */
    public pageReference recallApproval(){
        If( lsr.Reason_Cancelled_by_Customer__c<>null){
            list<processInstanceWorkitem> pwit =[SELECT Id from ProcessInstanceWorkitem 
                                                 WHERE ProcessInstance.TargetObjectId =:recId
                                                 AND ProcessInstance.Status = 'Pending'];
            if(pwit<>null && !pwit.isEmpty()){
                
                
                Approval.ProcessWorkitemRequest pwr = new Approval.ProcessWorkitemRequest();
                pwr.setComments('Record has been Closed-void using Void button ');
                pwr.setAction('Removed');
                pwr.setWorkitemId(pwit[0].id);
                Approval.ProcessResult result = Approval.process(pwr);
                
            }
            
            Lot_Request__c lreq = new Lot_Request__c (id=recId);
            lreq.Stage__c = 'Closed - Void'; 
            lreq.Reason_Cancelled_by_Customer__c=lsr.Reason_Cancelled_by_Customer__c;
            update lreq;
            
            
            list<Lot_Request__c>lrList= new list<Lot_Request__c> ();
            lrList.add(lreq);
            LotApprovalProcessUtil.sendEmailtoApprovers(lrList);
            
            
            pageRef = new PageReference('/'+lreq.id);
            pageRef.setRedirect(true);
            
        } else {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Please enter the Reason before you proceed'));
            
        }
        return pageRef;
    }  
    
    
    public PageReference cancel(){
        PageReference  pageReff = new PageReference('/'+lsr.id);
        pageReff.setRedirect(true);
        
        return pageReff;
    }    
    
}