/*
    Author: Anirban Roy
    Description: This is the controller class for the recall functionality of Approval Process for NPC. (Case : 00004883)
    History: 
        ARoy      01292014    - Code creation.
*/

public class NPCFormRecallApprovalController {
    
    // Variable Declaration
    private string recId {get;set;}
    public New_Part_Creation_Form__c npcForm {get;set;}
    private string shareDevice {get;set;}
    public String comments{get; set;}
    
    // Constructor
    public NPCFormRecallApprovalController(ApexPages.StandardController controller){
        this.recId = ApexPages.currentPage().getParameters().get('id');
        this.shareDevice = ApexPages.currentPage().getParameters().get('share');
        npcForm = [
                    SELECT      Id                                
                                , Name
                                , BASE_Device__c
                                , CreatedBy.Name             
                    FROM        New_Part_Creation_Form__c
                    WHERE       Id = :this.recId
                  ];        
    }
    
    // NPC Form Recall function for the Customer Portal User
    public PageReference recallApproval(){
        // Check if device share is needed
        Device__Share ds = new Device__Share();
        if (this.shareDevice != null && this.shareDevice.trim() != '') {
            ds.ParentId = npcForm.BASE_Device__c;
            ds.UserOrGroupId = UserInfo.getUserId();
            ds.AccessLevel = 'Edit';
            ds.RowCause = 'Opportunity_Program_Team__c';
            
            insert ds;
        }
        
        // Recall the approval process
        Approval.ProcessWorkitemRequest req = new Approval.ProcessWorkitemRequest();
        req.setComments(this.comments);
        
        req.setAction('Removed');
        System.debug('MuktanpcForm'+npcForm.id);
        Id workItemId = getWorkItemId(npcForm.id);
        System.debug('MuktaworkItemId'+workItemId);
        if(workItemId != null)
        {            
            req.setWorkitemId(workItemId);
            Approval.ProcessResult result =  Approval.process(req);
            
            // Remove the user from the device share and redirect the user to the NPC readonly page fopr portal
            if(result.isSuccess()){
                String currentUrl = ApexPages.currentPage().getUrl();
                
                // Delete sharing
                if (this.shareDevice != null && this.shareDevice.trim() != '') {
                    List<Device__Share> listDS = [
                        SELECT      Id
                        FROM        Device__Share
                        WHERE       Id = :ds.Id
                    ];
                    
                    delete listDS;
                }
                
                PageReference pgr = new PageReference('/GlobalfoundryView/NPCFormReadOnlyVF?id=' + this.recId);                
                pgr.setRedirect(true); 
                return pgr;
            }
        }                    
        return null;
    }
    
    //NPC Cancel functionality for the Customer Portal User
    public PageReference cancelNPC(){
        PageReference pgr = new PageReference('/GlobalfoundryView/NPCFormReadOnlyVF?id=' + this.recId);                
        pgr.setRedirect(true); 
        return pgr;
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