public class ClsCustomerLookupDialog {
    public list<Account> listDisplayedCustomers {get; set;}
    public string searchString {get;set;}
    public integer startPageNum {get;set;}
    public integer endPageNum {get;set;}
    public integer totalRecords {get;set;}
    
	private list<Account> totalCustomerList;
    private SwiftPagination accountPagination;
    private integer PAGESIZE;
    
        
    public ClsCustomerLookupDialog() {
        listDisplayedCustomers = new list<Account>();
        searchString = '';
        string pgSize = Environment_Variable__c.getInstance('SwiftCustomLookupPageSize').Value__c;
        PAGESIZE = string.isBlank(pgSize)?0:integer.valueOf(pgSize);
        startPageNum = 0;
        endPageNum = 0;
        totalRecords = 0;
        totalCustomerList = MRSHandlerUtility.fetchCustomerName();
        totalCustomerList = (totalCustomerList==null)?new list<Account>():totalCustomerList;
        initializePagination(totalCustomerList);
    }
    
    public void searchCustomers() {
        list<Account> tempAccountList = new list<Account>();
        if(!string.isBlank(searchString)) {
            searchString = searchString.trim();
            for(Account a : totalCustomerList) {
                if(a.Name != null && a.Name.containsIgnoreCase(searchString)) {
                    tempAccountList.add(a);
                }
            }
            initializePagination(tempAccountList);
        }
        else {
            initializePagination(totalCustomerList);
        }
    }
    
    private void initializePagination(list<Account> customerList) {
        if(customerList != null) {
        	accountPagination = new SwiftPagination(customerList);
            accountPagination.setPageSize(PAGESIZE);
            totalRecords = accountPagination.getResultSize();
            populatePaginationData();
        }
    }
    
    private void populatePaginationData() {
        listDisplayedCustomers.clear();
        listDisplayedCustomers.addAll((list<Account>)accountPagination.getRecords());
        startPageNum = ((accountPagination.getPageNumber()-1)*PAGESIZE+1);
        startPageNum = (totalRecords==0)?0:startPageNum;
        endPageNum = startPageNum+PAGESIZE-1;
        endPageNum = (endPageNum>totalRecords)?totalRecords:endPageNum;
    }
    public Pagereference goNext() {
        if(accountPagination != null) {
            accountPagination.next();
        }
        populatePaginationData();
        return null;
    }
    
    public Pagereference goPrev() {
        if(accountPagination != null) {
            accountPagination.previous();
        }
        populatePaginationData();
        return null;
    }
    
    public boolean getHasPrevious() {
        if(accountPagination != null) {
            return accountPagination.getHasPrevious();
        }
        return false;
    }
    
    public boolean getHasNext() {
        if(accountPagination != null) {
            return accountPagination.getHasNext();
        }
        return false;
    }
}