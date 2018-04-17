/*
@Author < Akash >
@name <AcceptedIPRequestTest>
@CreateDate < 1/5/2017 >
@Description < test class for AcceptedIPRequest trigger>
@Version <1.0>
*/
@isTest
private class RFQIPR_triggerTest{ 
  @isTest 
  static void testAcceptedIPRequestTrigger(){       
    test.startTest();
    
    IP_Request__c ipr = IPRDataFactory.createIPR(new Map<String,Object>());
    RFQ__c rfq =  IPRDataFactory.createRFQ(new Map<String,Object>());
    RFQ_IPR__c rfqipr1 = new RFQ_IPR__c(IP_Request__c = ipr.id, RFQ__c = rfq.Id,AcceptedbyCustomer__c = true);
    RFQ_IPR__c rfqipr2 = new RFQ_IPR__c(IP_Request__c = ipr.id, RFQ__c = rfq.Id,AcceptedbyCustomer__c = true);
    insert rfqipr1 ;
    insert rfqipr2 ;
    update rfqipr1 ;
    delete rfqipr1 ;
    test.stopTest();
    
   }
}