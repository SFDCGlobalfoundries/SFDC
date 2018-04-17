public class clsVFAddPackageSpecController {
public string searchText{get;set;}
    public string searchTechGeoText{get;set;}//Added for Case#2438
    public string searchtechTypeText{get;set;}//Added for Case#2438
    public string isRevision{get;set;}//Added for Case#2438    
    public boolean isLatestRevision{get; set;} //Added for Case#2438
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
public clsVFAddPackageSpecController(ApexPages.StandardController controller) {
    pckg=(package__c)controller.getRecord();
    isLatestRevision=False;
}
//Modified for Case#2438
    public pageReference searchSpecs(){
/*------------added for Case 31128 start--------------------------------*/

         searchTechGeoText=pckg.Tech_Geometry__c;
         
/*------------added for Case 31128 end-------------------------------------------*/   
        if((searchtext!=null && searchtext.length()>1)||(searchTechGeoText!=null && searchTechGeoText.length()>1)||(searchtechTypeText!=null && searchtechTypeText.length()>1)){
            string tempsearchText='%'+searchText+'%';
            // string tempTechGeoText='%'+searchTechGeoText+'%';//commented for Case 31128
            string tempTechGeoText=searchTechGeoText;//added for Case 31128
            string temptechTypeText='%'+searchtechTypeText+'%';
            boolean latestRevision=isLatestRevision;
            list<design_spec__c> lstSpec=new list<design_spec__c>();
            if(searchResultWrapper.size()>0)
                searchResultWrapper.clear();
            if(latestRevision)
            {    
            /*   //lstspec=[select id,Name,Document_Number__c,Revision__c,Specification_Type__c,Technology_Type__c,Technology_Geometry__c,Spec_Description__c,Is_Latest_Revision__c  from design_spec__c where (Name like :tempSearchText OR Document_Number__c like :tempSearchText or Revision__c like :tempSearchText or Specification_Type__c like :tempSearchText or Technology_Type__c like :tempSearchText or  Technology_Geometry__c like :tempSearchText or description__c like :tempSearchText or opentext_id_formula__c like:tempSearchText) and recordtype.Name like '%Design_Specs%' and id Not in (select design_spec__c from package_spec__c where package__c=:pckg.id) and Technology_Type__c like :temptechTypeText and  Technology_Geometry__c like :tempTechGeoText and Is_Latest_Revision__c =: latestRevision Order by Name Limit 100];//commented for case 22610
                //lstspec=[select id,Name,Document_Number__c,Revision__c,Specification_Type__c,Technology_Type__c,Technology_Geometry__c,Spec_Description__c,Is_Latest_Revision__c  from design_spec__c where (Name like :tempSearchText OR Document_Number__c like :tempSearchText or Revision__c like :tempSearchText or Specification_Type__c like :tempSearchText or Technology_Type__c like :tempSearchText or  Technology_Geometry__c like :tempSearchText or opentext_id_formula__c like:tempSearchText) and recordtype.Name like '%Design_Specs%' and id Not in (select design_spec__c from package_spec__c where package__c=:pckg.id) and Technology_Type__c like :temptechTypeText and  Technology_Geometry__c like :tempTechGeoText and Is_Latest_Revision__c =: latestRevision Order by Name Limit 100];//commented for Case 31128
             lstspec=[select id,Name,Document_Number__c,Revision__c,Specification_Type__c,Technology_Type__c,Technology_Geometry__c,Spec_Description__c,Is_Latest_Revision__c  from design_spec__c where (Name like :tempSearchText OR Document_Number__c like :tempSearchText or Revision__c like :tempSearchText or Specification_Type__c like :tempSearchText or Technology_Type__c like :tempSearchText or opentext_id_formula__c like:tempSearchText) and recordtype.Name like '%Design_Specs%' and Specification_Type__c !='IP Design Kit' and id Not in (select design_spec__c from package_spec__c where package__c=:pckg.id) and Technology_Type__c like :temptechTypeText and  Technology_Geometry__c =:tempTechGeoText and Is_Latest_Revision__c =: latestRevision Order by Name Limit 100]; //added for Case 31128//modified for case 34664
             }
             else{
                //lstspec=[select id,Name,Document_Number__c,Revision__c,Specification_Type__c,Technology_Type__c,Technology_Geometry__c,Description__c,Is_Latest_Revision__c  from design_spec__c where (Name like :tempSearchText OR Document_Number__c like :tempSearchText or Revision__c like :tempSearchText or Specification_Type__c like :tempSearchText or Technology_Type__c like :tempSearchText or  Technology_Geometry__c like :tempSearchText or description__c like :tempSearchText or opentext_id_formula__c like:tempSearchText) and recordtype.Name like '%Design_Specs%' and id Not in (select design_spec__c from package_spec__c where package__c=:pckg.id) and Technology_Type__c like :temptechTypeText and  Technology_Geometry__c like :tempTechGeoText Order by Name Limit 100];//commented for 22610
               //lstspec=[select id,Name,Document_Number__c,Revision__c,Specification_Type__c,Technology_Type__c,Technology_Geometry__c,Spec_Description__c,Is_Latest_Revision__c  from design_spec__c where (Name like :tempSearchText OR Document_Number__c like :tempSearchText or Revision__c like :tempSearchText or Specification_Type__c like :tempSearchText or Technology_Type__c like :tempSearchText  or  Technology_Geometry__c like :tempSearchText or opentext_id_formula__c like:tempSearchText) and recordtype.Name like '%Design_Specs%' and id Not in (select design_spec__c from package_spec__c where package__c=:pckg.id) and Technology_Type__c like :temptechTypeText and  Technology_Geometry__c like :tempTechGeoText Order by Name Limit 100];//commented for Case 31128
               
               lstspec=[select id,Name,Document_Number__c,Revision__c,Specification_Type__c,Technology_Type__c,Technology_Geometry__c,Spec_Description__c,Is_Latest_Revision__c  from design_spec__c where (Name like :tempSearchText OR Document_Number__c like :tempSearchText or Revision__c like :tempSearchText or Specification_Type__c like :tempSearchText or Technology_Type__c like :tempSearchText  or opentext_id_formula__c like:tempSearchText) and recordtype.Name like '%Design_Specs%' and Specification_Type__c !='IP Design Kit' and id Not in (select design_spec__c from package_spec__c where package__c=:pckg.id) and Technology_Type__c like :temptechTypeText and  Technology_Geometry__c =:tempTechGeoText Order by Name Limit 100];//added for Case 31128//modified for case 34664
               }*///commented for case 35521
/*--------- added for case 35521 start-------------------------------------------------------------------------------------*/                 
                     if(searchtechTypeText=='' && searchtext=='')
                     {
                     system.debug('enter temptechTypeText==null');
                     lstspec=[select id,Name,Document_Number__c,Revision__c,Specification_Type__c,Technology_Type__c,Technology_Geometry__c,Spec_Description__c,Is_Latest_Revision__c  from design_spec__c where (Name like :tempSearchText OR Document_Number__c like :tempSearchText or Revision__c like :tempSearchText or Specification_Type__c like :tempSearchText  or opentext_id_formula__c like:tempSearchText) and recordtype.Name like '%Design_Specs%' and Specification_Type__c !='IP Design Kit' and id Not in (select design_spec__c from package_spec__c where package__c=:pckg.id) and  Technology_Geometry__c =:tempTechGeoText and Is_Latest_Revision__c =: latestRevision Order by Name Limit 100]; //added for Case 31128//modified for case 34664
                     
                     }
                     
                     else if(searchtechTypeText=='' && searchtext!='')
                     {
                     system.debug('enter else temptechTypeText==null');
                     lstspec=[select id,Name,Document_Number__c,Revision__c,Specification_Type__c,Technology_Type__c,Technology_Geometry__c,Spec_Description__c,Is_Latest_Revision__c  from design_spec__c where (Name like :tempSearchText OR Document_Number__c like :tempSearchText or Revision__c like :tempSearchText or Specification_Type__c like :tempSearchText or Technology_Type__c like :tempSearchText or opentext_id_formula__c like:tempSearchText) and recordtype.Name like '%Design_Specs%' and Specification_Type__c !='IP Design Kit' and id Not in (select design_spec__c from package_spec__c where package__c=:pckg.id)  and  Technology_Geometry__c =:tempTechGeoText and Is_Latest_Revision__c =: latestRevision Order by Name Limit 100]; //added for Case 31128//modified for case 34664
                     }
                     
                     else
                     {
                     lstspec=[select id,Name,Document_Number__c,Revision__c,Specification_Type__c,Technology_Type__c,Technology_Geometry__c,Spec_Description__c,Is_Latest_Revision__c  from design_spec__c where (Name like :tempSearchText OR Document_Number__c like :tempSearchText or Revision__c like :tempSearchText or Specification_Type__c like :tempSearchText or Technology_Type__c like :tempSearchText or opentext_id_formula__c like:tempSearchText) and recordtype.Name like '%Design_Specs%' and Specification_Type__c !='IP Design Kit' and id Not in (select design_spec__c from package_spec__c where package__c=:pckg.id) and Technology_Type__c like :temptechTypeText and  Technology_Geometry__c =:tempTechGeoText and Is_Latest_Revision__c =: latestRevision Order by Name Limit 100]; //added for Case 31128//modified for case 34664
                     
                     }
             }
             else{
                //lstspec=[select id,Name,Document_Number__c,Revision__c,Specification_Type__c,Technology_Type__c,Technology_Geometry__c,Description__c,Is_Latest_Revision__c  from design_spec__c where (Name like :tempSearchText OR Document_Number__c like :tempSearchText or Revision__c like :tempSearchText or Specification_Type__c like :tempSearchText or Technology_Type__c like :tempSearchText or  Technology_Geometry__c like :tempSearchText or description__c like :tempSearchText or opentext_id_formula__c like:tempSearchText) and recordtype.Name like '%Design_Specs%' and id Not in (select design_spec__c from package_spec__c where package__c=:pckg.id) and Technology_Type__c like :temptechTypeText and  Technology_Geometry__c like :tempTechGeoText Order by Name Limit 100];//commented for 22610
               //lstspec=[select id,Name,Document_Number__c,Revision__c,Specification_Type__c,Technology_Type__c,Technology_Geometry__c,Spec_Description__c,Is_Latest_Revision__c  from design_spec__c where (Name like :tempSearchText OR Document_Number__c like :tempSearchText or Revision__c like :tempSearchText or Specification_Type__c like :tempSearchText or Technology_Type__c like :tempSearchText  or  Technology_Geometry__c like :tempSearchText or opentext_id_formula__c like:tempSearchText) and recordtype.Name like '%Design_Specs%' and id Not in (select design_spec__c from package_spec__c where package__c=:pckg.id) and Technology_Type__c like :temptechTypeText and  Technology_Geometry__c like :tempTechGeoText Order by Name Limit 100];//commented for Case 31128
                   if(searchtechTypeText=='' && searchtext=='')
                     {
                     lstspec=[select id,Name,Document_Number__c,Revision__c,Specification_Type__c,Technology_Type__c,Technology_Geometry__c,Spec_Description__c,Is_Latest_Revision__c  from design_spec__c where (Name like :tempSearchText OR Document_Number__c like :tempSearchText or Revision__c like :tempSearchText or Specification_Type__c like :tempSearchText  or opentext_id_formula__c like:tempSearchText) and recordtype.Name like '%Design_Specs%' and Specification_Type__c !='IP Design Kit' and id Not in (select design_spec__c from package_spec__c where package__c=:pckg.id) and  Technology_Geometry__c =:tempTechGeoText Order by Name Limit 100];//added for Case 31128//modified for case 34664
                     }
                   else if(searchtechTypeText=='' && searchtext!='')
                     {
                     lstspec=[select id,Name,Document_Number__c,Revision__c,Specification_Type__c,Technology_Type__c,Technology_Geometry__c,Spec_Description__c,Is_Latest_Revision__c  from design_spec__c where (Name like :tempSearchText OR Document_Number__c like :tempSearchText or Revision__c like :tempSearchText or Specification_Type__c like :tempSearchText  or Technology_Type__c like :tempSearchText or opentext_id_formula__c like:tempSearchText) and recordtype.Name like '%Design_Specs%' and Specification_Type__c !='IP Design Kit' and id Not in (select design_spec__c from package_spec__c where package__c=:pckg.id) and  Technology_Geometry__c =:tempTechGeoText Order by Name Limit 100];//added for Case 31128//modified for case 34664
                     
                     }  
                     
                   else
                   {
                   lstspec=[select id,Name,Document_Number__c,Revision__c,Specification_Type__c,Technology_Type__c,Technology_Geometry__c,Spec_Description__c,Is_Latest_Revision__c  from design_spec__c where (Name like :tempSearchText OR Document_Number__c like :tempSearchText or Revision__c like :tempSearchText or Specification_Type__c like :tempSearchText  or Technology_Type__c like :tempSearchText or opentext_id_formula__c like:tempSearchText) and recordtype.Name like '%Design_Specs%' and Specification_Type__c !='IP Design Kit' and id Not in (select design_spec__c from package_spec__c where package__c=:pckg.id) and Technology_Type__c like :temptechTypeText and  Technology_Geometry__c =:tempTechGeoText Order by Name Limit 100];//added for Case 31128//modified for case 34664
                    
                   }  
                     
               }
/*---------added for case 35521 end-------------------------------------------------------------------------------------*/                    
               
               system.debug('lstspec***'+lstspec);
            if(lstspec.size()<1){
                bSearchMessage=true;
            }
            else{
                for(design_spec__c ds:lstspec){
                    searchResultWrapper.add(new specWrapper(ds) ); 
                    bSearchMessage=false;       
                }
            }
        }
        else{
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Please provide atleast 2 characters to search for!'));
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
    //system.debug('intial size:'+lstPckgSpec.size());
    //system.debug(lstPckgSpec[0].id+':list Spec Id::remSpecId:'+remSpecId);
    list<design_spec__c> temp=new list<design_spec__c>();
    temp=lstPckgSpec.deepClone(true,true,true);
    if(remSpecId!=null){
        for(integer i=0;i<temp.size();i++){
            if(temp[i].id==remSpecId){
                lstPckgSpec.remove(i);
                break;
            }
        }
    }
    return null;
}

public pageReference clearSearchResult(){
    if(searchResultWrapper.size()>0)
    searchResultWrapper.clear();
    searchText=null;
    searchTechGeoText=null;
    searchtechTypeText=null;
    isLatestRevision=false;
    bSearchMessage=false;  
    return null;
}
 /*           
public pageReference save(){
    try{
    list<package_spec__c> lPspec=new list<package_spec__c>();
    if(lstPckgSpec!=null && lstPckgSpec.size()>0){
    for(design_spec__c ds:lstPckgSpec){
        lPspec.add(new package_spec__c(package__c=pckg.id,Design_Spec__c=ds.id));    
    }
    }
    
    insert lPspec;
    return new pageReference('/'+ApexPages.currentPage().getParameters().get('id'));
    }
    catch(DMLexception e){
        system.debug('Exception:'+e.getMessage());
        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,e.getmessage()));
        return null;
    }
}
*/

public pageReference save(){
    try{
        list<package_spec__c> lPspec=new list<package_spec__c>();
        ID packageId =ApexPages.currentPage().getParameters().get('id');
         
        if(lstPckgSpec!=null && lstPckgSpec.size()>0){
            for(design_spec__c ds:lstPckgSpec){
                lPspec.add(new package_spec__c(package__c=pckg.id,Design_Spec__c=ds.id));    
            }
        }
        if (lPspec<>Null && !lPspec.isEmpty()){
            insert lPspec;
        }
        //Code is used to do auto provosioning for adoc specs which will be add in to package and package is already provisioned for other specs. 
        List<Document_Provisioning__c> listOfDocumentProvisionedRecord;
        Map<Id,List<Id>> mapOfPkgAndUserLst = new Map<Id,List<Id>>();
        List<Id> listOfUserIds = new List<Id>();
        ClsProvisioningHandler ProvisioningHandlerObj = new ClsProvisioningHandler();
        system.debug('packageId>>>>>>>>'+packageId);
        if(packageId!=null){
            listOfDocumentProvisionedRecord = [SELECT Id,
                                                      Design_Package__c,
                                                      User__c,
                                                      Status__c
                                               FROM   Document_Provisioning__c
                                               WHERE  Design_Package__c=:packageId 
                                               AND    User__c!=NULL
                                               AND    Status__c='Provisioned'];
                                               
            system.debug('listOfDocumentProvisionedRecord>>>>>>>>>>>>>>'+listOfDocumentProvisionedRecord);                                 
            if (listOfDocumentProvisionedRecord!=null && !listOfDocumentProvisionedRecord.isEmpty()){
                for(Document_Provisioning__c dProvision : listOfDocumentProvisionedRecord){
                    listOfUserIds.add(dProvision.User__c);
                }
                if (listOfUserIds!=null && !listOfUserIds.isEmpty()){
                    mapOfPkgAndUserLst.put(packageId,listOfUserIds);
                    system.debug('Before doProvision>>>>>>');
                    ProvisioningHandlerObj.doProvision(mapOfPkgAndUserLst,'Package');
                    system.debug('After doProvision>>>>>');
                }
            }                                  
        }
        return new pageReference('/'+ApexPages.currentPage().getParameters().get('id'));
        
    } catch(DMLexception e){
        system.debug('Exception:'+e.getMessage());
        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,e.getmessage()));
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