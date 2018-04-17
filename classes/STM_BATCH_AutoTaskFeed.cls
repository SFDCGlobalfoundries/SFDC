/*
    Company:        Cognizant Technology Solution
    Description:    This batch class will create a Task automatically if any file is found in the 'STM AutoTask' library.
    History:
        NJain    11/06/2014    Class Creation
        
*/

public class STM_BATCH_AutoTaskFeed implements Database.Batchable<sObject>,Database.Stateful{
    
    public List<ContentVersion> lstDocNotProcessed;
    
    public STM_BATCH_AutoTaskFeed(){
        lstDocNotProcessed = new List<ContentVersion>();
    }
    
    public Database.QueryLocator start(Database.BatchableContext BC) {
        return Database.getQueryLocator('SELECT id,VersionData,Description,Title,PathOnClient,FirstPublishLocationId  '+
                                        ' FROM ContentVersion WHERE FirstPublishLocationId = \''+ System.Label.STM_AUTOTASK_LIBRARYID+ '\''); 
    }
    
    public void execute(Database.BatchableContext BC, List<ContentVersion> lstDocument){
        if(lstDocument!= null && !lstDocument.isEmpty()){
            
            List<String> lstPatterns = new List<String>();
            List<STMTask__c> lstNewSTMTasks = new List<STMTask__c>();
            Map<String,ContentVersion>  MapNameDocument = new Map<String,ContentVersion>();
            Map<String,String>    MapDocProfile   = new Map<String,String>(); 
            Map<String,STMTaskChild__c> MapTask   = new Map<String,STMTaskChild__c>();
            Map<String,ReportProjectProfileChild__c>  MapNameProfile = new Map<String,ReportProjectProfileChild__c>();
            List<Id> lstCVId = new List<Id>();
            
            //Getting the File name patterns for which the task needs to be created
            for(STM_FilePattern__c fPatt: [SELECT id, Name, Destination_Folder__c FROM STM_FilePattern__c]){
                lstPatterns.add(fPatt.Name.toUpperCase());
            }
            
            //preparing the docs to process as per the pattern and docs which will not be processed
            for(ContentVersion doc: lstDocument){
                string tempMatch='';
                boolean taskMatchFound = false;
                for(String str: lstPatterns){
                    Pattern profilePattern  = Pattern.Compile(str.replace('(','\\(').replace(')','\\)').replace('$','\\$').toUpperCase());
                    Matcher m1= profilePattern.matcher(doc.Title.toUpperCase());
                    
                    while (m1.find()){
                        if(m1.group(0) != NULL && m1.group(0) != ''){
                            system.debug('####True'+m1.group(0));
                            if(tempMatch.length() < m1.group(0).length()){
                                tempMatch = m1.group(0);
                                taskMatchFound = True;
                            }
                            break;
                        }
                    }
                }
                if(taskMatchFound){
                    MapDocProfile.put(doc.Title.toUpperCase(),tempMatch);
                    MapNameDocument.put(doc.Title.toUpperCase(),doc);
                    lstCVId.add(doc.Id);
                }else{
                    system.debug('####False####: No STM File Pattern Match Found for Document:' + doc.Title);
                    lstDocNotProcessed.add(doc);
                }
            }
            
            //Querying all the fields of the matching profile record.
            List<ReportProjectProfileChild__c> lstReportProfile = [SELECT id,Alert_Reminder_User1__c,Alert_Reminder_User2__c,
                                                                    Alert_Reminder_User3__c,Assignee_Esc_1__c,Assignee_Esc_2__c,Assignee_Esc_3__c,Assignee_Esc_4__c,Assignee_Esc_5__c,
                                                                    CE_Esc_1__c,CE_Esc_2__c,CE_Esc_3__c,CE_Esc_4__c,CE_Esc_5__c,QA_Esc_1__c,QA_Esc_2__c,QA_Esc_3__c,QA_Esc_4__c,QA_Esc_5__c,
                                                                    ReportProjectProfile__c,Supervisor_Esc_1__c,Supervisor_Esc_2__c,Supervisor_Esc_3__c,Supervisor_Esc_4__c,Supervisor_Esc_5__c,
                                                                    
                                                                    ReportProjectProfile__r.Report_File_Name__c,
                                                                    ReportProjectProfile__r.AutoCopy__c,ReportProjectProfile__r.Frequency__c,ReportProjectProfile__r.FTPEnabled__c,
                                                                    ReportProjectProfile__r.Report_Category__c,ReportProjectProfile__r.Name,ReportProjectProfile__r.Assignee_1__c,ReportProjectProfile__r.Assignee_2__c,
                                                                    ReportProjectProfile__r.Assignee_3__c,ReportProjectProfile__r.Assignee_4__c,ReportProjectProfile__r.Assignee_5__c,
                                                                    ReportProjectProfile__r.Assignee_6__c,ReportProjectProfile__r.Assignee_7__c,ReportProjectProfile__r.Assignee_8__c,
                                                                    ReportProjectProfile__r.Assignee_9__c,ReportProjectProfile__r.Assignee_10__c,
                                                                    ReportProjectProfile__r.Source_System_Owner_1__c,ReportProjectProfile__r.Source_System_Owner_2__c,
                                                                    ReportProjectProfile__r.Source_System_Owner_3__c,ReportProjectProfile__r.Source_System_Owner_4__c,ReportProjectProfile__r.Source_System_Owner_5__c,
                                                                    ReportProjectProfile__r.Supervisor_1__c,ReportProjectProfile__r.Supervisor_2__c,ReportProjectProfile__r.Supervisor_3__c,
                                                                    ReportProjectProfile__r.Supervisor_4__c,ReportProjectProfile__r.Supervisor_5__c,ReportProjectProfile__r.QA_1__c,
                                                                    ReportProjectProfile__r.QA_2__c,ReportProjectProfile__r.QA_3__c,ReportProjectProfile__r.QA_4__c,ReportProjectProfile__r.QA_5__c,
                                                                    ReportProjectProfile__r.CE_1__c,ReportProjectProfile__r.CE_2__c,ReportProjectProfile__r.CE_3__c,ReportProjectProfile__r.CE_4__c,
                                                                    ReportProjectProfile__r.CE_5__c,ReportProjectProfile__r.SendToAssignee__c,ReportProjectProfile__r.SendToQA__c,
                                                                    ReportProjectProfile__r.SendToSupervisor__c,ReportProjectProfile__r.Days_for_Report_Upload__c,
                                                                    ReportProjectProfile__r.Days_for_Assignee_Escalation__c,ReportProjectProfile__r.Days_for_Supervisor_Escalation__c,
                                                                    ReportProjectProfile__r.Days_for_QA_Escalation__c,ReportProjectProfile__r.Days_for_CE_Escalation__c,
                                                                    ReportProjectProfile__r.Escalation_for_Assignee__c,ReportProjectProfile__r.Escalation_for_Supervisor__c,
                                                                    ReportProjectProfile__r.Escalation_for_QA__c,ReportProjectProfile__r.Escalation_for_CE__c,ReportProjectProfile__r.Account__c
                                                                    FROM ReportProjectProfileChild__c 
                                                                    WHERE ReportProjectProfile__r.Report_File_Name__c in :mapDocProfile.values()];
            
            for(ReportProjectProfileChild__c profileRec: lstReportProfile){
                MapNameProfile.put(profileRec.ReportProjectProfile__r.Report_File_Name__c.toUpperCase(),profileRec);
            }            
            
            for(ContentVersion doc: MapNameDocument.values()){
                ReportProjectProfileChild__c reportChild = MapNameProfile.get(mapDocProfile.get(doc.Title.toUpperCase()));
                STMTask__c stmTask = new STMTask__c();
                STMTaskChild__c stmTaskChild = new STMTaskChild__c();
                
                stmTask.Name = doc.Title;
                stmTask.Source_System_Owner_1__c = reportChild.ReportProjectProfile__r.Source_System_Owner_1__c;
                stmTask.Source_System_Owner_2__c = reportChild.ReportProjectProfile__r.Source_System_Owner_2__c;
                stmTask.Source_System_Owner_3__c = reportChild.ReportProjectProfile__r.Source_System_Owner_3__c;
                stmTask.Source_System_Owner_4__c = reportChild.ReportProjectProfile__r.Source_System_Owner_4__c;
                stmTask.Source_System_Owner_5__c = reportChild.ReportProjectProfile__r.Source_System_Owner_5__c;
                stmTask.Assignee_1__c = reportChild.ReportProjectProfile__r.Assignee_1__c;
                stmTask.Assignee_2__c = reportChild.ReportProjectProfile__r.Assignee_2__c;
                stmTask.Assignee_3__c = reportChild.ReportProjectProfile__r.Assignee_3__c;
                stmTask.Assignee_4__c = reportChild.ReportProjectProfile__r.Assignee_4__c;
                stmTask.Assignee_5__c = reportChild.ReportProjectProfile__r.Assignee_5__c;
                stmTask.Assignee_6__c = reportChild.ReportProjectProfile__r.Assignee_6__c;
                stmTask.Assignee_7__c = reportChild.ReportProjectProfile__r.Assignee_7__c;
                stmTask.Assignee_8__c = reportChild.ReportProjectProfile__r.Assignee_8__c;
                stmTask.Assignee_9__c = reportChild.ReportProjectProfile__r.Assignee_9__c;
                stmTask.Assignee_10__c = reportChild.ReportProjectProfile__r.Assignee_10__c;
                stmTask.Supervisor_1__c = reportChild.ReportProjectProfile__r.Supervisor_1__c;
                stmTask.Supervisor_2__c = reportChild.ReportProjectProfile__r.Supervisor_2__c;
                stmTask.Supervisor_3__c = reportChild.ReportProjectProfile__r.Supervisor_3__c;
                stmTask.Supervisor_4__c = reportChild.ReportProjectProfile__r.Supervisor_4__c;
                stmTask.Supervisor_5__c = reportChild.ReportProjectProfile__r.Supervisor_5__c;
                stmTask.QA_1__c = reportChild.ReportProjectProfile__r.QA_1__c;
                stmTask.QA_2__c = reportChild.ReportProjectProfile__r.QA_2__c;
                stmTask.QA_3__c = reportChild.ReportProjectProfile__r.QA_3__c;
                stmTask.QA_4__c = reportChild.ReportProjectProfile__r.QA_4__c;
                stmTask.QA_5__c = reportChild.ReportProjectProfile__r.QA_5__c;
                stmTask.CE_1__c = reportChild.ReportProjectProfile__r.CE_1__c;
                stmTask.CE_2__c = reportChild.ReportProjectProfile__r.CE_2__c;
                stmTask.CE_3__c = reportChild.ReportProjectProfile__r.CE_3__c;
                stmTask.CE_4__c = reportChild.ReportProjectProfile__r.CE_4__c;
                stmTask.CE_5__c = reportChild.ReportProjectProfile__r.CE_5__c;
                
                stmTask.Account__c   = reportChild.ReportProjectProfile__r.Account__c;
                stmTask.Frequency__c = reportChild.ReportProjectProfile__r.Frequency__c;
                stmTask.Days_for_Report_Upload__c = reportChild.ReportProjectProfile__r.Days_for_Report_Upload__c;
                stmTask.Days_for_Assignee_Escalation__c = reportChild.ReportProjectProfile__r.Days_for_Assignee_Escalation__c;
                stmTask.Days_for_Supervisor_Escalation__c = reportChild.ReportProjectProfile__r.Days_for_Supervisor_Escalation__c;
                stmTask.Days_for_QA_Escalation__c = reportChild.ReportProjectProfile__r.Days_for_QA_Escalation__c;
                stmTask.Days_for_CE_Escalation__c = reportChild.ReportProjectProfile__r.Days_for_CE_Escalation__c;
                stmTask.Escalation_for_Assignee__c = reportChild.ReportProjectProfile__r.Escalation_for_Assignee__c;
                stmTask.Escalation_for_Supervisor__c = reportChild.ReportProjectProfile__r.Escalation_for_Supervisor__c;
                stmTask.Escalation_for_QA__c = reportChild.ReportProjectProfile__r.Escalation_for_QA__c;
                stmTask.Escalation_for_CE__c = reportChild.ReportProjectProfile__r.Escalation_for_CE__c;
                stmTask.ReportCategory__c = reportChild.ReportProjectProfile__r.Report_Category__c;
                stmTask.Report_Project_Profile__c = reportChild.ReportProjectProfile__c;
                stmTask.SendToAssignee__c = reportChild.ReportProjectProfile__r.SendToAssignee__c;
                stmTask.SendToQA__c = reportChild.ReportProjectProfile__r.SendToQA__c;
                stmTask.SendToSupervisor__c = reportChild.ReportProjectProfile__r.SendToSupervisor__c;
                
                //Updating the Report Due-Date
                if(stmTask.Frequency__c.equalsIgnoreCase('Weekly')){
                   stmTask.Report_Due_Date__c =  System.TODAY().addDays(7);
                }
                else if(stmTask.Frequency__c.equalsIgnoreCase('Monthly')){
                   stmTask.Report_Due_Date__c =  System.TODAY().addMonths(1);
                }
                else if(stmTask.Frequency__c.equalsIgnoreCase('Quarterly')){
                   stmTask.Report_Due_Date__c =  System.TODAY().addMonths(3);
                }
                else if(stmTask.Frequency__c.equalsIgnoreCase('Semi-Annually')){
                   stmTask.Report_Due_Date__c =  System.TODAY().addMonths(6);
                }
                else if(stmTask.Frequency__c.equalsIgnoreCase('Yearly')){
                   stmTask.Report_Due_Date__c =  System.TODAY().addMonths(12);
                }else{
                    stmTask.Report_Due_Date__c = NULL;
                }
                
                lstNewSTMTasks.add(stmTask);
                
                stmTaskChild.Alert_Reminder_User1__c = reportChild.Alert_Reminder_User1__c;
                stmTaskChild.Alert_Reminder_User2__c = reportChild.Alert_Reminder_User2__c;
                stmTaskChild.Alert_Reminder_User3__c = reportChild.Alert_Reminder_User3__c;
                stmTaskChild.Assignee_Esc_1__c = reportChild.Assignee_Esc_1__c;
                stmTaskChild.Assignee_Esc_2__c = reportChild.Assignee_Esc_2__c;
                stmTaskChild.Assignee_Esc_3__c = reportChild.Assignee_Esc_3__c;
                stmTaskChild.Assignee_Esc_4__c = reportChild.Assignee_Esc_4__c;
                stmTaskChild.Assignee_Esc_5__c = reportChild.Assignee_Esc_5__c;
                stmTaskChild.Supervisor_Esc_1__c = reportChild.Supervisor_Esc_1__c;
                stmTaskChild.Supervisor_Esc_2__c = reportChild.Supervisor_Esc_2__c;
                stmTaskChild.Supervisor_Esc_3__c = reportChild.Supervisor_Esc_3__c;
                stmTaskChild.Supervisor_Esc_4__c = reportChild.Supervisor_Esc_4__c;
                stmTaskChild.Supervisor_Esc_5__c = reportChild.Supervisor_Esc_5__c;
                stmTaskChild.QA_Esc_1__c = reportChild.QA_Esc_1__c;
                stmTaskChild.QA_Esc_2__c = reportChild.QA_Esc_2__c;
                stmTaskChild.QA_Esc_3__c = reportChild.QA_Esc_3__c;
                stmTaskChild.QA_Esc_4__c = reportChild.QA_Esc_4__c;
                stmTaskChild.QA_Esc_5__c = reportChild.QA_Esc_5__c;
                stmTaskChild.CE_Esc_1__c = reportChild.CE_Esc_1__c;
                stmTaskChild.CE_Esc_2__c = reportChild.CE_Esc_2__c;
                stmTaskChild.CE_Esc_3__c = reportChild.CE_Esc_3__c;
                stmTaskChild.CE_Esc_4__c = reportChild.CE_Esc_4__c;
                stmTaskChild.CE_Esc_5__c = reportChild.CE_Esc_5__c;
                
                mapTask.put(stmTask.Name,stmTaskChild);
            }
            
            Database.Insert(lstNewSTMTasks);    //Inserting STM Task records
            
            List<ContentVersion> lstAttachments = new List<ContentVersion>();
            Map<String,String> mapTaskContentId = new Map<String,String>();
            for(STMTask__c taskRec: lstNewSTMTasks){
                if(mapTask.get(taskRec.Name) != NULL){
                    mapTask.get(taskRec.Name).STMTask__c = taskRec.Id;
                }
                if(MapNameDocument.get(taskRec.Name.toUpperCase()) != NULL){
                    ContentVersion cVerNew  = new ContentVersion();
                    cVerNew.VersionData     = MapNameDocument.get(taskRec.Name.toUpperCase()).VersionData;
                    cVerNew.Description     = MapNameDocument.get(taskRec.Name.toUpperCase()).Description;
                    cVerNew.Title           = taskRec.Name;
                    cVerNew.PathOnClient    = MapNameDocument.get(taskRec.Name.toUpperCase()).PathOnClient;
                    cVerNew.Origin = 'H';
                    lstAttachments.add(cVerNew);
                    mapTaskContentId.put(cVerNew.Title,taskRec.Id);
                }
            }
            Database.Insert(mapTask.values());    //Inserting STM Task Child
            Database.Insert(lstAttachments);      //Inserting ContentVersions
            
            List<FeedItem> lstNewFeedItems = new List<FeedItem>();
            for(ContentVersion cNew: lstAttachments){
                if(mapTaskContentId.get(cNew.Title) != NULL){
                    FeedItem fi = new FeedItem();
                    fi.Type = 'ContentPost';
                    fi.RelatedRecordId = cNew.Id;
                    fi.ParentId = mapTaskContentId.get(cNew.Title);
                    fi.Title = cNew.Title;
                    lstNewFeedItems.add(fi);
                }
            }
            Database.Insert(lstNewFeedItems); //Inserting FeedItems for the ContentVersions

            //Deleting Attachments processed from the Library 'STM Auto Task Library'
            List<String> lstContentDocumentsToDelete = new List<String>();
            system.debug('####lstCVId:####'+lstCVId);
            
            for(ContentVersion conVer: [select id,ContentDocumentId from ContentVersion where id in :lstCVId]){
                lstContentDocumentsToDelete.add(conVer.ContentDocumentId);
            }       
            system.debug('####Documents Deleted:####'+lstContentDocumentsToDelete);
            Database.Delete([select id from ContentDocument where id in :lstContentDocumentsToDelete]);
        }
    }

    public void finish(Database.BatchableContext BC){
        System.debug('###Auto Task Creation Batch Job Completed.###');
        System.debug('###Documents not processed are:###'+lstDocNotProcessed);
    }
}