@isTest
public class MRSApprovalServiceTest {
    
    @testSetup static void testSetup() {
        DataUtilTest.loadEnvironmentVariables();
    }
    
    @isTest
    private static void testInvalidField(){
        Test.startTest();
        MRSApprovalServiceTest.initTestData();
        MRSApprovalService.MRSApprovalMsg msg = MRSApprovalServiceTest.createValidMsg('','');
        msg.statusType = 'incorrect_field';
        MRSApprovalService.performApproval(msg);
        Test.stopTest();
    }
    
    @isTest
    private static void testTdti(){
        try {MRSApprovalService.performApproval_TDTI_MPW(null);} catch(Exception e) {}
    }
    
    @isTest
    private static void testInvalidSource(){
        Test.startTest();
        
        MRSApprovalServiceTest.initTestData();
        MRSApprovalService.MRSApprovalMsg msg = MRSApprovalServiceTest.createValidMsg('','');
        
        MRSApprovalService.performApproval_MDP(msg);
        
        Test.stopTest();
    }
    
    @isTest
    private static void testUnhandledException(){
        //insert new Environment_Variable__c(Name='SWIFT_MRS_Approval_Testing_Mode', Value__c='ON');
        //insert new Environment_Variable__c(Name='SWIFT_MRS_BYPASS_USER_VALIDATION', Value__c='ON');
        MRSApprovalServiceTest.initTestData();
        
        Test.startTest();
        
        MRSApprovalService.MRSApprovalMsg msg = MRSApprovalServiceTest.createValidMsg(MRSGeneralService.SOURCE_MDP, MRSGeneralService.MDP_MEBES_JOBVIEW);
        msg.messageId   = 'TestUnhandledException';
        
        MRSApprovalService.performApproval_MDP(msg);
        
        Test.stopTest();
    }
    
    @isTest
    private static void testResponseWebservice(){
        Test.setMock(WebServiceMock.class, new MRSMDPServiceResponseMock());
        
        Test.startTest();
        
        MRSMDPResponseService.mdpLayerStatus status = new MRSMDPResponseService.mdpLayerStatus();
        MRSMDPResponseService.mdpLayerStatus[] statuses = new MRSMDPResponseService.mdpLayerStatus[]{status};
        MRSMDPResponseService.MDPMRSResponseService_pt res = new MRSMDPResponseService.MDPMRSResponseService_pt();
        res.process('TEstWS', 'SUCCESS','','PTRF-1234-567', statuses);
        
        Test.stopTest();
    }
    
    @isTest
    private static void testUtils(){
        Test.startTest();
        MRSGeneralService service = new MRSGeneralService();
        service.getFieldMap();
        service.getSourceForApprovalEmail();
        service.getNoteCategory();
        Test.stopTest();
    }
    
