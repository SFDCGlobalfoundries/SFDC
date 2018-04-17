/*
    Author: Ariz Solito
    Description: Apex class logic for generating quarter year costs for configurations 
    History: 
        Asolito     11102016    - Code creation.                                   
*/
public class GenerateCost {
    final static Set<String> BONDINGPRODUCTYPE = new Set<String>{'Wafer',//for Allocation calc
                                                                 'Finished Wafer',
                                                                 'Tested Wafer',
                                                                 'Chip',
                                                                 'Module',
                                                                 'MCM'};
    
    final static Set<String> WAFERTESTPRODUCTYPE = new Set<String>{'Tested Wafer',
                                                                   'Chip',
                                                                   'Module',
                                                                   'MCM'};
                                                                   
    final static Set<String> MODULETESTPRODUCTYPE = new Set<String>{'Module',
                                                                    'MCM'};                                                                   
    
    static PCM_Administration__c pcmAdminSetting = PCM_Administration__c.getInstance('CURRENT_SETTING'); 
    static Map<String,Decimal> mapEncapCap= new map<String,Decimal>();    
    static Decimal CapQty =0;
  //Ravindra- BIB changes start
  static Map<String,Decimal> biBoardCostMap= new map<String,Decimal>();       
    static Map<String,DEcimal> biBoardVolMap= new map<String,DEcimal>();       
    //Ravindra- BIB changes end
  
  //Method will add the cost details to the header with custom user input costs
    public static Map<String,CostHeader> addToMap(GenerateYieldAndCost.ConfigDetail config, 
                                                  String year, 
                                                  String quarter,
                                                  String costType,
                                                  Decimal cost,
                                                  Map<String,GenerateYieldAndCost.YieldHeader> yieldHeaderMap,
                                                  Map<String,CostHeader> costHeaderMap){                                                          
        //create cost header
        String key = year + quarter;        
        if(costHeaderMap.containsKey(key)){
            costHeaderMap.get(key).addCostDetail(costType,cost);
        } else {
            if(yieldHeaderMap.containsKey(key)){
                costHeaderMap.put(key,new CostHeader(config,year,quarter,yieldHeaderMap.get(key)));    
                costHeaderMap.get(key).addCostDetail(costType,cost);
            }                
        }   
        
        return costHeaderMap;
    }
    
    //Method will add the cost details to the header
    public static Map<String,CostHeader> addToMap(GenerateYieldAndCost.ConfigDetail config, 
                                                  PCM_Cost__c c, 
                                                  Map<String,GenerateYieldAndCost.YieldHeader> yieldHeaderMap,
                                                  Map<String,CostHeader> costHeaderMap,
                                                  Map<String,Decimal> otherCostConstant){
        //create cost header
        String key = c.year__c + c.quarter__c;                
        
        if(costHeaderMap.containsKey(key)){
            if(otherCostConstant == null || otherCostConstant.size() == 0){
                costHeaderMap.get(key).addCostDetail(c);
            }
               
            if(otherCostConstant <> null && otherCostConstant.size() > 0){
                costHeaderMap.get(key).populateOtherCostConstant(otherCostConstant);
            }
        } else {
            if(yieldHeaderMap.containsKey(key)){
                if(otherCostConstant == null || otherCostConstant.size() == 0){
                    costHeaderMap.put(key,new CostHeader(config,c,yieldHeaderMap.get(key)));    
                    costHeaderMap.get(key).addCostDetail(c);
                }
                
                if(otherCostConstant <> null && otherCostConstant.size() > 0){
                    costHeaderMap.get(key).populateOtherCostConstant(otherCostConstant);
                }
            }
        }   
        
        return costHeaderMap;
    }
    
    //Method will pull Module BI and test cost
    public static Map<String,CostHeader> generateModuleBIandTestCost(GenerateYieldAndCost.ConfigDetail config, 
                                                                    Map<String,GenerateYieldAndCost.YieldHeader> yieldHeaderMap,
                                                                    Map<String,CostHeader> costHeaderMap){ 
                                                                    
        List<String> costFilters = new List<String>();
        List<String> testPlatforms = new List<String>();
        List<String> fabs = new List<String>();
        
        costFilters.add('Module Test Hour');
        testPlatforms.add(config.postFabService.module_test_platform__c);
        fabs.add(config.postFabService.module_test_location__c);
        
        //check for reliability grade > 5
        if(config.relgrade <> null){
            if(Integer.valueOf(config.relgrade) >= 5){
                costFilters.add('Module BI Hour');                
                testPlatforms.add(config.postFabService.reliability_platform__c);
                fabs.add(config.postFabService.reliability_platform__c);
            }
        }
        
        //Get the BI and Module test cost
        for(PCM_Cost__c c: [SELECT id,cost__c,recordType.name,quarter__c,year__c,allocation__c,pfactor__c
                               FROM PCM_Cost__c 
                               WHERE pn__c = 'NA'
                               AND recordType.name IN :costFilters                               
                               AND test_platform__c IN :testPlatforms
                               AND fab__c IN :fabs
                               AND year__c IN :config.years                               
                               ORDER BY year__c,quarter__c]){ 
            costHeaderMap = addToMap(config,c,yieldHeaderMap,costHeaderMap,null);                                                    
        }  
  //Ravindra - BIB Changes Starts  
    for(Config_Post_Fab_Service_Detail__c c:[Select id, Year__c,Quarter__c,Burn_in_Board_Cost__c 
                                FROM Config_Post_Fab_Service_Detail__c
                WHERE config_post_fab_service__c = :config.postFabService.id
                                AND recordType.name = 'SC Burn in board cost']){
                                biBoardCostMap.put(c.Year__c+c.Quarter__c, c.Burn_in_Board_Cost__c);  
        }
                                
                                                                        
        for(Config_Quarterly_Volume__c vol: config.quarterlyVolumes){
              if(vol.Q1_Volume__c!=null ){
                 biBoardVolMap.put(vol.Year__c+'Q1',vol.Q1_Volume__c);   
              }
                if(vol.Q2_Volume__c!=null){
                 biBoardVolMap.put(vol.Year__c+'Q2',vol.Q2_Volume__c);   
              }
                if(vol.Q3_Volume__c!=null ){
                 biBoardVolMap.put(vol.Year__c+'Q3',vol.Q3_Volume__c);   
              }
                if(vol.Q4_Volume__c!=null){
                 biBoardVolMap.put(vol.Year__c+'Q4',vol.Q4_Volume__c);   
              }
              
          }
//Ravindra - BIB Changes ends
      
        //Get the SBT cost for Module Test
        for(PCM_Cost__c c: [SELECT id,cost__c,recordType.name,quarter__c,year__c,allocation__c,pfactor__c
                               FROM PCM_Cost__c 
                               WHERE pn__c = 'NA'
                               AND recordType.name = 'Module Test SBT'
                               AND package_technology__c = :config.postFabService.package_technology__c
                               AND fab__c = :config.postFabService.module_test_location__c
                               AND year__c IN :config.years                               
                               ORDER BY year__c,quarter__c]){ 
            costHeaderMap = addToMap(config,c,yieldHeaderMap,costHeaderMap,null);                                                    
        }  
                                                                               
                                                                               
        return costHeaderMap;                                                   
    }
    
