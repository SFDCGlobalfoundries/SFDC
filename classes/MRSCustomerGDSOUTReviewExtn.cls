/*
Type Name: MRSCustomerGDSOUTReviewExtn
Author: Cognizant 
Created Date: 17-April-2014


Change History: #1
Author: Saurav Mukherjee

Modified Date: 07/08/2014
Reason: Task-1732

Change History: #2
Author: Saurav Mukherjee

Modified Date: 13/08/2014
Reason: Task-1768



……..
……..
*/

public without sharing class MRSCustomerGDSOUTReviewExtn {


    private List<Account> customerList ;  
    //public List<SelectOption> customerListTodisplay {get;set;}
    //public List<SelectOption> maskSetTitleToDisplay {get;set;}
    public transient List<MRS_Layer_Chip_Association__c> mrsLayerChipList ;
    public List<SelectOption> maskLayerList {get;set;}
    public List<SelectOption> layerStatusList {get;set;}
    public List<SelectOption> chipNameList {get;set;}
    public List<SelectOption> deviceIdList {get;set;}
    public List<SelectOption> ptrfList {get;set;}
    
    public List<OtherWrapperDisplayTable> otherdisplayTableList {get;set;}
    public List<WrapperChip> lstMainTableData;
    private List<WrapperLayerPtrf> lstsideTableData;
    private List<WrapperStatusCheck> lstgridData;
    public List<WrapperChip> lstChip {get; set;}
    public List<WrapperLayerPtrf> lstLayer {get; set;}
    public List<String> chipNameSet {get;set;} //Date: 07/08/2014 Reason: Task-1732
        
    private Set<Id> mstIdSet ;
    
    private Set<String> layerStatusSet;
    private Set<String> chipName;
    

    private Set<String> layerPtrfSet;
    private Set<String> maskLayerSet;
    private Set<String> ptrfName;
    private Set<String> setLoggedInUserGroups;
    public Set<String> deviceIdSet {get;set;}
    
    public Integer chipNameSize {get;set;}
    private Integer countOfRows;
    private Integer maxSizeLimit;
    
    private Map<Id,String> maskLayerMap;
    private Map<Id,String> chipNameMap;
    private Map<Id,String> ptrfMap;
    public Map<String,String> maskSetTitleMap {get;set;}
    
    public  Map<String,String> uniqueStatusMapChanged {get;set;}
    public Map<String,Boolean> chipWithCheckboxMap {get;set;}
    public Map<String,Boolean> layerPtrfCheckbox {get;set;}
    public Map<String,WrapperStatusCheck> mapForApprove {get;set;}
    public Map<String,String> statusWithTimestamp {get;set;}
    
    public Map<String,Boolean> containsStatus {get;set;}
    public Map<String,Id> ptrfNameIdMap {get;set;}
    private Map<String,String> mapStrCompareToIds;
    
    public Id selectedCustomerId {get;set;}
    public Id selectedMSTId {get;set;}

    public String selectedChipId {get;set;}
    public String selectedLayerId {get;set;}
    public String selectedPTRFId {get;set;}
    public String selectedLayerStatus {get;set;}
    public String selectedDeviceId {get;set;}
    public String type {get; set;}
    public String customerName {get;set;}
    public String mstAfterSave {get;set;}
    public String customerNameAfterSave {get;set;}
    public String mainTableJSON{get;set;}
    public String sideHeaderJSON{get;set;}
    public String gridTblJSON{get;set;}
    public String lookupCustomerURL {get;set;}
    public String lookupMSTURL {get;set;}
    
    public Boolean isTableActive {get;set;}
    public Boolean isPerformActive {get;set;}
    public Boolean isFiltersActive {get;set;}
    public Boolean isTechGeoActive {get;set;}
    public Integer sizeOfTable {get ;set;}
    public Boolean isSelectionTableTrue {get;set;}
    public Boolean isConfirmApproved {get;set;}
    public Boolean customerOrFoundry {get ;set;}
    public Boolean isCustomerListActive {get;set;}
    public Boolean isBreadcrumbActive {get;set;}
    public Boolean noRecords {get;set;}
    public Boolean imageActive {get;set;}
    public Boolean labelorDropdown {get;set;}
    public Boolean isSizeExceeded {get;set;}
    
    public Boolean isJobViewer {get;set;}
    private Boolean isUserGlobalShuttle=false;
    private Boolean isUserTDTIMPW=false;
    private Boolean isUserMDP=false;
    private Boolean isUserTapeoutCenter=false;
    private Boolean isAnyStatusisReady=false;
    private Boolean isGroupOrJobViewer = false;
    private Boolean isRecordLocked = false;
    private Boolean isAccountTeamProxy = false;     //Date: 13/08/2014 Reason : Task - 1768
    private Boolean isUserAdmin = false;    //Date: 13/08/2014 Reason : Task - 1768
    public transient Map<String,MRS_Layer_Chip_Association__c> layerChipMap = new Map<String,MRS_Layer_Chip_Association__c>();
    public transient Map<String,List<MRS_Layer_Chip_Association__c>> layerPtrfMap = new Map<String,List<MRS_Layer_Chip_Association__c>>();
    public transient Map<String,List<MRS_Layer_Chip_Association__c>> chipMap = new Map<String,List<MRS_Layer_Chip_Association__c>>();
    private Map<Id,Boolean> isGroupUserJobViewer  = new Map<Id,Boolean>();
    
    public MRSCustomerGDSOUTReviewExtn(ApexPages.StandardController controller) {
        /*-------------------Fetching the Host Url------------------------*/
        String url = ApexPages.currentPage().getHeaders().get('Host');
        if(url.contains(Label.Swift_Host_URL)){
            isBreadcrumbActive = true;
            lookupCustomerURL = Label.Swift_VFExternal_URL+'VFCustomerLookupDialog';
            lookupMSTURL = Label.Swift_VFExternal_URL+'VFMaskSetTitleLookupDialog';
        }
        else {
            isBreadcrumbActive = false;
            lookupCustomerURL = Label.Swift_VFInternal_URL+'VFCustomerLookupDialog';
            lookupMSTURL = Label.Swift_VFInternal_URL+'VFMaskSetTitleLookupDialog';
        }
        
        /*-------------------Fetching the type(Customer or Foundry)------------------------*/
        type = ApexPages.currentPage().getParameters().get('type');
        if(type =='Customer')
        {
            customerOrFoundry =true;
        }
        else if(type =='Foundry')
        {
            customerOrFoundry =false;
        }
        
        mrsLayerChipList = new List<MRS_Layer_Chip_Association__c>();
        maskLayerMap = new Map<Id,String>();
        layerStatusSet = new Set<String>();
        chipNameMap = new Map<Id,String>();
        deviceIdSet = new Set<String>();
        ptrfMap = new Map<Id,String>();
        maskSetTitleMap = new Map<String,String>();
        maskLayerList = new List<SelectOption>();
        layerStatusList = new List<SelectOption>();
        chipNameList = new List<SelectOption>();
        deviceIdList = new List<SelectOption>();
        ptrfList = new List<SelectOption>();
        //maskSetTitleToDisplay = new List<SelectOption>();
        //customerListTodisplay = new List<SelectOption>();
        
        uniqueStatusMapChanged = new Map<String,String>();
        chipName = new Set<String>();
        chipNameSet = new List<String>();  //Date: 07/08/2014 Reason: Task-1732

        layerPtrfSet = new Set<String>();
        chipWithCheckboxMap = new Map<String,Boolean>();
        layerPtrfCheckbox = new Map<String,Boolean>();
        mapForApprove  =new Map<String,WrapperStatusCheck>();
        statusWithTimestamp = new Map<String,String>();
        
        containsStatus = new Map<String,Boolean>();
        maskLayerSet = new Set<String>();
        ptrfName = new Set<String>();
        
        mapStrCompareToIds = new Map<String,String>();
        
        sizeOfTable = 0;
        if(Environment_Variable__c.getInstance('MRS_GDSOUT_RECORD_SIZE_LIMIT').Value__c == '0' || Environment_Variable__c.getInstance('MRS_GDSOUT_RECORD_SIZE_LIMIT').Value__c == ''){
            maxSizeLimit = 1000;
        }
        else {
            maxSizeLimit = Integer.valueOf(Environment_Variable__c.getInstance('MRS_GDSOUT_RECORD_SIZE_LIMIT').Value__c);
        }
        
        isTableActive = false;
        isPerformActive = false;
        isFiltersActive = true;
        isTechGeoActive = false;
        isSelectionTableTrue  =true;
        isConfirmApproved = false;
        noRecords = false;  
        imageActive = true;
        labelorDropdown = true;
                
        /*Checking if user is in any public group*/
         set<String> setLoggedInUserGroups = new set<String>();          
         setLoggedInUserGroups.addAll(MRSHandlerUtility.fetchCurrentUserGroup(UserInfo.getUserId()));   
         if(setLoggedInUserGroups.size()>0){
               for(String userGroup:setLoggedInUserGroups){
                   if(userGroup.equalsIgnoreCase('Swift_GlobalShuttle')||userGroup.equalsIgnoreCase('Swift_TDTI_MPW')
                           ||userGroup.equalsIgnoreCase('Swift_MDP')||userGroup.equalsIgnoreCase('Swift_Tapeout_Centre')
                           ||userGroup.equalsIgnoreCase('Swift_Tapeout_Application')||userGroup.equalsIgnoreCase('Swift_Tapeout_Operations')
                           ||userGroup.equalsIgnoreCase('SWIFT_Admin')||userGroup.equalsIgnoreCase('Swift_RMG')
                           ||userGroup.equalsIgnoreCase('SWIFT_Support')){
                                       
                       if(Environment_Variable__c.getInstance('MPW_Tech_Geo_GT_20').Value__c.containsIgnoreCase(userGroup)){
                           isUserGlobalShuttle=true;   
                       }                       
                       if(Environment_Variable__c.getInstance('MPW_Tech_Geo_LT_20').Value__c.containsIgnoreCase(userGroup)){
                           isUserTDTIMPW=true; 
                       }
                       if(Environment_Variable__c.getInstance('TECH_GEO_LT_20').Value__c.containsIgnoreCase(userGroup)){
                           isUserMDP=true; 
                       }
                       if(Environment_Variable__c.getInstance('ALL_VIEW_NO_APPROVAL').Value__c.containsIgnoreCase(userGroup)){
                           isUserTapeoutCenter=true; 
                       }
                       if(Environment_Variable__c.getInstance('ALL_VIEW_ALL_APPROVAL').Value__c.containsIgnoreCase(userGroup)){   //Date: 13/08/2014 Reason : Task - 1768
                           isUserAdmin = true;                                                                                    //Date: 13/08/2014 Reason : Task - 1768
                       }
                   }   
               }
           }  
           
           if(isUserGlobalShuttle || isUserTDTIMPW || isUserMDP || isUserTapeoutCenter){
                 isJobViewer= false;
                 isGroupOrJobViewer = false;
           }else{
                 isJobViewer = true;
                 isGroupOrJobViewer = true;
           }

        
        /*-------------------Fetching the Cusomer List------------------------*/
        customerList = MRSHandlerUtility.fetchCustomerName();
        
        if(customerList != null){
           if(customerList.size() > 0){
            if(ApexPages.currentPage().getCookies().get('account') ==  null  &&  ApexPages.currentPage().getCookies().get('mst') ==  null){
                if(customerList.size() == 1){
                    selectedCustomerId = customerList.get(0).Id;
                    customerName = customerList.get(0).Name+' ('+customerList.get(0).Short_Name__c+')';
                    isCustomerListActive = false;
                    labelorDropdown = true;
                    lookupMSTURL = lookupMSTURL + '?aid=' + selectedCustomerId + '&pg=' + type + 'GDSOutReview&jv=' + isJobViewer; 
                    fetchMRSForCustomer();
                    
                }
                else {
                    //customerListTodisplay.add(new SelectOption('',''));
                    isCustomerListActive = true;
                    labelorDropdown = true;
                    /*
                    for(Account accObj : customerList){
                        customerListTodisplay.add(new SelectOption(accObj.Id,accObj.Name+' ('+accObj.Short_Name__c+')'));
                    }
                    */
                }
            }
            else {
                if(String.valueOf(ApexPages.currentPage().getCookies().get('account').getValue()) != ''){
                    selectedCustomerId = String.valueOf(ApexPages.currentPage().getCookies().get('account').getValue());
                    lookupMSTURL = lookupMSTURL + '?aid=' + selectedCustomerId + '&pg=' + type + 'GDSOutReview&jv=' + isJobViewer;
                    fetchMRSForCustomer();
                }
                if(ApexPages.currentPage().getCookies().get('mst') == null){
                    isTableActive = false;
                }
                if(customerList.size()>1)
                {
                    for(Account acc : customerList)
                    {
                        //customerListTodisplay.add(new SelectOption(acc.Id,acc.Name+' ('+acc.Short_Name__c+')'));
                        if(acc.Id == selectedCustomerId){
                            customerNameAfterSave = acc.Name+' ('+acc.Short_Name__c+')';
                            customerName = acc.Name+' ('+acc.Short_Name__c+')';
                        }
                    }
                    
                    isCustomerListActive = true;
                    labelorDropdown = true;
                }
                else{
                    customerNameAfterSave = customerList.get(0).Name+' ('+customerList.get(0).Short_Name__c+')';
                    customerName = customerList.get(0).Name+' ('+customerList.get(0).Short_Name__c+')';
                    isCustomerListActive = false;
                    labelorDropdown = true; 
                }
                if(ApexPages.currentPage().getCookies().get('mst')!=null && String.valueOf(ApexPages.currentPage().getCookies().get('mst').getValue())!=''){
                    selectedMSTId = String.valueOf(ApexPages.currentPage().getCookies().get('mst').getValue());
                    /*
                    for(SelectOption mstOption : maskSetTitleToDisplay){
                        if(mstOption.getValue() != ''){
                            if(mstOption.getValue() == selectedMSTId){
                                mstAfterSave = mstOption.getLabel();
                            }
                        }
                    }
                    */
                    //lookupMSTURL = lookupMSTURL + '?aid=' + selectedCustomerId + '&pg=' + type + 'GDSOutReview&jv=' + isJobViewer;
                    if(maskSetTitleMap.containsKey(selectedMSTId)){
                        mstAfterSave = maskSetTitleMap.get(selectedMSTId);
                    }
                    
                    isFiltersActive = false;
                    maskLayerSet.clear();
                    layerStatusSet.clear();
                    chipName.clear();
                    deviceIdSet.clear();
                    ptrfName.clear();
                    maskLayerList.clear();
                    layerStatusList.clear();
                    chipNameList.clear();
                    deviceIdList.clear();
                    ptrfList.clear();
                    if(mstAfterSave != null){
                        isTableActive = true;
                        fetchMRSLayerChipAssociationDetails();
                    }
                    else {
                        noRecords = true;
                        isTableActive = false;
                    }

                }
            }
          }
        }
        
        
        
    }

    /**
        @Method:fetchMRSForCustomer
        @param: null
        @return: void
        @Description : This method will fetch the records for the customer selected
    **/    
    public void fetchMRSForCustomer() {   
        
        
        
        isTableActive = false;
        isPerformActive = false;

        selectedMSTId=null; selectedLayerId = null; selectedLayerStatus=''; selectedChipId=null; selectedDeviceId=''; selectedPTRFId=null;
        maskSetTitleMap.clear();
        maskLayerSet.clear();
        layerStatusSet.clear();
        chipName.clear();
        deviceIdSet.clear();
        ptrfName.clear();
        //maskSetTitleToDisplay.clear();
        maskLayerList.clear();
        layerStatusList.clear();
        chipNameList.clear();
        deviceIdList.clear();
        ptrfList.clear();
        /*
        for(SelectOption accObj : customerListTodisplay){
            if(accObj.getValue() != ''){
                if(accObj.getValue() == selectedCustomerId){

                    customerName= accObj.getLabel();
                    customerNameAfterSave = accObj.getLabel();
                }
            }
        }
        */
        for(Account acc : customerList)
        {
            if(acc.Id == selectedCustomerId){
                customerNameAfterSave = acc.Name+' ('+acc.Short_Name__c+')';
                customerName = acc.Name+' ('+acc.Short_Name__c+')';
            }
        }
         //------------------Code Added for remember customer name---------------------------//
         ClsMyDevices.account = new Cookie('account',selectedCustomerId,null,-1,false);
         ApexPages.currentPage().setCookies(new Cookie[]{ClsMyDevices.account});
        
        
        if(type == 'Customer')
            maskSetTitleMap = MRSHandlerUtility.fetchMaskSetTitleList(selectedCustomerId,'CustomerGDSOutReview',isJobViewer);  
        else
            maskSetTitleMap = MRSHandlerUtility.fetchMaskSetTitleList(selectedCustomerId,'FoundryGDSOutReview',isJobViewer);
        /*  
        if(maskSetTitleMap != null){
            maskSetTitleToDisplay.add(new SelectOption('',''));
            for(Id maskSetTitleId : maskSetTitleMap.keySet()){
                if(maskSetTitleId != null){
                    maskSetTitleToDisplay.add(new SelectOption(maskSetTitleId,maskSetTitleMap.get(maskSetTitleId)));
                }
            } 
        } 
        */
                 
    }
    
    /**
        @Method: fetchMRSForMaskSetTitle
        @param: null
        @return: void
        @Description : This method will fetch the records for the mask set title selected
    **/ 
    public void fetchMRSForMaskSetTitle() {
       
        if(selectedCustomerId != null && selectedMSTId != null && String.valueOf(selectedCustomerId) != '' && String.valueOf(selectedMSTId) != ''){
            if(selectedMSTId != null){
                isTableActive = true;
                
            }
            else {
                isTableActive = false;
                
            }
             //----------------------Code added for remmember MST--------------------------------//
             ClsMyDevices.mst = new Cookie('mst',selectedMSTId,null,-1,false);
             ApexPages.currentPage().setCookies(new Cookie[]{ClsMyDevices.mst});
            
            isFiltersActive = false;
            selectedLayerId = null; selectedLayerStatus=''; selectedChipId=null; selectedDeviceId=''; selectedPTRFId=null;
            
            maskLayerSet.clear();
            layerStatusSet.clear();
            chipName.clear();
            deviceIdSet.clear();
            ptrfName.clear();
            maskLayerList.clear();
            layerStatusList.clear();
            chipNameList.clear();
            deviceIdList.clear();
            ptrfList.clear();
            fetchMRSLayerChipAssociationDetails();
            
             
        }      
    }
    
    /**
        @Method: resetLSPCookies
        @param: null
        @return: void
        @Description : This method resets the cookies for Layer Summary Page
    **/
    public void resetLSPCookies() {
        if(ApexPages.currentPage().getCookies().get('mst')!=null && String.valueOf(ApexPages.currentPage().getCookies().get('mst').getValue())!=''){
            ClsMyDevices.mst = new Cookie('mst',null,null,-1,false);
            ApexPages.currentPage().setCookies(new Cookie[]{ClsMyDevices.mst});
        }
        
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
    
    public void fetchMRSForMaskLayer() {
        selectedLayerStatus=''; selectedChipId=null; selectedDeviceId=''; selectedPTRFId=null;
        layerStatusSet.clear();
        chipNameMap.clear();
        deviceIdSet.clear();
        ptrfMap.clear();
        layerStatusList.clear();
        chipNameList.clear();
        deviceIdList.clear();
        ptrfList.clear();
        
    }
    public void fetchMRSForStatus() {
        selectedChipId=null; selectedDeviceId=''; selectedPTRFId=null;
        chipNameMap.clear();
        deviceIdSet.clear();
        ptrfMap.clear();
        chipNameList.clear();
        deviceIdList.clear();
        ptrfList.clear();
        
    }
    public void fetchMRSForChipName() {
        selectedDeviceId=''; selectedPTRFId=null;
        deviceIdSet.clear();
        ptrfMap.clear();
        deviceIdList.clear();
        ptrfList.clear();
        
    }
    public void fetchMRSForPtrf() {
        selectedPTRFId=null;
        ptrfMap.clear();
        ptrfList.clear();
        
    }
    
    /**
        @Method: fetchMRSLayerChipAssociationDetails
        @param: null
        @return: void
        @Description : This method fetches the records and populates the filters
    **/
    public void fetchMRSLayerChipAssociationDetails() {
        
        isPerformActive = false;
        isTechGeoActive = false;

        List<MRS_Layer_Chip_Association__c> layerIterator;
        if(mrsLayerChipList == null){
            mrsLayerChipList = new List<MRS_Layer_Chip_Association__c>();
        }
        
        chipName.clear();
        layerPtrfSet.clear();
        chipNameSet.clear();
        
        if(layerChipMap==null){
            layerChipMap = new Map<String,MRS_Layer_Chip_Association__c>();
        }
        if(layerPtrfMap==null){
            layerPtrfMap = new Map<String,List<MRS_Layer_Chip_Association__c>>();
        }
        if(chipMap==null){
            chipMap = new Map<String,List<MRS_Layer_Chip_Association__c>>();
        }
        
        
        if(type =='Customer'){
            mrsLayerChipList = MRSHandlerUtility.getMrsChipLayerSummary(selectedCustomerId,selectedMSTId,selectedLayerId,selectedLayerStatus,selectedDeviceId,null,selectedChipId,selectedPTRFId,'CustomerGDSOutReview',isJobViewer);
        }
        else {
            mrsLayerChipList = MRSHandlerUtility.getMrsChipLayerSummary(selectedCustomerId,selectedMSTId,selectedLayerId,selectedLayerStatus,selectedDeviceId,null,selectedChipId,selectedPTRFId,'FoundryGDSOutReview',isJobViewer);
        }
        
        
        /*----Date: 13/08/2014 Reason : Task - 1768-------*/
        Set<String> teamRole = new Set<String>{'Primary Field Technical Support','Primary Field Application Engineer','Field Technical Support','Field Application Engineer'};
        List<Account_Team_Proxy__c> accTeamProxy;
        if(selectedCustomerId != null){
           accTeamProxy = [SELECT Id,Account__c,User__c,Team_Role__c 
							FROM Account_Team_Proxy__c 
							WHERE User__c = :UserInfo.getUserId()  
								AND   Account__c = :selectedCustomerId 
								AND (	Team_Role__c IN:teamRole
									OR (Team_Role__c = 'Account Manager' AND Is_FAE__c = TRUE)
                                    OR (Team_Role__c = 'Primary Account Manager' AND Is_FAE__c = TRUE) )];
        }
        
        if(accTeamProxy != null && accTeamProxy.size() > 0 &&  type =='Customer'){
            isAccountTeamProxy = true;
        }
        if(isUserAdmin){
            isAccountTeamProxy = true;
        }
        /*----------------------------------------------*/
        
        if(mrsLayerChipList.size() == 0 && (selectedMSTId == null || selectedMSTId != null))
        {
            noRecords = true;
            isTableActive = false;
        }
        else if(mrsLayerChipList.size() > 0 && selectedMSTId == null){
            noRecords = false;
            isTableActive = false;
        }
        else if(mrsLayerChipList.size() > 0 && selectedMSTId != null){
            noRecords = false;
            isTableActive = true;
        }
        
        isGroupUserJobViewer.clear();
        if(mrsLayerChipList != null && mrsLayerChipList.size() > 0){
            for(MRS_Layer_Chip_Association__c mrsLayerChipObj : mrsLayerChipList){
                /*-------------------Performance Fix--------------------------*/
                String strObj;
                if(mrsLayerChipObj.ROM_Code__c != null && mrsLayerChipObj.ROM_Code__c != '####' && mrsLayerChipObj.ROM_Code__c != 'null' && mrsLayerChipObj.ROM_Code__c != 'NULL'){
                     strObj = mrsLayerChipObj.Layer__r.Name+mrsLayerChipObj.Layer__r.Mask_Layer_Rev__c+'('+mrsLayerChipObj.ROM_Code__c+'):'+mrsLayerChipObj.PTRF__r.Name+':'+mrsLayerChipObj.Chip__r.Name;
                }    
                else {
                     strObj = mrsLayerChipObj.Layer__r.Name+mrsLayerChipObj.Layer__r.Mask_Layer_Rev__c+':'+mrsLayerChipObj.PTRF__r.Name+':'+mrsLayerChipObj.Chip__r.Name;
                }
                mapStrCompareToIds.put(strObj,mrsLayerChipObj.Id);
                /*--------------------------------------------------*/
                if(type =='Customer'){
                    if(mrsLayerChipObj.Customer_GDSOUT_Review__c == 'Ready'){
                        isGroupUserJobViewer.put(mrsLayerChipObj.PTRF__c,true);
                    }
                }
                else {
                    if(mrsLayerChipObj.Foundry_GDSOUT_Review__c == 'Ready'){
                        isGroupUserJobViewer.put(mrsLayerChipObj.PTRF__c,true);
                    }
                }
                
                maskLayerSet.add(mrsLayerChipObj.Layer__r.Name);
                if(mrsLayerChipObj.Layer__r.Layer_Status__c != null)
                  layerStatusSet.add(mrsLayerChipObj.Layer__r.Layer_Status__c);
                
                chipName.add(mrsLayerChipObj.Chip__r.Name);
                
                deviceIdSet.add(mrsLayerChipObj.PTRF__r.Device_Id__c);
                
                ptrfName.add(mrsLayerChipObj.PTRF__r.Name);
                
                if(mrsLayerChipList.size() <= maxSizeLimit){ // Task - 1864
                    
                    if(selectedMSTId != null){
                        if(type =='Customer'){
                            if(mrsLayerChipObj.Customer_GDSOUT_Review__c == 'Ready'){
                                isPerformActive = true;
                            }
                        }
                        else {
                            if(mrsLayerChipObj.Foundry_GDSOUT_Review__c == 'Ready'){
                                isPerformActive = true;
                            }
                        }
                        
                        if(mrsLayerChipObj.PTRF__r.Recticle_Type__c == 'Multi Node Reticle (MNR)'){
                            isTechGeoActive = true;
                        }
                        /*-----------------------------------------------------*/
                        layerPtrfSet.add(mrsLayerChipObj.Layer__r.Name+mrsLayerChipObj.Layer__r.Mask_Layer_Rev__c+'('+mrsLayerChipObj.ROM_Code__c+'):'+mrsLayerChipObj.PTRF__r.Name);
                   
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
                    }
                } // Task - 1864
                /*-----------------------------------------------------*/
            }
            if(selectedMSTId != null && mrsLayerChipList.size() <= maxSizeLimit){        //Date: 07/08/2014 Reason: Task-1732
                chipNameSet.addAll(chipName);  //Date: 07/08/2014 Reason: Task-1732
                chipNameSet.sort();  //Date: 07/08/2014 Reason: Task-1732
            }
            
            chipNameSize = chipNameSet.size();
            
            /*
            for(SelectOption mstOption : maskSetTitleToDisplay){
                if(mstOption.getValue() != ''){
                    if(mstOption.getValue() == selectedMSTId){
                        mstAfterSave = mstOption.getLabel();
                    }
                }
            }
            */
            if(maskSetTitleMap.containsKey(selectedMSTId)){
                mstAfterSave = maskSetTitleMap.get(selectedMSTId);
            }
            
            maskLayerList.add(new SelectOption('','')); 
            
            for(String maskLayerIdObj : maskLayerSet){
                maskLayerList.add(new SelectOption(maskLayerIdObj,maskLayerIdObj));
            }
            maskLayerList.sort();
            
            if(layerStatusSet.size()>0)
            {
                for(String layerStatusObj : layerStatusSet){
                    layerStatusList.add(new SelectOption(layerStatusObj,layerStatusObj));
                }
            }
            layerStatusList.sort();
            chipNameList.add(new SelectOption('',''));
            for(String chipIdObj : chipName){
                chipNameList.add(new SelectOption(chipIdObj,chipIdObj));
            }
            chipNameList.sort();
            
            deviceIdList.add(new SelectOption('',''));
            for(String deviceIdObj : deviceIdSet){
                if(deviceIdObj != null)
                   
                    deviceIdList.add(new SelectOption(deviceIdObj,deviceIdObj));
            } 
            deviceIdList.sort();
            ptrfList.add(new SelectOption('',''));
            for(String ptrfIdObj : ptrfName){
                ptrfList.add(new SelectOption(ptrfIdObj,ptrfIdObj));
            }
            ptrfList.sort();
            
            if(mrsLayerChipList.size() <= maxSizeLimit){  //Task - 1864
                
                isAnyStatusisReady = false;
                if(!isJobViewer){
                    
                    List<PTRF_JobViewer_Info__c> ptrfJobViewInfo = MRSHandlerUtility.getJobViewer(isGroupUserJobViewer.keySet(),type);
                    if(ptrfJobViewInfo != null && ptrfJobViewInfo.size() > 0){
                        for(PTRF_JobViewer_Info__c ptrfJobViewObject : ptrfJobViewInfo){
                            if(isGroupUserJobViewer.get(ptrfJobViewObject.PTRF__c)){
                                isAnyStatusisReady =true ;
                                break;
                            }
                        }
                    }
                }
                else{
                    isAnyStatusisReady = true;
                }
                /*----Date: 13/08/2014 Reason : Task - 1768-------*/
                if(isAccountTeamProxy){
                    isAnyStatusisReady = true;
                }
                /*-----------------------------------------------*/
                
               
                if(selectedMSTId != null && isPerformActive){
                    isPerformActive = true;
                }
                else if(selectedMSTId == null && isPerformActive){
                    isPerformActive = false;
                }
                else {
                    isPerformActive = false;
                }
               
                
                if(isAnyStatusisReady && isPerformActive){
                    isPerformActive = true;
                }
                else {
                    isPerformActive = false;
                }
                
                if(selectedMSTId != null && mrsLayerChipList.size() <= maxSizeLimit){ //Task - 1864
                    displayTable();
                }
            } //Task - 1864
            
            if(mrsLayerChipList.size() > maxSizeLimit){   //Task - 1864
                isSizeExceeded = true;  
                noRecords = false;
                isTableActive = false;
                isPerformActive = false;
                isTechGeoActive = false;                  //Task - 1864
            }
            else {                                        //Task - 1864 
                isSizeExceeded = false;  
                                 //Task - 1864
            }
        }
    }
    
    /**
        @Method: displayTable
        @param: null
        @return: void
        @Description : This method displays the the fetched data in a tabular form
    **/
    public void displayTable() {
        uniqueStatusMapChanged.clear();
        
        chipWithCheckboxMap.clear();
        layerPtrfCheckbox.clear();
        
        statusWithTimestamp.clear();
        
        Integer counter = 1;
        
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
                       
                        if(type =='Customer'){
                            uniqueStatusMapChanged.put(strObj.substringBeforeLast('(')+':'+chipObj+':'+strObj.substringAfterLast(':'),layerChipObj.Customer_GDSOUT_Review__c);
                        }
                        else {
                            uniqueStatusMapChanged.put(strObj.substringBeforeLast('(')+':'+chipObj+':'+strObj.substringAfterLast(':'),layerChipObj.Foundry_GDSOUT_Review__c);
                        }
                        containsStatus.put(strObj.substringBeforeLast('(')+':'+chipObj+':'+strObj.substringAfterLast(':'),true);
                        
                    }
                    else {
                            
                        if(type =='Customer'){
                            uniqueStatusMapChanged.put(strObj.substringBeforeLast(':')+':'+chipObj+':'+strObj.substringAfterLast(':'),layerChipObj.Customer_GDSOUT_Review__c);
                        }
                        else {
                            uniqueStatusMapChanged.put(strObj.substringBeforeLast(':')+':'+chipObj+':'+strObj.substringAfterLast(':'),layerChipObj.Foundry_GDSOUT_Review__c);
                        }
                        containsStatus.put(strObj.substringBeforeLast(':')+':'+chipObj+':'+strObj.substringAfterLast(':'),true);
                    }
                    
                    if(!strObj.contains('####') && !strObj.contains('null') && !strObj.contains('NULL')){
                        if(type =='Customer'){
                            if(layerChipObj.Customer_GDSOUT_Review_Date__c != null)
                                statusWithTimestamp.put(strObj.substringBeforeLast(':')+':'+chipObj+':'+strObj.substringAfterLast(':'),layerChipObj.Customer_GDSOUT_Review_Date__c.format());
                            else
                                statusWithTimestamp.put(strObj.substringBeforeLast(':')+':'+chipObj+':'+strObj.substringAfterLast(':'),'');    
                            }
                        else {
                           
                            if(layerChipObj.Foundry_GDSOUT_Review_Date__c != null)
                                statusWithTimestamp.put(strObj.substringBeforeLast(':')+':'+chipObj+':'+strObj.substringAfterLast(':'),layerChipObj.Foundry_GDSOUT_Review_Date__c.format());
                            else
                                statusWithTimestamp.put(strObj.substringBeforeLast(':')+':'+chipObj+':'+strObj.substringAfterLast(':'),'');
                        }
                    }
                    else if(strObj.contains('####') || strObj.contains('null') || strObj.contains('NULL')){
                        if(type =='Customer'){
                            if(layerChipObj.Customer_GDSOUT_Review_Date__c != null)
                                statusWithTimestamp.put(strObj.substringBefore('(')+':'+chipObj+':'+strObj.substringAfterLast(':'),layerChipObj.Customer_GDSOUT_Review_Date__c.format());
                            else
                                statusWithTimestamp.put(strObj.substringBefore('(')+':'+chipObj+':'+strObj.substringAfterLast(':'),'');    
                            }
                        else {
                            
                            if(layerChipObj.Foundry_GDSOUT_Review_Date__c != null)
                                statusWithTimestamp.put(strObj.substringBefore('(')+':'+chipObj+':'+strObj.substringAfterLast(':'),layerChipObj.Foundry_GDSOUT_Review_Date__c.format());
                            else
                                statusWithTimestamp.put(strObj.substringBefore('(')+':'+chipObj+':'+strObj.substringAfterLast(':'),'');
                        }
                    }
                }
                else if(!flgForUniqueStatus) {
                    
                    if(strObj.contains('####') || strObj.contains('null') || strObj.contains('NULL')){
                        
                        if(type =='Customer'){
                            uniqueStatusMapChanged.put(strObj.substringBeforeLast('(')+':'+chipObj+':'+strObj.substringAfterLast(':'),'');
                        }
                        else {
                            uniqueStatusMapChanged.put(strObj.substringBeforeLast('(')+':'+chipObj+':'+strObj.substringAfterLast(':'),'');
                        }
                        containsStatus.put(strObj.substringBeforeLast('(')+':'+chipObj+':'+strObj.substringAfterLast(':'),false);
                    }
                    else {
                        
                        if(type =='Customer'){
                            uniqueStatusMapChanged.put(strObj.substringBeforeLast(':')+':'+chipObj+':'+strObj.substringAfterLast(':'),'');
                        }
                        else {
                            uniqueStatusMapChanged.put(strObj.substringBeforeLast(':')+':'+chipObj+':'+strObj.substringAfterLast(':'),'');
                        }
                        containsStatus.put(strObj.substringBeforeLast(':')+':'+chipObj+':'+strObj.substringAfterLast(':'),false);
                    }

                    if(!strObj.contains('####') && !strObj.contains('null') && !strObj.contains('NULL')){
                        layerChipObj.Customer_GDSOUT_Review__c = '';
                        layerChipObj.Foundry_GDSOUT_Review__c = '';
                        
                        statusWithTimestamp.put(strObj.substringBeforeLast(':')+':'+chipObj+':'+strObj.substringAfterLast(':'),'');
                    }
                    else if(strObj.contains('####') || strObj.contains('null') || strObj.contains('NULL')){
                        layerChipObj.Customer_GDSOUT_Review__c = '';
                        layerChipObj.Foundry_GDSOUT_Review__c = '';
                        
                        statusWithTimestamp.put(strObj.substringBefore('(')+':'+chipObj+':'+strObj.substringAfterLast(':'),'');
                    }
                }
            }
        }
        
        otherdisplayTableList = new List<OtherWrapperDisplayTable>();
        OtherWrapperDisplayTable otherwrapperDsplTableObj;
        
        Boolean flag = true;
        for(String strObj : layerPtrfSet){
            
          MRS_Layer_Chip_Association__c mrsLayerChipObj = layerPtrfMap.get(strObj).get(0); 
          otherwrapperDsplTableObj = new OtherWrapperDisplayTable();
            
                if(flag){
                   
                    if(strObj.substringBeforeLast(':').contains('####') || strObj.substringBeforeLast(':').contains('null') || strObj.substringBeforeLast(':').contains('NULL')){
                        otherwrapperDsplTableObj.slNo = counter;
                        otherwrapperDsplTableObj.maskLayerROMCode = strObj.substringBeforeLast(':').substringBefore('(');
                        otherwrapperDsplTableObj.ptrf = strObj.substringAfterLast(':');
                        otherwrapperDsplTableObj.ptrfId = mrsLayerChipObj.PTRF__c;
                        otherwrapperDsplTableObj.isColor = flag;
                        otherwrapperDsplTableObj.TechGeo = mrsLayerChipObj.PTRF__r.Tech_Geo__c;
                        otherwrapperDsplTableObj.key = strObj.substringBeforeLast(':');
                    }
                    else {
                        otherwrapperDsplTableObj.slNo = counter;
                        otherwrapperDsplTableObj.maskLayerROMCode = strObj.substringBeforeLast(':');
                        otherwrapperDsplTableObj.ptrf = strObj.substringAfterLast(':');
                        otherwrapperDsplTableObj.ptrfId = mrsLayerChipObj.PTRF__c;
                        otherwrapperDsplTableObj.isColor = flag;
                        otherwrapperDsplTableObj.TechGeo = mrsLayerChipObj.PTRF__r.Tech_Geo__c;
                        otherwrapperDsplTableObj.key = strObj.substringBeforeLast(':');
                    }
                    flag = false;
                }
                else {
                    
                    if(strObj.substringBeforeLast(':').contains('####') || strObj.substringBeforeLast(':').contains('null') || strObj.substringBeforeLast(':').contains('NULL')){
                        otherwrapperDsplTableObj.slNo = counter;
                        otherwrapperDsplTableObj.maskLayerROMCode = strObj.substringBeforeLast(':').substringBefore('(');
                        otherwrapperDsplTableObj.ptrf = strObj.substringAfterLast(':');
                        otherwrapperDsplTableObj.ptrfId = mrsLayerChipObj.PTRF__c;
                        otherwrapperDsplTableObj.isColor = flag;
                        otherwrapperDsplTableObj.TechGeo = mrsLayerChipObj.PTRF__r.Tech_Geo__c;
                        otherwrapperDsplTableObj.key = strObj.substringBeforeLast(':');
                    }
                    else {
                        otherwrapperDsplTableObj.slNo = counter;
                        otherwrapperDsplTableObj.maskLayerROMCode = strObj.substringBeforeLast(':');
                        otherwrapperDsplTableObj.ptrf = strObj.substringAfterLast(':');
                        otherwrapperDsplTableObj.ptrfId = mrsLayerChipObj.PTRF__c;
                        otherwrapperDsplTableObj.isColor = flag;
                        otherwrapperDsplTableObj.TechGeo = mrsLayerChipObj.PTRF__r.Tech_Geo__c;
                        otherwrapperDsplTableObj.key = strObj.substringBeforeLast(':');
                    }
                    flag = true;
                }
                
                otherdisplayTableList.add(otherwrapperDsplTableObj);
                counter = counter + 1;
                    
            
        }
        sizeOfTable  = otherdisplayTableList.size();
        
        countOfRows = counter - 1;
        Boolean flagForChip;
        for(String chipNameObj : chipNameSet){
            flagForChip = false;
            
            if(chipMap.containsKey(chipNameObj)){

                for(MRS_Layer_Chip_Association__c mrsLayerChipObj : chipMap.get(chipNameObj)){
                    

                    if(type =='Customer'){
                        if(mrsLayerChipObj.Customer_GDSOUT_Review__c == 'Ready'){
                            flagForChip = true;
                            break;
                        }

                    }
                    else {


                        if(mrsLayerChipObj.Foundry_GDSOUT_Review__c == 'Ready'){
                            flagForChip = true;
                            break;
                        }

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
            
                
                if(mrsLayerChipObj.PTRF__r.Tech_Geo__c != null){
                    if(type =='Customer'){
                        if(mrsLayerChipObj.Customer_GDSOUT_Review__c == 'Ready' && Double.valueOf(mrsLayerChipObj.PTRF__r.Tech_Geo__c.toUppercase().substringBefore('UM').trim()) < 0.13){
                            flagForChip = true;
                            break;
                        }
                    }
                    else {
                        if(mrsLayerChipObj.Foundry_GDSOUT_Review__c == 'Ready' && Double.valueOf(mrsLayerChipObj.PTRF__r.Tech_Geo__c.toUppercase().substringBefore('UM').trim()) < 0.13){
                            flagForChip = true;
                            break;
                        }
                    }
                }    
                
            }
            if(layerPtrfObj.contains('####') || layerPtrfObj.contains('null') || layerPtrfObj.contains('NULL')){
                if(flagForChip)
                    layerPtrfCheckbox.put(layerPtrfObj.substringBefore('(')+layerPtrfObj.substringAfter(')'),true);
                else
                    layerPtrfCheckbox.put(layerPtrfObj.substringBefore('(')+layerPtrfObj.substringAfter(')'),false);
            }
            else {
                if(flagForChip)
                    layerPtrfCheckbox.put(layerPtrfObj,true);
                else
                    layerPtrfCheckbox.put(layerPtrfObj,false);
            }
        }
        
    }
    
    /**
        @Class: OtherWrapperDisplayTable
        @Description : This is a wrapper class which which will contain the data to be displayed in the table
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
        public String techGeo {get;set;}
        public WrapperLayerPtrf(String slNo,String maskLayer,String ptrf,String techgeo) {
            this.slNo =slNo;
            this.maskLayer = maskLayer;
            this.ptrf = ptrf;
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
    
    /**
        @Method: approvalData
        @param: null
        @return: void
        @Description : This method is used to generate the JSON from the table and fill the datas in the respective wrapper object
    **/
   public void approvalData()
   {
       

       isConfirmApproved = true;
       
       lstMainTableData = (List<WrapperChip>)JSON.deserialize(mainTableJSON,List<WrapperChip>.class);  
       lstsideTableData = (List<WrapperLayerPtrf>)JSON.deserialize(sideHeaderJSON,List<WrapperLayerPtrf>.class);
       lstgridData = (List<WrapperStatusCheck>)JSON.deserialize(gridTblJSON,List<WrapperStatusCheck>.class);   
       
       mapForApprove.clear();
       isPerformActive = false;
       isTableActive = false;
       isSelectionTableTrue = false;
       List<String> layerChipPtrf = new List<String>();
       for(WrapperLayerPtrf layerPtrfObj : lstsideTableData){
           for(WrapperChip wrapperChipObj : lstMainTableData){
               layerChipPtrf.add(layerPtrfObj.maskLayer+':'+layerPtrfObj.ptrf+':'+wrapperChipObj.chip);
           }
           
       }
       
       displayChecked(lstMainTableData,lstsideTableData,lstgridData);
       
   } 
   
   /**
        @Method: displayChecked
        @param: (List,List,List)
        @return: void
        @Description : This method is used to display the chips selected for approval
    **/
   public void displayChecked(List<WrapperChip> lstMainTableData,List<WrapperLayerPtrf> lstsideTableData,List<WrapperStatusCheck> lstgridData){
       
       ptrfNameIdMap = new Map<String,Id>();
       Set<String> ptrfUniqueName = new Set<String>();
       List<PTRF__c> ptrfNameIdList ;
       
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
       Set<String> chipName = new Set<String>();
       Set<String> layerName = new Set<String>();
       
       
       for(Integer position : positionChecked){
           
           for(Integer key : interval.keySet()){
               if(Integer.valueOf(interval.get(key).substringBefore('-'))<= position && position<=Integer.valueOf(interval.get(key).substringAfter('-'))){
                  
                  if(!layerName.contains(lstsideTableData.get(key).maskLayer+'-'+lstsideTableData.get(key).ptrf))
                  {
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
       
       chipPosition.sort();  //Date: 07/08/2014 Reason: Task-1732
       lstChip = sortList(lstChip); //Date: 07/08/2014 Reason: Task-1732
       
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
           ptrfUniqueName.add(layerWrapper.ptrf);
       }
       
       ptrfNameIdList = [SELECT Id,Name FROM PTRF__c WHERE Name IN :ptrfUniqueName];
       for(PTRF__c ptrfObj : ptrfNameIdList){
            ptrfNameIdMap.put(ptrfObj.Name,ptrfObj.Id);
       }
       
       
       Integer pos = 0;
       for(String strObj : layerPtrfChip){
       
           mapForApprove.put(strObj,checkedStatus.get(pos));
           pos = pos +1;
       } 
   }
   
   /**
        @Method: saveData
        @param: null
        @return: void
        @Description : This method is used to save the chips selected for approval
    **/
   public void saveData(){
           
       List<MRS_Layer_Chip_Association__c> mrsList = new List<MRS_Layer_Chip_Association__c>();
       List<MRS_Layer_Chip_Association__c> mrsListToUpdate = new List<MRS_Layer_Chip_Association__c>();
       Map<Id,List<MRS_Layer_Chip_Association__c>> techGeoAndId = new Map<Id,List<MRS_Layer_Chip_Association__c>>();
       List<MRS_Layer_Chip_Association__c> mrsListIterator;
       List<MRS_Layer_Chip_Association__c> lstMRSLCAToUpdate;
       
       isRecordLocked = false;
       
       Map<String,Error_Codes__c> mapErrorCodes = Error_Codes__c.getAll();
       set<String> setLayerChipId = new set<String>();
       
       for(String key: mapForApprove.keySet()){
            if(mapStrCompareToIds.size()>0 && mapStrCompareToIds.containsKey(key)){
                if(mapForApprove.get(key).flagSet == 'CHECKED' && mapForApprove.get(key).status == 'Ready'){
                    setLayerChipId.add(mapStrCompareToIds.get(key));
                }       
            }   
       }
       
       if(setLayerChipId.size()>0){
                try{
                    lstMRSLCAToUpdate = [SELECT Id,
                                            Customer_GDSOUT_Review__c,
                                            Customer_GDSOUT_Review_Date__c,
                                            Foundry_GDSOUT_Review_Date__c,
                                            Foundry_GDSOUT_Review__c,PTRF__c,Name,
                                            ROM_Code__c,Layer__r.Name,Layer__r.Mask_Layer_Rev__c,
                                            Chip__c,Chip__r.Name,PTRF__r.Tech_Geo__c,PTRF__r.MaskSetTitle__r.Name,
                                            PTRF__r.MaskSetTitle__c,PTRF__r.Device__c,PTRF__r.Device__r.Name,
                                            PTRF__r.Device_Id__c,PTRF__r.Name,Layer__c,LastModifiedById,Layer__r.ROM_Code__c,
                                            Layer__r.Layer_Status__c,Device_Id__c,Tech_Geo__c,PTRF__r.Recticle_Type__c
                                        FROM MRS_Layer_Chip_Association__c where Id IN:setLayerChipId  FOR UPDATE];  
                }catch(Exception ex){
                    
                    if(ex.getMessage().containsIgnoreCase(mapErrorCodes.get('DRT_Lock_SFDC_Error').Message__c)) {                       
                        ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,mapErrorCodes.get('MRS_Lock_Error').Message__c);                                              
                        ApexPages.addMessage(myMsg);
                        
                        isRecordLocked = true;               
                    }                           
                }       
       }
       if(!isRecordLocked && lstMRSLCAToUpdate!= null && lstMRSLCAToUpdate.size() > 0){
               
               for(MRS_Layer_Chip_Association__c mrsLayerChipObj : lstMRSLCAToUpdate){
                   if(type =='Customer'){
                       mrsLayerChipObj.Customer_GDSOUT_Review__c = 'Approve';
                       mrsLayerChipObj.Customer_GDSOUT_Review_Date__c = System.now();
                       mrsListToUpdate.add(mrsLayerChipObj);
                       
                       if(mrsLayerChipObj.Foundry_GDSOUT_Review__c == 'Approve' || mrsLayerChipObj.Foundry_GDSOUT_Review__c == 'N.A.' ){
                           mrsList.add(mrsLayerChipObj);
                       }
                   }
                   else {
                       mrsLayerChipObj.Foundry_GDSOUT_Review__c = 'Approve';
                       mrsLayerChipObj.Foundry_GDSOUT_Review_Date__c = System.now();
                       mrsListToUpdate.add(mrsLayerChipObj);
                      
                       if(mrsLayerChipObj.Customer_GDSOUT_Review__c == 'Approve' || mrsLayerChipObj.Customer_GDSOUT_Review__c == 'N.A.' ){
                           mrsList.add(mrsLayerChipObj);
                       }
                   }
               }
           
           if(mrsListToUpdate.size() > 0){
               MRSHandlerUtility.numberOfLayerChipRecords = mrsListToUpdate.size();
               update mrsListToUpdate;
           }
           isConfirmApproved = false;
           imageActive = true;
           labelorDropdown = true;
           
           for(MRS_Layer_Chip_Association__c mrsObj : mrsList){
               if(techGeoAndId.get(mrsObj.PTRF__c) != null){
                   techGeoAndId.get(mrsObj.PTRF__c).add(mrsObj);
               }
               else {
                   mrsListIterator = new List<MRS_Layer_Chip_Association__c>();
                   mrsListIterator.add(mrsObj);
                   techGeoAndId.put(mrsObj.PTRF__c,mrsListIterator);
               }
           }
           
           
           MRSHandlerUtility.sendEmailToReviewers(techGeoAndId,'GDSOUTReview',selectedCustomerId,true,null,'');
           isJobViewer = isGroupOrJobViewer;          
           fetchMRSLayerChipAssociationDetails();
       }
       
   }
   /**
        @Method: discardSelection
        @param: null
        @return: void
        @Description : This method is used to discard the chips selected for approval
    **/
   public void discardSelection(){
       isConfirmApproved = false;
       isSelectionTableTrue = true;
       
   }
   
   /**
        @Method: performReview
        @param: null
        @return: void
        @Description : This method is used to display the page after perform review button is clicked
    **/
   public void performReview(){
       
       isTableActive = false;
       isSelectionTableTrue = true;
       imageActive = false;
       labelorDropdown = false;
       isJobViewer = true;
       fetchMRSLayerChipAssociationDetails();
       isPerformActive = false;
       
   }
   
   /**
        @Method: exportToExcel
        @param: null
        @return: void
        @Description : This method is used to generate the excel file
    **/
   public PageReference exportToExcel(){
       
       Pagereference pgRef = Page.VFMRSGDSOUTReviewToExcel;
       pgRef.getParameters().put('type',type);       
       if(isTableActive)
           return pgRef;
       else
           return null;
   }
   
   /**
        @Method: exportToPDF
        @param: null
        @return: void
        @Description : This method is used to generate the pdf file
    **/
   public PageReference exportToPDF(){
       if(isTableActive)
           return Page.VFMRSGDSOUTReviewToPDF;
       else
           return null;
   }
   
   /**
        @Method: exportToCSV
        @param: null
        @return: void
        @Description : This method is used to generate the csv file
    **/
   public PageReference exportToCSV(){
           
       if(isTableActive)
           return Page.VFMRSGDSOUTReviewToCSV;
       else
           return null;
   }
   public void fetchAfterApply(){
       if(selectedCustomerId != null && selectedMSTId != null && String.valueOf(selectedCustomerId) != '' && String.valueOf(selectedMSTId) != ''){
           fetchMRSLayerChipAssociationDetails();
       }
   }
   //Date: 07/08/2014 Reason: Task-1732
   public List<WrapperChip> sortList(List<WrapperChip> lstChip){
        Map<String,WrapperChip> mapChip = new Map<String,WrapperChip>();
        List<String> keyList = new List<String>();
        for(WrapperChip wrObj : lstChip){
            mapChip.put(wrObj.chip,wrObj);
        }   
        keyList.addAll(mapChip.keySet());
        keyList.sort();
        lstChip.clear();
        for(String key : keyList){
            lstChip.add(mapChip.get(key));
        }
        
        return lstChip;
   }
   //Date: 07/08/2014 Reason: Task-1732 - END 

}