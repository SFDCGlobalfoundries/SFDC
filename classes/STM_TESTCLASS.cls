/**
*    Company       :   Cognizant Technologies PTE Ltd.
*    Description   :   Test Class for STM classes and triggers
*    History       :   

        Initials        Date                Description
-----------------------------------------------------------------------------------------
        Nikhil Jain    12/22/2014           Test class created.
**/

 
@isTest(SEEALLDATA = false)
private class STM_TESTCLASS{
    
    static String PrepareSTMdata(String frequency){
        
        Account a = new Account();
        
        ReportProjectProfile__c rp = new ReportProjectProfile__c();
        rp.Report_Category__c = 'ENG Lot Status Report';
        rp.Name = 'ENG testReport';
        rp.Frequency__c = frequency;
        rp.AutoCopy__c = true;
        rp.Days_for_Report_Upload__c = 2;
        rp.CE_1__c = UserInfo.getuserid();
        rp.Report_File_Name__c  = 'testAttachment';
        insert rp;
        
        ReportProjectProfileChild__c rpChild = new ReportProjectProfileChild__c();
        rpChild.Alert_Reminder_User1__c = UserInfo.getuserid();
        rpChild.ReportProjectProfile__c = rp.Id;
        insert rpChild;
        
        STMTask__c task = new STMTask__c();
        task.Account__c = A.Id;
        task.ReportCategory__c = 'ENG Lot Status Report';
        task.Report_Project_Profile__c = rp.Id;
        task.Name = 'testAttachment_w21';
        task.Frequency__c = frequency;
        task.Days_for_Report_Upload__c = 2;
        task.CE_1__c = UserInfo.getuserid();
        task.Report_Due_Date__c = system.Today()+25;
        insert task;
        
        STMTaskChild__c taskChild = new STMTaskChild__c();
        taskChild.Alert_Reminder_User1__c = UserInfo.getuserid();
        taskChild.STMTask__c = task.Id;
        insert taskChild;
        
        return task.Id;
    }
    
    static testMethod void methodForWeeklyTask() {
        String taskId = PrepareSTMdata('Weekly');
        STMTask__c stmTask = [select id,Account__c,Name from STMTask__c where Id=:taskId];
        
        ContentVersion c2= new ContentVersion();
        c2.VersionData = blob.valueOf('testData');
        c2.Description = 'testDescription';
        c2.Title = 'testAttachment_w22';
        c2.PathOnClient = 'testAttachment_w22.csv';
        c2.Origin = 'H';
        insert c2;
        
        FeedItem fi = new FeedItem();
        fi.Type = 'ContentPost';
        fi.Title = 'testAttachment_w22';
        fi.RelatedRecordId = c2.Id;
        fi.ParentId = stmTask.Id;
        insert fi;
                
        Test.StartTest();
            STM_BATCH_AutoCopyFeed stmBatchJob = new STM_BATCH_AutoCopyFeed();
            ID batchprocessid = Database.executeBatch(stmBatchJob,1);
        Test.stopTest();
    }
    
    static testMethod void methodForMonthlyTask() {
        PrepareSTMdata('Monthly');
        Test.StartTest();
            STM_BATCH_AutoCopyFeed stmBatchJob = new STM_BATCH_AutoCopyFeed();
            ID batchprocessid = Database.executeBatch(stmBatchJob,1);
        Test.stopTest();
    }
    
    static testMethod void methodForQuarterlyTask() {
        PrepareSTMdata('Quarterly');
        Test.StartTest();
            STM_BATCH_AutoCopyFeed stmBatchJob = new STM_BATCH_AutoCopyFeed();
            ID batchprocessid = Database.executeBatch(stmBatchJob,1);
        Test.stopTest();
    }
        
    static testMethod void methodForYearlyTask() {
        PrepareSTMdata('Yearly');
        Test.StartTest();
            STM_BATCH_AutoCopyFeed stmBatchJob = new STM_BATCH_AutoCopyFeed();
            ID batchprocessid = Database.executeBatch(stmBatchJob,1);
        Test.stopTest();
    }
    
