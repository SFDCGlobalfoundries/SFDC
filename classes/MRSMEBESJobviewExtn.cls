/*
Type Name:    MRSMEBESJobviewExtn 
Author:       Cognizant 
Created Date: 28-April-2014
Reason: This is the controller class for all the MEBES Jobview pages. 
Change History:
Cognizant            10052014     -      Added the methods populateMEBESTable and displayTable
Cognizant            12052014     -      Added the methods applyAllFilters and clearAllFilters
Cognizant            16052014     -      Added the methods approvalData, displayChecked and saveData
Cognizant            20052014     -      Added the methods discardSelection and performReview
Cognizant            24052014     -      Added the methods exportToExcel, exportToPDF and exportToPDF
Cognizant            03062014     -      Bug fixing done for defects
Cognizant            09062014     -      Incorporated the Code Review Comments
Cognizant            15082014     -      UAT Defect Fixing
Cognizant            27082014     -      UAT Defect Fixing
Cognizant            28082014     -      UAT Defect Fixing
Cognizant            20102014     -      Custom Lookup Implementation
Cognizant            10112014     -      Internal Sanity Check
Cognizant            12112014     -      Modified Code for CR019
Cognizant            04122014     -      Modified Code for TASK-2302
Cognizant            08012015     -      Modified Code for TASK-2389
*/
 
public class MRSMEBESJobviewExtn {
    
    //Public Variables Declaration
    //String Declaration     
    private String jobviewType;
    private String pageName;
    public String jobviewName {get ;set;}     
    public String selectedCustomer {get ;set;}    
    public String selectedMST {get ;set;}
    private String oldSelectedMST;
    public String selectedMSTName{get ;set;}
    public String noAccountErrorMsg; 
    public String selectedChipId {get;set;}
    public String selectedLayerId {get;set;}
    public String selectedPTRFId {get;set;}    
    public String selectedLayerStatus {get;set;}
    public String selectedDeviceId {get;set;}
    public String releaseReasonTxt {get ;set;}
    public String customerName {get;set;}
    public String mstAfterSave {get;set;}
    public String customerNameAfterSave {get;set;}
    public String mainTableJSON{get;set;}
    public String sideHeaderJSON{get;set;}
    public String gridTblJSON{get;set;}   
    public String lookupCustomerURL {get;set;}//Added for Custom Lookup Implementation
    public String lookupMSTURL {get;set;}//Added for Custom Lookup Implementation   
    //Integer Declaration
    public Integer chipSetSize{get ;set;}
    private Integer maxSizeLimit;   
    //Boolean Declaration
    public Boolean showLabel {get ;set;}
    public Boolean isPerformActive {get ;set;}
    public Boolean isTableActive {get ;set;}
    public Boolean noAccounts;
    public Boolean isBreadcrumbActive {get;set;}
    public Boolean isTechGeoActive {get;set;}
    public Boolean isConfirmApproved {get;set;}
    public Boolean isSelectionTableTrue {get;set;}
    public Boolean errorMessage{get;set;}
    public Boolean noRecords{get;set;}
    public Boolean isCustomerListActive{get;set;} 
    public Boolean applyFilters;  
    public Boolean imageActive {get;set;}
    public Boolean labelorDropdown {get;set;}
    public Boolean isReleaseComments {get;set;}
    public Boolean isSizeExceeded {get;set;}
    public Boolean isNumberOfTotalPTRFExceeded {get;set;}
    private Boolean isProceedComplete;
    private Boolean isUserAdmin;
    private Boolean isUserGS;
    private Boolean isUserTDTIMPW;
    private Boolean isUserMDP;
    private Boolean isUserTapeoutOps;
    private Boolean isUserTapeoutCenter;
    private Boolean isUserTapeoutApp;
    private Boolean isUserFE;
    private Boolean isUserFoundryJobviewer;        
    public Boolean isJobViewer {get;set;}
    private Boolean isGroupOrJobViewer = false;
    private Boolean isRecordLocked = false; 
    private Boolean isPerformApprovalForUser; 
    private Boolean onlyFoundryJV;//TASK-1913
    private Boolean flagNoStatusReady;//TASK-2115      
    //List Declaration
    private transient List<MRS_Layer_Chip_Association__c> mrsLayerChipList ;
    public transient List<Account> lstCustomerList {get;set;}    
    public transient List<SelectOption> lstMST {get;set;}
    public List<SelectOption> maskLayerList {get;set;}    
    public List<SelectOption> layerStatusList {get;set;}
    public List<SelectOption> chipNameList {get;set;}
    public List<SelectOption> deviceIdList {get;set;}
    public List<SelectOption> ptrfList {get;set;}
    public List<WrapperDisplayTable> displayTableList;
    public List<OtherWrapperDisplayTable> otherdisplayTableList {get;set;}
    private List<WrapperChip> lstMainTableData;
    private List<WrapperLayerPtrf> lstsideTableData;
    private List<WrapperStatusCheck> lstgridData;
    public List<WrapperChip> lstChip {get; set;}
    public List<WrapperLayerPtrf> lstLayer {get; set;}
    //Set Declaration
    public Set<String> chipNameSet {get;set;}
    public Set<String> layerPtrfSet;
    private Set<String> setLayerStatuses;
    private Set<String> setChips;
    private Set<String> setMaskLayers;
    private Set<String> setPTRFs;
    private Set<String> setDeviceIds;
    //Map Declaration  
    //public transient Map<String,String> uniqueStatusMapChanged {get;set;}
    //private Map<String,String> uniqueStatusMap;  
    private Map<String,String> mapStrCompareToIds;//TASK-1996       
    public Map<String,Boolean> chipWithCheckboxMap {get;set;}
    public Map<String,Boolean> layerPtrfCheckbox {get;set;}
    public Map<String,WrapperStatusCheck> mapForApprove {get;set;}
    //public Map<String,String> statusWithTimestamp {get;set;}   
    //public Map<String,Boolean> containsStatus {get;set;}
    public Map<Id,String> customerNameMap {get;set;}      
    public Map<String,Integer> mapUniqueLayerChips;
    public Map<String,String> mapMSTs;
    public Map<String,String> mapPTRFNamesToIds;
    private final Integer SUB_LIST_SIZE=1000;//TASK-2058
    public Map<String,statusWrapper> statusWrapperMap{get;set;}
    //Transient Variable Declaration to decrease the ViewState
    private transient Map<String,MRS_Layer_Chip_Association__c> layerChipMap = new Map<String,MRS_Layer_Chip_Association__c>();
    private transient Map<String,List<MRS_Layer_Chip_Association__c>> layerPtrfMap = new Map<String,List<MRS_Layer_Chip_Association__c>>();
    private transient Map<String,List<MRS_Layer_Chip_Association__c>> chipMap = new Map<String,List<MRS_Layer_Chip_Association__c>>();
             
    /**
        The constructor determines which of the 7 MEBES Jobview pages is currently being displayed and provides the name for the page.
        The constructor fetches the List of Customer Names to be populated.
        In case of a single Customer Name, the constructor also populates the corresponding Mask Set Titles.         
     **/
     
