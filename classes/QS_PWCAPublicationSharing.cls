/**
 * Author: Vijay Mahajan
 * Company: Cognizant Technology Solutions Asia Pacific Pte Ltd
 * Description: It is a QS_PWCAPublicationSharing class. It contains actual business logic,
 *             to share the PWCA publication with associated customers.
 * History:
 * <Vijay>     04032014 - class created
 * <Vijay>	   28032014 - This class is no longer in use, as PWCA Publication sharing  is handled on page level. commented below methods.
 */
public without sharing class QS_PWCAPublicationSharing{
    
    /**
     * This method instantiate PWCA publication share record
     *
     * @param	parentId	PWCA Publication Id
     * @param	userId		User Id
     * @param	accessLevel specify access level (Read)
     * @return  			instance of PWCA_publication__Share object
     *
    public PWCA_publication__Share preparePWCAPublicationShare(Id parentId, Id userId, String accessLevel){
        System.debug('parentId----'+parentId +'------userId---'+ userId + '---accessLevel---'+accessLevel);
        return new PWCA_publication__Share(ParentId = parentId, UserOrGroupId = userId, AccessLevel = accessLevel);
    }*/
    
    /**
     * This method shares the PWCA Publication records based on associated customers
     *
     * @param	pwcaPublicationList		List of PWCAPublication records
     * @param	pwcaPublicationMap		Map of PWCAPublication Id and object.
     *
    public void sharePWCAPublicationShare(List<PWCA_publication__c> pwcaPublicationList, Map<Id, PWCA_publication__c> pwcaPublicationMap){
        Map<Id, List<Id>> pwcaPublicationAccountListMap = new  Map<Id, List<Id>>();
        Set<Id> accountIdSet = new  Set<Id>();
     	if((pwcaPublicationList != null && !pwcaPublicationList.isEmpty()) && (pwcaPublicationMap != null && !pwcaPublicationMap.isEmpty())){
	        for(PWCA_publication__c pwcaPublicationObj: pwcaPublicationList){
	            System.debug('pwcaPublicationObj----'+pwcaPublicationObj);
	            if(pwcaPublicationObj.Ready_to_Publish__c){
	               pwcaPublicationAccountListMap.put(pwcaPublicationObj.Id, new List<Id>());
	               List<PWCAAssociated_Customers__c> pwcaAssociatedCustomerList = (pwcaPublicationMap.get(pwcaPublicationObj.Id) != null)?pwcaPublicationMap.get(pwcaPublicationObj.Id).Associated_Customers__r:null;
	               if(pwcaAssociatedCustomerList!= null && !pwcaAssociatedCustomerList.isEmpty()){
	                   for(PWCAAssociated_Customers__c associateCustomer: pwcaAssociatedCustomerList){
	                       pwcaPublicationAccountListMap.get(pwcaPublicationObj.Id).add(associateCustomer.Account__c);
	                       accountIdSet.add(associateCustomer.Account__c);
	                   }
	               }
	            }
	        }
     	}
        System.debug('pwcaPublicationAccountListMap----'+pwcaPublicationAccountListMap);
        System.debug('accountIdSet-------------'+accountIdSet);
        Map<Id, List<User>> accountUserListMap = getUserAccounListMap(accountIdSet);
        System.debug('accountUserListMap-------------'+accountUserListMap);
        List<PWCA_publication__Share> pwcaPublicationShareList = new List<PWCA_publication__Share>();
        try{
            if((pwcaPublicationAccountListMap != null && !pwcaPublicationAccountListMap.isEmpty()) && (accountUserListMap != null && !accountUserListMap.isEmpty())){
                for(Id pwcaPublicationId:pwcaPublicationAccountListMap.keySet()){
                    System.debug('pwcaPublicationId-------------'+pwcaPublicationId);
                    List<Id> accountIdList = pwcaPublicationAccountListMap.get(pwcaPublicationId);
                    for(Id accountId: accountIdList){
                        List<User> userIdList = accountUserListMap.get(accountId);
                        System.debug('accountId-------------'+accountId);
                        if(userIdList != null && !userIdList.isEmpty()){
                            for(User userObj : userIdList){
                                    System.debug('userObj-------------'+userObj);
                                    pwcaPublicationShareList.add(preparePWCAPublicationShare(pwcaPublicationId,userObj.Id,'Read'));
                            }
                        }
                    }
                }
            }
            if(pwcaPublicationShareList != null && !pwcaPublicationShareList.isEmpty()){
                Database.saveResult[] saveResultList = Database.insert(pwcaPublicationShareList, false);
            }
            
        }catch(Exception e){
        
        }
    }*/
    
    /**
     * This method prepares the map, accountId as a key and list of user as a value
     *
     * @param	accountIdSet		set of account Ids
     * @return  accountUserListMap	Map of accountId and list of users
     *
    private Map<Id, List<User>> getUserAccounListMap(Set<Id> accountIdSet){
        Map<Id, List<User>> accountUserListMap = new Map<Id, List<User>>();
              
        List<User> userList = null;
        if(accountIdSet != null && !accountIdSet.isEmpty()){
            userList = QS_CommonUtil.getUsers(accountIdSet); 
        }
        
        if(userList != null && !userList.isEmpty()){
            for(User userObj: userList){
                if(userObj.Contact.AccountId != null){
                    if(!accountUserListMap.containsKey(userObj.Contact.AccountId)){
                        accountUserListMap.put(userObj.Contact.AccountId, new List<User>());
                    }
                    accountUserListMap.get(userObj.Contact.AccountId).add(userObj);
                }
            }
        }
        return accountUserListMap;
    }*/
    
              
}