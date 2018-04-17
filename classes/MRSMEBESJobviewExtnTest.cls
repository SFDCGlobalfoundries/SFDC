/*
Type Name: MRSMEBESJobviewExtnTest
Author: Cognizant 
Created Date: 26-May-2014
Reason: 
Change History:
Author: 
Modified Date: 
Reason: 
Author: Cognizant Technology Solutions
Modified Date:
??..
??..
*/
@istest(SeeAllData=false)
public class MRSMEBESJobviewExtnTest{
    
    /**
    This method initialize data using throughout this test class.
    The create data method are: 
    - SwiftDataUtilityTest.customSystemData();
    @author     SWIFT TEAM
    @since      7-April-2015
    */
    @testSetup static void setup() {
        Test.startTest();
        
        SwiftDataUtilityTest.customSystemData();
        
        Account acc = SwiftDataUtilityTest.createTestAccountForDRT();
        Account acc2 = createTestAccountForDRT();
        
        Profile sysAdminProfile = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
        User userSA = new User(alias = 'testMRS', email='testMRS@test.com',
        emailencodingkey='UTF-8', lastname='testMRSLast', firstname='testMRSFirst', languagelocalekey='en_US',
        localesidkey='en_US', profileid = sysAdminProfile.Id,
        timezonesidkey='America/Los_Angeles', username='testMRS@test.com',communitynickname='testMRS');
        insert userSA;
        
        Mask_Set_Title__c objMST = SwiftDataUtilityTest.createMST('MPW001');
        insert objMST;
        
        MRS__c objMRS = new MRS__c(Mask_Set_Title__c=objMST.Id);
        insert objMRS;
        
        Test.stopTest();
    }

    /**
        This test method tests all the minor Wrapper method of MRSMEBESJobviewExtn class.
        @method name: TestWrapperMinorMethods
        @parameter:   none.
        @return :     None.
     **/
     
    public static testMethod void TestWrapperMinorMethods (){
    
         User sysAdminUser = [SELECT Id,Name FROM User WHERE Profile.Name = 'System Administrator' AND isActive = true].get(0);
         
         //Account acc = SwiftDataUtilityTest.createTestAccountForDRT();
        Account acc = getAccount('Test Account 009');
       // User sysAdminUser = [SELECT Id,Name FROM User WHERE Profile.Name = 'System Administrator' AND isActive = true].get(0);
        /*Profile sysAdminProfile = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
        User userSA = new User(alias = 'testMRS', email='testMRS@test.com',
        emailencodingkey='UTF-8', lastname='testMRSLast', firstname='testMRSFirst', languagelocalekey='en_US',
        localesidkey='en_US', profileid = sysAdminProfile.Id,
        timezonesidkey='America/Los_Angeles', username='testMRS@test.com',communitynickname='testMRS');
        insert userSA; 
        */
        User userSA = [SELECT Id FROM User WHERE Email = 'testMRS@test.com'];
        
         System.runAs(sysAdminUser){
            Group groupGS = [select Id, DeveloperName, Name from Group where DeveloperName = 'Swift_GlobalShuttle'];
            Group groupSA = [select Id, DeveloperName, Name from Group where DeveloperName = 'SWIFT_Admin'];
            List<GroupMember> listGM = new List<GroupMember>(); 
            GroupMember groupMemberSA = new GroupMember(GroupId = groupSA.Id,UserOrGroupId = userSA.Id);
            GroupMember groupMemberGS = new GroupMember(GroupId = groupGS.Id,UserOrGroupId = userSA.Id);          
            listGM.add(groupMemberSA);
            listGM.add(groupMemberGS);
            insert listGM;
            //Mask_Set_Title__c objMST = SwiftDataUtilityTest.createMST('MPW001');
            //insert objMST;
            Mask_Set_Title__c objMST = [SELECT Id, Name FROM Mask_Set_Title__c LIMIT 1];
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
            //MRS__c objMRS = new MRS__c(Mask_Set_Title__c=objMST.Id);
            //insert objMRS;
            MRS__c objMRS = [SELECT Id, Mask_Set_Title__c FROM MRS__c LIMIT 1];
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
            objMRSLCA1 = createLayerChipData(objMRSLCA1);
            objMRSLCA2 = createLayerChipData(objMRSLCA2);
            objMRSLCA3 = createLayerChipData(objMRSLCA3);
            objMRSLCA4 = createLayerChipData(objMRSLCA4);
            objMRSLCA5 = createLayerChipData(objMRSLCA5);
            objMRSLCA6 = createLayerChipData(objMRSLCA6);
            listMRSLCA.add(objMRSLCA1);
            listMRSLCA.add(objMRSLCA2);
            listMRSLCA.add(objMRSLCA3);
            listMRSLCA.add(objMRSLCA4);
            listMRSLCA.add(objMRSLCA5);
            listMRSLCA.add(objMRSLCA6);
            insert listMRSLCA;
            
       }     
                
         
        System.runAs(sysAdminUser){
            Test.startTest();
            DRT__c objDRT = new DRT__c(Name='Test DRT');
            insert objDRT;
            ApexPages.currentPage().getHeaders().put('Host',Label.Swift_Host_URL);            
            
            MRSMEBESJobviewExtn controller = new MRSMEBESJobviewExtn (new ApexPages.StandardController(objDRT));
            //system.assertEquals(controller.isBreadcrumbActive, true);
            MRSMEBESJobviewExtn.OtherWrapperDisplayTable wrapper1 = new MRSMEBESJobviewExtn.OtherWrapperDisplayTable();
            MRSMEBESJobviewExtn.WrapperDisplayTable wrapper2 = new MRSMEBESJobviewExtn.WrapperDisplayTable(1,'RXAZ','PTRF1','0.020UM',true,'PTRF1Id');
            MRSMEBESJobviewExtn.WrapperChip wrapper3 = new MRSMEBESJobviewExtn.WrapperChip('Chip1');
            MRSMEBESJobviewExtn.WrapperLayerPtrf wrapper4 = new MRSMEBESJobviewExtn.WrapperLayerPtrf('1','RXAZ','PTRF1','PTRF1Id','0.020UM');
            MRSMEBESJobviewExtn.WrapperStatusCheck wrapper5 = new MRSMEBESJobviewExtn.WrapperStatusCheck('RXAZChip1','CHECKED');
            controller.applyAllFilters();
            controller.clearAllFilters();
            controller.selectedMST='MST';
            controller.clearAllFilters();
            controller.performReview();
            controller.discardSelection();
            controller.exportToExcel();
            controller.exportToPDF();
            controller.exportToCSV();
            controller.isTableActive = true;
            controller.exportToExcel();
            controller.exportToPDF();
            controller.exportToCSV();              
            controller.resetLSPCookies();  
            controller.get(-1);
            MRSMEBESJobviewExtn.statusWrapper statusWrapper1 = new MRSMEBESJobviewExtn.statusWrapper(); 
            statusWrapper1.isKey = true;
            statusWrapper1.uniqueStatusMapChangedValue = 'Ready'; 
            statusWrapper1.statusWithTimestampValue = 'Ready';            
            controller.statusWrapperMap.put('Wrapper1',statusWrapper1);
            controller.addToStatusMap('Wrapper1','false','uniqueStatusMapChanged');
            controller.addToStatusMap('Wrapper1','false','containsStatus'); 
            controller.addToStatusMap('Wrapper2','false','containsStatus');  
            controller.addToStatusMap('Wrapper3','true','containsStatus');    
            controller.addToStatusMap('Wrapper4','true','statusWithTimestamp');                         
            Test.stopTest();
        }
    }
    
    /**
        This test method tests the constructor of MRSMEBESJobviewExtn class.
        @method name: TestConstructor
        @parameter:   none.
        @return :     None.
     **/
     
    public static testMethod void TestConstructor (){
        /*      
        Profile sysAdminProfile = [SELECT Id FROM Profile WHERE Name='System Administrator'];       
        User sysAdminUser = [SELECT Id,Name FROM User WHERE Profile.Name = 'System Administrator' AND isActive = true].get(0);
        User userSA = new User(alias = 'testMRS', email='testMRS@test.com',
        emailencodingkey='UTF-8', lastname='testMRSLast', firstname='testMRSFirst', languagelocalekey='en_US',
        localesidkey='en_US', profileid = sysAdminProfile.Id,
        timezonesidkey='America/Los_Angeles', username='testMRS@test.com',communitynickname='testMRS');
        insert userSA;
        */
        User userSA = [SELECT Id FROM User WHERE Email = 'testMRS@test.com'];
        
        Group groupTA = [select Id, DeveloperName, Name from Group where DeveloperName = 'Swift_Tapeout_Application'];
        Group groupTC = [select Id, DeveloperName, Name from Group where DeveloperName = 'Swift_Tapeout_Centre'];
        Group groupTMPW = [select Id, DeveloperName, Name from Group where DeveloperName = 'Swift_TDTI_MPW'];
        Group groupMDP = [select Id, DeveloperName, Name from Group where DeveloperName = 'Swift_MDP'];
        Group groupGS = [select Id, DeveloperName, Name from Group where DeveloperName = 'Swift_GlobalShuttle'];
        Group groupSA = [select Id, DeveloperName, Name from Group where DeveloperName = 'Swift_Admin'];
        Group groupTO = [select Id, DeveloperName, Name from Group where DeveloperName = 'Swift_Tapeout_Operations'];
        
        List<GroupMember> listGM = new List<GroupMember>(); 
        GroupMember groupMemberTA = new GroupMember(GroupId = groupTA.Id,UserOrGroupId = userSA.Id); 
        GroupMember groupMemberTC = new GroupMember(GroupId = groupTC.Id,UserOrGroupId = userSA.Id);
        GroupMember groupMemberTMPW = new GroupMember(GroupId = groupTMPW.Id,UserOrGroupId = userSA.Id);
        GroupMember groupMemberTMDP = new GroupMember(GroupId = groupMDP.Id,UserOrGroupId = userSA.Id);
        GroupMember groupMemberGS = new GroupMember(GroupId = groupGS.Id,UserOrGroupId = userSA.Id);
        GroupMember groupMemberSA = new GroupMember(GroupId = groupSA.Id,UserOrGroupId = userSA.Id); 
        GroupMember groupMemberTO = new GroupMember(GroupId = groupTO.Id,UserOrGroupId = userSA.Id);          
        listGM.add(groupMemberTA);
        listGM.add(groupMemberTC);
        listGM.add(groupMemberTMPW);
        listGM.add(groupMemberTMDP);
        listGM.add(groupMemberGS);
        listGM.add(groupMemberSA);
        listGM.add(groupMemberTO);
        insert listGM;
        
        System.runAs(userSA){
            Test.startTest();
            // comment-out, refactor with testSetup method setup()
          // SwiftDataUtilityTest.customSystemData();
             
            //Account acc = SwiftDataUtilityTest.createTestAccountForDRT();
            Account acc = getAccount('Test Account 009');
            acc.stage__c = 'Qualified';
            update acc;
            //Account acc = SwiftDataUtilityTest.createTestAccount();
            //List<Mask_Set_Title__c> mstList=SwiftDataUtilityTest.maskSetTitleList(1);
            List<Mask_Set_Title__c> mstList= [SELECT Id, Name FROM Mask_Set_Title__c LIMIT 1];
            //System.assertNotEquals(mstList[0].Id, null);
            DRT__c objDRT = new DRT__c(Name='Test DRT');
            insert objDRT;
            ApexPages.currentPage().getHeaders().put('Host','MRS Page');
            ApexPages.currentPage().getParameters().put('jobview','Customer');         
            
            MRSMEBESJobviewExtn controller = new MRSMEBESJobviewExtn (new ApexPages.StandardController(objDRT));
            //system.assertEquals(controller.isBreadcrumbActive, false);
            //system.assertEquals(controller.jobviewName, 'Customer'); 
            ApexPages.currentPage().getParameters().put('jobview','Foundry');
            MRSMEBESJobviewExtn controllerTwo = new MRSMEBESJobviewExtn (new ApexPages.StandardController(objDRT));
            Cookie account = new Cookie('account', acc.Id, null, -1, false);
            ApexPages.currentPage().setCookies(new Cookie[]{account});
            Cookie mst = new Cookie('mst', mstList.get(0).Id, null, -1, false);
            ApexPages.currentPage().setCookies(new Cookie[]{mst}); 
            ApexPages.currentPage().getParameters().put('jobview','TapeoutCentre');
            //Account acc2 = createTestAccountForDRT();
            MRSMEBESJobviewExtn controllerThree = new MRSMEBESJobviewExtn (new ApexPages.StandardController(objDRT));
            /*
            ApexPages.currentPage().getParameters().put('jobview','TapeoutApp');
            account = new Cookie('account', null, null, -1, false);
            account = new Cookie('account', acc.Id, null, -1, false);
            ApexPages.currentPage().setCookies(new Cookie[]{account});
            mst = new Cookie('mst', null, null, -1, false);          
            ApexPages.currentPage().setCookies(new Cookie[]{mst}); 
            MRSMEBESJobviewExtn controllerFour = new MRSMEBESJobviewExtn (new ApexPages.StandardController(objDRT));
            ApexPages.currentPage().getParameters().put('jobview','GlobalShuttle');
            MRSMEBESJobviewExtn controllerFive = new MRSMEBESJobviewExtn (new ApexPages.StandardController(objDRT));
            ApexPages.currentPage().getParameters().put('jobview','MDP');
            MRSMEBESJobviewExtn controllerSix = new MRSMEBESJobviewExtn (new ApexPages.StandardController(objDRT));
            */
            Test.stopTest();
        }
    }
    
    /**
        This test method tests the constructor of MRSMEBESJobviewExtn class.
        @method name: TestConstructor
        @parameter:   none.
        @return :     None.
     **/
     
    public static testMethod void TestConstructor1 (){
        /*      
        Profile sysAdminProfile = [SELECT Id FROM Profile WHERE Name='System Administrator'];       
        User sysAdminUser = [SELECT Id,Name FROM User WHERE Profile.Name = 'System Administrator' AND isActive = true].get(0);
        User userSA = new User(alias = 'testMRS', email='testMRS@test.com',
        emailencodingkey='UTF-8', lastname='testMRSLast', firstname='testMRSFirst', languagelocalekey='en_US',
        localesidkey='en_US', profileid = sysAdminProfile.Id,
        timezonesidkey='America/Los_Angeles', username='testMRS@test.com',communitynickname='testMRS');
        insert userSA;
        */
        User userSA = [SELECT Id FROM User WHERE Email = 'testMRS@test.com'];
        
        Group groupTA = [select Id, DeveloperName, Name from Group where DeveloperName = 'Swift_Tapeout_Application'];
        Group groupTC = [select Id, DeveloperName, Name from Group where DeveloperName = 'Swift_Tapeout_Centre'];
        Group groupTMPW = [select Id, DeveloperName, Name from Group where DeveloperName = 'Swift_TDTI_MPW'];
        Group groupMDP = [select Id, DeveloperName, Name from Group where DeveloperName = 'Swift_MDP'];
        Group groupGS = [select Id, DeveloperName, Name from Group where DeveloperName = 'Swift_GlobalShuttle'];
        Group groupSA = [select Id, DeveloperName, Name from Group where DeveloperName = 'Swift_Admin'];
        Group groupTO = [select Id, DeveloperName, Name from Group where DeveloperName = 'Swift_Tapeout_Operations'];
        
        List<GroupMember> listGM = new List<GroupMember>(); 
        GroupMember groupMemberTA = new GroupMember(GroupId = groupTA.Id,UserOrGroupId = userSA.Id); 
        GroupMember groupMemberTC = new GroupMember(GroupId = groupTC.Id,UserOrGroupId = userSA.Id);
        GroupMember groupMemberTMPW = new GroupMember(GroupId = groupTMPW.Id,UserOrGroupId = userSA.Id);
        GroupMember groupMemberTMDP = new GroupMember(GroupId = groupMDP.Id,UserOrGroupId = userSA.Id);
        GroupMember groupMemberGS = new GroupMember(GroupId = groupGS.Id,UserOrGroupId = userSA.Id);
        GroupMember groupMemberSA = new GroupMember(GroupId = groupSA.Id,UserOrGroupId = userSA.Id); 
        GroupMember groupMemberTO = new GroupMember(GroupId = groupTO.Id,UserOrGroupId = userSA.Id);          
        listGM.add(groupMemberTA);
        listGM.add(groupMemberTC);
        listGM.add(groupMemberTMPW);
        listGM.add(groupMemberTMDP);
        listGM.add(groupMemberGS);
        listGM.add(groupMemberSA);
        listGM.add(groupMemberTO);
        insert listGM;
        
        System.runAs(userSA){
            Test.startTest();
            // comment-out, refactor with testSetup method setup()
          // SwiftDataUtilityTest.customSystemData();
             
            //Account acc = SwiftDataUtilityTest.createTestAccountForDRT();
            Account acc = getAccount('Test Account 009');
            acc.stage__c = 'Qualified';
            update acc;
            //Account acc = SwiftDataUtilityTest.createTestAccount();
            //List<Mask_Set_Title__c> mstList=SwiftDataUtilityTest.maskSetTitleList(1);
            List<Mask_Set_Title__c> mstList=[SELECT Id, Name FROM Mask_Set_Title__c LIMIT 1];
            //System.assertNotEquals(mstList[0].Id, null);
            DRT__c objDRT = new DRT__c(Name='Test DRT');
            insert objDRT;
            ApexPages.currentPage().getHeaders().put('Host','MRS Page');
            //ApexPages.currentPage().getParameters().put('jobview','Customer');         
            
            //MRSMEBESJobviewExtn controller = new MRSMEBESJobviewExtn (new ApexPages.StandardController(objDRT));
            //system.assertEquals(controller.isBreadcrumbActive, false);
            //system.assertEquals(controller.jobviewName, 'Customer'); 
            //ApexPages.currentPage().getParameters().put('jobview','Foundry');
            //MRSMEBESJobviewExtn controllerTwo = new MRSMEBESJobviewExtn (new ApexPages.StandardController(objDRT));
            Cookie account = new Cookie('account', acc.Id, null, -1, false);
            ApexPages.currentPage().setCookies(new Cookie[]{account});
            Cookie mst = new Cookie('mst', mstList.get(0).Id, null, -1, false);
            ApexPages.currentPage().setCookies(new Cookie[]{mst}); 
            //ApexPages.currentPage().getParameters().put('jobview','TapeoutCentre');
            //Account acc2 = createTestAccountForDRT();
            Account acc2 = getAccount('TEST rec2');
            //MRSMEBESJobviewExtn controllerThree = new MRSMEBESJobviewExtn (new ApexPages.StandardController(objDRT));
            ApexPages.currentPage().getParameters().put('jobview','TapeoutApp');
            account = new Cookie('account', null, null, -1, false);
            account = new Cookie('account', acc.Id, null, -1, false);
            ApexPages.currentPage().setCookies(new Cookie[]{account});
            mst = new Cookie('mst', null, null, -1, false);          
            ApexPages.currentPage().setCookies(new Cookie[]{mst}); 
            MRSMEBESJobviewExtn controllerFour = new MRSMEBESJobviewExtn (new ApexPages.StandardController(objDRT));
            ApexPages.currentPage().getParameters().put('jobview','GlobalShuttle');
            MRSMEBESJobviewExtn controllerFive = new MRSMEBESJobviewExtn (new ApexPages.StandardController(objDRT));
            ApexPages.currentPage().getParameters().put('jobview','MDP');
            MRSMEBESJobviewExtn controllerSix = new MRSMEBESJobviewExtn (new ApexPages.StandardController(objDRT));
            
            Test.stopTest();
        }
    }
    
    /**
        This test method tests the constructor of MRSMEBESJobviewExtn class2.
        @method name: TestConstructor2
        @parameter:   none.
        @return :     None.
     **/
     
    public static testMethod void TestConstructor2 (){
        /*      
        Profile sysAdminProfile = [SELECT Id FROM Profile WHERE Name='System Administrator'];       
        User sysAdminUser = [SELECT Id,Name FROM User WHERE Profile.Name = 'System Administrator' AND isActive = true].get(0);
        User userSA = new User(alias = 'testMRS', email='testMRS@test.com',
        emailencodingkey='UTF-8', lastname='testMRSLast', firstname='testMRSFirst', languagelocalekey='en_US',
        localesidkey='en_US', profileid = sysAdminProfile.Id,
        timezonesidkey='America/Los_Angeles', username='testMRS@test.com',communitynickname='testMRS');
        insert userSA;
        */
        User userSA = [SELECT Id FROM User WHERE Email = 'testMRS@test.com'];
        
        Group groupTA = [select Id, DeveloperName, Name from Group where DeveloperName = 'Swift_Tapeout_Application'];
        Group groupTC = [select Id, DeveloperName, Name from Group where DeveloperName = 'Swift_Tapeout_Centre'];
        Group groupTMPW = [select Id, DeveloperName, Name from Group where DeveloperName = 'Swift_TDTI_MPW'];
        Group groupMDP = [select Id, DeveloperName, Name from Group where DeveloperName = 'Swift_MDP'];
        Group groupGS = [select Id, DeveloperName, Name from Group where DeveloperName = 'Swift_GlobalShuttle'];
        Group groupSA = [select Id, DeveloperName, Name from Group where DeveloperName = 'Swift_Admin'];
        Group groupTO = [select Id, DeveloperName, Name from Group where DeveloperName = 'Swift_Tapeout_Operations'];
        
        List<GroupMember> listGM = new List<GroupMember>(); 
        GroupMember groupMemberTA = new GroupMember(GroupId = groupTA.Id,UserOrGroupId = userSA.Id); 
        GroupMember groupMemberTC = new GroupMember(GroupId = groupTC.Id,UserOrGroupId = userSA.Id);
        GroupMember groupMemberTMPW = new GroupMember(GroupId = groupTMPW.Id,UserOrGroupId = userSA.Id);
        GroupMember groupMemberTMDP = new GroupMember(GroupId = groupMDP.Id,UserOrGroupId = userSA.Id);
        GroupMember groupMemberGS = new GroupMember(GroupId = groupGS.Id,UserOrGroupId = userSA.Id);
        GroupMember groupMemberSA = new GroupMember(GroupId = groupSA.Id,UserOrGroupId = userSA.Id); 
        GroupMember groupMemberTO = new GroupMember(GroupId = groupTO.Id,UserOrGroupId = userSA.Id);          
        listGM.add(groupMemberTA);
        listGM.add(groupMemberTC);
        listGM.add(groupMemberTMPW);
        listGM.add(groupMemberTMDP);
        listGM.add(groupMemberGS);
        listGM.add(groupMemberSA);
        listGM.add(groupMemberTO);
        insert listGM;
        
        System.runAs(userSA){
            Test.startTest();  
            // comment-out, refactor with testSetup method setup()
          // SwiftDataUtilityTest.customSystemData();
             
            //Account acc = SwiftDataUtilityTest.createTestAccountForDRT();
            Account acc = getAccount('Test Account 009');
            acc.stage__c = 'Qualified';
            update acc;
            //List<Mask_Set_Title__c> mstList=SwiftDataUtilityTest.maskSetTitleList(1);
            List<Mask_Set_Title__c> mstList=[SELECT Id, Name FROM Mask_Set_Title__c LIMIT 1];
            //System.assertNotEquals(mstList[0].Id, null);
            DRT__c objDRT = new DRT__c(Name='Test DRT');
            insert objDRT;
            ApexPages.currentPage().getHeaders().put('Host','MRS Page');         
                    
            Cookie account = new Cookie('account', acc.Id, null, -1, false);
            ApexPages.currentPage().setCookies(new Cookie[]{account});
            Cookie mst = new Cookie('mst', mstList.get(0).Id, null, -1, false);
            ApexPages.currentPage().setCookies(new Cookie[]{mst}); 
            //Account acc2 = createTestAccountForDRT();
            Account acc2 = getAccount('TEST rec2');
            ApexPages.currentPage().getParameters().put('jobview','MPWTDTI');           
            MRSMEBESJobviewExtn controllerSeven = new MRSMEBESJobviewExtn (new ApexPages.StandardController(objDRT));
            //system.assertEquals(controllerSeven.isBreadcrumbActive, false);
            //system.assertEquals(controllerSeven.jobviewName, 'TDTI-MPW');
            ApexPages.currentPage().getParameters().put('jobview','Others');
            MRSMEBESJobviewExtn controllerEight = new MRSMEBESJobviewExtn (new ApexPages.StandardController(objDRT));        
            Test.stopTest();
        }
    }
    
    /**
        This test method creates Test Account.
        @method name: createTestAccountForDRT
        @parameter:   none.
        @return :     None.
     **/
     
    public static Account createTestAccountForDRT(){
        recordtype rt=[select id from recordtype where sobjecttype='Account' and developername='GLOBALFOUNDRIES_Internal'] ;         
        Account acc2 = new Account(
            name = 'TEST rec2',
            recordtypeid=rt.id,
            stage__c = 'Unqualified',//Qualified
            short_name__c = 'TESTrec2',
            sub_type__c= 'Direct',
            site_department__c = 'test dept',
            transaction_type__c = 'Transactional',
            account_profile__c = 'Fabless - Emerging',
            Process_Tech_Interested__c = 'Mature (> 0.11um)',
            region__c = 'APJ',
            Market_Segment__c = 'Mobility',
            Sales_Territory__c = 'APJ-Japan',
            FE_Territory__c = 'APJ-FE-JAPAN',
            financial_territory__c = 'APJ-Japan',
            Corporate_Address_1__c = '50 water st',
             Bill_To_Address_1__c= '50 water st',
            Corporate_City__c = 'Lee',
            Bill_To_City__c='Lee',
            Corporate_Country__c = 'Japan',
             Bill_To_Country__c='Japan',
            Organization_Unit__c = 'GF Investment LLC OU',
            bill_to_location__c = 'YES',
            total_employee__c = 100,
            end_customer__c = 'people',
            Revenue_Potential__c = 'High Potential',
            Customer_Number__c='',
            Target_Account__c = 'Yes',
            siebel_account_id__c='1111',
            //--------------------------------
            Fab_9_10__c = 'No'
        );
            
        insert acc2; 
        return acc2;
    }
    
