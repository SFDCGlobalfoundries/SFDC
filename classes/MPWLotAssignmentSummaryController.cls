/**
* Author: Anil Kumar
* Company: JK Technosoft
* Project: MPW
* Description: Used for viewing and setting notification interval for Assignment already done
* History:
*    Anil Kumar 31/05/2016 - Created
**/
public with sharing class MPWLotAssignmentSummaryController {

    public List<AssignmentWrapper> lstAssignmentGroups      {get; set;}
    public List<MPWWIPWrapper> lstPopupMPWWIPLot            {get; set;}
    public String strAssignmentName                         {get; set;}
    public String strSelectAssignment                       {get; set;}
    public String strAssignmentUserId                       {get; set;}
    public Boolean showPopupOnLoad                          {get; set;}
    
    public MPWLotAssignmentSummaryController(){
        lstAssignmentGroups = new List<AssignmentWrapper>();
        lstPopupMPWWIPLot = new List<MPWWIPWrapper>();
        showPopupOnLoad = false;
        String strAssignmentNameTemp = ApexPages.currentPage().getParameters().get('name');
        strAssignmentName = '';
        
        if(strAssignmentNameTemp != null && strAssignmentNameTemp.trim() != '') {
            strAssignmentName = strAssignmentNameTemp;
            showPopupOnLoad = true;
        }
        
        strSelectAssignment = 'my';
        loadAssignmentSummary();
    }
    
    /*
    * Description : Method to retrieve Manufacturing Lot Assignment based on Assignment Group Name.
    */
    public void loadAssignmentSummary(){
        lstAssignmentGroups = new List<AssignmentWrapper>();
        Map<String, MPW_WIP_Lot__c> mapNotification = new Map<String, MPW_WIP_Lot__c>();
        
        String strQuery1 = 'SELECT Id, Saved_User__c, Assignment_Group_Name__c, Notification_Interval_Days__c, Notification_Start_Date__c, ' +
                            'Notification_End_Date__c FROM MPW_WIP_Lot__c ';
        String strQuery2 = 'SELECT Count(Id) c, Assignment_Group_Name__c, Saved_User__c FROM MPW_WIP_Lot__c ';
        
        try {
            if(strSelectAssignment == 'my') {
                strQuery1 += ' WHERE Saved_User__c = \'' + UserInfo.getUserId() + '\'';
                strQuery2 += ' WHERE Saved_User__c = \'' + UserInfo.getUserId() + '\'';
            }
            
            strQuery1 += ' ORDER BY Assignment_Group_Name__c DESC NULLS LAST LIMIT 10000';
            strQuery2 += ' GROUP BY Assignment_Group_Name__c, Saved_User__c ORDER BY Saved_User__c DESC, Assignment_Group_Name__c DESC LIMIT 10000';
            
            for(MPW_WIP_Lot__c oMWL : database.query(strQuery1)) {
                String strKey = oMWL.Assignment_Group_Name__c.toLowerCase() + String.valueOf(oMWL.Saved_User__c);
                if(!mapNotification.containsKey(strKey)) {
                    mapNotification.put(strKey, oMWL);
                }
            }
            
            for(AggregateResult aggr : database.query(strQuery2)) {
                String strAssigTemp = String.valueOf(aggr.get('Assignment_Group_Name__c'));
                AssignmentWrapper oAssignmentWrapper = new AssignmentWrapper();
                oAssignmentWrapper.intAssignmentCount = Integer.valueOf(aggr.get('c'));
                oAssignmentWrapper.isAllowEdit = aggr.get('Saved_User__c') == UserInfo.getUserId() ? true : false;
                MPW_WIP_Lot__c oMWL = new MPW_WIP_Lot__c();
                oMWL.Assignment_Group_Name__c = strAssigTemp;
                oMWL.Saved_User__c = String.valueOf(aggr.get('Saved_User__c'));
                String strKey = strAssigTemp.toLowerCase() + String.valueOf(aggr.get('Saved_User__c'));
                oMWL.Notification_Start_Date__c = mapNotification.containsKey(strKey) ? mapNotification.get(strKey).Notification_Start_Date__c : null;
                oMWL.Notification_End_Date__c = mapNotification.containsKey(strKey) ? mapNotification.get(strKey).Notification_End_Date__c : null;
                oMWL.Notification_Interval_Days__c = (mapNotification.containsKey(strKey) && mapNotification.get(strKey).Notification_Interval_Days__c != null) ? Integer.valueOf(mapNotification.get(strKey).Notification_Interval_Days__c) : 0;
                oAssignmentWrapper.oMPWWIPLot = oMWL;
                lstAssignmentGroups.add(oAssignmentWrapper);
            }
        }
        catch(Exception ex) {
            ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR, ex.getMessage());
            ApexPages.addMessage(msg);
            MPWExceptionHandler.exceptionHandler(ex, MPWLotAssignmentSummaryController.class.getName(), 'loadAssignmentSummary()', '', 'Manufacturing Lot Assignment Summary');
        }
    }
    
    /*
    * Description : Method to Save Manufacturing Lot Assignment setting.
    */
    public void saveAssignmentSummary(){
        List<MPW_WIP_Lot__c> lstMPWWIPLot = new List<MPW_WIP_Lot__c>();
        Map<String, AssignmentWrapper> mapAssignmentWrapper = new Map<String, AssignmentWrapper>();
        
        for(AssignmentWrapper oAW : lstAssignmentGroups) {
            if(oAW.isAllowEdit) {
                mapAssignmentWrapper.put(oAW.oMPWWIPLot.Assignment_Group_Name__c.toLowerCase(), oAW);
            }
        }
        
        for(MPW_WIP_Lot__c oM : [SELECT Id, Assignment_Group_Name__c, Saved_User__c, 
                                Notification_Interval_Days__c, Notification_Start_Date__c, Notification_End_Date__c  
                                FROM MPW_WIP_Lot__c 
                                WHERE Assignment_Group_Name__c != null AND Assignment_Group_Name__c IN: mapAssignmentWrapper.keySet() 
                                AND Saved_User__c =: UserInfo.getUserId() ]) {
            String strKey = oM.Assignment_Group_Name__c.toLowerCase();
            
            oM.Notification_Interval_Days__c = mapAssignmentWrapper.get(strKey).oMPWWIPLot.Notification_Interval_Days__c;
            oM.Notification_Start_Date__c = mapAssignmentWrapper.get(strKey).oMPWWIPLot.Notification_Start_Date__c;
            oM.Notification_End_Date__c = mapAssignmentWrapper.get(strKey).oMPWWIPLot.Notification_End_Date__c;
            lstMPWWIPLot.add(oM);
        }
        
        if(lstMPWWIPLot.size() > 0) {
            Savepoint sp = Database.setSavepoint();
            try {
                update lstMPWWIPLot;
            }
            catch(Exception ex) {
                Database.rollback(sp);
                ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR, ex.getMessage());
                ApexPages.addMessage(msg);
                MPWExceptionHandler.exceptionHandler(ex, MPWLotAssignmentSummaryController.class.getName(), 'saveAssignmentSummary()', '', 'Manufacturing Lot Assignment Summary');
            }
        }
        
        loadAssignmentSummary();
    }
    
    /*
    * Description : Method to get list of MPW_WIP_Lot__c for selected Assignment Group
    */
    public void loadPopupMPWWIPLot(){
        lstPopupMPWWIPLot = new List<MPWWIPWrapper>();
        
        try {
            for(MPW_WIP_Lot__c oMWL : [SELECT Id, Assignment_Group_Name__c, Notification_Interval_Days__c, MPW_MES_Part_ID__c, 
                                        Assignment_Type__c, Manufacturing_Lot__c, Manufacturing_Lot_Id__c, Saved_User__c, MPW_Prime_Die__c, 
                                        Prime_Die_Name__c, MPW_Train_Name__c, MPW_Prime_Die__r.MPW_Form__c, MPW_form__c, 
                                        MPW_Prime_Die__r.Account_Name__c, MPW_Form_Customer_Account_Name__c, 
                                        MPW_Prime_Die__r.MPW_Form__r.Customer_Company_Name__c, 
                                        Bare_Die_Shipment_Forecast_Date_BL__c, Bare_Die_Shipment_Forecast_Date_OR__c,
                                        Current_Scheduled_Date_CSD__c, Current_Scheduled_Date_CSD_OR__c
                                        FROM MPW_WIP_Lot__c WHERE Assignment_Group_Name__c =: strAssignmentName AND Saved_User__c =: strAssignmentUserId ORDER BY Manufacturing_Lot_Id__c, Prime_Die_Name__c LIMIT 1000]) {
                MPWWIPWrapper oW = new MPWWIPWrapper();
                oW.oMPWWIPLot = oMWL;
                oW.strForecastDateBL = '';
                oW.strForecastDateOR = '';
                oW.strCSDBL = '';
                oW.strCSDOR = '';
                
                Date dtForecastDateBL = oMWL.Bare_Die_Shipment_Forecast_Date_BL__c;
                if(dtForecastDateBL != null) {
                    String strMonth = dtForecastDateBL.month() < 10 ? '0' + String.valueOf(dtForecastDateBL.month()) : String.valueOf(dtForecastDateBL.month());
                    String strDay = dtForecastDateBL.day() < 10 ? '0' + String.valueOf(dtForecastDateBL.day()) : String.valueOf(dtForecastDateBL.day());
                    oW.strForecastDateBL = String.valueOf(dtForecastDateBL.year()) + strMonth + strDay;
                }
                
                Date dtForecastDateOR = oMWL.Bare_Die_Shipment_Forecast_Date_OR__c;
                if(dtForecastDateOR != null) {
                    String strMonth = dtForecastDateOR.month() < 10 ? '0' + String.valueOf(dtForecastDateOR.month()) : String.valueOf(dtForecastDateOR.month());
                    String strDay = dtForecastDateOR.day() < 10 ? '0' + String.valueOf(dtForecastDateOR.day()) : String.valueOf(dtForecastDateOR.day());
                    oW.strForecastDateOR = String.valueOf(dtForecastDateOR.year()) + strMonth + strDay;
                }
                
                Date dtCSDBL = oMWL.Current_Scheduled_Date_CSD__c;
                if(dtCSDBL != null) {
                    String strMonth = dtCSDBL.month() < 10 ? '0' + String.valueOf(dtCSDBL.month()) : String.valueOf(dtCSDBL.month());
                    String strDay = dtCSDBL.day() < 10 ? '0' + String.valueOf(dtCSDBL.day()) : String.valueOf(dtCSDBL.day());
                    oW.strCSDBL = String.valueOf(dtCSDBL.year()) + strMonth + strDay;
                }
                
                Date dtCSDOR = oMWL.Current_Scheduled_Date_CSD_OR__c;
                if(dtCSDOR != null) {
                    String strMonth = dtCSDOR.month() < 10 ? '0' + String.valueOf(dtCSDOR.month()) : String.valueOf(dtCSDOR.month());
                    String strDay = dtCSDOR.day() < 10 ? '0' + String.valueOf(dtCSDOR.day()) : String.valueOf(dtCSDOR.day());
                    oW.strCSDOR = String.valueOf(dtCSDOR.year()) + strMonth + strDay;
                }
                
                lstPopupMPWWIPLot.add(oW);
            }
        }
        catch(Exception ex) {
            ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR, ex.getMessage());
            ApexPages.addMessage(msg);
            MPWExceptionHandler.exceptionHandler(ex, MPWLotAssignmentSummaryController.class.getName(), 'loadPopupMPWWIPLot()', '', 'Manufacturing Lot Assignment Summary');
        }
    }
    
    public class MPWWIPWrapper {
        public MPW_WIP_Lot__c oMPWWIPLot        {get; set;}
        public String strForecastDateBL         {get; set;}
        public String strForecastDateOR         {get; set;}
        public String strCSDBL                  {get; set;}
        public String strCSDOR                  {get; set;}
    }
    
    public class AssignmentWrapper {
        public MPW_WIP_Lot__c oMPWWIPLot        {get; set;}
        public Integer intAssignmentCount       {get; set;}
        public Boolean isAllowEdit              {get; set;}
    }
}