/**
@Author < Meghna Ganguly >
@name < PackageDataTriggerHelper>
@CreateDate < 12/15/2016 >
@Description < This class manages the creation of Package Share from 
                Oppty Program Team Member insert/update/delete and Package Insert.>
@Version <1.0>
*/
public class PackageDataTriggerHelper {

    public static String OPPTY_PROGRAM_SHARE = EnvironmentVariable.get('OPP_PGM_TM_MEM_SR');
    public static Map<String,String> RECORD_ACCESS = new Map<String,String>{'Read/Write'=>'Edit','Read Only'=>'Read','Private'=>'None'}; 
   
    /* Package Sharing Start*/
    /*@testvisible private static List<Package_Data__Share> createpackShare(Opportunity_Program_Team_Member__c optm, List<Id> packIds){
        List<Package_Data__Share> lpacShr = new List<Package_Data__Share>();
        for(Id devId :packIds){
            Package_Data__Share newDS = new Package_Data__Share();
            newDS.AccessLevel = RECORD_ACCESS.get(optm.device_Access__c);
            newDS.RowCause = OPPTY_PROGRAM_SHARE;
            newDS.ParentId = devId;
            newDS.UserOrGroupId = optm.User__c;
            lpacShr.add(newDS);
        }
        return lpacShr;
    }*/
    
    // method to insert package share records when Oppty Program Team Member record is created
    /*public static voId insertpackShare(Set<Id> opptyIDs, Map<Id, Opportunity_Program_Team_Member__c> mapNewOpptyProgramTeamMember, Set<Id> activeUserIDs){
         
         // declare variable
         Map<String, List<Package_Data__Share>> mapOppProgShares = new Map<String, List<Package_Data__Share>>();
         List<Package_Data__Share> insertpackShare = new List<Package_Data__Share>();
         List<Package_Data__Share> pcList = new List<Package_Data__Share>();
         

         for(Package_Data__c pack:[select id, Technical_Requirement__r.Device__r.Opportunity_Program__c from Package_Data__c where Technical_Requirement__r.Device__r.Opportunity_Program__c IN :opptyIDs order by Technical_Requirement__r.Device__r.Opportunity_Program__c]){
            Package_Data__Share newDS = new Package_Data__Share();
            newDS.RowCause = OPPTY_PROGRAM_SHARE;
            newDS.ParentId = pack.id;
            
            List<Package_Data__Share> packsForKey = mapOppProgShares.get(pack.Technical_Requirement__r.Device__r.Opportunity_Program__c);
            if (packsForKey == null) {
                packsForKey = new List<Package_Data__Share>();
                packsForKey.add(newDS);

                mapOppProgShares.put(pack.Technical_Requirement__r.Device__r.Opportunity_Program__c, packsForKey);
            } else{
                 packsForKey.add(newDS);
                mapOppProgShares.put(pack.Technical_Requirement__r.Device__r.Opportunity_Program__c, packsForKey);

            }
        }
        
        for(Opportunity_Program_Team_Member__c optm: mapNewOpptyProgramTeamMember.values()){
            //only process the records that are not flagged for delete and are not core members
            if (!optm.Flag_for_Delete__c && activeUserIDs.contains(optm.User__c)){
                String oppProgId = optm.Opportunity_Program__c;
                //String UserId = optm.User__c;
                List<Package_Data__Share> dsList = mapOppProgShares.get(oppProgID);
                if(dsList!=null && dsList.size()>0){
                    for(Package_Data__Share ds:dsList){
                        Package_Data__Share ds1 = ds.clone();
                        if(ds1!=null){
                            ds1.AccessLevel = RECORD_ACCESS.get(optm.device_Access__c);
                            ds1.UserOrGroupId = optm.User__c;
                            insertpackShare.add(ds1);
                        }
                    }
                }                   
            }
        }
        try {
            if(insertpackShare!=null && insertpackShare.size()>0){
                insert insertpackShare;
            }
        } catch (Exception e) {
            GlobalUtility.logMessage('Error','PackageDataTriggerHelper','insertpackShare','','Exception while creating Package Data share record',String.valueof(e.getMessage()),'','Package Share',e,0);
        }                       
    }*/
     
    /*public voId insertpackdataShare(){ 
        insertpackageShare(trigger.newMap.keySet());
    }*/
    
