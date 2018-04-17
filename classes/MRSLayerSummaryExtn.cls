/*
Type Name: MRSLayerSummaryExtn
Author: Cognizant Technology Solutions
Created Date: 11-April-2014
Reason: This is a controller class for VFMRSLayerSummary page
Change History:
Cognizant            08102014     -      Code review comments implemented updated
Cognizant            27082014     -      Code comments updated
Cognizant            28072014     -      Method added: ViewStateCleanUp
Cognizant            25072014     -      Properties declared as transient
??..
??..
*/

public class MRSLayerSummaryExtn
{
   /* Map variable declaration */
   public transient Map<Id, List<Mask_Layer__c>> PTRFtoLayerMap{get;set;}
   public Map<String,MRS_Fields_Permission_Config__c> mapAll = new Map<String,MRS_Fields_Permission_Config__c>();
   public transient Map<Id,String> IDMstNameMap  = new Map<Id,String>();
   public Map<Id,String> CustomerNameIdMap= new Map<Id,String>();
   
   /* List variable declaration */   
   public transient List<Mask_Layer__c> firstPrimePTRF{get;set;}
   public transient List<Mask_Layer__c> firstFramePTRF{get;set;}
   public transient List<String> listOfPTRFIDs{get;set;}
   public List<MRS_Layer_Association__c> masterMRSObj{get;set;} {masterMRSObj = new List<MRS_Layer_Association__c>();}
   public List<LayerSummaryWrapper> ListObj{get;set;} {ListObj = new List<LayerSummaryWrapper>();}
   public List<LayerSummaryWrapper> postSortValues{get;set;} {postSortValues = new List<LayerSummaryWrapper>();}
   public List<LayerSummaryWrapper> requirement4{get;set;} {requirement4 = new List<LayerSummaryWrapper>();}
   public List<LayerSummaryWrapper> finalLSList{get;set;} {finalLSList = new List<LayerSummaryWrapper>();}
   public transient list<Account> lstCustomerList {get;set;} {lstCustomerList = new List<Account>();}
   public List<MRS_Layer_Chip_Association__c> lstmrsLayerChipSummary{get;set;}
   public List<String> SWIFT_FE_ROLES {get;set;} {
       Environment_Variable__c tempEnv = [SELECT Value__c FROM Environment_Variable__c WHERE Name = 'SwiftFETeamRoles' LIMIT 1];
       SWIFT_FE_ROLES = String.valueOf(tempEnv.Value__c).split(',');
   }
   public List<PTRF__c> PTRFList {get;set;}
   public List<PTRF__C> PTRFListForRecticle {get;set;}
   public List<MRS_Layer_Association__c> tempMRSObj {get;set;} {tempMRSObj = new List<MRS_Layer_Association__c>();}
   public List<MRS_Layer_Association__c> MRSForDropDowns {get;set;} {MRSForDropDowns = new List<MRS_Layer_Association__c>();}
   public List<MST_Config__c> listMST {get;set;}
   Public List<String> SelectedLayerStatusValue {get;set;}
   public transient list<SelectOption> customerList{get;set;}
   public list<SelectOption> mstList{get;set;}
   public list<SelectOption> lstmst{get;set;}   
   public list<SelectOption> lstMaskLayer {get;set;}
   public list<SelectOption> lstLayerStatus {get;set;}    
   public list<SelectOption> lstDeviceId {get;set;}
   public list<SelectOption> lstTechGeo {get;set;}      
   public list<integer> lstSizeOne {get;set;}
   
   /* Boolean variable declaration */  
   public Boolean DirectCallToValues {get;set;} {DirectCallToValues = false;}
   public Boolean SingleMSTValue {get;set;} {SingleMSTValue = false;}   
   public Boolean SizeExceeded {get;set;} {SizeExceeded = false;}                          
   public transient Boolean isFirstFramePTRF{get;set;}
   public Boolean ignoreFlagValues {get;set;}
   public Boolean isClear {get;set;} {isClear = false;}
   public Boolean groupFE {get;set;}
   public Boolean groupTapeoutOperation {get;set;}
   public Boolean groupMDP {get;set;}
   public Boolean groupGlobalShuttle {get;set;}
   public Boolean groupTDTIMPW {get;set;}
   public Boolean groupFoundryJobviewer {get;set;}
   public Boolean groupSwiftAdmin {get;set;}
   public Boolean groupSwiftSupport {get;set;}
   public Boolean groupTapeoutCentre {get;set;}
   public Boolean groupTapeoutApplication {get;set;}
   public Boolean groupRMG {get;set;}   
   public Boolean groupTapeoutAdmin {get;set;}
   public Boolean groupCAD {get;set;}  
   public Boolean hasMasterValue {get;set;}
   public Boolean TechGeoDisplayFlag {get;set;}
   public Boolean showLabel {get;set;}
   public Boolean isValidCustomer {get;set;}                  
   public Boolean isAll {get;set;} {
       if(ApexPages.currentPage()!=null){
       if(ApexPages.currentPage().getCookies().get('isAll') != null && String.valueOf(ApexPages.currentPage().getCookies().get('isAll').getValue()) != '' && String.valueOf(ApexPages.currentPage().getCookies().get('isAll').getValue()) != null){
            isAll = (String.valueOf(ApexPages.currentPage().getCookies().get('isAll').getValue())=='true'?true:false);
       }
       else{
           if(ApexPages.currentPage().getCookies().get('isAll') == null || String.valueOf(ApexPages.currentPage().getCookies().get('isAll').getValue()) == '' || String.valueOf(ApexPages.currentPage().getCookies().get('isAll').getValue()) == null){
               isAll = true;
           }
       }
       }else{
           isAll = true;
       }
   }
   public Boolean isGDSOUTReview {get;set;} 
   public Boolean isFrameMockupReview {get;set;}
   public Boolean isSendData {get;set;}
   public Boolean isRemoteJobView {get;set;} 
   public Boolean isORC {get;set;} 
   public Boolean isDRW {get;set;} 
   public Boolean isMEBESReceied {get;set;}
   public Boolean isMEBESReceived {get;set;} 
   public Boolean isMEBESJobView {get;set;}    
   public Boolean GDSOUTReviewFlag {get;set;}
   public Boolean FrameMockup {get;set;}   
   public Boolean SendData {get;set;}
   public Boolean MEBESReceived {get;set;}
   public Boolean MEBESJobview {get;set;}
   public Boolean CustomerRemoteJobview {get;set;}
   public Boolean FoundryRemoteJobview {get;set;}   
   public Boolean internalView {get;set;}    
   public Boolean GDSOUTReviewCustomerFlag {get;set;}   
   public Boolean GDSOUTReviewFoundryFlag {get;set;}   
   public Boolean FrameMockupCustomerFlag {get;set;}
   public Boolean FrameMockupFoundryFlag {get;set;}
   public Boolean SendDataPrimeFlag {get;set;}
   public Boolean SendDataFrameFlag {get;set;}
   public Boolean OriginalORC {get;set;}
   public Boolean OriginalDRW {get;set;}
   public Boolean ORCFlag {get;set;}
   public Boolean DRWFlag {get;set;}
   public Boolean MEBESReceivedPrimeFlag {get;set;}
   public Boolean MEBESReceivedFrameFlag {get;set;}
   public Boolean MEBESJobviewCustomerFlag {get;set;}
   public Boolean MEBESJobviewFoundryFlag {get;set;}   
   public Boolean MEBESJobviewTapeoutCentreFlag {get;set;}   
   public Boolean MEBESJobviewTapeoutApplicationsFlag {get;set;}   
   public Boolean MEBESJobviewGlobalShuttleFlag {get;set;}   
   public Boolean MEBESJobviewMDPFlag {get;set;}   
   public Boolean MEBESJobviewTDTIMPWFlag {get;set;}   
   public Boolean CustomerRemoteJobviewPrimeFlag {get;set;}   
   public Boolean CustomerRemoteJobviewFrameFlag {get;set;}         
   public Boolean FoundryRemoteJobviewPrime {get;set;}
   public Boolean FoundryRemoteJobviewFrame {get;set;}
   public Boolean isCustomer {get;set;}   
   public Boolean isBreadcrumbActive {get;set;}
   
   /* Integer variable declaration */
   public Integer refreshInterval {get;set;} {
        MRS_Layer_Summary_Refresh_Interval__c temp = [select Page_Refresh_Frequency__c from MRS_Layer_Summary_Refresh_Interval__c LIMIT 1];
        refreshInterval = (Integer)temp.Page_Refresh_Frequency__c;   
   }

   /* Custom object variable declaration */
   public transient Mask_Set_Title__C tempMST {get;set;}
   public Mask_Set_Title__c tempMSTForId {get;set;}
   public PaginatedSelectList MaskLayerSelectOptionList{ get;set; } {
       MaskLayerSelectOptionList = new PaginatedSelectList(); 
       MaskLayerSelectOptionList.add(new SelectOption('',''));
   }   
   /* String variable declaration */   
   public String lookupMSTURL {get;set;}
   public String MSTLookupBase {get;set;} {
       if(String.valueOf(ApexPages.currentPage().getHeaders().get('Host')).contains(Label.Swift_Host_URL)){MSTLookupBase = String.valueOf(Label.Swift_VFExternal_URL)+'VFMaskSetTitleLookupDialog';}
       else{MSTLookupBase = String.valueOf(Label.Swift_VFInternal_URL)+'VFMaskSetTitleLookupDialog';}
   }
   public String lookupCustomerURL {get;set;}
   public String LayerStatusForExport {get;set;}
   public String hiddenSelectedMST {get;set;}
   public String maskValuesSelected;
   public String MRSId {get;set;} 
   public string selectedCustomer {get ;set;} 
   public String selectedCustomerName {get;set;}    
   public String selectedmst {get;set;} 
   public String WithMPW = 'MPW%';
   public String startsWithMPW = ' AND MaskSetTitle__r.Name LIKE:WithMPW';
   public String MSTIDString {get;set;}
   public static String BASICQUERY = 'SELECT Customer_Frame_Mockup_Date__c,Customer_Frame_Mockup__c,Customer_Frame_Remote_Jobview_Setup_Date__c,Customer_Frame_Remote_Jobview_Setup__c,Customer_GDSOUT_Review_Date__c,Customer_GDSOUT_Review__c,Customer_MEBES_Jobview_Date__c,Customer_MEBES_Jobview__c,Customer_Prime_Remote_Jobview_Setup_Date__c,Customer_Prime_Remote_Jobview_Setup__c,Disapprove_Reason_For_Frame_Mockup_Revie__c,DRW_Date__c,DRW__c,Error_Message_Oracle_DB__c,Foundry_Frame_Mockup_Date__c,Foundry_Frame_Mockup__c,Foundry_Frame_Remote_Jobview_Setup_Date__c,Foundry_Frame_Remote_Jobview_Setup__c,Foundry_GDSOUT_Review_Date__c,Foundry_GDSOUT_Review__c,Foundry_MEBES_Jobview_Date__c,Foundry_MEBES_Jobview__c,Foundry_Prime_Remote_Jobview_Setup_Date__c,Foundry_Prime_Remote_Jobview_Setup__c,Frame_MEBES_Received_Date__c,Frame_MEBES_Received__c,Generated_Mask_Title__c,GlobalShuttle_MEBES_Jobview_Date__c,GlobalShuttle_MEBES_Jobview__c,Hold_Warning__c,Id,Layer_Status_Date__c,Layer_Status__c,Mask_Layer_Rev__c,Mask_Set_Title_Name__c,MDP_MEBES_Jobview_Date__c,MDP_MEBES_Jobview__c,MRS_Layer_Unique_Identifier__c,MRS__c,Name,ORC_Date__c,ORC__c,Prime_MEBES_Received_Date__c,Prime_MEBES_Received__c,Reticle_Type__c,ROM_Code__c,Send_Frame_Data_Date__c,Send_Frame_Data__c,Send_Prime_Data_Date__c,Send_Prime_Data__c,Tapeout_Applications_MEBES_Jobview_Date__c,Tapeout_Applications_MEBES_Jobview__c,Tapeout_Centre_MEBES_Jobview_Date__c,Tapeout_Centre_MEBES_Jobview__c,TDTI_MPW_MEBES_Jobview_Date__c,TDTI_MPW_MEBES_Jobview__c,Tech_Geo__c from MRS_Layer_Association__c where Id in :ChipLayerValues and Layer_Status__c <> \'\'';
   Public String SelectedMaskLayerValue {get;set;}{ SelectedMaskLayerValue = null; }
   Public String ValueCatcher {get;set;} { ValueCatcher = DefaultLayerSummaryValues(); }
   Public String SelectedTechGeoStatusValue {get;set;}{ SelectedTechGeoStatusValue = null; }
   Public String SelectedDeviceIdValue {get;set;}{ SelectedDeviceIdValue = null; }
   Public String FormattedTechGeo { get { return FormatTechGeo(SelectedTechGeoStatusValue); }set;}
   
   /* Set variable declaration */      
   public Set<LayerSummaryWrapper> LSWSet{get;set;}
   public Set<String> UniqueSet {get;set;}
   public Set<String> FinalMSTList {get;set;} 
   public Set<String> MRSChipDetailsId {get;set;}
   public Set<String> ChipLayerValues {get;set;} {ChipLayerValues = new Set<String>();}
   
   /* Id variable declaration */      
   public Id CustomerId {get;set;}     

/**
    This method is for exporting the Layer Summary values into a comma-separated-value format (.csv)
    @method name: exportToCSV
    @parameter:   None
    @return :     Reference of the Visualforce page for rendering in .csv format
**/ 
   public PageReference exportToCSV() {
    if(hasMasterValue){ return Page.VFMRSLayerSummarytoCSV;}
    else { return null; }
   }

/**
    This method is for exporting the Layer Summary values into a downloadable Microsoft Excel format (.xls)
    @method name: exportToExcel
    @parameter:   None
    @return :     Reference of the Visualforce page for rendering in .xls format
**/ 
   public PageReference exportToExcel(){
    if(hasMasterValue){return Page.VFMRSLayerSummarytoExcel;}
    else{return null;}
   }

/**
    This method returns the value for the variable hasMasterValue
    @parameter:   None
    @return :     Boolean value of the variable hasMasterValue
**/
    public Boolean getMasterValue(){ return hasMasterValue; }

/**
    This method is for generating the default layer status values for filtering out the initial content after selection of customer and mask set title.
    @method name: DefaultLayerSummaryValues
    @parameter:   None
    @return :     The default layer status values in a comma-separated string format
**/     
    public String DefaultLayerSummaryValues(){
        String returnValue = '';
        try { 
                for(AggregateResult a : [select Layer_Status__c from MRS_Layer_Association__c where Layer_Status__c not in ('Void','Cancel','Released','Shipped','',null) group by Layer_Status__c]){
                        returnValue = returnValue+String.valueOf(a.get('Layer_Status__c'))+',';
                }
                returnValue = returnValue.removeEnd(',');                 
        }
          catch(Exception e) {System.debug('The following exception has occurred: ' + e.getMessage());}
        return returnValue;
    } 

/**
    This is the wrapper method for generating the initial table after the selection of customer and mask set title are made in the Layer Summary page.
    @method name: switch
    @parameter:   None
    @return :     None
**/        
    public void switch(){
        ClsMyDevices.mst = new Cookie('mst',MSTIDString,null,-1,false);
        ApexPages.currentPage().setCookies(new Cookie[]{ClsMyDevices.mst});        
    try {
            isClear = false;
            if(!ignoreFlagValues){
                ValueCatcher = DefaultLayerSummaryValues(); 
                    LayerStatusForExport = '';
                    SelectedLayerStatusValue.clear();   
            }
            ClearDropDowns();        
            
            if(requirement4 != null && requirement4.size()>0){ 
                ChipLayerValues.clear();
                MRSForDropDowns.clear();
                tempMRSObj.clear();
                masterMRSObj.clear();             
            }
                      
            //resetLSPCookies();
            getSummary();
        }
        catch(Exception e) {System.debug('The following exception has occurred: ' + e.getMessage()); }
    }           

/**
    This method is for resetting the session cookies specific to Layer Summary Page.
    @method name: resetLSPCookies
    @parameter:   None
    @return :     None
**/ 

