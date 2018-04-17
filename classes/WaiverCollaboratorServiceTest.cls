/*
    @Author :- Abhita Bansal
*/
@isTest(SeeAllData=false)
private class WaiverCollaboratorServiceTest {
    
   /* @testSetup static void testdata() {
        DataUtilTest.loadEnvironmentVariables(); 
    }*/

    static testMethod void myCollaboratorServiceMethod() { 
        Test.setMock(WebServiceMock.class, new WebServiceCollabMockImpl());
        Test.setMock(WebServiceMock.class, new testWebServiceMockImpl());
        DesignCollaboratorTestData.getCustomSettings2('SIEBEL_OPPTY_ID_SEQUENCE_NO');
        
        DesignCollaboratorTestData.getCustomSettings('DEVICE_TYPE_RETROFIT');
        DesignCollaboratorTestData.getCustomSettings('DEVICE_TAPEOUT_TYPE_RETROFIT');
        DesignCollaboratorTestData.getCustomSettings('DEVICE_TAPEOUT_TYPE_SINGLE_PRODUCT');
        DesignCollaboratorTestData.getCustomSettings('DEVICE_STATUS_ACTIVE');
        DesignCollaboratorTestData.getCustomSettings('DEVICE_DESIGN_IN');
        DesignCollaboratorTestData.getCustomSettings('DEVICE_STAGE_TAPEOUT');
        DesignCollaboratorTestData.getCustomSettings('DEVICE_TAPEOUT_TYPE_GLOBALSHUTTLE_MPW');
        DesignCollaboratorTestData.getCustomSettings('DEVICE_TAPEOUT_TYPE_CUSTOMER_MPW');
        
        DesignCollaboratorTestData.getCustomSettings('ACT_TM_PRXY_TM_RL_CE');
        DesignCollaboratorTestData.getCustomSettings('ACCT_TM_PRXY_TM_RL_FP');
        DesignCollaboratorTestData.getCustomSettings('ACCT_TM_PRXY_TM_RL_AM');
        DesignCollaboratorTestData.getCustomSettings('ACCT_TM_PRXY_TM_RL_TS');
        DesignCollaboratorTestData.getCustomSettings('ACCT_TM_PRXY_TM_RL_AE');
        DesignCollaboratorTestData.getCustomSettings('ACCT_TM_PRXY_TM_RL_CSR');
        DesignCollaboratorTestData.getCustomSettings('GF_INTEGRATION_PROFILE_ID');
        DesignCollaboratorTestData.getCustomSettings('ACCT_TM_PRXY_TM_RL_PCSR');
        DesignCollaboratorTestData.getCustomSettings('ACCT_TM_PRXY_TM_RL_PAM');
        DesignCollaboratorTestData.getCustomSettings('ACCT_TM_PRXY_TM_RL_AA');      
        DesignCollaboratorTestData.getCustomSettings('ACCT_RT_ID_GF_INTERNAL');
        DesignCollaboratorTestData.getCustomSettings('ACCT_RT_ID_CUSTOMER');
        DesignCollaboratorTestData.getCustomSettings('BPM_isActive');        
        
        DesignCollaboratorTestData.getCustomSettings1('ACCT_RT_ID_CUSTOMER');
        DesignCollaboratorTestData.getCustomSettings1('ACCT_RT_ID_RESELLER');
        DesignCollaboratorTestData.getCustomSettings1('ACCT_PFTS_OR_BCSR_NOT_FOUND_ERROR');
        DesignCollaboratorTestData.getCustomSettings1('ACCT_TM_DUP_USER_ROLE_ERROR');
        DesignCollaboratorTestData.getCustomSettings1('ATP_INTEGRATION_SEQUENCE_ERROR');
        DesignCollaboratorTestData.getCustomSettings1('ATP_FLAG_FOR_DELETE_UPDATE_ERROR');
        DesignCollaboratorTestData.getCustomSettings1('ATP_FLAG_FOR_DELETE_CREATION_ERROR');
        DesignCollaboratorTestData.getCustomSettings1('DEV_D1_NAT_ACCESS_VALIDATION_MSG');
        DesignCollaboratorTestData.getCustomSettings1('BX041_STATUS_ERROR_NOT_CLOSED');
        DesignCollaboratorTestData.getCustomSettings1('EXPORT_CONTROL_DECLARATION_REQUIRED');
        DesignCollaboratorTestData.getCustomSettings1('SECURITY_DEVICE_REQUIRED');
        DesignCollaboratorTestData.getCustomSettings1('AUTOMOTIVE_DEVICE_REQUIRED');
        DesignCollaboratorTestData.getCustomSettings1('DEVICE_STAGE_VALIDATION');
        DesignCollaboratorTestData.getCustomSettings1('DEVICE_IP_DECLARATION_VALIDATION');
        DesignCollaboratorTestData.getCustomSettings4('Update Bill To Address No');
        
       DesignCollaboratorTestData.getDevCustomSettings('DEVICE_STAGE_DESIGN_IN');
       DesignCollaboratorTestData.getDevCustomSettings('DEVICE_STAGE_EOL');
       DesignCollaboratorTestData.getDevCustomSettings('DEVICE_STAGE_PRODUCTION'); 
       DesignCollaboratorTestData.getDevCustomSettings('DEVICE_STAGE_PROTOTYPE');
       DesignCollaboratorTestData.getDevCustomSettings('DEVICE_STAGE_RTR');
       DesignCollaboratorTestData.getDevCustomSettings('DEVICE_STAGE_SOLUTIONING');
       DesignCollaboratorTestData.getDevCustomSettings('DEVICE_STAGE_TAPEOUT');
       DesignCollaboratorTestData.getDevCustomSettings2('MANUAL_DEVICE_PV_YES');
       DesignCollaboratorTestData.getDevCustomSettings2('MANUAL_DEVICE_PV_NO');
       DesignCollaboratorTestData.getDevCustomSettings2('MANUAL_DEVICE_PRODUCTION');
       DesignCollaboratorTestData.getDevCustomSettings2('MANUAL_DEVICE_PROTO_RISK_PROD');
       DesignCollaboratorTestData.getDevCustomSettings2('MANUAL_DEVICE_TAPEOUT');
       DesignCollaboratorTestData.getDevCustomSettings2('MANUAL_DEVICE_RETROFIT');
       DesignCollaboratorTestData.getDevCustomSettings2('MANUAL_DEVICE_RETROFIT_ERROR');
       DesignCollaboratorTestData.getDevCustomSettings2('MANUAL_DEVICE_TEAM_ROOM_PUBLISH_ERROR');
       DesignCollaboratorTestData.getDevCustomSettings2('MANUAL_DEVICE_TEAM_ROOM_PUBLISH_INFO');
       DesignCollaboratorTestData.getDevCustomSettings2('MANUAL_DEVICE_DUPLICATE_DEVICE_ERROR');
       DesignCollaboratorTestData.getDevCustomSettings2('MANUAL_DEVICE_ACCOUNT_ERROR');
       DesignCollaboratorTestData.getDevCustomSettings2('MDEVICE_REPORT_FOLDER');
       DesignCollaboratorTestData.getDevCustomSettings2('MANUAL_DEVICE_OWNER_USER_FID');
       DesignCollaboratorTestData.getDevCustomSettings3('CRMDID_No'); 
        
        Wavier_Collaborator__c waiverColl = DesignCollaboratorTestData.getWaiverCollaborator0();
        waiverColl.PTSR_Number__c = 'PTSR-XXXX-001';
        update waiverColl;
        
        AcctRegHeadMappingTgrHandler.bypassAcctTrigger=true;
        Account account = DesignCollaboratorTestData.getAccountTestData();
        Opportunity opp = DesignCollaboratorTestData.getOppTestData(account.Id);
        Opportunity_Program__c oppProgram = DesignCollaboratorTestData.getOppProgTestData(account.Id, opp.Id);
		Error_Codes__c  b=new Error_Codes__c (name='CONFIG_STAGE_VALIDATION_MSG',Message__c='Process Flow Accepted');
        insert b;
        Device__c device = DesignCollaboratorTestData.getDeviceTestData(account.Id, opp.Id, oppProgram.Id);
        
        // attachement data
        list<Queryptsrattachments.GetPTSRAttachmentResponseDetailsType> attDetailList = new List<Queryptsrattachments.GetPTSRAttachmentResponseDetailsType>();
        Queryptsrattachments.GetPTSRAttachmentResponseDetailsType attDetail = new Queryptsrattachments.GetPTSRAttachmentResponseDetailsType();
        attDetail.FileID = '10000001';
        attDetail.PTSRID = '1000008001';
        attDetail.PTSRNumber='PTSR-XXXX-001';
        attDetail.Reference = 'Reference';
        attDetail.FileName = 'Test FileName';
        attDetail.ContentType = 'Attachment';
        attDetail.AttachTo = 'Test Collaborator';
        attDetail.FileSize = '2';
        attDetail.CreatedDate = '2015-09-09T16:56:33.75-07:00';
        attDetail.CreatedBy = 'test User';
        attDetail.ModifedDate = '2015-09-09T16:56:33.75-07:00';
        attDetail.ModifiedBy = 'test User';
        attDetailList.add(attDetail);
        
        // DFM List Data
        QueryPtsrServiceCls.GetDFMDetailsResponseDetailType dFMDetailInfo = new QueryPtsrServiceCls.GetDFMDetailsResponseDetailType();
        dFMDetailInfo.DFMDesignType = 'Test1';
        dFMDetailInfo.AccountManager = 'TestUser1';       
        List<QueryPtsrServiceCls.GetDFMDetailsResponseDetailType> dFMDetailInfoList = new List<QueryPtsrServiceCls.GetDFMDetailsResponseDetailType>();
        dFMDetailInfoList.add(dFMDetailInfo);
        
        
        QueryPtsrServiceCls.GetDRCDetailsResponseDetailType drcDetailInfo = new QueryPtsrServiceCls.GetDRCDetailsResponseDetailType();
        drcDetailInfo.LayoutType = 'Test layout type';
        drcDetailInfo.OtherLayoutType = 'Test otherlayouttype';        
        drcDetailInfo.LayoutSource = 'Test layout source';
        drcDetailInfo.OtherLayoutSource = 'Test OtherLayoutSource';
        
        List<QueryPtsrServiceCls.GetDRCDetailsResponseDetailType> drcDetailInfoList = new List<QueryPtsrServiceCls.GetDRCDetailsResponseDetailType>();
        drcDetailInfoList.add(drcDetailInfo);
        System.debug('drcDetailInfoList*************'+drcDetailInfoList);
        QueryPtsrServiceCls.GetDFMDetailsResponseDetailType dFMDetailInfo1 = new QueryPtsrServiceCls.GetDFMDetailsResponseDetailType();
        dFMDetailInfo1.DFMDesignType = 'Test1';
        dFMDetailInfo1.AccountManager = 'TestUser1'; 
        dFMDetailInfo1.DFMServiceDRCPlus = 'TRUE';
        dFMDetailInfo1.DFMServiceMCDMAS='TRUE';
        dFMDetailInfo1.DFMServiceCMPModel='TRUE';
        dFMDetailInfo1.DFMServiceLitho='TRUE'; 
        dFMDetailInfo1.DFMServiceCAA ='TRUE';    
        
        dFMDetailInfoList.add(dFMDetailInfo1);
        
        // PTSR List Data
        QueryPtsrServiceCls.GetPTSRDetailsResponseDetailType pTSRDetailInfo = new QueryPtsrServiceCls.GetPTSRDetailsResponseDetailType();
        pTSRDetailInfo.CustomerFullName = 'TestUser1';
        pTSRDetailInfo.MaskSetTitle = 'Test1';     
        List<QueryPtsrServiceCls.GetPTSRDetailsResponseDetailType> pTSRDetailInfoList = new List<QueryPtsrServiceCls.GetPTSRDetailsResponseDetailType>();
        pTSRDetailInfoList.add(pTSRDetailInfo);
       
        // DFM Chip List Data
        QueryPtsrServiceCls.GetDFMChipsDetailsResponseDetailType chipDetailInfo = new QueryPtsrServiceCls.GetDFMChipsDetailsResponseDetailType();
        chipDetailInfo.ChipName = 'Test1';
        chipDetailInfo.TopCellName = 'TestCell1';       
        List<QueryPtsrServiceCls.GetDFMChipsDetailsResponseDetailType> chipDetailInfoList = new List<QueryPtsrServiceCls.GetDFMChipsDetailsResponseDetailType>();
        chipDetailInfoList.add(chipDetailInfo);
        
        WaiverCollaboratorService.PTSRRequestElements ptsrReqElement = new WaiverCollaboratorService.PTSRRequestElements();
        ptsrReqElement.ptsrNumber = 'PTSR-XXXX-001';
        ptsrReqElement.crmDeviceId = '786372';
        ptsrReqElement.custShortName = 'TestAcc';       
             
        WaiverCollaboratorService.getDfmReponse(waiverColl.Id);
        WaiverCollaboratorService.createWaiverCollaboratorReport(ptsrReqElement);
        WaiverCollaboratorService.setDfmDetails(dFMDetailInfoList[0], waiverColl.Id);
        WaiverCollaboratorService.setDfmDetails(dFMDetailInfoList[1], waiverColl.Id);
        WaiverCollaboratorService.setPtsrDetails(pTSRDetailInfoList[0], waiverColl.Id);
        WaiverCollaboratorService.setDfmchipDetails(chipDetailInfoList, waiverColl.Id);
        WaiverCollaboratorService.setDWCAttachmentDetails(attDetailList, waiverColl.Id);
        
        System.assertEquals(ptsrReqElement.ptsrNumber = 'PTSR-XXXX-001', 'PTSR-XXXX-001');
    }
}