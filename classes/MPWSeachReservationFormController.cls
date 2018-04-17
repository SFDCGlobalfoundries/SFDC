/*
    Author: Abhita Bansal
    Description: This serves as the Extension for MPWSearchReservationFormVF and MPWVSearchScheduleExportCSVVF.
    History: 
        ABansal      06052015    - created
        SNAIR            16102015        - updated logic by using StandardSetController 
                SNAIR            19102015        - updated logic by using StandardSetController 
        Kanishk Singh: MPW-PP142: Clicking Back button in Search MPW Form should preserve the search criteria        
        
*/
public  class MPWSeachReservationFormController {
   
    public List<MPWReservationFormWrapper> listMPWReservationForms{get; set;}
    public Map<Id, list<Id>> feMap{get;set;}
    public Map<Id, list<Id>> amMap{get;set;}
    public Map<Id, list<Id>> csrMap{get;set;}
    public list<SelectOption> pageList{get; set;}
    //public MPW_Train_Maintenance__c mpwTM{get; set;} //Commented by Anil : Feb 16, 2017
    public MPW_Reservation__c mpwResf{get; set;}
    public List<List<string>> listDetails{get; set;}
    public String selectedVal{get; set;}
    public String sortType{get; set;}
    public String sortField{get; set;}
    public String mpwName{get; set;}
    public String feName {get; set;}
    public String custCompanyName {get; set;}
    public String csrName{get; set;}
    public String ownerName{get; set;}
    public boolean isPortalUser{get;set;}
    public boolean isAdmin{get;set;}
    public boolean isCSRProfile{get;set;}
    public String geometrySelectedValue{get;set;}
    public Set<Id> userId{get;set;}
    public Set<Id> mpwPortalFormIds{get;set;}
    public Set<Id> accountIds{get;set;}
    public Set<Id> groupIds{get;set;}
    public List<String> queueNameList{get;set;}
    public boolean hasNext{ get; set;}
    public boolean hasPrevious{ get; set;}
    public Integer psize{get;set;}
    public list<Id> feList{get;set;}
    public list<Id> amList{get;set;}
    public list<Id> csrList{get;set;}   
    public Integer totalNoOfPages{get; set;}
    public Integer pageRemainder{get;set;}
    public integer totalNoOfRecords{get; set;}
    public ApexPages.StandardSetController setController{get;set;}
    public boolean isLoad{get;set;}
    
    public string DIE{get;set;}
    public string WAFER{get;set;}
     
    public Map<String,Map<String,Integer>> mapPrimeExtraDie{get;set;}
    public string strUserSearchFilter=ApexPages.currentPage().getParameters().get('query');
    public string strEncodedUserSearchFilter{get;set;}
    
        
    public MPWSeachReservationFormController(ApexPages.StandardController stdController) { 
       DIE='dieQty';
       WAFER='waferQty';
       if(strUserSearchFilter!=null && strUserSearchFilter!=''){
        	strUserSearchFilter=EncodingUtil.urlDecode(strUserSearchFilter, 'UTF-8');
       }
       
        listMPWReservationForms = new List<MPWReservationFormWrapper>();
        this.queueNameList = new List<String>();
        mpwResf = new MPW_Reservation__c();
        //mpwTM  = new MPW_Train_Maintenance__c(); //Commented by Anil : Feb 16, 2017
        this.listDetails = new List<List<string>>();
        this.accountIds = new Set<Id>();
        mpwPortalFormIds = new Set<Id>();
        this.userId = new Set<Id>();
        groupIds = new Set<Id>();
        feMap = new Map<Id, list<Id>>();
        amMap = new Map<Id, list<Id>>();
        csrMap = new Map<Id, list<Id>>();
        
        this.sortField = 'LastModifiedDate';
        this.sortType = 'DESC';
        
        this.selectedVal = '10';   
        this.isPortalUser = false;
        this.isAdmin = false;
        this.isCSRProfile = false;
        this.isLoad=true;
        
        // CE and Turnkey Queues
        Group sgpTurnkey = getPublicGp('MPW SGP Turnkey Queue');
        Group sgpCEFab7 = getPublicGp('MPW Singapore MPW CE Fab 7 Queue');
        Group sgpCE3E = getPublicGp('MPW Singapore MPW CE Giga+ 3E Queue');
        Group dresdenCE = getPublicGp('MPW Dresden MPW CE Queue');
        Group drsUSTurnkey = getPublicGp('MPW DRS,US Turnkey Queue');
        Group usCE = getPublicGp('MPW US MPW CE Queue');
        
        groupIds.add(sgpTurnkey.Id);
        groupIds.add(sgpCEFab7.Id);
        groupIds.add(sgpCE3E.Id);
        groupIds.add(dresdenCE.Id);
        groupIds.add(drsUSTurnkey.Id);
        groupIds.add(usCE.Id);
        
        checkUser(UserInfo.getUserId());
        
        getpageList();

        //this.mpwTM.Geometry__c = 'None'; //Commented by Anil : Feb 16, 2017
        geometrySelectedValue = 'None';
        this.mpwResf.Form_Status__c = 'None';
        
        // CE and Turnkey Users
        if(isPortalUser == false || isAdmin == true){
            
            for(Id queueId : getUserIds(groupIds)) {
                userId.add(queueId);
            }
        }
        if(isPortalUser == false && isAdmin == false){
            this.queueNameList = retrieveQueueNames();
        }
        getSavedUserSearchFilter();
        searchMethod();
    }
    