    public void resetLSPCookies(){
            
            SelectedMaskLayerValue = null;
            ValueCatcher = DefaultLayerSummaryValues();
            SelectedLayerStatusValue = ValueCatcher.split(',');
            LayerStatusForExport = ValueCatcher;
            SelectedTechGeoStatusValue = null;
            SelectedDeviceIdValue = null;
                        
            Cookie maskLayer = new Cookie('maskLayer',null,null,-1,false);
            Cookie layerStatus = new Cookie('layerStatus',null,null,-1,false);
            Cookie techGeo = new Cookie('techGeo',null,null,-1,false);
            Cookie deviceId = new Cookie('deviceId',null,null,-1,false);        
            Cookie isAll = new Cookie('isAll',null,null,-1,false);     
            Cookie isGDSOUTReview = new Cookie('isGDSOUTReview',null,null,-1,false);
            Cookie isFrameMockupReview = new Cookie('isFrameMockupReview',null,null,-1,false);
            Cookie isSendData = new Cookie('isSendData',null,null,-1,false);
            Cookie isRemoteJobView = new Cookie('isRemoteJobView',null,null,-1,false);
            Cookie isORC = new Cookie('isORC',null,null,-1,false);
            Cookie isDRW = new Cookie('isDRW',null,null,-1,false);
            Cookie isMEBESReceived = new Cookie('isMEBESReceived',null,null,-1,false);
            Cookie isMEBESJobView = new Cookie('isMEBESJobView',null,null,-1,false);
            Cookie ClearStatus = new Cookie('clearStatus','false',null,-1,false); 
            
            ApexPages.currentPage().setCookies(new Cookie[]{ClearStatus});     
            ApexPages.currentPage().setCookies(new Cookie[]{maskLayer});
            ApexPages.currentPage().setCookies(new Cookie[]{layerStatus});
            ApexPages.currentPage().setCookies(new Cookie[]{techGeo});
            ApexPages.currentPage().setCookies(new Cookie[]{deviceId});        
            ApexPages.currentPage().setCookies(new Cookie[]{isAll});
            ApexPages.currentPage().setCookies(new Cookie[]{isGDSOUTReview});
            ApexPages.currentPage().setCookies(new Cookie[]{isFrameMockupReview});
            ApexPages.currentPage().setCookies(new Cookie[]{isSendData});
            ApexPages.currentPage().setCookies(new Cookie[]{isRemoteJobView});
            ApexPages.currentPage().setCookies(new Cookie[]{isORC});
            ApexPages.currentPage().setCookies(new Cookie[]{isDRW});
            ApexPages.currentPage().setCookies(new Cookie[]{isMEBESReceived});
            ApexPages.currentPage().setCookies(new Cookie[]{isMEBESJobView});    
    }

/**
    This method is for initializing the filter dropdowns in the Layer Summary page.
    @method name: InitiateDropDowns
    @parameter:   None
    @return :     None
**/    
    public void InitiateDropDowns(){
    
        lstMaskLayer = new List<SelectOption>();
        lstLayerStatus = new List<SelectOption>();
        lstDeviceId = new List<SelectOption>();
        lstTechGeo = new List<SelectOption>();
    }

/**
    This method is for clearing the filter dropdowns in the Layer Summary page.
    @method name: ClearDropDowns
    @parameter:   None
    @return :     None
**/    
    public void ClearDropDowns(){
        if(lstMaskLayer != null){lstMaskLayer.Clear();}
        if(lstLayerStatus != null){lstLayerStatus.Clear();}
        if(lstDeviceId != null){lstDeviceId.Clear();}
        if(lstTechGeo != null){lstTechGeo.Clear();}
        if(MaskLayerSelectOptionList != null){ MaskLayerSelectOptionList.clear();MaskLayerSelectOptionList.add(new SelectOption('',''));}
    }

/**
    This method is for calculating the Layer Chip values for a selection of customer and mask set title.
    @method name: getChipLayerValues
    @parameter:   None
    @return :     A set of String containing the unique layer chip ids for a selection of customer and mask set title
**/ 
    public Set<String> getChipLayerValues(){
        List<AggregateResult> agg = new List<AggregateResult>();
        List<AggregateResult> aggMST = new List<AggregateResult>();
        Set<String> Values = new Set<String>();
        
        if((selectedmst != null && selectedmst != '') || (MSTIDString != '' && MSTIDString != null))
        {                
        
        try {
            if(MSTIDString == null || MSTIDString == ''){
                if([select Layer__r.MRS__r.Mask_Set_Title__r.Name from MRS_Layer_Chip_Association__c where Customer_Name__c=:selectedCustomer and Layer__r.MRS__r.Mask_Set_Title__r.Name=:selectedmst and Layer__r.MRS__r.Mask_Set_Title__r.Status__c = 'Active' group by Layer__r.MRS__r.Mask_Set_Title__r.Name].size()>0){
                    aggMST = [select Layer__r.MRS__r.Mask_Set_Title__c,Layer__r.MRS__r.Mask_Set_Title__r.Name from MRS_Layer_Chip_Association__c where Customer_Name__c=:selectedCustomer and Layer__r.MRS__r.Mask_Set_Title__r.Name=:selectedmst and Layer__r.MRS__r.Mask_Set_Title__r.Status__c = 'Active' group by Layer__r.MRS__r.Mask_Set_Title__r.Name,Layer__r.MRS__r.Mask_Set_Title__c];
                    MSTIDString = String.valueOf(aggMST.get(0).get('Mask_Set_Title__c'));
                }
            }
            else{
                if(selectedmst != null && selectedmst != ''){
                    if([select Layer__r.MRS__r.Mask_Set_Title__r.Name from MRS_Layer_Chip_Association__c where Customer_Name__c=:selectedCustomer and Layer__r.MRS__r.Mask_Set_Title__r.Name=:selectedmst and Layer__r.MRS__r.Mask_Set_Title__r.Status__c = 'Active' group by Layer__r.MRS__r.Mask_Set_Title__r.Name].size()>0){
                        aggMST = [select Layer__r.MRS__r.Mask_Set_Title__c,Layer__r.MRS__r.Mask_Set_Title__r.Name from MRS_Layer_Chip_Association__c where Customer_Name__c=:selectedCustomer and Layer__r.MRS__r.Mask_Set_Title__r.Name=:selectedmst and Layer__r.MRS__r.Mask_Set_Title__r.Status__c = 'Active' group by Layer__r.MRS__r.Mask_Set_Title__r.Name,Layer__r.MRS__r.Mask_Set_Title__c];
                        MSTIDString = String.valueOf(aggMST.get(0).get('Mask_Set_Title__c'));
                    }                
                }
            }
            aggMST.clear();
            if(selectedmst == null || selectedmst == ''){
                if([select Layer__r.MRS__r.Mask_Set_Title__r.Name from MRS_Layer_Chip_Association__c where Customer_Name__c=:selectedCustomer and Layer__r.MRS__r.Mask_Set_Title__c=:MSTIDString and Layer__r.MRS__r.Mask_Set_Title__r.Status__c = 'Active' group by Layer__r.MRS__r.Mask_Set_Title__r.Name].size()>0){
                    aggMST = [select Layer__r.MRS__r.Mask_Set_Title__c,Layer__r.MRS__r.Mask_Set_Title__r.Name from MRS_Layer_Chip_Association__c where Customer_Name__c=:selectedCustomer and Layer__r.MRS__r.Mask_Set_Title__c=:MSTIDString and Layer__r.MRS__r.Mask_Set_Title__r.Status__c = 'Active' group by Layer__r.MRS__r.Mask_Set_Title__r.Name,Layer__r.MRS__r.Mask_Set_Title__c];
                    selectedmst = String.valueOf(aggMST.get(0).get('Name'));
                }
            }  
        }
        catch(Exception e) {System.debug('The following exception has occurred: ' + e.getMessage());}              

        try {
            if(MSTIDString != '' && MSTIDString != null){
            
                
                ClsMyDevices.mst = new Cookie('mst',MSTIDString,null,-1,false);
                ApexPages.currentPage().setCookies(new Cookie[]{ClsMyDevices.mst});
                
                 
                
                if(listOfPTRFIDs == NULL){listOfPTRFIDs = new List<String>();}
                else{listOfPTRFIDs.clear();}
                
                String PTRFQuery = 'select Id from PTRF__c where (Prime_Tapeout__c = true or Frame_Tapeout__c = true) and MaskSetTitle__c =:MSTIDString';
                if(!(groupMDP||groupSwiftAdmin||groupFE||groupTapeoutCentre||groupTapeoutApplication||groupTapeoutOperation||groupRMG||groupSwiftSupport||groupTapeoutAdmin||groupCAD||groupFoundryJobviewer)){
                    if(groupGlobalShuttle||groupTDTIMPW){ PTRFQuery = PTRFQuery + startsWithMPW; }
                }
                
                PTRFList = new List<PTRF__c>();

                PTRFList = Database.Query(PTRFQuery);
                
                    if(PTRFList != NULL){
                        for (PTRF__c PTRFObj : PTRFList){  listOfPTRFIDs.add(String.valueOf(PTRFObj.Id));  }
                        
                    PTRFtoLayerMap = new Map<Id, List<Mask_Layer__c>>();
                    for(Mask_Layer__c newMaskLayer : [select Name, Mask_Layer_Number__c, PTRF__c, Tapeout__c, Sort_Order__c from Mask_Layer__c where PTRF__c in:listOfPTRFIDs and Mask_Layer_Number__c not in ('NULL','null','',null) ORDER BY Sort_Order__c ASC]) {
                        if(PTRFtoLayerMap.containsKey(newMaskLayer.PTRF__c)) {
                            List<Mask_Layer__c> LayerList = PTRFtoLayerMap.get(newMaskLayer.PTRF__c);
                            LayerList.add(newMaskLayer);
                            PTRFtoLayerMap.put(newMaskLayer.PTRF__c, LayerList);
                        } else {   PTRFtoLayerMap.put(newMaskLayer.PTRF__c, new List<Mask_Layer__c> { newMaskLayer });  }
                    }
                        PTRFListForRecticle = [select Id, Recticle_Type__c from PTRF__C where MaskSetTitle__c =:MSTIDString AND Customer__c =:selectedCustomer AND Status__c = 'Perform Tapeout Options' AND Recticle_Type__c = 'Multi Node Reticle (MNR)'];
                        if(PTRFListForRecticle != NULL && !PTRFListForRecticle.isEmpty()){   TechGeoDisplayFlag = true; }
                        else{   TechGeoDisplayFlag = false;  }
                        
                        MRSChipDetailsId = new Set<String>();
                        for (MRS_Chip_Details__c MRSIds : [select Id from MRS_Chip_Details__C where MRS__C in (select Id from MRS__C where Mask_Set_Title__C =:MSTIDString)]){   MRSChipDetailsId.add(String.valueOf(MRSIds.Id)); }
                        Set<Id> PTRFIdWithoutBlankMaskLayerNumber = new Set<Id>();
                        for(Mask_Layer__c obj : [select Name, Mask_Layer_Number__c, PTRF__c, Tapeout__c from Mask_Layer__c where PTRF__c in:listOfPTRFIDs and Mask_Layer_Number__c not in (null,'','NULL')]){  PTRFIdWithoutBlankMaskLayerNumber.add(obj.PTRF__c);   }
                        agg = [select Layer__c from MRS_Layer_Chip_Association__c where Chip__c in:MRSChipDetailsId and Customer_Name__c=:selectedCustomer and (PTRF__r.Prime_Tapeout__c = true or PTRF__r.Frame_Tapeout__c = true) group by Layer__c];
                        for(AggregateResult obj : agg){   Values.add(String.valueOf(obj.get('Layer__c')));   }
                    }
                    else{   Values.add('');  }
                }
                else{
                    Values.add('');
                    ClsMyDevices.mst = new Cookie('mst',null,null,-1,false);
                    ApexPages.currentPage().setCookies(new Cookie[]{ClsMyDevices.mst});
                }
            }
            catch(Exception e) { System.debug('The following exception has occurred: ' + e.getMessage()); }            
        }
        else{
            Values.add('');
            ClsMyDevices.mst = new Cookie('mst',null,null,-1,false);
            ApexPages.currentPage().setCookies(new Cookie[]{ClsMyDevices.mst});
        }
        return Values;    
    }

/**
    This method is for generating the list of values for display in Layer Summary page for a selection of customer and mask set title.
    @method name: getSummary
    @parameter:   None
    @return :     None
**/
    public void getSummary() {   
    try {            
            List<AggregateResult> agg = new List<AggregateResult>();
            UniqueSet = new Set<String>();

                if(ValueCatcher != null && ValueCatcher != '' && !ignoreFlagValues){ SelectedLayerStatusValue = ValueCatcher.split(',');}
                            
            if(isClear){LayerStatusForExport = '';}
            if(requirement4 != null && requirement4.size()>0){ requirement4.clear(); }
            String query = '';
              User loggedInUser =[SELECT Id,AccountId,Name,ProfileId FROM User WHERE Id =:UserInfo.getUserId()];
            
            if(!ignoreFlagValues){
                if([SELECT Team_Role__c, User__c FROM Account_Team_Proxy__c WHERE Team_Role__c IN:SWIFT_FE_ROLES and User__c =:loggedInUser.Id].size()>0){ groupFE = true; }
                else{groupFE = false;}
                RestrictFieldValues(loggedInUser.Id, isCustomer,groupFE, loggedInUser.ProfileId);
            }
            
            ChipLayerValues = getChipLayerValues();
                
         if(selectedmst != null && selectedmst != '' && !ChipLayerValues.contains(''))
         {                
            String ListToString = '';
            for(String s:SelectedLayerStatusValue) { ListToString += (ListToString==''?'':',')+s; } 
 
                MRSForDropDowns = Database.Query(BASICQUERY);
    
            
            if(MRSForDropDowns != NULL){ PopulateFilterWithData(MRSForDropDowns); } 
                query = BASICQUERY;
                if (SelectedMaskLayerValue != NULL && SelectedMaskLayerValue != ''){ query += ' and Name =:SelectedMaskLayerValue'; }
                UniqueSet.clear();
                UniqueSet.addAll(SelectedLayerStatusValue);
                if (UniqueSet.size()>0 && !UniqueSet.contains('')){ query += ' and Layer_Status__c in:SelectedLayerStatusValue'; }            
                if (SelectedTechGeoStatusValue != NULL && SelectedTechGeoStatusValue != ''){ query += ' and Tech_Geo__c =:SelectedTechGeoStatusValue'; }
                if (SelectedDeviceIdValue != NULL && SelectedDeviceIdValue != ''){ query += ' and Id in (select Layer__c from MRS_Layer_Chip_Association__c where PTRF__r.Device_Id__c <> NULL and PTRF__r.Device_Id__c =:SelectedDeviceIdValue)'; }

                tempMRSObj = Database.Query(query);
            if(tempMRSObj.size()>1000){SizeExceeded = true; } else {SizeExceeded = false;}
        masterMRSObj.clear();
        if(!SizeExceeded){                
               
            Cookie maskLayer = new Cookie('maskLayer',SelectedMaskLayerValue,null,-1,false);
            Cookie layerStatus;
            if(LayerStatusForExport == ''){
                if(ApexPages.currentPage().getCookies().get('layerStatus') != null && String.valueOf(ApexPages.currentPage().getCookies().get('layerStatus').getValue()) == 'null'){
                    layerStatus = new Cookie('layerStatus','null',null,-1,false);
                }
                else{ layerStatus = new Cookie('layerStatus',null,null,-1,false); }
            }
            else{ layerStatus = new Cookie('layerStatus',LayerStatusForExport,null,-1,false); }
        
            Cookie techGeo = new Cookie('techGeo',SelectedTechGeoStatusValue,null,-1,false);
            Cookie deviceId = new Cookie('deviceId',SelectedDeviceIdValue,null,-1,false);
            
            Cookie isAll = new Cookie('isAll',(isAll==true?'true':'false'),null,-1,false);     
            Cookie isGDSOUTReview = new Cookie('isGDSOUTReview',(isGDSOUTReview==true?'true':'false'),null,-1,false);
            Cookie isFrameMockupReview = new Cookie('isFrameMockupReview',(isFrameMockupReview==true?'true':'false'),null,-1,false);
            Cookie isSendData = new Cookie('isSendData',(isSendData==true?'true':'false'),null,-1,false);
            Cookie isRemoteJobView = new Cookie('isRemoteJobView',(isRemoteJobView==true?'true':'false'),null,-1,false);
            Cookie isORC = new Cookie('isORC',(isORC==true?'true':'false'),null,-1,false);
            Cookie isDRW = new Cookie('isDRW',(isDRW==true?'true':'false'),null,-1,false);
            Cookie isMEBESReceived = new Cookie('isMEBESReceived',(isMEBESReceived==true?'true':'false'),null,-1,false);
            Cookie isMEBESJobView = new Cookie('isMEBESJobView',(isMEBESJobView==true?'true':'false'),null,-1,false);
            
            ApexPages.currentPage().setCookies(new Cookie[]{maskLayer});
            ApexPages.currentPage().setCookies(new Cookie[]{layerStatus});
            ApexPages.currentPage().setCookies(new Cookie[]{techGeo});
            ApexPages.currentPage().setCookies(new Cookie[]{deviceId});
            
            ApexPages.currentPage().setCookies(new Cookie[]{isAll});
            ApexPages.currentPage().setCookies(new Cookie[]{isGDSOUTReview});
            ApexPages.currentPage().setCookies(new Cookie[]{isFrameMockupReview});
            ApexPages.currentPage().setCookies(new Cookie[]{isSendData});
            ApexPages.currentPage().setCookies(new Cookie[]{isRemoteJobView});
            ApexPages.currentPage().setCookies(new Cookie[]{isORC});
            ApexPages.currentPage().setCookies(new Cookie[]{isDRW});
            ApexPages.currentPage().setCookies(new Cookie[]{isMEBESReceived});
            ApexPages.currentPage().setCookies(new Cookie[]{isMEBESJobView});

            masterMRSObj.clear();
            if(isCustomer){
                for(MRS_Layer_Association__c tempMRSLA : tempMRSObj){
                UniqueSet.clear();
                UniqueSet.addAll(SelectedLayerStatusValue);            
                    if(UniqueSet.size()>0 && !UniqueSet.contains('')){
                        if(UniqueSet.contains(tempMRSLA.Layer_Status__c)){ masterMRSObj.add(tempMRSLA); }
                    }
                    else{ masterMRSObj.add(tempMRSLA); }                
                }
                
            }
            else{
                if([SELECT Team_Role__c, User__c FROM Account_Team_Proxy__c WHERE Team_Role__c IN:SWIFT_FE_ROLES and User__c =:loggedInUser.Id].size()>0){ groupFE = true; }
                else{groupFE = false;}
                if((groupMDP||groupTapeoutCentre||groupTapeoutApplication||groupTapeoutOperation||groupRMG||groupSwiftSupport||groupTapeoutAdmin||groupCAD||groupFoundryJobviewer) && !groupSwiftAdmin && !groupFE){
                    for(MRS_Layer_Association__c tempMRSLA : tempMRSObj){
                        String TechGeoFormat = '';
                        if(String.valueOf(tempMRSLA.Tech_Geo__c) != '' && String.valueOf(tempMRSLA.Tech_Geo__c) != NULL && String.valueOf(tempMRSLA.Tech_Geo__c) != 'NULL' && !String.valueOf(tempMRSLA.Tech_Geo__c).equalsIgnoreCase('null')){
                            TechGeoFormat = FormatTechGeo(String.valueOf(tempMRSLA.Tech_Geo__c));
                        }
                        UniqueSet.clear();
                        UniqueSet.addAll(SelectedLayerStatusValue);                 
                        if(UniqueSet.size()>0 && !UniqueSet.contains('')){
                            if(UniqueSet.contains(tempMRSLA.Layer_Status__c)){
                                if(groupMDP){
                                    if(TechGeoFormat!=null && TechGeoFormat.toUppercase().contains('UM') && Double.valueOf(TechGeoFormat.toUppercase().substringBefore('UM').trim())<=0.02){   masterMRSObj.add(tempMRSLA);  } 
                                }
                                else{  masterMRSObj.add(tempMRSLA); }
                            }
                        }
                        else{
                            if(groupMDP){
                                if(TechGeoFormat!=null && TechGeoFormat.toUppercase().contains('UM') && Double.valueOf(TechGeoFormat.toUppercase().substringBefore('UM').trim())<=0.02){ masterMRSObj.add(tempMRSLA); } 
                            }
                            else{ masterMRSObj.add(tempMRSLA); }                
                        }
                    }
                          
                }
                else{
                    if((groupGlobalShuttle||groupTDTIMPW) && !groupSwiftAdmin && !groupFE){
                        if(tempMRSObj.size()>0){
                            for(MRS_Layer_Association__c tempMRSLA : tempMRSObj){
                                String TechGeoFormat = '';
                                if(String.valueOf(tempMRSLA.Tech_Geo__c) != '' && String.valueOf(tempMRSLA.Tech_Geo__c) != NULL && String.valueOf(tempMRSLA.Tech_Geo__c) != 'NULL' && !String.valueOf(tempMRSLA.Tech_Geo__c).equalsIgnoreCase('null')){ TechGeoFormat = FormatTechGeo(String.valueOf(tempMRSLA.Tech_Geo__c)); }
                                UniqueSet.clear();
                                UniqueSet.addAll(SelectedLayerStatusValue);                        
                                if(UniqueSet.size()>0 && !UniqueSet.contains('')){
                                    if(UniqueSet.contains(tempMRSLA.Layer_Status__c)){                        
                                        if(groupGlobalShuttle && TechGeoFormat!=null && TechGeoFormat.toUppercase().contains('UM') && Double.valueOf(TechGeoFormat.toUppercase().substringBefore('UM').trim())>0.02){ masterMRSObj.add(tempMRSLA); }
                                        if((groupTDTIMPW) && TechGeoFormat!=null && TechGeoFormat.toUppercase().contains('UM') && Double.valueOf(TechGeoFormat.toUppercase().substringBefore('UM').trim())<=0.02){ masterMRSObj.add(tempMRSLA); }
                                    }
                                }
                                else{
                                    if(groupGlobalShuttle && TechGeoFormat!=null && TechGeoFormat.toUppercase().contains('UM') && Double.valueOf(TechGeoFormat.toUppercase().substringBefore('UM').trim())>0.02){ masterMRSObj.add(tempMRSLA); }
                                    if(groupTDTIMPW && TechGeoFormat!=null && TechGeoFormat.toUppercase().contains('UM') && Double.valueOf(TechGeoFormat.toUppercase().substringBefore('UM').trim())<=0.02){ masterMRSObj.add(tempMRSLA); }                    
                                }
                            }
                        }
                    }
                    else{
                        if(groupSwiftAdmin||groupFE){
                            if(tempMRSObj.size()>0){
                                for(MRS_Layer_Association__c tempMRSLA : tempMRSObj){
                                    UniqueSet.clear();
                                    UniqueSet.addAll(SelectedLayerStatusValue);
                                    if(UniqueSet.size()>0 && !UniqueSet.contains('')){
                                        if(UniqueSet.contains(tempMRSLA.Layer_Status__c)){ masterMRSObj.add(tempMRSLA); }
                                    }
                                    else{ masterMRSObj.add(tempMRSLA); }
                                }
                            }
                        }
                    }
                }

                
            }  
        
        }

         }
         else
         {
                     
            ClsMyDevices.mst = new Cookie('mst',null,null,-1,false);
            ApexPages.currentPage().setCookies(new Cookie[]{ClsMyDevices.mst});
            
             masterMRSObj.clear();        
             query = 'SELECT Id, Name, ROM_Code__c, Layer_Status__c, Customer_GDSOUT_Review__c, Foundry_GDSOUT_Review__c, Customer_Frame_Mockup__c, Foundry_Frame_Mockup__c, Send_Prime_Data__c, Send_Frame_Data__c, ORC__c, DRW__c, Prime_MEBES_Received__c, Frame_MEBES_Received__c, Customer_MEBES_Jobview__c, Foundry_MEBES_Jobview__c, Tapeout_Centre_MEBES_Jobview__c, Tapeout_Applications_MEBES_Jobview__c, GlobalShuttle_MEBES_Jobview__c, MDP_MEBES_Jobview__c, TDTI_MPW_MEBES_Jobview__c, Customer_Prime_Remote_Jobview_Setup__c, Customer_Frame_Remote_Jobview_Setup__c, Foundry_Prime_Remote_Jobview_Setup__c, Foundry_Frame_Remote_Jobview_Setup__c, Customer_GDSOUT_Review_Date__c from MRS_Layer_Association__c where Id in :MRSId';
         }   
   
                this.hasMasterValue = true;
                ignoreFlagValues = false;  
                isClear = false;  
        }
        catch(Exception e) { System.debug('The following exception has occurred: ' + e.getMessage()); }     
    }

/**
    This method is for populating the filters with data for filtering in Layer Summary page for a selection of customer and mask set title.
    @method name: PopulateFilterWithData
    @parameter:   List of MRS Layer Association object
    @return :     None
**/
public void PopulateFilterWithData(List<MRS_Layer_Association__c> DropDownMRSObj){
try {
        User loggedInUser =[SELECT Id,AccountId,Name,ProfileId FROM User WHERE Id =:UserInfo.getUserId()];
        Set<String> MASKLayerSet = new Set<String>(); 
        UniqueSet = new Set<String>();
        Map<String,String> MaskLayerValues = new Map<String,String>();       
        Set<String> LayerStatusSet = new Set<String>();        
        Set<String> DeviceIdSet = new Set<String>();        
        Set<String> TechGeoSet = new Set<String>();        
        Set<String> MRSIDSet = new Set<String>();
        String tempMaskLayerFilterString = '';
        Map<String,String> TechGeoMAP = new Map<String,String>();
        Double TechGeoValue;
        List<MRS_Layer_Association__c> tempMRSObj = new List<MRS_Layer_Association__c>();
        ClearDropDowns();
        lstMaskLayer.add(new SelectOption('',''));
        lstDeviceId.add(new SelectOption('',''));
        lstTechGeo.add(new SelectOption('',''));
       
        if([SELECT Team_Role__c, User__c FROM Account_Team_Proxy__c WHERE Team_Role__c IN:SWIFT_FE_ROLES and User__c =:loggedInUser.Id].size()>0){ groupFE = true; }
        else{groupFE = false;}
        if(isCustomer){
            for(MRS_Layer_Association__c tempMRSLA : DropDownMRSObj){
            UniqueSet.clear();
            UniqueSet.addAll(SelectedLayerStatusValue);            
                if(UniqueSet.size()>0 && !UniqueSet.contains('')){
                    if(UniqueSet.contains(tempMRSLA.Layer_Status__c)){ tempMRSObj.add(tempMRSLA); }
                }
                else{ tempMRSObj.add(tempMRSLA); }                
            }
            
        }
        else{
            if((groupMDP||groupTapeoutCentre||groupTapeoutApplication||groupTapeoutOperation||groupRMG||groupSwiftSupport||groupTapeoutAdmin||groupCAD||groupFoundryJobviewer) && !groupSwiftAdmin && !groupFE){
                for(MRS_Layer_Association__c tempMRSLA : DropDownMRSObj){
                    String TechGeoFormat = '';
                    if(String.valueOf(tempMRSLA.Tech_Geo__c) != '' && String.valueOf(tempMRSLA.Tech_Geo__c) != NULL && String.valueOf(tempMRSLA.Tech_Geo__c) != 'NULL' && !String.valueOf(tempMRSLA.Tech_Geo__c).equalsIgnoreCase('null')){ TechGeoFormat = FormatTechGeo(String.valueOf(tempMRSLA.Tech_Geo__c)); }

                        if(groupMDP){
                            if(TechGeoFormat!=null && TechGeoFormat.toUppercase().contains('UM') && Double.valueOf(TechGeoFormat.toUppercase().substringBefore('UM').trim())<=0.02){ tempMRSObj.add(tempMRSLA); } 
                        }
                        else{ tempMRSObj.add(tempMRSLA); }                

                }
                      
            }
            else{
                if((groupGlobalShuttle||groupTDTIMPW) && !groupSwiftAdmin && !groupFE){
                    if(DropDownMRSObj.size()>0){
                        for(MRS_Layer_Association__c tempMRSLA : DropDownMRSObj){
                            String TechGeoFormat = '';
                            if(String.valueOf(tempMRSLA.Tech_Geo__c) != '' && String.valueOf(tempMRSLA.Tech_Geo__c) != NULL && String.valueOf(tempMRSLA.Tech_Geo__c) != 'NULL' && !String.valueOf(tempMRSLA.Tech_Geo__c).equalsIgnoreCase('null')){ TechGeoFormat = FormatTechGeo(String.valueOf(tempMRSLA.Tech_Geo__c)); }

                                
                                if(groupGlobalShuttle && TechGeoFormat!=null && TechGeoFormat.toUppercase().contains('UM') && Double.valueOf(TechGeoFormat.toUppercase().substringBefore('UM').trim())>0.02){ tempMRSObj.add(tempMRSLA); }
                                if(groupTDTIMPW && TechGeoFormat!=null && TechGeoFormat.toUppercase().contains('UM') && Double.valueOf(TechGeoFormat.toUppercase().substringBefore('UM').trim())<=0.02){ tempMRSObj.add(tempMRSLA); }                    

                        }
                    }
                }
                else{
                    if(groupSwiftAdmin||groupFE){
                        if(DropDownMRSObj.size()>0){
                            for(MRS_Layer_Association__c tempMRSLA : DropDownMRSObj){

                                    tempMRSObj.add(tempMRSLA);
                             
                            }
                        }
                    }
                }
            }
        }  

        List<String> MaskLayerList = new List<String>();
        Set<String> MRSFinalList = new Set<String>();
        
        if(tempMRSObj.size()>0){
            for(MRS_Layer_Association__c temp : tempMRSObj){  MRSFinalList.add(temp.Id);  }
            List<AggregateResult> aggObj = [select Mask_Layer_Number__c from Mask_Layer__c where PTRF__C in:listOfPTRFIDs group by Mask_Layer_Number__c];
            for(AggregateResult obj : aggObj){  MaskLayerList.add(String.valueOf(obj.get('Mask_Layer_Number__c')));   }
            
            for(MRS_Layer_Association__c obj : [select Id,Name,Layer_Status__c,Tech_Geo__c from MRS_Layer_Association__c where Id in:MRSFinalList and Name in:MaskLayerList]){
                MASKLayerSet.add(obj.Name);
                LayerStatusSet.add(obj.Layer_Status__c);                            
                TechGeoSet.add(obj.Tech_Geo__c);
                MRSIDSet.add(obj.Id);
            }
            
            for(String str : TechGeoSet){
                String TechGeoFormatted = str;
                if(TechGeoFormatted != NULL && !TechGeoFormatted.equalsIgnoreCase('NULL') && TechGeoFormatted != ''){
                    if(!TechGeoFormatted.toUppercase().contains('UM')){ TechGeoFormatted +='UM'; }
                    if(TechGeoFormatted != NULL && !TechGeoFormatted.equalsIgnoreCase('NULL') && TechGeoFormatted != '' && !TechGeoFormatted.toLowercase().contains('nm') && TechGeoFormatted.toUppercase().substringBefore('UM').trim() != null){
                        TechGeoValue = double.valueOf(TechGeoFormatted.toUppercase().substringBefore('UM').trim());
                        if(TechGeoValue != NULL && TechGeoValue<0.1){ TechGeoFormatted = TechGeoFormatted + ' (' + Integer.valueOf(TechGeoValue*1000) + 'nm)';  }
                    }
                    if(TechGeoFormatted != '' && TechGeoFormatted != null){ TechGeoMAP.put(str,TechGeoFormatted); }
                }                
            }
             
            List<AggregateResult> B = [select PTRF__r.Device_id__c from MRS_Layer_Chip_Association__c where Layer__c in:MRSIDSet and PTRF__r.Device_id__c <> NULL and PTRF__r.Device_id__c <> '' group by PTRF__r.Device_id__c];
            for (AggregateResult t: B){ DeviceIdSet.add(String.valueOf(t.get('Device_id__c'))); }
         
            List<String> SortedDropdowns = new List<String>();
            
            SortedDropdowns.addAll(MASKLayerSet);
            SortedDropdowns.sort();                                
            for(String str : SortedDropdowns){
                if(str != '' && str != NULL){ lstMaskLayer.add(new SelectOption(str,str)); MaskLayerSelectOptionList.add(new SelectOption(str,str));}
            }

            SortedDropdowns.clear();
            SortedDropdowns.addAll(LayerStatusSet);
            SortedDropdowns.sort(); 
            for(String str : SortedDropdowns){
                if(str != '' && str != NULL){ lstLayerStatus.add(new SelectOption(str,str));  }           
            }
            Set<String> NewSetString = new Set<String>();
            NewSetString.addAll(SelectedLayerStatusValue);
            if(!ignoreFlagValues){
                SelectedLayerStatusValue.clear();
                LayerStatusForExport = '';
            }
            
            for(String str : SortedDropdowns){
                if(ValueCatcher == ''){
                    SelectedLayerStatusValue.add(str);
                    if(NewSetString.contains(str)){  LayerStatusForExport = LayerStatusForExport+str+','; }
                }
                else{
                    if(!ignoreFlagValues){ SelectedLayerStatusValue = ValueCatcher.split(','); }
                }
            }
            LayerStatusForExport = '';
            Set<String> tempSetOfString = new Set<String>();
            tempSetOfString.addAll(ValueCatcher.split(','));
            
            for(String str : LayerStatusSet){ 
                if(tempSetOfString.size()>0 && tempSetOfString.contains(str)){ LayerStatusForExport = LayerStatusForExport+str+','; }
                else { if(tempSetOfString.size()<1) { LayerStatusForExport = LayerStatusForExport+str+','; } 
                } 
            }
            LayerStatusForExport = LayerStatusForExport.removeEnd(',');
            
            SortedDropdowns.clear();
            SortedDropdowns.addAll(DeviceIdSet);
            SortedDropdowns.sort();                       
            for(String str : SortedDropdowns){
                if(str != '' && str != NULL){ lstDeviceId.add(new SelectOption(str,str));  }
            }
            SortedDropdowns.clear();
            SortedDropdowns.addAll(TechGeoSet);
            SortedDropdowns.sort();  
            
            for(String str : SortedDropdowns){
                if(str != '' && str != NULL && TechGeoMAP.containsKey(str) && !str.equalsIgnoreCase('NULL')){  lstTechGeo.add(new SelectOption(str,TechGeoMAP.get(str))); }
            }
        }
    }
    catch(Exception e) { System.debug('The following exception has occurred: ' + e.getMessage()); }                   
}

/**
    This method is for clearing any previous filter in Layer Summary page and display complete set of data for a selection of customer and mask set title.
    @method name: Clear
    @parameter:   None
    @return :     None
**/
    public void Clear(){
    try {    
            isClear = true;
            ValueCatcher = '';
            ClearDropDowns();
            SelectedLayerStatusValue.clear(); 
            getSummary();
            SelectedMaskLayerValue = null;
            SelectedLayerStatusValue.clear();   
            ValueCatcher = '';   
            Cookie layerStatus = new Cookie('layerStatus','null',null,-1,false); 
            ApexPages.currentPage().setCookies(new Cookie[]{layerStatus});                  
            Cookie ClearStatus = new Cookie('clearStatus','true',null,-1,false); 
            ApexPages.currentPage().setCookies(new Cookie[]{ClearStatus}); 
        }
        catch(Exception e) { System.debug('The following exception has occurred: ' + e.getMessage()); }        
     }

/*
The following methods are the getter methods returning the values of variables.
*/ 
   public Boolean getGDSOUTReviewFlag(){ return this.GDSOUTReviewFlag; }
   public Boolean getFrameMockup(){ return this.FrameMockup; }
   public Boolean getSendData(){ return this.SendData; }
   public Boolean getMEBESReceived(){ return this.MEBESReceived; }
   public Boolean getMEBESJobview(){ return this.MEBESJobview; }
   public Boolean getCustomerRemoteJobview(){ return this.CustomerRemoteJobview; }
   public Boolean getFoundryRemoteJobview(){ return this.FoundryRemoteJobview; }       