    /**
        This test method creates Layer Chip data.
        @method name: createLayerChipData
        @parameter:   MRS_Layer_Chip_Association__c object.
        @return :     MRS_Layer_Chip_Association__c object.
     **/
     
    public static MRS_Layer_Chip_Association__c createLayerChipData(MRS_Layer_Chip_Association__c obj){
        obj.Customer_MEBES_Jobview__c = 'Ready';
        obj.Foundry_MEBES_Jobview__c = 'Ready';
        obj.GlobalShuttle_MEBES_Jobview__c = 'Ready';
        obj.MDP_MEBES_Jobview__c = 'Ready';
        obj.TDTI_MPW_MEBES_Jobview__c = 'Ready';
        obj.Tapeout_Applications_MEBES_Jobview__c = 'Ready';
        obj.Tapeout_Centre_MEBES_Jobview__c = 'Ready';  
        obj.Customer_MEBES_Jobview_Date__c =  Datetime.now();
        obj.Foundry_MEBES_Jobview_Date__c =  Datetime.now();
        obj.GlobalShuttle_MEBES_Jobview_Date__c =  Datetime.now();
        obj.MDP_MEBES_Jobview_Date__c =  Datetime.now();
        obj.TDTI_MPW_MEBES_Date__c =  Datetime.now();
        obj.Tapeout_Applications_MEBES_Jobview_Date__c =  Datetime.now();
        obj.Tapeout_Centre_MEBES_Jobview_Date__c =  Datetime.now();
        return obj;
    }
    
    /**
        This test method tests the main big methods of MRSMEBESJobviewExtn class.
        @method name: TestMainMethods
        @parameter:   none.
        @return :     None.
     **/
     
    public static testMethod void TestMainMethods (){
        // comment-out, refactor with testSetup method setup()
          // SwiftDataUtilityTest.customSystemData();
        //Account acc = SwiftDataUtilityTest.createTestAccountForDRT();
        Account acc = getAccount('Test Account 009');
        acc.stage__c = 'Qualified';
        update acc;
        User sysAdminUser = [SELECT Id,Name FROM User WHERE Profile.Name = 'System Administrator' AND isActive = true].get(0);
        /*Profile sysAdminProfile = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
        User userSA = new User(alias = 'testMRS', email='testMRS@test.com',
        emailencodingkey='UTF-8', lastname='testMRSLast', firstname='testMRSFirst', languagelocalekey='en_US',
        localesidkey='en_US', profileid = sysAdminProfile.Id,
        timezonesidkey='America/Los_Angeles', username='testMRS@test.com',communitynickname='testMRS');
        insert userSA; 
        */
        User userSA = [SELECT Id FROM User WHERE Email = 'testMRS@test.com'];
        
        Account_Team_Proxy__c atp = new Account_Team_Proxy__c(User__c = userSA.id,Account__c=acc.id,Account_Access__c='Read/Write',
        Opportunity_Access__c='Read/Write',Team_Role__c='Field Application Engineer',Sequence_No__c='1',Account_Role_ID__c='test1239');       
        insert atp;                
        System.runAs(sysAdminUser){
            Test.startTest();
            Group groupGS = [select Id, DeveloperName, Name from Group where DeveloperName = 'Swift_GlobalShuttle'];
            Group groupSA = [select Id, DeveloperName, Name from Group where DeveloperName = 'SWIFT_Admin'];
            Group groupFJ = [select Id, DeveloperName, Name from Group where DeveloperName = 'Swift_Foundry_Jobviewer'];
            List<GroupMember> listGM = new List<GroupMember>(); 
            GroupMember groupMemberSA = new GroupMember(GroupId = groupSA.Id,UserOrGroupId = userSA.Id);
            GroupMember groupMemberGS = new GroupMember(GroupId = groupGS.Id,UserOrGroupId = userSA.Id);   
            GroupMember groupMemberFJ = new GroupMember(GroupId = groupFJ.Id,UserOrGroupId = userSA.Id);       
            listGM.add(groupMemberSA);
            listGM.add(groupMemberGS);
            listGM.add(groupMemberFJ);
            insert listGM;
            //Mask_Set_Title__c objMST = SwiftDataUtilityTest.createMST('MPW001');
            //insert objMST;
            Mask_Set_Title__c objMST = [SELECT Id, Name FROM Mask_Set_Title__c LIMIT 1];
            PTRF__c objPTRF = new PTRF__c(Name ='PTRF1',Order_Type__c ='Test Order Type',Recticle_Type__c ='Multi Node Reticle (MNR)',MaskSetTitle__c=objMST.Id,Customer__c=acc.id, Prime_Tapeout__c = true ,Prime_GDSOUT_Review__c=true,Status__c='Perform Tapeout Options',Device_Id__c='Dev1234');
            insert objPTRF;
            List<PTRF_JobViewer_Info__c> listPTRFJVI = new List<PTRF_JobViewer_Info__c>();
            PTRF_JobViewer_Info__c objPTRFJVC = new PTRF_JobViewer_Info__c(Name='SAC',PTRF__c=objPTRF.Id,Jobview__c='Customer',Jobview_Type__c='Frame Mockup;Prime GDSOUT Review;MEBES Jobview',User__c=userSA.Id);
            PTRF_JobViewer_Info__c objPTRFJVF = new PTRF_JobViewer_Info__c(Name='SAF',PTRF__c=objPTRF.Id,Jobview__c='Foundry',Jobview_Type__c='Frame Mockup;Prime GDSOUT Review;MEBES Jobview',User__c=userSA.Id);
            //PTRF_JobViewer_Info__c objPTRFJVCust = new PTRF_JobViewer_Info__c(Name='SACust',PTRF__c=objPTRF.Id,Jobview__c='Customer',Jobview_Type__c='Frame Mockup;Prime GDSOUT Review;MEBES Jobview',User__c=listCon.get(0).Id);
            listPTRFJVI.add(objPTRFJVC);
            listPTRFJVI.add(objPTRFJVF);
            //listPTRFJVI.add(objPTRFJVCust);
            insert listPTRFJVI;
            //MRS__c objMRS = new MRS__c(Mask_Set_Title__c=objMST.Id);
            //insert objMRS;
            MRS__c objMRS = [SELECT Id, Mask_Set_Title__c FROM MRS__c LIMIT 1];
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
            MRS_Chip_Details__c objMRSCD4 = new MRS_Chip_Details__c(MRS__c=objMRS.Id,Name='Chip004');
            MRS_Chip_Details__c objMRSCD5 = new MRS_Chip_Details__c(MRS__c=objMRS.Id,Name='Chip005');
            listMRSCD.add(objMRSCD1);
            listMRSCD.add(objMRSCD2);
            listMRSCD.add(objMRSCD3);
            listMRSCD.add(objMRSCD4);
            listMRSCD.add(objMRSCD5);
            insert listMRSCD;
            
            
            
            List<MRS_Layer_Chip_Association__c> listMRSLCA = new List<MRS_Layer_Chip_Association__c>();
            MRS_Layer_Chip_Association__c objMRSLCA1 = new MRS_Layer_Chip_Association__c(Layer__c=objMRSLA1.Id,Chip__c=objMRSCD1.Id,PTRF__c=objPTRF.Id,Tech_Geo__c='0.019UM',Customer_Name__c=acc.Id,Device_Id__c='Device1',Mask_Set_Title_Id__c=String.valueOf(objMST.Id).substring(0,15));
            MRS_Layer_Chip_Association__c objMRSLCA2 = new MRS_Layer_Chip_Association__c(Layer__c=objMRSLA1.Id,Chip__c=objMRSCD2.Id,PTRF__c=objPTRF.Id,Tech_Geo__c='0.019UM',Customer_Name__c=acc.Id,Device_Id__c='Device1',Mask_Set_Title_Id__c=String.valueOf(objMST.Id).substring(0,15));
            MRS_Layer_Chip_Association__c objMRSLCA3 = new MRS_Layer_Chip_Association__c(Layer__c=objMRSLA2.Id,Chip__c=objMRSCD1.Id,PTRF__c=objPTRF.Id,Tech_Geo__c='0.019UM',Customer_Name__c=acc.Id,Device_Id__c='Device1',Mask_Set_Title_Id__c=String.valueOf(objMST.Id).substring(0,15));
            MRS_Layer_Chip_Association__c objMRSLCA4 = new MRS_Layer_Chip_Association__c(Layer__c=objMRSLA2.Id,Chip__c=objMRSCD2.Id,PTRF__c=objPTRF.Id,Tech_Geo__c='0.019UM',Customer_Name__c=acc.Id,Device_Id__c='Device1',Mask_Set_Title_Id__c=String.valueOf(objMST.Id).substring(0,15));
            MRS_Layer_Chip_Association__c objMRSLCA5 = new MRS_Layer_Chip_Association__c(Layer__c=objMRSLA1.Id,Chip__c=objMRSCD3.Id,PTRF__c=objPTRF.Id,Tech_Geo__c='0.019UM',Customer_Name__c=acc.Id,Device_Id__c='Device1',Mask_Set_Title_Id__c=String.valueOf(objMST.Id).substring(0,15));
            MRS_Layer_Chip_Association__c objMRSLCA6 = new MRS_Layer_Chip_Association__c(Layer__c=objMRSLA2.Id,Chip__c=objMRSCD3.Id,PTRF__c=objPTRF.Id,Tech_Geo__c='0.019UM',Customer_Name__c=acc.Id,Device_Id__c='Device1',Mask_Set_Title_Id__c=String.valueOf(objMST.Id).substring(0,15));
            MRS_Layer_Chip_Association__c objMRSLCA7 = new MRS_Layer_Chip_Association__c(Layer__c=objMRSLA1.Id,Chip__c=objMRSCD4.Id,PTRF__c=objPTRF.Id,Tech_Geo__c='0.019UM',Customer_Name__c=acc.Id,Device_Id__c='Device1',Mask_Set_Title_Id__c=String.valueOf(objMST.Id).substring(0,15));
            MRS_Layer_Chip_Association__c objMRSLCA8 = new MRS_Layer_Chip_Association__c(Layer__c=objMRSLA2.Id,Chip__c=objMRSCD5.Id,PTRF__c=objPTRF.Id,Tech_Geo__c='0.019UM',Customer_Name__c=acc.Id,Device_Id__c='Device1',Mask_Set_Title_Id__c=String.valueOf(objMST.Id).substring(0,15));
            objMRSLCA1 = createLayerChipData(objMRSLCA1);
            objMRSLCA2 = createLayerChipData(objMRSLCA2);
            objMRSLCA3 = createLayerChipData(objMRSLCA3);
            objMRSLCA4 = createLayerChipData(objMRSLCA4);
            objMRSLCA5 = createLayerChipData(objMRSLCA5);
            objMRSLCA6 = createLayerChipData(objMRSLCA6);
            objMRSLCA7 = createLayerChipData(objMRSLCA7);
            objMRSLCA8 = createLayerChipData(objMRSLCA8);
            listMRSLCA.add(objMRSLCA1);
            listMRSLCA.add(objMRSLCA2);
            listMRSLCA.add(objMRSLCA3);
            listMRSLCA.add(objMRSLCA4);
            listMRSLCA.add(objMRSLCA5);
            listMRSLCA.add(objMRSLCA6);
            listMRSLCA.add(objMRSLCA7);
            listMRSLCA.add(objMRSLCA8);
            insert listMRSLCA;
            System.runAs(userSA){
                DRT__c objDRT = new DRT__c(Name='Test DRT');
                insert objDRT;
                ApexPages.currentPage().getHeaders().put('Host','MRS Page');
                ApexPages.currentPage().getParameters().put('jobview','Customer');                 
                //Test.startTest();
                MRSMEBESJobviewExtn controller = new MRSMEBESJobviewExtn (new ApexPages.StandardController(objDRT));
                //system.assertEquals(controller.jobviewName, 'Customer');
                controller.selectedCustomer = acc.Id;
                controller.populateMSTList();
                //system.assertEquals(controller.customerNameAfterSave.toUpperCase(),'TEST REC (TESTREC)');                
                controller.populateMSTList();
                controller.selectedMST = objMST.Id;
                
                controller.populateMEBESTable();
                //system.assertEquals(controller.mstAfterSave, 'MPW001');
                /*controller.jobviewName = 'Foundry';               
                controller.populateMEBESTable();*/
                controller.getMaskLayerList0();
                controller.getMaskLayerList1();
                controller.getMaskLayerList2();
                controller.getMaskLayerList3();
                controller.getMaskLayerList4();
                controller.getMaskLayerList5();
                controller.getMaskLayerList6();
                controller.getMaskLayerList7();
                controller.getMaskLayerList8();
                controller.getMaskLayerList9();
                /*//system.assertEquals(controller.isUserGS, true);
                controller.jobviewName = 'Tapeout Centre';
                //Test.startTest();
                controller.populateMEBESTable();
                controller.jobviewName = 'Tapeout Application';
                controller.populateMEBESTable();
                //system.assertEqualscontroller.isTechGeoActive, true);                
                controller.jobviewName = 'Global Shuttle';
                controller.populateMEBESTable();
                controller.jobviewName = 'MDP';
                controller.populateMEBESTable();
                controller.jobviewName = 'TDTI-MPW';
                controller.populateMEBESTable();*/
                /*----------------Wrapper Chip----------*/
               MRSMEBESJobviewExtn.WrapperChip wrpChip = new MRSMEBESJobviewExtn.WrapperChip('Chip001'); 
               List<MRSMEBESJobviewExtn.WrapperChip> lstMainTableData = new List<MRSMEBESJobviewExtn.WrapperChip>();
               lstMainTableData.add(wrpChip);
               String MainTable=JSON.serialize(lstMainTableData);
               controller.mainTableJSON=MainTable;
             /*-------------------WrapperLayerPtrf -------------------*/
               MRSMEBESJobviewExtn.WrapperLayerPtrf wrpLayerPtrf = new MRSMEBESJobviewExtn.WrapperLayerPtrf('1','RXAZ(123)',objPTRF.Name,String.Valueof(objPTRF.Id),'0.019UM'); 
              List<MRSMEBESJobviewExtn.WrapperLayerPtrf> lstsideHeader= new List<MRSMEBESJobviewExtn.WrapperLayerPtrf>();
              lstsideHeader.add(wrpLayerPtrf);       
              String sideHeader=JSON.serialize(lstsideHeader);
              controller.sideHeaderJSON=sideHeader;
              /*--------------WrapperStatusCheck----------------*/
               MRSMEBESJobviewExtn.WrapperStatusCheck wrpStsCheck = new MRSMEBESJobviewExtn.WrapperStatusCheck('CHECKED','READY'); 
              List<MRSMEBESJobviewExtn.WrapperStatusCheck> lstgridTbl= new List<MRSMEBESJobviewExtn.WrapperStatusCheck>();
              lstgridTbl.add(wrpStsCheck );
              String gridTbl=JSON.serialize(lstgridTbl);
              controller.gridTblJSON=gridTbl;
              controller.approvalData();
              controller.jobviewName = 'Foundry';
              controller.approvalData();
              //system.assertEquals(controller.isReleaseComments, true);              
              controller.saveData();
              //system.assertEquals(controller.errorMessage, true);             
              controller.releaseReasonTxt = 'Release Reason';
              controller.isReleaseComments = true;
              controller.saveData(); 
              controller.releaseReasonTxt = 'Release Reason';             
              controller.isReleaseComments = true;
              controller.jobviewName = 'Customer';
              controller.saveData();
              controller.releaseReasonTxt = 'Release Reason';
              controller.isReleaseComments = true;
              controller.jobviewName = 'Tapeout Centre';
              controller.saveData();
              controller.releaseReasonTxt = 'Release Reason';
              controller.isReleaseComments = true;
              controller.jobviewName = 'Tapeout Application';
              controller.saveData();
              /*controller.jobviewName = 'Global Shuttle';
              controller.saveData();
              controller.jobviewName = 'MDP';
              controller.saveData();
              controller.jobviewName = 'TDTI-MPW';
              controller.saveData();*/
            }
            Test.stopTest();
        }   
    }
    
    /**
        This test method tests the main big methods of MRSMEBESJobviewExtn class.
        @method name: TestMainMethods2
        @parameter:   none.
        @return :     None.
     **/
     
    public static testMethod void TestMainMethods2 (){
        // comment-out, refactor with testSetup method setup()
          // SwiftDataUtilityTest.customSystemData();
        ///Account acc = SwiftDataUtilityTest.createTestAccountForDRT();
        Account acc = getAccount('Test Account 009');
        acc.stage__c = 'Qualified';
        update acc;
        User sysAdminUser = [SELECT Id,Name FROM User WHERE Profile.Name = 'System Administrator' AND isActive = true].get(0);
        /*Profile sysAdminProfile = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
        User userSA = new User(alias = 'testMRS', email='testMRS@test.com',
        emailencodingkey='UTF-8', lastname='testMRSLast', firstname='testMRSFirst', languagelocalekey='en_US',
        localesidkey='en_US', profileid = sysAdminProfile.Id,
        timezonesidkey='America/Los_Angeles', username='testMRS@test.com',communitynickname='testMRS');
        insert userSA;
        */
        User userSA = [SELECT Id FROM User WHERE Email = 'testMRS@test.com'];
        
        Account_Team_Proxy__c atp = new Account_Team_Proxy__c(User__c = userSA.id,Account__c=acc.id,Account_Access__c='Read/Write',
        Opportunity_Access__c='Read/Write',Team_Role__c='Field Application Engineer',Sequence_No__c='1',Account_Role_ID__c='test1239');       
        insert atp;                
        System.runAs(sysAdminUser){
            Group groupGS = [select Id, DeveloperName, Name from Group where DeveloperName = 'Swift_GlobalShuttle'];
            Group groupSA = [select Id, DeveloperName, Name from Group where DeveloperName = 'SWIFT_Admin'];
            Group groupFJ = [select Id, DeveloperName, Name from Group where DeveloperName = 'Swift_Foundry_Jobviewer'];
            List<GroupMember> listGM = new List<GroupMember>(); 
            GroupMember groupMemberSA = new GroupMember(GroupId = groupSA.Id,UserOrGroupId = userSA.Id);
            GroupMember groupMemberGS = new GroupMember(GroupId = groupGS.Id,UserOrGroupId = userSA.Id);   
            GroupMember groupMemberFJ = new GroupMember(GroupId = groupFJ.Id,UserOrGroupId = userSA.Id);       
            listGM.add(groupMemberSA);
            listGM.add(groupMemberGS);
            listGM.add(groupMemberFJ);
            insert listGM;
            //Mask_Set_Title__c objMST = SwiftDataUtilityTest.createMST('MPW001');
            //insert objMST;
            Mask_Set_Title__c objMST = [SELECT Id, Name FROM Mask_Set_Title__c LIMIT 1];
            PTRF__c objPTRF = new PTRF__c(Name ='PTRF1',Order_Type__c ='Test Order Type',Recticle_Type__c ='Multi Node Reticle (MNR)',MaskSetTitle__c=objMST.Id,Customer__c=acc.id, Prime_Tapeout__c = true ,Prime_GDSOUT_Review__c=true,Status__c='Perform Tapeout Options',Device_Id__c='Dev1234');
            insert objPTRF;
            List<PTRF_JobViewer_Info__c> listPTRFJVI = new List<PTRF_JobViewer_Info__c>();
            PTRF_JobViewer_Info__c objPTRFJVC = new PTRF_JobViewer_Info__c(Name='SAC',PTRF__c=objPTRF.Id,Jobview__c='Customer',Jobview_Type__c='Frame Mockup;Prime GDSOUT Review;MEBES Jobview',User__c=userSA.Id);
            PTRF_JobViewer_Info__c objPTRFJVF = new PTRF_JobViewer_Info__c(Name='SAF',PTRF__c=objPTRF.Id,Jobview__c='Foundry',Jobview_Type__c='Frame Mockup;Prime GDSOUT Review;MEBES Jobview',User__c=userSA.Id);
            //PTRF_JobViewer_Info__c objPTRFJVCust = new PTRF_JobViewer_Info__c(Name='SACust',PTRF__c=objPTRF.Id,Jobview__c='Customer',Jobview_Type__c='Frame Mockup;Prime GDSOUT Review;MEBES Jobview',User__c=listCon.get(0).Id);
            listPTRFJVI.add(objPTRFJVC);
            listPTRFJVI.add(objPTRFJVF);
            //listPTRFJVI.add(objPTRFJVCust);
            insert listPTRFJVI;
            //MRS__c objMRS = new MRS__c(Mask_Set_Title__c=objMST.Id);
            //insert objMRS;
            MRS__c objMRS = [SELECT Id, Mask_Set_Title__c FROM MRS__c LIMIT 1];
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
            MRS_Layer_Chip_Association__c objMRSLCA1 = new MRS_Layer_Chip_Association__c(Layer__c=objMRSLA1.Id,Chip__c=objMRSCD1.Id,PTRF__c=objPTRF.Id,Tech_Geo__c='0.019UM',Customer_Name__c=acc.Id,Device_Id__c='Device1',Mask_Set_Title_Id__c=String.valueOf(objMST.Id).substring(0,15));
            MRS_Layer_Chip_Association__c objMRSLCA2 = new MRS_Layer_Chip_Association__c(Layer__c=objMRSLA1.Id,Chip__c=objMRSCD2.Id,PTRF__c=objPTRF.Id,Tech_Geo__c='0.019UM',Customer_Name__c=acc.Id,Device_Id__c='Device1',Mask_Set_Title_Id__c=String.valueOf(objMST.Id).substring(0,15));
            MRS_Layer_Chip_Association__c objMRSLCA3 = new MRS_Layer_Chip_Association__c(Layer__c=objMRSLA2.Id,Chip__c=objMRSCD1.Id,PTRF__c=objPTRF.Id,Tech_Geo__c='0.019UM',Customer_Name__c=acc.Id,Device_Id__c='Device1',Mask_Set_Title_Id__c=String.valueOf(objMST.Id).substring(0,15));
            MRS_Layer_Chip_Association__c objMRSLCA4 = new MRS_Layer_Chip_Association__c(Layer__c=objMRSLA2.Id,Chip__c=objMRSCD2.Id,PTRF__c=objPTRF.Id,Tech_Geo__c='0.019UM',Customer_Name__c=acc.Id,Device_Id__c='Device1',Mask_Set_Title_Id__c=String.valueOf(objMST.Id).substring(0,15));
            MRS_Layer_Chip_Association__c objMRSLCA5 = new MRS_Layer_Chip_Association__c(Layer__c=objMRSLA1.Id,Chip__c=objMRSCD3.Id,PTRF__c=objPTRF.Id,Tech_Geo__c='0.019UM',Customer_Name__c=acc.Id,Device_Id__c='Device1',Mask_Set_Title_Id__c=String.valueOf(objMST.Id).substring(0,15));
            MRS_Layer_Chip_Association__c objMRSLCA6 = new MRS_Layer_Chip_Association__c(Layer__c=objMRSLA2.Id,Chip__c=objMRSCD3.Id,PTRF__c=objPTRF.Id,Tech_Geo__c='0.019UM',Customer_Name__c=acc.Id,Device_Id__c='Device1',Mask_Set_Title_Id__c=String.valueOf(objMST.Id).substring(0,15));
            objMRSLCA1 = createLayerChipData(objMRSLCA1);
            objMRSLCA2 = createLayerChipData(objMRSLCA2);
            objMRSLCA3 = createLayerChipData(objMRSLCA3);
            objMRSLCA4 = createLayerChipData(objMRSLCA4);
            objMRSLCA5 = createLayerChipData(objMRSLCA5);
            objMRSLCA6 = createLayerChipData(objMRSLCA6);
            listMRSLCA.add(objMRSLCA1);
            listMRSLCA.add(objMRSLCA2);
            listMRSLCA.add(objMRSLCA3);
            listMRSLCA.add(objMRSLCA4);
            listMRSLCA.add(objMRSLCA5);
            listMRSLCA.add(objMRSLCA6);
            insert listMRSLCA;
            System.runAs(userSA){
                Test.startTest();
                DRT__c objDRT = new DRT__c(Name='Test DRT');
                insert objDRT;
                ApexPages.currentPage().getHeaders().put('Host','MRS Page');
                ApexPages.currentPage().getParameters().put('jobview','Customer');                 
                //Test.startTest();
                MRSMEBESJobviewExtn controller = new MRSMEBESJobviewExtn (new ApexPages.StandardController(objDRT));
                //system.assertEquals(controller.jobviewName, 'Customer');
                controller.selectedCustomer = acc.Id;
                controller.populateMSTList();
                //system.assertEquals(controller.customerNameAfterSave.toUpperCase(),'TEST REC (TESTREC)');                
                controller.populateMSTList();
                controller.selectedMST = objMST.Id;
                //controller.populateMEBESTable();
                //system.assertEquals(controller.mstAfterSave, 'MPW001');
                //controller.jobviewName = 'Foundry';                
                controller.populateMEBESTable();
                /*controller.getMaskLayerList0();
                controller.getMaskLayerList1();
                controller.getMaskLayerList2();
                controller.getMaskLayerList3();
                controller.getMaskLayerList4();
                controller.getMaskLayerList5();
                controller.getMaskLayerList6();
                controller.getMaskLayerList7();
                controller.getMaskLayerList8();
                controller.getMaskLayerList9();
                //system.assertEquals(controller.isUserGS, true);
                controller.jobviewName = 'Tapeout Centre';
                //Test.startTest();
                controller.populateMEBESTable();
                controller.jobviewName = 'Tapeout Application';
                controller.populateMEBESTable();
                //system.assertEqualscontroller.isTechGeoActive, true);                
                controller.jobviewName = 'Global Shuttle';
                controller.populateMEBESTable();
                controller.jobviewName = 'MDP';
                controller.populateMEBESTable();
                controller.jobviewName = 'TDTI-MPW';
                controller.populateMEBESTable();*/
                /*----------------Wrapper Chip----------*/
               MRSMEBESJobviewExtn.WrapperChip wrpChip = new MRSMEBESJobviewExtn.WrapperChip('Chip001'); 
               List<MRSMEBESJobviewExtn.WrapperChip> lstMainTableData = new List<MRSMEBESJobviewExtn.WrapperChip>();
               lstMainTableData.add(wrpChip);
               String MainTable=JSON.serialize(lstMainTableData);
               controller.mainTableJSON=MainTable;
             /*-------------------WrapperLayerPtrf -------------------*/
               MRSMEBESJobviewExtn.WrapperLayerPtrf wrpLayerPtrf = new MRSMEBESJobviewExtn.WrapperLayerPtrf('1','RXAZ(123)',objPTRF.Name,String.Valueof(objPTRF.Id),'0.019UM'); 
              List<MRSMEBESJobviewExtn.WrapperLayerPtrf> lstsideHeader= new List<MRSMEBESJobviewExtn.WrapperLayerPtrf>();
              lstsideHeader.add(wrpLayerPtrf);       
              String sideHeader=JSON.serialize(lstsideHeader);
              controller.sideHeaderJSON=sideHeader;
              /*--------------WrapperStatusCheck----------------*/
               MRSMEBESJobviewExtn.WrapperStatusCheck wrpStsCheck = new MRSMEBESJobviewExtn.WrapperStatusCheck('CHECKED','READY'); 
              List<MRSMEBESJobviewExtn.WrapperStatusCheck> lstgridTbl= new List<MRSMEBESJobviewExtn.WrapperStatusCheck>();
              lstgridTbl.add(wrpStsCheck );
              String gridTbl=JSON.serialize(lstgridTbl);
              controller.gridTblJSON=gridTbl;
              controller.approvalData();
              controller.jobviewName = 'Global Shuttle';
              controller.approvalData();
              //system.assertEquals(controller.isReleaseComments, true);              
              controller.saveData();
              //system.assertEquals(controller.errorMessage, true);             
              controller.releaseReasonTxt = 'Release Reason';
              controller.isReleaseComments = true;
              controller.saveData(); 
              controller.releaseReasonTxt = 'Release Reason';             
              controller.isReleaseComments = true;
              controller.jobviewName = 'MDP';
              controller.saveData();
              controller.releaseReasonTxt = 'Release Reason';
              controller.isReleaseComments = true;
              controller.jobviewName = 'TDTI-MPW';
              controller.saveData();
              /*controller.releaseReasonTxt = 'Release Reason';
              controller.isReleaseComments = true;
              controller.jobviewName = 'Tapeout Application';
              controller.saveData();
              controller.jobviewName = 'Global Shuttle';
              controller.saveData();
              controller.jobviewName = 'MDP';
              controller.saveData();
              controller.jobviewName = 'TDTI-MPW';
              controller.saveData();*/
              Test.stopTest();
            }
        }   
    }
    
