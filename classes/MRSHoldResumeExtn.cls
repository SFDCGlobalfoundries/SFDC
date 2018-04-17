/*
Type Name:    MRSHoldResumeExtn 
Author:       Cognizant 
Created Date: 28-April-2014
Reason: This is the controller class for Hold Resume Layer Page. 
Change History:

Cognizant            21062014     -      Bug fixing done for defects
Cognizant            29062014     -      Incorporated the Code Review Comments
Cognizant            07072014     -      UAT Defect Fixing
Cognizant            18072014     -      UAT Defect Fixing
Cognizant            15082014     -      UAT Defect Fixing
Cognizant            27082014     -      UAT Defect Fixing
Cognizant            28082014     -      Incorporated the Code Review Comments
*/
public class MRSHoldResumeExtn{
    public string pendingResumeChipMsg {get;set;}//swgp-920
    public list<Account> lstCustomer {get;set;}
    public string selectedCustomer {get;set;}
    public String selectedCustomerName {get;set;}
    public String selectedCustomerId {get;set;}
    public List<SelectOption> lstMSTOptions {get;set;}
    public String selectedMST{get; set;}
    public String selectedMSTName{get;set;}
    public List<SelectOption> lstLayerStatusOptions {get;set;}
    public String selectedLayerStatus{get;set;}
    public List<SelectOption> lstDeviceIdOptions {get;set;}
    public String selectedDeviceId{get; set;}
    public List<SelectOption> lstTechGeoOptions {get;set;}
    public String selectedTechGeo{get; set;}
    public Boolean errorMessage{get;set;}
    public Boolean layerChipSummarTbl {get;set;}
    public Boolean disableApply;
    public String customerSelected{get;set;}
    public String mstSelected{get;set;}
    public Integer countOnProceed {get;set;}
    public Boolean colorOnProceed {get;set;}
    public transient String ValueCatcher {get;set;} {ValueCatcher = '';}
    // for unique values in the Layer status,Device Id and Tech Geo filters
    public Set<String> layerStatus{get;set;} 
    public Set<String> deviceId{get;set;} 
    public Set<String> techGeo{get;set;} 
    public boolean isFilterActive{get;set;}
    public boolean displayButtons{get;set;}
    public List<MRSWrapper> wrapperlst {get;set;}
    public Boolean isSameCustomer {get;set;}{isSameCustomer = true;}
    public Set<String> setLayerStatus {get;set;}
    // variables for Hold released layer warning
    public String warningAlert{get;set;}
    public String mrsLayerIdArray{get;set;}
    public List<String> lstMrsLayerId = new List<String>();
     public list<integer> lstSizeOne {get;set;}
    // Variables for updating Layer Status on clicking Proceed button
    public String mrsLayerIdArrayForStatusUpdate{get;set;}
    public List<String> lstMrsLayerIdForStatusUpdate = new List<String>();
    public Boolean internalView {get;set;} 
    
    // MRS Chip Layer Association list
    public List<MRS_Layer_Chip_Association__c> lstMRSChipLayerAssocObj {get; set;}
    
    public Boolean showLabel {get;set;} 
    public Boolean showLabelMST {get;set;}
    // variables used for enabling or disabling Hold button
    public List<GroupMember> loggedInUserGroup = new List<GroupMember>();
    public Boolean loggedInUserProfile;
    public Boolean enableHoldButton {get; set;}
    public transient List<MRSWrapper> mrsWrapperList{get;set;}
    public Boolean performHold {get ;set;}
    public Boolean holdChipFlg {get ;set;}
    public Boolean isHoldActive {get;set;}
    public Boolean isResumeActive {get;set;}
    public Boolean enableProceedTable {get;set;}
    public Map<String,String> mapMSTIdsToMSTNames;
    public Map<Id,String> account_idmap {get;set;}
    public String customerNameAfterSave {get ;set;}
    public String mstNameAfterSave {get;set;}
    public Map<Id,String> mapLayerAssoToStatus;
    
    //Code Correction Variables
    public Boolean groupTDTIMPW ;
    public Boolean groupGlobalShuttle ;
    public Boolean groupMDP ;
    public Boolean groupSwiftAdmin ;
    public Boolean groupTapeoutCentre ;
    public Boolean groupTapeoutApplication ;
    public Boolean groupTapeoutOperation ;
    public Boolean groupRMG {get;set;}
    public Boolean onlyRMG{get;set;}
    public Boolean groupTapeoutAdmin ;
    public Boolean groupSwiftSupport ;
    public Boolean groupFE ; 
    public Boolean isReleased{get;set;}   
    public List<String> SWIFT_FE_ROLES {get;set;} {  
    Environment_Variable__c tempEnv = [SELECT Value__c FROM Environment_Variable__c WHERE Name = 'SwiftFETeamRoles' LIMIT 1];
     SWIFT_FE_ROLES = String.valueOf(tempEnv.Value__c).split(',');
    }

    public Boolean isCustomer;   
    public User loggedInUser; 
    public Set<String> FinalMSTList {get;set;}
    public Mask_Set_Title__C tempMST;
    public String BASICQUERY = 'SELECT MRS__r.Mask_Set_Title__c,Customer_Frame_Mockup_Date__c,Customer_Frame_Mockup__c,Customer_Frame_Remote_Jobview_Setup_Date__c,Customer_Frame_Remote_Jobview_Setup__c,Customer_GDSOUT_Review_Date__c,Customer_GDSOUT_Review__c,Customer_MEBES_Jobview_Date__c,Customer_MEBES_Jobview__c,Customer_Prime_Remote_Jobview_Setup_Date__c,Customer_Prime_Remote_Jobview_Setup__c,Disapprove_Reason_For_Frame_Mockup_Revie__c,DRW_Date__c,DRW__c,Error_Message_Oracle_DB__c,Foundry_Frame_Mockup_Date__c,Foundry_Frame_Mockup__c,Foundry_Frame_Remote_Jobview_Setup_Date__c,Foundry_Frame_Remote_Jobview_Setup__c,Foundry_GDSOUT_Review_Date__c,Foundry_GDSOUT_Review__c,Foundry_MEBES_Jobview_Date__c,Foundry_MEBES_Jobview__c,Foundry_Prime_Remote_Jobview_Setup_Date__c,Foundry_Prime_Remote_Jobview_Setup__c,Frame_MEBES_Received_Date__c,Frame_MEBES_Received__c,Generated_Mask_Title__c,GlobalShuttle_MEBES_Jobview_Date__c,GlobalShuttle_MEBES_Jobview__c,Hold_Warning__c,Id,Layer_Status_Date__c,Layer_Status__c,Mask_Layer_Rev__c,Mask_Set_Title_Name__c,MDP_MEBES_Jobview_Date__c,MDP_MEBES_Jobview__c,MRS_Layer_Unique_Identifier__c,MRS__c,Name,ORC_Date__c,ORC__c,Prime_MEBES_Received_Date__c,Prime_MEBES_Received__c,Reticle_Type__c,ROM_Code__c,Send_Frame_Data_Date__c,Send_Frame_Data__c,Send_Prime_Data_Date__c,Send_Prime_Data__c,Tapeout_Applications_MEBES_Jobview_Date__c,Tapeout_Applications_MEBES_Jobview__c,Tapeout_Centre_MEBES_Jobview_Date__c,Tapeout_Centre_MEBES_Jobview__c,TDTI_MPW_MEBES_Jobview_Date__c,TDTI_MPW_MEBES_Jobview__c,Tech_Geo__c from MRS_Layer_Association__c where Id in :ChipLayerValues and Layer_Status__c <> \'\'';
    public String MSTIDString {get;set;}
    public List<String> listOfPTRFIDs{get;set;}
    public String WithMPW = 'MPW%';
    public String startsWithMPW = ' AND MaskSetTitle__r.Name LIKE:WithMPW';
    public List<PTRF__c> PTRFList {get;set;}
    public Set<String> MRSChipDetailsId {get;set;}
    
    
    public Set<String> ChipLayerValues {get;set;}
    public transient List<MRS_Layer_Association__c> MRSForDropDowns;
    public transient List<MRS_Layer_Association__c> tempMRSObj;
    public transient List<MRS_Layer_Association__c> masterMRSObj;
    public String LayerIdString{get;set;}
    public List<String> listofLayerIds;
    
    public Boolean noRecords{get;set;}
    public Boolean isSizeExceeded{get;set;}
    
