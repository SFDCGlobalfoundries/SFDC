/*
     Author: Deepti Narayan Biswal
     Description: Extension class for PSP_Milestone Page.
     History:
        DBiswal    01282016    Created.
        DBiswal    04262017    Changes for lock and unlock PSP dates.(line no. 235-244)
        PSamal    07192017    Changes related to Case-00072275

*/
public with sharing class PSP_MilestoneExtension {
    public Device__c deviceRec {get;set;}
    public List<Device__c> devlist {get;set;}
    public List<milestoneWrapper> milestoneList{get;set;}
    public String pspcreateReady {get;set;}
    public Device__c dev {get;set;}
    public List<devOverviewWrapper> devOverviewList {get;set;}
    public string xmlheader {get;set;}
    public string endfile{get;set;}
    public string styleBorderAttribute{get;set;}
    public string styleBorderAttribute2{get;set;}
    public String styleAlignmentAttribute{get;set;}
    public String styleAlignmentAttribute2{get;set;}
    public String styleFontAttribute{get;set;}
    public date lockdate {get;set;}
    public String ceUser {get;set;}
    public String accId {get;set;}
    public string userId {get;set;}
    public Boolean dateEditView {get;set;}
    public Map<String,Decimal> stepcycleMap {get;set;}
    public Date pspStatusWhen {get;set;}
    public Boolean editstatusflag {get;set;}
    public Boolean datelockflag {get;set;}
    public List<PSP_Status_Archieve__c> archieveList {get;set;}
    public Boolean AMFlag {get;set;}
    public Boolean AMFAEFlag {get;set;}
    public Boolean CEFlag {get;set;}
    public Boolean adminFlag {get;set;}
    public Boolean CEAdminFlag {get;set;}
    public List<selectOption> scheduleCompletedList {get;set;}
    public String scheduleCompletedtext {get;set;}
    public List<selectOption> includeinPSPList {get;set;}
    public String includeinPSPtext {get;set;}
    public List<selectOption> currDevoptions {get;set;}
    public String currDevId {get;set;}
    public Map<Id,Device__c> currDevMap {get;set;}
    public List<selectOption> ceFtpsOptions {get;set;}
    public String ceFtps {get;set;}
    public Boolean currDevDone {get;set;}
    public Boolean isASIC {get;set;}
    public List<selectOption> delTypeList {get;set;}
    public String delType {get;set;}
    public Boolean unlockAccess {get;set;}
    
    public PSP_MilestoneExtension(ApexPages.StandardController controller) {
        this.deviceRec = (Device__c)controller.getRecord();
        milestoneList = new List<milestoneWrapper>();
        dev = new Device__c();
        pspcreateReady = '';
        userId = null;
        dateEditView = false;
        editstatusflag = false;
        datelockflag = false;
        isASIC = false;
        search();
        devOverviewList = new List<devOverviewWrapper>();
        devOverviewList.add(new devOverviewWrapper(dev));
        xmlheader ='<?xml version="1.0"?><?mso-application progid="Excel.Sheet"?>';
        endfile = '</Workbook>';
        styleBorderAttribute = '<Borders><Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1" ss:Color="#000000"/><Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1" ss:Color="#000000"/><Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1" ss:Color="#000000"/><Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1" ss:Color="#000000"/></Borders>';
        styleBorderAttribute2 = '<Borders><Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1" ss:Color="#000000"/><Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1" ss:Color="#000000"/><Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1" ss:Color="#000000"/></Borders>';
        styleAlignmentAttribute = '<Alignment ss:Horizontal="Center" ss:Vertical="Bottom" ss:WrapText="1"/>';
        styleAlignmentAttribute2 = '<Alignment ss:Horizontal="Left" ss:Vertical="Bottom" ss:WrapText="1"/>';
        styleFontAttribute = '<Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="11" ss:Color="#000000" ss:Bold="1"/>';
        scheduleCompletedList = new List<selectOption>();
        scheduleCompletedList.add(new selectOption('Yes','Yes'));
        scheduleCompletedList.add(new selectOption('No','No'));
    }
    
    public pageReference search(){
        milestoneList = new List<milestoneWrapper>();
        dev = new Device__c();
        dev = [SELECT Id,Name,Design_Execution_Required__c,CRMDID__c,Device_ID__c,Account__c,Account__r.Name,Account__r.Account_Manager__r.Name,Fab__c,Geometry__c,Process_Technology__c,Opportunity__c,Opportunity_Name__c,Account__r.Classification__c,Market_Segment__c,Account__r.Region__c,Actual_Tapeout_Date_Done__c,
               Account__r.Owner.Name,End_Application__c,Semiconductor_Device__c,End_Customer__c,Device_Sourcing__c,Design_Win_Date__c,Product_TO_Date__c,Product_TO_Current__c,Sample_Delivery_Date__c,Forecasted_Proto_Date__c,Geometry_NM__c,Original_Forecasted_Tapeout_Date__c,Die_Yield_at_RTP__c,
               Respin_Date__c,Forecasted_RTP_Date__c,End_Customer_Qual_Complete_Date__c,Proto_Wafer_Fab_Shipped_Notes__c,Proto_Wafer_Fab_Shipped_Date__c,Risk_Wafer_Shipped_Date__c,Risk_Wafer_Shipped_Date_Notes__c,CE_assigned_for_PSP__c,Actual_Tapeout_Date_GMT__c,Account__r.Account_Manager__c,
               Design_Win_Date_Notes__c,End_Customer_Qual_Complete_Date_Notes__c,Percentage_Share_End_Customer_Socket__c,Proto_Wafer_First_Lot_Start_Date__c,Assembled_Tested_Part_Shipped_Date_Notes__c,Proto_Lot_Start_Date__c,CE_assigned_for_PSP__r.Name,TapeOut_AM__c,Schedule_Review_Completed_by_CE__c,
               Product_TO_Date_Notes__c,Proto_Wafer_First_Lot_Start_Date_Notes__c,Respin_Date_Notes__c,PSP_Dates_Locked__c,Forecasted_Production_Start_Date__c,Risk_Wafer_Start_Date_Notes__c,Production_Start_Date_Notes__c,PSP_to_be_Locked_by_Date__c,Primary_Device_AM__r.Name,Business_Unit__c,
               (SELECT Id,Name,BX_041_Status__c,Die_Size_X_mm__c,Die_Size_Y_mm__c FROM BX_041__r),Proto_Lot_Start_ID__c,Opportunity2__r.Design_Win_FAE__r.Id,Opportunity2__r.Design_Win_FAE__r.Name,Current_Forecast_Tapeout_Date__c,TapeOut_AM__r.Name,Primary_Device_AM__c,Include_in_PSP_Reports__c,
               Opportunity2__r.Date_Design_Win_Approved__c,Opportunity2__r.CloseDate,Opportunity2__r.Product__c,PSP_Risk__c,PSP_Escalation__c,PSP_Overview_Comments__c,PSP_Status_Who__c,PSP_Status_When__c,Assembled_Tested_Part_Shipped_Current__c,End_Customer_Qual_Complete_Current__c,
               Production_Wafer_Start_Current__c,Proto_Wafer_Fab_Shipped_Current__c,Proto_Wafer_First_Lot_Start_Current__c,Respin_Impact_to_Schedule_Current__c,Risk_Wafer_Shipped_Current__c,Risk_Wafer_Start_Current__c,Tapeout_Revenue__c,Assembled_Tested_Part_Shipped_Done__c,
               End_Customer_Qual_Complete_Done__c,Production_Wafer_Start_Done__c,Proto_Wafer_Fab_Shipped_Done__c,Proto_Wafer_First_Lot_Start_Done__c,Respin_Impact_to_Schedule_Done__c,Risk_Wafer_Shipped_Done__c,Risk_Wafer_Start_Done__c,TOR_Automatic__c,Deliverable_Type__c,Product_Line__c,
               Current_Customer_Device_Id__c,Current_Customer_Device_Sourcing__c,CE_FTPS__c,Exclude_from_Demand_Forecast__c,Design_Execution__c,Customer_Engagement__c,Customer_Engagement_Current__c,Customer_Engagement_Done__c,Customer_Engagement_Notes__c,Ready_to_Quote__c,Ready_to_Quote_Current__c,
               Ready_to_Quote_Done__c,Ready_to_Quote_Notes__c,CDS_Complete__c,CDS_Complete_Current__c,CDS_Complete_Done__c,CDS_Complete_Notes__c,First_customer_design_data__c,First_customer_design_data_Current__c,First_customer_design_data_Done__c,First_customer_design_data_Notes__c,
               RTM_e_Release_Dt__c,RTM_e_Release_Dt_Current__c,RTM_e_Release_Dt_Done__c,RTM_e_Release_Dt_Notes__c,RTM_e_Release_A__c,RTM_e_Release_A_Current__c,RTM_e_Release_A_Done__c,RTM_e_Release_A_Notes__c,Production_Wafer_Start_Judged__c,Production_Wafer_Start_Judged_Current__c,
               Production_Wafer_Start_Judged_Done__c,Production_Wafer_Start_Judged_Notes__c,Stage__c,Product_Indicator__c,Opportunity_Program__c,Primary_Option__r.Option_Stage__c,Primary_Option__c,(SELECT Id from PSP_Status_Archieves__r) FROM Device__c WHERE Id=:deviceRec.Id];
        devlist = new List<Device__c>();
        devlist.add(dev);
        
        if(dev.Product_Indicator__c=='ASIC'){ isASIC=true; }else{ isASIC=false; }
                
        List<String> milestoneNames = new List<String>();
        if(isASIC){
            milestoneNames.addAll(Environment_Variable__c.getInstance('PSP_Milestones_ASIC').Value__c.split(','));
        } else {
            milestoneNames.addAll(Environment_Variable__c.getInstance('PSP_Milestones').Value__c.split(','));
        }
        milestoneNames.add('');
        
        lockdate = dev.PSP_to_be_Locked_by_Date__c;
        accId = dev.Account__c;
        ceUser = dev.CE_assigned_for_PSP__c!=null ? dev.CE_assigned_for_PSP__r.Name : '';
        userId = dev.CE_assigned_for_PSP__c!=null ? dev.CE_assigned_for_PSP__c : null;
        if(dev.Assembled_Tested_Part_Shipped_Current__c !=null && dev.Production_Wafer_Start_Current__c !=null && dev.Proto_Wafer_Fab_Shipped_Current__c !=null && dev.Proto_Wafer_First_Lot_Start_Current__c !=null){
            pspcreateReady = 'pspcreateReady';
        } else {
            pspcreateReady = '';
        }
        pspStatusWhen = dev.PSP_Status_When__c!=null ? dev.PSP_Status_When__c : null;
        if(dev.Schedule_Review_Completed_by_CE__c != null){
            scheduleCompletedtext = dev.Schedule_Review_Completed_by_CE__c;
        } else {
            scheduleCompletedtext = 'No';
        }
        
        Map<String,String> devfieldlabelMap = new Map<String,String>();
        Map<String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
        Schema.SObjectType deviceSchema = schemaMap.get('Device__c');
        Map<String, Schema.SObjectField> fieldMap = deviceSchema.getDescribe().fields.getMap();
        for (String fieldName : fieldMap.keySet()) { 
            devfieldlabelMap.put(fieldMap.get(fieldName).getDescribe().getLabel(),fieldName);
        }
        
        includeinPSPList = new List<selectOption>();
        Schema.DescribeFieldResult fieldResult = Device__c.Include_in_PSP_Reports__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();        
        for( Schema.PicklistEntry f : ple){
            if(!f.getLabel().containsIgnorecase('None')){
                includeinPSPList.add(new SelectOption(f.getValue(),f.getLabel()));
            }
        }
        if(dev.Include_in_PSP_Reports__c != null){
            includeinPSPtext = dev.Include_in_PSP_Reports__c;
        } else {
            includeinPSPtext = 'Yes';
        }
        
        ceFtpsOptions = new List<SelectOption>();
        Schema.DescribeFieldResult fieldFtpsResult = Device__c.CE_FTPS__c.getDescribe();
        List<Schema.PicklistEntry> pleFtps = fieldFtpsResult.getPicklistValues();        
        for(Schema.PicklistEntry f : pleFtps){
            ceFtpsOptions.add(new SelectOption(f.getValue(),f.getLabel()));
        }
        
        if(dev.CE_FTPS__c != null && dev.CE_FTPS__c !=''){
            ceFtps = dev.CE_FTPS__c;
        } else {
            ceFtps = null;
        }
        
        delTypeList = new List<SelectOption>();
        delTypeList.add(new SelectOption('', '--None--'));
        Schema.DescribeFieldResult fielddelTypeResult = Device__c.Deliverable_Type__c.getDescribe();
        List<Schema.PicklistEntry> delTypepickvals = fielddelTypeResult.getPicklistValues();        
        for(Schema.PicklistEntry f : delTypepickvals){
            if(f.getValue() != 'Service' && f.getValue() != 'Design'){
                delTypeList.add(new SelectOption(f.getValue(),f.getLabel()));
            }
        }
        
        if(dev.Deliverable_Type__c != null && dev.Deliverable_Type__c !=''){
            delType = dev.Deliverable_Type__c;
        } else {
            delType = null;
        }
        
        //DBiswal - 09092016
        currDevoptions = new List<selectOption>();
        currDevMap = new Map<Id,Device__c>();
        for(Device__c d : [SELECT Id,Name,Account__c,Account__r.Name,Actual_Tapeout_Date_Done__c,Product_TO_Current__c,Proto_Wafer_First_Lot_Start_Done__c,Proto_Wafer_First_Lot_Start_Current__c,Proto_Wafer_Fab_Shipped_Done__c,Proto_Wafer_Fab_Shipped_Current__c,
                            Assembled_Tested_Part_Shipped_Done__c,Assembled_Tested_Part_Shipped_Current__c FROM Device__c WHERE (Base_Device__c =: dev.Id OR (Copied_Device__c =: dev.Id AND Tapeout_Type__c = 'Full Layer Retrofit')) AND Status__c = 'Active' ORDER BY Name]){
            currDevoptions.add(new selectOption(d.Id,d.Name));
            currDevMap.put(d.Id,d);
        }
        if(currDevoptions.size() > 0){
            currDevId = currDevId!=null ? currDevId : currDevoptions[0].getvalue();
            if(currDevMap.get(currDevId) != null){
                Device__c cdev = currDevMap.get(currDevId);
                if(cdev.Product_TO_Current__c != null && cdev.Actual_Tapeout_Date_Done__c == true && cdev.Proto_Wafer_First_Lot_Start_Current__c != null && cdev.Proto_Wafer_First_Lot_Start_Done__c == true && 
                    cdev.Proto_Wafer_Fab_Shipped_Current__c != null && cdev.Proto_Wafer_Fab_Shipped_Done__c == true && cdev.Assembled_Tested_Part_Shipped_Current__c != null && cdev.Assembled_Tested_Part_Shipped_Done__c == true){
                    currDevDone = true;
                } else {
                    currDevDone = false;
                }
            }
        } else {
            currDevId = 'Not Available';
        }
        
        //DBiswal - 07182016
        Set<Id> ceIdset = new Set<Id>();
        Set<Id> adminIdset = new Set<Id>();
        Set<Id> amIdset = new Set<Id>();
        Set<Id> faeIdset = new Set<Id>();
        Set<String> unlockSet = new Set<String>();
        for(Device__c dev : devlist){
            amIdset.add(dev.TapeOut_AM__c);
            amIdset.add(dev.Primary_Device_AM__c);
            amIdset.add(dev.Account__r.Account_Manager__c);
            ceIdset.add(dev.CE_assigned_for_PSP__c);
            faeIdset.add(dev.Opportunity2__r.Design_Win_FAE__r.Id);
        }
        
        for(Profile pf : [SELECT Id,Name FROM Profile WHERE (Name='System Administrator' OR Name='GF System Admin' OR Name='GF Global Admin')]){
            adminIdset.add(pf.Id);
        }
        
        if(amIdset.contains(UserInfo.getUserId())){
            AMFlag = true;
        } else {
            AMFlag = false;
        }
        if(amIdset.contains(UserInfo.getUserId()) || faeIdset.contains(UserInfo.getUserId())){
            AMFAEFlag = true;
        } else {
            AMFAEFlag = false;
        }
        if(ceIdset.contains(UserInfo.getUserId())){
            CEFlag = true;
        } else {
            CEFlag = false;
        }
        if(adminIdset.contains(UserInfo.getProfileId())){
            adminFlag = true;
        } else {
            adminFlag = false;
        }
        if(dev.PSP_to_be_Locked_by_Date__c != null && Date.today() >= dev.PSP_to_be_Locked_by_Date__c){
            unlockSet.addAll(System.label.PSP_Milestone_Unlock_Access.split(','));
            if(adminFlag || unlockSet.contains(UserInfo.getUserId())){
                unlockAccess = true;
            } else {
                unlockAccess = false;
            }
        } else {
            unlockAccess = true;
        }
        
        Map<String,String> milestoneOwnerMap = new Map<String,String>();
        Map<String,String> milestoneOwnerNameMap = new Map<String,String>();
        Map<String,Date> OrigDateMap = new Map<String,Date>();
        Map<String,Date> actualDateMap = new Map<String,Date>();
        Date sampledate;
        for(String s : milestoneNames){
            if(s.equalsIgnoreCase('Design Win')){
                if(isASIC){milestoneOwnerMap.put(s,'AM/FAE');}else{milestoneOwnerMap.put(s,'AM');}
                OrigDateMap.put(s,dev.Opportunity2__r.Date_Design_Win_Approved__c != null ? dev.Opportunity2__r.Date_Design_Win_Approved__c : dev.Opportunity2__r.CloseDate);
                if(isASIC){actualDateMap.put(s,dev.Design_Win_Date__c);}else{actualDateMap.put(s,sampledate);}
                milestoneOwnerNameMap.put(s,dev.TapeOut_AM__r.Name!=null ? dev.TapeOut_AM__r.Name : dev.Primary_Device_AM__r.Name!=null ? dev.Primary_Device_AM__r.Name : dev.Account__r.Account_Manager__r.Name);
            }
            if(s.equalsIgnoreCase('Product TO')){
                if(isASIC){milestoneOwnerMap.put(s,'FAE/TS/Pe');}else{milestoneOwnerMap.put(s,'FAE');}
                OrigDateMap.put(s,dev.Product_TO_Date__c!=null ? dev.Product_TO_Date__c : dev.Original_Forecasted_Tapeout_Date__c);
                actualDateMap.put(s,dev.Product_TO_Current__c!=null ? dev.Product_TO_Current__c : dev.Product_TO_Date__c);
                if(isASIC){milestoneOwnerNameMap.put(s,dev.CE_assigned_for_PSP__r.Name!=null?dev.CE_assigned_for_PSP__r.Name:'');}else{milestoneOwnerNameMap.put(s,dev.Opportunity2__r.Design_Win_FAE__r.Name);}                
            }
            if(s.equalsIgnoreCase('Wafer First Lot Start')){
                milestoneOwnerMap.put(s,'CE/PM');
                //OrigDateMap.put(s,dev.PSP_Dates_Locked__c==true?dev.Proto_Lot_Start_Date__c:sampledate);
                OrigDateMap.put(s,dev.PSP_Dates_Locked__c==true?dev.Proto_Wafer_First_Lot_Start_Date__c:sampledate);
                actualDateMap.put(s,dev.Proto_Wafer_First_Lot_Start_Current__c);
                milestoneOwnerNameMap.put(s,dev.CE_assigned_for_PSP__r.Name!=null?dev.CE_assigned_for_PSP__r.Name:'');
            }
            if(s.equalsIgnoreCase('Proto Wafer Fab Shipped')){
                if(isASIC){milestoneOwnerMap.put(s,'FAE/TS');}else{milestoneOwnerMap.put(s,'CE/PM');}
                OrigDateMap.put(s,dev.PSP_Dates_Locked__c==true?dev.Proto_Wafer_Fab_Shipped_Date__c:sampledate);
                actualDateMap.put(s,dev.Proto_Wafer_Fab_Shipped_Current__c);
                milestoneOwnerNameMap.put(s,dev.CE_assigned_for_PSP__r.Name!=null?dev.CE_assigned_for_PSP__r.Name:'');
                
            }
            if(s.equalsIgnoreCase('Assembled/Tested Part Shipped')){
                milestoneOwnerMap.put(s,'CE/PM');
                OrigDateMap.put(s,dev.PSP_Dates_Locked__c==true?dev.Forecasted_Proto_Date__c:sampledate);
                actualDateMap.put(s,dev.Assembled_Tested_Part_Shipped_Current__c);
                milestoneOwnerNameMap.put(s,dev.CE_assigned_for_PSP__r.Name!=null?dev.CE_assigned_for_PSP__r.Name:'');
            }
            if(s.equalsIgnoreCase('Respin Impact to Schedule')){
                milestoneOwnerMap.put(s,'FAE');
                OrigDateMap.put(s,dev.PSP_Dates_Locked__c==true?dev.Respin_Date__c:sampledate);
                actualDateMap.put(s,dev.Respin_Impact_to_Schedule_Current__c);
                milestoneOwnerNameMap.put(s,dev.Opportunity2__r.Design_Win_FAE__r.Name);
            }
            if(s.equalsIgnoreCase('RTR - Functionality and Yield')){
                milestoneOwnerMap.put(s,'CE/PM');
                OrigDateMap.put(s,dev.PSP_Dates_Locked__c==true?dev.Forecasted_RTP_Date__c:sampledate);
                actualDateMap.put(s,dev.Risk_Wafer_Start_Current__c);
                milestoneOwnerNameMap.put(s,dev.CE_assigned_for_PSP__r.Name!=null?dev.CE_assigned_for_PSP__r.Name:'');
            }
            if(s.equalsIgnoreCase('Direct Customer Qual Complete')){
                milestoneOwnerMap.put(s,'CE/PM');
                OrigDateMap.put(s,dev.PSP_Dates_Locked__c==true?dev.Risk_Wafer_Shipped_Date__c:sampledate);
                actualDateMap.put(s,dev.Risk_Wafer_Shipped_Current__c);
                milestoneOwnerNameMap.put(s,dev.CE_assigned_for_PSP__r.Name!=null?dev.CE_assigned_for_PSP__r.Name:'');
            }
            if(s.equalsIgnoreCase('End Customer Qual Complete')){
                if(isASIC){milestoneOwnerMap.put(s,'FAE/TS');}else{milestoneOwnerMap.put(s,'AM');}
                OrigDateMap.put(s,dev.PSP_Dates_Locked__c==true?dev.End_Customer_Qual_Complete_Date__c:sampledate);
                actualDateMap.put(s,dev.End_Customer_Qual_Complete_Current__c);
                milestoneOwnerNameMap.put(s,dev.TapeOut_AM__r.Name!=null ? dev.TapeOut_AM__r.Name : dev.Primary_Device_AM__r.Name!=null ? dev.Primary_Device_AM__r.Name : dev.Account__r.Account_Manager__r.Name);
            }
            if(s.equalsIgnoreCase('Production Wafer Start')){
                if(isASIC){milestoneOwnerMap.put(s,'FAE');}else{milestoneOwnerMap.put(s,'CE/PM');}
                OrigDateMap.put(s,dev.PSP_Dates_Locked__c==true?dev.Forecasted_Production_Start_Date__c:sampledate);
                actualDateMap.put(s,dev.Production_Wafer_Start_Current__c);
                milestoneOwnerNameMap.put(s,dev.CE_assigned_for_PSP__r.Name!=null?dev.CE_assigned_for_PSP__r.Name:'');
            }
            
            //Add milestones for ASIC
            if(s.equalsIgnoreCase('Customer Engagement')){
                milestoneOwnerMap.put(s,'FAE');
                OrigDateMap.put(s,dev.PSP_Dates_Locked__c==true ? dev.Customer_Engagement__c : sampledate);
                actualDateMap.put(s,dev.Customer_Engagement_Current__c);
                milestoneOwnerNameMap.put(s,dev.TapeOut_AM__r.Name!=null ? dev.TapeOut_AM__r.Name : dev.Primary_Device_AM__r.Name!=null ? dev.Primary_Device_AM__r.Name : dev.Account__r.Account_Manager__r.Name);
            }
            if(s.equalsIgnoreCase('Ready to Quote')){
                milestoneOwnerMap.put(s,'FAE');
                OrigDateMap.put(s,dev.PSP_Dates_Locked__c==true ? dev.Ready_to_Quote__c : sampledate);
                actualDateMap.put(s,dev.Ready_to_Quote_Current__c);
                milestoneOwnerNameMap.put(s,dev.TapeOut_AM__r.Name!=null ? dev.TapeOut_AM__r.Name : dev.Primary_Device_AM__r.Name!=null ? dev.Primary_Device_AM__r.Name : dev.Account__r.Account_Manager__r.Name);
            }
            if(s.equalsIgnoreCase('CDS Complete')){
                milestoneOwnerMap.put(s,'FAE/TS');
                OrigDateMap.put(s,dev.PSP_Dates_Locked__c==true ? dev.CDS_Complete__c : sampledate);
                actualDateMap.put(s,dev.CDS_Complete_Current__c);
                milestoneOwnerNameMap.put(s,dev.CE_assigned_for_PSP__r.Name!=null?dev.CE_assigned_for_PSP__r.Name:'');
            }
            if(s.equalsIgnoreCase('1st customer design data')){
                milestoneOwnerMap.put(s,'FAE/TS');
                OrigDateMap.put(s,dev.PSP_Dates_Locked__c==true ? dev.CDS_Complete__c : sampledate);
                actualDateMap.put(s,dev.First_customer_design_data_Current__c);
                milestoneOwnerNameMap.put(s,dev.CE_assigned_for_PSP__r.Name!=null?dev.CE_assigned_for_PSP__r.Name:'');
            }
            if(s.equalsIgnoreCase('RTM e-Release Dt')){
                milestoneOwnerMap.put(s,'FAE/TS/Pe');
                OrigDateMap.put(s,dev.PSP_Dates_Locked__c==true ? dev.CDS_Complete__c : sampledate);
                actualDateMap.put(s,dev.RTM_e_Release_Dt_Current__c);
                milestoneOwnerNameMap.put(s,dev.CE_assigned_for_PSP__r.Name!=null?dev.CE_assigned_for_PSP__r.Name:'');
            }
            if(s.equalsIgnoreCase('RTM e-Release A')){
                milestoneOwnerMap.put(s,'FAE/TS/Pe');
                OrigDateMap.put(s,dev.PSP_Dates_Locked__c==true ? dev.CDS_Complete__c : sampledate);
                actualDateMap.put(s,dev.RTM_e_Release_A_Current__c);
                milestoneOwnerNameMap.put(s,dev.CE_assigned_for_PSP__r.Name!=null?dev.CE_assigned_for_PSP__r.Name:'');
            }
            if(s.equalsIgnoreCase('Production Wafer Start (Judged)')){
                milestoneOwnerMap.put(s,'PLM');
                OrigDateMap.put(s,dev.PSP_Dates_Locked__c==true ? dev.CDS_Complete__c : sampledate);
                actualDateMap.put(s,dev.Production_Wafer_Start_Judged_Current__c);
                milestoneOwnerNameMap.put(s,dev.TapeOut_AM__r.Name!=null ? dev.TapeOut_AM__r.Name : dev.Primary_Device_AM__r.Name!=null ? dev.Primary_Device_AM__r.Name : dev.Account__r.Account_Manager__r.Name);
            }
        }
        date myDate;
        String comments;
        for(String milestone : milestoneNames){
            milestoneList.add(new milestoneWrapper(dev,milestone,milestoneOwnerMap.get(milestone),milestoneOwnerNameMap.get(milestone),OrigDateMap.get(milestone),actualDateMap.get(milestone),milestone!='' ? (String)dev.get(devfieldlabelMap.get(milestone+' Notes')) : '',milestone!='' && milestone!='Design Win' ? (Boolean)dev.get(devfieldlabelMap.get(milestone+' Done')) : false));
        }
        
        //calculate step cycle time
        String georange = '';
        String devgeo = dev.Geometry_NM__c.substring(0,dev.Geometry_NM__c.length()-2);
        if(Decimal.valueOf(devgeo) <= 20){
            georange = 'Geometry 20nm & below';
        } else if(Decimal.valueOf(devgeo) > 22 && Decimal.valueOf(devgeo) < 32){
            georange = 'Geometry 32nm - 22nm';
        } else if(Decimal.valueOf(devgeo) > 40 && Decimal.valueOf(devgeo) < 45){
            georange = 'Geometry 45nm - 40nm';
        }else if(Decimal.valueOf(devgeo) > 55 && Decimal.valueOf(devgeo) < 90){
            georange = 'Geometry 90nm - 55nm';
        }else if(Decimal.valueOf(devgeo) > 110 && Decimal.valueOf(devgeo) < 130){
            georange = 'Geometry 0.11um - 0.13um';
        }else if(Decimal.valueOf(devgeo) > 140 && Decimal.valueOf(devgeo) < 250){
            georange = 'Geometry 0.14um - 0.25um';
        }else if(Decimal.valueOf(devgeo) > 300){
            georange = 'Geometry 0.30um & Greater';
        }
        List<PSP_Step_Cycle_Time__c> stepcycleList = new List<PSP_Step_Cycle_Time__c>();
        stepcycleMap = new Map<String,Decimal>();
        if(georange != ''){
            stepcycleList = [SELECT Id,Geo__c,cycle_time_days__c,Milestone__c FROM PSP_Step_Cycle_Time__c WHERE Geo__c =: georange];
        }
        if(stepcycleList.size() > 0){
            for(PSP_Step_Cycle_Time__c ps : stepcycleList){
                stepcycleMap.put(ps.Milestone__c,ps.cycle_time_days__c);
            }
        }
        refreshStepCycletime();
        for(milestoneWrapper eachmile : milestoneList){
            if(eachmile.showEdit == true){
                
            }
        }
        return null;
    }
    
    //action method for PSP_StatusArchieves page
    public pageReference fetchArchieves(){
        archieveList = new List<PSP_Status_Archieve__c>();
        archieveList = [SELECT Id,Name,Device__c,Escalation__c,Overview_Comments__c,Risk__c,When__c,Who__c,CreatedBy.Name,CreatedDate FROM PSP_Status_Archieve__c WHERE Device__c =: deviceRec.Id ORDER BY CreatedDate DESC];
        return null;
    }
    
    public pageReference reset(){
        userId = '';
        ceUser = '';
        editstatusflag = false;
        search();
        return null;
    }
    
    public pageReference cancel(){
        pageReference pageref = new pageReference('/'+deviceRec.Id);
        pageref.setRedirect(true);
        return pageref;
    }
    
    public pageReference saveDates(){
        try{
            Map<String,String> devfieldlabelMap = new Map<String,String>();
            Map<String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
            Schema.SObjectType deviceSchema = schemaMap.get('Device__c');
            Map<String, Schema.SObjectField> fieldMap = deviceSchema.getDescribe().fields.getMap();
            for (String fieldName : fieldMap.keySet()) { 
                devfieldlabelMap.put(fieldMap.get(fieldName).getDescribe().getLabel(),fieldName);
            }
            
            Device__c devtoupdate = dev;
    
            if(scheduleCompletedtext != null && scheduleCompletedtext != ''){
                devtoupdate.Schedule_Review_Completed_by_CE__c = scheduleCompletedtext;
            }
            if(includeinPSPtext != null && includeinPSPtext != ''){
                devtoupdate.Include_in_PSP_Reports__c = includeinPSPtext;
            }
            if(delType != null && delType != ''){
                devtoupdate.Deliverable_Type__c = delType;
            } else {
                devtoupdate.Deliverable_Type__c = null;
            }
                    
            for(milestoneWrapper eachmile : milestoneList){
                if((eachmile.notes != null && eachmile.notes != '') && eachmile.notes != eachmile.devRec.get(devfieldlabelMap.get(eachmile.milestone+' Notes'))){
                    devtoupdate.put(devfieldlabelMap.get(eachmile.milestone+' Notes'), eachmile.notes);
                }
                //For updating from Forecasted Date
                if(eachmile.milestone != '' && eachmile.milestone != 'Design Win'){
                    if(!dev.PSP_Dates_Locked__c || datelockflag){
                        if(eachmile.milestone == 'Respin Impact to Schedule'){
                            devtoupdate.put(devfieldlabelMap.get(eachmile.milestone), eachmile.forecastedDate);
                            devtoupdate.put(devfieldlabelMap.get(eachmile.milestone+' Current'), eachmile.forecastedDate);
                            if(eachmile.productTOdone != (Boolean)dev.get(devfieldlabelMap.get(eachmile.milestone+' Done'))){
                                devtoupdate.put(devfieldlabelMap.get(eachmile.milestone+' Done'), eachmile.productTOdone);
                            }
                        } else{
                            //Commented for case#00057253
                            /*if(eachmile.milestone == 'Product TO'){
                                if(eachmile.productTOdone != dev.Actual_Tapeout_Date_Done__c){
                                    devtoupdate.Actual_Tapeout_Date_Done__c = eachmile.productTOdone;
                                }
                                if(eachmile.forecastedDate != null){
                                    if(eachmile.productTOdone == false){
                                        devtoupdate.Current_Forecast_Tapeout_Date__c = eachmile.forecastedDate;
                                    } else {
                                        devtoupdate.Current_Forecast_Tapeout_Date__c = eachmile.forecastedDate;
                                        devtoupdate.Actual_Tapeout_Date_GMT__c = eachmile.forecastedDate;
                                    }
                                    devtoupdate.put(devfieldlabelMap.get(eachmile.milestone), eachmile.forecastedDate);
                                }                            
                            } else {*/
                            
                            if(eachmile.forecastedDate != eachmile.devRec.get(devfieldlabelMap.get(eachmile.milestone))){
                                if(eachmile.milestone != 'Wafer First Lot Start'){
                                    devtoupdate.put(devfieldlabelMap.get(eachmile.milestone), eachmile.forecastedDate);
                                    devtoupdate.put(devfieldlabelMap.get(eachmile.milestone+' Current'), eachmile.forecastedDate);
                                } else {
                                    //devtoupdate.put(devfieldlabelMap.get('Proto Lot Start Date'), eachmile.forecastedDate);
                                    devtoupdate.put(devfieldlabelMap.get(eachmile.milestone), eachmile.forecastedDate);
                                    devtoupdate.put(devfieldlabelMap.get(eachmile.milestone+' Current'), eachmile.forecastedDate);
                                }
                            }
                            if(eachmile.productTOdone != (Boolean)dev.get(devfieldlabelMap.get(eachmile.milestone+' Done'))){
                                devtoupdate.put(devfieldlabelMap.get(eachmile.milestone+' Done'), eachmile.productTOdone);
                            }
                            //}
                        }
                    } else if(dev.PSP_Dates_Locked__c){
                        //if(eachmile.milestone != 'Product TO'){
                        if(eachmile.milestone == 'Respin Impact to Schedule'){
                            devtoupdate.put(devfieldlabelMap.get(eachmile.milestone+' Current'), eachmile.forecastedDate);
                            if(eachmile.productTOdone != (Boolean)dev.get(devfieldlabelMap.get(eachmile.milestone+' Done'))){
                                devtoupdate.put(devfieldlabelMap.get(eachmile.milestone+' Done'), eachmile.productTOdone);
                            }
                        } else{
                            if(eachmile.forecastedDate != eachmile.devRec.get(devfieldlabelMap.get(eachmile.milestone+' Current'))){
                                devtoupdate.put(devfieldlabelMap.get(eachmile.milestone+' Current'), eachmile.forecastedDate);
                            }
                            if(eachmile.productTOdone != (Boolean)dev.get(devfieldlabelMap.get(eachmile.milestone+' Done'))){
                                devtoupdate.put(devfieldlabelMap.get(eachmile.milestone+' Done'), eachmile.productTOdone);
                            }
                        }
                        //commented for Case#00057253
                        /*} else {
                            if(eachmile.productTOdone != dev.Actual_Tapeout_Date_Done__c){
                                devtoupdate.Actual_Tapeout_Date_Done__c = eachmile.productTOdone;
                            }
                            if(eachmile.forecastedDate != null){
                                if(eachmile.productTOdone == false){
                                    devtoupdate.Current_Forecast_Tapeout_Date__c = eachmile.forecastedDate;
                                }else {
                                    devtoupdate.Current_Forecast_Tapeout_Date__c = eachmile.forecastedDate;
                                    devtoupdate.Actual_Tapeout_Date_GMT__c = eachmile.forecastedDate;
                                }
                                devtoupdate.put(devfieldlabelMap.get(eachmile.milestone), eachmile.forecastedDate);
                            }
                        }*/
                    }
                }
                if(eachmile.milestone == 'Design Win' && isASIC){
                    devtoupdate.put(devfieldlabelMap.get(eachmile.milestone+' Date'), eachmile.forecastedDate);
                }
            }
            //update lock date
            devtoupdate.Product_TO_Current__c = devtoupdate.Product_TO_Current__c!=null ? devtoupdate.Product_TO_Current__c : dev.Product_TO_Date__c;
            if(devtoupdate.Product_TO_Current__c!=null && devtoupdate.Assembled_Tested_Part_Shipped_Current__c!=null && devtoupdate.End_Customer_Qual_Complete_Current__c!=null && devtoupdate.Production_Wafer_Start_Current__c!=null && devtoupdate.Proto_Wafer_Fab_Shipped_Current__c!=null && 
               devtoupdate.Proto_Wafer_First_Lot_Start_Current__c!=null && devtoupdate.Respin_Impact_to_Schedule_Current__c!=null && devtoupdate.Risk_Wafer_Shipped_Current__c!=null && devtoupdate.Risk_Wafer_Start_Current__c!=null && devtoupdate.PSP_to_be_Locked_by_Date__c==null){
                devtoupdate.PSP_to_be_Locked_by_Date__c = Date.Today().addDays(30);
            }
            
            //update Device Stage
            if(isASIC){
                Device__c d = [select id,Actual_Tapeout_Date_Done__c,Proto_Wafer_Fab_Shipped_Done__c,Risk_Wafer_Start_Done__c,Production_Wafer_Start_Done__c from Device__c where id=:dev.Id];
                
                if(dev.Stage__c == 'Design In' && dev.Actual_Tapeout_Date_GMT__c == null && devtoupdate.Product_TO_Current__c != null && d.Actual_Tapeout_Date_Done__c == false && devtoupdate.Actual_Tapeout_Date_Done__c == true){
                    devtoupdate.Actual_Tapeout_Date_GMT__c = Date.today();
                    devtoupdate.Stage__c = 'Tapeout';
                }
                if(dev.Stage__c == 'Tapeout' && devtoupdate.Proto_Wafer_Fab_Shipped_Current__c != null && d.Proto_Wafer_Fab_Shipped_Done__c == false && devtoupdate.Proto_Wafer_Fab_Shipped_Done__c == true){
                    devtoupdate.Stage__c = 'Prototype';
                }
                if(dev.Stage__c == 'RTR' && devtoupdate.Production_Wafer_Start_Current__c != null && d.Production_Wafer_Start_Done__c == false && devtoupdate.Production_Wafer_Start_Done__c == true){
                    devtoupdate.Stage__c = 'Production';
                }
            }       
        
            Database.Update(devtoupdate);
            
            search();
            /*  update device primary option based on below criteria as part of Sprint 2
                1. Product_Line__c ='ASIC'
                2. Deliverable_Type__c = 'Module'
                3. Proto_Wafer_Fab_Shipped_Done__c = true
                4. Proto_Wafer_Fab_Shipped_Current__c !=null
                5. Device Primary Option Stage needs to change from 'Prototype Fulfillment' to "Customer Decision" on filling of Device PSP 
            */
            if(null !=dev && null != dev.Product_Line__c && String.valueOf(dev.Product_Line__c).equalsIgnoreCase('ASIC') 
                && null != dev.Deliverable_Type__c && String.valueOf(dev.Deliverable_Type__c).equalsIgnoreCase('Module') 
                && dev.Proto_Wafer_Fab_Shipped_Done__c && null !=dev.Primary_Option__c && null != dev.Proto_Wafer_Fab_Shipped_Current__c
                && String.valueOf(dev.Primary_Option__r.Option_Stage__c).equalsIgnoreCase('Prototype Fulfillment'))
                {   
                    List<Id> ids = new List<Id>();
                    ids.add(dev.Primary_Option__c);
                    BnP_OptionUtility bnpCtr = new BnP_OptionUtility();
                    bnpCtr.updateOptionStages(ids, 'Customer Decision');
                }
            //update TechReview Review RIT date based upon below criteria
            /*
             * 1. Product_Line__c ='RF' or 'SiPh' 
             * 2. MileStone name = 'Product Tapeout'
             * 3. Product_TO_Current__c !=null
             * 4. Actual_Tapeout_Date_Done__c = true
             * 5. Tech Review Record type is Foundry
             * Code need to implement after confirmation from Nishi
             */
             if(null !=dev && dev.Actual_Tapeout_Date_Done__c && null !=dev.Product_TO_Current__c)
                 updateTechReviewRITDate(dev.Id);
        } catch (Exception e){
            PSP_createExtension.exceptionHandleMethod(PSP_MilestoneExtension.class.getName(),'saveDates()',String.ValueOf(dev.Id),'Error Message='+e.getMessage()+' At Line Number='+e.getLineNumber()+' Stack Trace='+e.getStackTraceString(),e.getTypeName(),e.getCause());
            Apexpages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR,returnError(e.getMessage())));
            return null;
        }
        return null;
    }
    
    private void updateTechReviewRITDate(Id deviceId){
        //Device is linked with only one Foundry record type for Tech review in real senario
        List<Tech_Review_Summary__c> techReviews = new List<Tech_Review_Summary__c>();
         
        for(Tech_Review_Summary__c techReview : [SELECT Id, Name, RIT_outlook__c, Device__c, Device__r.Product_Line__c, RecordType.DeveloperName,
                                                     Device__r.Product_TO_Current__c, Device__r.Actual_Tapeout_Date_Done__c 
                                                     FROM Tech_Review_Summary__c
                                                     WHERE Device__r.Product_TO_Current__c !=NULL
                                                     AND   (Device__r.Product_Line__c = 'RF' OR Device__r.Product_Line__c ='SiPh')
                                                     AND   Device__r.Actual_Tapeout_Date_Done__c = TRUE
                                                     AND   RecordType.DeveloperName = 'Foundry' 
                                                     AND   Device__c =:deviceId])
         {
            if(null !=techReview){
                techReview.RIT_outlook__c = techReview.Device__r.Product_TO_Current__c;
                techReviews.add(techReview);
            }   
         }                                           
         
        
        try{
            if(!techReviews.isEmpty()){
                update techReviews;
            }   
        } catch (Exception e){
            PSP_createExtension.exceptionHandleMethod(PSP_MilestoneExtension.class.getName(),'updateTechReviewRITDate()',String.ValueOf(dev.Id),'Error Message='+e.getMessage()+' At Line Number='+e.getLineNumber()+' Stack Trace='+e.getStackTraceString(),e.getTypeName(),e.getCause());
            Apexpages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR,returnError(e.getMessage())));
        }                               
        
    }
    
    public pageReference editStatus(){
        editstatusflag = true;
        return null;
    }
    
    public pageReference updateStatus(){
        Device__c devtoupdate = new Device__c();
        if(dev != null){
            devtoupdate.Id = dev.Id;
            devtoupdate.PSP_Risk__c = dev.PSP_Risk__c;
            devtoupdate.PSP_Overview_Comments__c = dev.PSP_Overview_Comments__c;
            devtoupdate.PSP_Escalation__c = dev.PSP_Escalation__c;
            devtoupdate.PSP_Status_Who__c = dev.PSP_Status_Who__c;
            devtoupdate.PSP_Status_When__c = pspStatusWhen;
        }
        try{
            update devtoupdate;
            //insert PSP archive
            PSP_Status_Archieve__c archieve = new PSP_Status_Archieve__c();
            archieve.Device__c = dev.Id;
            archieve.Risk__c = dev.PSP_Risk__c;
            archieve.Overview_Comments__c = dev.PSP_Overview_Comments__c;
            archieve.Escalation__c = dev.PSP_Escalation__c;
            archieve.Who__c = dev.PSP_Status_Who__c;
            archieve.When__c = pspStatusWhen;
            insert archieve;
        } catch(Exception e){
            PSP_createExtension.exceptionHandleMethod(PSP_MilestoneExtension.class.getName(),'updateStatus()',String.ValueOf(dev.Id),'Error Message='+e.getMessage()+' At Line Number='+e.getLineNumber()+' Stack Trace='+e.getStackTraceString(),e.getTypeName(),e.getCause());
            Apexpages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR,returnError(e.getMessage())));
        }
        editstatusflag = false;
        search();
        return null;
    }
    
    public pageReference cancelPSPStatus(){
        editstatusflag = false;
        return null;
    }
    
    public pageReference lockDates(){
        saveDates();
        if(dev.Product_TO_Current__c!=null && dev.Proto_Wafer_First_Lot_Start_Current__c!=null && dev.Proto_Wafer_Fab_Shipped_Current__c!=null && dev.Assembled_Tested_Part_Shipped_Current__c!=null && dev.Production_Wafer_Start_Current__c!=null){
            if(dev.CE_assigned_for_PSP__c != null){
                datelockflag = true;
                
                try{
                    Device__c updateDev = dev;
                    updateDev.PSP_Dates_Locked__c = true;
                    update updateDev;
                } catch(Exception e){
                    PSP_createExtension.exceptionHandleMethod(PSP_MilestoneExtension.class.getName(),'lockDates()',String.ValueOf(dev.Id),'Error Message='+e.getMessage()+' At Line Number='+e.getLineNumber()+' Stack Trace='+e.getStackTraceString(),e.getTypeName(),e.getCause());
                    Apexpages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR,returnError(e.getMessage())));
                }
            } else {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR,'Please Update CE User before locking.'));
                return null;
            }
        } else {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR,'Please fill all milestone dates before locking.'));
            return null;
        }
        search();
        datelockflag = false;
        return null;
    }
    
    public pageReference unlockDates(){
        try{
            date eraseDate;
            Map<String,String> devfieldlabelMap = new Map<String,String>();
            Map<String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
            Schema.SObjectType deviceSchema = schemaMap.get('Device__c');
            Map<String, Schema.SObjectField> fieldMap = deviceSchema.getDescribe().fields.getMap();
            for (String fieldName : fieldMap.keySet()) { 
                devfieldlabelMap.put(fieldMap.get(fieldName).getDescribe().getLabel(),fieldName);
            }
            saveDates();
            Device__c updateDev = dev;
            
            for(milestoneWrapper eachmile : milestoneList){
                if(devfieldlabelMap.containskey(eachmile.milestone)){
                 if(!isASIC){
                    if(eachmile.milestone != 'Design Win' && eachmile.milestone != 'Product TO'){
                        updateDev.put(devfieldlabelMap.get(eachmile.milestone), eraseDate);
                    }
                }else{
                    if(eachmile.milestone != 'Design Win'){
                        updateDev.put(devfieldlabelMap.get(eachmile.milestone), eraseDate);
                    } else {
                       updateDev.put(devfieldlabelMap.get(eachmile.milestone+' Date'), eraseDate); 
                    }
                } 
                           
                    
                }
                
            }
            updateDev.PSP_Dates_Locked__c = false;
            
            update updateDev;
        }catch(Exception e){
            PSP_createExtension.exceptionHandleMethod(PSP_MilestoneExtension.class.getName(),'unlockDates()',String.ValueOf(dev.Id),'Error Message='+e.getMessage()+' At Line Number='+e.getLineNumber()+' Stack Trace='+e.getStackTraceString(),e.getTypeName(),e.getCause());
            Apexpages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR,returnError(e.getMessage())));
        }
        
        search();
        return null;
    }
    
    public pageReference redirectPSPCreate(){
        pageReference pageref = new pageReference('/apex/PSP_Create?id='+deviceRec.Id);
        pageref.setRedirect(false);
        return pageref;
    }
    
    public pageReference updateCEmethod(){
        Device__c devtoupdate = new Device__c();
        try{
            if(userId != null && String.isNotBlank(userId)){
                devtoupdate = dev;
                devtoupdate.CE_assigned_for_PSP__c = userId;
                update devtoupdate;
            } else {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR,'Please provide any CE user'));
                return null;
            }
        } catch(Exception e){
            PSP_createExtension.exceptionHandleMethod(PSP_MilestoneExtension.class.getName(),'updateCEmethod()',String.ValueOf(dev.Id),'Error Message='+e.getMessage()+' At Line Number='+e.getLineNumber()+' Stack Trace='+e.getStackTraceString(),e.getTypeName(),e.getCause());
            Apexpages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR,returnError(e.getMessage())));
        }
        search();
        return null;
    }
    
    public pagereference refreshStepCycletime(){
        try{
            for(Integer i=1; i<milestoneList.size(); i++){
                if((!milestoneList[i].milestone.equalsIgnoreCase('Design Win') && !milestoneList[i].milestone.equalsIgnoreCase('')) || (milestoneList[i].milestone.equalsIgnoreCase('Design Win') && isASIC)){
                    if(milestoneList[i].milestone.equalsIgnoreCase('Wafer First Lot Start') || milestoneList[i].milestone.equalsIgnoreCase('Proto Wafer Fab Shipped') || milestoneList[i].milestone.equalsIgnoreCase('Assembled/Tested Part Shipped') || milestoneList[i].milestone.equalsIgnoreCase('Direct Customer Qual Complete')){
                        if(stepcycleMap.get(milestoneList[i].milestone) != null && dev.PSP_to_be_Locked_by_Date__c == null){
                            milestoneList[i].stepcycle = milestoneList[i].forecastedDate!=null ? milestoneList[i-1].forecastedDate!=null ? milestoneList[i-1].forecastedDate.daysBetween(milestoneList[i].forecastedDate) : stepcycleMap.get(milestoneList[i].milestone) : stepcycleMap.get(milestoneList[i].milestone);
                        } else {
                            milestoneList[i].stepcycle = milestoneList[i].forecastedDate!=null ? milestoneList[i-1].forecastedDate!=null ? milestoneList[i-1].forecastedDate.daysBetween(milestoneList[i].forecastedDate) : null : null;
                        }
                    } else if(milestoneList[i].milestone.equalsIgnoreCase('Product TO')){
                        if(!isASIC){
                            milestoneList[i].stepcycle = milestoneList[i].forecastedDate!=null ? milestoneList[i-1].originalDate!=null ? milestoneList[i-1].originalDate.daysBetween(milestoneList[i].forecastedDate) : null : null;
                        } else {
                            milestoneList[i].stepcycle = milestoneList[i].forecastedDate!=null ? milestoneList[i-1].forecastedDate !=null ? milestoneList[i-1].forecastedDate.daysBetween(milestoneList[i].forecastedDate) : null : null;
                        }
                    } else if(milestoneList[i].milestone.equalsIgnoreCase('RTR - Functionality and Yield')){
                        milestoneList[i].stepcycle = milestoneList[i].forecastedDate!=null ? milestoneList[i-1].forecastedDate!=null ? milestoneList[i-1].forecastedDate.daysBetween(milestoneList[i].forecastedDate) : 
                                                     milestoneList[i-2].forecastedDate!=null ? milestoneList[i-2].forecastedDate.daysBetween(milestoneList[i].forecastedDate) : null : null;
                    } else {
                        milestoneList[i].stepcycle = milestoneList[i].forecastedDate!=null ? milestoneList[i-1].forecastedDate!=null ? milestoneList[i-1].forecastedDate.daysBetween(milestoneList[i].forecastedDate) : null : null;
                    }
                }
            }
        }catch(Exception e){
            PSP_createExtension.exceptionHandleMethod(PSP_MilestoneExtension.class.getName(),'refreshStepCycletime()',String.ValueOf(dev.Id),'Error Message='+e.getMessage()+' At Line Number='+e.getLineNumber()+' Stack Trace='+e.getStackTraceString(),e.getTypeName(),e.getCause());
        }
        return null;
    }
    
    public pagereference refreshforecastedDate(){
        try{
            for(Integer i=1; i<milestoneList.size(); i++){
                if(isASIC ? (!milestoneList[i].milestone.equalsIgnoreCase('Customer Engagement') && !milestoneList[i].milestone.equalsIgnoreCase('')) : (!milestoneList[i].milestone.equalsIgnoreCase('Design Win') && !milestoneList[i].milestone.equalsIgnoreCase(''))){
                    if(isASIC ? (!milestoneList[i].milestone.equalsIgnoreCase('')) : (!milestoneList[i].milestone.equalsIgnoreCase('Product TO'))){
                        if(milestoneList[i].milestone.equalsIgnoreCase('Ready to Quote')){
                            milestoneList[i].forecastedDate = milestoneList[i].stepcycle!=null ? milestoneList[i-1].forecastedDate!=null ? milestoneList[i-1].forecastedDate.addDays(Integer.valueOf(milestoneList[i].stepcycle)) : Date.today().addDays(Integer.valueOf(milestoneList[i].stepcycle)) : null ;
                        } else {
                            milestoneList[i].forecastedDate = milestoneList[i].stepcycle!=null ? milestoneList[i-1].forecastedDate!=null ? milestoneList[i-1].forecastedDate.addDays(Integer.valueOf(milestoneList[i].stepcycle)) : null : null ;
                        }
                    } else {
                        milestoneList[i].forecastedDate = milestoneList[i].stepcycle !=null?milestoneList[i-1].originalDate.addDays(Integer.valueOf(milestoneList[i].stepcycle)):null;
                    }
                }
            }
        }catch(Exception e){
            PSP_createExtension.exceptionHandleMethod(PSP_MilestoneExtension.class.getName(),'refreshforecastedDate()',String.ValueOf(dev.Id),'Error Message='+e.getMessage()+' At Line Number='+e.getLineNumber()+' Stack Trace='+e.getStackTraceString(),e.getTypeName(),e.getCause());
        }
        return null;
    }
    
    public pageReference switchviewmethod(){
        if(!dateEditView){
            dateEditView = true;
        } else {
            dateEditView = false;
        }
        return null;
    }
    
    public class milestoneWrapper{
        public Device__c devRec{get;set;}
        public String milestone{get;set;}
        public String owner{get;set;}
        public String ownerName{get;set;}
        public Date originalDate{get;set;}
        public Date forecastedDate{get;set;}
        public String notes {get;set;}
        public Boolean showEdit {get;set;}
        public Decimal stepcycle {get;set;}
        public Boolean productTOdone {get;set;}
        public Boolean isDoneEditable {get;set;}
        public Boolean isASIC = false;
                
        public milestoneWrapper(Device__c device,String mile,String owner1,String ownerName1,Date origDate,Date forecaDate,String note,Boolean bool){
            devRec = device;
            milestone = mile;
            owner = owner1;
            ownerName = ownerName1;
            originalDate = origDate;
            forecastedDate = forecaDate;
            productTOdone = bool;
            
            //Commented for Case#00057253
            /*if(mile.equalsIgnoreCase('Product TO')){
                productTOdone = device.Actual_Tapeout_Date_Done__c;
                notes = note;
            }*/
            if(devRec.Product_Indicator__c=='ASIC'){ isASIC=true; }else{ isASIC=false; }
            if(!isASIC){
                if(mile.equalsIgnoreCase('Proto Wafer Fab Shipped')){
                    notes = note != null ? note : '' + 'FTPS Date:';                
                } else if(mile.equalsIgnoreCase('Assembled/Tested Part Shipped')){
                    notes = note != null ? note : '' + 'Vendor Name __________  ; FTPS Date:';                
                } else if(mile.equalsIgnoreCase('Respin Impact to Schedule')){
                    notes = note != null ? note : '' + '_____# of respins    _____ days per respin';                
                } else if(mile.equalsIgnoreCase('RTR - Functionality and Yield')){
                    notes = note != null ? note : '' + '______ # hrs HTOL';                
                } else {           
                    notes = note;
                }
            }
        }
    }
    
    public class devOverviewWrapper{
        public Device__c device{get;set;}
        public String businessUnit {get;set;}
        public Decimal dieSizex {get;set;}
        public Decimal dieSizey {get;set;}
        public String salesRegion {get;set;}
        public String accManager {get;set;}
        public Decimal turnkeyTotal {get;set;}
        public String torCalculation {get;set;}
        //public Manufacturing_Lot__c mflot {get;set;}
        
        public devOverviewWrapper(Device__c device){
            this.device = device;
            this.businessUnit = device.Account__r.Classification__c;
            this.salesRegion = device.Account__r.Region__c;
            this.accManager = device.TapeOut_AM__r.Name!=null ? device.TapeOut_AM__r.Name : device.Primary_Device_AM__r.Name!=null ? device.Primary_Device_AM__r.Name : device.Account__r.Account_Manager__r.Name;
            this.turnkeyTotal = 0;
            if(device.Tapeout_Revenue__c != null && device.Tapeout_Revenue__c > 0 && device.Tapeout_Revenue__c < 10000000){
                this.turnkeyTotal = device.Tapeout_Revenue__c;
                this.torCalculation = 'Manual';
            } else {
                this.turnkeyTotal = device.TOR_Automatic__c;
                this.torCalculation = 'Automatic';                
            }
        }
    }
    
    public String returnError(String msg){
        String msgtoDisp = '';
        if(msg.contains('INSUFFICIENT_ACCESS_OR_READONLY')){
            msgtoDisp = 'You do not have edit access on this record. Please Contact your AM/FAE/CSR.';
        } else {
            msgtoDisp = 'Error Occured';
        }
        return msgtoDisp;
    }
    
    public pageReference refreshRevDates(){
        currDevoptions = new List<selectOption>();
        currDevMap = new Map<Id,Device__c>();
        for(Device__c d : [SELECT Id,Name,Account__c,Account__r.Name,Actual_Tapeout_Date_Done__c,Product_TO_Current__c,Proto_Wafer_First_Lot_Start_Done__c,Proto_Wafer_First_Lot_Start_Current__c,Proto_Wafer_Fab_Shipped_Done__c,Proto_Wafer_Fab_Shipped_Current__c,
                           Assembled_Tested_Part_Shipped_Done__c,Assembled_Tested_Part_Shipped_Current__c FROM Device__c WHERE (Base_Device__c =: dev.Id OR (Copied_Device__c =: dev.Id AND Tapeout_Type__c = 'Full Layer Retrofit')) AND Status__c = 'Active' ORDER BY Name]){
            currDevoptions.add(new selectOption(d.Id,d.Name));
            currDevMap.put(d.Id,d);
        }
        if(currDevId != null && currDevMap.get(currDevId) != null){
            Device__c cdev = currDevMap.get(currDevId);
            if(cdev.Product_TO_Current__c != null && cdev.Actual_Tapeout_Date_Done__c == true && cdev.Proto_Wafer_First_Lot_Start_Current__c != null && cdev.Proto_Wafer_First_Lot_Start_Done__c == true && 
                cdev.Proto_Wafer_Fab_Shipped_Current__c != null && cdev.Proto_Wafer_Fab_Shipped_Done__c == true && cdev.Assembled_Tested_Part_Shipped_Current__c != null && cdev.Assembled_Tested_Part_Shipped_Done__c == true){
                currDevDone = true;
            } else {
                currDevDone = false;
            }
        }
        return null;
    }
    
    public pageReference refreshRevpanel(){
        if(currDevId != null && currDevMap.get(currDevId) != null){
            Device__c cdev = currDevMap.get(currDevId);
            if(cdev.Product_TO_Current__c == null || cdev.Proto_Wafer_First_Lot_Start_Current__c == null || cdev.Proto_Wafer_Fab_Shipped_Current__c == null || cdev.Assembled_Tested_Part_Shipped_Current__c == null){
                currDevDone = false;
            }
        }
        return null;
    }
    
    public pageReference saveRevDates(){
        try{
            if(currDevId != null){
                Device__c devUpd = new Device__c();
                if(currDevMap.get(currDevId) != null){
                    devUpd.Id = currDevId;
                    devUpd.Product_TO_Current__c = currDevMap.get(currDevId).Product_TO_Current__c;
                    devUpd.Proto_Wafer_First_Lot_Start_Current__c = currDevMap.get(currDevId).Proto_Wafer_First_Lot_Start_Current__c;
                    devUpd.Proto_Wafer_Fab_Shipped_Current__c = currDevMap.get(currDevId).Proto_Wafer_Fab_Shipped_Current__c;
                    devUpd.Assembled_Tested_Part_Shipped_Current__c = currDevMap.get(currDevId).Assembled_Tested_Part_Shipped_Current__c;
                    devUpd.Actual_Tapeout_Date_Done__c = currDevDone;
                    devUpd.Proto_Wafer_First_Lot_Start_Done__c = currDevDone;
                    devUpd.Proto_Wafer_Fab_Shipped_Done__c = currDevDone;
                    devUpd.Assembled_Tested_Part_Shipped_Done__c = currDevDone;
                    update devUpd;
                }
            }
        }catch(DMLException e){
            PSP_createExtension.exceptionHandleMethod(PSP_MilestoneExtension.class.getName(),'saveRevDates()',String.ValueOf(dev.Id),'Error Message='+e.getMessage()+' At Line Number='+e.getLineNumber()+' Stack Trace='+e.getStackTraceString(),e.getTypeName(),e.getCause());
            Apexpages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR,returnError(e.getMessage())+' when updating current Device Revision.'));
        }
        return null;
    }
}