    /**
        This test method tests the main big methods of MRSMEBESJobviewExtn class.
        @method name: TestMainMethods
        @parameter:   none.
        @return :     None.
     **/
     
    public static testMethod void TestMainMethodsFoundry (){
        // comment-out, refactor with testSetup method setup()
          // SwiftDataUtilityTest.customSystemData();
        //Account acc = SwiftDataUtilityTest.createTestAccountForDRT();
        Account acc = getAccount('Test Account 009');
        acc.stage__c = 'Qualified';
        update acc;
        User sysAdminUser = [SELECT Id,Name FROM User WHERE Profile.Name = 'System Administrator' AND isActive = true].get(0);
        /*Profile sysAdminProfile = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
        User userSA = new User(alias = 'testMRS', email='testMRS@test.com',
        emailencodingkey='UTF-8', lastname='testMRSLast', firstname='testMRSFirst', languagelocalekey='en_US',
        localesidkey='en_US', profileid = sysAdminProfile.Id,
        timezonesidkey='America/Los_Angeles', username='testMRS@test.com',communitynickname='testMRS');
        insert userSA; 
        */
        User userSA = [SELECT Id FROM User WHERE Email = 'testMRS@test.com'];
        
        Account_Team_Proxy__c atp = new Account_Team_Proxy__c(User__c = userSA.id,Account__c=acc.id,Account_Access__c='Read/Write',
        Opportunity_Access__c='Read/Write',Team_Role__c='Field Application Engineer',Sequence_No__c='1',Account_Role_ID__c='test1239');       
        insert atp;                
        System.runAs(sysAdminUser){
            Test.startTest();
            Group groupGS = [select Id, DeveloperName, Name from Group where DeveloperName = 'Swift_GlobalShuttle'];
            Group groupSA = [select Id, DeveloperName, Name from Group where DeveloperName = 'SWIFT_Admin'];
            Group groupFJ = [select Id, DeveloperName, Name from Group where DeveloperName = 'Swift_Foundry_Jobviewer'];
            List<GroupMember> listGM = new List<GroupMember>(); 
            GroupMember groupMemberSA = new GroupMember(GroupId = groupSA.Id,UserOrGroupId = userSA.Id);
            GroupMember groupMemberGS = new GroupMember(GroupId = groupGS.Id,UserOrGroupId = userSA.Id);   
            GroupMember groupMemberFJ = new GroupMember(GroupId = groupFJ.Id,UserOrGroupId = userSA.Id);       
            listGM.add(groupMemberSA);
            listGM.add(groupMemberGS);
            listGM.add(groupMemberFJ);
            insert listGM;
            //Mask_Set_Title__c objMST = SwiftDataUtilityTest.createMST('MPW001');
            //insert objMST;
            Mask_Set_Title__c objMST = [SELECT Id, Name FROM Mask_Set_Title__c LIMIT 1];
            PTRF__c objPTRF = new PTRF__c(Name ='PTRF1',Order_Type__c ='Test Order Type',Recticle_Type__c ='Multi Node Reticle (MNR)',MaskSetTitle__c=objMST.Id,Customer__c=acc.id, Prime_Tapeout__c = true ,Prime_GDSOUT_Review__c=true,Status__c='Perform Tapeout Options',Device_Id__c='Dev1234');
            insert objPTRF;
            List<PTRF_JobViewer_Info__c> listPTRFJVI = new List<PTRF_JobViewer_Info__c>();
            PTRF_JobViewer_Info__c objPTRFJVC = new PTRF_JobViewer_Info__c(Name='SAC',PTRF__c=objPTRF.Id,Jobview__c='Customer',Jobview_Type__c='Frame Mockup;Prime GDSOUT Review;MEBES Jobview',User__c=userSA.Id);
            PTRF_JobViewer_Info__c objPTRFJVF = new PTRF_JobViewer_Info__c(Name='SAF',PTRF__c=objPTRF.Id,Jobview__c='Foundry',Jobview_Type__c='Frame Mockup;Prime GDSOUT Review;MEBES Jobview',User__c=userSA.Id);
            //PTRF_JobViewer_Info__c objPTRFJVCust = new PTRF_JobViewer_Info__c(Name='SACust',PTRF__c=objPTRF.Id,Jobview__c='Customer',Jobview_Type__c='Frame Mockup;Prime GDSOUT Review;MEBES Jobview',User__c=listCon.get(0).Id);
            listPTRFJVI.add(objPTRFJVC);
            listPTRFJVI.add(objPTRFJVF);
            //listPTRFJVI.add(objPTRFJVCust);
            insert listPTRFJVI;
            //MRS__c objMRS = new MRS__c(Mask_Set_Title__c=objMST.Id);
            //insert objMRS;
            MRS__c objMRS = [SELECT Id, Mask_Set_Title__c FROM MRS__c LIMIT 1];
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
            MRS_Chip_Details__c objMRSCD4 = new MRS_Chip_Details__c(MRS__c=objMRS.Id,Name='Chip004');
            MRS_Chip_Details__c objMRSCD5 = new MRS_Chip_Details__c(MRS__c=objMRS.Id,Name='Chip005');
            listMRSCD.add(objMRSCD1);
            listMRSCD.add(objMRSCD2);
            listMRSCD.add(objMRSCD3);
            listMRSCD.add(objMRSCD4);
            listMRSCD.add(objMRSCD5);
            insert listMRSCD;
            List<MRS_Layer_Chip_Association__c> listMRSLCA = new List<MRS_Layer_Chip_Association__c>();
            MRS_Layer_Chip_Association__c objMRSLCA1 = new MRS_Layer_Chip_Association__c(Layer__c=objMRSLA1.Id,Chip__c=objMRSCD1.Id,PTRF__c=objPTRF.Id,Tech_Geo__c='0.019UM',Customer_Name__c=acc.Id,Device_Id__c='Device1',Mask_Set_Title_Id__c=String.valueOf(objMST.Id).substring(0,15));
            MRS_Layer_Chip_Association__c objMRSLCA2 = new MRS_Layer_Chip_Association__c(Layer__c=objMRSLA1.Id,Chip__c=objMRSCD2.Id,PTRF__c=objPTRF.Id,Tech_Geo__c='0.019UM',Customer_Name__c=acc.Id,Device_Id__c='Device1',Mask_Set_Title_Id__c=String.valueOf(objMST.Id).substring(0,15));
            MRS_Layer_Chip_Association__c objMRSLCA3 = new MRS_Layer_Chip_Association__c(Layer__c=objMRSLA2.Id,Chip__c=objMRSCD1.Id,PTRF__c=objPTRF.Id,Tech_Geo__c='0.019UM',Customer_Name__c=acc.Id,Device_Id__c='Device1',Mask_Set_Title_Id__c=String.valueOf(objMST.Id).substring(0,15));
            MRS_Layer_Chip_Association__c objMRSLCA4 = new MRS_Layer_Chip_Association__c(Layer__c=objMRSLA2.Id,Chip__c=objMRSCD2.Id,PTRF__c=objPTRF.Id,Tech_Geo__c='0.019UM',Customer_Name__c=acc.Id,Device_Id__c='Device1',Mask_Set_Title_Id__c=String.valueOf(objMST.Id).substring(0,15));
            MRS_Layer_Chip_Association__c objMRSLCA5 = new MRS_Layer_Chip_Association__c(Layer__c=objMRSLA1.Id,Chip__c=objMRSCD3.Id,PTRF__c=objPTRF.Id,Tech_Geo__c='0.019UM',Customer_Name__c=acc.Id,Device_Id__c='Device1',Mask_Set_Title_Id__c=String.valueOf(objMST.Id).substring(0,15));
            MRS_Layer_Chip_Association__c objMRSLCA6 = new MRS_Layer_Chip_Association__c(Layer__c=objMRSLA2.Id,Chip__c=objMRSCD3.Id,PTRF__c=objPTRF.Id,Tech_Geo__c='0.019UM',Customer_Name__c=acc.Id,Device_Id__c='Device1',Mask_Set_Title_Id__c=String.valueOf(objMST.Id).substring(0,15));
            MRS_Layer_Chip_Association__c objMRSLCA7 = new MRS_Layer_Chip_Association__c(Layer__c=objMRSLA1.Id,Chip__c=objMRSCD4.Id,PTRF__c=objPTRF.Id,Tech_Geo__c='0.019UM',Customer_Name__c=acc.Id,Device_Id__c='Device1',Mask_Set_Title_Id__c=String.valueOf(objMST.Id).substring(0,15));
            MRS_Layer_Chip_Association__c objMRSLCA8 = new MRS_Layer_Chip_Association__c(Layer__c=objMRSLA2.Id,Chip__c=objMRSCD5.Id,PTRF__c=objPTRF.Id,Tech_Geo__c='0.019UM',Customer_Name__c=acc.Id,Device_Id__c='Device1',Mask_Set_Title_Id__c=String.valueOf(objMST.Id).substring(0,15));
            objMRSLCA1 = createLayerChipData(objMRSLCA1);
            objMRSLCA2 = createLayerChipData(objMRSLCA2);
            objMRSLCA3 = createLayerChipData(objMRSLCA3);
            objMRSLCA4 = createLayerChipData(objMRSLCA4);
            objMRSLCA5 = createLayerChipData(objMRSLCA5);
            objMRSLCA6 = createLayerChipData(objMRSLCA6);
            objMRSLCA7 = createLayerChipData(objMRSLCA7);
            objMRSLCA8 = createLayerChipData(objMRSLCA8);
            listMRSLCA.add(objMRSLCA1);
            listMRSLCA.add(objMRSLCA2);
            listMRSLCA.add(objMRSLCA3);
            listMRSLCA.add(objMRSLCA4);
            listMRSLCA.add(objMRSLCA5);
            listMRSLCA.add(objMRSLCA6);
            listMRSLCA.add(objMRSLCA7);
            listMRSLCA.add(objMRSLCA8);
            insert listMRSLCA;
            System.runAs(userSA){
                
                DRT__c objDRT = new DRT__c(Name='Test DRT');
                insert objDRT;
                ApexPages.currentPage().getHeaders().put('Host','MRS Page');
                ApexPages.currentPage().getParameters().put('jobview','Customer');                 
                //Test.startTest();
                MRSMEBESJobviewExtn controller = new MRSMEBESJobviewExtn (new ApexPages.StandardController(objDRT));
                //system.assertEquals(controller.jobviewName, 'Customer');
                controller.selectedCustomer = acc.Id;
                controller.populateMSTList();
                //system.assertEquals(controller.customerNameAfterSave.toUpperCase(),'TEST REC (TESTREC)');                
                controller.populateMSTList();
                controller.selectedMST = objMST.Id;
                //controller.populateMEBESTable();
                //system.assertEquals(controller.mstAfterSave, null);
                controller.jobviewName = 'Foundry';
                
                controller.populateMEBESTable();
                /*controller.getMaskLayerList0();
                controller.getMaskLayerList1();
                controller.getMaskLayerList2();
                controller.getMaskLayerList3();
                controller.getMaskLayerList4();
                controller.getMaskLayerList5();
                controller.getMaskLayerList6();
                controller.getMaskLayerList7();
                controller.getMaskLayerList8();
                controller.getMaskLayerList9();
                //system.assertEquals(controller.isUserGS, true);
                controller.jobviewName = 'Tapeout Centre';
                //Test.startTest();
                controller.populateMEBESTable();
                controller.jobviewName = 'Tapeout Application';
                controller.populateMEBESTable();
                //system.assertEqualscontroller.isTechGeoActive, true);                
                controller.jobviewName = 'Global Shuttle';
                controller.populateMEBESTable();
                controller.jobviewName = 'MDP';
                controller.populateMEBESTable();
                controller.jobviewName = 'TDTI-MPW';
                controller.populateMEBESTable();*/
                /*----------------Wrapper Chip----------*/
               MRSMEBESJobviewExtn.WrapperChip wrpChip = new MRSMEBESJobviewExtn.WrapperChip('Chip001'); 
               List<MRSMEBESJobviewExtn.WrapperChip> lstMainTableData = new List<MRSMEBESJobviewExtn.WrapperChip>();
               lstMainTableData.add(wrpChip);
               String MainTable=JSON.serialize(lstMainTableData);
               controller.mainTableJSON=MainTable;
             /*-------------------WrapperLayerPtrf -------------------*/
               MRSMEBESJobviewExtn.WrapperLayerPtrf wrpLayerPtrf = new MRSMEBESJobviewExtn.WrapperLayerPtrf('1','RXAZ(123)',objPTRF.Name,String.Valueof(objPTRF.Id),'0.019UM'); 
              List<MRSMEBESJobviewExtn.WrapperLayerPtrf> lstsideHeader= new List<MRSMEBESJobviewExtn.WrapperLayerPtrf>();
              lstsideHeader.add(wrpLayerPtrf);       
              String sideHeader=JSON.serialize(lstsideHeader);
              controller.sideHeaderJSON=sideHeader;
              /*--------------WrapperStatusCheck----------------*/
               MRSMEBESJobviewExtn.WrapperStatusCheck wrpStsCheck = new MRSMEBESJobviewExtn.WrapperStatusCheck('CHECKED','READY'); 
              List<MRSMEBESJobviewExtn.WrapperStatusCheck> lstgridTbl= new List<MRSMEBESJobviewExtn.WrapperStatusCheck>();
              lstgridTbl.add(wrpStsCheck );
              String gridTbl=JSON.serialize(lstgridTbl);
              controller.gridTblJSON=gridTbl;
              controller.approvalData();
              controller.jobviewName = 'Foundry';
              controller.approvalData();
              //system.assertEquals(controller.isReleaseComments, true);              
              controller.saveData();
              //system.assertEquals(controller.errorMessage, true);             
              controller.releaseReasonTxt = 'Release Reason';
              controller.isReleaseComments = true;
              controller.saveData(); 
              controller.releaseReasonTxt = 'Release Reason';             
              controller.isReleaseComments = true;
              controller.jobviewName = 'Customer';
              controller.saveData();
              controller.releaseReasonTxt = 'Release Reason';
              controller.isReleaseComments = true;
              controller.jobviewName = 'Tapeout Centre';
              controller.saveData();
              controller.releaseReasonTxt = 'Release Reason';
              controller.isReleaseComments = true;
              controller.jobviewName = 'Tapeout Application';
              controller.saveData();
              /*controller.jobviewName = 'Global Shuttle';
              controller.saveData();
              controller.jobviewName = 'MDP';
              controller.saveData();
              controller.jobviewName = 'TDTI-MPW';
              controller.saveData();*/
              
            }
        }   
        Test.stopTest();
    }
    
    /**
        This test method tests the main big methods of MRSMEBESJobviewExtn class.
        @method name: TestMainMethods
        @parameter:   none.
        @return :     None.
     **/
     
    public static testMethod void TestMainMethodsTC (){
        // comment-out, refactor with testSetup method setup()
          // SwiftDataUtilityTest.customSystemData();
        //Account acc = SwiftDataUtilityTest.createTestAccountForDRT();
        Account acc = getAccount('Test Account 009');
        acc.stage__c = 'Qualified';
        update acc;
        User sysAdminUser = [SELECT Id,Name FROM User WHERE Profile.Name = 'System Administrator' AND isActive = true].get(0);
        /*Profile sysAdminProfile = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
        User userSA = new User(alias = 'testMRS', email='testMRS@test.com',
        emailencodingkey='UTF-8', lastname='testMRSLast', firstname='testMRSFirst', languagelocalekey='en_US',
        localesidkey='en_US', profileid = sysAdminProfile.Id,
        timezonesidkey='America/Los_Angeles', username='testMRS@test.com',communitynickname='testMRS');
        insert userSA; 
        */
        User userSA = [SELECT Id FROM User WHERE Email = 'testMRS@test.com'];
        
        Account_Team_Proxy__c atp = new Account_Team_Proxy__c(User__c = userSA.id,Account__c=acc.id,Account_Access__c='Read/Write',
        Opportunity_Access__c='Read/Write',Team_Role__c='Field Application Engineer',Sequence_No__c='1',Account_Role_ID__c='test1239');       
        insert atp;                
        System.runAs(sysAdminUser){
            Group groupGS = [select Id, DeveloperName, Name from Group where DeveloperName = 'Swift_GlobalShuttle'];
            Group groupSA = [select Id, DeveloperName, Name from Group where DeveloperName = 'SWIFT_Admin'];
            Group groupFJ = [select Id, DeveloperName, Name from Group where DeveloperName = 'Swift_Foundry_Jobviewer'];
            List<GroupMember> listGM = new List<GroupMember>(); 
            GroupMember groupMemberSA = new GroupMember(GroupId = groupSA.Id,UserOrGroupId = userSA.Id);
            GroupMember groupMemberGS = new GroupMember(GroupId = groupGS.Id,UserOrGroupId = userSA.Id);   
            GroupMember groupMemberFJ = new GroupMember(GroupId = groupFJ.Id,UserOrGroupId = userSA.Id);       
            listGM.add(groupMemberSA);
            listGM.add(groupMemberGS);
            listGM.add(groupMemberFJ);
            insert listGM;
            //Mask_Set_Title__c objMST = SwiftDataUtilityTest.createMST('MPW001');
            //insert objMST;
            Mask_Set_Title__c objMST = [SELECT Id, Name FROM Mask_Set_Title__c LIMIT 1];
            PTRF__c objPTRF = new PTRF__c(Name ='PTRF1',Order_Type__c ='Test Order Type',Recticle_Type__c ='Multi Node Reticle (MNR)',MaskSetTitle__c=objMST.Id,Customer__c=acc.id, Prime_Tapeout__c = true ,Prime_GDSOUT_Review__c=true,Status__c='Perform Tapeout Options',Device_Id__c='Dev1234');
            insert objPTRF;
            List<PTRF_JobViewer_Info__c> listPTRFJVI = new List<PTRF_JobViewer_Info__c>();
            PTRF_JobViewer_Info__c objPTRFJVC = new PTRF_JobViewer_Info__c(Name='SAC',PTRF__c=objPTRF.Id,Jobview__c='Customer',Jobview_Type__c='Frame Mockup;Prime GDSOUT Review;MEBES Jobview',User__c=userSA.Id);
            PTRF_JobViewer_Info__c objPTRFJVF = new PTRF_JobViewer_Info__c(Name='SAF',PTRF__c=objPTRF.Id,Jobview__c='Foundry',Jobview_Type__c='Frame Mockup;Prime GDSOUT Review;MEBES Jobview',User__c=userSA.Id);
            //PTRF_JobViewer_Info__c objPTRFJVCust = new PTRF_JobViewer_Info__c(Name='SACust',PTRF__c=objPTRF.Id,Jobview__c='Customer',Jobview_Type__c='Frame Mockup;Prime GDSOUT Review;MEBES Jobview',User__c=listCon.get(0).Id);
            listPTRFJVI.add(objPTRFJVC);
            listPTRFJVI.add(objPTRFJVF);
            //listPTRFJVI.add(objPTRFJVCust);
            insert listPTRFJVI;
            //MRS__c objMRS = new MRS__c(Mask_Set_Title__c=objMST.Id);
            //insert objMRS;
            MRS__c objMRS = [SELECT Id, Mask_Set_Title__c FROM MRS__c LIMIT 1];
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
            MRS_Chip_Details__c objMRSCD4 = new MRS_Chip_Details__c(MRS__c=objMRS.Id,Name='Chip004');
            MRS_Chip_Details__c objMRSCD5 = new MRS_Chip_Details__c(MRS__c=objMRS.Id,Name='Chip005');
            listMRSCD.add(objMRSCD1);
            listMRSCD.add(objMRSCD2);
            listMRSCD.add(objMRSCD3);
            listMRSCD.add(objMRSCD4);
            listMRSCD.add(objMRSCD5);
            insert listMRSCD;
            List<MRS_Layer_Chip_Association__c> listMRSLCA = new List<MRS_Layer_Chip_Association__c>();
            MRS_Layer_Chip_Association__c objMRSLCA1 = new MRS_Layer_Chip_Association__c(Layer__c=objMRSLA1.Id,Chip__c=objMRSCD1.Id,PTRF__c=objPTRF.Id,Tech_Geo__c='0.019UM',Customer_Name__c=acc.Id,Device_Id__c='Device1',Mask_Set_Title_Id__c=String.valueOf(objMST.Id).substring(0,15));
            MRS_Layer_Chip_Association__c objMRSLCA2 = new MRS_Layer_Chip_Association__c(Layer__c=objMRSLA1.Id,Chip__c=objMRSCD2.Id,PTRF__c=objPTRF.Id,Tech_Geo__c='0.019UM',Customer_Name__c=acc.Id,Device_Id__c='Device1',Mask_Set_Title_Id__c=String.valueOf(objMST.Id).substring(0,15));
            MRS_Layer_Chip_Association__c objMRSLCA3 = new MRS_Layer_Chip_Association__c(Layer__c=objMRSLA2.Id,Chip__c=objMRSCD1.Id,PTRF__c=objPTRF.Id,Tech_Geo__c='0.019UM',Customer_Name__c=acc.Id,Device_Id__c='Device1',Mask_Set_Title_Id__c=String.valueOf(objMST.Id).substring(0,15));
            MRS_Layer_Chip_Association__c objMRSLCA4 = new MRS_Layer_Chip_Association__c(Layer__c=objMRSLA2.Id,Chip__c=objMRSCD2.Id,PTRF__c=objPTRF.Id,Tech_Geo__c='0.019UM',Customer_Name__c=acc.Id,Device_Id__c='Device1',Mask_Set_Title_Id__c=String.valueOf(objMST.Id).substring(0,15));
            MRS_Layer_Chip_Association__c objMRSLCA5 = new MRS_Layer_Chip_Association__c(Layer__c=objMRSLA1.Id,Chip__c=objMRSCD3.Id,PTRF__c=objPTRF.Id,Tech_Geo__c='0.019UM',Customer_Name__c=acc.Id,Device_Id__c='Device1',Mask_Set_Title_Id__c=String.valueOf(objMST.Id).substring(0,15));
            MRS_Layer_Chip_Association__c objMRSLCA6 = new MRS_Layer_Chip_Association__c(Layer__c=objMRSLA2.Id,Chip__c=objMRSCD3.Id,PTRF__c=objPTRF.Id,Tech_Geo__c='0.019UM',Customer_Name__c=acc.Id,Device_Id__c='Device1',Mask_Set_Title_Id__c=String.valueOf(objMST.Id).substring(0,15));
            MRS_Layer_Chip_Association__c objMRSLCA7 = new MRS_Layer_Chip_Association__c(Layer__c=objMRSLA1.Id,Chip__c=objMRSCD4.Id,PTRF__c=objPTRF.Id,Tech_Geo__c='0.019UM',Customer_Name__c=acc.Id,Device_Id__c='Device1',Mask_Set_Title_Id__c=String.valueOf(objMST.Id).substring(0,15));
            MRS_Layer_Chip_Association__c objMRSLCA8 = new MRS_Layer_Chip_Association__c(Layer__c=objMRSLA2.Id,Chip__c=objMRSCD5.Id,PTRF__c=objPTRF.Id,Tech_Geo__c='0.019UM',Customer_Name__c=acc.Id,Device_Id__c='Device1',Mask_Set_Title_Id__c=String.valueOf(objMST.Id).substring(0,15));
            objMRSLCA1 = createLayerChipData(objMRSLCA1);
            objMRSLCA2 = createLayerChipData(objMRSLCA2);
            objMRSLCA3 = createLayerChipData(objMRSLCA3);
            objMRSLCA4 = createLayerChipData(objMRSLCA4);
            objMRSLCA5 = createLayerChipData(objMRSLCA5);
            objMRSLCA6 = createLayerChipData(objMRSLCA6);
            objMRSLCA7 = createLayerChipData(objMRSLCA7);
            objMRSLCA8 = createLayerChipData(objMRSLCA8);
            listMRSLCA.add(objMRSLCA1);
            listMRSLCA.add(objMRSLCA2);
            listMRSLCA.add(objMRSLCA3);
            listMRSLCA.add(objMRSLCA4);
            listMRSLCA.add(objMRSLCA5);
            listMRSLCA.add(objMRSLCA6);
            listMRSLCA.add(objMRSLCA7);
            listMRSLCA.add(objMRSLCA8);
            insert listMRSLCA;
            System.runAs(userSA){
                Test.startTest();
                DRT__c objDRT = new DRT__c(Name='Test DRT');
                insert objDRT;
                ApexPages.currentPage().getHeaders().put('Host','MRS Page');
                ApexPages.currentPage().getParameters().put('jobview','Customer');                 
                //Test.startTest();
                MRSMEBESJobviewExtn controller = new MRSMEBESJobviewExtn (new ApexPages.StandardController(objDRT));
                //system.assertEquals(controller.jobviewName, 'Customer');
                controller.selectedCustomer = acc.Id;
                controller.populateMSTList();
                //system.assertEquals(controller.customerNameAfterSave.toUpperCase(),'TEST REC (TESTREC)');                
                controller.populateMSTList();
                controller.selectedMST = objMST.Id;
                //controller.populateMEBESTable();
                //system.assertEquals(controller.mstAfterSave, null);
                //controller.jobviewName = 'Foundry';
                
                /*controller.populateMEBESTable();
                controller.getMaskLayerList0();
                controller.getMaskLayerList1();
                controller.getMaskLayerList2();
                controller.getMaskLayerList3();
                controller.getMaskLayerList4();
                controller.getMaskLayerList5();
                controller.getMaskLayerList6();
                controller.getMaskLayerList7();
                controller.getMaskLayerList8();
                controller.getMaskLayerList9();
                //system.assertEquals(controller.isUserGS, true);*/
                controller.jobviewName = 'Tapeout Centre';
                //Test.startTest();
                controller.populateMEBESTable();
                /*controller.jobviewName = 'Tapeout Application';
                controller.populateMEBESTable();
                //system.assertEqualscontroller.isTechGeoActive, true);                
                controller.jobviewName = 'Global Shuttle';
                controller.populateMEBESTable();
                controller.jobviewName = 'MDP';
                controller.populateMEBESTable();
                controller.jobviewName = 'TDTI-MPW';
                controller.populateMEBESTable();*/
                /*----------------Wrapper Chip----------*/
               MRSMEBESJobviewExtn.WrapperChip wrpChip = new MRSMEBESJobviewExtn.WrapperChip('Chip001'); 
               List<MRSMEBESJobviewExtn.WrapperChip> lstMainTableData = new List<MRSMEBESJobviewExtn.WrapperChip>();
               lstMainTableData.add(wrpChip);
               String MainTable=JSON.serialize(lstMainTableData);
               controller.mainTableJSON=MainTable;
             /*-------------------WrapperLayerPtrf -------------------*/
               MRSMEBESJobviewExtn.WrapperLayerPtrf wrpLayerPtrf = new MRSMEBESJobviewExtn.WrapperLayerPtrf('1','RXAZ(123)',objPTRF.Name,String.Valueof(objPTRF.Id),'0.019UM'); 
              List<MRSMEBESJobviewExtn.WrapperLayerPtrf> lstsideHeader= new List<MRSMEBESJobviewExtn.WrapperLayerPtrf>();
              lstsideHeader.add(wrpLayerPtrf);       
              String sideHeader=JSON.serialize(lstsideHeader);
              controller.sideHeaderJSON=sideHeader;
              /*--------------WrapperStatusCheck----------------*/
               MRSMEBESJobviewExtn.WrapperStatusCheck wrpStsCheck = new MRSMEBESJobviewExtn.WrapperStatusCheck('CHECKED','READY'); 
              List<MRSMEBESJobviewExtn.WrapperStatusCheck> lstgridTbl= new List<MRSMEBESJobviewExtn.WrapperStatusCheck>();
              lstgridTbl.add(wrpStsCheck );
              String gridTbl=JSON.serialize(lstgridTbl);
              controller.gridTblJSON=gridTbl;
              controller.approvalData();
              controller.jobviewName = 'Foundry';
              controller.approvalData();
              //system.assertEquals(controller.isReleaseComments, true);              
              controller.saveData();
              //system.assertEquals(controller.errorMessage, true);             
              controller.releaseReasonTxt = 'Release Reason';
              controller.isReleaseComments = true;
              controller.saveData(); 
              controller.releaseReasonTxt = 'Release Reason';             
              controller.isReleaseComments = true;
              controller.jobviewName = 'Customer';
              controller.saveData();
              controller.releaseReasonTxt = 'Release Reason';
              controller.isReleaseComments = true;
              controller.jobviewName = 'Tapeout Centre';
              controller.saveData();
              controller.releaseReasonTxt = 'Release Reason';
              controller.isReleaseComments = true;
              controller.jobviewName = 'Tapeout Application';
              controller.saveData();
              /*controller.jobviewName = 'Global Shuttle';
              controller.saveData();
              controller.jobviewName = 'MDP';
              controller.saveData();
              controller.jobviewName = 'TDTI-MPW';
              controller.saveData();*/
              Test.stopTest();
            }
        }   
    }
    
