/*
    Author:         ROS Team
    Company:        Cognizant Technology Solution
    Description:        
    History:
    
    Ankit Singhal   26-Aug-13    Class Creation
    CTS             10-Oct-13    Add Varibale pass Current Cycle.
    NJain           22-Sep-14    Added the condition in QueryLocator to filter out Reticle Datawarhouse that have Reticle_Status__c as 'Expected'           
    */
global class ROS_BatchRTDW implements Database.Batchable<sObject>{
    
   global String cycleId;
   private List<Reticle_Datawarehouse__c> lRetDw;
   public boolean isTestClass = false;
   public string JOBID;
   global Database.QueryLocator start(Database.BatchableContext BC){
      ROS_GlobalVariables.IsbypassTriggerBatch='true';
         if(!isTestClass){
                 JOBID = BC.getJobId();
                return Database.getQueryLocator('Select Id,Name,CustomerDevice_ID__c,Customer_ID__c,Customer_Name__c,FAB__c,GlobalFoundries_DeviceID__c,Region_Name__c,Reticle_Type__c,ROS_Cycle__c,InactiveDay__c,Device_Type__c from Reticle_Datawarehouse__c where InactiveDay__c > 365 and Job_Id__c=null and Reticle_Status__c <> \'Expected\'');
                
          }else{
                   JOBID = '123';
                return Database.getQueryLocator('Select Id,Name,CustomerDevice_ID__c,Customer_ID__c,Customer_Name__c,FAB__c,GlobalFoundries_DeviceID__c,Region_Name__c,Reticle_Type__c,ROS_Cycle__c,InactiveDay__c,Device_Type__c from Reticle_Datawarehouse__c where InactiveDay__c > 365 and Job_Id__c=null and Reticle_Status__c <> \'Expected\' limit 2');
               
          }        
   }

    global void execute(Database.BatchableContext BC,List<Reticle_Datawarehouse__c> scope) {    
        Id RecType = [Select Id From RecordType Where SobjectType = 'Reticle__c' and DeveloperName = 'Default'].Id;

        if (lRetDw != null) {
            lRetDw.addAll(scope);
        } else {
            lRetDw = new List<Reticle_Datawarehouse__c>();
            lRetDw.addAll(scope);
        }
        
        for(Reticle_DataWareHouse__c eachRETDWH : scope) {
            eachRETDWH.Job_Id__c = BC.getJobId();
        }
        
       String cycleId = [ SELECT Id FROM ROS_Cycle__c WHERE Name = :ROS_Util.getCurrentROSCycle() LIMIT 1 ].Id;  
        System.debug('>>>>>>>>>>>>>>>>>>>>>>>><<<<<<<<<<<<<<<<<<<<<<<< : ' + cycleId );
        
        List<Reticle__c> lReticle = [ SELECT Id,
                                             Name,
                                             Invalid__c,
                                             Invalid_Reason__c 
                                      FROM Reticle__c 
                                      WHERE Job_Id__c = :BC.getJobId() AND Invalid__c = true ];
        
        if (lReticle != null && !lReticle.isEmpty()) {
            ROS_ReticleDatawareHouseBatchHelper.updateInvalidReason(lReticle,scope,BC.getJobId());
            //System.abortJob(BC.getJobId());
            SYSTEM.DEBUG('INVALID DATA FOUND ROLL BACK DATA : ' + lReticle.size());
        } else {
            update scope;

            ROS_ReticleDatawareHouseBatchHelper.ValidateDatawareHouseReticles(scope, RecType, cycleId);
            SYSTEM.DEBUG('NO INVALID DATA : ' + lReticle.size());
        }
    }

    global void finish(Database.BatchableContext BC){
        ROS_GlobalVariables.IsbypassTriggerBatch = 'false';
        
        List<Reticle__c> lReticle = [ SELECT Id
                                           , Invalid__c
                                           , Invalid_Reason__c
                                      FROM Reticle__c 
                                      WHERE Job_Id__c = :BC.getJobId() 
                                          AND Invalid__c = true ];

        if (lReticle != null && !lReticle.isEmpty()) {
            ROS_BATCH_DeleteInvalidReticle batchDelInvalidReticle = new ROS_BATCH_DeleteInvalidReticle(BC.getJobId());
            Database.executeBatch(batchDelInvalidReticle);
        }
        //TODO: SEND FAILURE MAIL.
   }
}