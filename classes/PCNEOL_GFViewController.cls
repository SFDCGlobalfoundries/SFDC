/***************************************************************************************************************************
Class:         PCNEOL_GFViewController 
----------------------------------------------------------------------------------------------------------------------------
Author:        Dinesh M Suggala
Created Date:  11/7/2016
Reason:        This Class is used to show records based on filter criteria

Change Log:    Created     -     Dinesh     -     11/7/2016
               Updated     -     Sameera    -     21/2/2017	 
***************************************************************************************************************************/
public with sharing class PCNEOL_GFViewController {
              public String ACPCN{get;set;}
              public List<SelectOption> stagePCN;
              public String requestor{get;set;}
              public List<SelectOption> requestorvalues;
              public String status{get;set;}
              public List<SelectOption> statusvalues;
              public PCN_EOL__c EOL{get;set;}
              public Date eDate{get;set;}
              public Integer size{get;set;}
              public Integer noOfRecords{get; set;}
              public ApexPages.StandardSetController setCon{get;set;}
              public boolean Isportal;
              //public list<PCNEOLWrapper> PCNEOLwrapperlst;
  			  public string searchValue{get;set;}
  			  public Map<String,PCN_EOL__c> pcnIdPCNMap;
  			  public String Records = 'Yes';
  			  public String CustomLabelValue{get;set;}
			  
              public List<PCNEOLWrapper> listpcn{  
                get  
                {  
                    if(setCon!= null) { 
                        list<PCNEOLWrapper> PCNEOLwrapperlst = new  list<PCNEOLWrapper>();
                        for(PCN_EOL__c pcn:(List<PCN_EOL__c>)setCon.getRecords()){
                          PCNEOLwrapperlst.add(new PCNEOLWrapper(pcn));  
                        }
                        system.debug('PCNEOLwrapperlst%%%'+PCNEOLwrapperlst); 
                        return PCNEOLwrapperlst;
                    }
                    else  
                        if(Records != 'No'){
                        //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Info,'No Results found.Please Change the filter and try again'));
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Info,'Please change the filter and click on search to find records.')); 
                         }
                        return null ;  
                }  
                set;
                }    
             
            //Constructor 
             public PCNEOL_GFViewController (){
             CustomLabelValue=System.Label.EOL_GFV_Content;
             User u = [SELECT Id,ContactId FROM User WHERE Id = :UserInfo.getUserId()];   // Check if the logged in user is portal user
                    
              if (u.ContactId != null) {
                   Isportal= true;
               }
              else{
                   Isportal=false;
               }  
         
             }
          
             public List<SelectOption> getstagePCN(){
                List<SelectOption> options = new List<SelectOption>();       
             // options.add( new SelectOption( 'None', 'None' ));
                options.add( new SelectOption( 'Open PCN', 'Open PCN' ));
                options.add( new SelectOption( 'Closed PCN', 'Closed PCN' )); 
                options.add( new SelectOption( 'Cancelled PCN', 'Cancelled PCN' )); 
                options.add( new SelectOption( 'Rejected PCN', 'Rejected PCN' ));
                return options;
                
             }
            
             public void setstagePCN(List<SelectOption> l ){
                stagePCN=l;
                   
             }       
             
              public List<SelectOption> getrequestorvalues(){  
               Map<String,String> reqstringmap=new Map<String,String>();
                for(PCN_EOL__c s:[Select Id,OwnerId,Owner.Name,CreatedBy.Name,Affected_Part_Numbers__c from PCN_EOL__c])
                {   
                reqstringmap.put(s.OwnerId,Test.IsRunningTest() ? s.CreatedBy.Name : s.Owner.Name);
                }  
                
               List<SelectOption> options = new List<SelectOption>();
               options.add(new SelectOption( 'Select', 'Select' ));          
               for(String c:reqstringmap.KeySet()){
                   if(ACPCN=='Closed PCN' || ACPCN=='Open PCN' || ACPCN=='Cancelled PCN'|| ACPCN=='Rejected PCN'){
                        options.add( new SelectOption(c,reqstringmap.get(c)));
                   }
                 }      
                 return options;
             }  
             
               
               //This method is used to search records based on filter conditions 
               public PageReference refresh() {
                   
                    Records = 'Yes';
                   List<Part_Customer_Infomation__c>  pcinfolist=[Select Name,End_Of_Life__c,IBM_Part_Number__c from Part_Customer_Infomation__c];     
                   set<Id> partset=new set<Id>();
                   for(Part_Customer_Infomation__c pc:pcinfolist)
                   {
                    partset.add(pc.End_Of_Life__c);
                   }
                   
                  //  listpcn=new List<PCN_EOL__c>();
                    if(ACPCN!=null && ACPCN!='None'){

                      String s='Select Id,Name,EOL_Stage__c,CreatedDate,Owner.Name,PCN_Numbers__c,Affected_Part_Numbers__c,(Select Select_Checkbox__c  from Part_Customer_Infomations__r where Select_Checkbox__c =True) from PCN_EOL__c';
            
                      
                     if(ACPCN=='Open PCN'){     
                     s=s+' WHERE (EOL_Stage__c = \'New\' or EOL_Stage__c=\'Submitted, Awaiting LMT Approval\' or EOL_Stage__c=\'Awaiting BU Program Mgr Approval\' OR EOL_Stage__c=\'Sent to Customers\') ';
                     }
                     else if(ACPCN=='Open PCN' && Isportal){
                      s=s+' WHERE (EOL_Stage__c=\'Awaiting BU Program Mgr Approval\' OR EOL_Stage__c=\'Sent to Customers\')';
                      } 
                     else if(ACPCN=='Closed PCN'){
                     s=s+' WHERE (EOL_Stage__c = \'Closed\')';
                     }
                     else if(ACPCN=='Cancelled PCN'){
                      s=s+' WHERE (EOL_Stage__c = \'Cancelled\')';
                     }
                     else if(ACPCN=='Rejected PCN'){
                      s=s+' WHERE (EOL_Stage__c = \'Rejected\')';
                     }
                     
                       //added by Sameera
                    Set<String> searchSTRINGList = new Set<String>();
                    set<Id> partsetFinal=new set<Id>();
                   
                    if(searchValue!=null && searchValue.length()>0){
                        searchValue= searchValue.replaceAll( '\\s+', ''); //find all spaces in the string and replace it with empty string.
                         for(String key :searchValue.split(','))
                         {
                            searchSTRINGList.add(key);
                         }
                        pcnIdPCNMap = new Map<String,PCN_EOL__c>();
                        for(PCN_EOL__c pcn:[Select Id,Affected_Part_Numbers__c from PCN_EOL__c]){
                            pcnIdPCNMap.put(pcn.id,pcn);
                        }
                        if(pcnIdPCNMap!=null && pcnIdPCNMap.size()>0){
                            for(String pcn: pcnIdPCNMap.KeySet()){    
                                String affectedParts= pcnIdPCNMap.get(pcn).Affected_Part_Numbers__c.replaceAll( '\\s+', '');
                                for(String affectedPart: affectedParts.split(',')){
                                    if(searchSTRINGList.contains(affectedPart)){
                                        partsetFinal.add(pcn);
                                    }
                                }   
                            }
                        }  
                        if(partsetFinal.isEmpty()){
                           Records = 'No';
                           ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Info,'No Results found for the part number/numbers entered.Please Change the filter and try again.'));
                           
                        }else{
                            if(s.containsIgnoreCase('WHERE')){
                                    s=s+' AND Id IN : partsetFinal';   
                            }else{
                                   s=s+' WHERE Id IN : partsetFinal';
                            } 
                        }
                    }else{
                          if(s.containsIgnoreCase('WHERE')){
                           s=s+' AND Id IN : partset';
                           }
                          else{
                           s=s+' WHERE Id IN : partset';
                          }
                    }
                    //Added by Sameera 
                     
				   /*  if(Isportal){
                      if(s.containsIgnoreCase('WHERE')){
                       s=s+' AND Id IN : partset';
                       }
                      else{
                       s=s+' WHERE Id IN : partset';
                      }
                     }*/
                     
                   /*  if(requestor!=null && requestor!='Select'){
                      if(s.containsIgnoreCase('WHERE')){
                      s=s+' AND Owner.Id= \''+requestor+'\'';
                      }
                      else{
                      s=s+' WHERE Owner.Id= \''+requestor+'\'';
                      }
                     }*/
                     
                     if(eDate!=null){
                      DateTime dt1=DateTime.newInstance(eDate.year(),eDate.month(),eDate.day(),0,0,0);
                      DateTime dt2=DateTime.newInstance(eDate.year(),eDate.month(),eDate.day(),23,59,59);
                      if(s.containsIgnoreCase('WHERE')){
                       s=s+' AND CreatedDate >: dt1 AND CreatedDate <:dt2 ';
                      }
                      else{
                       s=s+' WHERE CreatedDate >: dt1 AND CreatedDate <:dt2 ';
                      }
                     }
                     
                     s = s  +  ' LIMIT 100' ;
                     system.debug('****s****'+s);  
                     try{
                     if(!Isportal){
                     setCon =new ApexPages.StandardSetController(Database.query(s)); 
                     }
                     else{
                     List<PCN_EOL__c> newlist=new List<PCN_EOL__c>();
                     for(PCN_EOL__c pc:Database.query(s)){
                      if(pc.Part_Customer_Infomations__r.size()>0 || (pc.Part_Customer_Infomations__r.size()==0 && pc.EOL_Stage__c=='Awaiting BU Program Mgr Approval')){
                       newlist.add(pc);                          
                       }
                      }
                         system.debug('newlist%%%'+newlist);                      
                      setCon =new ApexPages.StandardSetController(newlist);
                       system.debug('setCon%%%'+setCon);  
                     }
                     size=10;
                     setCon.setPagesize(size);
                     noofRecords=setCon.getResultSize();      
                      
                     }
                     Catch(Exception e){
                       ApexPages.addMessages( e );
                     }
                     
                     if(listpcn!=null && listpcn.size()==0){
                          //  ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Info,'No Results found.Please Change the filter and try again'));
                              ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Info,'Please change the filter and click on search to find records.'));
                            return null;
                        }                        
                    
                    }  
                 //  if(ACPCN =='None'){
                     if(Records=='No'){
                          setCon = null;                          
                     }
                     return null;
                 }
                 
                 public Boolean hasNext{
                    get{
                      return setCon.gethasPrevious();
                    }
                    set;
                 }
                
                 public Boolean hasPrevious{
                    get{
                      return setCon.gethasPrevious();
                    }
                    set;
                 }
            
                 public void first(){

                    setCon.first();
                 }
                
                 public void last(){
                    setCon.last();
                 }
                
                 public void next(){
                    setCon.next();
                 }
                
                 public void previous(){
                    setCon.previous();
                 }
    
     public Class PCNEOLWrapper{
          		public String Opened{get;set;}          		
        		public PCN_EOL__c pcnWrapper{get;set;}
         public PCNEOLWrapper(PCN_EOL__c newpcn){
               this.pcnWrapper = newpcn;
             if(newpcn.EOL_Stage__c == 'New'||newpcn.EOL_Stage__c == 'Submitted, Awaiting LMT Approval'||newpcn.EOL_Stage__c == 'Awaiting BU Program Mgr Approval'||newpcn.EOL_Stage__c == 'Sent to Customers'){
               this.Opened = 'Open';
             } else
               this.Opened =  newpcn.EOL_Stage__c;
                 
         }
     }
            
  }