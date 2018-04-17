/*
 Type Name: ClsMyDevices
 Author: Cognizant Technology Solutions
 Created Date: 10-April-2013
 Modified Date: 26-Aug-2013
 Reason: This class is responsible for showing the My Devices for portal user.
 Change History:

 
Author: Nino Bustillos
Modified Date: 29-Sept-2013
Reason: Merged code with Device Migration project for IP declaration/Export Control and NPC forms.
Change History: Case-4383:Adding sorting parameters in OpenTExt report URLs.

Author: Cognizant FV Team
Modified Date: Jan-08-2014 
Reason: Needs sorting based on modified date for all OpenText reports in tabs-My Wafer & My Device.
Change History:Case-4331

Author: Cognizant FV Team
Modified Date: Jan-08-2014
Reason: Replacing Portal Login ID with Federation ID 


Author: Vijay Mahajan
Modified Date: 22-April-2014 
Reason: No need to pass username parameter to open new CPK FV page. So commented the url parameter in 'CPK' section of redirect method. 


Author: Cognizant FV Team
Modified Date: July-30-2014
Reason: Case 25529

Author: Cognizant
Modified Date: 20-Aug-2014
Reason: Case 29542 (Sprint10: ROS GFV Enablement)


Modified Date: 04-Sep-2014
Reason: SWIFT Gen+ Implementation Tapeout Menu

Author: IBM
Modified Date: 28-Nov-2014
Reason: shownewpartcreationLink set to false for internal users by Sunil Arora for case # 37624
        
Author: IBM
Modified Date: 07-Apr-2015

Reason: Added method getUserShortNamePRF and changed variableOpenPageURL for case # 40399

Author: IBM
Modified Date: 21-Apr-2015
Reason: changed variableOpenPageURL for case # 40696

Author: GF Internal
Modified Date: 23-Nov-2015
Reason : Removed Global Shuttle MPW links and renamed MPW  as advised by Business user

Author: Anirban Roy         
Modified Date: 20-May-2016      
Reason : Adding the 'My Configurator' link under My Devices tab

Author: Anirban Roy         
Modified Date: 20-May-2016      
Reason : Adding the 'My Configurator' link under My Devices tab

Author: Long Luu
Modified Date: 20-July-2016
Reason : Hide Tapeout Application Mebes Jobview under Tapeout >> MRS >> Mebes Jobview (edited flag: showTapeOutApplicationReviewLink)

Author: Anil Kumar Reddy L
Modified Date: 26-NoV-2016
Reason : Added logic for Tapout Fab 9/10 devices

Author: Dinesh Suggala    
Modified Date:30th-Mar-2017
Reason: Hide DropBox Link based on DropBox__c checkbox in AccessSetUp

Author: Abhita Bansal
        Modified Date: 20-May-2017
        Reason : Changed the Label by Abhita for UAT Issue #166

Author: Anirban Roy         
Modified Date: 09-Jul-2016      
Reason : Modified the condition for FMS links

*/

