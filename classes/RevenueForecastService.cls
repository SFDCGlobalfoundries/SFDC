/*
    Author: Anirban Roy
    Description: This webservice resets the revenue forecast ASP/Volume. 
                 Called from 'Reset Forecast' button.
    History: 
        ARoy  	04082014    - Code creation.        
*/

global class RevenueForecastService {
    webservice static String resetForecast(String gmplId) {
        try{
            
            List<GMPL_BX009__Share> gmplList = new List<GMPL_BX009__Share>();
            
            String sysAdmin = EnvironmentVariable.get('SYS_ADMIN');
        	String ctsDev = EnvironmentVariable.get('CTS_DEVELOPER');
        	String gfDev = EnvironmentVariable.get('GF_DEVELOPER');
        	String gfSysAdmin = EnvironmentVariable.get('GF_SYSTEM_ADMIN');
        	String gfGlbAdmin = EnvironmentVariable.get('GF_GLOBAL_ADMIN');
        	String gfInt = EnvironmentVariable.get('GF_INTEGRATION');
            
            Profile prof = PPETeamHelper.getUserProfile();
            
            
            if(!(prof.Name == sysAdmin || prof.Name == ctsDev || prof.Name == gfDev
                || prof.Name == gfSysAdmin || prof.Name == gfGlbAdmin || prof.Name == gfInt)){          
	            gmplList =  PPETeamHelper.getGMPLBX009ShareUser(gmplId);
            }
            
            if((gmplList != null && gmplList.size()>0)||(prof.Name == sysAdmin || prof.Name == ctsDev || prof.Name == gfDev
                || prof.Name == gfSysAdmin || prof.Name == gfGlbAdmin || prof.Name == gfInt)){
            
	            String resetStatus = 'OK';
	                                
	            List<Revenue_Forecast__c> revForList = new List<Revenue_Forecast__c>();
	            for(Revenue_Forecast__c revForObj : [select		Id
	            												, Average_Sales_Price__c
	            												, Quantity__c 
	                                           		 from 		Revenue_Forecast__c 
	                                           		 where		GMPL_BX009__c = :gmplId]){
	                boolean isUpdate = false;
	                if(revForObj.Average_Sales_Price__c!=0){
	                    revForObj.Average_Sales_Price__c = 0;
	                    isUpdate = true;
	                }
	                if(revForObj.Quantity__c!=0){
	                    revForObj.Quantity__c = 0;
	                    isUpdate = true;
	                }
	                if(isUpdate){
	                	revForList.add(revForObj);			
	                }                
	            }           
	            if(revForList.size()>0){
	                update revForList;
	            }
	            return resetStatus;
            }else{
            	return 'User is having Read Only access on GMPL/BX009 record.';
            }
        }catch(Exception ex){
            return ex.getMessage();
        }
    }
}