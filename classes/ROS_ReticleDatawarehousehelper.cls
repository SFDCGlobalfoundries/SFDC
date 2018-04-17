/**
* @author       :   Ankit Singhal
* Company       :   Cognizant Technologies PTE Ltd.
* Description   :   Functionality to change Reticle Obsolescence from Customer Portal                  
* History       :

        Initials        Date                Description
-----------------------------------------------------------------------------------------
        ASinghal        26/06/2013          Created the Class
        Sameer Matale   2/26/2014           Modified to fix bug - Exception 'Fab reticle already exists'
        NJain           20/3/2014           Added new method RemoveSharingRecordsFabUsersNew
                                            Removed unwanted code
**/
public class ROS_ReticleDatawarehousehelper {

    /*---------------------------------------------------------------------------------------
    Method to create Fab Reticle records based on fab field in Reticle datawarehouse records
    -----------------------------------------------------------------------------------------*/
    public static void createfabreticles(Map<Id,Set<String>> MInsertReticles){
        Map<String,String> Fabmap=new Map<String,String> {};
        List<Fab_Reticle__c> Fabreticleinsert=new List<Fab_Reticle__c>();
    
        List<fab__c> fabmasterlist=new List<fab__c>([Select Id,name from fab__c]);
        Map<String,String> fabmastermap=new Map<String,String>{};
    
        for(Fab__c f:fabmasterlist)
            fabmastermap.put(f.name,f.id);
        
        System.debug('>>>>>>'+MInsertReticles);
        
        if(MInsertReticles!=null && MInsertReticles.size()>0) {
            for(Id r: MInsertReticles.keyset()) {
                for(String fab : MInsertReticles.get(r)){
                    if(fabmastermap.get(fab.toUpperCase())!=null) {
                        Fab_Reticle__c tempfabret=new Fab_Reticle__c(fab__c=fabmastermap.get(fab.toUpperCase()),reticle__c=r);
                        Fabreticleinsert.add(tempfabret);
                    }
                }
            }
        }

        if(!Fabreticleinsert.isempty()) {
            Database.SaveResult[] srList = Database.insert(Fabreticleinsert, false);
            
            //Nikhil-- commenting unwanted code block
            /*
            // Iterate through each returned result
            for (Database.SaveResult sr : srList) {
                if (!sr.isSuccess()) {
                    for(Database.Error err : sr.getErrors()) {
                        System.debug('The following error has occurred.');
                        System.debug(err.getStatusCode() + ': ' + err.getMessage());
                        System.debug('Fab reticle fields that affected this error: ' + err.getFields());
                    }
                }
            }
            */
        }
    }

    /* Method to create Device Reticle records based on GF Id in Reticle datawarehouse records */
    public static void createdevicereticles(Map<Id,Set<String>> MNewDeviceReticles,Map<String,Device__c> MDeviceNames){
        List<Reticle_Device__c> Lreticledevice=new list<Reticle_Device__c>();
        for(Id temp : MNewDeviceReticles.keyset()) {
            for(String device : MNewDeviceReticles.get(temp)){
            List<String> LeachConcatenatedGFCRMId=new List<String>(device.split(','));
                if(MDeviceNames.get(LeachConcatenatedGFCRMId[0])!=null){
                    Reticle_Device__c rd=new Reticle_Device__c(GF_Device_Id__c=LeachConcatenatedGFCRMId[0],Global_foundries_device_Id__c=LeachConcatenatedGFCRMId[0],reticle__c=temp,Device__c=MDeviceNames.get(LeachConcatenatedGFCRMId[0]).id,CRM_Device_ID__c=LeachConcatenatedGFCRMId[1]); 
                    Lreticledevice.add(rd);
                } else if (MDeviceNames.get(LeachConcatenatedGFCRMId[0]) == null) {
                    Reticle_Device__c rd=new Reticle_Device__c(reticle__c=temp, CRM_Device_ID__c=LeachConcatenatedGFCRMId[1], GF_Device_Id__c=LeachConcatenatedGFCRMId[0], Global_foundries_device_Id__c = LeachConcatenatedGFCRMId[0]); 
                    Lreticledevice.add(rd);
                }
            }
        }

        if(!Lreticledevice.isempty()) {
            Database.SaveResult[] srList = Database.insert(Lreticledevice, false);
            
            //Nikhil-- commenting unwanted code block
            /*
            // Iterate through each returned result
            for (Database.SaveResult sr : srList) {
                if (!sr.isSuccess()) {
                    for(Database.Error err : sr.getErrors()) {
                        System.debug('The following error has occurred.');
                        System.debug(err.getStatusCode() + ': ' + err.getMessage());
                        System.debug('Device reticle fields that affected this error: ' + err.getFields());
                    }
                }
            }
            */
        }
    }

