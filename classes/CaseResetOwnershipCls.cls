/*Author: UCM Team
* Description: This class is controller class for CaseResetOwnershipPage. This page and class are 
                used to reset owner from the case detail.
* History: Created on 02/16/2018
*/
public class CaseResetOwnershipCls {
    public Case caseVar;
    public List<id> userIds;
    public boolean flag{get;set;}
    public string errorMessage {get;set;}
    
    public CaseResetOwnershipCls(ApexPages.StandardController controller) {
        ApexPages.StandardController stdCtrl = controller;
        flag = false;
        errorMessage = '';
        caseVar = (Case) stdCtrl.getRecord();
        caseVar = [Select id ,IsNew__c,isAssignment__c,Date_Time_Verified__c,Close_Requested_Date__c,CreatedById,IsClosed,status from case where id = : caseVar.id][0]; 
    }
	
    public void resetCaseOwnership() {
        try {
            caseVar.IsNew__c = true;
            caseVar.isAssignment__c = true;                    
            Database.SaveResult saveResult = Database.update(caseVar, false);
            if (!saveResult.isSuccess()){
             flag = true;
             errorMessage = 'Couldn\'t save record as you do not have the level of necessary access to perform the operation you requested.\nPlease contact the owner of the record or your administrator if access is necessary';                                                  
            }
            else
            {
                errorMessage  = 'Record is updated successfully';
            }
               if(Test.isRunningTest()) {
                    throw new applicationException('In Test Mode');
            }
        }catch(Exception e) {
            ApplicationLogWrapper alw=new ApplicationLogWrapper();
            alw.source = CaseResetOwnershipCls.class.getName();
            alw.sourceFunction = 'resetCaseOwnership()';
            alw.ApplicationName='Device Management';                  
            alw.referenceInfo = 'Device';
            alw.logMessage ='Error Message='+e.getMessage()+' At Line Number='+e.getLineNumber()+' Stack Trace='+e.getStackTraceString();
            alw.debugLevel ='Error';
            alw.logCode =e.getTypeName();
            alw.ex=e.getCause();
            GlobalUtility.logMessage(alw);
            ApexPages.addMessages(e);    
        }            
    }
    
    public void closedVerified(){
        try {
            userIds = new List<id>();
            if(!caseVar.IsClosed) {
                if(UserInfo.getUserType() == 'Standard') {
                    errorMessage =  'Case is already open, please use Close Case functionality to close.';
                    flag = true;
                }
                else    {
                    errorMessage =  'Case is already open, please use OK to Close functionality to request close.';
                    flag = true;
                }
            }
            else    {
                if(caseVar.status != 'Closed - Verified') {
                    userIds = CaseWebServiceHandler.getGroupMember();
                    if(caseVar.CreatedById == UserInfo.getUserId() || userIds.contains(UserInfo.getUserId())) {
                        caseVar.Close_Requested_Date__c = system.now(); 
                        caseVar.Date_Time_Verified__c = system.now(); 
                        caseVar.Status = 'Closed - Verified'; 
                        Database.SaveResult saveResult = Database.update(caseVar, false);
                         if (!saveResult.isSuccess()){
                             flag = true;
                             errorMessage = 'Couldn\'t save record as you do not have the level of necessary access to perform the operation you requested.\nPlease contact the owner of the record or your administrator if access is necessary';                                                  
                        }           
               
                    }
                    else{
                        errorMessage =  'Only Case Creator can Verify the case and can change status to Closed - Verified.';
                        flag = true;
                    }
                }
                else {
                    errorMessage =  'Case is already Closed - Verified status.';
                    flag = true;
                }
            }
            if(!flag) {
                errorMessage = 'Case status successfully changed to Closed - Verified.';
            }
            if(Test.isRunningTest()) {
                throw new applicationException('In Test Mode');
            } 
        }catch(Exception e) {
            ApplicationLogWrapper alw=new ApplicationLogWrapper();
            alw.source = CaseResetOwnershipCls.class.getName();
            alw.sourceFunction = 'closedVerified()';
            alw.ApplicationName='Device Management';                  
            alw.referenceInfo = 'Device';
            alw.logMessage ='Error Message='+e.getMessage()+' At Line Number='+e.getLineNumber()+' Stack Trace='+e.getStackTraceString();
            alw.debugLevel ='Error';
            alw.logCode =e.getTypeName();
            alw.ex=e.getCause();
            GlobalUtility.logMessage(alw);
            ApexPages.addMessages(e);
        }
    }
    public class applicationException extends Exception {}
}