    public MRSMEBESJobviewExtn(ApexPages.StandardController controller) {         
        //Initializing the public variables
        onlyFoundryJV=false;
        isPerformApprovalForUser = false;
        noAccounts = false;
        isTableActive = false;
        isPerformActive = false;
        isTechGeoActive = false;
        showLabel = false;
        isConfirmApproved = false;
        isSelectionTableTrue = false;
        isNumberOfTotalPTRFExceeded=false;
        imageActive = true;
        applyFilters = false;
        labelorDropdown = true;
        isReleaseComments = false;  
        isProceedComplete = false;
        flagNoStatusReady = false;//TASK-2115                 
        lstmst = new List<SelectOption>();
        maskLayerList = new List<SelectOption>();
        layerStatusList = new List<SelectOption>();
        chipNameList = new List<SelectOption>();
        deviceIdList = new List<SelectOption>();
        ptrfList = new List<SelectOption>();
        customerNameMap = new Map<Id,String>();                   
        setLayerStatuses = new set<String>();
        setChips = new set<String>();
        setMaskLayers = new set<String>();
        setPTRFs = new set<String>();
        setDeviceIds = new set<String>();
        mapUniqueLayerChips = new Map<String,Integer>();        
        displayTableList = new List<WrapperDisplayTable>();
        //uniqueStatusMapChanged = new Map<String,String>();
        //uniqueStatusMap = new Map<String,String>();
        mapStrCompareToIds = new Map<String,String>();//TASK-1996             
        chipNameSet = new Set<String>();
        layerPtrfSet = new Set<String>();
        chipWithCheckboxMap = new Map<String,Boolean>();
        layerPtrfCheckbox = new Map<String,Boolean>();
        mapForApprove  =new Map<String,WrapperStatusCheck>();
        //statusWithTimestamp = new Map<String,String>();     
        //containsStatus = new Map<String,Boolean>();
        statusWrapperMap =new Map<String,statusWrapper>();
        mapMSTs = new Map<String,String>();
        mapPTRFNamesToIds = new Map<String,String>();       
        String url = ApexPages.currentPage().getHeaders().get('Host');
        //Setting the Breadcrumb to MyDevices if the screen is accessed from the community else setting it to MRS
        if(url.contains(Label.Swift_Host_URL)){         
            isBreadcrumbActive = true;            
            lookupCustomerURL = Label.Swift_VFExternal_URL+'VFCustomerLookupDialog';//Added for Custom Lookup Implementation
            lookupMSTURL = Label.Swift_VFExternal_URL+'VFMaskSetTitleLookupDialog';//Added for Custom Lookup Implementation          
        }else{
            isBreadcrumbActive = false;           
            lookupCustomerURL = Label.Swift_VFInternal_URL+'VFCustomerLookupDialog';//Added for Custom Lookup Implementation
            lookupMSTURL = Label.Swift_VFInternal_URL+'VFMaskSetTitleLookupDialog';//Added for Custom Lookup Implementation            
        }
        //As per TASK-1864, setting Limit of MEBES table
        if(Environment_Variable__c.getInstance('MRS_MEBES_RECORD_SIZE_LIMIT').Value__c == '0' || Environment_Variable__c.getInstance('MRS_MEBES_RECORD_SIZE_LIMIT').Value__c == ''){
            maxSizeLimit = 1000;
        }else {
            maxSizeLimit = Integer.valueOf(Environment_Variable__c.getInstance('MRS_MEBES_RECORD_SIZE_LIMIT').Value__c);
        }
        //Retrieving the jobviewType and depending on the type of MEBES Jobview screen, setting the jobviewName to be displayed on the screen        
        if(ApexPages.currentPage().getParameters().containsKey('jobview')) {
            jobviewType = ApexPages.currentPage().getParameters().get('jobview');
        }
        if(jobviewType == '' || jobviewType == null) {
            return;
        }
        if(jobviewType.equalsIgnoreCase('Customer')) {
            pageName = 'CustomerMEBES';
            jobviewName = 'Customer';          
        }else if(jobviewType.equalsIgnoreCase('Foundry')) {
            pageName = 'FoundryMEBES';
            jobviewName = 'Foundry';          
        }else if(jobviewType.equalsIgnoreCase('TapeoutCentre')) {
            pageName = 'TapeoutCenterMEBES';
            jobviewName = 'Tapeout Centre';            
        }else if(jobviewType.equalsIgnoreCase('TapeoutApp')) {
            pageName = 'TapeoutApplicationMEBES';
            jobviewName = 'Tapeout Application';
        }else if(jobviewType.equalsIgnoreCase('GlobalShuttle')) {
            pageName = 'GlobalShuttleMEBES';
            jobviewName = 'Global Shuttle';            
        }else if(jobviewType.equalsIgnoreCase('MDP')) {
            pageName = 'MDPMEBES';
            jobviewName = 'MDP';            
        }else if(jobviewType.equalsIgnoreCase('MPWTDTI')) {
            pageName = 'TDTIMPWMEBES';
            jobviewName = 'TDTI-MPW';            
        }else{
            return;
        }        
        //Retrieving Group Membership of the current logged-in User Start
        isUserFE=false;
        isUserGS=false;
        isUserTDTIMPW=false;
        isUserMDP=false;
        isUserTapeoutOps=false;
        isUserTapeoutCenter = false;
        isUserTapeoutApp = false;
        isUserAdmin = false;
        isUserFoundryJobviewer = false;//TASK-1913
        Id userId = UserInfo.getUserId();
        set<String> setLoggedInUserGroups = new set<String>();          
        setLoggedInUserGroups.addAll(MRSHandlerUtility.fetchCurrentUserGroup(userId));           
        if(setLoggedInUserGroups.size()>0){
            for(String userGroup:setLoggedInUserGroups){
                if(userGroup.equalsIgnoreCase('Swift_GlobalShuttle')){
                    isUserGS = true;                       
                } 
                if(userGroup.equalsIgnoreCase('Swift_TDTI_MPW')){
                    isUserTDTIMPW = true;                       
                } 
                if(userGroup.equalsIgnoreCase('SWIFT_Admin')){
                    isUserAdmin = true;                       
                }
                if(userGroup.equalsIgnoreCase('Swift_MDP')){
                    isUserMDP=true; 
                }
                if(userGroup.equalsIgnoreCase('Swift_Tapeout_Operations')){
                    isUserTapeoutOps=true; 
                }
                if(userGroup.equalsIgnoreCase('Swift_Tapeout_Centre')){
                    isUserTapeoutCenter=true;
                    if(Environment_Variable__c.getInstance('ALL_VIEW_ALL_APPROVAL').Value__c.containsIgnoreCase(userGroup)){
                        isUserAdmin=true;
                    } 
                }
                if(userGroup.equalsIgnoreCase('Swift_Tapeout_Application')){
                    isUserTapeoutApp=true; 
                }
                //TASK-1913
                if(userGroup.equalsIgnoreCase('Swift_Foundry_Jobviewer')){
                    isUserFoundryJobviewer=true; 
                }  
            }
        }            
        //Retrieving Group Membership of the current logged-in User End               
        if(isUserGS||isUserTDTIMPW||isUserMDP||isUserTapeoutCenter||isUserTapeoutOps||isUserTapeoutApp||isUserAdmin){
             isJobViewer= false;
        }else{
             isJobViewer = true;
        }
        //TASK-1913
        if(isUserFoundryJobviewer && isJobViewer && jobviewName!='Foundry'){
            onlyFoundryJV=true;
        }
        //TASK-1913
        List<PTRF_JobViewer_Info__c> ptrfJobViewlst = [SELECT Id,Jobview__c,Jobview_Type__c,PTRF__c,User__c FROM PTRF_JobViewer_Info__c Where PTRF__c!=null AND User__c=:UserInfo.getUserId() AND Jobview__c='Foundry' AND Jobview_Type__c INCLUDES('MEBES Jobview')];
        if(ptrfJobViewlst!=null && ptrfJobViewlst.size()>0){
            isGroupOrJobViewer = true;    
        }              
        //Populating the customer options
        lstCustomerList = new List<Account>();       
        lstCustomerList.addAll(fetchCustomerNames());
        if(lstCustomerList != null && !lstCustomerList.isEmpty()) {        
            for(Account accObj : lstCustomerList){                              
                customerNameMap.put(accObj.Id,accObj.Name+' ('+accObj.Short_Name__c+')');                   
            }
            //Code added for remembering Customer Name and MST across pages           
            if(ApexPages.currentPage().getCookies().get('account') ==  null  &&  ApexPages.currentPage().getCookies().get('mst') ==  null){
            //Code added for remembering Customer Name and MST across pages
                if(lstCustomerList.size()<2){
                    isCustomerListActive = false;
                    customerName = lstCustomerList.get(0).Name+' ('+lstCustomerList.get(0).Short_Name__c+')';                   
                    selectedCustomer = lstCustomerList.get(0).Id;
                    lookupMSTURL = lookupMSTURL + '?aid=' + selectedCustomer + '&pg=' + jobviewName + 'MEBES&jv=' + isJobViewer;//Added for Custom Lookup Implementation
                    showLabel=true; 
                    populateMSTList();  
                }else{                    
                    showLabel = false;
                    isCustomerListActive = true;
                }                        
            //Code added for remembering Customer Name and MST across pages
            }else{            
                if((ApexPages.currentPage().getCookies().get('account')!=null) && (String.valueOf(ApexPages.currentPage().getCookies().get('account').getValue())!='')){
                    if(customerNameMap!=null && customerNameMap.size()>0 && customerNameMap.containsKey(String.valueOf(ApexPages.currentPage().getCookies().get('account').getValue()))){
                        selectedCustomer = String.valueOf(ApexPages.currentPage().getCookies().get('account').getValue());                        
                        lookupMSTURL = lookupMSTURL + '?aid=' + selectedCustomer + '&pg=' + jobviewName + 'MEBES&jv=' + isJobViewer;//Added for Custom Lookup Implementation
                        populateMSTList();  
                    }                                   
                    if(ApexPages.currentPage().getCookies().get('mst') == null){
                        isPerformActive = false;
                    }
                    if(lstCustomerList.size()>1){                        
                        showLabel = false;
                        if(selectedCustomer!=null){
                            customerName  = customerNameMap.get(Id.valueOf(selectedCustomer));
                            customerNameAfterSave  = customerNameMap.get(Id.valueOf(selectedCustomer));
                        }
                        isCustomerListActive = true;
                    }else if(lstCustomerList.size()==1){
                        showLabel=true; 
                        isCustomerListActive = false;
                        customerName = customerNameMap.get(Id.valueOf(selectedCustomer));
                        customerNameAfterSave = customerNameMap.get(Id.valueOf(selectedCustomer));                       
                    }                    
                    if(customerNameAfterSave  != null){
                        if(ApexPages.currentPage().getCookies().get('mst') != null){
                            if(mapMSTs!=null && mapMSTs.size()>0 && mapMSTs.containsKey(ApexPages.currentPage().getCookies().get('mst').getValue())){
                                selectedmst = String.valueOf(ApexPages.currentPage().getCookies().get('mst').getValue());
                                //internal bug 
                                oldSelectedMST = selectedmst;                             
                            }
                            if(selectedmst!=null){ 
                                selectedMSTName =mapMSTs.get(Id.valueOf(selectedmst));                        
                                mstAfterSave =mapMSTs.get(Id.valueOf(selectedmst));
                                populateMEBESTable();
                            }
                        }
                    }else{
                        customerNameAfterSave = null;
                        selectedmst =null;
                        mstAfterSave= null;
                        //internal bug 
                        oldSelectedMST = null;  
                    }                                   
                }
            }
            //Code added for remembering Customer Name and MST across pages
        //In case of no Account records faced, displaying appropriate error message on screen            
        }else{
            noAccounts = true;
            noAccountErrorMsg = 'The user is not permitted to perform ' + jobviewType + ' MEBES Jobview as no Account records have been populated';   
        }
    }
    
    /**
        This method fetches the List of customer names to be displayed on the Customer Name combobox. 
        @method name: fetchCustomerNames
        @parameter:   None.
        @return :     List of Customer Names to be displayed.
     **/
         
    private List<Account> fetchCustomerNames() {  
        isTableActive = false;
        isPerformActive = false;
        List<Account> customerList = new List<Account>();
        //Fetching customer names from MRSHandlerUtility class    
        customerList.addAll(MRSHandlerUtility.fetchCustomerName());                
        return customerList;              
    }
    
    /**
        This method fetches the List of Mask Set Title names to be displayed on the Mask Set Title combobox. 
        @method name: populateMSTList
        @parameter:   None.
        @return :     None.
     **/
     
    public void populateMSTList(){ 
        //system.debug('Inside populateMSTList()');
        isProceedComplete = false;       
        set<SelectOption> setMST = new set<SelectOption>();        
        selectedChipId = '';
        selectedLayerId = '';
        selectedPTRFId = '';
        selectedLayerStatus = '';
        selectedDeviceId = '';       
        //Clearing and resetting all the filter values        
        if(lstmst!=null && lstmst.size()>0){
            lstmst.clear();
        }else{
            lstmst = new List<SelectOption>();
        }
        if(ptrfList!=null){
             ptrfList.clear();
        }
        if(chipNameList!=null){
             chipNameList.clear();
        }
        if(layerStatusList!=null){
             layerStatusList.clear();
        }
        if(maskLayerList!=null){
             maskLayerList.clear();
        }
        if(deviceIdList!=null){
             deviceIdList.clear();
        } 
        //Resetting all Boolean flags to false      
        isTableActive = false;
        isPerformActive = false;
        applyFilters = false;
        errorMessage = false; 
        noRecords =  false;   
        if(selectedCustomer!=null && !isConfirmApproved && !isSelectionTableTrue){
            //Populating the selected Customer Name to be displayed as label across the later pages         
            for(Account accObj:[select Id, Name, Short_Name__c from Account where Id=:selectedCustomer]){
                customerNameAfterSave = accObj.Name+' ('+accObj.Short_Name__c+')';
                customerName = accObj.Name+' ('+accObj.Short_Name__c+')';
            }
            //Determining whether the current logged-in user is a FE User or not.
            Set<String> teamRole = new Set<String>{'Primary Field Technical Support','Primary Field Application Engineer','Field Technical Support','Field Application Engineer'};
            List<Account_Team_Proxy__c> listAccTeamProxy = [Select Id,Account__c,User__c,Team_Role__c FROM Account_Team_Proxy__c WHERE User__c =:UserInfo.getUserId() AND Account__c =:selectedCustomer AND Team_Role__c IN:teamRole];
            if(listAccTeamProxy!=null && listAccTeamProxy.size()>0){
                isUserFE = true;    
            }
            if(isUserFE && isJobViewer){
                isJobViewer = false;    
            }
            //Code added for remembering Customer Name and MST across pages
            ClsMyDevices.account = new Cookie('account',selectedCustomer,null,-1,false);
            ApexPages.currentPage().setCookies(new Cookie[]{ClsMyDevices.account});
            //Code added for remembering Customer Name and MST across pages                     
            List<MRS_Layer_Chip_Association__c> listMRSLCA = new List<MRS_Layer_Chip_Association__c>(); 
            //Fetching List of Mask Set Title names from MRSHandlerUtility class          
            if(jobviewName !=null){
                mapMSTs = MRSHandlerUtility.fetchMaskSetTitleList(selectedCustomer,jobviewName+' MEBES',isJobViewer);
                //system.debug('mapMSTs='+mapMSTs);
            }
            /*//Populating the Mask Set Title names from the List of MRS Layer Chip Association records          
            if(mapMSTs!=null && mapMSTs.size()>0){                                        
                for(Id maskSetTitleId : mapMSTs.keySet()){
                    if(maskSetTitleId != null){
                        lstmst.add(new SelectOption(maskSetTitleId,mapMSTs.get(maskSetTitleId)));
                    }
                } 
            }*/            
        }        
                
    }

