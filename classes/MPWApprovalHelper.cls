/*
    Author: Kanishk Singh
    Description: Make comments section mandatory if the form is rejected.
    
*/

public class MPWApprovalHelper {

    public static void validateMPWFormRejectionReason(Map < Id, sObject > rejectedStatements) {
     try{
        for (ProcessInstance objProcessInstance: [SELECT id,TargetObjectId,
                (SELECT Id, StepStatus, Comments FROM Steps where StepStatus!='Started' ORDER BY CreatedDate DESC LIMIT 1)
                FROM ProcessInstance
                WHERE TargetObjectId IN: rejectedStatements.keySet()
                ORDER BY CreatedDate DESC limit 1])
             {
             //system.debug('$$$'+objProcessInstance.Steps);
             //system.debug('###'+objProcessInstance.Steps.size());
             
             if (objProcessInstance.Steps!=null && objProcessInstance.Steps.size()>0
              && (objProcessInstance.Steps[0].StepStatus=='Rejected' || objProcessInstance.Steps[0].StepStatus=='Removed' )
              &&((objProcessInstance.Steps[0].Comments == null || objProcessInstance.Steps[0].Comments.trim().length() == 0))) {
                   string strType='rejection';
                   if(objProcessInstance.Steps[0].StepStatus=='Removed'){
                      strType='recall';
                   }
                   if(objProcessInstance.Steps[0].StepStatus!='Removed'){
                      rejectedStatements.get(objProcessInstance.TargetObjectId).addError(
                       '<br><br><font size="3" color="red"> Please provide '+strType+' reason!</font>.<br><br> '+
                       'Click <a href="javascript:void(0);" onclick="window.history.back();">here </a>  to return to the previous page. ',false);
                    } else{
                        rejectedStatements.get(objProcessInstance.TargetObjectId).addError(' Please provide recall reason',false);
                    }
             
            }
        }
      }catch(Exception ex){}
    }
   
}