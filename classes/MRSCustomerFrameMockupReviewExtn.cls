/*
Type Name: MRSCustomerFrameMockupReviewExtn
Author: Cognizant 
Created Date: 17-April-2014
Reason: 
Change History:
Author: 
Modified Date: 
Reason: 
Author: Cognizant Technology Solutions
Modified Date:
��..
��..
*/

public class MRSCustomerFrameMockupReviewExtn
{
    private  list<Account> lstCustomerList;
    public string selectedCustomer {get ;set;}
    public Boolean showLabel {get;set;}
    public list<MST_Config__c> mstConfiglst {get ;set;}
    //public list<SelectOption> lstmst {get;set;}
    public String selectedmst {get;set;}
    public list<SelectOption> lstMaskLayer {get;set;}
    public String selectedMaskLayer {get;set;}
    public list<SelectOption> lstLayerStatus {get ;set;}
    public String selectedLayerStatus {get ;set;}
    public list<SelectOption> lstDeviceId {get;set;}
    public String selectedDeviceId {get ;set;}
    public list<SelectOption> lstFrameStatus {get ;set;}
    public String selectedFrameStatus {get;set;}
    public String selectedCustomerName {get;set;}
    public List<MRS_Layer_Chip_Association__c> lstmrsLayerChipSummary{get;set;}
    public Map<String,String> IDMstNameMap{get;set;} 
    public Map<Id,String> idAndMaskLayer{get;set;} 
    public Set<String> layerStatus{get;set;} 
    public Set<String> frameStatus{get;set;} 
    public Map<Id,String> account_idmap {get;set;}
    
    public List<frameTableWrapper> lstframeTableWrapper {get ;set;}
    public boolean renderedApproveData {get ;set;}
    public boolean rerenderApproveButton {get;set;}
    public boolean rerenderDisapproveButton {get;set;}
    public boolean disapproveReason {get ;set;}
    public String disApproveReasonTxt {get ;set;}
    private Map<String,MRS_Layer_Chip_Association__c> ptrfLayerChipSet = new Map<String,MRS_Layer_Chip_Association__c>();
    public String approveOrDisapprove {get;set;}
    public Boolean layerChipSummarTbl {get;set;}
    public Boolean performReviewFlag {get ;set;}
    public Boolean reticleType {get ; set;}
    public Boolean approveTableFlag{get;set;}
    public Boolean customerOrFoundary {get ;set;}
    public Map<Id,String> mapIdAnddate {get ;set;}
    private List<Id> mrsLayerChipSummary = new List<Id>();
    public Boolean isFilterActive {get;set;}
    public Boolean isBreadcrumbActive {get;set;}
    public Boolean isJobviewrChecked {get;set;}
    public Boolean  isQuickLinkChecked { get; set;}
    public String maskSetTitleName {get ;set;}
    public String customerNameAfterSave {get ;set;}
    public String mstNameAfterSave {get;set;}
    private String type;
    private Map<String,String> mapmstIdMstName = new Map<String,String>();
    public String page {get;set;}
    private Set<Id> disaaprovePTRFId = new Set<Id>();
    //public list<SelectOption> lstOfCustomer{get;set;}
    private Boolean isUserGlobalShuttle=false;
    private Boolean isUserTDTIMPW=false;
    private Boolean isUserMDP=false;
    private Boolean isUserTapeoutCenter=false; 
    public Boolean isJobViewer {get;set;}
    private Boolean seeThePerformApproval;
    private Boolean isRecordLocked = false;
    private Map<Id,Boolean> isGroupUserJobViewer = new Map<Id,Boolean>();
    private Boolean isAnyStatusisReady;
    private  Boolean isGroupOrJobViewer = false ;
    private Boolean applyFilters = false;
    Boolean isUserAdmin = false;
    public Boolean noRecords{get;set;}
    public Boolean errorMessage{get;set;}
    private Set<String> deviceIdSt = new Set<String>();
    public String lookupCustomerURL {get;set;}
    public String lookupMSTURL {get;set;}
    private static Boolean lstOfAcc;
    
