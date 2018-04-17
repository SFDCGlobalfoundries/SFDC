/******************************************************************************************************************************
Class:         ApprovalEscalationBatchforConfigTest
-------------------------------------------------------------------------------------------------------------------------------
Author:        Karna Shiva (GF - 1016934)
Created Date:  06/04/2016
Reason:        This Schedule class will run the ApprovalEscalationBatchConfig batch class
History:       
*******************************************************************************************************************************/

@isTest(SeeAllData=false)
public class ScheduleEscalationBatchConfigTest {

static testmethod void  testschedule() {
   
Test.StartTest();
 ScheduleEscalationBatchConfig sh1 = new ScheduleEscalationBatchConfig();      
  String sch = '0 0 23 * * ?';
  system.schedule('Test check', sch, sh1);
Test.stopTest();
}    
}