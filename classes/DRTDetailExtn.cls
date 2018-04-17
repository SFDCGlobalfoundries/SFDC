/*
Author: Cognizant Technology Solutions
Company: 
Description:    This will be the controller class behind the Visualforce Page VFDRTDetail. 
                This will also call the handler class DRTHandlerUtility which will contain all 
                the business logic regarding the DRT Detail, Copy, Delete, Cancel process. 
History:
    Cognizant     18032014     - Initial Version
    Cognizant     23032014     - Modified function saveFrameDRT change in save logic
    Cognizant     15052014     - Modified for adding Device__c column for fetching 
                                 device id to display the information in where used Tab
*/
public class DRTDetailExtn
{
    public  Id drtId {get;set;}
    public  DRT__c drtObj{get;set;}
    public  Boolean isStatusActive{get;set;}
    public  Boolean isCopyActive{get;set;}
    public  Boolean isUpdateActive{get;set;}
    public  Boolean isReviseActive{get;set;}
    public  Boolean isDeleteActive{get;set;}
    public  Boolean isCancelActive{get;set;}
    public  Boolean isBreadcrumbActive {get;set;}
    public  Boolean isTechGeoNull {get;set;}
    public  String savedCustomerName{get;set;}
    public  String savedMaskSetTitle{get;set;}
    public  String savedDRTType{get;set;}
    public  String savedTechGeo{get;set;}
    public  String savedStatus{get;set;}
    public  String description{get;set;}
    public  String drtDescription{get;set;}
    public string  currentUrl {get;set;}
    
    public transient List<PTRFDrtAssoWrapper> PTRFDrtAssoWrapperlst {get;set;}
    public transient List<DRTHandlerUtility.AuditTrail> drtAuditTrailWrappLst {get ;set;}
    public transient List<MaskLayerWrapper> maskLayerslst {get;set;}
    public transient Boolean drtPrimeType {get; set;}
    public transient Boolean drtFrameType {get; set;}
    public transient List<Frame_DRT_Association__c> frameDRTLst {get ;set;}
    public transient Map<String,DRTHandlerUtility.MaskRevROMCodeWrapper> keyChipLayerMap {get ;set;}
    public transient String drtName {get;set;}
    public transient List<chipDetailsWrapper> chipDetailsWrapperlst{get;set;}
    public transient List<frameClass> lstframe {get;set;}
    public transient List<String> lstDummy {get; set;}
    
    public static Map<String, Error_Codes__c> mapEC = Error_Codes__c.getAll();
    
    public String type {get; set;}
    public String fromPage{get; set;}
    public List<String> lstDRTErrorMessage {get;  private set;}
    
    private List<PRIME_DRT_Layer_Association__c> primeDRTLayerAssociationList;
    private List<PRIME_DRT_Chip_Association__c> primeDRTChipAssociationList;
    
    private List<DRT_PTRF_Association__c> drtPTRFAssociation;
    private DRTHandlerUtility objDRTHandlerUtility;
    private Integer internalVersion;
    
    private List<PRIME_DRT_Layer_Association__c> lstPrimeDRTLayerAssociation;
    private List<PRIME_DRT_Chip_Association__c> lstPrimeDRTChipAssociation;
    public transient List<ChipWrapper> chipWrapperList{get;set;}
    public transient List<MaskLayerHeaderWrapper> maskLayerHeaderWrapperList{get;set;}
    public transient map<string,map<string,DRTHandlerUtility.MaskRevROMCodeWrapper>> mapDisplayedMaskLayerData {get;set;}
    
