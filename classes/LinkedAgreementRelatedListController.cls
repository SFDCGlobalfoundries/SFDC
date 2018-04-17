public class LinkedAgreementRelatedListController{
    
    public List<Apttus__APTS_Agreement__c> agreements{get;set;}
    public String SelectedAgrId{get;set;}
    public ApexPages.StandardController stdController;
    public final Apttus__APTS_Agreement__c CurrAgr;
    public final Apttus__APTS_Agreement__c objAgr{get; set;}
  
  
    //pagination variables
       public List<Apttus__APTS_Agreement__c> lstSetController{get;set;}
       CustomIterable obj {get;set;}
        
     //pagination code starts here 
          
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
        
      //pagination code ends here 
      
        
  public pageReference getCallLinkerSearchPage() 
{
        pageReference pg = new pageReference('/apex/Related_Agreements?Id='+CurrAgr.Id);
        pg.setRedirect(true);
        return pg;
}





  public pageReference getCallUnLinkerPage() 
{
        pageReference pg = new pageReference('/apex/UnRelate_Agreements?Id='+CurrAgr.Id);
        pg.setRedirect(true);
        return pg;
}
    
    public LinkedAgreementRelatedListController(ApexPages.StandardController stdController) 
    {
        this.stdController = stdController;
        this.CurrAgr= (Apttus__APTS_Agreement__c)stdController.getRecord();
                
        if(CurrAgr!=null)
             objAgr = [Select Id,Apttus__FF_Agreement_Number__c from Apttus__APTS_Agreement__c where Id =: CurrAgr.Id]; 
          
        loadData();
      
       
    }
        
    public void loadData() 
    {
            
        agreements= [Select id,Name,Apttus__FF_Agreement_Number__c,CLM_Contract_Type__c,GF_Contract_Start_Date__c,GF_Contract_End_Date__c, Apttus__Account__r.Name,CLM_XREF_ID__c,Apttus__Status__c from Apttus__APTS_Agreement__c where id in (select Child_Level_Agreement__c from Linked_and_Associated_Contract__c where Top_Level_Agreement__c =: CurrAgr.id) Order By CreatedDate desc];
        
        lstSetController=  new list<Apttus__APTS_Agreement__c>();  
        obj = new CustomIterable (agreements); 
        obj.setPageSize = 3;
        next();        
        
    }
    
    public void deleteAgr()
    {
        if(SelectedAgrId== null)
            return;
        
        //find the agreement record within the collection
        
        Apttus__APTS_Agreement__c tobeDeleted = null;
        for(Apttus__APTS_Agreement__c agr :agreements)
        {
            if(agr.Id == SelectedAgrId)
            {
                tobeDeleted = agr;
                break;
            }
        }    
            
            //if agreement record found delete it
            if(tobeDeleted != null)
            {
                Delete tobeDeleted;
            }
            
            //refresh the data
            loadData();
        
    }
    
 public class  CustomIterable implements Iterator<list<Apttus__APTS_Agreement__c >>
{ 
   list<Apttus__APTS_Agreement__c > InnerList{get; set;}
   list<Apttus__APTS_Agreement__c > ListRequested{get; set;}

   Integer i {get; set;} 
   public Integer setPageSize {get; set;} 

   public CustomIterable(List<Apttus__APTS_Agreement__c > lstNDA)
   {
       InnerList = new list<Apttus__APTS_Agreement__c >(); 
       ListRequested = new list<Apttus__APTS_Agreement__c >();     
       InnerList = lstNDA;
       setPageSize = 6;
       i = 0; 
   }   

   public boolean hasNext(){ 
       if(i >= InnerList.size()) {
           return false; 
       } else {
           return true; 
       }
   } 
   
   public boolean hasPrevious(){ 
        
       if(i <= setPageSize) {
           return false; 
       } else {
           return true; 
       }
   }   

   public list<Apttus__APTS_Agreement__c > next(){       
       
       ListRequested = new list<Apttus__APTS_Agreement__c >(); 
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
   
   public list<Apttus__APTS_Agreement__c > previous(){      
       ListRequested = new list<Apttus__APTS_Agreement__c >(); 
       
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