    static testMethod void method_STM_BATCH_SCHEDULER_AutoTask() {
        PrepareSTMdata('Yearly');
        Test.StartTest();
            STM_BATCH_SCHEDULER_AutoTask stmBatchJob = new STM_BATCH_SCHEDULER_AutoTask();
            SchedulableContext sc;
            stmBatchJob.execute(sc);
        Test.stopTest();
    }
    
    static testMethod void method_STM_BATCH_SCHEDULER_AutoCopy() {
        PrepareSTMdata('Yearly');
        Test.StartTest();
            STM_BATCH_SCHEDULER_AutoCopy stmBatchJob = new STM_BATCH_SCHEDULER_AutoCopy();
            SchedulableContext sc;
            stmBatchJob.execute(sc);
        Test.stopTest();
    }
    
    static testMethod void method_STM_BATCH_AutoTaskFeed() {
        PrepareSTMdata('Monthly');
        
        ContentVersion c2= new ContentVersion();
        c2.VersionData = blob.valueOf('testData');
        c2.Description = 'testDescription';
        c2.Title = 'testAttachment_w21';
        c2.PathOnClient = 'testAttachment_w21.csv';
        //c2.FirstPublishLocationId = Label.STM_AUTOTASK_LIBRARYID;
        insert c2;
        
        Test.StartTest();
            STM_BATCH_AutoTaskFeed stmBatchJob = new STM_BATCH_AutoTaskFeed();
            ID batchprocessid = Database.executeBatch(stmBatchJob,1);
        Test.stopTest();
    }
    
    static testMethod void method_STM_BATCH_AutoTaskFeed_noMatch() {
        PrepareSTMdata('Monthly');
        
        ContentVersion c2= new ContentVersion();
        c2.VersionData = blob.valueOf('testData');
        c2.Description = 'testDescription';
        c2.Title = 'testNoAttachment_w21';
        c2.PathOnClient = 'testNoAttachment_w21.csv';
        //c2.FirstPublishLocationId = Label.STM_AUTOTASK_LIBRARYID;
        insert c2;
        
        Test.StartTest();
            STM_BATCH_AutoTaskFeed stmBatchJob = new STM_BATCH_AutoTaskFeed();
            ID batchprocessid = Database.executeBatch(stmBatchJob,1);
        Test.stopTest();
    }
    
    static testMethod void method_STM_sendTaskContent(){
        String taskId = PrepareSTMdata('Monthly');
        STMTask__c stmTask = [select id,Account__c,Name,Report_Project_Profile__c from STMTask__c where Id=:taskId];
        
        ContentVersion c2= new ContentVersion();
        c2.VersionData = blob.valueOf('testData');
        c2.Description = 'testDescription';
        c2.Title = 'testAttachment_w22';
        c2.PathOnClient = 'testAttachment_w22.csv';
        c2.Origin = 'H';
        insert c2;
        
        FeedItem fi = new FeedItem();
        fi.Type = 'ContentPost';
        fi.Title = 'testAttachment_w22';
        fi.RelatedRecordId = c2.Id;
        fi.ParentId = stmTask.Id;
        insert fi;
        
        Test.StartTest();
            ApexPages.StandardController sc = new ApexPages.standardController(stmTask);
            STM_sendTaskContent obj = new STM_sendTaskContent(sc);
            obj.addRows();
            obj.delWrapper();
            
            obj.showContactBlock();
            
            obj.wrappers.clear();
            STM_SendTaskContent.ContactWrapper cWrapper = new STM_SendTaskContent.ContactWrapper(1);
            cWrapper.con.firstname = 'FirstNameSTM';
            cWrapper.con.lastname = 'LastNameSTM';
            cWrapper.con.email = 'emailID@STM.com';
            obj.wrappers.add(cWrapper);
            obj.saveContacts();
            
            STM_Contact__c con1 = new STM_Contact__c();
            Contact c = [select id from Contact limit 1];
            con1.Contact__c = c.Id;
            con1.Report_Profile__c = stmTask.Report_Project_Profile__c;
            insert con1;
            
            obj.lstAttWrapper.add(new STM_sendTaskContent.SelectedAttachmentWrapper(fi,TRUE));
            for(STM_SendTaskContent.SelectedAttachmentWrapper wr: obj.lstAttWrapper){
                wr.IsChecked = True;
            }
            obj.sendEmail(); // Send Email when both Attachment and Contact is selected.
            
            //Inserting the same contact again to cover the exception
            obj.wrappers.clear();
            STM_SendTaskContent.ContactWrapper cWrapper2 = new STM_SendTaskContent.ContactWrapper(1);
            cWrapper2.con.firstname = 'FirstNameSTM';
            cWrapper2.con.lastname = 'LastNameSTM';
            cWrapper2.con.email = 'emailID@STM.com';
            obj.wrappers.add(cWrapper2);            
            obj.saveContacts();
            
        Test.stopTest();
    }
    
