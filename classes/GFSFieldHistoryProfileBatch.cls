global with sharing class GFSFieldHistoryProfileBatch implements Database.Batchable<sObject>, Database.Stateful,  Database.AllowsCallouts {
    string objectAPI;
    string sessionId;
    string emailId;  
    string recordId;
    list<string> profileIds;
    list<GFSMetadataService.SaveResult> finalResult;
    map<string, string> profileErrorMap = new map<string, string>();
    public GFSFieldHistoryProfileBatch(string objAPI, string sId, string email, string rId){
        objectAPI = objAPI;
        sessionId = sId;
        emailId = email;
        recordId = rId;
        /*profileIds = new list<string>();
        list<Set_Field_History__c> sfhs = [Select Id,Name,FieldNameList__c,Profiles__c from Set_Field_History__c where Id = :recordId];
        if(sfhs.size() > 0){
            if(sfhs[0].Profiles__c.contains('#')){
                profileIds = sfhs[0].Profiles__c.split('#');                     
            }else{
                profileIds.add(sfhs[0].Profiles__c);
            }
        }*/
    }

    global Database.QueryLocator start(Database.BatchableContext BC) {        
        //string query = 'Select Id, Name from Profile where Id in :profileIds';        
        string query = 'SELECT Id, Profile.Name, Profile.UserType FROM PermissionSet WHERE IsOwnedByProfile = true AND IsCustom = true';
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext ctx, List<Sobject> scope) {
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
            for(PermissionSet ps: (list<PermissionSet>)scope){
                if(ps.Profile.UserType != 'Guest'){
                    //system.debug('>>>>>>>>>ps.Profile.Name:'+ps.Profile.Name);   
                    string pname = ps.Profile.Name;
                    if(ps.Profile.Name == 'Solution Manager')
                        pname = 'SolutionManager';
                    else if(ps.Profile.Name == 'Contract Manager')
                        pname = 'ContractManager';
                    else if(ps.Profile.Name == 'System Administrator')
                        pname = 'Admin';
                    else if(ps.Profile.Name == 'Read Only')
                        pname = 'ReadOnly';
                    else if(ps.Profile.Name == 'Standard Platform User')
                        pname = 'StandardAul';
                    else if(ps.Profile.Name == 'Standard User')
                        pname = 'Standard';
                    else if(ps.Profile.Name == 'High Volume Customer Portal')
                        pname = 'HighVolumePortal';
                    else if(ps.Profile.Name == 'Marketing User')
                        pname = 'MarketingProfile';  
                                                         
                    GFSMetadataService.Profile p = new GFSMetadataService.Profile();
                    p.fullName = pname;                                                      
                    p.custom = false;
                    p.objectPermissions = new List<GFSMetadataService.ProfileObjectPermissions>();
                    GFSMetadataService.ProfileObjectPermissions objPerm = new GFSMetadataService.ProfileObjectPermissions();
                    string objectName = '';
                    if(objectAPI.contains('__c')){
                        objectName = 'GFS_'+objectAPI.split('__c')[0]+'_History__c'; 
                    } else{ 
                        objectName = 'GFS_'+objectAPI+'_History__c'; 
                    } 
                    //system.debug('>>>>>>>>>>objectName:'+objectName);
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
            }        
            
            if(!Test.isRunningTest()){
                cresults = service.updateMetadata(profiles);
                for(GFSMetadataService.SaveResult res: cresults){
                    //system.debug('>>>>>>>>>>>res:'+res.success);
                    if(res.errors != null)
                        for(GFSMetadataService.Error e: res.errors){
                            profileErrorMap.put(res.fullName,e.message);
                            //system.debug('>>>>>>>>>>>res:'+e.message);
                        }
                } 
                
                //system.debug('>>>>>>>>>profileErrorMap:'+profileErrorMap);   
            }else{
                cresults = new List<GFSMetadataService.SaveResult>();
                GFSMetadataService.SaveResult s = new GFSMetadataService.SaveResult();
                s.success = true;
                s.errors = null;
                cresults.add(s);
            }                    
    }
    
    global void finish(Database.BatchableContext BC){
        try{
        //call Layout Batch
        GFSFieldHistoryLayoutBatch b = new GFSFieldHistoryLayoutBatch(objectAPI,sessionId,emailId,recordId,profileErrorMap);
        Database.executeBatch(b,1);   
        
        //Send an email to user                
        /*    String errorMsg = '';
            for(GFSMetadataService.SaveResult cres: finalResult){
                if(!cres.success){
                    for(GFSMetadataService.Error error: cres.errors)
                        errorMsg += error.statusCode+': '+error.message+ '\n';                 
                }
            } 
            Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
            message.setToAddresses(new list<string>{emailId});
            if(errorMsg != ''){
                message.setSubject('Field History Setup Failed to Complete');
                message.setHtmlBody('Hi,<br/><br/> Field History Setup is failed with error.<br/>'+errorMsg+'<br/><br/> Thanks, <br/> Admin');                
            }else{                
                message.setSubject('Field History Setup Completed');
                message.setHtmlBody('Hi,<br/><br/> Field History Setup is Completed. <br/><br/> Thanks, <br/> Admin');
            }
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { message });  */
        }catch(Exception ex){
            system.debug('Exception occur:'+ex);
        }                        
    }
}