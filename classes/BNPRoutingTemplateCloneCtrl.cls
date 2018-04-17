/*
Type Name: BNPRoutingTemplateCloneCtrl
Author: Devendra Babu
Project Name: DIW Step Down Track 2 (BnP) 
Created Date: 5/23/2016
Description: This class serves controller for BNPRoutingTemplateClone Page.
Test Class: 
Change History:
*/
public with sharing class BNPRoutingTemplateCloneCtrl {
    
    public RFQ_Routing__c rec {get; set;}
    public RFQ_Routing__c dummyRT {get; set;}
    private List<RFQ_Tasks_Routing__c> tasks {get; set;}
    
    public BNPRoutingTemplateCloneCtrl (ApexPages.StandardController stc){
        
        string routingQuery=getCreatableFieldsSOQL('RFQ_Routing__c');
        string taskQuery=getCreatableFieldsSOQL('RFQ_Tasks_Routing__c');
        //query project record
          id recId=stc.getId();    
          rec=(RFQ_Routing__c)Database.query(routingQuery+' WHERE Id = :recId limit 1');
        
        //query task records 
                
        tasks=Database.query(taskQuery+' where Related_RFQ_Routing__c = :recId ');
                
        dummyRT = new RFQ_Routing__c();
        dummyRT.Name = 'Copy of ' + rec.Name;
        
              
    }
    
     // Returns a dynamic SOQL statement for the whole object, includes only creatable fields since we will be inserting a cloned result of this query
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
    
    public PageReference createClone(){      
        Savepoint preSave = Database.setSavepoint(); //set savepoint so we can rollback the whole save if there are errors
        PageReference pageReference = null;
        try{
           rec.Name = dummyRT.Name;
            RFQ_Routing__c newRT = rec.clone(false);
            newRT.Template__c = true;
            /*if(rec.Status__c == 'Complete' ){
                newRT.Status__c = 'InProgress';
            }*/
            //newRT.Skip_Validation__c = true;
            insert newRT;
            
            List<RFQ_Tasks_Routing__c> newTasks = cloneTasksIntoList(tasks);
            for(RFQ_Tasks_Routing__c newTask : newTasks){
                newTask.Related_RFQ_Routing__c = newRT.Id;
                newTask.Skip_Validation__c = true;
            }
            insert newTasks;
            
            //direct user to cloned project's detail page
            return new ApexPages.StandardController(newRT).view();
         
        }catch(Exception e){
            ApexPages.addMessages(e); //show save error(s) on the visualforce page
            GlobalUtility.logMessage('Error','BNPRoutingTemplateCloneCtrl','createClone','','Exception while creating Routing Template',String.valueof(e.getMessage()),'','BnP',e,0);
            Database.rollback(preSave); //rollback any completed saves if the transaction has errors
        }
        return pageReference;
    }
    
    private static List<RFQ_Tasks_Routing__c> cloneTasksIntoList(List<RFQ_Tasks_Routing__c> recs){
        List<RFQ_Tasks_Routing__c> newRecs = new List<RFQ_Tasks_Routing__c>();
        for(RFQ_Tasks_Routing__c rec : recs){
            RFQ_Tasks_Routing__c newRec = rec.clone(false);
            newRecs.add(newRec);
        }
        return newRecs;
    }
    
    
}