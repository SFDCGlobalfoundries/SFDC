/*
    Author: Zymark Ambat
    Description: This serves as the controller for MPWTrainScheduleTranxVF.
    History: 
        ZAmbat      05122015    - Code creation.
        SNair       05272015    - added logic to retreive associated reservation forms.
        SNair       06052015    - fixed exception thrown by getRenderAssociatedAccounts() method. 
        Poulami     01112016    - added logic for MPW# to auto populate running alphabet for the last 2 digit(after running out of number) e.g. after MPW1899 => MPW18A0 (not MPW18100)
*/

public class MPWTrainScheduleTranxController {
    //variables
    public string tranx {get;set;}
    public string selectedTabId {get;set;}
    public string fromTab {get;set;}
    public string selectedProcess {get;set;}
    public string searchAccountsKey {get;set;}
    public String sortType {get; set;}
    public String sortField {get; set;}
    public integer associatedAccountsMapSize {get;set;}
    public boolean isPortalUser {get;set;}
    public boolean checkRaise {get;set;}
    public MPW_Train_Maintenance__c mpwtm {get;set;}
    public List<MPW_Train_Maintenance_Details__c> listMPWTMDetails {get;set;}
    public List<TechModuleWrapper> listTechModules {get;set;}
    public List<AccountsWrapper> listSearchAccounts {get;set;}
    public List<MPW_Reservation__c> listMPWR{get;set;}
    public Integer associatedReservationFormSize{get;set;}
    public Map<string, ProcessTechModulesWrapper> mapSelectedTechModules {get;set;}
    public Map<string, AccountsWrapper> mapAssociatedAccounts {get;set;}
    public UtilClassToGetAllFields util{get;set;}
    public List<String> processValues;
    public String selectedMonth {get;set;}
    public String selectedYear {get;set;}
    public String selectedMonth1 {get;set;}
    public String selectedYear1 {get;set;}
    public String selectedMonth2 {get;set;}
    public String selectedYear2 {get;set;}
    public String selectedMonth3 {get;set;}
    public String selectedYear3 {get;set;}
    public Integer dateStart1;
    public String monthStart1;
    public String yearStart1;
    public Integer monthValueStart1;
    public Integer dateStart2;
    public String monthStart2;
    public String yearStart2;
    public Integer monthValueStart2;
    public Integer dateEnd1;
    public String monthEnd1;
    public String yearEnd1;
    public Integer monthValueEnd1;
    public Integer dateEnd2;
    public String monthEnd2;
    public String yearEnd2;
    public Integer monthValueEnd2;
    public Set<Id> accountIds;
    public Set<Id> mpwPortalFormIds;
    public Set<Id> mpwPortalFormIds1;
    public List<SelectOption> geometryList{get;set;}
    public List<MPW_Reservation__c> mpwResfList{get;set;}
    public List<MPW_Process_Information_Question__c> mpwpiqList{get;set;}
    public Set<Id> existingTMDIdList{get;set;}
    public User requestor{get;set;}
    public List<MPW_Train_Maintenance_Details__c> mpwtmdDeleteList{get;set;}
    public Set<Id> userId;
    string tempNo;
    string mpwNo = '';
    public MPWTrainScheduleTranxController(ApexPages.StandardController ctr) {
        this.mpwtmdDeleteList = new List<MPW_Train_Maintenance_Details__c>();
        this.mpwpiqList = new List<MPW_Process_Information_Question__c>();
        this.existingTMDIdList = new Set<Id>();
        this.mpwResfList = new List<MPW_Reservation__c>();
        this.geometryList = new List<SelectOption>();
        accountIds = new Set<Id>();
        mpwPortalFormIds = new Set<Id>();
        mpwPortalFormIds1 = new Set<Id>();
        this.userId = new Set<Id>();
        this.geometryList.add(new SelectOption('None','Select Geometry'));
        for(MPW_Geometry_Mapping__c m: [select Id, Name, Sequence_No__c from MPW_Geometry_Mapping__c where Active__c = true and Use_Process_Type__c = true order by Sequence_No__c asc]){
            this.geometryList.add(new SelectOption(m.Name,m.Name));
        }
        
        // Init
        this.selectedProcess = 'None';
        this.associatedAccountsMapSize = 0;
        this.associatedReservationFormSize = 0;
        this.mpwtm = new MPW_Train_Maintenance__c();
        
        this.listMPWTMDetails = new List<MPW_Train_Maintenance_Details__c>();
        this.listTechModules = new List<TechModuleWrapper>();
        this.listSearchAccounts = new List<AccountsWrapper>();
        this.mapSelectedTechModules = new Map<string, ProcessTechModulesWrapper>();
        this.mapAssociatedAccounts = new Map<string, AccountsWrapper>();
        this.processValues = new List<String>();
        
        this.checkRaise = false;
        
        // Check User
        this.requestor = [select Id, Name, ManagerId, Profile.Name, Email, AccountId from User where Id =: UserInfo.getUserId()];       
        this.isPortalUser = checkUser(this.requestor.Id);
        
        // Added By Abhita
        Group customised = getPublicGp('MPW Customized MPW Queue');
        Group globalShuttle = getPublicGp('MPW GlobalShuttle MPW Tapeout Queue');
        Group tdti = getPublicGp('MPW TDTI MPW Queue');
        
        if(!this.isPortalUser) {
            for(Id queueId : getUserIds(customised.Id)) {
                userId.add(queueId);
            }
            for(Id queueId : getUserIds(globalShuttle.Id)) {
                userId.add(queueId);
            }
            for(Id queueId : getUserIds(tdti.Id)) {
                userId.add(queueId);
            }
        }
        
        // Check if the point of initiation came from the Maintain MPW Schedule Tab
        this.selectedTabId = ApexPages.currentPage().getParameters().get('tabId');
        this.fromTab = ApexPages.currentPage().getParameters().get('from');
        
        // Check the transaction (View, Edit, or Add)
        if (ApexPages.currentPage().getParameters().get('tranx') != null) {
            this.tranx = ApexPages.currentPage().getParameters().get('tranx');
        } else {
            this.tranx = 'View';
        }

        // Check for record Id
        if (this.tranx == 'View' || this.tranx == 'Edit' || this.tranx == 'Clone') {
            
            Id mpwTrainId;
            Set<Id> accIds = new Set<Id>();
            Map<Id, Id> mpwTrainAccIdMap = new Map<Id, Id>();
            Map<Id, Set<Id>> atpMap = new Map<Id, Set<Id>>();
            Set<Id> atpList = new Set<Id>();
            
            DateTime todayDT = convertDateTime(DateTime.now());
            Datetime projectedEndDate;
            mpwTrainId = ApexPages.currentPage().getParameters().get('id');
            this.mpwtm = retrieveMPWTrainSchedule(ApexPages.currentPage().getParameters().get('id'));
            this.listMPWTMDetails = retrieveMPWTrainScheduleDetails(ApexPages.currentPage().getParameters().get('id'));
            if(this.tranx == 'View') {
                revertToPST();
                if(this.mpwtm.Active__c == true && this.mpwtm.Publish__c == true && this.mpwtm.Projected_2nd_Batch_Bare_Die_Ship_End__c != null){
                    // Added By Abhita
                    if(this.mpwtm.Projected_2nd_Batch_Bare_Die_Ship_End__c.day() == 1) {
                        projectedEndDate = this.mpwtm.Projected_2nd_Batch_Bare_Die_Ship_End__c.addDays(13);
                    }          
                    else{
                        projectedEndDate = this.mpwtm.Projected_2nd_Batch_Bare_Die_Ship_End__c;
                    }
                    if(projectedEndDate >= todayDT) {
                        if(this.requestor.Profile.Name == 'System Administrator' || this.requestor.Profile.Name == 'CTS Developers' || this.requestor.Profile.Name == 'GF Developer' || this.requestor.Profile.Name == 'GF Integration' || userId.contains(UserInfo.getUserId())) {
                            this.checkRaise = true; 
                        } else {
                            if(!isPortalUser) {
                                Set<Id> atpValues = new Set<Id>();
                                
                                List<MPW_Train_Account__c> mpwTrainAccs = [Select MPW_Train__c, Account__c, MPW_Train__r.Train_Type__c FROM MPW_Train_Account__c where MPW_Train__c = :mpwTrainId AND MPW_Train__r.Train_Type__c = 'GlobalShuttle'];
                                for(MPW_Train_Account__c mpwAcc : mpwTrainAccs) {
                                    mpwTrainAccIdMap.put(mpwAcc.MPW_Train__c, mpwAcc.Account__c);
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
                                                            
                                atpValues = atpMap.get(mpwTrainAccIdMap.get(this.mpwtm.Id));
                                if(mpwTrainAccIdMap.containsKey(this.mpwtm.Id) && atpValues.contains(UserInfo.getUserId())) {
                                    this.checkRaise = true;
                                } else if(this.mpwtm.Reservation_Close_Date__c >= todayDT){          
                                    this.checkRaise = true;            
                                }
                            } else if(isPortalUser) {
                                
                                if(this.mpwtm.Train_Type__c == 'CustomizedShuttle' && mpwPortalFormIds.contains(this.mpwtm.Id) && this.mpwtm.Reservation_Close_Date__c >= todayDT && this.mpwtm.Projected_2nd_Batch_Bare_Die_Ship_End__c != null) {
                                    this.checkRaise = true; 
                                 }
                                 if((this.mpwtm.Train_Type__c == 'GlobalShuttle' && this.mpwtm.Reservation_Close_Date__c >= todayDT) || (this.mpwtm.Train_Type__c == 'GlobalShuttle' && this.mpwtm.Reservation_Close_Date__c < todayDT && mpwPortalFormIds.contains(this.mpwtm.Id)) && this.mpwtm.Projected_2nd_Batch_Bare_Die_Ship_End__c != null) {
                                    this.checkRaise = true; 
                                 }                          
                            }
                        }
                    }
                }
            }
        }
        
        if (this.tranx == 'View' && this.selectedTabId == null) {
            this.selectedTabId = MPW_Settings__c.getInstance('Maintenance_MPW_Schedule_Tab_Id').Value__c;
        }
        
        if(this.tranx == 'Edit' || this.tranx == 'Clone') {
            if(this.mpwtm.Projected_1st_Batch_Bare_Die_Ship__c != null) {
                if(this.mpwtm.Projected_1st_Batch_Bare_Die_Ship_Start__c != null) {
                    Integer dayStartOne = this.mpwtm.Projected_1st_Batch_Bare_Die_Ship_Start__c.day() - 1;
                    Integer monthStartOne = this.mpwtm.Projected_1st_Batch_Bare_Die_Ship_Start__c.month();
                    Integer yearStartOne = this.mpwtm.Projected_1st_Batch_Bare_Die_Ship_Start__c.year();
                    
                    String month1st = calculateProjectedDate(dayStartOne, monthStartOne);
                    this.selectedMonth = month1st;
                    this.selectedYear = String.valueOf(yearStartOne);
                }
                if(this.mpwtm.Projected_1st_Batch_Bare_Die_Ship_End__c != null) {
                    Integer dayStartOne = this.mpwtm.Projected_1st_Batch_Bare_Die_Ship_End__c.day() - 1;
                    Integer monthStartOne = this.mpwtm.Projected_1st_Batch_Bare_Die_Ship_End__c.month();
                    Integer yearStartOne = this.mpwtm.Projected_1st_Batch_Bare_Die_Ship_End__c.year();
                  
                    String month1st = calculateProjectedDate(dayStartOne, monthStartOne);
                    
                    this.selectedMonth1 = month1st;
                    this.selectedYear1 = String.valueOf(yearStartOne);
                } 
            } 
            if(this.mpwtm.Projected_2nd_Batch_Bare_Die_Ship__c != null) {
                if(this.mpwtm.Projected_2nd_Batch_Bare_Die_Ship_Start__c != null) {
                    Integer dayStartOne = this.mpwtm.Projected_2nd_Batch_Bare_Die_Ship_Start__c.day() - 1;
                    Integer monthStartOne = this.mpwtm.Projected_2nd_Batch_Bare_Die_Ship_Start__c.month();
                    Integer yearStartOne = this.mpwtm.Projected_2nd_Batch_Bare_Die_Ship_Start__c.year();
                    
                    String month1st = calculateProjectedDate(dayStartOne, monthStartOne);
                    
                    this.selectedMonth2 = month1st;
                    this.selectedYear2 = String.valueOf(yearStartOne);
                }
                if(this.mpwtm.Projected_2nd_Batch_Bare_Die_Ship_End__c != null) {
                    Integer dayStartOne = this.mpwtm.Projected_2nd_Batch_Bare_Die_Ship_End__c.day() - 1;
                    Integer monthStartOne = this.mpwtm.Projected_2nd_Batch_Bare_Die_Ship_End__c.month();
                    Integer yearStartOne = this.mpwtm.Projected_2nd_Batch_Bare_Die_Ship_End__c.year();
                    
                    String month1st = calculateProjectedDate(dayStartOne, monthStartOne);
                    
                    this.selectedMonth3 = month1st;
                    this.selectedYear3 = String.valueOf(yearStartOne);
                }
            }
        }
    }
    
    //Added By Abhita
    public static Group getPublicGp(String PName){
            Group gp = [Select Type, id From Group where Type= 'Queue' And Name =:PName Limit 1];
            return gp;
    }
    
    public static Set<Id> getUserIds(String gpId){
           Set<Id> userList = new Set<Id>();
           for(GroupMember groupMem : [Select UserOrGroupId From GroupMember where GroupId =:gpId]){
                userList.add(groupMem.UserOrGroupId);
           }
           return userList;
    }
    
    private String calculateProjectedDate(Integer day, Integer month) {
        
        String b = '';
        String m = '';
                
        if(day <= 10) {
            b = 'Early';
        } else if(day > 10 && day <= 20) {
            b = 'Mid';
        } else if(day > 20) {
            b = 'End';
        } else{}
                
        if(month == 1) {
            m = 'Jan';
        } else if(month == 2) {
            m = 'Feb';
        } else if(month == 3) {
            m = 'Mar';
        } else if(month == 4) {
            m = 'Apr';
        } else if(month == 5) {
            m = 'May';
        } else if(month == 6) {
            m = 'Jun';
        } else if(month == 7) {
            m = 'Jul';
        } else if(month == 8) {
            m = 'Aug';
        } else if(month == 9) {
            m = 'Sept';
        } else if(month == 10) {
            m = 'Oct';
        } else if(month == 11) {
            m = 'Nov';
        } else if(month == 12) {
            m = 'Dec';
        } else{}
                
        String mp = b + ' ' + m;
        
        return b + ' ' + m;       
    }
  
    
    private boolean checkUser(string userId) {
        boolean temp = false;
        User u = [
            SELECT  AccountId
            FROM    User    
            WHERE   Id = :userId    
        ];
        
        if (u.AccountId != null) {
            retrievePortalAccounts(u.AccountId);
            temp = true;
             
        }
        
        return temp;
    }
    
    //Added By Abhita
    private Set<Id> retrievePortalAccounts(Id portalAccountId) {

        Set<Id> belowAccountIds = new Set<Id>();
        System.debug(portalAccountId)          ;
        // Get Account Id and ParentId
        accountIds.add(portalAccountId);
              
        // Get Accounts below
        belowAccountIds = retrievePortalAccountBelow(accountIds);
        
        
        // Get MPW Forms from Account Ids
        if(!belowAccountIds.isEmpty()) {
            retrievePortalMPWForms(belowAccountIds);
        } 
        return null;                               
    }
    
    private Set<Id> retrievePortalAccountBelow(Set<Id> portalAccountIds) {
        System.debug('1');
        Set<Id> tempAccountIds =  new Set<Id>();
    
        for (Account_Hierarchy__c ah : [SELECT      Account_Id__c
                                        FROM        Account_Hierarchy__c
                                        WHERE       Parent_Id__c IN :portalAccountIds
                                                    AND Account_Id__c NOT IN :portalAccountIds
                                        LIMIT 50]) { 
        tempAccountIds.add(ah.Account_Id__c);
        accountIds.add(ah.Account_Id__c);
        }
        
        if(!tempAccountIds.isEmpty()) {
            retrievePortalAccountBelow(tempAccountIds);           
        }
        
        return accountIds;
    }
    
    private Set<Id> retrievePortalMPWForms(Set<Id> portalAccountIds) {
            System.debug(portalAccountIds);
            for(MPW_Train_Account__c mpwAccountTrain : [ SELECT     MPW_Train__c
                                                                    , Account__c 
                                                         FROM       MPW_Train_Account__c 
                                                         WHERE      Account__c IN :portalAccountIds]){
                    mpwPortalFormIds.add(mpwAccountTrain.MPW_Train__c);                                                                                             
            }
            for(MPW_Train_Account__c mpwAccountTrain1 : [ SELECT    MPW_Train__c
                                                                    , Account__c 
                                                         FROM       MPW_Train_Account__c ]){
                    mpwPortalFormIds1.add(mpwAccountTrain1.MPW_Train__c);                                                                                             
            }
            return null;
    }
     
    
    public list<SelectOption> getmonthList() {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('--None--', '--None--'));
        
        List<MPW_Month__c> dateValues = [Select Id, Name, Sequence_No__c from MPW_Month__c Order By Sequence_No__c ASC];
        
        // Create the Select Options.
        for (MPW_Month__c dateName : dateValues) {
            options.add(new SelectOption(dateName.Name, dateName.Name));
        }
        return options;
    }   
    