   public Boolean getGDSOUTReviewCustomerFlag(){ return this.GDSOUTReviewCustomerFlag; }   
   public Boolean getGDSOUTReviewFoundryFlag(){ return this.GDSOUTReviewFoundryFlag; }
   public Boolean getFrameMockupCustomerFlag(){ return this.FrameMockupCustomerFlag; }
   public Boolean getFrameMockupFoundryFlag(){ return this.FrameMockupFoundryFlag; }  
   public Boolean getSendDataPrimeFlag(){ return this.SendDataPrimeFlag; } 
   public Boolean getSendDataFrameFlag(){ return this.SendDataFrameFlag; } 
   public Boolean getORCFlag(){ return this.ORCFlag; } 
   public Boolean getDRWFlag(){ return this.DRWFlag; }
   public Boolean getMEBESReceivedPrimeFlag(){ return this.MEBESReceivedPrimeFlag; }
   public Boolean getMEBESReceivedFrameFlag(){ return this.MEBESReceivedFrameFlag; } 
   public Boolean getMEBESJobviewCustomerFlag(){ return this.MEBESJobviewCustomerFlag; }  
   public Boolean getMEBESJobviewFoundryFlag(){ return this.MEBESJobviewFoundryFlag; }  
   public Boolean getMEBESJobviewTapeoutCentreFlag(){ return this.MEBESJobviewTapeoutCentreFlag; }  
   public Boolean getMEBESJobviewTapeoutApplicationsFlag(){ return false;/*return this.MEBESJobviewTapeoutApplicationsFlag; SWGP-859*/} 
   public Boolean getMEBESJobviewGlobalShuttleFlag(){ return this.MEBESJobviewGlobalShuttleFlag; }   
   public Boolean getMEBESJobviewMDPFlag(){ return this.MEBESJobviewMDPFlag; }    
   public Boolean getMEBESJobviewTDTIMPWFlag(){ return this.MEBESJobviewTDTIMPWFlag; }  
   public Boolean getCustomerRemoteJobviewPrimeFlag(){ return this.CustomerRemoteJobviewPrimeFlag; } 
   public Boolean getCustomerRemoteJobviewFrameFlag(){ return this.CustomerRemoteJobviewFrameFlag; }  
   public Boolean getFoundryRemoteJobviewPrime(){ return this.FoundryRemoteJobviewPrime; }   
   public Boolean getFoundryRemoteJobviewFrame(){ return this.FoundryRemoteJobviewFrame; }                                          
  
