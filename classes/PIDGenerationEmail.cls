/*
Author:      Ariz Solito
Description: Apex class for generating the email for PID creation in PLM
History:
    Asolito        11252015    - Apex class created
    Karna Shiva    Spring III  - Added queue criteria to pick only queue members
*/
public class PIDGenerationEmail {

    public static void sendEmail(Apttus_Proposal__Proposal__c config){ 
    
        String configDetailID;
        for(Apttus_Proposal__Proposal_Line_Item__c line: [SELECT id
                                                             FROM Apttus_Proposal__Proposal_Line_Item__c
                                                             WHERE Apttus_Proposal__Proposal__c = :config.id
                                                             AND Apttus_QPConfig__ItemSequence__c = 1]){
                                                             
            configDetailID = line.id;
        }  
        
        //Manually configured, insert dummy line item        
        if(configDetailID == null){
            Apttus_Proposal__Proposal_Line_Item__c rec = new Apttus_Proposal__Proposal_Line_Item__c(
                Apttus_Proposal__Proposal__c = config.id,
                Apttus_QPConfig__ItemSequence__c = 1            
            ); 
                   
            try {
                insert rec;
                configDetailID = rec.id;
            } catch (Exception ex){
                throw ex;
            }
        }
                
        for(EmailTemplate e: [SELECT id,htmlValue 
                                FROM EmailTemplate 
                                WHERE developerName ='PID_Creation_Notification']){                                                
                                    
            List<String> userIDs = getUserEmails(config);  
            
            List<Messaging.SingleEmailMessage> sendEmails = new list<Messaging.SingleEmailMessage>();
            for(String u: userIDs){
                Messaging.SingleEmailMessage sendEmail = new Messaging.SingleEmailMessage();
                sendEmail.setTemplateID(e.id);  
                sendEmail.setTargetObjectID(u);
                sendEmail.setWhatID(configDetailID);  
                sendEmail.saveAsActivity = false;  
                sendEmails.add(sendEmail);              
            }                                                         
            
            try {
                Messaging.reserveSingleEmailCapacity(userIDs.size());   
                Messaging.sendEmail(sendEmails);   
 
            } catch (Exception ex){
                throw ex;
            }
        }                        
    }
    
    private static List<String> getUserEmails(Apttus_Proposal__Proposal__c config){
        List<String> approvers = new List<String>();
        
        for(Apttus_Proposal__Proposal__c c: [SELECT id,device__r.fab__c
                                               FROM Apttus_Proposal__Proposal__c
                                               WHERE id = :config.id]){
                                                                   
            String fab = c.device__r.fab__c;   
            
            if(UtilsString.isNotBlank(fab)){        
                String fabNo = fab.remove('FAB ');
                  
                approvers.addAll(getQueueUsers(new List<String>{'PI/YE Users Fab' + fabNo}));  
            }
        }
                                                          
        return approvers;     
    }
    
    
    //Method will get all of the users under a queue
    private static List<String> getQueueUsers(List<String> queueNames){
        String query = 'SELECT UserOrGroupid '+
                       '  FROM GroupMember '+
                       '  WHERE group.type=\'Queue\''+' and group.name IN :queueNames' ;                                                  
        // spring - III added code to pick only queue memebers 
        
        List<String> approvers = new List<String>();
        for(GroupMember g: database.query(query)){
            //get only users from the queue
            if(String.valueOf(g.UserOrGroupId).contains('005')){
                approvers.add(g.UserOrGroupId);
            }
        }
               
        return approvers;                                                      
    }            
}