    //Utility test methods
    public static void initTestData(){
        Mask_Set_Title__c objMST;
        MRS__c objMRS;
        PTRF__c objPTRF;
        List<MRS_Layer_Association__c> layerList;
        List<MRS_Chip_Details__c> chipList;
        List<MRS_Layer_Chip_Association__c> layerChipList;
    
        RecordType general = [Select Id from RecordType where sObjectType='Email_Config_Settings__c' and Name='General'];
        List<Email_Config_Settings__c> ecsList = new List<Email_Config_Settings__c>();
        ecsList.add(new Email_Config_Settings__c( RecordTypeId=general.ID, TO__c='#Email:test@testemail.com', Source__c = MRSGeneralService.SOURCE_MDP, Email_Template_Name__c= MRSApprovalUtility.SWIFT_WS_Unhandled_Exception, Available_For_Use__c=true) );
        ecsList.add(new Email_Config_Settings__c( RecordTypeId=general.ID, TO__c='#Email:test@testemail.com', Source__c = MRSGeneralService.SOURCE_TDTI_MPW, Email_Template_Name__c= MRSApprovalUtility.SWIFT_WS_Unhandled_Exception, Available_For_Use__c=true) );
        insert ecsList;
        
        User sysAdminUser = [SELECT Id,Name FROM User WHERE Profile.Name = 'System Administrator' AND isActive = true].get(0);
        User userSA;
        System.runAs(sysAdminUser){
            Profile sysAdminProfile = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
            userSA = new User(alias = 'testMRS', email='testMRS@test.com',
            emailencodingkey='UTF-8', lastname='testMRSLast', firstname='testMRSFirst', languagelocalekey='en_US',
            localesidkey='en_US', profileid = sysAdminProfile.Id,
            timezonesidkey='America/Los_Angeles', username='testMRS@test.com',communitynickname='testMRS');
            userSA.HCM_Login_ID__c = 'TestUser123';
            insert userSA;
            
            List<Group> groups = [select Id, developername from Group where developername IN ('Swift_MDP', 'Swift_TDTI_MPW')];
            List<GroupMember> gmList = new List<GroupMember>();
            for(Group g : groups){
                gmList.add( new GroupMember(UserOrGroupId = userSA.ID, GroupId = g.ID) );
            }
            insert gmList;
        }
        
        Account acc = SwiftDataUtilityTest.createTestAccount();
        Account_Team_Proxy__c atp = new Account_Team_Proxy__c(User__c = userSA.id,Account__c=acc.id,Account_Access__c='Read/Write',
        Opportunity_Access__c='Read/Write',Team_Role__c='Primary Customer Service Rep',Sequence_No__c='1',Account_Role_ID__c='test1239');       
        insert atp;
        objMST = SwiftDataUtilityTest.createMST('MPW001');
        insert objMST;
        objPTRF = new PTRF__c(Name ='PTRF1',Tech_Geo_Value__c='0.02',Status__c='Perform Tapeout Options',Order_Type__c ='Test Order Type',Recticle_Type__c ='Single Layer Reticle (SLR)',MaskSetTitle__c=objMST.Id,Customer__c=acc.id,Customer_jobview__c='Gating mask release',Foundry_jobview__c='Gating mask release');
        insert objPTRF;
        
        List<PTRF_JobViewer_Info__c> listPTRFJVI = new List<PTRF_JobViewer_Info__c>();
        PTRF_JobViewer_Info__c objPTRFJVC = new PTRF_JobViewer_Info__c(Name='SAC',PTRF__c=objPTRF.Id,Jobview__c='Customer',Jobview_Type__c='Frame Mockup;Prime GDSOUT Review;MEBES Jobview',User__c=userSA.Id);
        PTRF_JobViewer_Info__c objPTRFJVF = new PTRF_JobViewer_Info__c(Name='SAF',PTRF__c=objPTRF.Id,Jobview__c='Foundry',Jobview_Type__c='Frame Mockup;Prime GDSOUT Review;MEBES Jobview',User__c=userSA.Id);
        listPTRFJVI.add(objPTRFJVC);
        listPTRFJVI.add(objPTRFJVF);
        insert listPTRFJVI;
        objMRS = new MRS__c(Mask_Set_Title__c=objMST.Id);
        insert objMRS;
        layerList = new List<MRS_Layer_Association__c>();
        MRS_Layer_Association__c objMRSLA1 = new MRS_Layer_Association__c(MRS__c=objMRS.Id,Layer_Status__c='Released',Name='RX',Mask_Layer_Rev__c='AZ',ROM_Code__c='123');
        MRS_Layer_Association__c objMRSLA2 = new MRS_Layer_Association__c(MRS__c=objMRS.Id,Layer_Status__c='Ready',Name='RY',Mask_Layer_Rev__c='AZ',ROM_Code__c='123');
        layerList.add(objMRSLA1);
        layerList.add(objMRSLA2);
        insert layerList;   
        chipList = new List<MRS_Chip_Details__c>();
        MRS_Chip_Details__c objMRSCD1 = new MRS_Chip_Details__c(MRS__c=objMRS.Id,Name='Chip001');
        MRS_Chip_Details__c objMRSCD2 = new MRS_Chip_Details__c(MRS__c=objMRS.Id,Name='Chip002');
        MRS_Chip_Details__c objMRSCD3 = new MRS_Chip_Details__c(MRS__c=objMRS.Id,Name='Frame');
        chipList.add(objMRSCD1);
        chipList.add(objMRSCD2);
        chipList.add(objMRSCD3);
        insert chipList;
        layerChipList = new List<MRS_Layer_Chip_Association__c>();
        MRS_Layer_Chip_Association__c objMRSLCA1 = new MRS_Layer_Chip_Association__c(Layer__c=objMRSLA1.Id,Chip__c=objMRSCD1.Id,PTRF__c=objPTRF.Id,Tech_Geo__c='0.019UM',Device_Id__c='1',Layer_Chip_Status__c='In Progress');
        MRS_Layer_Chip_Association__c objMRSLCA2 = new MRS_Layer_Chip_Association__c(Layer__c=objMRSLA1.Id,Chip__c=objMRSCD2.Id,PTRF__c=objPTRF.Id,Tech_Geo__c='0.019UM',Device_Id__c='1',Layer_Chip_Status__c='In Progress');
        MRS_Layer_Chip_Association__c objMRSLCA3 = new MRS_Layer_Chip_Association__c(Layer__c=objMRSLA2.Id,Chip__c=objMRSCD1.Id,PTRF__c=objPTRF.Id,Tech_Geo__c='0.019UM',Device_Id__c='1',Layer_Chip_Status__c='In Progress');
        MRS_Layer_Chip_Association__c objMRSLCA4 = new MRS_Layer_Chip_Association__c(Layer__c=objMRSLA2.Id,Chip__c=objMRSCD2.Id,PTRF__c=objPTRF.Id,Tech_Geo__c='0.019UM',Device_Id__c='1',Layer_Chip_Status__c='In Progress');
        MRS_Layer_Chip_Association__c objMRSLCA5 = new MRS_Layer_Chip_Association__c(Layer__c=objMRSLA1.Id,Chip__c=objMRSCD3.Id,PTRF__c=objPTRF.Id,Tech_Geo__c='0.019UM',Device_Id__c='1',Layer_Chip_Status__c='In Progress');
        MRS_Layer_Chip_Association__c objMRSLCA6 = new MRS_Layer_Chip_Association__c(Layer__c=objMRSLA2.Id,Chip__c=objMRSCD3.Id,PTRF__c=objPTRF.Id,Tech_Geo__c='0.019UM',Device_Id__c='1',Layer_Chip_Status__c='In Progress');
        objMRSLCA1=MRSHandlerUtility.setDRTLayerChipDefaultValues(objMRSLCA1);
        system.assertEquals(objMRSLCA1.Prime_MEBES_Received__c, null);
        layerChipList.add(objMRSLCA1);
        layerChipList.add(objMRSLCA2);
        layerChipList.add(objMRSLCA3);
        layerChipList.add(objMRSLCA4);
        layerChipList.add(objMRSLCA5);
        layerChipList.add(objMRSLCA6);
        //SEt value for jobview fields
        for(MRS_Layer_Chip_Association__c lc : layerChipList){
            lc.MDP_MEBES_Jobview__c             = 'Ready';
            lc.TDTI_MPW_MEBES_Jobview__c        = 'Ready';
            lc.Foundry_MEBES_Jobview__c         = 'Ready';
            lc.Customer_MEBES_Jobview__c        = 'Ready';
        }
        insert layerChipList;
    }
    
