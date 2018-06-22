public class DRConfigurationController1{
    
    public list<SelectOption> picklistValues{get; set;}
    public string picklistName{get; set;}
    public string newpicklistVal{get; set;}
    public string serverURL{get; set;}
    
    public DR_Configuration__c config{get; set;}
    
    public string customObjectId{get; set;}       
    public string dependentFieldVal{get; set;}
    public string controllingFieldVal{get; set;}
    public boolean isNewAppSelected{get; set;}
    
    public string applicationName{get; set;}
    public list<SelectOption> appNames{get; set;}
    public string newAppName{get; set;}
    public boolean rndrCrtApprov {get;set;}
    public static boolean isUATProcCreated;
    public static boolean isProdProcCreated;
    public string apprvlMssg {get;set;}

    public List<string> leftselected{get;set;}
    public List<string> rightselected{get;set;}
    Set<string> leftvalues = new Set<string>();
    Set<string> rightvalues = new Set<string>();    

    private set<string> newlyAddedValues;
    private set<string> removedValues;        
    public class PicklistWrapper{
        public string pickLabel{get; set;}
        public string pickValue{get; set;}
        
        public PicklistWrapper(string pv, string pl){
            pickLabel = pl;
            pickValue = pv;
        }
    }
    public list<PicklistWrapper> extPicklistValues{get; set;}
    public string oldpicklistVal{get; set;}
    
    public class DRApproverWrapper{
        public Application_Approver__c approverObj{get; set;}        
        public string queueName{get; set;}
        public boolean deleteflag{get; set;}
    }    
    public list<DRApproverWrapper> approvers{get; set;}
        
    public DRConfigurationController1(){
        picklistValues = new list<SelectOption>();  
        config = new DR_Configuration__c();
        list<DR_Configuration__c> configurations = [Select Id, Name, Additional_Notes__c, Application_Category__c, Application_Name__c, ApproverSubmitter_Check__c, Change_Type__c, Deployment_Status__c, Is_Code_Review_Completed__c,
                            Is_TA_Review_Completed__c, Is_TFA_Review_Completed__c, Request_Type__c, Review_Status__c, Risk_Start_Approver1__c, Risk_Start_Approver2__c, Risk_Start_Approver3__c,Opty_CAB_Approver__c,Opty_Internal_Control_Approver__c,
                            RMA_Approver1__c, RMA_Approver2__c, RMA_Approver3__c, Source_Environment__c, Stage__c, Standard_Apps_Approver1__c, Standard_Apps_Approver2__c, Standard_Apps_Approver3__c,Opty_FBO_EBiZ_Approver__c,Account_CAB_Approver__c,
                            Support_KT_Status__c, System_Affected__c, Target_Environment__c, Wafer_Write_Off_Approver1__c, Wafer_Write_Off_Approver2__c, Wafer_Write_Off_Approver3__c,Account_Internal_Control__c,Account_FBO_EBiZ_Approver__c, Admin_Email__c 
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
        
        List<ToolingAPI.CustomObject> customObjects = new list<ToolingAPI.CustomObject>();
        if(!Test.isRunningTest()){
            customObjects = (List<ToolingAPI.CustomObject>)
            toolingAPI.query('Select Id, DeveloperName, NamespacePrefix From CustomObject Where DeveloperName = \'DR_Configuration\'').records;         
            // Query CustomField object by TableEnumOrId (use CustomObject Id not name for Custom Objects)
            ToolingAPI.CustomObject customObject = customObjects[0];
            customObjectId = customObject.Id;
            customObjectId = customObjectId.substring(0,15);
        }
        
        /*
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
        */
        
        apprvlMssg = ApexPages.currentPage().getParameters().get('mssg');
        
        String Host = ApexPages.currentPage().getHeaders().get('Host');

        map<string, string> sandboxMap  = new map<string, string>() ;
        sandboxMap.put('preprod','preprod');
                  
        Organization org = [select id,IsSandbox,InstanceName from Organization limit 1];   
        String objectEndpointURL = 'https://'+Host;
        string sandboxNameold = '',sandboxNameNew = '';
        if(org.IsSandbox){
            sandboxNameold = UserInfo.getUserName().substringAfterLast('.');   
            if(sandboxMap.containsKey(sandboxNameold))
                sandboxNameNew = sandboxMap.get(sandboxNameold);
            
            serverURL = 'https://globalfoundries--'+sandboxNameNew+'.'+org.InstanceName.tolowercase()+'.my.salesforce.com';
        }else{
            serverURL = URL.getSalesforceBaseUrl().toExternalForm().split('visual.force.com')[0];
            if(serverURL.indexOf('gfsdr'+'.') > 0)
                serverURL = 'https://'+serverURL.split('gfsdr'+'.')[1]+'salesforce.com';
            else
                serverURL += 'salesforce.com';
        } 
        
        
 
        approvers = new list<DRApproverWrapper>();
        
        appNames = new list<SelectOption>();
        set<string> aNames = new set<string>();
    //     Map<Id,Profile> profileIds = new Map<id,profile>([SELECT Id,UserLicenseId FROM Profile where UserLicenseId in (SELECT Id FROM UserLicense where name ='Salesforce')]); 
    //     List<user> standardProfileUsers = [select id from user where profileId in:profileIds.Keyset()];

        
        
        list<Application_Approver__c> existingApprovers = [Select Id, name, GFSDR__User__c , Application_Name__c, Role__c from Application_Approver__c ];
        for(Application_Approver__c appApprover: existingApprovers)
            aNames.add(appApprover.Application_Name__c);
        appNames.add(new SelectOption('','--None--'));
        for(string n: aNames)
            appNames.add(new SelectOption(n,n));
        appNames.add(new SelectOption('New Application', 'New Application'));
        
        leftvalues = new set<string>();
        rightvalues = new set<string>();
        
        newlyAddedValues = new set<string>();
        removedValues = new set<string>();      
        isUATProcCreated = false ;
        isProdProcCreated = false ;
        
        if(apprvlMssg == 'Approvers added successfully'){
           
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.INFO,'Approvers added successfully'));
        }   
         
    }
    
    public PageReference selectclick(){
        rightselected.clear();
        for(String s : leftselected){
            leftvalues.remove(s);
            rightvalues.add(s);
            newlyAddedValues.add(s); 
        }
        return null;
    }
         
    public PageReference unselectclick(){
        leftselected.clear();
        for(String s : rightselected){
            rightvalues.remove(s);
            leftvalues.add(s);
            removedValues.add(s);
        }
        return null;
    }     

    public List<SelectOption> getunSelectedValues(){
        List<SelectOption> options = new List<SelectOption>();
        List<string> tempList = new List<String>();
        tempList.addAll(leftvalues);
        tempList.sort();
        for(string s : tempList)
            options.add(new SelectOption(s,s));
        return options;
    }
     
    public List<SelectOption> getSelectedValues(){
        List<SelectOption> options1 = new List<SelectOption>();
        List<string> tempList = new List<String>();
        tempList.addAll(rightvalues);
        tempList.sort();
        for(String s : tempList)
            options1.add(new SelectOption(s,s));
        return options1;
    }      
        
    public void addApplication(){
        approvers = new list<DRApproverWrapper>();
        rndrCrtApprov = true;
        if(applicationName != 'New Application'){
            isNewAppSelected = false;
            list<Application_Approver__c> existingApprovers = [Select Id, name, User__c, Application_Name__c, Role__c from Application_Approver__c where Application_Name__c  = :applicationName order by name];
            if(existingApprovers.size() > 0){
                for(Application_Approver__c approver :existingApprovers){
                    DRApproverWrapper wrapper = new DRApproverWrapper();
                    wrapper.approverObj = approver;
                    wrapper.deleteFlag = false;
                    approvers.add(wrapper);
                }
            }else {
                for(Integer i=0; i<4; i++){
                    DRApproverWrapper wrapper = new DRApproverWrapper();
                    wrapper.approverObj = new Application_Approver__c();
                    wrapper.approverObj.Application_Name__c = applicationName;
                    wrapper.deleteFlag = false;
                    approvers.add(wrapper);
                }
            }
        }else{
            isNewAppSelected = true;            
        }
    }

    public void addNewApplication(){
        approvers = new list<DRApproverWrapper>();        
        for(Integer i=0; i<4; i++){
            DRApproverWrapper wrapper = new DRApproverWrapper();
            wrapper.approverObj = new Application_Approver__c();
            wrapper.approverObj.Application_Name__c = newAppName;
            approvers.add(wrapper);
        }
    }
    
    public void selectPicklistField(){
        //fetch existing picklist values
        extPicklistValues = new list<PicklistWrapper>(); 
        rightvalues = new set<string>();
        system.debug('>>>>>>>>>>picklistName:'+picklistName);
        Map<String, Schema.SObjectField> drfieldsMap =  Schema.SObjectType.DR_Configuration__c.fields.getMap();
        for(Schema.SObjectField field : drfieldsMap.values()){
            if(field.getDescribe().getName() == picklistName){
                List<Schema.PicklistEntry> ple = field.getDescribe().getPicklistValues();   
                for(Schema.PicklistEntry p: ple){
                    extPicklistValues.add(new PicklistWrapper(p.getValue(),p.getLabel()));
                    rightvalues.add(p.getLabel());
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

    public pagereference saveApprovers(){
        //fetch existing approvers
        //list<Application_Approver__c> extapprovers = [Select Id, name, User__c, Application_Name__c, Role__c from Application_Approver__c where Application_Name__c = :applicationName];
        //delete extapprovers;
        
        list<Application_Approver__c> newApprovers = new list<Application_Approver__c>();
        list<Application_Approver__c> tobeDeletedApprovers = new list<Application_Approver__c>();
        set<string> queueNames = new set<string>();
        for(DRApproverWrapper  wrapper :approvers){            
            if(wrapper.approverObj.User__c != null && wrapper.approverObj.Role__c != null){
                if(wrapper.deleteFlag == false){
                    newApprovers.add(wrapper.approverObj);
                    queueNames.add('DR '+wrapper.approverObj.Application_Name__c+' '+wrapper.approverObj.Role__c.toUpperCase());
                }else {
                    tobeDeletedApprovers.add(wrapper.approverObj);
                }
            }
        }        
        upsert newApprovers;
        delete tobeDeletedApprovers;
        list<Id> newApproversIds = new list<Id>();
        for(Application_Approver__c approver :newApprovers)
            newApproversIds.add(approver.Id);
            
        createQueuesAndMembers(queueNames,newApproversIds);
        //createUATApprovalProcess();      
       // ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,'Approvers added successfully'));
        PageReference pgRef = new PageReference('/apex/DRConfiguration1');
        pgRef.getParameters().put('mssg', 'Approvers added successfully');
        pgRef.setRedirect(true);
        return pgRef;

    }
    
    public void createApprovalProcesses(){
        
        String updApplicationName = ApplicationName.replaceAll(' ', '_');
        String appName = 'DR UAT Approval'+'_'+ updApplicationName;
        system.debug('-appName-'+appName);
        
        List<ProcessDefinition> prDfLst = new List<ProcessDefinition>();
        prDfLst = [SELECT Id,LockType,Name,State,TableEnumOrId,Type FROM ProcessDefinition WHERE TableEnumOrId = 'GFSDR__Deployment_Request__c' and state= 'Active' and Name =:appName];
            
        if(prDfLst.size() == 0){
            system.debug('-applicationName-'+applicationName);  
            createUATApprovlProcess(userinfo.getSessionId(),applicationName); 
            createProductionApprovlProcess(userinfo.getSessionId(),applicationName);   
            
        }else{
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'Approval Process Already Exist.'));    
        }    
    }
    
    public static void deactivateExistingApprovalProcesses(string sessionId){   
        GFSMetadataService.MetadataPort service = new GFSMetadataService.MetadataPort();   
        service.SessionHeader = new GFSMetadataService.SessionHeader_element();
        service.timeout_x = 120000;
        service.SessionHeader.sessionId = sessionId;//userinfo.getSessionId();
        List<GFSMetadataService.DeleteResult> results = service.deleteMetadata('ApprovalProcess', new String[] { 'Deployment_Request__c.DR_Production_Approval1' });
        List<GFSMetadataService.DeleteResult> results1 = service.deleteMetadata('ApprovalProcess', new String[] { 'Deployment_Request__c.DR_UAT_Approval1' });
        system.debug('>>>>>>>>results:'+results);
        system.debug('>>>>>>>>results1:'+results1);
    }
    
     @future(callout=true)
    public static void createUATApprovlProcess(string sessionId, String ApplicationName){
    
        try{
            list<Application_Approver__c> newApprovers = [Select Id, name, User__c, Application_Name__c, Role__c from Application_Approver__c where Application_Name__c=: ApplicationName order by Name];
            map<string,set<string>> appNameListOfRoles = new map<string,set<string>>();
            String updApplicationName = ApplicationName.replaceAll(' ', '_');
            
            for(Application_Approver__c approver: newApprovers){
                if(!appNameListOfRoles.containsKey(approver.Application_Name__c))
                    appNameListOfRoles.put(approver.Application_Name__c, new set<string>{approver.Role__c});
                else 
                    appNameListOfRoles.get(approver.Application_Name__c).add(approver.Role__c);
            }
                        
        GFSMetadataService.MetadataPort service = new GFSMetadataService.MetadataPort();   
        service.SessionHeader = new GFSMetadataService.SessionHeader_element();
        service.timeout_x = 120000;
        service.SessionHeader.sessionId = sessionId;//userinfo.getSessionId();
        GFSMetadataService.ApprovalProcess approvalProcess = new GFSMetadataService.ApprovalProcess();
        approvalProcess.fullName = 'GFSDR__Deployment_Request__c.DR_UAT_Approval'+'_'+ updApplicationName;
        approvalProcess.label = 'DR UAT Approval'+'_'+ updApplicationName;
        approvalProcess.active = true;
        approvalProcess.allowRecall = true; 
        approvalProcess.showApprovalHistory = true;
        approvalProcess.recordEditability = 'AdminOnly';
        approvalProcess.finalApprovalRecordLock = false; 
        approvalProcess.finalRejectionRecordLock = false;
        approvalProcess.showApprovalHistory = false;
        approvalProcess.emailTemplate = 'Deployment_Request_Templates/Deployment_Approval_Request_Email';
        
        GFSMetadataService.WorkflowFieldUpdate fldUpdate = new GFSMetadataService.WorkflowFieldUpdate();
        fldUpdate.field = 'GFSDR__Stage_txt__c';
        fldUpdate.name = 'Update_Stage_equals_TFA_Review1';
        fldUpdate.fullName = 'GFSDR__Deployment_Request__c.Update_Stage_equals_TFA_Review1';
        fldUpdate.protected_x = false;
        fldUpdate.notifyAssignee = false;
        fldUpdate.operation = 'Formula';
        fldUpdate.formula = '"TFA Review"';
        
        if(!Test.isRunningTest()){
            List<GFSMetadataService.SaveResult> results = service.createMetadata( new GFSMetadataService.Metadata[] { fldUpdate });
            system.debug('>>>>>>>results:'+results);
        }
        
        //Recall Approval Process 
        GFSMetadataService.WorkflowFieldUpdate fldrecllUpdate = new GFSMetadataService.WorkflowFieldUpdate();
        fldrecllUpdate.field = 'GFSDR__TA_Approver_Name__c';
        fldrecllUpdate.name = 'Update_TA_Approver_Name';
        fldrecllUpdate.fullName = 'GFSDR__Deployment_Request__c.Update_TA_Approver_Name';
        fldrecllUpdate.protected_x = false;
        fldrecllUpdate.notifyAssignee = false;
        fldrecllUpdate.operation = 'Formula';
        fldrecllUpdate.formula = '" "';
        
        GFSMetadataService.WorkflowFieldUpdate fldrecllUpdate2 = new GFSMetadataService.WorkflowFieldUpdate();
        fldrecllUpdate2.field = 'GFSDR__TFA_Approver_Name__c';
        fldrecllUpdate2.name = 'Update_TFA_Approver_Name';
        fldrecllUpdate2.fullName = 'GFSDR__Deployment_Request__c.Update_TFA_Approver_Name';
        fldrecllUpdate2.protected_x = false;
        fldrecllUpdate2.notifyAssignee = false;
        fldrecllUpdate2.operation = 'Formula';
        fldrecllUpdate2.formula = '" "';
        
        
        GFSMetadataService.WorkflowFieldUpdate fldrecllUpdate3 = new GFSMetadataService.WorkflowFieldUpdate();
        fldrecllUpdate3.field = 'GFSDR__Stage_txt__c';
        fldrecllUpdate3.name = 'Update_Stage_to_Draft';
        fldrecllUpdate3.fullName = 'GFSDR__Deployment_Request__c.Update_Stage_to_Draft';
        fldrecllUpdate3.protected_x = false;
        fldrecllUpdate3.notifyAssignee = false;
        fldrecllUpdate3.operation = 'Formula';
        fldrecllUpdate3.formula = '"Draft"';
         
        if(!Test.isRunningTest()){
            List<GFSMetadataService.SaveResult> results = service.createMetadata( new GFSMetadataService.Metadata[] {fldrecllUpdate,fldrecllUpdate2,fldrecllUpdate3});
            system.debug('>>>>>>>results:'+results);
        }   
        
        
                //initial submission action
        GFSMetadataService.WorkflowActionReference initAction = new GFSMetadataService.WorkflowActionReference();
        initAction.name = 'Update_Stage_equals_TFA_Review1';
        initAction.type_x = 'FieldUpdate';
        
        //Recall Field Update
        GFSMetadataService.WorkflowActionReference recllAction = new GFSMetadataService.WorkflowActionReference();
        recllAction.name = 'Update_TA_Approver_Name';
        recllAction.type_x = 'FieldUpdate';
        
        GFSMetadataService.WorkflowActionReference recllAction2 = new GFSMetadataService.WorkflowActionReference();
        recllAction2.name = 'Update_TFA_Approver_Name';
        recllAction2.type_x = 'FieldUpdate';
        
        GFSMetadataService.WorkflowActionReference recllAction3 = new GFSMetadataService.WorkflowActionReference();
        recllAction3.name = 'Update_Stage_to_Draft';
        recllAction3.type_x = 'FieldUpdate';
        
        GFSMetadataService.ApprovalAction appAction = new GFSMetadataService.ApprovalAction();
        appAction.action = new list<GFSMetadataService.WorkflowActionReference>{initAction} ;
        
        GFSMetadataService.ApprovalAction reappAction = new GFSMetadataService.ApprovalAction();
        reappAction.action = new list<GFSMetadataService.WorkflowActionReference>{recllAction,recllAction2,recllAction3};
            
        approvalProcess.initialSubmissionActions = appAction;
        approvalProcess.recallActions = reappAction;
        
        //Entry Criteria
        GFSMetadataService.FilterItem ft = new GFSMetadataService.FilterItem();
        ft.field = 'GFSDR__Deployment_Request__c.GFSDR__Application_Name_txt__c';
        ft.operation = 'equals';
        ft.value = ApplicationName;
        
        GFSMetadataService.ApprovalEntryCriteria entry =  new GFSMetadataService.ApprovalEntryCriteria();
        entry.criteriaItems = new list<GFSMetadataService.FilterItem>{ft};
        approvalProcess.entryCriteria = entry;   
        
        GFSMetadataService.ApprovalSubmitter submitter1 = new GFSMetadataService.ApprovalSubmitter();
        submitter1.type_x = 'owner';
        approvalProcess.allowedSubmitters = new list<GFSMetadataService.ApprovalSubmitter>{submitter1};

        approvalProcess.approvalStep = new list<GFSMetadataService.ApprovalStep>();
      //  approvalProcess.rejectionActions = new list<GFSMetadataService.rejectionActions>();
        
        //TFA Step
        GFSMetadataService.Approver tfaapprover = new GFSMetadataService.Approver();
        tfaapprover.name = 'GFSDR__Deployment_Request__c.GFSDR__TFA_Review_User__c';
        tfaapprover.type_x ='relatedUserField';
        
        GFSMetadataService.ApprovalStepApprover tfastepApprover = new GFSMetadataService.ApprovalStepApprover();
        tfastepApprover.approver = new list<GFSMetadataService.Approver>{tfaapprover};
        tfastepApprover.whenMultipleApprovers = 'Unanimous';
            
        GFSMetadataService.ApprovalStep approvalTFAStep = new GFSMetadataService.ApprovalStep();
        approvalTFAStep.name='TFA_Approval';
        approvalTFAStep.label='TFA Approval';
        approvalTFAStep.allowDelegate= true;
        approvalTFAStep.assignedApprover = tfastepApprover;
        
        
        /* GFSMetadataService.WorkflowFieldUpdate tfaReviewerfldUpdate = new GFSMetadataService.WorkflowFieldUpdate();
        tfaReviewerfldUpdate.field = 'TFA_Approver_Name__c';
        tfaReviewerfldUpdate.name = 'Update_DR_TFA_Reviewer';
        tfaReviewerfldUpdate.fullName = 'Deployment_Request__c.Update_DR_TFA_Reviewer';
        tfaReviewerfldUpdate.protected_x = false;
        tfaReviewerfldUpdate.notifyAssignee = false;
        tfaReviewerfldUpdate.operation = 'Formula';
        tfaReviewerfldUpdate.formula = '\"'+userinfo.getFirstName()+'\"'; */

        GFSMetadataService.WorkflowFieldUpdate taReviewerfldUpdate = new GFSMetadataService.WorkflowFieldUpdate();
        taReviewerfldUpdate.field = 'GFSDR__TFA_Approver_Name__c';
        taReviewerfldUpdate.name = 'Update_TFA_Approver';
        taReviewerfldUpdate.fullName = 'GFSDR__Deployment_Request__c.Update_TFA_Approver';
        taReviewerfldUpdate.protected_x = false;
        taReviewerfldUpdate.notifyAssignee = false;
        taReviewerfldUpdate.operation = 'Formula';        
        taReviewerfldUpdate.formula =  '$User.FirstName + $User.LastName';

        //field update 
        GFSMetadataService.WorkflowFieldUpdate tafldUpdate = new GFSMetadataService.WorkflowFieldUpdate();
        GFSMetadataService.WorkflowFieldUpdate taRjfldUpdate = new GFSMetadataService.WorkflowFieldUpdate();        
        
        tafldUpdate.field = 'GFSDR__Stage_txt__c';
        tafldUpdate.name = 'Update_Stage_equals_TA_Review';
        tafldUpdate.fullName = 'GFSDR__Deployment_Request__c.Update_Stage_equals_TA_Review';
        tafldUpdate.protected_x = false;
        tafldUpdate.notifyAssignee = false;
        tafldUpdate.operation = 'Formula';
        tafldUpdate.formula = '"TA Review"';
        
        
        taRjfldUpdate.field = 'GFSDR__Rejected_Stage__c';
        taRjfldUpdate.name = 'Update_Rejected_Stage_field';
        taRjfldUpdate.fullName = 'GFSDR__Deployment_Request__c.Update_Rejected_Stage_field';
        taRjfldUpdate.protected_x = false;
        taRjfldUpdate.notifyAssignee = false;
        taRjfldUpdate.operation = 'Formula';
        taRjfldUpdate.formula = '"TFA Review"';
                
        
        if(!Test.isRunningTest()){
            List<GFSMetadataService.SaveResult> results1 = service.createMetadata( new GFSMetadataService.Metadata[] { tafldUpdate,taReviewerfldUpdate,taRjfldUpdate});
            system.debug('>>>>>>>results:'+results1);
        }
        
        //tfa approval action
        GFSMetadataService.WorkflowActionReference taAction = new GFSMetadataService.WorkflowActionReference();
        GFSMetadataService.WorkflowActionReference taAction1 = new GFSMetadataService.WorkflowActionReference();
        
        GFSMetadataService.WorkflowActionReference taRjAction = new GFSMetadataService.WorkflowActionReference();
        
        
        taAction.name = 'Update_Stage_equals_TA_Review';
        taAction.type_x = 'FieldUpdate';
        
        taAction1.name = 'Update_TFA_Approver';
        taAction1.type_x = 'FieldUpdate';
        
        taRjAction.name = 'Update_Rejected_Stage_field';
        taRjAction.type_x = 'FieldUpdate';
    
        GFSMetadataService.ApprovalAction taStepAction = new GFSMetadataService.ApprovalAction();
        taStepAction.action = new list<GFSMetadataService.WorkflowActionReference>{taAction,taAction1} ;
        
        GFSMetadataService.ApprovalAction taRjStepAction = new GFSMetadataService.ApprovalAction();
        taRjStepAction.action = new list<GFSMetadataService.WorkflowActionReference>{taRjAction} ;
        
        GFSMetadataService.ApprovalProcess recallAction = new GFSMetadataService.ApprovalProcess();
                
                 
        approvalTFAStep.approvalActions  = taStepAction;
        approvalTFAStep.rejectionActions = taRjStepAction;
        
        approvalProcess.approvalStep.add(approvalTFAStep);
       // approvalProcess.approvalStep.add(approvalTFAStep);
        
        //TA Step
        GFSMetadataService.Approver taapprover= new GFSMetadataService.Approver();
        taapprover.name = 'GFSDR__Deployment_Request__c.GFSDR__TA_Review_User__c';
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
        cabfldUpdate.field = 'GFSDR__Stage_txt__c';
        cabfldUpdate.name = 'Update_Stage_equals_CAB_Review';
        cabfldUpdate.fullName = 'GFSDR__Deployment_Request__c.Update_Stage_equals_CAB_Review';
        cabfldUpdate.protected_x = false;
        cabfldUpdate.notifyAssignee = false;
        cabfldUpdate.operation = 'Formula';
        cabfldUpdate.formula = '"CAB Review"';
        
        GFSMetadataService.WorkflowFieldUpdate cabfldUpdate2 = new GFSMetadataService.WorkflowFieldUpdate();
        cabfldUpdate2.field = 'GFSDR__TA_Approver_Name__c';
        cabfldUpdate2.name = 'Update_DR_TA_Reviewer';
        cabfldUpdate2.fullName = 'GFSDR__Deployment_Request__c.Update_DR_TA_Reviewer';
        cabfldUpdate2.protected_x = false;
        cabfldUpdate2.notifyAssignee = false;
        cabfldUpdate2.operation = 'Formula';        
        cabfldUpdate2.formula =  '$User.FirstName + $User.LastName';
        
        
        GFSMetadataService.WorkflowFieldUpdate cabRjfldUpdate = new GFSMetadataService.WorkflowFieldUpdate();
        cabRjfldUpdate.field = 'GFSDR__Rejected_Stage__c';
        cabRjfldUpdate.name = 'Update_Rejected_Stage_field_TA';
        cabRjfldUpdate.fullName = 'GFSDR__Deployment_Request__c.Update_Rejected_Stage_field_TA';
        cabRjfldUpdate.protected_x = false;
        cabRjfldUpdate.notifyAssignee = false;
        cabRjfldUpdate.operation = 'Formula';
        cabRjfldUpdate.formula = '"TA Review"';
        
        
        if(!Test.isRunningTest()){
            List<GFSMetadataService.SaveResult> results2 = service.createMetadata( new GFSMetadataService.Metadata[] {cabfldUpdate,cabfldUpdate2,cabRjfldUpdate});
            system.debug('>>>>>>>results:'+results2);
        }
        //ta step action
        GFSMetadataService.WorkflowActionReference cabAction = new GFSMetadataService.WorkflowActionReference();
        cabAction.name = 'Update_Stage_equals_CAB_Review';
        cabAction.type_x = 'FieldUpdate';
        
        GFSMetadataService.WorkflowActionReference cabAction2 = new GFSMetadataService.WorkflowActionReference();
        cabAction2.name = 'Update_DR_TA_Reviewer';
        cabAction2.type_x = 'FieldUpdate';
        
        
        
        GFSMetadataService.WorkflowActionReference cabRjAction = new GFSMetadataService.WorkflowActionReference();
        cabRjAction.name = 'Update_Rejected_Stage_field_TA';
        cabRjAction.type_x = 'FieldUpdate';
        
                
        
        /* GFSMetadataService.WorkflowActionReference taAction2 = new GFSMetadataService.WorkflowActionReference();
        taAction.name = 'Update_DR_TA_Reviewer';
        taAction.type_x = 'FieldUpdate'; */

        GFSMetadataService.ApprovalAction cabStepAction = new GFSMetadataService.ApprovalAction();
        cabStepAction.action = new list<GFSMetadataService.WorkflowActionReference>{cabAction,cabAction2} ;
        
        GFSMetadataService.ApprovalAction caRjStepAction = new GFSMetadataService.ApprovalAction();
        caRjStepAction.action = new list<GFSMetadataService.WorkflowActionReference>{cabRjAction};    
                 
        approvalTAStep.rejectionActions = caRjStepAction ;
        
        approvalTAStep.approvalActions = cabStepAction;    
        approvalProcess.approvalStep.add(approvalTAStep);
        
               
        GFSMetadataService.WorkflowFieldUpdate approvedfldUpdate = new GFSMetadataService.WorkflowFieldUpdate();
        approvedfldUpdate.field = 'GFSDR__Stage_txt__c';
        approvedfldUpdate.name = 'Update_Stage_equals_Approvedd';
        approvedfldUpdate.fullName = 'GFSDR__Deployment_Request__c.Update_Stage_equals_Approvedd';
        approvedfldUpdate.protected_x = false;
        approvedfldUpdate.notifyAssignee = false;
        approvedfldUpdate.operation = 'Formula';
        approvedfldUpdate.formula = '"Approved"';
        
        
        GFSMetadataService.WorkflowFieldUpdate approvedfldUpdate12 = new GFSMetadataService.WorkflowFieldUpdate();
        approvedfldUpdate12.field = 'GFSDR__CAB_Approver_Name__c';
        approvedfldUpdate12.name = 'Update_CAB_Approverr';
        approvedfldUpdate12.fullName = 'GFSDR__Deployment_Request__c.Update_CAB_Approverr';
        approvedfldUpdate12.protected_x = false;
        approvedfldUpdate12.notifyAssignee = false;
        approvedfldUpdate12.operation = 'Formula';
        approvedfldUpdate12.formula = '$User.FirstName + $User.LastName';

        
        
        GFSMetadataService.WorkflowFieldUpdate rejectedfldUpdate = new GFSMetadataService.WorkflowFieldUpdate();
        rejectedfldUpdate.field = 'GFSDR__Rejected_Stage__c';
        rejectedfldUpdate.name = 'Update_Rejected_Stage_to_CAB_Review';
        rejectedfldUpdate.fullName = 'GFSDR__Deployment_Request__c.Update_Rejected_Stage_to_CAB_Review';
        rejectedfldUpdate.protected_x = false;
        rejectedfldUpdate.notifyAssignee = false;
        rejectedfldUpdate.operation = 'Formula';
        rejectedfldUpdate.formula = '"CAB Review"';
        
        
        
        if(!Test.isRunningTest()){
            List<GFSMetadataService.SaveResult> approvedResults = service.createMetadata( new GFSMetadataService.Metadata[] {approvedfldUpdate,approvedfldUpdate12,rejectedfldUpdate});
       //    List<GFSMetadataService.SaveResult> approvedResults1 = service.createMetadata( new GFSMetadataService.Metadata[] {approvedfldUpdate12});
        system.debug('>>>>>>>results:'+approvedResults );
        }
        GFSMetadataService.WorkflowFieldUpdate rejectedfldUpdte = new GFSMetadataService.WorkflowFieldUpdate();
        rejectedfldUpdte.field = 'GFSDR__Stage_txt__c';
        rejectedfldUpdte.name = 'Update_Stage_equals_Rejected';
        rejectedfldUpdte.fullName = 'GFSDR__Deployment_Request__c.Update_Stage_equals_Rejected';
        rejectedfldUpdte.protected_x = false;
        rejectedfldUpdte.notifyAssignee = false;
        rejectedfldUpdte.operation = 'Formula';
        rejectedfldUpdte.formula = '"Rejected"';
        
        if(!Test.isRunningTest())
            List<GFSMetadataService.SaveResult> rejectedResults = service.createMetadata( new GFSMetadataService.Metadata[] {rejectedfldUpdte});
                
        GFSMetadataService.WorkflowActionReference finalApprovalAction = new GFSMetadataService.WorkflowActionReference();
        finalApprovalAction.name = 'Update_Stage_equals_Approved';
        finalApprovalAction.type_x = 'FieldUpdate';        
        GFSMetadataService.ApprovalAction finalappAction = new GFSMetadataService.ApprovalAction();
        finalappAction.action = new list<GFSMetadataService.WorkflowActionReference>{finalApprovalAction} ;            
        approvalProcess.finalApprovalActions = finalappAction;
        
        GFSMetadataService.WorkflowActionReference finalRejectAction = new GFSMetadataService.WorkflowActionReference();
        finalRejectAction.name = 'Update_Stage_equals_Rejected';
        finalRejectAction.type_x = 'FieldUpdate';        
        GFSMetadataService.ApprovalAction finalrejAction = new GFSMetadataService.ApprovalAction();
        finalrejAction.action = new list<GFSMetadataService.WorkflowActionReference>{finalRejectAction} ;            
        approvalProcess.finalRejectionActions = finalrejAction;
             

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
                otherFilterEntry.field = 'GFSDR__Deployment_Request__c.GFSDR__Application_Category_txt__c';
                otherFilterEntry.operation = 'equals';
                otherFilterEntry.value = 'Standard Apps';            
            } else {
                otherFilterEntry.field = 'GFSDR__Deployment_Request__c.GFSDR__Application_Name_txt__c';
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
            approvedAction.name = 'Update_Stage_equals_Approvedd';
            approvedAction.type_x = 'FieldUpdate';
            
            
            GFSMetadataService.WorkflowActionReference approvedAction2 = new GFSMetadataService.WorkflowActionReference();
            approvedAction2.name = 'Update_CAB_Approverr';
            approvedAction2.type_x = 'FieldUpdate';
            
            GFSMetadataService.WorkflowActionReference rejectedAction = new GFSMetadataService.WorkflowActionReference();
            rejectedAction.name = 'Update_Rejected_Stage_to_CAB_Review';
            rejectedAction.type_x = 'FieldUpdate';
                        

            GFSMetadataService.ApprovalAction approvedStepAction = new GFSMetadataService.ApprovalAction();
            approvedStepAction.action = new list<GFSMetadataService.WorkflowActionReference>{approvedAction,approvedAction2 } ;
            
            GFSMetadataService.ApprovalAction taRjStepActionAll = new GFSMetadataService.ApprovalAction();
            taRjStepActionAll.action = new list<GFSMetadataService.WorkflowActionReference>{rejectedAction} ;
            otherApprovalStep.rejectionActions = taRjStepActionAll;
                    
            otherApprovalStep.approvalActions = approvedStepAction;                
            approvalProcess.approvalStep.add(otherApprovalStep);                                                
            
        }
        
        if(!Test.isRunningTest()){
            List<GFSMetadataService.SaveResult> results3 = service.createMetadata( new GFSMetadataService.Metadata[] { approvalProcess });
            system.debug('>>>>>>>results:'+results3);    
            Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
            message.setSubject('Approval Proccess Exception');
            message.setHtmlBody('Approval process result:'+results3);
            message.setToAddresses(new list<string>{'anushribhushan.sarwade@globalfoundries.com','ramprakash.rai@globalfoundries.com'});
           // Messaging.sendEmail(new Messaging.SingleEmailMessage[] { message });
            isUATProcCreated = true;
        }
            
        }catch(Exception ex){
             system.debug('-mssg-'+ex.getmessage()); 
             Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
             message.setSubject('Approval Proccess Exception');
             message.setHtmlBody('Exception:'+ex.getMessage());
             message.setToAddresses(new list<string>{'anushribhushan.sarwade@globalfoundries.com','ramprakash.rai@globalfoundries.com'});
         //    Messaging.sendEmail(new Messaging.SingleEmailMessage[] { message });
        }         
    
    }
    
    @future(callout=true)
    public static void createProductionApprovlProcess(string sessionId, String ApplicationName){
    
        try{
        list<Application_Approver__c> newApprovers = [Select Id, name, User__c, Application_Name__c, Role__c from Application_Approver__c  where Application_Name__c=: ApplicationName order by Name];
        map<string,set<string>> appNameListOfRoles = new map<string,set<string>>();
        for(Application_Approver__c approver: newApprovers){
            if(!appNameListOfRoles.containsKey(approver.Application_Name__c))
                appNameListOfRoles.put(approver.Application_Name__c, new set<string>{approver.Role__c});
            else 
                appNameListOfRoles.get(approver.Application_Name__c).add(approver.Role__c);
        }   
        String updApplicationName = ApplicationName.replaceAll(' ', '_');
        
        GFSMetadataService.MetadataPort service = new GFSMetadataService.MetadataPort();   
        service.SessionHeader = new GFSMetadataService.SessionHeader_element();
        service.timeout_x = 120000;
        service.SessionHeader.sessionId = sessionId;//userinfo.getSessionId();
        GFSMetadataService.ApprovalProcess approvalProcess = new GFSMetadataService.ApprovalProcess();
        approvalProcess.fullName = 'GFSDR__Deployment_Request__c.DR_Production_Approval'+'_'+ updApplicationName;
        approvalProcess.label = 'DR Production Approval'+'_'+ updApplicationName;
        approvalProcess.active = true;
        approvalProcess.allowRecall = true; 
        approvalProcess.showApprovalHistory = true;
        approvalProcess.recordEditability = 'AdminOnly';
        approvalProcess.finalApprovalRecordLock = false; 
        approvalProcess.finalRejectionRecordLock = false;
        approvalProcess.showApprovalHistory = false;
        approvalProcess.emailTemplate = 'Deployment_Request_Templates/Deployment_Approval_Request_Email';
        
        GFSMetadataService.WorkflowFieldUpdate fldUpdate = new GFSMetadataService.WorkflowFieldUpdate();
        fldUpdate.field = 'GFSDR__Stage_txt__c';
        fldUpdate.name = 'Update_Stage_equals_EBiZ_FBO_Review';
        fldUpdate.fullName = 'GFSDR__Deployment_Request__c.Update_Stage_equals_EBiZ_FBO_Review';
        fldUpdate.protected_x = false;
        fldUpdate.notifyAssignee = false;
        fldUpdate.operation = 'Formula';
        fldUpdate.formula = '"EBiZ/FBO Review"';
        
        if(!Test.isRunningTest()){
            List<GFSMetadataService.SaveResult> results = service.createMetadata( new GFSMetadataService.Metadata[] { fldUpdate });
            system.debug('>>>>>>>results:'+results);
        }
        //initial submission action
        GFSMetadataService.WorkflowActionReference initAction = new GFSMetadataService.WorkflowActionReference();
        initAction.name = 'Update_Stage_equals_EBiZ_FBO_Review';
        initAction.type_x = 'FieldUpdate';
        
        GFSMetadataService.ApprovalAction appAction = new GFSMetadataService.ApprovalAction();
        appAction.action = new list<GFSMetadataService.WorkflowActionReference>{initAction};
            
        approvalProcess.initialSubmissionActions = appAction;
        //Entry Criteria
        GFSMetadataService.FilterItem ft = new GFSMetadataService.FilterItem();
        ft.field = 'GFSDR__Deployment_Request__c.GFSDR__Application_Name_txt__c';
        ft.operation = 'equals';
        ft.value = ApplicationName;
        
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
        testReviewfldUpdate.field = 'GFSDR__Stage_txt__c';
        testReviewfldUpdate.name = 'Update_Stage_equals_TEST_Review';
        testReviewfldUpdate.fullName = 'GFSDR__Deployment_Request__c.Update_Stage_equals_TEST_Review';
        testReviewfldUpdate.protected_x = false;
        testReviewfldUpdate.notifyAssignee = false;
        testReviewfldUpdate.operation = 'Formula';
        testReviewfldUpdate.formula = '"Test Review"';
        //Rejected Update
        GFSMetadataService.WorkflowFieldUpdate testReviewRjfldUpdate = new GFSMetadataService.WorkflowFieldUpdate();
        testReviewRjfldUpdate.field = 'GFSDR__Rejected_Stage__c';
        testReviewRjfldUpdate.name = 'Update_Stage_equals_TEST_Review_Rj';
        testReviewRjfldUpdate.fullName = 'GFSDR__Deployment_Request__c.Update_Stage_equals_TEST_Review_Rj';
        testReviewRjfldUpdate.protected_x = false;
        testReviewRjfldUpdate.notifyAssignee = false;
        testReviewRjfldUpdate.operation = 'Formula';
        testReviewRjfldUpdate.formula = '"EBiZ/FBO Review"';
        //Ebiz Approver
        GFSMetadataService.WorkflowFieldUpdate testReviewfldUpdateApprver = new GFSMetadataService.WorkflowFieldUpdate();
        testReviewfldUpdateApprver.field = 'GFSDR__EBIZ_FBO_Approver_Name__c';
        testReviewfldUpdateApprver.name = 'Update_DR_EBIZ_Reviewer_Prd';
        testReviewfldUpdateApprver.fullName = 'GFSDR__Deployment_Request__c.Update_DR_EBIZ_Reviewer_Prd';
        testReviewfldUpdateApprver.protected_x = false;
        testReviewfldUpdateApprver.notifyAssignee = false;
        testReviewfldUpdateApprver.operation = 'Formula';        
        testReviewfldUpdateApprver.formula = '$User.FirstName + $User.LastName';
        
        
        GFSMetadataService.WorkflowFieldUpdate sodReviewfldUpdate = new GFSMetadataService.WorkflowFieldUpdate();
        sodReviewfldUpdate.field = 'GFSDR__Stage_txt__c';
        sodReviewfldUpdate.name = 'Update_Stage_equals_SOD_Review_Prd';
        sodReviewfldUpdate.fullName = 'GFSDR__Deployment_Request__c.Update_Stage_equals_SOD_Review_Prd';
        sodReviewfldUpdate.protected_x = false;
        sodReviewfldUpdate.notifyAssignee = false;
        sodReviewfldUpdate.operation = 'Formula';
        sodReviewfldUpdate.formula = '"SOD Review"';
        
        //Rejected Update
        GFSMetadataService.WorkflowFieldUpdate sodReviewRjfldUpdate = new GFSMetadataService.WorkflowFieldUpdate();
        sodReviewRjfldUpdate.field = 'GFSDR__Rejected_Stage__c';
        sodReviewRjfldUpdate.name = 'Update_Stage_equals_SOD_Review_Rj';
        sodReviewRjfldUpdate.fullName = 'GFSDR__Deployment_Request__c.Update_Stage_equals_SOD_Review_Rj';
        sodReviewRjfldUpdate.protected_x = false;
        sodReviewRjfldUpdate.notifyAssignee = false;
        sodReviewRjfldUpdate.operation = 'Formula';
        sodReviewRjfldUpdate.formula = '"Test Review"';
        
        //SOD Approver Update
        GFSMetadataService.WorkflowFieldUpdate sodReviewAppfldUpdate = new GFSMetadataService.WorkflowFieldUpdate();
        sodReviewAppfldUpdate.field = 'GFSDR__SOD_Approver_Name__c';
        sodReviewAppfldUpdate.name = 'Update_SOD_Approver_Update_Prd';
        sodReviewAppfldUpdate.fullName = 'GFSDR__Deployment_Request__c.Update_SOD_Approver_Update_Prd';
        sodReviewAppfldUpdate.protected_x = false;
        sodReviewAppfldUpdate.notifyAssignee = false;
        sodReviewAppfldUpdate.operation = 'Formula';
        sodReviewAppfldUpdate.formula = '$User.FirstName + $User.LastName';

        GFSMetadataService.WorkflowFieldUpdate cabReviewfldUpdate = new GFSMetadataService.WorkflowFieldUpdate();
        cabReviewfldUpdate.field = 'GFSDR__Stage_txt__c';
        cabReviewfldUpdate.name = 'Update_Stage_equals_CAB_Review';
        cabReviewfldUpdate.fullName = 'GFSDR__Deployment_Request__c.Update_Stage_equals_CAB_Review';
        cabReviewfldUpdate.protected_x = false;
        cabReviewfldUpdate.notifyAssignee = false;
        cabReviewfldUpdate.operation = 'Formula';
        cabReviewfldUpdate.formula = '"CAB Review"';
        
        //Rejected Update
        GFSMetadataService.WorkflowFieldUpdate cabReviewRjfldUpdate = new GFSMetadataService.WorkflowFieldUpdate();
        cabReviewRjfldUpdate.field = 'GFSDR__Rejected_Stage__c';
        cabReviewRjfldUpdate.name = 'Update_Stage_equals_CAB_Review_Rj';
        cabReviewRjfldUpdate.fullName = 'GFSDR__Deployment_Request__c.Update_Stage_equals_CAB_Review_Rj';
        cabReviewRjfldUpdate.protected_x = false;
        cabReviewRjfldUpdate.notifyAssignee = false;
        cabReviewRjfldUpdate.operation = 'Formula';
        cabReviewRjfldUpdate.formula = '"SOD Review"';
        
        //CAB Approver Update
         GFSMetadataService.WorkflowFieldUpdate cabReviewApprvfldUpdate = new GFSMetadataService.WorkflowFieldUpdate();
         cabReviewApprvfldUpdate.field = 'GFSDR__CAB_Approver_Name__c';
         cabReviewApprvfldUpdate.name = 'Update_Stage_equals_CAB_Review_Appr';
         cabReviewApprvfldUpdate.fullName = 'GFSDR__Deployment_Request__c.Update_Stage_equals_CAB_Review_Appr';
         cabReviewApprvfldUpdate.protected_x = false;
         cabReviewApprvfldUpdate.notifyAssignee = false;
         cabReviewApprvfldUpdate.operation = 'Formula';
         cabReviewApprvfldUpdate.formula = '$User.FirstName + $User.LastName';
        
        
        if(!Test.isRunningTest()){
            List<GFSMetadataService.SaveResult> results2 = service.createMetadata(new GFSMetadataService.Metadata[] {testReviewfldUpdate,testReviewRjfldUpdate,testReviewfldUpdateApprver,sodReviewfldUpdate,sodReviewAppfldUpdate,sodReviewRjfldUpdate,cabReviewfldUpdate,cabReviewApprvfldUpdate ,cabReviewRjfldUpdate});
            system.debug('>>>>>>>>>>>results2:'+results2);
        }
        
        GFSMetadataService.WorkflowFieldUpdate approvedfldUpdate = new GFSMetadataService.WorkflowFieldUpdate();
        approvedfldUpdate.field = 'GFSDR__Stage_txt__c';
        approvedfldUpdate.name = 'Update_Stage_equals_Approved';
        approvedfldUpdate.fullName = 'GFSDR__Deployment_Request__c.Update_Stage_equals_Approved';
        approvedfldUpdate.protected_x = false;
        approvedfldUpdate.notifyAssignee = false;
        approvedfldUpdate.operation = 'Formula';
        approvedfldUpdate.formula = '"Approved"';
        
        GFSMetadataService.WorkflowFieldUpdate approvedRjfldUpdate = new GFSMetadataService.WorkflowFieldUpdate();
        approvedRjfldUpdate.field = 'GFSDR__Rejected_Stage__c';
        approvedRjfldUpdate.name = 'Update_Stage_equals_Approved_Rj';
        approvedRjfldUpdate.fullName = 'GFSDR__Deployment_Request__c.Update_Stage_equals_Approved_Rj';
        approvedRjfldUpdate.protected_x = false;
        approvedRjfldUpdate.notifyAssignee = false;
        approvedRjfldUpdate.operation = 'Formula';
        approvedRjfldUpdate.formula = '"CAB Review"';
        
        GFSMetadataService.WorkflowFieldUpdate approvedApprvfldUpdate = new GFSMetadataService.WorkflowFieldUpdate();
        approvedApprvfldUpdate.field = 'GFSDR__CAB_Approver_Name__c';
        approvedApprvfldUpdate.name = 'Update_Stage_equals_Approved_Appr';
        approvedApprvfldUpdate.fullName = 'GFSDR__Deployment_Request__c.Update_Stage_equals_Approved_Appr';
        approvedApprvfldUpdate.protected_x = false;
        approvedApprvfldUpdate.notifyAssignee = false;
        approvedApprvfldUpdate.operation = 'Formula';
        approvedApprvfldUpdate.formula = '$User.FirstName + $User.LastName';
             
        
        if(!Test.isRunningTest())
            List<GFSMetadataService.SaveResult> approvedResults = service.createMetadata( new GFSMetadataService.Metadata[] { approvedfldUpdate,approvedRjfldUpdate,approvedApprvfldUpdate});

        GFSMetadataService.WorkflowFieldUpdate rejectedfldUpdate = new GFSMetadataService.WorkflowFieldUpdate();
        rejectedfldUpdate.field = 'GFSDR__Stage_txt__c';
        rejectedfldUpdate.name = 'Update_Stage_equals_Rejected';
        rejectedfldUpdate.fullName = 'GFSDR__Deployment_Request__c.Update_Stage_equals_Rejected';
        rejectedfldUpdate.protected_x = false;
        rejectedfldUpdate.notifyAssignee = false;
        rejectedfldUpdate.operation = 'Formula';
        rejectedfldUpdate.formula = '"Rejected"';
        
        if(!Test.isRunningTest())
            List<GFSMetadataService.SaveResult> rejectedResults = service.createMetadata( new GFSMetadataService.Metadata[] { rejectedfldUpdate });
        
         //Recall Approval Process 
        GFSMetadataService.WorkflowFieldUpdate fldrecllUpdate = new GFSMetadataService.WorkflowFieldUpdate();
        fldrecllUpdate.field = 'GFSDR__TA_Approver_Name__c';
        fldrecllUpdate.name = 'Update_TA_Approver_Name_Prd';
        fldrecllUpdate.fullName = 'GFSDR__Deployment_Request__c.Update_TA_Approver_Name_Prd';
        fldrecllUpdate.protected_x = false;
        fldrecllUpdate.notifyAssignee = false;
        fldrecllUpdate.operation = 'Formula';
        fldrecllUpdate.formula = '" "';
        
        GFSMetadataService.WorkflowFieldUpdate fldrecllUpdate2 = new GFSMetadataService.WorkflowFieldUpdate();
        fldrecllUpdate2.field = 'GFSDR__TFA_Approver_Name__c';
        fldrecllUpdate2.name = 'Update_TFA_Approver_Name_Prd';
        fldrecllUpdate2.fullName = 'GFSDR__Deployment_Request__c.Update_TFA_Approver_Name_Prd';
        fldrecllUpdate2.protected_x = false;
        fldrecllUpdate2.notifyAssignee = false;
        fldrecllUpdate2.operation = 'Formula';
        fldrecllUpdate2.formula = '" "';
        
        
        GFSMetadataService.WorkflowFieldUpdate fldrecllUpdate3 = new GFSMetadataService.WorkflowFieldUpdate();
        fldrecllUpdate3.field = 'GFSDR__Stage_txt__c';
        fldrecllUpdate3.name = 'Update_Stage_to_Draft_Prd';
        fldrecllUpdate3.fullName = 'GFSDR__Deployment_Request__c.Update_Stage_to_Draft_Prd';
        fldrecllUpdate3.protected_x = false;
        fldrecllUpdate3.notifyAssignee = false;
        fldrecllUpdate3.operation = 'Formula';
        fldrecllUpdate3.formula = '"Draft"';
         
        if(!Test.isRunningTest()){
            List<GFSMetadataService.SaveResult> results = service.createMetadata( new GFSMetadataService.Metadata[] {fldrecllUpdate,fldrecllUpdate2,fldrecllUpdate3});
            system.debug('>>>>>>>results:'+results);
        }
        
                
        GFSMetadataService.WorkflowActionReference finalApprovalAction = new GFSMetadataService.WorkflowActionReference();
        finalApprovalAction.name = 'Update_Stage_equals_Approved';
        finalApprovalAction.type_x = 'FieldUpdate';        
        GFSMetadataService.ApprovalAction finalappAction = new GFSMetadataService.ApprovalAction();
        finalappAction.action = new list<GFSMetadataService.WorkflowActionReference>{finalApprovalAction} ;            
        approvalProcess.finalApprovalActions = finalappAction;
        
        GFSMetadataService.WorkflowActionReference finalRejectAction = new GFSMetadataService.WorkflowActionReference();
        finalRejectAction.name = 'Update_Stage_equals_Rejected';
        finalRejectAction.type_x = 'FieldUpdate';        
        GFSMetadataService.ApprovalAction finalrejAction = new GFSMetadataService.ApprovalAction();
        finalrejAction.action = new list<GFSMetadataService.WorkflowActionReference>{finalRejectAction} ;            
        approvalProcess.finalRejectionActions = finalrejAction;    
        
        //Recall Field Update
        GFSMetadataService.WorkflowActionReference recllAction = new GFSMetadataService.WorkflowActionReference();
        recllAction.name = 'Update_TA_Approver_Name_Prd';
        recllAction.type_x = 'FieldUpdate';
        
        GFSMetadataService.WorkflowActionReference recllAction2 = new GFSMetadataService.WorkflowActionReference();
        recllAction2.name = 'Update_TFA_Approver_Name_Prd';
        recllAction2.type_x = 'FieldUpdate';
        
        GFSMetadataService.WorkflowActionReference recllAction3 = new GFSMetadataService.WorkflowActionReference();
        recllAction3.name = 'Update_Stage_to_Draft';
        recllAction3.type_x = 'FieldUpdate';
        
        GFSMetadataService.ApprovalAction reappAction = new GFSMetadataService.ApprovalAction();
        reappAction.action = new list<GFSMetadataService.WorkflowActionReference>{recllAction,recllAction2,recllAction3};
        
        approvalProcess.recallActions = reappAction;
            
        
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
                    otherFilterEntry.field = 'GFSDR__Deployment_Request__c.GFSDR__Application_Category_txt__c';
                    otherFilterEntry.operation = 'equals';
                    otherFilterEntry.value = 'Standard Apps';            
                } else {
                    otherFilterEntry.field = 'GFSDR__Deployment_Request__c.GFSDR__Application_Name_txt__c';
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
                //if(role != 'CAB'){
                GFSMetadataService.WorkflowActionReference fldupdateStepAction = new GFSMetadataService.WorkflowActionReference();
                GFSMetadataService.WorkflowActionReference fldupdateStepAction1 = new GFSMetadataService.WorkflowActionReference();                
                GFSMetadataService.WorkflowActionReference fldupdateRjtStepAction = new GFSMetadataService.WorkflowActionReference();
                
                
                if(role == 'EBiZ/FBO'){
                    fldupdateStepAction1.name = 'Update_Stage_equals_TEST_Review';
                    fldupdateStepAction.name = 'Update_DR_EBIZ_Reviewer_Prd';
                    fldupdateStepAction.type_x = 'FieldUpdate';     
                    fldupdateStepAction1.type_x = 'FieldUpdate'; 
                    fldupdateRjtStepAction.name = 'Update_Stage_equals_TEST_Review_Rj';
                    
                }  
                if(role == 'TEST'){
                    fldupdateStepAction1.name = 'Update_Stage_equals_SOD_Review_Prd';                               
                    fldupdateStepAction.name = 'Update_SOD_Approver_Update_Prd';
                    fldupdateStepAction.type_x = 'FieldUpdate';     
                    fldupdateStepAction1.type_x = 'FieldUpdate'; 
                    fldupdateRjtStepAction.name = 'Update_Stage_equals_SOD_Review_Rj';
                }               
                if(role == 'SOD'){
                    fldupdateStepAction1.name = 'Update_Stage_equals_CAB_Review';
                    fldupdateStepAction.name = 'Update_Stage_equals_CAB_Review_Appr';
                    fldupdateStepAction.type_x = 'FieldUpdate';     
                   fldupdateStepAction1.type_x = 'FieldUpdate'; 
                    fldupdateRjtStepAction.name = 'Update_Stage_equals_CAB_Review_Rj';
                }    
                if(role == 'CAB'){
                    fldupdateStepAction1.name = 'Update_Stage_equals_Approved'; 
                    fldupdateStepAction.name = 'Update_Stage_equals_Approved_Appr';   
                    fldupdateStepAction.type_x = 'FieldUpdate';     
                   fldupdateStepAction1.type_x = 'FieldUpdate'; 
                    fldupdateRjtStepAction.name =  'Update_Stage_equals_Approved_Rj';   
                }                    
                                        
                 
                fldupdateRjtStepAction.type_x = 'FieldUpdate';  
                 
                 
                           
                GFSMetadataService.ApprovalAction appStepAction = new GFSMetadataService.ApprovalAction();
                appStepAction.action = new list<GFSMetadataService.WorkflowActionReference>{fldupdateStepAction,fldupdateStepAction1};                                                    
                GFSMetadataService.ApprovalAction caRjStepAction = new GFSMetadataService.ApprovalAction();
                caRjStepAction.action = new list<GFSMetadataService.WorkflowActionReference>{fldupdateRjtStepAction};   
                 
                otherApprovalStep.approvalActions = appStepAction;   
                otherApprovalStep.rejectionActions = caRjStepAction ;                           
                
                //}
                if(i != j)
                    otherApprovalStep.ifCriteriaNotMet = 'GotoNextStep';
                 
                otherApprovalStep.assignedApprover = otherstepApprover;
                approvalProcess.approvalStep.add(otherApprovalStep);                                                                        
            }
        } 
        
        if(!Test.isRunningTest()){
            List<GFSMetadataService.SaveResult> results1 = service.createMetadata( new GFSMetadataService.Metadata[] { approvalProcess });
            Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
            message.setSubject('Approval Proccess Exception');
            message.setHtmlBody('Approval process result:'+results1);
            message.setToAddresses(new list<string>{'anushribhushan.sarwade@globalfoundries.com','ramprakash.rai@globalfoundries.com'});
           // Messaging.sendEmail(new Messaging.SingleEmailMessage[] { message });
            system.debug('>>>>>>>results:'+results1);   
           
        }
        
        //update counter
        list<Approval_Counter__c> appCounter = [Select Id, Name from Approval_Counter__c limit 1];    
        integer c = Integer.valueOf(appCounter[0].Name);    
        appCounter[0].Name = string.valueOf(c + 1);
        update appCounter; 
        isProdProcCreated = true;
        
        }catch(Exception ex){
             system.debug('-mssg-'+ex.getmessage()); 
             Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
             message.setSubject('Approval Proccess Exception');
             message.setHtmlBody('Exception:'+ex.getMessage());
             message.setToAddresses(new list<string>{'anushribhushan.sarwade@globalfoundries.com','ramprakash.rai@globalfoundries.com'});
         //    Messaging.sendEmail(new Messaging.SingleEmailMessage[] { message });
        }             
    }
    
    
    @future(callout=true)
    public static void createProductionApprovalProcess(string sessionId, integer counter){
        try{
        list<Application_Approver__c> newApprovers = [Select Id, name, User__c, Application_Name__c, Role__c from Application_Approver__c order by Name];
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
        service.SessionHeader.sessionId = sessionId;//userinfo.getSessionId();
        GFSMetadataService.ApprovalProcess approvalProcess = new GFSMetadataService.ApprovalProcess();
        approvalProcess.fullName = 'GFSDR__Deployment_Request__c.DR_Production_Approval'+counter;
        approvalProcess.label = 'DR Production Approval'+counter;
        approvalProcess.active = true;
        approvalProcess.allowRecall = true; 
        approvalProcess.showApprovalHistory = true;
        approvalProcess.recordEditability = 'AdminOnly';
        approvalProcess.finalApprovalRecordLock = false; 
        approvalProcess.finalRejectionRecordLock = false;
        approvalProcess.showApprovalHistory = false;
        approvalProcess.emailTemplate = 'Deployment_Request_Templates/Deployment_Approval_Request_Email';
        
        GFSMetadataService.WorkflowFieldUpdate fldUpdate = new GFSMetadataService.WorkflowFieldUpdate();
        fldUpdate.field = 'GFSDR__Stage_txt__c';
        fldUpdate.name = 'Update_Stage_equals_EBiZ_FBO_Review';
        fldUpdate.fullName = 'GFSDR__Deployment_Request__c.Update_Stage_equals_EBiZ_FBO_Review';
        fldUpdate.protected_x = false;
        fldUpdate.notifyAssignee = false;
        fldUpdate.operation = 'Formula';
        fldUpdate.formula = '"EBiZ/FBO Review"';
        
        if(!Test.isRunningTest()){
            List<GFSMetadataService.SaveResult> results = service.createMetadata( new GFSMetadataService.Metadata[] { fldUpdate });
            system.debug('>>>>>>>results:'+results);
        }
        //initial submission action
        GFSMetadataService.WorkflowActionReference initAction = new GFSMetadataService.WorkflowActionReference();
        initAction.name = 'Update_Stage_equals_EBiZ_FBO_Review';
        initAction.type_x = 'FieldUpdate';
        
        GFSMetadataService.ApprovalAction appAction = new GFSMetadataService.ApprovalAction();
        appAction.action = new list<GFSMetadataService.WorkflowActionReference>{initAction};
            
        approvalProcess.initialSubmissionActions = appAction;
        //Entry Criteria
        GFSMetadataService.FilterItem ft = new GFSMetadataService.FilterItem();
        ft.field = 'GFSDR__Deployment_Request__c.GFSDR__Target_Environment_txt__c';
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
        testReviewfldUpdate.field = 'GFSDR__Stage_txt__c';
        testReviewfldUpdate.name = 'Update_Stage_equals_TEST_Review';
        testReviewfldUpdate.fullName = 'GFSDR__Deployment_Request__c.Update_Stage_equals_TEST_Review';
        testReviewfldUpdate.protected_x = false;
        testReviewfldUpdate.notifyAssignee = false;
        testReviewfldUpdate.operation = 'Formula';
        testReviewfldUpdate.formula = '"Test Review"';
        //Rejected Update
        GFSMetadataService.WorkflowFieldUpdate testReviewRjfldUpdate = new GFSMetadataService.WorkflowFieldUpdate();
        testReviewRjfldUpdate.field = 'GFSDR__Rejected_Stage__c';
        testReviewRjfldUpdate.name = 'Update_Stage_equals_TEST_Review_Rj';
        testReviewRjfldUpdate.fullName = 'GFSDR__Deployment_Request__c.Update_Stage_equals_TEST_Review_Rj';
        testReviewRjfldUpdate.protected_x = false;
        testReviewRjfldUpdate.notifyAssignee = false;
        testReviewRjfldUpdate.operation = 'Formula';
        testReviewRjfldUpdate.formula = '"EBiZ/FBO Review"';
        //Ebiz Approver
        GFSMetadataService.WorkflowFieldUpdate testReviewfldUpdateApprver = new GFSMetadataService.WorkflowFieldUpdate();
        testReviewfldUpdateApprver.field = 'GFSDR__EBIZ_FBO_Approver_Name__c';
        testReviewfldUpdateApprver.name = 'Update_DR_EBIZ_Reviewer_Prd';
        testReviewfldUpdateApprver.fullName = 'GFSDR__Deployment_Request__c.Update_DR_EBIZ_Reviewer_Prd';
        testReviewfldUpdateApprver.protected_x = false;
        testReviewfldUpdateApprver.notifyAssignee = false;
        testReviewfldUpdateApprver.operation = 'Formula';        
        testReviewfldUpdateApprver.formula = '$User.FirstName + $User.LastName';
        
        
        GFSMetadataService.WorkflowFieldUpdate sodReviewfldUpdate = new GFSMetadataService.WorkflowFieldUpdate();
        sodReviewfldUpdate.field = 'GFSDR__Stage_txt__c';
        sodReviewfldUpdate.name = 'Update_Stage_equals_SOD_Review_Prd';
        sodReviewfldUpdate.fullName = 'GFSDR__Deployment_Request__c.Update_Stage_equals_SOD_Review_Prd';
        sodReviewfldUpdate.protected_x = false;
        sodReviewfldUpdate.notifyAssignee = false;
        sodReviewfldUpdate.operation = 'Formula';
        sodReviewfldUpdate.formula = '"SOD Review"';
        
        //Rejected Update
        GFSMetadataService.WorkflowFieldUpdate sodReviewRjfldUpdate = new GFSMetadataService.WorkflowFieldUpdate();
        sodReviewRjfldUpdate.field = 'GFSDR__Rejected_Stage__c';
        sodReviewRjfldUpdate.name = 'Update_Stage_equals_SOD_Review_Rj';
        sodReviewRjfldUpdate.fullName = 'GFSDR__Deployment_Request__c.Update_Stage_equals_SOD_Review_Rj';
        sodReviewRjfldUpdate.protected_x = false;
        sodReviewRjfldUpdate.notifyAssignee = false;
        sodReviewRjfldUpdate.operation = 'Formula';
        sodReviewRjfldUpdate.formula = '"Test Review"';
        
        //SOD Approver Update
        GFSMetadataService.WorkflowFieldUpdate sodReviewAppfldUpdate = new GFSMetadataService.WorkflowFieldUpdate();
        sodReviewAppfldUpdate.field = 'GFSDR__SOD_Approver_Name__c';
        sodReviewAppfldUpdate.name = 'Update_SOD_Approver_Update_Prd';
        sodReviewAppfldUpdate.fullName = 'GFSDR__Deployment_Request__c.Update_SOD_Approver_Update_Prd';
        sodReviewAppfldUpdate.protected_x = false;
        sodReviewAppfldUpdate.notifyAssignee = false;
        sodReviewAppfldUpdate.operation = 'Formula';
        sodReviewAppfldUpdate.formula = '$User.FirstName + $User.LastName';

        GFSMetadataService.WorkflowFieldUpdate cabReviewfldUpdate = new GFSMetadataService.WorkflowFieldUpdate();
        cabReviewfldUpdate.field = 'GFSDR__Stage_txt__c';
        cabReviewfldUpdate.name = 'Update_Stage_equals_CAB_Review';
        cabReviewfldUpdate.fullName = 'GFSDR__Deployment_Request__c.Update_Stage_equals_CAB_Review';
        cabReviewfldUpdate.protected_x = false;
        cabReviewfldUpdate.notifyAssignee = false;
        cabReviewfldUpdate.operation = 'Formula';
        cabReviewfldUpdate.formula = '"CAB Review"';
        
        //Rejected Update
        GFSMetadataService.WorkflowFieldUpdate cabReviewRjfldUpdate = new GFSMetadataService.WorkflowFieldUpdate();
        cabReviewRjfldUpdate.field = 'GFSDR__Rejected_Stage__c';
        cabReviewRjfldUpdate.name = 'Update_Stage_equals_CAB_Review_Rj';
        cabReviewRjfldUpdate.fullName = 'GFSDR__Deployment_Request__c.Update_Stage_equals_CAB_Review_Rj';
        cabReviewRjfldUpdate.protected_x = false;
        cabReviewRjfldUpdate.notifyAssignee = false;
        cabReviewRjfldUpdate.operation = 'Formula';
        cabReviewRjfldUpdate.formula = '"SOD Review"';
        
        //CAB Approver Update
         GFSMetadataService.WorkflowFieldUpdate cabReviewApprvfldUpdate = new GFSMetadataService.WorkflowFieldUpdate();
         cabReviewApprvfldUpdate.field = 'GFSDR__CAB_Approver_Name__c';
         cabReviewApprvfldUpdate.name = 'Update_Stage_equals_CAB_Review_Appr';
         cabReviewApprvfldUpdate.fullName = 'GFSDR__Deployment_Request__c.Update_Stage_equals_CAB_Review_Appr';
         cabReviewApprvfldUpdate.protected_x = false;
         cabReviewApprvfldUpdate.notifyAssignee = false;
         cabReviewApprvfldUpdate.operation = 'Formula';
         cabReviewApprvfldUpdate.formula = '$User.FirstName + $User.LastName';
        
        
        if(!Test.isRunningTest()){
            List<GFSMetadataService.SaveResult> results2 = service.createMetadata(new GFSMetadataService.Metadata[] {testReviewfldUpdate,testReviewRjfldUpdate,testReviewfldUpdateApprver,sodReviewfldUpdate,sodReviewAppfldUpdate,sodReviewRjfldUpdate,cabReviewfldUpdate,cabReviewApprvfldUpdate ,cabReviewRjfldUpdate});
            system.debug('>>>>>>>>>>>results2:'+results2);
        }
        
        GFSMetadataService.WorkflowFieldUpdate approvedfldUpdate = new GFSMetadataService.WorkflowFieldUpdate();
        approvedfldUpdate.field = 'GFSDR__Stage_txt__c';
        approvedfldUpdate.name = 'Update_Stage_equals_Approved';
        approvedfldUpdate.fullName = 'GFSDR__Deployment_Request__c.Update_Stage_equals_Approved';
        approvedfldUpdate.protected_x = false;
        approvedfldUpdate.notifyAssignee = false;
        approvedfldUpdate.operation = 'Formula';
        approvedfldUpdate.formula = '"Approved"';
        
        GFSMetadataService.WorkflowFieldUpdate approvedRjfldUpdate = new GFSMetadataService.WorkflowFieldUpdate();
        approvedRjfldUpdate.field = 'GFSDR__Rejected_Stage__c';
        approvedRjfldUpdate.name = 'Update_Stage_equals_Approved_Rj';
        approvedRjfldUpdate.fullName = 'GFSDR__Deployment_Request__c.Update_Stage_equals_Approved_Rj';
        approvedRjfldUpdate.protected_x = false;
        approvedRjfldUpdate.notifyAssignee = false;
        approvedRjfldUpdate.operation = 'Formula';
        approvedRjfldUpdate.formula = '"CAB Review"';
        
        GFSMetadataService.WorkflowFieldUpdate approvedApprvfldUpdate = new GFSMetadataService.WorkflowFieldUpdate();
        approvedApprvfldUpdate.field = 'GFSDR__CAB_Approver_Name__c';
        approvedApprvfldUpdate.name = 'Update_Stage_equals_Approved_Appr';
        approvedApprvfldUpdate.fullName = 'GFSDR__Deployment_Request__c.Update_Stage_equals_Approved_Appr';
        approvedApprvfldUpdate.protected_x = false;
        approvedApprvfldUpdate.notifyAssignee = false;
        approvedApprvfldUpdate.operation = 'Formula';
        approvedApprvfldUpdate.formula = '$User.FirstName + $User.LastName';
             
        
        if(!Test.isRunningTest())
            List<GFSMetadataService.SaveResult> approvedResults = service.createMetadata( new GFSMetadataService.Metadata[] { approvedfldUpdate,approvedRjfldUpdate,approvedApprvfldUpdate});

        GFSMetadataService.WorkflowFieldUpdate rejectedfldUpdate = new GFSMetadataService.WorkflowFieldUpdate();
        rejectedfldUpdate.field = 'GFSDR__Stage_txt__c';
        rejectedfldUpdate.name = 'Update_Stage_equals_Rejected';
        rejectedfldUpdate.fullName = 'GFSDR__Deployment_Request__c.Update_Stage_equals_Rejected';
        rejectedfldUpdate.protected_x = false;
        rejectedfldUpdate.notifyAssignee = false;
        rejectedfldUpdate.operation = 'Formula';
        rejectedfldUpdate.formula = '"Rejected"';
        
        if(!Test.isRunningTest())
            List<GFSMetadataService.SaveResult> rejectedResults = service.createMetadata( new GFSMetadataService.Metadata[] { rejectedfldUpdate });
        
         //Recall Approval Process 
        GFSMetadataService.WorkflowFieldUpdate fldrecllUpdate = new GFSMetadataService.WorkflowFieldUpdate();
        fldrecllUpdate.field = 'GFSDR__TA_Approver_Name__c';
        fldrecllUpdate.name = 'Update_TA_Approver_Name_Prd';
        fldrecllUpdate.fullName = 'GFSDR__Deployment_Request__c.Update_TA_Approver_Name_Prd';
        fldrecllUpdate.protected_x = false;
        fldrecllUpdate.notifyAssignee = false;
        fldrecllUpdate.operation = 'Formula';
        fldrecllUpdate.formula = '" "';
        
        GFSMetadataService.WorkflowFieldUpdate fldrecllUpdate2 = new GFSMetadataService.WorkflowFieldUpdate();
        fldrecllUpdate2.field = 'GFSDR__TFA_Approver_Name__c';
        fldrecllUpdate2.name = 'Update_TFA_Approver_Name_Prd';
        fldrecllUpdate2.fullName = 'GFSDR__Deployment_Request__c.Update_TFA_Approver_Name_Prd';
        fldrecllUpdate2.protected_x = false;
        fldrecllUpdate2.notifyAssignee = false;
        fldrecllUpdate2.operation = 'Formula';
        fldrecllUpdate2.formula = '" "';
        
        
        GFSMetadataService.WorkflowFieldUpdate fldrecllUpdate3 = new GFSMetadataService.WorkflowFieldUpdate();
        fldrecllUpdate3.field = 'GFSDR__Stage_txt__c';
        fldrecllUpdate3.name = 'Update_Stage_to_Draft_Prd';
        fldrecllUpdate3.fullName = 'GFSDR__Deployment_Request__c.Update_Stage_to_Draft_Prd';
        fldrecllUpdate3.protected_x = false;
        fldrecllUpdate3.notifyAssignee = false;
        fldrecllUpdate3.operation = 'Formula';
        fldrecllUpdate3.formula = '"Draft"';
         
        if(!Test.isRunningTest()){
            List<GFSMetadataService.SaveResult> results = service.createMetadata( new GFSMetadataService.Metadata[] {fldrecllUpdate,fldrecllUpdate2,fldrecllUpdate3});
            system.debug('>>>>>>>results:'+results);
        }
        
                
        GFSMetadataService.WorkflowActionReference finalApprovalAction = new GFSMetadataService.WorkflowActionReference();
        finalApprovalAction.name = 'Update_Stage_equals_Approved';
        finalApprovalAction.type_x = 'FieldUpdate';        
        GFSMetadataService.ApprovalAction finalappAction = new GFSMetadataService.ApprovalAction();
        finalappAction.action = new list<GFSMetadataService.WorkflowActionReference>{finalApprovalAction} ;            
        approvalProcess.finalApprovalActions = finalappAction;
        
        GFSMetadataService.WorkflowActionReference finalRejectAction = new GFSMetadataService.WorkflowActionReference();
        finalRejectAction.name = 'Update_Stage_equals_Rejected';
        finalRejectAction.type_x = 'FieldUpdate';        
        GFSMetadataService.ApprovalAction finalrejAction = new GFSMetadataService.ApprovalAction();
        finalrejAction.action = new list<GFSMetadataService.WorkflowActionReference>{finalRejectAction} ;            
        approvalProcess.finalRejectionActions = finalrejAction;    
        
        //Recall Field Update
        GFSMetadataService.WorkflowActionReference recllAction = new GFSMetadataService.WorkflowActionReference();
        recllAction.name = 'Update_TA_Approver_Name_Prd';
        recllAction.type_x = 'FieldUpdate';
        
        GFSMetadataService.WorkflowActionReference recllAction2 = new GFSMetadataService.WorkflowActionReference();
        recllAction2.name = 'Update_TFA_Approver_Name_Prd';
        recllAction2.type_x = 'FieldUpdate';
        
        GFSMetadataService.WorkflowActionReference recllAction3 = new GFSMetadataService.WorkflowActionReference();
        recllAction3.name = 'Update_Stage_to_Draft';
        recllAction3.type_x = 'FieldUpdate';
        
        GFSMetadataService.ApprovalAction reappAction = new GFSMetadataService.ApprovalAction();
        reappAction.action = new list<GFSMetadataService.WorkflowActionReference>{recllAction,recllAction2,recllAction3};
        
        approvalProcess.recallActions = reappAction;
            
        
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
                    otherFilterEntry.field = 'GFSDR__Deployment_Request__c.GFSDR__Application_Category_txt__c';
                    otherFilterEntry.operation = 'equals';
                    otherFilterEntry.value = 'Standard Apps';            
                } else {
                    otherFilterEntry.field = 'GFSDR__Deployment_Request__c.GFSDR__Application_Name_txt__c';
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
                //if(role != 'CAB'){
                GFSMetadataService.WorkflowActionReference fldupdateStepAction = new GFSMetadataService.WorkflowActionReference();
                GFSMetadataService.WorkflowActionReference fldupdateStepAction1 = new GFSMetadataService.WorkflowActionReference();                
                GFSMetadataService.WorkflowActionReference fldupdateRjtStepAction = new GFSMetadataService.WorkflowActionReference();
                
                
                if(role == 'EBiZ/FBO'){
                    fldupdateStepAction1.name = 'Update_Stage_equals_TEST_Review';
                    fldupdateStepAction.name = 'Update_DR_EBIZ_Reviewer_Prd';
                    fldupdateStepAction.type_x = 'FieldUpdate';     
                    fldupdateStepAction1.type_x = 'FieldUpdate'; 
                    fldupdateRjtStepAction.name = 'Update_Stage_equals_TEST_Review_Rj';
                    
                }  
                if(role == 'TEST'){
                    fldupdateStepAction1.name = 'Update_Stage_equals_SOD_Review_Prd';                               
                    fldupdateStepAction.name = 'Update_SOD_Approver_Update_Prd';
                    fldupdateStepAction.type_x = 'FieldUpdate';     
                    fldupdateStepAction1.type_x = 'FieldUpdate'; 
                    fldupdateRjtStepAction.name = 'Update_Stage_equals_SOD_Review_Rj';
                }               
                if(role == 'SOD'){
                    fldupdateStepAction1.name = 'Update_Stage_equals_CAB_Review';
                    fldupdateStepAction.name = 'Update_Stage_equals_CAB_Review_Appr';
                    fldupdateStepAction.type_x = 'FieldUpdate';     
                   fldupdateStepAction1.type_x = 'FieldUpdate'; 
                    fldupdateRjtStepAction.name = 'Update_Stage_equals_CAB_Review_Rj';
                }    
                if(role == 'CAB'){
                    fldupdateStepAction1.name = 'Update_Stage_equals_Approved'; 
                    fldupdateStepAction.name = 'Update_Stage_equals_Approved_Appr';   
                    fldupdateStepAction.type_x = 'FieldUpdate';     
                   fldupdateStepAction1.type_x = 'FieldUpdate'; 
                    fldupdateRjtStepAction.name =  'Update_Stage_equals_Approved_Rj';   
                }                    
                                        
                 
                fldupdateRjtStepAction.type_x = 'FieldUpdate';  
                 
                 
                           
                GFSMetadataService.ApprovalAction appStepAction = new GFSMetadataService.ApprovalAction();
                appStepAction.action = new list<GFSMetadataService.WorkflowActionReference>{fldupdateStepAction,fldupdateStepAction1};                                                    
                GFSMetadataService.ApprovalAction caRjStepAction = new GFSMetadataService.ApprovalAction();
                caRjStepAction.action = new list<GFSMetadataService.WorkflowActionReference>{fldupdateRjtStepAction};   
                 
                otherApprovalStep.approvalActions = appStepAction;   
                otherApprovalStep.rejectionActions = caRjStepAction ;                           
                
                //}
                if(i != j)
                    otherApprovalStep.ifCriteriaNotMet = 'GotoNextStep';
                 
                otherApprovalStep.assignedApprover = otherstepApprover;
                approvalProcess.approvalStep.add(otherApprovalStep);                                                                        
            }
        } 
        
        if(!Test.isRunningTest()){
            List<GFSMetadataService.SaveResult> results1 = service.createMetadata( new GFSMetadataService.Metadata[] { approvalProcess });
            Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
            message.setSubject('Approval Proccess Exception');
            message.setHtmlBody('Approval process result:'+results1);
            message.setToAddresses(new list<string>{'anushribhushan.sarwade@globalfoundries.com','ramprakash.rai@globalfoundries.com'});
           // Messaging.sendEmail(new Messaging.SingleEmailMessage[] { message });
            system.debug('>>>>>>>results:'+results1);   
           
        }
        createUATApprovalProcess(sessionId, counter);
        //update counter
        list<Approval_Counter__c> appCounter = [Select Id, Name from Approval_Counter__c limit 1];    
        integer c = Integer.valueOf(appCounter[0].Name);    
        appCounter[0].Name = string.valueOf(c + 1);
        update appCounter; 
        isProdProcCreated = true;
        
        }catch(Exception ex){
             system.debug('-mssg-'+ex.getmessage()); 
             Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
             message.setSubject('Approval Proccess Exception');
             message.setHtmlBody('Exception:'+ex.getMessage());
             message.setToAddresses(new list<string>{'anushribhushan.sarwade@globalfoundries.com','ramprakash.rai@globalfoundries.com'});
         //    Messaging.sendEmail(new Messaging.SingleEmailMessage[] { message });
        }             
    }
    
    
    
    
    
  //  @future(callout=true)
    public static void createUATApprovalProcess(string sessionId, integer counter){
        try{
        list<Application_Approver__c> newApprovers = [Select Id, name, User__c, Application_Name__c, Role__c from Application_Approver__c order by Name];
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
        service.SessionHeader.sessionId = sessionId;//userinfo.getSessionId();
        GFSMetadataService.ApprovalProcess approvalProcess = new GFSMetadataService.ApprovalProcess();
        approvalProcess.fullName = 'GFSDR__Deployment_Request__c.DR_UAT_Approval'+counter;
        approvalProcess.label = 'DR UAT Approval'+counter;
        approvalProcess.active = true;
        approvalProcess.allowRecall = true; 
        approvalProcess.showApprovalHistory = true;
        approvalProcess.recordEditability = 'AdminOnly';
        approvalProcess.finalApprovalRecordLock = false; 
        approvalProcess.finalRejectionRecordLock = false;
        approvalProcess.showApprovalHistory = false;
        approvalProcess.emailTemplate = 'Deployment_Request_Templates/Deployment_Approval_Request_Email';
        
        GFSMetadataService.WorkflowFieldUpdate fldUpdate = new GFSMetadataService.WorkflowFieldUpdate();
        fldUpdate.field = 'GFSDR__Stage_txt__c';
        fldUpdate.name = 'Update_Stage_equals_TFA_Review1';
        fldUpdate.fullName = 'GFSDR__Deployment_Request__c.Update_Stage_equals_TFA_Review1';
        fldUpdate.protected_x = false;
        fldUpdate.notifyAssignee = false;
        fldUpdate.operation = 'Formula';
        fldUpdate.formula = '"TFA Review"';
        if(!Test.isRunningTest()){
            List<GFSMetadataService.SaveResult> results = service.createMetadata( new GFSMetadataService.Metadata[] { fldUpdate });
            system.debug('>>>>>>>results:'+results);
        }
        
        //Recall Approval Process 
        GFSMetadataService.WorkflowFieldUpdate fldrecllUpdate = new GFSMetadataService.WorkflowFieldUpdate();
        fldrecllUpdate.field = 'GFSDR__TA_Approver_Name__c';
        fldrecllUpdate.name = 'Update_TA_Approver_Name';
        fldrecllUpdate.fullName = 'GFSDR__Deployment_Request__c.Update_TA_Approver_Name';
        fldrecllUpdate.protected_x = false;
        fldrecllUpdate.notifyAssignee = false;
        fldrecllUpdate.operation = 'Formula';
        fldrecllUpdate.formula = '" "';
        
        GFSMetadataService.WorkflowFieldUpdate fldrecllUpdate2 = new GFSMetadataService.WorkflowFieldUpdate();
        fldrecllUpdate2.field = 'GFSDR__TFA_Approver_Name__c';
        fldrecllUpdate2.name = 'Update_TFA_Approver_Name';
        fldrecllUpdate2.fullName = 'GFSDR__Deployment_Request__c.Update_TFA_Approver_Name';
        fldrecllUpdate2.protected_x = false;
        fldrecllUpdate2.notifyAssignee = false;
        fldrecllUpdate2.operation = 'Formula';
        fldrecllUpdate2.formula = '" "';
        
        
        GFSMetadataService.WorkflowFieldUpdate fldrecllUpdate3 = new GFSMetadataService.WorkflowFieldUpdate();
        fldrecllUpdate3.field = 'GFSDR__Stage_txt__c';
        fldrecllUpdate3.name = 'Update_Stage_to_Draft';
        fldrecllUpdate3.fullName = 'GFSDR__Deployment_Request__c.Update_Stage_to_Draft';
        fldrecllUpdate3.protected_x = false;
        fldrecllUpdate3.notifyAssignee = false;
        fldrecllUpdate3.operation = 'Formula';
        fldrecllUpdate3.formula = '"Draft"';
         
        if(!Test.isRunningTest()){
            List<GFSMetadataService.SaveResult> results = service.createMetadata( new GFSMetadataService.Metadata[] {fldrecllUpdate,fldrecllUpdate2,fldrecllUpdate3});
            system.debug('>>>>>>>results:'+results);
        }
        
        
        //initial submission action
        GFSMetadataService.WorkflowActionReference initAction = new GFSMetadataService.WorkflowActionReference();
        initAction.name = 'Update_Stage_equals_TFA_Review1';
        initAction.type_x = 'FieldUpdate';
        
        //Recall Field Update
        GFSMetadataService.WorkflowActionReference recllAction = new GFSMetadataService.WorkflowActionReference();
        recllAction.name = 'Update_TA_Approver_Name';
        recllAction.type_x = 'FieldUpdate';
        
        GFSMetadataService.WorkflowActionReference recllAction2 = new GFSMetadataService.WorkflowActionReference();
        recllAction2.name = 'Update_TFA_Approver_Name';
        recllAction2.type_x = 'FieldUpdate';
        
        GFSMetadataService.WorkflowActionReference recllAction3 = new GFSMetadataService.WorkflowActionReference();
        recllAction3.name = 'Update_Stage_to_Draft';
        recllAction3.type_x = 'FieldUpdate';
        
        GFSMetadataService.ApprovalAction appAction = new GFSMetadataService.ApprovalAction();
        appAction.action = new list<GFSMetadataService.WorkflowActionReference>{initAction} ;
        
        GFSMetadataService.ApprovalAction reappAction = new GFSMetadataService.ApprovalAction();
        reappAction.action = new list<GFSMetadataService.WorkflowActionReference>{recllAction,recllAction2,recllAction3};
            
        approvalProcess.initialSubmissionActions = appAction;
        approvalProcess.recallActions = reappAction;
        
        //Entry Criteria
        GFSMetadataService.FilterItem ft = new GFSMetadataService.FilterItem();
        ft.field = 'GFSDR__Deployment_Request__c.GFSDR__Target_Environment_txt__c';
        ft.operation = 'equals';
        ft.value = 'UAT';
        
        GFSMetadataService.ApprovalEntryCriteria entry =  new GFSMetadataService.ApprovalEntryCriteria();
        entry.criteriaItems = new list<GFSMetadataService.FilterItem>{ft};
        approvalProcess.entryCriteria = entry;   
        
        GFSMetadataService.ApprovalSubmitter submitter1 = new GFSMetadataService.ApprovalSubmitter();
        submitter1.type_x = 'owner';
        approvalProcess.allowedSubmitters = new list<GFSMetadataService.ApprovalSubmitter>{submitter1};

        approvalProcess.approvalStep = new list<GFSMetadataService.ApprovalStep>();
      //  approvalProcess.rejectionActions = new list<GFSMetadataService.rejectionActions>();
        
        //TFA Step
        GFSMetadataService.Approver tfaapprover = new GFSMetadataService.Approver();
        tfaapprover.name = 'GFSDR__Deployment_Request__c.GFSDR__TFA_Review_User__c';
        tfaapprover.type_x ='relatedUserField';
        
        GFSMetadataService.ApprovalStepApprover tfastepApprover = new GFSMetadataService.ApprovalStepApprover();
        tfastepApprover.approver = new list<GFSMetadataService.Approver>{tfaapprover};
        tfastepApprover.whenMultipleApprovers = 'Unanimous';
            
        GFSMetadataService.ApprovalStep approvalTFAStep = new GFSMetadataService.ApprovalStep();
        approvalTFAStep.name='TFA_Approval';
        approvalTFAStep.label='TFA Approval';
        approvalTFAStep.allowDelegate= true;
        approvalTFAStep.assignedApprover = tfastepApprover;
        
        
        /* GFSMetadataService.WorkflowFieldUpdate tfaReviewerfldUpdate = new GFSMetadataService.WorkflowFieldUpdate();
        tfaReviewerfldUpdate.field = 'TFA_Approver_Name__c';
        tfaReviewerfldUpdate.name = 'Update_DR_TFA_Reviewer';
        tfaReviewerfldUpdate.fullName = 'Deployment_Request__c.Update_DR_TFA_Reviewer';
        tfaReviewerfldUpdate.protected_x = false;
        tfaReviewerfldUpdate.notifyAssignee = false;
        tfaReviewerfldUpdate.operation = 'Formula';
        tfaReviewerfldUpdate.formula = '\"'+userinfo.getFirstName()+'\"'; */

        GFSMetadataService.WorkflowFieldUpdate taReviewerfldUpdate = new GFSMetadataService.WorkflowFieldUpdate();
        taReviewerfldUpdate.field = 'GFSDR__TFA_Approver_Name__c';
        taReviewerfldUpdate.name = 'Update_TFA_Approver';
        taReviewerfldUpdate.fullName = 'GFSDR__Deployment_Request__c.Update_TFA_Approver';
        taReviewerfldUpdate.protected_x = false;
        taReviewerfldUpdate.notifyAssignee = false;
        taReviewerfldUpdate.operation = 'Formula';        
        taReviewerfldUpdate.formula =  '$User.FirstName + $User.LastName';

        //field update 
        GFSMetadataService.WorkflowFieldUpdate tafldUpdate = new GFSMetadataService.WorkflowFieldUpdate();
        GFSMetadataService.WorkflowFieldUpdate taRjfldUpdate = new GFSMetadataService.WorkflowFieldUpdate();        
        
        tafldUpdate.field = 'GFSDR__Stage_txt__c';
        tafldUpdate.name = 'Update_Stage_equals_TA_Review';
        tafldUpdate.fullName = 'GFSDR__Deployment_Request__c.Update_Stage_equals_TA_Review';
        tafldUpdate.protected_x = false;
        tafldUpdate.notifyAssignee = false;
        tafldUpdate.operation = 'Formula';
        tafldUpdate.formula = '"TA Review"';
        
        
        taRjfldUpdate.field = 'GFSDR__Rejected_Stage__c';
        taRjfldUpdate.name = 'Update_Rejected_Stage_field';
        taRjfldUpdate.fullName = 'GFSDR__Deployment_Request__c.Update_Rejected_Stage_field';
        taRjfldUpdate.protected_x = false;
        taRjfldUpdate.notifyAssignee = false;
        taRjfldUpdate.operation = 'Formula';
        taRjfldUpdate.formula = '"TFA Review"';
                
        
        if(!Test.isRunningTest()){
            List<GFSMetadataService.SaveResult> results1 = service.createMetadata( new GFSMetadataService.Metadata[] { tafldUpdate,taReviewerfldUpdate,taRjfldUpdate});
            system.debug('>>>>>>>results:'+results1);
        }
        
        //tfa approval action
        GFSMetadataService.WorkflowActionReference taAction = new GFSMetadataService.WorkflowActionReference();
        GFSMetadataService.WorkflowActionReference taAction1 = new GFSMetadataService.WorkflowActionReference();
        
        GFSMetadataService.WorkflowActionReference taRjAction = new GFSMetadataService.WorkflowActionReference();
        
        
        taAction.name = 'Update_Stage_equals_TA_Review';
        taAction.type_x = 'FieldUpdate';
        
        taAction1.name = 'Update_TFA_Approver';
        taAction1.type_x = 'FieldUpdate';
        
        taRjAction.name = 'Update_Rejected_Stage_field';
        taRjAction.type_x = 'FieldUpdate';
    
        GFSMetadataService.ApprovalAction taStepAction = new GFSMetadataService.ApprovalAction();
        taStepAction.action = new list<GFSMetadataService.WorkflowActionReference>{taAction,taAction1} ;
        
        GFSMetadataService.ApprovalAction taRjStepAction = new GFSMetadataService.ApprovalAction();
        taRjStepAction.action = new list<GFSMetadataService.WorkflowActionReference>{taRjAction} ;
        
        GFSMetadataService.ApprovalProcess recallAction = new GFSMetadataService.ApprovalProcess();
                
                 
        approvalTFAStep.approvalActions  = taStepAction;
        approvalTFAStep.rejectionActions = taRjStepAction;
        
        approvalProcess.approvalStep.add(approvalTFAStep);
       // approvalProcess.approvalStep.add(approvalTFAStep);
        
        //TA Step
        GFSMetadataService.Approver taapprover= new GFSMetadataService.Approver();
        taapprover.name = 'GFSDR__Deployment_Request__c.GFSDR__TA_Review_User__c';
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
        cabfldUpdate.field = 'GFSDR__Stage_txt__c';
        cabfldUpdate.name = 'Update_Stage_equals_CAB_Review';
        cabfldUpdate.fullName = 'GFSDR__Deployment_Request__c.Update_Stage_equals_CAB_Review';
        cabfldUpdate.protected_x = false;
        cabfldUpdate.notifyAssignee = false;
        cabfldUpdate.operation = 'Formula';
        cabfldUpdate.formula = '"CAB Review"';
        
        GFSMetadataService.WorkflowFieldUpdate cabfldUpdate2 = new GFSMetadataService.WorkflowFieldUpdate();
        cabfldUpdate2.field = 'GFSDR__TA_Approver_Name__c';
        cabfldUpdate2.name = 'Update_DR_TA_Reviewer';
        cabfldUpdate2.fullName = 'GFSDR__Deployment_Request__c.Update_DR_TA_Reviewer';
        cabfldUpdate2.protected_x = false;
        cabfldUpdate2.notifyAssignee = false;
        cabfldUpdate2.operation = 'Formula';        
        cabfldUpdate2.formula =  '$User.FirstName + $User.LastName';
        
        
        GFSMetadataService.WorkflowFieldUpdate cabRjfldUpdate = new GFSMetadataService.WorkflowFieldUpdate();
        cabRjfldUpdate.field = 'GFSDR__Rejected_Stage__c';
        cabRjfldUpdate.name = 'Update_Rejected_Stage_field_TA';
        cabRjfldUpdate.fullName = 'GFSDR__Deployment_Request__c.Update_Rejected_Stage_field_TA';
        cabRjfldUpdate.protected_x = false;
        cabRjfldUpdate.notifyAssignee = false;
        cabRjfldUpdate.operation = 'Formula';
        cabRjfldUpdate.formula = '"TA Review"';
        
        
        if(!Test.isRunningTest()){
            List<GFSMetadataService.SaveResult> results2 = service.createMetadata( new GFSMetadataService.Metadata[] {cabfldUpdate,cabfldUpdate2,cabRjfldUpdate});
            system.debug('>>>>>>>results:'+results2);
        }
        //ta step action
        GFSMetadataService.WorkflowActionReference cabAction = new GFSMetadataService.WorkflowActionReference();
        cabAction.name = 'Update_Stage_equals_CAB_Review';
        cabAction.type_x = 'FieldUpdate';
        
        GFSMetadataService.WorkflowActionReference cabAction2 = new GFSMetadataService.WorkflowActionReference();
        cabAction2.name = 'Update_DR_TA_Reviewer';
        cabAction2.type_x = 'FieldUpdate';
        
        
        
        GFSMetadataService.WorkflowActionReference cabRjAction = new GFSMetadataService.WorkflowActionReference();
        cabRjAction.name = 'Update_Rejected_Stage_field_TA';
        cabRjAction.type_x = 'FieldUpdate';
        
                
        
        /* GFSMetadataService.WorkflowActionReference taAction2 = new GFSMetadataService.WorkflowActionReference();
        taAction.name = 'Update_DR_TA_Reviewer';
        taAction.type_x = 'FieldUpdate'; */

        GFSMetadataService.ApprovalAction cabStepAction = new GFSMetadataService.ApprovalAction();
        cabStepAction.action = new list<GFSMetadataService.WorkflowActionReference>{cabAction,cabAction2} ;
        
        GFSMetadataService.ApprovalAction caRjStepAction = new GFSMetadataService.ApprovalAction();
        caRjStepAction.action = new list<GFSMetadataService.WorkflowActionReference>{cabRjAction};    
                 
        approvalTAStep.rejectionActions = caRjStepAction ;
        
        approvalTAStep.approvalActions = cabStepAction;    
        approvalProcess.approvalStep.add(approvalTAStep);
        
               
        GFSMetadataService.WorkflowFieldUpdate approvedfldUpdate = new GFSMetadataService.WorkflowFieldUpdate();
        approvedfldUpdate.field = 'GFSDR__Stage_txt__c';
        approvedfldUpdate.name = 'Update_Stage_equals_Approvedd';
        approvedfldUpdate.fullName = 'GFSDR__Deployment_Request__c.Update_Stage_equals_Approvedd';
        approvedfldUpdate.protected_x = false;
        approvedfldUpdate.notifyAssignee = false;
        approvedfldUpdate.operation = 'Formula';
        approvedfldUpdate.formula = '"Approved"';
        
        
        GFSMetadataService.WorkflowFieldUpdate approvedfldUpdate12 = new GFSMetadataService.WorkflowFieldUpdate();
        approvedfldUpdate12.field = 'GFSDR__CAB_Approver_Name__c';
        approvedfldUpdate12.name = 'Update_CAB_Approverr';
        approvedfldUpdate12.fullName = 'GFSDR__Deployment_Request__c.Update_CAB_Approverr';
        approvedfldUpdate12.protected_x = false;
        approvedfldUpdate12.notifyAssignee = false;
        approvedfldUpdate12.operation = 'Formula';
        approvedfldUpdate12.formula = '$User.FirstName + $User.LastName';

        
        
        GFSMetadataService.WorkflowFieldUpdate rejectedfldUpdate = new GFSMetadataService.WorkflowFieldUpdate();
        rejectedfldUpdate.field = 'GFSDR__Rejected_Stage__c';
        rejectedfldUpdate.name = 'Update_Rejected_Stage_to_CAB_Review';
        rejectedfldUpdate.fullName = 'GFSDR__Deployment_Request__c.Update_Rejected_Stage_to_CAB_Review';
        rejectedfldUpdate.protected_x = false;
        rejectedfldUpdate.notifyAssignee = false;
        rejectedfldUpdate.operation = 'Formula';
        rejectedfldUpdate.formula = '"CAB Review"';
        
        
        
        if(!Test.isRunningTest()){
            List<GFSMetadataService.SaveResult> approvedResults = service.createMetadata( new GFSMetadataService.Metadata[] {approvedfldUpdate,approvedfldUpdate12,rejectedfldUpdate});
       //    List<GFSMetadataService.SaveResult> approvedResults1 = service.createMetadata( new GFSMetadataService.Metadata[] {approvedfldUpdate12});
        system.debug('>>>>>>>results:'+approvedResults );
        }
        GFSMetadataService.WorkflowFieldUpdate rejectedfldUpdte = new GFSMetadataService.WorkflowFieldUpdate();
        rejectedfldUpdte.field = 'GFSDR__Stage_txt__c';
        rejectedfldUpdte.name = 'Update_Stage_equals_Rejected';
        rejectedfldUpdte.fullName = 'GFSDR__Deployment_Request__c.Update_Stage_equals_Rejected';
        rejectedfldUpdte.protected_x = false;
        rejectedfldUpdte.notifyAssignee = false;
        rejectedfldUpdte.operation = 'Formula';
        rejectedfldUpdte.formula = '"Rejected"';
        
        if(!Test.isRunningTest())
            List<GFSMetadataService.SaveResult> rejectedResults = service.createMetadata( new GFSMetadataService.Metadata[] {rejectedfldUpdte});
                
        GFSMetadataService.WorkflowActionReference finalApprovalAction = new GFSMetadataService.WorkflowActionReference();
        finalApprovalAction.name = 'Update_Stage_equals_Approved';
        finalApprovalAction.type_x = 'FieldUpdate';        
        GFSMetadataService.ApprovalAction finalappAction = new GFSMetadataService.ApprovalAction();
        finalappAction.action = new list<GFSMetadataService.WorkflowActionReference>{finalApprovalAction} ;            
        approvalProcess.finalApprovalActions = finalappAction;
        
        GFSMetadataService.WorkflowActionReference finalRejectAction = new GFSMetadataService.WorkflowActionReference();
        finalRejectAction.name = 'Update_Stage_equals_Rejected';
        finalRejectAction.type_x = 'FieldUpdate';        
        GFSMetadataService.ApprovalAction finalrejAction = new GFSMetadataService.ApprovalAction();
        finalrejAction.action = new list<GFSMetadataService.WorkflowActionReference>{finalRejectAction} ;            
        approvalProcess.finalRejectionActions = finalrejAction;
             

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
                otherFilterEntry.field = 'GFSDR__Deployment_Request__c.GFSDR__Application_Category_txt__c';
                otherFilterEntry.operation = 'equals';
                otherFilterEntry.value = 'Standard Apps';            
            } else {
                otherFilterEntry.field = 'GFSDR__Deployment_Request__c.GFSDR__Application_Name_txt__c';
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
            approvedAction.name = 'Update_Stage_equals_Approvedd';
            approvedAction.type_x = 'FieldUpdate';
            
            
            GFSMetadataService.WorkflowActionReference approvedAction2 = new GFSMetadataService.WorkflowActionReference();
            approvedAction2.name = 'Update_CAB_Approverr';
            approvedAction2.type_x = 'FieldUpdate';
            
            GFSMetadataService.WorkflowActionReference rejectedAction = new GFSMetadataService.WorkflowActionReference();
            rejectedAction.name = 'Update_Rejected_Stage_to_CAB_Review';
            rejectedAction.type_x = 'FieldUpdate';
                        

            GFSMetadataService.ApprovalAction approvedStepAction = new GFSMetadataService.ApprovalAction();
            approvedStepAction.action = new list<GFSMetadataService.WorkflowActionReference>{approvedAction,approvedAction2 } ;
            
            GFSMetadataService.ApprovalAction taRjStepActionAll = new GFSMetadataService.ApprovalAction();
            taRjStepActionAll.action = new list<GFSMetadataService.WorkflowActionReference>{rejectedAction} ;
            otherApprovalStep.rejectionActions = taRjStepActionAll;
                    
            otherApprovalStep.approvalActions = approvedStepAction;                
            approvalProcess.approvalStep.add(otherApprovalStep);                                                
        }
        
        if(!Test.isRunningTest()){
            List<GFSMetadataService.SaveResult> results3 = service.createMetadata( new GFSMetadataService.Metadata[] { approvalProcess });
            system.debug('>>>>>>>results:'+results3);    
            Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
            message.setSubject('Approval Proccess Exception');
            message.setHtmlBody('Approval process result:'+results3);
            message.setToAddresses(new list<string>{'anushribhushan.sarwade@globalfoundries.com','ramprakash.rai@globalfoundries.com'});
           // Messaging.sendEmail(new Messaging.SingleEmailMessage[] { message });
            isUATProcCreated = true;
        }
        }catch(Exception ex){
             system.debug('-mssg-'+ex.getmessage());        
             Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
             message.setSubject('Approval Proccess Exception');
             message.setHtmlBody('Exception:'+ex.getMessage());
             message.setToAddresses(new list<string>{'anushribhushan.sarwade@globalfoundries.com','ramprakash.rai@globalfoundries.com'});
           //  Messaging.sendEmail(new Messaging.SingleEmailMessage[] { message });
        }   
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
            QueueSObject q = new QueueSObject(SobjectType='GFSDR__Deployment_Request__c', QueueId=g.Id);
            newQueues.add(q);
        }        
        insert newQueues;
        
        //insert Group members
        extQueues = [Select Id, name from Group where Name in :queueNames];
        extqueueMap = new map<string, Id>();
        for(Group g :extQueues)
            extqueueMap.put(g.Name, g.Id);
            
        system.debug('>>>>>>>>>>>>>>>extqueueMap:'+extqueueMap);
        //insert group members
        list<GroupMember> newMembers = new list<GroupMember>();            
        for(Application_Approver__c nApprover :newApprovers){
            system.debug('>>>>>>>>>>>>nApprover:'+nApprover);
            system.debug('>>>>'+extqueueMap.containsKey('DR '+nApprover.Application_Name__c+' '+nApprover.Role__c));    
            string role = nApprover.Role__c;
            role = role.toUpperCase();        
            if(extqueueMap.containsKey('DR '+nApprover.Application_Name__c+' '+role)){
                GroupMember member = new GroupMember();
                member.UserOrGroupId = nApprover.User__c;
                member.GroupId = extqueueMap.get('DR '+nApprover.Application_Name__c+' '+role);
                newMembers.add(member);
            }
        }        
        insert newMembers;    
    }
    
    public void addPickVal(){
        leftvalues.add(newpicklistVal);
    }
    
    public void add(){
        //add value to the picklist field
        try{
            map<string, string> removedValMap = new map<string, string>();
            for(string r: removedValues)
                removedValMap.put(r,r);
            system.debug('>>>>>>>>>>>picklistName:'+picklistName);
            if(picklistName != null){
            GFSMetadataService.MetadataPort service = new GFSMetadataService.MetadataPort();   
            service.SessionHeader = new GFSMetadataService.SessionHeader_element();
            service.timeout_x = 120000;
            service.SessionHeader.sessionId = userinfo.getSessionId();
            GFSMetadataService.CustomField customField = new GFSMetadataService.CustomField();
            GFSMetadataService.PickListValue[] pickVals = new list<GFSMetadataService.PickListValue>();
            GFSMetadataService.PickListValue[] newpickVals = new list<GFSMetadataService.PickListValue>();
            customField = (GFSMetadataService.CustomField) service.readMetadata('CustomField', new String[] { 'GFSDR__DR_Configuration__c.'+picklistName}).getRecords()[0];
            pickVals = customField.picklist.picklistValues;
            system.debug('>>>>>>>>>>>>pickVals:'+pickVals);
            for(string str: newlyAddedValues){
                GFSMetadataService.PicklistValue two = new GFSMetadataService.PicklistValue();
                two.fullName= str;
                two.default_x=false;   
                two.isActive = true;
                customField.picklist.picklistValues.add(two);
                newpickVals.add(two);            
            }           
            
            for(GFSMetadataService.PickListValue pk: pickVals){
                system.debug('>>>>>>>>>>>>pk.fullName:'+pk.fullName);
                if(removedValMap.containsKey(pk.fullName)){
                    pk.isActive = false;
                    newpickVals.add(pk);
                }
            }
            if(!Test.isRunningTest())
                List<GFSMetadataService.SaveResult> results2 = service.updateMetadata(new GFSMetadataService.Metadata[] { customField });
            //ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,'Picklist values added successfully'));
            }  
        }catch(Exception ex){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,ex.getMessage()));
        }   
    }
    
    public void save(){
        
        if(config.Admin_Email__c != null){
             ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,'DR Configurations saved successfully'));   
            long now = datetime.now().gettime();
            while(datetime.now().gettime()-now<2000);
            add();
            upsert config;
           
        }else{
        
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'Please Enter Configure Admin Email'));   
        }
         
        /* list<Application_Approver__c> appApprovers = new list<Application_Approver__c>();

        upsert appApprovers;
        
        set<Id> appIds = new set<Id>();
        for(Application_Approver__c approver :appApprovers){
            appIds.add(approver.Id);                    
        } */
        
        //updateDRQueues(appIds);
     
    }   
}