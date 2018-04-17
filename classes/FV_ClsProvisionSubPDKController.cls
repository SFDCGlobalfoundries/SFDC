/**
 Type Name: FV_ClsProvisionSubPDKController
 Author: Cognizant Technology Solutions
 Created Date: 3-sep-2014
 Reason: case 27865
 Change History:
 Author: cognizant
 Modified Date: 23-sep-2014
 Reason: Case 35161
 Author: cognizant
 Modified Date: 7th-oct-2014
 Reason: Case 35459
 ��.. 
**/

public with sharing class FV_ClsProvisionSubPDKController{

private List<Account> tempAcct = new List<Account>();
private Map<ID,List<Opportunity>> AcctOppMAP = new Map<ID,List<Opportunity>>();
private Set<ID> AcctIDs = new Set<ID>();
public string searchText{get;set;}
public boolean renderContacts {get;set;}
public boolean renderSearchResults {get;set;}
public List<wrapper> wrapSelectedAccounts {get; set;}
public List<wrapper> searchResult {get; set;}

public Set<String> setofprovisionedusers{get;set;}
public Set<String> provisionedset{get;set;}

public List<String> provisionedlist{get;set;}

public  Boolean isValidProfile{get;set;}
public Map<String, Profiles_for_Provisioning__c> mapPFP = Profiles_for_Provisioning__c.getAll();
public Map<String, Restricted_Tech_Geometry__c> mapRTG = Restricted_Tech_Geometry__c.getAll();
public  Boolean isValidTechGeometry {get;set;}
public  Sub_PDK__c objSubPDK{get;set;}  
public  Id objSubPDKId{get;set;}
public  Boolean showAddAccounts{get;set;}
public  Boolean isValidReleaseStatusForProvisioning{get;set;}  
public boolean isNotObsoletePDK{get;set;} 

public FV_ClsProvisionSubPDKController(ApexPages.StandardController controller){
    renderContacts =false;
    renderSearchResults = false;
    Set<Id> setProfileIds = new Set<Id>();
    isValidTechGeometry  =false;
    setupWhiteListProvisioning();
    isValidProfile =false;
    isNotObsoletePDK = false; 
    setProfileIds.addAll(getValidProfiles());

    if(setProfileIds!=null && setProfileIds.contains(UserInfo.getProfileId())){
        isValidProfile = true;  
    }
    else{
        list<PermissionSetAssignment> PS = new list<PermissionSetAssignment>();
        PS=[select Id, PermissionSet.Name,AssigneeId FROM PermissionSetAssignment WHERE AssigneeId=:Userinfo.getUserId() and PermissionSet.Name=:System.Label.PermissionSetForProvisioning];
        system.debug('@@@@@@@@@@@@@@@@@@@@@@@@@'+PS+'@@@@@@@@@@@@@@@@@@@@@@@@@');
            if(PS.size()>0){
            isValidProfile = true;
            } 
            else{
                    ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'You do not have proper permission for de-provisioning this sub pdk.');
                    ApexPages.addMessage(myMsg);
                }
    }
     objSubPDKId = controller.getId();
        
        if(objSubPDKId!=null){
            
            objSubPDK = retrieveSubPDKInfo(objSubPDKId);
            
            isValidTechGeometry = verifyValidTechGeometry(objSubPDK.Tech_Geometry__c);
             /** Restrict from Provisioning Sub PDKs when PDK is Obsolete - Start **/
            isNotObsoletePDK = verifyNonObsoleteMasterPDK(objSubPDK.PDK__c);
            /** Restrict from Provisioning Sub PDKs when PDK is Obsolete - End **/
             showAddAccounts = showOrHideAddAccounts(objSubPDK.Release_Status__c); 
     } 
    
           
}

 public  Set<Id> getValidProfiles(){
        
        Set<Id> setProfileIds = new Set<Id>();
        
        if(mapPFP!=null && mapPFP.size()>0){
            for(Profile objProfile: [Select Id, Name from Profile where Name IN: mapPFP.KeySet()]){
                 setProfileIds.add(objProfile.Id);
             }

        }
         
        return setProfileIds;
    }
 
 public  Sub_PDK__c retrieveSubPDKInfo(Id subPDKId){
        
        Sub_PDK__c objSubPDK = new Sub_PDK__c();
        
        objSubPDK = [Select Id, Name, Sub_PDK_Version__c, Sub_PDK_Location_Fab__c, Sub_PDK_Revision_Release_Date__c, Sub_PDK_Lifecycle_Phase__c, 
                 Sub_PDK_Sub_class__c, Technology__c,Tech_Geometry__c, Release_Status__c, PDK__c from Sub_PDK__c
                 where Id =: subPDKId];
                 
        return objSubPDK;
            
    }
  public  Boolean showOrHideAddAccounts(String releaseStatus){
        

        Boolean showAccounts;
        isValidReleaseStatusForProvisioning = false;    
        

        if(releaseStatus!=null){
            if(releaseStatus.contains('Specific Account Release')){ 
                showAccounts = true;    
            }

            else{
                showAccounts = false;
            }

            if(releaseStatus!='Internal Use Only' && releaseStatus!='General Release'){
                isValidReleaseStatusForProvisioning = true; 
            }

            else{
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'You cannot provision for Release Statuses of General Release or Internal Release');
                ApexPages.addMessage(myMsg);    
            }
        }


        else{
            showAccounts = false;   
        }
        


        return showAccounts;
    }    
    
 /**
        This method decides whether the Tech Geometry of the Design Spec record is in Restricted Tech Geometries.

        @method name: verifyValidTechGeometry
        @parameter:   Tech Geometry of the corresponding Design Spec record.
        @return :     True or False depending on whether it's a valid Tech Geometry or not.
     **/
     
    public  Boolean verifyValidTechGeometry(String techGeometry){
        

        Boolean isValid;
        

        if(techGeometry!=null){
            if(mapRTG.keySet().contains(techGeometry)){
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'You cannot provision for Restricted Tech Geometries');
                ApexPages.addMessage(myMsg);
                isValid=false;          
            }

            else{
                isValid=true;
            }
        }


        else{
            isValid=true;
        }
        


        return isValid;
    }
 /** Restrict from Provisioning Sub PDKs when PDK is Obsolete - Start **/
    
    /**
        This method decides whether the PDK is Obsolete or not and restricts Sub PDK Provisioning.

        @method name: verifyNonObsoleteMasterPDK
        @parameter:   Master PDK Id of Sub PDK Record.
        @return :     False or True depending on whether PDK is Obsolete or not.
     **/
     
    public  Boolean verifyNonObsoleteMasterPDK(Id pdkId){
        

        Boolean isValid;
        

        if(pdkId!=null){
            for(PDK__c obj:[Select Id, PDK_Lifecycle_Phase__c from PDK__c where Id=:pdkId]){
                if(obj.PDK_Lifecycle_Phase__c=='Obsolete'){
                    ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'You cannot provision for Obsolete Master PDKs');
                    ApexPages.addMessage(myMsg);
                    isValid = false;        
                }

                else{
                    isValid = true;
                }   
            }
        }
        




        return isValid;
    }
    
    /** Restrict from Provisioning Sub PDKs when PDK is Obsolete - End **/
              
