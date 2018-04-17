/*
Type Name: BNP_LockGoogleSheetCtrl
Author: Deepti Narayan Biswal
Project Name: DIW Step Down Track 2 (BnP) 
Created Date: 08232016
Description: This class serves controller for BNP_LockGoogleSheet page.
Test Class: 
Change History:
*/
global class BNP_LockGoogleSheetCtrl{
    
    @remoteAction
    global static bnpwrapper getRFQDetail(string rIid){
        
        List<RFQ_Routing__c> rfqlist=[select id,Name,createddate,FileId__c,RFQ__c,RFQ__r.device__c,RFQ__r.Opportunity__c,RFQ__r.FolderId__c,RFQ__r.Account__r.Name,RFQ__r.Opportunity__r.Name from RFQ_Routing__c where RFQ__c=:rIid Order BY CreatedDate LIMIT 1];
        
        bnpwrapper routingwrap = new bnpwrapper(rfqlist[0]);
        return routingwrap;
        
    }
    
    global class bnpwrapper{
        global RFQ_Routing__c routing;
        global String mail;
        
        global bnpwrapper(RFQ_Routing__c rfqRout){
            routing = rfqRout;
            mail = UserInfo.getUserEmail();
        }
    }
}