   // method to insert package share records when package record is created
   /*public static voId insertpackageShare(Set<Id> NewpacksIds){
        Map<Id, List<Opportunity_Program_Team_Member__c>> mapOpptyProgTeamMembers = new Map<Id, List<Opportunity_Program_Team_Member__c>>();
        Set<Id> opptyIDs = new Set<Id>();
        Set<Id> userIDs = new Set<Id>();
        Set<Id> activeUserIDs = new Set<Id>();
        
        List<Package_Data__c> packList = [select Technical_Requirement__r.Device__r.Opportunity_Program__c from Package_Data__c
                                where Id in :newpacksIds];
        for(Package_Data__c opack : packList){
            opptyIDs.add(opack.Technical_Requirement__r.Device__r.Opportunity_Program__c);
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
        
        // iterate to all new pack records
        List<Package_Data__Share> lstNewpackShare = new List<Package_Data__Share>();
        for(Package_Data__c opack : packList){
            // Check if there are team members
            if(mapOpptyProgTeamMembers.containsKey(opack.Technical_Requirement__r.Device__r.Opportunity_Program__c)){
                for(Opportunity_Program_Team_Member__c oTeamMember : mapOpptyProgTeamMembers.get(opack.Technical_Requirement__r.Device__r.Opportunity_Program__c)){
                    Package_Data__Share newDS = new Package_Data__Share();
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
            GlobalUtility.logMessage('Error','PackageDataTriggerHelper','insertpackageShare','','Exception while creating Package Data Share record',String.valueof(e.getMessage()),'','Package Share',e,0);
        }
    }*/
     