    public static MRSApprovalService.MRSApprovalMsg createValidMsg(String source, String statusType){
        MRSApprovalService.MRSApprovalMsg msg = new MRSApprovalService.MRSApprovalMsg();
        msg.messageId       = System.now().format().replaceAll(' ','-');
        msg.ptrfNumber      = 'PTRF1';
        msg.maskSetTitle    = 'MPW001';
        msg.sourceInboundRequestTimestamp   =   System.now();
        //msg.employeeID      = employeeId;//MDP User
        msg.source          = source;
        msg.statusType      = statusType;
        msg.employeeID      = 'TestUser123';
        
        msg.layers = new List<MRSApprovalService.MRSLayerData>();
        
        Map<Id,MRS_Chip_Details__c> chipMap = new Map<ID,MRS_Chip_Details__c>([Select Id, Name from MRS_Chip_Details__c]);
        List<MRS_Layer_Association__c> layerList = [Select Id, Name, Mask_Layer_Rev__c, Rom_Code__c from MRS_Layer_Association__c];
        List<MRS_Layer_Chip_Association__c> layerChipList = [Select Id, Layer__c, Chip__c from MRS_Layer_Chip_Association__c where Layer__c IN :layerList];
        
        for(MRS_Layer_Association__c layer : layerList){
           
           List<MRSApprovalService.MRSLayerChipData>   lcList = new List<MRSApprovalService.MRSLayerChipData>();
           for(MRS_Layer_Chip_Association__c lc : layerChipList){
               if(lc.Layer__c!=layer.ID) continue;
               MRSApprovalService.MRSLayerChipData   lc1 = new MRSApprovalService.MRSLayerChipData();
               lc1.chipName        = chipMap.get(lc.Chip__c).Name;
               lc1.status          = 'Released';
               lcList.add(lc1);
           }
           //Create layer
           MRSApprovalService.MRSLayerData layer1 = new MRSApprovalService.MRSLayerData();
           layer1.layerNumber  = layer.Name;
           layer1.layerRev     = layer.Mask_Layer_Rev__c;
           layer1.romCode      = layer.Rom_Code__c;
           layer1.layerChips   = lcList;
           layer1.comment      = 'Test MDP - MRS integration';
           msg.layers.add(layer1);
        }
        
        return msg;
    }
    
    public class MRSMDPServiceResponseMock implements WebServiceMock {
       public void doInvoke( Object stub, Object request, Map<String, Object> response, String endpoint, String soapAction,
               String requestName, String responseNS, String responseName, String responseType) {
    
            MRSMDPResponseService.serviceMDPfeedbackResults result = new MRSMDPResponseService.serviceMDPfeedbackResults();
            response.put('response_x', result); 
       }
    }
}