    //Kanishk: Save user search filter
 private void saveUserSearchFilter() {
     try {
      
         map < String, string > mapSearch = new Map < String, string > {
             'mpwName' => mpwName,
             'Name' => mpwResf.Name,
             'geometrySelectedValue' => geometrySelectedValue,
             'Form_Status__c' => mpwResf.Form_Status__c,
             'Process_Type__c' => mpwResf.Process_Type__c,
             'feName' => feName,
             'custCompanyName' => custCompanyName,
             'csrName' => csrName,
             'ownerName' => ownerName
         };
        
          set<string> setKey=mapSearch.keySet();
          for(String str:setKey){
          	  if(mapSearch.get(str)==null || mapSearch.get(str)=='' ){
          	  	mapSearch.remove(str);
          	  }
          }
        
         strEncodedUserSearchFilter= EncodingUtil.urlEncode(JSON.Serialize(mapSearch), 'UTF-8');
     } catch (Exception ex) {}
 }

 //Kanishk: get user saved search filter
 private void getSavedUserSearchFilter() {
     if (strUserSearchFilter!=null && strUserSearchFilter!='') {
         map < String, string > mapSearch = (map < String, string > ) JSON.deserialize(strUserSearchFilter, map < String, string > .class);

         mpwName = mapSearch.get('mpwName');
         mpwResf.Name = mapSearch.get('Name');
         geometrySelectedValue = mapSearch.get('geometrySelectedValue');
         mpwResf.Form_Status__c = mapSearch.get('Form_Status__c');
         mpwResf.Process_Type__c = mapSearch.get('Process_Type__c');
         feName = mapSearch.get('feName');
         custCompanyName = mapSearch.get('custCompanyName');
         csrName = mapSearch.get('csrName');
         ownerName = mapSearch.get('ownerName');
     }

 }
   
    
    // to get the size of Records to display on page
    public List<SelectOption> getpageList() {
        pageList = new List<SelectOption>();
        pageList.add(new SelectOption('10', '10'));
        pageList.add(new SelectOption('20', '20'));
        pageList.add(new SelectOption('30', '30'));
        pageList.add(new SelectOption('50', '50'));
        pageList.add(new SelectOption('70', '70'));
        pageList.add(new SelectOption('100', '100'));
        
        return pageList;
    }
    
    public List<String> retrieveQueueNames(){
        List<String> queueNameSet = new List<String>();
        for(GroupMember g: [select Id, Group.Name, UserorGroupId from GroupMember where UserOrGroupId =: userInfo.getUserId()]){
            queueNameSet.add(g.Group.Name);
        }
        return queueNameSet;
    }
    public static Group getPublicGp(String PName){
            Group gp = [Select Type, id From Group where Type= 'Queue' And Name =:PName Limit 1];
            return gp;
    }
    
    public static Set<Id> getUserIds(Set<Id> gpId){
           Set<Id> userList = new Set<Id>();
           for(GroupMember groupMem : [Select UserOrGroupId From GroupMember where GroupId IN :gpId]){
                userList.add(groupMem.UserOrGroupId);
           }
           return userList;
    }
    
    private User checkUser(string userId) {
        User u = [SELECT  UserType
                          , Profile.Name
                          , AccountId
                  FROM    User    
                  WHERE   Id = :userId    
        ];
        
        if (u.UserType == 'CustomerSuccess' || u.UserType == 'PowerCustomerSuccess') {
            this.isPortalUser = true;
        } else {
            this.isPortalUser = false;
        }
        
        if(u.Profile.Name == 'System Administrator' || u.Profile.Name == 'CTS Developers') {
            this.isAdmin = true;
        }
        
        if(u.Profile.Name == 'GF CSR') {
            this.isCSRProfile = true;
        }
        
        
        if(this.isPortalUser && u.AccountId != null) {
            
            retrievePortalAccounts(u.AccountId);
        } 
        return u;
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
    
    private void retrievePortalMPWForms(Set<Id> portalAccountIds) {
            
            for(MPW_Reservation__c mpwAccountForms : [ SELECT Customer_Company_Name__c
                                                              , Id 
                                                       FROM   MPW_Reservation__c 
                                                       WHERE  Customer_Company_Name__c IN :portalAccountIds]){
                    mpwPortalFormIds.add(mpwAccountForms.Id);                                                                                             
            }
            
            
    }
    
    private void retreiveCustomerInformation(list<Id> accountIds) {
        
        List<Account_Team_Proxy__c> proxyListAM = new List<Account_Team_Proxy__c>();
        List<Account_Team_Proxy__c> proxyListFE = new List<Account_Team_Proxy__c>();
        List<Account_Team_Proxy__c> proxyListCSR = new List<Account_Team_Proxy__c>();
        feMap = new Map<Id, list<Id>>();
        amMap = new Map<Id, list<Id>>();
        csrMap = new Map<Id, list<Id>>();
        amList = new List<Id>();
        feList = new List<Id>();
        csrList = new List<Id>();
        
        proxyListAM = [select User__c, User__r.Name,Account__c, Team_Role__c from Account_Team_Proxy__c where Account__c IN :accountIds and Team_Role__c IN ('Account Manager','Primary Account Manager') order by Account__c asc];
        proxyListCSR = [select User__c, User__r.Name,Account__c, Team_Role__c from Account_Team_Proxy__c where Account__c IN :accountIds and Team_Role__c IN ('Customer Service Rep','Primary Customer Service Rep','Backup Customer Service Rep') order by Account__c asc];
        proxyListFE = [select User__c, User__r.Name,Account__c, Team_Role__c from Account_Team_Proxy__c where Account__c IN :accountIds and Team_Role__c IN ('Field Application Engineer','Primary Field Application Engineer') order by Account__c asc];
        
        if(!proxyListAM.isEmpty()){
            Id accAM = proxyListAM[0].Account__c;
            for(Account_Team_Proxy__c p: proxyListAM) {
                if(p.Account__c == accAM) {
                    amList.add(p.User__c);
                } else {
                    amMap.put(accAM, amList);
                    accAM = p.Account__c;
                    amList = new List<Id>();
                    amList.add(p.User__c);
                }
            }
            amMap.put(accAM, amList);
        }
        
        if(!proxyListCSR.isEmpty()){
            Id accCSR = proxyListCSR[0].Account__c;
            for(Account_Team_Proxy__c p: proxyListCSR) {
                if(p.Account__c == accCSR) {
                    csrList.add(p.User__c);
                } else {
                    csrMap.put(accCSR, csrList);
                    accCSR = p.Account__c;
                    csrList = new List<Id>();
                    csrList.add(p.User__c);
                }           
            }
            csrMap.put(accCSR, csrList);
        }
        
        if(!proxyListFE.isEmpty()){
            Id accFE = proxyListFE[0].Account__c;
            for(Account_Team_Proxy__c p: proxyListFE) {
                if(p.Account__c == accFE) {
                    feList.add(p.User__c);
                } else {
                    feMap.put(accFE, feList);
                    accFE = p.Account__c;
                    feList = new List<Id>();
                    feList.add(p.User__c);
                }           
            }
            feMap.put(accFE, feList);
        }
    }
    
    public void geometrySelected() {
         //geometrySelectedValue = mpwTM.Geometry__c; //Commented by Anil : Feb 16, 2017
         if(geometrySelectedValue != null){
            getProcessValues();
         }
    }
    
    public List<SelectOption> getGeometryValues() {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('None','Select Geometry'));
        for(MPW_Geometry_Mapping__c m: [select Id, Name, Sequence_No__c from MPW_Geometry_Mapping__c where Active__c = true and Use_Process_Type__c = true order by Sequence_No__c asc]){
            options.add(new SelectOption(m.Name,m.Name));
        }
        return options;
    }
    
