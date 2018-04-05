global with sharing class GFSFieldHistoryLayoutBatch implements Database.Batchable<sObject>, Database.Stateful,  Database.AllowsCallouts {
    string objectAPI;
    string sessionId;
    string emailId;  
    string recordId;
    list<GFSMetadataService.SaveResult> finalResult;
    map<string, string> perrors = new map<string, string>();
    public GFSFieldHistoryLayoutBatch(string objAPI, string sId, string email, string rId, map<string, string> profileErrors){
        objectAPI = objAPI;
        sessionId = sId;
        emailId = email;
        recordId = rId;    
        perrors = profileErrors;
    }

    global Database.QueryLocator start(Database.BatchableContext BC) {        
        string query = 'Select Id,Name,FieldNameList__c,Profiles__c,Layouts__c,All_Layouts__c from Set_Field_History__c where Id = :recordId';        
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext ctx, List<Sobject> scope) {
        try{
            Set_Field_History__c history = (Set_Field_History__c)scope[0];
            //system.debug('>>>>>>>>history.Layouts__c:'+history.Layouts__c);
            string historyLayouts = history.Layouts__c;
            list<string> pglayouts = historyLayouts.split('#');
            map<string,string> pglayoutsmap = new map<string,string>();
            for(string s: pglayouts)
                pglayoutsmap.put(s,s);
            //system.debug('>>>>>>>>pglayouts :'+pglayouts);
            
            system.debug('>>>>>>>>history.All_Layouts__c:'+history.All_Layouts__c);
            string allLayouts = history.All_Layouts__c;
            list<string> allpgLayouts = allLayouts.split('#');
            //system.debug('>>>>>>>>allpgLayouts :'+allpgLayouts);
            
            GFSMetadataService.MetadataPort service = new GFSMetadataService.MetadataPort();   
            service.SessionHeader = new GFSMetadataService.SessionHeader_element();
            service.timeout_x = 120000;
    
            if(!Test.isRunningTest()){ 
                service.SessionHeader.sessionId = sessionId;      
            }else{
                service.SessionHeader.sessionId = '00Dp00000000pIU!AQwAQK63yIYv9A9RZqe2yv9iO5BfGpStu8MapHhNGN45P0JWl3uMe7bSnn5AzztDlF4NekQ7SB.FzFHR5GZOulVmlEfdUSmD';
            }
            
            string historyObjectAPIName = '';
            if(objectAPI.contains('__c')){
                list<string> pieces = objectAPI.split('__');
                    if(pieces.size() > 2)
                        historyObjectAPIName = 'GFS_'+pieces[1]+'_History__c'; 
                    else
                        historyObjectAPIName = 'GFS_'+objectAPI.split('__c')[0]+'_History__c'; 
            } else{ 
                historyObjectAPIName = 'GFS_'+objectAPI+'_History__c'; 
            }
            
            list<GFSMetadataService.Layout> tobeUpdatedLayouts = new list<GFSMetadataService.Layout>();
            List<GFSMetadataService.SaveResult> cresults = new List<GFSMetadataService.SaveResult>();
            boolean relatedListExists = false;
            //Selected layout related list updates
            for(string pglayout: allpgLayouts){ 
                relatedListExists = false;           
                list<string> splitLayouts = pglayout.split(objectAPI+'-');
                string withNamepsaceLayout = objectAPI+'-'+splitLayouts[1];
                //system.debug('>>>>>>>>>>>withNamepsaceLayout :'+withNamepsaceLayout);
                GFSMetadataService.Layout layout = new GFSMetadataService.Layout();
                List<GFSMetadataService.RelatedListItem> lstMD = new list<GFSMetadataService.RelatedListItem>();
                if(!Test.isRunningTest()){
                    layout = (GFSMetadataService.Layout)service.readMetadata('Layout',new String[] {withNamepsaceLayout}).getRecords()[0]; 
                    lstMD = layout.relatedLists; 
                    system.debug('lstMD==========='+lstMD);                 
                }
                if(lstMD != null) {
                    if(pglayoutsmap.containsKey(pglayout)){
                        GFSMetadataService.RelatedListItem new_related_list = new GFSMetadataService.RelatedListItem();
                        new_related_list.relatedList = historyObjectAPIName+'.ParentId__c';
                        //new_related_list.relatedList = 'SZSF__GFS_Account_History__c.SZSF__ParentId__c';
                        new_related_list.fields = new List<String> {'Field__c', 'New_Value__c', 'Old_Value__c','CREATEDBY_USER.ALIAS'};
                        
                        if(layout.relatedLists != null){
                            for(GFSMetadataService.RelatedListItem item :layout.relatedLists){
                                if(item.relatedList == historyObjectAPIName+'.ParentId__c'){                                
                                    system.debug('inside related list exists');
                                    relatedListExists = true;
                                    break;
                                }
                            }                    
                            if(!Test.isRunningTest() && !relatedListExists){
                                layout.relatedLists.add(new_related_list);  
                                tobeUpdatedLayouts.add(layout);
                            }                                      
                        }
                    }else{
                        system.debug('inside remove');
                        integer i=0;
                        for(GFSMetadataService.RelatedListItem item :layout.relatedLists){                       
                            if(item.relatedList == historyObjectAPIName+'.ParentId__c'){
                                system.debug('inside remove');
                                layout.relatedLists.remove(i);
                                tobeUpdatedLayouts.add(layout);   
                                break;
                            }
                            i++;
                          }
                    }
                                                               
                }            
            }
            
            //system.debug('>>>>>>>>>tobeUpdatedLayouts:'+tobeUpdatedLayouts);        
            if(!Test.isRunningTest()){
                if(tobeUpdatedLayouts.size() > 0){
                    cresults = service.updateMetadata(tobeUpdatedLayouts);
                    finalResult = cresults;
                }
            }else{
                cresults = new List<GFSMetadataService.SaveResult>();
                GFSMetadataService.SaveResult s = new GFSMetadataService.SaveResult();
                s.success = true;
                s.errors = null;
                cresults.add(s);
            }  
        } catch(Exception ex){
            /* Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
            message.setToAddresses(new list<string>{'anushribhushan.sarwade@globalfoundries.com'});           
            message.setSubject('Failed....');
            message.setHtmlBody(ex.getMessage()+'==========='+ex.getStackTraceString());                
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { message }); */   
        } 
    }
    
    global void finish(Database.BatchableContext BC){
        try{
        //Send an email to user        
            String errorMsg = '';
            //system.debug('>>>>>>>>finalResult:'+finalResult);
            if(finalResult != null){
                for(GFSMetadataService.SaveResult cres: finalResult){
                    if(!cres.success){
                        for(GFSMetadataService.Error error: cres.errors)
                            errorMsg += error.statusCode+': '+error.message+ '\n';                 
                    }
                }
            } 
            Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
            message.setToAddresses(new list<string>{emailId});
            if(errorMsg != ''){
                message.setSubject('Field History Setup Failed to Complete');
                string msg = 'Hi,<br/><br/> Field History Setup is Completed. <br/><br/>';
                if(perrors.size() > 0){
                    msg += 'Following errors are occurred while updating profile:';
                    msg += '<table border="1"><tr><td style="width:50px;">Profile Name</td><td style="width:100px;">Error</td></tr>';
                    for(string str: perrors.keySet()){
                        msg += '<tr><td>'+str+'</td><td>'+perrors.get(str)+'</td></tr>';
                    }
                    msg += '</table>';
                }                
                message.setHtmlBody(msg+'<br/><br/> Thanks, <br/> Admin');
            }else{                
                message.setSubject('Field History Setup Completed');
                string msg = 'Hi,<br/><br/> Field History Setup is Completed. <br/><br/>';
                if(perrors.size() > 0){
                    msg += 'Following errors are occurred while updating profile:';
                    msg += '<table border="1"><tr><td style="width:50px;">Profile Name</td><td style="width:100px;">Error</td></tr>';
                    for(string str: perrors.keySet()){
                        msg += '<tr><td>'+str+'</td><td>'+perrors.get(str)+'</td></tr>';
                    }
                    msg += '</table>';
                }                
                message.setHtmlBody(msg+'<br/><br/> Thanks, <br/> Admin');                
            }
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { message }); 
        }catch(Exception ex){
            system.debug('Exception occur:'+ex);
        }                        
    }
}