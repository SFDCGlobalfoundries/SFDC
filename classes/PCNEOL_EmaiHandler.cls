/***************************************************************************************************************************
Class:         PCNEOL_EmaiHandler 
----------------------------------------------------------------------------------------------------------------------------
Author:        Dinesh M Suggala
Created Date:  11/7/2016
Reason:        This Class is used to send emails to Customer on 30/60/90 days based on Time trigger where as another method SendPrimary 
               is used to Send email to Primary FAE,Primary Account Manager and Primary CSR.

Change Log:    Created     -     Dinesh     -     11/7/2016
               Updated     -     Dinesh     -     5th May 2017
               Reason      -     Added the 3rd point in the body of the Email template at line #131. 
***************************************************************************************************************************/
public class PCNEOL_EmaiHandler {
public static void sendTriggerEmail (PCN_EOL__c pcneol){
     List<string> listofemails=new List<String>();
     List<string>  listofCc = new List<String>();
     set<String> accset=new set<String>();
     Map<String,String> AccMap=new Map<String,String>();
     List<Part_Customer_Infomation__c> partcustomerinfo = [Select Id,Name,Account__c,Account__r.Name,Ultimate_Customer_Account__r.Name,Select_Checkbox__c,End_Of_Life__c,End_Of_Life__r.Last_Order_Date__c,End_Of_Life__r.EOL_Stage__c,IBM_Part_Number__c,Shipment_Line_Internal__r.Cust_Part_Num__c ,Shipment_Line_Internal__c,Account__r.Short_Name__c,
      Ultimate_Customer_Account__c from Part_Customer_Infomation__c  where End_Of_Life__c=:pcneol.Id]; 
      system.debug('partcustomerinfo%%%'+partcustomerinfo);
       for(Part_Customer_Infomation__c pc:partcustomerinfo)
            {
            if(pc.Select_Checkbox__c==true)
            {
             accset.add(pc.Account__c); 
            }               
            }     
    
       for(Account_Team_Proxy__c a:[Select User__r.Name,User__r.Email,Team_Role__c,Account__c from Account_Team_Proxy__c where Account__c IN: accset and (Team_Role__c='Primary Account Manager' or Team_Role__c='Customer Engineer' or Team_Role__c='Primary Customer Service Rep' or Team_Role__c='Primary Field Application Engineer')]){
           listofCc.add(a.User__r.Email);
       }
      Map<Id,List<Contact>> mapconlist=new Map<Id,List<Contact>>();
      List<Contact> truecontctlist =[Select Id,Name,Email,Account.Name,Is_Portal_User_Active__c,(Select Id,PCRB__c from Access_Setup__r) from Contact where AccountId=:accset and Is_Portal_User_Active__c =true];
    system.debug('truecontctlist%%%'+truecontctlist);
    if(truecontctlist.size()>0){
        for(Contact con:truecontctlist){
            
             for(Portal_Tab_Access__c pta:con.Access_Setup__r){
               if(pta.PCRB__c==true){  
                if(!mapconlist.containsKey(con.AccountId)){
                    mapconlist.put(con.AccountId,new List<Contact>{con});   
                }
                else{
                   mapconlist.get(con.AccountId).add(con);   
                }   
             }
          }
            
       }
        
    }
     List<Contact> contactlist=new List<Contact>();
    If(mapconlist.size()>0)
         for(Id accId:mapconlist.Keyset())
        {
            if(mapconlist.get(accId).size()==1){
               contactlist.addAll(mapconlist.get(accId));
            }
            else if(mapconlist.get(accId).size()>1){
               contactlist.add(mapconlist.get(accId)[0]);   
            } 
         }
     String Template1 = [SELECT Id FROM EmailTemplate WHERE DeveloperName = 'PCN_Notify_Customer'].Id; 
     String Template2 = [SELECT Id FROM EmailTemplate WHERE DeveloperName = 'PCN_Notify_Customer_with_Question'].Id; 
    List<Messaging.SingleEmailMessage> emailslist = new List<Messaging.SingleEmailMessage>();
    
    If(contactlist.size()>0)  
      system.debug('contactlist%%%'+contactlist);  
     //ClientPath Emails
    for(Contact con:contactlist){
                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                 listofemails.add(con.Email);
              //set the email properties
                mail.setSaveAsActivity(false);
                if(pcneol.LODNotify1__c==true){
                mail.setTemplateId(Template1);
                }
                If(pcneol.LODNotify2__c==true){
                mail.setTemplateId(Template2);
                }
                If(pcneol.LODNotify3__c==true){
                mail.setTemplateId(Template1);
                }
                mail.setTargetObjectId(con.Id);    
                mail.setWhatId(pcneol.Id);
                mail.setToAddresses(listofemails);             
                emailslist.add(mail);   
        }
    system.debug('emailslist&&&'+emailslist);
           //send the email
         try{
          if(emailslist.size()>0)
        Messaging.sendEmail(emailslist);             
         }
    Catch(Exception e){
       
        ExceptionalHandlingMethod(PCNEOL_EmaiHandler.class.getName(),'sendTriggerEmail()',String.ValueOf(pcneol.Id),'Error Message='+e.getMessage()+' At Line Number='+e.getLineNumber()+' Stack Trace='+e.getStackTraceString(),e.getTypeName(),e.getCause());
        }
  }
          
          
          //Added by Dinesh
         //This method is used to send an Email to All primarys for the Account when Stage changes to Awaiting BU Program Mgr Approval.
          public Static void SendEmailtoPrimarys(PCN_EOL__c pcneol){
          
          set<String> setoftomails=new set<String>();
          List<string>  listoftomails = new List<String>();
          set<String> accset=new set<String>();
     
          List<Part_Customer_Infomation__c> partcustomerinfo = [Select Id,Name,Account__c,Account__r.Name,Ultimate_Customer_Account__r.Name,Select_Checkbox__c,End_Of_Life__c,IBM_Part_Number__c,Shipment_Line__r.Cust_Part_Num__c ,Shipment_Line__c,Ultimate_Customer_Account__c from Part_Customer_Infomation__c  where End_Of_Life__c =:pcneol.Id];  
    
           for(Part_Customer_Infomation__c pc:partcustomerinfo)
            {
             accset.add(pc.Account__c); 
            }               
    
           for(Account_Team_Proxy__c a:[Select User__r.Name,User__r.Email,Team_Role__c,Account__c from Account_Team_Proxy__c where Account__c IN: accset and (Team_Role__c='Primary Account Manager' or Team_Role__c='Primary Customer Service Rep' or Team_Role__c='Primary Field Application Engineer')]){
             setoftomails.add(a.User__r.Email);
             
           }
           listoftomails.addAll(setoftomails);
           List<Messaging.SingleEmailMessage> emailslist = new List<Messaging.SingleEmailMessage>();   
           if(listoftomails.size()>0){
           List<EmailTemplate> template = [SELECT Id,Name,DeveloperName,HtmlValue FROM EmailTemplate WHERE DeveloperName='PCN_Notify_Admin_with_Customer_Comment'];
           String htmlval = '' + template[0].HtmlValue + '';
           htmlval +='<br/>Hi Account Team,<br/><br/>Your customer will be affected and is pending notification of the End of Life (EOL) '+pcneol.PCN_Numbers__c+'.Please click the below link to view the EOL PCN in SalesForce';
           htmlval +='<br/><br/>Instructions:';
           htmlval +='<br/><br/><a href="'+URL.getSalesforceBaseUrl().toExternalForm()+'/'+pcneol.Id+'">1.Please click the link to view the EOL PCN in SalesForce</a>';
           htmlval +='<br/>2.Review the PCN.';
           htmlval +='<br/>3.Notify your customer as desired, complete this task by selecting the check box and clicking the "Notify Customer" button.';
           htmlval +='<br/>4.If you have any questions about the EOL, please contact the Originator.<br/><br/>';
           htmlval +='<br/><br/>Thank You,<br/>Global Foundries<br/><br/>';
           String Subject='';
           Subject +='EOL '+pcneol.PCN_Numbers__c+' entitled “Title of PCN” - Notification';
           Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
       
                mail.setSaveAsActivity(false);
                mail.setTemplateId(template[0].Id);
                mail.setSubject(Subject);   
                mail.setHtmlBody(htmlval);
                mail.setToAddresses(listoftomails);        
                emailslist.add(mail);   
        }
           //send the email
            try{
            if(emailslist.size()>0){
             Messaging.sendEmail(emailslist);
              }
           }
            Catch(Exception e){
            ExceptionalHandlingMethod(PCNEOL_EmaiHandler.class.getName(),'SendEmailtoPrimarys()',String.ValueOf(pcneol.Id),'Error Message='+e.getMessage()+' At Line Number='+e.getLineNumber()+' Stack Trace='+e.getStackTraceString(),e.getTypeName(),e.getCause());
            }
   }
   
       // Adding Method for ExceptionalHandling Framework
        public Static void ExceptionalHandlingMethod(String SourceName,String SourceFunctionName,String Obj, String logMessageT,String logCodeT,Exception exT){
      
          ApplicationLogWrapper alw=new ApplicationLogWrapper();
          alw.source = SourceName;
          alw.sourceFunction =SourceFunctionName;
          alw.ApplicationName='End of Life PCN';
          alw.referenceId =Obj;
          alw.referenceInfo='PCN';
          alw.logMessage =logMessageT;
          alw.debugLevel ='Error';
          alw.logCode =logCodeT;
          alw.ex=exT;
          GlobalUtility.logMessage(alw);
      }
}