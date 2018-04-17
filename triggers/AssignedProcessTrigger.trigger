/**
    Trigger Name:  AssignedProcessTrigger 
    Author:        Prosenjit Saha(PS)
    Description:   This trigger sets Unique_ID__c and MRS_status__c of Assigned Process records
                        
    History: 
                    Prosenjit Saha    12112013    - Code creation.
                    Thomas Lai        01202014    - Added before update event & removed unique validation on creation
**/

trigger AssignedProcessTrigger on Assigned_Process__c (before insert, before update) {
    if(!IntegrationUserUtil.isSkipTrigger()){
        //map<string,Assigned_Process__c > uniqueId2ApMap= new map<string,Assigned_Process__c >();
        for(Assigned_Process__c ap : trigger.new ){
            ap.Unique_ID__c = ap.Device__c + '-' + ap.Process__c;
            ap.MRS_Status__c = 'Sent';
           
        }     
    }   
}