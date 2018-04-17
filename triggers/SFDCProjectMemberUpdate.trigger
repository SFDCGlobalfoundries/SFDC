trigger SFDCProjectMemberUpdate on SFDC_Project_Member__c (after insert, after update) {
    
   Messaging.reserveSingleEmailCapacity(2);
   Map<String,SFDC_Project__c> portfolioMap = new Map<String,SFDC_Project__c>();
   SFDC_Project__c portfolio = null;
   String toEmail = null;
   List<SFDC_Project__c> portfolios = null;
   Map<String,String> toAddresses = new Map<String,String>();
   List<User>toUsers = null;
   List<String> toIds = null;
   List<SFDC_Project_Member__c> projectManagers = null;
   Messaging.SingleEmailMessage[] allEmails = new List<Messaging.SingleEmailMessage>();
   
   toIds = new List<String>();
   for(SFDC_Project_Member__c member: Trigger.new)
   {
        
        toIds.add(member.User__c);
        
        //LOOKUP PARENT PORTFOLIO TO SEE IF WE'VE RETRIEVED IT YET
        portfolio = portfolioMap.get(member.SFDC_Project__c);
        if(portfolio == null)
        {
            portfolios = [select id, Name from SFDC_Project__c where id = :member.SFDC_Project__c];
            if(portfolios.size() > 0)
            {
               //CACHE FOR LATER
               portfolioMap.put(member.SFDC_Project__c,portfolios.get(0));
            }
        }
   }
   
   //QUERY ALL THE EMAIL ADDRESSES NEEDED
   toUsers = [select id, Email from User where id in :toIds]; 
   for(User u:toUsers)
   {
       toAddresses.put(u.id,u.Email);
   }
   
   
          
   
   for(SFDC_Project_Member__c member: Trigger.new)
   {
       portfolio = portfolioMap.get(member.SFDC_Project__c);
       if(portfolio == null)
       {
           continue;
       }
       toEmail = toAddresses.get(member.User__c);
       if(toEmail == null)
       {
           continue;
       }
       
       
       Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
       mail.setToAddresses(new String[]{toEmail});
       mail.setReplyTo('noreply@globalfoundries.com');
       mail.setSenderDisplayName('Globalfoundries Salesforce Support');
       if(Trigger.IsInsert)
       {
           mail.setSubject('Added to Project : ' + portfolio.Name); 
           mail.setPlainTextBody('You have been added to Project: ' + portfolio.Name + ' under the role of ' + member.Role__c + '. To view project go to ' +  URL.getSalesforceBaseUrl().toExternalForm() + '/' + portfolio.Id);
           mail.setHtmlBody('You have been added to Project: <b> ' + portfolio.Name + ' </b>under the role of ' + member.Role__c + '.<p>'+
       'To view project <a href=' + URL.getSalesforceBaseUrl().toExternalForm() +'/' + portfolio.Id+'>click here.</a>');
       
           mail.setBccSender(false);
           mail.setUseSignature(false);
           allEmails.add(mail);
       }
       
       
   
   }
   
   Messaging.sendEmail(allEmails);
   

}