    public List<SelectOption> getProcessValues() {
        List<SelectOption> options = new List<SelectOption>();
        String varProcess = 'Process';
        options.add(new SelectOption('','Select All'));
        if(geometrySelectedValue != null && geometrySelectedValue != 'None'){
            List<MPW_Config_Settings__c> mpwConfig = new List<MPW_Config_Settings__c>();
            String soql = ' Select Id, Name from MPW_Config_Settings__c ' +
                          ' WHERE Active__c = true AND RecordType.DeveloperName = \'' + varProcess + '\' ';
            
            String soqlFilters = '';
            if(geometrySelectedValue != null) {
                soqlFilters = 'AND Name LIKE \'' + geometrySelectedValue + '%\' ';
            }
            
            if (soqlFilters != '') {
                soql = soql + soqlFilters;
            }
          
            soql = soql + 'ORDER BY Name ASC';             
            mpwConfig = database.query(soql);
            
            
            for(MPW_Config_Settings__c config : mpwConfig) {
                options.add(new SelectOption(config.Id, config.Name));
            }    
        }   
        return options;
    }

    //base query
    public String baseQuery{
        get{
            if(baseQuery == null){
                baseQuery = 'Select Extra_Die_Qty__c, MPW_Train_Name__r.Name, MPW_Train_Name__r.Projected_1st_Batch_Bare_Die_Ship_Start__c, MPW_Train_Name__r.Tapeout_Date_Customer__c, MPW_Train_Name__r.Projected_1st_Batch_Bare_Die_Ship_End__c, '+
                              'MPW_Train_Name__r.Projected_1st_Batch_Bare_Die_Ship__c, MPW_Train_Name__r.Lot_Start_Date__c, MPW_Train_Name__c, Name, Geometry__c, Form_Status__c, Process_Type__c, Process_Type__r.Name, FE_Name__r.Name, AM_Name__r.Name, CSR_Name__r.Name, ' +
                              'MPW_Train_Name__r.Cancellation_Deadline__c, Owner.Name, Customer_Company_Name__r.Name, lastModifiedDate, Bare_Die_Ship_Date__c, No_of_Prime_Dies__c, Category__c, ' +
                              'Step_1_Approver_1__c, Step_1_Approver_2__c, Step_1_Approver_3__c, Step_1_Approver_4__c, Step_1_Approver_5__c, Step_1_Approver_6__c, Extra_Die_Qty_Total__c,'+
                              'Step_1_Approver_7__c, Step_1_Approver_8__c, Step_1_Approver_9__c, Step_1_Approver_10__c, Supervisor__c, Approved_Queue__c, '+
                      '(Select Metal_Stack__c,Extra_Die_Qty__c,Extra_Wafer_Qty__c, Prime_Die_Name__c, Drawn_Die_Size_X_um__c, Drawn_Die_Size_Y_um__c,Backgrind__c, Delivery_Qty_Die_Form__c, Delivery_Qty_Wafer_Form__c,' +
                               'Corner_Split__c, POR__c, FF__c, FS__c, SF__c, SS__c, Expedite_In_DIE_Form__c, Expedite_In_WAFER_Form__c, Sub_Devices_Extraction__c, ' +
                               'Turnkey_Service__c, ShortLoop_Wafer__c ' +
                      'from MPW_Prime_Dies__r) ' + 
                      'from MPW_Reservation__c ';
            }
            return baseQuery; 
        }
        set;
    }
    
