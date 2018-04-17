/*
    Author: Zymark Ambat
    Description: This serves as the controller for MPWTrainsScheduleTabVF and MPWViewScheduleExportPDFVF.
    History: 
        ZAmbat      05112015    - Code creation.
        SNair       05252015    - modified to add Publish as search criteria and also inline editing for publish.
        Anil Kumar : 00069254 : May 4, 2017 : Customized shuttle should not display to all customers except linked account
        Kanishk Singh:MPW-PP137 Raise a Reservation Form for a customized shuttle should be enabled only for those Internal users who are linked to that customized shuttle
*/

public class MPWTrainScheduleTabController {
    public integer totalNoOfPages {get;set;}
    public integer totalNoOfRecords {get;set;}
    public integer currentPageNo {get;set;}
    public list<SelectOption> pageList {get;set;}
    public String selectedVal {get;set;}
    public string selectedTab {get;set;}
    public string selectedTabId {get;set;}
    public string userId {get;set;}
    public String sortType {get; set;}
    public String sortField {get; set;}
    public string selectedStatus {get;set;}
    public String selectedPublish{get;set;}
    public MPW_Train_Maintenance__c mpwtm {get;set;}
    public List<MPW_Notes__c> listScheduleNotes {get;set;}
    public List<MPWScheduleTrainWrapper> listMPWScheduleTrains {get; set;}  
    public Map<integer, List<MPWScheduleTrainWrapper>> mapMPWTrain {get;set;}
    //public Map<integer, List<MPW_Train_Maintenance__c>> mapMPW {get;set;}
    public Map<Id, Id> mapAccountMPW;
    public List<MPW_Train_Maintenance__c> listMTP;
    public Set<Id> mpwPortalFormIds;
    public Set<Id> mpwPortalFormIds1;
    public Set<Id> accountIds;
    public Boolean isPortalUser;
    public UtilClassToGetAllFields util{get;set;}
    public string geometry{get;set;}
    
    public MPWTrainScheduleTabController() {
        init();
    }
    
    public void init() {
        // Init
        this.listMPWScheduleTrains = new List<MPWScheduleTrainWrapper>();
        this.mpwtm = new MPW_Train_Maintenance__c();
        accountIds = new Set<Id>();
        mpwPortalFormIds = new Set<Id>();
        mpwPortalFormIds1 = new Set<Id>();
        mapAccountMPW = new Map<Id, Id>();
        this.totalNoOfPages = 0;
        this.totalNoOfRecords = 0;
        this.currentPageNo = 1;      
        this.sortField = 'Reservation_Close_Date__c';
        this.sortType = 'DESC';
        this.selectedStatus = 'None'; 
        this.selectedPublish = 'None';       
        this.selectedVal = '10';
        this.isPortalUser = false;
        this.geometry = 'None';
        
        if(ApexPages.currentPage().getParameters().get('userId') != null){
            userId = ApexPages.currentPage().getParameters().get('userId');
            getPortalInfoUser(userId);           
        }
        else{
            userId = UserInfo.getUserId();
            getPortalInfoUser(userId);
        }
        
        if(ApexPages.currentPage().getParameters().get('sfdc.tabName') != null) {
            this.selectedTabId = ApexPages.currentPage().getParameters().get('sfdc.tabName');
            // Check if the selected tab is Maintain MPW Schedule or View MPW Schedule
            if(this.selectedTabId == MPW_Settings__c.getInstance('View_MPW_Schedule_Tab_Id').Value__c){
                this.selectedTab = 'ViewMPWSchedule';
            }           
            else {
                this.selectedTab = retrieveSelectedTabName(ApexPages.currentPage().getParameters().get('sfdc.tabName'));
            }
        }
        else{
            this.selectedTab = 'ViewMPWSchedule';
        }
        
        // Retrieve MPW Records
        retrieveMPWRecords();
        
        // Retrieve Data from MPW Notes object
        this.listScheduleNotes = retrieveNotesData();
        
        getpageList();
    }
    
