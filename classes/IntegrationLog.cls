/*
  Author: Nino Bustillos
  Description: This class is used to insert the log for Siebel Integration.
  History:
    Nbustillos        12052012    - code creation.
    ARoy              03122013    - updation of IntegrationLogWrapper class and addIntegrationLogList method.     

*/


public with sharing class IntegrationLog{
//  Used to track the AIA Siebel integration transactions
//   This should be used to track histrical intgration issues for debugging and SLA analysis

    // Add a new integration log entry
    public static void addIntegrationLog(
            String ObjectName, 
            String SFDC_Row_ID, 
            String Siebel_Sync_ID,
            String Siebel_Error_Message,
            String Siebel_Operation,
            String Siebel_Status,
            DateTime StartTime )  {
            
     
      Try {
          String IntegrationID = SFDC_Row_ID + '-' + Siebel_Sync_ID;
          Integer errorCount = 0;
          if (Siebel_Status.contains('ERROR')) {
              errorCount = 1;
              // Find the previous errors to increment the count
              List<IntegrationLog__c> lastLogs = [Select SFDC_Row_ID__c, ErrorCount__c, LastModifiedDate 
                  FROM IntegrationLog__c 
                  WHERE SFDC_Row_ID__c = :SFDC_Row_ID AND Siebel_Status__c='ERROR'
                  ORDER BY LastModifiedDate DESC
                  LIMIT 1];
              System.debug (lastLogs);
              if (lastLogs.size() > 0 && lastLogs[0].ErrorCount__c != null) {
                  errorCount = errorCount + Integer.valueof(lastLogs[0].ErrorCount__c);
              } 
          }
          IntegrationLog__c intLog = new IntegrationLog__c (
                    IntegrationID__c = IntegrationID ,
                    Object__c  = ObjectName, 
                    SFDC_Row_ID__c  = SFDC_Row_ID,
                    Siebel_Error_Message__c = Siebel_Error_Message,
                    Siebel_Operation__c = Siebel_Operation,
                    Siebel_Status__c = Siebel_Status,
                    StartTime__c = StartTime,
                    ErrorCount__c = errorCount  );
          insert (intLog);
          
      } Catch (Exception ex){
      }
      
    
    }
    
    //New method to take a list of IntegrationLogWrapper objects and adds in integration log file
    public static void addIntegrationLogList(List<IntegrationLogWrapper> intLogWrpList){
        Try {
            // If the IntegrationLogWrapper list is not empty
            if(intLogWrpList.size()>0){
                
                // variable initialization
                List<IntegrationLog__c> intLogList = new List<IntegrationLog__c>();
                List<String> sfdcRwIdList = new List<String>();
                Map<String,Decimal> sfdcRowIdMap = new Map<String,Decimal>();
                
                // List of SFDC Row Id where status is 'ERROR'
                for(IntegrationLogWrapper intLogWp:intLogWrpList){
                   if (intLogWp.Siebel_Status.contains('ERROR')) {
                       sfdcRwIdList.add(intLogWp.SFDC_Row_ID);
                   }  
                }
                // Query to find the records with Siebel Status = 'ERROR'
                List<IntegrationLog__c> lastLogs = [Select SFDC_Row_ID__c, ErrorCount__c, LastModifiedDate
                                   FROM IntegrationLog__c 
                                   WHERE SFDC_Row_ID__c = :sfdcRwIdList AND Siebel_Status__c='ERROR'
                                   ORDER BY LastModifiedDate Desc];
                System.debug (lastLogs);
                
                //variables initialization and adding to the map the latest values of the Error count 
                //according to last modified date
                Map<String,DateTime> sfdcRowIdLDMap = new Map<String,DateTime>();
                for(IntegrationLog__c intLog:lastLogs){
                    if(!(sfdcRowIdLDMap.containsKey(intLog.SFDC_Row_ID__c))){                        
                        sfdcRowIdLDMap.put(intLog.SFDC_Row_ID__c,intLog.LastModifiedDate);
                        sfdcRowIdMap.put(intLog.SFDC_Row_ID__c,intLog.ErrorCount__c);
                    }
                    if(sfdcRowIdLDMap.containsKey(intLog.SFDC_Row_ID__c)){
                        if(((DateTime)(sfdcRowIdLDMap.get(intLog.SFDC_Row_ID__c))).getTime() < (intLog.LastModifiedDate).getTime()){
                            sfdcRowIdLDMap.put(intLog.SFDC_Row_ID__c,intLog.LastModifiedDate);
                            sfdcRowIdMap.put(intLog.SFDC_Row_ID__c,intLog.ErrorCount__c);
                        }
                    }
                }
                
                // Iterating through the IntegrationLogWrapper list to populate the Integration List
                for(IntegrationLogWrapper intLogWp:intLogWrpList){
                    String IntegrationID = intLogWp.SFDC_Row_ID + '-' + intLogWp.Siebel_Sync_ID;
                    Integer errorCount = 0;
                    // Checking the values whose Siebel Status = 'ERROR'
                    if (intLogWp.Siebel_Status.contains('ERROR')) {
                       errorCount = 1;
                       // Find the previous errors to increment the count
                       if (sfdcRowIdMap.containsKey(intLogWp.SFDC_Row_ID) && sfdcRowIdMap.get(intLogWp.SFDC_Row_ID) != null) {
                          errorCount = errorCount + Integer.valueof(sfdcRowIdMap.get(intLogWp.SFDC_Row_ID));
                       } 
                    }
                    // Initializing the IntegrationLog object
                    IntegrationLog__c intLog = new IntegrationLog__c (
                                                    IntegrationID__c = IntegrationID ,
                                                    Object__c  = intLogWp.ObjectName, 
                                                    SFDC_Row_ID__c  = intLogWp.SFDC_Row_ID,
                                                    Siebel_Error_Message__c = intLogWp.Siebel_Error_Message,
                                                    Siebel_Operation__c = intLogWp.Siebel_Operation,
                                                    Siebel_Status__c = intLogWp.Siebel_Status,
                                                    StartTime__c = intLogWp.StartTime,
                                                    ErrorCount__c = errorCount  );
                    
                    // Adding the IntegrationLog objects in a list 
                    intLogList.add(intLog);                    
                    
                }
                // Inserting the IntegrationLog object list
                insert intLogList;
        
            }
        } Catch (Exception ex){
        }

    }
    
    //Creation of wrapper class with same fields as addIntegrationLog
    public class IntegrationLogWrapper{
        String ObjectName {get; set;}
        String SFDC_Row_ID {get; set;}
        String Siebel_Sync_ID {get; set;}
        String Siebel_Error_Message {get; set;}
        String Siebel_Operation {get; set;}
        String Siebel_Status {get; set;}
        DateTime StartTime {get; set;}
        
        public IntegrationLogWrapper(
                    String ObjectName, 
                    String SFDC_Row_ID, 
                    String Siebel_Sync_ID,
                    String Siebel_Error_Message,
                    String Siebel_Operation,
                    String Siebel_Status,
                    DateTime StartTime){
                    
            this.ObjectName = ObjectName;
            this.SFDC_Row_ID = SFDC_Row_ID;
            this.Siebel_Sync_ID = Siebel_Sync_ID;
            this.Siebel_Error_Message = Siebel_Error_Message;
            this.Siebel_Operation = Siebel_Operation;
            this.Siebel_Status = Siebel_Status;
            this.StartTime = StartTime;
        }  
    }
    
    @isTest(SEEALLDATA = false)
    private static void testAddIntegrationLog(){
    
        DateTime startTime = DateTime.now().addSeconds(-3);
        String sfdcRowId = '003askskd';
        String SiebelErrorMsg = 'Unable to Sync';
        addIntegrationLog('Opportunity',sfdcRowId , '2012-12-12-30440', SiebelErrorMsg , 'Insert', 'ERROR',startTime);
        //         String ObjectName, 
        //        String SFDC_Row_ID, 
        //        String Siebel_Sync_ID,
        //        String Siebel_Error_Message,
        //        String Siebel_Operation,
        //        String Siebel_Status,
        //        DateTime StartTime
        List<IntegrationLog__c> lLogs = [select IntegrationID__c,  ErrorCount__c,  SFDC_Row_ID__c,  Siebel_Status__c , Siebel_Error_Message__c 
                    From IntegrationLog__c 
                    Where SFDC_Row_ID__c = :sfdcRowId];
        System.assertEquals(SiebelErrorMsg,   lLogs[0].Siebel_Error_Message__c, 'Integration Log was not created');  
         
        addIntegrationLog('Opportunity',sfdcRowId , '2012-12-12-30555', SiebelErrorMsg , 'Insert', 'ERROR',startTime);
        lLogs = [select IntegrationID__c,  ErrorCount__c,  SFDC_Row_ID__c,  Siebel_Status__c , Siebel_Error_Message__c, LastModifiedDate  
                    From IntegrationLog__c 
                    Where SFDC_Row_ID__c = :sfdcRowId
                     ORDER BY LastModifiedDate DESC
                      ];
        System.assertEquals(2,   lLogs.size() , 'Integration log not created');  


   }
   
   // Test method for the addIntegrationLogList method where a list of
   // IntegrationLogWrapper objects are taken as arguments
   @isTest(SEEALLDATA = false)
    private static void testAddIntegrationLogList(){
        //Variable declaration
        DateTime startTime = DateTime.now().addSeconds(-3);
        DateTime startTime1 = DateTime.now().addSeconds(-2);
        String sfdcRowId = '003askskd';
        String SiebelErrorMsg = 'Unable to Sync';
        
        //Initializing the IntegrationLogWrapper wrapper class with test data
        IntegrationLog.IntegrationLogWrapper intLogWrp1 
                        = new IntegrationLog.IntegrationLogWrapper('Opportunity',
                                                                    sfdcRowId , 
                                                                    '2012-12-12-30440', 
                                                                    SiebelErrorMsg , 
                                                                    'Insert', 
                                                                    'ERROR',
                                                                    startTime);
                                                                    
        IntegrationLog.IntegrationLogWrapper intLogWrp2 
                        = new IntegrationLog.IntegrationLogWrapper('Opportunity',
                                                                    sfdcRowId , 
                                                                    '2012-12-12-30555', 
                                                                    SiebelErrorMsg , 
                                                                    'Insert', 
                                                                    'ERROR',
                                                                    startTime1);                                                                    
                                                                    
        List<IntegrationLog.IntegrationLogWrapper> intLogWrpList 
                                = new List<IntegrationLog.IntegrationLogWrapper>();
        intLogWrpList.add(intLogWrp1);
        
        //Invoking the method of wrapper class to populate the List of wrapper objects
        addIntegrationLogList(intLogWrpList);                                                                                                   
        
        List<IntegrationLog__c> lLogs = [select IntegrationID__c,  ErrorCount__c,  SFDC_Row_ID__c,  Siebel_Status__c , Siebel_Error_Message__c 
                    From IntegrationLog__c 
                    Where SFDC_Row_ID__c = :sfdcRowId];
        System.assertEquals(SiebelErrorMsg,   lLogs[0].Siebel_Error_Message__c, 'Integration Log was not created');  
         
        //Removing the previous values from the list
        intLogWrpList.clear();
        intLogWrpList.add(intLogWrp2);
        
        //Invoking the method of wrapper class to populate the List of wrapper objects
        addIntegrationLogList(intLogWrpList);
        
        lLogs = [select IntegrationID__c,  ErrorCount__c,  SFDC_Row_ID__c,  Siebel_Status__c , Siebel_Error_Message__c, LastModifiedDate  
            From IntegrationLog__c 
            Where SFDC_Row_ID__c = :sfdcRowId
             ORDER BY LastModifiedDate DESC
              ];
        System.assertEquals(2,   lLogs.size() , 'Integration log not created');  


   }
  
}