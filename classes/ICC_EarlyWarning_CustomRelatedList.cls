public class ICC_EarlyWarning_CustomRelatedList
{
    public List<Early_Warning_Status__c> lstEWS {get;set;} 
    public Set<String> setHeaderNames{get;set;}
    
    public List<Schema.FieldSetMember> getFields() {
        return SObjectType.Early_Warning_Status__c.FieldSets.ICC_Custom_Related_List.getFields();
    }

    public ICC_EarlyWarning_CustomRelatedList(ApexPages.StandardController controller) 
    {
        Sales_Order_Schedule__c sos = (Sales_Order_Schedule__c)controller.getRecord();
        lstEWS = new List<Early_Warning_Status__c>();
        setHeaderNames = new Set<String>();
        
        String query = 'SELECT ';
        for(Schema.FieldSetMember f : this.getFields()) {
            query += f.getFieldPath() + ', ';
            setHeaderNames.add(f.getLabel());
        }
        query += 'Id FROM Early_Warning_Status__c WHERE Sales_Order1__c = \'' + sos.id + '\' ORDER BY Version_Id__c DESC';
        lstEWS = Database.query(query);
        /*lstEWS = [Select Id, Name, AVAIL_DATE__c, Available_Quantity__c, EWS_FLAG__c, Version_Id__c, 
                  Internal_Reason_Code__c, Extrnal_Reason_Code__c, Internal_Comments__c, External_Comments__c, 
                  Is_Latest_Version__c FROM Early_Warning_Status__c WHERE Sales_Order1__c =: sos.id ORDER BY Version_Id__c DESC];*/
    }
}