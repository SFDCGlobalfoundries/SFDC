/***************************************************************************************************************************
Class:         DeviceChecklistSelectCtrlExt
----------------------------------------------------------------------------------------------------------------------------
Author:        Sreedhar karukonda
Created Date:  14/08/2014
Reason:        This is controller class for DeviceChecklistSelectView Page

Change Log:     Created     -     Sreedhar     -     14/08/2014
                Updated     -     Sreedhar   -     10/02/2014 - Removed TASKRAY Application Objects Dependency
***************************************************************************************************************************/

public without sharing class DeviceChecklistSelectCtrlExt{
    public Checklist_Container__c program;
    
    public String message{get; set;}
    public boolean displayPrograms{
        get;
        set;
    }
    public DeviceChecklistSelectCtrlExt(ApexPages.StandardController controller) {
        this.program = (Checklist_Container__c)controller.getRecord();
    }
    public List<Checklist_Container__c> programs{get; set;}
    public PageReference getPrograms(){
        programs = null;
        message = null;
     
        List<Checklist_Container__c> projects= [select id, Name, Account__c, Device__c, Opportunity__c, Opportunity_Program__c 
                                                from Checklist_Container__c where Hierarchy_Level__c = 0 
                                                and Device__c = :program.Device__c];
        displayPrograms = true;
        if(projects.size() > 0){
            programs = projects;
        }else{
            message = 'No programs found for the device';
        }                                   
        return null;
    }
}