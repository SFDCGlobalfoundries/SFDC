/*
  Author: Anirban Roy
  Description: This is the controller class for CPQ Information Required.
  History:
    ARoy        02192015    - code creation.             
*/

public class CPQInformationRequiredController {
    
    public Apttus_Proposal__Proposal__c proposal{get;set;}
    public String toEmailAddress {get;set;}
    public Boolean isUpdate;
    public Boolean haveUserPermission {get;set;}
    
    public CPQInformationRequiredController(ApexPages.StandardController controller) {
        //proposal = (Apttus_Proposal__Proposal__c)controller.getRecord();
        proposal = [select  id
                            , Apttus_Proposal__Approval_Stage__c
                            , Information_Required_Status__c
                            , Device__r.Fab__c
                            , Approver_User_1__c
                            , Approver_User_2__c
                            , Approver_User_3__c
                            , Approver_User_4__c
                            , Approver_User_5__c
                            , Approver_User_6__c
                            , Approver_User_7__c
                            , Approver_User_8__c
                            , Approver_User_9__c
                            , Approver_User_10__c
                            , Approver_User_1__r.Name
                            , Approver_User_2__r.Name
                            , Approver_User_3__r.Name
                            , Approver_User_4__r.Name
                            , Approver_User_5__r.Name
                            , Approver_User_6__r.Name
                            , Approver_User_7__r.Name
                            , Approver_User_8__r.Name
                            , Approver_User_9__r.Name
                            , Approver_User_10__r.Name
                            , Information_Comments__c
                            , CreatedBy.Name
                    from    Apttus_Proposal__Proposal__c
                    where   Id = :((Apttus_Proposal__Proposal__c)controller.getRecord()).Id];
        toEmailAddress='';
        
        haveUserPermission = true;
        Boolean isCheck = false;
        isUpdate = false;
        if(proposal.Apttus_Proposal__Approval_Stage__c == 'Submitted Phase' 
            && proposal.Information_Required_Status__c != 'Information Required from Customer'){
            proposal.Information_Required_Status__c = 'Information Required from Customer';
            isUpdate = true;
            isCheck = true;
        }else if(proposal.Apttus_Proposal__Approval_Stage__c == 'Submitted Phase'
            && proposal.Information_Required_Status__c == 'Information Required from Customer'){
            proposal.Information_Required_Status__c = 'Information Updated';
            isUpdate = true;
        }else if((proposal.Apttus_Proposal__Approval_Stage__c == 'Configuration Design Phase' 
                || proposal.Apttus_Proposal__Approval_Stage__c == 'Package Accepted Phase'
                || proposal.Apttus_Proposal__Approval_Stage__c == 'Process Accepted Phase')
            && proposal.Information_Required_Status__c != 'Information Required from FAE'){
            proposal.Information_Required_Status__c = 'Information Required from FAE';
            isUpdate = true;
        }else if((proposal.Apttus_Proposal__Approval_Stage__c == 'Configuration Design Phase' 
                || proposal.Apttus_Proposal__Approval_Stage__c == 'Package Accepted Phase'
                || proposal.Apttus_Proposal__Approval_Stage__c == 'Process Accepted Phase')
            && proposal.Information_Required_Status__c == 'Information Required from FAE'){
            proposal.Information_Required_Status__c = 'Information Updated';
            isUpdate = true;
            isCheck = true;
        }
                
        Set<String> profIds = new Set<String>();
        for(Profile p : [select id from Profile where name in ('System Administrator','GF Global Admin','GF FAE/FTS')]){
            profIds.add(p.Id);    
        }
        if(isCheck && !(UserInfo.getUserId() == proposal.Approver_User_1__c || UserInfo.getUserId() == proposal.Approver_User_2__c
            || UserInfo.getUserId() == proposal.Approver_User_3__c || UserInfo.getUserId() == proposal.Approver_User_4__c
            || UserInfo.getUserId() == proposal.Approver_User_5__c || UserInfo.getUserId() == proposal.Approver_User_6__c
            || UserInfo.getUserId() == proposal.Approver_User_7__c || UserInfo.getUserId() == proposal.Approver_User_8__c
            || UserInfo.getUserId() == proposal.Approver_User_9__c || UserInfo.getUserId() == proposal.Approver_User_10__c 
            || profIds.contains(UserInfo.getProfileId()))){
            haveUserPermission = false;
            ApexPages.addmessage(new ApexPages.Message(ApexPages.severity.ERROR,'User other than FAE/Admins have no permission to click Information required button.'));                
        }
        
        if(proposal.Information_Required_Status__c == 'Information Required from Customer' 
            && proposal.Apttus_Proposal__Approval_Stage__c == 'Submitted Phase'){
            toEmailAddress = proposal.CreatedBy.Name;
        }else if((proposal.Information_Required_Status__c == 'Information Updated' 
            && proposal.Apttus_Proposal__Approval_Stage__c == 'Submitted Phase')
            || (proposal.Information_Required_Status__c == 'Information Required from FAE'
            && (proposal.Apttus_Proposal__Approval_Stage__c == 'Configuration Design Phase' 
                || proposal.Apttus_Proposal__Approval_Stage__c == 'Package Accepted Phase'
                || proposal.Apttus_Proposal__Approval_Stage__c == 'Process Accepted Phase'))){
            toEmailAddress = proposal.Approver_User_1__c != null?proposal.Approver_User_1__r.Name+', ':'';
            toEmailAddress = proposal.Approver_User_2__c != null?(toEmailAddress + proposal.Approver_User_2__r.Name+', '):toEmailAddress;
            toEmailAddress = proposal.Approver_User_3__c != null?(toEmailAddress + proposal.Approver_User_3__r.Name+', '):toEmailAddress;
            toEmailAddress = proposal.Approver_User_4__c != null?(toEmailAddress + proposal.Approver_User_4__r.Name+', '):toEmailAddress;
            toEmailAddress = proposal.Approver_User_5__c != null?(toEmailAddress + proposal.Approver_User_5__r.Name+', '):toEmailAddress;
            toEmailAddress = proposal.Approver_User_6__c != null?(toEmailAddress + proposal.Approver_User_6__r.Name+', '):toEmailAddress;
            toEmailAddress = proposal.Approver_User_7__c != null?(toEmailAddress + proposal.Approver_User_7__r.Name+', '):toEmailAddress;
            toEmailAddress = proposal.Approver_User_8__c != null?(toEmailAddress + proposal.Approver_User_8__r.Name+', '):toEmailAddress;
            toEmailAddress = proposal.Approver_User_9__c != null?(toEmailAddress + proposal.Approver_User_9__r.Name+', '):toEmailAddress;
            toEmailAddress = proposal.Approver_User_10__c != null?(toEmailAddress + proposal.Approver_User_10__r.Name):toEmailAddress;
            toEmailAddress = (toEmailAddress!=null)?toEmailAddress.removeEnd(', '):'';
        }else if(proposal.Information_Required_Status__c == 'Information Updated'
            && (proposal.Apttus_Proposal__Approval_Stage__c == 'Configuration Design Phase' 
                || proposal.Apttus_Proposal__Approval_Stage__c == 'Package Accepted Phase'
                || proposal.Apttus_Proposal__Approval_Stage__c == 'Process Accepted Phase')){
            toEmailAddress = 'Packaging '+proposal.Device__r.Fab__c+' Queue'+', PIYE '+proposal.Device__r.Fab__c+' Queue';
        }
    }
    
    public PageReference submitPage(){        
        
        if(isUpdate){
            update proposal;
        }
        
        PageReference pr;
        if(Apexpages.currentPage().getHeaders().get('Referer').contains('GlobalfoundryView')){
            pr = new PageReference('/GlobalfoundryView/'+proposal.Id);
        }else{
            pr = new PageReference('/'+proposal.Id);
        }        
        return pr;
    }
    
    public PageReference cancel(){
        PageReference pr;
        if(Apexpages.currentPage().getHeaders().get('Referer').contains('GlobalfoundryView')){
            pr = new PageReference('/GlobalfoundryView/'+proposal.Id);
        }else{
            pr = new PageReference('/'+proposal.Id);
        }        
        return pr;
    }

}