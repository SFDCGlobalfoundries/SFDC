@isTest
private class MRSMEBESJobviewExtnTest2 {

    @testSetup static void setup() {
        SwiftDataUtilityTest.customSystemData();
    }

    static testMethod void myUnitTest() {
        // comment-out, refactor with testSetup method setup()
          // SwiftDataUtilityTest.customSystemData();
         User sysAdminUser = [SELECT Id,Name FROM User WHERE Profile.Name = 'System Administrator' AND isActive = true].get(0);
         
         Account acc = SwiftDataUtilityTest.createTestAccountForDRT();
       // User sysAdminUser = [SELECT Id,Name FROM User WHERE Profile.Name = 'System Administrator' AND isActive = true].get(0);
        Profile sysAdminProfile = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
        User userSA = new User(alias = 'testMRS', email='testMRS@test.com',
        emailencodingkey='UTF-8', lastname='testMRSLast', firstname='testMRSFirst', languagelocalekey='en_US',
        localesidkey='en_US', profileid = sysAdminProfile.Id,
        timezonesidkey='America/Los_Angeles', username='testMRS@test.com',communitynickname='testMRS');
        insert userSA;                 
        
         System.runAs(sysAdminUser){
            Group groupGS = [select Id, DeveloperName, Name from Group where DeveloperName = 'Swift_GlobalShuttle'];
            Group groupSA = [select Id, DeveloperName, Name from Group where DeveloperName = 'SWIFT_Admin'];
            List<GroupMember> listGM = new List<GroupMember>(); 
            GroupMember groupMemberSA = new GroupMember(GroupId = groupSA.Id,UserOrGroupId = userSA.Id);
            GroupMember groupMemberGS = new GroupMember(GroupId = groupGS.Id,UserOrGroupId = userSA.Id);          
            listGM.add(groupMemberSA);
            listGM.add(groupMemberGS);
            insert listGM;
            Mask_Set_Title__c objMST = SwiftDataUtilityTest.createMST('MPW001');
            insert objMST;
            Cookie mst = new Cookie('mst', objMST.Id, null, -1, false);
            ApexPages.currentPage().setCookies(new Cookie[]{mst});
            PTRF__c objPTRF = new PTRF__c(Name ='PTRF1',Order_Type__c ='Test Order Type',Recticle_Type__c ='Multi Node Reticle (MNR)',MaskSetTitle__c=objMST.Id,Customer__c=acc.id);
            insert objPTRF;
            List<PTRF_JobViewer_Info__c> listPTRFJVI = new List<PTRF_JobViewer_Info__c>();
            PTRF_JobViewer_Info__c objPTRFJVC = new PTRF_JobViewer_Info__c(Name='SAC',PTRF__c=objPTRF.Id,Jobview__c='Customer',Jobview_Type__c='Frame Mockup;Prime GDSOUT Review;MEBES Jobview',User__c=userSA.Id);
            PTRF_JobViewer_Info__c objPTRFJVF = new PTRF_JobViewer_Info__c(Name='SAF',PTRF__c=objPTRF.Id,Jobview__c='Foundry',Jobview_Type__c='Frame Mockup;Prime GDSOUT Review;MEBES Jobview',User__c=userSA.Id);
            //PTRF_JobViewer_Info__c objPTRFJVCust = new PTRF_JobViewer_Info__c(Name='SACust',PTRF__c=objPTRF.Id,Jobview__c='Customer',Jobview_Type__c='Frame Mockup;Prime GDSOUT Review;MEBES Jobview',User__c=listCon.get(0).Id);
            listPTRFJVI.add(objPTRFJVC);
            listPTRFJVI.add(objPTRFJVF);
            //listPTRFJVI.add(objPTRFJVCust);
            insert listPTRFJVI;
            MRS__c objMRS = new MRS__c(Mask_Set_Title__c=objMST.Id);
            insert objMRS;
            List<MRS_Layer_Association__c> listMRSLA = new List<MRS_Layer_Association__c>();
            MRS_Layer_Association__c objMRSLA1 = new MRS_Layer_Association__c(MRS__c=objMRS.Id,Layer_Status__c='Ready',Name='RX',Mask_Layer_Rev__c='AZ',ROM_Code__c='123');
            MRS_Layer_Association__c objMRSLA2 = new MRS_Layer_Association__c(MRS__c=objMRS.Id,Layer_Status__c='Ready',Name='RY',Mask_Layer_Rev__c='AZ',ROM_Code__c='####');
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
            MRS_Layer_Chip_Association__c objMRSLCA1 = new MRS_Layer_Chip_Association__c(Layer__c=objMRSLA1.Id,Chip__c=objMRSCD1.Id,PTRF__c=objPTRF.Id,Tech_Geo__c='0.019UM',Customer_Name__c=acc.Id,Device_Id__c='Device1');
            MRS_Layer_Chip_Association__c objMRSLCA2 = new MRS_Layer_Chip_Association__c(Layer__c=objMRSLA1.Id,Chip__c=objMRSCD2.Id,PTRF__c=objPTRF.Id,Tech_Geo__c='0.019UM',Customer_Name__c=acc.Id,Device_Id__c='Device1');
            MRS_Layer_Chip_Association__c objMRSLCA3 = new MRS_Layer_Chip_Association__c(Layer__c=objMRSLA2.Id,Chip__c=objMRSCD1.Id,PTRF__c=objPTRF.Id,Tech_Geo__c='0.019UM',Customer_Name__c=acc.Id,Device_Id__c='Device1');
            MRS_Layer_Chip_Association__c objMRSLCA4 = new MRS_Layer_Chip_Association__c(Layer__c=objMRSLA2.Id,Chip__c=objMRSCD2.Id,PTRF__c=objPTRF.Id,Tech_Geo__c='0.019UM',Customer_Name__c=acc.Id,Device_Id__c='Device1');
            MRS_Layer_Chip_Association__c objMRSLCA5 = new MRS_Layer_Chip_Association__c(Layer__c=objMRSLA1.Id,Chip__c=objMRSCD3.Id,PTRF__c=objPTRF.Id,Tech_Geo__c='0.019UM',Customer_Name__c=acc.Id,Device_Id__c='Device1');
            MRS_Layer_Chip_Association__c objMRSLCA6 = new MRS_Layer_Chip_Association__c(Layer__c=objMRSLA2.Id,Chip__c=objMRSCD3.Id,PTRF__c=objPTRF.Id,Tech_Geo__c='0.019UM',Customer_Name__c=acc.Id,Device_Id__c='Device1');
            objMRSLCA1 = MRSMEBESJobviewExtnTest.createLayerChipData(objMRSLCA1);
            objMRSLCA2 = MRSMEBESJobviewExtnTest.createLayerChipData(objMRSLCA2);
            objMRSLCA3 = MRSMEBESJobviewExtnTest.createLayerChipData(objMRSLCA3);
            objMRSLCA4 = MRSMEBESJobviewExtnTest.createLayerChipData(objMRSLCA4);
            objMRSLCA5 = MRSMEBESJobviewExtnTest.createLayerChipData(objMRSLCA5);
            objMRSLCA6 = MRSMEBESJobviewExtnTest.createLayerChipData(objMRSLCA6);
            listMRSLCA.add(objMRSLCA1);
            listMRSLCA.add(objMRSLCA2);
            listMRSLCA.add(objMRSLCA3);
            listMRSLCA.add(objMRSLCA4);
            listMRSLCA.add(objMRSLCA5);
            listMRSLCA.add(objMRSLCA6);
            insert listMRSLCA;
            
       }     
                
         
        System.runAs(sysAdminUser){
            DRT__c objDRT = new DRT__c(Name='Test DRT');
            insert objDRT;
            ApexPages.currentPage().getHeaders().put('Host',Label.Swift_Host_URL);            
            Test.startTest();
            MRSMEBESJobviewExtn controller = new MRSMEBESJobviewExtn (new ApexPages.StandardController(objDRT));

            try {controller.getMaskLayerList0();}catch(exception e) {}
            try {controller.getMaskLayerList1();}catch(exception e) {}
            try {controller.getMaskLayerList2();}catch(exception e) {}
            try {controller.getMaskLayerList3();}catch(exception e) {}
            try {controller.getMaskLayerList4();}catch(exception e) {}
            try {controller.getMaskLayerList5();}catch(exception e) {}
            try {controller.getMaskLayerList6();}catch(exception e) {}
            try {controller.getMaskLayerList7();}catch(exception e) {}
            try {controller.getMaskLayerList8();}catch(exception e) {}
            try {controller.getMaskLayerList9();}catch(exception e) {}
            
            
            try {controller.getNthSubList(0);}catch(exception e) {}
            try {controller.getSubList(0,1);}catch(exception e) {}
            try {controller.clearAllFilters();}catch(exception e) {}
            try {controller.applyAllFilters();}catch(exception e) {}
            try {controller.resetLSPCookies();}catch(exception e) {}
            try {controller.performReview();}catch(exception e) {}
            try {controller.discardSelection();}catch(exception e) {}
            try {controller.exportToExcel();}catch(exception e) {}
            try {controller.exportToPDF();}catch(exception e) {}
            try {controller.exportToCSV();}catch(exception e) {}
            
            
                                
            Test.stopTest();
        }
    }
}