    /**
    * @description: This is the constructor
    * @param: ApexPages.StandardController controller
    * @return: none
    **/    
    public DRTDetailExtn(ApexPages.StandardController controller) {
        objDRTHandlerUtility = new DRTHandlerUtility();
        lstDummy = new List<String>();
        lstDummy.add('dummy'); // used in generating alternate highlight
        lstDRTErrorMessage = new list<String>();
        
        String url = ApexPages.currentPage().getHeaders().get('Host');
        if(Label.SWIFT_Community_URL.contains(url)){
            isBreadcrumbActive = true;
            currentUrl = Label.SWIFT_Community_URL;
        }
        else {
            isBreadcrumbActive = false;
            currentUrl = Label.Internal_URL;
        }
        if(ApexPages.currentPage().getParameters().containsKey('urlFromPage')) {
            fromPage = ApexPages.currentPage().getParameters().get('urlFromPage');
            
        }
        // get DRT Id from page parameter
        drtId = ApexPages.currentPage().getParameters().get('Id');
        if(drtId != null) {
            fetchDRTDetails();
            if(drtFrameType) {
                frameDRTLst = DRTHandlerUtility.fetchFrameDRTAssociation(drtId);//include new flag of isEdited
                lstframe  = new List<frameClass>();
                frameClass  frameWrapperObj;
                if(frameDRTLst !=null)
                {
                    Integer srlNo =1;
                    for(Frame_DRT_Association__c frameObj :frameDRTLst)
                    {
                        Boolean color  ;
                        if(Math.mod(srlNo,2)==0)
                            color  =true;
                          else
                             color =false;
                        frameWrapperObj = new frameClass(srlno,frameObj.Mask_Set_Title__r.Name,frameObj.Mask_Layer_No__c,frameObj.Retrofit_Mask_Rev__c,frameObj.Retrofit_ROM_Code__c,frameObj.Mask_Rev__c,frameObj.ROM_Code__c,color);
                        //swgp-2
                        frameWrapperObj.isEdited_retroMaskRev = frameObj.Is_Edited_Retrofit_Mask_Rev__c;
                        frameWrapperObj.isEdited_retroROMCode = frameObj.Is_Edited_Retrofit_ROM_Code__c;
                        //swgp-2-end
                        lstframe.add(frameWrapperObj);
                        srlNo ++;
                    }
                }
            }
            else if(drtPrimeType) {
                list<PRIME_DRT_Chip_Layer_Summary__c> lstChipLayerSummary = getPrimeDRTChipLayerSummaryList(drtId);
                mapDisplayedMaskLayerData = objDRTHandlerUtility.fetchPrimeDRTMaskRevROMCodeData(lstChipLayerSummary);//include new flag of isEdited
                string blankText = DRTHandlerUtility.blankText;
                for(string key : mapDisplayedMaskLayerData.keySet()) {
                    map<string,DRTHandlerUtility.MaskRevROMCodeWrapper> mObject =  mapDisplayedMaskLayerData.get(key);
                    for(DRTHandlerUtility.MaskRevROMCodeWrapper mObj : mObject.values()){
                        mObj.MaskRev = (mObj.MaskRev == blankText)?'':mObj.MaskRev;
                        mObj.RomCode = (mObj.RomCode == blankText)?'':mObj.RomCode;
                    }
                }  
                setDRTDataToWrapper(drtId);
            }
            //-------------Where Use tab---------------------//
            
            drtPTRFAssociation = DRTHandlerUtility.fetchDrtPTRFAssociation(drtId);
            PTRFDrtAssoWrapperlst  = new List<PTRFDrtAssoWrapper>();
            PTRFDrtAssoWrapper ptrfDRTWrapperObj;
            if(drtPTRFAssociation != null && !drtPTRFAssociation.isEmpty()) {
                Boolean color = false;
                for(DRT_PTRF_Association__c drtPTRFAssoObj : drtPTRFAssociation ) {
                    
                    ptrfDRTWrapperObj = new PTRFDrtAssoWrapper(drtPTRFAssoObj.PTRF__c,drtPTRFAssoObj.PTRF__r.Name,drtPTRFAssoObj.PTRF__r.Status__c,drtPTRFAssoObj.PTRF__r.MaskSetTitle__r.Name,
                                                               drtPTRFAssoObj.PTRF__r.Device_Id__c,drtPTRFAssoObj.PTRF__r.Frame_Tapeout__c,drtPTRFAssoObj.PTRF__r.Frame_Mockup__c,
                                                               drtPTRFAssoObj.PTRF__r.Prime_Tapeout__c,drtPTRFAssoObj.PTRF__r.Prime_GDSOUT_Review__c,drtPTRFAssoObj.PTRF__r.DRC_Only__c,color);
                    PTRFDrtAssoWrapperlst.add(ptrfDRTWrapperObj);
                    color = (!color)?true:false;
                }
            }
            
            //---------------End of Where Use tab ----------------------------//
            
            //----------------- Audit Trail Tab -------------------------//
            
            list<DRT__History> lstDRTHistory = DRTHandlerUtility.fetchDRTHistory(drtId);        
            list<PRIME_DRT_Chip_Association__History> lstPrimeDRTChipAssocHistory = DRTHandlerUtility.fetchPrimeDRTChipAssocHistory(drtId);
            list<PRIME_DRT_Layer_Association__History> lstPrimeDRTLayerAssocHistory = DRTHandlerUtility.fetchPrimeDRTLayerAssocHistory(drtId);
                
            drtAuditTrailWrappLst = DRTHandlerUtility.fetchDRTAuditTrail(drtObj,lstDRTHistory,lstPrimeDRTChipAssocHistory,
                                                                                   lstPrimeDRTLayerAssocHistory);
            //-------------------End Of Audit Trail Tab -----------------------//
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
    * @description: This class is used as a wrapper class for Mask Layers
    **/
   public class MaskLayerHeaderWrapper {
        public ID layerID{get;set;}
        public String layerNo{get;set;}
        public String retroftMaskRev{get;set;}
        public String retroftROMCode{get;set;}
        
        //swgp-2
        public boolean isEdited_retrofitMaskRev {get;set;}
        public boolean isEdited_retrofitROMCode {get;set;}
        //swgp-2-end
        
        public MaskLayerHeaderWrapper(ID layerID,String layerNo,String retroftMaskRev,String retroftROMCode) {
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
    * @description: This method is used to generate the wrapper object list for showing Mask Layers in the DRT when opened in Update page.
    * @param: ID idDRT
    * @return: void
    **/
    private void setDRTDataToWrapper(ID idDRT) {
        MaskLayerHeaderWrapper  objMaskLayerHeaderWrapper;
        ChipWrapper objChipWrapper;
        if(lstPrimeDRTLayerAssociation != null && !lstPrimeDRTLayerAssociation.isEmpty()) {
             maskLayerHeaderWrapperList = new List<MaskLayerHeaderWrapper>();
             for (PRIME_DRT_Layer_Association__c objPDLayer:lstPrimeDRTLayerAssociation ) {
                    string maskRev,romCode;
                    maskRev = objPDLayer.Retrofit_Mask_Rev__c;
                    romCode = objPDLayer.Retrofit_ROM_Code__c;
                    objMaskLayerHeaderWrapper=new MaskLayerHeaderWrapper(objPDLayer.Id,objPDLayer.Name,maskRev,romCode);
                    
                    //swgp-2
                    objMaskLayerHeaderWrapper.isEdited_retrofitMaskRev = objPDLayer.Is_Edited_Retrofit_Mask_Rev__c;
                    objMaskLayerHeaderWrapper.isEdited_retrofitROMCode = objPDLayer.Is_Edited_Retrofit_ROM_Code__c;
                    //swgp-2-end
                    
                    maskLayerHeaderWrapperList.add(objMaskLayerHeaderWrapper);
             }         
        }
        if(lstPrimeDRTChipAssociation != null && !lstPrimeDRTChipAssociation.isEmpty()) {
             chipWrapperList = new List<ChipWrapper>();
             integer counter = 1;
             for (PRIME_DRT_Chip_Association__c objPDChip:lstPrimeDRTChipAssociation ) {
                  objChipWrapper = new ChipWrapper(string.valueOf(counter),objPDChip.id,objPDChip.Name,objPDChip.Mask_Set_Title__c,objPDChip.Mask_Set_Title__r.Name);
                  chipWrapperList.add(objChipWrapper); 
                  counter++;
             }                 
        }
    }
    
    /**
    * @description: This method is used to fetch DRT object details from database.
    * @param: none
    * @return: void
    **/
    public void fetchDRTDetails() {
        drtObj=DRTHandlerUtility.fetchDRTDetails(drtId);
        if(drtId!=null){
            drtName = drtObj.Name;
            savedMaskSetTitle =drtObj.Mask_Set_Title__r.Name;
            savedCustomerName=drtObj.Customer_Name__r.Name+' ('+drtObj.Customer_Short_Name__c+')';
            savedDRTType = drtObj.Type__c;
            savedStatus=drtObj.Status__c;
            savedTechGeo=drtObj.Tech_Geo__c;
            description=drtObj.Description__c;
            internalVersion = Integer.valueOf(drtObj.Internal_Version__c);
            if(internalVersion == null) {
                internalVersion = 0;
            }
            if(savedDRTType != null && savedDRTType.equalsIgnoreCase('PRIME'))
            {
                drtPrimeType=true;
                drtFrameType =false;
            }else
            {
                drtFrameType =true;
                drtPrimeType=false;
            }
             if(savedTechGeo != null)
             {
                 isTechGeoNull =true;
             }
            if(savedStatus=='Active'){
                isCopyActive = true;
                isUpdateActive = false; 
                isReviseActive = true;
                isDeleteActive = false;
                isCancelActive = true;
            }
            else if(savedStatus=='Draft'){
                isCopyActive = true;
                isUpdateActive = true; 
                isReviseActive = false;
                isDeleteActive = true;
                isCancelActive = false;
            }
            else if(savedStatus=='Inactive'){
                isCopyActive = true;
                isUpdateActive = false; 
                isReviseActive = false;
                isDeleteActive = false;
                isCancelActive = false;
            }
            else if(savedStatus=='Cancel'){
                isCopyActive = true;
                isUpdateActive = false; 
                isReviseActive = false;
                isDeleteActive = false;
                isCancelActive = false;
            }
            else if(savedStatus=='Deleted'){
                isCopyActive = true;
                isUpdateActive = false; 
                isReviseActive = false;
                isDeleteActive = false;
                isCancelActive = false;
            }
            else if(savedStatus=='Closed'){
                isCopyActive = true;
                isUpdateActive = false; 
                isReviseActive = false;
                isDeleteActive = false;
                isCancelActive = false;
            }
        }
        if(drthandlerutility.isEditDRTApplicable(drtObj)==false){
             isCopyActive = false;
             isUpdateActive = false; 
             isReviseActive = false;
             isDeleteActive = false;
             isCancelActive = false;
        }
   }
   
   /**
    * @description: This method is used to lock the DRT record when performing DML Update.
    * @param: Id recId
    * @return: Integer
    **/ 
   private integer lockRecord(Id recId) {
       DRT__c drtForLock = [SELECT Id,Internal_Version__c FROM DRT__c WHERE Id = :recId FOR UPDATE];
       Integer version = Integer.valueOf(drtForLock.Internal_Version__c);
       if(version==null) {
           version=0;
       }
       return version;           
   }
    
   /**
    * @description: This method is used to redirect to DRT revise page.
    * @param: none
    * @return: PageReference
    **/ 
   public PageReference redirectToRevise() {
       // clear list of error messages
       if(lstDRTErrorMessage != null){
           lstDRTErrorMessage.clear();
       }
       //added as to change the error message
       List<DRT_PTRF_Association__c> drtPtrfAssociationList=[select id,PTRFNumber__c from DRT_PTRF_Association__c where drt__c=:drtId and PTRF_Status__c='Closed' ];
       if(drtPtrfAssociationList != null && !drtPtrfAssociationList.isEmpty()){
            String commaSeparatedPtrfNameStr='';
            for(DRT_PTRF_Association__c dpa : drtPtrfAssociationList){
                if(dpa.PTRFNumber__c != null && dpa.PTRFNumber__c != ''){
                    commaSeparatedPtrfNameStr += dpa.PTRFNumber__c + ',';
                } 
            }
            commaSeparatedPtrfNameStr = commaSeparatedPtrfNameStr.lastIndexOf(',') > 0 ? commaSeparatedPtrfNameStr.substring(0,commaSeparatedPtrfNameStr.lastIndexOf(',')) : commaSeparatedPtrfNameStr;
            commaSeparatedPtrfNameStr = '\"'+commaSeparatedPtrfNameStr+'\"';
            String errMsg=string.format(mapEC.get('DRT REVISE NOT ALLOWED').Message__c, new string[] {commaSeparatedPtrfNameStr});
            lstDRTErrorMessage.add(errMsg);
       }
       
       if(lstDRTErrorMessage != null && !lstDRTErrorMessage.isEmpty()){
            return null;
       }
       
       Pagereference pgRef = new Pagereference('/apex/VFDRTRevise?id='+drtId+'&urlFromPage='+fromPage);
       pgRef.setRedirect(true);
       return pgRef;
    }
   
    /**
    * @description: This method is used to redirect to DRT update page.
    * @param: none
    * @return: PageReference
    **/
    public PageReference redirectToUpdate() { 
       Pagereference pgRef = new Pagereference('/apex/VFDRTUpdate?id='+drtId+'&urlFromPage='+fromPage);
       pgRef.setRedirect(true);
       return pgRef;
    }
    
    /**
    * @description: This method is used to cancel an Active DRT.
    * @param: none
    * @return: PageReference
    **/
    public PageReference redirectToCancel() {
       // clear list of error messages
       if(lstDRTErrorMessage != null){
           lstDRTErrorMessage.clear();
       }
       Savepoint sp = Database.setSavepoint();
       try {
           drtPTRFAssociation = DRTHandlerUtility.fetchDrtPTRFAssociation(drtId);
           if(drtObj.Status__c == 'Active' && drtPTRFAssociation != null && (drtPTRFAssociation.size()>0)) {
              string errorMsg = Error_Codes__c.getInstance('DRT_LINKED_TO_PTRF_CANCEL_ERROR').Message__c;
              lstDRTErrorMessage.add(errorMsg);
              return null;
           }
           Integer internalVersionMod = lockRecord(drtObj.Id);
           if(internalVersion != internalVersionMod) {
                string errorMsg = Error_Codes__c.getInstance('DRT_Concurrent_Modification_Error').Message__c;
                lstDRTErrorMessage.add(errorMsg);
                return null;     
           }
           else {
                drtObj.Internal_Version__c = internalVersion+1;
           }           
           drtObj.Status__c = 'Cancel';
           update drtObj;
           Pagereference pgRef = new Pagereference('/apex/VFDRTDetail?id='+drtId+'&urlFromPage='+fromPage);
           pgRef.setRedirect(true);
           return pgRef;
       }catch (Exception e){
           Database.rollback(sp);
           if(e.getMessage().containsIgnoreCase(Error_Codes__c.getInstance('DRT_Lock_SFDC_Error').Message__c)) {
               string errorMsg = Error_Codes__c.getInstance('DRT_Lock_Error').Message__c;
               lstDRTErrorMessage.add(errorMsg);
               return null;                
           }
           lstDRTErrorMessage.add(e.getMessage());
           return null;
       }
    }
    
    /**
    * @description: This method is used to delete a DRT in draft status.
    * @param: none
    * @return: PageReference
    **/
    public PageReference redirectToDelete(){
       // clear list of error messages
       if(lstDRTErrorMessage != null){
           lstDRTErrorMessage.clear();
       }
       Savepoint sp = Database.setSavepoint();
       try {
           Integer internalVersionMod = lockRecord(drtObj.Id);
           if(internalVersion != internalVersionMod) {
                string errorMsg = Error_Codes__c.getInstance('DRT_Concurrent_Modification_Error').Message__c;
                lstDRTErrorMessage.add(errorMsg);
                return null;     
           }
           else {
                drtObj.Internal_Version__c = internalVersion+1;
           }
           drtObj.Status__c = 'Deleted';
           update drtObj;
           Pagereference pgRef = new Pagereference('/apex/VFDRTDetail?id='+drtId+'&urlFromPage='+fromPage);
           pgRef.setRedirect(true);
           return pgRef;
       }catch (Exception e){
           Database.rollback(sp);
           if(e.getMessage().containsIgnoreCase(Error_Codes__c.getInstance('DRT_Lock_SFDC_Error').Message__c)) {
               string errorMsg = Error_Codes__c.getInstance('DRT_Lock_Error').Message__c;
               lstDRTErrorMessage.add(errorMsg);
               return null;                
           }
           lstDRTErrorMessage.add(e.getMessage());
           return null;
       }
    }
    
    /**
    * @description: This method is used to copy a DRT.
    * @param: none
    * @return: PageReference
    **/
    public PageReference redirectToCopy(){
        // clear list of error messages
        if(lstDRTErrorMessage != null){
            lstDRTErrorMessage.clear();
        }
        Savepoint sp = Database.setSavepoint();
        DRT__c newDRTObject;
        Id drtIdObj;
        try {
            newDRTObject = new DRT__c(Name='DRT',Customer_Name__c=drtObj.Customer_Name__c,Description__c=drtObj.Description__c,
                                          Last_Sync_Req_Timestamp__c=drtObj.Last_Sync_Req_Timestamp__c,Mask_Set_Title__c=drtObj.Mask_Set_Title__c,
                                          Old_Rev_DRT__c=null,Status__c='Draft',Type__c=drtObj.Type__c,Tech_Geo__c = drtObj.Tech_Geo__c,
                                          Copied_From__c = drtObj.Id);
            
            // generate next DRT name                              
            newDRTObject.Name = objDRTHandlerUtility.generateNextDRTName(drtObj.Mask_Set_Title__c,drtObj.Mask_Set_Title__r.Name,drtObj.Type__c);
            newDRTObject.Unique_DRT_Name__c = newDRTObject.Name; // set unique DRT Name
            
            if(drtObj.Type__c!=null && drtObj.Type__c.equalsIgnorecase('prime')){
                List<PRIME_DRT_Chip_Association__c> lstCopyPrimeDRTChip = lstPrimeDRTChipAssociation.deepClone();              
                List<PRIME_DRT_Layer_Association__c> lstCopyPrimeDRTLayer = lstPrimeDRTLayerAssociation.deepClone();
                list<PRIME_DRT_Chip_Layer_Summary__c> lstCopyPrimeDRTChipLayerSummary = new list<PRIME_DRT_Chip_Layer_Summary__c>();
                
                map<string,PRIME_DRT_Chip_Layer_Summary__c> primeDRTChipLayerSummaryMap = new map<string,PRIME_DRT_Chip_Layer_Summary__c>() ;
                for(PRIME_DRT_Chip_Layer_Summary__c drtChipLayer : getPrimeDRTChipLayerSummaryList(drtId)) {   
                    string key = drtChipLayer.Layer__c+':'+drtChipLayer.Chip__c;
                    
                    //swgp-2 reset flag for copying, new copy drt should have new fresh data pull from system
                    //without the reset here, new copy drt would has edited flag as source drt (showing orange in edit page)
                    drtChipLayer.Is_Edited_Mask_Layer_Rev__c = false;
                    drtChipLayer.Is_Edited_ROM_Code__c = false;
                    //swgp-2-end
                    
                    primeDRTChipLayerSummaryMap.put(key,drtChipLayer);
                }
                
                Integer i = 0;//swgp-2
                for(PRIME_DRT_Layer_Association__c layer : lstPrimeDRTLayerAssociation) {
                    
                    //swgp-2 reset flag for copying, new copy drt should have new fresh data pull from system
                    //without the reset here, new copy drt would has edited flag as source drt (showing orange in edit page)
                    lstCopyPrimeDRTLayer[i].Is_Edited_Retrofit_Mask_Rev__c = false;
                    lstCopyPrimeDRTLayer[i].Is_Edited_Retrofit_ROM_Code__c = false;
                    i++;
                    //swgp-2-end
                    
                    for(PRIME_DRT_Chip_Association__c chip : lstPrimeDRTChipAssociation) {
                        string key = layer.Id+':'+chip.Id;
                        if(primeDRTChipLayerSummaryMap.containsKey(key)) {
                            PRIME_DRT_Chip_Layer_Summary__c newChipLayerObj = primeDRTChipLayerSummaryMap.get(key);
                            newChipLayerObj.Id = null;
                            lstCopyPrimeDRTChipLayerSummary.add(newChipLayerObj);
                        }
                    }
                }
                drtIdObj = DRTHandlerUtility.insertDRT(newDRTObject,lstCopyPrimeDRTLayer,lstCopyPrimeDRTChip,lstCopyPrimeDRTChipLayerSummary);
                
            }
            else if(drtObj.Type__c!=null && drtObj.Type__c.equalsIgnorecase('frame')){
                insert newDRTObject;
                list<Frame_DRT_Association__c> frameDRTList = [SELECT Id,Name,DRT__c,Mask_Layer_No__c,DRT_Status__c,Mask_Rev__c,Mask_Set_Title__c,Retrofit_Mask_Rev__c,Retrofit_ROM_Code__c,Retrofit_Tech_Geo__c,ROM_Code__c
                                                               FROM Frame_DRT_Association__c
                                                               WHERE DRT__c = :drtId];
                List<Frame_DRT_Association__c> lstCopyFrameDRT = frameDRTList.deepClone();
                for(Frame_DRT_Association__c newFrameDRTObj : lstCopyFrameDRT){
                    newFrameDRTObj.DRT__c = newDRTObject.Id;
                }
                insert lstCopyFrameDRT;
            } 
        }
        catch (Exception e) 
        {
            Database.rollback(sp);
            if(e.getMessage().containsIgnoreCase('Unique_DRT_Name__c')) {
                 string errorMsg = Error_Codes__c.getInstance('Unique_DRT_Name_Error').Message__c.replace('{DRTName}',newDRTObject.Name);
                 lstDRTErrorMessage.add(errorMsg);
                 return null;                
            }
            lstDRTErrorMessage.add(e.getMessage());
            return null;
        }   
        if(newDRTObject.Id!=null) {  
            Pagereference pgRef = new Pagereference('/apex/VFDRTDetail?id='+newDRTObject.Id+'&urlFromPage='+fromPage);
            pgRef.setRedirect(true);
            return pgRef;
        }
        return null;
    } 
   
   /**
    * @description: This class is used as a wrapper class for Mask Layers.
    **/ 
   public class MaskLayerWrapper
   {
       public String layerNo {get ;set ;}
       public String retrofitMaskRev {get ;set;}
       public String retrofitRomCode {get;set;}
       public Id layerId {get;set;}
       
       public MaskLayerWrapper(String layerNo ,String retrofitMaskRev,String retrofitRomCode,Id layerId)
       {
           this.layerNo =layerNo ;
           this.retrofitMaskRev =retrofitMaskRev ;
           this.retrofitRomCode =retrofitRomCode ;
           this.layerId =layerId;           
       }
   }
   
   /**
    * @description: This class is used as a wrapper class for showing 'Where Use' details.
    **/
   public class PTRFDrtAssoWrapper
   {
       public Id ptrfId{get; set;}
       public String ptrf {get;set;}
       public String orderStatus {get;set;}
       public String mst {get;set;}
       public String deviceId {get;set;}
       public boolean frameTapeOut {get;set;}
       public boolean frameMockup {get;set;}
       public boolean primeTapeOut {get;set;}
       public boolean primeGDSOUTReview {get;set;}
       public boolean drc {get;set;}
       public boolean color {get;set;}
       
       public  PTRFDrtAssoWrapper(Id ptrfId,String ptrf,String orderStatus,String mst,String deviceId,boolean frameTapeOut,boolean frameMockup,boolean primeTapeOut,
                                  boolean primeGDSOUTReview,boolean drc,boolean color) {
           this.ptrfId = ptrfId;
           this.ptrf =ptrf;
           this.orderStatus = orderStatus;
           this.mst = mst;
           this.deviceId = deviceId ;
           this.frameTapeOut = frameTapeOut;
           this.frameMockup = frameMockup ;
           this.primeTapeOut = primeTapeOut;
           this.primeGDSOUTReview = primeGDSOUTReview;
           this.drc = drc;
           this.color =color;
       }
   }
  
  /**
    * @description: This class is used as a wrapper class for showing left table in DRT.
  **/
  public class chipDetailsWrapper {
      public String chipName {get;set;}
      public String mstName {get;set;}
      public Integer counter{get;set;}
      public Id chipId {get ;set;}
      public Boolean colour {get;set;}
      public chipDetailsWrapper(String chipName,String mstName, Integer counter,Id chipId,Boolean colour)
      {
          this.chipName =chipName ;
          this.mstName =mstName ;
          this.counter=counter;
          this.chipId =chipId;
          this.colour = colour;
      }
  }
  
  /**
    * @description: This class is used as a wrapper class for Frame DRT table.
  **/
  public class frameClass
  {
      public Integer counter {get;set;}
      public String mst {get;set;}
      public String maskLayer {get;set;}
      public String retrofitMaskRev {get;set;}
      public String retrofitRomCode {get;set;}
      public String maskRev {get;set;}
      public String romCode {get;set;}
      public Boolean color {get;set;}
      
        //swgp-2
        public boolean isEdited_retroMaskRev {get;set;}
        public boolean isEdited_retroROMCode {get;set;}
        //swgp-2-end
      
      public  frameClass(Integer counter, String mst,String maskLayer,String retrofitMaskRev,String retrofitRomCode,String maskRev,String romCode,Boolean color )
      {
          this.counter =counter;
          this.mst=mst;
          this.maskLayer=maskLayer;
          this.retrofitMaskRev=retrofitMaskRev;
          this.retrofitRomCode =retrofitRomCode;
          this.maskRev =maskRev;
          this.romCode  =romCode ;
          this.color =color ;
      }
  }

}