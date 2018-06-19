trigger DeploymentRequestTrigger on Deployment_Request__c (after update, before update) {
    list<DR_Task__c> tasks = new list<DR_Task__c>();
    
    list<DR_Configuration__c> drconfig = [Select Id, Name, Additional_Notes__c, Application_Category__c, Application_Name__c, ApproverSubmitter_Check__c, Change_Type__c, Deployment_Status__c, Is_Code_Review_Completed__c,
                                              Is_TA_Review_Completed__c, Is_TFA_Review_Completed__c, Request_Type__c, Review_Status__c, Risk_Start_Approver1__c, Risk_Start_Approver2__c, Risk_Start_Approver3__c,
                                              RMA_Approver1__c, RMA_Approver2__c, RMA_Approver3__c, Source_Environment__c, Stage__c, Standard_Apps_Approver1__c, Standard_Apps_Approver2__c, Standard_Apps_Approver3__c,
                                              Support_KT_Status__c, System_Affected__c, Target_Environment__c, Wafer_Write_Off_Approver1__c, Wafer_Write_Off_Approver2__c, Wafer_Write_Off_Approver3__c, Admin_Email__c
                                              From DR_Configuration__c limit 1];
    for(Deployment_Request__c dr: trigger.new){
        Deployment_Request__c oldDR= trigger.oldMap.get(dr.Id);
    
        if(drconfig.size() > 0 && drconfig[0].ApproverSubmitter_Check__c){
            if((oldDR.Stage_txt__c!= dr.Stage_txt__c) && (dr.Stage_txt__c == 'Approved' || dr.Stage_txt__c == 'Rejected') && (dr.CreatedById == dr.LastModifiedById)){                
                // add error message to prevent update.
                dr.addError('Deployment Request creator cannot approve/reject the record.');
            }            
        }
        
        if(trigger.isAfter){
            if(dr.Stage_txt__c == 'Deployed' && oldDR.Stage_txt__c != 'Deployed'){
                //create Task               
                DR_Task__c t = new DR_Task__c();
                t.Assigned_To__c = dr.ownerId;
                t.Admin_Email__c = drconfig[0].GFSDR__Admin_Email__c;
                t.Deployment_Request__c = dr.Id;
                t.Subject__c = 'Post Deployment Review';
                t.Status__c = 'Not Started';
                t.Description__c = 'Please validate changes in the target environment to complete the task';
                tasks.add(t);
            }   
            
            if(dr.Stage_txt__c == 'Approved' && oldDR.Stage_txt__c != 'Approved'){
                //create Task               
                DR_Task__c t = new DR_Task__c();
                t.Admin_Email__c = drconfig[0].Admin_Email__c;
                t.Deployment_Request__c = dr.Id;
                t.Subject__c = 'Deployment Task';
                t.Status__c = 'Not Started';
                t.Description__c = 'Please deploy changes to the target environment and close the request';
                tasks.add(t);
            }            
        }                
    }    
    if(tasks.size() > 0) insert tasks;
    
/*    if(trigger.isBefore){    
        for(Deployment_Request__c dr: trigger.new){
            if(dr.Stage_txt__c == 'Closed')
                dr.addError('Can not update Closed DR');
            list<ProcessInstance> drPIs = [SELECT Id, TargetObjectId, (SELECT Id, StepStatus, Comments, ActorId, CreatedDate FROM StepsAndWorkitems where StepStatus = 'Approved' order by CreatedDate DESC) FROM ProcessInstance where TargetObjectId = :dr.Id];
            system.debug('>>>>>>>>>>drPIs:'+drPIs);
            system.debug('>>>>>>>>>>dr.Stage_txt__c:'+dr.Stage_txt__c);
            if(drPIs.size() > 0 && drPIs[0].StepsAndWorkitems.size() > 0){
                list<User> actor = [Select Id, Name from User where Id = :drPIs[0].StepsAndWorkitems[0].ActorId];
                if(dr.Stage_txt__c == 'TA Review')            
                    dr.TFA_Approver_Name__c = actor[0].Name;
                if(dr.Stage_txt__c == 'CAB Review' && dr.Target_Environment_txt__c == 'UAT')            
                    dr.TA_Approver_Name__c = actor[0].Name;
                if(dr.Stage_txt__c == 'Approved' && dr.Target_Environment_txt__c == 'UAT')            
                    dr.CAB_Approver_Name__c = actor[0].Name;

                if(dr.Stage_txt__c == 'Test Review')            
                    dr.EBIZ_FBO_Approver_Name__c = actor[0].Name;
                if(dr.Stage_txt__c == 'SOD Review')            
                    dr.Test_Approver_Name__c = actor[0].Name;
                if(dr.Stage_txt__c == 'CAB Review' && dr.Target_Environment_txt__c == 'Production')            
                    dr.SOD_Approver_Name__c = actor[0].Name;
                if(dr.Stage_txt__c == 'Approved' && dr.Target_Environment_txt__c == 'Production')            
                    dr.CAB_Approver_Name__c = actor[0].Name; 
            }             
        }        
    } */
}