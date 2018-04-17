/*
    Author: Prajnith Karra
    Description: This serves as a custom controller for VF page, to select approvers manually.
    History:        
        Prajnith    10102016    - Updated code for fixing Device reactivation.                    
*/

public class NPCFormAssigneApprProcessController{
private string recId {get;set;}
    public New_Part_Creation_Form__c npcForm {get;set;}
    public boolean isPIYEApproval {get; set;} 
    public String comments{get; set;}
    public boolean npcFabCheck {get; set;}
    public String fabList = Environment_Variable__c.getInstance('NPC_FAB_LIST').Value__c;
    public Boolean maskCheck = false;
    public boolean actualimpl {get;set;}
    public boolean reqActualImp {get;set;}

public NPCFormAssigneApprProcessController(){
        this.recId = ApexPages.currentPage().getParameters().get('id');
        system.debug('***ID***'+this.recId);
        actualimpl = true;
        reqActualImp = false;
        this.npcForm = [
                    SELECT      Id
                                , Name
                                , No_of_PI_YE_Assignes__c 
                                , Planned_Implementation_Date__c
                                , Actual_Implementation_Date__c
                                , No_of_SMO_Users__c 
                                , Originating_Device__r.PLM_Device_ID__c  
                                , CRM_DID__c
                                , Originating_Device__r.CRMDID__c                                                                     
                                , Action__c
                                , PID__c
                                , PID_Status__c
                                , Comments__c 
                                , Notification_Group__c
                                , Litho_Validate_Reticle_is_in_GF__c
                                , Date_to_Ship_Reticle_to_Mask_Shop__c
                                , Mask_Shop_Name__c
                                , Mask_Shop_Site__c
                                , Mask_Shop_Address__c
                                , Assignee_1__c
                                , Assignee_2__c
                                , Additional_Recipient_1__c
                                , Is_reticle_available__c
                                , Skip_Final_Step__c 
                                , STF_Activation_Steps__c
                                , NRE_25K_USD__c
                                , Risk_Waiver__c
                                , Min_Order_qty_agreement_with_customer__c
                                , Min_Order_Create__c
                                , Account_Name__c
                                , Account__c
                                , Fab__c
                                , New_Part_ID__c
                                , Reason_for_New_Part__c
                                , Tapeout_Required__c
                                , No_of_Approvers__c
                                , PIYE_Approver_1__c
                                , PIYE_Approver_2__c
                                , PIYE_Approver_3__c, PIYE_Approver_4__c
                                , No_of_PIYE_Approvers__c
                                , BASE_Device__c
                                , BASE_Device__r.OwnerId
                                , Originating_Device__c
                                , Originating_Device__r.Opportunity_Program__c
                                , NPC_Form_Status__c
                                , Approver_1__c 
                                , Approver_2__c
                                , Approver_3__c 
                                , Approver_4__c
                                , Approver_5__c 
                                , Approver_6__c
                                , Approver_7__c 
                                , Approver_8__c
                                , Approver_9__c 
                                , Approver_10__c                                
                                , No_of_Customer_Rep_Approvers__c
                                , (SELECT Layer__c,New_Part_Creation_Form__c from Masks__r)                                                            
                    FROM        New_Part_Creation_Form__c
                    WHERE       Id = :this.recId
                  ];  
                  
        reqActualImp = true;                        
                 
        if(npcForm.Skip_Final_Step__c == false && npcForm.Is_reticle_available__c == EnvironmentVariable.get('NPC_STF_Reticle_Customer') )
        {
                actualimpl = false;
                reqActualImp = true;                 
        }
        if(npcForm!=null){                                                                                         
            List<ProcessInstance> piList = [SELECT      Id
                                                        , (SELECT Id, StepStatus, Comments FROM Steps WHERE Comments = 'Auto Submission After CE Approval' OR Comments = 'Auto Submission After FE Action')
                                            FROM        ProcessInstance 
                                            WHERE       TargetObjectId = :this.npcForm.Id
                                            ORDER BY    CreatedDate DESC];                                                                                                    
        }
        if(npcForm.Is_reticle_available__c == EnvironmentVariable.get('NPC_STF_Reticle_Customer')){
         List<Account_Team_Proxy__c> tempListACCTM = [
                        SELECT      Id
                                    , User__c,
                                    user__r.Name
                        FROM        Account_Team_Proxy__c
                        WHERE       Account__c = :this.npcform.Account__c
                                    AND (Team_Role__c =: 'Backup Customer Service Rep' OR Team_Role__c =: 'Primary Customer Service Rep')
                                    AND User__r.IsActive = true
                        ORDER BY    CreatedDate
                        LIMIT 10]; 
            this.npcForm.No_of_Customer_Rep_Approvers__c = tempListACCTM.size();                        
            if(tempListACCTM.size() > 0){

                if(tempListACCTM.size() == 2){
                    this.npcform.Approver_1__c = tempListACCTM[0].User__c;
                    this.npcform.Approver_2__c = tempListACCTM[1].User__c;                
                }
                else if(tempListACCTM.size() == 1){
                    this.npcform.Approver_1__c = tempListACCTM[0].User__c;
                }

            }
            else
            {
               this.npcform.Approver_1__c = null;
               this.npcform.Approver_2__c = null;
            }
       }                                                   
                        
    }
    
