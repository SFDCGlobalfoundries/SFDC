/*
Author: Ariz Solito
Description: Apex controller class for Yield and Cost Report
History: 
Asolito     05272016    - Code creation.    
Rpaliwal    06132015    - Update to display BurnIn Cost of Relgrade 5 or more
ssharma1    01222017    - Addition of GMPW (Average) & Wafer Starts
*/
public class YieldAndCostReportCntrlr {
    transient public final Apttus_Proposal__Proposal__c currProposal { get; set; }
    public TestTimeWrapper  testTimeData {get; set;}
    public YieldWrapper yieldData {get; set;}
    public CostWrapper costData {get; set;}
    public Boolean isPDF {get; set;}
    public  Boolean isExcel {get; set;}
    private EnableYieldStages enableYieldStages;
    private EnableCostStages enableCostStages;
    public List<Config_Post_Fab_Services__c> cpfsList {get;set;}
    
    public YieldAndCostReportCntrlr(ApexPages.StandardController ctrl){
        this.currProposal = (Apttus_Proposal__Proposal__c)ctrl.getRecord();
        List<YieldRow> yieldRows = new List<YieldRow>();
        List<CostRow> costRows = new List<CostRow>();
        
        if(apexpages.currentpage().getparameters().get('rendertype') == 'pdf'){
            this.isPDF = true;
        } else if(apexpages.currentpage().getparameters().get('rendertype') == 'excel'){               
            this.isExcel = true;
        }
        
        this.enableYieldStages = new EnableYieldStages(this.currProposal.product_type__c,this.currProposal.relgrade__c);
        this.enableCostStages = new EnableCostStages(this.currProposal.product_type__c,this.currProposal.relgrade__c);
        
        cpfsList = [select    Module_Test_Time_Method__c
                    , Module_User_Defined_Time__c
                    , Test_Time_Method__c
                    , User_Defined_Time__c
                    from      Config_Post_Fab_Services__c
                    where     configuration__c = :this.currProposal.id        
                   ];
        
        system.debug('1===> '+[SELECT quarter__c,year__c,FEOL_yield__c,BEOL_PRE_yield__c,
                               BEOL_POST_yield__c,KERF_X__c,KERF_Y__c,CPW__c,wafer_test_yield__c,
                               LYH__c,GCPW__c,BA__c,BI__c,module_test_yield__c,GMPW__c
                               FROM Configurator_Yield__c 
                               WHERE quote_proposal__c = :this.currProposal.id
                               ORDER BY year__c,quarter__c]);
        Map<String,Configurator_Yield__c> yieldRowMap = new Map<String,Configurator_Yield__c>();
        for(Configurator_Yield__c y: [SELECT quarter__c,year__c,FEOL_yield__c,BEOL_PRE_yield__c,
                                      BEOL_POST_yield__c,KERF_X__c,KERF_Y__c,CPW__c,wafer_test_yield__c,
                                      LYH__c,GCPW__c,BA__c,BI__c,module_test_yield__c,GMPW__c
                                      FROM Configurator_Yield__c 
                                      WHERE quote_proposal__c = :this.currProposal.id
                                      ORDER BY year__c,quarter__c]){
                                          yieldRows.add(new YieldRow(y,this.currProposal));
                                          yieldRowMap.put(y.year__c + y.quarter__c,y);                                                        
                                      }         
        system.debug('2===> '+[SELECT quarter__c,year__c,volume__c,calculated_total_wafer_processing_cost__c,
                               calculated_total_wafer_finishing_cost__c,calculated_total_wafer_test_cost__c,
                               calculated_total_substrate_cost__c,calculated_total_module_assembly_cost__c,
                               calculated_total_module_burn_in_cost__c,calculated_total_module_test_cost__c,
                               calculated_total_allocation_cost__c,finish_goods_unit_cost__c
                               FROM Configurator_Cost__c 
                               WHERE quote_proposal__c = :this.currProposal.id
                               ORDER BY year__c,quarter__c]);
        for(Configurator_Cost__c c: [SELECT quarter__c,year__c,volume__c,calculated_total_wafer_processing_cost__c,
                                     calculated_total_wafer_finishing_cost__c,calculated_total_wafer_test_cost__c,
                                     calculated_total_substrate_cost__c,calculated_total_module_assembly_cost__c,
                                     calculated_total_module_burn_in_cost__c,calculated_total_module_test_cost__c,
                                     calculated_total_allocation_cost__c,finish_goods_unit_cost__c
                                     FROM Configurator_Cost__c 
                                     WHERE quote_proposal__c = :this.currProposal.id
                                     ORDER BY year__c,quarter__c]){
                                         String key = c.year__c + c.quarter__c;                                        
                                         if(yieldRowMap.containsKey(key)){                                        
                                             costRows.add(new CostRow(c));
                                         }
                                     }        
        
        system.debug('3==> '+[SELECT test_time__c,test_section__c,module_test_pass__c,
                              recordType.name
                              FROM Configurator_Test_Pass__c 
                              WHERE configuration__c = :this.currProposal.id
                              ORDER BY test_section__c]);        
        List<Configurator_Test_Pass__c> testPasses = [SELECT test_time__c,test_section__c,module_test_pass__c,
                                                      recordType.name
                                                      FROM Configurator_Test_Pass__c 
                                                      WHERE configuration__c = :this.currProposal.id
                                                      ORDER BY test_section__c];                                                  
        
        this.testTimeData = new TestTimeWrapper(testPasses,cpfsList);
        this.yieldData = new YieldWrapper(yieldRows,this.currProposal.product_type__c,this.enableYieldStages);                                                      
        this.costData = new CostWrapper(costRows,this.currProposal.product_type__c,this.enableCostStages); 
        calcuateWaferStarts();
    } 
    
