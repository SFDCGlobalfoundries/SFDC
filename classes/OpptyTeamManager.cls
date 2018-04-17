/*
    Author: Anirban Roy/Nino Bustillos
    Description: This class manages the creation of Oppty Program and Device Share from 
                Oppty Program Team Member insert/update/delete and Device Insert.
    History:
        Nbustillos  03122013    - code creation.
        ARoy        03142013    - removed exception handling to the OppProgTeamMember trigger.
        Asolito     12092013    - code optimization. added user filter on the device__share query
        Tlai        13042014    - Changed code in the method updateOpptyProgramShare and updateDeviceShare
                                - Added new method createDeviceShare
        Tlai        23042013    - Changed logic of updateDeviceShare
*/
public class OpptyTeamManager {
    public static string OPPTY_PROGRAM_SHARE = EnvironmentVariable.get('OPP_PGM_TM_MEM_SR');
    public static map<string,string> RECORD_ACCESS = new map<string,string>{'Read/Write'=>'Edit','Read Only'=>'Read','Private'=>'None'}; 
    
    public static void deleteOpptyProgramShare(set<Id> opptyIDs, set<id> userIDs){
        List<Opportunity_Program__Share> opsList = [select id from Opportunity_Program__Share where 
                                                    ParentId=:opptyIDs and UserOrGroupId=:userIDs
                                                    and RowCause=:OPPTY_PROGRAM_SHARE];


        if(opsList!=null && opsList.size()>0){
            delete opsList;
        }

    }
    
    public static void deleteDeviceShare(set<Id> opptyIDs, set<id> userIDs){
        List<Device__Share> dsList = [select Id from Device__Share
                                      where ParentId in (select id from Device__c where Opportunity_Program__c=:opptyIDs)
                                      and UserOrGroupId=:userIDs
                                      and RowCause=:OPPTY_PROGRAM_SHARE];
        

        if(dsList!=null && dsList.size()>0){
            delete dsList;
        }

    }
    
    public static void updateOpptyProgramShare(set<Opportunity_Program_Team_Member__c> sOPTM ){
        set<id> sOpptyPrgmId = new set<id>();
        set<string> sUniqueId = new set<String>();
        set<id> sUserId = new set<id>();
        for(Opportunity_Program_Team_Member__c optm : sOPTM){
            sUniqueId.add(optm.Opportunity_Program__c + '' + optm.User__c);
            sOpptyPrgmId.add(optm.Opportunity_Program__c);
            sUserId.add(optm.User__c);
        }
        // variables
        map<string, Opportunity_Program__Share> mUniqId2OppProgShares = new map<string, Opportunity_Program__Share>();
        list<Opportunity_Program__Share> upsertOpptyPrgmShare = new list<Opportunity_Program__Share>();
         
        // Retrieve existing Oppty Program Shares
        List<Opportunity_Program__Share> opsList = [select AccessLevel, Id, IsDeleted, LastModifiedById,
                                                   LastModifiedDate, ParentId, RowCause, UserOrGroupId from Opportunity_Program__Share
                                                   where ParentId =:sOpptyPrgmId and RowCause=:OPPTY_PROGRAM_SHARE and UserOrGroupId =:sUserId];
        
        for(Opportunity_Program__Share oppShare:opsList){
            if(sUniqueId.contains(oppShare.ParentId+''+oppShare.UserOrGroupId)){
                mUniqId2OppProgShares.put(oppShare.ParentId+''+oppShare.UserOrGroupId,oppShare);
            }
        }
        
        // Iterate to all updated version Oppty Programs
        for(Opportunity_Program_Team_Member__c optm: sOPTM){
            
            if(mUniqId2OppProgShares.containsKey(optm.Opportunity_Program__c + '' + optm.User__c)){
                Opportunity_Program__Share ops = mUniqId2OppProgShares.get(optm.Opportunity_Program__c + '' + optm.User__c);
                ops.AccessLevel = RECORD_ACCESS.get(optm.Opportunity_Program_Access__c);
                upsertOpptyPrgmShare.add(ops);
            }else {
                upsertOpptyPrgmShare.add(new Opportunity_Program__Share(
                                                AccessLevel = RECORD_ACCESS.get(optm.Opportunity_Program_Access__c),
                                                ParentId = optm.Opportunity_Program__c,
                                                RowCause = OPPTY_PROGRAM_SHARE,
                                                UserOrGroupId = optm.User__c));
            }
        }
        
        if(upsertOpptyPrgmShare.size()>0){
            upsert upsertOpptyPrgmShare;
        }
    }
    
