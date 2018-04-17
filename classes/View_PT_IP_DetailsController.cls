/**********************************************************************************************************************************
Class:         View_PT_IP_DetailsController
-----------------------------------------------------------------------------------------------------------------------------------
Author:        Joydev Mondol (Cognizant - 153480)
Created Date:  20/09/2013
Reason:        Controls the View_PT_IP_Details Visualforce page to show the PT/IP details in sections as follows:

               PT Sections
               -----------
               1) Overview
               2) Specification
               3) Design Kit
               
               IP Sections  
               -----------
               1) Overview
               2) IP Design Kit
               3) IP Silicon Report | Design Kit & Merge Kit
               4) IP Mearged Design Kit
               5) Type Specific Data
***********************************************************************************************************************************/

//sample url (PT): https://c.cs5.visual.force.com/apex/View_PT_IP_Details?Entity=PT&Id=a4yO000000008KG
//sample url (IP): https://c.cs5.visual.force.com/apex/View_PT_IP_Details?Entity=IP&Id=a55O00000008iPJ

public class View_PT_IP_DetailsController {
    //IP Non-NDA sheet URL
    final private static String NONNDAURL = Environment_Variable__c.getInstance('IP_CATALOG_SEARCH_NON_NDA_URL').value__c;
    
    public String nonNDAURLVal {get; set;}        
    
    //PT information for all sections
    public Process_Technology__c CurrentProcessTechnology { get; set; }
    
    //Related Notes and Attachment of the current IP
    public List<Attachment> IPAttachments { get; set; }
    
    //Related IPs of the current Process Technology
    public List<Base_IP__c> getPT_IPs() {
         PaginationVariable.setpagesize(10);
         return (List<Base_IP__c>) PaginationVariable.getRecords();
    }
    
    //Related PTs of the current IP
    public List<Process_Technology__c> IP_PTs { get; set; }

    //IP information for Overview, Type Specific Data and Silicon Report
    public Base_IP__c CurrentIPOverview { get; set; }
    
    //IP information for Design Kit (To be depricated later due to requirement change in Multiplicity between IP and Design Kits)
    public IP__c CurrentIPDesignKit { get; set; }
    
    //Design Kits info for IP 
    public List<IP__c> CurrentIPDesignKits { get; set; }
    
    //IP information for Merged Design Kit (To be depricated later due to requirement change in Multiplicity between IP and Merged Design Kits)
    public IP_Merge__c CurrentIPMergedDesignKit { get; set; }
    
    //IP information for Merged Design Kit
    public List<IP_Merge__c> CurrentIPMergedDesignKits { get; set; }
    
    //Entity Scope (PT/IP)
    public String Entity { get; set; }
    public Id EntityId { get; set; }
    
    //NDA Eligibility
    public Boolean IsEligible { get; set; } 
    
    //Error message
    public final String ERROR_MESSAGE = 'You are not authorised! \nYour NDA has expired. \nPlease contact your account manager for new NDA or Extension';
    
    //Pagination parameters
    public ApexPages.StandardSetController PaginationVariable {get;set;}
    public String szPT_IPQuery {get;set;}
    public String szIP_PTQuery {get;set;}
    public String szIPAttachmentQuery {get;set;}
    
    //Sorting parameters
    public String SortDirection {get; set;}            /* sort order of the PT/IP related table columns - asc or desc */
    private String szSortExp = null;                   /* used for sorting the PT/IP related table columns */ 
    
    //Creates the sorting expression for the soql query when the related IPs and PTs columns need to be sorted    
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
    
    //Constructor
    public View_PT_IP_DetailsController(){
        Entity = ApexPages.currentPage().getParameters().get('Entity');
        EntityId = ApexPages.currentPage().getParameters().get('Id');
        
        SortDirection = 'ASC';
        PaginationVariable = Null;        
        
        ShowInfoWithNDA();
    }
    
