@isTest
public class MCMQuarterlyVolumeExtTest {

    static testmethod void Test1(){
         MCMDataUtilTest.testdata();      
         User admin = DeviceChecklistTestDataUtils.createUserWithDCAdmin('System Administrator');
        System.runAs(admin){
            IntegrationUsers__c skipUser = new IntegrationUsers__c(SetupOwnerId = admin.Id, Is_Integration_User__c= true, Skip_Trigger__c = true, Skip_Validation_Rule__c = true);
            insert skipUser;
     
        string acctId = getAccount('MYTEST ACCOUNT').id;
        string opptyId = MCMDataUtilTest.createOpp(acctId);
        string opptyProgramId = MCMDataUtilTest.createOppProg(acctId,opptyId);
         // Create Device
        List<Device__c> devices = new List<Device__c>();
        Device__c deviceGood = MCMdataUtilTest.createGoodDevice(acctId,opptyProgramId);
        devices.add(deviceGood);    
       test.startTest();
         MCMController mcmCont = new MCMController();
    
        mcmCont.mcmDetailObj.Device__c = deviceGood.id;
        mcmCont.mcmDetailObj.Fab__c ='FAB 9';
        mcmCont.mcmDetailObj.Test_Platform__c ='66XX512_M';
        mcmCont.mcmDetailObj.Burn_In_Platform__c= 'ABES_IV';
        mcmCont.mcmDetailObj.Number_of_Sockets_Per_Boards__c=  3;
        mcmCont.mcmDetailObj.No_of_DUTS__c='16';
        mcmCont.mcmDetailObj.Actual_Tapeout_Date_FAB_9_and_FAB_10__c = date.newInstance(2017,1,1);
        mcmCont.mcmDetailObj.User_Defined_Time__c= 50;
         PageReference pg = Page.MCMDetailPage;
             ApexPages.CurrentPage().getParameters().put('Id',deviceGood.Id);
        mcmCont.SaveMCMData();
        
        PCM_MCM_Detail__c mcm = [Select id from PCM_MCM_Detail__c where device__c=:deviceGood.id];
          list<MCM_Quarterly_Volume__c> lstQ = new list<MCM_Quarterly_Volume__c>(); 
           MCM_Quarterly_Volume__c conQ1 = new MCM_Quarterly_Volume__c(PCM_MCM_Detail__c=mcm.Id,Year__c=2017,Q1_Volume__c=10,Q2_Volume__c=20,Q3_Volume__c=30,Q4_Volume__c=40);
           lstQ.add(conQ1);
           insert lstQ;
        
           PCM_Administration__c pcmadmin = new PCM_Administration__c(Name = 'CURRENT_SETTING',Version_ID__c='1',PCM_Fabs__c='FAB 2,FAB 8,FAB 9,FAB 10',Catalog_ID__c='PCM215');
           insert pcmadmin;
        
        ApexPages.CurrentPage().getParameters().put('Id',deviceGood.Id);
         ApexPages.CurrentPage().getHeaders().put('Referer','GlobalfoundryView');
           MCMQuaterlyVolumeExt controll = new MCMQuaterlyVolumeExt();
           controll.addRow();
           controll.deleteRows();
           controll.SaveQuarterlyVolume();
           controll.redirectToMCMDetail();
           controll.thisQuarter = 1;
          test.stopTest();  
        }   
    }
      private static Account getAccount(string AccountName)
    {
        Account acct = [SELECT Id, Name FROM Account Where Name =: AccountName];
        
        return acct;
    }
}