public pageReference searchAccount(){
    if(searchtext!=null && searchtext.length()>1)
    {
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
    Sub_PDK__c objPdk=new Sub_PDK__c();
    set<id> setaccids=new set<id>();
    list<account> lstAcc=new list<Account>();
    provisionedList=new List<string>();//added by cognizant for urgent issue case 35459

    map<id,list<user>> mapAccUserlst=new map<id,list<user>>();
    objPdk=[Select Id, Name, Sub_PDK_Version__c, Sub_PDK_Location_Fab__c, Sub_PDK_Revision_Release_Date__c, Sub_PDK_Lifecycle_Phase__c, 
                 Sub_PDK_Sub_class__c, Technology__c,Tech_Geometry__c, Release_Status__c, PDK__c from Sub_PDK__c where id=:Apexpages.CurrentPage().getparameters().get('id')];
    //if(pkg!=null && pkg.Package_Release_Status__c=='White List'){
    if(objPdk!=null && (objPdk.Release_Status__c).tolowercase().contains('white list')){
        renderContacts=true;
        for(White_List__c wl:[select account__c,account__r.Name,Sub_PDK__c from white_List__c where Sub_PDK__c=:objPdk.id]){
            setaccids.add(wl.account__c); 
            lstAcc.add(new Account(id=wl.account__c,name=wl.account__r.Name));      
        }
       
        list<user> lstUser=new list<user>(); 
        list<user> Provisionedlstusr=new list<user>();
     
     lstUser=[select id,firstName,Name,Email,lastName,contact.accountid,contact.account.Name,Contact_Created_In_Open_Text__c from user where Isactive=true and contact.accountid in :setaccids and Contact_Created_In_Open_Text__c=true order by Name/*and id NOT in (select user__c from Document_Provisioning__c where design_package__c=:pkg.id and status__c='Provisioned') */ ];                  
     Provisionedlstusr=[select id,firstName,Name,Email,lastName,contact.accountid,contact.account.Name,Contact_Created_In_Open_Text__c from user where Isactive=true and Contact_Created_In_Open_Text__c=true and contact.accountid in :setaccids and id in (select user__c from Document_Provisioning__c where Sub_PDK__c=:objPdk.id and status__c='Provisioned')order by Name];    
 
     
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
                     provisionedlist.add(u.id);//added by cognizant for urgent issue case 35459
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
           system.debug('w.hasActiveContacts###'+w.hasActiveContacts);         
        }
        
        
    }
}
public pageReference next(){
    set<id> acctIds=new set<id>();
     
     provisionedList=new List<string>();
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

  lstusrs=[select firstname,Name,Email,lastname,id,contact.accountid,Contact_Created_In_Open_Text__c from user where Isactive=true and contact.accountid in :acctIds and Contact_Created_In_Open_Text__c=true order by Name/* and id NOT in (select user__c from Document_Provisioning__c where design_package__c=:ApexPages.currentPage().getParameters().get('id')and status__c='Provisioned')*/ ];
   system.debug('lstusrs$$$$$$'+lstusrs);
   
    Provisionedlstusrs=[select firstname,Name,Email,lastname,id,contact.accountid,Contact_Created_In_Open_Text__c from user where Isactive=true and contact.accountid in :acctIds  and Contact_Created_In_Open_Text__c=true and id in (select user__c from Document_Provisioning__c where Sub_PDK__c=:ApexPages.currentPage().getParameters().get('id')and status__c='Provisioned')order by Name];


  

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
    
     system.debug('mapAccUser$$$$$$'+mapAccUser);

   
   Set<User> setofprovisionedusers =new Set<User>();
   setofprovisionedusers.addall(Provisionedlstusrs);
    
    system.debug('lstusrs****'+lstusrs);
    system.debug('Provisionedlstusrs****'+Provisionedlstusrs);
    system.debug('setofprovisionedusers****'+setofprovisionedusers);
    
      
    
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
                      system.debug('enter if###');
                      
                      provisionedlist.add(u.id);
                      uw.alreadyprovisioned=true;
                      
                      system.debug('uw.alreadyprovisioned@@'+uw.alreadyprovisioned);
                      
                     }
                     
                     else
                     {
                     system.debug('uw.alreadyprovisioned###'+uw.alreadyprovisioned);
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
 
public pageReference provisionPDK(){
list<id> lstUserIds=new list<id>();
Set<id> SetUserIds=new SEt<id>();
boolean contactselected =false;

system.debug('enter true loop');
if(wrapSelectedAccounts!=null && wrapSelectedAccounts.size()>0){
system.debug('wrapSelectedAccounts$$$'+wrapSelectedAccounts);
for(wrapper w:wrapSelectedAccounts){
 system.debug('enter for ');
    for(wrapper2 u:w.usrs){
    system.debug('enter for222 '+u);
    system.debug('is selcted## '+u.selected);
        if(u.alreadyprovisioned){
        system.debug('enter if');
            lstUserIds.add(u.usr.id);
           
        }
       
    }    
}
    
    system.debug('provisionedList###'+provisionedList);
    system.debug('lstUserIds###'+lstUserIds);
   if(provisionedList!=null && lstUserIds!=null) //added for emergency case 00035161 
   { //added for emergency case 00035161 
    if(!provisionedList.isempty() && !lstUserIds.isempty() )
    {
         for(id userid :provisionedList)
         {
         
             for(id userid1:lstUserIds)
             {
                 if(userid!=userid1)
                 {
                 system.debug('if user check###');
                 SetUserIds.add(userid);
                 }
             }
         }
     }
     else
         {
         SetUserIds.addall(lstUserIds);
         }
   } //added for emergency case 00035161      
 system.debug('SetUserIds###'+SetUserIds);
 system.debug('lstUserIds###'+lstUserIds);
if(SetUserIds.isempty() || lstUserIds.size()==provisionedList.size())//modified for case 00035161 
{
system.debug('enter else loop');

 Apexpages.Message msg = new Apexpages.Message(ApexPages.Severity.Error,Label.Contact_Req_For_Prov_Msg);   
 Apexpages.addmessage(msg);
}
else
{
system.debug('enter else');
    map<id,list<id>> mapSubPDKProv=new map<id,list<id>>();
    mapSubPDKProv.put(ApexPages.currentPage().getParameters().get('id'),lstUserIds);
    ClsProvisioningHandler clsPrv=new ClsProvisioningHandler();
    try{
    clsPrv.doProvision(mapSubPDKProv,'SubPDK');
    system.debug('enter doProvision');
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
    public Map<String, Boolean> mapUserIdToChecked{get;set;}
     public wrapper2(){
         if(usr==null){
         usr = new user();
         }//initialize user
         selected=false;
         //alreadyprovisioned=false;
        
     }
 }
}