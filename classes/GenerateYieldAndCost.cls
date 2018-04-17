/*
    Author: Ariz Solito
    Description: Apex class logic for generating quarter year yields and costs for configurations 
    History: 
        Asolito     05272016    - Code creation.                                   
*/
public class GenerateYieldAndCost {
    public static Boolean hasRun = false;
    //static PCM_Administration__c pcmAdminSetting = PCM_Administration__c.getInstance('CURRENT_SETTING'); 
    static map<String,Config_Quarterly_Volume__c> mpYearQuarterQuarterVol = new map<String,Config_Quarterly_Volume__c>();
    
    @future
    public static void generate(ID configID){
        ConfigDetail config;       
        hasRun = true;
        
        //get the configuration details
        for(Apttus_Proposal__Proposal__c a: [SELECT id,fab_name__c, mask_set_long__c,process_technology__c,relgrade__c,
                                                    product_type__c,wafer_size__c,Business_unit__c,APTPS_Metal_Options__c,
                                                    Actual_Tapeout_Date_FAB_9_and_FAB_10__c,Deliverable_Part_Type__c,                                                    
                                                    (SELECT Id,BLM_Size_Type__c,Bonding__c,Configuration__c,Minimum_C4_Pitch__c,Solder__c,Solder_Type__c,
                                                            fab__c,Minimum_Kerf__c,Kerf_X__c,Kerf_Y__c,package_technology__c,
                                                            Reliability_Platform__c,Reliability_Location__c,test_location__c,Number_of_Socket_Per_Boards__c
                                                            ,method__c,Test_Time_Method__c,Module_Test_Time_Method__c,Module_Number_of_DUTS__c
                                                            ,Circuit_Limited_Yield_CLY__c, Design_for_Profit_DFP__c
                                                            ,User_Defined_Time__c,Module_User_Defined_Time__c
                                                       FROM Config_Post_Fab_Services__r)
                                               FROM Apttus_Proposal__Proposal__c 
                                               WHERE id = :configID]){  
            config = new ConfigDetail(a);
        }
        
        Apttus_Config2__ProductConfiguration__c pc=new Apttus_Config2__ProductConfiguration__c();
        
        if(!Test.isRunningTest()){
            pc = [select id,createddate from Apttus_Config2__ProductConfiguration__c
                                                      where Apttus_QPConfig__Proposald__c = :configID
                                                      order by createddate desc limit 1]; 
        }else{
            //pc = new Apttus_Config2__ProductConfiguration__c(); 
            pc.Apttus_QPConfig__Proposald__c = configId;
            insert pc; 
        }
        
        //get the proposal product attribute value records from the proposal line item
        for(Apttus_Config2__LineItem__c lineItem : [select   Apttus_Config2__AttributeValueId__r.Die_Size_X_mm__c
                                                             , Apttus_Config2__AttributeValueId__r.Die_Size_Y_mm__c 
                                                    from     Apttus_Config2__LineItem__c
                                                    where    Apttus_Config2__OptionId__c = null
                                                    and      Apttus_Config2__ConfigurationId__c = :pc.id
                                                    limit 1]){
            config.addAttributeValues(lineItem);    
        }
        
        for(Config_Post_Fab_Services__c c: [SELECT id,BLM_Size_Type__c,bonding__c,minimum_C4_pitch__c,solder__c,solder_type__c,Number_of_DUTS__c,
                                                   circuit_limited_yield_CLY__c,design_for_profit_DFP__c,fab__c,test_location__c,
                                                   test_platform__c,package_technology__c,body_length__c,body_width__c,subst_layer__c,
                                                   subst_IO_pitch__c,line_width__c,subst_material__c,package_IO_pitch__c,package_IO__c,
                                                   wire_material_for_WB__c,encapsulation__c,reliability_platform__c,reliability_location__c,Number_of_Socket_Per_Boards__c,
                                                   Kerf_X__c,Kerf_Y__c,module_test_platform__c,module_test_location__c,method__c,Module_Number_of_DUTS__c,
                                                   Test_Time_Method__c,Module_Test_Time_Method__c,package_tech_method__c,
                                                   Burn_in_Stress_Yield_Method__c,Module_Test_Yield_Method__c,User_Defined_Time__c,Module_User_Defined_Time__c
                                                   ,capacitor_type__c,Capacitor_Qty__c,PF_Desc__c, PF_Number__c, PF_Stat__c, Revision__c,
                                                   (SELECT available_redundancy__c,count__c,quarter__c,year__c,circuit_group__c,
                                                          circuit_type__c,Burn_in_duration__c,recordtype.name,method__c
                                                          ,Bond_Assembly_Yield_by_Time_Period__c,User_Defined_Yield_BI__c,User_Defined_Yield_Module__c
                                                      FROM Config_Post_Fab_Service_Detail__r)
                                              FROM Config_Post_Fab_Services__c 
                                              WHERE configuration__c = :config.configID]){
            config.addPostFabService(c);                                             
        }
        
        for(PFile_Data__c pfd : [select    id, PF_Desc__c, PF_Number__c, PF_Stat__c, Revision__c,
                                           (select Circuit_Group__c, Circuit_Type__c, Circuit_Unit__c, Count__c, recordtype.name
                                           , QTR1__c, QTR2__c, QTR3__c, QTR4__c, QTR5__c, QTR6__c, QTR7__c, QTR8__c, QTR9__c, QTR10__c
                                           , QTR11__c, QTR12__c, QTR13__c, QTR14__c, QTR15__c, QTR16__c, QTR17__c, QTR18__c, QTR19__c
                                           , QTR20__c, QTR21__c, QTR22__c, QTR23__c, QTR24__c, Redundancy__c, Yield_Type__c 
                                           from PFile_Yields__r)
                                 from      PFile_Data__c
                                 where     PF_Desc__c = :config.postFabService.PF_Desc__c
                                 and       PF_Number__c = :(config.postFabService.PF_Number__c!=null)?Decimal.valueOf(config.postFabService.PF_Number__c):null
                                 and       PF_Stat__c = :config.postFabService.PF_Stat__c
                                 and       Revision__c = :(config.postFabService.Revision__c!=null)?Decimal.valueOf(config.postFabService.Revision__c):null
                                ]){
            config.addpfileData(pfd);        
        }                                             
                 
        //get the year from the quarterly volume
        for(Config_Quarterly_Volume__c c: [SELECT year__c,Q1_Volume__c,Q2_Volume__c,Q3_Volume__c,Q4_Volume__c
                                             FROM Config_Quarterly_Volume__c
                                             WHERE quote_proposal__c = :configID]){
            config.addQuarterlyVolumes(c);                                    
            config.addYears(String.valueOf(c.year__c));        
            mpYearQuarterQuarterVol.put(String.valueOf(c.year__c),c);                                     
        }
        
        //generate the yields calculation
        Map<String,YieldHeader> yieldHeaderMap = GenerateYield.generate(config);
        
        //generate the costs calculation
        Map<String,GenerateCost.CostHeader> costHeaderMap = GenerateCost.generate(yieldHeaderMap,config); 
        
        //insert the yields and costs calculation to to Configurator Yield
        //and Configurator Cost records
        populateYieldAndCostRecords(config,yieldHeaderMap,costHeaderMap);            
    }        
    
