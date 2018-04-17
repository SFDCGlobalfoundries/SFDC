/*
     Author: Deepti Narayan Biswal
     Description: Extension class for PSP_CustomCEUsersLookup Page.
     History:
        DBiswal    05212016    Created.
        DBiswal    05302017    Added user lookup for ASIC (line no. 44-57).

*/
public class PSP_CustomCEUsersLookupController {
    
    public String accId {get;set;}
    public List<ceUsersWrapper> listceUsersWrapper {get;set;}
    public List<User> listceUsers {get;set;}
    public String userval {get;set;}
    public String asicFlag {get;set;}
    
    public PSP_CustomCEUsersLookupController(){
        accId = ApexPages.currentPage().getParameters().get('accid');
        String oppProgId = ApexPages.currentPage().getParameters().get('oppProgid');
        asicFlag = ApexPages.currentPage().getParameters().get('isASIC');
        Set<Id> usrIdSet = new Set<Id>();
        if(asicFlag == 'true'){
            for(Opportunity_Program_Team_Member__c optm : [SELECT Id,User__c,User__r.Name,Team_Role__c FROM Opportunity_Program_Team_Member__c WHERE Opportunity_Program__c =: oppProgId]){
                usrIdSet.add(optm.User__c);
            }
        } else{
            for(Account_Team_Proxy__c atp : [SELECT Id,User__c,User__r.Name,Team_Role__c FROM Account_Team_Proxy__c WHERE Account__c =: accId and Team_Role__c = 'Customer Engineer']){
                usrIdSet.add(atp.User__c);
            }
        }
        
        listceUsersWrapper = new List<ceUsersWrapper>();
        listceUsers = new List<User>();
        if(usrIdSet.size()>0){
            for(User usr :[SELECT Id,Name,Title,Email,Phone FROM User WHERE Id IN : usrIdSet AND IsActive = TRUE]){
                listceUsersWrapper.add(new ceUsersWrapper(usr,false));
                listceUsers.add(usr);
            }
        } else {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'No Users Found.'));
        }
    }
    //DBiswal - 05302017    Added user lookup for ASIC.
    public void searchUsers(){
        if(userval != '' && userval != null){
            listceUsers = new List<User>();
            String usrStr = '%' + userval + '%';
            for(User usr :[SELECT Id,Name,Title,Email,Phone FROM User WHERE Name LIKE :usrStr AND IsActive = TRUE AND UserType = 'Standard']){
                listceUsers.add(usr);
            }
            if(listceUsers.size() == 0){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'No Users found.'));
            }
        } else {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'Please enter some value for search.'));
        }
    }
    
    public class ceUsersWrapper{
        public User ceUser {get;set;}
        public Boolean isSelected {get;set;}
        
        public ceUsersWrapper(User eachUser,Boolean value) {
            ceUser = eachUser;
            isSelected = value;
        }
    }
}