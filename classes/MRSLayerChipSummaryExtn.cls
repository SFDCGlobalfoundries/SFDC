/*
Type Name: MRSLayerChipSummaryExtn
Author: Cognizant 
Created Date: 17-April-2014
Reason: This is a controller class for MRSLayerChipSummary page
Change History:
Author: 
Modified Date: 
Reason: 
Author: Cognizant Technology Solutions
Modified Date:
??..
??..
 */

public class MRSLayerChipSummaryExtn
{
    
    public Map<String,EmailTemplate> mapEmailTemplateAndName{
        get{
            if(mapEmailTemplateAndName==null || mapEmailTemplateAndName.keySet().isEmpty()){
                List<EmailTemplate> emailTeplatelst = [SELECT id,Subject,Body,HtmlValue,DeveloperName from EmailTemplate 
                                                 where DeveloperName 
                                                 IN ('SWIFT_Customer_Gating_GDSOUTReview','SWIFT_GDSOUT_Ready_Email_Template','SWIFT_Customer_gating_non_gating_MEBES','Swift_Gating_MEBES_Recieved_Initial','SWIFT_Non_Gating_MEBES_Recieved_Initial',
                                                      'SWIFT_Customer_non_gating_MEBES_JV','SWIFT_gating_subsequent_Email_Template','SWIFT_non_gating_subsequent_Email_Template','Swift_Customer_Gating_MEBES_Recieved_Initial','SWIFT_Customer_Non_Gating_MEBES_Recieved_Initial','Swift_Foundry_Gating_MEBES_Recieved_Initial','SWIFT_Foundry_Non_Gating_MEBES_Recieved_Initial',
                                                      'SWIFT_Gating_Tapeout_Application_Custom','SWIFT_Non_Gating_Tapeout_Application_Custom','Swift_Prime_OR_Frame_Jobview_Receved_Gating'
                                                      ,'SWIFT_PRIME_OR_FRAME_NON_GATING_MEBES_RECEIVED','SWIFT_Gating_Received_revised_MEBES_data_Custom','SWIFT_Non_Gating_Received_revised_MEBES_data_Custom',
                                                      'SWIFT_Non_Gating_Tapeout_Application_Custom','SWIFT_Gating_Tapeout_Application_Custom','SWIFT_gating_subsequent_Email_Template','SWIFT_non_gating_subsequent_Email_Template','SWIFT_Send_Email_To_MDP',
                                                      'SWIFT_Send_Email_To_Tapeout_Applications_Subsequent','SWIFT_Send_Email_To_GS_TDTI_MPW_Subsequent','SWIFT_Gating_Tapeout_Center_custom', 'SWIFT_Gating_Received_revised_MEBES_data_Custom1','SWIFT_Customer_Ready_Email',
                                                      'SWIFT_Foundry_Ready_Email','SWIFT_Gating_MDP_Custom','SWIFT_Foundry_Gating_GDSOUTReview')];
                mapEmailTemplateAndName = new Map<String,EmailTemplate>();
                for(EmailTemplate emailTemplateObj :emailTeplatelst){
                    mapEmailTemplateAndName.put(emailTemplateObj.DeveloperName,emailTemplateObj);
                }
            }
            return mapEmailTemplateAndName;
        }
        set;
    }
    public static Map<Id,Set<Id>> groupIduserIdMap;
    public static List<User> userlist;
    public static  Map<Id,Group> lstgroupMap;
    public static OrgWideEmailAddress orgWideAddr;
    public static set<String> setLayersInPTRFButNotInDRT;
    public static Integer numberOfLayerChipRecords;
    public static List<MRS_Layer_Chip_Association__c> listNew;
    public static map<Id,MRS_Layer_Chip_Association__c> mapOldLayerChips;
    public static String mrsId;
       
    public Map<Id,MRS_Layer_Association__c> mapLayerSummaryDetails{get;set;}
    public MRS_Layer_Association__c objLayerSummaryDetails{get;set;}
    public Boolean isBreadcrumbActive {get;set;}
    public string strCustomerId{get; set;}
    public string strMstId{get; set;}
    public string strCustomerName{get; set;}
    public string strCustomer{get; set;}
    public string idCurrentLayer{get; set;}
    public string strSelectedLayerChipStatus{get; set;}
    private boolean flagController{get; set;}
    public string statusSelectedValue{get; set;}
    public string deviceSelectedValue{get; set;}
    public string ptrfSelectedValue{get; set;}
    public string techgeoSelectedValue{get; set;}
    public set<String> setLayerList{get;set;}
    public List<String> listLayerList{get;set;}
    public set<String> setDeviceId{get;set;}
    public set<String> setPTRFnDRT{get;set;}
    public Set<String> setTechGeo{get;set;}
    public Integer refreshInterval {get;set;}
    public Boolean internalView {get;set;}    
    
    private boolean isFEUser{get;set;}
    private boolean isTapeoutOperation{get;set;}
    private boolean isMDP{get;set;}
    private boolean isGlobalShuttle{get;set;}
    private boolean isTDTIMPW{get;set;}
    private boolean isFoundryJobviewer{get;set;}
    private boolean isSwiftAdmin{get;set;}
    private boolean isSwiftRMG{get;set;}
    private boolean isSwiftTapeoutAdmin{get;set;}
    private boolean isSwiftTapeoutApplication{get;set;}
    private boolean isSwiftTapeoutCentre{get;set;}
    
    public List<LayerChipSummaryWrapper> lstLayerChipWrapper{get;set;}
    public List<MRS_Layer_Chip_Association__c> lstLayerChipSummary{get;set;}
    public List<MRS_Layer_Chip_Association__c> lstLayerChipSummaryOld{get;set;}
    public boolean isValidCustomer {get;set;}
    public boolean boolIsVoidApplicable{get;set;}
    public boolean boolGDSOUTReviewCustomer{get;set;}
    public boolean boolGDSOUTReviewFoundry{get;set;}
    public boolean boolFrameMockupCustomer{get;set;}
    public boolean boolFrameMockupFoundry{get;set;}
    public boolean boolSendDataPrime{get;set;}
    public boolean boolSendDataFrame{get;set;}
    public boolean boolDRW{get;set;}
    public boolean boolORC{get;set;}
    public boolean boolCustomerRemoteJobviewPrime{get;set;}
    public boolean boolCustomerRemoteJobviewFrame{get;set;}
    public boolean boolFoundryRemoteJobviewPrime{get;set;}
    public boolean boolFoundryRemoteJobviewFrame{get;set;}
    public boolean boolMEBESReceivedPrime{get;set;}
    public boolean boolMEBESReceivedFrame{get;set;}
    public boolean boolMEBESJobviewCustomer{get;set;}
    public boolean boolMEBESJobviewFoundry{get;set;}
    public boolean boolMEBESJobviewTapeoutCenter{get;set;}
    public boolean boolMEBESJobviewTapeoutAPPLICATIONS{get;set;}
    public boolean boolMEBESJobviewGlobalShuttle{get;set;}
    public boolean boolMEBESJobviewMDP{get;set;}
    public boolean boolMEBESJobviewTDTIMPW{get;set;}
   
    public boolean boolAll{get;set;}
    public boolean boolGDSOUT{get;set;}
    public boolean boolFrameMockup{get;set;}
    public boolean boolSendData{get;set;}
    public boolean boolRemoteJobview{get;set;}
    public boolean boolORC1{get;set;}
    public boolean boolDRW1{get;set;}
    public boolean boolMebesRecieved{get;set;}
    public boolean boolMebesJobview{get;set;}
    
    public boolean boolShowGDSOUT{get;set;}
    public boolean boolShowFrameMockup{get;set;}
    public boolean boolShowSendData{get;set;}
    public boolean boolShowRemoteJobview{get;set;}
    public boolean boolShowORC{get;set;}
    public boolean boolShowDRW{get;set;}
    public boolean boolShowMebesRecieved{get;set;}
    public boolean boolShowMebesJobview{get;set;}
    
    public boolean boolIsMailSent{get;set;}
    
    public List<String> SWIFT_FE_ROLES {get;set;} {
       Environment_Variable__c tempEnv = [SELECT Value__c FROM Environment_Variable__c WHERE Name = 'SwiftFETeamRoles' LIMIT 1];
       SWIFT_FE_ROLES = String.valueOf(tempEnv.Value__c).split(',');
    }
       
    public boolean boolIsManualUpdateApplicable{get;set;}
    public list<integer> lstSizeOne {get;set;}
    public boolean boolShowTechGeo{get;set;}
    public string  strTechGeo{get;set;}
    Public String ValueCatcher {get;set;} { ValueCatcher = DefaultLayerSummaryValues(); }    
    public map<String,set<String>> mapManualUpdatePicklist{get;set;}
    private map<String,String> mapTechGeoValues{get;set;}
    public String techgeoSelectedText{get;set;}
    
    public Map<String,Map<String,String>> mapLayerChipStatusSettings {get;set;}
     
     public list<SelectOption> optionlistLayerStatus {
        get{
            list<SelectOption> stoption= new list<SelectOption>();
            if(listLayerList!=null && listLayerList.size()>0)
            {
                for(String obj : listLayerList)
                {
                    if(obj!=null){
                        stoption.add(new SelectOption(obj, obj));
                    }
                }
            }
            return stoption;
           }
         set; }
       
      public list<SelectOption> optionlistDevice {
        get{
            list<SelectOption> stoption= new list<SelectOption>();
            stoption.add(new SelectOption('',''));
            if(setDeviceId!=null && setDeviceId.size()>0)
            {
                for(String obj : setDeviceId)
                {
                    if(obj!=null){
                        stoption.add(new SelectOption(obj, obj));
                    }
                }
                stoption.sort();
            }
            return stoption;
           }
         set; }    
      
      
       public list<SelectOption> optionlistPTRFnDRT {
        get{
            list<SelectOption> stoption= new list<SelectOption>();
            stoption.add(new SelectOption('',''));
            if(setPTRFnDRT!=null && setPTRFnDRT.size()>0)
            {
            for(String obj : setPTRFnDRT)
            {
                if(obj!=null){
                    stoption.add(new SelectOption(obj, obj));
                }
            }
            stoption.sort();
            }
            return stoption;
           }
         set; }   
         
         public list<SelectOption> optionlistTechGeo {
        get{
            list<SelectOption> stoption= new list<SelectOption>();
            stoption.add(new SelectOption('',''));
            if(setTechGeo!=null && setTechGeo.size()>0)
            {
            for(String obj : setTechGeo)
            {
                if(obj!=null){
                    stoption.add(new SelectOption(obj.split(':')[1], obj.split(':')[0]));
                }
            }
            stoption.sort();
            }
            return stoption;
           }
         set; }
         
         public list<SelectOption> listCustomerGDSOUTReview{
         get{
            list<SelectOption> stoption= new list<SelectOption>();
            stoption.add(new SelectOption('',''));
            set<String> setTemp=new set<String>();
            setTemp=mapManualUpdatePicklist.get('Customer_GDSOUT_Review__c');
            if(setTemp!=null && setTemp.size()>0)
            {
            for(String obj : setTemp)
            {
                if(obj!=null){
                    stoption.add(new SelectOption(obj, obj));
                }
            }
            
            }
            return stoption;
           }
         set; }
       
        public list<SelectOption> listFoundryGDSOUTReview{
         get{
            list<SelectOption> stoption= new list<SelectOption>();
            stoption.add(new SelectOption('',''));
            set<String> setTemp=new set<String>();
            setTemp=mapManualUpdatePicklist.get('Foundry_GDSOUT_Review__c');
            if(setTemp!=null && setTemp.size()>0)
            {
            for(String obj : setTemp)
            {
                if(obj!=null){
                    stoption.add(new SelectOption(obj, obj));
                }
            }
            }
            return stoption;
           }
         set; }
         
          public list<SelectOption> listCustomerFrameMockup{
         get{
            list<SelectOption> stoption= new list<SelectOption>();
            stoption.add(new SelectOption('',''));
            set<String> setTemp=new set<String>();
            setTemp=mapManualUpdatePicklist.get('Customer_Frame_Mockup__c');
            if(setTemp!=null && setTemp.size()>0)
            {
            for(String obj : setTemp)
            {
                if(obj!=null){
                    stoption.add(new SelectOption(obj, obj));
                }
            }
            }
            return stoption;
           }
         set; }
         
          public list<SelectOption> listFoundryFrameMockup{
         get{
            list<SelectOption> stoption= new list<SelectOption>();
            stoption.add(new SelectOption('',''));
            set<String> setTemp=new set<String>();
            setTemp=mapManualUpdatePicklist.get('Foundry_Frame_Mockup__c');
            if(setTemp!=null && setTemp.size()>0)
            {
            for(String obj : setTemp)
            {
                if(obj!=null){
                    stoption.add(new SelectOption(obj, obj));
                }
            }
            }
            return stoption;
           }
         set; }
         
          public list<SelectOption> listSendPrimeData{
         get{
            list<SelectOption> stoption= new list<SelectOption>();
            stoption.add(new SelectOption('',''));
            set<String> setTemp=new set<String>();
            setTemp=mapManualUpdatePicklist.get('Send_Prime_Data__c');
            if(setTemp!=null && setTemp.size()>0)
            {
            for(String obj : setTemp)
            {
                if(obj!=null){
                    stoption.add(new SelectOption(obj, obj));
                }
            }
            }
            return stoption;
           }
         set; }
         
          public list<SelectOption> listSendFrameData{
         get{
            list<SelectOption> stoption= new list<SelectOption>();
            stoption.add(new SelectOption('',''));
            set<String> setTemp=new set<String>();
            setTemp=mapManualUpdatePicklist.get('Send_Frame_Data__c');
            if(setTemp!=null && setTemp.size()>0)
            {
            for(String obj : setTemp)
            {
                if(obj!=null){
                    stoption.add(new SelectOption(obj, obj));
                }
            }
            }
            return stoption;
           }
         set; }
         
          public list<SelectOption> listORC{
         get{
            list<SelectOption> stoption= new list<SelectOption>();
            stoption.add(new SelectOption('',''));
            set<String> setTemp=new set<String>();
            setTemp=mapManualUpdatePicklist.get('ORC__c');
            if(setTemp!=null && setTemp.size()>0)
            {
            for(String obj : setTemp)
            {
                if(obj!=null){
                    stoption.add(new SelectOption(obj, obj));
                }
            }
            }
            return stoption;
           }
         set; }
         
          public list<SelectOption> listDRW{
         get{
            list<SelectOption> stoption= new list<SelectOption>();
            stoption.add(new SelectOption('',''));
            set<String> setTemp=new set<String>();
            setTemp=mapManualUpdatePicklist.get('DRW__c');
            if(setTemp!=null && setTemp.size()>0)
            {
            for(String obj : setTemp)
            {
                if(obj!=null){
                    stoption.add(new SelectOption(obj, obj));
                }
            }
            }
            return stoption;
           }
         set; }
         
         
           public list<SelectOption> listCustomerPrimeRemoteJobviewSetup{
         get{
            list<SelectOption> stoption= new list<SelectOption>();
            stoption.add(new SelectOption('',''));
            set<String> setTemp=new set<String>();
            setTemp.add('N.A.');
            setTemp.add('Done');
            if(setTemp!=null && setTemp.size()>0)
            {
            for(String obj : setTemp)
            {
                if(obj!=null){
                    stoption.add(new SelectOption(obj, obj));
                }
            }
            }
            return stoption;
           }
         set; }
         
         
            public list<SelectOption> listCustomerFrameRemoteJobviewSetup{
         get{
            list<SelectOption> stoption= new list<SelectOption>();
            stoption.add(new SelectOption('',''));
            set<String> setTemp=new set<String>();
            setTemp.add('N.A.');
            setTemp.add('Done');
            if(setTemp!=null && setTemp.size()>0)
            {
            for(String obj : setTemp)
            {
                if(obj!=null){
                    stoption.add(new SelectOption(obj, obj));
                }
            }
            }
            return stoption;
           }
         set; }
         
         
         
            public list<SelectOption> listFoundryPrimeRemoteJobviewSetup{
         get{
            list<SelectOption> stoption= new list<SelectOption>();
            stoption.add(new SelectOption('',''));
            set<String> setTemp=new set<String>();
            setTemp.add('N.A.');
            setTemp.add('Done');
            if(setTemp!=null && setTemp.size()>0)
            {
            for(String obj : setTemp)
            {
                if(obj!=null){
                    stoption.add(new SelectOption(obj, obj));
                }
            }
            }
            return stoption;
           }
         set; }
         
         
         
            public list<SelectOption> listFoundryFrameRemoteJobviewSetup{
         get{
            list<SelectOption> stoption= new list<SelectOption>();
            stoption.add(new SelectOption('',''));
            set<String> setTemp=new set<String>();
            setTemp.add('N.A.');
            setTemp.add('Done');
            if(setTemp!=null && setTemp.size()>0)
            {
            for(String obj : setTemp)
            {
                if(obj!=null){
                    stoption.add(new SelectOption(obj, obj));
                }
            }
            }
            return stoption;
           }
         set; }
         
         
          public list<SelectOption> listPrimeMEBESReceived{
         get{
            list<SelectOption> stoption= new list<SelectOption>();
            stoption.add(new SelectOption('',''));
            set<String> setTemp=new set<String>();
            setTemp=mapManualUpdatePicklist.get('Prime_MEBES_Received__c');
            if(setTemp!=null && setTemp.size()>0)
            {
            for(String obj : setTemp)
            {
                if(obj!=null){
                    stoption.add(new SelectOption(obj, obj));
                }
            }
            }
            return stoption;
           }
         set; }
         
          public list<SelectOption> listFrameMEBESReceived{
         get{
            list<SelectOption> stoption= new list<SelectOption>();
            stoption.add(new SelectOption('',''));
            set<String> setTemp=new set<String>();
            setTemp=mapManualUpdatePicklist.get('Frame_MEBES_Received__c');
            if(setTemp!=null && setTemp.size()>0)
            {
            for(String obj : setTemp)
            {
                if(obj!=null){
                    stoption.add(new SelectOption(obj, obj));
                }
            }
            }
            return stoption;
           }
         set; }
         
          public list<SelectOption> listCustomerMEBESJobview{
         get{
            list<SelectOption> stoption= new list<SelectOption>();
            stoption.add(new SelectOption('',''));
            set<String> setTemp=new set<String>();
            setTemp=mapManualUpdatePicklist.get('Customer_MEBES_Jobview__c');
            if(setTemp!=null && setTemp.size()>0)
            {
            for(String obj : setTemp)
            {
                if(obj!=null){
                    stoption.add(new SelectOption(obj, obj));
                }
            }
            }
            return stoption;
           }
         set; }
         
          public list<SelectOption> listFoundryMEBESJobview{
         get{
            list<SelectOption> stoption= new list<SelectOption>();
            stoption.add(new SelectOption('',''));
            set<String> setTemp=new set<String>();
            setTemp=mapManualUpdatePicklist.get('Foundry_MEBES_Jobview__c');
            if(setTemp!=null && setTemp.size()>0)
            {
            for(String obj : setTemp)
            {
                if(obj!=null){
                    stoption.add(new SelectOption(obj, obj));
                }
            }
            }
            return stoption;
           }
         set; }
         
          public list<SelectOption> listTapeoutCentreMEBESJobview{
         get{
            list<SelectOption> stoption= new list<SelectOption>();
            stoption.add(new SelectOption('',''));
            set<String> setTemp=new set<String>();
            setTemp=mapManualUpdatePicklist.get('Tapeout_Centre_MEBES_Jobview__c');
            if(setTemp!=null && setTemp.size()>0)
            {
            for(String obj : setTemp)
            {
                if(obj!=null){
                    stoption.add(new SelectOption(obj, obj));
                }
            }
            }
            return stoption;
           }
         set; }
         
          public list<SelectOption> listTapeoutApplicationsMEBESJobview{
         get{
            list<SelectOption> stoption= new list<SelectOption>();
            stoption.add(new SelectOption('',''));
            set<String> setTemp=new set<String>();
            setTemp=mapManualUpdatePicklist.get('Tapeout_Applications_MEBES_Jobview__c');
            if(setTemp!=null && setTemp.size()>0)
            {
            for(String obj : setTemp)
            {
                if(obj!=null){
                    stoption.add(new SelectOption(obj, obj));
                }
            }
            }
            return stoption;
           }
         set; }
         
          public list<SelectOption> listGlobalShuttleMEBESJobview{
         get{
            list<SelectOption> stoption= new list<SelectOption>();
            stoption.add(new SelectOption('',''));
            set<String> setTemp=new set<String>();
            setTemp=mapManualUpdatePicklist.get('GlobalShuttle_MEBES_Jobview__c');
            if(setTemp!=null && setTemp.size()>0)
            {
            for(String obj : setTemp)
            {
                if(obj!=null){
                    stoption.add(new SelectOption(obj, obj));
                }
            }
            }
            return stoption;
           }
         set; }
         
          public list<SelectOption> listMDPMEBESJobview{
         get{
            list<SelectOption> stoption= new list<SelectOption>();
            stoption.add(new SelectOption('',''));
            set<String> setTemp=new set<String>();
            setTemp=mapManualUpdatePicklist.get('MDP_MEBES_Jobview__c');
            if(setTemp!=null && setTemp.size()>0)
            {
            for(String obj : setTemp)
            {
                if(obj!=null){
                    stoption.add(new SelectOption(obj, obj));
                }
            }
            }
            return stoption;
           }
         set; }
         
