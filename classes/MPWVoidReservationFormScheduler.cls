/*
Author: Shyam Ravindra Nair
Description: Apex class will auto-void Reservation forms if
1) Reservation Form Status is Draft and Reservation Close Date is less than today.
2) Reservation Form is under Pending status and Other Participant's Date is less than today.
History:
SNair     08182015     - code creation.
SNair     10192015     - modifield query logic.
Kanishk Singh: MPW-PP117 -Remove email communication to customer when the reservation form is auto void
*/

global class MPWVoidReservationFormScheduler implements Schedulable {

    global void execute(SchedulableContext SC){
        List<MPW_Reservation__c> mpwresfList = new List<MPW_Reservation__c>();
        List<MPW_Reservation__c> tempList = new List<MPW_Reservation__c>();
        date tempdate = date.today().addMonths(-1);
        String soql = 'select Id, Form_Status__c from MPW_Reservation__c';
        
        //Kanishk: needs to get form status(Pending Internal Budget Owner Approval,Pending FAE Review,Draft) detail from custom setting
        soql += ' where DAY_ONLY(Customer_Tapeout_Date__c) =: tempdate and Form_Status__c IN (\'Pending Internal Budget Owner Approval\',\'Pending FAE Review\',\'Draft\')';
       
        tempList = database.query(soql);
        
        if(!tempList.isEmpty()){
            for(MPW_Reservation__c temp: tempList){
            	/*Kanishk Singh: As per business , Auto void is not a Approval Rejection , only need to change form status as Void*/
               /* if(temp.Form_Status__c.startsWith('Pending')){
                    Approval.ProcessWorkitemRequest PWR = new Approval.ProcessWorkitemRequest();
                    PWR.setComments('Rejected as the Form is Voided');
                    PWR.setAction('Reject');
                    Id workItemId = getWorkItemId(temp.Id);
                    PWR.setWorkitemId(workItemId);
                    Approval.ProcessResult result =  Approval.process(PWR);
                }*/
                
                /*Kanishk : end*/
                
                temp.Form_Status__c = 'Void';
                temp.SendPurchaseOrderReminder__c = false;
                temp.SendQuotation_Close_CancellationReminder__c = false;
                temp.SendSalesOrderNumberReminder__c = false;
                mpwresfList.add(temp);
            }
            
            if(!mpwresfList.isEmpty()){
                update mpwresfList;
            }
        }
    }
    
   /* public Id getWorkItemId(Id targetObjectId){
        Id retVal = null;
        for(ProcessInstanceWorkitem workItem: [select p.Id from ProcessInstanceWorkitem p where p.ProcessInstance.TargetObjectId =: targetObjectId]){
            retVal = workItem.Id;
        }
        return retVal;
    }*/
    
    
}