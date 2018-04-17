@isTest(SeeAllData=false)
private class FV_SendReceiveATPdataServiceTest
{
  
  static testMethod void testUserAccInfo()
  {
   DataUtilTest.loadEnvironmentVariables();
   FV_SendReceiveATPdataService.ImpersonationDataWrapper objWrapper = new FV_SendReceiveATPdataService.ImpersonationDataWrapper();
   
   list<FV_SendReceiveATPdataService.ImpersonationDataWrapper> lstWrapper = new list<FV_SendReceiveATPdataService.ImpersonationDataWrapper>();
   
   objWrapper.sfId='123456';
   objWrapper.userShortname='e123';
   objWrapper.accountsShortName='Acc1';
   lstWrapper.add(objWrapper);
   
   Internal_Impersonation_Mapping__c obj=new Internal_Impersonation_Mapping__c();
   obj.User_Shortname__c='e123';
   obj.Accounts_ShortName__c='';
   obj.Sync_Needed__c =True;
   insert obj;
   
   Test.startTest();
   FV_SendReceiveATPdataService.getUserAccInfo();
   test.StopTest();
  }
  
  static testMethod void testUpdateSyncwithOTStatus()
  {
   DataUtilTest.loadEnvironmentVariables();
   FV_SendReceiveATPdataService.OtStatusWrapper objWrapper = new FV_SendReceiveATPdataService.OtStatusWrapper ();
   
   list<FV_SendReceiveATPdataService.OtStatusWrapper> lstWrapper = new list<FV_SendReceiveATPdataService.OtStatusWrapper>();
   
   Internal_Impersonation_Mapping__c obj=new Internal_Impersonation_Mapping__c();
   obj.User_Shortname__c='e123';
   obj.Accounts_ShortName__c='';
   obj.Sync_Needed__c =True;
   insert obj;
   
   objWrapper.sfId=obj.Id;
   objWrapper.syncwthOT=True;
   objWrapper.otErrorMsg=null;
   
   lstWrapper.add(objWrapper);
   
   
   
   Test.startTest();
   FV_SendReceiveATPdataService.updateSyncwithOTStatus(lstWrapper);
   test.StopTest();
  }
  
}