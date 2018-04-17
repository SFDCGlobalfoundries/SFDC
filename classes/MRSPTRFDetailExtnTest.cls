/*
    Author: Cognizant
    Description: Apex test class for MRSPTRFDetailExtn class
    History: 
    Cognizant      15/05/2014    - Apex code created
*/
@istest(SeeAllData=False)
public class MRSPTRFDetailExtnTest {
	
	/**
	This method initialize data using throughout this test class.
	The create data method are: 
	- SwiftDataUtilityTest.customSystemData();
	@author		SWIFT TEAM
	@since		7-April-2015
	*/
	@testSetup static void setup() {
		SwiftDataUtilityTest.customSystemData();
	}
     
    
    /**
        This test method tests all the main method of MRSPTRFDetailExtn class.
        @method name: PTRFDetailExtnTest
        @parameter:   none.
        @return :     None.
     **/
     
     static testmethod void PTRFDetailExtnTest(){        
        PTRF__c objPTRF;
        list<User> listUser = new list<User>();
        Profile sysAdminProfile = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
        Profile stdUserProfile = [SELECT Id FROM Profile WHERE Name='Standard User'];
        UserRole usrRole=[SELECT Id FROM UserRole WHERE Name = 'GLOBALFOUNDRIES Corporate'];
        User userSA = new User(alias = 'testMRS', email='testMRS@test.com',
        emailencodingkey='UTF-8', lastname='testMRSLast', firstname='testMRSFirst', languagelocalekey='en_US',
        localesidkey='en_US', profileid = sysAdminProfile.Id, UserRoleId = usrRole.Id,
        timezonesidkey='America/Los_Angeles', username='testMRS@test.com',communitynickname='testMRS');
        User userSU = new User(alias = 'testMRS2', email='testMRS2@test.com',
        emailencodingkey='UTF-8', lastname='testMRS2Last', firstname='testMRS2First', languagelocalekey='en_US',
        localesidkey='en_US', profileid = stdUserProfile.Id, UserRoleId = usrRole.Id,
        timezonesidkey='America/Los_Angeles', username='testMRS2@test.com',communitynickname='testMRS2');   
        listUser.add(userSA);
        listUser.add(userSU); 
        insert listUser;   

        
        
        system.runAs(userSA){
            //Adding Environment Variable custom settings
            /*
            list<environment_variable__c> lstEV = new list<environment_variable__c>();
            lstEV.add(new environment_variable__c(Name='SWIFT_MRS_PTRF_EndPoint',Value__c='www.test.globalfoundries.com'));
            lstEV.add(new environment_variable__c(Name='SWIFT_MRS_PTRF_OnOff',Value__c='ON'));
            insert lstEV;
            */
            objPTRF = new PTRF__c();
            
            objPTRF.Name = 'PTRF 1';
            objPTRF.Order_Type__c = 'Test Order Type';
            objPTRF.Recticle_Type__c = 'Single Layer Reticle (SLR)';
            insert objPTRF;
            ApexPages.currentPage().getHeaders().put('Host', 'test');
            ApexPages.currentPage().getParameters().put('ptrfURL',objPTRF.Id);
            MRSPTRFDetailExtn controller = new MRSPTRFDetailExtn (new ApexPages.StandardController(objPTRF));
            //String nextPage=controller.redirectToPage().getURL(); 
            System.assertEquals(controller.ptrfUrl, objPTRF.Id);
            System.assertEquals(controller.isPTRFAccess, true);
            pagereference pg=controller.redirectToPage();
            Test.setcurrentPage(pg);
            // first test without parameter 
        }
        test.startTest();
        system.runAs(userSU){
            MRSPTRFDetailExtn controller = new MRSPTRFDetailExtn (new ApexPages.StandardController(objPTRF)); 
            System.assertEquals(controller.isPTRFAccess, false);  
        }
        test.stopTest();
     }
     
     /**
        This test method tests all the minor triggers of this project.
        @method name: testingMinorTriggers
        @parameter:   none.
        @return :     None.
     **/
     
