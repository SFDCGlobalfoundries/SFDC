public class DRConfigurationController1{
    
    public list<SelectOption> picklistValues{get; set;}
    public string picklistName{get; set;}
    public string newpicklistVal{get; set;}
    public string serverURL{get; set;}
    
    public DR_Configuration__c config{get; set;}
    
    public string customObjectId{get; set;}       
    public string dependentFieldVal{get; set;}
    public string controllingFieldVal{get; set;}
    
    public string applicationName{get; set;}
    
    public class PicklistWrapper{
        public string pickLabel{get; set;}
        public string pickValue{get; set;}
        
        public PicklistWrapper(string pv, string pl){
            pickLabel = pl;
            pickValue = pv;
        }
    }
    public list<PicklistWrapper> extPicklistValues{get; set;}
    
    public class DRApproverWrapper{
        public Application_Approver__c approverObj{get; set;}        
        public string queueName{get; set;}
    }    
    public list<DRApproverWrapper> approvers{get; set;}
        
    public DRConfigurationController1(){
        picklistValues = new list<SelectOption>();  
        config = new DR_Configuration__c();
        list<DR_Configuration__c> configurations = [Select Id, Name, Additional_Notes__c, Application_Category__c, Application_Name__c, ApproverSubmitter_Check__c, Change_Type__c, Deployment_Status__c, Is_Code_Review_Completed__c,
                            Is_TA_Review_Completed__c, Is_TFA_Review_Completed__c, Request_Type__c, Review_Status__c, Risk_Start_Approver1__c, Risk_Start_Approver2__c, Risk_Start_Approver3__c,Opty_CAB_Approver__c,Opty_Internal_Control_Approver__c,
                            RMA_Approver1__c, RMA_Approver2__c, RMA_Approver3__c, Source_Environment__c, Stage__c, Standard_Apps_Approver1__c, Standard_Apps_Approver2__c, Standard_Apps_Approver3__c,Opty_FBO_EBiZ_Approver__c,Account_CAB_Approver__c,
                            Support_KT_Status__c, System_Affected__c, Target_Environment__c, Wafer_Write_Off_Approver1__c, Wafer_Write_Off_Approver2__c, Wafer_Write_Off_Approver3__c,Account_Internal_Control__c,Account_FBO_EBiZ_Approver__c
                  From DR_Configuration__c limit 1];
        
        if(configurations.size() > 0){
            config = configurations[0];
        }          
        picklistValues.add(new SelectOption('','--None--')) ;
        Map<String, Schema.SObjectField> drfieldsMap =  Schema.SObjectType.DR_Configuration__c.fields.getMap();
        for(Schema.SObjectField field : drfieldsMap.values()){
            if(field.getDescribe().getType() == Schema.DisplayType.Picklist)
                picklistValues.add(new SelectOption(field.getDescribe().getName(),field.getDescribe().getLabel()));
        } 
        
        // Constructs the Tooling API wrapper (default constructor uses user session Id)
        ToolingAPI toolingAPI = new ToolingAPI();         
        // Query CustomObject object by DeveloperName (note no __c suffix required)
        List<ToolingAPI.CustomObject> customObjects = (List<ToolingAPI.CustomObject>)
             toolingAPI.query('Select Id, DeveloperName, NamespacePrefix From CustomObject Where DeveloperName = \'DR_Configuration\'').records;         
        // Query CustomField object by TableEnumOrId (use CustomObject Id not name for Custom Objects)
        ToolingAPI.CustomObject customObject = customObjects[0];
        customObjectId = customObject.Id;
        customObjectId = customObjectId.substring(0,15);
        //Get server URL
        String sUrlRewrite = System.URL.getSalesforceBaseUrl().getHost();
        String sfBaseProtocol = System.URL.getSalesforceBaseUrl().getProtocol();
    
        //remove namespace
        integer firstDotPos = sUrlRewrite.indexOf('.');
        sURlRewrite = sURlRewrite.substring(firstDotPos+1);
    
        //replace visual.force with salesforce
        sURlRewrite = sURlRewrite.replace('visual.force', 'salesforce');
        sUrlRewrite = sfBaseProtocol+'://'+sURlRewrite;
        system.debug('>>>>>>>>>>>>>>>>instance URL:'+sUrlRewrite);
        serverURL = sUrlRewrite;
        
        approvers = new list<DRApproverWrapper>();
    }
    
    public void addApplication(){
        approvers = new list<DRApproverWrapper>();
        list<Application_Approver__c> existingApprovers = [Select Id, name, User__c, Application_Name__c, Role__c from Application_Approver__c where Application_Name__c  = :applicationName];
        if(existingApprovers.size() > 0){
            for(Application_Approver__c approver :existingApprovers){
                DRApproverWrapper wrapper = new DRApproverWrapper();
                wrapper.approverObj= approver;
                approvers.add(wrapper);
            }
        }else {
            for(Integer i=0; i<4; i++){
                DRApproverWrapper wrapper = new DRApproverWrapper();
                wrapper.approverObj = new Application_Approver__c();
                wrapper.approverObj.Application_Name__c = applicationName;
                approvers.add(wrapper);
            }
        }
    }
    
    public void selectPicklistField(){
        //fetch existing picklist values
        extPicklistValues = new list<PicklistWrapper>(); 
        system.debug('>>>>>>>>>>picklistName:'+picklistName);
        Map<String, Schema.SObjectField> drfieldsMap =  Schema.SObjectType.DR_Configuration__c.fields.getMap();
        for(Schema.SObjectField field : drfieldsMap.values()){
            if(field.getDescribe().getName() == picklistName){
                List<Schema.PicklistEntry> ple = field.getDescribe().getPicklistValues();   
                for(Schema.PicklistEntry p: ple){
                    extPicklistValues.add(new PicklistWrapper(p.getValue(),p.getLabel()));
                }            
            }
        }
    }
    
    public void addRow(){
        DRApproverWrapper wrapper = new DRApproverWrapper();
        wrapper.approverObj = new Application_Approver__c();
        wrapper.approverObj.Application_Name__c = applicationName;
        approvers.add(wrapper);
    }

    public void saveApprovers(){
        //fetch existing approvers
        //list<Application_Approver__c> extapprovers = [Select Id, name, User__c, Application_Name__c, Role__c from Application_Approver__c where Application_Name__c = :applicationName];
        //delete extapprovers;
        
        list<Application_Approver__c> newApprovers = new list<Application_Approver__c>();
        set<string> queueNames = new set<string>();
        for(DRApproverWrapper  wrapper :approvers){            
            if(wrapper.approverObj.User__c != null && wrapper.approverObj.Role__c != null){
                newApprovers.add(wrapper.approverObj);
                queueNames.add('DR '+wrapper.approverObj.Application_Name__c+' '+wrapper.approverObj.Role__c.toUpperCase());
            }
        }        
        upsert newApprovers;
        list<Id> newApproversIds = new list<Id>();
        for(Application_Approver__c approver :newApprovers)
            newApproversIds.add(approver.Id);
            
        createQueuesAndMembers(queueNames,newApproversIds);
        //createUATApprovalProcess();      
    }
    
    public void createApprovalProcesses(){
        createUATApprovalProcess();
        createProductionApprovalProcess();
    }
    
    @future(callout=true)
    public static void createProductionApprovalProcess(){
        list<Application_Approver__c> newApprovers = [Select Id, name, User__c, Application_Name__c, Role__c from Application_Approver__c];
        map<string,set<string>> appNameListOfRoles = new map<string,set<string>>();
        for(Application_Approver__c approver: newApprovers){
            if(!appNameListOfRoles.containsKey(approver.Application_Name__c))
                appNameListOfRoles.put(approver.Application_Name__c, new set<string>{approver.Role__c});
            else 
                appNameListOfRoles.get(approver.Application_Name__c).add(approver.Role__c);
        }   
        
        GFSMetadataService.MetadataPort service = new GFSMetadataService.MetadataPort();   
        service.SessionHeader = new GFSMetadataService.SessionHeader_element();
        service.timeout_x = 120000;
        service.SessionHeader.sessionId = userinfo.getSessionId();
        GFSMetadataService.ApprovalProcess approvalProcess = new GFSMetadataService.ApprovalProcess();
        approvalProcess.fullName = 'Deployment_Request__c.DR_Production_Approval1';
        approvalProcess.label = 'DR Production Approval1';
        approvalProcess.active = false;
        approvalProcess.allowRecall = true; 
        approvalProcess.showApprovalHistory = true;
        approvalProcess.recordEditability = 'AdminOnly';
        approvalProcess.finalApprovalRecordLock = false; 
        approvalProcess.finalRejectionRecordLock = false;
        approvalProcess.showApprovalHistory = false;
        
        GFSMetadataService.WorkflowFieldUpdate fldUpdate = new GFSMetadataService.WorkflowFieldUpdate();
        fldUpdate.field = 'Stage_txt__c';
        fldUpdate.name = 'Update_Stage_equals_EBiZ_FBO_Review';
        fldUpdate.fullName = 'Deployment_Request__c.Update_Stage_equals_EBiZ_FBO_Review';
        fldUpdate.protected_x = false;
        fldUpdate.notifyAssignee = false;
        fldUpdate.operation = 'Formula';
        fldUpdate.formula = '"EBiZ/FBO Review"';
        List<GFSMetadataService.SaveResult> results = service.createMetadata( new GFSMetadataService.Metadata[] { fldUpdate });
        system.debug('>>>>>>>results:'+results);
        
        //initial submission action
        GFSMetadataService.WorkflowActionReference initAction = new GFSMetadataService.WorkflowActionReference();
        initAction.name = 'Update_Stage_equals_EBiZ_FBO_Review';
        initAction.type_x = 'FieldUpdate';
        
        GFSMetadataService.ApprovalAction appAction = new GFSMetadataService.ApprovalAction();
        appAction.action = new list<GFSMetadataService.WorkflowActionReference>{initAction};
            
        approvalProcess.initialSubmissionActions = appAction;
        //Entry Criteria
        GFSMetadataService.FilterItem ft = new GFSMetadataService.FilterItem();
        ft.field = 'Deployment_Request__c.Target_Environment_txt__c';
        ft.operation = 'equals';
        ft.value = 'Production';
        
        GFSMetadataService.ApprovalEntryCriteria entry =  new GFSMetadataService.ApprovalEntryCriteria();
        entry.criteriaItems = new list<GFSMetadataService.FilterItem>{ft};
        approvalProcess.entryCriteria = entry;   
        
        GFSMetadataService.ApprovalSubmitter submitter1 = new GFSMetadataService.ApprovalSubmitter();
        submitter1.type_x = 'owner';
        approvalProcess.allowedSubmitters = new list<GFSMetadataService.ApprovalSubmitter>{submitter1};

        GFSMetadataService.ApprovalStepRejectBehavior taRejectBehave = new GFSMetadataService.ApprovalStepRejectBehavior();
        taRejectBehave.type_x = 'RejectRequest';
        
        //create field updates for steps
        GFSMetadataService.WorkflowFieldUpdate testReviewfldUpdate = new GFSMetadataService.WorkflowFieldUpdate();
        testReviewfldUpdate.field = 'Stage_txt__c';
        testReviewfldUpdate.name = 'Update_Stage_equals_TEST_Review';
        testReviewfldUpdate.fullName = 'Deployment_Request__c.Update_Stage_equals_TEST_Review';
        testReviewfldUpdate.protected_x = false;
        testReviewfldUpdate.notifyAssignee = false;
        testReviewfldUpdate.operation = 'Formula';
        testReviewfldUpdate.formula = '"TEST Review"';

        GFSMetadataService.WorkflowFieldUpdate sodReviewfldUpdate = new GFSMetadataService.WorkflowFieldUpdate();
        sodReviewfldUpdate.field = 'Stage_txt__c';
        sodReviewfldUpdate.name = 'Update_Stage_equals_SOD_Review';
        sodReviewfldUpdate.fullName = 'Deployment_Request__c.Update_Stage_equals_SOD_Review';
        sodReviewfldUpdate.protected_x = false;
        sodReviewfldUpdate.notifyAssignee = false;
        sodReviewfldUpdate.operation = 'Formula';
        sodReviewfldUpdate.formula = '"SOD Review"';

        GFSMetadataService.WorkflowFieldUpdate cabReviewfldUpdate = new GFSMetadataService.WorkflowFieldUpdate();
        cabReviewfldUpdate.field = 'Stage_txt__c';
        cabReviewfldUpdate.name = 'Update_Stage_equals_CAB_Review';
        cabReviewfldUpdate.fullName = 'Deployment_Request__c.Update_Stage_equals_CAB_Review';
        cabReviewfldUpdate.protected_x = false;
        cabReviewfldUpdate.notifyAssignee = false;
        cabReviewfldUpdate.operation = 'Formula';
        cabReviewfldUpdate.formula = '"CAB Review"';
        
        List<GFSMetadataService.SaveResult> results2 = service.createMetadata( new GFSMetadataService.Metadata[] {testReviewfldUpdate,sodReviewfldUpdate,cabReviewfldUpdate});
        system.debug('>>>>>>>>>>>results2:'+results2);
        
        approvalProcess.approvalStep = new list<GFSMetadataService.ApprovalStep>();
        integer i = 0, j = 0;
        
        for(string key: appNameListOfRoles.keySet())
            j += appNameListOfRoles.get(key).size();
        
        for(string key: appNameListOfRoles.keySet()){
            for(string role: appNameListOfRoles.get(key)){
                i++;
                GFSMetadataService.Approver otherapprover = new GFSMetadataService.Approver();
                string str = key.replaceAll(' ','_');
                string srole = role.replace('/','_').toUpperCase();
                otherapprover.name = 'DR_'+str+'_'+srole;
                otherapprover.type_x ='queue';
                
                GFSMetadataService.ApprovalStepApprover otherstepApprover= new GFSMetadataService.ApprovalStepApprover();
                otherstepApprover.approver = new list<GFSMetadataService.Approver>{otherapprover};
                otherstepApprover.whenMultipleApprovers = 'Unanimous';
    
                //Entry Criteria
                GFSMetadataService.FilterItem otherFilterEntry = new GFSMetadataService.FilterItem();
                if(key == 'Default'){
                    otherFilterEntry.field = 'Deployment_Request__c.Application_Category_txt__c';
                    otherFilterEntry.operation = 'equals';
                    otherFilterEntry.value = 'Standard Apps';            
                } else {
                    otherFilterEntry.field = 'Deployment_Request__c.Application_Name_txt__c';
                    otherFilterEntry.operation = 'equals';
                    otherFilterEntry.value = key;
                }
                
                GFSMetadataService.ApprovalEntryCriteria otherentry =  new GFSMetadataService.ApprovalEntryCriteria();
                otherentry.criteriaItems = new list<GFSMetadataService.FilterItem>{otherFilterEntry};
                    
                GFSMetadataService.ApprovalStep otherApprovalStep = new GFSMetadataService.ApprovalStep();                
                otherApprovalStep.name=str+'Approval'+srole;
                system.debug('>>>>>>>>>>otherApprovalStep.name:'+otherApprovalStep.name);
                otherApprovalStep.label=key+' Approval '+role;
                otherApprovalStep.allowDelegate= true;
                otherApprovalStep.rejectBehavior = taRejectBehave;
                otherApprovalStep.entryCriteria = otherentry;

                //Approval Step Action
                system.debug('>>>>>>>>>>>>>role:'+role);
                if(role != 'CAB'){
                    GFSMetadataService.WorkflowActionReference fldupdateStepAction = new GFSMetadataService.WorkflowActionReference();
                    if(role == 'EBiZ/FBO')
                        fldupdateStepAction.name = 'Update_Stage_equals_TEST_Review';
                    if(role == 'TEST')
                        fldupdateStepAction.name = 'Update_Stage_equals_SOD_Review';                
                    if(role == 'SOD')
                        fldupdateStepAction.name = 'Update_Stage_equals_CAB_Review';
                                            
                    fldupdateStepAction.type_x = 'FieldUpdate';                
                    GFSMetadataService.ApprovalAction appStepAction = new GFSMetadataService.ApprovalAction();
                    appStepAction.action = new list<GFSMetadataService.WorkflowActionReference>{fldupdateStepAction};                                
                    otherApprovalStep.approvalActions = appStepAction;
                }
                if(i != j)
                    otherApprovalStep.ifCriteriaNotMet = 'GotoNextStep';
                 
                otherApprovalStep.assignedApprover = otherstepApprover;
                approvalProcess.approvalStep.add(otherApprovalStep);                                                                        
            }
        } 
        
        List<GFSMetadataService.SaveResult> results1 = service.createMetadata( new GFSMetadataService.Metadata[] { approvalProcess });
        system.debug('>>>>>>>results:'+results1);                
    }
    
    @future(callout=true)
    public static void createUATApprovalProcess(){
        list<Application_Approver__c> newApprovers = [Select Id, name, User__c, Application_Name__c, Role__c from Application_Approver__c];
        map<string,list<string>> appNameListOfRoles = new map<string,list<string>>();
        for(Application_Approver__c approver: newApprovers){
            if(!appNameListOfRoles.containsKey(approver.Application_Name__c))
                appNameListOfRoles.put(approver.Application_Name__c, new list<string>{approver.Role__c});
            else 
                appNameListOfRoles.get(approver.Application_Name__c).add(approver.Role__c);
        }
        
        system.debug('>>>>>>appNameListOfRoles:'+appNameListOfRoles);

        GFSMetadataService.MetadataPort service = new GFSMetadataService.MetadataPort();   
        service.SessionHeader = new GFSMetadataService.SessionHeader_element();
        service.timeout_x = 120000;
        service.SessionHeader.sessionId = userinfo.getSessionId();
        GFSMetadataService.ApprovalProcess approvalProcess = new GFSMetadataService.ApprovalProcess();
        approvalProcess.fullName = 'Deployment_Request__c.DR_UAT_Approval1';
        approvalProcess.label = 'DR UAT Approval1';
        approvalProcess.active = false;
        approvalProcess.allowRecall = true; 
        approvalProcess.showApprovalHistory = true;
        approvalProcess.recordEditability = 'AdminOnly';
        approvalProcess.finalApprovalRecordLock = false; 
        approvalProcess.finalRejectionRecordLock = false;
        approvalProcess.showApprovalHistory = false;
        
        GFSMetadataService.WorkflowFieldUpdate fldUpdate = new GFSMetadataService.WorkflowFieldUpdate();
        fldUpdate.field = 'Stage_txt__c';
        fldUpdate.name = 'Update_Stage_equals_TFA_Review1';
        fldUpdate.fullName = 'Deployment_Request__c.Update_Stage_equals_TFA_Review1';
        fldUpdate.protected_x = false;
        fldUpdate.notifyAssignee = false;
        fldUpdate.operation = 'Formula';
        fldUpdate.formula = '"TFA Review"';
        List<GFSMetadataService.SaveResult> results = service.createMetadata( new GFSMetadataService.Metadata[] { fldUpdate });
        system.debug('>>>>>>>results:'+results);
        
        //initial submission action
        GFSMetadataService.WorkflowActionReference initAction = new GFSMetadataService.WorkflowActionReference();
        initAction.name = 'Update_Stage_equals_TFA_Review1';
        initAction.type_x = 'FieldUpdate';
        
        GFSMetadataService.ApprovalAction appAction = new GFSMetadataService.ApprovalAction();
        appAction.action = new list<GFSMetadataService.WorkflowActionReference>{initAction} ;
            
        approvalProcess.initialSubmissionActions = appAction;
        //Entry Criteria
        GFSMetadataService.FilterItem ft = new GFSMetadataService.FilterItem();
        ft.field = 'Deployment_Request__c.Target_Environment_txt__c';
        ft.operation = 'equals';
        ft.value = 'UAT';
        
        GFSMetadataService.ApprovalEntryCriteria entry =  new GFSMetadataService.ApprovalEntryCriteria();
        entry.criteriaItems = new list<GFSMetadataService.FilterItem>{ft};
        approvalProcess.entryCriteria = entry;   
        
        GFSMetadataService.ApprovalSubmitter submitter1 = new GFSMetadataService.ApprovalSubmitter();
        submitter1.type_x = 'owner';
        approvalProcess.allowedSubmitters = new list<GFSMetadataService.ApprovalSubmitter>{submitter1};

        approvalProcess.approvalStep = new list<GFSMetadataService.ApprovalStep>();
        
        //TFA Step
        GFSMetadataService.Approver tfaapprover = new GFSMetadataService.Approver();
        tfaapprover.name = 'Deployment_Request__c.TFA_Review_User__c';
        tfaapprover.type_x ='relatedUserField';
        
        GFSMetadataService.ApprovalStepApprover tfastepApprover = new GFSMetadataService.ApprovalStepApprover();
        tfastepApprover.approver = new list<GFSMetadataService.Approver>{tfaapprover};
        tfastepApprover.whenMultipleApprovers = 'Unanimous';
            
        GFSMetadataService.ApprovalStep approvalTFAStep = new GFSMetadataService.ApprovalStep();
        approvalTFAStep.name='TFA_Approval';
        approvalTFAStep.label='TFA Approval';
        approvalTFAStep.allowDelegate= true;
        approvalTFAStep.assignedApprover = tfastepApprover;

        //field update 
        GFSMetadataService.WorkflowFieldUpdate tafldUpdate = new GFSMetadataService.WorkflowFieldUpdate();
        tafldUpdate.field = 'Stage_txt__c';
        tafldUpdate.name = 'Update_Stage_equals_TA_Review';
        tafldUpdate.fullName = 'Deployment_Request__c.Update_Stage_equals_TA_Review';
        tafldUpdate.protected_x = false;
        tafldUpdate.notifyAssignee = false;
        tafldUpdate.operation = 'Formula';
        tafldUpdate.formula = '"TA Review"';
        List<GFSMetadataService.SaveResult> results1 = service.createMetadata( new GFSMetadataService.Metadata[] { tafldUpdate });
        system.debug('>>>>>>>results:'+results1);
        
        //initial submission action
        GFSMetadataService.WorkflowActionReference taAction = new GFSMetadataService.WorkflowActionReference();
        taAction.name = 'Update_Stage_equals_TA_Review';
        taAction.type_x = 'FieldUpdate';
        
        GFSMetadataService.ApprovalAction taStepAction = new GFSMetadataService.ApprovalAction();
        taStepAction.action = new list<GFSMetadataService.WorkflowActionReference>{taAction} ;
                
        approvalTFAStep.approvalActions = taStepAction;
        approvalProcess.approvalStep.add(approvalTFAStep);
        
        //TA Step
        GFSMetadataService.Approver taapprover= new GFSMetadataService.Approver();
        taapprover.name = 'Deployment_Request__c.TA_Review_User__c';
        taapprover.type_x ='relatedUserField';
        
        GFSMetadataService.ApprovalStepApprover tastepApprover= new GFSMetadataService.ApprovalStepApprover();
        tastepApprover.approver = new list<GFSMetadataService.Approver>{taapprover};
        tastepApprover.whenMultipleApprovers = 'Unanimous';
        
        GFSMetadataService.ApprovalStepRejectBehavior taRejectBehave = new GFSMetadataService.ApprovalStepRejectBehavior();
        taRejectBehave.type_x = 'RejectRequest';
        
        GFSMetadataService.ApprovalStep approvalTAStep = new GFSMetadataService.ApprovalStep();
        approvalTAStep.name='TA_Approval';
        approvalTAStep.label='TA Approval';
        approvalTAStep.allowDelegate= true;
        approvalTAStep.assignedApprover = tastepApprover;
        approvalTAStep.rejectBehavior = taRejectBehave;
        
        GFSMetadataService.WorkflowFieldUpdate cabfldUpdate = new GFSMetadataService.WorkflowFieldUpdate();
        cabfldUpdate.field = 'Stage_txt__c';
        cabfldUpdate.name = 'Update_Stage_equals_CAB_Review';
        cabfldUpdate.fullName = 'Deployment_Request__c.Update_Stage_equals_CAB_Review';
        cabfldUpdate.protected_x = false;
        cabfldUpdate.notifyAssignee = false;
        cabfldUpdate.operation = 'Formula';
        cabfldUpdate.formula = '"CAB Review"';
        List<GFSMetadataService.SaveResult> results2 = service.createMetadata( new GFSMetadataService.Metadata[] { cabfldUpdate });
        system.debug('>>>>>>>results:'+results2);
        
        //initial submission action
        GFSMetadataService.WorkflowActionReference cabAction = new GFSMetadataService.WorkflowActionReference();
        cabAction.name = 'Update_Stage_equals_CAB_Review';
        cabAction.type_x = 'FieldUpdate';
        
        GFSMetadataService.ApprovalAction cabStepAction = new GFSMetadataService.ApprovalAction();
        cabStepAction.action = new list<GFSMetadataService.WorkflowActionReference>{cabAction} ;
        
        approvalTAStep.approvalActions = cabStepAction;
                
        approvalProcess.approvalStep.add(approvalTAStep);
        
        GFSMetadataService.WorkflowFieldUpdate approvedfldUpdate = new GFSMetadataService.WorkflowFieldUpdate();
        approvedfldUpdate.field = 'Stage_txt__c';
        approvedfldUpdate.name = 'Update_Stage_equals_Approved';
        approvedfldUpdate.fullName = 'Deployment_Request__c.Update_Stage_equals_Approved';
        approvedfldUpdate.protected_x = false;
        approvedfldUpdate.notifyAssignee = false;
        approvedfldUpdate.operation = 'Formula';
        approvedfldUpdate.formula = '"Approved"';
        List<GFSMetadataService.SaveResult> approvedResults = service.createMetadata( new GFSMetadataService.Metadata[] { approvedfldUpdate });
        
        integer i=0;
        for(string key: appNameListOfRoles.keySet()){
            i++;
            //other Steps
            GFSMetadataService.Approver otherapprover = new GFSMetadataService.Approver();
            string str = key.replaceAll(' ','_');
            otherapprover.name = 'DR_'+str+'_CAB';
            otherapprover.type_x ='queue';
            
            GFSMetadataService.ApprovalStepApprover otherstepApprover= new GFSMetadataService.ApprovalStepApprover();
            otherstepApprover.approver = new list<GFSMetadataService.Approver>{otherapprover};
            otherstepApprover.whenMultipleApprovers = 'Unanimous';

            //Entry Criteria
            GFSMetadataService.FilterItem otherFilterEntry = new GFSMetadataService.FilterItem();
            if(key == 'Default'){
                otherFilterEntry.field = 'Deployment_Request__c.Application_Category_txt__c';
                otherFilterEntry.operation = 'equals';
                otherFilterEntry.value = 'Standard Apps';            
            } else {
                otherFilterEntry.field = 'Deployment_Request__c.Application_Name_txt__c';
                otherFilterEntry.operation = 'equals';
                otherFilterEntry.value = key;
            }
            
            GFSMetadataService.ApprovalEntryCriteria otherentry =  new GFSMetadataService.ApprovalEntryCriteria();
            otherentry.criteriaItems = new list<GFSMetadataService.FilterItem>{otherFilterEntry};
            
            GFSMetadataService.ApprovalStep otherApprovalStep = new GFSMetadataService.ApprovalStep();
            otherApprovalStep.name=str+'_Approval';
            otherApprovalStep.label=key+' Approval';
            otherApprovalStep.allowDelegate= true;
            otherApprovalStep.rejectBehavior = taRejectBehave;
            otherApprovalStep.entryCriteria = otherentry;
            if(i != appNameListOfRoles.size())
                otherApprovalStep.ifCriteriaNotMet = 'GotoNextStep';
            otherApprovalStep.assignedApprover = otherstepApprover;
            
            //field update action                          
            GFSMetadataService.WorkflowActionReference approvedAction = new GFSMetadataService.WorkflowActionReference();
            approvedAction.name = 'Update_Stage_equals_Approved';
            approvedAction.type_x = 'FieldUpdate';
            
            GFSMetadataService.ApprovalAction approvedStepAction = new GFSMetadataService.ApprovalAction();
            approvedStepAction.action = new list<GFSMetadataService.WorkflowActionReference>{approvedAction} ;
                    
            otherApprovalStep.approvalActions = approvedStepAction;                
            approvalProcess.approvalStep.add(otherApprovalStep);                                                
        }
        List<GFSMetadataService.SaveResult> results3 = service.createMetadata( new GFSMetadataService.Metadata[] { approvalProcess });
        system.debug('>>>>>>>results:'+results3);    
    }
    
    @future
    public static void createQueuesAndMembers(set<string> queueNames, list<Id> approverIds){
        list<Application_Approver__c> newApprovers = [Select Id, name, User__c, Application_Name__c, Role__c from Application_Approver__c where Id IN :approverIds];
        //get existing queues
        list<Group> extQueues = [Select Id, name from Group where Name in :queueNames];
        map<string, Id> extqueueMap = new map<string, Id>();
        for(Group g :extQueues)
            extqueueMap.put(g.Name, g.Id);
            
        list<Group> newGroups = new list<Group>();            
        for(string q :queueNames){ 
            if(!extqueueMap.containsKey(q)){
                Group g = new Group(Type='Queue', Name=q);
                newGroups.add(g);
            }            
        }
        insert newGroups;
        
        //create Queues
        list<QueueSObject> newQueues = new list<QueueSObject>();    
        for(Group g :newGroups){
            QueueSObject q = new QueueSObject(SobjectType='Deployment_Request__c', QueueId=g.Id);
            newQueues.add(q);
        }        
        insert newQueues;
        
        //insert Group members
        extQueues = [Select Id, name from Group where Name in :queueNames];
        extqueueMap = new map<string, Id>();
        for(Group g :extQueues)
            extqueueMap.put(g.Name, g.Id);
        
        //insert group members
        list<GroupMember> newMembers = new list<GroupMember>();            
        for(Application_Approver__c nApprover :newApprovers){
            if(extqueueMap.containsKey('DR '+nApprover.Application_Name__c+' '+nApprover.Role__c)){
                GroupMember member = new GroupMember();
                member.UserOrGroupId = nApprover.User__c;
                member.GroupId = extqueueMap.get('DR '+nApprover.Application_Name__c+' '+nApprover.Role__c);
                newMembers.add(member);
            }
        }        
        insert newMembers;    
    }
    
    public void add(){
        //add value to the picklist field
        try{
            if(newpicklistVal != null){
                GFSMetadataService.MetadataPort service = new GFSMetadataService.MetadataPort();   
                service.SessionHeader = new GFSMetadataService.SessionHeader_element();
                service.timeout_x = 120000;
                service.SessionHeader.sessionId = userinfo.getSessionId();
                GFSMetadataService.CustomField customField = new GFSMetadataService.CustomField();
                GFSMetadataService.PickListValue[] pickVals = new list<GFSMetadataService.PickListValue>();
                GFSMetadataService.PickListValue[] newpickVals = new list<GFSMetadataService.PickListValue>();
                customField = (GFSMetadataService.CustomField) service.readMetadata('CustomField', new String[] { 'DR_Configuration__c.'+picklistName}).getRecords()[0];
                pickVals = customField.picklist.picklistValues;
                system.debug('>>>>>>>pickVals :'+pickVals);
                list<string> splittedPicklist = newpicklistVal.split('\r\n');
                system.debug('>>>>>>>splittedPicklist:'+splittedPicklist);
                for(string str: splittedPicklist){
                    GFSMetadataService.PicklistValue two = new GFSMetadataService.PicklistValue();
                    two.fullName= str;
                    two.default_x=false;   
                    customField.picklist.picklistValues.add(two);
                    newpickVals.add(two);            
                }
                List<GFSMetadataService.SaveResult> results2 = service.updateMetadata(new GFSMetadataService.Metadata[] { customField });
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,'Picklist values added successfully'));
            }     
        }catch(Exception ex){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,ex.getMessage()));
        }   
    }
    
    public void save(){
        upsert config;
        
        list<Application_Approver__c> appApprovers = new list<Application_Approver__c>();

        upsert appApprovers;
        
        set<Id> appIds = new set<Id>();
        for(Application_Approver__c approver :appApprovers){
            appIds.add(approver.Id);                    
        }
        
        //updateDRQueues(appIds);
        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,'DR Configurations saved successfully'));
    }   
}