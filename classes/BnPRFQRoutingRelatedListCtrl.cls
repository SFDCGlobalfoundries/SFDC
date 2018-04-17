/*
Type Name: BnPRFQRoutingRelatedListCtrl
Author: Depti Narayan Biswal
Project Name: DIW Step Down Track 2 (BnP) 
Created Date: 7/14/2016
Description: This class serves controller for BnPRFQRoutingRelatedList Page.
Test Class: 
Change History:
*/
public class BnPRFQRoutingRelatedListCtrl {
    
    public String reqInfoId {get; set;}
    public String templateName {get; set;}
    public Integer noOfTask {get; set;}
    public String createdByUser {get; set;}
    public String routeBasePurpose {get; set;}
    
    public BnPRFQRoutingRelatedListCtrl(ApexPages.StandardController controller) {
        reqInfoId = controller.getId();
        noOfTask = null;
    }
    
    Public Integer noOfRecords{get; set;}
    Public Integer size{get;set;}
    public ApexPages.StandardSetController setCon {
        get{
            if(setCon == null){
                size = 10;
                string queryString = 'SELECT Id, Name, No_of_Task__c, Auto_Stop_on_Rejection__c, CreatedById, createdby.Name, Calculate_due_date_based_on__c, Description__c, Route_Base_Purpose__c, Route_Name__c, Status__c FROM Route_Template__c';
                setCon = new ApexPages.StandardSetController(Database.getQueryLocator(queryString));
                setCon.setPageSize(size);
                noOfRecords = setCon.getResultSize();
            }
            return setCon;
        }set;
    }
     
    Public List<Route_Template__c> getRoutingTemplates(){
        List<Route_Template__c> routeTemplateList = new List<Route_Template__c>();
        for(Route_Template__c a : (List<Route_Template__c>)setCon.getRecords())
            routeTemplateList.add(a);
        return routeTemplateList;
    }
    
