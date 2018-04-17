/*
    Author: Zymark Ambat
    Description: This Class serves as the controller for the WaferWriteOffPdfVF.
    History: 
        ZAmbat      03112015    - Code creation.
*/

public class WaferWriteOffPdfController {
    public string createdDateTime {get;set;}
    public string lastModifiedDateTime {get;set;}
    public boolean editValue {get;set;}
    public Wafer_Write_Off__c waferWriteOff {get;set;}
    public List<string> listApprovalStepOrder {get;set;}
    public List<WaferWriteOff_ManufacturingLot__c> listWWOML {get;set;}
    public List<ApprovalWrapper> listApprovalWrapper {get;set;}
    
    public WaferWriteOffPdfController(ApexPages.StandardController controller) {
        this.waferWriteOff = new Wafer_Write_Off__c();
        this.waferWriteOff = [
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
                        , Date_Submitted_for_Approval__c
                        , No_of_Lots__c
                        , Reason__c
                        , Other_Reason__c
                        , Comments__c
                        , Total_Value__c
                        , Total_Provisioned__c
                        , Total_Impact_to_P_L__c
                        , OwnerId
                        , LastModifiedById
                        , CreatedDate
                        , LastModifiedDate
            FROM        Wafer_Write_Off__c
            WHERE       Id = :ApexPages.currentPage().getParameters().get('id')
        ];
        
        this.createdDateTime = this.waferWriteOff.CreatedDate.format();
        this.lastModifiedDateTime = this.waferWriteOff.LastModifiedDate.format();
        
        this.listWWOML = new List<WaferWriteOff_ManufacturingLot__c>();
        this.listWWOML = [SELECT    Id
                                    , Manufacturing_Lot__c  
                                    , Manufacturing_Lot__r.Account_Name__c
                                    , Manufacturing_Lot__r.Active_Flag__c
                                    , Manufacturing_Lot__r.Account_Name__r.Name
                                    , Manufacturing_Lot__r.Device_ID_MES__c
                                    , Manufacturing_Lot__r.Name
                                    , Manufacturing_Lot__r.Lot_Type__c
                                    , Manufacturing_Lot__r.Current_Wafer_Quantity_In_Lot__c
                                    , Manufacturing_Lot__r.Current_Lot_Die_Quantity__c
                                    , Manufacturing_Lot__r.Stage_Id__c
                                    , Manufacturing_Lot__r.Lot_Start_Date__c
                                    , Reason__c
                                    , Status__c
                                    , Aged_Days__c
                                    , Die_Qty__c
                                    , Wafer_Qty__c
                                    , Lot_Start_Date__c
                                    , Comments__c
                                    , Lot_type__c
                                    , Wafer_Write_Off_Status__c
                          FROM      WaferWriteOff_ManufacturingLot__c
                          WHERE     Wafer_Write_Off__c = :ApexPages.currentPage().getParameters().get('id')
                          ORDER BY  Manufacturing_Lot__r.Name ASC];

        List<string> listProfile1 = Environment_Variable__c.getInstance('WWO_PROFILE_1').Value__c.split(';');
        Set<string> setProfile1 = new Set<string>();
        setProfile1.addAll(listProfile1);
        
        List<string> listProfile2 = Environment_Variable__c.getInstance('WWO_PROFILE_2').Value__c.split(';');
        Set<string> setProfile2 = new Set<string>();
        setProfile2.addAll(listProfile2);
        
        List<string> listProfile3 = Environment_Variable__c.getInstance('WWO_PROFILE_3').Value__c.split(';');
        Set<string> setProfile3 = new Set<string>();
        setProfile3.addAll(listProfile3);
        
        Profile p = [
            SELECT    Name
            FROM      Profile
            WHERE     Id = :UserInfo.getProfileId()
        ];
        
        if (setProfile1.contains(p.Name)) {
            this.editValue = false;
        } else if (setProfile2.contains(p.Name)) {
            this.editValue = true;
        } else if (setProfile3.contains(p.Name)) {
            this.editValue = true;
        } else {
            this.editValue = false;
        }
        
        // Approval Process
        Map<Id, string> mapProcessStep = new Map<Id, string>();
        for (ProcessNode pn : [SELECT    Id
                                         , Name
                               FROM      ProcessNode
                               WHERE     ProcessDefinition.DeveloperName = 'Wafer_Write_Off_Approval_Process']) {
            mapProcessStep.put(pn.Id, pn.Name);
        }
        
        List<string> listKeySet = new List<string>();
        Map<string, Map<string, List<ApprovalStepWrapper>>> mapApprovalSteps = new Map<string, Map<string, List<ApprovalStepWrapper>>>();
        for (ProcessInstance pi : [SELECT     Id
                                              , (SELECT     StepStatus
                                                            , StepNodeId
                                                            , OriginalActor.Name
                                                            , ActorId
                                                            , Actor.Name
                                                            , Comments
                                                            , CreatedDate
                                                            , CreatedById
                                                            , CreatedBy.Name 
                                                 FROM       Steps 
                                                 ORDER BY   CreatedDate DESC)
                                   FROM       ProcessInstance    
                                   WHERE      TargetObjectId = :this.waferWriteOff.Id
                                   ORDER BY   CreatedDate DESC
                                   LIMIT 1]) {
            if (pi.Steps.size() > 0) {
                Map<string, List<ApprovalStepWrapper>> tempMap = new Map<string, List<ApprovalStepWrapper>>();
                for (ProcessInstanceStep s : pi.Steps) {
                    string stepName;
                    if (mapProcessStep.get(s.StepNodeId) == null) {
                        stepName = 'Approval Request Submitted';
                    } else {
                        stepName = 'Step: ' + mapProcessStep.get(s.StepNodeId);
                    }
                    
                    ApprovalStepWrapper asw = new ApprovalStepWrapper();
                    asw.stepCreatedDate = s.CreatedDate.format();
                    asw.assignedTo = s.OriginalActor.Name;
                    asw.actualApprover = s.Actor.Name;
                    asw.comments = s.Comments;
                    
                    if (s.StepStatus == 'Started') {
                        asw.status = 'Submitted';
                    } else if (s.StepStatus == 'NoResponse') {
                        asw.status = '';
                    } else {
                        asw.status = s.StepStatus;
                    }
                    
                    if (tempMap.containsKey(stepName)) {
                        tempMap.get(stepName).add(asw);
                    } else {
                        tempMap.put(stepName, new List<ApprovalStepWrapper>{asw});
                    }
                }
                
                listKeySet.add(pi.Id);
                mapApprovalSteps.put(pi.Id, tempMap);
            }                           
        }
        
        if (mapApprovalSteps.size() > 0) {
            this.listApprovalStepOrder = new List<string>();
            this.listApprovalStepOrder.add('Step: Pending Finance Controller Approval 1');
            this.listApprovalStepOrder.add('Step: Pending Finance Controller Approval 2');
            this.listApprovalStepOrder.add('Step: Pending Fab VP Approval 1');
            this.listApprovalStepOrder.add('Step: Pending Fab VP Approval 2');
            this.listApprovalStepOrder.add('Step: Pending Fab VP Approval 3');
            this.listApprovalStepOrder.add('Step: Pending Sales Operations Approval');
            this.listApprovalStepOrder.add('Step: Pending Account Manager Confirmation 1');
            this.listApprovalStepOrder.add('Step: Pending Account Manager Confirmation 2');
            this.listApprovalStepOrder.add('Step: Pending Account Manager Confirmation 3');
            this.listApprovalStepOrder.add('Step: Pending Planning Manager Approval');
            this.listApprovalStepOrder.add('Step: Pending Finance Update of Write Off Value');
            this.listApprovalStepOrder.add('Approval Request Submitted');
            
            this.listApprovalWrapper = new List<ApprovalWrapper>();
            for (string key1 : listKeySet) {
                ApprovalWrapper a = new ApprovalWrapper();
                a.processInstanceId = key1;
                
                Map<string, List<ApprovalStepWrapper>> tempStepsMap = mapApprovalSteps.get(key1);
                for (string s : this.listApprovalStepOrder) {
                    if (tempStepsMap.containsKey(s)) {
                        ApprovalProcessStepWrapper aps = new ApprovalProcessStepWrapper();
                        aps.stepName = s;
                        aps.listApprovalStepWrapper.addAll(tempStepsMap.get(s));
               
                        for (ApprovalStepWrapper asw3 : tempStepsMap.get(s)) {
                            if (asw3.status == 'Approved') {
                                aps.overallStatus = 'Approved';
                                break;
                            } else if (asw3.status == 'Rejected') {
                                aps.overallStatus = 'Rejected';
                                break;
                            }
                        }
                        
                        a.listApprovalProcessStepWrapper.add(aps);
                    }
                }
                
                this.listApprovalWrapper.add(a);
            }
        }
    }
    
    public class ApprovalWrapper {
        public string processInstanceId {get;set;}
        public List<ApprovalProcessStepWrapper> listApprovalProcessStepWrapper {get;set;}
        
        public ApprovalWrapper() {
            this.listApprovalProcessStepWrapper = new List<ApprovalProcessStepWrapper>();
        }
    }
    
    public class ApprovalProcessStepWrapper {
        public string stepName {get;set;}
        public string overallStatus {get;set;}
        public List<ApprovalStepWrapper> listApprovalStepWrapper {get;set;}
        
        public ApprovalProcessStepWrapper() {
            this.listApprovalStepWrapper = new List<ApprovalStepWrapper>();
        }
    }
    
    public class ApprovalStepWrapper {
        public string stepCreatedDate {get;set;}
        public string assignedTo {get;set;}
        public string actualApprover {get;set;}
        public string comments {get;set;}
        public string status {get;set;}
        
        public ApprovalStepWrapper() {}
    }
}