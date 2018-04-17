/*
@Author < Akash >
@name <IPRequestRecordTest>
@CreateDate < 1/5/2017 >
@Description < test class for IPRequestRecord>
@Version <1.0>
*/
@isTest
private class IPRequestRecordTest{

  
    @testSetup
    static void testDataSetup(){
       DataUtilTest.loadEnvironmentVariables();
       
       Map<String,Object> fieldValueMap = new Map<String,Object>();
        fieldValueMap.put('Name', 'MYTEST ACCOUNT1');  
        fieldValueMap.put('Account_Type__c', 'Customer');                           
        fieldValueMap.put('sub_type__c', 'Indirect');        
        fieldValueMap.put('site_department__c', 'IT');  
        fieldValueMap.put('Account_Manager__c', userinfo.getuserid());        
        fieldValueMap.put('transaction_type__c', 'Non-Transactional');                          
        fieldValueMap.put('region__c', 'US');        
        fieldValueMap.put('Corporate_Address_1__c', 'Test Address 1');          
        fieldValueMap.put('Corporate_City__c', 'Test City');                
        fieldValueMap.put('Corporate_Country__c', 'Singapore');
        fieldValueMap.put('Bill_To_Address_1__c', 'Test Address 1');          
        fieldValueMap.put('Bill_To_City__c', 'Test City');            
        fieldValueMap.put('Bill_To_Country__c', 'Singapore');
        
        AccountDataFactory.createAccount(fieldValueMap); 
    }
     
  @isTest 
  static void testIPRequestRecord(){  
  
     // Creating the original configurator
        Account acc = getAccount('MYTEST ACCOUNT1');        
        Opportunity opp = createOpp(acc.Id);  
        Opportunity_Program__c oppProg = createOppProg(acc.Id,opp.Id); 
        Device__c dev = DeviceUtilTest.createCMPWDevice(acc.Id,oppProg.Id);     
    test.startTest();
    insert dev;
    
    IP_Request__c ipr = IPRDataFactory.createIPR(new Map<String,Object>());
    IP_Request__c ipr2 = IPRDataFactory.createIPR(new Map<String,Object>());
    ipr2.device__c = dev.id;
    update ipr2;
    RFQ__c rfq =  IPRDataFactory.createRFQ(new Map<String,Object>());
    rfq.Device__c = dev.Id;
    update rfq ;
    RFQ_IPR__c rfqipr1 = new RFQ_IPR__c(IP_Request__c = ipr.id, RFQ__c = rfq.Id,AcceptedbyCustomer__c = true);
    RFQ_IPR__c rfqipr2 = new RFQ_IPR__c(IP_Request__c = ipr.id, RFQ__c = rfq.Id,AcceptedbyCustomer__c = true);
    insert rfqipr1 ;
    insert rfqipr2 ;
   
    Pagereference pg = Page.IP_Request;
    Test.setCurrentPage(pg);
    ApexPages.currentPage().getparameters().put('id',rfq.id);
    ApexPages.currentPage().getparameters().put('name',rfq.id);
    IPRequestRecord ipReq = new IPRequestRecord();
    ipReq.getRfqId();
    List<IPRequestRecord.ipRequest> lstIpr = ipReq.getIPR();
    for(IPRequestRecord.ipRequest ip : lstIpr) {
      ip.selected = true;
    }
    
    ipReq.processSelected();
    list<string> lstiprs  =ipReq.finaliprequestrecords;
    string msg = ipReq.msg;
    ipReq.cancel();
    test.stopTest();
    
   }
   
     //Static method to create Opportunity test record
    static Opportunity createOpp(Id acctId){
        Opportunity opp = new Opportunity(Name = 'Test Opportunity1',
                                          AccountId = acctId,
                                          StageName = '1. Discovery',
                                          Market_Segment__c = 'Automotive',
                                          Target_Process_Node__c = '14XM',
                                          Process_Platform__c = 'GF Baseline',
                                          Opportunity_Sourcing_Type__c = 'First Source',
                                          Fab_Split__c = 100,
                                          CloseDate = date.newinstance(2012, 12, 21),
                                          Process_Geometry__c = '0.014UM',
                                          Fab_Assignment_1__c = 'FAB 1',
                                          Process_Family__c = 'Super Low Power');
        
        insert opp;
        return opp;
    }
    
    //Static method to create Opportunity Program test record
    static Opportunity_Program__c createOppProg(Id acctId, Id oppId){
        Opportunity_Program__c opProg = 
                    new Opportunity_Program__c(Name = 'Test OppProg1',
                                               Account__c = acctId,
                                               Opportunity__c = oppId);
        insert opProg;
        return opProg;
    }
    
     private static Account getAccount(string AccountName){
        Account acct = [SELECT Id, Name FROM Account Where Name =: AccountName];
        
        return acct;
    }
}