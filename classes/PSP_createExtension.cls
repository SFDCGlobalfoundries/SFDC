/*
    Type Name: PSP_createExtension
    Author: Deepti Narayan Biswal 
    Created Date: 04222014
    Description: This class serves controller for PSP_Create page.
    Test Class: PSP_createExtensionTest
    Change History:
    04262017	DBiswal     for PSP TOR calculation by Market segment(line no. 1163-1223)
	03052018	DBiswal		for Copy issue in PSP volumes.(line no. 719,1350 are commented)
*/
public with sharing class PSP_createExtension{
    
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
    public List<calculateTotals> lstPSPwaferQTRTTLCost{get;set;}
    public List<calculateTotals> lstPSPturnkeyQTRTTLCost{get;set;}
    public List<calculateTotals> lstPSPTurnkeyRev{get;set;}
    
    //DBiswal   05152016
    public List<DevicePSPData__c> lstPSPprototypeWaferStarts {get;set;}
    public List<DevicePSPData__c> lstPSPproductionWaferStarts {get;set;}
    public List<DevicePSPData__c> lstprototypeWaferOuts {get;set;}
    public List<DevicePSPData__c> lstproductionWaferOuts {get;set;}
    public List<calculateWaferOuts> lstOppWaferOuts {get;set;}
    public List<calculateWaferOuts> lstOppWaferASPs {get;set;}
    public Decimal torTotal {get;set;}
    
    public boolean overrideWaferOut{get;set;}
    public boolean showWaferOut{get;set;}
    public boolean showTable{get;set;}
    public boolean editAccess{get;set;}
    public boolean editASPAccess{get;set;}
    public List<DevicePSPData__c> lstPSPrecords;
    public boolean isQuarterlyview{get;set;}
    public boolean isPreview = false;
    public boolean previewFlag{get;set;}
    public String delType {get;set;}
    public Device__c dev = new Device__c();
    public Boolean isASICFlag {get;set;}
    
    public String xlsHeader {
        get {
            String strHeader = '';
            strHeader += '<?xml version="1.0"?>';
            strHeader += '<?mso-application progid="Excel.Sheet"?>';
            return strHeader;
        }
    }
        
    //Constructor for Standard Controller
    public PSP_createExtension(ApexPages.StandardController controller) {
        if(!Test.isRunningTest()){
            controller.addFields(new List<String>{'PSP_Volume_Percentage__c','PSP_Slide_Schedule_to__c','PSP_Slide_Schedule_by_Months__c','Deliverable_Type__c'});
        }
        //initializing variables and lists
        this.devicerecord = (Device__c)controller.getRecord();
        lstPSPrecords = new List<DevicePSPData__c>();
        lstYears = new List<Integer>();
        showWaferOut = true;
        overrideWaferOut = false;
        showTable = true;
        isValidProfile = false;
        isQuarterlyview = false;
        torTotal = 0;
        previewFlag = false;
        
        //Get DPML values from table
        dev = [SELECT Id,Fab__c,Market_Segment__c, Product_TO_Date__c,Product_Indicator__c,Geometry__c,Proto_DPML__c,Production_DPML__c,TOR_Automatic__c,Deliverable_Type__c FROM Device__c WHERE Id =: devicerecord.Id];
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
            Set<Id> editProfileset = new Set<Id>();
            Set<String> profSet = new Set<String>();
            profSet.addAll(System.label.PSP_Volume_Profiles.split(','));
            for(Profile p : [select Id from Profile where Name IN: profSet]){
                editProfileset.add(p.Id);
            }
            //Opening the PSP edit access explicitly for CSR users
            //editAccess = [SELECT RecordId,HasEditAccess  FROM UserRecordAccess WHERE UserId=:UserInfo.getUserId() AND RecordId =:deviceRecord.Id].HasEditAccess || UserInfo.getProfileId() == CSRprofileId;
            editAccess = [SELECT RecordId,HasEditAccess  FROM UserRecordAccess WHERE UserId=:UserInfo.getUserId() AND RecordId =:deviceRecord.Id].HasEditAccess;
            if(editProfileset.contains(UserInfo.getProfileId())){
                editASPAccess = [SELECT RecordId,HasEditAccess  FROM UserRecordAccess WHERE UserId=:UserInfo.getUserId() AND RecordId =:deviceRecord.Id].HasEditAccess;
            } else {
                editASPAccess = false;
            }
            if((deviceRecord.Proto_Wafer_Fab_Shipped_Current__c == NULL || deviceRecord.Assembled_Tested_Part_Shipped_Current__c == NULL || deviceRecord.Production_Wafer_Start_Current__c == NULL ||
               deviceRecord.Proto_Wafer_First_Lot_Start_Current__c == NULL) && dev.Product_Indicator__c != 'ASIC'){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Please fill the PSP section for Dates.Please Refresh the page again.'));
                showTable = false;
            }else{
                //get the record details from the database
                callRecords();            
                calculateoppWaferOut();
                //Displaying message when DPML and Mask Layer field is empty for WAFER OUT calculations
                if(deviceRecord.Proto_DPML__c == NULL || deviceRecord.No_of_Mask_Layers__c == NULL || 
                   deviceRecord.Production_DPML__c == NULL){
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Please fill DPMLs and Mask Layer fields for WaferOut calculations.'));
                    showWaferOut = false;
                }
            }
            
        }catch(Exception e){
            PSP_createExtension.exceptionHandleMethod(PSP_createExtension.class.getName(),'Constructor for class',String.ValueOf(deviceRecord.Id),'Error Message='+e.getMessage()+' At Line Number='+e.getLineNumber()+' Stack Trace='+e.getStackTraceString(),e.getTypeName(),e.getCause());
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Following Exception Occurred:'+e.getMessage()));       
        }
    }
    
    //DBiswal - for PSP_createExport page
    public void setQuarterlyvalue(){
        if(ApexPages.currentPage().getParameters().get('isQuarterlyview') == 'true'){
            isQuarterlyview = true;
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
        
        dev = [SELECT Id,Deliverable_Type__c,Market_Segment__c,Product_TO_Date__c FROM Device__c WHERE Id =: deviceRecord.Id];
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
        
        lstPSPProtoASPRecords = new List<DevicePSPData__c>();
        lstPSPProtoRevRecords = new List<calculateWaferOuts>();
        lstPSPProdASPRecords = new List<DevicePSPData__c>();
        lstPSPProdRevRecords = new List<calculateWaferOuts>();
        lstPSPwaferQTRTTLCost = new List<calculateTotals>();
        lstPSPturnkeyQTRTTLCost = new List<calculateTotals>();
        lstPSPTurnkeyRev = new List<calculateTotals>();
        
        //DBiswal   05152016
        lstPSPprototypeWaferStarts = new List<DevicePSPData__c>();
        lstPSPproductionWaferStarts = new List<DevicePSPData__c>();
        lstprototypeWaferOuts = new List<DevicePSPData__c>();
        lstproductionWaferOuts  = new List<DevicePSPData__c>();
        lstOppWaferOuts  = new List<calculateWaferOuts>();
        lstOppWaferASPs = new List<calculateWaferOuts>();
        
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
                pspProtoRevperYear.month1 = (pspdata.Month_1__c * mapProtoWaferOutCal.get(pspdata.Year__c).Month_1__c).setScale(2);
                pspProtoRevperYear.month2 = (pspdata.Month_2__c * mapProtoWaferOutCal.get(pspdata.Year__c).Month_2__c).setScale(2);
                pspProtoRevperYear.month3 = (pspdata.Month_3__c * mapProtoWaferOutCal.get(pspdata.Year__c).Month_3__c).setScale(2);
                pspProtoRevperYear.month4 = (pspdata.Month_4__c * mapProtoWaferOutCal.get(pspdata.Year__c).Month_4__c).setScale(2);
                pspProtoRevperYear.month5 = (pspdata.Month_5__c * mapProtoWaferOutCal.get(pspdata.Year__c).Month_5__c).setScale(2);
                pspProtoRevperYear.month6 = (pspdata.Month_6__c * mapProtoWaferOutCal.get(pspdata.Year__c).Month_6__c).setScale(2);
                pspProtoRevperYear.month7 = (pspdata.Month_7__c * mapProtoWaferOutCal.get(pspdata.Year__c).Month_7__c).setScale(2);
                pspProtoRevperYear.month8 = (pspdata.Month_8__c * mapProtoWaferOutCal.get(pspdata.Year__c).Month_8__c).setScale(2);
                pspProtoRevperYear.month9 = (pspdata.Month_9__c * mapProtoWaferOutCal.get(pspdata.Year__c).Month_9__c).setScale(2);
                pspProtoRevperYear.month10 = (pspdata.Month_10__c * mapProtoWaferOutCal.get(pspdata.Year__c).Month_10__c).setScale(2);
                pspProtoRevperYear.month11 = (pspdata.Month_11__c * mapProtoWaferOutCal.get(pspdata.Year__c).Month_11__c).setScale(2);
                pspProtoRevperYear.month12 = (pspdata.Month_12__c * mapProtoWaferOutCal.get(pspdata.Year__c).Month_12__c).setScale(2);
                pspProtoRevperYear.quarter1 = (pspProtoRevperYear.month1 + pspProtoRevperYear.month2 + pspProtoRevperYear.month3).setScale(2);
                pspProtoRevperYear.quarter2 = (pspProtoRevperYear.month4 + pspProtoRevperYear.month5 + pspProtoRevperYear.month6).setScale(2);
                pspProtoRevperYear.quarter3 = (pspProtoRevperYear.month7 + pspProtoRevperYear.month8 + pspProtoRevperYear.month9).setScale(2);
                pspProtoRevperYear.quarter4 = (pspProtoRevperYear.month10 + pspProtoRevperYear.month11 + pspProtoRevperYear.month12).setScale(2);
                pspProtoRevperYear.yearNo = pspdata.Year__c;
                
                lstPSPProtoRevRecords.add(pspProtoRevperYear);
            }                
        }
        
        for(DevicePSPData__c pspdata : lstPSPProdASPRecords){
            if(mapYearWaferOut3.containsKey(pspdata.Year__c)){
                calculateWaferOuts pspProdRevperYear = new calculateWaferOuts();
                pspProdRevperYear.month1 = (pspdata.Month_1__c * mapYearWaferOut3.get(pspdata.Year__c).Month_1__c).setScale(2);
                pspProdRevperYear.month2 = (pspdata.Month_2__c * mapYearWaferOut3.get(pspdata.Year__c).Month_2__c).setScale(2);
                pspProdRevperYear.month3 = (pspdata.Month_3__c * mapYearWaferOut3.get(pspdata.Year__c).Month_3__c).setScale(2);
                pspProdRevperYear.month4 = (pspdata.Month_4__c * mapYearWaferOut3.get(pspdata.Year__c).Month_4__c).setScale(2);
                pspProdRevperYear.month5 = (pspdata.Month_5__c * mapYearWaferOut3.get(pspdata.Year__c).Month_5__c).setScale(2);
                pspProdRevperYear.month6 = (pspdata.Month_6__c * mapYearWaferOut3.get(pspdata.Year__c).Month_6__c).setScale(2);
                pspProdRevperYear.month7 = (pspdata.Month_7__c * mapYearWaferOut3.get(pspdata.Year__c).Month_7__c).setScale(2);
                pspProdRevperYear.month8 = (pspdata.Month_8__c * mapYearWaferOut3.get(pspdata.Year__c).Month_8__c).setScale(2);
                pspProdRevperYear.month9 = (pspdata.Month_9__c * mapYearWaferOut3.get(pspdata.Year__c).Month_9__c).setScale(2);
                pspProdRevperYear.month10 = (pspdata.Month_10__c * mapYearWaferOut3.get(pspdata.Year__c).Month_10__c).setScale(2);
                pspProdRevperYear.month11 = (pspdata.Month_11__c * mapYearWaferOut3.get(pspdata.Year__c).Month_11__c).setScale(2);
                pspProdRevperYear.month12 = (pspdata.Month_12__c * mapYearWaferOut3.get(pspdata.Year__c).Month_12__c).setScale(2);
                pspProdRevperYear.quarter1 = (pspProdRevperYear.month1 + pspProdRevperYear.month2 + pspProdRevperYear.month3).setScale(2);
                pspProdRevperYear.quarter2 = (pspProdRevperYear.month4 + pspProdRevperYear.month5 + pspProdRevperYear.month6).setScale(2);
                pspProdRevperYear.quarter3 = (pspProdRevperYear.month7 + pspProdRevperYear.month8 + pspProdRevperYear.month9).setScale(2);
                pspProdRevperYear.quarter4 = (pspProdRevperYear.month10 + pspProdRevperYear.month11 + pspProdRevperYear.month12).setScale(2);
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
            Decimal protoProcess = 0;
            Decimal prodProcess = 0;
            if(isASICFlag){
                if((deviceRecord.Post_Wafer_Processing_Proto__c == NULL || deviceRecord.Post_Wafer_Processing_Prod__c == NULL) && 
                    (deviceRecord.Deliverable_Type__c == 'Chip' || deviceRecord.Deliverable_Type__c == 'Module')){
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'Post Wafer Processing(Proto) and Post Wafer Processing(Prod) are mandatory when Deliverable Type is "Chip" or "Module".'));
                    return null;    
                } else {
                    if(deviceRecord.Deliverable_Type__c == 'Chip' || deviceRecord.Deliverable_Type__c == 'Module'){
                        protoProcess = deviceRecord.Post_Wafer_Processing_Proto__c != NULL ? deviceRecord.Post_Wafer_Processing_Proto__c : 0;
                        prodProcess = deviceRecord.Post_Wafer_Processing_Prod__c != NULL ? deviceRecord.Post_Wafer_Processing_Prod__c : 0;
                    }
                }
            }
            
            Map<Decimal,DevicePSPData__c> mapYearWaferOut1 = new Map<Decimal,DevicePSPData__c>();
            for(DevicePSPData__c pspRecWaferOut : lstprototypeWaferOuts){
                mapYearWaferOut1.put(pspRecWaferOut.Year__c,pspRecWaferOut);
            }
            Map<Decimal,DevicePSPData__c> mapYearWaferOut2 = new Map<Decimal,DevicePSPData__c>();
            for(DevicePSPData__c pspRecWaferOut : lstproductionWaferOuts){
                mapYearWaferOut2.put(pspRecWaferOut.Year__c,pspRecWaferOut);
            }
            List<DevicePSPData__c> lstPSPRecords = new List<DevicePSPData__c>();            
            //Calculation for Wafer-Out Totals
            if(overrideWaferOut == false){
            
                lstprototypeWaferOuts.clear();
                lstproductionWaferOuts.clear();
                List<Decimal> lstWaferOut1 = new List<Decimal>();
                List<Decimal> lstWaferOut2 = new List<Decimal>();
                
                if(deviceRecord.Proto_DPML__c == NULL || deviceRecord.No_of_Mask_Layers__c ==NULL || 
                   deviceRecord.Production_DPML__c == NULL){
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Please fill DPMLs and Mask Layer fields.'));
                    showWaferOut = false;
                }else{
                    showWaferOut = true;
                    integer dpmlShiftProto = integer.valueOf((deviceRecord.Proto_DPML__c*deviceRecord.No_of_Mask_Layers__c/30).round());
                    
                    integer dpmlShiftProd = integer.valueOf((deviceRecord.Production_DPML__c*deviceRecord.No_of_Mask_Layers__c/30).round());
                    
                    for(DevicePSPData__c qtyWaferStart : lstPSPprototypeWaferStarts){
                        lstWaferOut1.add(qtyWaferStart.Month_1__c);
                        lstWaferOut1.add(qtyWaferStart.Month_2__c);
                        lstWaferOut1.add(qtyWaferStart.Month_3__c);
                        lstWaferOut1.add(qtyWaferStart.Month_4__c);
                        lstWaferOut1.add(qtyWaferStart.Month_5__c);
                        lstWaferOut1.add(qtyWaferStart.Month_6__c);
                        lstWaferOut1.add(qtyWaferStart.Month_7__c);
                        lstWaferOut1.add(qtyWaferStart.Month_8__c);
                        lstWaferOut1.add(qtyWaferStart.Month_9__c);
                        lstWaferOut1.add(qtyWaferStart.Month_10__c);
                        lstWaferOut1.add(qtyWaferStart.Month_11__c);
                        lstWaferOut1.add(qtyWaferStart.Month_12__c);
                    }
                    
                    for(DevicePSPData__c qtyWaferStart : lstPSPproductionWaferStarts){
                        lstWaferOut2.add(qtyWaferStart.Month_1__c);
                        lstWaferOut2.add(qtyWaferStart.Month_2__c);
                        lstWaferOut2.add(qtyWaferStart.Month_3__c);
                        lstWaferOut2.add(qtyWaferStart.Month_4__c);
                        lstWaferOut2.add(qtyWaferStart.Month_5__c);
                        lstWaferOut2.add(qtyWaferStart.Month_6__c);
                        lstWaferOut2.add(qtyWaferStart.Month_7__c);
                        lstWaferOut2.add(qtyWaferStart.Month_8__c);
                        lstWaferOut2.add(qtyWaferStart.Month_9__c);
                        lstWaferOut2.add(qtyWaferStart.Month_10__c);
                        lstWaferOut2.add(qtyWaferStart.Month_11__c);
                        lstWaferOut2.add(qtyWaferStart.Month_12__c);
                    }
                    
                    if(dpmlShiftProd>0){
                        for(Integer i=1;i<=dpmlShiftProd;i++){
                            //lstWaferOut2.add(0,0);
                           lstWaferOut2.add(0);
                        }
                    }
                                        
                    if(dpmlShiftProto>0){
                        for(Integer i=1;i<=dpmlShiftProto;i++){
                            //lstWaferOut1.add(0,0);
                            lstWaferOut1.add(0);
                        }
                    }
                    
                    //calculation of Post Wafer Processing
                    if(isASICFlag){
                        if(protoProcess>30){
                            for(Integer i=1;i<=protoProcess/30;i++){
                                //lstWaferOut1.add(0,0); 
                                lstWaferOut1.add(0);                               
                            }
                        }
                        if(prodProcess>30){
                            for(Integer i=1;i<=prodProcess/30;i++){
                                //lstWaferOut2.add(0,0);
                                   lstWaferOut2.add(0);                                 
                            }
                        }
                    }
                    
                    integer monthStart1=0;
                    integer monthStart2=0;
                    integer monthStart11=0;
                    integer monthStart22=0;
                    
                    for(Integer yearNo:lstYears){                                                                        
                        DevicePSPData__c pspWaferOutTotalPerYear1 = new DevicePSPData__c(Device__c= deviceRecord.id,id=mapYearWaferOut1.get(yearNo).Id);
                        pspWaferOutTotalPerYear1.Month_1__c = lstWaferOut1[monthStart1];monthStart1++;
                        pspWaferOutTotalPerYear1.Month_2__c = lstWaferOut1[monthStart1];monthStart1++;
                        pspWaferOutTotalPerYear1.Month_3__c = lstWaferOut1[monthStart1];monthStart1++;
                        pspWaferOutTotalPerYear1.Month_4__c = lstWaferOut1[monthStart1];monthStart1++;
                        pspWaferOutTotalPerYear1.Month_5__c = lstWaferOut1[monthStart1];monthStart1++;
                        pspWaferOutTotalPerYear1.Month_6__c = lstWaferOut1[monthStart1];monthStart1++;
                        pspWaferOutTotalPerYear1.Month_7__c = lstWaferOut1[monthStart1];monthStart1++;
                        pspWaferOutTotalPerYear1.Month_8__c = lstWaferOut1[monthStart1];monthStart1++;
                        pspWaferOutTotalPerYear1.Month_9__c = lstWaferOut1[monthStart1];monthStart1++;
                        pspWaferOutTotalPerYear1.Month_10__c = lstWaferOut1[monthStart1];monthStart1++;
                        pspWaferOutTotalPerYear1.Month_11__c = lstWaferOut1[monthStart1];monthStart1++;
                        pspWaferOutTotalPerYear1.Month_12__c = lstWaferOut1[monthStart1];monthStart1++;
                        lstprototypeWaferOuts.add(pspWaferOutTotalPerYear1);
                        monthStart11=monthStart1;
                        
                        DevicePSPData__c pspWaferOutTotalPerYear2 = new DevicePSPData__c(Device__c= deviceRecord.id,id=mapYearWaferOut2.get(yearNo).Id);
                        pspWaferOutTotalPerYear2.Month_1__c = lstWaferOut2[monthStart2];monthStart2++;
                        pspWaferOutTotalPerYear2.Month_2__c = lstWaferOut2[monthStart2];monthStart2++;
                        pspWaferOutTotalPerYear2.Month_3__c = lstWaferOut2[monthStart2];monthStart2++;
                        pspWaferOutTotalPerYear2.Month_4__c = lstWaferOut2[monthStart2];monthStart2++;
                        pspWaferOutTotalPerYear2.Month_5__c = lstWaferOut2[monthStart2];monthStart2++;
                        pspWaferOutTotalPerYear2.Month_6__c = lstWaferOut2[monthStart2];monthStart2++;
                        pspWaferOutTotalPerYear2.Month_7__c = lstWaferOut2[monthStart2];monthStart2++;
                        pspWaferOutTotalPerYear2.Month_8__c = lstWaferOut2[monthStart2];monthStart2++;
                        pspWaferOutTotalPerYear2.Month_9__c = lstWaferOut2[monthStart2];monthStart2++;
                        pspWaferOutTotalPerYear2.Month_10__c = lstWaferOut2[monthStart2];monthStart2++;
                        pspWaferOutTotalPerYear2.Month_11__c = lstWaferOut2[monthStart2];monthStart2++;
                        pspWaferOutTotalPerYear2.Month_12__c = lstWaferOut2[monthStart2];monthStart2++;
                        lstproductionWaferOuts.add(pspWaferOutTotalPerYear2);
                        monthStart22 = monthStart2;
                    }
                    
                    Integer checkpoint = 0;
                    
                    if(monthStart11 < lstWaferOut1.size()){
                        for(Integer i=monthStart11;i<lstWaferOut1.size();i++){
                            if(lstWaferOut1[i] > 0){
                                checkpoint++;
                            }
                        }
                    }
                    if(monthStart22 < lstWaferOut2.size()){
                        for(Integer i=monthStart22;i<lstWaferOut2.size();i++){
                            if(lstWaferOut2[i] > 0){
                                checkpoint++;
                            }
                        }
                    }
                    
                    if((!Test.isRunningTest() && checkpoint > 0) || Test.isRunningTest()){
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
                        
                        Integer yearToInsert;
                        AggregateResult[] lstAggrReslt = [select max(Year__c) from DevicePSPData__c where Device__c = :deviceRecord.id];
                        if(!lstAggrReslt.isEmpty()){
                            yearToInsert = integer.valueOf(lstAggrReslt[0].get('expr0'))+1;
                            
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
                                
                                if(phaseVal == 'Prototype Wafer Start' || phaseVal == 'Production Wafer Start' || phaseVal == 'Prototype Wafer ASP' || phaseVal == 'Production Wafer ASP'){
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
                                } else if(phaseVal == 'Prototype Wafer Out') {
                                    pspRecord.Month_1__c = monthStart11<lstWaferOut1.size() ? lstWaferOut1[monthStart11] : 0;monthStart11++;
                                    pspRecord.Month_2__c = monthStart11<lstWaferOut1.size() ? lstWaferOut1[monthStart11] : 0;monthStart11++;
                                    pspRecord.Month_3__c = monthStart11<lstWaferOut1.size() ? lstWaferOut1[monthStart11] : 0;monthStart11++;
                                    pspRecord.Month_4__c = monthStart11<lstWaferOut1.size() ? lstWaferOut1[monthStart11] : 0;monthStart11++;
                                    pspRecord.Month_5__c = monthStart11<lstWaferOut1.size() ? lstWaferOut1[monthStart11] : 0;monthStart11++;
                                    pspRecord.Month_6__c = monthStart11<lstWaferOut1.size() ? lstWaferOut1[monthStart11] : 0;monthStart11++;
                                    pspRecord.Month_7__c = monthStart11<lstWaferOut1.size() ? lstWaferOut1[monthStart11] : 0;monthStart11++;
                                    pspRecord.Month_7__c = monthStart11<lstWaferOut1.size() ? lstWaferOut1[monthStart11] : 0;monthStart11++;
                                    pspRecord.Month_8__c = monthStart11<lstWaferOut1.size() ? lstWaferOut1[monthStart11] : 0;monthStart11++;
                                    pspRecord.Month_9__c = monthStart11<lstWaferOut1.size() ? lstWaferOut1[monthStart11] : 0;monthStart11++;
                                    pspRecord.Month_10__c = monthStart11<lstWaferOut1.size() ? lstWaferOut1[monthStart11] : 0;monthStart11++;
                                    pspRecord.Month_11__c = monthStart11<lstWaferOut1.size() ? lstWaferOut1[monthStart11] : 0;monthStart11++;
                                    pspRecord.Month_12__c = monthStart11<lstWaferOut1.size() ? lstWaferOut1[monthStart11] : 0;monthStart11++;
                                    pspRecord.Quarter1__c = 0;
                                    pspRecord.Quarter2__c = 0;
                                    pspRecord.Quarter3__c = 0;
                                    pspRecord.Quarter4__c = 0;
                                } else if(phaseVal == 'Production Wafer Out') {
                                    pspRecord.Month_1__c = monthStart22<lstWaferOut2.size() ? lstWaferOut2[monthStart22] : 0;monthStart22++;
                                    pspRecord.Month_2__c = monthStart22<lstWaferOut2.size() ? lstWaferOut2[monthStart22] : 0;monthStart22++;
                                    pspRecord.Month_3__c = monthStart22<lstWaferOut2.size() ? lstWaferOut2[monthStart22] : 0;monthStart22++;
                                    pspRecord.Month_4__c = monthStart22<lstWaferOut2.size() ? lstWaferOut2[monthStart22] : 0;monthStart22++;
                                    pspRecord.Month_5__c = monthStart22<lstWaferOut2.size() ? lstWaferOut2[monthStart22] : 0;monthStart22++;
                                    pspRecord.Month_6__c = monthStart22<lstWaferOut2.size() ? lstWaferOut2[monthStart22] : 0;monthStart22++;
                                    pspRecord.Month_7__c = monthStart22<lstWaferOut2.size() ? lstWaferOut2[monthStart22] : 0;monthStart22++;
                                    pspRecord.Month_7__c = monthStart22<lstWaferOut2.size() ? lstWaferOut2[monthStart22] : 0;monthStart22++;
                                    pspRecord.Month_8__c = monthStart22<lstWaferOut2.size() ? lstWaferOut2[monthStart22] : 0;monthStart22++;
                                    pspRecord.Month_9__c = monthStart22<lstWaferOut2.size() ? lstWaferOut2[monthStart22] : 0;monthStart22++;
                                    pspRecord.Month_10__c = monthStart22<lstWaferOut2.size() ? lstWaferOut2[monthStart22] : 0;monthStart22++;
                                    pspRecord.Month_11__c = monthStart22<lstWaferOut2.size() ? lstWaferOut2[monthStart22] : 0;monthStart22++;
                                    pspRecord.Month_12__c = monthStart22<lstWaferOut2.size() ? lstWaferOut2[monthStart22] : 0;monthStart22++;
                                    pspRecord.Quarter1__c = 0;
                                    pspRecord.Quarter2__c = 0;
                                    pspRecord.Quarter3__c = 0;
                                    pspRecord.Quarter4__c = 0;
                                }
                                lstPSPRecords.add(pspRecord);
                            }
                        }
                        
                    }
                }
            
            }
                                    
            //Prepare a final list to insert/update to the database.
            List<DevicePSPData__c> finalListPSPData = new List<DevicePSPData__c>();
            
            finalListPSPData.addAll(lstprototypeWaferOuts);
            finalListPSPData.addAll(lstproductionWaferOuts);
            finalListPSPData.addAll(lstPSPprototypeWaferStarts);
            finalListPSPData.addAll(lstPSPproductionWaferStarts);
            finalListPSPData.addAll(lstPSPRecords);
            
            finalListPSPData.addAll(lstPSPProtoASPRecords);
            finalListPSPData.addAll(lstPSPProdASPRecords);
            
            database.upsert(devicerecord);
            database.upsert(finalListPSPData);
            
            //make a query call to get the latest values of formula fields for Totals.
            callRecords();
            calculateoppWaferOut();
            devicerecord.TOR_Automatic__c = torTotal;
            system.debug('deepti '+torTotal+' $$ '+devicerecord.TOR_Automatic__c);
            database.upsert(devicerecord);
        }catch(Exception e){
            PSP_createExtension.exceptionHandleMethod(PSP_createExtension.class.getName(),'SaveCustom()',String.ValueOf(deviceRecord.Id),'Error Message='+e.getMessage()+' At Line Number='+e.getLineNumber()+' Stack Trace='+e.getStackTraceString(),e.getTypeName(),e.getCause());
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Following Exception Occured:'+e.getMessage()));
        }
        return null;
    }
    
    public pageReference SaveAfterWaferOutCopy(){
        try{
            if(deviceRecord.Production_DPML__c < deviceRecord.Proto_DPML__c ){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Please fill correct DPMLs.'));
                return null;
            }
            Map<Decimal,DevicePSPData__c> mapYearWaferOut2 = new Map<Decimal,DevicePSPData__c>();
            for(DevicePSPData__c pspRecWaferOut : lstPSPproductionWaferStarts){
                mapYearWaferOut2.put(pspRecWaferOut.Year__c,pspRecWaferOut);
            }
            List<DevicePSPData__c> lstPSPRecords = new List<DevicePSPData__c>();            
            //Calculation for Wafer-Out Totals
            if(overrideWaferOut == false){            
                List<Decimal> lstWaferOut1 = new List<Decimal>();
                List<Decimal> lstWaferOut2 = new List<Decimal>();
                List<Decimal> lstWaferOut3 = new List<Decimal>();
                for(DevicePSPData__c qtyWaferStart : lstproductionWaferOuts){
                    lstWaferOut3.add(qtyWaferStart.Month_1__c);
                    lstWaferOut3.add(qtyWaferStart.Month_2__c);
                    lstWaferOut3.add(qtyWaferStart.Month_3__c);
                    lstWaferOut3.add(qtyWaferStart.Month_4__c);
                    lstWaferOut3.add(qtyWaferStart.Month_5__c);
                    lstWaferOut3.add(qtyWaferStart.Month_6__c);
                    lstWaferOut3.add(qtyWaferStart.Month_7__c);
                    lstWaferOut3.add(qtyWaferStart.Month_8__c);
                    lstWaferOut3.add(qtyWaferStart.Month_9__c);
                    lstWaferOut3.add(qtyWaferStart.Month_10__c);
                    lstWaferOut3.add(qtyWaferStart.Month_11__c);
                    lstWaferOut3.add(qtyWaferStart.Month_12__c);
                }
                lstPSPproductionWaferStarts.clear();
                
                if(deviceRecord.Proto_DPML__c == NULL || deviceRecord.No_of_Mask_Layers__c ==NULL || 
                   deviceRecord.Production_DPML__c == NULL){
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Please fill DPMLs and Mask Layer fields.'));
                    showWaferOut = false;
                }else{
                    showWaferOut = true;
                    integer dpmlShiftProd = integer.valueOf((deviceRecord.Production_DPML__c*deviceRecord.No_of_Mask_Layers__c/30).round());
                    
                    //DBiswal - 09202016
                    List<DevicePSPData__c> prodWaferOutTempList = new List<DevicePSPData__c>();
                    Decimal volumePrcnt = deviceRecord.PSP_Volume_Percentage__c;
                    String slideDirn = deviceRecord.PSP_Slide_Schedule_to__c;
                    String slideMonth = deviceRecord.PSP_Slide_Schedule_by_Months__c;
                    if(volumePrcnt <= -1 || volumePrcnt > 100){
                        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Please provide any value from 0 to 100 for "Modify Row 4 to be a % of Row 5" value.'));
                    }
                    if((volumePrcnt != null && volumePrcnt > -1 && volumePrcnt <= 100) || (slideDirn != null && slideDirn != 'None') || (slideMonth != null && slideMonth != 'None')){
                        List<String> pspfieldNames = new List<String>();
                        pspfieldNames.addAll(Environment_Variable__c.getInstance('PSP_Create_SlidingFields').Value__c.split(','));
                        if((volumePrcnt != null && volumePrcnt > -1 && volumePrcnt <= 100)){
                            for(Integer psp=0; psp<lstproductionWaferOuts.size(); psp++){
                                if(volumePrcnt != null){
                                    lstproductionWaferOuts[psp].Month_1__c = lstproductionWaferOuts[psp].Month_1__c!=null ? Math.round((lstproductionWaferOuts[psp].Month_1__c*volumePrcnt)/100) : 0;
                                    lstproductionWaferOuts[psp].Month_2__c = lstproductionWaferOuts[psp].Month_2__c!=null ? Math.round((lstproductionWaferOuts[psp].Month_2__c*volumePrcnt)/100) : 0;
                                    lstproductionWaferOuts[psp].Month_3__c = lstproductionWaferOuts[psp].Month_3__c!=null ? Math.round((lstproductionWaferOuts[psp].Month_3__c*volumePrcnt)/100) : 0;
                                    lstproductionWaferOuts[psp].Month_4__c = lstproductionWaferOuts[psp].Month_4__c!=null ? Math.round((lstproductionWaferOuts[psp].Month_4__c*volumePrcnt)/100) : 0;
                                    lstproductionWaferOuts[psp].Month_5__c = lstproductionWaferOuts[psp].Month_5__c!=null ? Math.round((lstproductionWaferOuts[psp].Month_5__c*volumePrcnt)/100) : 0;
                                    lstproductionWaferOuts[psp].Month_6__c = lstproductionWaferOuts[psp].Month_6__c!=null ? Math.round((lstproductionWaferOuts[psp].Month_6__c*volumePrcnt)/100) : 0;
                                    lstproductionWaferOuts[psp].Month_7__c = lstproductionWaferOuts[psp].Month_7__c!=null ? Math.round((lstproductionWaferOuts[psp].Month_7__c*volumePrcnt)/100) : 0;
                                    lstproductionWaferOuts[psp].Month_8__c = lstproductionWaferOuts[psp].Month_8__c!=null ? Math.round((lstproductionWaferOuts[psp].Month_8__c*volumePrcnt)/100) : 0;
                                    lstproductionWaferOuts[psp].Month_9__c = lstproductionWaferOuts[psp].Month_9__c!=null ? Math.round((lstproductionWaferOuts[psp].Month_9__c*volumePrcnt)/100) : 0;
                                    lstproductionWaferOuts[psp].Month_10__c = lstproductionWaferOuts[psp].Month_10__c!=null ? Math.round((lstproductionWaferOuts[psp].Month_10__c*volumePrcnt)/100) : 0;
                                    lstproductionWaferOuts[psp].Month_11__c = lstproductionWaferOuts[psp].Month_11__c!=null ? Math.round((lstproductionWaferOuts[psp].Month_11__c*volumePrcnt)/100) : 0;
                                    lstproductionWaferOuts[psp].Month_12__c = lstproductionWaferOuts[psp].Month_12__c!=null ? Math.round((lstproductionWaferOuts[psp].Month_12__c*volumePrcnt)/100) : 0;
                                }
                            }
                            if(slideDirn == 'Left'){
                                for(Integer psp=0; psp<lstproductionWaferOuts.size(); psp++){
                                    Integer slideVar = Integer.valueOf(slideMonth);
                                    for(Integer i=0; i<pspfieldNames.size(); i++){
                                        if(i+slideVar < 12){
                                            lstproductionWaferOuts[psp].put(pspfieldNames[i], lstproductionWaferOuts[psp].get(pspfieldNames[i+slideVar]));
                                        } else{
                                            if(psp+1 < lstproductionWaferOuts.size()){
                                                lstproductionWaferOuts[psp].put(pspfieldNames[i], lstproductionWaferOuts[psp+1].get(pspfieldNames[(i+slideVar)-12]));
                                            } else {
                                                lstproductionWaferOuts[psp].put(pspfieldNames[i], 0);
                                            }
                                        }
                                    }
                                    prodWaferOutTempList.add(lstproductionWaferOuts[psp]);
                                }
                            }
                        }
                        if(slideDirn == 'Right'){
                            Integer slideVar = Integer.valueOf(slideMonth);
                            List<DevicePSPData__c> lstTempPSPRecords = new List<DevicePSPData__c>();
                            for(Integer i=pspfieldNames.size()-1; i>=0; i--){
                                Integer month = Integer.valueOf(pspfieldNames[i].substringBetween('_'));
                                if((month+slideVar) > 12 && (Decimal)lstproductionWaferOuts[lstproductionWaferOuts.size()-1].get(pspfieldNames[i]) > 0){
                                    lstTempPSPRecords.addAll(addNewYearwithoutInsert(lstproductionWaferOuts));
                                    break;
                                }
                            }
                            if(lstTempPSPRecords.size() > 0){
                                lstproductionWaferOuts.clear();
                                lstproductionWaferOuts.addAll(lstTempPSPRecords);
                            }
                            for(Integer psp=lstproductionWaferOuts.size()-1; psp>=0; psp--){
                                for(Integer j=pspfieldNames.size()-1; j>=0; j--){
                                    if(j >= slideVar){
                                        lstproductionWaferOuts[psp].put(pspfieldNames[j], lstproductionWaferOuts[psp].get(pspfieldNames[j-slideVar]));
                                    } else{
                                        if((psp-1) >= 0){
                                            lstproductionWaferOuts[psp].put(pspfieldNames[j], lstproductionWaferOuts[psp-1].get(pspfieldNames[(12+j)-slideVar]));
                                        } else {
                                            lstproductionWaferOuts[psp].put(pspfieldNames[j], 0);
                                        }
                                    }
                                }
                                if(prodWaferOutTempList.size() > 0){
                                    prodWaferOutTempList.add(0,lstproductionWaferOuts[psp]);
                                } else {
                                    prodWaferOutTempList.add(new DevicePSPData__c());
                                    prodWaferOutTempList.add(0,lstproductionWaferOuts[psp]);
                                    prodWaferOutTempList.remove(1);
                                }
                            }
                        }
                    }
                    if(prodWaferOutTempList.size()==0){
                        prodWaferOutTempList.addAll(lstproductionWaferOuts);
                    }                    
                    
                    for(DevicePSPData__c qtyWaferStart : prodWaferOutTempList){
                        lstWaferOut2.add(qtyWaferStart.Month_1__c);
                        lstWaferOut2.add(qtyWaferStart.Month_2__c);
                        lstWaferOut2.add(qtyWaferStart.Month_3__c);
                        lstWaferOut2.add(qtyWaferStart.Month_4__c);
                        lstWaferOut2.add(qtyWaferStart.Month_5__c);
                        lstWaferOut2.add(qtyWaferStart.Month_6__c);
                        lstWaferOut2.add(qtyWaferStart.Month_7__c);
                        lstWaferOut2.add(qtyWaferStart.Month_8__c);
                        lstWaferOut2.add(qtyWaferStart.Month_9__c);
                        lstWaferOut2.add(qtyWaferStart.Month_10__c);
                        lstWaferOut2.add(qtyWaferStart.Month_11__c);
                        lstWaferOut2.add(qtyWaferStart.Month_12__c);
                    }
                    
                    if(dpmlShiftProd>0){
                        for(Integer i=1;i<=dpmlShiftProd;i++){
                            //lstWaferOut2.remove(0);
                            lstWaferOut2.add(0);
                        }
                    }
                    
                    integer monthStart2=0;
                    
                    integer monthStart22=0;
                    for(Integer yearNo:lstYears){
                        
                        DevicePSPData__c pspWaferOutTotalPerYear2 = new DevicePSPData__c(Device__c= deviceRecord.id,id = isPreview ? null : mapYearWaferOut2.get(yearNo).Id);
                        pspWaferOutTotalPerYear2.Month_1__c = lstWaferOut2[monthStart2];monthStart2++;
                        pspWaferOutTotalPerYear2.Month_2__c = lstWaferOut2[monthStart2];monthStart2++;
                        pspWaferOutTotalPerYear2.Month_3__c = lstWaferOut2[monthStart2];monthStart2++;
                        pspWaferOutTotalPerYear2.Month_4__c = lstWaferOut2[monthStart2];monthStart2++;
                        pspWaferOutTotalPerYear2.Month_5__c = lstWaferOut2[monthStart2];monthStart2++;
                        pspWaferOutTotalPerYear2.Month_6__c = lstWaferOut2[monthStart2];monthStart2++;
                        pspWaferOutTotalPerYear2.Month_7__c = lstWaferOut2[monthStart2];monthStart2++;
                        pspWaferOutTotalPerYear2.Month_8__c = lstWaferOut2[monthStart2];monthStart2++;
                        pspWaferOutTotalPerYear2.Month_9__c = lstWaferOut2[monthStart2];monthStart2++;
                        pspWaferOutTotalPerYear2.Month_10__c = lstWaferOut2[monthStart2];monthStart2++;
                        pspWaferOutTotalPerYear2.Month_11__c = lstWaferOut2[monthStart2];monthStart2++;
                        pspWaferOutTotalPerYear2.Month_12__c = lstWaferOut2[monthStart2];monthStart2++;
                        lstPSPproductionWaferStarts.add(pspWaferOutTotalPerYear2);
                        monthStart22 = monthStart2;
                    }
                    
                    Integer checkpoint = 0;
                    
                    if(monthStart22 < lstWaferOut2.size()){
                        for(Integer i=monthStart22;i<lstWaferOut2.size();i++){
                            if(lstWaferOut2[i] > 0){
                                checkpoint++;
                            }
                        }
                    }
                    if(prodWaferOutTempList.size() > lstPSPproductionWaferStarts.size()){
                        checkpoint++;
                    }
                    
                    if((!Test.isRunningTest() && checkpoint > 0) || Test.isRunningTest()){
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
                        
                        Integer yearToInsert;
                        AggregateResult[] lstAggrReslt = [select max(Year__c) from DevicePSPData__c where Device__c = :deviceRecord.id];
                        if(!lstAggrReslt.isEmpty()){
                            yearToInsert = integer.valueOf(lstAggrReslt[0].get('expr0'))+1;
                            if(isPreview){lstYears.add(yearToInsert);}
                            
                            for(String phaseVal:lstPickvals){
                                if(phaseVal != 'Production Wafer Out' || (phaseVal == 'Production Wafer Out' && prodWaferOutTempList[prodWaferOutTempList.size()-1].Year__c < yearToInsert)){
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
                                    
                                    if(phaseVal == 'Prototype Wafer Start' || phaseVal == 'Prototype Wafer Out' || phaseVal == 'Prototype Wafer ASP' || phaseVal == 'Production Wafer ASP'){
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
                                    } else if(phaseVal == 'Production Wafer Start') {
                                        pspRecord.Month_1__c = monthStart22<lstWaferOut2.size() ? lstWaferOut2[monthStart22] : 0;monthStart22++;
                                        pspRecord.Month_2__c = monthStart22<lstWaferOut2.size() ? lstWaferOut2[monthStart22] : 0;monthStart22++;
                                        pspRecord.Month_3__c = monthStart22<lstWaferOut2.size() ? lstWaferOut2[monthStart22] : 0;monthStart22++;
                                        pspRecord.Month_4__c = monthStart22<lstWaferOut2.size() ? lstWaferOut2[monthStart22] : 0;monthStart22++;
                                        pspRecord.Month_5__c = monthStart22<lstWaferOut2.size() ? lstWaferOut2[monthStart22] : 0;monthStart22++;
                                        pspRecord.Month_6__c = monthStart22<lstWaferOut2.size() ? lstWaferOut2[monthStart22] : 0;monthStart22++;
                                        pspRecord.Month_7__c = monthStart22<lstWaferOut2.size() ? lstWaferOut2[monthStart22] : 0;monthStart22++;
                                        pspRecord.Month_7__c = monthStart22<lstWaferOut2.size() ? lstWaferOut2[monthStart22] : 0;monthStart22++;
                                        pspRecord.Month_8__c = monthStart22<lstWaferOut2.size() ? lstWaferOut2[monthStart22] : 0;monthStart22++;
                                        pspRecord.Month_9__c = monthStart22<lstWaferOut2.size() ? lstWaferOut2[monthStart22] : 0;monthStart22++;
                                        pspRecord.Month_10__c = monthStart22<lstWaferOut2.size() ? lstWaferOut2[monthStart22] : 0;monthStart22++;
                                        pspRecord.Month_11__c = monthStart22<lstWaferOut2.size() ? lstWaferOut2[monthStart22] : 0;monthStart22++;
                                        pspRecord.Month_12__c = monthStart22<lstWaferOut2.size() ? lstWaferOut2[monthStart22] : 0;monthStart22++;
                                        pspRecord.Quarter1__c = 0;
                                        pspRecord.Quarter2__c = 0;
                                        pspRecord.Quarter3__c = 0;
                                        pspRecord.Quarter4__c = 0;
                                    } else if(phaseVal == 'Production Wafer Out'){
                                        pspRecord.Month_1__c = prodWaferOutTempList.size()>lstPSPproductionWaferStarts.size() ? prodWaferOutTempList[lstPSPproductionWaferStarts.size()].Month_1__c : 0;
                                        pspRecord.Month_2__c = prodWaferOutTempList.size()>lstPSPproductionWaferStarts.size() ? prodWaferOutTempList[lstPSPproductionWaferStarts.size()].Month_2__c : 0;
                                        pspRecord.Month_3__c = prodWaferOutTempList.size()>lstPSPproductionWaferStarts.size() ? prodWaferOutTempList[lstPSPproductionWaferStarts.size()].Month_3__c : 0;
                                        pspRecord.Month_4__c = prodWaferOutTempList.size()>lstPSPproductionWaferStarts.size() ? prodWaferOutTempList[lstPSPproductionWaferStarts.size()].Month_4__c : 0;
                                        pspRecord.Month_5__c = prodWaferOutTempList.size()>lstPSPproductionWaferStarts.size() ? prodWaferOutTempList[lstPSPproductionWaferStarts.size()].Month_5__c : 0;
                                        pspRecord.Month_6__c = prodWaferOutTempList.size()>lstPSPproductionWaferStarts.size() ? prodWaferOutTempList[lstPSPproductionWaferStarts.size()].Month_6__c : 0;
                                        pspRecord.Month_7__c = prodWaferOutTempList.size()>lstPSPproductionWaferStarts.size() ? prodWaferOutTempList[lstPSPproductionWaferStarts.size()].Month_7__c : 0;
                                        pspRecord.Month_8__c = prodWaferOutTempList.size()>lstPSPproductionWaferStarts.size() ? prodWaferOutTempList[lstPSPproductionWaferStarts.size()].Month_8__c : 0;
                                        pspRecord.Month_9__c = prodWaferOutTempList.size()>lstPSPproductionWaferStarts.size() ? prodWaferOutTempList[lstPSPproductionWaferStarts.size()].Month_9__c : 0;
                                        pspRecord.Month_10__c = prodWaferOutTempList.size()>lstPSPproductionWaferStarts.size() ? prodWaferOutTempList[lstPSPproductionWaferStarts.size()].Month_10__c : 0;
                                        pspRecord.Month_11__c = prodWaferOutTempList.size()>lstPSPproductionWaferStarts.size() ? prodWaferOutTempList[lstPSPproductionWaferStarts.size()].Month_11__c : 0;
                                        pspRecord.Month_12__c = prodWaferOutTempList.size()>lstPSPproductionWaferStarts.size() ? prodWaferOutTempList[lstPSPproductionWaferStarts.size()].Month_12__c : 0;
                                        pspRecord.Quarter1__c = 0;
                                        pspRecord.Quarter2__c = 0;
                                        pspRecord.Quarter3__c = 0;
                                        pspRecord.Quarter4__c = 0;
                                    }
                                    if(!isPreview){
                                        lstPSPRecords.add(pspRecord);
                                    } else {
                                        if(phaseVal == 'Prototype Wafer Start'){
                                            lstPSPprototypeWaferStarts.add(pspRecord);
                                        }else if(phaseVal == 'Prototype Wafer Out'){
                                            lstprototypeWaferOuts.add(pspRecord);
                                        }else if(phaseVal == 'Prototype Wafer ASP'){
                                            lstPSPProtoASPRecords.add(pspRecord);
                                        }else if(phaseVal == 'Production Wafer Start'){
                                            lstPSPproductionWaferStarts.add(pspRecord);
                                        }else if(phaseVal == 'Production Wafer Out'){
                                            lstproductionWaferOuts.add(pspRecord);
                                        }else if(phaseVal == 'Production Wafer ASP'){
                                            lstPSPProdASPRecords.add(pspRecord);
                                        }
                                    }
                                }
                            }
                            //add Revenue values
                            calculateWaferOuts pspRevcal = new calculateWaferOuts();
                            pspRevcal.month1 = 0;
                            pspRevcal.month2 = 0;
                            pspRevcal.month3 = 0;
                            pspRevcal.month4 = 0;
                            pspRevcal.month5 = 0;
                            pspRevcal.month6 = 0;
                            pspRevcal.month7 = 0;
                            pspRevcal.month8 = 0;
                            pspRevcal.month9 = 0;
                            pspRevcal.month10 = 0;
                            pspRevcal.month11 = 0;
                            pspRevcal.month12 = 0;
                            pspRevcal.quarter1 = 0;
                            pspRevcal.quarter2 = 0;
                            pspRevcal.quarter3 = 0;
                            pspRevcal.quarter4 = 0;
                            pspRevcal.yearNo = yearToInsert ;
                            
                            lstPSPProtoRevRecords.add(pspRevcal);
                            lstPSPProdRevRecords.add(pspRevcal);
                        }                        
                    }
                }            
            }
                                    
            //Prepare a final list to insert/update to the database.
            List<DevicePSPData__c> finalListPSPData = new List<DevicePSPData__c>();
            
            finalListPSPData.addAll(lstproductionWaferOuts);
            finalListPSPData.addAll(lstPSPproductionWaferStarts);
            finalListPSPData.addAll(lstPSPRecords);
            if(!isPreview){
                database.upsert(devicerecord);
                database.upsert(finalListPSPData);
                
                //make a query call to get the latest values of formula fields for Totals.
                callRecords();
                calculateoppWaferOut();
                devicerecord.TOR_Automatic__c = torTotal;
                devicerecord.PSP_Volume_Percentage__c = (devicerecord.PSP_Volume_Percentage__c > 0 && devicerecord.PSP_Volume_Percentage__c <= 100) ? devicerecord.PSP_Volume_Percentage__c : null;
                database.upsert(devicerecord);
            } else {
                calculateoppWaferOut();
            }
        }catch(Exception e){
            PSP_createExtension.exceptionHandleMethod(PSP_createExtension.class.getName(),'SaveAfterWaferOutCopy()',String.ValueOf(deviceRecord.Id),'Error Message='+e.getMessage()+' At Line Number='+e.getLineNumber()+' Stack Trace='+e.getStackTraceString(),e.getTypeName(),e.getCause());
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Following Exception Occured:'+e.getMessage()));
        }
        isPreview = false;
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
        PageReference pageRef = new PageReference('/apex/PSP_createExport?id='+deviceRecord.id);
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
                
                PageReference pageRef = new PageReference('/apex/PSP_create?id='+deviceRecord.id);
                pageRef.setRedirect(true);    
                return pageRef;
            }
        }catch(Exception e){
            PSP_createExtension.exceptionHandleMethod(PSP_createExtension.class.getName(),'addNewYear()',String.ValueOf(deviceRecord.Id),'Error Message='+e.getMessage()+' At Line Number='+e.getLineNumber()+' Stack Trace='+e.getStackTraceString(),e.getTypeName(),e.getCause());
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
                
                    PageReference pageRef = new PageReference('/apex/PSP_create?id='+deviceRecord.id);
                    pageRef.setRedirect(true);    
                    return pageRef;
                }else{
                     ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,'No additional year added which can be removed.'));
                }
                
            }
        }catch(Exception e){
            PSP_createExtension.exceptionHandleMethod(PSP_createExtension.class.getName(),'removeYear()',String.ValueOf(deviceRecord.Id),'Error Message='+e.getMessage()+' At Line Number='+e.getLineNumber()+' Stack Trace='+e.getStackTraceString(),e.getTypeName(),e.getCause());
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Following error has occured:'+e.getMessage()));
        }        
        return null;
    }
    
    //Function to add a new year without inserting for PSP
    public List<DevicePSPData__c> addNewYearwithoutInsert(List<DevicePSPData__c> prodWafOutList){
    
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
        lstPSPRecords.addAll(prodWafOutList);
        try{
            Integer yearToInsert;
            AggregateResult[] lstAggrReslt = [select max(Year__c) from DevicePSPData__c where Device__c = :deviceRecord.id];
            if(!lstAggrReslt.isEmpty()){
                yearToInsert = integer.valueOf(lstAggrReslt[0].get('expr0'))+1;
                
                for(String phaseVal:lstPickvals){
                    if(phaseVal == 'Production Wafer Out'){
                        DevicePSPData__c pspRecord = new DevicePSPData__c();
                        pspRecord.Device__c = devicerecord.id;
                        pspRecord.Phase__c  = phaseVal;
                        pspRecord.Year__c   = yearToInsert;
                        pspRecord.Phase_Number__c = 5;
                                            
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
                }
            }
        }catch(Exception e){
            PSP_createExtension.exceptionHandleMethod(PSP_createExtension.class.getName(),'addNewYearwithoutInsert()',String.ValueOf(deviceRecord.Id),'Error Message='+e.getMessage()+' At Line Number='+e.getLineNumber()+' Stack Trace='+e.getStackTraceString(),e.getTypeName(),e.getCause());
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Following error has occured:'+e.getMessage()));
        }        
        return lstPSPRecords;
    }
        
    //Function to fetch the Opportyunity Wafer Out
    public pageReference calculateoppWaferOut(){
        try{        
            lstOppWaferOuts  = new List<calculateWaferOuts>();
            lstOppWaferASPs = new List<calculateWaferOuts>();
            
            List<Decimal> yearList = new List<Decimal>();
            for(DevicePSPData__c pspRecWaferRev : lstproductionWaferOuts){
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
                            oppWaferOutperYear.month1 = (Math.floor(qr.Volume__c != 0 ? qr.Volume__c/3 : qr.Volume__c)).setScale(2);
                            oppWaferOutperYear.month2 = (Math.floor(qr.Volume__c != 0 ? qr.Volume__c/3 : qr.Volume__c)).setScale(2);
                            oppWaferOutperYear.month3 = (qr.Volume__c != 0 ? qr.Volume__c-(oppWaferOutperYear.month1+oppWaferOutperYear.month2) : qr.Volume__c).setScale(2);
                            oppWaferASPperYear.quarter1 = qr.ASP__c;
                        }else if(qr.Fiscal_Quarter__c.contains('Q2')){
                            oppWaferOutperYear.quarter2 = (qr.Volume__c).setScale(2);
                            oppWaferOutperYear.month4 = (Math.floor(qr.Volume__c != 0 ? qr.Volume__c/3 : qr.Volume__c)).setScale(2);
                            oppWaferOutperYear.month5 = (Math.floor(qr.Volume__c != 0 ? qr.Volume__c/3 : qr.Volume__c)).setScale(2);
                            oppWaferOutperYear.month6 = (qr.Volume__c != 0 ? qr.Volume__c-(oppWaferOutperYear.month4+oppWaferOutperYear.month5) : qr.Volume__c).setScale(2);
                            oppWaferASPperYear.quarter2 = qr.ASP__c;
                        }else if(qr.Fiscal_Quarter__c.contains('Q3')){
                            oppWaferOutperYear.quarter3 = (qr.Volume__c).setScale(2);
                            oppWaferOutperYear.month7 = (Math.floor(qr.Volume__c != 0 ? qr.Volume__c/3 : qr.Volume__c)).setScale(2);
                            oppWaferOutperYear.month8 = (Math.floor(qr.Volume__c != 0 ? qr.Volume__c/3 : qr.Volume__c)).setScale(2);
                            oppWaferOutperYear.month9 = (qr.Volume__c != 0 ? qr.Volume__c-(oppWaferOutperYear.month7+oppWaferOutperYear.month8) : qr.Volume__c).setScale(2);
                            oppWaferASPperYear.quarter3 = qr.ASP__c;
                        }else if(qr.Fiscal_Quarter__c.contains('Q4')){
                            oppWaferOutperYear.quarter4 = (qr.Volume__c).setScale(2);
                            oppWaferOutperYear.month10 = (Math.floor(qr.Volume__c != 0 ? qr.Volume__c/3 : qr.Volume__c)).setScale(2);
                            oppWaferOutperYear.month11 = (Math.floor(qr.Volume__c != 0 ? qr.Volume__c/3 : qr.Volume__c)).setScale(2);
                            oppWaferOutperYear.month12 = (qr.Volume__c != 0 ? qr.Volume__c-(oppWaferOutperYear.month10+oppWaferOutperYear.month11) : qr.Volume__c).setScale(2);
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
            mapOppASP = findWholevals(yearList,quarterList,mapOppASP);
            mapYearWaferOutforMarket = findWholevals(yearList,quarterList,mapYearWaferOutforMarket);
            
            Map<String,MargetSegmentDevice__c> MarketSegmentValuemap = new map<String,MargetSegmentDevice__c>();
            MarketSegmentValuemap = MargetSegmentDevice__c.getall();
            for(Decimal year : yearList){
                for(String quart : quarterList){
                    if(MarketSegmentValuemap.containskey(dev.Market_Segment__c) && count < MarketSegmentValuemap.get(dev.Market_Segment__c).value__c * 4){
                        String keyVal = String.valueOf(year) + quart;
                        if(mapOppASP.containsKey(keyVal) && mapYearWaferOutforMarket.containsKey(keyVal)){
                            torTotal += mapOppASP.get(keyVal) * mapYearWaferOutforMarket.get(keyVal);
                            system.debug('deepti '+torTotal);
                            count++;
                        }
                    }
                }
            }
        } catch(Exception e){
            PSP_createExtension.exceptionHandleMethod(PSP_createExtension.class.getName(),'calculateoppWaferOut()',String.ValueOf(deviceRecord.Id),'Error Message='+e.getMessage()+' At Line Number='+e.getLineNumber()+' Stack Trace='+e.getStackTraceString(),e.getTypeName(),e.getCause());
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Following error has occured:'+e.getMessage()));
        }
        return NULL;
    }
    
    //method to check first non-null value
    public static Map<String,Decimal> findWholevals(List<Decimal> yearList, List<String> quarterList, Map<String,Decimal> origValMap){
        Map<String,Decimal> editedValMap = new Map<String,Decimal>();
        if(yearList != null && yearList.size() > 0){
            for(Decimal year : yearList){
                if(quarterList != null && quarterList.size() > 0){
                    for(String quart : quarterList){
                        String keyVal = String.valueOf(year) + quart;
                        if(origValMap != null && origValMap.containskey(keyVal)){
                            if(origValMap.get(keyVal) == null || origValMap.get(keyVal) == 0.00){
                                origValMap.remove(keyVal);
                            } else{
                                return origValMap;
                            }
                        }
                    }
                }
            }
        }
        return editedValMap;
    }
        
    public PageReference QuarterlyView() {
        try{
            PageReference newocp = new PageReference('/apex/PSP_createQuarterly?id='+deviceRecord.id);   //<----- changed here
            newocp.setRedirect(true);
            return newocp;
        } catch (DMLException e) {
            PSP_createExtension.exceptionHandleMethod(PSP_createExtension.class.getName(),'QuarterlyView()',String.ValueOf(deviceRecord.Id),'Error Message='+e.getMessage()+' At Line Number='+e.getLineNumber()+' Stack Trace='+e.getStackTraceString(),e.getTypeName(),e.getCause());
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, 'Error'));
            return null;
        }
        return null;
    }
  
    public pageReference previewPower(){
        isPreview = true;
        previewFlag = true;
        copyOppWaferOuts();
        return null;
    }
  
    public pageReference resetPreview(){
        isPreview = false;
        previewFlag = false;
        callRecords();
        calculateoppWaferOut();
        Device__c dev = [SELECT Id,PSP_Volume_Percentage__c,PSP_Slide_Schedule_to__c,PSP_Slide_Schedule_by_Months__c FROM Device__c WHERE Id =: deviceRecord.Id];
        deviceRecord.PSP_Volume_Percentage__c = dev.PSP_Volume_Percentage__c;
        deviceRecord.PSP_Slide_Schedule_to__c = dev.PSP_Slide_Schedule_to__c;
        deviceRecord.PSP_Slide_Schedule_by_Months__c = dev.PSP_Slide_Schedule_by_Months__c;
        return null;
    }
    
    //DBiswal 09142016
    public pageReference copyOppWaferOuts(){
        try{
            Map<decimal,calculateWaferOuts> oppWaferOutMap = new Map<decimal,calculateWaferOuts>();
            List<DevicePSPData__c> newProdWaferOutList = new List<DevicePSPData__c>();
            if(!isPreview){callRecords();calculateoppWaferOut();previewFlag = false;}
            for(calculateWaferOuts cal : lstOppWaferOuts){
                oppWaferOutMap.put(cal.yearNo,cal);
            }
            for(DevicePSPData__c pspData : lstproductionWaferOuts){
                if(oppWaferOutMap.containsKey(pspData.Year__c)){
                    pspData.Month_1__c = oppWaferOutMap.get(pspData.Year__c).month1 != null ? oppWaferOutMap.get(pspData.Year__c).month1 : 0;
                    pspData.Month_2__c = oppWaferOutMap.get(pspData.Year__c).month2 != null ? oppWaferOutMap.get(pspData.Year__c).month2 : 0;
                    pspData.Month_3__c = oppWaferOutMap.get(pspData.Year__c).month3 != null ? oppWaferOutMap.get(pspData.Year__c).month3 : 0;
                    pspData.Month_4__c = oppWaferOutMap.get(pspData.Year__c).month4 != null ? oppWaferOutMap.get(pspData.Year__c).month4 : 0;
                    pspData.Month_5__c = oppWaferOutMap.get(pspData.Year__c).month5 != null ? oppWaferOutMap.get(pspData.Year__c).month5 : 0;
                    pspData.Month_6__c = oppWaferOutMap.get(pspData.Year__c).month6 != null ? oppWaferOutMap.get(pspData.Year__c).month6 : 0;
                    pspData.Month_7__c = oppWaferOutMap.get(pspData.Year__c).month7 != null ? oppWaferOutMap.get(pspData.Year__c).month7 : 0;
                    pspData.Month_8__c = oppWaferOutMap.get(pspData.Year__c).month8 != null ? oppWaferOutMap.get(pspData.Year__c).month8 : 0;
                    pspData.Month_9__c = oppWaferOutMap.get(pspData.Year__c).month9 != null ? oppWaferOutMap.get(pspData.Year__c).month9 : 0;
                    pspData.Month_10__c = oppWaferOutMap.get(pspData.Year__c).month10 != null ? oppWaferOutMap.get(pspData.Year__c).month10 : 0;
                    pspData.Month_11__c = oppWaferOutMap.get(pspData.Year__c).month11 != null ? oppWaferOutMap.get(pspData.Year__c).month11 : 0;
                    pspData.Month_12__c = oppWaferOutMap.get(pspData.Year__c).month12 != null ? oppWaferOutMap.get(pspData.Year__c).month12 : 0;
                } else {
                    pspData.Month_1__c = 0;
                    pspData.Month_2__c = 0;
                    pspData.Month_3__c = 0;
                    pspData.Month_4__c = 0;
                    pspData.Month_5__c = 0;
                    pspData.Month_6__c = 0;
                    pspData.Month_7__c = 0;
                    pspData.Month_8__c = 0;
                    pspData.Month_9__c = 0;
                    pspData.Month_10__c = 0;
                    pspData.Month_11__c = 0;
                    pspData.Month_12__c = 0;
                }
                newProdWaferOutList.add(pspData);
            }
            if(newProdWaferOutList.size() > 0){
                if(isPreview){
                    lstproductionWaferOuts.clear();
                    lstproductionWaferOuts.addAll(newProdWaferOutList);
                    updateProdWafStart();
                    SaveAfterWaferOutCopy();
                } else {
                    database.upsert(newProdWaferOutList);
                    updateProdWafStart();
                    callRecords();
                    SaveAfterWaferOutCopy();
                }
            }
        }catch(Exception e){
            PSP_createExtension.exceptionHandleMethod(PSP_createExtension.class.getName(),'copyOppWaferOuts()',String.ValueOf(deviceRecord.Id),'Error Message='+e.getMessage()+' At Line Number='+e.getLineNumber()+' Stack Trace='+e.getStackTraceString(),e.getTypeName(),e.getCause());
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Following Exception Occured: '+e.getMessage()));
        }
        return null;
    }
  
    public void updateProdWafStart(){
        try{
            if(deviceRecord.Proto_DPML__c == NULL || deviceRecord.No_of_Mask_Layers__c ==NULL || deviceRecord.Production_DPML__c == NULL){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Please fill DPMLs and Mask Layer fields.'));
            }else{
                integer dpmlShiftProd = integer.valueOf((deviceRecord.Production_DPML__c*deviceRecord.No_of_Mask_Layers__c/30).round());
                List<Decimal> lstWaferOut2 = new List<Decimal>();
                Map<Decimal,DevicePSPData__c> mapYearWaferOut2 = new Map<Decimal,DevicePSPData__c>();
                for(DevicePSPData__c qtyWaferStart : lstPSPproductionWaferStarts){
                    mapYearWaferOut2.put(qtyWaferStart.Year__c,qtyWaferStart);
                }
                lstPSPproductionWaferStarts.clear();
                for(DevicePSPData__c qtyWaferStart : lstproductionWaferOuts){
                    lstWaferOut2.add(qtyWaferStart.Month_1__c);
                    lstWaferOut2.add(qtyWaferStart.Month_2__c);
                    lstWaferOut2.add(qtyWaferStart.Month_3__c);
                    lstWaferOut2.add(qtyWaferStart.Month_4__c);
                    lstWaferOut2.add(qtyWaferStart.Month_5__c);
                    lstWaferOut2.add(qtyWaferStart.Month_6__c);
                    lstWaferOut2.add(qtyWaferStart.Month_7__c);
                    lstWaferOut2.add(qtyWaferStart.Month_8__c);
                    lstWaferOut2.add(qtyWaferStart.Month_9__c);
                    lstWaferOut2.add(qtyWaferStart.Month_10__c);
                    lstWaferOut2.add(qtyWaferStart.Month_11__c);
                    lstWaferOut2.add(qtyWaferStart.Month_12__c);
                }
              
                if(dpmlShiftProd>0){
                  for(Integer i=1;i<=dpmlShiftProd;i++){
                      //lstWaferOut2.add(0,0);
                      //lstWaferOut2.remove(0);
                      lstWaferOut2.add(0);
                  }
                }
              
                integer monthStart=0;
                for(Integer yearNo:lstYears){
                  DevicePSPData__c pspWaferOutTotalPerYear = new DevicePSPData__c(Device__c= deviceRecord.id,id = isPreview ? null : mapYearWaferOut2.get(yearNo).Id);
                  pspWaferOutTotalPerYear.Month_1__c = lstWaferOut2[monthStart];monthStart++;
                  pspWaferOutTotalPerYear.Month_2__c = lstWaferOut2[monthStart];monthStart++;
                  pspWaferOutTotalPerYear.Month_3__c = lstWaferOut2[monthStart];monthStart++;
                  pspWaferOutTotalPerYear.Month_4__c = lstWaferOut2[monthStart];monthStart++;
                  pspWaferOutTotalPerYear.Month_5__c = lstWaferOut2[monthStart];monthStart++;
                  pspWaferOutTotalPerYear.Month_6__c = lstWaferOut2[monthStart];monthStart++;
                  pspWaferOutTotalPerYear.Month_7__c = lstWaferOut2[monthStart];monthStart++;
                  pspWaferOutTotalPerYear.Month_8__c = lstWaferOut2[monthStart];monthStart++;
                  pspWaferOutTotalPerYear.Month_9__c = lstWaferOut2[monthStart];monthStart++;
                  pspWaferOutTotalPerYear.Month_10__c = lstWaferOut2[monthStart];monthStart++;
                  pspWaferOutTotalPerYear.Month_11__c = lstWaferOut2[monthStart];monthStart++;
                  pspWaferOutTotalPerYear.Month_12__c = lstWaferOut2[monthStart];monthStart++;
                  lstPSPproductionWaferStarts.add(pspWaferOutTotalPerYear);
                }
                if(lstPSPproductionWaferStarts.size() > 0){
                  if(!isPreview){
                      database.upsert(lstPSPproductionWaferStarts);
                  }
                }
            }
        }catch(Exception e){
            PSP_createExtension.exceptionHandleMethod(PSP_createExtension.class.getName(),'updateProdWafStart()',String.ValueOf(deviceRecord.Id),'Error Message='+e.getMessage()+' At Line Number='+e.getLineNumber()+' Stack Trace='+e.getStackTraceString(),e.getTypeName(),e.getCause());
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Following Exception Occured: '+e.getMessage()));
        }
    }
    
    //DBiswal
    public class calculateTotals{
        public decimal quarter1{get;set;}
        public decimal quarter2{get;set;}
        public decimal quarter3{get;set;}
        public decimal quarter4{get;set;}
        public decimal yearNo{get;set;}
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
    
    public Static void exceptionHandleMethod(String SrcName,String SrcFunctionName,String Obj, String logMsg,String logcd,Exception exc){
        ApplicationLogWrapper alw = new ApplicationLogWrapper();
        alw.source = SrcName;
        alw.sourceFunction = SrcFunctionName;
        alw.ApplicationName = 'Device Management';
        alw.referenceId = obj;
        alw.referenceInfo = 'PSP';
        alw.logMessage = logMsg;
        alw.debugLevel = 'Error';
        alw.logCode = logcd;
        alw.ex = exc;
        GlobalUtility.logMessage(alw);
    }
}