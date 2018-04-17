/*
Author: Cognizant Technology Solutions
Company: 
Description:    This will be the controller class behind the Visualforce Page VFDRTSearch. 
                This will also call the handler class DRTHandlerUtility which will contain all 
                the business logic regarding the DRT Search process. 
History:
    Cognizant     18032014     - Initial Version
    Cognizant     14052014     - Modified SearchDRT() method for handling the selection of All value in the dropdown.
*/

public class DRTSearchExtn
{
    public Id customerName {get;set;}
    
    public String maskSetTitle {get;set;}
    public String maskSetTitleName {get;set;}
    public String drtStatus {get;set;}
    public String drtNumber {get;set;}
    public String drtName {get;set;}
    public String drtType {get;set;}
    public String nextPreviousPage {get;set;}
    public String noRecordToDisplay {get;set;}
    public String renderType {get;  private set;}
    public String columnName {get; set;}
    
    public List<DRT__c> DRTList {get;set;}
    public List<Account> customerNameList {get;set;}
    public List<SelectOption> statusListToDisplay {get;set;}
    public List<Mask_Set_Title__c> maskSetTitleList {get ; set;}
    public List<SelectOption> maskSetTitleOption { get ; set ;}
    public List<SelectOption> drtTypeList {get;set;}
    public List<WrapperDRT> wrapperDRTList {get;set;}
    public List<Integer> totalPageList {get;set;}
    public List<SelectOption> drtNumberList {get;set;}
    public List<SelectOption> noOfRecordsPerPage {get;set;}
    public List<SelectOption> customerNameListToDisplay {get;set;}
    public List<WrapperDRT> drtTodisplay {get;set;}
    public String customerNametoDisplay {get;set;}
    
    public Set<String> statusList {get;set;}
    public Set<String> drtTypeSet {get;set;}

    public Boolean disableCustomerList {get;set;}
    public Boolean isCustomerNameActive {get;set;}
    public Boolean isCustomerListActive {get;set;}
    public Boolean isDrtTableActive {get;set;}
    public Boolean disableList {get;set;}
    public Boolean flagForClass ;
    public Boolean isBreadcrumbActive {get;set;}
    
    public Integer numberOfRecordsPerPage {get;set;}
    public Integer counter {get;set;}
    public Integer countOfTotalDrt {get;set;}
    public Integer totalPages {get;set;}
    public Integer selectedCounter{get;set;}
    public Integer endOfDisplay {get;set;}
    public Integer slno ;
    
    public static String hostName {get; set;}
    public string clickedDRTId {get;set;}
    private boolean mpwOnly;
    
    
    /**
    * @description: This class is used as a wrapper class for showing DRT search results
    **/
    public class WrapperDRT{
        public Integer serialNo {get;set;}
        public String drtName {get;set;}
        public String status {get;set;}
        public String drtStatus {get;set;}
        public Id drtId {get;set;}
        public Boolean isEven {get;set;}
    }
    
    /**
    * @description: This class is used as a wrapper class for Customer list.
    **/
    public class WrapperCustomerList{
        public Id customerId {get;set;}
        public String customerName {get;set;}
    }
    
