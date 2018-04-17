/***************************************************************************************************************************
Class:         PCNEOL_PartCustomerController1
----------------------------------------------------------------------------------------------------------------------------
Author:        Dinesh M Suggala
Created Date:  11/19/2016 
Reason:        This Class is used to show part customer information records per each account and "Notify Customer" button is there to notify customers
Change Log:    Created     -     Dinesh     -     11/19/2016 
                Updated    -    Sameera    -      21/2/2017   
                Updated    -    Dinesh      -     22/11/2017(Production Issue Fixed)
***************************************************************************************************************************/

public with sharing class PCNEOL_PartCustomerController1{
        
        public List<Part_Customer_Infomation__c> partcustomerinfo{get;set;}
        public Map<String,List<Part_Customer_Infomation__c>> PCMap{get;set;}
        public Map<String,List<Account_Team_Proxy__c>> ATMap{get;set;}
        public id Current_Id{get;set;}
        public List<PartCustomerWrapper> listwrapper{get;set;}
        public PCN_EOL__c pcneol;
        public boolean hide{get;set;}
        public boolean Isportal{get;set;}
        public String Template1;
        public String Template2;
        public List<string> listofCc;
        public boolean SAApprove{get;set;}
        public String pgMsg {get;set;}
        public set<String> AccIdset;
        public User u;
        
        //Added by Sameera
        public Map<Id,List<Contact>> AccountIdContactMap=new Map<Id,List<Contact>>();
        public Id accId;
        //constructor
        public PCNEOL_PartCustomerController1 (ApexPages.StandardController controller){         
           if(!test.isRunningTest())
           controller.addFields(new List<String>{'Method_to_contrl_discontinued_device_p_n__c','EOL_Stage__c'});     
           pcneol=(PCN_EOL__c)controller.getRecord(); 
           Current_Id = controller.getRecord().id;
           if(pcneol.EOL_Stage__c=='Awaiting BU Program Mgr Approval' || pcneol.EOL_Stage__c=='Sent to Customers'){
           SAApprove=true;
           }
           
           // Check if the logged in user is portal user
           u = [SELECT Id,ContactId FROM User WHERE Id = :UserInfo.getUserId()];            
           if (u.ContactId != null) {
             Isportal= false;
           }
           else{
             Isportal=true;
           }  
           if(!isportal){
             accId = [SELECT AccountId,Id from Contact where Id=:u.ContactId].AccountId;
            } 
           partcustomerinfo  =new List<Part_Customer_Infomation__c>();    
           partcustomerinfo=[Select Id,Name,Account__c,Account__r.Name,Ultimate_Customer_Account__r.Name,Select_Checkbox__c,Ultimate_Customer_Select_Checbox__c,End_Of_Life__c,End_Of_Life__r.Last_Order_Date__c,End_Of_Life__r.EOL_Stage__c,IBM_Part_Number__c,Ultimate_Customer_Account__c,Shipment_Line_Internal__r.Cust_Part_Num__c,Shipment_Line_Internal__r.PO_Num__c,Shipment_Line_Internal__c,Account__r.Short_Name__c,Shipment_Line_Internal__r.Name,Acknowledged__c,Release_Date__c from Part_Customer_Infomation__c  where End_Of_Life__c=:Current_Id]; 
           Map<String,String> AccMap=new Map<String,String>();
           PCMap=new Map<String,List<Part_Customer_Infomation__c>>();
           AccIdset=new Set<String>();
           Set<String> UltCustIdset= new Set<String>();
           
           if(partcustomerinfo.size()>0){
            for(Part_Customer_Infomation__c pc:partcustomerinfo){
             
             if(!AccMap.ContainsKey(pc.Account__c) && pc.Account__c!=null){
             AccMap.put(pc.Account__c,pc.Account__r.Name);
             AccIdset.add(pc.Account__c);
             }  
            
            if(!AccMap.ContainsKey(pc.Ultimate_Customer_Account__c ) && pc.Ultimate_Customer_Account__c!=null){
             AccMap.put(pc.Ultimate_Customer_Account__c ,pc.Ultimate_Customer_Account__r.Name);
             UltCustIdset.add(pc.Ultimate_Customer_Account__c );
             }
            
              Map<Id,Contact> ContactMap = new Map<Id,Contact>([SELECT Id,Name,Email,AccountId,Is_Portal_User_Active__c,(SELECT Id,PCN_End_of_Life__c,PCRB__c from Access_Setup__r) from Contact where AccountId IN:AccMap.keySet() AND Is_Portal_User_Active__c=:TRUE ]);
            for(Contact x:ContactMap.values()){
                if(x.Access_Setup__r.size()>0 && x.Access_Setup__r[0].PCN_End_of_Life__c ==true && x.Access_Setup__r[0].PCRB__c == true){
                    if(AccountIdContactMap.get(x.AccountId)==null){
                        AccountIdContactMap.put(x.AccountId,new List<Contact>());
                    }
                        AccountIdContactMap.get(x.AccountId).add(x);
                }   
            }
            
            if(!PCMap.ContainsKey(pc.Account__c) && pc.Account__c!=null){
            PCMap.put(pc.Account__c,new List<Part_Customer_Infomation__c>{pc});
             }  
            else if(PCMap.ContainsKey(pc.Account__c) && pc.Account__c!=null){
            PCMap.get(pc.Account__c).add(pc);
             }
            
            if(!PCMap.ContainsKey(pc.Ultimate_Customer_Account__c) && pc.Ultimate_Customer_Account__c!=null){
             PCMap.put(pc.Ultimate_Customer_Account__c ,new List<Part_Customer_Infomation__c>{pc});
             }  
            else if(PCMap.ContainsKey(pc.Ultimate_Customer_Account__c) && pc.Ultimate_Customer_Account__c!=null ){
             PCMap.get(pc.Ultimate_Customer_Account__c).add(pc);
             }
            
            }
           }
           
           ATMap=new Map<String,List<Account_Team_Proxy__c>>();
           listofCc = new List<String>();
           for(Account_Team_Proxy__c a:[Select User__r.Name,User__r.Email,Team_Role__c,Account__c from Account_Team_Proxy__c where Account__c IN: AccMap.Keyset() and (Team_Role__c='Primary Account Manager' or Team_Role__c='Customer Engineer' or Team_Role__c='Primary Customer Service Rep' or Team_Role__c='Primary Field Application Engineer')]){          
               listofCc.add(a.User__r.Email);
               if(!ATMap.containsKey(a.Account__c)){
                    ATMap.put(a.Account__c,new List<Account_Team_Proxy__c>{a});
                } else {
                    ATMap.get(a.Account__c).add(a);
                }
            }
            listwrapper=new List<PartCustomerWrapper>();
            for(String s: AccMap.Keyset()){
               if((!UltCustIdset.contains(s) && !Isportal) || Isportal){
                 listwrapper.add(new PartCustomerWrapper(AccIdset.Contains(s) ? 'AccountID':'UltimateCustomerID',PCMap.get(s),ATMap.get(s),s,AccMap.get(s),AccountIdContactMap));
               }
            }
            
            
            if(listwrapper.size()>0){
             hide=true;   
            }
            else if(listwrapper.isEmpty()){
              hide=false;
              ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Info,' No Records found.');
              ApexPages.addMessage(myMsg);
            }
            

                
            }
             
            //This method is used to Notify Customer 
            public pageReference SendtoCustomer(){
             Savepoint sp = Database.setSavepoint();
             integer count=0;
             pgMsg ='';
             set<String> accountsetcust=new set<String>();
             set<Part_Customer_Infomation__c> pcset=new set<Part_Customer_Infomation__c>();
             for(PartCustomerWrapper pwrapper :listwrapper){  
                 if(pwrapper.selected==true){
                  accountsetcust.add(pwrapper.AccountId);      
                  pcset.addAll(pwrapper.partcustomer);
                  count++;  
                  }  
                } 
              if(Count==0){
              pgMsg = 'Warning:Select at least one Account';
              ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Error,'Please select Atleast One Checkbox to Notify.');
              ApexPages.addMessage(myMsg); 
              return null;    
             }  
         
             Map<Id,List<Contact>> mapconlist=new Map<Id,List<Contact>>();
             List<Contact> truecontctlist=[Select Id,Name,Email,Account.Name,Is_Portal_User_Active__c,(Select Id,PCRB__c from Access_Setup__r) from Contact where AccountId=:accountsetcust and Is_Portal_User_Active__c =true];
             if(truecontctlist.size()>0){
             for(Contact con:truecontctlist){
                 if(con.Access_Setup__r!=null && con.Access_Setup__r.size()>0 && con.Access_Setup__r[0].PCRB__c==true){
                    if(!mapconlist.containsKey(con.AccountId)){
                        mapconlist.put(con.AccountId,new List<Contact>{con});   
                    }
                    else{
                       mapconlist.get(con.AccountId).add(con);   
                    }                
                   } 
                } 
                if(mapconlist.isEmpty()){
                pgMsg = 'Warning:There is contact found but don"t have access to PCRB application.Please Manually Notify';
                return null;
                }              
             }
             else{
             pgMsg = 'Warning:There is no contact found for this customer in GFV- please send manually';
             ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Error,'Error: No respective contact is present for a particular account to notify.');
             ApexPages.addMessage(myMsg); 
             return null;
             }
        
            List<Contact> contactlist=new List<Contact>();
            for(Id accId:mapconlist.Keyset())
            {
                if(mapconlist.get(accId).size()==1){
                   contactlist.addAll(mapconlist.get(accId));
                }
                else if(mapconlist.get(accId).size()>1){
                   contactlist.addAll(mapconlist.get(accId));   
                }         
            }
            List<Messaging.SingleEmailMessage> emailslist = new List<Messaging.SingleEmailMessage>();    
            
            String Template1 = [SELECT Id FROM EmailTemplate WHERE DeveloperName = 'PCN_Notify_Customer'].Id; 
            String Template2 = [SELECT Id FROM EmailTemplate WHERE DeveloperName = 'PCN_Notify_Customer_with_Question'].Id; 
            List<string> listofemails=new List<String>();
    
                for(Contact con:contactlist){
                    Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                    mail.setSaveAsActivity(false);
                    if(pcneol.Method_to_contrl_discontinued_device_p_n__c!=null){
                    mail.setTemplateId(Template2);
                    }
                    else{
                    mail.setTemplateId(Template1);
                    }               
                    mail.setTargetObjectId(con.Id);    
                    mail.setWhatId(Current_Id);
                    emailslist.add(mail);    
                    
                }
                try{
                
                if(emailslist.size()>0){
                List<Part_Customer_Infomation__c> updatelist=new List<Part_Customer_Infomation__c>();
                 for(String pc: PCMap.KeySet()){
                  if(mapconlist.containsKey(pc)){
                  Boolean IsAccount=AccIdset.Contains(pc)?True:False;
                    for(Part_Customer_Infomation__c p:PCMap.get(pc)){
                     if(IsAccount){  
                      if(p.Select_Checkbox__c!=true ){ 
                        p.Select_Checkbox__c=true;
                            if(p.Release_Date__c == null){
                                  p.Release_Date__c = System.today();
                             }
                       }    
                      } 
                      else{
                      if(p.Ultimate_Customer_Select_Checbox__c!=true ){ 
                        p.Ultimate_Customer_Select_Checbox__c=true; 
                          if(p.Release_Date__c == null){
                               p.Release_Date__c = System.today();
                           } 
                       }  
                      } 
                      updatelist.add(p);              
                     } 
                   } 
                  }
                   if(updatelist.size()>0){
                   Map<Id,Part_Customer_Infomation__c> UpdateMap=new Map<Id,Part_Customer_Infomation__c>();
                   for(Part_Customer_Infomation__c pnew:updatelist){
                    UpdateMap.put(pnew.Id,pnew);
                    }
                    system.debug('UpdateMap.Values()***'+UpdateMap.Values());
                    Update UpdateMap.Values(); 
                   } 
                     
                    Messaging.sendEmail(emailslist);
                    ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Confirm,'Email Has Been Sent Successfully.');
                    ApexPages.addMessage(myMsg); 
                    pgMsg = 'Info:Email Has Been Sent Successfully.';
                    } 
             
                 }
                Catch(Exception e){
                pgMsg = 'Warning: Invalid Email Address for the Contact';
                Database.rollback(sp);
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Error,'Error: Invalid Email Address for the Contact.');
                ApexPages.addMessage(myMsg);
                
                //Adding Code for Exceptional Handling Framework
                PCNEOL_EmaiHandler.ExceptionalHandlingMethod(PCNEOL_PartCustomerController1.class.getName(),'SendtoCustomer()',String.ValueOf(Current_Id),'Error Message='+e.getMessage()+' At Line Number='+e.getLineNumber()+' Stack Trace='+e.getStackTraceString(),e.getTypeName(),e.getCause());
                }
            return null;
      }
    
    
      //Wrapper Class 
      public class PartCustomerWrapper {
        public List<Part_Customer_Infomation__c> partcustomer{get;set;}
        public List<Account_Team_Proxy__c> AcctTeamProxy{get;set;}
        public Map<Id,List<Contact>> AccountIdContactMap1{get;set;}
        public boolean selected{get;set;}
        public String AccountId{get;set;}
        public String AccountName{get;set;}
        public boolean checkflag{get;set;}
        public List<AccountTeamWrapper> ATWrapper{get;set;}
        public boolean mposelected{get;set;}
        public String contactExist{get;set;}
        public boolean acknowledged{get;set;}
        public String releaseDate{get;set;}
        
        public PartCustomerWrapper (String st,List<Part_Customer_Infomation__c> pcinfo,List<Account_Team_Proxy__c> Ateamproxy,String faccount,String Aname,Map<Id,List<Contact>> AccountIdContactMap){
        this.partcustomer=pcinfo;
        this.AcctTeamProxy=Ateamproxy;
        this.AccountId=faccount;
        this.AccountName=Aname;
        this.selected=false;
        Integer countee=0;
         this.AccountIdContactMap1 = AccountIdContactMap;
         this.releaseDate='';
         
       // if(st.equalsignorecase('AccountID')){        
        if(System.Label.MPO_DMEA.Contains(this.AccountId)){
          mposelected=true;
         }
        else{
          mposelected=false;
        }  
       // }
       if(AccountIdContactMap1!=null && AccountIdContactMap1.containsKey(this.AccountId)){
           contactExist = 'Yes';
       }else{
            contactExist = 'No';
       }
        ATWrapper=new List<AccountTeamWrapper>();
        String Tname='';
        if(AcctTeamProxy!=null && AcctTeamProxy.size()>0){
            for(Account_Team_Proxy__c at: AcctTeamProxy){      
             if(at.Team_Role__c!='Customer Engineer'){
             ATWrapper.add(new AccountTeamWrapper(at.Team_Role__c,at.User__r.Name));
             }
             else{
             Tname+=at.User__r.Name+',';
             }
            }
           }
                if(Tname!=''){
                ATWrapper.add(new AccountTeamWrapper('Customer Engineer',Tname));
                }
                 
                for(Part_Customer_Infomation__c p: pcinfo){
                    if(st.EqualsIgnoreCase('AccountID')){
                     if(p.Select_Checkbox__c==false){
                     countee++;
                     }
                    }
                    else{
                     if(p.Ultimate_Customer_Select_Checbox__c==false){
                     countee++;
                     }
                     }
                     if(p.Acknowledged__c==true){
                             acknowledged = true;
                     }else{
                             acknowledged = false;
                     }
                     if(p.Release_Date__c!=null){
                        releaseDate = String.ValueOf(p.Release_Date__c);
                    }
                } 
                if(countee==0){
                checkflag=true;
                }
                else{
                checkflag=false;
                }
              }  
        
         }       
      
             
          public Class AccountTeamWrapper{
           public String TeamRoleCE{get;set;}
           public String UserName{get;set;}
          
          public AccountTeamWrapper(String TRole,String UserR){
           this.TeamRoleCE=TRole;
           this.UserName=UserR;
           }
          }
       public pageReference openPCNEOL(){
                if(!Isportal && accId!=null){
                    List<Account> accList = [SELECT Id,Name from Account where Id =:accId ];
                    List<Part_Customer_Infomation__c> PCIList = new  List<Part_Customer_Infomation__c>();
                    List<Part_Customer_Infomation__c> pciUpdateList = new List<Part_Customer_Infomation__c>();
                    if(!accList.isEmpty() && accList!=null){
                        for(Account acc:accList){ 
                            if(PCMap!=null && PCMap.containsKey(acc.Id)){
                                PCIList = PCMap.get(acc.Id);
                            }
                        }
                    }
                    if(!PCIList.isEmpty() && PCIList!=null){
                        for(Part_Customer_Infomation__c pci:PCIList){
                            if(pci.Select_Checkbox__c){
                           
                                pci.Acknowledged__c = true;
                                 if(!Approval.isLocked(pci.Id)){
                                    pciUpdateList.add(pci);
                                 }
                            }
                        }
                    }
              
                    
                    if(pciUpdateList!=null && !pciUpdateList.isEmpty()){
                        update pciUpdateList;
                    }
                }
                return null;
          }
    
}