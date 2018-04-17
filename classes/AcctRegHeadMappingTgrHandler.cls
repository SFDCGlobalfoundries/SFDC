/*
    Author: 
    Description: This is handler class for AccountRegionHeadMappingTrigger
    History:
        Tlai		25072014	- Created
*/
public class AcctRegHeadMappingTgrHandler {
	public static boolean bypassOppTrigger = false;
	public static boolean bypassAcctTrigger = false;
	
	public static list<Account> updateAccount4NewMapping(set<id> usrIdSet, map<id, Account_Region_Head_Mapping__c> arhmap, map<id,Account_Region_Head_Mapping__c> acct2Arhm ){
		map<id, Account> returnResult = new map<id, Account>();
		map<id, User> userMap = new map<id, User>([select id,name,HCM_Login_ID__c from user where id in:usrIdSet and isactive = true]);
        map<id, id> acct2SVP = new map<id, id>();
        
        map<id, Account> accMap = new map<id, Account>();
        for(account acct :[select id, 
                                    Region_head_mapping__c, 
                                    //Region_Head_Backup_Name__c,
                                    Region_Head_Name__c,
                                    Region_Head__c,
                                    Region_Head_lk__c,
                                    Sales_SVP__c,
                                    Financial_Territory__c,
                                    Territory_Approver_lk__c
                                    //Region_Head_Backup__c 
                            from account 
                            where Region_head_mapping__c in :arhmap.keySet() or id in :acct2Arhm.keySet()]){
            /************************************************************************************************
            *                           Find Accounts related to the changed mappings                       *
            *************************************************************************************************/
            Account_Region_Head_Mapping__c temp;
            if(acct2Arhm.containsKey(acct.id)){
                temp = acct2Arhm.get(acct.id);
                acct.Region_head_mapping__c = temp.id;
            } else if(acct.Region_head_mapping__c != null && arhmap.containsKey(acct.Region_head_mapping__c)){
                temp = arhmap.get(acct.Region_head_mapping__c);
            } 
            
            if(temp != null) {
                /************************************************************************************************
                *                           sync region head & SVP on Account from the same on mapping          *
                *************************************************************************************************/
                acct.Region_head_mapping__c = temp.id;
                //acct.Region_Head_Backup_Name__c = (temp.region_head_backup_lk__c != null && userMap.containsKey(temp.region_head_backup_lk__c)) ? userMap.get(temp.region_head_backup_lk__c).name: null;
                //acct.Region_Head_Backup__c = (temp.region_head_backup_lk__c != null && userMap.containsKey(temp.region_head_backup_lk__c)) ? userMap.get(temp.region_head_backup_lk__c).HCM_Login_ID__c: null;
                acct.Region_Head_Name__c = (temp.region_head_lk__c != null && userMap.containsKey(temp.region_head_lk__c)) ? userMap.get(temp.region_head_lk__c).name :null;
                acct.Region_Head__c = (temp.region_head_lk__c != null && userMap.containsKey(temp.region_head_lk__c)) ?userMap.get(temp.region_head_lk__c).HCM_Login_ID__c : null;
                acct.Region_Head_lk__c = temp.region_head_lk__c;
                acct.Territory_Approver_lk__c = temp.Territory_Approver_LK__c;
                acct2SVP.put(acct.id, acct.Sales_SVP__c);
                acct.Sales_SVP__c = temp.Sales_SVP__c;              
                accMap.put(acct.id, acct);
            }
            
        }
        
        if(accMap.size()>0){ 
	        for(ProcessInstance pi : [select TargetObjectId 
	        								from ProcessInstance 
	        								where status = 'Pending' 
	        									and ProcessDefinitionId = '04a900000008gTp' //Process Name-> Invoice_Term_Change
	        									and TargetObjectId in : accMap.keySet()]){
	    		if(accMap.containsKey(pi.TargetObjectId)){
	    			/************************************************************************************************
					*							Reserve SVP on account when pending for SVP's approval				*
					*************************************************************************************************/
	    			accMap.get(pi.TargetObjectId).Sales_SVP__c = acct2SVP.get(pi.TargetObjectId);// recover SVP
	    		}							
	    	}
        
        	/************************************************************************************************
			*							Update Account														*
			*************************************************************************************************/
            Database.SaveResult[] srAcct = database.update(accMap.values(), false);
            for(Database.SaveResult sr :srAcct){
            	if(sr.isSuccess()){
            		returnResult.put(sr.getId(), accMap.get(sr.getId()));
            	}else{
            		Database.Error err = sr.getErrors()[0];
            		system.debug('Error->' + err.getStatusCode() + ' : ' + err.getMessage());
            	}
            }
        }
        
         return accMap.values();
	}
	
