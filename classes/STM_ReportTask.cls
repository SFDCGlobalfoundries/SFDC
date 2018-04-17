public with sharing class STM_ReportTask {
    
    ApexPages.standardController sc;
    STMTask__c taskRecord = new STMTask__c();
    public Id taskId{get;set;}
    public STMTaskChild__c taskChild{get;set;}
    public string ReportNameFromPage {get;set;}
    public Boolean creator{get;set;}
    public Boolean isCEIntiateFTP{get;set;}
    public Boolean isQA{get;set;}
    
    public STM_ReportTask(ApexPages.StandardController controller){
        taskRecord = (STMTask__c)controller.getRecord();
        sc = controller;
        taskId  = controller.getId();
        if(taskId != NULL){
            List<STMTaskChild__c> lstTaskChild = new List<STMTaskChild__c>();
            lstTaskChild = [select id,Assignee_Esc_1__c, Assignee_Esc_1__r.name, Assignee_Esc_2__c,Assignee_Esc_2__r.name,
                         Assignee_Esc_3__c, Assignee_Esc_3__r.name,Assignee_Esc_4__c,Assignee_Esc_4__r.name,
                         Assignee_Esc_5__c,Assignee_Esc_5__r.name,
                         Supervisor_Esc_1__c,Supervisor_Esc_1__r.name,Supervisor_Esc_2__c,Supervisor_Esc_2__r.name,
                         Supervisor_Esc_3__c,Supervisor_Esc_3__r.name,Supervisor_Esc_4__c,Supervisor_Esc_4__r.name,
                         Supervisor_Esc_5__c,Supervisor_Esc_5__r.name,
                         QA_Esc_1__c,QA_Esc_1__r.name, QA_Esc_2__c,QA_Esc_2__r.name,QA_Esc_3__c,QA_Esc_3__r.name,
                         QA_Esc_4__c,QA_Esc_4__r.name,QA_Esc_5__c,QA_Esc_5__r.name,CE_Esc_5__c,CE_Esc_5__r.name,
                         CE_Esc_1__c,CE_Esc_1__r.name,CE_Esc_2__c,CE_Esc_2__r.name,CE_Esc_3__c,CE_Esc_3__r.name,CE_Esc_4__c,CE_Esc_4__r.name
                         //,Alert_Reminder_User1__c,Alert_Reminder_User2__c,Alert_Reminder_User3__c
                         //,Alert_Reminder_User1__r.name,Alert_Reminder_User2__r.name,Alert_Reminder_User3__r.name
                         from STMTaskChild__c where STMTask__c = :taskId limit 1];
            
            if(taskRecord.CreatedById != UserInfo.getUserId()){
                creator = False;
            }else{
                creator = True;
            }
            
            if(lstTaskChild != NULL && !lstTaskChild.isEmpty()){
                taskChild = lstTaskChild[0];
            }else{
                taskChild = new STMTaskChild__c();
            }
        }else{
             taskChild = new STMTaskChild__c();
             creator = True;
        }
        if( UserInfo.getUserId() == taskRecord.CE_1__c || UserInfo.getUserId() == taskRecord.CE_2__c ||
            UserInfo.getUserId() == taskRecord.CE_3__c || UserInfo.getUserId() == taskRecord.CE_4__c ||
            UserInfo.getUserId() == taskRecord.CE_5__c){
            isCEIntiateFTP = True;
        }
        if( UserInfo.getUserId() == taskRecord.QA_1__c || UserInfo.getUserId() == taskRecord.QA_2__c ||
            UserInfo.getUserId() == taskRecord.QA_3__c || UserInfo.getUserId() == taskRecord.QA_4__c ||
            UserInfo.getUserId() == taskRecord.QA_5__c){
            isQA = True;
        }
    }
    
    public String SelectedReportCategory{get;set;}
    
    //++ Function for Populating form
    List<ReportProjectProfile__c> lstprofileRec;
    ReportProjectProfile__c profileRec;
    
    public PageReference callPopulateFormNew(){
        system.debug('#####ReportNameFromPage########'+ReportNameFromPage);
        lstprofileRec = new  List<ReportProjectProfile__c>();
        lstprofileRec.clear();
        lstprofileRec =[select id from ReportProjectProfile__c where name = :ReportNameFromPage limit 1];
        
        profileRec = new ReportProjectProfile__c();
        
        if(!lstprofileRec.isEmpty()){
            system.debug('Hello inside the loop');
            profileRec = [SELECT Id,Frequency__c,Report_Category__c, Account__c,Report_File_Name__c,
                            Source_System_Owner_1__c,Source_System_Owner_2__c,Source_System_Owner_3__c,Source_System_Owner_4__c,Source_System_Owner_5__c,
                            Assignee_1__c,Assignee_2__c,Assignee_3__c,Assignee_4__c,Assignee_5__c,
                            Assignee_6__c,Assignee_7__c,Assignee_8__c,Assignee_9__c,Assignee_10__c,
                            Supervisor_1__c,Supervisor_2__c,Supervisor_3__c,Supervisor_4__c,Supervisor_5__c,
                            QA_1__c,QA_2__c,QA_3__c,QA_4__c,QA_5__c,
                            CE_1__c,CE_2__c,CE_3__c,CE_4__c,CE_5__c,
                            SendToAssignee__c,SendToSupervisor__c,SendToQA__c,//Days_for_Report_Upload__c,
                            Days_for_Assignee_Escalation__c,Days_for_CE_Escalation__c,Days_for_QA_Escalation__c,Days_for_Supervisor_Escalation__c,
                            Escalation_for_Assignee__c,Escalation_for_Supervisor__c,Escalation_for_QA__c,Escalation_for_CE__c,
                                                        
                            (SELECT //Alert_Reminder_User1__c,Alert_Reminder_User2__c,Alert_Reminder_User3__c,
                            Assignee_Esc_1__c,Assignee_Esc_2__c,Assignee_Esc_3__c,Assignee_Esc_4__c,Assignee_Esc_5__c,
                            Supervisor_Esc_1__c,Supervisor_Esc_2__c,Supervisor_Esc_3__c,Supervisor_Esc_4__c,Supervisor_Esc_5__c,
                            QA_Esc_1__c,QA_Esc_2__c,QA_Esc_3__c,QA_Esc_4__c,QA_Esc_5__c,
                            CE_Esc_1__c,CE_Esc_2__c,CE_Esc_3__c,CE_Esc_4__c,CE_Esc_5__c, ReportProjectProfile__c
                            FROM Report_Project_Profile_Childs__r)
                            
                            FROM ReportProjectProfile__c 
                            //where id = :taskRecord.Report_Project_Profile__c limit 1];
                            where name = :ReportNameFromPage limit 1];                
            
            system.debug('###########profileRec ##########'+profileRec );
            if(profileRec !=NULL){
                taskRecord.Account__c              = profileRec.Account__c;
                taskRecord.Frequency__c            = profileRec.Frequency__c;
                
                //prepopulate Workflow Details from Project Profile as per the Report Type selected.
                taskRecord.SendToAssignee__c  = profileRec.SendToAssignee__c;
                taskRecord.SendToSupervisor__c= profileRec.SendToSupervisor__c;
                taskRecord.SendToQA__c        = profileRec.SendToQA__c;
                
                taskRecord.Source_System_Owner_1__c = profileRec.Source_System_Owner_1__c;
                taskRecord.Source_System_Owner_2__c = profileRec.Source_System_Owner_2__c;
                taskRecord.Source_System_Owner_3__c = profileRec.Source_System_Owner_3__c;
                taskRecord.Source_System_Owner_4__c = profileRec.Source_System_Owner_4__c;
                taskRecord.Source_System_Owner_5__c = profileRec.Source_System_Owner_5__c;
                
                taskRecord.Assignee_1__c = profileRec.Assignee_1__c;
                taskRecord.Assignee_2__c = profileRec.Assignee_2__c;
                taskRecord.Assignee_3__c = profileRec.Assignee_3__c;
                taskRecord.Assignee_4__c = profileRec.Assignee_4__c;
                taskRecord.Assignee_5__c = profileRec.Assignee_5__c;
                taskRecord.Assignee_6__c = profileRec.Assignee_6__c;
                taskRecord.Assignee_7__c = profileRec.Assignee_7__c;
                taskRecord.Assignee_8__c = profileRec.Assignee_8__c;
                taskRecord.Assignee_9__c = profileRec.Assignee_9__c;
                taskRecord.Assignee_10__c = profileRec.Assignee_10__c;
                
                taskRecord.Supervisor_1__c = profileRec.Supervisor_1__c;
                taskRecord.Supervisor_2__c = profileRec.Supervisor_2__c;
                taskRecord.Supervisor_3__c = profileRec.Supervisor_3__c;
                taskRecord.Supervisor_4__c = profileRec.Supervisor_4__c;
                taskRecord.Supervisor_5__c = profileRec.Supervisor_5__c;
                
                taskRecord.QA_1__c= profileRec.QA_1__c;
                taskRecord.QA_2__c= profileRec.QA_2__c;
                taskRecord.QA_3__c= profileRec.QA_3__c;
                taskRecord.QA_4__c= profileRec.QA_4__c;
                taskRecord.QA_5__c= profileRec.QA_5__c;
                
                taskRecord.CE_1__c= profileRec.CE_1__c;
                taskRecord.CE_2__c= profileRec.CE_2__c;
                taskRecord.CE_3__c= profileRec.CE_3__c;
                taskRecord.CE_4__c= profileRec.CE_4__c;
                taskRecord.CE_5__c= profileRec.CE_5__c;
                
                
                //prepopulate Escalation Details from Project Profile as per the Report Type selected.
                taskRecord.Escalation_for_Assignee__c  = profileRec.Escalation_for_Assignee__c;
                taskRecord.Escalation_for_Supervisor__c= profileRec.Escalation_for_Supervisor__c;
                taskRecord.Escalation_for_QA__c        = profileRec.Escalation_for_QA__c;
                taskRecord.Escalation_for_CE__c        = profileRec.Escalation_for_CE__c;
        
                taskRecord.Days_for_Assignee_Escalation__c    = profileRec.Days_for_Assignee_Escalation__c;
                taskRecord.Days_for_Supervisor_Escalation__c  = profileRec.Days_for_Supervisor_Escalation__c;
                taskRecord.Days_for_QA_Escalation__c          = profileRec.Days_for_QA_Escalation__c;
                taskRecord.Days_for_CE_Escalation__c          = profileRec.Days_for_CE_Escalation__c;           
                
                taskChild.Assignee_Esc_1__c = profileRec.Report_Project_Profile_Childs__r[0].Assignee_Esc_1__c;
                taskChild.Assignee_Esc_2__c = profileRec.Report_Project_Profile_Childs__r[0].Assignee_Esc_2__c;
                taskChild.Assignee_Esc_3__c = profileRec.Report_Project_Profile_Childs__r[0].Assignee_Esc_3__c;
                taskChild.Assignee_Esc_4__c = profileRec.Report_Project_Profile_Childs__r[0].Assignee_Esc_4__c;
                taskChild.Assignee_Esc_5__c = profileRec.Report_Project_Profile_Childs__r[0].Assignee_Esc_5__c;
                
                taskChild.Supervisor_Esc_1__c = profileRec.Report_Project_Profile_Childs__r[0].Supervisor_Esc_1__c;
                taskChild.Supervisor_Esc_2__c = profileRec.Report_Project_Profile_Childs__r[0].Supervisor_Esc_2__c;
                taskChild.Supervisor_Esc_3__c = profileRec.Report_Project_Profile_Childs__r[0].Supervisor_Esc_3__c;
                taskChild.Supervisor_Esc_4__c = profileRec.Report_Project_Profile_Childs__r[0].Supervisor_Esc_4__c;
                taskChild.Supervisor_Esc_5__c = profileRec.Report_Project_Profile_Childs__r[0].Supervisor_Esc_5__c;
                
                taskChild.QA_Esc_1__c = profileRec.Report_Project_Profile_Childs__r[0].QA_Esc_1__c;
                taskChild.QA_Esc_2__c = profileRec.Report_Project_Profile_Childs__r[0].QA_Esc_2__c;
                taskChild.QA_Esc_3__c = profileRec.Report_Project_Profile_Childs__r[0].QA_Esc_3__c;
                taskChild.QA_Esc_4__c = profileRec.Report_Project_Profile_Childs__r[0].QA_Esc_4__c;
                taskChild.QA_Esc_5__c = profileRec.Report_Project_Profile_Childs__r[0].QA_Esc_5__c;
                
                taskChild.CE_Esc_1__c = profileRec.Report_Project_Profile_Childs__r[0].CE_Esc_1__c;
                taskChild.CE_Esc_2__c = profileRec.Report_Project_Profile_Childs__r[0].CE_Esc_2__c;
                taskChild.CE_Esc_3__c = profileRec.Report_Project_Profile_Childs__r[0].CE_Esc_3__c;
                taskChild.CE_Esc_4__c = profileRec.Report_Project_Profile_Childs__r[0].CE_Esc_4__c;
                taskChild.CE_Esc_5__c = profileRec.Report_Project_Profile_Childs__r[0].CE_Esc_5__c;
                
                //prepopulate Alert Details from Project Profile as per the Report Type selected.
                //taskRecord.Days_for_Report_Upload__c = profileRec.Days_for_Report_Upload__c;
                //taskChild.Alert_Reminder_User1__c = profileRec.Report_Project_Profile_Childs__r[0].Alert_Reminder_User1__c;
                //taskChild.Alert_Reminder_User2__c = profileRec.Report_Project_Profile_Childs__r[0].Alert_Reminder_User2__c;
                //taskChild.Alert_Reminder_User3__c = profileRec.Report_Project_Profile_Childs__r[0].Alert_Reminder_User3__c;
                
                //populate the Task Name
                String currentWeek = DateTime.newInstanceGmt(
                                        Date.newInstance(System.today().Year(), System.today().Month(),System.today().Day()
                                                         ).toStartOfWeek(), Time.NewInstance(12,0,0,0)
                                     ).format('w');
                String currentMonthNo = '';
                if(System.today().Month() <= 9){
                    currentMonthNo = '0'+ string.valueOf(System.today().Month());
                }else{
                    currentMonthNo = string.valueOf(System.today().Month());
                }
                
                if(taskRecord.Frequency__c == 'Monthly' || taskRecord.Frequency__c == 'Yearly' || taskRecord.Frequency__c == 'Quarterly' || taskRecord.Frequency__c == 'Semi-Annually'){
                    taskRecord.Name = profileRec.Report_File_Name__c + '_' + System.TODAY().YEAR() + '-' + currentMonthNo;
                }else{
                    taskRecord.Name = profileRec.Report_File_Name__c + '_W' + currentWeek;
                }
            }
        }
        else{
            taskRecord.Name                    = NULL;
            taskRecord.Account__c              = NULL;
            taskRecord.Frequency__c            = NULL;
            taskRecord.SendToAssignee__c  = NULL;
            taskRecord.SendToSupervisor__c= NULL;
            taskRecord.SendToQA__c        = NULL;
            taskRecord.Source_System_Owner_1__c = NULL;
            taskRecord.Source_System_Owner_2__c = NULL;
            taskRecord.Source_System_Owner_3__c = NULL;
            taskRecord.Source_System_Owner_4__c = NULL;
            taskRecord.Source_System_Owner_5__c = NULL;
            taskRecord.Assignee_1__c = NULL;
            taskRecord.Assignee_2__c = NULL;
            taskRecord.Assignee_3__c = NULL;
            taskRecord.Assignee_4__c = NULL;
            taskRecord.Assignee_5__c = NULL;
            taskRecord.Assignee_6__c = NULL;
            taskRecord.Assignee_7__c = NULL;
            taskRecord.Assignee_8__c = NULL;
            taskRecord.Assignee_9__c = NULL;
            taskRecord.Assignee_10__c = NULL;
            taskRecord.Supervisor_1__c = NULL;
            taskRecord.Supervisor_2__c = NULL;
            taskRecord.Supervisor_3__c = NULL;
            taskRecord.Supervisor_4__c = NULL;
            taskRecord.Supervisor_5__c = NULL;
            taskRecord.QA_1__c= NULL;
            taskRecord.QA_2__c= NULL;
            taskRecord.QA_3__c= NULL;
            taskRecord.QA_4__c= NULL;
            taskRecord.QA_5__c= NULL;
            taskRecord.CE_1__c= NULL;
            taskRecord.CE_2__c= NULL;
            taskRecord.CE_3__c= NULL;
            taskRecord.CE_4__c= NULL;
            taskRecord.CE_5__c= NULL;
            taskRecord.Escalation_for_Assignee__c  = NULL;
            taskRecord.Escalation_for_Supervisor__c= NULL;
            taskRecord.Escalation_for_QA__c        = NULL;
            taskRecord.Escalation_for_CE__c        = NULL;
            taskRecord.Days_for_Assignee_Escalation__c    = NULL;
            taskRecord.Days_for_Supervisor_Escalation__c  = NULL;
            taskRecord.Days_for_QA_Escalation__c          = NULL;
            taskRecord.Days_for_CE_Escalation__c          = NULL;           
            taskChild.Assignee_Esc_1__c = NULL;
            taskChild.Assignee_Esc_2__c = NULL;
            taskChild.Assignee_Esc_3__c = NULL;
            taskChild.Assignee_Esc_4__c = NULL;
            taskChild.Assignee_Esc_5__c = NULL;
            taskChild.Supervisor_Esc_1__c = NULL;
            taskChild.Supervisor_Esc_2__c = NULL;
            taskChild.Supervisor_Esc_3__c = NULL;
            taskChild.Supervisor_Esc_4__c = NULL;
            taskChild.Supervisor_Esc_5__c = NULL;
            taskChild.QA_Esc_1__c = NULL;
            taskChild.QA_Esc_2__c = NULL;
            taskChild.QA_Esc_3__c = NULL;
            taskChild.QA_Esc_4__c = NULL;
            taskChild.QA_Esc_5__c = NULL;
            taskChild.CE_Esc_1__c = NULL;
            taskChild.CE_Esc_2__c = NULL;
            taskChild.CE_Esc_3__c = NULL;
            taskChild.CE_Esc_4__c = NULL;
            taskChild.CE_Esc_5__c = NULL;
            //taskRecord.Days_for_Report_Upload__c = NULL;
            //taskChild.Alert_Reminder_User1__c = NULL;
            //taskChild.Alert_Reminder_User2__c = NULL;
            //taskChild.Alert_Reminder_User3__c = NULL;
        }
        return null;
    }
    //--New function for Populating form   
    
    public pageReference SaveTask(){
        try{
            if(taskRecord.Name == NULL){
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Please fill in the Task Name under the Report Details tab.'));
                return null;
            }
            
            if(taskRecord.Assignee_1__c==NULL && taskRecord.SendToAssignee__c == TRUE){
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Please fill in atleast first Assignee details'));
                return null;
            }
            if(taskRecord.Supervisor_1__c==NULL && taskRecord.SendToSupervisor__c == TRUE){
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Please select atleast first Supervisor under "Workflow Details" tab'));
                return null;
            }
            if(taskRecord.QA_1__c == NULL && taskRecord.SendToQA__c == TRUE){
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Please select atleast first QA under "Workflow Details" tab'));
                return null;
            }
            if(taskRecord.CE_1__c==NULL){
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Please select atleast first CE under "Workflow Details" tab'));
                return null;
            }
            
            //check if the Users has been added in the correct order
            if(taskRecord.SendToAssignee__c){                
                if(checkOrderOfUsers(taskRecord.Assignee_2__c,taskRecord.Assignee_3__c,taskRecord.Assignee_4__c,taskRecord.Assignee_5__c,
                                     taskRecord.Assignee_6__c,taskRecord.Assignee_7__c,taskRecord.Assignee_8__c,taskRecord.Assignee_9__c,
                                     taskRecord.Assignee_10__c)){
                    ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Please fill in Assignees in order.'));
                    return NULL;
                }
            }
            if(taskRecord.SendToSupervisor__c){                
                if(checkOrderOfUsers(taskRecord.Supervisor_2__c,taskRecord.Supervisor_3__c,taskRecord.Supervisor_4__c,taskRecord.Supervisor_5__c)){
                    ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Please fill in Supervisors in order.'));
                    return NULL;
                }
            }
            if(taskRecord.SendToQA__c){                
                if(checkOrderOfUsers(taskRecord.QA_2__c,taskRecord.QA_3__c,taskRecord.QA_4__c,taskRecord.QA_5__c)){
                    ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Please fill in QAs in order.'));
                    return NULL;
                }
            }
            if(checkOrderOfUsers(taskRecord.CE_2__c,taskRecord.CE_3__c,taskRecord.CE_4__c,taskRecord.CE_5__c)){
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Please fill in CEs in order.'));
                return NULL;
            }
            
            //replacing blank with test user for Escalation details
            if((taskChild.Assignee_Esc_1__c==NULL || taskRecord.Days_for_Assignee_Escalation__c == NULL) && taskRecord.Escalation_for_Assignee__c == TRUE){
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Please select atleast first "Assignee Escalation User" and "Days for Escalation" under "Escalation Details" tab'));
                return null;
            }
            if((taskChild.Supervisor_Esc_1__c==NULL|| taskRecord.Days_for_Supervisor_Escalation__c == NULL)&& taskRecord.Escalation_for_Supervisor__c == TRUE){
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Please select atleast first "Supervisor Escalation User" and "Days for Escalation" under "Escalation Details" tab'));
                return null;
            }
            if((taskChild.QA_Esc_1__c==NULL || taskRecord.Days_for_QA_Escalation__c == NULL) && taskRecord.Escalation_for_QA__c == TRUE){
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Please select atleast first "QA Escalation User" and "Days for Escalation" under "Escalation Details" tab'));
                return null;
            }
            if((taskChild.CE_Esc_1__c==NULL || taskRecord.Days_for_CE_Escalation__c == NULL) && taskRecord.Escalation_for_CE__c == TRUE){
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Please select atleast first "CE Escalation User" and "Days for Escalation" under "Escalation Details" tab'));
                return null;
            }
            
            //replacing blank with test user for Alert details
            /*if(taskChild.Alert_Reminder_User1__c ==NULL || taskRecord.Days_for_Report_Upload__c == NULL){
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Please select atleast first "Alert Reminder User" and "Days for Report Upload" under "Escalation Details" tab'));
                return null;
            }*/
            
            upsert(taskRecord);
            system.debug('################taskRecord##############'+taskRecord);
            system.debug('################taskChild##############'+taskChild);
            
            if(taskId==NULL){
                taskChild.STMTask__c = taskRecord.id;
            }
            database.upsert(taskChild);
            
            PageReference pageRef = new PageReference('/apex/STMTaskRead?id='+taskRecord.id);
            pageRef.setRedirect(true);
            return pageRef;
        }
        catch(DMLException e){
            if(e.getDmlType(0) == StatusCode.INSUFFICIENT_ACCESS_OR_READONLY){
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'You don\'t have access to Edit this record.'));
            }
            else if(e.getDmlType(0) == StatusCode.ENTITY_IS_LOCKED){
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Record is locked. Thus, you cannot edit it.'));
            }else{
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,e.getDmlMessage(0)));
                System.Debug('###Exception Occured###'+e.getMessage());
            }
        }
        catch(Exception e){
             ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Some Exeception Occured. Please contact System Administrator.'));
             System.Debug('###Exception Occured###'+e.getMessage());
             return null;
        }
        return null;
    }
    
    public boolean checkOrderOfUsers(Id User2, Id User3, Id User4, Id User5){
        if(
            (User5 != NULL && (User2 == NULL || User3 == NULL || User4 == NULL)) ||
            (User4 != NULL && (User2 == NULL || User3 == NULL)) ||
            (User3 != NULL && (User2 == NULL))
        ){
            return true;
        }else{
            return false;
        }
    }
    
    public boolean checkOrderOfUsers(Id User2, Id User3, Id User4, Id User5,Id User6, Id User7, Id User8, Id User9, Id User10){
        if(
            (User10!= NULL && (User2 == NULL || User3 == NULL || User4 == NULL || User5 == NULL || User6 == NULL || User7 == NULL || User8 == NULL || User9 == NULL)) ||
            (User9 != NULL && (User2 == NULL || User3 == NULL || User4 == NULL || User5 == NULL || User6 == NULL || User7 == NULL || User8 == NULL)) ||
            (User8 != NULL && (User2 == NULL || User3 == NULL || User4 == NULL || User5 == NULL || User6 == NULL || User7 == NULL)) ||
            (User7 != NULL && (User2 == NULL || User3 == NULL || User4 == NULL || User5 == NULL || User6 == NULL)) ||
            (User6 != NULL && (User2 == NULL || User3 == NULL || User4 == NULL || User5 == NULL)) ||
            (User5 != NULL && (User2 == NULL || User3 == NULL || User4 == NULL)) ||
            (User4 != NULL && (User2 == NULL || User3 == NULL)) ||
            (User3 != NULL && (User2 == NULL))
        ){
            return true;
        }else{
            return false;
        }
    }
    
    public pageReference voidTask(){
        taskRecord.Cancelled__c = True;
        taskRecord.Status__c = 'Cancelled';
        taskRecord.Approval_Stage__c = 'Cancelled';
        update taskRecord;
        return new PageReference('/'+taskRecord.Id);
    }
    
    public pageReference initiateFTP(){
        STM_SystemMode.initiateFTP(taskRecord.Id);
        return new PageReference('/'+taskRecord.Id);
    }
    
    public pageReference redirectSendEmail(){
        return new PageReference('/apex/STM_SendTaskContent?id='+taskRecord.Id);
    }
    
    public PageReference submitForApproval(){
        system.debug('####Inside Submit####');
        try{
            STMTask__C tskToSubmit = [select Count_of_Attachments__c,Approval_Criteria_Met__c from STMTask__c where id =:taskRecord.Id limit 1];
            if(tskToSubmit.Approval_Criteria_Met__c){
                Approval.ProcessSubmitRequest req = new Approval.ProcessSubmitRequest();
                req.setObjectId(taskRecord.Id);
                Approval.ProcessResult result = Approval.process(req);
                PageReference pageRef = new PageReference('/'+taskRecord.Id);
                pageRef.setRedirect(True);
                return pageRef;
            }else{
                string erMsg= '';
                if(tskToSubmit.Count_of_Attachments__c <1){
                    erMsg = 'Please attach atleast one file to submit this task for Approval.';
                }else{
                    erMsg = 'You don\'t have access to submit this task for Approval.';
                }
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,erMsg));
            }
        }catch (Exception ex){
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Some Exeception Occured. Please contact System Administrator.'));
            System.Debug('###Exception Occured###'+ex.getMessage());
            return NULL;
        }
        return NULL;
    }
}