     static testmethod void testingMinorTriggers(){ 
        Profile sysAdminProfile = [SELECT Id FROM Profile WHERE Name='System Administrator'];   
        User userSA = new User(alias = 'testMRS', email='testMRS@test.com',
        emailencodingkey='UTF-8', lastname='testMRSLast', firstname='testMRSFirst', languagelocalekey='en_US',
        localesidkey='en_US', profileid = sysAdminProfile.Id,
        timezonesidkey='America/Los_Angeles', username='testMRS@test.com',communitynickname='testMRS');
        insert userSA;
        //Adding Environment Variable custom settings
        /*
        list<environment_variable__c> lstEV = new list<environment_variable__c>();
        lstEV.add(new environment_variable__c(Name='SWIFT_MRS_PTRF_EndPoint',Value__c='www.test.globalfoundries.com'));
        lstEV.add(new environment_variable__c(Name='SWIFT_MRS_PTRF_OnOff',Value__c='ON'));
        insert lstEV;
        */
        system.runAs(userSA){
            MRS_Invalid_Email_Extension__c obj = new MRS_Invalid_Email_Extension__c();
            obj.Name = 'yahoo.com';
            insert obj;
            Fab_Distribution_Table__c objFab = new Fab_Distribution_Table__c(Fab_No__c='Fab1',Distribution_List__c='test@yahoo.com');
            try{
                insert objFab;
            }catch(Exception ex){} 
            Fab_Distribution_Table__c objFab2 = new Fab_Distribution_Table__c(Fab_No__c='Fab1',Distribution_List__c='test@gmail.com'); 
            insert objFab2;
            system.assertEquals(objFab2.Fab_No__c, 'Fab1');
            Fab_Distribution_Table__c objFab3 = new Fab_Distribution_Table__c(Fab_No__c='Fab1',Distribution_List__c='test@gmail.com'); 
            try{
                insert objFab3;
            }catch(Exception ex){}
            objFab2.Distribution_List__c='test@yahoo.com';
            try{
                update objFab2;
            }catch(Exception ex){} 
            objFab2.Distribution_List__c='test@gmail.com';
            objFab2.Fab_No__c='Fab2';
            try{
                update objFab2;
            }catch(Exception ex){}
            Maskshop_Configuration__c objMC = new Maskshop_Configuration__c(Name='MC001');
            insert objMC;
            Maskshop_Configuration__c objMC2 = new Maskshop_Configuration__c(Name='MC001');
            try{
                insert objMC2; 
            }catch(Exception ex){}
            objMC2.Name = 'MC002';
            insert objMC2;
            system.assertEquals(objMC2.Name, 'MC002');
            objMC.Name = 'MC002';
            try{
                update objMC; 
            }catch(Exception ex){}
            Released_Mask_Write_Distribution_List__c objRMWDL = new Released_Mask_Write_Distribution_List__c(Maskshop__c=objMC2.Id,Distribution_List__c='test@yahoo.com');
            try{
                insert objRMWDL;
            }catch(Exception ex){}
            objRMWDL.Distribution_List__c='test@gmail.com';
            insert objRMWDL;
            system.assertEquals(objRMWDL.Maskshop__c, objMC2.Id);
            objRMWDL.Distribution_List__c='test@yahoo.com'; 
            try{
                update objRMWDL; 
            }catch(Exception ex){}
            test.startTest();
            Mask_Set_Title__c objMST = SwiftDataUtilityTest.createMST('MST001');
            insert objMST;
            PTRF__c objPTRF = new PTRF__c(Name='PTRF1',Status__c='Perform Tapeout Options',Order_Type__c='Test Order Type',Recticle_Type__c='Single Layer Reticle (SLR)',MaskSetTitle__c=objMST.Id);
            insert objPTRF; 
            List<DRT__c> listDRT = new List<DRT__c>();
            DRT__c objDRT = new DRT__c(Name='DRT1',Type__c='Prime');
            DRT__c objDRT2 = new DRT__c(Name='DRT2',Type__c='Frame');
            listDRT.add(objDRT);
            listDRT.add(objDRT2);
            insert listDRT;
            DRT_PTRF_Association__c objDRTPTRF = new DRT_PTRF_Association__c(PTRF__c=objPTRF.Id,DRT__c=objDRT.Id,Synced_with_Oracle_DB__c=false);
            insert objDRTPTRF;
            DRT_PTRF_Association__c objDRTPTRF2 = new DRT_PTRF_Association__c(PTRF__c=objPTRF.Id,DRT__c=objDRT2.Id,Synced_with_Oracle_DB__c=false);
            insert objDRTPTRF2;
            List<DRT_PTRF_Association__c> listDRTPTRF = new List<DRT_PTRF_Association__c>();
            objDRTPTRF2.Synced_with_Oracle_DB__c = true;
            objDRTPTRF2.DRT__c=objDRT.Id;
            objDRTPTRF.DRT__c=objDRT2.Id;
            listDRTPTRF.add(objDRTPTRF);
            listDRTPTRF.add(objDRTPTRF2);
            try{
                update listDRTPTRF;
            }catch(Exception ex){}
            try{
                delete objDRTPTRF;
            }catch(Exception ex){}
            objPTRF.Status__c='Active';
            update objPTRF;
            objPTRF.Prime_TapeOut__c=true;
            objPTRF.Frame_TapeOut__c=true;
            objPTRF.Status__c='Perform Tapeout Options';
            update objPTRF;
            objPTRF.Status__c='Cancel';
            objPTRF.Prime_TapeOut__c=false;
            objPTRF.Frame_TapeOut__c=false;
            objPTRF.DRC_DRW_Status__c='Cancelled DRC DRW';
            // comment-out, refactor with testSetup method setup()
			// SwiftDataUtilityTest.customSystemData();
            update objPTRF;
            objPTRF.Status__c='Closed';
            update objPTRF;
            test.stopTest();
        }
     }
     
