/*
* @ Author :- Navneet rajput
* @ Description :- 
* @ Date :-
* @ Change History :-  
**/

public with sharing class WaiverCollaborator4CustomerCls {
	
	
	public list<Wavier_Collaborator__c> lst_WaiverCollaborator {get;set;}

	public list<Wavier_Collaborator__c> getWaiverList(){
		
		if (Collaborator<>NULL){
			lst_WaiverCollaborator = Collaborator.getRecords();
		}
		return lst_WaiverCollaborator;
	}
	
	 public ApexPages.StandardSetController Collaborator {
        get {
            if(Collaborator == null) {
                Collaborator = new ApexPages.StandardSetController(
								Database.getQueryLocator([SELECT Id,Name,PTSR_Number__c,Workflow_Status__c,Progressbar_staus__c,
																 PTSR_Status__c,PTSR_Service_Type__c,DFMServiceOption__c,
																 Waiver_Status__c,Account__r.Name
														 FROM Wavier_Collaborator__c 
														 order by Name DESC]));
                // sets the number of records in each page set
                Collaborator.setPageSize(10);
            }
            return Collaborator;
        }
        set;
    }
	// indicates whether there are more records after the current page set.
    public Boolean hasNext {
        get {
            return Collaborator.getHasNext();
        }
        set;
    }

    // indicates whether there are more records before the current page set.
    public Boolean hasPrevious {
        get {
            return Collaborator.getHasPrevious();
        }
        set;
    }

    // returns the page number of the current page set
    public Integer pageNumber {
        get {
            return Collaborator.getPageNumber();
        }
        set;
    }

    // returns the first page of records
     public void first() {
         Collaborator.first();
     }

     // returns the last page of records
     public void last() {
         Collaborator.last();
     }

     // returns the previous page of records
     public void previous() {
         Collaborator.previous();
     }

     // returns the next page of records
     public void next() {
         Collaborator.next();
     }

     // returns the PageReference of the original page, if known, or the home page.
     public void cancel() {
         Collaborator.cancel();
     }
	
}