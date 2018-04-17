/**
    Class Name:    UpdateAssigneProcessBatch
    Author:        Thomas Lai(TL)
    Description:   This class update Assigned Process linked to specific set of Processes
    History: 
      TL           18012014    - Code creation.
**/

global class UpdateAssigneProcessBatch implements Database.Batchable<sObject>{

    //Variable declaration: 
    public String query;
    public set<id> procIdSet;
    /******************************************************************************************************
    @Method Name:    start
    @Return Type:    NA
    @parameter:      Database.BatchableContext
    @Reason:         Start method of the batch class to query on the Assigned Process records 
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
        update scope;
    }
    
    /******************************************************************************************************
    @Method Name:    finish
    @Return Type:    NA
    @parameter:      Database.BatchableContext
    @Reason:         Finish method to send mails once the batch execution finishes. 
    *******************************************************************************************************/ 
    global void finish(Database.BatchableContext BC){//start finish method
        
    }//end finish method.
}//end of class