    public void setselectedLayerStatus(String str){
        this.selectedLayerStatus = str;
    }
    public Set<String> PTRFIdWithoutBlankMaskLayerNumber;
    private Integer maxSizeLimit;
    public String lookupCustomerURL {get;set;}
    public String lookupMSTURL{get;set;}
    // Constructor 
    public MRSHoldResumeExtn(ApexPages.StandardController controller){
        isReleased=false;
        noRecords=false;
        listofLayerIds = new List<String>();
        LayerIdString = '';
        MSTIDString = null;
        wrapperlst  = new List<MRSWrapper>();
        List<AggregateResult> aggMST = new List<AggregateResult>();
        internalView = false;
        
        String hostName = ApexPages.currentPage().getHeaders().get('Host');
        if(!String.isBlank(System.Label.Internal_URL) && System.Label.Internal_URL.containsIgnoreCase(hostName)) {
            internalView = true;
            lookupCustomerURL = Label.Swift_VFInternal_URL+'VFCustomerLookupDialog';
            lookupMSTURL = Label.Swift_VFInternal_URL+'VFMaskSetTitleLookupDialog';
        }
        else {
            internalView = false;
            lookupCustomerURL = Label.Swift_VFExternal_URL+'VFCustomerLookupDialog';
            lookupMSTURL = Label.Swift_VFExternal_URL+'VFMaskSetTitleLookupDialog';
        } 
        // intialize variables
        
        groupTDTIMPW = false;
        groupGlobalShuttle = false;
        groupMDP = false;
        groupSwiftAdmin = false;
        groupTapeoutCentre = false;
        groupTapeoutApplication = false;
        groupTapeoutOperation = false;
        groupRMG = false;
        onlyRMG = false;
        groupTapeoutAdmin = false;
        groupSwiftSupport = false;
        groupFE = false;
        isCustomer=false;
        mapLayerAssoToStatus = new Map<Id,String>();
        lstSizeOne = new list<integer>{1}; 
        DRTHandlerUtility drtHandlerUtilityObj = new DRTHandlerUtility();
        mrsWrapperList = new List<MRSWrapper>();
        enableHoldButton = false;
        showLabel = false;
        showLabelMST = false;        
        lstLayerStatusOptions = new List<SelectOption>();
        lstDeviceIdOptions = new List<SelectOption>();
        lstTechGeoOptions = new List<SelectOption>();
        lstMSTOptions = new List<SelectOption>();
        layerStatus = new Set<String>(); // Initializing for populating Layer Status filter
        deviceId = new Set<String>(); // Initializing for populating Device Id filter
        techGeo = new Set<String>(); // Initializing for populating Tech Geo filter
        warningAlert='';
        mrsLayerIdArray ='';
        mrsLayerIdArrayForStatusUpdate ='';
        lstMSTOptions.clear();
        layerChipSummarTbl = false;
        disableApply = false;
        holdChipFlg = false;
        displaybuttons =true;
        isHoldActive = false;
        isResumeActive = false;
        enableProceedTable = false;
        MRSLAYERID = '';
        comments = '';
        layerSummarTbl = false;
        isSizeExceeded = false;
        MRSForDropDowns =  new List<MRS_Layer_Association__c>();
        tempMRSObj =  new List<MRS_Layer_Association__c>();
        masterMRSObj = new List<MRS_Layer_Association__c>();
        mapMSTIdsToMSTNames = new Map<String,String>();
        PTRFIdWithoutBlankMaskLayerNumber = new Set<String>();
        //Judge whether Customer 
        loggedInUser = [Select Id,Profile.Name,AccountId from User WHERE Id =:UserInfo.getuserId()];
          if(String.valueOf(loggedInUser.AccountId) != null && String.valueOf(loggedInUser.AccountId) != ''){
              isCustomer = true;
            }
          else{
               isCustomer = false;
             }
             
        //Retrieve Accounts     
        
        lstCustomer = MRSHandlerUtility.fetchCustomerName();
        
        
        // Retrieve Accounts Ends
        
        if(lstCustomer !=null && !lstCustomer.isEmpty()){
          if(ApexPages.currentPage().getCookies().get('account') ==  null || ApexPages.currentPage().getCookies().get('account').getValue() ==  '' || ApexPages.currentPage().getCookies().get('account').getValue() ==  null){
           
           if(lstCustomer.size()==1){
             
             showLabel = true;
              selectedCustomerId = lstCustomer.get(0).Id;
              selectedCustomerName = lstCustomer.get(0).Name;
              if(lstCustomer.get(0).Short_Name__c != null && lstCustomer.get(0).Short_Name__c != ''){
                selectedCustomerName+= ' ('+String.valueOf(lstCustomer.get(0).Short_Name__c)+')';
              }
              
              // SWGP-241
              String url = ApexPages.currentPage().getHeaders().get('Host');
              if( url.contains(Label.Swift_Host_URL) ) {
                lookupMSTURL= Label.Swift_VFExternal_URL+'VFMaskSetTitleLookupDialog'+'?aid='+selectedCustomerId+'&pg=LayerSummary&jv=false';
              } else {
                lookupMSTURL= Label.Swift_VFInternal_URL+'VFMaskSetTitleLookupDialog'+'?aid='+selectedCustomerId+'&pg=LayerSummary&jv=false';
              }
              // SWGP-241 END  
              
              customerNameAfterSave = selectedCustomerName;
              ClsMyDevices.account = new Cookie('account',selectedCustomerId,null,-1,false);
              ApexPages.currentPage().setCookies(new Cookie[]{ClsMyDevices.account});
              lstMSTOptions.clear();
              getMRSLayerChipSummary();
              
              
             }
          }
          // Account Cookie NOT null
          else{
           
            if(lstCustomer.size()==1){
              showLabel = true;
               
               selectedCustomerId = lstCustomer.get(0).Id;
              selectedCustomerName = lstCustomer.get(0).Name;
              if(lstCustomer.get(0).Short_Name__c != null && lstCustomer.get(0).Short_Name__c != ''){
                selectedCustomerName+= ' ('+String.valueOf(lstCustomer.get(0).Short_Name__c)+')';
              }
              customerNameAfterSave = selectedCustomerName;
              ClsMyDevices.account = new Cookie('account',selectedCustomerId,null,-1,false);
              ApexPages.currentPage().setCookies(new Cookie[]{ClsMyDevices.account});
              String url = ApexPages.currentPage().getHeaders().get('Host');
                if(url.contains(Label.Swift_Host_URL)){
                    lookupMSTURL = Label.Swift_VFExternal_URL+'VFMaskSetTitleLookupDialog?aid='+selectedCustomerId+'&pg=HoldResume&jv=false';
                }
                else {
                    lookupMSTURL = Label.Swift_VFInternal_URL+'VFMaskSetTitleLookupDialog?aid='+selectedCustomerId+'&pg=HoldResume&jv=false';
                }
               if(ApexPages.currentPage().getCookies().get('mst') != null && ApexPages.currentPage().getCookies().get('mst').getValue() != '' && ApexPages.currentPage().getCookies().get('mst').getValue() != null){
                 
                
                   selectedmst = String.valueOf(ApexPages.currentPage().getCookies().get('mst').getValue());
                  
                  if(selectedmst!=null && selectedmst !='')
                  {
                    mstNameAfterSave =[Select Name From Mask_Set_Title__c Where Id = :selectedmst].Name;
                  }
                  if(mstNameAfterSave != null){
                     
                   }
                  
              }
              else{
                   selectedmst = '';
              }
              lstMSTOptions.clear();
              getMRSLayerChipSummary();
            }
            // If lstCustomer != 1
            else{
              
              selectedCustomerId = String.valueOf(ApexPages.currentPage().getCookies().get('account').getValue()); 
              String url = ApexPages.currentPage().getHeaders().get('Host');
                if(url.contains(Label.Swift_Host_URL)){
                    lookupMSTURL = Label.Swift_VFExternal_URL+'VFMaskSetTitleLookupDialog?aid='+selectedCustomerId+'&pg=HoldResume&jv=false';
                }
                else {
                    lookupMSTURL = Label.Swift_VFInternal_URL+'VFMaskSetTitleLookupDialog?aid='+selectedCustomerId+'&pg=HoldResume&jv=false';
                }
               List<Account> acct = new List<Account>();
                    acct = [select Id, Name, Short_Name__c from Account where Id =:selectedCustomerId];
                    
                    if(acct.size()>0 /*&& acct.size()<2*/){
                        selectedCustomerName = String.valueOf(acct.get(0).Name);   
                        if(acct.get(0).Short_Name__c != null && acct.get(0).Short_Name__c != ''){
                            selectedCustomerName+= ' ('+String.valueOf(acct.get(0).Short_Name__c)+')';
                        }  
                        customerNameAfterSave = selectedCustomerName; 
                                      
                    }
                    else{
                        selectedCustomerName = '';
                    }
                    ClsMyDevices.account = new Cookie('account',selectedCustomerId,null,-1,false);
                    ApexPages.currentPage().setCookies(new Cookie[]{ClsMyDevices.account});
                if(ApexPages.currentPage().getCookies().get('mst') != null && ApexPages.currentPage().getCookies().get('mst').getValue() != '' && ApexPages.currentPage().getCookies().get('mst').getValue() != null){
                  
                  selectedmst = String.valueOf(ApexPages.currentPage().getCookies().get('mst').getValue());
                  
                  if(selectedmst!=null && selectedmst !='')
                  {
                    mstNameAfterSave =[Select Name From Mask_Set_Title__c Where Id = :selectedmst].Name;
                  }
                 
                   
            }
            else{
                 selectedmst = '';
            }
            
            lstMSTOptions.clear();
            getMRSLayerChipSummary();    
            }
            
            
          }
        }
        
    }
      // Get CHIP LAYER VALUES to populate Table with Layers
    
