public class DRConfigurationController{
    
    public list<SelectOption> picklistValues{get; set;}
    public string picklistName{get; set;}
    public string newpicklistVal{get; set;}
    public string serverURL{get; set;}
    
    public DR_Configuration__c config{get; set;}
    
    public string customObjectId{get; set;}       
    public string dependentFieldVal{get; set;}
    public string controllingFieldVal{get; set;}
    
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
        
        public DRApproverWrapper(string aname){
            approverObj = new Application_Approver__c();
            approverObj.Application_Name__c = aname;
        }  
        
        public DRApproverWrapper(Application_Approver__c extapp){
            approverObj = new Application_Approver__c();
            approverObj = extapp;
        }     
    }
    public list<DRApproverWrapper> accMgmtdrApprovers{get; set;}
    public list<DRApproverWrapper> optyMgmtdrApprovers{get; set;}
    public list<DRApproverWrapper> rmadrApprovers{get; set;}
    public list<DRApproverWrapper> riskStartdrApprovers{get; set;}
    public list<DRApproverWrapper> defaultdrApprovers{get; set;}
    
        
    public DRConfigurationController(){
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
        
        //retrieve applications approvers data
        list<Application_Approver__c> existingApprovers = [Select Id, name, User__c, Application_Name__c, Role__c from Application_Approver__c];
        accMgmtdrApprovers = new list<DRApproverWrapper>();
        optyMgmtdrApprovers = new list<DRApproverWrapper>();
        riskStartdrApprovers = new list<DRApproverWrapper>();
        rmadrApprovers = new list<DRApproverWrapper>();
        defaultdrApprovers = new list<DRApproverWrapper>();
        
        if(existingApprovers.size() > 0){
            for(Application_Approver__c ext: existingApprovers){
                if(ext.Application_Name__c == 'Account Management')
                    accMgmtdrApprovers.add(new DRApproverWrapper(ext));
                if(ext.Application_Name__c == 'Opportunity Management')
                    optyMgmtdrApprovers.add(new DRApproverWrapper(ext));
                if(ext.Application_Name__c == 'RMA')
                    rmadrApprovers.add(new DRApproverWrapper(ext));
                if(ext.Application_Name__c == 'Risk Start')
                    riskStartdrApprovers.add(new DRApproverWrapper(ext));
                if(ext.Application_Name__c == 'Default')
                    defaultdrApprovers.add(new DRApproverWrapper(ext));
            }
        }else{
            accMgmtdrApprovers.add(new DRApproverWrapper('Account Management'));
            accMgmtdrApprovers.add(new DRApproverWrapper('Account Management'));
            accMgmtdrApprovers.add(new DRApproverWrapper('Account Management'));
            accMgmtdrApprovers.add(new DRApproverWrapper('Account Management'));
            
            optyMgmtdrApprovers.add(new DRApproverWrapper('Opportunity Management'));
            optyMgmtdrApprovers.add(new DRApproverWrapper('Opportunity Management'));
            optyMgmtdrApprovers.add(new DRApproverWrapper('Opportunity Management'));
            optyMgmtdrApprovers.add(new DRApproverWrapper('Opportunity Management'));
            
            rmadrApprovers.add(new DRApproverWrapper('RMA'));
            rmadrApprovers.add(new DRApproverWrapper('RMA'));
            rmadrApprovers.add(new DRApproverWrapper('RMA'));
            rmadrApprovers.add(new DRApproverWrapper('RMA'));
            
            riskStartdrApprovers.add(new DRApproverWrapper('Risk Start'));
            riskStartdrApprovers.add(new DRApproverWrapper('Risk Start'));
            riskStartdrApprovers.add(new DRApproverWrapper('Risk Start'));
            riskStartdrApprovers.add(new DRApproverWrapper('Risk Start'));
            
            defaultdrApprovers.add(new DRApproverWrapper('Default'));
            defaultdrApprovers.add(new DRApproverWrapper('Default'));
            defaultdrApprovers.add(new DRApproverWrapper('Default'));
            defaultdrApprovers.add(new DRApproverWrapper('Default'));
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
    
    public void accMgmtAddRow(){
        accMgmtdrApprovers.add(new DRApproverWrapper('Account Management'));
    }
    
    public void opptyMgmtAddRow(){
        optyMgmtdrApprovers.add(new DRApproverWrapper('Opportunity Management'));
    }

    public void riskStartAddRow(){
        riskStartdrApprovers.add(new DRApproverWrapper('Risk Start'));
    }

    public void rmaAddRow(){
        rmadrApprovers.add(new DRApproverWrapper('RMA'));
    }
    
    public void defaultAddRow(){
        defaultdrApprovers.add(new DRApproverWrapper('Default'));    
    }

    public void save(){
        upsert config;
        
        list<Application_Approver__c> appApprovers = new list<Application_Approver__c>();
        for(DRApproverWrapper wrapper: accMgmtdrApprovers){
            if(wrapper.approverObj.User__c != null && wrapper.approverObj.Role__c != null)
                appApprovers.add(wrapper.approverObj);
        }
        for(DRApproverWrapper wrapper: optyMgmtdrApprovers){
            if(wrapper.approverObj.User__c != null && wrapper.approverObj.Role__c != null)
                appApprovers.add(wrapper.approverObj);
        }        
        for(DRApproverWrapper wrapper: riskStartdrApprovers){
            if(wrapper.approverObj.User__c != null && wrapper.approverObj.Role__c != null)
                appApprovers.add(wrapper.approverObj);
        }        
        for(DRApproverWrapper wrapper: rmadrApprovers){
            if(wrapper.approverObj.User__c != null && wrapper.approverObj.Role__c != null)
                appApprovers.add(wrapper.approverObj);
        }        
        for(DRApproverWrapper wrapper: defaultdrApprovers){
            if(wrapper.approverObj.User__c != null && wrapper.approverObj.Role__c != null)
                appApprovers.add(wrapper.approverObj);
        }        
        upsert appApprovers;
        
        set<Id> appIds = new set<Id>();
        for(Application_Approver__c approver :appApprovers){
            appIds.add(approver.Id);                    
        }
        
        updateDRQueues(appIds);
        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,'DR Configurations saved successfully'));
    }
    
    @future
    public static void updateDRQueues(set<Id> approverIds){
        list<Application_Approver__c> appApprovers = [Select Id, Name, User__c, Role__c, Application_Name__c From Application_Approver__c where Id IN :approverIds];
        //insert approvers in queue as a member
        list<GroupMember> members = new list<GroupMember>();
        
        list<Group> grps = [Select Id, name, DeveloperName from Group where DeveloperName IN ('DR_Account_Mgmt_CAB','DR_Account_Mgmt_EBIZ_FBO','DR_Account_Mgmt_SOD','DR_Account_Mgmt_Test','DR_Default_CAB','DR_Default_EBIZ_FBO','DR_Default_Test','DR_Opportunity_Mgmt_CAB','DR_Opportunity_Mgmt_EBIZ_FBO','DR_Opportunity_Mgmt_SOD','DR_Opportunity_Mgmt_Test','DR_Risk_Start_CAB','DR_Risk_Start_EBIZ_FBO','DR_Risk_Start_SOD','DR_Risk_Start_Test','DR_RMA_CAB','DR_RMA_EBIZ_FBO','DR_RMA_SOD','DR_RMA_Test')];
        map<string,Id> grpMap = new map<string,Id>();
        for(Group g: grps)
            grpMap.put(g.DeveloperName,g.Id);
        
        system.debug('>>>>>>>grpMap:'+grpMap);
        //delete existing members of grp
        list<GroupMember> extmembers = [Select UserOrGroupId, GroupId from GroupMember where GroupId IN :grpMap.values()];
        delete extmembers;
        
        list<GroupMember> grpMembers = new list<GroupMember>();        
        for(Application_Approver__c approver: appApprovers){
            GroupMember newMember = new GroupMember();
            newMember.UserOrGroupId = approver.User__c;
            if(approver.Application_Name__c == 'Account Management' && approver.Role__c == 'EBiZ/FBO')
                newMember.GroupId = grpMap.get('DR_Account_Mgmt_EBIZ_FBO');
            if(approver.Application_Name__c == 'Account Management' && approver.Role__c == 'CAB')
                newMember.GroupId = grpMap.get('DR_Account_Mgmt_CAB');
            if(approver.Application_Name__c == 'Account Management' && approver.Role__c == 'SOD')
                newMember.GroupId = grpMap.get('DR_Account_Mgmt_SOD');
            if(approver.Application_Name__c == 'Account Management' && approver.Role__c == 'TEST')
                newMember.GroupId = grpMap.get('DR_Account_Mgmt_Test');

            if(approver.Application_Name__c == 'Opportunity Management' && approver.Role__c == 'EBiZ/FBO')
                newMember.GroupId = grpMap.get('DR_Opportunity_Mgmt_EBIZ_FBO');
            if(approver.Application_Name__c == 'Opportunity Management' && approver.Role__c == 'CAB')
                newMember.GroupId = grpMap.get('DR_Opportunity_Mgmt_CAB');            
            if(approver.Application_Name__c == 'Opportunity Management' && approver.Role__c == 'SOD')
                newMember.GroupId = grpMap.get('DR_Opportunity_Mgmt_SOD');
            if(approver.Application_Name__c == 'Opportunity Management' && approver.Role__c == 'TEST')
                newMember.GroupId = grpMap.get('DR_Opportunity_Mgmt_Test');

            if(approver.Application_Name__c == 'Risk Start' && approver.Role__c == 'EBiZ/FBO')
                newMember.GroupId = grpMap.get('DR_Risk_Start_EBIZ_FBO');
            if(approver.Application_Name__c == 'Risk Start' && approver.Role__c == 'CAB')
                newMember.GroupId = grpMap.get('DR_Risk_Start_CAB');            
            if(approver.Application_Name__c == 'Risk Start' && approver.Role__c == 'SOD')
                newMember.GroupId = grpMap.get('DR_Risk_Start_SOD');
            if(approver.Application_Name__c == 'Risk Start' && approver.Role__c == 'TEST')
                newMember.GroupId = grpMap.get('DR_Risk_Start_Test');                

            if(approver.Application_Name__c == 'RMA' && approver.Role__c == 'EBiZ/FBO')
                newMember.GroupId = grpMap.get('DR_RMA_EBIZ_FBO');
            if(approver.Application_Name__c == 'RMA' && approver.Role__c == 'CAB')
                newMember.GroupId = grpMap.get('DR_RMA_CAB');            
            if(approver.Application_Name__c == 'RMA' && approver.Role__c == 'SOD')
                newMember.GroupId = grpMap.get('DR_RMA_SOD');
            if(approver.Application_Name__c == 'RMA' && approver.Role__c == 'TEST')
                newMember.GroupId = grpMap.get('DR_RMA_Test');                

            if(approver.Application_Name__c == 'Default' && approver.Role__c == 'EBiZ/FBO')
                newMember.GroupId = grpMap.get('DR_Default_EBIZ_FBO');
            if(approver.Application_Name__c == 'Default' && approver.Role__c == 'CAB')
                newMember.GroupId = grpMap.get('DR_Default_CAB');            
            if(approver.Application_Name__c == 'Default' && approver.Role__c == 'TEST')
                newMember.GroupId = grpMap.get('DR_Default_Test');   
                
            system.debug('>>>>>>>newMember:'+newMember);                             
            grpMembers.add(newMember);
        }
        upsert grpMembers;    
    }
}