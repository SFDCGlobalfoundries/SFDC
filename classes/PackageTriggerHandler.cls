/*
Type Name: PackageTriggerHandler
Author: Cognizant 
Created Date: 13-June-2013
Reason: This class is used for Handler class for Trigger PackageTrigger.
Change History:
Author: 
Modified Date: 6/30/2013
Reason: Document Provisioning
Change History:Case-4853
Author: Cognizant FV Team
Modified Date: 26-01-2014
Reason: Handling Provisioning/De-Provisioning for General release Packages
……..
*/
public class PackageTriggerHandler{
public void deProvisionDraftPackage(list<package__c> newlstPackage,list<package__c> oldlstPackage){
    set<id> deprovisionPckgIds=new set<id>();
    for(integer i=0;i<newlstPackage.size();i++){
        if(newlstPackage[i].package_release_status__c!=oldlstPackage[i].package_release_status__c && newlstPackage[i].package_release_status__c=='Draft' ){
                deprovisionPckgIds.add(newlstPackage[i].id);
        }
    }
    
    //Map to hold package id and list of all user Ids who have been provisioned the Package.
    map<id,list<id>> mappckglstUser=new map<id,list<id>>();
    //Set to store all user ids who are being de-provisioned
    set<id> userIds=new set<id>(); 
    //Map to hold package id and list of Design Spec Ids for the package
    map<id,list<Id>> mappckglstSpec=new map<id,list<Id>>(); 
    // set to store all Design Spec Ids which belong to Draft Design Packages 
    set<id> specIds=new set<id>();
    //map to hold package id and document provisioning reccords for corresponding Design Specs
    map<id,Document_Provisioning__c> mapIdDocProv= new map<id,Document_Provisioning__c>(); 
    list<Document_Provisioning__c> lstPckgProv=new list<Document_Provisioning__c>();
    list<Document_Provisioning__c> lstPckgSpecProv=new list<Document_Provisioning__c>();
    
    lstPckgProv=[select id,Design_Package__c, user__c from Document_Provisioning__c where Design_Package__c!=null and Design_Package__c in :deprovisionPckgIds and status__c='Provisioned'];
    for(Document_Provisioning__c dp:lstPckgProv){
        if(mappckglstUser!=null && !mappckglstUser.isEmpty() && mappckglstUser.containsKey(dp.Design_Package__c)){
            list<id> temp=new list<id>();
            temp=mappckglstUser.get(dp.Design_Package__c);
            temp.add(dp.user__c);
            mappckglstUser.put(dp.Design_Package__c,temp);
            userIds.add(dp.user__c);
        }
        else{
            list<id> temp=new list<id>();
            temp.add(dp.user__c);
            mappckglstUser.put(dp.Design_Package__c,temp); 
            userIds.add(dp.user__c);   
        }    
     }
     system.debug('****map pacge user list:'+mappckglstUser);
     
     for(Package_Spec__c ps:[select package__c,design_spec__c from package_spec__c where package__c in :deprovisionPckgIds]){
         if(mappckglstSpec!=null && !mappckglstSpec.isEmpty() && mappckglstSpec.containsKey(ps.Package__c)){
            list<id> temp=new list<id>();
            temp=mappckglstSpec.get(ps.Package__c);
            temp.add(ps.design_spec__c);
            mappckglstSpec.put(ps.Package__c,temp);
            specIds.add(ps.design_spec__c);
        }
        else{
            list<id> temp=new list<id>();
            temp.add(ps.design_spec__c);
            mappckglstSpec.put(ps.Package__c,temp); 
            specIds.add(ps.design_spec__c);   
        } 
     }
     system.debug('****map pacge user list:'+mappckglstSpec);
     // Get all Document Provisioning records which need to be updated
     lstPckgSpecProv=[select id,Spec_Level_Provisioning__c,Packages_Provisioned_for__c,Sub_PDK_Provisioned_for__c,Team_Rooms_Provisioned_for__c,User__c,Design_Spec__c from Document_Provisioning__c where user__c in:userIds and Design_Spec__c in :specIds and status__c='Provisioned' ];
     system.debug('***** package spec provisioning:'+lstPckgSpecProv);
     for(Package__c p:newlstPackage){
         if(mappckglstUser!=null && mappckglstUser.containskey(p.id)){
         for(id uid:mappckglstUser.get(p.id)){
             for(Document_Provisioning__c dp:lstPckgSpecProv){
                 if(dp.user__c==uid){
                     system.debug('before package removal:'+dp.Packages_Provisioned_for__c+'***p.id:'+p.id);
                     system.debug('packages provisioned for:'+dp.Packages_Provisioned_for__c+'***package id:'+p.id);
                     if(dp.Packages_Provisioned_for__c!=null && string.valueOf(dp.Packages_Provisioned_for__c).contains(p.id)){
                         if(string.valueOf(dp.Packages_Provisioned_for__c).contains(';'+p.id)){
                             dp.Packages_Provisioned_for__c=dp.Packages_Provisioned_for__c.replace(';'+p.id,'');    
                         }
                         else if(string.valueOf(dp.Packages_Provisioned_for__c).contains(p.id+';')){
                             dp.Packages_Provisioned_for__c=dp.Packages_Provisioned_for__c.replace(p.id+';','');    
                         }
                         else 
                              dp.Packages_Provisioned_for__c=dp.Packages_Provisioned_for__c.replace(p.id,'');    
                     } 
                     system.debug('after package removal:'+dp.Packages_Provisioned_for__c+'***p.id:'+p.id);   
                 }
                 if(!dp.Spec_Level_Provisioning__c && (dp.Packages_Provisioned_for__c==null || dp.Packages_Provisioned_for__c=='') && (dp.Sub_PDK_Provisioned_for__c==null || dp.Sub_PDK_Provisioned_for__c=='') && (dp.Team_Rooms_Provisioned_for__c==null || dp.Team_Rooms_Provisioned_for__c=='') ){
                     dp.status__c='De-Provisioned';
                 }    
             }
         }
         }
     }
     
     //select all doc provisioning record of Packages to de-provision
     list<Document_Provisioning__c> lstPckgDeProv=new list<Document_Provisioning__c>();
     for(Document_Provisioning__c dp:[select id from Document_Provisioning__c where Status__c='Provisioned' and Design_Package__c in:deprovisionPckgIds  ]){
         dp.status__c='De-Provisioned';
         lstPckgDeProv.add(dp);        
     }
     system.debug('package provisionig records:'+lstPckgDeProv);
     
     //Update all related doc provisioning records.
     try{
         update lstPckgDeProv;
         update lstPckgSpecProv;
     }
     catch(exception e){
         system.debug('Package de-provisioning error:'+e.getmessage());
     }
    
}
//Case-4853 : Changes Start
//Commenting out replaced old method
/*****
public void provisionGeneralReleasePackageSpec(list<package__c> newlstPackage,list<package__c> oldlstPackage){  

    list<id> lstUserIds=new list<id>();
    map<id,list<id>> mapPckglstUser=new map<id,list<id>>();
 
    // Get all customer portal users    
    string portalgroupId=[select id from group where name=:label.Portal_User_Group limit 1].id;
    for(groupmember gm:[select UserOrGroupId from GroupMember where GroupId=:portalgroupId]){
        if(string.valueOf(gm.UserOrGroupId).startswith('005')){
            lstUserIds.add(gm.UserOrGroupId); 
        }       
    }
    
    //create package user list map for provisioning
    for(package__c p:newlstPackage){
        if(p.package_release_status__c!=((Package__c)trigger.oldMap.get(p.id)).package_release_status__c && String.ValueOf(p.package_release_status__c).tolowercase().contains('general release'))
        mapPckglstUser.put(p.id,lstUserIds);    
    } 
    
    // call provisioning utility class method
     ClsProvisioningHandler clsPrv=new ClsProvisioningHandler();
    try{
    clsPrv.doProvision(mapPckglstUser,'Package');
    }catch(exception e){
        system.debug('Exception message:'+e.getmessage());
    }
}
****/

public void provisionGeneralReleasePackageWhiteListSpec(list<package__c> newlstPackage,list<package__c> oldlstPackage){  
    set<id> setPckgId = new set<id>();
    set<id> setSpecId = new set<id>();
    map<id,list<id>> mapPckgSpec = new map<id,list<id>>();
    map<id,list<id>> mapSpecWL = new map<id,list<id>>();
    set<id> setWL = new set<id>();
    list<user> lstUsers = new list<user>();
    set<id> setWLSpecId = new set<id>();
    map<string,document_provisioning__c> mapDocPro =new map<string,document_provisioning__c>();
    map<string,document_provisioning__c> tempMapDocPro =new map<string,document_provisioning__c>();
    map<string,document_Provisioning__c> maplstDocProUpsert = new map<string,document_Provisioning__c>();
    map<id,list<user>> mapAcclstUser = new map<id,list<user>>();
    
    try{
    //create package user list map for provisioning
    for(package__c p:newlstPackage){
        if(p.package_release_status__c!=((Package__c)trigger.oldMap.get(p.id)).package_release_status__c && String.ValueOf(p.package_release_status__c).tolowercase().contains('general release'))
        setPckgId.add(p.id);           
    } 
    
    list<package_spec__c> lstPckgSpec = new list<package_spec__c>();
    lstPckgSpec = [select package__c,Design_Spec__c from package_spec__c where package__c in :setPckgId];
    for(Package_spec__c ps :lstPckgSpec){
      setSpecId.add(ps.Design_spec__c);
      if(mapPckgSpec!=null && mapPckgSpec.containskey(ps.package__c)){
          list<id> temp = new list<id>();
          temp = mapPckgSpec.get(ps.package__c);
          temp.add(ps.Design_spec__c);
          mapPckgSpec.put(ps.package__c,temp);    
      }
      else{
          list<id> temp = new list<id>();
          temp.add(ps.Design_spec__c);
          mapPckgSpec.put(ps.package__c,temp);
      }      
    }
    //Get all white list accounts for each Spec
    for(White_list__c wl: [select Account__c,Design_Spec__c from white_list__c where Design_Spec__c in :setSpecId ]){
        setWL.add(wl.account__c);
        setWLSpecId.add(wl.design_spec__c);
        if(mapSpecWL!=null && mapSpecWL.containskey(wl.Design_Spec__c)){
            list<id> temp = new list<id>();
            temp = mapSpecWL.get(wl.Design_Spec__c);
            temp.add(wl.account__c);
            mapSpecWL.put(wl.Design_Spec__c,temp);
        }
        else{
            list<id> temp = new list<id>();
            temp.add(wl.account__c);
            mapSpecWL.put(wl.Design_Spec__c,temp);
        }
    }
    lstUsers = [select accountid,id from user where isactive=true and accountid!=null and accountid in :setWL];
    
    for(user u:lstUsers){
        if(mapAcclstUser!=null && mapAcclstUser.containskey(u.accountid)){
            list<user> temp = new list<user>();
            temp = mapAcclstUser.get(u.accountid);
            temp.add(u);
            mapAcclstUser.put(u.accountid,temp);
        }
        else{
            list<user> temp = new list<user>();
            temp.add(u);
            mapAcclstUser.put(u.accountid,temp);
        }
        
    }
    
    list<document_provisioning__c> lstDocPro = new list<Document_Provisioning__c>();
    lstDocPro = [select id, status__c, Packages_provisioned_for__c, user__c, Design_spec__c from document_provisioning__c where design_spec__c!=null and design_spec__c in :setWLSpecId and user__c in :lstUsers];
    for(document_provisioning__c dp :lstDocPro){
        mapDocPro.put(dp.user__c+'-'+dp.design_spec__c,dp);
    }
    
    for(package_spec__c ps :lstPckgSpec){
        if(!setWLSpecId.isEmpty() && setWLSpecId.contains(ps.design_spec__c) && mapSpecWL!=null && !mapSpecWL.keyset().isEmpty()){           
            if(mapSpecWL.get(ps.design_spec__c)!=null && mapAcclstUser!=null && !mapAcclstUser.keyset().isEmpty()){
                for(id acc :mapSpecWL.get(ps.design_spec__c)){
                    for(user u :mapAcclstUser.get(acc)){
                        if(maplstDocProUpsert!=null && maplstDocProUpsert.containskey(u.id+'-'+ps.design_spec__c) && ( (maplstDocProUpsert.get(u.id+'-'+ps.design_spec__c).Packages_provisioned_for__c==null || maplstDocProUpsert.get(u.id+'-'+ps.design_spec__c).Packages_provisioned_for__c=='') || !(maplstDocProUpsert.get(u.id+'-'+ps.design_spec__c).Packages_provisioned_for__c!=null && (maplstDocProUpsert.get(u.id+'-'+ps.design_spec__c).Packages_provisioned_for__c).indexof(ps.package__c)>-1))){
                            maplstDocProUpsert.get(u.id+'-'+ps.design_spec__c).Packages_provisioned_for__c = maplstDocProUpsert.get(u.id+'-'+ps.design_spec__c).Packages_provisioned_for__c + ';' + ps.package__c;        
                        }                        
                        else if(mapDocPro!=null && mapDocPro.containskey(u.id+'-'+ps.design_spec__c)){
                            document_provisioning__c dp =new document_provisioning__c();
                            dp = mapDocPro.get(u.id+'-'+ps.design_spec__c); 
                            dp.status__c = 'Provisioned';
                            if(mapDocPro.get(u.id+'-'+ps.design_spec__c).Packages_Provisioned_for__c!=null){
                               if(!(mapDocPro.get(u.id+'-'+ps.design_spec__c).Packages_Provisioned_for__c.indexOf(ps.Package__c)>-1) )
                                dp.Packages_Provisioned_for__c = mapDocPro.get(u.id+'-'+ps.design_spec__c).Packages_Provisioned_for__c + ';' + ps.Package__c;
                            }
                            else {
                                dp.Packages_Provisioned_for__c = ps.Package__c;
                            }
                            maplstDocProUpsert.put(u.id+'-'+ps.design_spec__c,mapDocPro.get(u.id+'-'+ps.design_spec__c));
                                  
                        }
                        else{
                            document_provisioning__c dp = new document_provisioning__c();
                            dp.status__c='Provisioned';
                            dp.User__c = u.id;
                            dp.Design_Spec__c = ps.design_spec__c;
                            dp.Packages_Provisioned_for__c = ps.Package__c;
                            maplstDocProUpsert.put(u.id+'-'+ps.design_spec__c,dp);
                        }    
                    }
                }
            }
        }
    }
    if(maplstDocProUpsert!=null && !maplstDocProUpsert.keyset().isEmpty() && maplstDocProUpsert.values().size()>0){
        upsert maplstDocProUpsert.values();
    }
   }catch(exception ex){
       system.debug('Error in General release package\'s associated white list Spec\'s provisioning!:'+ex.getmessage());
   } 
}

//Method used to de-provision White List Specs of a Package which is made Draft from General Release
public void deProvisionWLSpecsDraftPackage(list<package__c> newlstPackage,list<package__c> oldlstPackage){
set<id> deprovisionPckgIds=new set<id>();
set<id> pckgSpecIds = new set<id>();
set<id> WLIds = new set<id>();
map<id,set<id>> mapSpecWL = new map<id,set<id>>();
list<document_provisioning__c> lstDocPro = new list<document_provisioning__c>();

 for(integer i=0;i<newlstPackage.size();i++){
    if(oldlstPackage[i].package_release_status__c=='General Release' && newlstPackage[i].package_release_status__c=='Draft' ){
        deprovisionPckgIds.add(newlstPackage[i].id);
    }
 }
 for(package_spec__c ps :[select design_spec__c from package_spec__c where package__c in :deprovisionPckgIds]){
     pckgSpecIds.add(ps.design_spec__c);
 }
 for(white_list__c wl:[select account__c,design_spec__c from white_list__c where design_spec__c in :pckgSpecIds]){
     WLIds.add(wl.account__c);
     if(mapSpecWL!=null && mapSpecWL.containskey(wl.design_spec__c)){
         set<id> temp = new set<id>();
         temp = mapSpecWL.get(wl.design_spec__c);
         temp.add(wl.account__c);
         mapSpecWL.put(wl.design_Spec__c,temp);
     }
     else{
         set<id> temp = new set<id>();
         temp.add(wl.account__c);
         mapSpecWL.put(wl.design_Spec__c,temp);
     }
 }
 
 for(document_Provisioning__c dp :[select status__c,Spec_Level_Provisioning__c,packages_provisioned_for__c,Sub_PDK_Provisioned_for__c,Team_Rooms_Provisioned_for__c,account__c,design_spec__c from document_provisioning__c where status__c='Provisioned' and account__c in :WLIds and design_spec__c in :pckgSpecIds]){
     if(dp.packages_provisioned_for__c!=null && mapSpecWL!=null && mapSpecWL.containskey(dp.design_spec__c) && mapSpecWL.get(dp.design_spec__c).contains(dp.account__c)){
         for(string pckgId :dp.packages_provisioned_for__c.split(';')){
             if(deprovisionPckgIds.contains(pckgId)){
                 if((dp.packages_provisioned_for__c).contains(';'+pckgId)){
                     dp.packages_provisioned_for__c = (dp.packages_provisioned_for__c).replace(';'+pckgId,'');        
                 }
                 else if ((dp.packages_provisioned_for__c).contains(pckgId+';')){
                     dp.packages_provisioned_for__c = (dp.packages_provisioned_for__c).replace(pckgId+';','');
                 }
                 else
                     dp.packages_provisioned_for__c = (dp.packages_provisioned_for__c).replace(pckgId,'');        
             }
         }
         if(!dp.Spec_Level_Provisioning__c && (dp.Packages_Provisioned_for__c==null || dp.Packages_Provisioned_for__c=='') && (dp.Sub_PDK_Provisioned_for__c==null || dp.Sub_PDK_Provisioned_for__c=='') && (dp.Team_Rooms_Provisioned_for__c==null || dp.Team_Rooms_Provisioned_for__c=='')){
             dp.status__c='De-Provisioned';
         }
         lstDocPro.add(dp);    
     }                            
 }
 
 if(lstDocPro!=null && lstDocPro.size()>0){
     update lstDocPro;
 }
}
//Case-4853 : Changes End

    
}