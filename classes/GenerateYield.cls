/*
    Author: Anirban Roy
    Description: Apex class logic for generating quarter year yields for configurations 
    History: 
        ARoy     11102016    - Code creation.                                   
*/
public class GenerateYield {
    
    //Static Variables
    static PCM_Administration__c pcmAdminSetting = PCM_Administration__c.getInstance('CURRENT_SETTING');
    static Decimal totalWaferTestTime=0.0;
    static Decimal totalModuleTestTime=0.0;
    static Set<String> configQtrSet = new Set<String>();
    static List<String> alphaQtr = new List<String>(); 
    static String thisQuarter; 
    static String yrStr;  
    static Boolean isDRAMSelected;
    //Method will generate the quarter year yield calculations
    public static Map<String,GenerateYieldAndCost.YieldHeader> generate(GenerateYieldAndCost.ConfigDetail config){
                                                                  
        Map<String,GenerateYieldAndCost.YieldHeader> yieldHeaderMap = new Map<String,GenerateYieldAndCost.YieldHeader>(); 
        //get the PCM yield tables based on the configuration parameters        
        List<PCM_Yield__c> yields = new List<PCM_Yield__c>();
        
      
        //first query for technology dependent yields
        List<PCM_Yield__c> techYields = [SELECT id,yield__c,recordType.name,quarter__c,year__c,layer_of_metal__c,
                                            bonding__c,Solder_Type__c,Solder__c,BLM_Size_Type__c,Minimum_C4_Pitch__c
                                           FROM PCM_Yield__c
                                           WHERE fab__c = :config.fab
                                           AND Catalog_ID__c =:pcmAdminSetting.Catalog_ID__c
                                           AND Version__c =:pcmAdminSetting.Version_ID__c
                                           AND PT_number__c = :config.PTNumber
                                           AND year__c IN :config.years 
                                           ORDER BY year__c,quarter__c];
        
      
        //second query for non-technology dependent yields
        List<PCM_Yield__c> nonTechYields = [SELECT id,yield__c,recordType.name,quarter__c,year__c,
                                                bonding__c,Solder_Type__c,Solder__c,BLM_Size_Type__c,Minimum_C4_Pitch__c
                                              FROM PCM_Yield__c
                                              WHERE fab__c = :config.postFabService.fab__c
                                              AND Catalog_ID__c =:pcmAdminSetting.Catalog_ID__c
                                              AND Version__c =:pcmAdminSetting.Version_ID__c
                                              AND recordType.name IN ('BEOL PRE','BEOL POST')
                                              AND year__c IN :config.years 
                                              ORDER BY year__c,quarter__c];         
                                                                                  
        yields.addAll(techYields);
        yields.addAll(nonTechYields);
        
        for(PCM_Yield__c y: yields){
                              
            //create yield header
            String key = y.year__c + y.quarter__c;            
            Boolean addToMap = false;             
            //config layer of metal = PCM table layer of metal             
            if(y.recordType.name == 'FEOL'){
                if(config.metalLayers == y.layer_of_metal__c){
                    addToMap = true;
                }
            } else if(y.recordType.name == 'BEOL PRE' || y.recordType.name == 'BEOL POST'){             
                if(!config.postFabServices.isEmpty() && config.postFabServices[0].bonding == y.bonding__c
                  && config.postFabServices[0].BLMSizeType == y.BLM_Size_Type__c && config.postFabServices[0].minC4Pitch == y.Minimum_C4_Pitch__c
                  && config.postFabServices[0].solder == y.Solder__c && config.postFabServices[0].solderType == y.Solder_Type__c){
                    addToMap = true;
                } 
                
            } else {
                addToMap = true;
            }            
            if(addToMap){
                if(yieldHeaderMap.containsKey(key)){
                    yieldHeaderMap.get(key).addYieldValue(y);
                } else {
                    yieldHeaderMap.put(key,new GenerateYieldAndCost.YieldHeader(config,y));    
                    yieldHeaderMap.get(key).addYieldValue(y);
                }
            }                                                                                                                                      
        }
        
        List<Configurator_Test_Pass__c> ctpList = new List<Configurator_Test_Pass__c>();
        if(config.productType != 'Wafer' && config.productType != 'Finished Wafer'){
            //Wafer Test, CPW and Test Time Calculation
            yieldHeaderMap = waferTestCalc(config,yieldHeaderMap);
            
            // Calling the test pass calculation for wafer
            List<Configurator_Test_Pass__c> ctpWafTest = createConfigWafTestPass(config,'WAF_TST');
            if(ctpWafTest!=null && ctpWafTest.size()>0){
                ctpList.addAll(ctpWafTest);
            } 
            
            //Wafer Cap Req Calculation
            yieldHeaderMap = populateCapReq(config,yieldHeaderMap);
        
            //LYH Calculation
            lyhCalculate(config,yieldHeaderMap);
        
            //GCPW Calculation
            gcpwCalculate(yieldHeaderMap); 
        }        
        
        if(config.productType == 'Chip' || config.productType == 'Module' 
                || config.productType == 'MCM'){
            
 
            // Calling the test pass calculation for module
            List<Configurator_Test_Pass__c> ctpModTest = createConfigModTestPass(config,'MOD_TST');
            if(ctpModTest!=null && ctpModTest.size()>0){
                ctpList.addAll(ctpModTest);
            }
            
            //BA calculation
            baYieldCalculate(config,yieldHeaderMap);
            
            //Module Test Yield Calculation
            modYieldCalculate(config,yieldHeaderMap);
        
            if(Decimal.valueOf(config.relgrade)>=5){
                //BI Yield Calculation
                biYieldCalculate(config,yieldHeaderMap);
            
                //BI Cap Req Calculation
                biCapReqCalculate(config,yieldHeaderMap);
            }
        
            //Module Test Cap Req Calculation
            modTestCapReqCalculate(config,yieldHeaderMap);
        }
        
        
        List<Configurator_Test_Pass__c> ctpdel = [SELECT    id 
                                                  FROM      Configurator_Test_Pass__c
                                                  WHERE     Configuration__c = :config.configID];                                                    
        if(ctpdel.size()>0){
            delete ctpdel;
        }
        if(ctpList.size()>0){    
            insert ctpList;
        }                
         
        return yieldHeaderMap;                             
    }
    