    /**
        This test method tests the main big methods of MRSMEBESJobviewExtn class.
        @method name: TestMainMethods
        @parameter:   none.
        @return :     None.
     **/
     
    public static testMethod void TestMainMethodsTA (){
        // comment-out, refactor with testSetup method setup()
          // SwiftDataUtilityTest.customSystemData();
        //Account acc = SwiftDataUtilityTest.createTestAccountForDRT();
        Account acc = getAccount('Test Account 009');
        acc.stage__c = 'Qualified';
        update acc;
        User sysAdminUser = [SELECT Id,Name FROM User WHERE Profile.Name = 'System Administrator' AND isActive = true].get(0);
        /*Profile sysAdminProfile = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
        User userSA = new User(alias = 'testMRS', email='testMRS@test.com',
        emailencodingkey='UTF-8', lastname='testMRSLast', firstname='testMRSFirst', languagelocalekey='en_US',
        localesidkey='en_US', profileid = sysAdminProfile.Id,
        timezonesidkey='America/Los_Angeles', username='testMRS@test.com',communitynickname='testMRS');
        insert userSA;
        */
        User userSA = [SELECT Id FROM User WHERE Email = 'testMRS@test.com'];
        
        Account_Team_Proxy__c atp = new Account_Team_Proxy__c(User__c = userSA.id,Account__c=acc.id,Account_Access__c='Read/Write',
        Opportunity_Access__c='Read/Write',Team_Role__c='Field Application Engineer',Sequence_No__c='1',Account_Role_ID__c='test1239');       
        insert atp;                
        System.runAs(sysAdminUser){
            Group groupGS = [select Id, DeveloperName, Name from Group where DeveloperName = 'Swift_GlobalShuttle'];
            Group groupSA = [select Id, DeveloperName, Name from Group where DeveloperName = 'SWIFT_Admin'];
            Group groupFJ = [select Id, DeveloperName, Name from Group where DeveloperName = 'Swift_Foundry_Jobviewer'];
            List<GroupMember> listGM = new List<GroupMember>(); 
            GroupMember groupMemberSA = new GroupMember(GroupId = groupSA.Id,UserOrGroupId = userSA.Id);
            GroupMember groupMemberGS = new GroupMember(GroupId = groupGS.Id,UserOrGroupId = userSA.Id);   
            GroupMember groupMemberFJ = new GroupMember(GroupId = groupFJ.Id,UserOrGroupId = userSA.Id);       
            listGM.add(groupMemberSA);
            listGM.add(groupMemberGS);
            listGM.add(groupMemberFJ);
            insert listGM;
            //Mask_Set_Title__c objMST = SwiftDataUtilityTest.createMST('MPW001');
            //insert objMST;
            Mask_Set_Title__c objMST = [SELECT Id, Name FROM Mask_Set_Title__c LIMIT 1];
            PTRF__c objPTRF = new PTRF__c(Name ='PTRF1',Order_Type__c ='Test Order Type',Recticle_Type__c ='Multi Node Reticle (MNR)',MaskSetTitle__c=objMST.Id,Customer__c=acc.id, Prime_Tapeout__c = true ,Prime_GDSOUT_Review__c=true,Status__c='Perform Tapeout Options',Device_Id__c='Dev1234');
            insert objPTRF;
            List<PTRF_JobViewer_Info__c> listPTRFJVI = new List<PTRF_JobViewer_Info__c>();
            PTRF_JobViewer_Info__c objPTRFJVC = new PTRF_JobViewer_Info__c(Name='SAC',PTRF__c=objPTRF.Id,Jobview__c='Customer',Jobview_Type__c='Frame Mockup;Prime GDSOUT Review;MEBES Jobview',User__c=userSA.Id);
            PTRF_JobViewer_Info__c objPTRFJVF = new PTRF_JobViewer_Info__c(Name='SAF',PTRF__c=objPTRF.Id,Jobview__c='Foundry',Jobview_Type__c='Frame Mockup;Prime GDSOUT Review;MEBES Jobview',User__c=userSA.Id);
            //PTRF_JobViewer_Info__c objPTRFJVCust = new PTRF_JobViewer_Info__c(Name='SACust',PTRF__c=objPTRF.Id,Jobview__c='Customer',Jobview_Type__c='Frame Mockup;Prime GDSOUT Review;MEBES Jobview',User__c=listCon.get(0).Id);
            listPTRFJVI.add(objPTRFJVC);
            listPTRFJVI.add(objPTRFJVF);
            //listPTRFJVI.add(objPTRFJVCust);
            insert listPTRFJVI;
            //MRS__c objMRS = new MRS__c(Mask_Set_Title__c=objMST.Id);
            //insert objMRS;
            MRS__c objMRS = [SELECT Id, Mask_Set_Title__c FROM MRS__c LIMIT 1];
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
            MRS_Chip_Details__c objMRSCD4 = new MRS_Chip_Details__c(MRS__c=objMRS.Id,Name='Chip004');
            MRS_Chip_Details__c objMRSCD5 = new MRS_Chip_Details__c(MRS__c=objMRS.Id,Name='Chip005');
            listMRSCD.add(objMRSCD1);
            listMRSCD.add(objMRSCD2);
            listMRSCD.add(objMRSCD3);
            listMRSCD.add(objMRSCD4);
            listMRSCD.add(objMRSCD5);
            insert listMRSCD;
            List<MRS_Layer_Chip_Association__c> listMRSLCA = new List<MRS_Layer_Chip_Association__c>();
            MRS_Layer_Chip_Association__c objMRSLCA1 = new MRS_Layer_Chip_Association__c(Layer__c=objMRSLA1.Id,Chip__c=objMRSCD1.Id,PTRF__c=objPTRF.Id,Tech_Geo__c='0.019UM',Customer_Name__c=acc.Id,Device_Id__c='Device1',Mask_Set_Title_Id__c=String.valueOf(objMST.Id).substring(0,15));
            MRS_Layer_Chip_Association__c objMRSLCA2 = new MRS_Layer_Chip_Association__c(Layer__c=objMRSLA1.Id,Chip__c=objMRSCD2.Id,PTRF__c=objPTRF.Id,Tech_Geo__c='0.019UM',Customer_Name__c=acc.Id,Device_Id__c='Device1',Mask_Set_Title_Id__c=String.valueOf(objMST.Id).substring(0,15));
            MRS_Layer_Chip_Association__c objMRSLCA3 = new MRS_Layer_Chip_Association__c(Layer__c=objMRSLA2.Id,Chip__c=objMRSCD1.Id,PTRF__c=objPTRF.Id,Tech_Geo__c='0.019UM',Customer_Name__c=acc.Id,Device_Id__c='Device1',Mask_Set_Title_Id__c=String.valueOf(objMST.Id).substring(0,15));
            MRS_Layer_Chip_Association__c objMRSLCA4 = new MRS_Layer_Chip_Association__c(Layer__c=objMRSLA2.Id,Chip__c=objMRSCD2.Id,PTRF__c=objPTRF.Id,Tech_Geo__c='0.019UM',Customer_Name__c=acc.Id,Device_Id__c='Device1',Mask_Set_Title_Id__c=String.valueOf(objMST.Id).substring(0,15));
            MRS_Layer_Chip_Association__c objMRSLCA5 = new MRS_Layer_Chip_Association__c(Layer__c=objMRSLA1.Id,Chip__c=objMRSCD3.Id,PTRF__c=objPTRF.Id,Tech_Geo__c='0.019UM',Customer_Name__c=acc.Id,Device_Id__c='Device1',Mask_Set_Title_Id__c=String.valueOf(objMST.Id).substring(0,15));
            MRS_Layer_Chip_Association__c objMRSLCA6 = new MRS_Layer_Chip_Association__c(Layer__c=objMRSLA2.Id,Chip__c=objMRSCD3.Id,PTRF__c=objPTRF.Id,Tech_Geo__c='0.019UM',Customer_Name__c=acc.Id,Device_Id__c='Device1',Mask_Set_Title_Id__c=String.valueOf(objMST.Id).substring(0,15));
            MRS_Layer_Chip_Association__c objMRSLCA7 = new MRS_Layer_Chip_Association__c(Layer__c=objMRSLA1.Id,Chip__c=objMRSCD4.Id,PTRF__c=objPTRF.Id,Tech_Geo__c='0.019UM',Customer_Name__c=acc.Id,Device_Id__c='Device1',Mask_Set_Title_Id__c=String.valueOf(objMST.Id).substring(0,15));
            MRS_Layer_Chip_Association__c objMRSLCA8 = new MRS_Layer_Chip_Association__c(Layer__c=objMRSLA2.Id,Chip__c=objMRSCD5.Id,PTRF__c=objPTRF.Id,Tech_Geo__c='0.019UM',Customer_Name__c=acc.Id,Device_Id__c='Device1',Mask_Set_Title_Id__c=String.valueOf(objMST.Id).substring(0,15));
            objMRSLCA1 = createLayerChipData(objMRSLCA1);
            objMRSLCA2 = createLayerChipData(objMRSLCA2);
            objMRSLCA3 = createLayerChipData(objMRSLCA3);
            objMRSLCA4 = createLayerChipData(objMRSLCA4);
            objMRSLCA5 = createLayerChipData(objMRSLCA5);
            objMRSLCA6 = createLayerChipData(objMRSLCA6);
            objMRSLCA7 = createLayerChipData(objMRSLCA7);
            objMRSLCA8 = createLayerChipData(objMRSLCA8);
            listMRSLCA.add(objMRSLCA1);
            listMRSLCA.add(objMRSLCA2);
            listMRSLCA.add(objMRSLCA3);
            listMRSLCA.add(objMRSLCA4);
            listMRSLCA.add(objMRSLCA5);
            listMRSLCA.add(objMRSLCA6);
            listMRSLCA.add(objMRSLCA7);
            listMRSLCA.add(objMRSLCA8);
            insert listMRSLCA;
            System.runAs(userSA){
                Test.startTest();
                DRT__c objDRT = new DRT__c(Name='Test DRT');
                insert objDRT;
                ApexPages.currentPage().getHeaders().put('Host','MRS Page');
                ApexPages.currentPage().getParameters().put('jobview','Customer');                 
                //Test.startTest();
                MRSMEBESJobviewExtn controller = new MRSMEBESJobviewExtn (new ApexPages.StandardController(objDRT));
                //system.assertEquals(controller.jobviewName, 'Customer');
                controller.selectedCustomer = acc.Id;
                controller.populateMSTList();
                //system.assertEquals(controller.customerNameAfterSave.toUpperCase(),'TEST REC (TESTREC)');                
                controller.populateMSTList();
                controller.selectedMST = objMST.Id;
                //controller.populateMEBESTable();
                //system.assertEquals(controller.mstAfterSave, null);
                //controller.jobviewName = 'Foundry';
                
                /*controller.populateMEBESTable();
                controller.getMaskLayerList0();
                controller.getMaskLayerList1();
                controller.getMaskLayerList2();
                controller.getMaskLayerList3();
                controller.getMaskLayerList4();
                controller.getMaskLayerList5();
                controller.getMaskLayerList6();
                controller.getMaskLayerList7();
                controller.getMaskLayerList8();
                controller.getMaskLayerList9();
                //system.assertEquals(controller.isUserGS, true);
                controller.jobviewName = 'Tapeout Centre';
                //Test.startTest();
                controller.populateMEBESTable();*/
                controller.jobviewName = 'Tapeout Application';
                controller.populateMEBESTable();
                /*//system.assertEqualscontroller.isTechGeoActive, true);                
                controller.jobviewName = 'Global Shuttle';
                controller.populateMEBESTable();
                controller.jobviewName = 'MDP';
                controller.populateMEBESTable();
                controller.jobviewName = 'TDTI-MPW';
                controller.populateMEBESTable();*/
                /*----------------Wrapper Chip----------*/
               MRSMEBESJobviewExtn.WrapperChip wrpChip = new MRSMEBESJobviewExtn.WrapperChip('Chip001'); 
               List<MRSMEBESJobviewExtn.WrapperChip> lstMainTableData = new List<MRSMEBESJobviewExtn.WrapperChip>();
               lstMainTableData.add(wrpChip);
               String MainTable=JSON.serialize(lstMainTableData);
               controller.mainTableJSON=MainTable;
             /*-------------------WrapperLayerPtrf -------------------*/
               MRSMEBESJobviewExtn.WrapperLayerPtrf wrpLayerPtrf = new MRSMEBESJobviewExtn.WrapperLayerPtrf('1','RXAZ(123)',objPTRF.Name,String.Valueof(objPTRF.Id),'0.019UM'); 
              List<MRSMEBESJobviewExtn.WrapperLayerPtrf> lstsideHeader= new List<MRSMEBESJobviewExtn.WrapperLayerPtrf>();
              lstsideHeader.add(wrpLayerPtrf);       
              String sideHeader=JSON.serialize(lstsideHeader);
              controller.sideHeaderJSON=sideHeader;
              /*--------------WrapperStatusCheck----------------*/
               MRSMEBESJobviewExtn.WrapperStatusCheck wrpStsCheck = new MRSMEBESJobviewExtn.WrapperStatusCheck('CHECKED','READY'); 
              List<MRSMEBESJobviewExtn.WrapperStatusCheck> lstgridTbl= new List<MRSMEBESJobviewExtn.WrapperStatusCheck>();
              lstgridTbl.add(wrpStsCheck );
              String gridTbl=JSON.serialize(lstgridTbl);
              controller.gridTblJSON=gridTbl;
              controller.approvalData();
              controller.jobviewName = 'Foundry';
              controller.approvalData();
              //system.assertEquals(controller.isReleaseComments, true);              
              controller.saveData();
              //system.assertEquals(controller.errorMessage, true);             
              controller.releaseReasonTxt = 'Release Reason';
              controller.isReleaseComments = true;
              controller.saveData(); 
              controller.releaseReasonTxt = 'Release Reason';             
              controller.isReleaseComments = true;
              controller.jobviewName = 'Customer';
              controller.saveData();
              controller.releaseReasonTxt = 'Release Reason';
              controller.isReleaseComments = true;
              controller.jobviewName = 'Tapeout Centre';
              controller.saveData();
              controller.releaseReasonTxt = 'Release Reason';
              controller.isReleaseComments = true;
              controller.jobviewName = 'Tapeout Application';
              controller.saveData();
              /*controller.jobviewName = 'Global Shuttle';
              controller.saveData();
              controller.jobviewName = 'MDP';
              controller.saveData();
              controller.jobviewName = 'TDTI-MPW';
              controller.saveData();*/
              Test.stopTest();
            }
        }   
    }
    
    /**
        This test method tests the main big methods of MRSMEBESJobviewExtn class.
        @method name: TestMainMethods
        @parameter:   none.
        @return :     None.
     **/
     
