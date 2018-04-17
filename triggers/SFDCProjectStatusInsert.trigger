trigger SFDCProjectStatusInsert on SFDC_Project_Status__c (before insert) 
{
     Datetime currentSGPDatetime = DateUtil.getCurrentTimeSGP();
     Date statusMonday = null;
     Datetime statusMondayDT = null;
     Date statusFriday = null;
     Datetime statusFridayDT = null;
     
     List<SFDC_Project_Status__c> prevList = null;
     
     for(SFDC_Project_Status__c status:Trigger.new)
     {
       statusMondayDT = DateUtil.getWeekMondaySGP(status.Week_Ending_Date__c);
       statusFridayDT = statusMondayDT.addDays(4);     
       statusMondayDT = statusMondayDT.addHours(9);   
       statusFridayDT = statusFridayDT.addHours(19);
       //comment out the restriction on submitting period checking. New requirements from Purva to allow submission to enable anytime from Saturday to Friday.
       //if(!((currentSGPDatetime.getTime() > statusMondayDT.getTime())&&(currentSGPDatetime.getTime()< statusFridayDT.getTime())))
       //{
       //   status.addError('Current time in Singapore is ' + currentSGPDatetime.formatGMT('MM/dd/yyyy HH:mm aa') + ', Status for Week Ending on ' + statusFridayDT.format('MM/dd/yyyy') +
       //   ' can only be submitted between ' + statusMondayDT.formatGMT('MM/dd/yyyy HH:mm aa') + ' SGT and ' +  statusFridayDT.formatGMT('MM/dd/yyyy HH:mm aa') + ' SGT');
       //}
       
       prevList = [SELECT id, Name, Week_Ending_Date__c from SFDC_Project_Status__c where Project__c = :status.Project__c and Week_Ending_Date__c = :status.Week_Ending_Date__c];
       if(prevList.size() > 0)
       {
           status.addError('Status for week ending date of ' + status.Week_Ending_Date__c + ' has already been submitted for this project');
       } 
     }
     
    
     
      
     
}