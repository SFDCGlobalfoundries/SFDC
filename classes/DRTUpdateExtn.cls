/*
Author: Cognizant Technology Solutions
Company: 
Description:    This will be the controller class behind the Visualforce Page VFDRTUpdate. 
                This will also call the handler class DRTHandlerUtility which will contain 
                all the business logic regarding the DRT Updating process.
History:
    Cognizant     18032014     - Initial Version
    Cognizant     11052014     - Changes in function updatePrimeDRT for bug fixing
*/

global class DRTUpdateExtn {
    //swgp-269
    public boolean hasShippedLayer {get;set;}//a flag to check at page load whether any shipped layer or not
    public boolean isSaveByUser {get;set;}//a flag to determine that user clicks on Save & Activate button
    public boolean isNewDrt {get;set;}
    //swgp-269-end
    
    private List<PRIME_DRT_Layer_Association__c> lstPrimeDRTLayerAssociation;
    private List<PRIME_DRT_Chip_Association__c> lstPrimeDRTChipAssociation;
    public DRT__c objDRTDetail{get;set;}
    public boolean isPrimeDRT {get;set;}
    public boolean isFrameDRT {get;set;}      
    private List<PRIME_DRT_Chip_Layer_Summary__c> lstPrimeDrtSummary;          
    public String mainTableJSON{get; set;}
    public String maskLayerHeaderJSON{get; set;}
    public String maskLayerContentJSON{get; set;}
    public String maskLayerJSON{get; set;}
    public transient List<MaskLayerHeaderWrapper> maskLayerHeaderWrapperList{get;set;}     
    public transient List<ChipWrapper> chipWrapperList{get;set;}
    public String addRowMSTString {get; private set;}
    public List<SelectOption> mstOptions{get; set;}
    private Map<String,String> mstMap {get; private set;}
    public String selectedAccount {get; set;}
    public String baseMST {get; set;} 
    public String baseMSTName { get; set;}    
    public DRTHandlerUtility.DRTWrapper drtWrapper {get;set;}
    public  Boolean isTechGeoNull {get;set;}
    public  Boolean isBreadcrumbActive {get;set;}
    
    public List<MaskLayerRow> maskLayerList {get; private set;}    
    public List<DRTHandlerUtility.FrameDRTWrapper> lstFrameDRTWrapper {get;set;} 
    public String frameTableJSON {get; set;}
    private static Id drtId;
    private List<Frame_DRT_Association__c> lstFrameDRTAssociation;
    public String strDesc{get; set;}
    public String fromPage{get; set;}
    
    // error json
    public String mainTableErrorJSON {get;  set;}
    public String maskLayerErrorJSON {get; set;}
    public String maskLayerContentErrorJSON {get; set;}
    public String frameTableErrorJSON {get; set;}
    public list<String> lstDRTErrorMessage {get;  set;}
        
    private DRTHandlerUtility objDRTHandlerUtility;
    
    public static Map<String, Error_Codes__c> mapEC = Error_Codes__c.getAll();
    private Integer internalVersion;
    
    public String selectedMaskLayerJSON {get; set;}
    public List<DRTHandlerUtility.MaskLayerWrapper> lstSelectedMaskLayer {get; set;}
    public list<DRTHandlerUtility.ChipWrapper> mainTableChipList {get;set;}
    public string mainTableChipListJSON {get;set;}
    public string selectedChipsJSON {get;set;}
    public string delChipsJSON {get;set;}
    public transient map<string,map<string,DRTHandlerUtility.MaskRevROMCodeWrapper>> mapDisplayedMaskLayerData {get;set;}
    
    public list<Mask_Layer__c> lstPopulatedMaskLayers;
    private integer layerCount {get;set;} // global count of no of added layers to prevent duplicate html id  
    
    public static string blankText = '---';
    public string noLayerAvailableErrorMsg {get;set;}
    
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
    * @param: ApexPages.StandardController objController
    * @return: none
    **/
    public DRTUpdateExtn(ApexPages.StandardController objController) {
          string idDRTId = ApexPages.currentPage().getParameters().get('id');
          lstPopulatedMaskLayers = new list<Mask_Layer__c>();
          lstSelectedMaskLayer = new list<DRTHandlerUtility.MaskLayerWrapper>();
          layerCount = 0;
          lstDRTErrorMessage = new list<String>();
          maskLayerList = new List<MaskLayerRow>();
          String url = ApexPages.currentPage().getHeaders().get('Host');
          
          if(Label.SWIFT_Community_URL.contains(url)){ isBreadcrumbActive = true; } else { isBreadcrumbActive = false; }
            
          try {
              objDRTHandlerUtility = new DRTHandlerUtility();
              objDRTDetail = DRTHandlerUtility.fetchDRTDetails(idDRTId);
              drtWrapper = new DRTHandlerUtility.DRTWrapper(objDRTDetail);
              internalVersion = Integer.valueOf(objDRTDetail.Internal_Version__c);
              if(internalVersion == null) {
                  internalVersion = 0;
              }
              if(objDRTDetail.Status__c != 'Draft') {
                  return;
              }
              if(!string.isBlank(objDRTDetail.Tech_Geo__c)){
                  isTechGeoNull = true;
              }
              drtId = idDRTId;
              strDesc = objDRTDetail.description__c;
              isPrimeDRT = false;
              isFrameDRT = false;
              if(objDRTDetail.Type__c!=null && objDRTDetail.Type__c.equalsIgnorecase('prime')) {
                    isPrimeDRT = true;
                    isFrameDRT = false;
              }
              else if(objDRTDetail.Type__c!=null && objDRTDetail.Type__c.equalsIgnorecase('frame')){
                    isFrameDRT = true;
                    isPrimeDRT = false;
              }  
              if(ApexPages.currentPage().getParameters().containsKey('urlFromPage')) { fromPage = ApexPages.currentPage().getParameters().get('urlFromPage'); }
                                       
              if(!string.isBlank(objDRTDetail.Type__c) && objDRTDetail.Type__c.equalsIgnoreCase('prime')) {
                  list<PRIME_DRT_Chip_Layer_Summary__c> lstChipLayerSummary = getPrimeDRTChipLayerSummaryList(idDRTId);
                  mapDisplayedMaskLayerData = objDRTHandlerUtility.fetchPrimeDRTMaskRevROMCodeData(lstChipLayerSummary);//swgp-2
                  setDRTDataToWrapper(idDRTId);                  
                  populateMSTOptions();
                  
              }
              else if(!string.isBlank(objDRTDetail.Type__c) && objDRTDetail.Type__c.equalsIgnoreCase('frame')) {
                  lstFrameDRTWrapper = fetchFrameDRTData(idDRTId);
                  populateMSTOptions();
                  
              }
              
              
            //swgp-269: will need to check for layer status and set a flag to indicate there are at least 1 layer is shipped >>> flag true
            //====================================================================
            //if this drt is new >>> no check at page load for shipped layer
            if(null == objDRTDetail.Old_Rev_DRT__c) {
                isNewDrt = true;
                return;
            }
            isNewDrt = false;
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
              
              
          }catch(Exception e) {
          }       
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
    * @description: This method is used to lock the DRT record when performing DML Update.
    * @param: Id recId
    * @return: Integer
    **/   
   private Integer lockRecord(Id recId) {
            DRT__c drtForLock = [SELECT Id,Internal_Version__c FROM DRT__c WHERE Id = :recId FOR UPDATE];
            Integer version = Integer.valueOf(drtForLock.Internal_Version__c);
            if(version==null) {
                version=0;
            }
            return version;           
    }

    /**
    * @description: This method is used to populate Mask Layers in Add Retrofit Layer page.
    * @param: none
    * @return: Pagereference
    **/
    public Pagereference populateMaskLayers() {
        if(MaskLayerList != null && !MaskLayerList.isEmpty()){
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
    * @description: This method is used to populate Mask Set Title dropdown
    * @param: none
    * @return: void
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
            selectedAccount=objDRTDetail.customer_name__c  ;          
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
    * @param: string selectedMST,string techGeo,string idOfDRT
    * @return: list<String>
    **/
    @RemoteAction
    global static List<String> fetchChipNames(string selectedMST,string techGeo,string idOfDRT) {        
        Set<String> setChipName = new Set<String>();
        list<String> lstChipName = new List<String>();
        if(!string.isBlank(selectedMST)) {
        List<Chip_Detail__c> lstChipDetail = DRTHandlerUtility.fetchChipDetails(selectedMST,techGeo);
            if(lstChipDetail != null && !lstChipDetail.isEmpty()) { for(Chip_Detail__c chip : lstChipDetail) { setChipName.add(chip.Name); } }
            
            if(!string.isBlank(idOfDRT)) {
                for(PRIME_DRT_Chip_Association__c deletedChip : [SELECT Id,Name FROM PRIME_DRT_Chip_Association__c 
                                                                            WHERE DRT__c =:idOfDRT 
                                                                            AND Mask_Set_Title__c = :selectedMST 
                                                                            AND IsSoftDeleted__c = true]) {
                   setChipName.add(deletedChip.Name); 
                }                    
            }
        }
        lstChipName.addAll(setChipName);
        return lstChipName;
     }

    /**
    * @description: This method is used to save Prime DRT
    * @param: string status
    * @return: Pagereference
    **/
    private Pagereference savePrimeDRT(string status) {
        // flag indicating if any error occurred
        Boolean saveError = false;
        // clear list of error messages
        if(lstDRTErrorMessage != null){
            lstDRTErrorMessage.clear();
        }
        if(status == 'Active') {
            // check if activation allowed or not
            if(!DRTHandlerUtility.isRevisedDRTActivationAllowed(objDRTDetail.Name)){ String errorMessage =  mapEC.get('DRT versions linked to Closed PTRF').Message__c; lstDRTErrorMessage.add(errorMessage); return null; }
        }                   
        /* Prepare DRT__c data */
        
        DRT__c drtData = objDRTDetail;
        drtData.Status__c = status;       
        drtData.description__c=strDesc ;
        
        /* prepare PRIME_DRT_Chip_Association__c data   */
        
        // parse JSON response for Main Table data
        List<MainTableClass> lstMainTableData = (List<MainTableClass>)JSON.deserialize(mainTableJSON,List<MainTableClass>.class);        
        
        List<PRIME_DRT_Chip_Association__c> lstDRTChipAssoc = new List<PRIME_DRT_Chip_Association__c>();        
        if(lstMainTableData != null && !lstMainTableData.isEmpty()) {
            PRIME_DRT_Chip_Association__c objPrimeDrtChipAssoc;
            for(MainTableClass mainTableRow : lstMainTableData) {
                objPrimeDrtChipAssoc = new PRIME_DRT_Chip_Association__c();
                if(!String.isBlank(mainTableRow.chipId)){
                    objPrimeDrtChipAssoc.Id = mainTableRow.chipId;
                }
                // if new record is 
                objPrimeDrtChipAssoc.Name = mainTableRow.chipName;                    
                
                if(!String.isBlank(mainTableRow.mstId)) { objPrimeDrtChipAssoc.Mask_Set_Title__c = mainTableRow.mstId; } else { objPrimeDrtChipAssoc.Mask_Set_Title__c  = null; }
                                
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
                if(!String.isBlank(maskLayerHeaderRow.layerId)){
                    objPrimeDrtLayerAssoc.ID = maskLayerHeaderRow.layerId;
                }
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
                    if(!String.isBlank(tableRow.summaryId)){
                        objPrimeDrtChipLayerAssoc.Id = tableRow.summaryId;
                    }
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
            
            //swgp-269: gate submiting drt for shipped layer at page load
            if(null != hasShippedLayer && null != isSaveByUser && hasShippedLayer && isSaveByUser) {
                //none-to-do-code
            } else {
                //swgp-269
                if(null != hasShippedLayer && null != isSaveByUser && !isNewDrt && hasShippedLayer && !isSaveByUser) isSaveByUser = true;
        
                if(objDRTErrorDetails.error) saveError = true;
                 
                // add error messages to page
                lstDRTErrorMessage.addAll(objDRTErrorDetails.MainTableError.setErrorMessage);
                lstDRTErrorMessage.addAll(objDRTErrorDetails.MaskLayerHeaderError.setErrorMessage);
                lstDRTErrorMessage.addAll(objDRTErrorDetails.MaskLayerContentError.setErrorMessage);
                
                //swgp-269
                for(Integer i=0; i<lstDRTErrorMessage.size(); i++) {
                    //repeated code...i know...
                    //the compared error message was originated from Error_Code__c.UNIQUE_COMBINATION_ERROR_MRS
                    //any change to UNIQUE_COMBINATION_ERROR_MRS need to modify below as well
                    //UNIQUE_COMBINATION_ERROR_SHIPPED_LAYER: message to show at page load of drt revise/update page if there are any shipped layers
                    String shippedError = Error_Codes__c.getInstance('UNIQUE_COMBINATION_ERROR_MRS').Message__c;
                    String s = Error_Codes__c.getInstance('UNIQUE_COMBINATION_ERROR_SHIPPED_LAYER').Message__c;
                    if(lstDRTErrorMessage.get(i).containsIgnoreCase(shippedError)) { lstDRTErrorMessage.remove(i); lstDRTErrorMessage.add(s); break; }
                }//swgp-269-end
                
                // set json data indicating hightlight locations
                mainTableErrorJSON = objDRTErrorDetails.MainTableError.errorJSON;
                maskLayerErrorJSON = objDRTErrorDetails.MaskLayerHeaderError.errorJSON;
                maskLayerContentErrorJSON = objDRTErrorDetails.MaskLayerContentError.errorJSON;
            }
        }
        
        Boolean isSuccess = false;
        if(!saveError) {
            isSuccess = updatePrimeDRT(drtData,lsDRTLayerAssoc,lstPrimeDRTLayerAssociation,lstDRTChipAssoc,lstPrimeDRTChipAssociation,lsDRTChipLayerAssoc,lstPrimeDrtSummary);
            if(isSuccess && drtData.Status__c =='Active'){ DRTHandlerUtility.revisedDRTFunctionality(drtData.Name,drtData.Id); sendMailOnActivation(drtData.Id,drtData.Old_Rev_DRT__r.Name); }
        }
        if(isSuccess) { return new Pagereference('/apex/vfdrtdetail?Id='+drtData.ID+'&urlFromPage=Update'); }
        return null;
       }
      
      /**
      * @description: This method is called on 'Save as Draft' action. Used to save the DRT in Draft status.
      * @param: none
      * @return: Pagereference
      **/ 
      public Pagereference saveAsDraft() {
           if(objDRTDetail.type__c.equalsIgnoreCase('prime')) {
                    return savePrimeDRT('Draft');
                }
           else if(objDRTDetail.type__c.equalsIgnoreCase('frame')) { return saveFrameDRT('Draft'); } return null;     
      }
      
      /**
      * @description: This method is called on 'Save & Activate' action. Used to save and activate the DRT.
      * @param: none
      * @return: Pagereference
      **/
      public Pagereference saveAsActive() {
           if(objDRTDetail.type__c.equalsIgnoreCase('prime')) {
                    return savePrimeDRT('Active');
                }
           else if(objDRTDetail.type__c.equalsIgnoreCase('frame')) { return saveFrameDRT('Active'); } return null;          
      }
    
     /**
     * @description: This method contains the update logic when saving a DRT.
     * @param: none
     * @return: Boolean
     **/
     private Boolean updatePrimeDRT(DRT__c recordDRT,List<PRIME_DRT_Layer_Association__c> newLayerList,
                                        List<PRIME_DRT_Layer_Association__c> oldLayerList,
                                        List<PRIME_DRT_Chip_Association__c> newChipList,
                                        List<PRIME_DRT_Chip_Association__c> oldChipList,
                                        List<PRIME_DRT_Chip_Layer_Summary__c> newChipLayerSummary,
                                        List<PRIME_DRT_Chip_Layer_Summary__c> oldChipLayerSummary) {
        
        database.saveresult uResultDRT ;
        ID idDRTOld;
        List<PRIME_DRT_Layer_Association__c> pdLayerInsertList ;      
        List<PRIME_DRT_Layer_Association__c> pdLayerUpdateList ;
        List<PRIME_DRT_Layer_Association__c> pdLayerDeleteList ;
        Set<String> setNewPDLayer = new Set<String>();            
        List<PRIME_DRT_Chip_Association__c> pdChipInsertList ;      
        List<PRIME_DRT_Chip_Association__c> pdChipUpdateList ;
        List<PRIME_DRT_Chip_Association__c> pdChipDeleteList ;
        Set<String> setNewPDChip =  new Set<String>();
        List<PRIME_DRT_Chip_Layer_Summary__c> pdCLSummaryInsertList ;      
        List<PRIME_DRT_Chip_Layer_Summary__c> pdCLSummaryUpdateList ;
        List<PRIME_DRT_Chip_Layer_Summary__c> pdCLSummaryDeleteList ;
        Set<String> setNewPDCLSummary = new Set<String>();        
        List<ID> lstLayerID;
        List<ID> lstChipID;
        List<Database.saveresult> lstResultLayerInsert;        
        List<Database.saveresult> lstResultChipInsert;
        integer intCounter=0;
        list<DRTHandlerUtility.ChipWrapper> lstChipsForDelete = new list<DRTHandlerUtility.ChipWrapper>();
        Boolean isSuccess = true;
        Savepoint sp = Database.setSavepoint();
        
        try {   
                Integer internalVersionMod = lockRecord(recordDRT.Id);
                if(internalVersion != internalVersionMod) {
                   Database.rollBack(sp);
                   string errorMsg = Error_Codes__c.getInstance('DRT_Concurrent_Modification_Error').Message__c;
                   lstDRTErrorMessage.add(errorMsg);
                   isSuccess = false;
                   return isSuccess;     
                }
                else {
                    recordDRT.Internal_Version__c = internalVersion+1;
                }
                uResultDRT = Database.update(recordDRT);
                
                if (uResultDRT.isSuccess())
                {
                    idDRTOld = uResultDRT.getId();
                                                           
                    lstLayerID = new List<ID>();
                    lstChipID = new List<ID>();
                                                           
                    pdLayerInsertList = new List<PRIME_DRT_Layer_Association__c>();
                    pdLayerUpdateList = new List<PRIME_DRT_Layer_Association__c>();
                    pdLayerDeleteList = new List<PRIME_DRT_Layer_Association__c>(); 
                    
                                     
                    for (PRIME_DRT_Layer_Association__c objLayerNew : newLayerList)
                        {
                                if(objLayerNew.ID!=null)
                                {
                                     pdLayerUpdateList.add(objLayerNew);
                                     setNewPDLayer.add(objLayerNew.ID);
                                     lstLayerID.add(objLayerNew.ID);                                    
                                }
                                else
                                {
                                     objLayerNew.drt__c = recordDRT.id;
                                     objLayerNew.isCreatedLater__c = true;
                                     pdLayerInsertList.add(objLayerNew);                                  
                                }
                        }                                              
                     if(oldLayerList!=null && oldLayerList.size()>0)
                    {                    
                        for(PRIME_DRT_Layer_Association__c objLayerOld:oldLayerList)
                        {
                            if(objLayerOld.ID!=null){
                                if(!setNewPDLayer.contains(objLayerOld.ID)){
                                    objLayerOld.IsSoftDeleted__c = true;
                                    pdLayerDeleteList.add(objLayerOld);
                                }                                
                            }                            
                        }
                    }
                    
                    // DML on Layer list
                    lstResultLayerInsert = insertUpdateDeleteData(pdLayerInsertList,pdLayerUpdateList,pdLayerDeleteList);
                    if(lstResultLayerInsert != null && !lstResultLayerInsert.isEmpty()) {
                        for(Database.saveresult resultChipTemp : lstResultLayerInsert ) 
                        {
                            if (resultChipTemp.isSuccess())
                            {
                               lstLayerID.add(resultChipTemp.getId());
                            }                        
                        }
                    }

                    pdChipInsertList =new List<PRIME_DRT_Chip_Association__c>();
                    pdChipUpdateList =new List<PRIME_DRT_Chip_Association__c>();
                    pdChipDeleteList =new List<PRIME_DRT_Chip_Association__c>(); 
                                  
                    for (PRIME_DRT_Chip_Association__c objChipNew:newChipList)
                        {
                            if(objChipNew.ID!=null)
                            {
                                 pdChipUpdateList.add(objChipNew);
                                 setNewPDChip.add(objChipNew.ID); 
                                 lstChipID.add(objChipNew.ID);                                 
                            }
                            else
                            {
                                 objChipNew.drt__c=recordDRT.id;
                                 objChipNew.isCreatedLater__c=true;
                                 pdChipInsertList.add(objChipNew);
                            }
                       }             
                     if(oldChipList!=null && oldChipList.size()>0)
                    {                    
                        for(PRIME_DRT_Chip_Association__c objChipOld:oldChipList)
                        {
                            if(objChipOld.ID!=null){
                                if(!setNewPDChip.contains(objChipOld.ID)){
                                    objChipOld.IsSoftDeleted__c = true;
                                    pdChipDeleteList.add(objChipOld);
                                    lstChipsForDelete.add(new DRTHandlerUtility.ChipWrapper(objChipOld.Mask_Set_Title__c,objChipOld.Name));
                                }                                
                            }                            
                        }
                    }
                    // validate whether chips can be deleted or not
                    list<string> lstNonremovableChips = DRTHandlerUtility.fetchChipsForDeletion(recordDRT.Name, lstChipsForDelete);
                    if(lstNonremovableChips != null && !lstNonremovableChips.isEmpty()) {
                        string errorMessage  = mapEC.get('Prime Dies/Scribeline dropins PTRF').Message__c;
                        lstDRTErrorMessage.add(errorMessage);
                        
                        Database.rollback(sp);
                        isSuccess = false;
                        return isSuccess;
                    }
                    
                    lstResultChipInsert=insertUpdateDeleteData(pdChipInsertList,pdChipUpdateList,pdChipDeleteList);
                    if(lstResultChipInsert!= null && !lstResultChipInsert.isEmpty()) {
                         for(Database.saveresult resultChipTemp:lstResultChipInsert ) 
                        {
                            if (resultChipTemp.isSuccess())
                            {
                               lstChipID.add(resultChipTemp.getId());
                            }                        
                        }
                    }
                    
                    pdCLSummaryInsertList = new List<PRIME_DRT_Chip_Layer_Summary__c>();
                    pdCLSummaryUpdateList = new List<PRIME_DRT_Chip_Layer_Summary__c>();
                    pdCLSummaryDeleteList = new List<PRIME_DRT_Chip_Layer_Summary__c>(); 
                    
                    for (ID objLayerId : lstLayerID)
                        {
                            for (ID objChipId : lstChipID)
                            {
                                if(newChipLayerSummary[intCounter].Id==null)
                                {
                                    newChipLayerSummary[intCounter].Chip__c=objChipId; 
                                    newChipLayerSummary[intCounter].Layer__c=objLayerId;                                     
                                }                                
                                intCounter++;
                            }     
                        }                   
                    for (PRIME_DRT_Chip_Layer_Summary__c objChipLayerSummaryNew:newChipLayerSummary)
                        {
                                if(objChipLayerSummaryNew.ID!=null)
                                {
                                     pdCLSummaryUpdateList.add(objChipLayerSummaryNew);
                                     setNewPDCLSummary.add(objChipLayerSummaryNew.ID);                                      
                                }
                                else
                                {
                                     pdCLSummaryInsertList.add(objChipLayerSummaryNew); 
                                }
                        }
                    insertUpdateDeleteData(pdCLSummaryInsertList,pdCLSummaryUpdateList,pdCLSummaryDeleteList);                   
                }
            } 
            catch (Exception e){
                isSuccess = false;
                Database.rollback(sp);
                if(e.getMessage().containsIgnoreCase(Error_Codes__c.getInstance('DRT_Lock_SFDC_Error').Message__c)) { string errorMsg = Error_Codes__c.getInstance('DRT_Lock_Error').Message__c; lstDRTErrorMessage.add(errorMsg); return isSuccess; }
                lstDRTErrorMessage.add(e.getMessage());
                return isSuccess;
            }            
            return isSuccess;                  
       }
    
    /**
    * @description: This method is used to perform DML operations when updating a DRT.
    * @param: List<SObject> insertList,List<SObject> updateList,List<SObject> deleteList
    * @return: List<Database.saveresult>
    **/
    @TestVisible
    private static List<Database.saveresult> insertUpdateDeleteData(List<SObject> insertList,List<SObject> updateList,List<SObject> deleteList) {
        List<Database.saveresult> listResult = new List<Database.saveresult>();
        if(insertList!=null && insertList.size()>0){
            listResult=Database.insert(insertList,true);
        }
        if(updateList!=null && updateList.size()>0){
            Database.update(updateList,true);
        }
        if(deleteList!=null && deleteList.size()>0){
            Database.update(deleteList,true);  // soft delete          
        }
        return listResult ;     
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
                    maskRev = (string.isBlank(maskRev))?blankText:maskRev;
                    romCode = (string.isBlank(romCode))?blankText:romCode;
                    objMaskLayerHeaderWrapper=new MaskLayerHeaderWrapper(string.valueOf(counter),objPDLayer.Id,objPDLayer.Name,maskRev,romCode);
                    objMaskLayerHeaderWrapper.htmlId = string.valueOf(counter);
                    
                    //swgp-2
                    objMaskLayerHeaderWrapper.isEdited_retrofitMaskRev = objPDLayer.Is_Edited_Retrofit_Mask_Rev__c;
                    objMaskLayerHeaderWrapper.isEdited_retrofitROMCode = objPDLayer.Is_Edited_Retrofit_ROM_Code__c;
                    //swgp-2-end
                    
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
    * @description: This class is used to deserialize JSON response from page
    **/
    @TestVisible private class MainTableClass {
        String chipName;
        String mstId;
        String chipId;
        public MainTableClass(String chipName,String mstId,String chipId) {
            this.chipName = chipName;
            this.mstId = mstId;
            this.chipId = chipId;
        }
    }
    
    /**
    * @description: This class is used to deserialize JSON response from page
    **/
    @TestVisible private class MaskLayerHeaderClass {
        String layerNo;
        String retrofitMaskRev;
        String retrofitROMCode;
        String layerId;
        
        //swgp-2
        boolean isEdited_retrofitMaskRev;
        boolean isEdited_retrofitROMCode;
        //swgp-2-end
        
        public MaskLayerHeaderClass(String layerNo,String retrofitMaskRev,String retrofitROMCode, ID layerId) {
            this.layerNo = layerNo;
            if(retrofitMaskRev!=null && retrofitMaskRev!=''){
                this.retrofitMaskRev = retrofitMaskRev.toUpperCase();
            }
            if(retrofitROMCode!=null && retrofitROMCode!=''){
                this.retrofitROMCode = retrofitROMCode.toUpperCase();
            }
            this.layerId = layerId;
        }
    }
    
    /**
    * @description: This class is used to deserialize JSON response from page
    **/
    @TestVisible private class MaskLayerContentClass {
        String maskRev;
        String romCode;
        String summaryId;
        
        //swgp-2
        boolean isEdited_maskRev;
        boolean isEdited_romCode;
        //swgp-2-end
        
        public MaskLayerContentClass(String maskRev,String romCode,String summaryId) {
            if(maskRev!=null && maskRev!=''){
            this.maskRev = maskRev.toUpperCase();
            }
            if(romCode!=null && romCode!=''){
            this.romCode = romCode.toUpperCase();
            }
            this.summaryId = summaryId;
        }
    }
    
    /**
    * @description: This class is used as a wrapper class for Mask Layers
    **/
    public class MaskLayerHeaderWrapper {
        public ID layerID{get;set;}
        public String layerNo{get;set;}
        public string counter{get;set;}
        public String retroftMaskRev{get;set;}
        public String retroftROMCode{get;set;}
        public string htmlId {get; set;}
        
        //swgp-2
        public boolean isEdited_retrofitMaskRev {get;set;}
        public boolean isEdited_retrofitROMCode {get;set;}
        //swgp-2-end
        
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
    * @description: This class is used as a wrapper class for Mask Layers in Add Retrofit Layer page.
    **/
    public class MaskLayerRow {
        public Integer no {get; set;}
        public String layerNo {get; set;}
        public String pastMaskRev {get; set;}
        public String pastROMCode {get; set;}
        
        //swgp-2
        public boolean isEdited_maskRev {get;set;}
        public boolean isEdited_romCode {get;set;}
        //swgp-2-end
        
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
    * @description: This class is used to deserialize Frame DRT JSON response from page
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
            if(retroMaskRev !=null && retroMaskRev !=''){
                this.retroMaskRev = retroMaskRev.toUpperCase();
            }
            if(retroROMCode!=null && retroROMCode!=''){
                this.retroROMCode = retroROMCode.toUpperCase();
            }
            if(maskRev!=null && maskRev!=''){
                this.maskRev = maskRev.toUpperCase();
            }
            if(romCode!=null && romCode!=''){
                this.romCode = romCode.toUpperCase();
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
        lstFrameDRTAssociation = DRTHandlerUtility.fetchFrameDRTAssociation(idDRTId);
        for(Frame_DRT_Association__c frameDrtObj : lstFrameDRTAssociation) {
            objFrameDRTWrapper = new DRTHandlerUtility.FrameDRTWrapper(counter,frameDrtObj.Mask_Set_Title__c,frameDrtObj.Mask_Set_Title__r.Name,frameDrtObj.Mask_Layer_No__c ,frameDrtObj.Retrofit_Mask_Rev__c ,frameDrtObj.Retrofit_ROM_Code__c ,frameDrtObj.Mask_Rev__c ,frameDrtObj.ROM_Code__c);
            
            //swgp-2
            objFrameDRTWrapper.isEdited_retroMaskRev = frameDrtObj.Is_Edited_Retrofit_Mask_Rev__c;
            objFrameDRTWrapper.isEdited_retroROMCode = frameDrtObj.Is_Edited_Retrofit_ROM_Code__c;
            //swgp-2-end
            
            lstFrameWrapper.add(objFrameDRTWrapper);
            counter ++;
        }
        return lstFrameWrapper; 
    }
    
    /**
    * @description: This method populates Mask Layer dropdown in Add Row of FRAME DRT table. Called on change of Mask Set Title dropdown in Add Row.
    * @param: string mstId,string techGeo
    * @return: set<string>
    **/
    @RemoteAction
    global static Set<string> fetchLayerNos(string mstId,string techGeo) {
        return DRTHandlerUtility.fetchLayerNos(mstId,techGeo);
    } 
    
    /**
    * @description: This method populates Mask Rev and ROM Code dropdown in Add Row of FRAME DRT table. Called on change of Mask Layer in Add Row.
    * @param: string mstId,string selectedLayerNo,string techGeo
    * @return: List<List<String>>
    **/
    @RemoteAction
    global static List<List<string>> fetchMaskRevROMCode(string mstId,string selectedLayerNo,string techGeo) {
        return DRTHandlerUtility.fetchMaskRevROMCode(mstId,selectedLayerNo,techGeo);
    }    
    
    /**
    * @description: This method is used to save Frame DRT.
    * @param: string status
    * @return: Pagereference
    **/
    private Pagereference saveFrameDRT(string status) {
        // flag indicating if any error occurred
        Boolean saveError = false;
        // clear list of error messages
        if(lstDRTErrorMessage != null){
            lstDRTErrorMessage.clear();
        }
        if(status == 'Active') {
            // check if activation allowed or not
            if(!DRTHandlerUtility.isRevisedDRTActivationAllowed(objDRTDetail.Name)){ String errorMessage = mapEC.get('DRT versions linked to Closed PTRF').Message__c; lstDRTErrorMessage.add(errorMessage); return null; }
        }  
        /* Prepare DRT__c data */
        
        DRT__c drtData = objDrtDetail;               
        drtData.status__c = status;         
        drtData.description__c=strDesc ;
        
        /** Prepare Frame_DRT_Association__c data **/
        
        // parse JSON response for Frame Layer table data
        List<FrameTableClass> lstFrameTableData = (List<FrameTableClass>)JSON.deserialize(frameTableJSON,List<FrameTableClass>.class);
        
        List<Frame_DRT_Association__c> lstFrameDRTAssoc = new List<Frame_DRT_Association__c>();        
        Frame_DRT_Association__c frameDRTAssocObj;
        if(lstFrameTableData != null && !lstFrameTableData.isEmpty()) {
            for(FrameTableClass frameRow : lstFrameTableData) {
                frameDRTAssocObj = new Frame_DRT_Association__c();
                frameDRTAssocObj.DRT__c = drtData.Id;
                if(!String.isBlank(frameRow.mstId)) { frameDRTAssocObj.Mask_Set_Title__c = frameRow.mstId; } else { frameDRTAssocObj.Mask_Set_Title__c  = null; }
                
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
            
            //swgp-269: gate submiting drt for shipped layer at page load
            if(null != hasShippedLayer && null != isSaveByUser && hasShippedLayer && isSaveByUser) {
                //none-to-do-code
            } else {
                
                //swgp-269
                if(null != hasShippedLayer && null != isSaveByUser && !isNewDrt && hasShippedLayer && !isSaveByUser) isSaveByUser = true;
                
                if(objFrameErrorDetails.error) { saveError = true; }
                
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
        
        Boolean isSuccess = false;
        Savepoint sp = Database.setSavepoint();
        try {
            if(!saveError) {
                updateFrameDRT(drtData ,lstFrameDRTAssoc ,lstFrameDRTAssociation);
                if(drtData.Status__c =='Active'){
                    DRTHandlerUtility.revisedDRTFunctionality(drtData.Name,drtData.Id);
                    sendMailOnActivation(drtData.Id,drtData.Old_Rev_DRT__r.Name);
                }
                isSuccess = true;
            }
        }
        catch (DmlException e) {
            isSuccess = false;
            Database.rollback(sp);
            ApexPages.addMessages(e);               
        } 
        if(isSuccess) { return new Pagereference('/apex/vfdrtdetail?Id='+drtData.id+'&urlFromPage=Update'); }
        return null;
    }      
    
    /**
    * @description: This method contains the update logic for saving Frame DRT.
    * @param: DRT__c recordDRT,List<Frame_DRT_Association__c> newFrameDataList,List<Frame_DRT_Association__c> oldFrameDataList
    * @return: void
    **/
    private void updateFrameDRT(DRT__c recordDRT,List<Frame_DRT_Association__c> newFrameDataList,List<Frame_DRT_Association__c> oldFrameDataList) {
        
        Database.saveresult uResultDRT ;  
        string idDRTOld ;    
        List<Frame_DRT_Association__c> pdFrameInsertList ;      
        List<Frame_DRT_Association__c> pdFrameUpdateList ;
        List<Frame_DRT_Association__c> pdFrameDeleteList ;
        Set<String> setNewPDFrame = new Set<String>();            
       
        integer intCounter=0;
        
        idDRTOld = recordDRT.Id;
                                               
        pdFrameInsertList = new List<Frame_DRT_Association__c>();
        pdFrameUpdateList = new List<Frame_DRT_Association__c>();
        pdFrameDeleteList = new List<Frame_DRT_Association__c>(); 
        for (Frame_DRT_Association__c objFrameNew : newFrameDataList) {
            if(objFrameNew .ID!=null) { pdFrameUpdateList.add(objFrameNew ); setNewPDFrame .add(objFrameNew .ID); }
            else { objFrameNew .drt__c = recordDRT.id; pdFrameInsertList .add(objFrameNew ); }
        }
        if(oldFrameDataList!=null && oldFrameDataList.size()>0)
        {                    
            for(Frame_DRT_Association__c objFrameOld:oldFrameDataList)
            {
                if(objFrameOld.ID!=null){
                    if(!setNewPDFrame .contains(objFrameOld.ID)){
                        pdFrameDeleteList.add(objFrameOld);
                    }                                
                }                            
            }
        }
        if(pdFrameInsertList !=null && pdFrameInsertList .size()>0){
            Database.insert(pdFrameInsertList ,true);
        }
        if(pdFrameUpdateList !=null && pdFrameUpdateList .size()>0){
            Database.update(pdFrameUpdateList ,true);
        }
        if(pdFrameDeleteList !=null && pdFrameDeleteList .size()>0){
            Database.delete(pdFrameDeleteList ,true);
        }               
        uResultDRT = Database.update(recordDRT);
                       
       }
    
    /**
    * @description: This method is used to send email notification when saving and activating a DRT
    * @param: Id savedDRTId, string oldDRTName
    * @return: void
    **/
    @TestVisible 
    private void sendMailOnActivation(Id savedDRTId, string oldDRTName) {
        if(string.isBlank(oldDRTName)) {
            DRTHandlerUtility.sendMassEmailOnDRTActivation(savedDRTId, !notSendEmail);
        }
        else {
            DRTHandlerUtility.sendMassEmailOnDRTRevision(savedDRTId,oldDRTName);
        }
    }
    
    /**
    * @description: This method is called on clicking 'Add' button in Add Retrofit Layer page. Used to add the selected Mask Layers to the DRT table.
    * @param: none
    * @return: Pagereference
    **/
    public Pagereference addMaskLayers() {
        // deserialize selected mask layers
        lstSelectedMaskLayer = (list<DRTHandlerUtility.MaskLayerWrapper>)JSON.deserialize(selectedMaskLayerJSON,list<DRTHandlerUtility.MaskLayerWrapper>.class);
        if(lstSelectedMaskLayer==null||lstSelectedMaskLayer.isEmpty()){ return null; }
        
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