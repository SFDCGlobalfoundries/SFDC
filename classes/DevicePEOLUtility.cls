/*
*   Author: Sreedhar Karukonda
*   Description:  This class is used as Test data creation for all PEOL related Test classes
*   History: 
*   skarukon      09/22/2015    - Apex code created    
*/

global without sharing class DevicePEOLUtility {
	/*
    * Will be called from "Get CSRs From Account" Button in Device PEOL Request details page
    */
     webservice static void fillCSR(Id peolId){
     	Device_PEOL_Request__c request = [select Id, Name, Primary_CSR__c, Backup_CSR__c, Customer__c, Customer__r.Name  from Device_PEOL_Request__c where Id =: peolId];
     	assignPrimaryCSRFromAccount(new List<Device_PEOL_Request__c>{request});
     	boolean errorFlag= false;
     	String errorMessage = '';
     	if(request.Primary_CSR__c == null){
     		errorFlag = true;
     		errorMessage += request.Customer__r.Name + ' does not have "Primary Customer Service Rep" in Account Team Proxy. \n';
     	}
     	if(request.Backup_CSR__c == null){
     		errorFlag = true;
     		errorMessage += request.Customer__r.Name + ' does not have "Backup Customer Service Rep" in Account Team Proxy. \n';
     	}
     	if(errorFlag){
     		throw new PEOLException(errorMessage + ' Please add them and click this button.' );
     	}
     	update request;
     }
     
	/*
    * Assign Primary CSR Name from Account
    */
    public static void assignPrimaryCSRFromAccount(List<Device_PEOL_Request__c>newList){
        
        //Collect all account IDs
        Set<Id> accountIDs = new Set<Id>();
        for(Device_PEOL_Request__c peolRequest: newList){
            accountIDs.add(peolRequest.Customer__c);
        }
        String DEVICE_REQUEST_PEOL_APPROVER_ROLES = UtilsString.isNotBlank(EnvironmentVariable.get('DEVICE_REQUEST_PEOL_APPROVER_ROLES')) ?
                                             EnvironmentVariable.get('DEVICE_REQUEST_PEOL_APPROVER_ROLES'): 'Backup Customer Service Rep,Primary Customer Service Rep';
        List<String> rolesList = DEVICE_REQUEST_PEOL_APPROVER_ROLES.split(',');

        if(accountIDs.size() > 0){
            Map<Id, Account> accountWithTeams = new Map<Id, Account> ([select Id, Name, Primary_CSR__c, (select Id, Name, Team_Role__c, User__c from Account_Team_Proxy__r where Team_Role__c in : rolesList and User__r.IsActive = true) from Account where Id in : accountIDs]);
            for(Device_PEOL_Request__c peolRequest: newList){
                // Assign Primary CSR 
                if(accountWithTeams.get(peolRequest.Customer__c).Primary_CSR__c != null){
                	
                   peolRequest.Primary_CSR__c = accountWithTeams.get(peolRequest.Customer__c).Primary_CSR__c;
                }else{
                   Id primaryCSR = getFirstCSR(accountWithTeams.get(peolRequest.Customer__c), 'Primary Customer Service Rep');
                   peolRequest.Primary_CSR__c = primaryCSR != null ? primaryCSR : null;
                }
                // Assign Backup CSR
                 Id backupCSR = getFirstCSR(accountWithTeams.get(peolRequest.Customer__c), 'Backup Customer Service Rep');
                 peolRequest.Backup_CSR__c = backupCSR != null ? backupCSR : null;
            }
        }
    }

    public static Id getFirstCSR(Account acc, String role){
        for(Account_Team_Proxy__c atp: acc.Account_Team_Proxy__r){
            if(atp.Team_Role__c == role){
                return atp.User__c;
            }
        }
        return null;
    }

    public class PEOLException extends Exception{}
}