/*
Type Name: clsDisablePortalUserController
Author: Cognizant 
Created Date: 03-May-2013
Reason: This class is used for deactivating the portal contact and its corresponding Portal user- whenever a Contact is disabled as a portal User
Change History:
Author: 
Modified Date: 
Reason: 
……..
……..
*/

public class clsDisablePortalUserController {

    private Contact objContact;
    public String sMsg{get;set;}
    public String sSeverity{get;set;}
    public String redirectUrl {get; set;}
     
    /**
        This constructor sets the contact sobject details into the sObject. It also instantiate the class for accessing from the page
        
        @method name: clsDisablePortalUserController
        @parameter:   Set the standard controller sObject record details in to the controller.
        @return :     none
    **/
    
    public clsDisablePortalUserController(ApexPages.StandardController controller) {
                //Sets the local class variable with the contact record detail captured in the page
                this.objContact = (Contact)controller.getRecord();
                //Sets this variable to refresh the contact page after update operation has been executed.
                String sDomain=System.Label.Salesforce_Domain_URL;
                String sParent_Domain=Apexpages.currentPage().getParameters().get('parent_domain');
                if (sParent_Domain.contains(sDomain)){
                    String sCommunityName=System.Label.Community_Name;
                    this.redirectUrl ='/' + sCommunityName +'/'+this.objContact.Id;
                } else {
                    this.redirectUrl ='/'+this.objContact.Id;
                }
      }
      
    /**
        This method checks whether the user has appropriate user permission to deactivate portal user. 
        System Admin users will have permission to deactivate any portal user
        
        @method name: checkUserPermission
        @parameter:   none
        @return :     Boolean
    **/
    
        private Boolean checkUserPermission(){
            try{
                sMsg='';
                sSeverity='';
                
                
                //Checking whether the user exists in the Account team of the Account related to the user
                List<AccountTeamMember> AccountTeamList=new List<AccountTeamMember>();
                AccountTeamList=[Select id from AccountTeamMember 
                                                    Where AccountTeamMember.AccountId=:objContact.AccountId 
                                                    And AccountTeamMember.UserId=:Userinfo.getUserId()]; 
                                                    
                System.debug('AccountTeamList---------->'+AccountTeamList);
                
                Boolean blnInAccountTeam=false;
                if (AccountTeamList.size()==0){
                    blnInAccountTeam=false;
                }else{
                    blnInAccountTeam=true;
                }
                
                //Retrieves the permissionset which has setting for the user deactivation.
                PermissionSet objPermissionset=[Select PermissionsManageUsers, Name, Id From PermissionSet where Name='Portal_User_Management_Permission_Set'];
                List<PermissionSetAssignment> permissionSetAssignmentList=new List<PermissionSetAssignment>();
                //Retrieves the profile id for the system admin and all portal admin
                List<String> profileNameList=new List<String>();
                profileNameList.add(System.Label.CustomerPortalAdmin);
                //Cased # 10023
                //Added Overage Portal profiles in the list
                profileNameList.add(System.Label.OverageCustomerPortalAdmin);
                profileNameList.add(System.Label.OverageSupplierPortalAdmin); 
                profileNameList.add(System.Label.OverageResellerPortalAdmin); 
                profileNameList.add(System.Label.OverageEnablementPartnerPortalAdmin);  
                profileNameList.add(System.Label.EnablementPartnerPortalAdmin);
                profileNameList.add(System.Label.ResellerPortalAdmin);
                profileNameList.add(System.Label.SupplierPortalAdmin);
                profileNameList.add(System.Label.GFRegionalAdmin);
                profileNameList.add(System.Label.GFGlobalAdmin);
                profileNameList.add(System.Label.GFSystemAdmin);
                //Below three profiles are added by Sunil Arora for case # 23605
                profileNameList.add(System.Label.GF_FAE_FTS);
                profileNameList.add(System.Label.GFCSR);
                profileNameList.add(System.Label.GFSales);
                //Code end for case # 23605
                profileNameList.add('System Administrator');
                Boolean blnAllowUserProfile=false;
                for (Profile objProfile:[Select id from Profile where Name IN: profileNameList]){
                    if ((Userinfo.getProfileId()==objProfile.Id)){
                        blnAllowUserProfile=true;   
                    }
                }
                //Retrieves the id from the permission Assignment set which has the user assigned with the permission set
                System.debug('^^^^ User Id: ' + userinfo.getUserId());
                System.debug('^^^^ PermissionSet Assignment Id: ' + objPermissionset.Id);
                
                permissionSetAssignmentList=[Select id From PermissionSetAssignment where PermissionSetId=:objPermissionset.Id AND AssigneeId=:Userinfo.getUserId()];
                
                if (permissionSetAssignmentList.size()==0 && blnAllowUserProfile==false){
                    sMsg='User does not have appropriate permission to deactivate a portal user';
                    sSeverity='error';
                    return false;
                }else if (blnInAccountTeam==false && permissionSetAssignmentList.size()>0) {
                    sMsg='User does not have appropriate permission to deactivate a portal user';
                    sSeverity='error';
                    return false;
                }else if (blnInAccountTeam==true && permissionSetAssignmentList.size()>0){
                    return true;                    
                }else if (blnAllowUserProfile==true) {
                    return true;
                } else {
                    sMsg='User does not have appropriate permission to deactivate a portal user';
                    sSeverity='error';
                    return false;
                }
            } catch(Exception ex){
                sMsg=ex.getMessage();
                sSeverity='error';      
                return false;   
            }
        }

    /**
        This function calls the method to deactivate the user and also set the contact field Is_Portal_User_Active__c to false
        @method name: deactivateContact
        @parameter:   none
        @return :     Pagereference
    **/         
        public Pagereference deactivateContact(){
            sMsg='';
            sSeverity='';
            try {
                //Fetches the contact information 
                Contact objContactToUpdate=[SELECT Id,Is_Portal_User_Active__c,Is_Portal_User_Created__c FROM Contact WHERE id=:objContact.Id];
                if (objContactToUpdate.Is_Portal_User_Active__c==false){
                    sMsg='User is already deactivated';
                    sSeverity='info';
                    return null;    
                } else{
                    if (checkUserPermission()) {    
                        objContactToUpdate.Is_Portal_User_Active__c = false;      
                        //updates the contact record
                        update objContactToUpdate;
                        
                        //prepares the data to call the method deactivateContactUser in the ClsAccTriggerHandler class to deativate the user
                        List<Id> contactIdList=new List<Id>();
                        contactIdList.add(this.objContact.Id);
                        //calls the method to deactivate the user
                        ClsAccTriggerHandler.deactivateContactUser(contactIdList);
                        sMsg='User deactivated successfully.';
                        sSeverity='info';
                        return null;
                    } else {
                        return null;
                    }
                }
            }catch(Exception ex){
                sMsg=ex.getMessage();
                sSeverity='error';      
                return null;
            }
        
        }  
        
        
}