     /**
        This test method tests all the other triggers of this project.
        @method name: testingOtherTriggers
        @parameter:   none.
        @return :     None.
     **/
     
     static testmethod void testingOtherTriggers(){ 
        Profile sysAdminProfile = [SELECT Id FROM Profile WHERE Name='System Administrator'];   
        User userSA = new User(alias = 'testMRS', email='testMRS@test.com',
        emailencodingkey='UTF-8', lastname='testMRSLast', firstname='testMRSFirst', languagelocalekey='en_US',
        localesidkey='en_US', profileid = sysAdminProfile.Id,
        timezonesidkey='America/Los_Angeles', username='testMRS@test.com',communitynickname='testMRS');
        insert userSA;
        //Adding Environment Variable custom settings
        /*
        list<environment_variable__c> lstEV = new list<environment_variable__c>();
        lstEV.add(new environment_variable__c(Name='SWIFT_MRS_PTRF_EndPoint',Value__c='www.test.globalfoundries.com'));
        lstEV.add(new environment_variable__c(Name='SWIFT_MRS_PTRF_OnOff',Value__c='ON'));
        insert lstEV;
        */
        system.runAs(userSA){
            // comment-out, refactor with testSetup method setup()
			// SwiftDataUtilityTest.customSystemData();
            Account acc = SwiftDataUtilityTest.createTestAccount();
            test.startTest();
            Mask_Set_Title__c objMST = SwiftDataUtilityTest.createMST('MST001');
            insert objMST;
            PTRF__c objPTRF = new PTRF__c(Name ='PTRF1',Order_Type__c ='Test Order Type',Recticle_Type__c ='Single Layer Reticle (SLR)',MaskSetTitle__c=objMST.Id,Customer__c=acc.id);
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
            MRS_Layer_Association__c objMRSLA2 = new MRS_Layer_Association__c(MRS__c=objMRS.Id,Layer_Status__c='Ready',Name='RY',Mask_Layer_Rev__c='AZ',ROM_Code__c=null);
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
            MRS_Layer_Chip_Association__c objMRSLCA1 = new MRS_Layer_Chip_Association__c(Layer__c=objMRSLA1.Id,Chip__c=objMRSCD1.Id,PTRF__c=objPTRF.Id,Foundry_Frame_Mockup__c='Approve',Tech_Geo__c='0.019UM',Customer_Frame_Mockup__c='Not Ready',Layer_Chip_Status__c='In Progress');
            MRS_Layer_Chip_Association__c objMRSLCA2 = new MRS_Layer_Chip_Association__c(Layer__c=objMRSLA1.Id,Chip__c=objMRSCD2.Id,PTRF__c=objPTRF.Id,Foundry_Frame_Mockup__c='Approve',Tech_Geo__c='0.019UM',Layer_Chip_Status__c='In Progress');
            MRS_Layer_Chip_Association__c objMRSLCA3 = new MRS_Layer_Chip_Association__c(Layer__c=objMRSLA2.Id,Chip__c=objMRSCD1.Id,PTRF__c=objPTRF.Id,Foundry_Frame_Mockup__c='Approve',Tech_Geo__c='0.019UM',Layer_Chip_Status__c='In Progress');
            MRS_Layer_Chip_Association__c objMRSLCA4 = new MRS_Layer_Chip_Association__c(Layer__c=objMRSLA2.Id,Chip__c=objMRSCD2.Id,PTRF__c=objPTRF.Id,Foundry_Frame_Mockup__c='Approve',Tech_Geo__c='0.019UM',Layer_Chip_Status__c='In Progress');
            MRS_Layer_Chip_Association__c objMRSLCA5 = new MRS_Layer_Chip_Association__c(Layer__c=objMRSLA1.Id,Chip__c=objMRSCD3.Id,PTRF__c=objPTRF.Id,Foundry_Frame_Mockup__c='Approve',Tech_Geo__c='0.019UM',Layer_Chip_Status__c='In Progress');
            MRS_Layer_Chip_Association__c objMRSLCA6 = new MRS_Layer_Chip_Association__c(Layer__c=objMRSLA2.Id,Chip__c=objMRSCD3.Id,PTRF__c=objPTRF.Id,Foundry_Frame_Mockup__c='Approve',Tech_Geo__c='0.019UM',Layer_Chip_Status__c='In Progress');
            listMRSLCA.add(objMRSLCA1);
            listMRSLCA.add(objMRSLCA2);
            listMRSLCA.add(objMRSLCA3);
            listMRSLCA.add(objMRSLCA4);
            listMRSLCA.add(objMRSLCA5);
            listMRSLCA.add(objMRSLCA6);
            insert listMRSLCA;             
            update objMRSLCA1;                                                        
            test.stopTest();
        }
     }
     
