global with sharing class GFSFieldHistoryObjectBatch implements Database.Batchable<sObject>, Database.Stateful,  Database.AllowsCallouts {
    string historyRecordId;
    string baseURL;
    string sessionId;
    string emailId;
    string objectName;
    string objectAPIName;
    string triggerres;
    public GFSFieldHistoryObjectBatch(string recordId, string bURL, string sId, string email, string objName){      
        historyRecordId = recordId; 
        baseURL = bURL;
        sessionId = sId;
        emailId = email;
        objectName = objName;
    }

    global Database.QueryLocator start(Database.BatchableContext BC) {
        string query = 'Select Id,Name,FieldNameList__c,Profiles__c from Set_Field_History__c where Id = :historyRecordId';
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext ctx, List<Sobject> scope) {
        GFSMetadataService.MetadataPort service = new GFSMetadataService.MetadataPort();   
        service.SessionHeader = new GFSMetadataService.SessionHeader_element();
        service.timeout_x = 120000;

        if(!Test.isRunningTest())
            service.SessionHeader.sessionId = sessionId;                               
        else
            service.SessionHeader.sessionId = '00Dp00000000pIU!AQwAQK63yIYv9A9RZqe2yv9iO5BfGpStu8MapHhNGN45P0JWl3uMe7bSnn5AzztDlF4NekQ7SB.FzFHR5GZOulVmlEfdUSmD';
        
        GFSMetadataService.CustomObject customObject = new GFSMetadataService.CustomObject();  
        list<Set_Field_History__c> sfh = (list<Set_Field_History__c>)scope;
        objectAPIName = sfh[0].Name;
        if(objectAPIName.contains('__c')){
            list<string> pieces = objectAPIName.split('__');
                if(pieces.size() > 2)
                    customObject.fullName = 'GFS_'+pieces[1]+'_History__c'; 
                else
                    customObject.fullName = 'GFS_'+objectAPIName.split('__c')[0]+'_History__c'; 
        } else{ 
            customObject.fullName = 'GFS_'+objectAPIName+'_History__c'; 
        }
        
        customObject.label = 'GFS '+objectName+' History';  
        customObject.pluralLabel = 'GFS '+objectName+' History'; 
        customObject.nameField = new GFSMetadataService.CustomField(); 
        customObject.nameField.type_x = 'AutoNumber';  
        customobject.nameField.DisplayFormat='H-{00000000}';  
        customObject.nameField.label = 'Name'; 
        customObject.deploymentStatus = 'Deployed'; 
        customObject.sharingModel = 'Read';
        if(!Test.isRunningTest())
            GFSMetadataService.SaveResult[] results = service.createMetadata(new List<GFSMetadataService.Metadata> { customObject });
        
        system.debug('customObject.fullName '+customObject.fullName +' '+objectAPIName); 
        GFSMetadataService.CustomField customField = new GFSMetadataService.CustomField(); 
        customField.fullName = customObject.fullName+'.ParentId__c'; 
        customField.label = 'ParentId'; customField.type_x = 'Lookup'; 
        customField.relationshipLabel = customObject.label; 
        customField.relationshipName = customObject.fullName.split('__c')[0]; 
        customField.referenceTo = objectAPIName;             
        
        GFSMetadataService.CustomField customField2 = new GFSMetadataService.CustomField();  
        customField2.fullName = customObject.fullName+'.Field__c'; 
        customField2.label = 'Field';  
        customField2.type_x = 'Text'; 
        customField2.length = 100;   
        GFSMetadataService.CustomField customField4 = new GFSMetadataService.CustomField(); 
        customField4.fullName = customObject.fullName+'.New_Value__c'; 
        customField4.label = 'New Value'; 
        customField4.type_x = 'Text'; 
        customField4.length = 200; 
        GFSMetadataService.CustomField customField5 = new GFSMetadataService.CustomField();
        customField5.fullName = customObject.fullName+'.Old_Value__c'; 
        customField5.label = 'Old Value'; 
        customField5.type_x = 'Text';           
        customField5.length = 200; 
        if(!Test.isRunningTest())  
            List<GFSMetadataService.SaveResult> results1 = service.createMetadata( new GFSMetadataService.Metadata[] {customField,customField2,customField4,customField5});
        
        string triggerName = 'GFS'+objectName.deleteWhitespace()+'HistoryTrigger';  
        string triggerBody = '';
        //if(baseURL.contains('sfsz'))
        //    triggerBody = 'trigger '+triggerName+' on '+objectAPIName+' (before update,after update) {if(trigger.isBefore){SFSZ.GFSSetFieldHistoryUpdate.preRequisite(trigger.oldMap,trigger.NewMap);}if(trigger.isAfter){SFSZ.GFSSetFieldHistoryUpdate.updateHistoryObject(trigger.oldMap,trigger.NewMap);}}';   
        //else 
        //GFS_Configuration__c config = GFS_Configuration__c.getValues('1');  
        string namespace = Label.GFSFieldHistoryNamespace;
        //if(config != null)
        //    namespace = config.Namespace__c.toUpperCase();                
        triggerBody = 'trigger '+triggerName+' on '+objectAPIName+' (before update,after update) {if(trigger.isBefore){'+namespace+'.GFSSetFieldHistoryUpdate.preRequisite(trigger.oldMap,trigger.NewMap);}if(trigger.isAfter){'+namespace+'.GFSSetFieldHistoryUpdate.updateHistoryObject(trigger.oldMap,trigger.NewMap);}}';
       
        String json = '{"Name" :\"'+ triggerName+'\", "TableEnumOrId" :\"'+ objectAPIName +'\", "Body" : \"'+triggerBody+'\"}';  
        Httprequest req1 = new HttpRequest(); 
        req1.setEndpoint(baseURL+'/services/data/v32.0/sobjects/ApexTrigger');
        req1.setMethod('POST');   
        req1.setTimeout(120000); 
        req1.setHeader('Content-Type', 'application/json'); 
        if(!Test.isRunningTest())
            req1.setHeader('Authorization', 'OAuth ' + sessionId); 
        else
            req1.setHeader('Authorization', 'OAuth 00Dp00000000pIU!AQwAQK63yIYv9A9RZqe2yv9iO5BfGpStu8MapHhNGN45P0JWl3uMe7bSnn5AzztDlF4NekQ7SB.FzFHR5GZOulVmlEfdUSmD');
        req1.setBody(json);

        Http httpReq1 = new Http();   
        if(!Test.isRunningTest()){ 
            HttpResponse res1 = httpReq1.send(req1);  
            triggerres = res1.getBody();
        }
        GFSMetadataService.Profile profile = new GFSMetadataService.Profile();    
        profile.fullName = 'Admin';   
        profile.custom = false;
    
        GFSMetadataService.ProfileFieldLevelSecurity fieldSec1 = new GFSMetadataService.ProfileFieldLevelSecurity();   
        fieldSec1.field=customField.fullName; 
        fieldSec1.editable=true;  
        GFSMetadataService.ProfileFieldLevelSecurity fieldSec2 = new GFSMetadataService.ProfileFieldLevelSecurity();   
        fieldSec2.field=customField2.fullName;
        fieldSec2.editable=true;  
        GFSMetadataService.ProfileFieldLevelSecurity fieldSec4 = new GFSMetadataService.ProfileFieldLevelSecurity();   
        fieldSec4.field=customField4.fullName; 
        fieldSec4.editable=true;  
        GFSMetadataService.ProfileFieldLevelSecurity fieldSec5 = new GFSMetadataService.ProfileFieldLevelSecurity();   
        fieldSec5.field=customField5.fullName; 
        fieldSec5.editable=true;
    
        profile.FieldPermissions = new GFSMetadataService.ProfileFieldLevelSecurity[] {fieldSec1,fieldSec2,fieldSec4,fieldSec5} ;  
        
        map<string, GFS_Configuration__c> configMap = GFS_Configuration__c.getAll();
        set<Id> userIds = new set<Id>();
        for(GFS_Configuration__c c: configMap.values()){
            if(c.Namespace__c == null)
                userIds.add(c.Name);
        }
        
        Organization org = [Select o.Id, o.CreatedDate, o.CreatedById From Organization o];
        list<User> users = [Select Id, Name, ProfileId from User where Id in :userIds];
        set<Id> profileIds = new set<Id>();
        for(User u: users)
            profileIds.add(u.profileId);    
        
        list<Profile> profiles = [Select id, name, createddate from Profile where Id in :profileIds];    
        map<string,boolean> profileDetails = new map<string,boolean>();
        for(Profile p: profiles){
            if(p.Name != 'System Administrator')
                if(p.CreatedDate > org.CreatedDate)
                    profileDetails.put(p.Name,true);
                else    
                    profileDetails.put(p.Name,false);
        }    
        
        list<GFSMetadataService.Profile> adminProfiles = new list<GFSMetadataService.Profile>();
        adminProfiles.add(profile);
        for(string p: profileDetails.keySet()){
            GFSMetadataService.Profile aprofile = new GFSMetadataService.Profile();    
            aprofile.fullName = p;   
            aprofile.custom = profileDetails.get(p);
        
            GFSMetadataService.ProfileFieldLevelSecurity fSec1 = new GFSMetadataService.ProfileFieldLevelSecurity();   
            fSec1.field=customField.fullName; 
            fSec1.editable=true;  
            GFSMetadataService.ProfileFieldLevelSecurity fSec2 = new GFSMetadataService.ProfileFieldLevelSecurity();   
            fSec2.field=customField2.fullName;
            fSec2.editable=true;  
            GFSMetadataService.ProfileFieldLevelSecurity fSec4 = new GFSMetadataService.ProfileFieldLevelSecurity();   
            fSec4.field=customField4.fullName; 
            fSec4.editable=true;  
            GFSMetadataService.ProfileFieldLevelSecurity fSec5 = new GFSMetadataService.ProfileFieldLevelSecurity();   
            fSec5.field=customField5.fullName; 
            fSec5.editable=true;
        
            aprofile.FieldPermissions = new GFSMetadataService.ProfileFieldLevelSecurity[] {fSec1,fSec2,fSec4,fSec5} ;    
            adminProfiles.add(aprofile);          
        }
        
        if(!Test.isRunningTest())
            List<GFSMetadataService.SaveResult> results2 =  service.updateMetadata(adminProfiles);    
        system.debug('Object batch executed successfully');                        
    }
    
    global void finish(Database.BatchableContext BC){
        //send trigger response email
        /* Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
        message.setToAddresses(new list<string>{'anushribhushan.sarwade@globalfoundries.com'});
        message.setSubject('Failed....');
        message.setHtmlBody('Hi,<br/><br/>'+triggerres+'.....base URL>>>>'+baseURL);                
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { message });  */
        //call to profile batch
        GFSFieldHistoryProfileBatch b = new GFSFieldHistoryProfileBatch(objectAPIName,sessionId,emailId,historyRecordId);
        Database.executeBatch(b,5);                                
    }
}