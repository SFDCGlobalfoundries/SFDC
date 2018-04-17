/*------------------------------------------------------------  
Author:        Sameera
Company:       CTS
Description:   A Batch class to send email to all contacts
History
<Date>      <Authors Name>     <Brief Description of Change>
------------------------------------------------------------*/
global  class FV_BatchASICNewsAlert implements  Database.Batchable<sObject>,Database.Stateful{
  
  global string query='';
  global string sendEmailIds ='Emails sent to (';
  global string failureError ='';
  global Id setOrgWideEmailAddress;
  global string dateTimeFormat = DateTime.now().format('yyyy-MM-dd\'T\'hh:mm:ss\'Z\'');
  global boolean hasFailure = false;
  global boolean hasMails = false;
  global string processedASICrecords ='Processed records for ASIC News & Alert: '; 
  global map <id,set<id>> MasterIdAccountIdsetmap;
  global map <id,list<Contact>> AccountIdContactmap;
  global map <Id,list<string>> asicIdContactEmailsmap;
  @TestVisible
  public boolean TestVaraible = false;
  
  global Database.QueryLocator start(Database.BatchableContext BC)
  {       
    Id thisJobId = bc.getJobId();
    AsyncApexJob[] jobs = [SELECT ID 
                           FROM AsyncApexJob 
                           WHERE id!=:thisJobId 
                               AND status='Processing' 
                               AND ApexClass.Name ='FV_BatchASICNewsAlert' 
                               AND JobType='BatchApex'
                          ];
    if (jobs.isEmpty() ) {
         query = 'SELECT Id,Name,Master_PDK__c,Is_notification_completed__c,Title__c,Email_notification_status__c,Type__c from ASIC_News_Alert__c where Active__c=true AND Is_notification_completed__c=FALSE AND Master_PDK__c!=null AND Published_on__c <=' + dateTimeFormat; 
         return Database.getQueryLocator(query);        
    }
    else {
        system.abortJob(thisJobId);
        return null;
    }
  }
 
   global void execute(Database.BatchableContext BC, list<sObject> records)
   {
      set<Id> MasterPDKIds = new set<Id>();
      set<ID> AccountIdset = new set<ID>();
      map <id,id> AsicIdMasterId =new map <id,id>();
      map <Id,ASIC_News_Alert__c> asicObjectmap = new map <Id,ASIC_News_Alert__c>();
      list<Document_Provisioning__c> dplist = new list<Document_Provisioning__c>();
      list<Contact> conlist = new list<Contact>();
      map<string,ID> conEmailmap = new map<string,ID>();
      map<ID,ID> userContactmap = new map<ID,ID>();      
      string ASICUrl = Label.ASIC_News_Alert_URL;
         
      for(ASIC_News_Alert__c item: (list<ASIC_News_Alert__c>)records){
            AsicIdMasterId.put(item.Id,item.Master_PDK__c);
            MasterPDKIds.add(item.Master_PDK__c); 
            asicObjectmap.put(item.Id,item);    
       } 
      MasterIdAccountIdsetmap =new map <id,set<id>>(); 
     // get all the DP records
      dplist = [SELECT ID,
                       Status__c,
                       Sub_PDK__c,
                       DP_ASIC_Business__c,
                       AccountID__c,
                       Sub_PDK__r.PDK__c 
                FROM  Document_Provisioning__c 
                WHERE Status__c='Provisioned' 
                      AND DP_ASIC_Business__c=TRUE 
                      AND Sub_PDK__c!=null 
                      AND AccountID__c!=null 
                      AND Sub_PDK__r.PDK__c IN:MasterPDKIds
               ];
     if(!dplist.isEmpty()){                                            
     // get all the accounts related to DPs
      for(Document_Provisioning__c dp:dplist){
            AccountIdset.add(dp.AccountID__c);
            if(MasterIdAccountIdsetmap.get(dp.Sub_PDK__r.PDK__c) == null){
                MasterIdAccountIdsetmap.put(dp.Sub_PDK__r.PDK__c,new set<id>()); 
            }
            MasterIdAccountIdsetmap.get(dp.Sub_PDK__r.PDK__c).add(dp.AccountID__c);    
      }
      
      // get all contacts list which are provisioend to and portal user is active
      if(!AccountIdset.isEmpty()){ 
          set<ID> conIDs = new set<ID>();                         
          for(Portal_Tab_Access__c  oAccesssetup :[SELECT ID,Contact__c,Access_setup_Design_Kits_ASIC_DK__c,Access_setup_News_Alerts_ASIC__c FROM Portal_Tab_Access__c WHERE Contact__r.AccountID IN:AccountIdset AND Contact__r.Is_Portal_User_Active__c =: true AND (Access_setup_Design_Kits_ASIC_DK__c =: TRUE AND Access_setup_News_Alerts_ASIC__c =: TRUE)]){
            conIDs.add(oAccesssetup.Contact__c);          
          }
         //conlist = [SELECT Id,Name,Email,AccountId,Is_Portal_User_Active__c from Contact where AccountId IN:AccountIdset AND Is_Portal_User_Active__c=:TRUE];         
           conlist = [SELECT Id,Name,Email,AccountId,Is_Portal_User_Active__c from Contact where ID IN: conIDs ];                                         
        }
        
        map<id,list<Contact>> accContacts = new map<id,list<Contact>>();
        set<String> conEmailSet = new set<String>();
        
        for(contact oCon: conlist){
            string AccountEmailUnique = oCon.AccountId+oCon.Email;
                         
            if(accContacts.containsKey(oCon.AccountID)){
                if(!conEmailSet.contains(AccountEmailUnique)){
                    accContacts.get(oCon.AccountID).add(oCon);
                    conEmailSet.add(AccountEmailUnique);                     
                }
            }
            else{
                accContacts.put(oCon.AccountID,new list<Contact>());
                accContacts.get(oCon.AccountID).add(oCon);
            }
        }

       AccountIdContactmap =new map <id,list<Contact>>();
       asicIdContactEmailsmap = new map <Id,list<string>>();
       
      for(user oUser : [SELECT ID,Contact.ID FROM User WHERE ContactID IN: conlist ]){
          userContactmap.put(oUser.Contact.ID,oUser.ID); 
      }
      
      for (ID accID : accContacts.keySet()){
          for(Contact c : accContacts.get(accID)){
            conEmailmap.put(c.Email,c.ID);
            if(AccountIdContactmap.containsKey(c.accountid)){
                AccountIdContactmap.get(c.accountid).add(c);
            }else{
                list<Contact> contactlist=new list<Contact>();
                contactlist.add(c);
                AccountIdContactmap.put(c.accountid,contactlist);
            }
          }
      }
      
      
      for(id asicid:AsicIdMasterId.keyset())
      { 
          id masterid=AsicIdMasterId.get(asicid);
          set<id> accountIdset1=MasterIdAccountIdsetmap.get(masterid);
          if(accountIdset1!=null&& !accountIdset1.isEmpty()){
              list<string> tempEmaillist=new list<string>();
              for(id accountid:accountIdset1){
                  list<Contact> tempConlist=AccountIdContactmap.get(accountid);
                  if(tempConlist!=null && !tempConlist.isEmpty()){
                      for(Contact ConObj:tempConlist){
                          if(ConObj.Email !=null){
                            tempEmaillist.add(ConObj.email);
                          }
                      }
                  }
              }
            
            asicIdContactEmailsmap.put(asicid,tempEmaillist);
          }
      } 
      
        //send email to contacts (customers) **********START
        for(OrgWideEmailAddress owa : [select id, Address, DisplayName from OrgWideEmailAddress where Address like '%swift%']) {
            if(owa.Address.contains('swift')) 
                setOrgWideEmailAddress = owa.id; 
        } 
         
    if(asicIdContactEmailsmap!=null && !asicIdContactEmailsmap.isEmpty())
    {
        for(id asicId:asicIdContactEmailsmap.keyset())
        {
            ASIC_News_Alert__c AsicObj = asicObjectmap.get(asicId);            
            AsicObj.Email_notification_status__c = System.now() + ': start sending email.';            
            processedASICrecords = processedASICrecords + '\n'+'\n'+'ID: '+ AsicObj.Name + '\n' +' Title: ' +  AsicObj.Title__c +'\n '+'Emails sent to: '+'\n' ;                    
            Boolean mailFlag=false;
            Messaging.SingleEmailMessage[] messages = new list<Messaging.SingleEmailMessage>();

            if( asicIdContactEmailsmap.get(asicId)!=null && !asicIdContactEmailsmap.get(asicId).isEmpty())
            {
                for(string emailstring:asicIdContactEmailsmap.get(asicId)){                                        
                    if(!mailFlag){
                        processedASICrecords=processedASICrecords+emailstring+'\n';
                        mailFlag=true;
                    }
                    else{
                        processedASICrecords=processedASICrecords+''+emailstring+'\n';                     
                    }
                    if(emailstring !=null){
                        hasmails = true;
                    }                            
                }
                system.debug('****asicIdContactEmailsmap***'+asicIdContactEmailsmap.get(asicId).size());                                                                 
               //message.toAddresses =  asicIdContactEmailsmap.get(asicId);                                        
                if(asicIdContactEmailsmap.get(asicId).size() > 98  || test.isRunningTest())
                {
                    // split the email address list  into less than 100 
                    list<string> lstTemp = new list<string>();
                     for(Integer i = 0 ; i < (asicIdContactEmailsmap.get(asicId).size() / 98)+1 ; i++){
                          lstTemp = new list<string>();
                            for(Integer j=(i*98);(j<(i*98)+98) && j<asicIdContactEmailsmap.get(asicId).size() ; j++){
                                lstTemp.add(asicIdContactEmailsmap.get(asicId).get(j));
                              }
                        for(string oEmail:lstTemp){
                            Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage(); 
                            message.setTargetObjectId(userContactmap.get(conEmailmap.get(oEmail)));
                            message.setOrgWideEmailAddressId(setOrgWideEmailAddress); 
                            message.setBccAddresses(new string[] {'gfv.do.not.reply@globalfoundries.com'});  
                            message.setSaveAsActivity(false);             
                            message.setBccSender(false);                        
                            messages.add(message);
                            message.setSubject('ASIC '+AsicObj.Type__c+': '+ AsicObj.Title__c); //add type  field 
                            string messageBody = '<html><body>Hi, <br/> You are receiving this email because this is related to the design kit you have access to.'+'&nbsp;' +'<br/>Subject: ' + AsicObj.Title__c +'.<br/>Please follow the link below to view the detail.'+'<a href="'+ASICUrl+AsicObj.Id+'">ASIC News & Alert Link</a>'+'<br/>If you need help, please contact FAE of your account.</body></html>';                        
                            message.setHtmlBody(messageBody);                         
                        }
                    } // end split 100 loop                           
                }
                if(asicIdContactEmailsmap.get(asicId).size() <= 98)
                {                    
                   for(string oEmail:asicIdContactEmailsmap.get(asicId)){
                        Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage(); 
                        message.setTargetObjectId(userContactmap.get(conEmailmap.get(oEmail)));
                        message.setOrgWideEmailAddressId(setOrgWideEmailAddress); 
                        message.setBccAddresses(new string[] {'gfv.do.not.reply@globalfoundries.com'});  
                        message.setSaveAsActivity(false);             
                        message.setBccSender(false);                        
                        messages.add(message);
                        message.setSubject('ASIC '+AsicObj.Type__c+': '+ AsicObj.Title__c); //add type  field 
                        string messageBody = '<html><body>Hi, <br/> You are receiving this email because this is related to the design kit you have access to.'+'&nbsp;' +'<br/>Subject: ' + AsicObj.Title__c +'.<br/>Please follow the link below to view the detail.'+'<a href="'+ASICUrl+AsicObj.Id+'">ASIC News & Alert Link</a>'+'<br/>If you need help, please contact FAE of your account.</body></html>';                        
                        message.setHtmlBody(messageBody);                         
                    }                                    
                }                                   
                AsicObj.Is_notification_completed__c  = true;                                                                    
                try{
                     Messaging.SendEmailResult[] results = Messaging.sendEmail(messages);
                    if (results[0].success) {
                          AsicObj.Email_notification_status__c = dateTimeFormat + ': sending email completed.'; 
                    }
                    else {
                          AsicObj.Email_notification_status__c = dateTimeFormat + ': Error:' + results[0].errors[0].message + 'list of failed email -'+asicIdContactEmailsmap.get(asicId) ;   
                          failureError = 'Failure occurred -' + results[0].errors[0].message;
                    } 
                    if(TestVaraible == true){
                        string abc = string.valueof(decimal.valueof('evfrf'));
                    }                    
               }
               catch(Exception e){
                    AsicObj.Email_notification_status__c = dateTimeFormat + ': Error:' + 'list of failed email -'+asicIdContactEmailsmap.get(asicId) +'. There was an exception for' + e.getMessage() ;
                    failureError = failureError + asicIdContactEmailsmap.get(asicId);
                       GlobalUtility.logMessage('Error', 
                                     'FV_BatchASICNewsAlert', 
                                     'execute-Send Email Error', 
                                     '', 
                                     'ASIC', 
                                     'Error Message='+e.getMessage()+' At Line Number='+e.getLineNumber()+' Stack Trace='+e.getStackTracestring(),
                                     '',
                                     'PDK Provisioning',
                                     e,
                                     2300); 
               }
            } 
        }  
    } 
    }// DP if  
    if(!asicObjectmap.isEmpty())
        update asicObjectmap.values();
 
   }
      
   global void finish(Database.BatchableContext BC){
        if(!failureError.equals('')){
            hasFailure = true;
        }
        if(processedASICrecords.containsOnly('Processed records for ASIC News & Alert: ')){
            processedASICrecords = '';
        }
       //one line query 158
        AsyncApexJob a =
        [SELECT Id, Status, NumberOfErrors, JobItemsProcessed, TotalJobItems, CreatedBy.Email
        FROM AsyncApexJob WHERE Id =:BC.getJobId()];
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();  
            list<string> mailToAddresses = new list<string>();
            list<string> UserIdlist = new list<string>();
            list<Group> grouplist = [SELECT (select userOrGroupId from groupMembers) FROM group WHERE name = 'ASIC News Alert Admin'];
            if(grouplist != null && !grouplist.isEmpty() && grouplist[0].groupMembers!=null && !grouplist[0].groupMembers.isEmpty())
            {
            
                for (GroupMember gm : grouplist[0].groupMembers) {
                   UserIdlist.add(gm.userOrGroupId);
                }
            
                User[] userlist = [SELECT Id,email FROM user WHERE id IN :UserIdlist];
                for(User u : userlist) {
                    mailToAddresses.add(u.email);
                }
                mail.setToAddresses(mailToAddresses); //Send mail to admin group of users
                mail.setBccAddresses(new string[] {'gfv.do.not.reply@globalfoundries.com'});
                //custom label bcc
                mail.setSubject('Do not reply : Batch Status - ASIC News & Alert notification -' + a.Status);
                mail.setPlainTextBody('You are receiving this email because your name is added to Public Group \'ASIC News Alert Admin\'.'+'\n'+'\n'+'For ASIC News & Alert : The batch Apex job processed'+' '+ a.TotalJobItems + ' batches with '+ a.NumberOfErrors + ' failures.'+'\n'+processedASICrecords + '\n' + failureError);
                
                if(hasMails || hasFailure){
                    try{
                       Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
                       
                        if(TestVaraible == true){
                        string abc = string.valueof(decimal.valueof('evfrf'));
                        }   
                    }
                    catch(Exception e){
                     GlobalUtility.logMessage('Error', 
                                         'FV_BatchASICNewsAlert', 
                                         'Final- Send Email Error', 
                                         '', 
                                         'ASIC', 
                                         'Error Message='+e.getMessage()+' At Line Number='+e.getLineNumber()+' Stack Trace='+e.getStackTracestring(),
                                         '',
                                         'PDK Provisioning',
                                         e,
                                         2300); 
                    }
                }
            }
   }


}