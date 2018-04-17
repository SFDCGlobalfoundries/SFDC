public virtual with sharing class QS_Paginator {
    
    public ApexPages.StandardSetController stdSetController;
    public Integer pageSize {get;set;}
    public List<SelectOption> pageSizeList;
    public Integer pageNumber;
    public Integer totalPageCount;
    public String sortDirection;
    public String sortExp;
    private List<sObject> sObjectList;

    
    /*
        Description:    Constructor
    */
    public QS_Paginator() {
        if(System.Label.Paginator_PageSize != NULL){
            pageSize = Integer.valueOf(System.Label.Paginator_PageSize);
        }else{
            pageSize =10;
        }
        pageNumber = 1;
    }
    
    /*
        Description:    Getter method for current page number
    */
    public Integer getPageNumber() {
        return pageNumber;
    }

    /*
        Description:    Setter method for page number.
                        If page number > total page count, set page number = last page number. If page number <= 0, set page number = 1.
    */
    public void setPageNumber(Integer value) {
        pageNumber = ( value <= 0 || value == NULL) ? 1 : ( ( value  >= totalPageCount ) ? totalPageCount : value );
    }

    /*
        Description:    Returns boolean value that decides whether to enable/disable next page/last page links on the page,
                                using getHasNext() method of standard set controller
    */
    public virtual boolean getDisableNext() {
        if(stdSetController == NULL) {
            return true;
        }else {
            return !(stdSetController.getHasNext());
        }
    }

    /*
        Description:    Returns boolean value that decides whether to enable/disable first page/previous page links on the page,
                        using getHasPrevious() method of standard set controller
    */
    public virtual boolean getDisablePrevious() {
        if(stdSetController == NULL) {
            return true;
        }else {
            return !(stdSetController.getHasPrevious());
        }
    }

    /*
        Description:    Returns total page count based on page size and total number of records
    */
    public virtual Integer getTotalPageCount() {
        if(stdSetController == NULL) {
            return 0;
        }else {
            totalPageCount = (math.mod(stdSetController.getResultSize(), pageSize) > 0) ? ( ( stdSetController.getResultSize() / pageSize ) + 1) : ( stdSetController.getResultSize() / pageSize );
            return totalPageCount;
        }
    }

    /*
        Description:    This method returns the set of records for current page using standard set controller.
        Parameters:     None
        Return type:    List of sObject records
    */
    public List<sObject> getSObjectDataSet() {
        if(stdSetController == NULL) {
            pageNumber = 1;
            return NULL;
        }else {pageNumber = stdSetController.getPageNumber();
            pageNumber = stdSetController.getPageNumber();
            return stdSetController.getRecords();
        }
    }

    /*
        Description:    Setter method for page size
    */
    public virtual void setPageSize(Integer pageSize) {
        stdSetController.setPageSize(pageSize);
    }

   
    /*
        Description:    This method is used to instantiate Standard Set Controller based on records returned by SOQL query.
                                Standard set controller is then used to implement pagination on the visualforce page.
        Parameters: String soql query
        Return type:    void
    */
    public void prepareStdSetController(List<sObject> lstSObject) {
        stdSetController = new ApexPages.StandardSetController(lstSObject);
        setPageSize(pageSize);
        goToPageN(pageNumber);
    }

    /*
        Description:    This method redirects user to the first page of result set
    */
    public virtual void goToFirstPage() {
        stdSetController.first();
    }

    /*
        Description:    This method redirects user to the previous page of result set
    */
    public virtual void goToPreviousPage() {
        stdSetController.previous();
    }

    /*
        Description:    This method redirects user to the next page of result set
    */
    public virtual void goToNextPage() {
        stdSetController.next();
    }

    /*
        Description:    This method redirects user to the last page of result set
    */
    public virtual void goToLastPage() {
        stdSetController.last();
    }

    /*
        Description:    This method redirects user to the Nth page of result set
        Parameter:      Integer page number
        Return type:    void
    */
    public virtual void goToPageN(Integer pageNumber) {
        stdSetController.setPageNumber(pageNumber);
    }
    
    /*
        Description:    This method returns the current start index no of record to display
        Parameter:      void
        Return type:    Integer record number
    */
    public virtual Integer getDisplayRecordStart(){
        return ((stdSetController.getPageNumber() - 1) * stdSetController.getPageSize()) + 1;
    }
    
    /*
        Description:    This method returns the current end index no of record to display
        Parameter:      void
        Return type:    Integer record number
    */
    public virtual Integer getDisplayRecordEnd() {
        if ((stdSetController.getResultSize() - ((stdSetController.getPageNumber() - 1) * stdSetController.getPageSize())) < stdSetController.getPageSize()) {
            return stdSetController.getResultSize();
        } else {
            return stdSetController.getPageNumber() * stdSetController.getPageSize();
        }
    }
}