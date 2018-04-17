/*
 Type Name: ClsMyWafers
 Author: Cognizant Technology Solutions
 Created Date: 15-April-2013
 Modified Date : 27-Aug-2013
 Reason: This class is responsible for showing the my wafers details for portal user.
 Change History:Case-4331
    ZAmbat      09162014    - Updated code as per CASE 34625.
 Author: Cognizant FV Team
 Modified Date: Jan-08-2014
 Reason: Replacing Portal Login ID with Federation ID 
 
 Modified Date : Mar-11-2015
 Modified by : Sunil Arora
 Reason : For case # 39091 as showpageBlock was written instead of showdetailsectio
 Modified Date : Nov-09-2016
 Modified by : Sunita char
 Reason : For adding the reports link for Fab 9/10 reports in My wafers Tab in Community
 
 Modified Date : Feb-10-2017
 Modified by : Sridhar Gopireddy
 Reason : For adding the Pick All Map link for Fab 9/10 reports in My wafers Tab in Community
 
 Modified Date : March-31-2017
 Modified by : Praodsh Samal
 Reason : Changes for Pick All Map
 
 Modified Date : Sept-28-2017
 Modified by : Amit Kumar Ojha
 Reason : for WIP Tracking Report Case-00079786
 
 Modified Date : Oct-1o-2017
 Modified by : Amit Kumar Ojha
 Reason : for Shipment Container Link on myWafer Tab Fab 9/10 Report Case-00080619
 ……..
 …….. 
 ……..
*/


