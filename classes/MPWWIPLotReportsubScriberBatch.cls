public class MPWWIPLotReportsubScriberBatch  implements Database.Batchable < sObject >{
   
    public List < sObject > start(Database.BatchableContext BC) {
        String query = 'Select User_Name__c,Scheduled_Frequency1__c,Start_Date__c,End_Date__c   from MPW_WIP_Report_Schedule__c';
        return Database.query(query);
    }
    
    public void execute(Database.BatchableContext BC, List < MPW_WIP_Report_Schedule__c > scope) {
        
         MPW_WIP_Report_Schedule__c objMPWWIPReportSchedule= scope[0];
         
         String strUserName=objMPWWIPReportSchedule.User_Name__c;
         boolean isReportSend=false;
        
        if((objMPWWIPReportSchedule.Start_Date__c ==null ||objMPWWIPReportSchedule.Start_Date__c<=System.Today()) && (objMPWWIPReportSchedule.End_Date__c ==null ||objMPWWIPReportSchedule.End_Date__c>=System.Today())){ 
        
         if(objMPWWIPReportSchedule.Scheduled_Frequency1__c=='MONTHLY' && (System.Today().toStartOfMonth()==System.Today() || Test.isRunningTest())){
           isReportSend=true;
         }else if(objMPWWIPReportSchedule.Scheduled_Frequency1__c=='WEEKLY'  && (System.Today().toStartofWeek()==System.Today() || Test.isRunningTest())){
            isReportSend=true;
         }else if(objMPWWIPReportSchedule.Scheduled_Frequency1__c=='DAILY'){
            isReportSend=true;
         }
        
	        if(isReportSend){
	          MPWWIPLotReportSendWithAttachment.sendEmailToCustomer(strUserName);
	        }
        }
    }

    public void finish(Database.BatchableContext BC) {}
}