    //Method will insert the quarter year yield and cost calculations
    public static void populateYieldAndCostRecords(ConfigDetail config, Map<String,YieldHeader> yieldHeaderMap, 
                                                   Map<String,GenerateCost.CostHeader> costHeaderMap){
         String thisYear = String.valueOf(config.productionDate.year());
          String thisQuarter ;
           set<String> stValidQuarterThisYear = new set<String>(); 
            integer month = config.productionDate.month();
            if(month >= 1 && month <=3) {
              thisQuarter = 'Q1';
              stValidQuarterThisYear = new  set<String>{'Q1','Q2','Q3','Q4'};
            }
            if(month >= 4 && month <=6) {
              thisQuarter = 'Q2';
              stValidQuarterThisYear = new  set<String>{'Q2','Q3','Q4'};
            }
            if(month >= 7 && month <=9) {
              thisQuarter = 'Q3';
              stValidQuarterThisYear = new  set<String>{'Q3','Q4'};
            }
            if(month >= 10 && month <=12) {
              thisQuarter = 'Q4';
              stValidQuarterThisYear = new  set<String>{'Q4'};
            }
           
                                                    
        //check if config has existing yield and cost records
        //if Yes - delete all
        try {
            List<Configurator_Yield__c> yields = [SELECT id 
                                                    FROM Configurator_Yield__c 
                                                    WHERE quote_proposal__c = :config.configID];                                                    
            delete yields;                                                    
            
            List<Configurator_Cost__c> costs = [SELECT id 
                                                    FROM Configurator_Cost__c 
                                                    WHERE quote_proposal__c = :config.configID];
            delete costs;                                  
        } catch (Exception e){}
        
        //populate yield records
        List<Configurator_Yield__c> yields = new List<Configurator_Yield__c>();
        for(String key: yieldHeaderMap.keySet()){
            YieldHeader yHead = yieldHeaderMap.get(key);
            if(yHead.year == thisYear) {
              if(stValidQuarterThisYear.contains(yHead.quarter)) {
                yields.add(yieldHeaderMap.get(key).generateRecord());
              }
            }
            else {
              yields.add(yieldHeaderMap.get(key).generateRecord());
            }
        }
        
        //populate cost records
        List<Configurator_Cost__c> costs = new List<Configurator_Cost__c>();
        for(String key: costHeaderMap.keySet()){
            GenerateCost.CostHeader cost =  costHeaderMap.get(key);
            Config_Quarterly_Volume__c configQuarter;
            if(mpYearQuarterQuarterVol.containsKey(cost.year)) {
              configQuarter = mpYearQuarterQuarterVol.get(cost.year);
            }
            if(cost.year == thisYear) {
              if(stValidQuarterThisYear.contains(cost.quarter)) {
                Configurator_Cost__c tempCost = costHeaderMap.get(key).generateRecord();
                if(configQuarter != NULL) {
                  if(tempCost.quarter__c == 'Q1') {tempCost.volume__c = configQuarter.Q1_Volume__c;}
                  if(tempCost.quarter__c == 'Q2') {tempCost.volume__c = configQuarter.Q2_Volume__c;}
                  if(tempCost.quarter__c == 'Q3') {tempCost.volume__c = configQuarter.Q3_Volume__c;}
                  if(tempCost.quarter__c == 'Q4') {tempCost.volume__c = configQuarter.Q4_Volume__c;} 
                }
                costs.add(tempCost);
              }
            }
            else {
              Configurator_Cost__c tempCost = costHeaderMap.get(key).generateRecord();
               if(configQuarter != NULL) {
                  if(tempCost.quarter__c == 'Q1') {tempCost.volume__c = configQuarter.Q1_Volume__c;}
                  if(tempCost.quarter__c == 'Q2') {tempCost.volume__c = configQuarter.Q2_Volume__c;}
                  if(tempCost.quarter__c == 'Q3') {tempCost.volume__c = configQuarter.Q3_Volume__c;}
                  if(tempCost.quarter__c == 'Q4') {tempCost.volume__c = configQuarter.Q4_Volume__c;} 
                }   
              costs.add(tempCost);
            }     
        }
        
        try {
            insert yields;
            insert costs;
            
            //populate cost details
            //populate cost records
            List<Configurator_Cost_Detail__c> costDetails = new List<Configurator_Cost_Detail__c>();
            for(String key: costHeaderMap.keySet()){
                GenerateCost.CostHeader cost =  costHeaderMap.get(key);
                if(cost.year == thisYear) { 
                  if(stValidQuarterThisYear.contains(cost.quarter)) {
                     costDetails.addAll(costHeaderMap.get(key).generateCostDetails());
                  }
                }else {
                  costDetails.addAll(costHeaderMap.get(key).generateCostDetails());
                }                
            }
            
            insert costDetails;
            
            //calculate the cost totals
            List<Configurator_Cost__c> calculatedTotalCosts = GenerateCost.computeCosts(yields,config);
            update calculatedTotalCosts;
            
        } catch(Exception e){
           ApplicationLogWrapper alw=new ApplicationLogWrapper();
            alw.source = GenerateYieldAndCost.class.getName();
            alw.sourceFunction ='populateYieldAndCostRecords()';
            alw.ApplicationName='CPQ';
            alw.referenceId = config.configID;
            alw.referenceInfo='Bug';
            alw.logMessage ='Error Message='+e.getMessage()+' At Line Number='+e.getLineNumber()+' Stack Trace='+e.getStackTraceString();
            alw.debugLevel ='Error';
            alw.logCode =e.getTypeName();
            alw.ex=e.getCause();
            GlobalUtility.logMessage(alw);
        }
    }
    
