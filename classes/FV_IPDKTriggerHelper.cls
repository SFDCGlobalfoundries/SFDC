/*
*   Author: Dinesh Suggala
*   Description:  This is helper class which called from FV_IPDKTrigger
    Modified Date: 29/1/2018
*   History: 
*     
*/
public Class FV_IPDKTriggerHelper{

   public static void AATriggerEmailtoFAE(List<IPDK_License_Information__c> ipdklist){
   
   Map<String,IPDK_License_Information__c> AASpecAccMap=new Map<String,IPDK_License_Information__c>();
   Map<String,List<IPDK_License_Information__c>> DPOwnerMap=new Map<String,List<IPDK_License_Information__c>>();
   Set<Id> ASpecSet=new Set<Id>();
   
   for(IPDK_License_Information__c ipdk:[Select Id,Specification__c,Account__c from IPDK_License_Information__c  where Id=:ipdklist]){
    AASpecAccMap.put(ipdk.Specification__c+'-'+ipdk.Account__c,ipdk);  
    ASpecSet.add(ipdk.Specification__c);
    }
   
   
   String sregion='';
   for(Document_Provisioning__c dp:[Select Id,Design_Spec__c,AccountID__c,BE_Region__c,BE_Requestor__c,Is_BE_Required__c from Document_Provisioning__c where Design_Spec__c=:ASpecSet and RecordType.Name='IP DK Record Type' and Is_BE_Required__c='Yes']){    
   if(AASpecAccMap.Containskey(dp.Design_Spec__c+'-'+dp.AccountID__c )){
    if(!DPOwnerMap.ContainsKey(dp.BE_Requestor__c)){
     DPOwnerMap.put(dp.BE_Requestor__c,new List<IPDK_License_Information__c>{AASpecAccMap.get(dp.Design_Spec__c+'-'+dp.AccountID__c)});
     sregion=dp.BE_Region__c;   
     
    }
    else{
     DPOwnerMap.get(dp.BE_Requestor__c).add(AASpecAccMap.get(dp.Design_Spec__c+'-'+dp.AccountID__c)); 
     } 
    }
   }
   
   List<String> slist=new List<String>();
    if(sregion!='' && sregion!=null && !String.isBlank(sregion)){
     for(String backEnd :IPDK_BackEndRegionKit__c.getInstance(sregion).Federation_ID__c.split(',')){
     slist.add(backEnd);
     }
    }
    
   //Custom Setting to fetch gfv email
     IPDK_Constant__c pc=IPDK_Constant__c.getInstance('DoNotReplyEmail');
     String dontreplymail=pc.Value__c;
   
   List<String> toaddresslist = new List<String>();
        for(User user:[Select Id,Name,Email,HCM_Login_ID__c From User Where  IsActive =true AND FederationIdentifier IN :slist]){
           toaddresslist.add(user.Email);
           toaddresslist.add(dontreplymail);
        } 
   
   List<Messaging.SingleEmailMessage> emaillist = new List<Messaging.SingleEmailMessage>();
   List<EmailTemplate> template = [SELECT Id,Name,DeveloperName,HtmlValue FROM EmailTemplate WHERE DeveloperName='IPDK_AA_Creation_Notify_Email'];
   for(String s: DPOwnerMap.KeySet()){
    for(IPDK_License_Information__c ipdklicense: DPOwnerMap.get(s)){  
    
    Messaging.SingleEmailMessage email=new Messaging.SingleEmailMessage();
    email.setTargetObjectId(s);
    email.setWhatId(ipdklicense.id);   
    email.setTemplateId(template[0].Id);
    email.setCCAddresses(toaddresslist);
    email.setSaveAsActivity(false);
    
    emaillist.add(email);   
    }
   }

   try{
   if(emaillist.size()>0){
    Messaging.SendEmail(emaillist); 
    }
   }
   Catch(Exception e){
    for(Integer i = 0; i < e.getNumDml(); i++) {
        // Process exception here
        GlobalUtility.logMessage('Error','FV_IPDKTriggerHelper','PDK Provisioning','',e.getDmlMessage(i),String.valueof(e.getMessage()),'','PDK Provisioning',e,0);
        System.debug(e.getDmlMessage(i)); 
      }
   }
 
 }
}