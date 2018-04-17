public with sharing class PSP_searchExtension{
   
    public Device__c deviceRec{get;set;}
    public Boolean isValidProfile{get;set;}
    public string accId{get;set;}
    public string accName{get;set;}
    public string oppId{get;set;}
    public string oppName{get;set;}
    public integer yearofbegin{get;set;}
    public string fabSelected{get;set;}
    public string processGeometrySelected{get;set;}
    public boolean displayInPSP{get;set;}
    
    public List<SelectOption> lstSalesTerritory{get;set;}
    public string salesTerrSelected{get;set;}
    public List<Integer> lstYears{get;set;}
    
    public integer yearofStart{get;set;}
    public integer yearofEnd{get;set;}
    public List<Integer> lstYearsDisplay{get;set;}
    
    public List<Device__c> lstDevices{get;set;}
    
    public List<DevicePSPData__c> lstTotalPSPWaferStart{get;set;}
    public List<DevicePSPData__c> lstTotalPSPWaferOut{get;set;}
    public List<DevicePSPData__c> lstTotalPSPWaferForecast{get;set;}
    public List<QuarterlyTotal> lstWaferStartQuarterTotal{get;set;}
    public List<QuarterlyTotal> lstWaferOutQuarterTotal{get;set;} 
    
    public List<DevicePSPData__c> lstTotalWaferForecast{get;set;}
    public List<QuarterlyTotal> lstWaferForecastQuarterTotal{get;set;}
    public List<QuarterlyTotal> lstWaferGMQuarterTotal{get;set;}
    public List<QuarterlyTotal> lstWGMQuarterTotal{get;set;}
    public List<QuarterlyTotal> lstRevenueQuarterTotal{get;set;}
    public List<QuarterlyTotal> lstCostQuarterTotal{get;set;}
    public List<QuarterlyTotal> lstWeightedGM{get;set;}
    public List<QuarterlyTotal> lstWeightedAverage{get;set;}
    public List<QuarterlyTotal> lstvolume{get;set;}
    public List<QuarterlyTotal> lstQtrlyWaferCostTotal{get;set;}
    public List<QuarterlyTotal> lstQtrlyTurnkeyRevTotal{get;set;}
    public List<QuarterlyTotal> lstQtrlyTurnkeyCostTotal{get;set;}
    
    //DBiswal 05162016
    public List<DevicePSPData__c> lstprototypeWaferOuts {get;set;}
    public List<DevicePSPData__c> lstproductionWaferOuts {get;set;}
    public List<calculateWaferOuts> lstOppWaferOuts {get;set;}
    public List<calculateWaferOuts> lstprototypeWaferOutsTTL {get;set;}
    public List<calculateWaferOuts> lstproductionWaferOutsTTL {get;set;}
  
    String queryString;
    //pagination variables
    private integer counter=0;  //keeps track of the offset
    private integer list_size= integer.valueOf(System.Label.PSP_PageSize); //sets the page size or number of rows
    public integer total_size; //used to show user the total size of the list
    
    //wrapper class for Quarterly totals
    public class QuarterlyTotal{
        public decimal quarter1{get;set;}
        public decimal quarter2{get;set;}
        public decimal quarter3{get;set;}
        public decimal quarter4{get;set;}
        public decimal yearNo{get;set;}
    }
    
    //Constructor for Standard Controller
    public PSP_searchExtension(ApexPages.StandardController controller){
        
        deviceRec = new Device__c();
        this.deviceRec = (Device__c)controller.getRecord();
        //list initializations
        lstTotalPSPWaferStart = new List<DevicePSPData__c>();
        lstTotalPSPWaferOut = new List<DevicePSPData__c>();
        lstTotalPSPWaferForecast = new List<DevicePSPData__c>();
        lstWaferStartQuarterTotal = new List<QuarterlyTotal>();
        lstWaferOutQuarterTotal = new List<QuarterlyTotal>();
        lstDevices = new List<Device__c>();
        lstSalesTerritory = new List<SelectOption>();
        lstYears = new List<Integer>();
        
        isValidProfile = false;
        isValidProfileForProvisioning();
        
        lstTotalWaferForecast  = new List<DevicePSPData__c>();
        lstWaferForecastQuarterTotal = new List<QuarterlyTotal>();
        lstWaferGMQuarterTotal = new List<QuarterlyTotal>();
        lstWGMQuarterTotal     = new List<QuarterlyTotal>();
        lstRevenueQuarterTotal = new List<QuarterlyTotal>();
        lstCostQuarterTotal    = new List<QuarterlyTotal>();
        lstWeightedGM = new List<QuarterlyTotal>();
        lstWeightedAverage = new List<QuarterlyTotal>();
        lstvolume=new List<QuarterlyTotal>();
        lstQtrlyWaferCostTotal = new List<QuarterlyTotal>();
        lstQtrlyTurnkeyRevTotal = new List<QuarterlyTotal>();
        lstQtrlyTurnkeyCostTotal = new List<QuarterlyTotal>();
        
        //DBiswal
        lstprototypeWaferOuts = new List<DevicePSPData__c>();
        lstproductionWaferOuts = new List<DevicePSPData__c>();
        lstOppWaferOuts  = new List<calculateWaferOuts>();
        lstprototypeWaferOutsTTL = new List<calculateWaferOuts>();
        lstproductionWaferOutsTTL = new List<calculateWaferOuts>();
        
        //variables initialization
        oppId = ApexPages.currentPage().getParameters().get('oppId');
        accId = ApexPages.currentPage().getParameters().get('accId');
        yearofbegin = System.today().Year();
        yearofStart = System.today().Year();
        yearofEnd   = System.today().Year()+2;
        
        lstYearsDisplay = new List<Integer>();
        for(integer i= yearofStart ; i<= yearofEnd ;i++){
            lstYearsDisplay.add(i);
        }
        
        displayInPSP = false;
        processGeometrySelected = 'None';
        fabSelected = 'None';
        
        salesTerrSelected = 'None';
        queryString = '';
        
        queryString = 'select id,Product_TO_Date__c,Forecasted_Production_Start_Date__c,Account__c,Opportunity2__r.name,Opportunity2__c ,Account__r.name from Device__c where name!=NULL ';        
        if(oppId != NULL){
            queryString = queryString + ' and Opportunity2__c =\''+ oppId +'\'';
            deviceRec.Opportunity2__c = oppId;
        }
        if(accId !=NULL){
            queryString = queryString + ' and Account__c =\''+ accId +'\'';
            deviceRec.Account__c = accId;
        }
        queryString = queryString + ' and No_of_Mask_Layers__c != NULL and Proto_DPML__c != NULL ';
        queryString = queryString + ' and Product_TO_Date__c >= ' + yearofbegin+'-01-01 and Product_TO_Date__c <= ' + yearofbegin + '-12-31 ';
        queryString = queryString + ' order by name limit 20000 ';
        
        lstDevices = Database.query(queryString);
        if(!lstDevices.isEmpty()){
            if(accId != NULL) accName = lstDevices[0].Account__r.name;
            if(oppId !=NULL)  oppName = lstDevices[0].Opportunity2__r.name;
        }
        total_size = lstDevices.size(); //set the total size in the constructor
        Search();
        AggregateResult[] lstAggrReslt = [select min(Year__c),max(Year__c) from DevicePSPData__c where Device__c in :lstDevices];
        if(!lstAggrReslt.isEmpty()){
            for(integer i= integer.valueOf(lstAggrReslt[0].get('expr0'));i<=integer.valueOf(lstAggrReslt[0].get('expr1'));i++){
                lstYears.add(i);
            }
        }
        
        lstYears.sort();
    }
    
    //get Picklist values of year of Start
    public List<SelectOption> getYears() {
        List<SelectOption> lstOptions = new List<SelectOption>();
        for(integer i=2013;i<=2020;i++){
            lstOptions.add(new SelectOption(string.valueOf(i),string.valueOf(i)));
        }
        return lstOptions;
    }
    
    //get Picklist values of year of End
    public List<SelectOption> getYearsEnd() {
        List<SelectOption> lstOptions = new List<SelectOption>();
        for(integer i=2013;i<=2020;i++){
            lstOptions.add(new SelectOption(string.valueOf(i),string.valueOf(i)));
        }
        return lstOptions;
    }
    
    //get Picklist values of Fabs
    public List<SelectOption> getFabs() {
        List<SelectOption> lstOptions = new List<SelectOption>();
        for(FAB__c fab:[select id,name from Fab__c order by name]){
            lstOptions.add(new SelectOption(fab.name,fab.name));        
        }
        lstOptions.add(0,new SelectOption('None','--None--'));
        return lstOptions;
    }
    
    //get Picklist values of Process Geometry
    public List<SelectOption> getProcessGeometries(){
        List<SelectOption> lstOptions = new List<SelectOption>();
        List<String> lstPickvals=new List<String>();
        
        Schema.SObjectType targetType = Schema.getGlobalDescribe().get('Opportunity');
        Sobject Object_name = targetType.newSObject();
        Schema.sObjectType sobject_type = Object_name.getSObjectType(); //grab the sobject that was passed
        Schema.DescribeSObjectResult sobject_describe = sobject_type.getDescribe(); //describe the sobject
        Map<String, Schema.SObjectField> field_map = sobject_describe.fields.getMap(); //get a map of fields for the passed sobject
        List<Schema.PicklistEntry> pick_list_values = field_map.get('Process_Geometry__c').getDescribe().getPickListValues(); //grab the list of picklist values for the passed field on the sobject
        for (Schema.PicklistEntry a : pick_list_values) { 
            lstOptions.add(new SelectOption(a.getValue(),a.getValue()));
        }
        lstOptions.sort();
        lstOptions.add(0,new SelectOption('None','--None--'));
        return lstOptions;
    }
    
    public List<SelectOption> getSalesTerritories(){
        List<SelectOption> lstOptions = new List<SelectOption>();
        List<String> lstPickvals=new List<String>();
        
        Schema.SObjectType targetType = Schema.getGlobalDescribe().get('Account');
        Sobject Object_name = targetType.newSObject();
        Schema.sObjectType sobject_type = Object_name.getSObjectType(); //grab the sobject that was passed
        Schema.DescribeSObjectResult sobject_describe = sobject_type.getDescribe(); //describe the sobject
        Map<String, Schema.SObjectField> field_map = sobject_describe.fields.getMap(); //get a map of fields for the passed sobject
        List<Schema.PicklistEntry> pick_list_values = field_map.get('Sales_Territory__c').getDescribe().getPickListValues(); //grab the list of picklist values for the passed field on the sobject
        for (Schema.PicklistEntry a : pick_list_values) { 
                lstOptions.add(new SelectOption(a.getValue(),a.getValue()));
        }
        lstOptions.sort();
        lstOptions.add(0,new SelectOption('None','--None--'));
        return lstOptions;
    }
    //Seach function for filtering the records as per defined by the user
    public pageReference Search(){
        lstTotalPSPWaferStart.clear();
        lstWaferStartQuarterTotal.clear();
        lstTotalPSPWaferOut.clear();
        lstWaferOutQuarterTotal.clear();
        lstTotalPSPWaferForecast.clear();
        lstWaferForecastQuarterTotal.clear();
        lstWaferGMQuarterTotal.clear();
        lstWGMQuarterTotal.clear();
        lstRevenueQuarterTotal.clear();
        lstCostQuarterTotal.clear();
        lstWeightedGM.clear();
        lstWeightedAverage.clear();
        lstvolume.clear();
        lstQtrlyWaferCostTotal.clear();
        lstQtrlyTurnkeyRevTotal.clear();
        lstQtrlyTurnkeyCostTotal.clear();
        
        lstprototypeWaferOuts.clear();
        lstproductionWaferOuts.clear();
        lstprototypeWaferOutsTTL.clear();
        lstproductionWaferOutsTTL.clear();
        
        try{
            counter=0;  //keeps track of the offset
            list_size = Integer.valueOf(System.Label.PSP_PageSize); //sets the page size or number of rows
            lstDevices.clear();
            queryString = '';
               
            if(yearofEnd < yearofbegin){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,'"Display: Ending Year" cannot be less than "Year of Start"'));
            }else if(yearofStart > yearofEnd){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,'"Display: Ending Year" cannot be less than "Display: Starting Year"'));            
            }else{                                
                queryString = ' select id,Product_TO_Date__c,Proto_Wafer_Fab_Shipped_Date__c,Forecasted_Production_Start_Date__c,'+
                              '(select id,Year__c from DevicePSPs_Data__r where (Phase__c = \'Prototype Wafer Out\' OR Phase__c = \'Production Wafer Out\') order by Year__c) '+
                              ' from Device__c where name!=NULL ';
                
                if(accId != NULL && accName != ''){
                    queryString = queryString + ' and Account__c =\''+accId+'\'';
                }
                if(oppId != NULL && oppName != ''){
                    queryString = queryString + ' and Opportunity2__c =\''+oppId+'\'';
                }
                if(fabSelected != 'None'){
                    queryString = queryString + ' and FAB__c =\''+fabSelected +'\'';
                }            
                if(processGeometrySelected != 'None'){
                    queryString = queryString + ' and Geometry__c =\''+processGeometrySelected+'\'';
                }            
                if(salesTerrSelected != 'None' && salesTerrSelected != NULL && salesTerrSelected != ''){
                    queryString = queryString + ' and Account__r.Sales_Territory__c =\''+salesTerrSelected +'\'';
                }          
                if(displayInPSP == true){
                    queryString = queryString + ' and Display_in_PSP__c =true ';
                }
                
                //check for DPML and Mask Layer field for Wafer OUT
                queryString = queryString + ' and No_of_Mask_Layers__c != NULL and Proto_DPML__c != NULL and Production_DPML__c !=NULL ';
                //queryString = queryString + ' and Product_TO_Date__c >= ' + yearofbegin+'-01-01 and Product_TO_Date__c <= ' + yearofbegin + '-12-31';
                queryString = queryString + ' and Product_TO_Date__c >= ' + yearofStart +'-01-01 and Product_TO_Date__c <= ' + yearofEnd + '-12-31';
                queryString = queryString + ' order by name limit 20000';
                
                lstDevices = Database.query(queryString);
                List<Device__c> tempDevices = new List<Device__c>();
                tempDevices.clear();
                for(Device__c device:lstDevices){
                    if(device.DevicePSPs_Data__r.size()>0){
                        tempDevices.add(device);
                    }
                }
                lstDevices.clear();
                lstDevices.addAll(tempDevices);
                
                if(lstDevices.isEmpty()){
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,'No Results found. Please change the filter criteria.'));
                }else{
                    total_size = lstDevices.size();
                    
                    //++Calculation for Years to display
                    lstYears.clear();
                    decimal maxYear = 2000;
                    decimal minYear = 2100;
                    for(Device__c deviceForDate : lstDevices){
                        //logic for fetching the Min range of year to display
                        if(deviceForDate.Product_TO_Date__c.Year() < minYear){
                            minYear = deviceForDate.Product_TO_Date__c.Year();
                        }                
                        //logic for fetching the Max range of year to display
                        for(DevicePSPData__c devPSPrec:deviceForDate.DevicePSPs_Data__r){
                            if(devPSPrec.Year__c > maxYear){
                                maxYear = devPSPrec.Year__c;
                            }
                        }
                    }
                    for(Integer i=Integer.valueOf(minYear);i<=Integer.valueOf(maxYear);i++){
                        lstYears.add(i);
                    }
                    lstYears.sort();
                    //--Calculation for Years to display
                    
                    integer endYeartemp = 2000;
                    integer startYeartemp = 2100;
                    if(Integer.valueOf(maxYear)<= yearofEnd){
                        endYeartemp = Integer.valueOf(maxYear);
                    }else{
                        endYeartemp = yearofEnd;
                    }
                    
                    if(Integer.valueOf(minYear)>= yearofStart){
                        startYeartemp = Integer.valueOf(minYear);
                    }else{
                        startYeartemp = yearofStart;
                    }
                    
                    lstYearsDisplay.clear();
                    for(integer i= startYeartemp ; i<= endYeartemp ; i++){
                        lstYearsDisplay.add(i);
                    }
                }
            }
            return null;
        }catch (QueryException e) {
            ApexPages.addMessages(e);   
            return null;
        }
    }
    
    //++pagination for results
    public Device__c[] getSearchResult() {
      try {      
            if(lstDevices.isEmpty()){
                lstTotalPSPWaferStart.clear();
                lstWaferStartQuarterTotal.clear();
                lstTotalPSPWaferOut.clear();
                lstWaferOutQuarterTotal.clear();
                lstTotalPSPWaferForecast.clear();
                lstWaferForecastQuarterTotal.clear();
                lstWaferGMQuarterTotal.clear();
                lstWGMQuarterTotal.clear();
                lstRevenueQuarterTotal.clear();
                lstCostQuarterTotal.clear();
                lstWeightedGM.clear();
                lstWeightedAverage.clear();
                lstvolume.clear();
                lstQtrlyWaferCostTotal.clear();
                lstQtrlyTurnkeyRevTotal.clear();
                lstQtrlyTurnkeyCostTotal.clear();
                
                lstprototypeWaferOuts.clear();
                lstproductionWaferOuts.clear();
                lstprototypeWaferOutsTTL.clear();
                lstproductionWaferOutsTTL.clear();
                
            }else{
                lstDevices.clear();
                queryString = '';
                
                queryString = 'select id,name,Fab__c,Account__c,Account__r.name,Account__r.Short_Name__c, Opportunity2__r.name,'+
                            ' Geometry__c,Obstacles__c,Actions__c,Forecasted_Production_Start_Date__c,Opportunity2__c,'+           
                            ' Product_TO_Date__c,Sample_Delivery_Date__c,Forecasted_Proto_Date__c, Forecasted_RTP_Date__c,Proto_Wafer_Fab_Shipped_Date__c,'+
                            
                            '(select Month_1__c,Month_2__c,Month_3__c,Month_4__c,Month_5__c,Month_6__c,Month_7__c,Month_8__c,'+
                            ' Month_9__c,Month_10__c,Month_11__c,Month_12__c,Phase_Number__c,Phase__c,Year__c,Device__c,'+
                            ' WaferStart_Quarter1__c,WaferStart_Quarter2__c,WaferStart_Quarter3__c,WaferStart_Quarter4__c, '+
                            ' Quarter1__c,Quarter2__c,Quarter3__c,Quarter4__c '+
                            ' from DevicePSPs_Data__r where Phase__c = \'Production Wafer Out\' and Year__c in '+ lstYearsDisplay +
                            ' and Year__c in '+ lstYearsDisplay +
                            ' order by Year__c) '+
                            
                            ' from Device__c where name!=NULL ';
                
                if(accId != NULL && accName != ''){
                    queryString = queryString + ' and Account__c =\''+accId+'\'';
                }
                if(oppId != NULL && oppName != ''){
                    queryString = queryString + ' and Opportunity2__c =\''+oppId+'\'';
                }
                if(fabSelected != 'None'){
                    queryString = queryString + ' and FAB__c =\''+fabSelected +'\'';
                }            
                if(processGeometrySelected != 'None'){
                    queryString = queryString + ' and Geometry__c =\''+processGeometrySelected+'\'';
                }            
                if(salesTerrSelected != 'None' && salesTerrSelected != NULL && salesTerrSelected != ''){
                    queryString = queryString + ' and Account__r.Sales_Territory__c =\''+salesTerrSelected +'\'';
                }            
                if(displayInPSP == true){
                    queryString = queryString + ' and Display_in_PSP__c =true ';
                }
                            
                //check for DPML and Mask Layer field for Wafer OUT
                queryString = queryString + ' and No_of_Mask_Layers__c != NULL and Proto_DPML__c != NULL and Production_DPML__c !=NULL ';
                //queryString = queryString + ' and Product_TO_Date__c >= ' + yearofbegin+'-01-01 and Product_TO_Date__c <= ' + yearofbegin + '-12-31 ';
                queryString = queryString + ' and Product_TO_Date__c >= ' + yearofStart +'-01-01 and Product_TO_Date__c <= ' + yearofEnd + '-12-31';
                queryString = queryString + ' order by name limit '+ list_size + ' offset '+counter;
    
                lstDevices = Database.query(queryString);
                
                List<Device__c> lstDevices1 = new List<Device__c>();
                lstDevices1 = Database.query(queryString.replace('where Phase__c = \'Production Wafer Out\'', 'where (Phase__c = \'Prototype Wafer Out\' OR Phase__c = \'Production Wafer Out\')'));
                
                List<Device__c> tempDevices = new List<Device__c>();
                tempDevices.clear();
                for(Device__c device: lstDevices){
                    if(device.DevicePSPs_Data__r.size()>0){
                        tempDevices.add(device);
                    }                    
                }
                lstDevices.clear();
                lstDevices.addAll(tempDevices);  
                
                List<DevicePSPData__c> lstCompletePSPData = new List<DevicePSPData__c>();
                List<DevicePSPData__c> lstCompleteForecastData = new List<DevicePSPData__c>();
                List<DevicePSPData__c> lstCompletePSPWaferOutData = new List<DevicePSPData__c>();
                List<DevicePSPData__c> lstCompletePSPWaferForecastData = new List<DevicePSPData__c>();
                List<DevicePSPData__c> lstCompletePSPWaferGMData = new List<DevicePSPData__c>();
                lstprototypeWaferOuts = new List<DevicePSPData__c>();
                lstproductionWaferOuts = new List<DevicePSPData__c>();
                lstprototypeWaferOutsTTL = new List<calculateWaferOuts>();
                lstproductionWaferOutsTTL = new List<calculateWaferOuts>();
                
                for(Device__c deviceForDate : lstDevices1){
                    for(DevicePSPData__c devPSP: deviceForDate.DevicePSPs_Data__r){
                         if(devPSP.Phase__c == 'Prototype Wafer Out'){
                            lstprototypeWaferOuts.add(devPSP);
                        }else if(devPSP.Phase__c == 'Production Wafer Out'){
                            lstproductionWaferOuts.add(devPSP);
                        }
                    }
                }
                
                for(Integer i : lstYearsDisplay){
                    calculateWaferOuts prototypeWaferOutperYear = new calculateWaferOuts();
                    calculateWaferOuts productionWaferOutperYear = new calculateWaferOuts();
                    
                    for(DevicePSPData__c devPSP: lstprototypeWaferOuts){
                        if(devPSP.Year__c == Decimal.valueOf(i)){
                            prototypeWaferOutperYear.month1 = (prototypeWaferOutperYear.month1!=null ? prototypeWaferOutperYear.month1 : 0) + devPSP.Month_1__c;
                            prototypeWaferOutperYear.month2 = (prototypeWaferOutperYear.month2!=null ? prototypeWaferOutperYear.month2 : 0) + devPSP.Month_2__c;
                            prototypeWaferOutperYear.month3 = (prototypeWaferOutperYear.month3!=null ? prototypeWaferOutperYear.month3 : 0) + devPSP.Month_3__c;
                            prototypeWaferOutperYear.month4 = (prototypeWaferOutperYear.month4!=null ? prototypeWaferOutperYear.month4 : 0) + devPSP.Month_4__c;
                            prototypeWaferOutperYear.month5 = (prototypeWaferOutperYear.month5!=null ? prototypeWaferOutperYear.month5 : 0) + devPSP.Month_5__c;
                            prototypeWaferOutperYear.month6 = (prototypeWaferOutperYear.month6!=null ? prototypeWaferOutperYear.month6 : 0) + devPSP.Month_6__c;
                            prototypeWaferOutperYear.month7 = (prototypeWaferOutperYear.month7!=null ? prototypeWaferOutperYear.month7 : 0) + devPSP.Month_7__c;
                            prototypeWaferOutperYear.month8 = (prototypeWaferOutperYear.month8!=null ? prototypeWaferOutperYear.month8 : 0) + devPSP.Month_8__c;
                            prototypeWaferOutperYear.month9 = (prototypeWaferOutperYear.month9!=null ? prototypeWaferOutperYear.month9 : 0) + devPSP.Month_9__c;
                            prototypeWaferOutperYear.month10 = (prototypeWaferOutperYear.month10!=null ? prototypeWaferOutperYear.month10 : 0) + devPSP.Month_10__c;
                            prototypeWaferOutperYear.month11 = (prototypeWaferOutperYear.month11!=null ? prototypeWaferOutperYear.month11 : 0) + devPSP.Month_11__c;
                            prototypeWaferOutperYear.month12 = (prototypeWaferOutperYear.month12!=null ? prototypeWaferOutperYear.month12 : 0) + devPSP.Month_12__c;
                            prototypeWaferOutperYear.quarter1 = (prototypeWaferOutperYear.quarter1!=null ? prototypeWaferOutperYear.quarter1 : 0) + devPSP.WaferStart_Quarter1__c;
                            prototypeWaferOutperYear.quarter2 = (prototypeWaferOutperYear.quarter2!=null ? prototypeWaferOutperYear.quarter2 : 0) + devPSP.WaferStart_Quarter2__c;
                            prototypeWaferOutperYear.quarter3 = (prototypeWaferOutperYear.quarter3!=null ? prototypeWaferOutperYear.quarter3 : 0) + devPSP.WaferStart_Quarter3__c;
                            prototypeWaferOutperYear.quarter4 = (prototypeWaferOutperYear.quarter4!=null ? prototypeWaferOutperYear.quarter4 : 0) + devPSP.WaferStart_Quarter4__c;
                            prototypeWaferOutperYear.yearNo = devPSP.Year__c;
                        }                        
                    }
                    lstprototypeWaferOutsTTL.add(prototypeWaferOutperYear);
                    
                    for(DevicePSPData__c devPSP: lstproductionWaferOuts){
                        if(devPSP.Year__c == Decimal.valueOf(i)){
                            productionWaferOutperYear.month1 = (productionWaferOutperYear.month1!=null ? productionWaferOutperYear.month1 : 0) + devPSP.Month_1__c;
                            productionWaferOutperYear.month2 = (productionWaferOutperYear.month2!=null ? productionWaferOutperYear.month2 : 0) + devPSP.Month_2__c;
                            productionWaferOutperYear.month3 = (productionWaferOutperYear.month3!=null ? productionWaferOutperYear.month3 : 0) + devPSP.Month_3__c;
                            productionWaferOutperYear.month4 = (productionWaferOutperYear.month4!=null ? productionWaferOutperYear.month4 : 0) + devPSP.Month_4__c;
                            productionWaferOutperYear.month5 = (productionWaferOutperYear.month5!=null ? productionWaferOutperYear.month5 : 0) + devPSP.Month_5__c;
                            productionWaferOutperYear.month6 = (productionWaferOutperYear.month6!=null ? productionWaferOutperYear.month6 : 0) + devPSP.Month_6__c;
                            productionWaferOutperYear.month7 = (productionWaferOutperYear.month7!=null ? productionWaferOutperYear.month7 : 0) + devPSP.Month_7__c;
                            productionWaferOutperYear.month8 = (productionWaferOutperYear.month8!=null ? productionWaferOutperYear.month8 : 0) + devPSP.Month_8__c;
                            productionWaferOutperYear.month9 = (productionWaferOutperYear.month9!=null ? productionWaferOutperYear.month9 : 0) + devPSP.Month_9__c;
                            productionWaferOutperYear.month10 = (productionWaferOutperYear.month10!=null ? productionWaferOutperYear.month10 : 0) + devPSP.Month_10__c;
                            productionWaferOutperYear.month11 = (productionWaferOutperYear.month11!=null ? productionWaferOutperYear.month11 : 0) + devPSP.Month_11__c;
                            productionWaferOutperYear.month12 = (productionWaferOutperYear.month12!=null ? productionWaferOutperYear.month12 : 0) + devPSP.Month_12__c;
                            productionWaferOutperYear.quarter1 = (productionWaferOutperYear.quarter1!=null ? productionWaferOutperYear.quarter1 : 0) + devPSP.WaferStart_Quarter1__c;
                            productionWaferOutperYear.quarter2 = (productionWaferOutperYear.quarter2!=null ? productionWaferOutperYear.quarter2 : 0) + devPSP.WaferStart_Quarter2__c;
                            productionWaferOutperYear.quarter3 = (productionWaferOutperYear.quarter3!=null ? productionWaferOutperYear.quarter3 : 0) + devPSP.WaferStart_Quarter3__c;
                            productionWaferOutperYear.quarter4 = (productionWaferOutperYear.quarter4!=null ? productionWaferOutperYear.quarter4 : 0) + devPSP.WaferStart_Quarter4__c;
                            productionWaferOutperYear.yearNo = devPSP.Year__c;
                        }                        
                    }
                    lstproductionWaferOutsTTL.add(productionWaferOutperYear);
                }
                
                map<Decimal,DevicePSPData__c> mapPSPStartData = new map<Decimal,DevicePSPData__c>();
                map<Decimal,DevicePSPData__c> mapPSPOutData = new map<Decimal,DevicePSPData__c>();
                map<Decimal,DevicePSPData__c> mapPSPForecastData = new map<Decimal,DevicePSPData__c>();
                map<Decimal,QuarterlyTotal> mapWaferStart = new map<Decimal,QuarterlyTotal>();
                map<Decimal,QuarterlyTotal> mapWaferOut   = new map<Decimal,QuarterlyTotal>();
                map<Decimal,QuarterlyTotal> mapWaferForecast = new map<Decimal,QuarterlyTotal>();
                map<Decimal,QuarterlyTotal> mapWaferGM       = new map<Decimal,QuarterlyTotal>();
                map<Decimal,QuarterlyTotal> mapWaferRevenue  = new map<Decimal,QuarterlyTotal>();
                map<Decimal,QuarterlyTotal> mapWaferCost     = new map<Decimal,QuarterlyTotal>();
                map<Decimal,QuarterlyTotal> mapWeightedGM     = new map<Decimal,QuarterlyTotal>();
                
                for(Integer year:lstYears){
                    DevicePSPData__c devPSP = new DevicePSPData__c();
                    devPSP.Year__c = year;
                    mapPSPStartData.put(year,devPSP);
                    
                    DevicePSPData__c devPSP2 = new DevicePSPData__c();
                    devPSP2.Year__c = year;
                    mapPSPOutData.put(year,devPSP2);
                    
                    DevicePSPData__c devPSP3 = new DevicePSPData__c();
                    devPSP3.Year__c = year;
                    mapPSPForecastData.put(year,devPSP3);
                    
                    QuarterlyTotal quarterlyStartWrapperRec = new QuarterlyTotal();
                    quarterlyStartWrapperRec.YearNo = year;
                    
                    QuarterlyTotal quarterlyOutWrapperRec = new QuarterlyTotal();
                    quarterlyOutWrapperRec.YearNo = year;
                    
                    //For Calculation of Opportunity Forecast
                    QuarterlyTotal quarterlyForecastWrapperRec = new QuarterlyTotal();
                    quarterlyForecastWrapperRec.YearNo = year;
                    
                    //For Calculation of Weighted GM($)
                    QuarterlyTotal quarterlyGMWrapperRec = new QuarterlyTotal();
                    quarterlyGMWrapperRec.YearNo = year;
                    
                    //For Calculation of Weighted GM %
                    QuarterlyTotal quarterlyRevWrapperRec = new QuarterlyTotal();
                    quarterlyRevWrapperRec.YearNo = year;
                    QuarterlyTotal quarterlyCostWrapperRec = new QuarterlyTotal();
                    quarterlyCostWrapperRec.YearNo = year;
                    
                    mapWaferStart.put(year,quarterlyStartWrapperRec);
                    mapWaferOut.put(year,quarterlyOutWrapperRec);
                    mapWaferForecast.put(year,quarterlyForecastWrapperRec);                    
                    mapWaferGM.put(year,quarterlyGMWrapperRec);
                    mapWaferRevenue.put(year,quarterlyRevWrapperRec);
                    mapWaferCost.put(year,quarterlyCostWrapperRec);
                }
                
                //Calculation for Wafer Start Totals
                DevicePSPData__c tempDevPSP = new DevicePSPData__c();
                QuarterlyTotal tempWaferStartQuarterTotal = new QuarterlyTotal();
                
                for(DevicePSPData__c devicePSPData: lstCompletePSPData){
                    if(mapPSPStartData.get(devicePSPData.Year__c) != NULL){
                        tempDevPSP = mapPSPStartData.get(devicePSPData.Year__c);
                        tempDevPSP.Month_1__c = NullCheck(tempDevPSP.Month_1__c) + NullCheck(devicePSPData.Month_1__c);
                        tempDevPSP.Month_2__c = NullCheck(tempDevPSP.Month_2__c) + NullCheck(devicePSPData.Month_2__c);
                        tempDevPSP.Month_3__c = NullCheck(tempDevPSP.Month_3__c) + NullCheck(devicePSPData.Month_3__c);
                        tempDevPSP.Month_4__c = NullCheck(tempDevPSP.Month_4__c) + NullCheck(devicePSPData.Month_4__c);
                        tempDevPSP.Month_5__c = NullCheck(tempDevPSP.Month_5__c) + NullCheck(devicePSPData.Month_5__c);
                        tempDevPSP.Month_6__c = NullCheck(tempDevPSP.Month_6__c) + NullCheck(devicePSPData.Month_6__c);
                        tempDevPSP.Month_7__c = NullCheck(tempDevPSP.Month_7__c) + NullCheck(devicePSPData.Month_7__c);
                        tempDevPSP.Month_8__c = NullCheck(tempDevPSP.Month_8__c) + NullCheck(devicePSPData.Month_8__c);
                        tempDevPSP.Month_9__c = NullCheck(tempDevPSP.Month_9__c) + NullCheck(devicePSPData.Month_9__c);
                        tempDevPSP.Month_10__c = NullCheck(tempDevPSP.Month_10__c) + NullCheck(devicePSPData.Month_10__c);
                        tempDevPSP.Month_11__c = NullCheck(tempDevPSP.Month_11__c) + NullCheck(devicePSPData.Month_11__c);
                        tempDevPSP.Month_12__c = NullCheck(tempDevPSP.Month_12__c) + NullCheck(devicePSPData.Month_12__c);
                        
                        mapWaferStart.get(devicePSPData.Year__c).quarter1 = NullCheck(mapWaferStart.get(devicePSPData.Year__c).quarter1) + NullCheck(devicePSPData.Month_1__c) + NullCheck(devicePSPData.Month_2__c) + NullCheck(devicePSPData.Month_3__c);
                        mapWaferStart.get(devicePSPData.Year__c).quarter2 = NullCheck(mapWaferStart.get(devicePSPData.Year__c).quarter2) + NullCheck(devicePSPData.Month_4__c) + NullCheck(devicePSPData.Month_5__c) + NullCheck(devicePSPData.Month_6__c);
                        mapWaferStart.get(devicePSPData.Year__c).quarter3 = NullCheck(mapWaferStart.get(devicePSPData.Year__c).quarter3) + NullCheck(devicePSPData.Month_7__c) + NullCheck(devicePSPData.Month_8__c) + NullCheck(devicePSPData.Month_9__c);
                        mapWaferStart.get(devicePSPData.Year__c).quarter4 = NullCheck(mapWaferStart.get(devicePSPData.Year__c).quarter4) + NullCheck(devicePSPData.Month_10__c) + NullCheck(devicePSPData.Month_11__c) + NullCheck(devicePSPData.Month_12__c);
                    }
                }
                lstCompletePSPData.clear();
                lstTotalPSPWaferStart.clear();
                lstWaferStartQuarterTotal.clear();
                
                for(Integer year: lstYearsDisplay){
                    lstTotalPSPWaferStart.add(mapPSPStartData.get(year));
                    lstWaferStartQuarterTotal.add(mapWaferStart.get(year));
                }
                
                //Calculation for Wafer Out Totals
                queryString = queryString.replace('WaferStart Total','WaferOut Total');
                QuarterlyTotal tempWaferOutQuarterTotal = new QuarterlyTotal();
                
                for(Device__c devWaferOut: Database.Query(queryString)){
                    if(devWaferOut.DevicePSPs_Data__r.size()>0){
                        lstCompletePSPWaferOutData.addAll(devWaferOut.DevicePSPs_Data__r);
                    }
                }
                for(DevicePSPData__c devicePSPData : lstCompletePSPWaferOutData){
                    if(mapPSPOutData.get(devicePSPData.Year__c) != NULL){    
                        tempDevPSP = mapPSPOutData.get(devicePSPData.Year__c);
                        tempDevPSP.Month_1__c = NullCheck(tempDevPSP.Month_1__c) + NullCheck(devicePSPData.Month_1__c);
                        tempDevPSP.Month_2__c = NullCheck(tempDevPSP.Month_2__c) + NullCheck(devicePSPData.Month_2__c);
                        tempDevPSP.Month_3__c = NullCheck(tempDevPSP.Month_3__c) + NullCheck(devicePSPData.Month_3__c);
                        tempDevPSP.Month_4__c = NullCheck(tempDevPSP.Month_4__c) + NullCheck(devicePSPData.Month_4__c);
                        tempDevPSP.Month_5__c = NullCheck(tempDevPSP.Month_5__c) + NullCheck(devicePSPData.Month_5__c);
                        tempDevPSP.Month_6__c = NullCheck(tempDevPSP.Month_6__c) + NullCheck(devicePSPData.Month_6__c);
                        tempDevPSP.Month_7__c = NullCheck(tempDevPSP.Month_7__c) + NullCheck(devicePSPData.Month_7__c);
                        tempDevPSP.Month_8__c = NullCheck(tempDevPSP.Month_8__c) + NullCheck(devicePSPData.Month_8__c);
                        tempDevPSP.Month_9__c = NullCheck(tempDevPSP.Month_9__c) + NullCheck(devicePSPData.Month_9__c);
                        tempDevPSP.Month_10__c = NullCheck(tempDevPSP.Month_10__c) + NullCheck(devicePSPData.Month_10__c);
                        tempDevPSP.Month_11__c = NullCheck(tempDevPSP.Month_11__c) + NullCheck(devicePSPData.Month_11__c);
                        tempDevPSP.Month_12__c = NullCheck(tempDevPSP.Month_12__c) + NullCheck(devicePSPData.Month_12__c);
                        
                        tempWaferOutQuarterTotal = mapWaferOut.get(devicePSPData.Year__c);
                        tempWaferOutQuarterTotal.quarter1 = NullCheck(tempWaferOutQuarterTotal.quarter1) + NullCheck(devicePSPData.Month_1__c)+NullCheck(devicePSPData.Month_2__c)+NullCheck(devicePSPData.Month_3__c);
                        tempWaferOutQuarterTotal.quarter2 = NullCheck(tempWaferOutQuarterTotal.quarter2) + NullCheck(devicePSPData.Month_4__c)+NullCheck(devicePSPData.Month_5__c)+NullCheck(devicePSPData.Month_6__c);
                        tempWaferOutQuarterTotal.quarter3 = NullCheck(tempWaferOutQuarterTotal.quarter3) + NullCheck(devicePSPData.Month_7__c)+NullCheck(devicePSPData.Month_8__c)+NullCheck(devicePSPData.Month_9__c);
                        tempWaferOutQuarterTotal.quarter4 = NullCheck(tempWaferOutQuarterTotal.quarter4) + NullCheck(devicePSPData.Month_10__c)+NullCheck(devicePSPData.Month_11__c)+NullCheck(devicePSPData.Month_12__c);
                    }
                }
                lstCompletePSPWaferOutData.clear();
                lstTotalPSPWaferOut.clear();
                lstWaferOutQuarterTotal.clear();
                
                for(Integer year:lstYearsDisplay){
                    lstTotalPSPWaferOut.add(mapPSPOutData.get(year));
                    lstWaferOutQuarterTotal.add(mapWaferOut.get(year));
                }
                
                //++ New calculations 21-Sep-15 NJain
                //++ Calculation for Wafer Forecast Totals
                queryString = queryString.replace('WaferOut Total','Wafer Forecast');
                QuarterlyTotal tempWaferForecastQuarterTotal = new QuarterlyTotal();
                
                Set<String> setCheckUniqueOpportunity = new Set<String>();
                for(Device__c devWaferForecast: Database.Query(queryString)){
                    if(!setCheckUniqueOpportunity.contains(devWaferForecast.Opportunity2__c)){
                        if(devWaferForecast.DevicePSPs_Data__r.size()>0){
                            lstCompletePSPWaferForecastData.addAll(devWaferForecast.DevicePSPs_Data__r);
                        }
                        setCheckUniqueOpportunity.add(devWaferForecast.Opportunity2__c);
                    }
                }
                for(DevicePSPData__c devicePSPData : lstCompletePSPWaferForecastData){
                    if(mapPSPForecastData.get(devicePSPData.Year__c) != NULL){    
                        tempDevPSP = mapPSPForecastData.get(devicePSPData.Year__c);
                        tempDevPSP.Month_1__c = NullCheck(tempDevPSP.Month_1__c) + NullCheck(devicePSPData.Month_1__c);
                        tempDevPSP.Month_2__c = NullCheck(tempDevPSP.Month_2__c) + NullCheck(devicePSPData.Month_2__c);
                        tempDevPSP.Month_3__c = NullCheck(tempDevPSP.Month_3__c) + NullCheck(devicePSPData.Month_3__c);
                        tempDevPSP.Month_4__c = NullCheck(tempDevPSP.Month_4__c) + NullCheck(devicePSPData.Month_4__c);
                        tempDevPSP.Month_5__c = NullCheck(tempDevPSP.Month_5__c) + NullCheck(devicePSPData.Month_5__c);
                        tempDevPSP.Month_6__c = NullCheck(tempDevPSP.Month_6__c) + NullCheck(devicePSPData.Month_6__c);
                        tempDevPSP.Month_7__c = NullCheck(tempDevPSP.Month_7__c) + NullCheck(devicePSPData.Month_7__c);
                        tempDevPSP.Month_8__c = NullCheck(tempDevPSP.Month_8__c) + NullCheck(devicePSPData.Month_8__c);
                        tempDevPSP.Month_9__c = NullCheck(tempDevPSP.Month_9__c) + NullCheck(devicePSPData.Month_9__c);
                        tempDevPSP.Month_10__c = NullCheck(tempDevPSP.Month_10__c) + NullCheck(devicePSPData.Month_10__c);
                        tempDevPSP.Month_11__c = NullCheck(tempDevPSP.Month_11__c) + NullCheck(devicePSPData.Month_11__c);
                        tempDevPSP.Month_12__c = NullCheck(tempDevPSP.Month_12__c) + NullCheck(devicePSPData.Month_12__c);
                        
                        tempWaferForecastQuarterTotal = mapWaferForecast.get(devicePSPData.Year__c);
                        tempWaferForecastQuarterTotal.quarter1 = NullCheck(tempWaferForecastQuarterTotal.quarter1) + NullCheck(devicePSPData.Month_1__c)+NullCheck(devicePSPData.Month_2__c)+NullCheck(devicePSPData.Month_3__c);
                        tempWaferForecastQuarterTotal.quarter2 = NullCheck(tempWaferForecastQuarterTotal.quarter2) + NullCheck(devicePSPData.Month_4__c)+NullCheck(devicePSPData.Month_5__c)+NullCheck(devicePSPData.Month_6__c);
                        tempWaferForecastQuarterTotal.quarter3 = NullCheck(tempWaferForecastQuarterTotal.quarter3) + NullCheck(devicePSPData.Month_7__c)+NullCheck(devicePSPData.Month_8__c)+NullCheck(devicePSPData.Month_9__c);
                        tempWaferForecastQuarterTotal.quarter4 = NullCheck(tempWaferForecastQuarterTotal.quarter4) + NullCheck(devicePSPData.Month_10__c)+NullCheck(devicePSPData.Month_11__c)+NullCheck(devicePSPData.Month_12__c);
                    }
                }
                lstCompletePSPWaferForecastData.clear();
                lstTotalPSPWaferForecast.clear();
                lstWaferForecastQuarterTotal.clear();
                
                for(Integer year:lstYearsDisplay){
                    lstTotalPSPWaferForecast.add(mapPSPForecastData.get(year));
                    lstWaferForecastQuarterTotal.add(mapWaferForecast.get(year));
                }
                
                //-- Calculation for Wafer Forecast Totals
                
                //++ Weighted Wafer GM ($) Totals
                queryString = queryString.replace('Wafer Forecast','Wafer QTR GM($)');
                
                for(Device__c devWaferGM: Database.Query(queryString)){
                    if(devWaferGM.DevicePSPs_Data__r.size()>0){
                        lstCompletePSPWaferGMData.addAll(devWaferGM.DevicePSPs_Data__r);
                    }
                }                
                for(DevicePSPData__c devicePSPData: lstCompletePSPWaferGMData){
                    if(mapWaferGM.get(devicePSPData.Year__c) != NULL){
                        mapWaferGM.get(devicePSPData.Year__c).quarter1 = NullCheck(mapWaferGM.get(devicePSPData.Year__c).quarter1) + NullCheck(devicePSPData.Quarter1__c);
                        mapWaferGM.get(devicePSPData.Year__c).quarter2 = NullCheck(mapWaferGM.get(devicePSPData.Year__c).quarter2) + NullCheck(devicePSPData.Quarter2__c);
                        mapWaferGM.get(devicePSPData.Year__c).quarter3 = NullCheck(mapWaferGM.get(devicePSPData.Year__c).quarter3) + NullCheck(devicePSPData.Quarter3__c);
                        mapWaferGM.get(devicePSPData.Year__c).quarter4 = NullCheck(mapWaferGM.get(devicePSPData.Year__c).quarter4) + NullCheck(devicePSPData.Quarter4__c);
                    }
                }
                lstCompletePSPWaferGMData.clear();
                lstWaferGMQuarterTotal.clear();
                
                for(Integer year: lstYearsDisplay){
                    lstWaferGMQuarterTotal.add(mapWaferGM.get(year));
                }
                //-- Weighted Wafer GM ($) Totals
                
                //++ Weighted Wafer GM% Totals
                // for calculation of Total Revenue per Quarter
                List<DevicePSPData__c> lstCompletePSPRevenueData = new List<DevicePSPData__c>();
                queryString = queryString.replace('Wafer QTR GM($)','Revenue ($)');
                QuarterlyTotal tempRevenueQuarterTotal = new QuarterlyTotal();
                for(Device__c devWaferRev: Database.Query(queryString)){
                    if(devWaferRev.DevicePSPs_Data__r.size()>0){
                        lstCompletePSPRevenueData.addAll(devWaferRev.DevicePSPs_Data__r);
                    }
                }
                for(DevicePSPData__c devicePSPData: lstCompletePSPRevenueData){
                    if(mapWaferRevenue.get(devicePSPData.Year__c) != NULL){
                        mapWaferRevenue.get(devicePSPData.Year__c).Quarter1 = NullCheck(mapWaferRevenue.get(devicePSPData.Year__c).Quarter1) + NullCheck(devicePSPData.Quarter1__c);
                        mapWaferRevenue.get(devicePSPData.Year__c).Quarter2 = NullCheck(mapWaferRevenue.get(devicePSPData.Year__c).Quarter2) + NullCheck(devicePSPData.Quarter2__c);
                        mapWaferRevenue.get(devicePSPData.Year__c).Quarter3 = NullCheck(mapWaferRevenue.get(devicePSPData.Year__c).Quarter3) + NullCheck(devicePSPData.Quarter3__c);
                        mapWaferRevenue.get(devicePSPData.Year__c).Quarter4 = NullCheck(mapWaferRevenue.get(devicePSPData.Year__c).Quarter4) + NullCheck(devicePSPData.Quarter4__c);
                    }
                }
                lstCompletePSPRevenueData.clear();
                lstRevenueQuarterTotal.clear();
                for(Integer year: lstYearsDisplay){
                    if(mapWaferRevenue.get(year) != null){
                        lstRevenueQuarterTotal.add(mapWaferRevenue.get(year));
                    }
                }
                
                // for calculation of Total Wafer Cost per Quarter
              
                List<DevicePSPData__c> lstCompletePSPWaferCostData = new List<DevicePSPData__c>();
                queryString = queryString.replace('Revenue ($)','Wafer Cost');
                QuarterlyTotal tempWaferCostQuarterTotal = new QuarterlyTotal();
                for(Device__c devWaferCost: Database.Query(queryString)){
                    if(devWaferCost.DevicePSPs_Data__r.size()>0){
                        lstCompletePSPWaferCostData.addAll(devWaferCost.DevicePSPs_Data__r);
                    }
                }               
                for(DevicePSPData__c devicePSPData: lstCompletePSPWaferCostData){
                    if(mapWaferCost.get(devicePSPData.Year__c) != NULL){
                        mapWaferCost.get(devicePSPData.Year__c).quarter1 = NullCheck(mapWaferCost.get(devicePSPData.Year__c).quarter1) + NullCheck(devicePSPData.Quarter1__c);
                        mapWaferCost.get(devicePSPData.Year__c).quarter2 = NullCheck(mapWaferCost.get(devicePSPData.Year__c).quarter2) + NullCheck(devicePSPData.Quarter2__c);
                        mapWaferCost.get(devicePSPData.Year__c).quarter3 = NullCheck(mapWaferCost.get(devicePSPData.Year__c).quarter3) + NullCheck(devicePSPData.Quarter3__c);
                        mapWaferCost.get(devicePSPData.Year__c).quarter4 = NullCheck(mapWaferCost.get(devicePSPData.Year__c).quarter4) + NullCheck(devicePSPData.Quarter4__c);
                    }
                }
                lstCompletePSPWaferCostData.clear();
                lstCostQuarterTotal.clear();                
                for(Integer year: lstYearsDisplay){
                    if(mapWaferCost.get(year)!=null){
                        lstCostQuarterTotal.add(mapWaferCost.get(year));
                    }
                }
                
                //DBiswal - for calculation of Qtrly TTL Wfr Cost
                lstQtrlyWaferCostTotal.clear();
                for(QuarterlyTotal qt : lstCostQuarterTotal){
                    QuarterlyTotal waferCostrecord = new QuarterlyTotal();
                    //if(qt.yearNo != null){
                    if(qt.yearNo != null){
                        waferCostrecord.quarter1 = NullCheck(qt.quarter1)*NullCheck(mapWaferOut.get(qt.yearNo).quarter1);
                        waferCostrecord.quarter2 = NullCheck(qt.quarter2)*NullCheck(mapWaferOut.get(qt.yearNo).quarter2);
                        waferCostrecord.quarter3 = NullCheck(qt.quarter3)*NullCheck(mapWaferOut.get(qt.yearNo).quarter3);
                        waferCostrecord.quarter4 = NullCheck(qt.quarter4)*NullCheck(mapWaferOut.get(qt.yearNo).quarter4);
                        waferCostrecord.yearNo = qt.yearNo;
                    }
                    lstQtrlyWaferCostTotal.add(waferCostrecord);
                }
                
                
                //DBiswal - for calculation of Qtrly TTL Turnkey Rev
                List<DevicePSPData__c> lstCompletePSPTurnkeyRevData = new List<DevicePSPData__c>();
                queryString = queryString.replace('Wafer Cost','Turnkey ASP');
                for(Device__c devTurnkeyRev: Database.Query(queryString)){
                    if(devTurnkeyRev.DevicePSPs_Data__r.size()>0){
                        lstCompletePSPTurnkeyRevData.addAll(devTurnkeyRev.DevicePSPs_Data__r);
                    }
                }
                lstQtrlyTurnkeyRevTotal.clear();
                for(Decimal year: mapWaferOut.keySet()){
                    QuarterlyTotal turnkeyRevrecord = new QuarterlyTotal();
                    for(DevicePSPData__c devicePSPData: lstCompletePSPTurnkeyRevData){
                        if(devicePSPData.Year__c == year.intValue()){
                            turnkeyRevrecord.quarter1 = NullCheck(devicePSPData.Quarter1__c)*NullCheck(mapWaferOut.get(devicePSPData.Year__c).quarter1);
                            turnkeyRevrecord.quarter2 = NullCheck(devicePSPData.Quarter2__c)*NullCheck(mapWaferOut.get(devicePSPData.Year__c).quarter2);
                            turnkeyRevrecord.quarter3 = NullCheck(devicePSPData.Quarter3__c)*NullCheck(mapWaferOut.get(devicePSPData.Year__c).quarter3);
                            turnkeyRevrecord.quarter4 = NullCheck(devicePSPData.Quarter4__c)*NullCheck(mapWaferOut.get(devicePSPData.Year__c).quarter4);
                            turnkeyRevrecord.yearNo = devicePSPData.Year__c;
                        }                        
                    }
                    if(turnkeyRevrecord.yearNo != null){
                        lstQtrlyTurnkeyRevTotal.add(turnkeyRevrecord);
                    }
                }
                lstCompletePSPTurnkeyRevData.clear();
                
                //DBiswal - for calculation of Qtrly TTL Turnkey Cost
                List<DevicePSPData__c> lstCompletePSPTurnkeyCostData = new List<DevicePSPData__c>();
                queryString = queryString.replace('Turnkey ASP','Turnkey Cost');
                for(Device__c devTurnkeyCost: Database.Query(queryString)){
                    if(devTurnkeyCost.DevicePSPs_Data__r.size()>0){
                        lstCompletePSPTurnkeyCostData.addAll(devTurnkeyCost.DevicePSPs_Data__r);
                    }
                }
                lstQtrlyTurnkeyCostTotal.clear();
                for(Decimal year: mapWaferOut.keySet()){
                    QuarterlyTotal turnkeyCostrecord = new QuarterlyTotal();
                    for(DevicePSPData__c devicePSPData: lstCompletePSPTurnkeyCostData){
                        if(devicePSPData.Year__c == year.intValue()){
                            turnkeyCostrecord.quarter1 = NullCheck(devicePSPData.Quarter1__c)*NullCheck(mapWaferOut.get(devicePSPData.Year__c).quarter1);
                            turnkeyCostrecord.quarter2 = NullCheck(devicePSPData.Quarter2__c)*NullCheck(mapWaferOut.get(devicePSPData.Year__c).quarter2);
                            turnkeyCostrecord.quarter3 = NullCheck(devicePSPData.Quarter3__c)*NullCheck(mapWaferOut.get(devicePSPData.Year__c).quarter3);
                            turnkeyCostrecord.quarter4 = NullCheck(devicePSPData.Quarter4__c)*NullCheck(mapWaferOut.get(devicePSPData.Year__c).quarter4);
                            turnkeyCostrecord.yearNo = devicePSPData.Year__c;
                        }                        
                    }
                    if(turnkeyCostrecord.yearNo != null){
                        lstQtrlyTurnkeyCostTotal.add(turnkeyCostrecord);
                    }
                }
                lstCompletePSPTurnkeyCostData.clear();
                
/*-----------------------------sunita-----------------------------*/                
             
             for(QuarterlyTotal obj: lstRevenueQuarterTotal)
             {
                 for(QuarterlyTotal obj1: lstCostQuarterTotal)
                     {
                      if(obj!=null && obj1!=null && obj.yearNo==obj1.yearNo)
                      {
                      
                         QuarterlyTotal newObj=new QuarterlyTotal ();
                         if(obj.quarter1 != null && obj1.quarter1 != null){
                             newObj.quarter1=(obj.quarter1-obj1.quarter1);
                             if(obj.quarter1!=0)
                             {
                               newObj.quarter1= newObj.quarter1/obj.quarter1;
                               newObj.quarter1=newobj.quarter1.setScale(2);
                             }
                             else
                             {
                               newObj.quarter1=0;
                             }
                         }
                         if(obj.quarter2 != null && obj1.quarter2 != null){
                             newObj.quarter2=(obj.quarter2-obj1.quarter2);
                             
                             if(obj.quarter2!=0)
                             {
                               newObj.quarter2= newObj.quarter2/obj.quarter2;
                               newObj.quarter2=newobj.quarter2.setScale(2);
                             }
                             else
                             {
                               newObj.quarter2=0;
                             }
                         }
                         if(obj.quarter3 != null && obj1.quarter3 != null){
                             newObj.quarter3=(obj.quarter3-obj1.quarter3);
                             if(obj.quarter3!=0)
                             {
                               newObj.quarter3= newObj.quarter3/obj.quarter3;
                               newObj.quarter3=newobj.quarter3.setScale(2);
                             }
                             else
                             {
                               newObj.quarter3=0;
                             }
                         }
                         if(obj.quarter4 != null && obj1.quarter4 != null){
                             newObj.quarter4=(obj.quarter4-obj1.quarter4);
                             if(obj.quarter4!=0)
                             {
                               newObj.quarter4= newObj.quarter4/obj.quarter4;
                               newObj.quarter4=newobj.quarter4.setScale(2);
                             }
                             else
                             {
                               newObj.quarter4=0;
                             }
                         }

                         lstWeightedGM.add(newObj);
                         
                         }
                     
                     }
                     
                 
             }
             
             Set<Id> setOpp=new Set<Id>();
             Set<Id> setAcc=new Set<Id>();
             
             for(Device__c objdev:lstDevices)
             {
              if(objdev.Opportunity2__r!=null)
              {
               setOpp.add(objdev.Opportunity2__c);
              }
              if(objdev.Account__c!=null)
              {
              setAcc.add(objdev.Account__c);
              }
             
             }
             
             List<Account> lstAcc=[Select id from account where id in:setAcc];
             List<Opportunity> lstOpp=[Select id from Opportunity where id in:setOpp];
             List<Opportunity> lstOpp1=[Select id from Opportunity where AccountId in:setAcc];
             
             
             Set<Id> setOpp1 =new Set<Id>();
             for(Opportunity obj :lstOpp1)
             {
             setOpp1.add(obj.Id);
             }
             setOpp.addAll(setOpp1);
             List<Quarterly_Revenue_Object__c> lstQTR=[Select Id,Opportunity__c,
                                                              Volume__c,Date__c,
                                                              Fiscal_Quarter__c 
                                                              from Quarterly_Revenue_Object__c
                                                              where Opportunity__c in:setOpp ORDER BY Date__c ASC];
             Set<Decimal> yearSet = new Set<Decimal>();
             for(Integer i : lstYearsDisplay){
                 yearSet.add(Decimal.valueOf(i));
             }
             lstOppWaferOuts  = new List<calculateWaferOuts>(); 
             Decimal YearVal;
             for(Decimal year : yearSet){
                 calculateWaferOuts oppWaferOutperYear = new calculateWaferOuts();
                 for(Quarterly_Revenue_Object__c qr: lstQTR){
                     YearVal  = Decimal.valueOf(qr.Date__c.year());
                     if(YearVal == year && qr.Fiscal_Quarter__c != NULL){
                         oppWaferOutperYear.yearNo = year;
                         if(qr.Fiscal_Quarter__c.contains('Q1')){
                             oppWaferOutperYear.quarter1 = qr.Volume__c;
                             oppWaferOutperYear.month1 = Math.floor(qr.Volume__c != 0 ? qr.Volume__c/3 : qr.Volume__c);
                             oppWaferOutperYear.month2 = Math.floor(qr.Volume__c != 0 ? qr.Volume__c/3 : qr.Volume__c);
                             oppWaferOutperYear.month3 = Math.ceil(qr.Volume__c != 0 ? qr.Volume__c/3 : qr.Volume__c);                    
                         }else if(qr.Fiscal_Quarter__c.contains('Q2')){
                             oppWaferOutperYear.quarter2 = qr.Volume__c;
                             oppWaferOutperYear.month4 = Math.floor(qr.Volume__c != 0 ? qr.Volume__c/3 : qr.Volume__c);
                             oppWaferOutperYear.month5 = Math.floor(qr.Volume__c != 0 ? qr.Volume__c/3 : qr.Volume__c);
                             oppWaferOutperYear.month6 = Math.ceil(qr.Volume__c != 0 ? qr.Volume__c/3 : qr.Volume__c);
                         }else if(qr.Fiscal_Quarter__c.contains('Q3')){
                             oppWaferOutperYear.quarter3 = qr.Volume__c;
                             oppWaferOutperYear.month7 = Math.floor(qr.Volume__c != 0 ? qr.Volume__c/3 : qr.Volume__c);
                             oppWaferOutperYear.month8 = Math.floor(qr.Volume__c != 0 ? qr.Volume__c/3 : qr.Volume__c);
                             oppWaferOutperYear.month9 = Math.ceil(qr.Volume__c != 0 ? qr.Volume__c/3 : qr.Volume__c);
                         }else if(qr.Fiscal_Quarter__c.contains('Q4')){
                             oppWaferOutperYear.quarter4 = qr.Volume__c;
                             oppWaferOutperYear.month10 = Math.floor(qr.Volume__c != 0 ? qr.Volume__c/3 : qr.Volume__c);
                             oppWaferOutperYear.month11 = Math.floor(qr.Volume__c != 0 ? qr.Volume__c/3 : qr.Volume__c);
                             oppWaferOutperYear.month12 = Math.ceil(qr.Volume__c != 0 ? qr.Volume__c/3 : qr.Volume__c);
                         }
                     }
                 }
                 lstOppWaferOuts.add(oppWaferOutperYear);
             }
             
            }
            return lstDevices;
        }catch (QueryException e) {
            ApexPages.addMessages(e);   
            return null;
        } 
    }
    
    //Function for NULL check. Returns 0 when NULL, otherwise the value being passed.
    public decimal NullCheck(decimal i){
        if(i==NULL)
            return 0;
        else
            return i;       
    }

    //++pagination for results   
    public PageReference Beginning() { //user clicked beginning
        counter = 0;
        return null;
    }    
    public PageReference Previous() { //user clicked previous button
        counter -= list_size;
        return null;
    }    
    public PageReference Next() { //user clicked next button
        counter += list_size;
        return null;
    }    
    public PageReference End() { //user clicked end
        counter = total_size - math.mod(total_size, list_size);
        return null;
    }    
    public Boolean getDisablePrevious() { 
        //this will disable the previous and beginning buttons
        if (counter>0) return false; else return true;
    }    
    public Boolean getDisableNext() { //this will disable the next and end buttons
        if (counter + list_size < total_size) return false; else return true;
    }    
    public Integer getTotal_size() {
        return total_size;
    }    
    public Integer getPageNumber() {
        return counter/list_size + 1;
    }    
    public Integer getTotalPages() {
        if (math.mod(total_size, list_size) > 0) {
            return total_size/list_size + 1;
        }else{
            return (total_size/list_size);
        }
    }
    //--pagination for results
     
    //Exporting the records to Excel file
    public pageReference ExportToExcel(){
        lstWeightedGM.clear();
        lstWeightedAverage.clear();
        PageReference pageRef = new PageReference('/apex/PSP_searchExport?id='+deviceRec.id);
        return pageRef;
    }
    
    //Return to the opportunity in Return
    public pageReference returnFunction(){
        PageReference pageRef;
        if(oppId != NULL && oppId != ''){
            pageRef = new PageReference('/'+oppId);
        }else if(accId != NULL && accId !=''){
            pageRef = new PageReference('/'+accId);
        }else{
            pageRef = new PageReference('/home/home.jsp');
        }
        return pageRef;
    }
    
     public pageReference isValidProfileForProvisioning(){
        //DBiswal 01182016 - access granted using public group
        Set<Id> setUserIds = new Set<Id>();
        for(GroupMember gm : [SELECT Id,UserOrGroupId FROM GroupMember where Group.DeveloperName = 'PSP_Margin_Analysis_Access']){
            setUserIds.add(gm.UserOrGroupId);
        }
        if(setUserIds != null && setUserIds.contains(UserInfo.getUserId())){
            isValidProfile = true;
        }
        return null;
    }
    
    //DBiswal 05162016
    public class calculateWaferOuts{
        public decimal month1{get;set;}
        public decimal month2{get;set;}
        public decimal month3{get;set;}
        public decimal month4{get;set;}
        public decimal month5{get;set;}
        public decimal month6{get;set;}
        public decimal month7{get;set;}
        public decimal month8{get;set;}
        public decimal month9{get;set;}
        public decimal month10{get;set;}
        public decimal month11{get;set;}
        public decimal month12{get;set;}
        public decimal quarter1{get;set;}
        public decimal quarter2{get;set;}
        public decimal quarter3{get;set;}
        public decimal quarter4{get;set;}
        public decimal yearNo{get;set;}
    }
}