public class ContractManageMembersCtrlExt{

public ContractManageMembersCtrlExt(){
    
  
     String id = apexpages.currentpage().getparameters().get('id');
      List<Apttus__APTS_Agreement__c> contractList = [select Id,Name,Apttus__Status__c,Apttus__Status_Category__c, OwnerId   
                                                             from Apttus__APTS_Agreement__c where id = :id];
      if(contractList.size() > 0) {
            ContractRoom  = contractList.get(0);
         }
         
         if(contractList != null) {  
            ContractRoomName = ContractRoom.Name;
            Map<String,Contract_Team__c> groupMap = new Map<String,Contract_Team__c>();
            List<Contract_Team__c> currMembers = null;
            List<Contract_Team__c> sortedMembers = new List<Contract_Team__c>();
              
            currMembers = [SELECT Id, User__c, User__r.Name, User__r.ProfileId, User__r.UserRoleId, Access__c, Is_Group__c, Group_Selected__c, Group_ID__c, Group_Name__c 
                           FROM Contract_Team__c WHERE Agreement__c = :ContractRoom.id ORDER BY User__r.Name];
            
            sTeamMember = new Set<String>();
            Contract_Team__c  mbr = new Contract_Team__c(Agreement__c = ContractRoom.id, Access__c = null, Is_Group__c = false, Group_Name__c = null);            
              
            for(Contract_Team__c  member: currMembers) {
                sTeamMember.add(member.User__c);
                
                if(member.Is_Group__c == null) {
                   member.Is_Group__c = false;
                }else if(member.Is_Group__c == true) {
                    groupMap.put(member.Group_ID__c, member);
                } 
                
            }
         
      
          for (Integer iterator = 0; iterator < 5; iterator++) {
                currMembers.add(new Contract_Team__c(Agreement__c = ContractRoom.id, Access__c = null, Is_Group__c = false, Group_Name__c = null));
            }
            
           //QUERY and get the GROUPS
            Groups = [select Id,Type,Name from Group where Type = 'Regular'];
            for(Group g:Groups)
            {
               mbr = groupMap.get(g.Id);
               if(mbr == null)
               {
                   mbr = new Contract_Team__c(Agreement__c = ContractRoom.id, Access__c = null,Group_Selected__c = false, Group_ID__c = g.Id, Is_Group__c = true, Group_Name__c = g.Name);
                   
               }else
               {
                   mbr.Group_Selected__c = true;
                   mbr.Is_Group__c = true;
                   mbr.Group_Name__c = g.Name;
                   mbr.Group_ID__c = g.Id;
               }
               
               sortedMembers.add(mbr);
            }

            Members = currMembers;
         }
    }
            
       
     public Apttus__APTS_Agreement__c ContractRoom{get;set;}
     public List<Contract_Team__c> Members{get;set;}
     public List<Group> Groups{get;set;}  
     public String ContractRoomName{get;set;}
     public Set<String> sTeamMember {get; set;}
    
    
    public PageReference addNewRow() {
       Contract_Team__c newMember = new Contract_Team__c();
       if(ContractRoom != null) {
           newMember.Agreement__c = ContractRoom.id;
       }
       
       Members.add(newMember);
       return null;
    }
    
     // This method deletes Contract Member
    public PageReference deleteMember() {
        PageReference pageReference = ApexPages.currentPage();
        String memberId = pageReference.getParameters().get('memberId');
        
        List<String> lDeletedUserIds = new List<String>();
        List<Contract_Team__c> lDeleteMember = [SELECT Id, User__c,User_Profile__c,User_Role__c FROM Contract_Team__c WHERE Id =: memberId];
        
        Integer iterator = 0;
        
        while (iterator < Members.size()) {
            if (Members.get(iterator).Id == memberId) {
                lDeletedUserIds.add(Members.get(iterator).User__c);            
                Members.remove(iterator);
            } else {
                iterator++;
            }
        }
        
        sTeamMember.removeAll(lDeletedUserIds);
        
        delete lDeleteMember;
        
        return null;
    }
    
       public PageReference Save() {
           // try {
            List<Id> newMembers = new List<Id>();
            PageReference trPage = null;
            
            if(ContractRoom  != null) {
            trPage = new PageReference('/'+ContractRoom.Id);
            }
            
            List<Contract_Team__c> umembers = new List<Contract_Team__c>();
            List<Contract_Team__c> dmembers = new List<Contract_Team__c>();
            Set<String> sTeamRoomCheck = new Set<String>();
            
            sTeamRoomCheck.addAll(sTeamMember);
            
           for(Contract_Team__c member: Members) { 
            
            if(!member.Is_Group__c) {
            if (member.User__c != null && member.Access__c != null) {
            String strId = member.Id;
            if (strId != null && strId.length() > 0) {umembers.add(member);} 
            else { newMembers.add(member.User__c);umembers.add(member);}
            }
           }
          }
            try{           
             upsert umembers;
            }catch (DMLException e){
             for (Contract_Team__c ct : umembers) {
                  ct.addError('There was a problem insert/updating the contract team:'+ e.getMessage());
             }
            }
            try{
            delete dmembers;
            }catch (DMLException ex){
             for (Contract_Team__c dm : umembers) {
                  dm.addError('There was a problem deleting the contract team:'+ ex.getMessage());
             }
            } 
             
            return trPage;
        }
    }