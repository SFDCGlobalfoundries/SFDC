@isTest
 private class RetryMRSDRTScheduleTest
 {
 
 static testMethod void schedule_DRTbatch()
 {
    list<Environment_Variable__c> lstEV = new list<Environment_Variable__c>();
    lstEV.add(new Environment_Variable__c(Name='MRSSyncObject', Value__c='MRS'));
    lstEV.add(new Environment_Variable__c(Name='DRTSyncObject', Value__c='DRT'));
    try{
    insert lstEV;
    }catch(exception e){}
   Test.StartTest();
   string CORN_EXP = '0 0 0 1 4 ?';
   RetryDRTSyncSchedulable test1 = new RetryDRTSyncSchedulable();
   string jobid = system.schedule('my batch job', CORN_EXP, new RetryDRTSyncSchedulable() );
   CronTrigger ct = [select id, CronExpression, TimesTriggered, NextFireTime from CronTrigger where id = :jobId];  
   Test.StopTest();
 }
 static testMethod void schedule_DRTbatchDRTChip()
 {
    list<Environment_Variable__c> lstEV = new list<Environment_Variable__c>();
    lstEV.add(new Environment_Variable__c(Name='MRSSyncObject', Value__c='MRS'));
    lstEV.add(new Environment_Variable__c(Name='DRTSyncObject', Value__c='DRTChip'));
    try{
    insert lstEV;
    }catch(exception e){}
    
   Test.StartTest();
   string CORN_EXP = '0 0 0 1 4 ?';
   RetryDRTSyncSchedulable test1 = new RetryDRTSyncSchedulable();
   string jobid = system.schedule('my batch job', CORN_EXP, new RetryDRTSyncSchedulable() );
   CronTrigger ct = [select id, CronExpression, TimesTriggered, NextFireTime from CronTrigger where id = :jobId];  
   Test.StopTest();
 }
 static testMethod void schedule_DRTbatchDRTLayer()
 {
    list<Environment_Variable__c> lstEV = new list<Environment_Variable__c>();
    lstEV.add(new Environment_Variable__c(Name='MRSSyncObject', Value__c='MRS'));
    lstEV.add(new Environment_Variable__c(Name='DRTSyncObject', Value__c='DRTLayer'));
    try{
    insert lstEV;
    }catch(exception e){}
   Test.StartTest();
   string CORN_EXP = '0 0 0 1 4 ?';
   RetryDRTSyncSchedulable test1 = new RetryDRTSyncSchedulable();
   string jobid = system.schedule('my batch job', CORN_EXP, new RetryDRTSyncSchedulable() );
   CronTrigger ct = [select id, CronExpression, TimesTriggered, NextFireTime from CronTrigger where id = :jobId];  
   Test.StopTest();
 }
 static testMethod void schedule_DRTbatchFrameDRT()
 {
    list<Environment_Variable__c> lstEV = new list<Environment_Variable__c>();
    lstEV.add(new Environment_Variable__c(Name='MRSSyncObject', Value__c='MRS'));
    lstEV.add(new Environment_Variable__c(Name='DRTSyncObject', Value__c='FrameDRT'));
    try{
    insert lstEV;
    }catch(exception e){}
   Test.StartTest();
   string CORN_EXP = '0 0 0 1 4 ?';
   RetryDRTSyncSchedulable test1 = new RetryDRTSyncSchedulable();
   string jobid = system.schedule('my batch job', CORN_EXP, new RetryDRTSyncSchedulable() );
   CronTrigger ct = [select id, CronExpression, TimesTriggered, NextFireTime from CronTrigger where id = :jobId];  
   Test.StopTest();
 }
 static testMethod void schedule_DRTbatchDRTPTRF()
 {
    list<Environment_Variable__c> lstEV = new list<Environment_Variable__c>();
    lstEV.add(new Environment_Variable__c(Name='MRSSyncObject', Value__c='MRS'));
    lstEV.add(new Environment_Variable__c(Name='DRTSyncObject', Value__c='DRTPTRF'));
    try{
    insert lstEV;
    }catch(exception e){}
   Test.StartTest();
   string CORN_EXP = '0 0 0 1 4 ?';
   RetryDRTSyncSchedulable test1 = new RetryDRTSyncSchedulable();
   string jobid = system.schedule('my batch job', CORN_EXP, new RetryDRTSyncSchedulable() );
   CronTrigger ct = [select id, CronExpression, TimesTriggered, NextFireTime from CronTrigger where id = :jobId];  
   Test.StopTest();
 }
 static testMethod void schedule_DRTbatchDRTLayerChip()
 {
    list<Environment_Variable__c> lstEV = new list<Environment_Variable__c>();
    lstEV.add(new Environment_Variable__c(Name='MRSSyncObject', Value__c='MRS'));
    lstEV.add(new Environment_Variable__c(Name='DRTSyncObject', Value__c='DRTLayerChip'));
    try{
    insert lstEV;
    }catch(exception e){}
   Test.StartTest();
   string CORN_EXP = '0 0 0 1 4 ?';
   RetryDRTSyncSchedulable test1 = new RetryDRTSyncSchedulable();
   string jobid = system.schedule('my batch job', CORN_EXP, new RetryDRTSyncSchedulable() );
   CronTrigger ct = [select id, CronExpression, TimesTriggered, NextFireTime from CronTrigger where id = :jobId];  
   Test.StopTest();
 }
 static testMethod void schedule_DRTbatchDRTdotNET()
 {
    list<Environment_Variable__c> lstEV = new list<Environment_Variable__c>();
    lstEV.add(new Environment_Variable__c(Name='MRSSyncObject', Value__c='MRS'));
    lstEV.add(new Environment_Variable__c(Name='DRTSyncObject', Value__c='DRTdotNET'));
   try{
    insert lstEV;
    }catch(exception e){}
   Test.StartTest();
   string CORN_EXP = '0 0 0 1 4 ?';
   RetryDRTSyncSchedulable test1 = new RetryDRTSyncSchedulable();
   string jobid = system.schedule('my batch job', CORN_EXP, new RetryDRTSyncSchedulable() );
   CronTrigger ct = [select id, CronExpression, TimesTriggered, NextFireTime from CronTrigger where id = :jobId];  
   Test.StopTest();
 }
 static testMethod void schedule_DRTbatchDRTPackage()
 {
    list<Environment_Variable__c> lstEV = new list<Environment_Variable__c>();
    lstEV.add(new Environment_Variable__c(Name='MRSSyncObject', Value__c='MRS'));
    lstEV.add(new Environment_Variable__c(Name='DRTSyncObject', Value__c='DRTPackage'));
    try{
    insert lstEV;
    }catch(exception e){}
   Test.StartTest();
   string CORN_EXP = '0 0 0 1 4 ?';
   RetryDRTSyncSchedulable test1 = new RetryDRTSyncSchedulable();
   string jobid = system.schedule('my batch job', CORN_EXP, new RetryDRTSyncSchedulable() );
   CronTrigger ct = [select id, CronExpression, TimesTriggered, NextFireTime from CronTrigger where id = :jobId];  
   Test.StopTest();
 }
 
 static testMethod void RetryMRSSyncSchedulableTest()
 {
    list<Environment_Variable__c> lstEV = new list<Environment_Variable__c>();
    lstEV.add(new Environment_Variable__c(Name='MRSSyncObject', Value__c='MRS'));
    lstEV.add(new Environment_Variable__c(Name='DRTSyncObject', Value__c='DRT'));
    try{
    insert lstEV;
    }catch(exception e){}
   Test.StartTest();
   string CORN_EXP = '0 0 0 1 4 ?';
   RetryMRSSyncSchedulable test1 = new RetryMRSSyncSchedulable();
  string jobid = system.schedule('my batch job', CORN_EXP, new RetryMRSSyncSchedulable() ); 
   Test.StopTest();
 }
 
 static testMethod void RetryMRSSyncSchedulableTestMRSChip()
 {
    list<Environment_Variable__c> lstEV = new list<Environment_Variable__c>();
    lstEV.add(new Environment_Variable__c(Name='MRSSyncObject', Value__c='MRSChip'));
    lstEV.add(new Environment_Variable__c(Name='DRTSyncObject', Value__c='DRT'));
    try{
    insert lstEV;
    }catch(exception e){}
   Test.StartTest();
   string CORN_EXP = '0 0 0 1 4 ?';
   RetryMRSSyncSchedulable test1 = new RetryMRSSyncSchedulable();
  string jobid = system.schedule('my batch job', CORN_EXP, new RetryMRSSyncSchedulable() ); 
   Test.StopTest();
 }
 
 static testMethod void RetryMRSSyncSchedulableTestMRSLayer()
 {
    list<Environment_Variable__c> lstEV = new list<Environment_Variable__c>();
    lstEV.add(new Environment_Variable__c(Name='MRSSyncObject', Value__c='MRSLayer'));
    lstEV.add(new Environment_Variable__c(Name='DRTSyncObject', Value__c='DRT'));
    try{
    insert lstEV;
    }catch(exception e){}
   Test.StartTest();
   string CORN_EXP = '0 0 0 1 4 ?';
   RetryMRSSyncSchedulable test1 = new RetryMRSSyncSchedulable();
  string jobid = system.schedule('my batch job', CORN_EXP, new RetryMRSSyncSchedulable() ); 
   Test.StopTest();
 }
 
 static testMethod void RetryMRSSyncSchedulableTestMRSLayerChip()
 {
    list<Environment_Variable__c> lstEV = new list<Environment_Variable__c>();
    lstEV.add(new Environment_Variable__c(Name='MRSSyncObject', Value__c='MRSLayerChip'));
    lstEV.add(new Environment_Variable__c(Name='DRTSyncObject', Value__c='DRT'));
   try{
    insert lstEV;
    }catch(exception e){}
   Test.StartTest();
   string CORN_EXP = '0 0 0 1 4 ?';
   RetryMRSSyncSchedulable test1 = new RetryMRSSyncSchedulable();
  string jobid = system.schedule('my batch job', CORN_EXP, new RetryMRSSyncSchedulable() ); 
   Test.StopTest();
 }
 
 static testMethod void RetryMRSSyncSchedulableTestMRSNotes()
 {
    list<Environment_Variable__c> lstEV = new list<Environment_Variable__c>();
    lstEV.add(new Environment_Variable__c(Name='MRSSyncObject', Value__c='MRSNotes'));
    lstEV.add(new Environment_Variable__c(Name='DRTSyncObject', Value__c='DRT'));
    try{
    insert lstEV;
    }catch(exception e){}
   Test.StartTest();
   string CORN_EXP = '0 0 0 1 4 ?';
   RetryMRSSyncSchedulable test1 = new RetryMRSSyncSchedulable();
  string jobid = system.schedule('my batch job', CORN_EXP, new RetryMRSSyncSchedulable() ); 
   Test.StopTest();
 }
 
 static testMethod void RetryMRSSyncSchedulableTestMRSLayerStatusdotNET()
 {
    list<Environment_Variable__c> lstEV = new list<Environment_Variable__c>();
    lstEV.add(new Environment_Variable__c(Name='MRSSyncObject', Value__c='MRSLayerStatusdotNET'));
    lstEV.add(new Environment_Variable__c(Name='DRTSyncObject', Value__c='DRT'));
    try{
    insert lstEV;
    }catch(exception e){}
   Test.StartTest();
   string CORN_EXP = '0 0 0 1 4 ?';
   RetryMRSSyncSchedulable test1 = new RetryMRSSyncSchedulable();
  string jobid = system.schedule('my batch job', CORN_EXP, new RetryMRSSyncSchedulable() ); 
   Test.StopTest();
 }
 
 static testMethod void RetryMRSSyncSchedulableTestMRSPrimeFramedotNET()
 {
    list<Environment_Variable__c> lstEV = new list<Environment_Variable__c>();
    lstEV.add(new Environment_Variable__c(Name='MRSSyncObject', Value__c='MRSPrimeFramedotNET'));
    lstEV.add(new Environment_Variable__c(Name='DRTSyncObject', Value__c='DRT'));
    try{
    insert lstEV;
    }catch(exception e){}
   Test.StartTest();
   string CORN_EXP = '0 0 0 1 4 ?';
   RetryMRSSyncSchedulable test1 = new RetryMRSSyncSchedulable();
  string jobid = system.schedule('my batch job', CORN_EXP, new RetryMRSSyncSchedulable() ); 
   Test.StopTest();
 }
 
 static testMethod void RetryMRSSyncSchedulableTestMRSPackage()
 {
    list<Environment_Variable__c> lstEV = new list<Environment_Variable__c>();
    lstEV.add(new Environment_Variable__c(Name='MRSSyncObject', Value__c='MRSPackage'));
    lstEV.add(new Environment_Variable__c(Name='DRTSyncObject', Value__c='DRT'));
    try{
    insert lstEV;
    }catch(exception e){}
   Test.StartTest();
   string CORN_EXP = '0 0 0 1 4 ?';
   RetryMRSSyncSchedulable test1 = new RetryMRSSyncSchedulable();
  string jobid = system.schedule('my batch job', CORN_EXP, new RetryMRSSyncSchedulable() ); 
   Test.StopTest();
 }
 
 static testMethod void RetryMRSSyncSchedulableTestFrameDisapprove()
 {
    list<Environment_Variable__c> lstEV = new list<Environment_Variable__c>();
    lstEV.add(new Environment_Variable__c(Name='MRSSyncObject', Value__c='FrameDisapprove'));
    lstEV.add(new Environment_Variable__c(Name='DRTSyncObject', Value__c='DRT'));
    try{
    insert lstEV;
    }catch(exception e){}
   Test.StartTest();
   string CORN_EXP = '0 0 0 1 4 ?';
   RetryMRSSyncSchedulable test1 = new RetryMRSSyncSchedulable();
  string jobid = system.schedule('my batch job', CORN_EXP, new RetryMRSSyncSchedulable() ); 
   Test.StopTest();
 }
 
 static testMethod void RetryMRSSyncSchedulableTestTapeoutApp()
 {
    list<Environment_Variable__c> lstEV = new list<Environment_Variable__c>();
    lstEV.add(new Environment_Variable__c(Name='MRSSyncObject', Value__c='TapeoutApp'));
    lstEV.add(new Environment_Variable__c(Name='DRTSyncObject', Value__c='DRT'));
    try{
    insert lstEV;
    }catch(exception e){}
   Test.StartTest();
   string CORN_EXP = '0 0 0 1 4 ?';
   RetryMRSSyncSchedulable test1 = new RetryMRSSyncSchedulable();
  string jobid = system.schedule('my batch job', CORN_EXP, new RetryMRSSyncSchedulable() ); 
   Test.StopTest();
 }
 
 static testMethod void RetryMRSSyncSchedulableTestFabDistri()
 {
    list<Environment_Variable__c> lstEV = new list<Environment_Variable__c>();
    lstEV.add(new Environment_Variable__c(Name='MRSSyncObject', Value__c='FabDistri'));
    lstEV.add(new Environment_Variable__c(Name='DRTSyncObject', Value__c='DRT'));
    try{
    insert lstEV;
    }catch(exception e){}
   Test.StartTest();
   string CORN_EXP = '0 0 0 1 4 ?';
   RetryMRSSyncSchedulable test1 = new RetryMRSSyncSchedulable();
  string jobid = system.schedule('my batch job', CORN_EXP, new RetryMRSSyncSchedulable() ); 
   Test.StopTest();
 }
 
 static testMethod void RetryMRSSyncSchedulableTestMST()
 {
    list<Environment_Variable__c> lstEV = new list<Environment_Variable__c>();
    lstEV.add(new Environment_Variable__c(Name='MRSSyncObject', Value__c='MST'));
    lstEV.add(new Environment_Variable__c(Name='DRTSyncObject', Value__c='DRT'));
    try{
    insert lstEV;
    }catch(exception e){}
   Test.StartTest();
   string CORN_EXP = '0 0 0 1 4 ?';
   RetryMRSSyncSchedulable test1 = new RetryMRSSyncSchedulable();
  string jobid = system.schedule('my batch job', CORN_EXP, new RetryMRSSyncSchedulable() ); 
   Test.StopTest();
 }
 
 static testMethod void RetryMRSSyncSchedulableTestMSTConfig()
 {
    list<Environment_Variable__c> lstEV = new list<Environment_Variable__c>();
    lstEV.add(new Environment_Variable__c(Name='MRSSyncObject', Value__c='MSTConfig'));
    lstEV.add(new Environment_Variable__c(Name='DRTSyncObject', Value__c='DRT'));
    try{
    insert lstEV;
    }catch(exception e){}
   Test.StartTest();
   string CORN_EXP = '0 0 0 1 4 ?';
   RetryMRSSyncSchedulable test1 = new RetryMRSSyncSchedulable();
  string jobid = system.schedule('my batch job', CORN_EXP, new RetryMRSSyncSchedulable() ); 
   Test.StopTest();
 }
  // Test method for Out of sync error email
    @istest (SeeAllData=true)
 static void RetyFabDistriSyncOracleBatchableEmailUnitTest() 
    {  
          
          try
          {
          list<Environment_Variable__c> lstEV = new list<Environment_Variable__c>();
          lstEV=[select name,value__c from Environment_Variable__c where name ='SWIFT_ADMIN_EMAIL'];
          if(lstEV.size()>0){
          lstEV[0].value__c = lstEV[0].value__c+';'+'swiftadmin@gfoundries.com';
          update lstEV[0];
          }
          Mask_Set_Title__c mst = new Mask_Set_Title__c(Name='YTREWQY',
                                                       Description__c='Test Description for MST',
                                                       Synced_with_Oracle_DB__c=false,
                                                       Status__c='Active',
                                                       Is_Available_For_Use__c=true
                                                       //createddate=Datetime.newInstance(2014, 28 , 07, 12,1,5), //System.now().adddays(-2),//DateTime.parse('07/29/2014 06:40 PM'),
                                                       //lastmodifieddate=Datetime.newInstance(2014, 28 , 07, 12,1,5)
                                                       );
          insert mst;
          PTRF__c ptrf = new PTRF__c(Name='ACOU001',
                                     MaskSetTitle__c =mst.Id,
                                     Order_Type__c = 'testOrder001',
                                     //Synced_with_Oracle_DB__c=false,
                                     Recticle_Type__c='Multi Layer Reticle (MLR)',
                                     Customer_jobview__c='Gating Mask Release'
                                     //createddate=System.now().adddays(-2),
                                     //lastmodifieddate=System.now().adddays(-1)
                                     );
          insert ptrf;
          
          MRS__c mrs = new MRS__c(Full_Sync__c =true,
                                   Synced_with_Oracle_DB__c=false,
                                   MRS_Package_Sync__c=false,
                                   Mask_Set_Title__c=mst.Id
                                   //createddate=System.now().adddays(-2),
                                   //lastmodifieddate=System.now().adddays(-1)
                                   );
          insert mrs;   
          MRS__c mrs2 = new MRS__c(Full_Sync__c =true,
                                   Synced_with_Oracle_DB__c=false,
                                   MRS_Package_Sync__c=false,
                                   Mask_Set_Title__c=mst.Id
                                   //createddate=System.now().adddays(-2),
                                   //lastmodifieddate=System.now().adddays(-1)
                                   );
          insert mrs2; 
          
          MRS_Layer_Association__c mrsLayer = new MRS_Layer_Association__c(Name ='layer001',
                                                                           Synced_with_Oracle_DB__c=false,
                                                                           Mask_Layer_Rev__c = '899',
                                                                           Layer_Name__c = 'testLayer001',
                                                                           Layer_Status__c = 'Not Ready',
                                                                           mrs__c = mrs.id
                                                                           //createddate=System.now().adddays(-2),
                                                                           //lastmodifieddate=System.now().adddays(-1)
                                                                           );
          insert mrslayer;  
                                                                                                                                                    
          MRS_Chip_Details__c mrsChip = new MRS_Chip_Details__c(Name='chip001',
                                                                Synced_with_Oracle_DB__c=false,
                                                                mrs__c = mrs.id
                                                                //createddate=System.now().adddays(-2),
                                                                //lastmodifieddate=System.now().adddays(-2)
                                                                );
          insert mrsChip;  
          
          MST_Config__c mstconfig=new MST_Config__c(Mask_Set_Title__c=mst.Id,Synced_with_Oracle_DB__c = false);
          insert mstconfig;
          
          MRS_Layer_Chip_Association__c layerChip = new MRS_Layer_Chip_Association__c(Name='layerChip001',
                                                                                      Synced_with_Oracle_DB__c=false,
                                                                                      //createddate=System.now().adddays(-2),
                                                                                      //lastmodifieddate=System.now().adddays(-1),
                                                                                      Layer__c=mrsLayer.Id,
                                                                                      Chip__c=mrsChip.Id,
                                                                                      PTRF__c=ptrf.Id,
                                                                                      All_Send_Frame_Done__c = TRUE,
                                                                                      All_Send_Prime_Done__c=TRUE,
                                                                                      Sync_PTRF_Layer_SendPrimeFrame_dotNET__c = false);
          
         
          insert layerChip;
          
          MRS_Layer_Chip_Association__c layerChip1 = new MRS_Layer_Chip_Association__c(Name='layerChip002',
                                                                                      Synced_with_Oracle_DB__c=false,
                                                                                      //createddate=System.now().adddays(-2),
                                                                                      //lastmodifieddate=System.now().adddays(-1),
                                                                                      Layer__c=mrsLayer.Id,
                                                                                      Chip__c=mrsChip.Id,
                                                                                      PTRF__c=ptrf.Id,
                                                                                      All_Send_Frame_Done__c = TRUE,
                                                                                      All_Send_Prime_Done__c=TRUE,
                                                                                      Sync_PTRF_Layer_SendPrimeFrame_dotNET__c = false);
          
         
          insert layerChip1;
          
          Fab_Distribution_Table__c febDisTab=new Fab_Distribution_Table__c(Fab_No__c='FAB 1',Distribution_List__c='Test011',Synced_with_Oracle_DB__c = false,Trigger_Oracle_DB_Sync_Manual__c=false,isDeleted__c=false);
          insert febDisTab;
          
          Notes__c notes=new Notes__c(Synced_with_Oracle_DB__c = false,MRS_Layer_Association__c=mrslayer.Id,ParentId__c=layerChip.Id);
          insert notes;
          
          Tapeout_Applications_MEBES_Jobview_Confi__c TapAppMeb=new Tapeout_Applications_MEBES_Jobview_Confi__c(Synced_with_Oracle_DB__c = false,Tapeout_Application_Jobview__c='Test001');
          insert TapAppMeb;
          
          //List<AsyncApexJob> aajList = [ select id,Status from AsyncApexJob];
          //  for ( AsyncApexJob aaj : aajList ) {
          //      //System.abortJob(aaj.id);
          //  }
          RetyFabDistriSyncOracleBatchable reassign = new RetyFabDistriSyncOracleBatchable();
          reassign.Query='SELECT Id, Name FROM Fab_Distribution_Table__c WHERE Synced_with_Oracle_DB__c = false AND LastModifieddate > Today';
          reassign.Field = 'Trigger_Oracle_DB_Sync_Manual__c';
          reassign.Value = false;
          Test.StartTest();
          ID batchprocessid = Database.executeBatch(reassign);
          Test.StopTest(); 
           }
           catch(exception e){}   
    }
  @istest (SeeAllData=true)
  static void RetryDRTpackageSyncOracleBatchableEmailUnitTest() 
    {  
          
          try
          {
          Mask_Set_Title__c mst = new Mask_Set_Title__c(Name='YTREWQJ',
                                                       Description__c='Test Description for MST',
                                                       Synced_with_Oracle_DB__c=false,
                                                       Status__c='Active',
                                                       Is_Available_For_Use__c=true
                                                       //createddate=Datetime.newInstance(2014, 28 , 07, 12,1,5), //System.now().adddays(-2),//DateTime.parse('07/29/2014 06:40 PM'),
                                                       //lastmodifieddate=Datetime.newInstance(2014, 28 , 07, 12,1,5)
                                                       );
          insert mst;
          DRT__c drt=new DRT__c(name='ytrewq',Mask_Set_Title__c=mst.Id,DRT_Package_Sync__c=false,Synced_with_Oracle_DB__c = false);
          insert drt;
          
          DRT__c drt2=new DRT__c(name='ykxewq',Mask_Set_Title__c=mst.Id,DRT_Package_Sync__c=false,Synced_with_Oracle_DB__c = false);
          insert drt2;
          PTRF__c ptrf = new PTRF__c(Name='ACOU001',
                                     MaskSetTitle__c =mst.Id,
                                     Order_Type__c = 'testOrder001',
                                     //Synced_with_Oracle_DB__c=false,
                                     Recticle_Type__c='Multi Layer Reticle (MLR)',
                                     Customer_jobview__c='Gating Mask Release'
                                     //createddate=System.now().adddays(-2),
                                     //lastmodifieddate=System.now().adddays(-1)
                                     );
          insert ptrf;
          
          PRIME_DRT_Chip_Association__c pdrtchip=new PRIME_DRT_Chip_Association__c(Name='Primedrt001',Mask_Set_Title__c=mst.Id,DRT__c=drt.Id,Synced_with_Oracle_DB__c = false);

          insert pdrtchip;
          PRIME_DRT_Layer_Association__c primedrtlayerasso=new PRIME_DRT_Layer_Association__c(name='Test001',DRT__c=drt.Id,Synced_with_Oracle_DB__c = false);
          try{
          insert primedrtlayerasso;
          }catch(exception e){}
          
          Frame_DRT_Association__c frmdrtassociation=new Frame_DRT_Association__c(DRT__c=drt.Id,Mask_Set_Title__c=mst.Id,Synced_with_Oracle_DB__c = false);
          insert frmdrtassociation;
          PRIME_DRT_Chip_Layer_Summary__c primedrtSummary=new PRIME_DRT_Chip_Layer_Summary__c(Synced_with_Oracle_DB__c = false,
                                   Chip__c=pdrtchip.Id,Layer__c=primedrtlayerasso.id);
          insert primedrtSummary;
          
          //List<AsyncApexJob> aajList = [ select id,Status from AsyncApexJob];
          //  for ( AsyncApexJob aaj : aajList ) {
          //      //System.abortJob(aaj.id);
          //  }
          RetryDRTpackageSyncOracleBatchable reassign = new RetryDRTpackageSyncOracleBatchable();
          reassign.Query='SELECT Id, Name FROM DRT__c WHERE DRT_Package_Sync__c=TRUE and Synced_with_Oracle_DB__c = false AND LastModifiedDate > TODAY';
          reassign.Field = 'Trigger_Oracle_DB_FullPackageSync_Manual__c';
          reassign.Value = false;
          Test.StartTest();
          ID batchprocessid = Database.executeBatch(reassign);
          Test.StopTest(); 
           }
           catch(exception e){}   
    }   
}