	public static list<Account> updateAccount4InactiveMappings(set<id> inActiveMappings){
		map<id,Account> returnResult = new map<id,Account>();
		list<Account> updateAcctList = new list<Account>();
		
		map<id, Account> acctMap = new map<id, Account> ();
    	/*for(Account acct : (list<Account>)database.query(strQuery)){
        	acctMap.put(acct.id, acct);
        }*/
        for(Account acct : [select id, 
                                    Region_head_mapping__c, 
                                    //Region_Head_Backup_Name__c,
                                    Region_Head_Name__c,
                                    Region_Head__c,
                                    Region_Head_lk__c,
                                    Sales_SVP__c,
                                    Financial_Territory__c,
                                    Territory_Approver_lk__c
                                    //Region_Head_Backup__c 
                            from account 
                            where Region_head_mapping__c in :inActiveMappings]){
            /************************************************************************************************
            *                           Find Accounts related to the inactive mappings                      *
            *************************************************************************************************/
            acctMap.put(acct.id, acct);
        }
        
        if(acctMap.size() > 0){
            /****************************** Step 1 find account which has been submitted to SVP for approval**********************/
            // acct pending for SVP approval shouldn't change SVP
            set<id> acctIdSetForApprvl = new set<id>();
            for(ProcessInstance pi : [select TargetObjectId 
                                        from ProcessInstance 
                                        where status = 'Pending' 
                                            and ProcessDefinitionId = '04a900000008gTp' //Process Name-> Invoice_Term_Change
                                            and TargetObjectId in : acctMap.keySet()]){
            /************************************************************************************************
            *                           Find Accounts which are pending for SVP approval                    *
            *************************************************************************************************/
                acctIdSetForApprvl.add(pi.TargetObjectId);                          
            }
            
            /****************************** Step 2 populate arhMap ******************************************/
            // arhMap to get information of all Account_Region_Head_Mapping__c records
            map<String, Account_Region_Head_Mapping__c> arhMap = new map<String, Account_Region_Head_Mapping__c>();
            
            for(Account_Region_Head_Mapping__c arhm : [select id,
                                                                Strategic_Account__c,
                                                                Sales_SVP__c, 
                                                                Sales_Territory__c,
                                                                region_head_lk__c,
                                                                //region_head_backup_lk__c,
                                                                region_head_lk__r.name,
                                                                region_head_lk__r.HCM_Login_ID__c,
                                                                Territory_Approver_LK__c
                                                                //region_head_backup_lk__r.name,
                                                                //region_head_backup_lk__r.HCM_Login_ID__c 
                                                            from Account_Region_Head_Mapping__c
                                                            where isActive__c = true]){
                /************************************************************************************************
                *                           Find all active mappings                                            *
                *************************************************************************************************/
                if(arhm.Strategic_Account__c != null){
                    arhMap.put(arhm.Strategic_Account__c, arhm);
                } else {
                	arhMap.put(arhm.Sales_Territory__c, arhm);
                }
            }
            
            
            /****************************** Step 3 populate updateAcctList ******************************************/
            
            for(Account acct :  acctMap.values()){
                Account_Region_Head_Mapping__c temp;
                if(arhMap.containsKey(acct.id)){
                    temp = arhMap.get(acct.id);
                } else if(arhMap.containsKey(acct.Financial_Territory__c)){
                    temp = arhMap.get(acct.Financial_Territory__c);
                }
                
                if(temp != null){
                    /************************************************************************************************
                    *                           sync region head & svp on account from the same on mapping          *
                    *************************************************************************************************/
                    acct.Region_head_mapping__c = temp.id;
                    
                    //acct.Region_Head_Backup_Name__c = temp.region_head_backup_lk__c != null  ? temp.region_head_backup_lk__r.name : null;
                    //acct.Region_Head_Backup__c = temp.region_head_backup_lk__c != null  ? temp.region_head_backup_lk__r.HCM_Login_ID__c : null;
                    acct.Region_Head_Name__c = temp.region_head_lk__c != null  ? temp.region_head_lk__r.name :null;
                    acct.Region_Head__c = temp.region_head_lk__c != null ? temp.region_head_lk__r.HCM_Login_ID__c : null;
            
                    acct.Region_Head_lk__c = temp.region_head_lk__c;
                    acct.Sales_SVP__c = acctIdSetForApprvl.contains(acct.id)?acct.Sales_SVP__c:temp.Sales_SVP__c;//Reserve old svp if account is pending for svp approval
                    acct.Territory_Approver_LK__c = temp.Territory_Approver_LK__c;
                    updateAcctList.add(acct);
                }
                
            }
            
            /****************************** Step 4 update updateAcctList ******************************************/
            if(updateAcctList.size() > 0){
                /************************************************************************************************
                *                           Update accounts                                                     *
                *************************************************************************************************/
                Database.SaveResult[] srAcct = database.update(updateAcctList, false);
                for(Database.SaveResult sr :srAcct){
                    if(sr.isSuccess()){
                        returnResult.put(sr.getId(),acctMap.get(sr.getId()));
                    }else{
                        Database.Error err = sr.getErrors()[0];
                        system.debug('Error->' + err.getStatusCode() + ' : ' + err.getMessage());
                    }
                }
            }
        }
        
        return updateAcctList;
	}
	
	public static void updateOppty(list<account> acctlist){
		if(acctlist.size() > 0){
			list<Opportunity> oppList = new list<Opportunity>();
	        for(Opportunity opp : [select id,Territory_Head_for_Review__c,Sales_SVP_for_Review__c,accountId,Design_Win_Review_Status__c,account.Region_head_mapping__r.region_head_lk__c,
	            													account.Region_head_mapping__r.Sales_SVP__c from Opportunity where accountId in : acctlist]){
	        	
	        	boolean flag = false;
	        	if(opp.Design_Win_Review_Status__c != 'Submitted for Review' &&  opp.Design_Win_Review_Status__c != 'Won'){
	        		opp.Territory_Head_for_Review__c = opp.account.Region_head_mapping__r.region_head_lk__c;//accMap.get(opp.accountId).region_head_lk__c;
	        		flag = true;
	        	}
	        	
	        	if(opp.Design_Win_Review_Status__c != 'Recommend for Approval' &&  opp.Design_Win_Review_Status__c != 'Recommend for Rejection' &&  opp.Design_Win_Review_Status__c != 'Won' ){
	        		opp.Sales_SVP_for_Review__c = opp.account.Region_head_mapping__r.Sales_SVP__c;//accMap.get(opp.accountId).Sales_SVP__c;
	        		flag = true;
	        	}
	        	
	        	if(flag) oppList.add(opp);
	        	
	        }
	        
	        if(oppList.size() > 0){
	        	Database.SaveResult[] srOppty = database.update(oppList, false);
	        }
		}
	}
}