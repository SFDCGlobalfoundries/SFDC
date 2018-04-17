/*
 * @ Author :- Anil Kumar Reddy L
 * @ Description :- contains the logic for rendering of devices of Fab 9/10.
 * @ Date :- 24/11/2016
 * @ Change History :-  
        Date            Name    Reason
        ----            ----    ------
        05/19/2017      ARoy    Modified the code to use StandardSetController to fix view state issue.
        06/28/2017      RRai    Modified the code to remove hardcoding.  
        7/12/2017       ARoy    Modified for Design Partner addition. (Issue 485)
		 1-FEB-2018         Devendra -Tapeout process changes
**/
public with sharing class FMSFAB_9_10_Devices_Cont {
    
    public String sortCol {
        get;
        set;
    }
    public String sortType {
        get;
        set;
    }
    
    public ApexPages.StandardSetController setCon {
        get;
        set;
    }

    public Id formID {get;set;}
    public Integer size{get;set;} 
    public Integer noOfPages{get; set;}
    public final String FMS_IMC_FORM = EnvironmentVariable.get('FMS_IMC_FORM'); 
    public final String FMS_DDR_FORM = EnvironmentVariable.get('FMS_DDR_FORM'); 
    public final String FMS_MAIN_FORM = EnvironmentVariable.get('FMS_MAIN_FORM'); 
    public final String FMS_RIT_FORM = EnvironmentVariable.get('FMS_RIT_FORM'); 
    public final String FMS_SP_FORM = EnvironmentVariable.get('FMS_SP_FORM');
    public string TapeoutProcess{get;set;}
    
    public FMSFAB_9_10_Devices_Cont() {
        size=50;
        TapeoutProcess='FMS 2.0';
        sort();
        
    }   
    
   /*  public CtrlEditAllBudget(ApexPages.StandardSetController stdSetController)
    {
       // Set Page Size
       stdSetController.setPageSize(50);
       this.stdSetController = stdSetController;
       system.debug('stdSetController=>'+stdSetController.getRecords());
       List<Budget__c> budidlist = (List<Budget__c>)stdSetController.getRecords();

       for(Budget__c budinstance:budidlist)
       {
         system.debug('budget id = >'+budinstance.Id);
       }
    }
    */
    
    
    public List<DeviceListWrapper> getDevicesList(){
        List<DeviceListWrapper> devListWrapper = new List<DeviceListWrapper>();
       
         List<Device__c> budidlist = (List<Device__c>)setCon.getRecords();
        

       for(Device__c c:budidlist)
       {
         system.debug('c id = >'+c.Name);
       }
        
        for(SObject d : setCon.getRecords()){
            devListWrapper.add(new DeviceListWrapper((Device__c)d));
            System.debug('Device====>' +d);
        }
        
        
        return devListWrapper;
    }

    public void sort(){
        String sortColTemp='';
        if (sortCol == 'mpw') {
            sortColTemp = 'mpw_train_number__r.name';
        }else{
            sortColTemp = sortCol;
        }
        string wherecondition='';
        if(TapeoutProcess=='FMS 2.0')wherecondition='Tapeout_Process__c=:TapeoutProcess';
        else wherecondition='((fab__c=\'Fab 9\' or fab__c=\'Fab 10\' or fab__c=\'ALTIS\') and Tapeout_Process__c=:TapeoutProcess)'; 
        //Made changes for Design Partner addition by Anirban on 7/12/2017
        String soql = 'select Id, Name, Project_Name__c, Customer_Tapeout_Date__c, Geometry__c,crmdid__c,Reticle_Type__c,Current_Forecast_Tapeout_Date__c,'+
                    'ip_declaration_status__c, Tapeout_Process__c,Process_Family__c, Status__c, Stage__c, Fab__c,'+
                    'Pre_PTRF_Validation_Status__c, Actual_Tapeout_Date_GMT__c, Device_Mask_Set_Title__c,'+
                    'CreatedDate, MPW_Train_Number__r.Name, BX041_Status__c, Opportunity2__c, Opportunity_Program__c,'+
                    'Opportunity2__r.name, Opportunity_Program__r.name,Tapeout_Type__c,Account__c,Account__r.name,Design_Partner__r.Name,'+
                    '(select id, Status__c, name from IP_Declaration_Form__r limit 1),'+
                    '(select Export_Control_Form__c , Export_Control_Form__r.name, Export_Control_Form__r.Status__c from device_export_control_junctions__r limit 1),'+
                    '(select id, Name, Form_Name__c from Form_Management_Systems__r limit 1) '+
                    'from Device__c where '+wherecondition+' and Account__r.Fab_9_10__c = \'Yes\' and Status__c=\'Active\'';
        if(sortCol!=null && sortType!=null) {
            soql += ' order by ' + sortColTemp + ' ' + sortType +' limit 10000';                        
        }else{
            soql += ' order by CreatedDate desc limit 10000';
        }
        system.debug(Database.query(soql));
        setCon = new ApexPages.StandardSetController(Database.getQueryLocator(soql));
        setCon.setPageSize(size); 
        noOfPages = (setCon.getResultSize()>0)?((Integer)Math.ceil(setCon.getResultSize()/setCon.getPageSize())):0;
    }
                    
    public class DeviceListWrapper {
        public Device__c deviceInfo {
            get;
            set;
        }
        public String IpDecId {
            get;
            set;
        }
        public String ExptCntrlId {
            get;
            set;
        }
        public String deviceID {
            get;
            set;
        }
        public String custTapeoutDate {
            get;
            set;
        }
        public String geometry {
            get;
            set;
        }
        public String processFamily {
            get;
            set;
        }
        public String status {
            get;
            set;
        }
        public String stage {
            get;
            set;
        }
        public String fab {
            get;
            set;
        }
        public String tapeoutprocess {
            get;
            set;
        }
        public String MPW {
            get;
            set;
        }
        public String tapeoutReadiness {
            get;
            set;
        }
        public String actualTapeoutDate {
            get;
            set;
        }
        public String maskSetTitle {
            get;
            set;
        }
        public String createdDate {
            get;
            set;
        }
        public String IPDecStatus {
            get;
            set;
        }
        public String bx041ID {
            get;
            set;
        }
        public String cdrsStatus {
            get;
            set;
        } 
        public String configID {
            get;
            set;
        } 
        public String ConfigurationName {
            get;
            set;
        } 
        public String tapeOutType {
            get;
            set;
        }
        public String opportunity {
            get;
            set;
        }
        public String opportunityProgram {
            get;
            set;
        }

        public String opportunityName {
            get;
            set;
        }
        public String opportunityProgramName {
            get;
            set;
        }
         public String ipDeclarationForm {
            get;
            set;
        }
         public String ipDeclarationStatus {
            get;
            set;
        }
         public String exportControllForm {
            get;
            set;
        }
         public String accountName {
            get;
            set;
        }
        public String fmsFormName {
            get;
            set;
        }
         public ID fmsFormID {
            get;
            set;
        }
        
        public String crmdID {get;set;}
        public String designPartner {get;set;} //Made changes for Design Partner addition by Anirban on 7/12/2017
        public String ecStatus{get;set;}
        public String retType{get;set;}
        public Date currTapDate{get;set;}

        public DeviceListWrapper(Device__c deviceInfo) {
            this.deviceInfo = deviceInfo;

            this.crmdID = deviceInfo.CRMDID__c;
            this.retType= deviceInfo.Reticle_Type__c; 
                this.currTapDate = deviceInfo.Current_Forecast_Tapeout_Date__c;
           
            for (Device_Export_Control_Junction__c d: this.deviceInfo.device_export_control_junctions__r) {
                this.ExptCntrlId = d.Export_Control_Form__c;
                this.exportControllForm = d.Export_Control_Form__r.name;
                 this.ecStatus=d.Export_Control_Form__r.Status__c; 
            }

            if (this.deviceInfo.IP_Declaration_Form__r != null) {
                for (IP_Declaration_Form__c objID: this.deviceInfo.IP_Declaration_Form__r) {
                    this.IpDecId = objID.Id;
                    this.ipDeclarationForm = objID.name;
                    this.ipDeclarationStatus = objID.Status__c;  
                }
            }

            this.deviceID = deviceInfo.name;
            this.custTapeoutDate = deviceInfo.customer_tapeout_date__c <> null ?
                deviceInfo.customer_tapeout_date__c.format() :
                null;
            this.geometry = deviceInfo.geometry__c;
            this.processFamily = deviceInfo.process_family__c;
            this.status = deviceInfo.status__c;
            this.stage = deviceInfo.stage__c;
            this.fab = deviceInfo.fab__c;
            this.MPW = deviceInfo.MPW_Train_Number__r.name;
            this.tapeoutReadiness = deviceInfo.pre_PTRF_validation_status__c;
            this.actualTapeoutDate = deviceInfo.actual_tapeout_date_GMT__c <> null ?
                deviceInfo.actual_tapeout_date_GMT__c.format() :
                '';
            this.maskSetTitle = deviceInfo.device_mask_set_title__c;
            this.createdDate = deviceInfo.createdDate.format();
            this.IPDecStatus = deviceInfo.ip_declaration_status__c;
            this.cdrsStatus = deviceInfo.BX041_Status__c;
            this.tapeOutType = deviceInfo.Tapeout_Type__c;
            this.opportunity = deviceInfo.Opportunity2__c;
            this.opportunityProgram = deviceInfo.Opportunity_Program__c;
            this.opportunityName = deviceInfo.Opportunity2__r.Name;
            this.tapeoutprocess=deviceInfo.Tapeout_Process__c;
            this.opportunityProgramName = deviceInfo.Opportunity_Program__r.Name;
            this.accountName = deviceInfo.Account__r.name;
            this.designPartner = deviceInfo.Design_Partner__r.Name; //Made changes for Design Partner addition by Anirban on 7/12/2017
            if (this.deviceInfo.Form_Management_Systems__r != null) {
                for (Form_Management_System__c fms: this.deviceInfo.Form_Management_Systems__r) {
                    this.fmsFormName = fms.Form_Name__c;
                    this.fmsFormID = fms.id;
                }
            }
            
        }  
    }
            
        public PageReference navigateFMSForm(){
            PageReference Pg;
            Form_Management_System__c fmsRT = [SELECT ID,RECORDTYPEID,RECORDTYPE.name FROM Form_Management_System__c WHERE ID = :formID];
            String rtName = fmsRT.RECORDTYPE.name;
            if(rtName == FMS_DDR_FORM ) {
                pg = new PageReference('/apex/FMSDDRFormViewPage?id='+formID); 
            } else if(rtName == FMS_RIT_FORM ) {
                pg = new PageReference('/apex/FMSRITFormViewPage?id='+formID);
            } else if(rtName == FMS_IMC_FORM ) {
                pg = new PageReference('/apex/FMSIMCFormViewPage?id='+formID);
            } else if(rtName == FMS_MAIN_FORM ) {
                pg = new PageReference('/apex/FMSmainFormViewPage?id='+formID);
            } else if(rtName == FMS_SP_FORM ) {
                 pg = new PageReference('/apex/FMSSPFormViewExtension?id='+formID);
            }
            
            return pg;
        }  
}