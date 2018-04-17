/*
Type Name: ClsContactTriggerHandler
Author: Cognizant 
Created Date: 25-April-2013
Reason: This class is used for creating two records in Contact External Application object - one for FTP and
        another for FV access - whenever a Contact is enabled as a portal User
Change History:
Author: 
Modified Date: 5/22/2013
Reason: Query and code optimization
Modified Date: 8/04/2015
Reason: Design_Specification_Packages__c=false so that it is not visible on GFV

Modified By: Abhita Bansal
Modified Date: 14/6/2017
Reason: Added the logic for FMS Project.
……..
……..
*/
public class ClsContactTriggerHandler{
    
    
    /** Modified By Cognizant on 25042013 Start
     **/
    private Boolean isExecuting = false;
    private Integer size = 0; 
    public static String recordIdFV {get;set;}
    public static String recordIdFTP {get;set;}
    public static List<Contact_External_Application__c> lstCEA {get;set;}
    public static List<User> lstUser {get;set;}
    public static List<Account_Short_Name__c> lstASN {get;set;}
    
     //Variable to stop the CreateSharingOnAccount Trigger to perform the functionality once 
    //Modified on 5/22/2013
    public static Boolean blnContactShareRun =false;       
    
    /**
        
    **/
    
    public static void createSharingOnAccount(Set<Id> contactIdList){
        
        Id parentAcctnObj;
        Id parentParentAcctnObj;
        Id parentParentParentAcctnObj;
        Id childAcctnObj;
        Id childChildAcctnObj;
        Id childChildChildAcctnObj;
        Id portalUserId;
        Set<Id> setParentAccountIds = new Set<Id>();
        Set<Id> setChildAccountIds = new Set<Id>();
        Set<Id> setChildContactIds = new Set<Id>();
        List<AccountShare> AccShareList = new List<AccountShare>();
               
        if(contactIdList!=null && contactIdList.size()>0){
        
            Contact objContact = new Contact();
            objContact = [Select Id, accountId from Contact where Id IN:contactIdList]; 
        
            if(objContact!=null){
                portalUserId = [Select Id from User where IsActive=true and contactId  = : objContact.Id].Id;
                
                for(Account acc: [Select Id, ParentId from Account where Id=:objContact.accountId]){
                    parentAcctnObj = acc.Id;
                    setParentAccountIds.add(parentAcctnObj );
                    if(acc.ParentId!=null){
                        parentParentAcctnObj = acc.ParentId;
                        setParentAccountIds.add(parentParentAcctnObj  );
                    }
                }
                
                if(parentParentAcctnObj!=null){
                    for(Account acc: [Select Id, ParentId from Account where Id=:parentParentAcctnObj]){
                        
                        if(acc.ParentId!=null){
                            parentParentParentAcctnObj= acc.ParentId;
                            setParentAccountIds.add(parentParentParentAcctnObj);
                        }
                    }        
                }
                
                if(setParentAccountIds!=null && setParentAccountIds.size()>0){
                    for(Account acc: [Select Id, ParentId from Account where ParentId=:parentAcctnObj]){
                        setChildAccountIds.add(acc.Id);
                    }
                }
                
                /*for(Contact contact: [Select Id from Contact where accountId IN : setChildAccountIds OR accountId IN : setParentAccountIds]){
                    setChildContactIds.add(contact.Id);
                }*/
                
            } 
            
            
            AccountShare accShareOne = new AccountShare();
            accShareOne.UserOrgroupId = portalUserId;
            accShareOne.AccountId = parentAcctnObj;
            accShareOne.AccountAccessLevel = System.Label.PortalAccountAccessLevel;
            accShareOne.OpportunityAccessLevel = System.Label.PortalOpportunityAccessLevel;
            accShareOne.CaseAccessLevel = System.Label.PortalCaseAccessLevel; 
            
            AccountShare accShareTwo = new AccountShare();
            accShareTwo.UserOrgroupId = portalUserId;
            accShareTwo.AccountId = parentParentAcctnObj;
            accShareTwo.AccountAccessLevel = System.Label.PortalAccountAccessLevel;
            accShareTwo.OpportunityAccessLevel = System.Label.PortalOpportunityAccessLevel;
            accShareTwo.CaseAccessLevel = System.Label.PortalCaseAccessLevel; 
            
            AccountShare accShareThree = new AccountShare();
            accShareThree.UserOrgroupId = portalUserId;
            accShareThree.AccountId = parentParentParentAcctnObj;
            accShareThree.AccountAccessLevel = System.Label.PortalAccountAccessLevel;
            accShareThree.OpportunityAccessLevel = System.Label.PortalOpportunityAccessLevel;
            accShareThree.CaseAccessLevel = System.Label.PortalCaseAccessLevel;              
            
            AccShareList.add(accShareOne);
            AccShareList.add(accShareTwo); 
            AccShareList.add(accShareThree); 
            
            try{
                insert AccShareList;
            }
            catch(DmlException x){
            }                                        
        }     
        
            
    }
    
