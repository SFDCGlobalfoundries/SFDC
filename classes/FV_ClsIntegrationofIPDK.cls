/*
Company      : Cognizant
Name         : FV_ClsIntegrationofIPDK 
Author       : Sunita
Created Date : 7-Nov-2014
Reason: Case 34665 - IPDK enhancement

……..
 */


global class FV_ClsIntegrationofIPDK 
{
  
 // webService static List<String> integrateIPDK(String DocNumber) 
  webService static String integrateIPDK(String DocNumber) 
  { 
    List<String> accshortNamelst;
    List<IPDK_License_Information__c> licenseInformationList;
      
     String str='';
    try {  
           system.debug('DocNumber$$'+DocNumber);
           licenseInformationList =new List<IPDK_License_Information__c>();
           accshortNamelst =new List<String>();    
           Set<id> setofDsIds=new Set<Id>();
           
           List<Design_Spec__c> lstDS=[Select id,Name,Revision__c 
                                       from Design_Spec__c 
                                       where Name=:DocNumber 
                                       order by Revision__c desc limit 1];
          
           system.debug('lstDS$$'+lstDS);
           
           if(lstDS<>Null &&!lstDS.isEmpty())
           {
               for(Design_Spec__c dspbj :lstDS)
               {
                   setofDsIds.add(dspbj.id);
               }
           }
           system.debug('setofDsIds$$'+setofDsIds);
           if (setofDsIds<>Null && !setofDsIds.isEmpty()){    
               licenseInformationList =[select id,Specification__c,Account__c,Account__r.Short_Name__c 
                                        from IPDK_License_Information__c 
                                        where Specification__c in:setofDsIds];
           }
           system.debug('licenseInformationList $$'+licenseInformationList );
           if(licenseInformationList!=null && !licenseInformationList.isEmpty())
           {
               for(IPDK_License_Information__c obj : licenseInformationList)
               {
                accshortNamelst.add(obj.Account__r.Short_Name__c);
 /*------------------added------------------------*/               
                if(str=='')
                {
                str=obj.Account__r.Short_Name__c;
                }
                else
                {
                str=obj.Account__r.Short_Name__c+','+str;
                }
 /*------------------added------------------------*/                
               }
           }    
           system.debug('accshortNamelst$$$'+accshortNamelst);
           
      } catch (Exception e){
            system.debug('Exception >>>>>>>>'+e.getMessage());      
      }    
     // return accshortNamelst;
     return str;
    }
}