    //Method will pull substrate and BA Cost
    public static Map<String,CostHeader> generateSubstrateAndBACost(GenerateYieldAndCost.ConfigDetail config, 
                                                                    Map<String,GenerateYieldAndCost.YieldHeader> yieldHeaderMap,
                                                                    Map<String,CostHeader> costHeaderMap){ 
                                                                    
        if(config.postFabService.package_tech_method__c == 'GF'){
           //Substrate PN       
            List<PCM_Cost__c> substrateCost = [SELECT PN__c 
                                                 FROM PCM_Cost__c 
                                                 WHERE recordType.name = 'Cost Sub REF' 
                                                 AND package_technology__c = :config.postFabService.package_technology__c
                                                 AND body_length__c = :config.postFabService.body_length__c
                                                 AND body_width__c = :config.postFabService.body_width__c 
                                                 AND subst_layers__c = :config.postFabService.subst_layer__c 
                                                 AND subst_IO_pitch__c = :config.postFabService.subst_IO_pitch__c
                                                 AND line_width__c = :config.postFabService.line_width__c
                                                 AND subst_material__c = :config.postFabService.subst_material__c
                                                 AND package_IO__c = :integer.valueOf(config.postFabService.Package_IO__c)];
            
           
            //BA PN
            List<PCM_Cost__c> BACost = [SELECT PN__c
                                           FROM PCM_Cost__c 
                                           WHERE recordType.name = 'Cost Module BA REF' 
                                           AND package_technology__c = :config.postFabService.package_technology__c
                                           AND body_length__c = :config.postFabService.body_length__c
                                           AND body_width__c = :config.postFabService.body_width__c
                                           AND package_IO_pitch__c = :config.postFabService.package_IO_pitch__c
                                           AND package_IO_count__c = :config.postFabService.package_IO__c
                                           AND layer_count__c = :config.postFabService.subst_layer__c
                                           AND wire_bond_material__c = :config.postFabService.wire_material_for_WB__c];            
                                            
            List<PCM_Cost__c> PNRecs = new List<PCM_Cost__c>();                                        
            PNRecs.addAll(substrateCost);
            PNRecs.addAll(BACost);        
             
            List<String> PNs = new List<String>();                               
            for(PCM_Cost__c p: PNRecs){
                PNs.add(p.PN__c);
            }                 
            
            //Substrate and BA cost
            for(PCM_Cost__c c : [SELECT id,cost__c,recordType.name,quarter__c,year__c,allocation__c,pfactor__c
                                   FROM PCM_Cost__c 
                                   WHERE recordType.name IN ('SUB FIN CC','Module BA ASM')
                                   AND PN__c IN :PNs
                                   AND year__c IN :config.years
                                   //AND fab__c = :config.fab
                                   ORDER BY year__c,quarter__c]){            
                           
            costHeaderMap = addToMap(config,c,yieldHeaderMap,costHeaderMap,null); 
            }
           
             //===================================================================================  
             //Encapsulation PN
            List<PCM_Cost__c> EncapsulationCost = [SELECT PN__c
                                           FROM PCM_Cost__c 
                                           WHERE recordType.name = 'Cost LID REF' 
                                           AND encapsulation__c = :config.postFabService.encapsulation__c];
            
            //Capacitor PN
            List<PCM_Cost__c> CapacitorCost = [SELECT PN__c
                                           FROM PCM_Cost__c 
                                           WHERE recordType.name = 'Cost DECAP REF' 
                                           AND capacitor_Type__c = :config.postFabService.capacitor_type__C];
            
            CapQty =config.postFabService.Capacitor_Qty__c;
            List<PCM_Cost__c> PNRef = new List<PCM_Cost__c>();   
            PNRef.addAll(EncapsulationCost);
            PNRef.addAll(CapacitorCost);        
             
            PNs.clear(); // Using same list defined above
            
            for(PCM_Cost__c p: PNRef){
                PNs.add(p.PN__c);
            }                 
           
            //Getting Encapsulation & Capacitor Cost
            for(PCM_Cost__c c : [SELECT id,cost__c,recordType.name,quarter__c,year__c
                                   FROM PCM_Cost__c 
                                   WHERE recordType.name IN ('Module BA DCAPS ASM','Module BA LID ASM')
                                   AND PN__c IN :PNs
                                   AND year__c IN :config.years
                                   //AND fab__c = :config.fab
                                   ORDER BY year__c,quarter__c]){            
                           
               mapEncapCap.put(c.recordType.name +'-'+c.Year__c+c.Quarter__c, c.Cost__c) ;             
            }                
            
            //Substrate and BA Vol Mult
            for(PCM_Cost__c c: [SELECT id,volume_mult__c,volume_lower__c,volume_upper__c,recordType.name,quarter__c,year__c,
                                       constant_value__c
                                  FROM PCM_Cost__c
                                  WHERE recordType.name IN ('SUB FIN CCVOL','Module BA CCVOL')
                                  AND package_technology__c = :config.postFabService.package_technology__c
                                  AND year__c  IN :config.years 
                                  /*AND fab__c = :config.fab*/
								  Order by year__c, quarter__c, volume_lower__c]){            
                 
                for(Config_Quarterly_Volume__c vol: config.quarterlyVolumes){
                    if(Integer.valueOf(c.year__c) == vol.year__c){
						Map<String,Decimal> constMap = new Map<String,Decimal>();
                    	c.quarter__c = c.quarter__c.trim();
                        Integer quarterVol = null;
						if(c.quarter__c.equals('Q1') || c.quarter__c.equals('Q2') || c.quarter__c.equals('Q3') || c.quarter__c.equals('Q4') )
							quarterVol = Integer.valueOf(vol.get(c.quarter__c+'_volume__c')); 
                        if(quarterVol <> null &&  quarterVol >= c.volume_lower__c && quarterVol <= c.volume_upper__c){  
							constMap.put(c.recordType.name,c.volume_mult__c);
							costHeaderMap = addToMap(config,c,yieldHeaderMap,costHeaderMap,constMap); 
							break;
						}                                
                    }  
                }                        
            } 
        } else if (config.postFabService.package_tech_method__c == 'Custom'){
            for(Config_Post_Fab_Service_Detail__c c: [SELECT bond_assembly_cost_by_time_period__c,subst_cost_by_time_period__c,
                                                             package_option_cost_by_time_period__c,quarter__c,year__c
                                                        FROM Config_Post_Fab_Service_Detail__c
                                                        WHERE config_post_fab_service__c = :config.postFabService.id
                                                        AND recordType.name = 'Module Build']){
                //Substrate cost                                        
                costHeaderMap = addToMap(config,c.year__c,c.quarter__c,'Substrate Cost',c.subst_cost_by_time_period__c,yieldHeaderMap,costHeaderMap);
                //BA cost                                         
                costHeaderMap = addToMap(config,c.year__c,c.quarter__c,'Module BA Cost',c.bond_assembly_cost_by_time_period__c,yieldHeaderMap,costHeaderMap);
                                                                        
            }                                                        
        }                             
                                                                               
        return costHeaderMap;                                                   
    }
    