   public String getselectedCustomerName(){ return this.selectedCustomerName; }
   public void resetSingleMSTValue() { SingleMSTValue = false;}
   public void resetMSTCookie(){
        ClsMyDevices.mst = new Cookie('mst',null,null,-1,false);
        ApexPages.currentPage().setCookies(new Cookie[]{ClsMyDevices.mst});    
   }
   public void assignMSTCookie(){
        system.debug('#### assignMSTCookie : selectedmst : '+selectedmst+' MSTIDString : '+MSTIDString);
        ClsMyDevices.mst = new Cookie('mst',MSTIDString,null,-1,false);
        ApexPages.currentPage().setCookies(new Cookie[]{ClsMyDevices.mst});    
        ignoreFlagValues = true;         
        //switch();
   }    
/**
    This method is for assigning the customer name to the variable based on selection in Layer Summary page
    @method name: setselectedCustomerName
    @parameter:   Customer name string
    @return :     None
**/
    public void setselectedCustomerName(String cusName){
        this.selectedCustomer = cusName;
        Account acc = [select Name,Id,Stage__c,Short_Name__c FROM Account where Id =:selectedCustomer].get(0); 
        this.selectedCustomerName = String.valueOf(acc.Name);
        if(acc.Short_Name__c != null && acc.Short_Name__c != ''){ this.selectedCustomerName+= ' ('+acc.Short_Name__c+')'; }                     

    }

/**
    This method is for assigning the customer id to the variable based on selection in Layer Summary page and subsequent mask set title values population
    @method name: setCustomerID
    @parameter:   None
    @return :     None
**/
    public void setCustomerID(){
        List<AggregateResult> aggMST = new List<AggregateResult>(); 

        Account acc = [select Name,Id,Stage__c,Short_Name__c FROM Account where Id =:selectedCustomer].get(0); 
        this.selectedCustomerName = String.valueOf(acc.Name);
        if(acc.Short_Name__c != null && acc.Short_Name__c != ''){ this.selectedCustomerName+= ' ('+acc.Short_Name__c+')'; }

        selectedmst = null;
        MSTIDString = null;
        
        lstmst.clear();
        lstMaskLayer.Clear();
        lstLayerStatus.Clear();
        lstDeviceId.Clear();
        lstTechGeo.Clear();  
        ChipLayerValues.clear();
        MRSForDropDowns.clear();
        tempMRSObj.clear();
        masterMRSObj.clear();         
        if(requirement4 != null && requirement4.size()>0){ requirement4.clear(); }
        ClsMyDevices.account = new Cookie('account',selectedCustomer,null,-1,false);
        ApexPages.currentPage().setCookies(new Cookie[]{ClsMyDevices.account});
        List<PTRF__c> tempPTRFList = [SELECT MaskSetTitle__c,MaskSetTitle__r.Name FROM PTRF__c WHERE Customer__c =:selectedCustomer and MaskSetTitle__c != null and MaskSetTitle__r.Name != null];
        if(tempPTRFList.size() == 1){
            selectedmst = String.valueOf(tempPTRFList.get(0).MaskSetTitle__r.Name);
            MSTIDString = String.valueOf(tempPTRFList.get(0).MaskSetTitle__c);
            ClsMyDevices.mst = new Cookie('mst',MSTIDString,null,-1,false);
            ApexPages.currentPage().setCookies(new Cookie[]{ClsMyDevices.mst});      
            //SingleMSTValue = true;
                      
            DirectCallToValues = true; ignoreFlagValues = true;
            switch();      
        }
        else{
            hasMasterValue = false;
              
            ClsMyDevices.mst = new Cookie('mst',MSTIDString,null,-1,false);
            ApexPages.currentPage().setCookies(new Cookie[]{ClsMyDevices.mst});        
            
            if(MSTIDString != null && MSTIDString != ''){

                aggMST.clear();
                if([select Layer__r.MRS__r.Mask_Set_Title__r.Name from MRS_Layer_Chip_Association__c where Customer_Name__c=:selectedCustomer and Layer__r.MRS__r.Mask_Set_Title__c=:MSTIDString and Layer__r.MRS__r.Mask_Set_Title__r.Status__c = 'Active' group by Layer__r.MRS__r.Mask_Set_Title__r.Name].size()>0){
                    aggMST = [select Layer__r.MRS__r.Mask_Set_Title__r.Name from MRS_Layer_Chip_Association__c where Customer_Name__c=:selectedCustomer and Layer__r.MRS__r.Mask_Set_Title__r.Name=:selectedmst and Layer__r.MRS__r.Mask_Set_Title__r.Status__c = 'Active' group by Layer__r.MRS__r.Mask_Set_Title__r.Name];
                    selectedmst = String.valueOf(aggMST.get(0).get('Name'));
                }                 
            }
            else{
                if(ApexPages.currentPage().getCookies().get('mst') != null && ApexPages.currentPage().getCookies().get('mst').getValue() != '' && ApexPages.currentPage().getCookies().get('mst').getValue() != null){
                    tempMST = new Mask_Set_Title__C();
                    String mstValuefromCookie = '';
                    mstValuefromCookie = String.valueOf(ApexPages.currentPage().getCookies().get('mst').getValue());
                    aggMST.clear();
                    if([select Layer__r.MRS__r.Mask_Set_Title__r.Name from MRS_Layer_Chip_Association__c where Customer_Name__c=:selectedCustomer and Layer__r.MRS__r.Mask_Set_Title__c=:mstValuefromCookie and Layer__r.MRS__r.Mask_Set_Title__r.Status__c = 'Active' group by Layer__r.MRS__r.Mask_Set_Title__r.Name].size()>0){
                        aggMST = [select Layer__r.MRS__r.Mask_Set_Title__r.Name from MRS_Layer_Chip_Association__c where Customer_Name__c=:selectedCustomer and Layer__r.MRS__r.Mask_Set_Title__r.Name=:selectedmst and Layer__r.MRS__r.Mask_Set_Title__r.Status__c = 'Active' group by Layer__r.MRS__r.Mask_Set_Title__r.Name];
                        selectedmst = String.valueOf(aggMST.get(0).get('Name'));
                    }                

                }  
            }
        }

    }

/**
    This method is for populating the Customer List of values with data
    @method name: getCustomerLOV
    @parameter:   None
    @return :     List of select option values
**/
   public List<SelectOption> getCustomerLOV() {      
        customerList = new List<SelectOption>();
        if(selectedCustomerName != NULL && selectedCustomerName != '' && selectedCustomer != '' && selectedCustomer != NULL){
            customerList.add(new SelectOption(selectedCustomer,selectedCustomerName));
            for (String s: CustomerNameIdMap.keyset()) {
                if(s != selectedCustomer){
                    customerList.add(new SelectOption(s,String.valueOf(CustomerNameIdMap.get(s))));                        
                }
            }
        }
        else{
            customerList.add(new SelectOption('',''));                 
            for (String s: CustomerNameIdMap.keyset()) { customerList.add(new SelectOption(s,String.valueOf(CustomerNameIdMap.get(s)))); }
        }        
    customerList.sort();
    CustomerNameIdMap.clear();
    return customerList;        
    }    

/**
    This method is assigning customer value after selection
    @method name: setCustomerValue
    @parameter:   Customer value string
    @return :     None
**/
    public void setCustomerValue(String customerValuesSelected) {
        this.selectedCustomer = customerValuesSelected; 
        Account acc = [select Name,Id,Stage__c,Short_Name__c FROM Account where Id =:selectedCustomer].get(0); 
        this.selectedCustomerName = String.valueOf(acc.Name);
        if(acc.Short_Name__c != null && acc.Short_Name__c != ''){ this.selectedCustomerName+= ' ('+acc.Short_Name__c+')'; }    

    } 

