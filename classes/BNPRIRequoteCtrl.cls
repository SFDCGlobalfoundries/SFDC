/*
Type Name: BNPRIRequoteCtrl
Author: Poulami Saha
Project Name: DIW Step Down Track 2 (BnP) 
Created Date: 11/25/2016
Description: This class is call from 'Requote' button to clone RFQ.
Test Class: 
Change History:
*/
Global class BNPRIRequoteCtrl{
    public static Request_Information__c reqInfoRec {get; set;}
    public static Request_Information__c dummyreqInfoRec {get; set;}
    public static List<RFQ_Routing__c> routeList {get; set;}
    public static List<RFQ_Tasks_Routing__c> tasks {get; set;}
    public static List<RFQ_Task_Assignee__c> taskAssignees {get; set;}
    public static Map<Id,List<RFQ_Task_Assignee__c>> taskAssigneeMap;
    
    /**
    *  The Purpose of this method is to clone RFQ.
    *  @name <BNPRIRequote>
    *  @param <String> 
    *  @return <String>
    *  @throws exception-<GlobalUtility.logMessage was called to capture the exception>
    */
    WebService static String BNPRIRequote(String recInfoId){
        string reqInfoQuery = getCreatableFieldsSOQL('Request_Information__c');
        string routingQuery = getCreatableFieldsSOQL('RFQ_Routing__c');
        string taskQuery = getCreatableFieldsSOQL('RFQ_Tasks_Routing__c');
        string taskAssigneeQuery = getCreatableFieldsSOQL('RFQ_Task_Assignee__c');
        
        //query Request Information record
        //Id reqInforecId = stc.getId();
        reqInfoRec = (Request_Information__c)Database.query(reqInfoQuery + ' WHERE Id =: recInfoId limit 1');
        
        //query Routing records
        routeList = Database.query(routingQuery + ' where RFQ__c =: recInfoId ORDER BY CreatedDate DESC LIMIT 1');
        
        //query task records                
        tasks = Database.query(taskQuery + ' where Related_RFQ_Routing__c IN: routeList');
                
        //query task assignee records                
        taskAssignees = Database.query(taskAssigneeQuery + ' where RFQ_Task_Routing__c IN: tasks');
        
        taskAssigneeMap = new Map<Id,List<RFQ_Task_Assignee__c>>();
        for(RFQ_Task_Assignee__c assignee : taskAssignees){
            if(!taskAssigneeMap.containsKey(assignee.RFQ_Task_Routing__c)){
                taskAssigneeMap.put(assignee.RFQ_Task_Routing__c,new List<RFQ_Task_Assignee__c>{assignee});
            } else {
                taskAssigneeMap.get(assignee.RFQ_Task_Routing__c).add(assignee);
            }
        }
        dummyreqInfoRec = new Request_Information__c();
        dummyreqInfoRec.Name = 'Copy of '+ reqInfoRec.Name;
        
        Savepoint preSave = Database.setSavepoint(); //set savepoint so we can rollback the whole save if there are errors
        //PageReference pageReference = null;
        try{
            //reqInfoRec.Name = dummyreqInfoRec.Name;
            Request_Information__c newreqInfo = reqInfoRec.clone(false);
            newreqInfo.Name = dummyreqInfoRec.Name;
            newreqInfo.Last_Respin_Quote__c = reqInfoRec.id;
            
            if(reqInfoRec.Count__c == null)
            {
              reqInfoRec.Count__c = 1;
              System.debug('Version1'+reqInfoRec);
              reqInfoRec.Skip_Validation__c = true;
              update reqInfoRec;
              newreqInfo.Version__c = 1;
              newreqInfo.Skip_Validation__c = true;
            }
            else
            {
              reqInfoRec.Count__c = reqInfoRec.Count__c + 1;
              System.debug('Version11'+reqInfoRec);
              reqInfoRec.Skip_Validation__c = true;
              update reqInfoRec;                  
              newreqInfo.Version__c = reqInfoRec.Count__c;
              newreqInfo.Count__c = null;
              newreqInfo.Skip_Validation__c = true;
            }
            
            insert newreqInfo;
            
            //insert Routing
            List<RFQ_Routing__c> newRoutings = new List<RFQ_Routing__c>();
                newRoutings = cloneRoutingIntoList(routeList);
                for(RFQ_Routing__c newRouting : newRoutings){
                    newRouting.RFQ__c = newreqInfo.Id;
                }
                insert newRoutings;
           
            //insert Tasks
            Map<Id,RFQ_Tasks_Routing__c> newTaskMap = new Map<Id,RFQ_Tasks_Routing__c>();
                newTaskMap = cloneTasksIntoList(tasks);
                List<RFQ_Tasks_Routing__c> newTasks = new List<RFQ_Tasks_Routing__c>();
                for(RFQ_Tasks_Routing__c newTask : newTaskMap.values()){                    
                    newTask.Related_RFQ_Routing__c = newRoutings[0].Id;
                    newTasks.add(newTask);
                }
                insert newTasks;

            //insert Task Assignee
                List<RFQ_Task_Assignee__c> newTaskAssignees = cloneTaskAssigneesIntoList(taskAssignees);
                for(RFQ_Task_Assignee__c newTaskAssign : newTaskAssignees){                    
                    newTaskAssign.RFQ_Task_Routing__c = newTaskMap.get(newTaskAssign.RFQ_Task_Routing__c).Id;
                }
                insert newTaskAssignees;
                        
            //direct user to cloned request information's detail page
            return +newreqInfo.id;
        }catch(Exception e){
            GlobalUtility.logMessage('Error','BNPRICloneCtrl','createClone','','Exception while respining Request Information',String.valueof(e.getMessage()),'','BnP',e,0);
            Database.rollback(preSave); //rollback any completed saves if the transaction has errors
            return e.getMessage();
        }
    }
    
    /**
    *  Returns a dynamic SOQL statement for the whole object, includes only creatable fields since we will be inserting a cloned result of this query
    *  @name <getCreatableFieldsSOQL>
    *  @param <String> 
    *  @return <String>
    *  @throws exception-<exception description>
    */
    public static string getCreatableFieldsSOQL(String objectName){
        
        String selects = '';        
        
        SObjectType objType = Schema.getGlobalDescribe().get(objectName);
        
        Schema.DescribeSObjectResult objTypeResult = objType.getDescribe();
        
        Map<String, Schema.FieldSet> FsMap =  objTypeResult.fieldSets.getMap();
        
        
        List<Schema.FieldSetMember> nonCloneFields= FsMap.get('NonCloneFields').getFields();

        set<string> nonClonedFieldSet=new set<string>();
        for(Schema.FieldSetMember f : nonCloneFields) {
            nonClonedFieldSet.add(f.getFieldPath());
        }
                
        // Get a map of field name and field token
        Map<String, Schema.SObjectField> fMap = Schema.getGlobalDescribe().get(objectName.toLowerCase()).getDescribe().Fields.getMap();
        list<string> selectFields = new list<string>();
        
        if (fMap != null){
            for (Schema.SObjectField ft : fMap.values()){ // loop through all field tokens (ft)
                Schema.DescribeFieldResult fd = ft.getDescribe(); // describe each field (fd)
                if (fd.isCreateable()){ // field is creatable
                    selectFields.add(fd.getName());
                }
            }
        }
        
        if (!selectFields.isEmpty()){
            for (string s:selectFields){
                if(!nonClonedFieldSet.contains(s)){
                    selects += s + ',';
                }
            }
            if (selects.endsWith(',')){selects = selects.substring(0,selects.lastIndexOf(','));}
            
        }
        
        return 'SELECT ' + selects + ' FROM ' + objectName ;
        
    }
    
    
    /**
    *  Returns List of Routing record to clone
    *  @name <cloneRoutingIntoList>
    *  @param <List<RFQ_Routing__c>> 
    *  @return <List<RFQ_Routing__c>>
    *  @throws exception-<exception description>
    */
    private static List<RFQ_Routing__c> cloneRoutingIntoList(List<RFQ_Routing__c> recs){
        List<RFQ_Routing__c> newRecs = new List<RFQ_Routing__c>();
        for(RFQ_Routing__c rec : recs){
            RFQ_Routing__c newRec = rec.clone(false);
            newRecs.add(newRec);
        }
        return newRecs;
    }
    
    /**
    *  Returns List of Task Routing record to clone
    *  @name <cloneTasksIntoList>
    *  @param <List<RFQ_Tasks_Routing__c>> 
    *  @return <List<RFQ_Tasks_Routing__c>>
    *  @throws exception-<exception description>
    */
    private static Map<Id,RFQ_Tasks_Routing__c> cloneTasksIntoList(List<RFQ_Tasks_Routing__c> recs){
        Map<Id,RFQ_Tasks_Routing__c> newRecs = new Map<Id,RFQ_Tasks_Routing__c>();
        for(RFQ_Tasks_Routing__c rec : recs){
            RFQ_Tasks_Routing__c newRec = rec.clone(false);
            newRecs.put(rec.Id,newRec);
        }
        return newRecs;
    }
    
    /**
    *  Returns List of Task Assignee record to clone
    *  @name <cloneTaskAssigneesIntoList>
    *  @param <List<RFQ_Task_Assignee__c>> 
    *  @return <List<RFQ_Task_Assignee__c>>
    *  @throws exception-<exception description>
    */
    private static List<RFQ_Task_Assignee__c> cloneTaskAssigneesIntoList(List<RFQ_Task_Assignee__c> recs){
        List<RFQ_Task_Assignee__c> newRecs = new List<RFQ_Task_Assignee__c>();
        for(RFQ_Task_Assignee__c rec : recs){
            RFQ_Task_Assignee__c newRec = rec.clone(false);
            newRecs.add(newRec);
        }
        return newRecs;
    } 
}