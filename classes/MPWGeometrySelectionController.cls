/*
    Author:     Shyam Ravindra Nair
    Purpose:    Apex class which will be controller for MPWGeometrySelectionVF.
        SNAIR       17/07/2015      code created.
        SNAIR       13/10/2015      updated code for MPW Train retrieval.

*/
public class MPWGeometrySelectionController {
    
    public List<SelectOption> mpwTrainOption{get;set;}
    public String geometry{get;set;}
    public String mpwtrain{get;set;}
    public String returnURL{get;set;}
    public Id userId{get;set;}
    public Set<Id> mpwPortalFormIds;
    public Set<Id> mpwPortalFormIds1;
    public Set<Id> accountIds;
    public Boolean isPortalUser;
    
    
    public MPWGeometrySelectionController(){
        this.isPortalUser = false;
        this.accountIds = new Set<Id>();
        this.mpwPortalFormIds = new Set<Id>();
        this.mpwPortalFormIds1 = new Set<Id>();
        this.mpwTrainOption = new List<SelectOption>();
        this.mpwTrainOption.add(new SelectOption('None','Select Schedule'));
        this.returnURL = ApexPages.currentPage().getParameters().get('retURL');
        this.userId = userInfo.getUserId();
        getPortalInfoUser(this.userId);
        system.debug('isPortalUser: '+this.isPortalUser);
    }
    
    private void getPortalInfoUser(Id portalUserId){
            User userInfo = [ SELECT        Id
                                            , AccountId
                                            , UserType
                              FROM          User
                              WHERE         Id =: portalUserId];
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
    
    /*public boolean getIsPortalType(){
        return isPortalUser;
    }*/
    
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
            
    }
    