    public void resetLSPCookies(){
        //Code added for Internal Sanity Check - Start
        if(ApexPages.currentPage().getCookies().get('mst')!=null && String.valueOf(ApexPages.currentPage().getCookies().get('mst').getValue())!=''){
            ClsMyDevices.mst = new Cookie('mst',null,null,-1,false);
            ApexPages.currentPage().setCookies(new Cookie[]{ClsMyDevices.mst});
        }
        //Code added for Internal Sanity Check - End        
        Cookie maskLayer = new Cookie('maskLayer',null,null,-1,false);       
        Cookie layerStatusObject = new Cookie('layerStatus',null,null,-1,false);
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
        ApexPages.currentPage().setCookies(new Cookie[]{maskLayer});
        ApexPages.currentPage().setCookies(new Cookie[]{layerStatusObject});
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
        This method populates the MEBES Jobview Table in the MEBES Jobview visualforce pages. 
        @method name: populateMEBESTable
        @parameter:   None.
        @return :     None.
     **/
     
    public void populateMEBESTable(){
        noRecords = false;
        isRecordLocked = false;
        layerPtrfSet.clear();
        chipNameSet.clear();
        mapUniqueLayerChips.clear();
        
        if(statusWrapperMap != null){ statusWrapperMap.clear(); }
        
        List<MRS_Layer_Chip_Association__c> layerIterator;
        
        //*******************************************************************************
        //*******************************************************************************
        //TASK-2115    
        //this task is hardcoded for a user whom is both fjv and fae of selected customer   
        //flagNoStatusReady is used to show/hide Perform Approval button in the UI
        //::: true = hide the button T_T
        //::: false = show the button -_-
        if(isUserFoundryJobviewer && (jobviewName == 'Foundry') && isUserFE && !isUserAdmin && !isUserGS && !isUserTDTIMPW && !isUserMDP && !isUserTapeoutOps && !isUserTapeoutCenter && !isUserTapeoutApp){//TASK-2302
            
            List<PTRF_JobViewer_Info__c> ptrfJobViewlst = [SELECT Id,Jobview__c,Jobview_Type__c,PTRF__c,User__c FROM PTRF_JobViewer_Info__c Where PTRF__c!=null AND User__c=:UserInfo.getUserId() AND Jobview__c='Foundry' AND Jobview_Type__c INCLUDES('MEBES Jobview')];
            List<MRS_Layer_Chip_Association__c> mrsLayerChipAssoList = new List<MRS_Layer_Chip_Association__c>();
            set<String> setPTRFIds = new set<String>();
            
            if(ptrfJobViewlst!=null && ptrfJobViewlst.size()>0){
                
                for(PTRF_JobViewer_Info__c obj:ptrfJobViewlst){ setPTRFIds.add(obj.PTRF__c); }
                
                if(setPTRFIds.size()>0){
                    
                    mrsLayerChipAssoList = [SELECT Id,PTRF__c,Foundry_MEBES_Jobview__c,Layer_Chip_Status__c,PTRF_Or_DRT__c,Layer__r.Layer_Status__c from MRS_Layer_Chip_Association__c 
                        where PTRF__c IN:setPTRFIds AND Foundry_MEBES_Jobview__c='Ready' AND PTRF_Or_DRT__c!='DRT' 
                            AND Layer_Chip_Status__c NOT IN ('Cancel','Void') //swgp-602: lift Hold from NOT IN filter
                            AND Layer__r.Layer_Status__c NOT IN ('N.A.','Released','Shipped') //swgp-602: lift Hold from NOT IN filter
                        limit 1];//this list is queried just to set a flag?!? >>> set limit to 1 hope to lower change of governor exception
                     
                    if(mrsLayerChipAssoList.size()==0){ flagNoStatusReady = true; }//swgp-602: need to check this flag, as this could be hardcoded for Foundry JV ONLY
                } 
            }
        } 
        //TASK-2115-END
        //*******************************************************************************
        //*******************************************************************************
        
        if(lstCustomerList==null){
            lstCustomerList=new List<Account>();
            lstCustomerList.addAll(fetchCustomerNames());       
        }        

        if(layerChipMap==null){ layerChipMap = new Map<String,MRS_Layer_Chip_Association__c>(); }

        if(layerPtrfMap==null){ layerPtrfMap = new Map<String,List<MRS_Layer_Chip_Association__c>>(); }

        if(chipMap==null){ chipMap = new Map<String,List<MRS_Layer_Chip_Association__c>>(); }
        
        if(!isProceedComplete){ errorMessage = false; }
                   
        if(selectedMST!=null){
            //Populating the selected Mask Set Title Name to be displayed as label across the later pages
            for(Mask_Set_Title__c obj:[Select Id, name from Mask_Set_Title__c where Id=:selectedMST]){
                selectedMSTName = obj.Name;
                mstAfterSave = obj.Name;
            }
            //Code added for remembering Customer Name and MST across pages
            ClsMyDevices.mst = new Cookie('mst',selectedMST,null,-1,false);
            ApexPages.currentPage().setCookies(new Cookie[]{ClsMyDevices.mst});
            //Code added for remembering Customer Name and MST across pages
        }               
        isTableActive = true;
        isPerformActive = false;
        //system.debug(LoggingLevel.ERROR,'$$$$$$$$$$ outside applyFilters block='+applyFilters);        
        if(!applyFilters){
            //system.debug(LoggingLevel.ERROR,'$$$$$$$$$$ inside applyFilters ='+applyFilters);
            //Resetting all filters to false when a new Mask Set Title Name is selected
            if(ptrfList!=null){
                 ptrfList.clear();
            }
            if(chipNameList!=null){
                 chipNameList.clear();
            }
            if(layerStatusList!=null){
                 layerStatusList.clear();
            }
            if(maskLayerList!=null){
                 maskLayerList.clear();
            }
            if(deviceIdList!=null){
                 deviceIdList.clear();
            }          
            if(setLayerStatuses!=null){
                 setLayerStatuses.clear();
            }                      
            if(setChips!=null){
                 setChips.clear();
            }
            if(setMaskLayers!=null){
                 setMaskLayers.clear();
            }
            if(setPTRFs!=null){
                 setPTRFs.clear();
            }
            if(setDeviceIds!=null){
                 setDeviceIds.clear();
            }            
        }     

        if(selectedMST!=null){ 
            //Retrieving the MRS Layer Chip Association records to be displayed on the MEBES Jobview screens by fetching them from the MRSHandlerUtility.getMrsChipLayerSummary method                                            
            ptrfList.add(new SelectOption('',''));
            chipNameList.add(new SelectOption('',''));
            maskLayerList.add(new SelectOption('',''));
            deviceIdList.add(new SelectOption('',''));            
            if(jobviewName !=null){
                //TASK-2389 - Start
                if(onlyFoundryJV && isUserFE){
                    onlyFoundryJV = false;  
                } 
                //TASK-2389 - End                 
                mrsLayerChipList = new List<MRS_Layer_Chip_Association__c>();
                if(!onlyFoundryJV){
                    //TASK-1913
                    if(oldSelectedMST != selectedMST){
                        selectedLayerId='';
                        selectedLayerStatus='';
                        selectedDeviceId='';
                        selectedChipId='';
                        selectedPTRFId='';
                        setChips.clear();
                        setMaskLayers.clear();
                        setPTRFS.clear();
                        setLayerStatuses.clear();       
                        setDeviceIds.clear();
                        oldSelectedMST = selectedMST;
                    }  
                    //swgp-602
                    mrsLayerChipList = MRSHandlerUtility.getMrsChipLayerSummary(selectedCustomer,selectedMST,selectedLayerId,selectedLayerStatus,selectedDeviceId,null,selectedChipId,selectedPTRFId,jobviewName+' MEBES', isJobViewer);
                }
            }       

            if(mrsLayerChipList!=null && mrsLayerChipList.size()>0){        
                for(MRS_Layer_Chip_Association__c mrsLayerChipObj:mrsLayerChipList){                    
                    if(!applyFilters){
                        //Populating all the filter values
                        if(mrsLayerChipObj.PTRF__r.Name!=null){
                            setPTRFs.add(mrsLayerChipObj.PTRF__r.Name);
                        }
                        if(mrsLayerChipObj.Chip__r.Name!=null){                            
                            setChips.add(mrsLayerChipObj.Chip__r.Name);
                        }
                        if(mrsLayerChipObj.Layer__r.Layer_Status__c!=null){
                            setLayerStatuses.add(mrsLayerChipObj.Layer__r.Layer_Status__c);
                        }    
                        if(mrsLayerChipObj.Layer__r.Name!=null){
                            setMaskLayers.add(mrsLayerChipObj.Layer__r.Name);            
                        }
                        if(mrsLayerChipObj.PTRF__r.Device_Id__c!=null){
                            setDeviceIds.add(mrsLayerChipObj.PTRF__r.Device_Id__c);                           
                        }                     
                    }else{
                        if(mrsLayerChipObj.PTRF__r.Name!=null){
                            setPTRFs.add(mrsLayerChipObj.PTRF__r.Name);
                        }
                    }
                    if(mrsLayerChipList.size() <= maxSizeLimit){ // Task - 1864                   
                        if(!isPerformActive){
                            //If there is any single record having the corresponding MEBES Jobview Status as Ready, enabling the Perform Approval button on the screen, else keeping it as disabled
                            if(jobviewName =='Customer'){
                                if(mrsLayerChipObj.Customer_MEBES_Jobview__c!=null && mrsLayerChipObj.Customer_MEBES_Jobview__c == 'Ready'){
                                    isPerformActive = true;                                
                                }
                            }else if(jobviewName =='Foundry'){
                                if(mrsLayerChipObj.Foundry_MEBES_Jobview__c!=null && mrsLayerChipObj.Foundry_MEBES_Jobview__c == 'Ready'){
                                    isPerformActive = true;                                
                                }
                            }else if(jobviewName =='Tapeout Centre'){
                                if(mrsLayerChipObj.Tapeout_Centre_MEBES_Jobview__c!=null && mrsLayerChipObj.Tapeout_Centre_MEBES_Jobview__c == 'Ready'){
                                    isPerformActive = true;                                
                                }
                            }else if(jobviewName =='Tapeout Application'){
                                if(mrsLayerChipObj.Tapeout_Applications_MEBES_Jobview__c!=null && mrsLayerChipObj.Tapeout_Applications_MEBES_Jobview__c == 'Ready'){
                                    isPerformActive = true;                               
                                }
                            }else if(jobviewName =='Global Shuttle'){
                                if(mrsLayerChipObj.GlobalShuttle_MEBES_Jobview__c!=null && mrsLayerChipObj.GlobalShuttle_MEBES_Jobview__c == 'Ready'){
                                    isPerformActive = true;                                
                                }
                            }else if(jobviewName =='MDP'){
                                if(mrsLayerChipObj.MDP_MEBES_Jobview__c!=null && mrsLayerChipObj.MDP_MEBES_Jobview__c == 'Ready'){
                                    isPerformActive = true;                                
                                }
                            }else if(jobviewName =='TDTI-MPW'){
                                if(mrsLayerChipObj.TDTI_MPW_MEBES_Jobview__c!=null && mrsLayerChipObj.TDTI_MPW_MEBES_Jobview__c == 'Ready'){
                                    isPerformActive = true;                                
                                }
                            }
                        }
                        //If Reticle Type is of 'MNR' Type, rendering the Tech Geo column in the MEBES Jobview tables                    
                        if((mrsLayerChipObj.PTRF__r.Recticle_Type__c == 'Multi Node Reticle (MNR)') && !isTechGeoActive ){
                            isTechGeoActive = true;
                        }                   
                        layerPtrfSet.add(mrsLayerChipObj.Layer__r.Name+mrsLayerChipObj.Layer__r.Mask_Layer_Rev__c+'('+mrsLayerChipObj.ROM_Code__c+'):'+mrsLayerChipObj.PTRF__r.Name);          
                        chipNameSet.add(mrsLayerChipObj.Chip__r.Name);
                        //Setting Unique combination of Layer and Chips
                        String uniqueLayerChipCombo;
                        Integer counterUniqueLayerChip;
                        if(mrsLayerChipObj.ROM_Code__c!=null && mrsLayerChipObj.ROM_Code__c!='####'){
                            uniqueLayerChipCombo = mrsLayerChipObj.Layer__r.Name+mrsLayerChipObj.Layer__r.Mask_Layer_Rev__c+mrsLayerChipObj.ROM_Code__c+mrsLayerChipObj.Chip__r.Name+mrsLayerChipObj.PTRF__r.Tech_Geo__c;   
                        }else{
                            uniqueLayerChipCombo = mrsLayerChipObj.Layer__r.Name+mrsLayerChipObj.Layer__r.Mask_Layer_Rev__c+mrsLayerChipObj.Chip__r.Name+mrsLayerChipObj.PTRF__r.Tech_Geo__c;   
                        }                                       
                        if(mapUniqueLayerChips!=null){
                            if(mapUniqueLayerChips.containsKey(uniqueLayerChipCombo)){
                                counterUniqueLayerChip = mapUniqueLayerChips.get(uniqueLayerChipCombo);
                                counterUniqueLayerChip = counterUniqueLayerChip +1;
                            }else{
                                counterUniqueLayerChip = 1; 
                            }                
                            mapUniqueLayerChips.put(uniqueLayerChipCombo, counterUniqueLayerChip);  
                        }                                
                        // Setting Unique combination of Layer and Chips                    
                        layerChipMap.put(mrsLayerChipObj.Layer__r.Name+mrsLayerChipObj.Layer__r.Mask_Layer_Rev__c+'('+mrsLayerChipObj.ROM_Code__c+'):'+mrsLayerChipObj.PTRF__r.Name+mrsLayerChipObj.Chip__r.Name,mrsLayerChipObj);                 
                        if(layerPtrfMap.get(mrsLayerChipObj.Layer__r.Name+mrsLayerChipObj.Layer__r.Mask_Layer_Rev__c+'('+mrsLayerChipObj.ROM_Code__c+'):'+mrsLayerChipObj.PTRF__r.Name) != null){
                            layerPtrfMap.get(mrsLayerChipObj.Layer__r.Name+mrsLayerChipObj.Layer__r.Mask_Layer_Rev__c+'('+mrsLayerChipObj.ROM_Code__c+'):'+mrsLayerChipObj.PTRF__r.Name).add(mrsLayerChipObj);
                        }
                        else{
                            layerIterator = new List<MRS_Layer_Chip_Association__c>();
                            layerIterator.add(mrsLayerChipObj);
                            layerPtrfMap.put(mrsLayerChipObj.Layer__r.Name+mrsLayerChipObj.Layer__r.Mask_Layer_Rev__c+'('+mrsLayerChipObj.ROM_Code__c+'):'+mrsLayerChipObj.PTRF__r.Name,layerIterator);
                        }
    
                        if(chipMap.get(mrsLayerChipObj.Chip__r.Name) != null){
                            chipMap.get(mrsLayerChipObj.Chip__r.Name).add(mrsLayerChipObj);
                        }
                        else {
                            layerIterator = new List<MRS_Layer_Chip_Association__c>();
                            layerIterator.add(mrsLayerChipObj);
                            chipMap.put(mrsLayerChipObj.Chip__r.Name,layerIterator);
                        }
                        //TASK-1996
                        String strCompare='';
                        if(mrsLayerChipObj.ROM_Code__c!=null && mrsLayerChipObj.ROM_Code__c!='####' && mrsLayerChipObj.ROM_Code__c.toUpperCase()!='NULL'){
                            strCompare = mrsLayerChipObj.Layer__r.Name+mrsLayerChipObj.Layer__r.Mask_Layer_Rev__c+'('+mrsLayerChipObj.ROM_Code__c+'):'+mrsLayerChipObj.PTRF__r.Name+':'+mrsLayerChipObj.Chip__r.Name;                           
                        }else{
                            strCompare = mrsLayerChipObj.Layer__r.Name+mrsLayerChipObj.Layer__r.Mask_Layer_Rev__c+':'+mrsLayerChipObj.PTRF__r.Name+':'+mrsLayerChipObj.Chip__r.Name;        
                        }
                        mapStrCompareToIds.put(strCompare,mrsLayerChipObj.Id);
                        //TASK-1996
                    }                          
                } 
                if(mrsLayerChipList.size() <= maxSizeLimit){ // Task - 1864
                    chipSetSize = chipNameSet.size();                
                    Boolean isCheckboxActive = isPerformActive;                
                    if(isUserAdmin){
                        isPerformApprovalForUser = true;
                    }else{
                        if(isUserTapeoutOps){
                            isPerformApprovalForUser = false;
                        }
                        if(isUserFE && (jobviewName=='Customer')){
                            isPerformApprovalForUser = true;    
                        }
                        if(isUserGS && ((jobviewName=='Customer')||(jobviewName=='Foundry')||(jobviewName=='Global Shuttle'))){
                            isPerformApprovalForUser = true;    
                        }
                        if(isUserTDTIMPW && ((jobviewName=='Customer')||(jobviewName=='Foundry')||(jobviewName=='TDTI-MPW'))){
                            isPerformApprovalForUser = true;    
                        }
                        if(isUserMDP && jobviewName=='MDP'){
                            isPerformApprovalForUser = true;    
                        }
                        if(isUserTapeoutCenter && jobviewName=='Tapeout Centre'){
                            isPerformApprovalForUser = true;    
                        }
                        if(isUserTapeoutApp && jobviewName=='Tapeout Application'){
                            isPerformApprovalForUser = true;    
                        }   
                    }                                
                    if(!isjobViewer){               
                        if(isCheckboxActive && isPerformApprovalForUser){
                            isPerformActive = true; 
                        }else{
                            isPerformActive = false;
                        }
                        if(isGroupOrJobViewer && isCheckboxActive && jobviewName=='Foundry' && !isUserAdmin){
                            isPerformActive = true;    
                        }
                    }
                    else{
                        //TASK-1913
                        if(isCheckboxActive && (jobviewName=='Foundry'||jobviewName=='Customer')){
                            isPerformActive = true; 
                        }else{
                            isPerformActive = false;
                        }
                        //TASK-1913                     
                    }
                    //TASK-2115
                    if(flagNoStatusReady && isPerformActive){
                        isPerformActive = false;    
                    }
                    //TASK-2115
                }                                                            
                if(!applyFilters){
                    //Populating all the Filter Values from the set of retrieved values.
                    if(setPTRFs!=null && setPTRFs.size()>0){
                        for(String ptrf: setPTRFs){
                            ptrfList.add(new SelectOption(ptrf, ptrf)); 
                        }
                        ptrfList.sort();
                    } 
                    if(setChips!=null && setChips.size()>0){
                        for(String chip: setChips){
                            chipNameList.add(new SelectOption(chip, chip));
                        }
                        chipNameList.sort();
                    }
                    if(setMaskLayers!=null && setMaskLayers.size()>0){
                        for(String maskLayers: setMaskLayers){
                            maskLayerList.add(new SelectOption(maskLayers, maskLayers));
                        }
                        maskLayerList.sort();
                   
                    } 
                    if(setLayerStatuses!=null && setLayerStatuses.size()>0){
                        for(String statuses: setLayerStatuses){
                            layerStatusList.add(new SelectOption(statuses, statuses));   
                        }
                        layerStatusList.sort();                        
                    }
                    if(setDeviceIds!=null && setDeviceIds.size()>0){
                        for(String deviceId : setDeviceIds){                         
                            deviceIdList.add(new SelectOption(deviceId, deviceId));
                        } 
                        deviceIdList.sort();                        
                    }                    
                }
            //In case of no matching MRS Layer Chip Association records found, displaying appropriate Error Message on screen.                               
            }else{
                noRecords = true;
                isTableActive = false;
                isSelectionTableTrue = false; 
                Map<String,Error_Codes__c> mapErrorCodes = Error_Codes__c.getAll();
                ApexPages.Message  myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,' '+'No matching records exist.');
                ApexPages.addMessage(myMsg);        
            } 
            setChips.clear();
            setMaskLayers.clear();
            //setPTRFS.clear();
            setLayerStatuses.clear();           
            setDeviceIds.clear();
            Integer totalNoOfPtrfLimit=0;
            if(Environment_Variable__c.getInstance('MRS_MEBES_PTRF_SIZE_LIMIT').Value__c == '0' || Environment_Variable__c.getInstance('MRS_MEBES_PTRF_SIZE_LIMIT').Value__c == ''){
                totalNoOfPtrfLimit = 50;
            }else {
                totalNoOfPtrfLimit = Integer.valueOf(Environment_Variable__c.getInstance('MRS_MEBES_PTRF_SIZE_LIMIT').Value__c);
            }
            if(mrsLayerChipList.size() > maxSizeLimit){ // Task - 1864          
                isTableActive=false;
                isTechGeoActive = false;
                isPerformApprovalForUser = false;
                isSizeExceeded=true;
                //containsStatus.clear();
                //statusWithTimestamp.clear();
                //uniqueStatusMap.clear();  
                if(statusWrapperMap != null){  
                    statusWrapperMap.clear();    
                }   
            }else if(setPTRFS.size() > totalNoOfPtrfLimit ){
                //system.debug(LoggingLevel.ERROR,'Inside else if');
                isTableActive=false;
                isTechGeoActive = false;
                isPerformApprovalForUser = false;
                isSizeExceeded=false;
                isPerformActive=false;
                isNumberOfTotalPTRFExceeded=true;
                if(statusWrapperMap != null){  
                    statusWrapperMap.clear();    
                }
                setPTRFS.clear();   
            }else{
                //system.debug(LoggingLevel.ERROR,'inside else');
                displayTable();
                isNumberOfTotalPTRFExceeded=false;
                isSizeExceeded=false;                   
            }                         
            applyFilters = false;
        }        
                
    }
    
