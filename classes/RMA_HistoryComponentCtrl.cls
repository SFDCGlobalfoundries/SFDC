/**
 * Author: Surendranadh Nune
 * Company: GlobalFoundries,India
 * Project: Return Material Authorization
 * Description: This class is used to display the field history of RMA.
 * History:
 *    SurendranadhNune 17122015  -   Created.
 *                            
 **/
public class RMA_HistoryComponentCtrl{
    
    // External variables
    public SObject myObject {get; set;}
    public Integer recordLimit {get; set;}
    public static String objectLabel {get;}
    public boolean isPrint {get;set;}
    public integer PageSize {get;set;}
    public boolean AllowShowMore {get;set;}
    public String reportDevName {get;set;}
    
    // Internal Variables
    public objectHistoryLine[] objectHistory; 
    public static final Map<String, Schema.SObjectType> mySObjectTypeMap = Schema.getGlobalDescribe();
    public static Map<String, Schema.SObjectField> myObjectFieldMap;
    public static List<Schema.PicklistEntry> historyFieldPicklistValues;
        
    //Constructor
    public RMA_HistoryComponentCtrl(){
        PageSize = 5;   
        isPrint = false;
        AllowShowMore = true;
    }
    
    //Method to increase the pagesize
    public void showMore(){
        PageSize += 5;
    }
    
    //Method which dynamically queries the history records based on recordId
    public List<objectHistoryLine> getObjectHistory(){
        
        Id myObjectId = String.valueOf(myObject.get('Id'));
        Schema.DescribeSObjectResult objectDescription = myObject.getSObjectType().getDescribe();
        integer limitPlusOne = PageSize + 1;
        myObjectFieldMap = objectDescription.fields.getMap();
        objectLabel = String.valueOf(objectDescription.getLabel());

        //Get the name of thew history table
        String objectHistoryTableName = objectDescription.getName();
        //if we have a custom object we need to drop the 'c' off the end before adding 'History' to get the history tables name
        if (objectDescription.isCustom()){
            objectHistoryTableName = objectHistoryTableName.substring(0, objectHistoryTableName.length()-1);
        }
        objectHistoryTableName = objectHistoryTableName + 'History';

        Schema.DescribeFieldResult objectHistoryFieldField = mySObjectTypeMap.get(objectHistoryTableName).getDescribe().fields.getMap().get('Field').getDescribe();
        historyFieldPicklistValues = objectHistoryFieldField.getPickListValues();

        list<objectHistoryLine> objectHistory = new list<objectHistoryLine>();

        String prevDate = '';

        if(recordLimit == null){
            recordLimit = 100;
        }
        String limitVal = isPrint ? String.valueOf(Limits.getLimitQueryRows()) : String.valueOf(limitPlusOne);
        list<sObject> historyList = Database.query( 'SELECT CreatedDate,'+
                                                            'CreatedById,'+
                                                            'Field,'+
                                                            'NewValue,'+
                                                            'OldValue ' +
                                                    'FROM ' + objectHistoryTableName + ' ' +
                                                    'WHERE ParentId =\'' + myObjectId + '\' ' +
                                                    'ORDER BY CreatedDate DESC '+
                                                    'LIMIT ' + limitVal);
         
        allowShowMore = (historyList !=null && historyList.size() == limitPlusOne);
        
        for(Integer i = 0; i < historyList.size(); i++){
            sObject historyLine = historyList.get(i);
            if( (historyLine.get('newValue') == null && historyLine.get('oldValue') == null) || 
                (historyLine.get('newValue') != null && !(string.valueOf(historyLine.get('newValue')).startsWith('005') || 
                    string.valueOf(historyLine.get('newValue')).startsWith('00G'))) || 
                (historyLine.get('oldValue') != null && !(string.valueOf(historyLine.get('oldValue')).startsWith('005') || 
                    string.valueOf(historyLine.get('oldValue')).startsWith('00G')))
            ){
                objectHistoryLine tempHistory = new objectHistoryLine();
                
                // Set the Date and who performed the action
                if(String.valueOf(historyLine.get('CreatedDate')) != prevDate){
                    tempHistory.theDate = String.valueOf(historyLine.get('CreatedDate'));
                    datetime dttime1=datetime.valueOf(tempHistory.theDate) ;
                    TimeZone tz = UserInfo.getTimeZone();
                    DateTime localTime = dttime1.AddSeconds(tz.getOffset(dttime1)/1000);
                    tempHistory.theDate = localTime.format('MM/dd/yyyy hh:mm a');                   
                    tempHistory.userId = String.valueOf(historyLine.get('CreatedById'));
                    tempHistory.who = String.valueOf(historyLine.get('CreatedById'));
                }
                else{
                    tempHistory.theDate = '';
                    tempHistory.who = '';
                    tempHistory.userId = String.valueOf(historyLine.get('CreatedById'));
                }
                prevDate = String.valueOf(historyLine.get('CreatedDate'));
              
                // Get the field label
                String fieldLabel = RMA_HistoryComponentCtrl.returnFieldLabel(String.valueOf(historyLine.get('Field')));

                // Set the Action value
                if(String.valueOf(historyLine.get('Field')) == 'created'){ // on Creation
                    tempHistory.action = 'Created.';
                }
                else if(historyLine.get('oldValue') != null && historyLine.get('newValue') == null){ // when deleting a value from a field
                    // Format the Date and if there's an error, catch it and re
                    try{
                        tempHistory.action = 'Deleted ' + Date.valueOf(historyLine.get('oldValue')).format() + ' in <b>' + fieldLabel + '</b>.';
                    }catch(Exception e){
                        tempHistory.action = 'Deleted ' + String.valueOf(historyLine.get('oldValue')) + ' in <b>' + fieldLabel + '</b>.';
                    }
                }
                else{ // all other scenarios
                    String fromText = '';
                    if (historyLine.get('oldValue') != null) {
                        try {
                            fromText = ' from ' + Date.valueOf(historyLine.get('oldValue')).format();
                        } catch (Exception e) {
                            fromText = ' from ' + String.valueOf(historyLine.get('oldValue'));
                        }
                    }

                    String toText = '';
                    if (historyLine.get('oldValue') != null) {
                        try {
                            toText = Date.valueOf(historyLine.get('newValue')).format();
                        } catch (Exception e) {
                            toText = String.valueOf(historyLine.get('newValue'));
                        }
                    }
                    if (toText != ''){
                        tempHistory.action = 'Changed <b>' + fieldLabel + '</b>' + fromText + ' to <b>' + toText + '</b>.';
                    }
                    else {
                        tempHistory.action = 'Changed <b>' + fieldLabel;
                    }
                }

                // Add to the list
                objectHistory.add(tempHistory);
                if (objectHistory.size() == PageSize) break;
            }
        }

        List<Id> userIdList = new List<Id>();
        for (objectHistoryLine myHistory : objectHistory){
            userIdList.add(myHistory.userId);
        }
        Map<Id, User> userIdMap = new Map<ID, User>([SELECT Name FROM User WHERE Id IN : userIdList]);

        for (objectHistoryLine myHistory : objectHistory){
            if (userIdMap.containsKey(myHistory.userId) & (myHistory.who != '') ){
                myHistory.who = userIdMap.get(myHistory.who).Name;
            }
        }

        return objectHistory;
    } 