    public String getCustomerValue(){ return this.selectedCustomerName; }                

  
    public String getselectedmst(){ return this.selectedmst;
    }
    public void setselectedmst(String mstName){ this.selectedmst = mstName; }

/**
    This method is for providing a sorted list of mask set title values. Referenced by VF page.
    @method name: getMSTLOV
    @parameter:   None
    @return :     List of select option values
**/
    public List<SelectOption> getMSTLOV() {             
            lstmst.sort();
            return lstmst;
    }
   public void setMSTValue(String MSTValuesSelected) { this.selectedmst = MSTValuesSelected; }
   public String getMSTValue() { return selectedmst; }               

/**
    This method is for refreshing the values in the Layer Summary page on regular intervals
    @method name: refreshData
    @parameter:   None
    @return :     None
**/
    public void refreshData() {
        infoMessage = '';
        ignoreFlagValues = true;
        if(isAll){
            isGDSOUTReview = true;
            isFrameMockupReview = true;
            isSendData = true;
            isRemoteJobView = true;
            isORC = true;
            isDRW = true;
            isMEBESReceived = true;
            isMEBESJobView = true;
        }
        DirectCallToValues = true;
        switch();
    }
    
    


/**
    This method is for calculating the user's permission to view data and fields in the Layer Summary page
    @method name: RestrictFieldValues
    @parameter:   
                1) String value of logged in User's Id
                2) Boolean value of Customer flag (true if customer, false otherwise)
                3) Boolean value of FE user flag (true if FE, false otherwise)
                4) String value of logged in User's profile Id
    @return :     None
**/     
    public void RestrictFieldValues(String suppliedUserId, Boolean suppliedCustomerFlag, Boolean isFEUser, String loggedInUserProfileId){
    String UserId = suppliedUserId;    
        
    String DevName = NULL;
    String CSName = NULL;
    isCustomer = suppliedCustomerFlag;
    mapAll.clear();
    List<MRS_Fields_Permission_Config__c> listAll = [SELECT CreatedById,CreatedDate,CustomerRemoteJobviewFrame__c,CustomerRemoteJobviewPrime__c,DRW__c,FoundryRemoteJobviewFrame__c,FoundryRemoteJobviewPrime__c,FrameMockupCustomer__c,FrameMockupFoundry__c,GDSOUTReviewCustomer__c,GDSOUTReviewFoundry__c,Id,IsDeleted,LastModifiedById,LastModifiedDate,MEBESJobviewCustomer__c,MEBESJobviewFoundry__c,MEBESJobviewGlobalShuttle__c,MEBESJobviewMDP__c,MEBESJobviewTapeoutAPPLICATIONS__c,MEBESJobviewTapeoutCenter__c,MEBESJobviewTDTIMPW__c,MEBESReceivedFrame__c,MEBESReceivedPrime__c,Name,ORC__c,SendDataFrame__c,SendDataPrime__c,SetupOwnerId,SystemModstamp FROM MRS_Fields_Permission_Config__c LIMIT 1000];
    for (MRS_Fields_Permission_Config__c temp : listAll){ mapAll.put(String.valueOf(temp.Name).toUpperCase(), temp); }
    Profile profileSysAdmin = [Select Id, name from Profile where name='System Administrator' LIMIT 1]; 
    Profile FEProfile = [SELECT Id,Name FROM Profile WHERE Name = 'GF FAE/FTS'];  
    List <Group> listGroup = [select Name, DeveloperName from Group where Id in (select GroupId from GroupMember where UserOrGroupId =:UserId)]; 
   if(loggedInUserProfileId == profileSysAdmin.Id || isFEUser){ 


    if(isFEUser){ 
        setAllFlagValue(false);        
        CSName = 'SWIFT_FE';
        CalculateFieldDisplayValues(CSName);
        if(listGroup != null && listGroup.size()>0){
            for(Group testGroup : listGroup){
                DevName = String.valueOf(testGroup.DeveloperName);
                CSName = String.valueOf(testGroup.DeveloperName).toUpperCase();
                CalculateFieldDisplayValues(CSName);
                if(DevName.equalsIgnoreCase('Swift_GlobalShuttle')){ groupGlobalShuttle = true; }
                else if(DevName.equalsIgnoreCase('SWIFT_Admin')){ groupSwiftAdmin = true; }
                else if(DevName.equalsIgnoreCase('Swift_MDP')){ groupMDP = true; }
                else if(DevName.equalsIgnoreCase('SWIFT_Support')){ groupSwiftSupport = true; }
                else if(DevName.equalsIgnoreCase('Swift_Tapeout_Centre')){ groupTapeoutCentre = true; }
                else if(DevName.equalsIgnoreCase('Swift_Tapeout_Operations')){ groupTapeoutOperation = true; }
                else if(DevName.equalsIgnoreCase('Swift_TDTI_MPW')){ groupTDTIMPW = true; }
                else if(DevName.equalsIgnoreCase('Swift_Tapeout_Application')){ groupTapeoutApplication = true; }
                else if(DevName.equalsIgnoreCase('Swift_RMG')){ groupRMG = true; }
                else if(DevName.equalsIgnoreCase('Swift_Foundry_Jobviewer')){ groupFoundryJobviewer = true; }
                else if(DevName.equalsIgnoreCase('Swift_Tapeout_Admin')){ groupTapeoutAdmin = true; }
                else if(DevName.equalsIgnoreCase('SWIFT_CAD')){ groupCAD = true; }
            }  
            groupFE = false;
        }
    }
    else{
        setAllFlagValue(true);
        groupSwiftAdmin = true;
    }

   if(!isAll && !ignoreFlagValues)
   {
           if(isGDSOUTReview!= null){
           GDSOUTReviewCustomerFlag &= isGDSOUTReview;
           GDSOUTReviewFoundryFlag &= isGDSOUTReview;
           }
           if(isFrameMockupReview!= null){
           FrameMockupCustomerFlag &= isFrameMockupReview;
           FrameMockupFoundryFlag &= isFrameMockupReview; 
           }
           
           if(isSendData!= null){
           SendDataPrimeFlag &= isSendData;
           SendDataFrameFlag &= isSendData;
           }
           if(isRemoteJobView!= null){
           CustomerRemoteJobviewPrimeFlag &= isRemoteJobView;
           CustomerRemoteJobviewFrameFlag &= isRemoteJobView;
           FoundryRemoteJobviewPrime &= isRemoteJobView;
           FoundryRemoteJobviewFrame &= isRemoteJobView;
           }
           if(isORC!= null){ ORCFlag &= isORC; }
           if(isDRW!= null){ DRWFlag &= isDRW; }           
           if(isMEBESReceived!= null){
           MEBESReceivedPrimeFlag &= isMEBESReceived;
           MEBESReceivedFrameFlag &= isMEBESReceived;
           }
           if(isMEBESJobView!= null){
           MEBESJobviewCustomerFlag &= isMEBESJobView;
           MEBESJobviewFoundryFlag &= isMEBESJobView;
           MEBESJobviewTapeoutCentreFlag &= isMEBESJobView;
           
           //SWGP-859
           //MEBESJobviewTapeoutApplicationsFlag &= isMEBESJobView;
           MEBESJobviewTapeoutApplicationsFlag = false;
           
           MEBESJobviewGlobalShuttleFlag &= isMEBESJobView;
           MEBESJobviewMDPFlag &= isMEBESJobView;
           MEBESJobviewTDTIMPWFlag &= isMEBESJobView;
           }
      }
   
   }
   else
   {
       if(isCustomer)
       {
            setAllFlagValue(false);

            Customer_Layer_Summary_Permission__c customerFieldPermission = [select Customer__c, Customer_Remote_Jobview__c, Customer_Short_Name__c, Frame_Mockup__c, GDSOUT_Review__c, MEBES_Jobview__c from Customer_Layer_Summary_Permission__c where Customer__c =:selectedCustomer LIMIT 1];
            if(customerFieldPermission != null) {
                this.GDSOUTReviewCustomerFlag |= customerFieldPermission.GDSOUT_Review__c;
                this.FrameMockupCustomerFlag |= customerFieldPermission.Frame_Mockup__c;
                this.MEBESJobviewCustomerFlag |= customerFieldPermission.MEBES_Jobview__c;
                this.CustomerRemoteJobviewPrimeFlag |= customerFieldPermission.Customer_Remote_Jobview__c;
                this.CustomerRemoteJobviewFrameFlag |= customerFieldPermission.Customer_Remote_Jobview__c;            
            }
            else{ 
            system.debug('No Values in CLSP'); }
       }
       else 
       {
            setAllFlagValue(false);
            
    for(Group testGroup : listGroup){
        DevName = String.valueOf(testGroup.DeveloperName);

            CSName = String.valueOf(testGroup.DeveloperName).toUpperCase();
       
        CalculateFieldDisplayValues(CSName);
        if(DevName.equalsIgnoreCase('Swift_GlobalShuttle')){ groupGlobalShuttle = true; }
        else if(DevName.equalsIgnoreCase('SWIFT_Admin')){ groupSwiftAdmin = true; }    
        else if(DevName.equalsIgnoreCase('Swift_MDP')){ groupMDP = true; }
        else if(DevName.equalsIgnoreCase('SWIFT_Support')){ groupSwiftSupport = true; }
        else if(DevName.equalsIgnoreCase('Swift_Tapeout_Centre')){ groupTapeoutCentre = true; }
        else if(DevName.equalsIgnoreCase('Swift_Tapeout_Operations')){ groupTapeoutOperation = true; }
        else if(DevName.equalsIgnoreCase('Swift_TDTI_MPW')){ groupTDTIMPW = true; }
        else if(DevName.equalsIgnoreCase('Swift_Tapeout_Application')){ groupTapeoutApplication = true; }  
        else if(DevName.equalsIgnoreCase('Swift_RMG')){ groupRMG = true; }
        else if(DevName.equalsIgnoreCase('Swift_Foundry_Jobviewer')){ groupFoundryJobviewer = true; }
        else if(DevName.equalsIgnoreCase('Swift_Tapeout_Admin')){ groupTapeoutAdmin = true; }        
        else if(DevName.equalsIgnoreCase('SWIFT_CAD')){ groupCAD = true; }              
    }

   GDSOUTReviewFlag = GDSOUTReviewCustomerFlag|GDSOUTReviewFoundryFlag;
   FrameMockup = FrameMockupCustomerFlag|FrameMockupFoundryFlag;   
   SendData = SendDataPrimeFlag|SendDataFrameFlag;
   MEBESReceived = MEBESReceivedPrimeFlag|MEBESReceivedFrameFlag;
   MEBESJobview = MEBESJobviewCustomerFlag|MEBESJobviewFoundryFlag;
   MEBESJobview = MEBESJobview|MEBESJobviewTapeoutCentreFlag;
   MEBESJobview = MEBESJobview|MEBESJobviewTapeoutApplicationsFlag;
   MEBESJobview = MEBESJobview|MEBESJobviewGlobalShuttleFlag;
   MEBESJobview = MEBESJobview|MEBESJobviewMDPFlag;
   MEBESJobview = MEBESJobview|MEBESJobviewTDTIMPWFlag;
   
   CustomerRemoteJobview = CustomerRemoteJobviewPrimeFlag|CustomerRemoteJobviewFrameFlag;
   FoundryRemoteJobview = FoundryRemoteJobviewPrime|FoundryRemoteJobviewFrame;            
   
   if(!isAll && !ignoreFlagValues)
   {
           if(isGDSOUTReview!= null){
           GDSOUTReviewCustomerFlag &= isGDSOUTReview;
           GDSOUTReviewFoundryFlag &= isGDSOUTReview;
           }
           if(isFrameMockupReview!= null){
           FrameMockupCustomerFlag &= isFrameMockupReview;
           FrameMockupFoundryFlag &= isFrameMockupReview;  
           }
           
           if(isSendData!= null){
           SendDataPrimeFlag &= isSendData;
           SendDataFrameFlag &= isSendData;
           }
           if(isRemoteJobView!= null){
           CustomerRemoteJobviewPrimeFlag &= isRemoteJobView;
           CustomerRemoteJobviewFrameFlag &= isRemoteJobView;
           FoundryRemoteJobviewPrime &= isRemoteJobView;
           FoundryRemoteJobviewFrame &= isRemoteJobView;
           }
           if(isORC!= null){ ORCFlag &= isORC; }
           if(isDRW!= null){ DRWFlag &= isDRW; }           
           if(isMEBESReceived!= null){
           MEBESReceivedPrimeFlag &= isMEBESReceived;
           MEBESReceivedFrameFlag &= isMEBESReceived;
           }
           if(isMEBESJobView!= null){
           MEBESJobviewCustomerFlag &= isMEBESJobView;
           MEBESJobviewFoundryFlag &= isMEBESJobView;
           MEBESJobviewTapeoutCentreFlag &= isMEBESJobView;
           
           //SWGP-859
           //MEBESJobviewTapeoutApplicationsFlag &= isMEBESJobView;
           MEBESJobviewTapeoutApplicationsFlag = false;
           
           MEBESJobviewGlobalShuttleFlag &= isMEBESJobView;
           MEBESJobviewMDPFlag &= isMEBESJobView;
           MEBESJobviewTDTIMPWFlag &= isMEBESJobView;
           }
    }

   }   
  }     
 }  

/**
    This method is for setting all table flag values according to the parameter passed
    @method name: setAllFlagValue
    @parameter:   Boolean flag value
    @return :     None
**/ 
    public void setAllFlagValue(Boolean bool){
        if(GDSOUTReviewFlag != null){ GDSOUTReviewFlag |= bool; }
        else{ GDSOUTReviewFlag = bool; }
        if(FrameMockup != null){ FrameMockup |= bool; }
        else{ FrameMockup = bool; }
        if(SendData != null){ SendData |= bool; }
        else{ SendData = bool; }
        if(MEBESReceived != null){ MEBESReceived |= bool; }
        else{ MEBESReceived = bool; }
        if(MEBESJobview != null){ MEBESJobview |= bool; }
        else{ MEBESJobview = bool; }
        if(CustomerRemoteJobview != null){ CustomerRemoteJobview |= bool; }
        else{ CustomerRemoteJobview = bool; }
        if(FoundryRemoteJobview != null){ FoundryRemoteJobview |= bool; }
        else{ FoundryRemoteJobview = bool; }
        if(OriginalDRW != null){ OriginalDRW |= bool; }
        else{ OriginalDRW = bool; }
        if(OriginalORC != null){ OriginalORC |= bool; }
        else{ OriginalORC = bool; }
              
        GDSOUTReviewCustomerFlag = bool;
        GDSOUTReviewFoundryFlag = bool;
        FrameMockupCustomerFlag = bool;
        FrameMockupFoundryFlag = bool;
        SendDataPrimeFlag = bool;
        SendDataFrameFlag = bool;  
        ORCFlag = bool;
        DRWFlag = bool;
        MEBESReceivedPrimeFlag = bool;
        MEBESReceivedFrameFlag = bool;
        MEBESJobviewCustomerFlag = bool;
        MEBESJobviewFoundryFlag = bool;
        MEBESJobviewTapeoutCentreFlag = bool;
        
        //swgp-859
        //MEBESJobviewTapeoutApplicationsFlag = bool;
        MEBESJobviewTapeoutApplicationsFlag = false;
        
        MEBESJobviewGlobalShuttleFlag = bool;
        MEBESJobviewMDPFlag = bool;
        MEBESJobviewTDTIMPWFlag = bool;
        CustomerRemoteJobviewPrimeFlag = bool;
        CustomerRemoteJobviewFrameFlag = bool;
        FoundryRemoteJobviewPrime = bool;
        FoundryRemoteJobviewFrame = bool;    
    }

/**
    This method is for calculating and setting flag values according to the MRS Permission Config custom setting
    @method name: CalculateFieldDisplayValues
    @parameter:   Public group name of the user
    @return :     None
**/ 
    public void CalculateFieldDisplayValues(String CSName)
    {
        if(mapAll.containsKey(CSName)){
       
        Boolean tempGDSOUTReviewCustomerFlag  = false;
        tempGDSOUTReviewCustomerFlag  = mapAll.get(CSName).GDSOUTReviewCustomer__c;
        this.GDSOUTReviewCustomerFlag |= tempGDSOUTReviewCustomerFlag;
        if(GDSOUTReviewFlag != null){ GDSOUTReviewFlag |= GDSOUTReviewCustomerFlag; }
        else{ GDSOUTReviewFlag = GDSOUTReviewCustomerFlag; }        
       
        Boolean tempGDSOUTReviewFoundryFlag   = false;
        tempGDSOUTReviewFoundryFlag   = mapAll.get(CSName).GDSOUTReviewFoundry__c;
        this.GDSOUTReviewFoundryFlag |= tempGDSOUTReviewFoundryFlag;
        if(GDSOUTReviewFlag != null){ GDSOUTReviewFlag |= GDSOUTReviewFoundryFlag; }
        else{ GDSOUTReviewFlag = GDSOUTReviewFoundryFlag; }        
       
        Boolean tempFrameMockupCustomerFlag    = false;
        tempFrameMockupCustomerFlag    = mapAll.get(CSName).FrameMockupCustomer__c;
        this.FrameMockupCustomerFlag |= tempFrameMockupCustomerFlag;
        if(FrameMockup != null){ FrameMockup |= FrameMockupCustomerFlag; }
        else{ FrameMockup = FrameMockupCustomerFlag; }        
       
        Boolean tempFrameMockupFoundryFlag = false;
        tempFrameMockupFoundryFlag = mapAll.get(CSName).FrameMockupFoundry__c;
        this.FrameMockupFoundryFlag |= tempFrameMockupFoundryFlag;
        if(FrameMockup != null){ FrameMockup |= FrameMockupFoundryFlag; }
        else{ FrameMockup = FrameMockupFoundryFlag; }        
       
        Boolean tempSendDataPrimeFlag = false;
        tempSendDataPrimeFlag = mapAll.get(CSName).SendDataPrime__c;
        this.SendDataPrimeFlag |= tempSendDataPrimeFlag;
        if(SendData != null){ SendData |= SendDataPrimeFlag; }
        else{ SendData = SendDataPrimeFlag; }        
       
        Boolean tempSendDataFrameFlag = false;
        tempSendDataFrameFlag = mapAll.get(CSName).SendDataFrame__c;
        this.SendDataFrameFlag |= tempSendDataFrameFlag;
        if(SendData != null){ SendData |= SendDataFrameFlag; }
        else{ SendData = SendDataFrameFlag; }        
       
        Boolean tempORCFlag = false;
        tempORCFlag = mapAll.get(CSName).ORC__c;
        this.ORCFlag |= tempORCFlag;
        if(OriginalORC != null){ OriginalORC |= ORCFlag; }
        else{ OriginalORC = ORCFlag; }
        
        Boolean tempDRWFlag = false;
        tempDRWFlag = mapAll.get(CSName).DRW__c;
        this.DRWFlag |= tempDRWFlag;
        if(OriginalDRW != null){ OriginalDRW |= DRWFlag; }
        else{ OriginalDRW = DRWFlag; }
        
        Boolean tempMEBESReceivedPrimeFlag = false;
        tempMEBESReceivedPrimeFlag = mapAll.get(CSName).MEBESReceivedPrime__c;
        this.MEBESReceivedPrimeFlag |= tempMEBESReceivedPrimeFlag;
        if(MEBESReceived != null){ MEBESReceived |= MEBESReceivedPrimeFlag; }
        else{ MEBESReceived = MEBESReceivedPrimeFlag; }        
      
        Boolean tempMEBESReceivedFrameFlag = false;
        tempMEBESReceivedFrameFlag = mapAll.get(CSName).MEBESReceivedFrame__c;
        this.MEBESReceivedFrameFlag |= tempMEBESReceivedFrameFlag;
        if(MEBESReceived != null){ MEBESReceived |= MEBESReceivedFrameFlag; }
        else{ MEBESReceived = MEBESReceivedFrameFlag; }        
        
        Boolean tempMEBESJobviewCustomerFlag = false;
        tempMEBESJobviewCustomerFlag = mapAll.get(CSName).MEBESJobviewCustomer__c;
        this.MEBESJobviewCustomerFlag |= tempMEBESJobviewCustomerFlag;
        if(MEBESJobview != null){ MEBESJobview |= MEBESJobviewCustomerFlag; }
        else{ MEBESJobview = MEBESJobviewCustomerFlag; }        
        
        Boolean tempMEBESJobviewFoundryFlag = false;
        tempMEBESJobviewFoundryFlag = mapAll.get(CSName).MEBESJobviewFoundry__c;
        this.MEBESJobviewFoundryFlag |= tempMEBESJobviewFoundryFlag;
        if(MEBESJobview != null){ MEBESJobview |= MEBESJobviewFoundryFlag; }
        else{ MEBESJobview = MEBESJobviewFoundryFlag; }        
       
        Boolean tempMEBESJobviewTapeoutCentreFlag = false;
        tempMEBESJobviewTapeoutCentreFlag = mapAll.get(CSName).MEBESJobviewTapeoutCenter__c;
        this.MEBESJobviewTapeoutCentreFlag |= tempMEBESJobviewTapeoutCentreFlag;
        if(MEBESJobview != null){ MEBESJobview |= MEBESJobviewTapeoutCentreFlag; }
        else{ MEBESJobview = MEBESJobviewTapeoutCentreFlag; }        
        
        //swgp-859
        //Boolean tempMEBESJobviewTapeoutApplicationsFlag = false;
        //tempMEBESJobviewTapeoutApplicationsFlag = mapAll.get(CSName).MEBESJobviewTapeoutAPPLICATIONS__c;
        //this.MEBESJobviewTapeoutApplicationsFlag |= tempMEBESJobviewTapeoutApplicationsFlag;
        this.MEBESJobviewTapeoutApplicationsFlag = false;
        if(MEBESJobview != null){ MEBESJobview |= MEBESJobviewTapeoutApplicationsFlag; }
        else{ MEBESJobview = MEBESJobviewTapeoutApplicationsFlag; }        
        
        Boolean tempMEBESJobviewGlobalShuttleFlag = false;
        tempMEBESJobviewGlobalShuttleFlag = mapAll.get(CSName).MEBESJobviewGlobalShuttle__c;
        this.MEBESJobviewGlobalShuttleFlag |= tempMEBESJobviewGlobalShuttleFlag;
        if(MEBESJobview != null){ MEBESJobview |= MEBESJobviewGlobalShuttleFlag; }
        else{ MEBESJobview = MEBESJobviewGlobalShuttleFlag; }        
        
        Boolean tempMEBESJobviewMDPFlag = false;
        tempMEBESJobviewMDPFlag = mapAll.get(CSName).MEBESJobviewMDP__c;
        this.MEBESJobviewMDPFlag |= tempMEBESJobviewMDPFlag;
        if(MEBESJobview != null){ MEBESJobview |= MEBESJobviewMDPFlag; }
        else{ MEBESJobview = MEBESJobviewMDPFlag; }        
      
        Boolean tempMEBESJobviewTDTIMPWFlag = false;
        tempMEBESJobviewTDTIMPWFlag = mapAll.get(CSName).MEBESJobviewTDTIMPW__c;
        this.MEBESJobviewTDTIMPWFlag |= tempMEBESJobviewTDTIMPWFlag;
        if(MEBESJobview != null){ MEBESJobview |= MEBESJobviewTDTIMPWFlag; }
        else{ MEBESJobview = MEBESJobviewTDTIMPWFlag; }        
       
        Boolean tempCustomerRemoteJobviewPrimeFlag = false;
        tempCustomerRemoteJobviewPrimeFlag = mapAll.get(CSName).CustomerRemoteJobviewPrime__c;
        this.CustomerRemoteJobviewPrimeFlag |= tempCustomerRemoteJobviewPrimeFlag;
        if(CustomerRemoteJobview != null){ CustomerRemoteJobview |= CustomerRemoteJobviewPrimeFlag; }
        else{ CustomerRemoteJobview = CustomerRemoteJobviewPrimeFlag; }        
       
        Boolean tempCustomerRemoteJobviewFrameFlag = false;
        tempCustomerRemoteJobviewFrameFlag = mapAll.get(CSName).CustomerRemoteJobviewFrame__c;
        this.CustomerRemoteJobviewFrameFlag |= tempCustomerRemoteJobviewFrameFlag;
        if(CustomerRemoteJobview != null){ CustomerRemoteJobview |= CustomerRemoteJobviewFrameFlag; }
        else{ CustomerRemoteJobview = CustomerRemoteJobviewFrameFlag; }          
       
        Boolean tempFoundryRemoteJobviewPrime = false;
        tempFoundryRemoteJobviewPrime = mapAll.get(CSName).FoundryRemoteJobviewPrime__c;
        this.FoundryRemoteJobviewPrime |= tempFoundryRemoteJobviewPrime;
        if(FoundryRemoteJobview != null){ FoundryRemoteJobview |= FoundryRemoteJobviewPrime; }
        else{ FoundryRemoteJobview = FoundryRemoteJobviewPrime; }      
       
        Boolean tempFoundryRemoteJobviewFrame = false;
        tempFoundryRemoteJobviewFrame = mapAll.get(CSName).FoundryRemoteJobviewFrame__c;
        this.FoundryRemoteJobviewFrame |= tempFoundryRemoteJobviewFrame;
        if(FoundryRemoteJobview != null){ FoundryRemoteJobview |= FoundryRemoteJobviewFrame; }
        else{ FoundryRemoteJobview = FoundryRemoteJobviewFrame; }        

       }
   }
/**
    This method is for fetching the list of customer values based on the user's access
    @method name: fetchCustomerNames
    @parameter:   None
    @return :     List of Accounts
**/
 private List<Account> fetchCustomerNames() {     
        List<Account> customerList = new List<Account>();       
        customerList.addAll(MRSHandlerUtility.fetchCustomerName());                   
        return customerList;        
 }    
public MRSLayerSummaryExtn(ApexPages.StandardController controller) { 
        
        lstSizeOne = new list<integer>{1};            
        groupFE = false;
        groupTapeoutOperation = false;
        groupMDP = false;
        groupGlobalShuttle = false;
        groupTDTIMPW = false;
        groupFoundryJobviewer = false;
        groupSwiftAdmin = false;
        groupSwiftSupport = false;
        groupTapeoutCentre = false;
        groupTapeoutApplication = false;
        groupRMG = false;
        groupTapeoutAdmin = false;
        groupCAD = false;

        SelectedLayerStatusValue = new List<String>();
        SelectedLayerStatusValue.clear(); 
            
        if(ApexPages.currentPage().getCookies().get('mst') == null||ApexPages.currentPage().getCookies().get('mst').getValue() == null || ApexPages.currentPage().getCookies().get('mst').getValue() == ''){resetLSPCookies();}
            
            if(ApexPages.currentPage().getCookies().get('maskLayer') != null && ApexPages.currentPage().getCookies().get('maskLayer').getValue() != '' && ApexPages.currentPage().getCookies().get('maskLayer').getValue() != null){  SelectedMaskLayerValue = String.valueOf(ApexPages.currentPage().getCookies().get('maskLayer').getValue());  }
            else{  SelectedMaskLayerValue = ''; }

            if(ApexPages.currentPage().getCookies().get('layerStatus') != null && ApexPages.currentPage().getCookies().get('layerStatus').getValue() != '' && ApexPages.currentPage().getCookies().get('layerStatus').getValue() != null){          
                if(String.valueOf(ApexPages.currentPage().getCookies().get('layerStatus').getValue()) == 'null'){
                    SelectedLayerStatusValue.clear();
                    ValueCatcher = '';
                }
                else{
                    SelectedLayerStatusValue = String.valueOf(ApexPages.currentPage().getCookies().get('layerStatus').getValue()).split(','); 
                    ValueCatcher = String.valueOf(ApexPages.currentPage().getCookies().get('layerStatus').getValue());                    
                }
                LayerStatusForExport = ValueCatcher; 

            }
            else{
               /* if(ApexPages.currentPage().getCookies().get('clearStatus') != null && ApexPages.currentPage().getCookies().get('clearStatus').getValue() != '' && ApexPages.currentPage().getCookies().get('clearStatus').getValue() != 'false'){
                    isClear = true;
                    ValueCatcher = '';
                    //ClearDropDowns();
                    SelectedLayerStatusValue.clear(); 
                }
                else{*/
                    ValueCatcher = DefaultLayerSummaryValues();
                    SelectedLayerStatusValue = ValueCatcher.split(',');                
               // }
            }
                
            if(ApexPages.currentPage().getCookies().get('techGeo') != null && ApexPages.currentPage().getCookies().get('techGeo').getValue() != '' && ApexPages.currentPage().getCookies().get('techGeo').getValue() != null){  SelectedTechGeoStatusValue = String.valueOf(ApexPages.currentPage().getCookies().get('techGeo').getValue());  } 
            if(ApexPages.currentPage().getCookies().get('deviceId') != null && ApexPages.currentPage().getCookies().get('deviceId').getValue() != '' && ApexPages.currentPage().getCookies().get('deviceId').getValue() != null){   SelectedDeviceIdValue = String.valueOf(ApexPages.currentPage().getCookies().get('deviceId').getValue());  }   

        String url = ApexPages.currentPage().getHeaders().get('Host');
        if(url.contains(Label.Swift_Host_URL)){  
            isBreadcrumbActive = true; 
            lookupCustomerURL = Label.Swift_VFExternal_URL+'VFCustomerLookupDialog';
            lookupMSTURL = Label.Swift_VFExternal_URL+'VFMaskSetTitleLookupDialog';
        }
        else{  
                isBreadcrumbActive =false;
                lookupCustomerURL = Label.Swift_VFInternal_URL+'VFCustomerLookupDialog';
                lookupMSTURL = Label.Swift_VFInternal_URL+'VFMaskSetTitleLookupDialog';
        }        
        if(isAll){
            isGDSOUTReview = true;
            isFrameMockupReview = true;
            isSendData = true;
            isRemoteJobView = true;
            isORC = true;
            isDRW = true;
            isMEBESReceived = true;
            isMEBESJobView = true;
        }        
        else{
            if(ApexPages.currentPage().getCookies().get('isGDSOUTReview') != null && String.valueOf(ApexPages.currentPage().getCookies().get('isGDSOUTReview').getValue()) != '' && String.valueOf(ApexPages.currentPage().getCookies().get('isGDSOUTReview').getValue()) != null){ isGDSOUTReview = (String.valueOf(ApexPages.currentPage().getCookies().get('isGDSOUTReview').getValue())=='true'?true:false); }
            else{ isGDSOUTReview = true; }

            if(ApexPages.currentPage().getCookies().get('isFrameMockupReview') != null && String.valueOf(ApexPages.currentPage().getCookies().get('isFrameMockupReview').getValue()) != '' && String.valueOf(ApexPages.currentPage().getCookies().get('isFrameMockupReview').getValue()) != null){ isFrameMockupReview = (String.valueOf(ApexPages.currentPage().getCookies().get('isFrameMockupReview').getValue())=='true'?true:false); }
            else{ isFrameMockupReview = true; }

            if(ApexPages.currentPage().getCookies().get('isSendData') != null && String.valueOf(ApexPages.currentPage().getCookies().get('isSendData').getValue()) != '' && String.valueOf(ApexPages.currentPage().getCookies().get('isSendData').getValue()) != null){ isSendData = (String.valueOf(ApexPages.currentPage().getCookies().get('isSendData').getValue())=='true'?true:false); }
            else{ isSendData = true; }

            if(ApexPages.currentPage().getCookies().get('isRemoteJobView') != null && String.valueOf(ApexPages.currentPage().getCookies().get('isRemoteJobView').getValue()) != '' && String.valueOf(ApexPages.currentPage().getCookies().get('isRemoteJobView').getValue()) != null){ isRemoteJobView = (String.valueOf(ApexPages.currentPage().getCookies().get('isRemoteJobView').getValue())=='true'?true:false); }
            else{ isRemoteJobView = true; }

            if(ApexPages.currentPage().getCookies().get('isORC') != null && String.valueOf(ApexPages.currentPage().getCookies().get('isORC').getValue()) != '' && String.valueOf(ApexPages.currentPage().getCookies().get('isORC').getValue()) != null){ isORC = (String.valueOf(ApexPages.currentPage().getCookies().get('isORC').getValue())=='true'?true:false); }
            else{ isORC = true; }

            if(ApexPages.currentPage().getCookies().get('isDRW') != null && String.valueOf(ApexPages.currentPage().getCookies().get('isDRW').getValue()) != '' && String.valueOf(ApexPages.currentPage().getCookies().get('isDRW').getValue()) != null){ isDRW = (String.valueOf(ApexPages.currentPage().getCookies().get('isDRW').getValue())=='true'?true:false); }
            else{ isDRW = true; }

            if(ApexPages.currentPage().getCookies().get('isMEBESReceived') != null && String.valueOf(ApexPages.currentPage().getCookies().get('isMEBESReceived').getValue()) != '' && String.valueOf(ApexPages.currentPage().getCookies().get('isMEBESReceived').getValue()) != null){ isMEBESReceived = (String.valueOf(ApexPages.currentPage().getCookies().get('isMEBESReceived').getValue())=='true'?true:false);  }
            else{  isMEBESReceived = true; }

            if(ApexPages.currentPage().getCookies().get('isMEBESJobView') != null && String.valueOf(ApexPages.currentPage().getCookies().get('isMEBESJobView').getValue()) != '' && String.valueOf(ApexPages.currentPage().getCookies().get('isMEBESJobView').getValue()) != null){ isMEBESJobView = (String.valueOf(ApexPages.currentPage().getCookies().get('isMEBESJobView').getValue())=='true'?true:false); }
            else{ isMEBESJobView = true; }

        }

        TechGeoDisplayFlag = false;

        ignoreFlagValues = false;

        lstmst = new List<SelectOption>();    
        isCustomer = false;     
        showLabel = false;
        lstmst.add(new SelectOption('',''));

        List<AggregateResult> aggMST = new List<AggregateResult>();  

        InitiateDropDowns();
        isFirstFramePTRF = false;      
        internalView = false;
        String hostName = ApexPages.currentPage().getHeaders().get('Host');
        if(!String.isBlank(System.Label.Internal_URL) && System.Label.Internal_URL.containsIgnoreCase(hostName)) { internalView = true; }
        else { internalView = false; }     
          
        User loggedInUser =[SELECT Id,AccountId,Name,ProfileId FROM User WHERE Id =:UserInfo.getUserId()];
        if(String.valueOf(loggedInUser.AccountId) != null && String.valueOf(loggedInUser.AccountId) != ''){ isCustomer = true; }
        else{ isCustomer = false; }
        if([SELECT Team_Role__c, User__c FROM Account_Team_Proxy__c WHERE Team_Role__c IN:SWIFT_FE_ROLES and User__c =:loggedInUser.Id].size()>0){ groupFE = true; }
        else{ groupFE = false; }
        //RestrictFieldValues(loggedInUser.Id, isCustomer, groupFE, loggedInUser.ProfileId); 
        //OriginalORC |= ORCFlag;
        //OriginalDRW |= DRWFlag;                    

        Profile sysAdminProfile = [select Id, Name from Profile where Name = 'System Administrator' LIMIT 1];
        Profile FEProfile = [SELECT Id,Name FROM Profile WHERE Name = 'GF FAE/FTS'];
        List<PTRF_JobViewer_Info__c> PTRFInFoundryJobview = [select Id,PTRF__c from PTRF_JobViewer_Info__c where Jobview__c = 'Foundry' and User__c =:UserInfo.getUserId()];
        
        lstCustomerList.clear();
        lstCustomerList.addAll(fetchCustomerNames());
        if(lstCustomerList !=null && !lstCustomerList.isEmpty())
        {
            
            try {
            if(ApexPages.currentPage().getCookies().get('account') ==  null||ApexPages.currentPage().getCookies().get('account').getValue() ==  '' || ApexPages.currentPage().getCookies().get('account').getValue() ==  null){               
                if(lstCustomerList.size()>0 && lstCustomerList.size()<2) 
                {
                    

                    
                    if(String.valueOf(loggedInUser.AccountId) != null && String.valueOf(loggedInUser.AccountId) != ''){ isCustomer = true; }
                    else{ isCustomer = false; }
                    showLabel =true;

                    if([SELECT Team_Role__c, User__c FROM Account_Team_Proxy__c WHERE Team_Role__c IN:SWIFT_FE_ROLES and User__c =:loggedInUser.Id].size()>0){ groupFE = true; }
                    else{ groupFE = false; }
                    selectedCustomer =String.valueOf(lstCustomerList.get(0).Id);
                    selectedCustomerName =String.valueOf(lstCustomerList.get(0).Name);    
                    if(url.contains(Label.Swift_Host_URL)){lookupMSTURL= Label.Swift_VFExternal_URL+'VFMaskSetTitleLookupDialog'+'?aid='+selectedCustomer+'&pg=LayerSummary&jv=false';}
                    else{lookupMSTURL= Label.Swift_VFInternal_URL+'VFMaskSetTitleLookupDialog'+'?aid='+selectedCustomer+'&pg=LayerSummary&jv=false';}                                                 


                    if(lstCustomerList.get(0).Short_Name__c != null && lstCustomerList.get(0).Short_Name__c != ''){ selectedCustomerName+= ' ('+String.valueOf(lstCustomerList.get(0).Short_Name__c)+')'; }    
                  
                    CustomerNameIdMap.put(selectedCustomer,selectedCustomerName);
                    ClsMyDevices.account = new Cookie('account',selectedCustomer,null,-1,false);
                    ApexPages.currentPage().setCookies(new Cookie[]{ClsMyDevices.account});
                    RestrictFieldValues(loggedInUser.Id, isCustomer, groupFE, loggedInUser.ProfileId); 
                    OriginalORC |= ORCFlag;
                    OriginalDRW |= DRWFlag;
                    /**TASK-2301**/
                    List<AggregateResult> tempPTRFList = [SELECT MaskSetTitle__c,MaskSetTitle__r.Name FROM PTRF__c WHERE Customer__c =:selectedCustomer and MaskSetTitle__c != null and MaskSetTitle__r.Name != null group by MaskSetTitle__c,MaskSetTitle__r.Name];
                    system.debug('&&&&&&& tempPTRFList size : '+tempPTRFList.size()+' Customer : '+selectedCustomer);
                    if(tempPTRFList.size() == 1){
                        selectedmst = String.valueOf(tempPTRFList.get(0).get('Name'));
                        MSTIDString = String.valueOf(tempPTRFList.get(0).get('MaskSetTitle__c'));
                        ClsMyDevices.mst = new Cookie('mst',MSTIDString,null,-1,false);
                        ApexPages.currentPage().setCookies(new Cookie[]{ClsMyDevices.mst});      
                        //SingleMSTValue = true;
                        
                        if(selectedCustomer != null && selectedCustomer != '' && selectedmst != null && selectedmst != '') {DirectCallToValues = true;ignoreFlagValues = true; switch(); }
                    } 
                     /**TASK-2301**/                    

                }else 
                {
                    isCustomer = false;
                    showLabel = false;

                    if([SELECT Team_Role__c, User__c FROM Account_Team_Proxy__c WHERE Team_Role__c IN:SWIFT_FE_ROLES and User__c =:loggedInUser.Id].size()>0){
                        groupFE = true;
                        isCustomer = false;
                        
                        RestrictFieldValues(loggedInUser.Id, isCustomer, groupFE, loggedInUser.ProfileId);
                        OriginalORC |= ORCFlag;
                        OriginalDRW |= DRWFlag;                        
                    }
                    else 
                    {
                        groupFE = false;
                        isCustomer = false;
                        RestrictFieldValues(loggedInUser.Id, isCustomer, groupFE, loggedInUser.ProfileId);
                        OriginalORC |= ORCFlag;
                        OriginalDRW |= DRWFlag;

                    }
                }
              
          } 

        else{             
                if(ApexPages.currentPage().getCookies().get('account') != null && ApexPages.currentPage().getCookies().get('account').getValue() != null){
                if(url.contains(Label.Swift_Host_URL)){lookupMSTURL= Label.Swift_VFExternal_URL+'VFMaskSetTitleLookupDialog'+'?aid='+String.valueOf(ApexPages.currentPage().getCookies().get('account').getValue())+'&pg=LayerSummary&jv=false';}
                else{lookupMSTURL= Label.Swift_VFInternal_URL+'VFMaskSetTitleLookupDialog'+'?aid='+String.valueOf(ApexPages.currentPage().getCookies().get('account').getValue())+'&pg=LayerSummary&jv=false';}                                }
                
                selectedCustomer = String.valueOf(ApexPages.currentPage().getCookies().get('account').getValue());
                
                List<Account> AccList = [select Id, Name, Short_Name__c from Account where Id =:selectedCustomer];
                selectedCustomerName = AccList.get(0).Name + ' ('+AccList.get(0).Short_Name__c+')';
                List<AggregateResult> tempPTRFList = [SELECT MaskSetTitle__c,MaskSetTitle__r.Name FROM PTRF__c WHERE Customer__c =:selectedCustomer and MaskSetTitle__c != null and MaskSetTitle__r.Name != null group by MaskSetTitle__c,MaskSetTitle__r.Name];
                if(tempPTRFList.size() == 1){
                    selectedmst = String.valueOf(tempPTRFList.get(0).get('Name'));
                    MSTIDString = String.valueOf(tempPTRFList.get(0).get('MaskSetTitle__c'));
                    ClsMyDevices.mst = new Cookie('mst',MSTIDString,null,-1,false);
                    ApexPages.currentPage().setCookies(new Cookie[]{ClsMyDevices.mst});      
                    //SingleMSTValue = true;
                    RestrictFieldValues(loggedInUser.Id, isCustomer, groupFE, loggedInUser.ProfileId); 
                    OriginalORC |= ORCFlag;
                    OriginalDRW |= DRWFlag;                     
                    if(selectedCustomer != null && selectedCustomer != '' && selectedmst != null && selectedmst != '') {DirectCallToValues = true;ignoreFlagValues = true; switch(); }
                }
                else{                    
                    SingleMSTValue = false;
                    
                    if(lstCustomerList.size()>0 && lstCustomerList.size()<2) 
                    {
                        showLabel =true;
                        
                        if(String.valueOf(loggedInUser.AccountId) != null && String.valueOf(loggedInUser.AccountId) != ''){ isCustomer = true; }
                        else{ isCustomer = false;  }
                        if([SELECT Team_Role__c, User__c FROM Account_Team_Proxy__c WHERE Team_Role__c IN:SWIFT_FE_ROLES and User__c =:loggedInUser.Id].size()>0){  groupFE = true; }
                        else{ groupFE = false; }
                        selectedCustomer =String.valueOf(lstCustomerList.get(0).Id);
                        selectedCustomerName =String.valueOf(lstCustomerList.get(0).Name);                     
                        if(url.contains(Label.Swift_Host_URL)){lookupMSTURL= Label.Swift_VFExternal_URL+'VFMaskSetTitleLookupDialog'+'?aid='+selectedCustomer+'&pg=LayerSummary&jv=false';}
                        else{lookupMSTURL= Label.Swift_VFInternal_URL+'VFMaskSetTitleLookupDialog'+'?aid='+selectedCustomer+'&pg=LayerSummary&jv=false';}                                                 
                            
                        if(lstCustomerList.get(0).Short_Name__c != null && lstCustomerList.get(0).Short_Name__c != ''){ selectedCustomerName+= ' ('+String.valueOf(lstCustomerList.get(0).Short_Name__c)+')'; } 
                          
                        CustomerNameIdMap.put(selectedCustomer, selectedCustomerName);
                        ClsMyDevices.account = new Cookie('account',selectedCustomer,null,-1,false);
                        ApexPages.currentPage().setCookies(new Cookie[]{ClsMyDevices.account});
                        RestrictFieldValues(loggedInUser.Id, isCustomer, groupFE, loggedInUser.ProfileId); 
                        OriginalORC |= ORCFlag;
                        OriginalDRW |= DRWFlag;
                        if(ApexPages.currentPage().getCookies().get('mst') != null && ApexPages.currentPage().getCookies().get('mst').getValue() != '' && ApexPages.currentPage().getCookies().get('mst').getValue() != null){
                            String mstValuefromCookie = '';
                            mstValuefromCookie = String.valueOf(ApexPages.currentPage().getCookies().get('mst').getValue());
                            tempMST = new Mask_Set_Title__C();
                            tempMST = [select Id, Name from Mask_Set_Title__C where Id =:mstValuefromCookie];  
                            selectedmst = String.valueOf(tempMST.Name);   
                            MSTIDString = String.valueOf(tempMST.Id);                   
                            aggMST.clear();
                            tempMST.clear();
                        }
                        else{ selectedmst = ''; }  

                    }else 
                    {
                        selectedCustomer = String.valueOf(ApexPages.currentPage().getCookies().get('account').getValue());
                        List<Account> acct = new List<Account>();
                        acct = [select Id, Name, Short_Name__c from Account where Id =:selectedCustomer];
                        if(acct.size()>0 && acct.size()<2){
                            selectedCustomerName = String.valueOf(acct.get(0).Name);   
                            if(acct.get(0).Short_Name__c != null && acct.get(0).Short_Name__c != ''){ selectedCustomerName+= ' ('+String.valueOf(acct.get(0).Short_Name__c)+')';  }  
                                          
                        }
                        else{  selectedCustomerName = '';  }
                        isCustomer = false;
                        showLabel = false;

    
                        if([SELECT Team_Role__c, User__c FROM Account_Team_Proxy__c WHERE Team_Role__c IN:SWIFT_FE_ROLES and User__c =:loggedInUser.Id].size()>0){ // If FE
                            groupFE = true;
                            isCustomer = false;
                            RestrictFieldValues(loggedInUser.Id, isCustomer, groupFE, loggedInUser.ProfileId);
                            OriginalORC |= ORCFlag;
                            OriginalDRW |= DRWFlag;
                        }
                        else 
                        {
                            groupFE = false;
                            isCustomer = false;
                            RestrictFieldValues(loggedInUser.Id, isCustomer, groupFE, loggedInUser.ProfileId);
                            OriginalORC |= ORCFlag;
                            OriginalDRW |= DRWFlag;

                        }                     
                    }                                 
                    if(ApexPages.currentPage().getCookies().get('mst') != null && ApexPages.currentPage().getCookies().get('mst').getValue() != '' && ApexPages.currentPage().getCookies().get('mst').getValue() != null){
                        String mstValuefromCookie = '';
                        mstValuefromCookie = String.valueOf(ApexPages.currentPage().getCookies().get('mst').getValue());
                        tempMST = new Mask_Set_Title__C();
                        tempMST = [select Id, Name from Mask_Set_Title__C where Id =:mstValuefromCookie];
                        selectedmst = String.valueOf(tempMST.Name);
                        MSTIDString = String.valueOf(tempMST.Id);
                        aggMST.clear();

                        
                        if([select Layer__r.MRS__r.Mask_Set_Title__r.Name,Layer__r.Tech_Geo__c from MRS_Layer_Chip_Association__c WHERE Customer_Name__c =:selectedCustomer group by Layer__r.MRS__r.Mask_Set_Title__r.Name,Layer__r.Tech_Geo__c].size()<1){ selectedmst = null;  }   
                        tempMST.clear();                 
                    }
                    else{  selectedmst = '';   }
 
                    if(selectedCustomer != null && selectedCustomer != '' && selectedmst != null && selectedmst != ''){ DirectCallToValues = true;ignoreFlagValues = true; switch(); }

                }
             }
           }
          catch(Exception e) {  System.debug('The following exception has occurred: ' + e.getMessage());  }
        } 
        else
        {
            groupFE = false;
            isCustomer = false;
            RestrictFieldValues(loggedInUser.Id, isCustomer, groupFE, loggedInUser.ProfileId);
            OriginalORC |= ORCFlag;
            OriginalDRW |= DRWFlag;

        }
        
        // privileges for calc status link
        viewLink = getCalcLinkPrivilege();
  }   

/**
    This is the wrapper class for displaying values in Layer Summary page
**/
    public class LayerSummaryWrapper{        
            public String  Customer_Frame_Remote_Jobview_Setup_Date{get;set;}
            public String Customer_Prime_Remote_Jobview_Setup_Date{get;set;}
            public String Customer_Frame_Mockup_Date{get;set;}
            public String Customer_GDSOUT_Review_Date{get;set;}
            public String Customer_MEBES_Jobview_Date{get;set;}
            public String DRW_Date{get;set;}
            public String Foundry_Frame_Remote_Jobview_Setup_Date{get;set;}
            public String Foundry_Prime_Remote_Jobview_Setup_Date{get;set;}
            public String Foundry_Frame_Mockup_Date{get;set;}
            public String Foundry_GDSOUT_Review_Date{get;set;}
            public String Foundry_MEBES_Jobview_Date{get;set;}
            public String Frame_MEBES_Received_Date{get;set;}
            public String GlobalShuttle_MEBES_Jobview_Date{get;set;}
            public String Layer_Status_Date{get;set;}
            public String MDP_MEBES_Jobview_Date{get;set;}
            public String ORC_Date{get;set;}
            public String Prime_MEBES_Received_Date{get;set;}
            public String Send_Frame_Data_Date{get;set;}
            public String Send_Prime_Data_Date{get;set;}
            public String Tapeout_Applications_MEBES_Jobview_Date{get;set;}
            public String Tapeout_Centre_MEBES_Jobview_Date{get;set;}
            public String TDTI_MPW_MEBES_Jobview_Date{get;set;}
    