    public static testMethod void TestMainMethodsGS (){
        // comment-out, refactor with testSetup method setup()
          // SwiftDataUtilityTest.customSystemData();
        //Account acc = SwiftDataUtilityTest.createTestAccountForDRT();
        Account acc = getAccount('Test Account 009');
        acc.stage__c = 'Qualified';
        update acc;
        User sysAdminUser = [SELECT Id,Name FROM User WHERE Profile.Name = 'System Administrator' AND isActive = true].get(0);
        /*Profile sysAdminProfile = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
        User userSA = new User(alias = 'testMRS', email='testMRS@test.com',
        emailencodingkey='UTF-8', lastname='testMRSLast', firstname='testMRSFirst', languagelocalekey='en_US',
        localesidkey='en_US', profileid = sysAdminProfile.Id,
        timezonesidkey='America/Los_Angeles', username='testMRS@test.com',communitynickname='testMRS');
        insert userSA; 
        */
        User userSA = [SELECT Id FROM User WHERE Email = 'testMRS@test.com'];
        
        Account_Team_Proxy__c atp = new Account_Team_Proxy__c(User__c = userSA.id,Account__c=acc.id,Account_Access__c='Read/Write',
        Opportunity_Access__c='Read/Write',Team_Role__c='Field Application Engineer',Sequence_No__c='1',Account_Role_ID__c='test1239');       
        insert atp;                
        System.runAs(sysAdminUser){
            Group groupGS = [select Id, DeveloperName, Name from Group where DeveloperName = 'Swift_GlobalShuttle'];
            Group groupSA = [select Id, DeveloperName, Name from Group where DeveloperName = 'SWIFT_Admin'];
            Group groupFJ = [select Id, DeveloperName, Name from Group where DeveloperName = 'Swift_Foundry_Jobviewer'];
            List<GroupMember> listGM = new List<GroupMember>(); 
            GroupMember groupMemberSA = new GroupMember(GroupId = groupSA.Id,UserOrGroupId = userSA.Id);
            GroupMember groupMemberGS = new GroupMember(GroupId = groupGS.Id,UserOrGroupId = userSA.Id);   
            GroupMember groupMemberFJ = new GroupMember(GroupId = groupFJ.Id,UserOrGroupId = userSA.Id);       
            listGM.add(groupMemberSA);
            listGM.add(groupMemberGS);
            listGM.add(groupMemberFJ);
            insert listGM;
            //Mask_Set_Title__c objMST = SwiftDataUtilityTest.createMST('MPW001');
            //insert objMST;
            Mask_Set_Title__c objMST = [SELECT Id, Name FROM Mask_Set_Title__c LIMIT 1];
            PTRF__c objPTRF = new PTRF__c(Name ='PTRF1',Order_Type__c ='Test Order Type',Recticle_Type__c ='Multi Node Reticle (MNR)',MaskSetTitle__c=objMST.Id,Customer__c=acc.id, Prime_Tapeout__c = true ,Prime_GDSOUT_Review__c=true,Status__c='Perform Tapeout Options',Device_Id__c='Dev1234');
            insert objPTRF;
            List<PTRF_JobViewer_Info__c> listPTRFJVI = new List<PTRF_JobViewer_Info__c>();
            PTRF_JobViewer_Info__c objPTRFJVC = new PTRF_JobViewer_Info__c(Name='SAC',PTRF__c=objPTRF.Id,Jobview__c='Customer',Jobview_Type__c='Frame Mockup;Prime GDSOUT Review;MEBES Jobview',User__c=userSA.Id);
            PTRF_JobViewer_Info__c objPTRFJVF = new PTRF_JobViewer_Info__c(Name='SAF',PTRF__c=objPTRF.Id,Jobview__c='Foundry',Jobview_Type__c='Frame Mockup;Prime GDSOUT Review;MEBES Jobview',User__c=userSA.Id);
            //PTRF_JobViewer_Info__c objPTRFJVCust = new PTRF_JobViewer_Info__c(Name='SACust',PTRF__c=objPTRF.Id,Jobview__c='Customer',Jobview_Type__c='Frame Mockup;Prime GDSOUT Review;MEBES Jobview',User__c=listCon.get(0).Id);
            listPTRFJVI.add(objPTRFJVC);
            listPTRFJVI.add(objPTRFJVF);
            //listPTRFJVI.add(objPTRFJVCust);
            insert listPTRFJVI;
            //MRS__c objMRS = new MRS__c(Mask_Set_Title__c=objMST.Id);
            //insert objMRS;
            MRS__c objMRS = [SELECT Id, Mask_Set_Title__c FROM MRS__c LIMIT 1];
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
            MRS_Chip_Details__c objMRSCD4 = new MRS_Chip_Details__c(MRS__c=objMRS.Id,Name='Chip004');
            MRS_Chip_Details__c objMRSCD5 = new MRS_Chip_Details__c(MRS__c=objMRS.Id,Name='Chip005');
            listMRSCD.add(objMRSCD1);
            listMRSCD.add(objMRSCD2);
            listMRSCD.add(objMRSCD3);
            listMRSCD.add(objMRSCD4);
            listMRSCD.add(objMRSCD5);
            insert listMRSCD;
            List<MRS_Layer_Chip_Association__c> listMRSLCA = new List<MRS_Layer_Chip_Association__c>();
            MRS_Layer_Chip_Association__c objMRSLCA1 = new MRS_Layer_Chip_Association__c(Layer__c=objMRSLA1.Id,Chip__c=objMRSCD1.Id,PTRF__c=objPTRF.Id,Tech_Geo__c='0.019UM',Customer_Name__c=acc.Id,Device_Id__c='Device1',Mask_Set_Title_Id__c=String.valueOf(objMST.Id).substring(0,15));
            MRS_Layer_Chip_Association__c objMRSLCA2 = new MRS_Layer_Chip_Association__c(Layer__c=objMRSLA1.Id,Chip__c=objMRSCD2.Id,PTRF__c=objPTRF.Id,Tech_Geo__c='0.019UM',Customer_Name__c=acc.Id,Device_Id__c='Device1',Mask_Set_Title_Id__c=String.valueOf(objMST.Id).substring(0,15));
            MRS_Layer_Chip_Association__c objMRSLCA3 = new MRS_Layer_Chip_Association__c(Layer__c=objMRSLA2.Id,Chip__c=objMRSCD1.Id,PTRF__c=objPTRF.Id,Tech_Geo__c='0.019UM',Customer_Name__c=acc.Id,Device_Id__c='Device1',Mask_Set_Title_Id__c=String.valueOf(objMST.Id).substring(0,15));
            MRS_Layer_Chip_Association__c objMRSLCA4 = new MRS_Layer_Chip_Association__c(Layer__c=objMRSLA2.Id,Chip__c=objMRSCD2.Id,PTRF__c=objPTRF.Id,Tech_Geo__c='0.019UM',Customer_Name__c=acc.Id,Device_Id__c='Device1',Mask_Set_Title_Id__c=String.valueOf(objMST.Id).substring(0,15));
            MRS_Layer_Chip_Association__c objMRSLCA5 = new MRS_Layer_Chip_Association__c(Layer__c=objMRSLA1.Id,Chip__c=objMRSCD3.Id,PTRF__c=objPTRF.Id,Tech_Geo__c='0.019UM',Customer_Name__c=acc.Id,Device_Id__c='Device1',Mask_Set_Title_Id__c=String.valueOf(objMST.Id).substring(0,15));
            MRS_Layer_Chip_Association__c objMRSLCA6 = new MRS_Layer_Chip_Association__c(Layer__c=objMRSLA2.Id,Chip__c=objMRSCD3.Id,PTRF__c=objPTRF.Id,Tech_Geo__c='0.019UM',Customer_Name__c=acc.Id,Device_Id__c='Device1',Mask_Set_Title_Id__c=String.valueOf(objMST.Id).substring(0,15));
            MRS_Layer_Chip_Association__c objMRSLCA7 = new MRS_Layer_Chip_Association__c(Layer__c=objMRSLA1.Id,Chip__c=objMRSCD4.Id,PTRF__c=objPTRF.Id,Tech_Geo__c='0.019UM',Customer_Name__c=acc.Id,Device_Id__c='Device1',Mask_Set_Title_Id__c=String.valueOf(objMST.Id).substring(0,15));
            MRS_Layer_Chip_Association__c objMRSLCA8 = new MRS_Layer_Chip_Association__c(Layer__c=objMRSLA2.Id,Chip__c=objMRSCD5.Id,PTRF__c=objPTRF.Id,Tech_Geo__c='0.019UM',Customer_Name__c=acc.Id,Device_Id__c='Device1',Mask_Set_Title_Id__c=String.valueOf(objMST.Id).substring(0,15));
            objMRSLCA1 = createLayerChipData(objMRSLCA1);
            objMRSLCA2 = createLayerChipData(objMRSLCA2);
            objMRSLCA3 = createLayerChipData(objMRSLCA3);
            objMRSLCA4 = createLayerChipData(objMRSLCA4);
            objMRSLCA5 = createLayerChipData(objMRSLCA5);
            objMRSLCA6 = createLayerChipData(objMRSLCA6);
            objMRSLCA7 = createLayerChipData(objMRSLCA7);
            objMRSLCA8 = createLayerChipData(objMRSLCA8);
            listMRSLCA.add(objMRSLCA1);
            listMRSLCA.add(objMRSLCA2);
            listMRSLCA.add(objMRSLCA3);
            listMRSLCA.add(objMRSLCA4);
            listMRSLCA.add(objMRSLCA5);
            listMRSLCA.add(objMRSLCA6);
            listMRSLCA.add(objMRSLCA7);
            listMRSLCA.add(objMRSLCA8);
            insert listMRSLCA;
            Test.startTest();
            System.runAs(userSA){
                DRT__c objDRT = new DRT__c(Name='Test DRT');
                insert objDRT;
                ApexPages.currentPage().getHeaders().put('Host','MRS Page');
                ApexPages.currentPage().getParameters().put('jobview','Customer');                 
                //Test.startTest();
                MRSMEBESJobviewExtn controller = new MRSMEBESJobviewExtn (new ApexPages.StandardController(objDRT));
                //system.assertEquals(controller.jobviewName, 'Customer');
                controller.selectedCustomer = acc.Id;
                controller.populateMSTList();
                //system.assertEquals(controller.customerNameAfterSave.toUpperCase(),'TEST REC (TESTREC)');                
                controller.populateMSTList();
                controller.selectedMST = objMST.Id;
                //controller.populateMEBESTable();
                //system.assertEquals(controller.mstAfterSave, null);
                //controller.jobviewName = 'Foundry';
                
                controller.jobviewName = 'Global Shuttle';
                controller.populateMEBESTable();
                
                /*----------------Wrapper Chip----------*/
               MRSMEBESJobviewExtn.WrapperChip wrpChip = new MRSMEBESJobviewExtn.WrapperChip('Chip001'); 
               List<MRSMEBESJobviewExtn.WrapperChip> lstMainTableData = new List<MRSMEBESJobviewExtn.WrapperChip>();
               lstMainTableData.add(wrpChip);
               String MainTable=JSON.serialize(lstMainTableData);
               controller.mainTableJSON=MainTable;
             /*-------------------WrapperLayerPtrf -------------------*/
               MRSMEBESJobviewExtn.WrapperLayerPtrf wrpLayerPtrf = new MRSMEBESJobviewExtn.WrapperLayerPtrf('1','RXAZ(123)',objPTRF.Name,String.Valueof(objPTRF.Id),'0.019UM'); 
              List<MRSMEBESJobviewExtn.WrapperLayerPtrf> lstsideHeader= new List<MRSMEBESJobviewExtn.WrapperLayerPtrf>();
              lstsideHeader.add(wrpLayerPtrf);       
              String sideHeader=JSON.serialize(lstsideHeader);
              controller.sideHeaderJSON=sideHeader;
              /*--------------WrapperStatusCheck----------------*/
               MRSMEBESJobviewExtn.WrapperStatusCheck wrpStsCheck = new MRSMEBESJobviewExtn.WrapperStatusCheck('CHECKED','READY'); 
              List<MRSMEBESJobviewExtn.WrapperStatusCheck> lstgridTbl= new List<MRSMEBESJobviewExtn.WrapperStatusCheck>();
              lstgridTbl.add(wrpStsCheck );
              String gridTbl=JSON.serialize(lstgridTbl);
              controller.gridTblJSON=gridTbl;
              controller.approvalData();
              controller.jobviewName = 'Foundry';
              controller.approvalData();
              //system.assertEquals(controller.isReleaseComments, true);              
              controller.saveData();
              //system.assertEquals(controller.errorMessage, true);             
              controller.releaseReasonTxt = 'Release Reason';
              controller.isReleaseComments = true;
              controller.saveData(); 
              controller.releaseReasonTxt = 'Release Reason';             
              controller.isReleaseComments = true;
              controller.jobviewName = 'Customer';
              controller.saveData();
              controller.releaseReasonTxt = 'Release Reason';
              controller.isReleaseComments = true;
              controller.jobviewName = 'Tapeout Centre';
              controller.saveData();
              controller.releaseReasonTxt = 'Release Reason';
              controller.isReleaseComments = true;
              controller.jobviewName = 'Tapeout Application';
              controller.saveData();
              
            }
            Test.stopTest();
        }   
    }
    
    /**
        This test method tests the main big methods of MRSMEBESJobviewExtn class.
        @method name: TestMainMethods
        @parameter:   none.
        @return :     None.
     **/
     
    public static testMethod void TestMainMethodsMDP (){
        // comment-out, refactor with testSetup method setup()
          // SwiftDataUtilityTest.customSystemData();
        //Account acc = SwiftDataUtilityTest.createTestAccountForDRT();
        Account acc = getAccount('Test Account 009');
        acc.stage__c = 'Qualified';
        update acc;
        User sysAdminUser = [SELECT Id,Name FROM User WHERE Profile.Name = 'System Administrator' AND isActive = true].get(0);
        /*Profile sysAdminProfile = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
        User userSA = new User(alias = 'testMRS', email='testMRS@test.com',
        emailencodingkey='UTF-8', lastname='testMRSLast', firstname='testMRSFirst', languagelocalekey='en_US',
        localesidkey='en_US', profileid = sysAdminProfile.Id,
        timezonesidkey='America/Los_Angeles', username='testMRS@test.com',communitynickname='testMRS');
        insert userSA; 
        */
        User userSA = [SELECT Id FROM User WHERE Email = 'testMRS@test.com'];
        
        Account_Team_Proxy__c atp = new Account_Team_Proxy__c(User__c = userSA.id,Account__c=acc.id,Account_Access__c='Read/Write',
        Opportunity_Access__c='Read/Write',Team_Role__c='Field Application Engineer',Sequence_No__c='1',Account_Role_ID__c='test1239');       
        insert atp;                
        System.runAs(sysAdminUser){
            Group groupGS = [select Id, DeveloperName, Name from Group where DeveloperName = 'Swift_GlobalShuttle'];
            Group groupSA = [select Id, DeveloperName, Name from Group where DeveloperName = 'SWIFT_Admin'];
            Group groupFJ = [select Id, DeveloperName, Name from Group where DeveloperName = 'Swift_Foundry_Jobviewer'];
            List<GroupMember> listGM = new List<GroupMember>(); 
            GroupMember groupMemberSA = new GroupMember(GroupId = groupSA.Id,UserOrGroupId = userSA.Id);
            GroupMember groupMemberGS = new GroupMember(GroupId = groupGS.Id,UserOrGroupId = userSA.Id);   
            GroupMember groupMemberFJ = new GroupMember(GroupId = groupFJ.Id,UserOrGroupId = userSA.Id);       
            listGM.add(groupMemberSA);
            listGM.add(groupMemberGS);
            listGM.add(groupMemberFJ);
            insert listGM;
            //Mask_Set_Title__c objMST = SwiftDataUtilityTest.createMST('MPW001');
            //insert objMST;
            Mask_Set_Title__c objMST = [SELECT Id, Name FROM Mask_Set_Title__c LIMIT 1];
            PTRF__c objPTRF = new PTRF__c(Name ='PTRF1',Order_Type__c ='Test Order Type',Recticle_Type__c ='Multi Node Reticle (MNR)',MaskSetTitle__c=objMST.Id,Customer__c=acc.id, Prime_Tapeout__c = true ,Prime_GDSOUT_Review__c=true,Status__c='Perform Tapeout Options',Device_Id__c='Dev1234');
            insert objPTRF;
            List<PTRF_JobViewer_Info__c> listPTRFJVI = new List<PTRF_JobViewer_Info__c>();
            PTRF_JobViewer_Info__c objPTRFJVC = new PTRF_JobViewer_Info__c(Name='SAC',PTRF__c=objPTRF.Id,Jobview__c='Customer',Jobview_Type__c='Frame Mockup;Prime GDSOUT Review;MEBES Jobview',User__c=userSA.Id);
            PTRF_JobViewer_Info__c objPTRFJVF = new PTRF_JobViewer_Info__c(Name='SAF',PTRF__c=objPTRF.Id,Jobview__c='Foundry',Jobview_Type__c='Frame Mockup;Prime GDSOUT Review;MEBES Jobview',User__c=userSA.Id);
            //PTRF_JobViewer_Info__c objPTRFJVCust = new PTRF_JobViewer_Info__c(Name='SACust',PTRF__c=objPTRF.Id,Jobview__c='Customer',Jobview_Type__c='Frame Mockup;Prime GDSOUT Review;MEBES Jobview',User__c=listCon.get(0).Id);
            listPTRFJVI.add(objPTRFJVC);
            listPTRFJVI.add(objPTRFJVF);
            //listPTRFJVI.add(objPTRFJVCust);
            insert listPTRFJVI;
            //MRS__c objMRS = new MRS__c(Mask_Set_Title__c=objMST.Id);
            //insert objMRS;
            MRS__c objMRS = [SELECT Id, Mask_Set_Title__c FROM MRS__c LIMIT 1];
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
            MRS_Chip_Details__c objMRSCD4 = new MRS_Chip_Details__c(MRS__c=objMRS.Id,Name='Chip004');
            MRS_Chip_Details__c objMRSCD5 = new MRS_Chip_Details__c(MRS__c=objMRS.Id,Name='Chip005');
            listMRSCD.add(objMRSCD1);
            listMRSCD.add(objMRSCD2);
            listMRSCD.add(objMRSCD3);
            listMRSCD.add(objMRSCD4);
            listMRSCD.add(objMRSCD5);
            insert listMRSCD;
            List<MRS_Layer_Chip_Association__c> listMRSLCA = new List<MRS_Layer_Chip_Association__c>();
            MRS_Layer_Chip_Association__c objMRSLCA1 = new MRS_Layer_Chip_Association__c(Layer__c=objMRSLA1.Id,Chip__c=objMRSCD1.Id,PTRF__c=objPTRF.Id,Tech_Geo__c='0.019UM',Customer_Name__c=acc.Id,Device_Id__c='Device1',Mask_Set_Title_Id__c=String.valueOf(objMST.Id).substring(0,15));
            MRS_Layer_Chip_Association__c objMRSLCA2 = new MRS_Layer_Chip_Association__c(Layer__c=objMRSLA1.Id,Chip__c=objMRSCD2.Id,PTRF__c=objPTRF.Id,Tech_Geo__c='0.019UM',Customer_Name__c=acc.Id,Device_Id__c='Device1',Mask_Set_Title_Id__c=String.valueOf(objMST.Id).substring(0,15));
            MRS_Layer_Chip_Association__c objMRSLCA3 = new MRS_Layer_Chip_Association__c(Layer__c=objMRSLA2.Id,Chip__c=objMRSCD1.Id,PTRF__c=objPTRF.Id,Tech_Geo__c='0.019UM',Customer_Name__c=acc.Id,Device_Id__c='Device1',Mask_Set_Title_Id__c=String.valueOf(objMST.Id).substring(0,15));
            MRS_Layer_Chip_Association__c objMRSLCA4 = new MRS_Layer_Chip_Association__c(Layer__c=objMRSLA2.Id,Chip__c=objMRSCD2.Id,PTRF__c=objPTRF.Id,Tech_Geo__c='0.019UM',Customer_Name__c=acc.Id,Device_Id__c='Device1',Mask_Set_Title_Id__c=String.valueOf(objMST.Id).substring(0,15));
            MRS_Layer_Chip_Association__c objMRSLCA5 = new MRS_Layer_Chip_Association__c(Layer__c=objMRSLA1.Id,Chip__c=objMRSCD3.Id,PTRF__c=objPTRF.Id,Tech_Geo__c='0.019UM',Customer_Name__c=acc.Id,Device_Id__c='Device1',Mask_Set_Title_Id__c=String.valueOf(objMST.Id).substring(0,15));
            MRS_Layer_Chip_Association__c objMRSLCA6 = new MRS_Layer_Chip_Association__c(Layer__c=objMRSLA2.Id,Chip__c=objMRSCD3.Id,PTRF__c=objPTRF.Id,Tech_Geo__c='0.019UM',Customer_Name__c=acc.Id,Device_Id__c='Device1',Mask_Set_Title_Id__c=String.valueOf(objMST.Id).substring(0,15));
            MRS_Layer_Chip_Association__c objMRSLCA7 = new MRS_Layer_Chip_Association__c(Layer__c=objMRSLA1.Id,Chip__c=objMRSCD4.Id,PTRF__c=objPTRF.Id,Tech_Geo__c='0.019UM',Customer_Name__c=acc.Id,Device_Id__c='Device1',Mask_Set_Title_Id__c=String.valueOf(objMST.Id).substring(0,15));
            MRS_Layer_Chip_Association__c objMRSLCA8 = new MRS_Layer_Chip_Association__c(Layer__c=objMRSLA2.Id,Chip__c=objMRSCD5.Id,PTRF__c=objPTRF.Id,Tech_Geo__c='0.019UM',Customer_Name__c=acc.Id,Device_Id__c='Device1',Mask_Set_Title_Id__c=String.valueOf(objMST.Id).substring(0,15));
            objMRSLCA1 = createLayerChipData(objMRSLCA1);
            objMRSLCA2 = createLayerChipData(objMRSLCA2);
            objMRSLCA3 = createLayerChipData(objMRSLCA3);
            objMRSLCA4 = createLayerChipData(objMRSLCA4);
            objMRSLCA5 = createLayerChipData(objMRSLCA5);
            objMRSLCA6 = createLayerChipData(objMRSLCA6);
            objMRSLCA7 = createLayerChipData(objMRSLCA7);
            objMRSLCA8 = createLayerChipData(objMRSLCA8);
            listMRSLCA.add(objMRSLCA1);
            listMRSLCA.add(objMRSLCA2);
            listMRSLCA.add(objMRSLCA3);
            listMRSLCA.add(objMRSLCA4);
            listMRSLCA.add(objMRSLCA5);
            listMRSLCA.add(objMRSLCA6);
            listMRSLCA.add(objMRSLCA7);
            listMRSLCA.add(objMRSLCA8);
            insert listMRSLCA;
            Test.startTest();
            System.runAs(userSA){
                DRT__c objDRT = new DRT__c(Name='Test DRT');
                insert objDRT;
                ApexPages.currentPage().getHeaders().put('Host','MRS Page');
                ApexPages.currentPage().getParameters().put('jobview','Customer');                 
                //Test.startTest();
                MRSMEBESJobviewExtn controller = new MRSMEBESJobviewExtn (new ApexPages.StandardController(objDRT));
               //system.assertEquals(controller.jobviewName, 'Customer');
                controller.selectedCustomer = acc.Id;
                controller.populateMSTList();
                //system.assertEquals(controller.customerNameAfterSave.toUpperCase(),'TEST REC (TESTREC)');                
                controller.populateMSTList();
                controller.selectedMST = objMST.Id;
                //controller.populateMEBESTable();
                //system.assertEquals(controller.mstAfterSave, null);
                //controller.jobviewName = 'Foundry';
                
                controller.jobviewName = 'MDP';
                controller.populateMEBESTable();
                /*controller.jobviewName = 'TDTI-MPW';
                controller.populateMEBESTable();*/
                /*----------------Wrapper Chip----------*/
               MRSMEBESJobviewExtn.WrapperChip wrpChip = new MRSMEBESJobviewExtn.WrapperChip('Chip001'); 
               List<MRSMEBESJobviewExtn.WrapperChip> lstMainTableData = new List<MRSMEBESJobviewExtn.WrapperChip>();
               lstMainTableData.add(wrpChip);
               String MainTable=JSON.serialize(lstMainTableData);
               controller.mainTableJSON=MainTable;
             /*-------------------WrapperLayerPtrf -------------------*/
               MRSMEBESJobviewExtn.WrapperLayerPtrf wrpLayerPtrf = new MRSMEBESJobviewExtn.WrapperLayerPtrf('1','RXAZ(123)',objPTRF.Name,String.Valueof(objPTRF.Id),'0.019UM'); 
              List<MRSMEBESJobviewExtn.WrapperLayerPtrf> lstsideHeader= new List<MRSMEBESJobviewExtn.WrapperLayerPtrf>();
              lstsideHeader.add(wrpLayerPtrf);       
              String sideHeader=JSON.serialize(lstsideHeader);
              controller.sideHeaderJSON=sideHeader;
              /*--------------WrapperStatusCheck----------------*/
               MRSMEBESJobviewExtn.WrapperStatusCheck wrpStsCheck = new MRSMEBESJobviewExtn.WrapperStatusCheck('CHECKED','READY'); 
              List<MRSMEBESJobviewExtn.WrapperStatusCheck> lstgridTbl= new List<MRSMEBESJobviewExtn.WrapperStatusCheck>();
              lstgridTbl.add(wrpStsCheck );
              String gridTbl=JSON.serialize(lstgridTbl);
              controller.gridTblJSON=gridTbl;
              controller.approvalData();
              controller.jobviewName = 'Foundry';
              controller.approvalData();
              //system.assertEquals(controller.isReleaseComments, true);              
              controller.saveData();
              //system.assertEquals(controller.errorMessage, true);             
              controller.releaseReasonTxt = 'Release Reason';
              controller.isReleaseComments = true;
              controller.saveData(); 
              controller.releaseReasonTxt = 'Release Reason';             
              controller.isReleaseComments = true;
              controller.jobviewName = 'Customer';
              controller.saveData();
              controller.releaseReasonTxt = 'Release Reason';
              controller.isReleaseComments = true;
              controller.jobviewName = 'Tapeout Centre';
              controller.saveData();
              controller.releaseReasonTxt = 'Release Reason';
              controller.isReleaseComments = true;
              controller.jobviewName = 'Tapeout Application';
              controller.saveData();
              
            }
            Test.stopTest();
        }   
    }
    
    /**
        This test method tests the main big methods of MRSMEBESJobviewExtn class.
        @method name: TestMainMethods
        @parameter:   none.
        @return :     None.
     **/
     
