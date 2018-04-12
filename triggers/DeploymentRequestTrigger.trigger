trigger DeploymentRequestTrigger on Deployment_Request__c (after update, before update) {
    list<Task> tasks = new list<Task>();
    
    list<DR_Configuration__c> drconfig = [Select Id, Name, Additional_Notes__c, Application_Category__c, Application_Name__c, ApproverSubmitter_Check__c, Change_Type__c, Deployment_Status__c, Is_Code_Review_Completed__c,
                                              Is_TA_Review_Completed__c, Is_TFA_Review_Completed__c, Request_Type__c, Review_Status__c, Risk_Start_Approver1__c, Risk_Start_Approver2__c, Risk_Start_Approver3__c,
                                              RMA_Approver1__c, RMA_Approver2__c, RMA_Approver3__c, Source_Environment__c, Stage__c, Standard_Apps_Approver1__c, Standard_Apps_Approver2__c, Standard_Apps_Approver3__c,
                                              Support_KT_Status__c, System_Affected__c, Target_Environment__c, Wafer_Write_Off_Approver1__c, Wafer_Write_Off_Approver2__c, Wafer_Write_Off_Approver3__c
                                              From DR_Configuration__c limit 1];
    for(Deployment_Request__c dr: trigger.new){
        Deployment_Request__c oldDR= trigger.oldMap.get(dr.Id);
    
        if(drconfig.size() > 0 && drconfig[0].ApproverSubmitter_Check__c){
            if((oldDR.RM_Review_Status_txt__c != dr.RM_Review_Status_txt__c) && 
               (dr.RM_Review_Status_txt__c == 'SDM Approval' || dr.RM_Review_Status_txt__c == 'Approved' || dr.RM_Review_Status_txt__c == 'Rejected') && 
               (dr.CreatedById == dr.LastModifiedById)){                
                // add error message to prevent update.
                dr.addError('Deployment Request creator cannot approve/reject the record.');
            }            
        }
        
        if(dr.Stage_txt__c == 'Approved' && oldDR.Stage_txt__c != 'Approved'){
            //create Task               
            Task t = new Task();
            t.ownerId = dr.ownerId;
            t.whatId = dr.Id;
            t.Subject = 'Post Implementation Review';
            t.Status = 'Not Started';
            t.Description = 'This is implementation review task';
            tasks.add(t);
        }   
        
        if(trigger.isBefore){
            if(dr.Approver_Response1__c && !oldDR.Approver_Response1__c){
                if(dr.Application_Category_txt__c == 'Standard Apps' && drconfig[0].Standard_Apps_Approver2__c != null)
                    dr.Initial_Approver__c = drconfig[0].Standard_Apps_Approver2__c;
                if(dr.Application_Category_txt__c == 'SOX compliance Apps' && dr.Application_Name_txt__c == 'PX - Risk Start System' && drconfig[0].Risk_Start_Approver2__c != null)
                    dr.Initial_Approver__c = drconfig[0].Risk_Start_Approver2__c;
                if(dr.Application_Category_txt__c == 'SOX compliance Apps' && dr.Application_Name_txt__c == 'RMA' && drconfig[0].RMA_Approver2__c != null)
                    dr.Initial_Approver__c = drconfig[0].RMA_Approver2__c;
            }
    
            if(dr.Approver_Response2__c && !oldDR.Approver_Response2__c){
                if(dr.Application_Category_txt__c == 'Standard Apps' && drconfig[0].Standard_Apps_Approver3__c != null)
                    dr.Initial_Approver__c = drconfig[0].Standard_Apps_Approver3__c;
                if(dr.Application_Category_txt__c == 'SOX compliance Apps' && dr.Application_Name_txt__c == 'PX - Risk Start System' && drconfig[0].Risk_Start_Approver3__c != null)
                    dr.Initial_Approver__c = drconfig[0].Risk_Start_Approver3__c;
                if(dr.Application_Category_txt__c == 'SOX compliance Apps' && dr.Application_Name_txt__c == 'RMA' && drconfig[0].RMA_Approver3__c != null)
                    dr.Initial_Approver__c = drconfig[0].RMA_Approver3__c;
            }
        }
    }
    
    if(tasks.size() > 0) insert tasks;
}