    public static void updateDeviceShare( set<Opportunity_Program_Team_Member__c> sOPTM){
        // declare variable
        map <id, list<id>> mOpptyPrgmId2Devices = new map <id, list<id>>();
        map <String, list<Device__Share>> mOpptyPrgmAndUserId2DevShares = new map<String, list<Device__Share>>();
        set<String> sUniqueId = new set<String>();
        set<id> sOpptyPrgmId = new set<id>();
        set<id> sUserId = new set<id>();
        list<Device__Share> upsertDeviceShares = new list<Device__Share>(); 
        
        for(Opportunity_Program_Team_Member__c optm :sOPTM){
            sOpptyPrgmId.add(optm.Opportunity_Program__c);
            sUserId.add(optm.user__c);
        }
        
        List<Device__c> devList = [select id,Opportunity_Program__c from device__c where Opportunity_Program__c=:sOpptyPrgmId];
        map<id, list<id>> mOpptyPrgmId2DevIds = new map<id, list<Id>>();
        for(Device__c dev : devList) {
            if(mOpptyPrgmId2Devices.containskey(dev.Opportunity_Program__c)){
                mOpptyPrgmId2Devices.get(dev.Opportunity_Program__c).add(dev.id);
            }else {
                mOpptyPrgmId2Devices.put(dev.Opportunity_Program__c, new list<id>{dev.id});
            }
            for(Opportunity_Program_Team_Member__c optm :sOPTM){
                sUniqueId.add(dev.Opportunity_Program__c + ''+ dev.id + '' + optm.user__c);
            }
            
        }
        
        List<Device__Share> devShareList = [select AccessLevel,Id, IsDeleted, LastModifiedById, LastModifiedDate,
                                      ParentId, RowCause, UserOrGroupId , Parent.Opportunity_Program__c from Device__Share
                                      where ParentId in (select id from Device__c where Opportunity_Program__c=:sOpptyPrgmId)
                                      and RowCause=:OPPTY_PROGRAM_SHARE
                                      and userOrGroupId =:sUserId];
                                      
        for(Device__Share devShare : devShareList){
            if(sUniqueId.contains(devShare.Parent.Opportunity_Program__c + '' + devShare.parentid + '' + devShare.userorgroupid)){
                if(mOpptyPrgmAndUserId2DevShares.containskey(devShare.Parent.Opportunity_Program__c + '' + devShare.userorgroupid)){
                    mOpptyPrgmAndUserId2DevShares.get(devShare.Parent.Opportunity_Program__c + '' + devShare.userorgroupid).add(devShare);
                }else {
                    mOpptyPrgmAndUserId2DevShares.put(devShare.Parent.Opportunity_Program__c + '' + devShare.userorgroupid, new list<Device__Share>{devShare});
                }
            }
        }
        
                                             
        for(Opportunity_Program_Team_Member__c optm: sOPTM){
            //only process the records that are not flagged for delete and are not core members
            id oppPrgmId = optm.Opportunity_Program__c;
            id userID = optm.User__c;
            if(mOpptyPrgmAndUserId2DevShares.containskey(oppPrgmID + '' + userId)){
                list<Device__Share> devShares = mOpptyPrgmAndUserId2DevShares.get(oppPrgmID + '' + userId);
                set<id> sDevId = new set<id>();
                if(mOpptyPrgmId2Devices.containsKey(optm.Opportunity_Program__c)){
                    sDevId = new Set<id>(mOpptyPrgmId2Devices.get(optm.Opportunity_Program__c));
                }
                
                for(Device__Share devShr : devShares){
                    devShr.AccessLevel = RECORD_ACCESS.get(optm.Device_Access__c);
                    sDevId.remove(devShr.parentId);
                    upsertDeviceShares.add(devShr);
                }
                
                if(sDevId.size() > 0){
                    list<Device__Share> newDevShares = createDeviceShare(optm, new list<id>(sDevId));
                    upsertDeviceShares.addall(newDevShares);
                }
                
            }else if(mOpptyPrgmId2Devices.containskey(optm.Opportunity_Program__c)){//Tlai 23042013 - added condition to skip cases that device is not exsiting
                list<Device__Share> newDevShares = createDeviceShare(optm, mOpptyPrgmId2Devices.get(optm.Opportunity_Program__c));
                upsertDeviceShares.addall(newDevShares);
            }
        }
        
        if(upsertDeviceShares.size()>0){
            system.debug(upsertDeviceShares);
            upsert upsertDeviceShares;
        }
    }
    
