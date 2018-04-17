/*
	Author: Nino Bustillos
	Description: Helper class for Enviroment Variable.
	History:
		Nbustillos	01282013	- code creation.
*/
public class EnvironmentVariable {
	
	// retrieves the value of the global variable 'name'
	public static String get(String name){
		String returnValue = null;
		final Map<String,Environment_Variable__c> all = Environment_Variable__c.getAll();
		
		if((name!=null) && (name.trim()!=null) && (name.trim().length()>0) && (all!=null) && (all.get(name)!=null)){
			returnValue = all.get(name).Value__c;
		}
        system.debug('--returnValue--'+returnValue);
		return returnValue;
	}
	
	// insert or blindly update the global variable 'name' with the 'value'.
	public static String put(String name, String value){
		String returnValue = null;
		
		if((name!=null) && (name.trim()!=null) && (name.trim().length()!=0)){
			Environment_Variable__c record = null;
			
			try{
				List<Environment_Variable__c> existingRecord = [select Name, Value__c from Environment_Variable__c where Name = :name limit 1];
				if(existingRecord.size()>0){
					record = existingRecord.get(0);
					record.Value__c = value;
					update record;
				}else{
					record = new Environment_Variable__c(Name=name,Value__c=value);
					insert record;
				}
				
				returnValue = value;
			}catch(Exception e){
				returnValue = 'error';
			}
		}
		
		return returnValue;
	}
}