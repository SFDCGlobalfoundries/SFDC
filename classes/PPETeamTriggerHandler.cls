/*
    Author: Anirban Roy
    Description: This is the helper class for the trigger PPETeamTrigger.  
    History:
        ARoy        03192014    - code creation.
*/

public class PPETeamTriggerHandler {
    
    public static string GMPLBX009_SHARE = EnvironmentVariable.get('GMPL_BX009_SHARE_REASON');
    /*public static Boolean hasRun = false;    
    public static Set<String> ppeRoleAllowed = new Set<String>{'Project Lead','Account Manager','Product Marketing'};
    public static String sysAdmin = EnvironmentVariable.get('SYS_ADMIN');
    public static String ctsDev = EnvironmentVariable.get('CTS_DEVELOPER');
    public static String gfDev = EnvironmentVariable.get('GF_DEVELOPER');
    public static String gfSysAdmin = EnvironmentVariable.get('GF_SYSTEM_ADMIN');
    public static String gfGlbAdmin = EnvironmentVariable.get('GF_GLOBAL_ADMIN');
    public static String gfInt = EnvironmentVariable.get('GF Integration');*/
    public static map<string,string> RECORD_ACCESS = new map<string,string>{EnvironmentVariable.get('PPE_TEAM_RW_PERM')=>'Edit',EnvironmentVariable.get('PPE_TEAM_READ_PERM')=>'Read'};
    
    // Adding to the GMPL/BX009 share with Read/Edit permission
    public static void addtoGMPLShare(List<PPE_Team__c> ppeTeamList){
        List<GMPL_BX009__Share> gmplBx009ShareList = new List<GMPL_BX009__Share>();
        for(PPE_Team__c p : ppeTeamList){
            GMPL_BX009__Share gmplBx009Share = new GMPL_BX009__Share();
            gmplBx009Share.AccessLevel = RECORD_ACCESS.get(p.Access_Level__c);
            gmplBx009Share.ParentId = p.GMPL_BX009__c;
            gmplBx009Share.RowCause = GMPLBX009_SHARE;
            gmplBx009Share.UserOrGroupId = p.User__c;
            gmplBx009ShareList.add(gmplBx009Share);
        }
        
        if(gmplBx009ShareList.size()>0){
            insert gmplBx009ShareList;
        }
    }
    
    // Remove the user from the GMPL/BX009 share
    public static void removeFromGMPLShare(List<PPE_Team__c> ppeTeamList){
        Set<Id> userIds = new Set<Id>();
        Set<Id> gmplIds = new Set<Id>();
        for(PPE_Team__c p : ppeTeamList){
            userIds.add(p.User__c);
            gmplIds.add(p.GMPL_BX009__c);
        }
        
        List<GMPL_BX009__Share> gmplList =  [   SELECT  id 
                                                FROM    GMPL_BX009__Share 
                                                WHERE   ParentId=:gmplIds 
                                                AND     UserOrGroupId in :userIds
                                                AND     RowCause = :GMPLBX009_SHARE
                                            ];


        if(gmplList!=null && gmplList.size()>0){
            delete gmplList;
        }
    }
    
    //Validation for Duplicate User in PPE Team
    public static void validateDuplicateUser(List<PPE_Team__c> ppeTeamList){
        Set<Id> gmplIds = new Set<Id>();
        Map<Id,Set<Id>> gmplUsrIdMap = new Map<Id,Set<Id>>();
        Map<Id,String> gmplUserIdNameMap = new Map<Id,String>();
        
        for(PPE_Team__c p : ppeTeamList){
            gmplIds.add(p.GMPL_BX009__c);
        }       
            
        for(PPE_Team__c p : [SELECT     ID
                                        , User__c
                                        , User__r.Name
                                        , PPE_Role__c
                                        , GMPL_BX009__c
                              FROM      PPE_Team__c 
                              WHERE     GMPL_BX009__c in :gmplIds                                              
                             ]){
            if(!gmplUsrIdMap.isEmpty() && gmplUsrIdMap.get(p.GMPL_BX009__c) != null){
                gmplUsrIdMap.get(p.GMPL_BX009__c).add(p.User__c);
            }else{
                gmplUsrIdMap.put(p.GMPL_BX009__c,new Set<Id>{p.User__c});
            }
            gmplUserIdNameMap.put(p.User__c, p.User__r.Name);
        }
        
        for(PPE_Team__c p : ppeTeamList){
            
            if(!gmplUsrIdMap.isEmpty() && gmplUsrIdMap.get(p.GMPL_BX009__c) != null
                    && gmplUsrIdMap.get(p.GMPL_BX009__c).contains(p.User__c)){
                p.addError(Error_Codes__c.getInstance('PPE_TEAM_DUP_USER_VALIDATION').Message__c 
                           + ' '+ gmplUserIdNameMap.get(p.User__c) + ' is already added in the PPE Team.');
            }
            
        }
    }
    