    /**
        This method applies all the filters when the filter values are selected and Apply button is clicked and repopulates the MEBES Jobview tables. 
        @method name: applyAllFilters
        @parameter:   None.
        @return :     None.
     **/
     
    public void applyAllFilters(){
        isProceedComplete = false;
        //Setting applyFilters to true and populating the MEBES Jobview table on screen 
        applyFilters = true;
        if(selectedCustomer!= null && selectedMST!= null && String.valueOf(selectedCustomer)!='' && String.valueOf(selectedMST)!=''){
            populateMEBESTable();
        }
    }
    
    /**
        This method clears all the filters when the Clear button is clicked and repopulates the MEBES Jobview tables. 
        @method name: clearAllFilters
        @parameter:   None.
        @return :     None.
     **/
     
    public void clearAllFilters(){
        isProceedComplete = false;
        if(selectedMST!= null && String.valueOf(selectedMST)!=''){
            isTableActive = true;           
        }else{
            isTableActive = false;           
        }   
        //Clearing and resetting all the Filter values and set of retrieved values and populating the MEBES Jobview table.     
        selectedLayerId = ''; 
        selectedLayerStatus = null; 
        selectedChipId = ''; 
        selectedDeviceId = ''; 
        selectedPTRFId = '';        
        setChips.clear();
        setMaskLayers.clear();
        setPTRFS.clear();
        setLayerStatuses.clear();       
        setDeviceIds.clear();
        if(selectedCustomer!= null && selectedMST!= null && String.valueOf(selectedCustomer)!='' && String.valueOf(selectedMST)!=''){       
            populateMEBESTable();
        }       
    }
    
    /**
        This method displays the MEBES Jobview tables. 
        @method name: displayTable
        @parameter:   None.
        @return :     None.
     **/
     
