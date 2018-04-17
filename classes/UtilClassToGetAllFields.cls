/*
Author: Shyam Ravindra Nair
Description: Utility class to get all fields from given object.
History:
SNair     11112014     - code creation
*/
public class UtilClassToGetAllFields {
	public string getAllFields(string objectName){
        String fieldnames = '';
        String sql='';
        sObject obj;
        try{
            Map<String, Schema.SObjectType> m = Schema.getGlobalDescribe();
            Schema.Sobjecttype s = m.get(objectName);
            Schema.Describesobjectresult r = s.getDescribe(); 
            
            //get fields
            Map<String, Schema.Sobjectfield> fields = r.fields.getMap();
            for(string field: fields.keySet()){
                if(fieldnames == ''){
                    fieldnames = field;
                }
                else{
                    fieldnames += ',' + field; 
                }
            }
        }
        catch(Exception e){
            return null;
        }
        return fieldnames;
    }
}