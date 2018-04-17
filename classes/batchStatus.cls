public class batchStatus {
    
    public String PageType;
    public string BatchClassName {get;set;}
    public batchStatus (){
        PageType = ApexPages.currentPage().getParameters().get('PageType') ; 
        BatchClassName = PageType == 'ConfigDataUpdate' ? 'CPQConfigDataHandlerBatch': PageType == 'CPQIPUpdate' ? 'BatchProcessIpData' : null; 
    }
    public String getError() {
        return null;
    }
}