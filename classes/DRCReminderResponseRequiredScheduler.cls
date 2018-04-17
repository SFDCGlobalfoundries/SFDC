/*
*@ Author       :- SUHAS BARGI
*@ Company      :- Global Foundries
*@ Date         :- 
*@ Description  :- Scheduler to call waiver collaborator batch after every 24 hrs for 
* @ Template 4 : reminder mail, scheduled batch - Collaborator status is “Pending Customer/ Foundry” for >2days. THEN IF Release Report pending for every 24hrs until closed
*@ History      :- 
*/

global with sharing class DRCReminderResponseRequiredScheduler implements Schedulable {

     global void execute(SchedulableContext SC) {
        Date previousDate = date.Today().addDays(-2);
        string wRuleList   ='SELECT Account_Manager_Approver__c,AIA_Is_Sync_Message__c,CreatedById,CreatedDate,Customer_Closing_Comment__c,Customer_Review_Request__c,'
                         +'Design_Rule_Name__c,Final_Stage__c,Final_Status__c,GF_Internal_Closing_Comment__c,GF_Review_Comment__c,GF_Review_Results__c,'
                         +'Hierarchial_Error_Count__c,Id,Image_Path__c,isAllPartyApproved__c,IsCustomerAcceptsRisk__c,'
                         +'IsCustomerAgreeToFix__c,IsGfAcceptsRisk__c,Is_Sync_with_AIA__c,RecallApprovalProcess__c,Disagree__c,Old_Image_Path__c,Warning__c,'
                         +'MantisId__c,Name,Number_of_Violation__c,RuleId_Txt__c,RuleId__c,Rule_Description__c,SelectedBox__c,'
                         +'Stage__c,SystemModstamp,Waiver_Collaborator__c,Waiver_Collaborator__r.PTSR_Service_Type__c  FROM Waiver_Rule_List__c ' 
                         +'WHERE LastModifiedDate <= : previousDate AND (isAllPartyApproved__c = FALSE AND IsCustomerAcceptsRisk__c = FALSE AND IsCustomerAgreeToFix__c = FALSE AND IsGfAcceptsRisk__c=FALSE AND Waiver_Collaborator__r.Workflow_Status__c=\'Freeze\' AND Waiver_Collaborator__r.Is_releasedToCustomer__c=TRUE) ';
          
          
        string wCollList = 'Select id,Name,Account_Name__c,Progressbar_staus__c,Account_Short_Name__c,PTSR_Service_Type__c,isReleaseToCust4MultiDie__c,Mask_Set_Title__c,DRCServiceoption__c,CollaboratorClosedMail__c,MantisIds__c,PTSR_Number__c,PTSR_Status__c,Cancellation_Reason__c,DFM_Transaction_Id__c  from Wavier_Collaborator__c where CreatedDate <=: colpreviousdate AND isReleaseToCust4MultiDie__c= TRUE AND DRCServiceoption__c =\'DRC Run Only\' AND PTSR_Status__c != \'Closed\' AND Workflow_Status__c != \'Cancel\' ' ;                 
                         
      DRCReminderResponseRequiredBatch waiver = new DRCReminderResponseRequiredBatch(wRuleList,'Waiver_Rule_List__c');
      if(getSameJobCount() < 1 && getRunnigJobCount() < 5){
        database.executeBatch(waiver, 10);
      } 
      
       DRCReminderResponseRequiredBatch waiverColl = new DRCReminderResponseRequiredBatch(wCollList,'Wavier_Collaborator__c');
      if(getSameJobCount() < 1 && getRunnigJobCount() < 5){
        database.executeBatch(waiverColl, 10); 
      }
   }
   // Method return count of number of running jobs
    private static Integer getRunnigJobCount() {
        return (Integer)[Select count() From AsyncApexJob Where JobType = 'BatchApex' and ( Status = 'Processing' or Status = 'Preparing' )];
    }
    // Method retuns 1 if same job is already running and 0 if not runnig
    private static Integer getSameJobCount(){
        
        return (Integer)[Select count()From AsyncApexJob Where JobType = 'BatchApex' 
                         and ApexClass.Name = 'DRCReminderResponseRequiredBatch' 
                         and (Status = 'Processing' or Status = 'Preparing' )];
        
    }
}