/*
    Author:      Deepti Narayan Biswal
    Description: This class handles NoCPKReportforMonth Page.

    History:
    DBiswal    02182015 - Class Creation.
*/
public class NoCPKReportforMonthController{
     
    public Monthly_CPK_Report__c report{get;set;}
 
    public NoCPKReportforMonthController(ApexPages.StandardController stdController){
        this.report= (Monthly_CPK_Report__c)stdController.getRecord();
    }
     
    public void saveReport() {
        try{
            if(report.Reason_for_No_Reports__c == 'No WIP' || report.Reason_for_No_Reports__c == 'Lots < 10'){
                report.Approved__c = 'No Reports';
                update report;
            }
            
        }catch(exception e) {
            System.debug('Exception :'+e.getMessage());
        }
    }
}