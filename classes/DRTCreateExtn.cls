/*
Author: Cognizant Technology Solutions
Company: 
Description:    This will be the controller class behind the Visualforce Page VFDRTCreate.
                This will also call the handler class DRTHandlerUtility which will contain
                all the business logic regarding the DRT Creation process. 
History:
    Cognizant     18032014     - Initial Version
    Cognizant     23032014     - Modified function saveFrameDRT change in save logic
    Cognizant     10052014     - Modified function populateChipDetails for null checking
*/


global class DRTCreateExtn {
    
    //swgp-269
    public boolean hasShippedLayer {get;set;}//a flag to check at page load whether any shipped layer or not
   
    public List<SelectOption> accountOptions {get; set;} // account options
    public List<SelectOption> drtTypeOptions{get; set;} // drt type options
    public List<SelectOption> mstOptions{get; set;} // mst options
    public List<String> techGeoList{get; set;} // tech geo options
    public String selectedAccount {get; set;} //selected Customer Account
    public String selectedAccountName { get; private set;} // selected Account Name
    public String baseMST {get; set;} // base MST
    public String baseMSTName { get; set;} // base MST Name
    public String selectedDrtType {get; set;} // DRT type
    public String selectedTechGeo {get; set;} // Tech geo
    public String description {get; set;} // description
    public String drtName {get; set;}
   
    public List<MainTableWrapper> mainTableList {get; private set;}
    public List<MaskLayerRow> maskLayerList {get; private set;}
    public String addRowMSTString {get; private set;}
    public String selectedMaskLayerJSON {get; set;}
    public List<DRTHandlerUtility.MaskLayerWrapper> lstSelectedMaskLayer {get; set;}
    public list<DRTHandlerUtility.ChipWrapper> mainTableChipList {get;set;}
    public string mainTableChipListJSON {get;set;}
    public transient map<string,map<string,DRTHandlerUtility.MaskRevROMCodeWrapper>> mapDisplayedMaskLayerData {get;set;}
    public list<Integer> lstSizeOne {get;set;}
    
    public String mainTableJSON{get; set;}
    public String maskLayerHeaderJSON{get; set;}
    public String maskLayerContentJSON{get; set;}   
    public String frameTableJSON {get; set;}
   
    public Boolean showTechGeo {get; private set;}
    public Boolean showAsLabel {get; private set;}
    public Boolean mainTableListVisible {get; private set;}
    
   
    private Map<String,String> mstMap {get; private set;}
    @TestVisible private Map<String,String> acctIdNameMap;
    public Boolean internalView {get;set;}
   
    public Boolean selectedAccountBlank {get; private set;}
    public Boolean baseMSTBlank {get; private set;}
    public Boolean selectedDrtTypeBlank {get; private set;}
    public Boolean proceedActionValid {get; private set;}
    
    public String drtCreateErrorMsg {get; private set;}
    public String mainTableErrorJSON {get;  set;}
    public String maskLayerErrorJSON {get; set;}
    public String maskLayerContentErrorJSON {get; set;}
    public String frameTableErrorJSON {get; set;}
    public list<string> lstDRTErrorMessage {get;  set;}
    public string noLayerAvailableErrorMsg {get;set;} 
    
    private DRTHandlerUtility objDRTHandlerUtility;
    
    private Set<String> setDrtTypeOptions;
    private Set<String> setTechGeo;
    
    public static map<string,chip_detail__c> mapChipName;
    public list<Mask_Layer__c> lstPopulatedMaskLayers;
    
    private integer layerCount {get;set;} // global count of added layer to prevent duplicate html id
    
    public boolean isGFEmployee{
        get{
            return DRTHandlerUtility.isGFEmployee(UserInfo.getUserId());
        }
    }
    
    public boolean notSendEmail{//determine if an email should be sent to customer when a DRT is activated
        get{
            if(notSendEmail==null) notSendEmail = false;//default
            return notSendEmail;
        }
        set;
    }
    
    /**
    * @description: This is the constructor
    * @param: ApexPages.StandardController controller
    * @return: none
    **/
    public DRTCreateExtn(ApexPages.StandardController controller) {
        // inilialize variables
        mainTableList = new List<MainTableWrapper>();
        mstMap = new Map<String,String>();
        maskLayerList = new List<MaskLayerRow>();
        setTechGeo = new Set<String>();
        showAsLabel = false;
        showTechGeo = false;
        mainTableListVisible = false;
        lstSizeOne = new list<Integer>{1};
        setDrtTypeOptions = new Set<String>();
        lstDRTErrorMessage = new List<String>();
        lstPopulatedMaskLayers = new list<Mask_Layer__c>();
        lstSelectedMaskLayer = new list<DRTHandlerUtility.MaskLayerWrapper>();
        layerCount = 0;
        // instantiating handler utility class
        objDRTHandlerUtility = new DRTHandlerUtility();
        // popualte accounts
        populateAccountOptions();
        internalView = false;
        String hostName = ApexPages.currentPage().getHeaders().get('Host');
        if(!String.isBlank(System.Label.Internal_URL) && System.Label.Internal_URL.containsIgnoreCase(hostName)) {
            internalView = true;
        }
        else {
            internalView = false;
        }
        
        selectedAccountBlank = false;
        baseMSTBlank = false;
        selectedDrtTypeBlank = false;
        proceedActionValid = true;
    }
   
    /**
    * @description: This method populates the account dropdown
    * @param: none
    * @return: none
    **/
    public void populateAccountOptions() {
        List<Account> accountList = objDRTHandlerUtility.fetchCustomerName();
        if(accountOptions == null) {
            accountOptions = new List<SelectOption>();
        }
        else {
            accountOptions.clear();
        }
        accountOptions.add(new SelectOption('',''));
        acctIdNameMap = new Map<String,String>();
        acctIdNameMap.put('','');
        selectedAccount = '';
        if(accountList != null && !accountList.isEmpty()) {
            for(Account acct : accountList ) {
               acctIdNameMap.put(acct.Id,acct.Name+' '+'('+acct.Short_Name__c+')');
               accountOptions.add(new SelectOption(acct.Id,acct.Name+' '+'('+acct.Short_Name__c+')'));
            }
            if(accountList.size()==1) {
                selectedAccount = accountList.get(0).Id;
                populateMSTOptions();
                
            }
        }
        if(acctIdNameMap.containsKey(selectedAccount)) {
            selectedAccountName = acctIdNameMap.get(selectedAccount);
        }
    }
    
    /**
    * @description: This method populates the DRT type dropdown
    * @param: none
    * @return: none
    **/
    public void populateDrtTypeOptions() {
        if(drtTypeOptions == null) {
            drtTypeOptions = new List<SelectOption>();
        }
        else {
            drtTypeOptions.clear();
        }
        drtTypeOptions.add(new SelectOption('',''));
        Schema.DescribeFieldResult fieldResult = DRT__c.Type__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
       
        for(Schema.PicklistEntry f : ple) {
            drtTypeOptions.add(new SelectOption(f.getValue(), f.getLabel()));
            setDrtTypeOptions.add(f.getValue());
        }
        selectedDrtType = '';
    }
    
    /**
    * @description: This method populates the Mask Set Title dropdown
    * @param: none
    * @return: none
    **/
    
    public void populateMSTOptions() {
        if(mstOptions == null) {
            mstOptions = new List<SelectOption>();
        }
        else {
            mstOptions.clear();
        }
        mstOptions.add(new SelectOption('',''));
        mstMap = new Map<String,String>();
        mstMap.put('','');
        // add row mst string
        addRowMSTString = '#;';        
        if(!String.isBlank(selectedAccount) && (acctIdNameMap.containsKey(selectedAccount))) {
            List<Mask_Set_Title__c> mstList = objDRTHandlerUtility.fetchMSTList((ID)selectedAccount);
            for(Mask_Set_Title__c mst : mstList) {
                mstMap.put(mst.Id,mst.Name);
                mstOptions.add(new SelectOption(mst.Id,mst.Name));
                // prepare mst string for Add Row mst dropdown
                addRowMSTString += mst.Id + '#' + mst.Name + ';';
            }
            addRowMSTString=addRowMSTString.subString(0,addRowMSTString.length()-1);
        }
        baseMST = '';
        if(mstMap.containsKey(baseMST)) {
            baseMSTName = mstMap.get(baseMST);
        }
    }
    
    /**
    * @description: This method populates Tech Geo dropdown
    * @param: none
    * @return: none
    **/
    public void popuateTechGeoOptions() {
        showTechGeo = false; // set default display to none
        if(techGeoList == null) {
            techGeoList = new List<String>();
        }
        else {
            techGeoList.clear();
        }
        setTechGeo = DRTHandlerUtility.fetchTechGeoList(baseMST, selectedDrtType);
        if(setTechGeo != null && !setTechGeo.isEmpty()) {
            showTechGeo = true;
            techGeoList.add('');
            techGeoList.addAll(setTechGeo);
            selectedTechGeo = '';
        }
    }
   
    /**
    * @description: This RemoteAction method is used to populate chip dropdown in DRT table. Called on change of Mask Set Title in Add Row.
    * @param: string selectedMST, string techGeo
    * @return: list<String>
    **/
    @RemoteAction
    global static List<String> fetchChipNames(String selectedMST,string techGeo) {       
        List<String> lstChipName = new List<String>();
        if(selectedMST != '') {
        List<Chip_Detail__c> lstChipDetail = DRTHandlerUtility.fetchChipDetails(selectedMST,techGeo);
        if(lstChipDetail != null && !lstChipDetail.isEmpty()) {
            for(Chip_Detail__c chip : lstChipDetail) {
                lstChipName.add(chip.Name);
            }
        }
        }
        return lstChipName;
    }
    /**
    * @description: This method is called on 'Proceed' action in DRT. Used to populate initial DRT table.
    * @param: none
    * @return: Pagereference
    **/
    public Pagereference populateChipDetails() {        
        proceedActionValid = true;
        selectedAccountBlank = false;
        baseMSTBlank = false;
        selectedDrtTypeBlank = false;
        drtCreateErrorMsg = '';
        if(acctIdNameMap.containsKey(selectedAccount)) {
            selectedAccountName = acctIdNameMap.get(selectedAccount);
        }
        if(mstMap.containsKey(baseMST)) {
            baseMSTName = mstMap.get(baseMST);
        }
        if(String.isBlank(selectedAccount)|| (!acctIdNameMap.containsKey(selectedAccount))) {
            selectedAccountBlank = true;
            proceedActionValid = false;
        }
        if(String.isBlank(baseMST) || (!mstMap.containsKey(baseMST))) {
            baseMSTBlank = true;
            proceedActionValid = false;
        }
        if(String.isBlank(selectedDrtType) || (!setDrtTypeOptions.contains(selectedDrtType))) {
            selectedDrtTypeBlank = true;
            proceedActionValid = false;
        }
        if(!proceedActionValid) {
            drtCreateErrorMsg = Error_Codes__c.getInstance('DRT_CREATION_ERROR').Message__c;
        }
        Boolean techGeoError = false;
        if(!showTechGeo) { 
            // Tech Geo not applicable or not displayed
            popuateTechGeoOptions();
            if(showTechGeo) {   
                // Tech Geo was applicable but proceed happened before tech geo filter is rendered
                techGeoError = true;
            }
        }
        if(techGeoError || (showTechGeo && (String.isBlank(selectedTechGeo) || (!setTechGeo.contains(selectedTechGeo))))) {
            proceedActionValid = false;
            drtCreateErrorMsg = Error_Codes__c.getInstance('DRT_CREATION_ERROR_TECHGEO').Message__c;
        }
        if(!proceedActionValid) {
            return null;
        } 
        if(mainTableList == null) {
            mainTableList = new List<MainTableWrapper>();
        }
        else {
            mainTableList.clear();
        }
        mainTableListVisible = false;
        if(!String.isBlank(selectedDrtType) && selectedDrtType.equalsIgnoreCase('prime')) {
            List<Chip_Detail__c> chipDetailList = DRTHandlerUtility.fetchChipDetails(baseMST,selectedTechGeo);
            if(chipDetailList != null && !chipDetailList.isEmpty()) {
                Boolean isEven;
                for(Integer i=0; i < chipDetailList.size(); i++) {
                    isEven = false;
                    if(Math.mod(i,2)==0) {
                        isEven = true;
                    }
                    mainTableList.add(new MainTableWrapper(i+1,baseMSTName,chipDetailList.get(i).Name,isEven,chipDetailList.get(i).PTRF__c));           
                }
                mainTableListVisible = true;
            }
        }
        // drt name
        drtName = objDRTHandlerUtility.generateNextDRTName(baseMST,baseMSTName,selectedDrtType);
        showAsLabel = true;
       
        return null;
    }
    
    /**
    * @description: This method is called on clicking of Add Retrofit Layer button. Used to populate list of Mask Layers in Add Retrofit Layer page.
    * @param: none
    * @return: Pagereference
    **/
    public Pagereference populateMaskLayers() {
        if(MaskLayerList != null && !MaskLayerList.isEmpty()){
            return null;
        }
        maskLayerList = new List<MaskLayerRow>();
       
        if(!String.isBlank(baseMST) && !String.isBlank(selectedDrtType)) {
            Integer counter = 0;
            lstPopulatedMaskLayers.addAll(DRTHandlerUtility.fetchMaskLayers(baseMST,selectedDrtType,selectedTechGeo));
            list<Mask_Layer__c> lstPopulatedUniqueMaskLayers = DRTHandlerUtility.fetchUniqueMaskLayers(lstPopulatedMaskLayers);
            string layerNo,maskRev,romCode;
            for(Mask_Layer__c m : lstPopulatedUniqueMaskLayers) {
                counter++;
                layerNo = ((m.Mask_Layer_Number__c == null) ? '' :  m.Mask_Layer_Number__c);
                maskRev = ((m.Mask_Layer_Rev__c == null) ? '' : m.Mask_Layer_Rev__c);
                romCode = (((m.ROM_Code__c == null) || (m.ROM_Code__c == '####')) ? '' : m.ROM_Code__c);
                maskLayerList.add(new MaskLayerRow(counter,layerNo,maskRev,romCode));
            }
        }
        if(maskLayerList.size()==0){
            noLayerAvailableErrorMsg = Error_Codes__c.getInstance('DRT_NO_LAYERS_AVAILABLE_FOR_SELECTION').Message__c;
        }
        return null;
    }
    
    /**
    * @description: This class is used to deserialize JSON response from page. 
    **/
    @TestVisible private class MainTableClass {
        String chipName;
        String mstId;
        String PTRFId;
        public MainTableClass(String chipName,String mstId,String PTRFId) {
            this.chipName = chipName;
            this.mstId = mstId;
            this.PTRFId = PTRFId;
        }
    }
    
    /**
    * @description: This class is used to deserialize JSON response from page. 
    **/
    @TestVisible public class MaskLayerHeaderClass {
        public String layerNo {get; set;}
        public String retrofitMaskRev {get; set;}
        public String retrofitROMCode {get; set;}
        
        //swgp-2
        boolean isEdited_retrofitMaskRev;
        boolean isEdited_retrofitROMCode;
        //swgp-2-end
        
        public MaskLayerHeaderClass(String layerNo,String retrofitMaskRev,String retrofitROMCode) {
            this.layerNo = layerNo;
            if(retrofitMaskRev != null) {
                this.retrofitMaskRev = retrofitMaskRev.toUpperCase();
            }
            else {
                this.retrofitMaskRev = retrofitMaskRev;
            }
            if(retrofitROMCode != null) {
                this.retrofitROMCode = retrofitROMCode.toUpperCase();
            }
            else {
                this.retrofitROMCode = retrofitROMCode;
            }
        }
    }
    
    /**
    * @description: This class is used to deserialize JSON response from page. 
    **/
    @TestVisible private class MaskLayerContentClass {
        String maskRev;
        String romCode;
        
        //swgp-2
        boolean isEdited_maskRev;
        boolean isEdited_romCode;
        //swgp-2-end
        
        public MaskLayerContentClass(String maskRev,String romCode) {
            if(maskRev != null) {
                this.maskRev = maskRev.toUpperCase();
            }
            else {
                this.maskRev = maskRev;
            }
            if(romCode != null) {
                this.romCode = romCode.toUpperCase();
            }
            else {
                this.romCode = romCode;
            }
        }
    }
    
    /**
    * @description: This method populates Mask Layer dropdown in Add Row of FRAME DRT table. Called on change of Mask Set Title dropdown in Add Row.
    * @param: string mstId,string techGeo
    * @return: set<string>
    **/
    @RemoteAction
    global static Set<String> fetchLayerNos(String mstId,String techGeo) {
        return DRTHandlerUtility.fetchLayerNos(mstId,techGeo);
    }
    
    /**
    * @description: This method populates Mask Rev and ROM Code dropdown in Add Row of FRAME DRT table. Called on change of Mask Layer in Add Row.
    * @param: String mstId,String selectedLayerNo,String techGeo
    * @return: List<List<String>>
    **/ 
    @RemoteAction
    global static List<List<String>> fetchMaskRevROMCode(String mstId,String selectedLayerNo,String techGeo) {
        return DRTHandlerUtility.fetchMaskRevROMCode(mstId,selectedLayerNo,techGeo);
    }   
    
    /**
    * @description: This method is called on 'Save & Activate' action. Used to save and activate the DRT.
    * @param: none
    * @return: Pagereference
    **/
    public Pagereference saveAsActivate() {
        if(selectedDrtType.equalsIgnoreCase('prime')) {
            return savePrimeDRT('Activate');
        }
        else if(selectedDrtType.equalsIgnoreCase('frame')) {
            return saveFrameDRT('Activate');
        }
        return null;
    }
    
    /**
    * @description: This method is called on 'Save as Draft' action. Used to save the DRT in Draft status.
    * @param: none
    * @return: Pagereference
    **/
    public Pagereference saveAsDraft() {
        if(selectedDrtType.equalsIgnoreCase('prime')) {
            return savePrimeDRT('Draft');
        }
        else if(selectedDrtType.equalsIgnoreCase('frame')) {
            return saveFrameDRT('Draft');
        }
        return null;
    }
    
    /**
    * @description: This class is used to deserialize Frame DRT JSON response from page.
    **/
    @TestVisible private class FrameTableClass {
        String mstId;
        String layerNo;
        String retroMaskRev;
        String retroROMCode;
        String maskRev;
        String romCode;
        
        //swgp-2
        boolean isEdited_retroMaskRev;
        boolean isEdited_retroROMCode;
        //swgp-2-end
        
        public FrameTableClass(String mstId,String layerNo,String retroMaskRev,String retroROMCode,String maskRev,String romCode) {
            this.mstId = mstId;
            this.layerNo = layerNo;
            if(retroMaskRev != null) {
                this.retroMaskRev = retroMaskRev.toUpperCase();
            }
            else {
                this.retroMaskRev = retroMaskRev;
            }
            if(retroROMCode != null) {
                this.retroROMCode = retroROMCode.toUpperCase();
            }
            else {
                this.retroROMCode = retroROMCode;
            }
            if(maskRev != null) {
                this.maskRev = maskRev.toUpperCase();
            }
            else {
                this.maskRev = maskRev;
            }
            if(romCode != null) {
                this.romCode = romCode.toUpperCase();
            }
            else {
                this.romCode = romCode;
            }
        }
    }
    
    /**
    * @description: This method is used to save Frame DRT.
    * @param: string action
    * @return: Pagereference
    **/
    public Pagereference saveFrameDRT(string action) {
        // flag indicating if any error occurred
        Boolean saveError = false;
        String errorMessage;
        // clear list of error messages
        if(lstDRTErrorMessage != null){
            lstDRTErrorMessage.clear();
        }
        
        /* Prepare DRT__c data */
        
        DRT__c drtData = new DRT__c();
        drtData.Name = drtName;
        drtData.Unique_DRT_Name__c = drtName;
        drtData.Customer_Name__c = selectedAccount;
        drtData.type__c = selectedDrtType;
        drtData.Mask_Set_Title__c = baseMST;
        if(showTechGeo) {
            drtData.Tech_Geo__c = selectedTechGeo;
        }
        drtData.Description__c = description;
        if(action == 'Draft') {
            drtData.status__c = 'Draft';        
        }
        else if(action == 'Activate'){
            drtData.status__c = 'Active';
        }
        
        /** Prepare Frame_DRT_Association__c data **/
        
        // parse JSON response for Frame Layer table data
        List<FrameTableClass> lstFrameTableData = (List<FrameTableClass>)JSON.deserialize(frameTableJSON,List<FrameTableClass>.class);        
        
        List<Frame_DRT_Association__c> lstFrameDRTAssoc = new List<Frame_DRT_Association__c>();
        Frame_DRT_Association__c frameDRTAssocObj;
        
        if(lstFrameTableData != null && !lstFrameTableData.isEmpty()) {
                for(FrameTableClass frameRow : lstFrameTableData) {
                    frameDRTAssocObj = new Frame_DRT_Association__c();
                    if(!String.isBlank(frameRow.mstId)) {
                        frameDRTAssocObj.Mask_Set_Title__c = frameRow.mstId;               
                    }
                    else {
                        frameDRTAssocObj.Mask_Set_Title__c  = null;                        
                    }
                    frameDRTAssocObj.Mask_Layer_No__c = frameRow.layerNo;                    
                    frameDRTAssocObj.Mask_Rev__c = frameRow.maskRev;
                    if(frameDRTAssocObj.Mask_Rev__c != null) {
                        frameDRTAssocObj.Mask_Rev__c = frameDRTAssocObj.Mask_Rev__c.toUpperCase();
                    }                    
                    frameDRTAssocObj.ROM_Code__c = frameRow.romCode;
                    if(frameDRTAssocObj.ROM_Code__c != null) {
                        frameDRTAssocObj.ROM_Code__c = frameDRTAssocObj.ROM_Code__c.toUpperCase();
                    }                    
                    frameDRTAssocObj.Retrofit_Mask_Rev__c = frameRow.retroMaskRev;
                    if(frameDRTAssocObj.Retrofit_Mask_Rev__c != null) {
                        frameDRTAssocObj.Retrofit_Mask_Rev__c = frameDRTAssocObj.Retrofit_Mask_Rev__c.trim();
                        frameDRTAssocObj.Retrofit_Mask_Rev__c = frameDRTAssocObj.Retrofit_Mask_Rev__c.toUpperCase();
                    }
                    frameDRTAssocObj.Retrofit_Mask_Rev__c = (frameDRTAssocObj.Retrofit_Mask_Rev__c == DRTHandlerUtility.blankText)?'':frameDRTAssocObj.Retrofit_Mask_Rev__c;                    
                    
                    frameDRTAssocObj.Retrofit_ROM_Code__c = frameRow.retroROMCode;
                    if(frameDRTAssocObj.Retrofit_ROM_Code__c != null) {
                        frameDRTAssocObj.Retrofit_ROM_Code__c = frameDRTAssocObj.Retrofit_ROM_Code__c.trim();
                        frameDRTAssocObj.Retrofit_ROM_Code__c = frameDRTAssocObj.Retrofit_ROM_Code__c.toUpperCase();
                    }
                    frameDRTAssocObj.Retrofit_ROM_Code__c = (frameDRTAssocObj.Retrofit_ROM_Code__c == DRTHandlerUtility.blankText)?'':frameDRTAssocObj.Retrofit_ROM_Code__c;
                    
                    //swgp-2
                    frameDRTAssocObj.Is_Edited_Retrofit_Mask_Rev__c = frameRow.isEdited_retroMaskRev;
                    frameDRTAssocObj.Is_Edited_Retrofit_ROM_Code__c = frameRow.isEdited_retroROMCode;
                    //swgp-2-end
                    
                    lstFrameDRTAssoc.add(frameDRTAssocObj);                      
                }               
            }
        
            // validate Frame DRT data and prepare error information for highlighting error locations
            
            DRTHandlerUtility.ErrorDetails objFrameErrorDetails = objDRTHandlerUtility.validateFrameTableData(drtData,lstFrameDRTAssoc); 
            if(objFrameErrorDetails != null) {
                if(objFrameErrorDetails.error) {
                    saveError = true;
                }
                // add error messages to page
                lstDRTErrorMessage.addAll(objFrameErrorDetails.setErrorMessage);                
                // set json data indicating hightlight locations                
                frameTableErrorJSON = objFrameErrorDetails.errorJSON;
            }
            
            Savepoint sp = Database.setSavepoint();
            Id insertedDRTId;
            try {           
                if(!saveError) {
                    insertedDRTId = DRTHandlerUtility.insertFrameDRT(drtData,lstFrameDRTAssoc);
                    if(action == 'Activate') {
                        DRTHandlerUtility.sendMassEmailOnDRTActivation(insertedDRTId, !notSendEmail);
                    }
                }            
                if(insertedDRTId != null) {
                    return new Pagereference('/apex/vfdrtdetail?Id='+insertedDRTId+'&urlFromPage=Create');
                }
                else {
                    return null;
                }
            }
            catch(DMLException e) {
                Database.rollBack(sp);
                if(e.getMessage().containsIgnoreCase('Unique_DRT_Name__c')) {
                    string errorMsg = Error_Codes__c.getInstance('Unique_DRT_Name_Error').Message__c.replace('{DRTName}',drtData.Name);
                    lstDRTErrorMessage.add(errorMsg);
                    // Regenerate DRT Name
                    drtName = objDRTHandlerUtility.generateNextDRTName(baseMST,baseMSTName,selectedDrtType);
                    return null;                
                }
                lstDRTErrorMessage.add(e.getMessage());           
                return null;
            }
        return null;
    }
    
    /**
    * @description: This method is used to save Prime DRT
    * @param: String action
    * @return: Pagereference
    **/
    public Pagereference savePrimeDRT(String action) {
        // flag indicating if any error occurred
        Boolean saveError = false;
        // clear list of error messages
        if(lstDRTErrorMessage != null){
            lstDRTErrorMessage.clear();
        }
        
        /* Prepare DRT__c data */
        DRT__c drtData = new DRT__c();
        drtData.Customer_Name__c = selectedAccount;
        drtData.type__c = selectedDrtType;
        drtData.Mask_Set_Title__c = baseMST;
        drtData.Name = drtName;
        drtData.Unique_DRT_Name__c = drtName;
        
        if(showTechGeo) {
            drtData.Tech_Geo__c = selectedTechGeo;
        }
        drtData.Description__c = description;
        if(action == 'Draft') {
            drtData.status__c = 'Draft';        
        }
        else if(action == 'Activate'){
            drtData.status__c = 'Active';
        }
        /* prepare PRIME_DRT_Chip_Association__c data */
        
        // parse JSON response for Main Table data
        List<MainTableClass> lstMainTableData = (List<MainTableClass>)JSON.deserialize(mainTableJSON,List<MainTableClass>.class); 
              
        List<PRIME_DRT_Chip_Association__c> lstDRTChipAssoc = new List<PRIME_DRT_Chip_Association__c>();       
        if(lstMainTableData != null && !lstMainTableData.isEmpty()) {
            PRIME_DRT_Chip_Association__c objPrimeDrtChipAssoc;
            for(MainTableClass mainTableRow : lstMainTableData) {
                objPrimeDrtChipAssoc = new PRIME_DRT_Chip_Association__c();
                objPrimeDrtChipAssoc.Name = mainTableRow.chipName;
                if(!String.isBlank(mainTableRow.mstId)) {
                    objPrimeDrtChipAssoc.Mask_Set_Title__c = mainTableRow.mstId;               
                }
                else {
                    objPrimeDrtChipAssoc.Mask_Set_Title__c  = null;
                }
                objPrimeDrtChipAssoc.fetched_from_PTRF_Id__c = mainTableRow.PTRFId;
                lstDRTChipAssoc.add(objPrimeDrtChipAssoc);
                
            }
        }
        /* prepare PRIME_DRT_Layer_Association__c data */
        
        // parse JSON response for Mask Layer Header table data
        List<MaskLayerHeaderClass> lstMaskLayerHeaderData = (List<MaskLayerHeaderClass>)JSON.deserialize(maskLayerHeaderJSON,List<MaskLayerHeaderClass>.class);
        
        List<PRIME_DRT_Layer_Association__c> lsDRTLayerAssoc = new List<PRIME_DRT_Layer_Association__c>();       
        if(lstMaskLayerHeaderData!= null && !lstMaskLayerHeaderData.isEmpty()) {
            PRIME_DRT_Layer_Association__c objPrimeDrtLayerAssoc;
            for(MaskLayerHeaderClass maskLayerHeaderRow : lstMaskLayerHeaderData ) {
                objPrimeDrtLayerAssoc = new PRIME_DRT_Layer_Association__c();
                objPrimeDrtLayerAssoc.Name = maskLayerHeaderRow.layerNo;
                objPrimeDrtLayerAssoc.Retrofit_Mask_Rev__c = maskLayerHeaderRow.retrofitMaskRev;
                if(objPrimeDrtLayerAssoc.Retrofit_Mask_Rev__c != null) {
                    objPrimeDrtLayerAssoc.Retrofit_Mask_Rev__c = objPrimeDrtLayerAssoc.Retrofit_Mask_Rev__c.toUpperCase();
                }
                objPrimeDrtLayerAssoc.Retrofit_ROM_Code__c = maskLayerHeaderRow.retrofitROMCode;
                if(objPrimeDrtLayerAssoc.Retrofit_ROM_Code__c != null) {
                    objPrimeDrtLayerAssoc.Retrofit_ROM_Code__c = objPrimeDrtLayerAssoc.Retrofit_ROM_Code__c.toUpperCase();
                }         

                //swgp-2
                objPrimeDrtLayerAssoc.Is_Edited_Retrofit_Mask_Rev__c = maskLayerHeaderRow.isEdited_retrofitMaskRev;
                objPrimeDrtLayerAssoc.Is_Edited_Retrofit_ROM_Code__c = maskLayerHeaderRow.isEdited_retrofitROMCode;
                //swgp-2-end
                
                lsDRTLayerAssoc.add(objPrimeDrtLayerAssoc);
            }
        }
        // prepare PRIME_DRT_Chip_Layer_Summary__c data 
        
        // parse JSON response for Mask Layer Content table data    
        List<List<MaskLayerContentClass>> lstMaskLayerContentData = (List<List<MaskLayerContentClass>>)JSON.deserialize(maskLayerContentJSON,List<List<MaskLayerContentClass>>.class);       
        
        List<PRIME_DRT_Chip_Layer_Summary__c> lsDRTChipLayerAssoc = new List<PRIME_DRT_Chip_Layer_Summary__c>();       
        if(lstMaskLayerContentData!= null && !lstMaskLayerContentData.isEmpty()) {
            PRIME_DRT_Chip_Layer_Summary__c objPrimeDrtChipLayerAssoc;
            for(List<MaskLayerContentClass> maskLayerContentRow : lstMaskLayerContentData ) {
                for(MaskLayerContentClass tableRow : maskLayerContentRow) {
                    objPrimeDrtChipLayerAssoc = new PRIME_DRT_Chip_Layer_Summary__c();
                    objPrimeDrtChipLayerAssoc.Mask_Layer_Rev__c = tableRow.maskRev;
                    if(objPrimeDrtChipLayerAssoc.Mask_Layer_Rev__c != null) {
                        objPrimeDrtChipLayerAssoc.Mask_Layer_Rev__c = objPrimeDrtChipLayerAssoc.Mask_Layer_Rev__c.toUpperCase();
                    }
                    objPrimeDrtChipLayerAssoc.ROM_Code__c = tableRow.romCode;
                    if(objPrimeDrtChipLayerAssoc.ROM_Code__c != null) {
                        objPrimeDrtChipLayerAssoc.ROM_Code__c = objPrimeDrtChipLayerAssoc.ROM_Code__c.toUpperCase();
                    }
                    
                    //swgp-2
                    objPrimeDrtChipLayerAssoc.Is_Edited_Mask_Layer_Rev__c = tableRow.isEdited_maskRev;
                    objPrimeDrtChipLayerAssoc.Is_Edited_ROM_Code__c = tableRow.isEdited_romCode;
                    //swgp-2-end
                              
                    lsDRTChipLayerAssoc.add(objPrimeDrtChipLayerAssoc);
                }
            }
        }
        // validate DRT Table data and prepare error information for highlighting error locations
        DRTHandlerUtility.DRTErrorDetails objDRTErrorDetails = objDRTHandlerUtility.validateDRTTableData(drtData,lstDRTChipAssoc,lsDRTLayerAssoc,lsDRTChipLayerAssoc); 
        if(objDRTErrorDetails != null) {
            if(objDRTErrorDetails.error) {
                saveError = true;
            }
            // add error messages to page
            lstDRTErrorMessage.addAll(objDRTErrorDetails.MainTableError.setErrorMessage);
            lstDRTErrorMessage.addAll(objDRTErrorDetails.MaskLayerHeaderError.setErrorMessage);
            lstDRTErrorMessage.addAll(objDRTErrorDetails.MaskLayerContentError.setErrorMessage);
            // set json data indicating hightlight locations
            mainTableErrorJSON = objDRTErrorDetails.MainTableError.errorJSON;
            maskLayerErrorJSON = objDRTErrorDetails.MaskLayerHeaderError.errorJSON;
            maskLayerContentErrorJSON = objDRTErrorDetails.MaskLayerContentError.errorJSON;
        }
        ID insertedDRTId; // Id of DRT record to be inserted
        if(!saveError) { // insert only if no error
            insertedDRTId = insertDRT(drtData,lsDRTLayerAssoc,lstDRTChipAssoc,lsDRTChipLayerAssoc);
            //In case the DRT has been created successfully, send mail to intended recepients
            if(action == 'Activate'){
                DRTHandlerUtility.sendMassEmailOnDRTActivation(insertedDRTId, !notSendEmail);
            }   
        }
        if(insertedDRTId == null) {
            return null;
        }
        return new Pagereference('/apex/vfdrtdetail?Id='+insertedDRTId+'&urlFromPage=Create');
    }
    
    /**
    * @description: This method is used to insert the records related to a DRT.
    * @param: DRT__c recordDRT, List<PRIME_DRT_Layer_Association__c> layerList,List<PRIME_DRT_Chip_Association__c> chipList, List<PRIME_DRT_Chip_Layer_Summary__c> chipLayerSummary
    * @return: ID
    **/
    private ID insertDRT(DRT__c recordDRT, List<PRIME_DRT_Layer_Association__c> layerList,List<PRIME_DRT_Chip_Association__c> chipList, List<PRIME_DRT_Chip_Layer_Summary__c> chipLayerSummary) {              
        Database.saveresult uResultDRT;
        List<Database.saveresult> uResultsLayer;       
        List<Database.saveresult> uResultsChip;
        ID idDRTNew;       
        integer intCounter=0;
       
        Savepoint sp = Database.setSavepoint();
 
        try {
                return DRTHandlerUtility.insertDRT(recordDRT,layerList,chipList,chipLayerSummary);
        }
        catch (Exception e) {
            Database.rollback(sp);
            if(e.getMessage().containsIgnoreCase('Unique_DRT_Name__c')) {
                string errorMsg = Error_Codes__c.getInstance('Unique_DRT_Name_Error').Message__c.replace('{DRTName}',recordDRT.Name);
                lstDRTErrorMessage.add(errorMsg);
                // Regenerate DRT Name
                drtName = objDRTHandlerUtility.generateNextDRTName(baseMST,baseMSTName,selectedDrtType);
                return null;                
            }
            lstDRTErrorMessage.add(e.getMessage());
       }             
       return null;
    }
    
    /**
    * @description: This class is a wrapper class for initial DRT table populated on Proceed button click.
    **/
    public class MainTableWrapper {
        public Integer no {get; set;}
        public String mst {get; set;}
        public String chipName {get; set;}
        public Boolean isEven{get; set;}
        public String PTRFId {get; set;}
        public MainTableWrapper(Integer no, String mst, String chipName, Boolean isEven,String PTRFId) {
            this.no = no;
            this.mst = mst;
            this.chipName = chipName;
            this.isEven = isEven;
            this.PTRFId = PTRFId;
        }
    }
    
    /**
    * @description: This class is a wrapper class for Mask Layers in Add Retrofit Layer page.
    **/
    public class MaskLayerRow {
        public Integer no {get; set;}
        public String layerNo {get; set;}
        public String pastMaskRev {get; set;}
        public String pastROMCode {get; set;}
       
        public MaskLayerRow(Integer no, String layerNo, String pastMaskRev, String pastROMCode) {
            this.no = no;
            this.layerNo = layerNo;
            this.pastMaskRev = pastMaskRev;
            this.pastROMCode = pastROMCode;         
        }
    }
    
    /**
    * @description: This method is called on Discard button. Used to return to the initial Create DRT page.
    * @param: none
    * @return: Pagereference
    **/     
    public Pagereference refreshPage() {
        Pagereference pgRef = ApexPages.currentPage();
        pgRef.setRedirect(true);
        return pgRef;
    }
    
    /**
    * @description: This method is called on clicking 'Add' button in Add Retrofit Layer page. Used to add the selected Mask Layers to the DRT table.
    * @param: none
    * @return: Pagereference
    **/
    public Pagereference addMaskLayers() {
        // deserialize selected mask layers
        lstSelectedMaskLayer = (list<DRTHandlerUtility.MaskLayerWrapper>)JSON.deserialize(selectedMaskLayerJSON,list<DRTHandlerUtility.MaskLayerWrapper>.class);
        if(lstSelectedMaskLayer==null||lstSelectedMaskLayer.isEmpty()){
            return null;
        }
        // prepare list of chip names
        mainTableChipList = (list<DRTHandlerUtility.ChipWrapper>)JSON.deserialize(mainTableChipListJSON,list<DRTHandlerUtility.ChipWrapper>.class);
        
        // prepare mask layer header and mask layer content lists
        mapDisplayedMaskLayerData = objDRTHandlerUtility.fetchMaskRevROMCodeList(baseMST,selectedDrtType,selectedTechGeo,
                                                                                 lstSelectedMaskLayer,mainTableChipList,
                                                                                 lstPopulatedMaskLayers,layerCount);
        selectedMaskLayerJSON = '';
        mainTableChipListJSON = '';
        // set global count of added mask layers
        layerCount += lstSelectedMaskLayer.size();
        return null;
    }
    
    /**
    * @description: This method is used to generate Mask Rev/ROM Code dropdown on clicking of Mask Rev/ROM Code links for a particular chip and layer in DRT table.
    * @param: string chipName,string layerNo,string chipMST,string baseMST,string techGeo
    * @return: list<list<string>>
    **/
    @RemoteAction
    global static list<list<string>> fetchChipLayerComboData(string chipName,string layerNo,string chipMST,string baseMST,string techGeo) {    
        return DRTHandlerUtility.fetchChipLayerComboData(chipName,layerNo,chipMST,baseMST,techGeo);
    }
    
    /**
    * @description: This method is used to generate the right portion of row when adding a new row in the DRT table.
    *               Right portion means the part of the row under Mask Layers.
    * @param: string chipName,string layerJSON,string mstId,string baseMST,string techGeo,integer rowCountGlobal
    * @return: string
    **/
    @RemoteAction
    global static string fetchNewChipLayerData(string chipName,string layerJSON,string mstId,string baseMST,string techGeo,integer rowCountGlobal) {
        list<DRTHandlerUtility.MaskLayerWrapper> lstMaskLayerWrapper = (list<DRTHandlerUtility.MaskLayerWrapper>)JSON.deserialize(layerJSON,
                                                                               list<DRTHandlerUtility.MaskLayerWrapper>.class);
        list<DRTHandlerUtility.MaskRevROMCodeWrapper> lstLayerData = DRTHandlerUtility.fetchNewChipLayerData(chipName,lstMaskLayerWrapper,
                                                                                                             mstId,baseMST,techGeo,rowCountGlobal);        
        return JSON.serialize(lstLayerData);
    }
}