            public String userTimeStamp{get; set;}
            public MRS_Layer_Association__c OrigObj{get; set;}
            public LayerSummaryWrapper(MRS_Layer_Association__c objMRSLCA, String Customer_Frame_Remote_Jobview_Setup_Date,String Customer_Prime_Remote_Jobview_Setup_Date,String Customer_Frame_Mockup_Date,String Customer_GDSOUT_Review_Date,String Customer_MEBES_Jobview_Date,String DRW_Date,String Foundry_Frame_Remote_Jobview_Setup_Date,String Foundry_Prime_Remote_Jobview_Setup_Date,String Foundry_Frame_Mockup_Date,String Foundry_GDSOUT_Review_Date,String Foundry_MEBES_Jobview_Date,String Frame_MEBES_Received_Date,String GlobalShuttle_MEBES_Jobview_Date,String Layer_Status_Date,String MDP_MEBES_Jobview_Date,String ORC_Date,String Prime_MEBES_Received_Date,String Send_Frame_Data_Date,String Send_Prime_Data_Date,String Tapeout_Applications_MEBES_Jobview_Date,String Tapeout_Centre_MEBES_Jobview_Date,String TDTI_MPW_MEBES_Jobview_Date) {
            this.OrigObj = objMRSLCA;
            this.Customer_Frame_Remote_Jobview_Setup_Date = Customer_Frame_Remote_Jobview_Setup_Date;
            this.Customer_Prime_Remote_Jobview_Setup_Date =  Customer_Prime_Remote_Jobview_Setup_Date;
            this.Customer_Frame_Mockup_Date = Customer_Frame_Mockup_Date;
            this.Customer_GDSOUT_Review_Date = Customer_GDSOUT_Review_Date;
            this.userTimeStamp = Customer_GDSOUT_Review_Date;
            this.Customer_MEBES_Jobview_Date = Customer_MEBES_Jobview_Date;
            this.DRW_Date =  DRW_Date;
            this.Foundry_Frame_Remote_Jobview_Setup_Date = Foundry_Frame_Remote_Jobview_Setup_Date;
            this.Foundry_Prime_Remote_Jobview_Setup_Date = Foundry_Prime_Remote_Jobview_Setup_Date;
            this.Foundry_Frame_Mockup_Date = Foundry_Frame_Mockup_Date;
            this.Foundry_GDSOUT_Review_Date = Foundry_GDSOUT_Review_Date;
            this.Foundry_MEBES_Jobview_Date = Foundry_MEBES_Jobview_Date;
            this.Frame_MEBES_Received_Date = Frame_MEBES_Received_Date;
            this.GlobalShuttle_MEBES_Jobview_Date = GlobalShuttle_MEBES_Jobview_Date;
            this.Layer_Status_Date = Layer_Status_Date;
            this.MDP_MEBES_Jobview_Date = MDP_MEBES_Jobview_Date;
            this.ORC_Date = ORC_Date;
            this.Prime_MEBES_Received_Date = Prime_MEBES_Received_Date;
            this.Send_Frame_Data_Date = Send_Frame_Data_Date;
            this.Send_Prime_Data_Date = Send_Prime_Data_Date;
            this.Tapeout_Applications_MEBES_Jobview_Date = Tapeout_Applications_MEBES_Jobview_Date;
            this.Tapeout_Centre_MEBES_Jobview_Date = Tapeout_Centre_MEBES_Jobview_Date;
            this.TDTI_MPW_MEBES_Jobview_Date = TDTI_MPW_MEBES_Jobview_Date;
            if(this.OrigObj.Tech_Geo__c != NULL && this.OrigObj.Tech_Geo__c != 'NULL' && !this.OrigObj.Tech_Geo__c.toUppercase().contains('UM')){  this.OrigObj.Tech_Geo__c +='UM';  }
            if(this.OrigObj.Tech_Geo__c != NULL && this.OrigObj.Tech_Geo__c != 'NULL' && !this.OrigObj.Tech_Geo__c.toLowercase().contains('nm')){
                Double TechGeoValue = double.valueOf(this.OrigObj.Tech_Geo__c.toUppercase().substringBefore('UM').trim());
                    if(TechGeoValue != NULL && TechGeoValue<0.1){  this.OrigObj.Tech_Geo__c = this.OrigObj.Tech_Geo__c + ' (' + Integer.valueOf(TechGeoValue*1000) + 'nm)'; }
            }
        }

    }  
        
/**
    This is the method for sorting the layers prior to display
    @method name: sortMaskLayer
    @parameter:   
                1)List of PTRF (String) for the customer and mask set title selection
                2)List of Layer Summary wrapper object containing values for customer and mask set title selection
    @return :     List of Layer Summary wrapper object
**/
    public List<LayerSummaryWrapper> sortMaskLayer(List<String> PTRFList, List<LayerSummaryWrapper> LayerObj){
        List<LayerSummaryWrapper> WrapperList = new List<LayerSummaryWrapper>();
        List<LayerSummaryWrapper> tempWrapperList = new List<LayerSummaryWrapper>();
        List<LayerSummaryWrapper> tempAppenderList = new List<LayerSummaryWrapper>();
        Map<String,List<Mask_Layer__c>> firstFramePTRFMap = new Map<String,List<Mask_Layer__c>>();
        Map<String,List<Mask_Layer__c>> firstPrimePTRFMap = new Map<String,List<Mask_Layer__c>>();
        Map<String,List<Mask_Layer__c>> PTRFTrueMap = new Map<String,List<Mask_Layer__c>>();
        Map<String,List<LayerSummaryWrapper>> MapLayerObjToName = new Map<String,List<LayerSummaryWrapper>>();
        Map<String,List<LayerSummaryWrapper>> WrapperMap = new Map<String,List<LayerSummaryWrapper>>();
        List<Mask_Layer__c> firstFramePTRF = new List<Mask_Layer__c>();
        List<Mask_Layer__c> firstPrimePTRF = new List<Mask_Layer__c>();
        List<Mask_Layer__c> TempMaskLayerList = new List<Mask_Layer__c>();
        List<Mask_Layer__c> PTRFTrueList = new List<Mask_Layer__c>();
        List<AggregateResult> AggResult = new List<AggregateResult>();
        Boolean isFramePTRF = false;
        Boolean isPrimePTRF = false;
        String firstFrameId = NULL;
        String firstPrimeId = NULL;
        
            
        for(LayerSummaryWrapper newLayerObj : LayerObj) {
            if(MapLayerObjToName.containsKey(newLayerObj.OrigObj.Name)) {
                List<LayerSummaryWrapper> LayerList = MapLayerObjToName.get(newLayerObj.OrigObj.Name);
                LayerList.add(newLayerObj);
                MapLayerObjToName.put(newLayerObj.OrigObj.Name, LayerList);
            } 
    else { MapLayerObjToName.put(newLayerObj.OrigObj.Name, new List<LayerSummaryWrapper> { newLayerObj }); }
        }

        tempAppenderList.clear();
        Map<String,String> TheMap = new Map<String,String>();
        Set<String> PTRFSet = new Set<String>();
        List<String> PTRFSortList = new List<String>();
        List<String> PTRFSortListAfterPrimeFrameCheck = new List<String>();
        AggResult = [select PTRF__c from MRS_Layer_Chip_Association__c where PTRF__c in:PTRFList group by PTRF__C ORDER BY min(CreatedDate) ASC];

        for(AggregateResult obj : AggResult){ PTRFSortList.add(String.valueOf(obj.get('PTRF__c')));  }

      Map<Id,Boolean> CheckForFrameTapeout = new Map<Id,Boolean>();
        List<PTRF__c> listPTRF = [select Id,Frame_Tapeout__c from PTRF__c where Id in:PTRFSortList];
        
    for(PTRF__c t : listPTRF){  CheckForFrameTapeout.put(t.Id,t.Frame_Tapeout__c);  }  
        
    for(String PTRFId : PTRFSortList){
            Boolean isPresentFrame= CheckForFrameTapeout.get(PTRFId);
            TempMaskLayerList = PTRFtoLayerMap.get(PTRFId);
            if(TempMaskLayerList != NULL){
                if(!isFramePTRF){ 
                    if(isPresentFrame){ 
                        isFramePTRF = true;
                        firstFrameId = PTRFId;
                    }
                    else{
                        if(!isPrimePTRF){ 
                            isPrimePTRF = true;
                            firstPrimeId = PTRFId; 
                        }
                    }
                }
            }      
        }
        if(isFramePTRF && firstFrameId != NULL){
                    firstFramePTRF = PTRFtoLayerMap.get(firstFrameId);
                    PTRFSortListAfterPrimeFrameCheck.add(String.valueOf(firstFrameId));
        }
        else{
            if(firstPrimeId != NULL && isPrimePTRF){
                    firstPrimePTRF = PTRFtoLayerMap.get(firstPrimeId);
                    PTRFSortListAfterPrimeFrameCheck.add(String.valueOf(firstPrimeId));
            }
        }
        List<Mask_Layer__c> currentPTRF = new List<Mask_Layer__c>();
        for(String PTRFId : PTRFSortList){
            currentPTRF.clear();
            if(isFramePTRF && firstFrameId != NULL){
                if(PTRFId != firstFrameId){  PTRFSortListAfterPrimeFrameCheck.add(PTRFId);   }
            }
            else{
                if(firstPrimeId != NULL && isPrimePTRF){
                    if(PTRFId != firstPrimeId){   PTRFSortListAfterPrimeFrameCheck.add(PTRFId);    }
                }
            }
        }
        for(String strSortedPTRF : PTRFSortListAfterPrimeFrameCheck){
            currentPTRF = PTRFtoLayerMap.get(strSortedPTRF);
            if(currentPTRF != NULL){
                for(Mask_Layer__c currentMaskLayer : currentPTRF){
                    List<LayerSummaryWrapper> presentInList = MapLayerObjToName.get(currentMaskLayer.Mask_Layer_Number__c);
                    List<LayerSummaryWrapper> ListDeltaCheck = WrapperMap.get(currentMaskLayer.Mask_Layer_Number__c);
                    if(presentInList != NULL){
                        if(ListDeltaCheck == NULL){
                            WrapperList.addAll(presentInList);
                            WrapperMap.clear();
                            for(LayerSummaryWrapper newLayerObj : WrapperList) {
                                if(WrapperMap.containsKey(newLayerObj.OrigObj.Name)) {
                                    List<LayerSummaryWrapper> LayerList = WrapperMap.get(newLayerObj.OrigObj.Name);
                                    LayerList.add(newLayerObj);
                                    WrapperMap.put(newLayerObj.OrigObj.Name, LayerList);
                                } 
                else {   WrapperMap.put(newLayerObj.OrigObj.Name, new List<LayerSummaryWrapper> { newLayerObj });  }
                            }
                        }
                    }
                }
            }
        }       
        
        return WrapperList;
    }

/**
    This is the wrapper method invoking the mask layer sorting and generating the final list for display in Layer Summary page
    @method name: getMasterData
    @parameter:   None
    @return :     List of Layer Summary wrapper object
**/    
    public List<LayerSummaryWrapper> getMasterData(){
        //if(!SizeExceeded){
        ListObj.clear();
        
        postSortValues.clear();
        Map<Id,String> DispositionMap = new Map<Id,String>();
        List<Id> ListOfId = new List<Id>();
        for(MRS_Layer_Association__c temp : masterMRSObj) {  ListOfId.add(temp.Id);  }

        List<AggregateResult> agg = [SELECT PTRF__r.DRW_Disposition__c,Layer__c FROM MRS_Layer_Chip_Association__c WHERE Layer__c in:ListOfId group by PTRF__r.DRW_Disposition__c,Layer__c];  
        for(AggregateResult a : agg){
            String Disp = '';
            if(String.valueOf(a.get('DRW_Disposition__c')) != null){  Disp = String.valueOf(a.get('DRW_Disposition__c'));  }
            DispositionMap.put(String.valueOf(a.get('Layer__c')),Disp);
        }    
        for(MRS_Layer_Association__c temp : masterMRSObj)
        {
            String timestamp = '';
            String tempCustomer_Frame_Remote_Jobview_Setup_Date  = '';
            String tempCustomer_Prime_Remote_Jobview_Setup_Date  = '';
            String tempCustomer_Frame_Mockup_Date  = '';
            String tempCustomer_GDSOUT_Review_Date  = '';
            String tempuserTimeStamp  = '';
            String tempCustomer_MEBES_Jobview_Date  = '';
            String tempDRW_Date  = '';
            String tempFoundry_Frame_Remote_Jobview_Setup_Date  = '';
            String tempFoundry_Prime_Remote_Jobview_Setup_Date  = '';
            String tempFoundry_Frame_Mockup_Date  = '';
            String tempFoundry_GDSOUT_Review_Date  = '';
            String tempFoundry_MEBES_Jobview_Date  = '';
            String tempFrame_MEBES_Received_Date  = '';
            String tempGlobalShuttle_MEBES_Jobview_Date  = '';
            String tempLayer_Status_Date  = '';
            String tempMDP_MEBES_Jobview_Date  = '';
            String tempORC_Date  = '';
            String tempPrime_MEBES_Received_Date  = '';
            String tempSend_Frame_Data_Date  = '';
            String tempSend_Prime_Data_Date  = '';
            String tempTapeout_Applications_MEBES_Jobview_Date  = '';
            String tempTapeout_Centre_MEBES_Jobview_Date  = '';
            String tempTDTI_MPW_MEBES_Jobview_Date  = '';
                        
            if( temp.Customer_Frame_Remote_Jobview_Setup_Date__c != NULL) {  tempCustomer_Frame_Remote_Jobview_Setup_Date  =  temp.Customer_Frame_Remote_Jobview_Setup_Date__c.format();}

            if( temp.Customer_Prime_Remote_Jobview_Setup_Date__c != NULL) {  tempCustomer_Prime_Remote_Jobview_Setup_Date  =  temp.Customer_Prime_Remote_Jobview_Setup_Date__c.format();}

            if( temp.Customer_Frame_Mockup_Date__c != NULL) {  tempCustomer_Frame_Mockup_Date  =  temp.Customer_Frame_Mockup_Date__c.format();}
            if( temp.Customer_GDSOUT_Review_Date__c != NULL) {  tempCustomer_GDSOUT_Review_Date  =  temp.Customer_GDSOUT_Review_Date__c.format();}
            if( temp.Customer_MEBES_Jobview_Date__c != NULL) {  tempCustomer_MEBES_Jobview_Date  =  temp.Customer_MEBES_Jobview_Date__c.format();}

            if(temp.DRW_Date__c != null && String.valueOf(temp.DRW__c).equalsIgnoreCase('Done')){   tempDRW_Date = DispositionMap.get(temp.Id)+' '+temp.DRW_Date__c.format();   }
            else{
                if(temp.DRW_Date__c != null){  tempDRW_Date  =  temp.DRW_Date__c.format();   }
            }

            if( temp.Foundry_Frame_Remote_Jobview_Setup_Date__c != NULL) {  tempFoundry_Frame_Remote_Jobview_Setup_Date  =  temp.Foundry_Frame_Remote_Jobview_Setup_Date__c.format();}

            if( temp.Foundry_Prime_Remote_Jobview_Setup_Date__c != NULL) {  tempFoundry_Prime_Remote_Jobview_Setup_Date  =  temp.Foundry_Prime_Remote_Jobview_Setup_Date__c.format();}

            if( temp.Foundry_Frame_Mockup_Date__c != NULL) {  tempFoundry_Frame_Mockup_Date  =  temp.Foundry_Frame_Mockup_Date__c.format();}
            if( temp.Foundry_GDSOUT_Review_Date__c != NULL) {  tempFoundry_GDSOUT_Review_Date  =  temp.Foundry_GDSOUT_Review_Date__c.format();}
            if( temp.Foundry_MEBES_Jobview_Date__c != NULL) {  tempFoundry_MEBES_Jobview_Date  =  temp.Foundry_MEBES_Jobview_Date__c.format();}
            if( temp.Frame_MEBES_Received_Date__c != NULL) {  tempFrame_MEBES_Received_Date  =  temp.Frame_MEBES_Received_Date__c.format();}
            if( temp.GlobalShuttle_MEBES_Jobview_Date__c != NULL) {  tempGlobalShuttle_MEBES_Jobview_Date  =  temp.GlobalShuttle_MEBES_Jobview_Date__c.format();}
            if( temp.Layer_Status_Date__c != NULL) {  tempLayer_Status_Date  =  temp.Layer_Status_Date__c.format();}
            if( temp.MDP_MEBES_Jobview_Date__c != NULL) {  tempMDP_MEBES_Jobview_Date  =  temp.MDP_MEBES_Jobview_Date__c.format();}
            if( temp.ORC_Date__c != NULL) {  tempORC_Date  =  temp.ORC_Date__c.format();}
            if( temp.Prime_MEBES_Received_Date__c != NULL) {  tempPrime_MEBES_Received_Date  =  temp.Prime_MEBES_Received_Date__c.format();}
            if( temp.Send_Frame_Data_Date__c != NULL) {  tempSend_Frame_Data_Date  =  temp.Send_Frame_Data_Date__c.format();}
            if( temp.Send_Prime_Data_Date__c != NULL) {  tempSend_Prime_Data_Date  =  temp.Send_Prime_Data_Date__c.format();}
            if( temp.Tapeout_Applications_MEBES_Jobview_Date__c != NULL) {  tempTapeout_Applications_MEBES_Jobview_Date  =  temp.Tapeout_Applications_MEBES_Jobview_Date__c.format();}
            if( temp.Tapeout_Centre_MEBES_Jobview_Date__c != NULL) {  tempTapeout_Centre_MEBES_Jobview_Date  =  temp.Tapeout_Centre_MEBES_Jobview_Date__c.format();}
            if( temp.TDTI_MPW_MEBES_Jobview_Date__c != NULL) {  tempTDTI_MPW_MEBES_Jobview_Date  =  temp.TDTI_MPW_MEBES_Jobview_Date__c.format();}
                                                
            ListObj.add(new LayerSummaryWrapper(temp,tempCustomer_Frame_Remote_Jobview_Setup_Date,tempCustomer_Prime_Remote_Jobview_Setup_Date,tempCustomer_Frame_Mockup_Date,tempCustomer_GDSOUT_Review_Date,tempCustomer_MEBES_Jobview_Date,tempDRW_Date,tempFoundry_Frame_Remote_Jobview_Setup_Date,tempFoundry_Prime_Remote_Jobview_Setup_Date,tempFoundry_Frame_Mockup_Date,tempFoundry_GDSOUT_Review_Date,tempFoundry_MEBES_Jobview_Date,tempFrame_MEBES_Received_Date,tempGlobalShuttle_MEBES_Jobview_Date,tempLayer_Status_Date,tempMDP_MEBES_Jobview_Date,tempORC_Date,tempPrime_MEBES_Received_Date,tempSend_Frame_Data_Date,tempSend_Prime_Data_Date,tempTapeout_Applications_MEBES_Jobview_Date,tempTapeout_Centre_MEBES_Jobview_Date,tempTDTI_MPW_MEBES_Jobview_Date));            
        }
        
        Set<LayerSummaryWrapper> LSWSet = new Set<LayerSummaryWrapper>();
        if(requirement4 == null){  requirement4 = new List<LayerSummaryWrapper>();  }
        if(ListObj.size()>1){    
            postSortValues = sortMaskLayer(listOfPTRFIDs,ListObj);
            finalLSList.addAll(postSortValues);

            requirement4.addAll(finalLSList);
        }
        else{   requirement4.addAll(ListObj);  }
        ViewStateCleanUp();
        
        return requirement4;

    } 
    
/**
    This is the method clearing temporary variable values after the transaction
    @method name: ViewStateCleanUp
    @parameter:   None
    @return :     None
**/
    public void ViewStateCleanUp(){
        if(ChipLayerValues != null && ChipLayerValues.size()>0){   ChipLayerValues.clear();   }
        CustomerNameIdMap.clear();

        if(listOfPTRFIDs != null && listOfPTRFIDs.size()>0){  listOfPTRFIDs.clear();  }
        if(mapAll != null && mapAll.size()>0){  mapAll.clear();  }
        if(MRSChipDetailsId != null && MRSChipDetailsId.size()>0){   MRSChipDetailsId.clear();   }
        if(PTRFList != null && PTRFList.size()>0){  PTRFList.clear();  }
        if(PTRFListForRecticle != null && PTRFListForRecticle.size()>0){  PTRFListForRecticle.clear();  }
        if(finalLSList != null && finalLSList.size()>0){  finalLSList.clear();   }
        if(ListObj != null && ListObj.size()>0){  ListObj.clear();  }
        if(lstCustomerList != null && lstCustomerList.size()>0){  lstCustomerList.clear();  }
        if(masterMRSObj != null && masterMRSObj.size()>0){ masterMRSObj.clear();  }
        if(postSortValues != null && postSortValues.size()>0){  postSortValues.clear();  }
        if(PTRFtoLayerMap != null && PTRFtoLayerMap.size()>0){  PTRFtoLayerMap.clear();  }
        if(tempMRSObj != null && tempMRSObj.size()>0){  tempMRSObj.clear();  }
        if(MRSForDropDowns != null && MRSForDropDowns.size()>0){  MRSForDropDowns.clear();  }
        if(masterMRSObj != null && masterMRSObj.size()>0){  masterMRSObj.clear();   }
        if(FinalMSTList != null && FinalMSTList.size()>0){  FinalMSTList.clear();   }
        if(lstMaskLayer != null && lstMaskLayer.size()>0){ lstMaskLayer.clear(); }
        if(UniqueSet != null && UniqueSet.size()>0){ UniqueSet.clear();  }
    }
/**
    This is the method for formatting the tech geo value in proper format, for display in Layer Summary page
    @method name: FormatTechGeo
    @parameter:   Original tech geo value in string format
    @return :     Formatted value in string format
**/
    public String FormatTechGeo(String str){       
        String TechGeoFormatted = str;
        Double TechGeoValue;
        if(str != '' && str != NULL){
            if(!TechGeoFormatted.toUppercase().contains('UM')){  TechGeoFormatted +='UM';   }
            if(TechGeoFormatted != NULL && !TechGeoFormatted.equalsIgnoreCase('NULL') && TechGeoFormatted != '' && !TechGeoFormatted.toLowercase().contains('nm') && TechGeoFormatted.toUppercase().substringBefore('UM').trim() != null){
                TechGeoValue = double.valueOf(TechGeoFormatted.toUppercase().substringBefore('UM').trim());
                if(TechGeoValue != NULL && TechGeoValue<0.1){ TechGeoFormatted = TechGeoFormatted + ' (' + Integer.valueOf(TechGeoValue*1000) + 'nm)'; }
            }
        }
        else{  TechGeoFormatted = '';   }
        return TechGeoFormatted;    
    }

/**
    This is the inner class for creating a Paginated Selectlist for populating and displaying filter dropdowns with more than 1000 records in the list
    @class name: PaginatedSelectList 
**/


public class PaginatedSelectList {      
    private List<SelectOption> selectList=new List<SelectOption>();      
    private final Integer SUB_LIST_SIZE=1000;      
    public Integer Iteration {get;set;} {Iteration = 0;}
    public List<SelectOption> ListControl {get {return getValueFromList();} set;} {ListControl = new List<SelectOption>();}

/**
    This is the method for returning the size of the current object
    @method name: getSize
    @parameter:   None
    @return :     Size of object (Integer)
**/     
    public Integer getSize(){ return selectList.size(); }

/**
    This is the method for adding values to object
    @method name: add
    @parameter:   None
    @return :     None
**/ 
    public void add(SelectOption so){ selectList.add(so); }

/**
    This is the method for extracting specific selectoption value based on a index number specified
    @method name: get
    @parameter:   Index value for retrieval (Integer)
    @return :     Selectoption value at the selected index
**/ 
    public SelectOption get(Integer index){ 
    if(index>-1 && index<getSize()){
           return selectList.get(index);
           }else{ return null; }
        }

/**
    This is the method for clearing the object values
    @method name: clear
    @parameter:   None
    @return :     None
**/
    public void clear(){ selectList.clear(); }

/**
    This method returns all the selectoptions
    @method name: getSelectList
    @parameter:   None
    @return :     List of SelectOption
**/    
    public List<SelectOption> getSelectList(){ return selectList; }
    
/**
    This method Gets Select Options for the given start and end index both are inclusive.
    @method name: getSubList
    @parameter:   1) Integer: StartIndex,
                  2) Integer: EndIndex
    @return :     List of SelectOption
**/          
    public List<SelectOption> getSubList(Integer startIndex,Integer endIndex){ 
    List<SelectOption> subList=new List<SelectOption>();            
    if(startIndex>-1 && startIndex<selectList.size()&& endIndex>-1 && endIndex<selectList.size()&&startIndex<=endIndex){
           for(Integer i=startIndex;i<=endIndex;i++){ subList.add(get(i)); } 
           }      
    return subList; 
    }

    
/**
    This method Gets Nth sub list by dividing the main list in sublists of SUB_LIST_SIZE(1000 elements).      
    @method name: getNthSubList
    @parameter:   1) Integer: Index
    @return :     List of SelectOption
**/
    public List<SelectOption>getNthSubList(Integer index){
     Integer subListCount=(Integer)(selectList.size()/SUB_LIST_SIZE);
     if(Math.mod(selectList.size(),SUB_LIST_SIZE)>0) subListCount++;
     if(index>=0 && index<=subListCount){
     Integer startIndex=index*SUB_LIST_SIZE;
     Integer endIndex=index*SUB_LIST_SIZE+(SUB_LIST_SIZE-1);
     if(endIndex>=selectList.size())
         endIndex=selectList.size()-1;
         return getSubList(startIndex,endIndex);
     }else{ return new List<SelectOption>(); }
    }
     
/**
    This method Gets sublist for given index.
    @method name: getValueFromList
    @parameter:   None
    @return :     List of SelectOption
**/         
    public List<SelectOption> getValueFromList(){ return getNthSubList(Iteration); }

/*  Getter Methods  */
    public List<SelectOption>get0(){ return getNthSubList(0); }
    public List<SelectOption>get1(){ return getNthSubList(1); }
    public List<SelectOption>get2(){ return getNthSubList(2); }
    public List<SelectOption>get3(){ return getNthSubList(3); }
    public List<SelectOption>get4(){ return getNthSubList(4); }
    public List<SelectOption>get5(){ return getNthSubList(5); }
    public List<SelectOption>get6(){ return getNthSubList(6); }
    public List<SelectOption>get7(){ return getNthSubList(7); }
    public List<SelectOption>get8(){ return getNthSubList(8); }
    public List<SelectOption>get9(){ return getNthSubList(9); }
    public List<SelectOption>get10(){ return getNthSubList(10); }
    public List<SelectOption>get11(){ return getNthSubList(11); }
    public List<SelectOption>get12(){ return getNthSubList(12); }
    public List<SelectOption>get13(){ return getNthSubList(13); }
    public List<SelectOption>get14(){ return getNthSubList(14); }
    public List<SelectOption>get15(){ return getNthSubList(15); }
    public List<SelectOption>get16(){ return getNthSubList(16); }
    public List<SelectOption>get17(){ return getNthSubList(17); }
    public List<SelectOption>get18(){ return getNthSubList(18); }
    public List<SelectOption>get19(){ return getNthSubList(19); }
    
    }