    public void ShowInfoWithNDA(){
        try{
            If(Entity == 'PT'){
                fetchPTInfo(); 
                IsEligible = NDA_Authentication.checkNDAForPTAccess(CurrentProcessTechnology, 'In Effect');  
            } else {
                fetchIPInfo();
                IsEligible = NDA_Authentication.checkNDAForIPAccess(CurrentIPOverview, 'In Effect');
            }  
            
            If(!IsEligible){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, ERROR_MESSAGE));
            }
        }catch(Exception ex){
            GlobalUtility.logMessage('Error', 'View_PT_IP_DetailsController', 'ShowInfoWithNDA', null, null, ex.getMessage(), null,null,ex, null);
        }
    }
    
    public void fetchPTInfo() {
        //Query strings generated from field sets (For PT)
        String szPTQuery = 'Select ';
        
        for(Schema.FieldSetMember f : SObjectType.Process_Technology__c.FieldSets.PT_Overview.getFields()) {
            szPTQuery += f.getFieldPath() + ', ';
        }
        
        for(Schema.FieldSetMember f : SObjectType.Process_Technology__c.FieldSets.PT_Specification.getFields()) {
            szPTQuery += f.getFieldPath() + ', ';
        }
        
        for(Schema.FieldSetMember f : SObjectType.Process_Technology__c.FieldSets.PT_Design_Kit.getFields()) {
            szPTQuery += f.getFieldPath() + ', ';
        }
        
        szPTQuery += 'Id, Name, Tech_Geometry__c FROM Process_Technology__c Where Id = \'' + EntityId + '\'';
        
        CurrentProcessTechnology = Database.query(szPTQuery);
       
        fetchPTRelatedIps();
    }
    
    public void fetchPTRelatedIps() {
        //Query strings generated from field sets (For PT)
        szPT_IPQuery = 'Select ';
        
        for(Schema.FieldSetMember f : SObjectType.Base_IP__c.FieldSets.PT_IP_Columns.getFields()) {
            szPT_IPQuery += f.getFieldPath() + ', ';
        }
        
        //Generate the Ip Number tokens from PT_IP_Mapping__c
        String szPT_IPNumberTokens = '(';
        
        for(IP_PT_Map__c IP_PT_Map : [Select Id,
                                             IPNumber__c,
                                             PT_Number__c
                                        From IP_PT_Map__c
                                       Where PT_Number__c =: EntityId]){
            szPT_IPNumberTokens += '\'' + IP_PT_Map.IPNumber__c + '\',';                   
        }
        
        szPT_IPNumberTokens = (szPT_IPNumberTokens != '(' ? szPT_IPNumberTokens.substring(0, szPT_IPNumberTokens.length() - 1) + ')' : '');
        
        szPT_IPQuery += 'Id FROM Base_IP__c Where Id IN ' + (szPT_IPNumberTokens != '' ? szPT_IPNumberTokens : '(\'\')') +
                        (SortExpression != null && SortDirection != null ? 'Order By ' + SortExpression + ' ' + SortDirection : '');
        
        PaginationVariable = new ApexPages.StandardSetController(database.getQueryLocator(szPT_IPQuery));                                                                                                                           
        PaginationVariable.setPageSize(10);
        PaginationVariable.setPageNumber(1);
    }
    
    public void fetchIPRelatedNotesAndAttachments() {
        szIPAttachmentQuery = 'Select Id, ' +
                                'Name, ' +
                                'ContentType, ' +
                                'OwnerId, ' +
                                'ParentId, ' +
                                'CreatedById, ' +
                                'LastModifiedDate ' +
                           'From Attachment ' +
                          'Where ParentId = \'' + CurrentIPOverview.Id + '\' '; // +
                          //(SortExpression != null && SortDirection != null ? 'Order By ' + SortExpression + ' ' + SortDirection : '');
        
        IPAttachments = database.query(szIPAttachmentQuery);
        
    }
    
    public void fetchIPInfo() {
        //Query strings generated from field sets from Base_IP__c (For IP)
        String szIPQuery = 'Select ';
        
        //Get all the IP fields from schema
        Schema.DescribeSObjectResult ipSchema = Base_IP__c.sObjectType.getDescribe();
        
        for(Schema.SObjectField field : ipSchema.fields.getMap().Values()){
            szIPQuery += field + ',';
        }
        
        szIPQuery = szIPQuery.subString(0, szIPQuery.length() - 1);
        
        szIPQuery += ' FROM Base_IP__c Where Id = \'' + EntityId + '\'';
        
        CurrentIPOverview = Database.query(szIPQuery);
        this.nonNDAURLVal = NONNDAURL + CurrentIPOverview.IP_Number__c;        
        
        fetchIPDesignKits();
        
        fetchIPMergedDesignKits();
        fetchIPRelatedPTs();
        
        fetchIPRelatedNotesAndAttachments();
    }
    
    public void fetchIPDesignKits() {
        //Query strings generated from field sets from IP__c (For IP)
        String szIPQuery2 = 'Select ';
        
        for(Schema.FieldSetMember f : SObjectType.IP__c.FieldSets.IP_Design_Kit.getFields()) {
            szIPQuery2 += f.getFieldPath() + ', ';
        }
        
        szIPQuery2 += 'Id FROM IP__c Where IPNumber__c = \'' + EntityId + '\'' + 
                      'Order By Name DESC';// Limit 1';
                      //(SortExpression != null && SortDirection != null ? 'Order By ' + SortExpression + ' ' + SortDirection : '');
        
        CurrentIPDesignKits = Database.query(szIPQuery2);
    }
    
    public void fetchIPMergedDesignKits() {
        //Query strings generated from field sets from IP_Merge__c (For IP)
        String szIPQuery3 = 'Select ';
        
        for(Schema.FieldSetMember f : SObjectType.IP_Merge__c.FieldSets.IP_Merged_Design_Kit.getFields()) {
            szIPQuery3 += f.getFieldPath() + ', ';
        }
        
        for(Schema.FieldSetMember f : SObjectType.IP_Merge__c.FieldSets.IP_Silicon_Report.getFields()) {
            szIPQuery3 += f.getFieldPath() + ', ';
        }
        
        szIPQuery3 += 'Id FROM IP_Merge__c Where IPNumber__c = \'' + EntityId + '\'' + 
                      'Order By Name DESC ';//Limit 1';
                      //(SortExpression != null && SortDirection != null ? 'Order By ' + SortExpression + ' ' + SortDirection : '');
        
        CurrentIPMergedDesignKits = Database.query(szIPQuery3);
    }
    
    public void fetchIPRelatedPTs() {
        //Query strings generated from field sets (For IP)
        szIP_PTQuery = 'Select ';
        
        for(Schema.FieldSetMember f : SObjectType.Process_Technology__c.FieldSets.IP_PT_Columns.getFields()) {
            szIP_PTQuery += f.getFieldPath() + ', ';
        }
        
        //Generate the Ip Number tokens from PT_IP_Mapping__c
        String szIP_PTNumberTokens = '(';
        
        for(IP_PT_Map__c IP_PT_Map : [Select Id,
                                             IPNumber__c,
                                             PT_Number__c
                                        From IP_PT_Map__c
                                       Where IPNumber__c =: EntityId]){
            szIP_PTNumberTokens += '\'' + IP_PT_Map.PT_Number__c + '\',';                                 
        }
        
        szIP_PTNumberTokens = (szIP_PTNumberTokens != '(' ? szIP_PTNumberTokens.substring(0, szIP_PTNumberTokens.length() - 1) + ')' : '');
        
        szIP_PTQuery += 'Id FROM Process_Technology__c Where Id IN ' + (szIP_PTNumberTokens != '' ? szIP_PTNumberTokens : '(\'\')') +
                        (SortExpression != null && SortDirection != null ? 'Order By ' + SortExpression + ' ' + SortDirection : '');
        
        IP_PTs = Database.query(szIP_PTQuery);
    }
}