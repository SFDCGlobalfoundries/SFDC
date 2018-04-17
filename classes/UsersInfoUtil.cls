/*
  Author: Win
  Description: provide services to retrieve user related infor like Account contacts, account team proxy, team role, etc.
  History:
    win        07022013    - code creation.
    ARoy       11222013    - modified code to use portal_email__c instead of email field of User.                       
    ARoy       03082017    - Uncommented the contacts query and added check for Export_Control_Form flag                       
*/
public class UsersInfoUtil {
    
    private List<SelectOption> allAccountContacts {get; set;}
    
    public List<SelectOption> getIpDecFormContacts(Id ipDeclarationFormId) {
        if(isEmployee()){
            return getUserOptionsByIpFormId(ipDeclarationFormId);
        }
        return getMyAccountContactOptions();
    }
    
    public List<SelectOption> getExpControlFormContacts(Id expControlFormId) {
        if(isEmployee()){
            return getUserOptionsByExpFormId(expControlFormId);
        }
        return getExpContMyAccountContactOptions(expControlFormId);
    }
    
    private String custContactId = null;
    private String custAccountId = null;
    
    /**
     * used by GF staff who managing the IP Declaration Form.
    */
    private List<SelectOption> getUserOptionsByIpFormId(Id ipDeclarationFormId){
        String deviceId = DeviceHelper.getDeviceIdByIpDeclarationFormId(ipDeclarationFormId);
        return getUserOptionsByDeviceId(deviceId);
    }
    
    /**
     * used by GF staff who managing the Exp Control Form.
    */
    private List<SelectOption> getUserOptionsByExpFormId(Id expControlFormId){
        String deviceId = DeviceHelper.getDeviceIdByExpControlFormId(expControlFormId);
        return getUserOptionsExpControlByDeviceId(deviceId);
    }
    
    /*
        return null if nothing is found.
    */
    private List<SelectOption> getUserOptionsByDeviceId(Id deviceId){
        if(deviceId != null){
            String accountId = DeviceHelper.getAccountIdbyDeviceId(deviceId);
            if(accountId != null){
                List<User> users = getExistingCustomerAccountContacts(accountId);
                return generateUserOptions(users);
            }
        }
        return null;
    }
    
    /*
        return null if nothing is found.
    */
    private List<SelectOption> getUserOptionsExpControlByDeviceId(Id deviceId){
        if(deviceId != null){
            String accountId = DeviceHelper.getAccountIdbyDeviceId(deviceId);
            String desPartnerAccId = DeviceHelper.getDesPartnerAccountIdbyDeviceId(deviceId);
            List<User> users = new List<User>();
            Set<User> allUsersSet = new Set<User>();
            List<User> allUsersList = new List<User>();
            if(accountId != null){
                List<User> accUsers = getExistingCustomerAccountContacts(accountId);
                if(accUsers != null){
					users.addAll(accUsers);
					system.debug('Only Account Users:' +users);
				}
            }
            if(desPartnerAccId != null){
                List<User> desPartAccUsers = getExistingCustomerAccountContacts(desPartnerAccId);
                if(desPartAccUsers != null){
					users.addAll(desPartAccUsers);
					system.debug('Combined Users:' +users);
				}
            }
			if(users.size() > 0){
				allUsersSet.addAll(users);
				system.debug('Combined Users Set Other:' +allUsersSet);
			}
			if(allUsersSet.size() > 0){
				allUsersList.addAll(allUsersSet);
				system.debug('Combined Users List Other:' +allUsersList);
			}
            return generateUserOptions(allUsersList);
        }
        return null;
    }
    
    /**
     * used by Customer Portal user who tie to an Account.
    */
    private List<SelectOption> getMyAccountContactOptions() {
        List<User> users = getExistingCustomerAccountContacts(getCustAccountId());
        return generateUserOptions(users);
    }
    
    /**
     * used by Customer Portal user who tie to an Account.
    */
    private List<SelectOption> getExpContMyAccountContactOptions(Id expControlFormId){
        List<User> users = new List<User>();
        Set<User> allUsersSet = new Set<User>();
        List<User> allUsersList = new List<User>();
        String deviceId = DeviceHelper.getDeviceIdByExpControlFormId(expControlFormId);
        //String desPartnerAccId;
        if(deviceId != null){
            String accountId = DeviceHelper.getAccountIdbyDeviceId(deviceId);
            String desPartnerAccId = DeviceHelper.getDesPartnerAccountIdbyDeviceId(deviceId);
            if(accountId != null){
                List<User> accUsers = getExistingCustomerAccountContacts(accountId);
                if(accUsers != null){
					users.addAll(accUsers);
					system.debug('Only Account Users:' +users);
				}
            }
            if(desPartnerAccId != null){
                List<User> desPartAccUsers = getExistingCustomerAccountContacts(desPartnerAccId);
                if(desPartAccUsers != null){
					users.addAll(desPartAccUsers);
					system.debug('Combined Users Other:' +users);
				}
            }
        }
        List<User> accUsersLogin = getExistingCustomerAccountContacts(getCustAccountId());
        if(accUsersLogin != null){
			users.addAll(accUsersLogin);
			system.debug('Only Account Users Other:' +users);
		}
        if(users.size() > 0){
			allUsersSet.addAll(users);
			system.debug('Combined Users Set Other:' +allUsersSet);
		}
		if(allUsersSet.size() > 0){
			allUsersList.addAll(allUsersSet);
			system.debug('Combined Users List Other:' +allUsersList);
		}
        return generateUserOptions(allUsersList);
    }
    
