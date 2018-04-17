/*
  Author: Anirban Roy
  Description: This is the email service class for CPQ MLGPLUS object.
  History:
    ARoy        03232015    - code creation.              
*/
global class CPQMLGPLUSEmailService implements Messaging.InboundEmailHandler {

    // Email Service method to handle and process inbound email
    global Messaging.InboundEmailResult handleInboundEmail(Messaging.InboundEmail email,
                                                             Messaging.Inboundenvelope envelope) {
            
            Messaging.InboundEmailResult result = new Messaging.InboundEmailresult();
            String ptNumber;
            String subject = email.subject;            

            // Parsing the subject line to see if first word separated by '|' is the Process Technology
            if(subject != null && subject.indexOf('|')!= -1 && subject.split('\\|')[0] != null
                    && subject.split('\\|')[0].trim().startsWith('PT')){                
                ptNumber = subject.split('\\|')[0].trim();
                
                if(email.binaryAttachments != null){
                
                    // Query the CPQ MLGPLUS object to check for existing record for the PT 
                    List<CPQ_MLGPLUS__c> mlgpluslist = [select id from CPQ_MLGPLUS__c where Process_Technology__c = :ptNumber];                
                    CPQ_MLGPLUS__c mlgplus;
                    
                    // If not present, insert the CPQ MLGPLUS record
                    if(mlgpluslist == null || mlgpluslist.size() == 0){
                        mlgplus = new CPQ_MLGPLUS__c();
                        mlgplus.Process_Technology__c = ptNumber;
                        mlgplus.Status__c = 'Unprocessed';
                        Database.SaveResult mlgplusInsertResult = Database.insert(mlgplus,true);     
                    }else{
                        mlgplus = mlgpluslist[0];
                    }
                    
                    // Check the MLG Email record for the particular CPQ MLGPLUS object
                    List<MLG_Email__c> mlgEmailList = [select     id
                                                                  , version__c
                                                                  , CPQ_MLGPLUS__c 
                                                       from       MLG_Email__c 
                                                       where      CPQ_MLGPLUS__c = :mlgplus.id
                                                       order by createddate desc limit 1
                                                      ];
                    
                    MLG_Email__c mlgEmail = new MLG_Email__c();
                    mlgEmail.CPQ_MLGPLUS__c = mlgplus.id;
                    
                    // If MLG Email record exists increase the version by 1 and if MLG record does not exists set the version as 1
                    if(mlgEmailList != null && mlgEmailList.size() > 0){                 
                        mlgEmail.Version__c = String.valueOf(Integer.valueof(mlgEmailList[0].Version__c.trim())+1);     
                    }else{
                        mlgEmail.Version__c = '1';   
                    }
                    
                    // Insert the MLG Email record corresponding to the particular CPQ MLGPLUS record
                    Database.SaveResult mlgEmailInsertResult = Database.insert(mlgEmail,true);
                    
                    // Insert the email attachment in the notes & attachment of the MLG Email record                
                    List<Attachment> attList = new List<Attachment>();                
                    for (Messaging.Inboundemail.BinaryAttachment bAttachment : email.binaryAttachments) {
                        Attachment attachment = new Attachment();
                        attachment.Name = bAttachment.fileName;
                        attachment.Body = bAttachment.body;
                        attachment.ParentId = mlgEmail.Id;
                        attList.add(attachment);                    
                    }
                    if(attList.size()>0){
                        List<Database.SaveResult> mlgEmailAttachInsertResultList = Database.insert(attList,true);
                    }
                
                }else{
                    //Insert in the error log object with Attachment error
                    insertErrorLog('Attachment Error','The email does not contain any attachment.');                    
                }         
            }else{                
                //Insert in the error log object with Subject Line error
                insertErrorLog('Subject Line Error','The Email received does not have the PT number as the first word in the subject line.');             
            }
            result.success = true;
            return result;
    }
    
    // Insert record into the CPQ MLG Error Log object
    private void insertErrorLog(String errType, String errDesc){
        CPQ_MLG_Error_Log__c errLog = new CPQ_MLG_Error_Log__c();
        errLog.Error_Type__c = errType;
        errLog.Error_Description__c = errDesc;
        insert errLog;    
    }
}