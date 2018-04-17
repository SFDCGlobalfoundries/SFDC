trigger SignatoryBIUTrigger on Signatory__c (before insert, before update) 
{
    List<String> contactIds = new List<String>();
    Map<String,Contact> contactMap = new Map<String,Contact>();    
    
    List<String> accountIds = new List<String>();
    Map<String,Account> accountMap = new Map<String,Account>();    
   
    List<Signatory__c> lstSing = new List<Signatory__c>();
    
    List<String> agreementIds= new List<String>();
       Map<String,Apttus__APTS_Agreement__c> agreementMap = new Map<String,Apttus__APTS_Agreement__c>();    
    
    for(Signatory__c sig : Trigger.NEW)
    {
       if(sig.Status__c == 'Activated' || sig.Status__c == 'Terminated') { return;}
       
       if(sig.Contact__c != null){ contactIds.add(sig.Contact__c); }
       if(sig.Account__c != null){ accountIds.add(sig.Account__c); }
       if(sig.Agreement__c != null){ agreementIds.add(sig.Agreement__c); }
    }
    
    //QUERY FOR CONTACT WITH FULL INFORMATION    
    List<Contact> contacts = [select Id, FirstName, LastName, Title,Email,
                              MailingStreet, MailingCity, MailingState, MailingPostalCode, MailingCountry
                              from Contact where id in :contactIds]; 
    System.debug('Contacts List' +  contacts);
                             
    //QUERY FOR ACCOUNT WITH FULL INFORMATION                           
    List<Account> accounts = [select Id, Name,
                              Corporate_Address_1__c, Corporate_Address_2__c,Corporate_Address_3__c,Corporate_Address_4__c,Corporate_City__c, Corporate_State__c, Corporate_Postal_Zip_Code__c, Corporate_Country__c
                              from Account where id in :accountIds];                              
    
    List<Apttus__APTS_Agreement__c> agreements = [select Geometries__c from Apttus__APTS_Agreement__c where id in :agreementIds];
    
    System.debug('Account List' +  accounts); 
    System.debug('Agreements List' +  agreements );                            
    
    for(Contact c:contacts){ contactMap.put(c.id,c); } 
    for(Account a:accounts){ accountMap.put(a.id,a); }
    // this is for Tech Geomteris 
    for(Apttus__APTS_Agreement__c ag:agreements ){ agreementMap.put(ag.id,ag); }
    
    Contact ctct = null;
    Account acct = null;   
    Apttus__APTS_Agreement__c agmnt  = null;
  
 
    for(Signatory__c sig : Trigger.NEW)
    {
       ctct = (sig.Contact__c != null)?contactMap.get(sig.Contact__c):null; 
       acct = (sig.Account__c != null)?accountMap.get(sig.Account__c):null;   
       agmnt= (sig.Agreement__c != null) ? agreementMap.get(sig.Agreement__c):null;
       
       //AUTO FILL CONTACT INFO
       if(ctct != null)
       {
           if((ctct.FirstName != null)||(ctct.FirstName != null))
           {
               sig.First_Name__c = ctct.FirstName;
               sig.Last_Name__c = ctct.LastName;
               System.debug('Contact Full Name' + sig.First_Name__c + sig.Last_Name__c);
           } 
           if(ctct.Title != null)
           {
             sig.Contact_Title__c = ctct.Title;
           }        
           
           if(ctct.Email != null)
           {
              sig.Email__c = ctct.Email;  
           }        
           
           if(ctct.MailingStreet != null)
           {
              sig.Street__c = ctct.MailingStreet;
              sig.City__c = ctct.MailingCity;
              sig.State__c = ctct.MailingState;
              sig.Postal_Code__c = ctct.MailingPostalCode;
              sig.Country__c = ctct.MailingCountry; 
           }     
     
       }
       
       //AUTO FILL ACCOUNT INFO
       if(acct != null)
       {
           if(acct.Name != null)
           {
              sig.Account_Name__c = acct.Name;
              System.debug('Account Name' + sig.Account_Name__c );
           }
           if(acct.Corporate_Address_1__c != null)
           {
              sig.Account_Street__c = acct.Corporate_Address_1__c;
              sig.Account_Street_2__c = acct.Corporate_Address_2__c;
              sig.Account_Street_3__c = acct.Corporate_Address_3__c;
              sig.Account_Street_4__c = acct.Corporate_Address_4__c;
              sig.Account_City__c = acct.Corporate_City__c;
              sig.Account_State__c = acct.Corporate_State__c;
              sig.Account_Postal_Code__c = acct.Corporate_Postal_Zip_Code__c;
              sig.Account_Country__c = acct.Corporate_Country__c; 
           } 
       }
       
     if(agmnt != null){
      sig.Geometries__c = agmnt.Geometries__c;
      } 
     
       System.debug('Signatory List' +  sig);     
    }
  
  /*   try{
    if(lstSing.size() > 0 && Trigger.isUpdate) 
          update lstSing;
     }
    catch (Exception e){
    
    for(Signatory__c s : lstSing)    {      
    s.addError('The following exception has occurred: ' + e.getMessage());
    System.debug('The following exception has occurred: ' + e.getMessage());    }  
   
    } */           
  
}