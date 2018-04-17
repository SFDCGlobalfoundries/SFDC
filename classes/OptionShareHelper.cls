/**
@Author < Meghna Ganguly >
@name < OptionShareHelper>
@CreateDate < 12/16/2016 >
@Description < This class manages the creation of Option Share from 
                Oppty Program Team Member insert/update/delete and Option Insert.>
@Version <1.0>
*/
public class OptionShareHelper {

    public static String OPPTY_PROGRAM_SHARE = EnvironmentVariable.get('OPP_PGM_TM_MEM_SR');
    public static Map<String,String> RECORD_ACCESS = new Map<String,String>{'Read/Write'=>'Edit','Read Only'=>'Read','Private'=>'None'}; 
    
    /* Option Sharing Start*/ 
    
   @testvisible private static List<Customer_Requirement__Share> createOptionShare(Opportunity_Program_Team_Member__c optm, List<Id> optionIds){
        List<Customer_Requirement__Share> lOpShr = new List<Customer_Requirement__Share>();
        for(Id opId: optionIds){
            Customer_Requirement__Share newDS = new Customer_Requirement__Share();
            newDS.AccessLevel = RECORD_ACCESS.get(optm.device_Access__c);
            newDS.RowCause = OPPTY_PROGRAM_SHARE;
            newDS.ParentId = opId;
            newDS.UserOrGroupId = optm.User__c;
            lOpShr.add(newDS);
        }
        
        return lOpShr;
    } 
    
    // method to insert option share records when Oppty Program Team Member record is created
    public static voId insertOptionShare(Set<Id> opptyIds, Map<Id ,Opportunity_Program_Team_Member__c> mapNewOpptyProgramTeamMember, Set<Id> activeUserIds){
         
         // declare variable
         Map<String, List<Customer_Requirement__Share>> mapOppProgShares = new Map<String, List<Customer_Requirement__Share>>();
         //Map<String,String> oppopshares = opshareRecords(opptyIds);  
         List<Customer_Requirement__Share> insertoptionShare = new List<Customer_Requirement__Share>();
         List<Customer_Requirement__Share> oplist = new List<Customer_Requirement__Share>();
         

         for(Customer_Requirement__c option:[select Id ,Device__r.Opportunity_Program__c from Customer_Requirement__c where Device__r.Opportunity_Program__c IN :opptyIds order by Device__r.Opportunity_Program__c]){
            Customer_Requirement__Share newDS = new Customer_Requirement__Share();
            newDS.RowCause = OPPTY_PROGRAM_SHARE;
            newDS.ParentId = option.Id;
            //String oppProgId = oppopshares.get(option.Id);
            List<Customer_Requirement__Share> optionsForKey = mapOppProgShares.get(option.Device__r.Opportunity_Program__c);
            if (optionsForKey == null) {
                optionsForKey = new List<Customer_Requirement__Share>();
                optionsForKey.add(newDS);

                mapOppProgShares.put(option.Device__r.Opportunity_Program__c, optionsForKey);
            }else{
                 optionsForKey.add(newDS);
                mapOppProgShares.put(option.Device__r.Opportunity_Program__c, optionsForKey);

            }
        }
        
           
        
        for(Opportunity_Program_Team_Member__c optm: mapNewOpptyProgramTeamMember.values()){
            //only process the records that are not flagged for delete and are not core members
            if (!optm.Flag_for_Delete__c && activeUserIds.contains(optm.User__c)){
                String oppProgId = optm.Opportunity_Program__c;
                //String UserId = optm.User__c;
                List<Customer_Requirement__Share> dsList = mapOppProgShares.get(oppProgId);
                if(dsList!=null && dsList.size()>0){
                    for(Customer_Requirement__Share ds:dsList){
                        Customer_Requirement__Share ds1 = ds.clone();
                        if(ds1!=null){
                            ds1.AccessLevel = RECORD_ACCESS.get(optm.device_Access__c);
                            ds1.UserOrGroupId = optm.User__c;
                            insertoptionShare.add(ds1);
                        }
                    }
                }                   
            }
        }
        system.debug('@@@@@@@@insertoptionShare'+insertoptionShare);
        try {
            if(insertoptionShare != null && insertoptionShare.size()>0){
                insert insertoptionShare;
            }
        } catch (Exception e) {
            GlobalUtility.logMessage('Error','OptionShareHelper','insertOptionShare','','Exception while creating Option Share record',String.valueof(e.getMessage()),'','Option Share',e,0);
        }                      
    }
   
