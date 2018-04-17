/*
    Author: Deepti Narayan Biswal
    Description: This is a controller class for CXM_escalationTeamSelect VF page. 
    History:
        DBiswal    07292016    Created.
        DBiswal    04112017    Modified for Escalation team enhancement.
*/
public class CXM_escalationTeamSelectController { 
    public Escalation_Complaint__c custReq {get;set;}
    public List<internalActionWrapper> internalActionWrapperList {get;set;}
    public List<customerActionWrapper> customerActionWrapperList {get;set;}
    public Boolean refreshFlag {get;set;}
    public Boolean allSelected {get;set;}
    public Boolean boxFlag {get;set;}
    public Boolean teamEditFlag {get;set;}
    public Integer teamRowremove {get;set;}
    public String custReqId = '';
    public List<CXM_Escalation_Team__c> teamtoDel = new List<CXM_Escalation_Team__c>();
            
    public CXM_escalationTeamSelectController(ApexPages.StandardController controller) {
        custReqId = controller.getId();
        refreshFlag = false;
        List<Escalation_Complaint__c> escList = [SELECT Id,Name,Account__c,Account__r.Sales_Territory__c,Department__c,FAB__c,Escalation_User_1__c,Escalation_User_2__c,Escalation_User_3__c,Action_Owner_Team__c,Action_Assigner_Team__c 
                                                 FROM Escalation_Complaint__c WHERE Id =: custReqId];
        if(escList != null && escList.size() > 0){
            custReq = escList[0];
        }
        customerActionWrapperList = new List<customerActionWrapper>();
        queryTeam();
        
        if(custReq != null){
            for(Contact con : [SELECT Id,Name,AccountId,Email,ReportsToId,ReportsTo.Name FROM Contact WHERE AccountId =: custReq.Account__c ORDER BY Name]){
                customerActionWrapperList.add(new customerActionWrapper(con));
            }
        }
    }
    
    public void queryTeam(){
        internalActionWrapperList = new List<internalActionWrapper>();
        for(CXM_Escalation_Team__c cet : [SELECT Id,User__c,User__r.Name,User__r.Email,Escalation_Level__c FROM CXM_Escalation_Team__c WHERE Action_Management__c =: custReqId 
                                          AND (Escalation_Level__c = 'L2 - Account Team Level' OR Escalation_Level__c = 'L3 - Director/VP' OR Escalation_Level__c = 'L4 - Sr VP')]){
            internalActionWrapperList.add(new internalActionWrapper(cet));
        }
    }
    
    public pageReference saveRecOthers(){
        try{
            Database.update(custReq);
            refreshFlag = true;
        } catch(Exception e){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR,e.getMessage()));
            return null;
        }
        return null;
    }
    
    public pageReference settheBox(){
        if(ApexPages.CurrentPage().getParameters().get('url') == 'sf1'){
            boxFlag = true;
        } else {
            boxFlag = false;
        }
        return null;
    }
    
    public pageReference saveRecCustomers(){
        Integer warnflag = 0;
        Integer errflag = 0;
        String actionOwners = '';
        String actionAssigners = '';
        for(customerActionWrapper cust : customerActionWrapperList){
            if(cust.isSelected){
                warnflag++;
                if(!cust.level.equalsIgnoreCase('None')){
                    if(cust.level.equalsIgnoreCase('Requestor')){
                        actionOwners += cust.con.Name + ', ';
                    } else {
                        actionAssigners += cust.con.Name + ', ';
                    }
                } else {
                    errflag++;
                }
            }
        }
        if(warnflag == 0){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR,'Please select at least one Contact to Save'));
            return null;
        }
        if(errflag > 0){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR,'Please select Level for all selected Contacts'));
            return null;
        }
        if(actionOwners != '' || actionAssigners != ''){
            if(actionOwners != ''){
                custReq.Action_Owner_Team__c = actionOwners;
            } else {
                custReq.Action_Assigner_Team__c = actionAssigners;
            }
            try{
                Database.update(custReq);
                refreshFlag = true;
                return null;
            } catch(Exception e){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR,e.getMessage()));
                return null;
            }
        }
        return null;
    }
    
    public void editCXMteam(){
        teamEditFlag = true;
    }
    
    public void saveCXMteam(){
        if(internalActionWrapperList.size() > 0){
            List<CXM_Escalation_Team__c> cxmTeamtoUpsert = new List<CXM_Escalation_Team__c>();
            try{
                for(internalActionWrapper wrap : internalActionWrapperList){
                    cxmTeamtoUpsert.add(wrap.cxmTeam);
                }
                if(cxmTeamtoUpsert.size() > 0){
                    upsert cxmTeamtoUpsert;
                }
                if(teamtoDel.size() > 0){
                    delete teamtoDel;
                }
                queryTeam();
                teamEditFlag = false;
                teamtoDel = new List<CXM_Escalation_Team__c>();
            }catch(Exception e){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR,e.getMessage()));
            }
        }
    }
    
    public void addCXMteam(){
        CXM_Escalation_Team__c newTeam = new CXM_Escalation_Team__c();
        newTeam.Action_Management__c = custReqId;
        internalActionWrapperList.add(new internalActionWrapper(newTeam));
    }
    
    public void removeCXMteam(){    
        if(internalActionWrapperList[teamRowremove].cxmTeam.Id != null){
            teamtoDel.add(internalActionWrapperList[teamRowremove].cxmTeam);
        }
        internalActionWrapperList.remove(teamRowremove);        
    }
    
    public class internalActionWrapper{
        public CXM_Escalation_Team__c cxmTeam {get;set;}
        public Boolean isSelected {get;set;}
        
        public internalActionWrapper(CXM_Escalation_Team__c team){
            cxmTeam = team;
            isSelected = false;
        }
    }
    
    public class customerActionWrapper{
        public Boolean isSelected {get;set;}
        public Boolean allSelected {get;set;}
        public Contact con {get;set;}
        public List<selectOption> levelOptions {get;set;}
        public String level {get;set;}
        
        public customerActionWrapper(Contact conc){
            isSelected = false;
            allSelected = false;
            if(conc != null){
                con = conc;
            } else {
                con = new Contact();
            }
            levelOptions = new List<selectOption>();
            levelOptions.add(new selectOption('None','--None--'));
            levelOptions.add(new selectOption('Requestor','Requestor'));
            levelOptions.add(new selectOption('Collaborator','Collaborator'));
        }
    }
}