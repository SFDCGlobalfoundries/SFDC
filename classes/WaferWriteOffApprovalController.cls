/*
    Author: Zymark Ambat
    Description: This Class serves as the controller for the WaferWriteOffApprovalVF.
    History: 
        ZAmbat      01292015    - Code creation.
*/

public class WaferWriteOffApprovalController {
    public Wafer_Write_Off__c waferWriteOff {get;set;}
    public string comments {get;set;}

    public WaferWriteOffApprovalController(ApexPages.StandardController controller) {
        // init
        this.waferWriteOff = new Wafer_Write_Off__c();
        this.waferWriteOff = retrieveWaferWriteOffDetails(ApexPages.currentPage().getParameters().get('id'));
    }
    
    public Wafer_Write_Off__c retrieveWaferWriteOffDetails(string id) {
        return [
            SELECT      Id
                        , Name
                        , Customer_Name__c
                        , Customer_Name__r.Short_Name__c
                        , Customer_Name__r.Region__c
                        , Fab__c
                        , Status__c
                        , CreatedById
                        , In_Approval_Process__c
                        , Total_Die_Qty__c
                        , Total_Wafer_Qty__c
                        , Total_Impact_to_P_L__c
                        , Date_Submitted_for_Approval__c
                        , No_of_Lots__c
                        , Reason__c
                        , Other_Reason__c
                        , Comments__c
                        , OwnerId
            FROM        Wafer_Write_Off__c
            WHERE       Id = :id    
        ];
    }
    
    public boolean getShowApproveButton() {
        boolean showButton = false;
        if (ApexPages.currentPage().getParameters().get('approve') != null) {
            showButton = true;
        }
        
        return showButton;
    }
    
    public PageReference approveReject() {
        PageReference pageRef;
        try {
            ProcessInstanceWorkitem piw = [
                SELECT    Id
                FROM      ProcessInstanceWorkitem
                WHERE     ProcessInstance.TargetObjectId = :this.waferWriteOff.Id
                LIMIT 1    
            ];
            
            Approval.ProcessWorkitemRequest req = new Approval.ProcessWorkitemRequest();
            req.setWorkitemId(piw.Id);
            req.setAction(ApexPages.currentPage().getParameters().get('approvalAction'));
            req.setComments(this.comments);
            Approval.process(req);
            
            pageRef = new PageReference('/apex/WaferWriteOffVF?id=' + this.waferWriteOff.Id);
            pageRef.setRedirect(true);
        } catch (Exception e) {
            // Error
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, 'Error: ' + e.getMessage()));
        }
           
        return pageRef;
    }
    
    public PageReference cancel() {
        PageReference pageRef = new PageReference('/apex/WaferWriteOffVF?id=' + this.waferWriteOff.Id);   
        pageRef.setRedirect(true);
        
        return pageRef;
    }
}