    //Add PPE Team members to follow GMPL/BX009 records
    public static void addPPETeamToFollowGMPL(List<PPE_Team__c> ppeTeamList){    	    	
    	
    	Set<String> activeUserIds = new Set<String>();
    	Set<Id> gmplIds = new Set<Id>();
    	Set<Id> userIds = new Set<Id>();    	    	
    	Set<String> gmplFollowers = new Set<String>();
    	List<EntitySubscription> insertGmplFollowers = new List<EntitySubscription>();
    	
    	for(PPE_Team__c pT : ppeTeamList){
    		if(pT.GMPL_BX009__c != null){
    			gmplIds.add(pT.GMPL_BX009__c);
    		}
    	}
    	
    	//making sure that only Active Users are inserted/updated
        for (user u:[select id from User where IsActive = true]){
            activeUserIds.add(u.id);
        }
    	
        //query the EntitySubscription table to get all records affected
        for (EntitySubscription gmplES: [SELECT 	id
        											, parentid
        											, subscriberid 
        								 FROM 		EntitySubscription 
        								 WHERE 		parentid in :gmplIds 
        								 AND 		subscriberid in :activeUserIds]){
            gmplFollowers.add(String.valueOf(gmplES.parentid) + String.valueOf(gmplES.subscriberid));
        }
        
        //build the list of new Followers to Create
        for (PPE_Team__c pT: ppeTeamList){
            //only process records for an active user                    
            if (activeUserIds.contains(pT.User__c)){
                //The user is not present in the entity subscription, so need to create a new Entity Subscription
                if (!gmplFollowers.contains(String.valueOf(pT.GMPL_BX009__c) + String.valueOf(pT.User__c))){
                    insertGmplFollowers.add(new EntitySubscription(SubscriberId=pT.User__c, ParentId= pT.GMPL_BX009__c));
                }
            }
        }               
            
        //update the list of GMPL Follower records
        if(insertGmplFollowers.size()>0){
        	//try{
        		insert insertGmplFollowers;
        	/*}catch(Exception e){
        		system.debug('Error occurred while adding auto-follow : '+ e.getMessage());
        	}*/
        }
    }
    
    //Add PPE Team members to follow GMPL/BX009 records
    public static void removePPETeamToFollowGMPL(List<PPE_Team__c> ppeTeamList){    
    	
    	Set<Id> gmplIds = new Set<Id>();
    	Set<Id>	userIds = new Set<Id>();
    	List<EntitySubscription> removeGmplFollowers = new List<EntitySubscription>();
    	
    	for(PPE_Team__c pT : ppeTeamList){
    		if(pT.GMPL_BX009__c != null){
    			gmplIds.add(pT.GMPL_BX009__c);
    		}
    		if(pT.User__c != null){
    			userIds.add(pT.User__c);
    		}
    	}
    	
    	for(EntitySubscription esGMPL : [SELECT		id
    									 FROM		EntitySubscription
    									 WHERE		SubscriberId in :userIds
    									 AND		ParentId in :gmplIds]){
    		removeGmplFollowers.add(esGMPL);		
    	}
    	
    	if(removeGmplFollowers.size()>0){
    		//try{
        		delete removeGmplFollowers;
        	/*}catch(Exception e){
        		system.debug('Error occurred while removing auto-follow : '+ e.getMessage());
        	}*/
    	}
    }
    
