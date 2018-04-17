/**
* Author: Anil Kumar
* Company: JK Technosoft
* Project: MPW
* Description: Used to download Prime Die Assignment of Customer in Excel format
* History:
*    Anil Kumar 08/07/2016 - Created
**/
public without sharing class MPWCustomerWIPExcelController {

    public transient List<MPW_WIP_Lot__c> lstAssignments    {get; set;}
    public Date dtFromDate                                  {get; set;}
    public Date dtToDate                                    {get; set;}
    
    public MPWCustomerWIPExcelController(){
        lstAssignments = new List<MPW_WIP_Lot__c>();
        retrieveMPWAssignments();
    }
    
    /*
    * Description : Method to retrieve Manufacturing Lot Assignment based on logged in user.
    */
    private void retrieveMPWAssignments() {
        lstAssignments = new List<MPW_WIP_Lot__c>();
        String strAccountId = '';
        
        //Kanishk:1bf6628702622c8 parm is internal use only . request comes from Batch class to attach this report in email 
        String strUserName = ApexPages.currentPage().getParameters().get('1bf6628702622c8');
        
        User objLoggedInUser =null;
        if(strUserName!=null && strUserName!=''){
        	objLoggedInUser=[SELECT Id, Name, Email, Username FROM User WHERE Username =: strUserName];
        }else{
        	objLoggedInUser=[SELECT Id, Name, Email, Username FROM User WHERE Id =: UserInfo.getUserId()];
        }
         
        
        for(Contact objContact : [SELECT Id, User_Name__c, AccountId FROM Contact WHERE User_Name__c =: objLoggedInUser.Username LIMIT 1]) {
            strAccountId = objContact.AccountId;
        }
        
        String strQuery = 'SELECT Id, Name, Prime_Die_Name__c, Sales_Order__c, Geometry__c, Customer_Tapeout_Date__c, MPW_Train_Name__c, ';
        strQuery += 'MPW_Form_Customer_Account_Name__c, MPW_form__c, Current_Scheduled_Date_CSD__c, Current_Scheduled_Date_CSD_OR__c, ';
        strQuery += 'Current_Mask_Layer__c, Remaining_Mask_Count__c, Current_Lot_Location__c, Lot_Last_Modified_Date__c, Lot_State__c, ';
        strQuery += 'Stage_Name__c, Technology_Type__c, Active_Flag__c, Bare_Die_Shipment_Forecast_Date_BL__c, ';
        strQuery += 'Bare_Die_Shipment_Forecast_Date_OR__c, Delivery_Qty_Die_Form__c, MPW_Prime_Die__r.Fab_ID__c ';
        strQuery += 'FROM MPW_WIP_Lot__c WHERE MPW_Prime_Die__r.MPW_Form__r.Customer_Company_Name__c =: strAccountId AND Active_Flag__c = TRUE  ';
        
        String strFromDate = ApexPages.currentPage().getParameters().get('fromDt');
        String strToDate = ApexPages.currentPage().getParameters().get('toDt');
        
        try {
            if(strFromDate != null && strFromDate.trim() != '' && strFromDate.split('-').size() == 3) {
                dtFromDate = date.valueOf(strFromDate);
                strQuery += ' AND Customer_Tapeout_Date__c >=: dtFromDate ';
            }
            
            if(strToDate != null && strToDate.trim() != '' && strToDate.split('-').size() == 3) {
                dtToDate = date.valueOf(strToDate);
                strQuery += ' AND Customer_Tapeout_Date__c <=: dtToDate ';
            }
            
            strQuery += ' ORDER BY Manufacturing_Lot_Id__c NULLS LAST LIMIT 10000';
        
            for(MPW_WIP_Lot__c oMWL : database.query(strQuery)) {
                lstAssignments.add(oMWL);
            }
        }
        catch(exception ex) {       
            MPWExceptionHandler.exceptionHandler(ex, MPWCustomerWIPExcelController.class.getName(), 'retrieveMPWAssignments()', '', 'My MPW WIP Excel');
        }
    }
}