    //Wrapper class for Test Time Section
    public class TestTimeWrapper {
        public List<TestTimeRow> combinedTestTimeList {get; set;}
        public Map<String,Map<String,Decimal>> testPassMap;
        public Set<String> testSectionSet;
        public Decimal totalWaferTestTime {get; set;}
        public Decimal totalModuleTestTime {get; set;}        
        public Decimal totalTestTime {get; set;}
        public List<String> testPassHeader {get; set;}
        
        public TestTimeWrapper(List<Configurator_Test_Pass__c> testPasses,List<Config_Post_Fab_Services__c> cpfsList){
            this.combinedTestTimeList = new List<TestTimeRow>(); 
            this.testPassMap = new Map<String,Map<String,Decimal>>();
            this.testSectionSet = new Set<String>();
            this.totalWaferTestTime = 0;
            this.totalModuleTestTime  = 0;
            this.totalTestTime = 0;
            this.testPassHeader = new List<String>();
            
            for(Configurator_Test_Pass__c c: testPasses){
                if(this.testPassMap.containsKey(c.module_test_pass__c)){
                    this.testPassMap.get(c.module_test_pass__c).put(c.test_section__c,c.test_time__c);
                } else {
                    this.testPassMap.put(c.module_test_pass__c,new Map<String,Decimal>{c.test_section__c=>c.test_time__c});
                } 
                
                this.testSectionSet.add(c.test_section__c);  
            }
            
            List<String> sortedTestPasses = new List<String>();
            sortedTestPasses.addAll(testPassMap.keyset());
            sortedTestPasses.sort();
            this.testPassHeader.addAll(sortedTestPasses);
            
            Map<String,Decimal> totalTimePerTestPass = new Map<String,Decimal>();
            for(String t: this.testSectionSet){
                TestTimeRow rec = new TestTimeRow(t); 
                
                for(String s :sortedTestPasses){
                    if(this.testPassMap.get(s).containsKey(t)){
                        Decimal currTestTime = this.testPassMap.get(s).get(t);                        
                        rec.testTimes.add(currTestTime.setScale(5));
                        this.totalTestTime += currTestTime;
                        
                        if(s == 'WFT'){
                            this.totalWaferTestTime += currTestTime;    
                        } else {
                            this.totalModuleTestTime += currTestTime; 
                        }
                        
                        if(totalTimePerTestPass.containsKey(s)){
                            Decimal currTotalTestTime = totalTimePerTestPass.get(s) + currTestTime;
                            totalTimePerTestPass.put(s,currTotalTestTime);
                        } else {
                            totalTimePerTestPass.put(s,currTestTime);
                        }
                        
                    } else {
                        Decimal blank = 0;
                        rec.testTimes.add((blank).setScale(5));
                    }
                }
                
                this.combinedTestTimeList.add(rec);   
            }
            
            //add the totals
            TestTimeRow totalrow = new TestTimeRow('total'); 
            for(String t: sortedTestPasses){
                totalrow.testTimes.add(totalTimePerTestPass.get(t).setScale(5));
            }
            this.combinedTestTimeList.add(totalrow);
            
            this.totalWaferTestTime = (cpfsList!=null && cpfsList.size()>0 && cpfsList[0].Test_Time_Method__c=='User Defined GTT/Chip')?cpfsList[0].User_Defined_Time__c.setScale(5):this.totalWaferTestTime.setScale(5);
            this.totalModuleTestTime = (cpfsList!=null && cpfsList.size()>0 && cpfsList[0].Module_Test_Time_Method__c=='User Defined GTT/Chip')?cpfsList[0].Module_User_Defined_Time__c.setScale(5):this.totalModuleTestTime.setScale(5);
            this.totalTestTime = this.totalWaferTestTime+this.totalModuleTestTime;
            
        }
    } 
    