    //Method will pull Wafer test cost
    public static Map<String,CostHeader> generateWaferTestCost(GenerateYieldAndCost.ConfigDetail config, 
                                                               Map<String,GenerateYieldAndCost.YieldHeader> yieldHeaderMap,
                                                               Map<String,CostHeader> costHeaderMap){            
    
        //Wafer Test Cost
        List<PCM_Cost__c> waferTestCost = [SELECT id,cost__c,recordType.name,allocation__c,test_platform__c,fab__c,quarter__c,
                                                  constant_value__c,constant_name__c,PFactor__c,dicing__c,pt_number__c,year__c                                                 
                                             FROM PCM_Cost__c
                                             WHERE PN__c = 'NA'
                                             AND fab__c = :config.postFabService.test_location__c
                                             AND Catalog_ID__c =:pcmAdminSetting.Catalog_ID__c
                                             AND Version__c =:pcmAdminSetting.Version_ID__c
                                             AND Wafer_Size__c = :config.waferSize
                                             AND recordType.name IN ('Wafer Test Hour','Wafer Test GEN','Rate Constants',
                                                                     'DSP Dicing','DSP Factor','DSP GroupB','DSP Picking')
                                             AND year__c IN :config.years
                                             ORDER BY year__c,quarter__c];
                                             
        //add on the last part of the filter as DSP factor is yearly only                                           
        Map<String,PCM_Cost__c> DSPFactorFilterMap = new Map<String,PCM_Cost__c>();
                                        
        for(PCM_Cost__c c: waferTestCost){                                                                                    
            Boolean addToMap = false;
            Map<String,Decimal> constMap = new Map<String,Decimal>();
            
            if(c.recordType.name == 'Wafer Test GEN'){
                addToMap = true;         
            } else if(c.recordType.name == 'Wafer Test Hour'){
                if(c.test_platform__c ==  config.postFabService.test_platform__c){
                    addToMap = true;
                }   
            } else if(c.recordType.name == 'DSP Dicing'){
                if(c.dicing__c == 'YES'){
                    addToMap = true;
                }
            } else if(c.recordType.name == 'DSP Picking'){
                if(c.dicing__c == 'YES'){
                    addToMap = true;
                }
            } else if(c.recordType.name == 'DSP GroupB'){
                if(c.dicing__c == 'YES'){
                    addToMap = true;
                }
            } else if(c.recordType.name == 'DSP Factor'){                            
                if(c.pt_number__c == config.PTNumber){  
                    DSPFactorFilterMap.put(c.year__c,c);                    
                }
            }  else if(c.recordType.name == 'Rate Constants'){
                if(c.constant_name__c == 'DICING_K'){
                    constMap.put('DICING_K',c.constant_value__c);
                    addToMap = true;
                } else if(c.constant_name__c == 'DICING_VAR'){
                    constMap.put('DICING_VAR',c.constant_value__c);
                    addToMap = true;
                } else if(c.constant_name__c == 'SORT_PCK_VAR'){
                    constMap.put('SORT_PCK_VAR',c.constant_value__c);                    
                    addToMap = true;
                } else if(c.constant_name__c == 'SORT_PCK_K'){
                    constMap.put('SORT_PCK_K',c.constant_value__c);
                    addToMap = true;
                } else if(c.constant_name__c == 'GROUP_B_VAR'){
                    constMap.put('GROUP_B_VAR',c.constant_value__c);
                    addToMap = true;
                } else if(c.constant_name__c == 'GROUP_B_K'){
                    constMap.put('GROUP_B_K',c.constant_value__c);
                    addToMap = true;
                }
            }
            
            if(addToMap){
                costHeaderMap = addToMap(config,c,yieldHeaderMap,costHeaderMap,constMap);                                                                           
            }                                    
        } 
        
        //Add DSP Factor to the Cost Header having the same year
        for(String key: costHeaderMap.keyset()){
            CostHeader temp = costHeaderMap.get(key);              
            if(DSPFactorFilterMap.containsKey(temp.year)){
                temp.addCostDetail(DSPFactorFilterMap.get(temp.year));    
            }
        }
        
        return costHeaderMap;                                                   
    }
    