    private static list<Device__Share> createDeviceShare(Opportunity_Program_Team_Member__c optm, list<id> deviceIds){
        list<Device__Share> lDevShr = new list<Device__Share>();
        for(Id devId: deviceIds){
            Device__Share newDS = new Device__Share();
            newDS.AccessLevel = RECORD_ACCESS.get(optm.Device_Access__c);
            newDS.RowCause = OPPTY_PROGRAM_SHARE;
            newDS.ParentId = devId;
            newDS.UserOrGroupId = optm.User__c;
            lDevShr.add(newDS);
        }
        
        return lDevShr;
    }
    
    public static set<Id> insertOpptyProgramShare(map<id,Opportunity_Program_Team_Member__c> mapNewOpptyProgramTeamMember, set<id> activeUserIDs){
        // declare variable
        set <Id> setOppProgIDs = new set <Id>();
        list <Opportunity_Program__Share> insertOppProgShare = new list <Opportunity_Program__Share>();
        
        for(Opportunity_Program_Team_Member__c optm: mapNewOpptyProgramTeamMember.values()){
            
            //only process the records that are not flagged for delete and are not core members
            if (!optm.Flag_for_Delete__c && activeUserIDs.contains(optm.User__c)){                    
                Opportunity_Program__Share oppShare = new Opportunity_Program__Share();
                oppShare.AccessLevel = RECORD_ACCESS.get(optm.Opportunity_Program_Access__c);
                oppShare.ParentId = optm.Opportunity_Program__c;
                oppShare.RowCause = OPPTY_PROGRAM_SHARE;
                oppShare.UserOrGroupId = optm.User__c;
                insertOppProgShare.add(oppShare);
                setOppProgIDs.add(optm.Opportunity_Program__c);                 
            }
                
        }           

        if(insertOppProgShare!=null && insertOppProgShare.size()>0){
            insert insertOppProgShare;
        }

        return setOppProgIDs;                                   
    }
    
    public static void insertDeviceShare(set<Id> opptyIDs, map<id,Opportunity_Program_Team_Member__c> mapNewOpptyProgramTeamMember, set<id> activeUserIDs){
         
         // declare variable
         map <string, list<Device__Share>> mapOppProgShares = new map <string, list<Device__Share>>();
         //map <string,string> oppDevShares = devShareRecords(opptyIDs);  
         list <Device__Share> insertDeviceShare = new list <Device__Share>();
         list<Device__Share> devList = new list<Device__Share>();
         

         for(Device__c device:[select id,Opportunity_Program__c from Device__c where Opportunity_Program__c IN :opptyIDs order by Opportunity_Program__c]){
            Device__Share newDS = new Device__Share();
            newDS.RowCause = OPPTY_PROGRAM_SHARE;
            newDS.ParentId = device.id;
            //string oppProgID = oppDevShares.get(device.id);
            List<Device__Share> devicesForKey = mapOppProgShares.get(device.Opportunity_Program__c);
            if (devicesForKey == null) {
                devicesForKey = new list<Device__Share>();
                devicesForKey.add(newDS);

                mapOppProgShares.put(device.Opportunity_Program__c, devicesForKey);
            }else{
                 devicesForKey.add(newDS);
                mapOppProgShares.put(device.Opportunity_Program__c, devicesForKey);

            }
        }
        
           
        
        for(Opportunity_Program_Team_Member__c optm: mapNewOpptyProgramTeamMember.values()){
            //only process the records that are not flagged for delete and are not core members
            if (!optm.Flag_for_Delete__c && activeUserIDs.contains(optm.User__c)){
                string oppProgID = optm.Opportunity_Program__c;
                //string UserID = optm.User__c;
                list<Device__Share> dsList = mapOppProgShares.get(oppProgID);
                if(dsList!=null && dsList.size()>0){
                    for(Device__Share ds:dsList){
                        Device__Share ds1 = ds.clone();
                        if(ds1!=null){
                            ds1.AccessLevel = RECORD_ACCESS.get(optm.Device_Access__c);
                            ds1.UserOrGroupId = optm.User__c;
                            insertDeviceShare.add(ds1);
                        }
                    }
                }                   
            }
        }
        system.debug('@@@@@@@@insertDeviceShare'+insertDeviceShare);

        if(insertDeviceShare!=null && insertDeviceShare.size()>0){
            insert insertDeviceShare;
        }
                               
    }
    
