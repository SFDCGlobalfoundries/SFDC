/**
@Author < Meghna Ganguly >
@name < BnP_OppStageScheduleCtrl >
@CreateDate < 11/25/2016 >
@Description < This class is used as a controller for component which displays opportunity schedule >
@Version <1.0>
*/
public class BnP_OppStageScheduleCtrl {
    // variable for opportunity id which is an attribute in component
    public ID oppId { get;set; }
    // variable for opportunity record
    public Opportunity opp { get;set; }
   
    // constructor
    public BnP_OppStageScheduleCtrl() {}
    
    // method returns list of wrapper which have details of stage history - stage name, start date and end date
    public List<StageWrapperClass> getStageHistorylist() {
        
        List<OpportunityFieldHistory> oppHistoryList = new List<OpportunityFieldHistory>();
        List<StageWrapperClass> stageHistlist = new List<StageWrapperClass>();
        try {
             String ObjName = oppId.getSObjectType().getDescribe().getName();   
             if(ObjName == Schema.SobjectType.Opportunity.Name) {
             
                  opp = [Select Id, Name, StageName from Opportunity where Id = :oppId]; 
                 
                 System.debug('@@opp'+ opp);
                 
                 if(Test.isRunningTest()){  //if TEST, create dummy OpportunityFieldHistory
                     oppHistoryList.add(new OpportunityFieldHistory(OpportunityId=opp.id, Field='StageName'));
                 } else {
                     oppHistoryList = [Select Id, CreatedById, CreatedDate, Field, NewValue, OldValue, 
                                  Opportunity.CreatedDate from OpportunityFieldHistory 
                                 Where Field = 'StageName' and OpportunityId = :opp.Id ORDER BY CreatedDate];
                 }
                  StageWrapperClass stw = new StageWrapperClass();   
                  System.debug('@@oppHistoryList'+ oppHistoryList);
                  
                  stw.stage = returnFormattedString(oppHistoryList[0].OldValue);
                  stw.startdate = returnFormattedDate(oppHistoryList[0].Opportunity.CreatedDate);
                  stw.enddate = returnFormattedDate(oppHistoryList[0].CreatedDate);
                  stageHistlist.add(stw);   
                      
                  for(Integer i = 0; i < oppHistoryList.size(); i++){
                      StageWrapperClass stw1 = new StageWrapperClass();   
                      if (i<(oppHistoryList.size()-1)){
                          stw1.stage = returnFormattedString(oppHistoryList[i].NewValue) ;
                          stw1.startdate = returnFormattedDate(oppHistoryList[i].CreatedDate);
                          stw1.enddate = returnFormattedDate(oppHistoryList[i+1].CreatedDate);
                     
                      } else{
                          stw1.stage = returnFormattedString(oppHistoryList[i].NewValue) ;
                          stw1.startdate = returnFormattedDate(oppHistoryList[i].CreatedDate);
                          stw1.enddate = null;
                      }
                      
                      stageHistlist.add(stw1);
                  }
            }
           
        } catch(Exception e) {
        
            GlobalUtility.logMessage('Error','BnP_OppStageScheduleCtrl','getStageHistorylist','','Exception while getting Opportunity stages',String.valueof(e.getMessage()),'','Customer Decision',e,0);
        }
        return stageHistlist;
    }
    
    public String returnFormattedDate(DateTime dt) {
        if(dt != null) return Date.valueOf(dt).format();
        else return '';
    }
    
    public String returnFormattedString(Object obj) {
        if(obj != null) return String.valueOf(obj);
        else return '';
    }
    
    // wrapper class 
    public class StageWrapperClass {
        // name of stage
        public String stage      {get;set;}
        // date when opportunity entered the stage
        public String startdate  {get;set;}
        // date when opportunity leave the stage
        public String enddate    {get;set;}
     } 
    
  }