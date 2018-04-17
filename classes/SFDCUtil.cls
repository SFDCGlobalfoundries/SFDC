public class SFDCUtil
{

   public static SFDC_Project_Stage__c findCurrentStage(String projectId)
   {   
        System.debug('win: Entering findCurrentStage.');
        List<SFDC_Project_Stage__c> mlist = new List<SFDC_Project_Stage__c>();
        Map<String,SFDC_Project_Stage__c> smap = new Map<String,SFDC_Project_Stage__c>();
        List<SFDC_Project_Stage__c> slist = [SELECT id, Name,Name__c,SFDC_Project__c,Start_Date__c, End_Date__c,Completed__c,Skip__c,Skip_Justification__c 
                                             from SFDC_Project_Stage__c where SFDC_Project__c = :projectId];
        for(SFDC_Project_Stage__c stg:slist)
        {
            smap.put(stg.Name__c,stg);
        }
        SFDC_Project_Stage__c pstg = null;
        Schema.DescribeFieldResult f = Schema.SObjectType.SFDC_Project_Stage__c.fields.Name__c;
        List <Schema.PicklistEntry> plentries = f.getPicklistValues();
        for(Schema.PicklistEntry ple:plentries)
        {
             pstg = smap.get(ple.getValue());
             if(pstg != null)
             {
                 System.debug('win: pstg ='+pstg);
                 mlist.add(pstg);
             }
        }
        System.debug('win: mlist='+mlist);
        if(mlist == null || mlist.size() == 0){
            System.debug('win: mlist is zero.');
            return null;
        }
        
        SFDC_Project_Stage__c stage = null;
        SFDC_Project_Stage__c currentStage = null;
        
       
        
        for(Integer i = 0; i < mlist.size(); ++i)
        {
           stage = mlist.get(i);
           if((stage.Completed__c)||(stage.Skip__c))
           {
              //CHECK IF ON LAST ONE
              if(i == mlist.size()-1)
              {
                 return stage;
              }
              continue;  
           }else
           {
             return stage;
             
           }
        }

        return null;

      }
      

     public static SFDC_Project_Milestone__c findCurrentMilestone(String stageId)
     {
        SFDC_Project_Milestone__c milestone = null;
              
        List<SFDC_Project_Milestone__c> milestones = [select id, Name, Start_Date__c, Completed__c from SFDC_Project_Milestone__c where Stage__c = :stageId order by Start_Date__c];
        
         
         for(Integer k = 0; k < milestones.size(); ++k)
         {
             milestone = milestones.get(k);
             if(milestone.Completed__c)
             {
                     continue;
             }else
             {
                   return milestone;
             }
         }
              
         return milestone;
     }
     
     public static void notifyProjectStakeHolders(String projectId, String[] roles, String subject, String plainText, String htmlText)
     {
     
          Messaging.reserveSingleEmailCapacity(2);
          List<String> toAddresses = new List<String>();
          List<User>toUsers = null;
          List<String> toIds = null;
          List<SFDC_Project_Member__c> stakeHolders = null;
          List<SFDC_Project__c> plist = [Select id from SFDC_Project__c where id = :projectId];
          SFDC_Project__c sproj = null;
          String soql = 'select User__c from SFDC_Project_Member__c where SFDC_Project__c =\'' + projectId;
          if(plist.size() != 1)
          {
              return;
          }
          sproj = plist.get(0);
          
          soql += '\' and Role__c in (';
          for(Integer i = 0; i < roles.size(); ++i)
          {
              soql += '\'';
              soql += roles[i];
              soql += '\'';
              if(i + 1 < roles.size())
              {
                 soql += ',';
              }
          }
          soql += ')';

          toIds = new List<String>();
          
          
          
          stakeHolders = (List<SFDC_Project_Member__c>)Database.query(soql);
          
          for(SFDC_Project_Member__c sh:stakeHolders)
          {
              toIds.add(sh.User__c);
          }      
             
          toUsers = [select User.Email from User where id in :toIds];  
          for(User u:toUsers)
          {
            toAddresses.add(u.Email);
          }
          if(toAddresses.size() == 0)
          {
           return;
          }
          Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
          mail.setToAddresses(toAddresses);
          mail.setReplyTo('noreply@globalfoundries.com');
          mail.setSenderDisplayName('Globalfoundries Salesforce Support');
          mail.setSubject(subject); 
          mail.setPlainTextBody(plainText);
          mail.setHtmlBody(htmlText);
          mail.setBccSender(false);
          mail.setUseSignature(false);
       
          Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
         
     
     }

      
}