    //Get the wafer test yield value calculated, cpw calculated and the test time calculated
    public static Map<String,GenerateYieldAndCost.YieldHeader> waferTestCalc(GenerateYieldAndCost.ConfigDetail config,Map<String,GenerateYieldAndCost.YieldHeader> yieldHeaderMap){
                
        // Variable Declaration
        List<String> grsQtr = new List<String>();
        Integer i = 6;
        Integer j = 1;
        Decimal kerfX = (config.postFabService.Kerf_X__c!=null)?config.postFabService.Kerf_X__c:0.0;
        Decimal kerfY = (config.postFabService.Kerf_Y__c!=null)?config.postFabService.Kerf_Y__c:0.0;
        
        // Getting the quarter records
        for(Config_Quarterly_Volume__c configQtrVol : [select    Q1_Volume__c
                                                                 , Q2_Volume__c
                                                                 , Q3_Volume__c
                                                                 , Q4_Volume__c
                                                                 , Quote_Proposal__c
                                                                 , Year__c
                                                       from      Config_Quarterly_Volume__c
                                                       where     Quote_Proposal__c = :config.configID
                                                       order by  Year__c asc
                                                      ]){
            if(configQtrVol.Q1_Volume__c!=null){
                configQtrSet.add(configQtrVol.Year__c+'_Q1');
                grsQtr.add('Q'+i+'__c');
                alphaQtr.add('Q'+j+'__c');
                i++;
                j++;
            }
            if(configQtrVol.Q2_Volume__c!=null){
                configQtrSet.add(configQtrVol.Year__c+'_Q2');
                grsQtr.add('Q'+i+'__c');
                alphaQtr.add('Q'+j+'__c');
                i++;
                j++;
            }
            if(configQtrVol.Q3_Volume__c!=null){
                configQtrSet.add(configQtrVol.Year__c+'_Q3');
                grsQtr.add('Q'+i+'__c');
                alphaQtr.add('Q'+j+'__c');
                i++;
                j++;
            }
            if(configQtrVol.Q4_Volume__c!=null){
                configQtrSet.add(configQtrVol.Year__c+'_Q4');
                grsQtr.add('Q'+i+'__c');
                alphaQtr.add('Q'+j+'__c');
                i++;
                j++;
            }            
        }
        
        // Get the quarter and month from Actual tapeout date
        integer month = config.productionDate.month();
        integer year = config.productionDate.year();
        yrStr = String.valueOf(year);
        if(month >= 1 && month <=3) {
          thisQuarter = 'Q1';
        }
        if(month >= 4 && month <=6) {
          thisQuarter = 'Q2';
        }
        if(month >= 7 && month <=9) {
          thisQuarter = 'Q3';
        }
        if(month >= 10 && month <=12) {
          thisQuarter = 'Q4';
        }
        

        //Condition when method = 'Circuit'
        if(config.postfabservice.Method__c=='Circuit'){
        
            //Get the Foundry DD Curve
            List<PCM_Test_Yield__c> pcmTestYieldList1 = [select    DD_Curve__c
                                                         from      PCM_Test_Yield__c
                                                         where     RecordType.name = 'Foundry DD Curve'
                                                         and       PT_Number__c = :config.PTNumber
                                                         and       Catalog_ID__c =:pcmAdminSetting.Catalog_ID__c
                                                         and       Version__c =:pcmAdminSetting.Version_ID__c
                                                        ];
            String temp = (pcmTestYieldList1!=null && pcmTestYieldList1.size()>0)?pcmTestYieldList1[0].DD_Curve__c:null;        
            
            //Get the GRS values
            List<PCM_Test_Yield__c> pcmTestYieldList2 = [select    Q6__c, Q7__c, Q8__c, Q9__c, Q10__c, Q11__c, Q12__c, Q13__c, Q14__c, Q15__c
                                                                   , Q16__c, Q17__c, Q18__c, Q19__c, Q20__c, Q21__c, Q22__c, Q23__c, Q24__c, Q25__c
                                                                   ,Q26__c
                                                         from      PCM_Test_Yield__c
                                                         where     RecordType.name = 'GRS' 
                                                         and       Tech_DD__c = :(pcmTestYieldList1!=null && pcmTestYieldList1.size()>0)?pcmTestYieldList1[0].DD_Curve__c:null
                                                         and       Catalog_ID__c =:pcmAdminSetting.Catalog_ID__c
                                                         and       Version__c =:pcmAdminSetting.Version_ID__c
                                                        ];
                          
            //Get the Alpha values      
            List<PCM_Test_Yield__c> pcmTestYieldList3 = [select    Q1__c, Q2__c, Q3__c, Q4__c, Q5__c, Q6__c, Q7__c, Q8__c, Q9__c, Q10__c
                                                                   , Q11__c, Q12__c, Q13__c, Q14__c, Q15__c, Q16__c, Q17__c, Q18__c, Q19__c
                                                                   , Q20__c, Q21__c, Q22__c, Q23__c, Q24__c, Start_Quarter__c, Start_Year__c
                                                                   , RecordType.name 
                                                         from      PCM_Test_Yield__c
                                                         where     RecordType.name in ('Alpha','DD Curve') 
                                                         and       Tech_DD__c = :(pcmTestYieldList1!=null && pcmTestYieldList1.size()>0)?pcmTestYieldList1[0].DD_Curve__c:null
                                                         and       Catalog_ID__c =:pcmAdminSetting.Catalog_ID__c
                                                         and       Version__c =:pcmAdminSetting.Version_ID__c
                                                        ];
            
            PCM_Test_Yield__c alphaObj = new PCM_Test_Yield__c();
            PCM_Test_Yield__c ddCurveObj = new PCM_Test_Yield__c();
            for(PCM_Test_Yield__c pcy : pcmTestYieldList3){
                if(pcy.RecordType.name == 'Alpha'){
                    alphaObj = pcy;            
                }else if(pcy.RecordType.name == 'DD Curve'){
                    ddCurveObj = pcy;    
                }    
            }
            Integer strCount = 1;
            if(alphaObj!=null){
                Integer yrCnt = (Integer.valueOf(yrStr)-Integer.valueOf(alphaObj.Start_Year__c))*4;
                Integer qtrCnt = Integer.valueOf(thisQuarter.substring(1))-Integer.valueOf((alphaObj.Start_Quarter__c).substring(1));
                strCount = yrCnt+qtrCnt+1;
            }
            Integer strDDCount = 1;
            if(ddCurveObj!=null){
                Integer yrCnt = (Integer.valueOf(yrStr)-Integer.valueOf(ddCurveObj.Start_Year__c))*4;
                Integer qtrCnt = Integer.valueOf(thisQuarter.substring(1))-Integer.valueOf((ddCurveObj.Start_Quarter__c).substring(1));
                strDDCount = yrCnt+qtrCnt+1;
            }
            
            
            Map<String,Decimal> availRedMap = new Map<String,Decimal>();
            Map<String,Decimal> cktFaultsMap = new Map<String,Decimal>();
            
            // Get the Circuit Group, Type and Redundancy
            for(PCM_Test_Yield__c p : [select    red_fact__c
                                                 , CKT_red__c
                                                 , RecordType.name
                                                 , Ckt_Group__c
                                                 , Ckt_Type__c
                                                 , Ckt_Faults__c
                                                 , Avail_Red__c
                                       from      PCM_Test_Yield__c
                                       where     RecordType.name in ('Red','CKT Fact')
                                       and       Catalog_ID__c =:pcmAdminSetting.Catalog_ID__c
                                       and       Version__c =:pcmAdminSetting.Version_ID__c                                   
                                      ]){
                if(p.RecordType.name == 'Red'){
                    availRedMap.put(p.CKT_red__c,p.red_fact__c);
                }else if(p.RecordType.name == 'CKT Fact'){
                    cktFaultsMap.put(p.Ckt_Group__c+'_'+p.Ckt_Type__c+'_'+p.Avail_Red__c,p.Ckt_Faults__c);
                }      
            }                                                               
            
            // For cpw calculation
            Decimal cpwValue = cpwCalculate(config,yieldHeaderMap);                             
            
            // Get the circuit limited yield cly and Design for Profit DFP
            Decimal cly = config.postFabService.Circuit_Limited_Yield_CLY__c;
            Decimal dfp = config.postFabService.Design_for_Profit_DFP__c;
            Integer count = 0;        
            
            // Iterate through the year's quarters for wafer test yield calculation, cpw, kerf x and kerf y.
            for(String configQtr : configQtrSet){
                Decimal grs = (pcmTestYieldList2!=null && pcmTestYieldList2.size()>0)?((count>20)?pcmTestYieldList2[0].Q26__c:(Decimal)(pcmTestYieldList2[0].get(grsQtr[count]))):0.0;
                Decimal alpha = (alphaObj!=null)?((strCount>=24)?alphaObj.Q24__c:(Decimal)(alphaObj.get('Q'+strCount+'__c'))):1.0;            
                Decimal ddCurveVal = (ddCurveObj!=null)?((strDDCount>=24)?ddCurveObj.Q24__c:(Decimal)(ddCurveObj.get('Q'+strDDCount+'__c'))):1.0;
                
                Decimal totChipFaultDensityPerQtr = 0.0;
            
                // Get the Config Post Fab Service Detail with a 'Wafer Test Pass' recordtype
                for(Config_Post_Fab_Service_Detail__c cpfsd : config.postFabService.Config_Post_Fab_Service_Detail__r){
                    if(cpfsd.recordtype.name == 'Wafer Test Pass'){
                        Decimal redundancy = 0.0;
                        Decimal cktFault = 0.0;
                        if(cpfsd.Available_Redundancy__c == null){
                            redundancy = 1;    
                        }else{
                            redundancy = (availRedMap.containsKey(cpfsd.Available_Redundancy__c))?availRedMap.get(cpfsd.Available_Redundancy__c):1;
                        }
                                    
                        cktFault = (cktFaultsMap.containsKey(cpfsd.Circuit_Group__c+'_'+cpfsd.Circuit_Type__c+'_'+(cpfsd.Available_Redundancy__c!=null?cpfsd.Available_Redundancy__c:'NONE')))?cktFaultsMap.get(cpfsd.Circuit_Group__c+'_'+cpfsd.Circuit_Type__c+'_'+(cpfsd.Available_Redundancy__c!=null?cpfsd.Available_Redundancy__c:'NONE')):0.0;
                        totChipFaultDensityPerQtr += ((cpfsd.Count__c!=null)?cpfsd.Count__c:0.0)*redundancy*cktFault*ddCurveVal;
                    }
                }                
                
                Decimal waferTestYield = Decimal.valueOf((Double)cly*((Double)grs/Math.pow((Double)(1+dfp*(totChipFaultDensityPerQtr/alpha)),((Double)alpha))));
                
                String yr = configQtr.split('_')[0];
                String qtr = configQtr.split('_')[1];
                
                // Put the calculated values in the yieldHeader map. 
                if(yieldHeaderMap.containsKey(yr+qtr)){
                    yieldHeaderMap.get(yr+qtr).addWaferTestYield(waferTestYield);
                    yieldHeaderMap.get(yr+qtr).addCPWValue(cpwValue);
                    yieldHeaderMap.get(yr+qtr).addKerfXValue(kerfX);
                    yieldHeaderMap.get(yr+qtr).addKerfYValue(kerfY);
                } else {
                    yieldHeaderMap.put(yr+qtr,new GenerateYieldAndCost.YieldHeader(config,yr,qtr,waferTestYield));    
                    yieldHeaderMap.get(yr+qtr).addWaferTestYield(waferTestYield);
                    yieldHeaderMap.get(yr+qtr).addCPWValue(cpwValue);
                    yieldHeaderMap.get(yr+qtr).addKerfXValue(kerfX);
                    yieldHeaderMap.get(yr+qtr).addKerfYValue(kerfY);
                }
                 
                count++;
                strCount++;
                strDDCount++;
            }
        }else if(config.postfabservice.Method__c=='Custom'){
            PFile_Yield__c wftObj;
            PFile_Yield__c cpwObj;
            //PFile_Yield__c kerfXObj;
            //PFile_Yield__c kerfYObj;
            
            // Iterate the data of the PFile Yield
            for(PFile_Yield__c pfy : config.pfd.PFile_Yields__r){
                if(pfy.recordType.name == 'Custom Yields'){
                    if(pfy.Yield_Type__c=='WFT'){
                        wftObj=pfy;            
                    }
                    if(pfy.Yield_Type__c=='CPW'){
                        cpwObj=pfy; 
                    }
                    /*if(pfy.Yield_Type__c=='KERF_X'){
                        kerfXObj=pfy; 
                    }
                    if(pfy.Yield_Type__c=='KERF_Y'){
                        kerfYObj=pfy; 
                    }*/
                }           
            }
            //kerfX = (kerfXObj!=null)?kerfXObj.QTR1__c:0.0;
            //kerfY = (kerfYObj!=null)?kerfYObj.QTR1__c:0.0;
            
            Integer count=1;
            
            // Iterate the quarters of the years
            for(String configQtr : configQtrSet){
                
                String key = (count<=24)?('QTR'+String.valueOf(count)+'__c'):'QTR24__c';
                Decimal waferTestYield = (wftObj!=null)?(Decimal)wftObj.get(key):1.0;
                Decimal cpwValue = (cpwObj!=null)?(Decimal)cpwObj.get(key):1.0;
                
                String yr = configQtr.split('_')[0];
                String qtr = configQtr.split('_')[1];
                
                if(yieldHeaderMap.containsKey(yr+qtr)){
                    yieldHeaderMap.get(yr+qtr).addWaferTestYield(waferTestYield);
                    yieldHeaderMap.get(yr+qtr).addCPWValue(cpwValue);
                    yieldHeaderMap.get(yr+qtr).addKerfXValue(kerfX);
                    yieldHeaderMap.get(yr+qtr).addKerfYValue(kerfY);
                } else {
                    yieldHeaderMap.put(yr+qtr,new GenerateYieldAndCost.YieldHeader(config,yr,qtr,waferTestYield));    
                    yieldHeaderMap.get(yr+qtr).addWaferTestYield(waferTestYield);
                    yieldHeaderMap.get(yr+qtr).addCPWValue(cpwValue);
                    yieldHeaderMap.get(yr+qtr).addKerfXValue(kerfX);
                    yieldHeaderMap.get(yr+qtr).addKerfYValue(kerfY);
                }
                count++;
            }
        }
        
        return yieldHeaderMap;                
        
    }
    
