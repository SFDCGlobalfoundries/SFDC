/*@Author < Nikhil bajaj >
@CreateDate < 11/Aug/2017 >
@Description <This is class is used to create configuration record pdf file in attachement and email notificaiton whenever configuration record is submitted by
 external users and FAE>
@Version <1.0>
*/

Public Class CPQInsertAttachement{
    @future(callout=true)
    Public  static void createAttachement(Id ConfigId,Id userId ,Boolean mailtoExtUser ,String templateName){
         
        
        if(ConfigId !=null && userId !=null){
             try{
                EmailTemplate template;
                if(templateName!=null){
                    template=[SELECT Id,body,subject FROM EmailTemplate WHERE developername =:templateName];
                }
                
                String stTargetId =[SELECT Id FROM Contact WHERE Email = 'noreply@salesforce.com' LIMIT 1].id;
                User activeUser = [Select Email From User where Id = : userId limit 1];
                String userEmail = activeUser.Email;
                Apttus_Proposal__Proposal__c config = [SELECT id,Name,Apttus_Proposal__Account__c,Device__c,Process_Technology__c,Apttus_Proposal__Opportunity__c,Process_Technology_Name__c,Fab_Name__c,Reticle_Count__c,Device_Owner__c,Comment__c FROM Apttus_Proposal__Proposal__c WHERE Id =:ConfigId];
                
                PageReference pagePdf = new PageReference('/apex/CPQ_Proposal_pdf?id='+config.id+'&doSave=No'); 
                Blob pdfPageBlob;
                if (Test.IsRunningTest())
                 {
                     pdfPageBlob = Blob.valueOf('UNIT.TEST');
                   
                 }
                 else
                 {
                      pdfPageBlob = pagePdf.getContentAsPDF();
                 }
                 
                List<User> ExternalUserList;
                
                if(mailtoExtUser==true){
                    List<ProcessInstance> piList = new List<ProcessInstance>([SELECT Id,SubmittedById 
                                                                                  FROM ProcessInstance 
                                                                                  where TargetObjectId =: config.id
                                                                                ORDER BY CreatedDate 
                                                                                 ASC LIMIT 1]);  
                     if(!piList.isEmpty()){
                         Id originalSubmitter = piList[0].SubmittedById ;
                         ExternalUserList = [Select Email from User where Id =:originalSubmitter ];
                      }
                  }
                     
                Attachment a = new Attachment(); 
                a.Body = pdfPageBlob ; 
                a.ParentID = config.id ; 
                a.Name = 'Proposal - ' + config.Name +'.pdf'; 
                a.Description = 'Proposal'; 
                Database.Insert(a); 
              
                String[] ccAddresses;
                if(mailtoExtUser ==true && !ExternalUserList.isEmpty() && ExternalUserList[0].Email !=null){
                       ccAddresses = new String[] {ExternalUserList[0].Email};
                 }
                
                String[] toAddresses = new String[] {userEmail};
                
                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                mail.setTargetObjectId(stTargetId);
                mail.setToAddresses(toAddresses);
                if(mailtoExtUser ==true && !ccAddresses.isEmpty() && ccAddresses!=null){
                    mail.setCcAddresses(ccAddresses);
                }
                
                mail.setTemplateId(template.Id);
                mail.setSaveAsActivity(false);
                mail.setWhatId(config.id);
                mail.setTreatTargetObjectAsRecipient(false);
                List<Messaging.Emailfileattachment> fileAttachments = new List<Messaging.Emailfileattachment>();
                Messaging.Emailfileattachment efa = new Messaging.Emailfileattachment();
                efa.setFileName('Proposal - ' + config.Name +'.pdf');
                efa.setBody(pdfPageBlob);
                fileAttachments.add(efa);
                mail.setFileAttachments(fileAttachments);
                
                Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });             
                        
             }catch(Exception excp){
                 GlobalUtility.logMessage('Error','CPQInsertAttachement','createAttachement','','Exception while inserting configuration record PDF file in attachement object or sending email to configurator creater',String.valueof(excp.getMessage()),'','Apttus CPQ',excp,0);
                
              }
          }

    }
    
}