     public PageReference approveNPC(){  
    String pageHeaderReferer = ApexPages.currentPage().getHeaders().get('Referer');         
    
      if(pageHeaderReferer != null && pageHeaderReferer.containsIgnoreCase('NPCPIYUpdate')){
             if(npcForm.Assignee_1__c  != null){
                  npcForm.No_of_PI_YE_Assignes__c = 1; 
             }
             if(npcForm.Assignee_2__c  != null && npcForm.Assignee_1__c == null){
                  npcForm.Assignee_1__c  = npcForm.Assignee_2__c;
                  npcForm.No_of_PI_YE_Assignes__c = 1;                 
             }
             if (npcForm.Assignee_1__c != null && npcForm.Assignee_2__c != null) {
                  npcForm.No_of_PI_YE_Assignes__c = 2; 
             }
      if(npcForm.Originating_Device__r.PLM_Device_ID__c == '' || npcForm.Originating_Device__r.PLM_Device_ID__c == null){ npcForm.CRM_DID__c =  npcForm.Originating_Device__r.CRMDID__c;}
      
      if(npcForm.Is_reticle_available__c != EnvironmentVariable.get('NPC_STF_Reticle_Customer')){ 
                   
                           
           if(npcForm.Planned_Implementation_Date__c == null && npcForm.Actual_Implementation_Date__c == null){ 
            ApexPages.addmessage(new ApexPages.Message(ApexPages.severity.ERROR, EnvironmentVariable.get('NPC_STF_ImplementationDate_VALIDATE')));                     
             return null;
           }
           else if(npcForm.Planned_Implementation_Date__c == null && npcForm.Actual_Implementation_Date__c != null){
            ApexPages.addmessage(new ApexPages.Message(ApexPages.severity.ERROR, EnvironmentVariable.get('NPC_STF_PlannedImpl_Mand')));                    
             return null;
           }
           else
           {               
            update npcForm;            
            if(npcForm.Planned_Implementation_Date__c != null && npcForm.Actual_Implementation_Date__c != null){
               
                date todaysDate = system.today();
                if(npcForm.Actual_Implementation_Date__c <= todaysDate )    {
                Approval.ProcessWorkitemRequest req = new Approval.ProcessWorkitemRequest();            
                req.setComments(this.comments);
                system.debug('10051'+ req);
                req.setAction('Approve');
                Id workItemId = getWorkItemId(npcForm.id);
                  req.setWorkitemId(workItemId);
                Approval.ProcessResult result =  Approval.process(req);            
                 if(result.isSuccess()){
                        Approval.ProcessSubmitRequest reqSubmit = new Approval.ProcessSubmitRequest();
                 }
                 PageReference pageRef;
                  pageRef = new PageReference('/'+npcForm.Id);            
                 pageRef.setRedirect(true);
                 return pageRef; 
                 }
                 else
                 {
                   ApexPages.addmessage(new ApexPages.Message(ApexPages.severity.ERROR, EnvironmentVariable.get('NPC_STF_Actual_Imp_GR_TODAY')));                         
                   return null;   
                 }
            }
             PageReference pageRef;
                  pageRef = new PageReference('/'+npcForm.Id);            
                 pageRef.setRedirect(true);
                 return pageRef; 
                                   
           }
        }
          if(npcForm.Is_reticle_available__c == EnvironmentVariable.get('NPC_STF_Reticle_Customer')){            

             if(npcForm.Planned_Implementation_Date__c == null){ 
                        ApexPages.addmessage(new ApexPages.Message(ApexPages.severity.ERROR,  EnvironmentVariable.get('NPC_STF_ImplementationDate_VALIDATE')));                                
                         return null;
             }
             else
             {
              date todaysDate = system.today();
                if(npcForm.Actual_Implementation_Date__c != null && npcForm.Actual_Implementation_Date__c > todaysDate )    {
                   ApexPages.addmessage(new ApexPages.Message(ApexPages.severity.ERROR,  EnvironmentVariable.get('NPC_STF_Actual_Imp_GR_TODAY')));                             
                   return null; 
                }                                   
                update npcForm;
                 if(npcForm.Planned_Implementation_Date__c != null && npcForm.Approver_1__c == null && npcForm.Approver_2__c == null){ 
                        ApexPages.addmessage(new ApexPages.Message(ApexPages.severity.ERROR, 'No Customer Representatives in Account'));
                        return null;
                 }
               if(npcForm.Actual_Implementation_Date__c == null && npcForm.Date_to_Ship_Reticle_to_Mask_Shop__c != null && npcForm.Mask_Shop_Name__c != null){
                        ApexPages.addmessage(new ApexPages.Message(ApexPages.severity.ERROR, 'Actual implementation date is Required'));
                        return null;            
                }
                             
                if(npcForm.Planned_Implementation_Date__c != null && (npcForm.Approver_1__c != null || npcForm.Approver_2__c != null)){
                    Approval.ProcessWorkitemRequest req = new Approval.ProcessWorkitemRequest();            
                    req.setComments(this.comments);
                    system.debug('10051'+ req);
                    req.setAction('Approve');
                    Id workItemId = getWorkItemId(npcForm.id);
                      req.setWorkitemId(workItemId);
                    Approval.ProcessResult result =  Approval.process(req);            
                     if(result.isSuccess()){
                            Approval.ProcessSubmitRequest reqSubmit = new Approval.ProcessSubmitRequest();
                     }
                     PageReference pageRef;
                      pageRef = new PageReference('/'+npcForm.Id);            
                     pageRef.setRedirect(true);
                     return pageRef; 
                }
             PageReference pageRef;
                  pageRef = new PageReference('/'+npcForm.Id);            
                 pageRef.setRedirect(true);
                 return pageRef; 
                                   
           }
           
          }        
       } 
        if(pageHeaderReferer != null && pageHeaderReferer.containsIgnoreCase('NPCMaskReticleShopInfo')){
                //npcForm.Skip_Final_Step__c = true;
                if(npcForm.Mask_Shop_Name__c == null && npcForm.No_of_SMO_Users__c == 0){                                  
                  list<GroupMember> grSMO =  [SELECT Group.Name,Group.Id,UserorgroupId FROM GroupMember WHERE Group.Type = 'Queue' AND  Group.Name =: EnvironmentVariable.get('NPC_Reactivation_SMO')];
                     npcForm.Approver_1__c = null;
                     npcForm.Approver_2__c = null;
                     npcForm.Approver_3__c = null;
                     npcForm.No_of_SMO_Users__c = grSMO.size();
                     Integer cnt2 = 1;
                      for(Integer i = 0; i < grSMO.size();i++ ){
                             string userID = grSMO[i].UserorgroupId;
                              if(userID.startsWith('005')){
                                  npcForm.put('Approver_'+cnt2+'__c', userID);
                                     cnt2++;
                              }                     
                       }                                                             
                }
             update npcForm;   
                   Approval.ProcessWorkitemRequest req = new Approval.ProcessWorkitemRequest();            
                    req.setComments(this.comments);
                    system.debug('10051'+ req);
                    req.setAction('Approve');
                    Id workItemId = getWorkItemId(npcForm.id);
                      req.setWorkitemId(workItemId);
                    Approval.ProcessResult result =  Approval.process(req);            
                     if(result.isSuccess()){   
                            Approval.ProcessSubmitRequest reqSubmit = new Approval.ProcessSubmitRequest();                     
                           // reqSubmit.setObjectId(npcForm.id);                           
                           // Approval.Processresult resSubmit = Approval.process(reqSubmit);                            
                     }
                                        
             PageReference pageRef;
                  pageRef = new PageReference('/'+npcForm.Id);            
                 pageRef.setRedirect(true);
                 return pageRef; 
                                   
           }
       
                
         return null;       
     }
  // Cancel NPC by CE and PIYE
    public PageReference cancelNPC(){        
        return getNPCDetailPage();
    }
    // Redirect to the NPC Readonly page
    private PageReference getNPCDetailPage(){
        PageReference pgRef = new PageReference('/apex/NPCFormInternalReadOnlyVF');
        pgRef.getParameters().put('id',npcForm.Id);
        pgRef.setRedirect(true);
        return pgRef;
    }   
    // Reject NPC by CE and PIYE
    public PageReference rejectNPC(){
        /**
         * Snune 10012015 - Updated code for fixing case 47700
         * Added if else statements to make comments mandatory.
         */
        if(String.isNotBlank(this.comments)){
            Approval.ProcessWorkitemRequest req = new Approval.ProcessWorkitemRequest();
            //addComments(req);
            req.setComments(this.comments);
            
            req.setAction('Reject');
            Id workItemId = getWorkItemId(npcForm.id);
    
            if(workItemId == null)
            {
                system.debug('Error');
            }else{
                req.setWorkitemId(workItemId);
                // Submit the request for approval
                Approval.ProcessResult result =  Approval.process(req);
            }
            return getNPCDetailPage();
        }else{
             ApexPages.addmessage(new ApexPages.Message(ApexPages.severity.ERROR, 'Please enter Comments for rejecting NPC.'));
             return null;
        }
    }
  // Retrieve the last workitem among the list
    public Id getWorkItemId(Id targetObjectId)
    {
        Id retVal = null;
        for(ProcessInstanceWorkitem workItem  : [Select p.Id from ProcessInstanceWorkitem p
                                                where p.ProcessInstance.TargetObjectId =: targetObjectId]){
            retVal  =  workItem.Id;
        }
        return retVal;
    }    
        
        
    
}