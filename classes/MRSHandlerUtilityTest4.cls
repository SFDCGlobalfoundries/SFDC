@istest(SeeAllData=false)
private class MRSHandlerUtilityTest4 {
  
    /**
    This method initialize data using throughout this test class.
    The create data method are: 
    - SwiftDataUtilityTest.customSystemData();
    @author    SWIFT TEAM
    @since    7-April-2015
    */
    @testSetup static void setup() {
        Test.startTest();
        
        SwiftDataUtilityTest.customSystemData();
        
        Profile sysAdminProfile = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
        User userSA = new User(alias = 'testMRS', email='testMRS@test.com',
        emailencodingkey='UTF-8', lastname='testMRSLast', firstname='testMRSFirst', languagelocalekey='en_US',
        localesidkey='en_US', profileid = sysAdminProfile.Id,
        timezonesidkey='America/Los_Angeles', username='testMRS@test.com',communitynickname='testMRS');
        insert userSA;
        
        Account acc = SwiftDataUtilityTest.createTestAccount();
        Mask_Set_Title__c objMST = SwiftDataUtilityTest.createMST('MST001');
        insert objMST;
        
        MRS__c objMRS = new MRS__c(Mask_Set_Title__c=objMST.Id);
        insert objMRS;
        
        Account_Team_Proxy__c atp = new Account_Team_Proxy__c(User__c = userSA.id,Account__c=acc.id,Account_Access__c='Read/Write',
            Opportunity_Access__c='Read/Write',Team_Role__c='Primary Customer Service Rep',Sequence_No__c='1',Account_Role_ID__c='test1239');       
        insert atp;
        
        Test.stopTest();
    }
    
    /**
        This test method sets All the Layer Chip values.
        @method name: setLayerChipFlagValues
        @parameter:   MRS_Layer_Chip_Association__c object.
        @return :     MRS_Layer_Chip_Association__c object.
     **/    

    public static MRS_Layer_Chip_Association__c setLayerChipFlagValues(MRS_Layer_Chip_Association__c objLayerChip){
        objLayerChip.Is_Customer_GDSOUT_Review_Updated__c=true;
        objLayerChip.Is_Foundry_GDSOUT_Review_Updated__c=true;
        objLayerChip.Is_Customer_Frame_Mockup_Updated__c=true;
        objLayerChip.Is_Foundry_Frame_Mockup_Updated__c=true;
        objLayerChip.Is_Send_Prime_Data_Updated__c=true;
        objLayerChip.Is_Send_Frame_Data_Updated__c=true;
        objLayerChip.Is_Customer_Prime_Remote_Jobview_Updated__c=true;
        objLayerChip.Is_Customer_Frame_Remote_Jobview_Updated__c=true;
        objLayerChip.Is_Foundry_Prime_Remote_Jobview_Updated__c=true;
        objLayerChip.Is_Foundry_Frame_Remote_Jobview_Updated__c=true;
        objLayerChip.Is_ORC_Updated__c=true;
        objLayerChip.Is_DRW_Updated__c=true;
        objLayerChip.Is_Prime_MEBES_Received_Updated__c=true;
        objLayerChip.Is_Frame_MEBES_Received_Updated__c=true;
        objLayerChip.Is_Customer_MEBES_Jobview_Updated__c=true;
        objLayerChip.Is_Foundry_MEBES_Jobview_Updated__c=true;
        objLayerChip.Is_Tapeout_Centre_MEBES_Jobview_Updated__c=true;
        objLayerChip.Is_Tapeout_Apps_MEBES_Jobview_Updated__c=true;
        objLayerChip.Is_GlobalShuttle_MEBES_Jobview_Updated__c=true;
        objLayerChip.Is_MDP_MEBES_Jobview_Updated__c=true;
        objLayerChip.Is_TDTI_MPW_MEBES_Jobview_Updated__c=true;
        objLayerChip.Customer_MEBES_Jobview__c='Ready';
        objLayerChip.Foundry_MEBES_Jobview__c='Ready';
        objLayerChip.GlobalShuttle_MEBES_Jobview__c='Ready';
        objLayerChip.MDP_MEBES_Jobview__c='Ready';
        objLayerChip.Tapeout_Centre_MEBES_Jobview__c='Ready';
        objLayerChip.Tapeout_Applications_MEBES_Jobview__c='Ready';
        objLayerChip.TDTI_MPW_MEBES_Jobview__c='Ready';
        return objLayerChip;    
     }
     