     /**
        This test method tests all the other triggers continued of this project.
        @method name: testingOtherTriggers2
        @parameter:   none.
        @return :     None.
     **/
     
     static testmethod void testingOtherTriggers2(){ 
        Profile sysAdminProfile = [SELECT Id FROM Profile WHERE Name='System Administrator'];   
        User userSA = new User(alias = 'testMRS', email='testMRS@test.com',
        emailencodingkey='UTF-8', lastname='testMRSLast', firstname='testMRSFirst', languagelocalekey='en_US',
        localesidkey='en_US', profileid = sysAdminProfile.Id,
        timezonesidkey='America/Los_Angeles', username='testMRS@test.com',communitynickname='testMRS');
        insert userSA;
        //Adding Environment Variable custom settings
        /*
        list<environment_variable__c> lstEV = new list<environment_variable__c>();
        lstEV.add(new environment_variable__c(Name='SWIFT_MRS_PTRF_EndPoint',Value__c='www.test.globalfoundries.com'));
        lstEV.add(new environment_variable__c(Name='SWIFT_MRS_PTRF_OnOff',Value__c='ON'));
        insert lstEV;
        */
        system.runAs(userSA){
            // comment-out, refactor with testSetup method setup()
			// SwiftDataUtilityTest.customSystemData();
            Account acc = SwiftDataUtilityTest.createTestAccount();
            test.startTest();
            Mask_Set_Title__c objMST = SwiftDataUtilityTest.createMST('MST001');
            insert objMST;
            PTRF__c objPTRF = new PTRF__c(Name ='PTRF1',Order_Type__c ='Test Order Type',Recticle_Type__c ='Single Layer Reticle (SLR)',MaskSetTitle__c=objMST.Id,Customer__c=acc.id);
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
            MRS_Layer_Association__c objMRSLA2 = new MRS_Layer_Association__c(MRS__c=objMRS.Id,Layer_Status__c='Ready',Name='RY',Mask_Layer_Rev__c='AZ',ROM_Code__c=null);
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
            MRS_Layer_Chip_Association__c objMRSLCA1 = new MRS_Layer_Chip_Association__c(Layer__c=objMRSLA1.Id,Chip__c=objMRSCD1.Id,PTRF__c=objPTRF.Id,Foundry_Frame_Mockup__c='Approve',Tech_Geo__c='0.019UM',Customer_Frame_Mockup__c='Not Ready',Layer_Chip_Status__c='In Progress');
            MRS_Layer_Chip_Association__c objMRSLCA2 = new MRS_Layer_Chip_Association__c(Layer__c=objMRSLA1.Id,Chip__c=objMRSCD2.Id,PTRF__c=objPTRF.Id,Foundry_Frame_Mockup__c='Approve',Tech_Geo__c='0.019UM',Layer_Chip_Status__c='In Progress');
            MRS_Layer_Chip_Association__c objMRSLCA3 = new MRS_Layer_Chip_Association__c(Layer__c=objMRSLA2.Id,Chip__c=objMRSCD1.Id,PTRF__c=objPTRF.Id,Foundry_Frame_Mockup__c='Approve',Tech_Geo__c='0.019UM',Layer_Chip_Status__c='In Progress');
            MRS_Layer_Chip_Association__c objMRSLCA4 = new MRS_Layer_Chip_Association__c(Layer__c=objMRSLA2.Id,Chip__c=objMRSCD2.Id,PTRF__c=objPTRF.Id,Foundry_Frame_Mockup__c='Approve',Tech_Geo__c='0.019UM',Layer_Chip_Status__c='In Progress');
            MRS_Layer_Chip_Association__c objMRSLCA5 = new MRS_Layer_Chip_Association__c(Layer__c=objMRSLA1.Id,Chip__c=objMRSCD3.Id,PTRF__c=objPTRF.Id,Foundry_Frame_Mockup__c='Approve',Tech_Geo__c='0.019UM',Layer_Chip_Status__c='In Progress');
            MRS_Layer_Chip_Association__c objMRSLCA6 = new MRS_Layer_Chip_Association__c(Layer__c=objMRSLA2.Id,Chip__c=objMRSCD3.Id,PTRF__c=objPTRF.Id,Foundry_Frame_Mockup__c='Approve',Tech_Geo__c='0.019UM',Layer_Chip_Status__c='In Progress');
            listMRSLCA.add(objMRSLCA1);
            listMRSLCA.add(objMRSLCA2);
            listMRSLCA.add(objMRSLCA3);
            listMRSLCA.add(objMRSLCA4);
            listMRSLCA.add(objMRSLCA5);
            listMRSLCA.add(objMRSLCA6);
            insert listMRSLCA; 
            objMRSLCA1.Layer_Chip_Status__c='Void';
            update objMRSLCA1;                                                        
            test.stopTest();
        }
     }
     