    /**
    * Manual calculate status of layer/layer chip
    * entry from Calc Status link
    *
    * Statistic of:
    * - Max numbers of SOQL:
    * - Max numbers of DML:
    *
    * @author           SWIFT Team
    * @created date     30-May-2015
    */
    public String selectedLayerId {get;set;}
    public String errorMessage {get;set;}
    
    /*
    public void calculateStatus() {
        
        boolean isRefresh = false; // indicated to or not to refresh page, if data change: refresh, otherwise: no refresh
        // selectedLayerId
        // query this layer where id = selectedLayerId as before update captured.
        // going down the end of function, if isRefresh = true: query this layer again and compare to before update captured for details on which fields changed. 
        MRS_Layer_Association__c oldLayerCaptured = [
            SELECT Id,Customer_GDSOUT_Review__c,Foundry_GDSOUT_Review__c,Customer_Frame_Mockup__c,Layer_Status__c,
                Foundry_Frame_Mockup__c,Send_Prime_Data__c,Send_Frame_Data__c,Customer_Prime_Remote_Jobview_Setup__c,
                Customer_Frame_Remote_Jobview_Setup__c,Foundry_Prime_Remote_Jobview_Setup__c,
                Foundry_Frame_Remote_Jobview_Setup__c,ORC__c,DRW__c,Prime_MEBES_Received__c,Frame_MEBES_Received__c,
                Customer_MEBES_Jobview__c,Foundry_MEBES_Jobview__c,Tapeout_Centre_MEBES_Jobview__c,
                Tapeout_Applications_MEBES_Jobview__c,GlobalShuttle_MEBES_Jobview__c,MDP_MEBES_Jobview__c,TDTI_MPW_MEBES_Jobview__c
            FROM MRS_Layer_Association__c 
            WHERE Id = :selectedLayerId
        ];
        // query all layer chip where layer__c = selectedLayerId and status in ('In Progress','Not Ready') <------- LIST A
        String query = 
            'SELECT id,Layer_Chip_Status__c,Customer_GDSOUT_Review__c,' 
            +   'Foundry_GDSOUT_Review__c,Customer_Frame_Mockup__c,Foundry_Frame_Mockup__c,' 
            +   'Send_Prime_Data__c,Send_Frame_Data__c,DRW__c,ORC__c,Prime_MEBES_Received__c,' 
            +   'Frame_MEBES_Received__c,Customer_MEBES_Jobview__c,Foundry_MEBES_Jobview__c,' 
            +   'GlobalShuttle_MEBES_Jobview__c,MDP_MEBES_Jobview__c,Tapeout_Applications_MEBES_Jobview__c,' 
            +   'Tapeout_Centre_MEBES_Jobview__c,TDTI_MPW_MEBES_Jobview__c,PTRF__r.Tech_Geo_Value__c,Layer_Name__c,Rev__c,Chip_Name__c,PTRF_Number__c,Mask_Set_Title_Name__c ' 
            + 'FROM MRS_Layer_Chip_Association__c '
            + 'WHERE Layer__c= :selectedLayerId ';

        List<MRS_Layer_Chip_Association__c> layerChips = new List<MRS_Layer_Chip_Association__c>();
        layerChips = Database.query(query + ' AND Layer_Chip_Status__c IN (\'Not Ready\',\'In Progress\')');
        // if list A.size() == 0
        //      then query 1 layer chip where layer__c = selectedLayerId and status in ('Released') <------- LIST B
        if( layerChips.isEmpty() ) {
            // B:
            // only need to select 1 layer chip under
            // set CAD_Update__c = true > update -> so layer will be re-calculated
            layerChips = new List<MRS_Layer_Chip_Association__c>();
            layerChips = Database.query(query + ' AND Layer_Chip_Status__c IN (\'Released\') limit 1');
            if( !layerChips.isEmpty() ) {
                try {
                    // only need to re-trigger 1 layer chip for calculate at layer level
                    isRefresh = triggerLayer(layerChips.get(0), oldLayerCaptured);                  
                } catch(Exception e) {
                    logErrorCalc('Unexpected Calc Status error occurred by ', layerChips.get(0), e); // DML HERE
                }
            }
        } else {
            // A:
            // Re-calculate status for each layer chip in list A
            // if status after calculate != before calculate
            // update layer chip in list A with new value
            // take out 1 layer chip in list A -> set CAD_Update__c = true > update -> so layer will be re-calculated
            try {
                // 1. re-calculate status at layer chip level. Only for Layer Chip Status
                BatchScheduleSetLayerChipStatus.reTriggerLayerChip(layerChips);
                // 2. re-calculate status at layer level. For overall layer status all all fields status.
                isRefresh = triggerLayer(layerChips.get(0), oldLayerCaptured);
            } catch(Exception e) {
                logErrorCalc('Unexpected Calc Status error occurred by ', layerChips.get(0), e); // DML HERE
            }
        }
        
        if( isRefresh ) {
            // query this layer :selectedLayerId again and compare to before update captured for details on which fields changed.
            refreshData1(); // SOQL HERE
        }   
    }
    */
    
