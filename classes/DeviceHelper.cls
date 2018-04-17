/*
    Author: Win Hwang
    Description: This helper class provides method to deal with common function for an IP/Exp obj that related to the Device/Account.
    History: 
        Win      07172013    - Code creation.
        ARoy     11222013    - modified code to use portal_email__c instead of email field of User.
*/
public class DeviceHelper {
    
    public static String TEAM_ROLE_FE = EnvironmentVariable.get('OPPTY_PROG_TM_ROLE_FTS');
    public static String TEAM_ROLE_PRIMARY_FE = EnvironmentVariable.get('OPPTY_PROG_TM_ROLE_PFTS');
    
    public static String TEAM_ROLE_AM = EnvironmentVariable.get('OPPTY_PROG_TM_ROLE_AM');
    public static String TEAM_ROLE_PRIMARY_AM = EnvironmentVariable.get('OPPTY_PROG_TM_ROLE_PAM');
    
    //public static String TEAM_ROLE_GTC = '';
    //public static String TEAM_ROLE_DSO = '';
    
    public static Id getDeviceIdByIpDeclarationFormId(Id ipDeclarationFormId){
        try{
            if(ipDeclarationFormId != null){
                String devId = [SELECT Device__c from IP_Declaration_Form__c where id = :ipDeclarationFormId].Device__c;
                if(devId != null){
                    return devId;
                }
            }
        }catch (Exception e) {
            return e.getMessage();
            //e.printStackTrace();
        }
        return null; 
    }
    
    public static Id getDeviceIdByExpControlFormId(Id expControlFormId){
        try{
            if(expControlFormId != null){
                List<Device_Export_Control_Junction__c> devExpConJunc =  [select Device__c                                                                     
                                                            from Device_Export_Control_Junction__c
                                                            where Export_Control_Form__c = :expControlFormId];
                String devId;
                if(devExpConJunc.size() > 0){
                    devId = devExpConJunc[0].Device__c;
                }
                if(devId != null){
                    return devId;
                }
            }
        }catch (Exception e) {
            return e.getMessage();
            //e.printStackTrace();
        }
        return null; 
    }
    
    public static Id getAccountIdbyDeviceId(Id deviceId){
        try{
            if(deviceId != null){
                String accountId = [SELECT Account__c from Device__c where id =: deviceId].Account__c;
                if(accountId != null){
                    return accountId;
                }
            }
        }catch (Exception e) {
            return e.getMessage();
            //e.printStackTrace();
        }
        return null; 
    }
    
    public static Id getDesPartnerAccountIdbyDeviceId(Id deviceId){
        try{
            if(deviceId != null){
                String accountId = [SELECT Design_Partner__c from Device__c where id =: deviceId].Design_Partner__c;
                if(accountId != null){
                    return accountId;
                }
            }
        }catch (Exception e) {
            return e.getMessage();
            //e.printStackTrace();
        }
        return null; 
    }
    
    /*
        @return list of Email for FE and AM.
    */
    public static List<String> getFEAMEmails(Id accountId){
        try{
            Set<String> uniqueEmails = new Set<String>();
            List<String> feEmails = getFeEmails(accountId);
            List<String> amEmails = getAmEmails(accountId);
            
            if(feEmails != null){
                uniqueEmails.addAll(feEmails);
            }
            if(amEmails != null){
                uniqueEmails.addAll(amEmails);
            }
            if(uniqueEmails != null){
                List<String> emailList = new List<String>();
                emailList.addAll(uniqueEmails);
                //emailList.add('winhwang.lim@globalfoundries.com'); //TODO: to remove after SIT.
                return emailList;
            }
        }catch(Exception e){
            system.debug('Error: DeviceHelper 80:' + e.getMessage());
            return null;
        }
        return null;
    }
    
    /*
        @return list of Field Engineer Email.
        
        Select a.User__c, a.Team_Role__c, a.Name, a.Id, a.Account__c From Account_Team_Proxy__c a
        where Account__c = '001O000000F5x0x' and Team_Role__c = 'Field Engineer'
        
        select IsActive, Id, Email, firstName, lastName From User where Id in (
            Select User__c From Account_Team_Proxy__c
            where Account__c = '001O000000F5x0x' and Team_Role__c = 'Field Engineer'
        ) and IsActive = true
    */
    public static List<String> getFeEmails(Id accountId){
        try{
            List<String> feEmails = new List<String>();
            List<String> fe1 = getEmails(accountId, TEAM_ROLE_FE);
            List<String> fe2 = getEmails(accountId, TEAM_ROLE_PRIMARY_FE);
            
            feEmails = combineList(fe1, fe2);
            
            if(feEmails != null && feEmails.size() > 0){
                return feEmails;
            }
        }catch(Exception e){
            system.debug('Error: DeviceHelper 113:' + e.getMessage());
            return null;
        }
        return null;
    }
    
    /*
        @return list of Account Manager Email.
    */
    public static List<String> getAmEmails(Id accountId){
        try{
            List<String> amEmails = new List<String>();
            List<String> am1 = getEmails(accountId, TEAM_ROLE_AM);
            List<String> am2 = getEmails(accountId, TEAM_ROLE_PRIMARY_AM);
            
            amEmails = combineList(am1, am2);
            
            if(amEmails != null && amEmails.size() > 0){
                return amEmails;
            }
        }catch(Exception e){
            system.debug('Error: DeviceHelper 113:' + e.getMessage());
            return null;
        }
        return null;
    }
    
    private static List<String> combineList(List<String> aList, List<String> bList){
        try{
            List<String> cList = new List<String>();
             
            if(aList != null)
                cList.addAll(aList);
            if(bList != null)
                cList.addAll(bList);
            if(cList != null && cList.size() > 0){
                return cList;
            }
        }catch(Exception e){
            system.debug('Error: DeviceHelper 138:' + e.getMessage());
            return null;
        }
        return null;
    }
    
    /*
        @return null if accountId or teamRole not found.
    */
    public static List<String> getEmails(Id accountId, String teamRole){
        try{
            if(accountId != null){
                //get opportunity program team proxy, filter team role 'Field Engineer'
                List<User> users = [select IsActive, Id, Portal_Email__c, firstName, lastName From User where Id in (
                                        Select User__c From Account_Team_Proxy__c
                                        where Account__c = :accountId and Team_Role__c = :teamRole
                                    ) and IsActive = true];
                
                if(users != null && users.size() > 0){
                    List<String> emails = new List<String>();
                    for(User user : users){
                        emails.add(user.Portal_Email__c);
                    }
                    return emails;
                }
            }
        }catch (Exception e) {
            system.debug('Error: ' + e.getMessage());
            //e.printStackTrace();
        }
        return null; 
    }
    
    
   
}