    //query builder
    public String buildQuery(){
        String query = baseQuery;
        
        if (this.mpwName != null && this.mpwName != '') {
            if(query == baseQuery){
                query += 'where MPW_Train_Name__r.Name LIKE \'%' + this.mpwName.replace('*', '%') + '%\' ';
            }
            else{
                query += 'and MPW_Train_Name__r.Name LIKE \'%' + this.mpwName.replace('*', '%') + '%\' ';
            }
        }
        if (this.mpwResf.Name != null && this.mpwResf.Name != '') {
            if(query == baseQuery){
                query += 'where Name LIKE \'%' + this.mpwResf.Name.replace('*', '%') + '%\' ';
            }
            else{
                query += 'and Name LIKE \'%' + this.mpwResf.Name.replace('*', '%') + '%\' ';
            }
        }
        if(this.mpwResf.Form_Status__c != 'None' && this.mpwResf.Form_Status__c != null){
            if(query == baseQuery){
                query += 'where Form_Status__c = \'' + this.mpwResf.Form_Status__c + '\' ';
            }
            else{
                query += 'and Form_Status__c = \'' + this.mpwResf.Form_Status__c + '\' ';
            }
        }
        if (this.geometrySelectedValue != 'None' && this.geometrySelectedValue != null) {
            if(query == baseQuery){
                query += 'where Geometry__c = \'' + this.geometrySelectedValue + '\' ';
            }
            else{
                query += 'and Geometry__c = \'' + this.geometrySelectedValue + '\' ';
            }
        }
        /* Commented by Anil : Feb 16, 2017
        if (this.mpwTM.Geometry__c != 'None' && this.mpwTM.Geometry__c != null) {
            if(query == baseQuery){
                query += 'where Geometry__c = \'' + this.mpwTM.Geometry__c + '\' ';
            }
            else{
                query += 'and Geometry__c = \'' + this.mpwTM.Geometry__c + '\' ';
            }
        }
        */
        if (this.mpwResf.Process_Type__c != null) {
            if(query == baseQuery){
                query += 'where Process_Type__c = \'' + this.mpwResf.Process_Type__c + '\' ';
            }
            else{
                query += 'and Process_Type__c = \'' + this.mpwResf.Process_Type__c + '\' ';
            }
        }
        if (this.mpwResf.Process_Type__c != null) {
            if(query == baseQuery){
                query += 'where Process_Type__c = \'' + this.mpwResf.Process_Type__c + '\' ';
            }
            else{
                query += 'and Process_Type__c = \'' + this.mpwResf.Process_Type__c + '\' ';
            }
        }
        if (this.feName != null && this.feName != '') {
            if(query == baseQuery){
                query += 'where FE_Name__r.Name LIKE \'%' + this.feName + '%\' ';
            }
            else{
                query += 'and FE_Name__r.Name LIKE \'%' + this.feName + '%\' ';
            }
        }
        if (this.custCompanyName != null && this.custCompanyName != '') {
            if(query == baseQuery){
                query += 'where Customer_Company_Name__r.Name LIKE \'%' + this.custCompanyName + '%\' ';
            }
            else{
                query += 'and Customer_Company_Name__r.Name LIKE \'%' + this.custCompanyName + '%\' ';
            }
        }
        if (this.csrName != null && this.csrName != '') {
            if(query == baseQuery){
                query += 'where CSR_Name__r.Name LIKE \'%' + this.csrName + '%\' ';
            }
            else{
                query += 'and CSR_Name__r.Name LIKE \'%' + this.csrName + '%\' ';
            }
        }
        if (this.ownerName != null && this.ownerName != '') {
            if(query == baseQuery){
                query += 'where Owner.Name LIKE \'%' + this.ownerName + '%\' ';
            }
            else{
                query += 'and Owner.Name LIKE \'%' + this.ownerName + '%\' ';
            }
        }   
        if(this.isPortalUser){
            String category= 'Customer';
            if(query == baseQuery){
                query += 'where Id IN :mpwPortalFormIds AND Category__c = \'' + category + '\' ' ;
            }
            else{
                query += 'and Id IN :mpwPortalFormIds AND Category__c = \'' + category + '\' ' ;
            }             
        } 
        
        //query += ' ORDER BY LastModifiedDate DESC';
        query += ' ORDER BY '+sortField+' '+sortType;
        
        return query; 
    }
    
    public void searchMethod(){
        //formWrapper = null;
        setController = null;
        listMPWReservationForms = null;
        createformWrapper();
        
       if(!isLoad){
        	saveUserSearchFilter();
       }
        isLoad=false;
        //return null;
    }
    
    public void createformWrapper(){
        psize = Integer.valueOf(selectedVal);
        setController = new ApexPages.StandardSetController(Database.getQueryLocator(buildQuery()));
        setController.setPageSize(psize);
        totalNoOfRecords = setController.getResultSize();
        pageRemainder = math.mod(totalNoofRecords,psize);
        if(pageRemainder != 0){
             totalNoOfPages = Integer.valueOf(math.ceil(totalNoofRecords/psize))+1;
        }
        else{
            totalNoOfPages = Integer.valueOf(math.ceil(totalNoofRecords/psize));
        }
        listMPWReservationForms = convertWrapper(setController.getRecords());
        hasNext = setController.getHasNext();
        hasPrevious = setController.getHasPrevious();
    }
    