    /**
    * @description: This is the constructor.
    * @param: ApexPages.StandardController controller
    * @return: none
    **/
    public DRTSearchExtn(ApexPages.StandardController controller) {
        hostName = ApexPages.currentPage().getHeaders().get('Host');
        if(!String.isBlank(Label.SWIFT_Community_URL) && Label.SWIFT_Community_URL.contains(hostName)){
            isBreadcrumbActive = true;
        }
        else {
            isBreadcrumbActive = false;
        }
        
         if(ApexPages.currentPage().getParameters().containsKey('renderType')) {
            renderType = ApexPages.currentPage().getParameters().get('renderType');
        }
        mpwOnly = false;
        customerNameList = new DRTHandlerUtility().fetchCustomers(true);
        
        customerNameListToDisplay = new List<SelectOption>();
        DRTList = new List<DRT__c>();
        drtTypeSet = new Set<String>();
        noOfRecordsPerPage = new List<SelectOption>();
        
        nextPreviousPage = null;
        counter = 1; 
        selectedCounter = 1;
        wrapperDRTList = new List<WrapperDRT>();
        totalPageList = new List<Integer>();
        drtTodisplay  = new List<WrapperDRT>();
        drtTypeList = new List<SelectOption>();
        maskSetTitleOption = new List<SelectOption>();
        drtNumberList = new List<SelectOption>();
        statusListToDisplay = new List<SelectOption>();
        
        numberOfRecordsPerPage = Integer.valueOf(Label.SearchDRTNoOfRecords);
        List<String> lstNoOfRecords = Label.SearchDRTNoOfRecordsFactor.split(';');
        for(String num : lstNoOfRecords){
            noOfRecordsPerPage.add(new SelectOption(num,num));
        }
        // For globalshutte or tdti-mpw user show MPW msts only
        string strGroupMPW = Environment_Variable__c.getInstance('DRTMPWGroup').Value__c;
        string strCreateGroup = Environment_Variable__c.getInstance('DRTCreateGroup').Value__c; 
        string strEditGroup = Environment_Variable__c.getInstance('DRTEditGroup').Value__c;
        string strViewGroup = Environment_Variable__c.getInstance('DRTViewGroup').Value__c;
        string strDRTGroup = strCreateGroup+','+strEditGroup+','+strViewGroup;
        
        list<string> lstDRTGroup = strDRTGroup.split(',');
        string strNonMPWGroup = '';
        if(lstDRTGroup!=null && !lstDRTGroup.isEmpty()){
            for(string gName : lstDRTGroup) {
                if(strGroupMPW!=null && (!strGroupMPW.containsIgnorecase(gName))) {
                    strNonMPWGroup += gName +',';
                }
            }
        }
        
        for(GroupMember gm : [SELECT Id,Group.id,Group.DeveloperName FROM GroupMember WHERE UserOrGroupId = :UserInfo.getUserId()]) {
            if(strGroupMPW.containsIgnoreCase(gm.Group.DeveloperName)) {
                mpwOnly = true;
            }
            else if(strNonMPWGroup.containsIgnoreCase(gm.Group.DeveloperName)){
                mpwOnly = false;
                break;
            }
        }
        if(customerNameList.size() == 1){
            isCustomerNameActive = true;
            disableList = false;
            customerName = customerNameList.get(0).Id;
            customerNametoDisplay = customerNameList.get(0).Name +' '+'('+customerNameList.get(0).Short_Name__c+')';
            if(customerName != null && String.valueOf(customerName)!='' ){
                searchDRT();      
            }
            
        }
        else if(customerNameList!=null && !customerNameList.isEmpty()){
            disableList = true;
            isCustomerNameActive = false;
            isDrtTableActive = false;
            customerNameListToDisplay.add(new SelectOption('',''));
            for(Account accountObject : customerNameList){
                 customerNameListToDisplay.add(new SelectOption(accountObject.Id,accountObject.Name+' '+'('+accountObject.Short_Name__c+')'));
            }    
        }   
    }
    
    /**
    * @description: This method is used in Export to Excel funcationality.
    * @param: none
    * @return: PageReference
    **/
    public PageReference exportToExcel()
    {
        if(String.valueOf(customerName)!='' && customerName!=null)
        {
            Account acc=[select id,name,short_name__c from account where id = :customerName];
            customerNametoDisplay = acc.Name + ' ('+acc.Short_Name__c+')';
        }
        //setting drtType for export to excel
        if(null == drtType || drtType == '' || drtType == 'All'){
            drtType = 'All';
        }
        
        //setting drtStatus for export to excel
        if(null == drtStatus || drtStatus == '' || drtStatus == 'All'){
            drtStatus = 'All';
        }
        return Page.VFDRTSearchToExcel;
     }
    
    /**
    * @description: This method is used in Export to PDF funcationality.
    * @param: none
    * @return: PageReference
    **/
    public PageReference exportToPdf()
    {
        String pdfUrl = '/apex/VFDRTSearchToPdf?renderType=pdf';
        PageReference pgref = new PageReference(pdfUrl);
        pgref.setRedirect(true);
        return pgref ;
    }
    
    /**
    * @description: This method is used to refresh the search results on change of Customer.
    * @param: none
    * @return: void
    **/
    public void searchDRTCustomer(){
        nextPreviousPage = null;
        counter = 1;
        selectedCounter = 1;
        maskSetTitle = null;
        drtType = null;
        drtStatus = null;
        drtNumber = null;
        maskSetTitleOption.clear();
        drtTypeSet.clear();
        statusListToDisplay.clear();
        drtNumberList.clear();
        searchDRT();
    }
    
