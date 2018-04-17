/*
    Company:     Cognizant Technology Solution
    Description: This Trigger will create ContentDistribution record for all the feed attachments whenever the Task is approved.
                 Change the access of STM Collaborator Group to 'Viewer' and grant Collaborator access to 'STM CE Group' once
                 the record moves forward after Assignee Approval.
    History:
        NJain    12/17/2014    Trigger Creation
        NJain    01/14/2015    Collabortor Access Modifications
*/
trigger STM_TRIGGER_Task on STMTask__c(Before Insert, After Update, Before Update) {
    
    if(System.Label.STM_TRIGGER_Task_Enable.equalsIgnoreCase('True')){
    
        if(Trigger.isBefore && Trigger.isInsert){
            for(STMTask__c stmTask: Trigger.New){
                stmTask.Status__c = 'Draft';
                stmTask.FTP_Initiated__c = false;
                stmTask.FTP_Done__c = false;
                stmTask.Approval_Stage__c = 'Initial';
            }
        }
        
        if(Trigger.isAfter && Trigger.isUpdate){
            
            List<String> lstTaskApproved = new List<String>();
            List<ContentDistribution> lstContentDist = new List<ContentDistribution>();
            for(STMTask__c stmTask: Trigger.New){
                if(stmTask.Status__c.equalsIgnoreCase('Approved') && !Trigger.oldMap.get(stmTask.Id).Status__c.equalsIgnoreCase('Approved')){
                    lstTaskApproved.add(stmTask.Id);
                }
            }
            
            for(FeedItem fi: [select id,RelatedRecordId,Title from FeedItem where Type ='ContentPost' and ParentId in: lstTaskApproved]){
                ContentDistribution cd = new ContentDistribution();
                cd.name = fi.Title;
                cd.ContentVersionId = fi.RelatedRecordId;
                cd.PreferencesAllowOriginalDownload = true;
                cd.PreferencesAllowPDFDownload = false;
                cd.PreferencesAllowViewInBrowser = true;
                lstContentDist.add(cd);
            }
            if(!lstContentDist.isEmpty()){
                Database.Insert(lstContentDist);
            }
        }
        
        if(Trigger.isBefore && Trigger.isUpdate){
            List<Id> lstTasksSTMCollaborator = new List<Id>();
            List<Id> lstTasksSTMCE = new List<Id>();
            
            for(STMTask__c stmTask: Trigger.New){
                if(stmTask.Status__c != 'Draft' && 
                    (Trigger.oldMap.get(stmTask.Id).Status__c == 'Draft' || Trigger.oldMap.get(stmTask.Id).Status__c == 'Rejected(Pending Originator/Assignee Action)')){
                    lstTasksSTMCollaborator.add(stmTask.Id);
                }
                if((stmTask.Status__c == 'Draft' || stmTask.Status__c == 'Rejected(Pending Originator/Assignee Action)') && Trigger.oldMap.get(stmTask.Id).Status__c != 'Draft'){
                    lstTasksSTMCE.add(stmTask.Id);
                }
            }
            
            if(!lstTasksSTMCollaborator.isEmpty()){
                List<Id> lstCDId = new List<Id>();
                for(ContentVersion CV : [SELECT Id,ContentDocumentId FROM ContentVersion 
                                            WHERE Id in (SELECT RelatedRecordId FROM FeedItem where ParentId in :lstTasksSTMCollaborator)]){
                    lstCDId.add(CV.ContentDocumentId);
                }
                
                List<ContentDocumentLink> lstCDLinkToUpdate = [SELECT Id from ContentDocumentLink 
                                                                WHERE LinkedEntityId = :System.Label.STM_COLLABORATOR_GROUPID AND
                                                                      ContentDocumentId IN :lstCDId];
                
                List<ContentDocumentLink> lstNewCDlinkForCE = new List<ContentDocumentLink>();
                for(Id contentDocId: lstCDId){
                    ContentDocumentLink c = new ContentDocumentLink ();
                    c.LinkedEntityId = System.Label.STM_CE_GROUPID;
                    c.ShareType = 'C';
                    c.ContentDocumentId = contentDocId;
                    lstNewCDlinkForCE.add(c);
                }
                insert lstNewCDlinkForCE;
                
                for(ContentDocumentLink cdl: lstCDLinkToUpdate){
                    cdl.ShareType='V';
                }
                update lstCDLinkToUpdate;
                
            }
            
            if(!lstTasksSTMCE.isEmpty()){
                List<Id> lstCDId = new List<Id>();
                for(ContentVersion CV : [SELECT Id,ContentDocumentId FROM ContentVersion 
                                            WHERE Id in (SELECT RelatedRecordId FROM FeedItem where ParentId in :lstTasksSTMCE)]){
                    lstCDId.add(CV.ContentDocumentId);
                }
                
                List<ContentDocumentLink> lstCDLinkToUpdate = [SELECT Id from ContentDocumentLink 
                                                                WHERE LinkedEntityId = :System.Label.STM_COLLABORATOR_GROUPID AND
                                                                      ContentDocumentId IN :lstCDId];
                for(ContentDocumentLink cdl: lstCDLinkToUpdate){
                    cdl.ShareType='C';
                }
                update lstCDLinkToUpdate;
                
                List<ContentDocumentLink> lstCDlinkForCEtoDelete = [SELECT Id from ContentDocumentLink 
                                                                        WHERE LinkedEntityId = :System.Label.STM_CE_GROUPID AND
                                                                              ContentDocumentId IN :lstCDId];
                delete lstCDlinkForCEtoDelete;
            }
        }
        
    }
}