    //Wrapper class for Test Time Row
    public class TestTimeRow {
        public String testSection {get; set;}
        public List<Decimal> testTimes {get; set;}
        
        public TestTimeRow( String testSection){
            this.testSection = testSection;
            this.testTimes = new List<Decimal>();
        }
    }                         
    
    //Wrapper class for the cost section of the report
    public class CostWrapper {
        public List<CostRowWrapper> costReportRows {get; set;}
        public List<String> quarterYearHeaders {get; set;}
        public Set<String> yearHeaders {get; set;}
        
        public CostWrapper(List<CostRow> costRows,String productType,EnableCostStages enableCostStages){
            this.costReportRows = new List<CostRowWrapper>();
            this.quarterYearHeaders = new List<String>();
            this.yearHeaders = new Set<String>();            
            
            this.quarterYearHeaders.add('YEAR-QTR');
            this.yearHeaders.add('YEAR');            
            
            //generate the column headers           
            for(CostRow y: costRows){
                this.quarterYearHeaders.add(y.quarterYear);                
                this.yearHeaders.add(y.year);                
            }
            
            //generate the cost stages
            for(String stage : enableCostStages.availableStages.get(productType)){
                this.costReportRows.add(new CostRowWrapper(costRows,stage));    
            }                                     
        }        
    }
    
    //Wrapper class for the cost row of the report
    public class CostRowWrapper {
        public List<String> quarterYearCosts {get; set;}
        public List<String> yearCosts {get; set;}
        