    public void displayTable(){
        displayTableList.clear();
        /*if(uniqueStatusMapChanged==null){
            uniqueStatusMapChanged = new Map<String,String>();
        }        
        if(uniqueStatusMap==null){
            uniqueStatusMap = new Map<String,String>();
        }        
        uniqueStatusMapChanged.clear();
        uniqueStatusMap.clear();*/
        chipWithCheckboxMap.clear();
        layerPtrfCheckbox.clear();
        WrapperDisplayTable displayObj;

        Integer counter = 1;

        if(mrsLayerChipList!=null && mrsLayerChipList.size()>0){                          
            Boolean flgForUniqueStatus;
            for(String strObj : layerPtrfSet){
                for(String chipObj : chipNameSet){
                    MRS_Layer_Chip_Association__c layerChipObj =new  MRS_Layer_Chip_Association__c();
                    flgForUniqueStatus = false;                   
                    if(layerChipMap.get(strObj+chipObj)!=null){
                        flgForUniqueStatus = true;
                        layerChipObj = layerChipMap.get(strObj+chipObj);
                    }
                    if(flgForUniqueStatus){
                        if(strObj.contains('####') || strObj.contains('null') || strObj.contains('NULL')){                            
                            if(jobviewName =='Customer'){

                                addToStatusMap(strObj.substringBeforeLast('(')+':'+chipObj+':'+strObj.substringAfterLast(':'),layerChipObj.Customer_MEBES_Jobview__c,'uniqueStatusMapChanged'); 
                            }else if(jobviewName =='Foundry'){

                                addToStatusMap(strObj.substringBeforeLast('(')+':'+chipObj+':'+strObj.substringAfterLast(':'),layerChipObj.Foundry_MEBES_Jobview__c,'uniqueStatusMapChanged'); 
                            }else if(jobviewName =='Tapeout Centre'){

                                addToStatusMap(strObj.substringBeforeLast('(')+':'+chipObj+':'+strObj.substringAfterLast(':'),layerChipObj.Tapeout_Centre_MEBES_Jobview__c,'uniqueStatusMapChanged'); 
                            }else if(jobviewName =='Tapeout Application'){

                                addToStatusMap(strObj.substringBeforeLast('(')+':'+chipObj+':'+strObj.substringAfterLast(':'),layerChipObj.Tapeout_Applications_MEBES_Jobview__c,'uniqueStatusMapChanged'); 
                            }else if(jobviewName =='Global Shuttle'){

                                addToStatusMap(strObj.substringBeforeLast('(')+':'+chipObj+':'+strObj.substringAfterLast(':'),layerChipObj.GlobalShuttle_MEBES_Jobview__c,'uniqueStatusMapChanged'); 
                            }else if(jobviewName =='MDP'){

                                addToStatusMap(strObj.substringBeforeLast('(')+':'+chipObj+':'+strObj.substringAfterLast(':'),layerChipObj.MDP_MEBES_Jobview__c,'uniqueStatusMapChanged'); 
                            }else if(jobviewName =='TDTI-MPW'){

                                addToStatusMap(strObj.substringBeforeLast('(')+':'+chipObj+':'+strObj.substringAfterLast(':'),layerChipObj.TDTI_MPW_MEBES_Jobview__c,'uniqueStatusMapChanged'); 
                            }                                                  

                            addToStatusMap(strObj.substringBeforeLast('(')+':'+chipObj+':'+strObj.substringAfterLast(':'),'true','containsStatus');                        
                        }else{                            
                            if(jobviewName =='Customer'){

                                addToStatusMap(strObj.substringBeforeLast(':')+':'+chipObj+':'+strObj.substringAfterLast(':'),layerChipObj.Customer_MEBES_Jobview__c,'uniqueStatusMapChanged'); 
                            }else if(jobviewName =='Foundry'){

                                addToStatusMap(strObj.substringBeforeLast(':')+':'+chipObj+':'+strObj.substringAfterLast(':'),layerChipObj.Foundry_MEBES_Jobview__c,'uniqueStatusMapChanged'); 
                            }else if(jobviewName =='Tapeout Centre'){

                                addToStatusMap(strObj.substringBeforeLast(':')+':'+chipObj+':'+strObj.substringAfterLast(':'),layerChipObj.Tapeout_Centre_MEBES_Jobview__c,'uniqueStatusMapChanged'); 
                            }else if(jobviewName =='Tapeout Application'){

                                addToStatusMap(strObj.substringBeforeLast(':')+':'+chipObj+':'+strObj.substringAfterLast(':'),layerChipObj.Tapeout_Applications_MEBES_Jobview__c,'uniqueStatusMapChanged'); 
                            }else if(jobviewName =='Global Shuttle'){

                                addToStatusMap(strObj.substringBeforeLast(':')+':'+chipObj+':'+strObj.substringAfterLast(':'),layerChipObj.GlobalShuttle_MEBES_Jobview__c,'uniqueStatusMapChanged'); 
                            }else if(jobviewName =='MDP'){

                                addToStatusMap(strObj.substringBeforeLast(':')+':'+chipObj+':'+strObj.substringAfterLast(':'),layerChipObj.MDP_MEBES_Jobview__c,'uniqueStatusMapChanged'); 
                            }else if(jobviewName =='TDTI-MPW'){

                                addToStatusMap(strObj.substringBeforeLast(':')+':'+chipObj+':'+strObj.substringAfterLast(':'),layerChipObj.TDTI_MPW_MEBES_Jobview__c,'uniqueStatusMapChanged'); 
                            }                                                             

                            addToStatusMap(strObj.substringBeforeLast(':')+':'+chipObj+':'+strObj.substringAfterLast(':'),'true','containsStatus');
                        }
                        //Populating the Map of the corrsponding Status to the Last Modified Timestamp
                        if(!strObj.contains('####') && !strObj.contains('null') && !strObj.contains('NULL')){                        
                            if(jobviewName =='Customer'){
                                if(layerChipObj.Customer_MEBES_Jobview_Date__c != null){

                                    addToStatusMap(strObj.substringBeforeLast(':')+':'+chipObj+':'+strObj.substringAfterLast(':'),layerChipObj.Customer_MEBES_Jobview_Date__c.format(),'statusWithTimestamp');
                                }else{

                                    addToStatusMap(strObj.substringBeforeLast(':')+':'+chipObj+':'+strObj.substringAfterLast(':'),'','statusWithTimestamp');
                                }        
                            }else if(jobviewName =='Foundry'){
                                if(layerChipObj.Foundry_MEBES_Jobview_Date__c!= null){

                                    addToStatusMap(strObj.substringBeforeLast(':')+':'+chipObj+':'+strObj.substringAfterLast(':'),layerChipObj.Foundry_MEBES_Jobview_Date__c.format(),'statusWithTimestamp');
                                }else{

                                }    addToStatusMap(strObj.substringBeforeLast(':')+':'+chipObj+':'+strObj.substringAfterLast(':'),'','statusWithTimestamp');
                            }else if(jobviewName =='Tapeout Centre'){
                                if(layerChipObj.Tapeout_Centre_MEBES_Jobview_Date__c!= null){

                                    addToStatusMap(strObj.substringBeforeLast(':')+':'+chipObj+':'+strObj.substringAfterLast(':'),layerChipObj.Tapeout_Centre_MEBES_Jobview_Date__c.format(),'statusWithTimestamp');
                                }else{

                                    addToStatusMap(strObj.substringBeforeLast(':')+':'+chipObj+':'+strObj.substringAfterLast(':'),'','statusWithTimestamp');
                                }    
                            }else if(jobviewName =='Tapeout Application'){
                                if(layerChipObj.Tapeout_Applications_MEBES_Jobview_Date__c!= null){

                                    addToStatusMap(strObj.substringBeforeLast(':')+':'+chipObj+':'+strObj.substringAfterLast(':'),layerChipObj.Tapeout_Applications_MEBES_Jobview_Date__c.format(),'statusWithTimestamp');
                                }else{

                                    addToStatusMap(strObj.substringBeforeLast(':')+':'+chipObj+':'+strObj.substringAfterLast(':'),'','statusWithTimestamp');
                                }    
                            }else if(jobviewName =='Global Shuttle'){
                                if(layerChipObj.GlobalShuttle_MEBES_Jobview_Date__c!= null){

                                    addToStatusMap(strObj.substringBeforeLast(':')+':'+chipObj+':'+strObj.substringAfterLast(':'),layerChipObj.GlobalShuttle_MEBES_Jobview_Date__c.format(),'statusWithTimestamp');
                                }else{

                                    addToStatusMap(strObj.substringBeforeLast(':')+':'+chipObj+':'+strObj.substringAfterLast(':'),'','statusWithTimestamp');
                                }    
                            }else if(jobviewName =='MDP'){
                                if(layerChipObj.MDP_MEBES_Jobview_Date__c!= null){

                                    addToStatusMap(strObj.substringBeforeLast(':')+':'+chipObj+':'+strObj.substringAfterLast(':'),layerChipObj.MDP_MEBES_Jobview_Date__c.format(),'statusWithTimestamp');
                                }else{

                                    addToStatusMap(strObj.substringBeforeLast(':')+':'+chipObj+':'+strObj.substringAfterLast(':'),'','statusWithTimestamp');
                                }    
                            }else if(jobviewName =='TDTI-MPW'){
                                if(layerChipObj.TDTI_MPW_MEBES_Date__c!= null){

                                    addToStatusMap(strObj.substringBeforeLast(':')+':'+chipObj+':'+strObj.substringAfterLast(':'),layerChipObj.TDTI_MPW_MEBES_Date__c.format(),'statusWithTimestamp');
                                }else{

                                    addToStatusMap(strObj.substringBeforeLast(':')+':'+chipObj+':'+strObj.substringAfterLast(':'),'','statusWithTimestamp');
                                }    
                            }
                        }else{
                            if(jobviewName =='Customer'){
                                if(layerChipObj.Customer_MEBES_Jobview_Date__c != null){

                                    addToStatusMap(strObj.substringBeforeLast('(')+':'+chipObj+':'+strObj.substringAfterLast(':'),layerChipObj.Customer_MEBES_Jobview_Date__c.format(),'statusWithTimestamp');
                                }else{

                                    addToStatusMap(strObj.substringBeforeLast('(')+':'+chipObj+':'+strObj.substringAfterLast(':'),'','statusWithTimestamp');
                                }        
                            }else if(jobviewName =='Foundry'){
                                if(layerChipObj.Foundry_MEBES_Jobview_Date__c!= null){

                                    addToStatusMap(strObj.substringBeforeLast('(')+':'+chipObj+':'+strObj.substringAfterLast(':'),layerChipObj.Foundry_MEBES_Jobview_Date__c.format(),'statusWithTimestamp');
                                }else{

                                    addToStatusMap(strObj.substringBeforeLast('(')+':'+chipObj+':'+strObj.substringAfterLast(':'),'','statusWithTimestamp');
                                }    
                            }else if(jobviewName =='Tapeout Centre'){
                                if(layerChipObj.Tapeout_Centre_MEBES_Jobview_Date__c!= null){

                                    addToStatusMap(strObj.substringBeforeLast('(')+':'+chipObj+':'+strObj.substringAfterLast(':'),layerChipObj.Tapeout_Centre_MEBES_Jobview_Date__c.format(),'statusWithTimestamp');
                                }else{

                                    addToStatusMap(strObj.substringBeforeLast('(')+':'+chipObj+':'+strObj.substringAfterLast(':'),'','statusWithTimestamp');
                                }    
                            }else if(jobviewName =='Tapeout Application'){
                                if(layerChipObj.Tapeout_Applications_MEBES_Jobview_Date__c!= null){

                                    addToStatusMap(strObj.substringBeforeLast('(')+':'+chipObj+':'+strObj.substringAfterLast(':'),layerChipObj.Tapeout_Applications_MEBES_Jobview_Date__c.format(),'statusWithTimestamp');
                                }else{

                                    addToStatusMap(strObj.substringBeforeLast('(')+':'+chipObj+':'+strObj.substringAfterLast(':'),'','statusWithTimestamp');
                                }    
                            }else if(jobviewName =='Global Shuttle'){
                                if(layerChipObj.GlobalShuttle_MEBES_Jobview_Date__c!= null){

                                    addToStatusMap(strObj.substringBeforeLast('(')+':'+chipObj+':'+strObj.substringAfterLast(':'),layerChipObj.GlobalShuttle_MEBES_Jobview_Date__c.format(),'statusWithTimestamp');
                                }else{

                                    addToStatusMap(strObj.substringBeforeLast('(')+':'+chipObj+':'+strObj.substringAfterLast(':'),'','statusWithTimestamp');
                                }    
                            }else if(jobviewName =='MDP'){
                                if(layerChipObj.MDP_MEBES_Jobview_Date__c!= null){

                                    addToStatusMap(strObj.substringBeforeLast('(')+':'+chipObj+':'+strObj.substringAfterLast(':'),layerChipObj.MDP_MEBES_Jobview_Date__c.format(),'statusWithTimestamp');
                                }else{

                                    addToStatusMap(strObj.substringBeforeLast('(')+':'+chipObj+':'+strObj.substringAfterLast(':'),'','statusWithTimestamp');
                                }    
                            }else if(jobviewName =='TDTI-MPW'){
                                if(layerChipObj.TDTI_MPW_MEBES_Date__c!= null){

                                    addToStatusMap(strObj.substringBeforeLast('(')+':'+chipObj+':'+strObj.substringAfterLast(':'),layerChipObj.TDTI_MPW_MEBES_Date__c.format(),'statusWithTimestamp');
                                }else{

                                    addToStatusMap(strObj.substringBeforeLast('(')+':'+chipObj+':'+strObj.substringAfterLast(':'),'','statusWithTimestamp');
                                }    
                            }
                        }                       
                    }else if(!flgForUniqueStatus) {
                        layerChipObj.Customer_MEBES_Jobview__c = '';
                        layerChipObj.Foundry_MEBES_Jobview__c = '';
                        layerChipObj.GlobalShuttle_MEBES_Jobview__c = '';
                        layerChipObj.MDP_MEBES_Jobview__c = '';
                        layerChipObj.Tapeout_Applications_MEBES_Jobview__c = '';
                        layerChipObj.Tapeout_Centre_MEBES_Jobview__c = '';
                        layerChipObj.TDTI_MPW_MEBES_Jobview__c = '';
                        if(strObj.contains('####') || strObj.contains('null') || strObj.contains('NULL')){                            
                            if(jobviewName =='Customer'){

                                addToStatusMap(strObj.substringBeforeLast('(')+':'+chipObj+':'+strObj.substringAfterLast(':'),layerChipObj.Customer_MEBES_Jobview__c,'uniqueStatusMapChanged'); 
                            }else if(jobviewName =='Foundry'){

                                addToStatusMap(strObj.substringBeforeLast('(')+':'+chipObj+':'+strObj.substringAfterLast(':'),layerChipObj.Foundry_MEBES_Jobview__c,'uniqueStatusMapChanged'); 
                            }else if(jobviewName =='Tapeout Centre'){

                                addToStatusMap(strObj.substringBeforeLast('(')+':'+chipObj+':'+strObj.substringAfterLast(':'),layerChipObj.Tapeout_Centre_MEBES_Jobview__c,'uniqueStatusMapChanged'); 
                            }else if(jobviewName =='Tapeout Application'){

                                addToStatusMap(strObj.substringBeforeLast('(')+':'+chipObj+':'+strObj.substringAfterLast(':'),layerChipObj.Tapeout_Applications_MEBES_Jobview__c,'uniqueStatusMapChanged'); 
                            }else if(jobviewName =='Global Shuttle'){

                                addToStatusMap(strObj.substringBeforeLast('(')+':'+chipObj+':'+strObj.substringAfterLast(':'),layerChipObj.GlobalShuttle_MEBES_Jobview__c,'uniqueStatusMapChanged'); 
                            }else if(jobviewName =='MDP'){

                                addToStatusMap(strObj.substringBeforeLast('(')+':'+chipObj+':'+strObj.substringAfterLast(':'),layerChipObj.MDP_MEBES_Jobview__c,'uniqueStatusMapChanged'); 
                            }else if(jobviewName =='TDTI-MPW'){

                                addToStatusMap(strObj.substringBeforeLast('(')+':'+chipObj+':'+strObj.substringAfterLast(':'),layerChipObj.TDTI_MPW_MEBES_Jobview__c,'uniqueStatusMapChanged'); 
                            }                                               

                            addToStatusMap(strObj.substringBeforeLast('(')+':'+chipObj+':'+strObj.substringAfterLast(':'),'false','containsStatus');
                        }else{                            
                            if(jobviewName =='Customer'){

                                addToStatusMap(strObj.substringBeforeLast(':')+':'+chipObj+':'+strObj.substringAfterLast(':'),layerChipObj.Customer_MEBES_Jobview__c,'uniqueStatusMapChanged'); 
                            }else if(jobviewName =='Foundry'){

                                addToStatusMap(strObj.substringBeforeLast(':')+':'+chipObj+':'+strObj.substringAfterLast(':'),layerChipObj.Foundry_MEBES_Jobview__c,'uniqueStatusMapChanged'); 
                            }else if(jobviewName =='Tapeout Centre'){

                                addToStatusMap(strObj.substringBeforeLast(':')+':'+chipObj+':'+strObj.substringAfterLast(':'),layerChipObj.Tapeout_Centre_MEBES_Jobview__c,'uniqueStatusMapChanged'); 
                            }else if(jobviewName =='Tapeout Application'){
                                
                                addToStatusMap(strObj.substringBeforeLast(':')+':'+chipObj+':'+strObj.substringAfterLast(':'),layerChipObj.Tapeout_Applications_MEBES_Jobview__c,'uniqueStatusMapChanged'); 
                            }else if(jobviewName =='Global Shuttle'){

                                addToStatusMap(strObj.substringBeforeLast(':')+':'+chipObj+':'+strObj.substringAfterLast(':'),layerChipObj.GlobalShuttle_MEBES_Jobview__c,'uniqueStatusMapChanged'); 
                            }else if(jobviewName =='MDP'){

                                addToStatusMap(strObj.substringBeforeLast(':')+':'+chipObj+':'+strObj.substringAfterLast(':'),layerChipObj.MDP_MEBES_Jobview__c,'uniqueStatusMapChanged'); 
                            }else if(jobviewName =='TDTI-MPW'){

                                addToStatusMap(strObj.substringBeforeLast(':')+':'+chipObj+':'+strObj.substringAfterLast(':'),layerChipObj.TDTI_MPW_MEBES_Jobview__c,'uniqueStatusMapChanged'); 
                            }                                                    

                            addToStatusMap(strObj.substringBeforeLast(':')+':'+chipObj+':'+strObj.substringAfterLast(':'),'false','containsStatus');
                        }
                        if(!strObj.contains('####') && !strObj.contains('null') && !strObj.contains('NULL')){

                            addToStatusMap(strObj.substringBeforeLast(':')+':'+chipObj+':'+strObj.substringAfterLast(':'),'','statusWithTimestamp');
                        }else{

                            addToStatusMap(strObj.substringBefore('(')+':'+chipObj+':'+strObj.substringAfterLast(':'),'','statusWithTimestamp');
                        }
                    }
                }
            }
            //uniqueStatusMapChanged = uniqueStatusMap; 
            Boolean flagForChip;
            //Setting the flags for populating checkboxes besides the combination of Layer and Chip having the MEBES Jobview status as Ready
            for(String chipNameObj : chipNameSet){
                flagForChip = false;                
                for(MRS_Layer_Chip_Association__c mrsLayerChipObj : chipMap.get(chipNameObj)){                   
                    if(jobviewName=='Customer'){
                        if(mrsLayerChipObj.Customer_MEBES_Jobview__c == 'Ready'){
                            flagForChip = true;
                            break;
                        }
                    }else if(jobviewName=='Foundry'){
                        if(mrsLayerChipObj.Foundry_MEBES_Jobview__c == 'Ready'){
                            flagForChip = true;
                            break;
                        }
                    }else if(jobviewName=='Tapeout Centre'){
                        if(mrsLayerChipObj.Tapeout_Centre_MEBES_Jobview__c == 'Ready'){
                            flagForChip = true;
                            break;
                        }
                    }else if(jobviewName=='Tapeout Application'){
                        if(mrsLayerChipObj.Tapeout_Applications_MEBES_Jobview__c == 'Ready'){
                            flagForChip = true;
                            break;
                        }
                    }else if(jobviewName=='Global Shuttle'){
                        if(mrsLayerChipObj.GlobalShuttle_MEBES_Jobview__c == 'Ready'){
                            flagForChip = true;
                            break;
                        }
                    }else if(jobviewName=='MDP'){
                        if(mrsLayerChipObj.MDP_MEBES_Jobview__c == 'Ready'){
                            flagForChip = true;
                            break;
                        }
                    }else if(jobviewName=='TDTI-MPW'){
                        if(mrsLayerChipObj.TDTI_MPW_MEBES_Jobview__c == 'Ready'){
                            flagForChip = true;
                            break;
                        }
                    }                    
                }
                if(flagForChip)
                    chipWithCheckboxMap.put(chipNameObj,true);
                else
                    chipWithCheckboxMap.put(chipNameObj,false);
            }
            for(String layerPtrfObj : layerPtrfSet){
                flagForChip = false;                
                for(MRS_Layer_Chip_Association__c mrsLayerChipObj : layerPtrfMap.get(layerPtrfObj)){    
                    if(jobviewName=='Customer'){
                        if(mrsLayerChipObj.Customer_MEBES_Jobview__c == 'Ready'){
                            flagForChip = true;
                            break;
                        }
                    }else if(jobviewName=='Foundry'){
                        if(mrsLayerChipObj.Foundry_MEBES_Jobview__c == 'Ready'){
                            flagForChip = true;
                            break;
                        }
                    }else if(jobviewName=='Tapeout Centre'){
                        if(mrsLayerChipObj.Tapeout_Centre_MEBES_Jobview__c == 'Ready'){
                            flagForChip = true;
                            break;
                        }
                    }else if(jobviewName=='Tapeout Application'){
                        if(mrsLayerChipObj.Tapeout_Applications_MEBES_Jobview__c == 'Ready'){
                            flagForChip = true;
                            break;
                        }
                    }else if(jobviewName=='Global Shuttle'){
                        if(mrsLayerChipObj.GlobalShuttle_MEBES_Jobview__c == 'Ready'){
                            flagForChip = true;
                            break;
                        }
                    }else if(jobviewName=='MDP'){
                        if(mrsLayerChipObj.MDP_MEBES_Jobview__c == 'Ready'){
                            flagForChip = true;
                            break;
                        }
                    }else if(jobviewName=='TDTI-MPW'){
                        if(mrsLayerChipObj.TDTI_MPW_MEBES_Jobview__c == 'Ready'){
                            flagForChip = true;
                            break;
                        }
                    }                   
                }
                if(layerPtrfObj.contains('null')||layerPtrfObj.contains('NULL')||layerPtrfObj.contains('####')){
                    if(flagForChip)
                        layerPtrfCheckbox.put(layerPtrfObj.substringBefore('(')+layerPtrfObj.substringAfter(')'),true);
                    else
                        layerPtrfCheckbox.put(layerPtrfObj.substringBefore('(')+layerPtrfObj.substringAfter(')'),false);
                }else {
                    if(flagForChip)
                        layerPtrfCheckbox.put(layerPtrfObj,true);
                    else
                        layerPtrfCheckbox.put(layerPtrfObj,false);
                }
            }        
            Boolean flag = true;
            for(String strObj : layerPtrfSet){                
                MRS_Layer_Chip_Association__c mrsLayerChipObj = layerPtrfMap.get(strObj).get(0);             
                if(flag){
                    displayObj = new WrapperDisplayTable(counter,strObj.substringBeforeLast(':'),strObj.substringAfterLast(':'),mrsLayerChipObj.PTRF__r.Tech_Geo__c,flag,mrsLayerChipObj.PTRF__c);
                    flag = false;
                }else {
                    displayObj = new WrapperDisplayTable(counter,strObj.substringBeforeLast(':'),strObj.substringAfterLast(':'),mrsLayerChipObj.PTRF__r.Tech_Geo__c,flag,mrsLayerChipObj.PTRF__c);
                    flag = true;
                }
                displayTableList.add(displayObj);
                counter = counter + 1;                       
            }
            //Displaying the MEBES Jobview table on screen with the updated values
            otherdisplayTableList = new List<OtherWrapperDisplayTable>();
            OtherWrapperDisplayTable otherwrapperDsplTableObj;
            for(WrapperDisplayTable wrapperDsplTableObj : displayTableList){                       
                if(wrapperDsplTableObj.maskLayerROMCode.contains('null')||wrapperDsplTableObj.maskLayerROMCode.contains('NULL')||wrapperDsplTableObj.maskLayerROMCode.contains('####')){
                    otherwrapperDsplTableObj = new OtherWrapperDisplayTable();
                    otherwrapperDsplTableObj.slNo = wrapperDsplTableObj.slNo;
                    otherwrapperDsplTableObj.ptrfId = wrapperDsplTableObj.ptrfId;                
                    otherwrapperDsplTableObj.maskLayerROMCode = wrapperDsplTableObj.maskLayerROMCode.substringBefore('(');
                    otherwrapperDsplTableObj.ptrf = wrapperDsplTableObj.ptrf;
                    otherwrapperDsplTableObj.isColor = wrapperDsplTableObj.isColor ;
                    otherwrapperDsplTableObj.TechGeo = wrapperDsplTableObj.TechGeo;
                    otherwrapperDsplTableObj.key = wrapperDsplTableObj.maskLayerROMCode;
                    otherdisplayTableList.add(otherwrapperDsplTableObj);
                    mapPTRFNamesToIds.put(otherwrapperDsplTableObj.ptrf,otherwrapperDsplTableObj.ptrfId);               
                }else{
                    otherwrapperDsplTableObj = new OtherWrapperDisplayTable();
                    otherwrapperDsplTableObj.slNo = wrapperDsplTableObj.slNo;
                    otherwrapperDsplTableObj.ptrfId = wrapperDsplTableObj.ptrfId;
                    otherwrapperDsplTableObj.maskLayerROMCode = wrapperDsplTableObj.maskLayerROMCode;
                    otherwrapperDsplTableObj.ptrf = wrapperDsplTableObj.ptrf;
                    otherwrapperDsplTableObj.isColor = wrapperDsplTableObj.isColor ;
                    otherwrapperDsplTableObj.TechGeo = wrapperDsplTableObj.TechGeo;
                    otherwrapperDsplTableObj.key = wrapperDsplTableObj.maskLayerROMCode;
                    otherdisplayTableList.add(otherwrapperDsplTableObj);
                    mapPTRFNamesToIds.put(otherwrapperDsplTableObj.ptrf,otherwrapperDsplTableObj.ptrfId);
                }                      
            }          
        }
    }
     
