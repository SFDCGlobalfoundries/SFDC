public class MRSResumeHoldLayerChipExtn{
    private list<integer> lstSizeOne;
    public String SelectedCustomerId;
    public String SelectedMSTid;
    public String SelectedCustomerName{get;set;}
    public String SelectedMSTName{get;set;}
    public String SelectedMrsLayerId;
    public String oldLayerStatus {get;set;}
    public List<SelectOption> lstLayerStatusOption {get;set;}
    public String selectedLayerStatus{get;set;}
    public List<SelectOption> lstDeviceIdOption {get;set;}
    public String selectedDeviceId{get; set;}
    public List<SelectOption> lstTechGeoOption {get;set;}
    public String selectedTechGeo{get; set;}
    public List<MRSLayerChipWrapper> mrsWrapperLists {get; set;}
    public Set<String> layerStatusName {get; set;}
    public String ValueCatcher {get;set;} {ValueCatcher = '';}
    public Set<String> deviceIdName {get; set;}
    public Set<String> techGeoName {get; set;}
    private List<MRS_Layer_Chip_Association__c> lstChipLayerAssocObjs;
    public Boolean performChipHold {get ;set;}
    public Boolean isHoldActive {get;set;}
    public Boolean isResumeActive {get;set;}
    public String customerSelected ;
    public String mstSelected;
    public Boolean internalView {get;set;}
    public String maskLayerName{get;set;}
    public Integer countOnProceed ;
    public Boolean colorOnProceed ;
    public Boolean isBreadcrumbActive {get;set;}
    public Boolean records {get;set;}
    
    Boolean isUserGlobalShuttle=false;
    Boolean isUserTDTIMPW=false;
    Boolean isUserMDP=false;
    Boolean isUserAdmin=false;  
    Boolean isTapeOutCenter = false;
    Boolean isRMG = false;
    Boolean isTapeoutApp = false;
    public Boolean showError {get;set;}
    
public MRSResumeHoldLayerChipExtn(ApexPages.StandardController controller){
    lstSizeOne = new list<integer>{1};
    mrsWrapperLists = new List<MRSLayerChipWrapper>();
    lstLayerStatusOption = new List<SelectOption>();
    lstDeviceIdOption = new List<SelectOption>();
    lstTechGeoOption = new List<SelectOption>();
    lstChipLayerAssocObjs = new List<MRS_Layer_Chip_Association__c>();
    layerStatusName = new Set<String>(); // Initializing for populating Layer Status filter
    deviceIdName = new Set<String>(); // Initializing for populating Device Id filter
    techGeoName = new Set<String>(); // Initializing for populating Tech Geo filter
    SelectedCustomerId = '';
    SelectedMSTid = '';
    SelectedCustomerName ='';
    SelectedMSTName ='';
    
    performChipHold = false;
    isHoldActive = false;
    isResumeActive = false;
    
    internalView = false;
        String hostName = ApexPages.currentPage().getHeaders().get('Host');
        if(!String.isBlank(System.Label.Internal_URL) && System.Label.Internal_URL.containsIgnoreCase(hostName)) { internalView = true; }
        else {
            internalView = false;
        } 
        
     String url = ApexPages.currentPage().getHeaders().get('Host');
    if(url.contains(Label.Swift_Host_URL)){ isBreadcrumbActive = true; } else { isBreadcrumbActive = false; }
    /*-----------------------User Groups-----------------------*/
    Id userId = UserInfo.getUserId();
    set<String> setLoggedInUserGroups = new set<String>(); 
    setLoggedInUserGroups.addAll(MRSHandlerUtility.fetchCurrentUserGroup(userId));
    
    if(setLoggedInUserGroups.size()>0){
        for(String userGroup:setLoggedInUserGroups){
            if(userGroup.equalsIgnoreCase('Swift_GlobalShuttle')||userGroup.equalsIgnoreCase('Swift_TDTI_MPW')
                        ||userGroup.equalsIgnoreCase('Swift_MDP')||userGroup.equalsIgnoreCase('Swift_Tapeout_Centre')
                        ||userGroup.equalsIgnoreCase('Swift_Tapeout_Application')
                        ||userGroup.equalsIgnoreCase('SWIFT_Admin')||userGroup.equalsIgnoreCase('Swift_RMG')){
                if(userGroup.equalsIgnoreCase('Swift_GlobalShuttle')){ isUserGlobalShuttle=true; } 
                if(userGroup.equalsIgnoreCase('Swift_TDTI_MPW')){ isUserTDTIMPW=true; } 
                if(userGroup.equalsIgnoreCase('Swift_MDP')){ isUserMDP=true; } 
                if(userGroup.equalsIgnoreCase('SWIFT_Admin')){ isUserAdmin=true; } 
                if(userGroup.equalsIgnoreCase('Swift_RMG')){ isRMG=true; } 
                if(userGroup.equalsIgnoreCase('Swift_Tapeout_Centre')){ isTapeOutCenter=true; } 
                if(userGroup.equalsIgnoreCase('Swift_Tapeout_Application')){ isTapeoutApp=true; }  
                            
            }
            
        }
    }
    /*---------------------------------------------------------*/
    getUrlParameters();
    getMRSLayerChipAssociation();
    
 }
public Boolean enableProceedTable {get;set;}
public List<MRSLayerChipWrapper> wrapperlst {get;set;}

    /**
        @Method:displayChipProceedData
        @param: null
        @return: void
        @Description : This method creates the wrapper object
    **/
public void displayChipProceedData(){
        enableProceedTable = true;
        countOnProceed = 1;
        colorOnProceed = true;
        wrapperlst  = new List<MRSLayerChipWrapper>();
        for(MRSLayerChipWrapper mrsWrapperObj :mrsWrapperLists)
        {
            if(mrsWrapperObj.isChecked)
            {
                mrsWrapperObj.count = countOnProceed++;
                mrsWrapperObj.color = colorOnProceed;
                if(!colorOnProceed) { mrsWrapperObj.color = true; colorOnProceed = true; } else { mrsWrapperObj.color = false; colorOnProceed = false; }
                wrapperlst.add(mrsWrapperObj);
            }
        }
        
    }
    /**
        @Method:getUrlParameters
        @param: null
        @return: void
        @Description : This method gets the parameters
    **/
Public void getUrlParameters(){
    SelectedCustomerId= Apexpages.currentPage().getParameters().get('customerId');
    SelectedMSTid= Apexpages.currentPage().getParameters().get('MSTID');
    SelectedMrsLayerId=Apexpages.currentPage().getParameters().get('MRSLAYERID');
    maskLayerName = Apexpages.currentPage().getParameters().get('MaskLayerName');
    
    if(SelectedCustomerId != Null){
        Account acc = [Select Name,Short_Name__c from Account WHERE Id = :SelectedCustomerId];
        
        SelectedCustomerName = acc.Name + ' ('+acc.Short_Name__c+')';
    }
    if(SelectedMSTid != Null){
        Mask_Set_Title__c mst = [Select Name from Mask_Set_Title__c WHERE Id = :SelectedMSTid];
        SelectedMSTName = mst.Name;
    }
    
    }
    /**
        @Method:exportToCSV
        @param: null
        @return: PageReference
        @Description : This method exports to CSV
    **/
    public PageReference exportToCSV()
    {
        
        PageReference page =null;
        if(mrsWrapperLists!=null) { page =new PageReference('/apex/VFMRSResumeHoldChipCSV'); }else{ page =null; }
        return page;
    }
    /**
        @Method:exportToExcel
        @param: null
        @return: PageReference
        @Description : This method exports to Excel
    **/    
   public PageReference exportToExcel()
   {
        PageReference page =null;
        if(mrsWrapperLists!=null) { page =new PageReference('/apex/VFMRSResumeHoldChipExcel'); }else{ page =null; }
        return page;
   }
    /**
        @Method:getMRSLayerChipAssociation
        @param: null
        @return: PageReference
        @Description : This method queries the data to display
    **/ 
public void getMRSLayerChipAssociation(){
    
    layerStatusName.clear();
    lstLayerStatusoption.clear();
    deviceIdName.clear();
    lstDeviceIdOption.clear();
    techGeoName.clear();
    lstTechGeoOption.clear();
    lstChipLayerAssocObjs.clear();
    mrsWrapperLists.clear();
    
    if(selectedCustomerId != null){
        lstChipLayerAssocObjs = getMRSChipLayerDetail(selectedCustomerId,selectedMSTid,SelectedMrsLayerId,selectedlayerStatus,
                                                    selectedDeviceId,selectedTechGeo);
    }
    
    if(lstChipLayerAssocObjs != null && lstChipLayerAssocObjs.size() > 0){
        records = true;
    }
    else {
        records = false;
    }
    
                                             
    if(lstChipLayerAssocObjs != null && !lstChipLayerAssocObjs.isEmpty()){        
        Map<String,MRS_Layer_Chip_Association__c> mapMRSChipLayerAssocObj = new Map<String,MRS_Layer_Chip_Association__c>();
        
        isHoldActive = false;
        isResumeActive = false;
        for(MRS_Layer_Chip_Association__c mrsObj : lstChipLayerAssocObjs){

            
            if(mrsobj.Layer__r.Layer_Status__c!=null && selectedMSTid !=null)
                 {
                     layerStatusName.add(mrsObj.Layer__r.Layer_Status__c);
                 }     
                 
            if(mrsobj.PTRF__r.Device_Id__c!=null && selectedMSTid !=null)
                 {
                     deviceIdName.add(mrsObj.PTRF__r.Device_Id__c);
                 }
                 
            if(mrsobj.Tech_Geo__c!=null && selectedMSTid !=null)
                 {
                     techGeoName.add(mrsObj.PTRF__r.Tech_Geo__c);
                 } 
                 
             
            if(mrsObj.layer_chip_status__c == 'In Progress' || mrsObj.layer_chip_status__c == 'Released'){ isHoldActive = true; }
            if(mrsObj.layer_chip_status__c == 'Hold'){
                isResumeActive = true;
            }
            
            
            // put data to map for unique combination of layer and layer status
            String key = mrsObj.Layer__c + '-' + mrsObj.Layer__r.Layer_Status__c;
            mapMRSChipLayerAssocObj.put(key,mrsObj);    
              
        }
        
            oldLayerStatus = lstChipLayerAssocObjs.get(0).Layer__r.Layer_Status__c;
        
        
         for(String layerSt : layerStatusName)
         {
             if(layerSt != null){
                lstLayerStatusoption.add(new SelectOption(layerSt,layerSt));
             }
         }
         lstLayerStatusoption.sort();    
            
         
         lstDeviceIdOption.add(new SelectOption('',''));
         for(String deviceid : deviceIdName)
         {
             if(deviceid != null){
                lstDeviceIdOption.add(new SelectOption(deviceid,deviceid));
             }
         }  
         lstDeviceIdOption.sort();
         
         lstTechGeoOption.add(new SelectOption('',''));
         for(String techGeo : techGeoName)
         {
             if(techGeo != null){   
                lstTechGeoOption.add(new SelectOption(techGeo,techGeo));
             }
             
         }
         lstTechGeoOption.sort();
       
            
        Boolean color = true;
        Boolean isChecked = false;
        Integer counter = 1;
        for(MRS_Layer_Chip_Association__c chip : lstChipLayerAssocObjs){            
            MRSLayerChipWrapper mrsWrappers = new MRSLayerChipWrapper(chip,counter,color,isChecked);
            mrsWrapperLists.add(mrsWrappers);
            if(!color) { color = true; } else { color = false; }
            counter++;
        }
    }    
}    
    /**
        @Method:getMRSChipLayerDetail
        @param: String customerId,String mstId,String mrsLayerId,String layerStatus,String deviceId,String techGeo
        @return: List<MRS_Layer_Chip_Association__c>
        @Description : This method prepares the query
    **/ 
private  List<MRS_Layer_Chip_Association__c> getMRSChipLayerDetail(String customerId,String mstId,String mrsLayerId,String layerStatus,String deviceId,String techGeo) {
    
    
    String chipFrom = 'DRT';
    String  lstmrsLayerChipsAsso = 'SELECT  Name,Chip__c,Chip__r.Name,Customer_Frame_Mockup__c,Customer_Frame_Remote_Jobview_Setup__c,layer__r.MRS__r.Mask_Set_Title__c,\n'+
                                             'layer__r.MRS__r.Mask_Set_Title__r.Name,PTRF__r.Device__c,PTRF__r.Device__r.Name,PTRF__r.Tech_Geo__c,Customer_GDSOUT_Review__c,Customer_MEBES_Jobview__c,\n'+
                                             'Customer_Prime_Remote_Jobview_Setup__c,Customer_Frame_Mockup_Date__c,Customer_Frame_Remote_Jobview_Setup_Date__c,\n'+
                                             'Customer_GDSOUT_Review_Date__c,DRW__c,DRW_Date__c,Foundry_Frame_Mockup__c,Foundry_Frame_Remote_Jobview_Setup__c,\n'+
                                             'Foundry_GDSOUT_Review__c,Foundry_Prime_Remote_Jobview_Setup__c,Foundry_Frame_Mockup_Date__c,Foundry_Frame_Remote_Jobview_Setup_Date__c,\n'+
                                             'Foundry_GDSOUT_Review_Date__c,Foundry_MEBES_Jobview__c,Foundry_MEBES_Jobview_Date__c,Foundry_Prime_Remote_Jobview_Setup_Date__c,\n'+
                                             'Frame_MEBES_Received__c,Frame_MEBES_Received_Date__c,Frame_TapeOut__c,GlobalShuttle_MEBES_Jobview__c,\n'+
                                             'GlobalShuttle_MEBES_Jobview_Date__c,PTRF_Or_DRT__c,PTRF__r.Order_Type__c,PTRF__r.Customer_jobview__c,PTRF__r.Foundry_Jobview__c,PTRF__r.Name,DRT__r.Name,Hold_Mask_Write__c,Hold_Mask_Write_Date__c,Layer__c,ROM_Code__c,\n'+
                                             'Layer__r.Name,Layer_Chip_Status__c,Mask_Layer__c,PTRF__c,Layer__r.Layer_Status__c,PTRF__r.Device_Id__c,Device_Id__c,PTRF__r.MaskSetTitle__r.Name,PTRF__r.MaskSetTitle__c,Tech_Geo__c,PTRF__r.Recticle_Type__c,PTRF__r.Frame_Tapeout__c,PTRF__r.Frame_Mockup__c,LastModifiedById \n'+
                                     ' FROM  MRS_Layer_Chip_Association__c';
                                     
     
      if(customerId !='' && customerId !=null)
      {
          lstmrsLayerChipsAsso  =lstmrsLayerChipsAsso  +' WHERE Customer_Name__c =:customerId';
      }
      if(mstId!=''  && mstId!=null){
          lstmrsLayerChipsAsso  =lstmrsLayerChipsAsso  +' AND layer__r.MRS__r.Mask_Set_Title__c =:mstId';
      }
      if(mrsLayerId!=''  && mrsLayerId!=null){
          lstmrsLayerChipsAsso  =lstmrsLayerChipsAsso  +' AND layer__c =:mrsLayerId';
      }
      if(ValueCatcher!='' && ValueCatcher!=null){
          List<String> layerStatusList = new List<String>();
          layerStatusList = ValueCatcher.split(',');
          
    
          lstmrsLayerChipsAsso  =lstmrsLayerChipsAsso  +' AND Layer__r.Layer_Status__c =:layerStatusList';
      }    
      if(deviceId!='' && deviceId!=null){
          lstmrsLayerChipsAsso  =lstmrsLayerChipsAsso  +' AND PTRF__r.Device_Id__c=:deviceId';
      }
      if(techGeo!='' && techGeo!=null){
          lstmrsLayerChipsAsso  =lstmrsLayerChipsAsso  +' AND PTRF__r.Tech_Geo__c=:techGeo';
      } 
      lstmrsLayerChipsAsso  =lstmrsLayerChipsAsso  +' AND PTRF_Or_DRT__c != :chipFrom';  
            List<MRS_Layer_Chip_Association__c> MRSlayerChipLists =Database.Query(lstmrsLayerChipsAsso);
            
            
      Set<MRS_Layer_Chip_Association__c> mrsLayerChipSet = new Set<MRS_Layer_Chip_Association__c>();
      if(isUserGlobalShuttle){ mrsLayerChipSet.addAll(permissionToViewData(MRSlayerChipLists,'GlobalShuttle')); } 
      if(isUserTDTIMPW){ mrsLayerChipSet.addAll(permissionToViewData(MRSlayerChipLists,'TDTI-MPW')); }
      if(isUserMDP){ mrsLayerChipSet.addAll(permissionToViewData(MRSlayerChipLists,'MDP')); }
      if(isUserAdmin){ mrsLayerChipSet.addAll(permissionToViewData(MRSlayerChipLists,'SwiftAdmin')); }
      if(isTapeOutCenter){ mrsLayerChipSet.addAll(permissionToViewData(MRSlayerChipLists,'TapeoutCenter')); }
      if(isRMG){ mrsLayerChipSet.addAll(permissionToViewData(MRSlayerChipLists,'RMG')); }   
      if(isTapeoutApp){ mrsLayerChipSet.addAll(permissionToViewData(MRSlayerChipLists,'TapeoutApp')); }   
      
      if(isUserGlobalShuttle || isUserTDTIMPW || isUserMDP || isUserAdmin || isTapeOutCenter || isRMG || isTapeoutApp){
          MRSlayerChipLists.clear();
          MRSlayerChipLists.addAll(mrsLayerChipSet);     
      }     
      
      return MRSlayerChipLists ;
      
    }
    /**
        @Method:permissionToViewData
        @param: List<MRS_Layer_Chip_Association__c> mrsLayerChipList,String pubGroup
        @return: List<MRS_Layer_Chip_Association__c>
        @Description : This method sorts the data according to permission
    **/ 
    public List<MRS_Layer_Chip_Association__c> permissionToViewData(List<MRS_Layer_Chip_Association__c> mrsLayerChipList,String pubGroup){
        List<MRS_Layer_Chip_Association__c> chipsToView = new List<MRS_Layer_Chip_Association__c>();
        Set<String> setJobview = new Set<String>{'Not Required','Not gating mask release'};
        Set<String> setOrderType = new Set<String>{'New Prototype','Retrofit'};
        Double mdpTechGeoCutoff       = Double.valueOf( MRSHandlerUtilityExtn.loadEnvVariable('Swift_MDP_Tech_Geo_Cut_Off','0.022') );
        if(pubGroup == 'SwiftAdmin' || pubGroup == 'TapeoutCenter' || pubGroup == 'TapeoutApp'){
            chipsToView.addAll(mrsLayerChipList);
           
        }
        else if(pubGroup == 'RMG'){
            for(MRS_Layer_Chip_Association__c mrsObj : mrsLayerChipList){
                if(mrsObj.Layer_Chip_Status__c != 'In Progress'){
                    chipsToView.add(mrsObj);
                }
                
            }   
            
        }
        else if(pubGroup == 'MDP'){
            Double techGeo = 0.0;
            for(MRS_Layer_Chip_Association__c mrsObj : mrsLayerChipList){
                if(mrsObj.Tech_Geo__c != null){
                    techGeo = Double.valueOf(mrsObj.Tech_Geo__c.toUppercase().substringBefore('UM').trim());
                }
                if(techGeo <= mdpTechGeoCutoff){
                    chipsToView.add(mrsObj);
                }
            }
            
        }
        else if(pubGroup == 'GlobalShuttle'){
            Double techGeo = 0.0;
            for(MRS_Layer_Chip_Association__c mrsObj : mrsLayerChipList){
                if(mrsObj.Tech_Geo__c != null){
                    techGeo = Double.valueOf(mrsObj.Tech_Geo__c.toUppercase().substringBefore('UM').trim());
                }
                if(techGeo > 0.02 && mrsObj.layer__r.MRS__r.Mask_Set_Title__r.Name.startsWith('MPW')){
                    chipsToView.add(mrsObj);
                }
            }
            
        }
        else if(pubGroup == 'TDTI-MPW'){
            Double techGeo = 0.0;
            for(MRS_Layer_Chip_Association__c mrsObj : mrsLayerChipList){
                if(mrsObj.Tech_Geo__c != null){
                    techGeo = Double.valueOf(mrsObj.Tech_Geo__c.toUppercase().substringBefore('UM').trim());
                }
                if(techGeo <= 0.02 && mrsObj.PTRF__r.MaskSetTitle__r.Name.startsWith('MPW')){
                    chipsToView.add(mrsObj);
                }
            }
            
        }
        
        return chipsToView;
    }
    /**
        @Method:getMRSTblData
        @param: null
        @return: null
        @Description : gets the mrs table
    **/
    public void getMRSTblData()
    { 
       
        mrsWrapperLists.clear();
       
        getMRSLayerChipAssociation();
        
    }
public void getMSTchipLayer(){
    getMRSLayerChipAssociation();
    
    }
public class MRSLayerChipWrapper
{   
    public MRS_Layer_Chip_Association__c mrs {get;set;}
    public String layerId {get; set;}
    public String layerName {get; set;}
    public String layerChipStatus {get; set;}
    public integer count {get;set;}
    public Boolean color {get; private set;}
    public Boolean isChecked {get;set;}
    public String ptrfOrDRTName {get;set;}
    public String ptrfOrDRTId {get;set;}
    public MRSLayerChipWrapper(MRS_Layer_Chip_Association__c mrs, Integer counter, Boolean color, Boolean isChecked){
    this.mrs = mrs;
    this.layerId = mrs.Layer__c;
    this.layerName = mrs.Layer__r.Name;
    this.layerChipStatus = mrs.Layer_Chip_Status__c;
    this.count = counter;
    this.color = color;
    this.isChecked = isChecked;
    if(mrs.PTRF_Or_DRT__c == null || mrs.PTRF_Or_DRT__c == 'PTRF'){
        this.ptrfOrDRTName = mrs.PTRF__r.Name;
        this.ptrfOrDRTId = mrs.PTRF__c;
        }else{
        this.ptrfOrDRTName = mrs.DRT__r.Name;
        this.ptrfOrDRTId = mrs.DRT__c;
            }
        }
    }

 public void anfn_discard(){
 Integer c =1;
    for(MRSLayerChipWrapper mrsWrapperObj :mrsWrapperLists){
        mrsWrapperObj.count = c;
        c++;
        if(!colorOnProceed) {
            mrsWrapperObj.color = true;
            colorOnProceed = true;
            }
        else {
        mrsWrapperObj.color = false;
        colorOnProceed = false;
            }
        mrsWrapperObj.isChecked = false;
        }
        performChipHold = true;
 }
 public void acfn_discardHold(){
 
 }
    /**
        @Method:acfn_refreshTableChip
        @param: null
        @return: null
        @Description : Method saves the data
    **/
 public void acfn_refreshTableChip()
   {
       performChipHold =true;
       mrsWrapperLists.clear();
       getMRSLayerChipAssociation();
       
   }
   

    public String comments {get;set;}
    public String arrPTRFids {get;set;}
    public Boolean isHold{get;set;}
    public String commentIsNull{get;set;}
    public Boolean isChecking{get;set;}
    public void isCheckBoxTrue(){
        if(!isChecking){
        ApexPages.Message notChecked = new ApexPages.Message(ApexPages.Severity.Error,'');                    
        notChecked = new ApexPages.Message(ApexPages.Severity.Error,'No Layer is selected');                    
        ApexPages.addMessage(notChecked);   
        } 
    }
    public void IsCommentBlank(){
    if(commentIsNull == 'commentIsNull'){
        ApexPages.Message comment = new ApexPages.Message(ApexPages.Severity.Error,'');                    
        comment = new ApexPages.Message(ApexPages.Severity.Error,'Please enter Comment');                    
        ApexPages.addMessage(comment);    
        }
    }
    Public void chipLayerUpdateOnProceed(){ 
        mrsWrapperLists.clear();
        List<String> mrsLayerChip = new List<String>(arrPTRFids.split(','));
        List<MRS_Layer_Chip_Association__c> mrsChipIds = [SELECT Id,Layer_Chip_Status__c from MRS_Layer_Chip_Association__c WHERE Id IN :mrsLayerChip];
        
        Notes__c auditProceedComments ;
        List<Notes__c> insertNotesComment = new List<Notes__c>();
        if(mrsChipIds != null){
        for (MRS_Layer_Chip_Association__c m :mrsChipIds){
            if(m.Layer_Chip_Status__c == 'Released' || m.Layer_Chip_Status__c == 'Hold' || m.Layer_Chip_Status__c == 'In Progress'){
            auditProceedComments = new Notes__c();
            auditProceedComments.Body__c = comments;
            auditProceedComments.Category__c = 'Hold Chip';
            auditProceedComments.ParentId__c = m.Id;
            insertNotesComment.add(auditProceedComments);
            
            }
        }
     }  
     if(insertNotesComment!=null){   
        insert insertNotesComment;
         }
         
        List<MRS_Layer_Chip_Association__c> updateMLAChiplayerStatus = new List<MRS_Layer_Chip_Association__c>();
        List<MRS_Layer_Chip_Association__c> mlaToUpdate = [Select Id,Name,Layer__r.MRS__r.Mask_Set_Title__c,Layer__r.MRS__r.Mask_Set_Title__r.name,PTRF__c,PTRF__r.Fab__c,
                                                            PTRF__r.Name,PTRF__r.MaskSetTitle__r.Name,Layer__r.Name,Layer__r.Mask_Layer_Rev__c,Layer__r.ROM_Code__c,
                                                            Layer_Chip_Old_Status__c,Chip_Hold_Warning__c,Layer__c,PTRF__r.Submitter__c,PTRF__r.Submitter__r.isActive,
                                                            PTRF__r.Submitter__r.Portal_Email__c,Layer__r.Layer_Old_Status__c,Layer__r.Layer_Status__c,
                                                            Layer_Chip_Status__c,Tech_Geo__c,LastModifiedBy.Name,Chip__r.Name, PTRF__r.Customer__c,
                                                            
                                                            layer__r.hold_layer_by_user__c//swgp-919 
                                                            
                                                            ,Is_Cancel_After_Off_Hold__c//swgp-950
                                                            
                                                            
                                                            from MRS_Layer_Chip_Association__c WHERE Id IN :mrsLayerChip];
        List<Id> layerIds = new List<Id>();
        List<MRS_Layer_Chip_Association__c> mrsListHold = new List<MRS_Layer_Chip_Association__c>();
        List<MRS_Layer_Chip_Association__c> mrsListResume = new List<MRS_Layer_Chip_Association__c>();      
        for(MRS_Layer_Chip_Association__c m :mlaToUpdate){
            List<Id> mstIds = new List<Id>();
            mstIds.add(m.Layer__r.MRS__r.Mask_Set_Title__c);
            String layerName = m.Layer__r.Name+m.Layer__r.Mask_Layer_Rev__c+ '('+m.Layer__r.ROM_Code__c+')';
            if(isHold){
                if(m.Layer_Chip_Status__c == 'In Progress'){m.Chip_Hold_Warning__c = 'Held without Warning'; } 
                //else if(m.Layer_Chip_Status__c == 'Released'){ m.Chip_Hold_Warning__c = 'Hold Warning Acknowledge'; }
                //this one to be mofidied to: only if layer_status is released >>> log Hold warning ack
                else if(m.layer__r.layer_status__c == 'Released'){ m.Chip_Hold_Warning__c = 'Hold Warning Acknowledge'; }
                m.Layer_Chip_Status__c = 'Hold';
                
                layerIds.add(m.Layer__c);
                
                updateMLAChiplayerStatus.add(m);
                
                mrsListHold.add(m);
                }
             if(!isHold){
                 
                //swgp-950
                //WHEN resume: if was previously cancel but failed due to still being on hold >>> when resume, straight away cancel it
                //else: as normal >>> just resume to release/in progress                
                if(m.Is_Cancel_After_Off_Hold__c) {
                    m.Layer_Chip_Status__c = 'Cancel';
                    m.Is_Cancel_After_Off_Hold__c = false;
                } else { m.Layer_Chip_Status__c = m.Layer_Chip_Old_Status__c; }
                //swgp-950-end
                
                m.Chip_Hold_Warning__c = 'None';
                
                updateMLAChiplayerStatus.add(m);
                
                mrsListResume.add(m);
            }
         }
         if(mrsListHold != null && mrsListHold.size() > 0){            
             sendEmailOnHoldResume(mrsListHold,UserInfo.getuserId(),true,comments); 
         }
         if(mrsListResume != null && mrsListResume.size() > 0){            
             sendEmailOnHoldResume(mrsListResume,UserInfo.getuserId(),false,comments);
             
            //swgp-919
            //check whether layer is still on hold by user
            if(mrsListResume.get(0).layer__r.hold_layer_by_user__c == true) {
                MRSHandlerUtilityExtn.sendPendingHoldResumeEmail_future('Swift_Layer_On_Hold_Warning',new Set<Id>{mrsListResume.get(0).layer__c});
            }
             
         }         
         
        if(updateMLAChiplayerStatus != null) { update updateMLAChiplayerStatus; }
        
        List<Id> updatedLayerChipIds = new List<Id>();
         List<MRS_Layer_Chip_Association__c> mrsListHoldExternal = new List<MRS_Layer_Chip_Association__c>();
        List<MRS_Layer_Chip_Association__c> mrsListResumeExternal = new List<MRS_Layer_Chip_Association__c>();
        for(MRS_Layer_Chip_Association__c m :updateMLAChiplayerStatus){
            updatedLayerChipIds.add(m.Id);
        }
        List<MRS_Layer_Chip_Association__c> updatedLayerChip = [Select Id,Name,Layer__r.MRS__r.Mask_Set_Title__c,PTRF__r.Name,
                                                                Layer__r.Name,Layer__r.Mask_Layer_Rev__c,Layer__r.ROM_Code__c,
                                                                Layer_Chip_Old_Status__c,Chip_Hold_Warning__c,Layer__c,Layer__r.MRS__r.Mask_Set_Title__r.Name,
                                                                Layer_Chip_Status__c,Layer__r.Layer_Status__c,Layer__r.Layer_Old_Status__c,LastModifiedBy.Name,Chip__r.Name,PTRF__r.Maskshop__c,PTRF__r.Fab__c,Customer_Name__c,PTRF__r.MaskSetTitle__r.Name,Layer__r.Mask_Set_Title_Name__c,Layer__r.Tech_Geo__c,PTRF__r.Tech_Geo__c from MRS_Layer_Chip_Association__c 
                                                                WHERE Id IN :updatedLayerChipIds];
        List<Id> mstIds = new List<Id>();
        for(MRS_Layer_Chip_Association__c m :updatedLayerChip){
        mstIds.add(m.Layer__r.MRS__r.Mask_Set_Title__c);
      
        
        
            if(isHold){ mrsListHoldExternal.add(m); }
            if(!isHold){ mrsListResumeExternal.add(m); }        
        }
         if(mrsListHoldExternal!= null && mrsListHoldExternal.size() > 0){ sendEmailOnHoldResumeToExternalGroup(mrsListHoldExternal,mstIds,UserInfo.getuserId(),true,comments); }
         if(mrsListResumeExternal!= null && mrsListResumeExternal.size() > 0){ sendEmailOnHoldResumeToExternalGroup(mrsListResumeExternal,mstIds,UserInfo.getuserId(),false,comments); }
        
        List<MRS_Layer_Association__c> updateLayerAssociation = [SELECT Id,Layer_status__c from MRS_Layer_Association__c Where Id IN :layerIds];
       
        if(updateLayerAssociation!= null){
            for(MRS_Layer_Association__c m :updateLayerAssociation){
                m.layer_status__c = 'Hold';
            }
        }
        update updateLayerAssociation;
        isHoldActive = false;
        isResumeActive = false;
        ValueCatcher = null;
        getMRSLayerChipAssociation();
       
        String recordUpdated = 'The MRS Layer Status has been put on hold successfully';
        
    }
    /**
        @Method:sendEmailOnHoldResume
        @param: List<MRS_Layer_Chip_Association__c> mrsList,Id userId,Boolean isHold,String comments
        @return: null
        @Description : Method sends email internal
    **/
    public void sendEmailOnHoldResume(List<MRS_Layer_Chip_Association__c> mrsList,Id userId,Boolean isHold,String comments){
       
        Double techGeo;
        Boolean mstName = false;
        Boolean isRMG = false;
        Integer counter = 0;
        String chipName = '';
        String layerName = '';
        String subject= '';
        String body = '';

        List<Id> layerIds = new List<Id>();
        
        for(MRS_Layer_Chip_Association__c m : mrsList){
            if(m.Tech_Geo__c != null){ techGeo = double.valueOf(m.Tech_Geo__c.toUpperCase().substringBefore('UM').trim()); }
            if(m.Layer__r.MRS__r.Mask_Set_Title__r.Name.startsWith('MPW')){ mstName = true; }
            if(counter == 0){ chipName = chipName+m.Chip__r.Name; } else { chipName = chipName+', '+m.Chip__r.Name; }
            counter++;
            layerIds.add(m.Layer__c); 
        }
        
        List<MRS_Layer_Association__c> lstMRSLA = new List<MRS_Layer_Association__c>();
        lstMRSLA = [SELECT Id,Name,tech_geo_int__c,LogicalOperation__c,Layer_status__c,Mask_Set_Title_Name__c,ROM_Code__c,Mask_Layer_Rev__c FROM MRS_Layer_Association__c WHERE Id IN :layerIds];

        //EmailTemplate
        EmailTemplate et = new EmailTemplate();
        if(isHold){ et=[Select id,Subject,Body,HtmlValue, DeveloperName from EmailTemplate where DeveloperName=:'Swift_Hold_Mask_Write_for_Layer_Chip']; } else if(!isHold){ et=[Select id,Subject,Body,HtmlValue, DeveloperName from EmailTemplate where DeveloperName=:'Swift_Resume_Mask_Write_for_Layer_Chip']; } 
        
        string DeveloperName = et.DeveloperName;
                   
         List<MRS_Layer_Association__c> lstMLA = new List<MRS_Layer_Association__c>();
        lstMLA.add(lstMRSLA.get(0));
        
        EmailHandlerUtilityPerMST.sendEmailPerMST(DeveloperName ,lstMLA , mrsList,comments);
     
    } 


    /**
        @Method:sendEmailOnHoldResumeToExternalGroup
        @param: List<MRS_Layer_Chip_Association__c> mrsList,List<Id> maskSetTitle,Id userId,Boolean isHold,String comments
        @return: null
        @Description : Method sends email external
    **/
   public void sendEmailOnHoldResumeToExternalGroup(List<MRS_Layer_Chip_Association__c> mrsList,List<Id> maskSetTitle,Id userId,Boolean isHold,String comments){

        Set<Id> setChipIds = new Set<Id>();
         for(MRS_Layer_Chip_Association__c mcp:mrsList){
           setChipIds.add(mcp.id);
         }
        if((oldLayerStatus == 'Released') || (oldLayerStatus == 'Hold' && mrsList.get(0).Layer__r.Layer_Status__c == 'Released')){
          
            EmailTemplate et = new EmailTemplate();
            Set<String> setEmailTemplates = new Set<String>();
            if(isHold){      
                et=[Select id,Subject,Body,HtmlValue,DeveloperName from EmailTemplate where DeveloperName=:'Swift_Hold_Mask_Write_for_Layer_Chip_External_Group']; 
                 setEmailTemplates.add('Swift_Hold_Mask_Write_for_Layer_Chip_External_Group');
            }
            if(!isHold){ et=[Select id,Subject,Body,HtmlValue,DeveloperName from EmailTemplate where DeveloperName=:'Swift_Resume_Mask_Write_for_Layer_Chip_External_Group']; setEmailTemplates.add('Swift_Resume_Mask_Write_for_Layer_Chip_External_Group'); }
            Map<String,PerMaskshopHoldResumeLocals__c> mapChipLocalFields = PerMaskshopHoldResumeLocals__c.getAll();
            Set<String> setChipLocalFields = new Set<String>();
             if(mapChipLocalFields!=null && mapChipLocalFields.size()>0){
               setChipLocalFields.addAll(mapChipLocalFields.keySet());
             }
             Set<String> setChipGlobalFields = new Set<String>();
             Map<string,set<string>> mapChipGlobalFields = EmailSubjectBodyPerMaskshop.createQueryString(setEmailTemplates);
              if(mapChipGlobalFields!=null && mapChipGlobalFields.size()>0){
                 if(isHold){ setChipGlobalFields = mapChipGlobalFields.get('Swift_Hold_Mask_Write_for_Layer_Chip_External_Group'); }
                 if(!isHold){ setChipGlobalFields = mapChipGlobalFields.get('Swift_Resume_Mask_Write_for_Layer_Chip_External_Group'); }
              } 
              
              if(setChipGlobalFields.size()>0){
               setChipLocalFields.addAll(setChipGlobalFields);
              }
              List<String> lstChipAllFields = new List<String>();
              lstChipAllFields.addAll(setChipLocalFields);
              String setFields = String.join(lstChipAllFields,',');
              String Query = '';
              if(setFields!=null && setFields!=''){
               Query = 'SELECT '+setFields+' FROM MRS_Layer_Chip_Association__c where id IN: setChipIds AND layer_chip_status__c != \'Cancel\'';
              }
              List<MRS_Layer_Chip_Association__c> lstMRSLChpAsso = new List<MRS_Layer_Chip_Association__c>();
              lstMRSLChpAsso = Database.query(Query);
              if(lstMRSLChpAsso.size()>0)
              EmailHandlerUtilityPerMaskShop.sendChipEmailPerMaskshop(et,lstMRSLChpAsso,comments);

        }
    }

    public void clearFilter(){
        selectedLayerStatus = '';
        selectedDeviceId = '';
        selectedTechGeo = '';
        getMRSLayerChipAssociation();
    }
}