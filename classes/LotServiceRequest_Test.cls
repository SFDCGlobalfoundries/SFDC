/*
    Author: Nikhil jain
    Description: This Class serves as the test class for Lot Service Request.
    History: 
        NJain    13-Jul-2015    - Code creation.
        RNadella 10-oct-2015 --   Added reason for delay 
*/

@isTest(SeeAllData=false)
public class LotServiceRequest_Test{
    
    @testSetup static void testdata(){
        DataUtilTest.loadEnvironmentVariables();
    }
    
    static Id createAccount() {
        // Create Account
        RecordType rt = [
            SELECT      Id
            FROM        RecordType
            WHERE       SObjectType = 'Account'
                        AND Name = 'Customer'
        ];
        
        Account testAcct = new Account();
        testAcct.Name = 'Test Account ZA';
        testAcct.Stage__c = 'Unqualified';
        testAcct.Site_Department__c = 'Test Department';
        testAcct.Sub_Type__c = 'Direct';
        testAcct.Transaction_Type__c = 'Transactional';
        testAcct.Region__c = 'APJ';
        testAcct.Bill_To_Address_1__c = 'Test Address 1';
        testAcct.Corporate_Address_1__c = 'Corporate Address 1';
        testAcct.Bill_To_City__c = 'Test City';
        testAcct.Corporate_City__c = 'Test City';
        testAcct.Bill_To_Country__c = 'Singapore';
        testAcct.Corporate_Country__c = 'Singapore';
        testAcct.RecordTypeId = rt.Id;      
        testAcct.Short_Name__c = 'TestAcct';
        insert testAcct;
                
        return testAcct.Id;
    }
    
    static Lot_Request_Price_Table__c createPriceTable(){
        Lot_Request_Price_Table__c lotPriceTable = new Lot_Request_Price_Table__c();
        lotPriceTable.Effective_Date__c  = System.TODAY()-2;
        lotPriceTable.Expiration_Date__c = System.TODAY()+20;
        lotPriceTable.Fab__c             = 'FAB 2';
        lotPriceTable.Standard_Price_to_Expedite_to_Bullet__c      = 22000;
        lotPriceTable.Standard_Price_to_Expedite_to_Hand_Carry__c  = 200000;
        lotPriceTable.Standard_Price_to_Expedite_to_Hot__c         = 8000;
        insert lotPriceTable;
        return lotPriceTable;
    }
    
    static PO_Lead_Time__c createPOLeadTime(String accId){
        PO_Lead_Time__c  poleadTime = new PO_Lead_Time__c();
        poleadTime.Account__c = accId;
        poleadTime.Bullet_DPML_12w_day_CurrQtr__c = '1';
        poleadTime.Bullet_DPML_12w_day_CurrQtr_1__c = '1';
        poleadTime.Bullet_DPML_12w_day_CurrQtr_2__c = '1';
        poleadTime.Bullet_DPML_12w_day_CurrQtr_3__c = '1';
        poleadTime.Bullet_DPML_12w_day_CurrQtr1__c = '1';
        poleadTime.Bullet_DPML_12w_day_CurrQtr_1_1__c = '1';
        poleadTime.Bullet_DPML_12w_day_CurrQtr_2_1__c = '1';
        poleadTime.Bullet_DPML_12w_day_CurrQtr_3_1__c = '1';
        poleadTime.Base_Device__c = 'testDeviceId';
        poleadTime.Hot_DPML_12w_day_CurrQtr__c = '1';
        poleadTime.Hot_DPML_12w_day_CurrQtr_1__c = '1';
        poleadTime.Hot_DPML_12w_day_CurrQtr_2__c = '1';
        poleadTime.Hot_DPML_12w_day_CurrQtr_3__c = '1';
        poleadTime.Hot_DPML_12w_day_CurrQtr1__c = '1';
        poleadTime.Hot_DPML_12w_day_CurrQtr_1_1__c = '1';
        poleadTime.Hot_DPML_12w_day_CurrQtr_2_1__c = '1';
        poleadTime.Hot_DPML_12w_day_CurrQtr_3_1__c = '1';
        poleadTime.Standard_DPML_day_CurrQtr__c = '1';
        poleadTime.Standard_DPML_day_CurrQtr_1__c = '1';
        poleadTime.Standard_DPML_day_CurrQtr_2__c = '1';
        poleadTime.Standard_DPML_day_CurrQtr_3__c = '1';
        poleadTime.Fab__c = 'FAB 2';
        insert poleadTime;
        return poleadTime;
    }
    
