public with sharing class DWC_SetOfFinalStatusCtrl {
    
    public set<string> setofPrimeDie{get;set;}
    public set<string> setofStatus{get;set;}
    public String collId {get; set;}
    
    public void init(){
        if(!Test.isRunningTest()){
         collId=apexpages.currentpage().getparameters().get('id');
        } else {
            Wavier_Collaborator__c waiverCollaborator = new Wavier_Collaborator__c();
            waiverCollaborator = [Select Id from Wavier_Collaborator__c Where IsDeleted = false limit 1]; 
            collId = waiverCollaborator.Id;
        }    
        system.debug('collId'+collId);
        setofStatus=new set<string>();
        setofPrimeDie=new set<string>();
        
        List<Waiver_Rule_List__c> lst_WaiverRules = [SELECT Id,Name,Final_Stage__c,Prime_Die_Name__c,Rule_Type__c,Waiver_Collaborator__c,RecallApprovalProcess__c 
                                                        FROM Waiver_Rule_List__c  where Waiver_Collaborator__c=:collId and Rule_Type__c !='' ];
        integer count=0;
        for(Waiver_Rule_List__c w:lst_WaiverRules){
            setofStatus.add(w.Final_Stage__c);
            setofPrimeDie.add(w.Prime_Die_Name__c);
            count++;
        }
        if(setofPrimeDie!=null && setofPrimeDie.size()>1) { updateReleaseToCustFlag(collId,setofStatus); }
      }
  
     @future
    public static void updateReleaseToCustFlag(string collabId,set<string> statusSet){
        
        Integer chipCount =  [SELECT count() FROM Chip__c
                     WHERE Wavier_Collaborator__c =:collabId  ];
        
        List<Wavier_Collaborator__c> wc=[select id,isMulti__c from Wavier_Collaborator__c where id=:collabId ];
        if(!wc.isempty()){
            if(chipCount != null && chipCount>1) wc[0].isMulti__c=true;  
         DfmUtilityCls.stopTrigger=true;
        system.debug('test start ');
        update wc;
        }
  }

}