    /**
    * @description: This method is used to refresh the search results on change of DRT Type.
    * @param: none
    * @return: void
    **/
    public void searchDRTType(){
        nextPreviousPage = null;
        counter = 1;
        selectedCounter = 1;
        drtStatus = null;
        drtNumber = null;
        statusListToDisplay.clear();
        drtNumberList.clear();
        searchDRT();
    }
    
    /**
    * @description: This method is used to refresh the search results on change of Mask Set Title.
    * @param: none
    * @return: void
    **/
    public void searchDRTMST(){
        counter = 1;
        selectedCounter = 1;
        drtType = null;
        drtStatus = null;
        drtNumber = null;
        drtTypeSet.clear();
        statusListToDisplay.clear();
        drtNumberList.clear();
        searchDRT();
    }
    
    /**
    * @description: This method is used to refresh the search results on change of DRT status.
    * @param: none
    * @return: void
    **/
    public void searchDRTStatus(){
        counter = 1;
        selectedCounter = 1;
        drtNumber = null;
        drtNumberList.clear();
        searchDRT();
    }
    
    /**
    * @description: This method is used to refresh the search results on change of DRT Number.
    * @param: none
    * @return: void
    **/
    public void searchDRTNumber() {
        counter = 1;
        selectedCounter = 1;
        searchDRT();
    }
    
    /**
    * @description: This method is used in pagination of search results.
    * @param: none
    * @return: void
    **/
    public void callPagination(){
        counter = 1;
        selectedCounter = 1;
        nextPreviousPage = null;
        pagination();
    }
    
    /**
    * @description: This method is used fetch DRT records according to the search filters selected.
    * @param: none
    * @return: void
    **/
    public void searchDRT(){
        String searchDRTQuery;
        statusList = new Set<String>();
        set<Id> setUniqueMST = new set<Id>();
        Map<String,String> mstMap = new Map<String,String>(); 
        if(String.valueOf(customerName)!='' && customerName!=null) {
            disableList = false;

            searchDRTQuery = 'SELECT Id,Name,Status__c,Type__c,Mask_Set_Title__c,Mask_Set_Title__r.Name FROM DRT__c WHERE Customer_Name__c= :customerName'; 
            
            if(!String.isBlank(drtType) && (drtType!='All')){
                searchDRTQuery += ' AND Type__c= :drtType';
            }
            if(!String.isBlank(maskSetTitle) && (maskSetTitle!='All')){
                searchDRTQuery += ' AND Mask_Set_Title__c = :maskSetTitle';
            }
            else if((string.isBlank(maskSetTitle) || (maskSetTitle=='All')) && mpwOnly) {
                searchDRTQuery += ' AND Mask_Set_Title__r.Name LIKE \'MPW%\' ';
            }
            if(!String.isBlank(drtStatus) && (drtStatus!='All')){
                searchDRTQuery += ' AND Status__c= :drtStatus';
            }
            if(!String.isBlank(drtNumber) && (drtNumber!='All')){
                searchDRTQuery += ' AND Id= :drtNumber' ;
            }
            searchDRTQuery  += ' ORDER BY Name';
            DRTList = Database.query(searchDRTQuery);
            
            if(DRTList!=null && DRTList.size() > 0)
            {
                isDrtTableActive = true;
                
                for(DRT__c drtObject:DRTList) {
                    if(!setUniqueMST.contains(drtObject.Mask_Set_Title__c)) {
                        if(mpwOnly && drtObject.Mask_Set_Title__r.Name != null && drtObject.Mask_Set_Title__r.Name.startsWith('MPW')) {
                            maskSetTitleOption.add(new SelectOption(drtObject.Mask_Set_Title__c,drtObject.Mask_Set_Title__r.Name));
                            setUniqueMST.add(drtObject.Mask_Set_Title__c);
                        }
                        else if(!mpwOnly){
                            maskSetTitleOption.add(new SelectOption(drtObject.Mask_Set_Title__c,drtObject.Mask_Set_Title__r.Name));
                            setUniqueMST.add(drtObject.Mask_Set_Title__c);
                        }
                    }
                    mstMap.put(drtObject.Mask_Set_Title__c,drtObject.Mask_Set_Title__r.Name);
                    statusList.add(drtObject.Status__c);
                    drtTypeSet.add(drtObject.Type__c);
                    drtNumberList.add(new SelectOption(drtObject.Id,drtObject.Name));
                }
                for(String status : statusList){
                    String statusVal;
                    if(status==null) {
                        statusVal = '';
                    }
                    else {
                        statusVal = status;
                    }
                    statusListToDisplay.add(new SelectOption(statusVal,statusVal));
                }
               
                wrapperDRTList.clear();
                WrapperDRT wrapperDRTObject;
                
                slno = 1;
                
                //setting DRT name for export to excel
                if(DRTList != null && !DRTList.isEmpty() && DRTList.size() == 1){
                    DRT__c drt = DRTList[0];
                    drtName = drt.name;
                }else if(null == drtNumber || drtNumber == 'All'){
                    drtName = 'All';
                }
                
                //setting MST name for export to excel
                if(null != maskSetTitle && maskSetTitle != ''){
                        maskSetTitleName = mstMap.get(maskSetTitle);
                }else{
                    maskSetTitleName = 'All';
                }
                
                //setting drtType for export to excel
                if(null == drtType || drtType == 'All'){
                    drtType = 'All';
                }
                
                //setting drtStatus for export to excel
                if(null == drtStatus || drtStatus == 'All'){
                    drtStatus = 'All';
                }
                
                for(DRT__c drtObject:DRTList){
                    wrapperDRTObject = new WrapperDRT();
                    wrapperDRTObject.drtId = drtObject.Id;
                    wrapperDRTObject.serialNo = slno;
                    wrapperDRTObject.drtName = drtObject.Name;
                    wrapperDRTObject.status = drtObject.Status__c;
                    wrapperDRTList.add(wrapperDRTObject);
                    slno = slno+1;
                }
                pagination();
            }
            else {
                wrapperDRTList.clear();
                isDrtTableActive = false;
                noRecordToDisplay = Error_Codes__c.getInstance('NO DRT TO DISPLAY').Message__c;
            }
        }
        else {
            wrapperDRTList.clear();
            maskSetTitleOption.clear();
            statusListToDisplay.clear();
            DRTList.clear();
            drtNumberList.clear();
            disableList = true;
        }
        if((wrapperDRTList == null) || wrapperDRTList.isEmpty()) {
            isDrtTableActive = false;
        }
        else {
            isDrtTableActive = true;
        }   
    }
    
