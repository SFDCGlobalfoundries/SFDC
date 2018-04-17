/*
SWGP-998
This class updates MRS_Layer_Syncing_Status__c/MRS_Layer_Chip_Syncing_Status__c object based on response result from MSIH.
- Both objects will be in the same sObject list.

- In future, if new shadow object need to be added for another mrs object, 
has to keep universal field naming of Error_Syncing_at_MSIH__c/Is_Synced_With_MSIH__c
then it can be added into this class with minimum code repeated.
*/
global class MRSResponseService {

    global class ResponseMessage {
        webservice String sfdcId;
        webservice String status;
        webservice String message;
    }
    
    //all below are commented out waiting for aia, whether they can call a user data type collection to mssql stored procedure
    webservice static String notification(list<ResponseMessage> msgList) {
        try { return handling(msgList); } catch(Exception e) { return '## unhandled error exception: ' + e.getMessage() + ' | ' + e.getStackTraceString(); }
        
    }
    
    private static String handling(list<ResponseMessage> msgList) {
        
        String returnResult = 'ack';//in case no exceptions
        
        map<id, ResponseMessage> lm = new map<id, ResponseMessage>();//layer response map
        map<id, ResponseMessage> lcm = new map<id, ResponseMessage>();//layer chip response map
        
        //extract data from payload (data is mixed of layer/layer chip result)
        for(ResponseMessage rm: msgList) {            
            try{
                Id sfdcId = (Id) rm.sfdcId;
                if(sfdcId.getSObjectType() == MRS_Layer_Association__c.sObjectType)             lm.put(sfdcId, rm);//is layer?
                else if(sfdcId.getSObjectType() == MRS_Layer_Chip_Association__c.sObjectType)   lcm.put(sfdcId, rm);//is layer chip?
            } catch(exception e) {
                //potential error: aia/msih return incorrect id
                returnResult += ' ## error in update some records: ' + e.getMessage() + ' | ' + e.getStackTraceString();
            }
        }
        
        set<id> k1 = lm.keySet();//layer keys
        set<id> k2 = lcm.keySet();//layer chip keys
        String q1 = 'select id,MRS_Layer_Association__c from MRS_Layer_Syncing_Status__c where MRS_Layer_Association__c in :k1';
        String q2 = 'select id,MRS_Layer_Chip_Association__c from MRS_Layer_Chip_Syncing_Status__c where MRS_Layer_Chip_Association__c in :k2';
        
        list<sObject> result = new list<sObject>();
        result.addAll(Database.query(q1));
        result.addAll(Database.query(q2));
        
        for(sObject o: result) {
            
            String tmpMsg = '';
            String tmpStatus = '';
            Id key;//key is layer/layer chip 18 digits id
            
            if(o.getSObjectType() == MRS_Layer_Syncing_Status__c.sObjectType) {
                key = (Id) o.get('MRS_Layer_Association__c');
                if(lm.containsKey(key))  {
                    tmpMsg = lm.get(key).message;
                    tmpStatus = lm.get(key).status;
                }
            } else if(o.getSObjectType() == MRS_Layer_Chip_Syncing_Status__c.sObjectType) {
                key = (Id) o.get('MRS_Layer_Chip_Association__c');
                if(lcm.containsKey(key)) {
                    tmpMsg = lcm.get(key).message;
                    tmpStatus = lcm.get(key).status;
                }
            }
            
            //==================================================================================|
            if(!String.isBlank(tmpMsg))               o.put('Error_Syncing_at_MSIH__c', tmpMsg);
            else                                      o.put('Error_Syncing_at_MSIH__c', '');
            //==================================================================================|
            if(tmpStatus.containsIgnoreCase('error')) o.put('Is_Synced_With_MSIH__c', false);
            else                                      o.put('Is_Synced_With_MSIH__c', true);
            //==================================================================================|
        }
        
        //this allows partial success update
        //>>> any failures will be retry later by MRSBatchRetryMSIH batch class
        if(!result.isEmpty()) Database.SaveResult[] updateResult = database.update(result, false);
        return returnResult;
    }
}