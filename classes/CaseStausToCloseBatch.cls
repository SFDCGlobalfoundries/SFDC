/*********************************************************************************/
  // Purpose      : CaseStausToCloseBatch class is responsible for major responsibilities / business logic required in UCM Project
  // Date created : 02 May, 2017
  // Created by   : GlobalFoundries
  // Author       : Manikumar M 
  // Description  : Responsible to close Case when all the Bug/WR(s) associated with a Case are close.
  // Change History 
  //    1. [Modify By] [Modify Date] 
  //        [Reason] :
/*********************************************************************************/
global class CaseStausToCloseBatch implements Database.Batchable<sObject> {
    global Boolean allChildsClosed;
    global string query;
    
    
    global database.querylocator start(Database.BatchableContext BC) {
        //query = 'Select id,Status,Public_comments__c from Case where (NOT(Status LIKE \'%Closed%\'))';
        query = 'Select id,Status,Public_comments__c from Case where Status =\'Resolved - Pending PDK release\'';
        return Database.getQueryLocator(query);    
    }
    
    global void execute(Database.BatchableContext BC, List<Case> scope){
        try {
            Set<Id> caseIdSet = new set<Id>();
            List<Case> caseObjList = new List<Case>();
            Map<Id,List<CaseBugAssociation__c>> ChildRecMap = new Map<Id,List<CaseBugAssociation__c>>();
            for(Case caseObj:scope){
                caseIdSet.add(caseObj.Id);
            }
            
            if(caseIdSet.size() > 0) {        
                for (CaseBugAssociation__c bugObj :[ SELECT id,Status__c,Case__c from CaseBugAssociation__c where Case__c IN :caseIdSet]) {
                    if(ChildRecMap.containsKey(bugObj.Case__c)) {
                        ChildRecMap.get(bugObj.Case__c).add(bugObj);
                    }
                    else{
                        ChildRecMap.put(bugObj.Case__c,new List<CaseBugAssociation__c>{bugObj});
                    }
                }
            }
            
            for(Id CaseId :ChildRecMap.keyset()){
                allChildsClosed=true;
                for(CaseBugAssociation__c caseBugObj :ChildRecMap.get(CaseId)){
                    if(caseBugObj.Status__c != 'Closed'){
                        allChildsClosed=false;
                        break;
                    }
                }
                if(allChildsClosed==true){
                    caseObjList.add(New Case(Id=CaseId,Bulk_Update__c=true,Status = 'Closed - Resolved',Last_Case_Comments__c ='The Bug(s) associated with this Case have closed/shipped'));
                }
                
            }
            if(caseObjList.size()>0){
                Database.update(caseObjList);
                
                List<FeedItem> caseFeedList =  new List<FeedItem>();
                
                for(Integer i=0;i<caseObjList.size();i++){
                    FeedItem feedItemObj = new FeedItem(
                        Body = caseObjList[i].Last_Case_Comments__c,
                        ParentId = caseObjList[i].Id,
                        Status = 'Published',
                        VISIBILITY = 'AllUsers'
                    );
                    caseFeedList.add(feedItemObj);
                }
                
                Database.insert(caseFeedList);
                   
            }
            
             if(Test.isRunningTest()) {
                        throw new applicationException('In Test Mode');
                } 
        }
        catch (Exception e) {
            ApplicationLogWrapper alw=new ApplicationLogWrapper();
            alw.source = CaseStausToCloseBatch.class.getName();
            alw.sourceFunction ='execute()';
            alw.ApplicationName='Case Management';                
            alw.referenceInfo = 'Case';
            alw.logMessage ='Error Message='+e.getMessage()+' At Line Number='+e.getLineNumber()+' Stack Trace='+e.getStackTraceString();
            alw.debugLevel ='Error';
            alw.logCode =e.getTypeName();
            alw.ex=e.getCause();
            GlobalUtility.logMessage(alw);
        }     
    }
    global void finish(Database.BatchableContext BC){
        
    }  
public class applicationException extends Exception {}     

}