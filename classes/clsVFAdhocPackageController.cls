public class clsVFAdhocPackageController {
public string searchText{get;set;}
public string remSpecId{get;set;}
public boolean bSearchMessage{get;set;}
package__c pckg=new package__c();
public list<design_spec__c> searchResult=new list<design_spec__c>();
public list<design_spec__c> lstPckgSpec{get;set;}
public list<specWrapper> searchResultWrapper{
get{
    if(searchResultWrapper==null)
        searchResultWrapper=new list<specWrapper>();
    return searchResultWrapper;
}
set;
}
public clsVFAdhocPackageController(ApexPages.StandardController controller) {
    pckg=(package__c)controller.getRecord();
}

public pageReference searchSpecs(){
string tempsearchText='%'+searchText+'%';
list<design_spec__c> lstSpec=new list<design_spec__c>();
if(searchResultWrapper.size()>0)
    searchResultWrapper.clear();
lstspec=[select id,Name,Document_Number__c,Revision__c,Specification_Type__c,Technology_Type__c,Technology_Geometry__c,Description__c  from design_spec__c where Document_Number__c like :tempSearchText or Revision__c like :tempSearchText or Specification_Type__c like :tempSearchText or Technology_Geometry__c like :tempSearchText or description__c like :tempSearchText or opentext_id_formula__c like:tempSearchText];
if(lstspec.size()<1){
    bSearchMessage=true;
    }
else{
for(design_spec__c ds:lstspec){
    searchResultWrapper.add(new specWrapper(ds) );        
}
}
return null;
}

public PageReference addToPackage(){
    set<string> setSpecs=new set<string>();
    if(lstPckgSpec==null)
        lstPckgSpec=new list<design_spec__c>();
    if(lstPckgSpec!=null && lstPckgSpec.size()>0 ){
        for(design_spec__c ps:lstPckgSpec)
            setSpecs.add(ps.id);
    }
    for(specWrapper  sw:searchResultWrapper){
        if(sw.checked && !setSpecs.contains(sw.s.id)){
            lstPckgSpec.add(sw.s);  
            setSpecs.add(sw.s.id);  
        }
    }
    return null;
}

public pageReference removeSpec(){
    system.debug('intial size:'+lstPckgSpec.size());
    system.debug(lstPckgSpec[0].id+':list Spec Id::remSpecId:'+remSpecId);
    list<design_spec__c> temp=new list<design_spec__c>();
    temp=lstPckgSpec.deepClone(true,true,true);
    if(remSpecId!=null){
        for(integer i=0;i<temp.size();i++){
            if(temp[i].id==remSpecId){
                system.debug('coming inside remove block.');
                lstPckgSpec.remove(i);
                break;
            }
        }
    }
    system.debug('after removal size:'+lstPckgSpec.size());
    return null;
}

public pageReference clearSearchResult(){
    if(searchResultWrapper.size()>0)
    searchResultWrapper.clear();
    return null;
}

public pageReference save(){
    list<package_spec__c> lPspec=new list<package_spec__c>();
    for(design_spec__c ds:lstPckgSpec){
        lPspec.add(new package_spec__c(package__c=pckg.id,Design_Spec__c=ds.id));    
    }
    try{
    insert lPspec;
    return new pageReference('/'+ApexPages.currentPage().getParameters().get('id'));
    }
    catch(exception e){
        system.debug('Exception:'+e.getMessage());
        return null;
    }
}

public pageReference cancel(){
    return new pageReference('/'+ApexPages.currentPage().getParameters().get('id'));
}

public class specWrapper {
public boolean checked{get;set;}
public Design_spec__c s {get;set;}

public specWrapper(){
checked=false;
s=new design_spec__c();
}
public specWrapper(design_spec__c spec){
checked=false;
s=spec;
}
}

}