     /**
        This test method tests all the other triggers continued of this project.
        @method name: testingOtherTriggers3
        @parameter:   none.
        @return :     None.
     **/
     
     static testmethod void testingOtherTriggers3(){ 
        Profile sysAdminProfile = [SELECT Id FROM Profile WHERE Name='System Administrator'];   
        User userSA = new User(alias = 'testMRS', email='testMRS@test.com',
        emailencodingkey='UTF-8', lastname='testMRSLast', firstname='testMRSFirst', languagelocalekey='en_US',
        localesidkey='en_US', profileid = sysAdminProfile.Id,
        timezonesidkey='America/Los_Angeles', username='testMRS@test.com',communitynickname='testMRS');
        insert userSA;
        //Adding Environment Variable custom settings
        /*
        list<environment_variable__c> lstEV = new list<environment_variable__c>();
        lstEV.add(new environment_variable__c(Name='SWIFT_MRS_PTRF_EndPoint',Value__c='www.test.globalfoundries.com'));
        lstEV.add(new environment_variable__c(Name='SWIFT_MRS_PTRF_OnOff',Value__c='ON'));
        insert lstEV;
        */
        system.runAs(userSA){
            // comment-out, refactor with testSetup method setup()
			// SwiftDataUtilityTest.customSystemData();
            Account acc = SwiftDataUtilityTest.createTestAccount();
            test.startTest();
            Mask_Set_Title__c objMST = SwiftDataUtilityTest.createMST('MST001');
            insert objMST;
            PTRF__c objPTRF = new PTRF__c(Name ='PTRF1',Order_Type__c ='Test Order Type',Recticle_Type__c ='Single Layer Reticle (SLR)',MaskSetTitle__c=objMST.Id,Customer__c=acc.id);
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
            MRS_Layer_Association__c objMRSLA2 = new MRS_Layer_Association__c(MRS__c=objMRS.Id,Layer_Status__c='Ready',Name='RY',Mask_Layer_Rev__c='AZ',ROM_Code__c=null);
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
            MRS_Layer_Chip_Association__c objMRSLCA1 = new MRS_Layer_Chip_Association__c(Layer__c=objMRSLA1.Id,Chip__c=objMRSCD1.Id,PTRF__c=objPTRF.Id,Foundry_Frame_Mockup__c='Approve',Tech_Geo__c='0.019UM',Customer_Frame_Mockup__c='Not Ready',Layer_Chip_Status__c='In Progress');
            MRS_Layer_Chip_Association__c objMRSLCA2 = new MRS_Layer_Chip_Association__c(Layer__c=objMRSLA1.Id,Chip__c=objMRSCD2.Id,PTRF__c=objPTRF.Id,Foundry_Frame_Mockup__c='Approve',Tech_Geo__c='0.019UM',Layer_Chip_Status__c='In Progress');
            MRS_Layer_Chip_Association__c objMRSLCA3 = new MRS_Layer_Chip_Association__c(Layer__c=objMRSLA2.Id,Chip__c=objMRSCD1.Id,PTRF__c=objPTRF.Id,Foundry_Frame_Mockup__c='Approve',Tech_Geo__c='0.019UM',Layer_Chip_Status__c='In Progress');
            MRS_Layer_Chip_Association__c objMRSLCA4 = new MRS_Layer_Chip_Association__c(Layer__c=objMRSLA2.Id,Chip__c=objMRSCD2.Id,PTRF__c=objPTRF.Id,Foundry_Frame_Mockup__c='Approve',Tech_Geo__c='0.019UM',Layer_Chip_Status__c='In Progress');
            MRS_Layer_Chip_Association__c objMRSLCA5 = new MRS_Layer_Chip_Association__c(Layer__c=objMRSLA1.Id,Chip__c=objMRSCD3.Id,PTRF__c=objPTRF.Id,Foundry_Frame_Mockup__c='Approve',Tech_Geo__c='0.019UM',Layer_Chip_Status__c='In Progress');
            MRS_Layer_Chip_Association__c objMRSLCA6 = new MRS_Layer_Chip_Association__c(Layer__c=objMRSLA2.Id,Chip__c=objMRSCD3.Id,PTRF__c=objPTRF.Id,Foundry_Frame_Mockup__c='Approve',Tech_Geo__c='0.019UM',Layer_Chip_Status__c='In Progress');
            listMRSLCA.add(objMRSLCA1);
            listMRSLCA.add(objMRSLCA2);
            listMRSLCA.add(objMRSLCA3);
            listMRSLCA.add(objMRSLCA4);
            listMRSLCA.add(objMRSLCA5);
            listMRSLCA.add(objMRSLCA6);
            insert listMRSLCA; 
            objMRSLCA1.Customer_Frame_Mockup__c='Ready';
            update objMRSLCA1;                                                        
            test.stopTest();
        }
     }
     