    //method to update package share records when Oppty Program Team Member record is updated
    /*public static voId updatepackShare( Set<Opportunity_Program_Team_Member__c> sOPTM){
        // declare variable
        Map<Id, List<Id>> mOpptyPrgmId2packs = new Map<Id, List<Id>>();
        Map<String, List<Package_Data__Share>> mOpptyPrgmAndUserId2opshares = new Map<String, List<Package_Data__Share>>();
        Set<String> sUniqueId = new Set<String>();
        Set<Id> sOpptyPrgmId = new Set<Id>();
        Set<Id> sUserId = new Set<Id>();
        List<Package_Data__Share> upsertpackShares = new List<Package_Data__Share>(); 
        
        for(Opportunity_Program_Team_Member__c optm :sOPTM){
            sOpptyPrgmId.add(optm.Opportunity_Program__c);
            sUserId.add(optm.user__c);
        }
        
        List<Package_Data__c> pcList = [select id,Technical_Requirement__r.Device__r.Opportunity_Program__c from Package_Data__c where Technical_Requirement__r.Device__r.Opportunity_Program__c=:sOpptyPrgmId];
        Map<Id, List<Id>> mOpptyPrgmId2DevIds = new Map<Id, List<Id>>();
        for(Package_Data__c dev : pcList) {
            if(mOpptyPrgmId2packs.containskey(dev.Technical_Requirement__r.Device__r.Opportunity_Program__c)){
                mOpptyPrgmId2packs.get(dev.Technical_Requirement__r.Device__r.Opportunity_Program__c).add(dev.id);
            } else {
                mOpptyPrgmId2packs.put(dev.Technical_Requirement__r.Device__r.Opportunity_Program__c, new List<Id>{dev.id});
            }
            for(Opportunity_Program_Team_Member__c optm :sOPTM){
                sUniqueId.add(dev.Technical_Requirement__r.Device__r.Opportunity_Program__c + ''+ dev.Id + '' + optm.user__c);
            }
            
        }
        
        List<Package_Data__Share> opshareList = [select AccessLevel,Id, IsDeleted, LastModifiedById, LastModifiedDate,
                                      ParentId, RowCause, UserOrGroupId , Parent.Technical_Requirement__r.Device__r.Opportunity_Program__c from Package_Data__Share
                                      where ParentId in (select Id from Package_Data__c where Technical_Requirement__r.Device__r.Opportunity_Program__c=:sOpptyPrgmId)
                                      and RowCause=:OPPTY_PROGRAM_SHARE
                                      and userOrGroupId =:sUserId];
                                      
        for(Package_Data__Share opshare : opshareList){
            if(sUniqueId.contains(opshare.Parent.Technical_Requirement__r.Device__r.Opportunity_Program__c + '' + opshare.parentId + '' + opshare.userorgroupid)){
                if(mOpptyPrgmAndUserId2opshares.containskey(opshare.Parent.Technical_Requirement__r.Device__r.Opportunity_Program__c + '' + opshare.userorgroupid)){
                    mOpptyPrgmAndUserId2opshares.get(opshare.Parent.Technical_Requirement__r.Device__r.Opportunity_Program__c + '' + opshare.userorgroupid).add(opshare);
                } else {
                    mOpptyPrgmAndUserId2opshares.put(opshare.Parent.Technical_Requirement__r.Device__r.Opportunity_Program__c + '' + opshare.userorgroupid, new List<Package_Data__Share>{opshare});
                }
            }
        }
        
                                             
        for(Opportunity_Program_Team_Member__c optm: sOPTM){
            //only process the records that are not flagged for delete and are not core members
            Id oppPrgmId = optm.Opportunity_Program__c;
            Id userId = optm.User__c;
            if(mOpptyPrgmAndUserId2opshares.containskey(oppPrgmId + '' + userId)){
                List<Package_Data__Share> opshares = mOpptyPrgmAndUserId2opshares.get(oppPrgmId + '' + userId);
                Set<Id> sDevId = new Set<Id>();
                if(mOpptyPrgmId2packs.containsKey(optm.Opportunity_Program__c)){
                    sDevId = new Set<Id>(mOpptyPrgmId2packs.get(optm.Opportunity_Program__c));
                }
                
                for(Package_Data__Share devShr : opshares){
                    devShr.AccessLevel = RECORD_ACCESS.get(optm.device_Access__c);
                    sDevId.remove(devShr.parentId);
                    upsertpackShares.add(devShr);
                }
                
                if(sDevId.size() > 0){
                   List<Package_Data__Share> newopshares = createpackShare(optm, new List<Id>(sDevId));
                   upsertpackShares.addall(newopshares);
                }
                
            } else if(mOpptyPrgmId2packs.containskey(optm.Opportunity_Program__c)){
                List<Package_Data__Share> newopshares = createpackShare(optm, mOpptyPrgmId2packs.get(optm.Opportunity_Program__c));
                upsertpackShares.addall(newopshares);
            }
        }
        try {
            if(upsertpackShares.size()>0){
                upsert upsertpackShares;
            }
        } catch (Exception e) {
            GlobalUtility.logMessage('Error','PackageDataTriggerHelper','updatepackShare','','Exception while updating Package Data Share record',String.valueof(e.getMessage()),'','Package Share',e,0);
        }
    }*/

    //method to delete package share records when Oppty Program Team Member record is deleted
    /*public static voId deletepackShare(Set<Id> opptyIDs, Set<Id> userIDs){
        List<Package_Data__Share> pcList = [select Id from Package_Data__Share
                                      where ParentId in (select Id from Package_Data__c where Technical_Requirement__r.Device__r.Opportunity_Program__c=:opptyIDs)
                                      and UserOrGroupId=:userIDs
                                      and RowCause=:OPPTY_PROGRAM_SHARE];
        
        try {
            if(pcList!=null && pcList.size()>0){
                delete pcList;
            }
        } catch (Exception e) {
            GlobalUtility.logMessage('Error','PackageDataTriggerHelper','deletepackShare','','Exception while deleting Package Data Share record',String.valueof(e.getMessage()),'','Package Share',e,0);
        }
    }*/
    
   /*@testvisible private static Map<String, String> pcshareRecords(Set<Id> setOppProgIDs){
            Map<String, String> pcshares = new Map<String, String>(); 
            List<Package_Data__c> pcList = [select id, Technical_Requirement__r.Device__r.Opportunity_Program__c from Package_Data__c where Technical_Requirement__r.Device__r.Opportunity_Program__c=:setOppProgIDs];
            
            if(pcList != null && pcList.size()>0){
                for(Package_Data__c dev: pcList){
                    pcshares.put(dev.id, dev.Technical_Requirement__r.Device__r.Opportunity_Program__c);
                }
            }
            return pcshares;
      }*/
 
 /* Package Sharing End*/
}