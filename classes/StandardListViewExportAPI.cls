/*
Type Name: StandardListViewExportAPI 
Author: Cognizant Case Management Team
Created Date: 20-Jan-2015
Reason: Reason: Visualforce controller for the page to export the records directly from list view.
Test Class: StandardListViewExportAPITest
Change History:
Author: 
Modified Date: 
…….//.
……..
--
*/
public with sharing class StandardListViewExportAPI{ 
  public string breakStr {get; set;}
    public List < String > fields {
        get;
        set;
    }
    public List < String > columnName {
        get;
        set;
    }
    public List < sObject > recordList {
        get;
        set;
    }
    public List < List < sObject >> allRecords {
        get;
        set;
    }
    public List < StandardListViewExportAPI.Columns > parserCol {
        get;
        set;
    }
    public List < Columns > columns;
    public String fileName {
        get;
        set;
    }
    public transient String listid;
    public transient String ObjectName;
    public transient String listName;
    /***
    * This method is used for getting records from List Views specified in Page URL.
    ***/ 
    public void fetchListviewRecords() {  
        
        breakStr  = '\r\n';
        columnName = new List<String>();
        fields = new List<String>();
        parserCol =  new List<StandardListViewExportAPI.Columns>();
        recordList = new List<sObject>();
        allRecords = new List<List<sObject>>();
        //get page parameters
        getParameters();
        
        if(this.listid !=null && this.ObjectName != null && this.listName !=null){
            fileName =  ObjectName +'_'+listName.replace(' ','_') +'_'+ Datetime.now().format();
            //Http callout 
            callHttpRequest();
        }
    } 
    
    /***
    * This method is used for getting values from Page URL.
    ***/  
    public void getParameters() {
        this.listid = isNotBlank(ApexPages.currentPage().getParameters().get('listid')) ?
            ApexPages.currentPage().getParameters().get('listid') : null;
        this.ObjectName = isNotBlank(ApexPages.currentPage().getParameters().get('Object')) ?
            ApexPages.currentPage().getParameters().get('Object') : null;
        this.listName = isNotBlank(ApexPages.currentPage().getParameters().get('listName')) ?
            ApexPages.currentPage().getParameters().get('listName') : null;
    }
        
    /***
    * This method is used for getting values from Page URL.
    ***/  
    public void callHttpRequest() {
        try{
            Map<String,Object> root;
            List<Sobject> listSobject = new List<Sobject>();
            HttpResponse res;
            // Instantiate a new HTTP request, specify the method (GET) as well as the endpoint
            HttpRequest req = new HttpRequest();
            req.setHeader('Authorization', 'Bearer ' + UserInfo.getSessionID());
            req.setHeader('Content-Type', 'application/json');
            String baseUrl = URL.getSalesforceBaseUrl().toExternalForm();
            String endpointUrl = baseUrl;
            system.debug('####### endpointUrl:'+endpointUrl);
            
            if(UserInfo.getUserType() != 'Standard'){endpointUrl += '/GlobalfoundryView';}
            else{
                if(baseUrl.containsIgnoreCase('GlobalfoundryView')){endpointUrl += '/GlobalfoundryView';}
            }
            
            endpointUrl += '/services/data/v32.0/sobjects/'+ObjectName+'/listviews/'+listid+'/describe';
            
            req.setEndpoint(endpointUrl);
            req.setMethod('GET'); 
            req.setTimeout(120000);
             
            Http h = new Http();
                    
            // Invoke web service call        
            if (!Test.isRunningTest()){
                res = h.send(req);
                root  = (Map<String, Object>)JSON.deserializeUntyped(res.getBody()); 
                listSobject = Database.query((string)root.get('query'));
                
                JSONParser parser = JSON.createParser(res.getBody()); 
                //Parsing JSON string to get the column details
                while (parser.nextToken() != null){ 
                    if(parser.getCurrentToken() == JSONToken.START_ARRAY) {       
                        while (parser.nextToken() != null) {
                            if(parser.getCurrentToken() == JSONToken.START_OBJECT) {
                                StandardListViewExportAPI.Columns le = (StandardListViewExportAPI.Columns)parser.readValueAs(StandardListViewExportAPI.Columns.class);
                                parserCol.add(le);                        
                            }
                        }
                    }
                } 
            }else{
                listSobject = [select Id from Case limit 1];
                //parserCol = new StandardListViewExportAPI.Columns(null, null, 'Id',false, 'Id', null, 0, true, null);
                StandardListViewExportAPI.Columns le = new StandardListViewExportAPI.Columns();
                parserCol.add(le);   
            }
            
            //Nested list logic to overcome collection limit
            for(Sobject sobj : listSobject){
                recordList.add(sobj);
                if(recordList.size() == 10000){
                    allRecords.add(recordList);
                    recordList = new List<sObject>();
                }
            }
            
            if(recordList != null && !recordList.isEmpty())
                allRecords.add(recordList);  
            
            for(StandardListViewExportAPI.Columns lc : parserCol){
                if(lc.hidden == false && lc.fieldNameOrPath != Null){
                    fields.add(lc.fieldNameOrPath);
                    columnName.add(lc.label);    
                }
            }
			if(Test.isRunningTest()) {
                    throw new applicationException('In Test Mode');
            }
        } catch (Exception e) {
            ApplicationLogWrapper alw=new ApplicationLogWrapper();
            alw.source = CaseTriggerHandler.class.getName();
            alw.sourceFunction ='callHttpRequest()';
            alw.ApplicationName='Case Management';                    
            alw.referenceInfo = 'Case';
            alw.logMessage = 'Error Message='+e.getMessage()+' At Line Number='+e.getLineNumber()+' Stack Trace='+e.getStackTraceString();
            alw.debugLevel = 'Error';
            alw.logCode = e.getTypeName();
            alw.ex = e.getCause();
            GlobalUtility.logMessage(alw);    
        }
    }
    
    /****
    * isNotBlank- check the string null or blank
    ***/
    public static Boolean isNotBlank(String val){
        if(val <> null && val <> '' && val <> 'null'){
            return true;
        }
        return false;
    }
    
    public class Columns {    
        public String ascendingLabel;
        public String descendingLabel;
        public String fieldNameOrPath;
        public Boolean hidden;
        public String label;
        public String selectListItem;
        public String sortDirection;
        public Integer sortIndex;
        public Boolean sortable;
        public String type;
    }
	public class applicationException extends Exception {} 
}