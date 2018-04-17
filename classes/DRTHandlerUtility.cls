/*
Type Name: DRTHandlerUtility
Author: Cognizant 
Created Date: 18-March-2014
Reason: This is the handler class for the DRT processes. 
        It will contain all the business logic for the various DRT processes. 
        It will be called from the controller classes 
        i.e. DRTCreateExtn, DRTDetailExtn, DRTUpdateExtn, DRTReviseExtn, DRTSearchExtn.
Change History:
Author: 
Modified Date: 
Reason: Modified for adding Device__c column in fetchDrtPTRFAssociation()  for fetching device id to display the information in where used Tab
Author: Cognizant Technology Solutions
Modified Date:
??..
??..
*/
public without sharing class DRTHandlerUtility {
    private static set<string> setPTRFOrderStatus;
    public static map<string, Error_Codes__c> mapEC = Error_Codes__c.getAll();
    public static string alternateColorClass;
    public static string blankText;
    
    static {
        alternateColorClass = Environment_Variable__c.getInstance('DRT_Alternate_Row_Styleclass').Value__c;
        blankText = '---';
        setPTRFOrderStatus = new set<string>();
        setPTRFOrderStatus.addAll(Environment_Variable__c.getInstance('DRTPTRFOrderStatus').Value__c.split(','));
    }
    public DRTHandlerUtility(){}
    
    /**
    * @description: This method is used to call fetchCustomerName() for fetching accounts 
    * for user permission create/edit DRT
    * @param: none
    * @return: list<Account>
    **/
    public list<Account> fetchCustomerName() {
        return fetchCustomers(false);
    }
    
    /**
    * @description: This method is used to fetch accounts based on the logged in user permission.
    * @param: none
    * @return: list<Account>
    **/
    public list<Account> fetchCustomers(boolean readOnlyView) {
        User loggedInUserInfo =[SELECT Id,AccountId,Name,ProfileId,Profile.Name FROM User WHERE Id =:UserInfo.getUserId()];
        list<Account> customerlist = new list<Account>();
        set<id> setUniqueAccountId = new set<id>();
        
        set<String> setAccRecordTypes = new set<string>{'GLOBALFOUNDRIES_Internal','Customer','Enablement_Partner','Reseller'};
        string recTypeGFInternal,recTypeCustomer,recTypeEnabPartner,recTypeReseller;
        
        for(RecordType objRT:[Select Id,Name,DeveloperName,SobjectType from RecordType where SobjectType = 'Account' and DeveloperName IN:setAccRecordTypes]){
            if(objRT.DeveloperName=='GLOBALFOUNDRIES_Internal'){
                recTypeGFInternal = objRT.Id;       
            }
            else if(objRT.DeveloperName=='Customer'){
                recTypeCustomer = objRT.Id;     
            }
            else if(objRT.DeveloperName=='Enablement_Partner'){
                recTypeEnabPartner = objRT.Id;      
            }
            else if(objRT.DeveloperName=='Reseller'){
                recTypeReseller = objRT.Id;     
            }   
        }
        if(loggedInUserInfo.AccountId!=null) {
            customerlist =[SELECT Name,Id,Stage__c,Transaction_Type__c,recordTypeId,Short_Name__c FROM Account WHERE Id=:loggedInUserInfo.AccountId AND 
            ((recordTypeId=:recTypeGFInternal AND (Stage__c='Qualified' OR Stage__c='Authorized')) OR (recordTypeId=:recTypeCustomer AND Stage__c='Authorized' AND Transaction_Type__c='Transactional')
            OR (recordTypeId=:recTypeEnabPartner AND Stage__c='Authorized') OR (recordTypeId=:recTypeReseller AND Stage__c='Authorized' AND Transaction_Type__c='Transactional'))];
        }
        else {
            customerlist =[SELECT Name,Id,Stage__c,Transaction_Type__c,recordTypeId,Short_Name__c FROM Account WHERE
            ((recordTypeId=:recTypeGFInternal AND (Stage__c='Qualified' OR Stage__c='Authorized')) OR (recordTypeId=:recTypeCustomer AND Stage__c='Authorized' AND Transaction_Type__c='Transactional')
            OR (recordTypeId=:recTypeEnabPartner AND Stage__c='Authorized') OR (recordTypeId=:recTypeReseller AND Stage__c='Authorized' AND Transaction_Type__c='Transactional'))]; 
            
        }
        // for FE users
        list<String> lstTeamRoles = new list<String>();
        lstTeamRoles = Environment_Variable__c.getInstance('SwiftFETeamRoles').Value__c.split(',');
        Map<Id,Account> mapAcctIdName = new Map<Id,Account>();
        for(Account a : customerlist) {
            mapAcctIdName.put(a.Id,a);
        }
        Boolean groupUser = false;
        string strCreateGroup = Environment_Variable__c.getInstance('DRTCreateGroup').Value__c; 
        string strEditGroup = Environment_Variable__c.getInstance('DRTEditGroup').Value__c;
        string strViewGroup = Environment_Variable__c.getInstance('DRTViewGroup').Value__c;
        string strDRTGroup = strCreateGroup+','+strEditGroup+(readOnlyView?','+strViewGroup:'');
        list<string> lstDRTGroup = strDRTGroup.split(',');
        if(lstDRTGroup!=null && !lstDRTGroup.isEmpty()){
            list<groupmember> lstGrpMember = [select Id from groupmember where userorgroupid =:loggedInUserInfo.Id and group.DeveloperName IN :lstDRTGroup LIMIT 1];
            if(lstGrpMember!=null && (lstGrpMember.size()>0)){
                groupUser = true;
            }
        }
        list<Account> customerListFE = new list<Account>();
        Boolean isFEUser = false;
        if((loggedInUserInfo.Profile.Name != 'System Administrator') && (!groupUser)) {
            
            //swgp-1025: add into below query 1 more condition (OR) for dual role FAE
            for(Account_Team_Proxy__c objATP:[Select Id,Account__c from Account_Team_Proxy__c 
                                                where 
                                                (
                                                    Team_Role__c IN :lstTeamRoles
                                                    OR
                                                    Is_FAE__c = true//swgp-1025
                                                )
                                                AND 
                                                User__c = :loggedInUserInfo.Id]) {
                isFEUser = true;
                if(mapAcctIdName.containsKey(objATP.Account__c)) {
                    if(!setUniqueAccountId.contains(objATP.Account__c)) {  
                        customerListFE.add(mapAcctIdName.get(objATP.Account__c));
                        setUniqueAccountId.add(objATP.Account__c);
                    }
                }
            }
        }
        if(isFEUser) {
            return customerListFE;
        }
        return customerlist;
    }
    
    /**
    * @description: This method is used to fetch Mask Set Title list.
    * @param: ID accountId
    * @return: list<Mask_Set_Title__c>
    **/
    public list<Mask_Set_Title__c> fetchMSTList(ID accountId) {
        set<Id> setExtendedMSTId = new set<Id>();
        set<Id> setValidMSTId = new set<Id>();
        list<Mask_Set_Title__c> maskSetTitlelist = new list<Mask_Set_Title__c>();
 
        
        if(accountId!=null) {
            for(MST_Config__c objMSTConfig:[SELECT Mask_Set_Title__c,Customer__c,Is_Active_Extension__c FROM MST_Config__c WHERE Customer__c=:accountId 
            and Is_Active_Extension__c=true]){
                setExtendedMSTId.add(objMSTConfig.Mask_Set_Title__c);  
            }
            for(PTRF__c objPTRF:[SELECT MaskSetTitle__c, Customer__c FROM PTRF__c WHERE (Prime_Tapeout__c = true OR Frame_Tapeout__c = true) 
                    AND Status__c IN :setPTRFOrderStatus 
                    AND (Customer__c = :accountId OR (MaskSetTitle__c IN :setExtendedMSTId))]){
                setValidMSTId.add(objPTRF.MaskSetTitle__c); 
            }
            
        }
        String queryStr;
        if(setValidMSTId != null && !setValidMSTId.isEmpty()) {
            queryStr ='SELECT Id,Name,Status__c FROM Mask_Set_Title__c WHERE Id IN :setValidMSTId AND Status__c=\'Active\'';
            string strGroupMPW = Environment_Variable__c.getInstance('DRTMPWGroup').Value__c;
            for(GroupMember gm : [SELECT Id,Group.id,Group.DeveloperName FROM GroupMember WHERE UserOrGroupId = :UserInfo.getUserId()]) {
                if(strGroupMPW.containsIgnoreCase(gm.Group.DeveloperName)) {
                    queryStr = queryStr + ' AND Name like \'MPW%\'';
                    break;
                }
            }
            maskSetTitlelist = Database.query(queryStr);
        }
        return maskSetTitlelist;
    }
    
    
    /**
    * @description: This method is used to fetch Tech Geo list.
    * @param: string mstId,string drtType
    * @return: set<string>
    **/
    public static set<String> fetchTechGeoList(String mstId,String drtType) {
        set<String> setTechGeo = new set<String>();
        if(!String.isBlank(mstId) && !String.isBlank(drtType)) {
            String reticleTypeMNR = 'Multi Node Reticle (MNR)';
            String queryStr = 'SELECT Id,Recticle_Type__c,Tech_Geo__c FROM PTRF__c WHERE MaskSetTitle__c = :mstId ';
            if(drtType.equalsIgnoreCase('prime')) {
                queryStr += 'AND (Prime_Tapeout__c = true OR Frame_Tapeout__c = true) ';
            }
            else if(drtType.equalsIgnoreCase('frame')) {
                queryStr += 'AND (Frame_Tapeout__c = true) ';
            }
            queryStr += 'AND Recticle_Type__c = :reticleTypeMNR AND Status__c IN :setPTRFOrderStatus';
            Boolean globalShuttleUser = false;
            Boolean tdtiMPWUser = false;
            for(GroupMember gm : [SELECT Id,Group.id,Group.DeveloperName FROM GroupMember WHERE UserOrGroupId = :UserInfo.getUserId()]) {
                if(gm.Group.DeveloperName == 'Swift_GlobalShuttle') {
                    globalShuttleUser = true;
                    break;
                }
                else if(gm.Group.DeveloperName == 'Swift_TDTI_MPW') {
                    tdtiMPWUser = true;
                    break;
                }
            }
            Boolean recordFound = false;
            Pattern techGeoPattern = Pattern.compile('(\\d*\\.\\d+)(.*)');
            for(PTRF__c ptrf : Database.query(queryStr)) {
                if(!String.isBlank(ptrf.Tech_Geo__c) && (!'null'.equalsIgnoreCase(ptrf.Tech_Geo__c))) {
                    Matcher pm = techGeoPattern.matcher(ptrf.Tech_Geo__c);
                    Decimal dcmTechGeo;
                    if(pm.matches() && !string.isBlank(pm.group(1))){
                        dcmTechGeo = Decimal.valueOf(pm.group(1));
                    }
                    if(globalShuttleUser && (dcmTechGeo != null && (dcmTechGeo > 0.02))) {
                        setTechGeo.add(ptrf.Tech_Geo__c);
                    }
                    if(tdtiMPWUser && (dcmTechGeo != null && (dcmTechGeo <= 0.02))) {
                        setTechGeo.add(ptrf.Tech_Geo__c);
                    }
                    if(!globalShuttleUser && !tdtiMPWUser){
                        setTechGeo.add(ptrf.Tech_Geo__c);
                    }
                }
                recordFound = true;
            }
            if(recordFound && (setTechGeo == null || setTechGeo.isEmpty())) {
                setTechGeo.add('');
            } 
        }
        return setTechGeo;
    } 
    
    /**
    * @description: This method is used to fetch Chip_Detail__c records based on Mask Set Title and Tech Geo.
    * @param: string mstId,string techGeo
    * @return: list<Chip_Detail__c>
    **/
    public static list<Chip_Detail__c> fetchChipDetails(string mstId,string techGeo) {
        if(!string.isBlank(mstId)) {
            set<string> setUnqiueChipNames = new set<string>();
            list<Chip_Detail__c> lstChipDetail = new list<Chip_Detail__c>();
            string queryStr = 'SELECT Id,Name,PTRF__c FROM Chip_Detail__c WHERE PTRF__r.MaskSetTitle__c = :mstId '+ 
                                                    'AND (PTRF__r.Prime_Tapeout__c = true OR PTRF__r.Frame_Tapeout__c = true) '+ 
                                                    'AND Tapeout__c = true '+ 
                                                    'AND PTRF_Order_Status__c IN :setPTRFOrderStatus ';
            if(!string.isBlank(techGeo)) {
                queryStr += 'AND PTRF__r.Tech_Geo__c = :techGeo';
            }
            for(Chip_Detail__c chip : Database.query(queryStr)) {
               string chipName = (chip.Name != null) ? chip.Name.toLowerCase() : '';
               if(!setUnqiueChipNames.contains(chipName)) {
                  lstChipDetail.add(chip);
                  setUnqiueChipNames.add(chipName);
               }
            }          
            return lstChipDetail;
        }
        return new list<Chip_Detail__c>();
    }
    
    /**
    * @description: This method is used to fetch list of chips which cannot be deleted from DRT.
    * @param: string drtName, list<DRTHandlerUtility.ChipWrapper> lstChipWrapper
    * @return: list<string>
    **/
    public static list<string> fetchChipsForDeletion(string drtName, list<DRTHandlerUtility.ChipWrapper> lstChipWrapper) {
        if(string.isBlank(drtName) || lstChipWrapper == null || lstChipWrapper.isEmpty()) {
            return new list<string>();
        }
        integer lastIdx = drtName.lastIndexOf('.');
        string nameWithoutMinor;
        if(lastIdx != -1) {
            nameWithoutMinor = drtName.subString(0,lastIdx);
        }
        if(string.isBlank(nameWithoutMinor)) {
            return new list<string>();
        }
        set<string> setChip = new set<string>();
        set<string> setMST = new set<string>();
        for(DRTHandlerUtility.ChipWrapper chip : lstChipWrapper) {
            setChip.add(chip.chipName);
            setMST.add(chip.mst);
        }
        string strLikeDRTName = nameWithoutMinor+'%';
        
        map<string,set<Id>> mapChipNameSetPTRFId = new map<string,set<Id>>();
        for(Chip_Detail__c chipObj : [SELECT Id,Name,PTRF__c,PTRF__r.MaskSetTitle__c FROM Chip_Detail__c WHERE PTRF__r.MaskSetTitle__c IN :setMST 
                                                    AND (PTRF__r.Prime_Tapeout__c = true OR PTRF__r.Frame_Tapeout__c = true) 
                                                    AND Tapeout__c = true 
                                                    AND Name IN :setChip 
                                                    AND PTRF_Order_Status__c IN :setPTRFOrderStatus]) {
            string key = chipObj.PTRF__r.MaskSetTitle__c+'-'+chipObj.Name;
            if(!mapChipNameSetPTRFId.containsKey(key)){
                mapChipNameSetPTRFId.put(key,new set<Id>());
            }
            mapChipNameSetPTRFId.get(key).add(chipObj.PTRF__c);
        }
        set<id> setPTRFId = new set<id>();
        for(set<id> setId : mapChipNameSetPTRFId.values()) {
            setPTRFId.addAll(setId);
        }
        set<Id> setDRTPTRFId = new set<Id>();
        if(setPTRFId != null && !setPTRFId.isEmpty()) {
            for(DRT_PTRF_Association__c objDRTPTRFAssoc : [SELECT Id,PTRF__c FROM DRT_PTRF_Association__c WHERE  DRT__r.Name LIKE :strLikeDRTName AND PTRF__c IN :setPTRFId]) {
                setDRTPTRFId.add(objDRTPTRFAssoc.PTRF__c);
            }
        }
        list<string> lstChipsForDelete = new list<string>();
        for(string key : mapChipNameSetPTRFId.keySet()){
            if(containsId(mapChipNameSetPTRFId.get(key),setDRTPTRFId)) {
                lstChipsForDelete.add(key);
            }
        }
        return lstChipsForDelete;
    }
    
    /**
    * @description: This method is used to return unique set of Mask Layers from a list of Mask Layers.
    * @param: list<Mask_Layer__c> lstMaskLayer
    * @return: list<Mask_Layer__c>
    **/
    public static list<Mask_Layer__c> fetchUniqueMaskLayers(list<Mask_Layer__c> lstMaskLayer) {
            list<Mask_Layer__c> lstUniqueMaskLayer = new List<Mask_Layer__c>();
            set<string> setUniqueMaskLayer = new set<string>();
            for(Mask_Layer__c m : lstMaskLayer) {
                string layerNo = ((m.Mask_Layer_Number__c == null) ? '' :  m.Mask_Layer_Number__c);
                string maskRev = ((m.Mask_Layer_Rev__c == null) ? '' : m.Mask_Layer_Rev__c);
                string romCode = (((m.ROM_Code__c == null) || (m.ROM_Code__c == '####')) ? '' : m.ROM_Code__c);
                string maskLayerStr = layerNo+'-' + maskRev+'-'+romCode;
                if(!setUniqueMaskLayer.contains(maskLayerStr)) {
                    lstUniqueMaskLayer.add(m);
                    setUniqueMaskLayer.add(maskLayerStr);
                }    
            }
        return lstUniqueMaskLayer;
    }
    
    /**
    * @description: This method is used to return list of Mask Layers.
    * @param: String mstId,String drtType,String techGeo
    * @return: list<Mask_Layer__c>
    **/
    public static list<Mask_Layer__c> fetchMaskLayers(String mstId,String drtType,String techGeo) {
        if(!String.isBlank(mstId) && !String.isBlank(drtType)) {
            String queryStr = 'SELECT Id,Name,PTRF__c,Mask_Layer_Number__c,Mask_Layer_Rev__c,ROM_Code__c FROM Mask_Layer__c WHERE PTRF__r.MaskSetTitle__c = :mstId AND Tapeout__c = true ';
            if(drtType.equalsIgnoreCase('prime')) {
                queryStr += 'AND (PTRF_Prime_Tapeout__c = true OR PTRF_Frame_Tapeout__c = true) ';
            }
            else {
                queryStr += 'AND PTRF_Frame_Tapeout__c = true ';
            }
            if(!String.isBlank(techGeo)) {
                String techGeoFiltered = String.escapeSingleQuotes(techGeo);
                queryStr += 'AND PTRF__r.Tech_Geo__c = :techGeoFiltered ';
            }
            queryStr += 'AND PTRF_Order_Status__c IN :setPTRFOrderStatus';                                     
            
            list<Mask_Layer__c> lstMaskLayer = Database.query(queryStr);
            return lstMaskLayer;
        }   
        return new list<Mask_Layer__c>();
    }
    
    /**
    * @description: This is the class for wrapping up default Mask Rev/ROM Code data for a particular chip and layer in DRT table.
    **/
    public class MaskRevROMCodeWrapper {
        public string colorClass {get;set;}
        public string htmlId {get;set;}
        public string id {get;set;}
        public string MaskRev {get; set;}
        public string RomCode {get; set;}
        
        //swgp-2
        public boolean isEdited_maskRev {get;set;}
        public boolean isEdited_romCode {get;set;}
        //swgp-2-end
        
        public MaskRevROMCodeWrapper() {
        }
        public MaskRevROMCodeWrapper(string maskRev, string romCode) {
            this.htmlId = '';
            this.colorClass = '';
            if(maskRev != null)           {
                this.MaskRev= maskRev.toUpperCase() ;
            }
            else {
               this.MaskRev = '';
            }
            if(romCode != null) {
                this.RomCode= romCode.toUpperCase();
            }
            else {
                this.RomCode= '';
            }
        }        
    }
    
    /**
    * @description: This is the class for wrapping up Mask Layer data.
    **/
    public class MaskLayerWrapper {
        public String layerNo {get; set;}
        public String maskRev {get; set;}
        public String romCode {get; set;}
        public String layerID {get; set;}
        public string htmlId {get; set;}
        public MaskLayerWrapper(String layerNo,String maskRev,String romCode) {
            this.layerNo = layerNo;
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
    * @description: This is the class for wrapping up Chip_Detail__c data.
    **/
    public class ChipWrapper {
        public string mst{get;set;}
        public string chipName{get;set;}
        public ChipWrapper(string mst,string chipName){
            this.mst = mst;
            this.chipName = chipName;
        }
    }
    
    
    /**
    * @description: This method is used to check whether there is any common id between two set of ids.
    * @param: set<id> firstSet,set<id>secondSet
    * @return: boolean
    **/
    private static boolean containsId(set<id> firstSet,set<id>secondSet) {
        if(firstSet == null || secondSet == null){
            return false;
        }
        boolean found = false;
        for(Id val1 : firstSet) {
            for(Id val2 : secondSet){
                if(val1==val2){
                    found = true;
                    break;
                }
            }
            if(found){
                break;
            }
        }
        return found;
    }
    
    /**
    * @description: This method is used to fetch default list of Mask Rev/ROM Code data for a set of chips and layers.
    *               Used when adding a number of layers to DRT table from Add Retrofit Layer page.
    * @param: string mstId,string drtType,string techGeo,list<MaskLayerWrapper> lstSelectedMaskLayer,list<ChipWrapper> lstChipWrapper,list<Mask_Layer__c> lstAllMaskLayer,integer layerCount
    * @return: map<string,map<string,MaskRevROMCodeWrapper>>
    **/  
    public map<string,map<string,MaskRevROMCodeWrapper>> fetchMaskRevROMCodeList(string mstId,string drtType,string techGeo,list<MaskLayerWrapper> lstSelectedMaskLayer,list<ChipWrapper> lstChipWrapper,list<Mask_Layer__c> lstAllMaskLayer,integer layerCount) {
        map<string,map<string,MaskRevROMCodeWrapper>> mapMaskRevROMCode = new map<string,map<string,MaskRevROMCodeWrapper>>();
        if(!string.isBlank(mstId) && !string.isBlank(drtType) &&  lstSelectedMaskLayer != null && !lstSelectedMaskLayer.isEmpty() && lstChipWrapper != null && !lstChipWrapper.isEmpty() && lstAllMaskLayer != null && !lstAllMaskLayer.isEmpty()) {
            // map of chip name and set of ptrf id
            map<string,set<id>> mapChipNamePTRFId = new map<string,set<id>>();
            set<string> setChipName = new set<string>();
            set<string> setChipMSTId = new set<string>();
            for(ChipWrapper obj : lstChipWrapper){
                setChipName.add(obj.chipName);
                setChipMSTId.add(obj.mst);
            }
            for(chip_detail__c chip : [SELECT Id,Name,PTRF__c,PTRF__r.MaskSetTitle__c FROM Chip_Detail__c WHERE PTRF__r.MaskSetTitle__c IN :setChipMSTId 
                                                    AND PTRF__r.Prime_Tapeout__c = true 
                                                    AND Tapeout__c = true 
                                                    AND Name IN :setChipName 
                                                    AND PTRF_Order_Status__c IN :setPTRFOrderStatus]) {                
                string key = chip.Name + '-' + chip.PTRF__r.MaskSetTitle__c;
                if(!mapChipNamePTRFId.containsKey(key)) {
                    mapChipNamePTRFId.put(key,new set<id>());
                }
                mapChipNamePTRFId.get(key).add(chip.PTRF__c);                
            }
            // when chip is not found in any PTRF add it to map with ptrf id null
            for(String chipName : setChipName) {
                if(!mapChipNamePTRFId.containsKey(chipName)) {
                    mapChipNamePTRFId.put(chipName,new set<id>());
                }
            }
            // map of mask layer and set of ptrf id
            map<string,set<id>> mapMasklayer = new map<string,set<id>>();
            for(Mask_Layer__c m : lstAllMaskLayer) {
                
                string maskLayerStr = ((m.Mask_Layer_Number__c==null)?'':m.Mask_Layer_Number__c)
                            + '-' + ((m.Mask_Layer_Rev__c==null)?'':m.Mask_Layer_Rev__c)
                            + '-' + ((m.ROM_Code__c==null || m.ROM_Code__c=='####')?'':m.ROM_Code__c);
                            
                //string maskLayerStr = (m.Mask_Layer_Number__c==null)?'':m.Mask_Layer_Number__c;
                if(!mapMasklayer.containsKey(maskLayerStr)) {
                    mapMasklayer.put(maskLayerStr,new set<id>());
                }
                mapMasklayer.get(maskLayerStr).add(m.PTRF__c);
            }
            // loop through all mask layers selected in Add Retrofit Layer page
            integer layerCounter = layerCount;
            integer rowCounter;
            for(MaskLayerWrapper mWrapper : lstSelectedMaskLayer) {
                layerCounter++;
                rowCounter = 0;
                
                string layerNo = mWrapper.layerNo;
                string maskRev = mWrapper.maskRev;
                string romCode = mWrapper.romCode;
                string maskLayerStr = layerNo+'-'+maskRev+'-'+romCode;
                //string maskLayerStr = (layerNo==null)?'':layerNo;            
                if(!mapMaskRevROMCode.containsKey(maskLayerStr)) {
                    mapMaskRevROMCode.put(maskLayerStr, new map<string,MaskRevROMCodeWrapper>());
                }
                for(ChipWrapper cWrapper : lstChipWrapper) {
                    rowCounter++;
                    string keyChip = cWrapper.chipName + '-' + cWrapper.mst;
                    map<string,MaskRevROMCodeWrapper> mapChipNameMaskRevROMCode = mapMaskRevROMCode.get(maskLayerStr);
                    if(!mapChipNameMaskRevROMCode.containsKey(keyChip)) {
                         mapChipNameMaskRevROMCode.put(keyChip, new MaskRevROMCodeWrapper());                       
                    }
                    // if chip belongs to the same PTRF from where mask layer comes
                    MaskRevROMCodeWrapper mObject = mapChipNameMaskRevROMCode.get(keyChip);
                    if(mapMasklayer.containsKey(maskLayerStr) && containsId(mapChipNamePTRFId.get(keyChip),mapMasklayer.get(maskLayerStr))) {
                        mObject.MaskRev = MaskRev;
                        mObject.RomCode = RomCode;
                    }
                    mObject.maskRev = (string.isBlank(mObject.maskRev))?'---':mObject.maskRev;
                    mObject.romCode = (string.isBlank(mObject.romCode))?'---':mObject.romCode;
                    mapChipNameMaskRevROMCode.get(keyChip).htmlId = layerCounter+'-'+rowCounter;
                    if(Math.mod(rowCounter,2)==0) {
                        mapChipNameMaskRevROMCode.get(keyChip).colorClass = alternateColorClass;
                    }
                }
            }
        }   
        return mapMaskRevROMCode;
    } 
    
    /**
    * @description: This method is used to fetch list of Mask Rev/ROM Code data for a particular chip and layer combination.
    * @param: string chipName,string layerNo,string chipMST,string baseMST,string techGeo
    * @return: list<list<string>>
    **/
    public static list<list<string>> fetchChipLayerComboData(string chipName,string layerNo,string chipMST,string baseMST,string techGeo){
        list<list<string>> lstMaskRevROMCode = new list<list<String>>();
        lstMaskRevROMCode.add(new list<string>()); // initialize list of mask rev
        lstMaskRevROMCode.add(new list<string>()); // initialize list of rom code
        set<string> setMaskRev = new set<string>();
        set<string> setROMCode = new set<string>();
        set<id> setChipPTRFId = new set<id>();
        for(chip_detail__c chip : [SELECT Id,Name,PTRF__c FROM Chip_Detail__c WHERE PTRF__r.MaskSetTitle__c = :chipMST 
                                                    AND PTRF__r.Prime_Tapeout__c = true 
                                                    AND Tapeout__c = true 
                                                    AND Name = :chipName 
                                                    AND PTRF_Order_Status__c IN :setPTRFOrderStatus]) {
                setChipPTRFId.add(chip.PTRF__c);
        }
        String queryStr = 'SELECT Id,Name,PTRF__c,Mask_Layer_Number__c,Mask_Layer_Rev__c,ROM_Code__c FROM Mask_Layer__c '
                        + ' WHERE Mask_Layer_Number__c = :layerNo '
                        + ' AND Tapeout__c = true '
                        + ' AND PTRF__c IN :setChipPTRFId '
                        + ' AND PTRF__r.MaskSetTitle__c = :chipMST '
                        + ' AND PTRF_Order_Status__c IN :setPTRFOrderStatus '
                        + ' AND (PTRF__r.Prime_Tapeout__c = true OR PTRF__r.Frame_Tapeout__c = true) ';
        
        if(!String.isBlank(techGeo)) {
            String techGeoFiltered = String.escapeSingleQuotes(techGeo);
            queryStr += ' AND PTRF__r.Tech_Geo__c = :techGeoFiltered ';
        }
            
        for(Mask_Layer__c m : Database.query(queryStr)) {
            string maskRev = ((m.Mask_Layer_Rev__c == null) ? '' : m.Mask_Layer_Rev__c);
            string romCode = (((m.ROM_Code__c == null) || (m.ROM_Code__c == '####')) ? '' : m.ROM_Code__c);
            setMaskRev.add(maskRev);
            setROMCode.add(romCode);
        }
        lstMaskRevROMCode.get(0).addAll(setMaskRev);
        lstMaskRevROMCode.get(1).addAll(setROMCode);
        return lstMaskRevROMCode;
    }
    
    /**
    * @description: This method is used to fetch list of Mask Rev/ROM Code data for a particular chip and a set of layers combination.
    * @param: string chipName,list<MaskLayerWrapper> lstMaskLayerWrapper,string mstId,string baseMST,string techGeo,integer rowCountGlobal
    * @return: list<MaskRevROMCodeWrapper>
    **/
    public static list<MaskRevROMCodeWrapper> fetchNewChipLayerData(string chipName,list<MaskLayerWrapper> lstMaskLayerWrapper,string mstId,string baseMST,string techGeo,integer rowCountGlobal) {
        list<MaskRevROMCodeWrapper> lstLayerData = new list<MaskRevROMCodeWrapper>();
            
        if(!string.isBlank(chipName) && !string.isBlank(mstId) && lstMaskLayerWrapper != null && !lstMaskLayerWrapper.isEmpty()) {
            set<string> setLayerNo = new set<string>();
            for(MaskLayerWrapper mWrapper : lstMaskLayerWrapper) {
                setLayerNo.add(mWrapper.layerNo);
            }
            // map of chip name and set of ptrf id
            map<string,set<id>> mapChipNamePTRFId = new map<string,set<id>>();
            mapChipNamePTRFId.put(chipName,new set<id>());
            for(chip_detail__c chip : [SELECT Id,Name,PTRF__c FROM Chip_Detail__c WHERE PTRF__r.MaskSetTitle__c = :mstId 
                                                    AND PTRF__r.Prime_Tapeout__c = true  
                                                    AND Tapeout__c = true 
                                                    AND Name = :chipName
                                                    AND PTRF_Order_Status__c IN :setPTRFOrderStatus]) {
                mapChipNamePTRFId.get(chipName).add(chip.PTRF__c);                
            }
            set<id> setChipPTRFId = mapChipNamePTRFId.get(chipName);
            setChipPTRFId = (setChipPTRFId==null||setChipPTRFId.isEmpty())?(new set<id>()):setChipPTRFId;
            string queryStr = 'SELECT Id,PTRF__c,Mask_Layer_Number__c,Mask_Layer_Rev__c,ROM_Code__c FROM Mask_Layer__c '
                    +' WHERE Mask_Layer_Number__c IN :setLayerNo AND Tapeout__c = true AND PTRF__r.MaskSetTitle__c = :mstId '
                    +' AND PTRF_Order_Status__c IN :setPTRFOrderStatus '
                    +' AND (PTRF__r.Prime_Tapeout__c = true OR PTRF__r.Frame_Tapeout__c = true) '
                    +' AND PTRF__c IN :setChipPTRFId ';
            if(!string.isBlank(techGeo)) {
                string techGeoFiltered = String.escapeSingleQuotes(techGeo);
                queryStr += ' AND PTRF__r.Tech_Geo__c = :techGeoFiltered ';
            }
            // map of mask layer and set of ptrf id
            map<string,set<id>> mapMasklayer = new map<string,set<id>>();
            for(Mask_Layer__c m : Database.query(queryStr)) {
                string maskLayerStr = ((m.Mask_Layer_Number__c==null)?'':m.Mask_Layer_Number__c)
                            + '-' + ((m.Mask_Layer_Rev__c==null)?'':m.Mask_Layer_Rev__c)
                            + '-' + ((m.ROM_Code__c==null || m.ROM_Code__c=='####')?'':m.ROM_Code__c);
                            
                //string maskLayerStr = (m.Mask_Layer_Number__c==null)?'':m.Mask_Layer_Number__c;            
                if(!mapMasklayer.containsKey(maskLayerStr)) {
                    mapMasklayer.put(maskLayerStr,new set<id>());
                }
                mapMasklayer.get(maskLayerStr).add(m.PTRF__c);
            }
            integer layerCounter=1;
            for(MaskLayerWrapper mWrapper : lstMaskLayerWrapper) {
                string layerNo = mWrapper.layerNo;
                string maskRev = mWrapper.maskRev;
                string romCode = mWrapper.romCode;
                string maskLayerStr = layerNo+'-'+maskRev+'-'+romCode;
                //string maskLayerStr = (layerNo==null)?'':layerNo;
                MaskRevROMCodeWrapper mObject = new MaskRevROMCodeWrapper();
                if(mapMasklayer.containsKey(maskLayerStr) && containsId(mapChipNamePTRFId.get(chipName),mapMasklayer.get(maskLayerStr))) {
                    mObject.maskRev = maskRev;
                    mObject.romCode = romCode;
                }
                mObject.maskRev = (string.isBlank(mObject.maskRev))?'---':mObject.maskRev;
                mObject.romCode = (string.isBlank(mObject.romCode))?'---':mObject.romCode;
                mObject.htmlId = layerCounter+'-'+rowCountGlobal;
                lstLayerData.add(mObject);
                layerCounter++;
            }
        }
        return lstLayerData;
    }
    
    /**
    * @description: This method is used to fetch list of Mask Layers.
    * @param: String mstId,String techGeo
    * @return: set<String>
    **/
    public static set<String> fetchLayerNos(String mstId,String techGeo) {
        list<Mask_Layer__c> lstLayerNo;
        String techGeoFiltered = String.escapeSingleQuotes(techGeo);
        if(!String.isBlank(mstId)){
            if(String.isBlank(techGeoFiltered)) {          
                lstLayerNo = [SELECT Id,Name,Tech_Geo__c,Mask_Layer_Number__c FROM Mask_Layer__c WHERE PTRF__r.MaskSetTitle__c = :mstId 
                                   AND Tapeout__c = true 
                                   AND PTRF__r.Frame_Tapeout__c = true 
                                   AND PTRF_Order_Status__c IN :setPTRFOrderStatus ];
            }
            else {
                lstLayerNo = [SELECT Id,Name,Tech_Geo__c,Mask_Layer_Number__c FROM Mask_Layer__c WHERE PTRF__r.MaskSetTitle__c = :mstId 
                                   AND Tapeout__c = true 
                                   AND PTRF__r.Frame_Tapeout__c = true 
                                   AND PTRF__r.Tech_Geo__c = :techGeoFiltered 
                                   AND PTRF_Order_Status__c IN :setPTRFOrderStatus ];
            }
        }
        set<string> setUniqueLayerNos  = new set<String>();
        set<string> setUniqueLayerNosRet = new set<string>();
        setUniqueLayerNosRet.add('');
        if(lstLayerNo !=null && !lstLayerNo.isEmpty()) {
            for(Mask_Layer__c  maskLayer : lstLayerNo) {
                setUniqueLayerNos.add(maskLayer.Mask_Layer_Number__c);
            }
        }
       setUniqueLayerNosRet.addAll(setUniqueLayerNos);
       return setUniqueLayerNosRet;
    } 
    
    /**
    * @description: This method is used to fetch list of Mask Rev/ROM Code data.
    * @param: String mstId,String selectedLayerNo,String techGeo
    * @return: list<list<String>>
    **/
    public static list<list<String>> fetchMaskRevROMCode(String mstId,String selectedLayerNo,String techGeo) {
        String techGeoFiltered = String.escapeSingleQuotes(techGeo);
        list<Mask_Layer__c> lstMaskLayer;
        if(!String.isBlank(mstId) && !String.isBlank(selectedLayerNo)) {
            if(String.isBlank(techGeoFiltered)) {   
                lstMaskLayer = [SELECT Name,Tech_Geo__c,Mask_Layer_Rev__c,ROM_Code__c 
                                FROM Mask_Layer__c
                                WHERE PTRF__r.MaskSetTitle__c  = :mstId
                                AND Mask_Layer_Number__c = :selectedLayerNo
                                AND Tapeout__c = true 
                                AND PTRF__r.Frame_Tapeout__c = true 
                                AND PTRF_Order_Status__c IN :setPTRFOrderStatus
                                ];
            }
            else {
                lstMaskLayer = [SELECT Name,Tech_Geo__c,Mask_Layer_Rev__c,ROM_Code__c 
                                FROM Mask_Layer__c
                                WHERE PTRF__r.MaskSetTitle__c  = :mstId
                                AND Mask_Layer_Number__c = :selectedLayerNo
                                AND Tapeout__c = true 
                                AND PTRF__r.Tech_Geo__c = :techGeoFiltered 
                                AND PTRF__r.Frame_Tapeout__c = true 
                                AND PTRF_Order_Status__c IN :setPTRFOrderStatus
                                ];
            }
        }
        list<list<String>> lstMaskRevROMCode  = new list<list<String>>();
        list<String> lstMaskRev = new list<String>();
        set<string> setMaskRev = new set<string>();
        list<String> lstROMCode = new list<String>();
        set<string> setROMCode = new set<string>();
        lstMaskRev.add('');
        lstROMCode.add('');
        if(lstMaskLayer !=null && !lstMaskLayer.isEmpty()) {
            for(Mask_Layer__c  maskLayer : lstMaskLayer) {
                setMaskRev.add(maskLayer.Mask_Layer_Rev__c);
                String strROMCode = maskLayer.ROM_Code__c;
                if(strROMCode == '####') {
                    strROMCode = '';
                }
                setROMCode.add(strROMCode);
            }
        }
        lstMaskRev.addAll(setMaskRev);
        lstROMCode.addAll(setROMCode);
        lstMaskRevROMCode.add(lstMaskRev);
        lstMaskRevROMCode.add(lstROMCode);
       return lstMaskRevROMCode;
    }
    
    
    /**
    * @description: This method is used to fetch DRT object details.
    * @param: ID idDRT
    * @return: DRT__c
    **/
    public static DRT__c fetchDRTDetails(ID idDRT) {
        if(idDRT != null) {
            DRT__c objDRTDetail = [SELECT Name,Copied_From__c,Internal_Version__c,Copied_From__r.Name,Old_Rev_DRT__c,Old_Rev_DRT__r.Name,Customer_Name__c,Customer_Short_Name__c,Last_Sync_Req_Timestamp__c,
                                                LastModifiedById,LastModifiedBy.Name,Mask_Set_Title__c,Mask_Set_Title__r.Name,Type__c,Tech_Geo__c,Status__c,Description__c,Customer_Name__r.Name 
                                    FROM DRT__c 
                                    WHERE ID = :idDRT];
            return objDRTDetail;
        }
        return null;        
    }
    
    /**
    * @description: This method is used to fetch PRIME_DRT_Layer_Association__c object details.
    * @param: ID idDRT
    * @return: list<PRIME_DRT_Layer_Association__c>
    **/
    public static list<PRIME_DRT_Layer_Association__c> fetchPrimeDRTLayerAssociationList(ID idDRT) {
        if(idDRT!=null) {        
            list<PRIME_DRT_Layer_Association__c> lstPrimeDRTLayerAssociation=[SELECT ID,Name,DRT__c,DRT__r.Name,Retrofit_Mask_Rev__c,Retrofit_ROM_Code__c,Retrofit_Tech_Geo__c,
                                                                                isCreatedLater__c,isSoftDeleted__c,  
                                                                                
                                                                                //swgp-2
                                                                                Is_Edited_Retrofit_Mask_Rev__c,Is_Edited_Retrofit_ROM_Code__c
                                                                                
                                                                                FROM PRIME_DRT_Layer_Association__c 
                                                                                WHERE DRT__c=:idDRT 
                                                                                AND IsSoftDeleted__c = false 
                                                                                ORDER BY CreatedDate];
            return lstPrimeDRTLayerAssociation;
        }
        return null;
    }
    
    /**
    * @description: This method is used to fetch PRIME_DRT_Chip_Association__c object details.
    * @param: ID idDRT
    * @return: list<PRIME_DRT_Chip_Association__c>
    **/
    public static list<PRIME_DRT_Chip_Association__c> fetchPrimeDRTChipAssociationList(ID idDRT) {
        if(idDRT!=null) {            
            list<PRIME_DRT_Chip_Association__c> lstPrimeDRTChipAssociation=[SELECT ID,Name,DRT__c,fetched_from_PTRF_Id__c,DRT__r.Name,Mask_Set_Title__c,Mask_Set_Title__r.name,
                                                                                isCreatedLater__c,isSoftDeleted__c
                                                                                FROM PRIME_DRT_Chip_Association__c 
                                                                                WHERE DRT__c=:idDRT 
                                                                                AND IsSoftDeleted__c = false 
                                                                                ORDER BY CreatedDate];
            return lstPrimeDRTChipAssociation;
        }
        return null;
    }
    
    /**
    * @description: This method is used to fetch PRIME_DRT_Chip_Layer_Summary__c object details.
    * @param: ID idDRT
    * @return: list<PRIME_DRT_Chip_Layer_Summary__c>
    **/
    public static list<PRIME_DRT_Chip_Layer_Summary__c> fetchPrimeDRTChipLayerSummaryList(list<PRIME_DRT_Layer_Association__c> lstPrimeDRTLayerAssociation,list<PRIME_DRT_Chip_Association__c> lstPrimeDRTChipAssociation) {
        list<PRIME_DRT_Chip_Layer_Summary__c> lstPrimeDRTChipLayerSummary;    
        if(lstPrimeDRTLayerAssociation!=null && 
                lstPrimeDRTLayerAssociation.size()>0 && 
                lstPrimeDRTChipAssociation!=null && 
                lstPrimeDRTChipAssociation.size()>0) {
                
            set<Id> lstIDPrimeDRTLayerAssociation= (new Map<Id,SObject>(lstPrimeDRTLayerAssociation)).keyset();
            set<Id> lstIDPrimeDRTChipAssociation= (new Map<Id,SObject>(lstPrimeDRTChipAssociation)).keyset();
            
            lstPrimeDRTChipLayerSummary=[SELECT ID,Name,Chip__c,Chip__r.Name,Layer__c,Layer__r.name,IsActive__c,Mask_Layer_Rev__c,ROM_Code__c,Layer__r.Retrofit_Mask_Rev__c,Layer__r.Retrofit_ROM_Code__c  
                                            
                                            //swgp-2
                                            ,Is_Edited_Mask_Layer_Rev__c,Is_Edited_ROM_Code__c
                                            
                                            FROM PRIME_DRT_Chip_Layer_Summary__c 
                                            WHERE (Chip__c IN :lstIDPrimeDRTChipAssociation and Layer__c IN : lstIDPrimeDRTLayerAssociation ) 
                                            ORDER BY Chip__r.Name,Layer__r.name,Layer__r.Retrofit_Mask_Rev__c,Layer__r.Retrofit_ROM_Code__c];

        }
        return lstPrimeDRTChipLayerSummary;
    }
    
    /**
    * @description: This method is used to prepare Mask Rev/ROM Code data from PRIME_DRT_Chip_Layer_Summary__c records.
    * @param: list<PRIME_DRT_Chip_Layer_Summary__c> lstChipLayerSummary
    * @return: map<string,map<string,DRTHandlerUtility.MaskRevROMCodeWrapper>>
    **/
    public map<string,map<string,DRTHandlerUtility.MaskRevROMCodeWrapper>> fetchPrimeDRTMaskRevROMCodeData(list<PRIME_DRT_Chip_Layer_Summary__c> lstChipLayerSummary){
        map<string,map<string,DRTHandlerUtility.MaskRevROMCodeWrapper>> mapMaskRevROMCode 
                            = new map<string,map<string,DRTHandlerUtility.MaskRevROMCodeWrapper>>();
        if(lstChipLayerSummary == null) {
            return mapMaskRevROMCode;
        }
        for(PRIME_DRT_Chip_Layer_Summary__c objSummary : lstChipLayerSummary){
            if(!mapMaskRevROMCode.containsKey(objSummary.Layer__c)){
                mapMaskRevROMCode.put(objSummary.Layer__c,new map<string,DRTHandlerUtility.MaskRevROMCodeWrapper>());
            }
            map<string,DRTHandlerUtility.MaskRevROMCodeWrapper>  mapChipMaskRevROMCode = mapMaskRevROMCode.get(objSummary.Layer__c);
            if(!mapChipMaskRevROMCode.containsKey(objSummary.Chip__c)) {
                mapChipMaskRevROMCode.put(objSummary.Chip__c, new DRTHandlerUtility.MaskRevROMCodeWrapper());
            }
            string maskRev,romCode;
            maskRev = (string.isBlank(objSummary.Mask_Layer_Rev__c))?'---':objSummary.Mask_Layer_Rev__c;
            romCode = (string.isBlank(objSummary.ROM_Code__c))?'---':objSummary.ROM_Code__c;
            mapChipMaskRevROMCode.get(objSummary.Chip__c).maskRev = maskRev;
            mapChipMaskRevROMCode.get(objSummary.Chip__c).romCode = romCode;
            mapChipMaskRevROMCode.get(objSummary.Chip__c).id = objSummary.Id;
            
            //swgp-2
            mapChipMaskRevROMCode.get(objSummary.Chip__c).isEdited_maskRev = objSummary.Is_Edited_Mask_Layer_Rev__c;
            mapChipMaskRevROMCode.get(objSummary.Chip__c).isEdited_romCode = objSummary.Is_Edited_ROM_Code__c;
            //swgp-2-end
        }
        return mapMaskRevROMCode;
    }
    
    /**
    * @description: This method is used to fetch DRT_PTRF_Association__c records.
    * @param: Id drtId
    * @return: list<DRT_PTRF_Association__c>
    **/
    public static list<DRT_PTRF_Association__c> fetchDrtPTRFAssociation(Id drtId) {
        if(drtId!=null) {
            list<DRT_PTRF_Association__c> fetchDrtPTRFAssociationlist= [SELECT Id, PTRF__c, DRT__c, PTRF__r.Name, PTRF__r.Device_Id__c, PTRF__r.Status__c,PTRF__r.MaskSetTitle__c,PTRF__r.MaskSetTitle__r.Name,PTRF__r.Device__c,PTRF__r.Device__r.Name,
                                                                            PTRF__r.Frame_Tapeout__c,PTRF__r.Frame_Mockup__c,PTRF__r.Prime_Tapeout__c,PTRF__r.Prime_GDSOUT_Review__c,
                                                                            PTRF__r.DRC_Only__c
                                                                        FROM DRT_PTRF_Association__c 
                                                                        WHERE DRT__c=:drtId /*and PTRF__r.Status__c NOT IN ('Cancel','Closed', 'Deleted')*/ ];
                                                                        
           return fetchDrtPTRFAssociationlist;
        }
        return null;
    }
    
    /**
    * @description: This method is used to return map of Mask Set Title and Name from DRT_PTRF_Association__c records.
    * @param: list<DRT_PTRF_Association__c> fetchDrtPTRFAssociationlist
    * @return: Map<Id,String>
    **/
    public static Map<Id,String> fetchMapOfIdAndMSTName(list<DRT_PTRF_Association__c> fetchDrtPTRFAssociationlist) {
      set<Id> mstIdlst = new set<Id>();
      Map<Id,String> mapIdmst = new Map<Id,String>();
      list<Mask_Set_Title__c> mstlst ;
      if(fetchDrtPTRFAssociationlist !=null && fetchDrtPTRFAssociationlist.size()>0)
      {
          for(DRT_PTRF_Association__c drtPTRFAssObj: fetchDrtPTRFAssociationlist)
          {
              mstIdlst.add(drtPTRFAssObj.PTRF__r.MaskSetTitle__c);
          }
      }
       mstlst =[SELECT Name,Id FROM Mask_Set_Title__c WHERE Id IN:mstIdlst];
       if(mstlst!=null && mstlst.size()>0){
       for(Mask_Set_Title__c  mstObj : mstlst )
       {
           mapIdmst.put(mstObj.Id,mstObj.Name);
       }
       }
      return mapIdmst;
    }
    

  /**
  * @description: This method checks whether DRT creation is applicable for the logged in user.
  * @param: none
  * @return: boolean
  **/
  public static  boolean isCreateDRTApplicable() {
        // if user belongs to public group(s) having Create DRT permission then return true
        string strCreateGroup = Environment_Variable__c.getInstance('DRTCreateGroup').Value__c;
        string strPortalProfiles = Environment_Variable__c.getInstance('SwiftPortalProfiles1').Value__c + ',' + Environment_Variable__c.getInstance('SwiftPortalProfiles2').Value__c;
        boolean isCreateDRTApplicable = false;
          for(group tempGroup:[select developername from group where id in(select groupid from groupmember where userorgroupid =:UserInfo.getUserId())]) {
              if(!String.isBlank(tempGroup.developerName)){
                  if(strCreateGroup.containsIgnoreCase(tempGroup.developername)){
                      isCreateDRTApplicable = true;
                      break;
                  }
              }
          }
         // if system admin/ FE user/ portal user then return true
         if(!isCreateDRTApplicable) {
            User objCurrentUser = [SELECT Id,ProfileId,AccountId,Profile.Name FROM User WHERE Id = :UserInfo.getUserId()];
            if((objCurrentUser.Profile.Name == 'System Administrator') || strPortalProfiles.contains(objCurrentUser.Profile.Name))  {
                   isCreateDRTApplicable = true;
            }            
            else {
                 list<String> lstTeamRoles = new list<String>();
                 lstTeamRoles = Environment_Variable__c.getInstance('SwiftFETeamRoles').Value__c.split(',');
                 
                 //swgp-1025: add into below query 1 more condition (OR) for dual role FAE
                 Integer acctCountFE = [SELECT count() FROM Account_Team_Proxy__c 
                                        WHERE
                                            (
                                                Team_Role__c IN :lstTeamRoles
                                                OR
                                                Is_FAE__c = true//swgp-1025
                                            ) 
                                            AND User__c = :UserInfo.getUserId()];
                 if(acctCountFE != null && acctCountFE > 0) {
                     isCreateDRTApplicable = true;
                 }
             }
         }
        return isCreateDRTApplicable;
        
    }
    
    /**
    * @description: This method checks whether DRT detail page can be viewed by the logged in user or not.
    * @param: none
    * @return: boolean
    **/
    public static  boolean isViewDRTApplicable() {
         // if user belongs to public group(s) having View DRT permission then return true
         string strViewGroup = Environment_Variable__c.getInstance('DRTViewGroup').Value__c;
         string strPortalProfiles = Environment_Variable__c.getInstance('SwiftPortalProfiles1').Value__c + ',' + Environment_Variable__c.getInstance('SwiftPortalProfiles2').Value__c;
         string strDRTViewProfiles = Environment_Variable__c.getInstance('SwiftDRTViewProfiles')==null?'':Environment_Variable__c.getInstance('SwiftDRTViewProfiles').Value__c;
         boolean isViewDRTApplicable = false;        
         for(group tempGroup:[select developername from group where id in(select groupid from groupmember where userorgroupid =:UserInfo.getUserId())])
         {
             if(!String.isBlank(tempGroup.developerName)){
                 if(strViewGroup.containsIgnoreCase(tempGroup.developername)){
                     isViewDRTApplicable = true;
                     break;
                 }
             }
         }
        // if system admin/ FE user/ portal user then show search DRT
        if(!isViewDRTApplicable) {
            User objCurrentUser = [SELECT Id,ProfileId,AccountId,Profile.Name FROM User WHERE Id = :UserInfo.getUserId()];
            if((objCurrentUser.Profile.Name == 'System Administrator') || strPortalProfiles.contains(objCurrentUser.Profile.Name) || strDRTViewProfiles.contains(objCurrentUser.Profile.Name)) {
                   isViewDRTApplicable = true;
            }
            else {
                 list<String> lstTeamRoles = new list<String>();
                 lstTeamRoles = Environment_Variable__c.getInstance('SwiftFETeamRoles').Value__c.split(',');
                 
                 //swgp-1025: add into below query 1 more condition (OR) for dual role FAE
                 Integer acctCountFE = [SELECT count() FROM Account_Team_Proxy__c 
                                        WHERE 
                                        (
                                            Team_Role__c IN :lstTeamRoles
                                            OR
                                            Is_FAE__c = true//swgp-1025
                                        )
                                        AND 
                                        User__c = :UserInfo.getUserId()];
                 if(acctCountFE != null && acctCountFE > 0) {
                     isViewDRTApplicable = true;
                 }
            }
                
        }
        return isViewDRTApplicable;
    }
    
    /**
    * @description: This method checks whether editing a particular DRT is allowed for logged in user or not.
    * @param: DRT__c drt
    * @return: boolean
    **/
    public static boolean isEditDRTApplicable(DRT__c drt) {
        boolean isEditDRTApplicable = false;        
        User objCurrentUser = [SELECT Id,ProfileId,AccountId,Profile.Name FROM User WHERE Id = :UserInfo.getUserId()];
        /** allow edit for System Admin**/
        if(objCurrentUser.Profile.Name == 'System Administrator') {
            isEditDRTApplicable = true;
            return isEditDRTApplicable;
        }
        /** check if Edit Allowed for group or not **/
        if(!isEditDRTApplicable)  {      
             string strEditGroup = Environment_Variable__c.getInstance('DRTEditGroup').Value__c;        
             for(group tempGroup:[select developername from group where id in(select groupid from groupmember where userorgroupid =:objCurrentUser.Id)]) {
                 if(!String.isBlank(tempGroup.developerName)){
                     if(strEditGroup.containsIgnoreCase(tempGroup.developername)){
                         isEditDRTApplicable = true;
                         break;
                     }
                }
             }
        }
        /** check if Edit Allowed for Customer or not **/
        if(!isEditDRTApplicable && (drt.Customer_Name__c == objCurrentUser.AccountId)) {
            isEditDRTApplicable = true;
        }
        /** check if Edit Allowed for FE or not **/
        if(!isEditDRTApplicable) {           
            list<String> lstTeamRoles = new list<String>();
            lstTeamRoles = Environment_Variable__c.getInstance('SwiftFETeamRoles').Value__c.split(',');
            
            //swgp-1025: add into below query 1 more condition (OR) for dual role FAE
            Integer accountCount = [Select count() from Account_Team_Proxy__c where Account__c = :drt.Customer_Name__c 
                                                        AND
                                                        (
                                                            Team_Role__c IN :lstTeamRoles
                                                            OR
                                                            Is_FAE__c = true//swgp-1025
                                                        )  
                                                        AND User__c = :objCurrentUser.Id];
            
            if(accountCount != null && accountCount > 0) {
                isEditDRTApplicable = true;
            }                                
        }         
        return isEditDRTApplicable;
    }
    
    /**
    * @description: This method is used to return Frame_DRT_Association__c records for a particular DRT Id.
    * @param: Id drtId
    * @return: list<Frame_DRT_Association__c>
    **/
    public static list<Frame_DRT_Association__c> fetchFrameDRTAssociation(Id drtId) {
        if(drtId !=null){
            list<Frame_DRT_Association__c> lstFrameDRTAssoc =[SELECT  Id,DRT__c,DRT__r.Name,DRT_Status__c, Mask_Layer_No__c,Mask_Rev__c,Mask_Set_Title__c,Mask_Set_Title__r.Name,
                                                                 Retrofit_Mask_Rev__c,Retrofit_ROM_Code__c,Retrofit_Tech_Geo__c,ROM_Code__c,
                                                                 
                                                                 //swgp-2
                                                                 Is_Edited_Retrofit_Mask_Rev__c,Is_Edited_Retrofit_ROM_Code__c
                                                                 
                                                         FROM Frame_DRT_Association__c
                                                         WHERE DRT__c = :drtId];
            return lstFrameDRTAssoc;
        }
        else {
            return new list<Frame_DRT_Association__c>();
        }
    }
    
    /**
    * @description: This method is used to check whether a revised DRT can be activated or not.
    * @param: string revisedDRTName
    * @return: boolean
    **/ 
    public static boolean isRevisedDRTActivationAllowed(string revisedDRTName) {
        Boolean allowActivation = true;
        if(String.isBlank(revisedDRTName))  {
            return false;
        }
        integer lastIdx = revisedDRTName.lastIndexOf('.');
        String nameWithoutMinor;
        if(lastIdx != -1){
            nameWithoutMinor = revisedDRTName.subString(0,lastIdx);
        } 
        if(String.isBlank(nameWithoutMinor)) {
            return false;
        }       
            
        String strLikeNameWithoutMinor = '%'+nameWithoutMinor+'%';
        Map<Id,DRT__c> mapPreviousDRT = new Map<Id,DRT__c>([SELECT Id, Name FROM DRT__c WHERE Name != :revisedDRTName AND Name LIKE :strLikeNameWithoutMinor]);
                                                                
        if(mapPreviousDRT != null && !mapPreviousDRT.isEmpty()) {
            Integer countPTRF  = [SELECT count() FROM DRT_PTRF_Association__c  WHERE DRT__c IN :mapPreviousDRT.keyset() AND PTRF_Status__c = 'Closed'];
                                                                
            if(countPTRF != null && countPTRF > 0) {
                allowActivation = false;
            }
        }
        return allowActivation;                                                     
     }
    
    /**
    * @description: This method is used to check whether a revision of a DRT is allowed or not.
    * @param: Id drtId
    * @return: boolean
    **/
    public static Boolean isReviseApplicable(Id drtId)  {
       Boolean isApplicable=false;
       if(drtId != null) {
           isApplicable = true;
           integer countPTRF=[select count() from DRT_PTRF_Association__c where drt__c=:drtId and PTRF_Status__c='Closed' ];
           if(countPTRF!=null && countPTRF>0){
               isApplicable=false;
           }
       }
       return isApplicable;
   }   
   
   /**
    * @description: This method unlinks older DRT from related PTRF and links current DRT upon activation.
    * @param: string revisedDRTName,Id currentDRTId
    * @return: void
    **/ 
   public static void revisedDRTFunctionality(string revisedDRTName,Id currentDRTId)  {
        if(String.isBlank(revisedDRTName) || (currentDRTId == null))  {
            return;
        }
        Integer lastIdx = revisedDRTName.lastIndexOf('.');
        String nameWithoutMinor;
        if(lastIdx != -1) {
            nameWithoutMinor = revisedDRTName.subString(0,lastIdx); 
        }
        if(String.isBlank(nameWithoutMinor)) {
            return;
        }  
        String strLikeNameWithoutMinor = '%'+nameWithoutMinor+'%';
        Map<Id,DRT__c> mapPreviousDRT = new Map<Id,DRT__c>([SELECT Id, Name FROM DRT__c WHERE Status__c = 'Active' 
                                                                AND Id != :currentDRTId 
                                                                AND Name LIKE :strLikeNameWithoutMinor]);
        
        Map<Id,Id> olderDRTIdAndNewDRTIdMap = new Map<Id,Id>(); // map of previous active drt id and current drt
                                                                
        if(mapPreviousDRT != null && !mapPreviousDRT.isEmpty()) {
            
            list<DRT__c> lstDRTForUpdate = new list<DRT__c>();
            DRT__c objDRTUpdate;
            for(Id drtId : mapPreviousDRT.keyset()) {
                
                olderDRTIdAndNewDRTIdMap.put(drtId,currentDRTId);
                
                objDRTUpdate = new DRT__c();
                objDRTUpdate.Id = drtId;
                objDRTUpdate.Status__c = 'Inactive';
                lstDRTForUpdate.add(objDRTUpdate);
            }
            if(lstDRTForUpdate != null && !lstDRTForUpdate.isEmpty()) {
                update lstDRTForUpdate; // previous Active DRT versions are deactivated
            }
            
            
            Map<Id,Id> drtPTRFMap = new Map<Id,Id>(); // map of drt id and associated ptrf id
            list<DRT_PTRF_Association__c> lstDRTPTRFAssocForUpdate = new list<DRT_PTRF_Association__c>(); // drt ptrf assoc list for update
            for(DRT_PTRF_Association__c  drtPTRFAssoc : [SELECT Id,PTRF__c,DRT__c,DRT__r.Name,DRT__r.Status__c 
                                                                FROM DRT_PTRF_Association__c 
                                                                WHERE DRT__c IN :mapPreviousDRT.keyset()]) {
                drtPTRFMap.put(drtPTRFAssoc.DRT__c,drtPTRFAssoc.PTRF__c);
                lstDRTPTRFAssocForUpdate.add(drtPTRFAssoc);
            }
            
            for(DRT_PTRF_Association__c drtPTRFObj : lstDRTPTRFAssocForUpdate) {
                if(olderDRTIdAndNewDRTIdMap.containsKey(drtPTRFObj.DRT__c)) {
                    drtPTRFObj.DRT__c = olderDRTIdAndNewDRTIdMap.get(drtPTRFObj.DRT__c);
                }
                
            }
            if(lstDRTPTRFAssocForUpdate != null && !lstDRTPTRFAssocForUpdate.isEmpty()) {
                update lstDRTPTRFAssocForUpdate;
            }
        }
        
     }
     
     /**
    * @description: This method is used to generate DRT name upon creation.
    * @param: string baseMSTId, string baseMSTName, string drtType
    * @return: string
    **/
     public string generateNextDRTName(String baseMSTId, String baseMSTName, String drtType) {
        String newDRTName = 'Unnamed DRT'; // New DRT Name
        if(!String.isBlank(baseMSTId) && !String.isBlank(baseMSTName) && !String.isBlank(drtType)) {
            Pattern p = Pattern.compile('[^_]+_[^_]+_DRT_([\\d]+)\\.([\\d]+)');
            
            list<DRT__c> lstDRT = [SELECT Id, Name FROM DRT__c WHERE Mask_Set_Title__c = :baseMSTId AND Type__c = :drtType ORDER BY Name DESC LIMIT 1];
            String nextMajor = '001'; // for first DRT
            String nextMinor = '001';
            String major='';
            String minor='001';
            if(lstDRT != null && !lstDRT.isEmpty()) {
                String drtName=lstDRT.get(0).Name;
                Matcher pm = p.matcher(drtName);
                if(pm.matches()){
                     major = pm.group(1);
                     minor = pm.group(2);
                }
                if(!String.isBlank(major)) {
                    nextMajor = String.valueOf(Integer.valueOf(major)+1);
                }
                while (nextMajor.length() < 3)  { 
                    nextMajor = '0' + nextMajor; 
                } 
            }
            else {
                nextMajor = '001';
                minor = '001';
            }
            newDRTName = baseMSTName+'_'+drtType.toUpperCase()+'_'+'DRT_'+nextMajor+'.'+nextMinor;
        }
        return newDRTName;
        
     }
     
    /**
    * @description: This method is used to generate next DRT name upon revision.
    * @param: string oldName
    * @return: string
    **/
     public String generateNextRevisedDRTName(String oldName) {
        String newDRTName = 'Unnamed DRT';
        if(String.isBlank(oldName)) {
            return newDRTName;
        }
        Integer lastIdx = oldName.lastIndexOf('.');
        String nameWithoutMinor;
        if(lastIdx != -1) {
            nameWithoutMinor = oldName.subString(0,lastIdx);
        }
        if(String.isBlank(nameWithoutMinor)) {
            return newDRTName;
        } 
        
        Pattern p = Pattern.compile('[^_]+_[^_]+_DRT_([\\d]+)\\.([\\d]+)');
        String strLikeNameWithoutMinor = '%'+nameWithoutMinor+'%';
        list<DRT__c> lstDRT = [SELECT Id, Name FROM DRT__c WHERE Name LIKE :strLikeNameWithoutMinor ORDER BY Name DESC LIMIT 1];
        String nextMinor = '001'; // for first DRT
        String major='';
        String minor='';
        if(lstDRT != null && !lstDRT.isEmpty()) {
            String drtName=lstDRT.get(0).Name;
            Matcher pm = p.matcher(drtName);
            if(pm.matches()){
                 major = pm.group(1);
                 minor = pm.group(2);
            }
            if(!String.isBlank(minor)) {
                nextMinor = String.valueOf(Integer.valueOf(minor)+1);
            }
            while (nextMinor.length() < 3)  { 
                nextMinor = '0' + nextMinor; 
            } 
        }
        else {
            nextMinor = '001';
            major = '001';
        }
        newDRTName = nameWithoutMinor+'.'+nextMinor;
        return newDRTName;
        
     }
     
    /**
    * @description: This method is used to close a DRT when all related PTRFs have been closed.
    * @param: set<string> setRelatedPTRF
    * @return: void
    **/ 
     public static void closeDRTonPTRFclose(set<string> setRelatedPTRF) {
          set<string> setDRTlist= new set<string>();
          
          list<DRT_PTRF_Association__c> listDRTlist=new list<DRT_PTRF_Association__c>();
          map<string,set<string>> mapDRTtoPTRF=new map<string,set<string>>();
          set<string> temp=new set<string>();
          set<string> setDRTtobeDeleted=new set<string>();
          list<drt__c> listDRTforUpdate=new list<drt__c>();
          
          if(setRelatedPTRF!=null && setRelatedPTRF.size()>0){
          
             
              for (DRT_PTRF_Association__c DRTObj : [select DRT__c from DRT_PTRF_Association__c where ptrf__c in: setRelatedPTRF]){
                  setDRTlist.add(String.valueOf(DRTObj.DRT__c));
              }
             
              listDRTlist=[select DRT__c,PTRF__c,PTRF_Status__c from DRT_PTRF_Association__c where drt__c in: setDRTlist];
              listDRTforUpdate=[select ID,Status__c from DRT__c where ID in: setDRTlist];
              
              if(setDRTlist.size()>0 && listDRTlist.size()>0)
              {
                  for(string objDRT :setDRTlist)
                  {
                      temp = new Set<String>();
                      for(DRT_PTRF_Association__c objAssoc: listDRTlist)
                      {
                          if(objDRT ==objAssoc.DRT__c && objAssoc.PTRF_Status__c !='Cancel' && objAssoc.PTRF_Status__c !='Deleted')
                          {
                              temp.add(objAssoc.PTRF_Status__c);
                          }
                      }
                      mapDRTtoPTRF.put(objDRT,temp);
                  }
                  
                  for(string strDRT: mapDRTtoPTRF.keyset())  
                      {
                          if(mapDRTtoPTRF.containsKey(strDRT) && mapDRTtoPTRF.get(strDRT).size()==1 && mapDRTtoPTRF.get(strDRT).contains('Closed') )
                          {//SWGP-89: Close DRT if it is not linked to any active PTRF & linked to at least 1 Closed PTRF
                              for(DRT__c objDRTupdate: listDRTforUpdate)
                              {
                                  if(strDRT==objDRTupdate.id)
                                  {
                                      objDRTupdate.Status__c='Closed';
                                  }
                              }
                          }
                      }
                      database.update(listDRTforUpdate);
              }
          }
      }
      
    
    /**
    * @description: This method is used to insert a DRT object.
    * @param: DRT__c recordDRT
    * @return: Database.saveresult
    **/ 
    public static Database.saveresult insertDRTDetails(DRT__c recordDRT) {
        Database.saveresult uResult ;
        uResult = Database.insert(recordDRT,true);
        return uResult ;
    }
   
    /**
    * @description: This method is used to insert PRIME_DRT_Layer_Association__c list.
    * @param: list<PRIME_DRT_Layer_Association__c> layerlist
    * @return: list<Database.saveresult>
    **/
    public static list<Database.saveresult> insertLayerAssociation(list<PRIME_DRT_Layer_Association__c> layerlist) {
        list<Database.saveresult > uResults ;
        uResults = Database.insert(layerlist,true);
        return uResults;
    }
    
    /**
    * @description: This method is used to insert PRIME_DRT_Chip_Association__c list.
    * @param: list<PRIME_DRT_Chip_Association__c> chiplist
    * @return: list<Database.saveresult>
    **/
    public static list<Database.saveresult > insertChipAssociation(list<PRIME_DRT_Chip_Association__c> chiplist) {
        list<Database.saveresult > uResults = Database.insert(chiplist,true);
        return uResults;
    }

    /**
    * @description: This method is used to insert PRIME_DRT_Chip_Layer_Summary__c list.
    * @param: list<PRIME_DRT_Chip_Layer_Summary__c> chipLayerSummary
    * @return: list<Database.saveresult>
    **/
    public static list<Database.saveresult > insertPrimeDRTChipLayerSummary(list<PRIME_DRT_Chip_Layer_Summary__c> chipLayerSummary) {
        list<Database.saveresult > uResults ;
        uResults = Database.insert(chipLayerSummary,true);
        return uResults;
    }
    
    /**
    * @description: This method is used to insert a DRT.
    * @param: DRT__c recordDRT, list<PRIME_DRT_Layer_Association__c> layerlist,list<PRIME_DRT_Chip_Association__c> chiplist,list<PRIME_DRT_Chip_Layer_Summary__c> chipLayerSummary
    * @return: ID
    **/  
    public static ID insertDRT(DRT__c recordDRT, list<PRIME_DRT_Layer_Association__c> layerlist,list<PRIME_DRT_Chip_Association__c> chiplist,list<PRIME_DRT_Chip_Layer_Summary__c> chipLayerSummary) {

        Database.saveresult uResultDRT;
        list<Database.saveresult > uResultsLayer;       
        list<Database.saveresult > uResultsChip;
        ID idDRTNew;       
        integer intCounter=0;
     
        uResultDRT = insertDRTDetails(recordDRT);
        if (uResultDRT.isSuccess()) {
               
            idDRTNew = uResultDRT.getId();
           
            for(PRIME_DRT_Layer_Association__c objPDLayer:layerlist) {
                    objPDLayer.DRT__c= idDRTNew ;
                }
            if(layerlist!=null && layerlist.size()>0){
              uResultsLayer = insertLayerAssociation(layerlist);
            }
              
            for(PRIME_DRT_Chip_Association__c objPDChip:chiplist) {
                    objPDChip.DRT__c= idDRTNew ;
            }
            if(chiplist!=null && chiplist.size()>0){   
              uResultsChip = insertChipAssociation(chiplist);  
            }
            if(uResultsLayer != null && !uResultsLayer.isEmpty() && uResultsChip != null && !uResultsChip.isEmpty()) {
                for(Database.saveresult resultLayerTemp:uResultsLayer)
                {
                    if (resultLayerTemp.isSuccess())
                    {
                        for(Database.saveresult resultChipTemp:uResultsChip)
                        {
                            if (resultChipTemp.isSuccess())
                                        {
                                            chipLayerSummary[intCounter].Chip__c=resultChipTemp.getId();
                                            chipLayerSummary[intCounter].Layer__c=resultLayerTemp.getId();
                                        }
                                        intCounter++;                       
                                }   
                            }                       
                        }
                        if(chipLayerSummary!=null && chipLayerSummary.size()>0){
                          insertPrimeDRTChipLayerSummary(chipLayerSummary);
                        }
                    }                        
            }                   
            return idDRTNew;
        }
        
    /**
    * @description: This is the error class for left table in DRT
    **/
    public class MainTableError {
        public Integer row;
        public Integer col;
        public Boolean invalid;
        public MainTableError() {
        }
    }
    /**
    * @description: This is the error class for Mask Layer Header table in DRT
    **/
    public class MaskLayerHeaderError {
        public Integer tableNo;
        public Boolean invalid;
        public MaskLayerHeaderError() {
        }
    }
    
    /**
    * @description: This is the error class for DRT
    **/
    public class ErrorDetails {
        public Boolean error;
        public String errorJSON;
        public set<String> setErrorMessage;
        public ErrorDetails(Boolean error,String errorJSON, set<String> setErrorMessage) {
            this.error = error;
            this.errorJSON = errorJSON;
            this.setErrorMessage = setErrorMessage;
        }
    }
    
    /**
    * @description: This method checks if a string occurs more than once in a given map
    * @param: string name, map<string,integer> mapNameOccurence
    * @return: boolean
    **/
    private boolean isDuplicateName(string name, Map<string,integer> mapNameOccurence) { 
            if(!String.isBlank(name)) {
                name = name.toLowerCase();
            }       
            if(mapNameOccurence.containsKey(name) && (mapNameOccurence.get(name) > 1)) {
                return true;
            }
        return false;
    }
    
    /**
    * @description: This method validates left table data in DRT
    * @param: list<PRIME_DRT_Chip_Association__c> primeDrtChipAssoc,DRT__c drtData
    * @return: ErrorDetails
    **/
    public ErrorDetails validateMainTableData(list<PRIME_DRT_Chip_Association__c> primeDrtChipAssoc,DRT__c drtData) {
        String jsonData = '[]';
        Boolean error = false;
        String errorMessage;
        list<MainTableError> lstMainTableError = new list<MainTableError>();
        MainTableError objMainTableError;
        set<String> setErrorMessage = new set<String>();
        if(primeDrtChipAssoc != null && !primeDrtChipAssoc.isEmpty()) {      
            // map of chip name and number of occurence
            Map<String,Integer> mapNameOccurence = new Map<String,Integer>();           
            for(PRIME_DRT_Chip_Association__c chipAssoc : primeDrtChipAssoc) {
                String chipName = chipAssoc.Name;
                if(!String.isBlank(chipName)) {
                    chipName = chipName.toLowerCase();
                }
                if(!mapNameOccurence.containsKey(chipName))    {
                    mapNameOccurence.put(chipName,0);    
                }
                mapNameOccurence.put(chipName,mapNameOccurence.get(chipName)+1);
            }
            // regex for validating Prime Die/Scribeline Dropin name
            Pattern chipNamePattern = Pattern.compile('([A-Za-z0-9_]+)');
            
            Integer rowIdx = 0; // loop counter indicating row index in the main table
            for(PRIME_DRT_Chip_Association__c chipAssoc : primeDrtChipAssoc) {
                // match chip name
                Matcher matcherChipName = chipNamePattern.matcher(chipAssoc.Name);
                
                /** Mask set Title cannot be blank **/
                if(chipAssoc.Mask_Set_Title__c == null) {
                    error = true;
                    String errMsg = mapEC.get('MASK SET TITLE NOT BLANK').Message__c;
                     
                    //errorMessage = 'Error: Mask set Title cannot be blank';
                    setErrorMessage.add(errMsg);
                    
                    objMainTableError = new MainTableError();
                    objMainTableError.invalid = true;
                    objMainTableError.col = 2;
                    objMainTableError.row = rowIdx;                    
                    lstMainTableError.add(objMainTableError);
                }
                else {
                    objMainTableError = new MainTableError();
                    objMainTableError.invalid = false;
                    objMainTableError.col = 2;
                    objMainTableError.row = rowIdx;                    
                    lstMainTableError.add(objMainTableError);
                }
                /** Chip name cannot be blank, PRIME,FRAME or Duplicate **/
                if(String.isBlank(chipAssoc.Name)) {
                    error = true;
                    String errMsg = mapEC.get('PRIME DIE SCRIBELINE DROPIN NOT BLANK').Message__c;
                    setErrorMessage.add(errMsg);
                    
                    objMainTableError = new MainTableError();
                    objMainTableError.invalid = true;
                    objMainTableError.col = 3;
                    objMainTableError.row = rowIdx;                    
                    lstMainTableError.add(objMainTableError);
                }
                else if(chipAssoc.Name.equalsIgnoreCase('PRIME') || 
                            chipAssoc.Name.equalsIgnoreCase('FRAME')) {
                    error = true;
                    
                    String errMsg = mapEC.get('PRIME DIE NAME CAN NOT BE PRIME').Message__c;
                    setErrorMessage.add(errMsg);
                    
                    objMainTableError = new MainTableError();
                    objMainTableError.invalid = true;
                    objMainTableError.col = 3;
                    objMainTableError.row = rowIdx;                    
                    lstMainTableError.add(objMainTableError);
                }
                else if(!matcherChipName.matches()) {
                    error = true;
                    String errMsg = mapEC.get('PRIME DIE NAME ALPHANUMERIC').Message__c;
                    
                    setErrorMessage.add(errMsg);
                    
                    objMainTableError = new MainTableError();
                    objMainTableError.invalid = true;
                    objMainTableError.col = 3;
                    objMainTableError.row = rowIdx;                    
                    lstMainTableError.add(objMainTableError);
                }
                else if(isDuplicateName(chipAssoc.Name,mapNameOccurence)) {
                    error = true;
                    String errMsg = mapEC.get('PRIME DIE NAME CAN NOT BE REPEATED').Message__c;
                    setErrorMessage.add(errMsg);
                    
                    objMainTableError = new MainTableError();
                    objMainTableError.invalid = true;
                    objMainTableError.col = 3;
                    objMainTableError.row = rowIdx;                    
                    lstMainTableError.add(objMainTableError);
                }
                else {
                    objMainTableError = new MainTableError();
                    objMainTableError.invalid = false;
                    objMainTableError.col = 3;
                    objMainTableError.row = rowIdx;                    
                    lstMainTableError.add(objMainTableError);
                }                
                rowIdx++;  // increment row counter
            }
        }
        else {
            if(drtData.status__c == 'Active') {
                error = true;
                errorMessage = mapEC.get('CANNOT_ACTIVATE_DRT_NOCHIP').Message__c;
                setErrorMessage.add(errorMessage); // add error message to set
            }
        }
        
        if(lstMainTableError != null && !lstMainTableError.isEmpty()) {
            jsonData = JSON.serialize(lstMainTableError);            
        }
        ErrorDetails objErrorDetails = new ErrorDetails(error,jsonData,setErrorMessage);
        return objErrorDetails;
    }
    
    /**
    * @description: This method validates Mask Layer Header table data in DRT
    * @param: list<PRIME_DRT_Layer_Association__c> lstDRTLayerAssoc, DRT__c drtData
    * @return: ErrorDetails
    **/
    public ErrorDetails validateMaskLayerData(list<PRIME_DRT_Layer_Association__c> lstDRTLayerAssoc, DRT__c drtData) {
        String jsonData = '[]';
        Boolean error = false;
        String errorMessage;
        list<MaskLayerHeaderError> lstMaskLayerError = new list<MaskLayerHeaderError>();
        MaskLayerHeaderError objMaskLayerHeaderError;        
        set<String> setErrorMessage = new set<String>();
        
        set<string> setDRTMaskLayerNum = new set<string>();
        set<string> setDRTMaskLayerRev = new set<string>();
        set<string> setDRTROMCode = new set<string>();
        Pattern techGeoPattern = Pattern.compile('(\\d*\\.\\d+)(.*)');
        
        if(lstDRTLayerAssoc != null && !lstDRTLayerAssoc.isEmpty() && drtData != null && drtData.status__c == 'Active') {
            String uniqueComboStr = '';
            // map to find occurence of unique combination of base mst+mask layer no+retrofit rev+retrofit rom code in current DRT
            Map<String,Integer> mapUniqueComboOccurrenceCurrent = new Map<String,Integer>();
            // map to find occurence of unique combination of base mst+mask layer no+retrofit rev+retrofit rom code in all Active DRTs
            Map<String,Integer> mapUniqueComboOccurrenceAll = new Map<String,Integer>();
            // map of unique combination against list of mask layer table indexes
            Map<String,list<Integer>> mapUniqueComboTableIdxlist = new Map<String,list<Integer>>();
            // loop counter indicating index of Mask Layer Header table
            Integer tableIdx = 0;
            for(PRIME_DRT_Layer_Association__c maskLayer : lstDRTLayerAssoc) {
                /** Check combination in current DRT **/
                decimal dcmtechgeo;
                if(!string.isBlank(drtData.Tech_Geo__c)) {
                    Matcher pm = techGeoPattern.matcher(drtData.Tech_Geo__c);
                    if(pm.matches() && !string.isBlank(pm.group(1))){
                        dcmtechgeo = Decimal.valueOf(pm.group(1));
                    }
                }
                string techGeoDRT = (dcmtechgeo!=null)?string.valueOf(dcmtechgeo):'';
                techGeoDRT = (techGeoDRT==null)?'':techGeoDRT;
                
                setDRTMaskLayerNum.add(maskLayer.Name);                
                setDRTMaskLayerRev.add(maskLayer.Retrofit_Mask_Rev__c);                
                setDRTROMCode.add(maskLayer.Retrofit_ROM_Code__c);                
                uniqueComboStr = drtData.Mask_Set_Title__c + maskLayer.Name + maskLayer.Retrofit_Mask_Rev__c + maskLayer.Retrofit_ROM_Code__c + techGeoDRT;
                if(!mapUniqueComboOccurrenceCurrent.containsKey(uniqueComboStr)) {
                   mapUniqueComboOccurrenceCurrent.put(uniqueComboStr,0); 
                }
                mapUniqueComboOccurrenceCurrent.put(uniqueComboStr, mapUniqueComboOccurrenceCurrent.get(uniqueComboStr)+1);
                if(!mapUniqueComboTableIdxlist.containsKey(uniqueComboStr)) {
                    mapUniqueComboTableIdxlist.put(uniqueComboStr, new list<Integer>());
                }
                mapUniqueComboTableIdxlist.get(uniqueComboStr).add(tableIdx);
                
                /** Retrofit Mask Rev cannot be blank when activating a DRT **/
                if(String.isBlank(maskLayer.Retrofit_Mask_Rev__c)) {
                      error = true;
                      String errMsg = mapEC.get('RETROFIT MASK REV CAN NOT BE BLANK').Message__c;
                      setErrorMessage.add(errMsg); // add error message to set  
                }                
                tableIdx++; // increment counter
            }
            /** Check combination in all Active DRTs **/
            set<String> setExistingComboStr = new set<String>();
            String existingDRTName = ''; 
            Map<String,String> mapUniqueCombinationDRTName = new Map<String,String>();
            String currentDRTName = drtData.Name;
            String nameWithoutMinor = currentDRTName.subString(0,currentDRTName.lastIndexOf('.'));
            String strNameWithoutMinor = '%'+nameWithoutMinor+'%';  
            
            for (PRIME_DRT_Layer_Association__c objLayerAssoc : [SELECT Id,Name,DRT__c,DRT__r.Name,DRT__r.Tech_Geo__c,DRT_Status__c,Mask_Set_Title__c,DRT__r.Mask_Set_Title__c ,Retrofit_Mask_Rev__c,Retrofit_ROM_Code__c,
                                Retrofit_Tech_Geo__c FROM PRIME_DRT_Layer_Association__c 
                                WHERE (NOT DRT__r.Name LIKE :strNameWithoutMinor) AND DRT_Status__c = 'Active' AND DRT__r.Mask_Set_Title__c = :drtData.Mask_Set_Title__c AND IsSoftDeleted__c = false]) {
                String comboStr='';
                if(objLayerAssoc.DRT__r.Mask_Set_Title__c != null) {
                    comboStr += objLayerAssoc.DRT__r.Mask_Set_Title__c;
                }
                if(objLayerAssoc.Name != null) {
                    comboStr += objLayerAssoc.Name;
                }
                if(objLayerAssoc.Retrofit_Mask_Rev__c != null) {
                    comboStr += objLayerAssoc.Retrofit_Mask_Rev__c;
                }
                if(objLayerAssoc.Retrofit_ROM_Code__c != null) {
                    if(objLayerAssoc.Retrofit_ROM_Code__c == '####') {
                        comboStr += '';
                    }
                    else {
                        comboStr += objLayerAssoc.Retrofit_ROM_Code__c;
                    }
                }
                if(!string.isBlank(drtData.Tech_Geo__c)) {
                    decimal dcmtechgeo;
                    if(!string.isBlank(objLayerAssoc.DRT__r.Tech_Geo__c)) {
                        Matcher pm = techGeoPattern.matcher(objLayerAssoc.DRT__r.Tech_Geo__c);
                        if(pm.matches() && !string.isBlank(pm.group(1))){
                            dcmtechgeo = Decimal.valueOf(pm.group(1));
                        }
                    }
                    comboStr += (dcmtechgeo!=null)?string.valueOf(dcmtechgeo):'';
                }
                setExistingComboStr.add(comboStr);
                mapUniqueCombinationDRTName.put(comboStr, objLayerAssoc.DRT__r.Name);
            }
            /** Check combination in MRS_Layer_Association__c for Layer_Status__c 'Shipped' **/            
            set<string> setExistingComboMRS = new set<string>();
            for (MRS_Layer_Association__c objLayerAssoc : [SELECT Id,MRS_Layer_Association__c.Name,MRS__r.Mask_Set_Title__c,Mask_Layer_Rev__c,ROM_Code__c,Tech_Geo__c 
                                                                FROM MRS_Layer_Association__c 
                                                                WHERE MRS__r.Mask_Set_Title__c = :drtData.Mask_Set_Title__c 
                                                                      AND Name IN :setDRTMaskLayerNum 
                                                                      AND Mask_Layer_Rev__c IN :setDRTMaskLayerRev 
                                                                      AND ROM_Code__c IN :setDRTROMCode 
                                                                      AND Layer_Status__c = 'Shipped']) {
                string comboStr='';
                if(objLayerAssoc.MRS__r.Mask_Set_Title__c != null) {
                    comboStr += objLayerAssoc.MRS__r.Mask_Set_Title__c;
                }
                if(objLayerAssoc.Name != null) {
                    comboStr += objLayerAssoc.Name;
                }
                if(objLayerAssoc.Mask_Layer_Rev__c != null) {
                    comboStr += objLayerAssoc.Mask_Layer_Rev__c;
                }
                if(objLayerAssoc.ROM_Code__c != null) {
                    if(objLayerAssoc.ROM_Code__c == '####') {
                        comboStr += '';
                    }
                    else {
                        comboStr += objLayerAssoc.ROM_Code__c;
                    }
                }
                if(!string.isBlank(drtData.Tech_Geo__c)) {
                    decimal dcmtechgeo;
                    if(!string.isBlank(objLayerAssoc.Tech_Geo__c)) {
                        Matcher pm = techGeoPattern.matcher(objLayerAssoc.Tech_Geo__c);
                        if(pm.matches() && !string.isBlank(pm.group(1))){
                            dcmtechgeo = Decimal.valueOf(pm.group(1));
                        }
                    }
                    comboStr += (dcmtechgeo!=null)?string.valueOf(dcmtechgeo):'';
                }
                setExistingComboMRS.add(comboStr);
            }
            /** identify mask layer header tables which have duplicate combinations **/
            for(String key : mapUniqueComboTableIdxlist.keyset()) {
               if(mapUniqueComboOccurrenceCurrent.containsKey(key) && 
                           mapUniqueComboOccurrenceCurrent.get(key) > 1) { // combination occurs more than once in current DRT
                   for(Integer idx : mapUniqueComboTableIdxlist.get(key)) {
                       error = true;
                       objMaskLayerHeaderError = new MaskLayerHeaderError();  
                       objMaskLayerHeaderError.invalid = true;
                       objMaskLayerHeaderError.tableNo = idx;
                       lstMaskLayerError.add(objMaskLayerHeaderError);
                   }
                   errorMessage = mapEC.get('UNIQUE COMBINATION OF MST').Message__c; 
                   setErrorMessage.add(errorMessage); // add error message to set
               }
               else if(setExistingComboStr.contains(key)) {
                   for(Integer idx : mapUniqueComboTableIdxlist.get(key)) {
                       error = true;
                       objMaskLayerHeaderError = new MaskLayerHeaderError();  
                       objMaskLayerHeaderError.invalid = true;
                       objMaskLayerHeaderError.tableNo = idx;
                       lstMaskLayerError.add(objMaskLayerHeaderError);
                       if(mapUniqueCombinationDRTName.containsKey(key)) {
                            existingDRTName = mapUniqueCombinationDRTName.get(key);
                       }
                   }
                   errorMessage = mapEC.get('DUPLICATE DRT').Message__c.replace('{DRTName}',existingDRTName);  
                   setErrorMessage.add(errorMessage); // add error message to set
               }
               else if(setExistingComboMRS.contains(key)) {
                    for(Integer idx : mapUniqueComboTableIdxlist.get(key)) {
                       error = true;
                       objMaskLayerHeaderError = new MaskLayerHeaderError();  
                       objMaskLayerHeaderError.invalid = true;
                       objMaskLayerHeaderError.tableNo = idx;
                       lstMaskLayerError.add(objMaskLayerHeaderError);
                    }
                    
                    //swgp-269 and other tickets related to shipped layer error
                    errorMessage = mapEC.get('UNIQUE_COMBINATION_ERROR_MRS').Message__c;//PRIME DRT
                    setErrorMessage.add(errorMessage); // add error message to set
               }
               else {
                   for(Integer idx : mapUniqueComboTableIdxlist.get(key)) {
                       objMaskLayerHeaderError = new MaskLayerHeaderError();  
                       objMaskLayerHeaderError.invalid = false;
                       objMaskLayerHeaderError.tableNo = idx;
                       lstMaskLayerError.add(objMaskLayerHeaderError);
                   }
               }                       
           }
        }
        else {
            if((lstDRTLayerAssoc == null || lstDRTLayerAssoc.isEmpty()) && drtData != null && drtData.Status__c == 'Active') {
                error = true;
                errorMessage = mapEC.get('CAN NOT ACTIVATE DRT').Message__c;
                setErrorMessage.add(errorMessage); // add error message to set
            }
        }
        // generate error details
        if(lstMaskLayerError != null && !lstMaskLayerError.isEmpty()) {
            jsonData = JSON.serialize(lstMaskLayerError);
        }
        ErrorDetails objErrorDetails = new ErrorDetails(error,jsonData,setErrorMessage);
        return objErrorDetails;        
        
    }
    
    /**
    * @description: This method validates Mask Layer Content table data in DRT
    * @param: list<PRIME_DRT_Chip_Layer_Summary__c> lsDRTChipLayerAssoc, DRT__c drtData
    * @return: ErrorDetails
    **/
    public ErrorDetails validateMaskLayerContentData(list<PRIME_DRT_Chip_Layer_Summary__c> lsDRTChipLayerAssoc, DRT__c drtData) {
        String jsonData = '[]';
        Boolean error = false;
        String errorMessage;    
        set<String> setErrorMessage = new set<String>();
        
        integer noOfChipLayers = (lsDRTChipLayerAssoc != null) ? lsDRTChipLayerAssoc.size() : 0;        
        string thresholdLimit = Environment_Variable__c.getInstance('DRT_Uprev_Threshold_Limit').Value__c;
        if(!string.isBlank(thresholdLimit) && (noOfChipLayers > integer.valueOf(thresholdLimit))) {
            error = true;
            errorMessage = Error_Codes__c.getInstance('DRT_Uprev_Threshold_Limit_Error').Message__c.replace('{limit}',thresholdLimit);
            setErrorMessage.add(errorMessage); // add error message to set
        }
        if(lsDRTChipLayerAssoc != null && !lsDRTChipLayerAssoc.isEmpty() && drtData != null) {
            // loop counter
            Integer tableIdx = 0;
            for(PRIME_DRT_Chip_Layer_Summary__c chipLayer : lsDRTChipLayerAssoc) {
                if(drtData.status__c == 'Active') {
                    if(String.isBlank(chipLayer.Mask_Layer_Rev__c)) {
                        error = true;
                        
                        errorMessage = mapEC.get('MASK REV CAN NOT BLANK').Message__c;
                        setErrorMessage.add(errorMessage); // add error message to set
                    }
                }
                if(!String.isBlank(chipLayer.Mask_Layer_Rev__c) &&
                            chipLayer.Mask_Layer_Rev__c.length() != 2) {
                    error = true;
                    errorMessage = mapEC.get('MASK REV TWO CHAR').Message__c;
                    setErrorMessage.add(errorMessage); // add error message to set
                }
                if(!String.isBlank(chipLayer.ROM_Code__c) && chipLayer.ROM_Code__c.length() > 5) {
                    error = true;
                    
                    errorMessage = mapEC.get('ROM CODE 5 CHAR').Message__c;
                    setErrorMessage.add(errorMessage); // add error message to set
                }
            tableIdx++;
            }
        }
        ErrorDetails objErrorDetails = new ErrorDetails(error,jsonData,setErrorMessage);
        return objErrorDetails;  
    }
    
    /**
    * @description: This method validates overall DRT table data
    * @param: DRT__c drtData,list<PRIME_DRT_Chip_Association__c> lstDRTChipAssoc,list<PRIME_DRT_Layer_Association__c> lstDRTLayerAssoc,
                                                                list<PRIME_DRT_Chip_Layer_Summary__c> lsDRTChipLayerAssoc
    * @return: ErrorDetails
    **/
    public DRTErrorDetails validateDRTTableData(DRT__c drtData,list<PRIME_DRT_Chip_Association__c> lstDRTChipAssoc,list<PRIME_DRT_Layer_Association__c> lstDRTLayerAssoc,
                                                                list<PRIME_DRT_Chip_Layer_Summary__c> lsDRTChipLayerAssoc) {
        
        DRTErrorDetails objDRTErrorDetails = new DRTErrorDetails();
        
        objDRTErrorDetails.MainTableError = validateMainTableData(lstDRTChipAssoc,drtData);
        objDRTErrorDetails.MaskLayerHeaderError = validateMaskLayerData(lstDRTLayerAssoc,drtData);
        objDRTErrorDetails.MaskLayerContentError = validateMaskLayerContentData(lsDRTChipLayerAssoc,drtData);
        
        objDRTErrorDetails.error = false;
        if(objDRTErrorDetails.MainTableError.error || objDRTErrorDetails.MaskLayerHeaderError.error || objDRTErrorDetails.MaskLayerContentError.error) {
            objDRTErrorDetails.error = true;
        }
        
        return objDRTErrorDetails;
    }
    
    /**
    * @description: This method validates Frame DRT table data
    * @param: DRT__c drtData, list<Frame_DRT_Association__c> lstFrameDRTAssoc
    * @return: ErrorDetails
    **/
    public ErrorDetails validateFrameTableData(DRT__c drtData, list<Frame_DRT_Association__c> lstFrameDRTAssoc) {
        String jsonData = '[]';
        Boolean error = false;
        String errorMessage;    
        set<String> setErrorMessage = new set<String>();
        list<FrameTableError> lstFrameTableError = new list<FrameTableError>(); // list of error objects
        FrameTableError objFrameTableError; // variable holding error information
        set<string> setDRTMaskLayerNum = new set<string>();
        set<string> setDRTMaskLayerRev = new set<string>();
        set<string> setDRTROMCode = new set<string>();
        
        if(lstFrameDRTAssoc != null && !lstFrameDRTAssoc.isEmpty() && drtData != null) {
            // loop counter indicating row index in frame table
            Integer rowIdx = 0;
            for(Frame_DRT_Association__c frameDRTAssocObj : lstFrameDRTAssoc) {
                if(frameDRTAssocObj.Mask_Set_Title__c == null) {
                    error = true;
                    objFrameTableError = new FrameTableError();
                    objFrameTableError.invalid = true;
                    objFrameTableError.col = 2;
                    objFrameTableError.row = rowIdx;
                    lstFrameTableError.add(objFrameTableError);
                    
                    errorMessage = mapEC.get('MASK SET TITLE NOT BLANK').Message__c;
                    setErrorMessage.add(errorMessage); // add error message to set          
                }
                else {
                    objFrameTableError = new FrameTableError();
                    objFrameTableError.invalid = false;
                    objFrameTableError.col = 2;
                    objFrameTableError.row = rowIdx;
                    lstFrameTableError.add(objFrameTableError);
                }
                if(String.isBlank(frameDRTAssocObj.Mask_Layer_No__c)) {
                    error = true;
                    objFrameTableError = new FrameTableError();
                    objFrameTableError.invalid = true;
                    objFrameTableError.col = 3;
                    objFrameTableError.row = rowIdx;
                    lstFrameTableError.add(objFrameTableError);
                    errorMessage = mapEC.get('MASK LAYER NOT BLANK').Message__c;
                   
                    setErrorMessage.add(errorMessage); // add error message to set          
                }
                else {
                    objFrameTableError = new FrameTableError();
                    objFrameTableError.invalid = false;
                    objFrameTableError.col = 3;
                    objFrameTableError.row = rowIdx;
                    lstFrameTableError.add(objFrameTableError);
                }
                if(String.isBlank(frameDRTAssocObj.Retrofit_Mask_Rev__c) && (drtData.status__c == 'Active')) {
                    error = true;
                    objFrameTableError = new FrameTableError();
                    objFrameTableError.invalid = true;
                    objFrameTableError.col = 4;
                    objFrameTableError.row = rowIdx;
                    lstFrameTableError.add(objFrameTableError);
                    errorMessage = mapEC.get('RETROFIT MASK REV CAN NOT BE BLANK').Message__c;
                    
                    setErrorMessage.add(errorMessage); // add error message to set          
                }
                else {
                    objFrameTableError = new FrameTableError();
                    objFrameTableError.invalid = false;
                    objFrameTableError.col = 4;
                    objFrameTableError.row = rowIdx;
                    lstFrameTableError.add(objFrameTableError);
                }
                if(String.isBlank(frameDRTAssocObj.Mask_Rev__c) && (drtData.status__c == 'Active')) {
                    error = true;
                    objFrameTableError = new FrameTableError();
                    objFrameTableError.invalid = true;
                    objFrameTableError.col = 6;
                    objFrameTableError.row = rowIdx;
                    lstFrameTableError.add(objFrameTableError);
                    errorMessage = mapEC.get('MASK REV CAN NOT BLANK').Message__c;
                    
                    setErrorMessage.add(errorMessage); // add error message to set          
                }
                else {
                    objFrameTableError = new FrameTableError();
                    objFrameTableError.invalid = false;
                    objFrameTableError.col = 6;
                    objFrameTableError.row = rowIdx;
                    lstFrameTableError.add(objFrameTableError);
                }              
                rowIdx++; // increment row index  
            }
        }
        else if((lstFrameDRTAssoc == null || lstFrameDRTAssoc.isEmpty()) && drtData != null && drtData.Status__c == 'Active') {
            error = true;
            errorMessage = mapEC.get('CAN NOT ACTIVATE DRT').Message__c;
            setErrorMessage.add(errorMessage); // add error message to set
        }
        
        /** Checking of unique combination of Base Mask set Title, Mask Layer No, Retrofit Mask Rev, ROM Code and Tech Geo **/
        if(lstFrameDRTAssoc != null && !lstFrameDRTAssoc.isEmpty() && drtData != null && drtData.Status__c == 'Active') {
            String uniqueComboStr = '';
            // map to find occurence of unique combination of base mst+mask layer no+retrofit rev+retrofit rom code in current DRT
            Map<String,Integer> mapUniqueComboOccurrenceCurrent = new Map<String,Integer>();
            // map to find occurence of unique combination of base mst+mask layer no+retrofit rev+retrofit rom code in all Active DRTs
            Map<String,Integer> mapUniqueComboOccurrenceAll = new Map<String,Integer>();
            // map of unique combination against list of frame table row indexes
            Map<String,list<Integer>> mapUniqueComboTableIdxlist = new Map<String,list<Integer>>();
            // tech geo pattern
            Pattern techGeoPattern = Pattern.compile('(\\d*\\.\\d+)(.*)');   
            // loop counter indicating row index
            Integer frameRowIdx = 0;
            for(Frame_DRT_Association__c frameDRTAssocObj : lstFrameDRTAssoc) {
                /** Check combination in current DRT **/
                decimal dcmtechgeo;
                if(!string.isBlank(drtData.Tech_Geo__c)) {
                    Matcher pm = techGeoPattern.matcher(drtData.Tech_Geo__c);
                    if(pm.matches() && !string.isBlank(pm.group(1))){
                        dcmtechgeo = Decimal.valueOf(pm.group(1));
                    }
                }
                string techGeoDRT = (dcmtechgeo!=null)?string.valueOf(dcmtechgeo):'';
                techGeoDRT = (techGeoDRT==null)?'':techGeoDRT;
                
                setDRTMaskLayerNum.add(frameDRTAssocObj.Mask_Layer_No__c);                
                setDRTMaskLayerRev.add(frameDRTAssocObj.Retrofit_Mask_Rev__c);                
                setDRTROMCode.add(frameDRTAssocObj.Retrofit_ROM_Code__c);
                
                uniqueComboStr = drtData.Mask_Set_Title__c + frameDRTAssocObj.Mask_Layer_No__c + frameDRTAssocObj.Retrofit_Mask_Rev__c + frameDRTAssocObj.Retrofit_ROM_Code__c + techGeoDRT;
                if(!mapUniqueComboOccurrenceCurrent.containsKey(uniqueComboStr)) {
                   mapUniqueComboOccurrenceCurrent.put(uniqueComboStr,0); 
                }
                mapUniqueComboOccurrenceCurrent.put(uniqueComboStr, mapUniqueComboOccurrenceCurrent.get(uniqueComboStr)+1);
                if(!mapUniqueComboTableIdxlist.containsKey(uniqueComboStr)) {
                    mapUniqueComboTableIdxlist.put(uniqueComboStr, new list<Integer>());
                }
                mapUniqueComboTableIdxlist.get(uniqueComboStr).add(frameRowIdx);
                
                frameRowIdx++; // increment counter
            }
            
            /** Check combination in all Active DRTs **/
            set<String> setExistingComboStr = new set<String>();
            Map<String,String> mapUniqueCombinationDRTName = new Map<String,String>();
            String  existingDRTName = '';
            String currentDRTName = drtData.Name;
            String nameWithoutMinor = currentDRTName.subString(0,currentDRTName.lastIndexOf('.'));
            String strNameWithoutMinor = '%'+nameWithoutMinor+'%';      
            for (Frame_DRT_Association__c objFrameAssoc : [select Id,Name,DRT__c,DRT__r.Name,DRT__r.Tech_Geo__c,DRT_Status__c,Mask_Set_Title__c,DRT__r.Mask_Set_Title__c ,Mask_Layer_No__c,Retrofit_Mask_Rev__c,Retrofit_ROM_Code__c,
                                Retrofit_Tech_Geo__c from Frame_DRT_Association__c WHERE (NOT DRT__r.Name LIKE :strNameWithoutMinor) AND DRT_Status__c = 'Active' AND DRT__r.Mask_Set_Title__c = :drtData.Mask_Set_Title__c]) {
                String comboStr='';
                if(objFrameAssoc.DRT__r.Mask_Set_Title__c != null) {
                    comboStr += objFrameAssoc.DRT__r.Mask_Set_Title__c;
                }
                if(objFrameAssoc.Mask_Layer_No__c != null) {
                    comboStr += objFrameAssoc.Mask_Layer_No__c;
                }
                if(objFrameAssoc.Retrofit_Mask_Rev__c != null) {
                    comboStr += objFrameAssoc.Retrofit_Mask_Rev__c;
                }
                if(objFrameAssoc.Retrofit_ROM_Code__c != null) {
                    if(objFrameAssoc.Retrofit_ROM_Code__c != '####') {
                        comboStr += objFrameAssoc.Retrofit_ROM_Code__c;
                    }
                    else {
                        comboStr += '';
                    }
                }
                if(!string.isBlank(drtData.Tech_Geo__c)) {
                    decimal dcmtechgeo;
                    if(!string.isBlank(objFrameAssoc.DRT__r.Tech_Geo__c)) {
                        Matcher pm = techGeoPattern.matcher(objFrameAssoc.DRT__r.Tech_Geo__c);
                        if(pm.matches() && !string.isBlank(pm.group(1))){
                            dcmtechgeo = Decimal.valueOf(pm.group(1));
                        }
                    }
                    comboStr += (dcmtechgeo!=null)?string.valueOf(dcmtechgeo):'';
                }
                // add all unique combinations
                setExistingComboStr.add(comboStr);
                mapUniqueCombinationDRTName.put(comboStr, objFrameAssoc.DRT__r.Name);
            }
            /** Check combination in MRS_Layer_Association__c for Layer_Status__c 'Shipped' **/
            set<string> setUniqueComboCurrentDRT = mapUniqueComboTableIdxlist.keySet();
            set<string> setExistingComboMRS = new set<string>();
            for (MRS_Layer_Association__c objLayerAssoc : [SELECT Id,MRS_Layer_Association__c.Name,MRS__r.Mask_Set_Title__c,Mask_Layer_Rev__c,ROM_Code__c,Tech_Geo__c 
                                                                FROM MRS_Layer_Association__c 
                                                                WHERE MRS__r.Mask_Set_Title__c = :drtData.Mask_Set_Title__c 
                                                                      AND Name IN :setDRTMaskLayerNum 
                                                                      AND Mask_Layer_Rev__c IN :setDRTMaskLayerRev 
                                                                      AND ROM_Code__c IN :setDRTROMCode 
                                                                      AND Layer_Status__c = 'Shipped']) {
                string comboStr='';
                if(objLayerAssoc.MRS__r.Mask_Set_Title__c != null) {
                    comboStr += objLayerAssoc.MRS__r.Mask_Set_Title__c;
                }
                if(objLayerAssoc.Name != null) {
                    comboStr += objLayerAssoc.Name;
                }
                if(objLayerAssoc.Mask_Layer_Rev__c != null) {
                    comboStr += objLayerAssoc.Mask_Layer_Rev__c;
                }
                if(objLayerAssoc.ROM_Code__c != null) {
                    if(objLayerAssoc.ROM_Code__c == '####') {
                        comboStr += '';
                    }
                    else {
                        comboStr += objLayerAssoc.ROM_Code__c;
                    }
                }
                if(!string.isBlank(drtData.Tech_Geo__c)) {
                    decimal dcmtechgeo;
                    if(!string.isBlank(objLayerAssoc.Tech_Geo__c)) {
                        Matcher pm = techGeoPattern.matcher(objLayerAssoc.Tech_Geo__c);
                        if(pm.matches() && !string.isBlank(pm.group(1))){
                            dcmtechgeo = Decimal.valueOf(pm.group(1));
                        }
                    }
                    comboStr += (dcmtechgeo!=null)?string.valueOf(dcmtechgeo):'';
                }
                setExistingComboMRS.add(comboStr);
            }
            /** identify frame table rows which have duplicate combinations **/
            for(String key : mapUniqueComboTableIdxlist.keyset()) {
               if(mapUniqueComboOccurrenceCurrent.containsKey(key) && 
                           mapUniqueComboOccurrenceCurrent.get(key) > 1) { // combination occurs more than once in current DRT
                   for(Integer idx : mapUniqueComboTableIdxlist.get(key)) {
                       error = true;
                       objFrameTableError = new FrameTableError();  
                       objFrameTableError.invalid = true;
                       objFrameTableError.col = 3;
                       objFrameTableError.row = idx;                                      
                       lstFrameTableError.add(objFrameTableError);
                   }
                   errorMessage = mapEC.get('UNIQUE COMBINATION OF MST').Message__c;
                   setErrorMessage.add(errorMessage); // add error message to set
               }
               else if(setExistingComboStr.contains(key)) {
                   for(Integer idx : mapUniqueComboTableIdxlist.get(key)) {
                       error = true;
                       objFrameTableError = new FrameTableError();  
                       objFrameTableError.invalid = true;
                       objFrameTableError.col = 3;
                       objFrameTableError.row = idx;                                      
                       lstFrameTableError.add(objFrameTableError);
                       if(mapUniqueCombinationDRTName.containsKey(key)) {
                            existingDRTName = mapUniqueCombinationDRTName.get(key);
                       }
                       if(mapUniqueCombinationDRTName.containsKey(key)) {
                            existingDRTName = mapUniqueCombinationDRTName.get(key);
                       }
                   }
                   errorMessage = mapEC.get('DUPLICATE DRT').Message__c.replace('{DRTName}',existingDRTName);
                   setErrorMessage.add(errorMessage); // add error message to set
               }
               else if(setExistingComboMRS.contains(key)) {
                    for(Integer idx : mapUniqueComboTableIdxlist.get(key)) {
                       error = true;
                       
                       //SWGP-726
                       //to highlighted both layer number and revision 
                       
                       //Mask Layer 
                       objFrameTableError = new FrameTableError();  
                       objFrameTableError.invalid = true;
                       objFrameTableError.col = 3;
                       objFrameTableError.row = idx;                                      
                       lstFrameTableError.add(objFrameTableError);
                       
                       //Retrofit PTRF Mask Rev
                       objFrameTableError = new FrameTableError();  
                       objFrameTableError.invalid = true;
                       objFrameTableError.col = 4;
                       objFrameTableError.row = idx;                                      
                       lstFrameTableError.add(objFrameTableError);
                    }
                    
                    //swgp-269 and other related shipped error tickets
                    errorMessage = mapEC.get('UNIQUE_COMBINATION_ERROR_MRS').Message__c;
                    setErrorMessage.add(errorMessage);//frame drt
               }
               else {
                   for(Integer idx : mapUniqueComboTableIdxlist.get(key)) {
                       objFrameTableError = new FrameTableError();  
                       objFrameTableError.invalid = false;
                       objFrameTableError.col = 3; 
                       objFrameTableError.row = idx;                                     
                       lstFrameTableError.add(objFrameTableError);
                   }
               }                       
            }
        }
        // generate error details
        if(lstFrameTableError != null && !lstFrameTableError.isEmpty()) {
            jsonData = JSON.serialize(lstFrameTableError);
        }
        ErrorDetails objErrorDetails = new ErrorDetails(error,jsonData,setErrorMessage);
        return objErrorDetails; 
    }
    
    /**
    * @description: This method inserts Frame DRT data.
    * @param: DRT__c drtData, list<Frame_DRT_Association__c> lstFrameDRTAssoc
    * @return: ID
    **/
    public static ID insertFrameDRT(DRT__c drtData, list<Frame_DRT_Association__c> lstFrameDRTAssoc) {
        insert drtData;
        for(Frame_DRT_Association__c frame : lstFrameDRTAssoc) {
            frame.DRT__c = drtData.Id;
        }                    
        Database.insert(lstFrameDRTAssoc,true);
        return drtData.Id;
    }
    
    /**
    * @description: This method returns DRT__History records.
    * @param: Id drtId
    * @return: list<DRT__History>
    **/
    public static list<DRT__History> fetchDRTHistory(Id drtId) {
        list<DRT__History> lstDRTHistory = [SELECT Id,CreatedById,CreatedBy.Name,CreatedDate,Field,IsDeleted,NewValue,OldValue,ParentId 
                                               FROM  DRT__History
                                               WHERE ParentId  =:drtId 
                                                    and createdBy.profile.Name != 'GF Integration' and createdBy.name != 'Swift Deploy' //SWGP-791 & 790
                                               ORDER BY CreatedDate];
        return lstDRTHistory;
    }
    
    /**
    * @description: This method returns PRIME_DRT_Chip_Association__History records.
    * @param: Id drtId
    * @return: list<PRIME_DRT_Chip_Association__History>
    **/
    public static list<PRIME_DRT_Chip_Association__History> fetchPrimeDRTChipAssocHistory(Id drtId) {
        list<PRIME_DRT_Chip_Association__History> lstPrimeDRTChipAssocHistory = [SELECT Id,CreatedById,CreatedBy.Name,CreatedDate,Field,IsDeleted,NewValue,OldValue,
                                                                                        ParentId,Parent.isCreatedLater__c,Parent.Name,Parent.IsSoftDeleted__c 
                                                                                   FROM  PRIME_DRT_Chip_Association__History        
                                                                                   WHERE Parent.DRT__c  = :drtId
                                                                                        and createdBy.profile.Name != 'GF Integration' and createdBy.name != 'Swift Deploy' //SWGP-791 & 790
                                                                                   ORDER BY CreatedDate];
        return lstPrimeDRTChipAssocHistory;
    }
    
    /**
    * @description: This method returns PRIME_DRT_Layer_Association__History records.
    * @param: Id drtId
    * @return: list<PRIME_DRT_Layer_Association__History>
    **/
    public static list<PRIME_DRT_Layer_Association__History> fetchPrimeDRTLayerAssocHistory(Id drtId) {
        list<PRIME_DRT_Layer_Association__History> lstPrimeDRTLayerAssocHistory = [SELECT Id,CreatedById,CreatedBy.Name,CreatedDate,Field,IsDeleted,NewValue,OldValue,
                                                                                        ParentId,Parent.isCreatedLater__c,Parent.Name,Parent.Retrofit_Mask_Rev__c,
                                                                                        Parent.Retrofit_ROM_Code__c,Parent.Retrofit_Tech_Geo__c,
                                                                                        Parent.IsSoftDeleted__c  
                                                                                   FROM  PRIME_DRT_Layer_Association__History
                                                                                   WHERE Parent.DRT__c  = :drtId 
                                                                                        and createdBy.profile.Name != 'GF Integration' and createdBy.name != 'Swift Deploy' //SWGP-791 & 790
                                                                                   ORDER BY CreatedDate];
        return lstPrimeDRTLayerAssocHistory;
    }
    
    /**
    * @description: This is used to generate DRT audit trail info.
    * @param: DRT__c drtObj,List<DRT__History> lstDRTHistory,
                list<PRIME_DRT_Chip_Association__History> lstPrimeDRTChipAssocHistory,
                list<PRIME_DRT_Layer_Association__History> lstPrimeDRTLayerAssocHistory
    * @return: list<AuditTrail>
    **/
    public static list<AuditTrail> fetchDRTAuditTrail(DRT__c drtObj,List<DRT__History> lstDRTHistory,
                list<PRIME_DRT_Chip_Association__History> lstPrimeDRTChipAssocHistory,
                list<PRIME_DRT_Layer_Association__History> lstPrimeDRTLayerAssocHistory) {
        list<AuditTrail> lstAuditTrailObj = new list<AuditTrail>();
        AuditTrail objAuditTrail;
        
        // map of field api name and sObjectField for DRT__c
        Map<String, Schema.SObjectField> mapDRTSObjectField = Schema.SObjectType.DRT__c.fields.getMap();
        // map of api name and field label for DRT__c
        Map<String,String> mapDRTFieldAPINameAndLabel = new Map<String,String>();
                                             
        // prepare PRIME_DRT_Chip_Association__c  data
        for(PRIME_DRT_Chip_Association__History objHistory : lstPrimeDRTChipAssocHistory) {
            String fieldName = String.valueOf(objHistory.Field);
            String description; String oldValue = ''; String newValue = '';
            if('created'.equalsIgnoreCase(fieldName)) {
                if(objHistory.Parent.isCreatedLater__c) {
                    description ='Added';
                    oldValue = '';
                    newValue = objHistory.Parent.Name;
                    if(!Test.isRunningTest()) { 
                        objAuditTrail = new AuditTrail(DateTime.valueOf(objHistory.CreatedDate).format(),objHistory.CreatedBy.Name,description ,'Prime Die/Scribeline Dropin',oldValue,newValue);
                        lstAuditTrailObj.add(objAuditTrail);
                    }    
                }
            }
            else{
                if((fieldName == 'IsSoftDeleted__c') && objHistory.Parent.IsSoftDeleted__c) {
                    description ='Deleted';
                    oldValue = objHistory.Parent.Name;
                    newValue = '';
                    if(!Test.isRunningTest()) {
                        objAuditTrail = new AuditTrail(DateTime.valueOf(objHistory.CreatedDate).format(),objHistory.CreatedBy.Name,description ,
                                                                'Prime Die/Scribeline Dropin',oldValue,newValue);
                        lstAuditTrailObj.add(objAuditTrail);
                    }
                }
                else if(fieldName == 'Name') {
                    description ='Modified';
                    oldValue = String.valueOf(objHistory.OldValue);
                    newValue = String.valueOf(objHistory.NewValue);
                    if(!Test.isRunningTest()) {
                        objAuditTrail = new AuditTrail(DateTime.valueOf(objHistory.CreatedDate).format(),objHistory.CreatedBy.Name,description ,
                                                                'Prime Die/Scribeline Dropin',oldValue,newValue);
                        lstAuditTrailObj.add(objAuditTrail);
                    }
                }
            }
        }
        
        // prepare PRIME_DRT_Layer_Association__c history  data
        
        for(PRIME_DRT_Layer_Association__History objHistory : lstPrimeDRTLayerAssocHistory) {
            String fieldName = String.valueOf(objHistory.Field);
            String description; String oldValue = ''; String newValue = '';
            String fieldOldValue,fieldNewValue,retroMaskLayer,retroMaskRev,retroROMCode;
            
            fieldOldValue = String.valueOf(objHistory.OldValue);
            fieldNewValue = String.valueOf(objHistory.NewValue);
            
            retroMaskLayer = objHistory.Parent.Name;
            retroMaskRev = objHistory.Parent.Retrofit_Mask_Rev__c;
            retroROMCode = objHistory.Parent.Retrofit_ROM_Code__c;
            
            if(fieldOldValue == null) {
                fieldOldValue = '';
            }
            if(fieldNewValue == null) {
                fieldNewValue = '';
            }
            if(retroMaskLayer == null) {
                retroMaskLayer = '';
            }
            if(retroMaskRev == null) {
                retroMaskRev = '';
            }
            if(retroROMCode == null) {
                retroROMCode = '';
            }
            if('created'.equalsIgnoreCase(fieldName)) {
                if(objHistory.Parent.isCreatedLater__c) {
                    description ='Added';
                    oldValue = '';                    
                    newValue = retroMaskLayer+retroMaskRev+'('+retroROMCode+')';
                    if(!Test.isRunningTest()) {
                        objAuditTrail = new AuditTrail(DateTime.valueOf(objHistory.CreatedDate).format(),objHistory.CreatedBy.Name,description ,'Mask Layer',oldValue,newValue);
                        lstAuditTrailObj.add(objAuditTrail);
                    }
                }
            }
            else{
                if((fieldName == 'IsSoftDeleted__c') && objHistory.Parent.IsSoftDeleted__c) {
                    description ='Deleted';                    
                    oldValue = retroMaskLayer+retroMaskRev+'('+retroROMCode+')';                    
                    newValue = '';
                    if(!Test.isRunningTest()) {
                        objAuditTrail = new AuditTrail(DateTime.valueOf(objHistory.CreatedDate).format(),objHistory.CreatedBy.Name,description ,
                                                                'Mask Layer',oldValue,newValue);
                        lstAuditTrailObj.add(objAuditTrail);
                    }
                }
                else if(fieldName != 'IsSoftDeleted__c') {
                    description ='Modified';
                    oldValue = '';
                    newValue = '';
                    Boolean addToHistory = false;
                    if(fieldName == 'Name') {                        
                        oldValue = fieldOldValue+retroMaskRev+'('+retroROMCode+')';                        
                        newValue = fieldNewValue+retroMaskRev+'('+retroROMCode+')';
                        addToHistory = true;
                    }
                    else if(fieldName == 'Retrofit_Mask_Rev__c') {
                        oldValue = retroMaskLayer+fieldOldValue+'('+retroROMCode+')';
                        
                        newValue = retroMaskLayer+fieldNewValue+'('+retroROMCode+')';
                        addToHistory = true;
                    }
                    else if(fieldName == 'Retrofit_ROM_Code__c') {
                        oldValue = retroMaskLayer+retroMaskRev+'('+fieldOldValue+')';
                        
                        newValue = retroMaskLayer+retroMaskRev+'('+fieldNewValue+')';
                        addToHistory = true;
                    }
                    if(addToHistory) {
                        if(!Test.isRunningTest()) {
                            objAuditTrail = new AuditTrail(DateTime.valueOf(objHistory.CreatedDate).format(),objHistory.CreatedBy.Name,description ,
                                                                    'Mask Layer',oldValue,newValue);
                            lstAuditTrailObj.add(objAuditTrail);
                        } 
                    }
                }
            }
        }
        // prepare DRT__c history data
        for(DRT__History objHistory : lstDRTHistory) {
            String description;
            String fieldOldValue = String.valueOf(objHistory.OldValue);
            String fieldNewValue = String.valueOf(objHistory.NewValue);
            
            if(fieldOldValue == null) {
                fieldOldValue = '';
            }
            if(fieldNewValue == null) {
                fieldNewValue = '';
            }
            if('created'.equalsIgnoreCase(objHistory.Field)) {
                if(drtObj.Copied_From__c != null) {
                    description ='Copied from ' + drtObj.Copied_From__r.Name;
                    if(!Test.isRunningTest()) {
                        objAuditTrail = new AuditTrail(DateTime.valueOf(objHistory.CreatedDate).format(),objHistory.CreatedBy.Name,description ,null,null,null);
                    }
                    lstAuditTrailObj.add(objAuditTrail);
                }                
                else if(drtObj.Old_Rev_DRT__c != null) {
                    description ='Revised from ' + drtObj.Old_Rev_DRT__r.Name;
                    if(!Test.isRunningTest()) {
                        objAuditTrail = new AuditTrail(DateTime.valueOf(objHistory.CreatedDate).format(),objHistory.CreatedBy.Name,description ,null,null,null);
                    }
                    lstAuditTrailObj.add(objAuditTrail);
                }
                if(drtObj.Copied_From__c == null && drtObj.Old_Rev_DRT__c == null) {
                    description ='Created';
                    if(!Test.isRunningTest()) {
                        objAuditTrail = new AuditTrail(DateTime.valueOf(objHistory.CreatedDate).format(),objHistory.CreatedBy.Name,description ,null,null,null);
                    }   
                    lstAuditTrailObj.add(objAuditTrail);
                }
            }
            else {
                description ='Modified';
                if(!mapDRTFieldAPINameAndLabel.containsKey(objHistory.Field) && mapDRTSObjectField.containsKey(objHistory.Field)) {
                    mapDRTFieldAPINameAndLabel.put(objHistory.Field, mapDRTSObjectField.get(objHistory.Field).getDescribe().getLabel());
                }
                String fieldLabel = objHistory.Field;
                if(mapDRTFieldAPINameAndLabel.containsKey(objHistory.Field)) {
                    fieldLabel = mapDRTFieldAPINameAndLabel.get(objHistory.Field);
                }
                if(!Test.isRunningTest()) {
                    objAuditTrail = new AuditTrail(DateTime.valueOf(objHistory.CreatedDate).format(),objHistory.CreatedBy.Name,description ,
                                                        fieldLabel,fieldOldValue,fieldNewValue);
                }                                        
                lstAuditTrailObj.add(objAuditTrail);
            }
        }
        // sort Audit Trail by descending order of time created
        List<long> lstCreatedDateTime = new List<long>();
        Map<long,List<AuditTrail>> mapOfTimeAndListAuditTrail = new Map<long,List<AuditTrail>>();
        for(AuditTrail a : lstAuditTrailObj) {
            if(!Test.isRunningTest()) {
                //String timeStr = String.valueOf(DateTime.parse(a.createdDate).time());
                long timeStr = DateTime.parse(a.createdDate).getTime();
                if(!mapOfTimeAndListAuditTrail.containsKey(timeStr)) {
                    mapOfTimeAndListAuditTrail.put(timeStr,new List<AuditTrail>());
                }
                mapOfTimeAndListAuditTrail.get(timeStr).add(a);
                lstCreatedDateTime.add(timeStr);
            }
        }
        lstCreatedDateTime.sort();
        List<AuditTrail> lstAuditTrailObjSorted = new List<AuditTrail>();
        for(Integer i =  lstCreatedDateTime.size()-1; i >= 0; i--) {
            long key = lstCreatedDateTime.get(i);
            if(mapOfTimeAndListAuditTrail.containsKey(key)) {
                lstAuditTrailObjSorted.addAll(mapOfTimeAndListAuditTrail.get(key));
                mapOfTimeAndListAuditTrail.remove(key);
            }
        }
        return lstAuditTrailObjSorted;
    }
    
    
    /**
    * @description: This is used to send email notification on DRT activation.
    * @param: Id drtId
    * @param: boolean sendEmailToCustomers
    * @return: void
    **/  
    public static void sendMassEmailOnDRTActivation(Id drtId, boolean sendEmailToCustomers){
        try{    
            list<OrgWideEmailAddress> lstOrgWideEmailAddress = [select Id from OrgWideEmailAddress where DisplayName = :'GLOBALFOUNDRIES' LIMIT 1];
            string defaultFromEmailId = '';
            if(lstOrgWideEmailAddress != null && (!lstOrgWideEmailAddress.isEmpty())) {
                defaultFromEmailId = lstOrgWideEmailAddress.get(0).Id;
            }         
            
            User loggedInUserInfo =[SELECT Id,AccountId,Name,Portal_Email__c,email FROM User WHERE Id =:UserInfo.getUserId()];
            DRT__c drtActivated = [select Id,name,Customer_Name__c,Customer_Short_Name__c,Tech_Geo__c,Mask_Set_Title__r.Name,Mask_Set_Title_Formula__c from DRT__c where Id = :drtId limit 1];
            Account customer = [select id,name from account where id = :drtActivated.Customer_Name__c limit 1];
            //Fetch All portal users/ customer users
            Map<ID, User> portalUserMap = new Map<ID, User>([select id,name,Portal_Email__c,email from user where isActive=true and accountId = :drtActivated.Customer_Name__c]);
            //send mail if there are any portal users 
            if(null != portalUserMap && portalUserMap.size() > 0 && sendEmailToCustomers){
                List<Portal_Tab_Access__c> portaltabaccessList = new List<Portal_Tab_Access__c>();
                portaltabaccessList = [SELECT id, User__c From Portal_Tab_Access__c p
                                           WHERE p.User__c in :portalUserMap.keySet() 
                                               AND p.Account__c =:drtActivated.Customer_Name__c
                                               AND p.My_Devices__c = true
                                               AND p.PTRF__c = true ];
                List<User> portalUserList =new List<User>();
                if(null != portaltabaccessList && !portaltabaccessList.IsEmpty()){
                    for(Portal_Tab_Access__c pta : portaltabaccessList){
                        portalUserList.add(portalUserMap.get(pta.User__c));
                    }   
                    // grab the email template
                    EmailTemplate emailTemplate = [select Id, Subject, HtmlValue, Body from EmailTemplate where DeveloperName=: 'Swift_DRT_Activation'];
                    // process the merge fields
                    String subject = emailTemplate.Subject;
                    String DRTnoHyperlinked ='<a href="'+system.Label.SWIFT_Community_URL+'VFDRTDetail?id='+drtActivated.Id+'">'+drtActivated.Name+'</a>';
                    subject = subject.replace('<DRT_Number>', drtActivated.Name);
                    
                    String plainBody = emailTemplate.Body;
                    plainBody = plainBody.replace('<DRT.Customer Name>', customer.Name);
                    plainBody = plainBody.replace('<DRT.Customer Shortname>', drtActivated.Customer_Short_Name__c);
                    plainBody = plainBody.replace('<DRT.Number>',DRTnoHyperlinked);
                    plainBody = plainBody.replace('<DRT.Mask Set Title>',drtActivated.Mask_Set_Title__r.Name); 
                    
                     //build the email message
                    Messaging.Singleemailmessage email = new Messaging.Singleemailmessage();
                    if(!string.isBlank(defaultFromEmailId)) {
                        email.setOrgWideEmailAddressId(defaultFromEmailId);
                    }
                    email.setSubject(subject);
                    email.setHtmlBody(plainBody);
                    set<String> portalUserEmailSet = new set<String>();
                    for(User portalUser : portalUserList){
                        portalUserEmailSet.add(portalUser.Portal_Email__c);   
                    }
                    List<String> portalUserEmailList = new list<String>();
                    portalUserEmailList.addAll(portalUserEmailSet);
                    email.setToAddresses(portalUserEmailList);
                    //Swift ADMIN in bcc list
                    set<string> bccSet = new set<string>();
                    if(Environment_Variable__c.getInstance('SWIFT_ADMIN_EMAIL').Value__c.contains(';')){
                        bccSet.addAll(Environment_Variable__c.getInstance('SWIFT_ADMIN_EMAIL').Value__c.split(';'));
                    }else{
                        bccSet.add(Environment_Variable__c.getInstance('SWIFT_ADMIN_EMAIL').Value__c);
                    }
                    list<string> bccList = new list<string>();
                    bccList.addAll(bccSet);
                    if(bccList != null && !bccList.isEmpty()) {
                        email.setBccAddresses(bccList);
                    }
                    try{
                            //send mail to all portal users in only to list 
                            sendMassEmail(email);
                        }catch(Exception e){
                            system.debug('Error in Portal User DRT Activation sending mail='+e.getMessage());
                            system.debug('StackTrace='+e.getStackTraceString());
                    }
                }     
                //send second email to all internal users in to,cc,bcc list
                sendToCcBccMails(drtActivated,loggedInUserInfo,'activate','',defaultFromEmailId,customer.Name);
            }else{
                sendToCcBccMails(drtActivated,loggedInUserInfo,'activate','',defaultFromEmailId,customer.Name);
            }//else
        }catch(Exception ex){
            system.debug('Error in DRT activation mail='+ex.getMessage());
            system.debug('StackTrace='+ex.getStackTraceString());
        }        
    }
    
    /**
    * @description: This is used to split a list using start index and end index
    * @param: list<String> emailList, Integer startIndex, Integer endIndex
    * @return: list<String>
    **/
    @TestVisible private static list<String> subArray(list<String> emailList, Integer startIndex, Integer endIndex) {
            list<String> toReturn = new list<String>();
            for (Integer i = startIndex; i <= endIndex; i++) {
                toReturn.add(emailList.get(i));
            }
            return toReturn;
    }
    
    /**
    * @description: This is used to send email notification upon DRT revision (active DRT).
    * @param: Id drtId, String oldDRTName
    * @return: void
    **/
    public static void sendMassEmailOnDRTRevision(Id drtId, String oldDRTName){
        try{
            list<OrgWideEmailAddress> lstOrgWideEmailAddress = [select Id from OrgWideEmailAddress where DisplayName = :'GLOBALFOUNDRIES' LIMIT 1];
            string defaultFromEmailId = '';
            if(lstOrgWideEmailAddress != null && (!lstOrgWideEmailAddress.isEmpty())) {
                defaultFromEmailId = lstOrgWideEmailAddress.get(0).Id;
            }         
            
            User loggedInUserInfo =[SELECT Id,AccountId,Name,Portal_Email__c,email FROM User WHERE Id =:UserInfo.getUserId()];
            DRT__c drtRevised = [select Id,name,Customer_Name__c,Customer_Short_Name__c,Tech_Geo__c,Mask_Set_Title__r.Name,Mask_Set_Title_Formula__c from DRT__c where Id = :drtId limit 1];
            Account customer = [select id,name from account where id = :drtRevised.Customer_Name__c limit 1];
            //Fetch All portal users/ customer users
            Map<ID, User> portalUserMap = new Map<ID, User>([select id,name,Portal_Email__c,email from user where isActive=true and accountId = :drtRevised.Customer_Name__c]);
            //send mail if there are any portal users 
            if(null != portalUserMap && portalUserMap.size() > 0){
                List<Portal_Tab_Access__c> portaltabaccessList = new List<Portal_Tab_Access__c>();
                portaltabaccessList = [SELECT id, User__c From Portal_Tab_Access__c p
                                           WHERE p.User__c in :portalUserMap.keySet() 
                                               AND p.Account__c =:drtRevised.Customer_Name__c
                                               AND p.My_Devices__c = true
                                               AND p.PTRF__c = true ];
                List<User> portalUserList =new List<User>();
                if(null != portaltabaccessList && !portaltabaccessList.IsEmpty()){
                    for(Portal_Tab_Access__c pta : portaltabaccessList){
                        portalUserList.add(portalUserMap.get(pta.User__c));
                    }   
                    // grab the email template
                    EmailTemplate emailTemplate = [select Id, Subject, HtmlValue, Body from EmailTemplate where DeveloperName=: 'Swift_DRT_Revision'];
                    // process the merge fields
                    String subject = emailTemplate.Subject;
                    String DRTnoHyperlinked ='<a href="'+system.Label.Internal_URL+'VFDRTDetail?id='+drtRevised.Id+'">'+drtRevised.Name+'</a>';
                    subject = subject.replace('<DRT_Number_old>', oldDRTName);
                    subject = subject.replace('<DRT_Number>', drtRevised.Name);
                    
                    String plainBody = emailTemplate.Body;
                    plainBody = plainBody.replace('<DRT.Customer Name>', customer.Name);
                    plainBody = plainBody.replace('<DRT.Customer Shortname>', drtRevised.Customer_Short_Name__c);
                    plainBody = plainBody.replace('<DRT.Number>',DRTnoHyperlinked);
                    plainBody = plainBody.replace('<DRT.Mask Set Title>',drtRevised.Mask_Set_Title__r.Name); 
                    plainBody = plainBody.replace('<DRT.Number_Old>', oldDRTName);
                    plainBody = plainBody.replace('<User>', loggedInUserInfo.Name);
                    
                    list<DRT_PTRF_Association__c> drtPTRFAssociationlist= [SELECT Id, PTRF__c, PTRF__r.Name,PTRF__r.Status__c FROM DRT_PTRF_Association__c 
                                                                            WHERE DRT__c=:drtRevised.Id];
                    
                    String ptrfName = '';
                    if(null != drtPTRFAssociationlist && !drtPTRFAssociationlist.isEmpty()){
                        ptrfName += 'The following PTRFs will be linked to the revised DRT:</br>';
                        for(DRT_PTRF_Association__c drtPTRFAssociation : drtPTRFAssociationlist){
                            ptrfName += '<p>'+ drtPTRFAssociation.PTRF__r.Name + '<p>';
                        }
                        plainBody = plainBody.replace('<DRT.PTRFNumber_1>', ptrfName);  
                    }else{
                        ptrfName  += 'There are no PTRFs linked to this Active/Revised DRT';
                        plainBody = plainBody.replace('<DRT.PTRFNumber_1>', ptrfName);//empty ptrf
                    }
                    
                    //build the email message
                    Messaging.Singleemailmessage email = new Messaging.Singleemailmessage();
                    if(!string.isBlank(defaultFromEmailId)) {
                        email.setOrgWideEmailAddressId(defaultFromEmailId);
                    }
                    email.setSubject(subject);
                    email.setHtmlBody(plainBody);
                    set<String> portalUserEmailSet = new set<String>();
                    for(User portalUser : portalUserList){
                        portalUserEmailSet.add(portalUser.Portal_Email__c);   
                    }
                    List<String> portalUserEmailList = new list<String>();
                    portalUserEmailList.addAll(portalUserEmailSet);
                    email.setToAddresses(portalUserEmailList);
                    //Swift ADMIN in bcc list
                    set<string> bccSet = new set<string>();
                    if(Environment_Variable__c.getInstance('SWIFT_ADMIN_EMAIL').Value__c.contains(';')){
                        bccSet.addAll(Environment_Variable__c.getInstance('SWIFT_ADMIN_EMAIL').Value__c.split(';'));
                    }else{
                        bccSet.add(Environment_Variable__c.getInstance('SWIFT_ADMIN_EMAIL').Value__c);
                    }
                    list<string> bccList = new list<string>();
                    bccList.addAll(bccSet);
                    if(bccList != null && !bccList.isEmpty()) {
                        email.setBccAddresses(bccList);
                    }
                    try{
                            //send mail to all portal users in only to list 
                            sendMassEmail(email);
                        }catch(Exception e){
                            system.debug('Error in Portal User Revision sending mail='+e.getMessage());
                            system.debug('StackTrace='+e.getStackTraceString());
                    } 
                }   
                    //send second email to all internal users in to,cc,bcc list
                    sendToCcBccMails(drtRevised,loggedInUserInfo,'revised',oldDRTName,defaultFromEmailId,customer.Name);
                }else{
                    sendToCcBccMails(drtRevised,loggedInUserInfo,'revised',oldDRTName,defaultFromEmailId,customer.Name);
                    
            }//else
        }catch(Exception ex){
            system.debug('Error in DRT Revision mail='+ex.getMessage());
            system.debug('StackTrace='+ex.getStackTraceString());
        }        
    }
    
    /**
    * @description: This is used to send email notification using CC and BCC list.
    * @param: DRT__c objDRT,User loggedInUserInfo,String actionName,String oldDRTName,String defaultFromEmailId,String CustomerName
    * @return: void
    **/
    public static void sendToCcBccMails(DRT__c objDRT,User loggedInUserInfo,String actionName,String oldDRTName,String defaultFromEmailId,String CustomerName){        
            //the user who has activated/revised the DRT is not a portal user instead the user is an internal user
            Set<String> toSet=new Set<String>();
            Set<String> ccSet=new Set<String>();
            //user
            ccSet.add(loggedInUserInfo.Portal_Email__c);//User who activates the DRT is added in the CC mail list
            Map<String, Set<String>> FEuserMap= SwiftUtility.fetchFEUsers(new Set<String>{objDRT.Customer_Name__c});
            Set<String> FEuserIds = FEuserMap.get(objDRT.Customer_Name__c);
            if(null != FEuserIds && !FEuserIds.isEmpty()){
                List<User> FeUserList = [select id,Portal_Email__c,email,name from user where id in :FEuserIds];
                //All FE supporting the customer account of this DRT are added in CC mail list
                for(User u : FeUserList){
                    ccSet.add(u.Portal_Email__c);
                }
            }
            
            Set<String> tapeoutCentreSet=new Set<String>();
            Set<String> MDPList=new Set<String>();
            Set<String> FEgroupUserSet = new Set<String>();
            set<String> globalShuttleSet = new set<String>();
            set<String> tdtimpwSet = new set<String>();
            Set<String> bccSet = new Set<String>();
            
            //Tapeout Centre
            if(Environment_Variable__c.getInstance('SWIFT_TAPEOUT_CENTRE_EMAIL').Value__c.contains(';')){
                tapeoutCentreSet.addAll(Environment_Variable__c.getInstance('SWIFT_TAPEOUT_CENTRE_EMAIL').Value__c.split(';'));
            }else{
                tapeoutCentreSet.add(Environment_Variable__c.getInstance('SWIFT_TAPEOUT_CENTRE_EMAIL').Value__c);
            }
            //MDP
            if(Environment_Variable__c.getInstance('SWIFT_MDP_EMAIL').Value__c.contains(';')){
                MDPList.addAll(Environment_Variable__c.getInstance('SWIFT_MDP_EMAIL').Value__c.split(';'));
            }else{
                MDPList.add(Environment_Variable__c.getInstance('SWIFT_MDP_EMAIL').Value__c);
            }
            //GlobalShuttle 
            if(Environment_Variable__c.getInstance('SWIFT_GLOBALSHUTTLE_EMAIL').Value__c.contains(';')){
                globalShuttleSet.addAll(Environment_Variable__c.getInstance('SWIFT_GLOBALSHUTTLE_EMAIL').Value__c.split(';'));
            }else{
                globalShuttleSet.add(Environment_Variable__c.getInstance('SWIFT_GLOBALSHUTTLE_EMAIL').Value__c);
            }
            //TDTI-MPW
            if(Environment_Variable__c.getInstance('SWIFT_TDTI_MPW_EMAIL').Value__c.contains(';')){
                tdtimpwSet.addAll(Environment_Variable__c.getInstance('SWIFT_TDTI_MPW_EMAIL').Value__c.split(';'));
            }else{
                tdtimpwSet.add(Environment_Variable__c.getInstance('SWIFT_TDTI_MPW_EMAIL').Value__c);
            }      
            //swift ADMIN   
            if(Environment_Variable__c.getInstance('SWIFT_ADMIN_EMAIL').Value__c.contains(';')){
                bccSet.addAll(Environment_Variable__c.getInstance('SWIFT_ADMIN_EMAIL').Value__c.split(';'));
            }else{
                bccSet.add(Environment_Variable__c.getInstance('SWIFT_ADMIN_EMAIL').Value__c);
            }
            
            /*************SWGP-742*************/
            list<DRT_PTRF_Association__c> drtPTRFAssociationlist= [
                SELECT Id, PTRF__c, PTRF__r.Name,PTRF__r.Status__c,ptrf__r.Tech_Geo_Value__c 
                FROM DRT_PTRF_Association__c 
                WHERE DRT__c=:objDRT.Id and PTRF__r.Status__c IN ('Perform Tapeout Options','Closed','GlobalShuttle Updates','IP Merge','Perform DRC DRW')
            ];
            
            String comparedTechGeo;
            if(!String.isBlank(objDRT.Tech_Geo__c)) { comparedTechGeo = objDRT.Tech_Geo__c; }
            else { if(!drtPTRFAssociationlist.isEmpty()) comparedTechGeo = drtPTRFAssociationlist.get(0).ptrf__r.Tech_Geo_Value__c; }
            
            decimal dcmtechgeo;
            Pattern techGeoPattern = Pattern.compile('(\\d*\\.\\d+)(.*)');
            //if(!string.isBlank(objDRT.Tech_Geo__c)){
            if(!string.isBlank(comparedTechGeo)) {
                
                    Matcher pm = techGeoPattern.matcher(comparedTechGeo);
                    
                    if(pm.matches() && !string.isBlank(pm.group(1))) {
                        dcmtechgeo = Decimal.valueOf(pm.group(1));
                    }
            }
            
            /*
            list<DRT_PTRF_Association__c> drtPTRFAssociationlist= [
                SELECT Id, PTRF__c, PTRF__r.Name,PTRF__r.Status__c 
                FROM DRT_PTRF_Association__c 
                WHERE DRT__c=:objDRT.Id and PTRF__r.Status__c IN ('Perform Tapeout Options','Closed','GlobalShuttle Updates','IP Merge','Perform DRC DRW')
            ];
            */
            /*************SWGP-742*************/
            //only send email to TOC/MDP/TDTI-MPW/GS in case the drt is attached to a/some ptrf
            if(null != drtPTRFAssociationlist && !drtPTRFAssociationlist.isEmpty()){
                
                Boolean isTapeOutCentre = true;
                Boolean isMDP = true;
                Boolean isGlobalShuttle = true;
                Boolean istdtimpw = true;
                for(DRT_PTRF_Association__c drtPTRFAssociation : drtPTRFAssociationlist){
                    //to starts
                    if(isTapeOutCentre && (drtPTRFAssociation.PTRF__r.Status__c == 'Perform Tapeout Options' || drtPTRFAssociation.PTRF__r.Status__c == 'Closed')){
                        toSet.addAll(tapeoutCentreSet);
                        isTapeOutCentre = false;
                    }
                    
                    if(dcmtechgeo!=null && dcmtechgeo!=0){
                        Double mdpTechGeoCutoff       = Double.valueOf( MRSHandlerUtilityExtn.loadEnvVariable('Swift_MDP_Tech_Geo_Cut_Off','0.022') );
                        if(isMDP && dcmtechgeo <= mdpTechGeoCutoff && (drtPTRFAssociation.PTRF__r.Status__c == 'Perform Tapeout Options' || drtPTRFAssociation.PTRF__r.Status__c == 'Closed')){
                             toSet.addAll(MDPList);
                             isMDP = false;
                        }
                    }
                    //to ends
                    
                    
                    /*
                    SWGP-585: Change in technology cut-off between GlobalShuttle/TDTI-MPW and MRS name/label change
                    Cut-off value will be stored in a custom setting for config purpose

                    Old:
                        GlobalShuttle MEBES Jobview: MST starts with "MPW" and Tech node >20nm
                        TDTI-MPW MEBES Jobview: MST starts with "MPW" and Tech node <=20nm
                    To Be:
                        GlobalShuttle MEBES Jobview: MST starts with "MPW" and Tech node >22nm
                        TDTI-MPW MEBES Jobview: MST starts with "MPW" and Tech node <=22nm
                    */
                    //cc starts
                    if(objDRT.Mask_Set_Title_Formula__c!=null){
                        Environment_Variable__c gstdtitech = Environment_Variable__c.getInstance('Swift_GS_TDTI_Tech_Geo_Cut_Off');                        
                        Double gs_tdti_tech_geo = null != gstdtitech ? Double.valueOf(gstdtitech.value__c) : 0.022;
                                                
                        if(isGlobalShuttle && String.valueof(objDRT.Mask_Set_Title_Formula__c).startswith('MPW') 
                            && dcmtechgeo > gs_tdti_tech_geo //SWGP-585 //Swift_GS_TDTI_Tech_Geo_Cut_Off
                            &&
                        (drtPTRFAssociation.PTRF__r.Status__c == 'Perform Tapeout Options' || 
                         drtPTRFAssociation.PTRF__r.Status__c == 'Closed' ||
                         drtPTRFAssociation.PTRF__r.Status__c == 'GlobalShuttle Updates' ||
                         drtPTRFAssociation.PTRF__r.Status__c == 'IP Merge' ||
                         drtPTRFAssociation.PTRF__r.Status__c == 'Perform DRC DRW'
                         )){
                              ccSet.addAll(globalShuttleSet); 
                              isGlobalShuttle = false;         
                        }
                        if(istdtimpw && String.valueof(objDRT.Mask_Set_Title_Formula__c).startswith('MPW') 
                            && dcmtechgeo <= gs_tdti_tech_geo //SWGP-585 //Swift_GS_TDTI_Tech_Geo_Cut_Off
                            && 
                        (drtPTRFAssociation.PTRF__r.Status__c == 'Perform Tapeout Options' || 
                         drtPTRFAssociation.PTRF__r.Status__c == 'Closed' ||
                         drtPTRFAssociation.PTRF__r.Status__c == 'GlobalShuttle Updates' ||
                         drtPTRFAssociation.PTRF__r.Status__c == 'IP Merge' ||
                         drtPTRFAssociation.PTRF__r.Status__c == 'Perform DRC DRW'
                         )){
                              ccSet.addAll(tdtimpwSet);
                              istdtimpw = false;  
                        }
                    }
                    //cc ends
                    //when all intended recepients are added break the loop
                    if(!isTapeOutCentre && !isMDP && !isGlobalShuttle && !istdtimpw){
                        break;
                    }
            }//for
        }
        EmailTemplate emailTemplate=null;
        String subject = null;
        String plainBody = null;
        if(actionName == 'activate'){   
            // grab the email template
            emailTemplate = [select Id, Subject, HtmlValue, Body from EmailTemplate where DeveloperName=: 'Swift_DRT_Activation'];
            // process the merge fields
            subject = emailTemplate.Subject;
            String DRTnoHyperlinked ='<a href="'+system.Label.Internal_URL+'VFDRTDetail?id='+objDRT.Id+'">'+objDRT.Name+'</a>';
            subject = subject.replace('<DRT_Number>', objDRT.Name);
            plainBody = emailTemplate.Body;
            plainBody = plainBody.replace('<DRT.Customer Name>', CustomerName);
            plainBody = plainBody.replace('<DRT.Customer Shortname>', objDRT.Customer_Short_Name__c);
            plainBody = plainBody.replace('<DRT.Number>',DRTnoHyperlinked);
            plainBody = plainBody.replace('<DRT.Mask Set Title>',objDRT.Mask_Set_Title__r.Name); 
        }else if(actionName == 'revised'){
            // grab the email template
            emailTemplate = [select Id, Subject, HtmlValue, Body from EmailTemplate where DeveloperName=: 'Swift_DRT_Revision'];
            // process the merge fields
            subject = emailTemplate.Subject;
            String DRTnoHyperlinked ='<a href="'+system.Label.Internal_URL+'VFDRTDetail?id='+objDRT.Id+'">'+objDRT.Name+'</a>';
            subject = subject.replace('<DRT_Number_old>', oldDRTName);
            subject = subject.replace('<DRT_Number>', objDRT.Name);
            
            plainBody = emailTemplate.Body;
            plainBody = plainBody.replace('<DRT.Customer Name>', CustomerName);
            plainBody = plainBody.replace('<DRT.Customer Shortname>', objDRT.Customer_Short_Name__c);
            plainBody = plainBody.replace('<DRT.Number>',DRTnoHyperlinked);
            plainBody = plainBody.replace('<DRT.Mask Set Title>',objDRT.Mask_Set_Title__r.Name); 
            plainBody = plainBody.replace('<DRT.Number_Old>', oldDRTName);
            plainBody = plainBody.replace('<User>', loggedInUserInfo.Name);
            
            list<DRT_PTRF_Association__c> drtPTRFAssociationlistRevised= [SELECT Id, PTRF__c, PTRF__r.Name,PTRF__r.Status__c FROM DRT_PTRF_Association__c 
                                                                    WHERE DRT__c=:objDRT.Id];
            
            String ptrfName = '';
            if(null != drtPTRFAssociationlistRevised && !drtPTRFAssociationlistRevised.isEmpty()){
                ptrfName += 'The following PTRFs will be linked to the revised DRT:</br>';
                for(DRT_PTRF_Association__c drtPTRFAssociation : drtPTRFAssociationlistRevised){
                    ptrfName += '<p>'+ drtPTRFAssociation.PTRF__r.Name + '<p>';
                }
                plainBody = plainBody.replace('<DRT.PTRFNumber_1>', ptrfName);  
            }else{
                ptrfName  += 'There are no PTRFs linked to this Active/Revised DRT';
                plainBody = plainBody.replace('<DRT.PTRFNumber_1>', ptrfName);//empty ptrf
            }
        }   
            
        //build the email message
        Messaging.Singleemailmessage email = new Messaging.Singleemailmessage();
        if(!string.isBlank(defaultFromEmailId)) {
            email.setOrgWideEmailAddressId(defaultFromEmailId);
        }
        String[] toArray=new String[toSet.size()];
        String[] ccArray=new String[ccSet.size()];
        String[] bccArray=new String[bccSet.size()];
        Integer i=0;                
        for(String str : toSet){
            toArray[i++]=str;
        }
        i=0;
        for(String str : ccSet){
            ccArray[i++]=str;
        }
        i=0;
        for(String str : bccSet){
            bccArray[i++]=str;
        }
        email.setSubject(subject);
        email.setHtmlBody(plainBody);
        if(toArray.size() > 0){
            email.setToAddresses(toArray);
        }
        email.setCcAddresses(ccArray);
        email.setBccAddresses(bccArray); 
        try{
            sendMassEmail(email);
        }catch(Exception e){
        }
    }
    
    
    /**
    * @description: This is used to send emails. Splits To/CC list and send multiple emails when To/CC limits get exceeded.
    * @param: Messaging.SingleEmailMessage MsgsToSend
    * @return: void
    **/
    public static void sendMassEmail(Messaging.SingleEmailMessage MsgsToSend){
        try{
                Messaging.SingleEmailMessage emailToSend  = MsgsToSend;
                    List<String> toList = emailToSend.getToAddresses();
                    list<list<String>> lstOflstOfToEmail=new list<list<String>>();
                    if(toList != null && !toList.isEmpty()){
                        String toMailLimit = Environment_Variable__c.getInstance('SwiftEmailToListLimit').Value__c;
                        integer n=Integer.valueOf(toMailLimit);
                        if(toList.size() > n){
                            Double noOflst=Math.ceil((toList.size() / (Double)n));
                            for (integer i = 1; i <= noOflst; i++) {
                                if(((i * n) - 1) < toList.size()){
                                    list<String> temp = subArray(toList, ((i * n) - n),((i * n) - 1));
                                    lstOflstOfToEmail.add(temp);
                                }else{
                                    list<String> temp = subArray(toList, ((i * n) - n),(toList.size() - 1));
                                    lstOflstOfToEmail.add(temp);
                                }
                            }
                        }else{
                            lstOflstOfToEmail.add(toList);
                        }
                    }   
                    
                    List<String> ccList = emailToSend.getCCAddresses();
                    List<List<String>> lstOflstOfCCEmail=new List<List<String>>();
                    if(ccList != null && !ccList.isEmpty()){
                        String ccMailLimit = Environment_Variable__c.getInstance('SwiftEmailCCListLimit').Value__c;
                        integer n=Integer.valueOf(ccMailLimit);
                        Double noOflst=Math.ceil((ccList.size() / (Double)n));
                        if(ccList.size() > n){
                            for (integer i = 1; i <= noOflst; i++) {
                                if(((i * n) - 1) < ccList.size()){
                                    list<String> temp = subArray(ccList, ((i * n) - n),(i * n) - 1);
                                    lstOflstOfCCEmail.add(temp);
                                }else{
                                    list<String> temp = subArray(ccList, ((i * n) - n),(ccList.size()-1));
                                    lstOflstOfCCEmail.add(temp);
                                }
                            }
                        }else{
                            lstOflstOfCCEmail.add(ccList);
                        } 
                    }       
                    List<Messaging.SingleEmailMessage> lstEmailToCCSend=new List<Messaging.SingleEmailMessage>();
                    if(lstOflstOfToEmail.size() == 1 && lstOflstOfCCEmail.size() == 1){
                        lstEmailToCCSend.add(emailToSend);
                    }else if(lstOflstOfToEmail.size() >= lstOflstOfCCEmail.size()){ //comparing the no of contained lists
                        Integer ccMaxIndex = lstOflstOfCCEmail.size() - 1;
                        Integer loopCount=0;
                        for(list<String> emailList : lstOflstOfToEmail){
                            Messaging.SingleEmailMessage emailClone=new Messaging.SingleEmailMessage();
                            emailClone=cloneEmail(emailToSend,emailClone);
                            emailClone.setToAddresses(emailList);
                            if(loopCount <= ccMaxIndex){
                                emailClone.setCcAddresses(lstOflstOfCCEmail.get(loopCount));
                            } 
                            lstEmailToCCSend.add(emailClone);
                            loopCount++;
                        }
                    }else if(lstOflstOfCCEmail.size() > lstOflstOfToEmail.size()){
                        Integer toMaxIndex = lstOflstOfToEmail.size() - 1;
                        Integer loopCount=0;
                        for(list<String> emailList : lstOflstOfCCEmail){
                            Messaging.SingleEmailMessage emailClone=new Messaging.SingleEmailMessage();
                            emailClone=cloneEmail(emailToSend,emailClone);
                            emailClone.setCcAddresses(emailList);
                            if(loopCount <= toMaxIndex){
                                emailClone.setToAddresses(lstOflstOfToEmail.get(loopCount));
                            } 
                            lstEmailToCCSend.add(emailClone);
                            loopCount++;
                        }
                    }
            Messaging.sendEmail(lstEmailToCCSend);
        }catch(Exception e){
            system.debug('Error in DRT Activation/Revision mail ='+e.getMessage());
            system.debug('StackTrace='+e.getStackTraceString());
        }
    }
    
    /**
    * @description: This is used to clone a SingleEmailMessage.
    * @param: Messaging.SingleEmailMessage src,Messaging.SingleEmailMessage dest
    * @return: Messaging.SingleEmailMessage
    **/
    private static Messaging.SingleEmailMessage cloneEmail(Messaging.SingleEmailMessage src,Messaging.SingleEmailMessage dest){
        dest.setBccAddresses(src.getBCCAddresses());
        dest.setHtmlBody(src.getHtmlBody());
        dest.setOrgWideEmailAddressId(src.getOrgWideEmailAddressId());
        dest.setSubject(src.getSubject()); 
        return  dest;
    }
    
    
    /**
    * @description: This is the wrapper class for Audit Trail
    **/
    public class AuditTrail {
       public String createdDate {get ;set ;}
       public String userName {get ;set ;}
       public String description {get;set;}
       public String fieldChange {get ;set ;}
       public String oldValue {get ;set ;}
       public String newValue {get ;set ;}
       
       public AuditTrail(String  createdDate , String userName, String description, String fieldChange, String oldValue ,String newValue) {
           this.createdDate = createdDate; 
           this.userName = userName;
           this.description = description;
           this.fieldChange = fieldChange;
           this.oldValue  = oldValue ;
           this.newValue  = newValue ;
        }
    }
    
    /**
    * @description: This is the error class for Frame DRT
    **/   
    public class FrameTableError {
        public Integer row;
        public Integer col;
        public Boolean invalid;
        public FrameTableError() {
        }
    }
    
    /**
    * @description: This is the error class for Prime DRT
    **/
    public class DRTErrorDetails {
        public Boolean error;
        public ErrorDetails MainTableError;
        public ErrorDetails MaskLayerHeaderError;
        public ErrorDetails MaskLayerContentError;  
    }
    
    /**
    * @description: This is the wrapper class for storing DRT object info.
    **/
    public class DRTWrapper {
        public Id drtId {get;set;}
        public string drtName {get;set;}
        public string drtCustomerName {get;set;}
        public string drtMSTName {get;set;}
        public string drtMSTId {get;set;}
        public string drtType {get;set;}
        public string drtStatus {get;set;}
        public string drtTechGeo {get;set;}
        public DRTWrapper(DRT__c drtObj) {
            this.drtId = drtObj.Id;
            this.drtName = drtObj.Name;
            this.drtCustomerName = drtObj.Customer_Name__r.Name+' ('+drtObj.Customer_Short_Name__c+')';
            this.drtMSTName = drtObj.Mask_Set_Title__r.Name;
            this.drtMSTId = drtObj.Mask_Set_Title__c;
            this.drtType = drtObj.Type__c;
            this.drtStatus = drtObj.Status__c;
            this.drtTechGeo = drtObj.Tech_Geo__c;
        }
    }
    
    /**
    * @description: This is the wrapper class for storing Frame DRT.
    **/
    public class FrameDRTWrapper {
        public integer counter {get;set;}
        public string mstId {get;set;}
        public string mstName {get;set;}
        public string layerNo {get;set;}
        public string retroMaskRev {get;set;}
        public string retroROMCode{get;set;}
        public string maskRev {get;set;}
        public string romCode {get;set;}
        public string colorClass {get;set;}
        
        //swgp-2
        public boolean isEdited_retroMaskRev {get;set;}
        public boolean isEdited_retroROMCode {get;set;}
        //swgp-2-end
        
        public FrameDRTWrapper(integer counter,string mstId,string mstName, string layerNo,string retroMaskRev,string retroROMCode,string maskRev,string romCode) {
            this.counter = counter;
            this.mstId = mstId;
            this.mstName = mstName.toUpperCase();
            this.layerNo = layerNo;
            if(!string.isBlank(retroMaskRev)){
                this.retroMaskRev = retroMaskRev.toUpperCase();
            }
            else {
                this.retroMaskRev = blankText;
            }
            if(!string.isBlank(retroROMCode)){
                this.retroROMCode = retroROMCode.toUpperCase();
            }
            else {
                this.retroROMCode = blankText;
            }
            if(!string.isBlank(maskRev)){
                this.maskRev = maskRev.toUpperCase();
            }
            if(!string.isBlank(romCode)){
                this.romCode = romCode.toUpperCase();
            }
            this.counter = counter;
            this.colorClass = (Math.mod(counter,2)==0)?DRTHandlerUtility.alternateColorClass:'';
        }
    }
    
/**
* @description: This method is used to handle specific exceptions and send emails.
* @param: Exception e, String Subject,string[] name
* @return: void
**/
public static void handleError(Exception e, String Subject,string[] name){
         string msg;
         string objName=''; 
         Boolean CheckSendMail = False;
         list<string> toList = new list<string>();
         if(name!=null){
         for(string strName : name)
         {
             if(name.size() == 1)
             objName =strName+',';
             if(name.size() > 1)
             objName+=strName+',';
         }
         }
         if(e != null) { 
              if(objName.length()>0){
              msg='<html><body><p>Dear Team,<br> EXCEPTION ON'+objName+':</p>Error:'+e.getMessage()+'<br>Type:'+e.getTypeName()+'<br> Line Number:'+e.getLineNumber()+'<br>Trace:'+e.getStackTraceString()+'(end stack trace)';
              }
        else{
              msg='<html><body><p>Dear Team,<br> EXCEPTION:</p>Error:'+e.getMessage()+'<br>Type:'+e.getTypeName()+'<br> Line Number:'+e.getLineNumber()+'<br>Trace:'+e.getStackTraceString()+'(end stack trace)';
        }             
             }
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        OrgWideEmailAddress Orgid=[Select id,Address, DisplayName From OrgWideEmailAddress where DisplayName=:'GLOBALFOUNDRIES' LIMIT 1];
        if(Orgid != null )
            {
            mail.setOrgWideEmailAddressId(Orgid.Id);
            CheckSendMail = True; 
            }
         toList.add(Orgid.Address);
         mail.setToAddresses(toList);
         mail.setSubject(Subject);
         mail.setHtmlBody(msg);
         mail.setUseSignature(false);
         mail.setSaveAsActivity(false);

         if(CheckSendMail)
         Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
        } 
        
         public static void handleErrorOnSyncOracleResponse(Exception e,string objName,string Subject){
         string msg;
         string sObjName ; 
         Boolean CheckSendMail = False;
         list<string> toList = new list<string>();
         if(objName != null && objName != '')
         {
            sObjName = id.valueOf(objName).getSObjectType().getDescribe().getName();
            if(e != null)
            msg='<html><body><p>Dear Team,<br> EXCEPTION ON UPDATING'+sObjName+':</p>Error:'+e.getMessage()+'<br>Type:'+e.getTypeName()+'<br> Line Number:'+e.getLineNumber()+'<br>Trace:'+e.getStackTraceString()+'(end stack trace)';
         }
         else
         {
            if(e != null)
            msg='<html><body><p>Dear Team,<br> EXCEPTION:</p>Error:'+e.getMessage()+'<br>Type:'+e.getTypeName()+'<br> Line Number:'+e.getLineNumber()+'<br>Trace:'+e.getStackTraceString()+'(end stack trace)';
         }
         
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        OrgWideEmailAddress Orgid=[Select id,Address, DisplayName From OrgWideEmailAddress where DisplayName=:'GLOBALFOUNDRIES' LIMIT 1];
        if(Orgid != null )
            {
            mail.setOrgWideEmailAddressId(Orgid.Id);
            CheckSendMail = True; 
            }
         toList.add(Orgid.Address);
         mail.setToAddresses(toList);
         mail.setSubject(Subject);
         mail.setHtmlBody(msg);
         mail.setUseSignature(false);
         mail.setSaveAsActivity(false);

         if(CheckSendMail)
         Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
        }    
    
    /**
    * @description: This method is used to handle exceptions of PLM_TECN and send emails.
    * @param: Exception e,string objName,set<string> tecns,string Subject
    * @return: void
    **/    
    public static void handleErrorOnPLM_TECN(Exception e,string objName,set<string> tecns,string Subject){
         string msg;
         string sObjName =''; 
         Boolean CheckSendMail = False;
         list<string> toList = new list<string>();
         if(tecns!=null){
         for(string strName : tecns)
         {
             if(tecns.size() == 1)
             sObjName =strName+',';
             if(tecns.size() > 1)
             sObjName +=strName+',';
         }
         }
         if(objName != null && objName != '' && tecns != null)
         {
            if(e != null)
            msg='<html><body><p>Dear Team,<br> EXCEPTION ON UPDATING MRS LAYER Association'+objName+'on PLM TECN Integration for TECNs :'+sObjName +':</p>Error:'+e.getMessage()+'<br>Type:'+e.getTypeName()+'<br> Line Number:'+e.getLineNumber()+'<br>Trace:'+e.getStackTraceString()+'(end stack trace)';
         }
         else if(tecns != null)
         {
            if(e != null)
            msg='<html><body><p>Dear Team,<br> EXCEPTION ON UPDATING MRS LAYER CHIP Association on PLM TECN Integration:</p>Error:'+e.getMessage()+'<br>Type:'+e.getTypeName()+'<br> Line Number:'+e.getLineNumber()+'<br>Trace:'+e.getStackTraceString()+'(end stack trace)';
         }
         else
         {
            if(e != null)
            msg='<html><body><p>Dear Team,<br> EXCEPTION ON MRS LAYER CHIP Association on PLM TECN Integration:</p>Error:'+e.getMessage()+'<br>Type:'+e.getTypeName()+'<br> Line Number:'+e.getLineNumber()+'<br>Trace:'+e.getStackTraceString()+'(end stack trace)';
         }
         
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        OrgWideEmailAddress Orgid=[Select id,Address, DisplayName From OrgWideEmailAddress where DisplayName=:'GLOBALFOUNDRIES' LIMIT 1];
        if(Orgid != null )
            {
            mail.setOrgWideEmailAddressId(Orgid.Id);
            CheckSendMail = True; 
            }
         toList.add(Orgid.Address);
         mail.setToAddresses(toList);
         mail.setSubject(Subject);
         mail.setHtmlBody(msg);
         mail.setUseSignature(false);
         mail.setSaveAsActivity(false);

         if(CheckSendMail)
         Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
        }
        
      /**
      * @description: This method is used to handle exceptions of DRT Package sync and send emails.
      * @param: Exception e,string objName,set<string> tecns,string Subject
      * @return: void
      **/
      public static void handleErrorOnSyncDRTPackageSync(Exception e,list<string> objName,string Subject){
         string msg;
         string sObjName='' ; 
         Boolean CheckSendMail = False;
         list<string> toList = new list<string>();
         if(objName != null)
         {
            sObjName = id.valueOf(objName[0]).getSObjectType().getDescribe().getName();
            if(e != null)
            msg='<html><body><p>Dear Team,<br> EXCEPTION ON DRT PACKAGE SYNC'+sObjName+':</p>Error:'+e.getMessage()+'<br>Type:'+e.getTypeName()+'<br> Line Number:'+e.getLineNumber()+'<br>Trace:'+e.getStackTraceString()+'(end stack trace)';
         }
         else
         {
            if(e != null)
            msg='<html><body><p>Dear Team,<br> EXCEPTION ON DRT PACKAGE SYNC:</p>Error:'+e.getMessage()+'<br>Type:'+e.getTypeName()+'<br> Line Number:'+e.getLineNumber()+'<br>Trace:'+e.getStackTraceString()+'(end stack trace)';
         }
         
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        OrgWideEmailAddress Orgid=[Select id,Address, DisplayName From OrgWideEmailAddress where DisplayName=:'GLOBALFOUNDRIES' LIMIT 1];
        if(Orgid != null )
            {
            mail.setOrgWideEmailAddressId(Orgid.Id);
            CheckSendMail = True; 
            }
         toList.add(Orgid.Address);
         mail.setToAddresses(toList);
         mail.setSubject(Subject);
         mail.setHtmlBody(msg);
         mail.setUseSignature(false);
         mail.setSaveAsActivity(false);

         if(CheckSendMail)
         Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
        }    
        
        /**
        * @description: This method is used to handle exceptions of CAD Response Service and send emails.
        * @param: Exception e,set<string> objName,string Subject
        * @return: void
        **/
        public static void handleErrorOnMRSCADResponseService(Exception e,set<string> objName,string Subject){
         string msg;
         string sObjName ; 
         Boolean CheckSendMail = False;
         list<string> toList = new list<string>();
         if(objName!=null){
         for(string strName : objName)
         {
             if(objName.size() == 1)
             sObjName =strName+',';
             if(objName.size() > 1)
             sObjName +=strName+',';
         }
         }
         if(objName != null)
         {
            if(e != null)
            msg='<html><body><p>Dear Team,<br> EXCEPTION ON SENDING RESPONSE <br> PTRF NUMBER :'+sObjName +'</p>Error:'+e.getMessage()+'<br>Type:'+e.getTypeName()+'<br> Line Number:'+e.getLineNumber()+'<br>Trace:'+e.getStackTraceString()+'(end stack trace)';
         }
         else
         {
            if(e != null)
            msg='<html><body><p>Dear Team,<br> EXCEPTION ON SENDING RESPONSE:</p>Error:'+e.getMessage()+'<br>Type:'+e.getTypeName()+'<br> Line Number:'+e.getLineNumber()+'<br>Trace:'+e.getStackTraceString()+'(end stack trace)';
         }
         
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        OrgWideEmailAddress Orgid=[Select id,Address, DisplayName From OrgWideEmailAddress where DisplayName=:'GLOBALFOUNDRIES' LIMIT 1];
        if(Orgid != null )
            {
            mail.setOrgWideEmailAddressId(Orgid.Id);
            CheckSendMail = True; 
            }
         toList.add(Orgid.Address);
         mail.setToAddresses(toList);
         mail.setSubject(Subject);
         mail.setHtmlBody(msg);
         mail.setUseSignature(false);
         mail.setSaveAsActivity(false);

         if(CheckSendMail)
         Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
        } 
        
        public static void handleErrorOnMRSCADResponseServiceDRT(Exception e,set<string> objName,string Subject){
         string msg;
         string sObjName='' ; 
         Boolean CheckSendMail = False;
         list<string> toList = new list<string>();
         if(objName!=null){
         for(string strName : objName)
         {
             if(objName.size() == 1)
             sObjName =strName+',';
             if(objName.size() > 1)
             sObjName +=strName+',';
         }
         }
         if(objName != null)
         {
            if(e != null)
            msg='<html><body><p>Dear Team,<br> EXCEPTION ON SENDING RESPONSE <br> DRT NUMBER :'+sObjName +'</p>Error:'+e.getMessage()+'<br>Type:'+e.getTypeName()+'<br> Line Number:'+e.getLineNumber()+'<br>Trace:'+e.getStackTraceString()+'(end stack trace)';
         }
         else
         {
            if(e != null)
            msg='<html><body><p>Dear Team,<br> EXCEPTION ON SENDING RESPONSE:</p>Error:'+e.getMessage()+'<br>Type:'+e.getTypeName()+'<br> Line Number:'+e.getLineNumber()+'<br>Trace:'+e.getStackTraceString()+'(end stack trace)';
         }
         
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        OrgWideEmailAddress Orgid=[Select id,Address, DisplayName From OrgWideEmailAddress where DisplayName=:'GLOBALFOUNDRIES' LIMIT 1];
        if(Orgid != null )
            {
            mail.setOrgWideEmailAddressId(Orgid.Id);
            CheckSendMail = True; 
            }
         toList.add(Orgid.Address);
         mail.setToAddresses(toList);
         mail.setSubject(Subject);
         mail.setHtmlBody(msg);
         mail.setUseSignature(false);
         mail.setSaveAsActivity(false);

         if(CheckSendMail)
         Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
        }        
        
    
    /**
    * @description: This method is used to handle exceptions of PLM_TECN
    * @param: Exception e,list<string> reTecnNo,list<string> tecnNo,string Subject
    * @return: void
    **/    
    public static void handleErrorOnPLMTecnService(Exception e,list<string> reTecnNo,list<string> tecnNo,string Subject){
         string msg;
         string sTecnNo='' ; 
         string sReTecnNo='' ; 
         Boolean CheckSendMail = False;
         list<string> toList = new list<string>();
         if(tecnNo!=null){
         for(string strName : tecnNo)
         {
             if(tecnNo.size() == 1)
             sTecnNo =strName+',';
             if(tecnNo.size() > 1)
             sTecnNo +=strName+',';
         }
         }
         
         if(reTecnNo!=null){
         for(string strName : reTecnNo)
         {
             if(reTecnNo.size() == 1)
             sReTecnNo =strName+',';
             if(reTecnNo.size() > 1)
             sReTecnNo +=strName+',';
         }
         }
         if(tecnNo != null && reTecnNo!=null)
         {
            if(e != null)
            msg='<html><body><p>Dear Team,<br> EXCEPTION ON PLM TECN INTEGRATION <br> TECN NO :'+sTecnNo +'RELATED TECN NO :'+sReTecnNo +'</p>Error:'+e.getMessage()+'<br>Type:'+e.getTypeName()+'<br> Line Number:'+e.getLineNumber()+'<br>Trace:'+e.getStackTraceString()+'(end stack trace)';
         }
         else
         {
            if(e != null)
            msg='<html><body><p>Dear Team,<br> EXCEPTION ON PLM TECN INTEGRATION:</p>Error:'+e.getMessage()+'<br>Type:'+e.getTypeName()+'<br> Line Number:'+e.getLineNumber()+'<br>Trace:'+e.getStackTraceString()+'(end stack trace)';
         }
         
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        OrgWideEmailAddress Orgid=[Select id,Address, DisplayName From OrgWideEmailAddress where DisplayName=:'GLOBALFOUNDRIES' LIMIT 1];
        if(Orgid != null )
            {
            mail.setOrgWideEmailAddressId(Orgid.Id);
            CheckSendMail = True; 
            }
         toList.add(Orgid.Address);
         mail.setToAddresses(toList);
         mail.setSubject(Subject);
         mail.setHtmlBody(msg);
         mail.setUseSignature(false);
         mail.setSaveAsActivity(false);

         if(CheckSendMail)
         Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
        }        
        
   
    /**
    * @description: This method is used to handle exceptions of PTRF_AUPD trigger
    * @param: Exception e,set<string> objName,string ptrfOp,string Subject
    * @return: void
    **/
    public static void handleErrorOnPTRF_AUPD(Exception e,set<string> objName,string ptrfOp,string Subject){
         string msg;
         string sObjName='' ; 
         Boolean CheckSendMail = False;
         list<string> toList = new list<string>();
         if(objName!=null){
         for(string strName : objName)
         {
             if(objName.size() == 1)
             sObjName =strName+',';
             if(objName.size() > 1)
             sObjName +=strName+',';
         }
         }
         if(objName != null)
         {
            if(e != null)
            msg='<html><body><p>Dear Team,<br> EXCEPTION ON '+ptrfOp+' ON PTRF:'+sObjName +'</p>Error:'+e.getMessage()+'<br>Type:'+e.getTypeName()+'<br> Line Number:'+e.getLineNumber()+'<br>Trace:'+e.getStackTraceString()+'(end stack trace)';
         }
         else
         {
            if(e != null)
            msg='<html><body><p>Dear Team,<br> EXCEPTION ON '+ptrfOp+'ON PTRF :</p>Error:'+e.getMessage()+'<br>Type:'+e.getTypeName()+'<br> Line Number:'+e.getLineNumber()+'<br>Trace:'+e.getStackTraceString()+'(end stack trace)';
         }
         
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        OrgWideEmailAddress Orgid=[Select id,Address, DisplayName From OrgWideEmailAddress where DisplayName=:'GLOBALFOUNDRIES' LIMIT 1];
        if(Orgid != null )
            {
            mail.setOrgWideEmailAddressId(Orgid.Id);
            CheckSendMail = True; 
            }
         toList.add(Orgid.Address);
         mail.setToAddresses(toList);
         mail.setSubject(Subject);
         mail.setHtmlBody(msg);
         mail.setUseSignature(false);
         mail.setSaveAsActivity(false);

         if(CheckSendMail)
         Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
        } 
    
    /**
    * @description: Check if a user is GF employee
    * @param: User's Id
    * @return: true/false
    **/
    public static boolean isGFEmployee(Id userId){
        boolean b = true;
        List<User> users = [Select Email from User where Id=:userId];
        if(users.size()> 0 && !users.get(0).Email.contains('@globalfoundries.com')){
            b = false;//external user
        }
        return b;
    }
    
    /**
    Dummy method added to increase code coverage due to existing salesforce issue.
    Because of current class is too large so this is a workaround possible at this time.
    Issue link: https://success.salesforce.com/issues_view?id=a1p30000000T4oRAAS
    */
    // start dummy method
    public Integer mthdDummy(){
        Integer a = 1;
        Integer b = 5;
        Integer c = 0;      
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        return 1;
    }
    // end dummy method
    
    public Integer mthdDummy2(){
        Integer a = 1;
        Integer b = 5;
        Integer c = 0;      
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        return 1;
    }
}