    public String infoMessage {get;set;}
    
    /*
    public boolean triggerLayer (MRS_Layer_Chip_Association__c temp, MRS_Layer_Association__c oldLayerCaptured) {
        infoMessage = '';
        temp.CAD_Update__c = true;
        //update temp; // DML HERE
        
        MRS_Layer_Association__c afterCalculatedLayerCaptured = [
            SELECT Id,Customer_GDSOUT_Review__c,Foundry_GDSOUT_Review__c,Customer_Frame_Mockup__c,Layer_Status__c,Name,Mask_Layer_Rev__c,
                Foundry_Frame_Mockup__c,Send_Prime_Data__c,Send_Frame_Data__c,Customer_Prime_Remote_Jobview_Setup__c,
                Customer_Frame_Remote_Jobview_Setup__c,Foundry_Prime_Remote_Jobview_Setup__c,
                Foundry_Frame_Remote_Jobview_Setup__c,ORC__c,DRW__c,Prime_MEBES_Received__c,Frame_MEBES_Received__c,
                Customer_MEBES_Jobview__c,Foundry_MEBES_Jobview__c,Tapeout_Centre_MEBES_Jobview__c,
                Tapeout_Applications_MEBES_Jobview__c,GlobalShuttle_MEBES_Jobview__c,MDP_MEBES_Jobview__c,TDTI_MPW_MEBES_Jobview__c
            FROM MRS_Layer_Association__c 
            WHERE Id = :oldLayerCaptured.Id
        ];
        String updateMessages = ''; // store detail on which fields has been update if any
        String layerName = afterCalculatedLayerCaptured.Name + afterCalculatedLayerCaptured.Mask_Layer_Rev__c; // sample value: RXAZ
        // overall status
        infoMessage += oldLayerCaptured.Layer_Status__c != afterCalculatedLayerCaptured.Layer_Status__c 
            ? '<span class="bold-font">Layer Status</span> has been changed from "<span class="bold-font">' + oldLayerCaptured.Layer_Status__c + '</span>" to "<span class="bold-font">' + afterCalculatedLayerCaptured.Layer_Status__c + '</span>".<br />' 
            : '';
        //ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO, updateMessages));
        for ( String thisField: fetchFieldNames() ) {
            String fieldApi = thisField.split(':')[0];
            String fieldLabel = thisField.split(':')[1];
            infoMessage += oldLayerCaptured.get(fieldApi) != afterCalculatedLayerCaptured.get(fieldApi) 
                ? '+ <span class="bold-font">' +  fieldLabel + '</span> has been changed from "<span class="bold-font">' + oldLayerCaptured.get(fieldApi) + '</span>" to "<span class="bold-font">' + afterCalculatedLayerCaptured.get(fieldApi) + '</span>".<br />'
                : '';
            //ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO, updateMessages));
        }
        if( String.isNotEmpty(infoMessage) ) {
            infoMessage = 'Messages for layer <span class="bold-font">' + afterCalculatedLayerCaptured.Name + afterCalculatedLayerCaptured.Mask_Layer_Rev__c + '</span>.<br />' + infoMessage;
        }
        //ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO, updateMessages));
        return true;
    }
    
    public List < String > fetchFieldNames() {
        List < String > listFieldNames;
        listFieldNames = new List < String > ();
        listFieldNames.add('Customer_GDSOUT_Review__c:Customer GDSOUT Review');
        listFieldNames.add('Foundry_GDSOUT_Review__c:Foundry GDSOUT Review');
        listFieldNames.add('Customer_Frame_Mockup__c:Customer Frame Mockup');
        listFieldNames.add('Foundry_Frame_Mockup__c:Foundry Frame Mockup');
        listFieldNames.add('Send_Prime_Data__c:Send Prime Data');
        listFieldNames.add('Send_Frame_Data__c:Send Frame Data');
        listFieldNames.add('Customer_Prime_Remote_Jobview_Setup__c:Customer Prime Remote Jobview');
        listFieldNames.add('Customer_Frame_Remote_Jobview_Setup__c:Customer Frame Remote Jobview');
        listFieldNames.add('Foundry_Prime_Remote_Jobview_Setup__c:Foundry Prime Remote Jobview');
        listFieldNames.add('Foundry_Frame_Remote_Jobview_Setup__c:Foundry Frame Remote Jobview');
        listFieldNames.add('ORC__c:ORC');
        listFieldNames.add('DRW__c:DRW');
        listFieldNames.add('Prime_MEBES_Received__c:Prime MEBES Received');
        listFieldNames.add('Frame_MEBES_Received__c:Frame MEBES Received');
        listFieldNames.add('Customer_MEBES_Jobview__c:Customer MEBES Jobview');
        listFieldNames.add('Foundry_MEBES_Jobview__c:Foundry MEBES Jobview');
        listFieldNames.add('Tapeout_Centre_MEBES_Jobview__c:Tapeout Centre MEBES Jobview');
        listFieldNames.add('Tapeout_Applications_MEBES_Jobview__c:Tapeout Applications MEBES Jobview');
        listFieldNames.add('GlobalShuttle_MEBES_Jobview__c:GlobalShuttle MEBES Jobview');
        listFieldNames.add('MDP_MEBES_Jobview__c:DRR');
        listFieldNames.add('TDTI_MPW_MEBES_Jobview__c:TDTI MPW MEBES Jobview');
        return listFieldNames;
    }
    
    // TO-DO: add 1 more details to know the log come from first part (all chip Released, only trigger at layer) or second part (trigger both layer chip and layer)
    public void logErrorCalc(String errorMessage, MRS_Layer_Chip_Association__c layerChip, Exception e) {
        String userStr = UserInfo.getUserName();
        String mstStr = 'MST: ' + layerChip.Mask_Set_Title_Name__c;
        String layerStr = 'Layer: ' + layerChip.Layer_Name__c;
        String layerChipStr = 'Layer Chip: ' + layerChip.Layer_Name__c + '('+ layerChip.Rev__c +') - ptrf: ' + layerChip.PTRF_Number__c;
        
        String errorMssPage = errorMessage + userStr + ' on ' + mstStr + ', ' + layerStr + ', ' + layerChipStr; // message shown on screen
        String errorMss = errorMessage + '\n' + userStr + '\n' + mstStr + '\n' + layerStr + '\n' + layerChipStr; // message log at Application Log level
        SWIFT_Application_Log__c log  = new SWIFT_Application_Log__c(
            Debug_Level__c            = 'ERROR',
            Apex_Component_Name__c    = 'MRSLayerSummaryExtn',
            Method__c                 = 'calculateStatus',
            Message_ID__c             = 'ReCalculate ' + System.now(),
            Error_Message__c          = errorMss,
            Stack_Trace__c            = e.getMessage() + '\n' + e.getStackTraceString()
        );
        insert log;
        
        errorMssPage += '. ' + Environment_Variable__c.getInstance('SWIFT_MRS_ROLLUP_ERROR_MESSAGE').Value__c;
        this.errorMessage = errorMssPage;
        showPopup();
    }
    
    */
    public boolean viewLink {get;set;}
    /**
    * Read from Environment_Variable__c('SWIFT_MRS_ROLLUP_LINK_ACCESS') custom setting
    * Enable privilege of accessing Calc Status for Group define in SWIFT_MRS_ROLLUP_LINK_ACCESS
    */
    public boolean getCalcLinkPrivilege() {
        boolean result = false;
        try {
            // get environment variable for group access to link
            String groupAccess = Environment_Variable__c.getInstance('SWIFT_MRS_ROLLUP_LINK_ACCESS').Value__c;
            groupAccess = '(\'' + groupAccess.replace(';','\',\'') + '\')'; // ('Swift_Admin','Swift_MDP','Swift_Tapeoutcentre')
            String accessQuery = 'SELECT Id FROM Group WHERE DeveloperName IN ' + groupAccess;
            List<Group> lstGroupAccess = Database.query(accessQuery);
            if( !lstGroupAccess.isEmpty() ) {
                Set<Id> groupIds = (new Map<Id,SObject>(lstGroupAccess)).keySet();
                List<GroupMember> accessOfCurrentUser = new List<GroupMember>();
                accessOfCurrentUser = [
                    SELECT ID
                    FROM GroupMember
                    WHERE GroupId IN :groupIds AND UserOrGroupId = :UserInfo.getUserId()
                ];
                if( !accessOfCurrentUser.isEmpty() ) {
                    result = true;
                }
            } // else result = false    
        } catch(Exception e) {
            // no break others function if data is incorrect
        }
        return result;
    }
    
    public boolean displayPopup {get; set;}
    public void showPopup() {        
        displayPopup = true;    
    }
    public void closePopup() {       
        displayPopup = false;   
    }
    
    public void refreshData1() {
        ignoreFlagValues = true;
        if(isAll){
            isGDSOUTReview = true;
            isFrameMockupReview = true;
            isSendData = true;
            isRemoteJobView = true;
            isORC = true;
            isDRW = true;
            isMEBESReceived = true;
            isMEBESJobView = true;
        }
        DirectCallToValues = true;
        switch();
    } 
    
}