     /**
        This test method tests all the other triggers continued of this project.
        @method name: testingOtherTriggers4
        @parameter:   none.
        @return :     None.
     **/
     
     static testmethod void testingOtherTriggers4(){ 
        Profile sysAdminProfile = [SELECT Id FROM Profile WHERE Name='System Administrator'];   
        User userSA = new User(alias = 'testMRS', email='testMRS@test.com',
        emailencodingkey='UTF-8', lastname='testMRSLast', firstname='testMRSFirst', languagelocalekey='en_US',
        localesidkey='en_US', profileid = sysAdminProfile.Id,
        timezonesidkey='America/Los_Angeles', username='testMRS@test.com',communitynickname='testMRS');
        insert userSA;
        //Adding Environment Variable custom settings
        /*
        list<environment_variable__c> lstEV = new list<environment_variable__c>();
        lstEV.add(new environment_variable__c(Name='SWIFT_MRS_PTRF_EndPoint',Value__c='www.test.globalfoundries.com'));
        lstEV.add(new environment_variable__c(Name='SWIFT_MRS_PTRF_OnOff',Value__c='ON'));
        insert lstEV;
        */
        system.runAs(userSA){
            // comment-out, refactor with testSetup method setup()
			// SwiftDataUtilityTest.customSystemData();
            Account acc = SwiftDataUtilityTest.createTestAccount();
            test.startTest();
            Mask_Set_Title__c objMST = SwiftDataUtilityTest.createMST('MST001');
            insert objMST;
            PTRF__c objPTRF = new PTRF__c(Name ='PTRF1',Order_Type__c ='Test Order Type',Recticle_Type__c ='Single Layer Reticle (SLR)',MaskSetTitle__c=objMST.Id,Customer__c=acc.id);
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
            MRS_Layer_Association__c objMRSLA2 = new MRS_Layer_Association__c(MRS__c=objMRS.Id,Layer_Status__c='Ready',Name='RY',Mask_Layer_Rev__c='AZ',ROM_Code__c=null);
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
            MRS_Layer_Chip_Association__c objMRSLCA1 = new MRS_Layer_Chip_Association__c(Layer__c=objMRSLA1.Id,Chip__c=objMRSCD1.Id,PTRF__c=objPTRF.Id,Foundry_Frame_Mockup__c='Approve',Tech_Geo__c='0.019UM',Customer_Frame_Mockup__c='Not Ready',Layer_Chip_Status__c='In Progress');
            MRS_Layer_Chip_Association__c objMRSLCA2 = new MRS_Layer_Chip_Association__c(Layer__c=objMRSLA1.Id,Chip__c=objMRSCD2.Id,PTRF__c=objPTRF.Id,Foundry_Frame_Mockup__c='Approve',Tech_Geo__c='0.019UM',Layer_Chip_Status__c='In Progress');
            MRS_Layer_Chip_Association__c objMRSLCA3 = new MRS_Layer_Chip_Association__c(Layer__c=objMRSLA2.Id,Chip__c=objMRSCD1.Id,PTRF__c=objPTRF.Id,Foundry_Frame_Mockup__c='Approve',Tech_Geo__c='0.019UM',Layer_Chip_Status__c='In Progress');
            MRS_Layer_Chip_Association__c objMRSLCA4 = new MRS_Layer_Chip_Association__c(Layer__c=objMRSLA2.Id,Chip__c=objMRSCD2.Id,PTRF__c=objPTRF.Id,Foundry_Frame_Mockup__c='Approve',Tech_Geo__c='0.019UM',Layer_Chip_Status__c='In Progress');
            MRS_Layer_Chip_Association__c objMRSLCA5 = new MRS_Layer_Chip_Association__c(Layer__c=objMRSLA1.Id,Chip__c=objMRSCD3.Id,PTRF__c=objPTRF.Id,Foundry_Frame_Mockup__c='Approve',Tech_Geo__c='0.019UM',Layer_Chip_Status__c='In Progress');
            MRS_Layer_Chip_Association__c objMRSLCA6 = new MRS_Layer_Chip_Association__c(Layer__c=objMRSLA2.Id,Chip__c=objMRSCD3.Id,PTRF__c=objPTRF.Id,Foundry_Frame_Mockup__c='Approve',Tech_Geo__c='0.019UM',Layer_Chip_Status__c='In Progress');
            listMRSLCA.add(objMRSLCA1);
            listMRSLCA.add(objMRSLCA2);
            listMRSLCA.add(objMRSLCA3);
            listMRSLCA.add(objMRSLCA4);
            listMRSLCA.add(objMRSLCA5);
            listMRSLCA.add(objMRSLCA6);
            insert listMRSLCA; 
            objMRSLCA1.Customer_Frame_Mockup__c='Approve';
            update objMRSLCA1;                                                        
            test.stopTest();
        }
     }
}