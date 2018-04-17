/**
@Author < Meghna Ganguly >
@name < ASICSSpecificationsTriggerHelper>
@CreateDate < 01/05/2017 >
@Description < This class manages the creation of ASICS Specifications Share from 
                Oppty Program Team Member insert/update/delete and ASICS Specifications Insert.>
@Version <1.0>
*/
public class ASICSSpecificationsTriggerHelper {

    public static String OPPTY_PROGRAM_SHARE = EnvironmentVariable.get('OPP_PGM_TM_MEM_SR');
    public static Map<String,String> RECORD_ACCESS = new Map<String,String>{'Read/Write'=>'Edit','Read Only'=>'Read','Private'=>'None'}; 
   
    /* ASICS Specifications Sharing Start*/
    @testvisible private static List<ASICS_Specification__Share> createasicShare(Opportunity_Program_Team_Member__c optm, List<Id> packIds){
        List<ASICS_Specification__Share> lasicShr = new List<ASICS_Specification__Share>();
        for(Id devId :packIds){
            ASICS_Specification__Share newDS = new ASICS_Specification__Share();
            newDS.AccessLevel = RECORD_ACCESS.get(optm.device_Access__c);
            newDS.RowCause = OPPTY_PROGRAM_SHARE;
            newDS.ParentId = devId;
            newDS.UserOrGroupId = optm.User__c;
            lasicShr.add(newDS);
        }
        return lasicShr;
    } 
    
    // method to insert ASICS Specifications share records when Oppty Program Team Member record is created
    public static voId insertasicShare(Set<Id> opptyIDs, Map<Id, Opportunity_Program_Team_Member__c> mapNewOpptyProgramTeamMember, Set<Id> activeUserIDs){
         
         // declare variable
         Map<String, List<ASICS_Specification__Share>> mapOppProgShares = new Map<String, List<ASICS_Specification__Share>>();
         List<ASICS_Specification__Share> insertasicShare = new List<ASICS_Specification__Share>();
         List<ASICS_Specification__Share> asicList = new List<ASICS_Specification__Share>();
         

         for(ASICS_Specification__c asic:[select id, Device__r.Opportunity_Program__c from ASICS_Specification__c where Device__r.Opportunity_Program__c IN :opptyIDs order by Device__r.Opportunity_Program__c]){
            ASICS_Specification__Share newDS = new ASICS_Specification__Share();
            newDS.RowCause = OPPTY_PROGRAM_SHARE;
            newDS.ParentId = asic.id;
            
            List<ASICS_Specification__Share> asicsForKey = mapOppProgShares.get(asic.Device__r.Opportunity_Program__c);
            if (asicsForKey == null) {
                asicsForKey = new List<ASICS_Specification__Share>();
                asicsForKey.add(newDS);

                mapOppProgShares.put(asic.Device__r.Opportunity_Program__c, asicsForKey);
            } else{
                 asicsForKey.add(newDS);
                mapOppProgShares.put(asic.Device__r.Opportunity_Program__c, asicsForKey);

            }
        }
        
        for(Opportunity_Program_Team_Member__c optm: mapNewOpptyProgramTeamMember.values()){
            //only process the records that are not flagged for delete and are not core members
            if (!optm.Flag_for_Delete__c && activeUserIDs.contains(optm.User__c)){
                String oppProgId = optm.Opportunity_Program__c;
                //String UserId = optm.User__c;
                List<ASICS_Specification__Share> dsList = mapOppProgShares.get(oppProgID);
                if(dsList!=null && dsList.size()>0){
                    for(ASICS_Specification__Share ds:dsList){
                        ASICS_Specification__Share ds1 = ds.clone();
                        if(ds1!=null){
                            ds1.AccessLevel = RECORD_ACCESS.get(optm.device_Access__c);
                            ds1.UserOrGroupId = optm.User__c;
                            insertasicShare.add(ds1);
                        }
                    }
                }                   
            }
        }
        try {
            if(insertasicShare!=null && insertasicShare.size()>0){
                insert insertasicShare;
            }
        } catch (Exception e) {
            GlobalUtility.logMessage('Error','ASICSSpecificationsTriggerHelper','insertasicShare','','Exception while creating ASICS Specifications Data share record',String.valueof(e.getMessage()),'','ASICS Specifications Share',e,0);
        }                       
    }
     
    public void insertasicSpecificationsShare(){ 
        insertasicspecShare(trigger.newMap.keySet());
    }
    
