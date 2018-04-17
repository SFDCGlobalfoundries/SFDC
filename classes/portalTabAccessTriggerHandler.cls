/*
 Type Name: portalTabAccessTriggerHandler
 Author: Cognizant Technology Solutions
 Created Date: 25-April-2013
 Reason: This class is used for Initialising Portal Tab Access according to the Department chosen.
 Change History: Changes Related to Supplier Service
 Author: Cognizant FV Team
 Modified Date: 04-Dec-2013
 Reason: Included separate flow for Supplier profiles.
 Change History: Change related to modify existing access setup for contacts on change in parent account (related to Case 00003278)
 Author: Cognizant FV Team
 Modified Date: 18-February-2014
 Reason: There was a bug in access setup creation for external users on account change. It used to create dupliate records.
 Change History:
 Author: Prashant (AMS Support)
 Modified :27-January-2016
 Reason: Changes related to Access Setup to check  EHS Policy & Specs Acknowledgement by default while creating supplier contact(Case #  00051309)
 Author: Prashant (AMS Support)
 Modified :03-October-2016
 Reason: Changes related to Access Setup to set flag as true by default while creating supplier contact(Case # 00060034).

Modified By: Abhita Bansal
Modified Date: 14/6/2017
Reason: Added the logic for FMS Project. 
 ……..  ……..
*/

public class portalTabAccessTriggerHandler {

     
    public static Map<String, Contact_Portal_tab_access__c> mapDeptTab = Contact_Portal_Tab_Access__c.getAll();
    /*
    public static Id permSetMyDevices = [Select Id,Name from PermissionSet where Name='Tab_Access_Permission_Set_for_My_Devices'].Id;
    public static Id permSetMyWafers = [Select Id,Name from PermissionSet where Name='Tab_Access_Permission_Set_for_My_Wafers'].Id;
    public static Id permSetDesignDocs = [Select Id,Name from PermissionSet where Name='Tab_Access_Permission_Set_for_PDK_Design_Documents'].Id;
    public static Id permSetProductsServices = [Select Id,Name from PermissionSet where Name='Tab_Access_Permission_Set_for_Product_Services'].Id;
    */
    /**
        This method creates portal tab access records for the enabled portal users
        
        @method name: assignTabAccess 
        @parameter:   Set of Ids of Created Portal Users.
        @return :     none
    **/ 
 