    //Yield header wrapper class
    public class YieldHeader {
        public String headerKey;
        public String year;
        public String quarter;
        public Decimal FEOLYield;
        public Decimal BEOLPREYield;
        public Decimal BEOLPOSTYield;
        public Decimal WaferTestYield;
        public Decimal cpwVal;
        public Decimal capReqVal;
        public Decimal lyhVal;
        public Decimal gcpw;
        public Decimal baVal;
        public Decimal biYld;
        public Decimal biCapReq; 
        public Decimal modYld;
        public Decimal modTstCapReq;
        public Decimal kerfX;       
        public Decimal kerfY;
        private ConfigDetail config;
        
        public YieldHeader(ConfigDetail config, PCM_Yield__c yield){
            this.headerKey = yield.year__c + yield.quarter__c;
            this.year = yield.year__c;
            this.quarter = yield.quarter__c;
            this.config = config;
            this.biYld = 1;            
        }
        
        public YieldHeader(ConfigDetail config, String yearWafer, String quarterWafer,Decimal WaferTestYield){
            this.headerKey = yearWafer + quarterWafer;
            this.year = yearWafer;
            this.quarter = quarterWafer;
            this.WaferTestYield = WaferTestYield;
            this.config = config;   
            this.biYld = 1;         
        }
        