    /**
    * @description: This method is in the pagination functionality of search results.
    * @param: none
    * @return: void
    **/
    public void pagination(){
        flagForClass = true;
        countOfTotalDrt = slno-1;
        
        if(math.mod(countOfTotalDrt,numberOfRecordsPerPage) > 0){
            totalPages =  countOfTotalDrt/numberOfRecordsPerPage + 1;
        }
        else{
            totalPages =  countOfTotalDrt/numberOfRecordsPerPage ;
        }
        
        if(selectedCounter >  totalPages || selectedCounter < 1)
            selectedCounter = 1;
        
        if(wrapperDRTList.size()>0)
            isDrtTableActive =true;
        else
            isDrtTableActive =false;
        if(nextPreviousPage=='next' && nextPreviousPage!=null){
            counter += numberOfRecordsPerPage;
        }
        else if(nextPreviousPage=='previous' && nextPreviousPage!=null && String.valueOf(nextPreviousPage)!=''){
            counter -= numberOfRecordsPerPage;
        }else if(nextPreviousPage=='resetFlag')
        {
            counter =1;
        }else if(nextPreviousPage=='selectedCounter')
        {
            if(selectedCounter == 1)
            {
                counter =  1;
            }else
            {
            counter = (selectedCounter *numberOfRecordsPerPage) - (numberOfRecordsPerPage - 1);
            }
        }

        totalPageList.clear();
        
        for(Integer i=1;i<=totalPages;i++){
            totalPageList.add(i);
        }
        
        drtTodisplay.clear();
        
        
        if(numberOfRecordsPerPage >= countOfTotalDrt){
            endOfDisplay=countOfTotalDrt;
            
        }else if(((countOfTotalDrt+1)-counter) <= numberOfRecordsPerPage){
            endOfDisplay = countOfTotalDrt;
        }
        else if(numberOfRecordsPerPage>= counter){
            endOfDisplay = numberOfRecordsPerPage;
        }else if(counter>numberOfRecordsPerPage)
        {
            endOfDisplay = numberOfRecordsPerPage+counter-1;
        }
        if(wrapperDRTList.size()>0)
        {
            WrapperDRT wrapperObject;
            for(Integer i=counter;i<=endOfDisplay;i++){
                wrapperObject = wrapperDRTList.get(i-1);
                if(flagForClass){
                    wrapperObject.isEven = true;
                    flagForClass = false;
                }
                else {
                    wrapperObject.isEven = false;
                    flagForClass = true;
                }
                drtTodisplay.add(wrapperObject);
            }
            nextPreviousPage = null;
        }
    }
    