          public list<SelectOption> listTDTIMPWMEBESJobview{
         get{
            list<SelectOption> stoption= new list<SelectOption>();
            stoption.add(new SelectOption('',''));
            set<String> setTemp=new set<String>();
            setTemp=mapManualUpdatePicklist.get('TDTI_MPW_MEBES_Jobview__c');
            if(setTemp!=null && setTemp.size()>0)
            {
            for(String obj : setTemp)
            {
                if(obj!=null){
                    stoption.add(new SelectOption(obj, obj));
                }
            }
            }
            return stoption;
           }
         set; }
            
            
      public MRSLayerChipSummaryExtn(ApexPages.StandardController objController) {
           flagController=true;
           lstSizeOne = new list<integer>{1};       
           boolIsManualUpdateApplicable=false;          
           try {
            internalView = false;
            String hostName = ApexPages.currentPage().getHeaders().get('Host');
            if(!String.isBlank(System.Label.Internal_URL) && System.Label.Internal_URL.containsIgnoreCase(hostName)) {
                internalView = true;
            }
            else {
                internalView = false;
            }   
            idCurrentLayer=ApexPages.currentPage().getParameters().get('id');
            String url = ApexPages.currentPage().getHeaders().get('Host');
           
            
               if(url.contains(Label.Swift_Host_URL)){
                        isBreadcrumbActive = true;
                }else{
                      isBreadcrumbActive =false;
                }
            if(ApexPages.currentPage().getParameters().get('customerid')!=null){
                strCustomerId=ApexPages.currentPage().getParameters().get('customerid');
                setCustomerName(strCustomerId);
            }
            if(ApexPages.currentPage().getParameters().get('customer')!=null){
                strCustomer=ApexPages.currentPage().getParameters().get('customer');
            }
            if(ApexPages.currentPage().getParameters().get('mstid')!=null){
                strMstId=ApexPages.currentPage().getParameters().get('mstid');
            }
            MRS_Layer_Summary_Refresh_Interval__c temp = [select Page_Refresh_Frequency__c from MRS_Layer_Summary_Refresh_Interval__c LIMIT 1];
            refreshInterval = (Integer)temp.Page_Refresh_Frequency__c;
            if(idCurrentLayer!=null && !String.isempty(idCurrentLayer))
            {
               objLayerSummaryDetails = [SELECT Name,ROM_Code__c,Mask_Layer_Rev__c,Mask_Set_Title_Name__c,Layer_Status__c, Customer_GDSOUT_Review__c, Foundry_GDSOUT_Review__c, Customer_Frame_Mockup__c, Foundry_Frame_Mockup__c, Send_Prime_Data__c, Send_Frame_Data__c, ORC__c, DRW__c, Prime_MEBES_Received__c, Frame_MEBES_Received__c, Customer_MEBES_Jobview__c, Foundry_MEBES_Jobview__c, Tapeout_Centre_MEBES_Jobview__c, Tapeout_Applications_MEBES_Jobview__c, GlobalShuttle_MEBES_Jobview__c, MDP_MEBES_Jobview__c, TDTI_MPW_MEBES_Jobview__c, Customer_Prime_Remote_Jobview_Setup__c, Customer_Frame_Remote_Jobview_Setup__c, Foundry_Prime_Remote_Jobview_Setup__c, Foundry_Frame_Remote_Jobview_Setup__c,Tech_geo__c from MRS_Layer_Association__c where id=:idCurrentLayer LIMIT 1];
               populateFilterValues(idCurrentLayer);
               populateManualUpdatePicklist();
               if(ApexPages.currentPage().getParameters().get('layer_chip_status')!=null){
                    statusSelectedValue=ApexPages.currentPage().getParameters().get('layer_chip_status');
                    ValueCatcher =statusSelectedValue;
                    
               }else
               {
                   
                   statusSelectedValue=ValueCatcher ;
               }
               if(ApexPages.currentPage().getParameters().get('device_id')!=null){
                    deviceSelectedValue=ApexPages.currentPage().getParameters().get('device_id');
               }
               if(ApexPages.currentPage().getParameters().get('ptrf_drt')!=null){
                    ptrfSelectedValue=ApexPages.currentPage().getParameters().get('ptrf_drt');
               }
               if(ApexPages.currentPage().getParameters().get('tech_geo')!=null){
                    techgeoSelectedValue=ApexPages.currentPage().getParameters().get('tech_geo');
               }
               if(listLayerList!=null  && ValueCatcher!=null && ValueCatcher!=''){
                   strSelectedLayerChipStatus='';
                   if(listLayerList.size()>0){
                        for(string currentStatus : listLayerList){
                            if(ValueCatcher.containsignorecase(currentStatus)) strSelectedLayerChipStatus=strSelectedLayerChipStatus+currentStatus +',';
                        }
                        if(strSelectedLayerChipStatus.endswith(',')) strSelectedLayerChipStatus=strSelectedLayerChipStatus.removeend(',');
                    }
                }
               boolAll=true;
               viewLayerChipData();
               
               fetchStatusHierarchyFromSettings();
               isTechGeoViewable();
            }
            }catch(Exception e) {
                System.debug('$$: ' + e.getMessage());
                System.debug('$$StackTrace: ' + e.getStackTraceString());
            }       
      }
    
     /**
        This method is for determining the visibility of Tech Geo based on Reticle Type and formatting of Tech Geo field. 
        @method name: isTechGeoViewable
        @parameter:   null
        @return :     void
     **/  
     public void isTechGeoViewable()
        {
          
           String strMST;
           decimal dcmtechgeo;
           decimal finaldcmtechgeo;
           if(idCurrentLayer!=null && idCurrentLayer!=''){    
               List<MRS__c> listFilteredMRS=new List<MRS__c>() ;
               listFilteredMRS  = [SELECT  Mask_Set_Title__c from MRS__c where id in (select MRS__c from MRS_Layer_Association__c where id=:idCurrentLayer)];
               if(listFilteredMRS!=null && listFilteredMRS.size()>0){
                   strMST=listFilteredMRS[0].Mask_Set_Title__c;
                          
                    List<PTRF__C> listPTRF = [select Id, Recticle_Type__c,tech_geo__c from PTRF__C where MaskSetTitle__c =:strMST AND Recticle_Type__c = 'Multi Node Reticle (MNR)'];
                    if(listPTRF != NULL && listPTRF .size()>0 ){
                        boolShowTechGeo= true;
                        strTechGeo=objLayerSummaryDetails.Tech_Geo__c;
                        if(!strTechGeo.toUppercase().contains('UM')){
                             strTechGeo+='UM';
                        }
                        if(strTechGeo!=null && strTechGeo!='' && !strTechGeo.toLowercase().contains('nm')){
                            dcmtechgeo=Decimal.valueof(String.valueof(strTechGeo).touppercase().replace('UM',''));
                            if(dcmtechgeo<0.1){
                                finaldcmtechgeo=dcmtechgeo*1000;
                                strTechGeo=strTechGeo + ' ('+finaldcmtechgeo.round()+'nm)';
                            }
                           
                        }
                       
                    }
                    else{
                        boolShowTechGeo= false;
                    }  
                }
          }
        }
        
        /**
            This method is for determining the the List of Groups the user is assigned to. 
            @method name: getUserGroupList
            @parameter:   null
            @return :     List of Group objects
        **/   
        private List<Group> getUserGroupList()
        {
            List<Group> lstGroupNames=new List<Group>();
            List<groupmember> lstGroupMembers =new List<groupmember>();
            Set<String> setGrpId=new Set<String>(); 
           
            lstGroupMembers=[select groupid from groupmember where userorgroupid =:UserInfo.getUserId()];
            if(lstGroupMembers!=null && lstGroupMembers.size()>0)
            {
                for(groupmember objGrp:lstGroupMembers)
                {
                    if(objGrp.groupid!=null){
                        setGrpId.add(objGrp.groupid);
                    }
                }
                lstGroupNames=[select id,name,developername from group where id in:setGrpId];
            }
            return lstGroupNames;
        }
        
        /**
            This method is for setting the Column view permissions of the user based on the Group which he belongs and profile. 
            @method name: setViewPermissionForUser
            @parameter:   null
            @return :     void
        **/ 
        private void setViewPermissionForUser()
        {
            string strGroupName;
            if(isValidCustomer)
            {
                setFieldsForCustomer();
            }
            else
            {
                set<String> strGroupNameForSearch=new set<String>();
                List<Group> lstUserGroupNames=getUserGroupList();
                if(lstUserGroupNames!=null && lstUserGroupNames.size()>0)
                {
                     for(Group objGroup:lstUserGroupNames)
                     {
                    
                         if(objGroup.developername!=null && objGroup.developername!='')
                         {
                             strGroupName=objGroup.developername.trim();
                             if(strGroupName=='SWIFT_Admin')
                             {
                                 strGroupNameForSearch.add(String.valueof('SWIFT_Admin').touppercase());
                                 boolIsManualUpdateApplicable=true;
                                 boolIsVoidApplicable=true ;
                                 isSwiftAdmin=true;
                             }
                              if(strGroupName=='Swift_GlobalShuttle')
                             {
                                 strGroupNameForSearch.add(String.valueof('Swift_GlobalShuttle').touppercase());
                                 isGlobalShuttle=true;
                             }
                              if(strGroupName=='Swift_MDP')
                             {
                                 strGroupNameForSearch.add(String.valueof('Swift_MDP').touppercase());
                                 boolIsVoidApplicable=true;
                                 isMDP=true;
                             }
                              if(strGroupName=='SWIFT_Support')
                             {
                                 strGroupNameForSearch.add(String.valueof('SWIFT_Support').touppercase());
                                 boolIsManualUpdateApplicable=true; 
                             }
                              if(strGroupName=='Swift_Tapeout_Application')
                             {
                                 strGroupNameForSearch.add(String.valueof('Swift_Tapeout_Application').touppercase());
                                 isSwiftTapeoutApplication=true;
                             }
                              if(strGroupName=='Swift_Tapeout_Centre')
                             {
                                 strGroupNameForSearch.add(String.valueof('Swift_Tapeout_Centre').touppercase());
                                 boolIsVoidApplicable=true;
                                 boolIsManualUpdateApplicable=true;
                                 isSwiftTapeoutCentre=true;
                             }
                              if(strGroupName=='Swift_Tapeout_Operations')
                             {
                                 strGroupNameForSearch.add(String.valueof('Swift_Tapeout_Operations').touppercase());
                                 isTapeoutOperation=true;
                             }
                              if(strGroupName=='Swift_TDTI_MPW')
                             {
                                 strGroupNameForSearch.add(String.valueof('Swift_TDTI_MPW').touppercase());
                                 isTDTIMPW=true;
                             }
                              if(strGroupName=='Swift_Foundry_Jobviewer')
                             {
                                 strGroupNameForSearch.add(String.valueof('Swift_Foundry_Jobviewer').touppercase());
                                 isFoundryJobviewer=true;
                             }
                              if(strGroupName=='Swift_RMG')
                             {
                                 strGroupNameForSearch.add(String.valueof('Swift_RMG').touppercase());
                                 isSwiftRMG=true;
                             }
                              if(strGroupName=='SWIFT_CAD')
                             {
                                 strGroupNameForSearch.add(String.valueof('SWIFT_CAD').touppercase());
                             }
                              if(strGroupName=='Swift_Tapeout_Admin')
                             {
                                 strGroupNameForSearch.add(String.valueof('Swift_Tapeout_Admin').touppercase());
                                 isSwiftTapeoutAdmin=true;
                             }
                         }
                     }    
                }   
                      
                Map<String,MRS_Fields_Permission_Config__c> mapPFPC = MRS_Fields_Permission_Config__c.getAll();
                for (String fieldName : mapPFPC.keySet())
                {
                    if(strGroupNameForSearch.contains(fieldName.touppercase()))
                    {
                        setFieldsForInternalUser(mapPFPC.get(fieldName));
                    }
                }
             }
         
        }
        
        /**
            This method is for setting the Column view permissions of Customer user based on the permissions in Customer_Layer_Summary_Permission__c . 
            @method name: setFieldsForCustomer
            @parameter:   null
            @return :     void
        **/
         public void setFieldsForCustomer()
        {
            Customer_Layer_Summary_Permission__c customerFieldPermission = [select Customer__c, Customer_Remote_Jobview__c, Customer_Short_Name__c, Frame_Mockup__c, GDSOUT_Review__c, MEBES_Jobview__c from Customer_Layer_Summary_Permission__c where Customer__c =:strCustomerId LIMIT 1];
       
            if(customerFieldPermission!=null)
            {
                if(customerFieldPermission.GDSOUT_Review__c !=null)
                   {
                       boolGDSOUTReviewCustomer=customerFieldPermission.GDSOUT_Review__c;
                   }
                if(customerFieldPermission.Frame_Mockup__c!=null)
                   {
                       boolFrameMockupCustomer=customerFieldPermission.Frame_Mockup__c;
                   }         
                if(customerFieldPermission.Customer_Remote_Jobview__c!=null)
                   {
                       boolCustomerRemoteJobviewPrime=customerFieldPermission.Customer_Remote_Jobview__c;
                   }
                if(customerFieldPermission.Customer_Remote_Jobview__c!=null)
                   {
                       boolCustomerRemoteJobviewFrame=customerFieldPermission.Customer_Remote_Jobview__c;
                   }
              
                if(customerFieldPermission.MEBES_Jobview__c!=null)
                   {
                       boolMEBESJobviewCustomer=customerFieldPermission.MEBES_Jobview__c;
                   }
            }
        }
        
        /**
            This method is for setting the default visibility of user, all visibility for SysAdmin and customized visibility of FE User. 
            @method name: setDefaultValues
            @parameter:   null
            @return :     void
        **/
        public void setDefaultValues()
        {
        
            User loggedInUser =[SELECT Id,AccountId,Name,ProfileId FROM User WHERE Id =:UserInfo.getUserId()];
            Profile profileSysAdmin = [Select Id, name from Profile where name='System Administrator' LIMIT 1];
            if([SELECT Team_Role__c, User__c FROM Account_Team_Proxy__c WHERE Team_Role__c IN: SWIFT_FE_ROLES and User__c =:loggedInUser.Id].size()>0){
                        isFEUser = true;
                    }
                    else{
                        isFEUser= false;
                    }
                    
            isTapeoutOperation=false;
            isMDP=false;
            isGlobalShuttle=false;
            isTDTIMPW=false;
            isFoundryJobviewer=false;
            isSwiftAdmin=false;
            isSwiftRMG=false;
            isSwiftTapeoutAdmin=false;
            isSwiftTapeoutApplication=false;
            isSwiftTapeoutCentre=false;
            
            isValidCustomer = false;
            if(loggedInUser.AccountId!=null)
             {
                isValidCustomer = true;         
             }
            else
             {          
                isValidCustomer = false;            
             }
            
            
            if(loggedInUser.ProfileId == profileSysAdmin.Id ){ 
               
                boolIsManualUpdateApplicable=true;
                boolIsVoidApplicable=true;
                boolSendDataPrime=true;
                boolSendDataFrame=true;
                boolGDSOUTReviewCustomer=true;
                boolGDSOUTReviewFoundry=true;
                boolFrameMockupCustomer=true;
                boolFrameMockupFoundry=true;
                boolDRW=true;
                boolORC=true;
                boolCustomerRemoteJobviewPrime=true;
                boolCustomerRemoteJobviewFrame=true;
                boolFoundryRemoteJobviewPrime=true;
                boolFoundryRemoteJobviewFrame=true;
                boolMEBESReceivedPrime=true;
                boolMEBESReceivedFrame=true;
                boolMEBESJobviewCustomer=true;
                boolMEBESJobviewFoundry=true;
                boolMEBESJobviewTapeoutCenter=true;
                
                //swgp-859
                //boolMEBESJobviewTapeoutAPPLICATIONS=true;
                boolMEBESJobviewTapeoutAPPLICATIONS=false;
                
                boolMEBESJobviewGlobalShuttle=true;
                boolMEBESJobviewMDP=true;
                boolMEBESJobviewTDTIMPW  =true;
                
        
           }
           else
           {   
                boolIsVoidApplicable=false;
                boolGDSOUTReviewCustomer=false;
                boolGDSOUTReviewFoundry=false;
                boolFrameMockupCustomer=false;
                boolFrameMockupFoundry=false;
                boolSendDataPrime=false;
                boolSendDataFrame=false;
                boolDRW=false;
                boolORC=false;
                boolCustomerRemoteJobviewPrime=false;
                boolCustomerRemoteJobviewFrame=false;
                boolFoundryRemoteJobviewPrime=false;
                boolFoundryRemoteJobviewFrame=false;
                boolMEBESReceivedPrime=false;
                boolMEBESReceivedFrame=false;
                boolMEBESJobviewCustomer=false;
                boolMEBESJobviewFoundry=false;
                boolMEBESJobviewTapeoutCenter=false;
                boolMEBESJobviewTapeoutAPPLICATIONS=false;
                boolMEBESJobviewGlobalShuttle=false;
                boolMEBESJobviewMDP=false;
                boolMEBESJobviewTDTIMPW  =false;
           }    
           if(isFEUser == true){
                 Map<String,MRS_Fields_Permission_Config__c> mapPFPC = MRS_Fields_Permission_Config__c.getAll();
                   if(mapPFPC!=null && mapPFPC.get('SWIFT_FE')!=null)
                    {
                        setFieldsForInternalUser(mapPFPC.get('SWIFT_FE'));
                    }
                
            }   
        }
        
        /**
            This method is for setting the visibility of internal user based on the settings in MRS_Fields_Permission_Config__c. 
            @method name: setFieldsForInternalUser
            @parameter:   MRS_Fields_Permission_Config__c  object
            @return :     void
        **/
        private void setFieldsForInternalUser(MRS_Fields_Permission_Config__c objFieldPermission)
        {
            if(objFieldPermission!=null)
            {
                if(boolGDSOUTReviewCustomer==false)
                   {
                       boolGDSOUTReviewCustomer=objFieldPermission.GDSOUTReviewCustomer__c;
                   }
                if(boolGDSOUTReviewFoundry==false)
                   {
                       boolGDSOUTReviewFoundry=objFieldPermission.GDSOUTReviewFoundry__c;
                   }
                if(boolFrameMockupCustomer==false)
                   {
                       boolFrameMockupCustomer=objFieldPermission.FrameMockupCustomer__c;
                   }
                if(boolFrameMockupFoundry==false)
                   {
                       boolFrameMockupFoundry=objFieldPermission.FrameMockupFoundry__c;
                   }
                if(boolSendDataPrime==false)
                   {
                       boolSendDataPrime=objFieldPermission.SendDataPrime__c;
                   }
                if(boolSendDataFrame==false)
                   {
                       boolSendDataFrame=objFieldPermission.SendDataFrame__c;
                   }
                if(boolDRW==false)
                   {
                       boolDRW=objFieldPermission.DRW__c;
                   }
                if(boolORC==false)
                   {
                       boolORC=objFieldPermission.ORC__c;
                   }
                if(boolCustomerRemoteJobviewPrime==false)
                   {
                       boolCustomerRemoteJobviewPrime=objFieldPermission.CustomerRemoteJobviewPrime__c;
                   }
                if(boolCustomerRemoteJobviewFrame==false)
                   {
                       boolCustomerRemoteJobviewFrame=objFieldPermission.CustomerRemoteJobviewFrame__c;
                   }
                if(boolFoundryRemoteJobviewPrime==false)
                   {
                       boolFoundryRemoteJobviewPrime=objFieldPermission.FoundryRemoteJobviewPrime__c;
                   }
                if(boolFoundryRemoteJobviewFrame==false)
                   {
                       boolFoundryRemoteJobviewFrame=objFieldPermission.FoundryRemoteJobviewFrame__c;
                   }
                if(boolMEBESReceivedPrime==false)
                   {
                       boolMEBESReceivedPrime=objFieldPermission.MEBESReceivedPrime__c;
                   }
                if(boolMEBESReceivedFrame==false)
                   {
                       boolMEBESReceivedFrame=objFieldPermission.MEBESReceivedFrame__c;
                   }
                if(boolMEBESJobviewCustomer==false)
                   {
                       boolMEBESJobviewCustomer=objFieldPermission.MEBESJobviewCustomer__c;
                   }
                if(boolMEBESJobviewFoundry==false)
                   {
                       boolMEBESJobviewFoundry=objFieldPermission.MEBESJobviewFoundry__c;
                   }
                if(boolMEBESJobviewTapeoutCenter==false)
                   {
                       boolMEBESJobviewTapeoutCenter=objFieldPermission.MEBESJobviewTapeoutCenter__c;
                   }
                
                //swgp-859
                //if(boolMEBESJobviewTapeoutAPPLICATIONS==false)
                //   {
                //      //swgp-859
                //      //boolMEBESJobviewTapeoutAPPLICATIONS=false;
                //       //boolMEBESJobviewTapeoutAPPLICATIONS=objFieldPermission.MEBESJobviewTapeoutAPPLICATIONS__c;
                //   }
                
                if(boolMEBESJobviewGlobalShuttle==false)
                   {
                       boolMEBESJobviewGlobalShuttle=objFieldPermission.MEBESJobviewGlobalShuttle__c;
                   }
                if(boolMEBESJobviewMDP==false)
                   {
                       boolMEBESJobviewMDP=objFieldPermission.MEBESJobviewMDP__c;
                   }
                if(boolMEBESJobviewTDTIMPW ==false )
                   {
                       boolMEBESJobviewTDTIMPW  =objFieldPermission.MEBESJobviewTDTIMPW__c;
                   }
            }
           
        }
    