    /*
        return the HTML select options list by converting the list of user objects. 
    */
    private List<SelectOption> generateUserOptions(List<User> users){
        List<SelectOption> options = null;
        if(users != null){
            options = new List<SelectOption>(); 
            options.add(new SelectOption('', 'Select...'));
            for(User user : users){
                options.add(new SelectOption(user.id, prefDisplayName(user)));
            }
            return options;
        }
        return null;
    }

    
    /**
        return true if the user-type is Standard.
        
        Standard: user license. This user type also includes Salesforce Platform and Salesforce Platform One user licenses. Label is Standard.
        PowerPartner: PRM user whose access is limited because he or she is a partner and typically accesses the application through a partner portal. Label is Partner.
        CSPLitePortal: user whose access is limited because he or she is an organization's customer and accesses the application through aCustomer Portal. Label is High Volume Portal.
        CustomerSuccess: user whose access is limited because he or she is an organization's customer and accesses the application through a Customer Portal. Label is Customer Portal User.
        PowerCustomerSuccess: user whose access is limited because he or she is an organization's customer and accesses the application through a Customer Portal. Label is Customer Portal Manager. Users with this license type can view and edit data they directly own or data owned by or shared with users below them in the Customer Portal role hierarchy.
        CsnOnly: user whose access to the application is limited to Chatter. This user type includes Chatter Free and Chatter moderator users. Label is Chatter Free.
    */
    public static boolean isEmployee(){
        return (UserInfo.getUserType() == 'Standard')? true : false; 
    }
    
    /* move this method to DeviceHelper.cls
    public Id getDeviceIdByIpDeclarationFormId(Id ipDeclarationFormId){
        if(ipDeclarationFormId != null){
            String devId = [SELECT Device__c from IP_Declaration_Form__c where id = :ipDeclarationFormId].Device__c;
            if(devId != null){
                return devId;
            }
        }
        return null;
    }
    */
    
    /*
        move this method to DeviceHelper.cls 
    public Id getDeviceIdByExpControlFormId(Id expControlFormId){
        if(expControlFormId != null){
            String devId = [SELECT Device__c from Export_Control_Form__c where id = :expControlFormId].Device__c;
            if(devId != null){
                return devId;
            }
        }
        return null;
    }
    */
    
    /*
        move this method to DeviceHelper.cls 
    public Id getAccountIdbyDeviceId(String deviceId){
        if(deviceId != null){
            String accountId = [SELECT Account__c from Device__c where id =: deviceId].Account__c;
            if(accountId != null){
                return accountId;
            }
        }
        return null;
    }
    */
    
    /*
        Note that this method cannot be defined as static as it's referring to variable custContactId in this class.
        @return the contactId for a Current logon User
        @return null if contact is not created.
    */
    public Id getCustContactId(){
        try{
            if(custContactId != null){
                return custContactId;
            }
            String id = [Select contactid from User where id = :Userinfo.getUserid()].contactId;
            if(String.isNotEmpty(id)){
                custContactId = id;
                return custContactId;
            }
        }catch (Exception e) {
            return e.getMessage();
            //e.printStackTrace();
        }
        return null; 
    }
    
    /*
        Note that this method cannot be defined as static as it's referring to variable custContactId in this class.
        @return the accountId for a current logon User.
        @return null if contactId is not found.
    */
    public Id getCustAccountId(){
        try{
            if(custAccountId != null){
                return custAccountId;
            }
            if(getCustContactId() != null){
                String id = [Select AccountID from Contact where id = :getCustContactId()].AccountId;
                if(String.isNotEmpty(id)){
                    custAccountId = id;
                    return custAccountId;
                }
            }
        }catch (Exception e) {
            return e.getMessage();
            //e.printStackTrace();
        }
        return null;
    }
    
    /*
        @return list of User obj link to the contacts in the account.
        @return null if no User created for the contacts.
    */
    public static List<User> getExistingCustomerAccountContacts(Id accountId){
        try{
            if(accountId != null){
                // 03-08-2017    Anirban Roy    Uncommented the contacts query and added check for Export_Control_Form flag - START
                Set<Id> accountIds = FMSDeviceCreation_Ext.getAccountIds(accountId);
                List<Id> contactIds = new List<Id>();
                List<User> users = new List<User>();
                 if(!accountIds.isEmpty()){
                    for(Contact con : [select id, 
                                              (select id from Access_Setup__r 
                                               where My_Devices__c = true and Export_Control__c = true limit 1) 
                                       from Contact where accountId in :accountIds]){
                        if(con.Access_Setup__r != null && con.Access_Setup__r.size() > 0){
                            contactIds.add(con.id);    
                        }
                    }
                }
                 if(!contactIds.isEmpty()){
                    users = [select IsActive, Id, Email, firstName, lastName, Portal_Email__c From User where ContactId in :contactIds and IsActive = true];
                }
                // 03-08-2017    Anirban Roy    Uncommented the contacts query and added check for Export_Control_Form flag - END    
                if(users != null && users.size() > 0){
                    return users;
                }
                
            }
        }catch (Exception e) {
            system.debug(e.getMessage());
            //e.printStackTrace();
        }
        return null;
    }
    
    public static String prefDisplayName(User user){
        if(user != null){
            return user.LastName + ', ' + user.FirstName + ' ('+ user.Portal_Email__c +')';
        }
        return null;
    }
}