/*
    Company:        Cognizant Technology Solution
    Description:    This batch class will be used for Deep Cloning the STM Task records along with FeedItems.
                    The top class needs to be global as this needs to be accessible for API call
    History:
        NJain    11/06/2014    Class Creation
        
*/

global with sharing class STM_Clone{ 
   
   //New Parent Record ID for API call
   global string newParentRecordID {get;private set;}
    
    public class MyException extends Exception {}
    
    public Map<String,String> chidlObjAPIName_FieldAPIName = new Map<String,String>{};

   //standard constructor
   global STM_Clone(){
        
   }

   //quick clone constructor
   global STM_Clone(String parentRecordID,List<String> childObjAPINames){
        newParentRecordID=startsClone(parentRecordID,childObjAPINames);
   }
   
   //excute clone and returns new parent record id
   public string startsClone(String parentRecordID,List<String> childObjAPINames){
        string fieldsNames=''; 

        //Loop through all child object names
        for(string objAPIName: childObjAPINames) {
            //Check if current child object has records linked with the parent record            
            //Handle Note and Attachement in different way as they use "ParentID" in the query
            if(objAPIName == 'Note' || objAPIName == 'Attachment') {
                String queryString = 'select count(id) total from ' + String.escapeSingleQuotes(objAPIName) + ' where ParentId =\'' + String.escapeSingleQuotes(parentRecordID) + '\'';
                SObject result = Database.query(queryString); 

                //Find note and attachment records, add note & attachment into the list
                if((Integer)result.get('total') > 0)
                    fieldsNames = fieldsNames + objAPIName + ',';
            }
            else {
                String queryString = 'select count(id) total from ' + String.escapeSingleQuotes(objAPIName) + ' where ' + String.escapeSingleQuotes(chidlObjAPIName_FieldAPIName.get(objAPIName)) + '=\'' + String.escapeSingleQuotes(parentRecordID) + '\'';
                system.debug('#####Querystring#####'+queryString);
                SObject result = Database.query(queryString);                   

                //Find child object records linked with the parent record, add the child object API name into the list
                if((Integer)result.get('total') > 0)
                    fieldsNames = fieldsNames + objAPIName + ',';
            }
        }
        
        //Create Child Object API Name and creatable fields map
        Map<String, list<String>> objFields = New Map<String, list<String>>{};
        if(fieldsNames.length()>0) {
            //getCreatableFields(objAPIName) returns all creatable fields name for a given child obj API name        
            for(String objAPIName:fieldsNames.split(','))
                objFields.put(objAPIName,getCreatableFields(objAPIName));
            
        }

        //Clone parent record
        String newParentRecordID = cloneParentRecord(returnAPIObjectName(parentRecordID),getCreatableFields(returnAPIObjectName(parentRecordID)),parentRecordID);

        //Clone all selected child records
        for(String childObjAPIName:objFields.keySet())
            cloneChildRecords(childObjAPIName, objFields.get(childObjAPIName), returnAPIObjectName(parentRecordID), newParentRecordID,parentRecordID);
        
        createContentVersion(parentRecordId,newParentRecordID);
        
        return newParentRecordID;    
    }

    //Get all child object (which have records linked with the parent record) API name
    private void getFieldAPINames (String[] objects,String parentObjAPIName,String parentRecordID){
        string fieldsNames = '';
        for(string s: objects) {            
            String objAPIName=getAllChildObjNames(parentObjAPIName,parentRecordID).get(s);            
            if(objAPIName == 'Note' || objAPIName == 'Attachment') {
                String queryString = 'select count(id) total from ' + String.escapeSingleQuotes(objAPIName) + ' where ParentId =\'' + String.escapeSingleQuotes(parentRecordID) + '\'';
                SObject result = Database.query(queryString); 
                if((Integer)result.get('total')>0)
                    fieldsNames = fieldsNames + objAPIName + ',';
            }
            else {
                String queryString = 'select count(id) total from ' + String.escapeSingleQuotes(objAPIName) + ' where ' + String.escapeSingleQuotes(chidlObjAPIName_FieldAPIName.get(objAPIName)) + '=\'' + String.escapeSingleQuotes(parentRecordID) + '\'';
                SObject result = Database.query(queryString);
                if((Integer)result.get('total')>0)
                    fieldsNames = fieldsNames + objAPIName + ',';                   
            }
        }
    }

    //Clone all child records
    public void cloneChildRecords(String objAPIName, list<String> createableFields, String parentObjAPIName, string newParentRecordID, string parentRecordID){
        String fields = '';
        for(string s:createableFields)
            fields = fields + s + ',';

        fields=fields.substring(0, fields.lastIndexOf(','));

        String queryString = 'select ' + String.escapeSingleQuotes(fields) + ' from ' + String.escapeSingleQuotes(objAPIName) + ' where ' + String.escapeSingleQuotes(chidlObjAPIName_FieldAPIName.get(objAPIName)) + '=\'' + String.escapeSingleQuotes(parentRecordID) + '\'';
        list<SObject> result = Database.query(queryString);         
        list<SObject> copy = result.deepclone(false);       
        for(SObject obj :copy)
            obj.put(chidlObjAPIName_FieldAPIName.get(objAPIName), newParentRecordID);
        insert copy;
    }

    //Clone parent record and return new parent record ID
    public String cloneParentRecord(String objAPIName, List<String> createableFields,string parentRecordID) {
        String fields = '';
        for(string s:createableFields) {
            //Remove all contact mirror fields from person account
            if(s.contains('__pc') == false)
                fields = fields + s + ',';          
        }
        fields = fields.substring(0, fields.lastIndexOf(','));

        String queryString = 'select ' + String.escapeSingleQuotes(fields) + ' from ' + String.escapeSingleQuotes(objAPIName) + ' where id=\'' + String.escapeSingleQuotes(parentRecordID) + '\'';
        SObject result = Database.query(queryString);       
        Sobject copy = result.clone(false, true);
        insert copy;
        return copy.id ;
    }
       
    //Return the object API name for a given record
    public String returnAPIObjectName (string myRecordID){
        String objectName = '';
        
        String prefix = myRecordID.substring(0,3);
    
        Map<String, Schema.SObjectType> gd = Schema.getglobalDescribe();

        for(SObjectType s :gd.values()) {
            DescribeSObjectResult r = s.getDescribe();     
            if(r.getKeyPrefix()!=null) {
                if(r.getLocalName()!=null && r.getKeyPrefix().equals(prefix)) {
                    objectName=r.getLocalName();
                    break;
                } 
             }
        }        
        return objectName;
    }
    
    
    //Get all creatable fields for a given object
    public list<String> getCreatableFields(String objAPIName){
        Map<string,string> childFieldsName = new Map<string,string>{};
        
        Map<String, Schema.SObjectType> gd = Schema.getglobalDescribe();
        SObjectType sot = gd.get(objAPIName);
      
        //Get all non-creatable fields name except
        //Get the field tokens map
        Map<String, SObjectField> fields = new Map<String, SObjectField>{};
        if(sot.getDescribe().fields.getMap().keyset().size()>0)
            fields = sot.getDescribe().fields.getMap();
        
        //And drop those tokens in a List
        List<SObjectField> fieldtokens = fields.values();
        
        List<string> objectFields = new List<String>();
        
        for(SObjectField fieldtoken:fieldtokens) {
            DescribeFieldResult dfr = fieldtoken.getDescribe();
            
            if(dfr.isCreateable())
                objectFields.add(dfr.getLocalName());                       
        }
        
        return objectFields;
    }
    
    //Get all child object API names for a given parent object API name
    //return Map<object label,object local name>,
    public Map<string,string> getAllChildObjNames(String parentObj,String parentRecordID) {        
        Map<string,string> childFieldsName = new Map<string,string>{};        
        Map<String, Schema.SObjectType> gd = Schema.getglobalDescribe();
        SObjectType sot = gd.get(ParentObj);
       
       //Get all child fields
        Schema.DescribeSObjectResult fieldResult2 = sot.getDescribe();
        List<Schema.ChildRelationship> children = fieldResult2.getChildRelationships();
        for(Schema.ChildRelationship child:children) {
            //Exclude following objects
            if(child.getChildSObject().getDescribe().getLocalName() <> 'ProcessInstance' 
            && child.getChildSObject().getDescribe().getLocalName() <> 'ProcessInstanceHistory' 
            && child.getChildSObject().getDescribe().getLocalName() <> 'ContentVersion'
            && child.getChildSObject().getDescribe().getLocalName() <> 'ContentDocument'   
            && child.getChildSObject().getDescribe().getLocalName() <> 'ActivityHistory'
            && child.getChildSObject().getDescribe().getLocalName() <> 'OpenActivity'
            && child.getChildSObject().getDescribe().getLocalName() <> 'Event'
            && child.getChildSObject().getDescribe().getLocalName() <> 'Task'
            && child.getChildSObject().getDescribe().getLocalName() <> 'User'
            && child.getChildSObject().getDescribe().getLocalName() <> 'FeedComment'
            && child.getChildSObject().getDescribe().getLocalName() <> 'FeedPost' 
            && child.getChildSObject().getDescribe().getLocalName() <> 'FeedItem'
            && child.getChildSObject().getDescribe().getLocalName() <> 'EntitySubscription'
            && child.getChildSObject().getDescribe().getLocalName() <> 'NoteAndAttachment'
            && child.getChildSObject().getDescribe().getLocalName() <> 'UserRole'
            && child.getChildSObject().getDescribe().getLocalName() <> 'Partner'
            && child.getChildSObject().getDescribe().getLocalName() <> 'CampaignMemberStatus'
            && child.getChildSObject().getDescribe().getLocalName() <> 'ContentDistribution'
            && child.getChildSObject().getDescribe().getLocalName() <> 'ContentDocumentLink'
        
            //Do not take parent record which is the same object
            && child.getChildSObject().getDescribe().getLocalName() <> returnAPIObjectName(parentRecordID)

            //exclude obj created for sharing purpose
            && child.getChildSObject().getDescribe().getLocalName() <> returnAPIObjectName(parentRecordID) + 'share'
            && child.getChildSObject().getDescribe().getLocalName().endsWith('__Share')==false

            //has to be creatable
            && child.getChildSObject().getDescribe().isCreateable() == true) {
                string a=string.valueof(child.getChildSObject().getdescribe().getLocalName());
                string b=string.valueof(child.getField());
                chidlObjAPIName_FieldAPIName.put(string.valueof(child.getChildSObject().getdescribe().getLocalName()), string.valueof(child.getField()));
                childFieldsName.put(child.getChildSObject().getDescribe().getLabel(), child.getChildSObject().getDescribe().getLocalName());
            }
        }

        return childFieldsName;
    }
    
    //++Clone all the Content Versions
    public void createContentVersion(String parentRecordId,String newParentRecordID){
        STMTask__c stmTask = [select id,ReportCategory__c,Frequency__c  from STMTask__c where id= :newParentRecordID limit 1];
        
        List<String> lstOldContentVer = new List<String>();
        for(FeedItem oldFeedItem : [select RelatedRecordId from FeedItem where ParentId = :parentRecordId]){
            lstOldContentVer.add(oldFeedItem.RelatedRecordId);
        }
        
        String currentWeek = DateTime.newInstanceGmt(
                                Date.newInstance(System.today().Year(), System.today().Month(),System.today().Day()
                                                 ).toStartOfWeek(), Time.NewInstance(12,0,0,0)
                             ).format('w');
        String currentMonthNo = '';
        if(System.today().Month() <= 9){
            currentMonthNo = '0'+ string.valueOf(System.today().Month());
        }else{
            currentMonthNo = string.valueOf(System.today().Month());
        }
                        
        List<String> lstPatterns = new List<String>();
        for(STM_FilePattern__c fPatt: [SELECT id, Name, Destination_Folder__c FROM STM_FilePattern__c]){
            lstPatterns.add(fPatt.Name.toUpperCase());
        }
        
        //integer i=1;
        List<ContentVersion> lstNewContentVersions = new List<ContentVersion>();
        for(ContentVersion cOld: [SELECT id,VersionData,Description,Title,PathOnClient,FirstPublishLocationId,FileType
                                    FROM ContentVersion where id in :lstOldContentVer]){
            //Iterate through file pattern to rename the document in correct format.
            string tempMatch='';
            boolean matchFound = false;
            for(String str: lstPatterns){
                system.debug('#######cOld.Title#######' + cOld.Title);
                Pattern profilePattern  = Pattern.Compile(str.replace('(','\\(').replace(')','\\)').replace('$','\\$').toUpperCase());
                Matcher m1= profilePattern.matcher(cOld.Title.toUpperCase());
                
                while (m1.find()){
                    if(m1.group(0) != NULL && m1.group(0) != ''){
                        system.debug('####True'+m1.group(0));
                        if(tempMatch.length() < m1.group(0).length()){
                            tempMatch = m1.group(0);
                            matchFound = True;
                        }
                        break;
                    }
                }
            }
            if(matchFound){
                if(stmTask.Frequency__c == 'Monthly' || stmTask.Frequency__c == 'Yearly' || stmTask.Frequency__c == 'Quarterly' || stmTask.Frequency__c == 'Semi-Annually'){
                    cOld.Title = tempMatch + '_' + System.TODAY().YEAR() + '-' + currentMonthNo;
                }else{
                    cOld.Title = tempMatch + '_W' + currentWeek;
                }
            }
            system.debug('###DEBUG cOld.Title###'+cOld.Title);
            
            ContentVersion cNew= new ContentVersion();
            cNew.VersionData = cOld.VersionData;
            cNew.Description = cOld.Description;
            cNew.Title = cOld.Title;
            cNew.PathOnClient = cOld.Title + '.' + cOld.FileType;
            cNew.Origin = 'H';
            lstNewContentVersions.add(cNew);
        }
        insert lstNewContentVersions;
        
        List<FeedItem> lstFeedItemsNew = new List<FeedItem>();
        for(ContentVersion cNew: lstNewContentVersions){
            FeedItem fi = new FeedItem();
            fi.Type = 'ContentPost';
            fi.RelatedRecordId = cNew.Id;
            fi.ParentId = newParentRecordID;
            fi.Title = cNew.Title;
            lstFeedItemsNew.add(fi);
        }
        insert lstFeedItemsNew;
        //--Clone all the Content Versions
    }
}