    // Calculation of the Wafer Test Time
    private static List<Configurator_Test_Pass__c> createConfigWafTestPass(GenerateYieldAndCost.ConfigDetail config, String stage){
        Map<String,String> stageRecordTypeMap = new Map<String,String>{'WAF_TST'=>'Wafer Test Pass'};
        
        // Get records from the PCM Time object for recordtypes 'ATT Constants' and 'Time Data'
        List<PCM_Time__c> pcmTimeDataList = [select     id
                                                           , test_section__c
                                                           , calc__c
                                                           , test_pass__c
                                                           , RecordType.name
                                                           , stage__c
                                                           , time_comp__c
                                                           , data__c
                                                           , PT_Number__c
                                                           , relgrade__c
                                                           , driver__c 
                                                 from      PCM_Time__c 
                                                 where     RecordType.name = 'Time Data'
                                                 and       PT_Number__c in (:config.PTNumber,'DEFAULT') 
                                                 and       relgrade__c = :config.relgrade 
                                                 and       Catalog_ID__c =:pcmAdminSetting.Catalog_ID__c
                                                 and       Version__c =:pcmAdminSetting.Version_ID__c];
        
        
        List<PCM_Time__c> pcmTimeATTConWafList = [select      id
                                                           , test_section__c
                                                           , calc__c
                                                           , test_pass__c
                                                           , RecordType.name
                                                           , stage__c
                                                           , time_comp__c
                                                           , data__c
                                                           , PT_Number__c
                                                           , relgrade__c
                                                           , driver__c 
                                                 from      PCM_Time__c 
                                                 where     RecordType.name = 'ATT Constants'
                                                 and       Stage__c = 'WAF_TST' 
                                                 and       Catalog_ID__c =:pcmAdminSetting.Catalog_ID__c
                                                 and       Version__c =:pcmAdminSetting.Version_ID__c];                
        
        Map<String,String> testSectionWafMap = new Map<String,String>();
        String ptNumber; 
        
        //Iterate through PCM Time records
        for(PCM_Time__c pt : pcmTimeATTConWafList){
            testSectionWafMap.put(pt.test_section__c,pt.calc__c);              
        }    
        for(PCM_Time__c pt : pcmTimeDataList){           
            if(pt.PT_Number__c == config.PTNumber){
                ptNumber = config.PTNumber;
            }
        }
        
        // If no PT number can be found from the PCM Time records choose the 'DEFAULT' value
        if(ptNumber==null){
            ptNumber = 'DEFAULT';
        }
        
        Map<String,Double> testSectionWafData = new Map<String,Double>();
        for(PCM_Time__c pt : pcmTimeDataList){
            
            //Iterating the wafer map
            for(String section : testSectionWafMap.keySet()){
                if(pt.PT_Number__c == ptNumber
                        && pt.test_pass__c == 'WFT'
                        && pt.time_comp__c.contains(section)){
                    testSectionWafData.put(pt.time_comp__c,pt.data__c);                
                }
            }
            
        }                
        
        Map<String,Decimal> allWaferDriverCountMap = new Map<String,Decimal>();       
        
        isDRAMSelected=FALSE;
        //Iterate through config post fab service detail
        for(Config_Post_Fab_Service_Detail__c cpfsd : config.postFabService.Config_Post_Fab_Service_Detail__r){
            if(cpfsd.recordtype.name == 'Wafer Test Pass'){
                if(config.postfabservice.Test_Time_Method__c=='GF Forecast'){
                    if(allWaferDriverCountMap.containsKey('QTY_'+cpfsd.Circuit_Group__c.toUpperCase())){
                        allWaferDriverCountMap.put('QTY_'+cpfsd.Circuit_Group__c.toUpperCase(),(Decimal)(allWaferDriverCountMap.get('QTY_'+cpfsd.Circuit_Group__c.toUpperCase()))+cpfsd.Count__c);
                    }else{
                        allWaferDriverCountMap.put('QTY_'+cpfsd.Circuit_Group__c.toUpperCase(),cpfsd.Count__c);
                    }
                }
            }
        }
        allWaferDriverCountMap.put('AUTO',0);
        
        if(config.postfabservice.Method__c=='Custom'){
            Integer countCheck=0;
            //Iterate the PFile Yield records
            for(PFile_Yield__c pfy : config.pfd.PFile_Yields__r){
                if(pfy.recordType.name == 'Custom Circuit'){
                    if(countCheck==0){
                        allWaferDriverCountMap.clear();
                        allWaferDriverCountMap.put('AUTO',0);
                        countCheck++;
                    }
                    if(config.postfabservice.Test_Time_Method__c=='GF Forecast'){
                        if(allWaferDriverCountMap.containsKey('QTY_'+pfy.Circuit_Group__c.toUpperCase())){
                            allWaferDriverCountMap.put('QTY_'+pfy.Circuit_Group__c.toUpperCase(),(Decimal)(allWaferDriverCountMap.get('QTY_'+pfy.Circuit_Group__c.toUpperCase()))+pfy.Count__c);
                        }else{
                            allWaferDriverCountMap.put('QTY_'+pfy.Circuit_Group__c.toUpperCase(),pfy.Count__c);
                        }           
                    }
                }           
            }
        }                
        
        Decimal userDefWTT = (config.postfabservice.Test_Time_Method__c=='User Defined GTT/Chip')?config.postfabservice.User_Defined_Time__c:0.0;      
       
        //Record Type for Test Pass object
        Map<String,String> recordTypeMap = new Map<String,String>();
        for(RecordType rt : [select id,name from RecordType where SObjectType = 'Configurator_Test_Pass__c']){ 
            recordTypeMap.put(rt.name,rt.id);
        }
        
        //Test Time calculation for Wafer and Module stage of PCM Time record
    Map<String,Configurator_Test_Pass__c> testTimeMap = new Map<String,Configurator_Test_Pass__c>();
        List<Configurator_Test_Pass__c> configTestPass = new List<Configurator_Test_Pass__c>();
        for(PCM_Time__c pt : pcmTimeATTConWafList){
            //Calculation for Wafer Test Time
            Configurator_Test_Pass__c ctp = new Configurator_Test_Pass__c();
            ctp.Configuration__c = config.configID;
            ctp.Circuit_Group__c = pt.driver__c;
            ctp.Test_Section__c = pt.test_section__c;
            ctp.Module_Test_Pass__c = pt.test_pass__c;
            ctp.recordTypeId = (String)(recordTypeMap.get((String)(stageRecordTypeMap.get(stage))));

            if(!allWaferDriverCountMap.isEmpty() && allWaferDriverCountMap.keySet().contains(pt.driver__c) && config.postfabservice.Test_Time_Method__c!='User Defined GTT/Chip'){
         
                if(pt.calc__c == 'EXPONENT'){
                    ctp.Test_Time__c = (Decimal)((Double)((testSectionWafData.containsKey(pt.Test_Section__c+'_var'))?testSectionWafData.get(pt.Test_Section__c+'_var'):0.0)*(Math.pow(Double.valueOf(allWaferDriverCountMap.get(pt.driver__c)),Double.valueOf((testSectionWafData.containsKey(pt.Test_Section__c+'_k'))?testSectionWafData.get(pt.Test_Section__c+'_k'):0.0))));
                }else if(pt.calc__c == 'LINEAR'){
                    ctp.Test_Time__c =  (Decimal)((testSectionWafData.containsKey(pt.Test_Section__c+'_k'))?testSectionWafData.get(pt.Test_Section__c+'_k'):0.0)+((Decimal)(allWaferDriverCountMap.get(pt.driver__c))*(Decimal)((testSectionWafData.containsKey(pt.Test_Section__c+'_var'))?testSectionWafData.get(pt.Test_Section__c+'_var'):0.0));
                }else if(pt.calc__c == 'AUTO'){
                    ctp.Test_Time__c = (Decimal)((testSectionWafData.containsKey(pt.Test_Section__c+'_k'))?testSectionWafData.get(pt.Test_Section__c+'_k'):0.0);
                }
        //================================
                 if(testTimeMap.containsKey(pt.Test_Section__c)){
           Configurator_Test_Pass__c ctp1 = new Configurator_Test_Pass__c();
           ctp1 = testTimeMap.get(pt.Test_Section__c);
                       ctp.Test_Time__c=  ctp1.Test_Time__c+ctp.Test_Time__c;                       
             testTimeMap.put(pt.Test_Section__c,ctp);
                        }    
                  else{
            testTimeMap.put(pt.Test_Section__c,ctp);
          }  
//=======================================================          
            }else{
                ctp.Test_Time__c = 0;
            }
            totalWaferTestTime += (ctp.Test_Time__c!=null)?ctp.Test_Time__c:0.0;
      //=================
            //configTestPass.add(ctp);
      //===================
        }
    //===================================
    for(String ctp2 : testTimeMap.keySet()){
      configTestPass.add(testTimeMap.get(ctp2));
    }
    //========================
    totalWaferTestTime = (config.postfabservice.Test_Time_Method__c=='User Defined GTT/Chip')?userDefWTT:totalWaferTestTime;
        return configTestPass;            
    }
    
