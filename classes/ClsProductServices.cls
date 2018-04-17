/*
 Type Name: ClsProductServices
 Author: Cognizant Technology Solutions
 Created Date: 22-April-2013
 Modified Date: 29-Aug-2013
 Reason: This class is responsible for showing the Product & Services for portal user.
 Change History:Case-4331
 Author: Cognizant FV Team
 Modified Date: Jan-08-2014
 Reason: Replacing Portal Login ID with Federation ID
 Change History:Case-4383
 Author: Cognizant FV Team
 Modified Date: Jan-10-2014
 Reason: Replacing Portal Login ID with Federation ID 
 ------------------------------------------------------
 Change:         Enable proposal and Configurator link.
 Author:         Prosenjit Saha
 Modified Date:  16-June-2014
 Reason:         Enable proposal and Configurator link
 ------------------------------------------------------
 Change:         Enable IP Catalog and Product Catalog Search links.
 Author:         Anirban Roy
 Modified Date:  23-June-2014
 Reason:         Enable IP Catalog and Product Catalog Search links.
 ------------------------------------------------------
  Change:        Enable Second Source Tapeout link
 Author:         Ariz Solito
 Modified Date:  15-Sept-2014
 Reason:         Enable Second Source Tapeout link
 ------------------------------------------------------
  Change:        Enable Yield Calculator link
 Author:         Ariz Solito
 Modified Date:  02-Oct-2014
 Reason:         Enable Yield Calculator link
 ------------------------------------------------------
  Change:        Modified code to populate PriceList upon Proposal Creation
 Author:         Anirban Roy
 Modified Date:  29-Jan-2015
 Reason:         Modified code to populate PriceList upon Proposal Creation
 ------------------------------------------------------
 Change:        Added Tools Section
 Author:         Ariz Solito
 Modified Date:  19-Oct-2015
 Reason:         Added Tools Section
 ------------------------------------------------------
  Change:        Created New Link Lead time guide
 Author:         Prashant Srivastava/c6205707
 Modified Date:  20-NOV-2015
 Reason:         Created New Link Lead time guide(Case # 00048942 )
 ------------------------------------------------------
   Change:        Assign case to CPQ team from code
 Author:         Amrita Agarwala
 Modified Date:  31-AUG-2016
 Reason:         Assign case to CPQ team from code (case #00057334)
  ------------------------------------------------------
   Change:        Created New Link for Feature Description Search
 Author:         Amrita Agarwala
 Modified Date:  20-OCT-2016
 Reason:         Created New Link  Feature Description Search
 ------------------------------------------------------
 Change:        Case#00068928 - Sprint 7:Eliminate case creation for Apttus CPQ license issues
 Author:        Surendranadh Nune
 Modified Date:  21-Mar-2017
 Reason:         Case#00068928
 ------------------------------------------------------
 Change:        Created New Link for PNP Release
 Author:         Pradosh Samal
 Modified Date:  05-22-2017
 Reason:         Created New Link  PNP Release
 
 ------------------------------------------------------
 Change:        SOQL Modified
 Author:        Ravi Teja.B
 Modified Date: 21-07-2017
 Reason:        Added new values in to approval stage picklist for Process Flow Accepted
 ------------------------------------------------------
 Change:         Access Setup for PNP Release
 Author:         Pradosh Samal
 Modified Date:  09-04-2017
 Reason:         Access Setup for PNP Release
  ------------------------------------------------------
 Change:         Access for FetaureSearchUtility link in product and services tab for portal users
 Author:         Sunita Char
 Modified Date:  31-10-2017
 Reason:         Case 00081340
 …….. 
 Change:         Created new link for QMX Work Order
 Author:         Pradosh Samal
 Modified Date:  13-Nov-2015
 Reason:         Created new link for QMX Work Order
 ------------------------------------------------------
  Change:        Created New ASIC Service Prices
 Author:         Prashant Srivastava/c6205707
 Modified Date:  01-FAB-2018
 Reason:         Created New ASIC Service Prices(Case # 00085243 )
 ------------------------------------------------------
 …….. 
 ……..
*/

