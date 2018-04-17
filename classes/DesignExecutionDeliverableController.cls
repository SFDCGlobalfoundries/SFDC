/******************************************************************************************************
Name : DesignExecutionDeliverableController
Description : Controller class is used for creating records in google docs for Design Deliverable Question.
Project: Global Foundries
CreatedBy : Sandesh
Modified By : Abhishek/Sakthi
******************************************************************************************************/
global class DesignExecutionDeliverableController {
    public List<Design_Deliverable_Questions__c> designDeliverableData{get;set;}
    public string designDeliveryJson{get;set;}   
    public string DEID{get;set;}
    public string DEName{get;set;}
    public string GoogleSheetID{get;set;}

    
    public DesignExecutionDeliverableController(){
        designDeliveryJson = JSON.serialize(getDesignDeliverableMap());
        system.debug('-----designDeliveryJson----'+designDeliveryJson);
        DEID = ApexPages.currentPage().getParameters().get('DEID');
        DEName = ApexPages.currentPage().getParameters().get('DEName');
        GoogleSheetID =  ApexPages.currentPage().getParameters().get('GoogleSheetID');
    }
    
    /**
    * @description getDesignDeliverableMap method is used to create the Map with key milestone Name and value as a 
    *              List of question  
    * @param    No Parameter
    * @return   Map 
    */
    public Map<String,List<Design_Deliverable_Questions__c>> getDesignDeliverableMap(){
        Map<String,List<Design_Deliverable_Questions__c>> ddQuestionMap = new Map<String,List<Design_Deliverable_Questions__c>>();
        for(Design_Deliverable_Questions__c ddQuestion : [SELECT id,Name,Comments__c,Deliverables__c,
                                                          Delivered_Date__c,Milestone__c,Order__c 
                                                          FROM Design_Deliverable_Questions__c]){
           if(ddQuestion.Deliverables__c !=null)
                ddQuestion.Deliverables__c = ddQuestion.Deliverables__c.replaceAll('(\\r\\n\"|\\n|\\r|\")', '');
           if(ddQuestion.Comments__c !=null)
                ddQuestion.Comments__c = ddQuestion.Comments__c.replaceAll('(\\r\\n\"|\\n|\\r|\")', '');                                              
           if(ddQuestionMap.containsKey(ddQuestion.Milestone__c)){
              	ddQuestionMap.get(ddQuestion.Milestone__c).add(ddQuestion);
            }else{
                ddQuestionMap.put(ddQuestion.Milestone__c, new List<Design_Deliverable_Questions__c>{ddQuestion});
            }
        }
        return ddQuestionMap;
    }
    
     @remoteAction
    global static void  updateDE(string DEID,string GooglesheetID){
    
       Design_Execution__c DE =new Design_Execution__c(id=DEID,Google_Sheet_Id__c=GooglesheetID);
        update DE; 
        
        
    }
}