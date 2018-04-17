/**
* @author       :   Sushumna Mulugu
* Company       :   Cognizant Technologies PTE Ltd.
* Description   :   Functionality to run the CE Report and allow the user to
*                   save changes to Device and publish the report and send email
* History       :

        Initials        Date                Description
-----------------------------------------------------------------------------------------
        SMulugu         27/05/2013          Created the Class
        BMohan          27/05/2013          Created the Method btnClickEmailPdf & btnClickPublishToTeamRoom
        BMukhija        26/06/2013          Updated populateTabs method for adding sorting functionality.
        BMukhija        26/06/2013          Updated btnClickPublishToTeamRoom method for adding Error Messages in Custom
                                            settings and change severity for Page Messages.
        SMulugu         27/06/2013          Changes as per Parveen's Email.
        ASinghal        30/07/2013          Changes done as part of Case 00001643 to remove Publishto Field Mapping and add Attn To field mapping  from manualDevice to Device.
        Asinghal        31/07/2013          Changes done for Adding Mgmt Export Filter field as search criteria
        Asinghal        31/07/2013          Changes done to include Pagination buttons on top section of tabs
        Asinghal        14/08/2013          Changes Done to store Raw Files in a separate folder for records with or without Export Flag
        Asinghal        16/08/2013          Changes Done to dynamically change pagesize on CE Weekly Report
**/
public class ManualDeviceCEReportExtension{

    /* Variables */
    transient List<Manual_Device__c> lManualDevice { get; set; }
    public Boolean noError { get ; set; }
    public List<Manual_Device__c> T1 { get; set;}
    public List<Manual_Device__c> T2 { get; set;}
    public List<Manual_Device__c> T3 { get; set;}
    private List<Manual_Device__c> lmDevice = new List<Manual_Device__c>();
    public List<Manual_Device__c> protoRiskList {get; set;}
    public List<Manual_Device__c> productionList {get; set;}
    public List<Manual_Device__c> tapeoutList {get; set;}

    public String tapeCustomer { get; set; }
    public String tapeRegion { get; set; }
    public String tapeDevice { get; set; }
    public String tapeFab { get; set; }
    public String tapeExport {get;set; }
    public String selectedTab {get; set;}

    public String protoCustomer { get; set; }
    public String protoRegion { get; set; }
    public String protoDevice { get; set; }
    public String protoFab { get; set; }
    public String protoExport {get;set;}
    

    public String prodCustomer { get; set; }
    public String prodRegion { get; set; }
    public String prodDevice { get; set; }
    public String prodFab { get; set; }
    public String prodExport{get;set;}
    public Boolean bTeamRoom { get; set; }
    public String Exportflag;
    public Integer recordsize;
    public Integer recordProtosize;
    public Integer recordtapeoutsize;
    
    
     public Integer getrecordTapeoutsize(){
        if(this.recordTapeoutsize == null){
            return 1;
        }else{
        return this.recordTapeoutsize;
        

    }    
    }
    public void SetrecordTapeoutsize(Integer A){
      this.recordTapeoutsize = A;
    } 
     public Integer getrecordProtosize(){
        if(this.recordProtosize == null){
            return 1;
        }else{
        return this.recordProtosize;
        

    }   
    }
    public void SetrecordProtosize(Integer A){
      this.recordProtosize = A;
    } 
        
    public Integer getrecordsize(){
        if(this.recordsize == null){
            return 1;
        }else{
        return this.recordsize;
        

    }   
    }
    public void Setrecordsize(Integer A){
      this.recordsize = A;
    } 

    
    // DECLARATION SET CONTROLLERS FOR ALL TABS
    private ApexPages.StandardSetController setControllerTapeout {get;set;}
    private ApexPages.StandardSetController setControllerProto {get;set;}
    private ApexPages.StandardSetController setControllerProduction {get;set;}

    // TAPEOUT SET CONTROLLER ACTIONS
    public Boolean hasNext {
        get { return setControllerTapeout.getHasNext(); }
        private set;     
    }

