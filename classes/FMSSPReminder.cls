/*
 @class: FMSSPReminder 
 @CreatedBy: Ram Rai
 @CreatedDate: 11 Jul, 2017
 @Description: Batch class to be scheduled every day to send reminder emails to reviewers
 
  Change History:
    DATE            NAME                    Comments
    2-Aug-2017     Ram Rai                 Fixed the issue for email Reminders.
*/
 
public class FMSSPReminder implements Database.Batchable<sObject> {

    public Database.querylocator start(Database.BatchableContext BC){
        datetime myDateTime = datetime.now().addHours(-24);
        String query = '';
        // Added the logic in query for email Reminders.
        if(!Test.isRunningTest()){
            query = 'select Customer__c,Parent_Form_Id__c,Parent_Form_Id__r.Name,Customer_Name__r.Name,SelAppId__c,Customer_Name__c,Name__c,isBlank__c,CreatedBy.Name,LastModifiedBy.Name,CreatedBy.Email,LastModifiedBy.Email,CreatedDate,LastModifiedDate,Form_Name__c,Name,Form_Description__c,State_of_the_Form__c,Form_Type__c,ID,Days_left_for_deletion__c from Form_Management_System__c where  (Parent_Form_Id__c = null and Form_Type__c = \'Step Plan Approval (SP)\' and ((Latest_Step_Plan__c != null and Latest_Step_Plan__r.State_of_the_Form__c = \'WaitingForReview\') OR (Latest_Step_Plan__c = null and State_of_the_Form__c = \'WaitingForReview\')) and createddate < =:myDateTime )';  
        }else{
            query = 'select Customer__c,Parent_Form_Id__c,Parent_Form_Id__r.Name,Customer_Name__r.Name,SelAppId__c,Customer_Name__c,Name__c,isBlank__c,CreatedBy.Name,LastModifiedBy.Name,CreatedBy.Email,LastModifiedBy.Email,CreatedDate,LastModifiedDate,Form_Name__c,Name,Form_Description__c,State_of_the_Form__c,Form_Type__c,ID,Days_left_for_deletion__c from Form_Management_System__c where  (Parent_Form_Id__c = null and Form_Type__c = \'Step Plan Approval (SP)\' and State_of_the_Form__c = \'WaitingForReview\')'; 
        }
        return Database.getQueryLocator(query);
    } 
    
    public void execute(Database.BatchableContext BC, List<Form_Management_System__c> listOfFMS){
        String str1; 
        Map<String,List<String>> fmIdMap = new Map<String,List<String>>();  
        Set<String>   fmsId = new Set<String>();  
        Set<String>   usrId = new Set<String>();
         
        Messaging.SingleEmailMessage[] messages = new Messaging.SingleEmailMessage[]{};
        for(Form_Management_System__c fms: listOfFMS){                       
            str1 = fms.SelAppId__c ;                
            if(str1 !=null){
                for(String key : str1.split(';')){
                    fmsId.add(key);
                    if(fmIdMap.containsKey(fms.name)){
                        fmIdMap.get(fms.name).add(key);    
                    }else{
                        fmIdMap.put(fms.name,new List<String>{key});     
                    }       
                }
            }       
        }

        for(User usr : [select id from user where id in :fmsId and isActive = true]){          
            usrId.add(usr.id);    
        }      

        if(!fmIdMap.isEmpty()){    
            for(Form_Management_System__c fms: listOfFMS){              
                if(fmIdMap.containsKey(fms.name)){
                    Set<String> fmsUserIds = new Set<String>();
                    for(String userId : fmIdMap.get(fms.name)){
                        if(usrId.contains(userId)){
                            fmsUserIds.add(userId);    
                        }                        
                    }
                    if(fmsUserIds.size()>0){
                        messages.add(FMSEmailTemplates.createTemplate(fms,null,Label.Form_Old_Warning_Email,fmsUserIds));
                    }
                }                  
            }        
        
            if(!messages.isEmpty()){
                Messaging.SendEmailResult[] results = Messaging.sendEmail(messages, false); 
                for (Messaging.SendEmailResult res: results){
                    if(!res.success){
                        System.debug('The email failed to be sent: ' + res.errors[0].message);
                    }    
                }
            }
       
       } 
       
    }
      
    public void finish(Database.BatchableContext BC){
         
    }
}