        //Method will generate the PCM cost record
        public Configurator_Yield__c generateRecord(){
            Configurator_Yield__c y = new Configurator_Yield__c(
                quote_proposal__c = this.config.configID,
                FEOL_yield__c = this.FEOLYield,
                BEOL_PRE_yield__c = this.BEOLPREYield,
                BEOL_POST_yield__c = this.BEOLPOSTYield,
                Wafer_Test_Yield__c = this.WaferTestYield,
                CPW__c = this.cpwVal,
                Wafer_Test_CAP_REQ__c = this.capReqVal,
                LYH__c = this.lyhVal,
                GCPW__c = this.gcpw,
                BA__c = this.baVal,
                BI__c = this.biYld,
                Module_Test_Yield__c = this.modYld,
                BI_CAP_REQ__c = this.biCapReq,
                Module_Test_CAP_REQ__c = this.modTstCapReq,
                KERF_X__c = this.kerfX,
                KERF_Y__c = this.kerfY,
                year__c = this.year,
                quarter__c = this.quarter
            );
            return y;
        }
        
        //Method will add Yield values to the header
        public void addYieldValue(PCM_Yield__c y){   
            if(y.recordType.name == 'FEOL'){                
                this.FEOLYield = y.yield__c;
            } else if(y.recordType.name == 'BEOL PRE'){                
                this.BEOLPREYield = y.yield__c;
            } else if(y.recordType.name == 'BEOL POST'){                
                this.BEOLPOSTYield = y.yield__c;
            }         
        }
        
        //Method will add Yield values to the header
        public void addWaferTestYield(Decimal waferTestYield){
            this.WaferTestYield = waferTestYield;
        }
        
        //Method will add CPW values to the header
        public void addCPWValue(Decimal cpwVal){
            this.cpwVal= cpwVal;
        }
        
        //Method to add Wafer Test CAP Req
        public void addWaferTestCAPReq(Decimal capReqVal){
            this.capReqVal= capReqVal;
        }
        
        //Method to add LYH value 
        public void addLYH(Decimal lyhVal){
            this.lyhVal= lyhVal;
        }
        
        //Method to add GCPW value
        public void addGCPW(Decimal gcpw){
            this.gcpw = gcpw;
        }
        
        //Method to add BA value
        public void addBA(Decimal baVal){
            this.baVal= baVal;
        }
        
        //Method to add Burn-in Yield
        public void addBIYld(Decimal biYld){
            this.biYld= biYld;
        }
        
        //Method to add Burn-in Cap Req
        public void addBICapReq(Decimal biCapReq){
            this.biCapReq= biCapReq;
        }
                
        //Method to add Module Test Yield
        public void addModYld(Decimal modYld){
            this.modYld= modYld;
        }
        
