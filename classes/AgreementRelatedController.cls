/*
Type Name: AgreementRelatedController
Author: Suvajit Majumder

Test Class: 
Change History:
Author: 
Modified Date: 
……..
……..//
--
*/

global with sharing class AgreementRelatedController{

public List<NDAWrapper> lstSetController{get;set;}

public transient String QueryAgr;
private final Id agrid;
public final Apttus__APTS_Agreement__c objAgr{get; set;}
public String SearchName 
    {
        get;
        set
        {
        if(value!=NULL) 
            SearchName = value.trim();
        }        
    }
public String SearchAgrNumber
    {
        get; 
        set 
        {
          if(value!=NULL) 
            SearchAgrNumber = value.trim();
        }
     }
public String AccountName
    {
        get; 
        set 
        {
            if(value!=NULL) 
                AccountName= value.trim();
         }
     }
public String OwnerName 
    {
        get; 
        set 
        {
            if(value!=NULL) 
                OwnerName = value.trim();
         }
    }
public list<NDAWrapper> AgrSearchList {get;set;}
public transient List<Id> AlreadyLinkedList;
CustomIterable obj {get;set;}

public String contextItem{get;set;}


public Set<Id> selectedAgrIds;



    public AgreementRelatedController() {
    
      
       //init variable
       this.selectedAgrIds= new Set<Id>(); 
      
       AgrSearchList  = new list<NDAWrapper>();             
       lstSetController = new list<NDAWrapper>();
       
       obj= new CustomIterable (AgrSearchList);
       
        if(isNotBlank(ApexPages.currentPage().getParameters().get('Id'))) {
            if(agrid==null)
                if(validateId(ApexPages.currentPage().getParameters().get('Id'))!=null)
                    agrid = ApexPages.currentPage().getParameters().get('Id');
            
            if(agrid!=null){
                    if(objAgr ==null)
                        objAgr = [Select Id, Apttus__FF_Agreement_Number__c,Name,RecordTypeId from Apttus__APTS_Agreement__c where Id =: agrid];         
            }
        } 
        
       
             
    }
    
    
    
    public Boolean hasNext
        {
            get 
            {
                return obj.hasNext();
            }
            set;
        }
        
        public Boolean hasPrevious
        {
            get 
            {
                return obj.hasPrevious();
            }
            set;
        }
        
        public void next() 
        {
            lstSetController = obj.next();
        }
        
        public void previous() 
        {
            lstSetController = obj.previous();
        }
        
        
        
        public void doSelectItem()
        {
        
        this.selectedAgrIds.add(this.contextItem);
        
        }
        
        
       
    
    
    /*
    *   handle item deselected
    */
    public void doDeselectItem(){
        
        this.selectedAgrIds.remove(this.contextItem);
        
    }
    
    
        
    
    
    /*
    *   return count of selected items
    */
    public Integer getSelectedCount()
    {
        
        return this.selectedAgrIds.size();
        
    }
    
    public Integer getTotalCount()
    {
        
        return this.AgrSearchList.size();
        
    }
    
    
    /***
    * SearchAgreement - set search criteria fields and refresh Agreements table
    ***/
    public PageReference SearchAgreement() 
    { 
    
    
        getAgrList();
        return null;
    }
    public void getAgrList() {
        if (isNotBlank(SearchName) || isNotBlank(SearchAgrNumber) || isNotBlank(AccountName) || isNotBlank(OwnerName)){        
            transient list < Apttus__APTS_Agreement__c > listAgr = new list < Apttus__APTS_Agreement__c > ();
            if(AgrSearchList !=null)
            {
                AgrSearchList.clear();
                selectedAgrIds.clear();
                lstSetController.clear();
            }
                
            BuildQuery();
            
           
            System.debug('Dynamic query is:='+QueryAgr);
            
           
            listAgr = Database.Query(QueryAgr);
            if(listAgr != null && listAgr.size()>0)
            {
                for(Apttus__APTS_Agreement__c agr : listAgr)
                {
                     AgrSearchList.add(new NDAWrapper(false,agr));               
                }
            }
        }else{
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.Error, 'Please enter any search string(Name/Agreement Number/Account Name/Agreement Owner).'));
        }         
        
        lstSetController=  new list<NDAWrapper>();  
        obj = new CustomIterable (AgrSearchList); 
        obj.setPageSize = 5;
        
        next();
        
    }
    
    /**
    This method is used for Adding & Validating Agreement records
    @method name: add
    @parameter:   NA.
    @return :     NA.
    **/
    

    public PageReference Link() {
        
        transient Set<String> setTempIds = new Set<String>();
        transient List<Linked_and_Associated_Contract__c> linkerlist=new List<Linked_and_Associated_Contract__c>();
        transient Linked_and_Associated_Contract__c linkerobj=new Linked_and_Associated_Contract__c();
        transient List<Id> selectedRecToLink=new List<Id>();
        transient Map<Id,Id> RefMap=new Map<Id,Id>(); 
        PageReference pr = null; 
        integer agrCount = 0;
        try{
            if(!AgrSearchList.isEmpty()) 
            {
                for(NDAWrapper agr : AgrSearchList)
                {
                    
                    if(agr.isChecked)
                    {
                        
                        selectedRecToLink.add(agr.objAgr.id);
                        agrCount ++;
                    }
                }
                for(Linked_and_Associated_Contract__c linkobj:[select Top_Level_Agreement__c,Child_Level_Agreement__c from Linked_and_Associated_Contract__c where (Child_Level_Agreement__c=: objAgr.id and Top_Level_Agreement__c in :selectedRecToLink) OR (Top_Level_Agreement__c =: objAgr.id and Child_Level_Agreement__c in :selectedRecToLink)])
                        RefMap.put(linkobj.Top_Level_Agreement__c,linkobj.Child_Level_Agreement__c);
                        
                for(Id i:selectedRecToLink)
                {
                    if(RefMap.containsKey(objAgr.id) && i==RefMap.get(objAgr.id))
                        continue;
                    else
                        {
                            linkerobj=new Linked_and_Associated_Contract__c();
                            linkerobj.Top_Level_Agreement__c=objAgr.id;
                            linkerobj.Child_Level_Agreement__c=i;
                            linkerlist.add(linkerobj);
                        }    
                        
                    if(RefMap.containsKey(i) && objAgr.id==RefMap.get(i))
                        continue;
                    else
                        {
                            linkerobj=new Linked_and_Associated_Contract__c();
                            linkerobj.Top_Level_Agreement__c=i;
                            linkerobj.Child_Level_Agreement__c=objAgr.id;
                            linkerlist.add(linkerobj);
                        }     
                            
                }
                   
            }
            
            if(agrCount == 0)
            {
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.Error, 'No records were selected, please select at least one record to link.'));
            }else if(agrCount > 0)
            {                
                    if(linkerlist !=null && linkerlist.size()>0)
                    {
                       insert linkerlist;
                       pr = new PageReference('/'+agrid);                   
                    }
            }
        }catch(Exception e){ApexPages.addMessage(new ApexPages.message(ApexPages.severity.Error, 'Error Occurred ' + e.getMessage()));}
         return pr;
    }
    
    
    /***
    * BuildQuery - build query command for list selection change
    ***/
    public void BuildQuery() 
    {
        List<Apttus__APTS_Agreement__c> exclusionAgrs= [Select id from Apttus__APTS_Agreement__c where id in (select Child_Level_Agreement__c from Linked_and_Associated_Contract__c where Top_Level_Agreement__c =: ObjAgr.id)];
        exclusionAgrs.add(objAgr);
        
        AlreadyLinkedList=new List<Id>();
        
        for(Apttus__APTS_Agreement__c agr:exclusionAgrs)
            AlreadyLinkedList.add(agr.id);
        
        String QueryWhere = '';
        QueryAgr = 'SELECT Id,Name,Apttus__FF_Agreement_Number__c,CLM_Contract_Type__c,Apttus__Status_Category__c, Apttus__Status__c  , GF_Department_Name__c,CreatedBy.Id ,Apttus__Account__r.Name, Apttus__Account__c, GF_Contract_Start_Date__c,GF_Contract_End_Date__c,RecordTypeId,RecordType.Name,Owner.Name,CreatedDate,CreatedBy.Name,LastModifiedDate FROM Apttus__APTS_Agreement__c';
        
       
             
        if (SearchName != null && SearchName !='') 
        {
            QueryWhere = BuildWhere(QueryWhere, ' (Name LIKE \'%' + String.escapeSingleQuotes(SearchName) + '%\')');
        }
        
         if (AccountName!= null && AccountName!='') 
        {
            QueryWhere = BuildWhere(QueryWhere, ' (Apttus__Account__r.Name LIKE \'%' + String.escapeSingleQuotes(AccountName) + '%\')');
        }
        
        
        if (SearchAgrNumber!= null && SearchAgrNumber!='') 
        {
            QueryWhere = BuildWhere(QueryWhere, ' (Apttus__FF_Agreement_Number__c LIKE \'%' + String.escapeSingleQuotes(SearchAgrNumber) + '%\')');
        }               
        if (OwnerName!= null && OwnerName!='') 
        {
            QueryWhere = BuildWhere(QueryWhere, ' (CreatedBy.Name LIKE \'%' + String.escapeSingleQuotes(OwnerName) + '%\')');            
        }
        QueryAgr+= QueryWhere;  
        QueryAgr+= ') and  (Id  NOT IN: AlreadyLinkedList) ORDER BY LastModifiedDate LIMIT 50000';
        
      
        
    }
    
    /***
    * BuildWhere - build soql string for where criteria 
    ***/
    public String BuildWhere(String QW, String Cond) {
        if (QW == '') {
            return ' WHERE (' + Cond;
        } else {
            return QW + ' OR ' + Cond;            
        }
    }
    
    /***
    * isNotBlank- check the string null or blank
    ***/
    public static Boolean isNotBlank(String val){
        if(val <> null && val <> '' && val <> 'null'){
            return true;
        }
        return false;
    }
    
    /***
    * ClearAgreementSelectedSet - remove selected NDAs and initialize counter
    ***/
    public PageReference ClearAll(){
        SearchName = '';
        SearchAgrNumber = '';
        OwnerName ='';
        AccountName='';
        if(AgrSearchList !=null)
        {
            AgrSearchList.clear();
            lstSetController.clear();
            selectedAgrIds.clear();
            obj.i=0;
        }
        return null;
    }
     /**
    This method is used for validating Agreement Ids & users Ids
    @method name: validateId
    @parameter:   String Agreement Id.
    @return :     String Agreement Id.
    **/
    static public String validateId(String Idparam) {
        String id = String.escapeSingleQuotes(Idparam);
        if ((id.length() == 15 || id.length() == 18) && Pattern.matches('^[a-zA-Z0-9]*$', id)) {
            return id;
        }
        return null;
    }
    
    public PageReference closeEvent() {        
        PageReference pr = new PageReference('/'+agrid);
        return pr;
    }
    
     /**
    This class is used for creating mapping between isChecked & Agreement Records.
    @Class name: NDAWrapper
    @parameter:   NA.
    @return :     NA.
    **/
    global class NDAWrapper
    {
        public boolean isChecked{get;set;}
        public Apttus__APTS_Agreement__c objAgr{get;set;}

        public NDAWrapper(boolean x,Apttus__APTS_Agreement__c y)
        {
            isChecked = x;
            objAgr = y;
        }
    }
    


