/**
* Author        :   Nikhil Jain
* Company       :   Cognizant Technologies PTE Ltd.
* Description   :   Functionality for Mass Insert of Lot Instructions on Lot Request.
* History       :
        Initials        Date                Description
-----------------------------------------------------------------------------------------
        NJain           10/09/2013          Created the Class
        NJain           31-Jul-2015         Removed unwanted codes. Added columns in query.
        RNadella        31/08/2015          Increased integer list size and also added Active flag condition 
                                            to the Query        
        RNadella        31/08/2015          Added Current CRD to the Query to the queryString                                   
**/

public class LotInstruction_MassInsertController{
     
    ApexPages.StandardSetController stdSetController;
    
    //Variable declaration
    public String LotReqId{get;set;}
    public String lotReqName{get;set;}
    public String AccountName{get;set;}
    public String AccountShortName{get;set;}
    public String FabName{get;set;}
    public List<LotInstructionWrapper> lstLotInstructionWrapper{get;set;}
    public Integer numberOfRowToRemove{get;set;}
    
    public boolean showMfgLotTable{get;set;}
    public boolean showLotInstructionTable{get;set;}
    public boolean isChecked{get;set;}
    public String fieldToSearch{get;set;}
    public String textToSearch{get;set;}
    public List<MfgLotWrapper> lstMfgLotWrapper{get;set;}
    
    //for Pagination
    private integer counter=0;  //keeps track of the offset
    private integer list_size=25; //sets the page size or number of rows 
    public integer total_size; //used to show user the total size of the list
        
    List<Manufacturing_Lot__c> lstManufacturingLots = new List<Manufacturing_Lot__c>();
    List<Id> lstExistingMfgLotId = new List<Id>();
    Lot_Request__c lotReqRec;
    
    //Constructor
    public LotInstruction_MassInsertController(ApexPages.StandardSetController stdSetController){
        this.stdSetController = stdSetController;
        showMfgLotTable = false;
        lstMfgLotWrapper = new List<MfgLotWrapper>();

        LotReqId = (Id)ApexPages.currentPage().getParameters().get('id');
        
        lstLotInstructionWrapper = new List<LotInstructionWrapper>();

        if(LotReqId !=null){
            lotReqRec = [SELECT Name,Fab__c, Account__c,Account__r.Name,Account__r.Short_Name__c,
                                New_Customer_Requested_Date_CRD_CSR__c,
                                (SELECT Id,Manufacturing_Lot__c from Request_to_Lot_Tags__r) 
                         FROM Lot_Request__c where id =:LotReqId ];
            lotReqName = lotReqRec.name;
            AccountName= lotReqRec.Account__r.Name;
            FabName    = lotReqRec.Fab__c;
            AccountShortName = lotReqRec.Account__r.Short_Name__c;
            
            for(Lot_Instruction__c existingLotInstrn:lotReqRec.Request_to_Lot_Tags__r){
                lstExistingMfgLotId.add(existingLotInstrn.Manufacturing_Lot__c);
            }
        }    
    }
    
    //Defining the wrapper for Lot Instruction Wrapper 
    public class LotInstructionWrapper{
        public Lot_Instruction__c lotInstrn{get;set;}
        public boolean checkbox{get;set;}
        public date currentCSD{get;set;}
    }        
    
    //Defining the wrapper for Manufacturing Lot Wrapper
    public class MfgLotWrapper{
        public boolean radioButton{get;set;}
        public Manufacturing_Lot__c mfgLotRec{get;set;}
        public MfgLotWrapper(Manufacturing_Lot__c c) {
            mfgLotRec = c;
            radioButton = false;
        }
    }       
    