   // method to insert ASICS Specifications share records when ASICS Specifications record is created
   public static voId insertasicspecShare(Set<Id> NewasicsIds){
        Map<Id, List<Opportunity_Program_Team_Member__c>> mapOpptyProgTeamMembers = new Map<Id, List<Opportunity_Program_Team_Member__c>>();
        Set<Id> opptyIDs = new Set<Id>();
        Set<Id> userIDs = new Set<Id>();
        Set<Id> activeUserIDs = new Set<Id>();
        
        List<ASICS_Specification__c> asicsList = [select Device__r.Opportunity_Program__c from ASICS_Specification__c
                                where Id in :NewasicsIds];
        for(ASICS_Specification__c opack : asicsList){
            opptyIDs.add(opack.Device__r.Opportunity_Program__c);
        }
        
        // retrieve all program team members for each Opportunity Program
        for(Opportunity_Program__c oProgram : [select id, (select id, device_Access__c, User__c, User__r.IsActive, Flag_for_Delete__c from Opportunity_Program_Team_Members__r) 
                                              from Opportunity_Program__c where Id in :opptyIDs]){
            
            // save program team members based on Opportunity Program
            for(Opportunity_Program_Team_Member__c oProgramTeamMember : oProgram.Opportunity_Program_Team_Members__r){
                userIDs.add(oProgramTeamMember.User__c);
                
                // check if member is not flag for delete and user is active.
                if(!oProgramTeamMember.Flag_for_Delete__c && oProgramTeamMember.User__r.IsActive){
                    if(mapOpptyProgTeamMembers.containsKey(oProgram.Id)){
                        List<Opportunity_Program_Team_Member__c> lstProgTeamMembers = mapOpptyProgTeamMembers.get(oProgram.Id);
                        lstProgTeamMembers.add(oProgramTeamMember);
                        mapOpptyProgTeamMembers.put(oProgram.id,lstProgTeamMembers);
                    }else{
                        mapOpptyProgTeamMembers.put(oProgram.id,new List<Opportunity_Program_Team_Member__c>{oProgramTeamMember});
                    }
                }
            }
        }
        
        // iterate to all new asic records
        List<ASICS_Specification__Share> lstNewpackShare = new List<ASICS_Specification__Share>();
        for(ASICS_Specification__c opack : asicsList){
            // Check if there are team members
            if(mapOpptyProgTeamMembers.containsKey(opack.Device__r.Opportunity_Program__c)){
                for(Opportunity_Program_Team_Member__c oTeamMember : mapOpptyProgTeamMembers.get(opack.Device__r.Opportunity_Program__c)){
                    ASICS_Specification__Share newDS = new ASICS_Specification__Share();
                    newDS.RowCause = OPPTY_PROGRAM_SHARE;
                    newDS.ParentId = opack.id;
                    newDS.AccessLevel = RECORD_ACCESS.get(oTeamMember.device_Access__c);
                    newDS.UserOrGroupId = oTeamMember.User__c;
                    lstNewpackShare.add(newDS);
                }
            }
        }
        try {
            // create sharing records
            if(lstNewpackShare.size()>0){
                insert lstNewpackShare;
            }
        } catch (Exception e) {
            GlobalUtility.logMessage('Error','ASICSSpecificationsTriggerHelper','insertasicspecShare','','Exception while creating ASICS Specifications Data Share record',String.valueof(e.getMessage()),'','ASICS Specifications Share',e,0);
        }
    }
     