public with sharing class ClsMyWafers
{

     /**
    
    Variable Declaration
    
    */
    
    public String Page {get; set;}
    public Boolean showwelcomesection{get;set;}
    public Boolean showpageBlock{get;set;}
    public Boolean showdetailsection{get;set;}
    public String OpenPageURL {get; set;}
    public String OpenTextLoginServerURL {get; set;}
    public String respectivelevel{get;set;}
    public String respectivesublevel{get;set;}
    public Boolean showsubpanelLabel {get;set;}
    public Boolean showorderLink{get;set;}
    public Boolean showproductionLink{get;set;}
    public Boolean showshippingLink{get;set;}
    public Boolean showorderqueryLink{get;set;}
    public Boolean showproductionqueryLink{get;set;}
    public Boolean showshippingqueryLink{get;set;}
    public Boolean showorderSection{get;set;}
    public Boolean showprodSection{get;set;}
    public Boolean showshippSection{get;set;}
    
    public Boolean disableforecast{get;set;}
    public Boolean disablewaferst{get;set;}
    public Boolean disablewipstat{get;set;}
    public Boolean disablefabout{get;set;}
    public Boolean disablefinishreport{get;set;}
    public Boolean disablelotctrltable{get;set;}
    public Boolean disablemfgreport{get;set;}
    public Boolean disablescrapreport{get;set;}
    public Boolean disablewaferscrap{get;set;}
    public Boolean disablelothistory{get;set;}
    public Boolean disablefabwip{get;set;}
    public Boolean disablecycletime{get;set;}
    public Boolean disableengineeringwip{get;set;}
    public Boolean disableglobalshuttlempwwip{get;set;}
    public boolean disablePoLeadTime {get;set;}
    
    public Boolean disableacctstate{get;set;}
    public Boolean disablebklog{get;set;}
    public Boolean disablebilling{get;set;}
    public Boolean disablecredit{get;set;}
    public Boolean disablenre{get;set;}
    public Boolean disabletax{get;set;}
    public Boolean disableorderack{get;set;}
    public Boolean disableromblanket{get;set;}
    public Boolean disablepurchaseorder{get;set;}
    public Boolean disableorderreport{get;set;} 
     
    public Boolean disablecertificate{get;set;}
    public Boolean disabledelivery{get;set;}
    public Boolean disablepkgreport{get;set;}
    public Boolean disablecustomshipreport{get;set;}
    public Boolean disableshipalert{get;set;}
    public Boolean disableshipdetail{get;set;}
    public Boolean disableshipalertloc{get;set;}
    public String portalLoginUser;
    
/*-----added for modified for Icc by sunita start-------------------------------*/    
    public Boolean disableorder{get;set;}
    public Boolean disableshipment{get;set;}
    public Boolean disableinvoice{get;set;}
    public Boolean disableearlywarning{get;set;}
    public Boolean disablewipstatus{get;set;}
    public Boolean disablewiplotgatehistory{get;set;}
    public Boolean disablenonetlot{get;set;}
    public Boolean disablepackinglist{get;set;}
    public Boolean disableTaxInvoice2{get;set;}
    public Boolean disableorderack2{get;set;}
    public Boolean showFab9_10_Subscriptions {get;set;}
/*-----added for modified for Icc by sunita end-------------------------------*/       
    
    // FOR Fab 9/10 WIP Reports
    public Environment_Variable__c label;
    public Environment_Variable__c labelURL;
    public Environment_Variable__c shipmentContainerLabel;
    public Environment_Variable__c shipmentContainerLabelURL;
    public String WIP_Visibility {get; set;}
    public String Shipment_Container {get; set;}
    //
    private List<Portal_Tab_Access__c> portaltabaccessList = new List<Portal_Tab_Access__c>();
    User userObj = new User();
    
	public Boolean showPickAllKerfMapLink {get;set;}
	
      /**
        This method controls to showing the Links in the left hand panel and to
        create the Pageblock table where showing the My Wafers documents list.
        
        @method name: ClsMyWafers 
        @return : Boolean variables are set to true according to the Portal Tab Access record and 
                  returns the test data in the respective pageblock table.
     */
   
    public ClsMyWafers ()
    {
        showFab9_10_Subscriptions = false;
        showPickAllKerfMapLink = FALSE;
     	/**Added by Amit for WIP Tracking Report Case-00079786 on 09/28/2017**/
     	WIP_Visibility = '';
     	label = Environment_Variable__c.getInstance('ICC FAB 9/10 WIP Visibility');
        labelURL = Environment_Variable__c.getInstance('ICC FAB 9/10 WIP Visibility URL');
        
        if(label != null && label.Value__c != null) {    
        	WIP_Visibility = label.Value__c;
        }
        /**End Amit***/
        /**Added by Amit for Shipment Container Link under Shipment on Fab9/10 Report Case-00080619 on 10/12/2017**/
        Shipment_Container = '';
     	shipmentContainerLabel = Environment_Variable__c.getInstance('ICC FAB 9/10 Shipment Container');
        shipmentContainerLabelURL = Environment_Variable__c.getInstance('ICC FAB 9/10 Shipment Container URL');
        
        if(shipmentContainerLabel != null && shipmentContainerLabel.Value__c != null) {    
        	Shipment_Container = shipmentContainerLabel.Value__c;
        }
        /**End Amit***/
        //Case-4331:Adding Federation ID in query:Change-001
        userObj = [SELECT accountId,FederationIdentifier,Portal_Login__c,UserType,ContactId FROM User WHERE Id =:userInfo.getUserId()];
        
        for(Portal_Tab_Access__c obj :  [SELECT GFV_Fab9_10_Reports__c, Yield_Sort_ETest_Reporting__c FROM Portal_Tab_Access__c WHERE Contact__c =: userObj.ContactId]){
            
            if(obj.GFV_Fab9_10_Reports__c){
                showFab9_10_Subscriptions = TRUE;
            }
            
            if(obj.Yield_Sort_ETest_Reporting__c){
                showPickAllKerfMapLink = TRUE;
            }
        }
        
        for(User u: [Select ContactId FROM User WHERE Id =: UserInfo.getUserId()])
        {
            if(u.ContactId == null)
                showFab9_10_Subscriptions = true;
        }
        
        
        portaltabaccessList = [Select p.Wafer_Start__c, 
                                      p.WIP_Status__c, 
                                      p.Tax_Invoice__c, 
                                      p.Shipping_Query__c, 
                                      p.Shipment_Detail_Unsort_and_Sort__c, 
                                      p.Shipment_Alert_Report__c, 
                                      p.Ship_Alert_by_Location__c, 
                                      p.ROM_Blanket__c, 
                                      p.Production_Query__c, 
                                      p.Packaging_List_Report__c, 
                                      p.Order_Query__c, 
                                      p.Order_Acknowledgement__c, 
                                      p.On_Time_Delivery__c, 
                                      p.NRE_Invoice__c, 
                                      p.Lot_Control_table__c, 
                                      p.Forecast_Fab_Cycle_Time__c, 
                                      p.Finish_Goods_Report__c, 
                                      p.Fab_Out_Schedule__c, 
                                      p.Custom_Shipment_Report__c, 
                                      p.Credit_and_Debit_Note__c, 
                                      p.Certificate_of_Compliance__c, 
                                      p.Billing__c, 
                                      p.Purchase_Order_Tracking__c,
                                      p.Backlog__c, 
                                      p.Shipping__c, 
                                      p.Production__c, 
                                      p.Orders__c,
                                      p.Wafer_Scrap__c, 
                                      p.Scrap_Reports__c, 
                                      p.Lot_History__c, 
                                      p.Fab_WIP__c, 
                                      p.Custom_Order_Report__c, 
                                      p.Custom_Mfg_Report__c,
                                      p.Account_Statement__c,
                                      p.Cycle_Time__c,
                                      p.Engineering_WIP__c,
                                      p.GlobalShuttle_MPW_WIP__c,
                                      p.GFV_Fab9_10_Reports__c,
                                      p.PO_Lead_Time__c From Portal_Tab_Access__c p
                                       WHERE p.User__c = :userInfo.getUserId()
                                           AND p.Account__c =:userObj.accountId ];
        
        if(userObj.UserType == System.Label.Standard)
        {
            disableforecast=disablewaferst=disablewipstat=disablefabout=disablefinishreport=disablelotctrltable=disablemfgreport=
            disablewaferscrap=disablelothistory=disablefabwip=disablescrapreport=disableacctstate=disablebklog=disablebilling=
            disablecredit=disableorderack=disableromblanket=disablenre=disabletax=disablepurchaseorder=disableorderreport=
            disablecertificate=disabledelivery=disablepkgreport=disablecustomshipreport=disableshipalert=disableshipdetail=
            disableorder=disableshipment=disableinvoice=disableearlywarning=disablewipstatus=disablewiplotgatehistory=disablenonetlot=
            disableshipalertloc=showproductionqueryLink=showorderqueryLink=showshippingqueryLink= disablecycletime = disableengineeringwip = disableglobalshuttlempwwip = disablePoLeadTime = TRUE;        
        }
        else if(portaltabaccessList.size()>0)
        {
            for(Portal_Tab_Access__c portaltabaccessObj : portaltabaccessList)
            {
                
                
               if(portaltabaccessObj.Orders__c == TRUE)
                    showorderLink = TRUE;
                else
                    showorderLink = FALSE;
                
                if(portaltabaccessObj.Production__c == TRUE)
                    showproductionLink= TRUE;
                else
                    showproductionLink= FALSE;
                    
                if(portaltabaccessObj.Shipping__c == TRUE)
                    showshippingLink= TRUE;
                else
                    showshippingLink= FALSE;

                
                
                
                
                if(portaltabaccessObj.Order_Query__c == TRUE)
                    showorderqueryLink = TRUE;
                else
                    showorderqueryLink = FALSE;
                
                if(portaltabaccessObj.Production_Query__c == TRUE)
                    showproductionqueryLink= TRUE;
                else
                    showproductionqueryLink= FALSE;
                    
                if(portaltabaccessObj.Shipping_Query__c == TRUE)
                    showshippingqueryLink= TRUE;
                else
                    showshippingqueryLink= FALSE;
            
            
            ///////////////////// ORDERS //////////////////////////////////
            
            if(portaltabaccessObj.Account_Statement__c == TRUE)
                    disableacctstate = TRUE;
            else
                   disableacctstate = FALSE;
                    
            if(portaltabaccessObj.Backlog__c == TRUE)
                    disablebklog = TRUE;
                else
                    disablebklog = FALSE;
                    
            if(portaltabaccessObj.Billing__c == TRUE)
                    disablebilling = TRUE;
                else
                    disablebilling = FALSE;
                    
            if(portaltabaccessObj.Credit_and_Debit_Note__c == TRUE)
                    disablecredit = TRUE;
                else
                    disablecredit = FALSE;
                    
            if(portaltabaccessObj.NRE_Invoice__c == TRUE)
                    disablenre = TRUE;
                else
                    disablenre = FALSE;
                    
            if(portaltabaccessObj.Tax_Invoice__c == TRUE)
                    disabletax = TRUE;
                else
                    disabletax = FALSE;
                    
            if(portaltabaccessObj.Order_Acknowledgement__c == TRUE)
                    disableorderack = TRUE;
                else
                    disableorderack = FALSE;
                    
            if(portaltabaccessObj.ROM_Blanket__c == TRUE)
                    disableromblanket = TRUE;
                else
                    disableromblanket = FALSE;   
                    
            if(portaltabaccessObj.Purchase_Order_Tracking__c == TRUE)
                    disablepurchaseorder = TRUE;
                else
                    disablepurchaseorder = FALSE;
                    
            if(portaltabaccessObj.Custom_Order_Report__c == TRUE)
                    disableorderreport = TRUE;
                else
                    disableorderreport = FALSE;
                    
                    
            ////////////PRODUCTION////////////////////
          
             if(portaltabaccessObj.Forecast_Fab_Cycle_Time__c == TRUE)
                    disableforecast = TRUE;
                else
                    disableforecast = FALSE;
                    
            if(portaltabaccessObj.Wafer_Start__c == TRUE)
                    disablewaferst = TRUE;
                else
                    disablewaferst = FALSE;
                    
            if(portaltabaccessObj.WIP_Status__c == TRUE)
                    disablewipstat = TRUE;
                else
                    disablewipstat = FALSE;
                    
             if(portaltabaccessObj.Fab_Out_Schedule__c == TRUE)
                    disablefabout = TRUE;
                else
                    disablefabout = FALSE;
                    
             if(portaltabaccessObj.Finish_Goods_Report__c == TRUE)
                    disablefinishreport = TRUE;
                else
                    disablefinishreport = FALSE;
                    
             if(portaltabaccessObj.Lot_Control_table__c == TRUE)
                    disablelotctrltable = TRUE;
                else
                    disablelotctrltable = FALSE; 
                    
             if(portaltabaccessObj.Custom_Mfg_Report__c == TRUE)
                    disablemfgreport = TRUE;
                else
                    disablemfgreport = FALSE; 
                    
             if(portaltabaccessObj.Fab_WIP__c == TRUE)
                    disablefabwip = TRUE;
                else
                    disablefabwip = FALSE; 
                    
             if(portaltabaccessObj.Scrap_Reports__c== TRUE)
                    disablescrapreport = TRUE;
                else
                    disablescrapreport = FALSE; 
                    
             if(portaltabaccessObj.Wafer_Scrap__c == TRUE)
                    disablewaferscrap = TRUE;
                else
                    disablewaferscrap = FALSE; 
                    
            if(portaltabaccessObj.Lot_History__c == TRUE)
                    disablelothistory = TRUE;
                else
                    disablelothistory = FALSE;              
                     
             if(portaltabaccessObj.Cycle_Time__c == TRUE)
                    disablecycletime = TRUE;
                else
                    disablecycletime = FALSE;
            
            if(portaltabaccessObj.Engineering_WIP__c == TRUE)
                    disableengineeringwip = TRUE;
                else
                    disableengineeringwip = FALSE;
                    
            if(portaltabaccessObj.GlobalShuttle_MPW_WIP__c == TRUE)
                    disableglobalshuttlempwwip = TRUE;
                else
                    disableglobalshuttlempwwip = FALSE;
            
            if (portaltabaccessObj.Forecast_Fab_Cycle_Time__c == true) {
                disablePoLeadTime = true;
            } else {
                disablePoLeadTime = false;
            }
                   
            //////////////////// SHIPPING ////////////////////
             if(portaltabaccessObj.Certificate_of_Compliance__c == TRUE)
                    disablecertificate = TRUE;
                else
                    disablecertificate = FALSE;
                    
             if(portaltabaccessObj.On_Time_Delivery__c == TRUE)
                    disabledelivery = TRUE;
                else
                    disabledelivery = FALSE;
                    
              if(portaltabaccessObj.Packaging_List_Report__c == TRUE)
                    disablepkgreport = TRUE;
                else
                    disablepkgreport = FALSE;
                    
             if(portaltabaccessObj.Custom_Shipment_Report__c == TRUE)
                    disablecustomshipreport = TRUE;
                else
                    disablecustomshipreport = FALSE;
                    
             if(portaltabaccessObj.Shipment_Alert_Report__c == TRUE)
                    disableshipalert = TRUE;
                else
                    disableshipalert = FALSE;
                    
             if(portaltabaccessObj.Shipment_Detail_Unsort_and_Sort__c == TRUE)
                    disableshipdetail = TRUE;
                else
                    disableshipdetail = FALSE;
                    
              if(portaltabaccessObj.Ship_Alert_by_Location__c == TRUE)
                    disableshipalertloc = TRUE;
                else
                    disableshipalertloc = FALSE;
/*-----added by sunita on 11th Nov 2016 start---------------------------------------------------------------*/                    
             if(portaltabaccessObj.GFV_Fab9_10_Reports__c== TRUE)
                    disableorder= TRUE;
                else
                    disableorder= FALSE;
                    
             if(portaltabaccessObj.GFV_Fab9_10_Reports__c== TRUE)
                    disableshipment= TRUE;
                else
                    disableshipment= FALSE;
                    
             if(portaltabaccessObj.GFV_Fab9_10_Reports__c== TRUE)
                    disableinvoice= TRUE;
                else
                    disableinvoice= FALSE;
                    
             if(portaltabaccessObj.GFV_Fab9_10_Reports__c== TRUE)
                    disableearlywarning= TRUE;
                else
                    disableearlywarning= FALSE;  
                          
             if(portaltabaccessObj.GFV_Fab9_10_Reports__c== TRUE)
                    disablewipstatus= TRUE;
                else
                    disablewipstatus= FALSE;    
                            
            if(portaltabaccessObj.GFV_Fab9_10_Reports__c== TRUE)
                    disablewiplotgatehistory= TRUE;
                else
                    disablewiplotgatehistory= FALSE;
                    
            if(portaltabaccessObj.GFV_Fab9_10_Reports__c== TRUE)
                    disablenonetlot= TRUE;
                else
                    disablenonetlot= FALSE;     
/*-----added by sunita on 11th Nov 2016 end---------------------------------------------------------------*/                             
        }
        
        }
        Page = '' ;
        OpenPageURL = '' ;
        //Case-4331:Replacing Portal Login ID with Federation ID:Change-002
        //portalLoginUser = userObj.Portal_Login__c;
        if(userInfo.getusertype()=='CustomerSuccess' || userInfo.getusertype()=='PowerCustomerSuccess')
            portalLoginUser = userObj.Federationidentifier ;   
        else 
            portalLoginUser = null; 
        OpenTextLoginServerURL = System.Label.OTLoginServer+portalLoginUser;
        respectivelevel = System.Label.Orders;
        showorderSection = True; 
        showwelcomesection = True;
        showdetailsection = False;
        showpageBlock= False;
	}
    
    /**
        This method is used to redirect the new web page according to the links are specified .
        
        @method name: redirect
        @return : returns the new web site according to the links
         
     */
    //Case-4383:Adding Sorting Parameters in all OpenText report URLs. 
    
    public PageReference redirect()
    {
        if(Page == 'mywafershome')
        {
            respectivesubLevel = 'Overview';
            respectiveLevel = 'Overview';
            showpageBlock= False;
            showwelcomesection = True;
            showdetailsection = False;
            
        }
        if(Page == 'orders')
        {
            OpenPageURL ='';
            respectivelevel = System.Label.Orders;
            respectivesubLevel = System.Label.Orders;
            showorderSection = True;
            showprodSection = False;
            showshippSection = False;  
            showsubpanelLabel = False;
            showpageBlock= False;
            showwelcomesection = True;
            showdetailsection = False;

        }
        if(Page == 'production')
        {
            OpenPageURL ='';
            respectivelevel = System.Label.Production;
            respectivesubLevel = System.Label.Production;
            showorderSection = False;  
            showprodSection = True;
            showshippSection = False;
            showsubpanelLabel = False;
            showpageBlock= False;
            showwelcomesection = True;
            showdetailsection = False;

        }
         if(Page == 'shipping')
        {
            OpenPageURL ='';
            respectivelevel = System.Label.Shipping;
            respectivesubLevel = System.Label.Shipping;
            showorderSection = False;  
            showprodSection = False;
            showshippSection = True;
            showsubpanelLabel = False;
            showpageBlock= False;
            showwelcomesection = True;
            showdetailsection = False;

        }
        if(Page == 'forecastfabcycle')
        {
            showsubpanelLabel = True;
            respectivesubLevel = System.Label.Forecast_Fab_Cycle_Label;
            OpenPageURL =System.Label.Forecast_Fab_Cycle_URL+'&username='+portalLoginUser+System.Label.OpenTextSortParam;
            showpageBlock= True;
            showwelcomesection = False;
            showdetailsection = True;

        }
        if(Page == 'waferst')
        {
            showsubpanelLabel = True;
            respectivesubLevel = System.Label.Wafer_Start_Label;
            OpenPageURL =System.Label.Wafer_Start_URL+'&username='+portalLoginUser+System.Label.OpenTextSortParam;
            showpageBlock= True;
            showwelcomesection = False;
            showdetailsection = True;

        }
        if(Page == 'wipstat')
        {
            showsubpanelLabel = True;
            respectivesubLevel = System.Label.WIP_Status_Label;
            OpenPageURL =System.Label.WIP_Status_Wafer_URL+'&username='+portalLoginUser+System.Label.OpenTextSortParam;
            showpageBlock= True;
            showwelcomesection = False;
            showdetailsection = True;

        }
        if(Page == 'fabout')
        {
            showsubpanelLabel = True;
            respectivesubLevel = System.Label.Fab_Out_Schedule_Label;
            OpenPageURL =System.Label.Fab_Out_Schedule_URL+'&username='+portalLoginUser+System.Label.OpenTextSortParam;
            showpageBlock= True;
            showwelcomesection = False;
            showdetailsection = True;

        }
        if(Page == 'finishreport')
        {
            showsubpanelLabel = True;
            respectivesubLevel = System.Label.Finish_Report_Label;
            OpenPageURL =System.Label.Finish_Report_URL+'&username='+portalLoginUser+System.Label.OpenTextSortParam;
            showpageBlock= True;
            showwelcomesection = False;
            showdetailsection = True;

        }
        if(Page == 'lotcontrol')
        {
            showsubpanelLabel = True;
            respectivesubLevel = System.Label.Lot_Control_Table_Label;
            OpenPageURL =System.Label.Lot_Control_Table_Wafer_URL+'&username='+portalLoginUser+System.Label.OpenTextSortParam;
            showpageBlock= True;
            showwelcomesection = False;
            showdetailsection = True;

        }
        if(Page == 'mfgreport')
        {
            showsubpanelLabel = True;
            respectivesubLevel = System.Label.Mfg_Report_Label;
            OpenPageURL =System.Label.Mfg_Report_URL+'&username='+portalLoginUser+System.Label.OpenTextSortParam;
            showpageBlock= True;
            showwelcomesection = False;
            showdetailsection = True;

        }
        if(Page == 'scrapreport')
        {
            showsubpanelLabel = True;
            respectivesubLevel = System.Label.Scrap_Reports_Label;
            OpenPageURL =System.Label.Scrap_Reports_URL+'&username='+portalLoginUser+System.Label.OpenTextSortParam;
            showpageBlock= True;
            showwelcomesection = False;
            showdetailsection = True;

        }
        if(Page == 'waferscrap')
        {
            showsubpanelLabel = True;
            respectivesubLevel = System.Label.Wafer_Scrap_Label;
            OpenPageURL =System.Label.Wafer_Scrap_URL+'&username='+portalLoginUser+System.Label.OpenTextSortParam;
            showpageBlock= True;
            showwelcomesection = False;
            showdetailsection = True;

        }
        if(Page == 'lothistory')
        {
            showsubpanelLabel = True;
            respectivesubLevel = System.Label.Lot_History_Label;
            OpenPageURL =System.Label.Lot_History_URL+'&username='+portalLoginUser+System.Label.OpenTextSortParam;
            showpageBlock= True;
            showwelcomesection = False;
            showdetailsection = True;

        }
        if(Page == 'fabwip')
        {
            showsubpanelLabel = True;
            respectivesubLevel = System.Label.Fab_WIP_Label;
            OpenPageURL =System.Label.Fab_WIP_URL+'&username='+portalLoginUser+System.Label.OpenTextSortParam;
            showpageBlock= True;
            showwelcomesection = False;
            showdetailsection = True;

        }
        
        if(Page == 'cycletime')
        {
            showsubpanelLabel = True;
            respectivesubLevel = System.Label.Cycle_Time_Label;
            OpenPageURL =System.Label.Cycle_Time_URL+'&username='+portalLoginUser+System.Label.OpenTextSortParam;
            showpageBlock= True;
            showwelcomesection = False;
            showdetailsection = True;

        }
        if(Page == 'engineeringwip')
        {
            showsubpanelLabel = True;
            respectivesubLevel = System.Label.Enginnering_WIP_Label;
            OpenPageURL =System.Label.Enginnering_WIP_URL+'&username='+portalLoginUser+System.Label.OpenTextSortParam;
            showpageBlock= True;
            showwelcomesection = False;
            showdetailsection = True;

        }
        if(Page == 'globalshuttlempwwip')
        {
            showsubpanelLabel = True;
            respectivesubLevel = System.Label.GlobalShuttle_MPWWIP_Label;
            OpenPageURL =System.Label.GlobalShuttle_MPWWIP_URL+'&username='+portalLoginUser+System.Label.OpenTextSortParam;
            showpageBlock= True;
            showwelcomesection = False;
            showdetailsection = True;

        }
        
        if(Page == 'poLeadTime') { 
            showsubpanelLabel = True;
            respectivesubLevel = System.Label.PO_Lead_Time_Label;
            OpenPageURL =System.Label.PO_Lead_Time_URL+'?username='+portalLoginUser+System.Label.OpenTextSortParam;
            showpageBlock= True;
            showwelcomesection = False;
            showdetailsection = True;
        }
        
        if(Page == 'acctstate')
        {
            showsubpanelLabel = True;
            respectivesubLevel = System.Label.Account_Statement_Label;
            OpenPageURL =System.Label.Account_Statement_URL+'&username='+portalLoginUser+System.Label.OpenTextSortParam;
            showpageBlock= True;
            showwelcomesection = False;
            showdetailsection = True;

        }
        if(Page == 'bklog')
        {
            showsubpanelLabel = True;
            respectivesubLevel = System.Label.Back_Log_Label;
            OpenPageURL =System.Label.Back_Log_URL+'&username='+portalLoginUser+System.Label.OpenTextSortParam;
            showpageBlock= True;
            showwelcomesection = False;
            showdetailsection = True;

        }
        if(Page == 'billing')
        {
            showsubpanelLabel = True;
            respectivesubLevel = System.Label.Billing_Label;
            OpenPageURL =System.Label.Billing_URL+'&username='+portalLoginUser+System.Label.OpenTextSortParam;
            showpageBlock= True;
            showwelcomesection = False;
            showdetailsection = True;
        }
        if(Page == 'creditdebitnote')
        {
            showsubpanelLabel = True;
            respectivesubLevel = System.Label.Credit_Debit_Label;
            OpenPageURL =System.Label.Credit_Debit_URL+'&username='+portalLoginUser+System.Label.OpenTextSortParam;
            showpageBlock= True;
            showwelcomesection = False;
            showdetailsection = True;//updated by Sunil Arora for case # 39091 as showpageBlock was written instead of showdetailsection 
        }
        if(Page == 'orderack')
        {
            showsubpanelLabel = True;
            respectivesubLevel = System.Label.Order_Ack_Label;
            OpenPageURL =System.Label.Order_Ack_URL+'&username='+portalLoginUser+System.Label.OpenTextSortParam;
            showpageBlock= True;
            showwelcomesection = False;
            showdetailsection = True;

        }
        if(Page == 'romblanket')
        {
            showsubpanelLabel = True;
            respectivesubLevel = System.Label.ROM_Blanket_Label;
            OpenPageURL =System.Label.ROM_Blanket_URL+'&username='+portalLoginUser+System.Label.OpenTextSortParam;
            showpageBlock= True;
            showwelcomesection = False;
            showdetailsection = True;

        }
        if(Page == 'nreinvoice')
        {
            showsubpanelLabel = True;
            respectivesubLevel = System.Label.NRE_Invoice_Label;
            OpenPageURL =System.Label.NRE_Invoice_URL+'&username='+portalLoginUser+System.Label.OpenTextSortParam;
            showpageBlock= True;
            showwelcomesection = False;
            showdetailsection = True;

        }
        if(Page == 'taxinvoice')
        {
            showsubpanelLabel = True;
            respectivesubLevel = System.Label.Tax_Invoice_Label;
            OpenPageURL =System.Label.Tax_Invoice_URL+'&username='+portalLoginUser+System.Label.OpenTextSortParam;
            showpageBlock= True;
            showwelcomesection = False;
            showdetailsection = True;

        }
        if(Page == 'purchaseorder')
        {
            showsubpanelLabel = True;
            respectivesubLevel = System.Label.Purchase_Order_Label;
            OpenPageURL =System.Label.Purchase_Order_URL+'&username='+portalLoginUser+System.Label.OpenTextSortParam;
            showpageBlock= True;
            showwelcomesection = False;
            showdetailsection = True;

        }
        if(Page == 'orderreport')
        {
            showsubpanelLabel = True;
            respectivesubLevel = System.Label.Order_Report_Label;
            OpenPageURL =System.Label.Order_Report_URL+'&username='+portalLoginUser+System.Label.OpenTextSortParam;
            showpageBlock= True;
            showwelcomesection = False;
            showdetailsection = True;
        }
        
        if(Page == 'compliancecert')
        {
            showsubpanelLabel = True;
            respectivesubLevel = System.Label.Cert_Compliance_Label;
            OpenPageURL =System.Label.Cert_Compliance_URL+'&username='+portalLoginUser+System.Label.OpenTextSortParam;
            showpageBlock= True;
            showwelcomesection = False;
            showdetailsection = True;
        }
        if(Page == 'otd')
        {
            showsubpanelLabel = True;
            respectivesubLevel = System.Label.OTD_Label;
            OpenPageURL =System.Label.OTD_URL+'&username='+portalLoginUser+System.Label.OpenTextSortParam;
            showpageBlock= True;
            showwelcomesection = False;
            showdetailsection = True;
        }
        if(Page == 'packagingrpt')
        {
            showsubpanelLabel = True;
            respectivesubLevel = System.Label.Packaging_Report_Label;
            OpenPageURL =System.Label.Packaging_Report_URL+'&username='+portalLoginUser+System.Label.OpenTextSortParam;
            showpageBlock= True;
            showwelcomesection = False;
            showdetailsection = True;
        }
        if(Page == 'shipmentrpt')
        {
            showsubpanelLabel = True;
            respectivesubLevel = System.Label.Shipment_Report_Label;
            OpenPageURL =System.Label.Shipment_Report_URL+'&username='+portalLoginUser+System.Label.OpenTextSortParam;
            showpageBlock= True;
            showwelcomesection = False;
            showdetailsection = True;
        }
        if(Page == 'shipmentalert')
        {
            showsubpanelLabel = True;
            respectivesubLevel = System.Label.Shipment_Alert_Label;
            OpenPageURL =System.Label.Shipment_Alert_URL+'&username='+portalLoginUser+System.Label.OpenTextSortParam;
            showpageBlock= True;
            showwelcomesection = False;
            showdetailsection = True;
        }
        if(Page == 'shipmentdetail')
        {
            showsubpanelLabel = True;
            respectivesubLevel = System.Label.Shipment_Detail_Label;
            OpenPageURL =System.Label.Shipment_Detail_URL+'&username='+portalLoginUser+System.Label.OpenTextSortParam;
            showpageBlock= True;
            showwelcomesection = False;
            showdetailsection = True;
        }
        if(Page == 'shipalert')
        {
            showsubpanelLabel = True;
            respectivesubLevel = System.Label.Ship_Alert_Label;
            OpenPageURL =System.Label.Ship_Alert_URL+'&username='+portalLoginUser+System.Label.OpenTextSortParam;
            showpageBlock= True;
            showwelcomesection = False;
            showdetailsection = True;
        }
        
        if(Page == 'prodquery')
        {
            respectivelevel = System.Label.Production_Query_Label;
            respectivesubLevel= System.Label.Production_Query_Label;
            //OpenPageURL = System.Label.Production_Query_URL;
            OpenPageURL = 'apex/GF_ProductionQueryPage'; 
            showorderSection = False;  
            showprodSection = False;
            showshippSection = False;
            showsubpanelLabel = False;
            showpageBlock= True;
            showwelcomesection = False;
            showdetailsection = True;
        }
        if(Page == 'orderquery')
        {
            respectivelevel = System.Label.Order_Query_Label;
            //OpenPageURL = System.Label.Order_Query_URL;
            OpenPageURL = 'apex/GF_OrderQueryPage';
            respectivesubLevel = System.Label.Order_Query_Label;
            showorderSection = False;  
            showprodSection = False;
            showshippSection = False;
            showsubpanelLabel = False;
            showpageBlock= True;
            showwelcomesection = False;
            showdetailsection = True;
            showorderqueryLink = True;
        }
        if(Page == 'shippingquery')
        {
            respectivelevel = System.Label.Shipping_Query_Label;
            respectivesubLevel = System.Label.Shipping_Query_Label;
            //OpenPageURL = System.Label.Shipping_Query_URL;
            OpenPageURL = 'apex/GF_ShippingQueryPage';
            showorderSection = False;  
            showprodSection = False;
            showshippSection = False;
            showsubpanelLabel = False;
            showpageBlock= True;
            showwelcomesection = False;
            showdetailsection = True;
            showshippingqueryLink = True;
        }
/*----------------------------added by sunita for ICC-BBB  on Nov-09-2016 start------------------------------------------------------*/
        
        if(Page == 'Order')
        {
            respectivesubLevel = System.Label.Order_Rep;
            OpenPageURL =System.Label.Order_Rep_URL;
            showpageBlock= True;
            showwelcomesection = False;
            showdetailsection = True;
            showsubpanelLabel = False;
        }
        if(Page == 'Shipment')
        {
            respectivesubLevel = System.Label.shipment_Rep;
            OpenPageURL =System.Label.Shipment_Rep_URL;
            showpageBlock= True;
            showwelcomesection = False;
            showdetailsection = True;
            showsubpanelLabel = False;
        }

       /* if(Page == 'Invoice')
        {
            respectivesubLevel = System.Label.invoice_Rep;
            OpenPageURL =System.Label.Invoice_Rep_URL+'&username='+portalLoginUser+System.Label.OpenTextSortParam;
            showpageBlock= True;
            showwelcomesection = False;
            showdetailsection = True;
            showsubpanelLabel = False;
        }*/
        
        if(Page == 'Early Warning')
        {
            respectivesubLevel = System.Label.early_Rep;
            OpenPageURL =System.Label.EarlyWarning_Rep_URL;
            showpageBlock= True;
            showwelcomesection = False;
            showdetailsection = True;
            showsubpanelLabel = False;
        }
        
        if(Page == 'Wip Status')
        {
            respectivesubLevel = System.Label.Wip_Status_Rep;
            OpenPageURL =System.Label.WIP_Status_Rep_URL;
            showpageBlock= True;
            showwelcomesection = False;
            showdetailsection = True;
            showsubpanelLabel = False;
        }
        
        if(Page == 'Wip Lot Gate History')
        {
            respectivesubLevel = System.Label.Wip_Lot_Gate_History_Rep;
            OpenPageURL =System.Label.WIPLotGateHistory_Rep_URL;
            showpageBlock= True;
            showwelcomesection = False;
            showdetailsection = True;
            showsubpanelLabel = False;
        }
        
        if(Page == 'Nonet Lot')
        {
            respectivesubLevel = System.Label.Nonet_Lot_Label;
            OpenPageURL =System.Label.Nonet_Lot_Rep_url;
            showpageBlock= True;
            showwelcomesection = False;
            showdetailsection = True;
            showsubpanelLabel = False;
        }
        
        if(Page == 'Packing List2')
        {
            respectivesubLevel = System.Label.Packing_List;
            OpenPageURL =System.Label.Packing_List_Url+'&username='+portalLoginUser+System.Label.OpenTextSortParam;
            showpageBlock= True;
            showwelcomesection = False;
            showdetailsection = True;
            showsubpanelLabel = False;
        }
        
        if(Page == 'Tax Invoice2')
        {
            respectivesubLevel = System.Label.Tax_Invoice;
            OpenPageURL =System.Label.Tax_Invoice2_Url+'&username='+portalLoginUser+System.Label.OpenTextSortParam;
            showpageBlock= True;
            showwelcomesection = False;
            showdetailsection = True;
            showsubpanelLabel = False;
        }
        
        if(Page == 'Order Ack2')
        {
            respectivesubLevel = System.Label.Order_Acknowledgement;
            OpenPageURL =System.Label.Order_Acknowledgement_Url+'&username='+portalLoginUser+System.Label.OpenTextSortParam;
            showpageBlock= True;
            showwelcomesection = False;
            showdetailsection = True;
            showsubpanelLabel = False;
        }
        if(Page == 'Personal reports')
        {
            respectivesubLevel = System.Label.My_Personal_CustomReports;
            OpenPageURL = 'apex/ICC_My_Personal_CustomReports';
            showpageBlock= True;
            showwelcomesection = False;
            showdetailsection = True;
            showsubpanelLabel = False;
        }
        
        if(Page == 'Order Download')
        {
            respectivesubLevel = System.Label.Order_Status;
            OpenPageURL = System.Label.Order_Status_D_URL;
            showpageBlock= True;
            showwelcomesection = False;
            showdetailsection = True;
            showsubpanelLabel = False;
        }
        
        if(Page == 'Shipment download')
        {
            respectivesubLevel = System.Label.Shipment_download;
            OpenPageURL = System.Label.Shipment_download_url;
            showpageBlock= True;
            showwelcomesection = False;
            showdetailsection = True;
            showsubpanelLabel = False;
        }
        
        /**Added by Amit for Adding Shipment Container Link Case-00080619 on 10/12/2017**/
     	
        if(Page == 'Shipment Container')
        {
        	if(shipmentContainerLabel.Value__c != null)
        		respectivesubLevel = shipmentContainerLabel.Value__c;
            if(shipmentContainerLabelURL.Value__c != null)
            	OpenPageURL = shipmentContainerLabelURL.Value__c;
            showpageBlock= True;
            showwelcomesection = False;
            showdetailsection = True;
            showsubpanelLabel = False;
        }
        /**End Amit***/
        
        if(Page == 'Wip DStatus')
        {
            respectivesubLevel = System.Label.WIP_DReport;
            OpenPageURL = System.Label.WIP_Tracking_Customer_Default_View_URL;
            showpageBlock= True;
            showwelcomesection = False;
            showdetailsection = True;
            showsubpanelLabel = False;
        }
        if(Page == 'WIP_CDV')
        {
            respectivesubLevel = System.Label.WIP_CDV;
            OpenPageURL = System.Label.WIP_CDV_URL;
            showpageBlock= True;
            showwelcomesection = False;
            showdetailsection = True;
            showsubpanelLabel = False;
        }
        if(Page == 'WIP_CDV_Download')
        {
            respectivesubLevel = System.Label.WIP_CDV_Download;
            OpenPageURL = System.Label.WIP_CDV_Download_URL;
            showpageBlock= True;
            showwelcomesection = False;
            showdetailsection = True;
            showsubpanelLabel = False;
        }
        /**Added by Amit for WIP Tracking Report Case-00079786 on 09/28/2017**/
     	
        if(Page == 'WIP_Visibility')
        {
        	if(label.Value__c != null)
        		respectivesubLevel = label.Value__c;
            if(labelURL.Value__c != null)
            	OpenPageURL = labelURL.Value__c;
            showpageBlock= True;
            showwelcomesection = False;
            showdetailsection = True;
            showsubpanelLabel = False;
        }
        /**End Amit***/
        

/*---------------------------added by sunita for ICC-BBB Nov-09-2016 end-------------------------------------------------------------*/ 
        if(Page == 'Fab9/10Subscription')
        {
            respectivelevel = System.Label.Fab_Subscription_Rep;
            respectivesubLevel = System.Label.Fab_Subscription_Rep;
            //OpenPageURL = System.Label.Shipping_Query_URL;
            OpenPageURL = 'apex/ICC_User_Report_Subscriptions';  // changed by Rahul on 10/27/2016
            showorderSection = False;  
            showprodSection = False;
            showshippSection = False;
            showsubpanelLabel = False;
            showpageBlock= True;
            showwelcomesection = False;
            showdetailsection = True;
                       
        }
        
        if(Page == 'PickAllKerfMapPage'){
            
            //respectivelevel = System.Label.Pick_All_Kerf_Map;
            respectivesubLevel = System.Label.Pick_All_Kerf_Map;
            OpenPageURL = 'apex/PickAllKerfMapPage';
            //showorderSection = False;  
            //showprodSection = False;
            //showshippSection = False;
            showsubpanelLabel = False;
            showpageBlock= True;
            showwelcomesection = False;
            showdetailsection = True;
        }
        
        return null;
    }
	
}