    //Method will pull Bonding and Allocation cost
    public static Map<String,CostHeader> generateBondingAndAllocationCost(GenerateYieldAndCost.ConfigDetail config, 
                                                                          Map<String,GenerateYieldAndCost.YieldHeader> yieldHeaderMap,
                                                                          Map<String,CostHeader> costHeaderMap){            
            
        //Wafer Finishing and Allocation costs
        List<String> fabs = new List<String>{config.fab,config.postFabService.fab__c};
        List<PCM_Cost__c> waferandAllocCost = [SELECT id,cost__c,recordType.name,mask_layer__c,business_unit__c,Product_Type__c,quarter__c,year__c,
                                                      bonding__c,Solder_Type__c,Solder__c,BLM_Size_Type__c,Minimum_C4_Pitch__c,fab__c,PFactor__c,
                                                      Allocation__c,allocation_name__c
                                                 FROM PCM_Cost__c
                                                 WHERE PN__c = 'NA'
                                                 AND fab__c IN :fabs
                                                 AND Catalog_ID__c =:pcmAdminSetting.Catalog_ID__c
                                                 AND Version__c =:pcmAdminSetting.Version_ID__c
                                                 AND Wafer_Size__c = :config.waferSize
                                                 AND recordType.name IN ('Bonding','Allocation')
                                                 AND year__c IN :config.years
                                                 ORDER BY year__c,quarter__c]; 
                                         
        for(PCM_Cost__c c: waferandAllocCost){                                                                                    
            Boolean addToMap = false;
            
            if(c.recordType.name == 'Bonding'){               
                if(c.bonding__c == config.postFabService.bonding__c && 
                   c.BLM_size_type__c == config.postFabService.BLM_Size_Type__c &&
                   c.minimum_C4_pitch__c == config.postFabService.Minimum_C4_pitch__c &&
                   c.solder__c == config.postFabService.solder__c &&
                   c.solder_type__c == config.postFabService.solder_type__c &&
                   c.fab__c == config.postFabService.fab__c){
                addToMap = true; 
                }                                             
            } else if(c.recordType.name == 'Allocation'){
                String businessUnit = config.businessUnit == 'MCM' ? 'Module' : config.businessUnit;
                if(c.business_unit__c == businessUnit && 
                   c.product_type__c == config.productType &&
                   c.fab__c == config.fab){
                    addToMap = true;
                } 
            }
            
            if(addToMap){
                costHeaderMap = addToMap(config,c,yieldHeaderMap,costHeaderMap,null);                                                                           
            }
        } 
        
        return costHeaderMap;                                                   
    }
    
    //Method will pull FEOL cost
    public static Map<String,CostHeader> generateFEOLCost(GenerateYieldAndCost.ConfigDetail config, 
                                                          Map<String,GenerateYieldAndCost.YieldHeader> yieldHeaderMap,
                                                          Map<String,CostHeader> costHeaderMap){            
    
        //FEOL costs        
        List<PCM_Cost__c> techCost = [SELECT id,cost__c,recordType.name,mask_layer__c,quarter__c,year__c,allocation__c,business_unit__c,
                                             product_Type__c,layer_of_metal__c,PFactor__c
                                         FROM PCM_Cost__c
                                         WHERE PN__c = 'NA'                     
                                         AND recordType.name IN ('Mask Layer','Wafer Processing','Raw Wafer')
                                         AND Catalog_ID__c =:pcmAdminSetting.Catalog_ID__c
                                         AND fab__c = :config.fab
                                         AND Version__c =:pcmAdminSetting.Version_ID__c
                                         AND PT_number__c = :config.PTNumber
                                         AND Wafer_Size__c = :config.waferSize                                         
                                         AND year__c IN :config.years
                                         ORDER BY year__c,quarter__c
                                         ]; 
                                         
        for(PCM_Cost__c c: techCost){                                                                                    
            Boolean addToMap = false;
            
            //Raw Wafer
            if(c.recordType.name == 'Raw Wafer'){                
                addToMap = true;           
            } else if(c.recordType.name == 'Mask Layer'){
                if(config.masks.contains(c.mask_layer__c)){
                    addToMap = true;
                }
            } else if(c.recordType.name == 'Wafer Processing'){
                if(c.layer_of_metal__c == config.metalLayers){
                    addToMap = true;
                } 
            } 
            
            if(addToMap){              
                costHeaderMap = addToMap(config,c,yieldHeaderMap,costHeaderMap,null);                                                                                       
            }
        } 
        
        return costHeaderMap;                                                   
    }
    
