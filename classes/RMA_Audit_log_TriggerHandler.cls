/**
 * Author: Surendranadh Nune
 * Company: GlobalFoundries,India
 * Project: Return Material Authorization
 * Description: This class acts as a helper class for handling trigger events on RMA_Audit_log__c object.
 * History:
 *    SurendranadhNune 23122015  -   Created.
 *   Jabee Removed With shareing in line 11-25-05-2017
 *                            
 **/
public class RMA_Audit_log_TriggerHandler{
    
    /* This method is used to clear the Queue-in / Queue-out fields when RMA is rejected.
    *  This logic could not be written in RMA trigger because, as Queue-out time is captured
    *  through field update, we can't reset the queue out time in the same context. So, we are 
    *  clearing the fields when we are capturing the cycle time history.      
    */
    public static void updateRejectedRMA(Set<Id> rejectedRMASet){
        List<RMA__c> rmasForUpdate = new List<RMA__c>();
        for(Id rmaId : rejectedRMASet){
            RMA__c rmaObj = new RMA__c(id= rmaId);
            rmaObj.Queue_in_Time_for_Fab_Validation__c = rmaObj.Queue_in_Time_for_Finance_Approval__c = rmaObj.Queue_in_Time_for_Regional_Approval__c = 
            rmaObj.Queue_out_Time_for_CSR_Submission__c = rmaObj.Queue_out_Time_for_Fab_Validation__c =
            rmaObj.Queue_out_Time_for_Finance_Approval__c = rmaObj.Queue_out_Time_for_Regional_Approval__c = rmaObj.Queue_out_Time_for_Wafer_Acknowledgement__c =
            rmaObj.Queue_in_Time_for_Wafer_Acknowledgement__c = rmaObj.Queue_in_Time_for_CQ_Validation__c = rmaObj.Queue_out_Time_for_CQ_Validation__c = NULL;
            rmaObj.Extension_for_Fab_validation_required__c = false;
            rmaObj.Extension_Status__c = rmaObj.Extension_Approve_Reject_Reason__c = rmaObj.Extension_Reason__c = NULL;
            if(rmaObj.Cycle_Time_for_Fab_Validation__c != NULL && rmaObj.Number_of_Days__c != NULL){
                rmaObj.Cycle_Time_for_Fab_Validation__c -= rmaObj.Number_of_Days__c;
            }
            rmaObj.Number_of_Days__c = NULL;
            rmaObj.Queue_in_Time_for_CSR_Submission__c = Datetime.now();
            rmaObj.Reminder_Fab_Validation_Due_Date__c = rmaObj.Reminder_Fab_Validation_One_Day__c = rmaObj.Reminder_Fab_Validation_2_Days__c = rmaObj.Reminder_Fab_Validation_3_Days__c = false;
            rmaObj.Reminder_Quality_Approval_Due_Date__c = rmaObj.Reminder_Quality_Approval_1_Day__c = rmaObj.Reminder_Quality_Approval_2_Days__c = rmaObj.Reminder_Quality_Approval_3_Days__c = false;
            rmaObj.Reminder_Reg_Recommendation_Due_Date__c = rmaObj.Reminder_Reg_Recommendation_1_Day__c= rmaObj.Reminder_Reg_Recommendation_2_Days__c = rmaObj.Reminder_Reg_Recommendation_3_Days__c = false;
            rmaObj.Reminder_Finance_Approval_Due__c = rmaObj.Reminder_Finance_Approval_1_Day__c = rmaObj.Reminder_Finance_Approval_2_Days__c = rmaObj.Reminder_Finance_Approval_3_Days__c = false;
            rmaObj.Twenty_Two_Days_after_RMA_Rejected__c = false;
            rmaObj.Reminder_Acknowledgement_Due_Date__c = rmaObj.Reminder_Acknowledgement_1_Day__c = rmaObj.Reminder_Acknowledgement_2_Days__c = rmaObj.Reminder_Acknowledgement_3_Days__c = false;
            //Revert Acknowledgement fields.
            rmaObj.Acknowledged_Wafer_Return__c = rmaObj.Acknowledged_Wafer_Scrap__c = false;
            rmaObj.Validated_Quality__c = false;
            rmasForUpdate.add(rmaObj);
        }
        if(!rmasForUpdate.isEmpty()){
            update rmasForUpdate;
        }
    }
}