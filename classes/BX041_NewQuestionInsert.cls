/******************************************************************************************************
    Class Name:    BX041_NewQuestionInsert
    Author:        Prosenjit Saha(PS)
    Description:   This Class handles newly created question metadata.
    History: 
      PS           11152013    - Code creation.
*******************************************************************************************************/

global class BX041_NewQuestionInsert{
    
    public id questionID;
    /******************************************************************************************************
    @Method Name:    MethodBX041_QuestionInsert
    @Return Type:    NA
    @parameter:      ApexPages.StandardController controller
    @Reason:         This method inserts new question to all the existing CDRS. This will be accessed from
                     the ajax call.
    *******************************************************************************************************/    
    webService static void MethodBX041_QuestionInsert(id questionID){
        
        //retrieving question metadata information.
        Question_metadata__c qstm = new Question_metadata__c(); 
        qstm = [SELECT    id,
                          name,
                          Question__c,
                          Question_to_Display__c,
                          Type__c,
                          Template_Name__c,
                          record_type__c,
                          API_Name__c,
                          Is_Synced__c 
                FROM      Question_metadata__c 
                WHERE     id = :questionID];
        
        //set of  BX041 ids where new question metadata is not present.
        Set<ID> CDRSnottoAdd = new Set<ID>();
        
        //list of sobjects
        List<sObject> listSobj = new List<sObject>();
        
        //Query string
        String QueryStr = 'SELECT id,name,BX_041__c,Question_Metadata__c FROM '+qstm.API_Name__c + ' WHERE Question_Metadata__c = \''+questionID+'\''; 
        system.debug('Debug:prosenjit::'+ QueryStr );
        listSobj = database.query(QueryStr);    //making query in the database for all child records under BX041 of the new question type to find the new question.
        
        //making reference for the object type of the newly introduced question. 
        Schema.SObjectType targetType = Schema.getGlobalDescribe().get(qstm.API_Name__c);     
        sObject tempObj = targetType.newSObject();       
        
        for(sObject sobj : listSobj ){//for loop start
        
            //preparing the list of CDRS records that not qualifies 
            if(sobj.get('BX_041__c')!= NULL){
                CDRSnottoAdd.add((id)sobj.get('BX_041__c'));    
            }
                                               
        }   //for loop end
                
        //if the question metadata record is not already synced then it will be considered to insert child records.
        if(qstm.Is_Synced__c == false){
            
            //preparing the search string for BX041 records.
            String[] templateString  =  qstm.Template_Name__c.split(';'); //this returns a list of string of the templates for the new question
            string finalString; //this contains the search string.
            for(String str : templateString  ){
                if(finalString == NULL){
                    finalString = '(\''+str;
                }
                else{
                    finalString += '\',\''+str;   
                }
                
            }
            finalString += '\')';
            
            string finalCDRSId; //creating the search string for CDRS IDs.
            for(ID str : CDRSnottoAdd){
                if(finalCDRSId == NULL){
                    finalCDRSId = '(\''+str;
                }
                else{
                    finalCDRSId += '\',\''+str;   
                }
                
            }
            finalCDRSId += '\')';
            
            //creating instance of the batch class. The insert of the new records will be handled through a batch class, so that it can't exceed the
            //governance limit of DML data rows.
            BX041_BatchQuestionInsert QuestionBatch = new BX041_BatchQuestionInsert ();//creating instance of the batch class.
            
            string queryString = 'SELECT Id, name FROM BX_041__c WHERE template_Name__c IN '+finalString;
            if(CDRSnottoAdd.size() >0)  queryString += ' AND ID NOT IN '+finalCDRSId;  //CDRS query string for the batch class. 
            if(test.isRunningTest()) queryString += ' limit 10';
            system.debug('TestDebug::Proaenjit:::: queryString'+queryString);
            //set variables of the batch class.
            QuestionBatch.query = queryString ; 
            QuestionBatch.CDRSnotToAdd = CDRSnottoAdd;
            QuestionBatch.qstn = qstm ;
            ID batchprocessid = Database.executeBatch(QuestionBatch);   //executing batch
            System.debug('TestDebug::Prosenjit::: Returned batch process ID: ' + batchProcessId);
        }//end of the if block        
    }//end of method MethodBX041_QuestionInsert
}//end of the class