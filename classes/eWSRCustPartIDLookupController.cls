/*
    Author: Abhita Bansal
    Description: This Class is used by the VisualForce Page 'eWSRCustPartIDLookupPage' to he override the Standard Lookup of PartId
                to show the records of PartId on the basis of recordtype of form
    History: 
    ABansal     11/12/2014 - Code Creation
    Abansal     11/13/2014 - Added the Create Functionality
    ABansal     11/15/2014 - Remove the Create Functionality
    ABansal     11/23/2014 - Change the SOQL Query to get the results on record type basis
    ABansal     12/17/2014 - Update the search functionality to get the data from PO_Lead_Time__c object
    ABansal     01/08/2014 - Revert the changes back for search functionality to get the data from eWSR_Devices__c object
*/
public with sharing class eWSRCustPartIDLookupController{
    
      public List<eWSR_Devices__c> results{get;set;} 
      public string searchString{get;set;} 
      public String currentURL{get;set;}
      public string recordType{get;set;}
      public String soql; 
     
      public eWSRCustPartIDLookupController() {
        currentURL = ApexPages.currentPage().getURL();
        searchString = System.currentPageReference().getParameters().get('lksrch');
        recordType = System.currentPageReference().getParameters().get('recNameForm');

        if(searchString != '' && searchString != null){
        runSearch();  
        }
      }
   
      public PageReference search() {
        runSearch();
        return null;
      }
  
      private void runSearch() {
        results = performSearch(searchString);               
      } 
   
      private List<eWSR_Devices__c> performSearch(string searchString) {
            if(recordType != eWSRConstantsVariablesClass.FAB5JVRECORDTYPE){
                soql = 'SELECT id, Fab__c, Name FROM eWSR_Devices__c'; 
                soql = soql + ' where Name LIKE \'%' + searchString +'%\'' + ' AND Fab_String__c LIKE \'%' + recordType +'%\'' ;
                soql = soql + ' limit 100';
                System.debug(soql);
            }
            else{
                soql = 'SELECT id, Fab__c, Name FROM eWSR_Devices__c'; 
                soql = soql + ' where Name LIKE \'%' + searchString +'%\''+ ' AND Fab_String__c LIKE \'%'+ eWSRConstantsVariablesClass.FAB5RECORDTYPE + '%\'' ;
                soql = soql + ' limit 100';
                System.debug(soql);
            }
            return database.query(soql); 
      }
  
      public string getFormTag() {
        return System.currentPageReference().getParameters().get('frm');
      }
    
      public string getTextBox() {
        return System.currentPageReference().getParameters().get('txt');
      }
 
}