    /**
        This method performs Approval on the records displayed when the Perform Approval button is clicked. 
        @method name: performReview
        @parameter:   None.
        @return :     None.
    **/
    
    public void performReview(){
       isProceedComplete = false;              
       isSelectionTableTrue = true;
       imageActive = false;
       labelorDropdown = false;
       errorMessage = false;
       noRecords = false;
       //TASK-2115
       if(pageName == 'FoundryMEBES' && jobviewName == 'Foundry' && isUserFoundryJobviewer && isUserFE && !isUserAdmin && !isUserGS && !isUserTDTIMPW && !isUserMDP 
       && !isUserTapeoutOps && !isUserTapeoutCenter && !isUserTapeoutApp){//TASK-2302
            isJobViewer=true;
            populateMEBESTable();            
       }else{
       //TASK-2115     
           /*if(uniqueStatusMapChanged==null){
                uniqueStatusMapChanged = new Map<String,String>();            
           }
           uniqueStatusMapChanged = uniqueStatusMap;  */ 
        } 
        isTableActive = false;
        isPerformActive = false;     
    }
   
    /**
        This method populates the table from JSON corresponding to those records which are selected for Performing Approval. 
        @method name: approvalData
        @parameter:   None.
        @return :     None.
     **/
     
    public void approvalData(){
       isConfirmApproved = true;  
       //Populating the Wrapper Tables from JSON populated in the vsualforce page  
       lstMainTableData = (List<WrapperChip>)JSON.deserialize(mainTableJSON,List<WrapperChip>.class);  
       lstsideTableData = (List<WrapperLayerPtrf>)JSON.deserialize(sideHeaderJSON,List<WrapperLayerPtrf>.class);
       lstgridData = (List<WrapperStatusCheck>)JSON.deserialize(gridTblJSON,List<WrapperStatusCheck>.class);   
       mapForApprove.clear();       
       isPerformActive = false;
       isTableActive = false;
       isSelectionTableTrue = false;
       List<String> layerChipPtrf = new List<String>();
       //Populating the unique combination of selected Layers and Chips for Perform Approval
       for(WrapperLayerPtrf layerPtrfObj : lstsideTableData){
           for(WrapperChip wrapperChipObj : lstMainTableData){
               layerChipPtrf.add(layerPtrfObj.maskLayer+':'+layerPtrfObj.ptrf+':'+wrapperChipObj.chip);
           }
       }
       Integer counter = 0;
       for(String strObj : layerChipPtrf){
           mapForApprove.put(strObj,lstgridData.get(counter));
           counter = counter + 1;
       }
       //Calling displayChecked method for displaying only the selected and checked Layer Chip values on the last screen for Releasing
       displayChecked(lstMainTableData,lstsideTableData,lstgridData);
   } 
   
