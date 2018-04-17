trigger HCMEmployeeTrigger_biu on HCM_Employee__c (before insert, before update) {
//############################################################################################
//# Description: HCM Employee record insert/update -
//#       -If status if set to Inactive - find the related user record and set user to inactive 
//#       -Change "Employee ID" to all uppercase
//#       -Update: Supervisor update based on entered supervisor id.
//#        
//# Dependencies:  
//# Called from:  
//#
//# Change                              Date             Author
//# New                                 29-10-2012       Robert.k.smith@salesforce.com
//# Update                              04-03-2013       bhupesh.mukhija@cognizant.com  
//#
//#
//############################################################################################

    Set<String> sAllEmployeeIds = new Set<String>();
    Set<String> sInactiveEmployeeIds = new Set<String>(); 
    List<User> lInactiveUsers;
    List<ID> lUpdateHCMIDs = new List<ID>();

    // Enhancement HCM Supervisor Update   
    Map<String, Id> mEmpIdHCMId = new Map<String, Id>(); 
    Set<String> sAllSupervisorIds = new Set<String>();
    
    if (trigger.isInsert || trigger.isUpdate) {
        for (HCM_Employee__c eachHCM: Trigger.new) {    
        
            // Ensure that the Employee ID is always set to upper case   
            eachHCM.Employee_ID__c = eachHCM.Employee_ID__c.toUpperCase();
            sAllEmployeeIds.add(eachHCM.Employee_ID__c); 
            
            // check if its now inactive
            if (eachHCM.Status__c != null & eachHCM.Status__c.startsWithIgnoreCase('Inactive')) {
                sInactiveEmployeeIds.add(eachHCM.Employee_ID__c); 
            }
            
            // Enhancement HCM Supervisor Update: Get all Supervisor HCM_Employee Employee IDs.
            if (eachHCM.Supervisor_ID__c != null
                    && eachHCM.Supervisor_ID__c.length() > 0) {
                sAllSupervisorIds.add(eachHCM.Supervisor_ID__c);
            }
        }
        // get existing users that should be changed to inactive
        lInactiveUsers= [select id, name, isactive, FederationIdentifier 
            FROM user WHERE FederationIdentifier  in :sInactiveEmployeeIds and isactive=true];
        List<ID> lUserIDs = new List<ID>();
        
        for (User eachUser : lInactiveUsers) {
            lUserIDs.add(eachUser.id);
        }
        // call future method to disable users
        // Enhancement HCM Supervisor Update: Condition Update        
        if (lUserIDs != null && !lUserIDs.isEmpty() && !HCMUserActions.isFuture) {
            HCMUserActions.disableUsers(lUserIDs);
        }
        //  **Note this operation on the user can fail due to record ownership exceptions..
        //    These exceptions should be captured and reported to the admin to manually resolve
        
        // Enhancement HCM Supervisor Update: Get all corrosponding Supervisor HCM_Employee IDs.
        for (HCM_Employee__c eachHCM: 
                [SELECT Employee_ID__c, id FROM HCM_Employee__c WHERE Employee_ID__c IN: sAllSupervisorIds]) {
            mEmpIdHCMId.put(eachHCM.Employee_ID__c, eachHCM.id);
        }
        
        // Enhancement HCM Supervisor Update: Update Supervisor.
        for (HCM_Employee__c eachHCM: Trigger.new) {
            eachHCM.Supervisor__c = mEmpIdHCMId.get(eachHCM.Supervisor_ID__c);
        }
   }
      
    /* Check if the HCM Employee fields have been updated
       user.LastName
       user.Department
       user.email
       user.Title
       user.Phone 
       user.Supervisor */
       
       if (trigger.isUpdate) {
           for (id hcmID : trigger.newmap.keyset()) {
               // Check for updated values --
                if( trigger.oldMap.get(hcmID).Last_Name__c!= trigger.newMap.get(hcmID).Last_Name__c
                    ||  trigger.oldMap.get(hcmID).Department_Name__c!= trigger.newMap.get(hcmID).Department_Name__c
                    ||  trigger.oldMap.get(hcmID).Email_Address__c!= trigger.newMap.get(hcmID).Email_Address__c
                    ||  trigger.oldMap.get(hcmID).Job_Title__c!= trigger.newMap.get(hcmID).Job_Title__c
                    ||  trigger.oldMap.get(hcmID).Login_ID__c!= trigger.newMap.get(hcmID).Login_ID__c
                    ||  trigger.oldMap.get(hcmID).Supervisor_ID__c!= trigger.newMap.get(hcmID).Supervisor_ID__c) {           
 
                   lUpdateHCMIDs.add(hcmID);
                }
           }
           // call future method to update the users with the new data
          // Enhancement HCM Supervisor Update: Condition Update
          if (lUpdateHCMIDs != null && !lUpdateHCMIDs.isEmpty() && !HCMUserActions.isFuture) {
              HCMUserActions.updateUsersFromHCM(lUpdateHCMIDs);
           }
        //  **Note this operation on the user can fail due to record ownership exceptions..
        //    These exceptions should be captured and reported to the admin to manually resolve
    }           
}