/*
*@ Author    :- Sunita Char
*@ Company    :- Cognizant technology
*@ Date      :- 4/01/2016
*@ Description  :- Helps to update Opporunity previous revenue values
*@ History    :- 

*/


global class UpdateOpportunityPreviousRevenueBatchcls implements Schedulable, Database.Stateful, Database.Batchable<sObject> 
  {
        public list<string> opptyIds = new list<string>();
        public string opportunityIds;
        public string stagingId;
        public UpdateOpportunityPreviousRevenueBatchcls(){
            List<Oppty_Staging_Table__c> listOfDummyTable=new List<Oppty_Staging_Table__c>();
            listOfDummyTable=[select id,name,Time_diff__c,CreatedDate,Opportunity_Ids__c from Oppty_Staging_Table__c ORDER BY createddate DESC LIMIT 1];       
            Decimal timediff;      
            if(listOfDummyTable.size()!=0){               
                timediff=listOfDummyTable[0].Time_diff__c;
            }   
                
            if(timediff<=1){
                opportunityIds = listOfDummyTable[0].Opportunity_Ids__c;
                stagingId = listOfDummyTable[0].Id;
                if(listOfDummyTable[0].Opportunity_Ids__c.indexOf(',') > 0){
                    opptyIds = listOfDummyTable[0].Opportunity_Ids__c.split(',');                
                }else{
                    opptyIds.add(listOfDummyTable[0].Opportunity_Ids__c);
                }
                system.debug('>>>>>>>>>>>>>opptyIds :'+opptyIds);                        
           }
               
      }
       global Database.querylocator start(Database.BatchableContext BC)
       {
       
       system.debug('start>>>>>>>>>>>>opptyIds:'+opptyIds);
       return Database.getQueryLocator([SELECT ID,X2016_C__c,X2016_P__c,X2017_C__c,X2017_P__c,X2018_C__c,X2018_P__c,Account.RecordTypeId,Prob_P__c,Probability,Worst_Issue_Status_P__c,Worst_Issue_Status__c,
                                               X2019_C__c,X2019_P__c,X2020_C__c,X2020_P__c,Name,StageName, X2021_C__c, X2021_P__c, X2022_C__c, X2022_P__c, X2023_C__c, X2023_P__c, X2024_C__c, X2024_P__c, X2025_C__c, X2025_P__c  
                                               FROM  Opportunity where Id IN :opptyIds ]);
       }
       
    
      global void execute(SchedulableContext ctx) 
      {
        
       
      }
      global void execute(Database.BatchableContext BC, List<sObject> listOfOppRecordsfetched)
      {
         List<Opportunity> listOfOppRecordsupdated=new List<Opportunity>();
         List<Device_Gap__c> listOfOppIsuue=new List<Device_Gap__c>();
         List<Device_Gap__c> listOfOppIsuue1=new List<Device_Gap__c>();
         List<Device_Gap__c> listOfOppIsuueupdated=new List<Device_Gap__c>();
         SET<Id> setofOppids=new SET<Id>();
         SET<Id> SetofOppissueIds=new SET<Id>();
       List<Oppty_Staging_Table__c> listOfDummyTable=new List<Oppty_Staging_Table__c>();
       listOfDummyTable=[select id,name,Time_diff__c,CreatedDate from Oppty_Staging_Table__c ORDER BY createddate DESC LIMIT 1
       ];
        
        Decimal timediff;
        if(listOfDummyTable.size()!=0)
        {
           
            timediff=listOfDummyTable[0].Time_diff__c;
         }
           if(timediff<=1)
           {
             for(Opportunity objopp :(List<Opportunity>) listOfOppRecordsfetched)
             {
              if(objopp.account.RecordTypeId!=system.label.AccountRecordTypeIBMAccount)
              {
              setofOppids.add(objopp.Id);
              objopp.X2016_P__c = objopp.X2016_C__c;
              objopp.X2017_P__c = objopp.X2017_C__c;
              objopp.X2018_P__c = objopp.X2018_C__c;
              objopp.X2019_P__c = objopp.X2019_C__c;
              objopp.X2020_P__c = objopp.X2020_C__c;
              
              objopp.X2021_P__c = objopp.X2021_C__c;
              objopp.X2022_P__c = objopp.X2022_C__c;
              objopp.X2023_P__c = objopp.X2023_C__c;
              objopp.X2024_P__c = objopp.X2024_C__c;
              objopp.X2025_P__c = objopp.X2025_C__c;
              
              //Updated additional Opportunity fields 
              //objopp.Prob_P__c = objopp.Probability;
              //objopp.Worst_Issue_Status_P__c = objopp.Worst_Issue_Status__c;
              
              listOfOppRecordsupdated.add(objopp);
              }
             
             }
             if(listOfOppRecordsupdated.size()!=0)
             {
             
             
             update listOfOppRecordsupdated;
             }
             
             listOfOppIsuue = [SELECT ID, 
                                      Name, 
                                      Issue_Comments__c, 
                                      Status_P__c, Status__c, 
                                      Improve_Prob_P__c, 
                                      Improve_Prob__c, 
                                      Action_to_Close_Issue__c, 
                                      Action_Close_Date_P__c, 
                                      Action_Close_Date__c 
                                      FROM Device_Gap__c where Opportunity__c   in : setofOppids]; 
            
            if(listOfOppIsuue.size()!=0)
             {
             
                for(Device_Gap__c objIssue :listOfOppIsuue)
                {
                  SetofOppissueIds.add(objIssue.id);
                  
                }  
            }
            listOfOppIsuue1 = [SELECT ID, 
                                      Name, 
                                      Issue_Comments__c, 
                                      Status_P__c, Status__c, 
                                      Improve_Prob_P__c, 
                                      Improve_Prob__c, 
                                      Action_to_Close_Issue__c, 
                                      Action_Close_Date_P__c, 
                                      Action_Close_Date__c 
                                      FROM Device_Gap__c where Id in : SetofOppissueIds]; 
            
           if(listOfOppIsuue1.size()!=0)
          {
              
                for(Device_Gap__c objIssue :listOfOppIsuue1)
                {
                  
                  objIssue.Improve_Prob_P__c=objIssue.Improve_Prob__c;
                  objIssue.Action_Close_Date_P__c=objIssue.Action_Close_Date__c;
                  listOfOppIsuueupdated.add(objIssue);
                
                }
           } 
            if(listOfOppIsuueupdated.size()!=0)
             {
              update listOfOppIsuueupdated;
             }
             

          }
         
     }
      
      global void finish(Database.BatchableContext BC)
      {
        AsyncApexJob a = [Select Id,
                                 Status, 
                                 NumberOfErrors, 
                                 JobItemsProcessed,  
                                 TotalJobItems, 
                                 CreatedBy.Email, 
                                 ExtendedStatus  
                                 from AsyncApexJob where Id = :BC.getJobId()];  
                                 
      List<String> usr_email=new List<String>();
      List<GroupMember> lstofgpmembers=new  List<GroupMember>();
      Set<Id> setofUsers=new  Set<Id>();
      lstofgpmembers=[Select GroupId, 
                             UserOrGroupId
                             From GroupMember
                             Where GroupId = :system.label.Executive_Update_Admins];
                             
       if(lstofgpmembers.size()!=0) 
       {             
          for( GroupMember gp :  lstofgpmembers)
          {
           setofUsers.add(gp.UserOrGroupId);
          } 
       }   
          List<User> lstofUsers=new  List<User>();
          lstofUsers=[Select Id, 
                             email
                             From User
                             Where Id in  :setofUsers];
                             
        if(lstofUsers.size()!=0) 
       {                     
          for( User u1 :  lstofUsers)
          {
           usr_email.add(u1.email);
          }                  
       }             
       if(a.status=='Completed')
       {
           //Update Staging Table Record status
           List<Oppty_Staging_Table__c> listOfDummyTable = [select id,name,Time_diff__c,CreatedDate,Opportunity_Ids__c,Status__c from Oppty_Staging_Table__c where Status__c ='Pending'];
           for(Oppty_Staging_Table__c staging :listOfDummyTable){
               if(staging.Opportunity_Ids__c == opportunityIds){
                   if(staging.Id == stagingId)
                       staging.Status__c = 'Completed';
                   else
                       staging.Status__c = 'Aborted';               
               }
           }
           update listOfDummyTable;
           list<Opportunity> opportunities = [SELECT ID,X2016_C__c,X2016_P__c,X2017_C__c,X2017_P__c,X2018_C__c,X2018_P__c,Account.Name,Account.RecordTypeId,Prob_P__c,Probability,Worst_Issue_Status_P__c,Worst_Issue_Status__c,
                                               X2019_C__c,X2019_P__c,X2020_C__c,X2020_P__c,Name,StageName, X2021_C__c, X2021_P__c, X2022_C__c, X2022_P__c, X2023_C__c, X2023_P__c, X2024_C__c, X2024_P__c, X2025_C__c, X2025_P__c  
                                               FROM  Opportunity where Id IN :opptyIds ];
                                               
           
         Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();  
         String[] toAddresses = usr_email;  
         String[] ccAddresses = new String[] {a.CreatedBy.Email}; 
         String sfdcURL = URL.getSalesforceBaseUrl().toExternalForm();
         String fromadd=system.label.OrganisationWideAddress;
         mail.setToAddresses(toAddresses); 
         mail.setCcAddresses(ccAddresses);
         mail.setBccSender(false);
         mail.setOrgWideEmailAddressId(fromadd); 
         mail.setSubject('Update of Demand Gen Completed');  
         string htmlBody = 'The Batch to Update the Demand Gen Values for the following Opportunities is Completed. No Of Batches Processed '+ a.TotalJobItems +' and there were '+ a.NumberOfErrors + ' failures.';
         htmlBody += '<br/><br/><table border="1" style="border-width:1" cellpadding="5"><tr><th>Sr. No.</th><th>Opportunity Name</th><th>Account Name</th><th>Stage</th><th>Probability</th><th>Prob% (P)</th><th>Opportunity Link</th></tr>';
         integer i=0;
         for(Opportunity oppty: opportunities){
             i++;
             htmlBody += '<tr>'; 
             htmlBody += '<td align="center">'+i+'</td><td>'+oppty.Name+'</td><td>'+oppty.Account.Name+'</td><td>'+oppty.StageName+'</td><td>'+oppty.Probability+'</td><td>'+oppty.Prob_P__c+'</td><td>'+sfdcURL+'/'+oppty.Id;        
             htmlBody += '</tr>';             
         }
         htmlBody += '</table>';
         mail.setHTMLBody(htmlBody); 
           
            
         Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });  
         
        }
      }
  
  }