public with sharing class ClsProductServices {

    public Boolean showpageBlock { get; set; }
    public Boolean showdetailsection { get; set; }
    public Boolean showwelcomesection { get; set; }


    /**
    
    Variable Declaration
    
    */
    public String Page {get; set;}
    public String OpenPageURL {get; set;}
    public String OpenTextLoginServerURL {get; set;}
    public String respectiveLevel{get;set;}
    public String respectivesubLevel{get;set;}
    public Boolean showYieldCalculator {get;set;}
    public Boolean showSecondSourceTapeout {get;set;}
    public Boolean showConfigurator{get;set;}
    public Boolean showPropoals{get;set;}
    public Boolean showdesignEnablement{get;set;}
    public Boolean showProcessTechnology{get;set;}
    public Boolean showIp{get;set;}
    public Boolean showpartyIP{get;set;}
    public Boolean showpriceList{get;set;}
    public Boolean showMPW{get;set;}
    public boolean showMyMPW {get;set;}
    public Boolean showProcedure{get;set;}
    public Boolean showServices{get;set;}
    public Boolean showTools{get;set;}
    public Boolean showProcedureSection{get;set;}
    public Boolean showServiceSection{get;set;}
    public Boolean showFrame{get;set;}
    public Boolean showsubpanelLabel{get;set;}
    public Boolean showFeatureDescSearch {get;set;}
    public Boolean showFoundryServicePrices {get;set;}
    public Boolean showASICServicePrices {get;set;}
    public String portalLoginUser;
    private List<Portal_Tab_Access__c> portaltabaccessList = new List<Portal_Tab_Access__c>();
    User userObj = new User();
    public Boolean showPNPRelease  {get;set;}
    public String  pnpReleasePage  {get;set;}
    public String  pnpReleaseLabel {get;set;}
    public Boolean showQMXWorkOrder  {get;set;}
    public String  qmxWorkOrderPage  {get;set;}
    public String  qmxWorkOrderLabel {get;set;}
    /**
        This method is used to control the link visibility to Portal User.
        
        @method name: ClsProductServices
        @return : External Site
     */
    
    public ClsProductServices ()
    {
        
       
        //Case-4331:Adding Federation ID in query:Change-001        
        userObj = [SELECT accountId,FederationIdentifier,Portal_Login__c,UserType FROM User WHERE Id =:userInfo.getUserId()];
        portaltabaccessList = [Select p.X3rd_Party_IP__c,
                                      p.Procedure__c, 
                                      p.Services__c, 
                                      p.Process_Technology__c, 
                                      p.Price_List__c, 
                                      p.MPW__c, 
                                      p.IP__c, 
                                      p.Design_Enablement__c, 
                                      p.Configurator__c,
                                      p.Proposals__c,
                                      p.second_source_tapeout__c,
                                      p.yield_calculator__c,
                                      p.tools__c,
                                      p.Launch_Configurator_Plus__c,
                                      p.Foundry_Service_Prices__c,
                                      p.ASIC_Service_Prices__c,
                                      p.PNP_Release__c,
                                      p.QMX_Work_Order__c 
                                      From Portal_Tab_Access__c p
                                       WHERE p.User__c = :userInfo.getUserId()
                                           AND p.Account__c =:userObj.accountId ];
                                           
    
        if(userObj.UserType == System.Label.Standard)
        {   
    
           //Change:PS: 16-June-2014: added new proposal variable to display the new link to the internal users. this.showYieldCalculator=
            this.showYieldCalculator=this.showSecondSourceTapeout=showConfigurator=showPropoals=showdesignEnablement=showProcessTechnology=showProcedure=
            showIp=showpartyIP=showpriceList=showMPW=showServices=showTools=showFoundryServicePrices=showASICServicePrices=showPNPRelease=showQMXWorkOrder= TRUE;  

      //Aagarwala: show Feature Desc search utility for internal customers.
            showFeatureDescSearch = true;          
        }
        else if(portaltabaccessList.size()>0)
        {
            for(Portal_Tab_Access__c portaltabaccessObj : portaltabaccessList)
            {               
                //Added Asolito 10192015
                /*-----------------mpdified by sunita for case 00081340---------------*/
                if(portaltabaccessObj.tools__c){
                    this.showTools = TRUE;
                    showFeatureDescSearch=true;
                } else {
                    this.showTools = FALSE;
                    showFeatureDescSearch=false;
                }
                /*-----------------mpdified by sunita for case 00081340---------------*/
                //Added Asolito 02102014
                if(portaltabaccessObj.yield_calculator__c){
                    this.showYieldCalculator = TRUE;
                } else {
                    this.showYieldCalculator = FALSE;
                }
                
                //Added Asolito 09152014 
                if(portaltabaccessObj.second_source_tapeout__c){
                    this.showSecondSourceTapeout = TRUE;
                } else {
                    this.showSecondSourceTapeout = FALSE;
                }
                
                if(portaltabaccessObj.Configurator__c == TRUE)
                    showConfigurator = TRUE;
                else
                    showConfigurator = FALSE;
                //Change:PS: 16-June-2014:  get permission for the Proposal link
                if(portaltabaccessObj.Proposals__c == TRUE)
                    showPropoals = TRUE;
                else
                    showPropoals = FALSE;                
                 if(portaltabaccessObj.Design_Enablement__c == TRUE)
                    showdesignEnablement = TRUE;
                else
                    showdesignEnablement = FALSE;
                    
                 if(portaltabaccessObj.Process_Technology__c == TRUE)
                    showProcessTechnology = TRUE;
                else
                    showProcessTechnology = FALSE;
                    
                if(portaltabaccessObj.IP__c == TRUE)
                    showIp = TRUE;
                else
                    showIp = FALSE;
                    
                 if(portaltabaccessObj.X3rd_Party_IP__c == TRUE)
                    showpartyIP = TRUE;
                else
                    showpartyIP = FALSE;
                    
                  if(portaltabaccessObj.Price_List__c == TRUE)
                    showpriceList = TRUE;
                else
                    showpriceList = FALSE;
                    
                   if(portaltabaccessObj.MPW__c == TRUE) {
                    showMPW = TRUE;
                    showMyMPW = true;
                   } else {
                    showMPW = FALSE;
                    showMyMPW = false;
                   }
                    
                  if(portaltabaccessObj.Procedure__c == TRUE)
                    showProcedure = TRUE;
                else
                    showProcedure = FALSE;
                    
                   if(portaltabaccessObj.Services__c == TRUE)
                    showServices = TRUE;
                else
                    showServices = FALSE;
                  if(portaltabaccessObj.Foundry_Service_Prices__c == TRUE)     
                    showFoundryServicePrices = TRUE;    
                else    
                    showFoundryServicePrices = FALSE; 
                if(portaltabaccessObj.ASIC_Service_Prices__c == TRUE)     
                    showASICServicePrices = TRUE;    
                else    
                    showASICServicePrices = FALSE;                  
                    
                if(portaltabaccessObj.PNP_Release__c == TRUE){
                    
                    showPNPRelease  = TRUE;
                }
                else{
                    showPNPRelease = FALSE;
                }
                if(portaltabaccessObj.QMX_Work_Order__c == TRUE){
                    
                    showQMXWorkOrder  = TRUE;
                }
                else{
                    showQMXWorkOrder = FALSE;
                }
            }
        }

        if(showPNPRelease){
                    
            pnpReleaseLabel = Environment_Variable__c.getInstance('PNP_RELEASE_LABEL').Value__c;
            pnpReleasePage  = Environment_Variable__c.getInstance('PNP_RELEASE_PAGE').Value__c;
        }
        if(showQMXWorkOrder){
                    
            qmxWorkOrderLabel = Environment_Variable__c.getInstance('QMX_WORK_ORDER_LABEL').Value__c;
            qmxWorkOrderPage  = Environment_Variable__c.getInstance('QMX_WORK_ORDER_PAGE').Value__c;
        }            
        Page = '' ;
        OpenPageURL = '' ;
        //Case-4331:Replacing Portal Login ID with Federation ID:Change-002
        //portalLoginUser = userObj.Portal_Login__c;
        if(userInfo.getusertype()=='CustomerSuccess' || userInfo.getusertype()=='PowerCustomerSuccess')
            portalLoginUser = userObj.Federationidentifier ;   
        else 
        portalLoginUser = null; 
        portalLoginUser = userObj.Federationidentifier ; 
        OpenTextLoginServerURL = System.Label.OTLoginServer+portalLoginUser;
        respectiveLevel = System.Label.Products_Services;
        showwelcomesection = True;
        showdetailsection = False;
        showpageBlock= False;
    }
     /**
        This method will populate user name for MPW .
        
        @method name: redirect
        @return : returns the new web site according to the links
         
     */
    
        private string getUserShortName(){
        User user = [SELECT accountId,Portal_Login__c,HCM_Login_ID__c,UserType,Parent_Account_Short_Name__c,FederationIdentifier FROM User WHERE Id =:userInfo.getUserId()];
        if (user.HCM_Login_ID__c == null || user.HCM_Login_ID__c =='')
              return user.FederationIdentifier;// Federation ID will be always populated.
        else 
              return user.HCM_Login_ID__c;// In case federation Id is null it will take Hcm Id 
    }

     /**
        This method is used to redirect the new web page according to the links are specified .
        
        @method name: redirect
        @return : returns the new web site according to the links
         
     */
    public PageReference redirect()
    {
        if(Page == 'prductservicesLink')
        {
            respectivesubLevel = 'Overview';
            respectiveLevel = 'Overview';
            showpageBlock= False;
            showwelcomesection = True;
            showdetailsection = False;
            
        }
        
        //Asolito
        //10192015 - Tools link
        if(Page == 'tools'){
           showFrame = False;
           showProcedureSection = False;
           showServiceSection = True;
           showsubpanelLabel = False;
           respectiveLevel = System.Label.Tools;
           respectivesubLevel =System.Label.Tools;
           showpageBlock= False;
           showwelcomesection = True;
           showdetailsection = False;
          
        }
        
        //Asolito
        //10192015 - Validator link
        if(Page == 'validator'){
           showFrame = True;
           showsubpanelLabel = False;
           showProcedureSection = False;
           showServiceSection  = False;
           respectiveLevel = System.Label.Validator;
           respectivesubLevel = System.Label.Validator;
           OpenPageURL = System.Label.Validator_URL+'?username='+portalLoginUser ;
           showpageBlock= True;
           showwelcomesection = False;
           showdetailsection = True;
        }
        //Added by Amrita 
         if(Page == 'FeatureDescriptionSearch'){
           showFrame = True;
           showsubpanelLabel = False;
           showProcedureSection = False;
           showServiceSection  = False;
           respectiveLevel = System.Label.FeatureDescriptionSearch;
           respectivesubLevel = System.Label.FeatureDescriptionSearch;
           OpenPageURL = System.Label.FeatureDescriptionSearch_URL+'?username='+portalLoginUser ;
           showpageBlock= True;
           showwelcomesection = False;
           showdetailsection = True;
        }
        //Asolito
        //02102014 - Yield Calc link
        if(Page == 'yieldcalc'){
           showFrame = True;
           showsubpanelLabel = False;
           showProcedureSection = False;
           showServiceSection  = False;
           respectiveLevel = System.Label.Yield_Calculator;
           respectivesubLevel =System.Label.Yield_Calculator;
           OpenPageURL = System.Label.Yield_Calculator_URL ;
           showpageBlock= True; 
            showwelcomesection = False; 
            showdetailsection = True;
        }
        
        if(Page == 'myMPW') {
           showFrame = True;
           showsubpanelLabel = False;
           showProcedureSection = False;
           showServiceSection  = False;
           respectiveLevel = System.Label.MPW_My_MPW_URL;
           respectivesubLevel = System.Label.MPW_My_MPW_Label;
           OpenPageURL = System.Label.MPW_My_MPW_URL ;
           showpageBlock= True; 
           showwelcomesection = False; 
           showdetailsection = True;
        }
        
        //Asolito 09152014
        //Added Second Source Tapeout link
        if(Page == 'SecondSourceTapeout'){        
        
           showFrame = TRUE;
           showsubpanelLabel = False;
           showProcedureSection = False;
           showServiceSection  = False;
           respectiveLevel = System.Label.Second_Source_Tapeout;
           respectivesubLevel = System.Label.Second_Source_Tapeout;
           boolean ischanged = false;
           
           //calling getCatalogProposal method to get the new proposal or avialable proposal. 
           Apttus_Proposal__Proposal__c NewProposal = getCatalogProposal('Multi Source');
           
           //If the proposal is new: then set the 'Proposal from Teamroom' Record type to the new proposal 
           if(NewProposal.RecordTypeID == NULL){
               NewProposal.RecordTypeID = [SELECT id, name from RecordType where name = 'Proposal from Teamroom'].id;
               ischanged = true;
           }                     
           
           //if the proposal is new then, update the price list and record type. 
           if( ischanged == true){
               try{
                   update NewProposal;
               }
               catch(exception e){throw e;}
           }
                    
           //Prepare the configurator URL to navigate the user to the configurator page. 
           //01292015 ARoy : Modified code to remove the approval stage check
           if(String.valueOf(URL.getSalesforceBaseUrl()).contains('globalfoundryview')){
               OpenPageURL = (
                                   NewProposal.Apttus_QPConfig__PriceListId__c != NULL? 
                                   'Apttus_QPConfig__ProposalConfiguration?id='+NewProposal.id /*+ '&prodscope_1=Name&prodscope_2=ProductCode&prodscope_3=Description'*/+ '&flow=GFFlow' 
                                   : '');
           }
           else{
               OpenPageURL = (
                                    NewProposal.Apttus_QPConfig__PriceListId__c != NULL? 
                                   '/apex/Apttus_QPConfig__ProposalConfiguration?id='+NewProposal.id /*+ '&prodscope_1=Name&prodscope_2=ProductCode&prodscope_3=Description'*/+ '&flow=GFFlow' 
                                   : '');
           }        
           showpageBlock= False;
           showwelcomesection = False;
           showdetailsection = True;
           
        }
        
        //Change:PS: 16-June-2014: Following block has been modified to get proper Configurator link.
        if(Page == 'configurator')
        {
           //03022016 Naman : Case #00050039 - Check for Apttus License 
           Boolean bypass = false;
           
           /*Integer userCount = [SELECT    count()
                                FROM      UserPackageLicense 
                                WHERE     PackageLicense.NamespacePrefix = 'Apttus_Config2'
                                AND       UserId =:UserInfo.getUserId()]; */
           Boolean userAccessChk = UserInfo.isCurrentUserLicensed('Apttus_Config2');  
                                
           for(CPQLicenseUnavailable__c cs : CPQLicenseUnavailable__c.getAll().values()){
               if(userinfo.getProfileId().contains(cs.id__c)){
                   bypass = true;
               }                
           }            
    
           if(userAccessChk || bypass){
               showFrame = TRUE;
               showsubpanelLabel = False;
               showProcedureSection = False;
               showServiceSection  = False;
               respectiveLevel = System.Label.Configurator;
               respectivesubLevel = System.Label.Configurator;
               boolean ischanged = false;
               
               //calling getCatalogProposal method to get the new proposal or avialable proposal. 
               Apttus_Proposal__Proposal__c NewProposal = getCatalogProposal('First Source');
               
               //If the proposal is new: then set the 'Proposal from Teamroom' Record type to the new proposal 
               if(NewProposal.RecordTypeID == NULL){
                   NewProposal.RecordTypeID = [SELECT id, name from RecordType where name = 'Proposal from Teamroom'].id;
                   ischanged = true;
               }           
               
               //if the proposal is new then, update the price list and record type. 
               if( ischanged == true){
                   try{
                       update NewProposal;
                   }
                   catch(exception e){throw e;}
               }
               
               //Prepare the configurator URL to navigate the user to the configurator page. 
               //01292015 ARoy : Modified code to remove the approval stage check
               if(String.valueOf(URL.getSalesforceBaseUrl()).contains('globalfoundryview')){
                   OpenPageURL = (
                                    NewProposal.Apttus_QPConfig__PriceListId__c != NULL? 
                                       'Apttus_QPConfig__ProposalConfiguration?id='+NewProposal.id /*+ '&prodscope_1=Name&prodscope_2=ProductCode&prodscope_3=Description'*/+ '&flow=GFFlow' 
                                       : '');
               }
               else{
                   OpenPageURL = (
                                    NewProposal.Apttus_QPConfig__PriceListId__c != NULL? 
                                       '/apex/Apttus_QPConfig__ProposalConfiguration?id='+NewProposal.id /*+ '&prodscope_1=Name&prodscope_2=ProductCode&prodscope_3=Description'*/+ '&flow=GFFlow' 
                                       : '');
               }
               showpageBlock= False;
               showwelcomesection = False;
               showdetailsection = True;
            }else{                                                                                  
                 return null;                                                                                           
            }  
        }                
        
        //Change:PS: 16-June-2014: Following section handles the proposal List view URL. 
        if(Page == 'Proposals')
        {
           showFrame = True;
           showsubpanelLabel = False;
           showProcedureSection = False;
           showServiceSection  = False;
           respectiveLevel = System.Label.Proposals;
           respectivesubLevel = System.Label.Proposals;
           OpenPageURL = System.Label.Proposal_URL ;
           showpageBlock= True;
            showwelcomesection = False;
            showdetailsection = True;
        }
        if(Page == 'design')
        {
           showFrame = True;
           showsubpanelLabel = False;
           showProcedureSection = False;
           showServiceSection  = False;
           respectiveLevel = System.Label.Design_Enablement;
           respectivesubLevel =System.Label.Design_Enablement;
           OpenPageURL = System.Label.Design_Enablement_URL ;
           showpageBlock= True;
           showwelcomesection = False;
           showdetailsection = True;
           
        }
        if(Page == 'processtech')
        {
           showFrame = True;
           showsubpanelLabel = False;
           showProcedureSection = False;
           showServiceSection  = False;
           respectiveLevel = System.Label.Process_Tech;
           respectivesubLevel =System.Label.Process_Tech;
           OpenPageURL = System.Label.Process_Tech_URL ;
           showpageBlock= True;
            showwelcomesection = False;
            showdetailsection = True;
        }
        if(Page == 'ip')
        {
           showFrame = True;
           showsubpanelLabel = False;
           showProcedureSection = False;
           showServiceSection  = False;
           respectiveLevel = System.Label.IP;
           respectivesubLevel =System.Label.IP;
           OpenPageURL = System.Label.IP_URL ;
           showpageBlock= True;
            showwelcomesection = False;
            showdetailsection = True;
        }
        // Added by Prashant on 11/20/2015 for case # 00048942  
        //Start of the changes
        if(Page == 'Leadtimeguide')
        {
           userObj = [SELECT accountId,FederationIdentifier,Portal_Login__c,userType FROM User WHERE Id =:userInfo.getUserId()];
         

            if(userInfo.getusertype()=='CustomerSuccess' || userInfo.getusertype()=='PowerCustomerSuccess')
                portalLoginUser = userObj.Federationidentifier ;   
            else 
               portalLoginUser = null;        
               OpenTextLoginServerURL = System.Label.OTLoginServer+portalLoginUser;
               respectiveLevel = System.Label.Products_Services;
               showwelcomesection = True;
               showdetailsection = False;
               showpageBlock= False;
               showFrame = True;
               showsubpanelLabel = False;
               showProcedureSection = False;
               showServiceSection  = False;
               respectiveLevel = System.Label.Lead_time_guide;
               respectivesubLevel =System.Label.Lead_time_guide;
               OpenPageURL = System.Label.Lead_Time_Guide_URL+'&username='+portalLoginUser;
               showpageBlock= True;
               showwelcomesection = False;
               showdetailsection = True;
        }
        //End of the changes
        if(Page == 'partyip')
        {
           showFrame = True;
           showsubpanelLabel = False;
           showProcedureSection = False;
           showServiceSection  = False;
           respectiveLevel = System.Label.Party_IP;
           respectivesubLevel =System.Label.Party_IP;
           OpenPageURL = System.Label.Party_IP_URL ;
           showpageBlock= True;
            showwelcomesection = False;
            showdetailsection = True;
        }
        if(Page == 'pricelist')
        {
           showFrame = True;
           showsubpanelLabel = False;
           showProcedureSection = False;
           showServiceSection  = False;
           respectiveLevel = System.Label.Price_List;
           respectivesubLevel =System.Label.Price_List;
           OpenPageURL = System.Label.Price_List_URL;
           showpageBlock= True;
            showwelcomesection = False;
            showdetailsection = True;
        }
        if(Page == 'mpw')
        {
           showFrame = True;
           showsubpanelLabel = False;
           showProcedureSection = False;
           showServiceSection  = False;
           respectiveLevel = System.Label.MPW;
           respectivesubLevel =System.Label.MPW;
           OpenPageURL = System.Label.MPW_URL+'PT-User-Name='+getUserShortName();
           
           showpageBlock= True;
            showwelcomesection = False;
            showdetailsection = True;
        }
        if(Page == 'procedure')
        {
           showFrame = True;
           showsubpanelLabel = False;
           showProcedureSection = False;
           showServiceSection  = False;
           respectiveLevel = System.Label.Procedure;
           respectivesubLevel =System.Label.Procedure;
           OpenPageURL = System.Label.Procedure_URL+'&username='+portalLoginUser;
           showpageBlock= True;
            showwelcomesection = False;
            showdetailsection = True;
          
        }
        if(Page == 'services')
        {
           showFrame = False;
           showProcedureSection = False;
           showServiceSection = True;
           showsubpanelLabel = False;
           respectiveLevel = System.Label.Services;
           respectivesubLevel =System.Label.Services;
           showpageBlock= False;
            showwelcomesection = True;
            showdetailsection = False;
           
        }
       
        if(Page == 'car')
        {
           showFrame = True;
           showsubpanelLabel = True;
           respectivesubLevel = System.Label.CAR;
           OpenPageURL = System.Label.CAR_URL+'&username='+portalLoginUser ;   
           showpageBlock= True;
            showwelcomesection = False;
            showdetailsection = True;

        }
        if(Page == 'rma')
        {
           showFrame = True;
           showsubpanelLabel = True;
           respectivesubLevel = System.Label.RMA;
           OpenPageURL = System.Label.RMA_URL;
           //'apex/rma_search'; 
           //System.Label.RMA_URL+'&username='+portalLoginUser+System.Label.OpenTextSortParam ;   
           showpageBlock= True;
            showwelcomesection = False;
            showdetailsection = True;

        }
        if(Page == 'wafercompliance')
        {
           showFrame = True;
           showsubpanelLabel = True;
           respectivesubLevel = System.Label.Wafer_Complaince;
           OpenPageURL = System.Label.Wafer_Complaince_URL+'&username='+portalLoginUser;   
           showpageBlock= True;
            showwelcomesection = False;
            showdetailsection = True;
 
        }
        //Added by Sameera    
        if(Page == 'foundryserviceprices'){    
            showpageBlock= True;    
            showwelcomesection = False;    
            showdetailsection = True;    
            respectivesubLevel = System.Label.Foundry_Service_Prices;    
            OpenPageURL = System.Label.Foundry_Service_Prices_URL+'?Foundry=1';       
        }
        //Added by Prashant    
        if(Page == 'ASICserviceprices'){    
            showpageBlock= True;    
            showwelcomesection = False;    
            showdetailsection = True;    
            respectivesubLevel = System.Label.ASIC_Service_Prices;    
            OpenPageURL = System.Label.Foundry_Service_Prices_URL+'?Foundry=2';       
        }
        
        if(Page == pnpReleasePage){
            
            showFrame            = TRUE;
            showsubpanelLabel    = FALSE;
            showProcedureSection = FALSE;
            showServiceSection   = FALSE;
            respectiveLevel      = pnpReleaseLabel;
            respectivesubLevel   = pnpReleaseLabel;
            OpenPageURL          = pnpReleasePage;
            showpageBlock        = TRUE;
            showwelcomesection   = FALSE;
            showdetailsection    = TRUE;
        }
        if(Page == qmxWorkOrderPage){
            
            showFrame            = TRUE;
            showsubpanelLabel    = FALSE;
            showProcedureSection = FALSE;
            showServiceSection   = FALSE;
            respectiveLevel      = qmxWorkOrderLabel;
            respectivesubLevel   = qmxWorkOrderLabel;
            OpenPageURL          = qmxWorkOrderPage;
            showpageBlock        = TRUE;
            showwelcomesection   = FALSE;
            showdetailsection    = TRUE;
        }
        //if the Configurator has not been clicked then display in the iframe. 
        // added by AR on 6/23/2014 : condition added for IP Catalog Search and Product Catalog Search
        if(Page != 'SecondSourceTapeout' && Page != 'configurator' && Page != 'processtech' && Page != 'ip'){
            return null;
        }
        //if configurator has been clicked then display the configurator in separate tab.
        // added by AR on 6/23/2014 : if IP Catalog Search or Product Catalog Search has been clicked 
        // then display the configurator in separate tab.
        else{
            if(String.valueOf(URL.getSalesforceBaseUrl()).contains('globalfoundryview')){
                return new pagereference('/'+OpenPageURL);
            }
            else{
                return new pagereference('/apex/'+OpenPageURL);
            }
        }
        
    }
    
    /** Change:PS: 16-June-2014: 
        This method is used to get Proposal to use for the configurator: 
            This method will try to find the last draft proposal created by the current user. 
            if no such proposal is present then,  Create e new proposal.
        
        @method name: getCatalogProposal
        @return :     Apttus_Proposal__Proposal__c 
        
        @History: PS 0132015: new variable will be used to distinguish whether this is from first source or multi-source.
         
     */
    public Apttus_Proposal__Proposal__c getCatalogProposal(String CatalogType){
        List<Apttus_Proposal__Proposal__c> Prop = new List<Apttus_Proposal__Proposal__c>();
        Apttus_Proposal__Proposal__c NewProp = new Apttus_Proposal__Proposal__c();
        String PropAccount ;
        if(UserInfo.getUsertype() != System.Label.Standard){
            PropAccount = [SELECT name,ContactID,id, contact.Account.ID, contact.Account.name from user where id = :UserInfo.getUserId() ].contact.Account.ID;
        }
        
        //query--
        String szProposalQuery;
        
        //preparing query string
        // 01292015 ARoy : Modified query to add pricelist check and approval stage check
        szProposalQuery =  'SELECT id, name, Apttus_Proposal__Approval_Stage__c, Apttus_QPConfig__PriceListId__c, Apttus_Proposal__Account__c, Device__c, Mask_Set_Long__c, Catalog_Type__c,  APTPS_Primary__c FROM  Apttus_Proposal__Proposal__c';
        szProposalQuery += ' WHERE  Apttus_Proposal__Approval_Stage__c = \'Draft\''+' AND    CreatedByid = \''+ UserInfo.getUserId() + '\'' ;                     
        szProposalQuery += ' AND Process_Technology__c = NULL' +   (UserInfo.getUsertype() != System.Label.Standard ? ' AND Apttus_Proposal__Account__c = \''+ PropAccount + '\'' : '');
        szProposalQuery += ' AND Catalog_Type__c =  \''+CatalogType+ '\'' ; 
        szProposalQuery += ' AND Device__c  =  NULL ' ;
        szProposalQuery += ' AND APTPS_Primary__c = TRUE ';
        szProposalQuery += ' AND Apttus_QPConfig__PriceListId__c != NULL ';
        szProposalQuery += ' ORDER BY  name desc LIMIT  1';                          
                                           
        Prop = Database.query(szProposalQuery);
       
        //If proposal is not present for the current user, then create a new proposal with the account of the external user. 
        if(Prop.size() == 0){    
            if(UserInfo.getUsertype() != System.Label.Standard){
                NewProp.Apttus_Proposal__Account__c    = PropAccount;
            }
            NewProp.APTPS_Primary__c = TRUE;
            NewProp.Apttus_Proposal__Proposal_Name__c  = String.valueOf(DateTime.now());
            NewProp.Catalog_Type__c = CatalogType == 'Multi Source' 
                                        ? 'Multi Source' 
                                        : 'First Source' ;
            NewProp.Apttus_Proposal__Approval_Stage__c = 'Draft'; 
        
            //changed reference of Mask_Set__c to Mask_Set_Long__c for the Case#00051463
            NewProp.Mask_Set_Long__c = null ;
            //01292915 ARoy : Added the UpdatePricelist method call to populate the pricelist before insertion
            ProposalTriggerUtil.UpdatePricelist(new List<Apttus_Proposal__Proposal__c>{NewProp});
            try{
                 insert NewProp;
            
                }catch(exception e){throw e;}
           
            return NewProp;
        }
        else{   
            return Prop [0];
        }
    }
    
    //03022016 Naman : Case #00050039 - Check for Apttus License
   @RemoteAction
   public static String checkLicense(){
       String errorMsg = '';
       Boolean bypass = false;      
       Boolean userAccessChk = UserInfo.isCurrentUserLicensed('Apttus_Config2');
        
       for(CPQLicenseUnavailable__c cs : CPQLicenseUnavailable__c.getAll().values()){           
           if(userinfo.getProfileId().contains(cs.id__c)){
               bypass = true;              
           }                
       } 
                      
       if(!userAccessChk && bypass == false){
           //Case#00068928 --snune-- START
           List<PackageLicense> licenseList = [SELECT Id, NamespacePrefix, AllowedLicenses, UsedLicenses,ExpirationDate,Status 
                                               FROM PackageLicense 
                                               WHERE NamespacePrefix = 'Apttus_Config2'];
           if(licenseList != null && !licenseList.isEmpty()){ 
               try{
                 insert new UserPackageLicense(PackageLicenseId = licenseList[0].Id, userid=userinfo.getUserId());
                 errorMsg=(Environment_Variable__c.getInstance('ConfiguratorAccessLicenseMsg'))!=null?String.valueOf(Environment_Variable__c.getInstance('ConfiguratorAccessLicenseMsg').value__c)
                                   :'Click again we have assigned license to access Configurator.';
               }catch(Exception e){
                   errorMsg = hasExistingCase();
           }
           }                              
           //Case#00068928 --snune-- END
           return errorMsg; 
       }else{           
           return null;
       }                 
   }
   
   //Case#00068928 --snune-- START
   @Testvisible  
   private static String hasExistingCase(){
       String errorMsg = '';
       String sub = 'Apttus CPQ License for '+UserInfo.getName();
       List<Case> existingCase = new List<Case>([Select id,CaseNumber from Case where subject = :sub  and createdbyId =: userinfo.getUserId()]);
       if(!existingCase.isEmpty()){
          errorMsg = 'Already a Case #No.' + existingCase[0].CaseNumber + ' is existing for your apttus access';
       }else{
           errorMsg = Label.CPQ_License_Unavailable;
           sendEmail(URL.getCurrentRequestUrl().toExternalForm());
       }
       return errorMsg;
   } 
   //Case#00068928 --snune-- 
   
   @future 
   public static void sendEmail(String urlPass){
     try{

           Group record = [select Id from Group where Name = 'CPQ team' and Type = 'Queue'  limit 1]; // case #00057334
           
           //Case#00068928 --snune-- Assigning the recordtype explicitly, because case is being created with default record type.
           Case cs = new Case(Recordtype = new RecordType(name='SFDC Support'));
           cs.Region__c = 'US';
           cs.Application__c = 'Salesforce';
           cs.Business_process__c = 'Apttus CPQ';
           cs.Severity__c = 'Urgent';
           cs.Priority = 'Medium';
           cs.Support_Level__c = 'L1';
           cs.Subject = 'Apttus CPQ License for '+UserInfo.getName();
           cs.Description = 'Unable to access configurations. Please provide CPQ license';
           cs.Status = 'New';
           cs.Classification__c = 'Admin Request';
           cs.ownerid  = record.Id;
           insert cs;
           
           EmailTemplate emailTemplate = [select Id, Subject, HtmlValue, Body from EmailTemplate where name = 'CPQ License Unavailable Template'];
           Messaging.SingleEmailMessage semail = new Messaging.SingleEmailMessage();
           String[] sendingTo = new String[]{userinfo.getUserEmail()};
           semail.setToAddresses(sendingTo);                        
           semail.setSubject(emailTemplate.subject);
           String body = emailTemplate.htmlValue;
           body = body.replace('{!User.FirstName}',userinfo.getFirstName());           
                      
           if(urlPass.contains('GlobalfoundryView')){
               String curntUrl =  urlPass.remove('apexremote');
               curntUrl += cs.id;
               body = body.replace('{!Case.Id}',curntUrl);
           }           
           semail.setHtmlBody(body);           
           Messaging.sendEmail(new Messaging.SingleEmailMessage[] {semail});
        }catch(exception e){throw e;}
   }
   
}