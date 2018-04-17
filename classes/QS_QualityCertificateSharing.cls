/**
 * Author: Vijay Mahajan
 * Company: Cognizant Technology Solutions Asia Pacific Pte Ltd
 * Description: It is a QS_QualityCertificateSharing class. It contains actual business logic,
 *             to share the Quality Certificate with associated customers.
 * History:
 * <Vijay>     10032014 - class created
 * <Vijay>	   28032014 - This class is no longer in use, as Quality Certificate sharing  is handled on page level. commented below methods.	
 */
public without sharing class QS_QualityCertificateSharing{
    
    /**
     * This method instantiate Quality Certificate share record
     *
     * @param   parentId    Quality Certificate Id
     * @param   userId      User Id
     * @param   accessLevel specify access level (Read)
     * @return              instance of Quality_Certificate__Share object
     
    public Quality_Certificate__Share prepareQualityShare(Id parentId, Id userId, String accessLevel){
        System.debug('parentId----'+parentId +'------userId---'+ userId + '---accessLevel---'+accessLevel);
        return new Quality_Certificate__Share(ParentId = parentId, UserOrGroupId = userId, AccessLevel = accessLevel);
    }*/
    
    /**
     * This method shares the Quality Certifcate records based on associated customers
     *
     * @param   qualityCertificateList      List of PWCAPublication records
     * @param   qualityCertMap              Map of PWCAPublication Id and object.
     
    public void shareQualityCertificateShare(List<Quality_Certificate__c> qualityCertificateList, Map<Id, Quality_Certificate__c> qualityCertMap){
        Map<Id, List<Id>> qualityCertAccountListMap = new  Map<Id, List<Id>>();
        Set<Id> accountIdSet = new  Set<Id>();
        if((qualityCertificateList != null && !qualityCertificateList.isEmpty()) && (qualityCertMap != null && !qualityCertMap.isEmpty())){
            for(Quality_Certificate__c qualityCertObj: qualityCertificateList){
                System.debug('qualityCertObj----'+qualityCertObj);
                if(qualityCertObj.Stage__c == 'Approved'){
                   qualityCertAccountListMap.put(qualityCertObj.Id, new List<Id>());
                    List<QC_Access_List__c> qcAccessList = (qualityCertMap.get(qualityCertObj.Id) != null)?qualityCertMap.get(qualityCertObj.Id).JunctionObjectQcToAccounts__r: null;
                    if(qcAccessList != null && !qcAccessList.isEmpty()){
                        System.debug('qcAccessList==========='+qcAccessList);
                        for(QC_Access_List__c associateCustomer: qcAccessList){
                            qualityCertAccountListMap.get(qualityCertObj.Id).add(associateCustomer.Account__c);
                            accountIdSet.add(associateCustomer.Account__c);
                        }
                    }
                }
            }
        }
        System.debug('qualityCertAccountListMap----'+qualityCertAccountListMap);
        System.debug('accountIdSet-------------'+accountIdSet);
        Map<Id, List<User>> accountUserListMap = getUserAccounListMap(accountIdSet);
        System.debug('accountUserListMap-------------'+accountUserListMap);
        List<Quality_Certificate__Share> qualityCertShareList = new List<Quality_Certificate__Share>();
        try{
            if((qualityCertAccountListMap != null && !qualityCertAccountListMap.isEmpty()) && (accountUserListMap != null && !accountUserListMap.isEmpty())){
                for(Id qualityCertId:qualityCertAccountListMap.keySet()){
                    System.debug('qualityCertId-------------'+qualityCertId);
                    List<Id> accountIdList = qualityCertAccountListMap.get(qualityCertId);
                    for(Id accountId: accountIdList){
                        List<User> userIdList = accountUserListMap.get(accountId);
                        System.debug('accountId-------------'+accountId);
                        if(userIdList != null && !userIdList.isEmpty()){
                            for(User userObj : userIdList){
                                    System.debug('userObj-------------'+userObj);
                                    qualityCertShareList.add(prepareQualityShare(qualityCertId,userObj.Id,'Read'));
                            }
                        }
                    }
                }
            }
            if(qualityCertShareList != null && !qualityCertShareList.isEmpty()){
                Database.saveResult[] saveResultList = Database.insert(qualityCertShareList, false);
            }
            
        }catch(Exception e){
        }
    }*/
    
    /**
     * This method prepares the map, accountId as a key and list of user as a value
     *
     * @param   accountIdSet        set of account Ids
     * @return  accountUserListMap  Map of accountId and list of users
     
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