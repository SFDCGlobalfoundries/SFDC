/*
    Author: Shyam Nair
    Description: This class is used as controller for Internal Chargeout Report.
    History: 
        SNair      11082015    - Page creation.
      Kanishk Singh #00072337 Include the PA code name(in addition to number) in Internal Charge Out Report.  
      Kanishk Singh MPW-PP143  all the wrapper list/map as transient to fix view state issue. Now pagination is done using jquery datatable instead of
                               standardsetcontroller  
*/
public class InternalChargeOutReportController {

    public boolean noresultfound{get;set;}
    public boolean searchValue{get;set;}    
    public String selectedVal{get; set;}
    public integer totalNoOfPages {get; set;}
    public integer totalNoOfRecords {get; set;}
    public integer currentPageNo {get; set;}
    public String formNo{get;set;}
    public String mpwNo{get;set;}
    public String formStatus{get;set;}
    public String Usage{get;set;}
    public String Category{get;set;}
    public String formnumber{get;set;}
    public list<SelectOption> pageList {get; set;}
    public transient  List<MPW_Prime_Die__c> mpwpdList{get;set;}
    public transient  List<MPW_Change_Request__c> mpwcrList{get;set;}
    public transient  List<MPW_Extra_Die__c> mpwedList{get;set;}
    public List<Internal_Guideline_Factor__c> iglfList{get;set;}
    public transient  List<primediechangerequesWrapper> pcwrList{get;set;}
    public List<List<string>> listDetails {get; set;}
    public Map<String, Internal_Guideline_Factor__c> iglfMap{get;set;}
    public transient Map<Integer, List<primediechangerequesWrapper>> pcwrMap{get;set;}
    public UtilClassToGetAllFields util{get;set;}
    public Decimal totaldieqty{get;set;}
    public Decimal totalwaferqty{get;set;}
    public Decimal totaldienos{get;set;}
    public Decimal totalusedreticlespace{get;set;}
    public Decimal totalreqdienos{get;set;}
    public Decimal totalreqextradies{get;set;}
    public String fromEmail{get;set;}
        
    public InternalChargeOutReportController(){
        this.totaldieqty = 0;
        this.totalwaferqty = 0;
        this.totaldienos = 0;
        this.totalusedreticlespace = 0;
        this.totalreqdienos = 0;
        this.totalreqextradies = 0;
        this.noresultfound = false;
        this.searchValue = false;
        this.selectedVal = '10';
        this.totalNoOfPages = 0;
        this.totalNoOfRecords = 0;
        this.currentPageNo = 1; 
        this.Category = 'IP';
        this.Usage = 'Required';
        this.formStatus = 'Draft';
        this.formnumber = ApexPages.currentPage().getParameters().get('MPWFormNo');
        this.fromEmail = ApexPages.currentPage().getParameters().get('FROMEMAIL');
        util = new UtilClassToGetAllFields();
        iglfList = new List<Internal_Guideline_Factor__c>();
        iglfMap = new Map<String, Internal_Guideline_Factor__c>();
        String mapFields = util.getAllFields('Internal_Guideline_Factor__c');
        String sql = 'select '+mapFields+' from Internal_Guideline_Factor__c order by Name asc';
        iglfList = database.query(sql);
        if(!iglfList.isEmpty()){
            for(Internal_Guideline_Factor__c  i : iglfList){
                iglfMap.put(i.TechID__c, i);
            }
        }
        getpageList();
        if(this.formnumber != null){
            this.mpwNo = '';
            this.formNo = this.formnumber;
            this.Category = 'None';
            this.Usage = 'None';
            this.formStatus = 'None';
            retrieveRecords();
        }
    }
    
    public List<SelectOption> getCategoryOptions(){
        List<SelectOption> categoryOptions = new List<SelectOption>();
        categoryOptions.add(new SelectOption('None','--None--'));
        categoryOptions.add(new SelectOption('All','All'));
        categoryOptions.add(new SelectOption('IP','IP'));
        categoryOptions.add(new SelectOption('FAB','FAB'));
        categoryOptions.add(new SelectOption('TD','TD'));
        categoryOptions.add(new SelectOption('DE','DE'));
        categoryOptions.add(new SelectOption('ASIC R&D','ASIC R&D'));
        categoryOptions.add(new SelectOption('RF_ASIC_A&D Protos','RF_ASIC_A&D Protos'));
        categoryOptions.add(new SelectOption('Lighting','Lighting'));
        
        return categoryOptions;
    }
    
    public List<SelectOption> getFormStatusOptions(){
        List<SelectOption> formStatusOptions = new List<SelectOption>();
        formStatusOptions.add(new SelectOption('None','--None--'));
        formStatusOptions.add(new SelectOption('Draft','Draft'));
        formStatusOptions.add(new SelectOption('Accepted by MPW Tapeout','Accepted by MPW Tapeout'));
        formStatusOptions.add(new SelectOption('Pending Internal Budget Owner Approval','Pending Internal Budget Owner Approval'));
        formStatusOptions.add(new SelectOption('Pending MPW Tapeout Review','Pending MPW Tapeout Review'));
        formStatusOptions.add(new SelectOption('Pending FAE Review','Pending FAE Review'));
        formStatusOptions.add(new SelectOption('Pending MPW Business Representative Approval','Pending MPW Business Representative Approval'));
        formStatusOptions.add(new SelectOption('Void','Void'));
        return formStatusOptions;
    }
    