    /**
        This method updates the Portal Tab Access record corresponding to a Portal User record when the Department of the Contact is changed . 
        
        @method name: updatePortalTabAccess 
        @parameters:  Set of Ids of Contacts to be updated, Map of Contact Ids to Contact Departments.
        @return :     none
    **/
    
    public static void updatePortalTabAccess(Set<Id> contactIds,Map<Id,String> contactDepts){
        
        System.debug(' *** Inside updatePortalTabAccess method start *** ');
        Map<String, Contact_Portal_tab_access__c> mapDeptTab = Contact_Portal_Tab_Access__c.getAll();
        List<Id> portalUserId=new List<Id>();
        List<Portal_Tab_Access__c> portalTabAccessToUpdate=new List<Portal_Tab_Access__c>();
        Map<Id, String> userToDept = new Map<Id, String>();
        Map<Id, User> usersMap = new Map<Id, User>();        
        
        if(contactIds!=null && contactIds.size()>0){
            for(User portalUser:[Select Id, Name, contactId,Contact.Account.ASIC_Business_Flag__c from User where IsActive=true and contactId IN: contactIds]){
                portalUserId.add(portalUser.Id);
                userToDept.put(portalUser.Id, contactDepts.get(portalUser.contactId));
                usersMap.put(portalUser.Id,portalUser);                      
            }
            if(portalUserId!=null && portalUserId.size()>0){
                List<Portal_Tab_Access__c > lstPTA = [Select Id,Name,User__c,User__r.Contact.Account.ASIC_Business_Flag__c,My_Devices__c,My_Wafers__c ,PDK_Design_Documents__c,Product_Services__c,Supplier_Services__c,Vendor_Services__c, Tapeout_Fab_9_10__c
                                              FROM Portal_Tab_Access__c WHERE User__c IN:portalUserId]; // Added By Abhita for FMS Project
                if(lstPTA!=null && lstPTA.size()>0){                              
                for(Portal_Tab_Access__c objPTA:lstPTA ){
                    Boolean isMyDevices = false;
                    Boolean isMyWafers = false;
                    Boolean isPDK = false;
                    Boolean isProducts = false;
                    Boolean isSupplierServices= false;
                    Boolean isVendorServices= false;
                    Boolean isFab9_10_Access=false;// Added By Abhita for FMS Project
                    String[] lstDepts = new String[10];
                    objPTA = clearAllFlags(objPTA);
                    
                    String dept = userToDept.get(objPTA.User__c);
                    System.debug(' *** Value of dept is: *** ' + dept);
                    
                    if(dept!=null){
                        if(dept.contains(';')){
                            lstDepts=dept.split(';');
                        }
                        else{
                            lstDepts[0]=dept;
                        }
                        System.debug(' *** Value of lstDepts is: *** ' + lstDepts);                             
                        
                        for(String st: lstDepts){
                        
                            System.debug(' *** Value of st is: *** ' + st);   
                            Contact_Portal_tab_access__c pta = mapDeptTab.get(st);
                            System.debug(' *** Value of pta is: *** ' + pta);
                                                       
                            if(pta !=null){
                                if(pta.My_Devices__c){
                                    objPTA.My_Devices__c = true;
                                    isMyDevices = true;
                                }
                                else if(!isMyDevices)
                                    objPTA.My_Devices__c = false;
                                if(pta.My_Wafers__c){
                                    objPTA.My_Wafers__c = true;
                                    isMyWafers = true;
                                }
                                else if(!isMyWafers)
                                    objPTA.My_Wafers__c = false;
                                if(pta.PDK_Design_Documents__c){
                                    objPTA.PDK_Design_Documents__c = true;
                                    isPDK = true;
                                }
                                else if(!isPDK)
                                    objPTA.PDK_Design_Documents__c = false;
                                if(pta.Product_Services__c){
                                    objPTA.Product_Services__c = true;
                                    isProducts = true;
                                }
                                else if(!isProducts)
                                    objPTA.Product_Services__c = false;
                                    
                                //code for Supplier Service tab checkbox 
                                if(pta.Supplier_Services__c)
                                {
                                    objPTA.Supplier_Services__c = true;
                                    isSupplierServices = true;
                                }
                                else if(!isSupplierServices)
                                    objPTA.Supplier_Services__c = false;
                                    
                                //code for Vendor Service tab checkbox    
                                if(pta.Vendor_Services__c)
                                {
                                    objPTA.Vendor_Services__c = true;
                                    isVendorServices = true;
                                }
                                else if(!isVendorServices)
                                    objPTA.Vendor_Services__c = false;     
                                    
                                // Added By Abhita for FMS Project
                                if(pta.Tapeout_Fab_9_10__c){
                                    objPTA.Tapeout_Fab_9_10__c= true;
                                    isFab9_10_Access= true;
                                }
                                else if(!isFab9_10_Access)
                                    objPTA.Tapeout_Fab_9_10__c= false;   
                                    
                                /** My Devices **/
        
                                if(pta.Electrical_Test__c){
                                    objPTA.Electrical_Test__c = true;
                                    objPTA.Module_Final_Test__c = true;
                                    objPTA.Wafer_Sort_Test__c = true;
                                }  
                                if(pta.Wafer_Inspection__c)
                                    objPTA.Wafer_Inspection__c = true;
                                if(pta.Yield_Sort_ETest_Reporting__c)
                                    objPTA.Yield_Sort_ETest_Reporting__c = true;
                                if(pta.CPK__c)
                                    objPTA.CPK__c = true;
                                if(pta.Tester_Gauge_R_R__c)
                                    objPTA.Tester_Gauge_R_R__c = true;
                                if(pta.Product_Wafer_Compliance_Analysis__c)
                                    objPTA.Product_Wafer_Compliance_Analysis__c = true;   
                                if(pta.PCRB__c)
                                    objPTA.PCRB__c = true;
                                if(pta.IP_Declaration__c)
                                    objPTA.IP_Declaration__c = true;
                                if(pta.Export_Control__c)
                                    objPTA.Export_Control__c = true;
                                if(pta.BOM__c)
                                    objPTA.BOM__c = true;
                                if(pta.PTRF__c)
                                    objPTA.PTRF__c = true;
                                if(pta.Web_View__c)
                                    objPTA.Web_View__c = true; 
                                if(pta.Global_Shuttle_reservation__c)
                                    objPTA.Global_Shuttle_reservation__c = true;
                                if(pta.Stepper_Tooling_Form__c)
                                    objPTA.Stepper_Tooling_Form__c = true;
                                if(pta.Protoype_tracking__c)
                                    objPTA.Prototype_tracking__c = true;
                                if(pta.New_Part_Creation_after_Proto_form__c)
                                    objPTA.New_Part_Creation_after_Proto_form__c = true;
                                if(pta.Process_Request_Form_PRF__c)
                                    objPTA.Process_Request_Form_PRF__c = true;
                                if(pta.Risk_Waiver__c)
                                    objPTA.Risk_Waiver__c = true;
                                if(pta.RTR_RTP__c)
                                    objPTA.RTR_RTP__c = true;
                                if(pta.Process_Reliability_Monitoring__c)
                                    objPTA.Process_Reliability_Monitoring__c = true;
                                if(pta.Reticle_Obsolescence__c)
                                    objPTA.Reticle_Obsolescence__c = true;
                                if(pta.My_Reticles_Read_Only__c)
                                    objPTA.My_Reticles_Read_Only__c= true;                                   
                                if(pta.Construction_Analysis_report__c)
                                    objPTA.Construction_Analysis_report__c= true;
                                if(pta.Change_request_report__c)
                                    objPTA.Change_request_report__c= true;
                                if(pta.WLR_Monitoring_report__c)
                                    objPTA.WLR_Monitoring_report__c= true;
                                if(pta.Engineering_Lot_status_report__c)
                                    objPTA.Engineering_Lot_status_report__c= true;
                                if(pta.ET_and_Inline_CPK_report__c)
                                    objPTA.ET_and_Inline_CPK_report__c = true;    
                                /** My Wafers **/
                                
                                 if(pta.Orders__c)
                                    objPTA.Orders__c= true;
                                if(pta.Production__c)
                                    objPTA.Production__c= true;
                                if(pta.Shipping__c)
                                    objPTA.Shipping__c= true;
                                if(pta.Order_Query__c)
                                    objPTA.Order_Query__c = true;
                                if(pta.Production_Query__c )
                                    objPTA.Production_Query__c = true;
                                if(pta.Shipping_Query__c )
                                    objPTA.Shipping_Query__c = true;
                                if(pta.Forecast_Fab_Cycle_Time__c)
                                    objPTA.Forecast_Fab_Cycle_Time__c = true;
                                if(pta.Wafer_Start__c)
                                    objPTA.Wafer_Start__c = true;
                                if(pta.WIP_Status__c)
                                    objPTA.WIP_Status__c = true;
                                if(pta.Fab_Out_Schedule__c)
                                    objPTA.Fab_Out_Schedule__c = true;
                                if(pta.Finish_Goods_Report__c)
                                    objPTA.Finish_Goods_Report__c = true;
                                if(pta.Lot_Control_table__c)
                                    objPTA.Lot_Control_table__c = true;
                                if(pta.Account_Statement__c)
                                    objPTA.Account_Statement__c = true;
                                if(pta.Backlog__c)
                                    objPTA.Backlog__c = true;
                                if(pta.Billing__c)
                                    objPTA.Billing__c = true;
                                if(pta.Credit_and_Debit_Note__c)
                                    objPTA.Credit_and_Debit_Note__c = true;
                                if(pta.NRE_Invoice__c)
                                    objPTA.NRE_Invoice__c = true;
                                if(pta.Order_Acknowledgement__c)
                                    objPTA.Order_Acknowledgement__c = true;
                                if(pta.Purchase_Order_Tracking__c)
                                    objPTA.Purchase_Order_Tracking__c = true;
                                if(pta.Tax_Invoice__c)
                                    objPTA.Tax_Invoice__c = true;
                                if(pta.ROM_Blanket__c)
                                    objPTA.ROM_Blanket__c = true;
                                if(pta.Certificate_of_Compliance__c)
                                    objPTA.Certificate_of_Compliance__c = true;
                                if(pta.Custom_Shipment_Report__c)
                                    objPTA.Custom_Shipment_Report__c = true;
                                if(pta.On_Time_Delivery__c)
                                    objPTA.On_Time_Delivery__c = true;
                                if(pta.Shipment_Alert_Report__c)
                                    objPTA.Shipment_Alert_Report__c = true;
                                if(pta.Shipment_Detail_Unsort_and_Sort__c)
                                    objPTA.Shipment_Detail_Unsort_and_Sort__c = true;
                                if(pta.Ship_Alert_by_Location__c)
                                    objPTA.Ship_Alert_by_Location__c = true;
                                if(pta.Packaging_List_Report__c)
                                    objPTA.Packaging_List_Report__c = true;
                                    
                                 if(pta.Wafer_Scrap__c)
                                    objPTA.Wafer_Scrap__c = true;
                                if(pta.Scrap_Reports__c)
                                    objPTA.Scrap_Reports__c = true;
                                if(pta.Lot_History__c)
                                    objPTA.Lot_History__c = true;
                                if(pta.Fab_WIP__c)
                                    objPTA.Fab_WIP__c = true;
                                if(pta.Custom_Order_Report__c)
                                    objPTA.Custom_Order_Report__c = true;
                                if(pta.Custom_Mfg_Report__c)
                                    objPTA.Custom_Mfg_Report__c= true; 
                                    
                                if(pta.Cycle_Time__c)
                                    objPTA.Cycle_Time__c = true; 
                                if(pta.Engineering_WIP__c)
                                    objPTA.Engineering_WIP__c= true; 
                                if(pta.GlobalShuttle_MPW_WIP__c)
                                    objPTA.GlobalShuttle_MPW_WIP__c= true;    
                
                                /** Product and Services **/
                
                                if(pta.Configurator__c)
                                    objPTA.Configurator__c = true;
                                if(pta.Design_Enablement__c)
                                    objPTA.Design_Enablement__c = true;
                                if(pta.Process_Technology__c)
                                    objPTA.Process_Technology__c = true;
                                if(pta.Process_ID__c)
                                    objPTA.Process_ID__c = true;
                                if(pta.IP__c)
                                    objPTA.IP__c = true;
                                if(pta.X3rd_Party_IP__c)
                                    objPTA.X3rd_Party_IP__c = true;
                                if(pta.Price_List__c)
                                    objPTA.Price_List__c = true;
                                if(pta.MPW__c)
                                    objPTA.MPW__c = true;
                                if(pta.Turnkey__c)
                                    objPTA.Turnkey__c = true;
                                if(pta.Services__c)
                                    objPTA.Services__c = true;
                                if(pta.Procedure__c)
                                    objPTA.Procedure__c= true;
                                    
                                /** PDK & Design Documents **/
                
                                if(pta.Design_Specification_Packages__c)
                                    objPTA.Design_Specification_Packages__c = false;
                                if(pta.Design_Technology_Documents__c)
                                    objPTA.Design_Technology_Documents__c = true;
                                if(pta.PDKs__c)
                                    objPTA.PDK__c = true;                       
                                if(pta.IP_PLM__c)
                                    objPTA.IP_PLM__c= true;          
                                if(usersMap.get(objPTA.User__c).Contact.Account.ASIC_Business_Flag__c){
                                    objPTA.Access_Setup_Documentation_ASIC__c  = true;
                                    objPTA.Access_Setup_Design_Kits_ASIC_DK__c = true;
                                    objPTA.Access_Setup_News_Alerts_ASIC__c    = true;
                                }
                                    
                            } 
                        }
                        portalTabAccessToUpdate.add(objPTA);
                    }
                    else{
                        objPTA.My_Devices__c = false;
                        objPTA.My_Wafers__c = false;
                        objPTA.PDK_Design_Documents__c = false;
                        objPTA.Product_Services__c = false; 
                        objPTA.Supplier_Services__c=false;
                        objPTA.Vendor_Services__c=false;
                        objPTA.Tapeout_Fab_9_10__c= false;// Added By Abhita for FMS Project
                        portalTabAccessToUpdate.add(objPTA);
                    }
                                                                        
                }
                }
        /*
                else{
                
                    Set<Id> setPortalUserId = new Set<Id>();
                    setPortalUserId.addAll(portalUserId);
                    System.debug(' *** Set of Portal User Ids is ***' + setPortalUserId);
                    
                    if (System.isBatch() || System.isFuture()){
                        clsUserTriggerHandler.insertPermissionSets(setPortalUserId);
                    }else{
                        insertPermissionSetsFuture(setPortalUserId);
                    }                   
                    if (System.isBatch() || System.isFuture()){
                        portalTabAccessTriggerHandler.assignTabAccess(setPortalUserId);
                    }else{
                        ClsUserTriggerHandler.insertPTAFuture(setPortalUserId);
                    }
                }
        */
                if(portalTabAccessToUpdate!=null && portalTabAccessToUpdate.size()>0){
                    try{
            RecursionPrevent.setAlreadyModified();  
                        update portalTabAccessToUpdate;
            String PortaltabaccessId = '';
                        for (Portal_Tab_Access__c ptaObj: portalTabAccessToUpdate)
                        {
                                PortaltabaccessId = PortaltabaccessId+ptaObj.Id+ '|';
                        }
                        String setofIds= PortaltabaccessId.Substring(0,PortaltabaccessId.length()-1);
                        ClsPortalTabAccessTriggerHandler.assignTabAccessFuture(setofIds);
                    }
                    catch(DmlException ex){
                        System.debug(' ** Exception during Portal Tab Access Update is ** ' + ex.getMessage());
                    }
               }
            }
        }
                
    } 
    
