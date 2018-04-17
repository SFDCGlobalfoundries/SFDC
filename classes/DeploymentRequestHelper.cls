global class DeploymentRequestHelper {

    Webservice static String processApprovalNew (String requestId) {
        string retVal = 'Failure';
        try{        
            Deployment_Request__c dRequest = [SELECT Id, Name,Deployment_Request_Date_Time__c,Change_Type__c,Total_Build_Summaries__c,CR_Number__c,Target_Environment__c
                                               FROM Deployment_Request__c 
                                               WHERE Id =: requestId];
            if(dRequest != null){
                if(dRequest.Deployment_Request_Date_Time__c != null && dRequest.Deployment_Request_Date_Time__c.date() < Date.today()){
                    retVal = 'Request_datetime_Issue';
                }else if(dRequest.Change_Type__c == 'Issue' && dRequest.CR_Number__c == null && dRequest.Total_Build_Summaries__c < 1 && dRequest.Target_Environment__c == 'Production'){
                    retVal = 'Build_Summaries_Issue';
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