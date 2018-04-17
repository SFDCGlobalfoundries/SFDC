public class IPReqCopyController {
    public ApexPages.StandardController stdCnt;
    public IPReqCopyController(ApexPages.StandardController std){
        stdCnt = std;
    }
    public pageReference copy(){
        Schema.DescribeSObjectResult objectDescribe  = CMOS_BU_IP_Request__c.SObjectType.getDescribe();
        if(objectDescribe.createable){
            Map<String,CopyIPReqFields__c> custSetMap = CopyIPReqFields__c.getall();
            CMOS_BU_IP_Request__c ipReqNewValues = (CMOS_BU_IP_Request__c) stdCnt.getRecord();
            Id ipReqId = stdCnt.getRecord().id;
            string query = 'Select ';
            for( String fieldName : custSetMap.keySet()) {
                query += fieldName + ',';
            }
            query = query.removeEnd(',');
            query += ' from CMOS_BU_IP_Request__c where Id=:ipReqId';
            system.debug('query==>'+query);
            CMOS_BU_IP_Request__c ipReq = database.query(query);
            
            CMOS_BU_IP_Request__c copyOne = new CMOS_BU_IP_Request__c();
            for(String copyField: custSetMap.keySet()){
                if(copyField != 'IPType__c' && copyField != 'IP_Subtype__c')
                copyOne.put(copyField, ipReq.get(copyField));
            }
            copyOne.IPType__c = ipReqNewValues.IPType__c;
            copyOne.IP_Subtype__c = ipReqNewValues.IP_Subtype__c;
            copyOne.Stage__c='Draft';
            
            insert copyOne;
            return new PageReference('/'+copyOne.Id+'/e?retURL=%2F'+copyOne.Id);
        }
        return null;
    }
}