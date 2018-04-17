/*
    Author: Sunil Arora
    Description: Batch class to extract inactive TeamRoomMember records and delete them
    Created Date: 27th May,2016
*/
global class TeamRoomMemberDeleteBatch implements Database.Batchable<sObject>{

    global final String query = 'SELECT Id, Team_Room__c, Name, User__c, User__r.Id, User__r.IsActive, User__r.Name FROM Team_Room_Member__c where User__r.IsActive =false';
    
    global Database.QueryLocator start(Database.BatchableContext BC)
    {
        system.debug(query);
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext ctx, List<Sobject>
                        scope){
        try{
            List<Team_Room_Member__c> teamRoomMemberList = (List<Team_Room_Member__c>)scope;
            List<Database.Error> lsterror= new List<Database.Error>();
            Database.DeleteResult[] TRM_Dels = Database.delete(teamRoomMemberList,false );
            
            for (Database.DeleteResult sr : TRM_Dels) {

              if (sr.isSuccess()) {               
                // Operation was successful, so get the ID of the record that was processed
                
              }
              
              else {
                
                // Operation failed, so get all errors               
                
                for(Database.Error err : sr.getErrors()) {
                  lsterror.add( err);
                  
                  
                }
                
              }
               //below code will be used to create case in SFDC in case of error
               if(lsterror.size()>0 || Test.isRunningTest())
                {
                  String AdminMail= system.label.Case_Support_email_id;
                  string SetReplyTo=system.label.SetReplyTo;
                  Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                  mail.setToAddresses(new String[] {AdminMail});
                  mail.setReplyTo(SetReplyTo);
                  mail.setSenderDisplayName(system.label.SetSubjectTMD);
                  mail.setSubject(system.label.SetSubjectTMD);
                  mail.setPlainTextBody('The mail processing encountered following exception:-'+ lsterror);
                  Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
                }  
            }           

           }catch(Exception e){
              //System.debug('Exception is :::::'+e);
           }
        
    }
    


    global void finish(Database.BatchableContext BC){

    }
    

}