    /* Method to retreive ReticleId,Customer Portal Users corresponding to ReticleId,Contacts Map. */
    public static Map<Id,Set<Id>> createMapIdPortalUsers(Map<Id,List<Contact>> MIdContacts){
    
        Set<Id> SAllConIds=new Set<Id>(); 
        Map<Id,Set<Id>> MRetIdUserIds = new Map<Id,Set<Id>>(); 
        Map<Id,Set<Id>> MRetIdConIds=new Map<Id,Set<Id>>();
        
        for(Id eachretId : MIdContacts.keyset()){
            Set<Id> SConIds=new Set<Id>();           
            for(Contact eachContact : MIdContacts.get(eachretId)){
                SConIds.add(eachContact.id);
                //Nikhil -- moving below out of the loop
                //SAllConIds.add(eachContact.id);
            }
            SAllConIds.addAll(SConIds);
            
            MRetIdConIds.put(eachretId,SConIds);
        }
        
        List<User> lAllUsers = [ SELECT Id, ContactId FROM User WHERE ContactId IN :SAllConIds]; 

        for(Id RetId : MIdContacts.keyset()){    
            Set<Id> SUsers=new Set<Id>();
            for(User u : LAllUsers){        
                if(MRetIdConIds.get(RetId).contains(u.ContactId))
                    SUsers.add(u.id);
            }            
            MRetIdUserIds.put(RetId,SUsers);       
        }    
        //system.debug(']]]]]]]]]]]'+MRetIdUserIds);
        return MRetIdUserIds;
    }
    
    /*
    Method to Share records with CSR Of Accounts
    */
    public static Set<Reticle__Share> SharingRecordswithCSRs_1(ID retcileID, Set<Id> userIdSet,String Acesslevel,String rowCause){
        Set<Reticle__Share> LReticleshare=new Set<Reticle__Share>();
        
        for(ID Ids : userIdSet){
            Reticle__Share Retshare    = new Reticle__Share();
            Retshare.ParentId          = retcileID;
            Retshare.UserOrGroupId     = Ids;
            Retshare.AccessLevel       = Acesslevel;
            Retshare.RowCause          = rowCause;//Schema.Reticle__Share.RowCause.Sharing_with_CSR__c;
            LReticleshare.add(Retshare);
        }
        return LReticleshare;
    }
   //Commented for Fab-User sharing logic change through Sharing Rule
   /*
   public static Set<Reticle__Share> SharingRecordswithFabUser(Id recId, Map<Id,List<Id>> Fabs,List<Fab_User__c> fabUsers,String AccessLevel,String rowCause){
      
       SET<Id> FabUsersSet = new Set<ID>();
       Set<Reticle__Share> LReticleshare=new Set<Reticle__Share>();
       for(ID fabId : Fabs.get(recId)){
           for(Fab_User__c users : fabUsers){
               if(users.Fab__c == fabId){
                    Reticle__Share Retshare=new Reticle__Share();
                    Retshare.ParentId=recId;
                     if(users.Fab__c == fabId){
                      //FabUsersSet.add(users.User__c); 
                       Retshare.UserOrGroupId = users.User__c;
                     }
                   
                    Retshare.AccessLevel=AccessLevel;
                    Retshare.RowCause = rowCause;//Schema.Reticle__Share.RowCause.Sharing_with_Fab_Users_after_Obselescenc__c;
                    LReticleshare.add(Retshare); 
               }
           }
       }
       return LReticleshare;
                
    }*/
   
    public static List<Reticle__Share> RemoveSharingRecords(ID reticleID, Set<Id> userIdSet,List<Reticle__Share> LAllReticleShared){
        List<Reticle__Share> LReticleshare=new List<Reticle__Share>();
        for(Reticle__Share Ret : LAllReticleShared){
            //Nikhil-- Correcting the ReticleId compare with parentId of Sharing record instead of Record Id itself.
            //if(userIdSet.contains(Ret.UserorGroupId) && (Ret.Id==reticleID)){
            if(userIdSet.contains(Ret.UserorGroupId) && (Ret.ParentId==reticleID)){
                LReticleshare.add(Ret);  
            }   
        }
        /*List<Reticle__Share> LReticleshare=new List<Reticle__Share>([Select Id from Reticle__Share where UserOrGroupId in : userIdSet
                                                                       and ParentId =: reticleID]); */
        return LReticleshare;
    }
    
    //Commented for Fab-User sharing logic change through Sharing Rule
    /*
    public static List<Reticle__Share> RemoveSharingRecordsFabUsers(Id recId, Map<Id,List<Id>> Fabs,List<Fab_User__c> fabUsers,List<Reticle__Share> LAllReticleShared ){
       
       SET<Id> FabUsersSet = new Set<ID>();
       for(ID fabId : Fabs.get(recId)){
           for(Fab_User__c users : fabUsers){
               if(users.Fab__c == fabId){
                  FabUsersSet.add(users.User__c); 
               }
           }
       }
       List<Reticle__Share> LReticleshare = RemoveSharingRecords(recId,FabUsersSet,LAllReticleShared);
       return LReticleshare;
    }*/
    