    static void createAccountTeamProxy(Id accountId, boolean hasCE) {
        List<Account_Team_Proxy__c> listATP = new List<Account_Team_Proxy__c>();
        Account_Team_Proxy__c atpCE = new Account_Team_Proxy__c();
        if (hasCE) {
            atpCE.Account__c = accountId;
            atpCE.User__c = [SELECT Id FROM User WHERE Profile.Name = 'GF CE' AND IsActive = true LIMIT 1].Id;
            atpCE.Account_Access__c = 'Read/Write';
            atpCE.Opportunity_Access__c = 'Read/Write';
            atpCE.Team_Role__c = 'Customer Engineer';
            atpCE.Fab_Assignment__c = 'FAB 2;FAB 3;FAB 5';
            listATP.add(atpCE);
        }
        
        Account_Team_Proxy__c atpFE = new Account_Team_Proxy__c();
        atpFE.Account__c = accountId;
        atpFE.User__c = [SELECT Id FROM User WHERE Profile.Name = 'GF FAE/FTS' AND IsActive = true LIMIT 1].Id;
        atpFE.Account_Access__c = 'Read/Write';
        atpFE.Opportunity_Access__c = 'Read/Write';
        atpFE.Team_Role__c = 'Field Application Engineer';
        atpFE.Fab_Assignment__c = 'FAB 2;FAB 3;';
        listATP.add(atpFE);
        
        insert listATP;
    }
 
    static Manufacturing_Lot__c createManufacturingLot(Id accountId) {
        Manufacturing_Lot__c m = new Manufacturing_Lot__c();
        m.Account_Name__c = accountId;
        m.Name = 'testManufacturingLot';
        m.Lot_Type__c = 'QD1';
        //m.Last_Ship_Date__c = date.today().addDays(-3);
        m.Fab_Group__c = 'FAB 2';
        m.Lot_Start_Date__c = datetime.now();
        m.Device_ID_MES__c = 'testDeviceId';
        m.Device_ID_R12__c = 'testDeviceId';
        m.Active_Flag__c = true;
        m.Current_Scheduled_Date_CSD__c = System.TODAY()+5;
        insert m;
        return m;
    }
    
    public static Id getWorkItemId(Id targetObjectId){
        Id retVal = null;
        for(ProcessInstanceWorkitem workItem: [SELECT p.Id from ProcessInstanceWorkitem p
                                                WHERE p.ProcessInstance.TargetObjectId =: targetObjectId
                                                  AND p.ProcessInstance.Status = 'Pending'])
        {
            retVal  =  workItem.Id;
        }
        return retVal;
    }
    
    //Test method for EM approval Under Corridor and Planner as 'Supported to Meet CRD'
    static testMethod void testMethod1() {
        string accountId = LotServiceRequest_Test.createAccount();
        Manufacturing_Lot__c mfgLot = LotServiceRequest_Test.createManufacturingLot(accountId);
        Lot_Request_Price_Table__c lotPriceTable     = LotServiceRequest_Test.createPriceTable();
        PO_Lead_Time__c            createPOLeadTime  = LotServiceRequest_Test.createPOLeadTime(accountId);
        
        String rtId = Schema.Sobjecttype.Lot_Request__c.getRecordTypeInfosByName().get('Standard Lot Service Request').getRecordTypeId();

        Lot_Request__c l = new Lot_Request__c();
        l.Account__c = accountId;
        l.RecordTypeId = rtId;
        l.Lot_Request_Type__c = 'Standard Expedite';
        l.New_Customer_Requested_Date_CRD_CSR__c = date.today();
        l.Date_Customer_Submitted_Request__c = System.TODAY();
        l.Fab__c = 'FAB 2';
        l.Reason_for_Delay__c='Test';
        insert l;
        
        Lot_Instruction__c lotInstr = new Lot_Instruction__c();
        lotInstr.Manufacturing_Lot__c = mfgLot.Id;
        lotInstr.Lot_Request__c = l.Id;
        lotInstr.Account__c = accountId;
        insert lotInstr;
        
        l.Does_Customer_Accept_Standard_Pricing__c = 'Yes';
        update l;
        test.startTest();
            // Create an approval request for the account
            Approval.ProcessSubmitRequest req1 = new Approval.ProcessSubmitRequest();
            req1.setComments('Submitting request for approval.');
            req1.setObjectId(l.id);
            
            // Submit on behalf of a specific submitter
            req1.setSubmitterId(userInfo.getUserId());
            
            req1.setSkipEntryCriteria(true);
            
            // Submit the approval request for the account
            Approval.ProcessResult result = Approval.process(req1);
            
            //EM Approving the record by selecting the EM Recommendations
            l.Expedite_Manager_Recommendation_EM__c = 'Approved Under Corridor';
            l.Expedite_Manager_Comments__c = 'Approved by EM Under corridor.';
            update l;
            
            //Planner Approving the record by clicking Approve/Reject Link
            lotInstr.New_CSD_P__c = System.TODAY();
            update lotInstr;
            Approval.ProcessWorkitemRequest req = new Approval.ProcessWorkitemRequest();
            req.setComments('Planning Team Approval');
            req.setAction('Approve');
            req.setNextApproverIds(new Id[] {UserInfo.getUserId()});
            Id workItemId = getWorkItemId(l.id); 
            
            if(workItemId == NULL){
                l.addError('Some Exception occurred. Please contact system administrator.');
                system.debug('###Exception###');
            }
            else{
                req.setWorkitemId(workItemId);
                // Submit the request for approval
                Approval.ProcessResult result2 =  Approval.process(req);
            }
        test.stopTest();
    }
    