   /**
        This method displays only the records checked for Performing Approval in the last page of the MEBES Jobview screens. 
        @method name: displayChecked
        @parameter:   1. List of WrapperChip records.
                      2. List of WrapperLayerPtrf records.
                      3. List of WrapperStatusCheck records.
        @return :     None.
    **/  
    
   public void displayChecked(List<WrapperChip> lstMainTableData,List<WrapperLayerPtrf> lstsideTableData,List<WrapperStatusCheck> lstgridData){                   
       Integer diff = lstgridData.size() / lstsideTableData.size();
       Map<Integer,String> interval = new Map<Integer,String>();
       Integer count = 0;
       for(Integer i=0;i<lstgridData.size();i=i+diff){
           interval.put(count,String.valueOf(i)+'-'+String.valueOf(i+diff-1));
           count ++;
       }       
       lstChip = new List<WrapperChip>();
       lstLayer = new List<WrapperLayerPtrf>();      
       List<Integer> positionChecked = new List<Integer>();
       List<Integer> layerPosition = new List<Integer>();
       List<Integer> chipPosition = new List<Integer>();
       Integer counter = 0;
       for(WrapperStatusCheck statusObj : lstgridData){
           if(statusObj.flagSet == 'CHECKED' && statusObj.status == 'Ready'){
               positionChecked.add(counter);
           }
           counter ++;
       }
       //Generating only the selected and checked Layer Chip values on the last screen for Releasing
       Set<String> chipName = new Set<String>();
       Set<String> layerName = new Set<String>();
       for(Integer position : positionChecked){
           for(Integer key : interval.keySet()){
               if(Integer.valueOf(interval.get(key).substringBefore('-'))<= position && position<=Integer.valueOf(interval.get(key).substringAfter('-'))){
                   if(!layerName.contains(lstsideTableData.get(key).maskLayer+'-'+lstsideTableData.get(key).ptrf)){
                       lstsideTableData.get(key).ptrfId = mapPTRFNamesToIds.get(lstsideTableData.get(key).ptrf);
                       lstLayer.add(lstsideTableData.get(key));
                       layerPosition.add(key);
                       layerName.add(lstsideTableData.get(key).maskLayer+'-'+lstsideTableData.get(key).ptrf);
                   }
                   if(!chipName.contains(lstMainTableData.get(position-(key*diff)).chip)) {
                       lstChip.add(lstMainTableData.get(position-(key*diff)));
                       chipPosition.add(position-(key*diff));
                       chipName.add(lstMainTableData.get(position-(key*diff)).chip);
                   }
               }
           }    
       }
       List<WrapperStatusCheck> checkedStatus = new List<WrapperStatusCheck>();
       for(Integer layerInt : layerPosition){
           for(Integer chipInt : chipPosition){
               checkedStatus.add(lstgridData.get((layerInt*diff)+chipInt));
           }
       }
       mapForApprove.clear();
       List<String> layerPtrfChip = new List<String>();
       for(WrapperLayerPtrf layerWrapper : lstLayer){
           for(WrapperChip chipWrapper : lstChip)
           {
               layerPtrfChip.add(layerWrapper.maskLayer+':'+layerWrapper.ptrf+':'+chipWrapper.chip);
           }
       }
       Integer pos = 0;
       for(String strObj : layerPtrfChip){
           mapForApprove.put(strObj,checkedStatus.get(pos));
           pos = pos +1;
       }        
       if((isUserGS||isUserTDTIMPW) && ((jobviewName=='Customer')||(jobviewName=='Foundry'))){
            isReleaseComments =  true;          
       }       
    }
   
   /**
        This method saves the data into the database, when MEBES Jobview Perform Approval process is completed. 
        @method name: saveData
        @parameter:   None.
        @return :     None.
    **/ 
    
   public void saveData(){
       
       //If Release Comments is required, then displaying error message for blank Comment, else continuing with Release process
       if(isReleaseComments && (releaseReasonTxt==null || releaseReasonTxt.trim()=='')){
           
           Map<String,Error_Codes__c> mapErrorCodes = Error_Codes__c.getAll();
           ApexPages.Message  myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,' '+mapErrorCodes.get('MRS_RELEASE_COMMENT_MANDATORY').Message__c);
           ApexPages.addMessage(myMsg); 
           errorMessage=true;   
       }else{
           
           errorMessage = false;
        isRecordLocked = false;
            ApexPages.getMessages().clear();
           
           ApexPages.Message myMsg = null;
           Map<String,Error_Codes__c> mapErrorCodes = Error_Codes__c.getAll();
           Map<Id,List<MRS_Layer_Chip_Association__c>> techGeoAndId = new Map<Id,List<MRS_Layer_Chip_Association__c>>();       
           List<MRS_Layer_Chip_Association__c> mrsLayerChiplst;
           List<MRS_Layer_Chip_Association__c> lstMRSLCAToUpdate = new List<MRS_Layer_Chip_Association__c>();
           set<String> setLayerChipId = new set<String>();
           //TASK-1996
           for(String key: mapForApprove.keySet()){
                if(mapStrCompareToIds.size()>0 && mapStrCompareToIds.containsKey(key)){
                    if(mapForApprove.get(key).flagSet == 'CHECKED' && mapForApprove.get(key).status == 'Ready'){
                        setLayerChipId.add(mapStrCompareToIds.get(key));
                    }       
                }   
           }
           //TASK-1996               
           if(setLayerChipId.size()>0){
               
                try{
                    lstMRSLCAToUpdate = [SELECT Customer_MEBES_Jobview_Date__c,Customer_MEBES_Jobview__c,
                                                Foundry_MEBES_Jobview_Date__c,Foundry_MEBES_Jobview__c,
                                                GlobalShuttle_MEBES_Jobview_Date__c,GlobalShuttle_MEBES_Jobview__c,
                                                MDP_MEBES_Jobview_Date__c,MDP_MEBES_Jobview__c,PTRF__c,
                                                Tapeout_Applications_MEBES_Jobview_Date__c,Tapeout_Applications_MEBES_Jobview__c,
                                                Tapeout_Centre_MEBES_Jobview_Date__c,Tapeout_Centre_MEBES_Jobview__c,
                                                TDTI_MPW_MEBES_Date__c,TDTI_MPW_MEBES_Jobview__c,Id,Name,
                                                ROM_Code__c,Layer__r.Name,Layer__r.Mask_Layer_Rev__c,
                                                Chip__c,Chip__r.Name,PTRF__r.Tech_Geo__c,PTRF__r.MaskSetTitle__r.Name,
                                                PTRF__r.MaskSetTitle__c,PTRF__r.Device__c,PTRF__r.Device__r.Name,
                                                PTRF__r.Device_Id__c,PTRF__r.Name,Layer__c,LastModifiedById,Layer__r.ROM_Code__c,
                                                Layer__r.Layer_Status__c,Device_Id__c,Tech_Geo__c,PTRF__r.Recticle_Type__c
                                                FROM MRS_Layer_Chip_Association__c where Id IN:setLayerChipId FOR UPDATE];  
                }catch(Exception ex){
                    if(ex.getMessage().containsIgnoreCase(mapErrorCodes.get('DRT_Lock_SFDC_Error').Message__c)) {
                        
                        myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,mapErrorCodes.get('MRS_Lock_Error').Message__c);                                              
                        ApexPages.addMessage(myMsg);
                        errorMessage=true;
                        isRecordLocked = true;
                    }                           
                }       
           }

