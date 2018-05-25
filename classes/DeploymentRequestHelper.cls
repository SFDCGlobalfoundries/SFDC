global class DeploymentRequestHelper {

    Webservice static String processApprovalNew (String requestId) {
        string retVal = 'Failure';
        try{        
            Deployment_Request__c dRequest = [SELECT Id, Name,Deployment_Request_Date_Time__c,Change_Type_txt__c,Total_Build_Summaries__c,CR_Number__c,Target_Environment_txt__c,
                                                    Application_Category_txt__c, Application_Name_txt__c, Stage_txt__c
                                               FROM Deployment_Request__c 
                                               WHERE Id =: requestId];
                                               
            list<DR_Configuration__c> configurations = [Select Id, Name, Additional_Notes__c, Application_Category__c, Application_Name__c, ApproverSubmitter_Check__c, Change_Type__c, Deployment_Status__c, Is_Code_Review_Completed__c,
                                                                    Is_TA_Review_Completed__c, Is_TFA_Review_Completed__c, Request_Type__c, Review_Status__c, Risk_Start_Approver1__c, Risk_Start_Approver2__c, Risk_Start_Approver3__c,
                                                                    RMA_Approver1__c, RMA_Approver2__c, RMA_Approver3__c, Source_Environment__c, Stage__c, Standard_Apps_Approver1__c, Standard_Apps_Approver2__c, Standard_Apps_Approver3__c,
                                                                    Support_KT_Status__c, System_Affected__c, Target_Environment__c, Wafer_Write_Off_Approver1__c, Wafer_Write_Off_Approver2__c, Wafer_Write_Off_Approver3__c
                                                          From DR_Configuration__c limit 1];
                  
                  
            if(dRequest != null){
                if(dRequest.Deployment_Request_Date_Time__c != null && dRequest.Deployment_Request_Date_Time__c.date() < Date.today()){
                    retVal = 'Request_datetime_Issue';
                }else if(dRequest.Change_Type_txt__c == 'Issue' && dRequest.CR_Number__c == null && dRequest.Total_Build_Summaries__c < 1 && dRequest.Target_Environment_txt__c == 'Production'){
                    retVal = 'Build_Summaries_Issue';
                    //oDR.addError('Please add Build Summaries or CR number as the Change Type is an Issue');                                
                }else if(dRequest.Stage_txt__c != 'Draft'){
                    retVal = 'Stage_Not_Equal_to_Draft';
                    //oDR.addError('Please add Build Summaries or CR number as the Change Type is an Issue');                                
                }else{
                    retVal = 'Success';
                    Approval.ProcessSubmitRequest approvalReq = new Approval.ProcessSubmitRequest();
                    approvalReq.setObjectId(dRequest.Id);
                    Approval.ProcessResult processResult = Approval.process(approvalReq);
                }        
            }
        }catch(Exception ex){
            system.debug('Exception occur:'+ex.getMessage());
            retVal = ex.getMessage();
        }
        return retVal;  
    } 
}