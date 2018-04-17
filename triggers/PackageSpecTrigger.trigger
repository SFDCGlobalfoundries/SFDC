/*
Type Name: PackageSpecTrigger
Author: Cognizant
Created Date: 30-June-2013
Reason: This trigger prevents deletion of Package Specs for a Package which is not in Draft release status.
Change History:
Author: Cognizant
Modified Date: 13-May-2015
Reason: Case 41204
……..
……..
*/
trigger PackageSpecTrigger on Package_Spec__c (before insert,before update, before Delete) {
set<id> setPckgIds=new set<id>();
set<id> setDraftPckgs=new set<id>();
//Collect all Packages Ids
if(trigger.isupdate || trigger.isdelete){
    for(Package_Spec__c ps:Trigger.old){
        setPckgIds.add(ps.Package__c);
}
}
else{
    for(Package_Spec__c ps:Trigger.new){
    setPckgIds.add(ps.Package__c);
}
}
If(Trigger.isDelete){
//Select all Package Ids which are in Draft release status.
for(Package__c p:[select id from package__c where id in :setPckgIds and Package_Release_Status__c='Draft']){
    setDraftPckgs.add(p.id);
}
// Add error to those Package Specs which have Package in non-Draft status
for(Package_Spec__c ps:Trigger.old){
    if(!setDraftPckgs.contains(ps.Package__c)){
        //ps.addError(label.Package_Spec_Deletion_Error);
    }
}
}

// Update associateed document numbers at Package.
if(trigger.isBefore){

list<package__c> lstPackage=new list<package__c>();
lstPackage=[select id,Document_Numbers_Associated__c from package__C where id in :setPckgIds];
for(package__c p:lstPackage){
if(trigger.isinsert){
    for(package_Spec__c ps:trigger.new){
        system.debug('before pckg doc number:'+p.Document_Numbers_Associated__c+'***spec dco number:'+ps.Spec_Document_Number__c);
        if(p.Document_Numbers_Associated__c!=null && ps.Spec_Document_Number__c!=null && p.Document_Numbers_Associated__c.contains(ps.Spec_Document_Number__c)){     
        //do nothing
        }
        else{
            if(p.Document_Numbers_Associated__c==null || p.Document_Numbers_Associated__c=='null')
                p.Document_Numbers_Associated__c='';
            p.Document_Numbers_Associated__c=p.Document_Numbers_Associated__c+ps.Spec_Document_Number__c+';';    
        }
        system.debug('after pckg doc number:'+p.Document_Numbers_Associated__c+'***spec dco number:'+ps.Spec_Document_Number__c);
    }
}

if(trigger.isDelete){
    for(package_Spec__c ps:trigger.old){
  if(p.Document_Numbers_Associated__c!=null && ps.Spec_Document_Number__c!=null && p.Document_Numbers_Associated__c.contains(ps.Spec_Document_Number__c)){     
     
            p.Document_Numbers_Associated__c=p.Document_Numbers_Associated__c.replace(ps.Spec_Document_Number__c+';','');
        }
    }
}

}

/**------------------added by cognizant for Case 30222 start-----------------------------------------*/
   if(trigger.isDelete)
   {
   Set<Id> setofspecIds=new Set<Id>();
   Set<Id> setofpkgIds=new Set<Id>();
   map<Id,Id> Mapofpackids=new map<Id,Id>();
   map<Id,Id> Mapofspecandpackids=new map<Id,Id>();
    map<Id,Id> mapOfDp=new map<Id,Id>();
   List<Document_Provisioning__c> updateDplist=new  List<Document_Provisioning__c>();
   List<Document_Provisioning__c> updateDplist1=new  List<Document_Provisioning__c>();
   
   for(Package_Spec__c ps:Trigger.old){
        Mapofpackids.put(ps.Id,ps.Package__c);
        Mapofspecandpackids.put(ps.Package__c,ps.Design_spec__c);
        setofspecIds.add(ps.Design_spec__c);
        setofpkgIds.add(ps.Id);
   }
  // List<Design_spec__c> lstspec=[Select id from Design_spec__c where id in: Mapofpackids.getvalue()];
   List<Document_Provisioning__c> lstDpInSpec= [Select id,
                                          Design_spec__c,User__c,Packages_Provisioned_for__c,Spec_Level_Provisioning__c
                                          from Document_Provisioning__c 
                                          where Design_spec__c in :setofspecIds];
   system.debug('setofspecIds$$$'+setofspecIds);                                       
   system.debug('lstDpInSpec$$$'+lstDpInSpec);  
   system.debug('Mapofspecandpackids$$$'+Mapofspecandpackids);                                      
  /* List<Document_Provisioning__c> lstDpinPack= [Select id,
                                          Design_spec__c,Design_Package__c,User__c
                                          from Document_Provisioning__c 
                                          where Design_Package__c in :setofpkgIds];*/
                                          
   for(Document_Provisioning__c dp : lstDpInSpec)
   {
   mapOfDp.put(dp.Id,dp.Design_spec__c);
  
   }
   system.debug('mapOfDp$$$'+mapOfDp);  
   system.debug('Mapofspecandpackids$$$'+Mapofspecandpackids);  
   
     string str='';  
    if(!lstDpInSpec.isempty()) 
    {                                
     for(Document_Provisioning__c dp : lstDpInSpec)
    {
     str='';
     system.debug('enter dp');  
     
     system.debug('enter if loop'); 
     if(dp.Packages_Provisioned_for__c!=null)
     {
         for(String specStr : dp.Packages_Provisioned_for__c.split(';'))
             {
                     
                 system.debug('enter for string'); 
                 system.debug('enter if specStr'+specStr);        
                  if(Mapofspecandpackids.containskey(specStr))
                  {
                    //do nothing
                    system.debug('enter if  map'); 
                  }
                  else if(str!='')
                  {
                  system.debug('enter else map');   
                  str=specStr+';'+str;
                  system.debug('enter str'+str); 
                  
                  }
                  else if(str=='')
                  {
                  system.debug('enter else map1');   
                  str=specStr;
                  system.debug('enter str@@'+str); 
                  
                  }
             }
     
       system.debug('enter str###'+str); 
            if(str!='')
            {
             dp.Packages_Provisioned_for__c =str;
             
             system.debug('enter updateDplist'); 
             updateDplist.add(dp);
             }
             else if(dp.Spec_Level_Provisioning__c==false)//modified for Case 41204
             {
             system.debug('enter updateDplist1'); 
             //deleteDplist.add(dp);
             dp.Packages_Provisioned_for__c =str;
             dp.Status__c ='De-Provisioned';
             dp.Final_User_Access__c =false;
             updateDplist1.add(dp);
             }
             else if(dp.Spec_Level_Provisioning__c==true)//modified for Case 41204
             {
             system.debug('enter updateDplist2'); 
             //deleteDplist.add(dp);
             dp.Packages_Provisioned_for__c =str;
             //dp.Status__c ='De-Provisioned';
             //dp.Final_User_Access__c =false;
             updateDplist1.add(dp);
             }
       } //added for Case 41204     
     }
    } 
     
     system.debug('enter updateDplist'+updateDplist);  
     system.debug('enter updateDplist1'+updateDplist1);  
     if(updateDplist!=null)
     {
     update updateDplist;
     }
     if(updateDplist1!=null)
     {
     update updateDplist1;
     }
   }
/*----------------added by cognizant for Case 30222 end----------------------------------------------*/
try{
update lstPackage;
}
catch(exception e){
    system.debug('Packaeg Spec exception:'+e.getmessage());
}

}

}