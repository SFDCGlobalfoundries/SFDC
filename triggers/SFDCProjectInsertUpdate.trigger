trigger SFDCProjectInsertUpdate on SFDC_Project__c (after insert, after update) {

System.debug('win: triggering SFDCProjectInsertUpdate.');
    
   Messaging.reserveSingleEmailCapacity(2);
   Map<String,List<String>> toMap = new Map<String,List<String>>();
   List<String> toAddresses = new List<String>();
   List<User>toUsers = null;
   List<String> toIds = null;
   List<SFDC_Project_Member__c> projectManagers = null;
   for(SFDC_Project__c sproj: Trigger.new)
   {
        projectManagers = [select User__c from SFDC_Project_Member__c where SFDC_Project__c = :sproj.id and Role__c = 'IT Project Manager'];
        System.debug('win: projectManagers='+projectManagers);
        toIds = new List<String>();
        for(SFDC_Project_Member__c pm:projectManagers)
        {
           toIds.add(pm.User__c);
        }      
      
        toMap.put(sproj.id,toIds);
   }
   
   
   for(SFDC_Project__c sproj: Trigger.new)
   {
       toAddresses.clear();
       toIds = toMap.get(sproj.id);
       if(toIds.size() == 0)
       {
           continue;
       }
       toUsers = [select User.Email from User where id in :toIds];  
       for(User u:toUsers)
       {
          toAddresses.add(u.Email);
       }
       if(toAddresses.size() == 0)
       {
           continue;
       }
       Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
       mail.setToAddresses(toAddresses);
       mail.setReplyTo('noreply@globalfoundries.com');
       mail.setSenderDisplayName('Globalfoundries Salesforce Support');
       if(Trigger.IsInsert)
       {
           mail.setSubject('Project Created : ' + sproj.Name); 
           mail.setPlainTextBody('Project: ' + sproj.Name +' was just created.');
           mail.setHtmlBody('Project:<b> ' + sproj.Name +' </b>was just created.<p>'+
       'To view project <a href=' + URL.getSalesforceBaseUrl().toExternalForm() +'/' + sproj.Id+'>click here.</a>');
       }else
       {
          mail.setSubject('Project Modified : ' + sproj.Name); 
          mail.setPlainTextBody('Project: ' + sproj.Name +' has been modified.');
          mail.setHtmlBody('Project:<b> ' + sproj.Name +' </b>has been modified.<p>'+
       'To view project <a href='+ URL.getSalesforceBaseUrl().toExternalForm() +'/' + sproj.Id+'>click here.</a>');
       }
       mail.setBccSender(false);
       mail.setUseSignature(false);
       
       //Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
   }

}