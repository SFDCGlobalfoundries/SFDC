/*
 Class Name:         PNP_ReleaseController
 Author:             Pradosh Samal
 Created Date:       05/22/2017
 Reason:             This class is responsible for showing the PNP Release.
 Change History:     
 Author:             
 Modified Date: 
 Reason: 
 …….. 
 ……..
*/
public with sharing class PNP_ReleaseController{
    
    public Integer counter  {get; set;}
    public Integer listSize {get; set;} 
    public Integer totalSize{get; set;} 
    public List<PNP_Release__c> pnpReleaseList {get; set;}
    
    public PNP_ReleaseController(){        
        
        counter = 0;
        listSize = Integer.valueOf(EnvironmentVariable.get('PNP_RELEASE_PAGE_SIZE')); 
        totalSize = [SELECT count() FROM PNP_Release__c ];
        
        pnpReleaseList = new List<PNP_Release__c>();
        queryData();
    }
    
    public void queryData(){
        
        String query = 'SELECT Id, Name, PNP_Release_Stage__c, Priority__c, Lot_Size__c FROM PNP_Release__c LIMIT ' + listSize + ' OFFSET ' + counter;
        pnpReleaseList = Database.query(query);
    }
    
    public PageReference beginning() { 
        counter = 0;
        queryData();
        return NULL;
    }
    
    public PageReference previous() { 
        counter -= listSize;
        queryData();
        return NULL;
    }
    
    public PageReference next() { //user clicked next button
        counter += listSize;
        queryData();
        return NULL;
    }
    
    public PageReference end() { 
        counter = totalSize - Math.mod(totalSize, listSize);
        queryData();
        return null;
    }
    
    public Boolean getDisablePrevious() { 
        
        if(counter > 0){
            return FALSE;
        } 
        else{
            return TRUE;
        }
    }
    
     public Boolean getDisableNext() { 
        
        if (counter + listSize < totalSize){
            return FALSE;
        }
        else{
            return TRUE;
        }
    }
    
    public Integer getPageNumber() {
        return counter/listSize + 1;
    }
    
    public Integer getTotalPages() {
        if (Math.mod(totalSize, listSize) > 0) {
            return totalSize/listSize + 1;
        } 
        else {
            return (totalSize/listSize);
        }
    } 
}