    // Calculation of the Module Test Time
    private static List<Configurator_Test_Pass__c> createConfigModTestPass(GenerateYieldAndCost.ConfigDetail config, String stage){
        Map<String,String> stageRecordTypeMap = new Map<String,String>{'MOD_TST'=>'Module Test Pass'};
        isDRAMSelected= FALSE;
       //============Add by Ravindra to check if DRAM circuit is selected or not
       for(Config_Post_Fab_Service_Detail__c cpfsd : config.postFabService.Config_Post_Fab_Service_Detail__r){
           if(!isDRAMSelected && cpfsd.recordtype.name == 'Wafer Test Pass' && cpfsd.Circuit_Group__c.toUpperCase().equals('FXBL DRAM')){
               isDRAMSelected =TRUE;
           }     
       }
        // Get records from the PCM Time object for recordtypes 'ATT Constants' and 'Time Data'
        List<PCM_Time__c> pcmTimeDataList = [select     id
                                                           , test_section__c
                                                           , calc__c
                                                           , test_pass__c
                                                           , RecordType.name
                                                           , stage__c
                                                           , time_comp__c
                                                           , data__c
                                                           , PT_Number__c
                                                           , relgrade__c
                                                           , driver__c 
                                                 from      PCM_Time__c 
                                                 where     RecordType.name = 'Time Data'
                                                 and       PT_Number__c in (:config.PTNumber,'DEFAULT') 
                                                 and       relgrade__c = :config.relgrade 
                                                 and       Catalog_ID__c =:pcmAdminSetting.Catalog_ID__c
                                                 and       Version__c =:pcmAdminSetting.Version_ID__c];                
        
        List<PCM_Time__c> pcmTimeATTConModList = [select      id
                                                           , test_section__c
                                                           , calc__c
                                                           , test_pass__c
                                                           , RecordType.name
                                                           , stage__c
                                                           , time_comp__c
                                                           , data__c
                                                           , PT_Number__c
                                                           , relgrade__c
                                                           , driver__c 
                                                 from      PCM_Time__c 
                                                 where     RecordType.name = 'ATT Constants'
                                                 and       Stage__c = 'MOD_TST' 
                                                 and       Catalog_ID__c =:pcmAdminSetting.Catalog_ID__c
                                                 and       Version__c =:pcmAdminSetting.Version_ID__c];
        
        Map<String,String> testSectionModMap = new Map<String,String>();
        String ptNumber; 
        
        //Iterate through PCM Time records    
        for(PCM_Time__c pt : pcmTimeATTConModList){  
            if(isDRAMSelected ||(pt.test_pass__c=='FMT_POS_25C')){
              testSectionModMap.put(pt.test_pass__c+pt.test_section__c,pt.calc__c);              
            }
        }
        for(PCM_Time__c pt : pcmTimeDataList){           
            if(pt.PT_Number__c == config.PTNumber){
                ptNumber = config.PTNumber;
            }
        }
        
        // If no PT number can be found from the PCM Time records choose the 'DEFAULT' value
        if(ptNumber==null){
            ptNumber = 'DEFAULT';
        }
        
        Map<String,Double> testSectionModData = new Map<String,Double>();
        for(PCM_Time__c pt : pcmTimeDataList){            
            
            //Iterating the module map
            for(String section : testSectionModMap.keySet()){
                if(pt.PT_Number__c == ptNumber
                      && (pt.test_pass__c+pt.time_comp__c).contains(section)){
                    testSectionModData.put(pt.test_pass__c+pt.time_comp__c,pt.data__c);                
                }
            }
        }                
        
        Map<String,Decimal> allModuleDriverCountMap = new Map<String,Decimal>();        
        
        isDRAMSelected=FALSE;
        //Iterate through config post fab service detail
        for(Config_Post_Fab_Service_Detail__c cpfsd : config.postFabService.Config_Post_Fab_Service_Detail__r){
            if(cpfsd.recordtype.name == 'Wafer Test Pass'){
                if(config.postfabservice.Module_Test_Time_Method__c=='GF Forecast'){                   
                    if(allModuleDriverCountMap.containsKey('QTY_'+cpfsd.Circuit_Group__c.toUpperCase())){
                        allModuleDriverCountMap.put('QTY_'+cpfsd.Circuit_Group__c.toUpperCase(),(Decimal)(allModuleDriverCountMap.get('QTY_'+cpfsd.Circuit_Group__c.toUpperCase()))+cpfsd.Count__c);
                    }else{
                        allModuleDriverCountMap.put('QTY_'+cpfsd.Circuit_Group__c.toUpperCase(),cpfsd.Count__c);
                    }
                }
            }
        }
        allModuleDriverCountMap.put('AUTO',0);        
        
        //if(config.postfabservice.Module_Test_Yield_Method__c=='Custom'){
   if(config.postfabservice.Method__c=='Custom'){    
            Integer countCheck=0;
            //Iterate the PFile Yield records
            for(PFile_Yield__c pfy : config.pfd.PFile_Yields__r){
                if(pfy.recordType.name == 'Custom Circuit'){
                    if(countCheck==0){
                        allModuleDriverCountMap.clear();
                        allModuleDriverCountMap.put('AUTO',0);
                        countCheck++;
                    }
                    if(config.postfabservice.Module_Test_Time_Method__c=='GF Forecast'){
                        if(allModuleDriverCountMap.containsKey('QTY_'+pfy.Circuit_Group__c.toUpperCase())){
                            allModuleDriverCountMap.put('QTY_'+pfy.Circuit_Group__c.toUpperCase(),(Decimal)(allModuleDriverCountMap.get('QTY_'+pfy.Circuit_Group__c.toUpperCase()))+pfy.Count__c);
                        }else{
                            allModuleDriverCountMap.put('QTY_'+pfy.Circuit_Group__c.toUpperCase(),pfy.Count__c);
                        }
                    }
                }           
            }
        }
        
        Decimal userDefMTT = (config.postfabservice.Module_Test_Time_Method__c=='User Defined GTT/Chip')?config.postfabservice.Module_User_Defined_Time__c:0.0;      
       
        //Record Type for Test Pass object
        Map<String,String> recordTypeMap = new Map<String,String>();
        for(RecordType rt : [select id,name from RecordType where SObjectType = 'Configurator_Test_Pass__c']){ 
            recordTypeMap.put(rt.name,rt.id);
        }
        
        //Test Time calculation for Wafer and Module stage of PCM Time record
        Map<String,Configurator_Test_Pass__c> testTimeMap = new Map<String,Configurator_Test_Pass__c>();
        List<Configurator_Test_Pass__c> configTestPass = new List<Configurator_Test_Pass__c>();
        for(PCM_Time__c pt : pcmTimeATTConModList){
            //Calculation for Module Test Time
            Configurator_Test_Pass__c ctp = new Configurator_Test_Pass__c();
            ctp.Configuration__c = config.configID;
            ctp.Circuit_Group__c = pt.driver__c;
            ctp.Test_Section__c = pt.test_section__c;
            ctp.Module_Test_Pass__c = pt.test_pass__c;
            ctp.recordTypeId = (String)(recordTypeMap.get((String)(stageRecordTypeMap.get(stage))));

            if(!allModuleDriverCountMap.isEmpty() && allModuleDriverCountMap.keySet().contains(pt.driver__c) && config.postfabservice.Module_Test_Time_Method__c!='User Defined GTT/Chip'){
                if(pt.calc__c == 'EXPONENT'){                        
                    ctp.Test_Time__c = (Decimal)((Double)((testSectionModData.containsKey(pt.test_pass__c+pt.Test_Section__c+'_var'))?testSectionModData.get(pt.test_pass__c+pt.Test_Section__c+'_var'):0.0)*(Math.pow(Double.valueOf(allModuleDriverCountMap.get(pt.driver__c)),Double.valueOf((testSectionModData.containsKey(pt.test_pass__c+pt.Test_Section__c+'_k'))?testSectionModData.get(pt.test_pass__c+pt.Test_Section__c+'_k'):0.0))));
                }else if(pt.calc__c == 'LINEAR'){
                    ctp.Test_Time__c =  (Decimal)((testSectionModData.containsKey(pt.test_pass__c+pt.Test_Section__c+'_k'))?testSectionModData.get(pt.test_pass__c+pt.Test_Section__c+'_k'):0.0)+((Decimal)(allModuleDriverCountMap.get(pt.driver__c))*(Decimal)((testSectionModData.containsKey(pt.test_pass__c+pt.Test_Section__c+'_var'))?testSectionModData.get(pt.test_pass__c+pt.Test_Section__c+'_var'):0.0));
                }else if(pt.calc__c == 'AUTO'){
                    ctp.Test_Time__c = (Decimal)((testSectionModData.containsKey(pt.test_pass__c+pt.Test_Section__c+'_k'))?testSectionModData.get(pt.test_pass__c+pt.Test_Section__c+'_k'):0.0);
                }
                //================================
                 if(testTimeMap.containsKey(pt.test_pass__c+pt.Test_Section__c)){
           Configurator_Test_Pass__c ctp1 = new Configurator_Test_Pass__c();
           ctp1 = testTimeMap.get(pt.test_pass__c+pt.Test_Section__c);
                       ctp.Test_Time__c=  ctp1.Test_Time__c+ctp.Test_Time__c;                       
             testTimeMap.put(pt.test_pass__c+pt.Test_Section__c,ctp);
                        }    
                  else{
            testTimeMap.put(pt.test_pass__c+pt.Test_Section__c,ctp);
          }  
//=======================================================          
            }else{
                ctp.Test_Time__c = 0;
            }
            totalModuleTestTime += (ctp.Test_Time__c!=null)?ctp.Test_Time__c:0.0;
            //=================
            //configTestPass.add(ctp);
      //===================
        }
    //===================================
    for(String ctp2 : testTimeMap.keySet()){
      configTestPass.add(testTimeMap.get(ctp2));
    }
    //========================
    totalModuleTestTime = (config.postfabservice.Module_Test_Time_Method__c=='User Defined GTT/Chip')?userDefMTT:totalModuleTestTime;
        return configTestPass;    
    }
    