global class  CustomIterable implements Iterator<list<NDAWrapper>>
{ 
   list<NDAWrapper> InnerList{get; set;}
   list<NDAWrapper> ListRequested{get; set;}

   Integer i {get; set;} 
   public Integer setPageSize {get; set;} 

   public CustomIterable(List<NDAWrapper> lstNDAWr)
   {
       InnerList = new list<NDAWrapper>(); 
       ListRequested = new list<NDAWrapper>();     
       InnerList = lstNDAWr;
       setPageSize = 10;
       i = 0; 
   }   

   global boolean hasNext(){ 
       if(i >= InnerList.size()) {
           return false; 
       } else {
           return true; 
       }
   } 
   
   global boolean hasPrevious(){ 
        
       if(i <= setPageSize) {
           return false; 
       } else {
           return true; 
       }
   }   

   global list<NDAWrapper> next(){       
       
       ListRequested = new list<NDAWrapper>(); 
       integer startNumber;
       integer size = InnerList.size();
       if(hasNext())
       {  
           if(size <= (i + setPageSize))
           {
               startNumber = i;
               i = size;
           }
           else
           {
               i = (i + setPageSize);
               startNumber = (i - setPageSize);
           }
           
           
           
           for(integer start = startNumber; start < i; start++)
           {
               ListRequested.add(InnerList[start]);
           }
       } 
       return ListRequested;
   } 
   
   global list<NDAWrapper> previous(){      
       ListRequested = new list<NDAWrapper>(); 
       
       integer size = InnerList.size(); 
       if(i == size)
       {
           if(math.mod(size, setPageSize) > 0)
           {    
               i = size - math.mod(size, setPageSize);
           }
           else
           {
               i = (size - setPageSize);
           } 
       }
       else
       {
           i = (i - setPageSize);
       }
       
        
       
       for(integer start = (i - setPageSize); start < i; ++start)
       {
           ListRequested.add(InnerList[start]);
       } 
       return ListRequested;
   }   
}
    
}