    public static testmethod void getJobViewerTest(){
      // comment-out, refactor with testSetup method setup()
        // SwiftDataUtilityTest.customSystemData();
        // Insert Custom Settings Data---//
        //---------------------------------------------//

        Account acc = getAccount('Test Account 009');
        List<Mask_Set_Title__c> mstList = [SELECT Id, Name FROM Mask_Set_Title__c];
        MST_Config__c mstConfig = SwiftDataUtilityTest.createMSTconfig(acc.Id,mstList[0].Id);
        Opportunity opp = SwiftDataUtilityTest.createOpportunityDRT(acc.Id);
        Opportunity_Program__c oppProg = SwiftDataUtilityTest.createOpportunityProgramDRT(acc.Id, opp.Id);
        Process_Technology__c pt = SwiftDataUtilityTest.createProcessTechnologyForDRT();
        test.startTest();
        Device__c testDevice = SwiftDataUtilityTest.createDeviceWithPT(acc.Id, opp.Id,oppProg.Id,pt.Id);
        PTRF__c testPTRF  = SwiftDataUtilityTest.createPTRF_DRT(mstList[0].Id, testDevice.Id);
        
        list<PTRF_JobViewer_Info__c> testPTRFJobviewerInfoList = new list<PTRF_JobViewer_Info__c>();
        PTRF_JobViewer_Info__c testPTRFJobviewerInfo = new PTRF_JobViewer_Info__c(PTRF__c = testPTRF.Id, Jobview__c = 'Customer', User__c = UserInfo.getUserId());
        testPTRFJobviewerInfoList.add(testPTRFJobviewerInfo);
        testPTRFJobviewerInfo = new PTRF_JobViewer_Info__c(PTRF__c = testPTRF.Id, Jobview__c = 'Foundry', User__c = UserInfo.getUserId());
        testPTRFJobviewerInfoList.add(testPTRFJobviewerInfo);
        
        insert testPTRFJobviewerInfoList;
        set<id> testPTRFJobviewerInfoSetId = new set<id>();
        for(PTRF_JobViewer_Info__c obj : testPTRFJobviewerInfoList) {
            testPTRFJobviewerInfoSetId.add(obj.Id);
        }
        List<PTRF_JobViewer_Info__c> newList = new List<PTRF_JobViewer_Info__c>();
        newList = MRSHandlerUtility.getJobViewer(testPTRFJobviewerInfoSetId,'Customer');
        newList = MRSHandlerUtility.getJobViewer(testPTRFJobviewerInfoSetId,'Foundry');
        Test.stopTest();
    }
    /**
        This test method will cover the code CheckRecursive
        @method name: checkRecursiveTest
        
     **/ 
     public static testMethod void checkRecursiveTest(){
         Test.startTest();
             checkRecursive.runOnce();
             checkRecursive.runOnceAgain();
             system.assertEquals(checkRecursive.run , false);
         Test.stopTest();
     }
     /**
        This test method will cover the code for addingPTRF
        @method name: addingPTRFTest
     **/
     public static testMethod void addingPTRFTest(){
        User sysAdminUser = [SELECT Id,Name FROM User WHERE Profile.Name = 'System Administrator' AND isActive = true].get(0);
        User userSA = [SELECT Id, Email FROM User WHERE Email = 'testMRS@test.com'];
        System.runAs(sysAdminUser){ 
          // comment-out, refactor with testSetup method setup()
            // SwiftDataUtilityTest.customSystemData();
            // Insert Custom Settings Data---//
            //---------------------------------------------//
            Test.startTest();
            Account acc = getAccount('Test Account 009');
            Account_Team_Proxy__c atp = [SELECT Id, Name FROM Account_Team_Proxy__c LIMIT 1];
            Mask_Set_Title__c objMST = [SELECT Id, Name FROM Mask_Set_Title__c LIMIT 1];
            
            PTRF__c objPTRF = new PTRF__c(Name ='PTRF1',Order_Type__c ='Test Order Type',Recticle_Type__c ='Single Layer Reticle (SLR)',MaskSetTitle__c=objMST.Id,Customer__c=acc.id,Customer_jobview__c='Gating mask release',Foundry_jobview__c='Gating mask release');
            insert objPTRF;
            PTRF__C tempPTRF = [select Id, Name,Foundry_jobview__c,Customer_jobview__c from PTRF__c where Id =:objPTRF.Id];
            system.assertNotEquals(tempPTRF.Customer_jobview__c,null);
            List<PTRF_JobViewer_Info__c> listPTRFJVI = new List<PTRF_JobViewer_Info__c>();
            PTRF_JobViewer_Info__c objPTRFJVC = new PTRF_JobViewer_Info__c(Name='SAC',PTRF__c=tempPTRF.Id,Jobview__c='Customer',Jobview_Type__c='Frame Mockup;Prime GDSOUT Review;MEBES Jobview',User__c=userSA.Id);
            PTRF_JobViewer_Info__c objPTRFJVF = new PTRF_JobViewer_Info__c(Name='SAF',PTRF__c=tempPTRF.Id,Jobview__c='Foundry',Jobview_Type__c='Frame Mockup;Prime GDSOUT Review;MEBES Jobview',User__c=userSA.Id);
            listPTRFJVI.add(objPTRFJVC);
            listPTRFJVI.add(objPTRFJVF);
            insert listPTRFJVI;
            objPTRFJVC = [select Id, Name, PTRF__c, Jobview__c, Jobview_Type__c, User__c from PTRF_JobViewer_Info__c where Id=:objPTRFJVC.Id];
            objPTRFJVF = [select Id, Name, PTRF__c, Jobview__c, Jobview_Type__c, User__c from PTRF_JobViewer_Info__c where Id=:objPTRFJVF.Id];
            //system.assertNotEquals(objPTRFJVC.PTRF__r.Customer_jobview__c,null);
            MRS__c objMRS = [SELECT Id, Name, Mask_Set_Title__c FROM MRS__c LIMIT 1];
            
            List<MRS_Layer_Association__c> listMRSLA = new List<MRS_Layer_Association__c>();
            MRS_Layer_Association__c objMRSLA1 = new MRS_Layer_Association__c(MRS__c=objMRS.Id,Layer_Status__c='Ready',Name='RX',Mask_Layer_Rev__c='AZ',ROM_Code__c='123');
            MRS_Layer_Association__c objMRSLA2 = new MRS_Layer_Association__c(MRS__c=objMRS.Id,Layer_Status__c='Ready',Name='RY',Mask_Layer_Rev__c='AZ',ROM_Code__c='123');
            listMRSLA.add(objMRSLA1);
            listMRSLA.add(objMRSLA2);
            insert listMRSLA;   
            List<MRS_Chip_Details__c> listMRSCD = new List<MRS_Chip_Details__c>();
            MRS_Chip_Details__c objMRSCD1 = new MRS_Chip_Details__c(MRS__c=objMRS.Id,Name='Chip001');
            MRS_Chip_Details__c objMRSCD2 = new MRS_Chip_Details__c(MRS__c=objMRS.Id,Name='Chip002');
            MRS_Chip_Details__c objMRSCD3 = new MRS_Chip_Details__c(MRS__c=objMRS.Id,Name='Frame');
            listMRSCD.add(objMRSCD1);
            listMRSCD.add(objMRSCD2);
            listMRSCD.add(objMRSCD3);
            insert listMRSCD;
            List<MRS_Layer_Chip_Association__c> listMRSLCA = new List<MRS_Layer_Chip_Association__c>();
            MRS_Layer_Chip_Association__c objMRSLCA1 = new MRS_Layer_Chip_Association__c(Layer__c=objMRSLA1.Id,Chip__c=objMRSCD1.Id,PTRF__c=tempPTRF.Id,Tech_Geo__c='0.019UM',Device_Id__c='1',Layer_Chip_Status__c='In Progress',Foundry_MEBES_Jobview__c ='Ready',Customer_MEBES_Jobview__c ='Ready' );
            objMRSLCA1.PTRF__c=objPTRF.Id;
            MRS_Layer_Chip_Association__c objMRSLCA2 = new MRS_Layer_Chip_Association__c(Layer__c=objMRSLA1.Id,Chip__c=objMRSCD2.Id,PTRF__c=tempPTRF.Id,Tech_Geo__c='0.019UM',Device_Id__c='1',Layer_Chip_Status__c='In Progress',Foundry_MEBES_Jobview__c ='Ready',Customer_MEBES_Jobview__c ='Ready');
            objMRSLCA2.PTRF__c=objPTRF.Id;
            MRS_Layer_Chip_Association__c objMRSLCA3 = new MRS_Layer_Chip_Association__c(Layer__c=objMRSLA2.Id,Chip__c=objMRSCD1.Id,PTRF__c=tempPTRF.Id,Tech_Geo__c='0.019UM',Device_Id__c='1',Layer_Chip_Status__c='In Progress',Foundry_MEBES_Jobview__c ='Ready',Customer_MEBES_Jobview__c ='Ready');
            objMRSLCA3.PTRF__c=objPTRF.Id;
            MRS_Layer_Chip_Association__c objMRSLCA4 = new MRS_Layer_Chip_Association__c(Layer__c=objMRSLA2.Id,Chip__c=objMRSCD2.Id,PTRF__c=tempPTRF.Id,Tech_Geo__c='0.019UM',Device_Id__c='1',Layer_Chip_Status__c='In Progress',Foundry_MEBES_Jobview__c ='Ready',Customer_MEBES_Jobview__c ='Ready');
            objMRSLCA4.PTRF__c=objPTRF.Id;
            MRS_Layer_Chip_Association__c objMRSLCA5 = new MRS_Layer_Chip_Association__c(Layer__c=objMRSLA1.Id,Chip__c=objMRSCD3.Id,PTRF__c=tempPTRF.Id,Tech_Geo__c='0.019UM',Device_Id__c='1',Layer_Chip_Status__c='In Progress',Foundry_MEBES_Jobview__c ='Ready',Customer_MEBES_Jobview__c ='Ready');
            objMRSLCA5.PTRF__c=objPTRF.Id;
            MRS_Layer_Chip_Association__c objMRSLCA6 = new MRS_Layer_Chip_Association__c(Layer__c=objMRSLA2.Id,Chip__c=objMRSCD3.Id,PTRF__c=tempPTRF.Id,Tech_Geo__c='0.019UM',Device_Id__c='1',Layer_Chip_Status__c='In Progress',Foundry_MEBES_Jobview__c ='Ready',Customer_MEBES_Jobview__c ='Ready');
            objMRSLCA6.PTRF__c=objPTRF.Id;
            //objMRSLCA1=MRSHandlerUtility.setDRTLayerChipDefaultValues(objMRSLCA1);
            system.assertEquals(objMRSLCA1.Prime_MEBES_Received__c, null);
            listMRSLCA.add(objMRSLCA1);
            listMRSLCA.add(objMRSLCA2);
            listMRSLCA.add(objMRSLCA3);
            listMRSLCA.add(objMRSLCA4);
            listMRSLCA.add(objMRSLCA5);
            listMRSLCA.add(objMRSLCA6);
             
            insert listMRSLCA;
            objMRSLCA1 = [select Id, Name, Layer_Chip_Status__c, Customer_MEBES_Jobview__c, PTRF__r.Customer_Jobview__c, PTRF__c from MRS_Layer_Chip_Association__c where Id =:objMRSLCA1.Id];
            objMRSLCA2 = [select Id, Name, Layer_Chip_Status__c, Customer_MEBES_Jobview__c, PTRF__r.Customer_Jobview__c, PTRF__c from MRS_Layer_Chip_Association__c where Id =:objMRSLCA2.Id];
            objMRSLCA3 = [select Id, Name, Layer_Chip_Status__c, Customer_MEBES_Jobview__c, PTRF__r.Customer_Jobview__c, PTRF__c from MRS_Layer_Chip_Association__c where Id =:objMRSLCA3.Id];
            objMRSLCA4 = [select Id, Name, Layer_Chip_Status__c, Customer_MEBES_Jobview__c, PTRF__r.Customer_Jobview__c, PTRF__c from MRS_Layer_Chip_Association__c where Id =:objMRSLCA4.Id];
            objMRSLCA5 = [select Id, Name, Layer_Chip_Status__c, Customer_MEBES_Jobview__c, PTRF__r.Customer_Jobview__c, PTRF__c from MRS_Layer_Chip_Association__c where Id =:objMRSLCA5.Id];
            objMRSLCA6 = [select Id, Name, Layer_Chip_Status__c, Customer_MEBES_Jobview__c, PTRF__r.Customer_Jobview__c, PTRF__c from MRS_Layer_Chip_Association__c where Id =:objMRSLCA6.Id];
            objPTRF.Foundry_jobview__c = 'Gating mask release' ;
            objPTRF.Customer_jobview__c = 'Gating mask release' ;
            update objPTRF;
            //system.assertNotEquals(objPTRF.Customer_jobview__c,null); 
            //String str = 'Layer_Chip_Status__c : '+objMRSLCA1.Layer_Chip_Status__c+' Customer_MEBES_Jobview__c : '+objMRSLCA1.Customer_MEBES_Jobview__c+' PTRF__r.Customer_Jobview__c : '+objMRSLCA1.PTRF__r.Customer_Jobview__c+' PTRF : '+objMRSLCA1.PTRF__c+' PTRFObj value : '+objPTRF.Customer_jobview__c;
            //System.assertEquals(/*objMRSLCA1.PTRF__r.Customer_Jobview__c*/str,null);
            //test.startTest();
            MRSHandlerUtility.mebbesReceivedSendEmailToReviewers(listMRSLCA,'HII','hII',true);
            objPTRF.Foundry_jobview__c = 'Not gating mask release' ;
            objPTRF.Customer_jobview__c = 'Not gating mask release' ;
            update objPTRF ;  
            MRSHandlerUtility.mebbesReceivedSendEmailToReviewers(listMRSLCA,'HII','hII',true);
            test.stopTest();
        }
       
       
     }
   /**
        This test method will cover the code for for tapeoutApplication
        @method name: gatingNotGatingTapeoutApplication
   **/
    public static testMethod void gatingNotGatingTapeoutApplication(){
        User sysAdminUser = [SELECT Id,Name FROM User WHERE Profile.Name = 'System Administrator' AND isActive = true].get(0);
        User userSA = [SELECT Id, Email FROM User WHERE Email = 'testMRS@test.com'];
        System.runAs(sysAdminUser){ 
          // comment-out, refactor with testSetup method setup()
            // SwiftDataUtilityTest.customSystemData();
            // Insert Custom Settings Data---//
            //---------------------------------------------//
            Test.startTest();
            Account acc = getAccount('Test Account 009');
            Account_Team_Proxy__c atp = [SELECT Id, Name FROM Account_Team_Proxy__c LIMIT 1];
            Mask_Set_Title__c objMST = [SELECT Id, Name FROM Mask_Set_Title__c LIMIT 1];
            
            PTRF__c objPTRF = new PTRF__c(Name ='PTRF1',Recticle_Type__c ='Single Layer Reticle (SLR)',MaskSetTitle__c=objMST.Id,Customer__c=acc.id,Customer_jobview__c='Gating mask release',Foundry_jobview__c='Gating mask release',Process_Technology_Lifecycle_Phase__c='M5[Productization]',Tech_Geo_Value__c ='0.01',Order_Type__c='New Prototype');
            insert objPTRF;
            List<PTRF_JobViewer_Info__c> listPTRFJVI = new List<PTRF_JobViewer_Info__c>();
            PTRF_JobViewer_Info__c objPTRFJVC = new PTRF_JobViewer_Info__c(Name='SAC',PTRF__c=objPTRF.Id,Jobview__c='Customer',Jobview_Type__c='Frame Mockup;Prime GDSOUT Review;MEBES Jobview',User__c=userSA.Id);
            PTRF_JobViewer_Info__c objPTRFJVF = new PTRF_JobViewer_Info__c(Name='SAF',PTRF__c=objPTRF.Id,Jobview__c='Foundry',Jobview_Type__c='Frame Mockup;Prime GDSOUT Review;MEBES Jobview',User__c=userSA.Id);
            listPTRFJVI.add(objPTRFJVC);
            listPTRFJVI.add(objPTRFJVF);
            insert listPTRFJVI;
            MRS__c objMRS = [SELECT Id, Name, Mask_Set_Title__c FROM MRS__c LIMIT 1];
            
            List<MRS_Layer_Association__c> listMRSLA = new List<MRS_Layer_Association__c>();
            MRS_Layer_Association__c objMRSLA1 = new MRS_Layer_Association__c(MRS__c=objMRS.Id,Layer_Status__c='Ready',Name='RX',Mask_Layer_Rev__c='AZ',ROM_Code__c='123');
            MRS_Layer_Association__c objMRSLA2 = new MRS_Layer_Association__c(MRS__c=objMRS.Id,Layer_Status__c='Ready',Name='RY',Mask_Layer_Rev__c='AZ',ROM_Code__c='123');
            listMRSLA.add(objMRSLA1);
            listMRSLA.add(objMRSLA2);
            insert listMRSLA;   
            List<MRS_Chip_Details__c> listMRSCD = new List<MRS_Chip_Details__c>();
            MRS_Chip_Details__c objMRSCD1 = new MRS_Chip_Details__c(MRS__c=objMRS.Id,Name='Chip001');
            MRS_Chip_Details__c objMRSCD2 = new MRS_Chip_Details__c(MRS__c=objMRS.Id,Name='Chip002');
            MRS_Chip_Details__c objMRSCD3 = new MRS_Chip_Details__c(MRS__c=objMRS.Id,Name='Frame');
            listMRSCD.add(objMRSCD1);
            listMRSCD.add(objMRSCD2);
            listMRSCD.add(objMRSCD3);
            insert listMRSCD;
            List<MRS_Layer_Chip_Association__c> listMRSLCA = new List<MRS_Layer_Chip_Association__c>();
            MRS_Layer_Chip_Association__c objMRSLCA1 = new MRS_Layer_Chip_Association__c(Layer__c=objMRSLA1.Id,Chip__c=objMRSCD1.Id,PTRF__c=objPTRF.Id,Tech_Geo__c='0.019UM',Device_Id__c='1',Layer_Chip_Status__c='In Progress',Foundry_MEBES_Jobview__c ='Ready',Customer_MEBES_Jobview__c ='Ready',Tapeout_Applications_MEBES_Jobview__c='Ready');
            MRS_Layer_Chip_Association__c objMRSLCA2 = new MRS_Layer_Chip_Association__c(Layer__c=objMRSLA1.Id,Chip__c=objMRSCD2.Id,PTRF__c=objPTRF.Id,Tech_Geo__c='0.019UM',Device_Id__c='1',Layer_Chip_Status__c='In Progress',Foundry_MEBES_Jobview__c ='Ready',Customer_MEBES_Jobview__c ='Ready',Tapeout_Applications_MEBES_Jobview__c='Ready');
            MRS_Layer_Chip_Association__c objMRSLCA3 = new MRS_Layer_Chip_Association__c(Layer__c=objMRSLA2.Id,Chip__c=objMRSCD1.Id,PTRF__c=objPTRF.Id,Tech_Geo__c='0.019UM',Device_Id__c='1',Layer_Chip_Status__c='In Progress',Foundry_MEBES_Jobview__c ='Ready',Customer_MEBES_Jobview__c ='Ready',Tapeout_Applications_MEBES_Jobview__c='Ready');
            MRS_Layer_Chip_Association__c objMRSLCA4 = new MRS_Layer_Chip_Association__c(Layer__c=objMRSLA2.Id,Chip__c=objMRSCD2.Id,PTRF__c=objPTRF.Id,Tech_Geo__c='0.019UM',Device_Id__c='1',Layer_Chip_Status__c='In Progress',Foundry_MEBES_Jobview__c ='Ready',Customer_MEBES_Jobview__c ='Ready',Tapeout_Applications_MEBES_Jobview__c='Ready');
            MRS_Layer_Chip_Association__c objMRSLCA5 = new MRS_Layer_Chip_Association__c(Layer__c=objMRSLA1.Id,Chip__c=objMRSCD3.Id,PTRF__c=objPTRF.Id,Tech_Geo__c='0.019UM',Device_Id__c='1',Layer_Chip_Status__c='In Progress',Foundry_MEBES_Jobview__c ='Ready',Customer_MEBES_Jobview__c ='Ready',Tapeout_Applications_MEBES_Jobview__c='Ready');
            MRS_Layer_Chip_Association__c objMRSLCA6 = new MRS_Layer_Chip_Association__c(Layer__c=objMRSLA2.Id,Chip__c=objMRSCD3.Id,PTRF__c=objPTRF.Id,Tech_Geo__c='0.019UM',Device_Id__c='1',Layer_Chip_Status__c='In Progress',Foundry_MEBES_Jobview__c ='Ready',Customer_MEBES_Jobview__c ='Ready',Tapeout_Applications_MEBES_Jobview__c='Ready');
            //objMRSLCA1=MRSHandlerUtility.setDRTLayerChipDefaultValues(objMRSLCA1);
            system.assertEquals(objMRSLCA1.Prime_MEBES_Received__c, null);
            listMRSLCA.add(objMRSLCA1);
            listMRSLCA.add(objMRSLCA2);
            listMRSLCA.add(objMRSLCA3);
            listMRSLCA.add(objMRSLCA4);
            listMRSLCA.add(objMRSLCA5);
            listMRSLCA.add(objMRSLCA6);
            objPTRF.Foundry_jobview__c = 'Gating mask release' ;
            objPTRF.Customer_jobview__c = 'Gating mask release' ;
            update objPTRF ;  
            insert listMRSLCA;
            set<String> setLayerChipIds = new set<String>();
            for(MRS_Layer_Chip_Association__c objMRSLCA:listMRSLCA){
                setLayerChipIds.add(objMRSLCA.Id);  
            }            
            List<MRS_Layer_Chip_Association__c> listMRSLCANewQueried = new List<MRS_Layer_Chip_Association__c>();
            for(MRS_Layer_Chip_Association__c obj:[SELECT Approved__c,Chip_Hold_Warning__c,Chip_Name__c,Chip__c,CreatedById,CreatedDate,
            Customer_Frame_Mockup_Date__c,Customer_Frame_Mockup__c,Customer_Frame_Remote_Jobview_Setup_Date__c,Customer_Frame_Remote_Jobview_Setup__c,
            Customer_GDSOUT_Review_Date__c,Customer_GDSOUT_Review__c,Customer_MEBES_Jobview_Date__c,Customer_MEBES_Jobview__c,Customer_Name__c,
            Customer_Prime_Remote_Jobview_Setup_Date__c,Customer_Prime_Remote_Jobview_Setup__c,Device_Id__c,DRT_Name__c,DRT__c,DRW_Date__c,DRW__c,
            Error_Message_Oracle_DB__c,Error_Message_PTRF_Layer_SendPrimeFrame__c,Error_Message_Sync_Layer_Status__c,Foundry_Frame_Mockup_Date__c,
            Foundry_Frame_Mockup__c,Foundry_Frame_Remote_Jobview_Setup_Date__c,Foundry_Frame_Remote_Jobview_Setup__c,Foundry_GDSOUT_Review_Date__c,
            Foundry_GDSOUT_Review__c,Foundry_MEBES_Jobview_Date__c,Foundry_MEBES_Jobview__c,Foundry_Prime_Remote_Jobview_Setup_Date__c,
            Foundry_Prime_Remote_Jobview_Setup__c,Frame_MEBES_Received_Date__c,Frame_MEBES_Received__c,Frame_TapeOut__c,Layer__r.Mask_Layer_Rev__c,
            GlobalShuttle_MEBES_Jobview_Date__c,GlobalShuttle_MEBES_Jobview__c,Hold_Mask_Write_Date__c,Hold_Mask_Write__c,Id,IsDeleted,
            Is_Active__c,Is_Customer_Frame_Mockup_Updated__c,Is_Customer_Frame_Remote_Jobview_Updated__c,Is_Customer_GDSOUT_Review_Updated__c,
            Is_Customer_MEBES_Jobview_Updated__c,Is_Customer_Prime_Remote_Jobview_Updated__c,Is_DRW_Updated__c,Is_Foundry_Frame_Mockup_Updated__c,
            Is_Foundry_Frame_Remote_Jobview_Updated__c,Is_Foundry_GDSOUT_Review_Updated__c,Is_Foundry_MEBES_Jobview_Updated__c,PTRF__r.Tech_Geo__c,
            Is_Foundry_Prime_Remote_Jobview_Updated__c,Is_Frame_MEBES_Received_Updated__c,Is_GlobalShuttle_MEBES_Jobview_Updated__c,
            Is_MDP_MEBES_Jobview_Updated__c,Is_ORC_Updated__c,Is_Prime_MEBES_Received_Updated__c,Is_Send_Frame_Data_Updated__c,Chip__r.Name,
            Is_Send_Prime_Data_Updated__c,Is_Tapeout_Apps_MEBES_Jobview_Updated__c,Is_Tapeout_Centre_MEBES_Jobview_Updated__c,
            Is_TDTI_MPW_MEBES_Jobview_Updated__c,LastModifiedById,LastModifiedDate,lastmodifieddate_sgt__c,PTRF__r.Customer_jobview__c,PTRF__r.Foundry_jobview__c,
            Last_Sync_Req_Timestamp_Layer_Gen__c,Last_Sync_Req_Timestamp_ORCN_Job__c,Last_Sync_Req_Timestamp_Receive_MEBES__c,PTRF__r.Order_Type__c,
            Last_Sync_Req_Timestamp_Remote_Jobview__c,Last_Sync_Req_Timestamp_Send_Frame__c,Last_Sync_Req_Timestamp_Send_Prime__c,PTRF__r.Process_Technology_Lifecycle_Phase__c,
            Last_Sync_Req_Timestamp__c,Layer_Chip_Old_Status__c,Layer_Chip_Status_Date__c,Layer_Chip_Status__c,Layer_Name__c,Layer__r.Name,
            Layer_Send_Frame_Data__c,Layer_Send_Prime_Data__c,Layer__c,Lock_Record__c,Mask_Layer_Status__c,Mask_Layer__c,Mask_Set_Title_Name__c,
            MDP_MEBES_Jobview_Date__c,MDP_MEBES_Jobview__c,MRS_ID__c,MST__c,Name,ORC_Date__c,ORC__c,Prime_MEBES_Received_Date__c,
            Prime_MEBES_Received__c,Prime_TapeOut__c,PTRF_Number__c,PTRF_Or_DRT__c,PTRF__c,Rev__c,ROM_Code__c,Send_Frame_Data_Date__c,
            Send_Frame_Data__c,Send_Prime_Data_Date__c,Send_Prime_Data__c,Synced_with_Oracle_DB__c,Sync_Layer_Status__c,PTRF__r.MaskSetTitle__r.Name,
            Sync_PTRF_Layer_SendPrimeFrame_dotNET__c,Sync_PTRF_Layer_to_SWIFT_dotNET__c,SystemModstamp,Tapeout_Applications_MEBES_Jobview_Date__c,
            Tapeout_Applications_MEBES_Jobview__c,Tapeout_Centre_MEBES_Jobview_Date__c,Tapeout_Centre_MEBES_Jobview__c,TDTI_MPW_MEBES_Date__c,
            TDTI_MPW_MEBES_Jobview__c,Tech_Geo__c,Trigger_Sync_Layer_Status__c,Void__c,Layer__r.ROM_Code__c FROM MRS_Layer_Chip_Association__c where Id IN:setLayerChipIds]){
                listMRSLCANewQueried.add(obj);    
            }
            list<Tapeout_Applications_MEBES_Jobview_Confi__c> listTAMJC = new list<Tapeout_Applications_MEBES_Jobview_Confi__c>();
            Tapeout_Applications_MEBES_Jobview_Confi__c objTAMJC2 = new Tapeout_Applications_MEBES_Jobview_Confi__c(Excluded_Customer__c = 'gf',Process_Technology_Lifecycle_Phase__c = 'M5',PTRF_Customer_MEBES_Jobview__c = 'Gating mask release;Not gating mask release;Not required',PTRF_Foundry_MEBES_Jobview__c = 'Gating mask release;Not gating mask release;Not required',PTRF_Order_Type__c = 'Retrofit',PTRF_Technology__c = '0.20UM-0.28UM',Tapeout_Application_Jobview__c = 'Non gating',Logic_For_Calculation__c = 'OR');
            Tapeout_Applications_MEBES_Jobview_Confi__c objTAMJC = new Tapeout_Applications_MEBES_Jobview_Confi__c(Excluded_Customer__c = null,Process_Technology_Lifecycle_Phase__c = null,PTRF_Customer_MEBES_Jobview__c = 'Gating mask release;Not gating mask release;Not required',PTRF_Foundry_MEBES_Jobview__c = 'Gating mask release;Not gating mask release;Not required',PTRF_Order_Type__c = 'New Prototype',PTRF_Technology__c = '<= 0.020UM',Tapeout_Application_Jobview__c = 'Gating',Logic_For_Calculation__c = 'AND');
            Tapeout_Applications_MEBES_Jobview_Confi__c objTAMJC3 = new Tapeout_Applications_MEBES_Jobview_Confi__c(Excluded_Customer__c = 'gf',Process_Technology_Lifecycle_Phase__c = 'M5',PTRF_Customer_MEBES_Jobview__c = 'Gating mask release;Not gating mask release;Not required',PTRF_Foundry_MEBES_Jobview__c = 'Gating mask release;Not gating mask release;Not required',PTRF_Order_Type__c = 'New Prototype',PTRF_Technology__c = '>=0.06UM',Tapeout_Application_Jobview__c = 'Gating',Logic_For_Calculation__c = 'OR');
            Tapeout_Applications_MEBES_Jobview_Confi__c objTAMJC4 = new Tapeout_Applications_MEBES_Jobview_Confi__c(Excluded_Customer__c = 'gf',Process_Technology_Lifecycle_Phase__c = 'M5',PTRF_Customer_MEBES_Jobview__c = 'Gating mask release;Not gating mask release;Not required',PTRF_Foundry_MEBES_Jobview__c = 'Gating mask release;Not gating mask release;Not required',PTRF_Order_Type__c = 'New Prototype',PTRF_Technology__c = '>0.06UM',Tapeout_Application_Jobview__c = 'Gating',Logic_For_Calculation__c = 'OR');
            Tapeout_Applications_MEBES_Jobview_Confi__c objTAMJC5 = new Tapeout_Applications_MEBES_Jobview_Confi__c(Excluded_Customer__c = 'gf',Process_Technology_Lifecycle_Phase__c = 'M5',PTRF_Customer_MEBES_Jobview__c = 'Gating mask release;Not gating mask release;Not required',PTRF_Foundry_MEBES_Jobview__c = 'Gating mask release;Not gating mask release;Not required',PTRF_Order_Type__c = 'New Prototype',PTRF_Technology__c = '<0.06UM',Tapeout_Application_Jobview__c = 'Gating',Logic_For_Calculation__c = 'OR');
            Tapeout_Applications_MEBES_Jobview_Confi__c objTAMJC6 = new Tapeout_Applications_MEBES_Jobview_Confi__c(Excluded_Customer__c = 'gf',Process_Technology_Lifecycle_Phase__c = 'M5',PTRF_Customer_MEBES_Jobview__c = 'Gating mask release;Not gating mask release;Not required',PTRF_Foundry_MEBES_Jobview__c = 'Gating mask release;Not gating mask release;Not required',PTRF_Order_Type__c = 'New Prototype',PTRF_Technology__c = '0.06UM',Tapeout_Application_Jobview__c = 'Gating',Logic_For_Calculation__c = 'OR');
            Tapeout_Applications_MEBES_Jobview_Confi__c objTAMJC7 = new Tapeout_Applications_MEBES_Jobview_Confi__c(Excluded_Customer__c = null,Process_Technology_Lifecycle_Phase__c = null,PTRF_Customer_MEBES_Jobview__c = 'Gating mask release;Not gating mask release;Not required',PTRF_Foundry_MEBES_Jobview__c = 'Gating mask release;Not gating mask release;Not required',PTRF_Order_Type__c = 'New Prototype',PTRF_Technology__c = '<= 0.020UM',Tapeout_Application_Jobview__c = 'Gating',Logic_For_Calculation__c = 'OR');            
            Tapeout_Applications_MEBES_Jobview_Confi__c objTAMJC8 = new Tapeout_Applications_MEBES_Jobview_Confi__c(Excluded_Customer__c = 'gf',Process_Technology_Lifecycle_Phase__c = 'M5',PTRF_Customer_MEBES_Jobview__c = 'Gating mask release;Not gating mask release;Not required',PTRF_Foundry_MEBES_Jobview__c = 'Gating mask release;Not gating mask release;Not required',PTRF_Order_Type__c = 'Retrofit',PTRF_Technology__c = '0.20UM-0.28UM',Tapeout_Application_Jobview__c = 'Non gating',Logic_For_Calculation__c = 'AND');
            Tapeout_Applications_MEBES_Jobview_Confi__c objTAMJC9 = new Tapeout_Applications_MEBES_Jobview_Confi__c(Excluded_Customer__c = 'gf',Process_Technology_Lifecycle_Phase__c = 'M5',PTRF_Customer_MEBES_Jobview__c = 'Gating mask release;Not gating mask release;Not required',PTRF_Foundry_MEBES_Jobview__c = 'Gating mask release;Not gating mask release;Not required',PTRF_Order_Type__c = 'New Prototype',PTRF_Technology__c = '>=0.06UM',Tapeout_Application_Jobview__c = 'Gating',Logic_For_Calculation__c = 'AND');
            Tapeout_Applications_MEBES_Jobview_Confi__c objTAMJC10 = new Tapeout_Applications_MEBES_Jobview_Confi__c(Excluded_Customer__c = 'gf',Process_Technology_Lifecycle_Phase__c = 'M5',PTRF_Customer_MEBES_Jobview__c = 'Gating mask release;Not gating mask release;Not required',PTRF_Foundry_MEBES_Jobview__c = 'Gating mask release;Not gating mask release;Not required',PTRF_Order_Type__c = 'New Prototype',PTRF_Technology__c = '>0.06UM',Tapeout_Application_Jobview__c = 'Gating',Logic_For_Calculation__c = 'AND');
            Tapeout_Applications_MEBES_Jobview_Confi__c objTAMJC11 = new Tapeout_Applications_MEBES_Jobview_Confi__c(Excluded_Customer__c = 'gf',Process_Technology_Lifecycle_Phase__c = 'M5',PTRF_Customer_MEBES_Jobview__c = 'Gating mask release;Not gating mask release;Not required',PTRF_Foundry_MEBES_Jobview__c = 'Gating mask release;Not gating mask release;Not required',PTRF_Order_Type__c = 'New Prototype',PTRF_Technology__c = '<0.06UM',Tapeout_Application_Jobview__c = 'Gating',Logic_For_Calculation__c = 'AND');
            Tapeout_Applications_MEBES_Jobview_Confi__c objTAMJC12 = new Tapeout_Applications_MEBES_Jobview_Confi__c(Excluded_Customer__c = 'gf',Process_Technology_Lifecycle_Phase__c = 'M5',PTRF_Customer_MEBES_Jobview__c = 'Gating mask release;Not gating mask release;Not required',PTRF_Foundry_MEBES_Jobview__c = 'Gating mask release;Not gating mask release;Not required',PTRF_Order_Type__c = 'New Prototype',PTRF_Technology__c = '0.06UM',Tapeout_Application_Jobview__c = 'Gating',Logic_For_Calculation__c = 'AND');
            listTAMJC.add(objTAMJC);
            listTAMJC.add(objTAMJC2);
            listTAMJC.add(objTAMJC3);
            listTAMJC.add(objTAMJC4);
            listTAMJC.add(objTAMJC5);
            listTAMJC.add(objTAMJC6);
            listTAMJC.add(objTAMJC7);
            listTAMJC.add(objTAMJC8);
            listTAMJC.add(objTAMJC9);
            listTAMJC.add(objTAMJC10);
            listTAMJC.add(objTAMJC11);
            listTAMJC.add(objTAMJC12);
            insert listTAMJC;
            //test.startTest();
            MRSHandlerUtility.gatingOrNongatingPTRF(listMRSLCANewQueried);
          
            MRSHandlerUtility.mebbesReceivedSendEmailToReviewers(listMRSLCA,'HII','hII',true);
            test.stopTest();
        }
       
       
     }
     
    private static Account getAccount(string AccountName) {
    
        Account acct = [SELECT Id, Name FROM Account Where Name =: AccountName];
        
        return acct;
    }
}