    public static testMethod void TestMainMethodsTDTIMPW (){
        // comment-out, refactor with testSetup method setup()
          // SwiftDataUtilityTest.customSystemData();
        //Account acc = SwiftDataUtilityTest.createTestAccountForDRT();
        Account acc = getAccount('Test Account 009');
        acc.stage__c = 'Qualified';
        update acc;
        User sysAdminUser = [SELECT Id,Name FROM User WHERE Profile.Name = 'System Administrator' AND isActive = true].get(0);
        /*Profile sysAdminProfile = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
        User userSA = new User(alias = 'testMRS', email='testMRS@test.com',
        emailencodingkey='UTF-8', lastname='testMRSLast', firstname='testMRSFirst', languagelocalekey='en_US',
        localesidkey='en_US', profileid = sysAdminProfile.Id,
        timezonesidkey='America/Los_Angeles', username='testMRS@test.com',communitynickname='testMRS');
        insert userSA; 
        */
        User userSA = [SELECT Id FROM User WHERE Email = 'testMRS@test.com'];
        
        Account_Team_Proxy__c atp = new Account_Team_Proxy__c(User__c = userSA.id,Account__c=acc.id,Account_Access__c='Read/Write',
        Opportunity_Access__c='Read/Write',Team_Role__c='Field Application Engineer',Sequence_No__c='1',Account_Role_ID__c='test1239');       
        insert atp;                
        System.runAs(sysAdminUser){
            Group groupGS = [select Id, DeveloperName, Name from Group where DeveloperName = 'Swift_GlobalShuttle'];
            Group groupSA = [select Id, DeveloperName, Name from Group where DeveloperName = 'SWIFT_Admin'];
            Group groupFJ = [select Id, DeveloperName, Name from Group where DeveloperName = 'Swift_Foundry_Jobviewer'];
            List<GroupMember> listGM = new List<GroupMember>(); 
            GroupMember groupMemberSA = new GroupMember(GroupId = groupSA.Id,UserOrGroupId = userSA.Id);
            GroupMember groupMemberGS = new GroupMember(GroupId = groupGS.Id,UserOrGroupId = userSA.Id);   
            GroupMember groupMemberFJ = new GroupMember(GroupId = groupFJ.Id,UserOrGroupId = userSA.Id);       
            listGM.add(groupMemberSA);
            listGM.add(groupMemberGS);
            listGM.add(groupMemberFJ);
            insert listGM;
            //Mask_Set_Title__c objMST = SwiftDataUtilityTest.createMST('MPW001');
            //insert objMST;
            Mask_Set_Title__c objMST = [SELECT Id, Name FROM Mask_Set_Title__c LIMIT 1];
            PTRF__c objPTRF = new PTRF__c(Name ='PTRF1',Order_Type__c ='Test Order Type',Recticle_Type__c ='Multi Node Reticle (MNR)',MaskSetTitle__c=objMST.Id,Customer__c=acc.id, Prime_Tapeout__c = true ,Prime_GDSOUT_Review__c=true,Status__c='Perform Tapeout Options',Device_Id__c='Dev1234');
            insert objPTRF;
            List<PTRF_JobViewer_Info__c> listPTRFJVI = new List<PTRF_JobViewer_Info__c>();
            PTRF_JobViewer_Info__c objPTRFJVC = new PTRF_JobViewer_Info__c(Name='SAC',PTRF__c=objPTRF.Id,Jobview__c='Customer',Jobview_Type__c='Frame Mockup;Prime GDSOUT Review;MEBES Jobview',User__c=userSA.Id);
            PTRF_JobViewer_Info__c objPTRFJVF = new PTRF_JobViewer_Info__c(Name='SAF',PTRF__c=objPTRF.Id,Jobview__c='Foundry',Jobview_Type__c='Frame Mockup;Prime GDSOUT Review;MEBES Jobview',User__c=userSA.Id);
            //PTRF_JobViewer_Info__c objPTRFJVCust = new PTRF_JobViewer_Info__c(Name='SACust',PTRF__c=objPTRF.Id,Jobview__c='Customer',Jobview_Type__c='Frame Mockup;Prime GDSOUT Review;MEBES Jobview',User__c=listCon.get(0).Id);
            listPTRFJVI.add(objPTRFJVC);
            listPTRFJVI.add(objPTRFJVF);
            //listPTRFJVI.add(objPTRFJVCust);
            insert listPTRFJVI;
            //MRS__c objMRS = new MRS__c(Mask_Set_Title__c=objMST.Id);
            //insert objMRS;
            MRS__c objMRS = [SELECT Id, Mask_Set_Title__c FROM MRS__c LIMIT 1];
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
            MRS_Chip_Details__c objMRSCD4 = new MRS_Chip_Details__c(MRS__c=objMRS.Id,Name='Chip004');
            MRS_Chip_Details__c objMRSCD5 = new MRS_Chip_Details__c(MRS__c=objMRS.Id,Name='Chip005');
            listMRSCD.add(objMRSCD1);
            listMRSCD.add(objMRSCD2);
            listMRSCD.add(objMRSCD3);
            listMRSCD.add(objMRSCD4);
            listMRSCD.add(objMRSCD5);
            insert listMRSCD;
            List<MRS_Layer_Chip_Association__c> listMRSLCA = new List<MRS_Layer_Chip_Association__c>();
            MRS_Layer_Chip_Association__c objMRSLCA1 = new MRS_Layer_Chip_Association__c(Layer__c=objMRSLA1.Id,Chip__c=objMRSCD1.Id,PTRF__c=objPTRF.Id,Tech_Geo__c='0.019UM',Customer_Name__c=acc.Id,Device_Id__c='Device1',Mask_Set_Title_Id__c=String.valueOf(objMST.Id).substring(0,15));
            MRS_Layer_Chip_Association__c objMRSLCA2 = new MRS_Layer_Chip_Association__c(Layer__c=objMRSLA1.Id,Chip__c=objMRSCD2.Id,PTRF__c=objPTRF.Id,Tech_Geo__c='0.019UM',Customer_Name__c=acc.Id,Device_Id__c='Device1',Mask_Set_Title_Id__c=String.valueOf(objMST.Id).substring(0,15));
            MRS_Layer_Chip_Association__c objMRSLCA3 = new MRS_Layer_Chip_Association__c(Layer__c=objMRSLA2.Id,Chip__c=objMRSCD1.Id,PTRF__c=objPTRF.Id,Tech_Geo__c='0.019UM',Customer_Name__c=acc.Id,Device_Id__c='Device1',Mask_Set_Title_Id__c=String.valueOf(objMST.Id).substring(0,15));
            MRS_Layer_Chip_Association__c objMRSLCA4 = new MRS_Layer_Chip_Association__c(Layer__c=objMRSLA2.Id,Chip__c=objMRSCD2.Id,PTRF__c=objPTRF.Id,Tech_Geo__c='0.019UM',Customer_Name__c=acc.Id,Device_Id__c='Device1',Mask_Set_Title_Id__c=String.valueOf(objMST.Id).substring(0,15));
            MRS_Layer_Chip_Association__c objMRSLCA5 = new MRS_Layer_Chip_Association__c(Layer__c=objMRSLA1.Id,Chip__c=objMRSCD3.Id,PTRF__c=objPTRF.Id,Tech_Geo__c='0.019UM',Customer_Name__c=acc.Id,Device_Id__c='Device1',Mask_Set_Title_Id__c=String.valueOf(objMST.Id).substring(0,15));
            MRS_Layer_Chip_Association__c objMRSLCA6 = new MRS_Layer_Chip_Association__c(Layer__c=objMRSLA2.Id,Chip__c=objMRSCD3.Id,PTRF__c=objPTRF.Id,Tech_Geo__c='0.019UM',Customer_Name__c=acc.Id,Device_Id__c='Device1',Mask_Set_Title_Id__c=String.valueOf(objMST.Id).substring(0,15));
            MRS_Layer_Chip_Association__c objMRSLCA7 = new MRS_Layer_Chip_Association__c(Layer__c=objMRSLA1.Id,Chip__c=objMRSCD4.Id,PTRF__c=objPTRF.Id,Tech_Geo__c='0.019UM',Customer_Name__c=acc.Id,Device_Id__c='Device1',Mask_Set_Title_Id__c=String.valueOf(objMST.Id).substring(0,15));
            MRS_Layer_Chip_Association__c objMRSLCA8 = new MRS_Layer_Chip_Association__c(Layer__c=objMRSLA2.Id,Chip__c=objMRSCD5.Id,PTRF__c=objPTRF.Id,Tech_Geo__c='0.019UM',Customer_Name__c=acc.Id,Device_Id__c='Device1',Mask_Set_Title_Id__c=String.valueOf(objMST.Id).substring(0,15));
            objMRSLCA1 = createLayerChipData(objMRSLCA1);
            objMRSLCA2 = createLayerChipData(objMRSLCA2);
            objMRSLCA3 = createLayerChipData(objMRSLCA3);
            objMRSLCA4 = createLayerChipData(objMRSLCA4);
            objMRSLCA5 = createLayerChipData(objMRSLCA5);
            objMRSLCA6 = createLayerChipData(objMRSLCA6);
            objMRSLCA7 = createLayerChipData(objMRSLCA7);
            objMRSLCA8 = createLayerChipData(objMRSLCA8);
            listMRSLCA.add(objMRSLCA1);
            listMRSLCA.add(objMRSLCA2);
            listMRSLCA.add(objMRSLCA3);
            listMRSLCA.add(objMRSLCA4);
            listMRSLCA.add(objMRSLCA5);
            listMRSLCA.add(objMRSLCA6);
            listMRSLCA.add(objMRSLCA7);
            listMRSLCA.add(objMRSLCA8);
            insert listMRSLCA;
            
            Test.startTest();
            System.runAs(userSA){
                DRT__c objDRT = new DRT__c(Name='Test DRT');
                insert objDRT;
                ApexPages.currentPage().getHeaders().put('Host','MRS Page');
                ApexPages.currentPage().getParameters().put('jobview','Customer');                 
                //Test.startTest();
                MRSMEBESJobviewExtn controller = new MRSMEBESJobviewExtn (new ApexPages.StandardController(objDRT));
                //system.assertEquals(controller.jobviewName, 'Customer');
                controller.selectedCustomer = acc.Id;
                controller.populateMSTList();
                //system.assertEquals(controller.customerNameAfterSave.toUpperCase(),'TEST REC (TESTREC)');                
                controller.populateMSTList();
                controller.selectedMST = objMST.Id;
                //controller.populateMEBESTable();
                //system.assertEquals(controller.mstAfterSave, null);
                //controller.jobviewName = 'Foundry';
                
                /*controller.populateMEBESTable();
                controller.getMaskLayerList0();
                controller.getMaskLayerList1();
                controller.getMaskLayerList2();
                controller.getMaskLayerList3();
                controller.getMaskLayerList4();
                controller.getMaskLayerList5();
                controller.getMaskLayerList6();
                controller.getMaskLayerList7();
                controller.getMaskLayerList8();
                controller.getMaskLayerList9();
                //system.assertEquals(controller.isUserGS, true);
                controller.jobviewName = 'Tapeout Centre';
                //Test.startTest();
                controller.populateMEBESTable();
                controller.jobviewName = 'Tapeout Application';
                controller.populateMEBESTable();
                //system.assertEqualscontroller.isTechGeoActive, true);                
                controller.jobviewName = 'Global Shuttle';
                controller.populateMEBESTable();
                controller.jobviewName = 'MDP';
                controller.populateMEBESTable();*/
                controller.jobviewName = 'TDTI-MPW';
                controller.populateMEBESTable();
                /*----------------Wrapper Chip----------*/
               MRSMEBESJobviewExtn.WrapperChip wrpChip = new MRSMEBESJobviewExtn.WrapperChip('Chip001'); 
               List<MRSMEBESJobviewExtn.WrapperChip> lstMainTableData = new List<MRSMEBESJobviewExtn.WrapperChip>();
               lstMainTableData.add(wrpChip);
               String MainTable=JSON.serialize(lstMainTableData);
               controller.mainTableJSON=MainTable;
             /*-------------------WrapperLayerPtrf -------------------*/
               MRSMEBESJobviewExtn.WrapperLayerPtrf wrpLayerPtrf = new MRSMEBESJobviewExtn.WrapperLayerPtrf('1','RXAZ(123)',objPTRF.Name,String.Valueof(objPTRF.Id),'0.019UM'); 
              List<MRSMEBESJobviewExtn.WrapperLayerPtrf> lstsideHeader= new List<MRSMEBESJobviewExtn.WrapperLayerPtrf>();
              lstsideHeader.add(wrpLayerPtrf);       
              String sideHeader=JSON.serialize(lstsideHeader);
              controller.sideHeaderJSON=sideHeader;
              /*--------------WrapperStatusCheck----------------*/
               MRSMEBESJobviewExtn.WrapperStatusCheck wrpStsCheck = new MRSMEBESJobviewExtn.WrapperStatusCheck('CHECKED','READY'); 
              List<MRSMEBESJobviewExtn.WrapperStatusCheck> lstgridTbl= new List<MRSMEBESJobviewExtn.WrapperStatusCheck>();
              lstgridTbl.add(wrpStsCheck );
              String gridTbl=JSON.serialize(lstgridTbl);
              controller.gridTblJSON=gridTbl;
              controller.approvalData();
              controller.jobviewName = 'Foundry';
              controller.approvalData();
              //system.assertEquals(controller.isReleaseComments, true);              
              controller.saveData();
              //system.assertEquals(controller.errorMessage, true);             
              controller.releaseReasonTxt = 'Release Reason';
              controller.isReleaseComments = true;
              controller.saveData(); 
              controller.releaseReasonTxt = 'Release Reason';             
              controller.isReleaseComments = true;
              controller.jobviewName = 'Customer';
              controller.saveData();
              controller.releaseReasonTxt = 'Release Reason';
              controller.isReleaseComments = true;
              controller.jobviewName = 'Tapeout Centre';
              controller.saveData();
              controller.releaseReasonTxt = 'Release Reason';
              controller.isReleaseComments = true;
              controller.jobviewName = 'Tapeout Application';
              controller.saveData();
              /*controller.jobviewName = 'Global Shuttle';
              controller.saveData();
              controller.jobviewName = 'MDP';
              controller.saveData();
              controller.jobviewName = 'TDTI-MPW';
              controller.saveData();*/
            }
            Test.stopTest();
        }   
    }
    
    /**
        This test method tests the main big methods of MRSMEBESJobviewExtn class.
        @method name: TestMainMethods2
        @parameter:   none.
        @return :     None.
     **/
     
    public static testMethod void TestMainMethods2Foundry (){
        // comment-out, refactor with testSetup method setup()
          // SwiftDataUtilityTest.customSystemData();
        //Account acc = SwiftDataUtilityTest.createTestAccountForDRT();
        Account acc = getAccount('Test Account 009');
        acc.stage__c = 'Qualified';
        update acc;
        User sysAdminUser = [SELECT Id,Name FROM User WHERE Profile.Name = 'System Administrator' AND isActive = true].get(0);
        /*Profile sysAdminProfile = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
        User userSA = new User(alias = 'testMRS', email='testMRS@test.com',
        emailencodingkey='UTF-8', lastname='testMRSLast', firstname='testMRSFirst', languagelocalekey='en_US',
        localesidkey='en_US', profileid = sysAdminProfile.Id,
        timezonesidkey='America/Los_Angeles', username='testMRS@test.com',communitynickname='testMRS');
        insert userSA;
        */
        User userSA = [SELECT Id FROM User WHERE Email = 'testMRS@test.com'];
        
        Account_Team_Proxy__c atp = new Account_Team_Proxy__c(User__c = userSA.id,Account__c=acc.id,Account_Access__c='Read/Write',
        Opportunity_Access__c='Read/Write',Team_Role__c='Field Application Engineer',Sequence_No__c='1',Account_Role_ID__c='test1239');       
        insert atp;                
        System.runAs(sysAdminUser){
            Group groupGS = [select Id, DeveloperName, Name from Group where DeveloperName = 'Swift_GlobalShuttle'];
            Group groupSA = [select Id, DeveloperName, Name from Group where DeveloperName = 'SWIFT_Admin'];
            Group groupFJ = [select Id, DeveloperName, Name from Group where DeveloperName = 'Swift_Foundry_Jobviewer'];
            List<GroupMember> listGM = new List<GroupMember>(); 
            GroupMember groupMemberSA = new GroupMember(GroupId = groupSA.Id,UserOrGroupId = userSA.Id);
            GroupMember groupMemberGS = new GroupMember(GroupId = groupGS.Id,UserOrGroupId = userSA.Id);   
            GroupMember groupMemberFJ = new GroupMember(GroupId = groupFJ.Id,UserOrGroupId = userSA.Id);       
            listGM.add(groupMemberSA);
            listGM.add(groupMemberGS);
            listGM.add(groupMemberFJ);
            insert listGM;
            //Mask_Set_Title__c objMST = SwiftDataUtilityTest.createMST('MPW001');
            //insert objMST;
            Mask_Set_Title__c objMST = [SELECT Id, Name FROM Mask_Set_Title__c LIMIT 1];
            PTRF__c objPTRF = new PTRF__c(Name ='PTRF1',Order_Type__c ='Test Order Type',Recticle_Type__c ='Multi Node Reticle (MNR)',MaskSetTitle__c=objMST.Id,Customer__c=acc.id, Prime_Tapeout__c = true ,Prime_GDSOUT_Review__c=true,Status__c='Perform Tapeout Options',Device_Id__c='Dev1234');
            insert objPTRF;
            List<PTRF_JobViewer_Info__c> listPTRFJVI = new List<PTRF_JobViewer_Info__c>();
            PTRF_JobViewer_Info__c objPTRFJVC = new PTRF_JobViewer_Info__c(Name='SAC',PTRF__c=objPTRF.Id,Jobview__c='Customer',Jobview_Type__c='Frame Mockup;Prime GDSOUT Review;MEBES Jobview',User__c=userSA.Id);
            PTRF_JobViewer_Info__c objPTRFJVF = new PTRF_JobViewer_Info__c(Name='SAF',PTRF__c=objPTRF.Id,Jobview__c='Foundry',Jobview_Type__c='Frame Mockup;Prime GDSOUT Review;MEBES Jobview',User__c=userSA.Id);
            //PTRF_JobViewer_Info__c objPTRFJVCust = new PTRF_JobViewer_Info__c(Name='SACust',PTRF__c=objPTRF.Id,Jobview__c='Customer',Jobview_Type__c='Frame Mockup;Prime GDSOUT Review;MEBES Jobview',User__c=listCon.get(0).Id);
            listPTRFJVI.add(objPTRFJVC);
            listPTRFJVI.add(objPTRFJVF);
            //listPTRFJVI.add(objPTRFJVCust);
            insert listPTRFJVI;
            //MRS__c objMRS = new MRS__c(Mask_Set_Title__c=objMST.Id);
            //insert objMRS;
            MRS__c objMRS = [SELECT Id, Mask_Set_Title__c FROM MRS__c LIMIT 1];
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
            MRS_Layer_Chip_Association__c objMRSLCA1 = new MRS_Layer_Chip_Association__c(Layer__c=objMRSLA1.Id,Chip__c=objMRSCD1.Id,PTRF__c=objPTRF.Id,Tech_Geo__c='0.019UM',Customer_Name__c=acc.Id,Device_Id__c='Device1',Mask_Set_Title_Id__c=String.valueOf(objMST.Id).substring(0,15));
            MRS_Layer_Chip_Association__c objMRSLCA2 = new MRS_Layer_Chip_Association__c(Layer__c=objMRSLA1.Id,Chip__c=objMRSCD2.Id,PTRF__c=objPTRF.Id,Tech_Geo__c='0.019UM',Customer_Name__c=acc.Id,Device_Id__c='Device1',Mask_Set_Title_Id__c=String.valueOf(objMST.Id).substring(0,15));
            MRS_Layer_Chip_Association__c objMRSLCA3 = new MRS_Layer_Chip_Association__c(Layer__c=objMRSLA2.Id,Chip__c=objMRSCD1.Id,PTRF__c=objPTRF.Id,Tech_Geo__c='0.019UM',Customer_Name__c=acc.Id,Device_Id__c='Device1',Mask_Set_Title_Id__c=String.valueOf(objMST.Id).substring(0,15));
            MRS_Layer_Chip_Association__c objMRSLCA4 = new MRS_Layer_Chip_Association__c(Layer__c=objMRSLA2.Id,Chip__c=objMRSCD2.Id,PTRF__c=objPTRF.Id,Tech_Geo__c='0.019UM',Customer_Name__c=acc.Id,Device_Id__c='Device1',Mask_Set_Title_Id__c=String.valueOf(objMST.Id).substring(0,15));
            MRS_Layer_Chip_Association__c objMRSLCA5 = new MRS_Layer_Chip_Association__c(Layer__c=objMRSLA1.Id,Chip__c=objMRSCD3.Id,PTRF__c=objPTRF.Id,Tech_Geo__c='0.019UM',Customer_Name__c=acc.Id,Device_Id__c='Device1',Mask_Set_Title_Id__c=String.valueOf(objMST.Id).substring(0,15));
            MRS_Layer_Chip_Association__c objMRSLCA6 = new MRS_Layer_Chip_Association__c(Layer__c=objMRSLA2.Id,Chip__c=objMRSCD3.Id,PTRF__c=objPTRF.Id,Tech_Geo__c='0.019UM',Customer_Name__c=acc.Id,Device_Id__c='Device1',Mask_Set_Title_Id__c=String.valueOf(objMST.Id).substring(0,15));
            objMRSLCA1 = createLayerChipData(objMRSLCA1);
            objMRSLCA2 = createLayerChipData(objMRSLCA2);
            objMRSLCA3 = createLayerChipData(objMRSLCA3);
            objMRSLCA4 = createLayerChipData(objMRSLCA4);
            objMRSLCA5 = createLayerChipData(objMRSLCA5);
            objMRSLCA6 = createLayerChipData(objMRSLCA6);
            listMRSLCA.add(objMRSLCA1);
            listMRSLCA.add(objMRSLCA2);
            listMRSLCA.add(objMRSLCA3);
            listMRSLCA.add(objMRSLCA4);
            listMRSLCA.add(objMRSLCA5);
            listMRSLCA.add(objMRSLCA6);
            insert listMRSLCA;
            Test.startTest();
            System.runAs(userSA){
                DRT__c objDRT = new DRT__c(Name='Test DRT');
                insert objDRT;
                ApexPages.currentPage().getHeaders().put('Host','MRS Page');
                ApexPages.currentPage().getParameters().put('jobview','Customer');                 
                //Test.startTest();
                MRSMEBESJobviewExtn controller = new MRSMEBESJobviewExtn (new ApexPages.StandardController(objDRT));
                //system.assertEquals(controller.jobviewName, 'Customer');
                controller.selectedCustomer = acc.Id;
                controller.populateMSTList();
                //system.assertEquals(controller.customerNameAfterSave.toUpperCase(),'TEST REC (TESTREC)');                
                controller.populateMSTList();
                controller.selectedMST = objMST.Id;
                //controller.populateMEBESTable();
                //system.assertEquals(controller.mstAfterSave, 'MPW001');
                controller.jobviewName = 'Foundry';
                
                controller.populateMEBESTable();
                
                /*----------------Wrapper Chip----------*/
               MRSMEBESJobviewExtn.WrapperChip wrpChip = new MRSMEBESJobviewExtn.WrapperChip('Chip001'); 
               List<MRSMEBESJobviewExtn.WrapperChip> lstMainTableData = new List<MRSMEBESJobviewExtn.WrapperChip>();
               lstMainTableData.add(wrpChip);
               String MainTable=JSON.serialize(lstMainTableData);
               controller.mainTableJSON=MainTable;
             /*-------------------WrapperLayerPtrf -------------------*/
               MRSMEBESJobviewExtn.WrapperLayerPtrf wrpLayerPtrf = new MRSMEBESJobviewExtn.WrapperLayerPtrf('1','RXAZ(123)',objPTRF.Name,String.Valueof(objPTRF.Id),'0.019UM'); 
              List<MRSMEBESJobviewExtn.WrapperLayerPtrf> lstsideHeader= new List<MRSMEBESJobviewExtn.WrapperLayerPtrf>();
              lstsideHeader.add(wrpLayerPtrf);       
              String sideHeader=JSON.serialize(lstsideHeader);
              controller.sideHeaderJSON=sideHeader;
              /*--------------WrapperStatusCheck----------------*/
               MRSMEBESJobviewExtn.WrapperStatusCheck wrpStsCheck = new MRSMEBESJobviewExtn.WrapperStatusCheck('CHECKED','READY'); 
              List<MRSMEBESJobviewExtn.WrapperStatusCheck> lstgridTbl= new List<MRSMEBESJobviewExtn.WrapperStatusCheck>();
              lstgridTbl.add(wrpStsCheck );
              String gridTbl=JSON.serialize(lstgridTbl);
              controller.gridTblJSON=gridTbl;
              controller.approvalData();
              controller.jobviewName = 'Global Shuttle';
              controller.approvalData();
              //system.assertEquals(controller.isReleaseComments, true);              
              controller.saveData();
              //system.assertEquals(controller.errorMessage, true);             
              controller.releaseReasonTxt = 'Release Reason';
              controller.isReleaseComments = true;
              controller.saveData(); 
              controller.releaseReasonTxt = 'Release Reason';             
              controller.isReleaseComments = true;
              controller.jobviewName = 'MDP';
              controller.saveData();
              controller.releaseReasonTxt = 'Release Reason';
              controller.isReleaseComments = true;
              controller.jobviewName = 'TDTI-MPW';
              controller.saveData();
              
            }
            Test.stopTest();
        }   
    }
    
    /**
        This test method tests the main big methods of MRSMEBESJobviewExtn class.
        @method name: TestMainMethods2
        @parameter:   none.
        @return :     None.
     **/
     