    //Yield Stage - CPW Calculation
    private static Decimal cpwCalculate(GenerateYieldAndCost.ConfigDetail config,Map<String,GenerateYieldAndCost.YieldHeader> yieldHeaderMap){
        
        Decimal prodIntX=0.0;
        Decimal prodIntY=0.0;
        Decimal rMaxX2;
        Decimal rMaxY2;
        Decimal prodKerfX=0.0;
        Decimal prodKerfY=0.0;
        
        // Getting the Kerf Yield and Prod Int for X and Y
        List<PCM_Yield__c> pcmYieldKerf = [select    PROD_INT__c
                                                     , PROD_KERF__c
                                                     , RecordType.name
                                                     , Id
                                           from      PCM_Yield__c
                                           where     ((RecordType.name = 'KERF X' and Chip_LO__c <= :config.chipX and Chip_HI__c >= :config.chipX)
                                           OR        (RecordType.name = 'KERF Y' and Chip_LO__c <= :config.chipY and Chip_HI__c >= :config.chipY))
                                           AND       FAB__c = :config.fab AND Relgrade__c = :Decimal.valueOf(config.relgrade) AND PT_Number__c = :config.PTNumber
                                           and       Catalog_ID__c =:pcmAdminSetting.Catalog_ID__c
                                           and       Version__c =:pcmAdminSetting.Version_ID__c];
        
        // Getting the RMaxx2 and RMaxy2 values from PCM Yield
        List<PCM_Yield__c> pcmYieldTech = [SELECT    RMAXX2__c
                                                     , RMAXY2__c 
                                          FROM       PCM_Yield__c 
                                          WHERE      RecordType.name = 'Tech Info' 
                                          AND        PT_Number__c = :config.PTNumber 
                                          AND        Wafer_Size__c = :config.waferSize 
                                          AND        FAB__c = :config.fab
                                          and        Catalog_ID__c =:pcmAdminSetting.Catalog_ID__c
                                          and        Version__c =:pcmAdminSetting.Version_ID__c];
        
        // Get the Max data for TS
        List<aggregateResult> aggResults =   [SELECT MAX(Data__c)pcmdata FROM PCM_Yield__c 
                                              WHERE RecordType.name = 'CPW DATA' 
                                              AND FAB__c = :config.fab 
                                              AND PT_Number__c = :config.PTNumber 
                                              AND CPW_COMP__c='TS'
                                              and Catalog_ID__c =:pcmAdminSetting.Catalog_ID__c
                                              and Version__c =:pcmAdminSetting.Version_ID__c];
        
        Decimal ts = (aggResults!=null && aggResults.size()>0 && aggResults[0].get('pcmdata')!=null)?((Decimal)aggResults[0].get('pcmdata')):0.0;
        
        //Getting the Radius value
        List<PCM_Yield__c> pcmYieldRadList = [select    Wafer_Size__c
                                                        , Exclusion_Zone__c
                                              from      PCM_Yield__c
                                              where     FAB__c = :config.fab 
                                              AND PT_Number__c = :config.PTNumber
                                              and Catalog_ID__c =:pcmAdminSetting.Catalog_ID__c
                                              and Version__c =:pcmAdminSetting.Version_ID__c
                                              and recordtype.name = 'Tech Info' 
                                              and Wafer_Size__c <> null and Exclusion_Zone__c <> null limit 1
                                             ];      
        
        // Populate the ProdIntX, ProdIntY, KerfX, KerfY        
        for(PCM_Yield__c p : pcmYieldKerf){
            if(p.RecordType.name == 'KERF X'){
                if(config.postFabServices[0].minimumKerf=='Yes'){
                    prodKerfX = p.PROD_KERF__c;
                }else{
                    prodKerfX = config.postFabServices[0].kerfX;
                }
                prodIntX = p.PROD_INT__c;        
            }else if(p.RecordType.name == 'KERF Y'){
                if(config.postFabServices[0].minimumKerf=='Yes'){
                    prodKerfY = p.PROD_KERF__c;
                }else{
                    prodKerfY = config.postFabServices[0].kerfY;
                }
                prodIntY = p.PROD_INT__c;
            }

        }
        
        //Get the rMaxX2 and rMaxY2
        if(pcmYieldTech!=null){
            rMaxX2 = (pcmYieldTech!=null && pcmYieldTech.size()>0)?pcmYieldTech[0].RMAXX2__c:0.0;
            rMaxY2 = (pcmYieldTech!=null && pcmYieldTech.size()>0)?pcmYieldTech[0].RMAXY2__c:0.0;
        }
        
        Decimal mxk;
        Decimal myk;
        
        if(prodKerfX>0.5){
            mxk = Math.min(prodKerfX,prodKerfY);
        }else{
            mxk = prodKerfX;
        }
        
        if(prodKerfY>0.5){
            myk = Math.min(prodKerfX,prodKerfY);
        }else{
            myk = prodKerfY;
        }        
        
        Decimal nx;
        Decimal ny;
        try{
            nx = Math.max(1,Integer.valueof((rMaxX2-prodKerfX+prodIntX)/((config.chipX!=null)?config.chipX:0.0-prodIntX)));
        }catch(Exception e){nx=1;}
        
        try{
            ny = Math.max(1,Integer.valueof((rMaxY2-prodKerfY+prodIntY)/((config.chipY!=null)?config.chipY:0.0-prodIntY)));
        }catch(Exception e){ny=1;}
        
        Decimal xper = ((config.chipX!=null?config.chipX:0.0)*nx+prodKerfX+((nx-1)*mxk))/nx;
        Decimal yper = ((config.chipY!=null?config.chipY:0.0)*ny+prodKerfY+((ny-1)*myk))/ny;        
        
        //Calculate the RADIUS
        Decimal RADIUS=(((pcmYieldRadList!=null && pcmYieldRadList.size()>0)?pcmYieldRadList[0].Wafer_Size__c:0.0)-(((pcmYieldRadList!=null && pcmYieldRadList.size()>0)?pcmYieldRadList[0].Exclusion_Zone__c:0.0))*2)/2;
        Decimal YEC;
        try{
            YEC = RADIUS/yper;
        }catch(Exception e){YEC=0;}
        
        Double yoc,yod,yed;
        Double xnye,xnyo;
        Integer yexe=0;
        Integer yexo=0;
        Integer yoxe=0;
        Integer yoxo=0;
        
        //Calculation of cpw value
        for(Integer cnt=1;cnt<=yec;cnt++){ 
            yoc = cnt - 0.05;
            yed = yper * cnt;
            yod = yper * yoc;
            xnye =  Math.sqrt(Math.pow((Double)RADIUS,Double.valueOf(2)) - Math.pow((Double)yed,Double.valueOf(2)))/xper;
            xnyo =  Math.sqrt(Math.pow((Double)RADIUS,Double.valueOf(2)) - Math.pow((Double)yod,Double.valueOf(2)))/xper;
            yexe += Integer.valueOf(xnye)*2;
            yexo += Integer.valueOf((xnye<0.5)? 0 : (Integer.valueOf(xnyo + 0.5)-0.5)*2) ; 
            yoxe += Integer.valueOf(xnyo);
            yoxo += Integer.valueOf((xnyo<0.5)? 0 : (Integer.valueOf(xnyo + 0.5)-0.5)*2);
        }        
                
        Integer rcpwFirst = Math.max(yexe,yexo);
        Integer rcpwSecond = Math.max(yoxe,yoxo);
        Integer rcpw = Math.max(rcpwFirst,rcpwSecond);
        Decimal finalCalc = (Decimal.valueOf(rcpw)-(ts*nx*ny))*2;
        
        return finalCalc;
    }
    