    //method to update ASICS Specifications share records when Oppty Program Team Member record is updated
    public static voId updateasickShare( Set<Opportunity_Program_Team_Member__c> sOPTM){
        // declare variable
        Map<Id, List<Id>> mOpptyPrgmId2packs = new Map<Id, List<Id>>();
        Map<String, List<ASICS_Specification__Share>> mOpptyPrgmAndUserId2opshares = new Map<String, List<ASICS_Specification__Share>>();
        Set<String> sUniqueId = new Set<String>();
        Set<Id> sOpptyPrgmId = new Set<Id>();
        Set<Id> sUserId = new Set<Id>();
        List<ASICS_Specification__Share> upsertasicShares = new List<ASICS_Specification__Share>(); 
        
        for(Opportunity_Program_Team_Member__c optm :sOPTM){
            sOpptyPrgmId.add(optm.Opportunity_Program__c);
            sUserId.add(optm.user__c);
        }
        
        List<ASICS_Specification__c> asicList = [select id,Device__r.Opportunity_Program__c from ASICS_Specification__c where Device__r.Opportunity_Program__c=:sOpptyPrgmId];
        Map<Id, List<Id>> mOpptyPrgmId2DevIds = new Map<Id, List<Id>>();
        for(ASICS_Specification__c dev : asicList) {
            if(mOpptyPrgmId2packs.containskey(dev.Device__r.Opportunity_Program__c)){
                mOpptyPrgmId2packs.get(dev.Device__r.Opportunity_Program__c).add(dev.id);
            } else {
                mOpptyPrgmId2packs.put(dev.Device__r.Opportunity_Program__c, new List<Id>{dev.id});
            }
            for(Opportunity_Program_Team_Member__c optm :sOPTM){
                sUniqueId.add(dev.Device__r.Opportunity_Program__c + ''+ dev.Id + '' + optm.user__c);
            }
            
        }
        
        List<ASICS_Specification__Share> asicshareList = [select AccessLevel,Id, IsDeleted, LastModifiedById, LastModifiedDate,
                                      ParentId, RowCause, UserOrGroupId , Parent.Device__r.Opportunity_Program__c from ASICS_Specification__Share
                                      where ParentId in (select Id from ASICS_Specification__c where Device__r.Opportunity_Program__c=:sOpptyPrgmId)
                                      and RowCause=:OPPTY_PROGRAM_SHARE
                                      and userOrGroupId =:sUserId];
                                      
        for(ASICS_Specification__Share opshare : asicshareList){
            if(sUniqueId.contains(opshare.Parent.Device__r.Opportunity_Program__c + '' + opshare.parentId + '' + opshare.userorgroupid)){
                if(mOpptyPrgmAndUserId2opshares.containskey(opshare.Parent.Device__r.Opportunity_Program__c + '' + opshare.userorgroupid)){
                    mOpptyPrgmAndUserId2opshares.get(opshare.Parent.Device__r.Opportunity_Program__c + '' + opshare.userorgroupid).add(opshare);
                } else {
                    mOpptyPrgmAndUserId2opshares.put(opshare.Parent.Device__r.Opportunity_Program__c + '' + opshare.userorgroupid, new List<ASICS_Specification__Share>{opshare});
                }
            }
        }
        
                                             
        for(Opportunity_Program_Team_Member__c optm: sOPTM){
            //only process the records that are not flagged for delete and are not core members
            Id oppPrgmId = optm.Opportunity_Program__c;
            Id userId = optm.User__c;
            if(mOpptyPrgmAndUserId2opshares.containskey(oppPrgmId + '' + userId)){
                List<ASICS_Specification__Share> opshares = mOpptyPrgmAndUserId2opshares.get(oppPrgmId + '' + userId);
                Set<Id> sDevId = new Set<Id>();
                if(mOpptyPrgmId2packs.containsKey(optm.Opportunity_Program__c)){
                    sDevId = new Set<Id>(mOpptyPrgmId2packs.get(optm.Opportunity_Program__c));
                }
                
                for(ASICS_Specification__Share devShr : opshares){
                    devShr.AccessLevel = RECORD_ACCESS.get(optm.device_Access__c);
                    sDevId.remove(devShr.parentId);
                    upsertasicShares.add(devShr);
                }
                
                if(sDevId.size() > 0){
                   List<ASICS_Specification__Share> newopshares = createasicShare(optm, new List<Id>(sDevId));
                   upsertasicShares.addall(newopshares);
                }
                
            } else if(mOpptyPrgmId2packs.containskey(optm.Opportunity_Program__c)){
                List<ASICS_Specification__Share> newopshares = createasicShare(optm, mOpptyPrgmId2packs.get(optm.Opportunity_Program__c));
                upsertasicShares.addall(newopshares);
            }
        }
        try {
            if(upsertasicShares.size()>0){
                upsert upsertasicShares;
            }
        } catch (Exception e) {
            GlobalUtility.logMessage('Error','ASICSSpecificationsTriggerHelper','updateasickShare','','Exception while updating ASICS Specifications Data Share record',String.valueof(e.getMessage()),'','ASICS Specifications Share',e,0);
        }
    }

    //method to delete ASICS Specifications share records when Oppty Program Team Member record is deleted
    public static voId deleteasicShare(Set<Id> opptyIDs, Set<Id> userIDs){
        List<ASICS_Specification__Share> asicList = [select Id from ASICS_Specification__Share
                                      where ParentId in (select Id from ASICS_Specification__c where Device__r.Opportunity_Program__c=:opptyIDs)
                                      and UserOrGroupId=:userIDs
                                      and RowCause=:OPPTY_PROGRAM_SHARE];
        
        try {
            if(asicList!=null && asicList.size()>0){
                delete asicList;
            }
        } catch (Exception e) {
            GlobalUtility.logMessage('Error','ASICSSpecificationsTriggerHelper','deleteasicShare','','Exception while deleting ASICS Specifications Data Share record',String.valueof(e.getMessage()),'','ASICS Specifications Share',e,0);
        }
    }
    
   @testvisible private static Map<String, String> asicshareRecords(Set<Id> setOppProgIDs){
            Map<String, String> asicshares = new Map<String, String>(); 
            List<ASICS_Specification__c> asicList = [select id, Device__r.Opportunity_Program__c from ASICS_Specification__c where Device__r.Opportunity_Program__c=:setOppProgIDs];
            
            if(asicList != null && asicList.size()>0){
                for(ASICS_Specification__c dev: asicList){
                    asicshares.put(dev.id, dev.Device__r.Opportunity_Program__c);
                }
            }
            return asicshares;
      }
 
 /* ASICS Specifications Sharing End*/
}