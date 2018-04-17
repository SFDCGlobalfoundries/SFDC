/**
* Author        :   Yash
* Company       :   IBM India.
* Description   :   New Functionality added according to account Recordtype to visible Supplier section.
* History       :
        Initials        Date                Description
-----------------------------------------------------------------------------------------
        Ykumar          11/02/2014          Created the Class
        
**/

public class TabAccessCreatePageController
{
    public TabAccessCreatePageController(ApexPages.StandardController controller){}
    
    public static Boolean SupplierSection
    {
        get
        {
            if(SupplierSection==NULL)
                if(PTARec<>NULL)
                    if(PTARec.Account__r.RecordType.DeveloperName=='Suppliers')
                        SupplierSection=true;
                     else
                        SupplierSection=false;    
            return SupplierSection;            
        }
        set;
    }
    
    
    public static Boolean NotSupplierSection
    {
        get
        {
            if(NotSupplierSection==NULL)
                if(PTARec<>NULL)
                    if(PTARec.Account__r.RecordType.DeveloperName<>'Suppliers')
                        NotSupplierSection=true;
                     else
                        NotSupplierSection=false;    
            return NotSupplierSection;            
        }
        set;
    }
    
    public static Boolean isVendorPortalUser
    {
        get
        {
            Set<String> DeptValues=new Set<String>();
            if(isVendorPortalUser==NULL)
                if(PTARec<>NULL)
                    if(PTARec.Contact__r.Department__c <>NULL)
                        {
                            System.debug('logic is here=');
                            DeptValues.addAll(String.valueof(PTARec.Contact__r.Department__c).split(';'));                            
                            if(DeptValues.contains('Vendor Services'))
                                isVendorPortalUser=true;
                            else
                                isVendorPortalUser=false;    
                        }
                          
             return isVendorPortalUser;                   
        }
        set;
    }
 
    public static Id AccessId
    {
        get
        {
            AccessId=NULL;
            if(AccessId==NULL) AccessId=(Id)ApexPages.currentPage().getParameters().get('id');
            if(AccessId<>NULL) return AccessId;
            return AccessId;
        }
        
        set;
    }
    public static Portal_Tab_Access__c PTARec
    {
        get
        {
            if(PTARec==NULL)
            {
                PTARec=new Portal_Tab_Access__c();
                if(AccessId !=null) PTARec=[select id,Account__r.RecordType.DeveloperName,Contact__r.Department__c from Portal_Tab_Access__c where id=:AccessId limit 1][0];
            }
            return  PTARec;
            
        }
        set;
    }
    
    
}