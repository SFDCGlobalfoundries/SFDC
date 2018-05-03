public class DeploymentRequestController{
    
    public list<SelectOption> additionalNotes{get; set;}
    public list<SelectOption> applicationCategory{get; set;}
    public list<SelectOption> applicationName{get; set;}
    public list<SelectOption> changeType{get; set;}
    public list<SelectOption> deploymentStatus{get; set;}
    public list<SelectOption> codeReviewCompleted{get; set;}
    public list<SelectOption> taReviewCompleted{get; set;}
    public list<SelectOption> tfaReviewCompleted{get; set;}
    public list<SelectOption> requestType{get; set;}
    public list<SelectOption> reviewStatus{get; set;}
    public list<SelectOption> supportKTStatus{get; set;}
    public list<SelectOption> targetEnvironment{get; set;}
    public list<SelectOption> sourceEnvironment{get; set;}
    public list<SelectOption> stages{get; set;}
    public list<SelectOption> systemAffected{get; set;}
    
    public string notes{get; set;}
    public string appCategory{get; set;}
    public string appName{get; set;}
    public string dstatus{get; set;}
    public string codereview{get; set;}
    public string tareview{get; set;}
    public string tfareview{get; set;}
    public string reqtype{get; set;}
    public string rstatus{get; set;}
    public string ktstatus{get; set;}
    public string targetenv{get; set;}
    public string stage{get; set;}

    public Deployment_Request__c drObject{get; set;}
    public DR_Configuration__c drconfig{get; set;}
    
    public boolean disableChangeType{get; set;}
    public boolean disableApplicationName{get; set;}

    public DeploymentRequestController(ApexPages.StandardController controller) {
        drconfig = new DR_Configuration__c();
        drObject = new Deployment_Request__c();          
        controller.addFields(new String[]{
            'CR_Number__c','Request_Type_txt__c','Change_Type_txt__c','Source_Environment_txt__c','Target_Environment_txt__c','Deployment_Status_txt__c',
            'Deployment_Request_Date_Time__c','RM_Review_Status_txt__c','Application_Category_txt__c','Application_Name_txt__c','System_Affected_txt__c',
            'Clarity_Project_Id__c','Stage_txt__c','Is_TFA_Review_Completed_txt__c','Short_Description__c','UAT_DR__c','Description__c','Compliance_Review_Required__c',
            'TFA_Review_User__c','TA_Review_User__c','Code_Review_User__c','Is_TFA_Review_Completed_txt__c','Is_TA_Review_Completed_txt__c','Is_Code_Review_Completed_txt__c',
            'Support_KT_Date__c','Support_KT_Status_txt__c','Additional_Comments_txt__c','RM_Approval_Date__c','Administrator_to_Deploy__c','Deployment_End_Date_Time__c',
            'Deployment_Start_Date_Time__c','Submitted_Date__c','Approval_Date__c','Administrator_Comment__c','OwnerId' 
        });
        drObject = (Deployment_Request__c)controller.getRecord();
        if(drObject.Id == null){
            drObject.Deployment_Status_txt__c = 'Not Started';
            drObject.RM_Review_Status_txt__c = 'Not Started';
            drObject.Stage_txt__c = 'Draft';
        }
        init();
        if(drObject.Change_Type_txt__c != null){
            disableChangeType = false; 
            fetchChangeTypeValues();
        }
        if(drObject.Application_Name_txt__c != null){
            disableApplicationName = false;    
            fetchApplicationNameValues();
        }
    }
        
    public DeploymentRequestController(){ }
    
    public void init(){
        additionalNotes = new list<SelectOption>();
        Schema.DescribeFieldResult notesResult = DR_Configuration__c.Additional_Notes__c.getDescribe();
        List<Schema.PicklistEntry> notesPle = notesResult.getPicklistValues();
        for(Schema.PicklistEntry f : notesPle)
            additionalNotes.add(new SelectOption(f.getLabel(), f.getValue()));       

        applicationCategory = new list<SelectOption>();
        applicationCategory.add(new SelectOption('','--None--'));
        Schema.DescribeFieldResult categoryResult = DR_Configuration__c.Application_Category__c.getDescribe();
        List<Schema.PicklistEntry> categoryPle = categoryResult.getPicklistValues();
        for(Schema.PicklistEntry f : categoryPle)
            applicationCategory.add(new SelectOption(f.getLabel(), f.getValue()));       

        applicationName = new list<SelectOption>();
        applicationName.add(new SelectOption('','--None--'));
        //Schema.DescribeFieldResult appNameResult = DR_Configuration__c.Application_Name__c.getDescribe();
        //List<Schema.PicklistEntry> appNameple = appNameResult.getPicklistValues();
        //for(Schema.PicklistEntry f : appNameple)
        //    applicationName.add(new SelectOption(f.getLabel(), f.getValue()));       

        changeType = new list<SelectOption>();
        changeType.add(new SelectOption('','--None--'));
        //Schema.DescribeFieldResult changeTypeResult = DR_Configuration__c.Change_Type__c.getDescribe();
        //List<Schema.PicklistEntry> changeTypeple = changeTypeResult.getPicklistValues();
        //for(Schema.PicklistEntry f : changeTypeple)
        //    changeType.add(new SelectOption(f.getLabel(), f.getValue()));           
            
        deploymentStatus = new list<SelectOption>();
        deploymentStatus.add(new SelectOption('','--None--'));
        Schema.DescribeFieldResult deploymentStatusResult = DR_Configuration__c.Deployment_Status__c.getDescribe();
        List<Schema.PicklistEntry> deploymentStatusple = deploymentStatusResult.getPicklistValues();
        for(Schema.PicklistEntry f : deploymentStatusple)
            deploymentStatus.add(new SelectOption(f.getLabel(), f.getValue()));                               

        codeReviewCompleted = new list<SelectOption>();
        codeReviewCompleted.add(new SelectOption('','--None--'));
        Schema.DescribeFieldResult codeReviewResult = DR_Configuration__c.Is_Code_Review_Completed__c.getDescribe();
        List<Schema.PicklistEntry> codeReviewple = codeReviewResult.getPicklistValues();
        for(Schema.PicklistEntry f : codeReviewple)
            codeReviewCompleted.add(new SelectOption(f.getLabel(), f.getValue()));                       

        taReviewCompleted = new list<SelectOption>();
        taReviewCompleted.add(new SelectOption('','--None--'));
        Schema.DescribeFieldResult taReviewResult = DR_Configuration__c.Is_TA_Review_Completed__c.getDescribe();
        List<Schema.PicklistEntry> taReviewple = taReviewResult.getPicklistValues();
        for(Schema.PicklistEntry f : taReviewple)
            taReviewCompleted.add(new SelectOption(f.getLabel(), f.getValue()));                       

        tfaReviewCompleted = new list<SelectOption>();
        tfaReviewCompleted.add(new SelectOption('','--None--'));
        Schema.DescribeFieldResult tfaReviewResult = DR_Configuration__c.Is_TFA_Review_Completed__c.getDescribe();
        List<Schema.PicklistEntry> tfaReviewple = tfaReviewResult.getPicklistValues();
        for(Schema.PicklistEntry f : tfaReviewple)
            tfaReviewCompleted.add(new SelectOption(f.getLabel(), f.getValue()));                       

        requestType = new list<SelectOption>();
        requestType.add(new SelectOption('','--None--'));
        Schema.DescribeFieldResult requestTypeResult = DR_Configuration__c.Request_Type__c.getDescribe();
        List<Schema.PicklistEntry> requestTypeple = requestTypeResult.getPicklistValues();
        for(Schema.PicklistEntry f : requestTypeple)
            requestType.add(new SelectOption(f.getLabel(), f.getValue()));                       

        reviewStatus = new list<SelectOption>();
        reviewStatus.add(new SelectOption('','--None--'));
        Schema.DescribeFieldResult reviewStatusResult = DR_Configuration__c.Review_Status__c.getDescribe();
        List<Schema.PicklistEntry> reviewStatusple = reviewStatusResult.getPicklistValues();
        for(Schema.PicklistEntry f : reviewStatusple)
            reviewStatus.add(new SelectOption(f.getLabel(), f.getValue()));                       

        supportKTStatus = new list<SelectOption>();
        supportKTStatus.add(new SelectOption('','--None--'));
        Schema.DescribeFieldResult supportKTResult = DR_Configuration__c.Support_KT_Status__c.getDescribe();
        List<Schema.PicklistEntry> supportKTple = supportKTResult.getPicklistValues();
        for(Schema.PicklistEntry f : supportKTple)            
            supportKTStatus.add(new SelectOption(f.getLabel(), f.getValue()));     
                              
        targetEnvironment = new list<SelectOption>();
        targetEnvironment.add(new SelectOption('','--None--'));
        Schema.DescribeFieldResult targetEnvResult = DR_Configuration__c.Target_Environment__c.getDescribe();
        List<Schema.PicklistEntry> targetEnvple = targetEnvResult.getPicklistValues();
        for(Schema.PicklistEntry f : targetEnvple)
            targetEnvironment.add(new SelectOption(f.getLabel(), f.getValue()));                           

        sourceEnvironment = new list<SelectOption>();
        sourceEnvironment.add(new SelectOption('','--None--'));
        Schema.DescribeFieldResult sourceResult = DR_Configuration__c.Source_Environment__c.getDescribe();
        List<Schema.PicklistEntry> sourceple = sourceResult.getPicklistValues();
        for(Schema.PicklistEntry f : sourceple)
            sourceEnvironment.add(new SelectOption(f.getLabel(), f.getValue()));                               

        stages = new list<SelectOption>();
        stages.add(new SelectOption('','--None--'));
        Schema.DescribeFieldResult stageResult = DR_Configuration__c.Stage__c.getDescribe();
        List<Schema.PicklistEntry> stageple = stageResult.getPicklistValues();
        for(Schema.PicklistEntry f : stageple)
            stages.add(new SelectOption(f.getLabel(), f.getValue()));                                   

        systemAffected = new list<SelectOption>();
        Schema.DescribeFieldResult systemAffectedResult = DR_Configuration__c.System_Affected__c.getDescribe();
        List<Schema.PicklistEntry> systemAffectedple = systemAffectedResult.getPicklistValues();
        for(Schema.PicklistEntry f : systemAffectedple)
            systemAffected.add(new SelectOption(f.getLabel(), f.getValue()));                                   
    }
    
    public void fetchChangeTypeValues(){
        changeType = new list<SelectOption>();
        changeType.add(new SelectOption('','--None--'));
        system.debug('>>>>>>>>>drObject.Request_Type_txt__c:'+drObject.Request_Type_txt__c);
        if(drObject.Request_Type_txt__c != null){
            GFSMetadataService.MetadataPort service = new GFSMetadataService.MetadataPort();   
            service.SessionHeader = new GFSMetadataService.SessionHeader_element();
            service.timeout_x = 120000;
            service.SessionHeader.sessionId = userinfo.getSessionId();
            GFSMetadataService.CustomField customField = (GFSMetadataService.CustomField) service.readMetadata('CustomField', new String[] { 'DR_Configuration__c.Change_Type__c' }).getRecords()[0];
            for(GFSMetadataService.PicklistValue picklistValue : customField.picklist.picklistValues) {
                if(( picklistValue.controllingFieldValues == null ) || new Set<String>( picklistValue.controllingFieldValues ).contains(drObject.Request_Type_txt__c)) {
                    changeType.add(new SelectOption(picklistValue.fullName, picklistValue.fullName));  
                    disableChangeType = false;    
                }
            }  
        } else {
            disableChangeType = true;
        }  
    }
    
    public void fetchApplicationNameValues(){
        applicationName = new list<SelectOption>();
        applicationName.add(new SelectOption('','--None--'));
        
        if(drObject.Application_Category_txt__c != null){
            GFSMetadataService.MetadataPort service = new GFSMetadataService.MetadataPort();   
            service.SessionHeader = new GFSMetadataService.SessionHeader_element();
            service.timeout_x = 120000;
            service.SessionHeader.sessionId = userinfo.getSessionId();
            GFSMetadataService.CustomField customField = (GFSMetadataService.CustomField) service.readMetadata('CustomField', new String[] { 'DR_Configuration__c.Application_Name__c' }).getRecords()[0];
            for(GFSMetadataService.PicklistValue picklistValue : customField.picklist.picklistValues) {
                if(( picklistValue.controllingFieldValues == null ) || new Set<String>( picklistValue.controllingFieldValues ).contains(drObject.Application_Category_txt__c)) {
                    applicationName.add(new SelectOption(picklistValue.fullName, picklistValue.fullName));  
                    disableApplicationName = false;    
                }
            }  
        } else {
            disableApplicationName = true;
        }              
    }
      
    public Pagereference save(){
        try{
            system.debug('drObject.Change_Type_txt__c:'+drObject.Change_Type_txt__c);
            system.debug('drObject.Application_Name_txt__c:'+drObject.Application_Name_txt__c);
            //required field validations
            if(drObject.Request_Type_txt__c == null){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'Please select Request Type'));
                return null;
            }
            if(drObject.Source_Environment_txt__c == ''){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'Please select Source Environment'));
                return null;            
            }
            if(drObject.Target_Environment_txt__c == ''){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'Please select Target Environment'));
                return null;            
            }
            
            if(drObject.Application_Category_txt__c == ''){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'Please select Application Category'));
                return null;            
            }

            if(drObject.Is_TFA_Review_Completed_txt__c == ''){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'Please select Is TFA Review Completed'));
                return null;            
            }

            if(drObject.Is_TA_Review_Completed_txt__c == ''){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'Please select Is TA Review Completed'));
                return null;            
            }
            
            if(drObject.Is_Code_Review_Completed_txt__c == ''){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'Please select Is Code Review Completed'));
                return null;            
            }
            
            list<string> groupIds = new list<string>();
            string grpStartswithName = 'DR_Account_Mgmt';
            if(drObject.Application_Name_txt__c == 'Account Management')
                grpStartswithName = 'DR_Account_Mgmt';
            if(drObject.Application_Name_txt__c == 'Opportunity Management')
                grpStartswithName = 'DR_Opportunity_Mgmt';
            if(drObject.Application_Name_txt__c == 'PX - Risk Start System')
                grpStartswithName = 'DR_Risk_Start';
            if(drObject.Application_Name_txt__c == 'RMA')
                grpStartswithName = 'DR_RMA';
            if(drObject.Application_Category_txt__c == 'Standard Apps') 
                grpStartswithName = 'DR_Default';   
                
            list<Group> drgroups = [Select Id, Name from Group where DeveloperName like :grpStartswithName+'%'];
            map<string, Id> grpMap = new map<string, Id>();
            for(Group gp: drgroups)
                grpMap.put(gp.Name, gp.Id);
            
            list<GroupMember> drGroupMembers = [Select UserOrGroupId, GroupId from GroupMember where GroupId IN :grpMap.values()];
            map<Id, list<string>> grpIdGrpMembers = new map<Id, list<string>>();
            for(GroupMember member: drGroupMembers){
                if(!grpIdGrpMembers.containsKey(member.GroupId))
                    grpIdGrpMembers.put(member.GroupId, new list<string>{member.UserOrGroupId});
                else
                    grpIdGrpMembers.get(member.GroupId).add(member.UserOrGroupId);
            }
            system.debug('>>>>>>>>>>>>grpIdGrpMembers:'+grpIdGrpMembers);                
            upsert drObject;             
        }catch(Exception ex){
            system.debug('Exception:'+ex);
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,ex.getMessage()));
            return null;
        }       
        return new PageReference('/'+drObject.Id).setRedirect(true);
    }
    
    public Pagereference cancel(){
        return new PageReference('/'+drObject.Id).setRedirect(true);    
    }
}