    public Boolean hasPrevious {
        get { return setControllerTapeout.getHasPrevious(); }
        private set;
    }

    public void previousTapeout() {
       try {
            setControllerTapeout.previous();
            T1 = setControllerTapeout.getRecords();
       } catch (Exception ex) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Please Save Changes before leaving the Page. Please use Back button on browser to go to Previous Page.'));
            noError = false;           
       }
    }

    public void firstTapeout() {
       try {
            setControllerTapeout.first();
            T1 = setControllerTapeout.getRecords();
       } catch (Exception ex) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Please Save Changes before leaving the Page. Please use Back button on browser to go to Previous Page.'));
            noError = false;           
       }
    }

    public void lastTapeout() {
       try {
            setControllerTapeout.last();
            T1 = setControllerTapeout.getRecords();
       } catch (Exception ex) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Please Save Changes before leaving the Page. Please use Back button on browser to go to Previous Page.'));
            noError = false;           
       }
    }

    public void nextTapeout() {
       try {
            setControllerTapeout.next();
            T1 = setControllerTapeout.getRecords();
       } catch (Exception ex) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Please Save Changes before leaving the Page. Please use Back button on browser to go to Previous Page.'));
            noError = false;           
       }
    }

    public Integer pageNumberTapeout {
        get {
                return setControllerTapeout.getPageNumber(); }
        private set;     
    }

    public Integer totalPagesTapeout {
        get { //double dtotalPages = (setControllerTapeout.getResultSize() / setControllerTapeout.getPageSize());
              //dtotalPages = Math.floor(dtotalPages) + ((Math.mod(setControllerTapeout.getResultSize(), 10) > 0) ? 1 : 0);
              //return Integer.valueOf(dtotalPages); }
              return (Integer) Math.ceil(Double.valueOf(setControllerTapeout.getResultSize()) / setControllerTapeout.getPageSize());
        }
       private set;
    }

    // PROTO SET CONTROLLER ACTIONS
    public Boolean hasNextProto {
        get { return setControllerProto.getHasNext(); }
        private set;     
    }

    public Boolean hasPreviousProto {
        get { return setControllerProto.getHasPrevious(); }
        private set;
    }

    public void previousProto() {
        try {
            setControllerProto.previous();
            T2 = setControllerProto.getRecords();
        } catch (Exception ex) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Please Save Changes before leaving the Page. Please use Back button on browser to go to Previous Page.'));
            noError = false;           
       }
    }

    public void firstProto() {
        try {
            setControllerProto.first();
            T2 = setControllerProto.getRecords();
        } catch (Exception ex) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Please Save Changes before leaving the Page. Please use Back button on browser to go to Previous Page.'));
            noError = false;           
       }
    }

    public void lastProto() {
        try {
            setControllerProto.last();
            T2 = setControllerProto.getRecords();
       } catch (Exception ex) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Please Save Changes before leaving the Page. Please use Back button on browser to go to Previous Page.'));
            noError = false;           
       }
    }

    public void nextProto() {
        try {
            setControllerProto.next();
            T2 = setControllerProto.getRecords();
        } catch (Exception ex) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Please Save Changes before leaving the Page. Please use Back button on browser to go to Previous Page.'));
            noError = false;           
       }
    }

    public Integer pageNumberProto {
        get { return setControllerProto.getPageNumber(); }
        private set;     
    }

    public Integer totalPagesProto {
        get { //double dtotalPages = ( setControllerProto.getResultSize() / setControllerProto.getPageSize());
              //dtotalPages = Math.floor( dtotalPages ) + ( ( Math.mod( setControllerProto.getResultSize(), 10 ) > 0 ) ? 1 : 0);
              
              //return Integer.valueOf( dtotalPages ); }
              return (Integer) Math.ceil(Double.valueOf(setControllerProto.getResultSize()) / setControllerProto.getPageSize());
        }
       private set;
    }
    
    // PRODUCTION SET CONTROLLER ACTIONS
    public Boolean hasNextProduction {
        get { return setControllerProduction.getHasNext(); }
        private set;     
    }

    public Boolean hasPreviousProduction {
        get { return setControllerProduction.getHasPrevious(); }
        private set;
    }

    public void previousProduction() {
        try {
            setControllerProduction.previous();
            T3 = setControllerProduction.getRecords();
        } catch (Exception ex) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Please Save Changes before leaving the Page. Please use Back button on browser to go to Previous Page.'));
            noError = false;           
       }
    }

    public void firstProduction() {
        try {
            setControllerProduction.first();
            T3 = setControllerProduction.getRecords();
        } catch (Exception ex) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Please Save Changes before leaving the Page. Please use Back button on browser to go to Previous Page.'));
            noError = false;           
       }
    }

    public void lastProduction() {
        try {
            setControllerProduction.last();
            T3 = setControllerProduction.getRecords();
        } catch (Exception ex) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Please Save Changes before leaving the Page. Please use Back button on browser to go to Previous Page.'));
            noError = false;           
       }
    }

    public void nextProduction() {
        try {
            setControllerProduction.next();
            T3 = setControllerProduction.getRecords();
        } catch (Exception ex) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Please Save Changes before leaving the Page. Please use Back button on browser to go to Previous Page.'));
            noError = false;           
       }
    }

    public Integer pageNumberProduction {
        get { return setControllerProduction.getPageNumber(); }
        private set;     
    }

    public Integer totalPagesProduction {
        get {
                //double dtotalPages = ( setControllerProduction.getResultSize() / setControllerProduction.getPageSize());
             //dtotalPages = Math.floor( dtotalPages ) + ( ( Math.mod( setControllerProduction.getResultSize(), 10 ) > 0 ) ? 1 : 0);
             //return Integer.valueOf( dtotalPages ); }
             return (Integer) Math.ceil(Double.valueOf(setControllerProduction.getResultSize()) / setControllerProduction.getPageSize());
        }
       private set;
    }

    /***********************************************************
    * Name              : ManualDeviceCEReportExtension
    * Description       : Extensions Constructor
    * Input Parameters  : StandardController
    * Return            : None
    ************************************************************/
    public ManualDeviceCEReportExtension(){
    }
     
    public ManualDeviceCEReportExtension(ApexPages.StandardController controller) {
         /* Inserting all the Manual Device records on Page Load */
        noError = true;
        lManualDevice = new List<Manual_Device__c> () ;
    }

    /***********************************************************
    * Name              : updateManualDevice
    * Description       : Action method to update Manual Device
    * Input Parameters  : None
    * Return            : void
    ************************************************************/
    public void updateManualDevice() {
        try {
            lManualDevice = ManualDeviceHelper.getUpdatedDeviceData();
            bTeamRoom=false;
            Id CRMUserID = [ SELECT Id, Name
                             FROM User
                             WHERE Name =: 'BATCHUSR CRM' ].id;

            List<PermissionSetAssignment> lPermissionSetAssignment = [ SELECT Id 
                                                                        FROM PermissionSetAssignment 
                                                                        WHERE AssigneeId = :UserInfo.getUserId()
                                                                            AND PermissionSetId = :[ SELECT Id
                                                                                                     FROM PermissionSet
                                                                                                     WHERE Name = 'CE_Weekly_Permission_Set'] ];
            
            
            Map<Id,User> lUsers = new Map<Id,User>([ SELECT Id
                                  FROM User
                                  WHERE ProfileId IN :[ SELECT Id 
                                                        FROM Profile 
                                                        WHERE (Name = 'GF System Admin' OR Name = 'System Administrator')] ]);
            Id userID=userinfo.getUserId();
            Boolean IsCurrUsr=lUsers.containskey(userID);                                           
            if (!lPermissionSetAssignment.isEmpty() || IsCurrUsr) {
                bTeamRoom = true;
            }
            for ( Manual_Device__c mdVar : lManualDevice ) {
                mdVar.OwnerId = CRMUserID;
            }


            upsert lManualDevice Id;


            lManualDevice.clear();


            lManualDevice = ManualDeviceHelper.getUpdateManualDeviceData();
            
            populateTabs();
        } catch ( Exception ex ) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, ex.getMessage()));
            noError = false;
        }
    }
    
    
    public Void refreshpagesize(){
    getlist3();
    totalpagesproduction= (Integer) Math.ceil(Double.valueOf(setControllerProduction.getResultSize()) / setControllerProduction.getPageSize());






    }
    
    public Void refreshProtopagesize(){
    getlist2();
    totalpagesproto=(Integer) Math.ceil(Double.valueOf(setControllerProto.getResultSize()) / setControllerProto.getPageSize());
    }
    
    public Void refreshTapeoutpagesize(){
    getlist1();
    totalpagestapeout=(Integer) Math.ceil(Double.valueOf(setControllerTapeout.getResultSize()) / setControllerTapeout.getPageSize());
    }






    public List<Manual_Device__c> getList1() {
        T1= new List<Manual_Device__c>( [ Select Yield__c
                                               , Technology__c
                                               , Status__c
                                               , Region__c
                                               , Account_Name__c
//                                               , Publish_Report__c
                                               , Proto_Functional_Status__c
                                               , Project_Update__c
                                               , Process_Family__c
                                               , Prime_Die__c
                                               , Device__r.Actual_Tapeout_Date_GMT__c
                                               , IsActive__c
                                               , Geometry__c
                                               , Forecast_GDSII_In__c
                                               , Forecast_1st_3_reticle_Lot_Start__c
                                               , Fab__c
                                               , Export__c
                                               , ET_Met_Target__c
                                               , Device__c
                                               , Device_Id__c
                                               , Attn_To__c
                                               , Account__c
                                            FROM Manual_Device__c
                                            WHERE IsActive__c = true
                                                AND Publish_Report__c =: Label.GF_CE_Yes
                                                AND Status__c =: Label.GF_CE_Tapeout
                                                ORDER BY Forecast_GDSII_In__c ASC]);
      
        setControllerTapeout = new ApexPages.StandardSetController(T1);
        if(recordTapeoutsize != null){        
            setControllerTapeout.setPageSize(recordTapeoutsize);
        }else{
            setControllerTapeout.setPageSize(10);
        }
        setControllerTapeout.setPageNumber(1);
        T1.clear();
        T1 = setControllerTapeout.getRecords();
        
        return T1;
    }

    public List<Manual_Device__c> getList2(){
        T2 = new List<Manual_Device__c>([   Select Yield__c
                                              , Technology__c
                                              , Status__c
                                              , Region__c
                                              , Account_Name__c
//                                              , Publish_Report__c
                                              , Proto_Functional_Status__c
                                              , Project_Update__c
                                              , Process_Family__c
                                              , Prime_Die__c
                                              , Device__r.Actual_Tapeout_Date_GMT__c
                                              , IsActive__c
                                              , Geometry__c
                                              , Forecast_GDSII_In__c
                                              , Forecast_1st_3_reticle_Lot_Start__c
                                              , Fab__c
                                              , Export__c
                                              , ET_Met_Target__c
                                              , Device__c
                                              , Device_Id__c
                                              , Attn_To__c
                                              , Account__c
                                            FROM Manual_Device__c 
                                            WHERE IsActive__c = true
                                                AND Publish_Report__c =: Label.GF_CE_Yes

                                                AND Status__c =: Label.GF_CE_Proto_Risk_Production

                                                ORDER BY Fab__c, Account_Name__c ASC]);                                                                                   
        
        setControllerProto = new ApexPages.StandardSetController(T2);
        if(recordProtosize != null){        
            setControllerProto.setPageSize(recordProtosize);
        }else{
            setControllerProto.setPageSize(10);
        }
        setControllerProto.setPageNumber(1);
        T2.clear();
        T2 = setControllerProto.getRecords();
                
        return T2;                                                               
    }
    
    public List<Manual_Device__c> getList3() {
         T3 = new List<Manual_Device__c>( [ SELECT Yield__c
                                                 , Technology__c
                                                 , Status__c
                                                 , Region__c
                                                 , Account_Name__c
//                                                 , Publish_Report__c
                                                 , Proto_Functional_Status__c
                                                 , Project_Update__c
                                                 , Process_Family__c
                                                 , Prime_Die__c
                                                 , Device__r.Actual_Tapeout_Date_GMT__c
                                                 , IsActive__c
                                                 , Geometry__c
                                                 , Forecast_GDSII_In__c
                                                 , Forecast_1st_3_reticle_Lot_Start__c
                                                 , Fab__c
                                                 , Export__c
                                                 , ET_Met_Target__c
                                                 , Device__c
                                                 , Device_Id__c
                                                 , Attn_To__c
                                                 , Account__c
                                            FROM Manual_Device__c
                                            WHERE IsActive__c = true
                                                AND Publish_Report__c =: Label.GF_CE_Yes
                                                AND Status__c =: Label.GF_CE_Production

                                                ORDER BY Fab__c, Account_Name__c ASC]);
        setControllerProduction = new ApexPages.StandardSetController(T3);

       if(recordsize != null){        
            setControllerProduction.setPageSize(recordsize);
        }else{
            setControllerProduction.setPageSize(10);
        }
        setControllerProduction.setPageNumber(1);
        T3.clear();
        T3 = setControllerProduction.getRecords();

        return T3;
    }
    
    public void populateTabs () {
        T1 =  getList1();
        T2 =  getList2();
        T3 =  getList3();
        // ManualDeviceHelper.sortList(T1, 'Fab__c', 'asc');
        // ManualDeviceHelper.sortList(T2, 'Fab__c', 'asc');
        // ManualDeviceHelper.sortList(T3, 'Fab__c', 'asc');
    }

    /***********************************************************
    * Name              : updateManualDevice
    * Description       : Action method to update Manual Device
    * Input Parameters  : None
    * Return            : void
    ************************************************************/
    public void save () {
        list <Manual_Device__c>     manualDeviceList    =   new List<Manual_Device__c>();
        list <Device__c>            deviceList          =   new List<Device__c>();
        List<Manual_Device__c>      mDeviceList         =   new List<Manual_Device__c>();

        tapeCustomer = '';
        tapeRegion = '--None--';
        tapeDevice = '';
        tapeFab = '--None--';

        protoCustomer = '';
        protoRegion = '--None--';
        protoDevice = '';
        protoFab = '--None--';

        prodCustomer = '';
        prodRegion = '--None--';
        prodDevice = '';
        prodFab = '--None--';        
        try {

            if (!T3.isEmpty()) {               
                                manualDeviceList.addAll(T3);

                                for ( Manual_Device__c md : T3 ) {
                                                    if ( md.Device__c != null || md.Device__c != '' ) {
                                                    mDeviceList.add(md);
                                                    }
                }
            }

               if ( !T2.isEmpty()) {
                
                manualDeviceList.addAll(T2);

                for ( Manual_Device__c md : T2 ) {
                    if ( md.Device__c != null || md.Device__c != '' ) {
                        mDeviceList.add(md);
                    }
                }
            }

            if ( !T1.isEmpty()) {
                
                manualDeviceList.addAll(T1);

                for ( Manual_Device__c md : T1 ) {
                    if ( md.Device__c != null || md.Device__c != '' ) {
                        mDeviceList.add(md);
                    }
                }
            }
            ManualDeviceHelper.flagSaveReport = true;
            if(!mDeviceList.isEmpty()){
            deviceList = ManualDeviceHelper.convertDeviceFrmManualDevice(mDeviceList);
            }

            if ( !manualDeviceList.isEmpty() ) {
                update ( manualDeviceList );
            }

            if ( !deviceList.isEmpty()) {
                update(deviceList);
            }
            populatetabs();
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM,'Report has been Saved !'));
            
            //populateTabs(ManualDeviceHelper.getUpdateManualDeviceData());
        }
        catch ( exception ex ) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, ex.getMessage()));
        }
    }

    /***********************************************************
    * Name              : clearTapeoutFilters
    * Description       : Returns to the previous page
    * Input Parameters  : None
    * Return            : PageReference
    ************************************************************/
    public void clearTapeoutFilters() {
        T1=getlist1();
        tapeCustomer = '';
        tapeRegion = '--None--';
        tapeDevice = '';
        tapeFab = '--None--';
    }

    /***********************************************************
    * Name              : clearProtoFilters
    * Description       : Returns to the previous page
    * Input Parameters  : None
    * Return            : PageReference
    ************************************************************/
    public void clearProtoFilters() {
        T2=getlist2();
        protoCustomer = '';
        protoRegion = '--None--';
        protoDevice = '';
        protoFab = '--None--';
    }

    /***********************************************************
    * Name              : clearProductionFilters
    * Description       : Returns to the previous page
    * Input Parameters  : None
    * Return            : PageReference
    ************************************************************/
    public void clearProductionFilters() {
        T3=getList3();
        prodCustomer = '';
        prodRegion = '--None--';
        prodDevice = '';
        prodFab = '--None--';
    }

    /***********************************************************
    * Name              : filterTapeout
    * Description       : Returns to the previous page
    * Input Parameters  : None
    * Return            : PageReference
    ************************************************************/
    public void filterTapeout() {
        String Query1='Select Yield__c,Technology__c,Status__c,Region__c, '
            +'Account_Name__c,Publish_Report__c,Proto_Functional_Status__c,'
            +'Project_Update__c,Process_Family__c,Prime_Die__c,Device__r.Actual_Tapeout_Date_GMT__c, '
            +'Geometry__c,Forecast_GDSII_In__c,Forecast_1st_3_reticle_Lot_Start__c, '
            +'Fab__c,Export__c,ET_Met_Target__c,Device__c,Device_Id__c,Attn_To__c,Account__c '
            +'From Manual_Device__c where IsActive__c = true and Publish_Report__c = \'' + Label.GF_CE_Yes+ '\''
            +' and Status__c = \'' + Label.GF_CE_Tapeout+ '\'';
                                                                                   
        if((tapeCustomer != null) || (tapeCustomer != '')){
            Query1 = Query1+' and Account_Name__c like \'%' + tapeCustomer+ '%\'';    
        }
        
        if(taperegion!='None') {
            Query1=Query1 + ' and Region__c= \''+tapeRegion+ '\'';
        }
        
        if(tapeFab != 'None') {
            Query1=Query1+' and Fab__c = \'' + tapeFab+ '\'' ; 
        }
        
        if((tapedevice!=null) || (tapeDevice !='')) {
            //String devicelike='%'+tapedevice+'%';
            Query1=Query1+' and Device_Id__c like \'%' + tapedevice+ '%\'';
        }

        if(tapeExport!='None'){
            if(tapeExport=='Yes'){
            Exportflag='true';
            }else if(tapeExport=='No'){
            Exportflag='false';
            }
            Query1=Query1+' and Export__c = ' +Exportflag;
            }
            Query1 = Query1+ ' ORDER BY Forecast_GDSII_In__c ASC ';
        T1 = database.query(Query1);
        if (T1.isEmpty()) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, ManualDeviceConstants.MDEVICE_NO_RESULTS));
        }

        setControllerTapeout = new ApexPages.StandardSetController(T1);
         if(recordTapeoutsize != null){        
            setControllerTapeout.setPageSize(recordTapeoutsize);
        }else{
            setControllerTapeout.setPageSize(10);
        }
        setControllerTapeout.setPageNumber(1);
        T1.clear();
        T1 = setControllerTapeout.getRecords();
    }

    /***********************************************************
    * Name              : filterProto
    * Description       : Returns to the previous page
    * Input Parameters  : None
    * Return            : PageReference
    ************************************************************/
        public void filterProto() {
                 String Query1='Select Yield__c,Technology__c,Status__c,Region__c, '
                              +'Account_Name__c,Publish_Report__c,Proto_Functional_Status__c,'
                              +'Project_Update__c,Process_Family__c,Prime_Die__c,Device__r.Actual_Tapeout_Date_GMT__c, '
                              +'Geometry__c,Forecast_GDSII_In__c,Forecast_1st_3_reticle_Lot_Start__c, '
                              +'Fab__c,Export__c,ET_Met_Target__c,Device__c,Device_Id__c,Attn_To__c,Account__c '
                              +'From Manual_Device__c where IsActive__c = true and Publish_Report__c = \'' + Label.GF_CE_Yes+ '\''
                              +' and Status__c = \'' + Label.GF_CE_Proto_Risk_Production+ '\'';
                                                                                   
               if((protoCustomer!= null) || (protoCustomer!= '')){
                   // String tapelike = '%'+ protoCustomer +'%';
                    Query1 = Query1+' and Account_Name__c like \'%' + protoCustomer + '%\'';    
               }
               if( protoRegion!='None')
                {
                    Query1=Query1 + ' and Region__c= \''+ protoRegion + '\'';     
                }
               if((protoFab!= 'None')){
                Query1=Query1+' and Fab__c = \'' + protoFab+ '\'' ; 
                }
                if((protoDevice!=null) || (protoDevice!='')){
                //String devicelike='%'+tapedevice+'%';
                Query1=Query1+'and Device_Id__c like \'%' + protoDevice + '%\'';
            }
            if(protoExport!='None'){
            if(protoExport=='Yes'){
            Exportflag='true';
            }else if(protoExport=='No'){
            Exportflag='false';
            }
            Query1=Query1+' and Export__c = ' + Exportflag;
            }
            
            Query1 += ' ORDER BY Fab__c, Account_Name__c ASC ';
            T2 = database.query(Query1);
            
            if ( T2.isEmpty()) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, ManualDeviceConstants.MDEVICE_NO_RESULTS));
            }
            
        setControllerProto = new ApexPages.StandardSetController(T2);
         if(recordProtosize != null){        
            setControllerProto.setPageSize(recordProtosize);
        }else{
            setControllerProto.setPageSize(10);
        }
        setControllerProto.setPageNumber(1);
        T2.clear();
        T2 = setControllerProto.getRecords();
    }


    /***********************************************************
    * Name              : filterProduction
    * Description       : 
    * Input Parameters  : None
    * Return            : Void
    ************************************************************/
    public void filterProduction() {

                 String Query1='Select Yield__c,Technology__c,Status__c,Region__c, '
                              +'Account_Name__c,Publish_Report__c,Proto_Functional_Status__c,'
                              +'Project_Update__c,Process_Family__c,Prime_Die__c,Device__r.Actual_Tapeout_Date_GMT__c, '
                              +'Geometry__c,Forecast_GDSII_In__c,Forecast_1st_3_reticle_Lot_Start__c, '
                              +'Fab__c,Export__c,ET_Met_Target__c,Device__c,Device_Id__c,Attn_To__c,Account__c '
                              +'From Manual_Device__c where IsActive__c = true and Publish_Report__c = \'' + Label.GF_CE_Yes+ '\''
                              +' and Status__c = \'' + Label.GF_CE_Production+ '\'';
                                                                                   
               if((prodCustomer!= null) || (prodCustomer!= '')){
                   // String tapelike = '%'+ prodCustomer +'%';
                    Query1 = Query1+' and Account_Name__c like \'%' + prodCustomer + '%\'';    
               }
               if(prodRegion!='None')
                {
                    Query1=Query1 + ' and Region__c= \''+ prodRegion + '\'';     
                }
            if(prodFab!= 'None'){
                Query1=Query1+' and Fab__c = \'' + prodFab + '\'' ; 
            }
            if((prodDevice!=null) || (prodDevice!='')){
                //String devicelike='%'+ prodDevice +'%';
                Query1=Query1+' and Device_Id__c like \'%' + prodDevice + '%\'';
            }
            if(prodExport!='None'){
            if(prodExport=='Yes'){
            Exportflag='true';
            }else if(prodExport=='No'){
            Exportflag='false';
            }
            Query1=Query1+' and Export__c = ' + Exportflag ;
            }
            
            Query1 += ' ORDER BY Fab__c, Account_Name__c ASC ';
            T3 = database.query(Query1);
            if ( T3.isempty()) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, ManualDeviceConstants.MDEVICE_NO_RESULTS));
            }
                
        setControllerProduction = new ApexPages.StandardSetController(T3);

         if(recordsize != null){        
            setControllerProduction.setPageSize(recordsize);
        }else{
            setControllerProduction.setPageSize(10);
        }
        setControllerProduction.setPageNumber(1);
        T3.clear();
        T3 = setControllerProduction.getRecords();
    }

    /***********************************************************
    * Name              : returnPage
    * Description       : Returns to the previous page
    * Input Parameters  : None
    * Return            : PageReference
    ************************************************************/
    public pageReference returnPage(){
        pageReference cancel =  new PageReference ('/apex/DeviceCEWeekly');
        cancel.setRedirect(true);
        return (cancel);
    }

    /***********************************************************
    * Name              : returnPage
    * Description       : Returns to the previous page
    * Input Parameters  : None
    * Return            : PageReference
    ************************************************************/
    public pageReference backPage(){
        pageReference cancel =  new PageReference ('/home/home.jsp');
        cancel.setRedirect(true);
        return (cancel);
    }
    
    /***********************************************************
    * Name              : btnClickPublishToTeamRoom
    * Description       : On button click attach the page content as pdf in the Team Room
    * Input Parameters  : null
    * Return            : pageReference
    ************************************************************/
    public PageReference btnClickPublishToTeamRoom(){
        PageReference pageRef;
        Map<PageReference,String> tabPageNameList = new Map<PageReference,String>();
        Map<PageReference,String> tabrawPageNameList = new Map<PageReference,String>();
        pageRef = new PageReference('/apex/ProductionTabDetail');  
        tabPageNameList.put(Page.ProductionTabDetail,'Production');
        pageRef = new PageReference('/apex/ProtoRiskProductionTabDetail');  
        tabPageNameList.put(Page.ProtoRiskProductionTabDetail,'ProtoRiskProduction');
        pageRef = new PageReference('/apex/TapeoutTabDetail');
        tabPageNameList.put(Page.TapeoutTabDetail,'Tapeout');
        pageRef= new PageReference('/apex/ProductionRawTabDetail');
        tabrawPageNameList.put(Page.ProductionRawTabDetail,'ProductionRaw');
        pageRef= new PageReference('/apex/ProtorawRiskProductionTabDetail');
        tabrawPageNameList.put(Page.ProtoRawRiskProductionTabDetail,'ProtoRawRiskProduction');
        pageRef= new PageReference('/apex/TapeoutrawTabDetail');
        tabrawPageNameList.put(Page.TapeoutrawTabDetail,'Tapeoutraw');
        pageRef.setRedirect(false);
        Boolean bPublished = ManualDeviceHelper.btnClickPublishToTeamRoom(tabPageNameList);

        ManualDeviceHelper.RawbtnClickPublishToTeamRoom(tabrawPageNameList);
        if (bPublished) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM, ManualDeviceConstants.MDEVICE_TEAM_ROOM_PUBLISH_INFO));
        } else {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, ManualDeviceConstants.MDEVICE_TEAM_ROOM_PUBLISH_ERROR));
        }
        return null;
    }

}