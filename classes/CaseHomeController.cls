/*
Type Name: CaseHomeController 
Author: Cognizant Case Mgmt Team
Created Date: Nov-26-2014
Reason: Reason: This is the controllar class for CaseHomePortal page.
Test Class: CaseVisualforceControllerTest
Change History:
Author: 
Modified Date: 
……..
……..
--
*/
public with sharing class CaseHomeController {
    public list <case>myCaselist {
            get;
            set;
        }
    public list <case>myTeamCaselist {
            get;
            set;
        }
    final List < User > userList = [select Id, ContactId, Contact.AccountId from User where id = : UserInfo.getUserId() Limit 1];

    public void portalcaselist() {
            myCaselist = new list <case>();
            myTeamCaselist = new list <case>();
            String myCasequery = '';
            String myTeamCasequery = '';

            String query = 'SELECT CaseNumber,Subject,Short_Subject__c,Status, IsClosed,Category__c,Subcategory__c,Priority,Classification__c, Owner.Name, OwnerId, Case_Record_Type__c, CreatedDate,LastModifiedDate FROM Case where IsClosed=false ';

            myCasequery = query + ' AND CreatedById=\'' + UserInfo.getUserId() + '\' ORDER BY LastModifiedDate desc Limit 10';
            myCaselist = database.query(myCasequery);
            
            string accId = userList[0].Contact.AccountId;
            
            if( accId !=null && accId !=''){
                myTeamCasequery = query + ' AND CreatedById!=\'' + UserInfo.getUserId() + '\' AND AccountId=\'' + userList[0].Contact.AccountId + '\' ORDER BY LastModifiedDate desc Limit 1000';
                list <case> tempCaselist = database.query(myTeamCasequery);
    
    
                if (tempCaselist != null && tempCaselist.size() > 0) {
                    transient List < UserRecordAccess > listUserRecordAccess = new List < UserRecordAccess > ();
                    transient List < Id > setCaseIds = new List < Id > ();
                    transient Set < Id > setRecordIds = new Set < Id > ();
    
                    for (Case c: tempCaselist) {
                        //to avoid Number of records exceeds limit: 200 
                        if (setCaseIds.size() != 200) {
                            setCaseIds.add(c.Id);
                        } else if (setCaseIds.size() == 200 && listUserRecordAccess.size() < 10) {
                            listUserRecordAccess.addall(getUserRecordAccessList(setCaseIds));
                            setCaseIds.clear();
                        }
                    }
                    if (setCaseIds.size() > 0 && listUserRecordAccess.size() < 10) {
                        listUserRecordAccess.addall(getUserRecordAccessList(setCaseIds));
                        setCaseIds.clear();
                    }
    
                    for (UserRecordAccess ura: listUserRecordAccess) {
                        if (ura.HasReadAccess && setRecordIds.size() < 10) {
                            setRecordIds.add(ura.RecordId);
                        }
                    }
                    for (Case c: tempCaselist) {
                        if (setRecordIds.contains(c.Id) && myTeamCaselist.size() < 10) {
                            myTeamCaselist.add(c);
                        }
                    }
    
                }
            }
        }
        /***
         * getUserRecordAccessList- return UserRecordAccess list for portal users
         ***/
    public list < UserRecordAccess > getUserRecordAccessList(List < Id > setCaseIds) {
        List < UserRecordAccess > listUserRecordAccess = [SELECT RecordId, HasEditAccess, HasReadAccess FROM UserRecordAccess
            WHERE UserId = : UserInfo.getUserId() AND RecordId In: setCaseIds Limit 200
        ];

        return listUserRecordAccess;
    }
}