    public MRSCustomerFrameMockupReviewExtn(ApexPages.StandardController controller) {

        //-------Fetch Customer Name-------------------------------//
        type = ApexPages.currentPage().getParameters().get('type');
        String url = ApexPages.currentPage().getHeaders().get('Host');
        if(url.contains(Label.Swift_Host_URL)){
                isBreadcrumbActive = true;
                lookupCustomerURL = Label.Swift_VFExternal_URL+'VFCustomerLookupDialog';
                lookupMSTURL = Label.Swift_VFExternal_URL+'VFMaskSetTitleLookupDialog';
        }else{
              isBreadcrumbActive =false;
              lookupCustomerURL = Label.Swift_VFInternal_URL+'VFCustomerLookupDialog';
              lookupMSTURL = Label.Swift_VFInternal_URL+'VFMaskSetTitleLookupDialog';
        }
        
        if(type =='Customer')
        {
            customerOrFoundary =true;
            page ='CustomerFrameMockup';
        }else
        {
            customerOrFoundary  =false;
            page ='FoundryFrameMockup';
        }
         lstCustomerList = MRSHandlerUtility.fetchCustomerName();
         lstframeTableWrapper  = new List<frameTableWrapper>();
         //lstmst = new List<SelectOption>();
         lstMaskLayer  = new List<SelectOption>();
         lstDeviceId   = new List<SelectOption>();
         lstLayerStatus = new List<SelectOption>();
         lstFrameStatus  = new List<SelectOption>();
         //-----------------new Code------//
         mapIdAnddate = new Map<Id,String>();
         IDMstNameMap  = new Map<String,String>();
         idAndMaskLayer = new Map<Id,String>();
         layerStatus = new Set<String>();
         frameStatus = new Set<String>();
         account_idmap = new Map<Id,String>();
         //lstOfCustomer = new list<SelectOption>();
         isFilterActive =false;
         isJobViewer = false;
        //-------Fetch Mask Set Title-------------------------------//
        /** see whether it is a group user or not**/
        
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
                        if(Environment_Variable__c.getInstance('ALL_VIEW_ALL_APPROVAL').Value__c.containsIgnoreCase(userGroup)){
                          isUserAdmin = true;
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
       if(lstCustomerList !=null)
       { 
          if(lstCustomerList.size() > 0){
            if(ApexPages.currentPage().getCookies().get('account') ==  null  &&  ApexPages.currentPage().getCookies().get('mst') ==  null){
                if(lstCustomerList.size()>1)
                {
                    showLabel = false;
                    
                    for(Account acc : lstCustomerList)
                    {
                        String accName ;
                        if(acc.Short_Name__c !=null){
                            accName = acc.Name+' ('+acc.Short_Name__c+')';
                        }else{
                            accName = acc.Name;
                        }
                        account_idmap.put(acc.Id,accName);
                        //lstOfCustomer.add(new SelectOption(acc.Id,accName)) ;
                    }
                    
                }else 
                {
                    showLabel =true;
                    selectedCustomer =lstCustomerList.get(0).Id;
                    selectedCustomerName =lstCustomerList.get(0).Name+' ('+lstCustomerList.get(0).Short_Name__c+')';
                    customerNameAfterSave =lstCustomerList.get(0).Name+' ('+lstCustomerList.get(0).Short_Name__c+')';
                    lookupMSTURL = lookupMSTURL + '?aid=' + selectedCustomer + '&pg=' + page + '&jv=' + isJobViewer;
                    if(selectedCustomer != null){
                     ClsMyDevices.account = new Cookie('account',selectedCustomer,null,-1,false);
                     ApexPages.currentPage().setCookies(new Cookie[]{ClsMyDevices.account});
                    }
                    getMST();
                    performReviewFlag =false;
                   
                    for(Account acc : lstCustomerList)
                    {
                        String accName ;
                        if(acc.Short_Name__c !=null){
                            accName = acc.Name+' ('+acc.Short_Name__c+')';
                        }else{
                            accName = acc.Name;
                        }
                        account_idmap.put(acc.Id,accName);
                        //lstOfCustomer.add(new SelectOption(acc.Id,accName)) ;
                    }
                    
                    
                }
              
         }else{
                    if(ApexPages.currentPage().getCookies().get('account') != null && String.valueOf(ApexPages.currentPage().getCookies().get('account').getValue()) != '')
                    {
                        selectedCustomer = String.valueOf(ApexPages.currentPage().getCookies().get('account').getValue());
                        lookupMSTURL = lookupMSTURL + '?aid=' + selectedCustomer + '&pg=' + page + '&jv=' + isJobViewer;
                        getMST();
                            if(ApexPages.currentPage().getCookies().get('mst') == null)
                            {
                                performReviewFlag = false;
                            }
                                if(lstCustomerList.size()>1)
                                {
                                    for(Account acc : lstCustomerList)
                                    {
                                        String accName ;
                                        if(acc.Short_Name__c !=null){
                                            accName = acc.Name+' ('+acc.Short_Name__c+')';
                                        }else{
                                            accName = acc.Name;
                                        }
                                        account_idmap.put(acc.Id,accName);
                                        //lstOfCustomer.add(new SelectOption(acc.Id,accName)) ;
                                    }
                                    customerNameAfterSave  = account_idmap.get(Id.valueOf(selectedCustomer));
                                }else{
                                    showLabel =true;
                                    String accName ;
                                    if(lstCustomerList.get(0).Short_Name__c !=null){
                                        accName = lstCustomerList.get(0).Name+' ('+lstCustomerList.get(0).Short_Name__c+')';
                                    }else{
                                        accName = lstCustomerList.get(0).Name;
                                    }
                                    selectedCustomerName = accName;
                                    customerNameAfterSave = accName;
                                }
                           
                            if(ApexPages.currentPage().getCookies().get('mst') != null){
                                selectedmst = String.valueOf(ApexPages.currentPage().getCookies().get('mst').getValue());
                                mstNameAfterSave =IDMstNameMap.get(selectedmst);
                                getMRSLayerChipSummary();
                                if(mstNameAfterSave != null){
                                    if(lstmrsLayerChipSummary != null && lstmrsLayerChipSummary.size() > 0){
                                      layerChipSummarTbl = true;
                                      isFilterActive =true;
                                    }else{
                                        layerChipSummarTbl = false;
                                        isFilterActive =false;
                                    }
                                }
                             }else{
                                 layerChipSummarTbl = false;
                                 isFilterActive =false;
                             }
                    }else if(lstCustomerList.size()== 1){
                      showLabel =true;
                      selectedCustomer =lstCustomerList.get(0).Id;
                      selectedCustomerName =lstCustomerList.get(0).Name+' ('+lstCustomerList.get(0).Short_Name__c+')';
                      customerNameAfterSave =lstCustomerList.get(0).Name+' ('+lstCustomerList.get(0).Short_Name__c+')';
                      getMST();
                    }
           }
         }
        }
       lstOfAcc =showLabel;
         
        
    }
    /**
        @Method:getMRSLayerChipSummary
        @param: null
        @return: void
        @Description : This method will fetch the records to display in Frame Mockup page
    **/
    public void getMRSLayerChipSummary()
    {
        mrsLayerChipSummary.clear();
        mapIdAnddate.clear();
        lstframeTableWrapper.clear();
        ptrfLayerChipSet.clear();
        String page;
        
       /* showLabel = false;
        approveTableFlag = false;
        isQuickLinkChecked = false;*/
        if(!applyFilters){
         layerStatus.clear();
        idAndMaskLayer.clear();
        frameStatus.clear();
        deviceIdSt.clear();
        }
        if(customerOrFoundary)
        {
            page ='CustomerFrameMockup';
        }else
        {
            page='FoundryFrameMockup';
        }
         if(selectedmst != null && selectedmst.trim() != ''){
            lstmrsLayerChipSummary = MRSHandlerUtility.getMrsChipLayerSummary(selectedCustomer,selectedmst,selectedMaskLayer,selectedLayerStatus,selectedDeviceId,selectedFrameStatus,'','',page,isJobViewer/*,isDisplayed*/);
         }else{
            layerChipSummarTbl = false;
         }
        Boolean flgForAccountTeamProxy = false;
        List<String> teamRole = Environment_Variable__c.getInstance('SwiftFETeamRoles').Value__c.split(',');
        List<Account_Team_Proxy__c> accTeamProxy;
        if(selectedCustomer != null && selectedCustomer !=''){
           accTeamProxy = [Select Id,Account__c,User__c,Team_Role__c FROM Account_Team_Proxy__c WHERE User__c =:UserInfo.getUserId()  AND   Account__c =:selectedCustomer AND Team_Role__c IN:teamRole];
        }
        if(accTeamProxy != null && accTeamProxy.size() > 0 && page =='CustomerFrameMockup'){
          flgForAccountTeamProxy = true;
        }
        if(isUserAdmin){
          flgForAccountTeamProxy = true;
        }
         noRecords = false; //Sanity Testing Findings
         if(lstmrsLayerChipSummary  !=null && lstmrsLayerChipSummary.size() > 0)
         {
            
             performReviewFlag  =false;
             frameTableWrapper frameTableWrapperObj;
             Integer counter =1;
             boolean color=false;
             isGroupUserJobViewer.clear();
             for(MRS_Layer_Chip_Association__c mrsLayerObj : lstmrsLayerChipSummary)
             {
                String key = mrsLayerObj.ptrf__c;
                ptrfLayerChipSet.put(key,mrsLayerObj);
                IDMstNameMap.put(mrsLayerObj.layer__r.MRS__r.Mask_Set_Title__c,mrsLayerObj.layer__r.MRS__r.Mask_Set_Title__r.Name);
                if(!applyFilters ){
                 deviceIdSt.add(mrsLayerObj.PTRF__r.Device_Id__c);
                 if(mrsLayerObj.layer__c!=null && selectedmst!=null)
                 {
                     idAndMaskLayer.put(mrsLayerObj.layer__c,mrsLayerObj.layer__r.Name);
                 }
                 if(mrsLayerObj.Layer__r.Layer_Status__c!=null && selectedmst !=null)
                 {
                     layerStatus.add(mrsLayerObj.Layer__r.Layer_Status__c);
                 }
                 if(customerOrFoundary){
                     if(mrsLayerObj.Layer_Chip_Status__c!=null && selectedmst !=null)
                     {
                        frameStatus.add(mrsLayerObj.Customer_Frame_Mockup__c);
                     }
                     if(mrsLayerObj.Customer_Frame_Mockup__c == 'Ready' && mrsLayerObj.Layer_Chip_Status__c !='Cancel'){
                        isGroupUserJobViewer.put(mrsLayerObj.PTRF__c,true);
                     }
                 }
                 else{
                     if(mrsLayerObj.Layer_Chip_Status__c!=null && selectedmst !=null)
                     {
                        frameStatus.add(mrsLayerObj.Foundry_Frame_Mockup__c);
                     }
                     if(mrsLayerObj.Foundry_Frame_Mockup__c == 'Ready' && mrsLayerObj.Layer_Chip_Status__c !='Cancel'){
                        isGroupUserJobViewer.put(mrsLayerObj.PTRF__c,true);
                     }
                 }
                 }
                 
                 
             }
             isAnyStatusisReady = false;
             if(!isJobViewer){
               List<PTRF_JobViewer_Info__c> ptrfJobViewInfo = MRSHandlerUtility.getJobViewer(isGroupUserJobViewer.keySet(),page);
               if(ptrfJobViewInfo != null && ptrfJobViewInfo.size() > 0){
                  for(PTRF_JobViewer_Info__c ptrfJobViewObject : ptrfJobViewInfo){
                      if(isGroupUserJobViewer.get(ptrfJobViewObject.PTRF__c)){
                         isAnyStatusisReady =true ;
                         break;
                      }
                  }
               }
             }else{
                isAnyStatusisReady = true;
             }
             if(flgForAccountTeamProxy){
               isAnyStatusisReady = true;
             }
             Boolean checkedValue =false;
             for(String key : ptrfLayerChipSet.keySet())
             {
                
                mrsLayerChipSummary.add(ptrfLayerChipSet.get(key).Id);
              
                 if(ptrfLayerChipSet.get(key).PTRF__r.Recticle_Type__c =='Multi Node Reticle (MNR)')
                 {
                     reticleType  =true;
                 }
                 if(!color)
                 {
                     color = true;
                 }
                 else{
                     color =false;
                 }
                 if(customerOrFoundary)
                 {
                     if(ptrfLayerChipSet.get(key).Customer_Frame_Mockup__c=='Ready' && ptrfLayerChipSet.get(key).Layer_Chip_Status__c !='Cancel' && isAnyStatusisReady){
                         performReviewFlag  =true;
                     }
                 }else
                 {
                     if(ptrfLayerChipSet.get(key).Foundry_Frame_Mockup__c=='Ready'  && ptrfLayerChipSet.get(key).Layer_Chip_Status__c !='Cancel' && isAnyStatusisReady){
                         performReviewFlag  =true;
                     }
                 }
                 String techGeo = ptrfLayerChipSet.get(key).PTRF__r.Tech_Geo__c;
                 try{
                     if(Double.valueOf(ptrfLayerChipSet.get(key).PTRF__r.Tech_Geo__c) <0.10)
                     {
                         techGeo = ptrfLayerChipSet.get(key).PTRF__r.Tech_Geo__c;
                     }
                 }catch(Exception e)
                 {
                     if(ptrfLayerChipSet.get(key).PTRF__r.Tech_Geo__c != null)
                     {
                         String techGeoWithUM = ptrfLayerChipSet.get(key).PTRF__r.Tech_Geo__c.substringBefore('UM').trim();
                         if(techGeoWithUM == null)
                             techGeoWithUM = ptrfLayerChipSet.get(key).PTRF__r.Tech_Geo__c.substringBefore('um').trim();
                         if(Double.valueOf(techGeoWithUM ) <0.10)
                         {
                             techGeo = ptrfLayerChipSet.get(key).PTRF__r.Tech_Geo__c;
                         }   
                     }  
                 }
               if(selectedmst != null){
                     if(customerOrFoundary)
                     {
                         frameTableWrapperObj = new frameTableWrapper(counter,ptrfLayerChipSet.get(key).PTRF__r.Name,ptrfLayerChipSet.get(key).PTRF__c,ptrfLayerChipSet.get(key).Customer_Frame_Mockup__c,color,ptrfLayerChipSet.get(key).chip__c,checkedValue,ptrfLayerChipSet.get(key).Id,ptrfLayerChipSet.get(key).layer__c,techGeo,ptrfLayerChipSet.get(key).Id,ptrfLayerChipSet.get(key).Layer_Chip_Status__c);
                         if(ptrfLayerChipSet.get(key).Customer_Frame_Mockup_Date__c !=null){
                           mapIdAnddate.put(ptrfLayerChipSet.get(key).Id,String.ValueOf(ptrfLayerChipSet.get(key).Customer_Frame_Mockup_Date__c.format()));
                          }
                         else
                           mapIdAnddate.put(ptrfLayerChipSet.get(key).Id,'');
                     }else
                     {
                         frameTableWrapperObj = new frameTableWrapper(counter,ptrfLayerChipSet.get(key).PTRF__r.Name,ptrfLayerChipSet.get(key).PTRF__c,ptrfLayerChipSet.get(key).Foundry_Frame_Mockup__c,color,ptrfLayerChipSet.get(key).chip__c,checkedValue,ptrfLayerChipSet.get(key).Id,ptrfLayerChipSet.get(key).layer__c,techGeo,ptrfLayerChipSet.get(key).Id,ptrfLayerChipSet.get(key).Layer_Chip_Status__c);
                         if(ptrfLayerChipSet.get(key).Foundry_Frame_Mockup_Date__c !=null)
                          mapIdAnddate.put(ptrfLayerChipSet.get(key).Id,String.ValueOf(ptrfLayerChipSet.get(key).Foundry_Frame_Mockup_Date__c.format()));
                         else
                           mapIdAnddate.put(ptrfLayerChipSet.get(key).Id,''); 
                     }
                        lstframeTableWrapper.add(frameTableWrapperObj);
                     counter++;
                }
             }
         }else{
            layerChipSummarTbl = false;
            performReviewFlag =false;
            if(selectedmst != null && selectedmst.trim() != ''){
                Map<String,Error_Codes__c> mapErrorCodes = Error_Codes__c.getAll();
                noRecords = true;
            }
         }
         //lstmst.clear();
         lstMaskLayer.clear();
         lstDeviceId.clear();
         lstLayerStatus.clear();
         lstFrameStatus.clear();
         //lstmst.add(new SelectOption('All',''));
         for(String mstId : IDMstNameMap.keySet())
         {
             if(mstId != null){
               //lstmst.add(new SelectOption(mstId ,IDMstNameMap.get(mstId )));
             }
         }
          lstMaskLayer.add(new SelectOption('',''));
          Set<String> maskLayerSet = new Set<String>();
         for(Id layerId : idAndMaskLayer.keySet())
         {
             maskLayerSet.add(idAndMaskLayer.get(layerId));
         }
         for(String maskLayerSetObj : maskLayerSet)
         {
            lstMaskLayer.add(new SelectOption(maskLayerSetObj,maskLayerSetObj));
            
         }
         lstMaskLayer.sort();
         lstDeviceId.add(new SelectOption('',''));
         for(String device : deviceIdSt)
         {
             if(device != null){
               lstDeviceId.add(new SelectOption(device,device));
             }
             
         }
         lstDeviceId.sort();
         for(String layerSt : layerStatus)
         {
             lstLayerStatus.add(new SelectOption(layerSt,layerSt));
             
         }
         lstLayerStatus.sort();
         lstFrameStatus.add(new SelectOption('',''));
         for(String frameSt : frameStatus)
         {
             lstFrameStatus.add(new SelectOption(frameSt,frameSt));
             
         }
         lstFrameStatus.sort();
    }
    /**
        @Method : getMST
        @param: null
        @return: void
        @Description : This method will fetch the mst for showing it into the dropdown
    **/
    public void getMST()
    {
             if(selectedCustomer !=null)
            {
                Account accountObj = [SELECT Name,Id,Short_Name__c FROM Account WHERE Id=:selectedCustomer];
                String accName;
                if(accountObj.Short_Name__c != null){
                    accName = accountObj.Name+' ('+accountObj.Short_Name__c+')';
                }else{
                    accName = accountObj.Name;
                }
                selectedCustomerName = accName;
                customerNameAfterSave = accName;
                //------------------Code Added for remember customer name---------------------------//
                 ClsMyDevices.account = new Cookie('account',selectedCustomer,null,-1,false);
                 ApexPages.currentPage().setCookies(new Cookie[]{ClsMyDevices.account});
            }
            IDMstNameMap.clear();
            IDMstNameMap = MRSHandlerUtility.fetchMaskSetTitleList(selectedCustomer,page,isGroupOrJobViewer);
             performReviewFlag=false;
             layerChipSummarTbl  =false;
             selectedmst =null;
             selectedMaskLayer =null;
             selectedLayerStatus =null;
             selectedDeviceId =null;
             selectedFrameStatus =null;
             //lstmst.clear();
             lstMaskLayer.clear();
             lstLayerStatus.clear();
             lstFrameStatus.clear();
             lstDeviceId.clear();
             
             idAndMaskLayer.clear();
             deviceIdSt.clear();
             layerStatus.clear();
             frameStatus.clear();
             getMRSLayerChipSummary();
             performReviewFlag =false;
             if(approveTableFlag!=null || renderedApproveData!=null)
             {
                 if(approveTableFlag || renderedApproveData)
                 {
                     performReviewFlag =false;
                     layerChipSummarTbl=false;
                 }
                 
             }
            
             
    }
    /**
      @Method: getMaskLayer
      @param: null
      @return: void
      @Description : This method is used to get mask Layer to display into the filters
    **/
    public void getMaskLayer()
    {  
           noRecords = false;
             if(selectedmst != null && selectedmst.trim() != ''){
                 Mask_Set_Title__c msakSetObj = [SELECT Name FROM Mask_Set_Title__c WHERE Id =:selectedmst];
                 mstNameAfterSave = msakSetObj.Name ;
                 //----------------------Code added for remmember MST--------------------------------//
                 ClsMyDevices.mst = new Cookie('mst',selectedmst,null,-1,false);
                 ApexPages.currentPage().setCookies(new Cookie[]{ClsMyDevices.mst});
                 isFilterActive =true;
                 layerChipSummarTbl  =true;  
                 selectedMaskLayer =null;
                 selectedLayerStatus =null;
                 selectedDeviceId =null;
                 selectedFrameStatus =null;
                 applyFilters = false;
                 lstMaskLayer.clear();
                 lstLayerStatus.clear();
                 lstFrameStatus.clear();
                 lstDeviceId.clear();
                 idAndMaskLayer.clear();
                 deviceIdSt.clear();
                 layerStatus.clear();
                 frameStatus.clear();
                 lstframeTableWrapper.clear();
                 getMRSLayerChipSummary();
                  if(approveTableFlag!=null || renderedApproveData!=null)
                 {
                     if(approveTableFlag || renderedApproveData)
                     {
                         performReviewFlag =false;
                         layerChipSummarTbl=false;
                     }
                     
                 }
                
             }
    }
    /**
     @Method : getLayerStatus
     @param: null
     @return: void
     @Description : This method is used to retreive the Layer Status to display it into the filters
    **/
    public void getLayerStatus()
    {
             selectedLayerStatus =null;
             selectedDeviceId =null;
             selectedFrameStatus =null;
             lstLayerStatus.clear();
             lstFrameStatus.clear();
             lstDeviceId.clear();
             layerStatus.clear();
             frameStatus.clear();
             getMRSLayerChipSummary();
    }
    /**
    @Method: getDeviceId
    @param: null
    @return: void
    @Description: This method is used to retreive the device id to display it into the filter list
    **/
    public void getDeviceId()
    {
             selectedDeviceId =null;
             selectedFrameStatus =null;
             lstFrameStatus.clear();
             lstDeviceId.clear();
             frameStatus.clear();
             getMRSLayerChipSummary();
    }
    /**
     @Method:getFrameStatus
     @param: null
     @return:void
     @Description: This method will fetch the frame status to display it into the filter list
    **/
    public void getFrameStatus()
    {
             selectedFrameStatus =null;
             lstFrameStatus.clear();
             frameStatus.clear();
             getMRSLayerChipSummary();
    }
     /**
     @Inner class :frameTableWrapper
     @Description: This is a wrapper which is used to display the table in frame mockup
                page.
    **/
    public class frameTableWrapper
    {
        public Integer srlNo {get;set;}
        public String ptrf {get;set;}
        public Id ptrfId {get;set;}
        public String status {get ;set;}
        public boolean color {get ;set;}
        public Id chipId {get;set;}
        public Boolean checkedValue {get;set;}
        public Id layerChipSummarId {get;set;}
        public Id layerId {get;set;}
        public String techGeo {get;set;}
        public Id recordId{get;set;}
        public String layerChipStatus{get;set;}
        public frameTableWrapper(Integer srlNo,String ptrf,Id ptrfId ,String status,boolean color,Id chipId,Boolean checkedValue,Id layerChipSummarId ,Id layerId,String techGeo,Id recordId,String layerChipStatus)
        {
            this.srlNo =srlNo;
            this.ptrf =ptrf;
            this.ptrfId =ptrfId ;
            this.status =status;
            this.color =color;
            this.chipId =chipid;
            this.checkedValue =checkedValue ;
            this.layerChipSummarId  =layerChipSummarId ;
            this.layerId = layerId;
            this.techGeo =techGeo ;
            this.recordId=recordId;
            this.layerChipStatus = layerChipStatus;
        }
    }
    /**
     @Method: checkAllFrameStatus
     @param: null
     @return: void
     @descrption: This method is used to check whether the disapprove text should be shown in the page or not. 
    **/
    public void checkAllFrameStatus()
    {
       renderedApproveData  =true;
       disapproveReason =true;
       if(approveOrDisapprove.equalsIgnoreCase('Disapprove'))
        {
            disapproveReason =true;
        }else
        {
            disapproveReason =false;
        }
    }
    /**
     @Method: getApproveButtonEnabled
     @param: null
     @return : void
     @descrption: This method is used to check whether the Perform Approval button willbe enabled or not
    **/
    public void getApproveButtonEnabled()
    {
        
        if(selectedCustomer !=null)
        {
            Account accountObj = [SELECT Name,Id,Short_Name__c FROM Account WHERE Id=:selectedCustomer];
            selectedCustomerName = accountObj.Name+' ('+accountObj.Short_Name__c +')';
            customerNameAfterSave = accountObj.Name+' ('+accountObj.Short_Name__c +')';
        }
        Mask_Set_Title__c msakSetObj = [SELECT Name FROM Mask_Set_Title__c WHERE Id =:selectedmst];
        maskSetTitleName  = msakSetObj.Name ;
        mstNameAfterSave = msakSetObj.Name ;
        rerenderApproveButton =true;
        lstframeTableWrapper.clear();
        ptrfLayerChipSet.clear();
        approveTableFlag=true;
        layerChipSummarTbl=false;
        isJobViewer = true;
        showLabel = true;
        getMRSLayerChipSummary();
        performReviewFlag=false;
    }
    /**
     @Method: getTblData
     @param: null
     @return : void
     @descrption: This method is used to check whther the table should display depending upon the size of the wrapper list
    **/
    public void getTblData()
    {
       
        lstframeTableWrapper.clear();
        ptrfLayerChipSet.clear();
        applyFilters  = true;
        getMRSLayerChipSummary();
        if(!lstframeTableWrapper.isEmpty())
            layerChipSummarTbl =true;
        else{
             layerChipSummarTbl  =false; 
             Map<String,Error_Codes__c> mapErrorCodes = Error_Codes__c.getAll(); 
             noRecords = true;
            }  
    }
     /**
     @Method: saveTheData
     @param: null
     @return : void
     @descrption: This method will save the frame mockup review status.
    **/
    public void saveTheData()
    {
        MRS_Layer_Chip_Association__c mrsLayerChipObj;
        List<MRS_Layer_Chip_Association__c> lstMRSLayerChipAsso = new List<MRS_Layer_Chip_Association__c>();
        Set<Id> layerId = new Set<Id>();
        Map<Id,String> ptrfStatus = new  Map<Id,String>();
        Map<Id,List<MRS_Layer_Chip_Association__c>> techGeoAndId = new Map<Id,List<MRS_Layer_Chip_Association__c>>();
        Map<Id,List<MRS_Layer_Chip_Association__c>> disApproveMap = new Map<Id,List<MRS_Layer_Chip_Association__c>>();
        List<MRS_Layer_Chip_Association__c> mrsLayerChiplst;
        Set<Id> lstlayerChipId = new Set<Id>();
        Boolean flagForDisApproveOrApprove=false;
        isRecordLocked = false;
        Map<Id,List<MRS_Layer_Chip_Association__c>>  IdAndMRSChipObjlstMap= new Map<Id,List<MRS_Layer_Chip_Association__c>>();
        List<MRS_Layer_Chip_Association__c> mrsLayerChipObjlst;
        List<MRS_Layer_Chip_Association__c> mrsChipLayerQuery ;
        Map<String,Error_Codes__c> mapErrorCodes = Error_Codes__c.getAll();
        try{
          mrsChipLayerQuery = [SELECT Id,PTRF__c,Customer_Frame_Mockup__c,Customer_Frame_Mockup_Date__c,
                                                                          Foundry_Frame_Mockup__c,Foundry_Frame_Mockup_Date__c,Layer__c,Chip__r.Name,
                                                                          layer__r.MRS__r.Mask_Set_Title__r.Name,PTRF__r.Name,PTRF__r.Tech_Geo__c,
                                                                          Layer__r.ROM_Code__c,Layer__r.Mask_Layer_Rev__c,Layer__r.Name,PTRF__r.MaskSetTitle__r.Name
                                                                   FROM MRS_Layer_Chip_Association__c
                                                                   WHERE PTRF__c IN:ptrfLayerChipSet.keySet()
                                                                   AND Chip__r.Name =:Label.SWIFT_Frame_Status FOR UPDATE];
          for( MRS_Layer_Chip_Association__c frameTableWrapperObj : mrsChipLayerQuery )
          {
                   
                   if(IdAndMRSChipObjlstMap.get(frameTableWrapperObj.PTRF__c) != null)
                   {
                      IdAndMRSChipObjlstMap.get(frameTableWrapperObj.PTRF__c).add(frameTableWrapperObj);
                   }else
                   {
                   
                       mrsLayerChipObjlst= new List<MRS_Layer_Chip_Association__c>();
                       mrsLayerChipObjlst.add(frameTableWrapperObj);
                       IdAndMRSChipObjlstMap.put(frameTableWrapperObj.PTRF__c,mrsLayerChipObjlst);
                   }
               
          }
        }catch(Exception ex){
                    if(ex.getMessage().containsIgnoreCase(mapErrorCodes.get('DRT_Lock_SFDC_Error').Message__c)) {                      
                      ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,mapErrorCodes.get('MRS_Lock_Error').Message__c);                                              
                        ApexPages.addMessage(myMsg);
                        errorMessage=true;
                        isRecordLocked = true;               
                  }  
        }
        
        List<MRS_Layer_Chip_Association__c> mrsLayerChipAssoForSave;
        String sendEmailToCustomerOrFoundry ;
       if(!isRecordLocked){
       //MRSHandlerUtility.numberOfLayerChipRecords = 0;
        for( frameTableWrapper frameTableWrapperObj : lstframeTableWrapper)
          {
               mrsLayerChipAssoForSave = IdAndMRSChipObjlstMap.get(frameTableWrapperObj.ptrfId);
               //MRSHandlerUtility.numberOfLayerChipRecords = MRSHandlerUtility.numberOfLayerChipRecords + mrsLayerChipAssoForSave.size();
               //System.debug('MRSHandlerUtility.numberOfLayerChipRecords::Frame::'+MRSHandlerUtility.numberOfLayerChipRecords);
               if(frameTableWrapperObj.checkedValue ==true)
               {
                  if(customerOrFoundary){ 
                       if(approveOrDisapprove =='Disapprove')
                       {
                           for(MRS_Layer_Chip_Association__c mrsLayerChipAssoObj : mrsLayerChipAssoForSave )
                           {
                             if(mrsLayerChipAssoObj.Customer_Frame_Mockup__c == 'Ready'){
                                 mrsLayerChipAssoObj.Customer_Frame_Mockup__c='Disapprove';
                                 mrsLayerChipAssoObj.Customer_Frame_Mockup_Date__c =system.now();
                                 sendEmailToCustomerOrFoundry  ='Customer';
                                 disaaprovePTRFId.add(mrsLayerChipAssoObj.PTRF__c);
                                 if(techGeoAndId.get(mrsLayerChipAssoObj.PTRF__c) ==null)
                                 {
                                     mrsLayerChiplst = new List<MRS_Layer_Chip_Association__c>();
                                     mrsLayerChiplst.add(mrsLayerChipAssoObj);
                                     techGeoAndId.put(mrsLayerChipAssoObj.PTRF__c,mrsLayerChiplst);
                                 }else
                                 {
                                     techGeoAndId.get(mrsLayerChipAssoObj.PTRF__c).add(mrsLayerChipAssoObj);
                                 }
                                 flagForDisApproveOrApprove =false;
                                 lstlayerChipId.add(mrsLayerChipAssoObj.Id);
                                 layerId.add(mrsLayerChipAssoObj.Layer__c);
                                 lstMRSLayerChipAsso.add(mrsLayerChipAssoObj);
                            }
                           }
                       }else
                       {
                          for(MRS_Layer_Chip_Association__c mrsLayerChipAssoObj : mrsLayerChipAssoForSave )
                          {
                            if(mrsLayerChipAssoObj.Customer_Frame_Mockup__c == 'Ready'){
                                 mrsLayerChipAssoObj.Customer_Frame_Mockup__c='Approve';
                                 mrsLayerChipAssoObj.Customer_Frame_Mockup_Date__c =system.now();
                                 ptrfStatus.put(mrsLayerChipAssoObj.PTRF__c,mrsLayerChipAssoObj.Customer_Frame_Mockup__c);
                                 if(mrsLayerChipAssoObj.Foundry_Frame_Mockup__c =='Approve' || mrsLayerChipAssoObj.Foundry_Frame_Mockup__c =='N.A.')
                                 {
                                     
                                     if(mrsLayerChipAssoObj.Foundry_Frame_Mockup__c =='Approve')
                                     {
                                         sendEmailToCustomerOrFoundry  = 'Foundry&Customer';
                                     }else if(mrsLayerChipAssoObj.Foundry_Frame_Mockup__c =='N.A.')
                                     {
                                         sendEmailToCustomerOrFoundry  ='Customer';
                                     } 
                                     if(techGeoAndId.get(mrsLayerChipAssoObj.PTRF__c) == null)
                                     {
                                         mrsLayerChiplst = new List<MRS_Layer_Chip_Association__c>();
                                         mrsLayerChiplst.add(mrsLayerChipAssoObj);
                                         techGeoAndId.put(mrsLayerChipAssoObj.PTRF__c,mrsLayerChiplst);
                                     }else
                                     {
                                         techGeoAndId.get(mrsLayerChipAssoObj.PTRF__c).add(mrsLayerChipAssoObj);
                                     }
                                 }
                                 flagForDisApproveOrApprove =true;
                                 layerId.add(mrsLayerChipAssoObj.Layer__c);
                                 lstMRSLayerChipAsso.add(mrsLayerChipAssoObj);
                            }
                          }
                       }
                   }else
                   {
                        if(approveOrDisapprove =='Disapprove')
                       {
                          for(MRS_Layer_Chip_Association__c mrsLayerChipAssoObj : mrsLayerChipAssoForSave )
                          {
                            if(mrsLayerChipAssoObj.Foundry_Frame_Mockup__c == 'Ready'){
                                 mrsLayerChipAssoObj.Foundry_Frame_Mockup__c='Disapprove';
                                 mrsLayerChipAssoObj.Foundry_Frame_Mockup_Date__c =system.now();
                                 disaaprovePTRFId.add(mrsLayerChipAssoObj.PTRF__c);
                                 sendEmailToCustomerOrFoundry  ='Foundry';
                                 if(techGeoAndId.get(mrsLayerChipAssoObj.PTRF__c) ==null)
                                 {
                                     mrsLayerChiplst = new List<MRS_Layer_Chip_Association__c>();
                                     mrsLayerChiplst.add(mrsLayerChipAssoObj);
                                     techGeoAndId.put(mrsLayerChipAssoObj.PTRF__c,mrsLayerChiplst);
                                 }else
                                 {
                                     techGeoAndId.get(mrsLayerChipAssoObj.PTRF__c).add(mrsLayerChipAssoObj);
                                 }
                                 flagForDisApproveOrApprove=false;
                                 lstlayerChipId.add(mrsLayerChipAssoObj.Id);
                                 layerId.add(mrsLayerChipAssoObj.Layer__c);
                                 lstMRSLayerChipAsso.add(mrsLayerChipAssoObj);
                            }
                          }
                       }else
                       {
                          for(MRS_Layer_Chip_Association__c mrsLayerChipAssoObj : mrsLayerChipAssoForSave )
                          {
                            if(mrsLayerChipAssoObj.Foundry_Frame_Mockup__c == 'Ready'){
                                 mrsLayerChipAssoObj.Foundry_Frame_Mockup__c='Approve';
                                 mrsLayerChipAssoObj.Foundry_Frame_Mockup_Date__c =system.now();
                                 ptrfStatus.put(mrsLayerChipAssoObj.PTRF__c,mrsLayerChipAssoObj.Foundry_Frame_Mockup__c);
                                 if(mrsLayerChipAssoObj.Customer_Frame_Mockup__c =='Approve' || mrsLayerChipAssoObj.Customer_Frame_Mockup__c =='N.A.')
                                 {
                                     if(mrsLayerChipAssoObj.Customer_Frame_Mockup__c =='Approve')
                                     {
                                         sendEmailToCustomerOrFoundry  = 'Foundry&Customer';
                                     }else if(mrsLayerChipAssoObj.Customer_Frame_Mockup__c =='N.A.')
                                     {
                                         sendEmailToCustomerOrFoundry  ='Foundry';
                                     } 
                                     if(techGeoAndId.get(mrsLayerChipAssoObj.PTRF__c) ==null)
                                     {
                                         mrsLayerChiplst = new List<MRS_Layer_Chip_Association__c>();
                                         mrsLayerChiplst.add(mrsLayerChipAssoObj);
                                         techGeoAndId.put(mrsLayerChipAssoObj.PTRF__c,mrsLayerChiplst);
                                     }else
                                     {
                                         techGeoAndId.get(mrsLayerChipAssoObj.PTRF__c).add(mrsLayerChipAssoObj);
                                     }
                                 }
                                 flagForDisApproveOrApprove=true;
                                 layerId.add(mrsLayerChipAssoObj.Layer__c);
                                 lstMRSLayerChipAsso.add(mrsLayerChipAssoObj);
                            }
                          }
                       }
                   }
                   
               }
          }
    }
        
        if(!isRecordLocked){
         String category;
         if(customerOrFoundary)
         {
             category='Customer Frame Mockup Disapproval';
         }else
         {
             category='Foundry Frame Mockup Disapproval';
         }
          List<Notes__c> lstMRSLayerAsso =[SELECT Id,ParentId__c,Category__c,Body__c
                                                           FROM Notes__c
                                                           WHERE ParentId__c IN:lstlayerChipId
                                                           AND Category__c=:category];
        
             if(disApproveReasonTxt !=null && disApproveReasonTxt.trim()!='' && !flagForDisApproveOrApprove)
             {
               if(lstMRSLayerAsso !=null && lstMRSLayerAsso.size()>0){
                     
                     for(Notes__c mrsLayerObj : lstMRSLayerAsso )
                     {
                         mrsLayerObj.Body__c =disApproveReasonTxt ;
                     }
                     try{
                      update lstMRSLayerAsso ;
                     }catch(Exception e){
                     }
                    
                 }else
                 {
                     List<Notes__c> lstNotes = new List<Notes__c>();
                     Notes__c  notesObj;
                     for(Id layerChipId : lstlayerChipId)
                     {
                        notesObj = new Notes__c(Body__c=disApproveReasonTxt,Category__c=category,ParentId__c=layerChipId);
                        lstNotes.add(notesObj);
                     }
                     try{
                      insert lstNotes;
                     }catch(Exception e){
                     }
                 } 
                 try{
                      MRSHandlerUtility.numberOfLayerChipRecords = lstMRSLayerChipAsso.size(); 
                      update lstMRSLayerChipAsso;
                      if(!flagForDisApproveOrApprove){
                          List<PTRF__c> ptrfUpdatelst = new List<PTRF__c>();
                          for(PTRF__c ptrfObject : [SELECT Id,Prime_Tapeout__c,Status__c,Frame_Tapeout__c FROM PTRF__c Where Id IN :disaaprovePTRFId]){
                              if(!ptrfObject.Prime_Tapeout__c){
                                  ptrfObject.Status__c = 'Cancel';
                              }else{
                                  ptrfObject.Frame_Tapeout__c =false;
                              }
                              ptrfUpdatelst.add(ptrfObject);
                          }
                          try{
                              update ptrfUpdatelst;
                          }catch(Exception e){

                          }
                           
                         isJobViewer = isGroupOrJobViewer;
                           
                      }
                 }catch(Exception e){
                 }
                  
                    
                  String page;
                  if(customerOrFoundary)
                  {
                      page ='CustomerFrameMockup';
                  }else
                  {
                      page='FoundryFrameMockup';
                  }
                  if(techGeoAndId.size() >0)
                  {
                      if(sendEmailToCustomerOrFoundry =='Foundry&Customer')
                      {
                          try{
                              String disapprovalReason;
                              List<Notes__c> customerDisapprovalReason=[SELECT Id,ParentId__c,Category__c,Body__c
                                                                        FROM Notes__c
                                                                        WHERE ParentId__c IN:lstlayerChipId
                                                                        AND Category__c=:'Customer Frame Mockup Disapproval'];
                              if(customerDisapprovalReason != null)
                              {
                                disapprovalReason = customerDisapprovalReason.get(0).Body__c;
                              }
                              List<Notes__c> foundryDisapprovalReason=[SELECT Id,ParentId__c,Category__c,Body__c
                                                                        FROM Notes__c
                                                                        WHERE ParentId__c IN:lstlayerChipId
                                                                        AND Category__c=:'Foundry Frame Mockup Disapproval'];
                              if(foundryDisapprovalReason != null)
                              {
                                disapprovalReason = foundryDisapprovalReason.get(0).Body__c;
                              }
                             MRSHandlerUtility.sendEmailToReviewers(techGeoAndId,'CustomerFrameMockup',selectedCustomer,flagForDisApproveOrApprove,disapprovalReason,'');
                              }catch(Exception e){}
                          
                      }else if(sendEmailToCustomerOrFoundry !='Foundry&Customer')
                      {
                          try{
                              MRSHandlerUtility.sendEmailToReviewers(techGeoAndId,page,selectedCustomer,flagForDisApproveOrApprove,disApproveReasonTxt,'');
                             
                              }catch(Exception e){}    
                      }
                  }
                 
                  renderedApproveData =false;
                  rerenderApproveButton =false;
                  disapproveReason =false; 
                  layerChipSummarTbl=true;
                  errorMessage=false;
                  isQuickLinkChecked = false;
             }else if(!flagForDisApproveOrApprove && (disApproveReasonTxt ==null || disApproveReasonTxt.trim()==''))
             {
               isQuickLinkChecked =true;
               ApexPages.Message  myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,' '+mapErrorCodes.get('DISAPPROVE').Message__c);
               ApexPages.addMessage(myMsg);
               errorMessage=true;
             }
             if(flagForDisApproveOrApprove)
             {
                 try{
                  update lstMRSLayerChipAsso;
                  isJobViewer = isGroupOrJobViewer;
                  if(!flagForDisApproveOrApprove){
                          List<PTRF__c> ptrfUpdatelst = new List<PTRF__c>();
                          for(PTRF__c ptrfObject : [SELECT Id,Prime_Tapeout__c,Status__c,Frame_Tapeout__c FROM PTRF__c Where Id IN :disaaprovePTRFId]){
                              if(!ptrfObject.Prime_Tapeout__c){
                                  ptrfObject.Status__c = 'Cancel';
                              }else{
                                  ptrfObject.Frame_Tapeout__c =false;
                              }
                              ptrfUpdatelst.add(ptrfObject);
                          }
                          try{
                              update ptrfUpdatelst;
                          }catch(Exception e){
                          }
                          isJobViewer = isGroupOrJobViewer;
                   }
                 }catch(Exception e){
                 }
                
                 String page;
                  if(customerOrFoundary)
                  {
                      page ='CustomerFrameMockup';
                  }else
                  {
                      page='FoundryFrameMockup';
                  }
                  if(techGeoAndId.size() >0)
                  {
                      if(sendEmailToCustomerOrFoundry =='Foundry&Customer')
                      {
                          try{
                              MRSHandlerUtility.sendEmailToReviewers(techGeoAndId,'CustomerFrameMockup',selectedCustomer,flagForDisApproveOrApprove,disApproveReasonTxt,'');
                              }catch(Exception e){}
                          
                      }else if(sendEmailToCustomerOrFoundry !='Foundry&Customer')
                      {
                          try{
                              MRSHandlerUtility.sendEmailToReviewers(techGeoAndId,page,selectedCustomer,flagForDisApproveOrApprove,disApproveReasonTxt,'');
                             
                              }catch(Exception e){}
                          
                      }
                   }
                 renderedApproveData =false;
                 rerenderApproveButton =false;
                 disapproveReason =false; 
                 layerChipSummarTbl=true;
                 errorMessage=false;
             } 
             showLabel = lstOfAcc;
            if(flagForDisApproveOrApprove){
               applyFilters = false;   
               getMRSLayerChipSummary();   
            }else if(!flagForDisApproveOrApprove && disApproveReasonTxt != null && disApproveReasonTxt.trim() !=''){
              applyFilters = false;
             // isDisplayed = true;
              getMRSLayerChipSummary();   
            }
        }
        approveTableFlag = false;
        
        
    }
   /**
     @Method: checkDisapprove
     @param: null
     @return : void
     @descrption: This method will set the variable to  'Diapprove' when Disapprove button clicked by user.
   **/
    public void checkDisapprove()
    {
        approveOrDisapprove='Disapprove';
        disapproveReason =true;
        renderedApproveData=true;
        rerenderApproveButton =false;
        approveTableFlag=false;
    }
    /**
     @Method: checkApproveBuuton
     @param: null
     @return : void
     @descrption: This method will set the variable to  'Approve' when Approve button clicked by user.
   **/
    public void checkApproveBuuton()
    {
        approveOrDisapprove ='Approve';
        disapproveReason  =false;
        renderedApproveData=true;
        rerenderApproveButton=false;
        approveTableFlag=false;
    }
    /**
     @Method: discardDataFrom
     @param: null
     @return : void
     @descrption: This method will redirect the user to previous page whenevr the user click on discard button.
   **/
    public void discardDataFrom()
    {
        approveOrDisapprove  ='';
        rerenderApproveButton =true;
        disapproveReason  =false;
        renderedApproveData =false;
        approveTableFlag=true;
    }
     /**
     @Method: exportToCSV
     @param: null
     @return : void
     @descrption: This method will extract the data into EXCEL
     **/
    public PageReference exportToCSV()
    {
        
        PageReference page =null;
        if(lstframeTableWrapper!=null &&  lstframeTableWrapper.size() > 0 && layerChipSummarTbl!=null)
        {
         for(MRS_Layer_Chip_Association__c mrsLayerObj : lstmrsLayerChipSummary)
         {
             if(mrsLayerObj.PTRF__r.Recticle_Type__c =='Multi Node Reticle (MNR)')
                 {
                     reticleType  =true;
                 }
         }
        page =new PageReference('/apex/VFMRSFrameMockupReviewExcel');
        page.getParameters().put('type',type);
        }else{
           page =null;
        }
        return page;
    }
   /**
     @Method: exportToPDF
     @param: null
     @return : void
     @descrption: This method will extract the data into CSV
     **/ 
   public PageReference exportToPDF()
   {
        PageReference page =null;
        if(lstframeTableWrapper!=null && lstframeTableWrapper.size() > 0 && layerChipSummarTbl!=null)
        {
            for(MRS_Layer_Chip_Association__c mrsLayerObj : lstmrsLayerChipSummary)
         {
             if(mrsLayerObj.PTRF__r.Recticle_Type__c =='Multi Node Reticle (MNR)')
                 {
                     reticleType  =true;
                 }
         }
            page =new PageReference('/apex/VFMRSFrameMockupReviewCSV');
            page.getParameters().put('type',type);
        }else{
           page =null;
        }
        return page;
   }
   /**
    Reset the Cookies 
   **/
   public void resetLSPCookies(){
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
   
}