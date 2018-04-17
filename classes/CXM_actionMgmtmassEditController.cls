/*
    Author: Deepti Narayan Biswal
    Description: This is a controller class for CXM_actionMgmtmassEdit VF page. 
    History:
        DBiswal    07292016    Created.
        DBiswal    04112017    Modified for Escalation team enhancement.
        DBiswal    02062017    Modified for fix for Action name update(line no. 70-92).
*/
public with sharing class CXM_actionMgmtmassEditController {
        
    public List<actionmgmtwrapper> actionmgmtwrapperList{get;set;}
    public string accountId{get;set;}
    public String AccountName{get;set;}
    public Boolean isSF1flag {get;set;}
    public List<WrapperpaActionMgmtList> waActnMgmtList {get;set;}
    public Integer rowToRemove {get;set;}
    public List<escalationTeamWrap> escTeamwrapList {get;set;}
    public List<escalationTeamWrap> escTeamwrapRemovalList {get;set;}
    public Boolean escTeamFlag {get;set;}
    public Boolean escTeamRemoveFlag {get;set;}
    public Boolean AllselectedRem {get;set;}    
    public Integer teamRowremove {get;set;}
    public Boolean newActionflag {get;set;}
    public Boolean Allselected {get;set;}
    
    public class actionmgmtwrapper {
        public Boolean isSelected {get;set;}
        public Escalation_Complaint__c actmObj {get;set;}
        public String actionOwner {get;set;}
    }
    
    public CXM_actionMgmtmassEditController(){
        accountId = apexpages.currentpage().getparameters().get('accid');
        isSF1flag = isSF1();
        this.initiate();
    }
    
    public void initiate(){
        actionmgmtwrapperList = new List<actionmgmtwrapper>();
        waActnMgmtList = new List<WrapperpaActionMgmtList>();
        escTeamwrapList = new List<escalationTeamWrap>();
        escTeamwrapRemovalList = new List<escalationTeamWrap>();
        newActionflag = false;
        escTeamFlag = false;
        escTeamRemoveFlag = false;
        if(accountId !=null) {
            for(Escalation_Complaint__c actm : [select id,Name,Description__c,OwnerId,Owner.Name,Account__c,Account__r.Name,Subject__c,Escalation_Severity__c,Department__c,Stage__c,Severity__c,Type__c,Sub_Type__c,Escalation_Level__c,Expected_Close_Date__c,Closed_Date__c,Assigned_Resolution_Owner__c,Assigned_Resolution_Owner__r.Name FROM Escalation_Complaint__c WHERE Account__c =:accountId AND Stage__c != 'Closed' ORDER BY Name ASC]){
                actionmgmtwrapper actmwrap = new actionmgmtwrapper();
                actmwrap.actmObj = actm;
                actmwrap.isSelected = false;
                if(actm.Assigned_Resolution_Owner__c != null){
                    actmwrap.actionOwner = actm.Assigned_Resolution_Owner__r.Name;
                } else {
                    actmwrap.actionOwner = actm.Owner.Name;
                }
                actionmgmtwrapperList.add(actmwrap);
                AccountName = actm.Account__r.Name;
            }
        } else {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'No Related Action Managements found'));
        }       
    }
       
    public PageReference SaveActions(){
        Map<String, Escalation_Complaint__c> actmMap = new Map<String, Escalation_Complaint__c>();
        PageReference acctPage = new PageReference('/'+ accountId);
        List<Escalation_Complaint__c> updateactmList = new List<Escalation_Complaint__c>();
        List<Escalation_Complaint__c> insertactmList = new List<Escalation_Complaint__c>();
        Integer countflag = 0;
        Set<Id> actId = new Set<Id>();
        for(actionmgmtwrapper actmwrap :actionmgmtwrapperList)
        {
            if(actmwrap.isSelected && actmwrap.actmObj.Id != null){
                actId.add(actmwrap.actmObj.Id);
            }
        }
        Map<Id,Escalation_Complaint__c> actMap = new Map<Id,Escalation_Complaint__c>();
        actMap.putAll([SELECT id,Name,Subject__c FROM Escalation_Complaint__c WHERE Id IN: actId]);
        for(actionmgmtwrapper actmwrap :actionmgmtwrapperList)
        {
            if(actmwrap.isSelected){
                if(actmwrap.actmObj.id == null){
                    insertactmList.add(actmwrap.actmObj);
                } else if(actmwrap.actmObj.Id != null){
                    if(actMap != null && actMap.containsKey(actmwrap.actmObj.Id)){
                        actmwrap.actmObj.Subject__c = actMap.get(actmwrap.actmObj.Id).Subject__c;
                    }
                    updateactmList.add(actmwrap.actmObj);
                }
                countflag++;
            }
        }
        if(countflag == 0){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please select at least one action to edit'));
            return null;
        } 
        else {
            try{
                if(insertactmList.size() > 0){
                    Database.insert(insertactmList);
                }
                if(updateactmList.size() > 0){
                    Database.update(updateactmList);
                }                
            } catch(Exception e){
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,e.getdmlMessage(0));  
                ApexPages.addMessage(myMsg);
                return null;
            }
        }  
        
        waActnMgmtList = new List<WrapperpaActionMgmtList>();
        actionmgmtwrapperList = new List<actionmgmtwrapper>();
        if(accountId !=null) {
            for(Escalation_Complaint__c actm : [select id,Name,Description__c,OwnerId,Owner.Name,Account__c,Account__r.Name,Subject__c,Escalation_Severity__c,Department__c,Stage__c,Severity__c,Type__c,Sub_Type__c,Escalation_Level__c,Expected_Close_Date__c,Closed_Date__c,Assigned_Resolution_Owner__c,Assigned_Resolution_Owner__r.Name FROM Escalation_Complaint__c WHERE Account__c =:accountId AND Stage__c != 'Closed' ORDER BY Name ASC]){
                actionmgmtwrapper actmwrap = new actionmgmtwrapper();
                actmwrap.actmObj = actm;
                actmwrap.isSelected = false;
                if(actm.Assigned_Resolution_Owner__c != null){
                    actmwrap.actionOwner = actm.Assigned_Resolution_Owner__r.Name;
                } else {
                    actmwrap.actionOwner = actm.Owner.Name;
                }
                actionmgmtwrapperList.add(actmwrap);               
            }
            Allselected = false;
        } else {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'No Related Action Managements found'));
        } 
        
        return null;      
    }
    
    public static Boolean isSF1(){
        String retUrl = ApexPages.currentPage().getParameters().get('retURL');

        return String.isNotBlank(ApexPages.currentPage().getParameters().get('sfdcIFrameHost')) ||
        String.isNotBlank(ApexPages.currentPage().getParameters().get('sfdcIFrameOrigin')) ||
        ApexPages.currentPage().getParameters().get('isdtp') == 'p1' ||
        (String.isNotBlank(retUrl) && retURL.contains('projectone'));

    }
    
    public PageReference SaveMultipleAcntMgmt() {         
        List<Escalation_Complaint__c> acntMgmtRecordsToBeInserted = new List<Escalation_Complaint__c>();
        Set<String> actionName = new Set<String>();
        
        for(actionmgmtwrapper existRecords : actionmgmtwrapperList){
            actionName.add(existRecords.actmObj.subject__c);
        }
        
        if(waActnMgmtList !=null && !waActnMgmtList.isEmpty()){            
            for(WrapperpaActionMgmtList eachRecord : waActnMgmtList){ 
                if(!actionName.contains(eachRecord.record.subject__c)){
                    actionName.add(eachRecord.record.Subject__c);
                }
                else{
                    ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'There are redundant Action name in the rows or Action Management already exists with same action name.');  
                    ApexPages.addMessage(myMsg);
                    return null;
                }
                Escalation_Complaint__c acntMgmtTemp = eachRecord.record;
                acntMgmtRecordsToBeInserted.add(acntMgmtTemp);               
            }
            try{
                if(!acntMgmtRecordsToBeInserted.isEmpty()){
                    Database.SaveResult[] srActionList = Database.insert(acntMgmtRecordsToBeInserted, false);
                    
                    if(escTeamwrapList.size() > 0){
                    List<CXM_Escalation_Team__c> escTeamstoInsert = new List<CXM_Escalation_Team__c>();
                        for(Database.SaveResult sr : srActionList){
                            if(sr.isSuccess()){
                                for(escalationTeamWrap team : escTeamwrapList){
                                    CXM_Escalation_Team__c newTeam = new CXM_Escalation_Team__c();
                                    newTeam.Action_Management__c = sr.getId();
                                    newTeam.User__c = team.escTeam.User__c;
                                    newTeam.Escalation_Level__c = team.escTeam.Escalation_Level__c;
                                    escTeamstoInsert.add(newTeam);
                                }
                            }
                        }
                        Database.insert(escTeamstoInsert);
                        escTeamwrapList.clear();
                        escTeamFlag = false;
                        newActionflag = false;
                    }
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM,'Actions have been created successfully'));
                }
            }
            catch(Exception e){
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,e.getMessage());  
                ApexPages.addMessage(myMsg);
                return null;
            }            
        }
        
        waActnMgmtList = new List<WrapperpaActionMgmtList>();
        actionmgmtwrapperList = new List<actionmgmtwrapper>();
        if(accountId !=null) {
            for(Escalation_Complaint__c actm : [select id,Name,Description__c,OwnerId,Owner.Name,Account__c,Account__r.Name,Subject__c,Escalation_Severity__c,Department__c,Stage__c,Severity__c,Type__c,Sub_Type__c,Escalation_Level__c,Expected_Close_Date__c,Closed_Date__c,Assigned_Resolution_Owner__c,Assigned_Resolution_Owner__r.Name FROM Escalation_Complaint__c WHERE Account__c =:accountId AND Stage__c != 'Closed' ORDER BY Name ASC]){
                actionmgmtwrapper actmwrap = new actionmgmtwrapper();
                actmwrap.actmObj = actm;
                actmwrap.isSelected = false;
                if(actm.Assigned_Resolution_Owner__c != null){
                    actmwrap.actionOwner = actm.Assigned_Resolution_Owner__r.Name;
                } else {
                    actmwrap.actionOwner = actm.Owner.Name;
                }
                actionmgmtwrapperList.add(actmwrap);               
            }
        } else {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'No Related Action Managements found'));
        } 
        
        return null;
    }

    public void removeRowFromActnMgmtList(){
        if(rowToRemove == 0 && waActnMgmtList.size() == 1){
            newActionflag = false;
        }
        waActnMgmtList.remove(rowToRemove);
    }

    public void addNewRowToActnMgmtList(){
         newActionflag = true;
         WrapperpaActionMgmtList newRecord = new WrapperpaActionMgmtList();
         Escalation_Complaint__c newAcntMgmtRecord = new Escalation_Complaint__c();   
         newAcntMgmtRecord.account__c = accountId;    
         newRecord.record = newAcntMgmtRecord;
         newRecord.index = waActnMgmtList.size();
         waActnMgmtList.add(newRecord);         
    }
                    
    public class WrapperpaActionMgmtList{
        public Integer index {get;set;}
        public Escalation_Complaint__c record {get;set;}
    }
    
    //DBiswal - 02232017
    public class escalationTeamWrap{
        public Boolean isSelected {get;set;}
        public CXM_Escalation_Team__c escTeam {get;set;}
    }
    
    public void addEscTeam(){
        escalationTeamWrap newRec = new escalationTeamWrap();
        CXM_Escalation_Team__c newTeam = new CXM_Escalation_Team__c();
        newRec.escTeam = newTeam;
        escTeamwrapList.add(newRec);
    }
    
    public void saveEscTeam(){
        List<CXM_Escalation_Team__c> escTeamstoInsert = new List<CXM_Escalation_Team__c>();
        if(actionmgmtwrapperList.size() > 0 && escTeamwrapList.size() > 0){
            for(actionmgmtwrapper actmwrap : actionmgmtwrapperList)
            {
                if(actmwrap.isSelected){
                    for(escalationTeamWrap team : escTeamwrapList){
                        CXM_Escalation_Team__c newTeam = new CXM_Escalation_Team__c();
                        newTeam.Action_Management__c = actmwrap.actmObj.Id;
                        newTeam.User__c = team.escTeam.User__c;
                        newTeam.Escalation_Level__c = team.escTeam.Escalation_Level__c;
                        escTeamstoInsert.add(newTeam);
                    }
                }
            }
        }
        try{
            if(escTeamstoInsert.size() > 0){
                Database.insert(escTeamstoInsert);
                escTeamFlag = false;
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM,'Escalation Team has been assigned'));
            } else {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please provide at least one Action/user to assign'));
            }
        } catch(exception e){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Some error occured'));
        }
        
    }
    
    public void setescTeamSection(){
        escTeamFlag = escTeamFlag ? false : true;
        escTeamRemoveFlag = false;
    }
    
    public void setescTeamRemovalSection(){
        escTeamRemoveFlag = escTeamRemoveFlag ? false : true;
        escTeamFlag = false;
        if(escTeamRemoveFlag){
            escTeamwrapRemovalList = new List<escalationTeamWrap>();
            Set<Id> actMgmtSet = new Set<Id>();
            Map<String,String> escTeamMap = new Map<String,String>();
            if(actionmgmtwrapperList.size() > 0){
                for(actionmgmtwrapper actmwrap : actionmgmtwrapperList)
                {
                    if(actmwrap.isSelected){
                        actMgmtSet.add(actmwrap.actmObj.Id);
                    }
                }
            }
            if(actMgmtSet.size() > 0){
                for(CXM_Escalation_Team__c oldTeam : [SELECT Id,User__c,Escalation_Level__c,Action_Management__c FROM CXM_Escalation_Team__c WHERE Action_Management__c IN: actMgmtSet]){
                    escTeamMap.put(oldTeam.User__c,oldTeam.Escalation_Level__c);
                }
                if(!escTeamMap.isEmpty()){
                    for(String usr : escTeamMap.keySet()){
                        escalationTeamWrap oldRec = new escalationTeamWrap();
                        CXM_Escalation_Team__c oldTeam = new CXM_Escalation_Team__c();
                        oldTeam.User__c = usr;
                        oldTeam.Escalation_Level__c = escTeamMap.get(usr);
                        oldRec.escTeam = oldTeam;
                        oldRec.isSelected = false;
                        escTeamwrapRemovalList.add(oldRec);
                    }
                }
            }else {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please select at least one existing Action to remove its escalation team'));
                escTeamRemoveFlag = false;
            }            
        }
    }
    
    public void removeTeammethod(){
        List<CXM_Escalation_Team__c> cxmTeamtoDel = new List<CXM_Escalation_Team__c>();
        Set<Id> usrIdset = new Set<Id>();
        Set<Id> actMgmtSet = new Set<Id>();
        for(Integer i = 0; i < escTeamwrapRemovalList.size(); i++){
            if(escTeamwrapRemovalList[i].isSelected){
                usrIdset.add(escTeamwrapRemovalList[i].escTeam.User__c);
                escTeamwrapRemovalList.remove(i);
            }
        }
        for(actionmgmtwrapper actmwrap : actionmgmtwrapperList){
            if(actmwrap.isSelected){
                actMgmtSet.add(actmwrap.actmObj.Id);
            }
        }
        if(usrIdset.size() == 0 || actMgmtSet.size() == 0){
           ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please select at least one Action/User to remove its escalation team'));
        } else {
            for(CXM_Escalation_Team__c oldTeam : [SELECT Id,User__c,Escalation_Level__c FROM CXM_Escalation_Team__c WHERE User__c IN: usrIdset AND Action_Management__c IN: actMgmtSet]){
                cxmTeamtoDel.add(oldTeam);
            }
            if(cxmTeamtoDel.size() > 0){
                delete cxmTeamtoDel;
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM,'Escalation Teams have been removed'));
            }
        }
    }
    
    public void removeRowFromescTeam(){
        escTeamwrapList.remove(teamRowremove);
    }
}