/*
    Author: Zymark Ambat
    Description: This Class searches for the Account Team Proxy members for WaferWriteOffVF.
    History: 
        ZAmbat      01292015    - Code creation.
*/

public class WaferWriteOffSearchATPMembers {
    public static void retrieveAccountManager(List<Wafer_Write_Off__c> listWaferWriteOff) {
        Map<Id, List<Account_Team_Proxy__c>> mapWaferWriteOff = new Map<Id, List<Account_Team_Proxy__c>>();
        for (Wafer_Write_Off__c w : listWaferWriteOff) {
            mapWaferWriteOff.put(w.Customer_Name__c, new List<Account_Team_Proxy__c>());
        }
        
        for (Account_Team_Proxy__c a : [SELECT    Account__c
                                                  , User__c
                                        FROM      Account_Team_Proxy__c
                                        WHERE     Account__c IN :mapWaferWriteOff.keySet()
                                                  AND Team_Role__c IN ('Primary Account Manager', 'Account Manager')
                                                  AND User__r.IsActive = true
                                        ORDER BY  CreatedDate ASC]) {
            mapWaferWriteOff.get(a.Account__c).add(a);
        }
        
        for (Wafer_Write_Off__c w : listWaferWriteOff) {
            integer ctr = 1;
            for (Account_Team_Proxy__c a : mapWaferWriteOff.get(w.Customer_Name__c)) {
                if (ctr == 1) {
                    w.Account_Manager_1__c = a.User__c;
                } else if (ctr == 2) {
                    w.Account_Manager_2__c = a.User__c;
                } else if (ctr == 3) {
                    w.Account_Manager_3__c = a.User__c;
                    break;
                }
                ctr++;
            }
        }
    }
}