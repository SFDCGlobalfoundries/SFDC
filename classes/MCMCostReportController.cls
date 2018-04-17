public class MCMCostReportController {
    
    public final PCM_MCM_DEtail__c currMCM { get; set; }
    public CostWrapper costDataBefore {get; set;}
    public CostWrapper costDataAfter {get; set;}
    public CostWrapper qtrVolumeData {get; set;}
    public CostWrapper costDataConf {get; set;}
    public List<CostWrapper> lstCostDataConf {get; set;}
    public Boolean isPDF {get; set;}
    public  Boolean isExcel {get; set;}
    private EnableCostStages enableCostStagesBefore;
    private EnableCostStages enableCostStagesAfter;
    private EnableCostStages enableCostStagesConf;
    public list<PCM_MCM_DEtail__c> mcm_id {get;set;}
    public String deviceName {get;set;}   
    public Id mcmId;
    public Id deviceId; 
    public List<Integer> confRecCount {get;set;}
    public Integer cnt;
    public List<String> confProcessTechName {get;set;}
   
   public MCMCostReportController(){
         this.currMCM = new PCM_MCM_DEtail__c(); 
          
                    mcmId = ApexPages.currentPage().getParameters().get('mcmId');
       deviceId = ApexPages.currentPage().getParameters().get('Id');//Parent Device Id
        this.currMCM.Id = mcmId;
     
      mcm_id =  [Select id,device__r.name,device__c from PCM_MCM_Detail__c where id=: this.currMCM.Id ];
      deviceName = mcm_id[0].device__r.name;  
        List<CostRow> costRowsBefore = new List<CostRow>();
        List<CostRow> costRowsAfter = new List<CostRow>();
        List<CostRow> qtrVolumeRows = new List<CostRow>();
        List<CostRow> costRowsConf;
        confRecCount= new List<Integer>();
        lstCostDataConf = new List<CostWrapper>();
        confProcessTechName= new List<String>();
        if(apexpages.currentpage().getparameters().get('rendertype') == 'pdf'){
            this.isPDF = true;
        } else if(apexpages.currentpage().getparameters().get('rendertype') == 'excel'){               
            this.isExcel = true;
        }
        
        this.enableCostStagesBefore = new EnableCostStages('MCM Before');
        this.enableCostStagesAfter = new EnableCostStages('MCM After');
        this.enableCostStagesConf= new EnableCostStages('MCM Configurations');
        this.enableCostStagesConf= new EnableCostStages('MCM QTR Volume');
        
        for(MCM_Reporting_Data__c c: [SELECT quarter__c,year__c,Cost__c, Cost_Type__c
                                      FROM MCM_Reporting_Data__c 
                                      WHERE mcm__C = :this.currMCM.id 
                                      AND Cost_Type__c LIKE '%before%'
                                      ORDER BY year__c,quarter__c]){
                                          
                                          costRowsBefore.add(new CostRow(c,this.currMCM));
                                          
                                      }
        
         for(MCM_Reporting_Data__c c: [SELECT quarter__c,year__c,Cost__c, Cost_Type__c
                                      FROM MCM_Reporting_Data__c 
                                      WHERE mcm__C = :this.currMCM.id 
                                      AND (Cost_Type__c LIKE '%after%'  OR Cost_Type__c='MCM Finished Good Cost' OR Cost_Type__c='Device Cost')
                                      ORDER BY year__c,quarter__c]){
                                          
                                          costRowsAfter.add(new CostRow(c,this.currMCM));
                                          
                                      }
       
         for(MCM_Reporting_Data__c c: [SELECT quarter__c,year__c,Ship_Quantity__c, Cost_Type__c
                                      FROM MCM_Reporting_Data__c 
                                      WHERE mcm__C = :this.currMCM.id 
                                      AND (Cost_Type__c='MCM Quarterly Volume')
                                      ORDER BY year__c,quarter__c]){
                                          
                                          qtrVolumeRows.add(new CostRow(c,this.currMCM));
                                          
                                      }
        cnt=0;
        for (MCM_Configuration_Detail__c conf:[Select id,Configuration__c,Configuration__r.name,Configuration__r.process_Technology_name__c ,Chip_per_Technology__c
                                            FROM MCM_Configuration_Detail__c 
                                            WHERE PCM_MCM_MCM__c= :this.currMCM.id ]) {
                                                costRowsConf = new List<CostRow>();
                                                confRecCount.add(cnt);
                                                confProcessTechName.add(conf.Configuration__r.name +' - '+conf.Configuration__r.process_Technology_name__c + '  (No. of Chips per Unit - '  + conf.Chip_per_Technology__c+')' );
                                                cnt++;
                                                
                                                for(MCM_Reporting_Data__c c: [SELECT quarter__c,year__c,Ship_Quantity__c, Cost_Type__c,Cost__c
                                                                              FROM MCM_Reporting_Data__c 
                                                                              WHERE mcm__C = :this.currMCM.id 
                                                                              AND Cost_Type__c LIKE 'Configuration-%' 
                                                                              AND Configuration__c =:conf.Id 
                                                                              ORDER BY year__c,quarter__c asc]){
                                                                                  
                                                                                  costRowsConf.add(new CostRow(c,this.currMCM));
                                                                                  
                                                                              }
                                                 this.costDataConf = new CostWrapper(costRowsConf,'MCM Configurations',this.enableCostStagesConf);  
                                                lstCostDataConf.add(costDataConf);
                                            }
      
            
        this.costDataBefore = new CostWrapper(costRowsBefore,'MCM Before',this.enableCostStagesBefore);  
        this.costDataAfter = new CostWrapper(costRowsAfter,'MCM After',this.enableCostStagesAfter);  
this.qtrVolumeData = new CostWrapper(qtrVolumeRows,'MCM Quarterly Volume',this.enableCostStagesAfter);                                         
      
    }  
    
    
    //Wrapper class for the cost section of the report
    public class CostWrapper {
        public List<CostRowWrapper> costReportRows {get; set;}
        public Set<String> quarterYearHeaders {get; set;}
        public Set<String> yearHeaders {get; set;}
        public map<String,List<CostRow>> myMap;
        public List <CostRow> biBefore = new  List <CostRow>();
        public List <CostRow> biAfter = new  List <CostRow>();
        public List <CostRow> sbBefore = new  List <CostRow>();
        public List <CostRow> sbAfter = new  List <CostRow>();
        public List <CostRow> modBefore = new  List <CostRow>();
        public List <CostRow> modafter = new  List <CostRow>();
        public List <CostRow> modFinished= new  List <CostRow>();
        public List <CostRow> ConfigData= new  List <CostRow>();
        public List <CostRow> ConfigUCData= new  List <CostRow>();
        public List <CostRow> deviceCostData= new  List <CostRow>();
        public List <CostRow> qtrVolumeData= new  List <CostRow>();
        public CostWrapper(List<CostRow> costRows,String productType,EnableCostStages enableCostStages){
            this.costReportRows = new List<CostRowWrapper>();
            this.quarterYearHeaders = new set<String>();
            this.yearHeaders = new Set<String>();            
            this.myMap = new map<String,List<CostRow>>();
            this.quarterYearHeaders.add('YEAR-QTR');
            this.yearHeaders.add('YEAR');            
            
            //generate the column headers           
            for(CostRow y: costRows){
                this.quarterYearHeaders.add(y.quarterYear);                
                this.yearHeaders.add(y.year);        
                
                if(y.costType == 'Assembly & Substrate Cost (before Yield)' ){
                    sbBefore.add(y);
                }
                else if (y.costType == 'Assembly & Substrate Cost (after Yield)' ){
                    sbAfter.add(y);
                }
                else if (y.costType == 'Burn-In Cost (before Yield)' ){
                    biBefore.add(y);
                }
                else if (y.costType =='Burn-In Cost (after Yield)' ){
                    biAfter.add(y);
                }
                else if (y.costType == 'Module Test Cost (before Yield)' ){
                    modBefore.add(y);
                }
                else if (y.costType == 'Module Test Cost (after Yield)' ){
                    modafter.add(y);
                }
                else if (y.costType == 'MCM Finished Good Cost' ){
                    modFinished.add(y);
                }
                else if (y.costType == 'Configuration-Ship Quantity' ){
                    ConfigData.add(y);
                }
                 else if (y.costType == 'Configuration-Unit Cost' ){
                    ConfigUCData.add(y);
                }
                 else if (y.costType == 'Device Cost' ){
                    deviceCostData.add(y);
                }
                else if (y.costType == 'MCM Quarterly Volume' ){
                    qtrVolumeData.add(y);
                }
            }
            myMap.put('Assembly & Substrate Cost (before Yield)' ,sbBefore);
            myMap.put('Assembly & Substrate Cost (after Yield)' ,sbAfter);
            myMap.put('Burn-In Cost (before Yield)' ,biBefore);
            myMap.put('Burn-In Cost (after Yield)' ,biAfter);
            myMap.put('Module Test Cost (before Yield)' ,modBefore);
            myMap.put('Module Test Cost (after Yield)' ,modafter);
             myMap.put('MCM Finished Good Cost' ,modFinished);
             myMap.put('Configuration-Ship Quantity' ,ConfigData);
            myMap.put('Configuration-Unit Cost' ,ConfigUCData);
            myMap.put('Device Cost' ,deviceCostData);
            myMap.put('MCM Quarterly Volume', qtrVolumeData);
            
            //generate the cost stages
            for(String stage : enableCostStages.availableStages.get(productType)){
                this.costReportRows.add(new CostRowWrapper(myMap.get(stage)));    
            }     
            
        }        
    }
    
    //Wrapper class for the cost row of the report
    public class CostRowWrapper {
        public List<String> quarterYearCosts {get; set;}
        public List<String> yearCosts {get; set;}
        
        public CostRowWrapper(List<CostRow> costRows){
            this.quarterYearCosts = new List<String>();                      
            this.yearCosts = new List<String>();                      
            
            Map<String,Decimal> yearCostsMap = new Map<String,Decimal>();
            Map<String,Integer> yearQuarterCountMap = new Map<String,Integer>();
            Decimal currCost = 0;                      
            Integer biCounterBefore=0;
            Integer biCounterAfter=0;
            Integer modTstCounterBefore=0;
            Integer modTstCounterAfter=0;
            Integer sbstCounterBefore=0;
            Integer sbstCounterAfter=0;
          
           
            for(Integer counter = 0; counter < costRows.size(); counter++){
                //Cost type column value
                if(counter == 0){
                    this.quarterYearCosts.add(costRows[counter].costType);
                         
                }
                
                //Assemble & Substrate cost after applying Yield column value              
                if(costRows[counter].costType == 'Assembly & Substrate Cost (before Yield)' ){
                    this.quarterYearCosts.add('$' + costRows[counter].substrateCostBefore.format());
                    currCost = costRows[counter].substrateCostBefore; 
                }
                //Assemble & Substrate cost after applying Yield column value                    
                else if(costRows[counter].costType == 'Assembly & Substrate Cost (after Yield)' ){
                    this.quarterYearCosts.add('$' + costRows[counter].substrateCostAfter.format());
                    currCost = costRows[counter].substrateCostAfter; 
                                                            
                    //BI cost before applying Yield column value                    
                } else if(costRows[counter].costType == 'Burn-In Cost (before Yield)' ){
                    this.quarterYearCosts.add('$' + costRows[counter].BICostBefore.format());
                    currCost = costRows[counter].BICostBefore;  
                    
                    //BI cost after applying Yield column value                    
                } else if(costRows[counter].costType == 'Burn-In Cost (after Yield)'){
                    this.quarterYearCosts.add('$' + costRows[counter].BICostAfter.format());
                    currCost = costRows[counter].BICostAfter;    
                    
                    //Module test cost column value                    
                } else if(costRows[counter].costType == 'Module Test Cost (before Yield)' ){
                    this.quarterYearCosts.add('$' + costRows[counter].moduleTestCostBefore.format());
                    currCost = costRows[counter].moduleTestCostBefore; 
                    
                    //Module test cost column value                    
                } else if(costRows[counter].costType == 'Module Test Cost (after Yield)' ){
                    this.quarterYearCosts.add('$' + costRows[counter].moduleTestCostAfter.format());
                    currCost = costRows[counter].moduleTestCostAfter; 
                }
                else if(costRows[counter].costType == 'MCM Finished Good Cost' ){
                    this.quarterYearCosts.add('$' + costRows[counter].finishGoodsUnitCost.format());
                    currCost = costRows[counter].moduleTestCostAfter; 
                }   
                 else if(costRows[counter].costType == 'Configuration-Ship Quantity' ){
                    this.quarterYearCosts.add(costRows[counter].confShipQty.format());
                    currCost = costRows[counter].moduleTestCostAfter; 
                }  
                else if(costRows[counter].costType == 'Configuration-Unit Cost' ){
                    this.quarterYearCosts.add(costRows[counter].confUnitCost.format());
                
                }  
                 else if(costRows[counter].costType == 'Device Cost' ){
                    this.quarterYearCosts.add(costRows[counter].deviceCost.format());
                
                }  
                else if(costRows[counter].costType == 'MCM Quarterly Volume' ){
                    this.quarterYearCosts.add(costRows[counter].qtrVolume.format());
                
                }  
                //==============================
                if(yearQuarterCountMap.containsKey(costRows[counter].year)){
                    Integer currCount = yearQuarterCountMap.get(costRows[counter].year);
                    yearQuarterCountMap.put(costRows[counter].year,currCount+1);  
                } else {
                    yearQuarterCountMap.put(costRows[counter].year,1);      
                }               
                
                if(yearCostsMap.containsKey(costRows[counter].year)){                
                    Decimal subtotal = yearCostsMap.get(costRows[counter].year) + currCost;
                    yearCostsMap.put(costRows[counter].year,subtotal);
                } else {
                    yearCostsMap.put(costRows[counter].year,currCost); 
                }    
                
                //===========================  
                
            } 
        
        //get the number of quarters of the year for average                                            
    }     
}       

//wrapper class for the Configurator cost record
public class CostRow {
    public Decimal substrateCostBefore {get; set;} 
    public Decimal substrateCostAfter {get; set;} 
    public Decimal BICostBefore {get; set;}   
    public Decimal BICostAfter {get; set;}   
    public Decimal moduleTestCostBefore {get; set;}        
    public Decimal moduleTestCostAfter {get; set;}   
    public Decimal confUnitCost{get;set;}
    public Integer volume {get; set;}        
    public String quarterYear;
    public String year;
     public Decimal finishGoodsUnitCost {get; set;}
    public Integer confShipQty {get;set;}
    public Integer qtrVolume {get;set;}
    public Decimal deviceCost{get;set;}
    private MCM_Reporting_Data__c  cost;
    
    private PCM_MCM_Detail__c config;
    public String costType {get;set;}   
    
    public CostRow(MCM_Reporting_Data__c cost,PCM_MCM_Detail__c config){            
        this.substrateCostBefore = 0;
        this.substrateCostAfter = 0;
        this.BICostBefore = 0;
        this.BICostAfter = 0;
        this.moduleTestCostBefore = 0;            
        this.moduleTestCostAfter = 0;            
        this.cost = cost;
        this.config = config;
        this.volume = 0;
        this.quarterYear = cost.year__c + cost.quarter__c;
        this.year = cost.year__c;
        this.costType = cost.Cost_Type__c;
        this.finishGoodsUnitCost =0;
        this.confShipQty=0;
        this.confUnitCost =0.0;
        this.deviceCost=0.0;
        this.qtrVolume=0;
        if(cost.Cost_Type__c == 'Burn-In Cost (before Yield)'){
            this.BICostBefore = cost.Cost__c;
        }
        else if(cost.Cost_Type__c == 'Burn-In Cost (after Yield)'){
            this.BICostAfter = cost.Cost__c;
        }
        else if(cost.Cost_Type__c == 'Assembly & Substrate Cost (before Yield)'){
            this.substrateCostBefore = cost.Cost__c;
        }
        else if(cost.Cost_Type__c == 'Assembly & Substrate Cost (after Yield)'){
            this.substrateCostAfter = cost.Cost__c;
        }
        else if(cost.Cost_Type__c == 'Module Test Cost (before Yield)'){
            this.moduleTestCostBefore = cost.Cost__c;
        }
        else if(cost.Cost_Type__c == 'Module Test Cost (after Yield)'){
            this.moduleTestCostAfter = cost.Cost__c;
        }
        
        else if(cost.Cost_Type__c == 'MCM Finished Good Cost'){
            this.finishGoodsUnitCost = cost.Cost__c;
        }
        
        else if(cost.Cost_Type__c == 'Configuration-Ship Quantity'){
            this.confShipQty = Integer.valueOf(cost.Ship_Quantity__c);
        }
        else if(cost.Cost_Type__c == 'Configuration-Unit Cost'){
            this.confUnitCost = cost.Cost__c;
        }
        else if(cost.Cost_Type__c == 'Device Cost'){
            this.deviceCost = cost.Cost__c;
        }
         else if(cost.Cost_Type__c == 'MCM Quarterly Volume'){
            this.qtrVolume = Integer.valueOf(cost.Ship_Quantity__c);
        }
    }
}

//Wrapper class for the yield row of the report


//Wrapper class for enabling the different Cost Stages
public class EnableCostStages {
    public Map<String,Set<String>> availableStages;
    
    public EnableCostStages(String productType){
        this.availableStages = new Map<String,Set<String>>();
        
        Set<String> mcmSetBefore = new Set<String>{
            'Assembly & Substrate Cost (before Yield)',
                'Burn-In Cost (before Yield)',
                'Module Test Cost (before Yield)'

                };
                    this.availableStages.put('MCM Before',mcmSetBefore);
        
         Set<String> mcmSetAfter = new Set<String>{
               'Assembly & Substrate Cost (after Yield)' ,  
                'Burn-In Cost (after Yield)' ,   
                'Module Test Cost (after Yield)',   
                   'Device Cost',
               'MCM Finished Good Cost'
                };
                 this.availableStages.put('MCM After',mcmSetAfter);
       
        Set<String> mcmConfQtrVol = new Set<String>{
               'Configuration-Ship Quantity',
                   'Configuration-Unit Cost'
                };
                    this.availableStages.put('MCM Configurations',mcmConfQtrVol);
        
        Set<String> mcmQtrVol = new Set<String>{
               'MCM Quarterly Volume'
                 
                };
                    this.availableStages.put('MCM Quarterly Volume',mcmQtrVol);
    }
}
 // This method takes the user to MCM Detail page.
    public pagereference redirectToMCMDetail(){   
      PageReference pr;
      if(Apexpages.currentPage().getHeaders().get('Referer').contains('GlobalfoundryView')){          
        pr = new PageReference('/GlobalfoundryView/apex/MCMDetailPage?id='+mcm_id[0].device__c);
      }else{
        pr = new PageReference(URL.getSalesforceBaseUrl().toExternalForm()+'/apex/MCMDetailPage?id='+mcm_id[0].device__c);
      }
      return pr;
    } 
   
}