      /**
            This method is for setting the final visibility of user based on his priveleges and checkbox selected from UI. 
            @method name: setFieldsForFilter
            @parameter:   null
            @return :     void
        **/
     private void setFieldsForFilter()
        {
            
              
        
              boolean   boolGDSOUTReviewCustomerTemp=false;
              boolean   boolGDSOUTReviewFoundryTemp=false;
              boolean   boolFrameMockupCustomerTemp=false;
              boolean   boolFrameMockupFoundryTemp=false;
              boolean   boolSendDataPrimeTemp=false;
              boolean   boolSendDataFrameTemp=false;
              boolean   boolDRWTemp=false;
              boolean   boolORCTemp=false;
              boolean   boolCustomerRemoteJobviewPrimeTemp=false;
              boolean   boolCustomerRemoteJobviewFrameTemp=false;
              boolean   boolFoundryRemoteJobviewPrimeTemp=false;
              boolean   boolFoundryRemoteJobviewFrameTemp=false;
              boolean   boolMEBESReceivedPrimeTemp=false;
              boolean   boolMEBESReceivedFrameTemp=false;
              boolean   boolMEBESJobviewCustomerTemp=false;
              boolean   boolMEBESJobviewFoundryTemp=false;
              boolean   boolMEBESJobviewTapeoutCenterTemp=false;
              boolean   boolMEBESJobviewTapeoutAPPLICATIONSTemp=false;
              boolean   boolMEBESJobviewGlobalShuttleTemp=false;
              boolean   boolMEBESJobviewMDPTemp=false;
              boolean   boolMEBESJobviewTDTIMPWTemp  =false;
              
            
            if(boolAll!=true)
            {
                
                if(boolGDSOUT==true)
                {
                    
                     boolGDSOUTReviewCustomerTemp=true;
                     boolGDSOUTReviewFoundryTemp=true;
                   
                     
                }
                 if(boolFrameMockup==true)
                {
                     
                     boolFrameMockupCustomerTemp=true;
                     boolFrameMockupFoundryTemp=true;
                   
                    
                }
                   if(boolSendData==true)
                {
                     
                     boolSendDataPrimeTemp=true;
                     boolSendDataFrameTemp=true;
                    
                    
                }
                   if(boolRemoteJobview==true)
                {
                     
                     boolCustomerRemoteJobviewPrimeTemp=true;
                     boolCustomerRemoteJobviewFrameTemp=true;
                     boolFoundryRemoteJobviewPrimeTemp=true;
                     boolFoundryRemoteJobviewFrameTemp=true;
                    
                }
                   if(boolORC1==true)
                {
                     boolORCTemp=true;
                   
                }
                   if(boolDRW1==true)
                {
                     boolDRWTemp=true;
                   
                }
                   if(boolMebesRecieved==true)
                {
                     boolMEBESReceivedPrimeTemp=true;
                     boolMEBESReceivedFrameTemp=true;
                   
                }
                   if(boolMebesJobview==true)
                {
                     boolMEBESJobviewCustomerTemp=true;
                     boolMEBESJobviewFoundryTemp=true;
                     boolMEBESJobviewTapeoutCenterTemp=true;
                     boolMEBESJobviewTapeoutAPPLICATIONSTemp=true;
                     boolMEBESJobviewGlobalShuttleTemp=true;
                     boolMEBESJobviewMDPTemp=true;
                     boolMEBESJobviewTDTIMPWTemp  =true;
                   
                }
                
            }else{
                
                 boolGDSOUTReviewCustomerTemp=true;
                  boolGDSOUTReviewFoundryTemp=true;
                  boolFrameMockupCustomerTemp=true;
                  boolFrameMockupFoundryTemp=true;
                  boolSendDataPrimeTemp=true;
                  boolSendDataFrameTemp=true;
                  boolDRWTemp=true;
                  boolORCTemp=true;
                  boolCustomerRemoteJobviewPrimeTemp=true;
                  boolCustomerRemoteJobviewFrameTemp=true;
                  boolFoundryRemoteJobviewPrimeTemp=true;
                  boolFoundryRemoteJobviewFrameTemp=true;
                  boolMEBESReceivedPrimeTemp=true;
                  boolMEBESReceivedFrameTemp=true;
                  boolMEBESJobviewCustomerTemp=true;
                  boolMEBESJobviewFoundryTemp=true;
                  boolMEBESJobviewTapeoutCenterTemp=true;
                  boolMEBESJobviewTapeoutAPPLICATIONSTemp=true;
                  boolMEBESJobviewGlobalShuttleTemp=true;
                  boolMEBESJobviewMDPTemp=true;
                  boolMEBESJobviewTDTIMPWTemp  =true;
            }
           
                boolGDSOUTReviewCustomer=(boolGDSOUTReviewCustomer==true && boolGDSOUTReviewCustomerTemp==true) ? true:false;
                boolGDSOUTReviewFoundry=(boolGDSOUTReviewFoundry==true && boolGDSOUTReviewFoundryTemp==true) ? true:false;
                boolFrameMockupCustomer=(boolFrameMockupCustomer==true &&boolFrameMockupCustomerTemp==true) ? true:false;
                boolFrameMockupFoundry=(boolFrameMockupFoundry==true &&boolFrameMockupFoundryTemp==true) ? true:false;
                boolSendDataPrime=(boolSendDataPrime==true && boolSendDataPrimeTemp==true) ? true:false;
                boolSendDataFrame=(boolSendDataFrame==true && boolSendDataFrameTemp==true) ? true:false;
                boolCustomerRemoteJobviewPrime=(boolCustomerRemoteJobviewPrime==true && boolCustomerRemoteJobviewPrimeTemp==true) ? true:false;
                boolCustomerRemoteJobviewFrame=(boolCustomerRemoteJobviewFrame==true && boolCustomerRemoteJobviewFrameTemp==true) ? true:false;
                boolFoundryRemoteJobviewPrime=(boolFoundryRemoteJobviewPrime==true && boolFoundryRemoteJobviewPrimeTemp==true) ? true:false;
                boolFoundryRemoteJobviewFrame=(boolFoundryRemoteJobviewFrame==true && boolFoundryRemoteJobviewFrameTemp==true) ? true:false;
                boolORC=(boolORC==true && boolORCTemp==true) ? true:false;
                boolDRW=(boolDRW==true && boolDRWTemp==true)? true:false;
                boolMEBESReceivedPrime=(boolMEBESReceivedPrime==true && boolMEBESReceivedPrimeTemp==true)? true:false;
                boolMEBESReceivedFrame=(boolMEBESReceivedFrame==true && boolMEBESReceivedFrameTemp==true) ? true:false;
                boolMEBESJobviewCustomer=(boolMEBESJobviewCustomer==true && boolMEBESJobviewCustomerTemp==true) ? true:false;
                boolMEBESJobviewFoundry=(boolMEBESJobviewFoundry==true && boolMEBESJobviewFoundryTemp==true)? true:false;
                boolMEBESJobviewTapeoutCenter=(boolMEBESJobviewTapeoutCenter==true && boolMEBESJobviewTapeoutCenterTemp==true) ? true:false;
                
                //swgp-859
                //boolMEBESJobviewTapeoutAPPLICATIONS=(boolMEBESJobviewTapeoutAPPLICATIONS==true && boolMEBESJobviewTapeoutAPPLICATIONSTemp==true) ? true:false;
                boolMEBESJobviewTapeoutAPPLICATIONS = false;
                
                boolMEBESJobviewGlobalShuttle=(boolMEBESJobviewGlobalShuttle==true && boolMEBESJobviewGlobalShuttleTemp==true) ? true:false;
                boolMEBESJobviewMDP=(boolMEBESJobviewMDP==true && boolMEBESJobviewMDPTemp==true) ? true:false;
                boolMEBESJobviewTDTIMPW=(boolMEBESJobviewTDTIMPW==true && boolMEBESJobviewTDTIMPWTemp==true) ? true:false;
           
        }
        
    /**
            This method is for populating picklist values. 
            @method name: populateManualUpdatePicklist
            @parameter:   null
            @return :     void
    **/    
    public void populateManualUpdatePicklist()
    {
        set<String> setPickList=new set<String>(); 
        mapManualUpdatePicklist=new map<String,set<String>>();
        
        setPickList.addall(getPicklistValues('mrs_layer_chip_association__c','Customer_GDSOUT_Review__c'));
        mapManualUpdatePicklist.put('Customer_GDSOUT_Review__c',setPickList);
        setPickList=new set<String>(); 
        
        setPickList.addall(getPicklistValues('mrs_layer_chip_association__c','Foundry_GDSOUT_Review__c'));
        mapManualUpdatePicklist.put('Foundry_GDSOUT_Review__c',setPickList);
        setPickList=new set<String>(); 
        
        setPickList.addall(getPicklistValues('mrs_layer_chip_association__c','Customer_Frame_Mockup__c'));
        mapManualUpdatePicklist.put('Customer_Frame_Mockup__c',setPickList);
        setPickList=new set<String>(); 
        
        setPickList.addall(getPicklistValues('mrs_layer_chip_association__c','Foundry_Frame_Mockup__c'));
        mapManualUpdatePicklist.put('Foundry_Frame_Mockup__c',setPickList);
        setPickList=new set<String>(); 
        
        setPickList.addall(getPicklistValues('mrs_layer_chip_association__c','Send_Prime_Data__c'));
        mapManualUpdatePicklist.put('Send_Prime_Data__c',setPickList);
        setPickList=new set<String>(); 
        
        setPickList.addall(getPicklistValues('mrs_layer_chip_association__c','Send_Frame_Data__c'));
        mapManualUpdatePicklist.put('Send_Frame_Data__c',setPickList);
        setPickList=new set<String>(); 
        
        setPickList.addall(getPicklistValues('mrs_layer_chip_association__c','ORC__c'));
        mapManualUpdatePicklist.put('ORC__c',setPickList);
        setPickList=new set<String>(); 
        
        setPickList.addall(getPicklistValues('mrs_layer_chip_association__c','DRW__c'));
        mapManualUpdatePicklist.put('DRW__c',setPickList);
        setPickList=new set<String>(); 
        
        setPickList.addall(getPicklistValues('mrs_layer_chip_association__c','Prime_MEBES_Received__c'));
        mapManualUpdatePicklist.put('Prime_MEBES_Received__c',setPickList);
        setPickList=new set<String>(); 
        
        setPickList.addall(getPicklistValues('mrs_layer_chip_association__c','Frame_MEBES_Received__c'));
        mapManualUpdatePicklist.put('Frame_MEBES_Received__c',setPickList);
        setPickList=new set<String>(); 
        
        setPickList.addall(getPicklistValues('mrs_layer_chip_association__c','Customer_MEBES_Jobview__c'));
        mapManualUpdatePicklist.put('Customer_MEBES_Jobview__c',setPickList);
        setPickList=new set<String>(); 
        
        setPickList.addall(getPicklistValues('mrs_layer_chip_association__c','Foundry_MEBES_Jobview__c'));
        mapManualUpdatePicklist.put('Foundry_MEBES_Jobview__c',setPickList);
        setPickList=new set<String>(); 
        
        setPickList.addall(getPicklistValues('mrs_layer_chip_association__c','Tapeout_Centre_MEBES_Jobview__c'));
        mapManualUpdatePicklist.put('Tapeout_Centre_MEBES_Jobview__c',setPickList);
        setPickList=new set<String>(); 
        
        setPickList.addall(getPicklistValues('mrs_layer_chip_association__c','Tapeout_Applications_MEBES_Jobview__c'));
        mapManualUpdatePicklist.put('Tapeout_Applications_MEBES_Jobview__c',setPickList);
        setPickList=new set<String>(); 
        
        setPickList.addall(getPicklistValues('mrs_layer_chip_association__c','GlobalShuttle_MEBES_Jobview__c'));
        mapManualUpdatePicklist.put('GlobalShuttle_MEBES_Jobview__c',setPickList);
        setPickList=new set<String>(); 
        
        setPickList.addall(getPicklistValues('mrs_layer_chip_association__c','MDP_MEBES_Jobview__c'));
        mapManualUpdatePicklist.put('MDP_MEBES_Jobview__c',setPickList);
        setPickList=new set<String>(); 
        
        setPickList.addall(getPicklistValues('mrs_layer_chip_association__c','TDTI_MPW_MEBES_Jobview__c'));
        mapManualUpdatePicklist.put('TDTI_MPW_MEBES_Jobview__c',setPickList);
        setPickList=new set<String>(); 
        
       
    }
    
    
       /**
            This method is for populating values for filter dropdownlists. 
            @method name: populateFilterValues
            @parameter:   null
            @return :     void
       **/   
       public void populateFilterValues(String idLayerId)
       {
         string tempTechGeo='';
         string originalTechGeo='';
         decimal techgeo;
         decimal  finaltechgeo;
         
            if(idLayerId!=null && !String.isempty(idLayerId))
            {
               listLayerList=new List<String>(); 
               setLayerList=new set<String>(); 
               
               setDeviceId=new set<String>(); 
               setPTRFnDRT=new set<String>(); 
               setTechGeo=new set<String>(); 
               mapTechGeoValues=new map<String,String>();
               
               for(MRS_Layer_Chip_Association__c objSummary:MRSHandlerUtility.fetchMRSLayerChipSummaryDetails(idLayerId)){
                                if(objSummary.ptrf__r.device_id__c!=null){
                                    setDeviceId.add(objSummary.ptrf__r.Device_Id__c);
                                }
                                 if(objSummary.Layer_Chip_Status__c!=null){
                                    setLayerList.add(objSummary.Layer_Chip_Status__c);
                                }
                               
                                if(objSummary.PTRF_Or_DRT__c!=null && objSummary.PTRF_Or_DRT__c!='')
                                { 
                                    if(objSummary.PTRF_Or_DRT__c=='DRT')
                                    {
                                        if(objSummary.DRT__r.name!=null){
                                            setPTRFnDRT.add(String.valueOf(objSummary.DRT__r.name));
                                        }
                                    }
                                    else
                                    {
                                        if(objSummary.PTRF__r.name!=null){
                                            setPTRFnDRT.add(String.valueOf(objSummary.PTRF__r.name));                                    
                                        }
                                    }
                                }
                                else
                                {
                                     if(objSummary.PTRF__r.name!=null){
                                        setPTRFnDRT.add(String.valueOf(objSummary.PTRF__r.name));  
                                    }
                                }
                               
                                if(objSummary.Tech_Geo__c!=null && objSummary.Tech_Geo__c!=''){
                                      originalTechGeo=objSummary.Tech_Geo__c;
                                      if(!originalTechGeo.toUppercase().contains('UM')){
                                            originalTechGeo+='UM';
                                        }
                                        if(originalTechGeo!= NULL && originalTechGeo!= 'NULL' && !originalTechGeo.toLowercase().contains('nm')){
                                            techgeo=Decimal.valueof(String.valueof(originalTechGeo).touppercase().replace('UM',''));
                                            if(techgeo<0.1){
                                                finaltechgeo=techgeo*1000;
                                                tempTechGeo=objSummary.Tech_Geo__c+ ' ('+finaltechgeo.round()+'nm)';
                                            }
                                            else{
                                                tempTechGeo=originalTechGeo;
                                            }
                                        }else{
                                            tempTechGeo=originalTechGeo;
                                        }
                                    setTechGeo.add(tempTechGeo+':'+objSummary.Tech_Geo__c);
                                    mapTechGeoValues.put(objSummary.Tech_Geo__c,tempTechGeo);
                                }
                           }

                           listLayerList.addall(setLayerList);
                           listLayerList.sort();
                           
            }
          
       }
       
      /**
            This method is for getting pickist values. 
            @method name: getPicklistValues
            @parameter:   1. Object Name
                          2. Field Name  
            @return :     void
       **/ 
      private List<String> getPicklistValues(String ObjectApi_name,String Field_name)
      { 
          
         
          List<String> lstPickvals=new List<String>();
          Schema.SObjectType targetType = Schema.getGlobalDescribe().get(ObjectApi_name);//From the Object Api name retrieving the SObject
          Sobject Object_name = targetType.newSObject();
          Schema.sObjectType sobject_type = Object_name.getSObjectType(); //grab the sobject that was passed
          Schema.DescribeSObjectResult sobject_describe = sobject_type.getDescribe(); //describe the sobject
          Map<String, Schema.SObjectField> field_map = sobject_describe.fields.getMap(); //get a map of fields for the passed sobject
          List<Schema.PicklistEntry> pick_list_values = field_map.get(Field_name).getDescribe().getPickListValues(); //grab the list of picklist values for the passed field on the sobject
          for (Schema.PicklistEntry a : pick_list_values)
               { //for all values in the picklist list
                  lstPickvals.add(a.getValue());//add the value  to our final list
               }
         
          return lstPickvals;
      }
      
     /**
            This method is for fetching permitted picklist values from custom settings MRS_Layer_Chip_Status_Hierarchy__c. 
            @method name: fetchStatusHierarchyFromSettings
            @parameter:   null
            @return :     void
     **/  
     public void fetchStatusHierarchyFromSettings()
     {
                Map<String,String> mapTemp;
                MRS_Layer_Chip_Status_Hierarchy__c objCurrent;
                Map<String,MRS_Layer_Chip_Status_Hierarchy__c> mapPFPC = MRS_Layer_Chip_Status_Hierarchy__c.getAll();
                string keyname;
                mapLayerChipStatusSettings =new Map<String,Map<String,String>> ();
                for (String fieldName : mapPFPC.keySet())
                {
                    mapTemp=new Map<String,String>();
                    objCurrent=mapPFPC.get(fieldName);
                    
                    mapTemp.put('N.A.',objCurrent.NA__c);
                    mapTemp.put('Not Ready',objCurrent.Not_Ready__c);
                    mapTemp.put('Ready',objCurrent.Ready__c);
                    mapTemp.put('Approve',objCurrent.Approve__c);
                    mapTemp.put('Disapprove',objCurrent.Disapprove__c);
                    mapTemp.put('Done',objCurrent.Done__c);
                    mapTemp.put('InProgress',objCurrent.InProgress__c);
                    mapTemp.put('In Progress',objCurrent.InProgress__c);
                    mapTemp.put('Not Done',objCurrent.Not_Done__c);
                    mapTemp.put('Released',objCurrent.Released__c);
                                                                                                    
                    mapLayerChipStatusSettings.put(fieldName ,mapTemp);
                }
    }
    
    /**
            This method is for fetching default values for Layer Chip Status filter dropdown. 
            @method name: DefaultLayerSummaryValues
            @parameter:   null
            @return :     void
     **/     
      public String DefaultLayerSummaryValues(){
        String returnValue = '';
        if(idCurrentLayer==null || idCurrentLayer==''){
            idCurrentLayer=ApexPages.currentPage().getParameters().get('id');
        }
        
        for(AggregateResult a : [select Layer_Chip_Status__c from MRS_Layer_Chip_Association__C 
                                 where Layer__c=:idCurrentLayer and Layer_Chip_Status__c NOT IN ('','Void','Cancel','Released') and Layer_Chip_Status__c!=null
                                 group by Layer_Chip_Status__c Limit 50]){
            //if(String.valueOf(a.get('Layer_Chip_Status__c')) != 'Void' && String.valueOf(a.get('Layer_Chip_Status__c')) != 'Cancel' && String.valueOf(a.get('Layer_Chip_Status__c')) != 'Released' && String.valueOf(a.get('Layer_Chip_Status__c')) != null && String.valueOf(a.get('Layer_Chip_Status__c')) != ''){
                returnValue = returnValue+String.valueOf(a.get('Layer_Chip_Status__c'))+',';
            //}
        }
        returnValue = returnValue.removeEnd(','); 
        return returnValue;
    }
    