    static testMethod void method_STM_ReportProfile(){
        Account a = new Account();
        
        ReportProjectProfile__c rp = new ReportProjectProfile__c();
        rp.Report_Category__c = 'ENG Lot Status Report';
        rp.Name = 'ENG testReport';
        rp.Frequency__c = 'Monthly';
        rp.AutoCopy__c = true;
        rp.Days_for_Report_Upload__c = 2;
        rp.Report_File_Name__c  = 'testAttachment_';
        insert rp;
        
        ReportProjectProfileChild__c rpChild = new ReportProjectProfileChild__c();
        //rpChild.Alert_Reminder_User1__c = UserInfo.getuserid();
        rpChild.ReportProjectProfile__c = rp.Id;
        insert rpChild;
        
        Test.StartTest();
            ApexPages.StandardController sc = new ApexPages.standardController(rp);
            STM_ReportProfile obj = new STM_ReportProfile(sc);
            
            // Saving without Alert User 1
            obj.SaveProfile(); 
            obj.profileChild.Alert_Reminder_User1__c = UserInfo.getUserId();
            obj.profileRecord.Days_for_Report_Upload__c = 3;
            
            // Saving without CE User 1
            obj.SaveProfile(); 
            obj.profileRecord.CE_1__c = UserInfo.getUserId();
            
            // Saving without QA User 1
            obj.profileRecord.SendToQA__c = TRUE;
            obj.SaveProfile(); 
            obj.profileRecord.QA_1__c = UserInfo.getUserId();
            
            // Saving without Supervisor User 1
            obj.profileRecord.SendToSupervisor__c = TRUE;
            obj.SaveProfile(); 
            obj.profileRecord.Supervisor_1__c  = UserInfo.getUserId();
            
            // Saving without Assignee User 1
            obj.profileRecord.SendToAssignee__c = TRUE;
            obj.SaveProfile();            
            obj.profileRecord.Assignee_1__c  = UserInfo.getUserId();
            
            //Escalation Details: Assignee
            obj.profileRecord.Escalation_for_Assignee__c = True;
            obj.profileRecord.Days_for_Assignee_Escalation__c = '2';
            obj.SaveProfile(); 
            obj.profileChild.Assignee_Esc_1__c = UserInfo.getUserId();
            
            //Escalation Details: Supervisor
            obj.profileRecord.Escalation_for_Supervisor__c = True;
            obj.profileRecord.Days_for_Supervisor_Escalation__c = '3';
            obj.SaveProfile(); 
            obj.profileChild.Supervisor_Esc_1__c = UserInfo.getUserId();
            
            //Escalation Details: QA
            obj.profileRecord.Escalation_for_QA__c = True;
            obj.profileRecord.Days_for_QA_Escalation__c = '2';
            obj.SaveProfile(); 
            obj.profileChild.QA_Esc_1__c = UserInfo.getUserId();
            
            //Escalation Details: CE
            obj.profileRecord.Escalation_for_CE__c = True;
            obj.profileRecord.Days_for_CE_Escalation__c = '2';
            obj.SaveProfile(); 
            obj.profileChild.CE_Esc_1__c = UserInfo.getUserId();
            
            //Successful Record
            obj.SaveProfile(); 
            
        Test.stopTest();
    }
    
