/*
*
*  
*PTCatalogPublishController : Controller for pages for dashboard 
*/
public without sharing class PTCatalogPublishController {
  
  public list<CatalogPublication> lstPublicationStatus{get;set;}
  public list<CatalogPublication> lstPTPublishedPerFab{get;set;}
  public list<CatalogPublication> lstPTNotPublishedPerFab{get;set;}
  public Scribewidth_Calculator_Settings__c scribeWidthSetting{get;set;}
  public PTCatalogPublishController() {
    scribeWidthSetting = Scribewidth_Calculator_Settings__c.getInstance();
    map<String,Set<String>> mpCatalogPublishCount = new map<String,Set<String>>(); 
    map<String,Set<String>> mpPTPublishFab = new map<String,Set<String>>(); 
    map<String,Set<String>> mpPTNotPublishFab = new map<String,Set<String>>(); 
    
    mpCatalogPublishCount.put('Published',new set<String>());
    mpCatalogPublishCount.put('Not Published',new set<String>());
    list<Device__c> lstDevice = [Select Id,Fab__c,Actual_Tapeout_Date_GMT__c,Process_Technology_2__c,Process_Technology_2__r.Catalog_Publication__c 
                                FROM Device__c 
                                WHERE Actual_Tapeout_Date_GMT__c != NULL AND Actual_Tapeout_Date_GMT__c >=:scribeWidthSetting.Actual_tapeout_date_for_dashboard__c AND Recordtype.Name = 'Device' AND Stage__c != 'Design In' AND Stage__c != 'EOL'];
    for(Device__c device : lstDevice) {
      String fab;
      if(device.Fab__c != NULL) {
        fab = device.Fab__c.trim();
        fab = fab.replaceAll('(\\s+)', '');
        fab = fab.toUppercase();
        if(fab.containsIgnorecase('fab') && fab.length() > 3) {
          fab = fab.substring(0,3)+' ' + fab.substring(3);
        }
      }
      if(device.Process_Technology_2__r.Catalog_Publication__c) {
        if(!mpCatalogPublishCount.containsKey('Published')) {
          mpCatalogPublishCount.put('Published',new set<String>());
        }

        mpCatalogPublishCount.get('Published').add(device.Process_Technology_2__c);
        //fab code
        if(!mpPTPublishFab.containsKey(fab)) {
          mpPTPublishFab.put(fab,new set<String>());
        }
        
        mpPTPublishFab.get(fab).add(device.Process_Technology_2__c);
      }
      else {
        if(!mpCatalogPublishCount.containsKey('Not Published')) {
          mpCatalogPublishCount.put('Not Published',new set<String>());
        }
        
        mpCatalogPublishCount.get('Not Published').add(device.Process_Technology_2__c);
        
        //fab code
        if(!mpPTNotPublishFab.containsKey(fab)) {
          mpPTNotPublishFab.put(fab,new set<String>());
        }
        
        mpPTNotPublishFab.get(fab).add(device.Process_Technology_2__c);
      }         
    }
    lstPublicationStatus = new  list<CatalogPublication>();
    lstPTPublishedPerFab = new  list<CatalogPublication>();
    lstPTNotPublishedPerFab = new  list<CatalogPublication>();
    lstPublicationStatus.add(new CatalogPublication('Published',mpCatalogPublishCount.containsKey('Published')?mpCatalogPublishCount.get('Published').size():0));
    lstPublicationStatus.add(new CatalogPublication('Not Published',mpCatalogPublishCount.containsKey('Not Published')?mpCatalogPublishCount.get('Not Published').size():0));
    
    for(String fab :mpPTPublishFab.keySet()) {
      lstPTPublishedPerFab.add(new CatalogPublication(fab,mpPTPublishFab.get(fab).size()));       
    }
    
    for(String fab :mpPTNotPublishFab.keySet()) {
      lstPTNotPublishedPerFab.add(new CatalogPublication(fab,mpPTNotPublishFab.get(fab).size()));       
    } 
  }
  
  
  public class CatalogPublication {
    public string status{get;set;}
    public Integer count{get;set;}
    
    public CatalogPublication(String stats, Integer cnt) {
       status = stats;
       count = cnt;
    }
  }
}