/*
    Author: Prosenjit Saha
    Description: This page is used to run all the Apttus maintenance jobs
    History: 
        PSaha    04302015    - page creation. 
*/
public class CPQMaintenanceJobsController {

    public Map<String,String> MaintenanceLinkMap {get;set;}
    public String URLApttus {get;set;}
    
    public CPQMaintenanceJobsController(ApexPages.StandardSetController controller) {
        MaintenanceLinkMap  = new Map<String,String>();
        CPQ_Settings__c cpqMaintenancePages = CPQ_Settings__c.getValues('MaintenancePages');
        List<String> MaintenacejobName = cpqMaintenancePages.Maintenance_Job_Name__c.split(',') ; 
        List<String> MaintenacejobPage = cpqMaintenancePages.value__c.split(',') ; 
        for(integer i =0 ; i<MaintenacejobPage.size()  ; i++){
            MaintenanceLinkMap.put(MaintenacejobName [i], MaintenacejobPage [i]);
        }
        URLApttus = ApexPages.currentPage().getHeaders().containsKey('Host') ? ApexPages.currentPage().getHeaders().get('Host').replace('--c.','--apttus-config2.') : NULL;
    }

}