    /**
            This method is for fetching Layer chip status fields. 
            @method name: fetchFieldNames
            @parameter:   null
            @return :     List of String
     **/ 
    public List<String> fetchFieldNames()
    {
           
           
           List<String> listFieldNames; 
           listFieldNames=new List<String>();
               
               listFieldNames.add('Customer_GDSOUT_Review__c:Customer GDSOUT Review');
               listFieldNames.add('Foundry_GDSOUT_Review__c:Foundry GDSOUT Review');
               listFieldNames.add('Customer_Frame_Mockup__c:Customer Frame Mockup');
               listFieldNames.add('Foundry_Frame_Mockup__c:Foundry Frame Mockup');
               listFieldNames.add('Send_Prime_Data__c:Send Prime Data');
               listFieldNames.add('Send_Frame_Data__c:Send Frame Data');
               listFieldNames.add('Customer_Prime_Remote_Jobview_Setup__c:Customer Prime Remote Jobview');
               listFieldNames.add('Customer_Frame_Remote_Jobview_Setup__c:Customer Frame Remote Jobview');
               listFieldNames.add('Foundry_Prime_Remote_Jobview_Setup__c:Foundry Prime Remote Jobview');
               listFieldNames.add('Foundry_Frame_Remote_Jobview_Setup__c:Foundry Frame Remote Jobview');
               listFieldNames.add('ORC__c:ORC');
               listFieldNames.add('DRW__c:DRW');
               listFieldNames.add('Prime_MEBES_Received__c:Prime MEBES Received');
               listFieldNames.add('Frame_MEBES_Received__c:Frame MEBES Received');
               listFieldNames.add('Customer_MEBES_Jobview__c:Customer MEBES Jobview');
               listFieldNames.add('Foundry_MEBES_Jobview__c:Foundry MEBES Jobview');
               listFieldNames.add('Tapeout_Centre_MEBES_Jobview__c:Tapeout Centre MEBES Jobview');
               listFieldNames.add('Tapeout_Applications_MEBES_Jobview__c:Tapeout Applications MEBES Jobview');
               listFieldNames.add('GlobalShuttle_MEBES_Jobview__c:GlobalShuttle MEBES Jobview');
               listFieldNames.add('MDP_MEBES_Jobview__c:MDP MEBES Jobview');
               listFieldNames.add('TDTI_MPW_MEBES_Jobview__c:TDTI MPW MEBES Jobview');
            return listFieldNames;    
    }
    
    
    /**
            This method is for customized validations for each status fields and finally saving Layer Chip Assoc object data. 
            @method name: saveLayerChipData
            @parameter:   null
            @return :     PageReference obkect
     **/
    public PageReference saveLayerChipData()
    {
           ApexPages.Message mrsMessage;
           boolean isValid=true;
           boolean isRowValid=true;
           integer counter=0;
           string strOldStatus;
           string strNewStatus;
           string strFieldName;
           string strFieldDesc;           
                   
           Map<String,String> configmap;
           Map<String,String> tempField;
           List<String> listFieldNames; 
        try {
                
                listFieldNames=fetchFieldNames();
                                           
                for(MRS_Layer_Chip_Association__c objNewValue : lstLayerChipSummary)
                {
                    isRowValid=true;
                    for(String objMergedFieldName : listFieldNames)
                    {
                        
                        strFieldName=objMergedFieldName.split(':')[0];
                        strFieldDesc=objMergedFieldName.split(':')[1];
                        
                        strNewStatus= String.valueof(objNewValue.get(strFieldName));
                        strOldStatus= String.valueof(lstLayerChipSummaryOld[counter].get(strFieldName));
                        
                        //******** For checking Status change to blank for all fields***********
                       
                        if((strNewStatus==null || strNewStatus=='')&&(strOldStatus!=null && strOldStatus!='')){
                                mrsMessage= new ApexPages.Message(ApexPages.Severity.Info,'Change of status is invalid for '+strFieldDesc+' Record No. '+(counter+1) +' from ' +strOldStatus +' to Blank');
                                ApexPages.addMessage(mrsMessage);
                                isValid=false;
                                isRowValid=false;
                        }
                        //*********************************************************************
                        else if(strOldStatus!=null && strOldStatus!='' )
                        {
                            //******** For checking Status change to backward status according to CUSTOM SETTINGS - MRS_Layer_Chip_Status_Hierarchy for all fields
                            
                            configmap= mapLayerChipStatusSettings.get(strFieldName);
                            if(configmap!=null && Integer.valueof(configmap.get(strOldStatus))>Integer.valueof(configmap.get(strNewStatus)))
                            {
                                mrsMessage= new ApexPages.Message(ApexPages.Severity.Info,'Change of status is invalid for '+strFieldDesc+' Record No. '+(counter+1) +' from ' +strOldStatus +' to '+strNewStatus);
                                ApexPages.addMessage(mrsMessage);
                                isValid=false;
                                isRowValid=false;
                            }
                            //*********************************************************************
                            if(strNewStatus!=null && strNewStatus!='' )
                            {
                                if(!String.valueof('Customer_Prime_Remote_Jobview_Setup__c,Customer_Frame_Remote_Jobview_Setup__c,Foundry_Prime_Remote_Jobview_Setup__c,Foundry_Frame_Remote_Jobview_Setup__c').contains(strFieldName))
                                {
                                     if(strOldStatus.equalsIgnoreCase('N.A.')&& !strNewStatus.equalsIgnoreCase('N.A.'))
                                     {
                                         mrsMessage= new ApexPages.Message(ApexPages.Severity.Info,'Change of status is invalid for '+strFieldDesc+' Record No. '+(counter+1) +' from ' +strOldStatus +' to '+strNewStatus);
                                         ApexPages.addMessage(mrsMessage);
                                         isValid=false;
                                         isRowValid=false;
                                     }   
                                }
                                if(strNewStatus!=strOldStatus)
                                {
                                    if(String.valueof('Customer_GDSOUT_Review__c,Foundry_GDSOUT_Review__c').contains(strFieldName))
                                    {
                                         if((strOldStatus.equalsIgnoreCase('Not Ready') && !strNewStatus.equalsIgnoreCase('Ready'))||(strOldStatus.equalsIgnoreCase('Ready') && !strNewStatus.equalsIgnoreCase('Approve')))
                                         {
                                             mrsMessage= new ApexPages.Message(ApexPages.Severity.Info,'Change of status is invalid for '+strFieldDesc+' Record No. '+(counter+1) +' from ' +strOldStatus +' to '+strNewStatus);
                                             ApexPages.addMessage(mrsMessage);
                                             isValid=false;
                                             isRowValid=false;
                                         }   
                                    }
                                    if(String.valueof('Customer_Frame_Mockup__c,Foundry_Frame_Mockup__c').contains(strFieldName))
                                    {
                                         if((strOldStatus.equalsIgnoreCase('Not Ready') && !strNewStatus.equalsIgnoreCase('Ready'))||(strOldStatus.equalsIgnoreCase('Ready') && !String.valueof('Approve,Disapprove').contains(strNewStatus))||(strOldStatus.equalsIgnoreCase('Approve') && strNewStatus.equalsIgnoreCase('Disapprove'))||(strOldStatus.equalsIgnoreCase('Disapprove') && strNewStatus.equalsIgnoreCase('Approve')))
                                         {
                                             mrsMessage= new ApexPages.Message(ApexPages.Severity.Info,'Change of status is invalid for '+strFieldDesc+' Record No. '+(counter+1) +' from ' +strOldStatus +' to '+strNewStatus);
                                             ApexPages.addMessage(mrsMessage);
                                             isValid=false;
                                             isRowValid=false;
                                         }   
                                    }
                                    if(String.valueof('Send_Prime_Data__c,Send_Frame_Data__c').contains(strFieldName))
                                    {
                                        if( /*(strOldStatus.equalsIgnoreCase('Not Ready') && !strNewStatus.equalsIgnoreCase('Ready'))||*/(strOldStatus.equalsIgnoreCase('Not Done') && !strNewStatus.equalsIgnoreCase('Done')))
                                             {
                                                 mrsMessage= new ApexPages.Message(ApexPages.Severity.Info,'Change of status is invalid for '+strFieldDesc+' Record No. '+(counter+1) +' from ' +strOldStatus +' to '+strNewStatus);
                                                 ApexPages.addMessage(mrsMessage);
                                                 isValid=false;
                                                 isRowValid=false;
                                             }
                                        //if( /* (strOldStatus.equalsIgnoreCase('Not Ready') && strNewStatus.equalsIgnoreCase('Ready'))||*/(strOldStatus.equalsIgnoreCase('Not Done') && strNewStatus.equalsIgnoreCase('Done')))
                                        //     {
                                        //        if(!(String.valueof('N.A.,Approve').contains(String.valueof(lstLayerChipSummaryOld[counter].get('Customer_GDSOUT_Review__c')))
                                        //           && String.valueof('N.A.,Approve').contains(String.valueof(lstLayerChipSummaryOld[counter].get('Foundry_GDSOUT_Review__c')))
                                        //           && String.valueof('N.A.,Approve').contains(String.valueof(lstLayerChipSummaryOld[counter].get('Customer_Frame_Mockup__c')))
                                        //           && String.valueof('N.A.,Approve').contains(String.valueof(lstLayerChipSummaryOld[counter].get('Foundry_Frame_Mockup__c')))))
                                        //     {
                                             
                                        //         mrsMessage= new ApexPages.Message(ApexPages.Severity.Info,'Change of status is invalid for '+strFieldDesc+' Record No. '+(counter+1) +' from ' +strOldStatus +' to '+strNewStatus);
                                        //         ApexPages.addMessage(mrsMessage);
                                        //        isValid=false;
                                        //         isRowValid=false;
                                        //     }
                                        // }   
                                    }
                                     if(String.valueof('ORC__c').contains(strFieldName))
                                    {
                                         if((strOldStatus.equalsIgnoreCase('In Progress') && !strNewStatus.equalsIgnoreCase('Done')))
                                         {
                                             mrsMessage= new ApexPages.Message(ApexPages.Severity.Info,'Change of status is invalid for '+strFieldDesc+' Record No. '+(counter+1) +' from ' +strOldStatus +' to '+strNewStatus);
                                             ApexPages.addMessage(mrsMessage);
                                             isValid=false;
                                             isRowValid=false;
                                         }   
                                    }
                                     if(String.valueof('DRW__c').contains(strFieldName))
                                    {
                                         if((strOldStatus.equalsIgnoreCase('Not Ready') && !strNewStatus.equalsIgnoreCase('In Progress')) || (strOldStatus.equalsIgnoreCase('In Progress') && !strNewStatus.equalsIgnoreCase('Done')))
                                         {
                                             mrsMessage= new ApexPages.Message(ApexPages.Severity.Info,'Change of status is invalid for '+strFieldDesc+' Record No. '+(counter+1) +' from ' +strOldStatus +' to '+strNewStatus);
                                             ApexPages.addMessage(mrsMessage);
                                             isValid=false;
                                             isRowValid=false;
                                         }   
                                    }
                                    
                                    
                                    //RJV should no longer depend on SEND DATA_SWGP-270
                                    // if(String.valueof('Customer_Prime_Remote_Jobview_Setup__c,Customer_Frame_Remote_Jobview_Setup__c,Foundry_Prime_Remote_Jobview_Setup__c,Foundry_Frame_Remote_Jobview_Setup__c').contains(strFieldName))
                                   // {
                                    //    if((strOldStatus.equalsIgnoreCase('N.A.') && strNewStatus.equalsIgnoreCase('Done')))
                                    //         {
                                     //           if(!(String.valueof('N.A.,Done').contains(String.valueof(lstLayerChipSummaryOld[counter].get('Send_Prime_Data__c')))
                                     //              && String.valueof('N.A.,Done').contains(String.valueof(lstLayerChipSummaryOld[counter].get('Send_Frame_Data__c')))))
                                     //            {
                                     //                mrsMessage= new ApexPages.Message(ApexPages.Severity.Info,'Change of status is invalid for '+strFieldDesc+' Record No. '+(counter+1) +' from ' +strOldStatus +' to '+strNewStatus);
                                     //                ApexPages.addMessage(mrsMessage);
                                     //                isValid=false;
                                     //                isRowValid=false;
                                      //           }
                                      //   }   
                                    //}
                                    
                                    //MEBES received should no longer depend on SEND DATA SWGP-270
                                    // if(String.valueof('Prime_MEBES_Received__c,Frame_MEBES_Received__c').contains(strFieldName))
                                    //{
                                    //    if((strOldStatus.equalsIgnoreCase('Not Done') && strNewStatus.equalsIgnoreCase('Done')))
                                    //         {
                                    //            if(!(String.valueof('N.A.,Done').contains(String.valueof(lstLayerChipSummaryOld[counter].get('Send_Prime_Data__c')))
                                    //               && String.valueof('N.A.,Done').contains(String.valueof(lstLayerChipSummaryOld[counter].get('Send_Frame_Data__c')))))
                                    //             {
                                    //                 mrsMessage= new ApexPages.Message(ApexPages.Severity.Info,'Change of status is invalid for '+strFieldDesc+' Record No. '+(counter+1) +' from ' +strOldStatus +' to '+strNewStatus);
                                    //                 ApexPages.addMessage(mrsMessage);
                                    //                 isValid=false;
                                    //                 isRowValid=false;
                                    //             }
                                    //     }   
                                    //}
                                    
                                    
                                     if(String.valueof('Customer_MEBES_Jobview__c,Foundry_MEBES_Jobview__c,Tapeout_Centre_MEBES_Jobview__c,Tapeout_Applications_MEBES_Jobview__c,GlobalShuttle_MEBES_Jobview__c,MDP_MEBES_Jobview__c,TDTI_MPW_MEBES_Jobview__c').contains(strFieldName))
                                    {
                                        if((strOldStatus.equalsIgnoreCase('Not Ready') && !strNewStatus.equalsIgnoreCase('Ready'))||(strOldStatus.equalsIgnoreCase('Ready') && !strNewStatus.equalsIgnoreCase('Released')))
                                             {
                                                 mrsMessage= new ApexPages.Message(ApexPages.Severity.Info,'Change of status is invalid for '+strFieldDesc+' Record No. '+(counter+1) +' from ' +strOldStatus +' to '+strNewStatus);
                                                 ApexPages.addMessage(mrsMessage);
                                                 isValid=false;
                                                 isRowValid=false;
                                             }
                                        if((strOldStatus.equalsIgnoreCase('Not Ready') && strNewStatus.equalsIgnoreCase('Ready'))||(strOldStatus.equalsIgnoreCase('Ready') && strNewStatus.equalsIgnoreCase('Released')))
                                             {
                                                if(!(String.valueof('N.A.,Done').contains(String.valueof(lstLayerChipSummaryOld[counter].get('Customer_Prime_Remote_Jobview_Setup__c')))
                                                   && String.valueof('N.A.,Done').contains(String.valueof(lstLayerChipSummaryOld[counter].get('Customer_Frame_Remote_Jobview_Setup__c')))
                                                   && String.valueof('N.A.,Done').contains(String.valueof(lstLayerChipSummaryOld[counter].get('Foundry_Prime_Remote_Jobview_Setup__c')))
                                                   && String.valueof('N.A.,Done').contains(String.valueof(lstLayerChipSummaryOld[counter].get('Foundry_Frame_Remote_Jobview_Setup__c')))
                                                   && String.valueof('N.A.,Done').contains(String.valueof(lstLayerChipSummaryOld[counter].get('Prime_MEBES_Received__c')))
                                                   && String.valueof('N.A.,Done').contains(String.valueof(lstLayerChipSummaryOld[counter].get('Frame_MEBES_Received__c')))))
                                             {
                                             
                                                 mrsMessage= new ApexPages.Message(ApexPages.Severity.Info,'Change of status is invalid for '+strFieldDesc+' Record No. '+(counter+1) +' from ' +strOldStatus +' to '+strNewStatus);
                                                 ApexPages.addMessage(mrsMessage);
                                                 isValid=false;
                                                 isRowValid=false;
                                             }
                                         }   
                                    }
                                }
                            }
                            
                        }
                    }
                    if(isRowValid==true)
                    {
                        if(lstLayerChipSummary[counter].get('Customer_GDSOUT_Review__c')!=lstLayerChipSummaryOld[counter].get('Customer_GDSOUT_Review__c')){lstLayerChipSummary[counter].Is_Customer_GDSOUT_Review_Updated__c=true;}
                        if(lstLayerChipSummary[counter].get('Foundry_GDSOUT_Review__c')!=lstLayerChipSummaryOld[counter].get('Foundry_GDSOUT_Review__c')){lstLayerChipSummary[counter].Is_Foundry_GDSOUT_Review_Updated__c=true;}
                        if(lstLayerChipSummary[counter].get('Customer_Frame_Mockup__c')!=lstLayerChipSummaryOld[counter].get('Customer_Frame_Mockup__c')){lstLayerChipSummary[counter].Is_Customer_Frame_Mockup_Updated__c=true;}
                        if(lstLayerChipSummary[counter].get('Foundry_Frame_Mockup__c')!=lstLayerChipSummaryOld[counter].get('Foundry_Frame_Mockup__c')){lstLayerChipSummary[counter].Is_Foundry_Frame_Mockup_Updated__c=true;}
                        if(lstLayerChipSummary[counter].get('Send_Prime_Data__c')!=lstLayerChipSummaryOld[counter].get('Send_Prime_Data__c')){lstLayerChipSummary[counter].Is_Send_Prime_Data_Updated__c=true;}
                        if(lstLayerChipSummary[counter].get('Send_Frame_Data__c')!=lstLayerChipSummaryOld[counter].get('Send_Frame_Data__c')){lstLayerChipSummary[counter].Is_Send_Frame_Data_Updated__c=true;}
                        if(lstLayerChipSummary[counter].get('Customer_Prime_Remote_Jobview_Setup__c')!=lstLayerChipSummaryOld[counter].get('Customer_Prime_Remote_Jobview_Setup__c')){lstLayerChipSummary[counter].Is_Customer_Prime_Remote_Jobview_Updated__c=true;}
                        if(lstLayerChipSummary[counter].get('Customer_Frame_Remote_Jobview_Setup__c')!=lstLayerChipSummaryOld[counter].get('Customer_Frame_Remote_Jobview_Setup__c')){lstLayerChipSummary[counter].Is_Customer_Frame_Remote_Jobview_Updated__c=true;}
                        if(lstLayerChipSummary[counter].get('Foundry_Prime_Remote_Jobview_Setup__c')!=lstLayerChipSummaryOld[counter].get('Foundry_Prime_Remote_Jobview_Setup__c')){lstLayerChipSummary[counter].Is_Foundry_Prime_Remote_Jobview_Updated__c=true;}
                        if(lstLayerChipSummary[counter].get('Foundry_Frame_Remote_Jobview_Setup__c')!=lstLayerChipSummaryOld[counter].get('Foundry_Frame_Remote_Jobview_Setup__c')){lstLayerChipSummary[counter].Is_Foundry_Frame_Remote_Jobview_Updated__c=true;}
                        if(lstLayerChipSummary[counter].get('ORC__c')!=lstLayerChipSummaryOld[counter].get('ORC__c')){lstLayerChipSummary[counter].Is_ORC_Updated__c=true;}
                        if(lstLayerChipSummary[counter].get('DRW__c')!=lstLayerChipSummaryOld[counter].get('DRW__c')){lstLayerChipSummary[counter].Is_DRW_Updated__c=true;}
                        if(lstLayerChipSummary[counter].get('Prime_MEBES_Received__c')!=lstLayerChipSummaryOld[counter].get('Prime_MEBES_Received__c')){lstLayerChipSummary[counter].Is_Prime_MEBES_Received_Updated__c=true;}
                        if(lstLayerChipSummary[counter].get('Frame_MEBES_Received__c')!=lstLayerChipSummaryOld[counter].get('Frame_MEBES_Received__c')){lstLayerChipSummary[counter].Is_Frame_MEBES_Received_Updated__c=true;}
                        if(lstLayerChipSummary[counter].get('Customer_MEBES_Jobview__c')!=lstLayerChipSummaryOld[counter].get('Customer_MEBES_Jobview__c')){lstLayerChipSummary[counter].Is_Customer_MEBES_Jobview_Updated__c=true;}
                        if(lstLayerChipSummary[counter].get('Foundry_MEBES_Jobview__c')!=lstLayerChipSummaryOld[counter].get('Foundry_MEBES_Jobview__c')){lstLayerChipSummary[counter].Is_Foundry_MEBES_Jobview_Updated__c=true;}
                        if(lstLayerChipSummary[counter].get('Tapeout_Centre_MEBES_Jobview__c')!=lstLayerChipSummaryOld[counter].get('Tapeout_Centre_MEBES_Jobview__c')){lstLayerChipSummary[counter].Is_Tapeout_Centre_MEBES_Jobview_Updated__c=true;}
                        if(lstLayerChipSummary[counter].get('Tapeout_Applications_MEBES_Jobview__c')!=lstLayerChipSummaryOld[counter].get('Tapeout_Applications_MEBES_Jobview__c')){lstLayerChipSummary[counter].Is_Tapeout_Apps_MEBES_Jobview_Updated__c=true;}
                        if(lstLayerChipSummary[counter].get('GlobalShuttle_MEBES_Jobview__c')!=lstLayerChipSummaryOld[counter].get('GlobalShuttle_MEBES_Jobview__c')){lstLayerChipSummary[counter].Is_GlobalShuttle_MEBES_Jobview_Updated__c=true;}
                        if(lstLayerChipSummary[counter].get('MDP_MEBES_Jobview__c')!=lstLayerChipSummaryOld[counter].get('MDP_MEBES_Jobview__c')){lstLayerChipSummary[counter].Is_MDP_MEBES_Jobview_Updated__c=true;}
                        if(lstLayerChipSummary[counter].get('TDTI_MPW_MEBES_Jobview__c')!=lstLayerChipSummaryOld[counter].get('TDTI_MPW_MEBES_Jobview__c')){lstLayerChipSummary[counter].Is_TDTI_MPW_MEBES_Jobview_Updated__c=true;}

                    }
                    counter++;
                }
                if(isValid==true){
                    changeMebesJobviewStatus();
                    update lstLayerChipSummary;
                   
                    sendManualUpdateMail();
                   
                    
                    return openLayerChipPage();
                }
              }
              catch (DmlException e) {
                System.debug('$$: saveLayerChipData ' + e.getMessage());
                System.debug('$$StackTrace: saveLayerChipData ' + e.getStackTraceString());
            }
           return null;
    }
    
