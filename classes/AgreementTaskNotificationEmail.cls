/* Suvajit:- Code creation. This class receives Tasks records from the CLMAgreementTaskNotificationBatch Batch and processes them to send reminder email 1 day prior to task reminder date

*/

public without sharing class AgreementTaskNotificationEmail
{

    public static void AgreementAssigneeIdMapProcessor(Map<Id,Task> TaskMap)
    {
    
    final string APTS_AGREEMENT_C_OBJECT= EnvironmentVariable.get('APTS_AGREEMENT__C_OBJECT');
     
     
     //Code to prevent mail trigger if any other field except reminder date is changed 
     
     List<ID> ToExempt=new List<ID>();
     
    
    
 
 
    /* Get the Task for the WhatId as Apttus__APTS_Agreement__c and schedule an email notification to specific recipients one day prior to the reminder date set on task.
        */
        //***************************************************************************//
        Map<id,List<String>> AgreementAssigneeIdMap = new Map<id,List<String>>();
       
        List<String> emailIds;
        
        List<ID> AgreementList=new List<ID>();
        
        for(Task t:[select id, whatid from Task where id  in :TaskMap.keyset() and id not in :ToExempt])
            AgreementList.add(t.whatid);
                        
        List<Apttus__APTS_Agreement__c> Li=[select id from Apttus__APTS_Agreement__c where RecordType.DeveloperName in 
                        ('Finance_Treasury_Agreements',        
                        'IP_EDA_Agreements',
                        'Legal_Agreements',
                        'Procurement_Agreements',
                        'Sales_Agreements',
                        'TD_Agreements') and id in : AgreementList];  
                        
         
         
        AgreementList.clear();
                            
        for(Apttus__APTS_Agreement__c agr: Li)
            AgreementList.add(agr.id);    
            
                        
        
        
                        
        for(Task tsk : [select    id
                                  , WhoId
                                  , WhatId
                                  , What.Type
                                  , Subject
                                  , Status
                                  , Description
                                  , CLM_Email_Addresses__c
                                  , OwnerId
                                  , ActivityDate
                                  ,Priority
                                  ,Owner.Email
                                  ,Who.Email
                                  
                        from      Task
                        where     id in :TaskMap.keyset() and whatid in :AgreementList])
        {
        
            emailIds = new List<String>();
            if(tsk.WhatId != null && tsk.What.Type == APTS_AGREEMENT_C_OBJECT  )
            {
                
                if(tsk.Owner.Email<>NULL)emailIds.add(tsk.Owner.Email);
                if(tsk.Who.Email<>NULL)  emailIds.add(tsk.Who.Email);
                //code below parses the Email Addresses field(visible only to users having the permission set to provide access to this field) for additional email addresses
                if(tsk.CLM_Email_Addresses__c<>NULL)
                {
                
                Pattern p = Pattern.compile('(?:[a-z0-9!#$%&\'*+/=?^_`{|}~-]+(?:\\.[a-z0-9!#$%&\'*+/=?^_`{|}~-]+)*|\"(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21\\x23-\\x5b\\x5d-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])*\")@(?:(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\\[(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?|[a-z0-9-]*[a-z0-9]:(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21-\\x5a\\x53-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])+)\\])' );
                Matcher matcher=p.matcher(tsk.CLM_Email_Addresses__c);
                
                while(matcher.find())
                    { 
                    emailIds.add(matcher.group());
                    
                    }
                    
                matcher.reset();    
                   
                }
            
        AgreementAssigneeIdMap.put(tsk.id,emailIds);
           
            }
        }
        if(!AgreementAssigneeIdMap.isEmpty())
        {
            
            System.debug('AgreementAssigneeIdMap ==> '+AgreementAssigneeIdMap);
            sendEmailOnTask(AgreementAssigneeIdMap);
        }
      
      
 
 



}
    
    public static void sendEmailOnTask(Map<id,List<String>> AgreementAssigneeIdMap){
        
        List<Messaging.SingleEmailMessage> msgs = new List<Messaging.SingleEmailMessage>();
        
        List<String> userIds = new List<String>();
        List<String> userEmailIds = new List<String>();   
        List<Task> auditTask=new List<Task>();    
        List<Task> processedTask=new List<Task>();  
        Task AuditT=new Task();
        
        
        
        
        // Get the email template
        EmailTemplate emailTemp = [ SELECT      id 
                                    FROM        EmailTemplate 
                                    WHERE       name = :EnvironmentVariable.get('MAIL_TEMPLATE_ON_AGREEMENT_TASK')
                                  ];        
                                        
        
        
        
        Map<String,String> MergeFields=new Map<String,String>();
        
        List<Task> t_task=[Select id,Subject,OwnerId,What.Name,ActivityDate,Priority,Description,Owner.Email,Owner.Name from Task where id in :AgreementAssigneeIdMap.keySet()];
        
        // Iterate through the  Assignee list to create the email message
        for(Task t : t_task)
        {
                    MergeFields.clear();                     
                    if(AgreementAssigneeIdMap.get(t.id).size()>0)
                    Messaging.reserveSingleEmailCapacity(AgreementAssigneeIdMap.get(t.id).size());
                
                
                    //using placeholders to replace with task field values. Limitation of SFDC
                    
                    
                    if(t.Owner.Name<>NULL)      
                    MergeFields.put('{0}',t.Owner.Name); 
                    else MergeFields.put('{0}','  ');
                    
                    
                    if(t.Subject<>NULL)      
                    MergeFields.put('{1}',t.Subject); 
                    else MergeFields.put('{1}','  ');
                    
                    if(t.ActivityDate<>NULL)    
                    MergeFields.put('{2}',String.valueOf(t.ActivityDate));
                    else MergeFields.put('{2}','  ');
                    
                    
                    if(t.Priority<>NULL)        
                    MergeFields.put('{3}',t.Priority);
                    else MergeFields.put('{3}','  ');
                    
                    if(t.Description<>NULL)     
                    MergeFields.put('{4}',t.Description);
                    else MergeFields.put('{4}','  ');
                    
                    
                    
                    MergeFields.put('{!Apttus__APTS_Agreement__c.Name}' , t.What.Name);  

                    
                    MergeFields.put('{!Apttus__APTS_Agreement__c.OwnerEmail}',t.Owner.Email); 
                    
                    
                    
                    Messaging.SingleEmailMessage msg = EmailUtil.generateEmailTemplate(emailTemp.id,
                                                                                       t.whatid,
                                                                                       'Agreement TASK Reminder Notice',
                                                                                       AgreementAssigneeIdMap.get(t.id),
                                                                                       null,
                                                                                       MergeFields);
                                                                         
                                                                                         
                                                                                       
                try
                {
                      
                    if(msg != null)
                        {
                        msg.setSenderDisplayName('CLMAdmin@globalfoundries.com'); 
                        msgs.add(msg); 
                        AuditT=new Task(OwnerId=t.OwnerId,Subject=t.Subject+'-Reminder Sent-'+String.valueOf(DateTime.now()),ActivityDate=t.ActivityDate,WhatId=t.WhatId,Status='Completed',Priority='Low');
                        auditTask.add(AuditT);
                        t.IsProcessedByCLMBatch__c=True;
                        processedTask.add(t);
                        }                                                                                                                            
                       
                } catch (Exception e) 
                {
                    String CLM_ADMIN_MAIL_BATCH_NOTIFICATION = String.valueOf(EnvironmentVariable.get('CLM_ADMIN_MAIL_BATCH_NOTIFICATION'));  
                    String AdminMail= CLM_ADMIN_MAIL_BATCH_NOTIFICATION;
                    Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                    mail.setToAddresses(new String[] {AdminMail});
                    mail.setReplyTo(CLM_ADMIN_MAIL_BATCH_NOTIFICATION);
                    mail.setSenderDisplayName('CLM Mail Processing Class Exception');
                    mail.setSubject('Mail Processing Class');
                    mail.setPlainTextBody('The mail processing encountered following exception:-'+e.getMessage());
                    Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
                }        
        } 
        
        
        // Send the email
        if(msgs.size() > 0)
            if (!Test.isRunningTest()) 
                Messaging.sendEmail(msgs);
              
     insert auditTask; 
     update processedTask;  
        
    }
    
    

}