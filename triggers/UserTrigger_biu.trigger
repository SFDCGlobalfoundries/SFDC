trigger UserTrigger_biu on User (before insert, before update) {
//############################################################################################
//# Description: User record trigger 
//#       -Copy the FederationIdentifier value to the HCM_Employee_ID__c field
//#       -Validation: Throw a validation error if the FederationID is blank 
//#           if it does not match an existing HCM Employee ID found in the 
//#           HCM Employee table.
//#
//# Dependencies: 
//# 
//#
//# Change                              Date              Author
//# New                                 02-Nov-2012       Robert.k.smith@salesforce.com
//# Update                              04-Mar-2013       bhupesh.mukhija@cognizant.com
//# Update                              05-Apr-2013       ariz.solito@cognizant.com
//# Update                              19-Apr-2013       anirban-2.roy@cognizant.com
//# Update                              23-Apr-2013       anirban-2.roy@cognizant.com
//# Update                              21-May-2013       ariz.solito@cognizant.com
//# Update                              04-Jun-2013       ariz.solito@cognizant.com
//############################################################################################
Map<Id,Id>userManagerMap = new Map<ID,ID>(); // SFDC TEST - case#13198545
Map<String,User> mUsersByFedID = new Map<String,User>();
Map<String,HCM_Employee__c > mHCMEmployees = new Map<String, HCM_Employee__c >();
List<String> lFederationIDS = new List<String>();
// Enhancement HCM Supervisor Update
List<String> lUserIDS =  new List<String>();
Map<String, Id> mEmpIdUserId = new Map<String, Id>();
Map<String, String> mEmpIdSupervisorId = new Map<String, String>();
//ADDED 05/21/2013 - ASOLITO
//commented out batch job check flag and use the System.isbatch and System.isFuture
/*Boolean isCalledByCyberU = false;
Boolean isCalledByAccTeamProxyUpdate = false;*/

    if (trigger.isInsert || (trigger.isUpdate && !managerUpdater.executed)) {
        // Get all the profiles as we will look to identify the GF profiles
        Map<ID,Profile> allProfileMap = new Map<ID,Profile>( [SELECT Id, Name FROM Profile LIMIT 200] );

        for (User eachUser: Trigger.new) { 
             //Fix issue where this trigger won't call the @future class HCMUserActions.updateHCMUsers
            //when the firing is caused by the batch class of CyberU appexexchange app
            //ADDED 05/21/2013 - ASOLITO
            //commented out batch job check flag and use the System.isbatch and System.isFuture
            /*if(trigger.isUpdate){
                if((eachUser.lmscons__Cornerstone_ID__c <> trigger.oldMap.get(eachUser.id).lmscons__Cornerstone_ID__c)
                    || (eachUser.lmscons__Cornerstone_Group_Admin__c <> trigger.oldMap.get(eachUser.id).lmscons__Cornerstone_Group_Admin__c)){ 
                    isCalledByCyberU = true;   
                }
            }*/                                    
            Profile myProfile = allProfileMap.get(eachUser.ProfileId);
            String myProfileName = '' + myProfile.name;

            // only apply validation to the GF profiles
            if (myProfileName.StartsWith('GF')) {
                if (eachUser.FederationIdentifier != null && eachUser.FederationIdentifier.length() > 0) {
                
                    eachUser.FederationIdentifier = eachUser.FederationIdentifier.toUpperCase();
                    eachUser.HCM_Employee_ID__c = eachUser.FederationIdentifier;
                    lFederationIDS.add(eachUser.FederationIdentifier);
                } else {
                    // add a field validation error - should always provide a federationID
                    eachUser.FederationIdentifier.addError('Federation ID must be populated with a valid HCM Employee ID');
                }
            }
        }
        lUserIDS.addAll(lFederationIDS);
        for (HCM_Employee__c eachHCM: [select id, Login_ID__c, Last_Name__c, First_Name__c, Department_Name__c, Email_Address__c, Job_Title__c, Phone_Number__c , Employee_ID__c, Supervisor_ID__c
                FROM HCM_Employee__c where Employee_ID__c in :  lFederationIDS ]) {
            mHCMEmployees.put(eachHCM.Employee_ID__c , eachHCM);
            // Enhancement HCM Supervisor Update: Collect all users in List
                mEmpIdSupervisorId.put(eachHCM.Employee_ID__c, eachHCM.Supervisor_ID__c);
                lUserIDS.add(eachHCM.Supervisor_ID__c);
        }
        // Enhancement HCM Supervisor Update: Get all HCM Employee_Ids and Corrosponding User Ids
        for (User eachUser: 
            [SELECT FederationIdentifier, id FROM User Where FederationIdentifier IN: lUserIDS]) {
            mEmpIdUserId.put(eachUser.FederationIdentifier, eachUser.id);
        }
        
        for (User eachUser: Trigger.new) { 
            
            Profile myProfile = allProfileMap.get(eachUser.ProfileId);
            String myProfileName = '' + myProfile.name;

            // only apply validation to the GF profiles
            if (myProfileName.StartsWith('GF')) {           
            
               HCM_Employee__c matchedHCM = mHCMEmployees.get(eachUser.FederationIdentifier);
               if (matchedHCM != null) {
                    eachUser.HCM_Record_ID__c = matchedHCM.id;
                    eachUser.LastName = matchedHCM.Last_Name__c;
                    eachUser.Department = matchedHCM.Department_Name__c;
                    eachUser.email = matchedHCM.Email_Address__c;
                    eachUser.Title = matchedHCM.Job_Title__c;
                    eachUser.HCM_Login_ID__c = matchedHCM.Login_ID__c;
                    
                    // Enhancement HCM Supervisor Update: Update Manager Information in User
                    Id managerUser = mEmpIdUserId.get(mEmpIdSupervisorId.get(eachUser.FederationIdentifier));
                    if ((mEmpIdSupervisorId.get(eachUser.FederationIdentifier)) != null) {
                        if (managerUser != null) {
                            //eachUser.ManagerId = managerUser;
                            userManagerMap.put(eachUser.id,managerUser);// SFDC TEST - case#13198545 
                        }
                    } else {
                        eachUser.ManagerId = null;
                    }
               }else {
                   // add a field validation error - federationID should match an Employee ID
                   eachUser.FederationIdentifier.addError('Federation ID does not match an existing HCM Employee ID');
               }
            }
        } 
        if(userManagerMap.size()>0)
        {            
            managerUpdater.executed=true;
            managerUpdater.process(userManagerMap);           
        }
        // Start of the section added for preventing the @future class HCMUserActions.updateHCMUsers
        // when the firing is caused by the batch class of AccountTeamProxy Fab Assignment update
        //ADDED 05/21/2013 - ASOLITO
        //commented out batch job check flag and use the System.isbatch and System.isFuture
        /*if(trigger.isUpdate){
          for (User eachUser: Trigger.new) {           
                  if(eachUser.Fab_Assignment_Change__c <> trigger.oldMap.get(eachUser.id).Fab_Assignment_Change__c && trigger.oldMap.get(eachUser.id).Fab_Assignment_Change__c){ 
                      isCalledByAccTeamProxyUpdate = true;   
                  }
          }
        }*/
        // End of section        
        
        //ADDED 05/21/2013 - ASOLITO
        //future and batch calls won't pass this future method
        if (!HCMUserActions.isFuture && !System.isBatch() && !System.isFuture()) {
            HCMUserActions.updateHCMUsers(lFederationIDS, lUserIds);
        }
        
        //ADDED 06/04/2013 - ASOLITO
        //added codes to store removed fabs when user changes the value of fab assigned field
        if(trigger.isUpdate){
            Map<String,User> userMap = new Map<String,User>(); 
            for(User u: trigger.new){                                               
                if(u.fab_assigned__c <> trigger.oldMap.get(u.id).fab_assigned__c){
                    userMap.put(u.id,u);
                }
            }                  
             list<user> usrr= new list<user>([SELECT fab_assigned__c,fab_deleted__c,(SELECT id 
                                                              FROM Account_Team_Proxy__r 
                                                              WHERE team_role__c IN ('Customer Engineer','Fab Planner'))
                           FROM User
                           WHERE id IN :userMap.keySet()])     ;
            //system.debug('@@@@@@@@@@@user'+ usrr + usrr[0].account_team_proxy__r);      
            //Validate if user has been assigned as CE or Fab Planner
            //if yes don't allow blank value for fab assigned field 
            //system.debug('@@@@@@@@@@@@@@@@@'+userMap.keyset());
            List<Account_Team_proxy__c> atp =new List<Account_Team_proxy__c>();
            if(usrr.size()>0)
            {
                atp = usrr[0].account_team_proxy__r;
            }
            for(integer i=0; i<usrr.size();i++)
            {
                if(userMap.containsKey(usrr[i].id)){
                    User currUser = userMap.get(usrr[i].id);
                    
                    if(atp.size() > 0 && !UtilsString.isNotBlank(currUser.fab_assigned__c)){
                        currUser.fab_assigned__c.addError('This user cannot have a blank fab since its been assigned as a Customer Engineer or Fab Planner');
                    }
                } 
            } 
            /* for(User u: [SELECT fab_assigned__c,fab_deleted__c,(SELECT id 
                                                              FROM Account_Team_Proxy__r 
                                                              WHERE team_role__c IN ('Customer Engineer','Fab Planner'))
                           FROM User
                           WHERE id IN :userMap.keySet()]){
                           
                List<Account_Team_proxy__c> atp = u.account_team_proxy__r;
                
                if(userMap.containsKey(u.id)){
                    User currUser = userMap.get(u.id);
                    
                    if(atp.size() > 0 && !UtilsString.isNotBlank(currUser.fab_assigned__c)){
                        currUser.fab_assigned__c.addError('This user cannot have a blank fab since its been assigned as a Customer Engineer or Fab Planner');
                    }
                }           
            } */
            
            
            //concatenate the existing fab deleted field value
            for(String key: userMap.keySet()){
                User u = userMap.get(key);
                
                //get the new fab assigned values                               
                Map<String,String> newVal = new Map<String,String>();   
                if(UtilsString.isNotBlank(u.fab_assigned__c)){
                    newVal = UtilsString.convertStringListToMap(u.fab_assigned__c.split('\\;'));            
                }   
                
                //get the old fab assigned values
                List<String> oldVal = new List<String>();                                   
                if(UtilsString.isNotBlank(trigger.oldMap.get(u.id).fab_assigned__c)){
                    oldVal = trigger.oldMap.get(u.id).fab_assigned__c.split('\\;');
                }  
                
                //filter fabs not found in the new assigned values
                List<String> newDeletedFabs = new List<String>();   
                for(String o: oldVal){
                    if(!newVal.containsKey(o)){
                        newDeletedFabs.add(o);
                    }
                } 
                
                //set the value of the fab deleted field
                String finalVal = '';
                if(UtilsString.isNotBlank(u.fab_deleted__c)){                                   
                    Map<String,String> currValMap = UtilsString.convertStringListToMap(u.fab_deleted__c.split('\\;'));

                    for(String n :newDeletedFabs){
                        if(!currValMap.containsKey(n)){
                            finalVal += ';' + n;
                        }
                    }
                    u.fab_deleted__c += finalVal;
                } else {
                    for(String n: newDeletedFabs){
                        finalVal += n + ';';
                    }
                    u.fab_deleted__c = finalVal.removeEnd(';');
                    
                }                                               
            }                       
        }
    }
    
    //Added for the fab assignment change
        if(trigger.isUpdate && !managerUpdater.executed){
        for(User eachUser: trigger.new){
                if(eachUser.Fab_Assigned__c != trigger.oldMap.get(eachUser.Id).Fab_Assigned__c){
                        eachUser.Fab_Assignment_Change__c=true;             
                }
        }   
    }
}