/*
Type Name: OutOfOfficeCheckForDuplicate
Author: Cognizant
Created Date: 29th-Nov-2013
Reason: This Trigger is used for assiging user and check for Duplicate.
Test Class: OutOfOfficeTriggerTest
Change History:
Author: 
Modified Date: 
Reason: 
……..
……..
 */
trigger OutOfOfficeCheckForDuplicate on Out_Of_Office__c(before insert, before update) {
    Map < Id, Out_Of_Office__c > userId2OOO = new Map < Id, Out_Of_Office__c > ();        // Stored UserId as Key and OutofOfficeUser as Value from Out of Office
    Map < Id, Out_Of_Office__c > delegateId2OOO = new Map < Id, Out_Of_Office__c > ();    // Stored UserId as Key and DelegatedUser as Value from Out of Office
    
    String first = '<a style=color:#1b2be0 href="';      // Stored the Style and Colour for the ERROR Link
    String sBreak = '</br>';     //This is separate because you can use it anywhere else  in ERROR Link                                      
    String fullFileURL = URL.getSalesforceBaseUrl().toExternalForm();    // Can easily use in any instance, no need hard code 
    String last = '" target="_self">Click here to Update</a>';     // Target opens in new window, users can update data in another window easily.
    
    List < Out_Of_Office__c > lstOOODel = New List < Out_Of_Office__c > ();
    List < Out_Of_Office__c > lstOOO = [SELECT User__c, Delegate_User__c, Start_Time__c, End_Time__c, User__r.name from Out_Of_Office__c
        where Active__c = true
    ];
    
        if (lstOOO != null && lstOOO.size() > 0) {
            for (Out_Of_Office__c ooo: lstOOO) {
                delegateId2OOO.put(ooo.Delegate_User__c, ooo);
            }
        }

        for (Out_Of_Office__c o: Trigger.new) {

            if ((o.Record_Type_API__c == 'Out_Of_Office_Personal') && (o.User__c == null)) {
                o.User__c = UserInfo.getUserId();
            }

            //First, find any duplicates within the bulk data(if applicable) being added/updated.

            if (userId2OOO.get(o.User__c) == null) {
                userId2OOO.put(o.User__c, o);                
            }

            if (delegateId2OOO.containsKey(o.user__c)) {
                Out_Of_Office__c oTemp = delegateId2OOO.get(o.user__c);
                if ((o.Start_Time__c.getTime() >= oTemp.Start_Time__c.getTime() && o.Start_Time__c.getTime() <= oTemp.End_Time__c.getTime()) || (o.End_Time__c.getTime() >= oTemp.Start_Time__c.getTime() && o.End_Time__c.getTime() <= oTemp.End_Time__c.getTime())) {
                    // Calculate The Start Date and End Date Difference based on the Out of Office Data .
                    o.user__c.addError(System.Label.Out_of_Office_Delegated + oTemp.User__r.Name + System.Label.Out_of_Office_Delegated_2 + sBreak + first + fullFileURL + '/' + oTemp.id + '/e' + last, false);
                    // ERROR Link If There is already an Identical Record .
                }
            }

        }

        //Now we have to find if any duplicate Out_Of_Office__c records already exist in the DB.
        
        Set < Id > theseOOOs = new Set < Id > ();
        if (Trigger.isUpdate) {
            theseOOOs = Trigger.newMap.keySet();
        }

        //Look for any Out_Of_Office__c records with the same combination of User
        
        for (Out_Of_Office__c[] hs: [select User__c, Delegate_User__c, Start_Time__c, End_Time__c, User__r.name from Out_Of_Office__c
            where user__c in : userId2OOO.keySet()
            and id not in : theseOOOs
        ]) {
            for (Out_Of_Office__c h: hs) {
                lstOOODel.add(h);

                if (delegateId2OOO.containsKey(h.User__c)) {
                    Out_Of_Office__c oTemp = delegateId2OOO.get(h.user__c);

                    if ((h.Start_Time__c.getTime() >= oTemp.Start_Time__c.getTime() && h.Start_Time__c.getTime() <= oTemp.End_Time__c.getTime()) || (h.End_Time__c.getTime() >= oTemp.Start_Time__c.getTime() && h.End_Time__c.getTime() <= oTemp.End_Time__c.getTime())) {
                        // Calculate The Start Date and End Date Difference based on the Out of Office Data .
                        userId2OOO.get(h.user__c).addError(System.Label.Out_of_Office_Delegated + oTemp.User__r.Name + System.Label.Out_of_Office_Delegated_2 + sBreak + first + fullFileURL + '/' + oTemp.id + '/e' + last, false);
                        // ERROR Link If There is already an Identical Record 
                    }
                }
            }
        }
        if (lstOOODel != null && lstOOODel.size() > 0) {
            Delete lstOOODel;
        }

}