    /**
    * @description: This method is used to sort search results based on DRT Name/Status.
    * @param: none
    * @return: void
    **/
    private void sortDRT(String fieldName, Boolean isAscending){        
        String searchDRTQuery;
        if(String.valueOf(customerName)!='' && customerName!=null) {
            disableList = false;
            searchDRTQuery = 'SELECT Id,Name,Status__c,Type__c,Mask_Set_Title__c FROM DRT__c WHERE Customer_Name__c= :customerName';                     
            
            if(!String.isBlank(drtType) && (drtType!='All')){
                searchDRTQuery += ' AND Type__c= :drtType';
            }
            if(!String.isBlank(maskSetTitle) && (maskSetTitle!='All')){
                searchDRTQuery += ' AND Mask_Set_Title__c = :maskSetTitle';
            }
            else if((string.isBlank(maskSetTitle) || (maskSetTitle=='All')) && mpwOnly) {
                searchDRTQuery += ' AND Mask_Set_Title__r.Name LIKE \'MPW%\' ';
            }
            if(!String.isBlank(drtStatus) && (drtStatus!='All')){
                searchDRTQuery += ' AND Status__c= :drtStatus';
            }
            if(!String.isBlank(drtNumber) && (drtNumber!='All')){
                searchDRTQuery += ' AND Id= :drtNumber' ;
            }
            
            if(fieldName  == 'drt') {
                searchDRTQuery  += ' ORDER BY Name';
            }
            else if(fieldName  == 'status') {
                searchDRTQuery  += ' ORDER BY Status__c';
            }
            if(!isAscending) {
                searchDRTQuery  += ' DESC';
            }
            DRTList = Database.query(searchDRTQuery);            
            if(DRTList!=null && DRTList.size() > 0) {
                isDrtTableActive = true;                
                wrapperDRTList.clear();
                WrapperDRT wrapperDRTObject;
                
                slno = 1; 
                for(DRT__c drtObject:DRTList){
                    wrapperDRTObject = new WrapperDRT();
                    wrapperDRTObject.drtId = drtObject.Id;
                    wrapperDRTObject.serialNo = slno;
                    wrapperDRTObject.drtName = drtObject.Name;
                    wrapperDRTObject.status = drtObject.Status__c;
                    wrapperDRTList.add(wrapperDRTObject);
                    slno = slno+1;
                }
                
                pagination();
            }
            else {
                wrapperDRTList.clear();
                isDrtTableActive = false;                
                noRecordToDisplay = Error_Codes__c.getInstance('NO DRT TO DISPLAY').Message__c;
            }
        }
        else {            
             wrapperDRTList.clear();
             DRTList.clear();
             disableList = true;
        }
        if((wrapperDRTList == null) || wrapperDRTList.isEmpty()) {
            isDrtTableActive = false;
        }
        else {
            isDrtTableActive = true;
        }
    }
    
    /**
    * @description: This method is called when clicking on the upper arrow on DRT Name/Status column. Used to sort in ascending order.
    * @param: none
    * @return: Pagereference
    **/
    public Pagereference sortAscending() {
         sortDRT(columnName,true);         
         return null;
    }
    
    /**
    * @description: This method is called when clicking on the down arrow on DRT Name/Status column. Used to sort in descending order.
    * @param: none
    * @return: Pagereference
    **/
    public Pagereference sortDescending() {
         sortDRT(columnName,false); 
         return null;
    }
    
    /**
    * @description: This method is used to open DRT detail page upon clicking on a DRT in search results.
    * @param: none
    * @return: Pagereference
    **/
    public Pagereference openDRT(){
        return new Pagereference('/apex/VFDRTDetail?id='+clickedDRTId+'&urlFromPage=Search');
    }
}