    // Function to return Field Label of a object field given a Field API name
    public Static String returnFieldLabel(String fieldName){

        if (RMA_HistoryComponentCtrl.myObjectFieldMap.containsKey(fieldName)){
            return RMA_HistoryComponentCtrl.myObjectFieldMap.get(fieldName).getDescribe().getLabel();
        }
        else {
            for(Schema.PicklistEntry pickList : historyFieldPicklistValues){
                if (pickList.getValue() == fieldName){
                    if (pickList.getLabel() != null){
                        return pickList.getLabel();
                    }
                    else {
                        return pickList.getValue();
                    }
                }
            }
        }
        return '';
    }
    
    /**
     * Author: Surendranadh Nune 
     * Description: Method to get the field history report url from Report name.
     */ 
    public Pagereference getReportUrl(){
        List<Report> reports;
        Pagereference reportUrl;
        String rmaId =  myObject != null ? (String)myObject.get('Id') : null;
        if(rmaId != null && String.isNotBlank(reportDevName)){
            reports = new List<Report>([select developername,id from report where developername= :reportDevName]);
            if(!reports.isEmpty()){
                String pv0 = rmaId;
                pv0 = pv0.length() > 15 ? pv0.subString(0, 15) : rmaId;
                reportUrl = new Pagereference(URL.getSalesforceBaseUrl().toExternalForm() + '/' + reports[0].id + '?pv0=' + pv0 + '&export=1&enc=UTF-8&xf=xls');
            }
        }
        return reportUrl;
    }

    // Inner Class to store the detail of the object history lines 
    public class objectHistoryLine {

        public String theDate {get; set;}
        public String who {get; set;}
        public Id userId {get; set;} 
        public String action {get; set;}
    }
}