		public CostRowWrapper(){
		}
        public CostRowWrapper(List<CostRow> costRows, String costType){
            this.quarterYearCosts = new List<String>();                      
            this.yearCosts = new List<String>();                      
            
            Map<String,Decimal> yearCostsMap = new Map<String,Decimal>();
            Map<String,Integer> yearQuarterCountMap = new Map<String,Integer>();
            Decimal currCost = 0;                      
            
            for(Integer counter = 0; counter < costRows.size(); counter++){
                //Cost type column value
                system.debug('===========================>>> costRows=======' +costRows[counter]);
                if(counter == 0){
                    this.quarterYearCosts.add(costType);
                    
                    if(costType.contains('Volume')){
                        this.yearCosts.add('Exit Volume (Total)');    
                    } else {
                        this.yearCosts.add(costType + ' (Average)');
                    }
                }
                
                //Volume column value                
                if(costType == 'Sub solution exit Volume'){
                    if(costRows[counter].volume != NULL) {
                        this.quarterYearCosts.add(costRows[counter].volume.format()); 
                        currCost = costRows[counter].volume;
                    }
                    
                    
                    //Wafer line tailoring cost column value                    
                } else if(costType == 'Wafer line tailoring cost'){
                    this.quarterYearCosts.add('$' + costRows[counter].waferLineTailoringCost.format()); 
                    currCost = costRows[counter].waferLineTailoringCost;
                    
                    //Wafer process cost column value                    
                } else if(costType == 'Wafer process cost'){
                    this.quarterYearCosts.add('$' + costRows[counter].waferProcessCost.format());
                    currCost = costRows[counter].waferProcessCost; 
                    
                    //Wafer finishing cost column value                    
                } else if(costType == 'Wafer finishing cost'){
                    this.quarterYearCosts.add('$' + costRows[counter].waferFinishingCost.format());
                    currCost = costRows[counter].waferFinishingCost; 
                    
                    //Wafer test cost column value                    
                } else if(costType == 'Wafer test cost'){
                    this.quarterYearCosts.add('$' + costRows[counter].waferTestCost.format());
                    currCost = costRows[counter].waferTestCost;                     
                    
                    //Substrate cost column value                    
                } else if(costType == 'Substrate cost'){
                    this.quarterYearCosts.add('$' + costRows[counter].substrateCost.format());
                    currCost = costRows[counter].substrateCost; 
                    
                    //BA cost column value                    
                } else if(costType == 'Module assembly cost'){
                    this.quarterYearCosts.add('$' + costRows[counter].BACost.format());
                    currCost = costRows[counter].BACost; 
                    
                    //BI cost column value                    
                } else if(costType == 'Module Burn-in cost'){
                    this.quarterYearCosts.add('$' + costRows[counter].BICost.format());
                    currCost = costRows[counter].BICost;                                                            
                    
                    //Module test cost column value                    
                } else if(costType == 'Module test cost'){
                    this.quarterYearCosts.add('$' + costRows[counter].moduleTestCost.format());
                    currCost = costRows[counter].moduleTestCost; 
                    
                    //Allocation cost   
                } else if(costType == 'Allocations'){
                    this.quarterYearCosts.add('$' + costRows[counter].allocationCost.format()); 
                    currCost = costRows[counter].allocationCost;                                   
                    
                    //Finish goods unit cost column value                                        
                } else if(costType == 'Finish goods unit cost'){
                    this.quarterYearCosts.add('$' + costRows[counter].finishGoodsUnitCost.format()); 
                    currCost = costRows[counter].finishGoodsUnitCost;                                               
                }
                
                if(yearQuarterCountMap.containsKey(costRows[counter].year)){
                    Integer currCount = yearQuarterCountMap.get(costRows[counter].year);
                    
                    //Ravindra - Changes starts for Weighted Average  
                    ///   yearQuarterCountMap.put(costRows[counter].year,currCount+1);                   
                    if(costRows[counter].volume!=null)   {
                        yearQuarterCountMap.put(costRows[counter].year,currCount+costRows[counter].volume);  
                    }
                    
                } else {
                    //   yearQuarterCountMap.put(costRows[counter].year,1);      
                    if(costRows[counter].volume!=null)  yearQuarterCountMap.put(costRows[counter].year,costRows[counter].volume); 
                }
                //Ravindra - Changes Ends for Weighted Average  
                
                if(yearCostsMap.containsKey(costRows[counter].year)){                
                    Decimal subtotal;
                    if(costType == 'Sub solution exit Volume'){ 
                        subtotal = yearCostsMap.get(costRows[counter].year) + currCost;
                    }
                    else{
                       //Ravindra - Changes starts for Weighted Average   
                        if(costRows[counter].volume!=null)   {
                            subtotal = yearCostsMap.get(costRows[counter].year) + (currCost*costRows[counter].volume);     //Ravindra: convert Average to Weighted Average Cost
                        }
                        else {subtotal = yearCostsMap.get(costRows[counter].year); }
                        //Ravindra - Changes ends for Weighted Average  
                    }
                    yearCostsMap.put(costRows[counter].year,subtotal);
                } else {
                    if(costType == 'Sub solution exit Volume'){   
                        yearCostsMap.put(costRows[counter].year,currCost); 
                    }
                    Else{
                        if(costRows[counter].volume!=null) yearCostsMap.put(costRows[counter].year,(currCost*costRows[counter].volume));       //Ravindra: convert Average to Weighted Average Cost
                    }
                    
                }                                                    
            } 
            //   (Qtr1_Cost*Qtr1_Vol + Qtr2_Cost*Qtr2_Vol+... QtrN_Cost*QtrN_Vol)/(Qtr1_Vol+Qtr2_Vol+....QtrN_Vol)
            //get the number of quarters of the year for average
            
            for(CostRow c:costRows){
            }            
            
            for(String k: yearCostsMap.keyset()){
                Decimal val;
                if(costType == 'Sub solution exit Volume'){
                    val = yearCostsMap.get(k);
                    
                    
                    this.yearCosts.add(val.format());    
                } else {
                    val = (yearCostsMap.get(k)/yearQuarterCountMap.get(k));
                    this.yearCosts.add('$' + val.format());    
                }                            
            }                                                
        }     
    }       
    
