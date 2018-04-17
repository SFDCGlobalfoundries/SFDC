/*
    Author: Anirban Roy
    Description: This is the helper class to validate user for PPE Team.  
    History:
        ARoy        03222014    - code creation.
        ARoy		05262014	- modified code to fix the issue for Case 00023658.
*/

public class PPETeamHelper {
       
    // User retrieval from PPM Team Group
    public static List<GroupMember> getUserInGroup(String userId, List<String> grpDevName){
        
        List<GroupMember> gmList  =   [ select      id
                                                    , group.developername
                                                    , UserOrGroupId
                                        from        GroupMember
                                        where       UserOrGroupId = :userId
                                        and         group.developername in :grpDevName
                                      ];
                                      
        return gmList;
    }
    
    // User retrieval from PPE Team based on set of GMPLs/BX009s
    /*public static List<PPE_Team__c> getUserInPPETeam(String userId, List<String> gmplBx009Ids){
        
        List<PPE_Team__c> pTList =  [select     Id
                                                , PPE_Role__c
                                                , User__c
                                                , Access_Level__c
                                                , GMPL_BX009__c
                                     from       PPE_Team__c
                                     where      User__c = :userId
                                     and        GMPL_BX009__c in :gmplBx009Ids          
                                    ];
                                      
        return pTList;
    }*/
    
    // Get the User profile
    public static Profile getUserProfile(){
    	Profile prof = [select    Id
                                  ,Name 
                        from      Profile
                        where     Id = :UserInfo.getProfileId()
                       ];
        return prof;
    }
    
    // Get the shared users in the GMPL/BX009 records
    public static List<GMPL_BX009__Share> getGMPLBX009ShareUser(Id gmplBx009Id){
    	Set<Id> userOrGrpIds = new Set<Id>{UserInfo.getUserId()};
    	system.debug('UserInfo.getUserId()#######::'+UserInfo.getUserId());
    	for(GroupMember gm : [select	GroupId
							  from		GroupMember
							  where		UserOrGroupId = :UserInfo.getUserId()]){
        	userOrGrpIds.add(gm.GroupId);
        }
        system.debug('userOrGrpIds#######::'+userOrGrpIds);                            
        
        List<GMPL_BX009__Share> gmplList =  [SELECT  id
        											 , UserOrGroupId 
						                     FROM    GMPL_BX009__Share 
						                     WHERE   ParentId = :gmplBx009Id						                     
						                     AND	 AccessLevel in ('Edit','All')
						                    ];
		system.debug('gmplList#######::'+gmplList);
		
		Integer i=0;
		for(GMPL_BX009__Share gmplShare : gmplList){
			if(userOrGrpIds.contains(gmplShare.UserOrGroupId)){
				i++;
				break;
			}
		}
		
		if(i==0){
			gmplList.clear();
		}
		
		return gmplList; 				                    
    }  
}