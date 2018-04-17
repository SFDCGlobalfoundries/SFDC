/*
    Author: Anirban Roy
    Description: Apex class controller for CPQ Report Backup controller.
    History: 
        ARoy     04082015    - Code creation.
*/

public class CPQReportBackupController{
    
    public Map<String,String> reportNameLinkMap {get;set;}
    public String report1 = EnvironmentVariable.get('CPQ Report 1 Name');
    public String report2 = EnvironmentVariable.get('CPQ Report 2 Name');
    public String report3 = EnvironmentVariable.get('CPQ Report 3 Name');
    public String report4 = EnvironmentVariable.get('CPQ Report 4 Name');
    public String report5 = EnvironmentVariable.get('CPQ Report 5 Name');
    public String report6 = EnvironmentVariable.get('CPQ Report 6 Name');
    public String report7 = EnvironmentVariable.get('CPQ Report 7 Name');
    public String report8 = EnvironmentVariable.get('CPQ Report 8 Name');
    public String report9 = EnvironmentVariable.get('CPQ Report 9 Name');
    public String report10 = EnvironmentVariable.get('CPQ Report 10 Name');
    public String report11 = EnvironmentVariable.get('CPQ Report 11 Name');
    public String report12 = EnvironmentVariable.get('CPQ Report 12 Name');
    public String report13 = EnvironmentVariable.get('CPQ Report 13 Name');
    public String report14 = EnvironmentVariable.get('CPQ Report 14 Name');
    private CPQ_MLGPLUS__c cpqMlgplus;
    
    public CPQReportBackupController(ApexPages.StandardController stdController){
        cpqMlgplus = (CPQ_MLGPLUS__c)stdController.getRecord();
        cpqMlgplus = [select id, Process_Technology__c from CPQ_MLGPLUS__c where id = :cpqMlgplus.id];
        
        system.debug('cpqMlgplus.Process_Technology__c ==> '+cpqMlgplus.Process_Technology__c);
        
        reportNameLinkMap = new Map<String,String>();
        Map<String,String> devNameIdMap = new Map<String,String>();        
        for(Report r : [select    id
                                  , developername
                        from      Report
                        where     developername in (:report1,:report2,:report3,:report4,:report5,
                                                    :report6,:report7,:report8,:report9,:report10,
                                                    :report11,:report12,:report13,:report14)
                       ]){
            devNameIdMap.put(r.developername,r.id);        
        }
        
        reportNameLinkMap.put('Product Backup Report','/'+devNameIdMap.get(report14)+'?pv0='+cpqMlgplus.Process_Technology__c);
        reportNameLinkMap.put('Category Backup Report','/'+devNameIdMap.get(report13)+'?pv0='+cpqMlgplus.Process_Technology__c);
        reportNameLinkMap.put('Catergory Hierarchy Report','/'+devNameIdMap.get(report12)+'?pv0='+cpqMlgplus.Process_Technology__c);
        reportNameLinkMap.put('Product Option Group Report','/'+devNameIdMap.get(report2)+'?pv0='+cpqMlgplus.Process_Technology__c);
        reportNameLinkMap.put('Product Classification Report','/'+devNameIdMap.get(report11)+'?pv0='+cpqMlgplus.Process_Technology__c);
        reportNameLinkMap.put('Product Option Component Report','/'+devNameIdMap.get(report1)+'?pv0='+cpqMlgplus.Process_Technology__c);
        reportNameLinkMap.put('Price List & Price List Item Report','/'+devNameIdMap.get(report10)+'?pv0='+cpqMlgplus.Process_Technology__c);
        reportNameLinkMap.put('Product Attribute Group Report','/'+devNameIdMap.get(report9));
        reportNameLinkMap.put('Product Attribute Group Member Report','/'+devNameIdMap.get(report8));
        reportNameLinkMap.put('Product Attribute Report','/'+devNameIdMap.get(report7));
        reportNameLinkMap.put('Product Group Member Report','/'+devNameIdMap.get(report6));
        reportNameLinkMap.put('Constraint Rule Report','/'+devNameIdMap.get(report5)+'?pv0='+cpqMlgplus.Process_Technology__c);
        reportNameLinkMap.put('Constraint Rule Condition Report','/'+devNameIdMap.get(report4)+'?pv0='+cpqMlgplus.Process_Technology__c);
        reportNameLinkMap.put('Constraint Rule Action Report','/'+devNameIdMap.get(report3)+'?pv0='+cpqMlgplus.Process_Technology__c);
        
    }    
}