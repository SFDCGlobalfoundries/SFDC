/*
Type Name: BNP_IPRCtrl
Author: Devendra Babu
Project Name: DIW Step Down Track 2 (BnP) 
Created Date: 6/27/2016
Description: This class serves controller for BNP_IPListView Page.
Test Class: 
Change History:
*/
public class BNP_IPRCtrl{
    
    public Request_Information__c reqInfo{get;set;}
    public List<IP__c> ipDK{get;set;}    
    
    public BNP_IPRCtrl(ApexPages.StandardController controller){
        reqInfo = (Request_Information__c)controller.getRecord();
        if(reqInfo != null){
            reqInfo = [select id,Opportunity__c, Opportunity__r.Process_Geometry__c from Request_Information__c where id=:reqInfo.Id limit 1];
            ipDK=[select id,Name,IP_ID__c,IP_Technology__c,IP_Type__c from IP__c where IP_Geometry__c=:reqInfo.Opportunity__r.Process_Geometry__c];
        }
    }
    
}