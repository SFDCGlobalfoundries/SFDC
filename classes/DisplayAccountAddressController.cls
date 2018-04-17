public class DisplayAccountAddressController{
    
    public List<Account_Address__c> accAddress {get;set;}
    public Id accId {get;set;}  
   
    public DisplayAccountAddressController(ApexPages.StandardController controller) {
        
        Account record = (Account) controller.getRecord(); 
        accId = record.id;
        
        String accAddQuery = 'SELECT ';       
        accAddQuery += describeObjectFields('Account_Address__c');
        accAddQuery += ' FROM Account_Address__c WHERE account__c = ' + '\'' + accId + '\''; 
        accAddress = database.query(accAddQuery);
        
    }

    public String describeObjectFields(String objctName){
        String fieldNameStr = '';
        
        Map<String,Schema.SObjectType> GlobalDescribeMap = Schema.getGlobalDescribe();
        Schema.SObjectType SObjectTypeObj = GlobalDescribeMap.get(objctName);
        Map<String,Schema.SObjectField> SObjectFieldMap = SObjectTypeObj.getDescribe().fields.getMap();
        
        for(Schema.SObjectField fld : SObjectFieldMap.values()){
            Schema.DescribeFieldResult dfLst = fld.getDescribe();
            fieldNameStr += dfLst.getName() + ' ,';
        }
        
        return fieldNameStr.substring(0,fieldNameStr.length()-1);
    }    
}