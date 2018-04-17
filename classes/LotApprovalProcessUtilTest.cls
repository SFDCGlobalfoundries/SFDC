/**
* Author        :   Ravikiran Nadella
* Description   :  this class acts as test class for LotApprovalProcessUtil.
* History       :
        Initials        Date                Description
-----------------------------------------------------------------------------------------
             
        RNadella        09/11/2015          Created the class             
        RNadella        02/01/2016          Updated the class       
**/

@isTest
private class LotApprovalProcessUtilTest  {
    /*
    Modified By : GOPI KOKA
    Dont remove seealldata = true(applied for to cover code "ProcessInstanceHistory" records to retrive)
    */
    @isTest(seeAllData=true) static void submitApproval(){ 
        //DataUtilTest.loadEnvironmentVariables();
               
        Account acc = new Account();
        acc.name = 'MYTEST ACCOUNT1';
        acc.Site_Department__c = 'Test Site';
        acc.Sub_Type__c = 'Direct'; 
        acc.Transaction_Type__c = 'Transactional';
        acc.Region__c = 'US';
        acc.Corporate_Address_1__c = 'Test Corporate Address 1';
        acc.Corporate_City__c = 'Corporate City';
        acc.Corporate_Country__c = 'India';
        acc.Copy_Address__c = true;
        acc.Bill_To_Address_1__c = 'Test Bill Address 1';
        insert acc;
       
        string stdRecId=Schema.SObjectType.Lot_Request__c.getRecordTypeInfosByName().get('Standard Lot Service Request').getRecordTypeId();
        Lot_Request__c lotReq = new Lot_Request__c();
        lotReq.Lot_Request_Type__c = 'Standard Expedite';
        lotReq.Stage__c = 'Acknowledged by CSR';
        lotReq.RecordTypeId=stdRecId;
        lotReq.Fab__c = 'FAB 2';
        lotReq.Date_Customer_Submitted_Request__c = System.today();
        lotReq.Account__c =acc.id;
        lotReq.New_Customer_Requested_Date_CRD_CSR__c = System.Today() + 1;
        lotReq.Does_Customer_Accept_Standard_Pricing__c = 'Yes';
        insert lotReq;
        
        Process__c processRec = new Process__c();
        processRec.name = 'test Process';
        processRec.Tech_Type__c = 'CT';
        processRec.Tech_Geometry__c = '0.010UM';
        insert processRec;
        
        Manufacturing_Lot__c mfgLot = new Manufacturing_Lot__c();
        mfgLot.name = 'Test Mfg Lot';
        mfgLot.Fab_Group__c = 'FAB 2';
        mfgLot.Process_Id__c = processRec.id;
        mfgLot.Geometry__c = '0.010UM';
        mfgLot.Actual_Fab_Out_Date__c = System.Today() + 3;
        mfgLot.Account_Name__c = acc.id;
        mfgLot.Lot_Start_Date__c = datetime.now();
        mfgLot.Device_ID_MES__c = 'testDeviceId';
        mfgLot.Device_ID_R12__c = 'testDeviceId';
        mfgLot.Active_Flag__c = true;
        mfgLot.Current_Scheduled_Date_CSD__c = System.TODAY()+5;
        insert mfgLot;
        
        Lot_Instruction__c  lotInstrn = new Lot_Instruction__c();
        lotInstrn.Lot_Request__c = lotReq.id;
        lotInstrn.Manufacturing_Lot__c = mfgLot.id;
        lotInstrn.New_CSD_P__c  = System.Today() +4;
        lotInstrn.Account__c = acc.Id;
        insert lotInstrn;
        
        Profile p = [SELECT Id FROM Profile WHERE Name='Standard User']; 
        User u = new User(Alias = 'standt', Email='standarduser@testorg.com', 
                          EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                          LocaleSidKey='en_US', ProfileId = p.Id, 
                          TimeZoneSidKey='America/Los_Angeles', UserName='standarduser2345@testorg.com');
        insert u;
        
        // Create an approval request for the account
        Approval.ProcessSubmitRequest req1 = 
            new Approval.ProcessSubmitRequest();
        req1.setComments('Submitting request for approval.');
        req1.setObjectId(lotReq.id);

        // Submit on behalf of a specific submitter
        req1.setSubmitterId(UserInfo.getUserId()); 

        // Submit the record to specific process and skip the criteria evaluation
        req1.setProcessDefinitionNameOrId('Lot_Service_Request_Standard_1');
        req1.setSkipEntryCriteria(true);

        // Submit the approval request for the account
        Approval.ProcessResult result = Approval.process(req1);
        
        List<Id> newWorkItemIds = result.getNewWorkitemIds();
        
        // Instantiate the new ProcessWorkitemRequest object and populate it
        Approval.ProcessWorkitemRequest req2 = 
            new Approval.ProcessWorkitemRequest();
        req2.setComments('Approving request.');
        req2.setAction('Approve');
        req2.setNextApproverIds(new Id[] {UserInfo.getUserId()});
        
        // Use the ID from the newly created item to specify the item to be worked
        req2.setWorkitemId(newWorkItemIds.get(0));
    
        // Submit the request for approval
        Approval.ProcessResult result2 =  Approval.process(req2);
        
        
        PageReference pageRef = Page.VoidLotRequest;
        pageRef.getParameters().put('id', String.valueOf(lotReq.Id));
        Test.setCurrentPage(pageRef);
          
        list<Lot_Request__c> lrList= new list<Lot_Request__c>();
        lrList.add(lotReq);
        LotApprovalProcessUtil.activeMLonLotinstr(lotReq.id);
        LotApprovalProcessUtil.sendEmailtoApprovers(lrList);
        LotApprovalProcessUtil.recallCheck();
    }
}