      public Set<String> getChipLayerValues(){
        List<AggregateResult> agg = new List<AggregateResult>();
        List<AggregateResult> aggMST = new List<AggregateResult>();
        Set<String> Values = new Set<String>();

       
         if((mstselected != null && mstselected != '') || (selectedMST != '' && selectedMST != null) )
        {                
  
       if(selectedMST != '' && selectedMST != null){
        /** Code added for remembering Customer Name and MST across pages **/
            
            ClsMyDevices.mst = new Cookie('mst',selectedMST,null,-1,false);
            ApexPages.currentPage().setCookies(new Cookie[]{ClsMyDevices.mst});
            
            /** Code added for remembering Customer Name and MST across pages **/  
            
            if(listOfPTRFIDs == NULL)
            {
                listOfPTRFIDs = new List<String>();
            }
            else
            {
                listOfPTRFIDs.clear();
            }
            
            String PTRFQuery = 'select Id from PTRF__c where (Prime_Tapeout__c = true or Frame_Tapeout__c = true) and MaskSetTitle__c =:selectedMST';
            if(!(groupMDP||groupSwiftAdmin||groupTapeoutCentre||groupTapeoutApplication||groupTapeoutOperation||groupRMG||groupSwiftSupport||groupTapeoutAdmin)){
                if(groupGlobalShuttle||groupTDTIMPW){
                    PTRFQuery = PTRFQuery + startsWithMPW;
                }
            }
            
            PTRFList = new List<PTRF__c>();
           
            PTRFList = Database.Query(PTRFQuery);
            
                if(PTRFList != NULL){
                    for (PTRF__c PTRFObj : PTRFList){
                        listOfPTRFIDs.add(String.valueOf(PTRFObj.Id));
                    }
       
                    MRSChipDetailsId = new Set<String>();
                    for (MRS_Chip_Details__c MRSIds : [select Id from MRS_Chip_Details__C where MRS__C in (select Id from MRS__C where Mask_Set_Title__C =:selectedMST)]){
                        MRSChipDetailsId.add(String.valueOf(MRSIds.Id));
                    }
                    if(PTRFIdWithoutBlankMaskLayerNumber!=null)
                      PTRFIdWithoutBlankMaskLayerNumber.clear();
                    else 
                       PTRFIdWithoutBlankMaskLayerNumber = new Set<String>(); 
                    
                    
                    //SWGP-1187: : Performance limit error
                    //****************************************
                    //for(Mask_Layer__c obj : [select Name, Mask_Layer_Number__c, PTRF__c, Tapeout__c from Mask_Layer__c where PTRF__c in:listOfPTRFIDs and Mask_Layer_Number__c not in (null,'','NULL')]){
                    //    PTRFIdWithoutBlankMaskLayerNumber.add(obj.PTRF__c);
                    //}
                    PTRFIdWithoutBlankMaskLayerNumber.addAll(listOfPTRFIDs);
                    //****************************************
                    //swgp-1187-END
                                        
                    
                    agg = [select Layer__c from MRS_Layer_Chip_Association__c where Chip__c in:MRSChipDetailsId and PTRF__C in:PTRFIdWithoutBlankMaskLayerNumber and Customer_Name__c=:selectedCustomerId group by Layer__c LIMIT 50000];
                    for(AggregateResult obj : agg){
                        Values.add(String.valueOf(obj.get('Layer__c')));
                    }
                }
                else{
                    Values.add('');
                }
            }
            else{
                Values.add('');
                ClsMyDevices.mst = new Cookie('mst',null,null,-1,false);
                ApexPages.currentPage().setCookies(new Cookie[]{ClsMyDevices.mst});
            }
        }
        else{
            Values.add('');
            ClsMyDevices.mst = new Cookie('mst',null,null,-1,false);
            ApexPages.currentPage().setCookies(new Cookie[]{ClsMyDevices.mst});
        }
        return Values;    
    }
    
    
    //Retrieve data into the table on clicking the button Apply
     public Boolean isFilterApplied{get;set;}
    // Display Message when no record exists     
     public void displayErrorMsg(){
        
         layerChipSummarTbl=false;
         
         ApexPages.Message noRecord = new ApexPages.Message(ApexPages.Severity.Error,'');                    
         noRecord = new ApexPages.Message(ApexPages.Severity.Info,'No Record exists.');                    
         ApexPages.addMessage(noRecord);
        
     }
    // Table repopulated post applying filters and clicking on Apply 
     public void getMRSTblData()
    {   noRecords=false;
        isHoldActive=false;
        isResumeActive=false;
        layerChipSummarTbl=false;
        
        if(isFilterApplied){
         if(tempMRSObj!=null)
         tempMRSObj.clear();
         if(mrsWrapperList!=null)
         mrsWrapperList.clear();
         if(masterMRSObj!=null)
         masterMRSObj.clear();
        getMRSLayerChipSummary();
        
        }
       
    }
   // Populate Table with Layers selected for Resume/Hold 
    public void displayProceedData(){
        List<MRS_Layer_Association__c> lstLayersToUpdate = new List<MRS_Layer_Association__c>();
        
        if(LayerIdString!=null && LayerIdString!=''){
          listofLayerIds=LayerIdString.split(',');
        }
        if(listofLayerIds!=null && listofLayerIds.size()>0){ 
        lstLayersToUpdate=[SELECT MRS__r.Mask_Set_Title__c,Customer_Frame_Mockup_Date__c,Customer_Frame_Mockup__c,Customer_Frame_Remote_Jobview_Setup_Date__c,Customer_Frame_Remote_Jobview_Setup__c,Customer_GDSOUT_Review_Date__c,Customer_GDSOUT_Review__c,Customer_MEBES_Jobview_Date__c,Customer_MEBES_Jobview__c,Customer_Prime_Remote_Jobview_Setup_Date__c,Customer_Prime_Remote_Jobview_Setup__c,Disapprove_Reason_For_Frame_Mockup_Revie__c,DRW_Date__c,DRW__c,Error_Message_Oracle_DB__c,Foundry_Frame_Mockup_Date__c,Foundry_Frame_Mockup__c,Foundry_Frame_Remote_Jobview_Setup_Date__c,Foundry_Frame_Remote_Jobview_Setup__c,Foundry_GDSOUT_Review_Date__c,Foundry_GDSOUT_Review__c,Foundry_MEBES_Jobview_Date__c,Foundry_MEBES_Jobview__c,Foundry_Prime_Remote_Jobview_Setup_Date__c,Foundry_Prime_Remote_Jobview_Setup__c,Frame_MEBES_Received_Date__c,Frame_MEBES_Received__c,Generated_Mask_Title__c,GlobalShuttle_MEBES_Jobview_Date__c,GlobalShuttle_MEBES_Jobview__c,Hold_Warning__c,Id,Layer_Status_Date__c,Layer_Status__c,Mask_Layer_Rev__c,Mask_Set_Title_Name__c,MDP_MEBES_Jobview_Date__c,MDP_MEBES_Jobview__c,MRS_Layer_Unique_Identifier__c,MRS__c,Name,ORC_Date__c,ORC__c,Prime_MEBES_Received_Date__c,Prime_MEBES_Received__c,Reticle_Type__c,ROM_Code__c,Send_Frame_Data_Date__c,Send_Frame_Data__c,Send_Prime_Data_Date__c,Send_Prime_Data__c,Tapeout_Applications_MEBES_Jobview_Date__c,Tapeout_Applications_MEBES_Jobview__c,Tapeout_Centre_MEBES_Jobview_Date__c,Tapeout_Centre_MEBES_Jobview__c,TDTI_MPW_MEBES_Jobview_Date__c,TDTI_MPW_MEBES_Jobview__c,Tech_Geo__c from MRS_Layer_Association__c where Id in :listofLayerIds];
        }
        enableProceedTable = true;
        
        wrapperlst  = new List<MRSWrapper>();
        Boolean color = true;
        Integer counter = 1;
        Boolean isChecked = false;
        for(MRS_Layer_Association__c lr : lstLayersToUpdate){ 
            if(lr.Layer_Status__c=='Released') 
             isReleased=true;         
            MRSWrapper mrsWrapper = new MRSWrapper(lr,counter,color,isChecked);
            wrapperlst.add(mrsWrapper);
            
            if(!color) {
                color = true;
            }
            else {
                color = false;
            }
            counter++;
            
        } 
        
        if(lstLayersToUpdate!=null && lstLayersToUpdate.size()>0)
         lstLayersToUpdate.clear();
        if(listofLayerIds!=null && listofLayerIds.size()>0)
         listofLayerIds.clear();
        LayerIdString=''; 
     
      
    }
   // Method to repopulate table with Layers after clicking on Discard on the Approval Page 
    public void acfn_discard(){
    layerChipSummarTbl = false;
    noRecords=false;
    isHoldActive=false;
    isResumeActive=false;
    isReleased=false;
    enableProceedTable = false;
    
    wrapperlst.clear();
   if(masterMRSObj!=null)
    masterMRSObj.clear();
   if(tempMRSObj!=null) 
    tempMRSObj.clear();
    if(mrsWrapperList!=null) 
    mrsWrapperList.clear();
    
    getMRSLayerChipSummary();
    
    }
   // Method to repopulate table with Layers after clicking on Discard on the Layer selection page for Resume/Hold
    public void acfn_discardfirst(){
    layerChipSummarTbl = false;
    showLabel = false;
    showLabelMST = false;
    isHoldActive=false;
    isResumeActive=false;
    noRecords=false;
    enableProceedTable = false;
    
    wrapperlst.clear();
   if(masterMRSObj!=null)
    masterMRSObj.clear();
   if(tempMRSObj!=null) 
    tempMRSObj.clear();
    if(mrsWrapperList!=null) 
    mrsWrapperList.clear();
    
    getMRSLayerChipSummary();
    }   
    
    //Function for clearing filters
   public void clearFilters(){
    isFilterActive =true;
    
    enableProceedTable = false;
    wrapperlst.clear();
    Valuecatcher='';
    
    selectedLayerStatus='';
    selectedDeviceId='';
    selectedTechGeo='';
    
    layerChipSummarTbl=false;
    noRecords=false;
    lstLayerStatusOptions.clear();
    layerStatus.clear();
    
    deviceId.clear();
    lstDeviceIdOptions.clear();
    
     techGeo.clear();
    lstTechGeoOptions.clear();
    
    isHoldActive=false;
    isResumeActive=false;
    if(tempMRSObj!=null)
    tempMRSObj.clear();
    if(mrsWrapperList!=null)
    mrsWrapperList.clear();
    if(masterMRSObj!=null)
    masterMRSObj.clear();
    
    getMRSLayerChipSummary();
    }
    