    private static Portal_Tab_Access__c clearAllFlags(Portal_Tab_Access__c objPTA){
    
            objPTA.Tapeout_Fab_9_10__c= false;    // Added By Abhita for FMS Project
            /** My Devices **/    
            objPTA.Module_Final_Test__c = false;
            objPTA.Wafer_Sort_Test__c = false;                                    
            objPTA.Electrical_Test__c = false;       
            objPTA.Wafer_Inspection__c = false;        
            objPTA.Yield_Sort_ETest_Reporting__c = false;       
            objPTA.CPK__c = false;       
            objPTA.Tester_Gauge_R_R__c = false;       
            objPTA.Product_Wafer_Compliance_Analysis__c = false;          
            objPTA.PCRB__c = false;        
            objPTA.IP_Declaration__c = false;       
            objPTA.Export_Control__c = false;        
            objPTA.BOM__c = false;        
            objPTA.PTRF__c = false;        
            objPTA.Web_View__c = false;         
            objPTA.Global_Shuttle_reservation__c = false;       
            objPTA.Stepper_Tooling_Form__c = false;       
            objPTA.Prototype_tracking__c = false;       
            objPTA.New_Part_Creation_after_Proto_form__c = false;       
            objPTA.Process_Request_Form_PRF__c = false;        
            objPTA.Risk_Waiver__c = false;       
            objPTA.RTR_RTP__c = false;       
            objPTA.Process_Reliability_Monitoring__c = false;        
            objPTA.Reticle_Obsolescence__c = false;
            objPTA.My_Reticles_Read_Only__c = false;
            objPTA.Construction_Analysis_report__c = false;
            objPTA.Change_request_report__c = false;
            objPTA.WLR_Monitoring_report__c = false;
            objPTA.Engineering_Lot_status_report__c = false;
            objPTA.ET_and_Inline_CPK_report__c = false;
            
            /** My Wafers **/
            objPTA.Orders__c= false;        
            objPTA.Production__c= false;       
            objPTA.Shipping__c= false;          
            objPTA.Order_Query__c = false;        
            objPTA.Production_Query__c = false;       
            objPTA.Shipping_Query__c = false;        
            objPTA.Forecast_Fab_Cycle_Time__c = false;        
            objPTA.Wafer_Start__c = false;        
            objPTA.WIP_Status__c = false;       
            objPTA.Fab_Out_Schedule__c = false;       
            objPTA.Finish_Goods_Report__c = false;       
            objPTA.Lot_Control_table__c = false;       
            objPTA.Account_Statement__c = false;       
            objPTA.Backlog__c = false;       
            objPTA.Billing__c = false;        
            objPTA.Credit_and_Debit_Note__c = false;        
            objPTA.NRE_Invoice__c = false;        
            objPTA.Order_Acknowledgement__c = false;       
            objPTA.Purchase_Order_Tracking__c = false;       
            objPTA.Tax_Invoice__c = false;       
            objPTA.ROM_Blanket__c = false;        
            objPTA.Certificate_of_Compliance__c = false;       
            objPTA.Custom_Shipment_Report__c = false;       
            objPTA.On_Time_Delivery__c = false;        
            objPTA.Shipment_Alert_Report__c = false;        
            objPTA.Shipment_Detail_Unsort_and_Sort__c = false;       
            objPTA.Ship_Alert_by_Location__c = false;       
            objPTA.Packaging_List_Report__c = false;
            
            objPTA.Wafer_Scrap__c= false;
            objPTA.Scrap_Reports__c= false;
            objPTA.Lot_History__c= false;
            objPTA.Fab_WIP__c= false;
            objPTA.Custom_Order_Report__c= false;
            objPTA.Custom_Mfg_Report__c= false;
            
            objPTA.Cycle_Time__c= false;
            objPTA.Engineering_WIP__c= false;
            objPTA.GlobalShuttle_MPW_WIP__c= false;

    
            /** Product and Services **/        
            objPTA.Configurator__c = false;        
            objPTA.Design_Enablement__c = false;        
            objPTA.Process_Technology__c = false;       
            objPTA.Process_ID__c = false;        
            objPTA.IP__c = false;        
            objPTA.X3rd_Party_IP__c = false;       
            objPTA.Price_List__c = false;        
            objPTA.MPW__c = false;        
            objPTA.Turnkey__c = false;       
            objPTA.Services__c = false;
            objPTA.Procedure__c = false;
            /** PDK & Design Documents **/           
            objPTA.Design_Specification_Packages__c = false;       
            objPTA.Design_Technology_Documents__c = false;        
            objPTA.PDK__c = false;
            objPTA.IP_PLM__c= false; 
            
            /*Supplier Services*/
            objPTA.Supplier_Services__c=false;
            
            /*Vendor Services*/
            objPTA.Vendor_Services__c=false;
            
            return objPTA;                
    }
    