    public List<SelectOption> getUsageOptions(){
        List<SelectOption> usageOptions = new List<SelectOption>();
        usageOptions.add(new SelectOption('None','--None--'));
        for(MPW_Keyword_Config__c m: [SELECT Value__c, Sequence_No__c FROM MPW_Keyword_Config__c WHERE Type__c = 'CategoryUsage' AND Active__c = true order by Sequence_No__c asc]){
            usageOptions.add(new SelectOption(m.Value__c, m.Value__c));
        }
        return usageOptions;
    }
    
    public pageReference reset(){
        pageReference pgRef = new pageReference('/apex/InternalChargeOutReportVF');
        pgRef.setRedirect(true);
        return pgRef;
    }
    
    public void searchMethod(){
        if(this.mpwNo == '' && this.formNo == '' && (this.formStatus == 'None' || this.Usage == 'None'|| this.Category == 'None')){
            ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR,'Form Status, Usage and Category cannot be blank.'));
        }
        else{
            retrieveRecords();
        }
    }
    
    public void retrieveRecords(){
        this.searchValue = true;
        this.mpwpdList = new List<MPW_Prime_Die__c>(); 
        this.mpwcrList = new List<MPW_Change_Request__c>();
        this.mpwedList = new List<MPW_Extra_Die__c>();
        this.pcwrList = new List<primediechangerequesWrapper>();
        this.pcwrMap = new Map<Integer, List<primediechangerequesWrapper>>(); 
        String queryFields = util.getAllFields('MPW_Prime_Die__c');
        queryFields += ', MPW_Form__r.Name, MPW_Form__r.Customer_Name__c';
        String soql = 'SELECT '+queryFields+' FROM MPW_Prime_Die__c WHERE Category__c IN (\'IP\',\'FAB\',\'TD\',\'DE\',\'ASIC R&D\',\'RF_ASIC_A&D Protos\',\'Lighting\') AND Created_Date__c > 2014-02-28T23:59:00.000+0000 ';
        String sqlfilters = '';
        if(this.formNo != '' || this.mpwNo != '' || this.formStatus != 'None' || this.Usage != 'None' || this.Category != 'None'){
            if(this.mpwNo!= ''){
                sqlfilters += 'AND MPW_Train__c LIKE \'%' + this.mpwNo.replace('*', '%') + '%\' ';   
            }
            if(this.formNo != ''){
                sqlfilters += 'AND MPW_Form__r.Name LIKE \'' + this.formNo.replace('*', '%') + '%\' ';
            }
            if(this.formStatus != 'None'){
                sqlfilters += 'AND MPW_Form_Status__c = \'' + this.formStatus + '\' ';
            }
            if(this.Usage != 'None'){
                sqlfilters += 'AND Usage__c = \'' + this.Usage+ '\' ';
            }
            if(this.Category != 'None' && this.Category != 'All'){
                sqlfilters += 'AND Category__c= \'' + this.Category+ '\' ';
            }
        }
        if(sqlfilters != ''){
            soql += sqlfilters;
        }
        
        soql += ' ORDER BY Prime_Die_Name__c DESC';
        List<MPW_Prime_Die__c> tempList = new List<MPW_Prime_Die__c>();
        tempList = database.query(soql);
        this.mpwpdList = tempList;
        
         Map<String,String> mapPACodedescription=new  Map<String,String>();
         
        if(!this.mpwpdList.isEmpty()){
            Set<Id> pdIdList = new Set<Id>();
            Set<String> setPACode=new Set<String>();
            
            for(MPW_Prime_Die__c m: tempList){
                pdIdList.add(m.Id);
                if(m.PA_Code__c!=null && m.PA_Code__c!=''){
                  setPACode.add(m.PA_Code__c);  
                }
            }
          
            //Added by Anil : MPW-PP121
            //Set<String> setRequestTypeDefault = new Set<String>{'Drawn Die Size Change', 'Wafer Form Delivery', 'Corner Split Change', 'Extra Dies/Wafer Re-start'};
            Set<String> setRequestType = new Set<String>();
            for(MPW_Internal_Chargeout_Report__c cs : [SELECT Name, Change_Request__c FROM MPW_Internal_Chargeout_Report__c]) {
                setRequestType.add(cs.Change_Request__c);
            }
            
            String querychangerequestfields = util.getAllFields('MPW_Change_Request__c');
            querychangerequestfields += ', MPW_Form__r.Customer_Name__c, MPW_Prime_Die__r.Geometry__c';
            String query = 'SELECT '+querychangerequestfields+' FROM MPW_Change_Request__c WHERE MPW_Prime_Die__c IN: pdIdList ';
            query += ' AND Request_Type__c IN: setRequestType ';
            query += ' order by MPW_Prime_Die_Name__c DESC';
            this.mpwcrList = database.query(query);
            
            if(setRequestType.contains('Extra Dies/Wafer Re-start')) {
                String queryextradiefields = util.getAllFields('MPW_Extra_Die__c');
                queryextradiefields += ', MPW_Prime_Die__r.MPW_Form__r.Customer_Name__c, MPW_Prime_Die__r.Geometry__c, ';
                queryextradiefields += ' MPW_Prime_Die__r.MPW_Form__r.Category__c, MPW_Prime_Die__r.MPW_Form__r.Usage__c, MPW_Prime_Die__r.MPW_Form__r.PA_Code__c, MPW_Prime_Die__r.MPW_Form__c ';
                String queryED = 'SELECT '+queryextradiefields+' FROM MPW_Extra_Die__c WHERE MPW_Prime_Die__c IN: pdIdList ';
                queryED += ' AND ObjectType__c = \'MPW_Extra_Die__c\' AND Extra_Die_B__c != NULL order by Prime_Die_Name__c DESC';
                this.mpwedList = database.query(queryED);
            }
            
          if(!this.mpwcrList.isEmpty()){      
            for(MPW_Change_Request__c objChangeRequest: this.mpwcrList){
               if(objChangeRequest.PA_Code__c!=null && objChangeRequest.PA_Code__c!=''){
                  setPACode.add(objChangeRequest.PA_Code__c);   
                }
            }
          }
         
          if(!this.mpwedList.isEmpty()){   
            for(MPW_Extra_Die__c objExtraDie: this.mpwedList){
               if(objExtraDie.MPW_Prime_Die__r.MPW_Form__r.PA_Code__c!=null && objExtraDie.MPW_Prime_Die__r.MPW_Form__r.PA_Code__c!=''){
                  setPACode.add(objExtraDie.MPW_Prime_Die__r.MPW_Form__r.PA_Code__c);   
                }
            }
          } 
          
          for(MPW_ERP_PA_Code__c objMPWERPPACode:[select id,PA_Description__c,Name from MPW_ERP_PA_Code__c where Name In:setPACode]){
                mapPACodedescription.put(objMPWERPPACode.Name.toUpperCase(),objMPWERPPACode.PA_Description__c);
            }
         }
        
        /*** Start : Added By Anil ***/
        Map<String, MPW_Internal_Guideline_Factor__c> mapInternalGuidelineFactorCS = new Map<String, MPW_Internal_Guideline_Factor__c>();
        for(MPW_Internal_Guideline_Factor__c cs: [SELECT Id, Name, Category__c, Geometry__c, NON_SPLIT_Corner_Factor__c, SPLIT_Corner_Factor__c
                                                    FROM MPW_Internal_Guideline_Factor__c]) {
            String strKey = cs.Category__c.trim().toLowerCase() + '-' + cs.Geometry__c.trim().toLowerCase();
            mapInternalGuidelineFactorCS.put(strKey, cs);
        }
        /*** End : Added By Anil ***/
        
        if(!this.mpwpdList.isEmpty()){
            this.noresultfound = false;
            for(MPW_Prime_Die__c m: this.mpwpdList){
                
                
                if(m.Drawn_Die_Size_X_um__c == null){
                    m.Drawn_Die_Size_X_um__c = '0';
                }
                if(m.Drawn_Die_Size_Y_um__c == null){
                    m.Drawn_Die_Size_Y_um__c = '0';
                }
                Decimal diexsize = Decimal.valueOf(m.Drawn_Die_Size_X_um__c) * 0.001;
                Decimal dieysize = Decimal.valueOf(m.Drawn_Die_Size_Y_um__c) * 0.001;
                diexsize = diexsize.setScale(3, RoundingMode.HALF_UP);
                dieysize = dieysize.setScale(3, RoundingMode.HALF_UP); 
                
                //Modified by Anil : MPW-PP121 - March 8, 2017
                String rect = '';
                if(m.RETICLE_SPACE_A__c != null && m.RETICLE_SPACE_A__c != 0) {
                    rect = String.valueOf(m.RETICLE_SPACE_A__c.setScale(2));
                }
                else {
                    rect =iglfMap.get(m.Geometry__c)!=null?String.valueOf((diexsize * dieysize * iglfMap.get(m.Geometry__c).Reticle__c).setScale(2, RoundingMode.HALF_UP)):'';
                }
                
                String reqdieno = '';
                String reqextradie = '';
                List<String> dietowaferlist =iglfMap.get(m.Geometry__c)!=null?iglfMap.get(m.Geometry__c).DieToWaferConv__c.split('/'):new List<String>();
                if(m.Delivery_Qty_Die_Form__c == null){
                    m.Delivery_Qty_Die_Form__c = '0';
                }
                if(m.Delivery_Qty_Wafer_Form__c == null){
                    m.Delivery_Qty_Wafer_Form__c = '0';
                }
                
                /*** Start : Added By Anil ***/
                Integer intDQDF = Integer.valueOf(m.Delivery_Qty_Die_Form__c); 
                Integer intDQWF = Integer.valueOf(m.Delivery_Qty_Wafer_Form__c); 
                if(m.Corner_Split__c != null && m.Corner_Split__c.toLowerCase() == 'yes' && m.Category__c != null && m.Geometry__c != null) {
                    String strKey = m.Category__c.trim().toLowerCase() + '-' + m.Geometry__c.trim().toLowerCase();
                    Integer intSplitFactor = mapInternalGuidelineFactorCS.containsKey(strKey) ? Integer.valueOf(mapInternalGuidelineFactorCS.get(strKey).SPLIT_Corner_Factor__c) : 1;
                    
                    Integer intNonSplitFactor = mapInternalGuidelineFactorCS.containsKey(strKey) ? Integer.valueOf(mapInternalGuidelineFactorCS.get(strKey).NON_SPLIT_Corner_Factor__c) : 1;
                    
                    Integer intPOR = m.POR__c == null ? 0 : Integer.valueOf(m.POR__c); 
                    Integer intFF = m.FF__c == null ? 0 : Integer.valueOf(m.FF__c); 
                    Integer intSS = m.SS__c == null ? 0 : Integer.valueOf(m.SS__c); 
                    Integer intSF = m.SF__c == null ? 0 : Integer.valueOf(m.SF__c); 
                    Integer intFS = m.FS__c == null ? 0 : Integer.valueOf(m.FS__c); 
                    intDQDF = (intDQDF - intPOR - intFF - intSS - intSF - intFS);
                    intDQDF = intDQDF + (intPOR * intNonSplitFactor) + (intFF * intSplitFactor) + (intSS * intSplitFactor) + (intSF * intSplitFactor) + (intFS * intSplitFactor);
                    
                    Integer intWPOR = m.Wafer_POR__c == null ? 0 : Integer.valueOf(m.Wafer_POR__c); 
                    Integer intWFF = m.Wafer_FF__c == null ? 0 : Integer.valueOf(m.Wafer_FF__c); 
                    Integer intWSS = m.Wafer_SS__c == null ? 0 : Integer.valueOf(m.Wafer_SS__c); 
                    Integer intWSF = m.Wafer_SF__c == null ? 0 : Integer.valueOf(m.Wafer_SF__c); 
                    Integer intWFS = m.Wafer_FS__c == null ? 0 : Integer.valueOf(m.Wafer_FS__c); 
                    intDQWF = (intDQWF - intWPOR - intWFF - intWSS - intWSF - intWFS);
                    intDQWF = intDQWF + (intWPOR * intNonSplitFactor) + (intWFF * intSplitFactor) + (intWSS * intSplitFactor) + (intWSF * intSplitFactor) + (intWFS * intSplitFactor);
                }
                else if(m.Corner_Split__c != null && m.Corner_Split__c.toLowerCase() == 'no' && m.Category__c != null && m.Geometry__c != null) {
                    String strKey = m.Category__c.trim().toLowerCase() + '-' + m.Geometry__c.trim().toLowerCase();
                    
                    Integer intNonSplitFactor = mapInternalGuidelineFactorCS.containsKey(strKey) ? Integer.valueOf(mapInternalGuidelineFactorCS.get(strKey).NON_SPLIT_Corner_Factor__c) : 1;
                    
                    intDQDF = intDQDF * intNonSplitFactor;
                    intDQWF = intDQWF * intNonSplitFactor;
                }
                
                if(m.Extra_Die_B__c != null && m.Extra_Die_B__c != 0) {
                    reqdieno = String.valueOf(m.Extra_Die_B__c.setScale(2));
                }
                else {
                    reqdieno =iglfMap.get(m.Geometry__c)!=null? String.valueOf((((intDQDF + (intDQWF * 50)) * iglfMap.get(m.Geometry__c).Wafer__c) / Integer.valueOf(dietowaferlist[1])).setScale(2,RoundingMode.HALF_UP)):'';
                }
                 //reqdieno =iglfMap.get(m.Geometry__c)!=null? String.valueOf((((intDQDF + (intDQWF * 50)) * iglfMap.get(m.Geometry__c).Wafer__c) / Integer.valueOf(dietowaferlist[1])).setScale(2,RoundingMode.HALF_UP)):'';
                /*** End : Added By Anil ***/
                
               // reqdieno = String.valueOf((((Integer.valueOf(m.Delivery_Qty_Die_Form__c) + (Integer.valueOf(m.Delivery_Qty_Wafer_Form__c) * 50)) * iglfMap.get(m.Geometry__c).Wafer__c) / Integer.valueOf(dietowaferlist[1])).setScale(2,RoundingMode.HALF_UP));
                reqextradie = '0';
               
               /*Get PA Code Name from MPW_ERP_PA_Code__c object*/ 
                String strPACode=getPACodeDescription(mapPACodedescription,m.PA_Code__c);
                
                this.pcwrList.add(new primediechangerequesWrapper(String.valueOf(m.Extra_Die_Qty__c),rect,reqdieno,reqextradie,m.MPW_Train__c,m.MPW_Form__r.Customer_Name__c,m.Category__c,m.Sub_Category__c,m.Usage__c,m.Prime_Die_Name__c,diexsize,dieysize,m.Delivery_Qty_Die_Form__c,m.Delivery_Qty_Wafer_Form__c,m.Bare_Die_Ship_Date__c,m.PA_Code__c,strPACode,m.MPW_Form_Status__c,m.MPW_Form__r.Name,m.MPW_Form__c, false, ''));
                
                if(!this.mpwcrList.isEmpty()){
                    for(MPW_Change_Request__c c: this.mpwcrList){
                        if(m.Id == c.MPW_Prime_Die__c && (c.Request_Type__c != 'Extra Dies/Wafer Re-start' || (c.Request_Type__c == 'Extra Dies/Wafer Re-start' && !c.Status__c.startsWith('Accepted')))){
                            if(c.Drawn_Die_Size_X_um__c == null){
                                c.Drawn_Die_Size_X_um__c = '0';
                            }
                            if(c.Drawn_Die_Size_Y_um__c == null){
                                c.Drawn_Die_Size_Y_um__c = '0';
                            }
                            Decimal cdiexsize = Decimal.valueOf(c.Drawn_Die_Size_X_um__c) * 0.001;
                            Decimal cdieysize = Decimal.valueOf(c.Drawn_Die_Size_Y_um__c) * 0.001;
                            cdiexsize = cdiexsize.setScale(3, RoundingMode.HALF_UP);
                            cdieysize = cdieysize.setScale(3, RoundingMode.HALF_UP);
                            
                            //Modified by Anil : MPW-PP121 - March 8, 2017
                            String crect = '';
                            if(c.Request_Type__c == 'Drawn Die Size Change' && c.Status__c != null && c.Status__c.startsWith('Accepted') && m.RETICLE_SPACE_A__c != null && m.RETICLE_SPACE_A__c != 0) {
                                crect = String.valueOf(m.RETICLE_SPACE_A__c.setScale(2));
                            }
                            else  {
                                crect =iglfMap.get(c.MPW_Prime_Die__r.Geometry__c)!=null? String.valueOf((cdiexsize * cdieysize * iglfMap.get(c.MPW_Prime_Die__r.Geometry__c).Reticle__c).setScale(2,RoundingMode.HALF_UP)):'';
                            }
                            
                            String creqdieno = '';
                            String creqextradie = '';
                            List<String> cdietowaferlist =iglfMap.get(c.MPW_Prime_Die__r.Geometry__c)!=null?iglfMap.get(c.MPW_Prime_Die__r.Geometry__c).DieToWaferConv__c.split('/'):new List<String>();
                            if(c.Delivery_Qty_Die_Form__c == null){
                                c.Delivery_Qty_Die_Form__c = '0';
                            }
                            if(c.Delivery_Qty_Wafer_Form__c == null){
                                c.Delivery_Qty_Wafer_Form__c = '0';
                            }
                            if(c.Extra_Die_Quantity__c == null){
                                c.Extra_Die_Quantity__c = 0;
                            }
                            creqdieno = '0';
                            
                            /*** Start : Added By Anil ***/
                            Integer intDQDF1 = Integer.valueOf(c.Delivery_Qty_Die_Form__c); 
                            Integer intDQWF1 = Integer.valueOf(c.Delivery_Qty_Wafer_Form__c); 
                            
                            Integer totalnoofdie = 0;    
                            if(c.Address1_Quantity_Delivery_In_DIE_Form__c != '0' && c.Address1_Quantity_Delivery_In_DIE_Form__c != null){
                                totalnoofdie += Integer.valueOf(c.Address1_Quantity_Delivery_In_DIE_Form__c);
                            }
                            if(c.Address2_Quantity_Delivery_In_DIE_Form__c != '0' && c.Address2_Quantity_Delivery_In_DIE_Form__c != null){
                                totalnoofdie += Integer.valueOf(c.Address2_Quantity_Delivery_In_DIE_Form__c);
                            }
                            if(c.Address3_Quantity_Delivery_In_DIE_Form__c != '0' && c.Address3_Quantity_Delivery_In_DIE_Form__c != null){
                                totalnoofdie += Integer.valueOf(c.Address3_Quantity_Delivery_In_DIE_Form__c);
                            }
                            
                            Integer totalnoofwafer = 0;    
                            if(c.Address1_Quantity_Delivery_In_WAFER_Form__c != '0' && c.Address1_Quantity_Delivery_In_WAFER_Form__c != null){
                                totalnoofwafer += Integer.valueOf(c.Address1_Quantity_Delivery_In_WAFER_Form__c);
                            }
                            if(c.Address2_Quantity_Delivery_In_WAFER_Form__c != '0' && c.Address2_Quantity_Delivery_In_WAFER_Form__c != null){
                                totalnoofwafer += Integer.valueOf(c.Address2_Quantity_Delivery_In_WAFER_Form__c);
                            }
                            if(c.Address3_Quantity_Delivery_In_WAFER_Form__c != '0' && c.Address3_Quantity_Delivery_In_WAFER_Form__c != null){
                                totalnoofwafer += Integer.valueOf(c.Address3_Quantity_Delivery_In_WAFER_Form__c);
                            }
                            
                            if(c.Request_Type__c == 'Extra Dies/Wafer Re-start'){
                                intDQDF1 = totalnoofdie;
                                intDQWF1 = totalnoofwafer;
                                
                                totalnoofdie = totalnoofdie + totalnoofwafer*50;
                            }
                            
                            if(c.Corner_Split__c != null && c.Corner_Split__c.toLowerCase() == 'yes' && c.Category__c != null && c.MPW_Prime_Die__r.Geometry__c != null) {
                                String strKey = c.Category__c.trim().toLowerCase() + '-' + c.MPW_Prime_Die__r.Geometry__c.trim().toLowerCase();
                                Integer intSplitFactor = mapInternalGuidelineFactorCS.containsKey(strKey) ? Integer.valueOf(mapInternalGuidelineFactorCS.get(strKey).SPLIT_Corner_Factor__c) : 1;
                    
                                Integer intNonSplitFactor = mapInternalGuidelineFactorCS.containsKey(strKey) ? Integer.valueOf(mapInternalGuidelineFactorCS.get(strKey).NON_SPLIT_Corner_Factor__c) : 1;
                                
                                Integer intPOR = c.POR__c == null ? 0 : Integer.valueOf(c.POR__c); 
                                Integer intFF = c.FF__c == null ? 0 : Integer.valueOf(c.FF__c); 
                                Integer intSS = c.SS__c == null ? 0 : Integer.valueOf(c.SS__c); 
                                Integer intSF = c.SF__c == null ? 0 : Integer.valueOf(c.SF__c); 
                                Integer intFS = c.FS__c == null ? 0 : Integer.valueOf(c.FS__c); 
                                intDQDF1 = (intDQDF1 - intPOR - intFF - intSS - intSF - intFS);
                                intDQDF1 = intDQDF1 + (intPOR * intNonSplitFactor) + (intFF * intSplitFactor) + (intSS * intSplitFactor) + (intSF * intSplitFactor) + (intFS * intSplitFactor);
                                
                                Integer intWPOR = c.Wafer_POR__c == null ? 0 : Integer.valueOf(c.Wafer_POR__c); 
                                Integer intWFF = c.Wafer_FF__c == null ? 0 : Integer.valueOf(c.Wafer_FF__c); 
                                Integer intWSS = c.Wafer_SS__c == null ? 0 : Integer.valueOf(c.Wafer_SS__c); 
                                Integer intWSF = c.Wafer_SF__c == null ? 0 : Integer.valueOf(c.Wafer_SF__c); 
                                Integer intWFS = c.Wafer_FS__c == null ? 0 : Integer.valueOf(c.Wafer_FS__c); 
                                intDQWF1 = (intDQWF1 - intWPOR - intWFF - intWSS - intWSF - intWFS);
                                intDQWF1 = intDQWF1 + (intWPOR * intNonSplitFactor) + (intWFF * intSplitFactor) + (intWSS * intSplitFactor) + (intWSF * intSplitFactor) + (intWFS * intSplitFactor);
                            }
                            else if(c.Corner_Split__c != null && c.Corner_Split__c.toLowerCase() == 'no' && c.Category__c != null && c.MPW_Prime_Die__r.Geometry__c != null) {
                                String strKey = c.Category__c.trim().toLowerCase() + '-' + c.MPW_Prime_Die__r.Geometry__c.trim().toLowerCase();
                                Integer intNonSplitFactor = mapInternalGuidelineFactorCS.containsKey(strKey) ? Integer.valueOf(mapInternalGuidelineFactorCS.get(strKey).NON_SPLIT_Corner_Factor__c) : 1;
                                
                                intDQDF1 = intDQDF1 * intNonSplitFactor;
                                intDQWF1 = intDQWF1 * intNonSplitFactor;
                            }
                            
                            if((c.Request_Type__c == 'Wafer Form Delivery' || c.Request_Type__c == 'Corner Split Change') && c.Status__c != null && c.Status__c.startsWith('Accepted') && m.Extra_Die_B__c != null && m.Extra_Die_B__c != 0) {
                                creqextradie = String.valueOf(m.Extra_Die_B__c.setScale(2));
                            }
                            else{
                                creqextradie =iglfMap.get(c.MPW_Prime_Die__r.Geometry__c)!=null? String.valueOf((((intDQDF1 + (intDQWF1 * 50)) * iglfMap.get(c.MPW_Prime_Die__r.Geometry__c).Wafer__c) / Integer.valueOf(cdietowaferlist[1])).setScale(2,RoundingMode.HALF_UP)):'';
                              
                            }
                            /*** End : Added By Anil ***/
                            
                            //creqextradie = String.valueOf((((Integer.valueOf(c.Delivery_Qty_Die_Form__c) + (Integer.valueOf(c.Delivery_Qty_Wafer_Form__c) * 50)) * iglfMap.get(c.MPW_Prime_Die__r.Geometry__c).Wafer__c) / Integer.valueOf(cdietowaferlist[1])).setScale(2,RoundingMode.HALF_UP));
                              /*Get PA Code Name from MPW_ERP_PA_Code__c object*/ 
                             strPACode=getPACodeDescription(mapPACodedescription,c.PA_Code__c);
                              
                            this.pcwrList.add(new primediechangerequesWrapper(String.valueOf(totalnoofdie),crect,creqdieno,creqextradie,c.MPW_Train_Name__c,c.MPW_Form__r.Customer_Name__c,c.Category__c,c.Sub_Category__c,c.Usage__c,c.MPW_Prime_Die_Name__c,cdiexsize,cdieysize,c.Delivery_Qty_Die_Form__c,c.Delivery_Qty_Wafer_Form__c,'',c.PA_Code__c,strPACode,c.Status__c,c.MPW_Form_Name__c,c.MPW_Form__c, true, c.Request_Type__c));
                        }
                    }
                }
                
                //Modified by Anil : MPW-PP121 - March 8, 2017
                if(!this.mpwedList.isEmpty()){
                    for(MPW_Extra_Die__c c: this.mpwedList){
                        if(m.Id == c.MPW_Prime_Die__c){
                            Decimal cdiexsize = 0;
                            Decimal cdieysize = 0;
                            cdiexsize = cdiexsize.setScale(3, RoundingMode.HALF_UP);
                            cdieysize = cdieysize.setScale(3, RoundingMode.HALF_UP);
                            
                            String crect = '0.00';
                            String creqdieno = '0';
                            String creqextradie = c.Extra_Die_B__c != null ? String.valueOf(c.Extra_Die_B__c.setScale(2)) : '0';
                            Decimal totalnoofdie = c.Extra_Die_Qty__c != null ? c.Extra_Die_Qty__c : 0;    
                            
                              /*Get PA Code Name from MPW_ERP_PA_Code__c object*/ 
                              strPACode=getPACodeDescription(mapPACodedescription,c.MPW_Prime_Die__r.MPW_Form__r.PA_Code__c);
                           
                            this.pcwrList.add(new primediechangerequesWrapper(String.valueOf(totalnoofdie),crect,creqdieno,creqextradie,c.MPW_Train__c,c.MPW_Prime_Die__r.MPW_Form__r.Customer_Name__c,c.MPW_Prime_Die__r.MPW_Form__r.Category__c,c.MPW_Prime_Die__r.MPW_Form__r.Category__c,c.MPW_Prime_Die__r.MPW_Form__r.Usage__c,c.Prime_Die_Name__c,cdiexsize,cdieysize,'0','0','',c.MPW_Prime_Die__r.MPW_Form__r.PA_Code__c,strPACode,'Accepted by MPW Tapeout',c.MPW_Form_Number__c,c.MPW_Prime_Die__r.MPW_Form__c, true, 'Extra Dies/Wafer Re-start'));
                        }
                    }
                }  
            }
            if(!this.pcwrList.isEmpty()){
                this.pcwrMap = paginateRecords(pcwrList);
                calculateTotal(pcwrMap.get(currentPageNo));
            }
            else{
                this.totalNoOfRecords = 0;
            }
        }
        else{
            this.totalNoOfRecords = 0;
            this.selectedVal = '10';
            this.totalNoOfPages = 0;
            this.currentPageNo = 1;
            this.noresultfound = true;
        }
    }
    
    public string getPACodeDescription(Map<String,String> mapPACodeDescription,String strPACode){
     String strPACodeDesc='';
        if(strPACode!=null && strPACode!='' && mapPACodeDescription.get(strPACode.toUppercase())!=null){
            strPACodeDesc=mapPACodeDescription.get(strPACode.toUpperCase());
        }
        
        return strPACodeDesc;
    }
    
    public Map<integer, List<primediechangerequesWrapper>> paginateRecords(List<primediechangerequesWrapper> tempList) {
        Map<integer, List<primediechangerequesWrapper>> tempMap = new Map<integer, List<primediechangerequesWrapper>>();
        integer recordsPerPage = Integer.valueOf(selectedVal);
        integer pageNo = 1;
        List<primediechangerequesWrapper> temp = new List<primediechangerequesWrapper>();
        for (primediechangerequesWrapper m : tempList) {
            if (temp.size() < recordsPerPage) {
                temp.add(m);
            } else {
                tempMap.put(pageNo, temp);
                pageNo++;
                temp = new List<primediechangerequesWrapper>();
                temp.add(m);
            }
        }
        
        if (temp.size() > 0) {
            tempMap.put(pageNo, temp);
        }
        
        // Set values
        this.totalNoOfPages = pageNo;
        if(currentPageNo > 1){
           this.currentPageNo = 1;        
        }
        this.totalNoOfRecords  = tempList.size();
       
        return tempMap;
    }
    
    public void calculateTotal(List<primediechangerequesWrapper> temp){
        this.totaldieqty = 0;
        this.totalwaferqty = 0;
        this.totaldienos = 0;
        this.totalusedreticlespace = 0;
        this.totalreqdienos = 0;
        this.totalreqextradies = 0;
        if(temp != null) {
        for(integer i=0;i<temp.size();i++){
            this.totaldieqty += Decimal.valueOf(temp[i].quantdieform);
            this.totalwaferqty += Decimal.valueOf(temp[i].quantwaferform);
            if(temp[i].noofextradies != null){
                this.totaldienos += Decimal.valueOf(temp[i].noofextradies);
            }
            if(temp[i].usedrectilespace != null){
                this.totalusedreticlespace += Decimal.valueOf(temp[i].usedrectilespace);
            }
            this.totalreqdienos += Decimal.valueOf(temp[i].requesteddieno);
            this.totalreqextradies += Decimal.valueOf(temp[i].requestedextradie);
        }
        }
    }
    
    public List<List<primediechangerequesWrapper>> getPrimeDieRecords() {
        return makeSublist(pcwrList,999);// (this.pcwrMap.size() > 0 ? this.pcwrMap.get(this.currentPageNo) : new List<primediechangerequesWrapper>());
    }
    
    //to avoid collection size issue on VF page
    public static List<List<primediechangerequesWrapper>> makeSublist(List<primediechangerequesWrapper> lstOrginalList,Integer sublislSize){
        List<List<primediechangerequesWrapper>> lstSublist=new List<List<primediechangerequesWrapper>>();
        List<primediechangerequesWrapper> lstTemlSublist=new List<primediechangerequesWrapper>();
        
        if(lstOrginalList==null){
          return null;
        }
        
        for(integer ii=0;ii<lstOrginalList.size();ii++){
            if(ii>0 && (Math.mod((ii), sublislSize))==0){
              lstSublist.add(lstTemlSublist); 
              lstTemlSublist=new List<primediechangerequesWrapper>();
            }
          
           lstTemlSublist.add(lstOrginalList.get(ii));
        }
        lstSublist.add(lstTemlSublist); 
      
      return lstSublist;  
    }
    
    public List<SelectOption> getpageList() {
        pageList = new List<SelectOption>();
        pageList.add(new SelectOption('10', '10'));
        pageList.add(new SelectOption('20', '20'));
        pageList.add(new SelectOption('30', '30'));
        
        return pageList;
    }
    
    // Pagination Controls
    public boolean getHasPrevious() {
        return (this.currentPageNo > 1 ? true : false);
    }
    
    public boolean getHasNext() {
        return (this.currentPageNo < this.totalNoOfPages ? true : false);
    }
    
    public void previous() {
        this.currentPageNo--;
        calculateTotal(pcwrMap.get(currentPageNo));
        
    }
    
    public void next() {
        this.currentPageNo++;
        calculateTotal(pcwrMap.get(currentPageNo));
    }
    
    public void first() {
        this.currentPageNo = 1; 
        calculateTotal(pcwrMap.get(currentPageNo));
    }
    
    public void last() {
        this.currentPageNo = this.totalNoOfPages;  
        calculateTotal(pcwrMap.get(currentPageNo));
    }
    
    //export to csv
    public PageReference exportCsvFile() {
        this.listDetails = new List<List<string>>();
        createCsvFile();
        return new PageReference('/apex/InternalChargeOutReportToCsvVF');
    }
    
    public void createCsvFile(){
    searchMethod();
        List<string> headers = new List<string>();
        headers.add('MPW#,Customer Name,Cat.,Sub-Cat.,Usage,Prime Die,X Size(mm),Y Size(mm),Quantity Die Form,Quantity Wafer Form,# of Extra dies,Used Reticle Space($),Requested # of Dies($),Requested Extra dies($),Bare Die Ship Date,PA Code,PA Code Name,Form Status,Change Request Status,Change Request Type,Form Number\n');
        this.listDetails.add(headers);
        String details = '';
        List<string> tempList = new List<string>();
        for(primediechangerequesWrapper p: pcwrList){
            String x = String.valueOf(p.xsize);
            String y = String.valueOf(p.ysize);
            details = (p.mpwno != null ? p.mpwno : '')+','+
                      (p.customername != null ? p.customername : '')+','+
                      (p.cat != null ? p.cat : '')+','+
                      (p.subcat != null ? p.subcat : '')+','+
                      (p.usage != null ? p.usage : '')+','+
                      (p.primediename != null ? p.primediename : '')+','+
                      (x != null ? x : '')+','+
                      (y != null ? y : '')+','+
                      (p.quantdieform != null ? p.quantdieform : '')+','+
                      (p.quantwaferform != null ? p.quantwaferform : '')+','+
                      (p.noofextradies != null ? p.noofextradies : '')+','+
                      (p.usedrectilespace != null ? p.usedrectilespace : '')+','+
                      (p.requesteddieno != null ? p.requesteddieno : '')+','+
                      (p.requestedextradie != null ? p.requestedextradie : '')+','+
                      (p.baredieshipdate != null ? '"' + p.baredieshipdate + '"': '')+','+
                      (p.pacode != null ? p.pacode : '')+','+
                      (p.pacodedetail != null ? p.pacodedetail : '')+','+
                      (p.formstatus != null && !p.isChangeRequest ? p.formstatus : '')+','+
                      (p.formstatus != null && p.isChangeRequest ? p.formstatus : '')+','+
                      (p.changeRequestType != null ? p.changeRequestType : '')+','+
                      (p.formno != null ? p.formno : '')+','+
                      '\n';
            if (tempList.size() < 1000) {
                tempList.add(details);
            }
            else {
                this.listDetails.add(tempList); 
                tempList = new List<string>();
            }
        }   
        if (tempList.size() > 0) {
            this.listDetails.add(tempList);
        }
    }
    
    public class primediechangerequesWrapper{
        public String expeditedieform{get;set;}
        public String expeditewaferform{get;set;}
        public String geometryid{get;set;}
        public String mpwno{get;set;}
        public String customername{get;set;}
        public String cat{get;set;}
        public String subcat{get;set;}
        public String usage{get;set;}
        public String primediename{get;set;}
        public Decimal xsize{get;set;}
        public Decimal ysize{get;set;}
        public String quantdieform{get;set;}
        public String quantwaferform{get;set;}
        public String noofextradies{get;set;}
        public String usedrectilespace{get;set;}
        public String requesteddieno{get;set;}
        public String requestedextradie{get;set;}
        public String baredieshipdate{get;set;}
        public String pacode{get;set;}
        public String pacodedetail{get;set;}
        public String formstatus{get;set;}
        public String formno{get;set;}
        public String formid{get;set;}
        public Boolean isChangeRequest{get;set;}
        public String changeRequestType{get;set;}
        
        public primediechangerequesWrapper(String ned, String rectile, String reqdno, String reqexdie, String mno, String custname, String cate, String subc, String us, String pdname, Decimal x, Decimal y, String qdf, String qwf, String dshdate, String pcode,string pacodedetail, String fstatus, String fno, String fid, Boolean isCR, String crType){
            this.noofextradies = ned;
            this.usedrectilespace = rectile;
            this.requesteddieno = reqdno;
            this.requestedextradie = reqexdie;
            this.mpwno = mno;
            this.customername = custname;
            this.cat = cate;
            this.subcat = subc;
            this.usage = us;
            this.primediename = pdname;
            this.xsize = x;
            this.ysize = y;
            this.quantdieform = qdf;
            this.quantwaferform = qwf;
            this.baredieshipdate = dshdate;
            this.pacode = pcode;
            this.pacodedetail=pacodedetail;
            this.formstatus = fstatus;
            this.formno = fno;
            this.formid = fid;
            this.isChangeRequest = isCR;
            this.changeRequestType = crType;
        }
    }

}