    /**
            This method is for fetching Layer chip assoc object data according to user permissions and the filters selected in UI. 
            @method name: searchMrsChipLayerSummary
            @parameter:   1. Layer Association ID 
                          2. Device ID of selected device 
                          3. Layer Chip Status values selected  
                          4. PTRF or DRT ID selected 
                          5. Tech Geo value selected  
            @return :     List of MRS Layer Chip Assoc object
     **/
     private List<MRS_Layer_Chip_Association__c> searchMrsChipLayerSummary(string layerId,String deviceId,String layerChipStatus,String ptrfDrtNum,string techGeo)
    {
           String strMST;
          
           String accId='';
           String customerAcc='';
           String jobviewer_ptrf=''; 
           
           if(isFEUser){
               List<Account_Team_Proxy__c> accTeamProxy = [Select Id,Account__c,User__c FROM Account_Team_Proxy__c WHERE User__c =:UserInfo.getUserId()];
              
                if(accTeamProxy != null && accTeamProxy.size()>0)
                {
                    for(Account_Team_Proxy__c acc:accTeamProxy ){
                        accId=accId+acc.Account__c+',';
                    }
                }
           }
           if(isValidCustomer ){
               User loggedInUser =[SELECT Id,AccountId,Name,ProfileId FROM User WHERE Id =:UserInfo.getUserId()];
               customerAcc=loggedInUser.AccountId;
           }
           list<PTRF_JobViewer_Info__c> jobViewerList =[SELECT Id,PTRF__c,Name,User__c FROM PTRF_JobViewer_Info__c WHERE User__c =:UserInfo.getUserId()];
           if(jobViewerList != null && jobViewerList.size()>0)
                {
                    for(PTRF_JobViewer_Info__c jobviewer:jobViewerList  ){
                        jobviewer_ptrf=jobviewer_ptrf+jobviewer.PTRF__c+',';
                    }
                }
           
           List<String> listTemp=new List<String>(); 
            if(layerChipStatus!= null){
                listTemp = layerChipStatus.split(',');
            }
           List<MRS__c> listFilteredMRS=new List<MRS__c>() ;
           listFilteredMRS  = [SELECT  Mask_Set_Title__c from MRS__c where id in (select MRS__c from MRS_Layer_Association__c where id=:layerId)];
          
           strMST=listFilteredMRS[0].Mask_Set_Title__c;
                  
            Set<String> listOfPTRFIDs = new Set<String>();
            for (PTRF__c PTRFObj : [SELECT  ID,Customer__c,Tech_Geo__c,Mask_Set_Title_Name__c from PTRF__c where (Prime_Tapeout__c=true or Frame_Tapeout__c=true) and MaskSetTitle__c =:strMST and Customer__c=:strCustomerId]){
                
                if(isFEUser && accId!='' && PTRFObj.Customer__c!=null && String.valueof(PTRFObj.Customer__c)==strCustomerId){
                    if(accId.contains(String.valueof(PTRFObj.Customer__c))){
                        listOfPTRFIDs.add(String.valueOf(PTRFObj.Id));
                    }
                }
                if(isMDP && PTRFObj.Tech_Geo__c!=null && PTRFObj.Tech_Geo__c.toUppercase().contains('UM') && Double.valueOf(PTRFObj.Tech_Geo__c.toUppercase().substringBefore('UM').trim())<=0.02 && PTRFObj.Customer__c!=null && String.valueof(PTRFObj.Customer__c)==strCustomerId){
                    
                        listOfPTRFIDs.add(String.valueOf(PTRFObj.Id));
                    
                }
                if(isGlobalShuttle && String.valueof(PTRFObj.Mask_Set_Title_Name__c).startsWith('MPW') && PTRFObj.Tech_Geo__c!=null && PTRFObj.Tech_Geo__c.toUppercase().contains('UM') && Double.valueOf(PTRFObj.Tech_Geo__c.toUppercase().substringBefore('UM').trim())>0.02 && PTRFObj.Customer__c!=null && String.valueof(PTRFObj.Customer__c)==strCustomerId){
                    
                        listOfPTRFIDs.add(String.valueOf(PTRFObj.Id));
                    
                }
                 if(isTDTIMPW  && String.valueof(PTRFObj.Mask_Set_Title_Name__c).startsWith('MPW') && PTRFObj.Tech_Geo__c!=null && PTRFObj.Tech_Geo__c.toUppercase().contains('UM') && Double.valueOf(PTRFObj.Tech_Geo__c.toUppercase().substringBefore('UM').trim())<=0.02 && PTRFObj.Customer__c!=null && String.valueof(PTRFObj.Customer__c)==strCustomerId){
                    
                        listOfPTRFIDs.add(String.valueOf(PTRFObj.Id));
                    
                }
                 if(isValidCustomer && PTRFObj.Customer__c!=null  && customerAcc!='' && PTRFObj.Customer__c!=null && String.valueof(PTRFObj.Customer__c)==strCustomerId){
                        if(customerAcc==String.valueof(PTRFObj.Customer__c)){
                            listOfPTRFIDs.add(String.valueOf(PTRFObj.Id));
                        }
                    
                }
               
                 if(jobviewer_ptrf!='' && jobviewer_ptrf.contains(PTRFObj.Id) && PTRFObj.Customer__c!=null && String.valueof(PTRFObj.Customer__c)==strCustomerId){
                    
                        listOfPTRFIDs.add(String.valueOf(PTRFObj.Id));
                    
                }
                if(isFEUser==false && isMDP==false && isGlobalShuttle==false && isTDTIMPW ==false && isValidCustomer ==false ){
                    if(PTRFObj.Customer__c!=null && String.valueof(PTRFObj.Customer__c)==strCustomerId){
                        listOfPTRFIDs.add(String.valueOf(PTRFObj.Id));
                    }
                }
                if(isSwiftAdmin==true || isTapeoutOperation==true || isSwiftRMG==true || isSwiftTapeoutAdmin==true || isSwiftTapeoutApplication==true || isSwiftTapeoutCentre==true){
                    if(PTRFObj.Customer__c!=null && String.valueof(PTRFObj.Customer__c)==strCustomerId){
                        listOfPTRFIDs.add(String.valueOf(PTRFObj.Id));
                    }
                }
            }
          
           List<String> listOfDRTIDs = new List<String>();
           for (DRT_PTRF_Association__c DRTObj : [SELECT  DRT__c from DRT_PTRF_Association__c where PTRF__c in:listOfPTRFIDs]){
                listOfDRTIDs.add(String.valueOf(DRTObj.DRT__c));
            }
                                          
           String  lstmrsLayerChipAsso = 'SELECT  ID,PTRF__r.Device_Id__c,PTRF__r.DRW_Disposition__c,PTRF__r.Tech_Geo__c,Chip__r.Name,Layer__r.ROM_Code__c,Layer__r.Name,Layer__r.Mask_Layer_Rev__c,Mask_Layer__c,layer__r.MRS__r.Mask_Set_Title__r.Name,Is_Customer_GDSOUT_Review_Updated__c,Is_Foundry_GDSOUT_Review_Updated__c,Chip_Name__c,Tech_Geo__c,Layer__c,Chip__c,Mask_Set_Title_Name__c,PTRF__r.Customer_jobview__c,PTRF__r.Foundry_jobview__c,PTRF__r.Order_Type__c,PTRF__r.Process_Technology_Lifecycle_Phase__c,PTRF__r.Customer_Short_Name__c,PTRF_Number__c,PTRF__r.MaskSetTitle__r.Name,PTRF_Or_DRT__c,ptrf__c,drt__c,ptrf__r.name,drt__r.name,Layer_Chip_Status__c,Customer_GDSOUT_Review__c\n'+
                                                 ',Foundry_GDSOUT_Review__c,Customer_Frame_Mockup__c,Foundry_Frame_Mockup__c,Send_Prime_Data__c,Send_Frame_Data__c,ORC__c,DRW__c \n'+
                                                 ',Customer_Prime_Remote_Jobview_Setup__c,Customer_Frame_Remote_Jobview_Setup__c,Foundry_Prime_Remote_Jobview_Setup__c,Foundry_Frame_Remote_Jobview_Setup__c \n'+
                                                 ',Prime_MEBES_Received__c,Frame_MEBES_Received__c,Customer_MEBES_Jobview__c,Foundry_MEBES_Jobview__c,Tapeout_Centre_MEBES_Jobview__c \n'+
                                                 ',Tapeout_Applications_MEBES_Jobview__c,GlobalShuttle_MEBES_Jobview__c,MDP_MEBES_Jobview__c,TDTI_MPW_MEBES_Jobview__c \n'+
                                                  ',Customer_GDSOUT_Review_Date__c,Foundry_GDSOUT_Review_Date__c,Customer_Frame_Mockup_Date__c,Foundry_Frame_Mockup_Date__c,Send_Prime_Data_Date__c,Send_Frame_Data_Date__c,ORC_Date__c,DRW_Date__c \n'+
                                                 ',Customer_Prime_Remote_Jobview_Setup_Date__c,Customer_Frame_Remote_Jobview_Setup_Date__c,Foundry_Prime_Remote_Jobview_Setup_Date__c,Foundry_Frame_Remote_Jobview_Setup_Date__c \n'+
                                                 ',Prime_MEBES_Received_Date__c,Frame_MEBES_Received_Date__c,Customer_MEBES_Jobview_Date__c,Foundry_MEBES_Jobview_Date__c,Tapeout_Centre_MEBES_Jobview_Date__c \n'+
                                                 ',Tapeout_Applications_MEBES_Jobview_Date__c,GlobalShuttle_MEBES_Jobview_Date__c,MDP_MEBES_Jobview_Date__c,TDTI_MPW_MEBES_Date__c,Layer_Chip_Status_Date__c \n'+
                                         ' FROM  MRS_Layer_Chip_Association__c';
    
    
           
          if(layerId!='' && layerId!=null)
          {
              lstmrsLayerChipAsso  =lstmrsLayerChipAsso  +' WHERE Layer__c =:layerId';
          }else
          {
          return null;
          }
          if(deviceId!=''  && deviceId!=null && deviceId!='0')
              lstmrsLayerChipAsso  =lstmrsLayerChipAsso  +' AND PTRF__r.Device_Id__c =:deviceId';
        
          if(layerChipStatus!='' && layerChipStatus!=null && layerChipStatus!='0')
              lstmrsLayerChipAsso  =lstmrsLayerChipAsso  +' AND Layer_Chip_Status__c in:listTemp';
          
          if(ptrfDrtNum!='' && ptrfDrtNum!=null && ptrfDrtNum!='0')
              lstmrsLayerChipAsso  =lstmrsLayerChipAsso  +' AND ((PTRF__r.name=:ptrfDrtNum and PTRF_Or_DRT__c!=\'DRT\') OR ( DRT__r.name=:ptrfDrtNum and PTRF_Or_DRT__c=\'DRT\'))';
          if(techGeo!='' && techGeo!=null && techGeo!='0')
              lstmrsLayerChipAsso  =lstmrsLayerChipAsso  +' AND Tech_Geo__c=:techGeo';
         
          if(listOfPTRFIDs!=null && listOfPTRFIDs.size()>0)
              lstmrsLayerChipAsso  =lstmrsLayerChipAsso  +' AND PTRF__c in:listOfPTRFIDs ';
         
          List<MRS_Layer_Chip_Association__c> mrslstLayerChip =Database.Query(lstmrsLayerChipAsso);
    
          return   mrslstLayerChip ; 
                                                                  
    }  
    
 
    /**
            This method is for for changing Mebes Jobview Status based on values selected by user. 
            @method name: changeMebesJobviewStatus
            @parameter:   null
            @return :     void
     **/
    private void changeMebesJobviewStatus(){
    
        integer intCount=0;
        MRS_Layer_Chip_Association__c objOldValue;
        DateTime currentDateTime = DateTime.now();
        if(lstLayerChipSummary!=null && lstLayerChipSummary.size()>0){
            for(MRS_Layer_Chip_Association__c objValue : lstLayerChipSummary)
            {
                 objOldValue=lstLayerChipSummaryOld[intCount];
                            
                 if((String.Valueof(objValue.Prime_MEBES_Received__c).equalsIgnoreCase('Done') && !String.Valueof(objOldValue.Prime_MEBES_Received__c).equalsIgnoreCase('Done'))
                   || (String.Valueof(objValue.Frame_MEBES_Received__c).equalsIgnoreCase('Done') && !String.Valueof(objOldValue.Frame_MEBES_Received__c).equalsIgnoreCase('Done'))
                   )
                    {
                        if(String.Valueof(objValue.Customer_MEBES_Jobview__c).equalsIgnoreCase('Not Ready')){
                            objValue.Customer_MEBES_Jobview__c='Ready';
                            objValue.Is_Customer_MEBES_Jobview_Updated__c=true;
                        }
                        if(String.Valueof(objValue.Foundry_MEBES_Jobview__c).equalsIgnoreCase('Not Ready')){
                            objValue.Foundry_MEBES_Jobview__c='Ready';
                            objValue.Is_Foundry_MEBES_Jobview_Updated__c=true;
                        }
                        if(String.Valueof(objValue.Tapeout_Centre_MEBES_Jobview__c).equalsIgnoreCase('Not Ready')){
                            objValue.Tapeout_Centre_MEBES_Jobview__c='Ready';
                            objValue.Is_Tapeout_Centre_MEBES_Jobview_Updated__c=true;
                        }
                        if(String.Valueof(objValue.Tapeout_Applications_MEBES_Jobview__c).equalsIgnoreCase('Not Ready')){
                            objValue.Tapeout_Applications_MEBES_Jobview__c='Ready';
                            objValue.Is_Tapeout_Apps_MEBES_Jobview_Updated__c=true;
                        }
                        if(String.Valueof(objValue.GlobalShuttle_MEBES_Jobview__c).equalsIgnoreCase('Not Ready')){
                            objValue.GlobalShuttle_MEBES_Jobview__c='Ready';
                            objValue.Is_GlobalShuttle_MEBES_Jobview_Updated__c=true;
                        }
                        if(String.Valueof(objValue.MDP_MEBES_Jobview__c).equalsIgnoreCase('Not Ready')){
                            objValue.MDP_MEBES_Jobview__c='Ready';
                            objValue.Is_MDP_MEBES_Jobview_Updated__c=true;
                        }
                        if(String.Valueof(objValue.TDTI_MPW_MEBES_Jobview__c).equalsIgnoreCase('Not Ready')){
                            objValue.TDTI_MPW_MEBES_Jobview__c='Ready';
                            objValue.Is_TDTI_MPW_MEBES_Jobview_Updated__c=true;
                        }
                    }
                     if((String.Valueof(objValue.Customer_Prime_Remote_Jobview_Setup__c).equalsIgnoreCase('Done') && !String.Valueof(objOldValue.Customer_Prime_Remote_Jobview_Setup__c).equalsIgnoreCase('Done'))
                   || (String.Valueof(objValue.Customer_Frame_Remote_Jobview_Setup__c).equalsIgnoreCase('Done') && !String.Valueof(objOldValue.Customer_Frame_Remote_Jobview_Setup__c).equalsIgnoreCase('Done'))
                   )
                    {
                        if(String.Valueof(objValue.Customer_MEBES_Jobview__c).equalsIgnoreCase('Not Ready')){
                            objValue.Customer_MEBES_Jobview__c='Ready';
                            objValue.Is_Customer_MEBES_Jobview_Updated__c=true;
                            
                        }
                       
                    }
                      if((String.Valueof(objValue.Foundry_Prime_Remote_Jobview_Setup__c).equalsIgnoreCase('Done') && !String.Valueof(objOldValue.Foundry_Prime_Remote_Jobview_Setup__c).equalsIgnoreCase('Done'))
                   || (String.Valueof(objValue.Foundry_Frame_Remote_Jobview_Setup__c).equalsIgnoreCase('Done') && !String.Valueof(objOldValue.Foundry_Frame_Remote_Jobview_Setup__c).equalsIgnoreCase('Done'))
                   )
                    {
                        if(String.Valueof(objValue.Foundry_MEBES_Jobview__c).equalsIgnoreCase('Not Ready')){
                            objValue.Foundry_MEBES_Jobview__c='Ready';
                            objValue.Is_Foundry_MEBES_Jobview_Updated__c=true;
                        }
                       
                    }
                    
                    if(String.Valueof(objValue.Customer_GDSOUT_Review__c).equalsIgnoreCase('Ready') && !String.Valueof(objOldValue.Customer_GDSOUT_Review__c).equalsIgnoreCase('Ready'))
                    {
                        objValue.Customer_GDSOUT_Review_Notified_Date__c=currentDateTime;
                    }
                    if(String.Valueof(objValue.Foundry_GDSOUT_Review__c).equalsIgnoreCase('Ready') && !String.Valueof(objOldValue.Foundry_GDSOUT_Review__c).equalsIgnoreCase('Ready'))
                    {
                        objValue.Foundry_GDSOUT_Review_Notified_Date__c=currentDateTime;
                    }
                    if(String.Valueof(objValue.Customer_Frame_Mockup__c).equalsIgnoreCase('Ready') && !String.Valueof(objOldValue.Customer_Frame_Mockup__c).equalsIgnoreCase('Ready'))
                    {
                        objValue.Customer_Frame_Mockup_Notified_Date__c=currentDateTime;
                    }
                    if(String.Valueof(objValue.Foundry_Frame_Mockup__c).equalsIgnoreCase('Ready') && !String.Valueof(objOldValue.Foundry_Frame_Mockup__c).equalsIgnoreCase('Ready'))
                    {
                        objValue.Foundry_Frame_Mockup_Notified_Date__c=currentDateTime;
                    }
                    if(String.Valueof(objValue.Customer_MEBES_Jobview__c).equalsIgnoreCase('Ready') && !String.Valueof(objOldValue.Customer_MEBES_Jobview__c).equalsIgnoreCase('Ready'))
                    {
                        objValue.Customer_MEBES_Jobview_Notified_Date__c=currentDateTime;
                    }
                    if(String.Valueof(objValue.Foundry_MEBES_Jobview__c).equalsIgnoreCase('Ready') && !String.Valueof(objOldValue.Foundry_MEBES_Jobview__c).equalsIgnoreCase('Ready'))
                    {
                        objValue.Foundry_MEBES_Jobview_Notified_Date__c=currentDateTime;
                    }
                    if(String.Valueof(objValue.GlobalShuttle_MEBES_Jobview__c).equalsIgnoreCase('Ready') && !String.Valueof(objOldValue.GlobalShuttle_MEBES_Jobview__c).equalsIgnoreCase('Ready'))
                    {
                        objValue.GlobalShuttle_MEBES_Notified_Date__c=currentDateTime;
                    }
                    if(String.Valueof(objValue.MDP_MEBES_Jobview__c).equalsIgnoreCase('Ready') && !String.Valueof(objOldValue.MDP_MEBES_Jobview__c).equalsIgnoreCase('Ready'))
                    {
                        objValue.MDP_MEBES_Notified_Date__c=currentDateTime;
                    }
                    if(String.Valueof(objValue.Tapeout_Applications_MEBES_Jobview__c).equalsIgnoreCase('Ready') && !String.Valueof(objOldValue.Tapeout_Applications_MEBES_Jobview__c).equalsIgnoreCase('Ready'))
                    {
                        objValue.Tapeout_App_MEBES_Notified_Date__c=currentDateTime;
                    }
                    if(String.Valueof(objValue.Tapeout_Centre_MEBES_Jobview__c).equalsIgnoreCase('Ready') && !String.Valueof(objOldValue.Tapeout_Centre_MEBES_Jobview__c).equalsIgnoreCase('Ready'))
                    {
                        objValue.Tapeout_Centre_MEBES_Notified_Date__c=currentDateTime;
                    }
                    if(String.Valueof(objValue.TDTI_MPW_MEBES_Jobview__c).equalsIgnoreCase('Ready') && !String.Valueof(objOldValue.TDTI_MPW_MEBES_Jobview__c).equalsIgnoreCase('Ready'))
                    {
                        objValue.TDTI_MPW_MEBES_Notified_Date__c=currentDateTime;
                    }
                    intCount++;         
            }
        }
        
    }
    
