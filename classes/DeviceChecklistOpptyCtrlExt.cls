/*Author: Sreedhar Karukonda
    Description: This is a Controller Extension class for Opportunity object used in DeviceChecklistOpptyReportView Page.
    This page displays Opportunity related to Device Checklists statistics 
    
    History:
    Created     -     Sreedhar   -     05/14/2014     - code creation.
    Updated     -     Sreedhar   -     10/02/2014 - Removed TASKRAY Application Objects Dependency
*/
public without sharing class DeviceChecklistOpptyCtrlExt {
    public Opportunity opp {get; set;}  

    /*
    * Constructor as Opprtunity Statndard Controller Extension
    */
    public DeviceChecklistOpptyCtrlExt(ApexPages.StandardController stdController){
        this.opp = (Opportunity)stdController.getRecord();
    }

    /*
    * This holds reference to Report utility object
    */
    public DeviceChecklistReportsCtrlExt reportUtil {
        get{
            if(reportUtil == null) reportUtil = new DeviceChecklistReportsCtrlExt(null, this.opp.id);
            return reportUtil;
        }
        set;
    }

    /*
    * This Method calculates Opportunity related Checklists' statistics.
    */
    public List<DeviceChecklistReportsCtrlExt.ThisProjectStatus> getOpportunityChecklistsStatus(){
      return reportUtil.getOpportunityChecklistsStatus(opp.id);
    }

    /*
    *  This varibale holds reference to all device Checklist related to Opportunity.
    */
    public Map<id, Checklist_Container__c> allOpportunityDeviceChecklists{
        get{
            if(allOpportunityDeviceChecklists == null) {
                //allOpportunityDeviceChecklists = new Map<id, Checklist_Container__c>();
                allOpportunityDeviceChecklists = new Map<id, Checklist_Container__c>([select id, Name, Device__r.Name from Checklist_Container__c where 
                        Opportunity__c =: opp.id and Hierarchy_Level__c = 0 and Device__c != null]);
            }
            return allOpportunityDeviceChecklists;
        }
        set;
    }
}