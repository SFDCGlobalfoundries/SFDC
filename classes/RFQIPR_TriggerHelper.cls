/**
@Author < Nikhil bajaj >
@name <RFQIPR_TriggerHelper>
@CreateDate < 1/5/2016 >
@Description < This Handler class is handling the after insert,after update and after delete event of AcceptedIPRequest>
@Version <1.0>
*/
public class RFQIPR_TriggerHelper {
    List<Id> RFQ_ID = new List<Id>();
    List<Id> IPR_ID = new List<Id>();
    
    // method invoked on after insert and after update event
    // method to update AcceptedIPR when RFQ_IPR is created/updated
      
    public void upsertAcceptedIPR() {
        List<RFQ__c> rfq_updatelist=new List<RFQ__c>();
        For(RFQ_IPR__c rfqipr_newrec :(List<RFQ_IPR__c>) Trigger.new){
            RFQ_ID.add(rfqipr_newrec.RFQ__c);
            IPR_ID.add(rfqipr_newrec.IP_Request__c);
        }
            
            String commaSepratedList='';

            //getting ip request name with respect to rfqipr(accepted by customer)
            List<RFQ_IPR__c> IPR_Name = [select IP_Request__r.Name  from RFQ_IPR__c where RFQ__C in:RFQ_ID and AcceptedbyCustomer__c = True];

            //iterating ipr names and concatinating them
            for(RFQ_IPR__c str: IPR_Name){
                commaSepratedList += str.IP_Request__r.Name + ',' ;
            }
            List<RFQ__c> rfqlist= [SELECT Name FROM RFQ__c  WHERE id =: RFQ_ID];

            for(RFQ__c rfq :rfqlist){
                rfq.Accepted_IPR__c=commaSepratedList;
                rfq_updatelist.add(rfq);
            }
                
       
        try{
            update rfq_updatelist;
        }catch (Exception excp) {
            ApexPages.addMessages(excp);
            GlobalUtility.logMessage('Error','AcceptedIPRequestTriggerHelper','upsertAcceptedIPR','','Exception while inserting/updating rfq_ipr Record records',String.valueof(excp.getMessage()),'','IP Request',excp,0);
                  
         } 
         
    }

    // method invoked on after delete event
    // method to update AcceptedIPR field on rfq when RFQ_IPR is deleted
    public void updateAcceptedIPR() {
        List<RFQ_IPR__c> IPR_Name;
        List<RFQ__c> rfq_updatelist = new List<RFQ__c>();
        For(RFQ_IPR__c rfqipr_newrec :(List<RFQ_IPR__c>) Trigger.old){
            RFQ_ID.add(rfqipr_newrec.RFQ__c);
            IPR_ID.add(rfqipr_newrec.IP_Request__c);
            
        }
        String commaSepratedList='';
        IPR_Name = [select IP_Request__r.Name  from RFQ_IPR__c where  RFQ__C in:RFQ_ID and AcceptedbyCustomer__c = True];
        for(RFQ_IPR__c str: IPR_Name){
            commaSepratedList += str.IP_Request__r.Name + ',' ;
        }

        List<RFQ__c> rfqlist= [SELECT Name FROM RFQ__c  WHERE id =: RFQ_ID];

        for(RFQ__c rfq :rfqlist){
            rfq.Accepted_IPR__c=commaSepratedList;
            rfq_updatelist.add(rfq);
        }try{
            update rfq_updatelist;
         }catch (Exception excp) {
           ApexPages.addMessages(excp);
           GlobalUtility.logMessage('Error','AcceptedIPRequestTriggerHelper','updateAcceptedIPR','','Exception while deleteing rfq_ipr Record records',String.valueof(excp.getMessage()),'','IP Request',excp,0);
                 
         } 
    }
}