    // Calculation of the Wafer CAP Req
    public static Map<String,GenerateYieldAndCost.YieldHeader> populateCapReq(GenerateYieldAndCost.ConfigDetail config,Map<String,GenerateYieldAndCost.YieldHeader> yieldHeaderMap){
        
        Decimal loadFactor;
        Decimal ronRetestConstant;
        Decimal machineStopDelay;
        Decimal cleanTime;
        Decimal setupTime;
        Decimal ronTouchDownConstant;
        Decimal cleanTimeFreq=0;
        
        //Get the PCM Time Data for Workcenter and Handler FEH
        List<PCM_Time__c> pcmWafTestRecords = [select   Contingency_Percent__c
                                                        , Handlers_WS__c
                                                        , Overhead_Time__c
                                                        , Prober_Steptime__c
                                                        , Index_Time__c
                                                        , Characterization_Percent__c
                                                        , Planned_Maint__c
                                                        , Unplanned_Maint__c
                                                        , MFG_Planned_Maint__c
                                                        , MFG_Unplanned_Maint__c
                                                        , RecordType.name
                                                        , Calibration__c
                                                        , TAE_ME__c
                                                        , IS_DP__c
                                                from    PCM_Time__c
                                                where   RecordType.name in ('WorkCenter','Handler FEH','StepTime')
                                                and     Location__c = :config.postFabService.test_location__c
                                                and     Workcenter__c = :config.postFabService.test_platform__c
                                                and     Stage__c = 'WAF_TST'
                                                and     Catalog_ID__c =:pcmAdminSetting.Catalog_ID__c
                                                and     Version__c =:pcmAdminSetting.Version_ID__c
                                               ];
        
        // Get the constant data from PCM Time
        List<PCM_Time__c>   pcmApsConstantRec = [select Value__c
                                                        , RecordType.name
                                                        , Constant_Name__c
                                                 from   PCM_Time__c
                                                 where  RecordType.name = 'APS Constants'
                                                 and    Constant_Name__c in ('LOAD_FACTOR','RON_RETEST_PERCENT','MACH_STOP_DELAY','RON_TOUCHDOWN_CONSTANT','CLEAN_TIME','SETUP_TIME_PER_LOT','CLEAN_TIME_FREQ')
                                                 and     Catalog_ID__c =:pcmAdminSetting.Catalog_ID__c
                                                 and     Version__c =:pcmAdminSetting.Version_ID__c
                                                ];
        
        // Get the Lot Size data from wafer test stage
        List<PCM_Time__c>   pcmLotSizeRec = [select Lot_Size__c
                                                    , Year__c
                                             from   PCM_Time__c
                                             where  RecordType.name = 'Lot Size'
                                             and    Stage__c = 'WAF_TST' 
                                             and    Wafer_Size__c = :config.waferSize
                                             and    Year__c in :config.years
                                              and    Package_Tech__c = 'NA'];

        // Get the time data
        List<PCM_Time__c> pcmTimeData = [select    Data__c
                                                   , PT_Number__c
                                         from      PCM_Time__c
                                         where     RecordType.name = 'Time Data'
                                         and       relgrade__c = :config.relgrade
                                         and       ((PT_Number__c = :config.PTNumber                                       
                                         and       Test_Pass__c = 'WFT'
                                         and       Time_Comp__c = 'BTT_PCT')
                                         OR        (PT_Number__c = 'DEFAULT'                                       
                                         and       Test_Pass__c = 'DEFAULT'
                                         and       Time_Comp__c = 'BTT_PCT'))
                                        ];        
        
        Decimal pcmData=0.0;
        // Calculate PCM Time data for PT number or when PT number is 'DEFAULT'
        for(PCM_Time__c p : pcmTimeData){
            if(p.PT_Number__c == config.PTNumber){
                pcmData = p.Data__c;
                break;
            }

            if(pcmData == 0.0 && p.PT_Number__c == 'DEFAULT'){
                pcmData = p.Data__c;    
            }    
        }            
        
        // Get the constant values
        for(PCM_Time__c p : pcmApsConstantRec){
            if(p.Constant_Name__c == 'LOAD_FACTOR'){
                loadFactor = Decimal.valueOf(p.Value__c);
            }
            if(p.Constant_Name__c == 'RON_RETEST_PERCENT'){
                ronRetestConstant = Decimal.valueOf(p.Value__c);
            }
            if(p.Constant_Name__c == 'MACH_STOP_DELAY'){
                machineStopDelay = Decimal.valueOf(p.Value__c);
            }
            if(p.Constant_Name__c == 'CLEAN_TIME'){
                cleanTime = Decimal.valueOf(p.Value__c);
            }
            if(p.Constant_Name__c == 'SETUP_TIME_PER_LOT'){
                setupTime = Decimal.valueOf(p.Value__c);
            }   
            if(p.Constant_Name__c == 'RON_TOUCHDOWN_CONSTANT'){
                ronTouchDownConstant = Decimal.valueOf(p.Value__c);
            }     
            if(p.Constant_Name__c=='CLEAN_TIME_FREQ'){
                cleanTimeFreq=Decimal.valueOf(p.Value__c);
            }
        }
        
        // Variable Declaration
        Decimal proberTester;
        Decimal contingency;
        Decimal swOverHeadTime;
        Decimal stepTime;
        Decimal indexTime;
        Decimal goodTestTime = totalWaferTestTime;
        Decimal badTestTime = pcmData*goodTestTime;
        Decimal charTestTime = goodTestTime;
        Decimal charPercent;
        Decimal totDetractorHours=0.0; 
        Map<String,Decimal>cleanTimeYr = new Map<String,Decimal>();

         // Lot Size records iterated based on year
        Map<String,String> pcmLotSizeByYear = new Map<String,String>();
        for(PCM_Time__c p : pcmLotSizeRec){
            pcmLotSizeByYear.put(p.Year__c,p.Lot_Size__c);    
            
               if(cleanTimeFreq>0){
                   cleanTimeYr.put(p.Year__c,(Integer.valueOf(Math.ceil(Integer.valueOF(p.Lot_Size__c)/cleanTimeFreq))*cleanTime));
                 
                
                }
              else cleanTimeYr.put(p.Year__c,0);
            
            
        }     
        // Iterate through the Workcenter and Handler FEH records
        for(PCM_Time__c p : pcmWafTestRecords){  
            if(p.RecordType.name == 'WorkCenter'){
                proberTester = p.Handlers_WS__c;
                contingency = p.Contingency_Percent__c;
                swOverHeadTime = p.Overhead_Time__c;
                charPercent = p.Characterization_Percent__c;
                totDetractorHours += p.Planned_Maint__c+p.Unplanned_Maint__c+p.MFG_Planned_Maint__c+p.MFG_Unplanned_Maint__c+p.Calibration__c+p.TAE_ME__c+p.IS_DP__c;   
                
            }else if(p.RecordType.name == 'Handler FEH'){
                indexTime = p.Index_Time__c;
                
                
                totDetractorHours += p.Planned_Maint__c+p.Unplanned_Maint__c+p.MFG_Planned_Maint__c+p.MFG_Unplanned_Maint__c;
            }else if(p.RecordType.name == 'StepTime'){
                stepTime = p.Prober_Steptime__c; 
            }          
                
        }
        
        charPercent = (charPercent==null)?0.0:charPercent;
        swOverHeadTime = (swOverHeadTime==null)?0.0:swOverHeadTime;
        stepTime = (stepTime==null)?0.0:stepTime;
        indexTime = (indexTime==null)?0.0:indexTime;
        proberTester = (proberTester==null)?0.0:proberTester;
        contingency = (contingency==null)?0.0:contingency;

        //Iterate through Quarterly Volumes
        for(String configQtr : configQtrSet){
            
            String yr = configQtr.split('_')[0];
            String qtr = configQtr.split('_')[1];
            
            if(yieldHeaderMap.containsKey(yr+qtr)){
                
                //Calculation for the wafer test cap req
                Decimal goodWaferTestYield = (yieldHeaderMap.get(yr+qtr).WaferTestYield!=null)?yieldHeaderMap.get(yr+qtr).WaferTestYield:0.0;
                Decimal badWaferTestYield = 1-goodWaferTestYield;                
                
                Decimal avgTestTime = (((goodTestTime*goodWaferTestYield) +(badTestTime*badWaferTestYield))*(1-charPercent))+(charPercent*charTestTime); 
                Decimal touchDownUsed;
                Decimal noOfNuts = Decimal.valueOf(config.postFabService.Number_of_DUTS__c);
                Decimal steadyStateCapUsed;  
                if(noOfNuts==1){
                    touchDownUsed = (yieldHeaderMap.get(yr+qtr).cpwVal!=null)?yieldHeaderMap.get(yr+qtr).cpwVal:0.0;    
                }else if(noOfNuts>1){
                    touchDownUsed = (((yieldHeaderMap.get(yr+qtr).cpwVal!=null)?yieldHeaderMap.get(yr+qtr).cpwVal:0.0)/noOfNuts)*ronTouchDownConstant;
                }
                
                
                try{
                    if(noOfNuts<=4){
                        steadyStateCapUsed = 3600/(((avgTestTime+swOverHeadTime+stepTime)*touchDownUsed)+indexTime);   
                    }else{
                        steadyStateCapUsed = 3600/(((goodTestTime+swOverHeadTime+stepTime)*touchDownUsed)+indexTime);
                    }
                }catch(Exception e){steadyStateCapUsed = 0.0;}
                Decimal ratePerHour = steadyStateCapUsed*(1-machineStopDelay);
                Decimal startsPerHour = ratePerHour/(1+ronRetestConstant);
                Decimal lotsTestPerDay;
                try{
                    lotsTestPerDay = (24-totDetractorHours)/((cleanTimeYr.get(yr)+setupTime)+(Decimal.valueOf(pcmLotSizeByYear.get(yr))/startsPerHour));
                    
                }catch(Exception e){lotsTestPerDay = 0.0;}
                Decimal totalSetupHours = lotsTestPerDay*(((cleanTimeYr.containsKey(yr))?cleanTimeYr.get(yr):0.0)+setupTime);
                Decimal netProductiveHours = 24 - (totalSetupHours + totDetractorHours);
                Decimal rawThruput = ((startsPerHour*netProductiveHours)*proberTester)/loadFactor;
                Decimal contingencyThruStart = rawThruput/(1 + contingency);
                Decimal finalVal;
                try{
                    finalVal = 24/contingencyThruStart;
                }catch(Exception e){finalVal=0.0;}
                yieldHeaderMap.get(yr+qtr).addWaferTestCAPReq(finalVal);
            }  
        }
        return yieldHeaderMap;
    }
    
    // Calculate the LYH of Configurator Yield
    public static void lyhCalculate(GenerateYieldAndCost.ConfigDetail config,Map<String,GenerateYieldAndCost.YieldHeader> yieldHeaderMap){
              
              //Calculate the LYH for method as 'Circuit'
              if(config.postfabservice.Method__c=='Circuit'){
                  String query = 'select Q1__c, Q2__c, Q3__c, Q4__c, Q5__c, Q6__c, Q7__c, Q8__c, Q9__c, Q10__c'
                                  +', Q11__c, Q12__c, Q13__c, Q14__c, Q15__c, Q16__c, Q17__c, Q18__c, Q19__c'
                                  +', Q20__c, Q21__c, Q22__c, Q23__c, Q24__c,Q25__c,Q26__c, Start_Quarter__c, Start_Year__c' 
                                  +' FROM PCM_Test_Yield__c WHERE RecordType.name = \'LYH\' AND PT_Number__c =\''
                                  +config.PTNumber+'\'';                                   
                  
                  List<sObject> sobjList = Database.query(query);
                  Integer strCount = 1;
                  if(sobjList!=null){
                      Integer yrCnt = (Integer.valueOf(yrStr)-Integer.valueOf(((PCM_Test_Yield__c)sobjList[0]).Start_Year__c))*4;
                      Integer qtrCnt = Integer.valueOf(thisQuarter.substring(1))-Integer.valueOf((((PCM_Test_Yield__c)sobjList[0]).Start_Quarter__c).substring(1));
                      strCount = yrCnt+qtrCnt+1;
                  }
                                    
                  //Iterate through Quarterly Volumes
                  for(String configQtr : configQtrSet){
                      String yr = configQtr.split('_')[0];
                      String qtr = configQtr.split('_')[1];
                      yieldHeaderMap.get(yr+qtr).addLYH((sobjList!=null && sobjList.size()>0)?((Decimal)((PCM_Test_Yield__c)(sobjList[0])).get('Q'+(strCount>=26?26:strCount)+'__c')):0.0);
                      strCount++;
                  }
              }else if(config.postfabservice.Method__c=='Custom'){
                  //Calculate the LYH for method as 'Custom'
                  PFile_Yield__c lyhObj;
            
                  for(PFile_Yield__c pfy : config.pfd.PFile_Yields__r){
                      if(pfy.recordType.name == 'Custom Yields'){
                          if(pfy.Yield_Type__c=='LYH'){
                              lyhObj=pfy;            
                          }                    
                      }           
                  }
            
                  Integer count=1;            
                  //Iterate through Quarterly Volumes
                  for(String configQtr : configQtrSet){               
                    String yr = configQtr.split('_')[0];
                    String qtr = configQtr.split('_')[1];
                    String key = (count<=24)?('QTR'+String.valueOf(count)+'__c'):'QTR24__c';
                    Decimal lyh = (lyhObj!=null)?(Decimal)lyhObj.get(key):1.0;
                    yieldHeaderMap.get(yr+qtr).addLYH(lyh);
                    count++;
                  }
              }
    }
    
