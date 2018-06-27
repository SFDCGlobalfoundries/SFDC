trigger DeploymentRequestTrigger on Deployment_Request__c (after update, before update,after insert) {
    list<DR_Task__c> tasks = new list<DR_Task__c>();
    String strHTML ;
    Set<Id> chngUsId = new Set<Id>();
    List<EmailTemplate> et = [SELECT Id,HtmlValue,Subject FROM EmailTemplate WHERE DeveloperName = 'Deployment_Request_Email' AND isActive = TRUE];
    
    Map<Id,User> usrMap = new Map<Id,User>([SELECT Id,Name FROM User WHERE UserType = 'Standard']);
    List<GFSDR__DR_FeedMessage__mdt> fedMssgLst = new List<GFSDR__DR_FeedMessage__mdt>(); 
    
    list<DR_Configuration__c> drconfig = [Select Id, Name, Additional_Notes__c, Application_Category__c, Application_Name__c, ApproverSubmitter_Check__c, Change_Type__c, Deployment_Status__c, Is_Code_Review_Completed__c,
                                              Is_TA_Review_Completed__c, Is_TFA_Review_Completed__c, Request_Type__c, Review_Status__c, Risk_Start_Approver1__c, Risk_Start_Approver2__c, Risk_Start_Approver3__c,
                                              RMA_Approver1__c, RMA_Approver2__c, RMA_Approver3__c, Source_Environment__c, Stage__c, Standard_Apps_Approver1__c, Standard_Apps_Approver2__c, Standard_Apps_Approver3__c,
                                              Support_KT_Status__c, System_Affected__c, Target_Environment__c, Wafer_Write_Off_Approver1__c, Wafer_Write_Off_Approver2__c, Wafer_Write_Off_Approver3__c, Admin_Email__c
                                              From DR_Configuration__c limit 1];
                                              
    fedMssgLst = [select Label,GFSDR__FeedMessage__c from GFSDR__DR_FeedMessage__mdt where  Label='AdditionMssg' ];   

     // FeedItem feeditemVar ;
     FeedItem feeditemVar = new FeedItem();
     List<FeedItem > feedLst = new List<FeedItem >();
                                                    
    for(Deployment_Request__c dr: trigger.new){
         Deployment_Request__c oldDR ;
         feeditemVar = new FeedItem();
        if(trigger.isAfter && trigger.isUpdate){
        oldDR= trigger.oldMap.get(dr.Id);
    
        if(drconfig.size() > 0 && drconfig[0].ApproverSubmitter_Check__c){
            if((oldDR.Stage_txt__c!= dr.Stage_txt__c) && (dr.Stage_txt__c == 'Approved' || dr.Stage_txt__c == 'Rejected') && (dr.CreatedById == dr.LastModifiedById)){                
                // add error message to prevent update.
                dr.addError('Deployment Request creator cannot approve/reject the record.');
            }            
        }
        }
        
        if(trigger.isAfter && trigger.isUpdate){
            feeditemVar.parentid = dr.id;
             feeditemVar.Body = 'test';
             oldDR= trigger.oldMap.get(dr.Id);
             
             if(oldDR.GFSDR__User_1__c != dr.GFSDR__User_1__c){
                 chngUsId.add(dr.GFSDR__User_1__c);
             }
             
             if(oldDR.GFSDR__User_2__c != dr.GFSDR__User_2__c){
                 chngUsId.add(dr.GFSDR__User_2__c);
             }
             
             if(oldDR.GFSDR__User_3__c != dr.GFSDR__User_3__c){
                 chngUsId.add(dr.GFSDR__User_2__c);
             }
             
              if(oldDR.GFSDR__User_4__c != dr.GFSDR__User_4__c){
                 chngUsId.add(dr.GFSDR__User_4__c);
             }
             
            
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
                        
            Contact c = [select id, Email from Contact where email <> null limit 1];

            List<Messaging.SingleEmailMessage> lstMsgs = new List<Messaging.SingleEmailMessage>();
            
            Messaging.SingleEmailMessage msg = new Messaging.SingleEmailMessage();
            msg.setTemplateId( [select id from EmailTemplate where DeveloperName='Deployment_Request_Email_App'].id);
            msg.setWhatId( dr.id);
            msg.setTargetObjectId(c.id);
            msg.setToAddresses(new List<String>{'random_address@opfocus.com'});
            
            lstMsgs.add(msg);
            
            // Send the emails in a transaction, then roll it back
            Savepoint sp = Database.setSavepoint();
            Messaging.sendEmail(lstMsgs);
            Database.rollback(sp);
            
            List<Messaging.SingleEmailMessage> lstMsgsToSend = new List<Messaging.SingleEmailMessage>();
            for (Messaging.SingleEmailMessage email : lstMsgs) {
            Messaging.SingleEmailMessage emailToSend = new Messaging.SingleEmailMessage();
            Messaging.SingleEmailMessage emailToSend1 = new Messaging.SingleEmailMessage();
            Messaging.SingleEmailMessage emailToSend2 = new Messaging.SingleEmailMessage();
            Messaging.SingleEmailMessage emailToSend3 = new Messaging.SingleEmailMessage();
            
            if(dr.GFSDR__User_1__c != null) {    
                emailToSend.setTargetObjectId(dr.GFSDR__User_1__c);
                emailToSend.setPlainTextBody(email.getPlainTextBody());
                emailToSend.setHTMLBody(email.getHTMLBody());
                emailToSend.setSubject(email.getSubject());
                emailToSend.setSaveAsActivity(false);
                lstMsgsToSend.add(emailToSend);
            }
            
            if(dr.GFSDR__User_2__c != null) {    
                emailToSend1.setTargetObjectId(dr.GFSDR__User_2__c);
                emailToSend1.setPlainTextBody(email.getPlainTextBody());
                emailToSend1.setHTMLBody(email.getHTMLBody());
                emailToSend1.setSubject(email.getSubject());
                emailToSend1.setSaveAsActivity(false);
                lstMsgsToSend.add(emailToSend1);
            }
            
            if(dr.GFSDR__User_3__c != null) {    
                emailToSend2.setTargetObjectId(dr.GFSDR__User_3__c);
                emailToSend2.setPlainTextBody(email.getPlainTextBody());
                emailToSend2.setHTMLBody(email.getHTMLBody());
                emailToSend2.setSubject(email.getSubject());
                emailToSend2.setSaveAsActivity(false);
                lstMsgsToSend.add(emailToSend2);
            }
            
           if(dr.GFSDR__User_4__c != null) {    
                emailToSend3.setTargetObjectId(dr.GFSDR__User_4__c);
                emailToSend3.setPlainTextBody(email.getPlainTextBody());
                emailToSend3.setHTMLBody(email.getHTMLBody());
                emailToSend3.setSubject(email.getSubject());
                emailToSend3.setSaveAsActivity(false);
                lstMsgsToSend.add(emailToSend3);
            }          
            }
            Messaging.sendEmail(lstMsgsToSend);

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
            
            for(Id usid : chngUsId){
                
                 feeditemVar = new FeedItem();
                 feeditemVar.parentid = dr.id;
                 
                 feeditemVar.Body = usrMap.get(usid).name + ' ' +  fedMssgLst[0].GFSDR__FeedMessage__c;   
                 
                 feedLst.add(feeditemVar);                        
            }                 
        }          
        
        if(trigger.isAfter && trigger.isInsert){
           
            chngUsId = new set<id>();     
            strHTML = dr.name;
            EmailTemplate et = [SELECT Id FROM EmailTemplate WHERE DeveloperName ='Deployment_Request_Email'];  
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            mail.setToAddresses(new list<string>{'anushribhushan.sarwade@globalfoundries.com','ramprakash.rai@globalfoundries.com'});
            mail.setSubject('Deployment Request' + strHTML +' '+ 'has been updated');            
           // mail.setHtmlBody(strHTML);
            mail.setTemplateId(et.Id);
        //    Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });   
               // String   
            if(dr.GFSDR__User_1__c !=null)
            chngUsId.add(dr.GFSDR__User_1__c);
            if(dr.GFSDR__User_2__c !=null)
            chngUsId.add(dr.GFSDR__User_2__c);
            if(dr.GFSDR__User_3__c !=null)
            chngUsId.add(dr.GFSDR__User_3__c);
            if(dr.GFSDR__User_4__c !=null)
            chngUsId.add(dr.GFSDR__User_4__c);   
            
            system.debug('-chngUsId-'+chngUsId);
               
            for(Id usid : chngUsId){
                
                feeditemVar = new FeedItem();
                feeditemVar.parentid = dr.id;
                if(usrMap.containskey(usid))
                feeditemVar.Body = usrMap.get(usid).name + ' ' +  fedMssgLst[0].GFSDR__FeedMessage__c;   
                 feedLst.add(feeditemVar);                   
            }
            
            
            Contact c = [select id, Email from Contact where email <> null limit 1];

            List<Messaging.SingleEmailMessage> lstMsgs = new List<Messaging.SingleEmailMessage>();
            
            Messaging.SingleEmailMessage msg = new Messaging.SingleEmailMessage();
            msg.setTemplateId( [select id from EmailTemplate where DeveloperName='Deployment_Request_Email_App'].id);
            msg.setWhatId( dr.id);
            msg.setTargetObjectId(c.id);
            msg.setToAddresses(new List<String>{'random_address@opfocus.com'});
            
            lstMsgs.add(msg);
            
            // Send the emails in a transaction, then roll it back
            Savepoint sp = Database.setSavepoint();
            Messaging.sendEmail(lstMsgs);
            Database.rollback(sp);
            
            List<Messaging.SingleEmailMessage> lstMsgsToSend = new List<Messaging.SingleEmailMessage>();
            for (Messaging.SingleEmailMessage email : lstMsgs) {
            Messaging.SingleEmailMessage emailToSend = new Messaging.SingleEmailMessage();
            Messaging.SingleEmailMessage emailToSend1 = new Messaging.SingleEmailMessage();
            Messaging.SingleEmailMessage emailToSend2 = new Messaging.SingleEmailMessage();
            Messaging.SingleEmailMessage emailToSend3 = new Messaging.SingleEmailMessage();
            
            if(dr.GFSDR__User_1__c != null) {    
                emailToSend.setTargetObjectId(dr.GFSDR__User_1__c);
                emailToSend.setPlainTextBody(email.getPlainTextBody());
                emailToSend.setHTMLBody(email.getHTMLBody());
                emailToSend.setSubject(email.getSubject());
                emailToSend.setSaveAsActivity(false);
                lstMsgsToSend.add(emailToSend);
            }
            
            if(dr.GFSDR__User_2__c != null) {    
                emailToSend1.setTargetObjectId(dr.GFSDR__User_2__c);
                emailToSend1.setPlainTextBody(email.getPlainTextBody());
                emailToSend1.setHTMLBody(email.getHTMLBody());
                emailToSend1.setSubject(email.getSubject());
                emailToSend1.setSaveAsActivity(false);
                lstMsgsToSend.add(emailToSend1);
            }
            
            if(dr.GFSDR__User_3__c != null) {    
                emailToSend2.setTargetObjectId(dr.GFSDR__User_3__c);
                emailToSend2.setPlainTextBody(email.getPlainTextBody());
                emailToSend2.setHTMLBody(email.getHTMLBody());
                emailToSend2.setSubject(email.getSubject());
                emailToSend2.setSaveAsActivity(false);
                lstMsgsToSend.add(emailToSend2);
            }
            
           if(dr.GFSDR__User_4__c != null) {    
                emailToSend3.setTargetObjectId(dr.GFSDR__User_4__c);
                emailToSend3.setPlainTextBody(email.getPlainTextBody());
                emailToSend3.setHTMLBody(email.getHTMLBody());
                emailToSend3.setSubject(email.getSubject());
                emailToSend3.setSaveAsActivity(false);
                lstMsgsToSend.add(emailToSend3);
            }          
            }
            Messaging.sendEmail(lstMsgsToSend);
            
            
        }                  
    }    
    if(tasks.size() > 0) insert tasks;
    if(feedLst.size() > 0) insert feedLst;
    
   
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