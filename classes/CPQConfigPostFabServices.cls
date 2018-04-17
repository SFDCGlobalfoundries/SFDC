public class CPQConfigPostFabServices {
    
    public Decimal wl { get; set; }
    Public List<String> quarters {get;set;} 
    
    Set<Integer> Q1 = new Set<Integer>{1,2,3};
    Set<Integer> Q2 = new Set<Integer>{4,5,6};
    Set<Integer> Q3 = new Set<Integer>{7,8,9};
    Set<Integer> Q4 = new Set<Integer>{10,11,12};
    public Integer cMonth{get;set;}
    public Integer cYear = System.today().Year();
    public List<SelectOption> lstPackTechGF {get;set;}
    public List<SelectOption> lstPackTechCustom {get;set;}
    public list<PFile_Yield__c> pfyields {get;set;}  
    public List<integer> qtrCount {get;set;}
    public List<String> rowname {get;set;}   
    public String pfdesc { get; set; }
    public decimal  pfrevision { get; set; }
    public String PFStat { get; set; }
    public Decimal pfnumber { get; set; } 
    public String modifiedModBuildVal {get; set;}  
    public String modifiedBondingVal {get; set;}    
    //public String countries { get; set; }
    public List<volumeslist> volumes{get;set;}
    public List<volumeslist> volumesBI{get;set;}
    public List<wrapperlist> listwrapper{get;set;}
    public List<wrapperlist> listwrapperModule{get;set;}
    public List<wrapperlist> listwrapperBurnIn{get;set;}
    public List<wrapperlist> listwrapperSCCost{get;set;}
    public List<wrapperlist> listwrapperBurnInUser{get;set;}
    public List<wrapperlist> listwrapperMCMUser{get;set;}
    public List<wrapperlist> listwrapperModuleBuild{get;set;}
    public List<wrapperlist> listwrapperModuleBuild2{get;set;}
    public List<wrapperlist> listwrapperModuleBuild3{get;set;}
    
    public class volumeslist{
        public string volume {get;set;}
    }
    
    public class wrapperlist{
        public Decimal volume {get;set;}
        public string qrt {get;set;}
        
    }
    public class fieldslist{
        public string fieldname{get;set;}
    }
    public String fileData { get; set; }
    public Boolean isWTTDisplay{get;set;}
    public Boolean ispfdetails{get;set;}
    public Boolean isWTTDetails{get;set;}
    public Boolean isModuleDetails{get;set;}
    public Boolean isUserDetails{get;set;}
    public Boolean isUMDDetails{get;set;}
    public Boolean isUTDDetails{get;set;}
    public Boolean isBIBCDetails{get;set;}
    public Boolean isBYMDetails{get;set;}
    public Boolean customDisplay{get;set;}
    public Opportunity op {get;set;}
    public String items { get; set; }
    public ID vid { get; set; }
    public integer cnt=0;
    public id configReqId,cid ;
    public List<PCM_Yield__c> PCMYieldObj;
    public List<PCM_Yield__c> PCMYieldObj1;
    public Config_Post_Fab_Services__c  ConfigPSTFabServ {get;set;}
    public PFile_Data__c PFileData{get;set;}
    public Config_Post_Fab_Service_Detail__c ConfigPostFabServiceDetail {get;set;}
    public list<Config_Post_Fab_Service_Detail__c> listConfigPostFabServiceDetails {get;set;}
    public static Decimal  kerfxval;
    public static Decimal  kerfyval;
    public List<PFile_Data__c> pflist {get;set;}
    public Set<Decimal> pfnumbers{get;set;}
    public Set<String> pfstats{get;set;}
    public List<Config_Quarterly_Volume__c> Quart {get;set;}
    public List<fieldslist> objfields {get;set;}
    public List<string> burninfields{get;set;}
    public List<string> customfields{get;set;}
    public List<Apttus_Proposal__Proposal__c>  proposalobj {get;set;}
    
    public Config_Post_Fab_Services__c  ConfigPSTFabServupdate;        
    
    public CPQConfigPostFabServices ()
    {      
      cMonth = System.today().month();
        list<String> lstPackTechGFVal = new list<String>{'FCPBGA','BCC++','EPBGA','TEPBGA','FBGA','HPBGA','HQFP','LQFP','PBGA','PLCC','PQFP','QFN','QFN DR','STFBGA','TQFP','TAPP'};
            list<String> lstPackTechCustomVal = new list<String>{'FBGA','PBGA','PLCC','SLGA','PQ4','QFN','SOP','TSSOPep','TSOP','HQFP','LGA HPGC','SC70','SBGA','TSSOP','QFN DR','PQFP','HLQFP','CLGA','CCGA','CBGA-SAC','CBGA','CuCGA','EPBGA','FCPBGA','FCPBGAHP','TAPP','BCC','BCC++','STFBGA','PLGA','TEPBGA','MSOPep','HPBGA','MSOP','Other','LQFPep','TFBGA','TQFP','LQFP'};   
                lstPackTechGF = new list<SelectOption>();
        lstPackTechCustom = new list<SelectOption>();
        for(String str : lstPackTechGFVal) {
            lstPackTechGF.add(new SelectOption(str,str));
        }
        
        for(String str : lstPackTechCustomVal) {
            lstPackTechCustom.add(new SelectOption(str,str));
}
              
        
        listwrapper = new List<wrapperlist>();
        listwrapperModule= new List<wrapperlist>();
      listwrapperBurnIn= new List<wrapperlist>();
      listwrapperSCCost= new List<wrapperlist>();
      listwrapperBurnInUser= new List<wrapperlist>();
      listwrapperMCMUser= new List<wrapperlist>();
      listwrapperModuleBuild= new List<wrapperlist>();
      listwrapperModuleBuild2= new List<wrapperlist>();  
      listwrapperModuleBuild3= new List<wrapperlist>();    
         
        quarters = new List<String>();
        pflist  = new List<PFile_Data__c>();
        pfnumbers = new set<Decimal>();
        pfstats = new Set<String>();
        rowname = new List<string>();
        rowname.add('UserDefinedYield');
        objfields = new List<fieldslist>();
        fieldslist f = new fieldslist();
        for(string s:rowname ){
            
            f.fieldname = s;
            objfields.add(f);
            
        }
        burninfields = new List<string>{'Burn In Duration','Burn in Board Cost'}; 
            for( PFile_Data__c pf : [select PF_Stat__c,PF_Desc__c,Revision__c, PF_Number__c from PFile_Data__c]){
                pfnumbers.add(pf.PF_Number__c);
            }
        
        customfields = new List<string>{'Subst Cost by Time Period','Bond & Assembly Cost by Time Period','Package Option Cost by Time Period','Bond & Assembly Yield by Time Period'}; 
            for( PFile_Data__c pf : [select PF_Stat__c,PF_Desc__c,Revision__c, PF_Number__c from PFile_Data__c]){
                pfnumbers.add(pf.PF_Number__c);
            }
        
        volumes = new List<volumeslist>();
        volumesBI = new List<volumeslist>();
        proposalobj  = new List<Apttus_Proposal__Proposal__c>();
        ConfigPostFabServiceDetail= new Config_Post_Fab_Service_Detail__c();
        cid = ApexPages.currentPage().getParameters().get('retId');
        
        createQuarterlyVolumeList();
        Config_Post_Fab_Services__c[] cpfs = [SELECT Id,Kerf_X__c,Kerf_Y__c,Bonding__c,BLM_Size_Type__c,Solder_Type__c,Minimum_C4_Pitch__c,Solder__c,Configuration__c,Fab__c,Minimum_Kerf__c,Test_Location__c,Test_Platform__c,
                                              Test_Time_Method__c,User_Defined_Time__c,Number_of_DUTS__c,Customer_Test_Program__c,Package_Tech_Method__c,Package_Technology__c,Package_IO__c,Body_Length__c,
                                              Body_Width__c,Subst_Layer__c,Subst_IO_Pitch__c,Subst_Material__c,Wire_Material_for_WB__c,Capacitor_Type__c,Capacitor_Qty__c,Package_IO_Pitch__c,Encapsulation__c,
                                              Line_Width__c,Reliability_Location__c,Reliability_Platform__c,Number_of_Boards_Per_Platform__c,Number_of_Socket_Per_Boards__c,Burn_in_Stress_Yield_Method__c,
                                              MCM_Reliability_Platform__c,MCM_Number_of_DUTS__c,MCM_Test_Time_Method__c,Module_Test_Location__c,Module_Test_Platform__c,Module_Test_Time_Method__c,
                                              Module_User_Defined_Time__c,MCM_User_Defined_Time__c,Module_Customer_Test_Program__c,Module_Test_Yield_Method__c,Method__c,Module_Number_of_DUTS__c,PF_Number__c,PF_Desc__c,PF_Stat__c,Revision__c 
                                              FROM Config_Post_Fab_Services__c
                                              WHERE Configuration__c  = :cid limit 1];
        Quart  = [select  Q1_Volume__c,Q2_Volume__c,Q3_Volume__c,Q4_Volume__c, Quote_Proposal__c from  Config_Quarterly_Volume__c where Quote_Proposal__c =: cid];
        
        pflist   = [select PF_Stat__c,PF_Desc__c,Revision__c, PF_Number__c from PFile_Data__c where Configuration__c=: cid];

        List<Apttus_Config2__ProductConfiguration__c>  listconfig= [select id,name, Apttus_QPConfig__Proposald__c,Apttus_Config2__Status__c  from Apttus_Config2__ProductConfiguration__c where Apttus_QPConfig__Proposald__c =:CId order by createddate desc];
        
          proposalobj = [Select id, Deliverable_Part_Type__c, Actual_Tapeout_Date_FAB_9_and_FAB_10__c,Relgrade__c, Apttus_Proposal__Opportunity__c,Wafer_Size__c from Apttus_Proposal__Proposal__c where id = :cid limit 1];                                   
          if(proposalobj.size()>0){
        op = [Select id from Opportunity  where id = :proposalobj[0].Apttus_Proposal__Opportunity__c limit 1]; 
        wl = proposalobj[0].Relgrade__c != NULL ? Decimal.valueOf(proposalobj[0].Relgrade__c) : 0;

           cmonth = system.today().month();
              cyear = system.today().year();

        }
              
        
        List<Apttus_Config2__LineItem__c> PropolsaLineItemObj = new List<Apttus_Config2__LineItem__c>();        
        Id id1 = ApexPages.currentPage().getParameters().get('id');//lineitemid
        Id devRecordTypeId = Schema.SObjectType.PCM_Yield__c.getRecordTypeInfosByName().get('KERF X').getRecordTypeId();
        Id devRecordTypeId1 = Schema.SObjectType.PCM_Yield__c.getRecordTypeInfosByName().get('KERF Y').getRecordTypeId();
        
        PropolsaLineItemObj = [select Apttus_Config2__AttributeValueId__r.Die_Size_X_mm__c ,Apttus_Config2__AttributeValueId__r.Die_Size_Y_mm__c,Apttus_Config2__AttributeValueId__r.APTPS_ProcessTechnology__c,Apttus_Config2__ClassificationHierarchy__c from Apttus_Config2__LineItem__c where Apttus_Config2__ConfigurationId__c =:id1 AND  Apttus_Config2__LineType__c ='Product/Service'];        
        
        PCMYieldObj =  new  List<PCM_Yield__c>();
        PCMYieldObj1 =  new  List<PCM_Yield__c>();
        if(PropolsaLineItemObj.size()>0){
            Decimal dx= PropolsaLineItemObj[0].Apttus_Config2__AttributeValueId__r.Die_Size_X_mm__c;
            Decimal dy= PropolsaLineItemObj[0].Apttus_Config2__AttributeValueId__r.Die_Size_Y_mm__c;
            string PTNumber = PropolsaLineItemObj[0].Apttus_Config2__AttributeValueId__r.APTPS_ProcessTechnology__c;            
            
            PCMYieldObj = [SELECT Id, PROD_INT__c, Prod_Kerf__c FROM PCM_Yield__c where RecordTypeID=:devRecordTypeId AND  PT_Number__c=:PTNumber AND  Chip_Lo__c <=:dx and Chip_Hi__c >=: dx limit 1];
            PCMYieldObj1 = [SELECT Id, PROD_INT__c, Prod_Kerf__c FROM PCM_Yield__c where RecordTypeID =:devRecordTypeId1 AND  PT_Number__c=:PTNumber AND Chip_Lo__c <=:dx and Chip_Hi__c >=: dx limit 1];
        }
        
        
        if(cpfs.size()>0){                                      
            cnt = 1;
            
            Config_Post_Fab_Services__c  cf = new Config_Post_Fab_Services__c();                          
            
            cf.id = cpfs[0].id;
            cf.Bonding__c = cpfs[0].Bonding__c;

            cf.BLM_Size_Type__c= cpfs[0].BLM_Size_Type__c;
            cf.Solder_Type__c= cpfs[0].Solder_Type__c;
            cf.Minimum_C4_Pitch__c= cpfs[0].Minimum_C4_Pitch__c;       
            cf.Solder__c= cpfs[0].Solder__c; 
            cf.Fab__c = cpfs[0].Fab__c; 
            cf.Minimum_Kerf__c =  cpfs[0].Minimum_Kerf__c;
            cf.Test_Location__c = cpfs[0].Test_Location__c;
            cf.Test_Platform__c = cpfs[0].Test_Platform__c;
            cf.Test_Time_Method__c = cpfs[0].Test_Time_Method__c;
            cf.User_Defined_Time__c = cpfs[0].User_Defined_Time__c;
            cf.Number_of_DUTS__c= cpfs[0].Number_of_DUTS__c;
            cf.Module_Number_of_DUTS__c = cpfs[0].Module_Number_of_DUTS__c;
            cf.Package_IO__c = cpfs[0].Package_IO__c;
            cf.Customer_Test_Program__c = cpfs[0].Customer_Test_Program__c;
            cf.Package_Tech_Method__c = cpfs[0].Package_Tech_Method__c;
            cf.Package_Technology__c = cpfs[0].Package_Technology__c;
            cf.Body_Length__c= cpfs[0].Body_Length__c;
            cf.Body_Width__c= cpfs[0].Body_Width__c;
            cf.Subst_Layer__c= cpfs[0].Subst_Layer__c;
            cf.Subst_IO_Pitch__c= cpfs[0].Subst_IO_Pitch__c;
            cf.Subst_Material__c= cpfs[0].Subst_Material__c;
            cf.Wire_Material_for_WB__c= cpfs[0].Wire_Material_for_WB__c;
            cf.Capacitor_Type__c= cpfs[0].Capacitor_Type__c;
            cf.Capacitor_Qty__c= cpfs[0].Capacitor_Qty__c;
            cf.Package_IO_Pitch__c= cpfs[0].Package_IO_Pitch__c;
            cf.Encapsulation__c= cpfs[0].Encapsulation__c;
            cf.Line_Width__c= cpfs[0].Line_Width__c; 
            cf.Reliability_Location__c= cpfs[0].Reliability_Location__c;
            cf.Reliability_Platform__c= cpfs[0].Reliability_Platform__c;
            cf.Number_of_Boards_Per_Platform__c= cpfs[0].Number_of_Boards_Per_Platform__c;
            cf.Number_of_Socket_Per_Boards__c= cpfs[0].Number_of_Socket_Per_Boards__c;
            cf.Burn_in_Stress_Yield_Method__c= cpfs[0].Burn_in_Stress_Yield_Method__c;  
            cf.MCM_Reliability_Platform__c= cpfs[0].MCM_Reliability_Platform__c;
            cf.MCM_Number_of_DUTS__c= cpfs[0].MCM_Number_of_DUTS__c;
            cf.MCM_Test_Time_Method__c= cpfs[0].MCM_Test_Time_Method__c;  
            cf.Module_Test_Location__c= cpfs[0].Module_Test_Location__c;
            cf.Module_Test_Platform__c= cpfs[0].Module_Test_Platform__c;
            cf.Module_Test_Time_Method__c= cpfs[0].Module_Test_Time_Method__c;  
            cf.Module_User_Defined_Time__c= cpfs[0].Module_User_Defined_Time__c;
            cf.MCM_User_Defined_Time__c = cpfs[0].MCM_User_Defined_Time__c;
            cf.Module_Customer_Test_Program__c= cpfs[0].Module_Customer_Test_Program__c;
            cf.Module_Test_Yield_Method__c= cpfs[0].Module_Test_Yield_Method__c;  
            cf.Method__c= cpfs[0].Method__c;
            kerfxval= cpfs[0].kerf_X__c;
            kerfyval= cpfs[0].kerf_X__c;

            
            cf.kerf_X__c= cpfs[0].kerf_X__c;
            cf.kerf_y__c= cpfs[0].kerf_y__c;
            
            if(cpfs[0].Capacitor_Qty__c!=null){
            cf.Capacitor_Qty__c= cpfs[0].Capacitor_Qty__c;
            }else{
            cf.Capacitor_Qty__c=0;
            }
            
            if(cpfs[0].Number_of_Socket_Per_Boards__c!=null){
             cf.Number_of_Socket_Per_Boards__c= cpfs[0].Number_of_Socket_Per_Boards__c;
            }else{
            cf.Number_of_Socket_Per_Boards__c=1;
            }
            
            if(cpfs[0].Test_Time_Method__c!=null){
             cf.Test_Time_Method__c= cpfs[0].Test_Time_Method__c;
             
            }else{

            }
 
              if(cpfs[0].Module_User_Defined_Time__c!=null){
             cf.Module_User_Defined_Time__c= cpfs[0].Module_User_Defined_Time__c;
            }else{
            cf.Module_User_Defined_Time__c=1;
            }
            
            if(cpfs[0].MCM_User_Defined_Time__c!=null){
             cf.MCM_User_Defined_Time__c= cpfs[0].MCM_User_Defined_Time__c;
            }else{
            cf.MCM_User_Defined_Time__c=1;
            }
 
            
            cf.Circuit_Limited_Yield_CLY__c = 1;
            cf.Design_for_Profit_DFP__c= 1; 

            pfdesc = cpfs[0].PF_Desc__c ;
            if(cpfs[0].PF_Number__c !=null) pfnumber = Decimal.valueOf(cpfs[0].PF_Number__c);
            PFStat = cpfs[0].PF_Stat__c ;
            if(cpfs[0].Revision__c!=null) pfrevision  = Decimal.valueOf(cpfs[0].Revision__c) ;
            getpfchilds();
            ConfigPSTFabServupdate = cf;
            ConfigPSTFabServ = cf;
            if(cpfs[0].Method__c != '')
            {
                cf.Method__c = cpfs[0].Method__c;
                WTTDisplay();
            }
            UserModuleDisplay();
            UserModuleTimeDisplay();
            UserDefinedYieldDisplay(); 
            WTTDisplay();
            UserWaferDisplay();
            populatekerf();

            UserDefinedDisplay();wrapperlist newwrapper ;
               Id devRecordTypeId3 = Schema.SObjectType.Config_Post_Fab_Service_Detail__c.getRecordTypeInfosByName().get('MCM user defined yield').getRecordTypeId();
            listConfigPostFabServiceDetails = [Select Method__c,Quarter__c,Year__c,Circuit_Group__c,Count__c,CKT_Unit__c,Circuit_Type__c,Available_Redundancy__c from Config_Post_Fab_Service_Detail__c  where Config_Post_Fab_Service__c =: cf.id and RecordType.name = 'Wafer Test Pass' ];        
                       
            if(listConfigPostFabServiceDetails != null){
                
                for(Config_Post_Fab_Service_Detail__c  r:listConfigPostFabServiceDetails ){
                    if(ConfigPostFabServiceDetail.Method__c != '')
                    {
                        
                        ConfigPostFabServiceDetail.Method__c = r.Method__c;
                        WTTDisplay();
                    }
                }
            }
        }
        else{
            ConfigPSTFabServ = new Config_Post_Fab_Services__c(); 
            ConfigPSTFabServ.Circuit_Limited_Yield_CLY__c = 1;
            ConfigPSTFabServ.Design_for_Profit_DFP__c= 1; 
            ConfigPSTFabServ.Capacitor_Qty__c= 0;
            ConfigPSTFabServ.Number_of_Socket_Per_Boards__c=1;
            ConfigPSTFabServ.User_Defined_Time__c=1;
            ConfigPSTFabServ.Module_User_Defined_Time__c=1;
            ConfigPSTFabServ.MCM_User_Defined_Time__c=1;
            
            ConfigPSTFabServ.Bonding__c = 'C4';
            ConfigPSTFabServ.Solder_Type__c= 'PB Free';
            ConfigPSTFabServ.Solder__c= 'PB Free';
            ConfigPSTFabServ.BLM_Size_Type__c= '90um/TiW/Cu/Ni';
            ConfigPSTFabServ.Minimum_C4_Pitch__c= '148um';      
            
            if(PCMYieldObj.size()>0){
                ConfigPSTFabServ.Minimum_Kerf__c = 'Yes';
                
                ConfigPSTFabServ.Kerf_X__c =  PCMYieldObj[0].PROD_INT__c;
                
            }
            if(PCMYieldObj1.size()>0){
                ConfigPSTFabServ.Kerf_Y__c =  PCMYieldObj1[0].PROD_INT__c;  
            }
        }
        
        
        qtrCount =  new List<integer>();
        if(Quart.size()>0){
            
            for(Config_Quarterly_Volume__c q: Quart){
                
                volumeslist x = new volumeslist();
                if(q.Q1_Volume__c!= null) {
                    x.volume = null;
                    volumesBI.add(x);
                    volumes.add(x);
                }
                if(q.Q2_Volume__c!=null) {
                    x.volume = null;
                    volumes.add(x);
                    volumesBI.add(x);
                }
                
                if(q.Q3_Volume__c!=null) {
                    x.volume = null;
                    volumes.add(x);
                    volumesBI.add(x);
                }
                
                if(q.Q4_Volume__c!=null) {
                    x.volume = null;
                    volumes.add(x);
                    volumesBI.add(x);
                }
                
            }
        }        
        
        integer j=1;
        if(Q1.contains(cMonth)){
            j=1;}
        if(Q2.contains(cMonth)){
            j=2;}
        if(Q3.contains(cMonth)){
            j=3;}
        if(Q4.contains(cMonth)){
            j=4;}
                     
       UserModuleDefinedDisplay();WTTDisplay();
    }
    
    Decimal kerfX;
    Decimal kerfY;
    
    public pagereference pageActionInitialization() {
            
        if(ConfigPSTFabServ.Configuration__c ==null){
            ConfigPSTFabServ.Configuration__c = cid;
        }
        try{
        if(ConfigPSTFabServ.Id == NULL)upsert ConfigPSTFabServ;
        }catch(exception e){

        }
        
            listwrapperSCCost = fetchDetailData('Module Build','Subst_Cost_by_Time_Period__c');
            listwrapperModuleBuild = fetchDetailData('Module Build','Bond_Assembly_Cost_by_Time_Period__c');
            listwrapperModuleBuild2 = fetchDetailData('Module Build','Package_Option_Cost_by_Time_Period__c');
            listwrapperModuleBuild3 = fetchDetailData('Module Build','Bond_Assembly_Yield_by_Time_Period__c');
            listwrapperModule = fetchDetailData('Module user defined yield','User_Defined_Yield_Module__c');
            listwrapperBurnInUser = fetchDetailData('Burn-in','Burn_in_duration__c');
            listwrapperMCMUser = fetchDetailData('SC Burn in board cost','Burn_in_Board_Cost__c');
            listwrapperBurnIn = fetchDetailData('Burn-in user defined yield','User_Defined_Yield_BI__c');
        return null;    
    }
    
    
    public PageReference CreateWTY() {
        if(ConfigPSTFabServ.Circuit_Limited_Yield_CLY__c == NULL || ConfigPSTFabServ.Design_for_Profit_DFP__c == NULL || (ConfigPostFabServiceDetail.Count__c == null) || (ConfigPostFabServiceDetail.Circuit_Type__c == null) || (ConfigPostFabServiceDetail.Circuit_Group__c == null)){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please select and enter data for all required fields'));
            
        }else{
            try{
                ConfigPSTFabServ.Configuration__c =cid ;
                upsert ConfigPSTFabServ;                
                
                ConfigPostFabServiceDetail.Config_Post_Fab_Service__c = ConfigPSTFabServ.id;
                if(ConfigPostFabServiceDetail.Circuit_Group__c =='CORES' || ConfigPostFabServiceDetail.Circuit_Group__c =='DAC' || ConfigPostFabServiceDetail.Circuit_Group__c =='PLL'){ ConfigPostFabServiceDetail.CKT_Unit__c = 'Count'; }else
                    if(ConfigPostFabServiceDetail.Circuit_Group__c =='IO'){ ConfigPostFabServiceDetail.CKT_Unit__c = 'Kcount'; }else
                        if(ConfigPostFabServiceDetail.Circuit_Group__c =='MIXED'){ ConfigPostFabServiceDetail.CKT_Unit__c = 'Instance'; }else
                        {
                            ConfigPostFabServiceDetail.CKT_Unit__c = 'Kckts';
                        } 
                Id devRecordTypeId = Schema.SObjectType.Config_Post_Fab_Service_Detail__c.getRecordTypeInfosByName().get('Wafer Test Pass').getRecordTypeId();
                ConfigPostFabServiceDetail.RecordTypeID = devRecordTypeId;
                List<Config_Post_Fab_Service_Detail__c> duplicateList = new List<Config_Post_Fab_Service_Detail__c>([Select Circuit_Group__c,Count__c,CKT_Unit__c,Circuit_Type__c,Available_Redundancy__c from Config_Post_Fab_Service_Detail__c
                                                                                                                     where Config_Post_Fab_Service__c =: ConfigPSTFabServ.id and Circuit_Group__c =: ConfigPostFabServiceDetail.Circuit_Group__c AND
                                                                                                                     Circuit_Type__c =: ConfigPostFabServiceDetail.Circuit_Type__c AND Available_Redundancy__c =:ConfigPostFabServiceDetail.Available_Redundancy__c ]);
                
                if(duplicateList.size() == 0){
                    insert ConfigPostFabServiceDetail;
                    ConfigPostFabServiceDetail = new Config_Post_Fab_Service_Detail__c();
                }else{
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please select unique values for Circuit Group, Circuit Type and Available Redundancy'));
                }

            }catch(exception e){
                
            }

            listConfigPostFabServiceDetails = [Select Circuit_Group__c,Count__c,CKT_Unit__c,Circuit_Type__c,Available_Redundancy__c from Config_Post_Fab_Service_Detail__c where Config_Post_Fab_Service__c =: ConfigPSTFabServ.id and RecordType.Name = 'Wafer Test Pass' ]; 
            ConfigPostFabServiceDetail= new Config_Post_Fab_Service_Detail__c();
        }
        return null;
    }
    
    
    public PageReference reviewSelection(){
    
        /*if(op.Deliverable_Part_Type__c == 'Finished Wafer' || op.Deliverable_Part_Type__c == 'Tested Wafer' || op.Deliverable_Part_Type__c == 'Chip' || 
           op.Deliverable_Part_Type__c == 'MCM' || op.Deliverable_Part_Type__c == 'Module') {      
           
           List<PCM_Cost__c> cc = [SELECT id,wafer_size__c 
                                     FROM PCM_Cost__c
                                     WHERE bonding__c = :ConfigPSTFabServ.bonding__c
                                     AND solder_type__c = :ConfigPSTFabServ.solder_type__c
                                     AND solder__c = :ConfigPSTFabServ.solder__c
                                     AND BLM_size_type__c = :ConfigPSTFabServ.BLM_size_type__c
                                     AND minimum_C4_pitch__c = :ConfigPSTFabServ.minimum_C4_pitch__c
                                     AND wafer_size__c = :this.proposalobj[0].wafer_size__c
                                     AND fab__c = :ConfigPSTFabServ.fab__c];
                                     
            List<PCM_Yield__c> yy = [SELECT id,wafer_size__c 
                                       FROM PCM_Yield__c
                                       WHERE bonding__c = :ConfigPSTFabServ.bonding__c
                                       AND solder_type__c = :ConfigPSTFabServ.solder_type__c
                                       AND solder__c = :ConfigPSTFabServ.solder__c
                                       AND BLM_size_type__c = :ConfigPSTFabServ.BLM_size_type__c
                                       AND minimum_C4_pitch__c = :ConfigPSTFabServ.minimum_C4_pitch__c
                                       AND wafer_size__c = :this.proposalobj[0].wafer_size__c
                                       AND fab__c = :ConfigPSTFabServ.fab__c];                                     
                                     
            if(cc.isEmpty() || yy.isEmpty()){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Selected Wafer Finishing combination is not applicable for this Configuration. Please change the selection.'));
                return NULL;    
            } else {
                for(PCM_Cost__c c: cc){
                    for(Apttus_Proposal__Proposal__c p: this.proposalobj){
                        if(c.wafer_size__c <> p.wafer_size__c){
                            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Wafer Size mismatch of the Wafer Finishing combination and Configuration. '+ 
                                                                                                'Please change the selection.'+c.wafer_size__c+' '+p.wafer_size__c));
                            return NULL;    
                        } 
                    }
                }                                                                                              
            }                                            
        }*/                
            
        if(proposalobj[0].Deliverable_Part_Type__c == 'Tested Wafer' || proposalobj[0].Deliverable_Part_Type__c == 'Chip' || 
           proposalobj[0].Deliverable_Part_Type__c == 'MCM' || proposalobj[0].Deliverable_Part_Type__c == 'Module') {      
             
            Id devRecordTypeId = Schema.SObjectType.Config_Post_Fab_Service_Detail__c.getRecordTypeInfosByName().get('Wafer Test Pass').getRecordTypeId();

            kerfxval = ConfigPSTFabServ.kerf_x__c;
            kerfyval = ConfigPSTFabServ.kerf_y__c;
            
            if(ConfigPSTFabServ.kerf_y__c== 0.00000 || ConfigPSTFabServ.kerf_x__c== 0.00000  ) { ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please select values more than Zero for Kerf X and Kerf Y')); return NULL; }
            if(ConfigPSTFabServ.Method__c == NULL) { ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please select wafer test yield method')); return NULL; }
       
            if(ConfigPSTFabServ.Method__c == 'Circuit') { 
                list<Config_Post_Fab_Service_Detail__c> lstWaferTestDetail = [Select Id,Circuit_Group__c,Circuit_Type__c,CKT_Unit__c,Count__c,Available_Redundancy__c from Config_Post_Fab_Service_Detail__c 
                                    Where Config_Post_Fab_Service__c = :ConfigPSTFabServ.ID AND RecordType.Name = 'Wafer Test Pass'];
               System.debug('ConfigPSTFabServ.ID'+ ConfigPSTFabServ.ID);
                if(lstWaferTestDetail.isEmpty()) {
                  ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please add atleast 1 wafer test yield method detail'));
                  return NULL;
                }                                            
            }
            else if(ConfigPSTFabServ.Method__c == 'Custom') {           
                if(pfnumber == NULL || pfnumber == -999 || PFStat == NULL || pfrevision == NULL || pfrevision == -999 || pfdesc == NULL || pfdesc== '--None--') {
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please enter details for wafer test yield method'));
                    return NULL;
                }
            }
        }
   
        
        if(ConfigPSTFabServ.Package_Tech_Method__c == 'GF') {       
            list<PCM_Cost__c> lstPCMCostGFModule = [SELECT Id from PCM_Cost__c where Package_Technology__c =:ConfigPSTFabServ.Package_Technology__c AND Package_IO_Count__c =:ConfigPSTFabServ.Package_IO__c AND Body_Length__c =:ConfigPSTFabServ.Body_Length__c AND Body_Width__c =:ConfigPSTFabServ.Body_Width__c AND Package_IO_Pitch__c = :ConfigPSTFabServ.Subst_IO_Pitch__c AND RecordType.Name = 'Cost Module BA REF'];
            
            if(lstPCMCostGFModule.isEmpty() && (proposalobj[0].Deliverable_Part_Type__c == 'MCM' || proposalobj[0].Deliverable_Part_Type__c == 'Module')) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please select the correct Package Technology, Package IO,  Body Length, Body Width and IO Pitch combination in the Module Build Section')); return NULL; }
            
            lstPCMCostGFModule = [SELECT Id from PCM_Cost__c where Package_Technology__c =:ConfigPSTFabServ.Package_Technology__c AND Subst_Layers__c =:ConfigPSTFabServ.Subst_Layer__c 
                                  AND Subst_IO_Pitch__c =:ConfigPSTFabServ.Subst_IO_Pitch__c AND Subst_Material__c =:ConfigPSTFabServ.Subst_Material__c AND RecordType.Name = 'Cost Sub REF'];
            
            if(lstPCMCostGFModule.isEmpty() && (proposalobj[0].Deliverable_Part_Type__c == 'MCM' || proposalobj[0].Deliverable_Part_Type__c == 'Module')) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please select the correct Package Technology, Subst Layer, IO Pitch, and Subst Material combination in the Module Build Section')); return NULL; }       
        }
    //Shivam : Sprint10 : added validation to restrict the Number of Sockets Per Boards  ------ START
        if((proposalobj[0].Deliverable_Part_Type__c == 'MCM' || proposalobj[0].Deliverable_Part_Type__c == 'Module')  && (wl >= 5 ) 
			&& !String.isBlank(ConfigPSTFabServ.Reliability_Location__c) && !String.isBlank(ConfigPSTFabServ.Reliability_Platform__c)){
			PCM_Administration__c pcmAdminSetting = PCM_Administration__c.getInstance('CURRENT_SETTING');
			for(PCM_Time__c p : [select Avail__c from PCM_Time__c where RecordType.name = 'BI Usage' AND Usage_Fact__c = 'SOCKET_BIB' AND BI_OVEN__c =:ConfigPSTFabServ.Reliability_Platform__c AND Catalog_ID__c =:pcmAdminSetting.Catalog_ID__c AND Version__c =:pcmAdminSetting.Version_ID__c]){
				if(ConfigPSTFabServ.Number_of_Socket_Per_Boards__c > p.Avail__c){
					ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING,'Maximum allowed value for Number of Sockets Per Boards is '+p.Avail__c+'.'));return null;
				}                
			}
        }
    //Shivam : Sprint10 : added validation to restrict the Number of Sockets Per Boards  ------ FINISH
      //Ravindra - removed check for volume should be greater than 0  for Costs    
        for(wrapperlist wr: listwrapperSCCost){
                 if((wr.volume == NULL) && (proposalobj[0].Deliverable_Part_Type__c == 'MCM' || proposalobj[0].Deliverable_Part_Type__c == 'Module') && ConfigPSTFabServ.Package_Tech_Method__c=='Custom' ) {
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING,'Please fill the correct data for Subst Cost by time Period'));return null;}}
                    
        for(wrapperlist wr: listwrapperModuleBuild){if((wr.volume == NULL ) && (proposalobj[0].Deliverable_Part_Type__c == 'MCM' || proposalobj[0].Deliverable_Part_Type__c == 'Module') && ConfigPSTFabServ.Package_Tech_Method__c=='Custom') {
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING,'Please fill the correct data for Bond and Assembly Cost by Time Period'));return null;}}
                    
        for(wrapperlist wr: listwrapperModuleBuild2){if((wr.volume == NULL) && (proposalobj[0].Deliverable_Part_Type__c == 'MCM' || proposalobj[0].Deliverable_Part_Type__c == 'Module') && ConfigPSTFabServ.Package_Tech_Method__c=='Custom') {
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING,'Please fill the correct data for Package Option Cost by Time Period'));return null;}}
                    
        for(wrapperlist wr: listwrapperModuleBuild3){if((wr.volume == NULL || wr.volume==0.00000 ) && (proposalobj[0].Deliverable_Part_Type__c == 'MCM' || proposalobj[0].Deliverable_Part_Type__c == 'Module') && ConfigPSTFabServ.Package_Tech_Method__c=='Custom'){
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING,'Please fill the correct data for Bond and Assembly Yield by Time Period'));return null;}}
                    
        for(wrapperlist wr: listwrapperModule){if((wr.volume == NULL || wr.volume==0.00000) && (proposalobj[0].Deliverable_Part_Type__c == 'MCM' || proposalobj[0].Deliverable_Part_Type__c == 'Module') &&
                    ConfigPSTFabServ.Module_Test_Yield_Method__c == 'Custom') {
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING,'Please fill the required yield for Module'));return null;}}
        
        for(wrapperlist wr: listwrapperBurnInUser){if((wr.volume == NULL || wr.volume==0.00000) && ((proposalobj[0].Deliverable_Part_Type__c == 'MCM' || proposalobj[0].Deliverable_Part_Type__c == 'Module')  && (wl >= 5 ))) {
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING,'Please fill the required data for Burn-In Duration'));return null;}}
        
        for(wrapperlist wr: listwrapperMCMUser){ if((wr.volume == NULL) && ((proposalobj[0].Deliverable_Part_Type__c == 'MCM' || proposalobj[0].Deliverable_Part_Type__c == 'Module') && (wl >= 5 ))  ){
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING,'Please fill the required data for Burn-In Board Cost')); return null;}}   
                       
        for(wrapperlist wr: listwrapperBurnIn) { if((wr.volume == NULL || wr.volume==0.00000) && ((proposalobj[0].Deliverable_Part_Type__c == 'MCM' || proposalobj[0].Deliverable_Part_Type__c == 'Module' )&& (wl >= 5 )) && (ConfigPSTFabServ.Burn_in_Stress_Yield_Method__c == 'Custom')) {
           ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING,'Please fill the required yield for Single Chip Module Burn-in or Stress')); return null; } }           
                    
                    
                                                 
       ConfigPSTFabServ.PF_Desc__c = pfdesc; ConfigPSTFabServ.PF_Number__c = String.valueOf(pfnumber); ConfigPSTFabServ.PF_Stat__c = PFStat; ConfigPSTFabServ.Revision__c = String.valueOf(pfrevision); 
        
         
        
        try{ ID configReqId = ApexPages.currentPage().getParameters().get('retId');
            
            if( cnt > 0){ upsert ConfigPSTFabServ; }
            else  if(ConfigPSTFabServupdate == null &&  ConfigPSTFabServ.Bonding__c != null &&  ConfigPSTFabServ.Bonding__c != ''){
                ConfigPSTFabServ.Configuration__c = cid; upsert ConfigPSTFabServ; }
            if(!savedDetails()) { return NULL;}
            
        }catch(exception e)
        {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please select values for project code.'+e));
        }
        
        String currentUrl = ApexPages.currentPage().getURL(); String targetURL;
        
        targetURL =  currentUrl.replace('CPQConfigPostFabServices','ProposalSummary');PageReference pr = new PageReference(targetURL);
        
        Id businessObjectId = pr.getParameters().get('businessObjectId'); Id configRequestId = pr.getParameters().get('configRequestId');
        Id id1 = pr.getParameters().get('id'); Id lineitemid = pr.getParameters().get('lineItemId');
        Id retid = pr.getParameters().get('retId');
        
        pr.getParameters().clear(); pr.getParameters().put('businessObjectId', businessObjectId); 
        pr.getParameters().put('lineitemid', lineitemid); pr.getParameters().put('configRequestId', configRequestId); 
        pr.getParameters().put('retid', retid);  pr.getParameters().put('id', id1); 
        pr.getParameters().put('flow', 'GFFlow'); pr.getParameters().put('primaryLineNumber', '1'); 
        pr.setRedirect(true);return pr;
    }
    
    public PageReference backtoOption(){
        
        ID configReqId = ApexPages.currentPage().getParameters().get('retId');
        PageReference pr;
        String currentUrl = ApexPages.currentPage().getURL();      
        String targetURL;
        
        targetURL = Apexpages.currentPage().getHeaders().get('Origin').replace('--c','--apttus-config2') + currentUrl.replace('CPQConfigPostFabServices','Cart');
        pr = new PageReference(targetURL);
        pr.setRedirect(true);
        return pr;
    }
    public PageReference md() {        
        
        try{
            Config_Post_Fab_Service_Detail__c ct = [Select id from Config_Post_Fab_Service_Detail__c where id = :vid];
            Delete ct;
        }catch(exception e){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING,'Deletion in progress please wait'));
        }
        listConfigPostFabServiceDetails = [Select Circuit_Group__c,Count__c,CKT_Unit__c,Circuit_Type__c,Available_Redundancy__c from Config_Post_Fab_Service_Detail__c  where Config_Post_Fab_Service__c =: ConfigPSTFabServ.id and Circuit_Group__c !=null ]; 
        return null;
    }
    
   @testvisible private Boolean savedDetails(){        
        //delete old post fab service details before saving upsert ConfigPSTFabServ
        if(this.ConfigPSTFabServ.id <> null){
            List<String> postFabServiceDetailRecType = new List<String>{'Burn-in','Burn-in user defined yield','MCM user defined yield',
                                                                        'Module Build','Module user defined yield','SC Burn in board cost'};
            //delete Wafer test pass if Method is custom
            if(this.ConfigPSTFabServ.method__c == 'Custom'){
                postFabServiceDetailRecType.add('Wafer Test Pass');    
            }
            
            List<Config_Post_Fab_Service_Detail__c> deleteOldRecs = [SELECT id 
                                                                       FROM Config_Post_Fab_Service_Detail__c
                                                                       WHERE config_post_Fab_service__c = :this.ConfigPSTFabServ.id and Recordtype.Name IN : postFabServiceDetailRecType ];                                                                      
            delete deleteOldRecs;
        }
        
        //Insert new post fab service details
        List<Config_Post_Fab_Service_Detail__c> newRecs = new List<Config_Post_Fab_Service_Detail__c>();

        //Module Build
        Id ScBurnRecordtypeID= Schema.SObjectType.Config_Post_Fab_Service_Detail__c.getRecordTypeInfosByName().get('Module Build').getRecordTypeId();
        Integer maxRow = this.volumes.size();
       if(proposalobj[0].Deliverable_Part_Type__c=='Module' || proposalobj[0].Deliverable_Part_Type__c=='MCM') { 
        if(ConfigPSTFabServ.Package_Tech_Method__c == 'Custom') {
          for(Integer counter = 0; counter < listwrapperSCCost.size(); counter++){
            if(listwrapperSCCost[counter].volume == NULL || listwrapperModuleBuild[counter].volume == NULL
               || listwrapperModuleBuild2[counter].volume == NULL || listwrapperModuleBuild3[counter].volume == NULL) {
               if(listwrapperSCCost[counter].volume== NULL) {
                 ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING,'Please fill in all the required fields in Subst Cost by time Period section'));
               }
               if(listwrapperModuleBuild[counter].volume== NULL) {
                 ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING,'Please fill in all the required fields in Bond and Assembly Cost by Time Period section'));
               }if(listwrapperModuleBuild2[counter].volume== NULL) {
                 ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING,'Please fill in all the required fields in Package Option Cost by Time Period section'));
               }
               if(listwrapperModuleBuild3[counter].volume== NULL) {
                 ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING,'Please fill in all the required fields in Bond and Assembly Yield by Time Period section'));
               }
               
               return false;
            }
            
                Config_Post_Fab_Service_Detail__c newRec = new Config_Post_Fab_Service_Detail__c();
                newrec.recordTypeId = ScBurnRecordtypeID;    
                newRec.config_post_fab_service__c = this.configPSTFabServ.id;
                newRec.quarter__c = string.valueOf(this.listwrapperSCCost[counter].qrt).right(2);
                newRec.year__c= String.valueOf(this.listwrapperSCCost[counter].qrt).left(4);
                newRec.subst_cost_by_time_period__c = listwrapperSCCost[counter].volume;
                newRec.bond_assembly_cost_by_time_period__c= listwrapperModuleBuild[counter].volume;
                newRec.package_option_cost_by_time_period__c= listwrapperModuleBuild2[counter].volume;
                newRec.bond_assembly_yield_by_time_period__c= listwrapperModuleBuild3[counter].volume;
                newRecs.add(newRec);                                                              
            
          }
        }
        }
        if(proposalobj[0].Deliverable_Part_Type__c=='Module' || proposalobj[0].Deliverable_Part_Type__c=='MCM') {
        Id ModuleRecordTypeId = Schema.SObjectType.Config_Post_Fab_Service_Detail__c.getRecordTypeInfosByName().get('Module user defined yield').getRecordTypeId();
        if(ConfigPSTFabServ.Module_Test_Yield_Method__c == 'Custom') {                
          for(Wrapperlist wr: this.listwrapperModule){
            if(wr.volume == NULL ) {
               ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING,'Please fill in all the required fields in Module user defined yield'));
               return false;
            }             
            Config_Post_Fab_Service_Detail__c newRec = new Config_Post_Fab_Service_Detail__c();
            newRec.recordTypeId = ModuleRecordTypeId;
            newRec.config_post_fab_service__c = this.configPSTFabServ.id;
            newRec.quarter__c = string.valueOf(wr.qrt).right(2);
            newRec.year__c= String.valueOf(wr.qrt).left(4);
            newRec.user_defined_yield_module__c = wr.volume;
            newRecs.add(newRec);
          }
        }
        }      
       if((proposalobj[0].Deliverable_Part_Type__c=='Module'||proposalobj[0].Deliverable_Part_Type__c=='MCM') && (wl >=5 ) )  {
        Id BurnRecordTypeId = Schema.SObjectType.Config_Post_Fab_Service_Detail__c.getRecordTypeInfosByName().get('Burn-in').getRecordTypeId();        
        for(Wrapperlist wr: this.listwrapperBurnInUser){
            if(wr.volume == NULL ) {
               ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING,'Please fill in all the required fields in Reliability or Stress Services'));
               return false;
            } 
            Config_Post_Fab_Service_Detail__c newRec = new Config_Post_Fab_Service_Detail__c();
            newRec.recordTypeId = BurnRecordTypeId;
            newRec.config_Post_Fab_Service__c = this.configPSTFabServ.id;
            newRec.quarter__c = string.valueOf(wr.qrt).right(2);
            newRec.year__c= String.valueOf(wr.qrt).left(4);
            newRec.burn_in_duration__c = wr.volume;
            newRecs.add(newRec);
        }       
       
        Id BoardRecordTypeId = Schema.SObjectType.Config_Post_Fab_Service_Detail__c.getRecordTypeInfosByName().get('SC Burn in board cost').getRecordTypeId();        
        for(wrapperlist wr: listwrapperMCMUser){
            if(wr.volume == NULL) {
               ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING,'Please fill in all the required fields in Reliability or Stress Services'));
               return false;
            } 
            Config_Post_Fab_Service_Detail__c newRec = new Config_Post_Fab_Service_Detail__c();
            newRec.recordTypeId = BoardRecordTypeId;
            newRec.config_Post_Fab_Service__c = this.configPSTFabServ.id;
            newRec.quarter__c = string.valueOf(wr.qrt).right(2);
            newRec.year__c= String.valueOf(wr.qrt).left(4);
            newRec.Burn_in_Board_Cost__c = wr.volume;
            newRecs.add(newRec);
        }
        
        Id BiRecordTypeId = Schema.SObjectType.Config_Post_Fab_Service_Detail__c.getRecordTypeInfosByName().get('Burn-in user defined yield').getRecordTypeId();
        if(ConfigPSTFabServ.Burn_in_Stress_Yield_Method__c  == 'Custom') {        
        for(wrapperlist wr: listwrapperBurnIn){
            if(wr.volume == NULL) {
               ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING,'Please fill in all the required fields in Reliability or Stress Services'));
               return false;
            } 
            Config_Post_Fab_Service_Detail__c newRec = new Config_Post_Fab_Service_Detail__c();
            newRec.recordTypeId = BiRecordTypeId;
            newRec.config_Post_Fab_Service__c = this.configPSTFabServ.id;
            newRec.quarter__c = string.valueOf(wr.qrt).right(2);
            newRec.year__c= String.valueOf(wr.qrt).left(4);
            newRec.User_Defined_Yield_BI__c = wr.volume;                     
            newRecs.add(newRec);
        } 
        }       

         }                       
        
        insert newRecs;      
        return true;                                                            
    }
    
    public PageReference backtoQuaterlyPage(){
        
        if(ConfigPSTFabServ.Configuration__c ==null){
            ConfigPSTFabServ.Configuration__c = cid;
        }
        ConfigPSTFabServ.PF_Desc__c = pfdesc;
        ConfigPSTFabServ.PF_Number__c = String.valueOf(pfnumber);
        ConfigPSTFabServ.PF_Stat__c = PFStat;
        ConfigPSTFabServ.Revision__c = String.valueOf(pfrevision);
        upsert ConfigPSTFabServ;
        if(ConfigPostFabServiceDetail.Config_Post_Fab_Service__c ==null){
            ConfigPostFabServiceDetail.Config_Post_Fab_Service__c = ConfigPSTFabServ.id;
        }        
        
        savedDetails();
        
       
        
        ID configReqId = ApexPages.currentPage().getParameters().get('retId');
        ID idval = ApexPages.currentPage().getParameters().get('id');
        Id id1 = ApexPages.currentPage().getParameters().get('lineItemId');
        Id confrequid = ApexPages.currentPage().getParameters().get('configRequestId');
        PageReference pr;
        String currentUrl = ApexPages.currentPage().getURL();      
        String targetURL;
        targetURL = ('/apex/ConfigQuarterlyVolume?businessObjectId='+configReqId+'&lineItemId='+id1+'&configRequestId='+ confrequid+'&retId='+configReqId +'&id='+idval+'&flow=GFFlow&primaryLineNumber=1');
        pr = new PageReference(targetURL);
        pr.setRedirect(true); 
        
        return pr;
    }
    public PageReference UserModuleDisplay() {
        if(ConfigPSTFabServ.Package_Tech_Method__c=='GF'){
            isModuleDetails = true;
          
        }
        else  if(ConfigPSTFabServ.Package_Tech_Method__c=='Custom'){
            isModuleDetails = false;
        }else{
            isModuleDetails = false;
            
        }

        return null;
    }
    
    
    
    public PageReference WTTDisplay() {
        
        if(ConfigPSTFabServ.Method__c=='Circuit'){
            isWTTDisplay= true;
            customDisplay=false;
            ispfdetails =false;
        }else if(ConfigPSTFabServ.Method__c=='Custom'){
            isWTTDisplay= false;
            customDisplay=true;
            ispfdetails =true;
        }else {
            isWTTDisplay= false;
            customDisplay=false;
            ispfdetails =false;
        }
        
        
        return null;
        
    }
    
    public PageReference renderWTY() {
        return null;
    }
    
    public PageReference UserWaferDisplay() {
    
        if(ConfigPSTFabServ.Test_Time_Method__c!=null && ConfigPSTFabServ.Test_Time_Method__c == 'User Defined GTT/Chip'){
            isWTTDetails = true;
        }else{
            isWTTDetails = false;
            
        }
        return null;
    }
    
    
    public PageReference UserDefinedYieldDisplay() {
        if(ConfigPSTFabServ.Burn_in_Stress_Yield_Method__c == 'Custom'){
            isBYMDetails = true;
        }else{
            isBYMDetails = false;
            
        }
        return null;
    }
    
    public PageReference UserModuleDefinedDisplay() {
        if(ConfigPSTFabServ.Module_Test_Time_Method__c == 'User Defined GTT/Chip'){
            isUMDDetails = true;
        }else{
            isUMDDetails = false;
            
        }
        return null;
    }
    
    public PageReference UserModuleTimeDisplay() {
        if(ConfigPSTFabServ.Module_Test_Yield_Method__c == 'Custom'){
            isUTDDetails = true;
        }else{
            isUTDDetails = false;
            
        }
        return null;
    }
    
    
    public PageReference populatekerf() {
        if(ConfigPSTFabServ.Minimum_Kerf__c==NULL)ConfigPSTFabServ.Minimum_Kerf__c='Yes';
        if(ConfigPSTFabServ.Minimum_Kerf__c=='Yes'){
            if(PCMYieldObj.size()>0){
                ConfigPSTFabServ.Kerf_X__c =  PCMYieldObj[0].PROD_INT__c;
                ConfigPSTFabServ.Kerf_Y__c =  PCMYieldObj1[0].PROD_INT__c;  
            }
        }else{
        
       if(PCMYieldObj.size() > 0 && PCMYieldObj1.size() > 0){
           if(ConfigPSTFabServ!=null && ConfigPSTFabServ.Kerf_X__c == PCMYieldObj[0].PROD_INT__c){
                ConfigPSTFabServ.Kerf_X__c = Null;
               }
               if(ConfigPSTFabServ!=null && ConfigPSTFabServ.Kerf_Y__c== PCMYieldObj1[0].PROD_INT__c){
                ConfigPSTFabServ.Kerf_Y__c = Null; 
                }
                
            }
        }
        return null;
    }
    public void generateList(integer cnt){
        qtrCount = new List<integer>();
        
        for(integer i=1;i<=cnt && i<25;i++){
            qtrCount.add(i);
        }
    }
    
    public PageReference UserDefinedDisplay() {
        if(ConfigPSTFabServ.MCM_Test_Time_Method__c == 'User Defined GTT/Chip'){
            isUserDetails = true;
        }else{
            isUserDetails = false;
            
        }
        return null;
    }
    
    
    public List<SelectOption> getPfrevisions() {
        Set<String> pfrivisions = new Set<String>();
        for(PFile_Data__c pf: [select Revision__c from PFile_Data__c where PF_Stat__c =: PFStat AND PF_Number__c =: pfnumber]){
            pfrivisions.add(String.valueOf(pf.Revision__c));
        }
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('-999','--None--'));
        for(String s: pfrivisions){
            options.add(new SelectOption(s,s));
            
        }
        
        return options;
        
        
    }
    
    
    public List<SelectOption> getPfdescrs() {
        Set<String> pfrivisions = new Set<String>();
        
        for(PFile_Data__c pf: [select PF_Desc__c from PFile_Data__c where Revision__c =: pfrevision AND PF_Stat__c =: PFStat AND PF_Number__c =: pfnumber]){
            pfrivisions.add(String.valueOf(pf.PF_Desc__c));
        }
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('--None--','--None--'));
        for(String s: pfrivisions){
            options.add(new SelectOption(s,s));
        }
        return options;
    }
    
      public PageReference getpfchilds() {
        pflist   = [select PF_Stat__c,PF_Desc__c,Revision__c, PF_Number__c from PFile_Data__c where PF_Stat__c=:PFStat and PF_Desc__c=:pfdesc and PF_Number__c =: pfnumber and Revision__c =: pfrevision ];
        try{
            pfyields = new list<PFile_Yield__c>([Select Circuit_Group__c,Circuit_Type__c,Redundancy__c,Circuit_Unit__c,Count__c From PFile_Yield__c where Circuit_Group__c<>null and PFile__c=:pflist[0].id  AND Recordtype.name = 'Custom Circuit'] );
            ispfdetails = true;
        }catch(Exception e){
            ispfdetails = false;
        }
        return null;
    }
    
    public List<SelectOption> getPfvalues() {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('-999','--None--'));
        for(Decimal d : pfnumbers){
            options.add(new SelectOption(String.valueOf(d),String.valueOf(d)));
        }
        return options;
    }
    public PageReference createPFdata() {
        PFile_Data__c newpfdata = new PFile_Data__c();
        newpfdata.Configuration__c =cid ;
        newpfdata.PF_Stat__c =PFStat ;
        newpfdata.PF_Number__c =Integer.valueOf(pfnumber) ;
        newpfdata.Revision__c =Integer.valueOf(pfRevision) ;
        newpfdata.PF_Desc__c = String.ValueOf(pfDesc) ;
        pflist   = [select PF_Stat__c,PF_Desc__c,Revision__c, PF_Number__c from PFile_Data__c where PF_Stat__c=:PFStat and PF_Desc__c=:pfdesc ];
        return null;
    }
    
    public List<SelectOption> getPFStatvalues() {
        pfstats = new Set<String>();
        for(PFile_Data__c pf: [select PF_Stat__c from PFile_Data__c where PF_Number__c =: pfnumber]){ pfstats.add(pf.PF_Stat__c);
        }
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('--None--','--None--'));
        for(String s: pfstats){ options.add(new SelectOption(s,s));
        }
        return options;
    }
    
    public PageReference refreshBonding(){
        if(this.modifiedBondingVal == 'Bonding'){
            getSolderType(); getSolder(); getBLMSizeType(); getMinC4Pitch(); getBondingFab();           
        } else if(this.modifiedModBuildVal == 'Solder Type'){ getSolder(); getBLMSizeType(); getMinC4Pitch(); getBondingFab();   
        } else if(this.modifiedModBuildVal == 'Solder'){getBLMSizeType(); getMinC4Pitch();getBondingFab();    
        } else if(this.modifiedModBuildVal == 'BLM Size Type'){ getMinC4Pitch(); getBondingFab();          
        } else if(this.modifiedModBuildVal == 'Minimum C4 Pitch'){ getBondingFab(); 
        } 
        return null;
    }   
    
    public List<SelectOption> getBonding(){
        List<SelectOption> options = new List<SelectOption>();
        for(AggregateResult a: [SELECT count(id),bonding__c bonding
                                  FROM PCM_Cost__c
                                  WHERE recordtype.name = 'Bonding'
                                  GROUP BY bonding__c]){ options.add(new SelectOption(String.valueOf(a.get('bonding')),String.valueOf(a.get('bonding'))));
        }
        return options;
    }
    
    public List<SelectOption> getSolderType(){
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('--None--','--None--'));   
        for(AggregateResult a: [SELECT count(id),solder_type__c stype
                                  FROM PCM_Cost__c
                                  WHERE recordtype.name = 'Bonding'
                                  AND bonding__c = :this.ConfigPSTFabServ.bonding__c
                                  GROUP BY solder_type__c]){ options.add(new SelectOption(String.valueOf(a.get('stype')),String.valueOf(a.get('stype'))));
        }
        return options;
    }   
    
    public List<SelectOption> getSolder(){
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('--None--','--None--'));   
        for(AggregateResult a: [SELECT count(id),solder__c solder
                                  FROM PCM_Cost__c
                                  WHERE recordtype.name = 'Bonding'
                                  AND bonding__c = :this.ConfigPSTFabServ.bonding__c
                                  AND solder_type__c = :this.ConfigPSTFabServ.solder_type__c
                                  GROUP BY solder__c]){ options.add(new SelectOption(String.valueOf(a.get('solder')),String.valueOf(a.get('solder'))));
        }
        return options;
    }
    
    public List<SelectOption> getBLMSizeType(){
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('--None--','--None--'));   
        for(AggregateResult a: [SELECT count(id),blm_size_type__c blm
                                  FROM PCM_Cost__c
                                  WHERE recordtype.name = 'Bonding'
                                  AND bonding__c = :this.ConfigPSTFabServ.bonding__c
                                  AND solder_type__c = :this.ConfigPSTFabServ.solder_type__c
                                  AND solder__c = :this.ConfigPSTFabServ.solder__c
                                  GROUP BY blm_size_type__c]){  options.add(new SelectOption(String.valueOf(a.get('blm')),String.valueOf(a.get('blm'))));
        }
        return options;
    }
    
    public List<SelectOption> getMinC4Pitch(){
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('--None--','--None--'));   
        for(AggregateResult a: [SELECT count(id),minimum_c4_pitch__c c4
                                  FROM PCM_Cost__c
                                  WHERE recordtype.name = 'Bonding'
                                  AND bonding__c = :this.ConfigPSTFabServ.bonding__c
                                  AND solder_type__c = :this.ConfigPSTFabServ.solder_type__c
                                  AND solder__c = :this.ConfigPSTFabServ.solder__c
                                  AND blm_size_type__c = :this.ConfigPSTFabServ.blm_size_type__c
                                  GROUP BY minimum_c4_pitch__c]){ options.add(new SelectOption(String.valueOf(a.get('c4')),String.valueOf(a.get('c4'))));
        }
        return options;
    }
    
    public List<SelectOption> getBondingFab(){
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('--None--','--None--'));   
        for(AggregateResult a: [SELECT count(id),fab__c fab
                                  FROM PCM_Cost__c
                                  WHERE recordtype.name = 'Bonding'
                                  AND bonding__c = :this.ConfigPSTFabServ.bonding__c
                                  AND solder_type__c = :this.ConfigPSTFabServ.solder_type__c
                                  AND solder__c = :this.ConfigPSTFabServ.solder__c
                                  AND blm_size_type__c = :this.ConfigPSTFabServ.blm_size_type__c
                                  AND minimum_c4_pitch__c = :this.ConfigPSTFabServ.minimum_c4_pitch__c
                                  GROUP BY fab__c]){ options.add(new SelectOption(String.valueOf(a.get('fab')),String.valueOf(a.get('fab'))));
        }
        return options;
    }
    
    public PageReference refreshModuleBuild(){
        if(this.modifiedModBuildVal == 'Package Tech'){
            getPackageIO();
            getBodyLength();
            getBodyWidth();
            getSubstIOPitch();
            getSubstLayer();
            getSubstMaterial();
            getPackageMaterial();
        } else if(this.modifiedModBuildVal == 'Package IO'){
            getBodyLength();
            getBodyWidth();
            getSubstIOPitch();
            getSubstLayer();
            getSubstMaterial();
            getPackageMaterial();
        } else if(this.modifiedModBuildVal == 'Body Length' || this.modifiedModBuildVal == 'Body Width'){
            getSubstIOPitch();
            getSubstLayer();
            getSubstMaterial(); 
            getPackageMaterial();   
        } else if(this.modifiedModBuildVal == 'Subst IO Pitch'){
            getSubstLayer();
            getSubstMaterial();  
            getPackageMaterial();          
        } else if(this.modifiedModBuildVal == 'Subst Layer'){            
            getSubstMaterial();
        } else if(this.modifiedModBuildVal == 'Subst Material'){
            getLineWidth();
        }
        return null;
    }
    
    public List<SelectOption> getPackageTech(){
        List<SelectOption> options = new List<SelectOption>();
        for(AggregateResult a: [SELECT count(id),package_technology__c tech
                                  FROM PCM_Cost__c
                                  WHERE recordtype.name = 'Cost Sub Ref'
                                  GROUP BY package_technology__c]){ options.add(new SelectOption(String.valueOf(a.get('tech')),String.valueOf(a.get('tech'))));
        }
        return options;
    }
    
    public List<SelectOption> getPackageIO(){
        List<SelectOption> options = new List<SelectOption>();   
        options.add(new SelectOption('0','--None--'));   
        Set<String> val = new Set<String>();
        for(PCM_Cost__c c: [SELECT id,package_IO__c
                              FROM PCM_Cost__c
                              WHERE recordtype.name = 'Cost Sub Ref'
                              AND package_technology__c = :this.ConfigPSTFabServ.Package_Technology__c
                              ORDER BY package_IO__c]){ val.add(String.valueOf(c.package_IO__c));
        }
        for(String v: val){ options.add(new SelectOption(v,v));    
        }                             
        return options;
    }
    
    public List<SelectOption> getBodyLength(){
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('--None--','--None--'));
        Decimal packageIO = this.ConfigPSTFabServ.Package_IO__c <> null ? Decimal.valueOf(this.ConfigPSTFabServ.Package_IO__c) : null;
        for(AggregateResult a: [SELECT count(id),body_Length__c length
                                  FROM PCM_Cost__c
                                  WHERE recordtype.name = 'Cost Sub Ref'
                                  AND package_technology__c = :this.ConfigPSTFabServ.Package_Technology__c
                                  AND package_IO__c = :packageIO                                   
                                  GROUP BY body_Length__c
                                  ORDER BY body_Length__c ]){ options.add(new SelectOption(String.valueOf(a.get('length')),String.valueOf(a.get('length'))));
        }
        return options;
    }
    
    public List<SelectOption> getBodyWidth(){
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('--None--','--None--'));
        Decimal packageIO = this.ConfigPSTFabServ.Package_IO__c <> null ? Decimal.valueOf(this.ConfigPSTFabServ.Package_IO__c) : null;
        for(AggregateResult a: [SELECT count(id),body_width__c width
                                  FROM PCM_Cost__c
                                  WHERE recordtype.name = 'Cost Sub Ref'
                                  AND package_technology__c = :this.ConfigPSTFabServ.Package_Technology__c
                                  AND package_IO__c = :packageIO 
                                  GROUP BY body_width__c
                                  ORDER BY body_Width__c ]){ options.add(new SelectOption(String.valueOf(a.get('width')),String.valueOf(a.get('width'))));
        }
        return options;
    }
    
    public List<SelectOption> getSubstIOPitch(){
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('--None--','--None--'));
        Decimal packageIO = this.ConfigPSTFabServ.Package_IO__c <> null ? Decimal.valueOf(this.ConfigPSTFabServ.Package_IO__c) : null;
        for(AggregateResult a: [SELECT count(id),subst_io_pitch__c IOPitch
                             FROM PCM_Cost__c
                             WHERE recordtype.name = 'Cost Sub Ref'
                             AND package_technology__c = :this.ConfigPSTFabServ.Package_Technology__c
                             AND package_IO__c = :packageIO
                             AND body_length__c = :this.ConfigPSTFabServ.Body_Length__c
                             AND body_width__c = :this.ConfigPSTFabServ.Body_Width__c
                             GROUP BY subst_io_pitch__c]){ options.add(new SelectOption(String.valueOf(a.get('IOPitch')),String.valueOf(a.get('IOPitch'))));
        }
        return options;
    }        
    
    public List<SelectOption> getSubstLayer(){
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('--None--','--None--'));
        Decimal packageIO = this.ConfigPSTFabServ.Package_IO__c <> null ? Decimal.valueOf(this.ConfigPSTFabServ.Package_IO__c) : null;
        for(AggregateResult a: [SELECT count(id),subst_layers__c SubstLayer
                             FROM PCM_Cost__c
                             WHERE recordtype.name = 'Cost Sub Ref'
                             AND package_technology__c = :this.ConfigPSTFabServ.Package_Technology__c
                             AND package_IO__c = :packageIO
                             AND body_length__c = :this.ConfigPSTFabServ.Body_Length__c
                             AND body_width__c = :this.ConfigPSTFabServ.Body_Width__c
                             AND subst_io_pitch__c = :this.ConfigPSTFabServ.Subst_IO_Pitch__c
                             GROUP BY subst_layers__c]){ options.add(new SelectOption(String.valueOf(a.get('SubstLayer')),String.valueOf(a.get('SubstLayer'))));
        }
        return options;
    }
    
    public List<SelectOption> getSubstMaterial(){
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('--None--','--None--'));
        Decimal packageIO = this.ConfigPSTFabServ.Package_IO__c <> null ? Decimal.valueOf(this.ConfigPSTFabServ.Package_IO__c) : null;
        for(AggregateResult a: [SELECT count(id),subst_material__c SubstMaterial
                             FROM PCM_Cost__c
                             WHERE recordtype.name = 'Cost Sub Ref'
                             AND package_technology__c = :this.ConfigPSTFabServ.Package_Technology__c
                             AND package_IO__c = :packageIO
                             AND body_length__c = :this.ConfigPSTFabServ.Body_Length__c
                             AND body_width__c = :this.ConfigPSTFabServ.Body_Width__c
                             AND subst_io_pitch__c = :this.ConfigPSTFabServ.Subst_IO_Pitch__c
                             AND subst_layers__c = :this.ConfigPSTFabServ.Subst_Layer__c
                             GROUP BY subst_material__c 
                             ORDER BY subst_material__c]){ options.add(new SelectOption(String.valueOf(a.get('SubstMaterial')),String.valueOf(a.get('SubstMaterial'))));
        }
        return options;
    }
    
    public List<SelectOption> getLineWidth(){
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('--None--','--None--'));
        Decimal packageIO = this.ConfigPSTFabServ.Package_IO__c <> null ? Decimal.valueOf(this.ConfigPSTFabServ.Package_IO__c) : null;
        for(AggregateResult a: [SELECT count(id),line_width__c lineWidth
                             FROM PCM_Cost__c
                             WHERE recordtype.name = 'Cost Sub Ref'
                             AND package_technology__c = :this.ConfigPSTFabServ.Package_Technology__c
                             AND package_IO__c = :packageIO
                             AND body_length__c = :this.ConfigPSTFabServ.Body_Length__c
                             AND body_width__c = :this.ConfigPSTFabServ.Body_Width__c
                             AND subst_io_pitch__c = :this.ConfigPSTFabServ.Subst_IO_Pitch__c
                             AND subst_layers__c = :this.ConfigPSTFabServ.Subst_Layer__c
                             AND subst_material__c = :this.ConfigPSTFabServ.subst_material__c
                             GROUP BY line_width__c 
                             ORDER BY line_width__c ]){ options.add(new SelectOption(String.valueOf(a.get('lineWidth')),String.valueOf(a.get('lineWidth'))));
        }
        return options;
    }       
    
    public List<SelectOption> getPackageMaterial(){
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('--None--','--None--'));
        for(AggregateResult a: [SELECT count(id),wire_bond_material__c packageMaterial
                             FROM PCM_Cost__c
                             WHERE recordtype.name = 'Cost Module BA Ref'
                             AND package_technology__c = :this.ConfigPSTFabServ.Package_Technology__c
                             AND package_IO_count__c = :this.ConfigPSTFabServ.Package_IO__c
                             AND body_length__c = :this.ConfigPSTFabServ.Body_Length__c
                             AND body_width__c = :this.ConfigPSTFabServ.Body_Width__c
                             AND package_io_pitch__c = :this.ConfigPSTFabServ.subst_IO_Pitch__c
                             GROUP BY wire_bond_material__c 
                             ORDER BY wire_bond_material__c]){ options.add(new SelectOption(String.valueOf(a.get('packageMaterial')),String.valueOf(a.get('packageMaterial'))));
        }
        return options;
    }
    
    public List<SelectOption> getEncapsulation(){
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('None','--None--'));
        for(AggregateResult a: [SELECT count(id),encapsulation__c enc
                             FROM PCM_Cost__c
                             WHERE recordtype.name = 'Cost LID REF'                             
                             GROUP BY encapsulation__c 
                             ORDER BY encapsulation__c]){ options.add(new SelectOption(String.valueOf(a.get('enc')),String.valueOf(a.get('enc'))));
        }
        return options;
    }
    
    public List<SelectOption> getCapacitorType(){
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('--None--','--None--'));
        for(AggregateResult a: [SELECT count(id),capacitor_type__c cap
                             FROM PCM_Cost__c
                             WHERE recordtype.name = 'Cost DECAP REF'                             
                             GROUP BY capacitor_type__c 
                             ORDER BY capacitor_type__c]){ options.add(new SelectOption(String.valueOf(a.get('cap')),String.valueOf(a.get('cap'))));
        }
        return options;
    }
    
    // fetch quaterly volumme
    map<String,Config_Quarterly_Volume__c> mpQuarterly = new map<String,Config_Quarterly_Volume__c>(); 
    public void createQuarterlyVolumeList() {
      for(Config_Quarterly_Volume__c qt : [select  Q1_Volume__c,Q2_Volume__c,Q3_Volume__c,Q4_Volume__c, Quote_Proposal__c,Year__c from  Config_Quarterly_Volume__c where Quote_Proposal__c =: cid order by year__c asc]) {
        if(qt.Q1_Volume__c != NULL) {
          mpQuarterly.put(String.valueOf(qt.year__c)+'Q1',qt);
        }
        if(qt.Q2_Volume__c != NULL) {
          mpQuarterly.put(String.valueOf(qt.year__c)+'Q2',qt);
        }
        if(qt.Q3_Volume__c != NULL) {
          mpQuarterly.put(String.valueOf(qt.year__c)+'Q3',qt);
        }
        if(qt.Q4_Volume__c != NULL) {
          mpQuarterly.put(String.valueOf(qt.year__c)+'Q4',qt);
        }  
      }
    }
    
     // fetch quaterly volumme
    list<Config_Post_Fab_Service_Detail__c> lstDetailToDelete = new list<Config_Post_Fab_Service_Detail__c>();  
    public list<wrapperlist> fetchDetailData(String recordTypeName,String fieldName) {
      list<wrapperlist> lstTemp = new list<wrapperlist>(); 
      map<String,Config_Post_Fab_Service_Detail__c> mpConfig_Post_Fab_Service_Detail = new map<String,Config_Post_Fab_Service_Detail__c>();
       
      for(Config_Post_Fab_Service_Detail__c det :  [Select Year__c, User_Defined_Yield_Module__c, User_Defined_Yield_MCM__c, User_Defined_Yield_BI__c, User_Defined_Time_MCM__c, SystemModstamp, Subst_Cost_by_Time_Period__c, RecordTypeId, Quarter__c, Package_Option_Cost_by_Time_Period__c, Name, Method__c, LastModifiedDate, LastModifiedById, IsDeleted, Id, CreatedDate, CreatedById, Count__c, Config_Post_Fab_Service__c, Circuit_Type__c, Circuit_Group__c, CKT_Unit__c, Burn_in_duration__c, Burn_in_Board_Cost__c, Bond_Assembly_Yield_by_Time_Period__c, Bond_Assembly_Cost_by_Time_Period__c, Available_Redundancy__c 
                                                    From Config_Post_Fab_Service_Detail__c 
                                                    where recordType.Name = :recordTypeName AND Config_Post_Fab_Service__c =: ConfigPSTFabServ.id]) {
        String key = String.valueof(det.Year__c) + String.valueOf(det.quarter__c);
        mpConfig_Post_Fab_Service_Detail.put(key,det);
      }
      
      for(String key : mpQuarterly.keySet()) {
        if(mpConfig_Post_Fab_Service_Detail.containsKey(key)) {
          wrapperlist newwrapper=new  wrapperlist(); newwrapper.qrt = key;
          newwrapper.volume= mpConfig_Post_Fab_Service_Detail.get(key).get(fieldName) != NULL ? Decimal.valueOf(String.valueOf(mpConfig_Post_Fab_Service_Detail.get(key).get(fieldName))) : NULL;
          lstTemp.add(newwrapper);
        } 
        else {
          wrapperlist newwrapper=new  wrapperlist();
          newwrapper.qrt = key;
          newwrapper.volume= NULL;
          lstTemp.add(newwrapper);
        }
      } 
      return lstTemp;    
    }
    
}