    @future
    public static void insertPermissionSetsFuture(Set<Id> userIds){
        clsUserTriggerHandler.insertPermissionSets(userIds);
    }   
    
    /** Modified By Cognizant on 25042013 End
     **/
     
     /**
     * This is parametrized constructor
     *
     * @param   isExecuting     boolean variable to check trigger execution context
     * @param   size            size of list processing in trigger execution context
     */    
    public ClsContactTriggerHandler(Boolean isExecuting, Integer size){
        this.isExecuting = isExecuting;
        this.size = size;
    }
    
     /**
     * This method accepts trigger context variables for on after insert event and call the actual business logic
     *
     * @param  updatedConts  list of updated Contact records
     */ 
     public void OnAfterInsert(Contact[] updatedConts){
        List<Contact> contList = new List<Contact>();
        for(Contact contObj:updatedConts){
            contList.add(contObj);
        }
        if(!contList.isEmpty()){
           ContactDeviceSharingHandler contactDeviceSharingHandler = new ContactDeviceSharingHandler();
            contactDeviceSharingHandler.shareDesignPartnerDevice(contList); 
        } 
    }
     
    /**
     * This method accepts trigger context variables for on after update event and call the actual business logic
     *
     * @param  updatedConts list of updated Contact records
     */  
    public void OnAfterUpdate(Map<Id,Contact> oldConts,Contact[] updatedConts) {  
        ContactDeviceSharingHandler contactDeviceSharingHandler= new ContactDeviceSharingHandler();
        contactDeviceSharingHandler.shareDesignPartnerDevice(updatedConts);
        contactDeviceSharingHandler.removeDesignPartnerDeviceAccess(oldConts,updatedConts);
    }
    
    /**
     * This method accepts trigger context variables for on after delete event and call the actual business logic
     *
     * @param   oldConts list of updated Contact records
     */ 
     public void OnAfterDelete(Map<Id,Contact> oldConts,Contact[] updatedConts){
        ContactDeviceSharingHandler contactDeviceSharingHandler = new ContactDeviceSharingHandler();
        contactDeviceSharingHandler.removeDesignPartnerDeviceAccess(oldConts,updatedConts);
    }
}