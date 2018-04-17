/*
    Author:
    Description: This is a test class for DeleteCPQMLGErrorLog class. 
    History:
        ARoy        05252015    - code created.
*/
        
@isTest(SeeAllData=false)                               
public class DeleteCPQMLGErrorLogTest {

   static testmethod void testCPQMLGErrorLog() {
      
      CPQ_MLGPLUS__c cpqMlgplus = new CPQ_MLGPLUS__c();
      cpqMlgplus.Status__c = 'Unprocessed';
      insert cpqMlgplus;
      
      CPQ_MLG_Error_Log__c cmel = new CPQ_MLG_Error_Log__c();
      cmel.Error_Type__c = 'File Format Error';
      cmel.Error_Description__c = 'Test Error';
      insert cmel;
      
      Test.startTest();
          DeleteCPQMLGErrorLog delBatch = new DeleteCPQMLGErrorLog();
          Id BatchProcessId = Database.ExecuteBatch(delBatch);           
      Test.stopTest();  
   }
}