    //Test method for EM approval Under Corridor and Planner as 'Supported with improved CSD but not meeting CRD'
    static testMethod void testMethod3() {
        string accountId = LotServiceRequest_Test.createAccount();
        Manufacturing_Lot__c mfgLot = LotServiceRequest_Test.createManufacturingLot(accountId);
        Lot_Request_Price_Table__c lotPriceTable     = LotServiceRequest_Test.createPriceTable();
        PO_Lead_Time__c            createPOLeadTime  = LotServiceRequest_Test.createPOLeadTime(accountId);
        
        String rtId = Schema.Sobjecttype.Lot_Request__c.getRecordTypeInfosByName().get('Standard Lot Service Request').getRecordTypeId();
        
        Lot_Request__c l = new Lot_Request__c();
        l.Account__c = accountId;
        l.Lot_Request_Type__c = 'Standard Expedite';
        l.RecordTypeId = rtId;
        l.New_Customer_Requested_Date_CRD_CSR__c = date.today();
        l.Date_Customer_Submitted_Request__c = System.TODAY();
        l.Fab__c = 'FAB 2';
        l.Reason_for_Delay__c='Test';
        insert l;
        
        Lot_Instruction__c lotInstr = new Lot_Instruction__c();
        lotInstr.Manufacturing_Lot__c = mfgLot.Id;
        lotInstr.Lot_Request__c = l.Id;
        lotInstr.Account__c = accountId;
        insert lotInstr;
        
        l.Does_Customer_Accept_Standard_Pricing__c = 'Yes';
        update l;
        
        test.startTest();
            // Create an approval request for the account
            Approval.ProcessSubmitRequest req1 = new Approval.ProcessSubmitRequest();
            req1.setComments('Submitting request for approval.');
            req1.setObjectId(l.id);
            
            // Submit on behalf of a specific submitter
            req1.setSubmitterId(userInfo.getUserId());
            
            req1.setSkipEntryCriteria(true);
            
            // Submit the approval request for the account
            Approval.ProcessResult result = Approval.process(req1);
            
            //EM Approving the record by selecting the EM Recommendations
            l.Expedite_Manager_Recommendation_EM__c = 'Approved Under Corridor';
            l.Expedite_Manager_Comments__c = 'Approved by EM Under corridor.';
            update l;
            
            //Planner Approving the record by clicking Approve/Reject Link
            lotInstr.Current_CSD_ML_at_time_of_Submission__c=System.TODAY()+1;
            lotInstr.New_CSD_P__c = System.TODAY()+1;
            update lotInstr;
            Approval.ProcessWorkitemRequest req = new Approval.ProcessWorkitemRequest();
            req.setComments('Planning Team Approval');
            req.setAction('Approve');
            req.setNextApproverIds(new Id[] {UserInfo.getUserId()});
            Id workItemId = getWorkItemId(l.id); 
            
            if(workItemId == NULL){
                l.addError('Some Exception occurred. Please contact system administrator.');
                system.debug('###Exception###');
            }
            else{
                req.setWorkitemId(workItemId);
                // Submit the request for approval
                Approval.ProcessResult result2 =  Approval.process(req);
            }
        test.stopTest();
    }
    