    //wrapper class for the Configurator cost record
    public class CostRow {
        public Decimal waferProcessCost {get; set;}
        public Decimal waferFinishingCost {get; set;}
        public Decimal waferTestCost {get; set;}
        public Decimal substrateCost {get; set;}        
        public Decimal BACost {get; set;}        
        public Decimal BICost {get; set;}        
        public Decimal moduleTestCost {get; set;}        
        public Decimal waferLineTailoringCost {get; set;}
        public Decimal finishGoodsUnitCost {get; set;}
        public Decimal allocationCost {get; set;}        
        public Integer volume {get; set;}        
        public String quarterYear;
        public String year;
        private Configurator_Cost__c  cost;          
        
        public CostRow(Configurator_Cost__c cost){            
            this.cost = cost;                        
            this.volume = Integer.valueOf(cost.volume__c);
            this.quarterYear = cost.year__c + cost.quarter__c;
            this.year = cost.year__c;
            
            this.WaferLineTailoringCost = 0;
            this.waferProcessCost = cost.calculated_total_wafer_processing_cost__c;
            this.waferFinishingCost = cost.calculated_total_wafer_finishing_cost__c;
            this.waferTestCost = cost.calculated_total_wafer_test_cost__c;
            this.substrateCost = cost.calculated_total_substrate_cost__c;
            this.BACost = cost.calculated_total_module_assembly_cost__c;
            this.BICost = cost.calculated_total_module_burn_in_cost__c;
            this.moduleTestCost = cost.calculated_total_module_test_cost__c;            
            this.allocationCost = cost.calculated_total_allocation_cost__c;
            this.finishGoodsUnitCost = cost.finish_goods_unit_cost__c;                      
        }                
    }
    
    //Wrapper class for the yield section of the report
    public class YieldWrapper {
        public List<YieldRowWrapper> yieldReportRows {get; set;}
        public List<String> quarterYearHeaders {get; set;}
        
        public YieldWrapper(List<YieldRow> yieldRows,String productType,EnableYieldStages enableYieldStages){
            this.yieldReportRows = new List<YieldRowWrapper>();
            this.quarterYearHeaders = new List<String>();
            this.quarterYearHeaders.add('YEAR-QTR');
            
            for(YieldRow y: yieldRows){
                this.quarterYearHeaders.add(y.quarterYear);                
            }
            
            //generate the yield stages
            for(String stage : enableYieldStages.availableStages.get(productType)){
                this.yieldReportRows.add(new YieldRowWrapper(yieldRows,stage));    
            }                      
        }        
    }
    
    //Wrapper class for the yield row of the report
    public class YieldRowWrapper {
        public List<String> yields {get; set;}
        