    //Items on which the Searching can be made on Manufacturing Lot
    public List<SelectOption> getItems() {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('Purchase_Order_Number__c','PO#'));
        options.add(new SelectOption('Sales_Order_Number__c','SO#'));
        options.add(new SelectOption('Customer_Device_Id__c','Customer Device'));
        return options;
    }
    
    //Method for Searching the Manufacturing Lot records as per the search string passed.
    public PageReference searchLots() {
        try {
            lstMfgLotWrapper.clear();
            isChecked = false;
            
            if(textToSearch.trim()!=NULL && textToSearch.trim()!=''){
                
                String queryTotalSize;
                queryTotalSize = 'select id from Manufacturing_Lot__c where Fab_Group__c = \''+ lotReqRec.Fab__c + 
                                 '\' and Account_Name__c = \''+ lotReqRec.Account__c +'\' and ' + 
                                  fieldToSearch + ' like \'' + textToSearch+'%\''+ 
                                 ' and Last_Ship_Date__c = NULL '+
                                 ' and id not in :lstExistingMfgLotId' +
                                 ' and Active_Flag__c=true ';
                
                list<Manufacturing_lot__c> lst_total_size = database.Query(queryTotalSize);
                total_size = lst_total_size.size();
                String queryString;
                system.debug('###########Field To Search#########'+fieldToSearch );
                
                queryString = 'select id,name,Lot_Type__c,Geometry__c, Fab_Group__c,Purchase_Order_Number__c,Ship_to_Customer_Date__c,Last_Ship_Date__c,Account_Name__c,Remaining_Mask_Count__c,'+
                              'Sales_Order_Number__c, Customer_Device_Id__c,Current_Wafer_Quantity_In_Lot__c,Current_Scheduled_Date_CSD__c,Current_Customer_Request_Date_CRD__c  from Manufacturing_Lot__c where Fab_Group__c = \''+
                              lotReqRec.Fab__c + '\' and Account_Name__c = \''+ lotReqRec.Account__c + 
                              '\' and '+fieldToSearch + ' like \'' + textToSearch+'%\''+
                              ' and Last_Ship_Date__c = NULL '+
                              ' and id not in :lstExistingMfgLotId  ' + 
                              ' and Active_Flag__c=true limit  '+
                              string.valueOf(list_size) +' offset '+ string.valueOf(counter);
                
                system.debug('###########queryString #########'+queryString);
                lstManufacturingLots.clear();
                lstManufacturingLots = database.Query(queryString);
                
                for(Manufacturing_Lot__c mfgLot:lstManufacturingLots){
                    MfgLotWrapper mfgWrapperRec = new MfgLotWrapper(mfgLot);
                    lstMfgLotWrapper.add(mfgWrapperRec);
                }
                showMfgLotTable = false;
                if(!lstMfgLotWrapper.isEmpty()){
                    showMfgLotTable = true;
                }
                else{
                    showMfgLotTable = false;
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,'No Matching Manufacturing Lots Found'));
                }
            }
            else{
                 ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Please provide some text'));
                 return null;
            }
            return null;
            
        } catch (QueryException e) {
            ApexPages.addMessages(e);   
            return null;
        }
        return null;
    }
    
    //User clicked beginning
    public PageReference Beginning() { 
      counter = 0;
      searchLots();
      return null;
    }

    //User clicked previous button
    public PageReference Previous() { 
      counter -= list_size;
      searchLots();
      return null;
    }
    
    //User clicked next button
    public PageReference Next() { 
      counter += list_size;
      searchLots();
      return null;
    }
    
    //User clicked end
    public PageReference End() {
      counter = total_size - math.mod(total_size, list_size);
      searchLots();
      return null;
    }
    
    //This will disable the previous and beginning buttons
    public Boolean getDisablePrevious() {
      if (counter>0) 
          return false; 
      else 
          return true;
    }
    
    //This will disable the next and end buttons
    public Boolean getDisableNext() { 
      if (counter + list_size < total_size) 
          return false; 
      else 
          return true;
    }
    
    //This is for total page size
    public Integer getTotal_size() {
      return total_size;
    }
    
    //This will display the current page number
    public Integer getPageNumber() {
      return counter/list_size + 1;
    }
    
    //This will display the total pages
    public Integer getTotalPages() {
      if (math.mod(total_size, list_size) > 0) {
         return total_size/list_size + 1;
      } else {
         return (total_size/list_size);
      }
    }

    //This is used for creating the Lot Instruction rows for the Manufacturing Lot records selected by the user
    public PageReference createRows(){
        boolean anySelected = false;
        for(MfgLotWrapper mfgWrapRec: lstMfgLotWrapper){
            if(mfgWrapRec.radioButton == True){
                Lot_Instruction__c lotInstructionRow = new Lot_Instruction__c();
                LotInstructionWrapper wrapperRec = new LotInstructionWrapper();
                wrapperRec.lotInstrn = lotInstructionRow;
                wrapperRec.lotInstrn.Lot_Request__c = LotReqId;
                wrapperRec.lotInstrn.Manufacturing_Lot__c = mfgWrapRec.mfgLotRec.id;
                wrapperRec.lotInstrn.Account__c = mfgWrapRec.mfgLotRec.Account_Name__c;
                wrapperRec.lotInstrn.Submitted_Customer_Request_Date_CRD__c = lotReqRec.New_Customer_Requested_Date_CRD_CSR__c;
                wrapperRec.checkbox = true;
                wrapperRec.currentCSD = mfgWrapRec.mfgLotRec.Current_Scheduled_Date_CSD__c;
                lstLotInstructionWrapper.add(wrapperRec);
                anySelected = true;
            }        
        }
        if(!anySelected){
            showMfgLotTable = true;
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Please select atleast one Manufacturing Lot'));
            return null;
        }
        if(!lstLotInstructionWrapper.isEmpty()){
            showLotInstructionTable = true;
            showMfgLotTable = false;
            lstMfgLotWrapper.clear();
        }
        else{
            showLotInstructionTable = false;
        }                
        return null;
    }
    
    //For adding an empty Lot Instruction row to the table.
    public PageReference addNewRow(){
        
        Lot_Instruction__c lotInstructionRow = new Lot_Instruction__c();
        LotInstructionWrapper wrapperRec = new LotInstructionWrapper();
        wrapperRec.lotInstrn = lotInstructionRow;
        wrapperRec.lotInstrn.Lot_Request__c = LotReqId;
        wrapperRec.checkbox = true;
        lstLotInstructionWrapper.add(wrapperRec);
        
        if(lstLotInstructionWrapper.size()== 1){
            lstLotInstructionWrapper[0].checkbox = false;
        }
        else{
            lstLotInstructionWrapper[0].checkbox = true;
        }
        return null;
    }
    
    //For removing the Lot Instruction row which has been added to the table.
    public PageReference removeNewObject(){
        if(lstLotInstructionWrapper.size()>1){
            lstLotInstructionWrapper.remove(numberOfRowToRemove);  
        }
        
        if(lstLotInstructionWrapper.size()== 1){
            lstLotInstructionWrapper[0].checkbox = false;
        }else{
            lstLotInstructionWrapper[0].checkbox = true;
        }
        
        showLotInstructionTable = false;
        if(!lstLotInstructionWrapper.isEmpty()){
            showLotInstructionTable = true;
        }
        else{
            showLotInstructionTable = false;
        }
        return null;
    }
    
    // For inserting the Lot Instruction records in one go for all the records selected by the user.
    
    public PageReference Save(){
    
        List<Lot_Instruction__c> lstLotInstrFinal = new List<Lot_Instruction__c>();
        Set<Id> userIds = new Set<Id>();
        
        for(LotInstructionWrapper liRec:lstLotInstructionWrapper){
           lstLotInstrFinal.add(liRec.lotInstrn);
        }      
        transient List<Database.upsertResult> upsertResults = new List<Database.upsertResult>();
        try{
            upsertResults.clear();
            upsertResults = database.upsert(lstLotInstrFinal,true);
            PageReference lotRequestPage = new PageReference('/'+ LotReqId);
            return lotRequestPage;
        }
        catch(Exception e){
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,e.getdmlMessage(0));  
            ApexPages.addMessage(myMsg);
            return null;
        }
        return null;
    }
}