/**
* Author: Anil Kumar
* Company: JK Technosoft
* Project: MPW
* Description: Used for showing assigned WIP to Customer portal user
* History:
*    Anil Kumar 09/06/2016 - Created
**/
public without sharing class MPWCustomerWIPController {

    public List<MPW_WIP_Lot__c> lstAssignments                  {get; set;}
    public Map<Integer, List<MPW_WIP_Lot__c>> mapMPWAssignment  {get; set;}
    public MPW_WIP_Lot__c oWIPDummy                             {get; set;} //Used for displaying date input on page
    public String strSortType                                   {get; set;}
    public String strSortField                                  {get; set;}
    public Integer intTotalNoOfPages                            {get; set;}
    public Integer intTotalNoOfRecords                          {get; set;}
    public Integer intCurrentPageNo                             {get; set;}
    public Integer recordsPerPage                               {get; set;}
    public MPW_WIP_Report_Schedule__c oReportScheduleCS         {get; set;}
    public Boolean isReportSchedule                             {get; set;}
    public string strScheduledFrequency{get; set;}
    
    public MPWCustomerWIPController (){
        lstAssignments = new List<MPW_WIP_Lot__c>();
        mapMPWAssignment = new Map<Integer, List<MPW_WIP_Lot__c>>();
        oWIPDummy = new MPW_WIP_Lot__c();
        strSortType = 'ASC';
        strSortField = 'Manufacturing_Lot_Id__c';
        intTotalNoOfPages = intTotalNoOfRecords = 0;
        intCurrentPageNo = 1;
        recordsPerPage = 25;
        
        mapMPWAssignment = retrieveMPWAssignments();
        
        oReportScheduleCS = new MPW_WIP_Report_Schedule__c();
        isReportSchedule = false;
        
        for(MPW_WIP_Report_Schedule__c cs : [SELECT Id, Name, Day_of_Month__c, Scheduled_Frequency1__c, Scheduled_Frequency2__c, 
                                                Start_Date__c, End_Date__c
                                                FROM MPW_WIP_Report_Schedule__c
                                                WHERE Name =: UserInfo.getUserId()]) {
              oReportScheduleCS = cs;                                  	
             strScheduledFrequency=cs.Scheduled_Frequency1__c;
        }
    }
    
    /*
    * Description : Method to retrieve Manufacturing Lot Assignment based on logged in user.
    */
    private Map<Integer, List<MPW_WIP_Lot__c>> retrieveMPWAssignments() {
        Map<Integer, List<MPW_WIP_Lot__c>> tempMap = new Map<Integer, List<MPW_WIP_Lot__c>>();
        List<MPW_WIP_Lot__c> tempList = new List<MPW_WIP_Lot__c>();
        
        Set<Id> setFormIds = new Set<Id>();
        Set<Id> setPrimeDieIds = new Set<Id>();
        
        String strAccountId = '';
        
        User objLoggedInUser = [SELECT Id, Name, Email, Username FROM User WHERE Id =: UserInfo.getUserId()];
        
        for(Contact objContact : [SELECT Id, User_Name__c, AccountId FROM Contact WHERE User_Name__c =: objLoggedInUser.Username LIMIT 1]) {
            strAccountId = objContact.AccountId;
        }
        
        String strQuery = 'SELECT Id, Prime_Die_Name__c, Sales_Order__c, Geometry__c, Customer_Tapeout_Date__c, MPW_Train_Name__c, ';
        strQuery += 'MPW_Form_Customer_Account_Name__c, MPW_form__c, Current_Scheduled_Date_CSD__c, Current_Scheduled_Date_CSD_OR__c, '; 
        strQuery += 'Current_Mask_Layer__c, Remaining_Mask_Count__c, Current_Lot_Location__c, Lot_Last_Modified_Date__c, ';
        strQuery += 'Lot_State__c, Stage_Name__c, Technology_Type__c, Active_Flag__c, Bare_Die_Shipment_Forecast_Date_BL__c, ';
        strQuery += 'Bare_Die_Shipment_Forecast_Date_OR__c, Delivery_Qty_Die_Form__c, MPW_Prime_Die__r.Fab_ID__c ';
        strQuery += 'FROM MPW_WIP_Lot__c WHERE MPW_Prime_Die__r.MPW_Form__r.Customer_Company_Name__c =: strAccountId AND Active_Flag__c = TRUE ';
        
        try {
            Date dtFromDate = oWIPDummy.Notification_Start_Date__c;
            Date dtToDate = oWIPDummy.Notification_End_Date__c;
            
            if(dtFromDate != null) {
                strQuery += ' AND Customer_Tapeout_Date__c >=: dtFromDate ';
            }   
            
            if(dtToDate != null) {
                strQuery += ' AND Customer_Tapeout_Date__c <=: dtToDate ';
            }
            
            strQuery += ' ORDER BY ' + strSortField + ' ' +  strSortType + ' NULLS LAST LIMIT 1000';
            
            for(MPW_WIP_Lot__c oMWL : database.query(strQuery)) {
                tempList.add(oMWL);
            }
            
            if(tempList.size() > 0) {
                tempMap = paginateRecords(tempList);
            }
        }
        catch(exception ex) {
            MPWExceptionHandler.exceptionHandler(ex, MPWCustomerWIPController.class.getName(), 'retrieveMPWAssignments()', '', 'My MPW WIP');
        }
        return tempMap;
    }
    
    /*
    * Description : Method to retrieve Manufacturing Lot Assignment in excel format.
    */
    public PageReference exportToExcel() {
        String strFromDate = '';
        String strToDate = '';
        
        try {
            if(oWIPDummy.Notification_Start_Date__c != null) {
                strFromDate = oWIPDummy.Notification_Start_Date__c.year() + '-' + oWIPDummy.Notification_Start_Date__c.month() + '-' + oWIPDummy.Notification_Start_Date__c.day();
            }
            if(oWIPDummy.Notification_End_Date__c != null) {
                strToDate = oWIPDummy.Notification_End_Date__c.year() + '-' + oWIPDummy.Notification_End_Date__c.month() + '-' + oWIPDummy.Notification_End_Date__c.day();
            }
        }
        catch(exception ex) {
            MPWExceptionHandler.exceptionHandler(ex, MPWCustomerWIPController.class.getName(), 'exportToExcel()', '', 'My MPW WIP');
        }
        
        PageReference pref = new PageReference('/apex/MPWCustomerWIPExcel?fromDt=' + strFromDate + '&toDt=' + strToDate);
        pref.setRedirect(true);
        return pref;
    }
    
    /*
    * Description : Method for report subscription
    */
    public void reportSchedule() {
        isReportSchedule = true;
        oReportScheduleCS = new MPW_WIP_Report_Schedule__c();
        oReportScheduleCS.Name = UserInfo.getUserId();
        oReportScheduleCS.User_Name__c = UserInfo.getUserName();
        oReportScheduleCS.Scheduled_Frequency1__c = 'DAILY';
        oReportScheduleCS.Start_Date__c = date.today();
        oReportScheduleCS.End_Date__c = date.today().addMonths(12);
        oReportScheduleCS.Scheduled_Frequency2__c = 'EVERY_WEEKDAY';
        strScheduledFrequency=oReportScheduleCS.Scheduled_Frequency1__c ;
    }
    
    /*
    * Description : Method for editing report subscription
    */
    public void editReportSchedule() {
        isReportSchedule = true;
        oReportScheduleCS = new MPW_WIP_Report_Schedule__c();
        for(MPW_WIP_Report_Schedule__c cs : [SELECT Id, Name, Day_of_Month__c, Scheduled_Frequency1__c, Scheduled_Frequency2__c, 
                                                Start_Date__c, End_Date__c
                                                FROM MPW_WIP_Report_Schedule__c
                                                WHERE Name =: UserInfo.getUserId()]) {
            oReportScheduleCS = cs;
        }
    }
    
    /*
    * Description : Method for saving report subscription
    */
    public void saveReportSchedule() {
        isReportSchedule = false; 
        oReportScheduleCS.Scheduled_Frequency1__c=strScheduledFrequency;
        upsert oReportScheduleCS;
    }
    
    /*
    * Description : Method for deleting report subscription
    */
    public void deleteReportSchedule() {
        isReportSchedule = false;
        delete oReportScheduleCS;
        oReportScheduleCS = new MPW_WIP_Report_Schedule__c();
    }
    
    /*
    * Description : Method for cancel report subscription
    */
    public void cancelReportSchedule() {
        isReportSchedule = false;
    }
    
    /*
    * Description : Method for rendering day for Weekly frequency selection
    */
    public void renderFrequency() {
        if(oReportScheduleCS.Id == null) {
            if(oReportScheduleCS.Scheduled_Frequency1__c == 'DAILY') {
                oReportScheduleCS.Scheduled_Frequency2__c = 'EVERY_WEEKDAY';
            }
            else if(oReportScheduleCS.Scheduled_Frequency1__c == 'WEEKLY') {
                //Datetime dt = (datetime)date.today();
                //String strDay = dt.format('EEEE').toUpperCase();
                oReportScheduleCS.Scheduled_Frequency2__c = 'WEDNESDAY';
            }
        }
    }
    
    /*
    * Description : Method to bind pagination logic for Manufacturing Lot Assignment.
    */
    private Map<Integer, List<MPW_WIP_Lot__c>> paginateRecords(List<MPW_WIP_Lot__c> tempList) {
        Map<Integer, List<MPW_WIP_Lot__c>> tempMap = new Map<Integer, List<MPW_WIP_Lot__c>>();
        Integer pageNo = 1;
        intCurrentPageNo = 1;
        List<MPW_WIP_Lot__c> temp = new List<MPW_WIP_Lot__c>();
       
       for (MPW_WIP_Lot__c m : tempList) {
            if(temp.size() < recordsPerPage) {
                temp.add(m);
            } 
            else {
                tempMap.put(pageNo, temp);
                pageNo++;
                temp = new List<MPW_WIP_Lot__c>();
                temp.add(m);
            }
        }
        
        if(temp.size() > 0) {
            tempMap.put(pageNo, temp);
        }
        
        intTotalNoOfPages = pageNo;
        intTotalNoOfRecords  = tempList.size();
        
        return tempMap;
    }
    
    /*
    * Description : Method to retrieve Manufacturing Lot Assignment information based on Customer Tapeout Date.
    */
    public void filterWIP() {
        mapMPWAssignment = new Map<Integer, List<MPW_WIP_Lot__c>>();
        mapMPWAssignment = retrieveMPWAssignments();
    }
    
    /*
    * Description : Method to retrieve Manufacturing Lot Assignment based on current page number.
    */
    public List<MPW_WIP_Lot__c> getMyMPWAssignments() {
        try {
            return (mapMPWAssignment.size() > 0 ? mapMPWAssignment.get(intCurrentPageNo) : new List<MPW_WIP_Lot__c>());
        }
        catch(exception ex) {
            MPWExceptionHandler.exceptionHandler(ex, MPWCustomerWIPController.class.getName(), 'getMyMPWAssignments()', '', 'My MPW WIP');
            return new List<MPW_WIP_Lot__c>();
        }
    }
    
    /*
    * Description : Method to sort Manufacturing Lot Assignment.
    */
    public void sortRecords() {
        strSortType = strSortType == 'ASC' ? 'DESC' : 'ASC';
        
        mapMPWAssignment = new Map<Integer, List<MPW_WIP_Lot__c>>();
        mapMPWAssignment = retrieveMPWAssignments();
    }
    
    /*
    * Description : Method to check previous page Manufacturing Lot Assignment.
    */
    public boolean getHasPrevious() {
        return (intCurrentPageNo > 1 ? true : false);
    }
    
    /*
    * Description : Method to check next page Manufacturing Lot Assignment.
    */
    public boolean getHasNext() {
        return (intCurrentPageNo < intTotalNoOfPages ? true : false);
    }
    
    /*
    * Description : Method to retrieve previous page Manufacturing Lot Assignment.
    */
    public void previous() {
        intCurrentPageNo--;
    }
    
    /*
    * Description : Method to retrieve next page Manufacturing Lot Assignment.
    */
    public void next() {
        intCurrentPageNo++;
    }
    
    /*
    * Description : Method to retrieve first page Manufacturing Lot Assignment.
    */
    public void first() {
        intCurrentPageNo = 1; 
    }
    
    /*
    * Description : Method to retrieve last page Manufacturing Lot Assignment.
    */
    public void last() {
        intCurrentPageNo = intTotalNoOfPages;  
    }
    
   
    
    
}