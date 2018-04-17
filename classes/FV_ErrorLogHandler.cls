/*
* @ Author :- Navneet Rajput
* @ Company :- CTS
* @ Date :- 12 Dec 2014
* @ Description :- Class help to log error or exceptions occures during response send from AIA or OT
* @ Change History :-
**/
public with sharing class FV_ErrorLogHandler {
	
	private static PDK_Erro_Logger__c logger;
	
	public FV_ErrorLogHandler(){
	}
	
	public static void setErrorLogs(String moduleName,String className,String methodName,String error) {
		logger = FV_ErrorLogHandler.getInstance();
		logger.Module_Name__c = moduleName;
		logger.Class_Name__c = className;
		logger.Method_Name__c = methodName;
		logger.Error_Msg__c = error;
		 
		insert logger; 
	}
	// Return instance of errorLog object
	private static PDK_Erro_Logger__c getInstance(){
		if (logger == NULL){
			logger = new PDK_Erro_Logger__c();
		} else {
			return logger; 
		}
		return logger;
	} 
}