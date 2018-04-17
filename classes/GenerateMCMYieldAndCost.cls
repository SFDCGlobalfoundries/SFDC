public class GenerateMCMYieldAndCost {
    
    static PCM_Administration__c pcmAdminSetting = PCM_Administration__c.getInstance('CURRENT_SETTING');
    static Set<String> mcmQtrSet = new Set<String>();
    public String mcmID;
    public  static  List<MCM_Reporting_Data__c> insertQtr = new List<MCM_Reporting_Data__c>();
    public static MCM_Reporting_Data__c qtrData;
    public List<MCM_Quarterly_Volume__c> quarterlyVolumes;
    public static List<MCM_Yields__c> tempYld  {get;set;}
    public static Boolean hasRun = false;
    public static integer qtrCount;
    static map<Integer,String> mpYearQuarterQuarterVol = new map<integer, String>();
    static map<String,Decimal> mpQuarterYield = new map<String,Decimal>();
    static map<String,Decimal> mpQuarterBurnIn = new map<String,Decimal>();
    static map<String,Decimal> mpModTestYldResult {get;set;}
    static map<String,Decimal> mpBIYldResult {get;set;}
    static integer month {get;set;}
    static integer startYear {get;set;}
      static integer tempYear {get;set;}
     static integer tempQuarter {get;set;}
    static integer startQuarter {get;set;}
    static String packageTechnology='Custom-MCM';
    static PCM_Cost__c cost {get;set;}
    
    public static void generate(ID mcmID){
        McmDetail mcm;       
        hasRun = true;
        tempYld = new List<MCM_Yields__c>();
        qtrCount =0;
        mpModTestYldResult = new map<String,Decimal>();
        mpBIYldResult = new map<String,Decimal>();
        //get the configuration details
        for(PCM_MCM_Detail__c a: [SELECT  Id,Test_Platform__c,No_of_DUTS__c,User_Defined_Time__c,Device__c,Actual_Tapeout_Date_FAB_9_and_FAB_10__c,
                                  Actual_Tapeout_Date__c,Burn_In_Platform__c,Number_of_Sockets_Per_Boards__c,Fab__c     
                                  FROM PCM_MCM_Detail__c 
                                  WHERE id = :mcmID]){  
                                      mcm = new McmDetail(a);
                                  }
        
        
        
    
        
        //get the year from the quarterly volume
        for(MCM_Quarterly_Volume__c c: [SELECT year__c,Q1_Volume__c,Q2_Volume__c,Q3_Volume__c,Q4_Volume__c
                                        FROM MCM_Quarterly_Volume__c
                                        WHERE PCM_MCM_Detail__c = :mcmID]){
                                            mcm.addQuarterlyVolumes(c);                                    
                                            mcm.addYears(String.valueOf(c.year__c));        
                                         
                                            
                                            
                                            if(c.Q1_Volume__c!=null){
                                                mcmQtrSet.add(c.Year__c+'_Q1');
                                                qtrCount++;
                                                qtrData = new MCM_Reporting_Data__c();
                                                qtrData.Ship_Quantity__c =c.Q1_Volume__c;
                                                qtrData.Year__c = String.valueof(c.Year__c);
                                                qtrData.Quarter__c = 'Q1';
                                                qtrData.Cost_Type__c ='MCM Quarterly Volume';
                                                qtrData.MCM__c =mcmID;
                                                insertQtr.add(qtrData);
                                                
                                                 //using this to map Yield Quarter number with Year
                                            mpYearQuarterQuarterVol.put(qtrCount,String.valueOf(c.year__c));      
                                            }
                                            if(c.Q2_Volume__c!=null){
                                                mcmQtrSet.add(c.Year__c+'_Q2');
                                                qtrCount++;
                                                qtrData = new MCM_Reporting_Data__c();
                                                  qtrData.Ship_Quantity__c =c.Q2_Volume__c;
                                                qtrData.Year__c = String.valueof(c.Year__c);
                                                qtrData.Quarter__c = 'Q2';
                                                qtrData.Cost_Type__c ='MCM Quarterly Volume';
                                                qtrData.MCM__c =mcmID;
                                                insertQtr.add(qtrData);
                                                 //using this to map Yield Quarter number with Year
                                            mpYearQuarterQuarterVol.put(qtrCount,String.valueOf(c.year__c));      
                                            }
                                            if(c.Q3_Volume__c!=null){
                                                mcmQtrSet.add(c.Year__c+'_Q3');
                                                qtrCount++;
                                                qtrData = new MCM_Reporting_Data__c();
                                                  qtrData.Ship_Quantity__c =c.Q3_Volume__c;
                                                qtrData.Year__c = String.valueof(c.Year__c);
                                                qtrData.Quarter__c = 'Q3';
                                                qtrData.Cost_Type__c ='MCM Quarterly Volume';
                                                qtrData.MCM__c =mcmID;
                                                insertQtr.add(qtrData);
                                                 //using this to map Yield Quarter number with Year
                                            mpYearQuarterQuarterVol.put(qtrCount,String.valueOf(c.year__c));      
                                            }
                                            if(c.Q4_Volume__c!=null){
                                                mcmQtrSet.add(c.Year__c+'_Q4');
                                                qtrCount++;
                                                qtrData = new MCM_Reporting_Data__c();
                                                qtrData.Ship_Quantity__c =c.Q4_Volume__c;
                                                qtrData.Year__c = String.valueof(c.Year__c);
                                                qtrData.Quarter__c = 'Q4';
                                                qtrData.Cost_Type__c ='MCM Quarterly Volume';
                                                qtrData.MCM__c =mcmID;
                                                insertQtr.add(qtrData);
                                                
                                                 //using this to map Yield Quarter number with Year
                                            mpYearQuarterQuarterVol.put(qtrCount,String.valueOf(c.year__c));      
                                            }            
                                        }     
  
        
        //  Get quarterly Yields from MCM_Yields__C 
        String query = 'SELECT ';
        for(Schema.FieldSetMember f : SObjectType.MCM_Yields__c.FieldSets.Quarter.getFields()) {
            query += f.getFieldPath() + ', ';
        }
        query += 'recordtype.name FROM MCM_Yields__c Where MCM__c =:mcmId';
        
        
        for (MCM_Yields__C c: Database.query(query) ){
            mcm.addQuarterlyYields(c);  
            if(c.Q1__c!=null)  mpQuarterYield.put(c.recordtype.name +'-Q1', c.Q1__c);  else  continue;
            if(c.Q2__c!=null)  mpQuarterYield.put(c.recordtype.name +'-Q2', c.Q2__c);  else  continue;
            if(c.Q3__c!=null)  mpQuarterYield.put(c.recordtype.name +'-Q3', c.Q3__c);  else  continue;
            if(c.Q4__c!=null)  mpQuarterYield.put(c.recordtype.name +'-Q4', c.Q4__c);  else  continue;
            if(c.Q5__c!=null)  mpQuarterYield.put(c.recordtype.name +'-Q5', c.Q5__c);  else  continue;
            if(c.Q6__c!=null)  mpQuarterYield.put(c.recordtype.name +'-Q6', c.Q6__c);  else  continue;
            if(c.Q7__c!=null)  mpQuarterYield.put(c.recordtype.name +'-Q7', c.Q7__c);  else  continue;
            if(c.Q8__c!=null)  mpQuarterYield.put(c.recordtype.name +'-Q8', c.Q8__c);  else  continue;
            if(c.Q9__c!=null)  mpQuarterYield.put(c.recordtype.name +'-Q9', c.Q9__c);  else  continue;
            if(c.Q10__c!=null)  mpQuarterYield.put(c.recordtype.name +'-Q10', c.Q10__c);  else  continue;
            if(c.Q11__c!=null)  mpQuarterYield.put(c.recordtype.name +'-Q11', c.Q11__c);  else  continue;
            if(c.Q12__c!=null)  mpQuarterYield.put(c.recordtype.name +'-Q12', c.Q12__c);  else  continue;
            if(c.Q13__c!=null)  mpQuarterYield.put(c.recordtype.name +'-Q13', c.Q13__c);  else  continue;
            if(c.Q14__c!=null)  mpQuarterYield.put(c.recordtype.name +'-Q14', c.Q14__c);  else  continue;
            if(c.Q15__c!=null)  mpQuarterYield.put(c.recordtype.name +'-Q15', c.Q15__c);  else  continue;
            if(c.Q16__c!=null)  mpQuarterYield.put(c.recordtype.name +'-Q16', c.Q16__c);  else  continue;
            if(c.Q17__c!=null)  mpQuarterYield.put(c.recordtype.name +'-Q17', c.Q17__c);  else  continue;
            if(c.Q18__c!=null)  mpQuarterYield.put(c.recordtype.name +'-Q18', c.Q18__c);  else  continue;
            if(c.Q19__c!=null)  mpQuarterYield.put(c.recordtype.name +'-Q19', c.Q19__c);  else  continue;
            if(c.Q20__c!=null)  mpQuarterYield.put(c.recordtype.name +'-Q20', c.Q20__c);  else  continue;
            if(c.Q21__c!=null)  mpQuarterYield.put(c.recordtype.name +'-Q21', c.Q21__c);  else  continue;
            if(c.Q22__c!=null)  mpQuarterYield.put(c.recordtype.name +'-Q22', c.Q22__c);  else  continue;
            if(c.Q23__c!=null)  mpQuarterYield.put(c.recordtype.name +'-Q23', c.Q23__c);  else  continue;
            if(c.Q24__c!=null)  mpQuarterYield.put(c.recordtype.name +'-Q24', c.Q24__c);  else  continue;
               
        }
        
        //  Get quarterly BurnIn Duration from MCM_BurnIn_Duration__C
        String query1 = 'SELECT ';
        for(Schema.FieldSetMember f : SObjectType.MCM_BurnIn_Duration__c.FieldSets.QuarterDuration.getFields()) {
            query1 += f.getFieldPath() + ', ';
        }
        query1 += 'recordtype.name FROM MCM_BurnIn_Duration__c Where MCM__c =:mcmId';
        
        
        for (MCM_BurnIn_Duration__c c: Database.query(query1) ){
            mcm.addQuarterlyBurnIn(c);  
            if(c.Q1__c!=null)  mpQuarterBurnIn.put(c.recordtype.name +'-Q1', c.Q1__c);  else  continue;
            if(c.Q2__c!=null)  mpQuarterBurnIn.put(c.recordtype.name +'-Q2', c.Q2__c);  else  continue;
            if(c.Q3__c!=null)  mpQuarterBurnIn.put(c.recordtype.name +'-Q3', c.Q3__c);  else  continue;
            if(c.Q4__c!=null)  mpQuarterBurnIn.put(c.recordtype.name +'-Q4', c.Q4__c);  else  continue;
            if(c.Q5__c!=null)  mpQuarterBurnIn.put(c.recordtype.name +'-Q5', c.Q5__c);  else  continue;
            if(c.Q6__c!=null)  mpQuarterBurnIn.put(c.recordtype.name +'-Q6', c.Q6__c);  else  continue;
            if(c.Q7__c!=null)  mpQuarterBurnIn.put(c.recordtype.name +'-Q7', c.Q7__c);  else  continue;
            if(c.Q8__c!=null)  mpQuarterBurnIn.put(c.recordtype.name +'-Q8', c.Q8__c);  else  continue;
            if(c.Q9__c!=null)  mpQuarterBurnIn.put(c.recordtype.name +'-Q9', c.Q9__c);  else  continue;
            if(c.Q10__c!=null)  mpQuarterBurnIn.put(c.recordtype.name +'-Q10', c.Q10__c);  else  continue;
            if(c.Q11__c!=null)  mpQuarterBurnIn.put(c.recordtype.name +'-Q11', c.Q11__c);  else  continue;
            if(c.Q12__c!=null)  mpQuarterBurnIn.put(c.recordtype.name +'-Q12', c.Q12__c);  else  continue;
            if(c.Q13__c!=null)  mpQuarterBurnIn.put(c.recordtype.name +'-Q13', c.Q13__c);  else  continue;
            if(c.Q14__c!=null)  mpQuarterBurnIn.put(c.recordtype.name +'-Q14', c.Q14__c);  else  continue;
            if(c.Q15__c!=null)  mpQuarterBurnIn.put(c.recordtype.name +'-Q15', c.Q15__c);  else  continue;
            if(c.Q16__c!=null)  mpQuarterBurnIn.put(c.recordtype.name +'-Q16', c.Q16__c);  else  continue;
            if(c.Q17__c!=null)  mpQuarterBurnIn.put(c.recordtype.name +'-Q17', c.Q17__c);  else  continue;
            if(c.Q18__c!=null)  mpQuarterBurnIn.put(c.recordtype.name +'-Q18', c.Q18__c);  else  continue;
            if(c.Q19__c!=null)  mpQuarterBurnIn.put(c.recordtype.name +'-Q19', c.Q19__c);  else  continue;
            if(c.Q20__c!=null)  mpQuarterBurnIn.put(c.recordtype.name +'-Q20', c.Q20__c);  else  continue;
            if(c.Q21__c!=null)  mpQuarterBurnIn.put(c.recordtype.name +'-Q21', c.Q21__c);  else  continue;
            if(c.Q22__c!=null)  mpQuarterBurnIn.put(c.recordtype.name +'-Q22', c.Q22__c);  else  continue;
            if(c.Q23__c!=null)  mpQuarterBurnIn.put(c.recordtype.name +'-Q23', c.Q23__c);  else  continue;
            if(c.Q24__c!=null)  mpQuarterBurnIn.put(c.recordtype.name +'-Q24', c.Q24__c);  else  continue;  
        }
        
         month = mcm.productionDate.month();
         startYear = mcm.productionDate.year();
        if(month >= 1 && month <=3) {
          startQuarter = 1;
        }
        if(month >= 4 && month <=6) {
          startQuarter = 2;
        }
        if(month >= 7 && month <=9) {
          startQuarter = 3;
        }
        if(month >= 10 && month <=12) {
          startQuarter = 4;
        }
        
        //insert the yields and costs calculation to to Configurator Yield
        //and Configurator Cost records
        modTestCapReqCalculate(mcm);         
        biCapReqCalculate(mcm);

        generateCost(mcm);
        GenerateConfigurationDetails(mcm);
        GenerateMCMFinishedCost(mcm);
            
    }
    
    
    
    
    
    //Mcm wrapper class   
    public class McmDetail {
        public String mcmID;
        public PCM_MCM_Detail__c mcmObj;
        public String fab;
        
        public Date productionDate;
        public List<String> years;
        public List<MCM_Yields__c> quarterlyYields;
        public List<Mcm_Quarterly_Volume__c> quarterlyVolumes;
        public List<Mcm_BurnIn_Duration__c> quarterlyBurnIn;
        
        public McmDetail(PCM_MCM_Detail__c c){    
            this.mcmObj=c;
            this.quarterlyVolumes = new List<MCM_Quarterly_Volume__c>(); 
            this.quarterlyYields = new List<MCM_Yields__c>();
            this.years = new List<String>();
            this.mcmID = c.id;            
            this.fab = c.fab__c;
            this.quarterlyBurnIn = new List<Mcm_BurnIn_Duration__c>();
            
            if(this.fab == 'FAB 9' || this.fab == 'FAB 10'){
                this.productionDate = c.Actual_Tapeout_Date_FAB_9_and_FAB_10__c;    
            } else {
                this.productionDate = c.Actual_Tapeout_Date__c;
            }
                       
            
        }
        public void addQuarterlyBurnIn(Mcm_BurnIn_Duration__c c){
            this.quarterlyBurnIn.add(c);            
        }
        
        public void addQuarterlyYields(MCM_Yields__c c){
            this.quarterlyYields.add(c);            
        }
        
        public void addQuarterlyVolumes(MCM_Quarterly_Volume__c c){
            this.quarterlyVolumes.add(c);            
        }
        
        public void addYears(String year){
            this.years.add(year);
        }
        
    }
    
    //Calculation of Burn-in CAP Req
    public static void biCapReqCalculate(McmDetail mcmDtl){        
        
        Decimal reburnPercent = 0.0;
        Decimal loadFactor=0.0;
        Decimal bibloadUnloadTm=0.0;
        Decimal ovenSetup=0.0;
        Decimal ovenSetupBibLoad=0.0;
        Decimal ovenUnloadTime=0.0;       
        Decimal slotPerOvenUsed = 0.0;
        Decimal socketsPerBibUsed = 0.0;
        
        String bibPreload=''; 
        
        //Getting the constant values from 'APS Constants'
        for(PCM_Time__c p : [select    value__c
                                       ,recordtype.name
                                       , Constant_Name__c
                             from      PCM_Time__c
                             where     RecordType.name = 'APS Constants'
                             and       Constant_Name__c in ('OVEN_UNLOAD_TIME','BIB_PRELOAD','OVEN_SETUP','BIB_LOAD_UNLOAD_TM','LOAD_FACTOR','REBURN_PERCENT')
                             and       Location__c = :mcmDtl.mcmObj.Fab__c
                             and       Catalog_ID__c =:pcmAdminSetting.Catalog_ID__c
                             and       Version__c =:pcmAdminSetting.Version_ID__c]){
            if(p.Constant_Name__c == 'OVEN_UNLOAD_TIME'){
                ovenUnloadTime = Decimal.valueOf(p.Value__c);
            }
            if(p.Constant_Name__c == 'BIB_PRELOAD'){
                bibPreload = p.Value__c;
            }
            if(p.Constant_Name__c == 'OVEN_SETUP'){
                ovenSetup = Decimal.valueOf(p.Value__c);
            }
            if(p.Constant_Name__c == 'BIB_LOAD_UNLOAD_TM'){
                bibloadUnloadTm = Decimal.valueOf(p.Value__c);
            }
            if(p.Constant_Name__c == 'LOAD_FACTOR'){
                loadFactor = Decimal.valueOf(p.Value__c);
            }
            if(p.Constant_Name__c == 'REBURN_PERCENT'){
                reburnPercent = Decimal.valueOf(p.Value__c);
            }
        }
        
        if(bibPreload == 'N'){
            ovenSetupBibLoad = ovenSetup+bibloadUnloadTm;        
        }else if(bibPreload == 'Y'){
            ovenSetupBibLoad = ovenSetup;
        }
        
        // Get data for BI Usage
        for(PCM_Time__c p : [select    Avail__c
                                       , PCT__c
                                       , Usage_Fact__c 
                             from      PCM_Time__c 
                             where     RecordType.name = 'BI Usage' 
                             and       Usage_Fact__c in ('SOCKET_BIB','SLOT_PER_OVEN') 
                             and       BI_OVEN__c = :mcmDtl.mcmObj.Burn_In_Platform__c
                             and       Catalog_ID__c =:pcmAdminSetting.Catalog_ID__c
                             and       Version__c =:pcmAdminSetting.Version_ID__c]){
            if(p.Usage_Fact__c == 'SLOT_PER_OVEN'){
                slotPerOvenUsed = p.Avail__c*p.PCT__c;
            }
                      
                }
        
        socketsPerBibUsed=mcmDtl.mcmObj.Number_of_Sockets_Per_Boards__c;
        Decimal modPerOvenRun = (slotPerOvenUsed*socketsPerBibUsed)*(1-reburnPercent);
        Decimal ovenExecutionTime = ovenSetupBibLoad+ovenUnloadTime;        
        
        // Get the workcenter data
        List<PCM_Time__c> ptList = [select    TAE_ME__c
                                              , Planned_Maint__c
                                              , Unplanned_Maint__c
                                              , Contingency_Percent__c 
                                    from      PCM_Time__c
                                    where     RecordType.name = 'WorkCenter'
                                    and       Stage__c = 'MOD_BI'
                                    and       Location__c = :mcmDtl.mcmObj.Fab__c
                                    and       Workcenter__c = :mcmDtl.mcmObj.Burn_In_Platform__c
                                    ];
        
        Decimal totalDownTime = ((ptList!=null && ptList.size()>0)?ptList[0].TAE_ME__c:0.0)
                                        + ((ptList!=null && ptList.size()>0)?ptList[0].Planned_Maint__c:0.0)
                                        + ((ptList!=null && ptList.size()>0)?ptList[0].Unplanned_Maint__c:0.0);
        
        Decimal availableHours = 24-totalDownTime;
        
        // Calculate and add the BI Cap Req to the Configurator Yield object
        tempYear=startYear;
                  tempQuarter = startQuarter;
        for(MCM_BurnIn_Duration__C bIn:mcmDtl.quarterlyBurnIn){
            if(bIn.recordtype.name=='Burn-In Duration'){
              for (Integer mcmQtr=1;mcmQtr<=qtrCount;mcmQtr++){
                    
                    String yr =  mpYearQuarterQuarterVol.get(mcmQtr);
                    Decimal burnInDuration =(!mpQuarterBurnIn.isEmpty() && mpQuarterBurnIn.containsKey(bIn.recordtype.name+'-Q'+mcmQtr))?(Decimal)mpQuarterBurnIn.get(bIn.recordtype.name+'-Q'+mcmQtr):0.0;
                    Decimal totalRunTime =  ovenExecutionTime+burnInDuration;
                    
                    Decimal runsPerDay;
                    try{
                        runsPerDay = availableHours/totalRunTime;
                    }catch(Exception e){runsPerDay=0.0;}
                    Decimal startsPerDayOvens = (runsPerDay*loadFactor*modPerOvenRun)/(1+((ptList!=null && ptList.size()>0)?ptList[0].Contingency_Percent__c:0.0));            
                    
                    Decimal finalVal;
                    
                    try{
                        finalVal = 24/startsPerDayOvens;
                        
                    }catch(Exception e){finalVal=0.0;}
                
                    mpBIYldResult.put(tempYear+ '-Q' + tempQuarter,finalVal);
                    if(tempQuarter>=4){
                        tempQuarter =1;
                        tempYear++;
                    }
                    else tempQuarter++;
  
                } 

            }
        }
    }
    
    //Module Test Cap Req Calculation
    public static void modTestCapReqCalculate(McmDetail mcmDtl){
        
        Decimal groupPercent = 0.0;
        Decimal loadFactor = 0.0;
        Decimal retestPercent = 0.0;
        Decimal machineStopDelay = 0.0;
        Decimal setupTimePerLot = 0.0;
        Decimal ronRetestPct = 0.0;
                
        String PTNumber ='DEFAULT';
        //Getting the constant values         
        for(PCM_Time__c p : [select    Value__c
                             , Constant_Name__c
                             from      PCM_Time__c
                             where     RecordType.name = 'APS Constants'
                             and       Constant_Name__c in ('GROUP_A_PERCENT','LOAD_FACTOR','RETEST_PER_CENT','MACH_STOP_DELAY','SETUP_TIME_PER_LOT','RON_RETEST_PERCENT')
                             and       Location__c = :mcmDtl.mcmObj.Fab__c
                             and       Catalog_ID__c =:pcmAdminSetting.Catalog_ID__c
                             and       Version__c =:pcmAdminSetting.Version_ID__c
                            ]){
                                if(p.Constant_Name__c == 'GROUP_A_PERCENT'){
                                    groupPercent = Decimal.valueOf(p.Value__c);
                                }else if(p.Constant_Name__c == 'LOAD_FACTOR'){
                                    loadFactor = Decimal.valueOf(p.Value__c);
                                }else if(p.Constant_Name__c == 'RETEST_PER_CENT'){
                                    retestPercent = Decimal.valueOf(p.Value__c);
                                }else if(p.Constant_Name__c == 'MACH_STOP_DELAY'){
                                    machineStopDelay = Decimal.valueOf(p.Value__c);
                                }else if(p.Constant_Name__c == 'SETUP_TIME_PER_LOT'){
                                    setupTimePerLot = Decimal.valueOf(p.Value__c);
                                }else if(p.Constant_Name__c == 'RON_RETEST_PERCENT'){
                                    ronRetestPct = Decimal.valueOf(p.Value__c);
                                }    
                            }
        
        Decimal contingencyPct = 0.0;
        Decimal overHeadTime = 0.0;
        Decimal indexTime = 0.0;
        Decimal charPercent = 0.0;
        Decimal initialModSetupTime = 0.0;
        Decimal totDetractorHours=0.0;
        Decimal handlersPerTester = 0.0;
        
        //Getting PCM Records for Workcenter and Handler FEH recordType
        for(PCM_Time__c p : [select    Handlers_WS__c
                             , Contingency_Percent__c
                             , Overhead_Time__c
                             , Index_Time__c
                             , Characterization_Percent__c
                             , Initial_Mod_Setup__c
                             , Planned_Maint__c
                             , Unplanned_Maint__c
                             , MFG_Planned_Maint__c
                             , MFG_Unplanned_Maint__c
                             , Calibration__c
                             , TAE_ME__c
                             , IS_DP__c
                             , RecordType.name 
                             from      PCM_Time__c 
                             where     RecordType.name in ('WorkCenter','Handler FEH') 
                             and       Location__c = :mcmDtl.mcmObj.Fab__c
                             and       Stage__c = 'MOD_TST' 
                             and       Workcenter__c = :mcmDtl.mcmObj.Test_Platform__c
                             and       Catalog_ID__c =:pcmAdminSetting.Catalog_ID__c
                             and       Version__c =:pcmAdminSetting.Version_ID__c]){
                                 if(p.RecordType.name == 'WorkCenter'){
                                     handlersPerTester = p.Handlers_WS__c;
                                     contingencyPct = p.Contingency_Percent__c;
                                     overHeadTime = p.Overhead_Time__c;
                                     initialModSetupTime = p.Initial_Mod_Setup__c; 
                                     charPercent = p.Characterization_Percent__c;
                                     totDetractorHours += p.Planned_Maint__c+p.Unplanned_Maint__c+p.MFG_Planned_Maint__c+p.MFG_Unplanned_Maint__c+p.Calibration__c+p.TAE_ME__c+p.IS_DP__c;                                   
                                 }else if(p.RecordType.name == 'Handler FEH'){
                                     indexTime = p.Index_Time__c;
                                     
                                     
                                     totDetractorHours += p.Planned_Maint__c+p.Unplanned_Maint__c+p.MFG_Planned_Maint__c+p.MFG_Unplanned_Maint__c;
                                 }
                             }
        
        contingencyPct = (contingencyPct!=null)?contingencyPct:0.0;
        overHeadTime = (overHeadTime!=null)?overHeadTime:0.0;
        initialModSetupTime = (initialModSetupTime!=null)?initialModSetupTime:0.0;
        charPercent = (charPercent!=null)?charPercent:0.0;
        indexTime = (indexTime!=null)?indexTime:0.0;
        totDetractorHours = (totDetractorHours!=null)?totDetractorHours:0.0;
        
        List<PCM_Time__c>   pcmLotSizeRec = [select Lot_Size__c
                                             , Year__c
                                             from   PCM_Time__c
                                             where  RecordType.name = 'Lot Size'
                                             and    Stage__c = 'MOD_TST'
                                             and    Year__c in :mcmDtl.years
                                             and    Package_Tech__c = :packageTechnology order by Year__c asc];              
        
        Decimal pcmData = 0.0;
        for(PCM_Time__c p : [select    Data__c
                             , PT_Number__c
                             from      PCM_Time__c
                             where     RecordType.name = 'Time Data'
                             and       workcenter__c = :mcmDtl.mcmObj.Test_Platform__c
                             and       relgrade__c = '1'
                             and       ((PT_Number__c = :PTNumber                                       
                                         and       Time_Comp__c = 'BTT_PCT')
                                        OR        (PT_Number__c = 'DEFAULT'                                       
                                                   and       Time_Comp__c = 'BTT_PCT'))
                             and       Catalog_ID__c =:pcmAdminSetting.Catalog_ID__c
                             and       Version__c =:pcmAdminSetting.Version_ID__c]){
                                 
                                 if(pcmData == 0.0 && p.PT_Number__c == 'DEFAULT'){
                                     pcmData = p.Data__c;    
                                 }    
                             }         
        
        Map<String,String> pcmLotSizeByYear = new Map<String,String>();
        for(PCM_Time__c p : pcmLotSizeRec){
            pcmLotSizeByYear.put(p.Year__c,p.Lot_Size__c);    
        }
        
        
        Decimal goodTestTime = (mcmDtl.mcmObj.User_Defined_Time__c!=null)?mcmDtl.mcmObj.User_Defined_Time__c:0.0;
        Decimal badTestTime = goodTestTime*((pcmData!=null)?pcmData:0.0);
        Decimal charTestTime = goodTestTime;
        
        for(MCM_Yields__c yld:mcmDtl.quarterlyYields){
            if(yld.recordtype.name=='Test Yield'){
                tempYear=startYear;
                  tempQuarter = startQuarter;
                for (Integer mcmQtr=1;mcmQtr<=qtrCount;mcmQtr++){
                    
                    
                    Decimal modYld = (Decimal)(mpQuarterYield.get(yld.recordtype.name+'-Q'+(mcmQtr<24?mcmQtr:24)));
                    String yr =  mpYearQuarterQuarterVol.get(mcmQtr);       
                    Decimal badWaferTestYld = 1-modYld;
                    
                    Decimal avgTestTime = ((goodTestTime*modYld)+(badTestTime*badWaferTestYld)*(1-charPercent))+(charPercent*charTestTime);
                    
                    Decimal noOfDuts = Decimal.valueOf(mcmDtl.mcmObj.No_of_DUTS__c);
                    Decimal steadyStateCapUsed;  
                    try{
                        if(noOfDuts<=4){
                            steadyStateCapUsed= 3600/((avgTestTime+overHeadTime+indexTime)/noOfDuts);    
                        }else{
                            steadyStateCapUsed= 3600 /((goodTestTime+overHeadTime+indexTime)/noOfDuts);
                        }
                    }catch(Exception e){steadyStateCapUsed=0.0;}
                    Decimal ratePerHr = steadyStateCapUsed*(1-machineStopDelay);
                    Decimal startsPerHr = ratePerHr/(1+((retestPercent==0)?(1-modYld+ronRetestPct):retestPercent));
                    Decimal lotSizePerHandler = (pcmLotSizeByYear.containsKey(yr))?(Decimal.valueOf(pcmLotSizeByYear.get(yr))):0.0;
                    
                    Decimal lotsTestedPerDay;
                    try{
                        lotsTestedPerDay = (24-(initialModSetupTime+totDetractorHours))/(setupTimePerLot+(lotSizePerHandler/startsPerHr));
                    }catch(Exception e){lotsTestedPerDay=0.0;}
                    
                    Decimal totalSetup = (lotsTestedPerDay*setupTimePerLot)+initialModSetupTime;
                    Decimal netProductiveHr = 24 - (totalSetup+totDetractorHours);
                    Decimal rawThruPut = (startsPerHr*netProductiveHr)/1000*(loadFactor*handlersPerTester);
                    Decimal grpAThruput = rawThruPut/(1+groupPercent);
                    Decimal contingentThruputStart = grpAThruput/(1+contingencyPct);
                    Decimal finalResult = (contingentThruputStart!=0.0)?(24/(contingentThruputStart*1000)):0.0;
                    
                 
                    mpModTestYldResult.put(tempYear+ '-Q' + tempQuarter,finalResult);
                    if(tempQuarter>=4){
                        tempQuarter =1;
                        tempYear++;
                    }
                    else tempQuarter++;
              
                } 
            }
        }
       }

  static void generateCost(McmDetail mcmDetail){
        List<String> costFilters = new List<String>();
        List<String> testPlatforms = new List<String>();
        List<String> fabs = new List<String>();
        Map<String,PCM_Cost__c> costHeaderMap = new Map<String,PCM_Cost__c> ();
        Map<String,MCM_Reporting_Data__c> costHeaderMap1 = new Map<String,MCM_Reporting_Data__c> ();
        costFilters.add('Module Test Hour');
        testPlatforms.add(mcmDetail.mcmObj.Test_Platform__c);
        fabs.add(mcmDetail.mcmObj.Fab__c);
        
        costFilters.add('Module BI Hour');                
        testPlatforms.add(mcmDetail.mcmObj.Burn_In_Platform__c);    
        
        //Get the BI and Module test cost
        for(PCM_Cost__c c: [SELECT id,cost__c,recordType.name,quarter__c,year__c,allocation__c,pfactor__c
                               FROM PCM_Cost__c 
                               WHERE recordType.name IN :costFilters
                               AND test_platform__c IN :testPlatforms
                               AND fab__c = :mcmDetail.mcmObj.Fab__c
                               AND year__c IN :mcmDetail.years                               
                               ORDER BY year__c,quarter__c]){ 
            costHeaderMap.put(c.recordType.name + '-' +c.year__c +'-' +c.quarter__c,c);                                                    
        }  
        
        //Get the SBT cost for Module Test
        for(PCM_Cost__c c: [SELECT id,cost__c,recordType.name,quarter__c,year__c,allocation__c,pfactor__c
                               FROM PCM_Cost__c 
                               WHERE recordType.name = 'Module Test SBT'
                               AND package_technology__c = :packageTechnology
                               AND fab__c = :mcmDetail.mcmObj.Fab__c
                               AND year__c IN :mcmDetail.years                               
                               ORDER BY year__c,quarter__c]){ 
            costHeaderMap.put(c.recordType.name + '-' +c.year__c +'-'+ c.quarter__c,c);                                                         
        }  
                 
      
      
      //Calculation of MCM Test & BurnIn Cost before & after applying Yield
      integer tempQtr=startQuarter;
      integer currentYear =startYear;
      Decimal sbtCost =0.0;
      Decimal modCost;
      Decimal modResult=0.0;
      DEcimal biCost=0.0;
      Decimal biResult=0.0;
      cost = new PCM_Cost__c();
      List<MCM_Reporting_Data__c> data = new List<MCM_Reporting_Data__c>();
      MCM_Reporting_Data__c objModTst_beforeYld;
      MCM_Reporting_Data__c objModBI_beforeYld;
      MCM_Reporting_Data__c objModTst_afterYld;
      MCM_Reporting_Data__c objModBI_afterYld;
      MCM_Reporting_Data__c objAssmbly_afterYld;
      List<MCM_Reporting_Data__c> rptId ;
      ID id = mcmDetail.mcmID;
      
      Decimal mcmTstYield= 0.0;
      Decimal mcmBIYield=0.0;
      Decimal mcmAsmYield = 0.0;  
      
      //Delete previous Data
     rptId = new List<MCM_Reporting_Data__c>();
      for(MCM_Reporting_Data__c c:[Select id
                                                    FROM MCM_Reporting_Data__c
                               WHERE  Cost_Type__c!='Assembly & Substrate Cost (before Yield)' AND
                                    MCM__c =: mcmDetail.mcmObj.Id ]){
                                       
                                       rptId.add(c);
                                   }
      delete rptId;
      
          insert insertQtr; //Insert MCM Quarterly volume to display on report
      
       Decimal mcmAsmnlyYield= 0.0;
      for (integer i=1;i<=qtrCount;i++){
          
        objModTst_beforeYld = new MCM_Reporting_Data__c();
        objModBI_beforeYld=new MCM_Reporting_Data__c();
        objModTst_afterYld = new MCM_Reporting_Data__c();
        objModBI_afterYld=new MCM_Reporting_Data__c();   
        objAssmbly_afterYld =new MCM_Reporting_Data__c();   
                
         mcmBIYield = mpQuarterYield.get( 'Burn-In User Defined-Q' +(i<24?i:24));  
         mcmTstYield = mpQuarterYield.get( 'Test Yield-Q' +(i<24?i:24));            
      
          //Inserting MOD BI Cost before and after applying Yields
          biResult=mpBIYldResult.get(currentYear+'-Q'+tempQtr);
          cost =costHeaderMap.get( 'Module BI Hour-' +currentYear+'-Q'+tempQtr);
          biCost=(cost!=null)?(DEcimal)cost.Cost__c:0.0; 
          
          objModBI_beforeYld.MCM__c = id;
          objModBI_beforeYld.Cost_Type__c ='Burn-In Cost (before Yield)';
          objModBI_beforeYld.yEAR__c =String.valueof(currentYear);
          objModBI_beforeYld.Quarter__c = 'Q' +tempQtr;
          objModBI_beforeYld.Cost__c = biCost * biResult;
      
          
          objModBI_afterYld.MCM__c = id;
          objModBI_afterYld.yEAR__c =String.valueof(currentYear);
          objModBI_afterYld.Quarter__c = 'Q' +tempQtr;
          objModBI_afterYld.Cost_Type__c ='Burn-In Cost (after Yield)';
          objModBI_afterYld.Cost__c =((mcmBIYield*mcmTstYield)==0)?0:(biCost*biResult)/(mcmBIYield*mcmTstYield);
         
          
           //Inserting Mod Test Cost before and after applying Yields
          modResult=mpModTestYldResult.get(currentYear+'-Q'+tempQtr);
          
          cost =costHeaderMap.get( 'Module Test SBT-' +currentYear+'-Q'+tempQtr);
          sbtCost= (cost!=null)?(DEcimal)cost.Cost__c:0.0;
          cost =costHeaderMap.get( 'Module Test Hour-' +currentYear+'-Q'+tempQtr);
          modCost=(cost!=null)?(DEcimal)cost.Cost__c:0.0;
          objModTst_beforeYld.MCM__c = id;
          objModTst_beforeYld.Cost_Type__c ='Module Test Cost (before Yield)';
          objModTst_beforeYld.yEAR__c =String.valueof(currentYear);
          objModTst_beforeYld.Quarter__c = 'Q' +tempQtr;
          objModTst_beforeYld.Cost__c = (modCost * modResult)+sbtCost;
          
          objModTst_afterYld.MCM__c = id;
          objModTst_afterYld.Cost_Type__c ='Module Test Cost (after Yield)';
          objModTst_afterYld.yEAR__c =String.valueof(currentYear);
          objModTst_afterYld.Quarter__c = 'Q' +tempQtr;
          objModTst_afterYld.Cost__c = ((modCost * modResult)+sbtCost)/mcmTstYield;
          
          data.add(objModBI_beforeYld);   //BI Cost before applying Yield 
          data.add(objModBI_afterYld);   //BI Cost after applying Yield
          data.add(objModTst_beforeYld);     //Mod Tst Cost before applying Yield
          data.add(objModTst_afterYld);    //Mod Tst Cost after applying Yield
           if (tempQtr>=4) { tempQtr=1;currentYear++;} else tempQtr++;
      }
    
     Integer qtr =1; 
     for(MCM_Reporting_Data__c c:[Select id,Cost__c,Cost_Type__c,Year__c,Quarter__c,MCM__c
                                                    FROM MCM_Reporting_Data__c
                                  WHERE Cost_Type__c='Assembly & Substrate Cost (before Yield)'
                                   AND MCM__c =: mcmDetail.mcmObj.Id order by Year__c, quarter__c asc ]){
                                     objAssmbly_afterYld = new MCM_Reporting_Data__c();
                                       mcmAsmYield =mpQuarterYield.get( 'Assembly Yield-Q' +qtr);
                                       mcmBIYield = mpQuarterYield.get( 'Burn-In User Defined-Q' +qtr);
                                       mcmTstYield = mpQuarterYield.get( 'Test Yield-Q' + qtr);
                                       if(qtr<24) qtr++;
                                       objAssmbly_afterYld.Cost__c = (c.Cost__c)/(mcmAsmYield*mcmBIYield*mcmTstYield);
                                       objAssmbly_afterYld.Quarter__c = c.Quarter__c;
                                       objAssmbly_afterYld.Year__c = c.Year__c;
                                       objAssmbly_afterYld.MCM__c = c.MCM__c;
                                        objAssmbly_afterYld.Cost_Type__c =   'Assembly & Substrate Cost (after Yield)';
                                       data.add(objAssmbly_afterYld);
                                   }
      insert data;
      
    
   
     
  }
    
      // Calculating Quarterly Shipping Quantities for each selected configurations
    static void GenerateConfigurationDetails(McmDetail mcmDetail) {

        MCM_Reporting_Data__c dataQ1;
        MCM_Reporting_Data__c dataQ2;
        MCM_Reporting_Data__c dataQ3;
        MCM_Reporting_Data__c dataQ4;
        Integer qtyQtr1,qtyQtr2,qtyQtr3,qtyQtr4=0;
        Integer qtr; 
        List<MCM_Reporting_Data__c> data;

        Map<String,String> availableQtrYr = new Map<String,String>();
        
        for(MCM_Configuration_Detail__c c:[Select id,Chip_per_Technology__c,Configuration__c From MCM_Configuration_Detail__c Where PCM_MCM_MCM__c=:mcmDetail.mcmObj.Id]){
            qtr =1; 
            data = new List<MCM_Reporting_Data__c>();
            for(MCM_Quarterly_Volume__c qty:[Select Year__c, Q1_Volume__c,Q2_Volume__c,Q3_Volume__c,Q4_Volume__c 
                                             FROM MCM_Quarterly_Volume__c 
                                             WHERE PCM_MCM_Detail__c =:mcmDetail.mcmObj.Id 
                                            ORDER BY Year__c asc]){
                                                 
                                                 
                                                 dataQ1 =new MCM_Reporting_Data__c();
                                                 dataQ2 =new MCM_Reporting_Data__c();
                                                 dataQ3 =new MCM_Reporting_Data__c();
                                                 dataQ4 =new MCM_Reporting_Data__c();
                                                 
                                                 //Quarter 1
                                                 if(qty.Q1_Volume__C!=null){
                                                    dataQ1.Ship_Quantity__c = ((qty.Q1_Volume__c *c.Chip_per_Technology__c)/(mpQuarterYield.get( 'Assembly Yield-Q' +qtr)*mpQuarterYield.get( 'Burn-In User Defined-Q' +qtr)*mpQuarterYield.get( 'Test Yield-Q' + qtr)));
                                                     dataQ1.Year__c=String.valueOf(qty.Year__c);
                                                     dataQ1.Quarter__c ='Q1';
                                                     dataQ1.Cost_Type__c = 'Configuration-Ship Quantity';
                                                     dataQ1.MCM__c = mcmDetail.mcmObj.Id;
                                                     dataQ1.Configuration__c = c.Id;
                                                     data.add(dataQ1) ;  
                                                     availableQtrYr.put(String.valueOf(qty.Year__c)+'Q1', String.valueOf(qty.Year__c)+'Q1');
                                                     if(qtr<24) qtr++;
                                                 }
                                                 
                                                 //Quarter 2
                                                 if(qty.Q2_Volume__C!=null){
                                                     dataQ2.Ship_Quantity__c = ((qty.Q2_Volume__c*c.Chip_per_Technology__c) /(mpQuarterYield.get( 'Assembly Yield-Q' +qtr)*mpQuarterYield.get( 'Burn-In User Defined-Q' +qtr)*mpQuarterYield.get( 'Test Yield-Q' + qtr)));
                                                     dataQ2.Year__c=String.valueOf(qty.Year__c);
                                                     dataQ2.Quarter__c ='Q2';
                                                     dataQ2.Cost_Type__c = 'Configuration-Ship Quantity';
                                                     dataQ2.MCM__c = mcmDetail.mcmObj.Id;
                                                     dataQ2.Configuration__c = c.Id;
                                                     data.add(dataQ2) ;
                                                        availableQtrYr.put(String.valueOf(qty.Year__c)+'Q2', String.valueOf(qty.Year__c)+'Q2');
                                                     if(qtr<24) qtr++;
                                                 }
                                                 
                                                 //Quarter 3
                                                 if(qty.Q3_Volume__C!=null){
                                                      dataQ3.Ship_Quantity__c = ((qty.Q3_Volume__c*c.Chip_per_Technology__c)/(mpQuarterYield.get( 'Assembly Yield-Q' +qtr)*mpQuarterYield.get( 'Burn-In User Defined-Q' +qtr)*mpQuarterYield.get( 'Test Yield-Q' + qtr)));
                                                     dataQ3.Year__c=String.valueOf(qty.Year__c);
                                                     dataQ3.Quarter__c ='Q3';
                                                     dataQ3.Cost_Type__c = 'Configuration-Ship Quantity';
                                                     dataQ3.MCM__c = mcmDetail.mcmObj.Id;
                                                     dataQ3.Configuration__c = c.Id;
                                                     data.add(dataQ3) ;
                                                        availableQtrYr.put(String.valueOf(qty.Year__c)+'Q3', String.valueOf(qty.Year__c)+'Q3');
                                                     if(qtr<24) qtr++;
                                                     
                                                 }
                                                 
                                                 //Quarter 4
                                                 if(qty.Q4_Volume__C!=null){
                                                     dataQ4.Ship_Quantity__c = ((qty.Q4_Volume__C*c.Chip_per_Technology__c) /(mpQuarterYield.get( 'Assembly Yield-Q' +qtr)*mpQuarterYield.get( 'Burn-In User Defined-Q' +qtr)*mpQuarterYield.get( 'Test Yield-Q' + qtr)));
                                                     dataQ4.Year__c=String.valueOf(qty.Year__c);
                                                     dataQ4.Quarter__c ='Q4';
                                                     dataQ4.Cost_Type__c = 'Configuration-Ship Quantity';
                                                     dataQ4.MCM__c = mcmDetail.mcmObj.Id;
                                                     dataQ4.Configuration__c = c.Id;
                                                     data.add(dataQ4) ;
                                                     availableQtrYr.put(String.valueOf(qty.Year__c)+'Q4', String.valueOf(qty.Year__c)+'Q4');
                                                     if(qtr<24) qtr++;
                                                         }
                                                 
                                             }
            
        
             qtr =1; 
            for(Configurator_Cost__c confCost: [Select Id,Year__c,Quarter__c,Finish_goods_unit_cost__c 
                                               FROM Configurator_Cost__c
                                               WHERE Quote_Proposal__c =: c.Configuration__c
                                                ORDER BY Year__c,Quarter__C asc]){
                                    if(qtrCount>=qtr && availableQtrYr.containsKey(String.valueOf(confCost.Year__c)+confCost.Quarter__c)){                 
                                                    //For Configuration Unit Cost per Quarter
                                                     dataQ1 =new MCM_Reporting_Data__c();
                                                     dataQ1.Cost__c= confCost.Finish_goods_unit_cost__c;
                                                     dataQ1.Year__c=String.valueOf(confCost.Year__c);
                                                     dataQ1.Quarter__c =confCost.Quarter__c;
                                                     dataQ1.Cost_Type__c = 'Configuration-Unit Cost';
                                                     dataQ1.MCM__c = mcmDetail.mcmObj.Id;
                                                     dataQ1.Configuration__c = c.Id;
                                                    
                                                     data.add(dataQ1) ;
                                        if(qtr<24) qtr++;
                                    }
                                                }
            
                Insert data;
      
     
        }
             MCM_Reporting_Data__c deviceCost;
          AggregateResult[] deviceResults
                                                  = [select year__c,quarter__c, sum(Device_Part_Cost__c )  DeviceCost from mcm_reporting_data__c 
                                                     where mcm__c  =: mcmDetail.mcmObj.Id  and Cost_Type__c ='Configuration-Unit Cost'
                                                     group by year__c,quarter__c  order by Year__c,quarter__c asc];
      
        
           data.clear();
             qtr =1; 
        
           
            for (AggregateResult ar : deviceResults)  {
                deviceCost = new MCM_Reporting_Data__c();
               
                if(qtrCount>=qtr){
                deviceCost.Cost__c =(((Decimal)ar.get('DeviceCost'))/(mpQuarterYield.get( 'Assembly Yield-Q' +qtr)*mpQuarterYield.get( 'Burn-In User Defined-Q' +qtr)*mpQuarterYield.get( 'Test Yield-Q' + qtr)));
                 
                deviceCost.Quarter__c = string.valueof(ar.get('quarter__c'));
                                       deviceCost.Year__c =  String.valueof(ar.get('year__c') );
                                       deviceCost.MCM__c = mcmDetail.mcmObj.Id;
                                       deviceCost.Cost_Type__c =   'Device Cost';
                                       data.add(deviceCost);
                                       if(qtr<24) qtr++;
                }
            }
       insert data;
    }
    
    static void GenerateMCMFinishedCost(McmDetail mcmDetail){
         
         Integer qtr =1; 
        MCM_Reporting_Data__c finishCost;
        List<MCM_Reporting_Data__c> data = new List<MCM_Reporting_Data__c>();
     
           //for adding Total MCM Finished Good Cost
         
          AggregateResult[] finishedMCMResults
                                                  = [select year__c,quarter__c, sum(cost__c) total from mcm_reporting_data__c 
                                                     where mcm__c  =: mcmDetail.mcmObj.Id  and (cost_type__c like '%after%'  or Cost_Type__c ='Device Cost')
                                                     group by year__c,quarter__c order by Year__c,quarter__c asc];
      
          
            for (AggregateResult ar : finishedMCMResults)  {
                finishCost = new MCM_Reporting_Data__c();
             
              
                finishCost.Cost__c =(Decimal) ar.get('total');
                                       finishCost.Quarter__c =(String) ar.get('quarter__c');
                                       finishCost.Year__c = (String) ar.get('year__c') ;
                                       finishCost.MCM__c = mcmDetail.mcmObj.Id;
                                        finishCost.Cost_Type__c =   'MCM Finished Good Cost';
                                       data.add(finishCost);
                
            }
        insert data;
    }
}