    // Function for capture of the warning message in the MRS Layer Association object
    public void sendHoldWarning(){
    
    }
   // Deprecated method to Hold Layers 
    public void sendMrsLayerId(){
    
    List<MRS_Layer_Association__c> updateMLA = new List<MRS_Layer_Association__c>();
    List<String> lstMrsLayerId = new List<String>(mrsLayerIdArray.split(','));
    
    List<MRS_Layer_Association__c> mla = [Select Id,Layer_Status__c,Hold_Warning__c,LastModifiedBy.Name from MRS_Layer_Association__c WHERE Id IN :lstMrsLayerId];
    for(MRS_Layer_Association__c m :mla){
        m.Hold_Warning__c = 'Hold Warning Acknowledge';
        updateMLA.add(m);         
    }
        if(updateMLA!= null && !updateMLA.isEmpty()){
        update updateMLA;
        
        }
    }
    //populate Mask Set Title on change of customer
public void getMaskSetTitle(){
    // Store customer Name to cookie
    if(selectedCustomerId !=null){
        Account accountObj = [SELECT Name,Id,Short_Name__c FROM Account WHERE Id=:selectedCustomerId];
        String url = ApexPages.currentPage().getHeaders().get('Host');
        if(url.contains(Label.Swift_Host_URL)){
            
            lookupMSTURL = Label.Swift_VFExternal_URL+'VFMaskSetTitleLookupDialog?aid='+selectedCustomerId+'&pg=HoldResume&jv=false';
           
        }
        else {
            lookupMSTURL = Label.Swift_VFInternal_URL+'VFMaskSetTitleLookupDialog?aid='+selectedCustomerId+'&pg=HoldResume&jv=false';
         
        }
        if(accountObj != null){
            selectedCustomerName = accountObj.Name+' ('+accountObj.Short_Name__c+')';
            customerNameAfterSave = accountObj.Name+' ('+accountObj.Short_Name__c+')';
            //------------------Code Added for remember customer name---------------------------//
            ClsMyDevices.account = new Cookie('account',selectedCustomerId,null,-1,false);
            ApexPages.currentPage().setCookies(new Cookie[]{ClsMyDevices.account});
            
            ClsMyDevices.mst = new Cookie('mst',null,null,-1,false);
            ApexPages.currentPage().setCookies(new Cookie[]{ClsMyDevices.mst});

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
    }    
    displaybuttons = false;
    Valuecatcher='';
    lstMSTOptions.clear();
    
    lstLayerStatusOptions.clear();
    layerStatus.clear();
    
    deviceId.clear();
    lstDeviceIdOptions.clear();
    
    techGeo.clear();
    lstTechGeoOptions.clear();
    
    
    noRecords=false;
    layerChipSummarTbl=false;
    /*Ayan Change*/
    
    mstSelected = null;
    mstNameAfterSave = null;
    selectedMST = null;
    /*Ayan Change*/
    
    isHoldActive=false;
    isResumeActive=false;
    
    layerChipSummarTbl = false;
    enableProceedTable = false;
    wrapperlst.clear();
    if(mrsWrapperList!=null)
    mrsWrapperList.clear();
    if(tempMRSObj!=null)
    tempMRSObj.clear();
    if(masterMRSObj!=null)
    masterMRSObj.clear();
    
    getMRSLayerChipSummary();
    
    
} 
    //populate Layer Status on change of Mask Set Title
public void getMSTLayer(){
    // Send Mask set title to cookie
    Mask_Set_Title__c maskSetObj = [SELECT Id,Name FROM Mask_Set_Title__c WHERE Id =:selectedMSTName];
    if(maskSetObj != null){

        mstNameAfterSave = maskSetObj.Name ;
        selectedMST = maskSetObj.id;
      
        ClsMyDevices.mst = new Cookie('mst',String.valueOf(maskSetObj.Id),null,-1,false);
        ApexPages.currentPage().setCookies(new Cookie[]{ClsMyDevices.mst});  
        
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
    
    Valuecatcher='';
    selectedLayerStatus='';
    selectedDeviceId='';
    selectedTechGeo='';
    noRecords=false;
    layerChipSummarTbl = false;
    
    lstLayerStatusOptions.clear();
    layerStatus.clear();
    
    deviceId.clear();
    lstDeviceIdOptions.clear();
    
    techGeo.clear();
    lstTechGeoOptions.clear();
    
    isHoldActive=false;
    isResumeActive=false;
    
    enableProceedTable = false;
   
    wrapperlst.clear();
   if(masterMRSObj!=null)
    masterMRSObj.clear();
   if(tempMRSObj!=null) 
    tempMRSObj.clear();
   if(mrsWrapperList!=null) 
    mrsWrapperList.clear();
    
    getMRSLayerChipSummary();
  
    
}
    //populate Device Id on change of Mask Set Title
public void getMSTdeviceId(){
    
    Valuecatcher='';
    
    selectedLayerStatus='';
    selectedDeviceId='';
    selectedTechGeo='';
    noRecords=false;
    layerChipSummarTbl=false;
    
    lstLayerStatusOptions.clear();
    layerStatus.clear();
    
    deviceId.clear();
    lstDeviceIdOptions.clear();
    
     techGeo.clear();
    lstTechGeoOptions.clear();
    
    isHoldActive=false;
    isResumeActive=false;
    if(mrsWrapperList!=null)
    mrsWrapperList.clear();
    if(masterMRSObj!=null)
    masterMRSObj.clear();
    if(tempMRSObj!=null) 
    tempMRSObj.clear();
    
    
    getMRSLayerChipSummary();
    
}
    //populate Tech Geo on change of Mask Set Title
public void getMSTtechGeo(){
    Valuecatcher='';
    
    selectedLayerStatus='';
    selectedDeviceId='';
    selectedTechGeo='';
    
    layerChipSummarTbl=false;
    noRecords=false;
    lstLayerStatusOptions.clear();
    layerStatus.clear();
    
    deviceId.clear();
    lstDeviceIdOptions.clear();
    
     techGeo.clear();
    lstTechGeoOptions.clear();
    
    isHoldActive=false;
    isResumeActive=false;
    if(masterMRSObj!=null)
    masterMRSObj.clear();
   if(tempMRSObj!=null)
    tempMRSObj.clear();
   if(mrsWrapperList!=null) 
    mrsWrapperList.clear();
    
    getMRSLayerChipSummary();
    
}

    
 // Primary Method for populating Table with Layers with all Group and User level permissions applied   
public void getMRSLayerChipSummary(){
    
    if(Environment_Variable__c.getInstance('MRS_MEBES_RECORD_SIZE_LIMIT').Value__c == '0' || Environment_Variable__c.getInstance('MRS_MEBES_RECORD_SIZE_LIMIT').Value__c == ''){
            maxSizeLimit = 1000;
        }
    else if(Integer.valueOf(Environment_Variable__c.getInstance('MRS_MEBES_RECORD_SIZE_LIMIT').Value__c)<=1000){ 
            maxSizeLimit = Integer.valueOf(Environment_Variable__c.getInstance('MRS_MEBES_RECORD_SIZE_LIMIT').Value__c);  
        }   
    else {
            maxSizeLimit = 1000;
        }
    isSizeExceeded = false;
    String query = '';
 
    // populate filters and table data
    holdChipFlg  = false;
                                               
    if(selectedCustomerId != null){
    List<Account> acc = new List<Account>();
    acc = [Select Name,Short_Name__c from Account Where Id = :selectedCustomerId];
        if(acc.size()>0){
            customerSelected = String.valueOf(acc.get(0).Name)+' ('+acc.get(0).Short_Name__c+')';
        }
        else{
            customerSelected = null;
        }
    }
    
    if(selectedMST != null && selectedmst!=''){
    mstSelected = [Select Name from Mask_Set_Title__c Where Id = :selectedMST].Name;
    }
   
    // Judging User's Group
     
       if([SELECT Team_Role__c, User__c FROM Account_Team_Proxy__c WHERE Team_Role__c IN:SWIFT_FE_ROLES and User__c =:loggedInUser.Id].size()>0){
                groupFE = true;
            }
            else{
                groupFE = false;
            }

      List<GroupMember> grpMember = [SELECT Group.Name,UserOrGroupId FROM GroupMember WHERE UserOrGroupId =: UserInfo.getuserId()];
        if(grpMember!=Null && grpMember.size()>0){
            for(GroupMember gm : grpMember){
                
               
                if(gm.Group.Name == 'Swift GlobalShuttle'){
                    groupGlobalShuttle=true;   
                 }                       
                if(gm.Group.Name == 'Swift TDTI-MPW'){
                    groupTDTIMPW=true; 
                 }
                if(gm.Group.Name =='Swift MDP'){
                    groupMDP=true;
                 }
                
                if(gm.Group.Name =='Swift Tapeout Centre'){
                    groupTapeoutCentre=true; 
                 }
            
                if(gm.Group.Name == 'Swift RMG'){
                    groupRMG=true; 
                 }
                 
                 if(gm.Group.Name == 'SWIFT Admin'){
                    
                    groupSwiftAdmin=true; 
                }
               
                if(gm.Group.Name == 'Swift Tapeout Application'){
                    groupTapeoutApplication=true; 
               }     
            }
        }
          if(groupRMG && (!groupSwiftAdmin && !groupTapeoutCentre && !groupTapeoutApplication && !groupMDP && !groupGlobalShuttle && !groupTDTIMPW && !groupFE && !isCustomer)){
            onlyRMG=true;
            
          }
    // Judging User's Group
    
   // Retrieve customer short name for all the ptrfs 
    if(selectedCustomerId != null && selectedMST != null){ 
        displaybuttons = false;
        
        List<PTRF__c> lstPtrf = [Select Id,MaskSetTitle__c,Customer__r.Short_Name__c from PTRF__c Where MaskSetTitle__c = :selectedMST AND Status__c = 'Perform Tapeout Options'];
        Account acc = [Select Id,Name,Short_Name__c from Account Where Id =:selectedCustomerId];
        isSameCustomer = true;
        if(lstPtrf != null && acc != null){
        for(PTRF__c p :lstPtrf){
        
            if(p.Customer__r.Short_Name__c != acc.Short_Name__c && groupTDTIMPW==false && groupGlobalShuttle==false && groupMDP==false && groupTapeoutCentre==false && groupRMG==false && groupSwiftAdmin==false && groupTapeoutApplication==false){
                isSameCustomer = false;
                
                break;
                }
            }
        } 
    }   
    
   // getMaskSetTitleValues();
    
    ChipLayerValues = getChipLayerValues();
    
     List<String> layerStatusList = new List<String>(); 
     layerStatusList.clear();
     List<AggregateResult> agg = new List<AggregateResult>();
     Set<String> UniqueSet = new Set<String>();
        
     if(ValueCatcher != null && ValueCatcher!=''){
        layerStatusList = ValueCatcher.split(',');
     } 
     
    if(selectedmst != null && selectedmst != '' && !ChipLayerValues.contains(''))
     {
       String ListToString = '';
        for(String s:layerStatusList) {
           ListToString += (ListToString==''?'':',')+s;
        } 
        
       query = BASICQUERY; 
       
       UniqueSet.clear();
        UniqueSet.addAll(layerStatusList);
         
          if (UniqueSet.size()>0 && !UniqueSet.contains(''))
          {
                query += ' and Layer_Status__c in:layerStatusList';
          }
           if(selectedDeviceId!='' && selectedDeviceId!=null){
              query += ' and Id in (select Layer__c from MRS_Layer_Chip_Association__c where PTRF__r.Device_Id__c <> NULL and PTRF__r.Device_Id__c =:selectedDeviceId)';
          }
          if(selectedTechGeo!='' && selectedTechGeo!=null){
              query += ' AND Tech_Geo__c=:selectedTechGeo';
          }
          
          if(MRSForDropDowns!=null){
           if(MRSForDropDowns.size()>0)
            MRSForDropDowns.clear();
          }         
          MRSForDropDowns = Database.Query(BASICQUERY);
          
          if(tempMRSObj!=null){
           if(tempMRSObj.size()>0)
            tempMRSObj.clear();
          } 
          else{
           tempMRSObj = new List<MRS_Layer_Association__c>();
          }          
          if((UniqueSet.size()<1 || UniqueSet.contains('')) && selectedTechGeo == null && selectedDeviceId == null){
            tempMRSObj = MRSForDropDowns;
           }
            else{
            tempMRSObj = Database.Query(query);
           }
           
          if(masterMRSObj!=null) 
           masterMRSObj.clear();
          else
           masterMRSObj = new List<MRS_Layer_Association__c>();
           
        if(isCustomer){
            for(MRS_Layer_Association__c tempMRSLA : tempMRSObj){
            UniqueSet.clear();
            UniqueSet.addAll(layerStatusList);            
                if(UniqueSet.size()>0 && !UniqueSet.contains('')){
                    if(UniqueSet.contains(tempMRSLA.Layer_Status__c)){
                        masterMRSObj.add(tempMRSLA);
                    }
                }
                else{
                        masterMRSObj.add(tempMRSLA);             
                }                
            }
            
        }
        else{
            if((groupTapeoutCentre||groupTapeoutApplication||groupTapeoutOperation||groupRMG||groupSwiftSupport||groupTapeoutAdmin) && !groupSwiftAdmin && !groupFE){
                for(MRS_Layer_Association__c tempMRSLA : tempMRSObj){
                    String TechGeoFormat = '';
                    if(String.valueOf(tempMRSLA.Tech_Geo__c) != '' && String.valueOf(tempMRSLA.Tech_Geo__c) != NULL && String.valueOf(tempMRSLA.Tech_Geo__c) != 'NULL' && !String.valueOf(tempMRSLA.Tech_Geo__c).equalsIgnoreCase('null')){
                        TechGeoFormat = FormatTechGeo(String.valueOf(tempMRSLA.Tech_Geo__c));
                    }
                    UniqueSet.clear();
                    UniqueSet.addAll(layerStatusList);                 
                    if(UniqueSet.size()>0 && !UniqueSet.contains('')){
                        if(UniqueSet.contains(tempMRSLA.Layer_Status__c)){
                                masterMRSObj.add(tempMRSLA);
                        }
                    }
                    else{
                           masterMRSObj.add(tempMRSLA);
                    }
                }
                      
            }
            else{
                if((groupMDP||groupGlobalShuttle||groupTDTIMPW) && !groupSwiftAdmin && !groupFE){
                    if(tempMRSObj.size()>0){
                        //SWGP-347
                        Double mdpTechGeoCutoff       = Double.valueOf( MRSHandlerUtilityExtn.loadEnvVariable('Swift_MDP_Tech_Geo_Cut_Off','0.022') );
                        for(MRS_Layer_Association__c tempMRSLA : tempMRSObj){
                            String TechGeoFormat = '';
                            if(String.valueOf(tempMRSLA.Tech_Geo__c) != '' && String.valueOf(tempMRSLA.Tech_Geo__c) != NULL && String.valueOf(tempMRSLA.Tech_Geo__c) != 'NULL' && !String.valueOf(tempMRSLA.Tech_Geo__c).equalsIgnoreCase('null')){
                                TechGeoFormat = FormatTechGeo(String.valueOf(tempMRSLA.Tech_Geo__c));
                            }
                            UniqueSet.clear();
                            UniqueSet.addAll(layerStatusList);                        
                            if(UniqueSet.size()>0 && !UniqueSet.contains('')){
                                if(UniqueSet.contains(tempMRSLA.Layer_Status__c)){                        
                                    //Globalshuttle can only view PTRFs with Tech Geo greater than 20nm
                                    if(groupGlobalShuttle && TechGeoFormat!=null && TechGeoFormat.toUppercase().contains('UM') && Double.valueOf(TechGeoFormat.toUppercase().substringBefore('UM').trim())>0.02){
                                            masterMRSObj.add(tempMRSLA);  
                                    }
                                    //TDTI-MPW can only view PTRFs with Tech Geo lesser than 20nm
                                    
                                     if((groupTDTIMPW) && TechGeoFormat!=null && TechGeoFormat.toUppercase().contains('UM') && Double.valueOf(TechGeoFormat.toUppercase().substringBefore('UM').trim())<=0.02){
                                            masterMRSObj.add(tempMRSLA);
                                    }
                                    //MDP can only view PTRFs with Tech Geo lesser than 22nm
                                    if((groupMDP) && TechGeoFormat!=null && TechGeoFormat.toUppercase().contains('UM') && Double.valueOf(TechGeoFormat.toUppercase().substringBefore('UM').trim())<=mdpTechGeoCutoff){
                                            masterMRSObj.add(tempMRSLA);
                                    }

                                }
                            }
                            else{
                                //Globalshuttle can only view PTRFs with Tech Geo greater than 20nm
                                if(groupGlobalShuttle && TechGeoFormat!=null && TechGeoFormat.toUppercase().contains('UM') && Double.valueOf(TechGeoFormat.toUppercase().substringBefore('UM').trim())>0.02){
                                        masterMRSObj.add(tempMRSLA);  
                                }
                                //TDTI-MPW can only view PTRFs with Tech Geo lesser than 20nm
                                if((groupTDTIMPW) && TechGeoFormat!=null && TechGeoFormat.toUppercase().contains('UM') && Double.valueOf(TechGeoFormat.toUppercase().substringBefore('UM').trim())<=0.02){
                                        masterMRSObj.add(tempMRSLA);
                                }
                                //MDP can only view PTRFs with Tech Geo lesser than 22nm
                                if((groupMDP) && TechGeoFormat!=null && TechGeoFormat.toUppercase().contains('UM') && Double.valueOf(TechGeoFormat.toUppercase().substringBefore('UM').trim())<=mdpTechGeoCutoff){
                                        masterMRSObj.add(tempMRSLA);
                                }
                            }
                        }
                    }
                }
                else{
                    if(groupSwiftAdmin || groupFE){
                        if(tempMRSObj.size()>0){
                            for(MRS_Layer_Association__c tempMRSLA : tempMRSObj){
                                UniqueSet.clear();
                                UniqueSet.addAll(layerStatusList);
                                if(UniqueSet.size()>0 && !UniqueSet.contains('')){
                                    if(UniqueSet.contains(tempMRSLA.Layer_Status__c)){
                                        masterMRSObj.add(tempMRSLA);
                                    }
                                }
                                else{
                                    masterMRSObj.add(tempMRSLA);
                                }
                            }
                        }
                    }
                    else{
                     if(tempMRSObj.size()>0){
                            for(MRS_Layer_Association__c tempMRSLA : tempMRSObj){
                                UniqueSet.clear();
                                UniqueSet.addAll(layerStatusList);
                                if(UniqueSet.size()>0 && !UniqueSet.contains('')){
                                    if(UniqueSet.contains(tempMRSLA.Layer_Status__c)){
                                        masterMRSObj.add(tempMRSLA);
                                    }
                                }
                                else{
                                    masterMRSObj.add(tempMRSLA);
                              }
                          }
                      }
                  }
                }
            }
        } 
     } 

    if(masterMRSObj != null && !masterMRSObj.isEmpty()){        
        Map<String,MRS_Layer_Association__c> mapMRSChipLayerAssocObj = new Map<String,MRS_Layer_Association__c>();
       
       if(masterMRSObj!=null){  
        if(masterMRSObj.size()<=maxSizeLimit){  
          
          //swgp-1187
          //masterMRSObj = MRSHandlerUtility.sortMaskLayer(PTRFIdWithoutBlankMaskLayerNumber,masterMRSObj);
          masterMRSObj = MRSHandlerUtilityExtn.sortMaskLayer2(PTRFIdWithoutBlankMaskLayerNumber,masterMRSObj);
       } 
      } 
        setLayerStatus = new Set<String>();
        Set<String> setDeviceId = new Set<String>();
        Set<String> setTechGeo = new Set<String>();
        Set<Id> MRSIDSet = new Set<Id>();
         
        
        isHoldActive = false;
        isResumeActive = false;
        
        if(masterMRSObj.size()>0){
            for(MRS_Layer_Association__c temp : masterMRSObj){
              MRSIDSet.add(temp.Id);
            }  
         }         //populate Device Id
        
        //SWGP-1187: need to fix here as well
         //List<AggregateResult> B = [select PTRF__r.Device_id__c from MRS_Layer_Chip_Association__c where Layer__c in:MRSIDSet and PTRF__r.Device_id__c <> NULL and PTRF__r.Device_id__c <> '' group by PTRF__r.Device_id__c LIMIT 50000];
         List<AggregateResult> B = [
            select Device_id__c 
            from ptrf__c 
            where id in :PTRFIdWithoutBlankMaskLayerNumber 
                and Device_id__c <> NULL 
                and Device_id__c <> '' 
                and customer__c = :selectedCustomerId
            group by Device_id__c LIMIT 50000
        ];
            
            for (AggregateResult t: B){
                deviceId.add(String.valueOf(t.get('Device_id__c')));
            }    
                 
        for(MRS_Layer_Association__c mrsObj : masterMRSObj){
         //populate Layer Status
            if(mrsobj.Layer_Status__c!=null && selectedMST !=null && !setLayerStatus.contains(mrsObj.id) && mrsobj.Layer_Status__c!= '')
                 {
                     layerStatus.add(mrsObj.Layer_Status__c);
                 }     
               // setMSTId.add(mrsObj.MRS__r.Mask_Set_Title__c);
                setLayerStatus.add(mrsObj.id);
              
                 //populate Tech Geo
            if(mrsobj.Tech_Geo__c!=null && selectedMST !=null && !setTechGeo.contains(mrsObj.Id))
                 {
                     techGeo.add(mrsObj.Tech_Geo__c);
                 } 
                 setTechGeo.add(mrsobj.Id);
                 
          if(masterMRSObj.size()<=maxSizeLimit){   
           if(!onlyRMG){
            if((mrsObj.Layer_Status__c == 'In Progress' || mrsObj.Layer_Status__c == 'Released') && selectedMST != null){
                if(isSameCustomer){
                 isHoldActive = true;
                }
            }
           }
           else{
             if(mrsObj.Layer_Status__c == 'Released' && selectedMST != null){
                if(isSameCustomer){
                 isHoldActive = true;
                }
            }
           }
           
           if(mrsObj.Layer_Status__c == 'Hold' && selectedMST != null){
                if(isSameCustomer){
                isResumeActive = true;
                }
            }
          
            // put data to map for unique combination of layer and layer status
            String key = mrsObj.id + '-' + mrsObj.Layer_Status__c;
            
            mapMRSChipLayerAssocObj.put(key,mrsObj);
            mapLayerAssoToStatus.put(mrsObj.id,mrsObj.Layer_Status__c);
            
          }  
        }
        
         lstLayerStatusoptions.clear();
        
        Set<String> SetString = new Set<String>();
        SetString.addAll(layerStatus);
         for(String layerSt : SetString)
         {
             if(layerSt != NULL && layerSt != ''){
                 lstLayerStatusoptions.add(new SelectOption(layerSt,layerSt));             
             }
         }
         lstLayerStatusoptions.sort();
         
        lstDeviceIdOptions.clear();
        lstDeviceIdOptions.add(new SelectOption('',''));
         for(String device : deviceId)
         {   
             lstDeviceIdOptions.add(new SelectOption(device,device));
         }
         lstDeviceIdOptions.sort();
         
         lstTechGeoOptions.clear();
         lstTechGeoOptions.add(new SelectOption('',''));
         for(String tech : techGeo)
         {   
            if(tech != null && !tech.containsIgnoreCase('NuLL')){
            String TechGeoFormatted = tech;
            if(!TechGeoFormatted.contains('UM')){
                    TechGeoFormatted +='UM';
            }
            if(TechGeoFormatted != null && !TechGeoFormatted.contains('NULL') && !TechGeoFormatted.contains('nm')){
            Double TechGeoValue = double.valueOf(TechGeoFormatted.toUppercase().substringBefore('UM').trim());
            if(TechGeoValue != null && TechGeoValue<0.1){
                TechGeoFormatted = TechGeoFormatted + ' (' + Integer.valueOf(TechGeoValue*1000) + 'nm)';
                }
            }
            lstTechGeoOptions.add(new SelectOption(tech,TechGeoFormatted));    
        }
            
     }
         lstTechGeoOptions.sort();
        
      if(masterMRSObj.size()<=maxSizeLimit){  
        Boolean color = true;
        Integer counter = 1;
        Boolean isChecked = false;
        mrsWrapperList = new List<MRSWrapper>();
        for(MRS_Layer_Association__c key : masterMRSObj){ 
                       
            MRSWrapper mrsWrapper = new MRSWrapper(key,counter,color,isChecked);
           
            mrsWrapperList.add(mrsWrapper);
            
            if(!color) {
                color = true;
            }
            else {
                color = false;
            }
            counter++;
            
        }
        if(mrsWrapperList!=null && mrsWrapperList.size()>0){
           layerChipSummarTbl = true;
         }
        
                
        for(MRSWrapper  wrapperObj : mrsWrapperList)
        {
            if(wrapperObj.layerStatus =='Released')
            {
                break;
            }else
            {
                holdChipFlg =false;
            }
        }
       }
    }
    else{  
           noRecords=true;
           layerChipSummarTbl = false;
         
         
    } 
    if(masterMRSObj!=null){  
     if(masterMRSObj.size()<=maxSizeLimit){    
        chkLayerStatus();   
     }
    } 
    if(masterMRSObj!=null){
     if(masterMRSObj.size()>maxSizeLimit){
       isSizeExceeded = true;
     }
    } 
    
 }
    //Enable hold button based on layer status...
    public void chkLayerStatus(){
            // initialize hold button flag
            
            enableHoldButton = false;
            loggedInUserProfile = false;
            
            User loggedInUser = [Select Id,Profile.Name,AccountId from User WHERE Id =:UserInfo.getuserId()];
            
            if(loggedInUser.AccountId == null){
            List<Group> grp = [SELECT Id,Name FROM Group WHERE Name IN ('Swift GlobalShuttle','Swift TDTI-MPW','Swift Tapeout Centre','Swift Tapeout Application','Swift MDP')];
            List<GroupMember> grpMember = [SELECT Group.Name,UserOrGroupId FROM GroupMember WHERE UserOrGroupId =: loggedInUser.Id];
            
            if(grpMember!=Null && grpMember.size()>0){
                for(GroupMember gm : grpMember){
                    if(gm.Group.Name =='Swift GlobalShuttle' || gm.Group.Name =='Swift TDTI-MPW' || gm.Group.Name =='Swift Tapeout Centre'|| 
                      gm.Group.Name  =='Swift Tapeout Application' || gm.Group.Name  =='Swift MDP' || gm.Group.Name =='SWIFT Admin' ||
                      gm.Group.Name  =='Swift Foundry Jobviewer' || gm.Group.Name  =='Swift Tapeout Admin' || gm.Group.Name  =='Swift RMG')
                    {
                        loggedInUserGroup.add(gm);    
                    }
                 }
            }
      /*      if(loggedInUser.Profile.Name == 'GF FAE/FTS'){
                loggedInUserProfile = true;
                
            }    */
        }        
      //      Profile Pr = [SELECT Id,Name FROM Profile WHERE Name = 'GF FAE/FTS'];
          if(mrsWrapperList!=null && mrsWrapperList.size()>0){  
            for(MRSWrapper wrapperObj : mrsWrapperList) {
                
                String layerStatus = wrapperObj.mrs.Layer_Status__c;
                
                if(layerStatus!= null && loggedInUserProfile!= null){
                    if((layerStatus == 'In Progress' || layerStatus == 'Released' || layerStatus == 'Hold') && (loggedInUserGroup.size()>0 || groupFE  || loggedInUser.AccountId != null)) {
                        enableHoldButton = true;
                        
                        break;
                    }
                }
            }
         }   
    }
    
   // Wrapper Class for holding Table Data elements
       
     public class  MRSWrapper
    {   
        public MRS_Layer_Association__c mrs {get;set;}
        public String layerId {get; set;}
        public String layerName {get; set;}
        public String layerStatus {get; set;}
        public integer count {get;set;}
        public Boolean color {get; private set;}
        public Boolean isChecked {get;set;}
        public String MaskLayerName {get;set;}
        
        
        public MRSWrapper(MRS_Layer_Association__c mrs, Integer counter, Boolean color, Boolean isChecked){
            this.mrs = mrs;
            this.layerId = mrs.id;
            this.layerName = mrs.Name;
            this.layerStatus = mrs.Layer_Status__c;
           
            this.count = counter;
            this.color = color;
            this.isChecked = isChecked;
            
            if((mrs.Mask_Layer_Rev__c == null || mrs.Mask_Layer_Rev__c.equalsIgnoreCase('NULL')
              || mrs.Mask_Layer_Rev__c == '####')
              && (mrs.ROM_Code__c == null || mrs.ROM_Code__c.equalsIgnoreCase('NULL')
              || mrs.ROM_Code__c == '####'))
              {
            this.MaskLayerName = mrs.Name;
            }
            else if((mrs.Mask_Layer_Rev__c == null || mrs.Mask_Layer_Rev__c.equalsIgnoreCase('NULL')
              || mrs.Mask_Layer_Rev__c == '####')
              &&(mrs.ROM_Code__c != null || !mrs.ROM_Code__c.equalsIgnoreCase('NULL')
              || mrs.ROM_Code__c != '####')){
              this.MaskLayerName = mrs.Name+'('+mrs.ROM_Code__c+')';
              }
            else if(((mrs.Mask_Layer_Rev__c != null || mrs.Mask_Layer_Rev__c != '####'
              || !mrs.Mask_Layer_Rev__c.equalsIgnoreCase('NULL')))
              &&((mrs.ROM_Code__c == null || mrs.ROM_Code__c == '####'
              || mrs.ROM_Code__c.equalsIgnoreCase('NULL')))){
              this.MaskLayerName = mrs.Name+mrs.Mask_Layer_Rev__c;
              }  
            else if((mrs.Mask_Layer_Rev__c != null || !mrs.Mask_Layer_Rev__c.equalsIgnoreCase('NULL')
              || mrs.Mask_Layer_Rev__c != '####')
              &&(mrs.ROM_Code__c != null || !mrs.ROM_Code__c.equalsIgnoreCase('NULL')
              || mrs.ROM_Code__c != '####')){
              this.MaskLayerName = mrs.Name+mrs.Mask_Layer_Rev__c+'('+mrs.ROM_Code__c+')';
              }
             else{
             this.MaskLayerName = mrs.Name+mrs.Mask_Layer_Rev__c+'('+mrs.ROM_Code__c+')';
             }   
        }
    }
    
    // Exporting Table Data into Excel
    public PageReference exportToCSV()
        {   
            if(masterMRSObj!=null)
              masterMRSObj.clear();
            if(tempMRSObj!=null) 
              tempMRSObj.clear();
            if(mrsWrapperList!=null) 
              mrsWrapperList.clear();
    
              getMRSLayerChipSummary();
            PageReference page =null;
            if(mrsWrapperList!=null && layerChipSummarTbl!=null)
            {
             
               page =new PageReference('/apex/VFMRSResumeHoldExcel');
            }else{
               page =null;
            }
            return page;
        }
    // Exporting Table Data into CSV    
       public PageReference exportToPDF()
       {    
            if(masterMRSObj!=null)
              masterMRSObj.clear();
            if(tempMRSObj!=null) 
              tempMRSObj.clear();
            if(mrsWrapperList!=null) 
              mrsWrapperList.clear();
    
              getMRSLayerChipSummary();
            PageReference page =null;
            if(mrsWrapperList!=null && layerChipSummarTbl!=null)
            {
                page =new PageReference('/apex/VFMRSResumeHoldCSV');
               
            }else{
               page =null;
            }
            return page;
       }
     // Method to populate Table with Checkboxes for Resume/Hold action against Layers    
       public void refreshTable()
       {   noRecords=false;
           showLabel = true;
           showLabelMST = true;
           layerChipSummarTbl=false;
           
           holdChipFlg  =false;
           performHold =true;
           if(masterMRSObj!=null)
           masterMRSObj.clear();
           if(tempMRSObj!=null)
           tempMRSObj.clear();
           if(mrsWrapperList!=null)
           mrsWrapperList.clear();
           getMRSLayerChipSummary();
           
           //swgp-920
           pendingResumeChipMsg = null;//reset warning msg
           
       } 
    
        public String comments{get;set;}
        public String MRSLAYERID {get;set;}
        public String recordUpdated{get;set;}
        public Boolean layerSummarTbl{get;set;}
        public Boolean isHold{get;set;}
        public String commentIsNull{get;set;}
        public Boolean isChecking{get;set;}
        //Method to display Error message when User clicks on Proceed without selecting even a single Layer for Hold/Resume action
        public void isCheckBoxTrue(){
            if(!isChecking){
            
            ApexPages.Message notChecked = new ApexPages.Message(ApexPages.Severity.Error,'');                    
            notChecked = new ApexPages.Message(ApexPages.Severity.Info,'No layer is selected');      
            ApexPages.addMessage(notChecked);   
            } 
        }
       // Method to display error message when user clciks on final Proceed button on the Approval Page without putting a comment 
        public void IsCommentBlank(){
        if(commentIsNull == 'commentIsNull'){
            ApexPages.Message comment = new ApexPages.Message(ApexPages.Severity.Error,'');                    
            comment = new ApexPages.Message(ApexPages.Severity.Info,'Please enter comment');
            ApexPages.addMessage(comment);    
            }
        }
        // Method to update layer status after approval and final proceed
          Public void layerStatusUpdateOnProceed(){
           if(mrsWrapperList!=null)
            mrsWrapperList.clear();
            layerChipSummarTbl=false;
            noRecords=false;
            showLabel = false;
            showLabelMST = false;
            List<String> MrsLayerIds = new List<String>(MRSLAYERID.split(','));
            
            Notes__c auditProceedComments ;
            List<Notes__c> insertNotesComment = new List<Notes__c>();
            if(MrsLayerIds != null){
             for (String m :MrsLayerIds){
                auditProceedComments = new Notes__c();
                auditProceedComments.Body__c = comments;
                auditProceedComments.MRS_Layer_Association__c = m;
                insertNotesComment.add(auditProceedComments);
                
                
            }
         }     
            insert insertNotesComment;
            List<MRS_Layer_Association__c> updateMLAlayerStatus = new List<MRS_Layer_Association__c>();
            //swgp-920: include the roll up, and other field which are being used in MRSHandlerUtilityExtn.sendPendingHoldResumeEmail 
            List<MRS_Layer_Association__c> mlaToUpdate = [Select Id,Name,Mask_Layer_Rev__c,ROM_Code__c,Mask_Set_Title_Name__c,Layer_Status__c,MRS__r.Mask_Set_Title__c,MRS__r.Mask_Set_Title__r.Name,
                                                          Layer_Old_Status__c,Hold_Warning__c,Tech_Geo__c,LastModifiedBy.Name,tech_geo_int__c,LogicalOperation__c,
                                                          hold_by__c,  Count_Hold_Chip__c
                                                          from MRS_Layer_Association__c WHERE Id IN :MrsLayerIds];
            List<MRS_Layer_Association__c> mrsListHold = new List<MRS_Layer_Association__c>();
            List<MRS_Layer_Association__c> mrsListResume = new List<MRS_Layer_Association__c>(); 
            
            if(!isHold){
                List<MRS_Layer_Chip_Association__c> mrsLayerChipList = [SELECT Id,Chip_Name__c, Customer_GDSOUT_Review__c,Foundry_GDSOUT_Review__c,Customer_Frame_Mockup__c,Foundry_Frame_Mockup__c,Send_Prime_Data__c,Send_Frame_Data__c,
                                                                        DRW__c,ORC__c,Customer_Prime_Remote_Jobview_Setup__c,Foundry_Prime_Remote_Jobview_Setup__c,Customer_Frame_Remote_Jobview_Setup__c,Foundry_Frame_Remote_Jobview_Setup__c,Prime_MEBES_Received__c,
                                                                        Frame_MEBES_Received__c,Customer_MEBES_Jobview__c,Foundry_MEBES_Jobview__c,GlobalShuttle_MEBES_Jobview__c,MDP_MEBES_Jobview__c,Tapeout_Applications_MEBES_Jobview__c,
                                                                        Tapeout_Centre_MEBES_Jobview__c,TDTI_MPW_MEBES_Jobview__c,Layer_Chip_Status__c,Layer__c FROM MRS_Layer_Chip_Association__c WHERE Layer__c IN :MrsLayerIds LIMIT 50000];
                
                Map<String,List<MRS_Layer_Chip_Association__c>> layerChipMap = new Map<String,List<MRS_Layer_Chip_Association__c>>();
                Map<String,List<MRS_Layer_Chip_Association__c>> layerChipMapVoidCancel = new Map<String,List<MRS_Layer_Chip_Association__c>>();// TASK-2141
                
                for(MRS_Layer_Chip_Association__c layerChipObj : mrsLayerChipList){
                    if(layerChipObj.Layer_Chip_Status__c!='Cancel' && layerChipObj.Layer_Chip_Status__c!='Void'){
                        if(layerChipMap.get(layerChipObj.Layer__c) == null){
                            layerChipMap.put(layerChipObj.Layer__c,new List<MRS_Layer_Chip_Association__c>());
                        }
                        layerChipMap.get(layerChipObj.Layer__c).add(layerChipObj);
                    }
                    // TASK-2141                   
                    if(layerChipMapVoidCancel.get(layerChipObj.Layer__c) == null){
                        layerChipMapVoidCancel.put(layerChipObj.Layer__c,new List<MRS_Layer_Chip_Association__c>());
                    }
                    layerChipMapVoidCancel.get(layerChipObj.Layer__c).add(layerChipObj);                    
                    // END TASK-2141
                }
                
                for(MRS_Layer_Association__c m :mlaToUpdate){
                    m.Layer_Status__c = 'In Progress';
                }

                // TASK-2141
                List<MRS_Layer_Association__c> tempmlaToUpdate = new List<MRS_Layer_Association__c>();
                tempmlaToUpdate = MRSHandlerUtility.calculateLayerStatus(mlaToUpdate,layerChipMap); 
                if(tempmlaToUpdate.size()>0){
                    mlaToUpdate.clear();
                    mlaToUpdate.addAll(tempmlaToUpdate);    
                }else{                            
                    mlaToUpdate = MRSHandlerUtility.setLayerStatusForVoidCancelStatus(mlaToUpdate,layerChipMapVoidCancel);
                }            
                // TASK-2141                
            }
            
            //swgp-920
            list<String> pendingResumeMsg = new list<String>();
            list<mrs_layer_association__c> listTargetLayers = new list<mrs_layer_association__c>();
            //end-swgp-920
            
            for(MRS_Layer_Association__c m :mlaToUpdate){
                List<Id> mstIds = new List<Id>();
                mstIds.add(m.MRS__r.Mask_Set_Title__c);
                String layerName = m.Name+m.Mask_Layer_Rev__c+'('+m.ROM_Code__c+')';

                if(isHold){
                    isHoldActive =false;
                    isResumeActive=true;
                    
                    m.Layer_Status__c = 'Hold';
                    
                    //swgp-919
                    //set user whom hold the layer: Hold_By__c
                    m.Hold_By__c = UserInfo.getUserId();
                    m.Hold_Layer_By_User__c = true;
                    //---------------
                    
                    if(mapLayerAssoToStatus.get(m.id)!=null && mapLayerAssoToStatus.get(m.id)!='' && mapLayerAssoToStatus.get(m.id)=='Released' )
                     m.Hold_Warning__c = 'Hold Warning Acknowledge';
                    else if(mapLayerAssoToStatus.get(m.id)!=null && mapLayerAssoToStatus.get(m.id)!='' && mapLayerAssoToStatus.get(m.id)!='Released' )
                     m.Hold_Warning__c = 'Held without Warning';
                    updateMLAlayerStatus.add(m);
                    
                    mrsListHold.add(m);
                    
                }

                if(!isHold){
                    isHoldActive =true;
                    isResumeActive=false;
                    
                   if(m.Layer_Status__c != 'Hold') 
                    m.Hold_Warning__c = 'None';
                    
                    //swgp-919
                    //reset user whom hold the layer: Hold_By__c
                    m.Hold_By__c = null;
                    m.Hold_Layer_By_User__c = false;
                    //---------------
                    
                    //swgp-920
                    //check for the roll-up Count_Hold_Chip__c
                    //if Count_Hold_Chip__c > 0
                    //>>> extract layerNumber-rev to a set
                    //later out of loop >>> send email 
                    if(null != m.Count_Hold_Chip__c && m.Count_Hold_Chip__c > 0) {
                        pendingResumeMsg.add(m.name + m.mask_layer_rev__c);
                        listTargetLayers.add(m);
                    }
                    
                    updateMLAlayerStatus.add(m);
                    
                   if(m.Layer_Status__c != 'Hold')
                    mrsListResume.add(m);
                    
                }
                
            }
            if(updateMLAlayerStatus != null){
            update updateMLAlayerStatus;
            }
             if(mrsListHold != null && mrsListHold.size() > 0){            
                 sendEmailOnHoldResume(mrsListHold,true,comments); 
             }
             if(mrsListResume != null && mrsListResume.size() > 0){            
                 sendEmailOnHoldResume(mrsListResume,false,comments); 
             }   
            
            
            //Display updated table after proceed
            isReleased=false;
            enableProceedTable = false;
            wrapperlst.clear();
            Valuecatcher='';
    
    selectedLayerStatus='';
    selectedDeviceId='';
    selectedTechGeo='';
    
   
    
    lstLayerStatusOptions.clear();
    layerStatus.clear();
    
    deviceId.clear();
    lstDeviceIdOptions.clear();
    
     techGeo.clear();
    lstTechGeoOptions.clear();
    
    isHoldActive=false;
    isResumeActive=false;
   if(masterMRSObj!=null) 
    masterMRSObj.clear();
    if(tempMRSObj!=null) 
    tempMRSObj.clear();
   if(mrsWrapperList!=null) 
    mrsWrapperList.clear();

            getMRSLayerChipSummary();
            
            //swgp-920
            if(!pendingResumeMsg.isEmpty()) {
                Environment_Variable__c msg = Environment_Variable__c.getInstance('SWIFT_Pending_Resume_Chip');                
                pendingResumeChipMsg = msg.value__c.replace('<LAYER_IDENTIFIER>', String.join(pendingResumeMsg, ','));
                //trigger email from here
                user usr = [select id,email from user where id = :UserInfo.getUserId()];
                MRSHandlerUtilityExtn.sendPendingHoldResumeEmail('Swift_Layer_On_Hold_Pending_Layer_Chip_Warning', new list<String>{usr.email}, listTargetLayers);
            }
            //end-swgp-920
          }
    
    // Method to send email to stakeholders after Layer(s) being released/held    
       public void sendEmailOnHoldResume(List<MRS_Layer_Association__c> mrsList,Boolean isHold,String comments){
            EmailTemplate et = new EmailTemplate();
            Set<String> setEmailTemplates = new Set<String>();
             
             if(isHold){      
               et=[Select id,Subject,Body,HtmlValue,DeveloperName from EmailTemplate where DeveloperName=:'Swift_Hold_Mask_Write_for_Layer'];
                setEmailTemplates.add('Swift_Hold_Mask_Write_for_Layer'); 
             }
             if(!isHold){
               et=[Select id,Subject,Body,HtmlValue,DeveloperName from EmailTemplate where DeveloperName=:'Swift_Resume_Mask_Write_for_Layer'];
                setEmailTemplates.add('Swift_Resume_Mask_Write_for_Layer');
             }
             Map<String,PerMaskshopHoldResumeLocals__c> mapChipLocalFields = PerMaskshopHoldResumeLocals__c.getAll();
             Set<String> setChipLocalFields = new Set<String>();
             if(mapChipLocalFields!=null && mapChipLocalFields.size()>0){
               setChipLocalFields.addAll(mapChipLocalFields.keySet());
             }
           
             Set<String> setChipGlobalFields = new Set<String>();
             Map<string,set<string>> mapChipGlobalFields = EmailSubjectBodyPerMaskshop.createQueryString(setEmailTemplates);
              if(mapChipGlobalFields!=null && mapChipGlobalFields.size()>0){
                 if(isHold){
                   setChipGlobalFields = mapChipGlobalFields.get('Swift_Hold_Mask_Write_for_Layer');
                 }
                 if(!isHold){
                   setChipGlobalFields = mapChipGlobalFields.get('Swift_Resume_Mask_Write_for_Layer');
                 }
              } 
              
              if(setChipGlobalFields.size()>0){
               setChipLocalFields.addAll(setChipGlobalFields);
              }
              
              List<String> lstChipAllFields = new List<String>();
              lstChipAllFields.addAll(setChipLocalFields);
              String setFields = String.join(lstChipAllFields,',');
              String Query = '';
              if(setFields!=null && setFields!=''){
               Query = 'SELECT '+setFields+' FROM MRS_Layer_Chip_Association__c where Layer__c IN: mrsList AND layer_chip_status__c != \'Cancel\'';
              }
              
             
               List<MRS_Layer_Chip_Association__c> lstMRSLChpAsso = Database.query(Query);
             
             EmailHandlerUtilityPerMaskShop.sendEmailPerMaskshop(et,mrsList,lstMRSLChpAsso,comments,mapLayerAssoToStatus,true);

           // send out email notification after Layers are Held or Resumed - Ends     
        }   
    
    // Method to Trim Tech Geo into accepted format    
      public String FormatTechGeo(String str){       
        String TechGeoFormatted = str;
        Double TechGeoValue;
        if(str != '' && str != NULL){
            if(!TechGeoFormatted.toUppercase().contains('UM')){
                TechGeoFormatted +='UM';
            }
            if(TechGeoFormatted != NULL && !TechGeoFormatted.equalsIgnoreCase('NULL') && TechGeoFormatted != '' && !TechGeoFormatted.toLowercase().contains('nm') && TechGeoFormatted.toUppercase().substringBefore('UM').trim() != null){
                TechGeoValue = double.valueOf(TechGeoFormatted.toUppercase().substringBefore('UM').trim());
                if(TechGeoValue != NULL && TechGeoValue<0.1){
                    TechGeoFormatted = TechGeoFormatted + ' (' + Integer.valueOf(TechGeoValue*1000) + 'nm)';
                }
            }
        }
        else{
            TechGeoFormatted = '';
        }
        return TechGeoFormatted;    
    }
  }