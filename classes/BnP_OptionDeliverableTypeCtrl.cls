/**
   @Author <Cognizant Technology Solutions>
   @name <BnP_OptionDeliverableTypeCtrl>
   @CreateDate <02/09/2016>
   @Description <The Purpose of Apex Class To Capturethe Service,Design,wafer.Modul,Chip,Package Information>
   @Version <>
   @reference <>
   @Modified by <Arijit : 17/04/2017>
   @Modification Purpose <1. To Stop the Option Stage to go Backward direction>
  */
public with sharing Class  BnP_OptionDeliverableTypeCtrl
 {            
    public Customer_Requirement__c PropCR;
    public Boolean IsSaveVisible  {get;set;} 
    public Boolean IsEditVisible  {get;set;}
    public Wafer_Data__c wafer {set; get;}
    public Chip_Data__c Chp{set;get;} 
    public Design__c Des{set;get;}
    public Module_Data__c Modul{set;get;} 
    public Service__c Service{set;get;}
    public Package_Data__c pack{set;get;}
    public List<RecordType> lstred{get;set;}
    
    public String xlsHeader{
    get{
        String strHeader = '';
        strHeader += '<?xml version="1.0"?>';
        strHeader += '<?mso-application progid="Excel.Sheet"?>';
        return strHeader;
    }
 }
    public boolean ShowExport {set;get;}
    public List<Service__c> servicelist{get; set;}
    public List<Design__c> Designlist{get; set;}
    public List<Wafer_Data__c> WaferDatalist{get; set;}
    public List<Chip_Data__c> ChipDatalist{get; set;}
    public list<Module_Data__c> Modulelist{set;get;}
    public list<Package_Data__c> packagelist{set;get;}
 
      
    //Service Section
    public Boolean ServiceInputFieldSet {get;set;}
    public Boolean ServiceOutPutFieldSet {get;set;}
    Public String ButtonText{set; get;}
    Public Boolean IsCancelVisible{get;set;}

    //Wafer Section
    Public Boolean WaferInput {get;set;}
    Public Boolean WaferOutPut {get;set;}
    Public Boolean IsSaveWaferVisible {get;set;}
    Public Boolean IsEditWaferVisible {get;set;}
    Public String ButtonTextWafer{set; get;}
    Public Boolean IsCancelwaferVisible{get;set;}
    //Chip Section
    Public Boolean ChipInput {get;set;}
    Public Boolean ChipOutput {get;set;}
    Public String ButtonTextChip{set; get;}
    Public Boolean IsSaveChipVisible {get;set;}
    Public Boolean IsEditChipVisible {get;set;}
    Public Boolean IsCancelChipVisible{get;set;}

    //Module Section
    public Boolean ModuleInput {get;set;}
    public Boolean ModuleOutput {get;set;}
    public String ButtonTextModule{set; get;}
    public Boolean IsSaveModuleVisible {get;set;}
    public Boolean IsEditModuleVisible {get;set;}
    public Boolean IsCancelModuleVisible{get;set;}
    public boolean isMCM {get;set;}
    public string chipOptionSelection {get;set;}
    //Package Section
    Public Boolean PackageInput {get;set;}
    Public Boolean PackageOutput {get;set;}
    Public String ButtonTextPackage{set; get;}
    Public Boolean IsSavePackageVisible {get;set;}
    Public Boolean IsEditPackageVisible {get;set;}
    Public Boolean IsCancelPackageVisible{get;set;}
    
    //Design Section
    Public Boolean DesignInput {get;set;}
    Public Boolean DesignOutput {get;set;}
    Public String ButtonTextDesign{set; get;}
    Public Boolean IsSaveDesignVisible {get;set;}
    Public Boolean IsEditDesignVisible {get;set;}
    Public Boolean IsCancelDesignVisible{get;set;}

    //Modal Popup Code
    Public Boolean displayPopup {get; set;} 
    Public Integer Selection {get; set;}
    Public String RerenderPanelValue {get;set;}
    Public Boolean displayTabPanel {get;set;}

    //updated on 9/16/2016
    Public Boolean DeliverableTypedisable {get;set;}
    Public String Selectedcurenttab { get; set;}
    Public List<SelectOption> DeliverableType{get;set;}
    Public String selectDeliverabletype {set; get;}
    Map<String,Error_Codes__c> errorMessages;
    public string ValidationMsg {get; set;}
    public string currentOptionStage {get; set;}
    //constructor
    Public BnP_OptionDeliverableTypeCtrl(ApexPages.StandardController controller) 
    {                                         
        errorMessages = Error_Codes__c.getAll();
        this.PropCR = (Customer_Requirement__c)controller.getRecord();
        LoadDeliverableTypeOptions(); //Load all Deliverable type options
        Des = new Design__c();
        Des.Customer_Requirement__c= ApexPages.currentPage().getParameters().get('Id');
        wafer = new Wafer_Data__c();
        wafer.Technical_Requirement__c= ApexPages.currentPage().getParameters().get('Id');
        Service = new Service__c();
        Service.Technical_Requirement__c= ApexPages.currentPage().getParameters().get('Id');
        Chp=new Chip_Data__c();
        Chp.Technical_Requirement__c= ApexPages.currentPage().getParameters().get('Id');
        Modul = new Module_Data__c();
        Modul.Technical_Requirement__c= ApexPages.currentPage().getParameters().get('Id');
        pack = new Package_Data__c();
        pack.Technical_Requirement__c= ApexPages.currentPage().getParameters().get('Id');
        
        servicelist = new list<Service__c>();
        Designlist = new list<Design__c>();
        WaferDatalist = new list<Wafer_Data__c>(); 
        ChipDatalist = new list<Chip_Data__c>();
        Modulelist = new list<Module_Data__c>();
        packagelist = new list<Package_Data__c>();
                                  
        lstred = new List<RecordType>();
        // Section InputFieldSet & OutPutFieldSet for Service,Wafer,Chip,Module,Package,Design
        ServiceInputFieldSet = true;
        ServiceOutPutFieldSet = false;
        WaferInput = true;
        WaferOutPut = false;
        ChipInput = true;
        ChipOutput = false;
        ModuleInput = true;
        ModuleOutput = false;
        PackageInput = true;
        PackageOutput = false;
        DesignInput = true;
        DesignOutput = false; 
        
        ButtonText = 'Save';
        ButtonTextWafer = 'Save';
        ButtonTextChip = 'Save';
        ButtonTextModule = 'Save';
        ButtonTextPackage = 'Save';
        ButtonTextDesign = 'Save';     
        Selection = 0;
        RerenderPanelValue = 'Panel';
        
        Customer_Requirement__c Options= new Customer_Requirement__c();
        Options = [Select Id,Name,Deliverable_Type__c, Option_Stage__c From Customer_Requirement__c where Id =: ApexPages.currentPage().getParameters().get('Id')];
        selectDeliverabletype =Options.Deliverable_Type__c;
        currentOptionStage = Options.Option_Stage__c;
        if(selectDeliverabletype !=Null)
        {
          LoadServiceData();
          if(Service.Id == null)
          {
              IsServiceEdit();
          }
          if(Modul.Id == null)
          {              
              IsModuleEdit();
          }
          if(wafer.Id == null)
          {             
              IsWaferEdit();
          }
          if(Chp.Id == null)
          {
              IsChipEdit();  
          }
          if(pack.Id == null)
          {
              IsPackageEdit();
          }
          if(selectDeliverabletype == 'Wafer')
          {
              LoadWaferData(); 
              LoadChipData();            
          }
          else if(selectDeliverabletype == 'Chip')
          {
              LoadWaferData();
              LoadChipData();              
          } 
          else if(selectDeliverabletype == 'Module')
          {
              LoadWaferData();
              LoadChipData();
              LoadModuleData();
              LoadPackageData();
          }   
          LoadDesignData();
          if(Des.Id == null)
          {
              IsDesignEdit();
          }                
        }
        else
        {
            DeliverableTypeVisible();
        }  
        
        if(!servicelist.isEmpty()|| !Designlist.isEmpty()|| !WaferDatalist.isEmpty()|| !ChipDatalist.isEmpty()|| !Modulelist.isEmpty()|| !packagelist.isEmpty())
        {
           ShowExport= true;
        }
        
        else
        {
          ShowExport= false;
        }
    }
   /**
    *  @Description <The purpose of this method is to Load Service Data for Edit> 
    *  @name <LoadServiceData>
    *  @param <> <>
    *  @return <> - <>
    *  @throws exception-<Exception handled by GlobalUtility class>
    */    
    Public void LoadServiceData() 
    {
        string TRID = ApexPages.currentPage().getParameters().get('Id');
        String DT = ApexPages.currentPage().getParameters().get('DT');
        string DTValue = 'Yes';        
        
        String query = 'SELECT ';
        for(Schema.FieldSetMember f : this.getserviceinfo())
        {
            query += f.getFieldPath() + ', ';
        }                       
        query += 'Id,Name,Technical_Requirement__r.Name,Technical_Requirement__c FROM Service__c WHERE Technical_Requirement__c = '+ '\'' + Service.Technical_Requirement__c + '\'' + ' and Is_Deliverable_Type__c=' + '\'' + DTValue + '\'' + 'LIMIT 1';
        List<Service__c> lstService = new List<Service__c>();
        lstService = Database.query(query);  
        
        //updated bu pullarao
        servicelist.clear();
        servicelist.addall(lstService);
        //End 
                          
        if(lstService.size() > 0)
        {
            Service = lstService[0];           
            ButtonText = 'Update';
        }
        ServiceOutPutFieldSet = true;
        ServiceInputFieldSet = false;
        IsEditVisible = true;
        IsSaveVisible = false;                                                
    }  
    /**
    *  @Description <The purpose of this method is to Load Wafer Data for Edit> 
    *  @name <LoadWaferData>
    *  @param <> <>
    *  @return <> - <>
    *  @throws exception-<Exception handled by GlobalUtility class>
    */  
    Public void LoadWaferData()
    {
        string TRID = ApexPages.currentPage().getParameters().get('Id');
        String DT = ApexPages.currentPage().getParameters().get('DT');
        string DTValue = 'Yes';        
        
        String query = 'SELECT ';
        for(Schema.FieldSetMember f : this.getAdditionalactivesidewaferprocessing())
        {
            query += f.getFieldPath() + ', ';
        }
        for(Schema.FieldSetMember f : this.getActiveSideInterconnectDetails())
        {
            query += f.getFieldPath() + ', ';
        }   
        for(Schema.FieldSetMember f : this.getActiveSideC4Detailswf())
        {
            query += f.getFieldPath() + ', ';
        }  
        for(Schema.FieldSetMember f : this.getInterconnectDetails())
        {
            query += f.getFieldPath() + ', ';
        } 
        for(Schema.FieldSetMember f : this.getAdditionalbacksidewaferprocessing())
        {
            query += f.getFieldPath() + ', ';
        } 
        for(Schema.FieldSetMember f : this.getBackSideInterconnectDetails())
        {
            query += f.getFieldPath() + ', ';
        } 
        for(Schema.FieldSetMember f : this.getWaferDetails())
        {
            query += f.getFieldPath() + ', ';
        } 
        for(Schema.FieldSetMember f : this.getTestDetails())
        {
            query += f.getFieldPath() + ', ';
        } 
        for(Schema.FieldSetMember f : this.getAdditionalwaferprocessing())
        {
            query += f.getFieldPath() + ', ';
        }                      
        query += 'Id,Name,Technical_Requirement__r.Name,Technical_Requirement__c FROM Wafer_Data__c WHERE Technical_Requirement__c = '+ '\'' + wafer.Technical_Requirement__c + '\'' + ' and Is_Deliverable_Type__c=' + '\'' + DTValue + '\'' + 'LIMIT 1';
        List<Wafer_Data__c> lstWafer = new List<Wafer_Data__c>();
        lstWafer = Database.query(query);    
        
        //updated bu pullarao
        WaferDatalist.clear();
        WaferDatalist.addall(lstWafer); 
        //End                 
        
        if(lstWafer.size() > 0)
        { 
            wafer = lstWafer[0]; 
            Chp.Wafer_Data__c = lstWafer[0].Id;            
            ButtonTextWafer = 'Update'; 
            WaferOutPut = true;
            WaferInput = false;
            IsEditWaferVisible = true;
            IsSaveWaferVisible = false;
            IsCancelwaferVisible = false;
        }                                         
    }  
    /**
    *  @Description <The purpose of this method is to Load Chip Data for Edit> 
    *  @name <LoadChipData>
    *  @param <> <>
    *  @return <> - <>
    *  @throws exception-<Exception handled by GlobalUtility class>
    */  
    public void LoadChipData()
    {
        string TRID = ApexPages.currentPage().getParameters().get('Id');
        String DT = ApexPages.currentPage().getParameters().get('DT');
        string DTValue = 'Yes';        
        
        String query = 'SELECT ';
        for(Schema.FieldSetMember f : this.getParametersPartNumberIdentification())
        {
            query += f.getFieldPath() + ', ';   
        }
        for(Schema.FieldSetMember f : this.getPhysicalDimensions())
        {
            query += f.getFieldPath() + ', ';   
        }
        for(Schema.FieldSetMember f : this.getChipInterconnect())
        {
            query += f.getFieldPath() + ', '; 
        }
        for(Schema.FieldSetMember f : this.getGeneral())
        {
            query += f.getFieldPath() + ', '; 
        }
        for(Schema.FieldSetMember f : this.getDocumentation())
        {
            query += f.getFieldPath() + ', '; 
        }
        for(Schema.FieldSetMember f : this.getChip2D())
        {
            query += f.getFieldPath() + ', '; 
        }
        query += 'Id, Name,Technical_Requirement__r.Name,Wafer_Data__r.Name,Technical_Requirement__c, Wafer_Data__c FROM Chip_Data__c WHERE Technical_Requirement__c = '+ '\'' + Chp.Technical_Requirement__c + '\'' + ' and Is_Deliverable_Type__c=' + '\'' + DTValue + '\'';            
        List<Chip_Data__c> lstChip = new List<Chip_Data__c>();
        lstChip = Database.query(query);
        
       //updated bu pullarao
        ChipDatalist.clear();
        ChipDatalist.addall(lstChip);
        //End
        
        if(lstChip.size() > 0)
        {
            Chp = lstChip[0];
            ButtonTextChip = 'Update';
            Modul.Chip_1__c = Chp.Id;
            ChipOutput = true;
            ChipInput = false;
            IsEditChipVisible = true;
            IsSaveChipVisible = false;
            IsCancelChipVisible = false;
        }                                                      
    }  
    /**
    *  @Description <The purpose of this method is to Load Module Data for Edit> 
    *  @name <LoadModuleData>
    *  @param <> <>
    *  @return <> - <>
    *  @throws exception-<Exception handled by GlobalUtility class>
    */     
    Public void LoadModuleData()
    {
        string TRID = ApexPages.currentPage().getParameters().get('Id');
        String DT = ApexPages.currentPage().getParameters().get('DT');
        string DTValue = 'Yes';        
     
        String query = 'SELECT ';
        for(Schema.FieldSetMember f : this.getCapLid())
        {
            query += f.getFieldPath() + ', ';
        }               
        for(Schema.FieldSetMember f : this.getDiscreteComponents())
        {
            query += f.getFieldPath() + ', ';
        } 
        for(Schema.FieldSetMember f : this.getModuleDetails())
        {
            query += f.getFieldPath() + ', ';
        }
        for(Schema.FieldSetMember f : this.getMCM())
        {
            query += f.getFieldPath() + ', ';
        }
        for(Schema.FieldSetMember f : this.getModule2D())
        {
            query += f.getFieldPath() + ', ';
        }
        query += 'Id, Name,Technical_Requirement__r.Name,Chip_1__r.Name,Chip_1__c,Technical_Requirement__c FROM Module_Data__c  WHERE Technical_Requirement__c = '+ '\'' + Modul.Technical_Requirement__c + '\'' + ' and Is_Deliverable_Type__c=' + '\'' + DTValue + '\'' + 'LIMIT 1';            
        List<Module_Data__c> lstModule = new List<Module_Data__c>();
        lstModule = Database.query(query);
        
        //updated bu pullarao
        Modulelist.clear();
        Modulelist.addall(lstModule);
        //End
        
        if(lstModule.size() > 0)
        {
            Modul = lstModule[0];
            ButtonTextModule = 'Update';
            ModuleOutput = true;
            ModuleInput = false;
            IsEditModuleVisible = true;
            IsSaveModuleVisible = false;
            IsCancelModuleVisible = false;
            pack.Module_Data__c = Modul.Id;
        }                                                
    } 
    /**
    *  @Description <The purpose of this method is to Load PackageData for Edit> 
    *  @name <LoadPackageData>
    *  @param <> <>
    *  @return <> - <>
    *  @throws exception-<Exception handled by GlobalUtility class>
    */   
    Public void LoadPackageData()
    {
        string TRID = ApexPages.currentPage().getParameters().get('Id');
        String DT = ApexPages.currentPage().getParameters().get('DT');
        string DTValue = 'Yes';        
        
        String query = 'SELECT ';
        for(Schema.FieldSetMember f : this.getBottomSurfaceDetails())
        {
            query += f.getFieldPath() + ', ';
        }   
        for(Schema.FieldSetMember f : this.getBuildupLayerDetails())
        {
            query += f.getFieldPath() + ', ';
        }  
        for(Schema.FieldSetMember f : this.getCoreLayerDetails())
        {
            query += f.getFieldPath() + ', ';
        } 
        for(Schema.FieldSetMember f : this.getGeneralPackage())
        {
            query += f.getFieldPath() + ', ';
        }
        for(Schema.FieldSetMember f : this.getGeneralPackageDetails())
        {
            query += f.getFieldPath() + ', ';
        } 
        for(Schema.FieldSetMember f : this.getMLCLayerDetails())
        {
            query += f.getFieldPath() + ', ';
        }
        for(Schema.FieldSetMember f : this.getOtherInformation())
        {
            query += f.getFieldPath() + ', ';
        } 
        for(Schema.FieldSetMember f : this.getPackageChipSiteDetails())
        {
            query += f.getFieldPath() + ', ';
        }
        for(Schema.FieldSetMember f : this.getPackagePNDetails())
        {
            query += f.getFieldPath() + ', ';
        } 
        for(Schema.FieldSetMember f : this.getPackageServices())
        {
            query += f.getFieldPath() + ', ';
        }  
        for(Schema.FieldSetMember f : this.getTopSurfaceDetails())
        {
            query += f.getFieldPath() + ', ';
        }
        for(Schema.FieldSetMember f : this.getPackage2D())
        {
            query += f.getFieldPath() + ', ';
        }
        query += 'Id, Name,Technical_Requirement__r.Name,Module_Data__r.Name,Technical_Requirement__c,Module_Data__c FROM Package_Data__c  WHERE Technical_Requirement__c = '+ '\'' + pack.Technical_Requirement__c + '\'' + ' and Is_Deliverable_Type__c=' + '\'' + DTValue + '\'' + 'LIMIT 1';            
        List<Package_Data__c> lstPackage = new List<Package_Data__c>();
        lstPackage = Database.query(query); 
        
        //updated bu pullarao
        packagelist.clear();
        packagelist.addall(lstPackage);
        //End
        
        if(lstPackage.size() > 0)
        {         
            pack = lstPackage[0];           
            ButtonTextPackage = 'Update';
            PackageOutput = true;
            PackageInput = false;
            IsEditPackageVisible = true;
            IsCancelPackageVisible = false;
            IsSavePackageVisible = false; 
        }                                               
    }     
    /**
    *  @Description <The purpose of this method is to Load DesignData for Edit> 
    *  @name <LoadDesignData>
    *  @param <> <>
    *  @return <> - <>
    *  @throws exception-<Exception handled by GlobalUtility class>
    */ 
    public void LoadDesignData()
    {
        string TRID = ApexPages.currentPage().getParameters().get('Id');
        String DT = ApexPages.currentPage().getParameters().get('DT');
        string DTValue = 'Yes';        
       
        String query = 'SELECT ';
        for(Schema.FieldSetMember f : this.getAddCompilable())
        {
            query += f.getFieldPath() + ', ';
        }   
        for(Schema.FieldSetMember f : this.getAddCores())
        {
            query += f.getFieldPath() + ', ';
        } 
        for(Schema.FieldSetMember f : this.getAddImage())
        {
            query += f.getFieldPath() + ', ';
        } 
        for(Schema.FieldSetMember f : this.getAddImagePackage())
        {
            query += f.getFieldPath() + ', ';
        } 
        for(Schema.FieldSetMember f : this.getAddInterfaceCircuits())
        {
            query += f.getFieldPath() + ', ';
        } 
        for(Schema.FieldSetMember f : this.getAddPackage())
        {
            query += f.getFieldPath() + ', ';
        } 
        for(Schema.FieldSetMember f : this.getCircuitDetails())
        {
            query += f.getFieldPath() + ', ';
        } 
        for(Schema.FieldSetMember f : this.getCreateUser())
        {
            query += f.getFieldPath() + ', ';
        } 
        for(Schema.FieldSetMember f : this.getCreateUserDefined())
        {
            query += f.getFieldPath() + ', ';
        } 
        for(Schema.FieldSetMember f : this.getCreateUserDefinedcustomImg())
        {
            query += f.getFieldPath() + ', ';
        } 
        for(Schema.FieldSetMember f : this.getDesignServicesDetails())
        {
            query += f.getFieldPath() + ', ';
        } 
        for(Schema.FieldSetMember f : this.getDesignforTestDetails())
        {
            query += f.getFieldPath() + ', ';
        } 
        for(Schema.FieldSetMember f : this.getEditFeatures())
        {
            query += f.getFieldPath() + ', ';
        } 
        for(Schema.FieldSetMember f : this.getInterfaceCircuits())
        {
            query += f.getFieldPath() + ', ';
        } 
        for(Schema.FieldSetMember f : this.getPowerSupply())
        {
            query += f.getFieldPath() + ', ';
        }
        for(Schema.FieldSetMember f : this.getVDD1())
        {
            query += f.getFieldPath() + ', ';
        }
        for(Schema.FieldSetMember f : this.getVDD2())
        {
            query += f.getFieldPath() + ', ';
        }
        for(Schema.FieldSetMember f : this.getVDD3())
        {
            query += f.getFieldPath() + ', ';
        }
        for(Schema.FieldSetMember f : this.getVDD4())
        {
            query += f.getFieldPath() + ', ';
        }
        for(Schema.FieldSetMember f : this.getVDD5())
        {
            query += f.getFieldPath() + ', ';
        }
        for(Schema.FieldSetMember f : this.getVDD6())
        {
            query += f.getFieldPath() + ', ';
        } 
        for(Schema.FieldSetMember f : this.getImageDetails())
        {
            query += f.getFieldPath() + ', ';
        } 
        for(Schema.FieldSetMember f : this.getActiveSideC4Details())
        {
            query += f.getFieldPath() + ', ';
        } 
        for(Schema.FieldSetMember f : this.getActiveSideCapturePadDetails())
        {
            query += f.getFieldPath() + ', ';
        } 
        for(Schema.FieldSetMember f : this.getFileCheckIn())
        {
            query += f.getFieldPath() + ', ';
        } 
        for(Schema.FieldSetMember f : this.getMemorySummary())
        {
            query += f.getFieldPath() + ', ';
        } 
        for(Schema.FieldSetMember f : this.getSRAMDetails())
        {
            query += f.getFieldPath() + ', ';
        } 
        for(Schema.FieldSetMember f : this.getEmbeddedDRAMDetails())
        {
            query += f.getFieldPath() + ', ';
        } 
        for(Schema.FieldSetMember f : this.getDesignMethodology())
        {
            query += f.getFieldPath() + ', ';
        } 
        for(Schema.FieldSetMember f : this.getDesignDetails())
        {
            query += f.getFieldPath() + ', ';
        } 
        for(Schema.FieldSetMember f : this.getGroundruleWaivers())
        {
            query += f.getFieldPath() + ', ';
        } 
        for(Schema.FieldSetMember f : this.getSelecteDRAMs())
        {
            query += f.getFieldPath() + ', ';
        } 
        query += 'Id, Name,Customer_Requirement__r.Name,Customer_Requirement__c FROM Design__c WHERE Customer_Requirement__c= '+ '\'' + Des.Customer_Requirement__c+ '\'' + ' and Is_Deliverable_Type__c=' + '\'' + DTValue + '\'' + 'LIMIT 1';            
        
        List<Design__c> lstdesign = new List<Design__c>();
        lstdesign = Database.query(query);
        
        //updated bu pullarao
        Designlist.clear();
        Designlist.addall(lstdesign);
        //End
        
        if(lstdesign.size() > 0)
        {
            Des = lstdesign[0];    
            ButtonTextDesign= 'Update';
            DesignOutput = true; 
            DesignInput = false;
            IsEditDesignVisible = true;
            IsSaveDesignVisible = false;
        }
                                                 
    }     
    /**
    *  @Description <The purpose of this method is to Save the Service data> 
    *  @name <SaveServicedata>
    *  @param <> <>
    *  @return <> - <>
    *  @throws exception-<Exception handled by GlobalUtility class>
    */    
    public pagereference SaveServicedata()
    {            
        try 
        {
            if(ButtonText == 'Save')
            {
                //System.debug('<==>Option Stage : ' + currentOptionStage);
                string oppStage = currentOpportunityStage();
                if(oppStage == null || oppStage =='1. Discovery')
                {
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,errorMessages.get('OPTION_STAGE_ERROR').Message__c));

                    return null;
                   
                }
                
                boolean isReadyforTryforFit = false;
                isReadyforTryforFit = getOptionValueforTFF();
                if(!isReadyforTryforFit)
                {
                    prapareValidationmsg();                   
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,ValidationMsg));
                    return null;
                }
                
                integer numberofService = [Select Count() from Service__c where Technical_Requirement__c =: ApexPages.currentPage().getParameters().get('Id') and Is_Deliverable_Type__c= 'Yes'];
                if(numberofService == null || numberofService == 0)
                {
                    Service.Is_Deliverable_Type__c = 'Yes';
                    insert Service; 
                    
                   //updated bu pullarao                     
                    ShowExport = true;
                    servicelist.clear();
                    LoadServiceData();
                    Service=servicelist[0];
                    //End
                                     
                    //Update Option Stage 
                    BnP_OptionUtility GenericTr = new BnP_OptionUtility();               
                    List<Id> lstRecordId = new List<Id>();
                    lstRecordId.add(ApexPages.currentPage().getParameters().get('Id'));
                    if(currentOptionStage == 'Customer Engagement')
                        Boolean IsSuccess = GenericTr.updateOptionStages(lstRecordId, 'Try for Fit'); 
                }                                             
            }
            else
            {
                update Service; 
                
                //updated by pullarao
                servicelist.clear();
                servicelist.add(Service);
                //End
                                               
            } 
            PropCR.Service__c = Service.id;
            update PropCR;
            ServiceInputFieldSet = false;
            ServiceOutPutFieldSet = true; 
            IsEditVisible = true;
            IsSaveVisible = false;
            IsCancelVisible= false;         
            UpdateTRWithDT();
        }
        catch(Exception excp)
        {           
            GlobalUtility.logMessage('Error','BnP_OptionDeliverableTypeCtrl','SaveServicedata','','Exception while creating Service data for Option',String.valueof(excp.getMessage()),'','BnP',excp,0);
        }
                
        return null;
    }    
    /**
    *  @Description <The purpose of this method is to edit the Service data> 
    *  @name <EdittheSection>
    *  @param <> <>
    *  @return <> - <>
    *  @throws exception-<>
    */   
    public pagereference EdittheSection()
    {       
        ServiceInputFieldSet = true;
        ServiceOutPutFieldSet = false;
        ButtonText = 'Update'; 
        IsSaveVisible  = true; 
        IsCancelVisible = true;
        IsEditVisible   = false;
        return null;
    } 
    /**
    *  @Description <The purpose of this method is to Save the Wafer data> 
    *  @name <SaveWaferdata>
    *  @param <> <>
    *  @return <> - <>
    *  @throws exception-<Exception handled by GlobalUtility class>
    */   
    public pagereference SaveWaferdata()
    {           
        try 
        {
            
            if(ButtonTextWafer == 'Save')
            {
                string oppStage = currentOpportunityStage();
                if(oppStage == null || oppStage ==  '1. Discovery')
                {
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,errorMessages.get('OPTION_STAGE_ERROR').Message__c));
                    return null;
                }
                
                boolean isReadyforTryforFit = false;
                isReadyforTryforFit = getOptionValueforTFF();
                if(!isReadyforTryforFit)
                {
                    prapareValidationmsg();                   
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,ValidationMsg));
                    return null;
                }
                
                integer numberofWafer = [Select Count() from Wafer_Data__c where Technical_Requirement__c =: ApexPages.currentPage().getParameters().get('Id') and Is_Deliverable_Type__c= 'Yes'];
                if(numberofWafer == null || numberofWafer == 0)
                {               
                    wafer.Is_Deliverable_Type__c = 'Yes';
                   // wafer.Technical_Requirement__c= ApexPages.currentPage().getParameters().get('Id');
                    insert wafer;
                    
                     //updated by pullarao
                     ShowExport = true;
                     WaferDatalist.clear();
                     LoadWaferData();
                     wafer=WaferDatalist[0];
                     //End
                     
                    //Update Option Stage 
                    BnP_OptionUtility GenericTr = new BnP_OptionUtility();               
                    List<Id> lstRecordId = new List<Id>();
                    lstRecordId.add(ApexPages.currentPage().getParameters().get('Id'));
                    if(currentOptionStage == 'Customer Engagement')
                        Boolean IsSuccess = GenericTr.updateOptionStages(lstRecordId, 'Try for Fit');                     
                }                                             
            }
            else
            {
               update wafer;
               
               //updated by pullarao
               WaferDatalist.clear();
               WaferDatalist.add(wafer);
               //End
            } 
            Chp.Wafer_Data__c = wafer.id;
            PropCR.Wafer_Data__c = wafer.id;
            update PropCR;
            WaferInput = false;
            WaferOutPut = true; 
            IsEditWaferVisible = true;
            IsSaveWaferVisible = false;
            IsCancelwaferVisible = false;
            UpdateTRWithDT();
        }
        catch(Exception excp)
        {           
            GlobalUtility.logMessage('Error','BnP_OptionDeliverableTypeCtrl','SaveWaferdata','','Exception while creating Wafer data for Option',String.valueof(excp.getMessage()),'','BnP',excp,0);
        }
        return null;
    }  
    /**
    *  @Description <The purpose of this method is to edit the Wafer data> 
    *  @name <EditWaferSection>
    *  @param <> <>
    *  @return <> - <>
    *  @throws exception-<>
    */
    public pagereference EditWaferSection()
    {
        WaferInput = true;
        WaferOutPut = false; 
        ButtonTextWafer = 'Update'; 
        IsEditWaferVisible = false;
        IsSaveWaferVisible = true;
        IsCancelwaferVisible = true;
        return null;
    }
    /**
    *  @Description <The purpose of this method is to Save the Chip data> 
    *  @name <SaveChipdata>
    *  @param <> <>
    *  @return <> - <>
    *  @throws exception-<Exception handled by GlobalUtility class>
    */   
    public pagereference SaveChipdata()
    {                
        if(Chp.Wafer_Data__c == null)
        {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,errorMessages.get('OPTION_WAFERDATA_ERROR').Message__c));
             
            return null;
        }
        try 
        {
            if(ButtonTextChip == 'Save')
            {
                string oppStage = currentOpportunityStage();
                if(oppStage == null || oppStage == '1. Discovery')
                {
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,errorMessages.get('OPTION_STAGE_ERROR').Message__c));
                    return null;
                }
                
                boolean isReadyforTryforFit = false;
                isReadyforTryforFit = getOptionValueforTFF();
                if(!isReadyforTryforFit)
                {
                    prapareValidationmsg();
                    
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,ValidationMsg));
                    return null;
                }
                
                integer numberofChip = [Select Count() from Chip_Data__c where Technical_Requirement__c =: ApexPages.currentPage().getParameters().get('Id') and Is_Deliverable_Type__c= 'Yes'];
                if(numberofChip == null || numberofChip == 0)
                {
                    Chp.Is_Deliverable_Type__c= 'Yes';
                    insert Chp;
                    
                    //updated by pullarao
                    ShowExport = true;
                    ChipDatalist.clear();
                    LoadChipData();
                    Chp=ChipDatalist[0];
                    //End
                    PropCR.Chip_Data__c = Chp.id;
                    update PropCR;
                    
                   //Update Option Stage 
                    BnP_OptionUtility GenericTr = new BnP_OptionUtility();               
                    List<Id> lstRecordId = new List<Id>();
                    lstRecordId.add(ApexPages.currentPage().getParameters().get('Id'));
                    if(currentOptionStage == 'Customer Engagement')
                        Boolean IsSuccess = GenericTr.updateOptionStages(lstRecordId, 'Try for Fit');                 
                }                                             
            }
            else
            {
                update Chp;
                
                //updated by pullarao
                ChipDatalist.clear();
                ChipDatalist.add(Chp);
                //End

            }           
            Modul.Chip_1__c = Chp.Id; 
            ChipInput = false;
            ChipOutput = true;
            IsEditChipVisible = true;
            IsSaveChipVisible = false;
            IsCancelChipVisible = false;
            UpdateTRWithDT();    
        }
        catch(Exception excp)
        {           
            GlobalUtility.logMessage('Error','BnP_OptionDeliverableTypeCtrl','SaveChipdata','','Exception while creating Chip data for Option',String.valueof(excp.getMessage()),'','BnP',excp,0);
        }
       
        return null;
    } 
    /**
    *  @Description <The purpose of this method is to edit the Chip data> 
    *  @name <EditChipSection>
    *  @param <> <>
    *  @return <> - <>
    *  @throws exception-<>
    */
    public pagereference EditChipSection()
    {
        ChipInput = true;
        ChipOutput = false;
        ButtonTextChip = 'Update'; 
        IsEditChipVisible = false;
        IsSaveChipVisible = true;
        IsCancelChipVisible = true;
        return null;
    }
    /**
    *  @Description <The purpose of this method is to Save the Module data> 
    *  @name <SaveModuledata>
    *  @param <> <>
    *  @return <> - <>
    *  @throws exception-<Exception handled by GlobalUtility class>
    */ 
    public pagereference SaveModuledata()
    {                 
        if(Modul.Chip_1__c == null)
        {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,errorMessages.get('OPTION_MODULEDATA_ERROR').Message__c));
            return null;
        }
        try 
        {
            if(ButtonTextModule == 'Save')
            {
                string oppStage = currentOpportunityStage();
                if(oppStage == null || oppStage == '1. Discovery')
                {
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,errorMessages.get('OPTION_STAGE_ERROR').Message__c));
                    return null;
                }
                
                boolean isReadyforTryforFit = false;
                isReadyforTryforFit = getOptionValueforTFF();
                if(!isReadyforTryforFit)
                {
                    prapareValidationmsg();
                    
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,ValidationMsg));
                    return null;
                }
                
                integer numberofModule = [Select Count() from Module_Data__c where Technical_Requirement__c =: ApexPages.currentPage().getParameters().get('Id') and Is_Deliverable_Type__c= 'Yes'];
                if(numberofModule == null || numberofModule == 0)
                {
                    Modul.Is_Deliverable_Type__c= 'Yes';
                    insert Modul;
                    
                    //updated by pullarao
                    ShowExport = true;
                    Modulelist.clear();
                    LoadModuleData();
                    Modul=Modulelist[0];
                    //End

                    //Update Option Stage 
                    BnP_OptionUtility GenericTr = new BnP_OptionUtility();               
                    List<Id> lstRecordId = new List<Id>();
                    lstRecordId.add(ApexPages.currentPage().getParameters().get('Id'));
                    if(currentOptionStage == 'Customer Engagement')
                        Boolean IsSuccess = GenericTr.updateOptionStages(lstRecordId, 'Try for Fit');                           
                }
            }
            else
            {
                update Modul;
                
                //updated by pullarao
                Modulelist.clear();
                Modulelist.add(Modul);
                //End

            }
            
            
            PropCR.Modules__c = Modul.id;
            update PropCR;
            pack.Module_Data__c = Modul.id; 
            ModuleInput = false;
            ModuleOutput = true;
            IsEditModuleVisible  = true;
            IsSaveModuleVisible  = false;
            IsCancelModuleVisible = false;
            UpdateTRWithDT();
        }
        catch(Exception excp)
        {           
            GlobalUtility.logMessage('Error','BnP_OptionDeliverableTypeCtrl','SaveModuledata','','Exception while creating Module data for Option',String.valueof(excp.getMessage()),'','BnP',excp,0);
        }
       
        return null;
    }  
    /**
    *  @Description <The purpose of this method is to edit the Module data> 
    *  @name <EditModuleSection>
    *  @param <> <>
    *  @return <> - <>
    *  @throws exception-<>
    */
    Public pagereference EditModuleSection()
    {
        ModuleInput = true;
        ModuleOutput = false; 
        ButtonTextModule = 'Update'; 
        IsEditModuleVisible = false;
        IsSaveModuleVisible = true;
        IsCancelModuleVisible = true;
        return null;
    }
    /**
    *  @Description <The purpose of this method is to Save the Package data> 
    *  @name <SavePackagedata>
    *  @param <> <>
    *  @return <> - <>
    *  @throws exception-<Exception handled by GlobalUtility class>
    */ 
     public pagereference SavePackagedata()
    {                
        if(pack.Module_Data__c == null)
        {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,errorMessages.get('OPTION_PACKAGEDATA_ERROR').Message__c));
            return null;
        }  
        try 
        {
            if(ButtonTextPackage == 'Save')
            {
                string oppStage = currentOpportunityStage();
                if(oppStage == null || oppStage == '1. Discovery')
                {
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,errorMessages.get('OPTION_STAGE_ERROR').Message__c));
                    return null;
                }
                
                boolean isReadyforTryforFit = false;
                isReadyforTryforFit = getOptionValueforTFF();
                if(!isReadyforTryforFit)
                {
                    prapareValidationmsg();
                    //ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,errorMessages.get('IS_READY_TRYFORFIT').Message__c));
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,ValidationMsg));
                }
                
                integer numberofPackage = [Select Count() from Package_Data__c where Technical_Requirement__c =: ApexPages.currentPage().getParameters().get('Id') and Is_Deliverable_Type__c= 'Yes'];
                if(numberofPackage == null || numberofPackage == 0)
                {
                    pack.Is_Deliverable_Type__c= 'Yes';
                    insert pack;
                    
                     //updated by pullarao
                     ShowExport = true;
                     packagelist.clear();
                     LoadPackageData();
                     pack=packagelist[0];
                     //End
                     
                     
                    //Update Option Stage 
                    BnP_OptionUtility GenericTr = new BnP_OptionUtility();               
                    List<Id> lstRecordId = new List<Id>();
                    lstRecordId.add(ApexPages.currentPage().getParameters().get('Id'));
                    if(currentOptionStage == 'Customer Engagement')
                        Boolean IsSuccess = GenericTr.updateOptionStages(lstRecordId, 'Try for Fit');
                }                                   
            }
            else
            {
                update pack;
                
                //updated by pullarao
                packagelist.clear();
                packagelist.add(pack);
                //End
            }         
            
            PropCR.Package__c = pack.id;
            update PropCR;
            PackageInput = false;
            PackageOutput = true;
            IsEditPackageVisible  = true;
            IsSavePackageVisible  = false;
            IsCancelPackageVisible = false;
            UpdateTRWithDT();
        }
        catch(Exception excp)
        {           
            GlobalUtility.logMessage('Error','BnP_OptionDeliverableTypeCtrl','SavePackagedata','','Exception while creating Package data for Option',String.valueof(excp.getMessage()),'','BnP',excp,0);
        }
        return null;
    } 
    /**
    *  @Description <The purpose of this method is to edit the Package data> 
    *  @name <EditPackageSection>
    *  @param <> <>
    *  @return <> - <>
    *  @throws exception-<>
    */
    public pagereference EditPackageSection()
    {
        PackageInput = true;
        PackageOutput = false; 
        ButtonTextPackage = 'Update'; 
        IsEditPackageVisible = false;
        IsSavePackageVisible = true;
        IsCancelPackageVisible = true;
        return null;
    } 
    /**
    *  @Description <The purpose of this method is to Save the Design data> 
    *  @name <SaveDesigndata>
    *  @param <> <>
    *  @return <> - <>
    *  @throws exception-<Exception handled by GlobalUtility class>
    */
     public pagereference SaveDesigndata()
     {        
        try 
         {            
            if(ButtonTextDesign == 'Save')
            {
                string oppStage = currentOpportunityStage();
                if(oppStage == null || oppStage == '1. Discovery')
                {
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,errorMessages.get('OPTION_STAGE_ERROR').Message__c));
                    return null;
                }
                
                boolean isReadyforTryforFit = false;
                isReadyforTryforFit = getOptionValueforTFF();
                if(!isReadyforTryforFit)
                {
                    prapareValidationmsg();
                    //ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,errorMessages.get('IS_READY_TRYFORFIT').Message__c));
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,ValidationMsg));
                }
                
                integer numberofDesign = [Select Count() from Design__c where Customer_Requirement__c =: ApexPages.currentPage().getParameters().get('Id') and Is_Deliverable_Type__c= 'Yes'];
                if(numberofDesign== null || numberofDesign== 0)
                {
                    Des.Is_Deliverable_Type__c= 'Yes';
                    insert Des; 
                    
                     //updated by pullarao
                     ShowExport = true;
                     Designlist.clear();
                     LoadDesignData();
                     Des=Designlist[0];
                     //End
                    PropCR.Design__c = Des.id;
                    update PropCR;
                    //Update Option Stage 
                    BnP_OptionUtility GenericTr = new BnP_OptionUtility();               
                    List<Id> lstRecordId = new List<Id>();
                    lstRecordId.add(ApexPages.currentPage().getParameters().get('Id'));
                    if(currentOptionStage == 'Customer Engagement')
                        Boolean IsSuccess = GenericTr.updateOptionStages(lstRecordId, 'Try for Fit'); 
                }                                            
            }
            else
            {               
                update Des;
                
                //updated by pullarao
                Designlist.clear();
                Designlist.add(Des);
                //End

            }
            DesignInput = false;
            DesignOutput = true;
            IsEditDesignVisible = true;
            IsSaveDesignVisible = false;
            IsCancelDesignVisible = false;
            UpdateTRWithDT();
        }
        catch(Exception excp)
        {           
            GlobalUtility.logMessage('Error','BnP_OptionDeliverableTypeCtrl','SaveDesignData','','Exception while Saving Design data for Option',String.valueof(excp.getMessage()),'','BnP',excp,0);
        }
        return null;
    }
    /**
    *  @Description <The purpose of this method is to edit the Design data> 
    *  @name <EditDesignSection>
    *  @param <> <>
    *  @return <> - <>
    *  @throws exception-<>
    */   
    public pagereference EditDesignSection()
    {
        //Design Section
        DesignInput = true;
        DesignOutput = false; 
        ButtonTextDesign= 'Update'; 
        IsEditDesignVisible = false;
        IsSaveDesignVisible = true;
        IsCancelDesignVisible = true;
        return null;
    }
    /**
    *  @Description <The purpose of this method is to cancel the input values for Service data> 
    *  @name <canceldata>
    *  @param <> <>
    *  @return <> - <>
    *  @throws exception-<>
    */
    public void canceldata()
    {
       if(Service.Id != Null)
        {
           LoadServiceData();
        }
        else
        {
           Service = new Service__c();
           Service.Technical_Requirement__c= ApexPages.currentPage().getParameters().get('Id');
        }  
        
        if(ButtonText == 'Update')
        {
            IsCancelVisible = false;
        }
    }
    /**
    *  @Description <The purpose of this method is to cancel the input values for Wafer data> 
    *  @name <cancelWaferdata>
    *  @param <> <>
    *  @return <> - <>
    *  @throws exception-<>
    */
    public void cancelWaferdata()
    {
       if(wafer.Id != Null)
        {
           LoadWaferData();
        }
        else
        {
           wafer = new Wafer_Data__c();
           wafer.Technical_Requirement__c= ApexPages.currentPage().getParameters().get('Id');
        }  
        if(ButtonTextWafer == 'Update')
        {
          IsCancelwaferVisible = false;
        }
    }
    /**
    *  @Description <The purpose of this method is to cancel the input values for Chip data> 
    *  @name <CancelChipdata>
    *  @param <> <>
    *  @return <> - <>
    *  @throws exception-<>
    */ 
    public void CancelChipdata()
    {
    
       if(Chp.Id != Null)
        {
           LoadChipData();
        }
        else
        {
           Chp=new Chip_Data__c();
           Chp.Technical_Requirement__c= ApexPages.currentPage().getParameters().get('Id');
           Chp.Wafer_Data__c = wafer.Id;
        }  
        if(ButtonTextChip== 'Update')
        {
          IsCancelChipVisible= false;
        }
    }
    /**
    *  @Description <The purpose of this method is to cancel the input values for Module data> 
    *  @name <CancelModuledata>
    *  @param <> <>
    *  @return <> - <>
    *  @throws exception-<>
    */ 
    public void CancelModuledata()
    {
       if(Modul.Id != Null)
        {
           LoadModuleData();
        }
        else
        {
        
        Modul = new Module_Data__c();
        Modul.Technical_Requirement__c= ApexPages.currentPage().getParameters().get('Id');
        Modul.Chip_1__c = Chp.Id;
        }
        if(ButtonTextModule == 'Update')
        {
          IsCancelModuleVisible= false;
        }
  
    }
    /**
    *  @Description <The purpose of this method is to cancel the input values for Package data> 
    *  @name <CancelPackagedata>
    *  @param <> <>
    *  @return <> - <>
    *  @throws exception-<>
    */ 
    public void CancelPackagedata()
    {
       if(pack.Id != Null)
        {
           LoadPackageData();
        }
        else
        {
          pack = new Package_Data__c();
          pack.Technical_Requirement__c= ApexPages.currentPage().getParameters().get('Id');    
          pack.Module_Data__c = Modul.Id;
       } 
        if(ButtonTextPackage == 'Update')
        {
          IsCancelPackageVisible= false;
        }
 
    }
    /**
    *  @Description <The purpose of this method is to cancel the input values for Design data> 
    *  @name <CancelDesigndata>
    *  @param <> <>
    *  @return <> - <>
    *  @throws exception-<>
    */ 
    public void CancelDesigndata()
    {
       if(Des.Id != Null)
        {
           LoadDesignData();
        }
        else
        {
         Des = new Design__c();
         Des.Customer_Requirement__c= ApexPages.currentPage().getParameters().get('Id');
       }
       if(ButtonTextDesign == 'Update')
       {
          IsCancelDesignVisible = false;
       }
    }    
     /**
    *  @Description <The purpose of this method is to load service object FieldSets> 
    *  @name <getserviceinfo>
    *  @param <> <>
    *  @return <List<Schema.FieldSetMember> - <Returns the fieldset member in Service Object>
    *  @throws exception-<>
    */ 
    public List<Schema.FieldSetMember> getserviceinfo() 
    {
        return SObjectType.Service__c.FieldSets.service.getFields();
    }   
     /**
    *  @Description <The purpose of this method is to load Design object FieldSets> 
    *  @name <getAddCompilable>
    *  @param <> <>
    *  @return <List<Schema.FieldSetMember> - <Returns the fieldset member in Design Object>
    *  @throws exception-<>
    */ 
    Public List<Schema.FieldSetMember> getAddCompilable() 
    {        
        return SObjectType.Design__c.FieldSets.AddCompilableCircuitList.getFields();
    }

    Public List<Schema.FieldSetMember> getAddCores() 
    {
        return SObjectType.Design__c.FieldSets.Add_Cores.getFields();
    }

    Public List<Schema.FieldSetMember> getAddImage() 
    {
        return SObjectType.Design__c.FieldSets.Add_Image.getFields();
    }
      
    Public List<Schema.FieldSetMember> getAddImagePackage() 
    {
        return SObjectType.Design__c.FieldSets.Add_Image_Package.getFields();
    }

    Public List<Schema.FieldSetMember> getAddInterfaceCircuits() 
    {
        return SObjectType.Design__c.FieldSets.Add_Interface_Circuits.getFields();
    }

    Public List<Schema.FieldSetMember> getAddPackage() 
    {
        return SObjectType.Design__c.FieldSets.Add_Package.getFields();
    }

    Public List<Schema.FieldSetMember> getCircuitDetails() 
    {
        return SObjectType.Design__c.FieldSets.Circuit_Details.getFields();
    }
    Public List<Schema.FieldSetMember> getCreateUser() 
    {
        return SObjectType.Design__c.FieldSets.Create_User_Defined_Custom_Core.getFields();
    }
    Public List<Schema.FieldSetMember> getCreateUserDefined () 
    {
        return SObjectType.Design__c.FieldSets.Create_User_Defined_Custom_Image.getFields();
    }
    Public List<Schema.FieldSetMember> getCreateUserDefinedcustomImg() 
    {
        return SObjectType.Design__c.FieldSets.Create_User_Defined.getFields();
    }
    Public List<Schema.FieldSetMember> getDesignServicesDetails() 
    {
        return SObjectType.Design__c.FieldSets.Design_Services_Details.getFields();
    }
    Public List<Schema.FieldSetMember> getDesignforTestDetails() 
    {
        return SObjectType.Design__c.FieldSets.Design_for_Test_Details.getFields();
    }
    Public List<Schema.FieldSetMember> getEditFeatures() 
    {
        return SObjectType.Design__c.FieldSets.Edit_Features.getFields();
    }
    Public List<Schema.FieldSetMember> getInterfaceCircuits() 
    {
        return SObjectType.Design__c.FieldSets.Interface_Circuits.getFields();
    }
    Public List<Schema.FieldSetMember> getPowerSupply() 
    {
        return SObjectType.Design__c.FieldSets.Power_Supply.getFields();
    }
    public List<Schema.FieldSetMember> getVDD1() 
    {
        return SObjectType.Design__c.FieldSets.VDD_1.getFields();
    }
    public List<Schema.FieldSetMember> getVDD2() 
    {
        return SObjectType.Design__c.FieldSets.VDD_2.getFields();
    }
    public List<Schema.FieldSetMember> getVDD3() 
    {
        return SObjectType.Design__c.FieldSets.VDD_3.getFields();
    }
    public List<Schema.FieldSetMember> getVDD4() 
    {
        return SObjectType.Design__c.FieldSets.VDD_4.getFields();
    }
    public List<Schema.FieldSetMember> getVDD5() 
    {
        return SObjectType.Design__c.FieldSets.VDD_5.getFields();
    }
    public List<Schema.FieldSetMember> getVDD6() 
    {
        return SObjectType.Design__c.FieldSets.VDD_6.getFields();
    }
    Public List<Schema.FieldSetMember> getImageDetails() 
    {
        return SObjectType.Design__c.FieldSets.Image_Details.getFields();
    }
    Public List<Schema.FieldSetMember> getActiveSideC4Details() 
    {
        return SObjectType.Design__c.FieldSets.Active_Side_C4_Details.getFields();
    }
    Public List<Schema.FieldSetMember> getActiveSideCapturePadDetails() 
    {
        return SObjectType.Design__c.FieldSets.Active_Side_Capture_Pad_Details.getFields();
    }
    Public List<Schema.FieldSetMember> getFileCheckIn() 
    {
        return SObjectType.Design__c.FieldSets.File_Check_In.getFields();
    }
    Public List<Schema.FieldSetMember> getMemorySummary() 
    {
        return SObjectType.Design__c.FieldSets.Memory_Summary.getFields();
    }
    Public List<Schema.FieldSetMember> getSRAMDetails() 
    {
        return SObjectType.Design__c.FieldSets.SRAM_Details.getFields();
    }
    Public List<Schema.FieldSetMember> getEmbeddedDRAMDetails() 
    {
        return SObjectType.Design__c.FieldSets.Embedded_DRAM_Details.getFields();
    }
    Public List<Schema.FieldSetMember> getDesignMethodology() 
    {
        return SObjectType.Design__c.FieldSets.Design_Methodology.getFields();
    }
    Public List<Schema.FieldSetMember> getDesignDetails() 
    {
        return SObjectType.Design__c.FieldSets.Design_Details.getFields();
    }
    Public List<Schema.FieldSetMember> getGroundruleWaivers() 
    {
        return SObjectType.Design__c.FieldSets.Groundrule_Waivers.getFields();
    }
    Public List<Schema.FieldSetMember> getSelecteDRAMs() 
    {
        return SObjectType.Design__c.FieldSets.Select_eDRAMs.getFields();
    }
    /**
    *  @Description <The purpose of this method is to load WaferData object FieldSets> 
    *  @name <getAdditionalactivesidewaferprocessing>
    *  @param <> <>
    *  @return <List<Schema.FieldSetMember> - <Returns the fieldset member in WaferData Object>
    *  @throws exception-<>
    */ 
    Public List<Schema.FieldSetMember> getAdditionalactivesidewaferprocessing() 
    {
        return SObjectType.Wafer_Data__c.FieldSets.Additional_active_side_wafer_processing.getFields();
    }
    Public List<Schema.FieldSetMember> getActiveSideInterconnectDetails() 
    {
        return SObjectType.Wafer_Data__c.FieldSets.Active_Side_Interconnect_Details.getFields();
    }
    Public List<Schema.FieldSetMember> getActiveSideC4Detailswf() 
    {
        return SObjectType.Wafer_Data__c.FieldSets.Active_Side_C4_Details.getFields();
    }
    Public List<Schema.FieldSetMember> getInterconnectDetails() 
    {
        return SObjectType.Wafer_Data__c.FieldSets.Interconnect_Details.getFields();
    }
    Public List<Schema.FieldSetMember> getAdditionalbacksidewaferprocessing() 
    {
        return SObjectType.Wafer_Data__c.FieldSets.Additional_back_side_wafer_processing.getFields();
    }
    Public List<Schema.FieldSetMember> getBackSideInterconnectDetails() 
    {
        return SObjectType.Wafer_Data__c.FieldSets.Back_Side_Interconnect_Details.getFields();
    }
    Public List<Schema.FieldSetMember> getWaferDetails() 
    {
        return SObjectType.Wafer_Data__c.FieldSets.Wafer_Details.getFields();
    }
    Public List<Schema.FieldSetMember> getTestDetails() 
    {
        return SObjectType.Wafer_Data__c.FieldSets.Test_Details.getFields();
    }
    Public List<Schema.FieldSetMember> getAdditionalwaferprocessing() 
    {
        return SObjectType.Wafer_Data__c.FieldSets.Additional_wafer_processing.getFields();
    }
    /**
    *  @Description <The purpose of this method is to load ChipData object FieldSets> 
    *  @name <getParametersPartNumberIdentification>
    *  @param <> <>
    *  @return <List<Schema.FieldSetMember> - <Returns the fieldset member in ChipData Object>
    *  @throws exception-<>
    */
    Public List<Schema.FieldSetMember> getParametersPartNumberIdentification() 
    {
        return SObjectType.Chip_Data__c.FieldSets.Identification.getFields();
    }
    Public List<Schema.FieldSetMember> getPhysicalDimensions() 
    {
        return SObjectType.Chip_Data__c.FieldSets.Physical_Dimensions.getFields();
    }
    Public List<Schema.FieldSetMember> getChipInterconnect() 
    {
        return SObjectType.Chip_Data__c.FieldSets.Chip_Interconnect.getFields();
    }
    public List<Schema.FieldSetMember> getGeneral() 
    {
        return SObjectType.Chip_Data__c.FieldSets.General.getFields();
    }
    Public List<Schema.FieldSetMember> getDocumentation() 
    {
        return SObjectType.Chip_Data__c.FieldSets.Documentation.getFields();
    }
    Public List<Schema.FieldSetMember> getInformation() 
    {
        return SObjectType.Chip_Data__c.FieldSets.Information.getFields();
    }
    Public List<Schema.FieldSetMember> getChip2D() 
    {
        return SObjectType.Chip_Data__c.FieldSets.X2D_2_5D_3D.getFields();
    }
    /**
    *  @Description <The purpose of this method is to load ModuleData object FieldSets> 
    *  @name <getCapLid>
    *  @param <> <>
    *  @return <List<Schema.FieldSetMember> - <Returns the fieldset member in ModuleData Object>
    *  @throws exception-<>
    */
    Public List<Schema.FieldSetMember> getCapLid() 
    {
        return SObjectType.Module_Data__c.FieldSets.Cap_Lid.getFields();
    }
    Public List<Schema.FieldSetMember> getDiscreteComponents() 
    {
        return SObjectType.Module_Data__c.FieldSets.Discrete_Components.getFields();
    }
    Public List<Schema.FieldSetMember> getModuleDetails() 
    {
        return SObjectType.Module_Data__c.FieldSets.Module_Details.getFields();
    }
    Public List<Schema.FieldSetMember> getMCM() 
    {
        return SObjectType.Module_Data__c.FieldSets.MCM.getFields();
    }
    public List<Schema.FieldSetMember> getModule2D()
    {
        return SObjectType.Module_Data__c.FieldSets.X2D_2_5D_3D.getFields();
    }
    /**
    *  @Description <The purpose of this method is to load PackageData object FieldSets> 
    *  @name <getBottomSurfaceDetails>
    *  @param <> <>
    *  @return <List<Schema.FieldSetMember> - <Returns the fieldset member in PackageData Object>
    *  @throws exception-<>
    */
    Public List<Schema.FieldSetMember> getBottomSurfaceDetails() 
    {
        return SObjectType.Package_Data__c.FieldSets.Bottom_Surface_Details.getFields();
    }

    Public List<Schema.FieldSetMember> getBuildupLayerDetails() 
    {
        return SObjectType.Package_Data__c.FieldSets.Build_up_Layer_Details.getFields();
    }
        
    Public List<Schema.FieldSetMember> getCoreLayerDetails() 
    {
        return SObjectType.Package_Data__c.FieldSets.Core_Layer_Details.getFields();
    }

    Public List<Schema.FieldSetMember> getGeneralPackage() 
    {
        return SObjectType.Package_Data__c.FieldSets.General_Package.getFields();
    }
    Public List<Schema.FieldSetMember> getGeneralPackageDetails() 
    {
        return SObjectType.Package_Data__c.FieldSets.General_Package_Details.getFields();
    }
    Public List<Schema.FieldSetMember> getMLCLayerDetails() 
    {
        return SObjectType.Package_Data__c.FieldSets.MLC_Layer_Details.getFields();
    }
    Public List<Schema.FieldSetMember> getOtherInformation() 
    {
        return SObjectType.Package_Data__c.FieldSets.Other_Information.getFields();
    }
    Public List<Schema.FieldSetMember> getPackageChipSiteDetails() 
    {
        return SObjectType.Package_Data__c.FieldSets.Package_Chip_Site_Details.getFields();
    }
    Public List<Schema.FieldSetMember> getPackagePNDetails() 
    {
        return SObjectType.Package_Data__c.FieldSets.Package_PN_Details.getFields();
    }
    Public List<Schema.FieldSetMember> getPackageServices() 
    {
        return SObjectType.Package_Data__c.FieldSets.Package_Services.getFields();
    }
    Public List<Schema.FieldSetMember> getTopSurfaceDetails() 
    {
        return SObjectType.Package_Data__c.FieldSets.Top_Surface_Details.getFields();
    }
    Public List<Schema.FieldSetMember> getPackage2D() 
    {
        return SObjectType.Package_Data__c.FieldSets.X2D_2_5D_3D.getFields();
    }
    /**
    *  @Description <The purpose of this method is to edit the Service data> 
    *  @name <IsServiceEdit>
    *  @param <> <>
    *  @return <> - <>
    *  @throws exception-<>
    */
    Public Void IsServiceEdit()
    {
        IsSaveVisible = true;
        IsEditVisible = false;
        ServiceInputFieldSet = true;
        ServiceOutPutFieldSet = false;
        IsCancelVisible = true;
    }    
    /**
    *  @Description <The purpose of this method is to edit the Wafer data> 
    *  @name <IsWaferEdit>
    *  @param <> <>
    *  @return <> - <>
    *  @throws exception-<>
    */
    Public Void IsWaferEdit()
    {
        IsSaveWaferVisible = true;
        IsEditWaferVisible = false;
        WaferInput = true;
        WaferOutPut = false;
        IsCancelwaferVisible = true;
    } 
    /**
    *  @Description <The purpose of this method is to edit the Chip data> 
    *  @name <IsChipEdit>
    *  @param <> <>
    *  @return <> - <>
    *  @throws exception-<>
    */
    Public Void IsChipEdit()
    {
        IsSaveChipVisible = true;
        IsEditChipVisible = false;
        ChipInput = true;
        ChipOutput = false;
        IsCancelChipVisible = true; 
    }  
    /**
    *  @Description <The purpose of this method is to edit the Module data> 
    *  @name <IsModuleEdit>
    *  @param <> <>
    *  @return <> - <>
    *  @throws exception-<>
    */
    Public Void IsModuleEdit()
    {
        IsSaveModuleVisible = true;
        IsEditModuleVisible = false;
        ModuleInput = true;
        ModuleOutput = false;
        IsCancelModuleVisible= true;
    }  
    /**
    *  @Description <The purpose of this method is to edit the Package data> 
    *  @name <IsPackageEdit>
    *  @param <> <>
    *  @return <> - <>
    *  @throws exception-<>
    */
    Public Void IsPackageEdit()
    {
        IsSavePackageVisible = true;
        IsEditPackageVisible = false;
        PackageInput = true;
        PackageOutput = false; 
        IsCancelPackageVisible = true;      
    }  
     /**
    *  @Description <The purpose of this method is to edit the Design data> 
    *  @name <IsDesignEdit>
    *  @param <> <>
    *  @return <> - <>
    *  @throws exception-<>
    */
    Public Void IsDesignEdit()
    {
        IsSaveDesignVisible = true;
        IsEditDesignVisible = false;
        DesignInput = true;
        DesignOutput = false;
        IsCancelDesignVisible = true;
    }
     /**
    *  @Description <The purpose of this method is to visible for Service,Wafer,Chip,Module,Package,Design Data > 
    *  @name <DeliverableTypeVisible>
    *  @param <> <>
    *  @return <> - <>
    *  @throws exception-<>
    */
    Public Void DeliverableTypeVisible()
    {
          DeliverableTypedisable = false;   
          //Section Save& Edit,Cancel Visible  for Service,Wafer,Chip,Module,Package,Design         
          IsSaveVisible  = true; 
          IsEditVisible  = false;
          IsCancelVisible = true;
          IsSaveWaferVisible = true;
          IsEditWaferVisible = false;
          ButtonTextWafer = 'Save';
          IsCancelwaferVisible = true;
          IsSaveChipVisible = true;
          IsEditChipVisible = false;
          ButtonTextChip = 'Save';
          IsCancelChipVisible = true;
          IsSaveModuleVisible = true;
          IsEditModuleVisible = false;
          ButtonTextModule = 'Save';
          IsCancelModuleVisible = true;
          IsSavePackageVisible = true;
          IsEditPackageVisible = false;
          ButtonTextPackage = 'Save';
          IsCancelPackageVisible = true;
          IsSaveDesignVisible = true;
          IsEditDesignVisible = false;
          ButtonTextDesign = 'Save';
          IsCancelDesignVisible = true;
    }   
     /**
    *  @Description <The purpose of this method is to update Service,Wafer,Chip,Module,Package,Design Data > 
    *  @name <UpdateTRWithDT>
    *  @param <> <>
    *  @return <> - <>
    *  @throws exception-<>
    */
    public void UpdateTRWithDT()
    {
     try 
        {
            Customer_Requirement__c cr = new Customer_Requirement__c();
            cr.id=ApexPages.currentPage().getParameters().get('Id');
            cr.Deliverable_Type__c =selectDeliverabletype;
            update cr;
        }   
         catch(Exception excp)
        {           
            GlobalUtility.logMessage('Error','BnP_OptionDeliverableTypeCtrl','UpdateTRWithDT','','Exception while Updating DeliverableType',String.valueof(excp.getMessage()),'','BnP',excp,0);
        }                      
    } 
    /**
    *  @Description <The purpose of this method is to select the DeliverableType Options in BnP_OptionDeliverableType> 
    *  @name <LoadDeliverableTypeOptions>
    *  @param <> <>
    *  @return <> - <>
    *  @throws exception-<>
    */  
    public void LoadDeliverableTypeOptions()
    {
        Customer_Requirement__c TR = new Customer_Requirement__c();
        TR = [Select Opportunity_Contract_Pricing__c, Chip_Option__c,isTCA__c From Customer_Requirement__c where Id =: ApexPages.currentPage().getParameters().get('Id') Limit 1];
        DeliverableType = new List<SelectOption>(); 
        DeliverableType.add(new SelectOption('','--None--'));
        DeliverableType.add(new SelectOption('Service','Service'));
        DeliverableType.add(new SelectOption('Wafer','Wafer'));
        DeliverableType.add(new SelectOption('Chip','Chip'));
        if(TR.Opportunity_Contract_Pricing__c == 'No')
        {
          DeliverableType.add(new SelectOption('Module','Module'));
        } 
        DeliverableType.add(new SelectOption('Design','Design'));
        //Load the Chip Option Value
        getChipOptionInfo(TR.isTCA__c);
        
   }
   /**
    *  @Description <The purpose of this method is to return the current opportunity stage associated with the option> 
    *  @name <currentOpportunityStage>
    *  @param <> <>
    *  @return <> - <>
    *  @throws exception-<>
    */  
   public string currentOpportunityStage()
   {
       Customer_Requirement__c objCR = new Customer_Requirement__c();
       objCR = [Select Opportunity_Stage__c from Customer_Requirement__c where Id=: ApexPages.currentPage().getParameters().get('Id') Limit 1];       
       return objCR.Opportunity_Stage__c;
   }
   /**
    *  @Description <The purpose of this method is to select the Chip Option and displaying message in Vf Page "BnP_OptionDeliverableType"> 
    *  @name <getChipOptionInfo>
    *  @param <chipOption> <>
    *  @return <> - <>
    *  @throws exception-<>
    */  
   public void getChipOptionInfo(string chipOption)
   {      
       if(chipOption == 'No')
       {
           isMCM = true;
           chipOptionSelection = 'MCM(Multi Chip Module) Option';           
       }
       else
       {
           isMCM = false;
           chipOptionSelection = 'SCM(Single Chip Module) Option';
       }
   } 
    /**
    *  @Description <The purpose of this method is to display the information message based on selected Deliverable type> 
    *  @name <DeliverableTypeMessage>
    *  @param <> <>
    *  @return <> - <>
    *  @throws exception-<>
    */ 
   Public PageReference DeliverableTypeMessage()
   {
     //showDelTypemessage = true;
  
     if(selectDeliverabletype == 'Chip' &&  Chp.id == NULL)
      {
        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,errorMessages.get('OPTION_CHIP_ERROR').Message__c));
      }
     else if(selectDeliverabletype == 'Module' &&  Modul.id == NULL)
      {
        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,errorMessages.get('OPTION_MODULE_ERROR').Message__c));
      }
     return null;
   } 
   /**
    *  @Description <The purpose of this method is Based on selectDeliverabletype Export the Deliverabletype informastions> 
    *  @name <doClick>
    *  @param <> <>
    *  @return <PageReference> - <>
    *  @throws exception-<>
    */ 
   public PageReference doClick() 
   {
   
       Customer_Requirement__c Optionsnew= new Customer_Requirement__c();
       Optionsnew = [Select Id,Name,Deliverable_Type__c From Customer_Requirement__c where Id =: ApexPages.currentPage().getParameters().get('Id')];
       selectDeliverabletype =Optionsnew.Deliverable_Type__c;

     if(selectDeliverabletype == null || selectDeliverabletype == '')
       {
           ShowExport = true;
           return null;
       }
     else
      {
         return Page.BnP_ExportDeliverableType.setRedirect(false);
      } 
   }
   
   public boolean getOptionValueforTFF()
   {
       Customer_Requirement__c objCR = new Customer_Requirement__c();
       objCR = [Select Product_Type__c, MD_Part_Number__c, End_customer_project__c, Customer_part_name__c,
                MD_part_name__c, Option_Stage__c, If_ITAR_is_Yes_ITAR_Category__c, If_ITAR_is_Yes_Applicable_Suffixes__c, 
                ITAR_Flow_Evaluation__c,ITAR_Flow_Evaluation_New__c, Brand_and_Sub_brand__c, RIT_Type__c, Hazardous_use__c, Is_ITAR__c, Opportunity__c, Device__c 
                from Customer_Requirement__c where Id=: ApexPages.currentPage().getParameters().get('Id') Limit 1]; 

      opportunity objOpportunity = new opportunity();
      objOpportunity = [SELECT Id, Design_Win_Region__c, Design_Win_Territory__c, DPAS_Rating__c, CloseDate, 
                        Sum_of_Quarterly_Revenue__c, Deal_Grading_Status__c, Product_Line__c FROM opportunity where Id =: objCR.Opportunity__c Limit 1];
                        
       Device__c objDevice = new Device__c();
       objDevice = [SELECT Id,Device_Purpose__c,Project_Name__c, Device_Sourcing__c, Automotive_Device__c 
                    FROM Device__c where Id =: objCR.Device__c Limit 1];
                          
       if(objCR.End_customer_project__c != null && objCR.MD_part_name__c != null && objCR.Brand_and_Sub_brand__c != null && objCR.RIT_Type__c != null 
          && objCR.Hazardous_use__c != null &&  objOpportunity.Design_Win_Region__c != null && objOpportunity.Design_Win_Territory__c != null 
          && objOpportunity.CloseDate != null && objOpportunity.Sum_of_Quarterly_Revenue__c != null 
          && objDevice.Device_Purpose__c != null && objDevice.Project_Name__c != null && objDevice.Device_Sourcing__c != null)
       {          
           if(objOpportunity.Product_Line__c == 'ASIC' || objOpportunity.Product_Line__c == 'SiPh')
           {
                if(objOpportunity.Deal_Grading_Status__c != null)
                {
                    return true;
                }
                else
                {
                    return false;
                }
           }
           else
           {
                return true;
           }
                              
       }
       else
       {
           return false;
       }
   }

    public string prapareValidationmsg()
    {
        ValidationMsg = 'Below Fields are required to add Deliverable Type : ' +  '<br/>';
        ValidationMsg = ValidationMsg + '1. Option :GF Part Name <br/>';
        ValidationMsg = ValidationMsg + '2. Option :End customer project <br/>';
        ValidationMsg = ValidationMsg + '3. Option :RIT Type <br/>';
        ValidationMsg = ValidationMsg + '4. Option :Hazardous use? <br/>';
        ValidationMsg = ValidationMsg + '5. Option :Brand and Sub-brand <br/>';
        ValidationMsg = ValidationMsg + '6. Device :Device Purpose <br/>';
        ValidationMsg = ValidationMsg + '7. Device :Project Name <br/>';
        ValidationMsg = ValidationMsg + '8. Device :Device Sourcing <br/>';
        ValidationMsg = ValidationMsg + '9. Opportunity :Design Win Region <br/>';
        ValidationMsg = ValidationMsg + '10.Opportunity : Design Win Territory <br/>';
        ValidationMsg = ValidationMsg + '11.Opportunity :Close Date <br/>';
        ValidationMsg = ValidationMsg + '12.Opportunity :Sum of Quarterly Revenue <br/>';
        ValidationMsg = ValidationMsg + '13.Opportunity :Deal Grading Status (for ASIC and SiPh product line only)<br/>';
        
        return ValidationMsg;
    }
}