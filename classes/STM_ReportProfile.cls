public with sharing class STM_ReportProfile{

    public ReportProjectProfile__c profileRecord = new ReportProjectProfile__c();
    private Id profileId;
    public ReportProjectProfileChild__c profileChild{get;set;}
    
    public STM_ReportProfile(ApexPages.StandardController controller) {
        profileRecord = (ReportProjectProfile__c)controller.getRecord();
                
        //profileId = apexpages.currentpage().getparameters().get('id');
        profileId = controller.getId();
        
        if(profileId != NULL){
            profileChild = [select id,Assignee_Esc_1__c,Assignee_Esc_2__c,Assignee_Esc_3__c,Assignee_Esc_4__c,Assignee_Esc_5__c,
                         Supervisor_Esc_1__c,Supervisor_Esc_2__c,Supervisor_Esc_3__c,Supervisor_Esc_4__c,Supervisor_Esc_5__c,
                         QA_Esc_1__c,QA_Esc_2__c,QA_Esc_3__c,QA_Esc_4__c,QA_Esc_5__c,
                         CE_Esc_1__c,CE_Esc_2__c,CE_Esc_3__c,CE_Esc_4__c,CE_Esc_5__c
                         //,Alert_Reminder_User1__c,Alert_Reminder_User2__c,Alert_Reminder_User3__c
                         from ReportProjectProfileChild__c where ReportProjectProfile__c = :profileId limit 1];
        }
        else{
            profileChild = new ReportProjectProfileChild__c();
        }
    }
       
    public pageReference SaveProfile(){
        try{
                database.upsert(profileRecord);
    
                if(profileId==NULL){
                    profileChild.ReportProjectProfile__c = profileRecord.id;
                }
                
                //checks for escalation details
                if((profileChild.Assignee_Esc_1__c  == NULL || profileRecord.Days_for_Assignee_Escalation__c == NULL)&& profileRecord.Escalation_for_Assignee__c == TRUE){
                    ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Please select atleast first "Assignee Escalation User" and "Days for Escalation" under "Escalation Details" tab.'));
                    return null;
                }
                else if((profileChild.Supervisor_Esc_1__c  == NULL || profileRecord.Days_for_Supervisor_Escalation__c == NULL)&& profileRecord.Escalation_for_Supervisor__c == TRUE){
                    ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Please select atleast first "Supervisor Escalation User" and "Days for Escalation" under "Escalation Details" tab.'));
                    return null;            
                }
                else if((profileChild.QA_Esc_1__c  == NULL || profileRecord.Days_for_QA_Escalation__c == NULL) && profileRecord.Escalation_for_QA__c == TRUE){
                    ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Please select atleast first "QA Escalation User" and "Days for Escalation" under "Escalation Details" tab.'));
                    return null;
                }
                else if((profileChild.CE_Esc_1__c  == NULL || profileRecord.Days_for_CE_Escalation__c == NULL) && profileRecord.Escalation_for_CE__c == TRUE){
                    ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Please select atleast first "CE Escalation User" and "Days for Escalation" under "Escalation Details" tab.'));
                    return null;
                }
                
                //checks for workflow details
                if(profileRecord.Assignee_1__c  == NULL && profileRecord.SendToAssignee__c == TRUE){
                    ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Please select atleast first Assignee User under "Workflow Details" tab.'));
                    return null;
                }
                else if(profileRecord.Supervisor_1__c  == NULL && profileRecord.SendToSupervisor__c == TRUE){
                    ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Please select atleast first Supervisor User under "Workflow Details" tab.'));
                    return null;            
                }
                else if(profileRecord.QA_1__c  == NULL && profileRecord.SendToQA__c == TRUE){
                    ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Please select atleast first QA User under "Workflow Details" tab.'));
                    return null;
                }
                else if(profileRecord.CE_1__c  == NULL){
                    ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Please select atleast first CE User under "Workflow Details" tab.'));
                    return null;
                }
                //for Alert Details
                /*if(profileChild.Alert_Reminder_User1__c == NULL || profileRecord.Days_for_Report_Upload__c == NULL){
                    ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Please select atleast first "Alert User" and "Days for Report Upload" under "Alert Details" tab.'));
                    return null;
                }*/
                
                database.upsert(profileChild);
                PageReference pageRef = new PageReference('/apex/STM_ProfileRead?id='+profileRecord.id);
                pageRef.setRedirect(true);
                return pageRef;
        }catch(DMLException e){
            if(e.getDmlType(0) == StatusCode.INSUFFICIENT_ACCESS_OR_READONLY){
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'You don\'t have access to Edit this record.'));
            }
            else if(e.getDmlType(0) == StatusCode.DUPLICATE_VALUE){
                if(e.getMessage().contains('Report_File_Name__c')){
                    ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Report File Name already exists for another Report Profile.'));                
                }else{
                    ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Report Profile already exists with the same Report Title.'));
                }
            }
            else{
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Some Exception Occurred. Please contact administrator.'));
                System.Debug('###Exception Occured1###'+e.getMessage());
            }
        }catch(Exception e){
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Some Exception Occurred. Please contact administrator.'));
            System.Debug('###Exception Occured2###'+e.getMessage());
            return null;
        }
        return null;
    }
    
}