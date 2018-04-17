/******************************************************************************************************
    Class Name:    BX041_BatchQuestionInsert
    Author:        Prosenjit Saha(PS)
    Description:   This Class inserts newly created question metadata to the respective object under 
                   all BX041 records.
    History: 
      PS           12062013    - Code creation.
      SA           25062015    - Updated final method to send email to current user and changed email details as per case # 42855 
*******************************************************************************************************/

global class BX041_BatchQuestionInsert implements Database.Batchable<sObject>{

    //Variable declaration: 
    public String query;
    String email;
    Id toUserId;
    Id fromUserId;
    public Question_metadata__c qstn;//new question metadata
    
    //set of BX041 ids where the new question metadata is not present
    public Set<ID> CDRSnotToAdd = new Set<id>();
    
    /******************************************************************************************************
    @Method Name:    start
    @Return Type:    NA
    @parameter:      Database.BatchableContext
    @Reason:         Start method of the batch class to query on the BX041 records 
    *******************************************************************************************************/ 
    global Database.querylocator start(Database.BatchableContext BC){
        Database.querylocator qry = Database.getQueryLocator(query);
        if( qry != NULL){
            return qry ;
        }
        else{
            return null;
        }
    }
    
    /******************************************************************************************************
    @Method Name:    execute
    @Return Type:    NA
    @parameter:      Database.BatchableContext, List<sObject>
    @Reason:         Execute the batch class.
    *******************************************************************************************************/ 
    global void execute(Database.BatchableContext BC, List<sObject> scope){
        
        system.debug('TESTHERE:: Prosenjit');
        if(scope != NULL && qstn.Is_Synced__c == false){
            List<sObject> listObj = new List<sObject>();//list of a specific sobject to insert
            BX041__c instance = BX041__c.getInstance(qstn.record_type__c);  /*custom settings instance to get the API name and other required values of the different child objects under BX041 */
            for(sObject s : scope){//scope for all applicable BX041 records
                system.debug('TESTDebug:: PSahaQstn API name'+qstn.API_Name__c);
                system.debug('TESTDebug:: PSahaQstn API name'+instance );
                if(!CDRSnotToAdd.contains(s.id)){ // if the new question doesnt in the CDRSnotToAdd list
                    //creating target object to insert.
                    Schema.SObjectType targetType = Schema.getGlobalDescribe().get(qstn.API_Name__c);     
                    sObject tempObj = targetType.newSObject();     
                        //Setting different fields of the BX041's target child object
                        tempObj.put('BX_041__c' , s.id);
                        tempObj.put(instance.API_Name__c , qstn.Question_to_Display__c );
                        tempObj.put(instance.getValue__c , 'None' );
                        tempObj.put('Question_Metadata__c' , qstn.id);
                    listObj.add(tempObj);
                } // end of if block.
            } //end of for loop
        
            try{//try start
                 if(qstn.Is_Synced__c == false && listObj!= NULL){
                     insert listObj; //insert child object data under BX041
                     system.debug('PS:Debug:::'+listObj);
                 }
                 //update question record to Synced. 
                 qstn.Is_Synced__c = true;
                 update qstn;
            }//end try 
            catch(exception e){} 
            }//end of scope chech if block.  
    }//end of execute method.
    
    /******************************************************************************************************
    @Method Name:    finish
    @Return Type:    NA
    @parameter:      Database.BatchableContext
    @Reason:         Finish method to send mails once the batch execution finishes. 
    *******************************************************************************************************/ 
    global void finish(Database.BatchableContext BC){//start finish method
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        //query used by Sunil Arora to get current running user email id (Case # 42855)
        // Query the AsyncApexJob object to retrieve the current job's information.
          AsyncApexJob a = [SELECT Id, Status, NumberOfErrors, JobItemsProcessed, TotalJobItems, CreatedBy.Email FROM AsyncApexJob WHERE Id = :BC.getJobId()];
        mail.setToAddresses(new String[] {a.CreatedBy.Email,'dl.IT.Salesforce_Admin@globalfoundries.com'}); //add users here to get mails.
        mail.setReplyTo('noreply-salesforce@globalfoundries.com');
        mail.setSenderDisplayName('Batch Processing');
        mail.setSubject('CDRS: Question Metadata Execution');
        mail.setPlainTextBody('Dear Admin/Requester,'+'\n'+'Request for applying question metadata to all CDRS has been completed Successfuly. You may proceed to create/Update CDRS.'+'\n'+'Thanks');
        
        if(!Test.isRunningTest())Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail }); //sending emails 
    }//end finish method.
}//end of class