    public static testMethod void TestMainMethods2TC (){
        // comment-out, refactor with testSetup method setup()
          // SwiftDataUtilityTest.customSystemData();
        //Account acc = SwiftDataUtilityTest.createTestAccountForDRT();
        Account acc = getAccount('Test Account 009');
        acc.stage__c = 'Qualified';
        update acc;
        User sysAdminUser = [SELECT Id,Name FROM User WHERE Profile.Name = 'System Administrator' AND isActive = true].get(0);
        /*Profile sysAdminProfile = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
        User userSA = new User(alias = 'testMRS', email='testMRS@test.com',
        emailencodingkey='UTF-8', lastname='testMRSLast', firstname='testMRSFirst', languagelocalekey='en_US',
        localesidkey='en_US', profileid = sysAdminProfile.Id,
        timezonesidkey='America/Los_Angeles', username='testMRS@test.com',communitynickname='testMRS');
        insert userSA;
        */
        User userSA = [SELECT Id FROM User WHERE Email = 'testMRS@test.com'];
        
        Account_Team_Proxy__c atp = new Account_Team_Proxy__c(User__c = userSA.id,Account__c=acc.id,Account_Access__c='Read/Write',
        Opportunity_Access__c='Read/Write',Team_Role__c='Field Application Engineer',Sequence_No__c='1',Account_Role_ID__c='test1239');       
        insert atp;                
        System.runAs(sysAdminUser){
            Group groupGS = [select Id, DeveloperName, Name from Group where DeveloperName = 'Swift_GlobalShuttle'];
            Group groupSA = [select Id, DeveloperName, Name from Group where DeveloperName = 'SWIFT_Admin'];
            Group groupFJ = [select Id, DeveloperName, Name from Group where DeveloperName = 'Swift_Foundry_Jobviewer'];
            List<GroupMember> listGM = new List<GroupMember>(); 
            GroupMember groupMemberSA = new GroupMember(GroupId = groupSA.Id,UserOrGroupId = userSA.Id);
            GroupMember groupMemberGS = new GroupMember(GroupId = groupGS.Id,UserOrGroupId = userSA.Id);   
            GroupMember groupMemberFJ = new GroupMember(GroupId = groupFJ.Id,UserOrGroupId = userSA.Id);       
            listGM.add(groupMemberSA);
            listGM.add(groupMemberGS);
            listGM.add(groupMemberFJ);
            insert listGM;
            //Mask_Set_Title__c objMST = SwiftDataUtilityTest.createMST('MPW001');
            //insert objMST;
            Mask_Set_Title__c objMST = [SELECT Id, Name FROM Mask_Set_Title__c LIMIT 1];
            PTRF__c objPTRF = new PTRF__c(Name ='PTRF1',Order_Type__c ='Test Order Type',Recticle_Type__c ='Multi Node Reticle (MNR)',MaskSetTitle__c=objMST.Id,Customer__c=acc.id, Prime_Tapeout__c = true ,Prime_GDSOUT_Review__c=true,Status__c='Perform Tapeout Options',Device_Id__c='Dev1234');
            insert objPTRF;
            List<PTRF_JobViewer_Info__c> listPTRFJVI = new List<PTRF_JobViewer_Info__c>();
            PTRF_JobViewer_Info__c objPTRFJVC = new PTRF_JobViewer_Info__c(Name='SAC',PTRF__c=objPTRF.Id,Jobview__c='Customer',Jobview_Type__c='Frame Mockup;Prime GDSOUT Review;MEBES Jobview',User__c=userSA.Id);
            PTRF_JobViewer_Info__c objPTRFJVF = new PTRF_JobViewer_Info__c(Name='SAF',PTRF__c=objPTRF.Id,Jobview__c='Foundry',Jobview_Type__c='Frame Mockup;Prime GDSOUT Review;MEBES Jobview',User__c=userSA.Id);
            //PTRF_JobViewer_Info__c objPTRFJVCust = new PTRF_JobViewer_Info__c(Name='SACust',PTRF__c=objPTRF.Id,Jobview__c='Customer',Jobview_Type__c='Frame Mockup;Prime GDSOUT Review;MEBES Jobview',User__c=listCon.get(0).Id);
            listPTRFJVI.add(objPTRFJVC);
            listPTRFJVI.add(objPTRFJVF);
            //listPTRFJVI.add(objPTRFJVCust);
            insert listPTRFJVI;
            //MRS__c objMRS = new MRS__c(Mask_Set_Title__c=objMST.Id);
            //insert objMRS;
            MRS__c objMRS = [SELECT Id, Mask_Set_Title__c FROM MRS__c LIMIT 1];
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
            MRS_Layer_Chip_Association__c objMRSLCA1 = new MRS_Layer_Chip_Association__c(Layer__c=objMRSLA1.Id,Chip__c=objMRSCD1.Id,PTRF__c=objPTRF.Id,Tech_Geo__c='0.019UM',Customer_Name__c=acc.Id,Device_Id__c='Device1',Mask_Set_Title_Id__c=String.valueOf(objMST.Id).substring(0,15));
            MRS_Layer_Chip_Association__c objMRSLCA2 = new MRS_Layer_Chip_Association__c(Layer__c=objMRSLA1.Id,Chip__c=objMRSCD2.Id,PTRF__c=objPTRF.Id,Tech_Geo__c='0.019UM',Customer_Name__c=acc.Id,Device_Id__c='Device1',Mask_Set_Title_Id__c=String.valueOf(objMST.Id).substring(0,15));
            MRS_Layer_Chip_Association__c objMRSLCA3 = new MRS_Layer_Chip_Association__c(Layer__c=objMRSLA2.Id,Chip__c=objMRSCD1.Id,PTRF__c=objPTRF.Id,Tech_Geo__c='0.019UM',Customer_Name__c=acc.Id,Device_Id__c='Device1',Mask_Set_Title_Id__c=String.valueOf(objMST.Id).substring(0,15));
            MRS_Layer_Chip_Association__c objMRSLCA4 = new MRS_Layer_Chip_Association__c(Layer__c=objMRSLA2.Id,Chip__c=objMRSCD2.Id,PTRF__c=objPTRF.Id,Tech_Geo__c='0.019UM',Customer_Name__c=acc.Id,Device_Id__c='Device1',Mask_Set_Title_Id__c=String.valueOf(objMST.Id).substring(0,15));
            MRS_Layer_Chip_Association__c objMRSLCA5 = new MRS_Layer_Chip_Association__c(Layer__c=objMRSLA1.Id,Chip__c=objMRSCD3.Id,PTRF__c=objPTRF.Id,Tech_Geo__c='0.019UM',Customer_Name__c=acc.Id,Device_Id__c='Device1',Mask_Set_Title_Id__c=String.valueOf(objMST.Id).substring(0,15));
            MRS_Layer_Chip_Association__c objMRSLCA6 = new MRS_Layer_Chip_Association__c(Layer__c=objMRSLA2.Id,Chip__c=objMRSCD3.Id,PTRF__c=objPTRF.Id,Tech_Geo__c='0.019UM',Customer_Name__c=acc.Id,Device_Id__c='Device1',Mask_Set_Title_Id__c=String.valueOf(objMST.Id).substring(0,15));
            objMRSLCA1 = createLayerChipData(objMRSLCA1);
            objMRSLCA2 = createLayerChipData(objMRSLCA2);
            objMRSLCA3 = createLayerChipData(objMRSLCA3);
            objMRSLCA4 = createLayerChipData(objMRSLCA4);
            objMRSLCA5 = createLayerChipData(objMRSLCA5);
            objMRSLCA6 = createLayerChipData(objMRSLCA6);
            listMRSLCA.add(objMRSLCA1);
            listMRSLCA.add(objMRSLCA2);
            listMRSLCA.add(objMRSLCA3);
            listMRSLCA.add(objMRSLCA4);
            listMRSLCA.add(objMRSLCA5);
            listMRSLCA.add(objMRSLCA6);
            insert listMRSLCA;
            Test.startTest();
            System.runAs(userSA){
                DRT__c objDRT = new DRT__c(Name='Test DRT');
                insert objDRT;
                ApexPages.currentPage().getHeaders().put('Host','MRS Page');
                ApexPages.currentPage().getParameters().put('jobview','Customer');                 
                //Test.startTest();
                MRSMEBESJobviewExtn controller = new MRSMEBESJobviewExtn (new ApexPages.StandardController(objDRT));
                //system.assertEquals(controller.jobviewName, 'Customer');
                controller.selectedCustomer = acc.Id;
                controller.populateMSTList();
                //system.assertEquals(controller.customerNameAfterSave.toUpperCase(),'TEST REC (TESTREC)');                
                controller.populateMSTList();
                controller.selectedMST = objMST.Id;
                //controller.populateMEBESTable();
                //system.assertEquals(controller.mstAfterSave, null);
                //controller.jobviewName = 'Foundry';
                
                //system.assertEquals(controller.isUserGS, true);*/
                controller.jobviewName = 'Tapeout Centre';
                //Test.startTest();
                controller.populateMEBESTable();
                /*----------------Wrapper Chip----------*/
               MRSMEBESJobviewExtn.WrapperChip wrpChip = new MRSMEBESJobviewExtn.WrapperChip('Chip001'); 
               List<MRSMEBESJobviewExtn.WrapperChip> lstMainTableData = new List<MRSMEBESJobviewExtn.WrapperChip>();
               lstMainTableData.add(wrpChip);
               String MainTable=JSON.serialize(lstMainTableData);
               controller.mainTableJSON=MainTable;
             /*-------------------WrapperLayerPtrf -------------------*/
               MRSMEBESJobviewExtn.WrapperLayerPtrf wrpLayerPtrf = new MRSMEBESJobviewExtn.WrapperLayerPtrf('1','RXAZ(123)',objPTRF.Name,String.Valueof(objPTRF.Id),'0.019UM'); 
              List<MRSMEBESJobviewExtn.WrapperLayerPtrf> lstsideHeader= new List<MRSMEBESJobviewExtn.WrapperLayerPtrf>();
              lstsideHeader.add(wrpLayerPtrf);       
              String sideHeader=JSON.serialize(lstsideHeader);
              controller.sideHeaderJSON=sideHeader;
              /*--------------WrapperStatusCheck----------------*/
               MRSMEBESJobviewExtn.WrapperStatusCheck wrpStsCheck = new MRSMEBESJobviewExtn.WrapperStatusCheck('CHECKED','READY'); 
              List<MRSMEBESJobviewExtn.WrapperStatusCheck> lstgridTbl= new List<MRSMEBESJobviewExtn.WrapperStatusCheck>();
              lstgridTbl.add(wrpStsCheck );
              String gridTbl=JSON.serialize(lstgridTbl);
              controller.gridTblJSON=gridTbl;
              controller.approvalData();
              controller.jobviewName = 'Global Shuttle';
              controller.approvalData();
              //system.assertEquals(controller.isReleaseComments, false);              
              controller.saveData();
              //system.assertEquals(controller.errorMessage, false);             
              controller.releaseReasonTxt = 'Release Reason';
              controller.isReleaseComments = true;
              controller.saveData(); 
              controller.releaseReasonTxt = 'Release Reason';             
              controller.isReleaseComments = true;
              controller.jobviewName = 'MDP';
              controller.saveData();
              controller.releaseReasonTxt = 'Release Reason';
              controller.isReleaseComments = true;
              controller.jobviewName = 'TDTI-MPW';
              controller.saveData();
              
            }
            Test.stopTest();
        }   
    }
    
    /**
        This test method tests the main big methods of MRSMEBESJobviewExtn class.
        @method name: TestMainMethods2
        @parameter:   none.
        @return :     None.
     **/
     
    public static testMethod void TestMainMethods2TA (){
        // comment-out, refactor with testSetup method setup()
          // SwiftDataUtilityTest.customSystemData();
        //Account acc = SwiftDataUtilityTest.createTestAccountForDRT();
        Account acc = getAccount('Test Account 009');
        acc.stage__c = 'Qualified';
        update acc;
        User sysAdminUser = [SELECT Id,Name FROM User WHERE Profile.Name = 'System Administrator' AND isActive = true].get(0);
        /*Profile sysAdminProfile = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
        User userSA = new User(alias = 'testMRS', email='testMRS@test.com',
        emailencodingkey='UTF-8', lastname='testMRSLast', firstname='testMRSFirst', languagelocalekey='en_US',
        localesidkey='en_US', profileid = sysAdminProfile.Id,
        timezonesidkey='America/Los_Angeles', username='testMRS@test.com',communitynickname='testMRS');
        insert userSA; 
        */
        User userSA = [SELECT Id FROM User WHERE Email = 'testMRS@test.com'];
        
        Account_Team_Proxy__c atp = new Account_Team_Proxy__c(User__c = userSA.id,Account__c=acc.id,Account_Access__c='Read/Write',
        Opportunity_Access__c='Read/Write',Team_Role__c='Field Application Engineer',Sequence_No__c='1',Account_Role_ID__c='test1239');       
        insert atp;                
        System.runAs(sysAdminUser){
            Group groupGS = [select Id, DeveloperName, Name from Group where DeveloperName = 'Swift_GlobalShuttle'];
            Group groupSA = [select Id, DeveloperName, Name from Group where DeveloperName = 'SWIFT_Admin'];
            Group groupFJ = [select Id, DeveloperName, Name from Group where DeveloperName = 'Swift_Foundry_Jobviewer'];
            List<GroupMember> listGM = new List<GroupMember>(); 
            GroupMember groupMemberSA = new GroupMember(GroupId = groupSA.Id,UserOrGroupId = userSA.Id);
            GroupMember groupMemberGS = new GroupMember(GroupId = groupGS.Id,UserOrGroupId = userSA.Id);   
            GroupMember groupMemberFJ = new GroupMember(GroupId = groupFJ.Id,UserOrGroupId = userSA.Id);       
            listGM.add(groupMemberSA);
            listGM.add(groupMemberGS);
            listGM.add(groupMemberFJ);
            insert listGM;
            //Mask_Set_Title__c objMST = SwiftDataUtilityTest.createMST('MPW001');
            //insert objMST;
            Mask_Set_Title__c objMST = [SELECT Id, Name FROM Mask_Set_Title__c LIMIT 1];
            PTRF__c objPTRF = new PTRF__c(Name ='PTRF1',Order_Type__c ='Test Order Type',Recticle_Type__c ='Multi Node Reticle (MNR)',MaskSetTitle__c=objMST.Id,Customer__c=acc.id, Prime_Tapeout__c = true ,Prime_GDSOUT_Review__c=true,Status__c='Perform Tapeout Options',Device_Id__c='Dev1234');
            insert objPTRF;
            List<PTRF_JobViewer_Info__c> listPTRFJVI = new List<PTRF_JobViewer_Info__c>();
            PTRF_JobViewer_Info__c objPTRFJVC = new PTRF_JobViewer_Info__c(Name='SAC',PTRF__c=objPTRF.Id,Jobview__c='Customer',Jobview_Type__c='Frame Mockup;Prime GDSOUT Review;MEBES Jobview',User__c=userSA.Id);
            PTRF_JobViewer_Info__c objPTRFJVF = new PTRF_JobViewer_Info__c(Name='SAF',PTRF__c=objPTRF.Id,Jobview__c='Foundry',Jobview_Type__c='Frame Mockup;Prime GDSOUT Review;MEBES Jobview',User__c=userSA.Id);
            //PTRF_JobViewer_Info__c objPTRFJVCust = new PTRF_JobViewer_Info__c(Name='SACust',PTRF__c=objPTRF.Id,Jobview__c='Customer',Jobview_Type__c='Frame Mockup;Prime GDSOUT Review;MEBES Jobview',User__c=listCon.get(0).Id);
            listPTRFJVI.add(objPTRFJVC);
            listPTRFJVI.add(objPTRFJVF);
            //listPTRFJVI.add(objPTRFJVCust);
            insert listPTRFJVI;
            //MRS__c objMRS = new MRS__c(Mask_Set_Title__c=objMST.Id);
            //insert objMRS;
            MRS__c objMRS = [SELECT Id, Mask_Set_Title__c FROM MRS__c LIMIT 1];
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
            MRS_Layer_Chip_Association__c objMRSLCA1 = new MRS_Layer_Chip_Association__c(Layer__c=objMRSLA1.Id,Chip__c=objMRSCD1.Id,PTRF__c=objPTRF.Id,Tech_Geo__c='0.019UM',Customer_Name__c=acc.Id,Device_Id__c='Device1',Mask_Set_Title_Id__c=String.valueOf(objMST.Id).substring(0,15));
            MRS_Layer_Chip_Association__c objMRSLCA2 = new MRS_Layer_Chip_Association__c(Layer__c=objMRSLA1.Id,Chip__c=objMRSCD2.Id,PTRF__c=objPTRF.Id,Tech_Geo__c='0.019UM',Customer_Name__c=acc.Id,Device_Id__c='Device1',Mask_Set_Title_Id__c=String.valueOf(objMST.Id).substring(0,15));
            MRS_Layer_Chip_Association__c objMRSLCA3 = new MRS_Layer_Chip_Association__c(Layer__c=objMRSLA2.Id,Chip__c=objMRSCD1.Id,PTRF__c=objPTRF.Id,Tech_Geo__c='0.019UM',Customer_Name__c=acc.Id,Device_Id__c='Device1',Mask_Set_Title_Id__c=String.valueOf(objMST.Id).substring(0,15));
            MRS_Layer_Chip_Association__c objMRSLCA4 = new MRS_Layer_Chip_Association__c(Layer__c=objMRSLA2.Id,Chip__c=objMRSCD2.Id,PTRF__c=objPTRF.Id,Tech_Geo__c='0.019UM',Customer_Name__c=acc.Id,Device_Id__c='Device1',Mask_Set_Title_Id__c=String.valueOf(objMST.Id).substring(0,15));
            MRS_Layer_Chip_Association__c objMRSLCA5 = new MRS_Layer_Chip_Association__c(Layer__c=objMRSLA1.Id,Chip__c=objMRSCD3.Id,PTRF__c=objPTRF.Id,Tech_Geo__c='0.019UM',Customer_Name__c=acc.Id,Device_Id__c='Device1',Mask_Set_Title_Id__c=String.valueOf(objMST.Id).substring(0,15));
            MRS_Layer_Chip_Association__c objMRSLCA6 = new MRS_Layer_Chip_Association__c(Layer__c=objMRSLA2.Id,Chip__c=objMRSCD3.Id,PTRF__c=objPTRF.Id,Tech_Geo__c='0.019UM',Customer_Name__c=acc.Id,Device_Id__c='Device1',Mask_Set_Title_Id__c=String.valueOf(objMST.Id).substring(0,15));
            objMRSLCA1 = createLayerChipData(objMRSLCA1);
            objMRSLCA2 = createLayerChipData(objMRSLCA2);
            objMRSLCA3 = createLayerChipData(objMRSLCA3);
            objMRSLCA4 = createLayerChipData(objMRSLCA4);
            objMRSLCA5 = createLayerChipData(objMRSLCA5);
            objMRSLCA6 = createLayerChipData(objMRSLCA6);
            listMRSLCA.add(objMRSLCA1);
            listMRSLCA.add(objMRSLCA2);
            listMRSLCA.add(objMRSLCA3);
            listMRSLCA.add(objMRSLCA4);
            listMRSLCA.add(objMRSLCA5);
            listMRSLCA.add(objMRSLCA6);
            insert listMRSLCA;
            Test.startTest();
            System.runAs(userSA){
                DRT__c objDRT = new DRT__c(Name='Test DRT');
                insert objDRT;
                ApexPages.currentPage().getHeaders().put('Host','MRS Page');
                ApexPages.currentPage().getParameters().put('jobview','Customer');                 
                //Test.startTest();
                MRSMEBESJobviewExtn controller = new MRSMEBESJobviewExtn (new ApexPages.StandardController(objDRT));
                //system.assertEquals(controller.jobviewName, 'Customer');
                controller.selectedCustomer = acc.Id;
                controller.populateMSTList();
                //system.assertEquals(controller.customerNameAfterSave.toUpperCase(),'TEST REC (TESTREC)');                
                controller.populateMSTList();
                controller.selectedMST = objMST.Id;
                //controller.populateMEBESTable();
                //system.assertEquals(controller.mstAfterSave, null);
                //controller.jobviewName = 'Foundry';
                
                controller.jobviewName = 'Tapeout Application';
                controller.populateMEBESTable();
                
                /*----------------Wrapper Chip----------*/
               MRSMEBESJobviewExtn.WrapperChip wrpChip = new MRSMEBESJobviewExtn.WrapperChip('Chip001'); 
               List<MRSMEBESJobviewExtn.WrapperChip> lstMainTableData = new List<MRSMEBESJobviewExtn.WrapperChip>();
               lstMainTableData.add(wrpChip);
               String MainTable=JSON.serialize(lstMainTableData);
               controller.mainTableJSON=MainTable;
             /*-------------------WrapperLayerPtrf -------------------*/
               MRSMEBESJobviewExtn.WrapperLayerPtrf wrpLayerPtrf = new MRSMEBESJobviewExtn.WrapperLayerPtrf('1','RXAZ(123)',objPTRF.Name,String.Valueof(objPTRF.Id),'0.019UM'); 
              List<MRSMEBESJobviewExtn.WrapperLayerPtrf> lstsideHeader= new List<MRSMEBESJobviewExtn.WrapperLayerPtrf>();
              lstsideHeader.add(wrpLayerPtrf);       
              String sideHeader=JSON.serialize(lstsideHeader);
              controller.sideHeaderJSON=sideHeader;
              /*--------------WrapperStatusCheck----------------*/
               MRSMEBESJobviewExtn.WrapperStatusCheck wrpStsCheck = new MRSMEBESJobviewExtn.WrapperStatusCheck('CHECKED','READY'); 
              List<MRSMEBESJobviewExtn.WrapperStatusCheck> lstgridTbl= new List<MRSMEBESJobviewExtn.WrapperStatusCheck>();
              lstgridTbl.add(wrpStsCheck );
              String gridTbl=JSON.serialize(lstgridTbl);
              controller.gridTblJSON=gridTbl;
              controller.approvalData();
              controller.jobviewName = 'Global Shuttle';
              controller.approvalData();
              //system.assertEquals(controller.isReleaseComments, false);              
              controller.saveData();
              //system.assertEquals(controller.errorMessage, false);             
              controller.releaseReasonTxt = 'Release Reason';
              controller.isReleaseComments = true;
              controller.saveData(); 
              controller.releaseReasonTxt = 'Release Reason';             
              controller.isReleaseComments = true;
              controller.jobviewName = 'MDP';
              controller.saveData();
              controller.releaseReasonTxt = 'Release Reason';
              controller.isReleaseComments = true;
              controller.jobviewName = 'TDTI-MPW';
              controller.saveData();
              
            }
            Test.stopTest();
        }   
    }
    
    /**
        This test method tests the main big methods of MRSMEBESJobviewExtn class.
        @method name: TestMainMethods2
        @parameter:   none.
        @return :     None.
     **/
     
    public static testMethod void TestMainMethods2GS (){
        // comment-out, refactor with testSetup method setup()
          // SwiftDataUtilityTest.customSystemData();
        //Account acc = SwiftDataUtilityTest.createTestAccountForDRT();
        Account acc = getAccount('Test Account 009');
        acc.stage__c = 'Qualified';
        update acc;
        User sysAdminUser = [SELECT Id,Name FROM User WHERE Profile.Name = 'System Administrator' AND isActive = true].get(0);
        /*Profile sysAdminProfile = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
        User userSA = new User(alias = 'testMRS', email='testMRS@test.com',
        emailencodingkey='UTF-8', lastname='testMRSLast', firstname='testMRSFirst', languagelocalekey='en_US',
        localesidkey='en_US', profileid = sysAdminProfile.Id,
        timezonesidkey='America/Los_Angeles', username='testMRS@test.com',communitynickname='testMRS');
        insert userSA;
        */
        User userSA = [SELECT Id FROM User WHERE Email = 'testMRS@test.com'];
        
        Account_Team_Proxy__c atp = new Account_Team_Proxy__c(User__c = userSA.id,Account__c=acc.id,Account_Access__c='Read/Write',
        Opportunity_Access__c='Read/Write',Team_Role__c='Field Application Engineer',Sequence_No__c='1',Account_Role_ID__c='test1239');       
        insert atp;                
        System.runAs(sysAdminUser){
            Group groupGS = [select Id, DeveloperName, Name from Group where DeveloperName = 'Swift_GlobalShuttle'];
            Group groupSA = [select Id, DeveloperName, Name from Group where DeveloperName = 'SWIFT_Admin'];
            Group groupFJ = [select Id, DeveloperName, Name from Group where DeveloperName = 'Swift_Foundry_Jobviewer'];
            List<GroupMember> listGM = new List<GroupMember>(); 
            GroupMember groupMemberSA = new GroupMember(GroupId = groupSA.Id,UserOrGroupId = userSA.Id);
            GroupMember groupMemberGS = new GroupMember(GroupId = groupGS.Id,UserOrGroupId = userSA.Id);   
            GroupMember groupMemberFJ = new GroupMember(GroupId = groupFJ.Id,UserOrGroupId = userSA.Id);       
            listGM.add(groupMemberSA);
            listGM.add(groupMemberGS);
            listGM.add(groupMemberFJ);
            insert listGM;
            //Mask_Set_Title__c objMST = SwiftDataUtilityTest.createMST('MPW001');
            //insert objMST;
            Mask_Set_Title__c objMST = [SELECT Id, Name FROM Mask_Set_Title__c LIMIT 1];
            PTRF__c objPTRF = new PTRF__c(Name ='PTRF1',Order_Type__c ='Test Order Type',Recticle_Type__c ='Multi Node Reticle (MNR)',MaskSetTitle__c=objMST.Id,Customer__c=acc.id, Prime_Tapeout__c = true ,Prime_GDSOUT_Review__c=true,Status__c='Perform Tapeout Options',Device_Id__c='Dev1234');
            insert objPTRF;
            List<PTRF_JobViewer_Info__c> listPTRFJVI = new List<PTRF_JobViewer_Info__c>();
            PTRF_JobViewer_Info__c objPTRFJVC = new PTRF_JobViewer_Info__c(Name='SAC',PTRF__c=objPTRF.Id,Jobview__c='Customer',Jobview_Type__c='Frame Mockup;Prime GDSOUT Review;MEBES Jobview',User__c=userSA.Id);
            PTRF_JobViewer_Info__c objPTRFJVF = new PTRF_JobViewer_Info__c(Name='SAF',PTRF__c=objPTRF.Id,Jobview__c='Foundry',Jobview_Type__c='Frame Mockup;Prime GDSOUT Review;MEBES Jobview',User__c=userSA.Id);
            //PTRF_JobViewer_Info__c objPTRFJVCust = new PTRF_JobViewer_Info__c(Name='SACust',PTRF__c=objPTRF.Id,Jobview__c='Customer',Jobview_Type__c='Frame Mockup;Prime GDSOUT Review;MEBES Jobview',User__c=listCon.get(0).Id);
            listPTRFJVI.add(objPTRFJVC);
            listPTRFJVI.add(objPTRFJVF);
            //listPTRFJVI.add(objPTRFJVCust);
            insert listPTRFJVI;
            //MRS__c objMRS = new MRS__c(Mask_Set_Title__c=objMST.Id);
            //insert objMRS;
            MRS__c objMRS = [SELECT Id, Mask_Set_Title__c FROM MRS__c LIMIT 1];
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
            MRS_Layer_Chip_Association__c objMRSLCA1 = new MRS_Layer_Chip_Association__c(Layer__c=objMRSLA1.Id,Chip__c=objMRSCD1.Id,PTRF__c=objPTRF.Id,Tech_Geo__c='0.019UM',Customer_Name__c=acc.Id,Device_Id__c='Device1',Mask_Set_Title_Id__c=String.valueOf(objMST.Id).substring(0,15));
            MRS_Layer_Chip_Association__c objMRSLCA2 = new MRS_Layer_Chip_Association__c(Layer__c=objMRSLA1.Id,Chip__c=objMRSCD2.Id,PTRF__c=objPTRF.Id,Tech_Geo__c='0.019UM',Customer_Name__c=acc.Id,Device_Id__c='Device1',Mask_Set_Title_Id__c=String.valueOf(objMST.Id).substring(0,15));
            MRS_Layer_Chip_Association__c objMRSLCA3 = new MRS_Layer_Chip_Association__c(Layer__c=objMRSLA2.Id,Chip__c=objMRSCD1.Id,PTRF__c=objPTRF.Id,Tech_Geo__c='0.019UM',Customer_Name__c=acc.Id,Device_Id__c='Device1',Mask_Set_Title_Id__c=String.valueOf(objMST.Id).substring(0,15));
            MRS_Layer_Chip_Association__c objMRSLCA4 = new MRS_Layer_Chip_Association__c(Layer__c=objMRSLA2.Id,Chip__c=objMRSCD2.Id,PTRF__c=objPTRF.Id,Tech_Geo__c='0.019UM',Customer_Name__c=acc.Id,Device_Id__c='Device1',Mask_Set_Title_Id__c=String.valueOf(objMST.Id).substring(0,15));
            MRS_Layer_Chip_Association__c objMRSLCA5 = new MRS_Layer_Chip_Association__c(Layer__c=objMRSLA1.Id,Chip__c=objMRSCD3.Id,PTRF__c=objPTRF.Id,Tech_Geo__c='0.019UM',Customer_Name__c=acc.Id,Device_Id__c='Device1',Mask_Set_Title_Id__c=String.valueOf(objMST.Id).substring(0,15));
            MRS_Layer_Chip_Association__c objMRSLCA6 = new MRS_Layer_Chip_Association__c(Layer__c=objMRSLA2.Id,Chip__c=objMRSCD3.Id,PTRF__c=objPTRF.Id,Tech_Geo__c='0.019UM',Customer_Name__c=acc.Id,Device_Id__c='Device1',Mask_Set_Title_Id__c=String.valueOf(objMST.Id).substring(0,15));
            objMRSLCA1 = createLayerChipData(objMRSLCA1);
            objMRSLCA2 = createLayerChipData(objMRSLCA2);
            objMRSLCA3 = createLayerChipData(objMRSLCA3);
            objMRSLCA4 = createLayerChipData(objMRSLCA4);
            objMRSLCA5 = createLayerChipData(objMRSLCA5);
            objMRSLCA6 = createLayerChipData(objMRSLCA6);
            listMRSLCA.add(objMRSLCA1);
            listMRSLCA.add(objMRSLCA2);
            listMRSLCA.add(objMRSLCA3);
            listMRSLCA.add(objMRSLCA4);
            listMRSLCA.add(objMRSLCA5);
            listMRSLCA.add(objMRSLCA6);
            insert listMRSLCA;
            Test.startTest();
            System.runAs(userSA){
                DRT__c objDRT = new DRT__c(Name='Test DRT');
                insert objDRT;
                ApexPages.currentPage().getHeaders().put('Host','MRS Page');
                ApexPages.currentPage().getParameters().put('jobview','Customer');                 
                //Test.startTest();
                MRSMEBESJobviewExtn controller = new MRSMEBESJobviewExtn (new ApexPages.StandardController(objDRT));
                //system.assertEquals(controller.jobviewName, 'Customer');
                controller.selectedCustomer = acc.Id;
                controller.populateMSTList();
                //system.assertEquals(controller.customerNameAfterSave.toUpperCase(),'TEST REC (TESTREC)');                
                controller.populateMSTList();
                controller.selectedMST = objMST.Id;
                //controller.populateMEBESTable();
                //system.assertEquals(controller.mstAfterSave, null);
                //controller.jobviewName = 'Foundry';
                
                controller.jobviewName = 'Global Shuttle';
                controller.populateMEBESTable();
                
                /*----------------Wrapper Chip----------*/
               MRSMEBESJobviewExtn.WrapperChip wrpChip = new MRSMEBESJobviewExtn.WrapperChip('Chip001'); 
               List<MRSMEBESJobviewExtn.WrapperChip> lstMainTableData = new List<MRSMEBESJobviewExtn.WrapperChip>();
               lstMainTableData.add(wrpChip);
               String MainTable=JSON.serialize(lstMainTableData);
               controller.mainTableJSON=MainTable;
             /*-------------------WrapperLayerPtrf -------------------*/
               MRSMEBESJobviewExtn.WrapperLayerPtrf wrpLayerPtrf = new MRSMEBESJobviewExtn.WrapperLayerPtrf('1','RXAZ(123)',objPTRF.Name,String.Valueof(objPTRF.Id),'0.019UM'); 
              List<MRSMEBESJobviewExtn.WrapperLayerPtrf> lstsideHeader= new List<MRSMEBESJobviewExtn.WrapperLayerPtrf>();
              lstsideHeader.add(wrpLayerPtrf);       
              String sideHeader=JSON.serialize(lstsideHeader);
              controller.sideHeaderJSON=sideHeader;
              /*--------------WrapperStatusCheck----------------*/
               MRSMEBESJobviewExtn.WrapperStatusCheck wrpStsCheck = new MRSMEBESJobviewExtn.WrapperStatusCheck('CHECKED','READY'); 
              List<MRSMEBESJobviewExtn.WrapperStatusCheck> lstgridTbl= new List<MRSMEBESJobviewExtn.WrapperStatusCheck>();
              lstgridTbl.add(wrpStsCheck );
              String gridTbl=JSON.serialize(lstgridTbl);
              controller.gridTblJSON=gridTbl;
              controller.approvalData();
              controller.jobviewName = 'Global Shuttle';
              controller.approvalData();
              //system.assertEquals(controller.isReleaseComments, false);              
              controller.saveData();
              //system.assertEquals(controller.errorMessage, false);             
              controller.releaseReasonTxt = 'Release Reason';
              controller.isReleaseComments = true;
              controller.saveData(); 
              controller.releaseReasonTxt = 'Release Reason';             
              controller.isReleaseComments = true;
              controller.jobviewName = 'MDP';
              controller.saveData();
              controller.releaseReasonTxt = 'Release Reason';
              controller.isReleaseComments = true;
              controller.jobviewName = 'TDTI-MPW';
              controller.saveData();
              
            }
            Test.stopTest();
        }   
    }
    
