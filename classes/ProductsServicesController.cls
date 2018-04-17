/*
 Class Name:         ProductsServicesController
 Author:             Prosenjit Saha
 Created Date:       12-June-2014
 Modified Date:      16-June-2014
 Reason:             This class is responsible for showing the Proposals and other details of the Products and Services tab.
 Change History:     
 Author:             
 Modified Date: 
 Reason: 
 …….. 
 ……..
*/
public with sharing class ProductsServicesController{
    public String checkLink {get;set;} //to get the type link to display in the iframe.
    public integer counter=0;  //keeps track of the offset
    //sets the page size or number of rows
    public integer listSize=Integer.valueOf(EnvironmentVariable.get('PROPOSAL_LIST_SIZE')); 
    public List<Apttus_Proposal__Proposal__c> ProposalList {get;set;} //final proposal list based on the query 
    public String SortDirection {get; set;} // this variable set the direction of the proposal records. desc or asc
    private String szSortExp = null;  // variable to set the sort expression.
    public integer totalSize; //used to show user the total size of the list
    Public Map<ID,IP_Declaration_Form__c> MapIPDecData {get;set;} // Stores IP Declaration data.
    
    /*
    @Method Name:    Constructor ( ProductsServicesController)
    @Return Type:    NA
    @parameter:      NA
    @Reason:         Constructor of the VF page ProductsServicesTab
    */
    public ProductsServicesController(){        
        checkLink = ApexPages.currentPage().getParameters().get('name');
        totalSize = [select count() from Apttus_Proposal__Proposal__c ]; //total size of all the proposals. 
        //query on the proposals to populate values in the page. 
        queryProposals();    
    }
    
    /*
    @Method Name:    Beginning
    @Return Type:    PageReference 
    @parameter:      NA
    @Reason:         Method to return the user to the intial proposal record display.
    */
    public PageReference Beginning() { //user clicked beginning
        counter = 0;
        queryProposals();
        return null;
    }
    
    /*
    @Method Name:    Previous
    @Return Type:    PageReference 
    @parameter:      NA
    @Reason:         Method to return the user to the previous proposal record display.
    */
    public PageReference Previous() { //user clicked previous button
        counter -= listSize;
        queryProposals();
        return null;
    }
    
    /*
    @Method Name:    Next
    @Return Type:    PageReference 
    @parameter:      NA
    @Reason:         Method to return the user to the next proposal record display.
    */
    public PageReference Next() { //user clicked next button
        counter += listSize;
        queryProposals();
        return null;
    }
    
    /*
    @Method Name:    End
    @Return Type:    PageReference 
    @parameter:      NA
    @Reason:         Method to return the user to the last proposal record display.
    */
    public PageReference End() { //user clicked end
        counter = totalSize - math.mod(totalSize, listSize);
        if(Test.isRunningTest())
            counter = 100;
        queryProposals();
        return null;
    }
    
    /*
    @Method Name:    getDisablePrevious
    @Return Type:    Boolean 
    @parameter:      NA
    @Reason:         Method to determine the Previous button to disable or enable. 
    */
    public Boolean getDisablePrevious() { 
        //this will disable the previous and beginning buttons
        if (counter>0) return false; else return true;
    }
    
    /*
    @Method Name:    getDisableNext
    @Return Type:    Boolean 
    @parameter:      NA
    @Reason:         Method to determine the Next button to disable or enable. 
    */
    public Boolean getDisableNext() { //this will disable the next and end buttons
        if (counter + listSize < totalSize) return false; else return true;
    }
    
    
    /*
    @Method Name:    getTotalSize
    @Return Type:    Integer 
    @parameter:      NA
    @Reason:         Method to get total size of the proposal records. 
    */
    public Integer getTotalSize() {
        return totalSize;
    }
    
    /*
    @Method Name:    getPageNumber
    @Return Type:    Integer 
    @parameter:      NA
    @Reason:         Method to get Current page number.
    */
    public Integer getPageNumber() {
        return counter/listSize + 1;
    }
     
     
    /*
    @Method Name:    getTotalPages
    @Return Type:    Integer 
    @parameter:      NA
    @Reason:         Method to get total number of pages.
    */
    public Integer getTotalPages() {
        if (math.mod(totalSize, listSize) > 0) {
            return totalSize/listSize + 1;
        } else {
            return (totalSize/listSize);
        }
    } 
    
    /*
    @Method Name:    SortExpression
    @Return Type:    String
    @parameter:      NA
    @Reason:         Method to get Sort Expression.
    */
    public String SortExpression
    {
        get
        {                      
            return szSortExp;
        }
        
        set
        {             
            //If the column is clicked, it switchs between Ascending and Descending modes            
            if (value == szSortExp)
            {                        
                SortDirection = (SortDirection == 'ASC')? 'DESC' : 'ASC';            
            } 
            else
            {
                SortDirection = 'ASC';
            }
                 
            szSortExp = value;          
        }
    }
    
    /*
    @Method Name:    queryProposals
    @Return Type:    NA
    @parameter:      NA
    @Reason:         Method to get all the proposals based on the permission granted to the user.
    */
    public void queryProposals(){
        //preparing the query string..
        String szProposalQuery = 'Select ';
        
        for(Schema.FieldSetMember f : SObjectType.Apttus_Proposal__Proposal__c.FieldSets.Related_List_Column_for_Team_Room.getFields()) {
            szProposalQuery += f.getFieldPath() + ', ';
        }
        
        szProposalQuery += ' (select id, name, Configuration__c, Configuration__r.name, Is_Config_Used__c from IP_Declaration_Form__r limit 1) , ';
        
        szProposalQuery += 'Id FROM Apttus_Proposal__Proposal__c ' +
                           (SortExpression != null && SortDirection != null ? 'Order By ' + SortExpression + ' ' + SortDirection : '') +
                           ' limit '+ listSize +' offset '+counter;
        
        ProposalList = Database.query(szProposalQuery); //making the query on the proposals in the SFDC database. 
        MapIPDecData = new Map<ID,IP_Declaration_Form__c>();
        for(Apttus_Proposal__Proposal__c  proposal : ProposalList  ){
            IP_Declaration_Form__c tempdec = new IP_Declaration_Form__c ();
            for(IP_Declaration_Form__c ipdec : proposal.IP_Declaration_Form__r ){
                if (ipdec != NULL ){
                    tempdec  = ipdec ;
                }
            }
            MapIPDecData.put(proposal.id, tempdec  );
        }
        system.debug('Prosenjit Debug++'+MapIPDecData);
    }
}//end of the class.