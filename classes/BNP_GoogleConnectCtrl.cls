/*
Type Name: BNP_GoogleConnectCtrl
Author: Vijay Vemuru
Project Name: DIW Step Down Track 2 (BnP) 
Created Date: 06302016
Description: This class serves controller for BNP_LockGoogleSheet page.
Test Class: 
Change History:
*/
global class BNP_GoogleConnectCtrl{

    @remoteAction
    global static List<RFQ_Tasks_Routing__c>  getTasks(string rfqid){
        //select id,RFQ__c,RFQ__r.Opportunity__c from RFQ_Routing__c
        
         List<RFQ_Routing__c> rfqlist=[select id,FileId__c,RFQ__c,RFQ__r.Opportunity__c from RFQ_Routing__c where id=:rfqid];
         
         List<RFQ_Tasks_Routing__c> rtrList=[select id,Name,Task_Name__c from RFQ_Tasks_Routing__c where Related_RFQ_Routing__c=:rfqid order by createddate asc];
        
        //select id,Name  from RFQ_Tasks_Routing__c where Related_RFQ_Routing__c='aEKN00000008OIK'
        return rtrList;
    }
    
    @remoteAction
    global static RFQ_Routing__c  getRFQRoutingDetail(string rfqid){
        //select id,RFQ__c,RFQ__r.Opportunity__c from RFQ_Routing__c
        
         List<RFQ_Routing__c> rfqlist=[select id,Name,createddate,FileId__c,RFQ__c,RFQ__r.device__c,RFQ__r.Opportunity__c,RFQ__r.FolderId__c,RFQ__r.Account__r.Name,RFQ__r.Opportunity__r.Name,RFQ__r.Customer_Requirement__c,RFQ__r.Customer_Requirement__r.Name from RFQ_Routing__c where id=:rfqid];
         
        return rfqlist[0];
        
    }
    
    
    @remoteAction
    global static void  updateRequestInformation(string recid,string folderId){
    
       Request_Information__c ri=new Request_Information__c(id=recid,Folderid__c=folderId);
        update ri; 
        
        
    }
    
    
    @remoteAction
    global static void  updateRFQ(string recid,string fileId){
    
       RFQ_Routing__c rfq=new RFQ_Routing__c(id=recid,fileId__c=fileId);
        update rfq; 
        
        
    }


}