    static testMethod void method_STM_ReportProfile2(){
        Account a = new Account();
        
        ReportProjectProfile__c rp = new ReportProjectProfile__c();
        
        Test.StartTest();
            ApexPages.StandardController sc = new ApexPages.standardController(rp);
            STM_ReportProfile obj = new STM_ReportProfile(sc);
            
            obj.profileRecord.Report_Category__c = 'ENG Lot Status Report';
            obj.profileRecord.Name = 'ENG testReport';
            obj.profileRecord.Frequency__c = 'Monthly';
            obj.profileRecord.AutoCopy__c = true;
            obj.profileRecord.Days_for_Report_Upload__c = 2;
            obj.profileRecord.CE_1__c = UserInfo.getuserid();
            obj.profileRecord.Report_File_Name__c  = 'testAttachment_';
            
            // Saving without Alert User 1
            obj.SaveProfile(); 
            obj.profileChild.Alert_Reminder_User1__c = UserInfo.getUserId();
            obj.profileRecord.Days_for_Report_Upload__c = 3;
            
            // Saving without CE User 1
            obj.SaveProfile(); 
            obj.profileRecord.CE_1__c = UserInfo.getUserId();
                        
            obj.SaveProfile(); 
            
        Test.stopTest();
    }
    
    static testMethod void method_STM_ReportTask(){
        String taskId = PrepareSTMdata('Monthly');
        STMTask__c stmTask = [select id,Account__c,CreatedById,Assignee_1__c,Supervisor_1__c,
                                QA_1__c,QA_2__c,QA_3__c,QA_4__c,QA_5__c,
                                CE_1__c ,CE_2__c ,CE_3__c,CE_4__c ,CE_5__c from STMTask__c where Id=:taskId];
        
        PageReference pageRef = Page.STMTaskRead;
        Test.setCurrentPage(pageRef);
        
        Test.StartTest();
            ApexPages.StandardController sc = new ApexPages.standardController(stmTask);
            STM_ReportTask obj = new STM_ReportTask(sc);
            
            obj.ReportNameFromPage = 'No Report Profile';
            obj.callPopulateFormNew();
            obj.SaveTask(); 
            
            obj.ReportNameFromPage = 'ENG testReport';
            obj.callPopulateFormNew();
            
            // Saving without Task Name
            obj.SaveTask();
            obj.taskRecord.Name = 'test Task Name';
            
            //Saving without Alert Reminder User 1
            obj.taskChild.Alert_Reminder_User1__c = NULL;
            obj.SaveTask();
            obj.taskChild.Alert_Reminder_User1__c = UserInfo.getUserId();
                        
            // Saving without Assignee User 1
            obj.taskRecord.SendToAssignee__c = True;
            obj.SaveTask(); 
            obj.taskRecord.Assignee_1__c = UserInfo.getUserId();
            
            // Saving without Supervisor User 1
            obj.taskRecord.SendToSupervisor__c = TRUE;
            obj.SaveTask(); 
            obj.taskRecord.Supervisor_1__c = UserInfo.getUserId();
            
            // Saving without QA User 1
            obj.taskRecord.SendToQA__c = TRUE;
            obj.SaveTask(); 
            obj.taskRecord.QA_1__c = UserInfo.getUserId();
            
            // Saving without CE User 1
            obj.taskRecord.CE_1__c = NULL;
            obj.SaveTask();            
            obj.taskRecord.CE_1__c = UserInfo.getUserId();
            
            //Escalation Details: Assignee
            obj.taskRecord.Escalation_for_Assignee__c  = True;
            obj.taskRecord.Days_for_Assignee_Escalation__c = '2';
            obj.SaveTask(); 
            obj.taskChild.Assignee_Esc_1__c = UserInfo.getUserId();
            
            //Escalation Details: Supervisor
            obj.taskRecord.Escalation_for_Supervisor__c = True;
            obj.taskRecord.Days_for_Supervisor_Escalation__c = '3';
            obj.SaveTask(); 
            obj.taskChild.Supervisor_Esc_1__c = UserInfo.getUserId();
            
            //Escalation Details: QA
            obj.taskRecord.Escalation_for_QA__c = True;
            obj.taskRecord.Days_for_QA_Escalation__c = '2';
            obj.SaveTask(); 
            obj.taskChild.QA_Esc_1__c = UserInfo.getUserId();
            
            //Escalation Details: CE
            obj.taskRecord.Escalation_for_CE__c = True;
            obj.taskRecord.Days_for_CE_Escalation__c = '2';
            obj.SaveTask(); 
            obj.taskChild.CE_Esc_1__c = UserInfo.getUserId();
            
            //Order of Assignee Users
            obj.taskRecord.Assignee_3__c = UserInfo.getUserId();
            obj.SaveTask(); 
            
            //Order of Supervisor Users
            obj.taskRecord.Assignee_3__c = NULL;
            obj.taskRecord.Supervisor_3__c = UserInfo.getUserId();
            obj.SaveTask(); 
            
            //Order of QA Users
            obj.taskRecord.Supervisor_3__c = NULL;
            obj.taskRecord.QA_3__c = UserInfo.getUserId();
            obj.SaveTask();
            
            //Order of CE Users
            obj.taskRecord.QA_3__c = NULL;
            obj.taskRecord.CE_3__c = UserInfo.getUserId();
            obj.SaveTask();
            
            obj.taskRecord.CE_3__c = NULL;
            //Successful Record
            obj.SaveTask(); 
            
            
            ContentVersion c2= new ContentVersion();
            c2.VersionData = blob.valueOf('testData');
            c2.Description = 'testDescription';
            c2.Title = 'testAttachment_w22';
            c2.PathOnClient = 'testAttachment_w22.csv';
            c2.Origin = 'H';
            insert c2;
            
            FeedItem fi = new FeedItem();
            fi.Type = 'ContentPost';
            fi.Title = 'testAttachment_w22';
            fi.RelatedRecordId = c2.Id;
            fi.ParentId = stmTask.Id;
            insert fi;
            delete fi;
            
            obj.initiateFTP();
            
            obj.voidTask();
            
            obj.redirectSendEmail();
            
            ContentVersion cVer= new ContentVersion();
            cVer.VersionData = blob.valueOf('testData');
            cVer.Description = 'testDescription';
            cVer.Title = 'testAttachment_w23';
            cVer.PathOnClient = 'testAttachment_w23.csv';
            cVer.Origin = 'H';
            insert cVer;
        
            FeedItem fi2 = new FeedItem();
            fi2.Type = 'ContentPost';
            fi2.Title = 'testAttachment_w23';
            fi2.RelatedRecordId = cVer.Id;
            fi2.ParentId = stmTask.Id;
            insert fi2;
            
            stmTask.Status__c = 'Approved';
            update stmTask;
            
        Test.stopTest();
    }
    