  // method to insert option share records when option record is created 
   public static voId insertOptionShare(Set <Id> IdNewoptions){
        Map<Id ,List<Opportunity_Program_Team_Member__c>> mapOpptyProgTeamMembers = new Map<Id ,List<Opportunity_Program_Team_Member__c>>();
        Set<Id> opptyIds = new Set<Id>();
        Set<Id> userIds = new Set<Id>();
        Set<Id> activeUserIds = new Set<Id>();
        
        List<Customer_Requirement__c> optionList = [select Device__r.Opportunity_Program__c from Customer_Requirement__c
                                where Id in :IdNewoptions];
        for(Customer_Requirement__c ooption : optionList){
            opptyIds.add(ooption.Device__r.Opportunity_Program__c);
        }
        system.debug('opptyIds : ' + opptyIds);
        
        // retrieve all program team members for each Opportunity Program
        for(Opportunity_Program__c oProgram : [select Id , (select Id , device_Access__c, User__c, User__r.IsActive, Flag_for_Delete__c from Opportunity_Program_Team_Members__r) 
                                              from Opportunity_Program__c where Id in :opptyIds]){
            
            // save program team members based on Opportunity Program
            for(Opportunity_Program_Team_Member__c oProgramTeamMember : oProgram.Opportunity_Program_Team_Members__r){
                userIds.add(oProgramTeamMember.User__c);
                
                // check if member is not flag for delete and user is active.
                if(!oProgramTeamMember.Flag_for_Delete__c && oProgramTeamMember.User__r.IsActive){
                    if(mapOpptyProgTeamMembers.containsKey(oProgram.Id)){
                        List<Opportunity_Program_Team_Member__c> lstProgTeamMembers = mapOpptyProgTeamMembers.get(oProgram.Id);
                        lstProgTeamMembers.add(oProgramTeamMember);
                        mapOpptyProgTeamMembers.put(oProgram.Id ,lstProgTeamMembers);
                    }else{
                        mapOpptyProgTeamMembers.put(oProgram.Id ,new List<Opportunity_Program_Team_Member__c>{oProgramTeamMember});
                    }
                }
            }
        }
        
        // iterate to all new option records
        List<Customer_Requirement__Share> lstNewoptionShare = new List<Customer_Requirement__Share>();
        for(Customer_Requirement__c ooption : optionList){
            // Check if there are team members
            if(mapOpptyProgTeamMembers.containsKey(ooption.Device__r.Opportunity_Program__c)){
                for(Opportunity_Program_Team_Member__c oTeamMember : mapOpptyProgTeamMembers.get(ooption.Device__r.Opportunity_Program__c)){
                    Customer_Requirement__Share newDS = new Customer_Requirement__Share();
                    newDS.RowCause = OPPTY_PROGRAM_SHARE;
                    newDS.ParentId = ooption.Id;
                    newDS.AccessLevel = RECORD_ACCESS.get(oTeamMember.device_Access__c);
                    newDS.UserOrGroupId = oTeamMember.User__c;
                    lstNewoptionShare.add(newDS);
                }
            }
        }
        try {
            // create sharing records
            if(lstNewoptionShare.size()>0){
                insert lstNewoptionShare;
            }
        } catch (Exception e) {
            GlobalUtility.logMessage('Error','OptionShareHelper','insertOptionShare','','Exception while creating Option share record',String.valueof(e.getMessage()),'','Option Share',e,0);
        }
    }
   