    // Calculation of GCPW for Configurator Yield
    public static void gcpwCalculate(Map<String,GenerateYieldAndCost.YieldHeader> yieldHeaderMap){
          //Iterate through Quarterly Volumes
          for(String configQtr : configQtrSet){
              String yr = configQtr.split('_')[0];
              String qtr = configQtr.split('_')[1];
              Decimal FEOLYield = (yieldHeaderMap!=null && yieldHeaderMap.containsKey(yr+qtr) && yieldHeaderMap.get(yr+qtr).FEOLYield!=null)?yieldHeaderMap.get(yr+qtr).FEOLYield:0.0;
              Decimal BEOLPREYield = (yieldHeaderMap!=null && yieldHeaderMap.containsKey(yr+qtr) && yieldHeaderMap.get(yr+qtr).BEOLPREYield!=null)?yieldHeaderMap.get(yr+qtr).BEOLPREYield:0.0;
              Decimal BEOLPOSTYield = (yieldHeaderMap!=null && yieldHeaderMap.containsKey(yr+qtr) && yieldHeaderMap.get(yr+qtr).BEOLPOSTYield!=null)?yieldHeaderMap.get(yr+qtr).BEOLPOSTYield:0.0;
              Decimal WaferTestYield = (yieldHeaderMap!=null && yieldHeaderMap.containsKey(yr+qtr) && yieldHeaderMap.get(yr+qtr).WaferTestYield!=null)?yieldHeaderMap.get(yr+qtr).WaferTestYield:0.0;
              Decimal cpwVal = (yieldHeaderMap!=null && yieldHeaderMap.containsKey(yr+qtr) && yieldHeaderMap.get(yr+qtr).cpwVal!=null)?yieldHeaderMap.get(yr+qtr).cpwVal:0.0;
              Decimal lyhVal = (yieldHeaderMap!=null && yieldHeaderMap.containsKey(yr+qtr) && yieldHeaderMap.get(yr+qtr).lyhVal!=null)?yieldHeaderMap.get(yr+qtr).lyhVal:0.0;
              
              if(yieldHeaderMap.containsKey(yr+qtr)){
                  yieldHeaderMap.get(yr+qtr).addGCPW(FEOLYield*BEOLPREYield*BEOLPOSTYield*WaferTestYield*cpwVal*lyhVal);
                  
              }
          }
    }
    
    // Calculation of BA for Configurator Yield
    public static void baYieldCalculate(GenerateYieldAndCost.ConfigDetail config,Map<String,GenerateYieldAndCost.YieldHeader> yieldHeaderMap){        
        
        Map<String,Decimal> pcmMap = new Map<String,Decimal>();
        
        if(config.postfabservice.Package_Tech_Method__c=='GF'){
            //Get PCM Yield data for 'BA' recordtype
            for(PCM_Yield__c p : [SELECT   Yield__c
                                            , RecordType.name
                                            , PT_Number__c
                                            , Quarter__c
                                            , Year__c
                                            , Package_Technology__c
                                            , Fab__c 
                                  FROM      PCM_Yield__c 
                                  WHERE     RecordType.name = 'BA'
                                  AND       Package_Technology__c = :config.postFabService.package_technology__c
                                  AND       Fab__c = :config.fab]){
                pcmMap.put(p.Year__c+p.Quarter__c,p.Yield__c);    
            }
        }else if(config.postfabservice.Package_Tech_Method__c=='Custom'){
            for(Config_Post_Fab_Service_Detail__c detail : config.postFabService.Config_Post_Fab_Service_Detail__r){
                if(detail.recordtype.name=='Module Build'){
                    pcmMap.put(detail.Year__c+detail.Quarter__c,detail.Bond_Assembly_Yield_by_Time_Period__c);
                }
            }
        }
        //Iterate through Quarterly Volumes
        for(String configQtr : configQtrSet){
            String yr = configQtr.split('_')[0];
            String qtr = configQtr.split('_')[1];
            
            if(yieldHeaderMap.containsKey(yr+qtr) && !pcmMap.isEmpty() && pcmMap.containsKey(yr+qtr)){
                yieldHeaderMap.get(yr+qtr).addBA((Decimal)(pcmMap.get(yr+qtr)));         
            }else if(yieldHeaderMap.containsKey(yr+qtr)){
                yieldHeaderMap.get(yr+qtr).addBA(0.0);
            }    
        }        
    }
    
    //Calculation of Module Test Yield Calculation
    public static void modYieldCalculate(GenerateYieldAndCost.ConfigDetail config,Map<String,GenerateYieldAndCost.YieldHeader> yieldHeaderMap){        
        //Get PCM Yield record for 'Tech Info' recordtype
        List<String> tableYieldRef = new List<String>();
        for(PCM_Yield__c py :[select    tbl_yld_ref__c
                              from      pcm_yield__c 
                              where     RecordType.name = 'Tech Info' 
                              and       PT_Number__c = :config.PTNumber 
                              and       Wafer_Size__c = :config.waferSize 
                              and       Fab__c = :config.postFabService.module_test_location__c
                              and       Catalog_ID__c =:pcmAdminSetting.Catalog_ID__c
                              and       Version__c =:pcmAdminSetting.Version_ID__c]){
            tableYieldRef.add(py.tbl_yld_ref__c);        
        }                
        
        Map<String,Decimal> tblModYldMap = new Map<String,Decimal>();
        Map<String,Decimal> tblUserDefModYldMap = new Map<String,Decimal>();
        if(config.postfabservice.Module_Test_Yield_Method__c=='GF'){
            //Get TBL YLD Data for PCM Yield table
            for(PCM_Yield__c py : [select    Chip_Low_DIM__c
                                             , Chip_Hi_DIM__c
                                             , Yield__c
                                             , BI_Ind__c
                                             , Qtr_Index__c
                                             , IO_Sector__c
                                   from      PCM_Yield__c 
                                   where     RecordType.name = 'TBL YLD Data' 
                                   and       IO_Sector__c = 'MOD_TST'
                                   and       TBL_YLD_REF__c in :tableYieldRef 
                                   and       Fab__c = :config.postFabService.module_test_location__c
                                   and       Sys_Bus_Area__c = :config.businessUnit
                                   and       Chip_Low_DIM__c <= :config.chipX
                                   and       Chip_Hi_DIM__c >= :config.chipX
                                   and       Catalog_ID__c =:pcmAdminSetting.Catalog_ID__c
                                   and       Version__c =:pcmAdminSetting.Version_ID__c]){
                if(py.BI_Ind__c!=null && py.Qtr_Index__c!=null){
                    if(py.IO_Sector__c == 'MOD_TST' && config.postfabservice.Module_Test_Yield_Method__c=='GF'){
                        tblModYldMap.put(py.BI_Ind__c+String.valueOf(py.Qtr_Index__c),py.Yield__c);
                    } 
                }
            }
        }
        if(config.postfabservice.Module_Test_Yield_Method__c=='Custom'){
            for(Config_Post_Fab_Service_Detail__c detail : config.postFabService.Config_Post_Fab_Service_Detail__r){               
                if(detail.recordtype.name=='Module user defined yield' && config.postfabservice.Module_Test_Yield_Method__c=='Custom'){
                    tblUserDefModYldMap.put(detail.Year__c+detail.Quarter__c,detail.User_Defined_Yield_Module__c);
                }
            }    
        }
        Integer count = 0;
        //Iterate through the quarterly volumes
        for(String configQtr : configQtrSet){
            String yr = configQtr.split('_')[0];
            String qtr = configQtr.split('_')[1];            
            
            Decimal modYld = 0.0;
            count = count>6?6:count;

            if(config.postfabservice.Module_Test_Yield_Method__c=='GF'){
                modYld = tblModYldMap.containsKey('Y'+String.valueOf(count))?(Decimal)tblModYldMap.get('Y'+String.valueOf(count)):0.0;
            }else if(config.postfabservice.Module_Test_Yield_Method__c=='Custom'){
                modYld = tblUserDefModYldMap.containsKey(yr+qtr)?(Decimal)tblUserDefModYldMap.get(yr+qtr):0.0;
            }
            count++;
            
            if(yieldHeaderMap.containsKey(yr+qtr)){
                yieldHeaderMap.get(yr+qtr).addModYld(modYld);
            }
        }
                            
    }    
    
    //Calculation of Burn-in Yield Calculation
    public static void biYieldCalculate(GenerateYieldAndCost.ConfigDetail config,Map<String,GenerateYieldAndCost.YieldHeader> yieldHeaderMap){        
        //Get PCM Yield record for 'Tech Info' recordtype
        List<String> tableYieldRef = new List<String>();
        for(PCM_Yield__c py :[select    tbl_yld_ref__c
                              from      pcm_yield__c 
                              where     RecordType.name = 'Tech Info' 
                              and       PT_Number__c = :config.PTNumber 
                              and       Wafer_Size__c = :config.waferSize 
                              and       Fab__c = :config.postFabService.Reliability_Location__c
                              and       Catalog_ID__c =:pcmAdminSetting.Catalog_ID__c
                              and       Version__c =:pcmAdminSetting.Version_ID__c]){
            tableYieldRef.add(py.tbl_yld_ref__c);        
        }                
        
        Map<String,Decimal> tblBIYldMap = new Map<String,Decimal>();
        Map<String,Decimal> tblUserDefBIYldMap = new Map<String,Decimal>();
        if(config.postfabservice.Burn_in_Stress_Yield_Method__c=='GF'){
            //Get TBL YLD Data for PCM Yield table
            for(PCM_Yield__c py : [select    Chip_Low_DIM__c
                                             , Chip_Hi_DIM__c
                                             , Yield__c
                                             , BI_Ind__c
                                             , Qtr_Index__c
                                             , IO_Sector__c
                                   from      PCM_Yield__c 
                                   where     RecordType.name = 'TBL YLD Data' 
                                   and       IO_Sector__c = 'MOD_BI'
                                   and       TBL_YLD_REF__c in :tableYieldRef 
                                   and       Fab__c = :config.postFabService.Reliability_Location__c
                                   and       Sys_Bus_Area__c = :config.businessUnit
                                   and       Chip_Low_DIM__c <= :config.chipX
                                   and       Chip_Hi_DIM__c >= :config.chipX
                                   and       Catalog_ID__c =:pcmAdminSetting.Catalog_ID__c
                                   and       Version__c =:pcmAdminSetting.Version_ID__c]){
                if(py.BI_Ind__c!=null && py.Qtr_Index__c!=null){
                    if(py.IO_Sector__c == 'MOD_BI' && config.postfabservice.Burn_in_Stress_Yield_Method__c=='GF'){
                        tblBIYldMap.put(py.BI_Ind__c+String.valueOf(py.Qtr_Index__c),py.Yield__c);
                    }
                }
            }
        }
        if(config.postfabservice.Burn_in_Stress_Yield_Method__c=='Custom'){
            for(Config_Post_Fab_Service_Detail__c detail : config.postFabService.Config_Post_Fab_Service_Detail__r){
                if(detail.recordtype.name=='Burn-in user defined yield' && config.postfabservice.Burn_in_Stress_Yield_Method__c=='Custom'){
                    tblUserDefBIYldMap.put(detail.Year__c+detail.Quarter__c,detail.User_Defined_Yield_BI__c);
                }                
            }    
        }
        Integer count = 0;
        //Iterate through the quarterly volumes
        for(String configQtr : configQtrSet){
            String yr = configQtr.split('_')[0];
            String qtr = configQtr.split('_')[1];            
            
            Decimal biYld = 0.0;
            count = count>6?6:count;

            if(config.deliverableType=='Module' && Integer.valueOf(config.relgrade)>=5){
                if(config.postfabservice.Burn_in_Stress_Yield_Method__c=='GF'){
                    biYld = tblBIYldMap.containsKey('Y'+String.valueOf(count))?(Decimal)tblBIYldMap.get('Y'+String.valueOf(count)):0.0;
                }else if(config.postfabservice.Burn_in_Stress_Yield_Method__c=='Custom'){
                    biYld = tblUserDefBIYldMap.containsKey(yr+qtr)?(Decimal)tblUserDefBIYldMap.get(yr+qtr):0.0;
                }
            }else{
                biYld = 1;
            }

            count++;
            
            if(yieldHeaderMap.containsKey(yr+qtr)){
                yieldHeaderMap.get(yr+qtr).addBIYld(biYld);
            }
        }
                            
    }
    
