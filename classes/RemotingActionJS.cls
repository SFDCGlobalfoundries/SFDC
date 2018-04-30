global class RemotingActionJS{

    public RemotingActionJS(ApexPages.StandardController controller) {}
    public string requestType{get; set;}
    public string applicationCategory{get; set;}

    public RemotingActionJS(){}
    
    @RemoteAction
    global static list<SelectOption> fetchChangeTypeValues(string strRequestType){
        system.debug('>>>>>>>>>>fetchChangeTypeValues:'+strRequestType);    
        list<SelectOption> changeType = new list<SelectOption>();
        if(strRequestType != null){
            GFSMetadataService.MetadataPort service = new GFSMetadataService.MetadataPort();   
            service.SessionHeader = new GFSMetadataService.SessionHeader_element();
            service.timeout_x = 120000;
            service.SessionHeader.sessionId = userinfo.getSessionId();
            GFSMetadataService.CustomField customField = (GFSMetadataService.CustomField) service.readMetadata('CustomField', new String[] { 'DR_Configuration__c.Change_Type__c' }).getRecords()[0];
            for(GFSMetadataService.PicklistValue picklistValue : customField.picklist.picklistValues) {
                if(( picklistValue.controllingFieldValues == null ) || new Set<String>( picklistValue.controllingFieldValues ).contains(strRequestType)) {
                    changeType.add(new SelectOption(picklistValue.fullName, picklistValue.fullName));  
                }
            }  
        }    
        system.debug('>>>>>>>>>>changeType:'+changeType);    
        return changeType;
    }

    @RemoteAction
    global static list<SelectOption> fetchApplicationNameValues(string appCategory){
        list<SelectOption> applicationName = new list<SelectOption>();        
        if(appCategory != null){
            GFSMetadataService.MetadataPort service = new GFSMetadataService.MetadataPort();   
            service.SessionHeader = new GFSMetadataService.SessionHeader_element();
            service.timeout_x = 120000;
            service.SessionHeader.sessionId = userinfo.getSessionId();
            GFSMetadataService.CustomField customField = (GFSMetadataService.CustomField) service.readMetadata('CustomField', new String[] { 'DR_Configuration__c.Application_Name__c' }).getRecords()[0];
            for(GFSMetadataService.PicklistValue picklistValue : customField.picklist.picklistValues) {
                if(( picklistValue.controllingFieldValues == null ) || new Set<String>( picklistValue.controllingFieldValues ).contains(appCategory)) {
                    applicationName.add(new SelectOption(picklistValue.fullName, picklistValue.fullName));  
                }
            }  
        }     
        return applicationName;
    }
}