    //Method will calculate the different cost totals
    public static List<Configurator_Cost__c> computeCosts(List<Configurator_Yield__c> yields, 
                                                          GenerateYieldAndCost.ConfigDetail config){
                    
        Map<String,Configurator_Yield__c> yieldMaps = new Map<String,Configurator_Yield__c>();
        for(Configurator_Yield__c y: yields){
            yieldMaps.put(y.year__c + y.quarter__c,y);                                                        
        }
        
        List<Configurator_Cost__c> calculatedTotalCosts = new List<Configurator_Cost__c>();               
        for(Configurator_Cost__c c: [SELECT calculated_total_wafer_processing_cost__c,calculated_total_wafer_finishing_cost__c,
                                            calculated_total_wafer_test_cost__c,calculated_total_substrate_cost__c,calculated_total_module_assembly_cost__c, 
                                            calculated_total_module_burn_in_cost__c,calculated_total_module_test_cost__c,calculated_total_allocation_cost__c,
                                            total_wafer_processing_cost__c,total_raw_wafer_cost__c,
                                            total_mask_layer_list_cost__c,total_wafer_finishing_cost__c,
                                            total_wafer_test_cost__c,total_substrate_cost__c,total_BA_cost__c,
                                            total_BI_cost__c,total_module_test_cost__c,total_allocation__c,
                                            year__c,quarter__c,total_wafer_dicing_cost__c
                                       FROM Configurator_Cost__c 
                                       WHERE quote_proposal__c = :config.configID]){
            String key = c.year__c + c.quarter__c;                                        
            if(yieldMaps.containsKey(key)){  
                calculatedTotalCosts.add(calculateCostTotals(c,yieldMaps.get(key),config));
                
            }
        }
        
        return calculatedTotalCosts;
    } 
    
    
    //Method will calculate the per quarter year cost total
    public static Configurator_Cost__c calculateCostTotals(Configurator_Cost__c cost,
                                                           Configurator_Yield__c yield,
                                                           GenerateYieldAndCost.ConfigDetail config){
        Decimal waferProcessDiv = 0;
        Decimal waferFinishingDiv = 0;
        Decimal waferTestDiv = 0;
        Decimal waferTestDiv2 = 0;
        Decimal waferTestDiv3 = 0;
        Decimal substrateDiv = 0;
        Decimal BADiv = 0;
        Decimal BIDiv = 0;
        Decimal moduleTestDiv = 0;
        Decimal checkBIYield = 1;
        
        //check if relgrade >= 5 for BI
        if(Integer.valueOf(config.relgrade) >= 5){
            checkBIYield = yield.BI__c;
        }
        
        if(config.productType == 'Wafer'){
            waferProcessDiv = yield.FEOL_Yield__c == NULL ? 0 : yield.FEOL_Yield__c; 
               
        } else if(config.productType == 'Finished Wafer'){
            waferProcessDiv = (yield.FEOL_Yield__c == NULL ? 0 : yield.FEOL_Yield__c) * 
                              (yield.BEOL_PRE_Yield__c == NULL ? 0 : yield.BEOL_PRE_Yield__c) * 
                              (yield.BEOL_POST_Yield__c == NULL ? 0 : yield.BEOL_POST_Yield__c);
                                
            waferFinishingDiv = (yield.BEOL_PRE_Yield__c == NULL ? 0 : yield.BEOL_PRE_Yield__c) * 
                                (yield.BEOL_POST_Yield__c == NULL ? 0 : yield.BEOL_POST_Yield__c);
                                
        } else if(config.productType == 'Tested Wafer'){
            waferProcessDiv = (yield.FEOL_Yield__c == NULL ? 0 : yield.FEOL_Yield__c) * 
                              (yield.BEOL_PRE_Yield__c == NULL ? 0 : yield.BEOL_PRE_Yield__c) * 
                              (yield.BEOL_POST_Yield__c == NULL ? 0 : yield.BEOL_POST_Yield__c) *
                              (yield.LYH__c == NULL ? 0 : yield.LYH__c);
                                
            waferFinishingDiv = (yield.BEOL_PRE_Yield__c == NULL ? 0 : yield.BEOL_PRE_Yield__c) * 
                                (yield.BEOL_POST_Yield__c == NULL ? 0 : yield.BEOL_POST_Yield__c) *                                
                                (yield.LYH__c == NULL ? 0 : yield.LYH__c);
                                  
            waferTestDiv = (yield.BEOL_POST_Yield__c == NULL ? 0 : yield.BEOL_POST_Yield__c) *
                           (yield.LYH__c == NULL ? 0 : yield.LYH__c);     
                           
            waferTestDiv2 = (yield.BEOL_POST_Yield__c == NULL ? 0 : yield.BEOL_POST_Yield__c);         
        
        } else if(config.productType == 'Chip'){
            waferProcessDiv = (yield.FEOL_Yield__c == NULL ? 0 : yield.FEOL_Yield__c) * 
                              (yield.BEOL_PRE_Yield__c == NULL ? 0 : yield.BEOL_PRE_Yield__c) * 
                              (yield.BEOL_POST_Yield__c == NULL ? 0 : yield.BEOL_POST_Yield__c) *
                              (yield.wafer_test_Yield__c == NULL ? 0 : yield.wafer_test_Yield__c) *
                              (yield.LYH__c == NULL ? 0 : yield.LYH__c) *
                              (yield.CPW__c == NULL ? 0 : yield.CPW__c);
                                
            waferFinishingDiv = (yield.BEOL_PRE_Yield__c == NULL ? 0 : yield.BEOL_PRE_Yield__c) * 
                                (yield.BEOL_POST_Yield__c == NULL ? 0 : yield.BEOL_POST_Yield__c) *
                                (yield.wafer_test_Yield__c == NULL ? 0 : yield.wafer_test_Yield__c) *
                                (yield.LYH__c == NULL ? 0 : yield.LYH__c) *
                                (yield.CPW__c == NULL ? 0 : yield.CPW__c);
                                  
            waferTestDiv = (yield.BEOL_POST_Yield__c == NULL ? 0 : yield.BEOL_POST_Yield__c) *
                           (yield.wafer_test_Yield__c == NULL ? 0 : yield.wafer_test_Yield__c) *
                           (yield.LYH__c == NULL ? 0 : yield.LYH__c) *
                           (yield.CPW__c == NULL ? 0 : yield.CPW__c);     
                           
            waferTestDiv2 = (yield.BEOL_POST_Yield__c == NULL ? 0 : yield.BEOL_POST_Yield__c) *
                            (yield.CPW__c == NULL ? 0 : yield.CPW__c);                                
                                                                                                                       
        }  else if(config.productType == 'Module' ||config.productType == 'MCM'){
            waferProcessDiv = (yield.FEOL_Yield__c == NULL ? 0 : yield.FEOL_Yield__c) * 
                              (yield.BEOL_PRE_Yield__c == NULL ? 0 : yield.BEOL_PRE_Yield__c) * 
                              (yield.BEOL_POST_Yield__c == NULL ? 0 : yield.BEOL_POST_Yield__c) *
                              (yield.wafer_test_Yield__c == NULL ? 0 : yield.wafer_test_Yield__c) *
                              (yield.LYH__c == NULL ? 0 : yield.LYH__c) *
                              (yield.BA__c == NULL ? 0 : yield.BA__c) *
                              (checkBIYield == NULL ? 0 : checkBIYield) *
                              (yield.module_test_yield__c == NULL ? 0 : yield.module_test_yield__c) *
                              (yield.CPW__c == NULL ? 0 : yield.CPW__c);
                                
            waferFinishingDiv = (yield.BEOL_PRE_Yield__c == NULL ? 0 : yield.BEOL_PRE_Yield__c) * 
                                (yield.BEOL_POST_Yield__c == NULL ? 0 : yield.BEOL_POST_Yield__c) *
                                (yield.wafer_test_Yield__c == NULL ? 0 : yield.wafer_test_Yield__c) *
                                (yield.LYH__c == NULL ? 0 : yield.LYH__c) *                                    
                                (yield.BA__c == NULL ? 0 : yield.BA__c) *
                                (checkBIYield == NULL ? 0 : checkBIYield) *
                                (yield.module_test_yield__c == NULL ? 0 : yield.module_test_yield__c) *
                                (yield.CPW__c == NULL ? 0 : yield.CPW__c);
                                  
            waferTestDiv = (yield.BEOL_POST_Yield__c == NULL ? 0 : yield.BEOL_POST_Yield__c) *
                           (yield.wafer_test_Yield__c == NULL ? 0 : yield.wafer_test_Yield__c) *
                           (yield.LYH__c == NULL ? 0 : yield.LYH__c) *
                           (yield.CPW__c == NULL ? 0 : yield.CPW__c);     
                           
            waferTestDiv2 = (yield.BEOL_POST_Yield__c == NULL ? 0 : yield.BEOL_POST_Yield__c) *
                            (yield.CPW__c == NULL ? 0 : yield.CPW__c); 
                            
            waferTestDiv3 = (yield.BA__c == NULL ? 0 : yield.BA__c) *
                            (checkBIYield == NULL ? 0 : checkBIYield) *
                            (yield.module_test_yield__c == NULL ? 0 : yield.module_test_yield__c);                             
                           
            substrateDiv = (yield.BA__c == NULL ? 0 : yield.BA__c) *
                           (checkBIYield == NULL ? 0 : checkBIYield) *
                           (yield.module_test_yield__c == NULL ? 0 : yield.module_test_yield__c);
            
            BADiv = (yield.BA__c == NULL ? 0 : yield.BA__c) *
                    (checkBIYield == NULL ? 0 : checkBIYield) *
                    (yield.module_test_yield__c == NULL ? 0 : yield.module_test_yield__c);
                           
            BIDiv = (checkBIYield == NULL ? 0 : checkBIYield) *
                    (yield.module_test_yield__c == NULL ? 0 : yield.module_test_yield__c);
                    
            moduleTestDiv = yield.module_test_yield__c == NULL ? 0 : yield.module_test_yield__c;                         
        }           
    
        if(waferProcessDiv > 0) {                  
          cost.calculated_total_wafer_processing_cost__c = ((cost.total_wafer_processing_cost__c + 
                                                             cost.total_raw_wafer_cost__c +
                                                             cost.total_mask_layer_list_cost__c) / 
                                                             waferProcessDiv).setScale(5);
        }           
                                               
        if(waferFinishingDiv > 0) {
            cost.calculated_total_wafer_finishing_cost__c = (cost.total_wafer_finishing_cost__c / waferFinishingDiv).setScale(5);
        }                                         
        
        if(waferTestDiv > 0) {
            cost.calculated_total_wafer_test_cost__c = (cost.total_wafer_test_cost__c / waferTestDiv).setScale(5);
            
            if(waferTestDiv2 > 0){
                cost.calculated_total_wafer_test_cost__c += (cost.total_wafer_dicing_cost__c / waferTestDiv2).setScale(5);    
            }
            
            if(waferTestDiv3 > 0){
                cost.calculated_total_wafer_test_cost__c = (cost.calculated_total_wafer_test_cost__c / waferTestDiv3).setScale(5);    
            }
        }                          
        
        if(substrateDiv > 0) {
            cost.calculated_total_substrate_cost__c = (cost.total_substrate_cost__c / substrateDiv).setScale(5);
            
        }                     
        
        if(BADiv > 0) {
            cost.calculated_total_module_assembly_cost__c = (cost.total_BA_cost__c / BADiv).setScale(5);
        }  
        
        if(BIDiv > 0) {
            cost.calculated_total_module_burn_in_cost__c = (cost.total_BI_cost__c / BIDiv).setScale(5);
       Decimal BIBCost = biBoardCostMap.containsKey(yield.Year__c+yield.quarter__c) ? biBoardCostMap.get(yield.Year__c+yield.quarter__c): 0 ;
           Decimal BIBVol =  biBoardVolMap.containsKey(yield.Year__c+yield.quarter__c)?biBoardVolMap.get(yield.Year__c+yield.quarter__c):0;
           Decimal BIBUnitCost =   BIBVol>0?(BIBCost/BIBVol):0;
           cost.calculated_total_module_burn_in_cost__c = ((cost.total_BI_cost__c / BIDiv)+BIBUnitCost).setScale(5);
            
        }                                 
        
        if(moduleTestDiv > 0) {
            cost.calculated_total_module_test_cost__c = (cost.total_module_test_cost__c / moduleTestDiv).setScale(5);
        }              
        
        cost.calculated_total_allocation_cost__c = (cost.total_allocation__c * (
                                                    cost.calculated_total_wafer_processing_cost__c + 
                                                    cost.calculated_total_wafer_finishing_cost__c + 
                                                    cost.calculated_total_wafer_test_cost__c + 
                                                    cost.calculated_total_substrate_cost__c + 
                                                    cost.calculated_total_module_assembly_cost__c + 
                                                    cost.calculated_total_module_burn_in_cost__c + 
                                                    cost.calculated_total_module_test_cost__c)).setScale(5);  
                                   
        cost.finish_goods_unit_cost__c = (cost.calculated_total_wafer_processing_cost__c + 
                                          cost.calculated_total_wafer_finishing_cost__c + 
                                          cost.calculated_total_wafer_test_cost__c + 
                                          cost.calculated_total_substrate_cost__c + 
                                          cost.calculated_total_module_assembly_cost__c + 
                                          cost.calculated_total_module_burn_in_cost__c + 
                                          cost.calculated_total_module_test_cost__c + 
                                          cost.calculated_total_allocation_cost__c).setScale(5); 
                                          
        return cost;                                                                  
    }    
    