           if(lstMRSLCAToUpdate!=null && lstMRSLCAToUpdate.size()>0 && !isRecordLocked){            
                MRSHandlerUtility.numberOfLayerChipRecords = lstMRSLCAToUpdate.size();
                for(MRS_Layer_Chip_Association__c mrsLayerChipObj:lstMRSLCAToUpdate){
                    String strUniqueLayerChip;
                    //Generating Unique Layer Chip Values
                    if(mrsLayerChipObj.ROM_Code__c!=null && mrsLayerChipObj.ROM_Code__c!='####' && mrsLayerChipObj.ROM_Code__c.toUpperCase()!='NULL'){
                        strUniqueLayerChip = mrsLayerChipObj.Layer__r.Name+mrsLayerChipObj.Layer__r.Mask_Layer_Rev__c+mrsLayerChipObj.ROM_Code__c+mrsLayerChipObj.Chip__r.Name+mrsLayerChipObj.PTRF__r.Tech_Geo__c;
                    }else{
                        strUniqueLayerChip = mrsLayerChipObj.Layer__r.Name+mrsLayerChipObj.Layer__r.Mask_Layer_Rev__c+mrsLayerChipObj.Chip__r.Name+mrsLayerChipObj.PTRF__r.Tech_Geo__c;
                    }                                     
                    //If there are existing Duplicate Chips and Duplicate Frames (For Tapeout Centre), then displaying appropriate error message on screen, else continuing with the Release process
                    if(mapUniqueLayerChips!=null&& mapUniqueLayerChips.containsKey(strUniqueLayerChip)&& (mapUniqueLayerChips.get(strUniqueLayerChip)>1)
                    && (((jobviewName == 'Tapeout Centre')&&(mrsLayerChipObj.Chip__r.Name=='Frame'))||(mrsLayerChipObj.Chip__r.Name!='Frame'))){                        
                        if((jobviewName == 'Tapeout Centre')&&(mrsLayerChipObj.Chip__r.Name=='Frame')){
                            myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,' '+mapErrorCodes.get('MRS_DUPLICATE_FRAMES_IN_MEBES').Message__c);                              
                        }else if(mrsLayerChipObj.Chip__r.Name!='Frame'){
                            myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,' '+mapErrorCodes.get('MRS_DUPLICATE_CHIPS_IN_MEBES').Message__c+' '+mrsLayerChipObj.Chip__r.Name);          
                        } 
                        ApexPages.addMessage(myMsg);
                        errorMessage=true;                                                      
                    }else{
                        if(jobViewName =='Customer'){
                           mrsLayerChipObj.Customer_MEBES_Jobview__c = 'Released';
                           mrsLayerChipObj.Customer_MEBES_Jobview_Date__c = System.now();                                                                                  
                        }else if(jobviewName=='Foundry'){
                           mrsLayerChipObj.Foundry_MEBES_Jobview__c = 'Released';
                           mrsLayerChipObj.Foundry_MEBES_Jobview_Date__c = System.now();                                             
                        }else if(jobviewName=='Tapeout Centre'){
                           mrsLayerChipObj.Tapeout_Centre_MEBES_Jobview__c = 'Released';
                           mrsLayerChipObj.Tapeout_Centre_MEBES_Jobview_Date__c = System.now();                                                    
                        }else if(jobviewName=='Tapeout Application'){
                           mrsLayerChipObj.Tapeout_Applications_MEBES_Jobview__c = 'Released';
                           mrsLayerChipObj.Tapeout_Applications_MEBES_Jobview_Date__c = System.now();                      
                        }else if(jobviewName=='Global Shuttle'){
                           mrsLayerChipObj.GlobalShuttle_MEBES_Jobview__c = 'Released';
                           mrsLayerChipObj.GlobalShuttle_MEBES_Jobview_Date__c = System.now();                      
                        }else if(jobviewName=='MDP'){
                           mrsLayerChipObj.MDP_MEBES_Jobview__c = 'Released';
                           mrsLayerChipObj.MDP_MEBES_Jobview_Date__c = System.now();                     
                        }else if(jobviewName=='TDTI-MPW'){
                           mrsLayerChipObj.TDTI_MPW_MEBES_Jobview__c = 'Released';
                           mrsLayerChipObj.TDTI_MPW_MEBES_Date__c = System.now();                      
                        }                                                                   
                        if(techGeoAndId.get(mrsLayerChipObj.PTRF__c) ==null){
                            mrsLayerChiplst = new List<MRS_Layer_Chip_Association__c>();
                            mrsLayerChiplst.add(mrsLayerChipObj);
                            techGeoAndId.put(mrsLayerChipObj.PTRF__c,mrsLayerChiplst);
                        }else{
                            techGeoAndId.get(mrsLayerChipObj.PTRF__c).add(mrsLayerChipObj);
                        }
                    }                                                                                                                                              
                }
           }
                                 
           if(!isRecordLocked){                         
               //After releasing the Chips/Frames, sending Email to Reviewers through MRSHandlerUtility.sendEmailToReviewers method                      
               try{
                    update lstMRSLCAToUpdate;
                    
                    //only send email after update successfully 
                    if((jobViewName =='Customer')||(jobViewName =='Foundry')||(jobViewName =='Global Shuttle')){//CR019
                        MRSHandlerUtility.sendEmailToReviewers(techGeoAndId,pageName,selectedCustomer,null,releaseReasonTxt,'');
                    }//CR019
                    
                    if(isReleaseComments && lstMRSLCAToUpdate!=null && lstMRSLCAToUpdate.size()>0 && !isRecordLocked){ 
                        
                       //After releasing the Chips/Frames, populating the Release Comments in the child Notes object, if Release Comments was required         
                       List<Notes__c> lstNote = new List<Notes__c>();  
                       for(MRS_Layer_Chip_Association__c mrsLayerChipObj : lstMRSLCAToUpdate){                   
                           Notes__c objNote = new Notes__c();
                           objNote.ParentId__c = mrsLayerChipObj.Id;
                           objNote.Body__c = releaseReasonTxt;                  
                           if(jobViewName =='Customer'){
                               objNote.Category__c = 'Customer MEBES Jobview';
                           }else if(jobViewName =='Foundry'){
                               objNote.Category__c = 'Foundry MEBES Jobview';
                           }else if(jobViewName =='Tapeout Centre'){
                               objNote.Category__c = 'Tapeout Centre/MDP MEBES Jobview';
                           }else if(jobViewName =='Tapeout Application'){
                               objNote.Category__c = 'Tapeout Applications MEBES Jobview';
                           }else if(jobViewName =='Global Shuttle'){
                               objNote.Category__c = 'GlobalShuttle/TDTI-MPW MEBES Jobview';
                           }else if(jobViewName =='MDP'){
                               objNote.Category__c = 'Tapeout Centre/MDP MEBES Jobview';
                           }else if(jobViewName =='TDTI-MPW'){
                               objNote.Category__c = 'GlobalShuttle/TDTI-MPW MEBES Jobview';
                           }
                           lstNote.add(objNote);     
                        }
                        insert lstNote;
                    }                    
               }catch(Exception ex){
                   
                   MRSHandlerUtility.saveMRSExceptionErrorLog(ex, 'MRS Layer Chip Association','','MRSMEBESJobviewExtn','executeUpdateMCLA');  
                   if(ex.getMessage().containsIgnoreCase('EXCEEDED')){      
                        myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,mapErrorCodes.get('MRS_EMAIL_LIMIT_EXCEEDED').Message__c);                                              
                        ApexPages.addMessage(myMsg);
                        errorMessage=true;
                   } else {
                       myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,mapErrorCodes.get('MRS_Lock_Error').Message__c);
                        ApexPages.addMessage(myMsg);
                        errorMessage=true;
                   }
               }
               //TASK-2115
               if(isUserFE && isUserFoundryJobviewer && isJobViewer && (jobviewName == 'Foundry')){
                    isJobViewer = false;    
               }
               //TASK-2115
               isConfirmApproved = false;
               imageActive = true;
               labelorDropdown = true;
               releaseReasonTxt = '';
               isReleaseComments = false; 
               isProceedComplete = true;          
               populateMEBESTable();
           }           
       }     
   }
   
   /**
        This method discards the selected records for MEBES Jobview when the Discard button is clicked. 
        @method name: discardSelection
        @parameter:   None.
        @return :     None.
    **/ 
    
   public void discardSelection(){
       releaseReasonTxt = '';
       isConfirmApproved = false;
       isSelectionTableTrue = true;
       errorMessage = false;
       isReleaseComments = false;
       system.debug('errorMessage: '+ errorMessage);
       /*if(uniqueStatusMapChanged==null){
            uniqueStatusMapChanged = new Map<String,String>();            
       }
       uniqueStatusMapChanged = uniqueStatusMap;*/               
   }
   
   /**
        This method exports the data present in the MEBES Jobview tables to Excel format. 
        @method name: exportToExcel
        @parameter:   None.
        @return :     The MEBES Jobview screen.
    **/
    
   public PageReference exportToExcel(){
       /*if(uniqueStatusMapChanged==null){
            uniqueStatusMapChanged = new Map<String,String>();            
       }
       uniqueStatusMapChanged = uniqueStatusMap;*/              
       if(isTableActive)
           return Page.VFMRSMEBESJobviewToExcel;
       else
           return null;
   }
   
   /**
        This method exports the data present in the MEBES Jobview tables to PDF format. 
        @method name: exportToPDF
        @parameter:   None.
        @return :     The MEBES Jobview screen.
    **/
    
   public PageReference exportToPDF(){
       if(isTableActive)
           return Page.VFMRSMEBESJobviewToPDF;
       else
           return null;
   }
   
   /**
        This method exports the data present in the MEBES Jobview tables to CSV format. 
        @method name: exportToCSV
        @parameter:   None.
        @return :     The MEBES Jobview screen.
    **/
    
   public PageReference exportToCSV(){
       /*if(uniqueStatusMapChanged==null){
            uniqueStatusMapChanged = new Map<String,String>();           
       }       
       uniqueStatusMapChanged = uniqueStatusMap; */      
       if(isTableActive)
           return Page.VFMRSMEBESJobviewToCSV;
       else
           return null;
   }
   
    /** Wrapper Classes 
     **/  
        
    public class OtherWrapperDisplayTable {
        public Integer slNo {get;set;}
        public String maskLayerROMCode {get;set;}
        public String ptrf {get;set;}
        public String ptrfId {get;set;}
        public Boolean isColor {get;set;}
        public String TechGeo {get;set;}
        public String key{get;set;}
    }   
    public class WrapperDisplayTable {
        public Integer slNo {get;set;}
        public String maskLayerROMCode {get;set;}
        public String ptrf {get;set;}
        public String ptrfId {get;set;}
        public Boolean isColor {get;set;}
        public String TechGeo {get;set;}        
        public WrapperDisplayTable(Integer slNo,String maskLayerROMCode,String ptrf,String TechGeo,Boolean isColor,String ptrfId){            
            this.slNo = slNo;
            this.maskLayerROMCode = maskLayerROMCode;
            this.ptrf = ptrf;
            this.TechGeo = TechGeo;
            this.isColor = isColor;
            this.ptrfId=ptrfId;
        }
    }   
    public class WrapperChip {
        public String chip {get;set;}
        public WrapperChip(String chip) {
            this.chip = chip;
        }
    }
    public class WrapperLayerPtrf {
        public String slNo {get;set;}
        public String maskLayer {get;set;}
        public String ptrf {get;set;}
        public String ptrfId {get;set;}
        public String techGeo {get;set;}        
        public WrapperLayerPtrf(String slNo,String maskLayer,String ptrf,String ptrfId,String techgeo) {
            this.slNo =slNo;
            this.maskLayer = maskLayer;
            this.ptrf = ptrf;
            this.ptrfId = ptrfId;
            this.techgeo=techgeo;            
        }
    }    
    public class WrapperStatusCheck{
        public String flagSet {get;set;}
        public String status {get;set;}
        public WrapperStatusCheck(String flagSet,String status) {
            this.flagSet = flagSet ;
            this.status = status;
        } 
    }
    
    //TASK-2058
    /**
        Select Option Getter Methods
    **/    
    public List<SelectOption> getMaskLayerList0(){
        return getNthSubList(0);
    }    
    public List<SelectOption> getMaskLayerList1(){
        return getNthSubList(1);
    }
    public List<SelectOption> getMaskLayerList2(){
        return getNthSubList(2);
    }
    public List<SelectOption> getMaskLayerList3(){
        return getNthSubList(3);
    }
    public List<SelectOption> getMaskLayerList4(){
        return getNthSubList(4);
    }
    public List<SelectOption> getMaskLayerList5(){
        return getNthSubList(5);
    }
    public List<SelectOption> getMaskLayerList6(){
        return getNthSubList(6);
    }
    public List<SelectOption> getMaskLayerList7(){
        return getNthSubList(7);
    }
    public List<SelectOption> getMaskLayerList8(){
        return getNthSubList(8);
    }
    public List<SelectOption> getMaskLayerList9(){
        return getNthSubList(9);
    }
    
    /**
        This method gets the nth list of apex:selectOptions. 
        @method name: getNthSubList
        @parameter:   Index number.
        @return :     List of SelectOption.
    **/      
    public List<SelectOption> getNthSubList(Integer index){
        Integer subListCount=(Integer)(maskLayerList.size()/SUB_LIST_SIZE);
        if(Math.mod(maskLayerList.size(),SUB_LIST_SIZE)>0)
            subListCount++;       
        if(index>=0 && index<=subListCount){
            Integer startIndex=index*SUB_LIST_SIZE;
            Integer endIndex=index*SUB_LIST_SIZE+(SUB_LIST_SIZE-1);
            if(endIndex>=maskLayerList.size())
               endIndex=maskLayerList.size()-1;             
            return getSubList(startIndex,endIndex);
        }else{
            return new List<SelectOption>();
        }
    } 
    
    /**
        This method gets the nth subList of apex:selectOptions. 
        @method name: getSubList
        @parameter:   1. Start Index.
                      2. End Index
        @return :     List of SelectOption.
    **/      
    public List<SelectOption> getSubList(Integer startIndex,Integer endIndex){
        List<SelectOption> subList=new List<SelectOption>();
        if(startIndex>-1 && startIndex<maskLayerList.size()&& endIndex>-1 && endIndex<maskLayerList.size() && startIndex<=endIndex){
            for(Integer i=startIndex;i<=endIndex;i++){
                subList.add(get(i));
            }
        }
        return subList;
    }  
    
    /**
        This method gets the selectOption. 
        @method name: get
        @parameter:   Integer index.
        @return :     SelectOption.
    **/   
    public SelectOption get(Integer index){
        if(index>-1 && index<maskLayerList.size()){
            return maskLayerList.get(index);
        }else{
            return null;
        }    
    }   
    //TASK-2058   
    
    public class statusWrapper{
        public Boolean isKey{get;set;}
        public String uniqueStatusMapChangedValue{get;set;}
        public String statusWithTimestampValue{get;set;}
        
        public statusWrapper(){}
    }
    
    @TestVisible
    private void addToStatusMap(string key,string value,string type_map)  {
        if(statusWrapperMap != null){
            if(statusWrapperMap.containsKey(key)){
                statusWrapper swObj = statusWrapperMap.get(key);
                if(type_map == 'uniqueStatusMapChanged'){
                    swObj.uniqueStatusMapChangedValue=value;
                }else if(type_map == 'containsStatus'){
                    if(value == 'true'){
                        swObj.isKey=true;
                    }else if(value == 'false'){
                        swObj.isKey=false;
                    }   
                }else if(type_map == 'statusWithTimestamp'){
                    swObj.statusWithTimestampValue=value;
                }
            }else{
                statusWrapper swObj=new statusWrapper();
                if(type_map == 'uniqueStatusMapChanged'){
                    swObj.uniqueStatusMapChangedValue=value;
                }else if(type_map == 'containsStatus'){
                    if(value == 'true'){
                        swObj.isKey=true;
                    }else if(value == 'false'){
                        swObj.isKey=false;
                    }   
                }else if(type_map == 'statusWithTimestamp'){
                    swObj.statusWithTimestampValue=value;
                }
                statusWrapperMap.put(key,swObj);    
            }
        }
    }   
}