/*
Author: Shyam Ravindra Nair
Description: Apex class will act as controller to CustomerRequestorLookup page.
History:
SNair     12112014     - code creation
SNair     13112014     - implemented pagination to display search results
*/
public class CustomerRequestorLookupController {

    //String to hold account id
    public String accountID{get;set;}
    //flag to show error
    public Boolean showError{get;set;}
    
    public CustomerRequestorLookupController(){
        showError = false;
        accountID = ApexPages.currentPage().getParameters().get('rec');
        if(accountID == null || accountID == ''){
            showError = true;
            ApexPages.addMessage(new ApexPages.Message(ApexPages.SEVERITY.ERROR,'No customer selected.'));
         }
    } 
            
    //instance of standardsetcontroller from a query locator
    public ApexPages.StandardSetController con{
        get{
            if(con == null){
                con = new ApexPages.StandardSetController(Database.getQueryLocator([select Id, Name, Email from Contact where AccountId =: accountID order by Name]));
                con.setPageSize(10);
            }
            return con;
        }
        set;
    }
    
    //get showError 
    public Boolean getshowError(){
        return showError;
    }
    
    //get the list of contacts
    public List<Contact> getContactList(){
        return (List<Contact>)con.getRecords();    
    }
    
    // indicates whether there are more records after the current page set.
    public Boolean hasNext {
        get {
            return con.getHasNext();
        }
        set;
    }

    // indicates whether there are more records before the current page set.
    public Boolean hasPrevious {
        get {
            return con.getHasPrevious();
        }
        set;
    }

    // returns the page number of the current page set
    public Integer pageNumber {
        get {
            return con.getPageNumber();
        }
        set;
    }

    // returns the first page of records
     public void first() {
         con.first();
     }

     // returns the last page of records
     public void last() {
         con.last();
     }

     // returns the previous page of records
     public void previous() {
         con.previous();
     }

     // returns the next page of records
     public void next() {
         con.next();
     }
     
     public void cancel(){
         con.cancel();
     }
          
}