    /**
            This method is for sending mails to customized users/groups after the Layer Chip Assoc data is saved. 
            @method name: sendManualUpdateMail
            @parameter:   null
            @return :     void
     **/
    public void sendManualUpdateMail(){
    
        integer intCount=0;
        boolIsMailSent=false;
        List<MRS_Layer_Chip_Association__c> lstCustomerRemoteJobview=new List<MRS_Layer_Chip_Association__c>();
        List<MRS_Layer_Chip_Association__c> lstFoundryRemoteJobview=new List<MRS_Layer_Chip_Association__c>();
        List<MRS_Layer_Chip_Association__c> lstCustomerMebesJobview=new List<MRS_Layer_Chip_Association__c>();
        List<MRS_Layer_Chip_Association__c> lstFoundryMebesJobview=new List<MRS_Layer_Chip_Association__c>();
        List<MRS_Layer_Chip_Association__c> lstCustomerFrameMockup=new List<MRS_Layer_Chip_Association__c>();
        List<MRS_Layer_Chip_Association__c> lstFoundryFrameMockup=new List<MRS_Layer_Chip_Association__c>();
        List<MRS_Layer_Chip_Association__c> lstCustomerGDSOUTReview=new List<MRS_Layer_Chip_Association__c>();
        List<MRS_Layer_Chip_Association__c> lstFoundryGDSOUTReview=new List<MRS_Layer_Chip_Association__c>();
        List<MRS_Layer_Chip_Association__c> lstGlobalShuttle=new List<MRS_Layer_Chip_Association__c>();
        List<MRS_Layer_Chip_Association__c> lstMDP=new List<MRS_Layer_Chip_Association__c>();
        List<MRS_Layer_Chip_Association__c> lstTapeoutApps=new List<MRS_Layer_Chip_Association__c>();
        List<MRS_Layer_Chip_Association__c> lstTapeoutCentre=new List<MRS_Layer_Chip_Association__c>();
        MRS_Layer_Chip_Association__c objOldValue;
        Map<Id,List<MRS_Layer_Chip_Association__c>> mapCustomerGDSOUT=new Map<Id,List<MRS_Layer_Chip_Association__c>>();
        Map<Id,List<MRS_Layer_Chip_Association__c>> mapFoundryGDSOUT=new Map<Id,List<MRS_Layer_Chip_Association__c>>();
        Map<Id,List<MRS_Layer_Chip_Association__c>> mapCustomerFrameMockupApprove=new Map<Id,List<MRS_Layer_Chip_Association__c>>();
        Map<Id,List<MRS_Layer_Chip_Association__c>> mapFoundryFrameMockupApprove=new Map<Id,List<MRS_Layer_Chip_Association__c>>();
        Map<Id,List<MRS_Layer_Chip_Association__c>> mapCustomerFrameMockupDisapprove=new Map<Id,List<MRS_Layer_Chip_Association__c>>();
        Map<Id,List<MRS_Layer_Chip_Association__c>> mapFoundryFrameMockupDisapprove=new Map<Id,List<MRS_Layer_Chip_Association__c>>();
        
        Map<Id,List<MRS_Layer_Chip_Association__c>> mapMebesCustomer=new Map<Id,List<MRS_Layer_Chip_Association__c>>();
        Map<Id,List<MRS_Layer_Chip_Association__c>> mapMebesFoundry=new Map<Id,List<MRS_Layer_Chip_Association__c>>();
        Map<Id,List<MRS_Layer_Chip_Association__c>> mapMebesTapeoutCentre=new Map<Id,List<MRS_Layer_Chip_Association__c>>();
        Map<Id,List<MRS_Layer_Chip_Association__c>> mapMebesTapeoutApps=new Map<Id,List<MRS_Layer_Chip_Association__c>>();
        Map<Id,List<MRS_Layer_Chip_Association__c>> mapMebesGlobalshuttle=new Map<Id,List<MRS_Layer_Chip_Association__c>>();
        Map<Id,List<MRS_Layer_Chip_Association__c>> mapMDP=new Map<Id,List<MRS_Layer_Chip_Association__c>>();
        Map<Id,List<MRS_Layer_Chip_Association__c>> mapTDTI=new Map<Id,List<MRS_Layer_Chip_Association__c>>();
        
        list<Id> tempLayerChip1=new list<Id>();
        list<Id> tempLayerChip2=new list<Id>();
        list<Id> tempLayerChip3=new list<Id>();
        list<Id> tempLayerChip4=new list<Id>();
        list<Id> tempLayerChip5=new list<Id>();
        list<Id> tempLayerChip6=new list<Id>();
        
        list<Id> tempLayerChip7=new list<Id>();
        list<Id> tempLayerChip8=new list<Id>();
        list<Id> tempLayerChip9=new list<Id>();
        list<Id> tempLayerChip10=new list<Id>();
        list<Id> tempLayerChip11=new list<Id>();
        list<Id> tempLayerChip12=new list<Id>();
        list<Id> tempLayerChip13=new list<Id>();
                
        if(lstLayerChipSummary!=null && lstLayerChipSummary.size()>0){
            for(MRS_Layer_Chip_Association__c objValue : lstLayerChipSummary)
            {
                 objOldValue=lstLayerChipSummaryOld[intCount];

                 if((String.Valueof(objValue.Customer_Prime_Remote_Jobview_Setup__c).equalsIgnoreCase('Done') && !String.Valueof(objOldValue.Customer_Prime_Remote_Jobview_Setup__c).equalsIgnoreCase('Done'))
                   || (String.Valueof(objValue.Customer_Frame_Remote_Jobview_Setup__c).equalsIgnoreCase('Done') && !String.Valueof(objOldValue.Customer_Frame_Remote_Jobview_Setup__c).equalsIgnoreCase('Done'))
                    )
                    {
                        lstCustomerRemoteJobview.add(objValue);
                    }
                 if((String.Valueof(objValue.Foundry_Prime_Remote_Jobview_Setup__c).equalsIgnoreCase('Done') && !String.Valueof(objOldValue.Foundry_Prime_Remote_Jobview_Setup__c).equalsIgnoreCase('Done'))
                   || (String.Valueof(objValue.Foundry_Frame_Remote_Jobview_Setup__c).equalsIgnoreCase('Done')  && !String.Valueof(objOldValue.Foundry_Frame_Remote_Jobview_Setup__c).equalsIgnoreCase('Done'))               
                    )
                    {
                        lstFoundryRemoteJobview.add(objValue);
                    }
                 if((String.Valueof(objValue.Customer_MEBES_Jobview__c).equalsIgnoreCase('Ready') && String.Valueof(objOldValue.Customer_MEBES_Jobview__c).equalsIgnoreCase('Not Ready'))
                   )                  
                    {
                        lstCustomerMebesJobview.add(objValue);
                    }
                 if((String.Valueof(objValue.Foundry_MEBES_Jobview__c).equalsIgnoreCase('Ready') && String.Valueof(objOldValue.Foundry_MEBES_Jobview__c).equalsIgnoreCase('Not Ready'))
                   )                  
                    {
                        lstFoundryMebesJobview.add(objValue);
                    }   
                 if((String.Valueof(objValue.Customer_GDSOUT_Review__c).equalsIgnoreCase('Ready') && String.Valueof(objOldValue.Customer_GDSOUT_Review__c).equalsIgnoreCase('Not Ready'))
                   )                  
                    {
                        lstCustomerGDSOUTReview.add(objValue);
                    }
                    if((String.Valueof(objValue.Foundry_GDSOUT_Review__c).equalsIgnoreCase('Ready') && String.Valueof(objOldValue.Foundry_GDSOUT_Review__c).equalsIgnoreCase('Not Ready'))
                   )
                    {
                        lstFoundryGDSOUTReview.add(objValue);
                    }
                      if((String.Valueof(objValue.Customer_Frame_Mockup__c ).equalsIgnoreCase('Ready') && String.Valueof(objOldValue.Customer_Frame_Mockup__c ).equalsIgnoreCase('Not Ready'))
                   )
                    {
                        lstCustomerFrameMockup.add(objValue);
                    }
                        if((String.Valueof(objValue.Foundry_Frame_Mockup__c).equalsIgnoreCase('Ready') && String.Valueof(objOldValue.Foundry_Frame_Mockup__c).equalsIgnoreCase('Not Ready'))
                   )
                    {
                        lstFoundryFrameMockup.add(objValue);
                    }
                 if((String.Valueof(objValue.GlobalShuttle_MEBES_Jobview__c).equalsIgnoreCase('Ready') && String.Valueof(objOldValue.GlobalShuttle_MEBES_Jobview__c).equalsIgnoreCase('Not Ready'))
                  || (String.Valueof(objValue.TDTI_MPW_MEBES_Jobview__c).equalsIgnoreCase('Ready') && String.Valueof(objOldValue.TDTI_MPW_MEBES_Jobview__c).equalsIgnoreCase('Not Ready'))
                   )
                    {
                        lstGlobalShuttle.add(objValue);
                    } 
                 if((String.Valueof(objValue.MDP_MEBES_Jobview__c).equalsIgnoreCase('Ready') && String.Valueof(objOldValue.MDP_MEBES_Jobview__c).equalsIgnoreCase('Not Ready'))
                    )
                    {
                        lstMDP.add(objValue);
                    }
                 if((String.Valueof(objValue.Tapeout_Applications_MEBES_Jobview__c).equalsIgnoreCase('Ready') && String.Valueof(objOldValue.Tapeout_Applications_MEBES_Jobview__c).equalsIgnoreCase('Not Ready'))
                   )
                    {
                        lstTapeoutApps.add(objValue);
                    }
                 if((String.Valueof(objValue.Tapeout_Centre_MEBES_Jobview__c).equalsIgnoreCase('Ready') && String.Valueof(objOldValue.Tapeout_Centre_MEBES_Jobview__c).equalsIgnoreCase('Not Ready'))
                 )
                    {
                        lstTapeoutCentre.add(objValue);
                    } 
                   if((String.Valueof(objValue.Customer_GDSOUT_Review__c).equalsIgnoreCase('Approve') && String.Valueof(objOldValue.Customer_GDSOUT_Review__c).equalsIgnoreCase('Ready') && String.Valueof(objValue.Foundry_GDSOUT_Review__c).equalsIgnoreCase('Approve'))
                   )
                   {
                        if(objValue.PTRF_Or_DRT__c!='DRT' && objValue.PTRF__c!=null){
                           tempLayerChip1.add(objValue.ptrf__c);
                        }
                   }
                   if((String.Valueof(objValue.Foundry_GDSOUT_Review__c).equalsIgnoreCase('Approve') && String.Valueof(objOldValue.Foundry_GDSOUT_Review__c).equalsIgnoreCase('Ready') && String.Valueof(objValue.Customer_GDSOUT_Review__c).equalsIgnoreCase('Approve'))
                   )
                   {
                           if(objValue.PTRF_Or_DRT__c!='DRT' && objValue.PTRF__c!=null){
                               tempLayerChip2.add(objValue.ptrf__c);
                           }
                   } 
                   if((String.Valueof(objValue.Customer_Frame_Mockup__c).equalsIgnoreCase('Approve') && String.Valueof(objOldValue.Customer_Frame_Mockup__c).equalsIgnoreCase('Ready') && (String.Valueof(objValue.Foundry_Frame_Mockup__c).equalsIgnoreCase('Approve')||String.Valueof(objValue.Foundry_Frame_Mockup__c).equalsIgnoreCase('N.A.')))
                   )
                   {
                           if(objValue.PTRF_Or_DRT__c!='DRT' && objValue.PTRF__c!=null){
                               tempLayerChip3.add(objValue.ptrf__c);
                           }
                   } 
                   if((String.Valueof(objValue.Foundry_Frame_Mockup__c).equalsIgnoreCase('Approve') && String.Valueof(objOldValue.Foundry_Frame_Mockup__c).equalsIgnoreCase('Ready') && (String.Valueof(objValue.Customer_Frame_Mockup__c).equalsIgnoreCase('Approve')||String.Valueof(objValue.Customer_Frame_Mockup__c).equalsIgnoreCase('N.A.')))
                   )
                   {
                           if(objValue.PTRF_Or_DRT__c!='DRT' && objValue.PTRF__c!=null){
                               tempLayerChip4.add(objValue.ptrf__c);
                           }
                   } 
                   if((String.Valueof(objValue.Customer_Frame_Mockup__c).equalsIgnoreCase('Disapprove') && String.Valueof(objOldValue.Customer_Frame_Mockup__c).equalsIgnoreCase('Ready'))
                   )
                   {
                           if(objValue.PTRF_Or_DRT__c!='DRT' && objValue.PTRF__c!=null){
                               tempLayerChip5.add(objValue.ptrf__c);
                           }
                   } 
                   if((String.Valueof(objValue.Foundry_Frame_Mockup__c).equalsIgnoreCase('Disapprove') && String.Valueof(objOldValue.Foundry_Frame_Mockup__c).equalsIgnoreCase('Ready'))
                   )
                   {
                           if(objValue.PTRF_Or_DRT__c!='DRT' && objValue.PTRF__c!=null){
                               tempLayerChip6.add(objValue.ptrf__c);
                           }
                   }
                   if((String.Valueof(objValue.Customer_MEBES_Jobview__c).equalsIgnoreCase('Released') && String.Valueof(objOldValue.Customer_MEBES_Jobview__c).equalsIgnoreCase('Ready'))
                   )
                   {
                           if(objValue.PTRF_Or_DRT__c!='DRT' && objValue.PTRF__c!=null){
                               tempLayerChip7.add(objValue.ptrf__c);
                           }
                   }
                   if((String.Valueof(objValue.Foundry_MEBES_Jobview__c).equalsIgnoreCase('Released') && String.Valueof(objOldValue.Foundry_MEBES_Jobview__c).equalsIgnoreCase('Ready'))
                   )
                   {
                           if(objValue.PTRF_Or_DRT__c!='DRT' && objValue.PTRF__c!=null){
                               tempLayerChip8.add(objValue.ptrf__c);
                           }
                   } 
                   if((String.Valueof(objValue.Tapeout_Centre_MEBES_Jobview__c).equalsIgnoreCase('Released') && String.Valueof(objOldValue.Tapeout_Centre_MEBES_Jobview__c).equalsIgnoreCase('Ready'))
                   )
                   {
                           if(objValue.PTRF_Or_DRT__c!='DRT' && objValue.PTRF__c!=null){
                               tempLayerChip9.add(objValue.ptrf__c);
                           }
                   } 
                   if((String.Valueof(objValue.Tapeout_Applications_MEBES_Jobview__c).equalsIgnoreCase('Released') && String.Valueof(objOldValue.Tapeout_Applications_MEBES_Jobview__c).equalsIgnoreCase('Ready'))
                   )
                   {
                           if(objValue.PTRF_Or_DRT__c!='DRT' && objValue.PTRF__c!=null){
                               tempLayerChip10.add(objValue.ptrf__c);
                           }
                   } 
                   if((String.Valueof(objValue.GlobalShuttle_MEBES_Jobview__c).equalsIgnoreCase('Released') && String.Valueof(objOldValue.GlobalShuttle_MEBES_Jobview__c).equalsIgnoreCase('Ready'))
                   )
                   {
                           if(objValue.PTRF_Or_DRT__c!='DRT' && objValue.PTRF__c!=null){
                               tempLayerChip11.add(objValue.ptrf__c);
                           }
                   } 
                   if((String.Valueof(objValue.MDP_MEBES_Jobview__c).equalsIgnoreCase('Released') && String.Valueof(objOldValue.MDP_MEBES_Jobview__c).equalsIgnoreCase('Ready'))
                   )
                   {
                           if(objValue.PTRF_Or_DRT__c!='DRT' && objValue.PTRF__c!=null){
                               tempLayerChip12.add(objValue.ptrf__c);
                           }
                   } 
                   if((String.Valueof(objValue.TDTI_MPW_MEBES_Jobview__c).equalsIgnoreCase('Released') && String.Valueof(objOldValue.TDTI_MPW_MEBES_Jobview__c).equalsIgnoreCase('Ready'))
                   )
                   {
                           if(objValue.PTRF_Or_DRT__c!='DRT' && objValue.PTRF__c!=null){
                               tempLayerChip13.add(objValue.ptrf__c);
                           }
                   }  
                    intCount++;         
            }
            
            list<MRS_Layer_Chip_Association__c > tempLayerChip;
            if(tempLayerChip1!=null && tempLayerChip1.size()>0){
           
                for(Id keyId :tempLayerChip1){
                    intCount=0;
                    tempLayerChip=new list<MRS_Layer_Chip_Association__c >();
                   for(MRS_Layer_Chip_Association__c objValue : lstLayerChipSummary)
                    {
                        if(keyId ==objValue.ptrf__c){
                             objOldValue=lstLayerChipSummaryOld[intCount];
                             
                              if((String.Valueof(objValue.Customer_GDSOUT_Review__c).equalsIgnoreCase('Approve') && String.Valueof(objOldValue.Customer_GDSOUT_Review__c).equalsIgnoreCase('Ready'))
                               )
                               {
                                   tempLayerChip.add(objValue);
                               }
                         }
                         intCount++;
                    }
                    mapCustomerGDSOUT.put(keyId ,tempLayerChip);
                }
            
            }
            if(tempLayerChip2!=null && tempLayerChip2.size()>0){
           
                for(Id keyId :tempLayerChip2){
                    intCount=0;
                    tempLayerChip=new list<MRS_Layer_Chip_Association__c >();
                   for(MRS_Layer_Chip_Association__c objValue : lstLayerChipSummary)
                    {
                        if(keyId ==objValue.ptrf__c){
                             objOldValue=lstLayerChipSummaryOld[intCount];
                             
                              if((String.Valueof(objValue.Foundry_GDSOUT_Review__c).equalsIgnoreCase('Approve') && String.Valueof(objOldValue.Foundry_GDSOUT_Review__c).equalsIgnoreCase('Ready'))
                               )
                               {
                                   tempLayerChip.add(objValue);
                               }
                         }
                         intCount++;
                    }
                    mapFoundryGDSOUT.put(keyId ,tempLayerChip);
                }
            
            }
             if(tempLayerChip3!=null && tempLayerChip3.size()>0){
           
                for(Id keyId :tempLayerChip3){
                    intCount=0;
                    tempLayerChip=new list<MRS_Layer_Chip_Association__c >();
                   for(MRS_Layer_Chip_Association__c objValue : lstLayerChipSummary)
                    {
                        if(keyId ==objValue.ptrf__c){
                             objOldValue=lstLayerChipSummaryOld[intCount];
                             
                              if((String.Valueof(objValue.Customer_Frame_Mockup__c).equalsIgnoreCase('Approve') && String.Valueof(objOldValue.Customer_Frame_Mockup__c).equalsIgnoreCase('Ready'))
                               )
                               {
                                   tempLayerChip.add(objValue);
                               }
                         }
                         intCount++;
                    }
                    mapCustomerFrameMockupApprove.put(keyId ,tempLayerChip);
                }
            
            }
             if(tempLayerChip4!=null && tempLayerChip4.size()>0){
           
                for(Id keyId :tempLayerChip4){
                    intCount=0;
                    tempLayerChip=new list<MRS_Layer_Chip_Association__c >();
                   for(MRS_Layer_Chip_Association__c objValue : lstLayerChipSummary)
                    {
                        if(keyId ==objValue.ptrf__c){
                             objOldValue=lstLayerChipSummaryOld[intCount];
                             
                              if((String.Valueof(objValue.Foundry_Frame_Mockup__c).equalsIgnoreCase('Approve') && String.Valueof(objOldValue.Foundry_Frame_Mockup__c).equalsIgnoreCase('Ready'))
                               )
                               {
                                   tempLayerChip.add(objValue);
                               }
                         }
                         intCount++;
                    }
                    mapFoundryFrameMockupApprove.put(keyId ,tempLayerChip);
                }
            
            }
             if(tempLayerChip5!=null && tempLayerChip5.size()>0){
           
                for(Id keyId :tempLayerChip5){
                    intCount=0;
                    tempLayerChip=new list<MRS_Layer_Chip_Association__c >();
                   for(MRS_Layer_Chip_Association__c objValue : lstLayerChipSummary)
                    {
                        if(keyId ==objValue.ptrf__c){
                             objOldValue=lstLayerChipSummaryOld[intCount];
                             
                              if((String.Valueof(objValue.Customer_Frame_Mockup__c).equalsIgnoreCase('Disapprove') && String.Valueof(objOldValue.Customer_Frame_Mockup__c).equalsIgnoreCase('Ready'))
                               )
                               {
                                   tempLayerChip.add(objValue);
                               }
                         }
                         intCount++;
                    }
                    mapCustomerFrameMockupDisapprove.put(keyId ,tempLayerChip);
                }
            
            }
             if(tempLayerChip6!=null && tempLayerChip6.size()>0){
           
                for(Id keyId :tempLayerChip6){
                    intCount=0;
                    tempLayerChip=new list<MRS_Layer_Chip_Association__c >();
                   for(MRS_Layer_Chip_Association__c objValue : lstLayerChipSummary)
                    {
                        if(keyId ==objValue.ptrf__c){
                             objOldValue=lstLayerChipSummaryOld[intCount];
                             
                              if((String.Valueof(objValue.Foundry_Frame_Mockup__c).equalsIgnoreCase('Disapprove') && String.Valueof(objOldValue.Foundry_Frame_Mockup__c).equalsIgnoreCase('Ready'))
                               )
                               {
                                   tempLayerChip.add(objValue);
                               }
                         }
                         intCount++;
                    }
                    mapFoundryFrameMockupDisapprove.put(keyId ,tempLayerChip);
                }
            
            }
             if(tempLayerChip7!=null && tempLayerChip7.size()>0){
           
                for(Id keyId :tempLayerChip7){
                    intCount=0;
                    tempLayerChip=new list<MRS_Layer_Chip_Association__c >();
                   for(MRS_Layer_Chip_Association__c objValue : lstLayerChipSummary)
                    {
                        if(keyId ==objValue.ptrf__c){
                             objOldValue=lstLayerChipSummaryOld[intCount];
                             
                              if((String.Valueof(objValue.Customer_MEBES_Jobview__c).equalsIgnoreCase('Released') && String.Valueof(objOldValue.Customer_MEBES_Jobview__c).equalsIgnoreCase('Ready'))
                               )
                               {
                                   tempLayerChip.add(objValue);
                               }
                         }
                         intCount++;
                    }
                    mapMebesCustomer.put(keyId ,tempLayerChip);
                }
            
            }
             if(tempLayerChip8!=null && tempLayerChip8.size()>0){
           
                for(Id keyId :tempLayerChip8){
                    intCount=0;
                    tempLayerChip=new list<MRS_Layer_Chip_Association__c >();
                   for(MRS_Layer_Chip_Association__c objValue : lstLayerChipSummary)
                    {
                        if(keyId ==objValue.ptrf__c){
                             objOldValue=lstLayerChipSummaryOld[intCount];
                             
                               if((String.Valueof(objValue.Foundry_MEBES_Jobview__c).equalsIgnoreCase('Released') && String.Valueof(objOldValue.Foundry_MEBES_Jobview__c).equalsIgnoreCase('Ready'))
                               )
                               {
                                   tempLayerChip.add(objValue);
                               }
                         }
                         intCount++;
                    }
                    mapMebesFoundry.put(keyId ,tempLayerChip);
                }
            
            }
             if(tempLayerChip9!=null && tempLayerChip9.size()>0){
           
                for(Id keyId :tempLayerChip9){
                    intCount=0;
                    tempLayerChip=new list<MRS_Layer_Chip_Association__c >();
                   for(MRS_Layer_Chip_Association__c objValue : lstLayerChipSummary)
                    {
                        if(keyId ==objValue.ptrf__c){
                             objOldValue=lstLayerChipSummaryOld[intCount];
                             
                              if((String.Valueof(objValue.Tapeout_Centre_MEBES_Jobview__c).equalsIgnoreCase('Released') && String.Valueof(objOldValue.Tapeout_Centre_MEBES_Jobview__c).equalsIgnoreCase('Ready'))
                               )
                               {
                                   tempLayerChip.add(objValue);
                               }
                         }
                         intCount++;
                    }
                    mapMebesTapeoutCentre.put(keyId ,tempLayerChip);
                }
            
            }
             if(tempLayerChip10!=null && tempLayerChip10.size()>0){
           
                for(Id keyId :tempLayerChip10){
                    intCount=0;
                    tempLayerChip=new list<MRS_Layer_Chip_Association__c >();
                   for(MRS_Layer_Chip_Association__c objValue : lstLayerChipSummary)
                    {
                        if(keyId ==objValue.ptrf__c){
                             objOldValue=lstLayerChipSummaryOld[intCount];
                             
                              if((String.Valueof(objValue.Tapeout_Applications_MEBES_Jobview__c).equalsIgnoreCase('Released') && String.Valueof(objOldValue.Tapeout_Applications_MEBES_Jobview__c).equalsIgnoreCase('Ready'))
                               )
                               {
                                   tempLayerChip.add(objValue);
                               }
                         }
                         intCount++;
                    }
                    mapMebesTapeoutApps.put(keyId ,tempLayerChip);
                }
            
            }
            
             if(tempLayerChip11!=null && tempLayerChip11.size()>0){
           
                for(Id keyId :tempLayerChip11){
                    intCount=0;
                    tempLayerChip=new list<MRS_Layer_Chip_Association__c >();
                   for(MRS_Layer_Chip_Association__c objValue : lstLayerChipSummary)
                    {
                        if(keyId ==objValue.ptrf__c){
                             objOldValue=lstLayerChipSummaryOld[intCount];
                             
                              if((String.Valueof(objValue.GlobalShuttle_MEBES_Jobview__c).equalsIgnoreCase('Released') && String.Valueof(objOldValue.GlobalShuttle_MEBES_Jobview__c).equalsIgnoreCase('Ready'))
                               )
                               {
                                   tempLayerChip.add(objValue);
                                  
                               }
                         }
                         intCount++;
                    }
                    
                    mapMebesGlobalshuttle.put(keyId ,tempLayerChip);
                }
            
            }
             if(tempLayerChip12!=null && tempLayerChip12.size()>0){
           
                for(Id keyId :tempLayerChip12){
                    intCount=0;
                    tempLayerChip=new list<MRS_Layer_Chip_Association__c >();
                   for(MRS_Layer_Chip_Association__c objValue : lstLayerChipSummary)
                    {
                        if(keyId ==objValue.ptrf__c){
                             objOldValue=lstLayerChipSummaryOld[intCount];
                             
                               if((String.Valueof(objValue.MDP_MEBES_Jobview__c).equalsIgnoreCase('Released') && String.Valueof(objOldValue.MDP_MEBES_Jobview__c).equalsIgnoreCase('Ready'))
                               )
                               {
                                   tempLayerChip.add(objValue);
                               }
                         }
                         intCount++;
                    }
                    mapMDP.put(keyId ,tempLayerChip);
                }
            
            }
             if(tempLayerChip13!=null && tempLayerChip13.size()>0){
           
                for(Id keyId :tempLayerChip13){
                    intCount=0;
                    tempLayerChip=new list<MRS_Layer_Chip_Association__c >();
                   for(MRS_Layer_Chip_Association__c objValue : lstLayerChipSummary)
                    {
                        if(keyId ==objValue.ptrf__c){
                             objOldValue=lstLayerChipSummaryOld[intCount];
                             
                              if((String.Valueof(objValue.TDTI_MPW_MEBES_Jobview__c).equalsIgnoreCase('Released') && String.Valueof(objOldValue.TDTI_MPW_MEBES_Jobview__c).equalsIgnoreCase('Ready'))
                               )
                               {
                                   tempLayerChip.add(objValue);
                               }
                         }
                         intCount++;
                    }
                    mapTDTI.put(keyId ,tempLayerChip);
                }
            
            }
            
            if(lstCustomerRemoteJobview!=null && lstCustomerRemoteJobview.size()>0){
                MRSHandlerutility.sendDoneEmailtoRemoteJobView(lstCustomerRemoteJobview,'',true,false,'');
            }
            if(lstFoundryRemoteJobview!=null && lstFoundryRemoteJobview.size()>0){
                MRSHandlerutility.sendDoneEmailtoRemoteJobView(lstFoundryRemoteJobview,'',false,true,'');
            }
            
            
            if(lstCustomerMebesJobview!=null && lstCustomerMebesJobview.size()>0){
                mebbesReceivedSendEmailToReviewersManualUpdate(lstCustomerMebesJobview,'','',true,true);
            }
            if(lstFoundryMebesJobview!=null && lstFoundryMebesJobview.size()>0){
                mebbesReceivedSendEmailToReviewersManualUpdate(lstFoundryMebesJobview,'','',false,false);
            }
            
            if(lstCustomerFrameMockup!=null && lstCustomerFrameMockup.size()>0){
                MRSHandlerutility.sendRedyMailToCustomerAndFoundry(lstCustomerFrameMockup);
            }
            if(lstFoundryFrameMockup!=null && lstFoundryFrameMockup.size()>0){
                MRSHandlerutility.sendRedyMailToCustomerAndFoundry(lstFoundryFrameMockup);
            }
            
            if(lstCustomerGDSOUTReview!=null && lstCustomerGDSOUTReview.size()>0){
                MRSHandlerutility.sendRedyMailToGDSOUTReviewManualUpdate(lstCustomerGDSOUTReview,'',true);
            }
            if(lstFoundryGDSOUTReview!=null && lstFoundryGDSOUTReview.size()>0){
                MRSHandlerutility.sendRedyMailToGDSOUTReviewManualUpdate(lstFoundryGDSOUTReview,'',false);
            }
            
            if(lstGlobalShuttle!=null && lstGlobalShuttle.size()>0){
                MRSHandlerutility.sendEmailToGlobalshuttle(lstGlobalShuttle,'','');
            }
            
            
            if(lstMDP!=null && lstMDP.size()>0){
                MRSHandlerutility.sendEmailToMDPUser(lstMDP,'','');
            }
            
            if(lstTapeoutApps!=null && lstTapeoutApps.size()>0){
                MRSHandlerutility.sendEmailToTapeoutApplication(lstTapeoutApps,'','');
            }
            
            if(lstTapeoutCentre!=null && lstTapeoutCentre.size()>0){
                MRSHandlerutility.sendEmailToTapeoutCentre(lstTapeoutCentre,'','');
            }
            
             if(mapCustomerGDSOUT!=null && mapCustomerGDSOUT.size()>0){
                MRSHandlerutility.sendEmailToReviewers(mapCustomerGDSOUT,'GDSOUTReview',strCustomerId,true,'','');
            }
              if(mapFoundryGDSOUT!=null && mapFoundryGDSOUT.size()>0){
                MRSHandlerutility.sendEmailToReviewers(mapFoundryGDSOUT,'GDSOUTReview',strCustomerId,true,'','');
            }
              if(mapCustomerFrameMockupApprove!=null && mapCustomerFrameMockupApprove.size()>0){
                MRSHandlerutility.sendEmailToReviewers(mapCustomerFrameMockupApprove,'CustomerFrameMockup',strCustomerId,true,'','');
            }
               if(mapFoundryFrameMockupApprove!=null && mapFoundryFrameMockupApprove.size()>0){
                MRSHandlerutility.sendEmailToReviewers(mapFoundryFrameMockupApprove,'FoundryFrameMockup',strCustomerId,true,'','');
            }
              if(mapCustomerFrameMockupDisapprove!=null && mapCustomerFrameMockupDisapprove.size()>0){
                MRSHandlerutility.sendEmailToReviewers(mapCustomerFrameMockupDisapprove,'CustomerFrameMockup',strCustomerId,false,'','');
            }
              if(mapFoundryFrameMockupDisapprove!=null && mapFoundryFrameMockupDisapprove.size()>0){
                MRSHandlerutility.sendEmailToReviewers(mapFoundryFrameMockupDisapprove,'FoundryFrameMockup',strCustomerId,false,'','');
            }
            
             if(mapMebesCustomer!=null && mapMebesCustomer.size()>0){
                MRSHandlerutility.sendEmailToReviewers(mapMebesCustomer,'MEBES Jobview - Customer',strCustomerId,false,'','');
            }
             if(mapMebesFoundry!=null && mapMebesFoundry.size()>0){
                MRSHandlerutility.sendEmailToReviewers(mapMebesFoundry,'MEBES Jobview - Foundry',strCustomerId,false,'','');
            }
            
             if(mapMebesTapeoutCentre!=null && mapMebesTapeoutCentre.size()>0){
                MRSHandlerutility.sendEmailToReviewers(mapMebesTapeoutCentre,'MEBES Jobview - TapeoutCenter',strCustomerId,false,'','');
            }
             if(mapMebesTapeoutApps!=null && mapMebesTapeoutApps.size()>0){
                MRSHandlerutility.sendEmailToReviewers(mapMebesTapeoutApps,'MEBES Jobview - TapeoutApplication',strCustomerId,false,'','');
            }
            
             if(mapMebesGlobalshuttle!=null && mapMebesGlobalshuttle.size()>0){
                MRSHandlerutility.sendEmailToReviewers(mapMebesGlobalshuttle,'MEBES Jobview - GlobalShuttle',strCustomerId,false,'','');
            }
            
             if(mapMDP!=null && mapMDP.size()>0){
                MRSHandlerutility.sendEmailToReviewers(mapMDP,'MEBES Jobview - MDP',strCustomerId,false,'','');
            }
             if(mapTDTI!=null && mapTDTI.size()>0){
             
                MRSHandlerutility.sendEmailToReviewers(mapTDTI,'MEBES Jobview - TDTIMPW',strCustomerId,false,'','');
            }
            
        }
       boolIsMailSent=true;
    }
    