    //Method will generate the quarter year cost calculations
    public static Map<String,CostHeader> generate(Map<String,GenerateYieldAndCost.YieldHeader> yieldHeaderMap, 
                                                  GenerateYieldAndCost.ConfigDetail config){                                                  
                                                  
        Map<String,CostHeader> costHeaderMap = new Map<String,CostHeader>();
        
        costHeaderMap = generateFEOLCost(config,yieldHeaderMap,costHeaderMap);
        
        if(BONDINGPRODUCTYPE.contains(config.productType)){
            costHeaderMap = generateBondingAndAllocationCost(config,yieldHeaderMap,costHeaderMap);    
        }
        
        if(WAFERTESTPRODUCTYPE.contains(config.productType)){
            costHeaderMap = generateWaferTestCost(config,yieldHeaderMap,costHeaderMap);  
        }
        
        if(MODULETESTPRODUCTYPE.contains(config.productType)){
            costHeaderMap = generateSubstrateAndBACost(config,yieldHeaderMap,costHeaderMap);  
            
            costHeaderMap = generateModuleBIandTestCost(config,yieldHeaderMap,costHeaderMap);    
        }        
        
        for(String key: costHeaderMap.keyset()){
            costHeaderMap.get(key).generateComplexCalc(key);
        }                
           
        return costHeaderMap;                                        
    }

