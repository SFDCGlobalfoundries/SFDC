public class YieldFeedbackInlineController {
    public string recordId {get;set;}
    public string objectName {get;set;}
    public string soql {get;set;}
    public integer currentPageNo {get;set;}
    public integer totalNoOfPages {get;set;}
    public integer totalNoOfRecords {get;set;}
    public boolean showButton {get;set;}
    public Map<integer, List<Yield_Feedback__c>> mapRecords {get;set;}
    
    public YieldFeedbackInlineController() {
        this.recordId = ApexPages.currentPage().getParameters().get('id');
        this.currentPageNo = 1;
        this.totalNoOfPages = 0;
        this.totalNoOfRecords = 0;
        this.mapRecords = new Map<integer, List<Yield_Feedback__c>>();
        retrieveRecords();
    }
    
    public void retrieveRecords() {
        // Get Account Prefix
        Schema.DescribeSObjectResult a = Account.sObjectType.getDescribe();
        String accountPrefix = a.getKeyPrefix();
        
        // Get Device Prefix
        Schema.DescribeSObjectResult d = Device__c.sObjectType.getDescribe();
        String devicePrefix = d.getKeyPrefix();
        
        string query = 'SELECT Id, Manufacturing_Lot__c, Comments__c,Manufacturing_Lot__r.Name, Lot_Purpose__c, Is_Auto_Tagged__c, ' +
                              'Manufacturing_Lot__r.Lot_Start_Date__c, Manufacturing_Lot__r.Last_Ship_Date__c, ' +
                              'Functional__c, Sort_Yield__c, First_Time_Not_Right__c, Yield_Feedback_Due_Date__c, ' +
                              'Manual_Device__c, Tapeout_Type__c, Device__c, Device__r.Name, Fab__c ' +
                        'FROM  Yield_Feedback__c ' ;
        if (this.recordId.startsWith(accountPrefix)) {
            query = query + 'WHERE Account__c = \'' + this.recordId + '\' ';
            this.objectName = 'Account';
            this.showButton = true;
        } else if (this.recordId.startsWith(devicePrefix)) {
            query = query + 'WHERE Device__c = \'' + this.recordId + '\' ';
            this.objectName = 'Device';
            this.showButton = checkDevice();
        }
        
        query = query + 'ORDER BY Manufacturing_Lot__r.Name ASC';
        List<Yield_Feedback__c> tempList = new List<Yield_Feedback__c>();
        tempList = Database.query(query);
        if (tempList.size() > 0) {
            this.totalNoOfRecords = tempList.size();
            paginateRecords(tempList);  
        }
    }
    
    public void paginateRecords(List<Yield_Feedback__c> tempList) {
        integer pageKey = 1;
        for (Yield_Feedback__c y : tempList) {
            if (this.mapRecords.containsKey(pageKey)) {
                if (this.mapRecords.get(pageKey).size() < integer.valueOf(Environment_Variable__c.getInstance('EPTS_RECORDS_PER_PAGE').Value__c)) {
                    this.mapRecords.get(pageKey).add(y);
                } else {
                    pageKey++;
                    this.mapRecords.put(pageKey, new List<Yield_Feedback__c>{y});
                }
            } else {
                this.mapRecords.put(pageKey, new List<Yield_Feedback__c>{y});
            }
        }
        
        this.totalNoOfPages = this.mapRecords.size();
    }
    
    public List<Yield_Feedback__c> getRecords() {
        List<Yield_Feedback__c> tempList = new List<Yield_Feedback__c>();
        if (this.mapRecords.containsKey(this.currentPageNo)) {
            tempList = this.mapRecords.get(this.currentPageNo);
        }
        
        return tempList;
    }
    
    public boolean checkDevice() {
        boolean returnValue = true;
        Device__c d = [
            SELECT    Stage__c
                      , Status__c
            FROM      Device__c
            WHERE     Id = :this.recordId
        ];
        
        if (d.Stage__c == 'EOL' || d.Status__c == 'Inactive') {
            returnValue = false;
        }
        
        return returnValue;
    }
    
    public boolean getHasPrevious() {
        return (this.currentPageNo > 1 ? true : false);
    }
    
    public boolean getHasNext() {
        return (this.currentPageNo < this.totalNoOfPages ? true : false);
    }
    
    public void previous() {
        this.currentPageNo--;
    }
    
    public void next() {
        this.currentPageNo++;
    }
    
    public void first() {
        this.currentPageNo = 1; 
    }
    
    public void last() {
        this.currentPageNo = this.totalNoOfPages;  
    }
}