    //Test method for EM approval Under Non-Corridor and Planner recomm as 'Supported with improved CSD but not meeting CRD'
    static testMethod void testMethod4() {
        string accountId = LotServiceRequest_Test.createAccount();
        Manufacturing_Lot__c mfgLot = LotServiceRequest_Test.createManufacturingLot(accountId);
        Lot_Request_Price_Table__c lotPriceTable     = LotServiceRequest_Test.createPriceTable();
        PO_Lead_Time__c            createPOLeadTime  = LotServiceRequest_Test.createPOLeadTime(accountId);
        String rtId = Schema.Sobjecttype.Lot_Request__c.getRecordTypeInfosByName().get('Standard Lot Service Request').getRecordTypeId();
        
        Lot_Request__c l = new Lot_Request__c();
        l.Account__c = accountId;
        l.Lot_Request_Type__c = 'Standard Expedite';
        l.RecordTypeId = rtId;
        l.New_Customer_Requested_Date_CRD_CSR__c = date.today();
        l.Date_Customer_Submitted_Request__c = System.TODAY();
        l.Fab__c = 'FAB 2';
        l.Reason_for_Delay__c='Test';
        insert l;
        
        Lot_Instruction__c lotInstr = new Lot_Instruction__c();
        lotInstr.Manufacturing_Lot__c = mfgLot.Id;
        lotInstr.Lot_Request__c = l.Id;
        lotInstr.Account__c = accountId;
        insert lotInstr;
        
        l.Does_Customer_Accept_Standard_Pricing__c = 'Yes';
        update l;
        
        test.startTest();
            // Create an approval request for the account
            Approval.ProcessSubmitRequest req1 = new Approval.ProcessSubmitRequest();
            req1.setComments('Submitting request for approval.');
            req1.setObjectId(l.id);
            
            // Submit on behalf of a specific submitter
            req1.setSubmitterId(userInfo.getUserId());
            
            req1.setSkipEntryCriteria(true);
            
            // Submit the approval request for the account
            Approval.ProcessResult result = Approval.process(req1);
            
            //EM Approving the record by selecting the EM Recommendations
            l.Expedite_Manager_Recommendation_EM__c = 'Approved for Planner Feedback';
            l.Expedite_Manager_Comments__c = 'Approved by EM Under corridor.';
            update l;
            
            //Planner Approving the record by clicking Approve/Reject Link
            lotInstr.Current_CSD_ML_at_time_of_Submission__c=System.TODAY()+2;
            lotInstr.New_CSD_P__c = System.TODAY()+2;
            update lotInstr;
            Approval.ProcessWorkitemRequest req = new Approval.ProcessWorkitemRequest();
            req.setComments('Planning Team Approval');
            req.setAction('Approve');
            req.setNextApproverIds(new Id[] {UserInfo.getUserId()});
            Id workItemId = getWorkItemId(l.id); 
            
            if(workItemId == NULL){
                l.addError('Some Exception occurred. Please contact system administrator.');
                system.debug('###Exception###');
            }
            else{
                req.setWorkitemId(workItemId);
                // Submit the request for approval
                Approval.ProcessResult result2 =  Approval.process(req);
            }
            
        test.stopTest();
    }
    
    
    //Test method for EM approval Under Non-Corridor and Planner Rejects the record
    static testMethod void testMethod6() {
        string accountId = LotServiceRequest_Test.createAccount();
        Manufacturing_Lot__c mfgLot = LotServiceRequest_Test.createManufacturingLot(accountId);
        Lot_Request_Price_Table__c lotPriceTable     = LotServiceRequest_Test.createPriceTable();
        PO_Lead_Time__c            createPOLeadTime  = LotServiceRequest_Test.createPOLeadTime(accountId);
        String rtId = Schema.Sobjecttype.Lot_Request__c.getRecordTypeInfosByName().get('Standard Lot Service Request').getRecordTypeId();
        
        Lot_Request__c l = new Lot_Request__c();
        l.Account__c = accountId;
        l.Lot_Request_Type__c = 'Standard Expedite';
        l.RecordTypeId = rtId;
        l.New_Customer_Requested_Date_CRD_CSR__c = date.today();
        l.Date_Customer_Submitted_Request__c = System.TODAY();
        l.Fab__c = 'FAB 2';
        l.Reason_for_Delay__c='Test';
        insert l;
        
        Lot_Instruction__c lotInstr = new Lot_Instruction__c();
        lotInstr.Manufacturing_Lot__c = mfgLot.Id;
        lotInstr.Lot_Request__c = l.Id;
        lotInstr.Account__c = accountId;
        insert lotInstr;
        
        l.Does_Customer_Accept_Standard_Pricing__c = 'Yes';
        update l;
        
        test.startTest();
            // Create an approval request for the account
            Approval.ProcessSubmitRequest req1 = new Approval.ProcessSubmitRequest();
            req1.setComments('Submitting request for approval.');
            req1.setObjectId(l.id);
            
            // Submit on behalf of a specific submitter
            req1.setSubmitterId(userInfo.getUserId());
            
            req1.setSkipEntryCriteria(true);
            
            // Submit the approval request for the account
            Approval.ProcessResult result = Approval.process(req1);
            
            //EM Approving the record by selecting the EM Recommendations
            l.Expedite_Manager_Recommendation_EM__c = 'Approved for Planner Feedback';
            l.Expedite_Manager_Comments__c = 'Approved by EM Under corridor.';
            update l;
            
            //Planner Rejects the record by clicking Approve/Reject Link
            lotInstr.New_CSD_P__c = System.TODAY()+2;
            update lotInstr;
            Approval.ProcessWorkitemRequest req = new Approval.ProcessWorkitemRequest();
            req.setComments('Rejecting request');
            req.setAction('Reject');
            Id workItemId = getWorkItemId(l.id);   
    
            if(workItemId == null){
                l.addError('Error Occured in Trigger');
            }
            else{
                req.setWorkitemId(workItemId);
                // Submit the request for approval
                Approval.ProcessResult result2 =  Approval.process(req);
            }
            
        test.stopTest();
    }
    