    //Commented for Fab-User sharing logic change through Sharing Rule
    /*
    public static Set<Id> RemoveSharingRecordsFabUsersNew(Id recId, Map<Id,List<Id>> Fabs,List<Fab_User__c> fabUsers,List<Reticle__Share> LAllReticleShared ){
       
       SET<Id> FabUsersSet = new Set<ID>();
       for(ID fabId : Fabs.get(recId)){
           for(Fab_User__c users : fabUsers){
               if(users.Fab__c == fabId){
                  FabUsersSet.add(users.User__c); 
               }
           }
       }
       //List<Reticle__Share> LReticleshare = RemoveSharingRecords(recId,FabUsersSet,LAllReticleShared);
       //return LReticleshare;
       return FabUsersSet;
    }*/ 
   
    public static void SharingRecordswithCSRs(Map<Id,List<Account_Team_Proxy__c>> MRetIdATPProxyMap){
        List<Reticle__Share> LReticleshare=new List<Reticle__Share>();
        for(Id RetId : MRetIdATPProxyMap.keyset()){
            for(Account_Team_Proxy__c tempATP : MRetIdATPProxyMap.get(RetId)){
                Reticle__Share Retshare=new Reticle__Share();
                Retshare.ParentId=RetId;
                Retshare.UserOrGroupId=tempATP.User__c;
                Retshare.AccessLevel='edit';
                Retshare.RowCause = Schema.Reticle__Share.RowCause.Sharing_with_CSR__c;
                LReticleshare.add(Retshare);
            }
        }
        Database.SaveResult[] lsr = Database.insert(LReticleshare,false);
    }
   
   /*
   Method to Share records with Contacts Accounts after CSR has changed Reticle Workflow Status to 'Pending for Customer Feedback'
   */
   public static List<Reticle__Share> SharingRecordswithContacts(Map<Id, Set<Id>> MRetIdUserIds) {
       List<Reticle__Share> LReticleshare = new List<Reticle__Share>();   
   
       //Iterating each reticle for creating Sharing Record
       for(Id RetId : MRetIdUserIds.keyset()) {
            
            for(Id tempconid : MRetIdUserIds.get(RetId)){
                Reticle__Share Retshare=new Reticle__Share();
                Retshare.ParentId=RetId;
                Retshare.UserOrGroupId=tempconid;
                Retshare.AccessLevel='edit';
                Retshare.RowCause = Schema.Reticle__Share.RowCause.Sharing_Reticle_Contacts__c;
                LReticleshare.add(Retshare);
                }
           }
           // TODO: UNCOMMENT IF DEPENDENCY FOUND.
           // Database.SaveResult[] lsr = Database.insert(LReticleshare,false);
           
           return LReticleshare;
    }
    
    //Commented for Fab-User sharing logic change through Sharing Rule
    /* Sharing Records with FAB Users after Reticle is sent for Obselescence */
    /*public static void SharingRecordswithFabUsers(List<Reticle__c> LReticles){
        Set<String> SAllFabs = new Set<String>();
        Map<Id,Set<String>> MRetIdFabstr = new Map<Id,Set<String>>();
        Set<Id> SReticleIds = new Set<Id>();
        Map<Id,Set<Id>> MRetIdFabUsersId = new Map<Id,Set<Id>>();
        
        for(Reticle__c temp : LReticles){
            Set<String> SFabStrs = new Set<String>();
            Sfabstrs.addall(temp.Fabstr__c.split(','));
            SAllFabs.addall(Sfabstrs);
            MRetIdFabstr.put(temp.Id,SFabStrs);  
              
        }
            
        List<Fab__c> LFabtoFabUsers = new List<Fab__c>([Select Id,Name,(Select Id,Fab__c,User__c from Fab_User__r) from Fab__c where Name in :(SAllFabs)]);    
        List<Fab_User__c> LFabUsrs = new List<Fab_User__c>([Select Id,Name,User__c from Fab_User__c where Fab__r.Name in :(SAllFabs) and IsActive__c = true and Is_ROS_User__c =: true]);
        
        Map<Id,String> MFabUserIdFabName = new Map<Id,String>();
        
        for(Fab__c eachfab : LFabtoFabUsers ) {
            for(Fab_User__c eachFabUser : eachfab.Fab_User__r){
                MFabUserIdFabName.put(eachFabUser.Id,eachfab.Name); 
            }
        }  
            
        for(Id RetId : MRetIdFabstr.keyset()){
            Set<Id> SFabuserids = new Set<Id>();
            for(Fab_User__c temp : LFabUsrs ){
                if(MRetIdFabstr.get(RetId).contains(MFabUserIdFabName.get(temp.Id)))
                    SFabuserids.add(temp.User__c);
            }
            MRetIdFabUsersId.put(RetId,SFabuserids);
        }
         
        List<Reticle__Share> LReticleshare=new List<Reticle__Share>();  
        
        for(Id RetId : MRetIdFabUsersId.keyset()){                
            for(Id tempconid : MRetIdFabUsersId.get(RetId)){                
                Reticle__Share Retshare=new Reticle__Share();
                Retshare.ParentId=RetId;
                Retshare.UserOrGroupId=tempconid;
                Retshare.AccessLevel='edit';
                Retshare.RowCause = Schema.Reticle__Share.RowCause.Sharing_with_Fab_Users_after_Obselescenc__c;
                LReticleshare.add(Retshare);
            }
        }
        database.insert(LReticleshare);
    }
    */
}