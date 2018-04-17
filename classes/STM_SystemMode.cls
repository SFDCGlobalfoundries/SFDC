/*
    Company:        Cognizant Technology Solution
    Description:    This class contains methods that run in system mode.
    History:
        NJain    01/10/2015    Class Creation
        
*/
public without sharing class STM_SystemMode{
    
    //Updating the FTP Initiated flag to 'True'
    public static void initiateFTP(String taskId){
        STMTask__c taskRecord = new STMTask__c(id=taskId);
        taskRecord.FTP_Initiated__c = True;
        update taskRecord;
    }
    
    //Query FeedItem based on ParentId
    public static List<FeedItem> queryFeedItem(String stmTaskId){
        return [select id,ContentFileName,ContentSize,RelatedRecordId FROM FeedItem where ParentId = :stmTaskId and Type='ContentPost'];
    }
    
}