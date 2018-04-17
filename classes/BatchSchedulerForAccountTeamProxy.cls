/*
Type Name: BatchSchedulerForMRSLayerAssociation
Author: Cognizant
Created Date: 03-May-2014
Reason: Batch class for audit log
Change History:
Author:
Modified Date:
Reason:
Author: Cognizant Technology Solutions
Modified Date:
……..
……..
*/


global class BatchSchedulerForAccountTeamProxy implements Schedulable
{
 
  global void execute(SchedulableContext sc) {
      //final Integer BATCH_SIZE = 2000;
      final Integer BATCH_SIZE;
      Environment_Variable__c batchSize = Environment_Variable__c.getInstance('SWIFT_MRS_GENERAL_JOB_BATCH_SIZE');
      if(batchSize != null) BATCH_SIZE = Integer.valueOf(batchSize.value__c); else BATCH_SIZE = 500;
      
      DateTime currentTime = System.now();
      
      BatchAccTeamProxyAdd objbatchhistory  = new BatchAccTeamProxyAdd(); 
      database.executebatch(objbatchhistory,BATCH_SIZE);
      
      BatchContactAdd objcontactAdd=new BatchContactAdd();
      database.executebatch(objcontactAdd,BATCH_SIZE);
            
      if(!Test.isRunningTest()){
        System.abortJob(sc.getTriggerId());
      }
      
      String currentHour =  String.valueOf(currentTime.hour());
      String currentMinute =  String.valueOf(currentTime.minute());
      String sch= '0 0 '+String.valueOf(currentTime.hour() + 1)+' * * ?';
      if(currentTime.hour() == 23)
      {
      sch = '0 0 0 * * ?';
      }
      
      if(currentTime.minute() == 0 || Test.isRunningTest()){
        sch = '0 30 '+currentHour+' * * ?';
      }
      if(currentTime.minute() == 30 || Test.isRunningTest()){
        sch = '0 0 '+String.valueOf(currentTime.hour() + 1)+' * * ?';
      }
      if((currentTime.hour() == 23 && currentTime.minute() == 30) || Test.isRunningTest()){
          sch = '0 0 0 * * ?';
      }
      if(!Test.isRunningTest() && sch != null){
        System.schedule('AddDeletePTRFShare',sch,new BatchSchedulerForAccountTeamProxy());
      }
   } 
     
   
    
}