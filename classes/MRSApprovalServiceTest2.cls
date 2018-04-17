@isTest
private class MRSApprovalServiceTest2 {

    @isTest
    private static void testPerformApproval_TDTIMPW1(){        
        Test.startTest();
        MRSTDTIMPWService testController = new MRSTDTIMPWService();
        testController.getFieldMap();
        testController.getSourceForApprovalEmail();
        testController.getNoteCategory();
        Test.stopTest();
    }

    @isTest
    private static void testPerformApproval_Foundry_MEBES(){        
        Test.startTest();
        MRSFoundryMEBESJVService testController = new MRSFoundryMEBESJVService();
        testController.getFieldMap();
        testController.getSourceForApprovalEmail();
        testController.getNoteCategory();
        Test.stopTest();
    }
    
    @isTest
    private static void testPerformApproval_MRS_MDP_Service(){        
        Test.startTest();
        MRSMDPService testController = new MRSMDPService();
        testController.getFieldMap();
        testController.getSourceForApprovalEmail();
        testController.getNoteCategory();
        Test.stopTest();
    }
    
    @isTest
    private static void testPerformApproval_Customer_Service(){        
        Test.startTest();
        MRSCustomerMEBESJVService testController = new MRSCustomerMEBESJVService();
        testController.getFieldMap();
        testController.getSourceForApprovalEmail();
        testController.getNoteCategory();
        Test.stopTest();
    }
    
    @isTest
    private static void test_MRSApprovalUtility(){        
        MRSApprovalService.MRSApprovalMsg msg = new MRSApprovalService.MRSApprovalMsg();
        msg.ptrfNumber = 'PTRFNUMBER';
        try {MRSApprovalUtility.sendInvalidStatusEmail('message', msg, 'logid');} catch(Exception e) {}
    }
}