    //Test method for EM Rejection
    static testMethod void testMethod2() {
        string accountId = LotServiceRequest_Test.createAccount();
        Manufacturing_Lot__c mfgLot = LotServiceRequest_Test.createManufacturingLot(accountId);
        Lot_Request_Price_Table__c lotPriceTable     = LotServiceRequest_Test.createPriceTable();
        PO_Lead_Time__c            createPOLeadTime  = LotServiceRequest_Test.createPOLeadTime(accountId);
        String rtId = Schema.Sobjecttype.Lot_Request__c.getRecordTypeInfosByName().get('Standard Lot Service Request').getRecordTypeId();
        
        Lot_Request__c l = new Lot_Request__c();
        l.Account__c = accountId;
        l.Lot_Request_Type__c = 'Standard Expedite';
        l.RecordTypeId = rtId;
        l.New_Customer_Requested_Date_CRD_CSR__c = date.today();
        l.Date_Customer_Submitted_Request__c = System.TODAY();
        l.Fab__c = 'FAB 2';
        l.Reason_for_Delay__c='Test';
        l.Expedite_Manager_Recommendation_EM__c = 'Approval Not Required';
        l.Expedite_Manager_Comments__c = 'test';
        insert l;
        
        Lot_Instruction__c lotInstr = new Lot_Instruction__c();
        lotInstr.Manufacturing_Lot__c = mfgLot.Id;
        lotInstr.Lot_Request__c = l.Id;
        lotInstr.Account__c = accountId;
        insert lotInstr;
        
        l.Does_Customer_Accept_Standard_Pricing__c = 'Yes';
        update l;
        
        test.startTest();
            // Create an approval request for the account
            Approval.ProcessSubmitRequest req1 = new Approval.ProcessSubmitRequest();
            req1.setComments('Submitting request for approval.');
            req1.setObjectId(l.id);
            
            // Submit on behalf of a specific submitter
            req1.setSubmitterId(userInfo.getUserId());
            
            req1.setSkipEntryCriteria(true);
            
            // Submit the approval request for the account
            Approval.ProcessResult result = Approval.process(req1);
            
            l.Expedite_Manager_Recommendation_EM__c = 'Rejected';
            l.Expedite_Manager_Comments__c = 'Rejected by Expedite Manager.';
            update l;
        test.stopTest();
    }
   }