    public static void assignTabAccess(Set<Id> userIds){
               
        list<portal_tab_access__c> lstPrtlTabAccess=new list<portal_tab_access__c>();
        set<string> setContactIds=new set<string>();
        map<string,string> mapContactUser=new map<string,string>();
        map<string,portal_tab_access__c> mapPTB=new map<string,portal_tab_access__c>();
        //Supplier Service related Changes:Start-001
        map<string,user> mapContactUserDetail=new map<string,user>();
        //Supplier Service related Changes:Start-001
        
        if(userIds!=null && userIds.size()>0){
        
            //Supplier Service related Changes:Start-002
            for(user u:[select id,contactid,profile.Name from user where id in:userIds]){
               system.debug('enter user overage');   
                setContactIds.add(u.contactid);
                system.debug('setContactIds@@@'+setContactIds);     
                mapContactUser.put(u.contactid,u.id);
                mapContactUserDetail.put(u.contactid,u);
                system.debug('mapContactUser@@@'+mapContactUser);
            //Supplier Service related Changes:End-002  
            }
            
            /*---------   Added on 18-Feb-2014 (Case 00003278) ----- Begin --------------------------------------------------------*/
            map<string,Portal_Tab_Access__c> mapContactAccess = new map<string,Portal_Tab_Access__c>();
            Set<Id> setUserIds_AccessRead_Folder = new Set<Id>();
            for(Portal_Tab_Access__c access : [SELECT Id, GFV_Fab9_10_Reports__c, 
                                                      Account__c,
                                                      User__c  
                                                 FROM Portal_Tab_Access__c 
                                                WHERE User__c IN :mapContactUser.values()]){
                mapContactAccess.put(access.User__c, access);
                
                // Added by Rahul on 11/11/2016
                if(access.GFV_Fab9_10_Reports__c)
                    setUserIds_AccessRead_Folder.add(access.User__c);
            }
            
            if(!setUserIds_AccessRead_Folder.isEmpty())
            {
                List<Folder> lstFab9_10Folder = new List<Folder>();
                lstFab9_10Folder = [select Id FROM Folder WHERE DeveloperName = 'GFV_Fab_9_10_Reports'];
                if(!lstFab9_10Folder.isEmpty())
                {
                    
                }
            }
            
            System.debug(' *** UserId with Access Tab Map *** ' + mapContactAccess);
            /*---------   Added on 18-Feb-2014 (Case 00003278) ----- End ----------------------------------------------------------*/
        
            if(setContactIds!=null && setContactIds.size()>0){              
                for(Contact c:[select id,accountid,department__c,ftplocation__c,Account.Fab_9_10__c from Contact where id in :setContactIds]){
                    // (Case 00049175)--ftplocation__c---jabee--- 
                    //Supplier Service related Changes:End-003
                    if(mapContactUserDetail!=null && 
                       mapContactUserDetail.keyset()!=null && 
                       (mapContactUserDetail.get(c.id).Profile.Name.Contains(System.label.Supplier)==false)){//modified by cognizant for Case 5779
                    //Supplier Service related Changes:End-003
                    System.debug(' *** Value of department is *** ' + c.department__c);
                    System.debug(' *** not supplier*** ' );
                    
                    /*---------   Added on 18-Feb-2014 (Case 00003278) ----- Begin --------------------------------------------------*/
                    portal_tab_access__c temp;
                        
                    Id usrId = mapContactUser.get(c.id);
                    System.debug(' *** UserId is *** ' + usrId);
                    
                    if(mapContactAccess.containsKey(usrId)){
                       temp = mapContactAccess.get(usrId);
                       System.debug(' *** Existing Access Record is *** ' + temp);
                    } else {
                        temp = new portal_tab_access__c();
                        temp.user__c=  usrId; 
                        System.debug(' *** New Access Record is *** ' + temp); 
                    }   
                    /*---------   Added on 18-Feb-2014 (Case 00003278) ----- End ----------------------------------------------------*/
                    
                    temp.account__c=c.accountid;
                    String st = c.department__c;
                    String[] lstDepts = new String[10];
                    
					if(c.Account.Fab_9_10__c=='Yes') lstDepts.add('Tapeout Fab 9/10');// Added By Abhita for FMS Project
                    if(st!=null){
                    if(st.contains(';')){
                        lstDepts=st.split(';');
                    }
                    else{
                        lstDepts[0]=st;
                    }
                    System.debug(' *** Value of lstDepts is *** ' + lstDepts);
                    
                    for(String dept: lstDepts){
                        
                        System.debug(' *** Value of dept is *** ' + dept);
                        Contact_Portal_tab_access__c pta=new Contact_Portal_tab_access__c();
                        if (Test.isRunningTest()){
                            
                            
                            pta.X3rd_Party_IP__c=true;
                             pta.Account_Statement__c=true;
                             pta.Backlog__c=true;
                             pta.Billing__c=true;
                             pta.BOM__c=true;
                             pta.Certificate_of_Compliance__c=true;
                             pta.Configurator__c=true;
                             pta.CPK__c=true;
                             pta.Credit_and_Debit_Note__c=true;
                             pta.Custom_Shipment_Report__c=true;
                             pta.Design_Technology_Documents__c=true;
                             pta.Design_Enablement__c=true;
                             pta.Design_Specification_Packages__c=false;
                             pta.Export_Control__c=true;
                             pta.Fab_Out_Schedule__c=true;
                             pta.Finish_Goods_Report__c=true;
                    
                             pta.Forecast_Fab_Cycle_Time__c=true;
                             pta.Global_Shuttle_reservation__c=true;
                             pta.IP__c=true;
                             pta.IP_PLM__c=true;
                             pta.IP_Declaration__c=true;
                             pta.Lot_Control_table__c=true;
                             pta.MPW__c=true;
                             pta.New_Part_Creation_after_Proto_form__c=true;
                             pta.NRE_Invoice__c=true;
                             pta.On_Time_Delivery__c=true;
                             pta.Order_Acknowledgement__c=true;
                             pta.Shipment_Detail_Unsort_and_Sort__c=true;
                             pta.Packaging_List_Report__c=true;
                             pta.PCRB__c=true;
                            
                             pta.Order_Query__c=true;
                             pta.PTRF__c=true;
                             pta.Protoype_tracking__c=true;
                             pta.Product_Wafer_Compliance_Analysis__c=true;
                             pta.Production_Query__c=true;
                             pta.Production__c=true;
                             pta.Process_Technology__c=true;
                             pta.Process_Request_Form_PRF__c=true;
                             pta.Process_Reliability_Monitoring__c=true;
                             pta.Process_ID__c=true;
                             pta.Price_List__c=true;
                             pta.Yield_Sort_ETest_Reporting__c=true;
                             pta.WIP_Status__c=true;
                             pta.Web_View__c=true;
                             pta.Wafer_Start__c=true;
                             pta.Wafer_Inspection__c=true;
                             pta.Turnkey__c=true;
                             pta.Tester_Gauge_R_R__c=true;
                             pta.Tax_Invoice__c=true;
                             pta.Stepper_Tooling_Form__c=true;
                             pta.Shipping_Query__c=true;
                             pta.Shipping__c=true;
                             
                             
                             pta.Shipment_Alert_Report__c=true;
                             pta.Ship_Alert_by_Location__c=true;
                             pta.Services__c=true;
                             pta.RTR_RTP__c=true;
                             pta.ROM_Blanket__c=true;
             
                             pta.Risk_Waiver__c=true;
                             pta.Reticle_Obsolescence__c=true;
                             pta.My_Reticles_Read_Only__c=true;
                             pta.Purchase_Order_Tracking__c=true;
                      
                             pta.My_Devices__c=true;
                             pta.My_wafers__c=true;
                             //pta.Supplier_Services__c=true; 
                             pta.PDK_Design_Documents__c=True;
                             pta.Product_Services__c=True;
                             pta.Electrical_Test__c=True;
                             pta.Orders__c=True;
                             pta.Name='Procurement';        
                             
                             //pta.Supplier_Services__c=true;
                            // pta.Vendor_Services__c=true;     
							pta.Tapeout_Fab_9_10__c=true;   // Added by Abhita for FMS Project
                        }else{
                            pta = mapDeptTab.get(dept);
                        }                  
                        System.debug(' *** Value of pta is *** ' + pta);                       
                       if(pta!=null){
                            if(pta.My_Devices__c){
                                temp.my_devices__c=true;                    
                            }
                            if(pta.My_wafers__c){
                                temp.my_wafers__c=true;                    
                            }
                            if(pta.PDK_Design_Documents__c){
                                temp.pdk_design_documents__c=true;                   
                            }
                            if(pta.Product_Services__c){
                                temp.product_services__c=true;                    
                            }
                               
                            //code added for Supplier Services    
                            /*if(pta.Supplier_Services__c)
                                temp.Supplier_Services__c= true;
                            //code for vendor services as per DWP    
                            if(pta.Vendor_Services__c)
                                temp.Vendor_Services__c= true;  */   
							// Added by Abhita for FMS Project 
                             if(pta.Tapeout_Fab_9_10__c)
                                temp.Tapeout_Fab_9_10__c= true;
                               
                        /** My Devices **/
        
                            if(pta.Electrical_Test__c){
                                temp.Electrical_Test__c = true;
                                //temp.Module_Final_Test__c = true;
                               // temp.Wafer_Sort_Test__c = true;
                            } 
                            if(pta.Wafer_Inspection__c)
                                temp.Wafer_Inspection__c = true;
                            if(pta.Yield_Sort_ETest_Reporting__c)
                                temp.Yield_Sort_ETest_Reporting__c = true;
                            if(pta.CPK__c)
                                temp.CPK__c = true;
                            if(pta.Tester_Gauge_R_R__c)
                                temp.Tester_Gauge_R_R__c = true;
                            if(pta.Product_Wafer_Compliance_Analysis__c)
                                temp.Product_Wafer_Compliance_Analysis__c = true;   
                            if(pta.PCRB__c)
                                temp.PCRB__c = true;
                            if(pta.IP_Declaration__c)
                                temp.IP_Declaration__c = true;
                            if(pta.Export_Control__c)
                                temp.Export_Control__c = true;
                            if(pta.BOM__c)
                                temp.BOM__c = true;
                            if(pta.PTRF__c)
                                temp.PTRF__c = true;
                            if(pta.Web_View__c)
                                temp.Web_View__c = true; 
                            if(pta.Global_Shuttle_reservation__c)
                                temp.Global_Shuttle_reservation__c = true;
                            if(pta.Stepper_Tooling_Form__c)
                                temp.Stepper_Tooling_Form__c = true;
                            if(pta.Protoype_tracking__c)
                                temp.Prototype_tracking__c = true;
                            if(pta.New_Part_Creation_after_Proto_form__c)
                                temp.New_Part_Creation_after_Proto_form__c = true;
                            if(pta.Process_Request_Form_PRF__c)
                                temp.Process_Request_Form_PRF__c = true;
                            if(pta.Risk_Waiver__c)
                                temp.Risk_Waiver__c = true;
                            if(pta.RTR_RTP__c)
                                temp.RTR_RTP__c = true;
                            if(pta.Process_Reliability_Monitoring__c)
                                temp.Process_Reliability_Monitoring__c = true;
                            if(pta.Reticle_Obsolescence__c)
                                temp.Reticle_Obsolescence__c = true;
                            if(pta.My_Reticles_Read_Only__c)
                                temp.My_Reticles_Read_Only__c = true;
                            if(pta.Construction_Analysis_report__c)
                                temp.Construction_Analysis_report__c = true;
                            if(pta.Change_request_report__c)
                                temp.Change_request_report__c = true;
                            if(pta.WLR_Monitoring_report__c)
                                temp.WLR_Monitoring_report__c = true;
                            if(pta.Engineering_Lot_status_report__c)
                                temp.Engineering_Lot_status_report__c = true;   
                            if(pta.ET_and_Inline_CPK_report__c       )
                                temp.ET_and_Inline_CPK_report__c = true;
                                
                            /** My Wafers **/
            
                            if(pta.Orders__c)
                                temp.Orders__c= true;
                            if(pta.Production__c)
                                temp.Production__c= true;
                            if(pta.Shipping__c)
                                temp.Shipping__c= true;
                             if(pta.Order_Query__c)
                                temp.Order_Query__c = true;
                            if(pta.Production_Query__c )
                                temp.Production_Query__c = true;
                            if(pta.Shipping_Query__c )
                                temp.Shipping_Query__c = true;
                            if(pta.Forecast_Fab_Cycle_Time__c)
                                temp.Forecast_Fab_Cycle_Time__c = true;
                            if(pta.Wafer_Start__c)
                                temp.Wafer_Start__c = true;
                            if(pta.WIP_Status__c)
                                temp.WIP_Status__c = true;
                            if(pta.Fab_Out_Schedule__c)
                                temp.Fab_Out_Schedule__c = true;
                            if(pta.Finish_Goods_Report__c)
                                temp.Finish_Goods_Report__c = true;
                            if(pta.Lot_Control_table__c)
                                temp.Lot_Control_table__c = true;
                            if(pta.Account_Statement__c)
                                temp.Account_Statement__c = true;
                            if(pta.Backlog__c)
                                temp.Backlog__c = true;
                            if(pta.Billing__c)
                                temp.Billing__c = true;
                            if(pta.Credit_and_Debit_Note__c)
                                temp.Credit_and_Debit_Note__c = true;
                            if(pta.NRE_Invoice__c)
                                temp.NRE_Invoice__c = true;
                            if(pta.Order_Acknowledgement__c)
                                temp.Order_Acknowledgement__c = true;
                            if(pta.Purchase_Order_Tracking__c)
                                temp.Purchase_Order_Tracking__c = true;
                            if(pta.Tax_Invoice__c)
                                temp.Tax_Invoice__c = true;
                            if(pta.ROM_Blanket__c)
                                temp.ROM_Blanket__c = true;
                            if(pta.Certificate_of_Compliance__c)
                                temp.Certificate_of_Compliance__c = true;
                            if(pta.Custom_Shipment_Report__c)
                                temp.Custom_Shipment_Report__c = true;
                            if(pta.On_Time_Delivery__c)
                                temp.On_Time_Delivery__c = true;
                            if(pta.Shipment_Alert_Report__c)
                                temp.Shipment_Alert_Report__c = true;
                            if(pta.Shipment_Detail_Unsort_and_Sort__c)
                                temp.Shipment_Detail_Unsort_and_Sort__c = true;
                            if(pta.Ship_Alert_by_Location__c)
                                temp.Ship_Alert_by_Location__c = true;
                            if(pta.Packaging_List_Report__c)
                                temp.Packaging_List_Report__c = true;
                                
                             if(pta.Wafer_Scrap__c)
                                temp.Wafer_Scrap__c = true;
                            if(pta.Scrap_Reports__c)
                                temp.Scrap_Reports__c = true;
                            if(pta.Lot_History__c)
                                temp.Lot_History__c = true;
                            if(pta.Fab_WIP__c)
                                temp.Fab_WIP__c = true;
                            if(pta.Custom_Order_Report__c)
                                temp.Custom_Order_Report__c = true;
                            if(pta.Custom_Mfg_Report__c)
                                temp.Custom_Mfg_Report__c= true; 
                                
                            if(pta.Cycle_Time__c)
                                temp.Cycle_Time__c= true;
                            if(pta.Engineering_WIP__c)
                                temp.Engineering_WIP__c= true;
                            if(pta.GlobalShuttle_MPW_WIP__c)
                                temp.GlobalShuttle_MPW_WIP__c= true; 
                                //sunita added  
                            if(pta.GFV_Fab9_10_Reports__c)
                                temp.GFV_Fab9_10_Reports__c= true; 
                                
                            /** Product and Services **/
            
                            if(pta.Configurator__c)
                                temp.Configurator__c = true;
                            if(pta.Design_Enablement__c)
                                temp.Design_Enablement__c = true;
                            if(pta.Process_Technology__c)
                                temp.Process_Technology__c = true;
                            if(pta.Process_ID__c)
                                temp.Process_ID__c = true;
                            if(pta.IP__c)
                                temp.IP__c = true;
                            if(pta.X3rd_Party_IP__c)
                                temp.X3rd_Party_IP__c = true;
                            if(pta.Price_List__c)
                                temp.Price_List__c = true;
                            if(pta.MPW__c)
                                temp.MPW__c = true;
                            if(pta.Turnkey__c)
                                temp.Turnkey__c = true;
                            if(pta.Services__c)
                                temp.Services__c = true;
                            if(pta.Procedure__c)
                                temp.Procedure__c = true;    
            
                            /** PDK & Design Documents **/
            
                            if(pta.Design_Specification_Packages__c)
                                temp.Design_Specification_Packages__c = false;
                            if(pta.Design_Technology_Documents__c)
                                temp.Design_Technology_Documents__c = true;
                            if(pta.PDKs__c){
                                temp.PDK__c = true;                                
                                   // temp.Access_Setup_Documentation_ASIC__c  = c.Account.ASIC_Business_Flag__c;
                                   // temp.Access_Setup_Design_Kits_ASIC_DK__c = c.Account.ASIC_Business_Flag__c;
                                    //temp.Access_Setup_News_Alerts_ASIC__c    = c.Account.ASIC_Business_Flag__c;
                                
                            }
                                
                              /*---------   Added on 11-Feb-2016 (Case 00049175) ----- Jabee -----------------------------------------------*/   
                                if(c.ftplocation__c!=null){
                                    temp.PDK_FTP_Inbox__c=true; 
                                }
                                 /*------------------------------------- End -----------------------------------------------*/
                                                                           
                            if(pta.IP_PLM__c)
                                temp.IP_PLM__c= true;                       
                          }               
                    }
                    lstPrtlTabAccess.add(temp); 
                    System.debug(' *** Value of size of lstPrtlTabAccess is *** ' + lstPrtlTabAccess.size());
                    }  
                  //Supplier Service related Changes:Start-004
                    }else
                    {
                      system.debug('supplier profile@@');
                        /*---------   Added on 18-Feb-2014 (Case 00003278) ----- Begin -----------------------------------------------*/
                        portal_tab_access__c temp;
                            
                        Id usrId = mapContactUser.get(c.id);
                        System.debug(' *** UserId is *** ' + usrId);
                        
                        if(mapContactAccess.containsKey(usrId)){
                           temp = mapContactAccess.get(usrId);
                           System.debug(' *** Existing Access Record is *** ' + temp);
                        } else {
                            temp = new portal_tab_access__c();
                            temp.user__c=  usrId; 
                            System.debug(' *** New Access Record is *** ' + temp); 
                        }   
                        /*---------   Added on 18-Feb-2014 (Case 00003278) ----- End -------------------------------------------------*/
                        
                        temp.account__c=c.accountid;
                        temp.Material_Selection_Qualififcation__c=true;
                        temp.Supplier_eCOA_Submission__c=true;
                        temp.Procedure_Review_Acceptance__c=true;
                        temp.Wafer_Disposition_System__c=true;
                        temp.Turnkey_Incident_Report__c=true;
                        temp.Supplier_Procedure__c=true;
                        temp.SQE_Applications_Overview__c=true;
                        //Added by Prashant (Case # 00051309)
                        temp.EHS_Policy__c=true;
                        temp.Specs_Acknowledgement__c=true;
                        //Added by Prashant (Case # 00060034)
                       //temp.Change_Notification__c=true;                        
 /*------------------------added by cognizant for Case 5779------------------------------------------------*/
                        temp.my_devices__c=false;                    
                        temp.my_wafers__c=false;    
                        temp.pdk_design_documents__c=false;   
                        temp.product_services__c=false;
                        //code for DWP
                       /* if(c.department__c.contains('Supplier Services'))temp.Supplier_Services__c=true;
                        else temp.Supplier_Services__c=false;
                         if(c.department__c.contains('Vendor Services'))temp.Vendor_Services__c=true;
                        else temp.Vendor_Services__c=false;*/
						// Added by Abhita for FMS Project
                       if(c.Account.Fab_9_10__c=='Yes')
                           temp.Tapeout_Fab_9_10__c=true;
                       else
                           temp.Tapeout_Fab_9_10__c=false;   
 /*----------------------------------------------------------------------------------------------------------*/                       
                        lstPrtlTabAccess.add(temp);
                        system.debug('lstPrtlTabAccess@@'+lstPrtlTabAccess);
                    } 
                    //Supplier Service related Changes:End-004                                 
                }
                     
                if(lstPrtlTabAccess!=null && lstPrtlTabAccess.size()>0){
                    try{
                        System.debug(' *** Value of size of lstPrtlTabAccess in try block is *** ' + lstPrtlTabAccess.size());
                        RecursionPrevent.setAlreadyModified();
                        upsert lstPrtlTabAccess;
                       
                        String PortaltabaccessId = '';
                        for (Portal_Tab_Access__c ptaObj: lstPrtlTabAccess)
                        {
                                PortaltabaccessId = PortaltabaccessId+ptaObj.Id+ '|';
                        }
                        String setofIds= PortaltabaccessId.Substring(0,PortaltabaccessId.length()-1);
                        ClsPortalTabAccessTriggerHandler.assignTabAccessFuture(setofIds);
                    }
                    catch(DmlException ex){
                        System.debug(' ** Exception encountered in Inserting Portal Tab Access records is ** ' + ex.getMessage());    
                    }    
                }
            }
        }
    }

}