   //method to update option share records when Oppty Program Team Member record is updated 
    public static voId updateOptionShare( Set<Opportunity_Program_Team_Member__c> sOPTM){
        // declare variable
        Map<Id , List<Id>> mOpptyPrgmId2Options = new Map<Id , List<Id>>();
        Map<String, List<Customer_Requirement__Share>> mOpptyPrgmAndUserId2opshares = new Map<String, List<Customer_Requirement__Share>>();
        Set<String> sUniqueId = new Set<String>();
        Set<Id> sOpptyPrgmId = new Set<Id>();
        Set<Id> sUserId = new Set<Id>();
        List<Customer_Requirement__Share> upsertOptionShares = new List<Customer_Requirement__Share>(); 
        
        for(Opportunity_Program_Team_Member__c optm :sOPTM){
            sOpptyPrgmId.add(optm.Opportunity_Program__c);
            sUserId.add(optm.user__c);
        }
        
        List<Customer_Requirement__c> oplist = [select Id ,Device__r.Opportunity_Program__c from Customer_Requirement__c where Device__r.Opportunity_Program__c=:sOpptyPrgmId];
        Map<Id , List<Id>> mOpptyPrgmId2DevIds = new Map<Id , List<Id>>();
        for(Customer_Requirement__c dev : oplist) {
            if(mOpptyPrgmId2Options.containskey(dev.Device__r.Opportunity_Program__c)){
                mOpptyPrgmId2Options.get(dev.Device__r.Opportunity_Program__c).add(dev.Id);
            }else {
                mOpptyPrgmId2Options.put(dev.Device__r.Opportunity_Program__c, new List<Id>{dev.Id});
            }
            for(Opportunity_Program_Team_Member__c optm :sOPTM){
                sUniqueId.add(dev.Device__r.Opportunity_Program__c + ''+ dev.Id + '' + optm.user__c);
            }
            
        }
        
        List<Customer_Requirement__Share> opshareList = [select AccessLevel,Id , IsDeleted, LastModifiedById , LastModifiedDate,
                                      ParentId , RowCause, UserOrGroupId , Parent.Device__r.Opportunity_Program__c from Customer_Requirement__Share
                                      where ParentId in (select Id from Customer_Requirement__c where Device__r.Opportunity_Program__c=:sOpptyPrgmId)
                                      and RowCause=:OPPTY_PROGRAM_SHARE
                                      and userOrGroupId =:sUserId];
                                      
        for(Customer_Requirement__Share opshare : opshareList){
            if(sUniqueId.contains(opshare.Parent.Device__r.Opportunity_Program__c + '' + opshare.parentId + '' + opshare.userorgroupId)){
                if(mOpptyPrgmAndUserId2opshares.containskey(opshare.Parent.Device__r.Opportunity_Program__c + '' + opshare.userorgroupId)){
                    mOpptyPrgmAndUserId2opshares.get(opshare.Parent.Device__r.Opportunity_Program__c + '' + opshare.userorgroupId).add(opshare);
                }else {
                    mOpptyPrgmAndUserId2opshares.put(opshare.Parent.Device__r.Opportunity_Program__c + '' + opshare.userorgroupId , new List<Customer_Requirement__Share>{opshare});
                }
            }
        }
        
                                             
        for(Opportunity_Program_Team_Member__c optm: sOPTM){
            //only process the records that are not flagged for delete and are not core members
            Id oppPrgmId = optm.Opportunity_Program__c;
            Id userId = optm.User__c;
            if(mOpptyPrgmAndUserId2opshares.containskey(oppPrgmId + '' + userId)){
                List<Customer_Requirement__Share> opshares = mOpptyPrgmAndUserId2opshares.get(oppPrgmId + '' + userId);
                Set<Id> sDevId = new Set<Id>();
                if(mOpptyPrgmId2Options.containsKey(optm.Opportunity_Program__c)){
                    sDevId = new Set<Id>(mOpptyPrgmId2Options.get(optm.Opportunity_Program__c));
                }
                
                for(Customer_Requirement__Share devShr : opshares){
                    devShr.AccessLevel = RECORD_ACCESS.get(optm.device_Access__c);
                    sDevId.remove(devShr.parentId);
                    upsertOptionShares.add(devShr);
                }
                
                if(sDevId.size() > 0){
                   List<Customer_Requirement__Share> newopshares = createOptionShare(optm, new List<Id>(sDevId));
                   upsertOptionShares.addall(newopshares);
                }
                
            }else if(mOpptyPrgmId2Options.containskey(optm.Opportunity_Program__c)){
                List<Customer_Requirement__Share> newopshares = createOptionShare(optm, mOpptyPrgmId2Options.get(optm.Opportunity_Program__c));
                upsertOptionShares.addall(newopshares);
            }
        }
        try {
            if(upsertOptionShares.size()>0){
                upsert upsertOptionShares;
            }
        } catch (Exception e) {
            GlobalUtility.logMessage('Error','OptionShareHelper','updateOptionShare','','Exception while updating Option share record',String.valueof(e.getMessage()),'','Option Share',e,0);
        }
    }
 
    //method to delete option share records when Oppty Program Team Member record is deleted
    public static voId deleteOptionShare(Set<Id> opptyIds, Set<Id> userIds){
        List<Customer_Requirement__Share> opList = [select Id from Customer_Requirement__Share
                                      where ParentId in (select Id from Customer_Requirement__c where Device__r.Opportunity_Program__c=:opptyIds)
                                      and UserOrGroupId=:userIds
                                      and RowCause=:OPPTY_PROGRAM_SHARE];
        
        try {
            if(opList!=null && opList.size()>0){
                delete opList;
            }
        } catch (Exception e) {
            GlobalUtility.logMessage('Error','OptionShareHelper','deleteOptionShare','','Exception while deleting Option share record',String.valueof(e.getMessage()),'','Option Share',e,0);
        }
    }
    
   @testvisible private static Map<String, String> opshareRecords(Set<Id> setOppProgIds){
            Map<String, String> oppopshares = new Map<String, String>(); 
            List<Customer_Requirement__c> oplist = [select Id ,Device__r.Opportunity_Program__c from Customer_Requirement__c where Device__r.Opportunity_Program__c=:setOppProgIds];
            
            if(oplist!=null && oplist.size()>0){
                for(Customer_Requirement__c dev :oplist){
                    oppopshares.put(dev.Id, dev.Device__r.Opportunity_Program__c);
                }
            }
            return oppopshares;
      }
    /* Option Sharing End*/
  
    

  }