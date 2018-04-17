/**
 *@ author :SUHAS BARGI
 * 
 */
@isTest
private class GF_CommonErrorLoggerTest { 
    
   

    static testMethod void GF_CommonErrorLoggerTest1() {
        
        User usr = [Select Id,Email FROM User WHERE Id =:userInfo.getUserId()]; 
	    List<string> toAddresses = new List<string>{usr.Email};
         toAddresses.add('Gfv.do.not.reply@globalfoundries.com');
       
        try {
                 throw new GF_CommonErrorLoggerTest.GenericException('Problem while sending email, Please contact system administrator.' );
                     
              } catch (Exception ex) {
                  
                  GF_CommonErrorLogger.sendErrorNotification('DRC GF_CommonErrorLogger', ex, toAddresses);
              } 
       
       
    }
    
    static testMethod void GF_CommonErrorLoggerTest2() {
        
        User usr = [Select Id,Email FROM User WHERE Id =:userInfo.getUserId()];
	    List<string> toAddresses = new List<string>{usr.Email};
            toAddresses.add('Gfv.do.not.reply@globalfoundries.com');
       
       
        try {
                 throw new GF_CommonErrorLoggerTest.GenericException('Problem while sending email, Please contact system administrator.' );
                     
              } catch (Exception ex) {
                  
                  GF_CommonErrorLogger.creatLogs('DRC GF_CommonErrorLogger', 'Common Error logger ', 'Error Logging ', ex,  Date.today());
              } 
       
    }
    
    class GenericException extends Exception {
     }
}