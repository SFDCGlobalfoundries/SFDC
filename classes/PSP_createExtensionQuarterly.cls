/*
    Type Name: PSP_createExtensionQuarterly
    Author: Deepti Narayan Biswal 
    Created Date: 05212016
    Description: This class serves controller for PSP_Create page.
    Test Class: PSP_createExtensionQuarterlyTest
    Change History:
    04262017        for PSP TOR calculation by Market segment(line no. 457-495)
*/
public with sharing class PSP_createExtensionQuarterly{
    
    public Device__c deviceRecord{get;set;}
    public List<Integer> lstYears{get;set;}
    public Boolean isValidProfile{get;set;}
    
    public List<DevicePSPData__c> lstPSPproductTORecords{get;set;}
    public List<DevicePSPData__c> lstPSPsampleDelRecords{get;set;}
    public List<DevicePSPData__c> lstPSPprotoRecords{get;set;}
    public List<DevicePSPData__c> lstPSPpreProdRecords{get;set;}
    public List<DevicePSPData__c> lstPSPprodRecords{get;set;}
    public List<DevicePSPData__c> lstPSPwaferStartTotalRecords{get;set;}
    public List<DevicePSPData__c> lstPSPwaferOutTotalRecords{get;set;}
    
    public List<DevicePSPData__c> lstPSPProtoASPRecords{get;set;}
    public List<calculateWaferOuts> lstPSPProtoRevRecords{get;set;}
    public List<DevicePSPData__c> lstPSPProdASPRecords{get;set;}
    public List<calculateWaferOuts> lstPSPProdRevRecords{get;set;}
    
    public boolean overrideWaferOut{get;set;}
    public boolean showWaferOut{get;set;}
    public boolean showTable{get;set;}
    public boolean editAccess{get;set;}
    public List<DevicePSPData__c> lstPSPrecords;
    
    public List<QuarterlyTotal> lstPSPwaferQTRTTLCost{get;set;}
    public List<QuarterlyTotal> lstPSPturnkeyQTRTTLCost{get;set;}
    public List<QuarterlyTotal> lstPSPTurnkeyRev{get;set;}
    
    //DBiswal   05152016
    public List<DevicePSPData__c> lstPSPprototypeWaferStarts {get;set;}
    public List<DevicePSPData__c> lstPSPproductionWaferStarts {get;set;}
    public List<DevicePSPData__c> lstprototypeWaferOuts {get;set;}
    public List<DevicePSPData__c> lstproductionWaferOuts {get;set;}
    public List<calculateWaferOuts> lstOppWaferOuts {get;set;}
    public List<calculateWaferOuts> lstOppWaferASPs {get;set;}
    public Decimal torTotal {get;set;}
    public String delType {get;set;}
    public Device__c dev = new Device__c();
    public Boolean isASICFlag {get;set;}
    
     public class QuarterlyTotal{
        public Decimal quarter1{get;set;}
        public Decimal quarter2{get;set;}
        public Decimal quarter3{get;set;}
        public Decimal quarter4{get;set;}
        public Decimal yearNo{get;set;}
    }
        
    //Constructor for Standard Controller
    public PSP_createExtensionQuarterly(ApexPages.StandardController controller) {
        
        //initializing variables and lists
        this.devicerecord = (Device__c)controller.getRecord();
        lstPSPrecords = new List<DevicePSPData__c>();
        lstYears = new List<Integer>();
        showWaferOut = true;
        overrideWaferOut = false;
        showTable = true;
        isValidProfile = false;
        torTotal = 0;
        
        //Get DPML values from table
        dev = [SELECT Id,Fab__c,Market_Segment__c,Product_TO_Date__c,Product_Indicator__c,Geometry__c,Proto_DPML__c,Production_DPML__c,TOR_Automatic__c,Deliverable_Type__c FROM Device__c WHERE Id =: devicerecord.Id];
        List<PSP_DPML_Table__c> dpmlTablelist = [SELECT Id,Fab__c,Geometry__c,GF_Risk_Start_DPML__c,Production_DPML__c,Proto_DPML__c FROM PSP_DPML_Table__c WHERE Fab__c =: dev.Fab__c AND Geometry__c =: dev.Geometry__c LIMIT 1];
        if(dpmlTablelist.size() > 0){
            devicerecord.Proto_DPML__c = dev.Proto_DPML__c!=null ? dev.Proto_DPML__c : dpmlTablelist[0].Proto_DPML__c;
            devicerecord.Production_DPML__c = dev.Production_DPML__c!=null ? dev.Production_DPML__c : dpmlTablelist[0].Production_DPML__c;
        }
        
        if(dev.Deliverable_Type__c != null && dev.Deliverable_Type__c == 'Chip'){
            delType = 'Chip';
        } else if(dev.Deliverable_Type__c != null && dev.Deliverable_Type__c == 'Module'){
            delType = 'Module';
        } else {
            delType = 'Wafer';
        }
        if(dev.Product_Indicator__c == 'ASIC' || dev.Fab__c == 'FAB 9' || dev.Fab__c == 'FAB 10'){
            isASICFlag = true;
        } else {
            isASICFlag = false;
        }
        
        try{
            Id CSRprofileId= [select id from Profile where name = 'GF CSR' limit 1].Id;
            
            //Opening the PSP edit access explicitly for CSR users
            editAccess = [SELECT RecordId,HasEditAccess  FROM UserRecordAccess WHERE UserId=:UserInfo.getUserId() AND RecordId =:deviceRecord.Id].HasEditAccess || UserInfo.getProfileId() == CSRprofileId;
            if((deviceRecord.Proto_Wafer_Fab_Shipped_Current__c == NULL || deviceRecord.Assembled_Tested_Part_Shipped_Current__c == NULL || deviceRecord.Production_Wafer_Start_Current__c == NULL ||
               deviceRecord.Proto_Wafer_First_Lot_Start_Current__c == NULL) && dev.Product_Indicator__c != 'ASIC'){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Please fill the PSP section for Dates'));
                showTable = false;
            }else{
                //get the record details from the database
                callRecords();            
                calculateoppWaferOut();
                //Displaying message when DPML and Mask Layer field is empty for WAFER OUT calculations
                if(deviceRecord.Proto_DPML__c == NULL || deviceRecord.No_of_Mask_Layers__c == NULL || deviceRecord.Production_DPML__c == NULL){
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Please fill DPMLs and Mask Layer fields for WaferOut calculations.'));
                    showWaferOut = false;
                }
            }
        }catch(Exception e){
            PSP_createExtension.exceptionHandleMethod(PSP_createExtensionQuarterly.class.getName(),'within constructor',String.ValueOf(deviceRecord.Id),'Error Message='+e.getMessage()+' At Line Number='+e.getLineNumber()+' Stack Trace='+e.getStackTraceString(),e.getTypeName(),e.getCause());
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Following Exception Occurred:'+e.getMessage()));        
        }
    }
    
    //Function for making a query call to get the details of the Device record.
    public Map<Decimal,DevicePSPData__c> mapYearWaferOut3 = new Map<Decimal,DevicePSPData__c>();
    public void callRecords(){
        lstPSPrecords.clear();
        lstPSPrecords = [select id,Phase__c,Year__c,
                         Month_1__c,Month_2__c,Month_3__c,Month_4__c,Month_5__c,Month_6__c, 
                         Month_7__c,Month_8__c,Month_9__c,Month_10__c,Month_11__c,Month_12__c,
                         WaferStart_Quarter1__c,WaferStart_Quarter2__c ,WaferStart_Quarter3__c ,WaferStart_Quarter4__c,
                         Quarter1__c,Quarter2__c,Quarter3__c,Quarter4__c,Device__r.Market_Segment__c
                         from DevicePSPData__c where Device__c = :devicerecord.Id order by Phase_Number__c,Year__c];
        
        lstYears.clear();
        AggregateResult[] lstAggrReslt = [select min(Year__c),max(Year__c) from DevicePSPData__c where Device__c =:deviceRecord.id];
        if(!lstAggrReslt.isEmpty()){
            for(integer i= integer.valueOf(lstAggrReslt[0].get('expr0'));i<=integer.valueOf(lstAggrReslt[0].get('expr1'));i++){
                lstYears.add(i);
            }
        }
        lstYears.sort();
        
        Device__c dev = [SELECT Id,Deliverable_Type__c FROM Device__c WHERE Id =: deviceRecord.Id];
        if(dev.Deliverable_Type__c != null && dev.Deliverable_Type__c == 'Chip'){
            delType = 'Chip';
        } else if(dev.Deliverable_Type__c != null && dev.Deliverable_Type__c == 'Module'){
            delType = 'Module';
        } else {
            delType = 'Wafer';
        }
        
        lstPSPproductTORecords =  new List<DevicePSPData__c>();
        lstPSPsampleDelRecords =  new List<DevicePSPData__c>();
        lstPSPprotoRecords     =  new List<DevicePSPData__c>();
        lstPSPpreProdRecords   =  new List<DevicePSPData__c>();
        lstPSPprodRecords      =  new List<DevicePSPData__c>();
        lstPSPwaferStartTotalRecords =  new List<DevicePSPData__c>();
        lstPSPwaferOutTotalRecords   =  new List<DevicePSPData__c>();
        
        
        //DBiswal   05152016
        lstPSPprototypeWaferStarts = new List<DevicePSPData__c>();
        lstPSPproductionWaferStarts = new List<DevicePSPData__c>();
        lstprototypeWaferOuts = new List<DevicePSPData__c>();
        lstproductionWaferOuts  = new List<DevicePSPData__c>();
        lstOppWaferOuts  = new List<calculateWaferOuts>();
        lstOppWaferASPs = new List<calculateWaferOuts>();
        
        lstPSPProtoASPRecords = new List<DevicePSPData__c>();
        lstPSPProtoRevRecords = new List<calculateWaferOuts>();
        lstPSPProdASPRecords = new List<DevicePSPData__c>();
        lstPSPProdRevRecords = new List<calculateWaferOuts>();
        
        for(DevicePSPData__c pspRec:lstPSPrecords){
            if(pspRec.Phase__c == 'Prototype Wafer Start'){
                lstPSPprototypeWaferStarts.add(pspRec);
            }else if(pspRec.Phase__c == 'Prototype Wafer Out'){
                lstprototypeWaferOuts.add(pspRec);
            }else if(pspRec.Phase__c == 'Prototype Wafer ASP'){
                lstPSPProtoASPRecords.add(pspRec);
            }else if(pspRec.Phase__c == 'Production Wafer Start'){
                lstPSPproductionWaferStarts.add(pspRec);
            }else if(pspRec.Phase__c == 'Production Wafer Out'){
                lstproductionWaferOuts.add(pspRec);
            }else if(pspRec.Phase__c == 'Production Wafer ASP'){
                lstPSPProdASPRecords.add(pspRec);
            }
        }
        
        //DBiswal - Calculation for Wafer QTR TTL Cost, Turnkey Qtr TTL Cost and Turnkey Revenue
        Map<Decimal,DevicePSPData__c> mapYearWaferOut = new Map<Decimal,DevicePSPData__c>();
        for(DevicePSPData__c pspRecWaferOut : lstPSPwaferOutTotalRecords){
            mapYearWaferOut.put(pspRecWaferOut.Year__c,pspRecWaferOut);
        }
        
        for(DevicePSPData__c pspRecWaferOut : lstproductionWaferOuts){
            mapYearWaferOut3.put(pspRecWaferOut.Year__c,pspRecWaferOut);
        }
        
        Map<Decimal,DevicePSPData__c> mapProtoWaferOutCal = new Map<Decimal,DevicePSPData__c>();
        for(DevicePSPData__c pspRecWaferOut : lstprototypeWaferOuts){
            mapProtoWaferOutCal.put(pspRecWaferOut.Year__c,pspRecWaferOut);
        }
                
        lstPSPProtoRevRecords = new List<calculateWaferOuts>();
        lstPSPProdRevRecords = new List<calculateWaferOuts>();
            
        for(DevicePSPData__c pspdata : lstPSPProtoASPRecords){
            if(mapProtoWaferOutCal.containsKey(pspdata.Year__c)){
                calculateWaferOuts pspProtoRevperYear = new calculateWaferOuts();
                pspProtoRevperYear.quarter1 = (pspdata.WaferStart_Quarter1__c * mapProtoWaferOutCal.get(pspdata.Year__c).WaferStart_Quarter1__c).setScale(2);
                pspProtoRevperYear.quarter2 = (pspdata.WaferStart_Quarter2__c * mapProtoWaferOutCal.get(pspdata.Year__c).WaferStart_Quarter2__c).setScale(2);
                pspProtoRevperYear.quarter3 = (pspdata.WaferStart_Quarter3__c * mapProtoWaferOutCal.get(pspdata.Year__c).WaferStart_Quarter3__c).setScale(2);
                pspProtoRevperYear.quarter4 = (pspdata.WaferStart_Quarter4__c * mapProtoWaferOutCal.get(pspdata.Year__c).WaferStart_Quarter4__c).setScale(2);
                pspProtoRevperYear.yearNo = pspdata.Year__c;
                
                lstPSPProtoRevRecords.add(pspProtoRevperYear);
            }                
        }
        
        for(DevicePSPData__c pspdata : lstPSPProdASPRecords){
            if(mapYearWaferOut3.containsKey(pspdata.Year__c)){
                calculateWaferOuts pspProdRevperYear = new calculateWaferOuts();
                pspProdRevperYear.quarter1 = (pspdata.WaferStart_Quarter1__c * mapYearWaferOut3.get(pspdata.Year__c).WaferStart_Quarter1__c).setScale(2);
                pspProdRevperYear.quarter2 = (pspdata.WaferStart_Quarter2__c * mapYearWaferOut3.get(pspdata.Year__c).WaferStart_Quarter2__c).setScale(2);
                pspProdRevperYear.quarter3 = (pspdata.WaferStart_Quarter3__c * mapYearWaferOut3.get(pspdata.Year__c).WaferStart_Quarter3__c).setScale(2);
                pspProdRevperYear.quarter4 = (pspdata.WaferStart_Quarter4__c * mapYearWaferOut3.get(pspdata.Year__c).WaferStart_Quarter4__c).setScale(2);
                pspProdRevperYear.yearNo = pspdata.Year__c;
                
                lstPSPProdRevRecords.add(pspProdRevperYear);
            }                
        }
      
    }
    
    //Function that will calculate the totals for WaferStart and WaferOut as per the DPMLs and values filled in different phases.
    public pageReference SaveCustom(){
        try{
            if(deviceRecord.Production_DPML__c < deviceRecord.Proto_DPML__c ){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Please fill correct DPMLs.'));
                return null;
            }
            
            Map<Decimal,DevicePSPData__c> mapYearWaferProd = new Map<Decimal,DevicePSPData__c>();
            for(DevicePSPData__c pspRecWaferProd : lstPSPprodRecords){
                mapYearWaferProd.put(pspRecWaferProd.Year__c,pspRecWaferProd);
            }
            
            Map<Decimal,DevicePSPData__c> mapYearWaferStart = new Map<Decimal,DevicePSPData__c>();
            for(DevicePSPData__c pspRecWaferStart : lstPSPwaferStartTotalRecords){
                mapYearWaferStart.put(pspRecWaferStart.Year__c,pspRecWaferStart);
            }
            
            Map<Decimal,DevicePSPData__c> mapYearWaferOut = new Map<Decimal,DevicePSPData__c>();
            for(DevicePSPData__c pspRecWaferOut : lstPSPwaferOutTotalRecords){
                mapYearWaferOut.put(pspRecWaferOut.Year__c,pspRecWaferOut);
            }
            
            List<DevicePSPData__c> lstPSPrecordsProPreProd = new List<DevicePSPData__c>();
            lstPSPrecordsProPreProd.addAll(lstPSPproductTORecords);
            lstPSPrecordsProPreProd.addAll(lstPSPsampleDelRecords);
            lstPSPrecordsProPreProd.addAll(lstPSPprotoRecords);
            lstPSPrecordsProPreProd.addAll(lstPSPpreProdRecords);
                        
            lstPSPrecordsProPreProd.addAll(mapYearWaferProd.values());
            
            lstPSPwaferStartTotalRecords.clear();
                        
            //Prepare a final list to insert/update to the database.
            List<DevicePSPData__c> finalListPSPData = new List<DevicePSPData__c>();
            
           
            finalListPSPData.addAll(lstPSPwaferStartTotalRecords);
            finalListPSPData.addAll(lstPSPwaferOutTotalRecords);
            
            
            
            database.upsert(devicerecord);
            database.upsert(finalListPSPData);
            
            //make a query call to get the latest values of formula fields for Totals.
            callRecords();
            calculateoppWaferOut();
            devicerecord.TOR_Automatic__c = torTotal;
            database.upsert(devicerecord);
        }catch(Exception e){
            PSP_createExtension.exceptionHandleMethod(PSP_createExtensionQuarterly.class.getName(),'SaveCustom()',String.ValueOf(deviceRecord.Id),'Error Message='+e.getMessage()+' At Line Number='+e.getLineNumber()+' Stack Trace='+e.getStackTraceString(),e.getTypeName(),e.getCause());
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Following Exception Occured:'+e.getMessage()));
        }
        return null;
    }
    
    //Function to check the NULL value
    decimal NullCheck(decimal dec){
        if(dec == NULL){
            return 0; // Return 0(Zero) if the element is NULL
        }else{
            return dec; //Return the original value if element is NOT NULL
        }
    }
    
    //Function to redirect the page to Export Page which will export the details in Excel sheet.
    public pageReference ExportDevicePSP(){
        Boolean isQuarterlyview = true;
        PageReference pageRef = new PageReference('/apex/PSP_createQuarterlyExport?id='+deviceRecord.id);
        return pageRef;
    }
    
    //Function to add a new year for PSP
    public pageReference addNewYear(){
    
        //get Picklist values of Phases:
        List<String> lstPickvals=new List<String>();
        
        Schema.SObjectType targetType = Schema.getGlobalDescribe().get('DevicePSPData__c');
        Sobject Object_name = targetType.newSObject();
        Schema.sObjectType sobject_type = Object_name.getSObjectType(); //grab the sobject that was passed
        Schema.DescribeSObjectResult sobject_describe = sobject_type.getDescribe(); //describe the sobject
        Map<String, Schema.SObjectField> field_map = sobject_describe.fields.getMap(); //get a map of fields for the passed sobject
        List<Schema.PicklistEntry> pick_list_values = field_map.get('Phase__c').getDescribe().getPickListValues(); //grab the list of picklist values for the passed field on the sobject
        for (Schema.PicklistEntry a : pick_list_values) { 
            lstPickvals.add(a.getValue());
        }
        
        List<DevicePSPData__c> lstPSPRecords = new List<DevicePSPData__c>();
        
        try{
            Integer yearToInsert = 0;
            AggregateResult[] lstAggrReslt = [select max(Year__c) from DevicePSPData__c where Device__c = :deviceRecord.id];
            
            if(!lstAggrReslt.isEmpty() && lstAggrReslt[0].get('expr0') != null){
                yearToInsert = integer.valueOf(lstAggrReslt[0].get('expr0'))+1;
            } else {
                yearToInsert = dev.Product_TO_Date__c != null ? dev.Product_TO_Date__c.Year() : System.Today().year();
            }
            if(yearToInsert != 0){                
                for(String phaseVal:lstPickvals){
                    DevicePSPData__c pspRecord = new DevicePSPData__c();
                    pspRecord.Device__c = devicerecord.id;
                    pspRecord.Phase__c  = phaseVal;
                    pspRecord.Year__c   = yearToInsert;
                    if(phaseVal == 'Prototype Wafer Start'){
                        pspRecord.Phase_Number__c = 1;
                    }else if(phaseVal == 'Prototype Wafer Out'){
                        pspRecord.Phase_Number__c = 2;
                    }else if(phaseVal == 'Prototype Wafer ASP'){
                        pspRecord.Phase_Number__c = 3;
                    }else if(phaseVal == 'Production Wafer Start'){
                        pspRecord.Phase_Number__c = 4;
                    }else if(phaseVal == 'Production Wafer Out'){
                        pspRecord.Phase_Number__c = 5;
                    }else if(phaseVal == 'Production Wafer ASP'){
                        pspRecord.Phase_Number__c = 6;
                    }
                    
                    pspRecord.Month_1__c = 0;
                    pspRecord.Month_2__c = 0;
                    pspRecord.Month_3__c = 0;
                    pspRecord.Month_4__c = 0;
                    pspRecord.Month_5__c = 0;
                    pspRecord.Month_6__c = 0;
                    pspRecord.Month_7__c = 0;
                    pspRecord.Month_7__c = 0;
                    pspRecord.Month_8__c = 0;
                    pspRecord.Month_9__c = 0;
                    pspRecord.Month_10__c = 0;
                    pspRecord.Month_11__c = 0;
                    pspRecord.Month_12__c = 0;
                    pspRecord.Quarter1__c = 0;
                    pspRecord.Quarter2__c = 0;
                    pspRecord.Quarter3__c = 0;
                    pspRecord.Quarter4__c = 0;
                    
                    lstPSPRecords.add(pspRecord);
                }
                database.insert(lstPSPRecords);
                
                PageReference pageRef = new PageReference('/apex/PSP_createQuarterly?id='+deviceRecord.id);
                pageRef.setRedirect(true);    
                return pageRef;
            }
        }catch(Exception e){
            PSP_createExtension.exceptionHandleMethod(PSP_createExtensionQuarterly.class.getName(),'addNewYear()',String.ValueOf(deviceRecord.Id),'Error Message='+e.getMessage()+' At Line Number='+e.getLineNumber()+' Stack Trace='+e.getStackTraceString(),e.getTypeName(),e.getCause());
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Following error has occured:'+e.getMessage()));
        }        
        return null;
    }
    
    //Function to remove additional year for PSP
    public pageReference removeYear(){
    
        try{
            Integer yearToDelete;
            AggregateResult[] lstAggrReslt = [select max(Year__c) from DevicePSPData__c where Device__c = :deviceRecord.id];
            if(!lstAggrReslt.isEmpty()){
                yearToDelete = integer.valueOf(lstAggrReslt[0].get('expr0'));                
                
                
                if(yearToDelete > (deviceRecord.Forecasted_Production_Start_Date__c!=null ? deviceRecord.Forecasted_Production_Start_Date__c.year() : deviceRecord.Production_Wafer_Start_Current__c.year())){
                    database.delete([select id from DevicePSPData__c where Device__c = :deviceRecord.id and Year__c =:yearToDelete]);
                
                    PageReference pageRef = new PageReference('/apex/PSP_createQuarterly?id='+deviceRecord.id);
                    pageRef.setRedirect(true);    
                    return pageRef;
                }else{
                     ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,'No additional year added which can be removed.'));
                }
                
            }
        }catch(Exception e){
            PSP_createExtension.exceptionHandleMethod(PSP_createExtensionQuarterly.class.getName(),'removeYear()',String.ValueOf(deviceRecord.Id),'Error Message='+e.getMessage()+' At Line Number='+e.getLineNumber()+' Stack Trace='+e.getStackTraceString(),e.getTypeName(),e.getCause());
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Following error has occured:'+e.getMessage()));
        }        
        return null;
    }
        
    //Function to fetch the Opportyunity Wafer Out
    public pageReference calculateoppWaferOut(){
        try{
            lstOppWaferOuts  = new List<calculateWaferOuts>();
            lstOppWaferASPs = new List<calculateWaferOuts>();
            List<Decimal> yearList = new List<Decimal>();
            for(DevicePSPData__c pspRecWaferRev : lstPSPprototypeWaferStarts){
                yearList.add(pspRecWaferRev.Year__c);
            }
            
            List<Quarterly_Revenue_Object__c> lstQuarterRev = new List<Quarterly_Revenue_Object__c>();        
            lstQuarterRev = [SELECT Id,Fiscal_Quarter__c,Volume__c,Opportunity__r.Production_Confidence__c,Date__c,ASP__c,Turnkey_ASP__c
                             FROM Quarterly_Revenue_Object__c WHERE Opportunity__c = :deviceRecord.Opportunity_ID__c ORDER BY Date__c ASC];
                                
            Decimal YearVal;
            for(Decimal year : yearList){
                calculateWaferOuts oppWaferOutperYear = new calculateWaferOuts();
                calculateWaferOuts oppWaferASPperYear = new calculateWaferOuts();
                for(Quarterly_Revenue_Object__c qr: lstQuarterRev){
                    YearVal  = Decimal.valueOf(qr.Date__c.year()); 
                    
                    if(YearVal == year && qr.Fiscal_Quarter__c != NULL){
                        oppWaferOutperYear.yearNo = year;
                        oppWaferASPperYear.yearNo = year;
                        if(qr.Fiscal_Quarter__c.contains('Q1')){
                            oppWaferOutperYear.quarter1 = (qr.Volume__c).setScale(2);
                            oppWaferASPperYear.quarter1 = qr.ASP__c;
                        }else if(qr.Fiscal_Quarter__c.contains('Q2')){
                            oppWaferOutperYear.quarter2 = (qr.Volume__c).setScale(2);
                            oppWaferASPperYear.quarter2 = qr.ASP__c;
                        }else if(qr.Fiscal_Quarter__c.contains('Q3')){
                            oppWaferOutperYear.quarter3 = (qr.Volume__c).setScale(2);
                            oppWaferASPperYear.quarter3 = qr.ASP__c;
                        }else if(qr.Fiscal_Quarter__c.contains('Q4')){
                            oppWaferOutperYear.quarter4 = (qr.Volume__c).setScale(2);
                            oppWaferASPperYear.quarter4 = qr.ASP__c;
                        }
                    }
                }
                lstOppWaferOuts.add(oppWaferOutperYear);
                lstOppWaferASPs.add(oppWaferASPperYear);
            }
            
            Integer count = 0;
            torTotal = 0;
            Map<String,Decimal> mapOppASP = new Map<String,Decimal>();
            Map<String,Decimal> mapYearWaferOutforMarket = new Map<String,Decimal>();
            
            for(Quarterly_Revenue_Object__c qtrev : lstQuarterRev){
                mapOppASP.put(qtrev.Fiscal_Quarter__c,qtrev.ASP__c);
            }
            
            if(mapYearWaferOut3 != null && mapYearWaferOut3.size() > 0){
                for(Decimal year : mapYearWaferOut3.keySet()){
                    mapYearWaferOutforMarket.put(String.valueOf(year)+'-Q1',mapYearWaferOut3.get(year).WaferStart_Quarter1__c);
                    mapYearWaferOutforMarket.put(String.valueOf(year)+'-Q2',mapYearWaferOut3.get(year).WaferStart_Quarter2__c);
                    mapYearWaferOutforMarket.put(String.valueOf(year)+'-Q3',mapYearWaferOut3.get(year).WaferStart_Quarter3__c);
                    mapYearWaferOutforMarket.put(String.valueOf(year)+'-Q4',mapYearWaferOut3.get(year).WaferStart_Quarter4__c);
                }
            }        
            
            List<String> quarterList = new List<String>{'-Q1','-Q2','-Q3','-Q4'};
            mapOppASP = PSP_createExtension.findWholevals(yearList,quarterList,mapOppASP);
            mapYearWaferOutforMarket = PSP_createExtension.findWholevals(yearList,quarterList,mapYearWaferOutforMarket);
            
            Map<string,MargetSegmentDevice__c> MarketSegmentValuemap = new map <string,MargetSegmentDevice__c>();
            MarketSegmentValuemap = MargetSegmentDevice__c.getall();
            for(Decimal year : yearList){
                for(String quart : quarterList){
                    if(MarketSegmentValuemap.containskey(dev.Market_Segment__c) && count < MarketSegmentValuemap.get(dev.Market_Segment__c).value__c * 4){
                        String keyVal = String.valueOf(year) + quart;
                        if(mapOppASP.containsKey(keyVal) && mapYearWaferOutforMarket.containsKey(keyVal)){
                            torTotal += mapOppASP.get(keyVal) * mapYearWaferOutforMarket.get(keyVal);
                            count++;
                        }
                    }
                }
            }
        } catch (Exception e) {
            PSP_createExtension.exceptionHandleMethod(PSP_createExtensionQuarterly.class.getName(),'calculateoppWaferOut()',String.ValueOf(deviceRecord.Id),'Error Message='+e.getMessage()+' At Line Number='+e.getLineNumber()+' Stack Trace='+e.getStackTraceString(),e.getTypeName(),e.getCause());
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, 'Error'));
            return null;
        }
        return NULL;
    }
        
    public PageReference MonthlyView() {
        try {   
            PageReference newocp = new PageReference('/apex/PSP_create?id='+deviceRecord.id);   //<----- changed here
            newocp.setRedirect(true);
            return newocp;
        } catch (Exception e) {
            PSP_createExtension.exceptionHandleMethod(PSP_createExtensionQuarterly.class.getName(),'MonthlyView()',String.ValueOf(deviceRecord.Id),'Error Message='+e.getMessage()+' At Line Number='+e.getLineNumber()+' Stack Trace='+e.getStackTraceString(),e.getTypeName(),e.getCause());
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, 'Error'));
            return null;
        }
    }
      
    //DBiswal 05162016
    public class calculateWaferOuts{
        public decimal quarter1{get;set;}
        public decimal quarter2{get;set;}
        public decimal quarter3{get;set;}
        public decimal quarter4{get;set;}
        public decimal yearNo{get;set;}
    }
}