        public YieldRowWrapper(List<YieldRow> yieldRows, String yieldType){
            this.yields = new List<String>();  
            
            for(Integer counter = 0; counter < yieldRows.size(); counter++){
                if(counter == 0){
                    this.yields.add(yieldType);
                }
                
                if(yieldType == 'KERF X'){
                    this.yields.add(String.valueOf(yieldRows[counter].KERFX)); 
                } else if(yieldType == 'KERF Y'){
                    this.yields.add(String.valueOf(yieldRows[counter].KERFY)); 
                } else if(yieldType == 'CPW'){
                    this.yields.add(String.valueOf(yieldRows[counter].CPW)); 
                } else if(yieldType == 'FEOL'){
                    this.yields.add(String.valueOf(yieldRows[counter].FEOLYield)); 
                } else if(yieldType == 'BEOL PRE'){
                    this.yields.add(String.valueOf(yieldRows[counter].BEOLPREYield)); 
                } else if(yieldType == 'BEOL POST'){
                    this.yields.add(String.valueOf(yieldRows[counter].BEOLPOSTYield)); 
                } else if(yieldType == 'WFT'){
                    this.yields.add(String.valueOf(yieldRows[counter].waferTestYield)); 
                } else if(yieldType == 'LYH'){
                    this.yields.add(String.valueOf(yieldRows[counter].LYH)); 
                } else if(yieldType == 'GCPW'){
                    this.yields.add(String.valueOf(yieldRows[counter].GCPW)); 
                } else if(yieldType == 'BA'){
                    this.yields.add(String.valueOf(yieldRows[counter].BA)); 
                } else if(yieldType == 'BI'){
                    this.yields.add(String.valueOf(yieldRows[counter].BI)); 
                } else if(yieldType == 'TEST'){
                    this.yields.add(String.valueOf(yieldRows[counter].moduleTestYield)); 
                } else if(yieldType == 'GMPW'){
                    this.yields.add(String.valueOf(yieldRows[counter].GMPW)); 
                }
            }                                                
        }     
    }
    
    public class YieldRow {
        public Decimal FEOLYield;
        public Decimal BEOLPREYield;
        public Decimal BEOLPOSTYield;
        public Decimal waferTestYield;
        public Decimal LYH;
        public Decimal BA;
        public Decimal BI;
        public Decimal moduleTestYield;
        public Decimal CPW;
        public Decimal KERFX;
        public Decimal KERFY;
        public Decimal GCPW;
        public Decimal GMPW;
        public String quarterYear;
        
        public YieldRow(Configurator_Yield__c yield,Apttus_Proposal__Proposal__c config){
            this.quarterYear = yield.year__c + yield.quarter__c;
            this.FEOLYield = yield.FEOL_Yield__c <> null ? yield.FEOL_Yield__c.setScale(5) : 0;
            this.BEOLPREYield = yield.BEOL_PRE_Yield__c <> null ? yield.BEOL_PRE_Yield__c.setScale(5) : 0;
            this.BEOLPOSTYield = yield.BEOL_POST_Yield__c <> null ? yield.BEOL_POST_Yield__c.setScale(5) : 0;
            this.waferTestYield = yield.wafer_test_yield__c <> null ? yield.wafer_test_yield__c.setScale(5) : 0;
            this.CPW = yield.CPW__c <> null ? yield.CPW__c.setScale(5) : 0;
            this.LYH = yield.LYH__c <> null ? yield.LYH__c.setScale(5) : 0;
            this.BA = yield.BA__c <> null ? yield.BA__c.setScale(5) : 0;
            this.BI = yield.BI__c <> null ? yield.BI__c.setScale(5) : 0;
            this.moduleTestYield = yield.module_test_yield__c <> null ? yield.module_test_yield__c.setScale(5) : 0;
            this.KERFX = yield.KERF_X__c <> null ? yield.KERF_X__c.setScale(5) : 0;
            this.KERFY = yield.KERF_Y__c <> null ? yield.KERF_Y__c.setScale(5) : 0;
            this.GCPW = yield.GCPW__c <> null ? yield.GCPW__c.setScale(5) : 0;
            this.GMPW = yield.GMPW__c <> null ? yield.GMPW__c.setScale(5) : 0;
        }
    }        
    
    //Wrapper class for enabling the different Cost Stages
    public class EnableYieldStages {
        public Map<String,Set<String>> availableStages;
        