    public list<SelectOption> getyearList() {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('--None--', '--None--'));
        
        Map<String, MPW_Year__c> dates = MPW_Year__c.getAll();
        
        // Sort them by name
        List<String> dateNames = new List<String>();
        dateNames.addAll(dates.keySet());
        dateNames.sort();
        
        // Create the Select Options.
        for (String dateName : dateNames) {
            MPW_Year__c date1 = dates.get(dateName);
            options.add(new SelectOption(date1.Name, date1.Name));
        }
        return options;
    }
    
    // Projected 1st Start date
    public void monthValueStartOne(){
        monthStart1 = this.selectedMonth;
        if(this.tranx == 'Edit'){
            yearStart1 = this.selectedYear;
            combineValuesStartOne();
        }       
    }
    
    public void yearValueStartOne(){
        if(this.tranx == 'Edit' && monthStart1 == null) {
            monthStart1 = this.selectedMonth;
        }
        yearStart1 = this.selectedYear;
        combineValuesStartOne();       
    }
    
    private void combineValuesStartOne() {
        DateTime dt;
        
        
        if(monthStart1 != null) {
        if(monthStart1.contains('Early') ) {
            dateStart1 = 01;
        } else if(monthStart1.contains('Mid')) {
            dateStart1 = 15;
        } else if(monthStart1.contains('End')) {
            dateStart1 = 28;
        }
        
        if(monthStart1.contains('Jan')){
            monthValueStart1 = 01;
        }
        else if(monthStart1.contains('Feb')){
            monthValueStart1 = 02;
        }
        else if(monthStart1.contains('Mar')){
            monthValueStart1 = 03;
        }
        else if(monthStart1.contains('Apr')){
            monthValueStart1 = 04;
        }
        else if(monthStart1.contains('May')){
            monthValueStart1 = 05;
        }
        else if(monthStart1.contains('Jun')){
            monthValueStart1 = 06;
        }
        else if(monthStart1.contains('Jul')){
            monthValueStart1 = 07;
        }
        else if(monthStart1.contains('Aug')){
            monthValueStart1 = 08;
        }
        else if(monthStart1.contains('Sept')){
            monthValueStart1 = 09;
        }
        else if(monthStart1.contains('Oct')){
            monthValueStart1 = 10;
        }
        else if (monthStart1.contains('Nov')){
            monthValueStart1 = 11;
        }
        else if (monthStart1.contains('Dec')){
            monthValueStart1 = 12;
        } else {}
        
        Integer yearS1;
        if(yearStart1 != null && yearStart1 != '--None--') {
            yearS1 = Integer.valueOf(yearStart1);
        }
        
        if(yearS1 != null && monthValueStart1 != null && dateStart1 != null) {
            dt = DateTime.newInstance(yearS1,monthValueStart1,dateStart1,23,59,59);
            this.mpwtm.Projected_1st_Batch_Bare_Die_Ship_Start__c = dt;
        } else {
            this.mpwtm.Projected_1st_Batch_Bare_Die_Ship_Start__c = null;
        }
        }
    }
    
    // Projected 1st End date
    public void monthValueEndOne(){
        monthEnd1 = this.selectedMonth1;
        if(this.tranx == 'Edit'){
            yearEnd1 = this.selectedYear1;
            combineValuesEndOne();
        }
    }
    
    public void yearValueEndOne(){
        if(this.tranx == 'Edit' && monthEnd1 == null) {
            monthEnd1 = this.selectedMonth1;
        }
        yearEnd1 = this.selectedYear1;
        combineValuesEndOne();       
    }
    
    private void combineValuesEndOne() {
        if(monthEnd1 != null){
        if(monthEnd1.contains('Early') ) {
            dateEnd1 = 01;
        } else if(monthEnd1.contains('Mid')) {
            dateEnd1 = 15;
        } else if(monthEnd1.contains('End')) {
            dateEnd1 = 28;
        }
        
        if(monthEnd1.contains('Jan')){
            monthValueEnd1 = 01;
        }
        else if(monthEnd1.contains('Feb')){
            monthValueEnd1 = 02;
        }
        else if(monthEnd1.contains('Mar')){
            monthValueEnd1 = 03;
        }
        else if(monthEnd1.contains('Apr')){
            monthValueEnd1 = 04;
        }
        else if(monthEnd1.contains('May')){
            monthValueEnd1 = 05;
        }
        else if(monthEnd1.contains('Jun')){
            monthValueEnd1 = 06;
        }
        else if(monthEnd1.contains('Jul')){
            monthValueEnd1 = 07;
        }
        else if(monthEnd1.contains('Aug')){
            monthValueEnd1 = 08;
        }
        else if(monthEnd1.contains('Sept')){
            monthValueEnd1 = 09;
        }
        else if(monthEnd1.contains('Oct')){
            monthValueEnd1 = 10;
        }
        else if (monthEnd1.contains('Nov')){
            monthValueEnd1 = 11;
        }
        else if (monthEnd1.contains('Dec')){
            monthValueEnd1 = 12;
        } else {}
        
        Integer yearE1;
        if(yearEnd1 != null && yearEnd1 != '--None--'){
            yearE1 = integer.valueOf(yearEnd1);
        }
        
        if(yearE1 != null && monthValueEnd1 != null && dateEnd1 != null) {
            DateTime dt = DateTime.newInstance(yearE1,monthValueEnd1,dateEnd1,23,59,59);
            this.mpwtm.Projected_1st_Batch_Bare_Die_Ship_End__c = dt;
        } else {
            this.mpwtm.Projected_1st_Batch_Bare_Die_Ship_End__c = null;        
        }
        }
    }
    
    // Projected 2nd Start date
    public void monthValueStartTwo(){
        monthStart2 = this.selectedMonth2;
        if(this.tranx == 'Edit'){
            yearStart2 = this.selectedYear2;
            combineValuesStartTwo();
        }
    }
    
    public void yearValueStartTwo(){
        if(this.tranx == 'Edit' && monthStart2 == null) {
            monthStart2 = this.selectedMonth2;
        }
        yearStart2 = this.selectedYear2;
        combineValuesStartTwo();       
    }
    
    private void combineValuesStartTwo() {
        if(monthStart2 != null) {
        if(monthStart2.contains('Early') ) {
            dateStart2 = 01;
        } else if(monthStart2.contains('Mid')) {
            dateStart2 = 15;
        } else if(monthStart2.contains('End')) {
            dateStart2 = 28;
        }
        
        if(monthStart2.contains('Jan')){
            monthValueStart2 = 01;
        }
        else if(monthStart2.contains('Feb')){
            monthValueStart2 = 02;
        }
        else if(monthStart2.contains('Mar')){
            monthValueStart2 = 03;
        }
        else if(monthStart2.contains('Apr')){
            monthValueStart2 = 04;
        }
        else if(monthStart2.contains('May')){
            monthValueStart2 = 05;
        }
        else if(monthStart2.contains('Jun')){
            monthValueStart2 = 06;
        }
        else if(monthStart2.contains('Jul')){
            monthValueStart2 = 07;
        }
        else if(monthStart2.contains('Aug')){
            monthValueStart2 = 08;
        }
        else if(monthStart2.contains('Sept')){
            monthValueStart2 = 09;
        }
        else if(monthStart2.contains('Oct')){
            monthValueStart2 = 10;
        }
        else if (monthStart2.contains('Nov')){
            monthValueStart2 = 11;
        }
        else if (monthStart2.contains('Dec')){
            monthValueStart2 = 12;
        } else {}
        
        Integer yearS2;
        if(yearStart2 != null && yearStart2 != '--None--'){
            yearS2 = integer.valueOf(yearStart2);
        }
        
        if(yearS2 != null && monthValueStart2 != null && dateStart2 != null) {
            DateTime dt = DateTime.newInstance(yearS2,monthValueStart2,dateStart2,23,59,59);
            this.mpwtm.Projected_2nd_Batch_Bare_Die_Ship_Start__c = dt;
        } else {
            this.mpwtm.Projected_2nd_Batch_Bare_Die_Ship_Start__c = null;
        }
        }
    }
    
    // Projected 2nd End date
    public void monthValueEndTwo(){
        monthEnd2 = this.selectedMonth3;
        if(this.tranx == 'Edit'){
            yearEnd2 = this.selectedYear3;
            combineValuesEndTwo();
        }
    }
    
    public void yearValueEndTwo(){
        if(this.tranx == 'Edit' && monthEnd2 == null) {
            monthEnd2 = this.selectedMonth3;
        }
        yearEnd2 = this.selectedYear3;
        combineValuesEndTwo();       
    }
    
    private void combineValuesEndTwo() {
        if(monthEnd2 != null){
        if(monthEnd2.contains('Early') ) {
            dateEnd2 = 01;
        } else if(monthEnd2.contains('Mid')) {
            dateEnd2 = 15;
        } else if(monthEnd2.contains('End')) {
            dateEnd2 = 28;
        }
        
        if(monthEnd2.contains('Jan')){
            monthValueEnd2 = 01;
        }
        else if(monthEnd2.contains('Feb')){
            monthValueEnd2 = 02;
        }
        else if(monthEnd2.contains('Mar')){
            monthValueEnd2 = 03;
        }
        else if(monthEnd2.contains('Apr')){
            monthValueEnd2 = 04;
        }
        else if(monthEnd2.contains('May')){
            monthValueEnd2 = 05;
        }
        else if(monthEnd2.contains('Jun')){
            monthValueEnd2 = 06;
        }
        else if(monthEnd2.contains('Jul')){
            monthValueEnd2 = 07;
        }
        else if(monthEnd2.contains('Aug')){
            monthValueEnd2 = 08;
        }
        else if(monthEnd2.contains('Sept')){
            monthValueEnd2 = 09;
        }
        else if(monthEnd2.contains('Oct')){
            monthValueEnd2 = 10;
        }
        else if (monthEnd2.contains('Nov')){
            monthValueEnd2 = 11;
        }
        else if (monthEnd2.contains('Dec')){
            monthValueEnd2 = 12;
        } else {}
        
        Integer yearE2;
        if(yearEnd2 != null && yearEnd2 != '--None--'){
            yearE2 = integer.valueOf(yearEnd2);
        }
        
        if(yearE2 != null && monthValueEnd2 != null && dateEnd2 != null) {
            DateTime dt = DateTime.newInstance(yearE2,monthValueEnd2,dateEnd2,23,59,59);
            this.mpwtm.Projected_2nd_Batch_Bare_Die_Ship_End__c = dt;
        } else {
            this.mpwtm.Projected_2nd_Batch_Bare_Die_Ship_End__c = null;
        }
        }
    }
    
    private MPW_Train_Maintenance__c retrieveMPWTrainSchedule(string mpwId) {            
        MPW_Train_Maintenance__c m = [
            SELECT     Id
                       , Name
                       , Geometry__c
                       , Reservation_Close_Date__c
                       , Cancellation_Deadline__c 
                       , CDRS_Submit_Date__c
                       , GDSII_Cutoff_for_Dry_Run_DRC__c
                       , Tapeout_Date_Other_Participant__c
                       , Tapeout_Date_Customer__c
                       , Projected_1st_Batch_Bare_Die_Ship__c
                       , Projected_1st_Batch_Bare_Die_Ship_Start__c
                       , Projected_2nd_Batch_Bare_Die_Ship_Start__c
                       , Projected_2nd_Batch_Bare_Die_Ship__c 
                       , Projected_1st_Batch_Bare_Die_Ship_End__c
                       , Projected_2nd_Batch_Bare_Die_Ship_End__c
                       , Status__c
                       , Fab__c
                       , Publish__c
                       , Active__c
                       , Reticle_Type__c
                       , Train_Type__c
                       , OwnerId
                       , MPW_Most_Restrictive_Product_ECCN__c
                       , MPW_Most_Restrictive_Technology_ECCN__c    
            FROM       MPW_Train_Maintenance__c
            WHERE      Id = :mpwId
        ];
        
        //check associated MPW Reservation Forms
        this.mpwResfList = [select Id from MPW_Reservation__c where MPW_Train_Name__c =: m.Id];
        if(!mpwResfList.isEmpty()){
            Set<Id> mpwresfidlist = new Set<Id>();
            for(MPW_Reservation__c mpwResf: this.mpwResfList){
                mpwresfidlist.add(mpwResf.Id);
            }
            if(!mpwresfidlist.isEmpty()){
                this.mpwpiqList = [select Id, MPW_Maintenance_Details__c from MPW_Process_Information_Question__c where MPW_Reservation_Form__c IN: mpwresfidlist];
                if(!this.mpwpiqList.isEmpty()){
                    for(MPW_Process_Information_Question__c p: this.mpwpiqList){
                        this.existingTMDIdList.add(p.MPW_Maintenance_Details__c);
                    }
                }
            }
        }
        
        // Check for Associated Accounts
        this.mapAssociatedAccounts = new Map<string, AccountsWrapper>();
        for (MPW_Train_Account__c mta : [SELECT    Id
                                                   , Name
                                                   , Account__c
                                                   , Account__r.Name
                                                   , Account__r.Short_Name__c
                                                   , Account__r.Owner.Name
                                                   , Account__r.Stage__c
                                                   , Account__r.RecordType.Name
                                                   , Account__r.Sub_Type__c
                                                   , Account__r.Region__c
                                                   , Account__r.Financial_Territory__c
                                         FROM      MPW_Train_Account__c
                                         WHERE     MPW_Train__c = :m.Id
                                         ORDER BY  Account__r.Name ASC
                                                   , Account__r.Short_Name__c ASC]) {
            AccountsWrapper aw = new AccountsWrapper();
            aw.id = mta.Id;
            aw.accountId = mta.Account__c;
            aw.accountName = mta.Account__r.Name;
            aw.accountShortName = mta.Account__r.Short_Name__c;
            aw.accountType = mta.Account__r.RecordType.Name;
            aw.accountSubType = mta.Account__r.Sub_Type__c;
            aw.accountRegion = mta.Account__r.Region__c;
            aw.accountTerritory = mta.Account__r.Financial_Territory__c;
            aw.accountOwner = mta.Account__r.Owner.Name;
            this.mapAssociatedAccounts.put(mta.Account__c, aw);
        }
        
        // Update value
        this.associatedAccountsMapSize = this.mapAssociatedAccounts.size();
        
        //check assocatiated reservation forms
        listMPWR = new List<MPW_Reservation__c>();
        UtilClassToGetAllFields util = new UtilClassToGetAllFields();
        String queryFields = util.getAllFields('MPW_Reservation__c');
        String query = 'select '+queryFields+' from MPW_Reservation__c where MPW_Train_Name__c = \''+m.Id+'\' order by Name desc';
        listMPWR = database.query(query);
        
        if(!listMPWR.isEmpty()){
            this.associatedReservationFormSize = listMPWR.size();
        }
        
        return m;
    }
    
    private List<MPW_Train_Maintenance_Details__c> retrieveMPWTrainScheduleDetails(string mpwId) {
        List<MPW_Train_Maintenance_Details__c> tempList = new List<MPW_Train_Maintenance_Details__c>();
        tempList = [
            SELECT    Id
                      , Name
                      , Geometry__c
                      , Process_Type__c
                      , Process_Type__r.Name
                      , MPW_Tech_Module__c
                      , MPW_Tech_Module__r.Module_Name__c
                      , MPW_Tech_Module__r.Module_Description__c
                      , MPW_Tech_Module__r.Question__c
                      , Answers__c
            FROM      MPW_Train_Maintenance_Details__c
            WHERE     MPW_Train_Maintenance__c = :mpwId
            ORDER BY  Geometry__c ASC, Process_Type__r.Name ASC
        ];
        
        // Load data into this.mapSelectedTechModules
        this.mapSelectedTechModules = new Map<string, ProcessTechModulesWrapper>();
        for (MPW_Train_Maintenance_Details__c m : tempList) {
            ProcessTechModulesWrapper p = new ProcessTechModulesWrapper();
            if (!this.mapSelectedTechModules.containsKey(m.Process_Type__c)) {
                p.processId = m.Process_Type__c;
                p.processName = m.Process_Type__r.Name;
                p.mapTMW = new Map<Id, TechModuleWrapper>();
                
            } else {
                p = this.mapSelectedTechModules.get(m.Process_Type__c);
            }
            
            TechModuleWrapper t = new TechModuleWrapper();
            t.isSelected = true;
            t.Id = m.MPW_Tech_Module__c;
            t.moduleName = m.MPW_Tech_Module__r.Module_Name__c;
            t.moduleDescription = m.MPW_Tech_Module__r.Module_Description__c;
            t.question = m.MPW_Tech_Module__r.Question__c;
            t.selectedAnswers = m.Answers__c;
            t.mpwtmd = m;
            p.mapTMW.put(t.Id, t);
            p.mapSize = p.mapTMW.size();
            this.mapSelectedTechModules.put(p.processId, p);
        }

        return tempList;
    }
        
    public List<SelectOption> getProcessGroup() {
        
        processValues = new List<String>();
        List<SelectOption> options = new List<SelectOption>();
        for (MPW_Process_Group__c g : [SELECT   Name
                                        FROM    MPW_Process_Group__c
                                        WHERE   Active__c = true
                                                AND Geometry__c = :this.mpwtm.Geometry__c
                                        ORDER BY  Name ASC]) {
            processValues.add(g.name);
            options.add(new SelectOption(g.Name, g.Name));
        }
        
        return options;
    }
    
    public List<SelectOption> getFab() {

        List<SelectOption> options = new List<SelectOption>();
        if(this.processValues.size() > 0 ){
            String soql =   'SELECT  Fab__c, Name ' +
                            'FROM    MPW_Process_Group__c ' +
                            'WHERE   Active__c = true AND Geometry__c = \'' + mpwtm.Geometry__c + '\' AND ' +
                            (this.mpwtm.Status__c == null  ? 'Name = \'' + processValues[0] + '\'': 'Name = \'' + this.mpwtm.Status__c +'\'' ) + 
                            ' ORDER BY Name ASC';    
            
            for (MPW_Process_Group__c g : database.query(soql)) {
                String fabName = g.Fab__c;
                fabName = fabName.remove('[').remove(']');
                if(fabName.contains(',')){
                    List<String> fabs = fabName.split(',');
                    for(Integer i=0; i<fabs.size(); i++){
                        options.add(new SelectOption(fabs[i], fabs[i]));
                    }
                } else {
                    options.add(new SelectOption(fabName , fabName ));}
            }
        } else {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, 'No mapping is present'));
        }
        return options;
    }
    
    public List<SelectOption> getProcesses() {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('None', '--None--'));
        
        if(this.processValues.size() > 0 ){
            String soql =   'SELECT  Id, Name, Process__c ' +
                            'FROM    MPW_Process_Group__c ' +
                            'WHERE   Active__c = true AND Geometry__c = \'' + mpwtm.Geometry__c + '\' AND ' +
                            (this.mpwtm.Status__c == null  ? 'Name = \'' + processValues[0] + '\'': 'Name = \'' + this.mpwtm.Status__c +'\'' ) + 
                            ' ORDER BY Name ASC';    
            
            List<String> processNames = new List<String>();
            List<String> processNames1 = new List<String>();
            Map<String,Id> processIdMap = new Map<String,Id>();
            List<String> processes = new List<String>();
            String processGroup;
            String name = '';
            
            for (MPW_Process_Group__c g1 : database.query(soql)) {
                processes = new List<String>(); 
                processGroup = g1.Process__c;
                processGroup = processGroup.remove('[').remove(']');
                if(processGroup.contains(',')) {
                    processes = processGroup.split(',');
                    for(Integer i=0; i<processes.size(); i++){
                        String s = processes[i].trim();
                        processNames.add(s);
                       // processNames = processNames.trim();
                    }
                } else {
                    processNames.add(processGroup);
                }
            }
            
            List<MPW_Config_Settings__c> mpwConfig1 = [SELECT Id
                                                              , Name
                                                       FROM MPW_Config_Settings__c
                                                       WHERE Name IN : processNames
                                                             AND Active__c = true
                                                             AND RecordType.DeveloperName = 'Process'
                                                       ORDER BY  Name ASC];
            
            for (MPW_Config_Settings__c m : mpwConfig1) {
                processIdMap.put(m.Name,m.Id);
            }
            
            if(processGroup != null && processGroup.contains(',')) {
                for(Integer i=0; i<processes.size(); i++){
                    String s = processes[i].trim();
                    options.add(new SelectOption(processIdMap.get(s) + ';' + s, s));
                }
            } else if(processGroup != null){
                options.add(new SelectOption(processIdMap.get(processGroup) + ';' + processGroup , processGroup ));}
            }
            else {}
        return options;
    }
    
    //01112016 -- Modified by Poulami Starts
    public void refreshAvailableProcesses() {
        tempNo = null;
        this.mpwtm.Status__c = null;
        this.selectedProcess = 'None';
        this.listTechModules = new List<TechModuleWrapper>();
        this.mapSelectedTechModules = new Map<string, ProcessTechModulesWrapper>();
        Set<String> mpwTrainSet = new Set<String>();
        if (this.tranx == 'Add' && (this.mpwtm.Geometry__c != null && this.mpwtm.Geometry__c != 'None') && this.mpwtm.Train_Type__c == 'GlobalShuttle') {
            //this.mpwtm.Name = retrieveLatestMPWNo();
            mpwTrainSet = retrieveGlobalShuttleMPWTrainList();
            retrieveLatestMPWNo(mpwTrainSet);
            this.mpwtm.Name = mpwNo;
            this.mpwtm.Train_Number__c = this.mpwtm.Name;
        } else if(this.tranx == 'Add' && this.mpwtm.Train_Type__c == 'CustomizedShuttle') {
            //this.mpwtm.Name = retrieveLatestMPWNo();
            mpwTrainSet = retrieveCustomizedShuttleMPWTrainList();
            retrieveLatestMPWNo(mpwTrainSet);
            this.mpwtm.Name = mpwNo;
            this.mpwtm.Train_Number__c = this.mpwtm.Name;
        }
        
    }
    private Set<String> retrieveGlobalShuttleMPWTrainList(){
        List<MPW_Train_Maintenance__c> mpwList = [SELECT ID, Name, Train_Number__c, MPW_Train_No__c from MPW_Train_Maintenance__c WHERE Train_Type__c = 'GlobalShuttle' and Geometry__c =: this.mpwtm.Geometry__c];
        Set<String> mpwTrainSet = new Set<String>();
        for(MPW_Train_Maintenance__c mpwTrainNo : mpwList){
            mpwTrainSet.add(mpwTrainNo.MPW_Train_No__c);
        }
        return mpwTrainSet;
    }
    private Set<String> retrieveCustomizedShuttleMPWTrainList(){
        List<MPW_Train_Maintenance__c> mpwList = [SELECT ID, Name, Train_Number__c, MPW_Train_No__c from MPW_Train_Maintenance__c WHERE Train_Type__c = 'CustomizedShuttle'];
        Set<String> mpwTrainSet = new Set<String>();
        for(MPW_Train_Maintenance__c mpwTrainNo : mpwList){
            mpwTrainSet.add(mpwTrainNo.MPW_Train_No__c);
        }
        return mpwTrainSet;
    }
    private void retrieveLatestMPWNo(Set<String> mpwTrainSet) {
        List<MPW_Train_Maintenance__c> tempList = new List<MPW_Train_Maintenance__c>();
        String query = 'select ID, Train_Number__c ,Name, Geometry__c, CreatedDate, IsNumber__c, Running_Number__c, Train_type__c from MPW_Train_Maintenance__c';            
        if(this.mpwtm.Train_Type__c == 'GlobalShuttle'){
            query += ' where Geometry__c = \''+this.mpwtm.Geometry__c+'\' and Train_Type__c = \''+this.mpwtm.Train_Type__c+'\' and Train_Number__c != \'\' order by CreatedDate desc limit 1 ';
        }
        else if(this.mpwtm.Train_Type__c == 'CustomizedShuttle')  {
            //query += ' where Train_Type__c = \''+this.mpwtm.Train_Type__c+'\' and IsNumber__c = true order by Running_Number__c desc limit 1 ';
            query += ' where Train_Type__c = \''+this.mpwtm.Train_Type__c+'\' and Train_Number__c != \'\' order by CreatedDate desc limit 1 ';
        }  
        tempList = Database.query(query);
        mpwNo = '';
        if (tempList.size() == 1) {
            if(tempList[0].Train_Type__c == 'GlobalShuttle'){
                tempNo = tempNo != NULL ? tempNo : tempList[0].Train_Number__c.replace(MPW_Settings__c.getInstance(this.mpwtm.Geometry__c + '_' + this.mpwtm.Train_Type__c + '_Prefix').Value__c, '');
            }
            else if(tempList[0].Train_Type__c == 'CustomizedShuttle'){
                tempNo = tempNo != NULL ? tempNo : tempList[0].Train_Number__c.replace('MPWCS', '');
            }
            boolean isAssigned = false;
            if(tempNo.length() <= 2){
                tempNo = MPWTrainRunningNumber.calculateRunningNumber(tempNo);
                if(tempNo.length() == 1){
                    tempNo = '0' + tempNo;
                }
                if(tempList[0].Train_Type__c == 'GlobalShuttle'){
                    mpwno = MPW_Settings__c.getInstance(this.mpwtm.Geometry__c + '_' + this.mpwtm.Train_Type__c + '_Prefix').Value__c + tempNo;
                }
                if(tempList[0].Train_Type__c == 'CustomizedShuttle'){
                    mpwno = 'MPWCS'+ tempNo;
                }
                isAssigned = true;
            }
            if(tempNo.length() > 2){
                if(tempNo.isNumeric()){
                    if(tempList[0].Train_Type__c == 'GlobalShuttle'){
                        mpwno = MPW_Settings__c.getInstance(this.mpwtm.Geometry__c + '_' + this.mpwtm.Train_Type__c + '_Prefix').Value__c + 'A0';
                    }
                    if(tempList[0].Train_Type__c == 'CustomizedShuttle'){
                        mpwno = 'MPWCSA0';
                    }
                    isAssigned = true;
                }
            }
            if (!isAssigned) {
                //mpwNo = MPW_Settings__c.getInstance(this.mpwtm.Geometry__c + '_' + this.mpwtm.Train_Type__c + '_Prefix').Value__c + '1';
                if(this.mpwtm.Train_Type__c == 'GlobalShuttle'){
                    mpwNo = MPW_Settings__c.getInstance(this.mpwtm.Geometry__c + '_' + this.mpwtm.Train_Type__c + '_Prefix').Value__c + '00';
                }
                if(this.mpwtm.Train_Type__c == 'CustomizedShuttle'){
                    mpwNo = 'MPWCS00';
                }
            }
        }else{
            if(this.mpwtm.Train_Type__c == 'GlobalShuttle'){               
                //mpwNo = MPW_Settings__c.getInstance(this.mpwtm.Geometry__c + '_' + this.mpwtm.Train_Type__c + '_Prefix').Value__c + '1';
                mpwNo = MPW_Settings__c.getInstance(this.mpwtm.Geometry__c + '_' + this.mpwtm.Train_Type__c + '_Prefix').Value__c + '00';
            }
            else{
                //mpwNo = 'MPWCS01';
                mpwNo = 'MPWCS00';
            }                   
        }
        tempNo = isExist(mpwNo,this.mpwtm.Train_Type__c, mpwTrainSet);
        while( tempNo != 'false' && limits.getQueries()<99){
            retrieveLatestMPWNo(mpwTrainSet);
        }
    }

    private String isExist(String mpwNo, String trainType, Set<String> mpwTrainSet){
        String mpwtrain = '';
        if(mpwTrainSet.contains(mpwNo)){
            if(trainType == 'GlobalShuttle'){
                mpwtrain = mpwNo.replace(MPW_Settings__c.getInstance(this.mpwtm.Geometry__c + '_' + this.mpwtm.Train_Type__c + '_Prefix').Value__c, '');
            }
            if(trainType == 'CustomizedShuttle'){
                mpwtrain = mpwNo.replace('MPWCS', '');
            }
            return mpwtrain;
        }else{
            mpwtrain = 'false';
            return mpwtrain;
        }
    }
    //01112016 -- Modified by Poulami Ends
    
    public void retrieveTechModules() {
        this.listTechModules = new List<TechModuleWrapper>();
        for(MPW_Tech_Module__c m : [SELECT    Id
                                              , Module_Name__c
                                              , Module_Description__c
                                              , Question__c
                                              , Answers__c
                                    FROM      MPW_Tech_Module__c
                                    WHERE     Active__c = true
                                              AND Geometry__c INCLUDES (:this.mpwtm.Geometry__c)
                                    ORDER BY  Module_Name__c ASC]) {
            TechModuleWrapper t = new TechModuleWrapper();
            t.Id = m.Id;
            t.moduleName = m.Module_Name__c;
            t.moduleDescription = m.Module_Description__c;
            t.question = m.Question__c;
            
            if (m.Answers__c != null) {
                for (string s : m.Answers__c.split(';')) {
                    TechModuleAnswersWrapper ta = new TechModuleAnswersWrapper();
                    ta.answer = s;
                    t.listAnswers.add(ta);
                } 
            }   
            
            this.listTechModules.add(t);                     
        }
        
        // Check for existing values
        if (this.selectedProcess != 'None' && this.mapSelectedTechModules.containsKey(this.selectedProcess.split(';')[0])) {
            if (this.mapSelectedTechModules.get(this.selectedProcess.split(';')[0]).mapTMW.size() > 0) {
                Map<Id, TechModuleWrapper> tempMap = this.mapSelectedTechModules.get(this.selectedProcess.split(';')[0]).mapTMW;
                for (TechModuleWrapper t : this.listTechModules) {
                    if (tempMap.containsKey(t.Id)) {
                        t.isSelected = true;
                        t.mpwtmd = tempMap.get(t.Id).mpwtmd;
                        if (t.listAnswers.size() > 0 && tempMap.get(t.Id).selectedAnswers != null) {
                            Set<string> setSelectedAnswers = new Set<string>();
                            setSelectedAnswers.addAll(tempMap.get(t.Id).selectedAnswers.split(','));
                            for (TechModuleAnswersWrapper a : t.listAnswers) {
                                if (setSelectedAnswers.contains(a.answer)) {
                                    a.isSelected = true;
                                } else {
                                    a.isSelected = false;
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    public void addProcess() {
        if (this.selectedProcess != 'None') {
            ProcessTechModulesWrapper p = new ProcessTechModulesWrapper();
            p.processId = this.selectedProcess.split(';')[0];
            p.processName = this.selectedProcess.split(';')[1];
            Map<Id, TechModuleWrapper> tempMap = filterSelectedTechModules();
            p.mapTMW = tempMap;
            p.mapSize = p.mapTMW.size();
            this.mapSelectedTechModules.put(p.processId, p);
        } else {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, 'Please select a Process.'));
            return;
        }
    }
    
    private Map<Id, TechModuleWrapper> filterSelectedTechModules() {
        Map<Id, TechModuleWrapper> tempMap = new Map<Id, TechModuleWrapper>();
        boolean hasErrorMsg = false;
        for (TechModuleWrapper t : this.listTechModules) {
            if (t.isSelected) {
                t.selectedAnswers = '';
                integer ansCtr = 0;
                for (TechModuleAnswersWrapper a : t.listAnswers) {
                    if (a.isSelected) {
                        if (t.selectedAnswers == '') {
                            t.selectedAnswers = a.answer;
                        } else {
                            t.selectedAnswers += ',' + a.answer;
                        }
                        ansCtr++;
                    }
                }
                
                if (ansCtr == 0 && !hasErrorMsg) {
                    ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, 'Every Tech Module selected requires at least one asnwer.'));
                    hasErrorMsg = true;
                } else if (ansCtr > 0) {
                    tempMap.put(t.Id, t);
                }
           }
        }
        
        return tempMap;
    }
    
    public List<ProcessTechModulesWrapper> getSelectedProcessTechModules() {
        return this.mapSelectedTechModules.values();
    }
    
    public void editSelectedProcessModule() {
        this.selectedProcess = ApexPages.currentPage().getParameters().get('processId') + ';' + ApexPages.currentPage().getParameters().get('processName');
        retrieveTechModules();
    }
    
    public void removeSelectedProcessModule() {
       // if(mpwResfList.isEmpty()){
            String processtoremoveId = ApexPages.currentPage().getParameters().get('processId');
            ProcessTechModulesWrapper tempptmw = new ProcessTechModulesWrapper();
            tempptmw = this.mapSelectedTechModules.get(processtoremoveId);
            if(tempptmw.mapTMW.size() > 0){
                for(String key1: tempptmw.mapTMW.keySet()){
                    TechModuleWrapper t = tempptmw.mapTMW.get(key1);
                    if(t.mpwtmd.Id != null){
                        this.mpwtmdDeleteList.add(t.mpwtmd);
                    }
                    else{
                        this.mapSelectedTechModules.remove(processtoremoveId);
                        if (this.selectedProcess == ApexPages.currentPage().getParameters().get('processId') + ';' + ApexPages.currentPage().getParameters().get('processName')) {
                            this.selectedProcess = 'None';
                        }
                    }
                }
            }
            Boolean exist = false;
        if(!this.mpwtmdDeleteList.isEmpty()){
            for(MPW_Train_Maintenance_Details__c d: this.mpwtmdDeleteList){
                if(!this.existingTMDIdList.contains(d.Id)){
                    exist = false;
                }
                else{
                    exist = true;
                    break;
                }
            }
            if(!exist){
                this.mapSelectedTechModules.remove(processtoremoveId);
                if (this.selectedProcess == ApexPages.currentPage().getParameters().get('processId') + ';' + ApexPages.currentPage().getParameters().get('processName')) {
                    this.selectedProcess = 'None';
                }
            }
            else{
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Tech Module is already in use.'));
            }
        }
    }
    
    public PageReference save() {
        PageReference p;
        try {
            // Validate Train Type
            if (this.mpwtm.Train_Type__c == null) {
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, 'Please select a Train Type.'));
                return null;
            }
            
            // Validate MPW Name
            if (this.mpwtm.Name == null) {
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, 'Please provide an MPW Train Schedule Name.'));
                return null;
            }
            
            // Validate Geometry
            if (this.mpwtm.Geometry__c == 'None') {
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, 'Please select a Geometry.'));
                return null;
            }
            
            // Validate Reservation Close Date
            if (this.mpwtm.Publish__c && (this.mpwtm.Reservation_Close_Date__c == null || this.mpwtm.CDRS_Submit_Date__c == null || this.mpwtm.Cancellation_Deadline__c == null || this.mpwtm.GDSII_Cutoff_for_Dry_Run_DRC__c == null || this.mpwtm.Tapeout_Date_Other_Participant__c == null || this.mpwtm.Tapeout_Date_Customer__c == null || this.mpwtm.Status__c == null || this.selectedMonth == '--None--' || this.selectedYear == '--None--' || this.selectedMonth1 == '--None--' || this.selectedYear1 == '--None--' || this.selectedMonth2 == '--None--' || this.selectedYear2 == '--None--' || this.selectedMonth3 == '--None--' || this.selectedYear3 == '--None--')) {
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, 'Please enter all dates.'));
                return null;
            }
            
            // Validate Process
            if (this.mapSelectedTechModules.size() == 0 && this.mpwtm.Active__c && this.mpwtm.Publish__c) {
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, 'Please add at least 1 Process Type before making this MPW Train Active.'));
                return null;
            }
            
            // Validate Associated Account
            if (this.mpwtm.Train_Type__c == 'CustomizedShuttle' && this.mapAssociatedAccounts.size() == 0) {
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, 'Please associate at least 1 Account for Customized Shuttle MPWs.'));
                return null;
            }
            if(this.mpwtm.Fab__c == null){
            }
            
            // Clone
            if (this.tranx == 'Clone') {
                this.mpwtm = this.mpwtm.clone(false, true);
            }
            
            if(this.tranx == 'Edit') {
                if(this.selectedMonth != null) {
                    monthStart1 = this.selectedMonth;
                }
                
                if(this.selectedYear != null && this.selectedYear != '--None--') {
                    yearStart1 = this.selectedYear;
                }
                
                if(this.selectedMonth1 != null) {
                    monthEnd1 = this.selectedMonth1;
                }
                                
                if(this.selectedYear1 != null && this.selectedYear1 != '--None--') {
                    yearEnd1 = this.selectedYear1;
                }
                
                if(this.selectedMonth2 != null) {
                    monthStart2 = this.selectedMonth2;
                }
                
                if(this.selectedYear2 != null && this.selectedYear2 != '--None--') {
                    yearStart2 = this.selectedYear2;
                }
                
                if(this.selectedMonth3 != null) {
                    monthEnd2 = this.selectedMonth3;
                }
                
                if(this.selectedYear3 != null && this.selectedYear3 != '--None--') {
                    yearEnd2 = this.selectedYear3;
                }
                 
            }
            
            // Convert DateTime to PST
            convertToPST();
            //system.debug('this.mpwtm.Tapeout_Date_Customer__c: '+this.mpwtm.Tapeout_Date_Customer__c);
            
            MPW_Geometry_Mapping__c mpwgm = new MPW_Geometry_Mapping__c();
            if(this.mpwtm.Geometry__c != 'None'){
                mpwgm = [select Id, Geometry_ID__c, T2__c, T3__c from MPW_Geometry_Mapping__c where Name =: this.mpwtm.Geometry__c];
                if(mpwgm.Id != null){
                    this.mpwtm.Geometry_ID__c = mpwgm.Geometry_ID__c;  
                    Integer addDay = 0;
                    addDay += Integer.valueOf(mpwgm.T2__c);
                    addDay += Integer.valueOf(mpwgm.T3__c);
                    if(mpwtm.Tapeout_Date_Customer__c != null){
                        this.mpwtm.Lot_Start_Date__c = this.mpwtm.Tapeout_Date_Customer__c.addDays(addDay);
                    }
                    this.mpwtm.MPW_Train_No__c = this.mpwtm.Name;
                }
                else{
                    ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR,'Please select a geometry.'));
                }
            }
            
            
            // Save MPW Train Maintenance            
            upsert this.mpwtm;
            
            // Fresh insert
            this.listMPWTMDetails = new List<MPW_Train_Maintenance_Details__c>();
            for (string key : this.mapSelectedTechModules.keySet()) {
                ProcessTechModulesWrapper ptmw = this.mapSelectedTechModules.get(key);
                if (ptmw.mapTMW.size() > 0) {
                    for (string key1 : ptmw.mapTMW.keySet()) {
                        TechModuleWrapper t = ptmw.mapTMW.get(key1);
                        if(t.isSelected){
                            MPW_Train_Maintenance_Details__c m = new MPW_Train_Maintenance_Details__c();
                            if(t.mpwtmd.Id != null){
                                m = t.mpwtmd;
                                m.Answers__c = t.selectedAnswers;
                            }
                            else{
                                m.MPW_Train_Maintenance__c = this.mpwtm.Id;
                                m.Process_Type__c = ptmw.processId;
                                m.MPW_Tech_Module__c = t.Id;
                                m.Answers__c = t.selectedAnswers;
                            }
                            this.listMPWTMDetails.add(m);
                        }
                    }
                } else {
                    MPW_Train_Maintenance_Details__c m = new MPW_Train_Maintenance_Details__c();
                    m.MPW_Train_Maintenance__c = this.mpwtm.Id;
                    m.Process_Type__c = ptmw.processId;
                    this.listMPWTMDetails.add(m);
                }
            }
            
            
            if (this.listMPWTMDetails.size() > 0) {
                upsert this.listMPWTMDetails;
            }
            
            if(this.mpwtmdDeleteList.size() > 0){
                delete mpwtmdDeleteList;
            }
            
            // Delete existing Account Associations
            if (this.tranx == 'Edit') {
                List<MPW_Train_Account__c> listAccountAssociations = new List<MPW_Train_Account__c>();
                listAccountAssociations = [
                    SELECT    Id
                    FROM      MPW_Train_Account__c
                    WHERE     MPW_Train__c = :this.mpwtm.Id
                ];
                
                if (listAccountAssociations.size() > 0) {
                    delete listAccountAssociations;
                }
            }
            
            // Insert new Account Associations
            if (this.mapAssociatedAccounts.size() > 0) {
                List<MPW_Train_Account__c> tempList = new List<MPW_Train_Account__c>();
                for (string s : this.mapAssociatedAccounts.keySet()) {
                    MPW_Train_Account__c mta = new MPW_Train_Account__c();
                    mta.MPW_Train__c = this.mpwtm.Id;
                    mta.Account__c = this.mapAssociatedAccounts.get(s).accountId;
                    tempList.add(mta);
                }
                
                insert tempList;
            }

            // Go to View page
            p = Page.MPWTrainScheduleTranxVF;
            p.getParameters().put('tranx', 'View');
            p.getParameters().put('id', this.mpwtm.Id);
            p.getParameters().put('tabId', this.selectedTabId);
            p.setRedirect(true);
            
        } catch (Exception ex) {
             String errorMessage = ex.getMessage();
             if(errorMessage.contains('MPW_Train_No__c duplicates value on record with id')) {
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, 'MPW Train already exists. Please enter a different Train number'));
             } else {
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, ex.getMessage()));
             }
        }
        
        return p;
    }
    
    private void convertToPST() {
        // Reservation Close Date
        if (this.mpwtm.Reservation_Close_Date__c != null) {
            this.mpwtm.Reservation_Close_Date__c = convertDateTime(this.mpwtm.Reservation_Close_Date__c);
            system.debug('this.mpwtm.Reservation_Close_Date__c'+this.mpwtm.Reservation_Close_Date__c);
        }
        
        // CDRS Submit Date
        if (this.mpwtm.CDRS_Submit_Date__c != null) {
            this.mpwtm.CDRS_Submit_Date__c = convertDateTime(this.mpwtm.CDRS_Submit_Date__c);
            system.debug('this.mpwtm.CDRS_Submit_Date__c'+this.mpwtm.CDRS_Submit_Date__c);
        }
        
        // GDS II Cutoff
        if (this.mpwtm.GDSII_Cutoff_for_Dry_Run_DRC__c != null) {
            this.mpwtm.GDSII_Cutoff_for_Dry_Run_DRC__c = convertDateTime(this.mpwtm.GDSII_Cutoff_for_Dry_Run_DRC__c);
            system.debug('this.mpwtm.GDSII_Cutoff_for_Dry_Run_DRC__c'+this.mpwtm.GDSII_Cutoff_for_Dry_Run_DRC__c);
        }
        
        // Tapeout Date - Customer
        if (this.mpwtm.Tapeout_Date_Customer__c != null) {
            this.mpwtm.Tapeout_Date_Customer__c = convertDateTime(this.mpwtm.Tapeout_Date_Customer__c);
            system.debug('this.mpwtm.Tapeout_Date_Customer__c'+this.mpwtm.Tapeout_Date_Customer__c);
        }
        
        // Tapeout Date - Other Participant
        if (this.mpwtm.Tapeout_Date_Other_Participant__c != null) {
            this.mpwtm.Tapeout_Date_Other_Participant__c = convertDateTime(this.mpwtm.Tapeout_Date_Other_Participant__c);
            system.debug('this.mpwtm.Tapeout_Date_Other_Participant__c'+this.mpwtm.Tapeout_Date_Other_Participant__c);
        }
        
        // Projected 1st Batch Start
        if (this.mpwtm.Projected_1st_Batch_Bare_Die_Ship_Start__c != null) {
            this.mpwtm.Projected_1st_Batch_Bare_Die_Ship_Start__c = convertDateTime(this.mpwtm.Projected_1st_Batch_Bare_Die_Ship_Start__c);
            system.debug('this.mpwtm.Projected_1st_Batch_Bare_Die_Ship_Start__c'+this.mpwtm.Projected_1st_Batch_Bare_Die_Ship_Start__c);
        }
        
        // Projected 1st Batch End
        if (this.mpwtm.Projected_1st_Batch_Bare_Die_Ship_End__c != null) {
            this.mpwtm.Projected_1st_Batch_Bare_Die_Ship_End__c = convertDateTime(this.mpwtm.Projected_1st_Batch_Bare_Die_Ship_End__c);
            system.debug('this.mpwtm.Projected_1st_Batch_Bare_Die_Ship_End__c'+this.mpwtm.Projected_1st_Batch_Bare_Die_Ship_End__c);
        }
        
        // Projected 2nd Batch Start
        if (this.mpwtm.Projected_2nd_Batch_Bare_Die_Ship_Start__c != null) {
            this.mpwtm.Projected_2nd_Batch_Bare_Die_Ship_Start__c = convertDateTime(this.mpwtm.Projected_2nd_Batch_Bare_Die_Ship_Start__c);
            system.debug('this.mpwtm.Projected_2nd_Batch_Bare_Die_Ship_Start__c'+this.mpwtm.Projected_2nd_Batch_Bare_Die_Ship_Start__c);
        }
        
        // Projected 2nd Batch End
        if (this.mpwtm.Projected_2nd_Batch_Bare_Die_Ship_End__c != null) {
            this.mpwtm.Projected_2nd_Batch_Bare_Die_Ship_End__c = convertDateTime(this.mpwtm.Projected_2nd_Batch_Bare_Die_Ship_End__c);
            system.debug('this.mpwtm.Projected_2nd_Batch_Bare_Die_Ship_End__c'+this.mpwtm.Projected_2nd_Batch_Bare_Die_Ship_End__c);
        }
    }
    
    private void revertToPST() {
        // Reservation Close Date
        if (this.mpwtm.Reservation_Close_Date__c != null) {
            this.mpwtm.Reservation_Close_Date__c = revertDateTime(this.mpwtm.Reservation_Close_Date__c);
        }
        
        // CDRS Submit Date
        if (this.mpwtm.CDRS_Submit_Date__c != null) {
            this.mpwtm.CDRS_Submit_Date__c = revertDateTime(this.mpwtm.CDRS_Submit_Date__c);
        }
        
        // GDS II Cutoff
        if (this.mpwtm.GDSII_Cutoff_for_Dry_Run_DRC__c != null) {
            this.mpwtm.GDSII_Cutoff_for_Dry_Run_DRC__c = revertDateTime(this.mpwtm.GDSII_Cutoff_for_Dry_Run_DRC__c);
        }
        
        // Tapeout Date - Customer
        if (this.mpwtm.Tapeout_Date_Customer__c != null) {
            this.mpwtm.Tapeout_Date_Customer__c = revertDateTime(this.mpwtm.Tapeout_Date_Customer__c);
        }
        
        // Tapeout Date - Other Participant
        if (this.mpwtm.Tapeout_Date_Other_Participant__c != null) {
            this.mpwtm.Tapeout_Date_Other_Participant__c = revertDateTime(this.mpwtm.Tapeout_Date_Other_Participant__c);
        }
        
        // Projected 1st Batch Start
        if (this.mpwtm.Projected_1st_Batch_Bare_Die_Ship_Start__c != null) {
            this.mpwtm.Projected_1st_Batch_Bare_Die_Ship_Start__c = revertDateTime(this.mpwtm.Projected_1st_Batch_Bare_Die_Ship_Start__c);
        }
        
        // Projected 1st Batch End
        if (this.mpwtm.Projected_1st_Batch_Bare_Die_Ship_End__c != null) {
            this.mpwtm.Projected_1st_Batch_Bare_Die_Ship_End__c = revertDateTime(this.mpwtm.Projected_1st_Batch_Bare_Die_Ship_End__c);
        }
        
        // Projected 2nd Batch Start
        if (this.mpwtm.Projected_2nd_Batch_Bare_Die_Ship_Start__c != null) {
            this.mpwtm.Projected_2nd_Batch_Bare_Die_Ship_Start__c = revertDateTime(this.mpwtm.Projected_2nd_Batch_Bare_Die_Ship_Start__c);
        }
        
        // Projected 2nd Batch End
        if (this.mpwtm.Projected_2nd_Batch_Bare_Die_Ship_End__c != null) {
            this.mpwtm.Projected_2nd_Batch_Bare_Die_Ship_End__c = revertDateTime(this.mpwtm.Projected_2nd_Batch_Bare_Die_Ship_End__c);
        }
    }
    
    private DateTime convertDateTime(DateTime pDT) {
        system.debug('pDT:'+pDT);
        string temp = pDT.format('yyyy-MM-dd HH:mm:ss', 'America/Los_Angeles');
        DateTime pstTime = DateTime.valueOf(temp);
        long timeDiff = pDT.getTime() - pstTime.getTime();
        integer seconds = integer.valueOf(timeDiff/1000);
        
        return pstTime.addSeconds(seconds);
    }
    /*private DateTime convertDateTime(DateTime pDT) {
        system.debug('pDT:'+pDT);
        string temp = pDT.format('yyyy-MM-dd HH:mm:ss', 'America/Los_Angeles');
        String[] ss = temp.split(' ');
        String[] st = ss[0].split('-');
        String[] tt = ss[1].split(':');

        Datetime pstTime = Datetime.newInstanceGMT(Integer.valueOf(st[0]),Integer.valueOf(st[1]),Integer.valueOf(st[2]),Integer.valueOf(tt[0]),Integer.valueOf(tt[1]),Integer.valueOf(tt[2]));
        
        return pstTime;
    }*/
    private DateTime revertDateTime(DateTime pDT) {
        string temp = pDT.format('yyyy-MM-dd HH:mm:ss', 'America/Los_Angeles');    
        DateTime pstTime = DateTime.valueOf(temp);
        long timeDiff = pstTime.getTime() - pDT.getTime();
        integer seconds = integer.valueOf(timeDiff/1000);
        
        return pDT.addSeconds(seconds);
    }
    
    // Added By Abhita
    private List<Account_Team_Proxy__c> retreiveAccountTeamProxy(Set<Id> accountIds) {         
        List<Account_Team_Proxy__c> proxyList = new List<Account_Team_Proxy__c>();
      
        proxyList = [select User__c, Account__c from Account_Team_Proxy__c where Account__c IN :accountIds order by Account__c asc];
        
        return proxyList;
    }
    
    public PageReference edit() {
        PageReference p = Page.MPWTrainScheduleTranxVF;
        p.getParameters().put('tranx', 'Edit');
        p.getParameters().put('id', this.mpwtm.Id);
        p.getParameters().put('tabId', this.selectedTabId);
        p.setRedirect(true);
        
        return p;
    }
    
    public PageReference cloneMPW() {
        PageReference p = Page.MPWTrainScheduleTranxVF;
        p.getParameters().put('tranx', 'Clone');
        p.getParameters().put('id', this.mpwtm.Id);
        p.getParameters().put('tabId', this.selectedTabId);
        p.setRedirect(true);
        
        return p;
    }
    
    public PageReference cancel() {
        PageReference p;
        if (this.tranx == 'Add') {
            p = Page.MPWTrainScheduleTabVF;
            p.getParameters().put('sfdc.tabName', this.selectedTabId);
        } else if (this.tranx == 'Edit' || this.tranx == 'Clone') {
            if (this.fromTab != null) {
                p = Page.MPWTrainScheduleTabVF;
                p.getParameters().put('sfdc.tabName', this.selectedTabId);
            } else {
                p = Page.MPWTrainScheduleTranxVF;
                p.getParameters().put('tranx', 'View');
                p.getParameters().put('id', this.mpwtm.Id);
                p.getParameters().put('tabId', this.selectedTabId);
            }
        }
        p.setRedirect(true);
        
        return p;
    }
    
    public void searchAccounts() {
        
        if (this.searchAccountsKey.replace('*', '').replace('%', '').length() < 2) {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, 'Your search term must have 2 or more characters.'));
            return;
        }
        this.listSearchAccounts = new List<AccountsWrapper>();
        for (Account a : [SELECT    Id
                                    , Name
                                    , Short_Name__c
                                    , Owner.Name
                                    , Stage__c
                                    , RecordType.Name
                                    , Sub_Type__c
                                    , Region__c
                                    , Financial_Territory__c
                          FROM      Account
                          WHERE     Name LIKE :'%' + this.searchAccountsKey.replace('*', '') + '%'
                                    AND Id NOT IN :this.mapAssociatedAccounts.keySet()]) {
            AccountsWrapper aw = new AccountsWrapper();
            aw.accountId = a.Id;
            aw.accountName = a.Name;
            aw.accountShortName = a.Short_Name__c;
            aw.accountType = a.RecordType.Name;
            aw.accountSubType = a.Sub_Type__c;
            aw.accountRegion = a.Region__c;
            aw.accountTerritory = a.Financial_Territory__c;
            aw.accountOwner = a.Owner.Name;
            this.listSearchAccounts.add(aw);
        }
    }
    
    public void associateSelectedAccounts() {
        for (AccountsWrapper a : this.listSearchAccounts) {
            if (a.isSelected) {
                this.mapAssociatedAccounts.put(a.accountId, a);
            }
        }
        
        // Refresh
        this.searchAccountsKey = '';
        this.associatedAccountsMapSize = this.mapAssociatedAccounts.size();
        this.listSearchAccounts = new List<AccountsWrapper>();
    }
    
    public boolean getRenderAssociatedAccounts() {
        boolean temp = false;
        if (this.tranx == 'Add' 
            || this.tranx == 'Edit'
            || this.tranx == 'Clone') {
            temp = true;
        } else if (this.tranx == 'View') {
            if(this.mpwtm.Reservation_Close_Date__c != null){
                date tempDate = date.newInstance(this.mpwtm.Reservation_Close_Date__c.year(), this.mpwtm.Reservation_Close_Date__c.month(), this.mpwtm.Reservation_Close_Date__c.day());
                if (!this.isPortalUser && date.today() >= tempDate) {
                    temp = true;
                }
            }
        }
        
        return temp;
    }
    
    public void calculateOtherDates(){
        if(this.mpwtm.Tapeout_Date_Customer__c != null){
            this.mpwtm.Cancellation_Deadline__c = this.mpwtm.Tapeout_Date_Customer__c.addDays(-28);
            this.mpwtm.CDRS_Submit_Date__c = this.mpwtm.Tapeout_Date_Customer__c.addDays(-49);
            this.mpwtm.GDSII_Cutoff_for_Dry_Run_DRC__c = this.mpwtm.Tapeout_Date_Customer__c.addDays(-14);
            this.mpwtm.Reservation_Close_Date__c = this.mpwtm.Tapeout_Date_Customer__c.addDays(-56);
            this.mpwtm.Tapeout_Date_Other_Participant__c = this.mpwtm.Tapeout_Date_Customer__c.addDays(-14);
        }
    }
    
    public class ProcessTechModulesWrapper {
        public string processId {get;set;}
        public string processName {get;set;}
        public Map<Id, TechModuleWrapper> mapTMW {get;set;}
        public integer mapSize {get;set;}
        
        public ProcessTechModulesWrapper() {
            this.mapTMW = new Map<Id, TechModuleWrapper>();
            this.mapSize = 0;
        }
    }
    
    public void removeSelectedAccount() {
        this.mapAssociatedAccounts.remove(ApexPages.currentPage().getParameters().get('accountId'));
        this.associatedAccountsMapSize = this.mapAssociatedAccounts.size();
    }
    
    public class TechModuleWrapper {
        public boolean isSelected {get;set;}
        public string Id {get;set;}
        public string moduleName {get;set;}
        public string moduleDescription {get;set;}
        public string question {get;set;}
        public string selectedAnswers {get;set;}
        public List<TechModuleAnswersWrapper> listAnswers {get;set;}
        public MPW_Train_Maintenance_Details__c mpwtmd{get;set;}
        
        public TechModuleWrapper() {
            this.isSelected = false;
            this.listAnswers = new List<TechModuleAnswersWrapper>();
            this.mpwtmd = new MPW_Train_Maintenance_Details__c();
        }
    }
    
    public class TechModuleAnswersWrapper {
        public boolean isSelected {get;set;}
        public string answer {get;set;}
        
        public TechModuleAnswersWrapper() {
            this.isSelected = true;
        }
    }
    
    public class AccountsWrapper {
        public boolean isSelected {get;set;}
        public string id {get;set;}
        public string accountId {get;set;}
        public string accountName {get;set;}
        public string accountShortName {get;set;}
        public string accountType {get;set;}
        public string accountSubType {get;set;}
        public string accountRegion {get;set;}
        public string accountTerritory {get;set;}
        public string accountOwner {get;set;}
        
        
        public AccountsWrapper() {
            this.isSelected = false;
        }
    }
}