    //Cost header wrapper class
    public class CostHeader {
        public String headerKey;
        public String year;
        public String quarter;
        public Decimal dicingK = 0;
        public Decimal dicingVar = 0;        
        public Decimal sortPckK = 0;        
        public Decimal sortPckVar = 0;                
        public Decimal groupBK = 0;                
        public Decimal groupBVar = 0; 
        public Decimal substrateVolMult = 0;
        public Decimal BAVolMult = 0;                       
        public Map<String,CostDetail> costDetailMap;
        private GenerateYieldAndCost.ConfigDetail config;     
        private GenerateYieldAndCost.YieldHeader yieldHeader;     
        private Configurator_Cost__c costRec;                   
        
        public CostHeader(GenerateYieldAndCost.ConfigDetail config, PCM_Cost__c cost,GenerateYieldAndCost.YieldHeader yieldHeader){
            this.headerKey = cost.year__c + cost.quarter__c;
            this.year = cost.year__c;
            this.quarter = cost.quarter__c;
            this.config = config;  
            this.yieldHeader = yieldHeader;         
            this.costDetailMap = new Map<String,CostDetail>();                                     
        }  
        
        public CostHeader(GenerateYieldAndCost.ConfigDetail config, String year,String quarter,GenerateYieldAndCost.YieldHeader yieldHeader){
            this.headerKey = year + quarter;
            this.year = year;
            this.quarter = quarter;
            this.config = config;  
            this.yieldHeader = yieldHeader;         
            this.costDetailMap = new Map<String,CostDetail>();                                     
        }               
        
        //Method will add populate wafer test constansts
        public void populateOtherCostConstant(Map<String,Decimal> constMap){                  
            if(constMap.containsKey('DICING_K')){
                this.dicingK = constMap.get('DICING_K');                
            } else if(constMap.containsKey('DICING_VAR')){
                this.dicingVar = constMap.get('DICING_VAR');
            } else if(constMap.containsKey('SORT_PCK_VAR')){
                this.sortPckVar = constMap.get('SORT_PCK_VAR');
            } else if(constMap.containsKey('SORT_PCK_K')){
                this.sortPckK = constMap.get('SORT_PCK_K');
            } else if(constMap.containsKey('GROUP_B_VAR')){
                this.groupBVar = constMap.get('GROUP_B_VAR');
            } else if(constMap.containsKey('GROUP_B_K')){
                this.groupBK = constMap.get('GROUP_B_K');
            } else if(constMap.containsKey('SUB FIN CCVOL')){
                this.substrateVolMult = constMap.get('SUB FIN CCVOL');
            } else if(constMap.containsKey('Module BA CCVOL')){
                this.BAVolMult = constMap.get('Module BA CCVOL');
            }            
        }
        
        //Method will add cost detail values associated to the header
        public void addCostDetail(PCM_Cost__c c){ 
            
            //allocation and mask layer may have multiple records per quarter
            //so concatenate record type and name for uniqueness
            String key;
            if(c.recordType.name == 'Mask Layer'){
                key = c.recordType.name + c.mask_layer__c;
            } else if(c.recordType.name == 'Allocation'){
                key = c.recordType.name + c.allocation_name__c;
            } else {
                key = c.recordType.name;
            }
            
            costDetailMap.put(key,new CostDetail(c));    
        }  
        
        //Method will add cost detail values associated to the header
        public void addCostDetail(String costType,Decimal cost){                 
            costDetailMap.put(costType,new CostDetail(costType,cost));                                                                                         
        } 
        
        //Method will add cost detail values associated to the header
        public void addCostDetail(CalculatedCostDetail c,List<String> removeTempCostList){                 
            this.costDetailMap.put(c.costType + c.costTypeDetail,new CostDetail(c));  
            for(String r: removeTempCostList){
                this.costDetailMap.remove(r);    
            }                                                                                            
        }               
        
