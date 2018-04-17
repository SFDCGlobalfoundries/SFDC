/*-- 
Type Name: cls_RTeamRoomHomeController class
Author: Global Foundries (Dinesh Suggala) 
Created Date: 14th July 2017
Reason: This Class is used to for pagination and showing the data in pageblock table
Change History:
Author: Dinesh Suggala
Modified Date: 28/2/2018
Reason:Updated the code for redirection of portal user
 --*/
public with sharing class cls_RTeamRoomHomeController {
    
    //public List<Restricted_Team_Room__c> rteamlist{get;set;}
    public String RFilterId {get; set;}
    private Integer pageSize = 10;
    private String baseQuery = 'Select Name,R_Primary_Account__r.Name,RecordType.Name,CreatedDate,CreatedBy.Name FROM Restricted_Team_Room__c ORDER BY NAME ASC';
    public boolean Isportal{get;set;}
    public String stringURL; //Aded by Dinesh
    
    public cls_RTeamRoomHomeController(ApexPages.StandardController controller) {
    // Check if the logged in user is portal user


          stringURL= ApexPages.currentPage().getHeaders().get('Host');           //Added by Dinesh      
          if (stringURL.contains('globalfoundryview')) {
               Isportal= false;
           }
          else{
               Isportal= true;
           }
           
    }

     
    public ApexPages.StandardSetController RSetController {
        get{
            if(RSetController == null){
                RSetController = new ApexPages.StandardSetController(Database.getQueryLocator(baseQuery));
                RSetController.setPageSize(pageSize);

                // We have to set FilterId after Pagesize, else it will not work
                if(RFilterId != null)
                {
                  RSetController.setFilterId(RFilterId);
             
                }
            }
            return RSetController;
        }set;
    }
    
    //Navigate to first Page
    public void firstPage(){
      RSetController.first();
    }

    //Navigate to last Page
    public void lastPage()
    {
      RSetController.last();
    }

    //Navigate to Next page
    public void next()
    {
      if(RSetController.getHasNext())
      {
        RSetController.next();
      }
    }

    //Navigate to Prev Page
    public void prev()
    {
      if(RSetController.getHasPrevious())
      {
        RSetController.previous();
      }
    }

    public List<Restricted_Team_Room__c> getRteamRooms()
    {
      return (List<Restricted_Team_Room__c>)RSetController.getRecords();
    }

    //Get all available list view for Account
    public SelectOption[] getRTeamExistingViews(){
        return RSetController.getListViewOptions();
    }

    /**
    * Reset List View
    */
    public PageReference resetFilter(){
        RSetController = null;
        RSetController.setPageNumber(1);
        return null;
    }
      
    public pagereference newpage(){
		R_Team_Room_SObjectIdsllist__c dp=R_Team_Room_SObjectIdsllist__c.getValues('1');
        String sobjectfield=dp.sObjectId__c;
        R_Team_Room_SObjectIdsllist__c dp1=R_Team_Room_SObjectIdsllist__c.getValues('2');
        String objectthreedigit=dp1.sObjectId__c;
        
        PageReference pageRef = new PageReference('/setup/ui/recordtypeselect.jsp?ent='+sobjectfield+'&save_new_url=%2F'+objectthreedigit+'%2Fe');
		pageRef.setRedirect(true);
        return pageRef;
    }

}