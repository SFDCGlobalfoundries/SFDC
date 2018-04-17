/*    **
* Author       :   Nikhil Jain
* Company      :   Cognizant Technologies PTE Ltd.
* Description  :   Helper class for STM Task Child Trigger                  
* History      :

        Initials     Date              Description
-----------------------------------------------------------------------------------------
        NJain        11/07/2014        Created the Trigger Helper Class
**/

public class STM_TRIGGER_HELPER_TaskChild{
    
    public static Map<Id,User> mapUserIds = new Map<Id,User>();        
    
    public static void STMTaskChild_AfterInsert(List<STMTaskChild__c> lstSTMTaskChild){
        
        List<STMTask__c> lstSTMTasks = new List<STMTask__c>();
        Set<Id> lstEscalationUsers = new Set<Id>();    
                
        for(STMTaskChild__c stmChild: lstSTMTaskChild){
            lstEscalationUsers.add(stmChild.Alert_Reminder_User1__c);
            lstEscalationUsers.add(stmChild.Alert_Reminder_User2__c);
            lstEscalationUsers.add(stmChild.Alert_Reminder_User3__c);
            lstEscalationUsers.add(stmChild.Assignee_Esc_1__c);
            lstEscalationUsers.add(stmChild.Assignee_Esc_2__c);
            lstEscalationUsers.add(stmChild.Assignee_Esc_3__c);
            lstEscalationUsers.add(stmChild.Assignee_Esc_4__c);
            lstEscalationUsers.add(stmChild.Assignee_Esc_5__c);
            lstEscalationUsers.add(stmChild.Supervisor_Esc_1__c);
            lstEscalationUsers.add(stmChild.Supervisor_Esc_2__c);
            lstEscalationUsers.add(stmChild.Supervisor_Esc_3__c);
            lstEscalationUsers.add(stmChild.Supervisor_Esc_4__c);
            lstEscalationUsers.add(stmChild.Supervisor_Esc_5__c);
            lstEscalationUsers.add(stmChild.QA_Esc_1__c);
            lstEscalationUsers.add(stmChild.QA_Esc_2__c);
            lstEscalationUsers.add(stmChild.QA_Esc_3__c);
            lstEscalationUsers.add(stmChild.QA_Esc_4__c);
            lstEscalationUsers.add(stmChild.QA_Esc_5__c);
            lstEscalationUsers.add(stmChild.CE_Esc_1__c);
            lstEscalationUsers.add(stmChild.CE_Esc_2__c);
            lstEscalationUsers.add(stmChild.CE_Esc_3__c);
            lstEscalationUsers.add(stmChild.CE_Esc_4__c);
            lstEscalationUsers.add(stmChild.CE_Esc_5__c);
        }
            
        mapUserIds = new Map<Id,User>([select id,Email from User where id in :lstEscalationUsers]);
        
        for(STMTaskChild__c stmChild: lstSTMTaskChild){
            STMTask__c stmTask = new STMTask__c(id=stmChild.STMTask__c);
            stmTask.Alert_Reminder_User1_Email__c = getEmailId(stmChild.Alert_Reminder_User1__c);
            stmTask.Alert_Reminder_User2_Email__c = getEmailId(stmChild.Alert_Reminder_User2__c);
            stmTask.Alert_Reminder_User3_Email__c = getEmailId(stmChild.Alert_Reminder_User3__c);
            stmTask.Assignee_Esc1_Email__c = getEmailId(stmChild.Assignee_Esc_1__c);
            stmTask.Assignee_Esc2_Email__c = getEmailId(stmChild.Assignee_Esc_2__c);
            stmTask.Assignee_Esc3_Email__c = getEmailId(stmChild.Assignee_Esc_3__c);
            stmTask.Assignee_Esc4_Email__c = getEmailId(stmChild.Assignee_Esc_4__c);
            stmTask.Assignee_Esc5_Email__c = getEmailId(stmChild.Assignee_Esc_5__c);
            stmTask.Supervisor_Esc1_Email__c = getEmailId(stmChild.Supervisor_Esc_1__c);
            stmTask.Supervisor_Esc2_Email__c = getEmailId(stmChild.Supervisor_Esc_2__c);
            stmTask.Supervisor_Esc3_Email__c = getEmailId(stmChild.Supervisor_Esc_3__c);
            stmTask.Supervisor_Esc4_Email__c = getEmailId(stmChild.Supervisor_Esc_4__c);
            stmTask.Supervisor_Esc5_Email__c = getEmailId(stmChild.Supervisor_Esc_5__c);
            stmTask.QA_Esc1_Email__c = getEmailId(stmChild.QA_Esc_1__c);
            stmTask.QA_Esc2_Email__c = getEmailId(stmChild.QA_Esc_2__c);
            stmTask.QA_Esc3_Email__c = getEmailId(stmChild.QA_Esc_3__c);
            stmTask.QA_Esc4_Email__c = getEmailId(stmChild.QA_Esc_4__c);
            stmTask.QA_Esc5_Email__c = getEmailId(stmChild.QA_Esc_5__c);
            stmTask.CE_Esc1_Email__c = getEmailId(stmChild.CE_Esc_1__c);
            stmTask.CE_Esc2_Email__c = getEmailId(stmChild.CE_Esc_2__c);
            stmTask.CE_Esc3_Email__c = getEmailId(stmChild.CE_Esc_3__c);
            stmTask.CE_Esc4_Email__c = getEmailId(stmChild.CE_Esc_4__c);
            stmTask.CE_Esc5_Email__c = getEmailId(stmChild.CE_Esc_5__c);
            lstSTMTasks.add(stmTask);
        }
        if(!lstSTMTasks.isEmpty()){
            update lstSTMTasks;
        }
    }
    
    public static string getEmailId(String UserId){
        if(UserId != NULL && mapUserIds.get(UserId) != NULL){
            return mapUserIds.get(UserId).Email;
        }else{
            return '';
        }
    }
    
}