   /**
            This method is for setting target page when export to CSV is done. 
            @method name: exportToCSV
            @parameter:   null
            @return :     PageReference object
     **/
    public PageReference exportToCSV(){
        PageReference np = new PageReference('/apex/VFMRSLayerChipSummarytoCSV');
        np.setRedirect(false);
        if(lstLayerChipSummary!=null && lstLayerChipSummary.size()>0){
            return np;
        }
        else
        {
            return null;
        }
   }
   
   /**
            This method is for setting target page when export to Excel is done. 
            @method name: exportToExcel
            @parameter:   null
            @return :     PageReference object
     **/
   public PageReference exportToExcel(){
        PageReference np = new PageReference('/apex/VFMRSLayerChipSummarytoExcel');
        np.setRedirect(false);
        if(lstLayerChipSummary!=null && lstLayerChipSummary.size()>0){
            return np;
        }
        else
        {
            return null;
        }
   }
   
   /**
            This method is for setting target page when manual update export to CSV is done. 
            @method name: manualExportToCSV
            @parameter:   null
            @return :     PageReference object
     **/
   public PageReference manualExportToCSV(){
        viewLayerChipData();
        PageReference np = new PageReference('/apex/VFMRSLayerChipSummaryManualUpdateToCSV');
        np.setRedirect(false);
        if(lstLayerChipSummary!=null && lstLayerChipSummary.size()>0){
            return np;
        }
        else
        {
            return null;
        }
   }
   
   /**
            This method is for setting target page when manual update export to Excel is done. 
            @method name: manualExportToExcel
            @parameter:   null
            @return :     PageReference object
     **/
   public PageReference manualExportToExcel(){
        viewLayerChipData();
        PageReference np = new PageReference('/apex/VFMRSLayerChipSummarytoExcel');
        np.setRedirect(false);
        if(lstLayerChipSummary!=null && lstLayerChipSummary.size()>0){
            return np;
        }
        else
        {
            return null;
        }
   }
   
   /**
            This method is for setting target page when 'manual update' button is clicked. 
            @method name: openManualUpdate
            @parameter:   null
            @return :     PageReference object
     **/
   public PageReference openManualUpdate(){
        
        PageReference np;
        string strText='&layer_chip_status='+(statusSelectedValue!=null?statusSelectedValue:'')+'&device_id='+(deviceSelectedValue!=null?deviceSelectedValue:'')+'&ptrf_drt='+(ptrfSelectedValue!=null?ptrfSelectedValue:'')+'&tech_geo='+(techgeoSelectedValue!=null?techgeoSelectedValue:'')+'';
        
        if(isBreadcrumbActive==true){
            np = new PageReference(System.Label.SWIFT_Community_URL +'VFMRSLayerChipSummaryManualUpdate?id='+idCurrentLayer+'&customerid='+strCustomerId+'&mstid='+strMstId+'&customer='+strCustomer+strText);
        }else{
            np = new PageReference(System.Label.Internal_URL +'VFMRSLayerChipSummaryManualUpdate?id='+idCurrentLayer+'&customerid='+strCustomerId+'&mstid='+strMstId+'&customer='+strCustomer+strText);        
        }
        np.setRedirect(false);
        if(lstLayerChipSummary!=null && lstLayerChipSummary.size()>0){
            return np;
        }
        else
        {
            return null;
        }
   }
   
   /**
            This method is for setting target page when 'Back to Layer Chip Summary' button is clicked. 
            @method name: openLayerChipPage
            @parameter:   null
            @return :     PageReference object
     **/
   public PageReference openLayerChipPage(){
        
        PageReference np;
        string strText='&layer_chip_status='+(statusSelectedValue!=null?statusSelectedValue:'')+'&device_id='+(deviceSelectedValue!=null?deviceSelectedValue:'')+'&ptrf_drt='+(ptrfSelectedValue!=null?ptrfSelectedValue:'')+'&tech_geo='+(techgeoSelectedValue!=null?techgeoSelectedValue:'')+'';
        if(isBreadcrumbActive==true){
            np = new PageReference(System.Label.SWIFT_Community_URL + 'VFMRSLayerChipSummary?id='+idCurrentLayer+'&customerid='+strCustomerId+'&mstid='+strMstId+'&customer='+strCustomer+strText);
        }else{
            np = new PageReference(System.Label.Internal_URL +'VFMRSLayerChipSummary?id='+idCurrentLayer+'&customerid='+strCustomerId+'&mstid='+strMstId+'&customer='+strCustomer+strText);        
        }
        np.setRedirect(false);
        return np;
   }
   
   /**
            This method is for getting Customer Name. 
            @method name: setCustomerName
            @parameter:   1. Customer Id
            @return :     void
     **/
    public void setCustomerName(string idCustomer)
    {
         Account objAcc=[SELECT name,Short_Name__c FROM Account WHERE id=:idCustomer];
         if (objAcc!=null ){
             if(objAcc.Short_Name__c!=null && objAcc.Short_Name__c!=''){
                 strCustomerName=objAcc.name+' ('+objAcc.Short_Name__c+')';
             }else{
                 strCustomerName=objAcc.name;
             }
         }
    }
    
    /**
            This method is for clearing selected data when Clear button is clicked. 
            @method name: clearLayerChipData
            @parameter:   null
            @return :     void
     **/
    public void clearLayerChipData()
    {
        
        ValueCatcher ='';
        statusSelectedValue='';
        viewLayerChipData();
    }
    
    /**
            This method is for setting Stage filter checkbox visibility based on user priveleges. 
            @method name: setViewCheckbox
            @parameter:   null
            @return :     void
     **/
    private void setViewCheckbox(){
    
        boolShowGDSOUT=(boolGDSOUTReviewCustomer==true || boolGDSOUTReviewFoundry==true) ? true:false;
        boolShowFrameMockup=(boolFrameMockupCustomer==true || boolFrameMockupFoundry==true) ? true:false;
        boolShowSendData=(boolSendDataPrime==true || boolSendDataFrame==true) ? true:false;
        boolShowORC=(boolORC==true) ? true:false;
        boolShowDRW=(boolDRW==true) ? true:false;
        boolShowRemoteJobview=(boolCustomerRemoteJobviewPrime==true || boolCustomerRemoteJobviewFrame==true || boolFoundryRemoteJobviewPrime==true || boolFoundryRemoteJobviewFrame==true) ? true:false;
        boolShowMebesRecieved=(boolMEBESReceivedPrime==true || boolMEBESReceivedFrame==true) ? true:false;
        boolShowMebesJobview=(boolMEBESJobviewCustomer==true || boolMEBESJobviewFoundry==true || boolMEBESJobviewTapeoutCenter==true || boolMEBESJobviewTapeoutAPPLICATIONS==true || boolMEBESJobviewGlobalShuttle==true || boolMEBESJobviewMDP==true || boolMEBESJobviewTDTIMPW==true) ? true:false;
    
    }
    
    /**
            This method is for getting MRS Layer Chip data according to filters. 
            @method name: viewLayerChipData
            @parameter:   null
            @return :     void
     **/
    public void viewLayerChipData()
    {
        string DRW_value='';
        setDefaultValues();
        setViewPermissionForUser();
        setViewCheckbox();
        setFieldsForFilter();
        if(techgeoSelectedValue!=null && techgeoSelectedValue!=''){
            techgeoSelectedText=mapTechGeoValues.get(techgeoSelectedValue);
        }
        if(flagController!=true) strSelectedLayerChipStatus=statusSelectedValue;
        flagController=false;
        map<String,String> mapStatusDate=new map<String,String>();
        lstLayerChipWrapper=new List<LayerChipSummaryWrapper >();
        LayerChipSummaryWrapper objWrapper;
        lstLayerChipSummary=new List<MRS_Layer_Chip_Association__c>();
        if(idCurrentLayer!=null && idCurrentLayer!='')
        {
            lstLayerChipSummary=searchMrsChipLayerSummary(idCurrentLayer,deviceSelectedValue,statusSelectedValue,ptrfSelectedValue,techgeoSelectedValue); 
            objLayerSummaryDetails = [SELECT Name,ROM_Code__c,Mask_Layer_Rev__c,Mask_Set_Title_Name__c,Layer_Status__c, Customer_GDSOUT_Review__c, Foundry_GDSOUT_Review__c, Customer_Frame_Mockup__c, Foundry_Frame_Mockup__c, Send_Prime_Data__c, Send_Frame_Data__c, ORC__c, DRW__c, Prime_MEBES_Received__c, Frame_MEBES_Received__c, Customer_MEBES_Jobview__c, Foundry_MEBES_Jobview__c, Tapeout_Centre_MEBES_Jobview__c, Tapeout_Applications_MEBES_Jobview__c, GlobalShuttle_MEBES_Jobview__c, MDP_MEBES_Jobview__c, TDTI_MPW_MEBES_Jobview__c, Customer_Prime_Remote_Jobview_Setup__c, Customer_Frame_Remote_Jobview_Setup__c, Foundry_Prime_Remote_Jobview_Setup__c, Foundry_Frame_Remote_Jobview_Setup__c,Tech_geo__c from MRS_Layer_Association__c where id=:idCurrentLayer LIMIT 1];   
        }
       
        if(lstLayerChipSummary!=null && lstLayerChipSummary.size()>0)
        {
            integer counter=1;
            boolean isEven=false;
            string PtrfOrDrt='';
            string strPtrfDrtID ='';
            string strPtrfDrtLink ='';
            lstLayerChipSummaryOld=lstLayerChipSummary.deepclone(true,false,false);
            for(MRS_Layer_Chip_Association__c objLayerChip:lstLayerChipSummary)
            {
                
                 mapStatusDate=new map<String,String>();
                 if(Math.mod(counter,2)==0)
                {
                    isEven=true;
                }
                else{
                    isEven=false;
                }
                if(objLayerChip.PTRF_Or_DRT__c=='DRT'){
                    PtrfOrDrt=objLayerChip.DRT__r.name;
                    strPtrfDrtID =objLayerChip.DRT__c;
                    
                    if(isBreadcrumbActive==true){
                        strPtrfDrtLink = '/GlobalfoundryView/apex/MyDevices?iframe=VFDRTDetail&id='+objLayerChip.DRT__c;
                    }else{
                        strPtrfDrtLink = '/apex/MyDevices?iframe=VFDRTDetail&id='+objLayerChip.DRT__c;
                    }
                }else
                {
                   PtrfOrDrt=objLayerChip.PTRF__r.name;
                   strPtrfDrtID =objLayerChip.PTRF__c;
                   if(isBreadcrumbActive==true){    
                       //strPtrfDrtLink =System.Label.SWIFT_Community_URL+'VFMRSPTRFDetail?ptrfURL='+objLayerChip.PTRF__c;
                       
                       // TASK-2469
                       strPtrfDrtLink =System.Label.HYPERLINK_TO_SWIFT + objLayerChip.PTRF__r.Name;
                       // TASK-2469 END
                   }else{
                       //strPtrfDrtLink =Label.Internal_URL+'VFMRSPTRFDetail?ptrfURL='+objLayerChip.PTRF__c;
                       
                       // TASK-2469
                       strPtrfDrtLink =System.Label.HYPERLINK_TO_SWIFT + objLayerChip.PTRF__r.Name;
                       // TASK-2469 END
                   }
                   
                   System.debug('$#$# ptrf link: ' + strPtrfDrtLink);
                }
              
                mapStatusDate.put('Customer_GDSOUT_Review_Date__c',String.valueof(objLayerChip.Customer_GDSOUT_Review_Date__c==null?'':objLayerChip.Customer_GDSOUT_Review_Date__c.format()));
                mapStatusDate.put('Foundry_GDSOUT_Review_Date__c',String.valueof(objLayerChip.Foundry_GDSOUT_Review_Date__c==null?'':objLayerChip.Foundry_GDSOUT_Review_Date__c.format()));
                mapStatusDate.put('Customer_Frame_Mockup_Date__c',String.valueof(objLayerChip.Customer_Frame_Mockup_Date__c==null?'':objLayerChip.Customer_Frame_Mockup_Date__c.format()));
                mapStatusDate.put('Foundry_Frame_Mockup_Date__c',String.valueof(objLayerChip.Foundry_Frame_Mockup_Date__c==null?'':objLayerChip.Foundry_Frame_Mockup_Date__c.format()));
                mapStatusDate.put('Send_Prime_Data_Date__c',String.valueof(objLayerChip.Send_Prime_Data_Date__c==null?'':objLayerChip.Send_Prime_Data_Date__c.format()));
                mapStatusDate.put('Send_Frame_Data_Date__c',String.valueof(objLayerChip.Send_Frame_Data_Date__c==null?'':objLayerChip.Send_Frame_Data_Date__c.format()));
                mapStatusDate.put('ORC_Date__c',String.valueof(objLayerChip.ORC_Date__c==null?'':objLayerChip.ORC_Date__c.format()));
                
                if(objLayerChip.DRW__c!=null && objLayerChip.DRW__c!='' && String.valueof(objLayerChip.DRW__c).touppercase()=='DONE' && objLayerChip.ptrf__r.DRW_Disposition__c!=null && objLayerChip.ptrf__r.DRW_Disposition__c!='' ){
                   DRW_value= objLayerChip.ptrf__r.DRW_Disposition__c+'  '+String.valueof(objLayerChip.DRW_Date__c==null?'':objLayerChip.DRW_Date__c.format());
                }else
                {
                    DRW_value=String.valueof(objLayerChip.DRW_Date__c==null?'':objLayerChip.DRW_Date__c.format());
                }
                mapStatusDate.put('DRW_Date__c',DRW_value);
                
                mapStatusDate.put('Customer_Prime_Remote_Jobview_Setup_Date__c',String.valueof(objLayerChip.Customer_Prime_Remote_Jobview_Setup_Date__c==null?'':objLayerChip.Customer_Prime_Remote_Jobview_Setup_Date__c.format()));
                mapStatusDate.put('Customer_Frame_Remote_Jobview_Setup_Date__c',String.valueof(objLayerChip.Customer_Frame_Remote_Jobview_Setup_Date__c==null?'':objLayerChip.Customer_Frame_Remote_Jobview_Setup_Date__c.format()));
                mapStatusDate.put('Foundry_Prime_Remote_Jobview_Setup_Date__c',String.valueof(objLayerChip.Foundry_Prime_Remote_Jobview_Setup_Date__c==null?'':objLayerChip.Foundry_Prime_Remote_Jobview_Setup_Date__c.format()));
                mapStatusDate.put('Foundry_Frame_Remote_Jobview_Setup_Date__c',String.valueof(objLayerChip.Foundry_Frame_Remote_Jobview_Setup_Date__c==null?'':objLayerChip.Foundry_Frame_Remote_Jobview_Setup_Date__c.format()));
                mapStatusDate.put('Prime_MEBES_Received_Date__c',String.valueof(objLayerChip.Prime_MEBES_Received_Date__c==null?'':objLayerChip.Prime_MEBES_Received_Date__c.format()));
                mapStatusDate.put('Frame_MEBES_Received_Date__c',String.valueof(objLayerChip.Frame_MEBES_Received_Date__c==null?'':objLayerChip.Frame_MEBES_Received_Date__c.format()));
                mapStatusDate.put('Customer_MEBES_Jobview_Date__c',String.valueof(objLayerChip.Customer_MEBES_Jobview_Date__c==null?'':objLayerChip.Customer_MEBES_Jobview_Date__c.format()));
                mapStatusDate.put('Foundry_MEBES_Jobview_Date__c',String.valueof(objLayerChip.Foundry_MEBES_Jobview_Date__c==null?'':objLayerChip.Foundry_MEBES_Jobview_Date__c.format()));
                mapStatusDate.put('Tapeout_Centre_MEBES_Jobview_Date__c',String.valueof(objLayerChip.Tapeout_Centre_MEBES_Jobview_Date__c==null?'':objLayerChip.Tapeout_Centre_MEBES_Jobview_Date__c.format()));
                mapStatusDate.put('Tapeout_Applications_MEBES_Jobview_Date__c',String.valueof(objLayerChip.Tapeout_Applications_MEBES_Jobview_Date__c==null?'':objLayerChip.Tapeout_Applications_MEBES_Jobview_Date__c.format()));
                mapStatusDate.put('GlobalShuttle_MEBES_Jobview_Date__c',String.valueof(objLayerChip.GlobalShuttle_MEBES_Jobview_Date__c==null?'':objLayerChip.GlobalShuttle_MEBES_Jobview_Date__c.format()));
                mapStatusDate.put('MDP_MEBES_Jobview_Date__c',String.valueof(objLayerChip.MDP_MEBES_Jobview_Date__c==null?'':objLayerChip.MDP_MEBES_Jobview_Date__c.format()));
                mapStatusDate.put('TDTI_MPW_MEBES_Date__c',String.valueof(objLayerChip.TDTI_MPW_MEBES_Date__c==null?'':objLayerChip.TDTI_MPW_MEBES_Date__c.format()));
                mapStatusDate.put('Layer_Chip_Status_Date__c',String.valueof(objLayerChip.Layer_Chip_Status_Date__c==null?'':objLayerChip.Layer_Chip_Status_Date__c.format()));
               
                objWrapper=new LayerChipSummaryWrapper(counter,isEven,objLayerChip.ID,objLayerChip.Chip_Name__c,PtrfOrDrt,strPtrfDrtID ,objLayerChip.Layer_Chip_Status__c,objLayerChip.Customer_GDSOUT_Review__c
                ,objLayerChip.Foundry_GDSOUT_Review__c,objLayerChip.Customer_Frame_Mockup__c,objLayerChip.Foundry_Frame_Mockup__c,objLayerChip.Send_Prime_Data__c,objLayerChip.Send_Frame_Data__c,objLayerChip.ORC__c,objLayerChip.DRW__c
                ,objLayerChip.Customer_Prime_Remote_Jobview_Setup__c,objLayerChip.Customer_Frame_Remote_Jobview_Setup__c,objLayerChip.Foundry_Prime_Remote_Jobview_Setup__c,objLayerChip.Foundry_Frame_Remote_Jobview_Setup__c
                ,objLayerChip.Prime_MEBES_Received__c,objLayerChip.Frame_MEBES_Received__c,objLayerChip.Customer_MEBES_Jobview__c,objLayerChip.Foundry_MEBES_Jobview__c,objLayerChip.Tapeout_Centre_MEBES_Jobview__c
                ,objLayerChip.Tapeout_Applications_MEBES_Jobview__c,objLayerChip.GlobalShuttle_MEBES_Jobview__c,objLayerChip.MDP_MEBES_Jobview__c,objLayerChip.TDTI_MPW_MEBES_Jobview__c
                ,mapStatusDate,strPtrfDrtLink );
                
                lstLayerChipWrapper.add(objWrapper);
                counter++;
                
            }
           
        }
     
    }
     
  
   /**
            This wrapper class is for storing Layer Chip Assoc data to be used by UI. 
            @wrapperclass: LayerChipSummaryWrapper 
     **/
 public class LayerChipSummaryWrapper {
 