    public List<SelectOption> getGeometryList(){
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('None','Select Geometry'));
        for(MPW_Geometry_Mapping__c m: [select Id, Name, Sequence_No__c from MPW_Geometry_Mapping__c where Active__c = true and Use_Process_Type__c = true order by Sequence_No__c asc]){
            options.add(new SelectOption(m.Name,m.Name));
        }
        return options;
    }
    
    private void getPortalInfoUser(Id portalUserId){
        User userInfo = [ SELECT Id, AccountId, UserType FROM User
                          WHERE Id =: portalUserId];
        if(userInfo.UserType == 'CustomerSuccess' || userInfo.UserType == 'PowerCustomerSuccess'){
                this.isPortalUser = true;
        } else {
            this.isPortalUser = false;
        }
            
        if(this.isPortalUser){
            if(userInfo.AccountId != null){
                retrievePortalAccounts(userInfo.AccountId);
            }
            else{
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, 'No Account is associated with User'));
            }
        }
    }
    
    public boolean getIsPortalType(){
        return isPortalUser;
    }
    
    private void retrievePortalAccounts(Id portalAccountId) {
        
        Set<Id> belowAccountIds = new Set<Id>();
        
        // Get Account Id and ParentId
        accountIds.add(portalAccountId);
                        
        // Get Accounts below
        belowAccountIds = retrievePortalAccountBelow(accountIds);
        
        // Get MPW Forms from Account Ids
        if(!belowAccountIds.isEmpty()) {
            retrievePortalMPWForms(belowAccountIds);
        }                                
    }
    
    private Set<Id> retrievePortalAccountBelow(Set<Id> portalAccountIds) {
        
        Set<Id> tempAccountIds =  new Set<Id>();
    
        for (Account_Hierarchy__c ah : [SELECT Account_Id__c
                                        FROM  Account_Hierarchy__c
                                        WHERE Parent_Id__c IN :portalAccountIds AND Account_Id__c NOT IN :portalAccountIds
                                        LIMIT 50]) { 
            tempAccountIds.add(ah.Account_Id__c);
            accountIds.add(ah.Account_Id__c);
        }
        
        if(!tempAccountIds.isEmpty()) {
            retrievePortalAccountBelow(tempAccountIds);           
        }
        
        return accountIds;
    }
    
    private void retrievePortalMPWForms(Set<Id> portalAccountIds) {
            
        for(MPW_Train_Account__c mpwAccountTrain : [ SELECT MPW_Train__c, Account__c 
                                                     FROM MPW_Train_Account__c 
                                                     WHERE Account__c IN :portalAccountIds]){                    
            mpwPortalFormIds.add(mpwAccountTrain.MPW_Train__c);   
        }
        for(MPW_Train_Account__c mpwAccountTrain1 : [ SELECT MPW_Train__c, Account__c 
                                                     FROM MPW_Train_Account__c ]){
            mpwPortalFormIds1.add(mpwAccountTrain1.MPW_Train__c);                                                                      
        }
    }
            
    private List<MPW_Notes__c> retrieveNotesData() {
        String todayDT = datetime.now().format('yyyy-MM-dd');
        String notesVar = 'ScheduleNotes';
        string soql = 'SELECT Value__c ' + 
                      'FROM MPW_Notes__c ' +
                      'WHERE Active__c = true AND Type__c = \'' + notesVar + '\' AND Effective_Start_Date__c <= ' + todayDT + ' AND Effective_Finish_Date__c >= ' + todayDT + ' ' +
                      'ORDER BY Sequence_No__c ASC';
        this.listScheduleNotes = Database.Query(soql);
        
        return listScheduleNotes;
    }
    
    private string retrieveSelectedTabName(string tabId) {
        string tabName = '';
        for (Schema.DescribeTabSetResult dtsr : Schema.describeTabs()) {
            if (dtsr.isSelected()) {
                for (Schema.DescribeTabResult dtr : dtsr.tabs) {
                    if (dtr.url.contains(tabId)) {
                        tabName = dtr.label;
                        break;
                    }
                }
                break;
            }
        }
        return tabName.replace(' ', '');
    }
    
    public List<SelectOption> getFab() {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('None', '--None--'));
        for (MPW_Keyword_Config__c m : [SELECT Id, Value__c
                                        FROM MPW_Keyword_Config__c
                                        WHERE Active__c = true AND Type__c = 'FabListing'
                                        ORDER BY  Sequence_No__c ASC]) {
            options.add(new SelectOption(m.Value__c, m.Value__c));
        }
        
        return options;
    }
    
    private DateTime convertDateTime(DateTime pDT) {
        system.debug('pDT:'+pDT);
        string temp = pDT.format('yyyy-MM-dd HH:mm:ss', 'America/Los_Angeles');
        String[] ss = temp.split(' ');
        String[] st = ss[0].split('-');
        String[] tt = ss[1].split(':');

        Datetime pstTime = Datetime.newInstanceGMT(Integer.valueOf(st[0]),Integer.valueOf(st[1]),Integer.valueOf(st[2]),Integer.valueOf(tt[0]),Integer.valueOf(tt[1]),Integer.valueOf(tt[2]));
        
        return pstTime;
    }
    
    public void retrieveMPWRecords() {
    
        //list for Maintain MPW Schedule
        List<MPW_Train_Maintenance__c> tempList = new List<MPW_Train_Maintenance__c>();
        //List for View MPW Schedule
        List<MPW_Train_Maintenance__c> tempList1 = new List<MPW_Train_Maintenance__c>();
        
        Set<Id> mpwTrainIds = new Set<Id>();
        Set<Id> accIds = new Set<Id>();
        Map<Id, list<Id>> mpwTrainAccIdMap = new Map<Id, list<Id>>();
        Map<Id, Set<Id>> atpMap = new Map<Id, Set<Id>>();
        Set<Id> atpList = new Set<Id>();
        
        util = new UtilClassToGetAllFields();
        this.listMPWScheduleTrains = new List<MPWScheduleTrainWrapper>();
        this.totalNoOfRecords = 0;
        Datetime todayDT = convertDateTime(DateTime.now());
        Datetime projectedEndDate;
        
        String queryFields = util.getAllFields('MPW_Train_Maintenance__c');
        
        this.mapMPWTrain = new Map<integer, List<MPWScheduleTrainWrapper>>();
        
        // Main query
        String soql = 'SELECT '+queryFields+' FROM MPW_Train_Maintenance__c ';            
        // Filters
        string soqlFilters = '';
        if ((this.mpwtm.Name != null 
            || this.selectedStatus != 'None'
            || this.geometry != 'None' 
            || this.mpwtm.Fab__c != null
            || this.selectedPublish != 'None') 
            && this.selectedTab == 'MaintainMPWSchedule') {
            if (this.mpwtm.Name != null) {
                soqlFilters = 'Name LIKE \'%' + this.mpwtm.Name.replace('*', '%') + '%\' ';
            }
            
            if (this.selectedStatus != 'None') {
                soqlFilters = (soqlFilters != '' ? soqlFilters + 'AND ' : '') + 'Active__c = ' + (this.selectedStatus == 'Active' ? true : false) + ' ';
            }
            
            if (this.geometry != 'None') {
                soqlFilters = (soqlFilters != '' ? soqlFilters + 'AND ' : '') + 'Geometry__c = \'' + this.geometry + '\' ';
            }
            
            if (this.mpwtm.Fab__c != 'None') {
                string selectedFabs = this.mpwtm.Fab__c;
                soqlFilters = (soqlFilters != '' ? soqlFilters + 'AND ' : '') + 'Fab__c = \'' + this.mpwtm.Fab__c + '\' ';
            }
            if(this.selectedPublish != 'None'){
                System.debug(this.selectedPublish);
                if(this.selectedPublish == 'True'){
                        soqlFilters = (soqlFilters != '' ? soqlFilters + 'AND ' : '') + 'Publish__c = true ';   
                }
                if(this.selectedPublish == 'False'){
                        soqlFilters = (soqlFilters != '' ? soqlFilters + 'AND ' : '') + 'Publish__c = false ';  
                }
            }
        } 
        else if ((this.mpwtm.Name != null || this.geometry != 'None' || this.mpwtm.Reservation_Close_Start_Date__c != null || this.mpwtm.Reservation_Close_End_Date__c != null || this.mpwtm.Tapeout_Date_Customer_Start_Date__c != null || this.mpwtm.Tapeout_Date_Customer_End_Date__c != null) && this.selectedTab == 'ViewMPWSchedule') {
            if(this.mpwtm.Name != null) {
                soqlFilters = ' Name LIKE \'%' + this.mpwtm.Name.replace('*', '%') + '%\' ';
            }
            if (this.geometry != 'None') {
                soqlFilters = (soqlFilters != '' ? soqlFilters + 'AND ' : '') + 'Geometry__c = \'' + this.geometry + '\' ';
            }
            if(this.mpwtm.Reservation_Close_Start_Date__c != null && this.mpwtm.Reservation_Close_End_Date__c != null){
                String startdate = this.mpwtm.Reservation_Close_Start_Date__c.format('yyyy-MM-dd\'T\'hh:mm:ss\'Z\'');
                String enddate = this.mpwtm.Reservation_Close_End_Date__c.format('yyyy-MM-dd\'T\'hh:mm:ss\'Z\'');
                soqlFilters = (soqlFilters != '' ? soqlFilters + ' AND' : '') + ' Reservation_Close_Date__c > '+startdate+' AND Reservation_Close_Date__c < '+enddate ;
            }
            if(this.mpwtm.Tapeout_Date_Customer_Start_Date__c != null && this.mpwtm.Tapeout_Date_Customer_End_Date__c != null){
                String startdate = this.mpwtm.Tapeout_Date_Customer_Start_Date__c.format('yyyy-MM-dd\'T\'hh:mm:ss\'Z\'');
                String enddate = this.mpwtm.Tapeout_Date_Customer_End_Date__c .format('yyyy-MM-dd\'T\'hh:mm:ss\'Z\'');
                soqlFilters = (soqlFilters != '' ? soqlFilters + ' AND' : '') + ' Tapeout_Date_Customer__c > '+startdate+' AND Tapeout_Date_Customer__c < '+enddate;
            }
        }
        if(this.selectedTab == 'ViewMPWSchedule') {
            soqlFilters = (soqlFilters != '' ? soqlFilters + ' AND' : '') + ' (Publish__c = true AND Active__c = true AND Projected_2nd_Batch_Bare_Die_Ship_End__c != null) '; 
        }   
        
        if (soqlFilters != '') {
            soql = soql + 'WHERE ' + soqlFilters;
        }
        
        soql = soql + ' ORDER BY Reservation_Close_Date__c DESC';
        
        system.debug('SOQL query is: '+soql);
                         
        tempList = database.query(soql); 
        System.debug('Abhita'+templist);        
        listMTP = tempList; 

        //Added By Abhita           
        if(this.selectedTab == 'ViewMPWSchedule') { //ViewMPWSchedule           
            for(MPW_Train_Maintenance__c mpwTrain : tempList){    
                if(mpwTrain.Projected_2nd_Batch_Bare_Die_Ship_End__c.day() == 1) {
                    projectedEndDate = mpwTrain.Projected_2nd_Batch_Bare_Die_Ship_End__c.addDays(13);
                }          
                else{
                    projectedEndDate = mpwTrain.Projected_2nd_Batch_Bare_Die_Ship_End__c;
                }
                if(projectedEndDate >= todayDT){
                    tempList1.add(mpwTrain);
                }
            }
            
            if(!this.isPortalUser) {
                for(MPW_Train_Maintenance__c mpwTrain : tempList1) {
                    System.debug(mpwTrain.Id);
                    mpwTrainIds.add(mpwTrain.Id);
                }
             
                List<MPW_Train_Account__c> mpwTrainAccs = [Select MPW_Train__c, Account__c, MPW_Train__r.Train_Type__c FROM MPW_Train_Account__c where MPW_Train__c IN: mpwTrainIds AND MPW_Train__r.Train_Type__c IN ('GlobalShuttle','CustomizedShuttle')];
                for(MPW_Train_Account__c mpwAcc : mpwTrainAccs) {
                  
                    //Kanishk: Train could be associated with Multiple account . Updated one to one mapping to one to many   
                     // mpwTrainAccIdMap.put(mpwAcc.MPW_Train__c, mpwAcc.Account__c);             
                    
                    if(mpwTrainAccIdMap.get(mpwAcc.MPW_Train__c)==null){
                    	mpwTrainAccIdMap.put(mpwAcc.MPW_Train__c,new list<id>());
                    } 
                    
                     mpwTrainAccIdMap.get(mpwAcc.MPW_Train__c).add(mpwAcc.Account__c); 
                  
                     accIds.add(mpwAcc.Account__c);
                }
                
                List<Account_Team_Proxy__c> proxyList = retreiveAccountTeamProxy(accIds);
                
                if(!proxyList.isEmpty()){
                     Id accAM = proxyList[0].Account__c;
                     for(Account_Team_Proxy__c p: proxyList) {
                         if(p.Account__c == accAM) {
                         atpList.add(p.User__c);
                         } else {
                             atpMap.put(accAM, atpList);
                             accAM = p.Account__c;
                             atpList = new Set<Id>();
                             atpList.add(p.User__c);
                         }
                    }
                    atpMap.put(accAM, atpList);
                }
            }
            
            if(!tempList1.isEmpty()){           
                for(MPW_Train_Maintenance__c mpwTrain : tempList1){         
                    if (mpwTrain.Reservation_Close_Date__c != null) {
                        mpwTrain.Reservation_Close_Date__c = revertDateTime(mpwTrain.Reservation_Close_Date__c);
                    }
                    
                    // CDRS Submit Date
                    if (mpwTrain.CDRS_Submit_Date__c != null) {
                        mpwTrain.CDRS_Submit_Date__c = revertDateTime(mpwTrain.CDRS_Submit_Date__c);
                    }
                    
                    // GDS II Cutoff
                    if (mpwTrain.GDSII_Cutoff_for_Dry_Run_DRC__c != null) {
                        mpwTrain.GDSII_Cutoff_for_Dry_Run_DRC__c = revertDateTime(mpwTrain.GDSII_Cutoff_for_Dry_Run_DRC__c);
                    }
                    
                    // Tapeout Date - Customer
                    if (mpwTrain.Tapeout_Date_Customer__c != null) {
                        mpwTrain.Tapeout_Date_Customer__c = revertDateTime(mpwTrain.Tapeout_Date_Customer__c);
                    }
                    
                    // Tapeout Date - Other Participant
                    if (mpwTrain.Tapeout_Date_Other_Participant__c != null) {
                        mpwTrain.Tapeout_Date_Other_Participant__c = revertDateTime(mpwTrain.Tapeout_Date_Other_Participant__c);
                    }
                    
                    // Projected 1st Batch Start
                    if (mpwTrain.Projected_1st_Batch_Bare_Die_Ship_Start__c != null) {
                        mpwTrain.Projected_1st_Batch_Bare_Die_Ship_Start__c = revertDateTime(mpwTrain.Projected_1st_Batch_Bare_Die_Ship_Start__c);
                    }
                    
                    // Projected 1st Batch End
                    if (mpwTrain.Projected_1st_Batch_Bare_Die_Ship_End__c != null) {
                        mpwTrain.Projected_1st_Batch_Bare_Die_Ship_End__c = revertDateTime(mpwTrain.Projected_1st_Batch_Bare_Die_Ship_End__c);
                    }
                    
                    // Projected 2nd Batch Start
                    if (mpwTrain.Projected_2nd_Batch_Bare_Die_Ship_Start__c != null) {
                        mpwTrain.Projected_2nd_Batch_Bare_Die_Ship_Start__c = revertDateTime(mpwTrain.Projected_2nd_Batch_Bare_Die_Ship_Start__c);
                    }
                    
                    // Projected 2nd Batch End
                    if (mpwTrain.Projected_2nd_Batch_Bare_Die_Ship_End__c != null) {
                        mpwTrain.Projected_2nd_Batch_Bare_Die_Ship_End__c = revertDateTime(mpwTrain.Projected_2nd_Batch_Bare_Die_Ship_End__c);
                    }
                    
                    MPWScheduleTrainWrapper n = new MPWScheduleTrainWrapper();      
                    
                    if(!this.isPortalUser) { 
                       Set<Id> atpValues = new Set<Id>();
                       
                       //Kanishk: Train could be associated with Multiple account
                       // atpValues = atpMap.get(mpwTrainAccIdMap.get(mpwTrain.Id));
                       if(mpwTrainAccIdMap!=null && mpwTrainAccIdMap.get(mpwTrain.Id)!=null){
                         for(Id strAccId:mpwTrainAccIdMap.get(mpwTrain.Id)){
                         	 if(atpMap.get(strAccId)!=null){	
                        	   atpValues.addAll(atpMap.get(strAccId));
                         	 }
                        }
                       }
                       
                      
                      if(mpwTrain.Train_Type__c == 'GlobalShuttle'){
                        if(mpwTrainAccIdMap.containsKey(mpwTrain.Id) && atpValues.contains(UserInfo.getUserId())) {
                            n.isRaiseReq = true;
                        } else if(mpwTrain.Reservation_Close_Date__c >= todayDT){          
                              n.isRaiseReq = true;    
                        }
                      }
                      //Kanishk:Raise a Reservation Form for a customized shuttle should be enabled only for those Internal users who are linked to that customized shuttle
                      else if(mpwTrain.Train_Type__c == 'CustomizedShuttle'){
                      	if(mpwTrainAccIdMap.containsKey(mpwTrain.Id) && atpValues.contains(UserInfo.getUserId())) {
                      		 n.isRaiseReq = true;
                      	}
                      }            
                    }           
                    
                    Boolean isCustomizedShuttle = false; //Added by Anil Kumar : May 4, 2017
                    if(this.isPortalUser) {         
                         system.debug('Is Portal User, check for Customized.');
                         if(mpwTrain.Train_Type__c == 'CustomizedShuttle' && mpwPortalFormIds.contains(mpwTrain.Id)) {
                            system.debug('Raise for Customized Shuttle: '+mpwTrain.Name);
                            if(mpwTrain.Reservation_Close_Date__c >= todayDT) {
                                n.isRaiseReq = true;
                            }
                            
                            //Added by Anil Kumar : May 4, 2017 : Add MPW Train to list for CustomizedShuttle 
                            n.mpwScheduleTrain = mpwTrain;          
                            listMPWScheduleTrains.add(n);
                         }
                         
                         isCustomizedShuttle = mpwTrain.Train_Type__c == 'CustomizedShuttle' ? true : false;
                         
                         if((mpwTrain.Train_Type__c == 'GlobalShuttle' && mpwTrain.Reservation_Close_Date__c >= todayDT) || (mpwTrain.Train_Type__c == 'GlobalShuttle' && mpwTrain.Reservation_Close_Date__c < todayDT && mpwPortalFormIds.contains(mpwTrain.Id))) {
                            n.isRaiseReq = true;
                         }
                    } 
                    
                    //Modified by Anil Kumar : May 4, 2017 : Do not add CustomizedShuttle Train in to list here. 
                    if(!isCustomizedShuttle) {
                        n.mpwScheduleTrain = mpwTrain;          
                        listMPWScheduleTrains.add(n);           
                    }
                } 
            }          
        } else if(this.selectedTab == 'MaintainMPWSchedule') {          
            for(MPW_Train_Maintenance__c mpwTrain : tempList){          
                
                if (mpwTrain.Reservation_Close_Date__c != null) {
                    mpwTrain.Reservation_Close_Date__c = revertDateTime(mpwTrain.Reservation_Close_Date__c);
                }
                
                // CDRS Submit Date
                if (mpwTrain.CDRS_Submit_Date__c != null) {
                    mpwTrain.CDRS_Submit_Date__c = revertDateTime(mpwTrain.CDRS_Submit_Date__c);
                }
                
                // GDS II Cutoff
                if (mpwTrain.GDSII_Cutoff_for_Dry_Run_DRC__c != null) {
                    mpwTrain.GDSII_Cutoff_for_Dry_Run_DRC__c = revertDateTime(mpwTrain.GDSII_Cutoff_for_Dry_Run_DRC__c);
                }
                
                // Tapeout Date - Customer
                if (mpwTrain.Tapeout_Date_Customer__c != null) {
                    mpwTrain.Tapeout_Date_Customer__c = revertDateTime(mpwTrain.Tapeout_Date_Customer__c);
                }
                
                // Tapeout Date - Other Participant
                if (mpwTrain.Tapeout_Date_Other_Participant__c != null) {
                    mpwTrain.Tapeout_Date_Other_Participant__c = revertDateTime(mpwTrain.Tapeout_Date_Other_Participant__c);
                }
                
                // Projected 1st Batch Start
                if (mpwTrain.Projected_1st_Batch_Bare_Die_Ship_Start__c != null) {
                    mpwTrain.Projected_1st_Batch_Bare_Die_Ship_Start__c = revertDateTime(mpwTrain.Projected_1st_Batch_Bare_Die_Ship_Start__c);
                }
                
                // Projected 1st Batch End
                if (mpwTrain.Projected_1st_Batch_Bare_Die_Ship_End__c != null) {
                    mpwTrain.Projected_1st_Batch_Bare_Die_Ship_End__c = revertDateTime(mpwTrain.Projected_1st_Batch_Bare_Die_Ship_End__c);
                }
                
                // Projected 2nd Batch Start
                if (mpwTrain.Projected_2nd_Batch_Bare_Die_Ship_Start__c != null) {
                    mpwTrain.Projected_2nd_Batch_Bare_Die_Ship_Start__c = revertDateTime(mpwTrain.Projected_2nd_Batch_Bare_Die_Ship_Start__c);
                }
                
                // Projected 2nd Batch End
                if (mpwTrain.Projected_2nd_Batch_Bare_Die_Ship_End__c != null) {
                    mpwTrain.Projected_2nd_Batch_Bare_Die_Ship_End__c = revertDateTime(mpwTrain.Projected_2nd_Batch_Bare_Die_Ship_End__c);
                }
                
                MPWScheduleTrainWrapper n = new MPWScheduleTrainWrapper();          
                                
                n.mpwScheduleTrain = mpwTrain;          
                listMPWScheduleTrains.add(n);           
                                
            }           
        }
        if (listMPWScheduleTrains.size() > 0) {
            this.mapMPWTrain = paginateRecords(listMPWScheduleTrains);
        }     
    }
    
    private Map<integer, List<MPWScheduleTrainWrapper>> paginateRecords(List<MPWScheduleTrainWrapper> tempList) {
        Map<integer, List<MPWScheduleTrainWrapper>> tempMap = new Map<integer, List<MPWScheduleTrainWrapper>>();
        integer recordsPerPage = Integer.valueOf(selectedVal);
        integer pageNo = 1;
        List<MPWScheduleTrainWrapper> temp = new List<MPWScheduleTrainWrapper>();
        for (MPWScheduleTrainWrapper m : tempList) {
            if (temp.size() < recordsPerPage) {
                temp.add(m);
            } else {
                tempMap.put(pageNo, temp);
                pageNo++;
                temp = new List<MPWScheduleTrainWrapper>();
                temp.add(m);
            }
        }
        
        if (temp.size() > 0) {
            tempMap.put(pageNo, temp);
        }
        
        // Set values
        this.totalNoOfPages = pageNo;
        if(currentPageNo > 1){
           this.currentPageNo = 1;        
        }
        this.totalNoOfRecords  = tempList.size();
        
        return tempMap;
    }
    
    public PageReference addNewMPWSchedule() {
        PageReference p = Page.MPWTrainScheduleTranxVF;
        p.getParameters().put('tranx', 'Add');
        p.getParameters().put('tabId', this.selectedTabId);
        p.setRedirect(true);
        
        return p;
    }
    
    // Added By Abhita
    private List<Account_Team_Proxy__c> retreiveAccountTeamProxy(Set<Id> accountIds) {         
        List<Account_Team_Proxy__c> proxyList = new List<Account_Team_Proxy__c>();
      
        proxyList = [select User__c, Account__c from Account_Team_Proxy__c where Account__c IN :accountIds order by Account__c asc];
        
        return proxyList;
    }
    
    public void sortRecords() {
        string tempSortField = ApexPages.currentPage().getParameters().get('sortField');
        if (this.sortField == tempSortField) {
            if (this.sortType == 'ASC') {
                this.sortType = 'DESC';
            } else {
                this.sortType = 'ASC';
            }
        } else {
            this.sortField = tempSortField;
            this.sortType = 'ASC';
        }
        
        // Sort Records
        List<MPWScheduleTrainWrapper> tempList = new List<MPWScheduleTrainWrapper>();
        for (integer key : this.mapMPWTrain.keySet()) {
            tempList.addAll(this.mapMPWTrain.get(key));
        }
        
        Map<string, List<MPWScheduleTrainWrapper>> tempMap = new Map<string, List<MPWScheduleTrainWrapper>>();
        for(MPWScheduleTrainWrapper m : tempList){
            string sortKey = string.valueOf(m.mpwScheduleTrain.get(this.sortField)); 
            if(tempMap.containsKey(sortKey)){
                tempMap.get(sortKey).add(m);
            } else {
                tempMap.put(sortKey, new List<MPWScheduleTrainWrapper>{m});
            }
        }
        
        List<string> sortList = new List<String>();
        sortList.addAll(tempMap.keySet());
        sortList.sort();
        
        tempList = new List<MPWScheduleTrainWrapper>();
        if(this.sortType == 'ASC'){
            for(string s : sortList){
                tempList.addAll(tempMap.get(s));    
            }
        } else if(this.sortType == 'DESC'){
            for(integer ctr = (sortList.size()-1); ctr >= 0; ctr--){
                tempList.addAll(tempMap.get(sortList[ctr]));    
            }
        }
       
        this.mapMPWTrain = paginateRecords(tempList);
    }
    
    public List<MPWScheduleTrainWrapper> getMPWScheduleRecords() {
        return (this.mapMPWTrain.size() > 0 ? this.mapMPWTrain.get(this.currentPageNo) : new List<MPWScheduleTrainWrapper>());
    }
    
    private DateTime revertDateTime(DateTime pDT) {
        string temp = pDT.format('yyyy-MM-dd HH:mm:ss', 'America/Los_Angeles');    
        DateTime pstTime = DateTime.valueOf(temp);
        long timeDiff = pstTime.getTime() - pDT.getTime();
        integer seconds = integer.valueOf(timeDiff/1000);
        
        return pDT.addSeconds(seconds);
    }
    
    public List<SelectOption> getStatus() {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('None', '--None--'));
        options.add(new SelectOption('Active', 'Active'));
        options.add(new SelectOption('Inactive', 'Inactive'));
        
        return options;
    }
    
    public List<SelectOption> getPublish(){
            List<SelectOption> options = new List<SelectOption>();
            options.add(new SelectOption('None','--None--'));
            options.add(new SelectOption('True','True'));
            options.add(new SelectOption('False','False'));
            return options;
    }
    
    // to get the size of Records to display on page
    public List<SelectOption> getpageList() {
        pageList = new List<SelectOption>();
        pageList.add(new SelectOption('10', '10'));
        pageList.add(new SelectOption('20', '20'));
        pageList.add(new SelectOption('30', '30'));
        
        return pageList;
    }
    
    // Pagination Controls
    public boolean getHasPrevious() {
        return (this.currentPageNo > 1 ? true : false);
    }
    
    public boolean getHasNext() {
        return (this.currentPageNo < this.totalNoOfPages ? true : false);
    }
    
    public void previous() {
        this.currentPageNo--;
    }
    
    public void next() {
        this.currentPageNo++;
    }
    
    public void first() {
        this.currentPageNo = 1; 
    }
    
    public void last() {
        this.currentPageNo = this.totalNoOfPages;  
    }
    
    public void reset() {
        init();
    }
    
    public pageReference exportToPDF(){
        pageReference exportPage = Page.MPWViewScheduleExportPDFVF;
        return exportPage;
    }
    
    //method to save record after inline editing
    public pageReference saveMPW(){
        update listMTP;
        return null;
    }
    
    // Wrapper Class            
    public class MPWScheduleTrainWrapper {          
    public boolean isRaiseReq {get;set;}            
    public MPW_Train_Maintenance__c mpwScheduleTrain {get;set;}         
    
        public MPWScheduleTrainWrapper(){           
            isRaiseReq = false;         
            mpwScheduleTrain = new MPW_Train_Maintenance__c();          
        }                       
    }                  
}