    //Validate for User Permission to create/edit/delete PPE Team
    /*public static void validateUserPermission(List<PPE_Team__c> ppeTeamList){
                       
        List<GroupMember> gm  = PPETeamHelper.getUserInGroup(UserInfo.getUserId(),new List<String>{'PPM_Team_Group'});
                                    
        if(gm==null || gm.size()==0){
            
            Set<String> gmplIds = new Set<String>();
            //Identify the record is GMPL
            for(PPE_Team__c p : ppeTeamList){
                gmplIds.add(p.GMPL_BX009__c);
            }            
            
            Set<String> gmplLstIds = new Set<string>();
            Set<String> bx009Ids = new Set<String>();
            
            for(GMPL_BX009__c gmpl : [select     Id
                                                 , G0_Disposition__c
                                      from       GMPL_BX009__c
                                      where      id in :gmplIds]){
                if(gmpl.G0_Disposition__c == 'Approved to BX009'){
                    bx009Ids.add(gmpl.Id);                      
                }else{
                    gmplLstIds.add(gmpl.Id);
                }
            }                       
            
            Map<String,Set<String>> gmplBX009UserMap = new Map<String,Set<String>>();
            
            List<String> tempPPETeamList = new List<String>();
            if(gmplIds!=null){
                tempPPETeamList.addAll(gmplIds);
            }
            
            for(PPE_Team__c p : PPETeamHelper.getUserInPPETeam(UserInfo.getUserId(),tempPPETeamList)){
                
                if(gmplLstIds!=null && gmplLstIds.contains(p.GMPL_BX009__c)){
                    if(p.PPE_Role__c == 'Product Marketing'){
                        if(gmplBX009UserMap.containsKey(p.GMPL_BX009__c)){
                            gmplBX009UserMap.get(p.GMPL_BX009__c).add(p.User__c);
                        }else{
                            gmplBX009UserMap.put(p.GMPL_BX009__c,new Set<String>{p.User__c});
                        }
                    }
                }else if(bx009Ids!=null && bx009Ids.contains(p.GMPL_BX009__c)){
                    if(gmplBX009UserMap.containsKey(p.GMPL_BX009__c)){
                        gmplBX009UserMap.get(p.GMPL_BX009__c).add(p.User__c);
                    }else{
                        gmplBX009UserMap.put(p.GMPL_BX009__c,new Set<String>{p.User__c});
                    }
                }
                
            }
            
            system.debug('UserInfo.getUserId() ==> '+UserInfo.getUserId());
            system.debug('gmplLstIds ==> '+gmplLstIds);
            system.debug('bx009Ids ==>'+bx009Ids);
            system.debug('gmplBX009UserMap ==> '+gmplBX009UserMap);
            
            Boolean isCheckNotNeeded = false;
            
            Profile prof = [select    Id
                                      ,Name 
                            from      Profile
                            where     Id = :UserInfo.getProfileId()
                           ];
    
            if(prof.Name == sysAdmin || prof.Name == ctsDev || prof.Name == gfDev
                || prof.Name == gfSysAdmin || prof.Name == gfGlbAdmin || prof.Name == gfInt){
                isCheckNotNeeded = true;            
            }
            
            for(PPE_Team__c p : ppeTeamList){
                if(!isCheckNotNeeded && (gmplBX009UserMap.isEmpty() || (gmplBX009UserMap.containsKey(p.GMPL_BX009__c) 
                        && !(gmplBX009UserMap.get(p.GMPL_BX009__c).contains(UserInfo.getUserId()))))){
                    if(gmplLstIds.contains(p.GMPL_BX009__c)){
                        p.addError('Only PPM and PM can add/modify/remove PPE Team members.');
                    }
                    if(bx009Ids.contains(p.GMPL_BX009__c)){
                        p.addError('Only PPM and PPE Team Member(s) can add/modify/remove PPE Team members.');
                    }
                }
            }
        }
    }*/    
}