    public Integer currentPageNo {
        get {
            return setController.getPageNumber();
        }
        set;
    }
    
    private  Map<String,Map<String,Integer>> getExtraDieDetail(set<string> setPrimeDieId){
    	Map<String,Map<String,Integer>> mapPrimeExtraDie=new Map<String,Map<String,Integer>>();
    	
    	for(string str:setPrimeDieId){
    		mapPrimeExtraDie.put(str,new Map<string,Integer>{DIE=>0,WAFER=>0});
    	}
    	
    	for(MPW_Extra_Die__c obj:[select id,MPW_Prime_Die__c,Address1_Quantity_Delivery_In_DIE_Form__c,Address1_Quantity_Delivery_In_WAFER_Form__c from MPW_Extra_Die__c where MPW_Prime_Die__c IN:setPrimeDieId]){
    		
    		Integer address1DieQqty=obj.Address1_Quantity_Delivery_In_DIE_Form__c!=null?Integer.valueOf(obj.Address1_Quantity_Delivery_In_DIE_Form__c):0;
    		Integer address1WaferQqty=obj.Address1_Quantity_Delivery_In_WAFER_Form__c!=null?Integer.valueOf(obj.Address1_Quantity_Delivery_In_WAFER_Form__c):0;
    		
    		if(mapPrimeExtraDie.get(obj.MPW_Prime_Die__c)==null){
    			mapPrimeExtraDie.put(obj.MPW_Prime_Die__c,new Map<string,Integer>{DIE=>0,WAFER=>0});
    		}
    		
    		mapPrimeExtraDie.get(obj.MPW_Prime_Die__c).put(DIE,mapPrimeExtraDie.get(obj.MPW_Prime_Die__c).get(DIE)+address1DieQqty);
    		mapPrimeExtraDie.get(obj.MPW_Prime_Die__c).put(WAFER,mapPrimeExtraDie.get(obj.MPW_Prime_Die__c).get(WAFER)+address1WaferQqty);
    	}
    	
    	
      return mapPrimeExtraDie;	
    }
    
