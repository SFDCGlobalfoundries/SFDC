/*
Author: Cognizant Technology Solutions
Company: 
Description:    This will be the controller class behind the Visualforce Page VFDRTRevise. 
                This will also call the handler class DRTHandlerUtility which will contain all 
                the business logic regarding the DRT Revision process. 
History:
    Cognizant   18032014        - Initial Version
    SWIFT       19-Oct-2016     - SWGP-269          
*/
global class DRTReviseExtn {
    //swgp-269
    public boolean hasShippedLayer {get;set;}//a flag to check at page load whether any shipped layer or not
    public boolean isSaveByUser {get;set;}//a flag to determine that user clicks on Save & Activate button
    //swgp-269-end
    public List<PRIME_DRT_Layer_Association__c> lstPrimeDRTLayerAssociation {get;set;} 
    public List<PRIME_DRT_Chip_Association__c> lstPrimeDRTChipAssociation {get;set;} 
    public DRT__c objDRTDetail{get;set;}      
    public List<PRIME_DRT_Chip_Layer_Summary__c> lstPrimeDrtSummary{get;set;} 
    public String baseMST {get; set;} // base MST          
    public transient List<MaskLayerHeaderWrapper> maskLayerHeaderWrapperList{get;set;}     
    public transient List<ChipWrapper> chipWrapperList{get;set;} 
    public String mainTableJSON{get; set;}
    public String maskLayerHeaderJSON{get; set;}
    public String maskLayerContentJSON{get; set;} 
    public Id idDRTId;
    
    public  Boolean isTechGeoNull {get;set;}
    public  Boolean isBreadcrumbActive {get;set;}

    public List<SelectOption> accountOptions {get; set;} // account options
    public List<SelectOption> mstOptions{get; set;} // mst options
    public String selectedAccount {get; set;} //selected Customer Account
    public String selectedAccountName { get; private set;} // selected Account Name
    
    public String addRowMSTString {get; private set;}
    public String baseMSTName { get; set;} // base MST Name
    public List<MaskLayerRow> maskLayerList{get;set;}
    public String frameTableJSON {get; set;}
    public String selectedDrtType {get; set;} // DRT type
    public boolean isPrimeDRT {get;set;}
    public boolean isFrameDRT {get;set;}
    public DRTHandlerUtility.DRTWrapper drtWrapper {get;set;}
    public List<DRTHandlerUtility.FrameDRTWrapper> lstFrameDRTWrapper {get;set;} 
    public String strDesc{get; set;}
    public String revisedDRTName {get; private set;}
    public String revisedDRTStatus {get; private set;}
    public String fromPage{get; set;}
    
    // error variables
    public String mainTableErrorJSON {get; set;}
    public String maskLayerErrorJSON {get; set;}
    public String maskLayerContentErrorJSON {get; set;}
    public String frameTableErrorJSON {get; set;}
    public List<String> lstDRTErrorMessage {get;  set;}
    
    public static Map<String, Error_Codes__c> mapEC = Error_Codes__c.getAll();
    
    public String selectedMaskLayerJSON {get; set;}
    public List<DRTHandlerUtility.MaskLayerWrapper> lstSelectedMaskLayer {get; set;}
    public list<DRTHandlerUtility.ChipWrapper> mainTableChipList {get;set;}
    public string mainTableChipListJSON {get;set;}
    public string selectedChipsJSON {get;set;}
    public string delChipsJSON {get;set;}
    public transient map<string,map<string,DRTHandlerUtility.MaskRevROMCodeWrapper>> mapDisplayedMaskLayerData {get;set;}
    public string noLayerAvailableErrorMsg {get;set;}
    
    public list<Mask_Layer__c> lstPopulatedMaskLayers;
    private integer layerCount {get;set;} // global count of no of added layers to prevent duplicate html id
    
    private DRTHandlerUtility objDRTHandlerUtility;
    private Map<String,String> mstMap;
    private Map<String,String> acctIdNameMap;
    private static Id drtId;
    
    /**
    * @description: This is the constructor
    * @param: ApexPages.StandardController controller
    * @return: none
    **/
    public DRTReviseExtn(ApexPages.StandardController objController) {
            
            idDRTId=ApexPages.currentPage().getParameters().get('id');
            
            if(string.isBlank(idDRTId)) return; 
            
            // initialize variables
            lstPopulatedMaskLayers = new list<Mask_Layer__c>();
            lstSelectedMaskLayer = new list<DRTHandlerUtility.MaskLayerWrapper>();
            layerCount = 0;
            objDRTHandlerUtility = new DRTHandlerUtility();
            lstDRTErrorMessage = new List<String>();
            maskLayerList = new List<MaskLayerRow>();
            String url = ApexPages.currentPage().getHeaders().get('Host');
            
            if(Label.SWIFT_Community_URL.contains(url)) isBreadcrumbActive = true;
            else isBreadcrumbActive = false;
            
            objDRTDetail = DRTHandlerUtility.fetchDRTDetails(idDRTId);
            drtWrapper = new DRTHandlerUtility.DRTWrapper(objDRTDetail);            
            selectedDrtType  = objDRTDetail.Type__c;
            baseMST =  objDRTDetail.Mask_Set_Title__c; 
            strDesc = objDRTDetail.Description__c;
            revisedDRTName = objDRTHandlerUtility.generateNextRevisedDRTName(objDRTDetail.Name);                
            revisedDRTStatus = 'Draft';
            isPrimeDRT = false;
            isFrameDRT = false;
            
            if(selectedDrtType!=null && selectedDrtType.equalsIgnorecase('prime')) {
                isPrimeDRT = true;
                isFrameDRT = false;
            } else if(selectedDrtType!=null && selectedDrtType.equalsIgnorecase('frame')){
                isFrameDRT = true;
                isPrimeDRT = false;
            }
            
            // for breadcrumb
            if(ApexPages.currentPage().getParameters().containsKey('urlFromPage')) {
                fromPage = ApexPages.currentPage().getParameters().get('urlFromPage');
            }
                     
            if(objDRTDetail.Status__c != 'Active') return;
            
            if(!DRTHandlerUtility.isReviseApplicable(idDRTId)) return;
            
            if(objDRTDetail.Tech_Geo__c != null) isTechGeoNull = true;
            
            if(!string.isBlank(objDRTDetail.Type__c) && objDRTDetail.Type__c.equalsIgnoreCase('prime')) {
                
                list<PRIME_DRT_Chip_Layer_Summary__c> lstChipLayerSummary = getPrimeDRTChipLayerSummaryList(idDRTId);
                mapDisplayedMaskLayerData = objDRTHandlerUtility.fetchPrimeDRTMaskRevROMCodeData(lstChipLayerSummary);
  
                setDRTDataToWrapper(idDRTId);          
                populateMSTOptions();
            } else if(!string.isBlank(objDRTDetail.Type__c) && objDRTDetail.Type__c.equalsIgnoreCase('frame')) {
                lstFrameDRTWrapper = fetchFrameDRTData(idDRTId);
                populateMSTOptions();
            }
            
            //====================================================================
            //swgp-269: will need to check for layer status and set a flag to indicate there are at least 1 layer is shipped >>> flag true
            set<String> layerUniqueIdentifer = new set<String>();
                        
            //PRIME LIST
            if(null != maskLayerHeaderWrapperList) {
                for(MaskLayerHeaderWrapper m: maskLayerHeaderWrapperList) {
                    layerUniqueIdentifer.add(DRTHandlerUtilityExtn.getLayerUniqueIdentifier(objDRTDetail, m.layerNo, m.retroftMaskRev, m.retroftROMCode) + '%');//%: is used in soql WHERE clause below
                }
            }

            //FRAME LIST
            if(null != lstFrameDRTWrapper) {
                for(DRTHandlerUtility.FrameDRTWrapper m: lstFrameDRTWrapper) {
                    layerUniqueIdentifer.add(DRTHandlerUtilityExtn.getLayerUniqueIdentifier(objDRTDetail, m.layerNo, m.retroMaskRev, m.retroROMCode) + '%');//%: is used in soql WHERE clause below
                }
            }

            //query for at least 1 shipped layer
            list<mrs_layer_association__c> shippedLayerList = [
                select id from mrs_layer_association__c 
                where MRS_Layer_Unique_Identifier__c like :layerUniqueIdentifer and layer_status__c = 'Shipped'
                limit 1
            ];

            hasShippedLayer = false;//flag down
            if(!shippedLayerList.isEmpty()) hasShippedLayer = true;
            isSaveByUser = false;//flag down
            //swgp-269-end
            //====================================================================
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
        
        selectedAccount = objDRTDetail.customer_name__c;
        // add row mst string
        addRowMSTString = '#;';
        if(selectedAccount != null && selectedAccount != '') {
            
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
    * @description: This RemoteAction method is used to populate chip dropdown in DRT table. Called on change of Mask Set Title in Add Row.
    * @param: string selectedMST, string techGeo
    * @return: list<String>
    **/
    @RemoteAction
    global static List<String> fetchChipNames(string selectedMST,string techGeo) {        
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
    * @description: This method is used to fetch PRIME_DRT_Chip_Layer_Summary__c records from database
    * @param: ID idDRT
    * @return: List<PRIME_DRT_Chip_Layer_Summary__c>
    **/
    private List<PRIME_DRT_Chip_Layer_Summary__c> getPrimeDRTChipLayerSummaryList(ID idDRT) {
         lstPrimeDRTLayerAssociation = DRTHandlerUtility.fetchPrimeDRTLayerAssociationList(idDRT);
         lstPrimeDRTChipAssociation = DRTHandlerUtility.fetchPrimeDRTChipAssociationList(idDRT);
         list<PRIME_DRT_Chip_Layer_Summary__c> lstPrimeDRTChipLayerSummary = new list<PRIME_DRT_Chip_Layer_Summary__c>();
         if(lstPrimeDRTLayerAssociation!=null && !lstPrimeDRTLayerAssociation.isEmpty() && 
                            lstPrimeDRTChipAssociation!=null && !lstPrimeDRTChipAssociation.isEmpty()) {
             lstPrimeDRTChipLayerSummary = DRTHandlerUtility.fetchPrimeDRTChipLayerSummaryList(lstPrimeDRTLayerAssociation,lstPrimeDRTChipAssociation);
         }        
         return lstPrimeDRTChipLayerSummary;
     }
     
    /**
    * @description: This method is used to generate the wrapper object list for showing Mask Layers in the DRT when opened in Update page.
    * @param: ID idDRT
    * @return: void
    **/    
    private void setDRTDataToWrapper(ID idDRT) {
        MaskLayerHeaderWrapper  objMaskLayerHeaderWrapper;
        ChipWrapper objChipWrapper;
        if(lstPrimeDRTLayerAssociation != null && !lstPrimeDRTLayerAssociation.isEmpty()) {
             maskLayerHeaderWrapperList = new List<MaskLayerHeaderWrapper>();
             integer counter = 1;
             for (PRIME_DRT_Layer_Association__c objPDLayer:lstPrimeDRTLayerAssociation ) {
                    string maskRev,romCode;
                    maskRev = objPDLayer.Retrofit_Mask_Rev__c;
                    romCode = objPDLayer.Retrofit_ROM_Code__c;
                    maskRev = (string.isBlank(maskRev))?'---':maskRev;
                    romCode = (string.isBlank(romCode))?'---':romCode;
                    objMaskLayerHeaderWrapper=new MaskLayerHeaderWrapper(string.valueOf(counter),objPDLayer.Id,objPDLayer.Name,maskRev,romCode);
                    objMaskLayerHeaderWrapper.htmlId = string.valueOf(counter);
                    maskLayerHeaderWrapperList.add(objMaskLayerHeaderWrapper);
                    counter++;
             }
             layerCount = maskLayerHeaderWrapperList.size(); // set no of available layers          
        }
        if(lstPrimeDRTChipAssociation != null && !lstPrimeDRTChipAssociation.isEmpty()) {
             chipWrapperList =new List<ChipWrapper>();
             integer counter = 1;
             for (PRIME_DRT_Chip_Association__c objPDChip:lstPrimeDRTChipAssociation ) {
                  objChipWrapper = new ChipWrapper(string.valueOf(counter),objPDChip.id,objPDChip.Name,objPDChip.Mask_Set_Title__c,objPDChip.Mask_Set_Title__r.Name);
                  chipWrapperList.add(objChipWrapper); 
                  counter++;
             }                 
        }
    }
     
    /**
    * @description: This method is called on 'Save as Draft' action. Used to save the DRT in Draft status.
    * @param: none
    * @return: Pagereference
    **/   
    public Pagereference saveAsDraft() {
        if(!string.isBlank(selectedDrtType)) {
            if(selectedDrtType.equalsIgnoreCase('prime')) {
                return savePrimeDRT('Draft');
                }
            else if(selectedDrtType.equalsIgnoreCase('frame')) {
                return saveFrameDRT('Draft');
            }
        }
        return null;
    }

    /**
    * @description: This method is called on 'Save & Activate' action. Used to save and activate the DRT.
    * @param: none
    * @return: Pagereference
    **/
    public Pagereference saveAsActive() {
        if(!string.isBlank(selectedDrtType)) {
            if(selectedDrtType.equalsIgnoreCase('prime')) {
                return savePrimeDRT('Activate');
                }
            else if(selectedDrtType.equalsIgnoreCase('frame')) {
                return saveFrameDRT('Activate');
            }
        }
        return null;
    }
    
    /**
    * @description: This method is used to save Prime DRT
    * @param: none
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
                drtData.Name = revisedDRTName;
                drtData.Unique_DRT_Name__c = revisedDRTName;
                drtData.Description__c = strDesc;
                drtData.Customer_Name__c = objDRTDetail.Customer_Name__c;
                drtData.type__c = objDRTDetail.Type__c;
                drtData.Mask_Set_Title__c = objDRTDetail.Mask_Set_Title__c;
                drtData.Tech_Geo__c = objDRTDetail.Tech_Geo__c;
                drtData.Old_Rev_DRT__c = objDRTDetail.Id;
                
                if(action == 'Activate')  {
                    // check if activation allowed or not
                    if(!DRTHandlerUtility.isRevisedDRTActivationAllowed(revisedDRTName)){
                        string errorMessage ;                        
                        errorMessage = mapEC.get('DRT versions linked to Closed PTRF').Message__c;                        
                        lstDRTErrorMessage.add(errorMessage);
                        return null;
                    }
                    drtData.Status__c='Active';
                    objDRTDetail.status__c = 'Inactive';                    
                }
                else {
                    drtData.Status__c='Draft';  
                } 
                
                /* prepare PRIME_DRT_Chip_Association__c data   */
                
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
                
                /* prepare PRIME_DRT_Chip_Layer_Summary__c data */
        
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
                    
                    if(null != hasShippedLayer && null != isSaveByUser && hasShippedLayer && isSaveByUser) {//swgp-269: gate submiting drt for shipped layer at page load
                        //none-to-do-code
                    } else {
                        //swgp-269
                        if(null != hasShippedLayer && null != isSaveByUser && hasShippedLayer && !isSaveByUser) isSaveByUser = true;//below codes inside this outer ELSE is only ran 1 time at page load
                        if(objDRTErrorDetails.error) saveError = true;

                        // add error messages to page
                        lstDRTErrorMessage.addAll(objDRTErrorDetails.MainTableError.setErrorMessage);                        
                        lstDRTErrorMessage.addAll(objDRTErrorDetails.MaskLayerHeaderError.setErrorMessage);
                        lstDRTErrorMessage.addAll(objDRTErrorDetails.MaskLayerContentError.setErrorMessage);

                        for(Integer i=0; i<lstDRTErrorMessage.size(); i++) {
                            //Note: Retrofit Mask Layer <LAYER_UNIQUE> had already been shipped. No changes are allowed on Shipped layer(s).
                            //swgp-269
                            //the compared error message was originated from Error_Code__c.UNIQUE_COMBINATION_ERROR_MRS
                            //any change to UNIQUE_COMBINATION_ERROR_MRS need to modify below as well
                            //UNIQUE_COMBINATION_ERROR_SHIPPED_LAYER: message to show at page load of drt revise/update page if there are any shipped layers
                            String shippedError = Error_Codes__c.getInstance('UNIQUE_COMBINATION_ERROR_MRS').Message__c;
                            String s = Error_Codes__c.getInstance('UNIQUE_COMBINATION_ERROR_SHIPPED_LAYER').Message__c;
                            if(lstDRTErrorMessage.get(i).containsIgnoreCase(shippedError)) {                                
                                lstDRTErrorMessage.remove(i);
                                lstDRTErrorMessage.add(s);
                                break;
                            }
                        }
                        
                        // set json data indicating hightlight locations
                        mainTableErrorJSON = objDRTErrorDetails.MainTableError.errorJSON;
                        maskLayerErrorJSON = objDRTErrorDetails.MaskLayerHeaderError.errorJSON;
                        maskLayerContentErrorJSON = objDRTErrorDetails.MaskLayerContentError.errorJSON;
                    }
                }
                Savepoint sp = Database.setSavepoint();
                Id insertedDRTId;
                try {
                    if(!saveError) {
                        insertedDRTId = DRTHandlerUtility.insertDRT(drtData,lsDRTLayerAssoc,lstDRTChipAssoc,lsDRTChipLayerAssoc);
                        if(insertedDRTId != null && drtData.Status__c =='Active'){
                            DRTHandlerUtility.revisedDRTFunctionality(drtData.Name,insertedDRTId);
                            if(action == 'Activate') {
                                DRTHandlerUtility.sendMassEmailOnDRTRevision(insertedDRTId,objDRTDetail.Name);
                            }   
                        }
                    }
                }
                catch (Exception e){
                    Database.rollback(sp);
                    if(e.getMessage().containsIgnoreCase('Unique_DRT_Name__c')) {
                        string errorMsg = Error_Codes__c.getInstance('Unique_DRT_Name_Error').Message__c.replace('{DRTName}',drtData.Name);
                        lstDRTErrorMessage.add(errorMsg);
                        // Regenerate DRT revision
                        revisedDRTName = objDRTHandlerUtility.generateNextRevisedDRTName(objDRTDetail.Name);
                        return null;
                    }
                    lstDRTErrorMessage.add(e.getMessage());
                    return null;
                }
                if(insertedDRTId != null) {
                    return new Pagereference('/apex/vfdrtdetail?Id='+insertedDRTId+'&urlFromPage=Revise');
                }
                return null;
    }
    
   /**
   * @description: This class is used to deserialize JSON response from page. 
   **/
   @TestVisible private class MainTableClass {
        String chipName;
        String mstId;
        public MainTableClass(String chipName,String mstId) {
            this.chipName = chipName;
            this.mstId = mstId;
        }
    }
   
   /**
    * @description: This class is used to deserialize JSON response from page. 
    --------------------
    backend object: PRIME_DRT_Layer_Association__c
    **/ 
   @TestVisible private class MaskLayerHeaderClass {
        String layerNo;
        String retrofitMaskRev;
        String retrofitROMCode;
        //swgp-2
        boolean isEdited_retrofitMaskRev;
        boolean isEdited_retrofitROMCode;
        //swgp-2-end
        public MaskLayerHeaderClass(String layerNo,String retrofitMaskRev,String retrofitROMCode) {
            this.layerNo = layerNo;
            this.retrofitMaskRev = retrofitMaskRev;
            this.retrofitROMCode = retrofitROMCode;
            
            //swgp-2
            
            //swgp-2-end
        }
    }
    
    /**
    * @description: This class is used to deserialize JSON response from page. 
    --------------------
    backend object: PRIME_DRT_Chip_Layer_Summary__c
    **/
    @TestVisible private class MaskLayerContentClass {
        String maskRev;
        String romCode;
        //swgp-2
        boolean isEdited_maskRev;
        boolean isEdited_romCode;
        //swgp-2-end
        public MaskLayerContentClass(String maskRev,String romCode) {
            this.maskRev = maskRev;
            this.romCode = romCode;
            
            //swgp-2
            
            //swgp-2-end
        }
    }
   
    /**
    * @description: This class is used to deserialize Frame DRT JSON response from page.    
    --------------------
    backend object: Frame_DRT_Association__c
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
            this.retroMaskRev = retroMaskRev.toUpperCase();
            this.retroROMCode = retroROMCode.toUpperCase();
            this.maskRev = maskRev.toUpperCase();
            this.romCode = romCode.toUpperCase();
            
            //swgp-2
            
            //swgp-2-end
        }
    }
    
   /**
    * @description: This method is called on clicking of Add Retrofit Layer button. Used to populate list of Mask Layers in Add Retrofit Layer page.
    * @param: none
    * @return: Pagereference
    **/
   public Pagereference populateMaskLayers() {
        if(maskLayerList != null && !maskLayerList.isEmpty()){
            return null;
        }
        maskLayerList = new List<MaskLayerRow>();
        string baseMST = objDRTDetail.Mask_Set_Title__c;
        string drtType = objDRTDetail.Type__c;
        string techGeo = objDRTDetail.Tech_Geo__c;
        if(!String.isBlank(baseMST) && !String.isBlank(drtType)) {
            Integer counter = 0;
            lstPopulatedMaskLayers.addAll(DRTHandlerUtility.fetchMaskLayers(baseMST,drtType,techGeo));
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
             if(pastMaskRev!=null && pastMaskRev!=''){
            this.pastMaskRev = pastMaskRev.toUpperCase();
            }
             if(pastROMCode!=null && pastROMCode!=''){
            this.pastROMCode = pastROMCode.toUpperCase();           
            }
        }
    }
    
    /**
    * @description: This class is used as a wrapper class for Mask Layers
    **/
    public class MaskLayerHeaderWrapper {
        public ID layerID{get;set;}
        public string layerNo{get;set;}
        public string counter{get;set;}
        public string retroftMaskRev{get;set;}
        public string retroftROMCode{get;set;}
        public string htmlId{get;set;}
                
        public MaskLayerHeaderWrapper(string counter, ID layerID,String layerNo,String retroftMaskRev,String retroftROMCode) {
            this.counter = counter;
            this.layerID = layerID;
            this.layerNo = layerNo;
            if(retroftMaskRev!=null){
                this.retroftMaskRev=retroftMaskRev.toUpperCase();
            }
            if(retroftROMCode!=null){
                this.retroftROMCode=retroftROMCode.toUpperCase();
            }
        }            
    }
    
    /**
    * @description: This class is used as a wrapper class for the left table in DRT.
    **/
    public class ChipWrapper {
        public string chipID{get;set;}
        public string counter{get;set;}
        public string mstId {get; set;}
        public string mstName{get;set;}
        public string chipName{get;set;}
        public string colorClass {get;set;}
        
        public ChipWrapper(string counter,string chipId,string chipName,string mstId,String mstName) {
            this.counter = counter;  
            this.chipId = chipId;
            this.mstId = mstId;
            this.mstName = mstName;               
            this.chipName = chipName;
            this.colorClass='';
            if(Math.mod(Integer.valueOf(counter),2)==0) {
                this.colorClass = DRTHandlerUtility.alternateColorClass;
            }
        }                  
    }
    
    /**
    * @description: This method is used to fetch Frame DRT data from database
    * @param: Id idDRTId
    * @return: List<DRTHandlerUtility.FrameDRTWrapper>
    **/
    private List<DRTHandlerUtility.FrameDRTWrapper> fetchFrameDRTData(Id idDRTId) {
        string jsonData;
        DRTHandlerUtility.FrameDRTWrapper objFrameDRTWrapper;
        List<DRTHandlerUtility.FrameDRTWrapper> lstFrameWrapper = new List<DRTHandlerUtility.FrameDRTWrapper>();
        integer counter = 1;
        for(Frame_DRT_Association__c frameDrtObj : DRTHandlerUtility.fetchFrameDRTAssociation(idDRTId)) {
            objFrameDRTWrapper = new DRTHandlerUtility.FrameDRTWrapper(counter,frameDrtObj.Mask_Set_Title__c,frameDrtObj.Mask_Set_Title__r.Name,frameDrtObj.Mask_Layer_No__c ,frameDrtObj.Retrofit_Mask_Rev__c ,frameDrtObj.Retrofit_ROM_Code__c ,frameDrtObj.Mask_Rev__c ,frameDrtObj.ROM_Code__c);
            lstFrameWrapper.add(objFrameDRTWrapper);
            counter ++;
        }
        return lstFrameWrapper; 
    }
   
    /**
    * @description: This method is used to save Frame DRT.
    * @param: string action
    * @return: Pagereference
    **/
    public Pagereference saveFrameDRT(String action) {
        // flag indicating if any error occurred
        Boolean saveError = false;
        // clear list of error messages
        if(lstDRTErrorMessage != null){
            lstDRTErrorMessage.clear();
        }
        
        /* Prepare DRT__c data */
        
        DRT__c drtData = new DRT__c();        
        drtData.Name = revisedDRTName;
        drtData.Unique_DRT_Name__c = revisedDRTName;        
        drtData.Customer_Name__c = objDRTDetail.Customer_Name__c ;
        drtData.type__c = objDRTDetail.type__c ;
        drtData.Mask_Set_Title__c = objDRTDetail.Mask_Set_Title__c ;
        drtData.Tech_Geo__c = objDRTDetail.Tech_Geo__c;
        drtData.Description__c = strDesc;
        drtData.Old_Rev_DRT__c = objDRTDetail.Id;
        
        if(action == 'Draft') {
            drtData.status__c = 'Draft';         
        }
        else if(action == 'Activate'){
            // check if activation allowed or not
            if(!DRTHandlerUtility.isRevisedDRTActivationAllowed(revisedDRTName)){
                
                String errorMessage =  mapEC.get('DRT versions linked to Closed PTRF').Message__c;
                lstDRTErrorMessage.add(errorMessage);
                return null;
            }
                    
            drtData.status__c = 'Active';
            objDRTDetail.status__c = 'Inactive'; 
        }
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
                    if(!String.isBlank(frameDRTAssocObj.Mask_Rev__c)) {
                        frameDRTAssocObj.Mask_Rev__c = frameDRTAssocObj.Mask_Rev__c.toUpperCase();
                    }                    
                    frameDRTAssocObj.ROM_Code__c = frameRow.romCode;
                    if(frameDRTAssocObj.ROM_Code__c != null && frameDRTAssocObj.ROM_Code__c != '') {
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
                
                if(null != hasShippedLayer && null != isSaveByUser && hasShippedLayer && isSaveByUser ) {//swgp-269: gate submiting drt for shipped layer at page load
                    //none-to-do-code
                } else {
                    //swgp-269
                    if(null != hasShippedLayer && null != isSaveByUser && hasShippedLayer && !isSaveByUser) isSaveByUser = true;//below codes inside this outer ELSE is only ran 1 time at page load
                    if(objFrameErrorDetails.error) saveError = true;

                    // add error messages to page
                    lstDRTErrorMessage.addAll(objFrameErrorDetails.setErrorMessage);
                    
                    //swgp-269
                    for(Integer i=0; i<lstDRTErrorMessage.size(); i++) {
                        //repeated code...i know...
                        //the compared error message was originated from Error_Code__c.UNIQUE_COMBINATION_ERROR_MRS
                        //any change to UNIQUE_COMBINATION_ERROR_MRS need to modify below as well
                        //UNIQUE_COMBINATION_ERROR_SHIPPED_LAYER: message to show at page load of drt revise/update page if there are any shipped layers
                        String shippedError = Error_Codes__c.getInstance('UNIQUE_COMBINATION_ERROR_MRS').Message__c;
                        String s = Error_Codes__c.getInstance('UNIQUE_COMBINATION_ERROR_SHIPPED_LAYER').Message__c;
                        if(lstDRTErrorMessage.get(i).containsIgnoreCase(shippedError)) {                                
                            lstDRTErrorMessage.remove(i);
                            lstDRTErrorMessage.add(s);
                            break;
                        }
                    }//swgp-269-end
                                  
                    // set json data indicating hightlight locations                
                    frameTableErrorJSON = objFrameErrorDetails.errorJSON;
                }
            }
            
            Savepoint sp = Database.setSavepoint();
            Id insertedDRTId;
            try {           
                if(!saveError) {
                    //update objDRTDetail;
                    insertedDRTId = DRTHandlerUtility.insertFrameDRT(drtData,lstFrameDRTAssoc);
                    if(drtData.Status__c == 'Active' && insertedDRTId != null){
                        DRTHandlerUtility.revisedDRTFunctionality(drtData.Name,insertedDRTId);
                        if(action == 'Activate') {
                            DRTHandlerUtility.sendMassEmailOnDRTRevision(insertedDRTId,objDRTDetail.Name);
                        }
                    }
                }
            }
            catch(Exception e) {
                Database.rollBack(sp);
                if(e.getMessage().containsIgnoreCase('Unique_DRT_Name__c')) {
                    string errorMsg = Error_Codes__c.getInstance('Unique_DRT_Name_Error').Message__c.replace('{DRTName}',drtData.Name);
                    lstDRTErrorMessage.add(errorMsg);
                    // Regenerate DRT revision
                    revisedDRTName = objDRTHandlerUtility.generateNextRevisedDRTName(objDRTDetail.Name);
                    return null;
                }
                lstDRTErrorMessage.add(e.getMessage());           
                return null;
            }
            if(insertedDRTId != null) {
                return new Pagereference('/apex/vfdrtdetail?Id='+insertedDRTId+'&urlFromPage=Revise');
            }
        return null;
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
    * @param: string mstId,string selectedLayerNo,string techGeo
    * @return: List<List<String>>
    **/  
    @RemoteAction
    global static List<List<String>> fetchMaskRevROMCode(String mstId,String selectedLayerNo,String techGeo) {
        return DRTHandlerUtility.fetchMaskRevROMCode(mstId,selectedLayerNo,techGeo);
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
        mapDisplayedMaskLayerData = objDRTHandlerUtility.fetchMaskRevROMCodeList(objDRTDetail.Mask_Set_Title__c,objDRTDetail.Type__c,objDRTDetail.Tech_Geo__c,
                                                                                 lstSelectedMaskLayer,mainTableChipList,
                                                                                 lstPopulatedMaskLayers,layerCount);
        selectedMaskLayerJSON = '';
        mainTableChipListJSON = '';
        // set global count of added mask layers
        layerCount += lstSelectedMaskLayer.size();
        return null;
    }
    
    /**
    * @description: This method is used to validate whether rows can be deleted from DRT table or not.
    * @param: none
    * @return: Pagereference
    **/
    public Pagereference validateChipDeletion() {
        string drtName = objDRTDetail.Name;
        list<DRTHandlerUtility.ChipWrapper> lstChipWrapper = (list<DRTHandlerUtility.ChipWrapper>)JSON.deserialize(selectedChipsJSON,list<DRTHandlerUtility.ChipWrapper>.class);
        list<string> lstChips = DRTHandlerUtility.fetchChipsForDeletion(drtName,lstChipWrapper);
        delChipsJSON = JSON.serialize(lstChips);
        if(lstChips != null && !lstChips.isEmpty()) {
            string errorMessage = mapEC.get('Prime Dies/Scribeline dropins PTRF').Message__c;
            set<string> setErrMsg = new set<string>();
            setErrMsg.addAll(lstDRTErrorMessage);
            setErrMsg.add(errorMessage);
            lstDRTErrorMessage.clear();
            lstDRTErrorMessage.addAll(setErrMsg);
        }
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