    static testMethod void methodForSTMTaskTrigger() {
        String taskId = PrepareSTMdata('Monthly');
        Test.StartTest();
        
            FeedItem fi = new FeedItem();
            fi.Title = 'testAttachment_test';
            fi.Type = 'ContentPost';
            fi.ContentData = blob.valueOf('testData');
            fi.ContentFileName = 'testAttachment_test.csv';
            fi.ParentId = taskId;
            insert fi;
            
            // Create an approval request for the account
            Approval.ProcessSubmitRequest req1 = new Approval.ProcessSubmitRequest();
            req1.setComments('Submitting request for approval.');
            req1.setObjectId(taskId);
            
            // Submit the approval request for the account
            Approval.ProcessResult result = Approval.process(req1);
                        
            // First, get the ID of the newly created item
            List<Id> newWorkItemIds = result.getNewWorkitemIds();
            
            // Instantiate the new ProcessWorkitemRequest object and populate it
            Approval.ProcessWorkitemRequest req2 = new Approval.ProcessWorkitemRequest();
            req2.setComments('Rejecting request.');
            req2.setAction('Reject');
            
            // Use the ID from the newly created item to specify the item to be worked
            req2.setWorkitemId(newWorkItemIds.get(0));
            
            // Submit the request for approval
            Approval.ProcessResult result2 =  Approval.process(req2);
            
        Test.stopTest();
    }
}