    public static void insertDeviceShare(map<Id,Device__c> mapNewDevices){
        map<id,list<Opportunity_Program_Team_Member__c>> mapOpptyProgTeamMembers = new map<id,list<Opportunity_Program_Team_Member__c>>();
        set<id> opptyIDs = new set<id>();
        set<id> userIDs = new set<id>();
        set<id> activeUserIDs = new set<id>();
        
        for(Device__c oDevice : mapNewDevices.values()){
            opptyIDs.add(oDevice.Opportunity_Program__c);
        }
        system.debug('opptyIDs : ' + opptyIDs);
        
        // retrieve all program team members for each Opportunity Program
        for(Opportunity_Program__c oProgram : [select id, (select id, Device_Access__c, User__c, User__r.IsActive, Flag_for_Delete__c from Opportunity_Program_Team_Members__r) 
                                              from Opportunity_Program__c where id in :opptyIDs]){
            
            // save program team members based on Opportunity Program
            for(Opportunity_Program_Team_Member__c oProgramTeamMember : oProgram.Opportunity_Program_Team_Members__r){
                userIDs.add(oProgramTeamMember.User__c);
                
                // check if member is not flag for delete and user is active.
                if(!oProgramTeamMember.Flag_for_Delete__c && oProgramTeamMember.User__r.IsActive){
                    if(mapOpptyProgTeamMembers.containsKey(oProgram.Id)){
                        list<Opportunity_Program_Team_Member__c> lstProgTeamMembers = mapOpptyProgTeamMembers.get(oProgram.Id);
                        lstProgTeamMembers.add(oProgramTeamMember);
                        mapOpptyProgTeamMembers.put(oProgram.id,lstProgTeamMembers);
                    }else{
                        mapOpptyProgTeamMembers.put(oProgram.id,new list<Opportunity_Program_Team_Member__c>{oProgramTeamMember});
                    }
                }
            }
        }
        
        // iterate to all new device records
        list<Device__Share> lstNewDeviceShare = new list<Device__Share>();
        for(Device__c oDevice : mapNewDevices.values()){
            // Check if there are team members
            if(mapOpptyProgTeamMembers.containsKey(oDevice.Opportunity_Program__c)){
                for(Opportunity_Program_Team_Member__c oTeamMember : mapOpptyProgTeamMembers.get(oDevice.Opportunity_Program__c)){
                    Device__Share newDS = new Device__Share();
                    newDS.RowCause = OPPTY_PROGRAM_SHARE;
                    newDS.ParentId = oDevice.id;
                    newDS.AccessLevel = RECORD_ACCESS.get(oTeamMember.Device_Access__c);
                    newDS.UserOrGroupId = oTeamMember.User__c;
                    lstNewDeviceShare.add(newDS);
                }
            }
        }
        
        // create sharing records
        if(lstNewDeviceShare.size()>0){
            insert lstNewDeviceShare;
        }
    }
    
    private static map<string,string> devShareRecords(set<Id> setOppProgIDs){
            map <string,string> oppDevShares = new map <string,string>(); 
            List<Device__c> devList = [select id,Opportunity_Program__c from Device__c where Opportunity_Program__c=:setOppProgIDs];
            
            if(devList!=null && devList.size()>0){
                for(Device__c dev:devList){
                    oppDevShares.put(dev.id,dev.Opportunity_Program__c);
                }
            }
            return oppDevShares;
      }  
}