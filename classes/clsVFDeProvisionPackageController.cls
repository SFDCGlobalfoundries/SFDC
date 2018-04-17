/*
Type Name: clsVFDeProvisionPackageController
Author: Cognizant 
Created Date: 12-June-2013
Reason: This class is used for deprovisioning package.
Change History:
Author: Cognizant 
Modified Date: 25/11/2013
Reason: sorting of users
Author: Cognizant
Modified Date: 21-Jan-2014
Reason: Fetch users which are already created in OT(Case 00004324)
Author: Sunita
Modified Date: 3/20/2015
Reason: NDA changes for spec and package
……..
……..
*/


public with sharing class clsVFDeProvisionPackageController{
private package__c pckg=new package__c();
public list<Accountwrapper> lstwAccounts {get;set;}
public list<Accountwrapper> selectedlstwAccounts {get;set;}
public list<userwrapper> lstdeprovwusers {get;set;}
public boolean renderContacts{get;set;}
set<id> setUserIds=new set<id>();
set<id> setAccIds=new set<id>();


public clsVFDeProvisionPackageController(ApexPages.StandardController Controller){
    pckg=(package__c)controller.getRecord();
    renderContacts=false;    
    //for(Document_Provisioning__c dp:[select user__c from document_provisioning__c where design_package__c!=null and design_package__c=:apexPages.CurrentPage().getParameters().get('id') and status__c='Provisioned']){
    for(Document_Provisioning__c dp:[select user__c from document_provisioning__c where design_package__c!=null and design_package__c=:apexPages.CurrentPage().getParameters().get('id') and status__c='Provisioned']){
        setUserIds.add(dp.user__c);        
    }
    
    list<account> lstAcc=new list<Account>();
    list<user> lstUser=new list<user>();
    map<id,list<user>> mapAccUserlst=new map<id,list<user>>();
    
    /* cognizant modified on 25/11/2013---------*/    
    for(user u:[select id,firstName,Email,Name,lastName,contact.id,contact.Account.Name,contact.accountid,Contact_Created_In_Open_Text__c from user where id in :setUserIds and Contact_Created_In_Open_Text__c=true order by Name])//modified by cognizant for case 00004324
    {
    /*----------------------------------------*/ 
        lstUser.add(u);
        setAccIds.add(u.contact.AccountId);   
        if(mapAccUserlst!=null && mapAccUserlst.containsKey(u.contact.AccountId)){
            list<user> temp=new list<user>();
            temp=mapAccUserlst.get(u.contact.AccountId);
            temp.add(u); 
            mapAccUserlst.put(u.contact.AccountId,temp);          
        } 
        else{
            list<user> temp=new list<user>();
            temp.add(u);
            mapAccUserlst.put(u.contact.AccountId,temp);                
        }            
    }
    system.debug('****Account Ids:'+setAccIds);
    lstwAccounts=new list<accountwrapper>();
    for(Account acc:[select id,name from account where id in :setAccIds]){
        
        list<userwrapper> lstuw=new list<userwrapper>();
        for(user u:mapAccUserlst.get(acc.id)){
            userwrapper uw=new userwrapper();
            uw.usr=u;
            lstuw.add(uw);
        }
        
        accountwrapper aw=new accountwrapper();
        aw.acc=acc;
        aw.usrwrap=lstuw;
        lstwAccounts.add(aw);   
        system.debug('****Account id:'+aw.acc.name);     
    }
    system.debug('*****Account list:'+lstwAccounts);
}

public pageReference next(){
    selectedlstwAccounts=new list<accountwrapper>();
    if(lstwAccounts!=null && lstwAccounts.size()>0){
    for(accountwrapper aw:lstwAccounts){
        if(aw.selected){
            selectedlstwAccounts.add(aw);  
            renderContacts=true;  
        }
    }
    } 
    else{
        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Please select at least one Account to proceed!!'));    
    }   
    return null;
}

public pageReference deProvisionPackage(){
    //Set to hold all user ids selected for deprovisioning.
    set<id> userids=new set<id>();
    //Set to hold all the associated Design Spec ids for the Package.
    set<id> specIds=new set<id>();
    //list to contain all deprovisioning eligible Document Provisioning records for the associated Design Specs of the package.
    list<Document_Provisioning__c> lstPckgSpecProv=new list<Document_Provisioning__c>();
    //List to contain Document Provisoning records for the Package
    list<Document_Provisioning__c> lstPckgProv=new list<Document_Provisioning__c>();
    for(accountwrapper  aw:selectedlstwAccounts){
        for(userwrapper uw:aw.usrwrap){
            if(uw.selected){
                userids.add(uw.usr.id);    
            }    
        }    
    } 
    system.debug('****user Ids:'+userids);
    
    if(userids.size()<1){
        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Please select at least one Contact to proceed!!'));    
        return null;
    }
    
    
    //Get all asscoiated Design Spec to be deProvisioned
    for(Package_Spec__c ds:[select package__c,design_spec__c from package_spec__c where package__c=:apexPages.currentPage().getParameters().get('id')]){
        specids.add(ds.design_spec__c);
    }
    
    
    // Get all Document Provisioning records which need to be updated
    lstPckgSpecProv=[select id,Spec_Level_Provisioning__c,Packages_Provisioned_for__c,Sub_PDK_Provisioned_for__c,Team_Rooms_Provisioned_for__c,User__c,Design_Spec__c from Document_Provisioning__c where user__c in:userIds and Design_Spec__c in :specIds and status__c='Provisioned' ];
    system.debug('****prov records'+lstPckgSpecProv);
    
    for(id uid:userids){
        for(Document_Provisioning__c dp:lstPckgSpecProv){
                 system.debug('****Before loop packages provisioned for:'+dp.Packages_Provisioned_for__c+'***package Id:'+pckg.id);
                 if(dp.user__c==uid){
                     if(dp.Packages_Provisioned_for__c!=null && string.valueOf(dp.Packages_Provisioned_for__c).contains(pckg.id)){
                         if(string.valueOf(dp.Packages_Provisioned_for__c).contains(';'+pckg.id)){
                             dp.Packages_Provisioned_for__c=dp.Packages_Provisioned_for__c.replace(';'+pckg.id,'');    
                         }
                         else if(string.valueOf(dp.Packages_Provisioned_for__c).contains(pckg.id+';')){
                             dp.Packages_Provisioned_for__c=dp.Packages_Provisioned_for__c.replace(pckg.id+';','');    
                         }
                         else 
                              dp.Packages_Provisioned_for__c=dp.Packages_Provisioned_for__c.replace(pckg.id,'');    
                     }    
                 }
                 system.debug('****After loop packages provisioned for:'+dp.Packages_Provisioned_for__c+'***package Id:'+pckg.id);
                 if(!dp.Spec_Level_Provisioning__c && (dp.Packages_Provisioned_for__c==null || dp.Packages_Provisioned_for__c=='') && (dp.Sub_PDK_Provisioned_for__c==null || dp.Sub_PDK_Provisioned_for__c=='') && (dp.Team_Rooms_Provisioned_for__c==null || dp.Team_Rooms_Provisioned_for__c=='') ){
                     dp.status__c='De-Provisioned';
                     if(!system.isFuture() && !system.isBatch() && !dp.is_De_Prov_From_UI__c){//sunita 19th march
                     dp.is_De_Prov_From_UI__c=true;//sunita 19th march
                  }
                 }    
             }        
    }  
    
    //select all doc provisioning record of Packages to de-provision
    for(Document_Provisioning__c dp:[select id,is_De_Prov_From_UI__c from Document_Provisioning__c where Status__c='Provisioned' and Design_Package__c=:pckg.id and user__c in :userids]){
        dp.status__c='De-Provisioned';
        if(!system.isFuture() && !system.isBatch() && !dp.is_De_Prov_From_UI__c){//sunita 19th march
          dp.is_De_Prov_From_UI__c=true;//sunita 19th march
          }
        lstPckgProv.add(dp);        
    }
    
    //Update all related doc provisioning records.
     try{
         update lstPckgProv;
         update lstPckgSpecProv;
     }
     catch(exception e){
         system.debug('Package de-provisioning error:'+e.getmessage());
     }
    
    return new PageReference('/'+pckg.id);
}
                        
public class accountwrapper{
public account acc{get;set;}
public boolean selected{get;set;}
public list<userwrapper> usrwrap{get;set;}
accountwrapper(){
    if(acc==null)
        acc=new account();
    if(usrwrap==null)
        usrwrap=new list<userwrapper>();
}
}

public class userwrapper{
public user usr{get;set;}
public boolean selected{get;set;}
userwrapper(){
    if(usr==null)
        usr=new user();
}
}

}