    public List<MPWReservationFormWrapper>  convertWrapper(List<MPW_Reservation__c> mpwResfList){
        
        List<MPWReservationFormWrapper> tempWrapper = new List<MPWReservationFormWrapper>();
        List<Id> accountIds = new List<Id>();
        Set<Id> accIdSetAM = new set<Id>();
        Set<Id> accIdSetCSR = new set<Id>();
        Set<Id> accIdSetFE = new set<Id>();
       
        Set<String> setPrimeDie=new  Set<String>();
        
        for(MPW_Reservation__c mpwResf: mpwResfList){
            if(mpwResf.Category__c == 'Customer' && mpwResf.Customer_Company_Name__c != null){
                accountIds.add(mpwResf.Customer_Company_Name__c);
            }
            if(mpwResf.MPW_Prime_Dies__r!=null){
	            for(MPW_Prime_Die__c obj:mpwResf.MPW_Prime_Dies__r){
	            	setPrimeDie.add(obj.id);
	            }
            }
        }
        
        if(setPrimeDie!=null && setPrimeDie.size()>0){
          mapPrimeExtraDie=getExtraDieDetail(setPrimeDie);	
        }
        
        if(!accountIds.isEmpty()){
            retreiveCustomerInformation(accountIds);
        }
        
        for(MPW_Reservation__c mpw : mpwResfList){
          
          MPWReservationFormWrapper n = new MPWReservationFormWrapper();
            DateTime dtCTD;
            
            accIdSetAM = new set<Id>();
            accIdSetCSR = new set<Id>();
            accIdSetFE = new set<Id>();
            
            n.feName = mpw.FE_Name__r.Name;
            n.amName = mpw.AM_Name__r.Name;
            n.csrName = mpw.CSR_Name__r.Name;
            if(amMap.size() > 0) {
                if(mpw.Customer_Company_Name__c != null && amMap.get(mpw.Customer_Company_Name__c) != null) {
                    for(Id accIdAM : amMap.get(mpw.Customer_Company_Name__c)) {
                        accIdSetAM.add(accIdAM);
                    }
                }
            }
            
            if(feMap.size() > 0) {
                if(mpw.Customer_Company_Name__c != null && feMap.get(mpw.Customer_Company_Name__c) != null) {
                    for(Id accIdFE : feMap.get(mpw.Customer_Company_Name__c)) {
                        accIdSetFE.add(accIdFE);
                    }
                }
            }
            
            if(csrMap.size() > 0) {
                if(mpw.Customer_Company_Name__c != null && csrMap.get(mpw.Customer_Company_Name__c) != null) {
                    for(Id accIdCSR : csrMap.get(mpw.Customer_Company_Name__c)) {
                        accIdSetCSR.add(accIdCSR);
                    }
                }
            }
            
            // Copy Logic
            if(mpw.Category__c == 'Customer') {
                if(this.isPortalUser){
                    if(mpw.FE_Name__c != null && mpw.CSR_Name__c != null && mpw.AM_Name__c != null) {
                        n.isCopy = true;
                    }
                }                
            } else if(mpw.Category__c != 'Customer'){
                if(!this.isPortalUser){
                    n.isCopy = true;
                }
            }
            if(this.isAdmin) {
                 n.isCopy = true;
            }
                     
            // Edit Logic
                if(!this.isPortalUser){ 
                    if(mpw.Form_Status__c == 'Draft') {
                        if(UserInfo.getUserId() == mpw.OwnerId) {
                            n.isEdit = true;
                            if(mpw.MPW_Train_Name__r.Cancellation_Deadline__c != null && mpw.MPW_Train_Name__r.Cancellation_Deadline__c >= datetime.now()) {
                                n.isVoid = true;
                            }
                        }
                        if(UserInfo.getUserId() == mpw.Supervisor__c && mpw.MPW_Train_Name__r.Cancellation_Deadline__c != null && mpw.MPW_Train_Name__r.Cancellation_Deadline__c >= datetime.now()){
                          n.isVoid = true;
                        }
                    } else if(mpw.Form_Status__c == 'Pending FAE Review') {  
                        if(accIdSetFE.contains(UserInfo.getUserId())) {
                            n.isEdit = true;
                        }
                    } else if(mpw.Form_Status__c == 'Accepted by CE' || mpw.Form_Status__c == 'Accepted by MPW Tapeout' || mpw.Form_Status__c == 'Accepted by Turnkey') {   
                        if(accIdSetFE.contains(UserInfo.getUserId()) || mpw.OwnerId == UserInfo.getUserId() || accIdSetAM.contains(UserInfo.getUserId()) || accIdSetCSR.contains(UserInfo.getUserId())) {
                            n.isEdit = true;
                        } else if(userId.contains(UserInfo.getUserId())) {
                            n.isEdit = true;
                        } else if(this.isCSRProfile && mpw.Category__c != 'Customer') {
                            n.isEdit = true;
                        }
                        if(mpw.Approved_Queue__c != null && this.queueNameList.size() > 0){
                            for(String q: this.queueNameList){
                                //if(q == mpw.Approved_Queue__c && mpw.MPW_Train_Name__r.Cancellation_Deadline__c != null && mpw.MPW_Train_Name__r.Cancellation_Deadline__c >= datetime.now()){
                                if(q == mpw.Approved_Queue__c){
                                    n.isVoid = true;
                                }
                            }
                        }
                    }
                }
                
                if(this.isAdmin) {
                      if(mpw.Form_Status__c != 'Void'){
                        n.isEdit = true;  
                      }
                      if(mpw.Form_Status__c == 'Draft' || mpw.Form_Status__c == 'Accepted by CE' || mpw.Form_Status__c == 'Accepted by MPW Tapeout' || mpw.Form_Status__c == 'Accepted by Turnkey'){
                          n.isEdit = true;
                          if(mpw.MPW_Train_Name__r.Cancellation_Deadline__c != null && mpw.MPW_Train_Name__r.Cancellation_Deadline__c >= datetime.now()) {
                              n.isVoid = true;
                          }
                      }
                }
                
                if(this.isPortalUser){
                    if(mpw.FE_Name__c != null && mpw.CSR_Name__c != null && mpw.AM_Name__c != null) {
                        if(mpw.Form_Status__c == 'Draft' || mpw.Form_Status__c == 'Accepted by CE' || mpw.Form_Status__c == 'Accepted by MPW Tapeout' || mpw.Form_Status__c == 'Accepted by Turnkey') {
                            n.isEdit = true;
                            if(UserInfo.getUserId() == mpw.OwnerId && mpw.MPW_Train_Name__r.Cancellation_Deadline__c != null && mpw.MPW_Train_Name__r.Cancellation_Deadline__c >= datetime.now()){
                              n.isVoid = true;
                            }
                            Set<Id> faeuserids = new Set<Id>();
                            if(mpw.Step_1_Approver_1__c != null){
                              faeuserids.add(mpw.Step_1_Approver_1__c);
                            }
                            if(mpw.Step_1_Approver_2__c != null){
                              faeuserids.add(mpw.Step_1_Approver_2__c);
                            }
                            if(mpw.Step_1_Approver_3__c != null){
                              faeuserids.add(mpw.Step_1_Approver_3__c);
                            }
                            if(mpw.Step_1_Approver_4__c != null){
                              faeuserids.add(mpw.Step_1_Approver_4__c);
                            }
                            if(mpw.Step_1_Approver_5__c != null){
                              faeuserids.add(mpw.Step_1_Approver_5__c);
                            }
                            if(mpw.Step_1_Approver_6__c != null){
                              faeuserids.add(mpw.Step_1_Approver_6__c);
                            }
                            if(mpw.Step_1_Approver_7__c != null){
                              faeuserids.add(mpw.Step_1_Approver_7__c);
                            }
                            if(mpw.Step_1_Approver_8__c != null){
                              faeuserids.add(mpw.Step_1_Approver_8__c);
                            }
                            if(mpw.Step_1_Approver_9__c != null){
                              faeuserids.add(mpw.Step_1_Approver_9__c);
                            }
                            if(mpw.Step_1_Approver_10__c != null){
                              faeuserids.add(mpw.Step_1_Approver_10__c);
                            }
                            if(faeuserids.size() > 0){
                              if(faeuserids.contains(UserInfo.getUserId()) && mpw.MPW_Train_Name__r.Cancellation_Deadline__c != null && mpw.MPW_Train_Name__r.Cancellation_Deadline__c >= datetime.now()){
                                n.isVoid = true;
                              }
                            }
                        }
                    }
                    
                }
            if(mpw.MPW_Train_Name__r.Tapeout_Date_Customer__c != null) {
                dtCTD = datetime.newInstance(mpw.MPW_Train_Name__r.Tapeout_Date_Customer__c.Year()+1, mpw.MPW_Train_Name__r.Tapeout_Date_Customer__c.month(), mpw.MPW_Train_Name__r.Tapeout_Date_Customer__c.day())+1;
            }
            // Change Request Logic
            if((mpw.Form_Status__c == 'Accepted by CE' || mpw.Form_Status__c == 'Accepted by MPW Tapeout' || mpw.Form_Status__c == 'Accepted by Turnkey') 
                && ((mpw.MPW_Train_Name__r.Tapeout_Date_Customer__c != null && mpw.MPW_Train_Name__r.Tapeout_Date_Customer__c > datetime.now()) 
                || (mpw.MPW_Train_Name__r.Projected_1st_Batch_Bare_Die_Ship_Start__c != null && mpw.MPW_Train_Name__r.Projected_1st_Batch_Bare_Die_Ship_Start__c > datetime.now()                    
                    && mpw.Category__c != 'FAB' && mpw.Category__c != 'TD' && mpw.MPW_Train_Name__r.Projected_1st_Batch_Bare_Die_Ship__c != 'NA') 
                || (mpw.MPW_Train_Name__r.Projected_1st_Batch_Bare_Die_Ship_Start__c == null && mpw.Category__c != 'FAB' && mpw.Category__c != 'TD' && mpw.MPW_Train_Name__r.Projected_1st_Batch_Bare_Die_Ship__c != 'NA')
                || (mpw.MPW_Train_Name__r.Lot_Start_Date__c != null && mpw.MPW_Train_Name__r.Lot_Start_Date__c > datetime.now() && mpw.Category__c != 'FAB' && mpw.Category__c != 'TD')
                || (mpw.MPW_Train_Name__r.Tapeout_Date_Customer__c != null && (datetime.now() < dtCTD) 
                    && mpw.Category__c != 'FAB' && mpw.Category__c != 'TD'))) {
                n.isChange = true;
            }
            n.mpwReservationForm = mpw;
            tempWrapper.add(n);
        }
        return tempWrapper;
    }
    