        //Method to add Module Test CAP Req
        public void addModTestCapReq(Decimal modTstCapReq){
            this.modTstCapReq= modTstCapReq;
        }
        
        //Method to add KerfX
        public void addKerfXValue(Decimal kerfX){
            this.kerfX= kerfX;
        }
        
        //Method to add KerfY
        public void addKerfYValue(Decimal kerfY){
            this.kerfY= kerfY;
        }
    }        
    
    //Configuration wrapper class   
    public class ConfigDetail {
        public String configID;
        public String businessUnit;
        public String productType;
        public String fab;
        public String PTNumber;
        public String bonding;
        public Integer metalLayers;
        public Date productionDate;
        public List<String> years;
        public List<PostFabService> postFabServices;
        public Set<String> masks;
        public Decimal waferSize;
        public Config_Post_Fab_Services__c postFabService;
        public List<Config_Quarterly_Volume__c> quarterlyVolumes;
        public Decimal chipX;
        public Decimal chipY;
        public String relgrade;
        public PFile_Data__c pfd;
        public String deliverableType;
        
        public ConfigDetail(Apttus_Proposal__Proposal__c c){    
            this.postFabService = new Config_Post_Fab_Services__c(); 
            this.quarterlyVolumes = new List<Config_Quarterly_Volume__c>(); 
            this.years = new List<String>();
            this.postFabServices = new List<PostFabService>();
            this.pfd = new PFile_Data__c();
                          
            this.configID = c.id;            
            this.fab = c.fab_name__c;
            this.relgrade = c.relgrade__c;                        
            this.productionDate = c.Actual_Tapeout_Date_FAB_9_and_FAB_10__c;    
                        
            this.PTNumber= c.process_technology__c;
            this.businessUnit = c.business_unit__c;
            this.productType = c.product_type__c;            
            this.waferSize = c.wafer_size__c;
            this.deliverableType = c.Deliverable_Part_Type__c;
            
            if(UtilsString.isNotBlank(c.APTPS_Metal_Options__c)){
                this.metalLayers = Integer.valueOf(c.APTPS_Metal_Options__c.substring(0,2).replaceAll('[^0-9]',''));
            }
            
           
            this.masks = new Set<String>();            
            if(UtilsString.isNotBlank(c.mask_set_long__c)){
                this.masks.addAll(c.mask_set_long__c.split('\\s+'));
            }
            
            for(Config_Post_Fab_Services__c postFab : c.Config_Post_Fab_Services__r) {
              PostFabService fab = new PostFabService(postFab);
              this.postFabServices.add(fab);
            }                    
        }
        
        public void addAttributeValues(Apttus_Config2__LineItem__c lineItem){        
            this.chipX = lineItem.Apttus_Config2__AttributeValueId__r.Die_Size_X_mm__c;
            this.chipY = lineItem.Apttus_Config2__AttributeValueId__r.Die_Size_Y_mm__c;     
        }
        
        public void addQuarterlyVolumes(Config_Quarterly_Volume__c c){
            this.quarterlyVolumes.add(c);            
        }
        
        public void addYears(String year){
            this.years.add(year);
        }
        
        public void addPostFabService(Config_Post_Fab_Services__c postFabService){
            this.postFabService = postFabService;
        }
        
        public void addpfileData(PFile_Data__c pfd){
            this.pfd = pfd;
        }
    } 
    
    //Post Fab Services Wrapper
    public class PostFabService {
        public String bonding;
        public String BLMSizeType;
        public String minC4Pitch;
        public String solder;
        public String solderType;
        public String minimumKerf;
        public Decimal kerfX;
        public Decimal kerfY;
        public String method;        
        public List<Config_Post_Fab_Service_Detail__c> configPostFabDetails;
        
        public PostFabService(Config_Post_Fab_Services__c c){
            this.bonding = c.bonding__c;
            this.BLMSizeType = c.BLM_size_type__c;
            this.minC4Pitch = c.minimum_C4_pitch__c;
            this.solder = c.solder__c;
            this.solderType = c.solder_type__c;
            this.minimumKerf = c.minimum_kerf__c;
            this.kerfX = c.Kerf_X__c;
            this.kerfY = c.Kerf_Y__c; 
            this.method = c.Method__c;           
            this.configPostFabDetails = c.Config_Post_Fab_Service_Detail__r;
        }
    }
       
}