        public EnableYieldStages(String productType, String relgrade){
            this.availableStages = new Map<String,Set<String>>();
            
            //Wafer
            Set<String> waferSet = new Set<String>{
                'FEOL' 
                    };
                        this.availableStages.put('Wafer',waferSet);
            
            //Finished Wafer
            Set<String> finishedWaferSet = new Set<String>{
                'FEOL',
                    'BEOL PRE',
                    'BEOL POST'
                    };
                        this.availableStages.put('Finished Wafer',finishedWaferSet);                                               
            
            //Tested Wafer and Chip
            Set<String> testedWaferAndChipSet = new Set<String>{
                'KERF X',
                    'KERF Y',
                    'CPW',
                    'FEOL',
                    'BEOL PRE',
                    'BEOL POST',
                    'WFT',
                    'LYH',
                    'GCPW'
                    };
                        this.availableStages.put('Tested Wafer',testedWaferAndChipSet);           
            this.availableStages.put('Chip',testedWaferAndChipSet); 
            
            //Module
            Set<String> moduleSet = new Set<String>{
                'KERF X',
                    'KERF Y',
                    'CPW',
                    'FEOL',
                    'BEOL PRE',
                    'BEOL POST',
                    'WFT',
                    'LYH',
                    'GCPW',
                    'BA'                
                    };
                        
                        if(Integer.valueOf(relgrade) >=5){
                            moduleSet.add('BI');
                        }
            
            moduleSet.add('TEST');
            moduleSet.add('GMPW');                        
            
            this.availableStages.put('Module',moduleSet);           
            
            //MCM
            Set<String> mcmSet = new Set<String>{
                'KERF X',
                    'KERF Y',
                    'CPW',
                    'FEOL',
                    'BEOL PRE',
                    'BEOL POST',
                    'WFT',
                    'LYH',
                    'GCPW',
                    'BA'                
                    };
                        
                        if(Integer.valueOf(relgrade) >=5){
                            mcmSet.add('BI');
                        }
            
            mcmSet.add('TEST');
            mcmSet.add('GMPW');                        
            
            this.availableStages.put('MCM',mcmSet);           
        }
    }
    
    //Wrapper class for enabling the different Cost Stages
    public class EnableCostStages {
        public Map<String,Set<String>> availableStages;
        