    public List<SelectOption> getGeometryList(){
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('None','Select Geometry'));
        for(MPW_Geometry_Mapping__c m: [select Id, Name, Sequence_No__c from MPW_Geometry_Mapping__c where Active__c = true and Use_Process_Type__c = true order by Sequence_No__c asc]){
            options.add(new SelectOption(m.Name,m.Name));
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
    
    public void retreiveTrainOptions(){
        DateTime todayDT = convertDateTime(DateTime.now());
        this.mpwTrainOption = new List<SelectOption>();
        List<MPW_Train_Maintenance__c> mtmList = new List<MPW_Train_Maintenance__c>();
        this.mpwTrainOption.add(new selectOption('None', 'Select Schedule'));
        String query = 'SELECT Id, Name, Train_Type__c, Publish__c, Active__c, Geometry__c, Reservation_Open_Date__c, Reservation_Close_Date__c, Projected_2nd_Batch_Bare_Die_Ship_End__c FROM MPW_Train_Maintenance__c WHERE Active__c = true AND Publish__c = true AND Geometry__c = \''+this.geometry+'\' and Projected_2nd_Batch_Bare_Die_Ship_End__c != null';
        /*if(!isPortalUser){
            query += 'AND Reservation_Close_Date__c >=: todayDT ';
        }
        else if(isPortalUser){
            String trainGlobal = 'GlobalShuttle';
            String trainCustomized = 'CustomizedShuttle';
            //query += 'AND ((Train_Type__c = \'' + trainGlobal + '\' AND Id IN :mpwPortalFormIds) OR (Train_Type__c = \'' + trainCustomized + '\' AND Id IN :mpwPortalFormIds AND Reservation_Close_Date__c >=: todayDT) OR (Train_Type__c = \'' + trainGlobal + '\' AND Id NOT IN :mpwPortalFormIds AND Id NOT IN :mpwPortalFormIds1 AND Reservation_Close_Date__c >=: todayDT))' + ' ';
            query += 'AND ((Train_Type__c = \'' + trainGlobal + '\' AND Id IN :mpwPortalFormIds) OR (Train_Type__c = \'' + trainCustomized + '\' AND Id IN :mpwPortalFormIds) OR (Train_Type__c = \'' + trainGlobal + '\' AND Id NOT IN :mpwPortalFormIds AND Id NOT IN :mpwPortalFormIds1))' + ' ';
        }*/
        mtmList = Database.query(query);

        //Added By Abhita
        if(this.isPortalUser) {  
        	Datetime projectedEndDate;
        	List<MPW_Train_Maintenance__c> tempList = new List<MPW_Train_Maintenance__c>();
        	
            List<MPW_Train_Maintenance__c> mtmList1 = new List<MPW_Train_Maintenance__c>();    
            if(!mtmList.isEmpty()){
                for(MPW_Train_Maintenance__c mtp : mtmList) {
                	if(mtp.Projected_2nd_Batch_Bare_Die_Ship_End__c.day() == 1) {
	                	projectedEndDate = mtp.Projected_2nd_Batch_Bare_Die_Ship_End__c.addDays(13);
	                }          
	                else{
	                	projectedEndDate = mtp.Projected_2nd_Batch_Bare_Die_Ship_End__c;
	                }
	                if(projectedEndDate >= todayDT){
	                	tempList.add(mtp);
	                }
                	/*if(mtp.Train_Type__c == 'GlobalShuttle' && mpwPortalFormIds.contains(mtp.Id)) {           
                        mtmList1.add(mtp);      
                    } else if(mtp.Train_Type__c == 'GlobalShuttle' && !mpwPortalFormIds.contains(mtp.Id) && !mpwPortalFormIds1.contains(mtp.Id) && mtp.Reservation_Close_Date__c >= todayDT) {          
                        mtmList1.add(mtp);           
                    } else if(mtp.Train_Type__c == 'CustomizedShuttle' && mpwPortalFormIds.contains(mtp.Id) && mtp.Reservation_Close_Date__c >= todayDT) {           
                        mtmList1.add(mtp);            
                    }*/
                }
                if(!tempList.isEmpty()){
                	for(MPW_Train_Maintenance__c mpwTrain: tempList){
                		/*if (mpwTrain.Reservation_Close_Date__c != null) {
		                    mpwTrain.Reservation_Close_Date__c = revertDateTime(mpwTrain.Reservation_Close_Date__c);
		                }*/
		                
		                if(mpwTrain.Train_Type__c == 'CustomizedShuttle' && mpwPortalFormIds.contains(mpwTrain.Id) && mpwTrain.Reservation_Close_Date__c >= todayDT) { 
	                    	mtmList1.add(mpwTrain);
	                    }    
	                    if((mpwTrain.Train_Type__c == 'GlobalShuttle' && mpwTrain.Reservation_Close_Date__c >= todayDT) || (mpwTrain.Train_Type__c == 'GlobalShuttle' && mpwTrain.Reservation_Close_Date__c < todayDT && mpwPortalFormIds.contains(mpwTrain.Id))){
	                    	mtmList1.add(mpwTrain);
	                    }
                	}
                }
                
            }
            mtmList = new List<MPW_Train_Maintenance__c>();
            if(!mtmList1.isEmpty()) {               
                for(MPW_Train_Maintenance__c mtp : mtmList1) {
                    mtmList.add(mtp);
                }
            }
        }
        
        if(!mtmList.isEmpty()){
            for(MPW_Train_Maintenance__c mtm: mtmList){
                this.mpwTrainOption.add(new selectOption(mtm.Id, mtm.Name)); 
            }
        }
        else{
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,'No MPW Train Schedules are available for selected Geometry.'));
        }
    }
    
    private DateTime revertDateTime(DateTime pDT) {
        string temp = pDT.format('yyyy-MM-dd HH:mm:ss', 'America/Los_Angeles');    
        DateTime pstTime = DateTime.valueOf(temp);
        long timeDiff = pstTime.getTime() - pDT.getTime();
        integer seconds = integer.valueOf(timeDiff/1000);
        
        return pDT.addSeconds(seconds);
    }
    
    public List<SelectOption> getMPWTrainList(){
        return this.mpwTrainOption; 
    }
    
    public pageReference back(){
        pageReference pgRef = new pageReference(this.returnURL);
        pgRef.setRedirect(true);
        return pgRef;
    }
    
    public pageReference go(){
        system.debug('this.geometry: '+this.geometry);
        system.debug('this.mpwtrain: '+this.mpwtrain);
        if(this.geometry == 'None' && this.mpwtrain == 'None'){
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,'Please select Geometry and MPW Train Number.'));
            return null;
        }
        else{
            pageReference pgRef = new pageReference('/apex/MPWReservationFormVF?mpwId='+this.mpwtrain+'&mode=Edit&intpoint=mydevices&retURL='+this.returnURL);
            pgRef.setRedirect(true);
            return pgRef;
        }
    }

}