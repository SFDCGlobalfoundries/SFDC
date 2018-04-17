/*
    Author: Anirban Roy
    Description: Batch class to extract and update Account Team Proxy records for Fab Assignment modification in User object. 
    History: 
        ARoy        04222013    - code creation.
        Asolito     06102013    - Added fab deleted update 
        ASinghal    06192013    - Updated Query to only include records with Fab Assignment Change as False on Account Proxy Records and update the Fab when it is changed on User.
		Tlai		14032014	- Updated initial query to add fields Fab_Assignment__c, User__r.Fab_Assigned__c and removed the query in execute method
								  Added code to check if the Fab removed from user is not anymore assigned on ATP
								  Updated logic to partially update user records if any error
								  
*/
global class AccountTeamUpdateBatch implements Database.Batchable<sObject>{
    
    static final string ACC_TEAM_PRXY_TM_RL_CE = EnvironmentVariable.get('ACT_TM_PRXY_TM_RL_CE');
    static final string ACC_TEAM_PRXY_TM_RL_FP = EnvironmentVariable.get('ACCT_TM_PRXY_TM_RL_FP');
    
    // Query to fetch the Account Team Proxy records for Users having Fab_Assignment_Change__c checked
    // and Team Role as Customer Engineer and Fab Planner
    global final String query = 'Select User__c,Batch_Sync_Id__c,Team_Role__c,Fab_Deleted__c,Fab_Assignment__c,User__r.fab_deleted__c,User__r.Fab_Assigned__c from Account_Team_Proxy__c where'+
                                        +' User__c in (select Id from User where Fab_Assignment_Change__c = true) and '
                                        +' Fab_Assignment_Change__c = false and '
                                        +'Team_Role__c in (\''+ AccountTeamUpdateBatch.ACC_TEAM_PRXY_TM_RL_CE + '\',\''
                                        + AccountTeamUpdateBatch.ACC_TEAM_PRXY_TM_RL_FP + 
                                        '\') order by account__c';
    
    global Database.QueryLocator start(Database.BatchableContext BC)
    {
        return Database.getQueryLocator(query);
    }
    
    // Method to update the Account Team Proxy record so to fire the outbound message for Fab Assignment in Account Team Proxy
    global void execute(Database.BatchableContext ctx, List<Sobject>  scope){
        List<Account_Team_Proxy__c> atpList = (List<Account_Team_Proxy__c>)scope;

        //Tlai 14032014  - UserId set with successful update of ATP
        set<id> usrIdSet = new set<id>();
        for(Integer i = 0; i < atpList.size(); i++){
        	usrIdSet.add(atpList[i].user__c);
        	
            //check if fab deleted field is blank, AIA will not set the fab deleted field to blank if an error occurs
            if(UtilsString.isNotBlank(atpList[i].user__r.fab_deleted__c)){
                String finalVal = '';
                String atpDeletedFabs = atpList[i].fab_deleted__c;
                String atpAssignedFabs = atpList[i].Fab_Assignment__c;// current Fab assignment 
                List<String> userDeletedFabList = atpList[i].user__r.fab_deleted__c.split('\\;');
                
                for(String fab: userDeletedFabList){
                    
                    //Tlai 14030124 -- if removed Fab on User has been assigend on ATP, then remove it on ATP. otherwise no action
                    if(UtilsString.isNotBlank(atpList[i].fab_deleted__c)){
                    	// check assigned Fabs againts removed fab on user
                        if(!atpDeletedFabs.contains(fab) && atpAssignedFabs.contains(fab)){
	                        finalVal += ';' + fab;
	                    }  
	                                  
	                } else {
	                	// check assigned Fabs againts removed fab on user
	                	if(atpAssignedFabs.contains(fab)){
	                		finalVal += fab +';';
	                	}
	                }
                }
                
                if(!String.isblank(finalVal)){
                	if( finalVal.endswith(';')){
                		finalVal = finalVal.substring(0,finalVal.length()-1).trim();//remove the ending character ';'
                	}
                	
                	if(UtilsString.isNotBlank(atpList[i].fab_deleted__c)){
	                	atpList[i].fab_deleted__c += finalVal; 
	                }else {
	                	atpList[i].fab_deleted__c = finalVal; 
	                }
                }
            }
            
            // Assign the Batch_Sync_Id__c of the Account Team Proxy to current datetime and assign Fab from User Level
            atpList[i].Batch_Sync_Id__c = String.valueof(System.now());
            atpList[i].Fab_Assignment__c = atpList[i].User__r.Fab_Assigned__c;
        } //end for loop
        
        // Update the Account Team Proxy records to send the outbound message
        List<Database.SaveResult> atpSRList = Database.update(atpList, false);
        
        for(integer i = 0; i< atpSRList.size(); i++){
            if(!atpSRList[i].isSuccess()){      
                usrIdSet.remove(atpList[i].user__c);
            }
        }
        
        // update users with success update of ATPs
        if(usrIdSet.size() > 0){      
            // Retrieve the users for whom Fab_Assignment_Change__c is true
            List<User> usrList = [select Id, Fab_Assignment_Change__c from User where Fab_Assignment_Change__c = true and id  in:usrIdSet];
            
            if(usrList.size() > 0){
            	
            	// Assign the Fab_Assignment_Change__c to false
	            for(Integer i=0; i< usrList.size(); i++){
	                usrList[i].Fab_Assignment_Change__c  = false;
	                usrList[i].fab_deleted__c = null;
	            }
	            // Update the users records to set the Fab_Assignment_Change__c checkbox as false
	            List<Database.SaveResult> usrSRList = Database.update(usrList, false);	
	            for(Database.SaveResult sr: usrSRList){
	            	if(!sr.isSuccess()){
	            		system.debug(sr.getErrors()[0].getMessage());
	            	}
	            }
	        }
        }
    }
    
    global void finish(Database.BatchableContext BC){

    }
    
   
    
}