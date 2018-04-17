trigger STM_TRIGGER_FeedItem on FeedItem(before insert, before update, before delete,
                                           after insert , after update , after delete , after undelete) {
    if(System.Label.STM_TRIGGER_FeedItem_Enable.equalsIgnoreCase('True')){
    
        //Before Insert or Before Update
        if(Trigger.IsBefore && (Trigger.isInsert || Trigger.isUpdate || Trigger.isDelete)){
            
            //get Object Id for STM Task object
            Schema.DescribeSObjectResult r = STMTask__c.sObjectType.getDescribe();
            String keyPrefix = r.getKeyPrefix();
            
            List<FeedItem> lstFeedItemToProcess = new List<FeedItem>();
            Set<String> setSTMIds = new Set<String>();
            
            if(Trigger.IsBefore && Trigger.isDelete){
                for(FeedItem a: Trigger.Old){
                    if(String.valueOf(a.ParentId).startsWith(keyPrefix) && a.Type.equalsIgnoreCase('ContentPost')){
                        lstFeedItemToProcess.add(a);
                        setSTMIds.add(a.ParentId);
                    }
                }    
            }else{ //Run this block for Before Insert/ Before Update
                for(FeedItem a: Trigger.new){
                    if(String.valueOf(a.ParentId).startsWith(keyPrefix) && a.Type.equalsIgnoreCase('ContentPost')){
                        lstFeedItemToProcess.add(a);
                        setSTMIds.add(a.ParentId);
                    }
                }
            }
            
            //++Executing this block only for FeedItems that are associated to STM Task records
            if(!lstFeedItemToProcess.isEmpty()){
                Map<String,String> mapFilePatterns = new Map<String,String>();
                
                Map<String,STMTask__c> mapSTMTasks = new Map<String,STMTask__c>([SELECT Id,ReportCategory__c,Status__c,Approval_Stage__c FROM STMTask__c where id in: setSTMIds]);
                
                LIst<STM_FilePattern__c > lstFilePatt = [SELECT id, Name, ReportProjectProfile__c, Destination_Folder__c 
                                                         FROM STM_FilePattern__c
                                                         WHERE ReportProjectProfile__c in (SELECT Report_Project_Profile__c 
                                                                                           FROM STMTask__c WHERE id in: setSTMIds)];
                
                for(STM_FilePattern__c fPat: lstFilePatt ){
                    mapFilePatterns.put(fPat.Name.toUpperCase(),fPat.Destination_Folder__c);
                }

                if(Trigger.IsBefore && Trigger.isDelete){
                    for(FeedItem att: lstFeedItemToProcess){
                        if(mapSTMTasks.get(att.ParentId) != NULL 
                           && mapSTMTasks.get(att.ParentId).Status__c != 'Submitted' 
                           && mapSTMTasks.get(att.ParentId).Status__c != 'Approved'){
                        }else{
                            att.addError('You cannot delete any file if the Task is Under-Approval/ Approved.');
                        }
                   }
                }else{ //Run this block for Before Insert/ Before Update
                    for(FeedItem att: lstFeedItemToProcess){
                        system.debug('####Status####'+mapSTMTasks.get(att.ParentId).Status__c+'#####'+mapSTMTasks.get(att.ParentId).ReportCategory__c);
                        if(mapSTMTasks.get(att.ParentId) != NULL && (
                               (mapSTMTasks.get(att.ParentId).Status__c != 'Submitted' && 
                                mapSTMTasks.get(att.ParentId).Status__c != 'Approved'
                               ) 
                               ||
                               (mapSTMTasks.get(att.ParentId).Status__c.equalsIgnoreCase('Submitted') &&
                                mapSTMTasks.get(att.ParentId).Approval_Stage__c.equalsIgnoreCase('Assignee')
                               )
                           )
                        ){
                            if(mapSTMTasks.get(att.ParentId).ReportCategory__c != 'CAR Investigation Rpt'){
                                boolean taskMatchFound = false;
                                string tempMatch='';
                                for(String filePattern: mapFilePatterns.keySet()){
                                    system.debug('####File Pattern####'+filePattern);
                                    Pattern profilePattern  = Pattern.Compile(filePattern.replace('(','\\(').replace(')','\\)').replace('$','\\$').toUpperCase());
                                    Matcher m1= profilePattern.matcher(att.Title.toUpperCase());
                                    system.debug('###att.Title: '+att.Title);
                                    
                                    while (m1.find()){
                                        if(m1.group(0) != NULL && m1.group(0) != ''){
                                            
                                            if(tempMatch.length() < m1.group(0).length()){
                                                tempMatch = m1.group(0);
                                                taskMatchFound = True;
                                            }
                                            break;
                                        }
                                    }
                                }
                                if(taskMatchFound){
                                    att.Body = mapFilePatterns.get(tempMatch);
                                }else{
                                    string errorMsg = 'Incorrect file name format. Attach the file in one of the following formats:\n';
                                    integer i=1;
                                    for(String filePattern: mapFilePatterns.keySet()){
                                        errorMsg += i + '. ' + filePattern + '\n';
                                        i++;
                                    }
                                    att.addError(errorMsg);
                                }
                            }else{
                                //do nothing for CAR reports(allow any format).
                            }
                        }else{
                            att.addError('You cannot attach any file if the Task is Under-Approval/ Approved.');
                        }
                    }
                }
            }
            //--Executing this block only for attachmnets that are associated to STM Task records
        }
        
        //After Insert and After Delete
        if(Trigger.IsAfter && (Trigger.isInsert || Trigger.isDelete)){
            List<FeedItem> lstFeedItemToProcess = new List<FeedItem>();
            List<String> lstContentIdToDelete = new List<String>();
            Set<String> setSTMIds = new Set<String>();
            
            //get Object Id for STM Task object
            Schema.DescribeSObjectResult r = STMTask__c.sObjectType.getDescribe();
            String keyPrefix = r.getKeyPrefix();
            
            List<String> lstContentVersionIds = new List<String>();
            if(Trigger.isInsert){
                for(FeedItem a: Trigger.new){
                    if(String.valueOf(a.ParentId).startsWith(keyPrefix) && a.Type.equalsIgnoreCase('ContentPost')){
                        lstFeedItemToProcess.add(a);
                        setSTMIds.add(a.ParentId);
                        lstContentVersionIds.add(a.RelatedRecordId);
                    }
                }
            }
            if(Trigger.isDelete){
                for(FeedItem a: Trigger.old){
                    if(String.valueOf(a.ParentId).startsWith(keyPrefix) && a.Type.equalsIgnoreCase('ContentPost')){
                        lstFeedItemToProcess.add(a);
                        lstContentIdToDelete.add(a.RelatedRecordId);
                        setSTMIds.add(a.ParentId);
                    }
                }
                system.debug('#####1######'+lstContentIdToDelete);
            }
            
            //++Executing this block only for attachments that are associated to STM Task records
            if(!lstFeedItemToProcess.isEmpty()){
                Map<String,Integer> mapSTMtaskCount = new Map<String,Integer>();
                for(FeedItem feedContent : [select id,ParentId,RelatedRecordId from FeedItem where ParentId in :setSTMIds and Type = 'ContentPost']){
                    if(mapSTMtaskCount.get(feedContent.ParentId) == NULL){
                        mapSTMtaskCount.put(feedContent.ParentId,0);
                    }
                    mapSTMtaskCount.put(feedContent.ParentId,mapSTMtaskCount.get(feedContent.ParentId)+1);
                }
                
                List<STMTask__c> lstSTMtaskToUpdate = new List<STMTask__c>();
                for(String stmTask: setSTMIds){
                    STMTask__c stmTaskRec = new STMTask__c(id=stmTask);
                    stmTaskRec.Count_of_Attachments__c =0; //Initialize count to Zero(0).
                    if(mapSTMtaskCount.get(stmTask) != NULL){
                        stmTaskRec.Count_of_Attachments__c = mapSTMtaskCount.get(stmTask);
                    }
                    lstSTMtaskToUpdate.add(stmTaskRec);
                }
                update lstSTMtaskToUpdate;
                
                //Providing access to the STM Collaborator Group for the content Documents added on the Feed.
                if(Trigger.isInsert && Trigger.isAfter){
                    List<ContentDocumentLink> lstNewContentDocLink = new List<ContentDocumentLink>();
                    for(ContentVersion cv: [select id,ContentDocumentId from ContentVersion where id in :lstContentVersionIds]){
                        ContentDocumentLink cdl = new ContentDocumentLink();
                        cdl.ContentDocumentId = cv.ContentDocumentId;
                        cdl.LinkedEntityId = System.Label.STM_COLLABORATOR_GROUPID; //Chatter Collaborator Group ID: STM Collaborator Group
                        cdl.ShareType = 'C';
                        lstNewContentDocLink.add(cdl);
                    }
                    insert lstNewContentDocLink;    
                }
                
            }        
            //--Executing this block only for attachments that are associated to STM Task records
            
            //Executing this block for Deleting the attachments(Content Document) if the Feed is deleted from STM record.
            if(Trigger.isDelete){
                List<String> lstContentVersionToDelete = new List<String>();
                system.debug('#####2######'+lstContentIdToDelete);
                for(ContentVersion conVer: [select id,ContentDocumentId from ContentVersion where id in :lstContentIdToDelete]){
                    lstContentVersionToDelete.add(conVer.ContentDocumentId);
                }
                Database.Delete([select id from ContentDocument where id in :lstContentVersionToDelete and OwnerId =:UserInfo.getUserId()]);
            }
        }
    }
}