    public pageReference getNext(){
        setController.next();
        listMPWReservationForms = convertWrapper(setController.getRecords());
        hasNext = setController.getHasNext();
        hasPrevious = setController.getHasPrevious();
        return null;    
    }   
    
    public PageReference getPrevious(){
        setController.previous();
        listMPWReservationForms = convertWrapper(setController.getRecords());
        hasNext = setController.getHasNext();
        hasPrevious = setController.getHasPrevious();
        return null;
    }
    
    public PageReference getFirst(){
        setController.first();
        listMPWReservationForms = convertWrapper(setController.getRecords());
        hasNext = setController.getHasNext();
        hasPrevious = setController.getHasPrevious();
        return null;
    }
    
    public PageReference getLast(){
        setController.last();
        listMPWReservationForms = convertWrapper(setController.getRecords());
        hasNext = setController.getHasNext();
        hasPrevious = setController.getHasPrevious();
        return null;
    }
    
    public pageReference sortRecords() {
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
        //formWrapper = null;
        setController = null;
        listMPWReservationForms = null;
        createformWrapper();
        return null;    
    }
    
    public PageReference exportCsvFile() {
        // Refresh
        this.listDetails = new List<List<string>>();
        createCsvFile();
        return new PageReference('/apex/MPWVSearchScheduleExportCSVVF');
    }
    
