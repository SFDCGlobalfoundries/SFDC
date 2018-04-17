/**
 * This is a utility class which can be used to generate pagination on any set of SObject records
 * The method interface is similiar to that of standard set controller except that it can be used in place
 * 1. where standard set controller is not supported, i.e. OpportunityContactRole, Partner type SObject records.
 * 2. Overcomes standard set controller limit of 10000 records. It has the limit of maximum list size supported. 
**/
public class SwiftPagination {
    private List<SObject> listOfRecords;
    private List<SObject> currentSetOfRecords;
    private Integer currentPageNumber;
    private Integer currentPageIndex;
    private Integer pageSize;
    private Integer resultSize;
    
    public SwiftPagination (List<SObject> listOfRecords) {
        this.listOfRecords = new List<SObject>();
        this.listOfRecords.addAll(listOfRecords);
        pageSize = 1;
        currentPageNumber = 1;
        currentPageIndex = 0;
        resultSize = 0;
        currentSetOfRecords = new List<SObject>();
        if(this.listOfRecords != null && !this.listOfRecords.isEmpty()) {
            resultSize = this.listOfRecords.size();
        }
    }
    public Integer getResultSize() {
        return resultSize;
    }
    public void setPageSize(Integer pageSize) {
        this.pageSize = pageSize;
        if(this.pageSize < 1) {
            this.pageSize = 1;
        }
    }
    public Integer getPageNumber() {
        return currentPageNumber;
    }
    public void setPageNumber(Integer pageNum) {
        currentPageNumber = pageNum;
    }
    public List<SObject> getRecords() {
            currentSetOfRecords.clear();
            for(Integer idx = currentPageIndex; idx < (currentPageIndex + pageSize); idx++) {
                if((resultSize == 0) || (idx > (resultSize-1))) {
                    return currentSetOfRecords;
                }
                currentSetOfRecords.add(listOfRecords.get(idx));
            }
        return currentSetOfRecords;
    }
    public void first() {
        currentPageNumber = 1;
        currentPageIndex = 0;
    }
    public void last() {
        currentPageNumber = resultSize/pageSize;
        if(Math.mod(resultSize, pageSize) > 0) {
            currentPageNumber++;
        }
        if(currentPageNumber == 0) {
            currentPageNumber = 1;
        }
        currentPageIndex = (currentPageNumber - 1) * pageSize;
    }
    public void next() {
        currentPageNumber++;
        currentPageIndex += pageSize;
        if(currentPageIndex > (resultSize - 1)) {
            currentPageIndex -= pageSize;
            currentPageNumber--;
        }
    }
    public void previous() {
        currentPageNumber--;
        currentPageIndex -= pageSize;
        if(currentPageIndex < 0) {
            currentPageIndex += pageSize;
            currentPageNumber++;
        }
    }
    
    public Boolean getHasNext() {
        if((currentPageIndex + pageSize) > (resultSize - 1)) {
            return false;
        }
        return true;
    }
    
    public Boolean getHasPrevious() {
        if(currentPageIndex < pageSize) {
            return false;
        }
        return true;
    }
}