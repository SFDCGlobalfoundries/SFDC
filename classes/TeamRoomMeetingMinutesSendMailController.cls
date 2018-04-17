public class TeamRoomMeetingMinutesSendMailController 
{
    Team_Room_Meeting_Minutes__c mail = null;
    EmailTemplate emailTemp = null;
    
    public Team_Room_Meeting_Minutes__c getEmail()
    {
        if(mail == null)
        {
           String id = ApexPages.currentPage().getParameters().get('id');
           
           List<Team_Room_Meeting_Minutes__c> mmList = [SELECT id, name, Meeting_Date__c, Meeting_Type__c, Meeting_Notes__c, Meeting_Participants__c,
                                                         Team_Room__c, Team_Room__r.Name from Team_Room_Meeting_Minutes__c where id = :id LIMIT 1];
            
           if(mmList.size() > 0)
           {
               mail = mmList.get(0);
               mail.EmailSubject__c = mail.Meeting_Type__c + ' Minutes for ' + mail.Team_Room__r.Name + ' ';
               if(mail.Meeting_Date__c != null)
               {
                  String str = ' ' + mail.Meeting_Date__c;
                 mail.EmailSubject__c += str.substring(0,11);
               }
               String toAdd = '';
               List<Team_Room_Member__c> mlist = getTeamRoomMembers(mail.Team_Room__c);
               for(Team_Room_Member__c mbr:mlist)
               {
                   toAdd += mbr.User__r.Email + '\r\n';
               }
               
               mail.ToAdditional__c = toAdd;
           }
           
            
            
            EmailTemplate et = getEmailTemplate();
            if(et != null)
            {
                mail.HtmlBody__c = et.HtmlValue;
            }
        }
        return mail;
    }
    
    public EmailTemplate getEmailTemplate()
    {
       if(emailTemp == null)
       {
           List<EmailTemplate> etList = [SELECT Id,Name,HtmlValue from EmailTemplate where Name = 'Testing Template for Meeting Minutes'];
           if(etList.size() > 0)
           {
               emailTemp = etList.get(0);
           } 
       }
        return emailTemp;
    }
    
    public List<Team_Room_Member__c> getTeamRoomMembers(String trId)
    {
       List<Team_Room_Member__c> mlist = [SELECT User__r.Name, User__r.Email from Team_Room_Member__c where Team_Room__c = :trId ];
       return mlist;
    }
    
    public PageReference sendMail()
    {
    Team_Room_Meeting_Minutes__c mm = getEmail();
        if(mm.ToContact1__c == null)
        {
             ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.FATAL, 'Please select a Contact in the To box');
             ApexPages.addMessage(myMsg);
             return null;
        }
        
        
        
        update mm;
        List<String> toAddresses = new List<String>();
        String[] toAddSA = null;
        List<String> ccAddresses = new List<String>();
        List<String> bccAddresses = new List<String>();
        List<User> ulist = null;
        User u = null;
        if(mm.ToUser1__c != null)
        {
            ulist = [SELECT Id,Email from User where id = :mm.ToUser1__c];
            if(ulist.size() > 0)
            {
                u = ulist.get(0);
                toAddresses.add(u.Email);
            }
        }
        List<Contact> clist = null;
        Contact c = null;
        if(mm.ToContact1__c != null)
        {
            clist = [SELECT Id,Email from Contact where id = :mm.ToContact1__c];
            if(clist.size() > 0)
            {
                c = clist.get(0);
                toAddresses.add(c.Email);
            }
        }
        toAddSA = new String[toAddresses.size()];
        for(Integer i = 0; i < toAddresses.size(); ++i)
        {
            toAddSA[i] = toAddresses.get(i);
        }
        Messaging.reserveSingleEmailCapacity(2);
        
        Messaging.SingleEmailMessage msg = new Messaging.SingleEmailMessage();
        
        
        msg.setToAddresses(toAddSA);
        msg.setReplyTo('donotreply@globalfoundries.salesforce.com');
        msg.setSaveAsActivity(false);
        EmailTemplate et = getEmailTemplate();
        if(et != null)
        {
            msg.setTargetObjectId(c.Id);
            msg.setWhatId(mm.Id);
            msg.setTemplateId(et.Id);
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { msg });
        }else
        {
            msg.setSubject(mm.EmailSubject__c);
        }
        
        return new PageReference(URL.getSalesforceBaseUrl().toExternalForm() + '/' + mm.Id);
    }
    
   public PageReference cancel()
    {
        Team_Room_Meeting_Minutes__c mm = getEmail();
        return new PageReference(URL.getSalesforceBaseUrl().toExternalForm() + '/' + mm.Id);
    }
    
}