    /**
        This test method tests the main big methods of MRSMEBESJobviewExtn class.
        @method name: TestMainMethods2
        @parameter:   none.
        @return :     None.
     **/
     
    public static testMethod void TestMainMethods2MDP (){
        // comment-out, refactor with testSetup method setup()
          // SwiftDataUtilityTest.customSystemData();
        //Account acc = SwiftDataUtilityTest.createTestAccountForDRT();
        Account acc = getAccount('Test Account 009');
        acc.stage__c = 'Qualified';
        update acc;
        User sysAdminUser = [SELECT Id,Name FROM User WHERE Profile.Name = 'System Administrator' AND isActive = true].get(0);
        /*Profile sysAdminProfile = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
        User userSA = new User(alias = 'testMRS', email='testMRS@test.com',
        emailencodingkey='UTF-8', lastname='testMRSLast', firstname='testMRSFirst', languagelocalekey='en_US',
        localesidkey='en_US', profileid = sysAdminProfile.Id,
        timezonesidkey='America/Los_Angeles', username='testMRS@test.com',communitynickname='testMRS');
        insert userSA; 
        */
        User userSA = [SELECT Id FROM User WHERE Email = 'testMRS@test.com'];
        
        Account_Team_Proxy__c atp = new Account_Team_Proxy__c(User__c = userSA.id,Account__c=acc.id,Account_Access__c='Read/Write',
        Opportunity_Access__c='Read/Write',Team_Role__c='Field Application Engineer',Sequence_No__c='1',Account_Role_ID__c='test1239');       
        insert atp;                
        System.runAs(sysAdminUser){
            Group groupGS = [select Id, DeveloperName, Name from Group where DeveloperName = 'Swift_GlobalShuttle'];
            Group groupSA = [select Id, DeveloperName, Name from Group where DeveloperName = 'SWIFT_Admin'];
            Group groupFJ = [select Id, DeveloperName, Name from Group where DeveloperName = 'Swift_Foundry_Jobviewer'];
            List<GroupMember> listGM = new List<GroupMember>(); 
            GroupMember groupMemberSA = new GroupMember(GroupId = groupSA.Id,UserOrGroupId = userSA.Id);
            GroupMember groupMemberGS = new GroupMember(GroupId = groupGS.Id,UserOrGroupId = userSA.Id);   
            GroupMember groupMemberFJ = new GroupMember(GroupId = groupFJ.Id,UserOrGroupId = userSA.Id);       
            listGM.add(groupMemberSA);
            listGM.add(groupMemberGS);
            listGM.add(groupMemberFJ);
            insert listGM;
            //Mask_Set_Title__c objMST = SwiftDataUtilityTest.createMST('MPW001');
            //insert objMST;
            Mask_Set_Title__c objMST = [SELECT Id, Name FROM Mask_Set_Title__c LIMIT 1];
            PTRF__c objPTRF = new PTRF__c(Name ='PTRF1',Order_Type__c ='Test Order Type',Recticle_Type__c ='Multi Node Reticle (MNR)',MaskSetTitle__c=objMST.Id,Customer__c=acc.id, Prime_Tapeout__c = true ,Prime_GDSOUT_Review__c=true,Status__c='Perform Tapeout Options',Device_Id__c='Dev1234');
            insert objPTRF;
            List<PTRF_JobViewer_Info__c> listPTRFJVI = new List<PTRF_JobViewer_Info__c>();
            PTRF_JobViewer_Info__c objPTRFJVC = new PTRF_JobViewer_Info__c(Name='SAC',PTRF__c=objPTRF.Id,Jobview__c='Customer',Jobview_Type__c='Frame Mockup;Prime GDSOUT Review;MEBES Jobview',User__c=userSA.Id);
            PTRF_JobViewer_Info__c objPTRFJVF = new PTRF_JobViewer_Info__c(Name='SAF',PTRF__c=objPTRF.Id,Jobview__c='Foundry',Jobview_Type__c='Frame Mockup;Prime GDSOUT Review;MEBES Jobview',User__c=userSA.Id);
            //PTRF_JobViewer_Info__c objPTRFJVCust = new PTRF_JobViewer_Info__c(Name='SACust',PTRF__c=objPTRF.Id,Jobview__c='Customer',Jobview_Type__c='Frame Mockup;Prime GDSOUT Review;MEBES Jobview',User__c=listCon.get(0).Id);
            listPTRFJVI.add(objPTRFJVC);
            listPTRFJVI.add(objPTRFJVF);
            //listPTRFJVI.add(objPTRFJVCust);
            insert listPTRFJVI;
            //MRS__c objMRS = new MRS__c(Mask_Set_Title__c=objMST.Id);
            //insert objMRS;
            MRS__c objMRS = [SELECT Id, Mask_Set_Title__c FROM MRS__c LIMIT 1];
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
            MRS_Layer_Chip_Association__c objMRSLCA1 = new MRS_Layer_Chip_Association__c(Layer__c=objMRSLA1.Id,Chip__c=objMRSCD1.Id,PTRF__c=objPTRF.Id,Tech_Geo__c='0.019UM',Customer_Name__c=acc.Id,Device_Id__c='Device1',Mask_Set_Title_Id__c=String.valueOf(objMST.Id).substring(0,15));
            MRS_Layer_Chip_Association__c objMRSLCA2 = new MRS_Layer_Chip_Association__c(Layer__c=objMRSLA1.Id,Chip__c=objMRSCD2.Id,PTRF__c=objPTRF.Id,Tech_Geo__c='0.019UM',Customer_Name__c=acc.Id,Device_Id__c='Device1',Mask_Set_Title_Id__c=String.valueOf(objMST.Id).substring(0,15));
            MRS_Layer_Chip_Association__c objMRSLCA3 = new MRS_Layer_Chip_Association__c(Layer__c=objMRSLA2.Id,Chip__c=objMRSCD1.Id,PTRF__c=objPTRF.Id,Tech_Geo__c='0.019UM',Customer_Name__c=acc.Id,Device_Id__c='Device1',Mask_Set_Title_Id__c=String.valueOf(objMST.Id).substring(0,15));
            MRS_Layer_Chip_Association__c objMRSLCA4 = new MRS_Layer_Chip_Association__c(Layer__c=objMRSLA2.Id,Chip__c=objMRSCD2.Id,PTRF__c=objPTRF.Id,Tech_Geo__c='0.019UM',Customer_Name__c=acc.Id,Device_Id__c='Device1',Mask_Set_Title_Id__c=String.valueOf(objMST.Id).substring(0,15));
            MRS_Layer_Chip_Association__c objMRSLCA5 = new MRS_Layer_Chip_Association__c(Layer__c=objMRSLA1.Id,Chip__c=objMRSCD3.Id,PTRF__c=objPTRF.Id,Tech_Geo__c='0.019UM',Customer_Name__c=acc.Id,Device_Id__c='Device1',Mask_Set_Title_Id__c=String.valueOf(objMST.Id).substring(0,15));
            MRS_Layer_Chip_Association__c objMRSLCA6 = new MRS_Layer_Chip_Association__c(Layer__c=objMRSLA2.Id,Chip__c=objMRSCD3.Id,PTRF__c=objPTRF.Id,Tech_Geo__c='0.019UM',Customer_Name__c=acc.Id,Device_Id__c='Device1',Mask_Set_Title_Id__c=String.valueOf(objMST.Id).substring(0,15));
            objMRSLCA1 = createLayerChipData(objMRSLCA1);
            objMRSLCA2 = createLayerChipData(objMRSLCA2);
            objMRSLCA3 = createLayerChipData(objMRSLCA3);
            objMRSLCA4 = createLayerChipData(objMRSLCA4);
            objMRSLCA5 = createLayerChipData(objMRSLCA5);
            objMRSLCA6 = createLayerChipData(objMRSLCA6);
            listMRSLCA.add(objMRSLCA1);
            listMRSLCA.add(objMRSLCA2);
            listMRSLCA.add(objMRSLCA3);
            listMRSLCA.add(objMRSLCA4);
            listMRSLCA.add(objMRSLCA5);
            listMRSLCA.add(objMRSLCA6);
            insert listMRSLCA;
            Test.startTest();
            System.runAs(userSA){
                DRT__c objDRT = new DRT__c(Name='Test DRT');
                insert objDRT;
                ApexPages.currentPage().getHeaders().put('Host','MRS Page');
                ApexPages.currentPage().getParameters().put('jobview','Customer');                 
                //Test.startTest();
                MRSMEBESJobviewExtn controller = new MRSMEBESJobviewExtn (new ApexPages.StandardController(objDRT));
                //system.assertEquals(controller.jobviewName, 'Customer');
                controller.selectedCustomer = acc.Id;
                controller.populateMSTList();
                //system.assertEquals(controller.customerNameAfterSave.toUpperCase(),'TEST REC (TESTREC)');                
                controller.populateMSTList();
                controller.selectedMST = objMST.Id;
                //controller.populateMEBESTable();
                //system.assertEquals(controller.mstAfterSave, null);
                //controller.jobviewName = 'Foundry';
                
                controller.jobviewName = 'MDP';
                controller.populateMEBESTable();
                /*controller.jobviewName = 'TDTI-MPW';
                controller.populateMEBESTable();*/
                /*----------------Wrapper Chip----------*/
               MRSMEBESJobviewExtn.WrapperChip wrpChip = new MRSMEBESJobviewExtn.WrapperChip('Chip001'); 
               List<MRSMEBESJobviewExtn.WrapperChip> lstMainTableData = new List<MRSMEBESJobviewExtn.WrapperChip>();
               lstMainTableData.add(wrpChip);
               String MainTable=JSON.serialize(lstMainTableData);
               controller.mainTableJSON=MainTable;
             /*-------------------WrapperLayerPtrf -------------------*/
               MRSMEBESJobviewExtn.WrapperLayerPtrf wrpLayerPtrf = new MRSMEBESJobviewExtn.WrapperLayerPtrf('1','RXAZ(123)',objPTRF.Name,String.Valueof(objPTRF.Id),'0.019UM'); 
              List<MRSMEBESJobviewExtn.WrapperLayerPtrf> lstsideHeader= new List<MRSMEBESJobviewExtn.WrapperLayerPtrf>();
              lstsideHeader.add(wrpLayerPtrf);       
              String sideHeader=JSON.serialize(lstsideHeader);
              controller.sideHeaderJSON=sideHeader;
              /*--------------WrapperStatusCheck----------------*/
               MRSMEBESJobviewExtn.WrapperStatusCheck wrpStsCheck = new MRSMEBESJobviewExtn.WrapperStatusCheck('CHECKED','READY'); 
              List<MRSMEBESJobviewExtn.WrapperStatusCheck> lstgridTbl= new List<MRSMEBESJobviewExtn.WrapperStatusCheck>();
              lstgridTbl.add(wrpStsCheck );
              String gridTbl=JSON.serialize(lstgridTbl);
              controller.gridTblJSON=gridTbl;
              controller.approvalData();
              controller.jobviewName = 'Global Shuttle';
              controller.approvalData();
              //system.assertEquals(controller.isReleaseComments, false);              
              controller.saveData();
              //system.assertEquals(controller.errorMessage, false);             
              controller.releaseReasonTxt = 'Release Reason';
              controller.isReleaseComments = true;
              controller.saveData(); 
              controller.releaseReasonTxt = 'Release Reason';             
              controller.isReleaseComments = true;
              controller.jobviewName = 'MDP';
              controller.saveData();
              controller.releaseReasonTxt = 'Release Reason';
              controller.isReleaseComments = true;
              controller.jobviewName = 'TDTI-MPW';
              controller.saveData();
              
            }
            Test.stopTest();
        }   
    }
    
    /**
        This test method tests the main big methods of MRSMEBESJobviewExtn class.
        @method name: TestMainMethods2
        @parameter:   none.
        @return :     None.
     **/
     
    public static testMethod void TestMainMethods2TDTIMPW (){
        // comment-out, refactor with testSetup method setup()
          // SwiftDataUtilityTest.customSystemData();
        //Account acc = SwiftDataUtilityTest.createTestAccountForDRT();
        Account acc = getAccount('Test Account 009');
        acc.stage__c = 'Qualified';
        update acc;
        User sysAdminUser = [SELECT Id,Name FROM User WHERE Profile.Name = 'System Administrator' AND isActive = true].get(0);
        /*Profile sysAdminProfile = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
        User userSA = new User(alias = 'testMRS', email='testMRS@test.com',
        emailencodingkey='UTF-8', lastname='testMRSLast', firstname='testMRSFirst', languagelocalekey='en_US',
        localesidkey='en_US', profileid = sysAdminProfile.Id,
        timezonesidkey='America/Los_Angeles', username='testMRS@test.com',communitynickname='testMRS');
        insert userSA; 
        */
        User userSA = [SELECT Id FROM User WHERE Email = 'testMRS@test.com'];
        
        Account_Team_Proxy__c atp = new Account_Team_Proxy__c(User__c = userSA.id,Account__c=acc.id,Account_Access__c='Read/Write',
        Opportunity_Access__c='Read/Write',Team_Role__c='Field Application Engineer',Sequence_No__c='1',Account_Role_ID__c='test1239');       
        insert atp;                
        System.runAs(sysAdminUser){
            Group groupGS = [select Id, DeveloperName, Name from Group where DeveloperName = 'Swift_GlobalShuttle'];
            Group groupSA = [select Id, DeveloperName, Name from Group where DeveloperName = 'SWIFT_Admin'];
            Group groupFJ = [select Id, DeveloperName, Name from Group where DeveloperName = 'Swift_Foundry_Jobviewer'];
            List<GroupMember> listGM = new List<GroupMember>(); 
            GroupMember groupMemberSA = new GroupMember(GroupId = groupSA.Id,UserOrGroupId = userSA.Id);
            GroupMember groupMemberGS = new GroupMember(GroupId = groupGS.Id,UserOrGroupId = userSA.Id);   
            GroupMember groupMemberFJ = new GroupMember(GroupId = groupFJ.Id,UserOrGroupId = userSA.Id);       
            listGM.add(groupMemberSA);
            listGM.add(groupMemberGS);
            listGM.add(groupMemberFJ);
            insert listGM;
            //Mask_Set_Title__c objMST = SwiftDataUtilityTest.createMST('MPW001');
            //insert objMST;
            Mask_Set_Title__c objMST = [SELECT Id, Name FROM Mask_Set_Title__c LIMIT 1];
            PTRF__c objPTRF = new PTRF__c(Name ='PTRF1',Order_Type__c ='Test Order Type',Recticle_Type__c ='Multi Node Reticle (MNR)',MaskSetTitle__c=objMST.Id,Customer__c=acc.id, Prime_Tapeout__c = true ,Prime_GDSOUT_Review__c=true,Status__c='Perform Tapeout Options',Device_Id__c='Dev1234');
            insert objPTRF;
            List<PTRF_JobViewer_Info__c> listPTRFJVI = new List<PTRF_JobViewer_Info__c>();
            PTRF_JobViewer_Info__c objPTRFJVC = new PTRF_JobViewer_Info__c(Name='SAC',PTRF__c=objPTRF.Id,Jobview__c='Customer',Jobview_Type__c='Frame Mockup;Prime GDSOUT Review;MEBES Jobview',User__c=userSA.Id);
            PTRF_JobViewer_Info__c objPTRFJVF = new PTRF_JobViewer_Info__c(Name='SAF',PTRF__c=objPTRF.Id,Jobview__c='Foundry',Jobview_Type__c='Frame Mockup;Prime GDSOUT Review;MEBES Jobview',User__c=userSA.Id);
            //PTRF_JobViewer_Info__c objPTRFJVCust = new PTRF_JobViewer_Info__c(Name='SACust',PTRF__c=objPTRF.Id,Jobview__c='Customer',Jobview_Type__c='Frame Mockup;Prime GDSOUT Review;MEBES Jobview',User__c=listCon.get(0).Id);
            listPTRFJVI.add(objPTRFJVC);
            listPTRFJVI.add(objPTRFJVF);
            //listPTRFJVI.add(objPTRFJVCust);
            insert listPTRFJVI;
            //MRS__c objMRS = new MRS__c(Mask_Set_Title__c=objMST.Id);
            //insert objMRS;
            MRS__c objMRS = [SELECT Id, Mask_Set_Title__c FROM MRS__c LIMIT 1];
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
            MRS_Layer_Chip_Association__c objMRSLCA1 = new MRS_Layer_Chip_Association__c(Layer__c=objMRSLA1.Id,Chip__c=objMRSCD1.Id,PTRF__c=objPTRF.Id,Tech_Geo__c='0.019UM',Customer_Name__c=acc.Id,Device_Id__c='Device1',Mask_Set_Title_Id__c=String.valueOf(objMST.Id).substring(0,15));
            MRS_Layer_Chip_Association__c objMRSLCA2 = new MRS_Layer_Chip_Association__c(Layer__c=objMRSLA1.Id,Chip__c=objMRSCD2.Id,PTRF__c=objPTRF.Id,Tech_Geo__c='0.019UM',Customer_Name__c=acc.Id,Device_Id__c='Device1',Mask_Set_Title_Id__c=String.valueOf(objMST.Id).substring(0,15));
            MRS_Layer_Chip_Association__c objMRSLCA3 = new MRS_Layer_Chip_Association__c(Layer__c=objMRSLA2.Id,Chip__c=objMRSCD1.Id,PTRF__c=objPTRF.Id,Tech_Geo__c='0.019UM',Customer_Name__c=acc.Id,Device_Id__c='Device1',Mask_Set_Title_Id__c=String.valueOf(objMST.Id).substring(0,15));
            MRS_Layer_Chip_Association__c objMRSLCA4 = new MRS_Layer_Chip_Association__c(Layer__c=objMRSLA2.Id,Chip__c=objMRSCD2.Id,PTRF__c=objPTRF.Id,Tech_Geo__c='0.019UM',Customer_Name__c=acc.Id,Device_Id__c='Device1',Mask_Set_Title_Id__c=String.valueOf(objMST.Id).substring(0,15));
            MRS_Layer_Chip_Association__c objMRSLCA5 = new MRS_Layer_Chip_Association__c(Layer__c=objMRSLA1.Id,Chip__c=objMRSCD3.Id,PTRF__c=objPTRF.Id,Tech_Geo__c='0.019UM',Customer_Name__c=acc.Id,Device_Id__c='Device1',Mask_Set_Title_Id__c=String.valueOf(objMST.Id).substring(0,15));
            MRS_Layer_Chip_Association__c objMRSLCA6 = new MRS_Layer_Chip_Association__c(Layer__c=objMRSLA2.Id,Chip__c=objMRSCD3.Id,PTRF__c=objPTRF.Id,Tech_Geo__c='0.019UM',Customer_Name__c=acc.Id,Device_Id__c='Device1',Mask_Set_Title_Id__c=String.valueOf(objMST.Id).substring(0,15));
            objMRSLCA1 = createLayerChipData(objMRSLCA1);
            objMRSLCA2 = createLayerChipData(objMRSLCA2);
            objMRSLCA3 = createLayerChipData(objMRSLCA3);
            objMRSLCA4 = createLayerChipData(objMRSLCA4);
            objMRSLCA5 = createLayerChipData(objMRSLCA5);
            objMRSLCA6 = createLayerChipData(objMRSLCA6);
            listMRSLCA.add(objMRSLCA1);
            listMRSLCA.add(objMRSLCA2);
            listMRSLCA.add(objMRSLCA3);
            listMRSLCA.add(objMRSLCA4);
            listMRSLCA.add(objMRSLCA5);
            listMRSLCA.add(objMRSLCA6);
            insert listMRSLCA;
            Test.startTest();
            System.runAs(userSA){
                DRT__c objDRT = new DRT__c(Name='Test DRT');
                insert objDRT;
                ApexPages.currentPage().getHeaders().put('Host','MRS Page');
                ApexPages.currentPage().getParameters().put('jobview','Customer');                 
                //Test.startTest();
                MRSMEBESJobviewExtn controller = new MRSMEBESJobviewExtn (new ApexPages.StandardController(objDRT));
                //system.assertEquals(controller.jobviewName, 'Customer');
                controller.selectedCustomer = acc.Id;
                controller.populateMSTList();
                //system.assertEquals(controller.customerNameAfterSave.toUpperCase(),'TEST REC (TESTREC)');                
                controller.populateMSTList();
                controller.selectedMST = objMST.Id;
                //controller.populateMEBESTable();
                //system.assertEquals(controller.mstAfterSave, null);
                //controller.jobviewName = 'Foundry';
                
                controller.jobviewName = 'TDTI-MPW';
                controller.populateMEBESTable();
                /*----------------Wrapper Chip----------*/
               MRSMEBESJobviewExtn.WrapperChip wrpChip = new MRSMEBESJobviewExtn.WrapperChip('Chip001'); 
               List<MRSMEBESJobviewExtn.WrapperChip> lstMainTableData = new List<MRSMEBESJobviewExtn.WrapperChip>();
               lstMainTableData.add(wrpChip);
               String MainTable=JSON.serialize(lstMainTableData);
               controller.mainTableJSON=MainTable;
             /*-------------------WrapperLayerPtrf -------------------*/
               MRSMEBESJobviewExtn.WrapperLayerPtrf wrpLayerPtrf = new MRSMEBESJobviewExtn.WrapperLayerPtrf('1','RXAZ(123)',objPTRF.Name,String.Valueof(objPTRF.Id),'0.019UM'); 
              List<MRSMEBESJobviewExtn.WrapperLayerPtrf> lstsideHeader= new List<MRSMEBESJobviewExtn.WrapperLayerPtrf>();
              lstsideHeader.add(wrpLayerPtrf);       
              String sideHeader=JSON.serialize(lstsideHeader);
              controller.sideHeaderJSON=sideHeader;
              /*--------------WrapperStatusCheck----------------*/
               MRSMEBESJobviewExtn.WrapperStatusCheck wrpStsCheck = new MRSMEBESJobviewExtn.WrapperStatusCheck('CHECKED','READY'); 
              List<MRSMEBESJobviewExtn.WrapperStatusCheck> lstgridTbl= new List<MRSMEBESJobviewExtn.WrapperStatusCheck>();
              lstgridTbl.add(wrpStsCheck );
              String gridTbl=JSON.serialize(lstgridTbl);
              controller.gridTblJSON=gridTbl;
              controller.approvalData();
              controller.jobviewName = 'Global Shuttle';
              controller.approvalData();
              //system.assertEquals(controller.isReleaseComments, false);              
              controller.saveData();
              //system.assertEquals(controller.errorMessage, false);             
              controller.releaseReasonTxt = 'Release Reason';
              controller.isReleaseComments = true;
              controller.saveData(); 
              controller.releaseReasonTxt = 'Release Reason';             
              controller.isReleaseComments = true;
              controller.jobviewName = 'MDP';
              controller.saveData();
              controller.releaseReasonTxt = 'Release Reason';
              controller.isReleaseComments = true;
              controller.jobviewName = 'TDTI-MPW';
              controller.saveData();
              
            }
            Test.stopTest();
        }   
    }
    
    private static Account getAccount(string AccountName) {
    
        Account acct = [SELECT Id, Name FROM Account Where Name =: AccountName];
        
        return acct;
    }
}