/*
Type Name: DealGrading_CreateSnapShot
Author: Vijay Vemuru
CreateSnapshot:- This method captures a snapshot i.e year wise details are captured from Quaterly Revenues of opportunity. 
The snapshot is taken and is displayed as Related list on Deal Grading Object  
DeleteExistingSnapshot - This method deletes the existing Deal Grading Revenue snapshot on a newly created record to avoid duplication and this status is controlled by Approval Process

Test Class: DealGrading_CreateSnapShotTest
History:  6/21/2016   code creation
*/            
public class DealGrading_CreateSnapShot{

//Logic for creating a snapshot if Deal Grading status=Complete - Proceed to Quote

    public static void createSnapshot(List<Deal_Grading__c> Deal_Grading, map<id,Deal_Grading__c> oldMap){
    
        set<id> oppIds      =   new set<id>(); 
        map<id,map<string,quarterRevenueWrapper>> quaterRevMap = new map<id,map<string,quarterRevenueWrapper>>();
        list<Design_Win_Approval_History__c> dgRevenueList = new list<Design_Win_Approval_History__c>();
        
        for(Deal_Grading__c dg: Deal_Grading) {
            if(dg.Deal_Grading_status__c != oldMap.get(dg.id).Deal_Grading_status__c &&  
               dg.Deal_Grading_status__c == 'Complete - Proceed to Quote' 
               ) {
               
              oppIds.add(dg.Opportunity1__c);
            }       
        }     
        if(oppIds != null && oppIds.size() > 0) {
            
            try{
                for(Quarterly_Revenue_Object__c qRev :  [SELECT Current_Year__c,Fiscal_Quarter__c,year__c, NRE__c, ASP__c, Volume__c, Revenue__c, Opportunity__c 
                                                        FROM Quarterly_Revenue_Object__c WHERE Opportunity__c IN:oppIds]){
                    string fisYear          =   qrev.Fiscal_Quarter__c.substring(0,4);
                    integer currentyear     =   integer.valueOf(fisYear);
                    quarterRevenueWrapper  revenueDetails = new quarterRevenueWrapper();
                        if(quaterRevMap.containsKey(qRev.opportunity__c) && quaterRevMap.get(qRev.opportunity__c) != null &&
                            quaterRevMap.get(qRev.opportunity__c).containsKey(fisYear) && quaterRevMap.get(qRev.opportunity__c).get(fisYear) != null
                            ){
                            revenueDetails = quaterRevMap.get(qRev.opportunity__c).get(fisYear);
                            
                        } 
                        
                        revenueDetails.recCount = revenueDetails.recCount+1;    
                        if(revenueDetails.year  < currentyear) {
                            revenueDetails.year = currentyear;
                            
                        }
                        revenueDetails.ASP          =   ((revenueDetails.ASP*(revenueDetails.recCount -1) + (qRev.ASP__c != null ?qRev.ASP__c:0 ))/revenueDetails.recCount);
                        revenueDetails.NRE          =   revenueDetails.NRE+(qRev.NRE__c != null?qRev.NRE__c:0);
                        revenueDetails.volume       =   revenueDetails.volume+(qRev.volume__c != null ? qRev.volume__c:0);
                        revenueDetails.totalRev     =   revenueDetails.totalRev+(qRev.Revenue__c != null ? qRev.Revenue__c:0);
                        
                        if(quaterRevMap.containsKey(qRev.opportunity__c) && quaterRevMap.get(qRev.opportunity__c) != null){
                        
                            quaterRevMap.get(qRev.Opportunity__c).put(fisYear,revenueDetails);
                        }else{
                            quaterRevMap.put(qRev.Opportunity__c,new map<string,quarterRevenueWrapper>{fisYear=>revenueDetails});
                            
                        }
                    }
                    
                }catch(Exception excp) {
                    GlobalUtility.logMessage('Error','DealGrading_CreateSnapShot','createSnapshot','','Exception while getting the Deal Grading recordtype',String.valueof(excp.getMessage()),'','Deal Grading',excp,0);
                }
            id rectypeId = null;
            try{
                rectypeId  = [SELECT id FROM RecordType WHERE  developername=: 'Deal_Grading' AND SobjectType=: 'Design_Win_Approval_History__c' ].id;
            } catch(Exception excp) {
                GlobalUtility.logMessage('Error','DealGrading_CreateSnapShot','createSnapshot','','Exception while getting the Quarterly Revenue records ',String.valueof(excp.getMessage()),'','Deal Grading',excp,0);
            }
            for(Deal_Grading__c dg: Deal_Grading) {
              if(quaterRevMap.containsKey(dg.Opportunity1__c) && quaterRevMap.get(dg.Opportunity1__c) != null) {
                  for(quarterRevenueWrapper revenueDetails : quaterRevMap.get(dg.Opportunity1__c).values()){
                        Design_Win_Approval_History__c DG_rev  =   new Design_Win_Approval_History__c();   //create new record of Deal_Grading_Revenue__c
                            DG_rev.recordtypeid         =   rectypeId;  
                            DG_rev.Deal_Grading__c      =   dg.id;
                            DG_rev.Opportunity__c       =   dg.Opportunity1__c;
                            DG_rev.ASP__c               =   revenueDetails.ASP;
                            DG_rev.NRE__c               =   Integer.ValueOF(revenueDetails.NRE);
                            DG_rev.Volume__c            =   revenueDetails.volume; 
                            DG_rev.Total_Revenue__c     =   revenueDetails.totalRev; 
                            DG_rev.Year__c              =   String.valueOf(revenueDetails.year);
                        dgRevenueList.add(DG_rev);
                    }
                } 
            }    
            if(!dgRevenueList.isEmpty()){
                try{
                    insert dgRevenueList;
                } catch(Exception excp){ GlobalUtility.logMessage('Error','DealGrading_CreateSnapShot','createSnapshot',dgRevenueList[0].Deal_Grading__c,'Exception while inserting the revenues',String.valueof(excp.getMessage()),'','Deal Grading',excp,0);           
              }
            }
        }         
    }
    // deleting existing Deal Grading Revenue snapshot on a newly created record to avoid duplication
    public static void DeleteExistingSnapshot(List<Deal_Grading__c> Deal_Grading,map<id,Deal_Grading__c> oldMap){
        set<id> dgReviewIds = new set<id>();
        list<Design_Win_Approval_History__c> delDGRevList = new List<Design_Win_Approval_History__c>();
        for(Deal_Grading__c dg: Deal_Grading) {
            if(dg.Deal_Grading_status__c != oldMap.get(dg.id).Deal_Grading_status__c && 
               dg.Deal_Grading_status__c == 'Complete - Proceed to Quote' 
               ) {
                if(dg.Deal_Grading_status__c    ==  'Complete - Proceed to Quote'){
                    dgReviewIds.add(dg.id);
                }
            }
        }
        
        try{
            delDGRevList = [SELECT id FROM Design_Win_Approval_History__c WHERE Deal_Grading__c IN: dgReviewIds];
            if(!delDGRevList.isEmpty()) {
                delete delDGRevList;
            }
        } catch(Exception excp) {
                GlobalUtility.logMessage('Error','DealGrading_CreateSnapShot','DeleteExistingSnapshot','','Exception while deleting the Design_Win_Approval_History',String.valueof(excp.getMessage()),'','Deal Grading',excp,0);
            }
    } 
       
    //Wrapper class is need to write the logic for calculating sum, Average, Maximum values
    public class quarterRevenueWrapper{
        
        public integer year;
        public integer recCount;
        public decimal ASP;
        public decimal NRE;
        public decimal volume;
        public decimal totalRev;
        
        public quarterRevenueWrapper() {
            year        =   0;
            ASP         =   0;
            NRE         =   0;
            volume      =   0;
            totalRev    =   0;
            recCount    =   0;
        }
        
    }

}