    public void createCsvFile() {
        
        // Create Headers
        List<string> headers = new List<string>();
        headers.add('MPW#,Form#,Company Name,Process Offering,Prime Die Name,Die Size(X),Die Size(Y),GLOBALFOUNDRIES FAE,GLOBALFOUNDRIES Account Manager,GLOBALFOUNDRIES Customer Sales Rep.,Form Status, Extra Die, Last Executed Date,NoOfDies,BareDieShipDate,Backgrind,Metal Stack,Total Quantity(Dies),Total Quantity(Wafer),Initial Quantity(Dies),Initial Quantity(Wafer),CornerSplit,POR,FF,SS,FS,SF,Expedite in Die Form,Expedite in Wafer Form,SubDevideExtraction,TurnkeyServices,ShortLoopWafer\n');
        this.listDetails.add(headers);
        List<string> tempList = new List<string>();
        List<MPW_Reservation__c> tempResfList = new List<MPW_Reservation__c>();
        tempResfList = database.query(buildQuery());
        if(!tempResfList.isEmpty()){
        	
        	Set<String> setPrimeDie=new  Set<String>();
        	 Map<String,Map<String,Integer>> mapPrimeExtraDie=new Map<String,Map<String,Integer>>();
			 
			  for(MPW_Reservation__c mpwResf: tempResfList){
			   if(mpwResf.MPW_Prime_Dies__r!=null){
				    for(MPW_Prime_Die__c obj:mpwResf.MPW_Prime_Dies__r){
				    	setPrimeDie.add(obj.id);
				    }
				}
            }
 
		  if(setPrimeDie!=null && setPrimeDie.size()>0){
		     mapPrimeExtraDie=getExtraDieDetail(setPrimeDie);	
		   }
        	
            for (MPW_Reservation__c mp : tempResfList) {
                String bareDieShipDate = String.valueOf(mp.Bare_Die_Ship_Date__c);
                string detail = '';
                if(mp.MPW_Prime_Dies__r.size() == 0) {
                     detail = (mp.MPW_Train_Name__r.Name != null ? mp.MPW_Train_Name__r.Name : '') + ',' + 
                               mp.Name + ',"' + 
                              (mp.Customer_Company_Name__r.Name != null ? mp.Customer_Company_Name__r.Name : '') + '",' +
                              (mp.Process_Type__r.Name != null ? mp.Process_Type__r.Name: '') + '",' +
                              '' + ',' + '' + ',' +''+','+
                              (mp.FE_Name__r.Name != null ? mp.FE_Name__r.Name : '') + ',' +
                              (mp.AM_Name__r.Name != null ? mp.AM_Name__r.Name : '') + ',' +
                              (mp.CSR_Name__r.Name != null ? mp.CSR_Name__r.Name : '') + ',' +
                               mp.Form_Status__c + ',' +
                               mp.Extra_Die_Qty__c + ',' +  
                               mp.lastModifiedDate + ',' +
                               mp.No_of_Prime_Dies__c + ',' +
                              (bareDieShipDate  != null ? bareDieShipDate : '') + ',' + '\n';
                } 
                else {
                    for(MPW_Prime_Die__c mpd : mp.MPW_Prime_Dies__r) {
                        detail += (mp.MPW_Train_Name__r.Name != null ? mp.MPW_Train_Name__r.Name : '') + ',' + 
                                  mp.Name + ',"' + 
                                 (mp.Customer_Company_Name__r.Name != null ? mp.Customer_Company_Name__r.Name : '') + '",' +
                                 (mp.Process_Type__r.Name != null ? mp.Process_Type__r.Name: '') + '",' +
                                 (mpd.Prime_Die_Name__c != null ? mpd.Prime_Die_Name__c : '') + ',' +
                                 (mpd.Drawn_Die_Size_X_um__c + ',' + mpd.Drawn_Die_Size_Y_um__c) + ',' +
                                 (mp.FE_Name__r.Name != null ? mp.FE_Name__r.Name : '') + ',' +
                                 (mp.AM_Name__r.Name != null ? mp.AM_Name__r.Name : '') + ',' +
                                 (mp.CSR_Name__r.Name != null ? mp.CSR_Name__r.Name : '') + ',' +
                                  mp.Form_Status__c + ',' +
                                  mp.Extra_Die_Qty__c + ',' +
                                  mp.lastModifiedDate + ',' +
                                  mp.No_of_Prime_Dies__c + ',' +
                                 (bareDieShipDate  != null ? bareDieShipDate : '') + ',' + 
                                 (mpd.Backgrind__c != null ? mpd.Backgrind__c : '') + ',' + 
                                 (mpd.Metal_Stack__c != null ? mpd.Metal_Stack__c : '') + ',' + 
                                 (mpd.Delivery_Qty_Die_Form__c != null ? (Integer.valueOf(mpd.Delivery_Qty_Die_Form__c)+mapPrimeExtraDie.get(mpd.id).get(DIE) ): 0) + ',' +
                                 (mpd.Delivery_Qty_Wafer_Form__c != null ? (Integer.valueOf(mpd.Delivery_Qty_Wafer_Form__c)+mapPrimeExtraDie.get(mpd.id).get(WAFER) ):0) + ',' +
                                 (mpd.Delivery_Qty_Die_Form__c != null ? mpd.Delivery_Qty_Die_Form__c : '') + ',' +
                                 (mpd.Delivery_Qty_Wafer_Form__c != null ? mpd.Delivery_Qty_Wafer_Form__c : '') + ',' +
                                 (mpd.Corner_Split__c != null ? mpd.Corner_Split__c : '') + ',' +
                                 (mpd.POR__c != null ? mpd.POR__c : '') + ',' +
                                 (mpd.FF__c != null ? mpd.FF__c : '') + ',' +
                                 (mpd.SS__c != null ? mpd.SS__c: '') + ',' +
                                 (mpd.FS__c != null ? mpd.FS__c : '') + ',' +
                                 (mpd.SF__c != null ? mpd.SF__c : '') + ',' +
                                 (mpd.Expedite_In_DIE_Form__c != null ? mpd.Expedite_In_DIE_Form__c: '') + ',' +
                                 (mpd.Expedite_In_WAFER_Form__c != null ? mpd.Expedite_In_WAFER_Form__c : '') + ',' +
                                 (mpd.Sub_Devices_Extraction__c != null ? mpd.Sub_Devices_Extraction__c : '') + ',' +
                                 (mpd.Turnkey_Service__c != null ? mpd.Turnkey_Service__c : '') + ',' +
                                 (mpd.ShortLoop_Wafer__c != null ? mpd.ShortLoop_Wafer__c : '') + ',' +                             
                                 '\n';  
                    }
                }
                
                if (tempList.size() < 1000) {
                    tempList.add(detail);
                } else {
                    this.listDetails.add(tempList); 
                    tempList = new List<string>();
                }
            }
        }
        if (tempList.size() > 0) {
            this.listDetails.add(tempList);
        }
    }
    
    // Wrapper Class
    public class MPWReservationFormWrapper {
        public boolean isCopy {get;set;}
        public boolean isEdit {get;set;}
        public boolean isChange {get;set;}
        public boolean isVoid{get;set;}
        public MPW_Reservation__c mpwReservationForm {get;set;}
        public String feName {get;set;}
        public String amName {get;set;}
        public String csrName {get;set;}
        
        public MPWReservationFormWrapper(){
            isCopy = false;
            isEdit = false;
            isChange = false;
            isVoid = false;
            mpwReservationForm = new MPW_Reservation__c();
        }
    }

}