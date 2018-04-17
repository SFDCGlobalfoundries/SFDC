/**
* Author        :   Ravikiran Nadella
* Description   :  this class acts as Testclass for VoidLotRequestController
* History       :
        Initials        Date                Description
-----------------------------------------------------------------------------------------
             
        RNadella        11/09/2015          Created the class                                   
**/

@isTest
public class VoidLotRequestControllerTest{

@testSetup static void testdata() {
            DataUtilTest.loadEnvironmentVariables();
            
            Map<String,Object> fieldValueMap = new Map<String,Object>();
            fieldValueMap.put('Name', 'MYTEST ACCOUNT5');            
            fieldValueMap.put('stage__c', 'Unqualified');        
            fieldValueMap.put('sub_type__c', 'Direct');
            fieldValueMap.put('site_department__c', 'test dept');          
            fieldValueMap.put('transaction_type__c', 'transactional');                          
            fieldValueMap.put('region__c', 'APJ');        
            fieldValueMap.put('Corporate_Address_1__c', 'Test Address 1');          
            fieldValueMap.put('Corporate_City__c', 'Test City');                
            fieldValueMap.put('Corporate_Country__c', 'Singapore');
            fieldValueMap.put('Bill_To_Address_1__c', 'Test Address 1');          
            fieldValueMap.put('Bill_To_City__c', 'Test City');            
            fieldValueMap.put('Bill_To_Country__c', 'Singapore');        
            fieldValueMap.put('Fab_9_10__c','No');
    
            AccountDataFactory.createAccount(fieldValueMap);
        }
 
 static testMethod void voidRecallTest(){
        // Load Environment Variables   
                
         Account acc = getAccount('MYTEST ACCOUNT5');
        
        Profile p = [SELECT Id FROM Profile WHERE Name='Standard User']; 
        User u = new User(Alias = 'standt', Email='standarduser@testorg.com', 
                          EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                          LocaleSidKey='en_US', ProfileId = p.Id, 
                          TimeZoneSidKey='America/Los_Angeles', UserName='standarduser2345@testorg.com');
        insert u;

        Account_Team_Proxy__c accntTeamProxy = new Account_Team_Proxy__c();
        accntTeamProxy.Account__c = acc.Id;
        accntTeamProxy.User__c = u.id;
        accntTeamProxy.Account_Access__c = 'Read/Write';
        accntTeamProxy.Case_Access__c = 'Read/Write';
        accntTeamProxy.Opportunity_Access__c = 'Read/Write';
        accntTeamProxy.Team_Role__c = 'Backup Customer Service Rep';
        insert accntTeamProxy;
        //accntTeamProxy.Team_Role__c = 'Backup Customer Service Rep';
        //insert accntTeamProxy;                
        
        Lot_Request_Price_Table__c lotReqPriceTable = new Lot_Request_Price_Table__c();
        lotReqPriceTable.Fab__c = 'FAB 2';
        lotReqPriceTable.Geometry__c = '0.010UM';
        insert lotReqPriceTable;
        
        Fab_Cycle_Time_Table__c fabCycTimeTable = new Fab_Cycle_Time_Table__c();
        fabCycTimeTable.Fab__c = 'FAB 2';
        fabCycTimeTable.Geometry__c = '0.010UM';
        insert fabCycTimeTable;
        
                
     string stdRecId=Schema.SObjectType.Lot_Request__c.getRecordTypeInfosByName().get('Standard Lot Service Request').getRecordTypeId();
        Lot_Request__c lotReq = new Lot_Request__c();
        lotReq.Lot_Request_Type__c = 'Standard Expedite';
        lotReq.Stage__c = 'Acknowledged by CSR';
        lotReq.RecordTypeId=stdRecId;
        lotReq.Fab__c = 'FAB 2';
        lotReq.Date_Customer_Submitted_Request__c = System.today();
        lotReq.Account__c =acc.id;
        lotReq.New_Customer_Requested_Date_CRD_CSR__c = System.Today() + 7;
        lotReq.Does_Customer_Accept_Standard_Pricing__c = 'Yes';
        lotReq.Reason_Cancelled_by_Customer__c='Did Not Agree with Pricing';
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
        Approval.ProcessSubmitRequest req = new Approval.ProcessSubmitRequest();
           req.setComments('Submitted for approval. Please approve.');
            req.setObjectId(lotReq.Id);
            // submit the approval request for processing
            Approval.ProcessResult result = Approval.process(req);
        List<ProcessInstance> processInstances = [select Id, Status from ProcessInstance where TargetObjectId = :lotReq.id];
        
        
        ApexPages.StandardController sc = new ApexPages.StandardController(lotReq);
        VoidLotRequestController vlrst = new VoidLotRequestController(sc);
        Test.startTest();
        PageReference pageRef = Page.VoidLotRequest;
        pageRef.getParameters().put('id', String.valueOf(lotReq.Id));
        Test.setCurrentPage(pageRef);
       
         vlrst.recallApproval();
         vlrst.Cancel();
         list<Lot_Request__c>lrList= new list<Lot_Request__c>();
         lrList.add(lotReq);
         LotApprovalProcessUtil.sendEmailtoApprovers(lrList);
 		Test.stopTest();
 }
 
  private static Account getAccount(string AccountName)
    {
        Account acct = [SELECT Id, Name FROM Account Where Name =: AccountName];
        
        return acct;
    }


}