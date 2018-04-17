/*
Type Name: BnPTRtriggerHelper
Author: Deepti Narayan Biswal
Project Name: DIW Step Down Track 2 (BnP) 
Created Date: 09282016
Description: This class is helper class for BnPTRtrigger.
Change History:
*/
public class BnPTRtriggerHelper{
    public static void createRFQrecords(Set<Id> trSet){
        List<Request_Information__c> rfqListtoinsert = new List<Request_Information__c>();
        Id rfqRecTypeId = [SELECT Id,Name FROM RecordType WHERE SobjectType='Request_Information__c' AND DeveloperName='RFQ_Contract'].Id;
        for(Customer_Requirement__c custReq : [SELECT Id,Name,Opportunity__c,Opportunity__r.Name,Opportunity__r.AccountId,RecordType.DeveloperName FROM 
                                                Customer_Requirement__c WHERE Id IN: trSet]){
            if(custReq.RecordType.DeveloperName == 'Contract_Technical_Requirment'){
                Request_Information__c rfq = new Request_Information__c();
                rfq.Opportunity__c = custReq.Opportunity__c;
                rfq.Account__c = custReq.Opportunity__r.AccountId;
                rfq.Customer_Requirement__c = custReq.Id;
                rfq.Name = custReq.Opportunity__r.Name+'-'+custReq.Name+'--Contract RFQ';
                rfq.RecordTypeId = rfqRecTypeId;
                rfq.Quote_Status__c= 'Accept';
                rfqListtoinsert.add(rfq);
            }
        }
        if(rfqListtoinsert.size() > 0){
            insert rfqListtoinsert;
        }
    }
}