        //Method will do complex cost calculations
        public void generateComplexCalc(String key){
            //Wafer Test cost
            Decimal waferCAPREQ = this.yieldHeader.capReqVal <> null ? this.yieldHeader.capReqVal : 0;
            Decimal waferTestHour = costDetailMap.containsKey('Wafer Test Hour') ? costDetailMap.get('Wafer Test Hour').cost : 0;
            Decimal waferTestGEN = costDetailMap.containsKey('Wafer Test GEN') ? costDetailMap.get('Wafer Test GEN').cost : 0;
            Decimal waferTestCost = (waferCAPREQ * waferTestHour) + waferTestGEN;                                   
            
            CalculatedCostDetail waferTestCalc = new CalculatedCostDetail('Wafer Test','Wafer Test Cost',waferTestCost);
            addCostDetail(waferTestCalc,new List<String>{'Wafer Test Hour','Wafer Test GEN'});                                                     
            
            //Dicing Cost
            Decimal chipX = config.chipX <> null ? config.chipX : 0;
            Decimal chipY = config.chipY <> null ? config.chipY : 0;
            
            Decimal dicingCost = (costDetailMap.containsKey('DSP Dicing') && chipX > 0 && chipY > 0) ?            
                                 (((this.dicingVar / (chipX + chipY)) + this.dicingK) / 60) * costDetailMap.get('DSP Dicing').cost :
                                 0;

            CalculatedCostDetail dicingCostCalc = new CalculatedCostDetail('Wafer Dicing','Dicing Cost',dicingCost);
            addCostDetail(dicingCostCalc,new List<String>{'DSP Dicing'});
            
            //Group B Cost                
            Decimal groupBCost = costDetailMap.containsKey('DSP GroupB') &&  costDetailMap.containsKey('DSP Factor') ?            
                                 costDetailMap.get('DSP GroupB').cost * ((costDetailMap.get('DSP Factor').PFactor * (this.groupBVar * (chipX * chipY) + this.groupBK)) / 60) :
                                 0;

            CalculatedCostDetail groupBCostCalc = new CalculatedCostDetail('Wafer Dicing','GroupB Cost',groupBCost);  
            addCostDetail(groupBCostCalc,new List<String>{'DSP GroupB','DSP Factor'});
            
            //Sort Cost
            Decimal GCPW = this.yieldHeader.gcpw <> null ? this.yieldHeader.gcpw : 0;
            Decimal BEOLPREYield = this.yieldHeader.BEOLPREYield <> null ? this.yieldHeader.BEOLPREYield : 0;
            Decimal FEOLYield = this.yieldHeader.FEOLYield <> null ? this.yieldHeader.FEOLYield : 0;  
            Decimal sortCost = (costDetailMap.containsKey('DSP Picking') && BEOLPREYield > 0 && FEOLYield > 0)?            
                               (((this.sortPckVar * (GCPW /(BEOLPREYield * FEOLYield))) + this.sortPckK) / 60) * costDetailMap.get('DSP Picking').cost :
                               0;                                         

            CalculatedCostDetail sortCostCalc = new CalculatedCostDetail('Wafer Dicing','Sort Cost',sortCost);  
            addCostDetail(sortCostCalc,new List<String>{'DSP Picking'});                                   
            
            //Substrate Cost
            Decimal substrateCost = costDetailMap.containsKey('SUB FIN CC') ?            
                                    costDetailMap.get('SUB FIN CC').cost * this.substrateVolMult :
                                    0;

            CalculatedCostDetail substrateCostCalc = new CalculatedCostDetail('Substrate Cost','Substrate Cost',substrateCost);  
            addCostDetail(substrateCostCalc,new List<String>{'SUB FIN CC'});
            
            //Module BA Cost
         
            Decimal BACost=0;
            if(costDetailMap.containsKey('Module BA ASM') ){
                Decimal CAPCost = mapEncapCap.containsKey('Module BA DCAPS ASM-'+key)?  mapEncapCap.get('Module BA DCAPS ASM-'+key):0;
                Decimal EncapCost = mapEncapCap.containsKey('Module BA LID ASM-'+key)? mapEncapCap.get('Module BA LID ASM-'+key):0;
                
                BACost =(costDetailMap.get('Module BA ASM').cost +EncapCost+(CAPCost*CapQty)) * this.BAVolMult ;          
            }
        
            
            CalculatedCostDetail BACostCalc = new CalculatedCostDetail('Module BA Cost','Module BA Cost',BACost);  
            addCostDetail(BACostCalc,new List<String>{'Module BA ASM'});
            
            
            //Module Test
            Decimal ModuleCAPREQ = this.yieldHeader.modTstCapReq <> null ? this.yieldHeader.modTstCapReq : 0;
            Decimal moduleTestCost = costDetailMap.containsKey('Module Test Hour') &&  costDetailMap.containsKey('Module Test SBT') ?            
                                     (costDetailMap.get('Module Test Hour').cost * ModuleCAPREQ) + costDetailMap.get('Module Test SBT').cost :
                                     0;
            CalculatedCostDetail moduleTestCostCalc = new CalculatedCostDetail('Module Test Cost','Module Test Cost',moduleTestCost);  
            addCostDetail(moduleTestCostCalc,new List<String>{'Module Test Hour','Module Test SBT'});
            
            
            //Module BI Cost
            Decimal BICAPREQ = this.yieldHeader.biCapReq <> null ? this.yieldHeader.biCapReq : 0;
            Decimal BICost = costDetailMap.containsKey('Module BI Hour') ?            
                             costDetailMap.get('Module BI Hour').cost * BICAPREQ :
                             0;
            
            
            CalculatedCostDetail BICostCalc = new CalculatedCostDetail('Module BI Cost','Module BI Cost',BICost);  
            addCostDetail(BICostCalc,new List<String>{'Module BI Hour'});
            
        }
        
        //Method will generate the PCM cost record
        public Configurator_Cost__c generateRecord(){
            this.costRec = new Configurator_Cost__c(
                quote_proposal__c = this.config.configID,
                year__c = this.year,
                quarter__c = this.quarter
            );    
            
            return this.costRec;
        } 
        
        //Method will generate the PCM cost detail records under the header
        public List<Configurator_Cost_Detail__c> generateCostDetails(){
            List<Configurator_Cost_Detail__c> details = new List<Configurator_Cost_Detail__c>();
            
            for(String key: this.costDetailMap.keyset()){
                details.add(this.costDetailMap.get(key).generateRecord(this.costRec.id));           
            }                        
                               
            return details;
        }                                                     
    }    
   
    //Cost detail wrapper class
    public class CostDetail {
        public String costType;
        public String costTypeDetail;
        public Decimal cost;
        public Decimal allocation;
        public Decimal PFactor;
        public ID PCMCostID;
        
        public CostDetail(PCM_Cost__c c){
            this.costType = c.recordType.name;
            this.cost = c.cost__c;
            this.allocation = c.Allocation__c;
            this.PFactor = c.PFactor__c;
            this.PCMCostID = c.id;
        }
        
        public CostDetail(String costType,Decimal cost){
            this.costType = costType;
            this.cost = cost;            
        }
        
        public CostDetail(CalculatedCostDetail c){
            this.costType = c.costType;
            this.cost = c.cost;            
            this.costTypeDetail= c.costTypeDetail;          
        }                           
        
        //Method will generate the PCM cost detail record
        public Configurator_Cost_Detail__c generateRecord(ID costHeaderID){
            Configurator_Cost_Detail__c c = new Configurator_Cost_Detail__c(
                configurator_cost__c =costHeaderID,
                cost__c = this.cost,
                allocation__c = this.allocation,
                cost_type__c = this.costType,
                pcm_cost__c = this.PCMCostID,
                test_cost_type__c = this.costTypeDetail
            );
            
            return c;
        }
    }
    
    //Calculated Cost Wrapper class
    public class CalculatedCostDetail {
        public String costType;
        public String costTypeDetail;
        public Decimal cost;
    
        public CalculatedCostDetail(String costType,String costTypeDetail,Decimal cost){
            this.costType = costType;
            this.costTypeDetail = costTypeDetail;
            this.cost = cost;
        }    
    }    
}