public with sharing class HCMUserActions {
    
    public static Boolean isFuture = false;
    @future (callout=false)
    public static void disableUsers(List<ID> lUserIds){
        isFuture = true;
        List<User> lInactiveUsers= [select id, name, isactive, FederationIdentifier 
            FROM user WHERE id in :lUserIds and isactive=true];
        
        for (User eachUser : lInactiveUsers) {
            eachUser.isActive=false;
        }
    
        Database.SaveResult[] lsr = Database.update(lInactiveUsers, false);
        for(Database.SaveResult sr:lsr){
           if(sr.isSuccess()){
              System.debug('User ' + sr.getID() + ' has been deactivated' );
           } else {
               //TBD: report error on user update records
           }
        }
    }
    
 /* Update the User fields based on the HCM Employee field data
    user.LastName
    user.firstname
    user.Department
    user.email
    user.Title
    user.Phone */
    @future (callout=false)
    public static void updateUsersFromHCM(List<ID> lHCMIds){
        isFuture = true;    
        Map<String, HCM_Employee__c> mHCMRecords = new  Map<String, HCM_Employee__c>();
        
        for (HCM_Employee__c eachHCM : [ select id, Employee_ID__c, Last_Name__c, First_Name__c,
                     Department_Name__c, Email_Address__c, Job_Title__c, Phone_Number__c , Login_ID__c
                   FROM HCM_Employee__c where id in :lHCMIds] ) {
              mHCMRecords.put(eachHCM.Employee_ID__c , eachHCM); 
        }
        
        List<User> lUsers= [select id, federationidentifier, LastName, firstname, Department, email, Title, Phone, HCM_Login_ID__c   
            FROM user WHERE federationidentifier in : mHCMRecords.keySet()];
            
        for (User eachUser : lUsers) {
            HCM_Employee__c eachEmployee = mHCMRecords.get(eachUser.federationidentifier);
            if (eachEmployee != null) {
                eachUser.LastName = eachEmployee.Last_Name__c;
                eachUser.Department = eachEmployee.Department_Name__c;
                eachUser.email = eachEmployee.Email_Address__c;
                eachUser.Title = eachEmployee.Job_Title__c;
                eachUser.HCM_Login_ID__c = eachEmployee.Login_ID__c;      
            }
        }    
    
        Database.SaveResult[] lsr = Database.update(lUsers, false);
        for(Database.SaveResult sr:lsr){
           System.debug(sr);
           if(sr.isSuccess()){
              System.debug('User ' + sr.getID() + ' has been updated from HCM' );
           } else {
               //TBD: report error on user update records
           }
        }
    }
    
    // Enhancement HCM Supervisor Update: Update HCM User Object with Corrosponding User and Supervisor.
    @future (callout=false)
    public static void updateHCMUsers(List<String> lFederationIDS, List<String> lUserIds){
        isFuture = true;
        List<HCM_Employee__c> lHCMToUpdate = new List<HCM_Employee__c>();
        Map<String, Id> mEmpIdHCMEmpId = new Map<String, Id>();
        Map<String, Id> mEmpIdUserId = new Map<String, Id>();
        Map<String,HCM_Employee__c > mHCMEmployees = new Map<String, HCM_Employee__c >();
        
        for (HCM_Employee__c eachHCM: 
            [SELECT id, Employee_ID__c, Supervisor_ID__c FROM HCM_Employee__c WHERE Employee_ID__c IN:  lFederationIDS]) {
            mHCMEmployees.put(eachHCM.Employee_ID__c, eachHCM);
        }
        
        for (HCM_Employee__c eachHCM: 
            [SELECT id, Employee_ID__c FROM HCM_Employee__c WHERE Employee_ID__c IN:  lUserIDS]) {
            mEmpIdHCMEmpId.put(eachHCM.Employee_ID__c, eachHCM.id);
        }
        
        for (User eachUser: 
            [SELECT FederationIdentifier, id FROM User Where FederationIdentifier IN: lUserIDS]) {
            mEmpIdUserId.put(eachUser.FederationIdentifier, eachUser.id);
        }
        
        for (String eachHCM: mHCMEmployees.keySet()) {
            
            HCM_Employee__c matchedHCM =  mHCMEmployees.get(eachHCM);
            if (matchedHCM != null) {
                
                if (matchedHCM.Supervisor_ID__c != null && matchedHCM.Supervisor_ID__c.length() > 0) {
                    matchedHCM.Supervisor__c = mEmpIdHCMEmpId.get(matchedHCM.Supervisor_ID__c);
                }
                
                matchedHCM.User__c = mEmpIdUserId.get(matchedHCM.Employee_ID__c);
                lHCMToUpdate.add(matchedHCM);
            }
        }
        update lHCMToUpdate;
    }
}