        public EnableCostStages(String productType, String relgrade){
            this.availableStages = new Map<String,Set<String>>();
            
            //Wafer
            Set<String> waferSet = new Set<String>{
                'Sub solution exit Volume',
                    'Wafer line tailoring cost',  
                    'Wafer process cost',
                    'Allocations',
                    'Finish goods unit cost' 
                    };
                        this.availableStages.put('Wafer',waferSet);
            
            //Finished Wafer
            Set<String> finishedWaferSet = new Set<String>{
                'Sub solution exit Volume',
                    'Wafer line tailoring cost',  
                    'Wafer process cost',
                    'Wafer finishing cost',
                    'Allocations',
                    'Finish goods unit cost' 
                    };
                        this.availableStages.put('Finished Wafer',finishedWaferSet); 
            
            //Tested Wafer and Chip
            Set<String> testedWaferChipSet = new Set<String>{
                'Sub solution exit Volume',
                    'Wafer line tailoring cost',  
                    'Wafer process cost',
                    'Wafer finishing cost',
                    'Wafer test cost',
                    'Allocations',
                    'Finish goods unit cost' 
                    };
                        this.availableStages.put('Tested Wafer',testedWaferChipSet);                                                 
            this.availableStages.put('Chip',testedWaferChipSet);  
            
            //Module
            Set<String> moduleSet = new Set<String>{
                'Sub solution exit Volume',
                    'Wafer line tailoring cost',  
                    'Wafer process cost',
                    'Wafer finishing cost',
                    'Wafer test cost',
                    'Substrate cost',
                    'Module assembly cost'                                              
                    };
                        
                        if(Integer.valueOf(relgrade) >=5){
                            moduleSet.add('Module Burn-in cost');
                        }
            
            moduleSet.add('Module test cost');
            moduleSet.add('Allocations');
            moduleSet.add('Finish goods unit cost');
            
            this.availableStages.put('Module',moduleSet);          
            //MCM
            Set<String> mcmSet = new Set<String>{
                'Sub solution exit Volume',
                    'Wafer line tailoring cost',  
                    'Wafer process cost',
                    'Wafer finishing cost',
                    'Wafer test cost',
                    'Substrate cost',
                    'Module assembly cost'                                              
                    };
                        
                        if(Integer.valueOf(relgrade) >=5){
                            mcmSet.add('Module Burn-in cost');
                        }
            
            mcmSet.add('Module test cost');
            mcmSet.add('Allocations');
            mcmSet.add('Finish goods unit cost');
            
            this.availableStages.put('MCM',mcmSet);         
        }
    }
    // sSHarma1 - START Case#00074950
    public void calcuateWaferStarts(){
		/*
		CostWrapper.List<CostRowWrapper>.List<String>

			costData.	costReportRows.    yearCosts
		*/
		CostRowWrapper gmpwAvg = new CostRowWrapper();
		gmpwAvg.yearCosts = new List<String>{'GMPW (Average)'};
        
		CostRowWrapper waferStarts = new CostRowWrapper();
		waferStarts.yearCosts = new List<String>{'Wafer Starts'};
        
		
        List<String> qtrYrVolumes = new List<String>();
        List<String> qtrYrGMPWs = new List<String>();
        for(CostRowWrapper crw: costData.costReportRows){
            if(crw.quarterYearCosts != null && crw.quarterYearCosts.size() >0 && crw.quarterYearCosts[0] == 'Sub solution exit Volume'){
                qtrYrVolumes.addAll(crw.quarterYearCosts);
            }
        }
        for(YieldRowWrapper yrw : yieldData.yieldReportRows){
            if(yrw.yields != null && yrw.yields.size() > 0 && yrw.yields[0] == 'GMPW'){
                qtrYrGMPWs.addAll(yrw.yields);
            }
        }
        if(qtrYrGMPWs.size() == 0 || qtrYrGMPWs.size() != qtrYrVolumes.size() || qtrYrGMPWs.size() != costData.quarterYearHeaders.size())
			return;
        
        Map<String, Decimal> volumesByYear = new Map<String, Decimal>();
        Map<String, Decimal> GMPW_X_VolumesByYear = new Map<String, Decimal>();
        
        for(Integer i=1; i< costData.quarterYearHeaders.size(); i++){
                String year = costData.quarterYearHeaders[i].split('Q')[0];
                Decimal vol = 0;
                Decimal gmpw_X_vol = 0;
                if(volumesByYear.containsKey(year)){
                    vol = volumesByYear.get(year);
                    gmpw_X_vol = GMPW_X_VolumesByYear.get(year);
                }   
                volumesByYear.put(year, vol + Decimal.valueOf(qtrYrVolumes[i].replaceAll('[^.\\d]','')));
                GMPW_X_VolumesByYear.put(year, gmpw_X_vol + (Decimal.valueOf(qtrYrVolumes[i].replaceAll('[^.\\d]','')) * Decimal.valueOf(qtrYrGMPWs[i].replaceAll('[^.\\d]',''))));
        }
        
        for(String year : volumesByYear.keySet()){
            if(volumesByYear.get(year) != 0){
                gmpwAvg.yearCosts.add(String.valueOf((GMPW_X_VolumesByYear.get(year)/volumesByYear.get(year)).setScale(5)));
                if(GMPW_X_VolumesByYear.get(year) != 0)
					waferStarts.yearCosts.add(String.valueOf((volumesByYear.get(year) * volumesByYear.get(year) / GMPW_X_VolumesByYear.get(year)).setScale(3)));
				else
					waferStarts.yearCosts.add('Not defined');
            }else{
                gmpwAvg.yearCosts.add('Not defined');
                waferStarts.yearCosts.add('Not defined');
            }
        }
		costData.costReportRows.add(gmpwAvg);
		costData.costReportRows.add(waferStarts);
    }
    //sSharma1 - END Case#00074950
}