/*
Type Name: BnPRequestInfo_RevenueSnapShot
Author: Poulami Saha
Project Name: DIW Step Down Track 2 (BnP)
Created Date: 08/02/2017
Description: CreateSnapshot:- This method captures a snapshot i.e year wise details are captured from Quaterly Revenues of opportunity. 
The snapshot is taken and is displayed as Related list on Request Information Object  
DeleteExistingSnapshot - This method deletes the existing Request Information Revenue snapshot on a newly created record to avoid duplication.
Test Class: BnPRequestInfo_RevenueSnapShotTest
History:  08/02/2017   code creation
*/            
public class BnPRequestInfo_RevenueSnapShot{

//Logic for creating a snapshot if Request Information Quote status=Accept or Reject

    public static void createSnapshot(List<Request_Information__c> Req_Info, map<id,Request_Information__c> oldMap){
    
        set<id> oppIds      =   new set<id>(); 
        map<id,map<string,quarterRevenueWrapper>> quaterRevMap = new map<id,map<string,quarterRevenueWrapper>>();
        list<Request_Information_Revenue_Snap__c> rfqRevenueList = new list<Request_Information_Revenue_Snap__c>();
        
        for(Request_Information__c reqInfo: Req_Info) {
            if(reqInfo.Quote_Status__c != oldMap.get(reqInfo.id).Quote_Status__c &&  
               (reqInfo.Quote_Status__c == 'Accept' || reqInfo.Quote_Status__c == 'Reject') 
               ) {
               
              oppIds.add(reqInfo.Opportunity__c);
            }  
            
        }     
        if(oppIds != null && oppIds.size() > 0) {
            
            try{
                for(Quarterly_Revenue_Object__c qRev :  [SELECT Current_Year__c,Fiscal_Quarter__c,year__c, NRE__c, ASP__c, Volume__c, Revenue__c,Turnkey_ASP__c, Opportunity__c, Deliverable_Type__c, ASP_Module_Chip__c, Volume_Module_Chip__c 
                                                        FROM Quarterly_Revenue_Object__c WHERE Opportunity__c IN:oppIds]){
                    string fisYear          =   qrev.Fiscal_Quarter__c.substring(0,4);
                    integer currentyear     =   integer.valueOf(fisYear);
                    quarterRevenueWrapper  revenueDetails = new quarterRevenueWrapper();
                        if(quaterRevMap.containsKey(qRev.opportunity__c) && quaterRevMap.get(qRev.opportunity__c) != null &&
                            quaterRevMap.get(qRev.opportunity__c).containsKey(fisYear) && quaterRevMap.get(qRev.opportunity__c).get(fisYear) != null
                            ){
                            revenueDetails = quaterRevMap.get(qRev.opportunity__c).get(fisYear);
                            
                        } 
                        if(revenueDetails.year  < currentyear) {
                            revenueDetails.year = currentyear;
                        }
                        revenueDetails.volume       =   revenueDetails.volume+(qRev.volume__c != null ? qRev.volume__c:0);
                        revenueDetails.totalRev     =   revenueDetails.totalRev+(qRev.Revenue__c != null ? qRev.Revenue__c:0);
                
                        Decimal totalAsp    =   (revenueDetails.asp * revenueDetails.recCount)+ (qrev.asp__c != null ?  qrev.asp__c :0);
                        Decimal totalAspModChip    =   (revenueDetails.aspModChip * revenueDetails.recCount) + (qrev.ASP_Module_Chip__c != null ?  qrev.ASP_Module_Chip__c :0);
                        revenueDetails.recCount    =   revenueDetails.recCount+1;
                        revenueDetails.asp         =   (totalAsp/revenueDetails.recCount);
                        revenueDetails.aspModChip         =   (totalAspModChip/revenueDetails.recCount);
                        revenueDetails.volumeModChip      =   revenueDetails.volumeModChip+(qrev.Volume_Module_Chip__c != null ? qrev.Volume_Module_Chip__c:0);
                        if(quaterRevMap.containsKey(qRev.opportunity__c) && quaterRevMap.get(qRev.opportunity__c) != null){
                        
                            quaterRevMap.get(qRev.Opportunity__c).put(fisYear,revenueDetails);
                        }else{
                            quaterRevMap.put(qRev.Opportunity__c,new map<string,quarterRevenueWrapper>{fisYear=>revenueDetails});
                            
                        }
                    }
                    
                }catch(Exception excp) {
                    GlobalUtility.logMessage('Error','DealGrading_CreateSnapShot','createSnapshot','','Exception while getting the Deal Grading recordtype',String.valueof(excp.getMessage()),'','Deal Grading',excp,0);
                }

            for(Request_Information__c reqInfo: Req_Info) {
              if(quaterRevMap.containsKey(reqInfo.Opportunity__c) && quaterRevMap.get(reqInfo.Opportunity__c) != null) {
                  for(quarterRevenueWrapper revenueDetails : quaterRevMap.get(reqInfo.Opportunity__c).values()){
                        Request_Information_Revenue_Snap__c RFQ_rev  =   new Request_Information_Revenue_Snap__c();   //create new record of Deal_Grading_Revenue__c
                        RFQ_rev.Request_Information__c      =   reqInfo.id;
                        RFQ_rev.ASP__c               =   revenueDetails.ASP;
                        RFQ_rev.Volume__c            =   revenueDetails.volume; 
                        RFQ_rev.Total_Revenue_K__c     =   revenueDetails.totalRev; 
                        RFQ_rev.Year__c              =   String.valueOf(revenueDetails.year);
                        RFQ_rev.ASP_Module_Chip__c               =   revenueDetails.aspModChip;
                        RFQ_rev.Volume_Module_Chip__c            =   revenueDetails.volumeModChip; 
                        rfqRevenueList.add(RFQ_rev);
                    }
                } 
            }    
            if(!rfqRevenueList.isEmpty()){
                try{
                    insert rfqRevenueList;
                } catch(Exception excp){ GlobalUtility.logMessage('Error','DealGrading_CreateSnapShot','createSnapshot',rfqRevenueList[0].Request_Information__c,'Exception while inserting the revenues',String.valueof(excp.getMessage()),'','Deal Grading',excp,0);           
              }
            }
        }         
    }
    // deleting existing Request Information Revenue snapshot on a newly created record to avoid duplication
    public static void DeleteExistingSnapshot(List<Request_Information__c> Request_Information,map<id,Request_Information__c> oldMap){
        set<id> reqInfoIds = new set<id>();
        list<Request_Information_Revenue_Snap__c> reqInfoRevList = new List<Request_Information_Revenue_Snap__c>();
        for(Request_Information__c dg: Request_Information) {
            if(dg.Quote_Status__c != oldMap.get(dg.id).Quote_Status__c && 
               (dg.Quote_Status__c == 'Accept' || dg.Quote_Status__c == 'Reject') 
               ) {
                if(dg.Quote_Status__c    ==  'Accept' || dg.Quote_Status__c    ==  'Reject'){
                    reqInfoIds.add(dg.id);
                }
            }
        }
        
        try{
            reqInfoRevList = [SELECT id FROM Request_Information_Revenue_Snap__c WHERE Request_Information__c IN: reqInfoIds];
            if(!reqInfoRevList.isEmpty()) {
                delete reqInfoRevList;
            }
        } catch(Exception excp) {
                GlobalUtility.logMessage('Error','DealGrading_CreateSnapShot','DeleteExistingSnapshot','','Exception while deleting the Design_Win_Approval_History',String.valueof(excp.getMessage()),'','Deal Grading',excp,0);
            }
    } 
       
    //Wrapper class is need to write the logic for calculating sum, Average values
    public class quarterRevenueWrapper{
        
        public integer year;
        public integer recCount;
        public decimal ASP;
        public decimal NRE;
        public decimal volume;
        public decimal totalRev;
        public Decimal TRNYASP;
        public Decimal aspModChip{get;set;}
        public Decimal volumeModChip{get;set;}
        public String delType{get;set;}
        
        public quarterRevenueWrapper() {
            year        =   0;
            ASP         =   0;
            NRE         =   0;
            volume      =   0;
            totalRev    =   0;
            recCount    =   0;
            TRNYASP = 0;
            aspModChip         =   0;
            volumeModChip      =   0;
            delType = '';
        }
        
    }

}