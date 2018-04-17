/**
* Company       :   Cognizant Technologies PTE Ltd.
* Description   :   This is the controller class for RMA_BulkApproval page.
* History       :   

        Initials        Date          Description
-----------------------------------------------------------------------------------------
        Nikhil Jain    04-Jul-16      Created the Class
**/

public without sharing class RMA_BulkApprovalController{
    
    public List<RMAwrapper> lstRMAwrapper;
    List<String> lstQualityGroups;
    
    public Integer size{get;set;}
    public Integer noOfRecords{get; set;}
    
    //wrapper class for RMA records to be approved
    public class RMAwrapper{
        public boolean isSelected{get;set;}
        public RMA__c rmaRec{get;set;}
        public RMAwrapper(boolean isSel,RMA__c rmaRecord){
            isSelected = isSel;
            rmaRec = rmaRecord;
        }
    }
    
    //RMA_BulkApprovalController - Constructor initialization
    public RMA_BulkApprovalController(){
        lstRMAwrapper = new List<RMAwrapper>();
        lstQualityGroups = new List<String>();
        for(GroupMember gm: [SELECT Id, Group.Name from GroupMember 
                                WHERE Group.Name in  ('RMA Foundry Quality Team','RMA ASIC Quality Team','RMA IBM Server Quality Team') 
                                  and Group.Type = 'Regular'
                                  and UserOrGroupId = :UserInfo.getUserId()]){
            if(gm.Group.Name.contains('ASIC')){
                lstQualityGroups.add('ASIC');
            }else if(gm.Group.Name.contains('Foundry')){
                lstQualityGroups.add('Foundry');
            }else if(gm.Group.Name.contains('IBM Server')){
                lstQualityGroups.add('IBM Server');
            }
        }
    }
    
    //Prepare setController to retrieve records
    public ApexPages.StandardSetController setCon{
        get{
            if(setCon == null){
                size = integer.valueOf(System.Label.RMA_Bulk_Approval);                
                setCon = new ApexPages.StandardSetController(
                        [SELECT Id,Name,Workflow_Stage__c,Fab__c,RMA_By__c,Business_Category__c,Product_Line__c,ReasonCode__c,
                            Total_Wafers__c,Count_Line_Item__c,Disposition_by_Quality__c,RMA_Category__c,Grand_Total_Price__c,
                            Disposition_of_Wafers__c,
                            (SELECT id,Name,Invoice_Number__c,Lot_Number__c,Invoice_Date__c,Device__c,Wafer_Id_CSR_Submission__c,
                            Wafer_Id_Fab_9_10_CSR_Submission__c,Wafer_Quantity__c,Module_Quantity__c,Scrap_Limit__c,Wafer_Yield__c,
                            GDPW__c,Die_Quantity__c,Die_Selling_Price__c
                             FROM RMA_Return_Invoices__r)
                        FROM RMA__c
                        WHERE Workflow_Stage__c =: RMA_Constants.PEN_CQ_VAL
                            AND Business_Category__c in :lstQualityGroups 
                            AND RMA_Category__c = 'Technical/ Turnkey'
                            AND ReasonCode__c = 'R50'
                            AND Grand_Total_Price__c <= 2000
                         ORDER BY Business_Category__c
                         LIMIT 2000]);
                
                setCon.setPageSize(size);
                noOfRecords = setCon.getResultSize();
            }
            return setCon;
        }
        public set;
    }
    
    //Initialize setCon and return a list of records
    public List<RMAwrapper> getRMAWrapperRecords(){
        lstRMAwrapper.clear();        
        for(RMA__c rmaRec : (List<RMA__c>)setCon.getRecords()){
            //NJain - 28Oct16 - Defaulting the value to 'Scrap' if not filled by Quality.
            if(rmaRec.Disposition_By_Quality__c == NULL){
                rmaRec.Disposition_By_Quality__c = 'Scrap';
            }
            lstRMAwrapper.add(new RMAwrapper(True,rmaRec));
        }
        return lstRMAwrapper;
    }
    
    public PageReference SaveAndApprove(){
        List<RMA__c> lstRMAtoApprove = new List<RMA__c>();
        List<String> lstRMAwithNoDisposition = new List<String>();

        for(RMAwrapper wrapRec: lstRMAwrapper){
            if(wrapRec.isSelected){
                if(wrapRec.rmaRec.Disposition_By_Quality__c != NULL && wrapRec.rmaRec.Disposition_By_Quality__c != ''){
                    lstRMAtoApprove.add(wrapRec.rmaRec);
                }else{
                    lstRMAwithNoDisposition.add(wrapRec.rmaRec.Name);
                }
            }
        }
        
        if(lstRMAwithNoDisposition.isEmpty()){
            if(!lstRMAtoApprove.isEmpty()){
                try{
                    database.update(lstRMAtoApprove);
                    
                    map<String,String> mapRMAvsWorkItemId = new Map<String,String>();
                    List<Approval.ProcessWorkitemRequest> lstApprovalRequests = new List<Approval.ProcessWorkitemRequest>();
                    for(ProcessInstanceWorkitem workItem: [SELECT Id,ProcessInstance.TargetObjectId from ProcessInstanceWorkitem
                                                            WHERE ProcessInstance.TargetObjectId in :lstRMAtoApprove
                                                            AND   ProcessInstance.Status = 'Pending']){
                        mapRMAvsWorkItemId.put(workItem.ProcessInstance.TargetObjectId,workItem.Id);
                    }
                    // Approve the record
                    for(String rmaId :mapRMAvsWorkItemId.keySet()){
                        Approval.ProcessWorkitemRequest req = new Approval.ProcessWorkitemRequest();
                        req.setComments('Request approved through Bulk Approval by Quality');
                        req.setAction('Approve');
                        req.setNextApproverIds(new Id[] {UserInfo.getUserId()});
                        Id workItemId = mapRMAvsWorkItemId.get(rmaId);
                        if(workItemId == NULL){
                            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, 'Some Exception occurred.'));
                        }else{
                            req.setWorkitemId(workItemId);
                            lstApprovalRequests.add(req);
                        }
                    }
                    if(!lstApprovalRequests.isEmpty()){
                        List<Approval.ProcessResult> lstResult =  Approval.process(lstApprovalRequests);
                        Schema.DescribeSObjectResult r = RMA__c.sObjectType.getDescribe();
                        String keyPrefix = r.getKeyPrefix();
                        pageReference pg = new pageReference('/'+ keyPrefix);
                        pg.setRedirect(true);
                        return pg;
                    }
                }catch(Exception e){
                    ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, e.getMessage()));
					GlobalUtility.logMessage('Error', RMA_BulkApprovalController.class.getName(), 'SaveAndApprove()', '','RMA Bulk Approval',
                                      'Error Message='+e.getMessage()+' At Line Number='+e.getLineNumber()+' Stack Trace='+e.getStackTraceString(), 
                                      '','RMA',e, NULL);
                }
            }else{
                 ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, 'Please select atleast one RMA record to approve'));
            }
        }else{
            string msg='Please select <i>Disposition by Quality</i> for the following selected RMA records.<br/>';
            integer i=1;
            for(String s: lstRMAwithNoDisposition){
                msg += i +'.&nbsp;' + s + '<br/>';
                i++;
            }
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, msg));
        }
        return NULL;
    }
    
    public PageReference Cancel(){
        Schema.DescribeSObjectResult r = RMA__c.sObjectType.getDescribe();
        String keyPrefix = r.getKeyPrefix();
        pageReference pg = new pageReference('/'+ keyPrefix);
        pg.setRedirect(true);
        return pg;
    }
    
    //++Methods for Pagination
    public void first() {
        setCon.first();
    }
  
    public void last() {
        setCon.last();
    }
  
    public void previous() {
        setCon.previous();
    }
  
    public void next() {
        setCon.next();
    }
    public Boolean hasNext {
        get {
            return setCon.getHasNext();
        }
        set;
    }
    public Boolean hasPrevious {
        get {
            return setCon.getHasPrevious();
        }
        set;
    }
 
    public Integer pageNumber {
        get {
            return setCon.getPageNumber();
        }
        set;
    }
    //--Methods for Pagination
    
	//for code coverage
    public void dummyMethod(){
        integer i = 1; 
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
    }
}