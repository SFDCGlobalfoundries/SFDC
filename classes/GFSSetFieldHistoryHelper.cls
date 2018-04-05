public class GFSSetFieldHistoryHelper{

        public static map<string, string> createSandboxMap(){
            map<string, string> sMap = new map<string, string>();
            sMap.put('diw','DIW');
            sMap.put('appreview','AppReview');
            sMap.put('amsdev','AMSDEV');
            sMap.put('appadmin','APPADMIN');
            sMap.put('apttusdev','ApttusDev');
            sMap.put('asic','ASIC');
            sMap.put('bugtracker','BugTracker');
            sMap.put('cedev','CEDEV');
            sMap.put('cedev2','CEDEV2');
            sMap.put('clmdev','CLMDEV');
            sMap.put('configdev','CONFIGDEV');
            sMap.put('cpksda','CPKSDA');
            sMap.put('crmdev','CRMDEV');
            sMap.put('diwsit','DIWSIT');
            sMap.put('diwtest','DIWTEST');
            sMap.put('dpl','DPL');
            sMap.put('dw','DW');
            sMap.put('gfvdev','GFVDev');
            sMap.put('hotfix','HOTFIX');
            sMap.put('ibmint','IBMINT');
            sMap.put('icc30m','ICC3OM');
            sMap.put('ipbug','IPBUG');
            sMap.put('itartest','ITARTEST');
            sMap.put('mpwdev','MPWDEV');
            sMap.put('ndadev','NDADev');
            sMap.put('ndadev1','NDADEV1');
            sMap.put('npcstf','NPCSTF');
            sMap.put('pdkdev','PDKDEV');
            sMap.put('pdkdev2017','PDKDEV2017');
            sMap.put('prodfix','PRODFIX');
            sMap.put('prodmstr','PRODMSTR');
            sMap.put('rmasddev','RMASDDev');
            sMap.put('rmdev','RMDEV');
            sMap.put('rmpoc','RMPOC');
            sMap.put('ros2016','ROS2016');
            sMap.put('sdafms','SDAFMS');
            sMap.put('service','Service');
            sMap.put('servicesit','ServiceSIT');
            sMap.put('sit','SIT');
            sMap.put('swiftdev','SwiftDev');
            sMap.put('swiftsit1','SWIFTSIT1');
            sMap.put('uat','UAT');
            sMap.put('sit2','SIT2');
            sMap.put('uat2','UAT2');
            sMap.put('preprod','PREPROD');
            return sMap;
        }
        
       /* @Future(callout=true)
        public static void updateProfileAccess(string objAPI, list<string> profNames, string sessionId, string email){
            GFSMetadataService.MetadataPort service = new GFSMetadataService.MetadataPort();   
            service.SessionHeader = new GFSMetadataService.SessionHeader_element();
            service.timeout_x = 120000;

            if(!Test.isRunningTest()){ 
                service.SessionHeader.sessionId = sessionId;      
            }else{
                service.SessionHeader.sessionId = '00Dp00000000pIU!AQwAQK63yIYv9A9RZqe2yv9iO5BfGpStu8MapHhNGN45P0JWl3uMe7bSnn5AzztDlF4NekQ7SB.FzFHR5GZOulVmlEfdUSmD';
            }

            //Selected Profile Field Level Security
            List<GFSMetadataService.Profile> profiles = new List<GFSMetadataService.Profile>();
            List<GFSMetadataService.SaveResult> cresults = new List<GFSMetadataService.SaveResult>();
            
            for (String pName : profNames) {
                GFSMetadataService.Profile p = new GFSMetadataService.Profile();
                p.fullName = pName;
                p.custom = false;
                p.objectPermissions = new List<GFSMetadataService.ProfileObjectPermissions>();
                GFSMetadataService.ProfileObjectPermissions objPerm = new GFSMetadataService.ProfileObjectPermissions();
                string objectName = '';
                if(objAPI.contains('__c')){
                    objectName = 'GFS_'+objAPI.split('__c')[0]+'_History__c'; 
                } else{ 
                    objectName = 'GFS_'+objAPI+'_History__c'; 
                } 
                system.debug('>>>>>>>>>>objectName:'+objectName);
                objPerm.object_x = objectName;
                objPerm.allowCreate = false;
                objPerm.allowDelete = false;
                objPerm.allowEdit = false;
                objPerm.allowRead = true;
                objPerm.modifyAllRecords = false;
                objPerm.viewAllRecords = false;
                p.objectPermissions.add(objPerm);
                
                p.fieldPermissions = new List<GFSMetadataService.ProfileFieldLevelSecurity>();
                GFSMetadataService.ProfileFieldLevelSecurity childFieldSec = new GFSMetadataService.ProfileFieldLevelSecurity();
                childFieldSec.field = objectName+'.Field__c';
                childFieldSec.readable = true; 
                childFieldSec.editable = false;
                p.fieldPermissions.add(childFieldSec); 
                GFSMetadataService.ProfileFieldLevelSecurity childFieldSec1 = new GFSMetadataService.ProfileFieldLevelSecurity();
                childFieldSec1.field = objectName+'.New_Value__c';
                childFieldSec1.readable = true; 
                childFieldSec1.editable = false;
                p.fieldPermissions.add(childFieldSec1);
                GFSMetadataService.ProfileFieldLevelSecurity childFieldSec2 = new GFSMetadataService.ProfileFieldLevelSecurity();
                childFieldSec2.field = objectName+'.Old_Value__c';
                childFieldSec2.readable = true; 
                childFieldSec2.editable = false;
                p.fieldPermissions.add(childFieldSec2);                
                profiles.add(p);                
            }
            
            if(!Test.isRunningTest())
                cresults = service.updateMetadata(profiles);
            else{
                cresults = new List<GFSMetadataService.SaveResult>();
                GFSMetadataService.SaveResult s = new GFSMetadataService.SaveResult();
                s.success = true;
                s.errors = null;
                cresults.add(s);
            }
            system.debug('>>>>>>>>>cresults :'+cresults);
            
            //Send an email to user
            String errorMsg = '';
            for(GFSMetadataService.SaveResult cres: cresults){
                if(!cres.success){
                    for(GFSMetadataService.Error error: cres.errors)
                        errorMsg += error.statusCode+': '+error.message+ '\n';                 
                }
            } 
            
            if(errorMsg == ''){
                system.debug('inside if update counter>>>>');
                //update custom settings count
                GFS_Email_Counter__c gfs = [Select Name,Counter__c from GFS_Email_Counter__c where Name = 'ProfileCount' for update];
                system.debug('inside if before update counter>>>>'+gfs);
                gfs.Counter__c = gfs.Counter__c - profNames.size();                
                update gfs;
                system.debug('inside if after update counter>>>>'+gfs);
            }
            
            GFS_Email_Counter__c gfs = GFS_Email_Counter__c.getValues('ProfileCount');
            if(gfs.Counter__c == 0){
                Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
                message.setToAddresses(new list<string>{email});
                if(errorMsg != ''){
                    message.setSubject('Field History Setup Failed to Complete');
                    message.setHtmlBody('Hi,<br/><br/> Field History Setup is failed with error.<br/>'+errorMsg+'<br/><br/> Thanks, <br/> Admin');                
                }else{                
                    message.setSubject('Field History Setup Completed');
                    message.setHtmlBody('Hi,<br/><br/> Field History Setup is Completed. <br/><br/> Thanks, <br/> Admin');
                }
                Messaging.sendEmail(new Messaging.SingleEmailMessage[] { message });                        
            }
        }
    
        @Future(callout=true)
        public static void createNewHistoryObject(string selectedObject,string objAPI,string baseURL1,string sessionId, list<string> profNames, string email){  
               
            GFSMetadataService.MetadataPort service = new GFSMetadataService.MetadataPort();   
            service.SessionHeader = new GFSMetadataService.SessionHeader_element();
            service.timeout_x = 120000;

            if(!Test.isRunningTest())
                service.SessionHeader.sessionId = sessionId;                               
            else
                service.SessionHeader.sessionId = '00Dp00000000pIU!AQwAQK63yIYv9A9RZqe2yv9iO5BfGpStu8MapHhNGN45P0JWl3uMe7bSnn5AzztDlF4NekQ7SB.FzFHR5GZOulVmlEfdUSmD';
            
            GFSMetadataService.CustomObject customObject = new GFSMetadataService.CustomObject();         
            if(objAPI.contains('__c')){
                list<string> pieces = objAPI.split('__');
                    if(pieces.size() > 2)
                        customObject.fullName = 'GFS_'+pieces[1]+'_History__c'; 
                    else
                        customObject.fullName = 'GFS_'+objAPI.split('__c')[0]+'_History__c'; 
            } else{ 
                customObject.fullName = 'GFS_'+objAPI+'_History__c'; 
            }
            
            customObject.label = 'GFS '+selectedObject+' History';  
            customObject.pluralLabel = 'GFS '+selectedObject+' History'; 
            customObject.nameField = new GFSMetadataService.CustomField(); 
            customObject.nameField.type_x = 'AutoNumber';  
            customobject.nameField.DisplayFormat='H-{00000000}';  
            customObject.nameField.label = 'Name'; 
            customObject.deploymentStatus = 'Deployed'; 
            customObject.sharingModel = 'Read';
            if(!Test.isRunningTest())
                GFSMetadataService.SaveResult[] results = service.createMetadata(new List<GFSMetadataService.Metadata> { customObject });
            
            system.debug('customObject.fullName '+customObject.fullName +' '+objAPI); 
            GFSMetadataService.CustomField customField = new GFSMetadataService.CustomField(); 
            customField.fullName = customObject.fullName+'.ParentId__c'; 
            customField.label = 'ParentId'; customField.type_x = 'Lookup'; 
            customField.relationshipLabel = customObject.label; 
            customField.relationshipName = customObject.fullName.split('__c')[0]; 
            customField.referenceTo = objAPI;             
            
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
            
            string triggerName = 'GFS'+selectedObject.deleteWhitespace()+'HistoryTrigger';   
            string triggerBody = 'trigger '+triggerName+' on '+objAPI+' (before update,after update) {if(trigger.isBefore){GFSSetFieldHistoryUpdate.preRequisite(trigger.oldMap,trigger.NewMap);}if(trigger.isAfter){GFSSetFieldHistoryUpdate.updateHistoryObject(trigger.oldMap,trigger.NewMap);}}';   String json = '{"Name" :\"'+ triggerName+'\", "TableEnumOrId" :\"'+ objAPI+'\", "Body" : \"'+triggerBody+'\"}';  

            Httprequest req1 = new HttpRequest(); 
            req1.setEndpoint(baseURL1+'/services/data/v32.0/sobjects/ApexTrigger'); 
            req1.setMethod('POST');   
            req1.setHeader('Content-Type', 'application/json'); 
            if(!Test.isRunningTest())
                req1.setHeader('Authorization', 'OAuth ' + sessionId); 
            else
                req1.setHeader('Authorization', 'OAuth 00Dp00000000pIU!AQwAQK63yIYv9A9RZqe2yv9iO5BfGpStu8MapHhNGN45P0JWl3uMe7bSnn5AzztDlF4NekQ7SB.FzFHR5GZOulVmlEfdUSmD');
            req1.setBody(json);

            Http httpReq1 = new Http();   
            if(!Test.isRunningTest()){ 
                HttpResponse res1 = httpReq1.send(req1);  
                system.debug('>>>>>>>>>>>res1:'+res1);
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
            if(!Test.isRunningTest())
                List<GFSMetadataService.SaveResult> results2 =  service.updateMetadata( new GFSMetadataService.Metadata[] { profile });       
            //update SFH record
            //list<Set_Field_History__c> SFH = [select Id,Name,FieldNameList__c,Profiles__c,Is_History_Object_Created__c from Set_Field_History__c where Id = :recordId];
            //GFSFieldHistoryProfileBatch b = new GFSFieldHistoryProfileBatch(objAPI,profNames,sessionId,email);
            //Database.executeBatch(b, 5);
       }
       */
    public static Boolean checkMetadataAPIConnection(){
        try {
            GFSMetadataService.MetadataPort service = new GFSMetadataService.MetadataPort();
            service.SessionHeader = new GFSMetadataService.SessionHeader_element();
            service.SessionHeader.sessionId = UserInfo.getSessionId();
            List<GFSMetadataService.ListMetadataQuery> queries = new List<GFSMetadataService.ListMetadataQuery>();        
            GFSMetadataService.ListMetadataQuery remoteSites = new GFSMetadataService.ListMetadataQuery();
            remoteSites.type_x = 'RemoteSiteSetting';
            queries.add(remoteSites);                   
            service.listMetadata(queries, 28);          
        } catch (Exception e) {
            system.debug('Exception:'+e);
            return false;
        }
        return true;
    } 
    
    public static list<string> retrievePageLayouts(string objectName){
        list<string> layouts = new list<string>();
        system.debug('>>>>>>>>>>>>>>objectName:'+objectName);
        objectName = objectName+'-';
        GFSMetadataService.MetadataPort service = new GFSMetadataService.MetadataPort();
        service.SessionHeader = new GFSMetadataService.SessionHeader_element();
        service.SessionHeader.sessionId = UserInfo.getSessionId();
        List<GFSMetadataService.ListMetadataQuery> queries = new List<GFSMetadataService.ListMetadataQuery>();        
        GFSMetadataService.ListMetadataQuery layoutSettings = new GFSMetadataService.ListMetadataQuery();
        layoutSettings.type_x = 'Layout';
        queries.add(layoutSettings); 
        if(!Test.isRunningTest()){
        GFSMetadataService.FileProperties[] fileProperties = service.listMetadata(queries, 25);
            for(GFSMetadataService.FileProperties fileProperty : fileProperties) {
                if(fileProperty.fullName.startsWith(objectName))
                    layouts.add(fileProperty.fullName);        
            }
            system.debug('>>>>>>>>>>>>>>layouts:'+layouts);        
        }                 
        return layouts;       
    }      
}