    //Calculation of Burn-in CAP Req
    public static void biCapReqCalculate(GenerateYieldAndCost.ConfigDetail config,Map<String,GenerateYieldAndCost.YieldHeader> yieldHeaderMap){        
        
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
                             and       Location__c = :config.postFabService.Reliability_Location__c
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
                             and       BI_OVEN__c = :config.postFabService.Reliability_Platform__c
                             and       Catalog_ID__c =:pcmAdminSetting.Catalog_ID__c
                             and       Version__c =:pcmAdminSetting.Version_ID__c]){
            if(p.Usage_Fact__c == 'SLOT_PER_OVEN'){
                slotPerOvenUsed = p.Avail__c*p.PCT__c;
            }
            
            if(p.Usage_Fact__c == 'SOCKET_BIB'){
                if(config.postFabService.Number_of_Socket_Per_Boards__c != null && config.postFabService.Number_of_Socket_Per_Boards__c > 0 && config.postFabService.Number_of_Socket_Per_Boards__c < p.Avail__c)
                    socketsPerBibUsed = config.postFabService.Number_of_Socket_Per_Boards__c*p.PCT__c;
                else
                    socketsPerBibUsed = p.Avail__c*p.PCT__c;
            }           
        }        

        Decimal modPerOvenRun = (slotPerOvenUsed*socketsPerBibUsed)*(1-reburnPercent);
        Decimal ovenExecutionTime = ovenSetupBibLoad+ovenUnloadTime;
 
        // Get the Burn-in duration 
        Map<String,Decimal> burnInQuarterMap = new Map<String,Decimal>();         
        for(Config_Post_Fab_Service_Detail__c cpfsd : config.postFabService.Config_Post_Fab_Service_Detail__r){
            if(cpfsd.recordtype.name == 'Burn-in' && !(burnInQuarterMap.containskey(cpfsd.Year__c+cpfsd.Quarter__c))){
                burnInQuarterMap.put(cpfsd.Year__c+cpfsd.Quarter__c,cpfsd.Burn_in_duration__c);
            }    
        }

        
        // Get the workcenter data
        List<PCM_Time__c> ptList = [select    TAE_ME__c
                                              , Planned_Maint__c
                                              , Unplanned_Maint__c
                                              , Contingency_Percent__c 
                                    from      PCM_Time__c
                                    where     RecordType.name = 'WorkCenter'
                                    and       Stage__c = 'MOD_BI'
                                    and       Location__c = :config.postFabService.Reliability_Location__c
                                    and       Workcenter__c = :config.postFabService.Reliability_Platform__c
                                    ];
        
        Decimal totalDownTime = ((ptList!=null && ptList.size()>0)?ptList[0].TAE_ME__c:0.0)
                                        + ((ptList!=null && ptList.size()>0)?ptList[0].Planned_Maint__c:0.0)
                                        + ((ptList!=null && ptList.size()>0)?ptList[0].Unplanned_Maint__c:0.0);
        
        Decimal availableHours = 24-totalDownTime;
        
        // Calculate and add the BI Cap Req to the Configurator Yield object
        for(String configQtr : configQtrSet){
            String yr = configQtr.split('_')[0];
            String qtr = configQtr.split('_')[1];
            
            Decimal burnInDuration = (!burnInQuarterMap.isEmpty() && burnInQuarterMap.containsKey(yr+qtr))?(Decimal)burnInQuarterMap.get(yr+qtr):0.0;
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
            if(yieldHeaderMap.containsKey(yr+qtr)){
                yieldHeaderMap.get(yr+qtr).addBICapReq(finalVal);
            }  
        } 
    }
    
    //Module Test Cap Req Calculation
    public static void modTestCapReqCalculate(GenerateYieldAndCost.ConfigDetail config,Map<String,GenerateYieldAndCost.YieldHeader> yieldHeaderMap){
                    
          Decimal groupPercent = 0.0;
          Decimal loadFactor = 0.0;
          Decimal retestPercent = 0.0;
          Decimal machineStopDelay = 0.0;
          Decimal setupTimePerLot = 0.0;
          Decimal ronRetestPct = 0.0;
          
          //Getting the constant values         
         for(PCM_Time__c p : [select    Value__c
                                        , Constant_Name__c
                              from      PCM_Time__c
                              where     RecordType.name = 'APS Constants'
                              and       Constant_Name__c in ('GROUP_A_PERCENT','LOAD_FACTOR','RETEST_PER_CENT','MACH_STOP_DELAY','SETUP_TIME_PER_LOT','RON_RETEST_PERCENT')
                              and       Location__c = :config.postFabService.test_location__c
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
                              and       Location__c = :config.postFabService.module_test_location__c 
                              and       Stage__c = 'MOD_TST' 
                              and       Workcenter__c = :config.postFabService.module_test_platform__c
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
         
         //Get the PCM Lot Size records
         List<PCM_Time__c>   pcmLotSizeRec = [select Lot_Size__c
                                                    , Year__c
                                             from   PCM_Time__c
                                             where  RecordType.name = 'Lot Size'
                                             and    Stage__c = 'MOD_TST' 
                                             and    Year__c in :config.years
                                             and    Package_Tech__c = :config.postFabService.package_technology__c];          
         Decimal pcmData = 0.0;
         //Get PCM data for PT Number and also for 'DEFAULT' PT number
         for(PCM_Time__c p : [select    Data__c
                                        , PT_Number__c
                              from      PCM_Time__c
                              where     RecordType.name = 'Time Data'
                              and       relgrade__c = :config.relgrade
                              and       ((PT_Number__c = :config.PTNumber                                       
                              and       Time_Comp__c = 'BTT_PCT'
                              and       workcenter__c = :config.postFabService.module_test_platform__c)
                              OR        (PT_Number__c = 'DEFAULT'                                       
                              and       Time_Comp__c = 'BTT_PCT'
                              and       workcenter__c = 'DEFAULT'))
                              and       Catalog_ID__c =:pcmAdminSetting.Catalog_ID__c
                              and       Version__c =:pcmAdminSetting.Version_ID__c]){             
             if(p.PT_Number__c == config.PTNumber){
                 pcmData = p.Data__c;
                 break;
             }
             if(pcmData == 0.0 && p.PT_Number__c == 'DEFAULT'){
                 pcmData = p.Data__c;    
             }    
         }         
         
         Map<String,String> pcmLotSizeByYear = new Map<String,String>();
         for(PCM_Time__c p : pcmLotSizeRec){
             pcmLotSizeByYear.put(p.Year__c,p.Lot_Size__c);    
         }         
         
         Decimal goodTestTime = (totalModuleTestTime!=null)?totalModuleTestTime:0.0;
         Decimal badTestTime = goodTestTime*((pcmData!=null)?pcmData:0.0);
         Decimal charTestTime = goodTestTime;
         
         //Iterate through quarterly volumes and calculate the module test cap req
         for(String configQtr : configQtrSet){
             String yr = configQtr.split('_')[0];
             String qtr = configQtr.split('_')[1];
         
             Decimal modYld = (yieldHeaderMap.containsKey(yr+qtr) && yieldHeaderMap.get(yr+qtr).modYld!=null)?(Decimal)(yieldHeaderMap.get(yr+qtr).modYld):0.0;
             Decimal badWaferTestYld = 1-modYld;
             
             Decimal avgTestTime = (((goodTestTime*modYld)+(badTestTime*badWaferTestYld))*(1-charPercent))+(charPercent*charTestTime);
             Decimal noOfDuts = (config.postFabService!=null && config.postFabService.Module_Number_of_DUTS__c!=null)?Decimal.valueOf(config.postFabService.Module_Number_of_DUTS__c):0.0;
             Decimal steadyStateCapUsed;  
             try{
                 if(noOfDuts<=4){
                     steadyStateCapUsed= 3600/((avgTestTime+overHeadTime+indexTime)/noOfDuts);    
                 }else{
                     steadyStateCapUsed= 3600 /((goodTestTime+overHeadTime+indexTime)/noOfDuts);
                 }
               
             }catch(Exception e){steadyStateCapUsed=0.0;}
             Decimal ratePerHr = steadyStateCapUsed*(1-machineStopDelay);
             Decimal startsPerHr;
             try{
                 startsPerHr = ratePerHr/(1+((retestPercent==0)?(1-modYld+ronRetestPct):retestPercent));
               
             }catch(Exception e){startsPerHr=0;}
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
             if(yieldHeaderMap.containsKey(yr+qtr)){
                 yieldHeaderMap.get(yr+qtr).addModTestCapReq(finalResult);
             }
         }                  
    }        
            
}