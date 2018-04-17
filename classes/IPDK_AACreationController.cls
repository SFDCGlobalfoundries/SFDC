/*
*   Author: Global Foundries (Dinesh Suggala)
*   Description:  This Controller Class is used for Visualforce Component "AA Creation Notify Email"
    Created Date: 04/2/2018
*   History: 
*     
*/
global class IPDK_AACreationController {

  global String  accessipdkId{get;set;}
  global String accessipdkspecId{get;set;}
  global String accessipdkaccid{get;set;}
                                            
   global String requestor{
        get{
            List<Document_Provisioning__c> lstDP = [Select Id,Name,BE_Requestor__r.Name,AccountID__c
                                             From Document_Provisioning__c
                                             Where Design_Spec__c =:accessipdkspecId and AccountID__c=:accessipdkaccid];
                                                                     
            if(lstDP !=null && !lstDP.isEmpty()){
               return lstDP[0].BE_Requestor__r.Name; 
            }
            return '';
        }
        set;
    }                                          
    
}