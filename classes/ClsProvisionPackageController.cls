/*
Type Name: ClsProvisionPackageController
Author: Cognizant 
Created Date: 23-June-2013
Reason: This class is used for provisioning packages.
Change History: For Case# 2597
Author: Sunita Char
Modified Date: 26-Dec-2013
Reason: Sorting of the Users based on Name
Change History:
Author: 
Modified Date: 
Reason: Document Provisioning
Author: Cognizant
Modified Date: 21-Jan-2014
Reason: Fetch users which are already created in OT(Case 00004324)
……..
……..
*/
public with sharing class ClsProvisionPackageController{

private List<Account> tempAcct = new List<Account>();
private Map<ID,List<Opportunity>> AcctOppMAP = new Map<ID,List<Opportunity>>();
private Set<ID> AcctIDs = new Set<ID>();
public string searchText{get;set;}
public boolean renderContacts {get;set;}
public boolean renderSearchResults {get;set;}
public List<wrapper> wrapSelectedAccounts {get; set;}
public List<wrapper> searchResult {get; set;}

public ClsProvisionPackageController(ApexPages.StandardController controller){
    renderContacts =false;
    renderSearchResults = false;
    setupWhiteListProvisioning();
}

public pageReference searchAccount(){
    if(searchtext!=null && searchtext.length()>1){
/*------------------------added for Case  31838 start---------------------------------------------------------------------*/
         searchtext=searchtext.tolowercase();

/*------------------------added for Case  31838 end---------------------------------------------------------------------*/    
    searchResult =new list<wrapper>();
    string searchstrng='%'+searchtext+'%';
    // Case#2436 Added Short_Name__c
    for(Account a:[select name,id,Site_Department__c,Stage__c,Parent_Account_Name__c,Parent_Account_Short_Name__c,Short_Name__c from account where (name like :searchstrng OR Short_Name__c like :searchstrng)]){// Added parent account name/shortname for Case #00010006
       wrapper w=new wrapper();
       w.acct=a;  
       searchResult.add(w);
    }
    if(searchResult!=null && searchResult.size()>0){
        renderSearchResults = true; 
    } 
    else{
        renderSearchResults = false;
    }
    }
    else{
        renderSearchResults = false;
        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Please provide atleast 2 characters to search for!'));
    }  
return null;
}

public void setupWhiteListProvisioning(){
    package__c pkg=new package__C();
    set<id> setaccids=new set<id>();
    list<account> lstAcc=new list<Account>();
    map<id,list<user>> mapAccUserlst=new map<id,list<user>>();
    pkg=[select id,Package_Release_Status__c from package__c where id=:Apexpages.CurrentPage().getparameters().get('id')];
    //if(pkg!=null && pkg.Package_Release_Status__c=='White List'){
    if(pkg!=null && (pkg.Package_Release_Status__c).tolowercase().contains('white list')){
        renderContacts=true;
        for(White_List__c wl:[select account__c,account__r.Name,package__c from white_List__c where package__c=:pkg.id]){
            setaccids.add(wl.account__c); 
            lstAcc.add(new Account(id=wl.account__c,name=wl.account__r.Name));      
        }
       
        list<user> lstUser=new list<user>(); 
        list<user> Provisionedlstusr=new list<user>();
      /*-----Cognizant Added on 25/11/2013------------------------------------*/  
     lstUser=[select id,firstName,Name,Email,lastName,contact.accountid,contact.account.Name,Contact_Created_In_Open_Text__c from user where Isactive=true and contact.accountid in :setaccids and Contact_Created_In_Open_Text__c=true order by Name/*and id NOT in (select user__c from Document_Provisioning__c where design_package__c=:pkg.id and status__c='Provisioned') */ ];//modified by cognizant for Case 00004324                   
     Provisionedlstusr=[select id,firstName,Name,Email,lastName,contact.accountid,contact.account.Name,Contact_Created_In_Open_Text__c from user where Isactive=true and Contact_Created_In_Open_Text__c=true and contact.accountid in :setaccids and id in (select user__c from Document_Provisioning__c where design_package__c=:pkg.id and status__c='Provisioned')order by Name]; //modified by cognizant for Case 00004324    
 
    /*-----xxxxxxxxxxxxxxxxxxxxxx------------------------------------*/    
        for(User u:lstUser){
            if(mapAccUserlst!=null && mapAccUserlst.containsKey(u.contact.accountid)){
                list<user> ul=new list<user>();
                ul=mapAccUserlst.get(u.contact.accountid);
                ul.add(u);
                mapAccUserlst.put(u.contact.accountid,ul);
                system.debug('second loop:'+u.firstName+'****'+U.lastname);
            } 
            else{
                list<user> ul=new list<user>();
                ul.add(u);
                mapAccUserlst.put(u.contact.accountid,ul);
                system.debug('first loop:'+u.firstName+'****'+U.lastname);
            }
        }
        
        system.debug('@@lstUser'+lstUser);
        system.debug('@@Provisionedlstusr'+Provisionedlstusr);
        set<User> setofprovisioneduser=new set<User>();
        setofprovisioneduser.addall(Provisionedlstusr);
        
        system.debug('@@setofprovisioneduser'+setofprovisioneduser);
        
        // For white list need to bypass account selection and populate it with corrsponding white list account
        wrapSelectedAccounts=new list<wrapper>();
        for(Account acc:lstAcc){
            wrapper w=new wrapper();
            w.acct=acc;
            if(mapAccUserlst!=null && mapAccUserlst.containskey(acc.id)){
                list<wrapper2> lstw2=new list<wrapper2>();
                
                for(user u:mapAccUserlst.get(acc.id)){   
                    wrapper2 w2=new wrapper2(); 
                    w2.alreadyprovisioned=false;
                    system.debug('setofprovisioneduser.contains(u)'+setofprovisioneduser.contains(u));
                    system.debug('u*****'+u);
                     if(setofprovisioneduser.contains(u))
                     {
                      system.debug('enter if');
                      w2.alreadyprovisioned=true;
                      system.debug('w2.alreadyprovisioned'+w2.alreadyprovisioned);
                     }
                     
                     else
                     {
                     w2.alreadyprovisioned=false;
                     }                
                    w2.usr=u;
                    lstw2.add(w2); 
                    w.hasActiveContacts=true; 
                    system.debug('!@!@!@'+u);      
                }
                w.usrs= lstw2;
                
            }
            else{
                w.hasActiveContacts=false;
            }
            wrapSelectedAccounts.add(w);
                    
        }
        
        
    }
}

public pageReference next(){
    set<id> acctIds=new set<id>();
    list<user> lstusrs=new list<user>();
    map <id,list<user>> mapAccUser = new map<id,list<user>>();
    wrapSelectedAccounts=new list<wrapper>();
    
    if(searchResult!=null && searchResult.size()>0){
        for(wrapper w:searchResult){
            if(w.selected){
                acctIds.add(w.acct.id);
                renderContacts =true;
            }
        }
    }
    
    // Get all uesrs who have not yet been provisioned the Package.
    List<user> Provisionedlstusrs=new List<user>();
//Start Case 00002597 Changes to sort the users by Name
  lstusrs=[select firstname,Name,Email,lastname,id,contact.accountid,Contact_Created_In_Open_Text__c from user where Isactive=true and contact.accountid in :acctIds and Contact_Created_In_Open_Text__c=true order by Name/* and id NOT in (select user__c from Document_Provisioning__c where design_package__c=:ApexPages.currentPage().getParameters().get('id')and status__c='Provisioned')*/ ];//modified by cognizant for Case 00004324 
    Provisionedlstusrs=[select firstname,Name,Email,lastname,id,contact.accountid,Contact_Created_In_Open_Text__c from user where Isactive=true and contact.accountid in :acctIds  and Contact_Created_In_Open_Text__c=true and id in (select user__c from Document_Provisioning__c where design_package__c=:ApexPages.currentPage().getParameters().get('id')and status__c='Provisioned')order by Name];//modified by cognizant for Case 00004324 


//Start Case 00002597 Changes to sort the users by Name   

    //Create a map of Accountid and list of users.
    
    for(user u: lstusrs){
        if(mapAccUser !=null & mapAccUser .containskey(u.contact.accountid)){
            list<user> temp=new list<user>();
            temp= mapAccUser.get(u.contact.accountid);
            temp.add(u);
            mapAccUser.put(u.contact.accountid,temp);
        }
        else{
            mapAccUser.put(u.contact.accountid,new list<user>{u});    
        }            
    }
/*--------------------------------------------------------------------------*/
   
   Set<User> setofprovisionedusers =new Set<User>();
   setofprovisionedusers.addall(Provisionedlstusrs);
    
    system.debug('lstusrs****'+lstusrs);
    system.debug('Provisionedlstusrs****'+Provisionedlstusrs);
    system.debug('setofprovisionedusers****'+setofprovisionedusers);
    


/*------------------------------------------------------------------------------*/       
    
    system.debug('Map conent::'+mapAccUser);
    if(searchResult!=null && searchResult.size()>0){
    for(wrapper w: searchResult){
           if(w.selected){  
               
               list<wrapper2> lstWrap2=new list<wrapper2>();
               
               if(mapAccUser!=null && mapAccUser.containsKey(w.acct.id)){
               for(user u:mapAccUser.get(w.acct.id)){
                   wrapper2 uw=new wrapper2();
                   uw.alreadyprovisioned=false;
                   system.debug('setofprovisionedusers.contains(u)'+setofprovisionedusers.contains(u));
                     if(setofprovisionedusers.contains(u))
                     {
                      system.debug('enter if');
                      
                      uw.alreadyprovisioned=true;
                      system.debug('uw.alreadyprovisioned'+uw.alreadyprovisioned);
                     }
                     
                     else
                     {
                     uw.alreadyprovisioned=false;
                     }
                  
                   uw.usr=u;
                   system.debug('uw.alreadyprovisioned'+uw.alreadyprovisioned);
                   lstWrap2.add(uw);
                   w.hasActiveContacts = true;
                   }
               
               }
               system.debug('!$!$!$'+lstwrap2);
               w.usrs= lstWrap2;
               //lstWrap2.clear();         
               wrapSelectedAccounts.add(w);
           }
    }
    }
    
    
    // If no account is select then show Warning message.
    if(acctIds.isEmpty()){
        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Please search and select at least one account to proceed!!'));
    }
    return null;
}

public pageReference provisionPackage(){
list<id> lstUserIds=new list<id>();
if(wrapSelectedAccounts!=null && wrapSelectedAccounts.size()>0){
for(wrapper w:wrapSelectedAccounts){
    for(wrapper2 u:w.usrs){
        if(u.alreadyprovisioned){
            lstUserIds.add(u.usr.id);        
        }    
    }    
}
if(lstUserIds.isEmpty()){
    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Please select at least one contact to provision!!'));        
    return null;
}
else {
    map<id,list<id>> mapPckgProv=new map<id,list<id>>();
    mapPckgProv.put(ApexPages.currentPage().getParameters().get('id'),lstUserIds);
    ClsProvisioningHandler clsPrv=new ClsProvisioningHandler();
    try{
    clsPrv.doProvision(mapPckgProv,'Package');
    }catch(exception e){
        system.debug('Exception message:'+e.getmessage());
    }
    return new PageReference('/'+ApexPages.currentPage().getParameters().get('id')); 
}
}
return null;
}


//wrapper 1
public class wrapper{
     public Account acct {get; set;}
     public boolean selected {get;set;}
     public boolean hasActiveContacts {get;set;}
     public List<wrapper2> usrs {get; set;}
     public wrapper(){
         if(acct==null){acct = new Account();}//initialize account 
         if(usrs==null){usrs = new List<wrapper2>();}//initialize the user wrapper list
         hasActiveContacts =false;
     }
}
//wrapper 2 - the sub-wrapper
 public class wrapper2{
     public User usr {get; set;}
     public boolean selected {get; set;}
     public boolean alreadyprovisioned{get; set;}
     public wrapper2(){
         if(usr==null){
         usr = new user();
         }//initialize user
         selected=false;
         //alreadyprovisioned=false;
        
     }
 }

}