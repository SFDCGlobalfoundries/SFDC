/*
* @ Author :- Navneet Rajput
* @ Company :- Globalfoundries
* @ Description :- Class validate mandatory fields information from given inputs
**/

global with sharing class MandatoryFieldValidator {
		// input map should be prepare like map<string,string> map_DfmFields = 
		//	new Map<String,string> {'ptsr Number' => 'Ptsr Value','Ptsr Type' => 'DFM'}
		public static string createDFM (Map<String,String> dfmFields){
				if (dfmFields<>NULL && !dfmFields.isEmpty()) {
						Set<String> requiredFields = dfmFields.keySet();
						
						if (isValid(dfmFields.values())) {
								return 'Success';	
							
						}	else {
								return 'One or more required fields were NULL or BLANK: '+
										missingValues(dfmFields, requiredFields)+'.';		
						}
				}	
				
				return 'ERROR :: Input field map is empty, Please provide valid inputs. ';
		}
		
		//function validate list has blank or empty values 
	    private static boolean isValid(List<String> sList) {
		        for(String s : sList) {
			            if(s == null || s == ''){
			                return false;}
		        }
		        return true;
	    }
		
		//check input field with requiredFields and return missing field information
	    private static Set<String> missingValues(Map<String,String> inputFields, Set<String> requiredFields) {
		        Set<String> missingFields = new Set<String>(requiredFields);
		        
		        for(String key : inputFields.keySet()) {
			        	if(requiredFields.contains(key) && inputFields.get(key)<>NULL && !String.isEmpty(inputFields.get(key)))
			                missingFields.remove(key);
		        }
		        
		        return missingFields;
	    }
	
}