    public PageReference find() {

        //String query = 'SELECT Id, Name, BillingStreet, BillingCity, BillingState, BillingPostalCode FROM Account WHERE BillingPostalCode =: ' + zList + ' ORDER BY BillingPostalCode, Name';
        String soql = 'SELECT Id, Name, No_of_Task__c, Auto_Stop_on_Rejection__c, CreatedById, createdby.Name, Calculate_due_date_based_on__c, Description__c, Route_Base_Purpose__c, Route_Name__c, Status__c FROM Route_Template__c';
        
        if(noOfTask == 0){
            noOfTask = null;
        }
        if(routeBasePurpose == 'None'){
            routeBasePurpose = '';
            system.debug('Poulami :' +routeBasePurpose);
        }
        
        if (!templateName.equals('') && noOfTask == null && createdByUser.equals('') && routeBasePurpose.equals('')){
            soql += '  WHERE Name LIKE \'%'+String.escapeSingleQuotes(templateName)+'%\'';
        }
        else if (!templateName.equals('') && noOfTask != null && createdByUser.equals('') && routeBasePurpose.equals('')){
            soql += '  WHERE Name LIKE \'%'+String.escapeSingleQuotes(templateName)+'%\'' +'AND'+' '+'No_of_Task__c ='+noOfTask;  
            system.debug('Rony :' +soql);
        }
        else if (!templateName.equals('') && noOfTask != null && !createdByUser.equals('') && routeBasePurpose.equals('')){
            soql += '  WHERE Name LIKE \'%'+String.escapeSingleQuotes(templateName)+'%\'' +'AND'+' '+'No_of_Task__c ='+noOfTask +'AND'+' '+'createdby.Name LIKE \'%'+String.escapeSingleQuotes(createdByUser)+'%\'';
        }
        else if (!templateName.equals('') && noOfTask != null && !createdByUser.equals('') && !routeBasePurpose.equals('')){
            soql += '  WHERE Name LIKE \'%'+String.escapeSingleQuotes(templateName)+'%\'' +'AND'+' '+'No_of_Task__c ='+noOfTask +'AND'+' '+'createdby.Name LIKE \'%'+String.escapeSingleQuotes(createdByUser)+'%\'' +'AND'+' '+'Route_Base_Purpose__c LIKE \'' + ''+routeBasePurpose+'\'';
        }
        else if(templateName.equals('') && noOfTask != null && !createdByUser.equals('') && !routeBasePurpose.equals('')){
            soql += '  WHERE No_of_Task__c ='+noOfTask +'AND'+' '+'createdby.Name LIKE \'%'+String.escapeSingleQuotes(createdByUser)+'%\'' +'AND'+' '+'Route_Base_Purpose__c LIKE \'' + ''+routeBasePurpose+'\'';
        }
        else if(templateName.equals('') && noOfTask == null && !createdByUser.equals('') && !routeBasePurpose.equals('')){
            soql += '  WHERE createdby.Name LIKE \'%'+String.escapeSingleQuotes(createdByUser)+'%\'' +'AND'+' '+'Route_Base_Purpose__c LIKE \'' + ''+routeBasePurpose+'\'';
        }
        else if(templateName.equals('') && noOfTask == null && createdByUser.equals('') && !routeBasePurpose.equals('')){
            soql += '  WHERE Route_Base_Purpose__c LIKE \'' + ''+routeBasePurpose+'\'';
        }
        else if(!templateName.equals('') && noOfTask == null && !createdByUser.equals('') && !routeBasePurpose.equals('')){
            soql += '  WHERE Name LIKE \'%'+String.escapeSingleQuotes(templateName)+'%\'' +'AND'+' '+'createdby.Name LIKE \'%'+String.escapeSingleQuotes(createdByUser)+'%\'' +'AND'+' '+'Route_Base_Purpose__c LIKE \'' + ''+routeBasePurpose+'\'';
        }
        else if(!templateName.equals('') && noOfTask != null && createdByUser.equals('') && !routeBasePurpose.equals('')){
            soql += '  WHERE Name LIKE \'%'+String.escapeSingleQuotes(templateName)+'%\'' +'AND'+' '+'No_of_Task__c ='+noOfTask +'AND'+' '+'Route_Base_Purpose__c LIKE \'' + ''+routeBasePurpose+'\'';
        }
        else if(templateName.equals('') && noOfTask == null && !createdByUser.equals('') && routeBasePurpose.equals('')){
            soql += '  WHERE createdby.Name LIKE \'%'+String.escapeSingleQuotes(createdByUser)+'%\'';
        }
        else if(templateName.equals('') && noOfTask != null && createdByUser.equals('') && routeBasePurpose.equals('')){
            soql += '  WHERE No_of_Task__c ='+noOfTask;
        }
        else if(templateName.equals('') && noOfTask != null && !createdByUser.equals('') && routeBasePurpose.equals('')){
            soql += '  WHERE No_of_Task__c ='+noOfTask +'AND'+' '+'createdby.Name LIKE \'%'+String.escapeSingleQuotes(createdByUser)+'%\'';
        }
        else if(templateName.equals('') && noOfTask != null && createdByUser.equals('') && !routeBasePurpose.equals('')){
            soql += '  WHERE No_of_Task__c ='+noOfTask +'AND'+' '+'Route_Base_Purpose__c LIKE \'' + ''+routeBasePurpose+'\'';
        }
        else if(!templateName.equals('') && noOfTask == null && !createdByUser.equals('') && routeBasePurpose.equals('')){
            soql += '  WHERE Name LIKE \'%'+String.escapeSingleQuotes(templateName)+'%\'' +'AND'+' '+'createdby.Name LIKE \''+createdByUser+'\'';
        }
        else if(!templateName.equals('') && noOfTask == null && createdByUser.equals('') && !routeBasePurpose.equals('')){
            soql += '  WHERE Name LIKE \'%'+String.escapeSingleQuotes(templateName)+'%\'' +'AND'+' '+'Route_Base_Purpose__c LIKE \''+routeBasePurpose+'\'';
        }
        
        system.debug('XXXXXXXXXXXXXXXXX :' +soql);
        setCon = new ApexPages.StandardSetController(Database.getQueryLocator(soql));
        setCon.setPageSize(10);
        noOfRecords = setCon.getResultSize();
        return null;
    
    }
     
    public pageReference refresh() {
        setCon = null;
        getRoutingTemplates();
        setCon.setPageNumber(1);
        return null;
    }
     
    public Boolean hasNext {
        get {
            return setCon.getHasNext();
        }
        set;
    }
    public Boolean hasPrevious {
        get {
            return setCon.getHasPrevious();
        }
        set;
    }
  
    public Integer pageNumber {
        get {
            return setCon.getPageNumber();
        }
        set;
    }
  
    public void first() {
        setCon.first();
    }
  
    public void last() {
        setCon.last();
    }
  
    public void previous() {
        setCon.previous();
    }
  
    public void next() {
        setCon.next();
    }

}