public with sharing class ClsMyDevices
{

    /**
    
    Variable Declaration
    
    */

    
    public String  Page{get; set;}
    public String  ipdeclareLink{get; set;}
    public String  exportcontrolLink{get; set;}
    public String  ptrfLink{get; set;}
    public String  webviewLink{get; set;}
    public String  globalshuttlerepresentLink{get; set;}
    public String  analysisreportLink{get;set;}
    public String  newpartcreationLink{get; set;}
    public String  processrequestformLink{get; set;}
    public String  processreliabilityLink{get; set;}
    public String  reticleobsolescenceLink{get; set;}
    public String  rtrrtpLink{get;set;}
    public String  riskwaiverLink{get;set;}
    public String  steppertoolingformLink{get;set;}
    public String  OpenPageURL {get; set;}
    public String  OpenTextLoginServerURL {get; set;}
    public String  respectiveLevel{get; set;}
    public Boolean showpageBlock{get;set;}
    public Boolean showelectrictestLink{get;set;}
    public Boolean showInlineMeasurementLink{get;set;}//added by cognizant for Case 25529
    public Boolean showwaferinspectionLink{get;set;}
    public Boolean showyieldsReportingLink{get;set;}
    public Boolean showcpkLink{get;set;}
    public Boolean showWLRLink{get;set;}
    public Boolean showenglotstatusLink{get;set;}
    public Boolean showcpkreportLink {get;set;}
    public Boolean showanalysisreportLink{get;set;}
    public Boolean showCRLink{get;set;}
    public Boolean showproductwaferLink{get;set;}
    public Boolean showpcrbLink{get;set;}
    public Boolean showwipstatusLink{get;set;}
    public Boolean showlotcontroltableLink{get;set;}
    public Boolean showprocesstechnologyLink{get;set;}
    public Boolean showwelcomesection{get;set;}
    public Boolean showdetailsection{get;set;}
    
    public Boolean showmydeviceshomeLink{get;set;}
    public Boolean showipdeclarationLink{get;set;}
    public Boolean showexportcontrolLink{get;set;}
    public Boolean showProposals{get;set;} // Added by ARoy on 05/20/2016 to add 'My Configurator' link
    public Boolean showptrfLink{get;set;}
    public Boolean showFab9n10Link{get;set;} // Added by ARoy for FMS links on 09072017
    public Boolean showwebviewLink{get;set;}
    public Boolean showglobalshuttlerepresentLink{get;set;}
    public Boolean showsteppertoolingformLink{get;set;}
    public Boolean shownewpartcreationLink{get;set;}
    public Boolean showprocessrequestformLink{get;set;}
    public Boolean showriskwaiverLink{get;set;}
    public Boolean showrtrrtpLink{get;set;}
    public Boolean showprocessreliabilityLink{get;set;}
    public Boolean showreticleobsolescenceLink{get;set;}
    public Boolean showfieldsforEHS{get;set;}
    public Boolean showfieldsforBCM{get;set;}
    public Boolean showfieldsforImpact{get;set;}
    public List<Portal_Tab_Access__c> portaltabaccessList = new List<Portal_Tab_Access__c>();
    public String portalLoginUser;
    //Anil Kumar Reddy L added fields
    public Boolean showCreateDeviceLink{get;set;}
    public String  createDeviceLink{get; set;}
    public String  viewDevicesLink{get; set;}
    
    //Ramareddy K added fields
    
     public Boolean showviewpcneol{get;set;}
        /** Start of code for SwiftGen project **/
    // flag indicating whether the page in iframe belong to SWIFT or not
    private static boolean internalView;
    public Boolean isSwiftPage {get; private set;}
    public Boolean isSwiftMRSPage {get;private set;}
    public Boolean showRemoteJobviewLink {get; private set;}
    public Boolean showFrameMockupLink {get; private set;}
    public Boolean showGDSOUTReviewLink {get; private set;}
    public Boolean showMEBBESLink {get; private set;}
    public Boolean showSendData{get; private set;}
    public Boolean showHoldAndResume{get; private set;}
    public Boolean showFoundryFrameMockupLink {get; private set;}
    public Boolean showFoundryGDSOUTReview {get; private set;}
    public Boolean showFoundryMEBBESReviewLink {get; private set;}
    public Boolean showTapeOutCenterReviewLink {get; private set;}
    public Boolean showTapeOutApplicationReviewLink {get; private set;}//this field will be no longer in use
    public Boolean showGlobalShuttleReviewLINK { get; private set;}
    public Boolean showMDPReviewLink {get; private set;}
    public Boolean showTDTIReviewLink {get; private set;}
    public Boolean showFrameSendData {get; private set;}
    public Boolean showPrimeSendData {get; private set;}
    public Boolean showHoldResumeLink {get; private set;}
    
    public Boolean showCreateDRTLink {get; private set;}
    public Boolean showSearchDRTLink {get; private set;}
    public Boolean showDRTLink {get; private set;}
    public String respectivesubLevel{get;set;}
    public Boolean showMPW{get;set;}
    
    //Added by Ashish
    public Boolean showModuleFinaltest {get;set;}
    public Boolean showWaferSortTest {get;set;}
    
    
    public String iframeParam {get; set;}
    public static Cookie account;
    public static Cookie mst;
    public static String rememberedMST;
    public String parameter{get;set;}
    /** End of code for SwiftGen project **/
    
    /** Start Of MDD Declaration **/
    public Boolean showPartSearchLink {get; set;}
    public Boolean showReachLink {get; set;}
    public Boolean showChinaRohsLink {get; set;}
    public Boolean showEngineeringSpecLink {get; set;}
    public Boolean showMDD {get; set;}
    
    /** End Of MDD Declaration **/
    //Added by Dinesh
    public Boolean showdropboxLink {get;set;}
    public Boolean Isportal;
    public String dropbox {get;set;}
    public String dropbox1;
    public String dropbox2;
    public String dropbox3;
    
    public Boolean showQualityApp {get; set;}
    public Boolean OtherEHS {get; set;}
    public Boolean BCM {get; set;}
    public Boolean ImptNotification {get; set;}
    User userObj = new User();
    
     /**
        This method controls to showing the Links in the left hand panel and to
        showing the My Devices Home elements list.
        
        @method name: ClsMyDevices
        @return : Boolean variables are set to true according to the Portal Tab Access record and 
                  returns the test data in the respective pageblock table.
     */
    /** start of code for SwiftGen **/
    static {
        string hostName = ApexPages.currentPage().getHeaders().get('Host');
        if(!string.isBlank(system.label.Internal_URL) && system.label.Internal_URL.containsIgnoreCase(hostName)) {
            internalView = true;
        }
        else {
            internalView = false;
        }
    }
    
    /** end of code for SwiftGem**/    
    public ClsMyDevices()
    {
           showfieldsforEHS = false;     
           showfieldsforBCM = false;   
           showfieldsforImpact = false;
           //Anil Kumar Reddy L Added  logic for Fab9/10
                   showCreateDeviceLink = false;
                   viewDevicesLink = '/apex/FMSFAB_9_10_DevicesPage';
                /** Modification of code for SwiftGen project **/
        userObj = [SELECT accountId,Contact.AccountId,Portal_Login__c,UserType,Parent_Account_Short_Name__c,FederationIdentifier, Id ,Contact.Account.Contract_Customer__c,ContactId FROM User WHERE Id =:userInfo.getUserId()];
        /** End of code for SwiftGen project **/
        if(userObj.Contact.Account.Contract_Customer__c && UserInfo.getUserType() != 'Standard'){
            showCreateDeviceLink = true;
        }
        //Anil kumar Reddy L logic added for Fab 9/10
        //Added by Dinesh 30/3/2017 for dropbox link
         
        if (userObj.ContactId != null) {
           Isportal= true;
        }
         else{
           Isportal=false;
        }          
        //Ended code for DropBox Link
      
        portaltabaccessList = [SELECT p.Wafer_Inspection__c, 
                                      p.WIP_Status__c, 
                                      p.Product_Wafer_Compliance_Analysis__c, 
                                      p.PCN_End_of_Life__c,  // Added by Rama
                                      p.Electrical_Test__c,
                                      p.Module_Final_Test__c,                                     
                                      p.Wafer_Sort_Test__c,
                                      p.Inline_Measurement__c,//added by cognizant for Case 25529 
                                      p.CPK__c,
                                      p.Yield_Sort_ETest_Reporting__c,
                                      p.Process_Technology__c, 
                                      p.Lot_Control_table__c,
                                      p.Web_View__c, 
                                      p.Stepper_Tooling_Form__c, 
                                      p.Risk_Waiver__c, 
                                      p.Reticle_Obsolescence__c, 
                                      p.RTR_RTP__c, 
                                      p.Process_Request_Form_PRF__c, 
                                      p.Process_Reliability_Monitoring__c, 
                                      p.PTRF__c,  
                                      p.PCRB__c,  
                                      p.New_Part_Creation_after_Proto_form__c, 
                                      p.IP_Declaration__c,
                                      p.Proposals__c, // Added by ARoy on 05/20/2016 to add 'My Configurator' link                                    
                                      p.Global_Shuttle_reservation__c, 
                                      p.Export_Control__c,
                                      p.WLR_Monitoring_report__c, 
                                      p.Engineering_Lot_status_report__c, 
                                      p.ET_and_Inline_CPK_report__c, 
                                      p.Construction_Analysis_report__c, 
                                      p.Change_request_report__c,
                                      p.MDD_Parts__c,
                                      p.Quality_System__c,
                                      p.Other_EHS_CSR_Disclosures__c,
                                      p.ImpactNotify__c,
                                      p.BCM__c,
                                      p.MPW__c,
                                      p.Tapeout_Fab_9_10__c, // Added By Abhita
                                      p.DropBox__c           // Added by Dinesh 30/3/2017

                                      From Portal_Tab_Access__c p
                                       WHERE p.User__c = :userInfo.getUserId()
                                           AND p.Account__c =:userObj.accountId ];
                                 
        if(userObj.UserType == System.Label.Standard)
        {
/*-----commented by cognizant for Case 25529 start--------------------------------------------------*/              
          /* showlotcontroltableLink =showpcrbLink =showyieldsReportingLink=showcpkLink=showelectrictestLink=showproductwaferLink=showCRLink=
           showanalysisreportLink=showcpkreportLink=showenglotstatusLink=showWLRLink=showwipstatusLink=showwaferinspectionLink=
           showipdeclarationLink = showexportcontrolLink = showptrfLink = showwebviewLink = showglobalshuttlerepresentLink = showsteppertoolingformLink =
           shownewpartcreationLink = showprocessrequestformLink = showriskwaiverLink = showrtrrtpLink = showprocessreliabilityLink = 
           showreticleobsolescenceLink = TRUE;*/
/*-----commented by cognizant for Case 25529 end--------------------------------------------------*/                
/*-----added by cognizant for Case 25529 start--------------------------------------------------*/ 
            //shownewpartcreationLink set to false by Sunil Arora for case # 37624
           showlotcontroltableLink =showpcrbLink =showyieldsReportingLink=showcpkLink=showelectrictestLink=showInlineMeasurementLink=showproductwaferLink=showCRLink=
           showanalysisreportLink=showcpkreportLink=showenglotstatusLink=showWLRLink=showwipstatusLink=showwaferinspectionLink=
           showipdeclarationLink = showexportcontrolLink = showptrfLink = showwebviewLink = showglobalshuttlerepresentLink = showsteppertoolingformLink =
           showprocessrequestformLink = showriskwaiverLink = showrtrrtpLink = showprocessreliabilityLink = showMPW =
           showreticleobsolescenceLink = showProposals = showMDD = showModuleFinaltest = showWaferSortTest = showQualityApp = ImptNotification = OtherEHS = BCM = showviewpcneol=showdropboxLink=showFab9n10Link=TRUE;   // Added by ARoy on 05/20/2016 to add 'My Configurator' link
           shownewpartcreationLink=FALSE;
 /*-----added by cognizant for Case 25529 end--------------------------------------------------*/                   
         
        }
        else if(portaltabaccessList.size()>0)
        {
            for(Portal_Tab_Access__c portaltabaccessObj : portaltabaccessList)
            {
                if(portaltabaccessObj.Wafer_Inspection__c == TRUE)
                    showwaferinspectionLink = TRUE;
                else
                    showwaferinspectionLink = FALSE;
                
                if(portaltabaccessObj.WIP_Status__c == TRUE)
                    showwipstatusLink= TRUE;
                else
                    showwipstatusLink= FALSE;
                    
                if(portaltabaccessObj.WLR_Monitoring_report__c== TRUE)
                    showWLRLink= TRUE;
                else
                    showWLRLink= FALSE;
                    
                if(portaltabaccessObj.Engineering_Lot_status_report__c== TRUE)
                    showenglotstatusLink = TRUE;
                else
                    showenglotstatusLink = FALSE;
                    
                if(portaltabaccessObj.ET_and_Inline_CPK_report__c== TRUE)
                    showcpkreportLink = TRUE;
                else
                    showcpkreportLink = FALSE;
                    
                if(portaltabaccessObj.Construction_Analysis_report__c== TRUE)
                    showanalysisreportLink= TRUE;
                else
                    showanalysisreportLink= FALSE;
                    
                if(portaltabaccessObj.Change_request_report__c== TRUE)
                    showCRLink= TRUE;
                else
                    showCRLink= FALSE;
                    
                if(portaltabaccessObj.Product_Wafer_Compliance_Analysis__c == TRUE)
                    showproductwaferLink= TRUE;
                else
                    showproductwaferLink= FALSE;
                    
               if(portaltabaccessObj.Electrical_Test__c== TRUE)
                    showelectrictestLink= TRUE;
                else
                    showelectrictestLink= FALSE;
                if(portaltabaccessObj.Module_Final_Test__c == TRUE)
                    showModuleFinaltest = TRUE;
                else
                    showModuleFinaltest = FALSE;
                if(portaltabaccessObj.Wafer_Sort_Test__c == TRUE)
                    showWaferSortTest = TRUE;
                else
                    showWaferSortTest = FALSE;
/*---------------added by cognizant for Case 25529 start-------------------------------------------------------*/              
               if(portaltabaccessObj.Inline_Measurement__c== TRUE)
                    showInlineMeasurementLink= TRUE;
                else
                    showInlineMeasurementLink= FALSE;
/*-----------added by cognizant for Case 25529 end----------------------------------------------------------*/                       
                                        
               if(portaltabaccessObj.CPK__c== TRUE)
                    showcpkLink= TRUE;
               else
                    showcpkLink= FALSE;
                    
               if(portaltabaccessObj.Yield_Sort_ETest_Reporting__c == TRUE)
                    showyieldsReportingLink= TRUE;
               else
                    showyieldsReportingLink= FALSE;
               
               if(portaltabaccessObj.Process_Technology__c == TRUE)
                    showprocesstechnologyLink = TRUE;
               else
                    showprocesstechnologyLink = FALSE;
                    
               if(portaltabaccessObj.PCRB__c == TRUE)
                    showpcrbLink = TRUE;
                else
                    showpcrbLink = FALSE;
                    
               if(portaltabaccessObj.Lot_Control_table__c == TRUE)
                    showlotcontroltableLink = TRUE;
               else
                    showlotcontroltableLink = FALSE;
                    
               if(portaltabaccessObj.IP_Declaration__c == TRUE)
                    showipdeclarationLink = TRUE;
               else
                    showipdeclarationLink = FALSE;
                
               if(portaltabaccessObj.Export_Control__c == TRUE)
                    showexportcontrolLink = TRUE;
               else
                    showexportcontrolLink = FALSE;
               
               // Added by ARoy on 05/20/2016 to add 'My Configurator' link     
               //*****************************************************//        
               if(portaltabaccessObj.Proposals__c == TRUE)      
                    showProposals = TRUE;       
               else     
                    showProposals = FALSE;  
               //*****************************************************//
               
               if(portaltabaccessObj.PTRF__c == TRUE)
                    showptrfLink = TRUE;
               else
                    showptrfLink = FALSE;
                    
               if(portaltabaccessObj.Web_View__c == TRUE)
                    showwebviewLink = TRUE;
               else
                    showwebviewLink = FALSE;
                    
               if(portaltabaccessObj.Global_Shuttle_reservation__c == TRUE)
                    showglobalshuttlerepresentLink = TRUE;
               else
                    showglobalshuttlerepresentLink = FALSE;
                    
               if(portaltabaccessObj.Stepper_Tooling_Form__c == TRUE)
                    showsteppertoolingformLink = TRUE;
               else
                    showsteppertoolingformLink = FALSE;
                    
               if(portaltabaccessObj.New_Part_Creation_after_Proto_form__c == TRUE)
                    shownewpartcreationLink = TRUE;
               else
                    shownewpartcreationLink = FALSE;
                    
               if(portaltabaccessObj.Process_Request_Form_PRF__c == TRUE)
                    showprocessrequestformLink = TRUE;
               else
                    showprocessrequestformLink = FALSE;
                    
               if(portaltabaccessObj.Risk_Waiver__c == TRUE)
                    showriskwaiverLink = TRUE;
               else
                    showriskwaiverLink = FALSE;
                    
                if(portaltabaccessObj.RTR_RTP__c == TRUE)
                    showrtrrtpLink = TRUE;
               else
                    showrtrrtpLink = FALSE;
                    
                if(portaltabaccessObj.Process_Reliability_Monitoring__c == TRUE)
                    showprocessreliabilityLink = TRUE;
               else
                    showprocessreliabilityLink = FALSE;
                    
                    
                 if(portaltabaccessObj.Reticle_Obsolescence__c == TRUE)
                    showreticleobsolescenceLink = TRUE;
               else
                    showreticleobsolescenceLink = FALSE;  
                    
                 if(portaltabaccessObj.MPW__c == TRUE)
                    showMPW = TRUE;
               else
                    showMPW = FALSE;
                    
         //---------- Start Of MDD Declaration----------------------------------------/
                 if(portaltabaccessObj.MDD_Parts__c == TRUE)
                    showPartSearchLink = TRUE;
               else
                    showPartSearchLink = FALSE;
                    
                 if(portaltabaccessObj.MDD_Parts__c == TRUE)
                    showReachLink = TRUE;
               else
                    showReachLink = FALSE;
                    
                  if(portaltabaccessObj.MDD_Parts__c == TRUE)
                    showChinaRohsLink = TRUE;
               else
                    showChinaRohsLink = FALSE;
                    
                  if(portaltabaccessObj.MDD_Parts__c == TRUE)
                    showEngineeringSpecLink = TRUE;
               else
                    showEngineeringSpecLink = FALSE;
                    
                  if(portaltabaccessObj.MDD_Parts__c == TRUE)
                    showMDD = TRUE;
               else
                    showMDD = FALSE;      
            //------------End Of MDD Declaration ------------------------------------------/   
                // Added By Abhita     
               if(portaltabaccessObj.Tapeout_Fab_9_10__c == TRUE)
                    showFab9n10Link = TRUE; //Modified by ARoy for FMS Link on 09072017
               else
                    showFab9n10Link = FALSE; //Modified by ARoy for FMS Link on 09072017
                
                /*   if(portaltabaccessObj.Quality_System__c == TRUE)
                    showQualityApp = TRUE;
               else
                    showQualityApp = FALSE;    */
                
              //--------EHS Declaration-----/
                if(portaltabaccessObj.Other_EHS_CSR_Disclosures__c){
                    showQualityApp = TRUE;
                    OtherEHS = TRUE;
                }                 
                else{
                    OtherEHS = FALSE;
                }
                    
                //--------BCM Declaration-----/
                
                If(portaltabaccessObj.BCM__c){
                    showQualityApp = TRUE;
                    BCM = TRUE; 
                }   
                else{
                    BCM = FALSE;
                }
                //--------Impact Declaration-----/
              If(portaltabaccessObj.ImpactNotify__c){
                   showQualityApp = TRUE;
                    ImptNotification = TRUE;
                }
               else{
                    ImptNotification = FALSE; 
                }
                if(!(portaltabaccessObj.ImpactNotify__c || portaltabaccessObj.BCM__c || portaltabaccessObj.Other_EHS_CSR_Disclosures__c || portaltabaccessObj.IP_Declaration__c))
                   showQualityApp = FALSE;
                   
                     // added by ramareddy for PCNEOL Declaration
                if(portaltabaccessObj.PCN_End_of_Life__c == TRUE)
                    showviewpcneol= True;
                else
                    showviewpcneol= FALSE;  
                    
                if(portaltabaccessObj.DropBox__c == TRUE)
                    showdropboxLink= TRUE;
                else
                    showdropboxLink= FALSE; 
          }
        }
       Page = '' ;
       OpenPageURL = '' ;
       //showmydeviceshomeLink = true;
       //Case-4331:Replacing Portal Login ID with Federation ID:Change-001
       //portalLoginUser = userObj.Portal_Login__c;
       if(userInfo.getusertype()=='CustomerSuccess' || userInfo.getusertype()=='PowerCustomerSuccess')
            portalLoginUser = userObj.Federationidentifier ;   
        else 
            portalLoginUser = null; 
       OpenTextLoginServerURL = System.Label.OTLoginServer+portalLoginUser;
       showwelcomesection = True;
       showdetailsection = False;
       respectiveLevel = System.Label.My_Device_Home;
       
       ipdeclareLink = System.Label.IP_Declaration_URL;
       exportcontrolLink = System.Label.Export_Control_URL;
       ptrfLink = System.Label.PTRF_URL;
       webviewLink = System.Label.Web_View_URL;
       
       /**********************code modified by cognizant on sept 20th *******************/
       globalshuttlerepresentLink = System.Label.Global_Shuttle_URL+EncodingUtil.urlEncode('PT-User-Name='+userObj.FederationIdentifier,'UTF-8');
       newpartcreationLink = System.Label.New_Part_Create_URL+EncodingUtil.urlEncode('PT-User-Name='+userObj.FederationIdentifier,'UTF-8');
       processrequestformLink = System.Label.Process_Request_URL+EncodingUtil.urlEncode('PT-User-Name='+userObj.FederationIdentifier,'UTF-8');
       /*************************End****************************************/
       
       processreliabilityLink = System.Label.Process_Reliability_URL;
       reticleobsolescenceLink = System.Label.Reticle_Obsolescence_URL;
       riskwaiverLink =  System.Label.Risk_Waiver_URL;
       rtrrtpLink =  System.Label.RTR_RTP_URL;
       analysisreportLink = System.Label.Analysis_Report_URL;
        
                /** Start of code for SwiftGen project **/
       
       // initialize
       isSwiftPage = false;
       
       /*************************MRS Permision Set *********************************/
       
       
       if(userObj.accountId != null)
       {
        System.debug(':::Enetr into customer:::'+userObj.accountId);
       try{
        Customer_Layer_Summary_Permission__c customerLayerSummaryPermission = [SELECT Customer__c,
                                                                                      Customer_Remote_Jobview__c,
                                                                                      Customer_Short_Name__c,
                                                                                      Frame_Mockup__c,
                                                                                      GDSOUT_Review__c,
                                                                                      MEBES_Jobview__c
                                                                               FROM Customer_Layer_Summary_Permission__c
                                                                               WHERE Customer__c =:userObj.accountId
                                                                               LIMIT 1];
        if(customerLayerSummaryPermission != null)
        {
         if(customerLayerSummaryPermission.Frame_Mockup__c)
         {
             showFrameMockupLink = true;
         }else if(!customerLayerSummaryPermission.Frame_Mockup__c)
         { 
              showFrameMockupLink = false;   
         }
         if(customerLayerSummaryPermission.GDSOUT_Review__c)
         {
             showGDSOUTReviewLink = true;
         }else if(!customerLayerSummaryPermission.GDSOUT_Review__c)
         {
             showGDSOUTReviewLink = false;
         }if(customerLayerSummaryPermission.MEBES_Jobview__c)
         {
            showMEBBESLink  =true;
         }else if(!customerLayerSummaryPermission.MEBES_Jobview__c)
         {
             showMEBBESLink  =false;
         }
         showSendData = false;
         showHoldAndResume = true;
         showFoundryFrameMockupLink = false;
         showFoundryGDSOUTReview = false;
         showFoundryMEBBESReviewLink = false;
         showTapeOutCenterReviewLink = false;
         showTapeOutApplicationReviewLink = false;
         showGlobalShuttleReviewLINK = false;
         showMDPReviewLink =false;
         showTDTIReviewLink =false;
         showHoldResumeLink =true;
        }
        }catch(Exception e){}
        
       }else
       {  
       System.debug('userObj.Id:' + userObj.Id);  
           List<GroupMember>  groupMemberlst = [Select Id,UserOrGroupId,GroupId FROM GroupMember WHERE UserOrGroupId =:userObj.Id];
           Map<Id,GroupMember> groupIdAndGroupMemberMap = new Map<Id,GroupMember>();
           if(groupMemberlst != null)
           {
             for(GroupMember groupObj : groupMemberlst  )
             {
                 groupIdAndGroupMemberMap.put(groupObj.GroupId,groupObj);
             }
           
           Map<String,MRS_Fields_Permission_Config__c> mrsFieldPermissionConfig  = MRS_Fields_Permission_Config__c.getAll();
           System.debug(':::::::mrsFieldPermissionConfig  ::'+mrsFieldPermissionConfig  );
           if(mrsFieldPermissionConfig != null )
           {
              List<String> lstTeamRoles = Environment_Variable__c.getInstance('SwiftFETeamRoles').Value__c.split(',');
              Profile profileObj =[SELECT Name, Id FROM Profile WHERE Id =:UserInfo.getProfileId()];
              system.debug('user:' + UserInfo.getProfileId());
              List<Account_Team_Proxy__c> accountTeamProxy = [SELECT Account__c,User__c FROM Account_Team_Proxy__c WHERE User__c =:UserInfo.getUserId() AND Team_Role__c IN :lstTeamRoles ];
             if(profileObj.Name=='System Administrator')
              {
              system.debug('System Administrator:');
                       showFrameMockupLink = true;
                       showGDSOUTReviewLink = true;
                       showMEBBESLink  = true;
                       showSendData = true;
                       showHoldAndResume = true;
                       showFoundryFrameMockupLink = true;
                       showFoundryGDSOUTReview = true;
                       showFoundryMEBBESReviewLink = true;
                       showTapeOutCenterReviewLink = true;
                       
                       //swgp-859: SWIFT CHANGED
                       //affected: Tapeout Application Mebes Jobview under MRS menu
                       //showTapeOutApplicationReviewLink = true;
                       showTapeOutApplicationReviewLink = false;
                       
                       showGlobalShuttleReviewLINK = true;
                       showMDPReviewLink =true;
                       showTDTIReviewLink =true;
                       showPrimeSendData = true;
                       showFrameSendData = true;
                       showHoldResumeLink =true;
               }
               else if (groupIdAndGroupMemberMap != null && groupIdAndGroupMemberMap.size()>0)
               {
                   List<Group> grouplst =[Select Id,Name,DeveloperName from Group where Id =:groupIdAndGroupMemberMap.keySet() AND DeveloperName IN:mrsFieldPermissionConfig.keySet() ];
                   Map<String,Group> groupNameMap = new Map<String,Group>();
                   
                   if(grouplst !=null && grouplst.size() > 0)
                   {
                       for(Group groupObj : grouplst )
                       {
                           groupNameMap.put(groupObj.DeveloperName,groupObj);
                       }
                   
                       if(groupNameMap!= null && groupNameMap.size()>0)
                       {
                          
                           for(String groupName : groupNameMap.keySet())
                           {
                                if(groupName.equalsIgnoreCase('SWIFT_Admin'))
                                {
                                    groupName ='SWIFT_Admin';
                                }
                              
                                 if(mrsFieldPermissionConfig.get(groupName) != null)
                                 {
                                   if(mrsFieldPermissionConfig.get(groupName).FrameMockupCustomer__c== true)
                                   {
                                      showFrameMockupLink = true; 
                                   }
                                
                                   if(mrsFieldPermissionConfig.get(groupName).FrameMockupFoundry__c== true)
                                   {
                                       showFoundryFrameMockupLink = true;
                                   }
                               
                                   if(mrsFieldPermissionConfig.get(groupName).GDSOUTReviewCustomer__c == true)
                                   {
                                       showGDSOUTReviewLink = true;
                                   }
                               
                                   if(mrsFieldPermissionConfig.get(groupName).GDSOUTReviewFoundry__c == true)
                                   {
                                       showFoundryGDSOUTReview = true;
                                   }
                               
                                   if(mrsFieldPermissionConfig.get(groupName).MEBESJobviewCustomer__c == true)
                                   {
                                       showMEBBESLink  = true;
                                   }
                              
                                   if(mrsFieldPermissionConfig.get(groupName).MEBESJobviewFoundry__c == true)
                                   {
                                       showFoundryMEBBESReviewLink = true;
                                   }
                               
                                   if(mrsFieldPermissionConfig.get(groupName).MEBESJobviewGlobalShuttle__c == true)
                                   {
                                       showGlobalShuttleReviewLINK = true;
                                   }
                               
                                   if(mrsFieldPermissionConfig.get(groupName).MEBESJobviewMDP__c == true)
                                   {
                                       showMDPReviewLink = true;
                                   }
                                
                                    //swgp-859: SWIFT CHANGED
                                    //affected: Tapeout Application Mebes Jobview under MRS menu
                                    showTapeOutApplicationReviewLink = false;
                                   //if(mrsFieldPermissionConfig.get(groupName).MEBESJobviewTapeoutAPPLICATIONS__c == true)

                                   //{
                                   //    showTapeOutApplicationReviewLink =true;

                                   //}
                               
                                   if(mrsFieldPermissionConfig.get(groupName).MEBESJobviewTapeoutCenter__c == true)
                                   {
                                       showTapeOutCenterReviewLink = true;
                                   }
                              
                                   if(mrsFieldPermissionConfig.get(groupName).MEBESJobviewTDTIMPW__c == true)
                                   {
                                       showTDTIReviewLink = true;
                                   }
                               
                                  if(mrsFieldPermissionConfig.get(groupName).SendDataFrame__c == true)
                                  {
                                  system.debug('admin:');
                                      showSendData = true;
                                      showFrameSendData  = true;
                                  }
                               
                                 if(mrsFieldPermissionConfig.get(groupName).SendDataPrime__c == true)
                                 {
                                  system.debug('admin:');
                                      showSendData = true;
                                      showPrimeSendData  = true;
                                 }
                              
                              }
                         }
                       }
                 }if(accountTeamProxy != null && accountTeamProxy.size()>0){
                     Map<String,MRS_Fields_Permission_Config__c> swiftFEMap = MRS_Fields_Permission_Config__c.getAll();
                   if(swiftFEMap.get('SWIFT_FE').FrameMockupCustomer__c){
                       showFrameMockupLink = true;
                   }
                   if(swiftFEMap.get('SWIFT_FE').FrameMockupFoundry__c){
                       showFoundryFrameMockupLink = true;
                   }
                   if(swiftFEMap.get('SWIFT_FE').GDSOUTReviewCustomer__c){
                       showGDSOUTReviewLink = true;
                   }
                   if(swiftFEMap.get('SWIFT_FE').GDSOUTReviewFoundry__c){
                       showFoundryGDSOUTReview = true;
                   }
                   if(swiftFEMap.get('SWIFT_FE').SendDataPrime__c){
                       showSendData = true;
                       showPrimeSendData = true;
                   }
                   if(swiftFEMap.get('SWIFT_FE').SendDataFrame__c){
                       showSendData = true;
                       showFrameSendData = true;
                   } 
                   if(swiftFEMap.get('SWIFT_FE').MEBESJobviewCustomer__c){
                       showMEBBESLink  = true;
                   }
                   if(swiftFEMap.get('SWIFT_FE').MEBESJobviewFoundry__c){
                        showFoundryMEBBESReviewLink = true;
                   }
                   if(swiftFEMap.get('SWIFT_FE').MEBESJobviewGlobalShuttle__c){
                          showGlobalShuttleReviewLINK = true;
                   }
                    if(swiftFEMap.get('SWIFT_FE').MEBESJobviewMDP__c){
                          showMDPReviewLink =true;
                   }



                   
                   //swgp-859: SWIFT CHANGED
                   //affected: Tapeout Application Mebes Jobview under MRS menu
                   showTapeOutApplicationReviewLink = false;
                   //if(swiftFEMap.get('SWIFT_FE').MEBESJobviewTapeoutAPPLICATIONS__c){
                   //       showTapeOutApplicationReviewLink = true;
                   //}
                   
                   if(swiftFEMap.get('SWIFT_FE').MEBESJobviewTapeoutCenter__c){
                          showTapeOutCenterReviewLink = true;
                   }
                   if(swiftFEMap.get('SWIFT_FE').MEBESJobviewTDTIMPW__c){
                           showTDTIReviewLink =true;
                   }     
                 }else{
                      showFrameMockupLink = true;
                       showGDSOUTReviewLink = true;
                       showMEBBESLink  = true;
                       showSendData = false;
                       showHoldAndResume = true;
                       showFoundryFrameMockupLink = true;
                       showFoundryGDSOUTReview = true;
                       showFoundryMEBBESReviewLink = true;
                       showTapeOutCenterReviewLink = true;
                       
                       //swgp-859: SWIFT CHANGED
                       //affected: Tapeout Application Mebes Jobview under MRS menu
                       showTapeOutApplicationReviewLink = false;
                       
                       showGlobalShuttleReviewLINK = true;
                       showMDPReviewLink =true;
                       showTDTIReviewLink =true;
                       showPrimeSendData = true;
                       showFrameSendData = true;
                       showHoldResumeLink =true;
               }
                 showHoldResumeLink =true;
               }
               else if(accountTeamProxy != null && accountTeamProxy.size()>0)
               {
              /* system.debug('FE:');
                       showFrameMockupLink = true;
                       showGDSOUTReviewLink = true;
                       showMEBBESLink  = true;
                       showSendData = false;
                       showHoldAndResume = true;
                       showFoundryFrameMockupLink = true;
                       showFoundryGDSOUTReview = true;
                       showFoundryMEBBESReviewLink = true;
                       showTapeOutCenterReviewLink = true;
                       showTapeOutApplicationReviewLink = true;
                       showGlobalShuttleReviewLINK = true;
                       showMDPReviewLink =true;
                       showTDTIReviewLink =true;
                       showPrimeSendData = false;
                       showFrameSendData = false;
                       showHoldResumeLink =true;*/
                       Map<String,MRS_Fields_Permission_Config__c> swiftFEMap = MRS_Fields_Permission_Config__c.getAll();
                   if(swiftFEMap.get('SWIFT_FE').FrameMockupCustomer__c){
                       showFrameMockupLink = true;
                   }
                   if(swiftFEMap.get('SWIFT_FE').FrameMockupFoundry__c){
                       showFoundryFrameMockupLink = true;
                   }
                   if(swiftFEMap.get('SWIFT_FE').GDSOUTReviewCustomer__c){
                       showGDSOUTReviewLink = true;
                   }
                   if(swiftFEMap.get('SWIFT_FE').GDSOUTReviewFoundry__c){
                       showFoundryGDSOUTReview = true;
                   }
                   if(swiftFEMap.get('SWIFT_FE').SendDataPrime__c){
                       showSendData = true;
                       showPrimeSendData = true;
                   }
                   if(swiftFEMap.get('SWIFT_FE').SendDataFrame__c){
                       showSendData = true;
                       showFrameSendData = true;
                   } 
                   if(swiftFEMap.get('SWIFT_FE').MEBESJobviewCustomer__c){
                       showMEBBESLink  = true;
                   }
                   if(swiftFEMap.get('SWIFT_FE').MEBESJobviewFoundry__c){
                        showFoundryMEBBESReviewLink = true;
                   }
                   if(swiftFEMap.get('SWIFT_FE').MEBESJobviewGlobalShuttle__c){
                          showGlobalShuttleReviewLINK = true;
                   }
                    if(swiftFEMap.get('SWIFT_FE').MEBESJobviewMDP__c){
                          showMDPReviewLink =true;
                   }
                   
                   //swgp-859: SWIFT CHANGED
                   //affected: Tapeout Application Mebes Jobview under MRS menu
                   showTapeOutApplicationReviewLink = false;
                   //if(swiftFEMap.get('SWIFT_FE').MEBESJobviewTapeoutAPPLICATIONS__c){
                   //       showTapeOutApplicationReviewLink = true;

                   //}
                   
                   if(swiftFEMap.get('SWIFT_FE').MEBESJobviewTapeoutCenter__c){
                          showTapeOutCenterReviewLink = true;
                   }
                   if(swiftFEMap.get('SWIFT_FE').MEBESJobviewTDTIMPW__c){
                           showTDTIReviewLink =true;
                   }  
                   showHoldResumeLink = true;   
               }else{
                      showFrameMockupLink = true;
                       showGDSOUTReviewLink = true;
                       showMEBBESLink  = true;
                       showSendData = false;
                       showHoldAndResume = true;
                       showFoundryFrameMockupLink = true;
                       showFoundryGDSOUTReview = true;
                       showFoundryMEBBESReviewLink = true;
                       showTapeOutCenterReviewLink = true;
                       
                       //swgp-859: SWIFT CHANGED
                       //affected: Tapeout Application Mebes Jobview under MRS menu
                       showTapeOutApplicationReviewLink = false;
                       //showTapeOutApplicationReviewLink = true;
                       
                       showGlobalShuttleReviewLINK = true;
                       showMDPReviewLink =true;
                       showTDTIReviewLink =true;
                       showPrimeSendData = true;
                       showFrameSendData = true;
                       showHoldResumeLink =true;
               }
           }
         }
       }
       
       //MRSHandlerUtility.rememberedCustomer = null;
      // MRSHandlerUtility.rememberedMST = null;
       
       
       
       /************************End of Permission Set ****************************/
        
       showCreateDRTLink =true;
       showCreateDRTLink = drthandlerutility.isCreateDRTApplicable(); 
       
       showSearchDRTLink =true;
       showSearchDRTLink = drthandlerutility.isViewDRTApplicable(); 
       
       showDRTLink=true;
       if(showCreateDRTLink ==false && showSearchDRTLink ==false) showDRTLink=false;
       account = new Cookie('account',null,null,0,false);
       ApexPages.currentPage().setCookies(new Cookie[]{account});
       mst = new Cookie('mst',null,null,0,false);
       ApexPages.currentPage().setCookies(new Cookie[]{mst});
    }
    
    /** End of code for SwiftGen project **/    
    
    /**
        This method is used to redirect the new web page according to the links are specified .
        
        @method name: redirect
        @return : returns the new web site according to the links
         
     */
     
    public PageReference redirect()
    {
        /** Start of code for SwiftGen project **/
        isSwiftPage = false; // initialize to false
        isSwiftMRSPage =false;
        
        /** SET THE COOKIE **/
        if(parameter != null && parameter.trim() != ''){
                String customer = parameter.substringBetween('Customer=','&');
                String mstName = parameter.substringBetween('&mst=','&');
                if(customer != null){
                    account = new Cookie('account',customer.trim(),null,-1,false);
                    ApexPages.currentPage().setCookies(new Cookie[]{account});
                    if(mstName  == null){
                      mstName   =parameter.substringAfterLast('&mst=');
                    }
                    mst = new Cookie('mst',mstName,null,-1,false);
                    ApexPages.currentPage().setCookies(new Cookie[]{mst});
                }
                
            }
        /**                **/      
                /** End of code for SwiftGen project **/                
                if(Page == 'ExportControlList'){
            showwelcomesection = False;
            showdetailsection = True;
            showpageBlock= True;
            showmydeviceshomeLink = False;
            respectiveLevel = System.Label.Export_Control_Form;
            OpenPageURL = System.Label.Export_Control_URL;
        }
        
        if(Page == 'IPDeclarationList'){
            showwelcomesection = False;
            showdetailsection = True;
            showpageBlock= True;
            showmydeviceshomeLink = False;
            respectiveLevel = System.Label.IP_Declaration_Form;
            OpenPageURL = System.Label.IP_Declaration_URL;      
        }
        //Anil Kumar Reddy L  Added logic for Fab9/10 devices Start 
        if(Page == 'FMSFAB_9_10_DevicesPage'){
            showwelcomesection = False;
            showdetailsection = True;
            showpageBlock= True;
            showmydeviceshomeLink = False;
            respectiveLevel = 'View Devices';
            OpenPageURL = System.Label.FMSviewDevices;      
        }
       //Anil Kumar Reddy L  Added logic for Fab9/10 devices End
       
        // Added by ARoy on 05/20/2016 to add 'My Configurator' link        
        //*****************************************************//       
                
        if(Page == 'Proposals')     
        {       
           showwelcomesection = False;      
           showdetailsection = True;        
           showpageBlock= True;     
           showmydeviceshomeLink = False;       
           respectiveLevel = System.Label.Proposals;        
           OpenPageURL = System.Label.Proposal_URL ;        
        }   
                
        //*****************************************************//
        if(Page == 'FMSRepoistoryDocuments'){
            showwelcomesection = False;
            showdetailsection = true;
            showpageBlock= true;
            showmydeviceshomeLink = False;
            respectiveLevel = 'FMS Repository';//Changed the Label by Abhita for UAT Issue #166
            OpenPageURL = System.Label.FMSRepoistoryDocuments;      
        }
    
        if(Page == 'DesignWaiverCollaboratorList'){
            showwelcomesection = False;
            showdetailsection = True;
            showpageBlock= True;
            showmydeviceshomeLink = False;
            respectiveLevel ='Design Waiver Collaborator';
            //Schema.DescribeSObjectResult result = Wavier_Collaborator__c.SObjectType.getDescribe(); 
            //OpenPageURL = result.getKeyPrefix()+'/o';
            OpenPageURL='WaiverCollaborator4Customer';
        }
        
        if(Page == 'FormManagementSystemPage'){
            showwelcomesection = False;
            showdetailsection = True;
            showpageBlock= True;
            showmydeviceshomeLink = False;
            respectiveLevel ='Form Management System';
            //Schema.DescribeSObjectResult result = Wavier_Collaborator__c.SObjectType.getDescribe(); 
            //OpenPageURL = result.getKeyPrefix()+'/o';
            OpenPageURL='FormManagementMainPage';
        }
        
        //------------------Start Of MDD Declaration Logic------------------------------/
        
        if(Page == 'MDDPartSearch'){
            showwelcomesection = False;
            showdetailsection = True;
            showpageBlock= True;
            showmydeviceshomeLink = False;
            respectiveLevel ='Material Content Declaration';
            OpenPageURL='MDD_Login_Page';
        }
        
        if(Page == 'ReachDeclatarion'){
            showwelcomesection = False;
            showdetailsection = True;
            showpageBlock= True;
            showmydeviceshomeLink = False;
            respectiveLevel ='REACH';
            OpenPageURL='MDD_Reach';
        }
        
        if(Page == 'ChinaROHS_Declaration'){
            showwelcomesection = False;
            showdetailsection = True;
            showpageBlock= True;
            showmydeviceshomeLink = False;
            respectiveLevel ='CHINA RoHS';
            OpenPageURL='MDD_ChinaRohs';
        }


        if(Page == 'EngineeringSpec') {
            List<Part_Family__c> lst_engSpecs = [Select Id,Name from Part_Family__c where Name = 'Engineering Specs' limit 1];
            showwelcomesection = False;
            showdetailsection = True;
            showpageBlock= True;
            showmydeviceshomeLink = False;
            respectiveLevel ='Engineering Specs';
            if(lst_engSpecs.size() > 0)
               OpenPageURL= URL.getSalesforceBaseUrl().toExternalForm()+'/GlobalfoundryView/apex/MDD_EngineeringSpecsPg?id='+lst_engSpecs[0].Id;
            else
                OpenPageURL= URL.getSalesforceBaseUrl().toExternalForm()+'/GlobalfoundryView/apex/MDD_EngineeringSpecsPg';
        }
        
        //------------------End Of MDD Declaration Logic------------------------------/
        
        if(Page == 'SFFGeneration'){
            showwelcomesection = False;
            showdetailsection = True;
            showpageBlock= True;
            showmydeviceshomeLink = False;
            respectiveLevel = System.Label.SFFG_Label;
            OpenPageURL = System.Label.SFFG_URL;      
        }
        if(Page == 'NewPartCreationForm') {
            showwelcomesection = False;
            showdetailsection = True;
            showpageBlock= True;
            showmydeviceshomeLink = False;
            respectiveLevel = System.Label.New_Part_Creation_Form;
            OpenPageURL = System.Label.New_Part_Create_URL + '?userId=' + UserInfo.getUserId();
        }
        
        // ZAmbat 05072015---Start
        if(Page == 'myMPWDevices') {
            respectiveLevel = System.Label.MPW;
            respectivesubLevel = System.Label.MPW;
            showpageBlock= True;
            showwelcomesection = false; 
            showdetailsection = True;     
            OpenPageURL = System.Label.MPW_My_Devices+'?accountId='+userObj.Contact.AccountId;
        }
    
    /** Start: Added By Anil - JKT : June 16, 2016 **/
        if(Page == 'myMPWWIP') {
            respectiveLevel = System.Label.MPW;
            respectivesubLevel = System.Label.MPW;
            showpageBlock= True;
            showwelcomesection = false; 
            showdetailsection = True;     
            OpenPageURL = 'MPWCustomerWIP?accountId='+userObj.Contact.AccountId;
        }
        /** End: Added By Anil - JKT : June 16, 2016 **/
        
        if(Page == 'viewMPWSchedule') {
            respectiveLevel = System.Label.MPW;
            respectivesubLevel = System.Label.MPW;
            showpageBlock= True;
            showwelcomesection = false; 
            showdetailsection = True;     
            OpenPageURL = System.Label.MPW_View_Schedule_Tab_URL + '&userId=' + UserInfo.getUserId();
        }
        
        if(Page == 'searchMPW'){
            respectiveLevel = System.Label.MPW;
            respectivesubLevel = System.Label.MPW;
            showpageBlock= True;
            showwelcomesection = false; 
            showdetailsection = True;     
            OpenPageURL = System.Label.MPW_Search_Schedule_URL + '?userId=' + UserInfo.getUserId(); 
        }
        
        if(Page == 'userGuide'){
            respectiveLevel = System.Label.MPW;
            respectivesubLevel = System.Label.MPW;
            showpageBlock= True;
            showwelcomesection = false; 
            showdetailsection = True;     
            OpenPageURL = System.Label.MPW_User_Guide_ViewPage_URL; 
        }
        // ZAmbat 05072015---End
        
        if(Page == 'mydeviceshome')
        {
            respectiveLevel = System.Label.My_Device_Home;
            showpageBlock= False;
            showwelcomesection = True;
            showdetailsection = False;
            
        }
        if(Page == 'electricaltest')
        
        {
            showwelcomesection = False;
            showdetailsection = True;
            showpageBlock= True;
            showmydeviceshomeLink = False;
            respectiveLevel = System.Label.Electrical_Test;
            OpenPageURL = System.Label.Electrical_Test_URL+'&username='+portalLoginUser;
        }
        
        //------Added by Ashish -----//
        if(Page == 'ModuleFinalTest')
        
        {
            showwelcomesection = False;
            showdetailsection = True;
            showpageBlock= True;
            showmydeviceshomeLink = False;
            respectiveLevel = System.Label.Module_Final_Test;
            OpenPageURL = System.Label.Module_Final_Test_URL+'&username='+portalLoginUser;
        }
        
        if(Page == 'WaferSortTest')
        
        {
            showwelcomesection = False;
            showdetailsection = True;
            showpageBlock= True;
            showmydeviceshomeLink = False;
            respectiveLevel = System.Label.Wafer_Sort_Test;
            OpenPageURL = System.Label.Wafer_Sort_Test_URL+'&username='+portalLoginUser;
        }
/*--------added by cognizant for Case 25529 start---------------------------------------------------------------*/       
        if(Page == 'InlineMeasurement')
        
        {
            showwelcomesection = False;
            showdetailsection = True;
            showpageBlock= True;
            showmydeviceshomeLink = False;
            respectiveLevel = System.Label.Inline_Measurement;
            OpenPageURL = System.Label.Inline_Measurement_URL+'&username='+portalLoginUser;
        }
/*-------added by cognizant for Case 25529 end---------------------------------------------------------------*/            
                
        if(Page == 'waferinspection')
        {
            showwelcomesection = False;
            showdetailsection = True;
            showpageBlock= True;
            showmydeviceshomeLink = False;
            respectiveLevel = System.Label.Wafer_Inspection;
            OpenPageURL = System.Label.Wafer_Inspection_URL+'&username='+portalLoginUser;
        }
        if(Page == 'yieldreporting')
        {
            showwelcomesection = False;
            showdetailsection = True;
            showpageBlock= True;
            showmydeviceshomeLink = False;
            respectiveLevel = System.Label.Yield_Reporting;
            OpenPageURL = System.Label.Yield_Reporting_URL+'&username='+portalLoginUser;
        }
        if(Page == 'cpk')
        {
            showwelcomesection = False;
            showdetailsection = True;
            showpageBlock= True;
            showmydeviceshomeLink = False;
            respectiveLevel = System.Label.CPK;
            //OpenPageURL = System.Label.CPK_URL; // Added on 18th Nov regarding to CPK URL modification to View in FV
            system.debug('getUserShortName()>>>>>>>>>>>>>>>>'+getUserShortName());
            //pageReference pRef = new pageReference();
            //Case-4383:Change-001:Adding sorting parameter
            OpenPageURL = System.Label.CPK_URL; //+'&username='+getUserShortName()+System.label.OpenTextSortParam;
            system.debug('OpenPageURL>>>>>>>>>>>>'+OpenPageURL);
        }
        if(Page == 'QC')
        {
            showwelcomesection = False;
            showdetailsection = True;
            showpageBlock= True;
            showmydeviceshomeLink = False;
            respectiveLevel = System.Label.QC;
            OpenPageURL = System.Label.QC_URL+'?username='+getUserShortName(); // Added on 18th Nov regarding to QC URL modification to View in FV         
        
           
       }
//--------------- Start of EHS/CSR Disclosures ----------------------//
       if(Page == 'productwafer')
        {
            showwelcomesection = False;
            showdetailsection = True;
            showpageBlock= True;
            showmydeviceshomeLink = False;
            respectiveLevel = System.Label.Product_Wafer_Compliance;
            OpenPageURL = System.Label.Product_Wafer_Compliance_URL;
        }
        if(Page == 'ISOCertification')
        {
            showwelcomesection = False;
            showdetailsection = True;
            showpageBlock= True;
            showmydeviceshomeLink = False;
            respectiveLevel = 'ISO/Others Certificates';
            OpenPageURL = 'vfQualityCertificationOnFV';
        }
        if(Page == 'EHSDisclosures')
        {    
            Id IMRecordTypeId = Schema.SObjectType.Other_EHS_CSR_Certificate__c.getRecordTypeInfosByName().get('Other EHS CSR Approved').getRecordTypeId();
            system.debug('IMRecordTypeId&&'+IMRecordTypeId );
            showfieldsforEHS = true;

            showwelcomesection = False;
            showdetailsection = True;
            showpageBlock= True;
            showmydeviceshomeLink = False;
            respectiveLevel = 'EHS/CSR Disclosures';
            OpenPageURL = 'vfEHSQualityCertificationOnFV?RecordType='+IMRecordTypeId;
              system.debug('OpenPageURL&&'+OpenPageURL );
            
        }
        if(Page == 'ImpactNotification')
        {
           Id IMRecordTypeId = Schema.SObjectType.Other_EHS_CSR_Certificate__c.getRecordTypeInfosByName().get('Impact Notification Approved').getRecordTypeId();
            system.debug('IMRecordTypeId&&'+IMRecordTypeId ); 
            showfieldsforImpact = true;
            showwelcomesection = False;
            showdetailsection = True;           
            showpageBlock= True;
            showmydeviceshomeLink = False;
            respectiveLevel = 'Impact Notifications';
              OpenPageURL = 'vfEHSQualityCertificationOnFV?RecordType='+IMRecordTypeId;
              system.debug('OpenPageURL&&'+OpenPageURL );

        }
        if(Page == 'BCManagement')
        {
           Id IMRecordTypeId = Schema.SObjectType.Other_EHS_CSR_Certificate__c.getRecordTypeInfosByName().get('Business Continuity Mgmt Approved').getRecordTypeId();
            system.debug('IMRecordTypeId&&'+IMRecordTypeId );
            showfieldsforBCM = true;
            showwelcomesection = False;
            showdetailsection = True;
            showpageBlock= True;
            showmydeviceshomeLink = False;
            respectiveLevel = 'Business Continuity Management';
               OpenPageURL = 'vfEHSQualityCertificationOnFV?RecordType='+IMRecordTypeId;
              system.debug('OpenPageURL&&'+OpenPageURL );
        }
        //--------------- End of EHS/CSR Disclosures ----------------------//
       
       //---------------Start of PCNEOL----------------//      
        
          if(Page == 'ViewAllEOLPCNs'){
          
           //showFrame = True;
           //showsubpanelLabel = False;
           //showProcedureSection = False;
           //showServiceSection  = False;
           respectiveLevel = System.Label.ViewAllEOLPCNs;
           //respectivesubLevel =System.Label.ViewAllPCNEOL;           
           showpageBlock= True;
           showwelcomesection = False;
           showdetailsection = True;
           OpenPageURL = System.Label.ViewAllPCNEOL_URL ;
            system.debug('url^^^^^'+OpenPageURL);
          
        }
        //---------------End of PCNEOL----------------// 
        
       
       
        if(Page == 'wipstat')
        {
            showdetailsection = True;
            showwelcomesection = False;
            showpageBlock= True;
            showmydeviceshomeLink = False;
            respectiveLevel = System.Label.WIP_Status;
            OpenPageURL = System.Label.WIP_Status_URL+'&username='+portalLoginUser;
        }
        if(Page == 'lotcontrol')
        {
            showwelcomesection = False;
            showdetailsection = True;
            showpageBlock= True;
            showmydeviceshomeLink = False;
            respectiveLevel = System.Label.Lot_Control_Table;
            OpenPageURL = System.Label.Lot_Control_Table_URL+'&username='+portalLoginUser;
        }
        if(Page == 'processtech')
        {
            showwelcomesection = False;
            showdetailsection = True;
            showpageBlock= True;
            showmydeviceshomeLink = False;
            respectiveLevel = System.Label.Process_Technology;
            OpenPageURL = System.Label.Process_Technology_URL;
        }
        if(Page == 'pcrb')
        {
            showwelcomesection = False;
            showdetailsection = True;
            showpageBlock= True;
            showmydeviceshomeLink = False;
            respectiveLevel = System.Label.PCRB;
            OpenPageURL = System.Label.PCRB_URL+'PT-User-Name='+getUserShortName(); //Line updated by Sunil Arora for case # 40696
        }
        if(Page == 'WLR')
        {
            showwelcomesection = False;
            showdetailsection = True;
            showpageBlock= True;
            showmydeviceshomeLink = False;
            respectiveLevel = System.Label.WLR;
            OpenPageURL = System.Label.WLR_URL;
        }
        if(Page == 'cpkreport')
        {
            showwelcomesection = False;
            showdetailsection = True;
            showpageBlock= True;
            showmydeviceshomeLink = False;
            respectiveLevel = System.Label.CPK_Report;
            OpenPageURL = System.Label.CPK_Report_URL;
        }
        if(Page == 'analysisreport')
        {
            showwelcomesection = False;
            showdetailsection = True;
            showpageBlock= True;
            showmydeviceshomeLink = False;
            respectiveLevel = System.Label.Analysis_Report;
            OpenPageURL = System.Label.Analysis_Report_URL;
        }
        if(Page == 'lotstatusreport')
        {
            showwelcomesection = False;
            showdetailsection = True;
            showpageBlock= True;
            showmydeviceshomeLink = False;
            respectiveLevel = System.Label.Lot_Status_Report;
            OpenPageURL = System.Label.Lot_Status_Report_URL;
        }
        if(Page == 'MyDeviceRequirementList')
        {
            showwelcomesection = False;
            showdetailsection = True;
            showpageBlock= True;
            showmydeviceshomeLink = False;
            respectiveLevel = System.Label.CR;
            OpenPageURL = System.Label.CR_URL;
        }
        if(Page == 'steppertoolingform')
        {
            showwelcomesection = False;
            showdetailsection = True;
            showpageBlock= True;
            showmydeviceshomeLink = False;
            respectiveLevel = System.Label.Stepper_ToolingForm_Label;
            OpenPageURL = System.Label.Stepper_ToolingForm_URL+'&username='+portalLoginUser;
            
        }
// Modified by CTS for Global Shutter Mashup (Date :- 11/11/2013)
        //Commented as advised by Business user -devendra 21/11/2015
        /*if (Page=='globalShuttleRepresent'){
            showwelcomesection = False;
            showdetailsection = True;
            showpageBlock= True;
            showmydeviceshomeLink = False;
            respectiveLevel = System.Label.GlobalShuttleFormLabel;
            OpenPageURL = System.Label.MPW_URL+'PT-User-Name='+getUserShortName();

        }*/
        // Modified by CTS for Global Shutter Mashup (Date :- 11/11/2013)
        if (Page=='processRequest'){
            showwelcomesection = False;
            showdetailsection = True;
            showpageBlock= True;
            showmydeviceshomeLink = False;
            respectiveLevel = System.Label.processFormRequestLabel;
            OpenPageURL = System.Label.processRequestUrl+'PT-User-Name='+getUserShortNamePRF(); //Line updated by Sunil Arora for case # 40399
            //OpenPageURL= 'https://www.global-foundryview.com/eprf/eprf/LoginPage.jsp?'+'PT-User-Name='+'linlin';
        }
                // Modified by CTS for Reticle Obsolescence System (Date : 12-Aug-14)

        //Added by Dinesh on 30/3 for DropBox Link
        system.debug('**Entering into DropBox***');
        if (Page=='DropBox'){
            DropBox__c  dp=DropBox__c.getValues('Dropbox');
            String dropbox1 = dp.DropBox__c;
            String dropbox2=  dp.DropBox_ExternalURL__c;
            String dropbox3=  dp.DropBox_InternalURL__c;                                                                                 
            showwelcomesection = False;
            showdetailsection = True;
            showpageBlock= True;
            showmydeviceshomeLink = False;
            respectiveLevel = dropbox1;
            If(Isportal){           
            OpenPageURL = dropbox2;
            }
            else{
            OpenPageURL = dropbox3;
            }  
            
        }
        //Ends DropBox Code
        
        if(Page == 'reticleobsolescence'){
            showwelcomesection = False;
            showdetailsection = True;
            showpageBlock= True;
            showmydeviceshomeLink = False;
            respectiveLevel = System.Label.My_Reticles_Label;
            OpenPageURL = System.Label.Reticle_Obsolescence_URL;
        }
                
                       /** Start of code for SwiftGen project **/
        // Modified by CTS for GF-SwiftGen development purpose Starts
        if(Page == 'CreateDRT')
        {
            isSwiftPage = true;
            showwelcomesection = False;
            showdetailsection = true;
            showpageBlock= true;
            showmydeviceshomeLink = False;
            respectiveLevel = 'Device Revision Table';
            OpenPageURL = System.Label.SWIFT_Community_URL + 'VFDRTCreate';
            
        }
        if(Page == 'SearchDRT')
        {
            isSwiftPage = true;
            showwelcomesection = False;
            showdetailsection = true;
            showpageBlock= true;
            showmydeviceshomeLink = False;
            respectiveLevel = 'Device Revision Table';
            OpenPageURL = System.Label.SWIFT_Community_URL + 'VFDRTSearch';
            if(!String.isBlank(iframeParam)) {
                OpenPageURL += '?'+iframeParam;
            }
        }
        if(Page == 'DetailDRT')
        {
            isSwiftPage = true;
            showwelcomesection = False;
            showdetailsection = true;
            showpageBlock= true;
            showmydeviceshomeLink = False;
            respectiveLevel = 'Device Revision Table';
            if(internalView) {
                OpenPageURL = System.Label.Internal_URL+ 'VFDRTDetail';
            }
            else {
                OpenPageURL = System.Label.SWIFT_Community_URL + 'VFDRTDetail';
            }
            if(!String.isBlank(iframeParam)) {
                OpenPageURL += '?'+iframeParam;
            }
        }
        
        if(Page == 'LayerSummaryPage')
        {
            
            isSwiftMRSPage =true;
            isSwiftPage = false;
            showwelcomesection = False;
            showdetailsection = true;
            showpageBlock= true;
            showmydeviceshomeLink = False;
            respectiveLevel = 'Mask Release System';
            OpenPageURL = System.Label.SWIFT_Community_URL + 'VFMRSLayerSummary';
            if(!String.isBlank(iframeParam)) {
                OpenPageURL += '?'+iframeParam;
            }
        }
        if(Page == 'GDSOUTReviewCustomer')
        {
            isSwiftMRSPage =true;
            isSwiftPage =false;
            showwelcomesection = False;
            showdetailsection = true;
            showpageBlock= true;
            showmydeviceshomeLink = False;
            respectiveLevel = 'Mask Release System';
            OpenPageURL = System.Label.SWIFT_Community_URL + 'VFMRSGDSOUTReview?type=Customer';
        }
        if(Page == 'GDSOUTReviewFoundry')
        {
            isSwiftMRSPage =true;
            isSwiftPage =false;
            showwelcomesection = False;
            showdetailsection = true;
            showpageBlock= true;
            showmydeviceshomeLink = False;
            respectiveLevel = 'Mask Release System';
            OpenPageURL = System.Label.SWIFT_Community_URL + 'VFMRSGDSOUTReview?type=Foundry';
        }
        if(Page == 'FrameMockupReviewCustomer')
        {
            isSwiftMRSPage =true;
            isSwiftPage =false;
            //isSwiftPage = true;
            showwelcomesection = False;
            showdetailsection = true;
            showpageBlock= true;
            showmydeviceshomeLink = False;
            respectiveLevel = 'Mask Release System';
            //OpenPageURL = System.Label.SWIFT_Community_URL + 'VFMRSCustomerFrameMockupReview';
            OpenPageURL = System.Label.SWIFT_Community_URL + 'VFMRSFrameMockupReview?type=Customer';
        }
        if(Page == 'FrameMockupReviewFoundry')
        {
            isSwiftMRSPage =true;
            isSwiftPage =false;
            //isSwiftPage = true;
            showwelcomesection = False;
            showdetailsection = true;
            showpageBlock= true;
            showmydeviceshomeLink = False;
            respectiveLevel = 'Mask Release System';
            //OpenPageURL = System.Label.SWIFT_Community_URL + 'VFMRSFoundryFrameMockupReview';
            OpenPageURL = System.Label.SWIFT_Community_URL + 'VFMRSFrameMockupReview?type=Foundry';
        }
        if(Page == 'SendPrimeData')
        {
            isSwiftPage = true;
            showwelcomesection = False;
            showdetailsection = true;
            showpageBlock= true;
            showmydeviceshomeLink = False;
            respectiveLevel = 'Mask Release System';
            OpenPageURL = System.Label.SWIFT_Community_URL + 'VFMRSSendData';
           
        }
        if(Page == 'SendFrameData')
        {
            isSwiftPage = true;
            showwelcomesection = False;
            showdetailsection = true;
            showpageBlock= true;
            showmydeviceshomeLink = False;
            respectiveLevel = 'Mask Release System';
            OpenPageURL = System.Label.SWIFT_Community_URL + 'VFMRSSendDataFrame';
           
        }
        if(Page == 'MEBESJobviewCustomer')
        {
            //isSwiftMRSPage =true;
            isSwiftPage =true;           
            showwelcomesection = False;
            showdetailsection = true;
            showpageBlock= true;
            showmydeviceshomeLink = False;
            respectiveLevel = 'Mask Release System';           
            OpenPageURL = System.Label.SWIFT_Community_URL + 'VFMRSMEBESJobview?jobview=Customer';
        }
        if(Page == 'MEBESJobviewFoundry')
        {
            isSwiftMRSPage =true;
            isSwiftPage =false; 
            showwelcomesection = False;
            showdetailsection = true;
            showpageBlock= true;
            showmydeviceshomeLink = False;
            respectiveLevel = 'Mask Release System';           
            OpenPageURL = System.Label.SWIFT_Community_URL + 'VFMRSMEBESJobview?jobview=Foundry';
        }
        if(Page == 'MEBESJobviewTapeoutCentre')
        {
            isSwiftMRSPage =true;
            isSwiftPage =false; 
            showwelcomesection = False;
            showdetailsection = true;
            showpageBlock= true;
            showmydeviceshomeLink = False;
            respectiveLevel = 'Mask Release System';            
            OpenPageURL = System.Label.SWIFT_Community_URL + 'VFMRSMEBESJobview?jobview=TapeoutCentre';
        }
        if(Page == 'MEBESJobviewTapeoutApplication')
        {
            isSwiftMRSPage =true;
            isSwiftPage =false; 
            showwelcomesection = False;
            showdetailsection = true;
            showpageBlock= true;
            showmydeviceshomeLink = False;
            respectiveLevel = 'Mask Release System';           
            OpenPageURL = System.Label.SWIFT_Community_URL + 'VFMRSMEBESJobview?jobview=TapeoutApp';
        }
        if(Page == 'MEBESJobviewGlobalShuttle')
        {
            isSwiftMRSPage =true;
            isSwiftPage =false; 
            showwelcomesection = False;
            showdetailsection = true;
            showpageBlock= true;
            showmydeviceshomeLink = False;
            respectiveLevel = 'Mask Release System';            
            OpenPageURL = System.Label.SWIFT_Community_URL + 'VFMRSMEBESJobview?jobview=GlobalShuttle';
        }
        if(Page == 'MEBESJobviewMDP')
        {
            isSwiftMRSPage =true;
            isSwiftPage =false; 
            showwelcomesection = False;
            showdetailsection = true;
            showpageBlock= true;
            showmydeviceshomeLink = False;
            respectiveLevel = 'Mask Release System';            
            OpenPageURL = System.Label.SWIFT_Community_URL + 'VFMRSMEBESJobview?jobview=MDP';
        }
        if(Page == 'MEBESJobviewMPWTDTI')
        {
            isSwiftMRSPage =true;
            isSwiftPage =false; 
            showwelcomesection = False;
            showdetailsection = true;
            showpageBlock= true;
            showmydeviceshomeLink = False;
            respectiveLevel = 'Mask Release System';            
            OpenPageURL = System.Label.SWIFT_Community_URL + 'VFMRSMEBESJobview?jobview=MPWTDTI';
        }
        if(Page == 'HoldResumeLayer')
        {
            isSwiftMRSPage =true;
            isSwiftPage =false; 
            showwelcomesection = False;
            showdetailsection = true;
            showpageBlock= true;
            showmydeviceshomeLink = False;
            respectiveLevel = 'Mask Release System';
            OpenPageURL = System.Label.SWIFT_Community_URL + 'VFMRSResumeHold';
        }
        if(Page == 'TIDBView')
        {
            isSwiftPage = true;
            showwelcomesection = False;
            showdetailsection = true;
            showpageBlock= true;
            showmydeviceshomeLink = False;
            respectiveLevel = 'Tape-In Database';
            OpenPageURL = System.Label.SWIFT_Community_URL + 'VFTIDBView';
        }
        if(Page == 'TIDBFileExtraction')
        {
            isSwiftPage = true;
            showwelcomesection = False;
            showdetailsection = true;
            showpageBlock= true;
            showmydeviceshomeLink = False;
            respectiveLevel = 'Tape-In Database';
            OpenPageURL = System.Label.SWIFT_Community_URL + 'VFTIDBUploadFile';
        }
        if(Page == 'TIDBSearch')
        {
            isSwiftPage = true;
            showwelcomesection = False;
            showdetailsection = true;
            showpageBlock= true;
            showmydeviceshomeLink = False;
            respectiveLevel = 'Tape-In Database';
            OpenPageURL = System.Label.SWIFT_Community_URL + 'VFTIDBFileAuditTrail';
        }
        
        if(Page == 'PickAllMapPage'){
            showwelcomesection = False;
            showdetailsection = True;
            showpageBlock= True;
            showmydeviceshomeLink = False;
            respectiveLevel =System.Label.Pick_All_Maps;//'Form Management System';
            //Schema.DescribeSObjectResult result = Wavier_Collaborator__c.SObjectType.getDescribe(); 
            //OpenPageURL = result.getKeyPrefix()+'/o';
            OpenPageURL='PickAllMapPage';
        }
        // Modified by CTS for GF-SwiftGen development purpose Ends
        /** End of code for SwiftGen project **/
        return null;
    }
    
 /*
    * @ Author        :- Navneet Rajput
    * @ Company       :- CTS
    * @ Date          :- 11/11/2013  
    * @ Description   :- Common Method which return user short name
    **/
      
    private string getUserShortName(){
        User user = [SELECT accountId,Portal_Login__c,HCM_Login_ID__c,UserType,Parent_Account_Short_Name__c,FederationIdentifier FROM User WHERE Id =:userInfo.getUserId()];
        if (user.HCM_Login_ID__c == null || user.HCM_Login_ID__c =='')
              return user.FederationIdentifier;// Federation ID will be always populated.
        else 
              return user.HCM_Login_ID__c;// In case federation Id is null it will take Hcm Id 
    }
  

    //Method added by Sunil Arora for case # 40399
     private string getUserShortNamePRF(){
        User user = [SELECT
        accountId,Portal_Login__c,HCM_Login_ID__c,UserType,Parent_Account_Short_Name__c,FederationIdentifier
        FROM User WHERE Id =:userInfo.getUserId()];
        if (user.HCM_Login_ID__c == null || user.HCM_Login_ID__c =='')
        return user.FederationIdentifier;// Federation ID will be used for customers
        else
        return '';// return empty value in case it's a internal user
}  
}