        public Integer intSlno {get;set;}
        public boolean boolHighlightColor {get;set;}

        public String strLayerChipAssociationId {get;set;}
        public String strChipName {get;set;}
        public String strPtrfDrtNumber {get;set;}
        public String strLayerChipStatus {get;set;}
        
        public String strPtrfDrtID {get;set;}
        public String strPtrfDrtLink {get;set;}
               
        public String strGDSOUTReviewCustomer {get;set;}
        public String strGDSOUTReviewFoundry {get;set;}
        public String strFrameMockupCustomer{get;set;}
        public String strFrameMockupFoundry{get;set;}
        public String strSendDataPrime{get;set;}
        public String strSendDataFrame{get;set;}
        public String strORC{get;set;}
        public String strDRW {get;set;}
        public String strCustomerRemoteJobviewPrime {get;set;}
        public String strCustomerRemoteJobviewFrame {get;set;}
        public String strFoundryRemoteJobviewPrime {get;set;}
        public String strFoundryRemoteJobviewFrame {get;set;}
        public String strMebesRecievedPrime {get;set;}
        public String strMebesRecievedFrame {get;set;}
        public String strMebesJobviewCustomer {get;set;}
        public String strMebesJobviewFoundry {get;set;}
        public String strMebesJobviewTapeoutCentre {get;set;}        
        public String strMebesJobviewTapeoutApp {get;set;}
        public String strMebesJobviewGlobalShuttle {get;set;}
        public String strMebesJobviewMDP {get;set;}
        public String strMebesJobviewTDTI_MPW {get;set;}
        
        public Map<String,String> mapStatusChangeDate {get;set;}      

        public layerChipSummaryWrapper (integer intSlno ,boolean boolHighlightColor , String strLayerChipAssociationId ,String strChipName ,String strPtrfDrtNumber,String strPtrfDrtID ,String strLayerChipStatus 
        ,String strGDSOUTReviewCustomer ,String strGDSOUTReviewFoundry ,String strFrameMockupCustomer,String strFrameMockupFoundry
        ,String strSendDataPrime,String strSendDataFrame,String strORC,String strDRW 
        ,String strCustomerRemoteJobviewPrime ,String strCustomerRemoteJobviewFrame ,String strFoundryRemoteJobviewPrime ,String strFoundryRemoteJobviewFrame 
        ,String strMebesRecievedPrime ,String strMebesRecievedFrame ,String strMebesJobviewCustomer ,String strMebesJobviewFoundry 
        ,String strMebesJobviewTapeoutCentre ,String strMebesJobviewTapeoutApp ,String strMebesJobviewGlobalShuttle ,String strMebesJobviewMDP
        ,String strMebesJobviewTDTI_MPW,Map<String,String> mapStatusChangeDate,String strPtrfDrtLink ) {
            
            this.intSlno = intSlno ;
            this.boolHighlightColor = boolHighlightColor ;
            
            this.strLayerChipAssociationId = strLayerChipAssociationId ;
            this.strChipName = strChipName ;
            this.strPtrfDrtNumber = strPtrfDrtNumber ;
            this.strLayerChipStatus = strLayerChipStatus ;
            this.strPtrfDrtID = strPtrfDrtID ;
            this.strPtrfDrtLink = strPtrfDrtLink ;
            
            this.strGDSOUTReviewCustomer = strGDSOUTReviewCustomer ;
            this.strGDSOUTReviewFoundry = strGDSOUTReviewFoundry ;
            this.strFrameMockupCustomer= strFrameMockupCustomer;
            this.strFrameMockupFoundry= strFrameMockupFoundry;
            this.strSendDataPrime= strSendDataPrime;
            this.strSendDataFrame= strSendDataFrame;
            this.strORC= strORC;
            this.strDRW = strDRW ;
            this.strCustomerRemoteJobviewPrime = strCustomerRemoteJobviewPrime ;
            this.strCustomerRemoteJobviewFrame = strCustomerRemoteJobviewFrame ;
            this.strFoundryRemoteJobviewPrime = strFoundryRemoteJobviewPrime ;
            this.strFoundryRemoteJobviewFrame = strFoundryRemoteJobviewFrame ;
            this.strMebesRecievedPrime = strMebesRecievedPrime ;
            this.strMebesRecievedFrame = strMebesRecievedFrame ;
            this.strMebesJobviewCustomer = strMebesJobviewCustomer ;
            this.strMebesJobviewFoundry = strMebesJobviewFoundry ;
            this.strMebesJobviewTapeoutCentre = strMebesJobviewTapeoutCentre ;
            this.strMebesJobviewTapeoutApp = strMebesJobviewTapeoutApp ;
            this.strMebesJobviewGlobalShuttle = strMebesJobviewGlobalShuttle ;
            this.strMebesJobviewMDP = strMebesJobviewMDP ;
            this.strMebesJobviewTDTI_MPW = strMebesJobviewTDTI_MPW ;
            
            this.mapStatusChangeDate = mapStatusChangeDate ;
           
            
        }
    }
   
  public void mebbesReceivedSendEmailToReviewersManualUpdate(List<MRS_Layer_Chip_Association__c> sendDoneEmailtoJobView,String Jobdeck,String emailContentFromCadSystem,Boolean customerOrFoundry,Boolean IsCustomer)
  {
    
    Map<String,List<MRS_Layer_Chip_Association__c>> mapLCACategory= new Map<String,List<MRS_Layer_Chip_Association__c>>();
    
    Map<String,Map<String,String>> mapPTRFtoData =new Map<string,Map<String,String>>(); 
    
     Map<String,String> nameValue = new Map<String,String>();
        if(Jobdeck != null){
            nameValue.put('JOBDECK',Jobdeck);
        }
        if(emailContentFromCadSystem != null){
            nameValue.put('JOBVIEW_REMARK',emailContentFromCadSystem);
        }
             
        
        Map<String,String> tempMap =new Map<String,String>(); 
        EmailTemplate etCustomerGating = mapEmailTemplateAndName.get('Swift_Customer_Gating_MEBES_Recieved_Initial'); // Obsolete : Swift_Gating_MEBES_Recieved_Initial
        EmailTemplate etCustomerNonGating = mapEmailTemplateAndName.get('SWIFT_Customer_Non_Gating_MEBES_Recieved_Initial');// Obsolete : SWIFT_Non_Gating_MEBES_Recieved_Initial
        EmailTemplate etFoundryGating = mapEmailTemplateAndName.get('Swift_Foundry_Gating_MEBES_Recieved_Initial');
        EmailTemplate etFoundryNonGating = mapEmailTemplateAndName.get('SWIFT_Foundry_Non_Gating_MEBES_Recieved_Initial');
        
       if(emailContentFromCadSystem ==  null){
         emailContentFromCadSystem ='';
       }
    Set<Id> lstgettingPTRF = new Set<Id>();
    Set<Id> lstnongettingPTRF = new Set<Id>();
    Set<Id> lstFoundrygatting = new Set<Id>();
    Set<Id> lstFoundrynongatting = new Set<Id>();
    Set<Id> lstPTRFId = new Set<Id>();
    Set<Id> lstLayerId = new Set<Id>();
    Set<Id> mrsLayerChipId = new Set<Id>();
    Map<Id,List<MRS_Layer_Chip_Association__c>> mrsLayerChipIdandlst = new Map<Id,List<MRS_Layer_Chip_Association__c>>();
    Map<Id,List<MRS_Layer_Chip_Association__c>> mrsLayerChipIdandlstFoundry = new Map<Id,List<MRS_Layer_Chip_Association__c>>();
    for(MRS_Layer_Chip_Association__c mrsLayerChipObj : sendDoneEmailtoJobView)
    {
      if(mrsLayerChipObj.Layer_Chip_Status__c != 'Cancel' &&  mrsLayerChipObj.Layer_Chip_Status__c != 'Void'){
          if(IsCustomer==true && mrsLayerChipObj.Customer_MEBES_Jobview__c == 'Ready' &&  mrsLayerChipObj.PTRF__r.Customer_Jobview__c == 'Gating mask release'){
              lstPTRFId.add(mrsLayerChipObj.PTRF__c);
              lstLayerId.add(mrsLayerChipObj.Layer__c);
              mrsLayerChipId.add(mrsLayerChipObj.Id);
              if(mrsLayerChipIdandlst.containsKey(mrsLayerChipObj.PTRF__c)){
                 mrsLayerChipIdandlst.get(mrsLayerChipObj.PTRF__c).add(mrsLayerChipObj);
              }else{
                 List<MRS_Layer_Chip_Association__c> mrsLayerChiplst = new List<MRS_Layer_Chip_Association__c>();
                 mrsLayerChiplst.add(mrsLayerChipObj);
                 mrsLayerChipIdandlst.put(mrsLayerChipObj.PTRF__c,mrsLayerChiplst);
              }
          }
          else if(mrsLayerChipObj.Customer_MEBES_Jobview__c == 'N.A.' &&  mrsLayerChipObj.PTRF__r.Customer_Jobview__c == 'Not gating mask release'){//TASK-1955
              lstPTRFId.add(mrsLayerChipObj.PTRF__c);
              lstLayerId.add(mrsLayerChipObj.Layer__c);
              mrsLayerChipId.add(mrsLayerChipObj.Id);
              if(mrsLayerChipIdandlst.containsKey(mrsLayerChipObj.PTRF__c)){
                 mrsLayerChipIdandlst.get(mrsLayerChipObj.PTRF__c).add(mrsLayerChipObj);
              }else{
                 List<MRS_Layer_Chip_Association__c> mrsLayerChiplst = new List<MRS_Layer_Chip_Association__c>();
                 mrsLayerChiplst.add(mrsLayerChipObj);
                 mrsLayerChipIdandlst.put(mrsLayerChipObj.PTRF__c,mrsLayerChiplst);
              }
          }
           if(IsCustomer ==false && mrsLayerChipObj.Foundry_MEBES_Jobview__c == 'Ready' && mrsLayerChipObj.PTRF__r.Foundry_Jobview__c == 'Gating mask release'){
              lstPTRFId.add(mrsLayerChipObj.PTRF__c);
              lstLayerId.add(mrsLayerChipObj.Layer__c);
              mrsLayerChipId.add(mrsLayerChipObj.Id);
              if(mrsLayerChipIdandlstFoundry.containsKey(mrsLayerChipObj.PTRF__c)){
                 mrsLayerChipIdandlstFoundry.get(mrsLayerChipObj.PTRF__c).add(mrsLayerChipObj);
              }else{
                 List<MRS_Layer_Chip_Association__c> mrsLayerChiplst = new List<MRS_Layer_Chip_Association__c>();
                 mrsLayerChiplst.add(mrsLayerChipObj);
                 mrsLayerChipIdandlstFoundry.put(mrsLayerChipObj.PTRF__c,mrsLayerChiplst);
              }
          }
          else if(mrsLayerChipObj.Foundry_MEBES_Jobview__c == 'N.A.' && mrsLayerChipObj.PTRF__r.Foundry_Jobview__c == 'Not gating mask release'){//TASK-1955
              lstPTRFId.add(mrsLayerChipObj.PTRF__c);
              lstLayerId.add(mrsLayerChipObj.Layer__c);
              mrsLayerChipId.add(mrsLayerChipObj.Id);
              if(mrsLayerChipIdandlstFoundry.containsKey(mrsLayerChipObj.PTRF__c)){
                 mrsLayerChipIdandlstFoundry.get(mrsLayerChipObj.PTRF__c).add(mrsLayerChipObj);
              }else{
                 List<MRS_Layer_Chip_Association__c> mrsLayerChiplst = new List<MRS_Layer_Chip_Association__c>();
                 mrsLayerChiplst.add(mrsLayerChipObj);
                 mrsLayerChipIdandlstFoundry.put(mrsLayerChipObj.PTRF__c,mrsLayerChiplst);
              }
          }
      }
    }
    
    Map<String,List<String>> chipLayerMap = new Map<String,List<String>>();
    String IsGating='';
    for(Id ptrfIdIterator: mrsLayerChipIdandlst.keySet()){
        String subject;
        String htmlValue;
        chipLayerMap.clear();
        List<MRS_Layer_Chip_Association__c> mrsLayerChiplst = mrsLayerChipIdandlst.get(ptrfIdIterator);
        if(mrsLayerChiplst != null && mrsLayerChiplst.size() > 0){
            if((mrsLayerChiplst.get(0).PTRF__r.Customer_jobview__c =='Gating mask release' && mrsLayerChiplst.get(0).Customer_MEBES_Jobview__c == 'Ready')) 
                
              {
                subject = etCustomerGating.subject;
                htmlValue = etCustomerGating.HtmlValue;
                IsGating='Y';
                
                if(!mapLCACategory.containsKey('CustomerGating')){
                    mapLCACategory.put('CustomerGating',mrsLayerChiplst);
                }else{
                    mapLCACategory.get('CustomerGating').addAll(mrsLayerChiplst);
                } 
              }
              else if((mrsLayerChiplst.get(0).PTRF__r.Customer_jobview__c =='Not gating mask release' && mrsLayerChiplst.get(0).Customer_MEBES_Jobview__c == 'N.A.'))
              {
                subject = etCustomerNonGating.subject;
                htmlValue = etCustomerNonGating.HtmlValue;
                IsGating='N';
                
                if(!mapLCACategory.containsKey('CustomerNotGating')){
                    mapLCACategory.put('CustomerNotGating',mrsLayerChiplst);
                }else{
                    mapLCACategory.get('CustomerNotGating').addAll(mrsLayerChiplst);
                } 
              }
             
        }
        tempMap=new Map<String,String>(); 
        tempMap.put(Label.EmailKeysetForTemplate,(IsGating=='Y'?etCustomerGating.DeveloperName:etCustomerNonGating.DeveloperName));
                tempMap.put(Label.EmailKeysetForGatingNotGating,IsGating);
                tempMap.put(Label.EmailKeysetForBody,htmlValue );
                tempMap.put(Label.EmailKeysetForSubject,subject);
       
                mapPTRFtoData.put(ptrfIdIterator,tempMap);
    }
    /*
    if(mapPTRFtoData.size() > 0){
         try{
             EmailHandlerUtility.ptrfEmailMethod(mapPTRFtoData);
         }catch(Exception ex){
            system.debug(ex);
         }
         }
         */
         if(tempmap.size()>0){
         tempMap.clear();
         }
         mapPTRFtoData.clear();
    chipLayerMap.clear();
    for(Id ptrfIdIterator : mrsLayerChipIdandlstFoundry.keySet()){
        
        String subject;
        String htmlValue;
        chipLayerMap.clear();
        List<MRS_Layer_Chip_Association__c> mrsLayerChiplst = mrsLayerChipIdandlstFoundry.get(ptrfIdIterator);
        if(mrsLayerChiplst != null && mrsLayerChiplst.size() > 0){
            if((mrsLayerChiplst.get(0).PTRF__r.Foundry_jobview__c =='Gating mask release' && mrsLayerChiplst.get(0).Foundry_MEBES_Jobview__c == 'Ready')) 
                
              {
                subject = etFoundryGating.subject;
                htmlValue = etFoundryGating.HtmlValue;
                IsGating='Y';
                
                if(!mapLCACategory.containsKey('FoundryGating')){
                    mapLCACategory.put('FoundryGating',mrsLayerChiplst);
                }else{
                    mapLCACategory.get('FoundryGating').addAll(mrsLayerChiplst);
                } 
              }
              else if((mrsLayerChiplst.get(0).PTRF__r.Foundry_jobview__c =='Not gating mask release' && mrsLayerChiplst.get(0).Foundry_MEBES_Jobview__c == 'N.A.'))
              {
                subject = etFoundryNonGating.subject;
                htmlValue = etFoundryNonGating.HtmlValue;
                IsGating='N';
                
                if(!mapLCACategory.containsKey('FoundryNotGating')){
                    mapLCACategory.put('FoundryNotGating',mrsLayerChiplst);
                }else{
                    mapLCACategory.get('FoundryNotGating').addAll(mrsLayerChiplst);
                } 
              }
              
              
        }
        
    
    }
    /*
    if(mapPTRFtoData.size() > 0){
         try{
             EmailHandlerUtility.ptrfEmailMethod(mapPTRFtoData);
         }catch(Exception ex){
            system.debug(ex);
         }
         }
         */
         
         EmailSubjectBodyPerPTRF emailObject = new EmailSubjectBodyPerPTRF();
         if(mapLCACategory.containsKey('CustomerGating')){
            emailObject.emailSubBodyPerPTRF(mapLCACategory.get('CustomerGating'),'Swift_Customer_Gating_MEBES_Recieved_Initial',nameValue,'Y','Customer_MEBES_Jobview__c');
         } 
         if(mapLCACategory.containsKey('CustomerNotGating')){
            emailObject.emailSubBodyPerPTRF(mapLCACategory.get('CustomerNotGating'),'SWIFT_Customer_Non_Gating_MEBES_Recieved_Initial',nameValue,'N',null);
         } 
         if(mapLCACategory.containsKey('FoundryGating')){
            emailObject.emailSubBodyPerPTRF(mapLCACategory.get('FoundryGating'),'Swift_Foundry_Gating_MEBES_Recieved_Initial',nameValue,'Y','Foundry_MEBES_Jobview__c');
         } 
         if(mapLCACategory.containsKey('FoundryNotGating')){
            emailObject.emailSubBodyPerPTRF(mapLCACategory.get('FoundryNotGating'),'SWIFT_Foundry_Non_Gating_MEBES_Recieved_Initial',nameValue,'N',null);
         } 
         
  }
  
  
    static{
        
        orgWideAddr = [SELECT Id,DisplayName,Address FROM OrgWideEmailAddress WHERE DisplayName = 'GLOBALFOUNDRIES' LIMIT 1];
        groupIduserIdMap = new Map<Id,Set<Id>>();
        lstgroupMap = new Map<Id,Group>([SELECT Id,DeveloperName,Name FROM Group WHERE DeveloperName in ('Swift_Tapeout_Centre','Swift_MDP','SWIFT_Admin','Swift_Tapeout_Application','Swift_TDTI_MPW','Swift_GlobalShuttle')]);

        List<GroupMember> lstgroupMember;
        if(lstgroupMap  != null)
        {
            lstgroupMember = [Select Id,GroupId,UserOrGroupId FROM GroupMember WHERE GroupId IN:lstgroupMap.keySet()];
        }

        if(lstgroupMember  !=null)
        {
            for(GroupMember groupMemberObj : lstgroupMember )
            {
                if(groupIduserIdMap.containsKey(groupMemberObj.UserOrGroupId)){
                   groupIduserIdMap.get(groupMemberObj.UserOrGroupId).add(groupMemberObj.GroupId);
                }else{
                    Set<Id> groupSt = new Set<Id>();
                    groupSt.add(groupMemberObj.GroupId);
                    groupIduserIdMap.put(groupMemberObj.UserOrGroupId,groupSt);
                }
            }
        }

        
        if(groupIduserIdMap != null && groupIduserIdMap.size()>0)
        {
            userlist= [Select Email,Name,Portal_Email__c From User Where Id IN :groupIduserIdMap.keySet() AND IsActive =true];
        }
    }
}